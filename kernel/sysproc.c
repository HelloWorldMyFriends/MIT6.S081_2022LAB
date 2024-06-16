#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "fcntl.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//TODO
uint64 
sys_mmap(void){
  int length, prot, flags, fd, offset;
  argint(1, &length);
  argint(2, &prot);
  argint(3, &flags); 
  argint(4, &fd);
  argint(5, &offset);

  struct proc *p = myproc();
  if(p->mmap_addr - p->sz < p->sz)  //判断是否有足够空间
    return -1;
  if(flags & MAP_SHARED){
    if((prot & PROT_READ) && !p->ofile[fd]->readable)
      return -1;
    if((prot & PROT_WRITE) && !p->ofile[fd]->writable)
      return -1;    
  }
  p->vma[p->vma_size].addr = p->mmap_addr - p->sz;
  p->vma[p->vma_size].sz = length;
  p->vma[p->vma_size].prot = prot;
  p->vma[p->vma_size].flags = flags;
  p->vma[p->vma_size].file = p->ofile[fd];
  p->vma[p->vma_size].offset = offset;
  p->mmap_addr = p->vma[p->vma_size].addr;
  p->vma_size++;
  filedup(p->ofile[fd]);
  return p->mmap_addr;
}

uint64
sys_munmap(void){
  uint64 addr;
  int length;
  argaddr(0, &addr);
  argint(1, &length);
  struct proc* p = myproc();
  for(int i = 0; i < p->vma_size; ++i){
    if(p->vma[i].addr == addr){
      uint64 unmapsz = (p->vma[i].sz <= length ? p->vma[i].sz : length);
      if(p->vma[i].flags & MAP_SHARED){
        begin_op();
        ilock(p->vma[i].file->ip);
        writei(p->vma[i].file->ip, 1, addr, p->vma[i].offset, unmapsz);
        iunlock(p->vma[i].file->ip);
        end_op();
      }
      uvmunmap(p->pagetable, addr, unmapsz/PGSIZE, 1);
      length -= unmapsz;
      addr += unmapsz;
      p->vma[i].offset += unmapsz;
      p->vma[i].sz -= unmapsz;
      p->vma[i].addr += unmapsz;
      if(p->vma[i].sz == 0)
        fileclose(p->vma[i].file);
      if(length == 0)
        break;
    }
  }
  return 0;
}