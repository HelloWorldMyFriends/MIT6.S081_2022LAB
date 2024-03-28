// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct kmem{
  struct spinlock lock;
  struct run *freelist;
};

struct kmem kmems[NCPU];

void
kinit()
{
  for(int i = 0; i < NCPU; ++i){
    initlock(&kmems[i].lock, "kmem");
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  push_off();
  int id = cpuid();
  acquire(&kmems[id].lock);
  r->next = kmems[id].freelist;
  kmems[id].freelist = r;  
  release(&kmems[id].lock);
  pop_off();
}

// int kalloc_i;

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  push_off();
  int id = cpuid();
  pop_off();
  acquire(&kmems[id].lock);
  r = kmems[id].freelist;
  if(r){
    kmems[id].freelist = r->next;
  } else {  
  // now cpu's freelist is null, so we should acquie 
  // other cpu's lock and steal parts of free list 
    for(int kalloc_i = 0; ; kalloc_i = (kalloc_i + 1) % NCPU){  //TODO
      if(id == kalloc_i){
        continue;
      }
      acquire(&kmems[kalloc_i].lock);
      if(!kmems[kalloc_i].freelist){
        release(&kmems[kalloc_i].lock);
        continue;
      }
      r = kmems[kalloc_i].freelist;
      kmems[kalloc_i].freelist = r->next;
      release(&kmems[kalloc_i].lock);
      break;
    }
  }
  release(&kmems[id].lock);
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}

// void *
// kalloc(void)
// {
//   struct run *r;

//   push_off();

//   int cpu = cpuid();

//   acquire(&kmems[cpu].lock);

//   if(!kmems[cpu].freelist) { // no page left for this cpu
//     int steal_left = 64; // steal 64 pages from other cpu(s)
//     for(int i=0;i<NCPU;i++) {
//       if(i == cpu) continue; // no self-robbery
//       acquire(&kmems[i].lock);
//       struct run *rr = kmems[i].freelist;
//       while(rr && steal_left) {
//         kmems[i].freelist = rr->next;
//         rr->next = kmems[cpu].freelist;
//         kmems[cpu].freelist = rr;
//         rr = kmems[i].freelist;
//         steal_left--;
//       }
//       release(&kmems[i].lock);
//       if(steal_left == 0) break; // done stealing
//     }
//   }

//   r = kmems[cpu].freelist;
//   if(r)
//     kmems[cpu].freelist = r->next;
//   release(&kmems[cpu].lock);

//   pop_off();

//   if(r)
//     memset((char*)r, 5, PGSIZE); // fill with junk
//   return (void*)r;
// }