
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	031050ef          	jal	ra,80005846 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fa078793          	addi	a5,a5,-96 # 80021fd0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	91090913          	addi	s2,s2,-1776 # 80008960 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1d4080e7          	jalr	468(ra) # 8000622e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	274080e7          	jalr	628(ra) # 800062e2 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c6c080e7          	jalr	-916(ra) # 80005cf6 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	87250513          	addi	a0,a0,-1934 # 80008960 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0a8080e7          	jalr	168(ra) # 8000619e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	ece50513          	addi	a0,a0,-306 # 80021fd0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	83c48493          	addi	s1,s1,-1988 # 80008960 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	100080e7          	jalr	256(ra) # 8000622e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	82450513          	addi	a0,a0,-2012 # 80008960 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	19c080e7          	jalr	412(ra) # 800062e2 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00008517          	auipc	a0,0x8
    8000016c:	7f850513          	addi	a0,a0,2040 # 80008960 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	172080e7          	jalr	370(ra) # 800062e2 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd031>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	87aa                	mv	a5,a0
    8000028e:	86b2                	mv	a3,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	00d05963          	blez	a3,800002a4 <strncpy+0x1e>
    80000296:	0785                	addi	a5,a5,1
    80000298:	0005c703          	lbu	a4,0(a1)
    8000029c:	fee78fa3          	sb	a4,-1(a5)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f775                	bnez	a4,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	873e                	mv	a4,a5
    800002a6:	9fb5                	addw	a5,a5,a3
    800002a8:	37fd                	addiw	a5,a5,-1
    800002aa:	00c05963          	blez	a2,800002bc <strncpy+0x36>
    *s++ = 0;
    800002ae:	0705                	addi	a4,a4,1
    800002b0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002b4:	40e786bb          	subw	a3,a5,a4
    800002b8:	fed04be3          	bgtz	a3,800002ae <strncpy+0x28>
  return os;
}
    800002bc:	6422                	ld	s0,8(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e422                	sd	s0,8(sp)
    800002c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c8:	02c05363          	blez	a2,800002ee <safestrcpy+0x2c>
    800002cc:	fff6069b          	addiw	a3,a2,-1
    800002d0:	1682                	slli	a3,a3,0x20
    800002d2:	9281                	srli	a3,a3,0x20
    800002d4:	96ae                	add	a3,a3,a1
    800002d6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d8:	00d58963          	beq	a1,a3,800002ea <safestrcpy+0x28>
    800002dc:	0585                	addi	a1,a1,1
    800002de:	0785                	addi	a5,a5,1
    800002e0:	fff5c703          	lbu	a4,-1(a1)
    800002e4:	fee78fa3          	sb	a4,-1(a5)
    800002e8:	fb65                	bnez	a4,800002d8 <safestrcpy+0x16>
    ;
  *s = 0;
    800002ea:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ee:	6422                	ld	s0,8(sp)
    800002f0:	0141                	addi	sp,sp,16
    800002f2:	8082                	ret

00000000800002f4 <strlen>:

int
strlen(const char *s)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fa:	00054783          	lbu	a5,0(a0)
    800002fe:	cf91                	beqz	a5,8000031a <strlen+0x26>
    80000300:	0505                	addi	a0,a0,1
    80000302:	87aa                	mv	a5,a0
    80000304:	86be                	mv	a3,a5
    80000306:	0785                	addi	a5,a5,1
    80000308:	fff7c703          	lbu	a4,-1(a5)
    8000030c:	ff65                	bnez	a4,80000304 <strlen+0x10>
    8000030e:	40a6853b          	subw	a0,a3,a0
    80000312:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031a:	4501                	li	a0,0
    8000031c:	bfe5                	j	80000314 <strlen+0x20>

000000008000031e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000031e:	1141                	addi	sp,sp,-16
    80000320:	e406                	sd	ra,8(sp)
    80000322:	e022                	sd	s0,0(sp)
    80000324:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000326:	00001097          	auipc	ra,0x1
    8000032a:	bf6080e7          	jalr	-1034(ra) # 80000f1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	60270713          	addi	a4,a4,1538 # 80008930 <started>
  if(cpuid() == 0){
    80000336:	c139                	beqz	a0,8000037c <main+0x5e>
    while(started == 0)
    80000338:	431c                	lw	a5,0(a4)
    8000033a:	2781                	sext.w	a5,a5
    8000033c:	dff5                	beqz	a5,80000338 <main+0x1a>
      ;
    __sync_synchronize();
    8000033e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000342:	00001097          	auipc	ra,0x1
    80000346:	bda080e7          	jalr	-1062(ra) # 80000f1c <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	9ec080e7          	jalr	-1556(ra) # 80005d40 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	930080e7          	jalr	-1744(ra) # 80001c94 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	e94080e7          	jalr	-364(ra) # 80005200 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	178080e7          	jalr	376(ra) # 800014ec <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	88a080e7          	jalr	-1910(ra) # 80005c06 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b9c080e7          	jalr	-1124(ra) # 80005f20 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	9ac080e7          	jalr	-1620(ra) # 80005d40 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	99c080e7          	jalr	-1636(ra) # 80005d40 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	98c080e7          	jalr	-1652(ra) # 80005d40 <printf>
    kinit();         // physical page allocator
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	d22080e7          	jalr	-734(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	326080e7          	jalr	806(ra) # 800006ea <kvminit>
    kvminithart();   // turn on paging
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	068080e7          	jalr	104(ra) # 80000434 <kvminithart>
    procinit();      // process table
    800003d4:	00001097          	auipc	ra,0x1
    800003d8:	a96080e7          	jalr	-1386(ra) # 80000e6a <procinit>
    trapinit();      // trap vectors
    800003dc:	00002097          	auipc	ra,0x2
    800003e0:	890080e7          	jalr	-1904(ra) # 80001c6c <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	8b0080e7          	jalr	-1872(ra) # 80001c94 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	dfe080e7          	jalr	-514(ra) # 800051ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e0c080e7          	jalr	-500(ra) # 80005200 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	fe6080e7          	jalr	-26(ra) # 800023e2 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	684080e7          	jalr	1668(ra) # 80002a88 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	5fa080e7          	jalr	1530(ra) # 80003a06 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	ef4080e7          	jalr	-268(ra) # 80005308 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	eb2080e7          	jalr	-334(ra) # 800012ce <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	50f72323          	sw	a5,1286(a4) # 80008930 <started>
    80000432:	b789                	j	80000374 <main+0x56>

0000000080000434 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e422                	sd	s0,8(sp)
    80000438:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000043e:	00008797          	auipc	a5,0x8
    80000442:	4fa7b783          	ld	a5,1274(a5) # 80008938 <kernel_pagetable>
    80000446:	83b1                	srli	a5,a5,0xc
    80000448:	577d                	li	a4,-1
    8000044a:	177e                	slli	a4,a4,0x3f
    8000044c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045c:	7139                	addi	sp,sp,-64
    8000045e:	fc06                	sd	ra,56(sp)
    80000460:	f822                	sd	s0,48(sp)
    80000462:	f426                	sd	s1,40(sp)
    80000464:	f04a                	sd	s2,32(sp)
    80000466:	ec4e                	sd	s3,24(sp)
    80000468:	e852                	sd	s4,16(sp)
    8000046a:	e456                	sd	s5,8(sp)
    8000046c:	e05a                	sd	s6,0(sp)
    8000046e:	0080                	addi	s0,sp,64
    80000470:	84aa                	mv	s1,a0
    80000472:	89ae                	mv	s3,a1
    80000474:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000476:	57fd                	li	a5,-1
    80000478:	83e9                	srli	a5,a5,0x1a
    8000047a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047e:	04b7f263          	bgeu	a5,a1,800004c2 <walk+0x66>
    panic("walk");
    80000482:	00008517          	auipc	a0,0x8
    80000486:	bce50513          	addi	a0,a0,-1074 # 80008050 <etext+0x50>
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	86c080e7          	jalr	-1940(ra) # 80005cf6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000492:	060a8663          	beqz	s5,800004fe <walk+0xa2>
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	c84080e7          	jalr	-892(ra) # 8000011a <kalloc>
    8000049e:	84aa                	mv	s1,a0
    800004a0:	c529                	beqz	a0,800004ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a2:	6605                	lui	a2,0x1
    800004a4:	4581                	li	a1,0
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	cd4080e7          	jalr	-812(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ae:	00c4d793          	srli	a5,s1,0xc
    800004b2:	07aa                	slli	a5,a5,0xa
    800004b4:	0017e793          	ori	a5,a5,1
    800004b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd027>
    800004be:	036a0063          	beq	s4,s6,800004de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c2:	0149d933          	srl	s2,s3,s4
    800004c6:	1ff97913          	andi	s2,s2,511
    800004ca:	090e                	slli	s2,s2,0x3
    800004cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ce:	00093483          	ld	s1,0(s2)
    800004d2:	0014f793          	andi	a5,s1,1
    800004d6:	dfd5                	beqz	a5,80000492 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d8:	80a9                	srli	s1,s1,0xa
    800004da:	04b2                	slli	s1,s1,0xc
    800004dc:	b7c5                	j	800004bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004de:	00c9d513          	srli	a0,s3,0xc
    800004e2:	1ff57513          	andi	a0,a0,511
    800004e6:	050e                	slli	a0,a0,0x3
    800004e8:	9526                	add	a0,a0,s1
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	74a2                	ld	s1,40(sp)
    800004f0:	7902                	ld	s2,32(sp)
    800004f2:	69e2                	ld	s3,24(sp)
    800004f4:	6a42                	ld	s4,16(sp)
    800004f6:	6aa2                	ld	s5,8(sp)
    800004f8:	6b02                	ld	s6,0(sp)
    800004fa:	6121                	addi	sp,sp,64
    800004fc:	8082                	ret
        return 0;
    800004fe:	4501                	li	a0,0
    80000500:	b7ed                	j	800004ea <walk+0x8e>

0000000080000502 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000502:	57fd                	li	a5,-1
    80000504:	83e9                	srli	a5,a5,0x1a
    80000506:	00b7f463          	bgeu	a5,a1,8000050e <walkaddr+0xc>
    return 0;
    8000050a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050c:	8082                	ret
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e406                	sd	ra,8(sp)
    80000512:	e022                	sd	s0,0(sp)
    80000514:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000516:	4601                	li	a2,0
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	f44080e7          	jalr	-188(ra) # 8000045c <walk>
  if(pte == 0)
    80000520:	c105                	beqz	a0,80000540 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000522:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000524:	0117f693          	andi	a3,a5,17
    80000528:	4745                	li	a4,17
    return 0;
    8000052a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052c:	00e68663          	beq	a3,a4,80000538 <walkaddr+0x36>
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret
  pa = PTE2PA(*pte);
    80000538:	83a9                	srli	a5,a5,0xa
    8000053a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053e:	bfcd                	j	80000530 <walkaddr+0x2e>
    return 0;
    80000540:	4501                	li	a0,0
    80000542:	b7fd                	j	80000530 <walkaddr+0x2e>

0000000080000544 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000544:	715d                	addi	sp,sp,-80
    80000546:	e486                	sd	ra,72(sp)
    80000548:	e0a2                	sd	s0,64(sp)
    8000054a:	fc26                	sd	s1,56(sp)
    8000054c:	f84a                	sd	s2,48(sp)
    8000054e:	f44e                	sd	s3,40(sp)
    80000550:	f052                	sd	s4,32(sp)
    80000552:	ec56                	sd	s5,24(sp)
    80000554:	e85a                	sd	s6,16(sp)
    80000556:	e45e                	sd	s7,8(sp)
    80000558:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055a:	c639                	beqz	a2,800005a8 <mappages+0x64>
    8000055c:	8aaa                	mv	s5,a0
    8000055e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000560:	777d                	lui	a4,0xfffff
    80000562:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000566:	fff58993          	addi	s3,a1,-1
    8000056a:	99b2                	add	s3,s3,a2
    8000056c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000570:	893e                	mv	s2,a5
    80000572:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000576:	6b85                	lui	s7,0x1
    80000578:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057c:	4605                	li	a2,1
    8000057e:	85ca                	mv	a1,s2
    80000580:	8556                	mv	a0,s5
    80000582:	00000097          	auipc	ra,0x0
    80000586:	eda080e7          	jalr	-294(ra) # 8000045c <walk>
    8000058a:	cd1d                	beqz	a0,800005c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000058c:	611c                	ld	a5,0(a0)
    8000058e:	8b85                	andi	a5,a5,1
    80000590:	e785                	bnez	a5,800005b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000592:	80b1                	srli	s1,s1,0xc
    80000594:	04aa                	slli	s1,s1,0xa
    80000596:	0164e4b3          	or	s1,s1,s6
    8000059a:	0014e493          	ori	s1,s1,1
    8000059e:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a0:	05390063          	beq	s2,s3,800005e0 <mappages+0x9c>
    a += PGSIZE;
    800005a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a6:	bfc9                	j	80000578 <mappages+0x34>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	746080e7          	jalr	1862(ra) # 80005cf6 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	736080e7          	jalr	1846(ra) # 80005cf6 <panic>
      return -1;
    800005c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005ca:	60a6                	ld	ra,72(sp)
    800005cc:	6406                	ld	s0,64(sp)
    800005ce:	74e2                	ld	s1,56(sp)
    800005d0:	7942                	ld	s2,48(sp)
    800005d2:	79a2                	ld	s3,40(sp)
    800005d4:	7a02                	ld	s4,32(sp)
    800005d6:	6ae2                	ld	s5,24(sp)
    800005d8:	6b42                	ld	s6,16(sp)
    800005da:	6ba2                	ld	s7,8(sp)
    800005dc:	6161                	addi	sp,sp,80
    800005de:	8082                	ret
  return 0;
    800005e0:	4501                	li	a0,0
    800005e2:	b7e5                	j	800005ca <mappages+0x86>

00000000800005e4 <kvmmap>:
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
    800005ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ee:	86b2                	mv	a3,a2
    800005f0:	863e                	mv	a2,a5
    800005f2:	00000097          	auipc	ra,0x0
    800005f6:	f52080e7          	jalr	-174(ra) # 80000544 <mappages>
    800005fa:	e509                	bnez	a0,80000604 <kvmmap+0x20>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
    panic("kvmmap");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	00005097          	auipc	ra,0x5
    80000610:	6ea080e7          	jalr	1770(ra) # 80005cf6 <panic>

0000000080000614 <kvmmake>:
{
    80000614:	1101                	addi	sp,sp,-32
    80000616:	ec06                	sd	ra,24(sp)
    80000618:	e822                	sd	s0,16(sp)
    8000061a:	e426                	sd	s1,8(sp)
    8000061c:	e04a                	sd	s2,0(sp)
    8000061e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000620:	00000097          	auipc	ra,0x0
    80000624:	afa080e7          	jalr	-1286(ra) # 8000011a <kalloc>
    80000628:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062a:	6605                	lui	a2,0x1
    8000062c:	4581                	li	a1,0
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	b4c080e7          	jalr	-1204(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000636:	4719                	li	a4,6
    80000638:	6685                	lui	a3,0x1
    8000063a:	10000637          	lui	a2,0x10000
    8000063e:	100005b7          	lui	a1,0x10000
    80000642:	8526                	mv	a0,s1
    80000644:	00000097          	auipc	ra,0x0
    80000648:	fa0080e7          	jalr	-96(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10001637          	lui	a2,0x10001
    80000654:	100015b7          	lui	a1,0x10001
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f8a080e7          	jalr	-118(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	004006b7          	lui	a3,0x400
    80000668:	0c000637          	lui	a2,0xc000
    8000066c:	0c0005b7          	lui	a1,0xc000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f72080e7          	jalr	-142(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067a:	00008917          	auipc	s2,0x8
    8000067e:	98690913          	addi	s2,s2,-1658 # 80008000 <etext>
    80000682:	4729                	li	a4,10
    80000684:	80008697          	auipc	a3,0x80008
    80000688:	97c68693          	addi	a3,a3,-1668 # 8000 <_entry-0x7fff8000>
    8000068c:	4605                	li	a2,1
    8000068e:	067e                	slli	a2,a2,0x1f
    80000690:	85b2                	mv	a1,a2
    80000692:	8526                	mv	a0,s1
    80000694:	00000097          	auipc	ra,0x0
    80000698:	f50080e7          	jalr	-176(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069c:	4719                	li	a4,6
    8000069e:	46c5                	li	a3,17
    800006a0:	06ee                	slli	a3,a3,0x1b
    800006a2:	412686b3          	sub	a3,a3,s2
    800006a6:	864a                	mv	a2,s2
    800006a8:	85ca                	mv	a1,s2
    800006aa:	8526                	mv	a0,s1
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	f38080e7          	jalr	-200(ra) # 800005e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b4:	4729                	li	a4,10
    800006b6:	6685                	lui	a3,0x1
    800006b8:	00007617          	auipc	a2,0x7
    800006bc:	94860613          	addi	a2,a2,-1720 # 80007000 <_trampoline>
    800006c0:	040005b7          	lui	a1,0x4000
    800006c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c6:	05b2                	slli	a1,a1,0xc
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f1a080e7          	jalr	-230(ra) # 800005e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	702080e7          	jalr	1794(ra) # 80000dd6 <proc_mapstacks>
}
    800006dc:	8526                	mv	a0,s1
    800006de:	60e2                	ld	ra,24(sp)
    800006e0:	6442                	ld	s0,16(sp)
    800006e2:	64a2                	ld	s1,8(sp)
    800006e4:	6902                	ld	s2,0(sp)
    800006e6:	6105                	addi	sp,sp,32
    800006e8:	8082                	ret

00000000800006ea <kvminit>:
{
    800006ea:	1141                	addi	sp,sp,-16
    800006ec:	e406                	sd	ra,8(sp)
    800006ee:	e022                	sd	s0,0(sp)
    800006f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f22080e7          	jalr	-222(ra) # 80000614 <kvmmake>
    800006fa:	00008797          	auipc	a5,0x8
    800006fe:	22a7bf23          	sd	a0,574(a5) # 80008938 <kernel_pagetable>
}
    80000702:	60a2                	ld	ra,8(sp)
    80000704:	6402                	ld	s0,0(sp)
    80000706:	0141                	addi	sp,sp,16
    80000708:	8082                	ret

000000008000070a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070a:	715d                	addi	sp,sp,-80
    8000070c:	e486                	sd	ra,72(sp)
    8000070e:	e0a2                	sd	s0,64(sp)
    80000710:	fc26                	sd	s1,56(sp)
    80000712:	f84a                	sd	s2,48(sp)
    80000714:	f44e                	sd	s3,40(sp)
    80000716:	f052                	sd	s4,32(sp)
    80000718:	ec56                	sd	s5,24(sp)
    8000071a:	e85a                	sd	s6,16(sp)
    8000071c:	e45e                	sd	s7,8(sp)
    8000071e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000720:	03459793          	slli	a5,a1,0x34
    80000724:	e795                	bnez	a5,80000750 <uvmunmap+0x46>
    80000726:	8a2a                	mv	s4,a0
    80000728:	892e                	mv	s2,a1
    8000072a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072c:	0632                	slli	a2,a2,0xc
    8000072e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000732:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	6b05                	lui	s6,0x1
    80000736:	0735e263          	bltu	a1,s3,8000079a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073a:	60a6                	ld	ra,72(sp)
    8000073c:	6406                	ld	s0,64(sp)
    8000073e:	74e2                	ld	s1,56(sp)
    80000740:	7942                	ld	s2,48(sp)
    80000742:	79a2                	ld	s3,40(sp)
    80000744:	7a02                	ld	s4,32(sp)
    80000746:	6ae2                	ld	s5,24(sp)
    80000748:	6b42                	ld	s6,16(sp)
    8000074a:	6ba2                	ld	s7,8(sp)
    8000074c:	6161                	addi	sp,sp,80
    8000074e:	8082                	ret
    panic("uvmunmap: not aligned");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	93050513          	addi	a0,a0,-1744 # 80008080 <etext+0x80>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	59e080e7          	jalr	1438(ra) # 80005cf6 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	58e080e7          	jalr	1422(ra) # 80005cf6 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	57e080e7          	jalr	1406(ra) # 80005cf6 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	56e080e7          	jalr	1390(ra) # 80005cf6 <panic>
    *pte = 0;
    80000790:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000794:	995a                	add	s2,s2,s6
    80000796:	fb3972e3          	bgeu	s2,s3,8000073a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079a:	4601                	li	a2,0
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8552                	mv	a0,s4
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	cbc080e7          	jalr	-836(ra) # 8000045c <walk>
    800007a8:	84aa                	mv	s1,a0
    800007aa:	d95d                	beqz	a0,80000760 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ac:	6108                	ld	a0,0(a0)
    800007ae:	00157793          	andi	a5,a0,1
    800007b2:	dfdd                	beqz	a5,80000770 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b4:	3ff57793          	andi	a5,a0,1023
    800007b8:	fd7784e3          	beq	a5,s7,80000780 <uvmunmap+0x76>
    if(do_free){
    800007bc:	fc0a8ae3          	beqz	s5,80000790 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c2:	0532                	slli	a0,a0,0xc
    800007c4:	00000097          	auipc	ra,0x0
    800007c8:	858080e7          	jalr	-1960(ra) # 8000001c <kfree>
    800007cc:	b7d1                	j	80000790 <uvmunmap+0x86>

00000000800007ce <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	942080e7          	jalr	-1726(ra) # 8000011a <kalloc>
    800007e0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e2:	c519                	beqz	a0,800007f0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e4:	6605                	lui	a2,0x1
    800007e6:	4581                	li	a1,0
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	992080e7          	jalr	-1646(ra) # 8000017a <memset>
  return pagetable;
}
    800007f0:	8526                	mv	a0,s1
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fc:	7179                	addi	sp,sp,-48
    800007fe:	f406                	sd	ra,40(sp)
    80000800:	f022                	sd	s0,32(sp)
    80000802:	ec26                	sd	s1,24(sp)
    80000804:	e84a                	sd	s2,16(sp)
    80000806:	e44e                	sd	s3,8(sp)
    80000808:	e052                	sd	s4,0(sp)
    8000080a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080c:	6785                	lui	a5,0x1
    8000080e:	04f67863          	bgeu	a2,a5,8000085e <uvmfirst+0x62>
    80000812:	8a2a                	mv	s4,a0
    80000814:	89ae                	mv	s3,a1
    80000816:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	902080e7          	jalr	-1790(ra) # 8000011a <kalloc>
    80000820:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	954080e7          	jalr	-1708(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082e:	4779                	li	a4,30
    80000830:	86ca                	mv	a3,s2
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	8552                	mv	a0,s4
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	d0c080e7          	jalr	-756(ra) # 80000544 <mappages>
  memmove(mem, src, sz);
    80000840:	8626                	mv	a2,s1
    80000842:	85ce                	mv	a1,s3
    80000844:	854a                	mv	a0,s2
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	990080e7          	jalr	-1648(ra) # 800001d6 <memmove>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6a02                	ld	s4,0(sp)
    8000085a:	6145                	addi	sp,sp,48
    8000085c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	87a50513          	addi	a0,a0,-1926 # 800080d8 <etext+0xd8>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	490080e7          	jalr	1168(ra) # 80005cf6 <panic>

000000008000086e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086e:	1101                	addi	sp,sp,-32
    80000870:	ec06                	sd	ra,24(sp)
    80000872:	e822                	sd	s0,16(sp)
    80000874:	e426                	sd	s1,8(sp)
    80000876:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000878:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087a:	00b67d63          	bgeu	a2,a1,80000894 <uvmdealloc+0x26>
    8000087e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000880:	6785                	lui	a5,0x1
    80000882:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000884:	00f60733          	add	a4,a2,a5
    80000888:	76fd                	lui	a3,0xfffff
    8000088a:	8f75                	and	a4,a4,a3
    8000088c:	97ae                	add	a5,a5,a1
    8000088e:	8ff5                	and	a5,a5,a3
    80000890:	00f76863          	bltu	a4,a5,800008a0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000894:	8526                	mv	a0,s1
    80000896:	60e2                	ld	ra,24(sp)
    80000898:	6442                	ld	s0,16(sp)
    8000089a:	64a2                	ld	s1,8(sp)
    8000089c:	6105                	addi	sp,sp,32
    8000089e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a0:	8f99                	sub	a5,a5,a4
    800008a2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a4:	4685                	li	a3,1
    800008a6:	0007861b          	sext.w	a2,a5
    800008aa:	85ba                	mv	a1,a4
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	e5e080e7          	jalr	-418(ra) # 8000070a <uvmunmap>
    800008b4:	b7c5                	j	80000894 <uvmdealloc+0x26>

00000000800008b6 <uvmalloc>:
  if(newsz < oldsz)
    800008b6:	0ab66563          	bltu	a2,a1,80000960 <uvmalloc+0xaa>
{
    800008ba:	7139                	addi	sp,sp,-64
    800008bc:	fc06                	sd	ra,56(sp)
    800008be:	f822                	sd	s0,48(sp)
    800008c0:	f426                	sd	s1,40(sp)
    800008c2:	f04a                	sd	s2,32(sp)
    800008c4:	ec4e                	sd	s3,24(sp)
    800008c6:	e852                	sd	s4,16(sp)
    800008c8:	e456                	sd	s5,8(sp)
    800008ca:	e05a                	sd	s6,0(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f363          	bgeu	s3,a2,80000964 <uvmalloc+0xae>
    800008e2:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c51d                	beqz	a0,80000920 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000900:	875a                	mv	a4,s6
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c3a080e7          	jalr	-966(ra) # 80000544 <mappages>
    80000912:	e90d                	bnez	a0,80000944 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x32>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	a809                	j	80000930 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000920:	864e                	mv	a2,s3
    80000922:	85ca                	mv	a1,s2
    80000924:	8556                	mv	a0,s5
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	f48080e7          	jalr	-184(ra) # 8000086e <uvmdealloc>
      return 0;
    8000092e:	4501                	li	a0,0
}
    80000930:	70e2                	ld	ra,56(sp)
    80000932:	7442                	ld	s0,48(sp)
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
    80000938:	69e2                	ld	s3,24(sp)
    8000093a:	6a42                	ld	s4,16(sp)
    8000093c:	6aa2                	ld	s5,8(sp)
    8000093e:	6b02                	ld	s6,0(sp)
    80000940:	6121                	addi	sp,sp,64
    80000942:	8082                	ret
      kfree(mem);
    80000944:	8526                	mv	a0,s1
    80000946:	fffff097          	auipc	ra,0xfffff
    8000094a:	6d6080e7          	jalr	1750(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f1a080e7          	jalr	-230(ra) # 8000086e <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
    8000095e:	bfc9                	j	80000930 <uvmalloc+0x7a>
    return oldsz;
    80000960:	852e                	mv	a0,a1
}
    80000962:	8082                	ret
  return newsz;
    80000964:	8532                	mv	a0,a2
    80000966:	b7e9                	j	80000930 <uvmalloc+0x7a>

0000000080000968 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000968:	7179                	addi	sp,sp,-48
    8000096a:	f406                	sd	ra,40(sp)
    8000096c:	f022                	sd	s0,32(sp)
    8000096e:	ec26                	sd	s1,24(sp)
    80000970:	e84a                	sd	s2,16(sp)
    80000972:	e44e                	sd	s3,8(sp)
    80000974:	e052                	sd	s4,0(sp)
    80000976:	1800                	addi	s0,sp,48
    80000978:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097a:	84aa                	mv	s1,a0
    8000097c:	6905                	lui	s2,0x1
    8000097e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000980:	4985                	li	s3,1
    80000982:	a829                	j	8000099c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000984:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000986:	00c79513          	slli	a0,a5,0xc
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	fde080e7          	jalr	-34(ra) # 80000968 <freewalk>
      pagetable[i] = 0;
    80000992:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000996:	04a1                	addi	s1,s1,8
    80000998:	03248163          	beq	s1,s2,800009ba <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000099e:	00f7f713          	andi	a4,a5,15
    800009a2:	ff3701e3          	beq	a4,s3,80000984 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a6:	8b85                	andi	a5,a5,1
    800009a8:	d7fd                	beqz	a5,80000996 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009aa:	00007517          	auipc	a0,0x7
    800009ae:	74e50513          	addi	a0,a0,1870 # 800080f8 <etext+0xf8>
    800009b2:	00005097          	auipc	ra,0x5
    800009b6:	344080e7          	jalr	836(ra) # 80005cf6 <panic>
    }
  }
  kfree((void*)pagetable);
    800009ba:	8552                	mv	a0,s4
    800009bc:	fffff097          	auipc	ra,0xfffff
    800009c0:	660080e7          	jalr	1632(ra) # 8000001c <kfree>
}
    800009c4:	70a2                	ld	ra,40(sp)
    800009c6:	7402                	ld	s0,32(sp)
    800009c8:	64e2                	ld	s1,24(sp)
    800009ca:	6942                	ld	s2,16(sp)
    800009cc:	69a2                	ld	s3,8(sp)
    800009ce:	6a02                	ld	s4,0(sp)
    800009d0:	6145                	addi	sp,sp,48
    800009d2:	8082                	ret

00000000800009d4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
    800009de:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e0:	e999                	bnez	a1,800009f6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e2:	8526                	mv	a0,s1
    800009e4:	00000097          	auipc	ra,0x0
    800009e8:	f84080e7          	jalr	-124(ra) # 80000968 <freewalk>
}
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f6:	6785                	lui	a5,0x1
    800009f8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fa:	95be                	add	a1,a1,a5
    800009fc:	4685                	li	a3,1
    800009fe:	00c5d613          	srli	a2,a1,0xc
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	d06080e7          	jalr	-762(ra) # 8000070a <uvmunmap>
    80000a0c:	bfd9                	j	800009e2 <uvmfree+0xe>

0000000080000a0e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a0e:	c679                	beqz	a2,80000adc <uvmcopy+0xce>
{
    80000a10:	715d                	addi	sp,sp,-80
    80000a12:	e486                	sd	ra,72(sp)
    80000a14:	e0a2                	sd	s0,64(sp)
    80000a16:	fc26                	sd	s1,56(sp)
    80000a18:	f84a                	sd	s2,48(sp)
    80000a1a:	f44e                	sd	s3,40(sp)
    80000a1c:	f052                	sd	s4,32(sp)
    80000a1e:	ec56                	sd	s5,24(sp)
    80000a20:	e85a                	sd	s6,16(sp)
    80000a22:	e45e                	sd	s7,8(sp)
    80000a24:	0880                	addi	s0,sp,80
    80000a26:	8b2a                	mv	s6,a0
    80000a28:	8aae                	mv	s5,a1
    80000a2a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a2e:	4601                	li	a2,0
    80000a30:	85ce                	mv	a1,s3
    80000a32:	855a                	mv	a0,s6
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	a28080e7          	jalr	-1496(ra) # 8000045c <walk>
    80000a3c:	c531                	beqz	a0,80000a88 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a3e:	6118                	ld	a4,0(a0)
    80000a40:	00177793          	andi	a5,a4,1
    80000a44:	cbb1                	beqz	a5,80000a98 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a46:	00a75593          	srli	a1,a4,0xa
    80000a4a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a4e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	6c8080e7          	jalr	1736(ra) # 8000011a <kalloc>
    80000a5a:	892a                	mv	s2,a0
    80000a5c:	c939                	beqz	a0,80000ab2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a5e:	6605                	lui	a2,0x1
    80000a60:	85de                	mv	a1,s7
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	774080e7          	jalr	1908(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6a:	8726                	mv	a4,s1
    80000a6c:	86ca                	mv	a3,s2
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85ce                	mv	a1,s3
    80000a72:	8556                	mv	a0,s5
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	ad0080e7          	jalr	-1328(ra) # 80000544 <mappages>
    80000a7c:	e515                	bnez	a0,80000aa8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	99be                	add	s3,s3,a5
    80000a82:	fb49e6e3          	bltu	s3,s4,80000a2e <uvmcopy+0x20>
    80000a86:	a081                	j	80000ac6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	68050513          	addi	a0,a0,1664 # 80008108 <etext+0x108>
    80000a90:	00005097          	auipc	ra,0x5
    80000a94:	266080e7          	jalr	614(ra) # 80005cf6 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	256080e7          	jalr	598(ra) # 80005cf6 <panic>
      kfree(mem);
    80000aa8:	854a                	mv	a0,s2
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	572080e7          	jalr	1394(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab2:	4685                	li	a3,1
    80000ab4:	00c9d613          	srli	a2,s3,0xc
    80000ab8:	4581                	li	a1,0
    80000aba:	8556                	mv	a0,s5
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	c4e080e7          	jalr	-946(ra) # 8000070a <uvmunmap>
  return -1;
    80000ac4:	557d                	li	a0,-1
}
    80000ac6:	60a6                	ld	ra,72(sp)
    80000ac8:	6406                	ld	s0,64(sp)
    80000aca:	74e2                	ld	s1,56(sp)
    80000acc:	7942                	ld	s2,48(sp)
    80000ace:	79a2                	ld	s3,40(sp)
    80000ad0:	7a02                	ld	s4,32(sp)
    80000ad2:	6ae2                	ld	s5,24(sp)
    80000ad4:	6b42                	ld	s6,16(sp)
    80000ad6:	6ba2                	ld	s7,8(sp)
    80000ad8:	6161                	addi	sp,sp,80
    80000ada:	8082                	ret
  return 0;
    80000adc:	4501                	li	a0,0
}
    80000ade:	8082                	ret

0000000080000ae0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae0:	1141                	addi	sp,sp,-16
    80000ae2:	e406                	sd	ra,8(sp)
    80000ae4:	e022                	sd	s0,0(sp)
    80000ae6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae8:	4601                	li	a2,0
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	972080e7          	jalr	-1678(ra) # 8000045c <walk>
  if(pte == 0)
    80000af2:	c901                	beqz	a0,80000b02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af4:	611c                	ld	a5,0(a0)
    80000af6:	9bbd                	andi	a5,a5,-17
    80000af8:	e11c                	sd	a5,0(a0)
}
    80000afa:	60a2                	ld	ra,8(sp)
    80000afc:	6402                	ld	s0,0(sp)
    80000afe:	0141                	addi	sp,sp,16
    80000b00:	8082                	ret
    panic("uvmclear");
    80000b02:	00007517          	auipc	a0,0x7
    80000b06:	64650513          	addi	a0,a0,1606 # 80008148 <etext+0x148>
    80000b0a:	00005097          	auipc	ra,0x5
    80000b0e:	1ec080e7          	jalr	492(ra) # 80005cf6 <panic>

0000000080000b12 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b12:	c6bd                	beqz	a3,80000b80 <copyout+0x6e>
{
    80000b14:	715d                	addi	sp,sp,-80
    80000b16:	e486                	sd	ra,72(sp)
    80000b18:	e0a2                	sd	s0,64(sp)
    80000b1a:	fc26                	sd	s1,56(sp)
    80000b1c:	f84a                	sd	s2,48(sp)
    80000b1e:	f44e                	sd	s3,40(sp)
    80000b20:	f052                	sd	s4,32(sp)
    80000b22:	ec56                	sd	s5,24(sp)
    80000b24:	e85a                	sd	s6,16(sp)
    80000b26:	e45e                	sd	s7,8(sp)
    80000b28:	e062                	sd	s8,0(sp)
    80000b2a:	0880                	addi	s0,sp,80
    80000b2c:	8b2a                	mv	s6,a0
    80000b2e:	8c2e                	mv	s8,a1
    80000b30:	8a32                	mv	s4,a2
    80000b32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b36:	6a85                	lui	s5,0x1
    80000b38:	a015                	j	80000b5c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3a:	9562                	add	a0,a0,s8
    80000b3c:	0004861b          	sext.w	a2,s1
    80000b40:	85d2                	mv	a1,s4
    80000b42:	41250533          	sub	a0,a0,s2
    80000b46:	fffff097          	auipc	ra,0xfffff
    80000b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>

    len -= n;
    80000b4e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b52:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b54:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b58:	02098263          	beqz	s3,80000b7c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b60:	85ca                	mv	a1,s2
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	99e080e7          	jalr	-1634(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000b6c:	cd01                	beqz	a0,80000b84 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b6e:	418904b3          	sub	s1,s2,s8
    80000b72:	94d6                	add	s1,s1,s5
    80000b74:	fc99f3e3          	bgeu	s3,s1,80000b3a <copyout+0x28>
    80000b78:	84ce                	mv	s1,s3
    80000b7a:	b7c1                	j	80000b3a <copyout+0x28>
  }
  return 0;
    80000b7c:	4501                	li	a0,0
    80000b7e:	a021                	j	80000b86 <copyout+0x74>
    80000b80:	4501                	li	a0,0
}
    80000b82:	8082                	ret
      return -1;
    80000b84:	557d                	li	a0,-1
}
    80000b86:	60a6                	ld	ra,72(sp)
    80000b88:	6406                	ld	s0,64(sp)
    80000b8a:	74e2                	ld	s1,56(sp)
    80000b8c:	7942                	ld	s2,48(sp)
    80000b8e:	79a2                	ld	s3,40(sp)
    80000b90:	7a02                	ld	s4,32(sp)
    80000b92:	6ae2                	ld	s5,24(sp)
    80000b94:	6b42                	ld	s6,16(sp)
    80000b96:	6ba2                	ld	s7,8(sp)
    80000b98:	6c02                	ld	s8,0(sp)
    80000b9a:	6161                	addi	sp,sp,80
    80000b9c:	8082                	ret

0000000080000b9e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b9e:	caa5                	beqz	a3,80000c0e <copyin+0x70>
{
    80000ba0:	715d                	addi	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	addi	s0,sp,80
    80000bb8:	8b2a                	mv	s6,a0
    80000bba:	8a2e                	mv	s4,a1
    80000bbc:	8c32                	mv	s8,a2
    80000bbe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc2:	6a85                	lui	s5,0x1
    80000bc4:	a01d                	j	80000bea <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc6:	018505b3          	add	a1,a0,s8
    80000bca:	0004861b          	sext.w	a2,s1
    80000bce:	412585b3          	sub	a1,a1,s2
    80000bd2:	8552                	mv	a0,s4
    80000bd4:	fffff097          	auipc	ra,0xfffff
    80000bd8:	602080e7          	jalr	1538(ra) # 800001d6 <memmove>

    len -= n;
    80000bdc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be6:	02098263          	beqz	s3,80000c0a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bea:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bee:	85ca                	mv	a1,s2
    80000bf0:	855a                	mv	a0,s6
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	910080e7          	jalr	-1776(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000bfa:	cd01                	beqz	a0,80000c12 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfc:	418904b3          	sub	s1,s2,s8
    80000c00:	94d6                	add	s1,s1,s5
    80000c02:	fc99f2e3          	bgeu	s3,s1,80000bc6 <copyin+0x28>
    80000c06:	84ce                	mv	s1,s3
    80000c08:	bf7d                	j	80000bc6 <copyin+0x28>
  }
  return 0;
    80000c0a:	4501                	li	a0,0
    80000c0c:	a021                	j	80000c14 <copyin+0x76>
    80000c0e:	4501                	li	a0,0
}
    80000c10:	8082                	ret
      return -1;
    80000c12:	557d                	li	a0,-1
}
    80000c14:	60a6                	ld	ra,72(sp)
    80000c16:	6406                	ld	s0,64(sp)
    80000c18:	74e2                	ld	s1,56(sp)
    80000c1a:	7942                	ld	s2,48(sp)
    80000c1c:	79a2                	ld	s3,40(sp)
    80000c1e:	7a02                	ld	s4,32(sp)
    80000c20:	6ae2                	ld	s5,24(sp)
    80000c22:	6b42                	ld	s6,16(sp)
    80000c24:	6ba2                	ld	s7,8(sp)
    80000c26:	6c02                	ld	s8,0(sp)
    80000c28:	6161                	addi	sp,sp,80
    80000c2a:	8082                	ret

0000000080000c2c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2c:	c2dd                	beqz	a3,80000cd2 <copyinstr+0xa6>
{
    80000c2e:	715d                	addi	sp,sp,-80
    80000c30:	e486                	sd	ra,72(sp)
    80000c32:	e0a2                	sd	s0,64(sp)
    80000c34:	fc26                	sd	s1,56(sp)
    80000c36:	f84a                	sd	s2,48(sp)
    80000c38:	f44e                	sd	s3,40(sp)
    80000c3a:	f052                	sd	s4,32(sp)
    80000c3c:	ec56                	sd	s5,24(sp)
    80000c3e:	e85a                	sd	s6,16(sp)
    80000c40:	e45e                	sd	s7,8(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8a2a                	mv	s4,a0
    80000c46:	8b2e                	mv	s6,a1
    80000c48:	8bb2                	mv	s7,a2
    80000c4a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6985                	lui	s3,0x1
    80000c50:	a02d                	j	80000c7a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c52:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c56:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c58:	37fd                	addiw	a5,a5,-1
    80000c5a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c5e:	60a6                	ld	ra,72(sp)
    80000c60:	6406                	ld	s0,64(sp)
    80000c62:	74e2                	ld	s1,56(sp)
    80000c64:	7942                	ld	s2,48(sp)
    80000c66:	79a2                	ld	s3,40(sp)
    80000c68:	7a02                	ld	s4,32(sp)
    80000c6a:	6ae2                	ld	s5,24(sp)
    80000c6c:	6b42                	ld	s6,16(sp)
    80000c6e:	6ba2                	ld	s7,8(sp)
    80000c70:	6161                	addi	sp,sp,80
    80000c72:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c74:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c78:	c8a9                	beqz	s1,80000cca <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c7e:	85ca                	mv	a1,s2
    80000c80:	8552                	mv	a0,s4
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	880080e7          	jalr	-1920(ra) # 80000502 <walkaddr>
    if(pa0 == 0)
    80000c8a:	c131                	beqz	a0,80000cce <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8c:	417906b3          	sub	a3,s2,s7
    80000c90:	96ce                	add	a3,a3,s3
    80000c92:	00d4f363          	bgeu	s1,a3,80000c98 <copyinstr+0x6c>
    80000c96:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c98:	955e                	add	a0,a0,s7
    80000c9a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c9e:	daf9                	beqz	a3,80000c74 <copyinstr+0x48>
    80000ca0:	87da                	mv	a5,s6
    80000ca2:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ca8:	96da                	add	a3,a3,s6
    80000caa:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cac:	00f60733          	add	a4,a2,a5
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd030>
    80000cb4:	df59                	beqz	a4,80000c52 <copyinstr+0x26>
        *dst = *p;
    80000cb6:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cba:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cbc:	fed797e3          	bne	a5,a3,80000caa <copyinstr+0x7e>
    80000cc0:	14fd                	addi	s1,s1,-1
    80000cc2:	94c2                	add	s1,s1,a6
      --max;
    80000cc4:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cc6:	8b3e                	mv	s6,a5
    80000cc8:	b775                	j	80000c74 <copyinstr+0x48>
    80000cca:	4781                	li	a5,0
    80000ccc:	b771                	j	80000c58 <copyinstr+0x2c>
      return -1;
    80000cce:	557d                	li	a0,-1
    80000cd0:	b779                	j	80000c5e <copyinstr+0x32>
  int got_null = 0;
    80000cd2:	4781                	li	a5,0
  if(got_null){
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007851b          	sext.w	a0,a5
}
    80000cda:	8082                	ret

0000000080000cdc <printwalk>:


void printwalk(pagetable_t pt, int dep) {
    80000cdc:	7159                	addi	sp,sp,-112
    80000cde:	f486                	sd	ra,104(sp)
    80000ce0:	f0a2                	sd	s0,96(sp)
    80000ce2:	eca6                	sd	s1,88(sp)
    80000ce4:	e8ca                	sd	s2,80(sp)
    80000ce6:	e4ce                	sd	s3,72(sp)
    80000ce8:	e0d2                	sd	s4,64(sp)
    80000cea:	fc56                	sd	s5,56(sp)
    80000cec:	f85a                	sd	s6,48(sp)
    80000cee:	f45e                	sd	s7,40(sp)
    80000cf0:	f062                	sd	s8,32(sp)
    80000cf2:	ec66                	sd	s9,24(sp)
    80000cf4:	e86a                	sd	s10,16(sp)
    80000cf6:	e46e                	sd	s11,8(sp)
    80000cf8:	1880                	addi	s0,sp,112
    80000cfa:	8c2e                	mv	s8,a1
    for(int i = 0; i < 512; i++){
    80000cfc:	8a2a                	mv	s4,a0
    80000cfe:	4981                	li	s3,0
        pte_t pte = pt[i];
        if (pte & PTE_V) {
            for (int j = 0; j < dep - 1; j++) printf(".. ");
    80000d00:	4d85                	li	s11,1
            printf("..%d: pte %p ", i, pte);
    80000d02:	00007d17          	auipc	s10,0x7
    80000d06:	45ed0d13          	addi	s10,s10,1118 # 80008160 <etext+0x160>
            uint64 child = PTE2PA(pte);
            printf("pa %p\n", child);
    80000d0a:	00007c97          	auipc	s9,0x7
    80000d0e:	466c8c93          	addi	s9,s9,1126 # 80008170 <etext+0x170>
    80000d12:	fff58b1b          	addiw	s6,a1,-1
            for (int j = 0; j < dep - 1; j++) printf(".. ");
    80000d16:	00007a97          	auipc	s5,0x7
    80000d1a:	442a8a93          	addi	s5,s5,1090 # 80008158 <etext+0x158>
    for(int i = 0; i < 512; i++){
    80000d1e:	20000b93          	li	s7,512
    80000d22:	a029                	j	80000d2c <printwalk+0x50>
    80000d24:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d26:	0a21                	addi	s4,s4,8
    80000d28:	05798e63          	beq	s3,s7,80000d84 <printwalk+0xa8>
        pte_t pte = pt[i];
    80000d2c:	000a3903          	ld	s2,0(s4)
        if (pte & PTE_V) {
    80000d30:	00197793          	andi	a5,s2,1
    80000d34:	dbe5                	beqz	a5,80000d24 <printwalk+0x48>
            for (int j = 0; j < dep - 1; j++) printf(".. ");
    80000d36:	018ddb63          	bge	s11,s8,80000d4c <printwalk+0x70>
    80000d3a:	4481                	li	s1,0
    80000d3c:	8556                	mv	a0,s5
    80000d3e:	00005097          	auipc	ra,0x5
    80000d42:	002080e7          	jalr	2(ra) # 80005d40 <printf>
    80000d46:	2485                	addiw	s1,s1,1
    80000d48:	fe9b1ae3          	bne	s6,s1,80000d3c <printwalk+0x60>
            printf("..%d: pte %p ", i, pte);
    80000d4c:	864a                	mv	a2,s2
    80000d4e:	85ce                	mv	a1,s3
    80000d50:	856a                	mv	a0,s10
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	fee080e7          	jalr	-18(ra) # 80005d40 <printf>
            uint64 child = PTE2PA(pte);
    80000d5a:	00a95493          	srli	s1,s2,0xa
    80000d5e:	04b2                	slli	s1,s1,0xc
            printf("pa %p\n", child);
    80000d60:	85a6                	mv	a1,s1
    80000d62:	8566                	mv	a0,s9
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	fdc080e7          	jalr	-36(ra) # 80005d40 <printf>
            if ((pte & (PTE_R|PTE_W|PTE_X)) == 0)
    80000d6c:	00e97913          	andi	s2,s2,14
    80000d70:	fa091ae3          	bnez	s2,80000d24 <printwalk+0x48>
                printwalk((pagetable_t)child, dep + 1);
    80000d74:	001c059b          	addiw	a1,s8,1
    80000d78:	8526                	mv	a0,s1
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	f62080e7          	jalr	-158(ra) # 80000cdc <printwalk>
    80000d82:	b74d                	j	80000d24 <printwalk+0x48>
        }
    }
}
    80000d84:	70a6                	ld	ra,104(sp)
    80000d86:	7406                	ld	s0,96(sp)
    80000d88:	64e6                	ld	s1,88(sp)
    80000d8a:	6946                	ld	s2,80(sp)
    80000d8c:	69a6                	ld	s3,72(sp)
    80000d8e:	6a06                	ld	s4,64(sp)
    80000d90:	7ae2                	ld	s5,56(sp)
    80000d92:	7b42                	ld	s6,48(sp)
    80000d94:	7ba2                	ld	s7,40(sp)
    80000d96:	7c02                	ld	s8,32(sp)
    80000d98:	6ce2                	ld	s9,24(sp)
    80000d9a:	6d42                	ld	s10,16(sp)
    80000d9c:	6da2                	ld	s11,8(sp)
    80000d9e:	6165                	addi	sp,sp,112
    80000da0:	8082                	ret

0000000080000da2 <vmprint>:
void vmprint(pagetable_t pt) {
    80000da2:	1101                	addi	sp,sp,-32
    80000da4:	ec06                	sd	ra,24(sp)
    80000da6:	e822                	sd	s0,16(sp)
    80000da8:	e426                	sd	s1,8(sp)
    80000daa:	1000                	addi	s0,sp,32
    80000dac:	84aa                	mv	s1,a0
    printf("page table %p\n", pt);
    80000dae:	85aa                	mv	a1,a0
    80000db0:	00007517          	auipc	a0,0x7
    80000db4:	3c850513          	addi	a0,a0,968 # 80008178 <etext+0x178>
    80000db8:	00005097          	auipc	ra,0x5
    80000dbc:	f88080e7          	jalr	-120(ra) # 80005d40 <printf>
    printwalk(pt, 1);
    80000dc0:	4585                	li	a1,1
    80000dc2:	8526                	mv	a0,s1
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	f18080e7          	jalr	-232(ra) # 80000cdc <printwalk>
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret

0000000080000dd6 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dd6:	7139                	addi	sp,sp,-64
    80000dd8:	fc06                	sd	ra,56(sp)
    80000dda:	f822                	sd	s0,48(sp)
    80000ddc:	f426                	sd	s1,40(sp)
    80000dde:	f04a                	sd	s2,32(sp)
    80000de0:	ec4e                	sd	s3,24(sp)
    80000de2:	e852                	sd	s4,16(sp)
    80000de4:	e456                	sd	s5,8(sp)
    80000de6:	e05a                	sd	s6,0(sp)
    80000de8:	0080                	addi	s0,sp,64
    80000dea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	00008497          	auipc	s1,0x8
    80000df0:	fc448493          	addi	s1,s1,-60 # 80008db0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	8b26                	mv	s6,s1
    80000df6:	00007a97          	auipc	s5,0x7
    80000dfa:	20aa8a93          	addi	s5,s5,522 # 80008000 <etext>
    80000dfe:	01000937          	lui	s2,0x1000
    80000e02:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e04:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	0000ea17          	auipc	s4,0xe
    80000e0a:	baaa0a13          	addi	s4,s4,-1110 # 8000e9b0 <tickslock>
    char *pa = kalloc();
    80000e0e:	fffff097          	auipc	ra,0xfffff
    80000e12:	30c080e7          	jalr	780(ra) # 8000011a <kalloc>
    80000e16:	862a                	mv	a2,a0
    if(pa == 0)
    80000e18:	c129                	beqz	a0,80000e5a <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e1a:	416485b3          	sub	a1,s1,s6
    80000e1e:	8591                	srai	a1,a1,0x4
    80000e20:	000ab783          	ld	a5,0(s5)
    80000e24:	02f585b3          	mul	a1,a1,a5
    80000e28:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e2c:	4719                	li	a4,6
    80000e2e:	6685                	lui	a3,0x1
    80000e30:	40b905b3          	sub	a1,s2,a1
    80000e34:	854e                	mv	a0,s3
    80000e36:	fffff097          	auipc	ra,0xfffff
    80000e3a:	7ae080e7          	jalr	1966(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	17048493          	addi	s1,s1,368
    80000e42:	fd4496e3          	bne	s1,s4,80000e0e <proc_mapstacks+0x38>
  }
}
    80000e46:	70e2                	ld	ra,56(sp)
    80000e48:	7442                	ld	s0,48(sp)
    80000e4a:	74a2                	ld	s1,40(sp)
    80000e4c:	7902                	ld	s2,32(sp)
    80000e4e:	69e2                	ld	s3,24(sp)
    80000e50:	6a42                	ld	s4,16(sp)
    80000e52:	6aa2                	ld	s5,8(sp)
    80000e54:	6b02                	ld	s6,0(sp)
    80000e56:	6121                	addi	sp,sp,64
    80000e58:	8082                	ret
      panic("kalloc");
    80000e5a:	00007517          	auipc	a0,0x7
    80000e5e:	32e50513          	addi	a0,a0,814 # 80008188 <etext+0x188>
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	e94080e7          	jalr	-364(ra) # 80005cf6 <panic>

0000000080000e6a <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e6a:	7139                	addi	sp,sp,-64
    80000e6c:	fc06                	sd	ra,56(sp)
    80000e6e:	f822                	sd	s0,48(sp)
    80000e70:	f426                	sd	s1,40(sp)
    80000e72:	f04a                	sd	s2,32(sp)
    80000e74:	ec4e                	sd	s3,24(sp)
    80000e76:	e852                	sd	s4,16(sp)
    80000e78:	e456                	sd	s5,8(sp)
    80000e7a:	e05a                	sd	s6,0(sp)
    80000e7c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e7e:	00007597          	auipc	a1,0x7
    80000e82:	31258593          	addi	a1,a1,786 # 80008190 <etext+0x190>
    80000e86:	00008517          	auipc	a0,0x8
    80000e8a:	afa50513          	addi	a0,a0,-1286 # 80008980 <pid_lock>
    80000e8e:	00005097          	auipc	ra,0x5
    80000e92:	310080e7          	jalr	784(ra) # 8000619e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e96:	00007597          	auipc	a1,0x7
    80000e9a:	30258593          	addi	a1,a1,770 # 80008198 <etext+0x198>
    80000e9e:	00008517          	auipc	a0,0x8
    80000ea2:	afa50513          	addi	a0,a0,-1286 # 80008998 <wait_lock>
    80000ea6:	00005097          	auipc	ra,0x5
    80000eaa:	2f8080e7          	jalr	760(ra) # 8000619e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eae:	00008497          	auipc	s1,0x8
    80000eb2:	f0248493          	addi	s1,s1,-254 # 80008db0 <proc>
      initlock(&p->lock, "proc");
    80000eb6:	00007b17          	auipc	s6,0x7
    80000eba:	2f2b0b13          	addi	s6,s6,754 # 800081a8 <etext+0x1a8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ebe:	8aa6                	mv	s5,s1
    80000ec0:	00007a17          	auipc	s4,0x7
    80000ec4:	140a0a13          	addi	s4,s4,320 # 80008000 <etext>
    80000ec8:	01000937          	lui	s2,0x1000
    80000ecc:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ece:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	0000e997          	auipc	s3,0xe
    80000ed4:	ae098993          	addi	s3,s3,-1312 # 8000e9b0 <tickslock>
      initlock(&p->lock, "proc");
    80000ed8:	85da                	mv	a1,s6
    80000eda:	8526                	mv	a0,s1
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	2c2080e7          	jalr	706(ra) # 8000619e <initlock>
      p->state = UNUSED;
    80000ee4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ee8:	415487b3          	sub	a5,s1,s5
    80000eec:	8791                	srai	a5,a5,0x4
    80000eee:	000a3703          	ld	a4,0(s4)
    80000ef2:	02e787b3          	mul	a5,a5,a4
    80000ef6:	00d7979b          	slliw	a5,a5,0xd
    80000efa:	40f907b3          	sub	a5,s2,a5
    80000efe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f00:	17048493          	addi	s1,s1,368
    80000f04:	fd349ae3          	bne	s1,s3,80000ed8 <procinit+0x6e>
  }
}
    80000f08:	70e2                	ld	ra,56(sp)
    80000f0a:	7442                	ld	s0,48(sp)
    80000f0c:	74a2                	ld	s1,40(sp)
    80000f0e:	7902                	ld	s2,32(sp)
    80000f10:	69e2                	ld	s3,24(sp)
    80000f12:	6a42                	ld	s4,16(sp)
    80000f14:	6aa2                	ld	s5,8(sp)
    80000f16:	6b02                	ld	s6,0(sp)
    80000f18:	6121                	addi	sp,sp,64
    80000f1a:	8082                	ret

0000000080000f1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f1c:	1141                	addi	sp,sp,-16
    80000f1e:	e422                	sd	s0,8(sp)
    80000f20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f24:	2501                	sext.w	a0,a0
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret

0000000080000f2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e422                	sd	s0,8(sp)
    80000f30:	0800                	addi	s0,sp,16
    80000f32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f34:	2781                	sext.w	a5,a5
    80000f36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f38:	00008517          	auipc	a0,0x8
    80000f3c:	a7850513          	addi	a0,a0,-1416 # 800089b0 <cpus>
    80000f40:	953e                	add	a0,a0,a5
    80000f42:	6422                	ld	s0,8(sp)
    80000f44:	0141                	addi	sp,sp,16
    80000f46:	8082                	ret

0000000080000f48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f48:	1101                	addi	sp,sp,-32
    80000f4a:	ec06                	sd	ra,24(sp)
    80000f4c:	e822                	sd	s0,16(sp)
    80000f4e:	e426                	sd	s1,8(sp)
    80000f50:	1000                	addi	s0,sp,32
  push_off();
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	290080e7          	jalr	656(ra) # 800061e2 <push_off>
    80000f5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f5c:	2781                	sext.w	a5,a5
    80000f5e:	079e                	slli	a5,a5,0x7
    80000f60:	00008717          	auipc	a4,0x8
    80000f64:	a2070713          	addi	a4,a4,-1504 # 80008980 <pid_lock>
    80000f68:	97ba                	add	a5,a5,a4
    80000f6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	316080e7          	jalr	790(ra) # 80006282 <pop_off>
  return p;
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6105                	addi	sp,sp,32
    80000f7e:	8082                	ret

0000000080000f80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f80:	1141                	addi	sp,sp,-16
    80000f82:	e406                	sd	ra,8(sp)
    80000f84:	e022                	sd	s0,0(sp)
    80000f86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	fc0080e7          	jalr	-64(ra) # 80000f48 <myproc>
    80000f90:	00005097          	auipc	ra,0x5
    80000f94:	352080e7          	jalr	850(ra) # 800062e2 <release>

  if (first) {
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9287a783          	lw	a5,-1752(a5) # 800088c0 <first.1>
    80000fa0:	eb89                	bnez	a5,80000fb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fa2:	00001097          	auipc	ra,0x1
    80000fa6:	d0a080e7          	jalr	-758(ra) # 80001cac <usertrapret>
}
    80000faa:	60a2                	ld	ra,8(sp)
    80000fac:	6402                	ld	s0,0(sp)
    80000fae:	0141                	addi	sp,sp,16
    80000fb0:	8082                	ret
    first = 0;
    80000fb2:	00008797          	auipc	a5,0x8
    80000fb6:	9007a723          	sw	zero,-1778(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80000fba:	4505                	li	a0,1
    80000fbc:	00002097          	auipc	ra,0x2
    80000fc0:	a4c080e7          	jalr	-1460(ra) # 80002a08 <fsinit>
    80000fc4:	bff9                	j	80000fa2 <forkret+0x22>

0000000080000fc6 <allocpid>:
{
    80000fc6:	1101                	addi	sp,sp,-32
    80000fc8:	ec06                	sd	ra,24(sp)
    80000fca:	e822                	sd	s0,16(sp)
    80000fcc:	e426                	sd	s1,8(sp)
    80000fce:	e04a                	sd	s2,0(sp)
    80000fd0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fd2:	00008917          	auipc	s2,0x8
    80000fd6:	9ae90913          	addi	s2,s2,-1618 # 80008980 <pid_lock>
    80000fda:	854a                	mv	a0,s2
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	252080e7          	jalr	594(ra) # 8000622e <acquire>
  pid = nextpid;
    80000fe4:	00008797          	auipc	a5,0x8
    80000fe8:	8e078793          	addi	a5,a5,-1824 # 800088c4 <nextpid>
    80000fec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fee:	0014871b          	addiw	a4,s1,1
    80000ff2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ff4:	854a                	mv	a0,s2
    80000ff6:	00005097          	auipc	ra,0x5
    80000ffa:	2ec080e7          	jalr	748(ra) # 800062e2 <release>
}
    80000ffe:	8526                	mv	a0,s1
    80001000:	60e2                	ld	ra,24(sp)
    80001002:	6442                	ld	s0,16(sp)
    80001004:	64a2                	ld	s1,8(sp)
    80001006:	6902                	ld	s2,0(sp)
    80001008:	6105                	addi	sp,sp,32
    8000100a:	8082                	ret

000000008000100c <proc_pagetable>:
{
    8000100c:	1101                	addi	sp,sp,-32
    8000100e:	ec06                	sd	ra,24(sp)
    80001010:	e822                	sd	s0,16(sp)
    80001012:	e426                	sd	s1,8(sp)
    80001014:	e04a                	sd	s2,0(sp)
    80001016:	1000                	addi	s0,sp,32
    80001018:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	7b4080e7          	jalr	1972(ra) # 800007ce <uvmcreate>
    80001022:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001024:	cd39                	beqz	a0,80001082 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001026:	4729                	li	a4,10
    80001028:	00006697          	auipc	a3,0x6
    8000102c:	fd868693          	addi	a3,a3,-40 # 80007000 <_trampoline>
    80001030:	6605                	lui	a2,0x1
    80001032:	040005b7          	lui	a1,0x4000
    80001036:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001038:	05b2                	slli	a1,a1,0xc
    8000103a:	fffff097          	auipc	ra,0xfffff
    8000103e:	50a080e7          	jalr	1290(ra) # 80000544 <mappages>
    80001042:	04054763          	bltz	a0,80001090 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001046:	4719                	li	a4,6
    80001048:	05893683          	ld	a3,88(s2)
    8000104c:	6605                	lui	a2,0x1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	4ec080e7          	jalr	1260(ra) # 80000544 <mappages>
    80001060:	04054063          	bltz	a0,800010a0 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscall), PTE_R | PTE_U) < 0){
    80001064:	4749                	li	a4,18
    80001066:	06093683          	ld	a3,96(s2)
    8000106a:	6605                	lui	a2,0x1
    8000106c:	040005b7          	lui	a1,0x4000
    80001070:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001072:	05b2                	slli	a1,a1,0xc
    80001074:	8526                	mv	a0,s1
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	4ce080e7          	jalr	1230(ra) # 80000544 <mappages>
    8000107e:	04054463          	bltz	a0,800010c6 <proc_pagetable+0xba>
}
    80001082:	8526                	mv	a0,s1
    80001084:	60e2                	ld	ra,24(sp)
    80001086:	6442                	ld	s0,16(sp)
    80001088:	64a2                	ld	s1,8(sp)
    8000108a:	6902                	ld	s2,0(sp)
    8000108c:	6105                	addi	sp,sp,32
    8000108e:	8082                	ret
    uvmfree(pagetable, 0);
    80001090:	4581                	li	a1,0
    80001092:	8526                	mv	a0,s1
    80001094:	00000097          	auipc	ra,0x0
    80001098:	940080e7          	jalr	-1728(ra) # 800009d4 <uvmfree>
    return 0;
    8000109c:	4481                	li	s1,0
    8000109e:	b7d5                	j	80001082 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a0:	4681                	li	a3,0
    800010a2:	4605                	li	a2,1
    800010a4:	040005b7          	lui	a1,0x4000
    800010a8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010aa:	05b2                	slli	a1,a1,0xc
    800010ac:	8526                	mv	a0,s1
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	65c080e7          	jalr	1628(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010b6:	4581                	li	a1,0
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	91a080e7          	jalr	-1766(ra) # 800009d4 <uvmfree>
    return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	bf7d                	j	80001082 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c6:	4681                	li	a3,0
    800010c8:	4605                	li	a2,1
    800010ca:	040005b7          	lui	a1,0x4000
    800010ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010d0:	05b2                	slli	a1,a1,0xc
    800010d2:	8526                	mv	a0,s1
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	636080e7          	jalr	1590(ra) # 8000070a <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010dc:	4681                	li	a3,0
    800010de:	4605                	li	a2,1
    800010e0:	020005b7          	lui	a1,0x2000
    800010e4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e6:	05b6                	slli	a1,a1,0xd
    800010e8:	8526                	mv	a0,s1
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	620080e7          	jalr	1568(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    800010f2:	4581                	li	a1,0
    800010f4:	8526                	mv	a0,s1
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	8de080e7          	jalr	-1826(ra) # 800009d4 <uvmfree>
    return 0;
    800010fe:	4481                	li	s1,0
    80001100:	b749                	j	80001082 <proc_pagetable+0x76>

0000000080001102 <proc_freepagetable>:
{
    80001102:	7179                	addi	sp,sp,-48
    80001104:	f406                	sd	ra,40(sp)
    80001106:	f022                	sd	s0,32(sp)
    80001108:	ec26                	sd	s1,24(sp)
    8000110a:	e84a                	sd	s2,16(sp)
    8000110c:	e44e                	sd	s3,8(sp)
    8000110e:	1800                	addi	s0,sp,48
    80001110:	84aa                	mv	s1,a0
    80001112:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001114:	4681                	li	a3,0
    80001116:	4605                	li	a2,1
    80001118:	04000937          	lui	s2,0x4000
    8000111c:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001120:	05b2                	slli	a1,a1,0xc
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	5e8080e7          	jalr	1512(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000112a:	4681                	li	a3,0
    8000112c:	4605                	li	a2,1
    8000112e:	020005b7          	lui	a1,0x2000
    80001132:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001134:	05b6                	slli	a1,a1,0xd
    80001136:	8526                	mv	a0,s1
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	5d2080e7          	jalr	1490(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001140:	4681                	li	a3,0
    80001142:	4605                	li	a2,1
    80001144:	1975                	addi	s2,s2,-3
    80001146:	00c91593          	slli	a1,s2,0xc
    8000114a:	8526                	mv	a0,s1
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	5be080e7          	jalr	1470(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80001154:	85ce                	mv	a1,s3
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	87c080e7          	jalr	-1924(ra) # 800009d4 <uvmfree>
}
    80001160:	70a2                	ld	ra,40(sp)
    80001162:	7402                	ld	s0,32(sp)
    80001164:	64e2                	ld	s1,24(sp)
    80001166:	6942                	ld	s2,16(sp)
    80001168:	69a2                	ld	s3,8(sp)
    8000116a:	6145                	addi	sp,sp,48
    8000116c:	8082                	ret

000000008000116e <freeproc>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	1000                	addi	s0,sp,32
    80001178:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000117a:	6d28                	ld	a0,88(a0)
    8000117c:	c509                	beqz	a0,80001186 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	e9e080e7          	jalr	-354(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001186:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    8000118a:	70a8                	ld	a0,96(s1)
    8000118c:	c509                	beqz	a0,80001196 <freeproc+0x28>
    kfree((void*)p->usyscall);
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	e8e080e7          	jalr	-370(ra) # 8000001c <kfree>
  p->usyscall = 0;
    80001196:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000119a:	68a8                	ld	a0,80(s1)
    8000119c:	c511                	beqz	a0,800011a8 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    8000119e:	64ac                	ld	a1,72(s1)
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	f62080e7          	jalr	-158(ra) # 80001102 <proc_freepagetable>
  p->pagetable = 0;
    800011a8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011ac:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011b0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011b4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011b8:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011bc:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011c0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011c4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011c8:	0004ac23          	sw	zero,24(s1)
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <allocproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	00008497          	auipc	s1,0x8
    800011e6:	bce48493          	addi	s1,s1,-1074 # 80008db0 <proc>
    800011ea:	0000d917          	auipc	s2,0xd
    800011ee:	7c690913          	addi	s2,s2,1990 # 8000e9b0 <tickslock>
    acquire(&p->lock);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00005097          	auipc	ra,0x5
    800011f8:	03a080e7          	jalr	58(ra) # 8000622e <acquire>
    if(p->state == UNUSED) {
    800011fc:	4c9c                	lw	a5,24(s1)
    800011fe:	cf81                	beqz	a5,80001216 <allocproc+0x40>
      release(&p->lock);
    80001200:	8526                	mv	a0,s1
    80001202:	00005097          	auipc	ra,0x5
    80001206:	0e0080e7          	jalr	224(ra) # 800062e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000120a:	17048493          	addi	s1,s1,368
    8000120e:	ff2492e3          	bne	s1,s2,800011f2 <allocproc+0x1c>
  return 0;
    80001212:	4481                	li	s1,0
    80001214:	a095                	j	80001278 <allocproc+0xa2>
  p->pid = allocpid();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	db0080e7          	jalr	-592(ra) # 80000fc6 <allocpid>
    8000121e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001220:	4785                	li	a5,1
    80001222:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	ef6080e7          	jalr	-266(ra) # 8000011a <kalloc>
    8000122c:	892a                	mv	s2,a0
    8000122e:	eca8                	sd	a0,88(s1)
    80001230:	c939                	beqz	a0,80001286 <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	ee8080e7          	jalr	-280(ra) # 8000011a <kalloc>
    8000123a:	892a                	mv	s2,a0
    8000123c:	f0a8                	sd	a0,96(s1)
    8000123e:	c125                	beqz	a0,8000129e <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    80001240:	589c                	lw	a5,48(s1)
    80001242:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001244:	8526                	mv	a0,s1
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	dc6080e7          	jalr	-570(ra) # 8000100c <proc_pagetable>
    8000124e:	892a                	mv	s2,a0
    80001250:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001252:	c135                	beqz	a0,800012b6 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001254:	07000613          	li	a2,112
    80001258:	4581                	li	a1,0
    8000125a:	06848513          	addi	a0,s1,104
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	f1c080e7          	jalr	-228(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001266:	00000797          	auipc	a5,0x0
    8000126a:	d1a78793          	addi	a5,a5,-742 # 80000f80 <forkret>
    8000126e:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001270:	60bc                	ld	a5,64(s1)
    80001272:	6705                	lui	a4,0x1
    80001274:	97ba                	add	a5,a5,a4
    80001276:	f8bc                	sd	a5,112(s1)
}
    80001278:	8526                	mv	a0,s1
    8000127a:	60e2                	ld	ra,24(sp)
    8000127c:	6442                	ld	s0,16(sp)
    8000127e:	64a2                	ld	s1,8(sp)
    80001280:	6902                	ld	s2,0(sp)
    80001282:	6105                	addi	sp,sp,32
    80001284:	8082                	ret
    freeproc(p);
    80001286:	8526                	mv	a0,s1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	ee6080e7          	jalr	-282(ra) # 8000116e <freeproc>
    release(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00005097          	auipc	ra,0x5
    80001296:	050080e7          	jalr	80(ra) # 800062e2 <release>
    return 0;
    8000129a:	84ca                	mv	s1,s2
    8000129c:	bff1                	j	80001278 <allocproc+0xa2>
    freeproc(p);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	ece080e7          	jalr	-306(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012a8:	8526                	mv	a0,s1
    800012aa:	00005097          	auipc	ra,0x5
    800012ae:	038080e7          	jalr	56(ra) # 800062e2 <release>
    return 0;
    800012b2:	84ca                	mv	s1,s2
    800012b4:	b7d1                	j	80001278 <allocproc+0xa2>
    freeproc(p);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00000097          	auipc	ra,0x0
    800012bc:	eb6080e7          	jalr	-330(ra) # 8000116e <freeproc>
    release(&p->lock);
    800012c0:	8526                	mv	a0,s1
    800012c2:	00005097          	auipc	ra,0x5
    800012c6:	020080e7          	jalr	32(ra) # 800062e2 <release>
    return 0;
    800012ca:	84ca                	mv	s1,s2
    800012cc:	b775                	j	80001278 <allocproc+0xa2>

00000000800012ce <userinit>:
{
    800012ce:	1101                	addi	sp,sp,-32
    800012d0:	ec06                	sd	ra,24(sp)
    800012d2:	e822                	sd	s0,16(sp)
    800012d4:	e426                	sd	s1,8(sp)
    800012d6:	1000                	addi	s0,sp,32
  p = allocproc();
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	efe080e7          	jalr	-258(ra) # 800011d6 <allocproc>
    800012e0:	84aa                	mv	s1,a0
  initproc = p;
    800012e2:	00007797          	auipc	a5,0x7
    800012e6:	64a7bf23          	sd	a0,1630(a5) # 80008940 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012ea:	03400613          	li	a2,52
    800012ee:	00007597          	auipc	a1,0x7
    800012f2:	5e258593          	addi	a1,a1,1506 # 800088d0 <initcode>
    800012f6:	6928                	ld	a0,80(a0)
    800012f8:	fffff097          	auipc	ra,0xfffff
    800012fc:	504080e7          	jalr	1284(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    80001300:	6785                	lui	a5,0x1
    80001302:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001304:	6cb8                	ld	a4,88(s1)
    80001306:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000130a:	6cb8                	ld	a4,88(s1)
    8000130c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000130e:	4641                	li	a2,16
    80001310:	00007597          	auipc	a1,0x7
    80001314:	ea058593          	addi	a1,a1,-352 # 800081b0 <etext+0x1b0>
    80001318:	16048513          	addi	a0,s1,352
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	fa6080e7          	jalr	-90(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001324:	00007517          	auipc	a0,0x7
    80001328:	e9c50513          	addi	a0,a0,-356 # 800081c0 <etext+0x1c0>
    8000132c:	00002097          	auipc	ra,0x2
    80001330:	0fa080e7          	jalr	250(ra) # 80003426 <namei>
    80001334:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001338:	478d                	li	a5,3
    8000133a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	fa4080e7          	jalr	-92(ra) # 800062e2 <release>
}
    80001346:	60e2                	ld	ra,24(sp)
    80001348:	6442                	ld	s0,16(sp)
    8000134a:	64a2                	ld	s1,8(sp)
    8000134c:	6105                	addi	sp,sp,32
    8000134e:	8082                	ret

0000000080001350 <growproc>:
{
    80001350:	1101                	addi	sp,sp,-32
    80001352:	ec06                	sd	ra,24(sp)
    80001354:	e822                	sd	s0,16(sp)
    80001356:	e426                	sd	s1,8(sp)
    80001358:	e04a                	sd	s2,0(sp)
    8000135a:	1000                	addi	s0,sp,32
    8000135c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	bea080e7          	jalr	-1046(ra) # 80000f48 <myproc>
    80001366:	84aa                	mv	s1,a0
  sz = p->sz;
    80001368:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000136a:	01204c63          	bgtz	s2,80001382 <growproc+0x32>
  } else if(n < 0){
    8000136e:	02094663          	bltz	s2,8000139a <growproc+0x4a>
  p->sz = sz;
    80001372:	e4ac                	sd	a1,72(s1)
  return 0;
    80001374:	4501                	li	a0,0
}
    80001376:	60e2                	ld	ra,24(sp)
    80001378:	6442                	ld	s0,16(sp)
    8000137a:	64a2                	ld	s1,8(sp)
    8000137c:	6902                	ld	s2,0(sp)
    8000137e:	6105                	addi	sp,sp,32
    80001380:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001382:	4691                	li	a3,4
    80001384:	00b90633          	add	a2,s2,a1
    80001388:	6928                	ld	a0,80(a0)
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	52c080e7          	jalr	1324(ra) # 800008b6 <uvmalloc>
    80001392:	85aa                	mv	a1,a0
    80001394:	fd79                	bnez	a0,80001372 <growproc+0x22>
      return -1;
    80001396:	557d                	li	a0,-1
    80001398:	bff9                	j	80001376 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000139a:	00b90633          	add	a2,s2,a1
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	4ce080e7          	jalr	1230(ra) # 8000086e <uvmdealloc>
    800013a8:	85aa                	mv	a1,a0
    800013aa:	b7e1                	j	80001372 <growproc+0x22>

00000000800013ac <fork>:
{
    800013ac:	7139                	addi	sp,sp,-64
    800013ae:	fc06                	sd	ra,56(sp)
    800013b0:	f822                	sd	s0,48(sp)
    800013b2:	f426                	sd	s1,40(sp)
    800013b4:	f04a                	sd	s2,32(sp)
    800013b6:	ec4e                	sd	s3,24(sp)
    800013b8:	e852                	sd	s4,16(sp)
    800013ba:	e456                	sd	s5,8(sp)
    800013bc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	b8a080e7          	jalr	-1142(ra) # 80000f48 <myproc>
    800013c6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	e0e080e7          	jalr	-498(ra) # 800011d6 <allocproc>
    800013d0:	10050c63          	beqz	a0,800014e8 <fork+0x13c>
    800013d4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013d6:	048ab603          	ld	a2,72(s5)
    800013da:	692c                	ld	a1,80(a0)
    800013dc:	050ab503          	ld	a0,80(s5)
    800013e0:	fffff097          	auipc	ra,0xfffff
    800013e4:	62e080e7          	jalr	1582(ra) # 80000a0e <uvmcopy>
    800013e8:	04054863          	bltz	a0,80001438 <fork+0x8c>
  np->sz = p->sz;
    800013ec:	048ab783          	ld	a5,72(s5)
    800013f0:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013f4:	058ab683          	ld	a3,88(s5)
    800013f8:	87b6                	mv	a5,a3
    800013fa:	058a3703          	ld	a4,88(s4)
    800013fe:	12068693          	addi	a3,a3,288
    80001402:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001406:	6788                	ld	a0,8(a5)
    80001408:	6b8c                	ld	a1,16(a5)
    8000140a:	6f90                	ld	a2,24(a5)
    8000140c:	01073023          	sd	a6,0(a4)
    80001410:	e708                	sd	a0,8(a4)
    80001412:	eb0c                	sd	a1,16(a4)
    80001414:	ef10                	sd	a2,24(a4)
    80001416:	02078793          	addi	a5,a5,32
    8000141a:	02070713          	addi	a4,a4,32
    8000141e:	fed792e3          	bne	a5,a3,80001402 <fork+0x56>
  np->trapframe->a0 = 0;
    80001422:	058a3783          	ld	a5,88(s4)
    80001426:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000142a:	0d8a8493          	addi	s1,s5,216
    8000142e:	0d8a0913          	addi	s2,s4,216
    80001432:	158a8993          	addi	s3,s5,344
    80001436:	a00d                	j	80001458 <fork+0xac>
    freeproc(np);
    80001438:	8552                	mv	a0,s4
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	d34080e7          	jalr	-716(ra) # 8000116e <freeproc>
    release(&np->lock);
    80001442:	8552                	mv	a0,s4
    80001444:	00005097          	auipc	ra,0x5
    80001448:	e9e080e7          	jalr	-354(ra) # 800062e2 <release>
    return -1;
    8000144c:	597d                	li	s2,-1
    8000144e:	a059                	j	800014d4 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001450:	04a1                	addi	s1,s1,8
    80001452:	0921                	addi	s2,s2,8
    80001454:	01348b63          	beq	s1,s3,8000146a <fork+0xbe>
    if(p->ofile[i])
    80001458:	6088                	ld	a0,0(s1)
    8000145a:	d97d                	beqz	a0,80001450 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000145c:	00002097          	auipc	ra,0x2
    80001460:	63c080e7          	jalr	1596(ra) # 80003a98 <filedup>
    80001464:	00a93023          	sd	a0,0(s2)
    80001468:	b7e5                	j	80001450 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000146a:	158ab503          	ld	a0,344(s5)
    8000146e:	00001097          	auipc	ra,0x1
    80001472:	7d4080e7          	jalr	2004(ra) # 80002c42 <idup>
    80001476:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000147a:	4641                	li	a2,16
    8000147c:	160a8593          	addi	a1,s5,352
    80001480:	160a0513          	addi	a0,s4,352
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	e3e080e7          	jalr	-450(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    8000148c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001490:	8552                	mv	a0,s4
    80001492:	00005097          	auipc	ra,0x5
    80001496:	e50080e7          	jalr	-432(ra) # 800062e2 <release>
  acquire(&wait_lock);
    8000149a:	00007497          	auipc	s1,0x7
    8000149e:	4fe48493          	addi	s1,s1,1278 # 80008998 <wait_lock>
    800014a2:	8526                	mv	a0,s1
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	d8a080e7          	jalr	-630(ra) # 8000622e <acquire>
  np->parent = p;
    800014ac:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014b0:	8526                	mv	a0,s1
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	e30080e7          	jalr	-464(ra) # 800062e2 <release>
  acquire(&np->lock);
    800014ba:	8552                	mv	a0,s4
    800014bc:	00005097          	auipc	ra,0x5
    800014c0:	d72080e7          	jalr	-654(ra) # 8000622e <acquire>
  np->state = RUNNABLE;
    800014c4:	478d                	li	a5,3
    800014c6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014ca:	8552                	mv	a0,s4
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	e16080e7          	jalr	-490(ra) # 800062e2 <release>
}
    800014d4:	854a                	mv	a0,s2
    800014d6:	70e2                	ld	ra,56(sp)
    800014d8:	7442                	ld	s0,48(sp)
    800014da:	74a2                	ld	s1,40(sp)
    800014dc:	7902                	ld	s2,32(sp)
    800014de:	69e2                	ld	s3,24(sp)
    800014e0:	6a42                	ld	s4,16(sp)
    800014e2:	6aa2                	ld	s5,8(sp)
    800014e4:	6121                	addi	sp,sp,64
    800014e6:	8082                	ret
    return -1;
    800014e8:	597d                	li	s2,-1
    800014ea:	b7ed                	j	800014d4 <fork+0x128>

00000000800014ec <scheduler>:
{
    800014ec:	7139                	addi	sp,sp,-64
    800014ee:	fc06                	sd	ra,56(sp)
    800014f0:	f822                	sd	s0,48(sp)
    800014f2:	f426                	sd	s1,40(sp)
    800014f4:	f04a                	sd	s2,32(sp)
    800014f6:	ec4e                	sd	s3,24(sp)
    800014f8:	e852                	sd	s4,16(sp)
    800014fa:	e456                	sd	s5,8(sp)
    800014fc:	e05a                	sd	s6,0(sp)
    800014fe:	0080                	addi	s0,sp,64
    80001500:	8792                	mv	a5,tp
  int id = r_tp();
    80001502:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001504:	00779a93          	slli	s5,a5,0x7
    80001508:	00007717          	auipc	a4,0x7
    8000150c:	47870713          	addi	a4,a4,1144 # 80008980 <pid_lock>
    80001510:	9756                	add	a4,a4,s5
    80001512:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001516:	00007717          	auipc	a4,0x7
    8000151a:	4a270713          	addi	a4,a4,1186 # 800089b8 <cpus+0x8>
    8000151e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001520:	498d                	li	s3,3
        p->state = RUNNING;
    80001522:	4b11                	li	s6,4
        c->proc = p;
    80001524:	079e                	slli	a5,a5,0x7
    80001526:	00007a17          	auipc	s4,0x7
    8000152a:	45aa0a13          	addi	s4,s4,1114 # 80008980 <pid_lock>
    8000152e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001530:	0000d917          	auipc	s2,0xd
    80001534:	48090913          	addi	s2,s2,1152 # 8000e9b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001538:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001540:	10079073          	csrw	sstatus,a5
    80001544:	00008497          	auipc	s1,0x8
    80001548:	86c48493          	addi	s1,s1,-1940 # 80008db0 <proc>
    8000154c:	a811                	j	80001560 <scheduler+0x74>
      release(&p->lock);
    8000154e:	8526                	mv	a0,s1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	d92080e7          	jalr	-622(ra) # 800062e2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001558:	17048493          	addi	s1,s1,368
    8000155c:	fd248ee3          	beq	s1,s2,80001538 <scheduler+0x4c>
      acquire(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	ccc080e7          	jalr	-820(ra) # 8000622e <acquire>
      if(p->state == RUNNABLE) {
    8000156a:	4c9c                	lw	a5,24(s1)
    8000156c:	ff3791e3          	bne	a5,s3,8000154e <scheduler+0x62>
        p->state = RUNNING;
    80001570:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001574:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001578:	06848593          	addi	a1,s1,104
    8000157c:	8556                	mv	a0,s5
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	684080e7          	jalr	1668(ra) # 80001c02 <swtch>
        c->proc = 0;
    80001586:	020a3823          	sd	zero,48(s4)
    8000158a:	b7d1                	j	8000154e <scheduler+0x62>

000000008000158c <sched>:
{
    8000158c:	7179                	addi	sp,sp,-48
    8000158e:	f406                	sd	ra,40(sp)
    80001590:	f022                	sd	s0,32(sp)
    80001592:	ec26                	sd	s1,24(sp)
    80001594:	e84a                	sd	s2,16(sp)
    80001596:	e44e                	sd	s3,8(sp)
    80001598:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000159a:	00000097          	auipc	ra,0x0
    8000159e:	9ae080e7          	jalr	-1618(ra) # 80000f48 <myproc>
    800015a2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c10080e7          	jalr	-1008(ra) # 800061b4 <holding>
    800015ac:	c93d                	beqz	a0,80001622 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ae:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	00007717          	auipc	a4,0x7
    800015b8:	3cc70713          	addi	a4,a4,972 # 80008980 <pid_lock>
    800015bc:	97ba                	add	a5,a5,a4
    800015be:	0a87a703          	lw	a4,168(a5)
    800015c2:	4785                	li	a5,1
    800015c4:	06f71763          	bne	a4,a5,80001632 <sched+0xa6>
  if(p->state == RUNNING)
    800015c8:	4c98                	lw	a4,24(s1)
    800015ca:	4791                	li	a5,4
    800015cc:	06f70b63          	beq	a4,a5,80001642 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015d4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015d6:	efb5                	bnez	a5,80001652 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015da:	00007917          	auipc	s2,0x7
    800015de:	3a690913          	addi	s2,s2,934 # 80008980 <pid_lock>
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	97ca                	add	a5,a5,s2
    800015e8:	0ac7a983          	lw	s3,172(a5)
    800015ec:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ee:	2781                	sext.w	a5,a5
    800015f0:	079e                	slli	a5,a5,0x7
    800015f2:	00007597          	auipc	a1,0x7
    800015f6:	3c658593          	addi	a1,a1,966 # 800089b8 <cpus+0x8>
    800015fa:	95be                	add	a1,a1,a5
    800015fc:	06848513          	addi	a0,s1,104
    80001600:	00000097          	auipc	ra,0x0
    80001604:	602080e7          	jalr	1538(ra) # 80001c02 <swtch>
    80001608:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000160a:	2781                	sext.w	a5,a5
    8000160c:	079e                	slli	a5,a5,0x7
    8000160e:	993e                	add	s2,s2,a5
    80001610:	0b392623          	sw	s3,172(s2)
}
    80001614:	70a2                	ld	ra,40(sp)
    80001616:	7402                	ld	s0,32(sp)
    80001618:	64e2                	ld	s1,24(sp)
    8000161a:	6942                	ld	s2,16(sp)
    8000161c:	69a2                	ld	s3,8(sp)
    8000161e:	6145                	addi	sp,sp,48
    80001620:	8082                	ret
    panic("sched p->lock");
    80001622:	00007517          	auipc	a0,0x7
    80001626:	ba650513          	addi	a0,a0,-1114 # 800081c8 <etext+0x1c8>
    8000162a:	00004097          	auipc	ra,0x4
    8000162e:	6cc080e7          	jalr	1740(ra) # 80005cf6 <panic>
    panic("sched locks");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	ba650513          	addi	a0,a0,-1114 # 800081d8 <etext+0x1d8>
    8000163a:	00004097          	auipc	ra,0x4
    8000163e:	6bc080e7          	jalr	1724(ra) # 80005cf6 <panic>
    panic("sched running");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	ba650513          	addi	a0,a0,-1114 # 800081e8 <etext+0x1e8>
    8000164a:	00004097          	auipc	ra,0x4
    8000164e:	6ac080e7          	jalr	1708(ra) # 80005cf6 <panic>
    panic("sched interruptible");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	ba650513          	addi	a0,a0,-1114 # 800081f8 <etext+0x1f8>
    8000165a:	00004097          	auipc	ra,0x4
    8000165e:	69c080e7          	jalr	1692(ra) # 80005cf6 <panic>

0000000080001662 <yield>:
{
    80001662:	1101                	addi	sp,sp,-32
    80001664:	ec06                	sd	ra,24(sp)
    80001666:	e822                	sd	s0,16(sp)
    80001668:	e426                	sd	s1,8(sp)
    8000166a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	8dc080e7          	jalr	-1828(ra) # 80000f48 <myproc>
    80001674:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	bb8080e7          	jalr	-1096(ra) # 8000622e <acquire>
  p->state = RUNNABLE;
    8000167e:	478d                	li	a5,3
    80001680:	cc9c                	sw	a5,24(s1)
  sched();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	f0a080e7          	jalr	-246(ra) # 8000158c <sched>
  release(&p->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	c56080e7          	jalr	-938(ra) # 800062e2 <release>
}
    80001694:	60e2                	ld	ra,24(sp)
    80001696:	6442                	ld	s0,16(sp)
    80001698:	64a2                	ld	s1,8(sp)
    8000169a:	6105                	addi	sp,sp,32
    8000169c:	8082                	ret

000000008000169e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000169e:	7179                	addi	sp,sp,-48
    800016a0:	f406                	sd	ra,40(sp)
    800016a2:	f022                	sd	s0,32(sp)
    800016a4:	ec26                	sd	s1,24(sp)
    800016a6:	e84a                	sd	s2,16(sp)
    800016a8:	e44e                	sd	s3,8(sp)
    800016aa:	1800                	addi	s0,sp,48
    800016ac:	89aa                	mv	s3,a0
    800016ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016b0:	00000097          	auipc	ra,0x0
    800016b4:	898080e7          	jalr	-1896(ra) # 80000f48 <myproc>
    800016b8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	b74080e7          	jalr	-1164(ra) # 8000622e <acquire>
  release(lk);
    800016c2:	854a                	mv	a0,s2
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	c1e080e7          	jalr	-994(ra) # 800062e2 <release>

  // Go to sleep.
  p->chan = chan;
    800016cc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016d0:	4789                	li	a5,2
    800016d2:	cc9c                	sw	a5,24(s1)

  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	eb8080e7          	jalr	-328(ra) # 8000158c <sched>

  // Tidy up.
  p->chan = 0;
    800016dc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	c00080e7          	jalr	-1024(ra) # 800062e2 <release>
  acquire(lk);
    800016ea:	854a                	mv	a0,s2
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	b42080e7          	jalr	-1214(ra) # 8000622e <acquire>
}
    800016f4:	70a2                	ld	ra,40(sp)
    800016f6:	7402                	ld	s0,32(sp)
    800016f8:	64e2                	ld	s1,24(sp)
    800016fa:	6942                	ld	s2,16(sp)
    800016fc:	69a2                	ld	s3,8(sp)
    800016fe:	6145                	addi	sp,sp,48
    80001700:	8082                	ret

0000000080001702 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001702:	7139                	addi	sp,sp,-64
    80001704:	fc06                	sd	ra,56(sp)
    80001706:	f822                	sd	s0,48(sp)
    80001708:	f426                	sd	s1,40(sp)
    8000170a:	f04a                	sd	s2,32(sp)
    8000170c:	ec4e                	sd	s3,24(sp)
    8000170e:	e852                	sd	s4,16(sp)
    80001710:	e456                	sd	s5,8(sp)
    80001712:	0080                	addi	s0,sp,64
    80001714:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001716:	00007497          	auipc	s1,0x7
    8000171a:	69a48493          	addi	s1,s1,1690 # 80008db0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000171e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001720:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	0000d917          	auipc	s2,0xd
    80001726:	28e90913          	addi	s2,s2,654 # 8000e9b0 <tickslock>
    8000172a:	a811                	j	8000173e <wakeup+0x3c>
      }
      release(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	bb4080e7          	jalr	-1100(ra) # 800062e2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001736:	17048493          	addi	s1,s1,368
    8000173a:	03248663          	beq	s1,s2,80001766 <wakeup+0x64>
    if(p != myproc()){
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	80a080e7          	jalr	-2038(ra) # 80000f48 <myproc>
    80001746:	fea488e3          	beq	s1,a0,80001736 <wakeup+0x34>
      acquire(&p->lock);
    8000174a:	8526                	mv	a0,s1
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	ae2080e7          	jalr	-1310(ra) # 8000622e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001754:	4c9c                	lw	a5,24(s1)
    80001756:	fd379be3          	bne	a5,s3,8000172c <wakeup+0x2a>
    8000175a:	709c                	ld	a5,32(s1)
    8000175c:	fd4798e3          	bne	a5,s4,8000172c <wakeup+0x2a>
        p->state = RUNNABLE;
    80001760:	0154ac23          	sw	s5,24(s1)
    80001764:	b7e1                	j	8000172c <wakeup+0x2a>
    }
  }
}
    80001766:	70e2                	ld	ra,56(sp)
    80001768:	7442                	ld	s0,48(sp)
    8000176a:	74a2                	ld	s1,40(sp)
    8000176c:	7902                	ld	s2,32(sp)
    8000176e:	69e2                	ld	s3,24(sp)
    80001770:	6a42                	ld	s4,16(sp)
    80001772:	6aa2                	ld	s5,8(sp)
    80001774:	6121                	addi	sp,sp,64
    80001776:	8082                	ret

0000000080001778 <reparent>:
{
    80001778:	7179                	addi	sp,sp,-48
    8000177a:	f406                	sd	ra,40(sp)
    8000177c:	f022                	sd	s0,32(sp)
    8000177e:	ec26                	sd	s1,24(sp)
    80001780:	e84a                	sd	s2,16(sp)
    80001782:	e44e                	sd	s3,8(sp)
    80001784:	e052                	sd	s4,0(sp)
    80001786:	1800                	addi	s0,sp,48
    80001788:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178a:	00007497          	auipc	s1,0x7
    8000178e:	62648493          	addi	s1,s1,1574 # 80008db0 <proc>
      pp->parent = initproc;
    80001792:	00007a17          	auipc	s4,0x7
    80001796:	1aea0a13          	addi	s4,s4,430 # 80008940 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179a:	0000d997          	auipc	s3,0xd
    8000179e:	21698993          	addi	s3,s3,534 # 8000e9b0 <tickslock>
    800017a2:	a029                	j	800017ac <reparent+0x34>
    800017a4:	17048493          	addi	s1,s1,368
    800017a8:	01348d63          	beq	s1,s3,800017c2 <reparent+0x4a>
    if(pp->parent == p){
    800017ac:	7c9c                	ld	a5,56(s1)
    800017ae:	ff279be3          	bne	a5,s2,800017a4 <reparent+0x2c>
      pp->parent = initproc;
    800017b2:	000a3503          	ld	a0,0(s4)
    800017b6:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017b8:	00000097          	auipc	ra,0x0
    800017bc:	f4a080e7          	jalr	-182(ra) # 80001702 <wakeup>
    800017c0:	b7d5                	j	800017a4 <reparent+0x2c>
}
    800017c2:	70a2                	ld	ra,40(sp)
    800017c4:	7402                	ld	s0,32(sp)
    800017c6:	64e2                	ld	s1,24(sp)
    800017c8:	6942                	ld	s2,16(sp)
    800017ca:	69a2                	ld	s3,8(sp)
    800017cc:	6a02                	ld	s4,0(sp)
    800017ce:	6145                	addi	sp,sp,48
    800017d0:	8082                	ret

00000000800017d2 <exit>:
{
    800017d2:	7179                	addi	sp,sp,-48
    800017d4:	f406                	sd	ra,40(sp)
    800017d6:	f022                	sd	s0,32(sp)
    800017d8:	ec26                	sd	s1,24(sp)
    800017da:	e84a                	sd	s2,16(sp)
    800017dc:	e44e                	sd	s3,8(sp)
    800017de:	e052                	sd	s4,0(sp)
    800017e0:	1800                	addi	s0,sp,48
    800017e2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	764080e7          	jalr	1892(ra) # 80000f48 <myproc>
    800017ec:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ee:	00007797          	auipc	a5,0x7
    800017f2:	1527b783          	ld	a5,338(a5) # 80008940 <initproc>
    800017f6:	0d850493          	addi	s1,a0,216
    800017fa:	15850913          	addi	s2,a0,344
    800017fe:	02a79363          	bne	a5,a0,80001824 <exit+0x52>
    panic("init exiting");
    80001802:	00007517          	auipc	a0,0x7
    80001806:	a0e50513          	addi	a0,a0,-1522 # 80008210 <etext+0x210>
    8000180a:	00004097          	auipc	ra,0x4
    8000180e:	4ec080e7          	jalr	1260(ra) # 80005cf6 <panic>
      fileclose(f);
    80001812:	00002097          	auipc	ra,0x2
    80001816:	2d8080e7          	jalr	728(ra) # 80003aea <fileclose>
      p->ofile[fd] = 0;
    8000181a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000181e:	04a1                	addi	s1,s1,8
    80001820:	01248563          	beq	s1,s2,8000182a <exit+0x58>
    if(p->ofile[fd]){
    80001824:	6088                	ld	a0,0(s1)
    80001826:	f575                	bnez	a0,80001812 <exit+0x40>
    80001828:	bfdd                	j	8000181e <exit+0x4c>
  begin_op();
    8000182a:	00002097          	auipc	ra,0x2
    8000182e:	dfc080e7          	jalr	-516(ra) # 80003626 <begin_op>
  iput(p->cwd);
    80001832:	1589b503          	ld	a0,344(s3)
    80001836:	00001097          	auipc	ra,0x1
    8000183a:	604080e7          	jalr	1540(ra) # 80002e3a <iput>
  end_op();
    8000183e:	00002097          	auipc	ra,0x2
    80001842:	e62080e7          	jalr	-414(ra) # 800036a0 <end_op>
  p->cwd = 0;
    80001846:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000184a:	00007497          	auipc	s1,0x7
    8000184e:	14e48493          	addi	s1,s1,334 # 80008998 <wait_lock>
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	9da080e7          	jalr	-1574(ra) # 8000622e <acquire>
  reparent(p);
    8000185c:	854e                	mv	a0,s3
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	f1a080e7          	jalr	-230(ra) # 80001778 <reparent>
  wakeup(p->parent);
    80001866:	0389b503          	ld	a0,56(s3)
    8000186a:	00000097          	auipc	ra,0x0
    8000186e:	e98080e7          	jalr	-360(ra) # 80001702 <wakeup>
  acquire(&p->lock);
    80001872:	854e                	mv	a0,s3
    80001874:	00005097          	auipc	ra,0x5
    80001878:	9ba080e7          	jalr	-1606(ra) # 8000622e <acquire>
  p->xstate = status;
    8000187c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001880:	4795                	li	a5,5
    80001882:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	a5a080e7          	jalr	-1446(ra) # 800062e2 <release>
  sched();
    80001890:	00000097          	auipc	ra,0x0
    80001894:	cfc080e7          	jalr	-772(ra) # 8000158c <sched>
  panic("zombie exit");
    80001898:	00007517          	auipc	a0,0x7
    8000189c:	98850513          	addi	a0,a0,-1656 # 80008220 <etext+0x220>
    800018a0:	00004097          	auipc	ra,0x4
    800018a4:	456080e7          	jalr	1110(ra) # 80005cf6 <panic>

00000000800018a8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	1800                	addi	s0,sp,48
    800018b6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018b8:	00007497          	auipc	s1,0x7
    800018bc:	4f848493          	addi	s1,s1,1272 # 80008db0 <proc>
    800018c0:	0000d997          	auipc	s3,0xd
    800018c4:	0f098993          	addi	s3,s3,240 # 8000e9b0 <tickslock>
    acquire(&p->lock);
    800018c8:	8526                	mv	a0,s1
    800018ca:	00005097          	auipc	ra,0x5
    800018ce:	964080e7          	jalr	-1692(ra) # 8000622e <acquire>
    if(p->pid == pid){
    800018d2:	589c                	lw	a5,48(s1)
    800018d4:	01278d63          	beq	a5,s2,800018ee <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	a08080e7          	jalr	-1528(ra) # 800062e2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018e2:	17048493          	addi	s1,s1,368
    800018e6:	ff3491e3          	bne	s1,s3,800018c8 <kill+0x20>
  }
  return -1;
    800018ea:	557d                	li	a0,-1
    800018ec:	a829                	j	80001906 <kill+0x5e>
      p->killed = 1;
    800018ee:	4785                	li	a5,1
    800018f0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018f2:	4c98                	lw	a4,24(s1)
    800018f4:	4789                	li	a5,2
    800018f6:	00f70f63          	beq	a4,a5,80001914 <kill+0x6c>
      release(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	9e6080e7          	jalr	-1562(ra) # 800062e2 <release>
      return 0;
    80001904:	4501                	li	a0,0
}
    80001906:	70a2                	ld	ra,40(sp)
    80001908:	7402                	ld	s0,32(sp)
    8000190a:	64e2                	ld	s1,24(sp)
    8000190c:	6942                	ld	s2,16(sp)
    8000190e:	69a2                	ld	s3,8(sp)
    80001910:	6145                	addi	sp,sp,48
    80001912:	8082                	ret
        p->state = RUNNABLE;
    80001914:	478d                	li	a5,3
    80001916:	cc9c                	sw	a5,24(s1)
    80001918:	b7cd                	j	800018fa <kill+0x52>

000000008000191a <setkilled>:

void
setkilled(struct proc *p)
{
    8000191a:	1101                	addi	sp,sp,-32
    8000191c:	ec06                	sd	ra,24(sp)
    8000191e:	e822                	sd	s0,16(sp)
    80001920:	e426                	sd	s1,8(sp)
    80001922:	1000                	addi	s0,sp,32
    80001924:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	908080e7          	jalr	-1784(ra) # 8000622e <acquire>
  p->killed = 1;
    8000192e:	4785                	li	a5,1
    80001930:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	9ae080e7          	jalr	-1618(ra) # 800062e2 <release>
}
    8000193c:	60e2                	ld	ra,24(sp)
    8000193e:	6442                	ld	s0,16(sp)
    80001940:	64a2                	ld	s1,8(sp)
    80001942:	6105                	addi	sp,sp,32
    80001944:	8082                	ret

0000000080001946 <killed>:

int
killed(struct proc *p)
{
    80001946:	1101                	addi	sp,sp,-32
    80001948:	ec06                	sd	ra,24(sp)
    8000194a:	e822                	sd	s0,16(sp)
    8000194c:	e426                	sd	s1,8(sp)
    8000194e:	e04a                	sd	s2,0(sp)
    80001950:	1000                	addi	s0,sp,32
    80001952:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001954:	00005097          	auipc	ra,0x5
    80001958:	8da080e7          	jalr	-1830(ra) # 8000622e <acquire>
  k = p->killed;
    8000195c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	00005097          	auipc	ra,0x5
    80001966:	980080e7          	jalr	-1664(ra) # 800062e2 <release>
  return k;
}
    8000196a:	854a                	mv	a0,s2
    8000196c:	60e2                	ld	ra,24(sp)
    8000196e:	6442                	ld	s0,16(sp)
    80001970:	64a2                	ld	s1,8(sp)
    80001972:	6902                	ld	s2,0(sp)
    80001974:	6105                	addi	sp,sp,32
    80001976:	8082                	ret

0000000080001978 <wait>:
{
    80001978:	715d                	addi	sp,sp,-80
    8000197a:	e486                	sd	ra,72(sp)
    8000197c:	e0a2                	sd	s0,64(sp)
    8000197e:	fc26                	sd	s1,56(sp)
    80001980:	f84a                	sd	s2,48(sp)
    80001982:	f44e                	sd	s3,40(sp)
    80001984:	f052                	sd	s4,32(sp)
    80001986:	ec56                	sd	s5,24(sp)
    80001988:	e85a                	sd	s6,16(sp)
    8000198a:	e45e                	sd	s7,8(sp)
    8000198c:	e062                	sd	s8,0(sp)
    8000198e:	0880                	addi	s0,sp,80
    80001990:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	5b6080e7          	jalr	1462(ra) # 80000f48 <myproc>
    8000199a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000199c:	00007517          	auipc	a0,0x7
    800019a0:	ffc50513          	addi	a0,a0,-4 # 80008998 <wait_lock>
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	88a080e7          	jalr	-1910(ra) # 8000622e <acquire>
    havekids = 0;
    800019ac:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019ae:	4a15                	li	s4,5
        havekids = 1;
    800019b0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019b2:	0000d997          	auipc	s3,0xd
    800019b6:	ffe98993          	addi	s3,s3,-2 # 8000e9b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019ba:	00007c17          	auipc	s8,0x7
    800019be:	fdec0c13          	addi	s8,s8,-34 # 80008998 <wait_lock>
    800019c2:	a0d1                	j	80001a86 <wait+0x10e>
          pid = pp->pid;
    800019c4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019c8:	000b0e63          	beqz	s6,800019e4 <wait+0x6c>
    800019cc:	4691                	li	a3,4
    800019ce:	02c48613          	addi	a2,s1,44
    800019d2:	85da                	mv	a1,s6
    800019d4:	05093503          	ld	a0,80(s2)
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	13a080e7          	jalr	314(ra) # 80000b12 <copyout>
    800019e0:	04054163          	bltz	a0,80001a22 <wait+0xaa>
          freeproc(pp);
    800019e4:	8526                	mv	a0,s1
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	788080e7          	jalr	1928(ra) # 8000116e <freeproc>
          release(&pp->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	8f2080e7          	jalr	-1806(ra) # 800062e2 <release>
          release(&wait_lock);
    800019f8:	00007517          	auipc	a0,0x7
    800019fc:	fa050513          	addi	a0,a0,-96 # 80008998 <wait_lock>
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	8e2080e7          	jalr	-1822(ra) # 800062e2 <release>
}
    80001a08:	854e                	mv	a0,s3
    80001a0a:	60a6                	ld	ra,72(sp)
    80001a0c:	6406                	ld	s0,64(sp)
    80001a0e:	74e2                	ld	s1,56(sp)
    80001a10:	7942                	ld	s2,48(sp)
    80001a12:	79a2                	ld	s3,40(sp)
    80001a14:	7a02                	ld	s4,32(sp)
    80001a16:	6ae2                	ld	s5,24(sp)
    80001a18:	6b42                	ld	s6,16(sp)
    80001a1a:	6ba2                	ld	s7,8(sp)
    80001a1c:	6c02                	ld	s8,0(sp)
    80001a1e:	6161                	addi	sp,sp,80
    80001a20:	8082                	ret
            release(&pp->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	8be080e7          	jalr	-1858(ra) # 800062e2 <release>
            release(&wait_lock);
    80001a2c:	00007517          	auipc	a0,0x7
    80001a30:	f6c50513          	addi	a0,a0,-148 # 80008998 <wait_lock>
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	8ae080e7          	jalr	-1874(ra) # 800062e2 <release>
            return -1;
    80001a3c:	59fd                	li	s3,-1
    80001a3e:	b7e9                	j	80001a08 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a40:	17048493          	addi	s1,s1,368
    80001a44:	03348463          	beq	s1,s3,80001a6c <wait+0xf4>
      if(pp->parent == p){
    80001a48:	7c9c                	ld	a5,56(s1)
    80001a4a:	ff279be3          	bne	a5,s2,80001a40 <wait+0xc8>
        acquire(&pp->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	00004097          	auipc	ra,0x4
    80001a54:	7de080e7          	jalr	2014(ra) # 8000622e <acquire>
        if(pp->state == ZOMBIE){
    80001a58:	4c9c                	lw	a5,24(s1)
    80001a5a:	f74785e3          	beq	a5,s4,800019c4 <wait+0x4c>
        release(&pp->lock);
    80001a5e:	8526                	mv	a0,s1
    80001a60:	00005097          	auipc	ra,0x5
    80001a64:	882080e7          	jalr	-1918(ra) # 800062e2 <release>
        havekids = 1;
    80001a68:	8756                	mv	a4,s5
    80001a6a:	bfd9                	j	80001a40 <wait+0xc8>
    if(!havekids || killed(p)){
    80001a6c:	c31d                	beqz	a4,80001a92 <wait+0x11a>
    80001a6e:	854a                	mv	a0,s2
    80001a70:	00000097          	auipc	ra,0x0
    80001a74:	ed6080e7          	jalr	-298(ra) # 80001946 <killed>
    80001a78:	ed09                	bnez	a0,80001a92 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a7a:	85e2                	mv	a1,s8
    80001a7c:	854a                	mv	a0,s2
    80001a7e:	00000097          	auipc	ra,0x0
    80001a82:	c20080e7          	jalr	-992(ra) # 8000169e <sleep>
    havekids = 0;
    80001a86:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a88:	00007497          	auipc	s1,0x7
    80001a8c:	32848493          	addi	s1,s1,808 # 80008db0 <proc>
    80001a90:	bf65                	j	80001a48 <wait+0xd0>
      release(&wait_lock);
    80001a92:	00007517          	auipc	a0,0x7
    80001a96:	f0650513          	addi	a0,a0,-250 # 80008998 <wait_lock>
    80001a9a:	00005097          	auipc	ra,0x5
    80001a9e:	848080e7          	jalr	-1976(ra) # 800062e2 <release>
      return -1;
    80001aa2:	59fd                	li	s3,-1
    80001aa4:	b795                	j	80001a08 <wait+0x90>

0000000080001aa6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aa6:	7179                	addi	sp,sp,-48
    80001aa8:	f406                	sd	ra,40(sp)
    80001aaa:	f022                	sd	s0,32(sp)
    80001aac:	ec26                	sd	s1,24(sp)
    80001aae:	e84a                	sd	s2,16(sp)
    80001ab0:	e44e                	sd	s3,8(sp)
    80001ab2:	e052                	sd	s4,0(sp)
    80001ab4:	1800                	addi	s0,sp,48
    80001ab6:	84aa                	mv	s1,a0
    80001ab8:	892e                	mv	s2,a1
    80001aba:	89b2                	mv	s3,a2
    80001abc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	48a080e7          	jalr	1162(ra) # 80000f48 <myproc>
  if(user_dst){
    80001ac6:	c08d                	beqz	s1,80001ae8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ac8:	86d2                	mv	a3,s4
    80001aca:	864e                	mv	a2,s3
    80001acc:	85ca                	mv	a1,s2
    80001ace:	6928                	ld	a0,80(a0)
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	042080e7          	jalr	66(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ad8:	70a2                	ld	ra,40(sp)
    80001ada:	7402                	ld	s0,32(sp)
    80001adc:	64e2                	ld	s1,24(sp)
    80001ade:	6942                	ld	s2,16(sp)
    80001ae0:	69a2                	ld	s3,8(sp)
    80001ae2:	6a02                	ld	s4,0(sp)
    80001ae4:	6145                	addi	sp,sp,48
    80001ae6:	8082                	ret
    memmove((char *)dst, src, len);
    80001ae8:	000a061b          	sext.w	a2,s4
    80001aec:	85ce                	mv	a1,s3
    80001aee:	854a                	mv	a0,s2
    80001af0:	ffffe097          	auipc	ra,0xffffe
    80001af4:	6e6080e7          	jalr	1766(ra) # 800001d6 <memmove>
    return 0;
    80001af8:	8526                	mv	a0,s1
    80001afa:	bff9                	j	80001ad8 <either_copyout+0x32>

0000000080001afc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001afc:	7179                	addi	sp,sp,-48
    80001afe:	f406                	sd	ra,40(sp)
    80001b00:	f022                	sd	s0,32(sp)
    80001b02:	ec26                	sd	s1,24(sp)
    80001b04:	e84a                	sd	s2,16(sp)
    80001b06:	e44e                	sd	s3,8(sp)
    80001b08:	e052                	sd	s4,0(sp)
    80001b0a:	1800                	addi	s0,sp,48
    80001b0c:	892a                	mv	s2,a0
    80001b0e:	84ae                	mv	s1,a1
    80001b10:	89b2                	mv	s3,a2
    80001b12:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	434080e7          	jalr	1076(ra) # 80000f48 <myproc>
  if(user_src){
    80001b1c:	c08d                	beqz	s1,80001b3e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b1e:	86d2                	mv	a3,s4
    80001b20:	864e                	mv	a2,s3
    80001b22:	85ca                	mv	a1,s2
    80001b24:	6928                	ld	a0,80(a0)
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	078080e7          	jalr	120(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b2e:	70a2                	ld	ra,40(sp)
    80001b30:	7402                	ld	s0,32(sp)
    80001b32:	64e2                	ld	s1,24(sp)
    80001b34:	6942                	ld	s2,16(sp)
    80001b36:	69a2                	ld	s3,8(sp)
    80001b38:	6a02                	ld	s4,0(sp)
    80001b3a:	6145                	addi	sp,sp,48
    80001b3c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b3e:	000a061b          	sext.w	a2,s4
    80001b42:	85ce                	mv	a1,s3
    80001b44:	854a                	mv	a0,s2
    80001b46:	ffffe097          	auipc	ra,0xffffe
    80001b4a:	690080e7          	jalr	1680(ra) # 800001d6 <memmove>
    return 0;
    80001b4e:	8526                	mv	a0,s1
    80001b50:	bff9                	j	80001b2e <either_copyin+0x32>

0000000080001b52 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b52:	715d                	addi	sp,sp,-80
    80001b54:	e486                	sd	ra,72(sp)
    80001b56:	e0a2                	sd	s0,64(sp)
    80001b58:	fc26                	sd	s1,56(sp)
    80001b5a:	f84a                	sd	s2,48(sp)
    80001b5c:	f44e                	sd	s3,40(sp)
    80001b5e:	f052                	sd	s4,32(sp)
    80001b60:	ec56                	sd	s5,24(sp)
    80001b62:	e85a                	sd	s6,16(sp)
    80001b64:	e45e                	sd	s7,8(sp)
    80001b66:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b68:	00006517          	auipc	a0,0x6
    80001b6c:	4e050513          	addi	a0,a0,1248 # 80008048 <etext+0x48>
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	1d0080e7          	jalr	464(ra) # 80005d40 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b78:	00007497          	auipc	s1,0x7
    80001b7c:	39848493          	addi	s1,s1,920 # 80008f10 <proc+0x160>
    80001b80:	0000d917          	auipc	s2,0xd
    80001b84:	f9090913          	addi	s2,s2,-112 # 8000eb10 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b88:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b8a:	00006997          	auipc	s3,0x6
    80001b8e:	6a698993          	addi	s3,s3,1702 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b92:	00006a97          	auipc	s5,0x6
    80001b96:	6a6a8a93          	addi	s5,s5,1702 # 80008238 <etext+0x238>
    printf("\n");
    80001b9a:	00006a17          	auipc	s4,0x6
    80001b9e:	4aea0a13          	addi	s4,s4,1198 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba2:	00006b97          	auipc	s7,0x6
    80001ba6:	6d6b8b93          	addi	s7,s7,1750 # 80008278 <states.0>
    80001baa:	a00d                	j	80001bcc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bac:	ed06a583          	lw	a1,-304(a3)
    80001bb0:	8556                	mv	a0,s5
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	18e080e7          	jalr	398(ra) # 80005d40 <printf>
    printf("\n");
    80001bba:	8552                	mv	a0,s4
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	184080e7          	jalr	388(ra) # 80005d40 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bc4:	17048493          	addi	s1,s1,368
    80001bc8:	03248263          	beq	s1,s2,80001bec <procdump+0x9a>
    if(p->state == UNUSED)
    80001bcc:	86a6                	mv	a3,s1
    80001bce:	eb84a783          	lw	a5,-328(s1)
    80001bd2:	dbed                	beqz	a5,80001bc4 <procdump+0x72>
      state = "???";
    80001bd4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd6:	fcfb6be3          	bltu	s6,a5,80001bac <procdump+0x5a>
    80001bda:	02079713          	slli	a4,a5,0x20
    80001bde:	01d75793          	srli	a5,a4,0x1d
    80001be2:	97de                	add	a5,a5,s7
    80001be4:	6390                	ld	a2,0(a5)
    80001be6:	f279                	bnez	a2,80001bac <procdump+0x5a>
      state = "???";
    80001be8:	864e                	mv	a2,s3
    80001bea:	b7c9                	j	80001bac <procdump+0x5a>
  }
}
    80001bec:	60a6                	ld	ra,72(sp)
    80001bee:	6406                	ld	s0,64(sp)
    80001bf0:	74e2                	ld	s1,56(sp)
    80001bf2:	7942                	ld	s2,48(sp)
    80001bf4:	79a2                	ld	s3,40(sp)
    80001bf6:	7a02                	ld	s4,32(sp)
    80001bf8:	6ae2                	ld	s5,24(sp)
    80001bfa:	6b42                	ld	s6,16(sp)
    80001bfc:	6ba2                	ld	s7,8(sp)
    80001bfe:	6161                	addi	sp,sp,80
    80001c00:	8082                	ret

0000000080001c02 <swtch>:
    80001c02:	00153023          	sd	ra,0(a0)
    80001c06:	00253423          	sd	sp,8(a0)
    80001c0a:	e900                	sd	s0,16(a0)
    80001c0c:	ed04                	sd	s1,24(a0)
    80001c0e:	03253023          	sd	s2,32(a0)
    80001c12:	03353423          	sd	s3,40(a0)
    80001c16:	03453823          	sd	s4,48(a0)
    80001c1a:	03553c23          	sd	s5,56(a0)
    80001c1e:	05653023          	sd	s6,64(a0)
    80001c22:	05753423          	sd	s7,72(a0)
    80001c26:	05853823          	sd	s8,80(a0)
    80001c2a:	05953c23          	sd	s9,88(a0)
    80001c2e:	07a53023          	sd	s10,96(a0)
    80001c32:	07b53423          	sd	s11,104(a0)
    80001c36:	0005b083          	ld	ra,0(a1)
    80001c3a:	0085b103          	ld	sp,8(a1)
    80001c3e:	6980                	ld	s0,16(a1)
    80001c40:	6d84                	ld	s1,24(a1)
    80001c42:	0205b903          	ld	s2,32(a1)
    80001c46:	0285b983          	ld	s3,40(a1)
    80001c4a:	0305ba03          	ld	s4,48(a1)
    80001c4e:	0385ba83          	ld	s5,56(a1)
    80001c52:	0405bb03          	ld	s6,64(a1)
    80001c56:	0485bb83          	ld	s7,72(a1)
    80001c5a:	0505bc03          	ld	s8,80(a1)
    80001c5e:	0585bc83          	ld	s9,88(a1)
    80001c62:	0605bd03          	ld	s10,96(a1)
    80001c66:	0685bd83          	ld	s11,104(a1)
    80001c6a:	8082                	ret

0000000080001c6c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c6c:	1141                	addi	sp,sp,-16
    80001c6e:	e406                	sd	ra,8(sp)
    80001c70:	e022                	sd	s0,0(sp)
    80001c72:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c74:	00006597          	auipc	a1,0x6
    80001c78:	63458593          	addi	a1,a1,1588 # 800082a8 <states.0+0x30>
    80001c7c:	0000d517          	auipc	a0,0xd
    80001c80:	d3450513          	addi	a0,a0,-716 # 8000e9b0 <tickslock>
    80001c84:	00004097          	auipc	ra,0x4
    80001c88:	51a080e7          	jalr	1306(ra) # 8000619e <initlock>
}
    80001c8c:	60a2                	ld	ra,8(sp)
    80001c8e:	6402                	ld	s0,0(sp)
    80001c90:	0141                	addi	sp,sp,16
    80001c92:	8082                	ret

0000000080001c94 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c94:	1141                	addi	sp,sp,-16
    80001c96:	e422                	sd	s0,8(sp)
    80001c98:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9a:	00003797          	auipc	a5,0x3
    80001c9e:	49678793          	addi	a5,a5,1174 # 80005130 <kernelvec>
    80001ca2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ca6:	6422                	ld	s0,8(sp)
    80001ca8:	0141                	addi	sp,sp,16
    80001caa:	8082                	ret

0000000080001cac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cac:	1141                	addi	sp,sp,-16
    80001cae:	e406                	sd	ra,8(sp)
    80001cb0:	e022                	sd	s0,0(sp)
    80001cb2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	294080e7          	jalr	660(ra) # 80000f48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cc0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cc6:	00005697          	auipc	a3,0x5
    80001cca:	33a68693          	addi	a3,a3,826 # 80007000 <_trampoline>
    80001cce:	00005717          	auipc	a4,0x5
    80001cd2:	33270713          	addi	a4,a4,818 # 80007000 <_trampoline>
    80001cd6:	8f15                	sub	a4,a4,a3
    80001cd8:	040007b7          	lui	a5,0x4000
    80001cdc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cde:	07b2                	slli	a5,a5,0xc
    80001ce0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ce2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ce6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ce8:	18002673          	csrr	a2,satp
    80001cec:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cee:	6d30                	ld	a2,88(a0)
    80001cf0:	6138                	ld	a4,64(a0)
    80001cf2:	6585                	lui	a1,0x1
    80001cf4:	972e                	add	a4,a4,a1
    80001cf6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cf8:	6d38                	ld	a4,88(a0)
    80001cfa:	00000617          	auipc	a2,0x0
    80001cfe:	13460613          	addi	a2,a2,308 # 80001e2e <usertrap>
    80001d02:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d04:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d06:	8612                	mv	a2,tp
    80001d08:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d0e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d12:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d16:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d1a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d1c:	6f18                	ld	a4,24(a4)
    80001d1e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d22:	6928                	ld	a0,80(a0)
    80001d24:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d26:	00005717          	auipc	a4,0x5
    80001d2a:	37670713          	addi	a4,a4,886 # 8000709c <userret>
    80001d2e:	8f15                	sub	a4,a4,a3
    80001d30:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d32:	577d                	li	a4,-1
    80001d34:	177e                	slli	a4,a4,0x3f
    80001d36:	8d59                	or	a0,a0,a4
    80001d38:	9782                	jalr	a5
}
    80001d3a:	60a2                	ld	ra,8(sp)
    80001d3c:	6402                	ld	s0,0(sp)
    80001d3e:	0141                	addi	sp,sp,16
    80001d40:	8082                	ret

0000000080001d42 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d42:	1101                	addi	sp,sp,-32
    80001d44:	ec06                	sd	ra,24(sp)
    80001d46:	e822                	sd	s0,16(sp)
    80001d48:	e426                	sd	s1,8(sp)
    80001d4a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d4c:	0000d497          	auipc	s1,0xd
    80001d50:	c6448493          	addi	s1,s1,-924 # 8000e9b0 <tickslock>
    80001d54:	8526                	mv	a0,s1
    80001d56:	00004097          	auipc	ra,0x4
    80001d5a:	4d8080e7          	jalr	1240(ra) # 8000622e <acquire>
  ticks++;
    80001d5e:	00007517          	auipc	a0,0x7
    80001d62:	bea50513          	addi	a0,a0,-1046 # 80008948 <ticks>
    80001d66:	411c                	lw	a5,0(a0)
    80001d68:	2785                	addiw	a5,a5,1
    80001d6a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	996080e7          	jalr	-1642(ra) # 80001702 <wakeup>
  release(&tickslock);
    80001d74:	8526                	mv	a0,s1
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	56c080e7          	jalr	1388(ra) # 800062e2 <release>
}
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	64a2                	ld	s1,8(sp)
    80001d84:	6105                	addi	sp,sp,32
    80001d86:	8082                	ret

0000000080001d88 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d88:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d8c:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d8e:	0807df63          	bgez	a5,80001e2c <devintr+0xa4>
{
    80001d92:	1101                	addi	sp,sp,-32
    80001d94:	ec06                	sd	ra,24(sp)
    80001d96:	e822                	sd	s0,16(sp)
    80001d98:	e426                	sd	s1,8(sp)
    80001d9a:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001d9c:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001da0:	46a5                	li	a3,9
    80001da2:	00d70d63          	beq	a4,a3,80001dbc <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001da6:	577d                	li	a4,-1
    80001da8:	177e                	slli	a4,a4,0x3f
    80001daa:	0705                	addi	a4,a4,1
    return 0;
    80001dac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dae:	04e78e63          	beq	a5,a4,80001e0a <devintr+0x82>
  }
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret
    int irq = plic_claim();
    80001dbc:	00003097          	auipc	ra,0x3
    80001dc0:	47c080e7          	jalr	1148(ra) # 80005238 <plic_claim>
    80001dc4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dc6:	47a9                	li	a5,10
    80001dc8:	02f50763          	beq	a0,a5,80001df6 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001dcc:	4785                	li	a5,1
    80001dce:	02f50963          	beq	a0,a5,80001e00 <devintr+0x78>
    return 1;
    80001dd2:	4505                	li	a0,1
    } else if(irq){
    80001dd4:	dcf9                	beqz	s1,80001db2 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dd6:	85a6                	mv	a1,s1
    80001dd8:	00006517          	auipc	a0,0x6
    80001ddc:	4d850513          	addi	a0,a0,1240 # 800082b0 <states.0+0x38>
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	f60080e7          	jalr	-160(ra) # 80005d40 <printf>
      plic_complete(irq);
    80001de8:	8526                	mv	a0,s1
    80001dea:	00003097          	auipc	ra,0x3
    80001dee:	472080e7          	jalr	1138(ra) # 8000525c <plic_complete>
    return 1;
    80001df2:	4505                	li	a0,1
    80001df4:	bf7d                	j	80001db2 <devintr+0x2a>
      uartintr();
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	358080e7          	jalr	856(ra) # 8000614e <uartintr>
    if(irq)
    80001dfe:	b7ed                	j	80001de8 <devintr+0x60>
      virtio_disk_intr();
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	922080e7          	jalr	-1758(ra) # 80005722 <virtio_disk_intr>
    if(irq)
    80001e08:	b7c5                	j	80001de8 <devintr+0x60>
    if(cpuid() == 0){
    80001e0a:	fffff097          	auipc	ra,0xfffff
    80001e0e:	112080e7          	jalr	274(ra) # 80000f1c <cpuid>
    80001e12:	c901                	beqz	a0,80001e22 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e14:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e1a:	14479073          	csrw	sip,a5
    return 2;
    80001e1e:	4509                	li	a0,2
    80001e20:	bf49                	j	80001db2 <devintr+0x2a>
      clockintr();
    80001e22:	00000097          	auipc	ra,0x0
    80001e26:	f20080e7          	jalr	-224(ra) # 80001d42 <clockintr>
    80001e2a:	b7ed                	j	80001e14 <devintr+0x8c>
}
    80001e2c:	8082                	ret

0000000080001e2e <usertrap>:
{
    80001e2e:	1101                	addi	sp,sp,-32
    80001e30:	ec06                	sd	ra,24(sp)
    80001e32:	e822                	sd	s0,16(sp)
    80001e34:	e426                	sd	s1,8(sp)
    80001e36:	e04a                	sd	s2,0(sp)
    80001e38:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e3e:	1007f793          	andi	a5,a5,256
    80001e42:	e3b1                	bnez	a5,80001e86 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e44:	00003797          	auipc	a5,0x3
    80001e48:	2ec78793          	addi	a5,a5,748 # 80005130 <kernelvec>
    80001e4c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	0f8080e7          	jalr	248(ra) # 80000f48 <myproc>
    80001e58:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e5a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e5c:	14102773          	csrr	a4,sepc
    80001e60:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e62:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e66:	47a1                	li	a5,8
    80001e68:	02f70763          	beq	a4,a5,80001e96 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	f1c080e7          	jalr	-228(ra) # 80001d88 <devintr>
    80001e74:	892a                	mv	s2,a0
    80001e76:	c151                	beqz	a0,80001efa <usertrap+0xcc>
  if(killed(p))
    80001e78:	8526                	mv	a0,s1
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	acc080e7          	jalr	-1332(ra) # 80001946 <killed>
    80001e82:	c929                	beqz	a0,80001ed4 <usertrap+0xa6>
    80001e84:	a099                	j	80001eca <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e86:	00006517          	auipc	a0,0x6
    80001e8a:	44a50513          	addi	a0,a0,1098 # 800082d0 <states.0+0x58>
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	e68080e7          	jalr	-408(ra) # 80005cf6 <panic>
    if(killed(p))
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	ab0080e7          	jalr	-1360(ra) # 80001946 <killed>
    80001e9e:	e921                	bnez	a0,80001eee <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001ea0:	6cb8                	ld	a4,88(s1)
    80001ea2:	6f1c                	ld	a5,24(a4)
    80001ea4:	0791                	addi	a5,a5,4
    80001ea6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eac:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb0:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	2d4080e7          	jalr	724(ra) # 80002188 <syscall>
  if(killed(p))
    80001ebc:	8526                	mv	a0,s1
    80001ebe:	00000097          	auipc	ra,0x0
    80001ec2:	a88080e7          	jalr	-1400(ra) # 80001946 <killed>
    80001ec6:	c911                	beqz	a0,80001eda <usertrap+0xac>
    80001ec8:	4901                	li	s2,0
    exit(-1);
    80001eca:	557d                	li	a0,-1
    80001ecc:	00000097          	auipc	ra,0x0
    80001ed0:	906080e7          	jalr	-1786(ra) # 800017d2 <exit>
  if(which_dev == 2)
    80001ed4:	4789                	li	a5,2
    80001ed6:	04f90f63          	beq	s2,a5,80001f34 <usertrap+0x106>
  usertrapret();
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	dd2080e7          	jalr	-558(ra) # 80001cac <usertrapret>
}
    80001ee2:	60e2                	ld	ra,24(sp)
    80001ee4:	6442                	ld	s0,16(sp)
    80001ee6:	64a2                	ld	s1,8(sp)
    80001ee8:	6902                	ld	s2,0(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret
      exit(-1);
    80001eee:	557d                	li	a0,-1
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	8e2080e7          	jalr	-1822(ra) # 800017d2 <exit>
    80001ef8:	b765                	j	80001ea0 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efa:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001efe:	5890                	lw	a2,48(s1)
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	3f050513          	addi	a0,a0,1008 # 800082f0 <states.0+0x78>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	e38080e7          	jalr	-456(ra) # 80005d40 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f14:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f18:	00006517          	auipc	a0,0x6
    80001f1c:	40850513          	addi	a0,a0,1032 # 80008320 <states.0+0xa8>
    80001f20:	00004097          	auipc	ra,0x4
    80001f24:	e20080e7          	jalr	-480(ra) # 80005d40 <printf>
    setkilled(p);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	9f0080e7          	jalr	-1552(ra) # 8000191a <setkilled>
    80001f32:	b769                	j	80001ebc <usertrap+0x8e>
    yield();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	72e080e7          	jalr	1838(ra) # 80001662 <yield>
    80001f3c:	bf79                	j	80001eda <usertrap+0xac>

0000000080001f3e <kerneltrap>:
{
    80001f3e:	7179                	addi	sp,sp,-48
    80001f40:	f406                	sd	ra,40(sp)
    80001f42:	f022                	sd	s0,32(sp)
    80001f44:	ec26                	sd	s1,24(sp)
    80001f46:	e84a                	sd	s2,16(sp)
    80001f48:	e44e                	sd	s3,8(sp)
    80001f4a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f4c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f50:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f54:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f58:	1004f793          	andi	a5,s1,256
    80001f5c:	cb85                	beqz	a5,80001f8c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f62:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f64:	ef85                	bnez	a5,80001f9c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	e22080e7          	jalr	-478(ra) # 80001d88 <devintr>
    80001f6e:	cd1d                	beqz	a0,80001fac <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f70:	4789                	li	a5,2
    80001f72:	06f50a63          	beq	a0,a5,80001fe6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f76:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f7a:	10049073          	csrw	sstatus,s1
}
    80001f7e:	70a2                	ld	ra,40(sp)
    80001f80:	7402                	ld	s0,32(sp)
    80001f82:	64e2                	ld	s1,24(sp)
    80001f84:	6942                	ld	s2,16(sp)
    80001f86:	69a2                	ld	s3,8(sp)
    80001f88:	6145                	addi	sp,sp,48
    80001f8a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f8c:	00006517          	auipc	a0,0x6
    80001f90:	3b450513          	addi	a0,a0,948 # 80008340 <states.0+0xc8>
    80001f94:	00004097          	auipc	ra,0x4
    80001f98:	d62080e7          	jalr	-670(ra) # 80005cf6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	3cc50513          	addi	a0,a0,972 # 80008368 <states.0+0xf0>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	d52080e7          	jalr	-686(ra) # 80005cf6 <panic>
    printf("scause %p\n", scause);
    80001fac:	85ce                	mv	a1,s3
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	3da50513          	addi	a0,a0,986 # 80008388 <states.0+0x110>
    80001fb6:	00004097          	auipc	ra,0x4
    80001fba:	d8a080e7          	jalr	-630(ra) # 80005d40 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fbe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fc2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fc6:	00006517          	auipc	a0,0x6
    80001fca:	3d250513          	addi	a0,a0,978 # 80008398 <states.0+0x120>
    80001fce:	00004097          	auipc	ra,0x4
    80001fd2:	d72080e7          	jalr	-654(ra) # 80005d40 <printf>
    panic("kerneltrap");
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	3da50513          	addi	a0,a0,986 # 800083b0 <states.0+0x138>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	d18080e7          	jalr	-744(ra) # 80005cf6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	f62080e7          	jalr	-158(ra) # 80000f48 <myproc>
    80001fee:	d541                	beqz	a0,80001f76 <kerneltrap+0x38>
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	f58080e7          	jalr	-168(ra) # 80000f48 <myproc>
    80001ff8:	4d18                	lw	a4,24(a0)
    80001ffa:	4791                	li	a5,4
    80001ffc:	f6f71de3          	bne	a4,a5,80001f76 <kerneltrap+0x38>
    yield();
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	662080e7          	jalr	1634(ra) # 80001662 <yield>
    80002008:	b7bd                	j	80001f76 <kerneltrap+0x38>

000000008000200a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	f32080e7          	jalr	-206(ra) # 80000f48 <myproc>
  switch (n) {
    8000201e:	4795                	li	a5,5
    80002020:	0497e163          	bltu	a5,s1,80002062 <argraw+0x58>
    80002024:	048a                	slli	s1,s1,0x2
    80002026:	00006717          	auipc	a4,0x6
    8000202a:	3c270713          	addi	a4,a4,962 # 800083e8 <states.0+0x170>
    8000202e:	94ba                	add	s1,s1,a4
    80002030:	409c                	lw	a5,0(s1)
    80002032:	97ba                	add	a5,a5,a4
    80002034:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002036:	6d3c                	ld	a5,88(a0)
    80002038:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000203a:	60e2                	ld	ra,24(sp)
    8000203c:	6442                	ld	s0,16(sp)
    8000203e:	64a2                	ld	s1,8(sp)
    80002040:	6105                	addi	sp,sp,32
    80002042:	8082                	ret
    return p->trapframe->a1;
    80002044:	6d3c                	ld	a5,88(a0)
    80002046:	7fa8                	ld	a0,120(a5)
    80002048:	bfcd                	j	8000203a <argraw+0x30>
    return p->trapframe->a2;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	63c8                	ld	a0,128(a5)
    8000204e:	b7f5                	j	8000203a <argraw+0x30>
    return p->trapframe->a3;
    80002050:	6d3c                	ld	a5,88(a0)
    80002052:	67c8                	ld	a0,136(a5)
    80002054:	b7dd                	j	8000203a <argraw+0x30>
    return p->trapframe->a4;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	6bc8                	ld	a0,144(a5)
    8000205a:	b7c5                	j	8000203a <argraw+0x30>
    return p->trapframe->a5;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	6fc8                	ld	a0,152(a5)
    80002060:	bfe9                	j	8000203a <argraw+0x30>
  panic("argraw");
    80002062:	00006517          	auipc	a0,0x6
    80002066:	35e50513          	addi	a0,a0,862 # 800083c0 <states.0+0x148>
    8000206a:	00004097          	auipc	ra,0x4
    8000206e:	c8c080e7          	jalr	-884(ra) # 80005cf6 <panic>

0000000080002072 <fetchaddr>:
{
    80002072:	1101                	addi	sp,sp,-32
    80002074:	ec06                	sd	ra,24(sp)
    80002076:	e822                	sd	s0,16(sp)
    80002078:	e426                	sd	s1,8(sp)
    8000207a:	e04a                	sd	s2,0(sp)
    8000207c:	1000                	addi	s0,sp,32
    8000207e:	84aa                	mv	s1,a0
    80002080:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	ec6080e7          	jalr	-314(ra) # 80000f48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000208a:	653c                	ld	a5,72(a0)
    8000208c:	02f4f863          	bgeu	s1,a5,800020bc <fetchaddr+0x4a>
    80002090:	00848713          	addi	a4,s1,8
    80002094:	02e7e663          	bltu	a5,a4,800020c0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002098:	46a1                	li	a3,8
    8000209a:	8626                	mv	a2,s1
    8000209c:	85ca                	mv	a1,s2
    8000209e:	6928                	ld	a0,80(a0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	afe080e7          	jalr	-1282(ra) # 80000b9e <copyin>
    800020a8:	00a03533          	snez	a0,a0
    800020ac:	40a00533          	neg	a0,a0
}
    800020b0:	60e2                	ld	ra,24(sp)
    800020b2:	6442                	ld	s0,16(sp)
    800020b4:	64a2                	ld	s1,8(sp)
    800020b6:	6902                	ld	s2,0(sp)
    800020b8:	6105                	addi	sp,sp,32
    800020ba:	8082                	ret
    return -1;
    800020bc:	557d                	li	a0,-1
    800020be:	bfcd                	j	800020b0 <fetchaddr+0x3e>
    800020c0:	557d                	li	a0,-1
    800020c2:	b7fd                	j	800020b0 <fetchaddr+0x3e>

00000000800020c4 <fetchstr>:
{
    800020c4:	7179                	addi	sp,sp,-48
    800020c6:	f406                	sd	ra,40(sp)
    800020c8:	f022                	sd	s0,32(sp)
    800020ca:	ec26                	sd	s1,24(sp)
    800020cc:	e84a                	sd	s2,16(sp)
    800020ce:	e44e                	sd	s3,8(sp)
    800020d0:	1800                	addi	s0,sp,48
    800020d2:	892a                	mv	s2,a0
    800020d4:	84ae                	mv	s1,a1
    800020d6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	e70080e7          	jalr	-400(ra) # 80000f48 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020e0:	86ce                	mv	a3,s3
    800020e2:	864a                	mv	a2,s2
    800020e4:	85a6                	mv	a1,s1
    800020e6:	6928                	ld	a0,80(a0)
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	b44080e7          	jalr	-1212(ra) # 80000c2c <copyinstr>
    800020f0:	00054e63          	bltz	a0,8000210c <fetchstr+0x48>
  return strlen(buf);
    800020f4:	8526                	mv	a0,s1
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	1fe080e7          	jalr	510(ra) # 800002f4 <strlen>
}
    800020fe:	70a2                	ld	ra,40(sp)
    80002100:	7402                	ld	s0,32(sp)
    80002102:	64e2                	ld	s1,24(sp)
    80002104:	6942                	ld	s2,16(sp)
    80002106:	69a2                	ld	s3,8(sp)
    80002108:	6145                	addi	sp,sp,48
    8000210a:	8082                	ret
    return -1;
    8000210c:	557d                	li	a0,-1
    8000210e:	bfc5                	j	800020fe <fetchstr+0x3a>

0000000080002110 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000211c:	00000097          	auipc	ra,0x0
    80002120:	eee080e7          	jalr	-274(ra) # 8000200a <argraw>
    80002124:	c088                	sw	a0,0(s1)
}
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	64a2                	ld	s1,8(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret

0000000080002130 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002130:	1101                	addi	sp,sp,-32
    80002132:	ec06                	sd	ra,24(sp)
    80002134:	e822                	sd	s0,16(sp)
    80002136:	e426                	sd	s1,8(sp)
    80002138:	1000                	addi	s0,sp,32
    8000213a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	ece080e7          	jalr	-306(ra) # 8000200a <argraw>
    80002144:	e088                	sd	a0,0(s1)
}
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	64a2                	ld	s1,8(sp)
    8000214c:	6105                	addi	sp,sp,32
    8000214e:	8082                	ret

0000000080002150 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002150:	7179                	addi	sp,sp,-48
    80002152:	f406                	sd	ra,40(sp)
    80002154:	f022                	sd	s0,32(sp)
    80002156:	ec26                	sd	s1,24(sp)
    80002158:	e84a                	sd	s2,16(sp)
    8000215a:	1800                	addi	s0,sp,48
    8000215c:	84ae                	mv	s1,a1
    8000215e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002160:	fd840593          	addi	a1,s0,-40
    80002164:	00000097          	auipc	ra,0x0
    80002168:	fcc080e7          	jalr	-52(ra) # 80002130 <argaddr>
  return fetchstr(addr, buf, max);
    8000216c:	864a                	mv	a2,s2
    8000216e:	85a6                	mv	a1,s1
    80002170:	fd843503          	ld	a0,-40(s0)
    80002174:	00000097          	auipc	ra,0x0
    80002178:	f50080e7          	jalr	-176(ra) # 800020c4 <fetchstr>
}
    8000217c:	70a2                	ld	ra,40(sp)
    8000217e:	7402                	ld	s0,32(sp)
    80002180:	64e2                	ld	s1,24(sp)
    80002182:	6942                	ld	s2,16(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret

0000000080002188 <syscall>:



void
syscall(void)
{
    80002188:	1101                	addi	sp,sp,-32
    8000218a:	ec06                	sd	ra,24(sp)
    8000218c:	e822                	sd	s0,16(sp)
    8000218e:	e426                	sd	s1,8(sp)
    80002190:	e04a                	sd	s2,0(sp)
    80002192:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	db4080e7          	jalr	-588(ra) # 80000f48 <myproc>
    8000219c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000219e:	05853903          	ld	s2,88(a0)
    800021a2:	0a893783          	ld	a5,168(s2)
    800021a6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021aa:	37fd                	addiw	a5,a5,-1
    800021ac:	4775                	li	a4,29
    800021ae:	00f76f63          	bltu	a4,a5,800021cc <syscall+0x44>
    800021b2:	00369713          	slli	a4,a3,0x3
    800021b6:	00006797          	auipc	a5,0x6
    800021ba:	24a78793          	addi	a5,a5,586 # 80008400 <syscalls>
    800021be:	97ba                	add	a5,a5,a4
    800021c0:	639c                	ld	a5,0(a5)
    800021c2:	c789                	beqz	a5,800021cc <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021c4:	9782                	jalr	a5
    800021c6:	06a93823          	sd	a0,112(s2)
    800021ca:	a839                	j	800021e8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021cc:	16048613          	addi	a2,s1,352
    800021d0:	588c                	lw	a1,48(s1)
    800021d2:	00006517          	auipc	a0,0x6
    800021d6:	1f650513          	addi	a0,a0,502 # 800083c8 <states.0+0x150>
    800021da:	00004097          	auipc	ra,0x4
    800021de:	b66080e7          	jalr	-1178(ra) # 80005d40 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021e2:	6cbc                	ld	a5,88(s1)
    800021e4:	577d                	li	a4,-1
    800021e6:	fbb8                	sd	a4,112(a5)
  }
}
    800021e8:	60e2                	ld	ra,24(sp)
    800021ea:	6442                	ld	s0,16(sp)
    800021ec:	64a2                	ld	s1,8(sp)
    800021ee:	6902                	ld	s2,0(sp)
    800021f0:	6105                	addi	sp,sp,32
    800021f2:	8082                	ret

00000000800021f4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021f4:	1101                	addi	sp,sp,-32
    800021f6:	ec06                	sd	ra,24(sp)
    800021f8:	e822                	sd	s0,16(sp)
    800021fa:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021fc:	fec40593          	addi	a1,s0,-20
    80002200:	4501                	li	a0,0
    80002202:	00000097          	auipc	ra,0x0
    80002206:	f0e080e7          	jalr	-242(ra) # 80002110 <argint>
  exit(n);
    8000220a:	fec42503          	lw	a0,-20(s0)
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	5c4080e7          	jalr	1476(ra) # 800017d2 <exit>
  return 0;  // not reached
}
    80002216:	4501                	li	a0,0
    80002218:	60e2                	ld	ra,24(sp)
    8000221a:	6442                	ld	s0,16(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002220:	1141                	addi	sp,sp,-16
    80002222:	e406                	sd	ra,8(sp)
    80002224:	e022                	sd	s0,0(sp)
    80002226:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	d20080e7          	jalr	-736(ra) # 80000f48 <myproc>
}
    80002230:	5908                	lw	a0,48(a0)
    80002232:	60a2                	ld	ra,8(sp)
    80002234:	6402                	ld	s0,0(sp)
    80002236:	0141                	addi	sp,sp,16
    80002238:	8082                	ret

000000008000223a <sys_fork>:

uint64
sys_fork(void)
{
    8000223a:	1141                	addi	sp,sp,-16
    8000223c:	e406                	sd	ra,8(sp)
    8000223e:	e022                	sd	s0,0(sp)
    80002240:	0800                	addi	s0,sp,16
  return fork();
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	16a080e7          	jalr	362(ra) # 800013ac <fork>
}
    8000224a:	60a2                	ld	ra,8(sp)
    8000224c:	6402                	ld	s0,0(sp)
    8000224e:	0141                	addi	sp,sp,16
    80002250:	8082                	ret

0000000080002252 <sys_wait>:

uint64
sys_wait(void)
{
    80002252:	1101                	addi	sp,sp,-32
    80002254:	ec06                	sd	ra,24(sp)
    80002256:	e822                	sd	s0,16(sp)
    80002258:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000225a:	fe840593          	addi	a1,s0,-24
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	ed0080e7          	jalr	-304(ra) # 80002130 <argaddr>
  return wait(p);
    80002268:	fe843503          	ld	a0,-24(s0)
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	70c080e7          	jalr	1804(ra) # 80001978 <wait>
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000227c:	7179                	addi	sp,sp,-48
    8000227e:	f406                	sd	ra,40(sp)
    80002280:	f022                	sd	s0,32(sp)
    80002282:	ec26                	sd	s1,24(sp)
    80002284:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002286:	fdc40593          	addi	a1,s0,-36
    8000228a:	4501                	li	a0,0
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	e84080e7          	jalr	-380(ra) # 80002110 <argint>
  addr = myproc()->sz;
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	cb4080e7          	jalr	-844(ra) # 80000f48 <myproc>
    8000229c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000229e:	fdc42503          	lw	a0,-36(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	0ae080e7          	jalr	174(ra) # 80001350 <growproc>
    800022aa:	00054863          	bltz	a0,800022ba <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022ae:	8526                	mv	a0,s1
    800022b0:	70a2                	ld	ra,40(sp)
    800022b2:	7402                	ld	s0,32(sp)
    800022b4:	64e2                	ld	s1,24(sp)
    800022b6:	6145                	addi	sp,sp,48
    800022b8:	8082                	ret
    return -1;
    800022ba:	54fd                	li	s1,-1
    800022bc:	bfcd                	j	800022ae <sys_sbrk+0x32>

00000000800022be <sys_sleep>:

uint64
sys_sleep(void)
{
    800022be:	7139                	addi	sp,sp,-64
    800022c0:	fc06                	sd	ra,56(sp)
    800022c2:	f822                	sd	s0,48(sp)
    800022c4:	f426                	sd	s1,40(sp)
    800022c6:	f04a                	sd	s2,32(sp)
    800022c8:	ec4e                	sd	s3,24(sp)
    800022ca:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022cc:	fcc40593          	addi	a1,s0,-52
    800022d0:	4501                	li	a0,0
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	e3e080e7          	jalr	-450(ra) # 80002110 <argint>
  acquire(&tickslock);
    800022da:	0000c517          	auipc	a0,0xc
    800022de:	6d650513          	addi	a0,a0,1750 # 8000e9b0 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	f4c080e7          	jalr	-180(ra) # 8000622e <acquire>
  ticks0 = ticks;
    800022ea:	00006917          	auipc	s2,0x6
    800022ee:	65e92903          	lw	s2,1630(s2) # 80008948 <ticks>
  while(ticks - ticks0 < n){
    800022f2:	fcc42783          	lw	a5,-52(s0)
    800022f6:	cf9d                	beqz	a5,80002334 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022f8:	0000c997          	auipc	s3,0xc
    800022fc:	6b898993          	addi	s3,s3,1720 # 8000e9b0 <tickslock>
    80002300:	00006497          	auipc	s1,0x6
    80002304:	64848493          	addi	s1,s1,1608 # 80008948 <ticks>
    if(killed(myproc())){
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	c40080e7          	jalr	-960(ra) # 80000f48 <myproc>
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	636080e7          	jalr	1590(ra) # 80001946 <killed>
    80002318:	ed15                	bnez	a0,80002354 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000231a:	85ce                	mv	a1,s3
    8000231c:	8526                	mv	a0,s1
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	380080e7          	jalr	896(ra) # 8000169e <sleep>
  while(ticks - ticks0 < n){
    80002326:	409c                	lw	a5,0(s1)
    80002328:	412787bb          	subw	a5,a5,s2
    8000232c:	fcc42703          	lw	a4,-52(s0)
    80002330:	fce7ece3          	bltu	a5,a4,80002308 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002334:	0000c517          	auipc	a0,0xc
    80002338:	67c50513          	addi	a0,a0,1660 # 8000e9b0 <tickslock>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	fa6080e7          	jalr	-90(ra) # 800062e2 <release>
  return 0;
    80002344:	4501                	li	a0,0
}
    80002346:	70e2                	ld	ra,56(sp)
    80002348:	7442                	ld	s0,48(sp)
    8000234a:	74a2                	ld	s1,40(sp)
    8000234c:	7902                	ld	s2,32(sp)
    8000234e:	69e2                	ld	s3,24(sp)
    80002350:	6121                	addi	sp,sp,64
    80002352:	8082                	ret
      release(&tickslock);
    80002354:	0000c517          	auipc	a0,0xc
    80002358:	65c50513          	addi	a0,a0,1628 # 8000e9b0 <tickslock>
    8000235c:	00004097          	auipc	ra,0x4
    80002360:	f86080e7          	jalr	-122(ra) # 800062e2 <release>
      return -1;
    80002364:	557d                	li	a0,-1
    80002366:	b7c5                	j	80002346 <sys_sleep+0x88>

0000000080002368 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002368:	1141                	addi	sp,sp,-16
    8000236a:	e422                	sd	s0,8(sp)
    8000236c:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    8000236e:	4501                	li	a0,0
    80002370:	6422                	ld	s0,8(sp)
    80002372:	0141                	addi	sp,sp,16
    80002374:	8082                	ret

0000000080002376 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002376:	1101                	addi	sp,sp,-32
    80002378:	ec06                	sd	ra,24(sp)
    8000237a:	e822                	sd	s0,16(sp)
    8000237c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000237e:	fec40593          	addi	a1,s0,-20
    80002382:	4501                	li	a0,0
    80002384:	00000097          	auipc	ra,0x0
    80002388:	d8c080e7          	jalr	-628(ra) # 80002110 <argint>
  return kill(pid);
    8000238c:	fec42503          	lw	a0,-20(s0)
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	518080e7          	jalr	1304(ra) # 800018a8 <kill>
}
    80002398:	60e2                	ld	ra,24(sp)
    8000239a:	6442                	ld	s0,16(sp)
    8000239c:	6105                	addi	sp,sp,32
    8000239e:	8082                	ret

00000000800023a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023a0:	1101                	addi	sp,sp,-32
    800023a2:	ec06                	sd	ra,24(sp)
    800023a4:	e822                	sd	s0,16(sp)
    800023a6:	e426                	sd	s1,8(sp)
    800023a8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023aa:	0000c517          	auipc	a0,0xc
    800023ae:	60650513          	addi	a0,a0,1542 # 8000e9b0 <tickslock>
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	e7c080e7          	jalr	-388(ra) # 8000622e <acquire>
  xticks = ticks;
    800023ba:	00006497          	auipc	s1,0x6
    800023be:	58e4a483          	lw	s1,1422(s1) # 80008948 <ticks>
  release(&tickslock);
    800023c2:	0000c517          	auipc	a0,0xc
    800023c6:	5ee50513          	addi	a0,a0,1518 # 8000e9b0 <tickslock>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	f18080e7          	jalr	-232(ra) # 800062e2 <release>
  return xticks;
}
    800023d2:	02049513          	slli	a0,s1,0x20
    800023d6:	9101                	srli	a0,a0,0x20
    800023d8:	60e2                	ld	ra,24(sp)
    800023da:	6442                	ld	s0,16(sp)
    800023dc:	64a2                	ld	s1,8(sp)
    800023de:	6105                	addi	sp,sp,32
    800023e0:	8082                	ret

00000000800023e2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023e2:	7179                	addi	sp,sp,-48
    800023e4:	f406                	sd	ra,40(sp)
    800023e6:	f022                	sd	s0,32(sp)
    800023e8:	ec26                	sd	s1,24(sp)
    800023ea:	e84a                	sd	s2,16(sp)
    800023ec:	e44e                	sd	s3,8(sp)
    800023ee:	e052                	sd	s4,0(sp)
    800023f0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023f2:	00006597          	auipc	a1,0x6
    800023f6:	10658593          	addi	a1,a1,262 # 800084f8 <syscalls+0xf8>
    800023fa:	0000c517          	auipc	a0,0xc
    800023fe:	5ce50513          	addi	a0,a0,1486 # 8000e9c8 <bcache>
    80002402:	00004097          	auipc	ra,0x4
    80002406:	d9c080e7          	jalr	-612(ra) # 8000619e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000240a:	00014797          	auipc	a5,0x14
    8000240e:	5be78793          	addi	a5,a5,1470 # 800169c8 <bcache+0x8000>
    80002412:	00015717          	auipc	a4,0x15
    80002416:	81e70713          	addi	a4,a4,-2018 # 80016c30 <bcache+0x8268>
    8000241a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000241e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002422:	0000c497          	auipc	s1,0xc
    80002426:	5be48493          	addi	s1,s1,1470 # 8000e9e0 <bcache+0x18>
    b->next = bcache.head.next;
    8000242a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000242c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000242e:	00006a17          	auipc	s4,0x6
    80002432:	0d2a0a13          	addi	s4,s4,210 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    80002436:	2b893783          	ld	a5,696(s2)
    8000243a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000243c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002440:	85d2                	mv	a1,s4
    80002442:	01048513          	addi	a0,s1,16
    80002446:	00001097          	auipc	ra,0x1
    8000244a:	496080e7          	jalr	1174(ra) # 800038dc <initsleeplock>
    bcache.head.next->prev = b;
    8000244e:	2b893783          	ld	a5,696(s2)
    80002452:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002454:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002458:	45848493          	addi	s1,s1,1112
    8000245c:	fd349de3          	bne	s1,s3,80002436 <binit+0x54>
  }
}
    80002460:	70a2                	ld	ra,40(sp)
    80002462:	7402                	ld	s0,32(sp)
    80002464:	64e2                	ld	s1,24(sp)
    80002466:	6942                	ld	s2,16(sp)
    80002468:	69a2                	ld	s3,8(sp)
    8000246a:	6a02                	ld	s4,0(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret

0000000080002470 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002470:	7179                	addi	sp,sp,-48
    80002472:	f406                	sd	ra,40(sp)
    80002474:	f022                	sd	s0,32(sp)
    80002476:	ec26                	sd	s1,24(sp)
    80002478:	e84a                	sd	s2,16(sp)
    8000247a:	e44e                	sd	s3,8(sp)
    8000247c:	1800                	addi	s0,sp,48
    8000247e:	892a                	mv	s2,a0
    80002480:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002482:	0000c517          	auipc	a0,0xc
    80002486:	54650513          	addi	a0,a0,1350 # 8000e9c8 <bcache>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	da4080e7          	jalr	-604(ra) # 8000622e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002492:	00014497          	auipc	s1,0x14
    80002496:	7ee4b483          	ld	s1,2030(s1) # 80016c80 <bcache+0x82b8>
    8000249a:	00014797          	auipc	a5,0x14
    8000249e:	79678793          	addi	a5,a5,1942 # 80016c30 <bcache+0x8268>
    800024a2:	02f48f63          	beq	s1,a5,800024e0 <bread+0x70>
    800024a6:	873e                	mv	a4,a5
    800024a8:	a021                	j	800024b0 <bread+0x40>
    800024aa:	68a4                	ld	s1,80(s1)
    800024ac:	02e48a63          	beq	s1,a4,800024e0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024b0:	449c                	lw	a5,8(s1)
    800024b2:	ff279ce3          	bne	a5,s2,800024aa <bread+0x3a>
    800024b6:	44dc                	lw	a5,12(s1)
    800024b8:	ff3799e3          	bne	a5,s3,800024aa <bread+0x3a>
      b->refcnt++;
    800024bc:	40bc                	lw	a5,64(s1)
    800024be:	2785                	addiw	a5,a5,1
    800024c0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024c2:	0000c517          	auipc	a0,0xc
    800024c6:	50650513          	addi	a0,a0,1286 # 8000e9c8 <bcache>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	e18080e7          	jalr	-488(ra) # 800062e2 <release>
      acquiresleep(&b->lock);
    800024d2:	01048513          	addi	a0,s1,16
    800024d6:	00001097          	auipc	ra,0x1
    800024da:	440080e7          	jalr	1088(ra) # 80003916 <acquiresleep>
      return b;
    800024de:	a8b9                	j	8000253c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024e0:	00014497          	auipc	s1,0x14
    800024e4:	7984b483          	ld	s1,1944(s1) # 80016c78 <bcache+0x82b0>
    800024e8:	00014797          	auipc	a5,0x14
    800024ec:	74878793          	addi	a5,a5,1864 # 80016c30 <bcache+0x8268>
    800024f0:	00f48863          	beq	s1,a5,80002500 <bread+0x90>
    800024f4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024f6:	40bc                	lw	a5,64(s1)
    800024f8:	cf81                	beqz	a5,80002510 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024fa:	64a4                	ld	s1,72(s1)
    800024fc:	fee49de3          	bne	s1,a4,800024f6 <bread+0x86>
  panic("bget: no buffers");
    80002500:	00006517          	auipc	a0,0x6
    80002504:	00850513          	addi	a0,a0,8 # 80008508 <syscalls+0x108>
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	7ee080e7          	jalr	2030(ra) # 80005cf6 <panic>
      b->dev = dev;
    80002510:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002514:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002518:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000251c:	4785                	li	a5,1
    8000251e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002520:	0000c517          	auipc	a0,0xc
    80002524:	4a850513          	addi	a0,a0,1192 # 8000e9c8 <bcache>
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	dba080e7          	jalr	-582(ra) # 800062e2 <release>
      acquiresleep(&b->lock);
    80002530:	01048513          	addi	a0,s1,16
    80002534:	00001097          	auipc	ra,0x1
    80002538:	3e2080e7          	jalr	994(ra) # 80003916 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000253c:	409c                	lw	a5,0(s1)
    8000253e:	cb89                	beqz	a5,80002550 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002540:	8526                	mv	a0,s1
    80002542:	70a2                	ld	ra,40(sp)
    80002544:	7402                	ld	s0,32(sp)
    80002546:	64e2                	ld	s1,24(sp)
    80002548:	6942                	ld	s2,16(sp)
    8000254a:	69a2                	ld	s3,8(sp)
    8000254c:	6145                	addi	sp,sp,48
    8000254e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002550:	4581                	li	a1,0
    80002552:	8526                	mv	a0,s1
    80002554:	00003097          	auipc	ra,0x3
    80002558:	f9e080e7          	jalr	-98(ra) # 800054f2 <virtio_disk_rw>
    b->valid = 1;
    8000255c:	4785                	li	a5,1
    8000255e:	c09c                	sw	a5,0(s1)
  return b;
    80002560:	b7c5                	j	80002540 <bread+0xd0>

0000000080002562 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	1000                	addi	s0,sp,32
    8000256c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000256e:	0541                	addi	a0,a0,16
    80002570:	00001097          	auipc	ra,0x1
    80002574:	440080e7          	jalr	1088(ra) # 800039b0 <holdingsleep>
    80002578:	cd01                	beqz	a0,80002590 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000257a:	4585                	li	a1,1
    8000257c:	8526                	mv	a0,s1
    8000257e:	00003097          	auipc	ra,0x3
    80002582:	f74080e7          	jalr	-140(ra) # 800054f2 <virtio_disk_rw>
}
    80002586:	60e2                	ld	ra,24(sp)
    80002588:	6442                	ld	s0,16(sp)
    8000258a:	64a2                	ld	s1,8(sp)
    8000258c:	6105                	addi	sp,sp,32
    8000258e:	8082                	ret
    panic("bwrite");
    80002590:	00006517          	auipc	a0,0x6
    80002594:	f9050513          	addi	a0,a0,-112 # 80008520 <syscalls+0x120>
    80002598:	00003097          	auipc	ra,0x3
    8000259c:	75e080e7          	jalr	1886(ra) # 80005cf6 <panic>

00000000800025a0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025a0:	1101                	addi	sp,sp,-32
    800025a2:	ec06                	sd	ra,24(sp)
    800025a4:	e822                	sd	s0,16(sp)
    800025a6:	e426                	sd	s1,8(sp)
    800025a8:	e04a                	sd	s2,0(sp)
    800025aa:	1000                	addi	s0,sp,32
    800025ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ae:	01050913          	addi	s2,a0,16
    800025b2:	854a                	mv	a0,s2
    800025b4:	00001097          	auipc	ra,0x1
    800025b8:	3fc080e7          	jalr	1020(ra) # 800039b0 <holdingsleep>
    800025bc:	c925                	beqz	a0,8000262c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800025be:	854a                	mv	a0,s2
    800025c0:	00001097          	auipc	ra,0x1
    800025c4:	3ac080e7          	jalr	940(ra) # 8000396c <releasesleep>

  acquire(&bcache.lock);
    800025c8:	0000c517          	auipc	a0,0xc
    800025cc:	40050513          	addi	a0,a0,1024 # 8000e9c8 <bcache>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	c5e080e7          	jalr	-930(ra) # 8000622e <acquire>
  b->refcnt--;
    800025d8:	40bc                	lw	a5,64(s1)
    800025da:	37fd                	addiw	a5,a5,-1
    800025dc:	0007871b          	sext.w	a4,a5
    800025e0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025e2:	e71d                	bnez	a4,80002610 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025e4:	68b8                	ld	a4,80(s1)
    800025e6:	64bc                	ld	a5,72(s1)
    800025e8:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025ea:	68b8                	ld	a4,80(s1)
    800025ec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ee:	00014797          	auipc	a5,0x14
    800025f2:	3da78793          	addi	a5,a5,986 # 800169c8 <bcache+0x8000>
    800025f6:	2b87b703          	ld	a4,696(a5)
    800025fa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025fc:	00014717          	auipc	a4,0x14
    80002600:	63470713          	addi	a4,a4,1588 # 80016c30 <bcache+0x8268>
    80002604:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002606:	2b87b703          	ld	a4,696(a5)
    8000260a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000260c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002610:	0000c517          	auipc	a0,0xc
    80002614:	3b850513          	addi	a0,a0,952 # 8000e9c8 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	cca080e7          	jalr	-822(ra) # 800062e2 <release>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6902                	ld	s2,0(sp)
    80002628:	6105                	addi	sp,sp,32
    8000262a:	8082                	ret
    panic("brelse");
    8000262c:	00006517          	auipc	a0,0x6
    80002630:	efc50513          	addi	a0,a0,-260 # 80008528 <syscalls+0x128>
    80002634:	00003097          	auipc	ra,0x3
    80002638:	6c2080e7          	jalr	1730(ra) # 80005cf6 <panic>

000000008000263c <bpin>:

void
bpin(struct buf *b) {
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002648:	0000c517          	auipc	a0,0xc
    8000264c:	38050513          	addi	a0,a0,896 # 8000e9c8 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	bde080e7          	jalr	-1058(ra) # 8000622e <acquire>
  b->refcnt++;
    80002658:	40bc                	lw	a5,64(s1)
    8000265a:	2785                	addiw	a5,a5,1
    8000265c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265e:	0000c517          	auipc	a0,0xc
    80002662:	36a50513          	addi	a0,a0,874 # 8000e9c8 <bcache>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	c7c080e7          	jalr	-900(ra) # 800062e2 <release>
}
    8000266e:	60e2                	ld	ra,24(sp)
    80002670:	6442                	ld	s0,16(sp)
    80002672:	64a2                	ld	s1,8(sp)
    80002674:	6105                	addi	sp,sp,32
    80002676:	8082                	ret

0000000080002678 <bunpin>:

void
bunpin(struct buf *b) {
    80002678:	1101                	addi	sp,sp,-32
    8000267a:	ec06                	sd	ra,24(sp)
    8000267c:	e822                	sd	s0,16(sp)
    8000267e:	e426                	sd	s1,8(sp)
    80002680:	1000                	addi	s0,sp,32
    80002682:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002684:	0000c517          	auipc	a0,0xc
    80002688:	34450513          	addi	a0,a0,836 # 8000e9c8 <bcache>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	ba2080e7          	jalr	-1118(ra) # 8000622e <acquire>
  b->refcnt--;
    80002694:	40bc                	lw	a5,64(s1)
    80002696:	37fd                	addiw	a5,a5,-1
    80002698:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000269a:	0000c517          	auipc	a0,0xc
    8000269e:	32e50513          	addi	a0,a0,814 # 8000e9c8 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	c40080e7          	jalr	-960(ra) # 800062e2 <release>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret

00000000800026b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	e426                	sd	s1,8(sp)
    800026bc:	e04a                	sd	s2,0(sp)
    800026be:	1000                	addi	s0,sp,32
    800026c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026c2:	00d5d59b          	srliw	a1,a1,0xd
    800026c6:	00015797          	auipc	a5,0x15
    800026ca:	9de7a783          	lw	a5,-1570(a5) # 800170a4 <sb+0x1c>
    800026ce:	9dbd                	addw	a1,a1,a5
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	da0080e7          	jalr	-608(ra) # 80002470 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d8:	0074f713          	andi	a4,s1,7
    800026dc:	4785                	li	a5,1
    800026de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026e2:	14ce                	slli	s1,s1,0x33
    800026e4:	90d9                	srli	s1,s1,0x36
    800026e6:	00950733          	add	a4,a0,s1
    800026ea:	05874703          	lbu	a4,88(a4)
    800026ee:	00e7f6b3          	and	a3,a5,a4
    800026f2:	c69d                	beqz	a3,80002720 <bfree+0x6c>
    800026f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026f6:	94aa                	add	s1,s1,a0
    800026f8:	fff7c793          	not	a5,a5
    800026fc:	8f7d                	and	a4,a4,a5
    800026fe:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002702:	00001097          	auipc	ra,0x1
    80002706:	0f6080e7          	jalr	246(ra) # 800037f8 <log_write>
  brelse(bp);
    8000270a:	854a                	mv	a0,s2
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	e94080e7          	jalr	-364(ra) # 800025a0 <brelse>
}
    80002714:	60e2                	ld	ra,24(sp)
    80002716:	6442                	ld	s0,16(sp)
    80002718:	64a2                	ld	s1,8(sp)
    8000271a:	6902                	ld	s2,0(sp)
    8000271c:	6105                	addi	sp,sp,32
    8000271e:	8082                	ret
    panic("freeing free block");
    80002720:	00006517          	auipc	a0,0x6
    80002724:	e1050513          	addi	a0,a0,-496 # 80008530 <syscalls+0x130>
    80002728:	00003097          	auipc	ra,0x3
    8000272c:	5ce080e7          	jalr	1486(ra) # 80005cf6 <panic>

0000000080002730 <balloc>:
{
    80002730:	711d                	addi	sp,sp,-96
    80002732:	ec86                	sd	ra,88(sp)
    80002734:	e8a2                	sd	s0,80(sp)
    80002736:	e4a6                	sd	s1,72(sp)
    80002738:	e0ca                	sd	s2,64(sp)
    8000273a:	fc4e                	sd	s3,56(sp)
    8000273c:	f852                	sd	s4,48(sp)
    8000273e:	f456                	sd	s5,40(sp)
    80002740:	f05a                	sd	s6,32(sp)
    80002742:	ec5e                	sd	s7,24(sp)
    80002744:	e862                	sd	s8,16(sp)
    80002746:	e466                	sd	s9,8(sp)
    80002748:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000274a:	00015797          	auipc	a5,0x15
    8000274e:	9427a783          	lw	a5,-1726(a5) # 8001708c <sb+0x4>
    80002752:	cff5                	beqz	a5,8000284e <balloc+0x11e>
    80002754:	8baa                	mv	s7,a0
    80002756:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002758:	00015b17          	auipc	s6,0x15
    8000275c:	930b0b13          	addi	s6,s6,-1744 # 80017088 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002760:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002762:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002764:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002766:	6c89                	lui	s9,0x2
    80002768:	a061                	j	800027f0 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000276a:	97ca                	add	a5,a5,s2
    8000276c:	8e55                	or	a2,a2,a3
    8000276e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00001097          	auipc	ra,0x1
    80002778:	084080e7          	jalr	132(ra) # 800037f8 <log_write>
        brelse(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	e22080e7          	jalr	-478(ra) # 800025a0 <brelse>
  bp = bread(dev, bno);
    80002786:	85a6                	mv	a1,s1
    80002788:	855e                	mv	a0,s7
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	ce6080e7          	jalr	-794(ra) # 80002470 <bread>
    80002792:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002794:	40000613          	li	a2,1024
    80002798:	4581                	li	a1,0
    8000279a:	05850513          	addi	a0,a0,88
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	9dc080e7          	jalr	-1572(ra) # 8000017a <memset>
  log_write(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	050080e7          	jalr	80(ra) # 800037f8 <log_write>
  brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	dee080e7          	jalr	-530(ra) # 800025a0 <brelse>
}
    800027ba:	8526                	mv	a0,s1
    800027bc:	60e6                	ld	ra,88(sp)
    800027be:	6446                	ld	s0,80(sp)
    800027c0:	64a6                	ld	s1,72(sp)
    800027c2:	6906                	ld	s2,64(sp)
    800027c4:	79e2                	ld	s3,56(sp)
    800027c6:	7a42                	ld	s4,48(sp)
    800027c8:	7aa2                	ld	s5,40(sp)
    800027ca:	7b02                	ld	s6,32(sp)
    800027cc:	6be2                	ld	s7,24(sp)
    800027ce:	6c42                	ld	s8,16(sp)
    800027d0:	6ca2                	ld	s9,8(sp)
    800027d2:	6125                	addi	sp,sp,96
    800027d4:	8082                	ret
    brelse(bp);
    800027d6:	854a                	mv	a0,s2
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	dc8080e7          	jalr	-568(ra) # 800025a0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027e0:	015c87bb          	addw	a5,s9,s5
    800027e4:	00078a9b          	sext.w	s5,a5
    800027e8:	004b2703          	lw	a4,4(s6)
    800027ec:	06eaf163          	bgeu	s5,a4,8000284e <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027f0:	41fad79b          	sraiw	a5,s5,0x1f
    800027f4:	0137d79b          	srliw	a5,a5,0x13
    800027f8:	015787bb          	addw	a5,a5,s5
    800027fc:	40d7d79b          	sraiw	a5,a5,0xd
    80002800:	01cb2583          	lw	a1,28(s6)
    80002804:	9dbd                	addw	a1,a1,a5
    80002806:	855e                	mv	a0,s7
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	c68080e7          	jalr	-920(ra) # 80002470 <bread>
    80002810:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002812:	004b2503          	lw	a0,4(s6)
    80002816:	000a849b          	sext.w	s1,s5
    8000281a:	8762                	mv	a4,s8
    8000281c:	faa4fde3          	bgeu	s1,a0,800027d6 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002820:	00777693          	andi	a3,a4,7
    80002824:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002828:	41f7579b          	sraiw	a5,a4,0x1f
    8000282c:	01d7d79b          	srliw	a5,a5,0x1d
    80002830:	9fb9                	addw	a5,a5,a4
    80002832:	4037d79b          	sraiw	a5,a5,0x3
    80002836:	00f90633          	add	a2,s2,a5
    8000283a:	05864603          	lbu	a2,88(a2)
    8000283e:	00c6f5b3          	and	a1,a3,a2
    80002842:	d585                	beqz	a1,8000276a <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002844:	2705                	addiw	a4,a4,1
    80002846:	2485                	addiw	s1,s1,1
    80002848:	fd471ae3          	bne	a4,s4,8000281c <balloc+0xec>
    8000284c:	b769                	j	800027d6 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	cfa50513          	addi	a0,a0,-774 # 80008548 <syscalls+0x148>
    80002856:	00003097          	auipc	ra,0x3
    8000285a:	4ea080e7          	jalr	1258(ra) # 80005d40 <printf>
  return 0;
    8000285e:	4481                	li	s1,0
    80002860:	bfa9                	j	800027ba <balloc+0x8a>

0000000080002862 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002862:	7179                	addi	sp,sp,-48
    80002864:	f406                	sd	ra,40(sp)
    80002866:	f022                	sd	s0,32(sp)
    80002868:	ec26                	sd	s1,24(sp)
    8000286a:	e84a                	sd	s2,16(sp)
    8000286c:	e44e                	sd	s3,8(sp)
    8000286e:	e052                	sd	s4,0(sp)
    80002870:	1800                	addi	s0,sp,48
    80002872:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002874:	47ad                	li	a5,11
    80002876:	02b7e863          	bltu	a5,a1,800028a6 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000287a:	02059793          	slli	a5,a1,0x20
    8000287e:	01e7d593          	srli	a1,a5,0x1e
    80002882:	00b504b3          	add	s1,a0,a1
    80002886:	0504a903          	lw	s2,80(s1)
    8000288a:	06091e63          	bnez	s2,80002906 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000288e:	4108                	lw	a0,0(a0)
    80002890:	00000097          	auipc	ra,0x0
    80002894:	ea0080e7          	jalr	-352(ra) # 80002730 <balloc>
    80002898:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000289c:	06090563          	beqz	s2,80002906 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800028a0:	0524a823          	sw	s2,80(s1)
    800028a4:	a08d                	j	80002906 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028a6:	ff45849b          	addiw	s1,a1,-12
    800028aa:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028ae:	0ff00793          	li	a5,255
    800028b2:	08e7e563          	bltu	a5,a4,8000293c <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028b6:	08052903          	lw	s2,128(a0)
    800028ba:	00091d63          	bnez	s2,800028d4 <bmap+0x72>
      addr = balloc(ip->dev);
    800028be:	4108                	lw	a0,0(a0)
    800028c0:	00000097          	auipc	ra,0x0
    800028c4:	e70080e7          	jalr	-400(ra) # 80002730 <balloc>
    800028c8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028cc:	02090d63          	beqz	s2,80002906 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028d0:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028d4:	85ca                	mv	a1,s2
    800028d6:	0009a503          	lw	a0,0(s3)
    800028da:	00000097          	auipc	ra,0x0
    800028de:	b96080e7          	jalr	-1130(ra) # 80002470 <bread>
    800028e2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028e4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e8:	02049713          	slli	a4,s1,0x20
    800028ec:	01e75593          	srli	a1,a4,0x1e
    800028f0:	00b784b3          	add	s1,a5,a1
    800028f4:	0004a903          	lw	s2,0(s1)
    800028f8:	02090063          	beqz	s2,80002918 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028fc:	8552                	mv	a0,s4
    800028fe:	00000097          	auipc	ra,0x0
    80002902:	ca2080e7          	jalr	-862(ra) # 800025a0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002906:	854a                	mv	a0,s2
    80002908:	70a2                	ld	ra,40(sp)
    8000290a:	7402                	ld	s0,32(sp)
    8000290c:	64e2                	ld	s1,24(sp)
    8000290e:	6942                	ld	s2,16(sp)
    80002910:	69a2                	ld	s3,8(sp)
    80002912:	6a02                	ld	s4,0(sp)
    80002914:	6145                	addi	sp,sp,48
    80002916:	8082                	ret
      addr = balloc(ip->dev);
    80002918:	0009a503          	lw	a0,0(s3)
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	e14080e7          	jalr	-492(ra) # 80002730 <balloc>
    80002924:	0005091b          	sext.w	s2,a0
      if(addr){
    80002928:	fc090ae3          	beqz	s2,800028fc <bmap+0x9a>
        a[bn] = addr;
    8000292c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002930:	8552                	mv	a0,s4
    80002932:	00001097          	auipc	ra,0x1
    80002936:	ec6080e7          	jalr	-314(ra) # 800037f8 <log_write>
    8000293a:	b7c9                	j	800028fc <bmap+0x9a>
  panic("bmap: out of range");
    8000293c:	00006517          	auipc	a0,0x6
    80002940:	c2450513          	addi	a0,a0,-988 # 80008560 <syscalls+0x160>
    80002944:	00003097          	auipc	ra,0x3
    80002948:	3b2080e7          	jalr	946(ra) # 80005cf6 <panic>

000000008000294c <iget>:
{
    8000294c:	7179                	addi	sp,sp,-48
    8000294e:	f406                	sd	ra,40(sp)
    80002950:	f022                	sd	s0,32(sp)
    80002952:	ec26                	sd	s1,24(sp)
    80002954:	e84a                	sd	s2,16(sp)
    80002956:	e44e                	sd	s3,8(sp)
    80002958:	e052                	sd	s4,0(sp)
    8000295a:	1800                	addi	s0,sp,48
    8000295c:	89aa                	mv	s3,a0
    8000295e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002960:	00014517          	auipc	a0,0x14
    80002964:	74850513          	addi	a0,a0,1864 # 800170a8 <itable>
    80002968:	00004097          	auipc	ra,0x4
    8000296c:	8c6080e7          	jalr	-1850(ra) # 8000622e <acquire>
  empty = 0;
    80002970:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002972:	00014497          	auipc	s1,0x14
    80002976:	74e48493          	addi	s1,s1,1870 # 800170c0 <itable+0x18>
    8000297a:	00016697          	auipc	a3,0x16
    8000297e:	1d668693          	addi	a3,a3,470 # 80018b50 <log>
    80002982:	a039                	j	80002990 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002984:	02090b63          	beqz	s2,800029ba <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002988:	08848493          	addi	s1,s1,136
    8000298c:	02d48a63          	beq	s1,a3,800029c0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002990:	449c                	lw	a5,8(s1)
    80002992:	fef059e3          	blez	a5,80002984 <iget+0x38>
    80002996:	4098                	lw	a4,0(s1)
    80002998:	ff3716e3          	bne	a4,s3,80002984 <iget+0x38>
    8000299c:	40d8                	lw	a4,4(s1)
    8000299e:	ff4713e3          	bne	a4,s4,80002984 <iget+0x38>
      ip->ref++;
    800029a2:	2785                	addiw	a5,a5,1
    800029a4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029a6:	00014517          	auipc	a0,0x14
    800029aa:	70250513          	addi	a0,a0,1794 # 800170a8 <itable>
    800029ae:	00004097          	auipc	ra,0x4
    800029b2:	934080e7          	jalr	-1740(ra) # 800062e2 <release>
      return ip;
    800029b6:	8926                	mv	s2,s1
    800029b8:	a03d                	j	800029e6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ba:	f7f9                	bnez	a5,80002988 <iget+0x3c>
    800029bc:	8926                	mv	s2,s1
    800029be:	b7e9                	j	80002988 <iget+0x3c>
  if(empty == 0)
    800029c0:	02090c63          	beqz	s2,800029f8 <iget+0xac>
  ip->dev = dev;
    800029c4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029c8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029cc:	4785                	li	a5,1
    800029ce:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029d2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029d6:	00014517          	auipc	a0,0x14
    800029da:	6d250513          	addi	a0,a0,1746 # 800170a8 <itable>
    800029de:	00004097          	auipc	ra,0x4
    800029e2:	904080e7          	jalr	-1788(ra) # 800062e2 <release>
}
    800029e6:	854a                	mv	a0,s2
    800029e8:	70a2                	ld	ra,40(sp)
    800029ea:	7402                	ld	s0,32(sp)
    800029ec:	64e2                	ld	s1,24(sp)
    800029ee:	6942                	ld	s2,16(sp)
    800029f0:	69a2                	ld	s3,8(sp)
    800029f2:	6a02                	ld	s4,0(sp)
    800029f4:	6145                	addi	sp,sp,48
    800029f6:	8082                	ret
    panic("iget: no inodes");
    800029f8:	00006517          	auipc	a0,0x6
    800029fc:	b8050513          	addi	a0,a0,-1152 # 80008578 <syscalls+0x178>
    80002a00:	00003097          	auipc	ra,0x3
    80002a04:	2f6080e7          	jalr	758(ra) # 80005cf6 <panic>

0000000080002a08 <fsinit>:
fsinit(int dev) {
    80002a08:	7179                	addi	sp,sp,-48
    80002a0a:	f406                	sd	ra,40(sp)
    80002a0c:	f022                	sd	s0,32(sp)
    80002a0e:	ec26                	sd	s1,24(sp)
    80002a10:	e84a                	sd	s2,16(sp)
    80002a12:	e44e                	sd	s3,8(sp)
    80002a14:	1800                	addi	s0,sp,48
    80002a16:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a18:	4585                	li	a1,1
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	a56080e7          	jalr	-1450(ra) # 80002470 <bread>
    80002a22:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a24:	00014997          	auipc	s3,0x14
    80002a28:	66498993          	addi	s3,s3,1636 # 80017088 <sb>
    80002a2c:	02000613          	li	a2,32
    80002a30:	05850593          	addi	a1,a0,88
    80002a34:	854e                	mv	a0,s3
    80002a36:	ffffd097          	auipc	ra,0xffffd
    80002a3a:	7a0080e7          	jalr	1952(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a3e:	8526                	mv	a0,s1
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	b60080e7          	jalr	-1184(ra) # 800025a0 <brelse>
  if(sb.magic != FSMAGIC)
    80002a48:	0009a703          	lw	a4,0(s3)
    80002a4c:	102037b7          	lui	a5,0x10203
    80002a50:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a54:	02f71263          	bne	a4,a5,80002a78 <fsinit+0x70>
  initlog(dev, &sb);
    80002a58:	00014597          	auipc	a1,0x14
    80002a5c:	63058593          	addi	a1,a1,1584 # 80017088 <sb>
    80002a60:	854a                	mv	a0,s2
    80002a62:	00001097          	auipc	ra,0x1
    80002a66:	b2c080e7          	jalr	-1236(ra) # 8000358e <initlog>
}
    80002a6a:	70a2                	ld	ra,40(sp)
    80002a6c:	7402                	ld	s0,32(sp)
    80002a6e:	64e2                	ld	s1,24(sp)
    80002a70:	6942                	ld	s2,16(sp)
    80002a72:	69a2                	ld	s3,8(sp)
    80002a74:	6145                	addi	sp,sp,48
    80002a76:	8082                	ret
    panic("invalid file system");
    80002a78:	00006517          	auipc	a0,0x6
    80002a7c:	b1050513          	addi	a0,a0,-1264 # 80008588 <syscalls+0x188>
    80002a80:	00003097          	auipc	ra,0x3
    80002a84:	276080e7          	jalr	630(ra) # 80005cf6 <panic>

0000000080002a88 <iinit>:
{
    80002a88:	7179                	addi	sp,sp,-48
    80002a8a:	f406                	sd	ra,40(sp)
    80002a8c:	f022                	sd	s0,32(sp)
    80002a8e:	ec26                	sd	s1,24(sp)
    80002a90:	e84a                	sd	s2,16(sp)
    80002a92:	e44e                	sd	s3,8(sp)
    80002a94:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a96:	00006597          	auipc	a1,0x6
    80002a9a:	b0a58593          	addi	a1,a1,-1270 # 800085a0 <syscalls+0x1a0>
    80002a9e:	00014517          	auipc	a0,0x14
    80002aa2:	60a50513          	addi	a0,a0,1546 # 800170a8 <itable>
    80002aa6:	00003097          	auipc	ra,0x3
    80002aaa:	6f8080e7          	jalr	1784(ra) # 8000619e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aae:	00014497          	auipc	s1,0x14
    80002ab2:	62248493          	addi	s1,s1,1570 # 800170d0 <itable+0x28>
    80002ab6:	00016997          	auipc	s3,0x16
    80002aba:	0aa98993          	addi	s3,s3,170 # 80018b60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002abe:	00006917          	auipc	s2,0x6
    80002ac2:	aea90913          	addi	s2,s2,-1302 # 800085a8 <syscalls+0x1a8>
    80002ac6:	85ca                	mv	a1,s2
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00001097          	auipc	ra,0x1
    80002ace:	e12080e7          	jalr	-494(ra) # 800038dc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ad2:	08848493          	addi	s1,s1,136
    80002ad6:	ff3498e3          	bne	s1,s3,80002ac6 <iinit+0x3e>
}
    80002ada:	70a2                	ld	ra,40(sp)
    80002adc:	7402                	ld	s0,32(sp)
    80002ade:	64e2                	ld	s1,24(sp)
    80002ae0:	6942                	ld	s2,16(sp)
    80002ae2:	69a2                	ld	s3,8(sp)
    80002ae4:	6145                	addi	sp,sp,48
    80002ae6:	8082                	ret

0000000080002ae8 <ialloc>:
{
    80002ae8:	7139                	addi	sp,sp,-64
    80002aea:	fc06                	sd	ra,56(sp)
    80002aec:	f822                	sd	s0,48(sp)
    80002aee:	f426                	sd	s1,40(sp)
    80002af0:	f04a                	sd	s2,32(sp)
    80002af2:	ec4e                	sd	s3,24(sp)
    80002af4:	e852                	sd	s4,16(sp)
    80002af6:	e456                	sd	s5,8(sp)
    80002af8:	e05a                	sd	s6,0(sp)
    80002afa:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afc:	00014717          	auipc	a4,0x14
    80002b00:	59872703          	lw	a4,1432(a4) # 80017094 <sb+0xc>
    80002b04:	4785                	li	a5,1
    80002b06:	04e7f863          	bgeu	a5,a4,80002b56 <ialloc+0x6e>
    80002b0a:	8aaa                	mv	s5,a0
    80002b0c:	8b2e                	mv	s6,a1
    80002b0e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b10:	00014a17          	auipc	s4,0x14
    80002b14:	578a0a13          	addi	s4,s4,1400 # 80017088 <sb>
    80002b18:	00495593          	srli	a1,s2,0x4
    80002b1c:	018a2783          	lw	a5,24(s4)
    80002b20:	9dbd                	addw	a1,a1,a5
    80002b22:	8556                	mv	a0,s5
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	94c080e7          	jalr	-1716(ra) # 80002470 <bread>
    80002b2c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b2e:	05850993          	addi	s3,a0,88
    80002b32:	00f97793          	andi	a5,s2,15
    80002b36:	079a                	slli	a5,a5,0x6
    80002b38:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3a:	00099783          	lh	a5,0(s3)
    80002b3e:	cf9d                	beqz	a5,80002b7c <ialloc+0x94>
    brelse(bp);
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	a60080e7          	jalr	-1440(ra) # 800025a0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b48:	0905                	addi	s2,s2,1
    80002b4a:	00ca2703          	lw	a4,12(s4)
    80002b4e:	0009079b          	sext.w	a5,s2
    80002b52:	fce7e3e3          	bltu	a5,a4,80002b18 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002b56:	00006517          	auipc	a0,0x6
    80002b5a:	a5a50513          	addi	a0,a0,-1446 # 800085b0 <syscalls+0x1b0>
    80002b5e:	00003097          	auipc	ra,0x3
    80002b62:	1e2080e7          	jalr	482(ra) # 80005d40 <printf>
  return 0;
    80002b66:	4501                	li	a0,0
}
    80002b68:	70e2                	ld	ra,56(sp)
    80002b6a:	7442                	ld	s0,48(sp)
    80002b6c:	74a2                	ld	s1,40(sp)
    80002b6e:	7902                	ld	s2,32(sp)
    80002b70:	69e2                	ld	s3,24(sp)
    80002b72:	6a42                	ld	s4,16(sp)
    80002b74:	6aa2                	ld	s5,8(sp)
    80002b76:	6b02                	ld	s6,0(sp)
    80002b78:	6121                	addi	sp,sp,64
    80002b7a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b7c:	04000613          	li	a2,64
    80002b80:	4581                	li	a1,0
    80002b82:	854e                	mv	a0,s3
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	5f6080e7          	jalr	1526(ra) # 8000017a <memset>
      dip->type = type;
    80002b8c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b90:	8526                	mv	a0,s1
    80002b92:	00001097          	auipc	ra,0x1
    80002b96:	c66080e7          	jalr	-922(ra) # 800037f8 <log_write>
      brelse(bp);
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	a04080e7          	jalr	-1532(ra) # 800025a0 <brelse>
      return iget(dev, inum);
    80002ba4:	0009059b          	sext.w	a1,s2
    80002ba8:	8556                	mv	a0,s5
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	da2080e7          	jalr	-606(ra) # 8000294c <iget>
    80002bb2:	bf5d                	j	80002b68 <ialloc+0x80>

0000000080002bb4 <iupdate>:
{
    80002bb4:	1101                	addi	sp,sp,-32
    80002bb6:	ec06                	sd	ra,24(sp)
    80002bb8:	e822                	sd	s0,16(sp)
    80002bba:	e426                	sd	s1,8(sp)
    80002bbc:	e04a                	sd	s2,0(sp)
    80002bbe:	1000                	addi	s0,sp,32
    80002bc0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc2:	415c                	lw	a5,4(a0)
    80002bc4:	0047d79b          	srliw	a5,a5,0x4
    80002bc8:	00014597          	auipc	a1,0x14
    80002bcc:	4d85a583          	lw	a1,1240(a1) # 800170a0 <sb+0x18>
    80002bd0:	9dbd                	addw	a1,a1,a5
    80002bd2:	4108                	lw	a0,0(a0)
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	89c080e7          	jalr	-1892(ra) # 80002470 <bread>
    80002bdc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bde:	05850793          	addi	a5,a0,88
    80002be2:	40d8                	lw	a4,4(s1)
    80002be4:	8b3d                	andi	a4,a4,15
    80002be6:	071a                	slli	a4,a4,0x6
    80002be8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bea:	04449703          	lh	a4,68(s1)
    80002bee:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bf2:	04649703          	lh	a4,70(s1)
    80002bf6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bfa:	04849703          	lh	a4,72(s1)
    80002bfe:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c02:	04a49703          	lh	a4,74(s1)
    80002c06:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c0a:	44f8                	lw	a4,76(s1)
    80002c0c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c0e:	03400613          	li	a2,52
    80002c12:	05048593          	addi	a1,s1,80
    80002c16:	00c78513          	addi	a0,a5,12
    80002c1a:	ffffd097          	auipc	ra,0xffffd
    80002c1e:	5bc080e7          	jalr	1468(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c22:	854a                	mv	a0,s2
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	bd4080e7          	jalr	-1068(ra) # 800037f8 <log_write>
  brelse(bp);
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	972080e7          	jalr	-1678(ra) # 800025a0 <brelse>
}
    80002c36:	60e2                	ld	ra,24(sp)
    80002c38:	6442                	ld	s0,16(sp)
    80002c3a:	64a2                	ld	s1,8(sp)
    80002c3c:	6902                	ld	s2,0(sp)
    80002c3e:	6105                	addi	sp,sp,32
    80002c40:	8082                	ret

0000000080002c42 <idup>:
{
    80002c42:	1101                	addi	sp,sp,-32
    80002c44:	ec06                	sd	ra,24(sp)
    80002c46:	e822                	sd	s0,16(sp)
    80002c48:	e426                	sd	s1,8(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c4e:	00014517          	auipc	a0,0x14
    80002c52:	45a50513          	addi	a0,a0,1114 # 800170a8 <itable>
    80002c56:	00003097          	auipc	ra,0x3
    80002c5a:	5d8080e7          	jalr	1496(ra) # 8000622e <acquire>
  ip->ref++;
    80002c5e:	449c                	lw	a5,8(s1)
    80002c60:	2785                	addiw	a5,a5,1
    80002c62:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c64:	00014517          	auipc	a0,0x14
    80002c68:	44450513          	addi	a0,a0,1092 # 800170a8 <itable>
    80002c6c:	00003097          	auipc	ra,0x3
    80002c70:	676080e7          	jalr	1654(ra) # 800062e2 <release>
}
    80002c74:	8526                	mv	a0,s1
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6105                	addi	sp,sp,32
    80002c7e:	8082                	ret

0000000080002c80 <ilock>:
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	e04a                	sd	s2,0(sp)
    80002c8a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8c:	c115                	beqz	a0,80002cb0 <ilock+0x30>
    80002c8e:	84aa                	mv	s1,a0
    80002c90:	451c                	lw	a5,8(a0)
    80002c92:	00f05f63          	blez	a5,80002cb0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c96:	0541                	addi	a0,a0,16
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	c7e080e7          	jalr	-898(ra) # 80003916 <acquiresleep>
  if(ip->valid == 0){
    80002ca0:	40bc                	lw	a5,64(s1)
    80002ca2:	cf99                	beqz	a5,80002cc0 <ilock+0x40>
}
    80002ca4:	60e2                	ld	ra,24(sp)
    80002ca6:	6442                	ld	s0,16(sp)
    80002ca8:	64a2                	ld	s1,8(sp)
    80002caa:	6902                	ld	s2,0(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret
    panic("ilock");
    80002cb0:	00006517          	auipc	a0,0x6
    80002cb4:	91850513          	addi	a0,a0,-1768 # 800085c8 <syscalls+0x1c8>
    80002cb8:	00003097          	auipc	ra,0x3
    80002cbc:	03e080e7          	jalr	62(ra) # 80005cf6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc0:	40dc                	lw	a5,4(s1)
    80002cc2:	0047d79b          	srliw	a5,a5,0x4
    80002cc6:	00014597          	auipc	a1,0x14
    80002cca:	3da5a583          	lw	a1,986(a1) # 800170a0 <sb+0x18>
    80002cce:	9dbd                	addw	a1,a1,a5
    80002cd0:	4088                	lw	a0,0(s1)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	79e080e7          	jalr	1950(ra) # 80002470 <bread>
    80002cda:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cdc:	05850593          	addi	a1,a0,88
    80002ce0:	40dc                	lw	a5,4(s1)
    80002ce2:	8bbd                	andi	a5,a5,15
    80002ce4:	079a                	slli	a5,a5,0x6
    80002ce6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce8:	00059783          	lh	a5,0(a1)
    80002cec:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf0:	00259783          	lh	a5,2(a1)
    80002cf4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf8:	00459783          	lh	a5,4(a1)
    80002cfc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d00:	00659783          	lh	a5,6(a1)
    80002d04:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d08:	459c                	lw	a5,8(a1)
    80002d0a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d0c:	03400613          	li	a2,52
    80002d10:	05b1                	addi	a1,a1,12
    80002d12:	05048513          	addi	a0,s1,80
    80002d16:	ffffd097          	auipc	ra,0xffffd
    80002d1a:	4c0080e7          	jalr	1216(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d1e:	854a                	mv	a0,s2
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	880080e7          	jalr	-1920(ra) # 800025a0 <brelse>
    ip->valid = 1;
    80002d28:	4785                	li	a5,1
    80002d2a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d2c:	04449783          	lh	a5,68(s1)
    80002d30:	fbb5                	bnez	a5,80002ca4 <ilock+0x24>
      panic("ilock: no type");
    80002d32:	00006517          	auipc	a0,0x6
    80002d36:	89e50513          	addi	a0,a0,-1890 # 800085d0 <syscalls+0x1d0>
    80002d3a:	00003097          	auipc	ra,0x3
    80002d3e:	fbc080e7          	jalr	-68(ra) # 80005cf6 <panic>

0000000080002d42 <iunlock>:
{
    80002d42:	1101                	addi	sp,sp,-32
    80002d44:	ec06                	sd	ra,24(sp)
    80002d46:	e822                	sd	s0,16(sp)
    80002d48:	e426                	sd	s1,8(sp)
    80002d4a:	e04a                	sd	s2,0(sp)
    80002d4c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d4e:	c905                	beqz	a0,80002d7e <iunlock+0x3c>
    80002d50:	84aa                	mv	s1,a0
    80002d52:	01050913          	addi	s2,a0,16
    80002d56:	854a                	mv	a0,s2
    80002d58:	00001097          	auipc	ra,0x1
    80002d5c:	c58080e7          	jalr	-936(ra) # 800039b0 <holdingsleep>
    80002d60:	cd19                	beqz	a0,80002d7e <iunlock+0x3c>
    80002d62:	449c                	lw	a5,8(s1)
    80002d64:	00f05d63          	blez	a5,80002d7e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d68:	854a                	mv	a0,s2
    80002d6a:	00001097          	auipc	ra,0x1
    80002d6e:	c02080e7          	jalr	-1022(ra) # 8000396c <releasesleep>
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	64a2                	ld	s1,8(sp)
    80002d78:	6902                	ld	s2,0(sp)
    80002d7a:	6105                	addi	sp,sp,32
    80002d7c:	8082                	ret
    panic("iunlock");
    80002d7e:	00006517          	auipc	a0,0x6
    80002d82:	86250513          	addi	a0,a0,-1950 # 800085e0 <syscalls+0x1e0>
    80002d86:	00003097          	auipc	ra,0x3
    80002d8a:	f70080e7          	jalr	-144(ra) # 80005cf6 <panic>

0000000080002d8e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d8e:	7179                	addi	sp,sp,-48
    80002d90:	f406                	sd	ra,40(sp)
    80002d92:	f022                	sd	s0,32(sp)
    80002d94:	ec26                	sd	s1,24(sp)
    80002d96:	e84a                	sd	s2,16(sp)
    80002d98:	e44e                	sd	s3,8(sp)
    80002d9a:	e052                	sd	s4,0(sp)
    80002d9c:	1800                	addi	s0,sp,48
    80002d9e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da0:	05050493          	addi	s1,a0,80
    80002da4:	08050913          	addi	s2,a0,128
    80002da8:	a021                	j	80002db0 <itrunc+0x22>
    80002daa:	0491                	addi	s1,s1,4
    80002dac:	01248d63          	beq	s1,s2,80002dc6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002db0:	408c                	lw	a1,0(s1)
    80002db2:	dde5                	beqz	a1,80002daa <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db4:	0009a503          	lw	a0,0(s3)
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	8fc080e7          	jalr	-1796(ra) # 800026b4 <bfree>
      ip->addrs[i] = 0;
    80002dc0:	0004a023          	sw	zero,0(s1)
    80002dc4:	b7dd                	j	80002daa <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc6:	0809a583          	lw	a1,128(s3)
    80002dca:	e185                	bnez	a1,80002dea <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dcc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd0:	854e                	mv	a0,s3
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	de2080e7          	jalr	-542(ra) # 80002bb4 <iupdate>
}
    80002dda:	70a2                	ld	ra,40(sp)
    80002ddc:	7402                	ld	s0,32(sp)
    80002dde:	64e2                	ld	s1,24(sp)
    80002de0:	6942                	ld	s2,16(sp)
    80002de2:	69a2                	ld	s3,8(sp)
    80002de4:	6a02                	ld	s4,0(sp)
    80002de6:	6145                	addi	sp,sp,48
    80002de8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dea:	0009a503          	lw	a0,0(s3)
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	682080e7          	jalr	1666(ra) # 80002470 <bread>
    80002df6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002df8:	05850493          	addi	s1,a0,88
    80002dfc:	45850913          	addi	s2,a0,1112
    80002e00:	a021                	j	80002e08 <itrunc+0x7a>
    80002e02:	0491                	addi	s1,s1,4
    80002e04:	01248b63          	beq	s1,s2,80002e1a <itrunc+0x8c>
      if(a[j])
    80002e08:	408c                	lw	a1,0(s1)
    80002e0a:	dde5                	beqz	a1,80002e02 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e0c:	0009a503          	lw	a0,0(s3)
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	8a4080e7          	jalr	-1884(ra) # 800026b4 <bfree>
    80002e18:	b7ed                	j	80002e02 <itrunc+0x74>
    brelse(bp);
    80002e1a:	8552                	mv	a0,s4
    80002e1c:	fffff097          	auipc	ra,0xfffff
    80002e20:	784080e7          	jalr	1924(ra) # 800025a0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e24:	0809a583          	lw	a1,128(s3)
    80002e28:	0009a503          	lw	a0,0(s3)
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	888080e7          	jalr	-1912(ra) # 800026b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e34:	0809a023          	sw	zero,128(s3)
    80002e38:	bf51                	j	80002dcc <itrunc+0x3e>

0000000080002e3a <iput>:
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	e426                	sd	s1,8(sp)
    80002e42:	e04a                	sd	s2,0(sp)
    80002e44:	1000                	addi	s0,sp,32
    80002e46:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e48:	00014517          	auipc	a0,0x14
    80002e4c:	26050513          	addi	a0,a0,608 # 800170a8 <itable>
    80002e50:	00003097          	auipc	ra,0x3
    80002e54:	3de080e7          	jalr	990(ra) # 8000622e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e58:	4498                	lw	a4,8(s1)
    80002e5a:	4785                	li	a5,1
    80002e5c:	02f70363          	beq	a4,a5,80002e82 <iput+0x48>
  ip->ref--;
    80002e60:	449c                	lw	a5,8(s1)
    80002e62:	37fd                	addiw	a5,a5,-1
    80002e64:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e66:	00014517          	auipc	a0,0x14
    80002e6a:	24250513          	addi	a0,a0,578 # 800170a8 <itable>
    80002e6e:	00003097          	auipc	ra,0x3
    80002e72:	474080e7          	jalr	1140(ra) # 800062e2 <release>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	64a2                	ld	s1,8(sp)
    80002e7c:	6902                	ld	s2,0(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e82:	40bc                	lw	a5,64(s1)
    80002e84:	dff1                	beqz	a5,80002e60 <iput+0x26>
    80002e86:	04a49783          	lh	a5,74(s1)
    80002e8a:	fbf9                	bnez	a5,80002e60 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e8c:	01048913          	addi	s2,s1,16
    80002e90:	854a                	mv	a0,s2
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	a84080e7          	jalr	-1404(ra) # 80003916 <acquiresleep>
    release(&itable.lock);
    80002e9a:	00014517          	auipc	a0,0x14
    80002e9e:	20e50513          	addi	a0,a0,526 # 800170a8 <itable>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	440080e7          	jalr	1088(ra) # 800062e2 <release>
    itrunc(ip);
    80002eaa:	8526                	mv	a0,s1
    80002eac:	00000097          	auipc	ra,0x0
    80002eb0:	ee2080e7          	jalr	-286(ra) # 80002d8e <itrunc>
    ip->type = 0;
    80002eb4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eb8:	8526                	mv	a0,s1
    80002eba:	00000097          	auipc	ra,0x0
    80002ebe:	cfa080e7          	jalr	-774(ra) # 80002bb4 <iupdate>
    ip->valid = 0;
    80002ec2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	00001097          	auipc	ra,0x1
    80002ecc:	aa4080e7          	jalr	-1372(ra) # 8000396c <releasesleep>
    acquire(&itable.lock);
    80002ed0:	00014517          	auipc	a0,0x14
    80002ed4:	1d850513          	addi	a0,a0,472 # 800170a8 <itable>
    80002ed8:	00003097          	auipc	ra,0x3
    80002edc:	356080e7          	jalr	854(ra) # 8000622e <acquire>
    80002ee0:	b741                	j	80002e60 <iput+0x26>

0000000080002ee2 <iunlockput>:
{
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	1000                	addi	s0,sp,32
    80002eec:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eee:	00000097          	auipc	ra,0x0
    80002ef2:	e54080e7          	jalr	-428(ra) # 80002d42 <iunlock>
  iput(ip);
    80002ef6:	8526                	mv	a0,s1
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	f42080e7          	jalr	-190(ra) # 80002e3a <iput>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	64a2                	ld	s1,8(sp)
    80002f06:	6105                	addi	sp,sp,32
    80002f08:	8082                	ret

0000000080002f0a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0a:	1141                	addi	sp,sp,-16
    80002f0c:	e422                	sd	s0,8(sp)
    80002f0e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f10:	411c                	lw	a5,0(a0)
    80002f12:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f14:	415c                	lw	a5,4(a0)
    80002f16:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f18:	04451783          	lh	a5,68(a0)
    80002f1c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f20:	04a51783          	lh	a5,74(a0)
    80002f24:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f28:	04c56783          	lwu	a5,76(a0)
    80002f2c:	e99c                	sd	a5,16(a1)
}
    80002f2e:	6422                	ld	s0,8(sp)
    80002f30:	0141                	addi	sp,sp,16
    80002f32:	8082                	ret

0000000080002f34 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f34:	457c                	lw	a5,76(a0)
    80002f36:	0ed7e963          	bltu	a5,a3,80003028 <readi+0xf4>
{
    80002f3a:	7159                	addi	sp,sp,-112
    80002f3c:	f486                	sd	ra,104(sp)
    80002f3e:	f0a2                	sd	s0,96(sp)
    80002f40:	eca6                	sd	s1,88(sp)
    80002f42:	e8ca                	sd	s2,80(sp)
    80002f44:	e4ce                	sd	s3,72(sp)
    80002f46:	e0d2                	sd	s4,64(sp)
    80002f48:	fc56                	sd	s5,56(sp)
    80002f4a:	f85a                	sd	s6,48(sp)
    80002f4c:	f45e                	sd	s7,40(sp)
    80002f4e:	f062                	sd	s8,32(sp)
    80002f50:	ec66                	sd	s9,24(sp)
    80002f52:	e86a                	sd	s10,16(sp)
    80002f54:	e46e                	sd	s11,8(sp)
    80002f56:	1880                	addi	s0,sp,112
    80002f58:	8b2a                	mv	s6,a0
    80002f5a:	8bae                	mv	s7,a1
    80002f5c:	8a32                	mv	s4,a2
    80002f5e:	84b6                	mv	s1,a3
    80002f60:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f62:	9f35                	addw	a4,a4,a3
    return 0;
    80002f64:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f66:	0ad76063          	bltu	a4,a3,80003006 <readi+0xd2>
  if(off + n > ip->size)
    80002f6a:	00e7f463          	bgeu	a5,a4,80002f72 <readi+0x3e>
    n = ip->size - off;
    80002f6e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f72:	0a0a8963          	beqz	s5,80003024 <readi+0xf0>
    80002f76:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f78:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f7c:	5c7d                	li	s8,-1
    80002f7e:	a82d                	j	80002fb8 <readi+0x84>
    80002f80:	020d1d93          	slli	s11,s10,0x20
    80002f84:	020ddd93          	srli	s11,s11,0x20
    80002f88:	05890613          	addi	a2,s2,88
    80002f8c:	86ee                	mv	a3,s11
    80002f8e:	963a                	add	a2,a2,a4
    80002f90:	85d2                	mv	a1,s4
    80002f92:	855e                	mv	a0,s7
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	b12080e7          	jalr	-1262(ra) # 80001aa6 <either_copyout>
    80002f9c:	05850d63          	beq	a0,s8,80002ff6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	5fe080e7          	jalr	1534(ra) # 800025a0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002faa:	013d09bb          	addw	s3,s10,s3
    80002fae:	009d04bb          	addw	s1,s10,s1
    80002fb2:	9a6e                	add	s4,s4,s11
    80002fb4:	0559f763          	bgeu	s3,s5,80003002 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fb8:	00a4d59b          	srliw	a1,s1,0xa
    80002fbc:	855a                	mv	a0,s6
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	8a4080e7          	jalr	-1884(ra) # 80002862 <bmap>
    80002fc6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fca:	cd85                	beqz	a1,80003002 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fcc:	000b2503          	lw	a0,0(s6)
    80002fd0:	fffff097          	auipc	ra,0xfffff
    80002fd4:	4a0080e7          	jalr	1184(ra) # 80002470 <bread>
    80002fd8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fda:	3ff4f713          	andi	a4,s1,1023
    80002fde:	40ec87bb          	subw	a5,s9,a4
    80002fe2:	413a86bb          	subw	a3,s5,s3
    80002fe6:	8d3e                	mv	s10,a5
    80002fe8:	2781                	sext.w	a5,a5
    80002fea:	0006861b          	sext.w	a2,a3
    80002fee:	f8f679e3          	bgeu	a2,a5,80002f80 <readi+0x4c>
    80002ff2:	8d36                	mv	s10,a3
    80002ff4:	b771                	j	80002f80 <readi+0x4c>
      brelse(bp);
    80002ff6:	854a                	mv	a0,s2
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	5a8080e7          	jalr	1448(ra) # 800025a0 <brelse>
      tot = -1;
    80003000:	59fd                	li	s3,-1
  }
  return tot;
    80003002:	0009851b          	sext.w	a0,s3
}
    80003006:	70a6                	ld	ra,104(sp)
    80003008:	7406                	ld	s0,96(sp)
    8000300a:	64e6                	ld	s1,88(sp)
    8000300c:	6946                	ld	s2,80(sp)
    8000300e:	69a6                	ld	s3,72(sp)
    80003010:	6a06                	ld	s4,64(sp)
    80003012:	7ae2                	ld	s5,56(sp)
    80003014:	7b42                	ld	s6,48(sp)
    80003016:	7ba2                	ld	s7,40(sp)
    80003018:	7c02                	ld	s8,32(sp)
    8000301a:	6ce2                	ld	s9,24(sp)
    8000301c:	6d42                	ld	s10,16(sp)
    8000301e:	6da2                	ld	s11,8(sp)
    80003020:	6165                	addi	sp,sp,112
    80003022:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003024:	89d6                	mv	s3,s5
    80003026:	bff1                	j	80003002 <readi+0xce>
    return 0;
    80003028:	4501                	li	a0,0
}
    8000302a:	8082                	ret

000000008000302c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302c:	457c                	lw	a5,76(a0)
    8000302e:	10d7e863          	bltu	a5,a3,8000313e <writei+0x112>
{
    80003032:	7159                	addi	sp,sp,-112
    80003034:	f486                	sd	ra,104(sp)
    80003036:	f0a2                	sd	s0,96(sp)
    80003038:	eca6                	sd	s1,88(sp)
    8000303a:	e8ca                	sd	s2,80(sp)
    8000303c:	e4ce                	sd	s3,72(sp)
    8000303e:	e0d2                	sd	s4,64(sp)
    80003040:	fc56                	sd	s5,56(sp)
    80003042:	f85a                	sd	s6,48(sp)
    80003044:	f45e                	sd	s7,40(sp)
    80003046:	f062                	sd	s8,32(sp)
    80003048:	ec66                	sd	s9,24(sp)
    8000304a:	e86a                	sd	s10,16(sp)
    8000304c:	e46e                	sd	s11,8(sp)
    8000304e:	1880                	addi	s0,sp,112
    80003050:	8aaa                	mv	s5,a0
    80003052:	8bae                	mv	s7,a1
    80003054:	8a32                	mv	s4,a2
    80003056:	8936                	mv	s2,a3
    80003058:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305a:	00e687bb          	addw	a5,a3,a4
    8000305e:	0ed7e263          	bltu	a5,a3,80003142 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003062:	00043737          	lui	a4,0x43
    80003066:	0ef76063          	bltu	a4,a5,80003146 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306a:	0c0b0863          	beqz	s6,8000313a <writei+0x10e>
    8000306e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003070:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003074:	5c7d                	li	s8,-1
    80003076:	a091                	j	800030ba <writei+0x8e>
    80003078:	020d1d93          	slli	s11,s10,0x20
    8000307c:	020ddd93          	srli	s11,s11,0x20
    80003080:	05848513          	addi	a0,s1,88
    80003084:	86ee                	mv	a3,s11
    80003086:	8652                	mv	a2,s4
    80003088:	85de                	mv	a1,s7
    8000308a:	953a                	add	a0,a0,a4
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	a70080e7          	jalr	-1424(ra) # 80001afc <either_copyin>
    80003094:	07850263          	beq	a0,s8,800030f8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003098:	8526                	mv	a0,s1
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	75e080e7          	jalr	1886(ra) # 800037f8 <log_write>
    brelse(bp);
    800030a2:	8526                	mv	a0,s1
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	4fc080e7          	jalr	1276(ra) # 800025a0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ac:	013d09bb          	addw	s3,s10,s3
    800030b0:	012d093b          	addw	s2,s10,s2
    800030b4:	9a6e                	add	s4,s4,s11
    800030b6:	0569f663          	bgeu	s3,s6,80003102 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030ba:	00a9559b          	srliw	a1,s2,0xa
    800030be:	8556                	mv	a0,s5
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	7a2080e7          	jalr	1954(ra) # 80002862 <bmap>
    800030c8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030cc:	c99d                	beqz	a1,80003102 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030ce:	000aa503          	lw	a0,0(s5)
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	39e080e7          	jalr	926(ra) # 80002470 <bread>
    800030da:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030dc:	3ff97713          	andi	a4,s2,1023
    800030e0:	40ec87bb          	subw	a5,s9,a4
    800030e4:	413b06bb          	subw	a3,s6,s3
    800030e8:	8d3e                	mv	s10,a5
    800030ea:	2781                	sext.w	a5,a5
    800030ec:	0006861b          	sext.w	a2,a3
    800030f0:	f8f674e3          	bgeu	a2,a5,80003078 <writei+0x4c>
    800030f4:	8d36                	mv	s10,a3
    800030f6:	b749                	j	80003078 <writei+0x4c>
      brelse(bp);
    800030f8:	8526                	mv	a0,s1
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	4a6080e7          	jalr	1190(ra) # 800025a0 <brelse>
  }

  if(off > ip->size)
    80003102:	04caa783          	lw	a5,76(s5)
    80003106:	0127f463          	bgeu	a5,s2,8000310e <writei+0xe2>
    ip->size = off;
    8000310a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000310e:	8556                	mv	a0,s5
    80003110:	00000097          	auipc	ra,0x0
    80003114:	aa4080e7          	jalr	-1372(ra) # 80002bb4 <iupdate>

  return tot;
    80003118:	0009851b          	sext.w	a0,s3
}
    8000311c:	70a6                	ld	ra,104(sp)
    8000311e:	7406                	ld	s0,96(sp)
    80003120:	64e6                	ld	s1,88(sp)
    80003122:	6946                	ld	s2,80(sp)
    80003124:	69a6                	ld	s3,72(sp)
    80003126:	6a06                	ld	s4,64(sp)
    80003128:	7ae2                	ld	s5,56(sp)
    8000312a:	7b42                	ld	s6,48(sp)
    8000312c:	7ba2                	ld	s7,40(sp)
    8000312e:	7c02                	ld	s8,32(sp)
    80003130:	6ce2                	ld	s9,24(sp)
    80003132:	6d42                	ld	s10,16(sp)
    80003134:	6da2                	ld	s11,8(sp)
    80003136:	6165                	addi	sp,sp,112
    80003138:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313a:	89da                	mv	s3,s6
    8000313c:	bfc9                	j	8000310e <writei+0xe2>
    return -1;
    8000313e:	557d                	li	a0,-1
}
    80003140:	8082                	ret
    return -1;
    80003142:	557d                	li	a0,-1
    80003144:	bfe1                	j	8000311c <writei+0xf0>
    return -1;
    80003146:	557d                	li	a0,-1
    80003148:	bfd1                	j	8000311c <writei+0xf0>

000000008000314a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000314a:	1141                	addi	sp,sp,-16
    8000314c:	e406                	sd	ra,8(sp)
    8000314e:	e022                	sd	s0,0(sp)
    80003150:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003152:	4639                	li	a2,14
    80003154:	ffffd097          	auipc	ra,0xffffd
    80003158:	0f6080e7          	jalr	246(ra) # 8000024a <strncmp>
}
    8000315c:	60a2                	ld	ra,8(sp)
    8000315e:	6402                	ld	s0,0(sp)
    80003160:	0141                	addi	sp,sp,16
    80003162:	8082                	ret

0000000080003164 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003164:	7139                	addi	sp,sp,-64
    80003166:	fc06                	sd	ra,56(sp)
    80003168:	f822                	sd	s0,48(sp)
    8000316a:	f426                	sd	s1,40(sp)
    8000316c:	f04a                	sd	s2,32(sp)
    8000316e:	ec4e                	sd	s3,24(sp)
    80003170:	e852                	sd	s4,16(sp)
    80003172:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003174:	04451703          	lh	a4,68(a0)
    80003178:	4785                	li	a5,1
    8000317a:	00f71a63          	bne	a4,a5,8000318e <dirlookup+0x2a>
    8000317e:	892a                	mv	s2,a0
    80003180:	89ae                	mv	s3,a1
    80003182:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003184:	457c                	lw	a5,76(a0)
    80003186:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003188:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318a:	e79d                	bnez	a5,800031b8 <dirlookup+0x54>
    8000318c:	a8a5                	j	80003204 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000318e:	00005517          	auipc	a0,0x5
    80003192:	45a50513          	addi	a0,a0,1114 # 800085e8 <syscalls+0x1e8>
    80003196:	00003097          	auipc	ra,0x3
    8000319a:	b60080e7          	jalr	-1184(ra) # 80005cf6 <panic>
      panic("dirlookup read");
    8000319e:	00005517          	auipc	a0,0x5
    800031a2:	46250513          	addi	a0,a0,1122 # 80008600 <syscalls+0x200>
    800031a6:	00003097          	auipc	ra,0x3
    800031aa:	b50080e7          	jalr	-1200(ra) # 80005cf6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ae:	24c1                	addiw	s1,s1,16
    800031b0:	04c92783          	lw	a5,76(s2)
    800031b4:	04f4f763          	bgeu	s1,a5,80003202 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031b8:	4741                	li	a4,16
    800031ba:	86a6                	mv	a3,s1
    800031bc:	fc040613          	addi	a2,s0,-64
    800031c0:	4581                	li	a1,0
    800031c2:	854a                	mv	a0,s2
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	d70080e7          	jalr	-656(ra) # 80002f34 <readi>
    800031cc:	47c1                	li	a5,16
    800031ce:	fcf518e3          	bne	a0,a5,8000319e <dirlookup+0x3a>
    if(de.inum == 0)
    800031d2:	fc045783          	lhu	a5,-64(s0)
    800031d6:	dfe1                	beqz	a5,800031ae <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031d8:	fc240593          	addi	a1,s0,-62
    800031dc:	854e                	mv	a0,s3
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	f6c080e7          	jalr	-148(ra) # 8000314a <namecmp>
    800031e6:	f561                	bnez	a0,800031ae <dirlookup+0x4a>
      if(poff)
    800031e8:	000a0463          	beqz	s4,800031f0 <dirlookup+0x8c>
        *poff = off;
    800031ec:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031f0:	fc045583          	lhu	a1,-64(s0)
    800031f4:	00092503          	lw	a0,0(s2)
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	754080e7          	jalr	1876(ra) # 8000294c <iget>
    80003200:	a011                	j	80003204 <dirlookup+0xa0>
  return 0;
    80003202:	4501                	li	a0,0
}
    80003204:	70e2                	ld	ra,56(sp)
    80003206:	7442                	ld	s0,48(sp)
    80003208:	74a2                	ld	s1,40(sp)
    8000320a:	7902                	ld	s2,32(sp)
    8000320c:	69e2                	ld	s3,24(sp)
    8000320e:	6a42                	ld	s4,16(sp)
    80003210:	6121                	addi	sp,sp,64
    80003212:	8082                	ret

0000000080003214 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003214:	711d                	addi	sp,sp,-96
    80003216:	ec86                	sd	ra,88(sp)
    80003218:	e8a2                	sd	s0,80(sp)
    8000321a:	e4a6                	sd	s1,72(sp)
    8000321c:	e0ca                	sd	s2,64(sp)
    8000321e:	fc4e                	sd	s3,56(sp)
    80003220:	f852                	sd	s4,48(sp)
    80003222:	f456                	sd	s5,40(sp)
    80003224:	f05a                	sd	s6,32(sp)
    80003226:	ec5e                	sd	s7,24(sp)
    80003228:	e862                	sd	s8,16(sp)
    8000322a:	e466                	sd	s9,8(sp)
    8000322c:	1080                	addi	s0,sp,96
    8000322e:	84aa                	mv	s1,a0
    80003230:	8b2e                	mv	s6,a1
    80003232:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003234:	00054703          	lbu	a4,0(a0)
    80003238:	02f00793          	li	a5,47
    8000323c:	02f70263          	beq	a4,a5,80003260 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003240:	ffffe097          	auipc	ra,0xffffe
    80003244:	d08080e7          	jalr	-760(ra) # 80000f48 <myproc>
    80003248:	15853503          	ld	a0,344(a0)
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	9f6080e7          	jalr	-1546(ra) # 80002c42 <idup>
    80003254:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003256:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000325a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000325c:	4b85                	li	s7,1
    8000325e:	a875                	j	8000331a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003260:	4585                	li	a1,1
    80003262:	4505                	li	a0,1
    80003264:	fffff097          	auipc	ra,0xfffff
    80003268:	6e8080e7          	jalr	1768(ra) # 8000294c <iget>
    8000326c:	8a2a                	mv	s4,a0
    8000326e:	b7e5                	j	80003256 <namex+0x42>
      iunlockput(ip);
    80003270:	8552                	mv	a0,s4
    80003272:	00000097          	auipc	ra,0x0
    80003276:	c70080e7          	jalr	-912(ra) # 80002ee2 <iunlockput>
      return 0;
    8000327a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000327c:	8552                	mv	a0,s4
    8000327e:	60e6                	ld	ra,88(sp)
    80003280:	6446                	ld	s0,80(sp)
    80003282:	64a6                	ld	s1,72(sp)
    80003284:	6906                	ld	s2,64(sp)
    80003286:	79e2                	ld	s3,56(sp)
    80003288:	7a42                	ld	s4,48(sp)
    8000328a:	7aa2                	ld	s5,40(sp)
    8000328c:	7b02                	ld	s6,32(sp)
    8000328e:	6be2                	ld	s7,24(sp)
    80003290:	6c42                	ld	s8,16(sp)
    80003292:	6ca2                	ld	s9,8(sp)
    80003294:	6125                	addi	sp,sp,96
    80003296:	8082                	ret
      iunlock(ip);
    80003298:	8552                	mv	a0,s4
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	aa8080e7          	jalr	-1368(ra) # 80002d42 <iunlock>
      return ip;
    800032a2:	bfe9                	j	8000327c <namex+0x68>
      iunlockput(ip);
    800032a4:	8552                	mv	a0,s4
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	c3c080e7          	jalr	-964(ra) # 80002ee2 <iunlockput>
      return 0;
    800032ae:	8a4e                	mv	s4,s3
    800032b0:	b7f1                	j	8000327c <namex+0x68>
  len = path - s;
    800032b2:	40998633          	sub	a2,s3,s1
    800032b6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032ba:	099c5863          	bge	s8,s9,8000334a <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032be:	4639                	li	a2,14
    800032c0:	85a6                	mv	a1,s1
    800032c2:	8556                	mv	a0,s5
    800032c4:	ffffd097          	auipc	ra,0xffffd
    800032c8:	f12080e7          	jalr	-238(ra) # 800001d6 <memmove>
    800032cc:	84ce                	mv	s1,s3
  while(*path == '/')
    800032ce:	0004c783          	lbu	a5,0(s1)
    800032d2:	01279763          	bne	a5,s2,800032e0 <namex+0xcc>
    path++;
    800032d6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	ff278de3          	beq	a5,s2,800032d6 <namex+0xc2>
    ilock(ip);
    800032e0:	8552                	mv	a0,s4
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	99e080e7          	jalr	-1634(ra) # 80002c80 <ilock>
    if(ip->type != T_DIR){
    800032ea:	044a1783          	lh	a5,68(s4)
    800032ee:	f97791e3          	bne	a5,s7,80003270 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032f2:	000b0563          	beqz	s6,800032fc <namex+0xe8>
    800032f6:	0004c783          	lbu	a5,0(s1)
    800032fa:	dfd9                	beqz	a5,80003298 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032fc:	4601                	li	a2,0
    800032fe:	85d6                	mv	a1,s5
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	e62080e7          	jalr	-414(ra) # 80003164 <dirlookup>
    8000330a:	89aa                	mv	s3,a0
    8000330c:	dd41                	beqz	a0,800032a4 <namex+0x90>
    iunlockput(ip);
    8000330e:	8552                	mv	a0,s4
    80003310:	00000097          	auipc	ra,0x0
    80003314:	bd2080e7          	jalr	-1070(ra) # 80002ee2 <iunlockput>
    ip = next;
    80003318:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000331a:	0004c783          	lbu	a5,0(s1)
    8000331e:	01279763          	bne	a5,s2,8000332c <namex+0x118>
    path++;
    80003322:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003324:	0004c783          	lbu	a5,0(s1)
    80003328:	ff278de3          	beq	a5,s2,80003322 <namex+0x10e>
  if(*path == 0)
    8000332c:	cb9d                	beqz	a5,80003362 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	89a6                	mv	s3,s1
  len = path - s;
    80003334:	4c81                	li	s9,0
    80003336:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003338:	01278963          	beq	a5,s2,8000334a <namex+0x136>
    8000333c:	dbbd                	beqz	a5,800032b2 <namex+0x9e>
    path++;
    8000333e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003340:	0009c783          	lbu	a5,0(s3)
    80003344:	ff279ce3          	bne	a5,s2,8000333c <namex+0x128>
    80003348:	b7ad                	j	800032b2 <namex+0x9e>
    memmove(name, s, len);
    8000334a:	2601                	sext.w	a2,a2
    8000334c:	85a6                	mv	a1,s1
    8000334e:	8556                	mv	a0,s5
    80003350:	ffffd097          	auipc	ra,0xffffd
    80003354:	e86080e7          	jalr	-378(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003358:	9cd6                	add	s9,s9,s5
    8000335a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000335e:	84ce                	mv	s1,s3
    80003360:	b7bd                	j	800032ce <namex+0xba>
  if(nameiparent){
    80003362:	f00b0de3          	beqz	s6,8000327c <namex+0x68>
    iput(ip);
    80003366:	8552                	mv	a0,s4
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	ad2080e7          	jalr	-1326(ra) # 80002e3a <iput>
    return 0;
    80003370:	4a01                	li	s4,0
    80003372:	b729                	j	8000327c <namex+0x68>

0000000080003374 <dirlink>:
{
    80003374:	7139                	addi	sp,sp,-64
    80003376:	fc06                	sd	ra,56(sp)
    80003378:	f822                	sd	s0,48(sp)
    8000337a:	f426                	sd	s1,40(sp)
    8000337c:	f04a                	sd	s2,32(sp)
    8000337e:	ec4e                	sd	s3,24(sp)
    80003380:	e852                	sd	s4,16(sp)
    80003382:	0080                	addi	s0,sp,64
    80003384:	892a                	mv	s2,a0
    80003386:	8a2e                	mv	s4,a1
    80003388:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000338a:	4601                	li	a2,0
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	dd8080e7          	jalr	-552(ra) # 80003164 <dirlookup>
    80003394:	e93d                	bnez	a0,8000340a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003396:	04c92483          	lw	s1,76(s2)
    8000339a:	c49d                	beqz	s1,800033c8 <dirlink+0x54>
    8000339c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339e:	4741                	li	a4,16
    800033a0:	86a6                	mv	a3,s1
    800033a2:	fc040613          	addi	a2,s0,-64
    800033a6:	4581                	li	a1,0
    800033a8:	854a                	mv	a0,s2
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	b8a080e7          	jalr	-1142(ra) # 80002f34 <readi>
    800033b2:	47c1                	li	a5,16
    800033b4:	06f51163          	bne	a0,a5,80003416 <dirlink+0xa2>
    if(de.inum == 0)
    800033b8:	fc045783          	lhu	a5,-64(s0)
    800033bc:	c791                	beqz	a5,800033c8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033be:	24c1                	addiw	s1,s1,16
    800033c0:	04c92783          	lw	a5,76(s2)
    800033c4:	fcf4ede3          	bltu	s1,a5,8000339e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033c8:	4639                	li	a2,14
    800033ca:	85d2                	mv	a1,s4
    800033cc:	fc240513          	addi	a0,s0,-62
    800033d0:	ffffd097          	auipc	ra,0xffffd
    800033d4:	eb6080e7          	jalr	-330(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033d8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033dc:	4741                	li	a4,16
    800033de:	86a6                	mv	a3,s1
    800033e0:	fc040613          	addi	a2,s0,-64
    800033e4:	4581                	li	a1,0
    800033e6:	854a                	mv	a0,s2
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	c44080e7          	jalr	-956(ra) # 8000302c <writei>
    800033f0:	1541                	addi	a0,a0,-16
    800033f2:	00a03533          	snez	a0,a0
    800033f6:	40a00533          	neg	a0,a0
}
    800033fa:	70e2                	ld	ra,56(sp)
    800033fc:	7442                	ld	s0,48(sp)
    800033fe:	74a2                	ld	s1,40(sp)
    80003400:	7902                	ld	s2,32(sp)
    80003402:	69e2                	ld	s3,24(sp)
    80003404:	6a42                	ld	s4,16(sp)
    80003406:	6121                	addi	sp,sp,64
    80003408:	8082                	ret
    iput(ip);
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	a30080e7          	jalr	-1488(ra) # 80002e3a <iput>
    return -1;
    80003412:	557d                	li	a0,-1
    80003414:	b7dd                	j	800033fa <dirlink+0x86>
      panic("dirlink read");
    80003416:	00005517          	auipc	a0,0x5
    8000341a:	1fa50513          	addi	a0,a0,506 # 80008610 <syscalls+0x210>
    8000341e:	00003097          	auipc	ra,0x3
    80003422:	8d8080e7          	jalr	-1832(ra) # 80005cf6 <panic>

0000000080003426 <namei>:

struct inode*
namei(char *path)
{
    80003426:	1101                	addi	sp,sp,-32
    80003428:	ec06                	sd	ra,24(sp)
    8000342a:	e822                	sd	s0,16(sp)
    8000342c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000342e:	fe040613          	addi	a2,s0,-32
    80003432:	4581                	li	a1,0
    80003434:	00000097          	auipc	ra,0x0
    80003438:	de0080e7          	jalr	-544(ra) # 80003214 <namex>
}
    8000343c:	60e2                	ld	ra,24(sp)
    8000343e:	6442                	ld	s0,16(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003444:	1141                	addi	sp,sp,-16
    80003446:	e406                	sd	ra,8(sp)
    80003448:	e022                	sd	s0,0(sp)
    8000344a:	0800                	addi	s0,sp,16
    8000344c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000344e:	4585                	li	a1,1
    80003450:	00000097          	auipc	ra,0x0
    80003454:	dc4080e7          	jalr	-572(ra) # 80003214 <namex>
}
    80003458:	60a2                	ld	ra,8(sp)
    8000345a:	6402                	ld	s0,0(sp)
    8000345c:	0141                	addi	sp,sp,16
    8000345e:	8082                	ret

0000000080003460 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003460:	1101                	addi	sp,sp,-32
    80003462:	ec06                	sd	ra,24(sp)
    80003464:	e822                	sd	s0,16(sp)
    80003466:	e426                	sd	s1,8(sp)
    80003468:	e04a                	sd	s2,0(sp)
    8000346a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000346c:	00015917          	auipc	s2,0x15
    80003470:	6e490913          	addi	s2,s2,1764 # 80018b50 <log>
    80003474:	01892583          	lw	a1,24(s2)
    80003478:	02892503          	lw	a0,40(s2)
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	ff4080e7          	jalr	-12(ra) # 80002470 <bread>
    80003484:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003486:	02c92603          	lw	a2,44(s2)
    8000348a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000348c:	00c05f63          	blez	a2,800034aa <write_head+0x4a>
    80003490:	00015717          	auipc	a4,0x15
    80003494:	6f070713          	addi	a4,a4,1776 # 80018b80 <log+0x30>
    80003498:	87aa                	mv	a5,a0
    8000349a:	060a                	slli	a2,a2,0x2
    8000349c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000349e:	4314                	lw	a3,0(a4)
    800034a0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034a2:	0711                	addi	a4,a4,4
    800034a4:	0791                	addi	a5,a5,4
    800034a6:	fec79ce3          	bne	a5,a2,8000349e <write_head+0x3e>
  }
  bwrite(buf);
    800034aa:	8526                	mv	a0,s1
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	0b6080e7          	jalr	182(ra) # 80002562 <bwrite>
  brelse(buf);
    800034b4:	8526                	mv	a0,s1
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	0ea080e7          	jalr	234(ra) # 800025a0 <brelse>
}
    800034be:	60e2                	ld	ra,24(sp)
    800034c0:	6442                	ld	s0,16(sp)
    800034c2:	64a2                	ld	s1,8(sp)
    800034c4:	6902                	ld	s2,0(sp)
    800034c6:	6105                	addi	sp,sp,32
    800034c8:	8082                	ret

00000000800034ca <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ca:	00015797          	auipc	a5,0x15
    800034ce:	6b27a783          	lw	a5,1714(a5) # 80018b7c <log+0x2c>
    800034d2:	0af05d63          	blez	a5,8000358c <install_trans+0xc2>
{
    800034d6:	7139                	addi	sp,sp,-64
    800034d8:	fc06                	sd	ra,56(sp)
    800034da:	f822                	sd	s0,48(sp)
    800034dc:	f426                	sd	s1,40(sp)
    800034de:	f04a                	sd	s2,32(sp)
    800034e0:	ec4e                	sd	s3,24(sp)
    800034e2:	e852                	sd	s4,16(sp)
    800034e4:	e456                	sd	s5,8(sp)
    800034e6:	e05a                	sd	s6,0(sp)
    800034e8:	0080                	addi	s0,sp,64
    800034ea:	8b2a                	mv	s6,a0
    800034ec:	00015a97          	auipc	s5,0x15
    800034f0:	694a8a93          	addi	s5,s5,1684 # 80018b80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f6:	00015997          	auipc	s3,0x15
    800034fa:	65a98993          	addi	s3,s3,1626 # 80018b50 <log>
    800034fe:	a00d                	j	80003520 <install_trans+0x56>
    brelse(lbuf);
    80003500:	854a                	mv	a0,s2
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	09e080e7          	jalr	158(ra) # 800025a0 <brelse>
    brelse(dbuf);
    8000350a:	8526                	mv	a0,s1
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	094080e7          	jalr	148(ra) # 800025a0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003514:	2a05                	addiw	s4,s4,1
    80003516:	0a91                	addi	s5,s5,4
    80003518:	02c9a783          	lw	a5,44(s3)
    8000351c:	04fa5e63          	bge	s4,a5,80003578 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003520:	0189a583          	lw	a1,24(s3)
    80003524:	014585bb          	addw	a1,a1,s4
    80003528:	2585                	addiw	a1,a1,1
    8000352a:	0289a503          	lw	a0,40(s3)
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	f42080e7          	jalr	-190(ra) # 80002470 <bread>
    80003536:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003538:	000aa583          	lw	a1,0(s5)
    8000353c:	0289a503          	lw	a0,40(s3)
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	f30080e7          	jalr	-208(ra) # 80002470 <bread>
    80003548:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000354a:	40000613          	li	a2,1024
    8000354e:	05890593          	addi	a1,s2,88
    80003552:	05850513          	addi	a0,a0,88
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	c80080e7          	jalr	-896(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000355e:	8526                	mv	a0,s1
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	002080e7          	jalr	2(ra) # 80002562 <bwrite>
    if(recovering == 0)
    80003568:	f80b1ce3          	bnez	s6,80003500 <install_trans+0x36>
      bunpin(dbuf);
    8000356c:	8526                	mv	a0,s1
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	10a080e7          	jalr	266(ra) # 80002678 <bunpin>
    80003576:	b769                	j	80003500 <install_trans+0x36>
}
    80003578:	70e2                	ld	ra,56(sp)
    8000357a:	7442                	ld	s0,48(sp)
    8000357c:	74a2                	ld	s1,40(sp)
    8000357e:	7902                	ld	s2,32(sp)
    80003580:	69e2                	ld	s3,24(sp)
    80003582:	6a42                	ld	s4,16(sp)
    80003584:	6aa2                	ld	s5,8(sp)
    80003586:	6b02                	ld	s6,0(sp)
    80003588:	6121                	addi	sp,sp,64
    8000358a:	8082                	ret
    8000358c:	8082                	ret

000000008000358e <initlog>:
{
    8000358e:	7179                	addi	sp,sp,-48
    80003590:	f406                	sd	ra,40(sp)
    80003592:	f022                	sd	s0,32(sp)
    80003594:	ec26                	sd	s1,24(sp)
    80003596:	e84a                	sd	s2,16(sp)
    80003598:	e44e                	sd	s3,8(sp)
    8000359a:	1800                	addi	s0,sp,48
    8000359c:	892a                	mv	s2,a0
    8000359e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035a0:	00015497          	auipc	s1,0x15
    800035a4:	5b048493          	addi	s1,s1,1456 # 80018b50 <log>
    800035a8:	00005597          	auipc	a1,0x5
    800035ac:	07858593          	addi	a1,a1,120 # 80008620 <syscalls+0x220>
    800035b0:	8526                	mv	a0,s1
    800035b2:	00003097          	auipc	ra,0x3
    800035b6:	bec080e7          	jalr	-1044(ra) # 8000619e <initlock>
  log.start = sb->logstart;
    800035ba:	0149a583          	lw	a1,20(s3)
    800035be:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035c0:	0109a783          	lw	a5,16(s3)
    800035c4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035c6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035ca:	854a                	mv	a0,s2
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	ea4080e7          	jalr	-348(ra) # 80002470 <bread>
  log.lh.n = lh->n;
    800035d4:	4d30                	lw	a2,88(a0)
    800035d6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035d8:	00c05f63          	blez	a2,800035f6 <initlog+0x68>
    800035dc:	87aa                	mv	a5,a0
    800035de:	00015717          	auipc	a4,0x15
    800035e2:	5a270713          	addi	a4,a4,1442 # 80018b80 <log+0x30>
    800035e6:	060a                	slli	a2,a2,0x2
    800035e8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035ea:	4ff4                	lw	a3,92(a5)
    800035ec:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035ee:	0791                	addi	a5,a5,4
    800035f0:	0711                	addi	a4,a4,4
    800035f2:	fec79ce3          	bne	a5,a2,800035ea <initlog+0x5c>
  brelse(buf);
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	faa080e7          	jalr	-86(ra) # 800025a0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035fe:	4505                	li	a0,1
    80003600:	00000097          	auipc	ra,0x0
    80003604:	eca080e7          	jalr	-310(ra) # 800034ca <install_trans>
  log.lh.n = 0;
    80003608:	00015797          	auipc	a5,0x15
    8000360c:	5607aa23          	sw	zero,1396(a5) # 80018b7c <log+0x2c>
  write_head(); // clear the log
    80003610:	00000097          	auipc	ra,0x0
    80003614:	e50080e7          	jalr	-432(ra) # 80003460 <write_head>
}
    80003618:	70a2                	ld	ra,40(sp)
    8000361a:	7402                	ld	s0,32(sp)
    8000361c:	64e2                	ld	s1,24(sp)
    8000361e:	6942                	ld	s2,16(sp)
    80003620:	69a2                	ld	s3,8(sp)
    80003622:	6145                	addi	sp,sp,48
    80003624:	8082                	ret

0000000080003626 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003626:	1101                	addi	sp,sp,-32
    80003628:	ec06                	sd	ra,24(sp)
    8000362a:	e822                	sd	s0,16(sp)
    8000362c:	e426                	sd	s1,8(sp)
    8000362e:	e04a                	sd	s2,0(sp)
    80003630:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003632:	00015517          	auipc	a0,0x15
    80003636:	51e50513          	addi	a0,a0,1310 # 80018b50 <log>
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	bf4080e7          	jalr	-1036(ra) # 8000622e <acquire>
  while(1){
    if(log.committing){
    80003642:	00015497          	auipc	s1,0x15
    80003646:	50e48493          	addi	s1,s1,1294 # 80018b50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000364a:	4979                	li	s2,30
    8000364c:	a039                	j	8000365a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000364e:	85a6                	mv	a1,s1
    80003650:	8526                	mv	a0,s1
    80003652:	ffffe097          	auipc	ra,0xffffe
    80003656:	04c080e7          	jalr	76(ra) # 8000169e <sleep>
    if(log.committing){
    8000365a:	50dc                	lw	a5,36(s1)
    8000365c:	fbed                	bnez	a5,8000364e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000365e:	5098                	lw	a4,32(s1)
    80003660:	2705                	addiw	a4,a4,1
    80003662:	0027179b          	slliw	a5,a4,0x2
    80003666:	9fb9                	addw	a5,a5,a4
    80003668:	0017979b          	slliw	a5,a5,0x1
    8000366c:	54d4                	lw	a3,44(s1)
    8000366e:	9fb5                	addw	a5,a5,a3
    80003670:	00f95963          	bge	s2,a5,80003682 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003674:	85a6                	mv	a1,s1
    80003676:	8526                	mv	a0,s1
    80003678:	ffffe097          	auipc	ra,0xffffe
    8000367c:	026080e7          	jalr	38(ra) # 8000169e <sleep>
    80003680:	bfe9                	j	8000365a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003682:	00015517          	auipc	a0,0x15
    80003686:	4ce50513          	addi	a0,a0,1230 # 80018b50 <log>
    8000368a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	c56080e7          	jalr	-938(ra) # 800062e2 <release>
      break;
    }
  }
}
    80003694:	60e2                	ld	ra,24(sp)
    80003696:	6442                	ld	s0,16(sp)
    80003698:	64a2                	ld	s1,8(sp)
    8000369a:	6902                	ld	s2,0(sp)
    8000369c:	6105                	addi	sp,sp,32
    8000369e:	8082                	ret

00000000800036a0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036a0:	7139                	addi	sp,sp,-64
    800036a2:	fc06                	sd	ra,56(sp)
    800036a4:	f822                	sd	s0,48(sp)
    800036a6:	f426                	sd	s1,40(sp)
    800036a8:	f04a                	sd	s2,32(sp)
    800036aa:	ec4e                	sd	s3,24(sp)
    800036ac:	e852                	sd	s4,16(sp)
    800036ae:	e456                	sd	s5,8(sp)
    800036b0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036b2:	00015497          	auipc	s1,0x15
    800036b6:	49e48493          	addi	s1,s1,1182 # 80018b50 <log>
    800036ba:	8526                	mv	a0,s1
    800036bc:	00003097          	auipc	ra,0x3
    800036c0:	b72080e7          	jalr	-1166(ra) # 8000622e <acquire>
  log.outstanding -= 1;
    800036c4:	509c                	lw	a5,32(s1)
    800036c6:	37fd                	addiw	a5,a5,-1
    800036c8:	0007891b          	sext.w	s2,a5
    800036cc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036ce:	50dc                	lw	a5,36(s1)
    800036d0:	e7b9                	bnez	a5,8000371e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036d2:	04091e63          	bnez	s2,8000372e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036d6:	00015497          	auipc	s1,0x15
    800036da:	47a48493          	addi	s1,s1,1146 # 80018b50 <log>
    800036de:	4785                	li	a5,1
    800036e0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036e2:	8526                	mv	a0,s1
    800036e4:	00003097          	auipc	ra,0x3
    800036e8:	bfe080e7          	jalr	-1026(ra) # 800062e2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036ec:	54dc                	lw	a5,44(s1)
    800036ee:	06f04763          	bgtz	a5,8000375c <end_op+0xbc>
    acquire(&log.lock);
    800036f2:	00015497          	auipc	s1,0x15
    800036f6:	45e48493          	addi	s1,s1,1118 # 80018b50 <log>
    800036fa:	8526                	mv	a0,s1
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	b32080e7          	jalr	-1230(ra) # 8000622e <acquire>
    log.committing = 0;
    80003704:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003708:	8526                	mv	a0,s1
    8000370a:	ffffe097          	auipc	ra,0xffffe
    8000370e:	ff8080e7          	jalr	-8(ra) # 80001702 <wakeup>
    release(&log.lock);
    80003712:	8526                	mv	a0,s1
    80003714:	00003097          	auipc	ra,0x3
    80003718:	bce080e7          	jalr	-1074(ra) # 800062e2 <release>
}
    8000371c:	a03d                	j	8000374a <end_op+0xaa>
    panic("log.committing");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	f0a50513          	addi	a0,a0,-246 # 80008628 <syscalls+0x228>
    80003726:	00002097          	auipc	ra,0x2
    8000372a:	5d0080e7          	jalr	1488(ra) # 80005cf6 <panic>
    wakeup(&log);
    8000372e:	00015497          	auipc	s1,0x15
    80003732:	42248493          	addi	s1,s1,1058 # 80018b50 <log>
    80003736:	8526                	mv	a0,s1
    80003738:	ffffe097          	auipc	ra,0xffffe
    8000373c:	fca080e7          	jalr	-54(ra) # 80001702 <wakeup>
  release(&log.lock);
    80003740:	8526                	mv	a0,s1
    80003742:	00003097          	auipc	ra,0x3
    80003746:	ba0080e7          	jalr	-1120(ra) # 800062e2 <release>
}
    8000374a:	70e2                	ld	ra,56(sp)
    8000374c:	7442                	ld	s0,48(sp)
    8000374e:	74a2                	ld	s1,40(sp)
    80003750:	7902                	ld	s2,32(sp)
    80003752:	69e2                	ld	s3,24(sp)
    80003754:	6a42                	ld	s4,16(sp)
    80003756:	6aa2                	ld	s5,8(sp)
    80003758:	6121                	addi	sp,sp,64
    8000375a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375c:	00015a97          	auipc	s5,0x15
    80003760:	424a8a93          	addi	s5,s5,1060 # 80018b80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003764:	00015a17          	auipc	s4,0x15
    80003768:	3eca0a13          	addi	s4,s4,1004 # 80018b50 <log>
    8000376c:	018a2583          	lw	a1,24(s4)
    80003770:	012585bb          	addw	a1,a1,s2
    80003774:	2585                	addiw	a1,a1,1
    80003776:	028a2503          	lw	a0,40(s4)
    8000377a:	fffff097          	auipc	ra,0xfffff
    8000377e:	cf6080e7          	jalr	-778(ra) # 80002470 <bread>
    80003782:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003784:	000aa583          	lw	a1,0(s5)
    80003788:	028a2503          	lw	a0,40(s4)
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	ce4080e7          	jalr	-796(ra) # 80002470 <bread>
    80003794:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003796:	40000613          	li	a2,1024
    8000379a:	05850593          	addi	a1,a0,88
    8000379e:	05848513          	addi	a0,s1,88
    800037a2:	ffffd097          	auipc	ra,0xffffd
    800037a6:	a34080e7          	jalr	-1484(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037aa:	8526                	mv	a0,s1
    800037ac:	fffff097          	auipc	ra,0xfffff
    800037b0:	db6080e7          	jalr	-586(ra) # 80002562 <bwrite>
    brelse(from);
    800037b4:	854e                	mv	a0,s3
    800037b6:	fffff097          	auipc	ra,0xfffff
    800037ba:	dea080e7          	jalr	-534(ra) # 800025a0 <brelse>
    brelse(to);
    800037be:	8526                	mv	a0,s1
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	de0080e7          	jalr	-544(ra) # 800025a0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037c8:	2905                	addiw	s2,s2,1
    800037ca:	0a91                	addi	s5,s5,4
    800037cc:	02ca2783          	lw	a5,44(s4)
    800037d0:	f8f94ee3          	blt	s2,a5,8000376c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037d4:	00000097          	auipc	ra,0x0
    800037d8:	c8c080e7          	jalr	-884(ra) # 80003460 <write_head>
    install_trans(0); // Now install writes to home locations
    800037dc:	4501                	li	a0,0
    800037de:	00000097          	auipc	ra,0x0
    800037e2:	cec080e7          	jalr	-788(ra) # 800034ca <install_trans>
    log.lh.n = 0;
    800037e6:	00015797          	auipc	a5,0x15
    800037ea:	3807ab23          	sw	zero,918(a5) # 80018b7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	c72080e7          	jalr	-910(ra) # 80003460 <write_head>
    800037f6:	bdf5                	j	800036f2 <end_op+0x52>

00000000800037f8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037f8:	1101                	addi	sp,sp,-32
    800037fa:	ec06                	sd	ra,24(sp)
    800037fc:	e822                	sd	s0,16(sp)
    800037fe:	e426                	sd	s1,8(sp)
    80003800:	e04a                	sd	s2,0(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003806:	00015917          	auipc	s2,0x15
    8000380a:	34a90913          	addi	s2,s2,842 # 80018b50 <log>
    8000380e:	854a                	mv	a0,s2
    80003810:	00003097          	auipc	ra,0x3
    80003814:	a1e080e7          	jalr	-1506(ra) # 8000622e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003818:	02c92603          	lw	a2,44(s2)
    8000381c:	47f5                	li	a5,29
    8000381e:	06c7c563          	blt	a5,a2,80003888 <log_write+0x90>
    80003822:	00015797          	auipc	a5,0x15
    80003826:	34a7a783          	lw	a5,842(a5) # 80018b6c <log+0x1c>
    8000382a:	37fd                	addiw	a5,a5,-1
    8000382c:	04f65e63          	bge	a2,a5,80003888 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003830:	00015797          	auipc	a5,0x15
    80003834:	3407a783          	lw	a5,832(a5) # 80018b70 <log+0x20>
    80003838:	06f05063          	blez	a5,80003898 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000383c:	4781                	li	a5,0
    8000383e:	06c05563          	blez	a2,800038a8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003842:	44cc                	lw	a1,12(s1)
    80003844:	00015717          	auipc	a4,0x15
    80003848:	33c70713          	addi	a4,a4,828 # 80018b80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000384c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000384e:	4314                	lw	a3,0(a4)
    80003850:	04b68c63          	beq	a3,a1,800038a8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003854:	2785                	addiw	a5,a5,1
    80003856:	0711                	addi	a4,a4,4
    80003858:	fef61be3          	bne	a2,a5,8000384e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000385c:	0621                	addi	a2,a2,8
    8000385e:	060a                	slli	a2,a2,0x2
    80003860:	00015797          	auipc	a5,0x15
    80003864:	2f078793          	addi	a5,a5,752 # 80018b50 <log>
    80003868:	97b2                	add	a5,a5,a2
    8000386a:	44d8                	lw	a4,12(s1)
    8000386c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000386e:	8526                	mv	a0,s1
    80003870:	fffff097          	auipc	ra,0xfffff
    80003874:	dcc080e7          	jalr	-564(ra) # 8000263c <bpin>
    log.lh.n++;
    80003878:	00015717          	auipc	a4,0x15
    8000387c:	2d870713          	addi	a4,a4,728 # 80018b50 <log>
    80003880:	575c                	lw	a5,44(a4)
    80003882:	2785                	addiw	a5,a5,1
    80003884:	d75c                	sw	a5,44(a4)
    80003886:	a82d                	j	800038c0 <log_write+0xc8>
    panic("too big a transaction");
    80003888:	00005517          	auipc	a0,0x5
    8000388c:	db050513          	addi	a0,a0,-592 # 80008638 <syscalls+0x238>
    80003890:	00002097          	auipc	ra,0x2
    80003894:	466080e7          	jalr	1126(ra) # 80005cf6 <panic>
    panic("log_write outside of trans");
    80003898:	00005517          	auipc	a0,0x5
    8000389c:	db850513          	addi	a0,a0,-584 # 80008650 <syscalls+0x250>
    800038a0:	00002097          	auipc	ra,0x2
    800038a4:	456080e7          	jalr	1110(ra) # 80005cf6 <panic>
  log.lh.block[i] = b->blockno;
    800038a8:	00878693          	addi	a3,a5,8
    800038ac:	068a                	slli	a3,a3,0x2
    800038ae:	00015717          	auipc	a4,0x15
    800038b2:	2a270713          	addi	a4,a4,674 # 80018b50 <log>
    800038b6:	9736                	add	a4,a4,a3
    800038b8:	44d4                	lw	a3,12(s1)
    800038ba:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038bc:	faf609e3          	beq	a2,a5,8000386e <log_write+0x76>
  }
  release(&log.lock);
    800038c0:	00015517          	auipc	a0,0x15
    800038c4:	29050513          	addi	a0,a0,656 # 80018b50 <log>
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	a1a080e7          	jalr	-1510(ra) # 800062e2 <release>
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	addi	sp,sp,32
    800038da:	8082                	ret

00000000800038dc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038dc:	1101                	addi	sp,sp,-32
    800038de:	ec06                	sd	ra,24(sp)
    800038e0:	e822                	sd	s0,16(sp)
    800038e2:	e426                	sd	s1,8(sp)
    800038e4:	e04a                	sd	s2,0(sp)
    800038e6:	1000                	addi	s0,sp,32
    800038e8:	84aa                	mv	s1,a0
    800038ea:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038ec:	00005597          	auipc	a1,0x5
    800038f0:	d8458593          	addi	a1,a1,-636 # 80008670 <syscalls+0x270>
    800038f4:	0521                	addi	a0,a0,8
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	8a8080e7          	jalr	-1880(ra) # 8000619e <initlock>
  lk->name = name;
    800038fe:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003902:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003906:	0204a423          	sw	zero,40(s1)
}
    8000390a:	60e2                	ld	ra,24(sp)
    8000390c:	6442                	ld	s0,16(sp)
    8000390e:	64a2                	ld	s1,8(sp)
    80003910:	6902                	ld	s2,0(sp)
    80003912:	6105                	addi	sp,sp,32
    80003914:	8082                	ret

0000000080003916 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003916:	1101                	addi	sp,sp,-32
    80003918:	ec06                	sd	ra,24(sp)
    8000391a:	e822                	sd	s0,16(sp)
    8000391c:	e426                	sd	s1,8(sp)
    8000391e:	e04a                	sd	s2,0(sp)
    80003920:	1000                	addi	s0,sp,32
    80003922:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003924:	00850913          	addi	s2,a0,8
    80003928:	854a                	mv	a0,s2
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	904080e7          	jalr	-1788(ra) # 8000622e <acquire>
  while (lk->locked) {
    80003932:	409c                	lw	a5,0(s1)
    80003934:	cb89                	beqz	a5,80003946 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003936:	85ca                	mv	a1,s2
    80003938:	8526                	mv	a0,s1
    8000393a:	ffffe097          	auipc	ra,0xffffe
    8000393e:	d64080e7          	jalr	-668(ra) # 8000169e <sleep>
  while (lk->locked) {
    80003942:	409c                	lw	a5,0(s1)
    80003944:	fbed                	bnez	a5,80003936 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003946:	4785                	li	a5,1
    80003948:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	5fe080e7          	jalr	1534(ra) # 80000f48 <myproc>
    80003952:	591c                	lw	a5,48(a0)
    80003954:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003956:	854a                	mv	a0,s2
    80003958:	00003097          	auipc	ra,0x3
    8000395c:	98a080e7          	jalr	-1654(ra) # 800062e2 <release>
}
    80003960:	60e2                	ld	ra,24(sp)
    80003962:	6442                	ld	s0,16(sp)
    80003964:	64a2                	ld	s1,8(sp)
    80003966:	6902                	ld	s2,0(sp)
    80003968:	6105                	addi	sp,sp,32
    8000396a:	8082                	ret

000000008000396c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000396c:	1101                	addi	sp,sp,-32
    8000396e:	ec06                	sd	ra,24(sp)
    80003970:	e822                	sd	s0,16(sp)
    80003972:	e426                	sd	s1,8(sp)
    80003974:	e04a                	sd	s2,0(sp)
    80003976:	1000                	addi	s0,sp,32
    80003978:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000397a:	00850913          	addi	s2,a0,8
    8000397e:	854a                	mv	a0,s2
    80003980:	00003097          	auipc	ra,0x3
    80003984:	8ae080e7          	jalr	-1874(ra) # 8000622e <acquire>
  lk->locked = 0;
    80003988:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000398c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003990:	8526                	mv	a0,s1
    80003992:	ffffe097          	auipc	ra,0xffffe
    80003996:	d70080e7          	jalr	-656(ra) # 80001702 <wakeup>
  release(&lk->lk);
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	946080e7          	jalr	-1722(ra) # 800062e2 <release>
}
    800039a4:	60e2                	ld	ra,24(sp)
    800039a6:	6442                	ld	s0,16(sp)
    800039a8:	64a2                	ld	s1,8(sp)
    800039aa:	6902                	ld	s2,0(sp)
    800039ac:	6105                	addi	sp,sp,32
    800039ae:	8082                	ret

00000000800039b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039b0:	7179                	addi	sp,sp,-48
    800039b2:	f406                	sd	ra,40(sp)
    800039b4:	f022                	sd	s0,32(sp)
    800039b6:	ec26                	sd	s1,24(sp)
    800039b8:	e84a                	sd	s2,16(sp)
    800039ba:	e44e                	sd	s3,8(sp)
    800039bc:	1800                	addi	s0,sp,48
    800039be:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039c0:	00850913          	addi	s2,a0,8
    800039c4:	854a                	mv	a0,s2
    800039c6:	00003097          	auipc	ra,0x3
    800039ca:	868080e7          	jalr	-1944(ra) # 8000622e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ce:	409c                	lw	a5,0(s1)
    800039d0:	ef99                	bnez	a5,800039ee <holdingsleep+0x3e>
    800039d2:	4481                	li	s1,0
  release(&lk->lk);
    800039d4:	854a                	mv	a0,s2
    800039d6:	00003097          	auipc	ra,0x3
    800039da:	90c080e7          	jalr	-1780(ra) # 800062e2 <release>
  return r;
}
    800039de:	8526                	mv	a0,s1
    800039e0:	70a2                	ld	ra,40(sp)
    800039e2:	7402                	ld	s0,32(sp)
    800039e4:	64e2                	ld	s1,24(sp)
    800039e6:	6942                	ld	s2,16(sp)
    800039e8:	69a2                	ld	s3,8(sp)
    800039ea:	6145                	addi	sp,sp,48
    800039ec:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ee:	0284a983          	lw	s3,40(s1)
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	556080e7          	jalr	1366(ra) # 80000f48 <myproc>
    800039fa:	5904                	lw	s1,48(a0)
    800039fc:	413484b3          	sub	s1,s1,s3
    80003a00:	0014b493          	seqz	s1,s1
    80003a04:	bfc1                	j	800039d4 <holdingsleep+0x24>

0000000080003a06 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a06:	1141                	addi	sp,sp,-16
    80003a08:	e406                	sd	ra,8(sp)
    80003a0a:	e022                	sd	s0,0(sp)
    80003a0c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a0e:	00005597          	auipc	a1,0x5
    80003a12:	c7258593          	addi	a1,a1,-910 # 80008680 <syscalls+0x280>
    80003a16:	00015517          	auipc	a0,0x15
    80003a1a:	28250513          	addi	a0,a0,642 # 80018c98 <ftable>
    80003a1e:	00002097          	auipc	ra,0x2
    80003a22:	780080e7          	jalr	1920(ra) # 8000619e <initlock>
}
    80003a26:	60a2                	ld	ra,8(sp)
    80003a28:	6402                	ld	s0,0(sp)
    80003a2a:	0141                	addi	sp,sp,16
    80003a2c:	8082                	ret

0000000080003a2e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a2e:	1101                	addi	sp,sp,-32
    80003a30:	ec06                	sd	ra,24(sp)
    80003a32:	e822                	sd	s0,16(sp)
    80003a34:	e426                	sd	s1,8(sp)
    80003a36:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a38:	00015517          	auipc	a0,0x15
    80003a3c:	26050513          	addi	a0,a0,608 # 80018c98 <ftable>
    80003a40:	00002097          	auipc	ra,0x2
    80003a44:	7ee080e7          	jalr	2030(ra) # 8000622e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a48:	00015497          	auipc	s1,0x15
    80003a4c:	26848493          	addi	s1,s1,616 # 80018cb0 <ftable+0x18>
    80003a50:	00016717          	auipc	a4,0x16
    80003a54:	20070713          	addi	a4,a4,512 # 80019c50 <disk>
    if(f->ref == 0){
    80003a58:	40dc                	lw	a5,4(s1)
    80003a5a:	cf99                	beqz	a5,80003a78 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a5c:	02848493          	addi	s1,s1,40
    80003a60:	fee49ce3          	bne	s1,a4,80003a58 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a64:	00015517          	auipc	a0,0x15
    80003a68:	23450513          	addi	a0,a0,564 # 80018c98 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	876080e7          	jalr	-1930(ra) # 800062e2 <release>
  return 0;
    80003a74:	4481                	li	s1,0
    80003a76:	a819                	j	80003a8c <filealloc+0x5e>
      f->ref = 1;
    80003a78:	4785                	li	a5,1
    80003a7a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a7c:	00015517          	auipc	a0,0x15
    80003a80:	21c50513          	addi	a0,a0,540 # 80018c98 <ftable>
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	85e080e7          	jalr	-1954(ra) # 800062e2 <release>
}
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	64a2                	ld	s1,8(sp)
    80003a94:	6105                	addi	sp,sp,32
    80003a96:	8082                	ret

0000000080003a98 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a98:	1101                	addi	sp,sp,-32
    80003a9a:	ec06                	sd	ra,24(sp)
    80003a9c:	e822                	sd	s0,16(sp)
    80003a9e:	e426                	sd	s1,8(sp)
    80003aa0:	1000                	addi	s0,sp,32
    80003aa2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aa4:	00015517          	auipc	a0,0x15
    80003aa8:	1f450513          	addi	a0,a0,500 # 80018c98 <ftable>
    80003aac:	00002097          	auipc	ra,0x2
    80003ab0:	782080e7          	jalr	1922(ra) # 8000622e <acquire>
  if(f->ref < 1)
    80003ab4:	40dc                	lw	a5,4(s1)
    80003ab6:	02f05263          	blez	a5,80003ada <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003aba:	2785                	addiw	a5,a5,1
    80003abc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003abe:	00015517          	auipc	a0,0x15
    80003ac2:	1da50513          	addi	a0,a0,474 # 80018c98 <ftable>
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	81c080e7          	jalr	-2020(ra) # 800062e2 <release>
  return f;
}
    80003ace:	8526                	mv	a0,s1
    80003ad0:	60e2                	ld	ra,24(sp)
    80003ad2:	6442                	ld	s0,16(sp)
    80003ad4:	64a2                	ld	s1,8(sp)
    80003ad6:	6105                	addi	sp,sp,32
    80003ad8:	8082                	ret
    panic("filedup");
    80003ada:	00005517          	auipc	a0,0x5
    80003ade:	bae50513          	addi	a0,a0,-1106 # 80008688 <syscalls+0x288>
    80003ae2:	00002097          	auipc	ra,0x2
    80003ae6:	214080e7          	jalr	532(ra) # 80005cf6 <panic>

0000000080003aea <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aea:	7139                	addi	sp,sp,-64
    80003aec:	fc06                	sd	ra,56(sp)
    80003aee:	f822                	sd	s0,48(sp)
    80003af0:	f426                	sd	s1,40(sp)
    80003af2:	f04a                	sd	s2,32(sp)
    80003af4:	ec4e                	sd	s3,24(sp)
    80003af6:	e852                	sd	s4,16(sp)
    80003af8:	e456                	sd	s5,8(sp)
    80003afa:	0080                	addi	s0,sp,64
    80003afc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003afe:	00015517          	auipc	a0,0x15
    80003b02:	19a50513          	addi	a0,a0,410 # 80018c98 <ftable>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	728080e7          	jalr	1832(ra) # 8000622e <acquire>
  if(f->ref < 1)
    80003b0e:	40dc                	lw	a5,4(s1)
    80003b10:	06f05163          	blez	a5,80003b72 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b14:	37fd                	addiw	a5,a5,-1
    80003b16:	0007871b          	sext.w	a4,a5
    80003b1a:	c0dc                	sw	a5,4(s1)
    80003b1c:	06e04363          	bgtz	a4,80003b82 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b20:	0004a903          	lw	s2,0(s1)
    80003b24:	0094ca83          	lbu	s5,9(s1)
    80003b28:	0104ba03          	ld	s4,16(s1)
    80003b2c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b30:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b34:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b38:	00015517          	auipc	a0,0x15
    80003b3c:	16050513          	addi	a0,a0,352 # 80018c98 <ftable>
    80003b40:	00002097          	auipc	ra,0x2
    80003b44:	7a2080e7          	jalr	1954(ra) # 800062e2 <release>

  if(ff.type == FD_PIPE){
    80003b48:	4785                	li	a5,1
    80003b4a:	04f90d63          	beq	s2,a5,80003ba4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b4e:	3979                	addiw	s2,s2,-2
    80003b50:	4785                	li	a5,1
    80003b52:	0527e063          	bltu	a5,s2,80003b92 <fileclose+0xa8>
    begin_op();
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	ad0080e7          	jalr	-1328(ra) # 80003626 <begin_op>
    iput(ff.ip);
    80003b5e:	854e                	mv	a0,s3
    80003b60:	fffff097          	auipc	ra,0xfffff
    80003b64:	2da080e7          	jalr	730(ra) # 80002e3a <iput>
    end_op();
    80003b68:	00000097          	auipc	ra,0x0
    80003b6c:	b38080e7          	jalr	-1224(ra) # 800036a0 <end_op>
    80003b70:	a00d                	j	80003b92 <fileclose+0xa8>
    panic("fileclose");
    80003b72:	00005517          	auipc	a0,0x5
    80003b76:	b1e50513          	addi	a0,a0,-1250 # 80008690 <syscalls+0x290>
    80003b7a:	00002097          	auipc	ra,0x2
    80003b7e:	17c080e7          	jalr	380(ra) # 80005cf6 <panic>
    release(&ftable.lock);
    80003b82:	00015517          	auipc	a0,0x15
    80003b86:	11650513          	addi	a0,a0,278 # 80018c98 <ftable>
    80003b8a:	00002097          	auipc	ra,0x2
    80003b8e:	758080e7          	jalr	1880(ra) # 800062e2 <release>
  }
}
    80003b92:	70e2                	ld	ra,56(sp)
    80003b94:	7442                	ld	s0,48(sp)
    80003b96:	74a2                	ld	s1,40(sp)
    80003b98:	7902                	ld	s2,32(sp)
    80003b9a:	69e2                	ld	s3,24(sp)
    80003b9c:	6a42                	ld	s4,16(sp)
    80003b9e:	6aa2                	ld	s5,8(sp)
    80003ba0:	6121                	addi	sp,sp,64
    80003ba2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ba4:	85d6                	mv	a1,s5
    80003ba6:	8552                	mv	a0,s4
    80003ba8:	00000097          	auipc	ra,0x0
    80003bac:	348080e7          	jalr	840(ra) # 80003ef0 <pipeclose>
    80003bb0:	b7cd                	j	80003b92 <fileclose+0xa8>

0000000080003bb2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bb2:	715d                	addi	sp,sp,-80
    80003bb4:	e486                	sd	ra,72(sp)
    80003bb6:	e0a2                	sd	s0,64(sp)
    80003bb8:	fc26                	sd	s1,56(sp)
    80003bba:	f84a                	sd	s2,48(sp)
    80003bbc:	f44e                	sd	s3,40(sp)
    80003bbe:	0880                	addi	s0,sp,80
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bc4:	ffffd097          	auipc	ra,0xffffd
    80003bc8:	384080e7          	jalr	900(ra) # 80000f48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bcc:	409c                	lw	a5,0(s1)
    80003bce:	37f9                	addiw	a5,a5,-2
    80003bd0:	4705                	li	a4,1
    80003bd2:	04f76763          	bltu	a4,a5,80003c20 <filestat+0x6e>
    80003bd6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bd8:	6c88                	ld	a0,24(s1)
    80003bda:	fffff097          	auipc	ra,0xfffff
    80003bde:	0a6080e7          	jalr	166(ra) # 80002c80 <ilock>
    stati(f->ip, &st);
    80003be2:	fb840593          	addi	a1,s0,-72
    80003be6:	6c88                	ld	a0,24(s1)
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	322080e7          	jalr	802(ra) # 80002f0a <stati>
    iunlock(f->ip);
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	150080e7          	jalr	336(ra) # 80002d42 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bfa:	46e1                	li	a3,24
    80003bfc:	fb840613          	addi	a2,s0,-72
    80003c00:	85ce                	mv	a1,s3
    80003c02:	05093503          	ld	a0,80(s2)
    80003c06:	ffffd097          	auipc	ra,0xffffd
    80003c0a:	f0c080e7          	jalr	-244(ra) # 80000b12 <copyout>
    80003c0e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c12:	60a6                	ld	ra,72(sp)
    80003c14:	6406                	ld	s0,64(sp)
    80003c16:	74e2                	ld	s1,56(sp)
    80003c18:	7942                	ld	s2,48(sp)
    80003c1a:	79a2                	ld	s3,40(sp)
    80003c1c:	6161                	addi	sp,sp,80
    80003c1e:	8082                	ret
  return -1;
    80003c20:	557d                	li	a0,-1
    80003c22:	bfc5                	j	80003c12 <filestat+0x60>

0000000080003c24 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c24:	7179                	addi	sp,sp,-48
    80003c26:	f406                	sd	ra,40(sp)
    80003c28:	f022                	sd	s0,32(sp)
    80003c2a:	ec26                	sd	s1,24(sp)
    80003c2c:	e84a                	sd	s2,16(sp)
    80003c2e:	e44e                	sd	s3,8(sp)
    80003c30:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c32:	00854783          	lbu	a5,8(a0)
    80003c36:	c3d5                	beqz	a5,80003cda <fileread+0xb6>
    80003c38:	84aa                	mv	s1,a0
    80003c3a:	89ae                	mv	s3,a1
    80003c3c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c3e:	411c                	lw	a5,0(a0)
    80003c40:	4705                	li	a4,1
    80003c42:	04e78963          	beq	a5,a4,80003c94 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c46:	470d                	li	a4,3
    80003c48:	04e78d63          	beq	a5,a4,80003ca2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c4c:	4709                	li	a4,2
    80003c4e:	06e79e63          	bne	a5,a4,80003cca <fileread+0xa6>
    ilock(f->ip);
    80003c52:	6d08                	ld	a0,24(a0)
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	02c080e7          	jalr	44(ra) # 80002c80 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c5c:	874a                	mv	a4,s2
    80003c5e:	5094                	lw	a3,32(s1)
    80003c60:	864e                	mv	a2,s3
    80003c62:	4585                	li	a1,1
    80003c64:	6c88                	ld	a0,24(s1)
    80003c66:	fffff097          	auipc	ra,0xfffff
    80003c6a:	2ce080e7          	jalr	718(ra) # 80002f34 <readi>
    80003c6e:	892a                	mv	s2,a0
    80003c70:	00a05563          	blez	a0,80003c7a <fileread+0x56>
      f->off += r;
    80003c74:	509c                	lw	a5,32(s1)
    80003c76:	9fa9                	addw	a5,a5,a0
    80003c78:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c7a:	6c88                	ld	a0,24(s1)
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	0c6080e7          	jalr	198(ra) # 80002d42 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c84:	854a                	mv	a0,s2
    80003c86:	70a2                	ld	ra,40(sp)
    80003c88:	7402                	ld	s0,32(sp)
    80003c8a:	64e2                	ld	s1,24(sp)
    80003c8c:	6942                	ld	s2,16(sp)
    80003c8e:	69a2                	ld	s3,8(sp)
    80003c90:	6145                	addi	sp,sp,48
    80003c92:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c94:	6908                	ld	a0,16(a0)
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	3c2080e7          	jalr	962(ra) # 80004058 <piperead>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	b7d5                	j	80003c84 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ca2:	02451783          	lh	a5,36(a0)
    80003ca6:	03079693          	slli	a3,a5,0x30
    80003caa:	92c1                	srli	a3,a3,0x30
    80003cac:	4725                	li	a4,9
    80003cae:	02d76863          	bltu	a4,a3,80003cde <fileread+0xba>
    80003cb2:	0792                	slli	a5,a5,0x4
    80003cb4:	00015717          	auipc	a4,0x15
    80003cb8:	f4470713          	addi	a4,a4,-188 # 80018bf8 <devsw>
    80003cbc:	97ba                	add	a5,a5,a4
    80003cbe:	639c                	ld	a5,0(a5)
    80003cc0:	c38d                	beqz	a5,80003ce2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cc2:	4505                	li	a0,1
    80003cc4:	9782                	jalr	a5
    80003cc6:	892a                	mv	s2,a0
    80003cc8:	bf75                	j	80003c84 <fileread+0x60>
    panic("fileread");
    80003cca:	00005517          	auipc	a0,0x5
    80003cce:	9d650513          	addi	a0,a0,-1578 # 800086a0 <syscalls+0x2a0>
    80003cd2:	00002097          	auipc	ra,0x2
    80003cd6:	024080e7          	jalr	36(ra) # 80005cf6 <panic>
    return -1;
    80003cda:	597d                	li	s2,-1
    80003cdc:	b765                	j	80003c84 <fileread+0x60>
      return -1;
    80003cde:	597d                	li	s2,-1
    80003ce0:	b755                	j	80003c84 <fileread+0x60>
    80003ce2:	597d                	li	s2,-1
    80003ce4:	b745                	j	80003c84 <fileread+0x60>

0000000080003ce6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ce6:	00954783          	lbu	a5,9(a0)
    80003cea:	10078e63          	beqz	a5,80003e06 <filewrite+0x120>
{
    80003cee:	715d                	addi	sp,sp,-80
    80003cf0:	e486                	sd	ra,72(sp)
    80003cf2:	e0a2                	sd	s0,64(sp)
    80003cf4:	fc26                	sd	s1,56(sp)
    80003cf6:	f84a                	sd	s2,48(sp)
    80003cf8:	f44e                	sd	s3,40(sp)
    80003cfa:	f052                	sd	s4,32(sp)
    80003cfc:	ec56                	sd	s5,24(sp)
    80003cfe:	e85a                	sd	s6,16(sp)
    80003d00:	e45e                	sd	s7,8(sp)
    80003d02:	e062                	sd	s8,0(sp)
    80003d04:	0880                	addi	s0,sp,80
    80003d06:	892a                	mv	s2,a0
    80003d08:	8b2e                	mv	s6,a1
    80003d0a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d0c:	411c                	lw	a5,0(a0)
    80003d0e:	4705                	li	a4,1
    80003d10:	02e78263          	beq	a5,a4,80003d34 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d14:	470d                	li	a4,3
    80003d16:	02e78563          	beq	a5,a4,80003d40 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1a:	4709                	li	a4,2
    80003d1c:	0ce79d63          	bne	a5,a4,80003df6 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d20:	0ac05b63          	blez	a2,80003dd6 <filewrite+0xf0>
    int i = 0;
    80003d24:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d26:	6b85                	lui	s7,0x1
    80003d28:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d2c:	6c05                	lui	s8,0x1
    80003d2e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d32:	a851                	j	80003dc6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d34:	6908                	ld	a0,16(a0)
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	22a080e7          	jalr	554(ra) # 80003f60 <pipewrite>
    80003d3e:	a045                	j	80003dde <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d40:	02451783          	lh	a5,36(a0)
    80003d44:	03079693          	slli	a3,a5,0x30
    80003d48:	92c1                	srli	a3,a3,0x30
    80003d4a:	4725                	li	a4,9
    80003d4c:	0ad76f63          	bltu	a4,a3,80003e0a <filewrite+0x124>
    80003d50:	0792                	slli	a5,a5,0x4
    80003d52:	00015717          	auipc	a4,0x15
    80003d56:	ea670713          	addi	a4,a4,-346 # 80018bf8 <devsw>
    80003d5a:	97ba                	add	a5,a5,a4
    80003d5c:	679c                	ld	a5,8(a5)
    80003d5e:	cbc5                	beqz	a5,80003e0e <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d60:	4505                	li	a0,1
    80003d62:	9782                	jalr	a5
    80003d64:	a8ad                	j	80003dde <filewrite+0xf8>
      if(n1 > max)
    80003d66:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	8bc080e7          	jalr	-1860(ra) # 80003626 <begin_op>
      ilock(f->ip);
    80003d72:	01893503          	ld	a0,24(s2)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	f0a080e7          	jalr	-246(ra) # 80002c80 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d7e:	8756                	mv	a4,s5
    80003d80:	02092683          	lw	a3,32(s2)
    80003d84:	01698633          	add	a2,s3,s6
    80003d88:	4585                	li	a1,1
    80003d8a:	01893503          	ld	a0,24(s2)
    80003d8e:	fffff097          	auipc	ra,0xfffff
    80003d92:	29e080e7          	jalr	670(ra) # 8000302c <writei>
    80003d96:	84aa                	mv	s1,a0
    80003d98:	00a05763          	blez	a0,80003da6 <filewrite+0xc0>
        f->off += r;
    80003d9c:	02092783          	lw	a5,32(s2)
    80003da0:	9fa9                	addw	a5,a5,a0
    80003da2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003da6:	01893503          	ld	a0,24(s2)
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	f98080e7          	jalr	-104(ra) # 80002d42 <iunlock>
      end_op();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	8ee080e7          	jalr	-1810(ra) # 800036a0 <end_op>

      if(r != n1){
    80003dba:	009a9f63          	bne	s5,s1,80003dd8 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003dbe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dc2:	0149db63          	bge	s3,s4,80003dd8 <filewrite+0xf2>
      int n1 = n - i;
    80003dc6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dca:	0004879b          	sext.w	a5,s1
    80003dce:	f8fbdce3          	bge	s7,a5,80003d66 <filewrite+0x80>
    80003dd2:	84e2                	mv	s1,s8
    80003dd4:	bf49                	j	80003d66 <filewrite+0x80>
    int i = 0;
    80003dd6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dd8:	033a1d63          	bne	s4,s3,80003e12 <filewrite+0x12c>
    80003ddc:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dde:	60a6                	ld	ra,72(sp)
    80003de0:	6406                	ld	s0,64(sp)
    80003de2:	74e2                	ld	s1,56(sp)
    80003de4:	7942                	ld	s2,48(sp)
    80003de6:	79a2                	ld	s3,40(sp)
    80003de8:	7a02                	ld	s4,32(sp)
    80003dea:	6ae2                	ld	s5,24(sp)
    80003dec:	6b42                	ld	s6,16(sp)
    80003dee:	6ba2                	ld	s7,8(sp)
    80003df0:	6c02                	ld	s8,0(sp)
    80003df2:	6161                	addi	sp,sp,80
    80003df4:	8082                	ret
    panic("filewrite");
    80003df6:	00005517          	auipc	a0,0x5
    80003dfa:	8ba50513          	addi	a0,a0,-1862 # 800086b0 <syscalls+0x2b0>
    80003dfe:	00002097          	auipc	ra,0x2
    80003e02:	ef8080e7          	jalr	-264(ra) # 80005cf6 <panic>
    return -1;
    80003e06:	557d                	li	a0,-1
}
    80003e08:	8082                	ret
      return -1;
    80003e0a:	557d                	li	a0,-1
    80003e0c:	bfc9                	j	80003dde <filewrite+0xf8>
    80003e0e:	557d                	li	a0,-1
    80003e10:	b7f9                	j	80003dde <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003e12:	557d                	li	a0,-1
    80003e14:	b7e9                	j	80003dde <filewrite+0xf8>

0000000080003e16 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e16:	7179                	addi	sp,sp,-48
    80003e18:	f406                	sd	ra,40(sp)
    80003e1a:	f022                	sd	s0,32(sp)
    80003e1c:	ec26                	sd	s1,24(sp)
    80003e1e:	e84a                	sd	s2,16(sp)
    80003e20:	e44e                	sd	s3,8(sp)
    80003e22:	e052                	sd	s4,0(sp)
    80003e24:	1800                	addi	s0,sp,48
    80003e26:	84aa                	mv	s1,a0
    80003e28:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e2a:	0005b023          	sd	zero,0(a1)
    80003e2e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	bfc080e7          	jalr	-1028(ra) # 80003a2e <filealloc>
    80003e3a:	e088                	sd	a0,0(s1)
    80003e3c:	c551                	beqz	a0,80003ec8 <pipealloc+0xb2>
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	bf0080e7          	jalr	-1040(ra) # 80003a2e <filealloc>
    80003e46:	00aa3023          	sd	a0,0(s4)
    80003e4a:	c92d                	beqz	a0,80003ebc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e4c:	ffffc097          	auipc	ra,0xffffc
    80003e50:	2ce080e7          	jalr	718(ra) # 8000011a <kalloc>
    80003e54:	892a                	mv	s2,a0
    80003e56:	c125                	beqz	a0,80003eb6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e58:	4985                	li	s3,1
    80003e5a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e5e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e62:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e66:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e6a:	00005597          	auipc	a1,0x5
    80003e6e:	85658593          	addi	a1,a1,-1962 # 800086c0 <syscalls+0x2c0>
    80003e72:	00002097          	auipc	ra,0x2
    80003e76:	32c080e7          	jalr	812(ra) # 8000619e <initlock>
  (*f0)->type = FD_PIPE;
    80003e7a:	609c                	ld	a5,0(s1)
    80003e7c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e80:	609c                	ld	a5,0(s1)
    80003e82:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e86:	609c                	ld	a5,0(s1)
    80003e88:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e8c:	609c                	ld	a5,0(s1)
    80003e8e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e92:	000a3783          	ld	a5,0(s4)
    80003e96:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e9a:	000a3783          	ld	a5,0(s4)
    80003e9e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ea2:	000a3783          	ld	a5,0(s4)
    80003ea6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eaa:	000a3783          	ld	a5,0(s4)
    80003eae:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eb2:	4501                	li	a0,0
    80003eb4:	a025                	j	80003edc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eb6:	6088                	ld	a0,0(s1)
    80003eb8:	e501                	bnez	a0,80003ec0 <pipealloc+0xaa>
    80003eba:	a039                	j	80003ec8 <pipealloc+0xb2>
    80003ebc:	6088                	ld	a0,0(s1)
    80003ebe:	c51d                	beqz	a0,80003eec <pipealloc+0xd6>
    fileclose(*f0);
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	c2a080e7          	jalr	-982(ra) # 80003aea <fileclose>
  if(*f1)
    80003ec8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ecc:	557d                	li	a0,-1
  if(*f1)
    80003ece:	c799                	beqz	a5,80003edc <pipealloc+0xc6>
    fileclose(*f1);
    80003ed0:	853e                	mv	a0,a5
    80003ed2:	00000097          	auipc	ra,0x0
    80003ed6:	c18080e7          	jalr	-1000(ra) # 80003aea <fileclose>
  return -1;
    80003eda:	557d                	li	a0,-1
}
    80003edc:	70a2                	ld	ra,40(sp)
    80003ede:	7402                	ld	s0,32(sp)
    80003ee0:	64e2                	ld	s1,24(sp)
    80003ee2:	6942                	ld	s2,16(sp)
    80003ee4:	69a2                	ld	s3,8(sp)
    80003ee6:	6a02                	ld	s4,0(sp)
    80003ee8:	6145                	addi	sp,sp,48
    80003eea:	8082                	ret
  return -1;
    80003eec:	557d                	li	a0,-1
    80003eee:	b7fd                	j	80003edc <pipealloc+0xc6>

0000000080003ef0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ef0:	1101                	addi	sp,sp,-32
    80003ef2:	ec06                	sd	ra,24(sp)
    80003ef4:	e822                	sd	s0,16(sp)
    80003ef6:	e426                	sd	s1,8(sp)
    80003ef8:	e04a                	sd	s2,0(sp)
    80003efa:	1000                	addi	s0,sp,32
    80003efc:	84aa                	mv	s1,a0
    80003efe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	32e080e7          	jalr	814(ra) # 8000622e <acquire>
  if(writable){
    80003f08:	02090d63          	beqz	s2,80003f42 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f0c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f10:	21848513          	addi	a0,s1,536
    80003f14:	ffffd097          	auipc	ra,0xffffd
    80003f18:	7ee080e7          	jalr	2030(ra) # 80001702 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f1c:	2204b783          	ld	a5,544(s1)
    80003f20:	eb95                	bnez	a5,80003f54 <pipeclose+0x64>
    release(&pi->lock);
    80003f22:	8526                	mv	a0,s1
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	3be080e7          	jalr	958(ra) # 800062e2 <release>
    kfree((char*)pi);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	0ee080e7          	jalr	238(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f36:	60e2                	ld	ra,24(sp)
    80003f38:	6442                	ld	s0,16(sp)
    80003f3a:	64a2                	ld	s1,8(sp)
    80003f3c:	6902                	ld	s2,0(sp)
    80003f3e:	6105                	addi	sp,sp,32
    80003f40:	8082                	ret
    pi->readopen = 0;
    80003f42:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f46:	21c48513          	addi	a0,s1,540
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	7b8080e7          	jalr	1976(ra) # 80001702 <wakeup>
    80003f52:	b7e9                	j	80003f1c <pipeclose+0x2c>
    release(&pi->lock);
    80003f54:	8526                	mv	a0,s1
    80003f56:	00002097          	auipc	ra,0x2
    80003f5a:	38c080e7          	jalr	908(ra) # 800062e2 <release>
}
    80003f5e:	bfe1                	j	80003f36 <pipeclose+0x46>

0000000080003f60 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f60:	711d                	addi	sp,sp,-96
    80003f62:	ec86                	sd	ra,88(sp)
    80003f64:	e8a2                	sd	s0,80(sp)
    80003f66:	e4a6                	sd	s1,72(sp)
    80003f68:	e0ca                	sd	s2,64(sp)
    80003f6a:	fc4e                	sd	s3,56(sp)
    80003f6c:	f852                	sd	s4,48(sp)
    80003f6e:	f456                	sd	s5,40(sp)
    80003f70:	f05a                	sd	s6,32(sp)
    80003f72:	ec5e                	sd	s7,24(sp)
    80003f74:	e862                	sd	s8,16(sp)
    80003f76:	1080                	addi	s0,sp,96
    80003f78:	84aa                	mv	s1,a0
    80003f7a:	8aae                	mv	s5,a1
    80003f7c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f7e:	ffffd097          	auipc	ra,0xffffd
    80003f82:	fca080e7          	jalr	-54(ra) # 80000f48 <myproc>
    80003f86:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	2a4080e7          	jalr	676(ra) # 8000622e <acquire>
  while(i < n){
    80003f92:	0b405663          	blez	s4,8000403e <pipewrite+0xde>
  int i = 0;
    80003f96:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f98:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f9a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f9e:	21c48b93          	addi	s7,s1,540
    80003fa2:	a089                	j	80003fe4 <pipewrite+0x84>
      release(&pi->lock);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	00002097          	auipc	ra,0x2
    80003faa:	33c080e7          	jalr	828(ra) # 800062e2 <release>
      return -1;
    80003fae:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fb0:	854a                	mv	a0,s2
    80003fb2:	60e6                	ld	ra,88(sp)
    80003fb4:	6446                	ld	s0,80(sp)
    80003fb6:	64a6                	ld	s1,72(sp)
    80003fb8:	6906                	ld	s2,64(sp)
    80003fba:	79e2                	ld	s3,56(sp)
    80003fbc:	7a42                	ld	s4,48(sp)
    80003fbe:	7aa2                	ld	s5,40(sp)
    80003fc0:	7b02                	ld	s6,32(sp)
    80003fc2:	6be2                	ld	s7,24(sp)
    80003fc4:	6c42                	ld	s8,16(sp)
    80003fc6:	6125                	addi	sp,sp,96
    80003fc8:	8082                	ret
      wakeup(&pi->nread);
    80003fca:	8562                	mv	a0,s8
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	736080e7          	jalr	1846(ra) # 80001702 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fd4:	85a6                	mv	a1,s1
    80003fd6:	855e                	mv	a0,s7
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	6c6080e7          	jalr	1734(ra) # 8000169e <sleep>
  while(i < n){
    80003fe0:	07495063          	bge	s2,s4,80004040 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fe4:	2204a783          	lw	a5,544(s1)
    80003fe8:	dfd5                	beqz	a5,80003fa4 <pipewrite+0x44>
    80003fea:	854e                	mv	a0,s3
    80003fec:	ffffe097          	auipc	ra,0xffffe
    80003ff0:	95a080e7          	jalr	-1702(ra) # 80001946 <killed>
    80003ff4:	f945                	bnez	a0,80003fa4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ff6:	2184a783          	lw	a5,536(s1)
    80003ffa:	21c4a703          	lw	a4,540(s1)
    80003ffe:	2007879b          	addiw	a5,a5,512
    80004002:	fcf704e3          	beq	a4,a5,80003fca <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004006:	4685                	li	a3,1
    80004008:	01590633          	add	a2,s2,s5
    8000400c:	faf40593          	addi	a1,s0,-81
    80004010:	0509b503          	ld	a0,80(s3)
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	b8a080e7          	jalr	-1142(ra) # 80000b9e <copyin>
    8000401c:	03650263          	beq	a0,s6,80004040 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004020:	21c4a783          	lw	a5,540(s1)
    80004024:	0017871b          	addiw	a4,a5,1
    80004028:	20e4ae23          	sw	a4,540(s1)
    8000402c:	1ff7f793          	andi	a5,a5,511
    80004030:	97a6                	add	a5,a5,s1
    80004032:	faf44703          	lbu	a4,-81(s0)
    80004036:	00e78c23          	sb	a4,24(a5)
      i++;
    8000403a:	2905                	addiw	s2,s2,1
    8000403c:	b755                	j	80003fe0 <pipewrite+0x80>
  int i = 0;
    8000403e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004040:	21848513          	addi	a0,s1,536
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	6be080e7          	jalr	1726(ra) # 80001702 <wakeup>
  release(&pi->lock);
    8000404c:	8526                	mv	a0,s1
    8000404e:	00002097          	auipc	ra,0x2
    80004052:	294080e7          	jalr	660(ra) # 800062e2 <release>
  return i;
    80004056:	bfa9                	j	80003fb0 <pipewrite+0x50>

0000000080004058 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004058:	715d                	addi	sp,sp,-80
    8000405a:	e486                	sd	ra,72(sp)
    8000405c:	e0a2                	sd	s0,64(sp)
    8000405e:	fc26                	sd	s1,56(sp)
    80004060:	f84a                	sd	s2,48(sp)
    80004062:	f44e                	sd	s3,40(sp)
    80004064:	f052                	sd	s4,32(sp)
    80004066:	ec56                	sd	s5,24(sp)
    80004068:	e85a                	sd	s6,16(sp)
    8000406a:	0880                	addi	s0,sp,80
    8000406c:	84aa                	mv	s1,a0
    8000406e:	892e                	mv	s2,a1
    80004070:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	ed6080e7          	jalr	-298(ra) # 80000f48 <myproc>
    8000407a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	1b0080e7          	jalr	432(ra) # 8000622e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004086:	2184a703          	lw	a4,536(s1)
    8000408a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000408e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004092:	02f71763          	bne	a4,a5,800040c0 <piperead+0x68>
    80004096:	2244a783          	lw	a5,548(s1)
    8000409a:	c39d                	beqz	a5,800040c0 <piperead+0x68>
    if(killed(pr)){
    8000409c:	8552                	mv	a0,s4
    8000409e:	ffffe097          	auipc	ra,0xffffe
    800040a2:	8a8080e7          	jalr	-1880(ra) # 80001946 <killed>
    800040a6:	e949                	bnez	a0,80004138 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a8:	85a6                	mv	a1,s1
    800040aa:	854e                	mv	a0,s3
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	5f2080e7          	jalr	1522(ra) # 8000169e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b4:	2184a703          	lw	a4,536(s1)
    800040b8:	21c4a783          	lw	a5,540(s1)
    800040bc:	fcf70de3          	beq	a4,a5,80004096 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040c2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c4:	05505463          	blez	s5,8000410c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040c8:	2184a783          	lw	a5,536(s1)
    800040cc:	21c4a703          	lw	a4,540(s1)
    800040d0:	02f70e63          	beq	a4,a5,8000410c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040d4:	0017871b          	addiw	a4,a5,1
    800040d8:	20e4ac23          	sw	a4,536(s1)
    800040dc:	1ff7f793          	andi	a5,a5,511
    800040e0:	97a6                	add	a5,a5,s1
    800040e2:	0187c783          	lbu	a5,24(a5)
    800040e6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ea:	4685                	li	a3,1
    800040ec:	fbf40613          	addi	a2,s0,-65
    800040f0:	85ca                	mv	a1,s2
    800040f2:	050a3503          	ld	a0,80(s4)
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	a1c080e7          	jalr	-1508(ra) # 80000b12 <copyout>
    800040fe:	01650763          	beq	a0,s6,8000410c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004102:	2985                	addiw	s3,s3,1
    80004104:	0905                	addi	s2,s2,1
    80004106:	fd3a91e3          	bne	s5,s3,800040c8 <piperead+0x70>
    8000410a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000410c:	21c48513          	addi	a0,s1,540
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	5f2080e7          	jalr	1522(ra) # 80001702 <wakeup>
  release(&pi->lock);
    80004118:	8526                	mv	a0,s1
    8000411a:	00002097          	auipc	ra,0x2
    8000411e:	1c8080e7          	jalr	456(ra) # 800062e2 <release>
  return i;
}
    80004122:	854e                	mv	a0,s3
    80004124:	60a6                	ld	ra,72(sp)
    80004126:	6406                	ld	s0,64(sp)
    80004128:	74e2                	ld	s1,56(sp)
    8000412a:	7942                	ld	s2,48(sp)
    8000412c:	79a2                	ld	s3,40(sp)
    8000412e:	7a02                	ld	s4,32(sp)
    80004130:	6ae2                	ld	s5,24(sp)
    80004132:	6b42                	ld	s6,16(sp)
    80004134:	6161                	addi	sp,sp,80
    80004136:	8082                	ret
      release(&pi->lock);
    80004138:	8526                	mv	a0,s1
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	1a8080e7          	jalr	424(ra) # 800062e2 <release>
      return -1;
    80004142:	59fd                	li	s3,-1
    80004144:	bff9                	j	80004122 <piperead+0xca>

0000000080004146 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004146:	1141                	addi	sp,sp,-16
    80004148:	e422                	sd	s0,8(sp)
    8000414a:	0800                	addi	s0,sp,16
    8000414c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000414e:	8905                	andi	a0,a0,1
    80004150:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004152:	8b89                	andi	a5,a5,2
    80004154:	c399                	beqz	a5,8000415a <flags2perm+0x14>
      perm |= PTE_W;
    80004156:	00456513          	ori	a0,a0,4
    return perm;
}
    8000415a:	6422                	ld	s0,8(sp)
    8000415c:	0141                	addi	sp,sp,16
    8000415e:	8082                	ret

0000000080004160 <exec>:

int
exec(char *path, char **argv)
{
    80004160:	df010113          	addi	sp,sp,-528
    80004164:	20113423          	sd	ra,520(sp)
    80004168:	20813023          	sd	s0,512(sp)
    8000416c:	ffa6                	sd	s1,504(sp)
    8000416e:	fbca                	sd	s2,496(sp)
    80004170:	f7ce                	sd	s3,488(sp)
    80004172:	f3d2                	sd	s4,480(sp)
    80004174:	efd6                	sd	s5,472(sp)
    80004176:	ebda                	sd	s6,464(sp)
    80004178:	e7de                	sd	s7,456(sp)
    8000417a:	e3e2                	sd	s8,448(sp)
    8000417c:	ff66                	sd	s9,440(sp)
    8000417e:	fb6a                	sd	s10,432(sp)
    80004180:	f76e                	sd	s11,424(sp)
    80004182:	0c00                	addi	s0,sp,528
    80004184:	892a                	mv	s2,a0
    80004186:	dea43c23          	sd	a0,-520(s0)
    8000418a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	dba080e7          	jalr	-582(ra) # 80000f48 <myproc>
    80004196:	84aa                	mv	s1,a0

  begin_op();
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	48e080e7          	jalr	1166(ra) # 80003626 <begin_op>

  if((ip = namei(path)) == 0){
    800041a0:	854a                	mv	a0,s2
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	284080e7          	jalr	644(ra) # 80003426 <namei>
    800041aa:	c92d                	beqz	a0,8000421c <exec+0xbc>
    800041ac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	ad2080e7          	jalr	-1326(ra) # 80002c80 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b6:	04000713          	li	a4,64
    800041ba:	4681                	li	a3,0
    800041bc:	e5040613          	addi	a2,s0,-432
    800041c0:	4581                	li	a1,0
    800041c2:	8552                	mv	a0,s4
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	d70080e7          	jalr	-656(ra) # 80002f34 <readi>
    800041cc:	04000793          	li	a5,64
    800041d0:	00f51a63          	bne	a0,a5,800041e4 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041d4:	e5042703          	lw	a4,-432(s0)
    800041d8:	464c47b7          	lui	a5,0x464c4
    800041dc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041e0:	04f70463          	beq	a4,a5,80004228 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e4:	8552                	mv	a0,s4
    800041e6:	fffff097          	auipc	ra,0xfffff
    800041ea:	cfc080e7          	jalr	-772(ra) # 80002ee2 <iunlockput>
    end_op();
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	4b2080e7          	jalr	1202(ra) # 800036a0 <end_op>
  }
  return -1;
    800041f6:	557d                	li	a0,-1
}
    800041f8:	20813083          	ld	ra,520(sp)
    800041fc:	20013403          	ld	s0,512(sp)
    80004200:	74fe                	ld	s1,504(sp)
    80004202:	795e                	ld	s2,496(sp)
    80004204:	79be                	ld	s3,488(sp)
    80004206:	7a1e                	ld	s4,480(sp)
    80004208:	6afe                	ld	s5,472(sp)
    8000420a:	6b5e                	ld	s6,464(sp)
    8000420c:	6bbe                	ld	s7,456(sp)
    8000420e:	6c1e                	ld	s8,448(sp)
    80004210:	7cfa                	ld	s9,440(sp)
    80004212:	7d5a                	ld	s10,432(sp)
    80004214:	7dba                	ld	s11,424(sp)
    80004216:	21010113          	addi	sp,sp,528
    8000421a:	8082                	ret
    end_op();
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	484080e7          	jalr	1156(ra) # 800036a0 <end_op>
    return -1;
    80004224:	557d                	li	a0,-1
    80004226:	bfc9                	j	800041f8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004228:	8526                	mv	a0,s1
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	de2080e7          	jalr	-542(ra) # 8000100c <proc_pagetable>
    80004232:	8b2a                	mv	s6,a0
    80004234:	d945                	beqz	a0,800041e4 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004236:	e7042d03          	lw	s10,-400(s0)
    8000423a:	e8845783          	lhu	a5,-376(s0)
    8000423e:	10078463          	beqz	a5,80004346 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004242:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004244:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004246:	6c85                	lui	s9,0x1
    80004248:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004250:	6a85                	lui	s5,0x1
    80004252:	a0b5                	j	800042be <exec+0x15e>
      panic("loadseg: address should exist");
    80004254:	00004517          	auipc	a0,0x4
    80004258:	47450513          	addi	a0,a0,1140 # 800086c8 <syscalls+0x2c8>
    8000425c:	00002097          	auipc	ra,0x2
    80004260:	a9a080e7          	jalr	-1382(ra) # 80005cf6 <panic>
    if(sz - i < PGSIZE)
    80004264:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004266:	8726                	mv	a4,s1
    80004268:	012c06bb          	addw	a3,s8,s2
    8000426c:	4581                	li	a1,0
    8000426e:	8552                	mv	a0,s4
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	cc4080e7          	jalr	-828(ra) # 80002f34 <readi>
    80004278:	2501                	sext.w	a0,a0
    8000427a:	26a49463          	bne	s1,a0,800044e2 <exec+0x382>
  for(i = 0; i < sz; i += PGSIZE){
    8000427e:	012a893b          	addw	s2,s5,s2
    80004282:	03397563          	bgeu	s2,s3,800042ac <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004286:	02091593          	slli	a1,s2,0x20
    8000428a:	9181                	srli	a1,a1,0x20
    8000428c:	95de                	add	a1,a1,s7
    8000428e:	855a                	mv	a0,s6
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	272080e7          	jalr	626(ra) # 80000502 <walkaddr>
    80004298:	862a                	mv	a2,a0
    if(pa == 0)
    8000429a:	dd4d                	beqz	a0,80004254 <exec+0xf4>
    if(sz - i < PGSIZE)
    8000429c:	412984bb          	subw	s1,s3,s2
    800042a0:	0004879b          	sext.w	a5,s1
    800042a4:	fcfcf0e3          	bgeu	s9,a5,80004264 <exec+0x104>
    800042a8:	84d6                	mv	s1,s5
    800042aa:	bf6d                	j	80004264 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042ac:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b0:	2d85                	addiw	s11,s11,1
    800042b2:	038d0d1b          	addiw	s10,s10,56
    800042b6:	e8845783          	lhu	a5,-376(s0)
    800042ba:	08fdd763          	bge	s11,a5,80004348 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042be:	2d01                	sext.w	s10,s10
    800042c0:	03800713          	li	a4,56
    800042c4:	86ea                	mv	a3,s10
    800042c6:	e1840613          	addi	a2,s0,-488
    800042ca:	4581                	li	a1,0
    800042cc:	8552                	mv	a0,s4
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	c66080e7          	jalr	-922(ra) # 80002f34 <readi>
    800042d6:	03800793          	li	a5,56
    800042da:	20f51263          	bne	a0,a5,800044de <exec+0x37e>
    if(ph.type != ELF_PROG_LOAD)
    800042de:	e1842783          	lw	a5,-488(s0)
    800042e2:	4705                	li	a4,1
    800042e4:	fce796e3          	bne	a5,a4,800042b0 <exec+0x150>
    if(ph.memsz < ph.filesz)
    800042e8:	e4043483          	ld	s1,-448(s0)
    800042ec:	e3843783          	ld	a5,-456(s0)
    800042f0:	20f4e463          	bltu	s1,a5,800044f8 <exec+0x398>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042f4:	e2843783          	ld	a5,-472(s0)
    800042f8:	94be                	add	s1,s1,a5
    800042fa:	20f4e263          	bltu	s1,a5,800044fe <exec+0x39e>
    if(ph.vaddr % PGSIZE != 0)
    800042fe:	df043703          	ld	a4,-528(s0)
    80004302:	8ff9                	and	a5,a5,a4
    80004304:	20079063          	bnez	a5,80004504 <exec+0x3a4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004308:	e1c42503          	lw	a0,-484(s0)
    8000430c:	00000097          	auipc	ra,0x0
    80004310:	e3a080e7          	jalr	-454(ra) # 80004146 <flags2perm>
    80004314:	86aa                	mv	a3,a0
    80004316:	8626                	mv	a2,s1
    80004318:	85ca                	mv	a1,s2
    8000431a:	855a                	mv	a0,s6
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	59a080e7          	jalr	1434(ra) # 800008b6 <uvmalloc>
    80004324:	e0a43423          	sd	a0,-504(s0)
    80004328:	1e050163          	beqz	a0,8000450a <exec+0x3aa>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000432c:	e2843b83          	ld	s7,-472(s0)
    80004330:	e2042c03          	lw	s8,-480(s0)
    80004334:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004338:	00098463          	beqz	s3,80004340 <exec+0x1e0>
    8000433c:	4901                	li	s2,0
    8000433e:	b7a1                	j	80004286 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004340:	e0843903          	ld	s2,-504(s0)
    80004344:	b7b5                	j	800042b0 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004346:	4901                	li	s2,0
  iunlockput(ip);
    80004348:	8552                	mv	a0,s4
    8000434a:	fffff097          	auipc	ra,0xfffff
    8000434e:	b98080e7          	jalr	-1128(ra) # 80002ee2 <iunlockput>
  end_op();
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	34e080e7          	jalr	846(ra) # 800036a0 <end_op>
  p = myproc();
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	bee080e7          	jalr	-1042(ra) # 80000f48 <myproc>
    80004362:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004364:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004368:	6985                	lui	s3,0x1
    8000436a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000436c:	99ca                	add	s3,s3,s2
    8000436e:	77fd                	lui	a5,0xfffff
    80004370:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004374:	4691                	li	a3,4
    80004376:	6609                	lui	a2,0x2
    80004378:	964e                	add	a2,a2,s3
    8000437a:	85ce                	mv	a1,s3
    8000437c:	855a                	mv	a0,s6
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	538080e7          	jalr	1336(ra) # 800008b6 <uvmalloc>
    80004386:	892a                	mv	s2,a0
    80004388:	e0a43423          	sd	a0,-504(s0)
    8000438c:	e509                	bnez	a0,80004396 <exec+0x236>
  if(pagetable)
    8000438e:	e1343423          	sd	s3,-504(s0)
    80004392:	4a01                	li	s4,0
    80004394:	a2b9                	j	800044e2 <exec+0x382>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004396:	75f9                	lui	a1,0xffffe
    80004398:	95aa                	add	a1,a1,a0
    8000439a:	855a                	mv	a0,s6
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	744080e7          	jalr	1860(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    800043a4:	7bfd                	lui	s7,0xfffff
    800043a6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043a8:	e0043783          	ld	a5,-512(s0)
    800043ac:	6388                	ld	a0,0(a5)
    800043ae:	c52d                	beqz	a0,80004418 <exec+0x2b8>
    800043b0:	e9040993          	addi	s3,s0,-368
    800043b4:	f9040c13          	addi	s8,s0,-112
    800043b8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	f3a080e7          	jalr	-198(ra) # 800002f4 <strlen>
    800043c2:	0015079b          	addiw	a5,a0,1
    800043c6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ca:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043ce:	15796163          	bltu	s2,s7,80004510 <exec+0x3b0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d2:	e0043d03          	ld	s10,-512(s0)
    800043d6:	000d3a03          	ld	s4,0(s10)
    800043da:	8552                	mv	a0,s4
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f18080e7          	jalr	-232(ra) # 800002f4 <strlen>
    800043e4:	0015069b          	addiw	a3,a0,1
    800043e8:	8652                	mv	a2,s4
    800043ea:	85ca                	mv	a1,s2
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	724080e7          	jalr	1828(ra) # 80000b12 <copyout>
    800043f6:	10054f63          	bltz	a0,80004514 <exec+0x3b4>
    ustack[argc] = sp;
    800043fa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043fe:	0485                	addi	s1,s1,1
    80004400:	008d0793          	addi	a5,s10,8
    80004404:	e0f43023          	sd	a5,-512(s0)
    80004408:	008d3503          	ld	a0,8(s10)
    8000440c:	c909                	beqz	a0,8000441e <exec+0x2be>
    if(argc >= MAXARG)
    8000440e:	09a1                	addi	s3,s3,8
    80004410:	fb8995e3          	bne	s3,s8,800043ba <exec+0x25a>
  ip = 0;
    80004414:	4a01                	li	s4,0
    80004416:	a0f1                	j	800044e2 <exec+0x382>
  sp = sz;
    80004418:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000441c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000441e:	00349793          	slli	a5,s1,0x3
    80004422:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdcfc0>
    80004426:	97a2                	add	a5,a5,s0
    80004428:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000442c:	00148693          	addi	a3,s1,1
    80004430:	068e                	slli	a3,a3,0x3
    80004432:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004436:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000443a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000443e:	f57968e3          	bltu	s2,s7,8000438e <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004442:	e9040613          	addi	a2,s0,-368
    80004446:	85ca                	mv	a1,s2
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	6c8080e7          	jalr	1736(ra) # 80000b12 <copyout>
    80004452:	0c054363          	bltz	a0,80004518 <exec+0x3b8>
  p->trapframe->a1 = sp;
    80004456:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000445a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000445e:	df843783          	ld	a5,-520(s0)
    80004462:	0007c703          	lbu	a4,0(a5)
    80004466:	cf11                	beqz	a4,80004482 <exec+0x322>
    80004468:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000446a:	02f00693          	li	a3,47
    8000446e:	a039                	j	8000447c <exec+0x31c>
      last = s+1;
    80004470:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004474:	0785                	addi	a5,a5,1
    80004476:	fff7c703          	lbu	a4,-1(a5)
    8000447a:	c701                	beqz	a4,80004482 <exec+0x322>
    if(*s == '/')
    8000447c:	fed71ce3          	bne	a4,a3,80004474 <exec+0x314>
    80004480:	bfc5                	j	80004470 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004482:	4641                	li	a2,16
    80004484:	df843583          	ld	a1,-520(s0)
    80004488:	160a8513          	addi	a0,s5,352
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	e36080e7          	jalr	-458(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004494:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004498:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000449c:	e0843783          	ld	a5,-504(s0)
    800044a0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044a4:	058ab783          	ld	a5,88(s5)
    800044a8:	e6843703          	ld	a4,-408(s0)
    800044ac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ae:	058ab783          	ld	a5,88(s5)
    800044b2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044b6:	85e6                	mv	a1,s9
    800044b8:	ffffd097          	auipc	ra,0xffffd
    800044bc:	c4a080e7          	jalr	-950(ra) # 80001102 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    800044c0:	030aa703          	lw	a4,48(s5)
    800044c4:	4785                	li	a5,1
    800044c6:	00f70563          	beq	a4,a5,800044d0 <exec+0x370>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ca:	0004851b          	sext.w	a0,s1
    800044ce:	b32d                	j	800041f8 <exec+0x98>
  if(p->pid==1) vmprint(p->pagetable);
    800044d0:	050ab503          	ld	a0,80(s5)
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	8ce080e7          	jalr	-1842(ra) # 80000da2 <vmprint>
    800044dc:	b7fd                	j	800044ca <exec+0x36a>
    800044de:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044e2:	e0843583          	ld	a1,-504(s0)
    800044e6:	855a                	mv	a0,s6
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	c1a080e7          	jalr	-998(ra) # 80001102 <proc_freepagetable>
  return -1;
    800044f0:	557d                	li	a0,-1
  if(ip){
    800044f2:	d00a03e3          	beqz	s4,800041f8 <exec+0x98>
    800044f6:	b1fd                	j	800041e4 <exec+0x84>
    800044f8:	e1243423          	sd	s2,-504(s0)
    800044fc:	b7dd                	j	800044e2 <exec+0x382>
    800044fe:	e1243423          	sd	s2,-504(s0)
    80004502:	b7c5                	j	800044e2 <exec+0x382>
    80004504:	e1243423          	sd	s2,-504(s0)
    80004508:	bfe9                	j	800044e2 <exec+0x382>
    8000450a:	e1243423          	sd	s2,-504(s0)
    8000450e:	bfd1                	j	800044e2 <exec+0x382>
  ip = 0;
    80004510:	4a01                	li	s4,0
    80004512:	bfc1                	j	800044e2 <exec+0x382>
    80004514:	4a01                	li	s4,0
  if(pagetable)
    80004516:	b7f1                	j	800044e2 <exec+0x382>
  sz = sz1;
    80004518:	e0843983          	ld	s3,-504(s0)
    8000451c:	bd8d                	j	8000438e <exec+0x22e>

000000008000451e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000451e:	7179                	addi	sp,sp,-48
    80004520:	f406                	sd	ra,40(sp)
    80004522:	f022                	sd	s0,32(sp)
    80004524:	ec26                	sd	s1,24(sp)
    80004526:	e84a                	sd	s2,16(sp)
    80004528:	1800                	addi	s0,sp,48
    8000452a:	892e                	mv	s2,a1
    8000452c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000452e:	fdc40593          	addi	a1,s0,-36
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	bde080e7          	jalr	-1058(ra) # 80002110 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000453a:	fdc42703          	lw	a4,-36(s0)
    8000453e:	47bd                	li	a5,15
    80004540:	02e7eb63          	bltu	a5,a4,80004576 <argfd+0x58>
    80004544:	ffffd097          	auipc	ra,0xffffd
    80004548:	a04080e7          	jalr	-1532(ra) # 80000f48 <myproc>
    8000454c:	fdc42703          	lw	a4,-36(s0)
    80004550:	01a70793          	addi	a5,a4,26
    80004554:	078e                	slli	a5,a5,0x3
    80004556:	953e                	add	a0,a0,a5
    80004558:	651c                	ld	a5,8(a0)
    8000455a:	c385                	beqz	a5,8000457a <argfd+0x5c>
    return -1;
  if(pfd)
    8000455c:	00090463          	beqz	s2,80004564 <argfd+0x46>
    *pfd = fd;
    80004560:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004564:	4501                	li	a0,0
  if(pf)
    80004566:	c091                	beqz	s1,8000456a <argfd+0x4c>
    *pf = f;
    80004568:	e09c                	sd	a5,0(s1)
}
    8000456a:	70a2                	ld	ra,40(sp)
    8000456c:	7402                	ld	s0,32(sp)
    8000456e:	64e2                	ld	s1,24(sp)
    80004570:	6942                	ld	s2,16(sp)
    80004572:	6145                	addi	sp,sp,48
    80004574:	8082                	ret
    return -1;
    80004576:	557d                	li	a0,-1
    80004578:	bfcd                	j	8000456a <argfd+0x4c>
    8000457a:	557d                	li	a0,-1
    8000457c:	b7fd                	j	8000456a <argfd+0x4c>

000000008000457e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457e:	1101                	addi	sp,sp,-32
    80004580:	ec06                	sd	ra,24(sp)
    80004582:	e822                	sd	s0,16(sp)
    80004584:	e426                	sd	s1,8(sp)
    80004586:	1000                	addi	s0,sp,32
    80004588:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000458a:	ffffd097          	auipc	ra,0xffffd
    8000458e:	9be080e7          	jalr	-1602(ra) # 80000f48 <myproc>
    80004592:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004594:	0d850793          	addi	a5,a0,216
    80004598:	4501                	li	a0,0
    8000459a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000459c:	6398                	ld	a4,0(a5)
    8000459e:	cb19                	beqz	a4,800045b4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045a0:	2505                	addiw	a0,a0,1
    800045a2:	07a1                	addi	a5,a5,8
    800045a4:	fed51ce3          	bne	a0,a3,8000459c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a8:	557d                	li	a0,-1
}
    800045aa:	60e2                	ld	ra,24(sp)
    800045ac:	6442                	ld	s0,16(sp)
    800045ae:	64a2                	ld	s1,8(sp)
    800045b0:	6105                	addi	sp,sp,32
    800045b2:	8082                	ret
      p->ofile[fd] = f;
    800045b4:	01a50793          	addi	a5,a0,26
    800045b8:	078e                	slli	a5,a5,0x3
    800045ba:	963e                	add	a2,a2,a5
    800045bc:	e604                	sd	s1,8(a2)
      return fd;
    800045be:	b7f5                	j	800045aa <fdalloc+0x2c>

00000000800045c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045c0:	715d                	addi	sp,sp,-80
    800045c2:	e486                	sd	ra,72(sp)
    800045c4:	e0a2                	sd	s0,64(sp)
    800045c6:	fc26                	sd	s1,56(sp)
    800045c8:	f84a                	sd	s2,48(sp)
    800045ca:	f44e                	sd	s3,40(sp)
    800045cc:	f052                	sd	s4,32(sp)
    800045ce:	ec56                	sd	s5,24(sp)
    800045d0:	e85a                	sd	s6,16(sp)
    800045d2:	0880                	addi	s0,sp,80
    800045d4:	8b2e                	mv	s6,a1
    800045d6:	89b2                	mv	s3,a2
    800045d8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045da:	fb040593          	addi	a1,s0,-80
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	e66080e7          	jalr	-410(ra) # 80003444 <nameiparent>
    800045e6:	84aa                	mv	s1,a0
    800045e8:	14050b63          	beqz	a0,8000473e <create+0x17e>
    return 0;

  ilock(dp);
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	694080e7          	jalr	1684(ra) # 80002c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045f4:	4601                	li	a2,0
    800045f6:	fb040593          	addi	a1,s0,-80
    800045fa:	8526                	mv	a0,s1
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	b68080e7          	jalr	-1176(ra) # 80003164 <dirlookup>
    80004604:	8aaa                	mv	s5,a0
    80004606:	c921                	beqz	a0,80004656 <create+0x96>
    iunlockput(dp);
    80004608:	8526                	mv	a0,s1
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	8d8080e7          	jalr	-1832(ra) # 80002ee2 <iunlockput>
    ilock(ip);
    80004612:	8556                	mv	a0,s5
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	66c080e7          	jalr	1644(ra) # 80002c80 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000461c:	4789                	li	a5,2
    8000461e:	02fb1563          	bne	s6,a5,80004648 <create+0x88>
    80004622:	044ad783          	lhu	a5,68(s5)
    80004626:	37f9                	addiw	a5,a5,-2
    80004628:	17c2                	slli	a5,a5,0x30
    8000462a:	93c1                	srli	a5,a5,0x30
    8000462c:	4705                	li	a4,1
    8000462e:	00f76d63          	bltu	a4,a5,80004648 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004632:	8556                	mv	a0,s5
    80004634:	60a6                	ld	ra,72(sp)
    80004636:	6406                	ld	s0,64(sp)
    80004638:	74e2                	ld	s1,56(sp)
    8000463a:	7942                	ld	s2,48(sp)
    8000463c:	79a2                	ld	s3,40(sp)
    8000463e:	7a02                	ld	s4,32(sp)
    80004640:	6ae2                	ld	s5,24(sp)
    80004642:	6b42                	ld	s6,16(sp)
    80004644:	6161                	addi	sp,sp,80
    80004646:	8082                	ret
    iunlockput(ip);
    80004648:	8556                	mv	a0,s5
    8000464a:	fffff097          	auipc	ra,0xfffff
    8000464e:	898080e7          	jalr	-1896(ra) # 80002ee2 <iunlockput>
    return 0;
    80004652:	4a81                	li	s5,0
    80004654:	bff9                	j	80004632 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004656:	85da                	mv	a1,s6
    80004658:	4088                	lw	a0,0(s1)
    8000465a:	ffffe097          	auipc	ra,0xffffe
    8000465e:	48e080e7          	jalr	1166(ra) # 80002ae8 <ialloc>
    80004662:	8a2a                	mv	s4,a0
    80004664:	c529                	beqz	a0,800046ae <create+0xee>
  ilock(ip);
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	61a080e7          	jalr	1562(ra) # 80002c80 <ilock>
  ip->major = major;
    8000466e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004672:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004676:	4905                	li	s2,1
    80004678:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000467c:	8552                	mv	a0,s4
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	536080e7          	jalr	1334(ra) # 80002bb4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004686:	032b0b63          	beq	s6,s2,800046bc <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000468a:	004a2603          	lw	a2,4(s4)
    8000468e:	fb040593          	addi	a1,s0,-80
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	ce0080e7          	jalr	-800(ra) # 80003374 <dirlink>
    8000469c:	06054f63          	bltz	a0,8000471a <create+0x15a>
  iunlockput(dp);
    800046a0:	8526                	mv	a0,s1
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	840080e7          	jalr	-1984(ra) # 80002ee2 <iunlockput>
  return ip;
    800046aa:	8ad2                	mv	s5,s4
    800046ac:	b759                	j	80004632 <create+0x72>
    iunlockput(dp);
    800046ae:	8526                	mv	a0,s1
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	832080e7          	jalr	-1998(ra) # 80002ee2 <iunlockput>
    return 0;
    800046b8:	8ad2                	mv	s5,s4
    800046ba:	bfa5                	j	80004632 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046bc:	004a2603          	lw	a2,4(s4)
    800046c0:	00004597          	auipc	a1,0x4
    800046c4:	02858593          	addi	a1,a1,40 # 800086e8 <syscalls+0x2e8>
    800046c8:	8552                	mv	a0,s4
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	caa080e7          	jalr	-854(ra) # 80003374 <dirlink>
    800046d2:	04054463          	bltz	a0,8000471a <create+0x15a>
    800046d6:	40d0                	lw	a2,4(s1)
    800046d8:	00004597          	auipc	a1,0x4
    800046dc:	01858593          	addi	a1,a1,24 # 800086f0 <syscalls+0x2f0>
    800046e0:	8552                	mv	a0,s4
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	c92080e7          	jalr	-878(ra) # 80003374 <dirlink>
    800046ea:	02054863          	bltz	a0,8000471a <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ee:	004a2603          	lw	a2,4(s4)
    800046f2:	fb040593          	addi	a1,s0,-80
    800046f6:	8526                	mv	a0,s1
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	c7c080e7          	jalr	-900(ra) # 80003374 <dirlink>
    80004700:	00054d63          	bltz	a0,8000471a <create+0x15a>
    dp->nlink++;  // for ".."
    80004704:	04a4d783          	lhu	a5,74(s1)
    80004708:	2785                	addiw	a5,a5,1
    8000470a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000470e:	8526                	mv	a0,s1
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	4a4080e7          	jalr	1188(ra) # 80002bb4 <iupdate>
    80004718:	b761                	j	800046a0 <create+0xe0>
  ip->nlink = 0;
    8000471a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000471e:	8552                	mv	a0,s4
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	494080e7          	jalr	1172(ra) # 80002bb4 <iupdate>
  iunlockput(ip);
    80004728:	8552                	mv	a0,s4
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	7b8080e7          	jalr	1976(ra) # 80002ee2 <iunlockput>
  iunlockput(dp);
    80004732:	8526                	mv	a0,s1
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	7ae080e7          	jalr	1966(ra) # 80002ee2 <iunlockput>
  return 0;
    8000473c:	bddd                	j	80004632 <create+0x72>
    return 0;
    8000473e:	8aaa                	mv	s5,a0
    80004740:	bdcd                	j	80004632 <create+0x72>

0000000080004742 <sys_dup>:
{
    80004742:	7179                	addi	sp,sp,-48
    80004744:	f406                	sd	ra,40(sp)
    80004746:	f022                	sd	s0,32(sp)
    80004748:	ec26                	sd	s1,24(sp)
    8000474a:	e84a                	sd	s2,16(sp)
    8000474c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000474e:	fd840613          	addi	a2,s0,-40
    80004752:	4581                	li	a1,0
    80004754:	4501                	li	a0,0
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	dc8080e7          	jalr	-568(ra) # 8000451e <argfd>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004760:	02054363          	bltz	a0,80004786 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004764:	fd843903          	ld	s2,-40(s0)
    80004768:	854a                	mv	a0,s2
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	e14080e7          	jalr	-492(ra) # 8000457e <fdalloc>
    80004772:	84aa                	mv	s1,a0
    return -1;
    80004774:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004776:	00054863          	bltz	a0,80004786 <sys_dup+0x44>
  filedup(f);
    8000477a:	854a                	mv	a0,s2
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	31c080e7          	jalr	796(ra) # 80003a98 <filedup>
  return fd;
    80004784:	87a6                	mv	a5,s1
}
    80004786:	853e                	mv	a0,a5
    80004788:	70a2                	ld	ra,40(sp)
    8000478a:	7402                	ld	s0,32(sp)
    8000478c:	64e2                	ld	s1,24(sp)
    8000478e:	6942                	ld	s2,16(sp)
    80004790:	6145                	addi	sp,sp,48
    80004792:	8082                	ret

0000000080004794 <sys_read>:
{
    80004794:	7179                	addi	sp,sp,-48
    80004796:	f406                	sd	ra,40(sp)
    80004798:	f022                	sd	s0,32(sp)
    8000479a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000479c:	fd840593          	addi	a1,s0,-40
    800047a0:	4505                	li	a0,1
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	98e080e7          	jalr	-1650(ra) # 80002130 <argaddr>
  argint(2, &n);
    800047aa:	fe440593          	addi	a1,s0,-28
    800047ae:	4509                	li	a0,2
    800047b0:	ffffe097          	auipc	ra,0xffffe
    800047b4:	960080e7          	jalr	-1696(ra) # 80002110 <argint>
  if(argfd(0, 0, &f) < 0)
    800047b8:	fe840613          	addi	a2,s0,-24
    800047bc:	4581                	li	a1,0
    800047be:	4501                	li	a0,0
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	d5e080e7          	jalr	-674(ra) # 8000451e <argfd>
    800047c8:	87aa                	mv	a5,a0
    return -1;
    800047ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047cc:	0007cc63          	bltz	a5,800047e4 <sys_read+0x50>
  return fileread(f, p, n);
    800047d0:	fe442603          	lw	a2,-28(s0)
    800047d4:	fd843583          	ld	a1,-40(s0)
    800047d8:	fe843503          	ld	a0,-24(s0)
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	448080e7          	jalr	1096(ra) # 80003c24 <fileread>
}
    800047e4:	70a2                	ld	ra,40(sp)
    800047e6:	7402                	ld	s0,32(sp)
    800047e8:	6145                	addi	sp,sp,48
    800047ea:	8082                	ret

00000000800047ec <sys_write>:
{
    800047ec:	7179                	addi	sp,sp,-48
    800047ee:	f406                	sd	ra,40(sp)
    800047f0:	f022                	sd	s0,32(sp)
    800047f2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047f4:	fd840593          	addi	a1,s0,-40
    800047f8:	4505                	li	a0,1
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	936080e7          	jalr	-1738(ra) # 80002130 <argaddr>
  argint(2, &n);
    80004802:	fe440593          	addi	a1,s0,-28
    80004806:	4509                	li	a0,2
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	908080e7          	jalr	-1784(ra) # 80002110 <argint>
  if(argfd(0, 0, &f) < 0)
    80004810:	fe840613          	addi	a2,s0,-24
    80004814:	4581                	li	a1,0
    80004816:	4501                	li	a0,0
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	d06080e7          	jalr	-762(ra) # 8000451e <argfd>
    80004820:	87aa                	mv	a5,a0
    return -1;
    80004822:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004824:	0007cc63          	bltz	a5,8000483c <sys_write+0x50>
  return filewrite(f, p, n);
    80004828:	fe442603          	lw	a2,-28(s0)
    8000482c:	fd843583          	ld	a1,-40(s0)
    80004830:	fe843503          	ld	a0,-24(s0)
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	4b2080e7          	jalr	1202(ra) # 80003ce6 <filewrite>
}
    8000483c:	70a2                	ld	ra,40(sp)
    8000483e:	7402                	ld	s0,32(sp)
    80004840:	6145                	addi	sp,sp,48
    80004842:	8082                	ret

0000000080004844 <sys_close>:
{
    80004844:	1101                	addi	sp,sp,-32
    80004846:	ec06                	sd	ra,24(sp)
    80004848:	e822                	sd	s0,16(sp)
    8000484a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000484c:	fe040613          	addi	a2,s0,-32
    80004850:	fec40593          	addi	a1,s0,-20
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	cc8080e7          	jalr	-824(ra) # 8000451e <argfd>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004860:	02054463          	bltz	a0,80004888 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004864:	ffffc097          	auipc	ra,0xffffc
    80004868:	6e4080e7          	jalr	1764(ra) # 80000f48 <myproc>
    8000486c:	fec42783          	lw	a5,-20(s0)
    80004870:	07e9                	addi	a5,a5,26
    80004872:	078e                	slli	a5,a5,0x3
    80004874:	953e                	add	a0,a0,a5
    80004876:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000487a:	fe043503          	ld	a0,-32(s0)
    8000487e:	fffff097          	auipc	ra,0xfffff
    80004882:	26c080e7          	jalr	620(ra) # 80003aea <fileclose>
  return 0;
    80004886:	4781                	li	a5,0
}
    80004888:	853e                	mv	a0,a5
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret

0000000080004892 <sys_fstat>:
{
    80004892:	1101                	addi	sp,sp,-32
    80004894:	ec06                	sd	ra,24(sp)
    80004896:	e822                	sd	s0,16(sp)
    80004898:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000489a:	fe040593          	addi	a1,s0,-32
    8000489e:	4505                	li	a0,1
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	890080e7          	jalr	-1904(ra) # 80002130 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048a8:	fe840613          	addi	a2,s0,-24
    800048ac:	4581                	li	a1,0
    800048ae:	4501                	li	a0,0
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	c6e080e7          	jalr	-914(ra) # 8000451e <argfd>
    800048b8:	87aa                	mv	a5,a0
    return -1;
    800048ba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048bc:	0007ca63          	bltz	a5,800048d0 <sys_fstat+0x3e>
  return filestat(f, st);
    800048c0:	fe043583          	ld	a1,-32(s0)
    800048c4:	fe843503          	ld	a0,-24(s0)
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	2ea080e7          	jalr	746(ra) # 80003bb2 <filestat>
}
    800048d0:	60e2                	ld	ra,24(sp)
    800048d2:	6442                	ld	s0,16(sp)
    800048d4:	6105                	addi	sp,sp,32
    800048d6:	8082                	ret

00000000800048d8 <sys_link>:
{
    800048d8:	7169                	addi	sp,sp,-304
    800048da:	f606                	sd	ra,296(sp)
    800048dc:	f222                	sd	s0,288(sp)
    800048de:	ee26                	sd	s1,280(sp)
    800048e0:	ea4a                	sd	s2,272(sp)
    800048e2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e4:	08000613          	li	a2,128
    800048e8:	ed040593          	addi	a1,s0,-304
    800048ec:	4501                	li	a0,0
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	862080e7          	jalr	-1950(ra) # 80002150 <argstr>
    return -1;
    800048f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f8:	10054e63          	bltz	a0,80004a14 <sys_link+0x13c>
    800048fc:	08000613          	li	a2,128
    80004900:	f5040593          	addi	a1,s0,-176
    80004904:	4505                	li	a0,1
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	84a080e7          	jalr	-1974(ra) # 80002150 <argstr>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004910:	10054263          	bltz	a0,80004a14 <sys_link+0x13c>
  begin_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	d12080e7          	jalr	-750(ra) # 80003626 <begin_op>
  if((ip = namei(old)) == 0){
    8000491c:	ed040513          	addi	a0,s0,-304
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	b06080e7          	jalr	-1274(ra) # 80003426 <namei>
    80004928:	84aa                	mv	s1,a0
    8000492a:	c551                	beqz	a0,800049b6 <sys_link+0xde>
  ilock(ip);
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	354080e7          	jalr	852(ra) # 80002c80 <ilock>
  if(ip->type == T_DIR){
    80004934:	04449703          	lh	a4,68(s1)
    80004938:	4785                	li	a5,1
    8000493a:	08f70463          	beq	a4,a5,800049c2 <sys_link+0xea>
  ip->nlink++;
    8000493e:	04a4d783          	lhu	a5,74(s1)
    80004942:	2785                	addiw	a5,a5,1
    80004944:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004948:	8526                	mv	a0,s1
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	26a080e7          	jalr	618(ra) # 80002bb4 <iupdate>
  iunlock(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	3ee080e7          	jalr	1006(ra) # 80002d42 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000495c:	fd040593          	addi	a1,s0,-48
    80004960:	f5040513          	addi	a0,s0,-176
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	ae0080e7          	jalr	-1312(ra) # 80003444 <nameiparent>
    8000496c:	892a                	mv	s2,a0
    8000496e:	c935                	beqz	a0,800049e2 <sys_link+0x10a>
  ilock(dp);
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	310080e7          	jalr	784(ra) # 80002c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004978:	00092703          	lw	a4,0(s2)
    8000497c:	409c                	lw	a5,0(s1)
    8000497e:	04f71d63          	bne	a4,a5,800049d8 <sys_link+0x100>
    80004982:	40d0                	lw	a2,4(s1)
    80004984:	fd040593          	addi	a1,s0,-48
    80004988:	854a                	mv	a0,s2
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	9ea080e7          	jalr	-1558(ra) # 80003374 <dirlink>
    80004992:	04054363          	bltz	a0,800049d8 <sys_link+0x100>
  iunlockput(dp);
    80004996:	854a                	mv	a0,s2
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	54a080e7          	jalr	1354(ra) # 80002ee2 <iunlockput>
  iput(ip);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	498080e7          	jalr	1176(ra) # 80002e3a <iput>
  end_op();
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	cf6080e7          	jalr	-778(ra) # 800036a0 <end_op>
  return 0;
    800049b2:	4781                	li	a5,0
    800049b4:	a085                	j	80004a14 <sys_link+0x13c>
    end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	cea080e7          	jalr	-790(ra) # 800036a0 <end_op>
    return -1;
    800049be:	57fd                	li	a5,-1
    800049c0:	a891                	j	80004a14 <sys_link+0x13c>
    iunlockput(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	51e080e7          	jalr	1310(ra) # 80002ee2 <iunlockput>
    end_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	cd4080e7          	jalr	-812(ra) # 800036a0 <end_op>
    return -1;
    800049d4:	57fd                	li	a5,-1
    800049d6:	a83d                	j	80004a14 <sys_link+0x13c>
    iunlockput(dp);
    800049d8:	854a                	mv	a0,s2
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	508080e7          	jalr	1288(ra) # 80002ee2 <iunlockput>
  ilock(ip);
    800049e2:	8526                	mv	a0,s1
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	29c080e7          	jalr	668(ra) # 80002c80 <ilock>
  ip->nlink--;
    800049ec:	04a4d783          	lhu	a5,74(s1)
    800049f0:	37fd                	addiw	a5,a5,-1
    800049f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049f6:	8526                	mv	a0,s1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	1bc080e7          	jalr	444(ra) # 80002bb4 <iupdate>
  iunlockput(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	4e0080e7          	jalr	1248(ra) # 80002ee2 <iunlockput>
  end_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	c96080e7          	jalr	-874(ra) # 800036a0 <end_op>
  return -1;
    80004a12:	57fd                	li	a5,-1
}
    80004a14:	853e                	mv	a0,a5
    80004a16:	70b2                	ld	ra,296(sp)
    80004a18:	7412                	ld	s0,288(sp)
    80004a1a:	64f2                	ld	s1,280(sp)
    80004a1c:	6952                	ld	s2,272(sp)
    80004a1e:	6155                	addi	sp,sp,304
    80004a20:	8082                	ret

0000000080004a22 <sys_unlink>:
{
    80004a22:	7151                	addi	sp,sp,-240
    80004a24:	f586                	sd	ra,232(sp)
    80004a26:	f1a2                	sd	s0,224(sp)
    80004a28:	eda6                	sd	s1,216(sp)
    80004a2a:	e9ca                	sd	s2,208(sp)
    80004a2c:	e5ce                	sd	s3,200(sp)
    80004a2e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a30:	08000613          	li	a2,128
    80004a34:	f3040593          	addi	a1,s0,-208
    80004a38:	4501                	li	a0,0
    80004a3a:	ffffd097          	auipc	ra,0xffffd
    80004a3e:	716080e7          	jalr	1814(ra) # 80002150 <argstr>
    80004a42:	18054163          	bltz	a0,80004bc4 <sys_unlink+0x1a2>
  begin_op();
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	be0080e7          	jalr	-1056(ra) # 80003626 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a4e:	fb040593          	addi	a1,s0,-80
    80004a52:	f3040513          	addi	a0,s0,-208
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	9ee080e7          	jalr	-1554(ra) # 80003444 <nameiparent>
    80004a5e:	84aa                	mv	s1,a0
    80004a60:	c979                	beqz	a0,80004b36 <sys_unlink+0x114>
  ilock(dp);
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	21e080e7          	jalr	542(ra) # 80002c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a6a:	00004597          	auipc	a1,0x4
    80004a6e:	c7e58593          	addi	a1,a1,-898 # 800086e8 <syscalls+0x2e8>
    80004a72:	fb040513          	addi	a0,s0,-80
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	6d4080e7          	jalr	1748(ra) # 8000314a <namecmp>
    80004a7e:	14050a63          	beqz	a0,80004bd2 <sys_unlink+0x1b0>
    80004a82:	00004597          	auipc	a1,0x4
    80004a86:	c6e58593          	addi	a1,a1,-914 # 800086f0 <syscalls+0x2f0>
    80004a8a:	fb040513          	addi	a0,s0,-80
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	6bc080e7          	jalr	1724(ra) # 8000314a <namecmp>
    80004a96:	12050e63          	beqz	a0,80004bd2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a9a:	f2c40613          	addi	a2,s0,-212
    80004a9e:	fb040593          	addi	a1,s0,-80
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	6c0080e7          	jalr	1728(ra) # 80003164 <dirlookup>
    80004aac:	892a                	mv	s2,a0
    80004aae:	12050263          	beqz	a0,80004bd2 <sys_unlink+0x1b0>
  ilock(ip);
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	1ce080e7          	jalr	462(ra) # 80002c80 <ilock>
  if(ip->nlink < 1)
    80004aba:	04a91783          	lh	a5,74(s2)
    80004abe:	08f05263          	blez	a5,80004b42 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ac2:	04491703          	lh	a4,68(s2)
    80004ac6:	4785                	li	a5,1
    80004ac8:	08f70563          	beq	a4,a5,80004b52 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004acc:	4641                	li	a2,16
    80004ace:	4581                	li	a1,0
    80004ad0:	fc040513          	addi	a0,s0,-64
    80004ad4:	ffffb097          	auipc	ra,0xffffb
    80004ad8:	6a6080e7          	jalr	1702(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004adc:	4741                	li	a4,16
    80004ade:	f2c42683          	lw	a3,-212(s0)
    80004ae2:	fc040613          	addi	a2,s0,-64
    80004ae6:	4581                	li	a1,0
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	542080e7          	jalr	1346(ra) # 8000302c <writei>
    80004af2:	47c1                	li	a5,16
    80004af4:	0af51563          	bne	a0,a5,80004b9e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004af8:	04491703          	lh	a4,68(s2)
    80004afc:	4785                	li	a5,1
    80004afe:	0af70863          	beq	a4,a5,80004bae <sys_unlink+0x18c>
  iunlockput(dp);
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	3de080e7          	jalr	990(ra) # 80002ee2 <iunlockput>
  ip->nlink--;
    80004b0c:	04a95783          	lhu	a5,74(s2)
    80004b10:	37fd                	addiw	a5,a5,-1
    80004b12:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b16:	854a                	mv	a0,s2
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	09c080e7          	jalr	156(ra) # 80002bb4 <iupdate>
  iunlockput(ip);
    80004b20:	854a                	mv	a0,s2
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	3c0080e7          	jalr	960(ra) # 80002ee2 <iunlockput>
  end_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	b76080e7          	jalr	-1162(ra) # 800036a0 <end_op>
  return 0;
    80004b32:	4501                	li	a0,0
    80004b34:	a84d                	j	80004be6 <sys_unlink+0x1c4>
    end_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	b6a080e7          	jalr	-1174(ra) # 800036a0 <end_op>
    return -1;
    80004b3e:	557d                	li	a0,-1
    80004b40:	a05d                	j	80004be6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b42:	00004517          	auipc	a0,0x4
    80004b46:	bb650513          	addi	a0,a0,-1098 # 800086f8 <syscalls+0x2f8>
    80004b4a:	00001097          	auipc	ra,0x1
    80004b4e:	1ac080e7          	jalr	428(ra) # 80005cf6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b52:	04c92703          	lw	a4,76(s2)
    80004b56:	02000793          	li	a5,32
    80004b5a:	f6e7f9e3          	bgeu	a5,a4,80004acc <sys_unlink+0xaa>
    80004b5e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b62:	4741                	li	a4,16
    80004b64:	86ce                	mv	a3,s3
    80004b66:	f1840613          	addi	a2,s0,-232
    80004b6a:	4581                	li	a1,0
    80004b6c:	854a                	mv	a0,s2
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	3c6080e7          	jalr	966(ra) # 80002f34 <readi>
    80004b76:	47c1                	li	a5,16
    80004b78:	00f51b63          	bne	a0,a5,80004b8e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b7c:	f1845783          	lhu	a5,-232(s0)
    80004b80:	e7a1                	bnez	a5,80004bc8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b82:	29c1                	addiw	s3,s3,16
    80004b84:	04c92783          	lw	a5,76(s2)
    80004b88:	fcf9ede3          	bltu	s3,a5,80004b62 <sys_unlink+0x140>
    80004b8c:	b781                	j	80004acc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b8e:	00004517          	auipc	a0,0x4
    80004b92:	b8250513          	addi	a0,a0,-1150 # 80008710 <syscalls+0x310>
    80004b96:	00001097          	auipc	ra,0x1
    80004b9a:	160080e7          	jalr	352(ra) # 80005cf6 <panic>
    panic("unlink: writei");
    80004b9e:	00004517          	auipc	a0,0x4
    80004ba2:	b8a50513          	addi	a0,a0,-1142 # 80008728 <syscalls+0x328>
    80004ba6:	00001097          	auipc	ra,0x1
    80004baa:	150080e7          	jalr	336(ra) # 80005cf6 <panic>
    dp->nlink--;
    80004bae:	04a4d783          	lhu	a5,74(s1)
    80004bb2:	37fd                	addiw	a5,a5,-1
    80004bb4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	ffa080e7          	jalr	-6(ra) # 80002bb4 <iupdate>
    80004bc2:	b781                	j	80004b02 <sys_unlink+0xe0>
    return -1;
    80004bc4:	557d                	li	a0,-1
    80004bc6:	a005                	j	80004be6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bc8:	854a                	mv	a0,s2
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	318080e7          	jalr	792(ra) # 80002ee2 <iunlockput>
  iunlockput(dp);
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	30e080e7          	jalr	782(ra) # 80002ee2 <iunlockput>
  end_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	ac4080e7          	jalr	-1340(ra) # 800036a0 <end_op>
  return -1;
    80004be4:	557d                	li	a0,-1
}
    80004be6:	70ae                	ld	ra,232(sp)
    80004be8:	740e                	ld	s0,224(sp)
    80004bea:	64ee                	ld	s1,216(sp)
    80004bec:	694e                	ld	s2,208(sp)
    80004bee:	69ae                	ld	s3,200(sp)
    80004bf0:	616d                	addi	sp,sp,240
    80004bf2:	8082                	ret

0000000080004bf4 <sys_open>:

uint64
sys_open(void)
{
    80004bf4:	7131                	addi	sp,sp,-192
    80004bf6:	fd06                	sd	ra,184(sp)
    80004bf8:	f922                	sd	s0,176(sp)
    80004bfa:	f526                	sd	s1,168(sp)
    80004bfc:	f14a                	sd	s2,160(sp)
    80004bfe:	ed4e                	sd	s3,152(sp)
    80004c00:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c02:	f4c40593          	addi	a1,s0,-180
    80004c06:	4505                	li	a0,1
    80004c08:	ffffd097          	auipc	ra,0xffffd
    80004c0c:	508080e7          	jalr	1288(ra) # 80002110 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c10:	08000613          	li	a2,128
    80004c14:	f5040593          	addi	a1,s0,-176
    80004c18:	4501                	li	a0,0
    80004c1a:	ffffd097          	auipc	ra,0xffffd
    80004c1e:	536080e7          	jalr	1334(ra) # 80002150 <argstr>
    80004c22:	87aa                	mv	a5,a0
    return -1;
    80004c24:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c26:	0a07c863          	bltz	a5,80004cd6 <sys_open+0xe2>

  begin_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	9fc080e7          	jalr	-1540(ra) # 80003626 <begin_op>

  if(omode & O_CREATE){
    80004c32:	f4c42783          	lw	a5,-180(s0)
    80004c36:	2007f793          	andi	a5,a5,512
    80004c3a:	cbdd                	beqz	a5,80004cf0 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004c3c:	4681                	li	a3,0
    80004c3e:	4601                	li	a2,0
    80004c40:	4589                	li	a1,2
    80004c42:	f5040513          	addi	a0,s0,-176
    80004c46:	00000097          	auipc	ra,0x0
    80004c4a:	97a080e7          	jalr	-1670(ra) # 800045c0 <create>
    80004c4e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c50:	c951                	beqz	a0,80004ce4 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c52:	04449703          	lh	a4,68(s1)
    80004c56:	478d                	li	a5,3
    80004c58:	00f71763          	bne	a4,a5,80004c66 <sys_open+0x72>
    80004c5c:	0464d703          	lhu	a4,70(s1)
    80004c60:	47a5                	li	a5,9
    80004c62:	0ce7ec63          	bltu	a5,a4,80004d3a <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	dc8080e7          	jalr	-568(ra) # 80003a2e <filealloc>
    80004c6e:	892a                	mv	s2,a0
    80004c70:	c56d                	beqz	a0,80004d5a <sys_open+0x166>
    80004c72:	00000097          	auipc	ra,0x0
    80004c76:	90c080e7          	jalr	-1780(ra) # 8000457e <fdalloc>
    80004c7a:	89aa                	mv	s3,a0
    80004c7c:	0c054a63          	bltz	a0,80004d50 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c80:	04449703          	lh	a4,68(s1)
    80004c84:	478d                	li	a5,3
    80004c86:	0ef70563          	beq	a4,a5,80004d70 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c8a:	4789                	li	a5,2
    80004c8c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c90:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c94:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c98:	f4c42783          	lw	a5,-180(s0)
    80004c9c:	0017c713          	xori	a4,a5,1
    80004ca0:	8b05                	andi	a4,a4,1
    80004ca2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ca6:	0037f713          	andi	a4,a5,3
    80004caa:	00e03733          	snez	a4,a4
    80004cae:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cb2:	4007f793          	andi	a5,a5,1024
    80004cb6:	c791                	beqz	a5,80004cc2 <sys_open+0xce>
    80004cb8:	04449703          	lh	a4,68(s1)
    80004cbc:	4789                	li	a5,2
    80004cbe:	0cf70063          	beq	a4,a5,80004d7e <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	07e080e7          	jalr	126(ra) # 80002d42 <iunlock>
  end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	9d4080e7          	jalr	-1580(ra) # 800036a0 <end_op>

  return fd;
    80004cd4:	854e                	mv	a0,s3
}
    80004cd6:	70ea                	ld	ra,184(sp)
    80004cd8:	744a                	ld	s0,176(sp)
    80004cda:	74aa                	ld	s1,168(sp)
    80004cdc:	790a                	ld	s2,160(sp)
    80004cde:	69ea                	ld	s3,152(sp)
    80004ce0:	6129                	addi	sp,sp,192
    80004ce2:	8082                	ret
      end_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	9bc080e7          	jalr	-1604(ra) # 800036a0 <end_op>
      return -1;
    80004cec:	557d                	li	a0,-1
    80004cee:	b7e5                	j	80004cd6 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004cf0:	f5040513          	addi	a0,s0,-176
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	732080e7          	jalr	1842(ra) # 80003426 <namei>
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	c905                	beqz	a0,80004d2e <sys_open+0x13a>
    ilock(ip);
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	f80080e7          	jalr	-128(ra) # 80002c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d08:	04449703          	lh	a4,68(s1)
    80004d0c:	4785                	li	a5,1
    80004d0e:	f4f712e3          	bne	a4,a5,80004c52 <sys_open+0x5e>
    80004d12:	f4c42783          	lw	a5,-180(s0)
    80004d16:	dba1                	beqz	a5,80004c66 <sys_open+0x72>
      iunlockput(ip);
    80004d18:	8526                	mv	a0,s1
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	1c8080e7          	jalr	456(ra) # 80002ee2 <iunlockput>
      end_op();
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	97e080e7          	jalr	-1666(ra) # 800036a0 <end_op>
      return -1;
    80004d2a:	557d                	li	a0,-1
    80004d2c:	b76d                	j	80004cd6 <sys_open+0xe2>
      end_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	972080e7          	jalr	-1678(ra) # 800036a0 <end_op>
      return -1;
    80004d36:	557d                	li	a0,-1
    80004d38:	bf79                	j	80004cd6 <sys_open+0xe2>
    iunlockput(ip);
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	1a6080e7          	jalr	422(ra) # 80002ee2 <iunlockput>
    end_op();
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	95c080e7          	jalr	-1700(ra) # 800036a0 <end_op>
    return -1;
    80004d4c:	557d                	li	a0,-1
    80004d4e:	b761                	j	80004cd6 <sys_open+0xe2>
      fileclose(f);
    80004d50:	854a                	mv	a0,s2
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	d98080e7          	jalr	-616(ra) # 80003aea <fileclose>
    iunlockput(ip);
    80004d5a:	8526                	mv	a0,s1
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	186080e7          	jalr	390(ra) # 80002ee2 <iunlockput>
    end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	93c080e7          	jalr	-1732(ra) # 800036a0 <end_op>
    return -1;
    80004d6c:	557d                	li	a0,-1
    80004d6e:	b7a5                	j	80004cd6 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d70:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d74:	04649783          	lh	a5,70(s1)
    80004d78:	02f91223          	sh	a5,36(s2)
    80004d7c:	bf21                	j	80004c94 <sys_open+0xa0>
    itrunc(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	00e080e7          	jalr	14(ra) # 80002d8e <itrunc>
    80004d88:	bf2d                	j	80004cc2 <sys_open+0xce>

0000000080004d8a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d8a:	7175                	addi	sp,sp,-144
    80004d8c:	e506                	sd	ra,136(sp)
    80004d8e:	e122                	sd	s0,128(sp)
    80004d90:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	894080e7          	jalr	-1900(ra) # 80003626 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d9a:	08000613          	li	a2,128
    80004d9e:	f7040593          	addi	a1,s0,-144
    80004da2:	4501                	li	a0,0
    80004da4:	ffffd097          	auipc	ra,0xffffd
    80004da8:	3ac080e7          	jalr	940(ra) # 80002150 <argstr>
    80004dac:	02054963          	bltz	a0,80004dde <sys_mkdir+0x54>
    80004db0:	4681                	li	a3,0
    80004db2:	4601                	li	a2,0
    80004db4:	4585                	li	a1,1
    80004db6:	f7040513          	addi	a0,s0,-144
    80004dba:	00000097          	auipc	ra,0x0
    80004dbe:	806080e7          	jalr	-2042(ra) # 800045c0 <create>
    80004dc2:	cd11                	beqz	a0,80004dde <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	11e080e7          	jalr	286(ra) # 80002ee2 <iunlockput>
  end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	8d4080e7          	jalr	-1836(ra) # 800036a0 <end_op>
  return 0;
    80004dd4:	4501                	li	a0,0
}
    80004dd6:	60aa                	ld	ra,136(sp)
    80004dd8:	640a                	ld	s0,128(sp)
    80004dda:	6149                	addi	sp,sp,144
    80004ddc:	8082                	ret
    end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	8c2080e7          	jalr	-1854(ra) # 800036a0 <end_op>
    return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	b7fd                	j	80004dd6 <sys_mkdir+0x4c>

0000000080004dea <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dea:	7135                	addi	sp,sp,-160
    80004dec:	ed06                	sd	ra,152(sp)
    80004dee:	e922                	sd	s0,144(sp)
    80004df0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	834080e7          	jalr	-1996(ra) # 80003626 <begin_op>
  argint(1, &major);
    80004dfa:	f6c40593          	addi	a1,s0,-148
    80004dfe:	4505                	li	a0,1
    80004e00:	ffffd097          	auipc	ra,0xffffd
    80004e04:	310080e7          	jalr	784(ra) # 80002110 <argint>
  argint(2, &minor);
    80004e08:	f6840593          	addi	a1,s0,-152
    80004e0c:	4509                	li	a0,2
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	302080e7          	jalr	770(ra) # 80002110 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e16:	08000613          	li	a2,128
    80004e1a:	f7040593          	addi	a1,s0,-144
    80004e1e:	4501                	li	a0,0
    80004e20:	ffffd097          	auipc	ra,0xffffd
    80004e24:	330080e7          	jalr	816(ra) # 80002150 <argstr>
    80004e28:	02054b63          	bltz	a0,80004e5e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e2c:	f6841683          	lh	a3,-152(s0)
    80004e30:	f6c41603          	lh	a2,-148(s0)
    80004e34:	458d                	li	a1,3
    80004e36:	f7040513          	addi	a0,s0,-144
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	786080e7          	jalr	1926(ra) # 800045c0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e42:	cd11                	beqz	a0,80004e5e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	09e080e7          	jalr	158(ra) # 80002ee2 <iunlockput>
  end_op();
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	854080e7          	jalr	-1964(ra) # 800036a0 <end_op>
  return 0;
    80004e54:	4501                	li	a0,0
}
    80004e56:	60ea                	ld	ra,152(sp)
    80004e58:	644a                	ld	s0,144(sp)
    80004e5a:	610d                	addi	sp,sp,160
    80004e5c:	8082                	ret
    end_op();
    80004e5e:	fffff097          	auipc	ra,0xfffff
    80004e62:	842080e7          	jalr	-1982(ra) # 800036a0 <end_op>
    return -1;
    80004e66:	557d                	li	a0,-1
    80004e68:	b7fd                	j	80004e56 <sys_mknod+0x6c>

0000000080004e6a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e6a:	7135                	addi	sp,sp,-160
    80004e6c:	ed06                	sd	ra,152(sp)
    80004e6e:	e922                	sd	s0,144(sp)
    80004e70:	e526                	sd	s1,136(sp)
    80004e72:	e14a                	sd	s2,128(sp)
    80004e74:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e76:	ffffc097          	auipc	ra,0xffffc
    80004e7a:	0d2080e7          	jalr	210(ra) # 80000f48 <myproc>
    80004e7e:	892a                	mv	s2,a0
  
  begin_op();
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	7a6080e7          	jalr	1958(ra) # 80003626 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e88:	08000613          	li	a2,128
    80004e8c:	f6040593          	addi	a1,s0,-160
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	2be080e7          	jalr	702(ra) # 80002150 <argstr>
    80004e9a:	04054b63          	bltz	a0,80004ef0 <sys_chdir+0x86>
    80004e9e:	f6040513          	addi	a0,s0,-160
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	584080e7          	jalr	1412(ra) # 80003426 <namei>
    80004eaa:	84aa                	mv	s1,a0
    80004eac:	c131                	beqz	a0,80004ef0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	dd2080e7          	jalr	-558(ra) # 80002c80 <ilock>
  if(ip->type != T_DIR){
    80004eb6:	04449703          	lh	a4,68(s1)
    80004eba:	4785                	li	a5,1
    80004ebc:	04f71063          	bne	a4,a5,80004efc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ec0:	8526                	mv	a0,s1
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	e80080e7          	jalr	-384(ra) # 80002d42 <iunlock>
  iput(p->cwd);
    80004eca:	15893503          	ld	a0,344(s2)
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	f6c080e7          	jalr	-148(ra) # 80002e3a <iput>
  end_op();
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	7ca080e7          	jalr	1994(ra) # 800036a0 <end_op>
  p->cwd = ip;
    80004ede:	14993c23          	sd	s1,344(s2)
  return 0;
    80004ee2:	4501                	li	a0,0
}
    80004ee4:	60ea                	ld	ra,152(sp)
    80004ee6:	644a                	ld	s0,144(sp)
    80004ee8:	64aa                	ld	s1,136(sp)
    80004eea:	690a                	ld	s2,128(sp)
    80004eec:	610d                	addi	sp,sp,160
    80004eee:	8082                	ret
    end_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	7b0080e7          	jalr	1968(ra) # 800036a0 <end_op>
    return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	b7ed                	j	80004ee4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004efc:	8526                	mv	a0,s1
    80004efe:	ffffe097          	auipc	ra,0xffffe
    80004f02:	fe4080e7          	jalr	-28(ra) # 80002ee2 <iunlockput>
    end_op();
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	79a080e7          	jalr	1946(ra) # 800036a0 <end_op>
    return -1;
    80004f0e:	557d                	li	a0,-1
    80004f10:	bfd1                	j	80004ee4 <sys_chdir+0x7a>

0000000080004f12 <sys_exec>:

uint64
sys_exec(void)
{
    80004f12:	7121                	addi	sp,sp,-448
    80004f14:	ff06                	sd	ra,440(sp)
    80004f16:	fb22                	sd	s0,432(sp)
    80004f18:	f726                	sd	s1,424(sp)
    80004f1a:	f34a                	sd	s2,416(sp)
    80004f1c:	ef4e                	sd	s3,408(sp)
    80004f1e:	eb52                	sd	s4,400(sp)
    80004f20:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f22:	e4840593          	addi	a1,s0,-440
    80004f26:	4505                	li	a0,1
    80004f28:	ffffd097          	auipc	ra,0xffffd
    80004f2c:	208080e7          	jalr	520(ra) # 80002130 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f30:	08000613          	li	a2,128
    80004f34:	f5040593          	addi	a1,s0,-176
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	216080e7          	jalr	534(ra) # 80002150 <argstr>
    80004f42:	87aa                	mv	a5,a0
    return -1;
    80004f44:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f46:	0c07c263          	bltz	a5,8000500a <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004f4a:	10000613          	li	a2,256
    80004f4e:	4581                	li	a1,0
    80004f50:	e5040513          	addi	a0,s0,-432
    80004f54:	ffffb097          	auipc	ra,0xffffb
    80004f58:	226080e7          	jalr	550(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f5c:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f60:	89a6                	mv	s3,s1
    80004f62:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f64:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f68:	00391513          	slli	a0,s2,0x3
    80004f6c:	e4040593          	addi	a1,s0,-448
    80004f70:	e4843783          	ld	a5,-440(s0)
    80004f74:	953e                	add	a0,a0,a5
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	0fc080e7          	jalr	252(ra) # 80002072 <fetchaddr>
    80004f7e:	02054a63          	bltz	a0,80004fb2 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f82:	e4043783          	ld	a5,-448(s0)
    80004f86:	c3b9                	beqz	a5,80004fcc <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f88:	ffffb097          	auipc	ra,0xffffb
    80004f8c:	192080e7          	jalr	402(ra) # 8000011a <kalloc>
    80004f90:	85aa                	mv	a1,a0
    80004f92:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f96:	cd11                	beqz	a0,80004fb2 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f98:	6605                	lui	a2,0x1
    80004f9a:	e4043503          	ld	a0,-448(s0)
    80004f9e:	ffffd097          	auipc	ra,0xffffd
    80004fa2:	126080e7          	jalr	294(ra) # 800020c4 <fetchstr>
    80004fa6:	00054663          	bltz	a0,80004fb2 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004faa:	0905                	addi	s2,s2,1
    80004fac:	09a1                	addi	s3,s3,8
    80004fae:	fb491de3          	bne	s2,s4,80004f68 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb2:	f5040913          	addi	s2,s0,-176
    80004fb6:	6088                	ld	a0,0(s1)
    80004fb8:	c921                	beqz	a0,80005008 <sys_exec+0xf6>
    kfree(argv[i]);
    80004fba:	ffffb097          	auipc	ra,0xffffb
    80004fbe:	062080e7          	jalr	98(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fc2:	04a1                	addi	s1,s1,8
    80004fc4:	ff2499e3          	bne	s1,s2,80004fb6 <sys_exec+0xa4>
  return -1;
    80004fc8:	557d                	li	a0,-1
    80004fca:	a081                	j	8000500a <sys_exec+0xf8>
      argv[i] = 0;
    80004fcc:	0009079b          	sext.w	a5,s2
    80004fd0:	078e                	slli	a5,a5,0x3
    80004fd2:	fd078793          	addi	a5,a5,-48
    80004fd6:	97a2                	add	a5,a5,s0
    80004fd8:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004fdc:	e5040593          	addi	a1,s0,-432
    80004fe0:	f5040513          	addi	a0,s0,-176
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	17c080e7          	jalr	380(ra) # 80004160 <exec>
    80004fec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fee:	f5040993          	addi	s3,s0,-176
    80004ff2:	6088                	ld	a0,0(s1)
    80004ff4:	c901                	beqz	a0,80005004 <sys_exec+0xf2>
    kfree(argv[i]);
    80004ff6:	ffffb097          	auipc	ra,0xffffb
    80004ffa:	026080e7          	jalr	38(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ffe:	04a1                	addi	s1,s1,8
    80005000:	ff3499e3          	bne	s1,s3,80004ff2 <sys_exec+0xe0>
  return ret;
    80005004:	854a                	mv	a0,s2
    80005006:	a011                	j	8000500a <sys_exec+0xf8>
  return -1;
    80005008:	557d                	li	a0,-1
}
    8000500a:	70fa                	ld	ra,440(sp)
    8000500c:	745a                	ld	s0,432(sp)
    8000500e:	74ba                	ld	s1,424(sp)
    80005010:	791a                	ld	s2,416(sp)
    80005012:	69fa                	ld	s3,408(sp)
    80005014:	6a5a                	ld	s4,400(sp)
    80005016:	6139                	addi	sp,sp,448
    80005018:	8082                	ret

000000008000501a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000501a:	7139                	addi	sp,sp,-64
    8000501c:	fc06                	sd	ra,56(sp)
    8000501e:	f822                	sd	s0,48(sp)
    80005020:	f426                	sd	s1,40(sp)
    80005022:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005024:	ffffc097          	auipc	ra,0xffffc
    80005028:	f24080e7          	jalr	-220(ra) # 80000f48 <myproc>
    8000502c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000502e:	fd840593          	addi	a1,s0,-40
    80005032:	4501                	li	a0,0
    80005034:	ffffd097          	auipc	ra,0xffffd
    80005038:	0fc080e7          	jalr	252(ra) # 80002130 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000503c:	fc840593          	addi	a1,s0,-56
    80005040:	fd040513          	addi	a0,s0,-48
    80005044:	fffff097          	auipc	ra,0xfffff
    80005048:	dd2080e7          	jalr	-558(ra) # 80003e16 <pipealloc>
    return -1;
    8000504c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000504e:	0c054463          	bltz	a0,80005116 <sys_pipe+0xfc>
  fd0 = -1;
    80005052:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005056:	fd043503          	ld	a0,-48(s0)
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	524080e7          	jalr	1316(ra) # 8000457e <fdalloc>
    80005062:	fca42223          	sw	a0,-60(s0)
    80005066:	08054b63          	bltz	a0,800050fc <sys_pipe+0xe2>
    8000506a:	fc843503          	ld	a0,-56(s0)
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	510080e7          	jalr	1296(ra) # 8000457e <fdalloc>
    80005076:	fca42023          	sw	a0,-64(s0)
    8000507a:	06054863          	bltz	a0,800050ea <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000507e:	4691                	li	a3,4
    80005080:	fc440613          	addi	a2,s0,-60
    80005084:	fd843583          	ld	a1,-40(s0)
    80005088:	68a8                	ld	a0,80(s1)
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	a88080e7          	jalr	-1400(ra) # 80000b12 <copyout>
    80005092:	02054063          	bltz	a0,800050b2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005096:	4691                	li	a3,4
    80005098:	fc040613          	addi	a2,s0,-64
    8000509c:	fd843583          	ld	a1,-40(s0)
    800050a0:	0591                	addi	a1,a1,4
    800050a2:	68a8                	ld	a0,80(s1)
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	a6e080e7          	jalr	-1426(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050ac:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ae:	06055463          	bgez	a0,80005116 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050b2:	fc442783          	lw	a5,-60(s0)
    800050b6:	07e9                	addi	a5,a5,26
    800050b8:	078e                	slli	a5,a5,0x3
    800050ba:	97a6                	add	a5,a5,s1
    800050bc:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800050c0:	fc042783          	lw	a5,-64(s0)
    800050c4:	07e9                	addi	a5,a5,26
    800050c6:	078e                	slli	a5,a5,0x3
    800050c8:	94be                	add	s1,s1,a5
    800050ca:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800050ce:	fd043503          	ld	a0,-48(s0)
    800050d2:	fffff097          	auipc	ra,0xfffff
    800050d6:	a18080e7          	jalr	-1512(ra) # 80003aea <fileclose>
    fileclose(wf);
    800050da:	fc843503          	ld	a0,-56(s0)
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	a0c080e7          	jalr	-1524(ra) # 80003aea <fileclose>
    return -1;
    800050e6:	57fd                	li	a5,-1
    800050e8:	a03d                	j	80005116 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800050ea:	fc442783          	lw	a5,-60(s0)
    800050ee:	0007c763          	bltz	a5,800050fc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800050f2:	07e9                	addi	a5,a5,26
    800050f4:	078e                	slli	a5,a5,0x3
    800050f6:	97a6                	add	a5,a5,s1
    800050f8:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800050fc:	fd043503          	ld	a0,-48(s0)
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	9ea080e7          	jalr	-1558(ra) # 80003aea <fileclose>
    fileclose(wf);
    80005108:	fc843503          	ld	a0,-56(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	9de080e7          	jalr	-1570(ra) # 80003aea <fileclose>
    return -1;
    80005114:	57fd                	li	a5,-1
}
    80005116:	853e                	mv	a0,a5
    80005118:	70e2                	ld	ra,56(sp)
    8000511a:	7442                	ld	s0,48(sp)
    8000511c:	74a2                	ld	s1,40(sp)
    8000511e:	6121                	addi	sp,sp,64
    80005120:	8082                	ret
	...

0000000080005130 <kernelvec>:
    80005130:	7111                	addi	sp,sp,-256
    80005132:	e006                	sd	ra,0(sp)
    80005134:	e40a                	sd	sp,8(sp)
    80005136:	e80e                	sd	gp,16(sp)
    80005138:	ec12                	sd	tp,24(sp)
    8000513a:	f016                	sd	t0,32(sp)
    8000513c:	f41a                	sd	t1,40(sp)
    8000513e:	f81e                	sd	t2,48(sp)
    80005140:	fc22                	sd	s0,56(sp)
    80005142:	e0a6                	sd	s1,64(sp)
    80005144:	e4aa                	sd	a0,72(sp)
    80005146:	e8ae                	sd	a1,80(sp)
    80005148:	ecb2                	sd	a2,88(sp)
    8000514a:	f0b6                	sd	a3,96(sp)
    8000514c:	f4ba                	sd	a4,104(sp)
    8000514e:	f8be                	sd	a5,112(sp)
    80005150:	fcc2                	sd	a6,120(sp)
    80005152:	e146                	sd	a7,128(sp)
    80005154:	e54a                	sd	s2,136(sp)
    80005156:	e94e                	sd	s3,144(sp)
    80005158:	ed52                	sd	s4,152(sp)
    8000515a:	f156                	sd	s5,160(sp)
    8000515c:	f55a                	sd	s6,168(sp)
    8000515e:	f95e                	sd	s7,176(sp)
    80005160:	fd62                	sd	s8,184(sp)
    80005162:	e1e6                	sd	s9,192(sp)
    80005164:	e5ea                	sd	s10,200(sp)
    80005166:	e9ee                	sd	s11,208(sp)
    80005168:	edf2                	sd	t3,216(sp)
    8000516a:	f1f6                	sd	t4,224(sp)
    8000516c:	f5fa                	sd	t5,232(sp)
    8000516e:	f9fe                	sd	t6,240(sp)
    80005170:	dcffc0ef          	jal	ra,80001f3e <kerneltrap>
    80005174:	6082                	ld	ra,0(sp)
    80005176:	6122                	ld	sp,8(sp)
    80005178:	61c2                	ld	gp,16(sp)
    8000517a:	7282                	ld	t0,32(sp)
    8000517c:	7322                	ld	t1,40(sp)
    8000517e:	73c2                	ld	t2,48(sp)
    80005180:	7462                	ld	s0,56(sp)
    80005182:	6486                	ld	s1,64(sp)
    80005184:	6526                	ld	a0,72(sp)
    80005186:	65c6                	ld	a1,80(sp)
    80005188:	6666                	ld	a2,88(sp)
    8000518a:	7686                	ld	a3,96(sp)
    8000518c:	7726                	ld	a4,104(sp)
    8000518e:	77c6                	ld	a5,112(sp)
    80005190:	7866                	ld	a6,120(sp)
    80005192:	688a                	ld	a7,128(sp)
    80005194:	692a                	ld	s2,136(sp)
    80005196:	69ca                	ld	s3,144(sp)
    80005198:	6a6a                	ld	s4,152(sp)
    8000519a:	7a8a                	ld	s5,160(sp)
    8000519c:	7b2a                	ld	s6,168(sp)
    8000519e:	7bca                	ld	s7,176(sp)
    800051a0:	7c6a                	ld	s8,184(sp)
    800051a2:	6c8e                	ld	s9,192(sp)
    800051a4:	6d2e                	ld	s10,200(sp)
    800051a6:	6dce                	ld	s11,208(sp)
    800051a8:	6e6e                	ld	t3,216(sp)
    800051aa:	7e8e                	ld	t4,224(sp)
    800051ac:	7f2e                	ld	t5,232(sp)
    800051ae:	7fce                	ld	t6,240(sp)
    800051b0:	6111                	addi	sp,sp,256
    800051b2:	10200073          	sret
    800051b6:	00000013          	nop
    800051ba:	00000013          	nop
    800051be:	0001                	nop

00000000800051c0 <timervec>:
    800051c0:	34051573          	csrrw	a0,mscratch,a0
    800051c4:	e10c                	sd	a1,0(a0)
    800051c6:	e510                	sd	a2,8(a0)
    800051c8:	e914                	sd	a3,16(a0)
    800051ca:	6d0c                	ld	a1,24(a0)
    800051cc:	7110                	ld	a2,32(a0)
    800051ce:	6194                	ld	a3,0(a1)
    800051d0:	96b2                	add	a3,a3,a2
    800051d2:	e194                	sd	a3,0(a1)
    800051d4:	4589                	li	a1,2
    800051d6:	14459073          	csrw	sip,a1
    800051da:	6914                	ld	a3,16(a0)
    800051dc:	6510                	ld	a2,8(a0)
    800051de:	610c                	ld	a1,0(a0)
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	30200073          	mret
	...

00000000800051ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051ea:	1141                	addi	sp,sp,-16
    800051ec:	e422                	sd	s0,8(sp)
    800051ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051f0:	0c0007b7          	lui	a5,0xc000
    800051f4:	4705                	li	a4,1
    800051f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051f8:	c3d8                	sw	a4,4(a5)
}
    800051fa:	6422                	ld	s0,8(sp)
    800051fc:	0141                	addi	sp,sp,16
    800051fe:	8082                	ret

0000000080005200 <plicinithart>:

void
plicinithart(void)
{
    80005200:	1141                	addi	sp,sp,-16
    80005202:	e406                	sd	ra,8(sp)
    80005204:	e022                	sd	s0,0(sp)
    80005206:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	d14080e7          	jalr	-748(ra) # 80000f1c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005210:	0085171b          	slliw	a4,a0,0x8
    80005214:	0c0027b7          	lui	a5,0xc002
    80005218:	97ba                	add	a5,a5,a4
    8000521a:	40200713          	li	a4,1026
    8000521e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005222:	00d5151b          	slliw	a0,a0,0xd
    80005226:	0c2017b7          	lui	a5,0xc201
    8000522a:	97aa                	add	a5,a5,a0
    8000522c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005230:	60a2                	ld	ra,8(sp)
    80005232:	6402                	ld	s0,0(sp)
    80005234:	0141                	addi	sp,sp,16
    80005236:	8082                	ret

0000000080005238 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005238:	1141                	addi	sp,sp,-16
    8000523a:	e406                	sd	ra,8(sp)
    8000523c:	e022                	sd	s0,0(sp)
    8000523e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	cdc080e7          	jalr	-804(ra) # 80000f1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005248:	00d5151b          	slliw	a0,a0,0xd
    8000524c:	0c2017b7          	lui	a5,0xc201
    80005250:	97aa                	add	a5,a5,a0
  return irq;
}
    80005252:	43c8                	lw	a0,4(a5)
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret

000000008000525c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000525c:	1101                	addi	sp,sp,-32
    8000525e:	ec06                	sd	ra,24(sp)
    80005260:	e822                	sd	s0,16(sp)
    80005262:	e426                	sd	s1,8(sp)
    80005264:	1000                	addi	s0,sp,32
    80005266:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	cb4080e7          	jalr	-844(ra) # 80000f1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005270:	00d5151b          	slliw	a0,a0,0xd
    80005274:	0c2017b7          	lui	a5,0xc201
    80005278:	97aa                	add	a5,a5,a0
    8000527a:	c3c4                	sw	s1,4(a5)
}
    8000527c:	60e2                	ld	ra,24(sp)
    8000527e:	6442                	ld	s0,16(sp)
    80005280:	64a2                	ld	s1,8(sp)
    80005282:	6105                	addi	sp,sp,32
    80005284:	8082                	ret

0000000080005286 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005286:	1141                	addi	sp,sp,-16
    80005288:	e406                	sd	ra,8(sp)
    8000528a:	e022                	sd	s0,0(sp)
    8000528c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000528e:	479d                	li	a5,7
    80005290:	04a7cc63          	blt	a5,a0,800052e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005294:	00015797          	auipc	a5,0x15
    80005298:	9bc78793          	addi	a5,a5,-1604 # 80019c50 <disk>
    8000529c:	97aa                	add	a5,a5,a0
    8000529e:	0187c783          	lbu	a5,24(a5)
    800052a2:	ebb9                	bnez	a5,800052f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052a4:	00451693          	slli	a3,a0,0x4
    800052a8:	00015797          	auipc	a5,0x15
    800052ac:	9a878793          	addi	a5,a5,-1624 # 80019c50 <disk>
    800052b0:	6398                	ld	a4,0(a5)
    800052b2:	9736                	add	a4,a4,a3
    800052b4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052b8:	6398                	ld	a4,0(a5)
    800052ba:	9736                	add	a4,a4,a3
    800052bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052c8:	97aa                	add	a5,a5,a0
    800052ca:	4705                	li	a4,1
    800052cc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052d0:	00015517          	auipc	a0,0x15
    800052d4:	99850513          	addi	a0,a0,-1640 # 80019c68 <disk+0x18>
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	42a080e7          	jalr	1066(ra) # 80001702 <wakeup>
}
    800052e0:	60a2                	ld	ra,8(sp)
    800052e2:	6402                	ld	s0,0(sp)
    800052e4:	0141                	addi	sp,sp,16
    800052e6:	8082                	ret
    panic("free_desc 1");
    800052e8:	00003517          	auipc	a0,0x3
    800052ec:	45050513          	addi	a0,a0,1104 # 80008738 <syscalls+0x338>
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	a06080e7          	jalr	-1530(ra) # 80005cf6 <panic>
    panic("free_desc 2");
    800052f8:	00003517          	auipc	a0,0x3
    800052fc:	45050513          	addi	a0,a0,1104 # 80008748 <syscalls+0x348>
    80005300:	00001097          	auipc	ra,0x1
    80005304:	9f6080e7          	jalr	-1546(ra) # 80005cf6 <panic>

0000000080005308 <virtio_disk_init>:
{
    80005308:	1101                	addi	sp,sp,-32
    8000530a:	ec06                	sd	ra,24(sp)
    8000530c:	e822                	sd	s0,16(sp)
    8000530e:	e426                	sd	s1,8(sp)
    80005310:	e04a                	sd	s2,0(sp)
    80005312:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005314:	00003597          	auipc	a1,0x3
    80005318:	44458593          	addi	a1,a1,1092 # 80008758 <syscalls+0x358>
    8000531c:	00015517          	auipc	a0,0x15
    80005320:	a5c50513          	addi	a0,a0,-1444 # 80019d78 <disk+0x128>
    80005324:	00001097          	auipc	ra,0x1
    80005328:	e7a080e7          	jalr	-390(ra) # 8000619e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	4398                	lw	a4,0(a5)
    80005332:	2701                	sext.w	a4,a4
    80005334:	747277b7          	lui	a5,0x74727
    80005338:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000533c:	14f71b63          	bne	a4,a5,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	43dc                	lw	a5,4(a5)
    80005346:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005348:	4709                	li	a4,2
    8000534a:	14e79463          	bne	a5,a4,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000534e:	100017b7          	lui	a5,0x10001
    80005352:	479c                	lw	a5,8(a5)
    80005354:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005356:	12e79e63          	bne	a5,a4,80005492 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000535a:	100017b7          	lui	a5,0x10001
    8000535e:	47d8                	lw	a4,12(a5)
    80005360:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005362:	554d47b7          	lui	a5,0x554d4
    80005366:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000536a:	12f71463          	bne	a4,a5,80005492 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005376:	4705                	li	a4,1
    80005378:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537a:	470d                	li	a4,3
    8000537c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000537e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005380:	c7ffe6b7          	lui	a3,0xc7ffe
    80005384:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc78f>
    80005388:	8f75                	and	a4,a4,a3
    8000538a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538c:	472d                	li	a4,11
    8000538e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005390:	5bbc                	lw	a5,112(a5)
    80005392:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005396:	8ba1                	andi	a5,a5,8
    80005398:	10078563          	beqz	a5,800054a2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053a4:	43fc                	lw	a5,68(a5)
    800053a6:	2781                	sext.w	a5,a5
    800053a8:	10079563          	bnez	a5,800054b2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053ac:	100017b7          	lui	a5,0x10001
    800053b0:	5bdc                	lw	a5,52(a5)
    800053b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800053b4:	10078763          	beqz	a5,800054c2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800053b8:	471d                	li	a4,7
    800053ba:	10f77c63          	bgeu	a4,a5,800054d2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800053be:	ffffb097          	auipc	ra,0xffffb
    800053c2:	d5c080e7          	jalr	-676(ra) # 8000011a <kalloc>
    800053c6:	00015497          	auipc	s1,0x15
    800053ca:	88a48493          	addi	s1,s1,-1910 # 80019c50 <disk>
    800053ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053d0:	ffffb097          	auipc	ra,0xffffb
    800053d4:	d4a080e7          	jalr	-694(ra) # 8000011a <kalloc>
    800053d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053da:	ffffb097          	auipc	ra,0xffffb
    800053de:	d40080e7          	jalr	-704(ra) # 8000011a <kalloc>
    800053e2:	87aa                	mv	a5,a0
    800053e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053e6:	6088                	ld	a0,0(s1)
    800053e8:	cd6d                	beqz	a0,800054e2 <virtio_disk_init+0x1da>
    800053ea:	00015717          	auipc	a4,0x15
    800053ee:	86e73703          	ld	a4,-1938(a4) # 80019c58 <disk+0x8>
    800053f2:	cb65                	beqz	a4,800054e2 <virtio_disk_init+0x1da>
    800053f4:	c7fd                	beqz	a5,800054e2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053f6:	6605                	lui	a2,0x1
    800053f8:	4581                	li	a1,0
    800053fa:	ffffb097          	auipc	ra,0xffffb
    800053fe:	d80080e7          	jalr	-640(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005402:	00015497          	auipc	s1,0x15
    80005406:	84e48493          	addi	s1,s1,-1970 # 80019c50 <disk>
    8000540a:	6605                	lui	a2,0x1
    8000540c:	4581                	li	a1,0
    8000540e:	6488                	ld	a0,8(s1)
    80005410:	ffffb097          	auipc	ra,0xffffb
    80005414:	d6a080e7          	jalr	-662(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005418:	6605                	lui	a2,0x1
    8000541a:	4581                	li	a1,0
    8000541c:	6888                	ld	a0,16(s1)
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	d5c080e7          	jalr	-676(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	4721                	li	a4,8
    8000542c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000542e:	4098                	lw	a4,0(s1)
    80005430:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005434:	40d8                	lw	a4,4(s1)
    80005436:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000543a:	6498                	ld	a4,8(s1)
    8000543c:	0007069b          	sext.w	a3,a4
    80005440:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005444:	9701                	srai	a4,a4,0x20
    80005446:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000544a:	6898                	ld	a4,16(s1)
    8000544c:	0007069b          	sext.w	a3,a4
    80005450:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005454:	9701                	srai	a4,a4,0x20
    80005456:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000545a:	4705                	li	a4,1
    8000545c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000545e:	00e48c23          	sb	a4,24(s1)
    80005462:	00e48ca3          	sb	a4,25(s1)
    80005466:	00e48d23          	sb	a4,26(s1)
    8000546a:	00e48da3          	sb	a4,27(s1)
    8000546e:	00e48e23          	sb	a4,28(s1)
    80005472:	00e48ea3          	sb	a4,29(s1)
    80005476:	00e48f23          	sb	a4,30(s1)
    8000547a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000547e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005482:	0727a823          	sw	s2,112(a5)
}
    80005486:	60e2                	ld	ra,24(sp)
    80005488:	6442                	ld	s0,16(sp)
    8000548a:	64a2                	ld	s1,8(sp)
    8000548c:	6902                	ld	s2,0(sp)
    8000548e:	6105                	addi	sp,sp,32
    80005490:	8082                	ret
    panic("could not find virtio disk");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	2d650513          	addi	a0,a0,726 # 80008768 <syscalls+0x368>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	85c080e7          	jalr	-1956(ra) # 80005cf6 <panic>
    panic("virtio disk FEATURES_OK unset");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	2e650513          	addi	a0,a0,742 # 80008788 <syscalls+0x388>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	84c080e7          	jalr	-1972(ra) # 80005cf6 <panic>
    panic("virtio disk should not be ready");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2f650513          	addi	a0,a0,758 # 800087a8 <syscalls+0x3a8>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	83c080e7          	jalr	-1988(ra) # 80005cf6 <panic>
    panic("virtio disk has no queue 0");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	30650513          	addi	a0,a0,774 # 800087c8 <syscalls+0x3c8>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	82c080e7          	jalr	-2004(ra) # 80005cf6 <panic>
    panic("virtio disk max queue too short");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	31650513          	addi	a0,a0,790 # 800087e8 <syscalls+0x3e8>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	81c080e7          	jalr	-2020(ra) # 80005cf6 <panic>
    panic("virtio disk kalloc");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	32650513          	addi	a0,a0,806 # 80008808 <syscalls+0x408>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	80c080e7          	jalr	-2036(ra) # 80005cf6 <panic>

00000000800054f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054f2:	7159                	addi	sp,sp,-112
    800054f4:	f486                	sd	ra,104(sp)
    800054f6:	f0a2                	sd	s0,96(sp)
    800054f8:	eca6                	sd	s1,88(sp)
    800054fa:	e8ca                	sd	s2,80(sp)
    800054fc:	e4ce                	sd	s3,72(sp)
    800054fe:	e0d2                	sd	s4,64(sp)
    80005500:	fc56                	sd	s5,56(sp)
    80005502:	f85a                	sd	s6,48(sp)
    80005504:	f45e                	sd	s7,40(sp)
    80005506:	f062                	sd	s8,32(sp)
    80005508:	ec66                	sd	s9,24(sp)
    8000550a:	e86a                	sd	s10,16(sp)
    8000550c:	1880                	addi	s0,sp,112
    8000550e:	8a2a                	mv	s4,a0
    80005510:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005512:	00c52c83          	lw	s9,12(a0)
    80005516:	001c9c9b          	slliw	s9,s9,0x1
    8000551a:	1c82                	slli	s9,s9,0x20
    8000551c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005520:	00015517          	auipc	a0,0x15
    80005524:	85850513          	addi	a0,a0,-1960 # 80019d78 <disk+0x128>
    80005528:	00001097          	auipc	ra,0x1
    8000552c:	d06080e7          	jalr	-762(ra) # 8000622e <acquire>
  for(int i = 0; i < 3; i++){
    80005530:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005532:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005534:	00014b17          	auipc	s6,0x14
    80005538:	71cb0b13          	addi	s6,s6,1820 # 80019c50 <disk>
  for(int i = 0; i < 3; i++){
    8000553c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000553e:	00015c17          	auipc	s8,0x15
    80005542:	83ac0c13          	addi	s8,s8,-1990 # 80019d78 <disk+0x128>
    80005546:	a095                	j	800055aa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005548:	00fb0733          	add	a4,s6,a5
    8000554c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005550:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005552:	0207c563          	bltz	a5,8000557c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005556:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005558:	0591                	addi	a1,a1,4
    8000555a:	05560d63          	beq	a2,s5,800055b4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000555e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005560:	00014717          	auipc	a4,0x14
    80005564:	6f070713          	addi	a4,a4,1776 # 80019c50 <disk>
    80005568:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000556a:	01874683          	lbu	a3,24(a4)
    8000556e:	fee9                	bnez	a3,80005548 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005570:	2785                	addiw	a5,a5,1
    80005572:	0705                	addi	a4,a4,1
    80005574:	fe979be3          	bne	a5,s1,8000556a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005578:	57fd                	li	a5,-1
    8000557a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000557c:	00c05e63          	blez	a2,80005598 <virtio_disk_rw+0xa6>
    80005580:	060a                	slli	a2,a2,0x2
    80005582:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005586:	0009a503          	lw	a0,0(s3)
    8000558a:	00000097          	auipc	ra,0x0
    8000558e:	cfc080e7          	jalr	-772(ra) # 80005286 <free_desc>
      for(int j = 0; j < i; j++)
    80005592:	0991                	addi	s3,s3,4
    80005594:	ffa999e3          	bne	s3,s10,80005586 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005598:	85e2                	mv	a1,s8
    8000559a:	00014517          	auipc	a0,0x14
    8000559e:	6ce50513          	addi	a0,a0,1742 # 80019c68 <disk+0x18>
    800055a2:	ffffc097          	auipc	ra,0xffffc
    800055a6:	0fc080e7          	jalr	252(ra) # 8000169e <sleep>
  for(int i = 0; i < 3; i++){
    800055aa:	f9040993          	addi	s3,s0,-112
{
    800055ae:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800055b0:	864a                	mv	a2,s2
    800055b2:	b775                	j	8000555e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055b4:	f9042503          	lw	a0,-112(s0)
    800055b8:	00a50713          	addi	a4,a0,10
    800055bc:	0712                	slli	a4,a4,0x4

  if(write)
    800055be:	00014797          	auipc	a5,0x14
    800055c2:	69278793          	addi	a5,a5,1682 # 80019c50 <disk>
    800055c6:	00e786b3          	add	a3,a5,a4
    800055ca:	01703633          	snez	a2,s7
    800055ce:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055d0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055d4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d8:	f6070613          	addi	a2,a4,-160
    800055dc:	6394                	ld	a3,0(a5)
    800055de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e0:	00870593          	addi	a1,a4,8
    800055e4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055e8:	0007b803          	ld	a6,0(a5)
    800055ec:	9642                	add	a2,a2,a6
    800055ee:	46c1                	li	a3,16
    800055f0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055f2:	4585                	li	a1,1
    800055f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055f8:	f9442683          	lw	a3,-108(s0)
    800055fc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005600:	0692                	slli	a3,a3,0x4
    80005602:	9836                	add	a6,a6,a3
    80005604:	058a0613          	addi	a2,s4,88
    80005608:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000560c:	0007b803          	ld	a6,0(a5)
    80005610:	96c2                	add	a3,a3,a6
    80005612:	40000613          	li	a2,1024
    80005616:	c690                	sw	a2,8(a3)
  if(write)
    80005618:	001bb613          	seqz	a2,s7
    8000561c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005620:	00166613          	ori	a2,a2,1
    80005624:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005628:	f9842603          	lw	a2,-104(s0)
    8000562c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005630:	00250693          	addi	a3,a0,2
    80005634:	0692                	slli	a3,a3,0x4
    80005636:	96be                	add	a3,a3,a5
    80005638:	58fd                	li	a7,-1
    8000563a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000563e:	0612                	slli	a2,a2,0x4
    80005640:	9832                	add	a6,a6,a2
    80005642:	f9070713          	addi	a4,a4,-112
    80005646:	973e                	add	a4,a4,a5
    80005648:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000564c:	6398                	ld	a4,0(a5)
    8000564e:	9732                	add	a4,a4,a2
    80005650:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005652:	4609                	li	a2,2
    80005654:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005658:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000565c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005660:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005664:	6794                	ld	a3,8(a5)
    80005666:	0026d703          	lhu	a4,2(a3)
    8000566a:	8b1d                	andi	a4,a4,7
    8000566c:	0706                	slli	a4,a4,0x1
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005674:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005678:	6798                	ld	a4,8(a5)
    8000567a:	00275783          	lhu	a5,2(a4)
    8000567e:	2785                	addiw	a5,a5,1
    80005680:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005684:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005690:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005694:	00014917          	auipc	s2,0x14
    80005698:	6e490913          	addi	s2,s2,1764 # 80019d78 <disk+0x128>
  while(b->disk == 1) {
    8000569c:	4485                	li	s1,1
    8000569e:	00b79c63          	bne	a5,a1,800056b6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056a2:	85ca                	mv	a1,s2
    800056a4:	8552                	mv	a0,s4
    800056a6:	ffffc097          	auipc	ra,0xffffc
    800056aa:	ff8080e7          	jalr	-8(ra) # 8000169e <sleep>
  while(b->disk == 1) {
    800056ae:	004a2783          	lw	a5,4(s4)
    800056b2:	fe9788e3          	beq	a5,s1,800056a2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056b6:	f9042903          	lw	s2,-112(s0)
    800056ba:	00290713          	addi	a4,s2,2
    800056be:	0712                	slli	a4,a4,0x4
    800056c0:	00014797          	auipc	a5,0x14
    800056c4:	59078793          	addi	a5,a5,1424 # 80019c50 <disk>
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056ce:	00014997          	auipc	s3,0x14
    800056d2:	58298993          	addi	s3,s3,1410 # 80019c50 <disk>
    800056d6:	00491713          	slli	a4,s2,0x4
    800056da:	0009b783          	ld	a5,0(s3)
    800056de:	97ba                	add	a5,a5,a4
    800056e0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056e4:	854a                	mv	a0,s2
    800056e6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	b9c080e7          	jalr	-1124(ra) # 80005286 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056f2:	8885                	andi	s1,s1,1
    800056f4:	f0ed                	bnez	s1,800056d6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056f6:	00014517          	auipc	a0,0x14
    800056fa:	68250513          	addi	a0,a0,1666 # 80019d78 <disk+0x128>
    800056fe:	00001097          	auipc	ra,0x1
    80005702:	be4080e7          	jalr	-1052(ra) # 800062e2 <release>
}
    80005706:	70a6                	ld	ra,104(sp)
    80005708:	7406                	ld	s0,96(sp)
    8000570a:	64e6                	ld	s1,88(sp)
    8000570c:	6946                	ld	s2,80(sp)
    8000570e:	69a6                	ld	s3,72(sp)
    80005710:	6a06                	ld	s4,64(sp)
    80005712:	7ae2                	ld	s5,56(sp)
    80005714:	7b42                	ld	s6,48(sp)
    80005716:	7ba2                	ld	s7,40(sp)
    80005718:	7c02                	ld	s8,32(sp)
    8000571a:	6ce2                	ld	s9,24(sp)
    8000571c:	6d42                	ld	s10,16(sp)
    8000571e:	6165                	addi	sp,sp,112
    80005720:	8082                	ret

0000000080005722 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005722:	1101                	addi	sp,sp,-32
    80005724:	ec06                	sd	ra,24(sp)
    80005726:	e822                	sd	s0,16(sp)
    80005728:	e426                	sd	s1,8(sp)
    8000572a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000572c:	00014497          	auipc	s1,0x14
    80005730:	52448493          	addi	s1,s1,1316 # 80019c50 <disk>
    80005734:	00014517          	auipc	a0,0x14
    80005738:	64450513          	addi	a0,a0,1604 # 80019d78 <disk+0x128>
    8000573c:	00001097          	auipc	ra,0x1
    80005740:	af2080e7          	jalr	-1294(ra) # 8000622e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005744:	10001737          	lui	a4,0x10001
    80005748:	533c                	lw	a5,96(a4)
    8000574a:	8b8d                	andi	a5,a5,3
    8000574c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000574e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005752:	689c                	ld	a5,16(s1)
    80005754:	0204d703          	lhu	a4,32(s1)
    80005758:	0027d783          	lhu	a5,2(a5)
    8000575c:	04f70863          	beq	a4,a5,800057ac <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005760:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005764:	6898                	ld	a4,16(s1)
    80005766:	0204d783          	lhu	a5,32(s1)
    8000576a:	8b9d                	andi	a5,a5,7
    8000576c:	078e                	slli	a5,a5,0x3
    8000576e:	97ba                	add	a5,a5,a4
    80005770:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005772:	00278713          	addi	a4,a5,2
    80005776:	0712                	slli	a4,a4,0x4
    80005778:	9726                	add	a4,a4,s1
    8000577a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000577e:	e721                	bnez	a4,800057c6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005780:	0789                	addi	a5,a5,2
    80005782:	0792                	slli	a5,a5,0x4
    80005784:	97a6                	add	a5,a5,s1
    80005786:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005788:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000578c:	ffffc097          	auipc	ra,0xffffc
    80005790:	f76080e7          	jalr	-138(ra) # 80001702 <wakeup>

    disk.used_idx += 1;
    80005794:	0204d783          	lhu	a5,32(s1)
    80005798:	2785                	addiw	a5,a5,1
    8000579a:	17c2                	slli	a5,a5,0x30
    8000579c:	93c1                	srli	a5,a5,0x30
    8000579e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057a2:	6898                	ld	a4,16(s1)
    800057a4:	00275703          	lhu	a4,2(a4)
    800057a8:	faf71ce3          	bne	a4,a5,80005760 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057ac:	00014517          	auipc	a0,0x14
    800057b0:	5cc50513          	addi	a0,a0,1484 # 80019d78 <disk+0x128>
    800057b4:	00001097          	auipc	ra,0x1
    800057b8:	b2e080e7          	jalr	-1234(ra) # 800062e2 <release>
}
    800057bc:	60e2                	ld	ra,24(sp)
    800057be:	6442                	ld	s0,16(sp)
    800057c0:	64a2                	ld	s1,8(sp)
    800057c2:	6105                	addi	sp,sp,32
    800057c4:	8082                	ret
      panic("virtio_disk_intr status");
    800057c6:	00003517          	auipc	a0,0x3
    800057ca:	05a50513          	addi	a0,a0,90 # 80008820 <syscalls+0x420>
    800057ce:	00000097          	auipc	ra,0x0
    800057d2:	528080e7          	jalr	1320(ra) # 80005cf6 <panic>

00000000800057d6 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057d6:	1141                	addi	sp,sp,-16
    800057d8:	e422                	sd	s0,8(sp)
    800057da:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057dc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057e0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057e4:	0037979b          	slliw	a5,a5,0x3
    800057e8:	02004737          	lui	a4,0x2004
    800057ec:	97ba                	add	a5,a5,a4
    800057ee:	0200c737          	lui	a4,0x200c
    800057f2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057f6:	000f4637          	lui	a2,0xf4
    800057fa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057fe:	9732                	add	a4,a4,a2
    80005800:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005802:	00259693          	slli	a3,a1,0x2
    80005806:	96ae                	add	a3,a3,a1
    80005808:	068e                	slli	a3,a3,0x3
    8000580a:	00014717          	auipc	a4,0x14
    8000580e:	58670713          	addi	a4,a4,1414 # 80019d90 <timer_scratch>
    80005812:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005814:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005816:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005818:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000581c:	00000797          	auipc	a5,0x0
    80005820:	9a478793          	addi	a5,a5,-1628 # 800051c0 <timervec>
    80005824:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005828:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000582c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005830:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005834:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005838:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000583c:	30479073          	csrw	mie,a5
}
    80005840:	6422                	ld	s0,8(sp)
    80005842:	0141                	addi	sp,sp,16
    80005844:	8082                	ret

0000000080005846 <start>:
{
    80005846:	1141                	addi	sp,sp,-16
    80005848:	e406                	sd	ra,8(sp)
    8000584a:	e022                	sd	s0,0(sp)
    8000584c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000584e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005852:	7779                	lui	a4,0xffffe
    80005854:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc82f>
    80005858:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000585a:	6705                	lui	a4,0x1
    8000585c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005860:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005862:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005866:	ffffb797          	auipc	a5,0xffffb
    8000586a:	ab878793          	addi	a5,a5,-1352 # 8000031e <main>
    8000586e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005872:	4781                	li	a5,0
    80005874:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005878:	67c1                	lui	a5,0x10
    8000587a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000587c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005880:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005884:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005888:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000588c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005890:	57fd                	li	a5,-1
    80005892:	83a9                	srli	a5,a5,0xa
    80005894:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005898:	47bd                	li	a5,15
    8000589a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000589e:	00000097          	auipc	ra,0x0
    800058a2:	f38080e7          	jalr	-200(ra) # 800057d6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058a6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058aa:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ac:	823e                	mv	tp,a5
  asm volatile("mret");
    800058ae:	30200073          	mret
}
    800058b2:	60a2                	ld	ra,8(sp)
    800058b4:	6402                	ld	s0,0(sp)
    800058b6:	0141                	addi	sp,sp,16
    800058b8:	8082                	ret

00000000800058ba <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058ba:	715d                	addi	sp,sp,-80
    800058bc:	e486                	sd	ra,72(sp)
    800058be:	e0a2                	sd	s0,64(sp)
    800058c0:	fc26                	sd	s1,56(sp)
    800058c2:	f84a                	sd	s2,48(sp)
    800058c4:	f44e                	sd	s3,40(sp)
    800058c6:	f052                	sd	s4,32(sp)
    800058c8:	ec56                	sd	s5,24(sp)
    800058ca:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058cc:	04c05763          	blez	a2,8000591a <consolewrite+0x60>
    800058d0:	8a2a                	mv	s4,a0
    800058d2:	84ae                	mv	s1,a1
    800058d4:	89b2                	mv	s3,a2
    800058d6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058d8:	5afd                	li	s5,-1
    800058da:	4685                	li	a3,1
    800058dc:	8626                	mv	a2,s1
    800058de:	85d2                	mv	a1,s4
    800058e0:	fbf40513          	addi	a0,s0,-65
    800058e4:	ffffc097          	auipc	ra,0xffffc
    800058e8:	218080e7          	jalr	536(ra) # 80001afc <either_copyin>
    800058ec:	01550d63          	beq	a0,s5,80005906 <consolewrite+0x4c>
      break;
    uartputc(c);
    800058f0:	fbf44503          	lbu	a0,-65(s0)
    800058f4:	00000097          	auipc	ra,0x0
    800058f8:	780080e7          	jalr	1920(ra) # 80006074 <uartputc>
  for(i = 0; i < n; i++){
    800058fc:	2905                	addiw	s2,s2,1
    800058fe:	0485                	addi	s1,s1,1
    80005900:	fd299de3          	bne	s3,s2,800058da <consolewrite+0x20>
    80005904:	894e                	mv	s2,s3
  }

  return i;
}
    80005906:	854a                	mv	a0,s2
    80005908:	60a6                	ld	ra,72(sp)
    8000590a:	6406                	ld	s0,64(sp)
    8000590c:	74e2                	ld	s1,56(sp)
    8000590e:	7942                	ld	s2,48(sp)
    80005910:	79a2                	ld	s3,40(sp)
    80005912:	7a02                	ld	s4,32(sp)
    80005914:	6ae2                	ld	s5,24(sp)
    80005916:	6161                	addi	sp,sp,80
    80005918:	8082                	ret
  for(i = 0; i < n; i++){
    8000591a:	4901                	li	s2,0
    8000591c:	b7ed                	j	80005906 <consolewrite+0x4c>

000000008000591e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000591e:	711d                	addi	sp,sp,-96
    80005920:	ec86                	sd	ra,88(sp)
    80005922:	e8a2                	sd	s0,80(sp)
    80005924:	e4a6                	sd	s1,72(sp)
    80005926:	e0ca                	sd	s2,64(sp)
    80005928:	fc4e                	sd	s3,56(sp)
    8000592a:	f852                	sd	s4,48(sp)
    8000592c:	f456                	sd	s5,40(sp)
    8000592e:	f05a                	sd	s6,32(sp)
    80005930:	ec5e                	sd	s7,24(sp)
    80005932:	1080                	addi	s0,sp,96
    80005934:	8aaa                	mv	s5,a0
    80005936:	8a2e                	mv	s4,a1
    80005938:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000593a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000593e:	0001c517          	auipc	a0,0x1c
    80005942:	59250513          	addi	a0,a0,1426 # 80021ed0 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	8e8080e7          	jalr	-1816(ra) # 8000622e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000594e:	0001c497          	auipc	s1,0x1c
    80005952:	58248493          	addi	s1,s1,1410 # 80021ed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005956:	0001c917          	auipc	s2,0x1c
    8000595a:	61290913          	addi	s2,s2,1554 # 80021f68 <cons+0x98>
  while(n > 0){
    8000595e:	09305263          	blez	s3,800059e2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005962:	0984a783          	lw	a5,152(s1)
    80005966:	09c4a703          	lw	a4,156(s1)
    8000596a:	02f71763          	bne	a4,a5,80005998 <consoleread+0x7a>
      if(killed(myproc())){
    8000596e:	ffffb097          	auipc	ra,0xffffb
    80005972:	5da080e7          	jalr	1498(ra) # 80000f48 <myproc>
    80005976:	ffffc097          	auipc	ra,0xffffc
    8000597a:	fd0080e7          	jalr	-48(ra) # 80001946 <killed>
    8000597e:	ed2d                	bnez	a0,800059f8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005980:	85a6                	mv	a1,s1
    80005982:	854a                	mv	a0,s2
    80005984:	ffffc097          	auipc	ra,0xffffc
    80005988:	d1a080e7          	jalr	-742(ra) # 8000169e <sleep>
    while(cons.r == cons.w){
    8000598c:	0984a783          	lw	a5,152(s1)
    80005990:	09c4a703          	lw	a4,156(s1)
    80005994:	fcf70de3          	beq	a4,a5,8000596e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005998:	0001c717          	auipc	a4,0x1c
    8000599c:	53870713          	addi	a4,a4,1336 # 80021ed0 <cons>
    800059a0:	0017869b          	addiw	a3,a5,1
    800059a4:	08d72c23          	sw	a3,152(a4)
    800059a8:	07f7f693          	andi	a3,a5,127
    800059ac:	9736                	add	a4,a4,a3
    800059ae:	01874703          	lbu	a4,24(a4)
    800059b2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800059b6:	4691                	li	a3,4
    800059b8:	06db8463          	beq	s7,a3,80005a20 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800059bc:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059c0:	4685                	li	a3,1
    800059c2:	faf40613          	addi	a2,s0,-81
    800059c6:	85d2                	mv	a1,s4
    800059c8:	8556                	mv	a0,s5
    800059ca:	ffffc097          	auipc	ra,0xffffc
    800059ce:	0dc080e7          	jalr	220(ra) # 80001aa6 <either_copyout>
    800059d2:	57fd                	li	a5,-1
    800059d4:	00f50763          	beq	a0,a5,800059e2 <consoleread+0xc4>
      break;

    dst++;
    800059d8:	0a05                	addi	s4,s4,1
    --n;
    800059da:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800059dc:	47a9                	li	a5,10
    800059de:	f8fb90e3          	bne	s7,a5,8000595e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059e2:	0001c517          	auipc	a0,0x1c
    800059e6:	4ee50513          	addi	a0,a0,1262 # 80021ed0 <cons>
    800059ea:	00001097          	auipc	ra,0x1
    800059ee:	8f8080e7          	jalr	-1800(ra) # 800062e2 <release>

  return target - n;
    800059f2:	413b053b          	subw	a0,s6,s3
    800059f6:	a811                	j	80005a0a <consoleread+0xec>
        release(&cons.lock);
    800059f8:	0001c517          	auipc	a0,0x1c
    800059fc:	4d850513          	addi	a0,a0,1240 # 80021ed0 <cons>
    80005a00:	00001097          	auipc	ra,0x1
    80005a04:	8e2080e7          	jalr	-1822(ra) # 800062e2 <release>
        return -1;
    80005a08:	557d                	li	a0,-1
}
    80005a0a:	60e6                	ld	ra,88(sp)
    80005a0c:	6446                	ld	s0,80(sp)
    80005a0e:	64a6                	ld	s1,72(sp)
    80005a10:	6906                	ld	s2,64(sp)
    80005a12:	79e2                	ld	s3,56(sp)
    80005a14:	7a42                	ld	s4,48(sp)
    80005a16:	7aa2                	ld	s5,40(sp)
    80005a18:	7b02                	ld	s6,32(sp)
    80005a1a:	6be2                	ld	s7,24(sp)
    80005a1c:	6125                	addi	sp,sp,96
    80005a1e:	8082                	ret
      if(n < target){
    80005a20:	0009871b          	sext.w	a4,s3
    80005a24:	fb677fe3          	bgeu	a4,s6,800059e2 <consoleread+0xc4>
        cons.r--;
    80005a28:	0001c717          	auipc	a4,0x1c
    80005a2c:	54f72023          	sw	a5,1344(a4) # 80021f68 <cons+0x98>
    80005a30:	bf4d                	j	800059e2 <consoleread+0xc4>

0000000080005a32 <consputc>:
{
    80005a32:	1141                	addi	sp,sp,-16
    80005a34:	e406                	sd	ra,8(sp)
    80005a36:	e022                	sd	s0,0(sp)
    80005a38:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a3a:	10000793          	li	a5,256
    80005a3e:	00f50a63          	beq	a0,a5,80005a52 <consputc+0x20>
    uartputc_sync(c);
    80005a42:	00000097          	auipc	ra,0x0
    80005a46:	560080e7          	jalr	1376(ra) # 80005fa2 <uartputc_sync>
}
    80005a4a:	60a2                	ld	ra,8(sp)
    80005a4c:	6402                	ld	s0,0(sp)
    80005a4e:	0141                	addi	sp,sp,16
    80005a50:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a52:	4521                	li	a0,8
    80005a54:	00000097          	auipc	ra,0x0
    80005a58:	54e080e7          	jalr	1358(ra) # 80005fa2 <uartputc_sync>
    80005a5c:	02000513          	li	a0,32
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	542080e7          	jalr	1346(ra) # 80005fa2 <uartputc_sync>
    80005a68:	4521                	li	a0,8
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	538080e7          	jalr	1336(ra) # 80005fa2 <uartputc_sync>
    80005a72:	bfe1                	j	80005a4a <consputc+0x18>

0000000080005a74 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a74:	1101                	addi	sp,sp,-32
    80005a76:	ec06                	sd	ra,24(sp)
    80005a78:	e822                	sd	s0,16(sp)
    80005a7a:	e426                	sd	s1,8(sp)
    80005a7c:	e04a                	sd	s2,0(sp)
    80005a7e:	1000                	addi	s0,sp,32
    80005a80:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a82:	0001c517          	auipc	a0,0x1c
    80005a86:	44e50513          	addi	a0,a0,1102 # 80021ed0 <cons>
    80005a8a:	00000097          	auipc	ra,0x0
    80005a8e:	7a4080e7          	jalr	1956(ra) # 8000622e <acquire>

  switch(c){
    80005a92:	47d5                	li	a5,21
    80005a94:	0af48663          	beq	s1,a5,80005b40 <consoleintr+0xcc>
    80005a98:	0297ca63          	blt	a5,s1,80005acc <consoleintr+0x58>
    80005a9c:	47a1                	li	a5,8
    80005a9e:	0ef48763          	beq	s1,a5,80005b8c <consoleintr+0x118>
    80005aa2:	47c1                	li	a5,16
    80005aa4:	10f49a63          	bne	s1,a5,80005bb8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005aa8:	ffffc097          	auipc	ra,0xffffc
    80005aac:	0aa080e7          	jalr	170(ra) # 80001b52 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ab0:	0001c517          	auipc	a0,0x1c
    80005ab4:	42050513          	addi	a0,a0,1056 # 80021ed0 <cons>
    80005ab8:	00001097          	auipc	ra,0x1
    80005abc:	82a080e7          	jalr	-2006(ra) # 800062e2 <release>
}
    80005ac0:	60e2                	ld	ra,24(sp)
    80005ac2:	6442                	ld	s0,16(sp)
    80005ac4:	64a2                	ld	s1,8(sp)
    80005ac6:	6902                	ld	s2,0(sp)
    80005ac8:	6105                	addi	sp,sp,32
    80005aca:	8082                	ret
  switch(c){
    80005acc:	07f00793          	li	a5,127
    80005ad0:	0af48e63          	beq	s1,a5,80005b8c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ad4:	0001c717          	auipc	a4,0x1c
    80005ad8:	3fc70713          	addi	a4,a4,1020 # 80021ed0 <cons>
    80005adc:	0a072783          	lw	a5,160(a4)
    80005ae0:	09872703          	lw	a4,152(a4)
    80005ae4:	9f99                	subw	a5,a5,a4
    80005ae6:	07f00713          	li	a4,127
    80005aea:	fcf763e3          	bltu	a4,a5,80005ab0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aee:	47b5                	li	a5,13
    80005af0:	0cf48763          	beq	s1,a5,80005bbe <consoleintr+0x14a>
      consputc(c);
    80005af4:	8526                	mv	a0,s1
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	f3c080e7          	jalr	-196(ra) # 80005a32 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005afe:	0001c797          	auipc	a5,0x1c
    80005b02:	3d278793          	addi	a5,a5,978 # 80021ed0 <cons>
    80005b06:	0a07a683          	lw	a3,160(a5)
    80005b0a:	0016871b          	addiw	a4,a3,1
    80005b0e:	0007061b          	sext.w	a2,a4
    80005b12:	0ae7a023          	sw	a4,160(a5)
    80005b16:	07f6f693          	andi	a3,a3,127
    80005b1a:	97b6                	add	a5,a5,a3
    80005b1c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b20:	47a9                	li	a5,10
    80005b22:	0cf48563          	beq	s1,a5,80005bec <consoleintr+0x178>
    80005b26:	4791                	li	a5,4
    80005b28:	0cf48263          	beq	s1,a5,80005bec <consoleintr+0x178>
    80005b2c:	0001c797          	auipc	a5,0x1c
    80005b30:	43c7a783          	lw	a5,1084(a5) # 80021f68 <cons+0x98>
    80005b34:	9f1d                	subw	a4,a4,a5
    80005b36:	08000793          	li	a5,128
    80005b3a:	f6f71be3          	bne	a4,a5,80005ab0 <consoleintr+0x3c>
    80005b3e:	a07d                	j	80005bec <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b40:	0001c717          	auipc	a4,0x1c
    80005b44:	39070713          	addi	a4,a4,912 # 80021ed0 <cons>
    80005b48:	0a072783          	lw	a5,160(a4)
    80005b4c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b50:	0001c497          	auipc	s1,0x1c
    80005b54:	38048493          	addi	s1,s1,896 # 80021ed0 <cons>
    while(cons.e != cons.w &&
    80005b58:	4929                	li	s2,10
    80005b5a:	f4f70be3          	beq	a4,a5,80005ab0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b5e:	37fd                	addiw	a5,a5,-1
    80005b60:	07f7f713          	andi	a4,a5,127
    80005b64:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b66:	01874703          	lbu	a4,24(a4)
    80005b6a:	f52703e3          	beq	a4,s2,80005ab0 <consoleintr+0x3c>
      cons.e--;
    80005b6e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b72:	10000513          	li	a0,256
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	ebc080e7          	jalr	-324(ra) # 80005a32 <consputc>
    while(cons.e != cons.w &&
    80005b7e:	0a04a783          	lw	a5,160(s1)
    80005b82:	09c4a703          	lw	a4,156(s1)
    80005b86:	fcf71ce3          	bne	a4,a5,80005b5e <consoleintr+0xea>
    80005b8a:	b71d                	j	80005ab0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b8c:	0001c717          	auipc	a4,0x1c
    80005b90:	34470713          	addi	a4,a4,836 # 80021ed0 <cons>
    80005b94:	0a072783          	lw	a5,160(a4)
    80005b98:	09c72703          	lw	a4,156(a4)
    80005b9c:	f0f70ae3          	beq	a4,a5,80005ab0 <consoleintr+0x3c>
      cons.e--;
    80005ba0:	37fd                	addiw	a5,a5,-1
    80005ba2:	0001c717          	auipc	a4,0x1c
    80005ba6:	3cf72723          	sw	a5,974(a4) # 80021f70 <cons+0xa0>
      consputc(BACKSPACE);
    80005baa:	10000513          	li	a0,256
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	e84080e7          	jalr	-380(ra) # 80005a32 <consputc>
    80005bb6:	bded                	j	80005ab0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bb8:	ee048ce3          	beqz	s1,80005ab0 <consoleintr+0x3c>
    80005bbc:	bf21                	j	80005ad4 <consoleintr+0x60>
      consputc(c);
    80005bbe:	4529                	li	a0,10
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	e72080e7          	jalr	-398(ra) # 80005a32 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bc8:	0001c797          	auipc	a5,0x1c
    80005bcc:	30878793          	addi	a5,a5,776 # 80021ed0 <cons>
    80005bd0:	0a07a703          	lw	a4,160(a5)
    80005bd4:	0017069b          	addiw	a3,a4,1
    80005bd8:	0006861b          	sext.w	a2,a3
    80005bdc:	0ad7a023          	sw	a3,160(a5)
    80005be0:	07f77713          	andi	a4,a4,127
    80005be4:	97ba                	add	a5,a5,a4
    80005be6:	4729                	li	a4,10
    80005be8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bec:	0001c797          	auipc	a5,0x1c
    80005bf0:	38c7a023          	sw	a2,896(a5) # 80021f6c <cons+0x9c>
        wakeup(&cons.r);
    80005bf4:	0001c517          	auipc	a0,0x1c
    80005bf8:	37450513          	addi	a0,a0,884 # 80021f68 <cons+0x98>
    80005bfc:	ffffc097          	auipc	ra,0xffffc
    80005c00:	b06080e7          	jalr	-1274(ra) # 80001702 <wakeup>
    80005c04:	b575                	j	80005ab0 <consoleintr+0x3c>

0000000080005c06 <consoleinit>:

void
consoleinit(void)
{
    80005c06:	1141                	addi	sp,sp,-16
    80005c08:	e406                	sd	ra,8(sp)
    80005c0a:	e022                	sd	s0,0(sp)
    80005c0c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c0e:	00003597          	auipc	a1,0x3
    80005c12:	c2a58593          	addi	a1,a1,-982 # 80008838 <syscalls+0x438>
    80005c16:	0001c517          	auipc	a0,0x1c
    80005c1a:	2ba50513          	addi	a0,a0,698 # 80021ed0 <cons>
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	580080e7          	jalr	1408(ra) # 8000619e <initlock>

  uartinit();
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	32c080e7          	jalr	812(ra) # 80005f52 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c2e:	00013797          	auipc	a5,0x13
    80005c32:	fca78793          	addi	a5,a5,-54 # 80018bf8 <devsw>
    80005c36:	00000717          	auipc	a4,0x0
    80005c3a:	ce870713          	addi	a4,a4,-792 # 8000591e <consoleread>
    80005c3e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c40:	00000717          	auipc	a4,0x0
    80005c44:	c7a70713          	addi	a4,a4,-902 # 800058ba <consolewrite>
    80005c48:	ef98                	sd	a4,24(a5)
}
    80005c4a:	60a2                	ld	ra,8(sp)
    80005c4c:	6402                	ld	s0,0(sp)
    80005c4e:	0141                	addi	sp,sp,16
    80005c50:	8082                	ret

0000000080005c52 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c52:	7179                	addi	sp,sp,-48
    80005c54:	f406                	sd	ra,40(sp)
    80005c56:	f022                	sd	s0,32(sp)
    80005c58:	ec26                	sd	s1,24(sp)
    80005c5a:	e84a                	sd	s2,16(sp)
    80005c5c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c5e:	c219                	beqz	a2,80005c64 <printint+0x12>
    80005c60:	08054763          	bltz	a0,80005cee <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c64:	2501                	sext.w	a0,a0
    80005c66:	4881                	li	a7,0
    80005c68:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c6c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c6e:	2581                	sext.w	a1,a1
    80005c70:	00003617          	auipc	a2,0x3
    80005c74:	bf860613          	addi	a2,a2,-1032 # 80008868 <digits>
    80005c78:	883a                	mv	a6,a4
    80005c7a:	2705                	addiw	a4,a4,1
    80005c7c:	02b577bb          	remuw	a5,a0,a1
    80005c80:	1782                	slli	a5,a5,0x20
    80005c82:	9381                	srli	a5,a5,0x20
    80005c84:	97b2                	add	a5,a5,a2
    80005c86:	0007c783          	lbu	a5,0(a5)
    80005c8a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c8e:	0005079b          	sext.w	a5,a0
    80005c92:	02b5553b          	divuw	a0,a0,a1
    80005c96:	0685                	addi	a3,a3,1
    80005c98:	feb7f0e3          	bgeu	a5,a1,80005c78 <printint+0x26>

  if(sign)
    80005c9c:	00088c63          	beqz	a7,80005cb4 <printint+0x62>
    buf[i++] = '-';
    80005ca0:	fe070793          	addi	a5,a4,-32
    80005ca4:	00878733          	add	a4,a5,s0
    80005ca8:	02d00793          	li	a5,45
    80005cac:	fef70823          	sb	a5,-16(a4)
    80005cb0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cb4:	02e05763          	blez	a4,80005ce2 <printint+0x90>
    80005cb8:	fd040793          	addi	a5,s0,-48
    80005cbc:	00e784b3          	add	s1,a5,a4
    80005cc0:	fff78913          	addi	s2,a5,-1
    80005cc4:	993a                	add	s2,s2,a4
    80005cc6:	377d                	addiw	a4,a4,-1
    80005cc8:	1702                	slli	a4,a4,0x20
    80005cca:	9301                	srli	a4,a4,0x20
    80005ccc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cd0:	fff4c503          	lbu	a0,-1(s1)
    80005cd4:	00000097          	auipc	ra,0x0
    80005cd8:	d5e080e7          	jalr	-674(ra) # 80005a32 <consputc>
  while(--i >= 0)
    80005cdc:	14fd                	addi	s1,s1,-1
    80005cde:	ff2499e3          	bne	s1,s2,80005cd0 <printint+0x7e>
}
    80005ce2:	70a2                	ld	ra,40(sp)
    80005ce4:	7402                	ld	s0,32(sp)
    80005ce6:	64e2                	ld	s1,24(sp)
    80005ce8:	6942                	ld	s2,16(sp)
    80005cea:	6145                	addi	sp,sp,48
    80005cec:	8082                	ret
    x = -xx;
    80005cee:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cf2:	4885                	li	a7,1
    x = -xx;
    80005cf4:	bf95                	j	80005c68 <printint+0x16>

0000000080005cf6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cf6:	1101                	addi	sp,sp,-32
    80005cf8:	ec06                	sd	ra,24(sp)
    80005cfa:	e822                	sd	s0,16(sp)
    80005cfc:	e426                	sd	s1,8(sp)
    80005cfe:	1000                	addi	s0,sp,32
    80005d00:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d02:	0001c797          	auipc	a5,0x1c
    80005d06:	2807a723          	sw	zero,654(a5) # 80021f90 <pr+0x18>
  printf("panic: ");
    80005d0a:	00003517          	auipc	a0,0x3
    80005d0e:	b3650513          	addi	a0,a0,-1226 # 80008840 <syscalls+0x440>
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	02e080e7          	jalr	46(ra) # 80005d40 <printf>
  printf(s);
    80005d1a:	8526                	mv	a0,s1
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	024080e7          	jalr	36(ra) # 80005d40 <printf>
  printf("\n");
    80005d24:	00002517          	auipc	a0,0x2
    80005d28:	32450513          	addi	a0,a0,804 # 80008048 <etext+0x48>
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	014080e7          	jalr	20(ra) # 80005d40 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d34:	4785                	li	a5,1
    80005d36:	00003717          	auipc	a4,0x3
    80005d3a:	c0f72b23          	sw	a5,-1002(a4) # 8000894c <panicked>
  for(;;)
    80005d3e:	a001                	j	80005d3e <panic+0x48>

0000000080005d40 <printf>:
{
    80005d40:	7131                	addi	sp,sp,-192
    80005d42:	fc86                	sd	ra,120(sp)
    80005d44:	f8a2                	sd	s0,112(sp)
    80005d46:	f4a6                	sd	s1,104(sp)
    80005d48:	f0ca                	sd	s2,96(sp)
    80005d4a:	ecce                	sd	s3,88(sp)
    80005d4c:	e8d2                	sd	s4,80(sp)
    80005d4e:	e4d6                	sd	s5,72(sp)
    80005d50:	e0da                	sd	s6,64(sp)
    80005d52:	fc5e                	sd	s7,56(sp)
    80005d54:	f862                	sd	s8,48(sp)
    80005d56:	f466                	sd	s9,40(sp)
    80005d58:	f06a                	sd	s10,32(sp)
    80005d5a:	ec6e                	sd	s11,24(sp)
    80005d5c:	0100                	addi	s0,sp,128
    80005d5e:	8a2a                	mv	s4,a0
    80005d60:	e40c                	sd	a1,8(s0)
    80005d62:	e810                	sd	a2,16(s0)
    80005d64:	ec14                	sd	a3,24(s0)
    80005d66:	f018                	sd	a4,32(s0)
    80005d68:	f41c                	sd	a5,40(s0)
    80005d6a:	03043823          	sd	a6,48(s0)
    80005d6e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d72:	0001cd97          	auipc	s11,0x1c
    80005d76:	21edad83          	lw	s11,542(s11) # 80021f90 <pr+0x18>
  if(locking)
    80005d7a:	020d9b63          	bnez	s11,80005db0 <printf+0x70>
  if (fmt == 0)
    80005d7e:	040a0263          	beqz	s4,80005dc2 <printf+0x82>
  va_start(ap, fmt);
    80005d82:	00840793          	addi	a5,s0,8
    80005d86:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8a:	000a4503          	lbu	a0,0(s4)
    80005d8e:	14050f63          	beqz	a0,80005eec <printf+0x1ac>
    80005d92:	4981                	li	s3,0
    if(c != '%'){
    80005d94:	02500a93          	li	s5,37
    switch(c){
    80005d98:	07000b93          	li	s7,112
  consputc('x');
    80005d9c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d9e:	00003b17          	auipc	s6,0x3
    80005da2:	acab0b13          	addi	s6,s6,-1334 # 80008868 <digits>
    switch(c){
    80005da6:	07300c93          	li	s9,115
    80005daa:	06400c13          	li	s8,100
    80005dae:	a82d                	j	80005de8 <printf+0xa8>
    acquire(&pr.lock);
    80005db0:	0001c517          	auipc	a0,0x1c
    80005db4:	1c850513          	addi	a0,a0,456 # 80021f78 <pr>
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	476080e7          	jalr	1142(ra) # 8000622e <acquire>
    80005dc0:	bf7d                	j	80005d7e <printf+0x3e>
    panic("null fmt");
    80005dc2:	00003517          	auipc	a0,0x3
    80005dc6:	a8e50513          	addi	a0,a0,-1394 # 80008850 <syscalls+0x450>
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	f2c080e7          	jalr	-212(ra) # 80005cf6 <panic>
      consputc(c);
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	c60080e7          	jalr	-928(ra) # 80005a32 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dda:	2985                	addiw	s3,s3,1
    80005ddc:	013a07b3          	add	a5,s4,s3
    80005de0:	0007c503          	lbu	a0,0(a5)
    80005de4:	10050463          	beqz	a0,80005eec <printf+0x1ac>
    if(c != '%'){
    80005de8:	ff5515e3          	bne	a0,s5,80005dd2 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dec:	2985                	addiw	s3,s3,1
    80005dee:	013a07b3          	add	a5,s4,s3
    80005df2:	0007c783          	lbu	a5,0(a5)
    80005df6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dfa:	cbed                	beqz	a5,80005eec <printf+0x1ac>
    switch(c){
    80005dfc:	05778a63          	beq	a5,s7,80005e50 <printf+0x110>
    80005e00:	02fbf663          	bgeu	s7,a5,80005e2c <printf+0xec>
    80005e04:	09978863          	beq	a5,s9,80005e94 <printf+0x154>
    80005e08:	07800713          	li	a4,120
    80005e0c:	0ce79563          	bne	a5,a4,80005ed6 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e10:	f8843783          	ld	a5,-120(s0)
    80005e14:	00878713          	addi	a4,a5,8
    80005e18:	f8e43423          	sd	a4,-120(s0)
    80005e1c:	4605                	li	a2,1
    80005e1e:	85ea                	mv	a1,s10
    80005e20:	4388                	lw	a0,0(a5)
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	e30080e7          	jalr	-464(ra) # 80005c52 <printint>
      break;
    80005e2a:	bf45                	j	80005dda <printf+0x9a>
    switch(c){
    80005e2c:	09578f63          	beq	a5,s5,80005eca <printf+0x18a>
    80005e30:	0b879363          	bne	a5,s8,80005ed6 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e34:	f8843783          	ld	a5,-120(s0)
    80005e38:	00878713          	addi	a4,a5,8
    80005e3c:	f8e43423          	sd	a4,-120(s0)
    80005e40:	4605                	li	a2,1
    80005e42:	45a9                	li	a1,10
    80005e44:	4388                	lw	a0,0(a5)
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	e0c080e7          	jalr	-500(ra) # 80005c52 <printint>
      break;
    80005e4e:	b771                	j	80005dda <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e50:	f8843783          	ld	a5,-120(s0)
    80005e54:	00878713          	addi	a4,a5,8
    80005e58:	f8e43423          	sd	a4,-120(s0)
    80005e5c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e60:	03000513          	li	a0,48
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	bce080e7          	jalr	-1074(ra) # 80005a32 <consputc>
  consputc('x');
    80005e6c:	07800513          	li	a0,120
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	bc2080e7          	jalr	-1086(ra) # 80005a32 <consputc>
    80005e78:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e7a:	03c95793          	srli	a5,s2,0x3c
    80005e7e:	97da                	add	a5,a5,s6
    80005e80:	0007c503          	lbu	a0,0(a5)
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	bae080e7          	jalr	-1106(ra) # 80005a32 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e8c:	0912                	slli	s2,s2,0x4
    80005e8e:	34fd                	addiw	s1,s1,-1
    80005e90:	f4ed                	bnez	s1,80005e7a <printf+0x13a>
    80005e92:	b7a1                	j	80005dda <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e94:	f8843783          	ld	a5,-120(s0)
    80005e98:	00878713          	addi	a4,a5,8
    80005e9c:	f8e43423          	sd	a4,-120(s0)
    80005ea0:	6384                	ld	s1,0(a5)
    80005ea2:	cc89                	beqz	s1,80005ebc <printf+0x17c>
      for(; *s; s++)
    80005ea4:	0004c503          	lbu	a0,0(s1)
    80005ea8:	d90d                	beqz	a0,80005dda <printf+0x9a>
        consputc(*s);
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	b88080e7          	jalr	-1144(ra) # 80005a32 <consputc>
      for(; *s; s++)
    80005eb2:	0485                	addi	s1,s1,1
    80005eb4:	0004c503          	lbu	a0,0(s1)
    80005eb8:	f96d                	bnez	a0,80005eaa <printf+0x16a>
    80005eba:	b705                	j	80005dda <printf+0x9a>
        s = "(null)";
    80005ebc:	00003497          	auipc	s1,0x3
    80005ec0:	98c48493          	addi	s1,s1,-1652 # 80008848 <syscalls+0x448>
      for(; *s; s++)
    80005ec4:	02800513          	li	a0,40
    80005ec8:	b7cd                	j	80005eaa <printf+0x16a>
      consputc('%');
    80005eca:	8556                	mv	a0,s5
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	b66080e7          	jalr	-1178(ra) # 80005a32 <consputc>
      break;
    80005ed4:	b719                	j	80005dda <printf+0x9a>
      consputc('%');
    80005ed6:	8556                	mv	a0,s5
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	b5a080e7          	jalr	-1190(ra) # 80005a32 <consputc>
      consputc(c);
    80005ee0:	8526                	mv	a0,s1
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	b50080e7          	jalr	-1200(ra) # 80005a32 <consputc>
      break;
    80005eea:	bdc5                	j	80005dda <printf+0x9a>
  if(locking)
    80005eec:	020d9163          	bnez	s11,80005f0e <printf+0x1ce>
}
    80005ef0:	70e6                	ld	ra,120(sp)
    80005ef2:	7446                	ld	s0,112(sp)
    80005ef4:	74a6                	ld	s1,104(sp)
    80005ef6:	7906                	ld	s2,96(sp)
    80005ef8:	69e6                	ld	s3,88(sp)
    80005efa:	6a46                	ld	s4,80(sp)
    80005efc:	6aa6                	ld	s5,72(sp)
    80005efe:	6b06                	ld	s6,64(sp)
    80005f00:	7be2                	ld	s7,56(sp)
    80005f02:	7c42                	ld	s8,48(sp)
    80005f04:	7ca2                	ld	s9,40(sp)
    80005f06:	7d02                	ld	s10,32(sp)
    80005f08:	6de2                	ld	s11,24(sp)
    80005f0a:	6129                	addi	sp,sp,192
    80005f0c:	8082                	ret
    release(&pr.lock);
    80005f0e:	0001c517          	auipc	a0,0x1c
    80005f12:	06a50513          	addi	a0,a0,106 # 80021f78 <pr>
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	3cc080e7          	jalr	972(ra) # 800062e2 <release>
}
    80005f1e:	bfc9                	j	80005ef0 <printf+0x1b0>

0000000080005f20 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f20:	1101                	addi	sp,sp,-32
    80005f22:	ec06                	sd	ra,24(sp)
    80005f24:	e822                	sd	s0,16(sp)
    80005f26:	e426                	sd	s1,8(sp)
    80005f28:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f2a:	0001c497          	auipc	s1,0x1c
    80005f2e:	04e48493          	addi	s1,s1,78 # 80021f78 <pr>
    80005f32:	00003597          	auipc	a1,0x3
    80005f36:	92e58593          	addi	a1,a1,-1746 # 80008860 <syscalls+0x460>
    80005f3a:	8526                	mv	a0,s1
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	262080e7          	jalr	610(ra) # 8000619e <initlock>
  pr.locking = 1;
    80005f44:	4785                	li	a5,1
    80005f46:	cc9c                	sw	a5,24(s1)
}
    80005f48:	60e2                	ld	ra,24(sp)
    80005f4a:	6442                	ld	s0,16(sp)
    80005f4c:	64a2                	ld	s1,8(sp)
    80005f4e:	6105                	addi	sp,sp,32
    80005f50:	8082                	ret

0000000080005f52 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f52:	1141                	addi	sp,sp,-16
    80005f54:	e406                	sd	ra,8(sp)
    80005f56:	e022                	sd	s0,0(sp)
    80005f58:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f5a:	100007b7          	lui	a5,0x10000
    80005f5e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f62:	f8000713          	li	a4,-128
    80005f66:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f6a:	470d                	li	a4,3
    80005f6c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f70:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f74:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f78:	469d                	li	a3,7
    80005f7a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f7e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f82:	00003597          	auipc	a1,0x3
    80005f86:	8fe58593          	addi	a1,a1,-1794 # 80008880 <digits+0x18>
    80005f8a:	0001c517          	auipc	a0,0x1c
    80005f8e:	00e50513          	addi	a0,a0,14 # 80021f98 <uart_tx_lock>
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	20c080e7          	jalr	524(ra) # 8000619e <initlock>
}
    80005f9a:	60a2                	ld	ra,8(sp)
    80005f9c:	6402                	ld	s0,0(sp)
    80005f9e:	0141                	addi	sp,sp,16
    80005fa0:	8082                	ret

0000000080005fa2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fa2:	1101                	addi	sp,sp,-32
    80005fa4:	ec06                	sd	ra,24(sp)
    80005fa6:	e822                	sd	s0,16(sp)
    80005fa8:	e426                	sd	s1,8(sp)
    80005faa:	1000                	addi	s0,sp,32
    80005fac:	84aa                	mv	s1,a0
  push_off();
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	234080e7          	jalr	564(ra) # 800061e2 <push_off>

  if(panicked){
    80005fb6:	00003797          	auipc	a5,0x3
    80005fba:	9967a783          	lw	a5,-1642(a5) # 8000894c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fbe:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fc2:	c391                	beqz	a5,80005fc6 <uartputc_sync+0x24>
    for(;;)
    80005fc4:	a001                	j	80005fc4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fca:	0207f793          	andi	a5,a5,32
    80005fce:	dfe5                	beqz	a5,80005fc6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fd0:	0ff4f513          	zext.b	a0,s1
    80005fd4:	100007b7          	lui	a5,0x10000
    80005fd8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	2a6080e7          	jalr	678(ra) # 80006282 <pop_off>
}
    80005fe4:	60e2                	ld	ra,24(sp)
    80005fe6:	6442                	ld	s0,16(sp)
    80005fe8:	64a2                	ld	s1,8(sp)
    80005fea:	6105                	addi	sp,sp,32
    80005fec:	8082                	ret

0000000080005fee <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fee:	00003797          	auipc	a5,0x3
    80005ff2:	9627b783          	ld	a5,-1694(a5) # 80008950 <uart_tx_r>
    80005ff6:	00003717          	auipc	a4,0x3
    80005ffa:	96273703          	ld	a4,-1694(a4) # 80008958 <uart_tx_w>
    80005ffe:	06f70a63          	beq	a4,a5,80006072 <uartstart+0x84>
{
    80006002:	7139                	addi	sp,sp,-64
    80006004:	fc06                	sd	ra,56(sp)
    80006006:	f822                	sd	s0,48(sp)
    80006008:	f426                	sd	s1,40(sp)
    8000600a:	f04a                	sd	s2,32(sp)
    8000600c:	ec4e                	sd	s3,24(sp)
    8000600e:	e852                	sd	s4,16(sp)
    80006010:	e456                	sd	s5,8(sp)
    80006012:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006014:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006018:	0001ca17          	auipc	s4,0x1c
    8000601c:	f80a0a13          	addi	s4,s4,-128 # 80021f98 <uart_tx_lock>
    uart_tx_r += 1;
    80006020:	00003497          	auipc	s1,0x3
    80006024:	93048493          	addi	s1,s1,-1744 # 80008950 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006028:	00003997          	auipc	s3,0x3
    8000602c:	93098993          	addi	s3,s3,-1744 # 80008958 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006030:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006034:	02077713          	andi	a4,a4,32
    80006038:	c705                	beqz	a4,80006060 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000603a:	01f7f713          	andi	a4,a5,31
    8000603e:	9752                	add	a4,a4,s4
    80006040:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006044:	0785                	addi	a5,a5,1
    80006046:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006048:	8526                	mv	a0,s1
    8000604a:	ffffb097          	auipc	ra,0xffffb
    8000604e:	6b8080e7          	jalr	1720(ra) # 80001702 <wakeup>
    
    WriteReg(THR, c);
    80006052:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006056:	609c                	ld	a5,0(s1)
    80006058:	0009b703          	ld	a4,0(s3)
    8000605c:	fcf71ae3          	bne	a4,a5,80006030 <uartstart+0x42>
  }
}
    80006060:	70e2                	ld	ra,56(sp)
    80006062:	7442                	ld	s0,48(sp)
    80006064:	74a2                	ld	s1,40(sp)
    80006066:	7902                	ld	s2,32(sp)
    80006068:	69e2                	ld	s3,24(sp)
    8000606a:	6a42                	ld	s4,16(sp)
    8000606c:	6aa2                	ld	s5,8(sp)
    8000606e:	6121                	addi	sp,sp,64
    80006070:	8082                	ret
    80006072:	8082                	ret

0000000080006074 <uartputc>:
{
    80006074:	7179                	addi	sp,sp,-48
    80006076:	f406                	sd	ra,40(sp)
    80006078:	f022                	sd	s0,32(sp)
    8000607a:	ec26                	sd	s1,24(sp)
    8000607c:	e84a                	sd	s2,16(sp)
    8000607e:	e44e                	sd	s3,8(sp)
    80006080:	e052                	sd	s4,0(sp)
    80006082:	1800                	addi	s0,sp,48
    80006084:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006086:	0001c517          	auipc	a0,0x1c
    8000608a:	f1250513          	addi	a0,a0,-238 # 80021f98 <uart_tx_lock>
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	1a0080e7          	jalr	416(ra) # 8000622e <acquire>
  if(panicked){
    80006096:	00003797          	auipc	a5,0x3
    8000609a:	8b67a783          	lw	a5,-1866(a5) # 8000894c <panicked>
    8000609e:	e7c9                	bnez	a5,80006128 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060a0:	00003717          	auipc	a4,0x3
    800060a4:	8b873703          	ld	a4,-1864(a4) # 80008958 <uart_tx_w>
    800060a8:	00003797          	auipc	a5,0x3
    800060ac:	8a87b783          	ld	a5,-1880(a5) # 80008950 <uart_tx_r>
    800060b0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060b4:	0001c997          	auipc	s3,0x1c
    800060b8:	ee498993          	addi	s3,s3,-284 # 80021f98 <uart_tx_lock>
    800060bc:	00003497          	auipc	s1,0x3
    800060c0:	89448493          	addi	s1,s1,-1900 # 80008950 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060c4:	00003917          	auipc	s2,0x3
    800060c8:	89490913          	addi	s2,s2,-1900 # 80008958 <uart_tx_w>
    800060cc:	00e79f63          	bne	a5,a4,800060ea <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060d0:	85ce                	mv	a1,s3
    800060d2:	8526                	mv	a0,s1
    800060d4:	ffffb097          	auipc	ra,0xffffb
    800060d8:	5ca080e7          	jalr	1482(ra) # 8000169e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060dc:	00093703          	ld	a4,0(s2)
    800060e0:	609c                	ld	a5,0(s1)
    800060e2:	02078793          	addi	a5,a5,32
    800060e6:	fee785e3          	beq	a5,a4,800060d0 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060ea:	0001c497          	auipc	s1,0x1c
    800060ee:	eae48493          	addi	s1,s1,-338 # 80021f98 <uart_tx_lock>
    800060f2:	01f77793          	andi	a5,a4,31
    800060f6:	97a6                	add	a5,a5,s1
    800060f8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800060fc:	0705                	addi	a4,a4,1
    800060fe:	00003797          	auipc	a5,0x3
    80006102:	84e7bd23          	sd	a4,-1958(a5) # 80008958 <uart_tx_w>
  uartstart();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	ee8080e7          	jalr	-280(ra) # 80005fee <uartstart>
  release(&uart_tx_lock);
    8000610e:	8526                	mv	a0,s1
    80006110:	00000097          	auipc	ra,0x0
    80006114:	1d2080e7          	jalr	466(ra) # 800062e2 <release>
}
    80006118:	70a2                	ld	ra,40(sp)
    8000611a:	7402                	ld	s0,32(sp)
    8000611c:	64e2                	ld	s1,24(sp)
    8000611e:	6942                	ld	s2,16(sp)
    80006120:	69a2                	ld	s3,8(sp)
    80006122:	6a02                	ld	s4,0(sp)
    80006124:	6145                	addi	sp,sp,48
    80006126:	8082                	ret
    for(;;)
    80006128:	a001                	j	80006128 <uartputc+0xb4>

000000008000612a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000612a:	1141                	addi	sp,sp,-16
    8000612c:	e422                	sd	s0,8(sp)
    8000612e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006130:	100007b7          	lui	a5,0x10000
    80006134:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006138:	8b85                	andi	a5,a5,1
    8000613a:	cb81                	beqz	a5,8000614a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000613c:	100007b7          	lui	a5,0x10000
    80006140:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006144:	6422                	ld	s0,8(sp)
    80006146:	0141                	addi	sp,sp,16
    80006148:	8082                	ret
    return -1;
    8000614a:	557d                	li	a0,-1
    8000614c:	bfe5                	j	80006144 <uartgetc+0x1a>

000000008000614e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000614e:	1101                	addi	sp,sp,-32
    80006150:	ec06                	sd	ra,24(sp)
    80006152:	e822                	sd	s0,16(sp)
    80006154:	e426                	sd	s1,8(sp)
    80006156:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006158:	54fd                	li	s1,-1
    8000615a:	a029                	j	80006164 <uartintr+0x16>
      break;
    consoleintr(c);
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	918080e7          	jalr	-1768(ra) # 80005a74 <consoleintr>
    int c = uartgetc();
    80006164:	00000097          	auipc	ra,0x0
    80006168:	fc6080e7          	jalr	-58(ra) # 8000612a <uartgetc>
    if(c == -1)
    8000616c:	fe9518e3          	bne	a0,s1,8000615c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006170:	0001c497          	auipc	s1,0x1c
    80006174:	e2848493          	addi	s1,s1,-472 # 80021f98 <uart_tx_lock>
    80006178:	8526                	mv	a0,s1
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	0b4080e7          	jalr	180(ra) # 8000622e <acquire>
  uartstart();
    80006182:	00000097          	auipc	ra,0x0
    80006186:	e6c080e7          	jalr	-404(ra) # 80005fee <uartstart>
  release(&uart_tx_lock);
    8000618a:	8526                	mv	a0,s1
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	156080e7          	jalr	342(ra) # 800062e2 <release>
}
    80006194:	60e2                	ld	ra,24(sp)
    80006196:	6442                	ld	s0,16(sp)
    80006198:	64a2                	ld	s1,8(sp)
    8000619a:	6105                	addi	sp,sp,32
    8000619c:	8082                	ret

000000008000619e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000619e:	1141                	addi	sp,sp,-16
    800061a0:	e422                	sd	s0,8(sp)
    800061a2:	0800                	addi	s0,sp,16
  lk->name = name;
    800061a4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061a6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061aa:	00053823          	sd	zero,16(a0)
}
    800061ae:	6422                	ld	s0,8(sp)
    800061b0:	0141                	addi	sp,sp,16
    800061b2:	8082                	ret

00000000800061b4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061b4:	411c                	lw	a5,0(a0)
    800061b6:	e399                	bnez	a5,800061bc <holding+0x8>
    800061b8:	4501                	li	a0,0
  return r;
}
    800061ba:	8082                	ret
{
    800061bc:	1101                	addi	sp,sp,-32
    800061be:	ec06                	sd	ra,24(sp)
    800061c0:	e822                	sd	s0,16(sp)
    800061c2:	e426                	sd	s1,8(sp)
    800061c4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061c6:	6904                	ld	s1,16(a0)
    800061c8:	ffffb097          	auipc	ra,0xffffb
    800061cc:	d64080e7          	jalr	-668(ra) # 80000f2c <mycpu>
    800061d0:	40a48533          	sub	a0,s1,a0
    800061d4:	00153513          	seqz	a0,a0
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret

00000000800061e2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061ec:	100024f3          	csrr	s1,sstatus
    800061f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061f4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061f6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061fa:	ffffb097          	auipc	ra,0xffffb
    800061fe:	d32080e7          	jalr	-718(ra) # 80000f2c <mycpu>
    80006202:	5d3c                	lw	a5,120(a0)
    80006204:	cf89                	beqz	a5,8000621e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006206:	ffffb097          	auipc	ra,0xffffb
    8000620a:	d26080e7          	jalr	-730(ra) # 80000f2c <mycpu>
    8000620e:	5d3c                	lw	a5,120(a0)
    80006210:	2785                	addiw	a5,a5,1
    80006212:	dd3c                	sw	a5,120(a0)
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	addi	sp,sp,32
    8000621c:	8082                	ret
    mycpu()->intena = old;
    8000621e:	ffffb097          	auipc	ra,0xffffb
    80006222:	d0e080e7          	jalr	-754(ra) # 80000f2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006226:	8085                	srli	s1,s1,0x1
    80006228:	8885                	andi	s1,s1,1
    8000622a:	dd64                	sw	s1,124(a0)
    8000622c:	bfe9                	j	80006206 <push_off+0x24>

000000008000622e <acquire>:
{
    8000622e:	1101                	addi	sp,sp,-32
    80006230:	ec06                	sd	ra,24(sp)
    80006232:	e822                	sd	s0,16(sp)
    80006234:	e426                	sd	s1,8(sp)
    80006236:	1000                	addi	s0,sp,32
    80006238:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	fa8080e7          	jalr	-88(ra) # 800061e2 <push_off>
  if(holding(lk))
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	f70080e7          	jalr	-144(ra) # 800061b4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000624c:	4705                	li	a4,1
  if(holding(lk))
    8000624e:	e115                	bnez	a0,80006272 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006250:	87ba                	mv	a5,a4
    80006252:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006256:	2781                	sext.w	a5,a5
    80006258:	ffe5                	bnez	a5,80006250 <acquire+0x22>
  __sync_synchronize();
    8000625a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000625e:	ffffb097          	auipc	ra,0xffffb
    80006262:	cce080e7          	jalr	-818(ra) # 80000f2c <mycpu>
    80006266:	e888                	sd	a0,16(s1)
}
    80006268:	60e2                	ld	ra,24(sp)
    8000626a:	6442                	ld	s0,16(sp)
    8000626c:	64a2                	ld	s1,8(sp)
    8000626e:	6105                	addi	sp,sp,32
    80006270:	8082                	ret
    panic("acquire");
    80006272:	00002517          	auipc	a0,0x2
    80006276:	61650513          	addi	a0,a0,1558 # 80008888 <digits+0x20>
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	a7c080e7          	jalr	-1412(ra) # 80005cf6 <panic>

0000000080006282 <pop_off>:

void
pop_off(void)
{
    80006282:	1141                	addi	sp,sp,-16
    80006284:	e406                	sd	ra,8(sp)
    80006286:	e022                	sd	s0,0(sp)
    80006288:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000628a:	ffffb097          	auipc	ra,0xffffb
    8000628e:	ca2080e7          	jalr	-862(ra) # 80000f2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006292:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006296:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006298:	e78d                	bnez	a5,800062c2 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000629a:	5d3c                	lw	a5,120(a0)
    8000629c:	02f05b63          	blez	a5,800062d2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062a0:	37fd                	addiw	a5,a5,-1
    800062a2:	0007871b          	sext.w	a4,a5
    800062a6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062a8:	eb09                	bnez	a4,800062ba <pop_off+0x38>
    800062aa:	5d7c                	lw	a5,124(a0)
    800062ac:	c799                	beqz	a5,800062ba <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062b6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062ba:	60a2                	ld	ra,8(sp)
    800062bc:	6402                	ld	s0,0(sp)
    800062be:	0141                	addi	sp,sp,16
    800062c0:	8082                	ret
    panic("pop_off - interruptible");
    800062c2:	00002517          	auipc	a0,0x2
    800062c6:	5ce50513          	addi	a0,a0,1486 # 80008890 <digits+0x28>
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	a2c080e7          	jalr	-1492(ra) # 80005cf6 <panic>
    panic("pop_off");
    800062d2:	00002517          	auipc	a0,0x2
    800062d6:	5d650513          	addi	a0,a0,1494 # 800088a8 <digits+0x40>
    800062da:	00000097          	auipc	ra,0x0
    800062de:	a1c080e7          	jalr	-1508(ra) # 80005cf6 <panic>

00000000800062e2 <release>:
{
    800062e2:	1101                	addi	sp,sp,-32
    800062e4:	ec06                	sd	ra,24(sp)
    800062e6:	e822                	sd	s0,16(sp)
    800062e8:	e426                	sd	s1,8(sp)
    800062ea:	1000                	addi	s0,sp,32
    800062ec:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	ec6080e7          	jalr	-314(ra) # 800061b4 <holding>
    800062f6:	c115                	beqz	a0,8000631a <release+0x38>
  lk->cpu = 0;
    800062f8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062fc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006300:	0f50000f          	fence	iorw,ow
    80006304:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	f7a080e7          	jalr	-134(ra) # 80006282 <pop_off>
}
    80006310:	60e2                	ld	ra,24(sp)
    80006312:	6442                	ld	s0,16(sp)
    80006314:	64a2                	ld	s1,8(sp)
    80006316:	6105                	addi	sp,sp,32
    80006318:	8082                	ret
    panic("release");
    8000631a:	00002517          	auipc	a0,0x2
    8000631e:	59650513          	addi	a0,a0,1430 # 800088b0 <digits+0x48>
    80006322:	00000097          	auipc	ra,0x0
    80006326:	9d4080e7          	jalr	-1580(ra) # 80005cf6 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
