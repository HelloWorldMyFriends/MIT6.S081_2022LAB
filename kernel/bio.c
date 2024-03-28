// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBKT 13
#define HASH(x) ((x) % NBKT)

extern uint ticks;

struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  // struct buf head;
  struct spinlock headlock[NBKT];
  struct buf head[NBKT];
} bcache;





void
binit(void) 
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create hash backets of buffers
  for(int i = 0; i < NBKT; ++i){
    initlock(&bcache.headlock[i], "bcache");
    bcache.head[i].next = &bcache.head[i];
    bcache.head[i].prev = &bcache.head[i];
  }
  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf + NBUF; b++){
    b->next = bcache.head[0].next;
    b->prev = &bcache.head[0];
    initsleeplock(&b->lock, "buffer");
    bcache.head[0].next->prev = b;
    bcache.head[0].next = b;
  }

  
}


// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)  
{
  struct buf *b, *b2 = 0;
  int id = HASH(blockno); //index of hash backets
  int min_ticks = 0;
  acquire(&bcache.headlock[id]);  //TODO

  // Is the block already cached?
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.headlock[id]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  release(&bcache.headlock[id]);

  acquire(&bcache.lock);
  acquire(&bcache.headlock[id]);  
  
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){  
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.headlock[id]);
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }

  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    if((b->refcnt == 0) && (b->lastuse < min_ticks)){
      b2 = b;
      min_ticks = b->lastuse;
    }
  }

  if(b2){ // if find block in the hash idx, return it 
    b2->dev = dev;
    b2->blockno = blockno;
    b2->valid = 0;
    b2->refcnt = 1;
    b2->next = 0;
    release(&bcache.headlock[id]);
    release(&bcache.lock);
    acquiresleep(&b2->lock);
    return b2;
  }   

  // steal block from other hash idx
  for(int j = 0; j < NBKT; j++){  // efficient
  // for(int j = HASH(id + 1); j != id; j = HASH(j + 1)){ // not so
  
    if(j == id){
      continue;
    }

    acquire(&bcache.headlock[j]);
    for(b = bcache.head[j].next; b != &bcache.head[j]; b = b->next){
      if((b->refcnt == 0) && ((b2 == 0) || (b->lastuse < min_ticks))){
        b2 = b;
        min_ticks = b->lastuse;
      }
    }
      
    if(b2){ 
      b2->dev = dev;
      b2->blockno = blockno;
      b2->valid = 0;
      b2->refcnt = 1;
      b2->next->prev = b2->prev;
      b2->prev->next = b2->next;
      release(&bcache.headlock[j]);   // 上面两句已经切断了head[j]中b2的前后依赖,
                                      // 所以后面的代码跟head[j]已经没关系了,故release lock
      b2->next = bcache.head[id].next;
      b2->prev = &bcache.head[id];
      bcache.head[id].next->prev = b2;
      bcache.head[id].next = b2;
      release(&bcache.headlock[id]);
      release(&bcache.lock);
      acquiresleep(&b2->lock);
      return b2;
    }
    release(&bcache.headlock[j]);
  }
  release(&bcache.headlock[id]);
  release(&bcache.lock);
  panic("bget: no buffers");
  
}


// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);

  int id = HASH(b->blockno);
  acquire(&bcache.headlock[id]);
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->lastuse = ticks;
  }
  release(&bcache.headlock[id]);
}

void
bpin(struct buf *b) {
  int id = HASH(b->blockno);;
  acquire(&bcache.headlock[id]);
  b->refcnt++;
  release(&bcache.headlock[id]);
}

void
bunpin(struct buf *b) {
  int id = HASH(b->blockno);;
  acquire(&bcache.headlock[id]);
  b->refcnt--;
  release(&bcache.headlock[id]);
}


