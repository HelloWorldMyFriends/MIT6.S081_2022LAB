
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
    80000016:	111050ef          	jal	ra,80005926 <start>

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
    8000005e:	2b4080e7          	jalr	692(ra) # 8000630e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	354080e7          	jalr	852(ra) # 800063c2 <release>
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
    8000008e:	d4c080e7          	jalr	-692(ra) # 80005dd6 <panic>

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
    800000fa:	188080e7          	jalr	392(ra) # 8000627e <initlock>
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
    80000132:	1e0080e7          	jalr	480(ra) # 8000630e <acquire>
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
    8000014a:	27c080e7          	jalr	636(ra) # 800063c2 <release>

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
    80000174:	252080e7          	jalr	594(ra) # 800063c2 <release>
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
    80000358:	acc080e7          	jalr	-1332(ra) # 80005e20 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	9cc080e7          	jalr	-1588(ra) # 80001d30 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	f74080e7          	jalr	-140(ra) # 800052e0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	178080e7          	jalr	376(ra) # 800014ec <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	96a080e7          	jalr	-1686(ra) # 80005ce6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	c7c080e7          	jalr	-900(ra) # 80006000 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	a8c080e7          	jalr	-1396(ra) # 80005e20 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	a7c080e7          	jalr	-1412(ra) # 80005e20 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a6c080e7          	jalr	-1428(ra) # 80005e20 <printf>
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
    800003e0:	92c080e7          	jalr	-1748(ra) # 80001d08 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	94c080e7          	jalr	-1716(ra) # 80001d30 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	ede080e7          	jalr	-290(ra) # 800052ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	eec080e7          	jalr	-276(ra) # 800052e0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	0d2080e7          	jalr	210(ra) # 800024ce <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	770080e7          	jalr	1904(ra) # 80002b74 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	6e6080e7          	jalr	1766(ra) # 80003af2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	fd4080e7          	jalr	-44(ra) # 800053e8 <virtio_disk_init>
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
    8000048e:	94c080e7          	jalr	-1716(ra) # 80005dd6 <panic>
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
    800005b0:	00006097          	auipc	ra,0x6
    800005b4:	826080e7          	jalr	-2010(ra) # 80005dd6 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00006097          	auipc	ra,0x6
    800005c4:	816080e7          	jalr	-2026(ra) # 80005dd6 <panic>
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
    80000610:	7ca080e7          	jalr	1994(ra) # 80005dd6 <panic>

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
    8000075c:	67e080e7          	jalr	1662(ra) # 80005dd6 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	66e080e7          	jalr	1646(ra) # 80005dd6 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	65e080e7          	jalr	1630(ra) # 80005dd6 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	64e080e7          	jalr	1614(ra) # 80005dd6 <panic>
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
    8000086a:	570080e7          	jalr	1392(ra) # 80005dd6 <panic>

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
    800009b6:	424080e7          	jalr	1060(ra) # 80005dd6 <panic>
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
    80000a94:	346080e7          	jalr	838(ra) # 80005dd6 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	336080e7          	jalr	822(ra) # 80005dd6 <panic>
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
    80000b0e:	2cc080e7          	jalr	716(ra) # 80005dd6 <panic>

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
    80000d42:	0e2080e7          	jalr	226(ra) # 80005e20 <printf>
    80000d46:	2485                	addiw	s1,s1,1
    80000d48:	fe9b1ae3          	bne	s6,s1,80000d3c <printwalk+0x60>
        printf("..%d: pte %p ", i, pte);
    80000d4c:	864a                	mv	a2,s2
    80000d4e:	85ce                	mv	a1,s3
    80000d50:	856a                	mv	a0,s10
    80000d52:	00005097          	auipc	ra,0x5
    80000d56:	0ce080e7          	jalr	206(ra) # 80005e20 <printf>
        uint64 child = PTE2PA(pte);
    80000d5a:	00a95493          	srli	s1,s2,0xa
    80000d5e:	04b2                	slli	s1,s1,0xc
        printf("pa %p\n", child);
    80000d60:	85a6                	mv	a1,s1
    80000d62:	8566                	mv	a0,s9
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	0bc080e7          	jalr	188(ra) # 80005e20 <printf>
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
    80000dbc:	068080e7          	jalr	104(ra) # 80005e20 <printf>
  printwalk(pt, 1);
    80000dc0:	4585                	li	a1,1
    80000dc2:	8526                	mv	a0,s1
    80000dc4:	00000097          	auipc	ra,0x0
    80000dc8:	f18080e7          	jalr	-232(ra) # 80000cdc <printwalk>
}
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
    80000e66:	f74080e7          	jalr	-140(ra) # 80005dd6 <panic>

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
    80000e92:	3f0080e7          	jalr	1008(ra) # 8000627e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e96:	00007597          	auipc	a1,0x7
    80000e9a:	30258593          	addi	a1,a1,770 # 80008198 <etext+0x198>
    80000e9e:	00008517          	auipc	a0,0x8
    80000ea2:	afa50513          	addi	a0,a0,-1286 # 80008998 <wait_lock>
    80000ea6:	00005097          	auipc	ra,0x5
    80000eaa:	3d8080e7          	jalr	984(ra) # 8000627e <initlock>
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
    80000ee0:	3a2080e7          	jalr	930(ra) # 8000627e <initlock>
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
    80000f56:	370080e7          	jalr	880(ra) # 800062c2 <push_off>
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
    80000f70:	3f6080e7          	jalr	1014(ra) # 80006362 <pop_off>
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
    80000f94:	432080e7          	jalr	1074(ra) # 800063c2 <release>

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
    80000fa6:	da6080e7          	jalr	-602(ra) # 80001d48 <usertrapret>
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
    80000fc0:	b38080e7          	jalr	-1224(ra) # 80002af4 <fsinit>
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
    80000fe0:	332080e7          	jalr	818(ra) # 8000630e <acquire>
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
    80000ffa:	3cc080e7          	jalr	972(ra) # 800063c2 <release>
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
    800011f8:	11a080e7          	jalr	282(ra) # 8000630e <acquire>
    if(p->state == UNUSED) {
    800011fc:	4c9c                	lw	a5,24(s1)
    800011fe:	cf81                	beqz	a5,80001216 <allocproc+0x40>
      release(&p->lock);
    80001200:	8526                	mv	a0,s1
    80001202:	00005097          	auipc	ra,0x5
    80001206:	1c0080e7          	jalr	448(ra) # 800063c2 <release>
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
    80001296:	130080e7          	jalr	304(ra) # 800063c2 <release>
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
    800012ae:	118080e7          	jalr	280(ra) # 800063c2 <release>
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
    800012c6:	100080e7          	jalr	256(ra) # 800063c2 <release>
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
    80001330:	1e6080e7          	jalr	486(ra) # 80003512 <namei>
    80001334:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001338:	478d                	li	a5,3
    8000133a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	084080e7          	jalr	132(ra) # 800063c2 <release>
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
    80001448:	f7e080e7          	jalr	-130(ra) # 800063c2 <release>
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
    80001460:	728080e7          	jalr	1832(ra) # 80003b84 <filedup>
    80001464:	00a93023          	sd	a0,0(s2)
    80001468:	b7e5                	j	80001450 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000146a:	158ab503          	ld	a0,344(s5)
    8000146e:	00002097          	auipc	ra,0x2
    80001472:	8c0080e7          	jalr	-1856(ra) # 80002d2e <idup>
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
    80001496:	f30080e7          	jalr	-208(ra) # 800063c2 <release>
  acquire(&wait_lock);
    8000149a:	00007497          	auipc	s1,0x7
    8000149e:	4fe48493          	addi	s1,s1,1278 # 80008998 <wait_lock>
    800014a2:	8526                	mv	a0,s1
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	e6a080e7          	jalr	-406(ra) # 8000630e <acquire>
  np->parent = p;
    800014ac:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014b0:	8526                	mv	a0,s1
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	f10080e7          	jalr	-240(ra) # 800063c2 <release>
  acquire(&np->lock);
    800014ba:	8552                	mv	a0,s4
    800014bc:	00005097          	auipc	ra,0x5
    800014c0:	e52080e7          	jalr	-430(ra) # 8000630e <acquire>
  np->state = RUNNABLE;
    800014c4:	478d                	li	a5,3
    800014c6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014ca:	8552                	mv	a0,s4
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	ef6080e7          	jalr	-266(ra) # 800063c2 <release>
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
    80001554:	e72080e7          	jalr	-398(ra) # 800063c2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001558:	17048493          	addi	s1,s1,368
    8000155c:	fd248ee3          	beq	s1,s2,80001538 <scheduler+0x4c>
      acquire(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	dac080e7          	jalr	-596(ra) # 8000630e <acquire>
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
    80001582:	720080e7          	jalr	1824(ra) # 80001c9e <swtch>
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
    800015a8:	cf0080e7          	jalr	-784(ra) # 80006294 <holding>
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
    80001604:	69e080e7          	jalr	1694(ra) # 80001c9e <swtch>
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
    8000162e:	7ac080e7          	jalr	1964(ra) # 80005dd6 <panic>
    panic("sched locks");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	ba650513          	addi	a0,a0,-1114 # 800081d8 <etext+0x1d8>
    8000163a:	00004097          	auipc	ra,0x4
    8000163e:	79c080e7          	jalr	1948(ra) # 80005dd6 <panic>
    panic("sched running");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	ba650513          	addi	a0,a0,-1114 # 800081e8 <etext+0x1e8>
    8000164a:	00004097          	auipc	ra,0x4
    8000164e:	78c080e7          	jalr	1932(ra) # 80005dd6 <panic>
    panic("sched interruptible");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	ba650513          	addi	a0,a0,-1114 # 800081f8 <etext+0x1f8>
    8000165a:	00004097          	auipc	ra,0x4
    8000165e:	77c080e7          	jalr	1916(ra) # 80005dd6 <panic>

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
    8000167a:	c98080e7          	jalr	-872(ra) # 8000630e <acquire>
  p->state = RUNNABLE;
    8000167e:	478d                	li	a5,3
    80001680:	cc9c                	sw	a5,24(s1)
  sched();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	f0a080e7          	jalr	-246(ra) # 8000158c <sched>
  release(&p->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	d36080e7          	jalr	-714(ra) # 800063c2 <release>
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
    800016be:	c54080e7          	jalr	-940(ra) # 8000630e <acquire>
  release(lk);
    800016c2:	854a                	mv	a0,s2
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	cfe080e7          	jalr	-770(ra) # 800063c2 <release>

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
    800016e6:	ce0080e7          	jalr	-800(ra) # 800063c2 <release>
  acquire(lk);
    800016ea:	854a                	mv	a0,s2
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	c22080e7          	jalr	-990(ra) # 8000630e <acquire>
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
    80001732:	c94080e7          	jalr	-876(ra) # 800063c2 <release>
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
    80001750:	bc2080e7          	jalr	-1086(ra) # 8000630e <acquire>
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
    8000180e:	5cc080e7          	jalr	1484(ra) # 80005dd6 <panic>
      fileclose(f);
    80001812:	00002097          	auipc	ra,0x2
    80001816:	3c4080e7          	jalr	964(ra) # 80003bd6 <fileclose>
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
    8000182e:	ee8080e7          	jalr	-280(ra) # 80003712 <begin_op>
  iput(p->cwd);
    80001832:	1589b503          	ld	a0,344(s3)
    80001836:	00001097          	auipc	ra,0x1
    8000183a:	6f0080e7          	jalr	1776(ra) # 80002f26 <iput>
  end_op();
    8000183e:	00002097          	auipc	ra,0x2
    80001842:	f4e080e7          	jalr	-178(ra) # 8000378c <end_op>
  p->cwd = 0;
    80001846:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000184a:	00007497          	auipc	s1,0x7
    8000184e:	14e48493          	addi	s1,s1,334 # 80008998 <wait_lock>
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	aba080e7          	jalr	-1350(ra) # 8000630e <acquire>
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
    80001878:	a9a080e7          	jalr	-1382(ra) # 8000630e <acquire>
  p->xstate = status;
    8000187c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001880:	4795                	li	a5,5
    80001882:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	b3a080e7          	jalr	-1222(ra) # 800063c2 <release>
  sched();
    80001890:	00000097          	auipc	ra,0x0
    80001894:	cfc080e7          	jalr	-772(ra) # 8000158c <sched>
  panic("zombie exit");
    80001898:	00007517          	auipc	a0,0x7
    8000189c:	98850513          	addi	a0,a0,-1656 # 80008220 <etext+0x220>
    800018a0:	00004097          	auipc	ra,0x4
    800018a4:	536080e7          	jalr	1334(ra) # 80005dd6 <panic>

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
    800018ce:	a44080e7          	jalr	-1468(ra) # 8000630e <acquire>
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
    800018de:	ae8080e7          	jalr	-1304(ra) # 800063c2 <release>
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
    80001900:	ac6080e7          	jalr	-1338(ra) # 800063c2 <release>
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
    8000192a:	9e8080e7          	jalr	-1560(ra) # 8000630e <acquire>
  p->killed = 1;
    8000192e:	4785                	li	a5,1
    80001930:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	a8e080e7          	jalr	-1394(ra) # 800063c2 <release>
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
    80001958:	9ba080e7          	jalr	-1606(ra) # 8000630e <acquire>
  k = p->killed;
    8000195c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001960:	8526                	mv	a0,s1
    80001962:	00005097          	auipc	ra,0x5
    80001966:	a60080e7          	jalr	-1440(ra) # 800063c2 <release>
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
    800019a8:	96a080e7          	jalr	-1686(ra) # 8000630e <acquire>
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
    800019f4:	9d2080e7          	jalr	-1582(ra) # 800063c2 <release>
          release(&wait_lock);
    800019f8:	00007517          	auipc	a0,0x7
    800019fc:	fa050513          	addi	a0,a0,-96 # 80008998 <wait_lock>
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	9c2080e7          	jalr	-1598(ra) # 800063c2 <release>
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
    80001a28:	99e080e7          	jalr	-1634(ra) # 800063c2 <release>
            release(&wait_lock);
    80001a2c:	00007517          	auipc	a0,0x7
    80001a30:	f6c50513          	addi	a0,a0,-148 # 80008998 <wait_lock>
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	98e080e7          	jalr	-1650(ra) # 800063c2 <release>
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
    80001a50:	00005097          	auipc	ra,0x5
    80001a54:	8be080e7          	jalr	-1858(ra) # 8000630e <acquire>
        if(pp->state == ZOMBIE){
    80001a58:	4c9c                	lw	a5,24(s1)
    80001a5a:	f74785e3          	beq	a5,s4,800019c4 <wait+0x4c>
        release(&pp->lock);
    80001a5e:	8526                	mv	a0,s1
    80001a60:	00005097          	auipc	ra,0x5
    80001a64:	962080e7          	jalr	-1694(ra) # 800063c2 <release>
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
    80001a9e:	928080e7          	jalr	-1752(ra) # 800063c2 <release>
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
    80001b74:	2b0080e7          	jalr	688(ra) # 80005e20 <printf>
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
    80001bb6:	26e080e7          	jalr	622(ra) # 80005e20 <printf>
    printf("\n");
    80001bba:	8552                	mv	a0,s4
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	264080e7          	jalr	612(ra) # 80005e20 <printf>
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

0000000080001c02 <pgaccess>:


int pgaccess(uint64 va, int n, uint64 access_abits){
    80001c02:	711d                	addi	sp,sp,-96
    80001c04:	ec86                	sd	ra,88(sp)
    80001c06:	e8a2                	sd	s0,80(sp)
    80001c08:	e4a6                	sd	s1,72(sp)
    80001c0a:	e0ca                	sd	s2,64(sp)
    80001c0c:	fc4e                	sd	s3,56(sp)
    80001c0e:	f852                	sd	s4,48(sp)
    80001c10:	f456                	sd	s5,40(sp)
    80001c12:	f05a                	sd	s6,32(sp)
    80001c14:	ec5e                	sd	s7,24(sp)
    80001c16:	1080                	addi	s0,sp,96
    80001c18:	84aa                	mv	s1,a0
    80001c1a:	8a2e                	mv	s4,a1
    80001c1c:	8b32                	mv	s6,a2
  struct proc *p = myproc();
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	32a080e7          	jalr	810(ra) # 80000f48 <myproc>
    80001c26:	89aa                	mv	s3,a0
  pte_t *pte;
  int i;
  unsigned int bitmasks = 0;
    80001c28:	fa042623          	sw	zero,-84(s0)
  for(i = 0; i < n; i++){
    80001c2c:	05405363          	blez	s4,80001c72 <pgaccess+0x70>
    80001c30:	4901                	li	s2,0
    pte = walk(p->pagetable, va + i * PGSIZE, 0);
    if(pte && (*pte && PTE_V) && (*pte & PTE_A)){
      *pte &= ~PTE_A;  //clear PTE_A
      bitmasks |= (1 << i);
    80001c32:	4b85                	li	s7,1
  for(i = 0; i < n; i++){
    80001c34:	6a85                	lui	s5,0x1
    80001c36:	a029                	j	80001c40 <pgaccess+0x3e>
    80001c38:	2905                	addiw	s2,s2,1
    80001c3a:	94d6                	add	s1,s1,s5
    80001c3c:	032a0b63          	beq	s4,s2,80001c72 <pgaccess+0x70>
    pte = walk(p->pagetable, va + i * PGSIZE, 0);
    80001c40:	4601                	li	a2,0
    80001c42:	85a6                	mv	a1,s1
    80001c44:	0509b503          	ld	a0,80(s3)
    80001c48:	fffff097          	auipc	ra,0xfffff
    80001c4c:	814080e7          	jalr	-2028(ra) # 8000045c <walk>
    if(pte && (*pte && PTE_V) && (*pte & PTE_A)){
    80001c50:	d565                	beqz	a0,80001c38 <pgaccess+0x36>
    80001c52:	611c                	ld	a5,0(a0)
    80001c54:	d3f5                	beqz	a5,80001c38 <pgaccess+0x36>
    80001c56:	0407f713          	andi	a4,a5,64
    80001c5a:	df79                	beqz	a4,80001c38 <pgaccess+0x36>
      *pte &= ~PTE_A;  //clear PTE_A
    80001c5c:	fbf7f793          	andi	a5,a5,-65
    80001c60:	e11c                	sd	a5,0(a0)
      bitmasks |= (1 << i);
    80001c62:	012b973b          	sllw	a4,s7,s2
    80001c66:	fac42783          	lw	a5,-84(s0)
    80001c6a:	8fd9                	or	a5,a5,a4
    80001c6c:	faf42623          	sw	a5,-84(s0)
    80001c70:	b7e1                	j	80001c38 <pgaccess+0x36>
    }
  }
  copyout(p->pagetable, access_abits, (char *)&bitmasks, sizeof(bitmasks));
    80001c72:	4691                	li	a3,4
    80001c74:	fac40613          	addi	a2,s0,-84
    80001c78:	85da                	mv	a1,s6
    80001c7a:	0509b503          	ld	a0,80(s3)
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	e94080e7          	jalr	-364(ra) # 80000b12 <copyout>
  return 0;
    80001c86:	4501                	li	a0,0
    80001c88:	60e6                	ld	ra,88(sp)
    80001c8a:	6446                	ld	s0,80(sp)
    80001c8c:	64a6                	ld	s1,72(sp)
    80001c8e:	6906                	ld	s2,64(sp)
    80001c90:	79e2                	ld	s3,56(sp)
    80001c92:	7a42                	ld	s4,48(sp)
    80001c94:	7aa2                	ld	s5,40(sp)
    80001c96:	7b02                	ld	s6,32(sp)
    80001c98:	6be2                	ld	s7,24(sp)
    80001c9a:	6125                	addi	sp,sp,96
    80001c9c:	8082                	ret

0000000080001c9e <swtch>:
    80001c9e:	00153023          	sd	ra,0(a0)
    80001ca2:	00253423          	sd	sp,8(a0)
    80001ca6:	e900                	sd	s0,16(a0)
    80001ca8:	ed04                	sd	s1,24(a0)
    80001caa:	03253023          	sd	s2,32(a0)
    80001cae:	03353423          	sd	s3,40(a0)
    80001cb2:	03453823          	sd	s4,48(a0)
    80001cb6:	03553c23          	sd	s5,56(a0)
    80001cba:	05653023          	sd	s6,64(a0)
    80001cbe:	05753423          	sd	s7,72(a0)
    80001cc2:	05853823          	sd	s8,80(a0)
    80001cc6:	05953c23          	sd	s9,88(a0)
    80001cca:	07a53023          	sd	s10,96(a0)
    80001cce:	07b53423          	sd	s11,104(a0)
    80001cd2:	0005b083          	ld	ra,0(a1)
    80001cd6:	0085b103          	ld	sp,8(a1)
    80001cda:	6980                	ld	s0,16(a1)
    80001cdc:	6d84                	ld	s1,24(a1)
    80001cde:	0205b903          	ld	s2,32(a1)
    80001ce2:	0285b983          	ld	s3,40(a1)
    80001ce6:	0305ba03          	ld	s4,48(a1)
    80001cea:	0385ba83          	ld	s5,56(a1)
    80001cee:	0405bb03          	ld	s6,64(a1)
    80001cf2:	0485bb83          	ld	s7,72(a1)
    80001cf6:	0505bc03          	ld	s8,80(a1)
    80001cfa:	0585bc83          	ld	s9,88(a1)
    80001cfe:	0605bd03          	ld	s10,96(a1)
    80001d02:	0685bd83          	ld	s11,104(a1)
    80001d06:	8082                	ret

0000000080001d08 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d08:	1141                	addi	sp,sp,-16
    80001d0a:	e406                	sd	ra,8(sp)
    80001d0c:	e022                	sd	s0,0(sp)
    80001d0e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d10:	00006597          	auipc	a1,0x6
    80001d14:	59858593          	addi	a1,a1,1432 # 800082a8 <states.0+0x30>
    80001d18:	0000d517          	auipc	a0,0xd
    80001d1c:	c9850513          	addi	a0,a0,-872 # 8000e9b0 <tickslock>
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	55e080e7          	jalr	1374(ra) # 8000627e <initlock>
}
    80001d28:	60a2                	ld	ra,8(sp)
    80001d2a:	6402                	ld	s0,0(sp)
    80001d2c:	0141                	addi	sp,sp,16
    80001d2e:	8082                	ret

0000000080001d30 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d30:	1141                	addi	sp,sp,-16
    80001d32:	e422                	sd	s0,8(sp)
    80001d34:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d36:	00003797          	auipc	a5,0x3
    80001d3a:	4da78793          	addi	a5,a5,1242 # 80005210 <kernelvec>
    80001d3e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d42:	6422                	ld	s0,8(sp)
    80001d44:	0141                	addi	sp,sp,16
    80001d46:	8082                	ret

0000000080001d48 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d48:	1141                	addi	sp,sp,-16
    80001d4a:	e406                	sd	ra,8(sp)
    80001d4c:	e022                	sd	s0,0(sp)
    80001d4e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	1f8080e7          	jalr	504(ra) # 80000f48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d5c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d62:	00005697          	auipc	a3,0x5
    80001d66:	29e68693          	addi	a3,a3,670 # 80007000 <_trampoline>
    80001d6a:	00005717          	auipc	a4,0x5
    80001d6e:	29670713          	addi	a4,a4,662 # 80007000 <_trampoline>
    80001d72:	8f15                	sub	a4,a4,a3
    80001d74:	040007b7          	lui	a5,0x4000
    80001d78:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d7a:	07b2                	slli	a5,a5,0xc
    80001d7c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d7e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d82:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d84:	18002673          	csrr	a2,satp
    80001d88:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d8a:	6d30                	ld	a2,88(a0)
    80001d8c:	6138                	ld	a4,64(a0)
    80001d8e:	6585                	lui	a1,0x1
    80001d90:	972e                	add	a4,a4,a1
    80001d92:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d94:	6d38                	ld	a4,88(a0)
    80001d96:	00000617          	auipc	a2,0x0
    80001d9a:	13460613          	addi	a2,a2,308 # 80001eca <usertrap>
    80001d9e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001da0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001da2:	8612                	mv	a2,tp
    80001da4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001daa:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dae:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001db6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001db8:	6f18                	ld	a4,24(a4)
    80001dba:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dbe:	6928                	ld	a0,80(a0)
    80001dc0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001dc2:	00005717          	auipc	a4,0x5
    80001dc6:	2da70713          	addi	a4,a4,730 # 8000709c <userret>
    80001dca:	8f15                	sub	a4,a4,a3
    80001dcc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dce:	577d                	li	a4,-1
    80001dd0:	177e                	slli	a4,a4,0x3f
    80001dd2:	8d59                	or	a0,a0,a4
    80001dd4:	9782                	jalr	a5
}
    80001dd6:	60a2                	ld	ra,8(sp)
    80001dd8:	6402                	ld	s0,0(sp)
    80001dda:	0141                	addi	sp,sp,16
    80001ddc:	8082                	ret

0000000080001dde <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dde:	1101                	addi	sp,sp,-32
    80001de0:	ec06                	sd	ra,24(sp)
    80001de2:	e822                	sd	s0,16(sp)
    80001de4:	e426                	sd	s1,8(sp)
    80001de6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001de8:	0000d497          	auipc	s1,0xd
    80001dec:	bc848493          	addi	s1,s1,-1080 # 8000e9b0 <tickslock>
    80001df0:	8526                	mv	a0,s1
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	51c080e7          	jalr	1308(ra) # 8000630e <acquire>
  ticks++;
    80001dfa:	00007517          	auipc	a0,0x7
    80001dfe:	b4e50513          	addi	a0,a0,-1202 # 80008948 <ticks>
    80001e02:	411c                	lw	a5,0(a0)
    80001e04:	2785                	addiw	a5,a5,1
    80001e06:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	8fa080e7          	jalr	-1798(ra) # 80001702 <wakeup>
  release(&tickslock);
    80001e10:	8526                	mv	a0,s1
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	5b0080e7          	jalr	1456(ra) # 800063c2 <release>
}
    80001e1a:	60e2                	ld	ra,24(sp)
    80001e1c:	6442                	ld	s0,16(sp)
    80001e1e:	64a2                	ld	s1,8(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret

0000000080001e24 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e24:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e28:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e2a:	0807df63          	bgez	a5,80001ec8 <devintr+0xa4>
{
    80001e2e:	1101                	addi	sp,sp,-32
    80001e30:	ec06                	sd	ra,24(sp)
    80001e32:	e822                	sd	s0,16(sp)
    80001e34:	e426                	sd	s1,8(sp)
    80001e36:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e38:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e3c:	46a5                	li	a3,9
    80001e3e:	00d70d63          	beq	a4,a3,80001e58 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001e42:	577d                	li	a4,-1
    80001e44:	177e                	slli	a4,a4,0x3f
    80001e46:	0705                	addi	a4,a4,1
    return 0;
    80001e48:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e4a:	04e78e63          	beq	a5,a4,80001ea6 <devintr+0x82>
  }
}
    80001e4e:	60e2                	ld	ra,24(sp)
    80001e50:	6442                	ld	s0,16(sp)
    80001e52:	64a2                	ld	s1,8(sp)
    80001e54:	6105                	addi	sp,sp,32
    80001e56:	8082                	ret
    int irq = plic_claim();
    80001e58:	00003097          	auipc	ra,0x3
    80001e5c:	4c0080e7          	jalr	1216(ra) # 80005318 <plic_claim>
    80001e60:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e62:	47a9                	li	a5,10
    80001e64:	02f50763          	beq	a0,a5,80001e92 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001e68:	4785                	li	a5,1
    80001e6a:	02f50963          	beq	a0,a5,80001e9c <devintr+0x78>
    return 1;
    80001e6e:	4505                	li	a0,1
    } else if(irq){
    80001e70:	dcf9                	beqz	s1,80001e4e <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e72:	85a6                	mv	a1,s1
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	43c50513          	addi	a0,a0,1084 # 800082b0 <states.0+0x38>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	fa4080e7          	jalr	-92(ra) # 80005e20 <printf>
      plic_complete(irq);
    80001e84:	8526                	mv	a0,s1
    80001e86:	00003097          	auipc	ra,0x3
    80001e8a:	4b6080e7          	jalr	1206(ra) # 8000533c <plic_complete>
    return 1;
    80001e8e:	4505                	li	a0,1
    80001e90:	bf7d                	j	80001e4e <devintr+0x2a>
      uartintr();
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	39c080e7          	jalr	924(ra) # 8000622e <uartintr>
    if(irq)
    80001e9a:	b7ed                	j	80001e84 <devintr+0x60>
      virtio_disk_intr();
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	966080e7          	jalr	-1690(ra) # 80005802 <virtio_disk_intr>
    if(irq)
    80001ea4:	b7c5                	j	80001e84 <devintr+0x60>
    if(cpuid() == 0){
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	076080e7          	jalr	118(ra) # 80000f1c <cpuid>
    80001eae:	c901                	beqz	a0,80001ebe <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eb0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001eb4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001eb6:	14479073          	csrw	sip,a5
    return 2;
    80001eba:	4509                	li	a0,2
    80001ebc:	bf49                	j	80001e4e <devintr+0x2a>
      clockintr();
    80001ebe:	00000097          	auipc	ra,0x0
    80001ec2:	f20080e7          	jalr	-224(ra) # 80001dde <clockintr>
    80001ec6:	b7ed                	j	80001eb0 <devintr+0x8c>
}
    80001ec8:	8082                	ret

0000000080001eca <usertrap>:
{
    80001eca:	1101                	addi	sp,sp,-32
    80001ecc:	ec06                	sd	ra,24(sp)
    80001ece:	e822                	sd	s0,16(sp)
    80001ed0:	e426                	sd	s1,8(sp)
    80001ed2:	e04a                	sd	s2,0(sp)
    80001ed4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001eda:	1007f793          	andi	a5,a5,256
    80001ede:	e3b1                	bnez	a5,80001f22 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ee0:	00003797          	auipc	a5,0x3
    80001ee4:	33078793          	addi	a5,a5,816 # 80005210 <kernelvec>
    80001ee8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	05c080e7          	jalr	92(ra) # 80000f48 <myproc>
    80001ef4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ef6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef8:	14102773          	csrr	a4,sepc
    80001efc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f02:	47a1                	li	a5,8
    80001f04:	02f70763          	beq	a4,a5,80001f32 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	f1c080e7          	jalr	-228(ra) # 80001e24 <devintr>
    80001f10:	892a                	mv	s2,a0
    80001f12:	c151                	beqz	a0,80001f96 <usertrap+0xcc>
  if(killed(p))
    80001f14:	8526                	mv	a0,s1
    80001f16:	00000097          	auipc	ra,0x0
    80001f1a:	a30080e7          	jalr	-1488(ra) # 80001946 <killed>
    80001f1e:	c929                	beqz	a0,80001f70 <usertrap+0xa6>
    80001f20:	a099                	j	80001f66 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	3ae50513          	addi	a0,a0,942 # 800082d0 <states.0+0x58>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	eac080e7          	jalr	-340(ra) # 80005dd6 <panic>
    if(killed(p))
    80001f32:	00000097          	auipc	ra,0x0
    80001f36:	a14080e7          	jalr	-1516(ra) # 80001946 <killed>
    80001f3a:	e921                	bnez	a0,80001f8a <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001f3c:	6cb8                	ld	a4,88(s1)
    80001f3e:	6f1c                	ld	a5,24(a4)
    80001f40:	0791                	addi	a5,a5,4
    80001f42:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f48:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f4c:	10079073          	csrw	sstatus,a5
    syscall();
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	2d4080e7          	jalr	724(ra) # 80002224 <syscall>
  if(killed(p))
    80001f58:	8526                	mv	a0,s1
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	9ec080e7          	jalr	-1556(ra) # 80001946 <killed>
    80001f62:	c911                	beqz	a0,80001f76 <usertrap+0xac>
    80001f64:	4901                	li	s2,0
    exit(-1);
    80001f66:	557d                	li	a0,-1
    80001f68:	00000097          	auipc	ra,0x0
    80001f6c:	86a080e7          	jalr	-1942(ra) # 800017d2 <exit>
  if(which_dev == 2)
    80001f70:	4789                	li	a5,2
    80001f72:	04f90f63          	beq	s2,a5,80001fd0 <usertrap+0x106>
  usertrapret();
    80001f76:	00000097          	auipc	ra,0x0
    80001f7a:	dd2080e7          	jalr	-558(ra) # 80001d48 <usertrapret>
}
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6902                	ld	s2,0(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret
      exit(-1);
    80001f8a:	557d                	li	a0,-1
    80001f8c:	00000097          	auipc	ra,0x0
    80001f90:	846080e7          	jalr	-1978(ra) # 800017d2 <exit>
    80001f94:	b765                	j	80001f3c <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f96:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f9a:	5890                	lw	a2,48(s1)
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	35450513          	addi	a0,a0,852 # 800082f0 <states.0+0x78>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	e7c080e7          	jalr	-388(ra) # 80005e20 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	36c50513          	addi	a0,a0,876 # 80008320 <states.0+0xa8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	e64080e7          	jalr	-412(ra) # 80005e20 <printf>
    setkilled(p);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	954080e7          	jalr	-1708(ra) # 8000191a <setkilled>
    80001fce:	b769                	j	80001f58 <usertrap+0x8e>
    yield();
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	692080e7          	jalr	1682(ra) # 80001662 <yield>
    80001fd8:	bf79                	j	80001f76 <usertrap+0xac>

0000000080001fda <kerneltrap>:
{
    80001fda:	7179                	addi	sp,sp,-48
    80001fdc:	f406                	sd	ra,40(sp)
    80001fde:	f022                	sd	s0,32(sp)
    80001fe0:	ec26                	sd	s1,24(sp)
    80001fe2:	e84a                	sd	s2,16(sp)
    80001fe4:	e44e                	sd	s3,8(sp)
    80001fe6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fe8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fec:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ff0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ff4:	1004f793          	andi	a5,s1,256
    80001ff8:	cb85                	beqz	a5,80002028 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ffa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ffe:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002000:	ef85                	bnez	a5,80002038 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002002:	00000097          	auipc	ra,0x0
    80002006:	e22080e7          	jalr	-478(ra) # 80001e24 <devintr>
    8000200a:	cd1d                	beqz	a0,80002048 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000200c:	4789                	li	a5,2
    8000200e:	06f50a63          	beq	a0,a5,80002082 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002012:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002016:	10049073          	csrw	sstatus,s1
}
    8000201a:	70a2                	ld	ra,40(sp)
    8000201c:	7402                	ld	s0,32(sp)
    8000201e:	64e2                	ld	s1,24(sp)
    80002020:	6942                	ld	s2,16(sp)
    80002022:	69a2                	ld	s3,8(sp)
    80002024:	6145                	addi	sp,sp,48
    80002026:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	31850513          	addi	a0,a0,792 # 80008340 <states.0+0xc8>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	da6080e7          	jalr	-602(ra) # 80005dd6 <panic>
    panic("kerneltrap: interrupts enabled");
    80002038:	00006517          	auipc	a0,0x6
    8000203c:	33050513          	addi	a0,a0,816 # 80008368 <states.0+0xf0>
    80002040:	00004097          	auipc	ra,0x4
    80002044:	d96080e7          	jalr	-618(ra) # 80005dd6 <panic>
    printf("scause %p\n", scause);
    80002048:	85ce                	mv	a1,s3
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	33e50513          	addi	a0,a0,830 # 80008388 <states.0+0x110>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	dce080e7          	jalr	-562(ra) # 80005e20 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000205a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000205e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002062:	00006517          	auipc	a0,0x6
    80002066:	33650513          	addi	a0,a0,822 # 80008398 <states.0+0x120>
    8000206a:	00004097          	auipc	ra,0x4
    8000206e:	db6080e7          	jalr	-586(ra) # 80005e20 <printf>
    panic("kerneltrap");
    80002072:	00006517          	auipc	a0,0x6
    80002076:	33e50513          	addi	a0,a0,830 # 800083b0 <states.0+0x138>
    8000207a:	00004097          	auipc	ra,0x4
    8000207e:	d5c080e7          	jalr	-676(ra) # 80005dd6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	ec6080e7          	jalr	-314(ra) # 80000f48 <myproc>
    8000208a:	d541                	beqz	a0,80002012 <kerneltrap+0x38>
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	ebc080e7          	jalr	-324(ra) # 80000f48 <myproc>
    80002094:	4d18                	lw	a4,24(a0)
    80002096:	4791                	li	a5,4
    80002098:	f6f71de3          	bne	a4,a5,80002012 <kerneltrap+0x38>
    yield();
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	5c6080e7          	jalr	1478(ra) # 80001662 <yield>
    800020a4:	b7bd                	j	80002012 <kerneltrap+0x38>

00000000800020a6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
    800020b0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	e96080e7          	jalr	-362(ra) # 80000f48 <myproc>
  switch (n) {
    800020ba:	4795                	li	a5,5
    800020bc:	0497e163          	bltu	a5,s1,800020fe <argraw+0x58>
    800020c0:	048a                	slli	s1,s1,0x2
    800020c2:	00006717          	auipc	a4,0x6
    800020c6:	32670713          	addi	a4,a4,806 # 800083e8 <states.0+0x170>
    800020ca:	94ba                	add	s1,s1,a4
    800020cc:	409c                	lw	a5,0(s1)
    800020ce:	97ba                	add	a5,a5,a4
    800020d0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020d2:	6d3c                	ld	a5,88(a0)
    800020d4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020d6:	60e2                	ld	ra,24(sp)
    800020d8:	6442                	ld	s0,16(sp)
    800020da:	64a2                	ld	s1,8(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret
    return p->trapframe->a1;
    800020e0:	6d3c                	ld	a5,88(a0)
    800020e2:	7fa8                	ld	a0,120(a5)
    800020e4:	bfcd                	j	800020d6 <argraw+0x30>
    return p->trapframe->a2;
    800020e6:	6d3c                	ld	a5,88(a0)
    800020e8:	63c8                	ld	a0,128(a5)
    800020ea:	b7f5                	j	800020d6 <argraw+0x30>
    return p->trapframe->a3;
    800020ec:	6d3c                	ld	a5,88(a0)
    800020ee:	67c8                	ld	a0,136(a5)
    800020f0:	b7dd                	j	800020d6 <argraw+0x30>
    return p->trapframe->a4;
    800020f2:	6d3c                	ld	a5,88(a0)
    800020f4:	6bc8                	ld	a0,144(a5)
    800020f6:	b7c5                	j	800020d6 <argraw+0x30>
    return p->trapframe->a5;
    800020f8:	6d3c                	ld	a5,88(a0)
    800020fa:	6fc8                	ld	a0,152(a5)
    800020fc:	bfe9                	j	800020d6 <argraw+0x30>
  panic("argraw");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	2c250513          	addi	a0,a0,706 # 800083c0 <states.0+0x148>
    80002106:	00004097          	auipc	ra,0x4
    8000210a:	cd0080e7          	jalr	-816(ra) # 80005dd6 <panic>

000000008000210e <fetchaddr>:
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	e04a                	sd	s2,0(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84aa                	mv	s1,a0
    8000211c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	e2a080e7          	jalr	-470(ra) # 80000f48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002126:	653c                	ld	a5,72(a0)
    80002128:	02f4f863          	bgeu	s1,a5,80002158 <fetchaddr+0x4a>
    8000212c:	00848713          	addi	a4,s1,8
    80002130:	02e7e663          	bltu	a5,a4,8000215c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002134:	46a1                	li	a3,8
    80002136:	8626                	mv	a2,s1
    80002138:	85ca                	mv	a1,s2
    8000213a:	6928                	ld	a0,80(a0)
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	a62080e7          	jalr	-1438(ra) # 80000b9e <copyin>
    80002144:	00a03533          	snez	a0,a0
    80002148:	40a00533          	neg	a0,a0
}
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	64a2                	ld	s1,8(sp)
    80002152:	6902                	ld	s2,0(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret
    return -1;
    80002158:	557d                	li	a0,-1
    8000215a:	bfcd                	j	8000214c <fetchaddr+0x3e>
    8000215c:	557d                	li	a0,-1
    8000215e:	b7fd                	j	8000214c <fetchaddr+0x3e>

0000000080002160 <fetchstr>:
{
    80002160:	7179                	addi	sp,sp,-48
    80002162:	f406                	sd	ra,40(sp)
    80002164:	f022                	sd	s0,32(sp)
    80002166:	ec26                	sd	s1,24(sp)
    80002168:	e84a                	sd	s2,16(sp)
    8000216a:	e44e                	sd	s3,8(sp)
    8000216c:	1800                	addi	s0,sp,48
    8000216e:	892a                	mv	s2,a0
    80002170:	84ae                	mv	s1,a1
    80002172:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	dd4080e7          	jalr	-556(ra) # 80000f48 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000217c:	86ce                	mv	a3,s3
    8000217e:	864a                	mv	a2,s2
    80002180:	85a6                	mv	a1,s1
    80002182:	6928                	ld	a0,80(a0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	aa8080e7          	jalr	-1368(ra) # 80000c2c <copyinstr>
    8000218c:	00054e63          	bltz	a0,800021a8 <fetchstr+0x48>
  return strlen(buf);
    80002190:	8526                	mv	a0,s1
    80002192:	ffffe097          	auipc	ra,0xffffe
    80002196:	162080e7          	jalr	354(ra) # 800002f4 <strlen>
}
    8000219a:	70a2                	ld	ra,40(sp)
    8000219c:	7402                	ld	s0,32(sp)
    8000219e:	64e2                	ld	s1,24(sp)
    800021a0:	6942                	ld	s2,16(sp)
    800021a2:	69a2                	ld	s3,8(sp)
    800021a4:	6145                	addi	sp,sp,48
    800021a6:	8082                	ret
    return -1;
    800021a8:	557d                	li	a0,-1
    800021aa:	bfc5                	j	8000219a <fetchstr+0x3a>

00000000800021ac <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	1000                	addi	s0,sp,32
    800021b6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	eee080e7          	jalr	-274(ra) # 800020a6 <argraw>
    800021c0:	c088                	sw	a0,0(s1)
}
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	64a2                	ld	s1,8(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret

00000000800021cc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	1000                	addi	s0,sp,32
    800021d6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	ece080e7          	jalr	-306(ra) # 800020a6 <argraw>
    800021e0:	e088                	sd	a0,0(s1)
}
    800021e2:	60e2                	ld	ra,24(sp)
    800021e4:	6442                	ld	s0,16(sp)
    800021e6:	64a2                	ld	s1,8(sp)
    800021e8:	6105                	addi	sp,sp,32
    800021ea:	8082                	ret

00000000800021ec <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021ec:	7179                	addi	sp,sp,-48
    800021ee:	f406                	sd	ra,40(sp)
    800021f0:	f022                	sd	s0,32(sp)
    800021f2:	ec26                	sd	s1,24(sp)
    800021f4:	e84a                	sd	s2,16(sp)
    800021f6:	1800                	addi	s0,sp,48
    800021f8:	84ae                	mv	s1,a1
    800021fa:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021fc:	fd840593          	addi	a1,s0,-40
    80002200:	00000097          	auipc	ra,0x0
    80002204:	fcc080e7          	jalr	-52(ra) # 800021cc <argaddr>
  return fetchstr(addr, buf, max);
    80002208:	864a                	mv	a2,s2
    8000220a:	85a6                	mv	a1,s1
    8000220c:	fd843503          	ld	a0,-40(s0)
    80002210:	00000097          	auipc	ra,0x0
    80002214:	f50080e7          	jalr	-176(ra) # 80002160 <fetchstr>
}
    80002218:	70a2                	ld	ra,40(sp)
    8000221a:	7402                	ld	s0,32(sp)
    8000221c:	64e2                	ld	s1,24(sp)
    8000221e:	6942                	ld	s2,16(sp)
    80002220:	6145                	addi	sp,sp,48
    80002222:	8082                	ret

0000000080002224 <syscall>:



void
syscall(void)
{
    80002224:	1101                	addi	sp,sp,-32
    80002226:	ec06                	sd	ra,24(sp)
    80002228:	e822                	sd	s0,16(sp)
    8000222a:	e426                	sd	s1,8(sp)
    8000222c:	e04a                	sd	s2,0(sp)
    8000222e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	d18080e7          	jalr	-744(ra) # 80000f48 <myproc>
    80002238:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000223a:	05853903          	ld	s2,88(a0)
    8000223e:	0a893783          	ld	a5,168(s2)
    80002242:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002246:	37fd                	addiw	a5,a5,-1
    80002248:	4775                	li	a4,29
    8000224a:	00f76f63          	bltu	a4,a5,80002268 <syscall+0x44>
    8000224e:	00369713          	slli	a4,a3,0x3
    80002252:	00006797          	auipc	a5,0x6
    80002256:	1ae78793          	addi	a5,a5,430 # 80008400 <syscalls>
    8000225a:	97ba                	add	a5,a5,a4
    8000225c:	639c                	ld	a5,0(a5)
    8000225e:	c789                	beqz	a5,80002268 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002260:	9782                	jalr	a5
    80002262:	06a93823          	sd	a0,112(s2)
    80002266:	a839                	j	80002284 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002268:	16048613          	addi	a2,s1,352
    8000226c:	588c                	lw	a1,48(s1)
    8000226e:	00006517          	auipc	a0,0x6
    80002272:	15a50513          	addi	a0,a0,346 # 800083c8 <states.0+0x150>
    80002276:	00004097          	auipc	ra,0x4
    8000227a:	baa080e7          	jalr	-1110(ra) # 80005e20 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000227e:	6cbc                	ld	a5,88(s1)
    80002280:	577d                	li	a4,-1
    80002282:	fbb8                	sd	a4,112(a5)
  }
}
    80002284:	60e2                	ld	ra,24(sp)
    80002286:	6442                	ld	s0,16(sp)
    80002288:	64a2                	ld	s1,8(sp)
    8000228a:	6902                	ld	s2,0(sp)
    8000228c:	6105                	addi	sp,sp,32
    8000228e:	8082                	ret

0000000080002290 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002290:	1101                	addi	sp,sp,-32
    80002292:	ec06                	sd	ra,24(sp)
    80002294:	e822                	sd	s0,16(sp)
    80002296:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002298:	fec40593          	addi	a1,s0,-20
    8000229c:	4501                	li	a0,0
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	f0e080e7          	jalr	-242(ra) # 800021ac <argint>
  exit(n);
    800022a6:	fec42503          	lw	a0,-20(s0)
    800022aa:	fffff097          	auipc	ra,0xfffff
    800022ae:	528080e7          	jalr	1320(ra) # 800017d2 <exit>
  return 0;  // not reached
}
    800022b2:	4501                	li	a0,0
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	6105                	addi	sp,sp,32
    800022ba:	8082                	ret

00000000800022bc <sys_getpid>:

uint64
sys_getpid(void)
{
    800022bc:	1141                	addi	sp,sp,-16
    800022be:	e406                	sd	ra,8(sp)
    800022c0:	e022                	sd	s0,0(sp)
    800022c2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	c84080e7          	jalr	-892(ra) # 80000f48 <myproc>
}
    800022cc:	5908                	lw	a0,48(a0)
    800022ce:	60a2                	ld	ra,8(sp)
    800022d0:	6402                	ld	s0,0(sp)
    800022d2:	0141                	addi	sp,sp,16
    800022d4:	8082                	ret

00000000800022d6 <sys_fork>:

uint64
sys_fork(void)
{
    800022d6:	1141                	addi	sp,sp,-16
    800022d8:	e406                	sd	ra,8(sp)
    800022da:	e022                	sd	s0,0(sp)
    800022dc:	0800                	addi	s0,sp,16
  return fork();
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	0ce080e7          	jalr	206(ra) # 800013ac <fork>
}
    800022e6:	60a2                	ld	ra,8(sp)
    800022e8:	6402                	ld	s0,0(sp)
    800022ea:	0141                	addi	sp,sp,16
    800022ec:	8082                	ret

00000000800022ee <sys_wait>:

uint64
sys_wait(void)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022f6:	fe840593          	addi	a1,s0,-24
    800022fa:	4501                	li	a0,0
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	ed0080e7          	jalr	-304(ra) # 800021cc <argaddr>
  return wait(p);
    80002304:	fe843503          	ld	a0,-24(s0)
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	670080e7          	jalr	1648(ra) # 80001978 <wait>
}
    80002310:	60e2                	ld	ra,24(sp)
    80002312:	6442                	ld	s0,16(sp)
    80002314:	6105                	addi	sp,sp,32
    80002316:	8082                	ret

0000000080002318 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002318:	7179                	addi	sp,sp,-48
    8000231a:	f406                	sd	ra,40(sp)
    8000231c:	f022                	sd	s0,32(sp)
    8000231e:	ec26                	sd	s1,24(sp)
    80002320:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002322:	fdc40593          	addi	a1,s0,-36
    80002326:	4501                	li	a0,0
    80002328:	00000097          	auipc	ra,0x0
    8000232c:	e84080e7          	jalr	-380(ra) # 800021ac <argint>
  addr = myproc()->sz;
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	c18080e7          	jalr	-1000(ra) # 80000f48 <myproc>
    80002338:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000233a:	fdc42503          	lw	a0,-36(s0)
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	012080e7          	jalr	18(ra) # 80001350 <growproc>
    80002346:	00054863          	bltz	a0,80002356 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000234a:	8526                	mv	a0,s1
    8000234c:	70a2                	ld	ra,40(sp)
    8000234e:	7402                	ld	s0,32(sp)
    80002350:	64e2                	ld	s1,24(sp)
    80002352:	6145                	addi	sp,sp,48
    80002354:	8082                	ret
    return -1;
    80002356:	54fd                	li	s1,-1
    80002358:	bfcd                	j	8000234a <sys_sbrk+0x32>

000000008000235a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000235a:	7139                	addi	sp,sp,-64
    8000235c:	fc06                	sd	ra,56(sp)
    8000235e:	f822                	sd	s0,48(sp)
    80002360:	f426                	sd	s1,40(sp)
    80002362:	f04a                	sd	s2,32(sp)
    80002364:	ec4e                	sd	s3,24(sp)
    80002366:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80002368:	fcc40593          	addi	a1,s0,-52
    8000236c:	4501                	li	a0,0
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	e3e080e7          	jalr	-450(ra) # 800021ac <argint>
  acquire(&tickslock);
    80002376:	0000c517          	auipc	a0,0xc
    8000237a:	63a50513          	addi	a0,a0,1594 # 8000e9b0 <tickslock>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	f90080e7          	jalr	-112(ra) # 8000630e <acquire>
  ticks0 = ticks;
    80002386:	00006917          	auipc	s2,0x6
    8000238a:	5c292903          	lw	s2,1474(s2) # 80008948 <ticks>
  while(ticks - ticks0 < n){
    8000238e:	fcc42783          	lw	a5,-52(s0)
    80002392:	cf9d                	beqz	a5,800023d0 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002394:	0000c997          	auipc	s3,0xc
    80002398:	61c98993          	addi	s3,s3,1564 # 8000e9b0 <tickslock>
    8000239c:	00006497          	auipc	s1,0x6
    800023a0:	5ac48493          	addi	s1,s1,1452 # 80008948 <ticks>
    if(killed(myproc())){
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	ba4080e7          	jalr	-1116(ra) # 80000f48 <myproc>
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	59a080e7          	jalr	1434(ra) # 80001946 <killed>
    800023b4:	ed15                	bnez	a0,800023f0 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800023b6:	85ce                	mv	a1,s3
    800023b8:	8526                	mv	a0,s1
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	2e4080e7          	jalr	740(ra) # 8000169e <sleep>
  while(ticks - ticks0 < n){
    800023c2:	409c                	lw	a5,0(s1)
    800023c4:	412787bb          	subw	a5,a5,s2
    800023c8:	fcc42703          	lw	a4,-52(s0)
    800023cc:	fce7ece3          	bltu	a5,a4,800023a4 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800023d0:	0000c517          	auipc	a0,0xc
    800023d4:	5e050513          	addi	a0,a0,1504 # 8000e9b0 <tickslock>
    800023d8:	00004097          	auipc	ra,0x4
    800023dc:	fea080e7          	jalr	-22(ra) # 800063c2 <release>
  return 0;
    800023e0:	4501                	li	a0,0
}
    800023e2:	70e2                	ld	ra,56(sp)
    800023e4:	7442                	ld	s0,48(sp)
    800023e6:	74a2                	ld	s1,40(sp)
    800023e8:	7902                	ld	s2,32(sp)
    800023ea:	69e2                	ld	s3,24(sp)
    800023ec:	6121                	addi	sp,sp,64
    800023ee:	8082                	ret
      release(&tickslock);
    800023f0:	0000c517          	auipc	a0,0xc
    800023f4:	5c050513          	addi	a0,a0,1472 # 8000e9b0 <tickslock>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	fca080e7          	jalr	-54(ra) # 800063c2 <release>
      return -1;
    80002400:	557d                	li	a0,-1
    80002402:	b7c5                	j	800023e2 <sys_sleep+0x88>

0000000080002404 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002404:	7179                	addi	sp,sp,-48
    80002406:	f406                	sd	ra,40(sp)
    80002408:	f022                	sd	s0,32(sp)
    8000240a:	1800                	addi	s0,sp,48
  uint64 va;
  int n;
  uint64 access_abits;
  argaddr(0, &va);
    8000240c:	fe840593          	addi	a1,s0,-24
    80002410:	4501                	li	a0,0
    80002412:	00000097          	auipc	ra,0x0
    80002416:	dba080e7          	jalr	-582(ra) # 800021cc <argaddr>
  argint(1, &n);
    8000241a:	fe440593          	addi	a1,s0,-28
    8000241e:	4505                	li	a0,1
    80002420:	00000097          	auipc	ra,0x0
    80002424:	d8c080e7          	jalr	-628(ra) # 800021ac <argint>
  argaddr(2, &access_abits);
    80002428:	fd840593          	addi	a1,s0,-40
    8000242c:	4509                	li	a0,2
    8000242e:	00000097          	auipc	ra,0x0
    80002432:	d9e080e7          	jalr	-610(ra) # 800021cc <argaddr>
  if(n <= 0 || n > 512)
    80002436:	fe442583          	lw	a1,-28(s0)
    8000243a:	fff5871b          	addiw	a4,a1,-1 # fff <_entry-0x7ffff001>
    8000243e:	1ff00793          	li	a5,511
    80002442:	00e7ee63          	bltu	a5,a4,8000245e <sys_pgaccess+0x5a>
    return -1;
  return pgaccess(va, n, access_abits); 
    80002446:	fd843603          	ld	a2,-40(s0)
    8000244a:	fe843503          	ld	a0,-24(s0)
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	7b4080e7          	jalr	1972(ra) # 80001c02 <pgaccess>
}
    80002456:	70a2                	ld	ra,40(sp)
    80002458:	7402                	ld	s0,32(sp)
    8000245a:	6145                	addi	sp,sp,48
    8000245c:	8082                	ret
    return -1;
    8000245e:	557d                	li	a0,-1
    80002460:	bfdd                	j	80002456 <sys_pgaccess+0x52>

0000000080002462 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002462:	1101                	addi	sp,sp,-32
    80002464:	ec06                	sd	ra,24(sp)
    80002466:	e822                	sd	s0,16(sp)
    80002468:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000246a:	fec40593          	addi	a1,s0,-20
    8000246e:	4501                	li	a0,0
    80002470:	00000097          	auipc	ra,0x0
    80002474:	d3c080e7          	jalr	-708(ra) # 800021ac <argint>
  return kill(pid);
    80002478:	fec42503          	lw	a0,-20(s0)
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	42c080e7          	jalr	1068(ra) # 800018a8 <kill>
}
    80002484:	60e2                	ld	ra,24(sp)
    80002486:	6442                	ld	s0,16(sp)
    80002488:	6105                	addi	sp,sp,32
    8000248a:	8082                	ret

000000008000248c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000248c:	1101                	addi	sp,sp,-32
    8000248e:	ec06                	sd	ra,24(sp)
    80002490:	e822                	sd	s0,16(sp)
    80002492:	e426                	sd	s1,8(sp)
    80002494:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002496:	0000c517          	auipc	a0,0xc
    8000249a:	51a50513          	addi	a0,a0,1306 # 8000e9b0 <tickslock>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	e70080e7          	jalr	-400(ra) # 8000630e <acquire>
  xticks = ticks;
    800024a6:	00006497          	auipc	s1,0x6
    800024aa:	4a24a483          	lw	s1,1186(s1) # 80008948 <ticks>
  release(&tickslock);
    800024ae:	0000c517          	auipc	a0,0xc
    800024b2:	50250513          	addi	a0,a0,1282 # 8000e9b0 <tickslock>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	f0c080e7          	jalr	-244(ra) # 800063c2 <release>
  return xticks;
}
    800024be:	02049513          	slli	a0,s1,0x20
    800024c2:	9101                	srli	a0,a0,0x20
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret

00000000800024ce <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024ce:	7179                	addi	sp,sp,-48
    800024d0:	f406                	sd	ra,40(sp)
    800024d2:	f022                	sd	s0,32(sp)
    800024d4:	ec26                	sd	s1,24(sp)
    800024d6:	e84a                	sd	s2,16(sp)
    800024d8:	e44e                	sd	s3,8(sp)
    800024da:	e052                	sd	s4,0(sp)
    800024dc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024de:	00006597          	auipc	a1,0x6
    800024e2:	01a58593          	addi	a1,a1,26 # 800084f8 <syscalls+0xf8>
    800024e6:	0000c517          	auipc	a0,0xc
    800024ea:	4e250513          	addi	a0,a0,1250 # 8000e9c8 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	d90080e7          	jalr	-624(ra) # 8000627e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024f6:	00014797          	auipc	a5,0x14
    800024fa:	4d278793          	addi	a5,a5,1234 # 800169c8 <bcache+0x8000>
    800024fe:	00014717          	auipc	a4,0x14
    80002502:	73270713          	addi	a4,a4,1842 # 80016c30 <bcache+0x8268>
    80002506:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000250a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000250e:	0000c497          	auipc	s1,0xc
    80002512:	4d248493          	addi	s1,s1,1234 # 8000e9e0 <bcache+0x18>
    b->next = bcache.head.next;
    80002516:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002518:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000251a:	00006a17          	auipc	s4,0x6
    8000251e:	fe6a0a13          	addi	s4,s4,-26 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    80002522:	2b893783          	ld	a5,696(s2)
    80002526:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002528:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000252c:	85d2                	mv	a1,s4
    8000252e:	01048513          	addi	a0,s1,16
    80002532:	00001097          	auipc	ra,0x1
    80002536:	496080e7          	jalr	1174(ra) # 800039c8 <initsleeplock>
    bcache.head.next->prev = b;
    8000253a:	2b893783          	ld	a5,696(s2)
    8000253e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002540:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002544:	45848493          	addi	s1,s1,1112
    80002548:	fd349de3          	bne	s1,s3,80002522 <binit+0x54>
  }
}
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6942                	ld	s2,16(sp)
    80002554:	69a2                	ld	s3,8(sp)
    80002556:	6a02                	ld	s4,0(sp)
    80002558:	6145                	addi	sp,sp,48
    8000255a:	8082                	ret

000000008000255c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000255c:	7179                	addi	sp,sp,-48
    8000255e:	f406                	sd	ra,40(sp)
    80002560:	f022                	sd	s0,32(sp)
    80002562:	ec26                	sd	s1,24(sp)
    80002564:	e84a                	sd	s2,16(sp)
    80002566:	e44e                	sd	s3,8(sp)
    80002568:	1800                	addi	s0,sp,48
    8000256a:	892a                	mv	s2,a0
    8000256c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000256e:	0000c517          	auipc	a0,0xc
    80002572:	45a50513          	addi	a0,a0,1114 # 8000e9c8 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	d98080e7          	jalr	-616(ra) # 8000630e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000257e:	00014497          	auipc	s1,0x14
    80002582:	7024b483          	ld	s1,1794(s1) # 80016c80 <bcache+0x82b8>
    80002586:	00014797          	auipc	a5,0x14
    8000258a:	6aa78793          	addi	a5,a5,1706 # 80016c30 <bcache+0x8268>
    8000258e:	02f48f63          	beq	s1,a5,800025cc <bread+0x70>
    80002592:	873e                	mv	a4,a5
    80002594:	a021                	j	8000259c <bread+0x40>
    80002596:	68a4                	ld	s1,80(s1)
    80002598:	02e48a63          	beq	s1,a4,800025cc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000259c:	449c                	lw	a5,8(s1)
    8000259e:	ff279ce3          	bne	a5,s2,80002596 <bread+0x3a>
    800025a2:	44dc                	lw	a5,12(s1)
    800025a4:	ff3799e3          	bne	a5,s3,80002596 <bread+0x3a>
      b->refcnt++;
    800025a8:	40bc                	lw	a5,64(s1)
    800025aa:	2785                	addiw	a5,a5,1
    800025ac:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ae:	0000c517          	auipc	a0,0xc
    800025b2:	41a50513          	addi	a0,a0,1050 # 8000e9c8 <bcache>
    800025b6:	00004097          	auipc	ra,0x4
    800025ba:	e0c080e7          	jalr	-500(ra) # 800063c2 <release>
      acquiresleep(&b->lock);
    800025be:	01048513          	addi	a0,s1,16
    800025c2:	00001097          	auipc	ra,0x1
    800025c6:	440080e7          	jalr	1088(ra) # 80003a02 <acquiresleep>
      return b;
    800025ca:	a8b9                	j	80002628 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025cc:	00014497          	auipc	s1,0x14
    800025d0:	6ac4b483          	ld	s1,1708(s1) # 80016c78 <bcache+0x82b0>
    800025d4:	00014797          	auipc	a5,0x14
    800025d8:	65c78793          	addi	a5,a5,1628 # 80016c30 <bcache+0x8268>
    800025dc:	00f48863          	beq	s1,a5,800025ec <bread+0x90>
    800025e0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	cf81                	beqz	a5,800025fc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e6:	64a4                	ld	s1,72(s1)
    800025e8:	fee49de3          	bne	s1,a4,800025e2 <bread+0x86>
  panic("bget: no buffers");
    800025ec:	00006517          	auipc	a0,0x6
    800025f0:	f1c50513          	addi	a0,a0,-228 # 80008508 <syscalls+0x108>
    800025f4:	00003097          	auipc	ra,0x3
    800025f8:	7e2080e7          	jalr	2018(ra) # 80005dd6 <panic>
      b->dev = dev;
    800025fc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002600:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002604:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002608:	4785                	li	a5,1
    8000260a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000260c:	0000c517          	auipc	a0,0xc
    80002610:	3bc50513          	addi	a0,a0,956 # 8000e9c8 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	dae080e7          	jalr	-594(ra) # 800063c2 <release>
      acquiresleep(&b->lock);
    8000261c:	01048513          	addi	a0,s1,16
    80002620:	00001097          	auipc	ra,0x1
    80002624:	3e2080e7          	jalr	994(ra) # 80003a02 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002628:	409c                	lw	a5,0(s1)
    8000262a:	cb89                	beqz	a5,8000263c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000262c:	8526                	mv	a0,s1
    8000262e:	70a2                	ld	ra,40(sp)
    80002630:	7402                	ld	s0,32(sp)
    80002632:	64e2                	ld	s1,24(sp)
    80002634:	6942                	ld	s2,16(sp)
    80002636:	69a2                	ld	s3,8(sp)
    80002638:	6145                	addi	sp,sp,48
    8000263a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000263c:	4581                	li	a1,0
    8000263e:	8526                	mv	a0,s1
    80002640:	00003097          	auipc	ra,0x3
    80002644:	f92080e7          	jalr	-110(ra) # 800055d2 <virtio_disk_rw>
    b->valid = 1;
    80002648:	4785                	li	a5,1
    8000264a:	c09c                	sw	a5,0(s1)
  return b;
    8000264c:	b7c5                	j	8000262c <bread+0xd0>

000000008000264e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000264e:	1101                	addi	sp,sp,-32
    80002650:	ec06                	sd	ra,24(sp)
    80002652:	e822                	sd	s0,16(sp)
    80002654:	e426                	sd	s1,8(sp)
    80002656:	1000                	addi	s0,sp,32
    80002658:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000265a:	0541                	addi	a0,a0,16
    8000265c:	00001097          	auipc	ra,0x1
    80002660:	440080e7          	jalr	1088(ra) # 80003a9c <holdingsleep>
    80002664:	cd01                	beqz	a0,8000267c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002666:	4585                	li	a1,1
    80002668:	8526                	mv	a0,s1
    8000266a:	00003097          	auipc	ra,0x3
    8000266e:	f68080e7          	jalr	-152(ra) # 800055d2 <virtio_disk_rw>
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6105                	addi	sp,sp,32
    8000267a:	8082                	ret
    panic("bwrite");
    8000267c:	00006517          	auipc	a0,0x6
    80002680:	ea450513          	addi	a0,a0,-348 # 80008520 <syscalls+0x120>
    80002684:	00003097          	auipc	ra,0x3
    80002688:	752080e7          	jalr	1874(ra) # 80005dd6 <panic>

000000008000268c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000268c:	1101                	addi	sp,sp,-32
    8000268e:	ec06                	sd	ra,24(sp)
    80002690:	e822                	sd	s0,16(sp)
    80002692:	e426                	sd	s1,8(sp)
    80002694:	e04a                	sd	s2,0(sp)
    80002696:	1000                	addi	s0,sp,32
    80002698:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269a:	01050913          	addi	s2,a0,16
    8000269e:	854a                	mv	a0,s2
    800026a0:	00001097          	auipc	ra,0x1
    800026a4:	3fc080e7          	jalr	1020(ra) # 80003a9c <holdingsleep>
    800026a8:	c925                	beqz	a0,80002718 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800026aa:	854a                	mv	a0,s2
    800026ac:	00001097          	auipc	ra,0x1
    800026b0:	3ac080e7          	jalr	940(ra) # 80003a58 <releasesleep>

  acquire(&bcache.lock);
    800026b4:	0000c517          	auipc	a0,0xc
    800026b8:	31450513          	addi	a0,a0,788 # 8000e9c8 <bcache>
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	c52080e7          	jalr	-942(ra) # 8000630e <acquire>
  b->refcnt--;
    800026c4:	40bc                	lw	a5,64(s1)
    800026c6:	37fd                	addiw	a5,a5,-1
    800026c8:	0007871b          	sext.w	a4,a5
    800026cc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026ce:	e71d                	bnez	a4,800026fc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026d0:	68b8                	ld	a4,80(s1)
    800026d2:	64bc                	ld	a5,72(s1)
    800026d4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026d6:	68b8                	ld	a4,80(s1)
    800026d8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026da:	00014797          	auipc	a5,0x14
    800026de:	2ee78793          	addi	a5,a5,750 # 800169c8 <bcache+0x8000>
    800026e2:	2b87b703          	ld	a4,696(a5)
    800026e6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026e8:	00014717          	auipc	a4,0x14
    800026ec:	54870713          	addi	a4,a4,1352 # 80016c30 <bcache+0x8268>
    800026f0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026f2:	2b87b703          	ld	a4,696(a5)
    800026f6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026f8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026fc:	0000c517          	auipc	a0,0xc
    80002700:	2cc50513          	addi	a0,a0,716 # 8000e9c8 <bcache>
    80002704:	00004097          	auipc	ra,0x4
    80002708:	cbe080e7          	jalr	-834(ra) # 800063c2 <release>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6902                	ld	s2,0(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    panic("brelse");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	e1050513          	addi	a0,a0,-496 # 80008528 <syscalls+0x128>
    80002720:	00003097          	auipc	ra,0x3
    80002724:	6b6080e7          	jalr	1718(ra) # 80005dd6 <panic>

0000000080002728 <bpin>:

void
bpin(struct buf *b) {
    80002728:	1101                	addi	sp,sp,-32
    8000272a:	ec06                	sd	ra,24(sp)
    8000272c:	e822                	sd	s0,16(sp)
    8000272e:	e426                	sd	s1,8(sp)
    80002730:	1000                	addi	s0,sp,32
    80002732:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002734:	0000c517          	auipc	a0,0xc
    80002738:	29450513          	addi	a0,a0,660 # 8000e9c8 <bcache>
    8000273c:	00004097          	auipc	ra,0x4
    80002740:	bd2080e7          	jalr	-1070(ra) # 8000630e <acquire>
  b->refcnt++;
    80002744:	40bc                	lw	a5,64(s1)
    80002746:	2785                	addiw	a5,a5,1
    80002748:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000274a:	0000c517          	auipc	a0,0xc
    8000274e:	27e50513          	addi	a0,a0,638 # 8000e9c8 <bcache>
    80002752:	00004097          	auipc	ra,0x4
    80002756:	c70080e7          	jalr	-912(ra) # 800063c2 <release>
}
    8000275a:	60e2                	ld	ra,24(sp)
    8000275c:	6442                	ld	s0,16(sp)
    8000275e:	64a2                	ld	s1,8(sp)
    80002760:	6105                	addi	sp,sp,32
    80002762:	8082                	ret

0000000080002764 <bunpin>:

void
bunpin(struct buf *b) {
    80002764:	1101                	addi	sp,sp,-32
    80002766:	ec06                	sd	ra,24(sp)
    80002768:	e822                	sd	s0,16(sp)
    8000276a:	e426                	sd	s1,8(sp)
    8000276c:	1000                	addi	s0,sp,32
    8000276e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002770:	0000c517          	auipc	a0,0xc
    80002774:	25850513          	addi	a0,a0,600 # 8000e9c8 <bcache>
    80002778:	00004097          	auipc	ra,0x4
    8000277c:	b96080e7          	jalr	-1130(ra) # 8000630e <acquire>
  b->refcnt--;
    80002780:	40bc                	lw	a5,64(s1)
    80002782:	37fd                	addiw	a5,a5,-1
    80002784:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002786:	0000c517          	auipc	a0,0xc
    8000278a:	24250513          	addi	a0,a0,578 # 8000e9c8 <bcache>
    8000278e:	00004097          	auipc	ra,0x4
    80002792:	c34080e7          	jalr	-972(ra) # 800063c2 <release>
}
    80002796:	60e2                	ld	ra,24(sp)
    80002798:	6442                	ld	s0,16(sp)
    8000279a:	64a2                	ld	s1,8(sp)
    8000279c:	6105                	addi	sp,sp,32
    8000279e:	8082                	ret

00000000800027a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027a0:	1101                	addi	sp,sp,-32
    800027a2:	ec06                	sd	ra,24(sp)
    800027a4:	e822                	sd	s0,16(sp)
    800027a6:	e426                	sd	s1,8(sp)
    800027a8:	e04a                	sd	s2,0(sp)
    800027aa:	1000                	addi	s0,sp,32
    800027ac:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027ae:	00d5d59b          	srliw	a1,a1,0xd
    800027b2:	00015797          	auipc	a5,0x15
    800027b6:	8f27a783          	lw	a5,-1806(a5) # 800170a4 <sb+0x1c>
    800027ba:	9dbd                	addw	a1,a1,a5
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	da0080e7          	jalr	-608(ra) # 8000255c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027c4:	0074f713          	andi	a4,s1,7
    800027c8:	4785                	li	a5,1
    800027ca:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027ce:	14ce                	slli	s1,s1,0x33
    800027d0:	90d9                	srli	s1,s1,0x36
    800027d2:	00950733          	add	a4,a0,s1
    800027d6:	05874703          	lbu	a4,88(a4)
    800027da:	00e7f6b3          	and	a3,a5,a4
    800027de:	c69d                	beqz	a3,8000280c <bfree+0x6c>
    800027e0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027e2:	94aa                	add	s1,s1,a0
    800027e4:	fff7c793          	not	a5,a5
    800027e8:	8f7d                	and	a4,a4,a5
    800027ea:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027ee:	00001097          	auipc	ra,0x1
    800027f2:	0f6080e7          	jalr	246(ra) # 800038e4 <log_write>
  brelse(bp);
    800027f6:	854a                	mv	a0,s2
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	e94080e7          	jalr	-364(ra) # 8000268c <brelse>
}
    80002800:	60e2                	ld	ra,24(sp)
    80002802:	6442                	ld	s0,16(sp)
    80002804:	64a2                	ld	s1,8(sp)
    80002806:	6902                	ld	s2,0(sp)
    80002808:	6105                	addi	sp,sp,32
    8000280a:	8082                	ret
    panic("freeing free block");
    8000280c:	00006517          	auipc	a0,0x6
    80002810:	d2450513          	addi	a0,a0,-732 # 80008530 <syscalls+0x130>
    80002814:	00003097          	auipc	ra,0x3
    80002818:	5c2080e7          	jalr	1474(ra) # 80005dd6 <panic>

000000008000281c <balloc>:
{
    8000281c:	711d                	addi	sp,sp,-96
    8000281e:	ec86                	sd	ra,88(sp)
    80002820:	e8a2                	sd	s0,80(sp)
    80002822:	e4a6                	sd	s1,72(sp)
    80002824:	e0ca                	sd	s2,64(sp)
    80002826:	fc4e                	sd	s3,56(sp)
    80002828:	f852                	sd	s4,48(sp)
    8000282a:	f456                	sd	s5,40(sp)
    8000282c:	f05a                	sd	s6,32(sp)
    8000282e:	ec5e                	sd	s7,24(sp)
    80002830:	e862                	sd	s8,16(sp)
    80002832:	e466                	sd	s9,8(sp)
    80002834:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002836:	00015797          	auipc	a5,0x15
    8000283a:	8567a783          	lw	a5,-1962(a5) # 8001708c <sb+0x4>
    8000283e:	cff5                	beqz	a5,8000293a <balloc+0x11e>
    80002840:	8baa                	mv	s7,a0
    80002842:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002844:	00015b17          	auipc	s6,0x15
    80002848:	844b0b13          	addi	s6,s6,-1980 # 80017088 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000284e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002850:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002852:	6c89                	lui	s9,0x2
    80002854:	a061                	j	800028dc <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002856:	97ca                	add	a5,a5,s2
    80002858:	8e55                	or	a2,a2,a3
    8000285a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000285e:	854a                	mv	a0,s2
    80002860:	00001097          	auipc	ra,0x1
    80002864:	084080e7          	jalr	132(ra) # 800038e4 <log_write>
        brelse(bp);
    80002868:	854a                	mv	a0,s2
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	e22080e7          	jalr	-478(ra) # 8000268c <brelse>
  bp = bread(dev, bno);
    80002872:	85a6                	mv	a1,s1
    80002874:	855e                	mv	a0,s7
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	ce6080e7          	jalr	-794(ra) # 8000255c <bread>
    8000287e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002880:	40000613          	li	a2,1024
    80002884:	4581                	li	a1,0
    80002886:	05850513          	addi	a0,a0,88
    8000288a:	ffffe097          	auipc	ra,0xffffe
    8000288e:	8f0080e7          	jalr	-1808(ra) # 8000017a <memset>
  log_write(bp);
    80002892:	854a                	mv	a0,s2
    80002894:	00001097          	auipc	ra,0x1
    80002898:	050080e7          	jalr	80(ra) # 800038e4 <log_write>
  brelse(bp);
    8000289c:	854a                	mv	a0,s2
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	dee080e7          	jalr	-530(ra) # 8000268c <brelse>
}
    800028a6:	8526                	mv	a0,s1
    800028a8:	60e6                	ld	ra,88(sp)
    800028aa:	6446                	ld	s0,80(sp)
    800028ac:	64a6                	ld	s1,72(sp)
    800028ae:	6906                	ld	s2,64(sp)
    800028b0:	79e2                	ld	s3,56(sp)
    800028b2:	7a42                	ld	s4,48(sp)
    800028b4:	7aa2                	ld	s5,40(sp)
    800028b6:	7b02                	ld	s6,32(sp)
    800028b8:	6be2                	ld	s7,24(sp)
    800028ba:	6c42                	ld	s8,16(sp)
    800028bc:	6ca2                	ld	s9,8(sp)
    800028be:	6125                	addi	sp,sp,96
    800028c0:	8082                	ret
    brelse(bp);
    800028c2:	854a                	mv	a0,s2
    800028c4:	00000097          	auipc	ra,0x0
    800028c8:	dc8080e7          	jalr	-568(ra) # 8000268c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028cc:	015c87bb          	addw	a5,s9,s5
    800028d0:	00078a9b          	sext.w	s5,a5
    800028d4:	004b2703          	lw	a4,4(s6)
    800028d8:	06eaf163          	bgeu	s5,a4,8000293a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800028dc:	41fad79b          	sraiw	a5,s5,0x1f
    800028e0:	0137d79b          	srliw	a5,a5,0x13
    800028e4:	015787bb          	addw	a5,a5,s5
    800028e8:	40d7d79b          	sraiw	a5,a5,0xd
    800028ec:	01cb2583          	lw	a1,28(s6)
    800028f0:	9dbd                	addw	a1,a1,a5
    800028f2:	855e                	mv	a0,s7
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	c68080e7          	jalr	-920(ra) # 8000255c <bread>
    800028fc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028fe:	004b2503          	lw	a0,4(s6)
    80002902:	000a849b          	sext.w	s1,s5
    80002906:	8762                	mv	a4,s8
    80002908:	faa4fde3          	bgeu	s1,a0,800028c2 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000290c:	00777693          	andi	a3,a4,7
    80002910:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002914:	41f7579b          	sraiw	a5,a4,0x1f
    80002918:	01d7d79b          	srliw	a5,a5,0x1d
    8000291c:	9fb9                	addw	a5,a5,a4
    8000291e:	4037d79b          	sraiw	a5,a5,0x3
    80002922:	00f90633          	add	a2,s2,a5
    80002926:	05864603          	lbu	a2,88(a2)
    8000292a:	00c6f5b3          	and	a1,a3,a2
    8000292e:	d585                	beqz	a1,80002856 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002930:	2705                	addiw	a4,a4,1
    80002932:	2485                	addiw	s1,s1,1
    80002934:	fd471ae3          	bne	a4,s4,80002908 <balloc+0xec>
    80002938:	b769                	j	800028c2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	c0e50513          	addi	a0,a0,-1010 # 80008548 <syscalls+0x148>
    80002942:	00003097          	auipc	ra,0x3
    80002946:	4de080e7          	jalr	1246(ra) # 80005e20 <printf>
  return 0;
    8000294a:	4481                	li	s1,0
    8000294c:	bfa9                	j	800028a6 <balloc+0x8a>

000000008000294e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000294e:	7179                	addi	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	e84a                	sd	s2,16(sp)
    80002958:	e44e                	sd	s3,8(sp)
    8000295a:	e052                	sd	s4,0(sp)
    8000295c:	1800                	addi	s0,sp,48
    8000295e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002960:	47ad                	li	a5,11
    80002962:	02b7e863          	bltu	a5,a1,80002992 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002966:	02059793          	slli	a5,a1,0x20
    8000296a:	01e7d593          	srli	a1,a5,0x1e
    8000296e:	00b504b3          	add	s1,a0,a1
    80002972:	0504a903          	lw	s2,80(s1)
    80002976:	06091e63          	bnez	s2,800029f2 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000297a:	4108                	lw	a0,0(a0)
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	ea0080e7          	jalr	-352(ra) # 8000281c <balloc>
    80002984:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002988:	06090563          	beqz	s2,800029f2 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000298c:	0524a823          	sw	s2,80(s1)
    80002990:	a08d                	j	800029f2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002992:	ff45849b          	addiw	s1,a1,-12
    80002996:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000299a:	0ff00793          	li	a5,255
    8000299e:	08e7e563          	bltu	a5,a4,80002a28 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029a2:	08052903          	lw	s2,128(a0)
    800029a6:	00091d63          	bnez	s2,800029c0 <bmap+0x72>
      addr = balloc(ip->dev);
    800029aa:	4108                	lw	a0,0(a0)
    800029ac:	00000097          	auipc	ra,0x0
    800029b0:	e70080e7          	jalr	-400(ra) # 8000281c <balloc>
    800029b4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029b8:	02090d63          	beqz	s2,800029f2 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029bc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029c0:	85ca                	mv	a1,s2
    800029c2:	0009a503          	lw	a0,0(s3)
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	b96080e7          	jalr	-1130(ra) # 8000255c <bread>
    800029ce:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029d0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029d4:	02049713          	slli	a4,s1,0x20
    800029d8:	01e75593          	srli	a1,a4,0x1e
    800029dc:	00b784b3          	add	s1,a5,a1
    800029e0:	0004a903          	lw	s2,0(s1)
    800029e4:	02090063          	beqz	s2,80002a04 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029e8:	8552                	mv	a0,s4
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	ca2080e7          	jalr	-862(ra) # 8000268c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029f2:	854a                	mv	a0,s2
    800029f4:	70a2                	ld	ra,40(sp)
    800029f6:	7402                	ld	s0,32(sp)
    800029f8:	64e2                	ld	s1,24(sp)
    800029fa:	6942                	ld	s2,16(sp)
    800029fc:	69a2                	ld	s3,8(sp)
    800029fe:	6a02                	ld	s4,0(sp)
    80002a00:	6145                	addi	sp,sp,48
    80002a02:	8082                	ret
      addr = balloc(ip->dev);
    80002a04:	0009a503          	lw	a0,0(s3)
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	e14080e7          	jalr	-492(ra) # 8000281c <balloc>
    80002a10:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a14:	fc090ae3          	beqz	s2,800029e8 <bmap+0x9a>
        a[bn] = addr;
    80002a18:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a1c:	8552                	mv	a0,s4
    80002a1e:	00001097          	auipc	ra,0x1
    80002a22:	ec6080e7          	jalr	-314(ra) # 800038e4 <log_write>
    80002a26:	b7c9                	j	800029e8 <bmap+0x9a>
  panic("bmap: out of range");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	b3850513          	addi	a0,a0,-1224 # 80008560 <syscalls+0x160>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	3a6080e7          	jalr	934(ra) # 80005dd6 <panic>

0000000080002a38 <iget>:
{
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	e052                	sd	s4,0(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	89aa                	mv	s3,a0
    80002a4a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a4c:	00014517          	auipc	a0,0x14
    80002a50:	65c50513          	addi	a0,a0,1628 # 800170a8 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	8ba080e7          	jalr	-1862(ra) # 8000630e <acquire>
  empty = 0;
    80002a5c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5e:	00014497          	auipc	s1,0x14
    80002a62:	66248493          	addi	s1,s1,1634 # 800170c0 <itable+0x18>
    80002a66:	00016697          	auipc	a3,0x16
    80002a6a:	0ea68693          	addi	a3,a3,234 # 80018b50 <log>
    80002a6e:	a039                	j	80002a7c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a70:	02090b63          	beqz	s2,80002aa6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a74:	08848493          	addi	s1,s1,136
    80002a78:	02d48a63          	beq	s1,a3,80002aac <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a7c:	449c                	lw	a5,8(s1)
    80002a7e:	fef059e3          	blez	a5,80002a70 <iget+0x38>
    80002a82:	4098                	lw	a4,0(s1)
    80002a84:	ff3716e3          	bne	a4,s3,80002a70 <iget+0x38>
    80002a88:	40d8                	lw	a4,4(s1)
    80002a8a:	ff4713e3          	bne	a4,s4,80002a70 <iget+0x38>
      ip->ref++;
    80002a8e:	2785                	addiw	a5,a5,1
    80002a90:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a92:	00014517          	auipc	a0,0x14
    80002a96:	61650513          	addi	a0,a0,1558 # 800170a8 <itable>
    80002a9a:	00004097          	auipc	ra,0x4
    80002a9e:	928080e7          	jalr	-1752(ra) # 800063c2 <release>
      return ip;
    80002aa2:	8926                	mv	s2,s1
    80002aa4:	a03d                	j	80002ad2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa6:	f7f9                	bnez	a5,80002a74 <iget+0x3c>
    80002aa8:	8926                	mv	s2,s1
    80002aaa:	b7e9                	j	80002a74 <iget+0x3c>
  if(empty == 0)
    80002aac:	02090c63          	beqz	s2,80002ae4 <iget+0xac>
  ip->dev = dev;
    80002ab0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ab8:	4785                	li	a5,1
    80002aba:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002abe:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ac2:	00014517          	auipc	a0,0x14
    80002ac6:	5e650513          	addi	a0,a0,1510 # 800170a8 <itable>
    80002aca:	00004097          	auipc	ra,0x4
    80002ace:	8f8080e7          	jalr	-1800(ra) # 800063c2 <release>
}
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	70a2                	ld	ra,40(sp)
    80002ad6:	7402                	ld	s0,32(sp)
    80002ad8:	64e2                	ld	s1,24(sp)
    80002ada:	6942                	ld	s2,16(sp)
    80002adc:	69a2                	ld	s3,8(sp)
    80002ade:	6a02                	ld	s4,0(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    panic("iget: no inodes");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	a9450513          	addi	a0,a0,-1388 # 80008578 <syscalls+0x178>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	2ea080e7          	jalr	746(ra) # 80005dd6 <panic>

0000000080002af4 <fsinit>:
fsinit(int dev) {
    80002af4:	7179                	addi	sp,sp,-48
    80002af6:	f406                	sd	ra,40(sp)
    80002af8:	f022                	sd	s0,32(sp)
    80002afa:	ec26                	sd	s1,24(sp)
    80002afc:	e84a                	sd	s2,16(sp)
    80002afe:	e44e                	sd	s3,8(sp)
    80002b00:	1800                	addi	s0,sp,48
    80002b02:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b04:	4585                	li	a1,1
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	a56080e7          	jalr	-1450(ra) # 8000255c <bread>
    80002b0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b10:	00014997          	auipc	s3,0x14
    80002b14:	57898993          	addi	s3,s3,1400 # 80017088 <sb>
    80002b18:	02000613          	li	a2,32
    80002b1c:	05850593          	addi	a1,a0,88
    80002b20:	854e                	mv	a0,s3
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	6b4080e7          	jalr	1716(ra) # 800001d6 <memmove>
  brelse(bp);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	b60080e7          	jalr	-1184(ra) # 8000268c <brelse>
  if(sb.magic != FSMAGIC)
    80002b34:	0009a703          	lw	a4,0(s3)
    80002b38:	102037b7          	lui	a5,0x10203
    80002b3c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b40:	02f71263          	bne	a4,a5,80002b64 <fsinit+0x70>
  initlog(dev, &sb);
    80002b44:	00014597          	auipc	a1,0x14
    80002b48:	54458593          	addi	a1,a1,1348 # 80017088 <sb>
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00001097          	auipc	ra,0x1
    80002b52:	b2c080e7          	jalr	-1236(ra) # 8000367a <initlog>
}
    80002b56:	70a2                	ld	ra,40(sp)
    80002b58:	7402                	ld	s0,32(sp)
    80002b5a:	64e2                	ld	s1,24(sp)
    80002b5c:	6942                	ld	s2,16(sp)
    80002b5e:	69a2                	ld	s3,8(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret
    panic("invalid file system");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	a2450513          	addi	a0,a0,-1500 # 80008588 <syscalls+0x188>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	26a080e7          	jalr	618(ra) # 80005dd6 <panic>

0000000080002b74 <iinit>:
{
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b82:	00006597          	auipc	a1,0x6
    80002b86:	a1e58593          	addi	a1,a1,-1506 # 800085a0 <syscalls+0x1a0>
    80002b8a:	00014517          	auipc	a0,0x14
    80002b8e:	51e50513          	addi	a0,a0,1310 # 800170a8 <itable>
    80002b92:	00003097          	auipc	ra,0x3
    80002b96:	6ec080e7          	jalr	1772(ra) # 8000627e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b9a:	00014497          	auipc	s1,0x14
    80002b9e:	53648493          	addi	s1,s1,1334 # 800170d0 <itable+0x28>
    80002ba2:	00016997          	auipc	s3,0x16
    80002ba6:	fbe98993          	addi	s3,s3,-66 # 80018b60 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002baa:	00006917          	auipc	s2,0x6
    80002bae:	9fe90913          	addi	s2,s2,-1538 # 800085a8 <syscalls+0x1a8>
    80002bb2:	85ca                	mv	a1,s2
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	e12080e7          	jalr	-494(ra) # 800039c8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bbe:	08848493          	addi	s1,s1,136
    80002bc2:	ff3498e3          	bne	s1,s3,80002bb2 <iinit+0x3e>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret

0000000080002bd4 <ialloc>:
{
    80002bd4:	7139                	addi	sp,sp,-64
    80002bd6:	fc06                	sd	ra,56(sp)
    80002bd8:	f822                	sd	s0,48(sp)
    80002bda:	f426                	sd	s1,40(sp)
    80002bdc:	f04a                	sd	s2,32(sp)
    80002bde:	ec4e                	sd	s3,24(sp)
    80002be0:	e852                	sd	s4,16(sp)
    80002be2:	e456                	sd	s5,8(sp)
    80002be4:	e05a                	sd	s6,0(sp)
    80002be6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be8:	00014717          	auipc	a4,0x14
    80002bec:	4ac72703          	lw	a4,1196(a4) # 80017094 <sb+0xc>
    80002bf0:	4785                	li	a5,1
    80002bf2:	04e7f863          	bgeu	a5,a4,80002c42 <ialloc+0x6e>
    80002bf6:	8aaa                	mv	s5,a0
    80002bf8:	8b2e                	mv	s6,a1
    80002bfa:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bfc:	00014a17          	auipc	s4,0x14
    80002c00:	48ca0a13          	addi	s4,s4,1164 # 80017088 <sb>
    80002c04:	00495593          	srli	a1,s2,0x4
    80002c08:	018a2783          	lw	a5,24(s4)
    80002c0c:	9dbd                	addw	a1,a1,a5
    80002c0e:	8556                	mv	a0,s5
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	94c080e7          	jalr	-1716(ra) # 8000255c <bread>
    80002c18:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c1a:	05850993          	addi	s3,a0,88
    80002c1e:	00f97793          	andi	a5,s2,15
    80002c22:	079a                	slli	a5,a5,0x6
    80002c24:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c26:	00099783          	lh	a5,0(s3)
    80002c2a:	cf9d                	beqz	a5,80002c68 <ialloc+0x94>
    brelse(bp);
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	a60080e7          	jalr	-1440(ra) # 8000268c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c34:	0905                	addi	s2,s2,1
    80002c36:	00ca2703          	lw	a4,12(s4)
    80002c3a:	0009079b          	sext.w	a5,s2
    80002c3e:	fce7e3e3          	bltu	a5,a4,80002c04 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002c42:	00006517          	auipc	a0,0x6
    80002c46:	96e50513          	addi	a0,a0,-1682 # 800085b0 <syscalls+0x1b0>
    80002c4a:	00003097          	auipc	ra,0x3
    80002c4e:	1d6080e7          	jalr	470(ra) # 80005e20 <printf>
  return 0;
    80002c52:	4501                	li	a0,0
}
    80002c54:	70e2                	ld	ra,56(sp)
    80002c56:	7442                	ld	s0,48(sp)
    80002c58:	74a2                	ld	s1,40(sp)
    80002c5a:	7902                	ld	s2,32(sp)
    80002c5c:	69e2                	ld	s3,24(sp)
    80002c5e:	6a42                	ld	s4,16(sp)
    80002c60:	6aa2                	ld	s5,8(sp)
    80002c62:	6b02                	ld	s6,0(sp)
    80002c64:	6121                	addi	sp,sp,64
    80002c66:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c68:	04000613          	li	a2,64
    80002c6c:	4581                	li	a1,0
    80002c6e:	854e                	mv	a0,s3
    80002c70:	ffffd097          	auipc	ra,0xffffd
    80002c74:	50a080e7          	jalr	1290(ra) # 8000017a <memset>
      dip->type = type;
    80002c78:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c7c:	8526                	mv	a0,s1
    80002c7e:	00001097          	auipc	ra,0x1
    80002c82:	c66080e7          	jalr	-922(ra) # 800038e4 <log_write>
      brelse(bp);
    80002c86:	8526                	mv	a0,s1
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	a04080e7          	jalr	-1532(ra) # 8000268c <brelse>
      return iget(dev, inum);
    80002c90:	0009059b          	sext.w	a1,s2
    80002c94:	8556                	mv	a0,s5
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	da2080e7          	jalr	-606(ra) # 80002a38 <iget>
    80002c9e:	bf5d                	j	80002c54 <ialloc+0x80>

0000000080002ca0 <iupdate>:
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	e426                	sd	s1,8(sp)
    80002ca8:	e04a                	sd	s2,0(sp)
    80002caa:	1000                	addi	s0,sp,32
    80002cac:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cae:	415c                	lw	a5,4(a0)
    80002cb0:	0047d79b          	srliw	a5,a5,0x4
    80002cb4:	00014597          	auipc	a1,0x14
    80002cb8:	3ec5a583          	lw	a1,1004(a1) # 800170a0 <sb+0x18>
    80002cbc:	9dbd                	addw	a1,a1,a5
    80002cbe:	4108                	lw	a0,0(a0)
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	89c080e7          	jalr	-1892(ra) # 8000255c <bread>
    80002cc8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cca:	05850793          	addi	a5,a0,88
    80002cce:	40d8                	lw	a4,4(s1)
    80002cd0:	8b3d                	andi	a4,a4,15
    80002cd2:	071a                	slli	a4,a4,0x6
    80002cd4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cd6:	04449703          	lh	a4,68(s1)
    80002cda:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002cde:	04649703          	lh	a4,70(s1)
    80002ce2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ce6:	04849703          	lh	a4,72(s1)
    80002cea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cee:	04a49703          	lh	a4,74(s1)
    80002cf2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cf6:	44f8                	lw	a4,76(s1)
    80002cf8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cfa:	03400613          	li	a2,52
    80002cfe:	05048593          	addi	a1,s1,80
    80002d02:	00c78513          	addi	a0,a5,12
    80002d06:	ffffd097          	auipc	ra,0xffffd
    80002d0a:	4d0080e7          	jalr	1232(ra) # 800001d6 <memmove>
  log_write(bp);
    80002d0e:	854a                	mv	a0,s2
    80002d10:	00001097          	auipc	ra,0x1
    80002d14:	bd4080e7          	jalr	-1068(ra) # 800038e4 <log_write>
  brelse(bp);
    80002d18:	854a                	mv	a0,s2
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	972080e7          	jalr	-1678(ra) # 8000268c <brelse>
}
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6902                	ld	s2,0(sp)
    80002d2a:	6105                	addi	sp,sp,32
    80002d2c:	8082                	ret

0000000080002d2e <idup>:
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	e426                	sd	s1,8(sp)
    80002d36:	1000                	addi	s0,sp,32
    80002d38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d3a:	00014517          	auipc	a0,0x14
    80002d3e:	36e50513          	addi	a0,a0,878 # 800170a8 <itable>
    80002d42:	00003097          	auipc	ra,0x3
    80002d46:	5cc080e7          	jalr	1484(ra) # 8000630e <acquire>
  ip->ref++;
    80002d4a:	449c                	lw	a5,8(s1)
    80002d4c:	2785                	addiw	a5,a5,1
    80002d4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d50:	00014517          	auipc	a0,0x14
    80002d54:	35850513          	addi	a0,a0,856 # 800170a8 <itable>
    80002d58:	00003097          	auipc	ra,0x3
    80002d5c:	66a080e7          	jalr	1642(ra) # 800063c2 <release>
}
    80002d60:	8526                	mv	a0,s1
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <ilock>:
{
    80002d6c:	1101                	addi	sp,sp,-32
    80002d6e:	ec06                	sd	ra,24(sp)
    80002d70:	e822                	sd	s0,16(sp)
    80002d72:	e426                	sd	s1,8(sp)
    80002d74:	e04a                	sd	s2,0(sp)
    80002d76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d78:	c115                	beqz	a0,80002d9c <ilock+0x30>
    80002d7a:	84aa                	mv	s1,a0
    80002d7c:	451c                	lw	a5,8(a0)
    80002d7e:	00f05f63          	blez	a5,80002d9c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d82:	0541                	addi	a0,a0,16
    80002d84:	00001097          	auipc	ra,0x1
    80002d88:	c7e080e7          	jalr	-898(ra) # 80003a02 <acquiresleep>
  if(ip->valid == 0){
    80002d8c:	40bc                	lw	a5,64(s1)
    80002d8e:	cf99                	beqz	a5,80002dac <ilock+0x40>
}
    80002d90:	60e2                	ld	ra,24(sp)
    80002d92:	6442                	ld	s0,16(sp)
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	6902                	ld	s2,0(sp)
    80002d98:	6105                	addi	sp,sp,32
    80002d9a:	8082                	ret
    panic("ilock");
    80002d9c:	00006517          	auipc	a0,0x6
    80002da0:	82c50513          	addi	a0,a0,-2004 # 800085c8 <syscalls+0x1c8>
    80002da4:	00003097          	auipc	ra,0x3
    80002da8:	032080e7          	jalr	50(ra) # 80005dd6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dac:	40dc                	lw	a5,4(s1)
    80002dae:	0047d79b          	srliw	a5,a5,0x4
    80002db2:	00014597          	auipc	a1,0x14
    80002db6:	2ee5a583          	lw	a1,750(a1) # 800170a0 <sb+0x18>
    80002dba:	9dbd                	addw	a1,a1,a5
    80002dbc:	4088                	lw	a0,0(s1)
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	79e080e7          	jalr	1950(ra) # 8000255c <bread>
    80002dc6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dc8:	05850593          	addi	a1,a0,88
    80002dcc:	40dc                	lw	a5,4(s1)
    80002dce:	8bbd                	andi	a5,a5,15
    80002dd0:	079a                	slli	a5,a5,0x6
    80002dd2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd4:	00059783          	lh	a5,0(a1)
    80002dd8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ddc:	00259783          	lh	a5,2(a1)
    80002de0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de4:	00459783          	lh	a5,4(a1)
    80002de8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dec:	00659783          	lh	a5,6(a1)
    80002df0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df4:	459c                	lw	a5,8(a1)
    80002df6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002df8:	03400613          	li	a2,52
    80002dfc:	05b1                	addi	a1,a1,12
    80002dfe:	05048513          	addi	a0,s1,80
    80002e02:	ffffd097          	auipc	ra,0xffffd
    80002e06:	3d4080e7          	jalr	980(ra) # 800001d6 <memmove>
    brelse(bp);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	880080e7          	jalr	-1920(ra) # 8000268c <brelse>
    ip->valid = 1;
    80002e14:	4785                	li	a5,1
    80002e16:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e18:	04449783          	lh	a5,68(s1)
    80002e1c:	fbb5                	bnez	a5,80002d90 <ilock+0x24>
      panic("ilock: no type");
    80002e1e:	00005517          	auipc	a0,0x5
    80002e22:	7b250513          	addi	a0,a0,1970 # 800085d0 <syscalls+0x1d0>
    80002e26:	00003097          	auipc	ra,0x3
    80002e2a:	fb0080e7          	jalr	-80(ra) # 80005dd6 <panic>

0000000080002e2e <iunlock>:
{
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	e04a                	sd	s2,0(sp)
    80002e38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3a:	c905                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e3c:	84aa                	mv	s1,a0
    80002e3e:	01050913          	addi	s2,a0,16
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	c58080e7          	jalr	-936(ra) # 80003a9c <holdingsleep>
    80002e4c:	cd19                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e4e:	449c                	lw	a5,8(s1)
    80002e50:	00f05d63          	blez	a5,80002e6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e54:	854a                	mv	a0,s2
    80002e56:	00001097          	auipc	ra,0x1
    80002e5a:	c02080e7          	jalr	-1022(ra) # 80003a58 <releasesleep>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
    panic("iunlock");
    80002e6a:	00005517          	auipc	a0,0x5
    80002e6e:	77650513          	addi	a0,a0,1910 # 800085e0 <syscalls+0x1e0>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	f64080e7          	jalr	-156(ra) # 80005dd6 <panic>

0000000080002e7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7a:	7179                	addi	sp,sp,-48
    80002e7c:	f406                	sd	ra,40(sp)
    80002e7e:	f022                	sd	s0,32(sp)
    80002e80:	ec26                	sd	s1,24(sp)
    80002e82:	e84a                	sd	s2,16(sp)
    80002e84:	e44e                	sd	s3,8(sp)
    80002e86:	e052                	sd	s4,0(sp)
    80002e88:	1800                	addi	s0,sp,48
    80002e8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e8c:	05050493          	addi	s1,a0,80
    80002e90:	08050913          	addi	s2,a0,128
    80002e94:	a021                	j	80002e9c <itrunc+0x22>
    80002e96:	0491                	addi	s1,s1,4
    80002e98:	01248d63          	beq	s1,s2,80002eb2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e9c:	408c                	lw	a1,0(s1)
    80002e9e:	dde5                	beqz	a1,80002e96 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ea0:	0009a503          	lw	a0,0(s3)
    80002ea4:	00000097          	auipc	ra,0x0
    80002ea8:	8fc080e7          	jalr	-1796(ra) # 800027a0 <bfree>
      ip->addrs[i] = 0;
    80002eac:	0004a023          	sw	zero,0(s1)
    80002eb0:	b7dd                	j	80002e96 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb2:	0809a583          	lw	a1,128(s3)
    80002eb6:	e185                	bnez	a1,80002ed6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eb8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ebc:	854e                	mv	a0,s3
    80002ebe:	00000097          	auipc	ra,0x0
    80002ec2:	de2080e7          	jalr	-542(ra) # 80002ca0 <iupdate>
}
    80002ec6:	70a2                	ld	ra,40(sp)
    80002ec8:	7402                	ld	s0,32(sp)
    80002eca:	64e2                	ld	s1,24(sp)
    80002ecc:	6942                	ld	s2,16(sp)
    80002ece:	69a2                	ld	s3,8(sp)
    80002ed0:	6a02                	ld	s4,0(sp)
    80002ed2:	6145                	addi	sp,sp,48
    80002ed4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ed6:	0009a503          	lw	a0,0(s3)
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	682080e7          	jalr	1666(ra) # 8000255c <bread>
    80002ee2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee4:	05850493          	addi	s1,a0,88
    80002ee8:	45850913          	addi	s2,a0,1112
    80002eec:	a021                	j	80002ef4 <itrunc+0x7a>
    80002eee:	0491                	addi	s1,s1,4
    80002ef0:	01248b63          	beq	s1,s2,80002f06 <itrunc+0x8c>
      if(a[j])
    80002ef4:	408c                	lw	a1,0(s1)
    80002ef6:	dde5                	beqz	a1,80002eee <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ef8:	0009a503          	lw	a0,0(s3)
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	8a4080e7          	jalr	-1884(ra) # 800027a0 <bfree>
    80002f04:	b7ed                	j	80002eee <itrunc+0x74>
    brelse(bp);
    80002f06:	8552                	mv	a0,s4
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	784080e7          	jalr	1924(ra) # 8000268c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f10:	0809a583          	lw	a1,128(s3)
    80002f14:	0009a503          	lw	a0,0(s3)
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	888080e7          	jalr	-1912(ra) # 800027a0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f20:	0809a023          	sw	zero,128(s3)
    80002f24:	bf51                	j	80002eb8 <itrunc+0x3e>

0000000080002f26 <iput>:
{
    80002f26:	1101                	addi	sp,sp,-32
    80002f28:	ec06                	sd	ra,24(sp)
    80002f2a:	e822                	sd	s0,16(sp)
    80002f2c:	e426                	sd	s1,8(sp)
    80002f2e:	e04a                	sd	s2,0(sp)
    80002f30:	1000                	addi	s0,sp,32
    80002f32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f34:	00014517          	auipc	a0,0x14
    80002f38:	17450513          	addi	a0,a0,372 # 800170a8 <itable>
    80002f3c:	00003097          	auipc	ra,0x3
    80002f40:	3d2080e7          	jalr	978(ra) # 8000630e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f44:	4498                	lw	a4,8(s1)
    80002f46:	4785                	li	a5,1
    80002f48:	02f70363          	beq	a4,a5,80002f6e <iput+0x48>
  ip->ref--;
    80002f4c:	449c                	lw	a5,8(s1)
    80002f4e:	37fd                	addiw	a5,a5,-1
    80002f50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f52:	00014517          	auipc	a0,0x14
    80002f56:	15650513          	addi	a0,a0,342 # 800170a8 <itable>
    80002f5a:	00003097          	auipc	ra,0x3
    80002f5e:	468080e7          	jalr	1128(ra) # 800063c2 <release>
}
    80002f62:	60e2                	ld	ra,24(sp)
    80002f64:	6442                	ld	s0,16(sp)
    80002f66:	64a2                	ld	s1,8(sp)
    80002f68:	6902                	ld	s2,0(sp)
    80002f6a:	6105                	addi	sp,sp,32
    80002f6c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f6e:	40bc                	lw	a5,64(s1)
    80002f70:	dff1                	beqz	a5,80002f4c <iput+0x26>
    80002f72:	04a49783          	lh	a5,74(s1)
    80002f76:	fbf9                	bnez	a5,80002f4c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f78:	01048913          	addi	s2,s1,16
    80002f7c:	854a                	mv	a0,s2
    80002f7e:	00001097          	auipc	ra,0x1
    80002f82:	a84080e7          	jalr	-1404(ra) # 80003a02 <acquiresleep>
    release(&itable.lock);
    80002f86:	00014517          	auipc	a0,0x14
    80002f8a:	12250513          	addi	a0,a0,290 # 800170a8 <itable>
    80002f8e:	00003097          	auipc	ra,0x3
    80002f92:	434080e7          	jalr	1076(ra) # 800063c2 <release>
    itrunc(ip);
    80002f96:	8526                	mv	a0,s1
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	ee2080e7          	jalr	-286(ra) # 80002e7a <itrunc>
    ip->type = 0;
    80002fa0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	cfa080e7          	jalr	-774(ra) # 80002ca0 <iupdate>
    ip->valid = 0;
    80002fae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	aa4080e7          	jalr	-1372(ra) # 80003a58 <releasesleep>
    acquire(&itable.lock);
    80002fbc:	00014517          	auipc	a0,0x14
    80002fc0:	0ec50513          	addi	a0,a0,236 # 800170a8 <itable>
    80002fc4:	00003097          	auipc	ra,0x3
    80002fc8:	34a080e7          	jalr	842(ra) # 8000630e <acquire>
    80002fcc:	b741                	j	80002f4c <iput+0x26>

0000000080002fce <iunlockput>:
{
    80002fce:	1101                	addi	sp,sp,-32
    80002fd0:	ec06                	sd	ra,24(sp)
    80002fd2:	e822                	sd	s0,16(sp)
    80002fd4:	e426                	sd	s1,8(sp)
    80002fd6:	1000                	addi	s0,sp,32
    80002fd8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	e54080e7          	jalr	-428(ra) # 80002e2e <iunlock>
  iput(ip);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	f42080e7          	jalr	-190(ra) # 80002f26 <iput>
}
    80002fec:	60e2                	ld	ra,24(sp)
    80002fee:	6442                	ld	s0,16(sp)
    80002ff0:	64a2                	ld	s1,8(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ff6:	1141                	addi	sp,sp,-16
    80002ff8:	e422                	sd	s0,8(sp)
    80002ffa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ffc:	411c                	lw	a5,0(a0)
    80002ffe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003000:	415c                	lw	a5,4(a0)
    80003002:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003004:	04451783          	lh	a5,68(a0)
    80003008:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000300c:	04a51783          	lh	a5,74(a0)
    80003010:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003014:	04c56783          	lwu	a5,76(a0)
    80003018:	e99c                	sd	a5,16(a1)
}
    8000301a:	6422                	ld	s0,8(sp)
    8000301c:	0141                	addi	sp,sp,16
    8000301e:	8082                	ret

0000000080003020 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003020:	457c                	lw	a5,76(a0)
    80003022:	0ed7e963          	bltu	a5,a3,80003114 <readi+0xf4>
{
    80003026:	7159                	addi	sp,sp,-112
    80003028:	f486                	sd	ra,104(sp)
    8000302a:	f0a2                	sd	s0,96(sp)
    8000302c:	eca6                	sd	s1,88(sp)
    8000302e:	e8ca                	sd	s2,80(sp)
    80003030:	e4ce                	sd	s3,72(sp)
    80003032:	e0d2                	sd	s4,64(sp)
    80003034:	fc56                	sd	s5,56(sp)
    80003036:	f85a                	sd	s6,48(sp)
    80003038:	f45e                	sd	s7,40(sp)
    8000303a:	f062                	sd	s8,32(sp)
    8000303c:	ec66                	sd	s9,24(sp)
    8000303e:	e86a                	sd	s10,16(sp)
    80003040:	e46e                	sd	s11,8(sp)
    80003042:	1880                	addi	s0,sp,112
    80003044:	8b2a                	mv	s6,a0
    80003046:	8bae                	mv	s7,a1
    80003048:	8a32                	mv	s4,a2
    8000304a:	84b6                	mv	s1,a3
    8000304c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000304e:	9f35                	addw	a4,a4,a3
    return 0;
    80003050:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003052:	0ad76063          	bltu	a4,a3,800030f2 <readi+0xd2>
  if(off + n > ip->size)
    80003056:	00e7f463          	bgeu	a5,a4,8000305e <readi+0x3e>
    n = ip->size - off;
    8000305a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000305e:	0a0a8963          	beqz	s5,80003110 <readi+0xf0>
    80003062:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003068:	5c7d                	li	s8,-1
    8000306a:	a82d                	j	800030a4 <readi+0x84>
    8000306c:	020d1d93          	slli	s11,s10,0x20
    80003070:	020ddd93          	srli	s11,s11,0x20
    80003074:	05890613          	addi	a2,s2,88
    80003078:	86ee                	mv	a3,s11
    8000307a:	963a                	add	a2,a2,a4
    8000307c:	85d2                	mv	a1,s4
    8000307e:	855e                	mv	a0,s7
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	a26080e7          	jalr	-1498(ra) # 80001aa6 <either_copyout>
    80003088:	05850d63          	beq	a0,s8,800030e2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000308c:	854a                	mv	a0,s2
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	5fe080e7          	jalr	1534(ra) # 8000268c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003096:	013d09bb          	addw	s3,s10,s3
    8000309a:	009d04bb          	addw	s1,s10,s1
    8000309e:	9a6e                	add	s4,s4,s11
    800030a0:	0559f763          	bgeu	s3,s5,800030ee <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030a4:	00a4d59b          	srliw	a1,s1,0xa
    800030a8:	855a                	mv	a0,s6
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	8a4080e7          	jalr	-1884(ra) # 8000294e <bmap>
    800030b2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030b6:	cd85                	beqz	a1,800030ee <readi+0xce>
    bp = bread(ip->dev, addr);
    800030b8:	000b2503          	lw	a0,0(s6)
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	4a0080e7          	jalr	1184(ra) # 8000255c <bread>
    800030c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c6:	3ff4f713          	andi	a4,s1,1023
    800030ca:	40ec87bb          	subw	a5,s9,a4
    800030ce:	413a86bb          	subw	a3,s5,s3
    800030d2:	8d3e                	mv	s10,a5
    800030d4:	2781                	sext.w	a5,a5
    800030d6:	0006861b          	sext.w	a2,a3
    800030da:	f8f679e3          	bgeu	a2,a5,8000306c <readi+0x4c>
    800030de:	8d36                	mv	s10,a3
    800030e0:	b771                	j	8000306c <readi+0x4c>
      brelse(bp);
    800030e2:	854a                	mv	a0,s2
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	5a8080e7          	jalr	1448(ra) # 8000268c <brelse>
      tot = -1;
    800030ec:	59fd                	li	s3,-1
  }
  return tot;
    800030ee:	0009851b          	sext.w	a0,s3
}
    800030f2:	70a6                	ld	ra,104(sp)
    800030f4:	7406                	ld	s0,96(sp)
    800030f6:	64e6                	ld	s1,88(sp)
    800030f8:	6946                	ld	s2,80(sp)
    800030fa:	69a6                	ld	s3,72(sp)
    800030fc:	6a06                	ld	s4,64(sp)
    800030fe:	7ae2                	ld	s5,56(sp)
    80003100:	7b42                	ld	s6,48(sp)
    80003102:	7ba2                	ld	s7,40(sp)
    80003104:	7c02                	ld	s8,32(sp)
    80003106:	6ce2                	ld	s9,24(sp)
    80003108:	6d42                	ld	s10,16(sp)
    8000310a:	6da2                	ld	s11,8(sp)
    8000310c:	6165                	addi	sp,sp,112
    8000310e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003110:	89d6                	mv	s3,s5
    80003112:	bff1                	j	800030ee <readi+0xce>
    return 0;
    80003114:	4501                	li	a0,0
}
    80003116:	8082                	ret

0000000080003118 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003118:	457c                	lw	a5,76(a0)
    8000311a:	10d7e863          	bltu	a5,a3,8000322a <writei+0x112>
{
    8000311e:	7159                	addi	sp,sp,-112
    80003120:	f486                	sd	ra,104(sp)
    80003122:	f0a2                	sd	s0,96(sp)
    80003124:	eca6                	sd	s1,88(sp)
    80003126:	e8ca                	sd	s2,80(sp)
    80003128:	e4ce                	sd	s3,72(sp)
    8000312a:	e0d2                	sd	s4,64(sp)
    8000312c:	fc56                	sd	s5,56(sp)
    8000312e:	f85a                	sd	s6,48(sp)
    80003130:	f45e                	sd	s7,40(sp)
    80003132:	f062                	sd	s8,32(sp)
    80003134:	ec66                	sd	s9,24(sp)
    80003136:	e86a                	sd	s10,16(sp)
    80003138:	e46e                	sd	s11,8(sp)
    8000313a:	1880                	addi	s0,sp,112
    8000313c:	8aaa                	mv	s5,a0
    8000313e:	8bae                	mv	s7,a1
    80003140:	8a32                	mv	s4,a2
    80003142:	8936                	mv	s2,a3
    80003144:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003146:	00e687bb          	addw	a5,a3,a4
    8000314a:	0ed7e263          	bltu	a5,a3,8000322e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000314e:	00043737          	lui	a4,0x43
    80003152:	0ef76063          	bltu	a4,a5,80003232 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003156:	0c0b0863          	beqz	s6,80003226 <writei+0x10e>
    8000315a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000315c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003160:	5c7d                	li	s8,-1
    80003162:	a091                	j	800031a6 <writei+0x8e>
    80003164:	020d1d93          	slli	s11,s10,0x20
    80003168:	020ddd93          	srli	s11,s11,0x20
    8000316c:	05848513          	addi	a0,s1,88
    80003170:	86ee                	mv	a3,s11
    80003172:	8652                	mv	a2,s4
    80003174:	85de                	mv	a1,s7
    80003176:	953a                	add	a0,a0,a4
    80003178:	fffff097          	auipc	ra,0xfffff
    8000317c:	984080e7          	jalr	-1660(ra) # 80001afc <either_copyin>
    80003180:	07850263          	beq	a0,s8,800031e4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003184:	8526                	mv	a0,s1
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	75e080e7          	jalr	1886(ra) # 800038e4 <log_write>
    brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	4fc080e7          	jalr	1276(ra) # 8000268c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003198:	013d09bb          	addw	s3,s10,s3
    8000319c:	012d093b          	addw	s2,s10,s2
    800031a0:	9a6e                	add	s4,s4,s11
    800031a2:	0569f663          	bgeu	s3,s6,800031ee <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031a6:	00a9559b          	srliw	a1,s2,0xa
    800031aa:	8556                	mv	a0,s5
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	7a2080e7          	jalr	1954(ra) # 8000294e <bmap>
    800031b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031b8:	c99d                	beqz	a1,800031ee <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031ba:	000aa503          	lw	a0,0(s5) # 1000 <_entry-0x7ffff000>
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	39e080e7          	jalr	926(ra) # 8000255c <bread>
    800031c6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031c8:	3ff97713          	andi	a4,s2,1023
    800031cc:	40ec87bb          	subw	a5,s9,a4
    800031d0:	413b06bb          	subw	a3,s6,s3
    800031d4:	8d3e                	mv	s10,a5
    800031d6:	2781                	sext.w	a5,a5
    800031d8:	0006861b          	sext.w	a2,a3
    800031dc:	f8f674e3          	bgeu	a2,a5,80003164 <writei+0x4c>
    800031e0:	8d36                	mv	s10,a3
    800031e2:	b749                	j	80003164 <writei+0x4c>
      brelse(bp);
    800031e4:	8526                	mv	a0,s1
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	4a6080e7          	jalr	1190(ra) # 8000268c <brelse>
  }

  if(off > ip->size)
    800031ee:	04caa783          	lw	a5,76(s5)
    800031f2:	0127f463          	bgeu	a5,s2,800031fa <writei+0xe2>
    ip->size = off;
    800031f6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031fa:	8556                	mv	a0,s5
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	aa4080e7          	jalr	-1372(ra) # 80002ca0 <iupdate>

  return tot;
    80003204:	0009851b          	sext.w	a0,s3
}
    80003208:	70a6                	ld	ra,104(sp)
    8000320a:	7406                	ld	s0,96(sp)
    8000320c:	64e6                	ld	s1,88(sp)
    8000320e:	6946                	ld	s2,80(sp)
    80003210:	69a6                	ld	s3,72(sp)
    80003212:	6a06                	ld	s4,64(sp)
    80003214:	7ae2                	ld	s5,56(sp)
    80003216:	7b42                	ld	s6,48(sp)
    80003218:	7ba2                	ld	s7,40(sp)
    8000321a:	7c02                	ld	s8,32(sp)
    8000321c:	6ce2                	ld	s9,24(sp)
    8000321e:	6d42                	ld	s10,16(sp)
    80003220:	6da2                	ld	s11,8(sp)
    80003222:	6165                	addi	sp,sp,112
    80003224:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003226:	89da                	mv	s3,s6
    80003228:	bfc9                	j	800031fa <writei+0xe2>
    return -1;
    8000322a:	557d                	li	a0,-1
}
    8000322c:	8082                	ret
    return -1;
    8000322e:	557d                	li	a0,-1
    80003230:	bfe1                	j	80003208 <writei+0xf0>
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	bfd1                	j	80003208 <writei+0xf0>

0000000080003236 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003236:	1141                	addi	sp,sp,-16
    80003238:	e406                	sd	ra,8(sp)
    8000323a:	e022                	sd	s0,0(sp)
    8000323c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000323e:	4639                	li	a2,14
    80003240:	ffffd097          	auipc	ra,0xffffd
    80003244:	00a080e7          	jalr	10(ra) # 8000024a <strncmp>
}
    80003248:	60a2                	ld	ra,8(sp)
    8000324a:	6402                	ld	s0,0(sp)
    8000324c:	0141                	addi	sp,sp,16
    8000324e:	8082                	ret

0000000080003250 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003250:	7139                	addi	sp,sp,-64
    80003252:	fc06                	sd	ra,56(sp)
    80003254:	f822                	sd	s0,48(sp)
    80003256:	f426                	sd	s1,40(sp)
    80003258:	f04a                	sd	s2,32(sp)
    8000325a:	ec4e                	sd	s3,24(sp)
    8000325c:	e852                	sd	s4,16(sp)
    8000325e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003260:	04451703          	lh	a4,68(a0)
    80003264:	4785                	li	a5,1
    80003266:	00f71a63          	bne	a4,a5,8000327a <dirlookup+0x2a>
    8000326a:	892a                	mv	s2,a0
    8000326c:	89ae                	mv	s3,a1
    8000326e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003270:	457c                	lw	a5,76(a0)
    80003272:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003274:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003276:	e79d                	bnez	a5,800032a4 <dirlookup+0x54>
    80003278:	a8a5                	j	800032f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000327a:	00005517          	auipc	a0,0x5
    8000327e:	36e50513          	addi	a0,a0,878 # 800085e8 <syscalls+0x1e8>
    80003282:	00003097          	auipc	ra,0x3
    80003286:	b54080e7          	jalr	-1196(ra) # 80005dd6 <panic>
      panic("dirlookup read");
    8000328a:	00005517          	auipc	a0,0x5
    8000328e:	37650513          	addi	a0,a0,886 # 80008600 <syscalls+0x200>
    80003292:	00003097          	auipc	ra,0x3
    80003296:	b44080e7          	jalr	-1212(ra) # 80005dd6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329a:	24c1                	addiw	s1,s1,16
    8000329c:	04c92783          	lw	a5,76(s2)
    800032a0:	04f4f763          	bgeu	s1,a5,800032ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a4:	4741                	li	a4,16
    800032a6:	86a6                	mv	a3,s1
    800032a8:	fc040613          	addi	a2,s0,-64
    800032ac:	4581                	li	a1,0
    800032ae:	854a                	mv	a0,s2
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	d70080e7          	jalr	-656(ra) # 80003020 <readi>
    800032b8:	47c1                	li	a5,16
    800032ba:	fcf518e3          	bne	a0,a5,8000328a <dirlookup+0x3a>
    if(de.inum == 0)
    800032be:	fc045783          	lhu	a5,-64(s0)
    800032c2:	dfe1                	beqz	a5,8000329a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032c4:	fc240593          	addi	a1,s0,-62
    800032c8:	854e                	mv	a0,s3
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	f6c080e7          	jalr	-148(ra) # 80003236 <namecmp>
    800032d2:	f561                	bnez	a0,8000329a <dirlookup+0x4a>
      if(poff)
    800032d4:	000a0463          	beqz	s4,800032dc <dirlookup+0x8c>
        *poff = off;
    800032d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032dc:	fc045583          	lhu	a1,-64(s0)
    800032e0:	00092503          	lw	a0,0(s2)
    800032e4:	fffff097          	auipc	ra,0xfffff
    800032e8:	754080e7          	jalr	1876(ra) # 80002a38 <iget>
    800032ec:	a011                	j	800032f0 <dirlookup+0xa0>
  return 0;
    800032ee:	4501                	li	a0,0
}
    800032f0:	70e2                	ld	ra,56(sp)
    800032f2:	7442                	ld	s0,48(sp)
    800032f4:	74a2                	ld	s1,40(sp)
    800032f6:	7902                	ld	s2,32(sp)
    800032f8:	69e2                	ld	s3,24(sp)
    800032fa:	6a42                	ld	s4,16(sp)
    800032fc:	6121                	addi	sp,sp,64
    800032fe:	8082                	ret

0000000080003300 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003300:	711d                	addi	sp,sp,-96
    80003302:	ec86                	sd	ra,88(sp)
    80003304:	e8a2                	sd	s0,80(sp)
    80003306:	e4a6                	sd	s1,72(sp)
    80003308:	e0ca                	sd	s2,64(sp)
    8000330a:	fc4e                	sd	s3,56(sp)
    8000330c:	f852                	sd	s4,48(sp)
    8000330e:	f456                	sd	s5,40(sp)
    80003310:	f05a                	sd	s6,32(sp)
    80003312:	ec5e                	sd	s7,24(sp)
    80003314:	e862                	sd	s8,16(sp)
    80003316:	e466                	sd	s9,8(sp)
    80003318:	1080                	addi	s0,sp,96
    8000331a:	84aa                	mv	s1,a0
    8000331c:	8b2e                	mv	s6,a1
    8000331e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003320:	00054703          	lbu	a4,0(a0)
    80003324:	02f00793          	li	a5,47
    80003328:	02f70263          	beq	a4,a5,8000334c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000332c:	ffffe097          	auipc	ra,0xffffe
    80003330:	c1c080e7          	jalr	-996(ra) # 80000f48 <myproc>
    80003334:	15853503          	ld	a0,344(a0)
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	9f6080e7          	jalr	-1546(ra) # 80002d2e <idup>
    80003340:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003342:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003346:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003348:	4b85                	li	s7,1
    8000334a:	a875                	j	80003406 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000334c:	4585                	li	a1,1
    8000334e:	4505                	li	a0,1
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	6e8080e7          	jalr	1768(ra) # 80002a38 <iget>
    80003358:	8a2a                	mv	s4,a0
    8000335a:	b7e5                	j	80003342 <namex+0x42>
      iunlockput(ip);
    8000335c:	8552                	mv	a0,s4
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	c70080e7          	jalr	-912(ra) # 80002fce <iunlockput>
      return 0;
    80003366:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003368:	8552                	mv	a0,s4
    8000336a:	60e6                	ld	ra,88(sp)
    8000336c:	6446                	ld	s0,80(sp)
    8000336e:	64a6                	ld	s1,72(sp)
    80003370:	6906                	ld	s2,64(sp)
    80003372:	79e2                	ld	s3,56(sp)
    80003374:	7a42                	ld	s4,48(sp)
    80003376:	7aa2                	ld	s5,40(sp)
    80003378:	7b02                	ld	s6,32(sp)
    8000337a:	6be2                	ld	s7,24(sp)
    8000337c:	6c42                	ld	s8,16(sp)
    8000337e:	6ca2                	ld	s9,8(sp)
    80003380:	6125                	addi	sp,sp,96
    80003382:	8082                	ret
      iunlock(ip);
    80003384:	8552                	mv	a0,s4
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	aa8080e7          	jalr	-1368(ra) # 80002e2e <iunlock>
      return ip;
    8000338e:	bfe9                	j	80003368 <namex+0x68>
      iunlockput(ip);
    80003390:	8552                	mv	a0,s4
    80003392:	00000097          	auipc	ra,0x0
    80003396:	c3c080e7          	jalr	-964(ra) # 80002fce <iunlockput>
      return 0;
    8000339a:	8a4e                	mv	s4,s3
    8000339c:	b7f1                	j	80003368 <namex+0x68>
  len = path - s;
    8000339e:	40998633          	sub	a2,s3,s1
    800033a2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033a6:	099c5863          	bge	s8,s9,80003436 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800033aa:	4639                	li	a2,14
    800033ac:	85a6                	mv	a1,s1
    800033ae:	8556                	mv	a0,s5
    800033b0:	ffffd097          	auipc	ra,0xffffd
    800033b4:	e26080e7          	jalr	-474(ra) # 800001d6 <memmove>
    800033b8:	84ce                	mv	s1,s3
  while(*path == '/')
    800033ba:	0004c783          	lbu	a5,0(s1)
    800033be:	01279763          	bne	a5,s2,800033cc <namex+0xcc>
    path++;
    800033c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c4:	0004c783          	lbu	a5,0(s1)
    800033c8:	ff278de3          	beq	a5,s2,800033c2 <namex+0xc2>
    ilock(ip);
    800033cc:	8552                	mv	a0,s4
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	99e080e7          	jalr	-1634(ra) # 80002d6c <ilock>
    if(ip->type != T_DIR){
    800033d6:	044a1783          	lh	a5,68(s4)
    800033da:	f97791e3          	bne	a5,s7,8000335c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033de:	000b0563          	beqz	s6,800033e8 <namex+0xe8>
    800033e2:	0004c783          	lbu	a5,0(s1)
    800033e6:	dfd9                	beqz	a5,80003384 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033e8:	4601                	li	a2,0
    800033ea:	85d6                	mv	a1,s5
    800033ec:	8552                	mv	a0,s4
    800033ee:	00000097          	auipc	ra,0x0
    800033f2:	e62080e7          	jalr	-414(ra) # 80003250 <dirlookup>
    800033f6:	89aa                	mv	s3,a0
    800033f8:	dd41                	beqz	a0,80003390 <namex+0x90>
    iunlockput(ip);
    800033fa:	8552                	mv	a0,s4
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	bd2080e7          	jalr	-1070(ra) # 80002fce <iunlockput>
    ip = next;
    80003404:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003406:	0004c783          	lbu	a5,0(s1)
    8000340a:	01279763          	bne	a5,s2,80003418 <namex+0x118>
    path++;
    8000340e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003410:	0004c783          	lbu	a5,0(s1)
    80003414:	ff278de3          	beq	a5,s2,8000340e <namex+0x10e>
  if(*path == 0)
    80003418:	cb9d                	beqz	a5,8000344e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000341a:	0004c783          	lbu	a5,0(s1)
    8000341e:	89a6                	mv	s3,s1
  len = path - s;
    80003420:	4c81                	li	s9,0
    80003422:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003424:	01278963          	beq	a5,s2,80003436 <namex+0x136>
    80003428:	dbbd                	beqz	a5,8000339e <namex+0x9e>
    path++;
    8000342a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000342c:	0009c783          	lbu	a5,0(s3)
    80003430:	ff279ce3          	bne	a5,s2,80003428 <namex+0x128>
    80003434:	b7ad                	j	8000339e <namex+0x9e>
    memmove(name, s, len);
    80003436:	2601                	sext.w	a2,a2
    80003438:	85a6                	mv	a1,s1
    8000343a:	8556                	mv	a0,s5
    8000343c:	ffffd097          	auipc	ra,0xffffd
    80003440:	d9a080e7          	jalr	-614(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003444:	9cd6                	add	s9,s9,s5
    80003446:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000344a:	84ce                	mv	s1,s3
    8000344c:	b7bd                	j	800033ba <namex+0xba>
  if(nameiparent){
    8000344e:	f00b0de3          	beqz	s6,80003368 <namex+0x68>
    iput(ip);
    80003452:	8552                	mv	a0,s4
    80003454:	00000097          	auipc	ra,0x0
    80003458:	ad2080e7          	jalr	-1326(ra) # 80002f26 <iput>
    return 0;
    8000345c:	4a01                	li	s4,0
    8000345e:	b729                	j	80003368 <namex+0x68>

0000000080003460 <dirlink>:
{
    80003460:	7139                	addi	sp,sp,-64
    80003462:	fc06                	sd	ra,56(sp)
    80003464:	f822                	sd	s0,48(sp)
    80003466:	f426                	sd	s1,40(sp)
    80003468:	f04a                	sd	s2,32(sp)
    8000346a:	ec4e                	sd	s3,24(sp)
    8000346c:	e852                	sd	s4,16(sp)
    8000346e:	0080                	addi	s0,sp,64
    80003470:	892a                	mv	s2,a0
    80003472:	8a2e                	mv	s4,a1
    80003474:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003476:	4601                	li	a2,0
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	dd8080e7          	jalr	-552(ra) # 80003250 <dirlookup>
    80003480:	e93d                	bnez	a0,800034f6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003482:	04c92483          	lw	s1,76(s2)
    80003486:	c49d                	beqz	s1,800034b4 <dirlink+0x54>
    80003488:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348a:	4741                	li	a4,16
    8000348c:	86a6                	mv	a3,s1
    8000348e:	fc040613          	addi	a2,s0,-64
    80003492:	4581                	li	a1,0
    80003494:	854a                	mv	a0,s2
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	b8a080e7          	jalr	-1142(ra) # 80003020 <readi>
    8000349e:	47c1                	li	a5,16
    800034a0:	06f51163          	bne	a0,a5,80003502 <dirlink+0xa2>
    if(de.inum == 0)
    800034a4:	fc045783          	lhu	a5,-64(s0)
    800034a8:	c791                	beqz	a5,800034b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034aa:	24c1                	addiw	s1,s1,16
    800034ac:	04c92783          	lw	a5,76(s2)
    800034b0:	fcf4ede3          	bltu	s1,a5,8000348a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034b4:	4639                	li	a2,14
    800034b6:	85d2                	mv	a1,s4
    800034b8:	fc240513          	addi	a0,s0,-62
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	dca080e7          	jalr	-566(ra) # 80000286 <strncpy>
  de.inum = inum;
    800034c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c8:	4741                	li	a4,16
    800034ca:	86a6                	mv	a3,s1
    800034cc:	fc040613          	addi	a2,s0,-64
    800034d0:	4581                	li	a1,0
    800034d2:	854a                	mv	a0,s2
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	c44080e7          	jalr	-956(ra) # 80003118 <writei>
    800034dc:	1541                	addi	a0,a0,-16
    800034de:	00a03533          	snez	a0,a0
    800034e2:	40a00533          	neg	a0,a0
}
    800034e6:	70e2                	ld	ra,56(sp)
    800034e8:	7442                	ld	s0,48(sp)
    800034ea:	74a2                	ld	s1,40(sp)
    800034ec:	7902                	ld	s2,32(sp)
    800034ee:	69e2                	ld	s3,24(sp)
    800034f0:	6a42                	ld	s4,16(sp)
    800034f2:	6121                	addi	sp,sp,64
    800034f4:	8082                	ret
    iput(ip);
    800034f6:	00000097          	auipc	ra,0x0
    800034fa:	a30080e7          	jalr	-1488(ra) # 80002f26 <iput>
    return -1;
    800034fe:	557d                	li	a0,-1
    80003500:	b7dd                	j	800034e6 <dirlink+0x86>
      panic("dirlink read");
    80003502:	00005517          	auipc	a0,0x5
    80003506:	10e50513          	addi	a0,a0,270 # 80008610 <syscalls+0x210>
    8000350a:	00003097          	auipc	ra,0x3
    8000350e:	8cc080e7          	jalr	-1844(ra) # 80005dd6 <panic>

0000000080003512 <namei>:

struct inode*
namei(char *path)
{
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000351a:	fe040613          	addi	a2,s0,-32
    8000351e:	4581                	li	a1,0
    80003520:	00000097          	auipc	ra,0x0
    80003524:	de0080e7          	jalr	-544(ra) # 80003300 <namex>
}
    80003528:	60e2                	ld	ra,24(sp)
    8000352a:	6442                	ld	s0,16(sp)
    8000352c:	6105                	addi	sp,sp,32
    8000352e:	8082                	ret

0000000080003530 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003530:	1141                	addi	sp,sp,-16
    80003532:	e406                	sd	ra,8(sp)
    80003534:	e022                	sd	s0,0(sp)
    80003536:	0800                	addi	s0,sp,16
    80003538:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000353a:	4585                	li	a1,1
    8000353c:	00000097          	auipc	ra,0x0
    80003540:	dc4080e7          	jalr	-572(ra) # 80003300 <namex>
}
    80003544:	60a2                	ld	ra,8(sp)
    80003546:	6402                	ld	s0,0(sp)
    80003548:	0141                	addi	sp,sp,16
    8000354a:	8082                	ret

000000008000354c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000354c:	1101                	addi	sp,sp,-32
    8000354e:	ec06                	sd	ra,24(sp)
    80003550:	e822                	sd	s0,16(sp)
    80003552:	e426                	sd	s1,8(sp)
    80003554:	e04a                	sd	s2,0(sp)
    80003556:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003558:	00015917          	auipc	s2,0x15
    8000355c:	5f890913          	addi	s2,s2,1528 # 80018b50 <log>
    80003560:	01892583          	lw	a1,24(s2)
    80003564:	02892503          	lw	a0,40(s2)
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	ff4080e7          	jalr	-12(ra) # 8000255c <bread>
    80003570:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003572:	02c92603          	lw	a2,44(s2)
    80003576:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003578:	00c05f63          	blez	a2,80003596 <write_head+0x4a>
    8000357c:	00015717          	auipc	a4,0x15
    80003580:	60470713          	addi	a4,a4,1540 # 80018b80 <log+0x30>
    80003584:	87aa                	mv	a5,a0
    80003586:	060a                	slli	a2,a2,0x2
    80003588:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000358a:	4314                	lw	a3,0(a4)
    8000358c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000358e:	0711                	addi	a4,a4,4
    80003590:	0791                	addi	a5,a5,4
    80003592:	fec79ce3          	bne	a5,a2,8000358a <write_head+0x3e>
  }
  bwrite(buf);
    80003596:	8526                	mv	a0,s1
    80003598:	fffff097          	auipc	ra,0xfffff
    8000359c:	0b6080e7          	jalr	182(ra) # 8000264e <bwrite>
  brelse(buf);
    800035a0:	8526                	mv	a0,s1
    800035a2:	fffff097          	auipc	ra,0xfffff
    800035a6:	0ea080e7          	jalr	234(ra) # 8000268c <brelse>
}
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6902                	ld	s2,0(sp)
    800035b2:	6105                	addi	sp,sp,32
    800035b4:	8082                	ret

00000000800035b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b6:	00015797          	auipc	a5,0x15
    800035ba:	5c67a783          	lw	a5,1478(a5) # 80018b7c <log+0x2c>
    800035be:	0af05d63          	blez	a5,80003678 <install_trans+0xc2>
{
    800035c2:	7139                	addi	sp,sp,-64
    800035c4:	fc06                	sd	ra,56(sp)
    800035c6:	f822                	sd	s0,48(sp)
    800035c8:	f426                	sd	s1,40(sp)
    800035ca:	f04a                	sd	s2,32(sp)
    800035cc:	ec4e                	sd	s3,24(sp)
    800035ce:	e852                	sd	s4,16(sp)
    800035d0:	e456                	sd	s5,8(sp)
    800035d2:	e05a                	sd	s6,0(sp)
    800035d4:	0080                	addi	s0,sp,64
    800035d6:	8b2a                	mv	s6,a0
    800035d8:	00015a97          	auipc	s5,0x15
    800035dc:	5a8a8a93          	addi	s5,s5,1448 # 80018b80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035e2:	00015997          	auipc	s3,0x15
    800035e6:	56e98993          	addi	s3,s3,1390 # 80018b50 <log>
    800035ea:	a00d                	j	8000360c <install_trans+0x56>
    brelse(lbuf);
    800035ec:	854a                	mv	a0,s2
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	09e080e7          	jalr	158(ra) # 8000268c <brelse>
    brelse(dbuf);
    800035f6:	8526                	mv	a0,s1
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	094080e7          	jalr	148(ra) # 8000268c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003600:	2a05                	addiw	s4,s4,1
    80003602:	0a91                	addi	s5,s5,4
    80003604:	02c9a783          	lw	a5,44(s3)
    80003608:	04fa5e63          	bge	s4,a5,80003664 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000360c:	0189a583          	lw	a1,24(s3)
    80003610:	014585bb          	addw	a1,a1,s4
    80003614:	2585                	addiw	a1,a1,1
    80003616:	0289a503          	lw	a0,40(s3)
    8000361a:	fffff097          	auipc	ra,0xfffff
    8000361e:	f42080e7          	jalr	-190(ra) # 8000255c <bread>
    80003622:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003624:	000aa583          	lw	a1,0(s5)
    80003628:	0289a503          	lw	a0,40(s3)
    8000362c:	fffff097          	auipc	ra,0xfffff
    80003630:	f30080e7          	jalr	-208(ra) # 8000255c <bread>
    80003634:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003636:	40000613          	li	a2,1024
    8000363a:	05890593          	addi	a1,s2,88
    8000363e:	05850513          	addi	a0,a0,88
    80003642:	ffffd097          	auipc	ra,0xffffd
    80003646:	b94080e7          	jalr	-1132(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	002080e7          	jalr	2(ra) # 8000264e <bwrite>
    if(recovering == 0)
    80003654:	f80b1ce3          	bnez	s6,800035ec <install_trans+0x36>
      bunpin(dbuf);
    80003658:	8526                	mv	a0,s1
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	10a080e7          	jalr	266(ra) # 80002764 <bunpin>
    80003662:	b769                	j	800035ec <install_trans+0x36>
}
    80003664:	70e2                	ld	ra,56(sp)
    80003666:	7442                	ld	s0,48(sp)
    80003668:	74a2                	ld	s1,40(sp)
    8000366a:	7902                	ld	s2,32(sp)
    8000366c:	69e2                	ld	s3,24(sp)
    8000366e:	6a42                	ld	s4,16(sp)
    80003670:	6aa2                	ld	s5,8(sp)
    80003672:	6b02                	ld	s6,0(sp)
    80003674:	6121                	addi	sp,sp,64
    80003676:	8082                	ret
    80003678:	8082                	ret

000000008000367a <initlog>:
{
    8000367a:	7179                	addi	sp,sp,-48
    8000367c:	f406                	sd	ra,40(sp)
    8000367e:	f022                	sd	s0,32(sp)
    80003680:	ec26                	sd	s1,24(sp)
    80003682:	e84a                	sd	s2,16(sp)
    80003684:	e44e                	sd	s3,8(sp)
    80003686:	1800                	addi	s0,sp,48
    80003688:	892a                	mv	s2,a0
    8000368a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000368c:	00015497          	auipc	s1,0x15
    80003690:	4c448493          	addi	s1,s1,1220 # 80018b50 <log>
    80003694:	00005597          	auipc	a1,0x5
    80003698:	f8c58593          	addi	a1,a1,-116 # 80008620 <syscalls+0x220>
    8000369c:	8526                	mv	a0,s1
    8000369e:	00003097          	auipc	ra,0x3
    800036a2:	be0080e7          	jalr	-1056(ra) # 8000627e <initlock>
  log.start = sb->logstart;
    800036a6:	0149a583          	lw	a1,20(s3)
    800036aa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036ac:	0109a783          	lw	a5,16(s3)
    800036b0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036b2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036b6:	854a                	mv	a0,s2
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	ea4080e7          	jalr	-348(ra) # 8000255c <bread>
  log.lh.n = lh->n;
    800036c0:	4d30                	lw	a2,88(a0)
    800036c2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036c4:	00c05f63          	blez	a2,800036e2 <initlog+0x68>
    800036c8:	87aa                	mv	a5,a0
    800036ca:	00015717          	auipc	a4,0x15
    800036ce:	4b670713          	addi	a4,a4,1206 # 80018b80 <log+0x30>
    800036d2:	060a                	slli	a2,a2,0x2
    800036d4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036d6:	4ff4                	lw	a3,92(a5)
    800036d8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036da:	0791                	addi	a5,a5,4
    800036dc:	0711                	addi	a4,a4,4
    800036de:	fec79ce3          	bne	a5,a2,800036d6 <initlog+0x5c>
  brelse(buf);
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	faa080e7          	jalr	-86(ra) # 8000268c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036ea:	4505                	li	a0,1
    800036ec:	00000097          	auipc	ra,0x0
    800036f0:	eca080e7          	jalr	-310(ra) # 800035b6 <install_trans>
  log.lh.n = 0;
    800036f4:	00015797          	auipc	a5,0x15
    800036f8:	4807a423          	sw	zero,1160(a5) # 80018b7c <log+0x2c>
  write_head(); // clear the log
    800036fc:	00000097          	auipc	ra,0x0
    80003700:	e50080e7          	jalr	-432(ra) # 8000354c <write_head>
}
    80003704:	70a2                	ld	ra,40(sp)
    80003706:	7402                	ld	s0,32(sp)
    80003708:	64e2                	ld	s1,24(sp)
    8000370a:	6942                	ld	s2,16(sp)
    8000370c:	69a2                	ld	s3,8(sp)
    8000370e:	6145                	addi	sp,sp,48
    80003710:	8082                	ret

0000000080003712 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003712:	1101                	addi	sp,sp,-32
    80003714:	ec06                	sd	ra,24(sp)
    80003716:	e822                	sd	s0,16(sp)
    80003718:	e426                	sd	s1,8(sp)
    8000371a:	e04a                	sd	s2,0(sp)
    8000371c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000371e:	00015517          	auipc	a0,0x15
    80003722:	43250513          	addi	a0,a0,1074 # 80018b50 <log>
    80003726:	00003097          	auipc	ra,0x3
    8000372a:	be8080e7          	jalr	-1048(ra) # 8000630e <acquire>
  while(1){
    if(log.committing){
    8000372e:	00015497          	auipc	s1,0x15
    80003732:	42248493          	addi	s1,s1,1058 # 80018b50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003736:	4979                	li	s2,30
    80003738:	a039                	j	80003746 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000373a:	85a6                	mv	a1,s1
    8000373c:	8526                	mv	a0,s1
    8000373e:	ffffe097          	auipc	ra,0xffffe
    80003742:	f60080e7          	jalr	-160(ra) # 8000169e <sleep>
    if(log.committing){
    80003746:	50dc                	lw	a5,36(s1)
    80003748:	fbed                	bnez	a5,8000373a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000374a:	5098                	lw	a4,32(s1)
    8000374c:	2705                	addiw	a4,a4,1
    8000374e:	0027179b          	slliw	a5,a4,0x2
    80003752:	9fb9                	addw	a5,a5,a4
    80003754:	0017979b          	slliw	a5,a5,0x1
    80003758:	54d4                	lw	a3,44(s1)
    8000375a:	9fb5                	addw	a5,a5,a3
    8000375c:	00f95963          	bge	s2,a5,8000376e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003760:	85a6                	mv	a1,s1
    80003762:	8526                	mv	a0,s1
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	f3a080e7          	jalr	-198(ra) # 8000169e <sleep>
    8000376c:	bfe9                	j	80003746 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000376e:	00015517          	auipc	a0,0x15
    80003772:	3e250513          	addi	a0,a0,994 # 80018b50 <log>
    80003776:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003778:	00003097          	auipc	ra,0x3
    8000377c:	c4a080e7          	jalr	-950(ra) # 800063c2 <release>
      break;
    }
  }
}
    80003780:	60e2                	ld	ra,24(sp)
    80003782:	6442                	ld	s0,16(sp)
    80003784:	64a2                	ld	s1,8(sp)
    80003786:	6902                	ld	s2,0(sp)
    80003788:	6105                	addi	sp,sp,32
    8000378a:	8082                	ret

000000008000378c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000378c:	7139                	addi	sp,sp,-64
    8000378e:	fc06                	sd	ra,56(sp)
    80003790:	f822                	sd	s0,48(sp)
    80003792:	f426                	sd	s1,40(sp)
    80003794:	f04a                	sd	s2,32(sp)
    80003796:	ec4e                	sd	s3,24(sp)
    80003798:	e852                	sd	s4,16(sp)
    8000379a:	e456                	sd	s5,8(sp)
    8000379c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000379e:	00015497          	auipc	s1,0x15
    800037a2:	3b248493          	addi	s1,s1,946 # 80018b50 <log>
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	b66080e7          	jalr	-1178(ra) # 8000630e <acquire>
  log.outstanding -= 1;
    800037b0:	509c                	lw	a5,32(s1)
    800037b2:	37fd                	addiw	a5,a5,-1
    800037b4:	0007891b          	sext.w	s2,a5
    800037b8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037ba:	50dc                	lw	a5,36(s1)
    800037bc:	e7b9                	bnez	a5,8000380a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037be:	04091e63          	bnez	s2,8000381a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037c2:	00015497          	auipc	s1,0x15
    800037c6:	38e48493          	addi	s1,s1,910 # 80018b50 <log>
    800037ca:	4785                	li	a5,1
    800037cc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037ce:	8526                	mv	a0,s1
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	bf2080e7          	jalr	-1038(ra) # 800063c2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037d8:	54dc                	lw	a5,44(s1)
    800037da:	06f04763          	bgtz	a5,80003848 <end_op+0xbc>
    acquire(&log.lock);
    800037de:	00015497          	auipc	s1,0x15
    800037e2:	37248493          	addi	s1,s1,882 # 80018b50 <log>
    800037e6:	8526                	mv	a0,s1
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	b26080e7          	jalr	-1242(ra) # 8000630e <acquire>
    log.committing = 0;
    800037f0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037f4:	8526                	mv	a0,s1
    800037f6:	ffffe097          	auipc	ra,0xffffe
    800037fa:	f0c080e7          	jalr	-244(ra) # 80001702 <wakeup>
    release(&log.lock);
    800037fe:	8526                	mv	a0,s1
    80003800:	00003097          	auipc	ra,0x3
    80003804:	bc2080e7          	jalr	-1086(ra) # 800063c2 <release>
}
    80003808:	a03d                	j	80003836 <end_op+0xaa>
    panic("log.committing");
    8000380a:	00005517          	auipc	a0,0x5
    8000380e:	e1e50513          	addi	a0,a0,-482 # 80008628 <syscalls+0x228>
    80003812:	00002097          	auipc	ra,0x2
    80003816:	5c4080e7          	jalr	1476(ra) # 80005dd6 <panic>
    wakeup(&log);
    8000381a:	00015497          	auipc	s1,0x15
    8000381e:	33648493          	addi	s1,s1,822 # 80018b50 <log>
    80003822:	8526                	mv	a0,s1
    80003824:	ffffe097          	auipc	ra,0xffffe
    80003828:	ede080e7          	jalr	-290(ra) # 80001702 <wakeup>
  release(&log.lock);
    8000382c:	8526                	mv	a0,s1
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	b94080e7          	jalr	-1132(ra) # 800063c2 <release>
}
    80003836:	70e2                	ld	ra,56(sp)
    80003838:	7442                	ld	s0,48(sp)
    8000383a:	74a2                	ld	s1,40(sp)
    8000383c:	7902                	ld	s2,32(sp)
    8000383e:	69e2                	ld	s3,24(sp)
    80003840:	6a42                	ld	s4,16(sp)
    80003842:	6aa2                	ld	s5,8(sp)
    80003844:	6121                	addi	sp,sp,64
    80003846:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003848:	00015a97          	auipc	s5,0x15
    8000384c:	338a8a93          	addi	s5,s5,824 # 80018b80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003850:	00015a17          	auipc	s4,0x15
    80003854:	300a0a13          	addi	s4,s4,768 # 80018b50 <log>
    80003858:	018a2583          	lw	a1,24(s4)
    8000385c:	012585bb          	addw	a1,a1,s2
    80003860:	2585                	addiw	a1,a1,1
    80003862:	028a2503          	lw	a0,40(s4)
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	cf6080e7          	jalr	-778(ra) # 8000255c <bread>
    8000386e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003870:	000aa583          	lw	a1,0(s5)
    80003874:	028a2503          	lw	a0,40(s4)
    80003878:	fffff097          	auipc	ra,0xfffff
    8000387c:	ce4080e7          	jalr	-796(ra) # 8000255c <bread>
    80003880:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003882:	40000613          	li	a2,1024
    80003886:	05850593          	addi	a1,a0,88
    8000388a:	05848513          	addi	a0,s1,88
    8000388e:	ffffd097          	auipc	ra,0xffffd
    80003892:	948080e7          	jalr	-1720(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003896:	8526                	mv	a0,s1
    80003898:	fffff097          	auipc	ra,0xfffff
    8000389c:	db6080e7          	jalr	-586(ra) # 8000264e <bwrite>
    brelse(from);
    800038a0:	854e                	mv	a0,s3
    800038a2:	fffff097          	auipc	ra,0xfffff
    800038a6:	dea080e7          	jalr	-534(ra) # 8000268c <brelse>
    brelse(to);
    800038aa:	8526                	mv	a0,s1
    800038ac:	fffff097          	auipc	ra,0xfffff
    800038b0:	de0080e7          	jalr	-544(ra) # 8000268c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038b4:	2905                	addiw	s2,s2,1
    800038b6:	0a91                	addi	s5,s5,4
    800038b8:	02ca2783          	lw	a5,44(s4)
    800038bc:	f8f94ee3          	blt	s2,a5,80003858 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038c0:	00000097          	auipc	ra,0x0
    800038c4:	c8c080e7          	jalr	-884(ra) # 8000354c <write_head>
    install_trans(0); // Now install writes to home locations
    800038c8:	4501                	li	a0,0
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	cec080e7          	jalr	-788(ra) # 800035b6 <install_trans>
    log.lh.n = 0;
    800038d2:	00015797          	auipc	a5,0x15
    800038d6:	2a07a523          	sw	zero,682(a5) # 80018b7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038da:	00000097          	auipc	ra,0x0
    800038de:	c72080e7          	jalr	-910(ra) # 8000354c <write_head>
    800038e2:	bdf5                	j	800037de <end_op+0x52>

00000000800038e4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038f2:	00015917          	auipc	s2,0x15
    800038f6:	25e90913          	addi	s2,s2,606 # 80018b50 <log>
    800038fa:	854a                	mv	a0,s2
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	a12080e7          	jalr	-1518(ra) # 8000630e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003904:	02c92603          	lw	a2,44(s2)
    80003908:	47f5                	li	a5,29
    8000390a:	06c7c563          	blt	a5,a2,80003974 <log_write+0x90>
    8000390e:	00015797          	auipc	a5,0x15
    80003912:	25e7a783          	lw	a5,606(a5) # 80018b6c <log+0x1c>
    80003916:	37fd                	addiw	a5,a5,-1
    80003918:	04f65e63          	bge	a2,a5,80003974 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000391c:	00015797          	auipc	a5,0x15
    80003920:	2547a783          	lw	a5,596(a5) # 80018b70 <log+0x20>
    80003924:	06f05063          	blez	a5,80003984 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003928:	4781                	li	a5,0
    8000392a:	06c05563          	blez	a2,80003994 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000392e:	44cc                	lw	a1,12(s1)
    80003930:	00015717          	auipc	a4,0x15
    80003934:	25070713          	addi	a4,a4,592 # 80018b80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003938:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000393a:	4314                	lw	a3,0(a4)
    8000393c:	04b68c63          	beq	a3,a1,80003994 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003940:	2785                	addiw	a5,a5,1
    80003942:	0711                	addi	a4,a4,4
    80003944:	fef61be3          	bne	a2,a5,8000393a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003948:	0621                	addi	a2,a2,8
    8000394a:	060a                	slli	a2,a2,0x2
    8000394c:	00015797          	auipc	a5,0x15
    80003950:	20478793          	addi	a5,a5,516 # 80018b50 <log>
    80003954:	97b2                	add	a5,a5,a2
    80003956:	44d8                	lw	a4,12(s1)
    80003958:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000395a:	8526                	mv	a0,s1
    8000395c:	fffff097          	auipc	ra,0xfffff
    80003960:	dcc080e7          	jalr	-564(ra) # 80002728 <bpin>
    log.lh.n++;
    80003964:	00015717          	auipc	a4,0x15
    80003968:	1ec70713          	addi	a4,a4,492 # 80018b50 <log>
    8000396c:	575c                	lw	a5,44(a4)
    8000396e:	2785                	addiw	a5,a5,1
    80003970:	d75c                	sw	a5,44(a4)
    80003972:	a82d                	j	800039ac <log_write+0xc8>
    panic("too big a transaction");
    80003974:	00005517          	auipc	a0,0x5
    80003978:	cc450513          	addi	a0,a0,-828 # 80008638 <syscalls+0x238>
    8000397c:	00002097          	auipc	ra,0x2
    80003980:	45a080e7          	jalr	1114(ra) # 80005dd6 <panic>
    panic("log_write outside of trans");
    80003984:	00005517          	auipc	a0,0x5
    80003988:	ccc50513          	addi	a0,a0,-820 # 80008650 <syscalls+0x250>
    8000398c:	00002097          	auipc	ra,0x2
    80003990:	44a080e7          	jalr	1098(ra) # 80005dd6 <panic>
  log.lh.block[i] = b->blockno;
    80003994:	00878693          	addi	a3,a5,8
    80003998:	068a                	slli	a3,a3,0x2
    8000399a:	00015717          	auipc	a4,0x15
    8000399e:	1b670713          	addi	a4,a4,438 # 80018b50 <log>
    800039a2:	9736                	add	a4,a4,a3
    800039a4:	44d4                	lw	a3,12(s1)
    800039a6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039a8:	faf609e3          	beq	a2,a5,8000395a <log_write+0x76>
  }
  release(&log.lock);
    800039ac:	00015517          	auipc	a0,0x15
    800039b0:	1a450513          	addi	a0,a0,420 # 80018b50 <log>
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	a0e080e7          	jalr	-1522(ra) # 800063c2 <release>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret

00000000800039c8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	e04a                	sd	s2,0(sp)
    800039d2:	1000                	addi	s0,sp,32
    800039d4:	84aa                	mv	s1,a0
    800039d6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039d8:	00005597          	auipc	a1,0x5
    800039dc:	c9858593          	addi	a1,a1,-872 # 80008670 <syscalls+0x270>
    800039e0:	0521                	addi	a0,a0,8
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	89c080e7          	jalr	-1892(ra) # 8000627e <initlock>
  lk->name = name;
    800039ea:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039ee:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039f2:	0204a423          	sw	zero,40(s1)
}
    800039f6:	60e2                	ld	ra,24(sp)
    800039f8:	6442                	ld	s0,16(sp)
    800039fa:	64a2                	ld	s1,8(sp)
    800039fc:	6902                	ld	s2,0(sp)
    800039fe:	6105                	addi	sp,sp,32
    80003a00:	8082                	ret

0000000080003a02 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a02:	1101                	addi	sp,sp,-32
    80003a04:	ec06                	sd	ra,24(sp)
    80003a06:	e822                	sd	s0,16(sp)
    80003a08:	e426                	sd	s1,8(sp)
    80003a0a:	e04a                	sd	s2,0(sp)
    80003a0c:	1000                	addi	s0,sp,32
    80003a0e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a10:	00850913          	addi	s2,a0,8
    80003a14:	854a                	mv	a0,s2
    80003a16:	00003097          	auipc	ra,0x3
    80003a1a:	8f8080e7          	jalr	-1800(ra) # 8000630e <acquire>
  while (lk->locked) {
    80003a1e:	409c                	lw	a5,0(s1)
    80003a20:	cb89                	beqz	a5,80003a32 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a22:	85ca                	mv	a1,s2
    80003a24:	8526                	mv	a0,s1
    80003a26:	ffffe097          	auipc	ra,0xffffe
    80003a2a:	c78080e7          	jalr	-904(ra) # 8000169e <sleep>
  while (lk->locked) {
    80003a2e:	409c                	lw	a5,0(s1)
    80003a30:	fbed                	bnez	a5,80003a22 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a32:	4785                	li	a5,1
    80003a34:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	512080e7          	jalr	1298(ra) # 80000f48 <myproc>
    80003a3e:	591c                	lw	a5,48(a0)
    80003a40:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a42:	854a                	mv	a0,s2
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	97e080e7          	jalr	-1666(ra) # 800063c2 <release>
}
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6902                	ld	s2,0(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a58:	1101                	addi	sp,sp,-32
    80003a5a:	ec06                	sd	ra,24(sp)
    80003a5c:	e822                	sd	s0,16(sp)
    80003a5e:	e426                	sd	s1,8(sp)
    80003a60:	e04a                	sd	s2,0(sp)
    80003a62:	1000                	addi	s0,sp,32
    80003a64:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a66:	00850913          	addi	s2,a0,8
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	8a2080e7          	jalr	-1886(ra) # 8000630e <acquire>
  lk->locked = 0;
    80003a74:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a78:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a7c:	8526                	mv	a0,s1
    80003a7e:	ffffe097          	auipc	ra,0xffffe
    80003a82:	c84080e7          	jalr	-892(ra) # 80001702 <wakeup>
  release(&lk->lk);
    80003a86:	854a                	mv	a0,s2
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	93a080e7          	jalr	-1734(ra) # 800063c2 <release>
}
    80003a90:	60e2                	ld	ra,24(sp)
    80003a92:	6442                	ld	s0,16(sp)
    80003a94:	64a2                	ld	s1,8(sp)
    80003a96:	6902                	ld	s2,0(sp)
    80003a98:	6105                	addi	sp,sp,32
    80003a9a:	8082                	ret

0000000080003a9c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a9c:	7179                	addi	sp,sp,-48
    80003a9e:	f406                	sd	ra,40(sp)
    80003aa0:	f022                	sd	s0,32(sp)
    80003aa2:	ec26                	sd	s1,24(sp)
    80003aa4:	e84a                	sd	s2,16(sp)
    80003aa6:	e44e                	sd	s3,8(sp)
    80003aa8:	1800                	addi	s0,sp,48
    80003aaa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aac:	00850913          	addi	s2,a0,8
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	85c080e7          	jalr	-1956(ra) # 8000630e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aba:	409c                	lw	a5,0(s1)
    80003abc:	ef99                	bnez	a5,80003ada <holdingsleep+0x3e>
    80003abe:	4481                	li	s1,0
  release(&lk->lk);
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	900080e7          	jalr	-1792(ra) # 800063c2 <release>
  return r;
}
    80003aca:	8526                	mv	a0,s1
    80003acc:	70a2                	ld	ra,40(sp)
    80003ace:	7402                	ld	s0,32(sp)
    80003ad0:	64e2                	ld	s1,24(sp)
    80003ad2:	6942                	ld	s2,16(sp)
    80003ad4:	69a2                	ld	s3,8(sp)
    80003ad6:	6145                	addi	sp,sp,48
    80003ad8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ada:	0284a983          	lw	s3,40(s1)
    80003ade:	ffffd097          	auipc	ra,0xffffd
    80003ae2:	46a080e7          	jalr	1130(ra) # 80000f48 <myproc>
    80003ae6:	5904                	lw	s1,48(a0)
    80003ae8:	413484b3          	sub	s1,s1,s3
    80003aec:	0014b493          	seqz	s1,s1
    80003af0:	bfc1                	j	80003ac0 <holdingsleep+0x24>

0000000080003af2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003af2:	1141                	addi	sp,sp,-16
    80003af4:	e406                	sd	ra,8(sp)
    80003af6:	e022                	sd	s0,0(sp)
    80003af8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003afa:	00005597          	auipc	a1,0x5
    80003afe:	b8658593          	addi	a1,a1,-1146 # 80008680 <syscalls+0x280>
    80003b02:	00015517          	auipc	a0,0x15
    80003b06:	19650513          	addi	a0,a0,406 # 80018c98 <ftable>
    80003b0a:	00002097          	auipc	ra,0x2
    80003b0e:	774080e7          	jalr	1908(ra) # 8000627e <initlock>
}
    80003b12:	60a2                	ld	ra,8(sp)
    80003b14:	6402                	ld	s0,0(sp)
    80003b16:	0141                	addi	sp,sp,16
    80003b18:	8082                	ret

0000000080003b1a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b1a:	1101                	addi	sp,sp,-32
    80003b1c:	ec06                	sd	ra,24(sp)
    80003b1e:	e822                	sd	s0,16(sp)
    80003b20:	e426                	sd	s1,8(sp)
    80003b22:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b24:	00015517          	auipc	a0,0x15
    80003b28:	17450513          	addi	a0,a0,372 # 80018c98 <ftable>
    80003b2c:	00002097          	auipc	ra,0x2
    80003b30:	7e2080e7          	jalr	2018(ra) # 8000630e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b34:	00015497          	auipc	s1,0x15
    80003b38:	17c48493          	addi	s1,s1,380 # 80018cb0 <ftable+0x18>
    80003b3c:	00016717          	auipc	a4,0x16
    80003b40:	11470713          	addi	a4,a4,276 # 80019c50 <disk>
    if(f->ref == 0){
    80003b44:	40dc                	lw	a5,4(s1)
    80003b46:	cf99                	beqz	a5,80003b64 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b48:	02848493          	addi	s1,s1,40
    80003b4c:	fee49ce3          	bne	s1,a4,80003b44 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b50:	00015517          	auipc	a0,0x15
    80003b54:	14850513          	addi	a0,a0,328 # 80018c98 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	86a080e7          	jalr	-1942(ra) # 800063c2 <release>
  return 0;
    80003b60:	4481                	li	s1,0
    80003b62:	a819                	j	80003b78 <filealloc+0x5e>
      f->ref = 1;
    80003b64:	4785                	li	a5,1
    80003b66:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b68:	00015517          	auipc	a0,0x15
    80003b6c:	13050513          	addi	a0,a0,304 # 80018c98 <ftable>
    80003b70:	00003097          	auipc	ra,0x3
    80003b74:	852080e7          	jalr	-1966(ra) # 800063c2 <release>
}
    80003b78:	8526                	mv	a0,s1
    80003b7a:	60e2                	ld	ra,24(sp)
    80003b7c:	6442                	ld	s0,16(sp)
    80003b7e:	64a2                	ld	s1,8(sp)
    80003b80:	6105                	addi	sp,sp,32
    80003b82:	8082                	ret

0000000080003b84 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b84:	1101                	addi	sp,sp,-32
    80003b86:	ec06                	sd	ra,24(sp)
    80003b88:	e822                	sd	s0,16(sp)
    80003b8a:	e426                	sd	s1,8(sp)
    80003b8c:	1000                	addi	s0,sp,32
    80003b8e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b90:	00015517          	auipc	a0,0x15
    80003b94:	10850513          	addi	a0,a0,264 # 80018c98 <ftable>
    80003b98:	00002097          	auipc	ra,0x2
    80003b9c:	776080e7          	jalr	1910(ra) # 8000630e <acquire>
  if(f->ref < 1)
    80003ba0:	40dc                	lw	a5,4(s1)
    80003ba2:	02f05263          	blez	a5,80003bc6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ba6:	2785                	addiw	a5,a5,1
    80003ba8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003baa:	00015517          	auipc	a0,0x15
    80003bae:	0ee50513          	addi	a0,a0,238 # 80018c98 <ftable>
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	810080e7          	jalr	-2032(ra) # 800063c2 <release>
  return f;
}
    80003bba:	8526                	mv	a0,s1
    80003bbc:	60e2                	ld	ra,24(sp)
    80003bbe:	6442                	ld	s0,16(sp)
    80003bc0:	64a2                	ld	s1,8(sp)
    80003bc2:	6105                	addi	sp,sp,32
    80003bc4:	8082                	ret
    panic("filedup");
    80003bc6:	00005517          	auipc	a0,0x5
    80003bca:	ac250513          	addi	a0,a0,-1342 # 80008688 <syscalls+0x288>
    80003bce:	00002097          	auipc	ra,0x2
    80003bd2:	208080e7          	jalr	520(ra) # 80005dd6 <panic>

0000000080003bd6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bd6:	7139                	addi	sp,sp,-64
    80003bd8:	fc06                	sd	ra,56(sp)
    80003bda:	f822                	sd	s0,48(sp)
    80003bdc:	f426                	sd	s1,40(sp)
    80003bde:	f04a                	sd	s2,32(sp)
    80003be0:	ec4e                	sd	s3,24(sp)
    80003be2:	e852                	sd	s4,16(sp)
    80003be4:	e456                	sd	s5,8(sp)
    80003be6:	0080                	addi	s0,sp,64
    80003be8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bea:	00015517          	auipc	a0,0x15
    80003bee:	0ae50513          	addi	a0,a0,174 # 80018c98 <ftable>
    80003bf2:	00002097          	auipc	ra,0x2
    80003bf6:	71c080e7          	jalr	1820(ra) # 8000630e <acquire>
  if(f->ref < 1)
    80003bfa:	40dc                	lw	a5,4(s1)
    80003bfc:	06f05163          	blez	a5,80003c5e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c00:	37fd                	addiw	a5,a5,-1
    80003c02:	0007871b          	sext.w	a4,a5
    80003c06:	c0dc                	sw	a5,4(s1)
    80003c08:	06e04363          	bgtz	a4,80003c6e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c0c:	0004a903          	lw	s2,0(s1)
    80003c10:	0094ca83          	lbu	s5,9(s1)
    80003c14:	0104ba03          	ld	s4,16(s1)
    80003c18:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c1c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c20:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c24:	00015517          	auipc	a0,0x15
    80003c28:	07450513          	addi	a0,a0,116 # 80018c98 <ftable>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	796080e7          	jalr	1942(ra) # 800063c2 <release>

  if(ff.type == FD_PIPE){
    80003c34:	4785                	li	a5,1
    80003c36:	04f90d63          	beq	s2,a5,80003c90 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c3a:	3979                	addiw	s2,s2,-2
    80003c3c:	4785                	li	a5,1
    80003c3e:	0527e063          	bltu	a5,s2,80003c7e <fileclose+0xa8>
    begin_op();
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	ad0080e7          	jalr	-1328(ra) # 80003712 <begin_op>
    iput(ff.ip);
    80003c4a:	854e                	mv	a0,s3
    80003c4c:	fffff097          	auipc	ra,0xfffff
    80003c50:	2da080e7          	jalr	730(ra) # 80002f26 <iput>
    end_op();
    80003c54:	00000097          	auipc	ra,0x0
    80003c58:	b38080e7          	jalr	-1224(ra) # 8000378c <end_op>
    80003c5c:	a00d                	j	80003c7e <fileclose+0xa8>
    panic("fileclose");
    80003c5e:	00005517          	auipc	a0,0x5
    80003c62:	a3250513          	addi	a0,a0,-1486 # 80008690 <syscalls+0x290>
    80003c66:	00002097          	auipc	ra,0x2
    80003c6a:	170080e7          	jalr	368(ra) # 80005dd6 <panic>
    release(&ftable.lock);
    80003c6e:	00015517          	auipc	a0,0x15
    80003c72:	02a50513          	addi	a0,a0,42 # 80018c98 <ftable>
    80003c76:	00002097          	auipc	ra,0x2
    80003c7a:	74c080e7          	jalr	1868(ra) # 800063c2 <release>
  }
}
    80003c7e:	70e2                	ld	ra,56(sp)
    80003c80:	7442                	ld	s0,48(sp)
    80003c82:	74a2                	ld	s1,40(sp)
    80003c84:	7902                	ld	s2,32(sp)
    80003c86:	69e2                	ld	s3,24(sp)
    80003c88:	6a42                	ld	s4,16(sp)
    80003c8a:	6aa2                	ld	s5,8(sp)
    80003c8c:	6121                	addi	sp,sp,64
    80003c8e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c90:	85d6                	mv	a1,s5
    80003c92:	8552                	mv	a0,s4
    80003c94:	00000097          	auipc	ra,0x0
    80003c98:	348080e7          	jalr	840(ra) # 80003fdc <pipeclose>
    80003c9c:	b7cd                	j	80003c7e <fileclose+0xa8>

0000000080003c9e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c9e:	715d                	addi	sp,sp,-80
    80003ca0:	e486                	sd	ra,72(sp)
    80003ca2:	e0a2                	sd	s0,64(sp)
    80003ca4:	fc26                	sd	s1,56(sp)
    80003ca6:	f84a                	sd	s2,48(sp)
    80003ca8:	f44e                	sd	s3,40(sp)
    80003caa:	0880                	addi	s0,sp,80
    80003cac:	84aa                	mv	s1,a0
    80003cae:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cb0:	ffffd097          	auipc	ra,0xffffd
    80003cb4:	298080e7          	jalr	664(ra) # 80000f48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cb8:	409c                	lw	a5,0(s1)
    80003cba:	37f9                	addiw	a5,a5,-2
    80003cbc:	4705                	li	a4,1
    80003cbe:	04f76763          	bltu	a4,a5,80003d0c <filestat+0x6e>
    80003cc2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cc4:	6c88                	ld	a0,24(s1)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	0a6080e7          	jalr	166(ra) # 80002d6c <ilock>
    stati(f->ip, &st);
    80003cce:	fb840593          	addi	a1,s0,-72
    80003cd2:	6c88                	ld	a0,24(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	322080e7          	jalr	802(ra) # 80002ff6 <stati>
    iunlock(f->ip);
    80003cdc:	6c88                	ld	a0,24(s1)
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	150080e7          	jalr	336(ra) # 80002e2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ce6:	46e1                	li	a3,24
    80003ce8:	fb840613          	addi	a2,s0,-72
    80003cec:	85ce                	mv	a1,s3
    80003cee:	05093503          	ld	a0,80(s2)
    80003cf2:	ffffd097          	auipc	ra,0xffffd
    80003cf6:	e20080e7          	jalr	-480(ra) # 80000b12 <copyout>
    80003cfa:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cfe:	60a6                	ld	ra,72(sp)
    80003d00:	6406                	ld	s0,64(sp)
    80003d02:	74e2                	ld	s1,56(sp)
    80003d04:	7942                	ld	s2,48(sp)
    80003d06:	79a2                	ld	s3,40(sp)
    80003d08:	6161                	addi	sp,sp,80
    80003d0a:	8082                	ret
  return -1;
    80003d0c:	557d                	li	a0,-1
    80003d0e:	bfc5                	j	80003cfe <filestat+0x60>

0000000080003d10 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d10:	7179                	addi	sp,sp,-48
    80003d12:	f406                	sd	ra,40(sp)
    80003d14:	f022                	sd	s0,32(sp)
    80003d16:	ec26                	sd	s1,24(sp)
    80003d18:	e84a                	sd	s2,16(sp)
    80003d1a:	e44e                	sd	s3,8(sp)
    80003d1c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d1e:	00854783          	lbu	a5,8(a0)
    80003d22:	c3d5                	beqz	a5,80003dc6 <fileread+0xb6>
    80003d24:	84aa                	mv	s1,a0
    80003d26:	89ae                	mv	s3,a1
    80003d28:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d2a:	411c                	lw	a5,0(a0)
    80003d2c:	4705                	li	a4,1
    80003d2e:	04e78963          	beq	a5,a4,80003d80 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d32:	470d                	li	a4,3
    80003d34:	04e78d63          	beq	a5,a4,80003d8e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d38:	4709                	li	a4,2
    80003d3a:	06e79e63          	bne	a5,a4,80003db6 <fileread+0xa6>
    ilock(f->ip);
    80003d3e:	6d08                	ld	a0,24(a0)
    80003d40:	fffff097          	auipc	ra,0xfffff
    80003d44:	02c080e7          	jalr	44(ra) # 80002d6c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d48:	874a                	mv	a4,s2
    80003d4a:	5094                	lw	a3,32(s1)
    80003d4c:	864e                	mv	a2,s3
    80003d4e:	4585                	li	a1,1
    80003d50:	6c88                	ld	a0,24(s1)
    80003d52:	fffff097          	auipc	ra,0xfffff
    80003d56:	2ce080e7          	jalr	718(ra) # 80003020 <readi>
    80003d5a:	892a                	mv	s2,a0
    80003d5c:	00a05563          	blez	a0,80003d66 <fileread+0x56>
      f->off += r;
    80003d60:	509c                	lw	a5,32(s1)
    80003d62:	9fa9                	addw	a5,a5,a0
    80003d64:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d66:	6c88                	ld	a0,24(s1)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	0c6080e7          	jalr	198(ra) # 80002e2e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d70:	854a                	mv	a0,s2
    80003d72:	70a2                	ld	ra,40(sp)
    80003d74:	7402                	ld	s0,32(sp)
    80003d76:	64e2                	ld	s1,24(sp)
    80003d78:	6942                	ld	s2,16(sp)
    80003d7a:	69a2                	ld	s3,8(sp)
    80003d7c:	6145                	addi	sp,sp,48
    80003d7e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d80:	6908                	ld	a0,16(a0)
    80003d82:	00000097          	auipc	ra,0x0
    80003d86:	3c2080e7          	jalr	962(ra) # 80004144 <piperead>
    80003d8a:	892a                	mv	s2,a0
    80003d8c:	b7d5                	j	80003d70 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d8e:	02451783          	lh	a5,36(a0)
    80003d92:	03079693          	slli	a3,a5,0x30
    80003d96:	92c1                	srli	a3,a3,0x30
    80003d98:	4725                	li	a4,9
    80003d9a:	02d76863          	bltu	a4,a3,80003dca <fileread+0xba>
    80003d9e:	0792                	slli	a5,a5,0x4
    80003da0:	00015717          	auipc	a4,0x15
    80003da4:	e5870713          	addi	a4,a4,-424 # 80018bf8 <devsw>
    80003da8:	97ba                	add	a5,a5,a4
    80003daa:	639c                	ld	a5,0(a5)
    80003dac:	c38d                	beqz	a5,80003dce <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dae:	4505                	li	a0,1
    80003db0:	9782                	jalr	a5
    80003db2:	892a                	mv	s2,a0
    80003db4:	bf75                	j	80003d70 <fileread+0x60>
    panic("fileread");
    80003db6:	00005517          	auipc	a0,0x5
    80003dba:	8ea50513          	addi	a0,a0,-1814 # 800086a0 <syscalls+0x2a0>
    80003dbe:	00002097          	auipc	ra,0x2
    80003dc2:	018080e7          	jalr	24(ra) # 80005dd6 <panic>
    return -1;
    80003dc6:	597d                	li	s2,-1
    80003dc8:	b765                	j	80003d70 <fileread+0x60>
      return -1;
    80003dca:	597d                	li	s2,-1
    80003dcc:	b755                	j	80003d70 <fileread+0x60>
    80003dce:	597d                	li	s2,-1
    80003dd0:	b745                	j	80003d70 <fileread+0x60>

0000000080003dd2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dd2:	00954783          	lbu	a5,9(a0)
    80003dd6:	10078e63          	beqz	a5,80003ef2 <filewrite+0x120>
{
    80003dda:	715d                	addi	sp,sp,-80
    80003ddc:	e486                	sd	ra,72(sp)
    80003dde:	e0a2                	sd	s0,64(sp)
    80003de0:	fc26                	sd	s1,56(sp)
    80003de2:	f84a                	sd	s2,48(sp)
    80003de4:	f44e                	sd	s3,40(sp)
    80003de6:	f052                	sd	s4,32(sp)
    80003de8:	ec56                	sd	s5,24(sp)
    80003dea:	e85a                	sd	s6,16(sp)
    80003dec:	e45e                	sd	s7,8(sp)
    80003dee:	e062                	sd	s8,0(sp)
    80003df0:	0880                	addi	s0,sp,80
    80003df2:	892a                	mv	s2,a0
    80003df4:	8b2e                	mv	s6,a1
    80003df6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003df8:	411c                	lw	a5,0(a0)
    80003dfa:	4705                	li	a4,1
    80003dfc:	02e78263          	beq	a5,a4,80003e20 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e00:	470d                	li	a4,3
    80003e02:	02e78563          	beq	a5,a4,80003e2c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e06:	4709                	li	a4,2
    80003e08:	0ce79d63          	bne	a5,a4,80003ee2 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e0c:	0ac05b63          	blez	a2,80003ec2 <filewrite+0xf0>
    int i = 0;
    80003e10:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e12:	6b85                	lui	s7,0x1
    80003e14:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e18:	6c05                	lui	s8,0x1
    80003e1a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e1e:	a851                	j	80003eb2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e20:	6908                	ld	a0,16(a0)
    80003e22:	00000097          	auipc	ra,0x0
    80003e26:	22a080e7          	jalr	554(ra) # 8000404c <pipewrite>
    80003e2a:	a045                	j	80003eca <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e2c:	02451783          	lh	a5,36(a0)
    80003e30:	03079693          	slli	a3,a5,0x30
    80003e34:	92c1                	srli	a3,a3,0x30
    80003e36:	4725                	li	a4,9
    80003e38:	0ad76f63          	bltu	a4,a3,80003ef6 <filewrite+0x124>
    80003e3c:	0792                	slli	a5,a5,0x4
    80003e3e:	00015717          	auipc	a4,0x15
    80003e42:	dba70713          	addi	a4,a4,-582 # 80018bf8 <devsw>
    80003e46:	97ba                	add	a5,a5,a4
    80003e48:	679c                	ld	a5,8(a5)
    80003e4a:	cbc5                	beqz	a5,80003efa <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003e4c:	4505                	li	a0,1
    80003e4e:	9782                	jalr	a5
    80003e50:	a8ad                	j	80003eca <filewrite+0xf8>
      if(n1 > max)
    80003e52:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	8bc080e7          	jalr	-1860(ra) # 80003712 <begin_op>
      ilock(f->ip);
    80003e5e:	01893503          	ld	a0,24(s2)
    80003e62:	fffff097          	auipc	ra,0xfffff
    80003e66:	f0a080e7          	jalr	-246(ra) # 80002d6c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e6a:	8756                	mv	a4,s5
    80003e6c:	02092683          	lw	a3,32(s2)
    80003e70:	01698633          	add	a2,s3,s6
    80003e74:	4585                	li	a1,1
    80003e76:	01893503          	ld	a0,24(s2)
    80003e7a:	fffff097          	auipc	ra,0xfffff
    80003e7e:	29e080e7          	jalr	670(ra) # 80003118 <writei>
    80003e82:	84aa                	mv	s1,a0
    80003e84:	00a05763          	blez	a0,80003e92 <filewrite+0xc0>
        f->off += r;
    80003e88:	02092783          	lw	a5,32(s2)
    80003e8c:	9fa9                	addw	a5,a5,a0
    80003e8e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e92:	01893503          	ld	a0,24(s2)
    80003e96:	fffff097          	auipc	ra,0xfffff
    80003e9a:	f98080e7          	jalr	-104(ra) # 80002e2e <iunlock>
      end_op();
    80003e9e:	00000097          	auipc	ra,0x0
    80003ea2:	8ee080e7          	jalr	-1810(ra) # 8000378c <end_op>

      if(r != n1){
    80003ea6:	009a9f63          	bne	s5,s1,80003ec4 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003eaa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eae:	0149db63          	bge	s3,s4,80003ec4 <filewrite+0xf2>
      int n1 = n - i;
    80003eb2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003eb6:	0004879b          	sext.w	a5,s1
    80003eba:	f8fbdce3          	bge	s7,a5,80003e52 <filewrite+0x80>
    80003ebe:	84e2                	mv	s1,s8
    80003ec0:	bf49                	j	80003e52 <filewrite+0x80>
    int i = 0;
    80003ec2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ec4:	033a1d63          	bne	s4,s3,80003efe <filewrite+0x12c>
    80003ec8:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eca:	60a6                	ld	ra,72(sp)
    80003ecc:	6406                	ld	s0,64(sp)
    80003ece:	74e2                	ld	s1,56(sp)
    80003ed0:	7942                	ld	s2,48(sp)
    80003ed2:	79a2                	ld	s3,40(sp)
    80003ed4:	7a02                	ld	s4,32(sp)
    80003ed6:	6ae2                	ld	s5,24(sp)
    80003ed8:	6b42                	ld	s6,16(sp)
    80003eda:	6ba2                	ld	s7,8(sp)
    80003edc:	6c02                	ld	s8,0(sp)
    80003ede:	6161                	addi	sp,sp,80
    80003ee0:	8082                	ret
    panic("filewrite");
    80003ee2:	00004517          	auipc	a0,0x4
    80003ee6:	7ce50513          	addi	a0,a0,1998 # 800086b0 <syscalls+0x2b0>
    80003eea:	00002097          	auipc	ra,0x2
    80003eee:	eec080e7          	jalr	-276(ra) # 80005dd6 <panic>
    return -1;
    80003ef2:	557d                	li	a0,-1
}
    80003ef4:	8082                	ret
      return -1;
    80003ef6:	557d                	li	a0,-1
    80003ef8:	bfc9                	j	80003eca <filewrite+0xf8>
    80003efa:	557d                	li	a0,-1
    80003efc:	b7f9                	j	80003eca <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003efe:	557d                	li	a0,-1
    80003f00:	b7e9                	j	80003eca <filewrite+0xf8>

0000000080003f02 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f02:	7179                	addi	sp,sp,-48
    80003f04:	f406                	sd	ra,40(sp)
    80003f06:	f022                	sd	s0,32(sp)
    80003f08:	ec26                	sd	s1,24(sp)
    80003f0a:	e84a                	sd	s2,16(sp)
    80003f0c:	e44e                	sd	s3,8(sp)
    80003f0e:	e052                	sd	s4,0(sp)
    80003f10:	1800                	addi	s0,sp,48
    80003f12:	84aa                	mv	s1,a0
    80003f14:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f16:	0005b023          	sd	zero,0(a1)
    80003f1a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f1e:	00000097          	auipc	ra,0x0
    80003f22:	bfc080e7          	jalr	-1028(ra) # 80003b1a <filealloc>
    80003f26:	e088                	sd	a0,0(s1)
    80003f28:	c551                	beqz	a0,80003fb4 <pipealloc+0xb2>
    80003f2a:	00000097          	auipc	ra,0x0
    80003f2e:	bf0080e7          	jalr	-1040(ra) # 80003b1a <filealloc>
    80003f32:	00aa3023          	sd	a0,0(s4)
    80003f36:	c92d                	beqz	a0,80003fa8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f38:	ffffc097          	auipc	ra,0xffffc
    80003f3c:	1e2080e7          	jalr	482(ra) # 8000011a <kalloc>
    80003f40:	892a                	mv	s2,a0
    80003f42:	c125                	beqz	a0,80003fa2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f44:	4985                	li	s3,1
    80003f46:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f4a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f4e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f52:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f56:	00004597          	auipc	a1,0x4
    80003f5a:	76a58593          	addi	a1,a1,1898 # 800086c0 <syscalls+0x2c0>
    80003f5e:	00002097          	auipc	ra,0x2
    80003f62:	320080e7          	jalr	800(ra) # 8000627e <initlock>
  (*f0)->type = FD_PIPE;
    80003f66:	609c                	ld	a5,0(s1)
    80003f68:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f6c:	609c                	ld	a5,0(s1)
    80003f6e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f72:	609c                	ld	a5,0(s1)
    80003f74:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f78:	609c                	ld	a5,0(s1)
    80003f7a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f7e:	000a3783          	ld	a5,0(s4)
    80003f82:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f86:	000a3783          	ld	a5,0(s4)
    80003f8a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f8e:	000a3783          	ld	a5,0(s4)
    80003f92:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f96:	000a3783          	ld	a5,0(s4)
    80003f9a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f9e:	4501                	li	a0,0
    80003fa0:	a025                	j	80003fc8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fa2:	6088                	ld	a0,0(s1)
    80003fa4:	e501                	bnez	a0,80003fac <pipealloc+0xaa>
    80003fa6:	a039                	j	80003fb4 <pipealloc+0xb2>
    80003fa8:	6088                	ld	a0,0(s1)
    80003faa:	c51d                	beqz	a0,80003fd8 <pipealloc+0xd6>
    fileclose(*f0);
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	c2a080e7          	jalr	-982(ra) # 80003bd6 <fileclose>
  if(*f1)
    80003fb4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fb8:	557d                	li	a0,-1
  if(*f1)
    80003fba:	c799                	beqz	a5,80003fc8 <pipealloc+0xc6>
    fileclose(*f1);
    80003fbc:	853e                	mv	a0,a5
    80003fbe:	00000097          	auipc	ra,0x0
    80003fc2:	c18080e7          	jalr	-1000(ra) # 80003bd6 <fileclose>
  return -1;
    80003fc6:	557d                	li	a0,-1
}
    80003fc8:	70a2                	ld	ra,40(sp)
    80003fca:	7402                	ld	s0,32(sp)
    80003fcc:	64e2                	ld	s1,24(sp)
    80003fce:	6942                	ld	s2,16(sp)
    80003fd0:	69a2                	ld	s3,8(sp)
    80003fd2:	6a02                	ld	s4,0(sp)
    80003fd4:	6145                	addi	sp,sp,48
    80003fd6:	8082                	ret
  return -1;
    80003fd8:	557d                	li	a0,-1
    80003fda:	b7fd                	j	80003fc8 <pipealloc+0xc6>

0000000080003fdc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fdc:	1101                	addi	sp,sp,-32
    80003fde:	ec06                	sd	ra,24(sp)
    80003fe0:	e822                	sd	s0,16(sp)
    80003fe2:	e426                	sd	s1,8(sp)
    80003fe4:	e04a                	sd	s2,0(sp)
    80003fe6:	1000                	addi	s0,sp,32
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	322080e7          	jalr	802(ra) # 8000630e <acquire>
  if(writable){
    80003ff4:	02090d63          	beqz	s2,8000402e <pipeclose+0x52>
    pi->writeopen = 0;
    80003ff8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ffc:	21848513          	addi	a0,s1,536
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	702080e7          	jalr	1794(ra) # 80001702 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004008:	2204b783          	ld	a5,544(s1)
    8000400c:	eb95                	bnez	a5,80004040 <pipeclose+0x64>
    release(&pi->lock);
    8000400e:	8526                	mv	a0,s1
    80004010:	00002097          	auipc	ra,0x2
    80004014:	3b2080e7          	jalr	946(ra) # 800063c2 <release>
    kfree((char*)pi);
    80004018:	8526                	mv	a0,s1
    8000401a:	ffffc097          	auipc	ra,0xffffc
    8000401e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004022:	60e2                	ld	ra,24(sp)
    80004024:	6442                	ld	s0,16(sp)
    80004026:	64a2                	ld	s1,8(sp)
    80004028:	6902                	ld	s2,0(sp)
    8000402a:	6105                	addi	sp,sp,32
    8000402c:	8082                	ret
    pi->readopen = 0;
    8000402e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004032:	21c48513          	addi	a0,s1,540
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	6cc080e7          	jalr	1740(ra) # 80001702 <wakeup>
    8000403e:	b7e9                	j	80004008 <pipeclose+0x2c>
    release(&pi->lock);
    80004040:	8526                	mv	a0,s1
    80004042:	00002097          	auipc	ra,0x2
    80004046:	380080e7          	jalr	896(ra) # 800063c2 <release>
}
    8000404a:	bfe1                	j	80004022 <pipeclose+0x46>

000000008000404c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000404c:	711d                	addi	sp,sp,-96
    8000404e:	ec86                	sd	ra,88(sp)
    80004050:	e8a2                	sd	s0,80(sp)
    80004052:	e4a6                	sd	s1,72(sp)
    80004054:	e0ca                	sd	s2,64(sp)
    80004056:	fc4e                	sd	s3,56(sp)
    80004058:	f852                	sd	s4,48(sp)
    8000405a:	f456                	sd	s5,40(sp)
    8000405c:	f05a                	sd	s6,32(sp)
    8000405e:	ec5e                	sd	s7,24(sp)
    80004060:	e862                	sd	s8,16(sp)
    80004062:	1080                	addi	s0,sp,96
    80004064:	84aa                	mv	s1,a0
    80004066:	8aae                	mv	s5,a1
    80004068:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	ede080e7          	jalr	-290(ra) # 80000f48 <myproc>
    80004072:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	298080e7          	jalr	664(ra) # 8000630e <acquire>
  while(i < n){
    8000407e:	0b405663          	blez	s4,8000412a <pipewrite+0xde>
  int i = 0;
    80004082:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004084:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004086:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000408a:	21c48b93          	addi	s7,s1,540
    8000408e:	a089                	j	800040d0 <pipewrite+0x84>
      release(&pi->lock);
    80004090:	8526                	mv	a0,s1
    80004092:	00002097          	auipc	ra,0x2
    80004096:	330080e7          	jalr	816(ra) # 800063c2 <release>
      return -1;
    8000409a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000409c:	854a                	mv	a0,s2
    8000409e:	60e6                	ld	ra,88(sp)
    800040a0:	6446                	ld	s0,80(sp)
    800040a2:	64a6                	ld	s1,72(sp)
    800040a4:	6906                	ld	s2,64(sp)
    800040a6:	79e2                	ld	s3,56(sp)
    800040a8:	7a42                	ld	s4,48(sp)
    800040aa:	7aa2                	ld	s5,40(sp)
    800040ac:	7b02                	ld	s6,32(sp)
    800040ae:	6be2                	ld	s7,24(sp)
    800040b0:	6c42                	ld	s8,16(sp)
    800040b2:	6125                	addi	sp,sp,96
    800040b4:	8082                	ret
      wakeup(&pi->nread);
    800040b6:	8562                	mv	a0,s8
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	64a080e7          	jalr	1610(ra) # 80001702 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040c0:	85a6                	mv	a1,s1
    800040c2:	855e                	mv	a0,s7
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	5da080e7          	jalr	1498(ra) # 8000169e <sleep>
  while(i < n){
    800040cc:	07495063          	bge	s2,s4,8000412c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    800040d0:	2204a783          	lw	a5,544(s1)
    800040d4:	dfd5                	beqz	a5,80004090 <pipewrite+0x44>
    800040d6:	854e                	mv	a0,s3
    800040d8:	ffffe097          	auipc	ra,0xffffe
    800040dc:	86e080e7          	jalr	-1938(ra) # 80001946 <killed>
    800040e0:	f945                	bnez	a0,80004090 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040e2:	2184a783          	lw	a5,536(s1)
    800040e6:	21c4a703          	lw	a4,540(s1)
    800040ea:	2007879b          	addiw	a5,a5,512
    800040ee:	fcf704e3          	beq	a4,a5,800040b6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040f2:	4685                	li	a3,1
    800040f4:	01590633          	add	a2,s2,s5
    800040f8:	faf40593          	addi	a1,s0,-81
    800040fc:	0509b503          	ld	a0,80(s3)
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	a9e080e7          	jalr	-1378(ra) # 80000b9e <copyin>
    80004108:	03650263          	beq	a0,s6,8000412c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000410c:	21c4a783          	lw	a5,540(s1)
    80004110:	0017871b          	addiw	a4,a5,1
    80004114:	20e4ae23          	sw	a4,540(s1)
    80004118:	1ff7f793          	andi	a5,a5,511
    8000411c:	97a6                	add	a5,a5,s1
    8000411e:	faf44703          	lbu	a4,-81(s0)
    80004122:	00e78c23          	sb	a4,24(a5)
      i++;
    80004126:	2905                	addiw	s2,s2,1
    80004128:	b755                	j	800040cc <pipewrite+0x80>
  int i = 0;
    8000412a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000412c:	21848513          	addi	a0,s1,536
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	5d2080e7          	jalr	1490(ra) # 80001702 <wakeup>
  release(&pi->lock);
    80004138:	8526                	mv	a0,s1
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	288080e7          	jalr	648(ra) # 800063c2 <release>
  return i;
    80004142:	bfa9                	j	8000409c <pipewrite+0x50>

0000000080004144 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004144:	715d                	addi	sp,sp,-80
    80004146:	e486                	sd	ra,72(sp)
    80004148:	e0a2                	sd	s0,64(sp)
    8000414a:	fc26                	sd	s1,56(sp)
    8000414c:	f84a                	sd	s2,48(sp)
    8000414e:	f44e                	sd	s3,40(sp)
    80004150:	f052                	sd	s4,32(sp)
    80004152:	ec56                	sd	s5,24(sp)
    80004154:	e85a                	sd	s6,16(sp)
    80004156:	0880                	addi	s0,sp,80
    80004158:	84aa                	mv	s1,a0
    8000415a:	892e                	mv	s2,a1
    8000415c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	dea080e7          	jalr	-534(ra) # 80000f48 <myproc>
    80004166:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	1a4080e7          	jalr	420(ra) # 8000630e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004172:	2184a703          	lw	a4,536(s1)
    80004176:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000417a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000417e:	02f71763          	bne	a4,a5,800041ac <piperead+0x68>
    80004182:	2244a783          	lw	a5,548(s1)
    80004186:	c39d                	beqz	a5,800041ac <piperead+0x68>
    if(killed(pr)){
    80004188:	8552                	mv	a0,s4
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	7bc080e7          	jalr	1980(ra) # 80001946 <killed>
    80004192:	e949                	bnez	a0,80004224 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004194:	85a6                	mv	a1,s1
    80004196:	854e                	mv	a0,s3
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	506080e7          	jalr	1286(ra) # 8000169e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a0:	2184a703          	lw	a4,536(s1)
    800041a4:	21c4a783          	lw	a5,540(s1)
    800041a8:	fcf70de3          	beq	a4,a5,80004182 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ac:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ae:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041b0:	05505463          	blez	s5,800041f8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800041b4:	2184a783          	lw	a5,536(s1)
    800041b8:	21c4a703          	lw	a4,540(s1)
    800041bc:	02f70e63          	beq	a4,a5,800041f8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041c0:	0017871b          	addiw	a4,a5,1
    800041c4:	20e4ac23          	sw	a4,536(s1)
    800041c8:	1ff7f793          	andi	a5,a5,511
    800041cc:	97a6                	add	a5,a5,s1
    800041ce:	0187c783          	lbu	a5,24(a5)
    800041d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041d6:	4685                	li	a3,1
    800041d8:	fbf40613          	addi	a2,s0,-65
    800041dc:	85ca                	mv	a1,s2
    800041de:	050a3503          	ld	a0,80(s4)
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	930080e7          	jalr	-1744(ra) # 80000b12 <copyout>
    800041ea:	01650763          	beq	a0,s6,800041f8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ee:	2985                	addiw	s3,s3,1
    800041f0:	0905                	addi	s2,s2,1
    800041f2:	fd3a91e3          	bne	s5,s3,800041b4 <piperead+0x70>
    800041f6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041f8:	21c48513          	addi	a0,s1,540
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	506080e7          	jalr	1286(ra) # 80001702 <wakeup>
  release(&pi->lock);
    80004204:	8526                	mv	a0,s1
    80004206:	00002097          	auipc	ra,0x2
    8000420a:	1bc080e7          	jalr	444(ra) # 800063c2 <release>
  return i;
}
    8000420e:	854e                	mv	a0,s3
    80004210:	60a6                	ld	ra,72(sp)
    80004212:	6406                	ld	s0,64(sp)
    80004214:	74e2                	ld	s1,56(sp)
    80004216:	7942                	ld	s2,48(sp)
    80004218:	79a2                	ld	s3,40(sp)
    8000421a:	7a02                	ld	s4,32(sp)
    8000421c:	6ae2                	ld	s5,24(sp)
    8000421e:	6b42                	ld	s6,16(sp)
    80004220:	6161                	addi	sp,sp,80
    80004222:	8082                	ret
      release(&pi->lock);
    80004224:	8526                	mv	a0,s1
    80004226:	00002097          	auipc	ra,0x2
    8000422a:	19c080e7          	jalr	412(ra) # 800063c2 <release>
      return -1;
    8000422e:	59fd                	li	s3,-1
    80004230:	bff9                	j	8000420e <piperead+0xca>

0000000080004232 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004232:	1141                	addi	sp,sp,-16
    80004234:	e422                	sd	s0,8(sp)
    80004236:	0800                	addi	s0,sp,16
    80004238:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000423a:	8905                	andi	a0,a0,1
    8000423c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000423e:	8b89                	andi	a5,a5,2
    80004240:	c399                	beqz	a5,80004246 <flags2perm+0x14>
      perm |= PTE_W;
    80004242:	00456513          	ori	a0,a0,4
    return perm;
}
    80004246:	6422                	ld	s0,8(sp)
    80004248:	0141                	addi	sp,sp,16
    8000424a:	8082                	ret

000000008000424c <exec>:

int
exec(char *path, char **argv)
{
    8000424c:	df010113          	addi	sp,sp,-528
    80004250:	20113423          	sd	ra,520(sp)
    80004254:	20813023          	sd	s0,512(sp)
    80004258:	ffa6                	sd	s1,504(sp)
    8000425a:	fbca                	sd	s2,496(sp)
    8000425c:	f7ce                	sd	s3,488(sp)
    8000425e:	f3d2                	sd	s4,480(sp)
    80004260:	efd6                	sd	s5,472(sp)
    80004262:	ebda                	sd	s6,464(sp)
    80004264:	e7de                	sd	s7,456(sp)
    80004266:	e3e2                	sd	s8,448(sp)
    80004268:	ff66                	sd	s9,440(sp)
    8000426a:	fb6a                	sd	s10,432(sp)
    8000426c:	f76e                	sd	s11,424(sp)
    8000426e:	0c00                	addi	s0,sp,528
    80004270:	892a                	mv	s2,a0
    80004272:	dea43c23          	sd	a0,-520(s0)
    80004276:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000427a:	ffffd097          	auipc	ra,0xffffd
    8000427e:	cce080e7          	jalr	-818(ra) # 80000f48 <myproc>
    80004282:	84aa                	mv	s1,a0

  begin_op();
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	48e080e7          	jalr	1166(ra) # 80003712 <begin_op>

  if((ip = namei(path)) == 0){
    8000428c:	854a                	mv	a0,s2
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	284080e7          	jalr	644(ra) # 80003512 <namei>
    80004296:	c92d                	beqz	a0,80004308 <exec+0xbc>
    80004298:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	ad2080e7          	jalr	-1326(ra) # 80002d6c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042a2:	04000713          	li	a4,64
    800042a6:	4681                	li	a3,0
    800042a8:	e5040613          	addi	a2,s0,-432
    800042ac:	4581                	li	a1,0
    800042ae:	8552                	mv	a0,s4
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	d70080e7          	jalr	-656(ra) # 80003020 <readi>
    800042b8:	04000793          	li	a5,64
    800042bc:	00f51a63          	bne	a0,a5,800042d0 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042c0:	e5042703          	lw	a4,-432(s0)
    800042c4:	464c47b7          	lui	a5,0x464c4
    800042c8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042cc:	04f70463          	beq	a4,a5,80004314 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042d0:	8552                	mv	a0,s4
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	cfc080e7          	jalr	-772(ra) # 80002fce <iunlockput>
    end_op();
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	4b2080e7          	jalr	1202(ra) # 8000378c <end_op>
  }
  return -1;
    800042e2:	557d                	li	a0,-1
}
    800042e4:	20813083          	ld	ra,520(sp)
    800042e8:	20013403          	ld	s0,512(sp)
    800042ec:	74fe                	ld	s1,504(sp)
    800042ee:	795e                	ld	s2,496(sp)
    800042f0:	79be                	ld	s3,488(sp)
    800042f2:	7a1e                	ld	s4,480(sp)
    800042f4:	6afe                	ld	s5,472(sp)
    800042f6:	6b5e                	ld	s6,464(sp)
    800042f8:	6bbe                	ld	s7,456(sp)
    800042fa:	6c1e                	ld	s8,448(sp)
    800042fc:	7cfa                	ld	s9,440(sp)
    800042fe:	7d5a                	ld	s10,432(sp)
    80004300:	7dba                	ld	s11,424(sp)
    80004302:	21010113          	addi	sp,sp,528
    80004306:	8082                	ret
    end_op();
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	484080e7          	jalr	1156(ra) # 8000378c <end_op>
    return -1;
    80004310:	557d                	li	a0,-1
    80004312:	bfc9                	j	800042e4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004314:	8526                	mv	a0,s1
    80004316:	ffffd097          	auipc	ra,0xffffd
    8000431a:	cf6080e7          	jalr	-778(ra) # 8000100c <proc_pagetable>
    8000431e:	8b2a                	mv	s6,a0
    80004320:	d945                	beqz	a0,800042d0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004322:	e7042d03          	lw	s10,-400(s0)
    80004326:	e8845783          	lhu	a5,-376(s0)
    8000432a:	10078463          	beqz	a5,80004432 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000432e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004330:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004332:	6c85                	lui	s9,0x1
    80004334:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004338:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000433c:	6a85                	lui	s5,0x1
    8000433e:	a0b5                	j	800043aa <exec+0x15e>
      panic("loadseg: address should exist");
    80004340:	00004517          	auipc	a0,0x4
    80004344:	38850513          	addi	a0,a0,904 # 800086c8 <syscalls+0x2c8>
    80004348:	00002097          	auipc	ra,0x2
    8000434c:	a8e080e7          	jalr	-1394(ra) # 80005dd6 <panic>
    if(sz - i < PGSIZE)
    80004350:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004352:	8726                	mv	a4,s1
    80004354:	012c06bb          	addw	a3,s8,s2
    80004358:	4581                	li	a1,0
    8000435a:	8552                	mv	a0,s4
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	cc4080e7          	jalr	-828(ra) # 80003020 <readi>
    80004364:	2501                	sext.w	a0,a0
    80004366:	26a49463          	bne	s1,a0,800045ce <exec+0x382>
  for(i = 0; i < sz; i += PGSIZE){
    8000436a:	012a893b          	addw	s2,s5,s2
    8000436e:	03397563          	bgeu	s2,s3,80004398 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004372:	02091593          	slli	a1,s2,0x20
    80004376:	9181                	srli	a1,a1,0x20
    80004378:	95de                	add	a1,a1,s7
    8000437a:	855a                	mv	a0,s6
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	186080e7          	jalr	390(ra) # 80000502 <walkaddr>
    80004384:	862a                	mv	a2,a0
    if(pa == 0)
    80004386:	dd4d                	beqz	a0,80004340 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004388:	412984bb          	subw	s1,s3,s2
    8000438c:	0004879b          	sext.w	a5,s1
    80004390:	fcfcf0e3          	bgeu	s9,a5,80004350 <exec+0x104>
    80004394:	84d6                	mv	s1,s5
    80004396:	bf6d                	j	80004350 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004398:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000439c:	2d85                	addiw	s11,s11,1
    8000439e:	038d0d1b          	addiw	s10,s10,56
    800043a2:	e8845783          	lhu	a5,-376(s0)
    800043a6:	08fdd763          	bge	s11,a5,80004434 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043aa:	2d01                	sext.w	s10,s10
    800043ac:	03800713          	li	a4,56
    800043b0:	86ea                	mv	a3,s10
    800043b2:	e1840613          	addi	a2,s0,-488
    800043b6:	4581                	li	a1,0
    800043b8:	8552                	mv	a0,s4
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	c66080e7          	jalr	-922(ra) # 80003020 <readi>
    800043c2:	03800793          	li	a5,56
    800043c6:	20f51263          	bne	a0,a5,800045ca <exec+0x37e>
    if(ph.type != ELF_PROG_LOAD)
    800043ca:	e1842783          	lw	a5,-488(s0)
    800043ce:	4705                	li	a4,1
    800043d0:	fce796e3          	bne	a5,a4,8000439c <exec+0x150>
    if(ph.memsz < ph.filesz)
    800043d4:	e4043483          	ld	s1,-448(s0)
    800043d8:	e3843783          	ld	a5,-456(s0)
    800043dc:	20f4e463          	bltu	s1,a5,800045e4 <exec+0x398>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043e0:	e2843783          	ld	a5,-472(s0)
    800043e4:	94be                	add	s1,s1,a5
    800043e6:	20f4e263          	bltu	s1,a5,800045ea <exec+0x39e>
    if(ph.vaddr % PGSIZE != 0)
    800043ea:	df043703          	ld	a4,-528(s0)
    800043ee:	8ff9                	and	a5,a5,a4
    800043f0:	20079063          	bnez	a5,800045f0 <exec+0x3a4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043f4:	e1c42503          	lw	a0,-484(s0)
    800043f8:	00000097          	auipc	ra,0x0
    800043fc:	e3a080e7          	jalr	-454(ra) # 80004232 <flags2perm>
    80004400:	86aa                	mv	a3,a0
    80004402:	8626                	mv	a2,s1
    80004404:	85ca                	mv	a1,s2
    80004406:	855a                	mv	a0,s6
    80004408:	ffffc097          	auipc	ra,0xffffc
    8000440c:	4ae080e7          	jalr	1198(ra) # 800008b6 <uvmalloc>
    80004410:	e0a43423          	sd	a0,-504(s0)
    80004414:	1e050163          	beqz	a0,800045f6 <exec+0x3aa>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004418:	e2843b83          	ld	s7,-472(s0)
    8000441c:	e2042c03          	lw	s8,-480(s0)
    80004420:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004424:	00098463          	beqz	s3,8000442c <exec+0x1e0>
    80004428:	4901                	li	s2,0
    8000442a:	b7a1                	j	80004372 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000442c:	e0843903          	ld	s2,-504(s0)
    80004430:	b7b5                	j	8000439c <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004432:	4901                	li	s2,0
  iunlockput(ip);
    80004434:	8552                	mv	a0,s4
    80004436:	fffff097          	auipc	ra,0xfffff
    8000443a:	b98080e7          	jalr	-1128(ra) # 80002fce <iunlockput>
  end_op();
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	34e080e7          	jalr	846(ra) # 8000378c <end_op>
  p = myproc();
    80004446:	ffffd097          	auipc	ra,0xffffd
    8000444a:	b02080e7          	jalr	-1278(ra) # 80000f48 <myproc>
    8000444e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004450:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004454:	6985                	lui	s3,0x1
    80004456:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004458:	99ca                	add	s3,s3,s2
    8000445a:	77fd                	lui	a5,0xfffff
    8000445c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004460:	4691                	li	a3,4
    80004462:	6609                	lui	a2,0x2
    80004464:	964e                	add	a2,a2,s3
    80004466:	85ce                	mv	a1,s3
    80004468:	855a                	mv	a0,s6
    8000446a:	ffffc097          	auipc	ra,0xffffc
    8000446e:	44c080e7          	jalr	1100(ra) # 800008b6 <uvmalloc>
    80004472:	892a                	mv	s2,a0
    80004474:	e0a43423          	sd	a0,-504(s0)
    80004478:	e509                	bnez	a0,80004482 <exec+0x236>
  if(pagetable)
    8000447a:	e1343423          	sd	s3,-504(s0)
    8000447e:	4a01                	li	s4,0
    80004480:	a2b9                	j	800045ce <exec+0x382>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004482:	75f9                	lui	a1,0xffffe
    80004484:	95aa                	add	a1,a1,a0
    80004486:	855a                	mv	a0,s6
    80004488:	ffffc097          	auipc	ra,0xffffc
    8000448c:	658080e7          	jalr	1624(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004490:	7bfd                	lui	s7,0xfffff
    80004492:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004494:	e0043783          	ld	a5,-512(s0)
    80004498:	6388                	ld	a0,0(a5)
    8000449a:	c52d                	beqz	a0,80004504 <exec+0x2b8>
    8000449c:	e9040993          	addi	s3,s0,-368
    800044a0:	f9040c13          	addi	s8,s0,-112
    800044a4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044a6:	ffffc097          	auipc	ra,0xffffc
    800044aa:	e4e080e7          	jalr	-434(ra) # 800002f4 <strlen>
    800044ae:	0015079b          	addiw	a5,a0,1
    800044b2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044b6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044ba:	15796163          	bltu	s2,s7,800045fc <exec+0x3b0>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044be:	e0043d03          	ld	s10,-512(s0)
    800044c2:	000d3a03          	ld	s4,0(s10)
    800044c6:	8552                	mv	a0,s4
    800044c8:	ffffc097          	auipc	ra,0xffffc
    800044cc:	e2c080e7          	jalr	-468(ra) # 800002f4 <strlen>
    800044d0:	0015069b          	addiw	a3,a0,1
    800044d4:	8652                	mv	a2,s4
    800044d6:	85ca                	mv	a1,s2
    800044d8:	855a                	mv	a0,s6
    800044da:	ffffc097          	auipc	ra,0xffffc
    800044de:	638080e7          	jalr	1592(ra) # 80000b12 <copyout>
    800044e2:	10054f63          	bltz	a0,80004600 <exec+0x3b4>
    ustack[argc] = sp;
    800044e6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044ea:	0485                	addi	s1,s1,1
    800044ec:	008d0793          	addi	a5,s10,8
    800044f0:	e0f43023          	sd	a5,-512(s0)
    800044f4:	008d3503          	ld	a0,8(s10)
    800044f8:	c909                	beqz	a0,8000450a <exec+0x2be>
    if(argc >= MAXARG)
    800044fa:	09a1                	addi	s3,s3,8
    800044fc:	fb8995e3          	bne	s3,s8,800044a6 <exec+0x25a>
  ip = 0;
    80004500:	4a01                	li	s4,0
    80004502:	a0f1                	j	800045ce <exec+0x382>
  sp = sz;
    80004504:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004508:	4481                	li	s1,0
  ustack[argc] = 0;
    8000450a:	00349793          	slli	a5,s1,0x3
    8000450e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdcfc0>
    80004512:	97a2                	add	a5,a5,s0
    80004514:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004518:	00148693          	addi	a3,s1,1
    8000451c:	068e                	slli	a3,a3,0x3
    8000451e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004522:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004526:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000452a:	f57968e3          	bltu	s2,s7,8000447a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000452e:	e9040613          	addi	a2,s0,-368
    80004532:	85ca                	mv	a1,s2
    80004534:	855a                	mv	a0,s6
    80004536:	ffffc097          	auipc	ra,0xffffc
    8000453a:	5dc080e7          	jalr	1500(ra) # 80000b12 <copyout>
    8000453e:	0c054363          	bltz	a0,80004604 <exec+0x3b8>
  p->trapframe->a1 = sp;
    80004542:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004546:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000454a:	df843783          	ld	a5,-520(s0)
    8000454e:	0007c703          	lbu	a4,0(a5)
    80004552:	cf11                	beqz	a4,8000456e <exec+0x322>
    80004554:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004556:	02f00693          	li	a3,47
    8000455a:	a039                	j	80004568 <exec+0x31c>
      last = s+1;
    8000455c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004560:	0785                	addi	a5,a5,1
    80004562:	fff7c703          	lbu	a4,-1(a5)
    80004566:	c701                	beqz	a4,8000456e <exec+0x322>
    if(*s == '/')
    80004568:	fed71ce3          	bne	a4,a3,80004560 <exec+0x314>
    8000456c:	bfc5                	j	8000455c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000456e:	4641                	li	a2,16
    80004570:	df843583          	ld	a1,-520(s0)
    80004574:	160a8513          	addi	a0,s5,352
    80004578:	ffffc097          	auipc	ra,0xffffc
    8000457c:	d4a080e7          	jalr	-694(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004580:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004584:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004588:	e0843783          	ld	a5,-504(s0)
    8000458c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004590:	058ab783          	ld	a5,88(s5)
    80004594:	e6843703          	ld	a4,-408(s0)
    80004598:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000459a:	058ab783          	ld	a5,88(s5)
    8000459e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045a2:	85e6                	mv	a1,s9
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	b5e080e7          	jalr	-1186(ra) # 80001102 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    800045ac:	030aa703          	lw	a4,48(s5)
    800045b0:	4785                	li	a5,1
    800045b2:	00f70563          	beq	a4,a5,800045bc <exec+0x370>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045b6:	0004851b          	sext.w	a0,s1
    800045ba:	b32d                	j	800042e4 <exec+0x98>
  if(p->pid==1) vmprint(p->pagetable);
    800045bc:	050ab503          	ld	a0,80(s5)
    800045c0:	ffffc097          	auipc	ra,0xffffc
    800045c4:	7e2080e7          	jalr	2018(ra) # 80000da2 <vmprint>
    800045c8:	b7fd                	j	800045b6 <exec+0x36a>
    800045ca:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045ce:	e0843583          	ld	a1,-504(s0)
    800045d2:	855a                	mv	a0,s6
    800045d4:	ffffd097          	auipc	ra,0xffffd
    800045d8:	b2e080e7          	jalr	-1234(ra) # 80001102 <proc_freepagetable>
  return -1;
    800045dc:	557d                	li	a0,-1
  if(ip){
    800045de:	d00a03e3          	beqz	s4,800042e4 <exec+0x98>
    800045e2:	b1fd                	j	800042d0 <exec+0x84>
    800045e4:	e1243423          	sd	s2,-504(s0)
    800045e8:	b7dd                	j	800045ce <exec+0x382>
    800045ea:	e1243423          	sd	s2,-504(s0)
    800045ee:	b7c5                	j	800045ce <exec+0x382>
    800045f0:	e1243423          	sd	s2,-504(s0)
    800045f4:	bfe9                	j	800045ce <exec+0x382>
    800045f6:	e1243423          	sd	s2,-504(s0)
    800045fa:	bfd1                	j	800045ce <exec+0x382>
  ip = 0;
    800045fc:	4a01                	li	s4,0
    800045fe:	bfc1                	j	800045ce <exec+0x382>
    80004600:	4a01                	li	s4,0
  if(pagetable)
    80004602:	b7f1                	j	800045ce <exec+0x382>
  sz = sz1;
    80004604:	e0843983          	ld	s3,-504(s0)
    80004608:	bd8d                	j	8000447a <exec+0x22e>

000000008000460a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000460a:	7179                	addi	sp,sp,-48
    8000460c:	f406                	sd	ra,40(sp)
    8000460e:	f022                	sd	s0,32(sp)
    80004610:	ec26                	sd	s1,24(sp)
    80004612:	e84a                	sd	s2,16(sp)
    80004614:	1800                	addi	s0,sp,48
    80004616:	892e                	mv	s2,a1
    80004618:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000461a:	fdc40593          	addi	a1,s0,-36
    8000461e:	ffffe097          	auipc	ra,0xffffe
    80004622:	b8e080e7          	jalr	-1138(ra) # 800021ac <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004626:	fdc42703          	lw	a4,-36(s0)
    8000462a:	47bd                	li	a5,15
    8000462c:	02e7eb63          	bltu	a5,a4,80004662 <argfd+0x58>
    80004630:	ffffd097          	auipc	ra,0xffffd
    80004634:	918080e7          	jalr	-1768(ra) # 80000f48 <myproc>
    80004638:	fdc42703          	lw	a4,-36(s0)
    8000463c:	01a70793          	addi	a5,a4,26
    80004640:	078e                	slli	a5,a5,0x3
    80004642:	953e                	add	a0,a0,a5
    80004644:	651c                	ld	a5,8(a0)
    80004646:	c385                	beqz	a5,80004666 <argfd+0x5c>
    return -1;
  if(pfd)
    80004648:	00090463          	beqz	s2,80004650 <argfd+0x46>
    *pfd = fd;
    8000464c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004650:	4501                	li	a0,0
  if(pf)
    80004652:	c091                	beqz	s1,80004656 <argfd+0x4c>
    *pf = f;
    80004654:	e09c                	sd	a5,0(s1)
}
    80004656:	70a2                	ld	ra,40(sp)
    80004658:	7402                	ld	s0,32(sp)
    8000465a:	64e2                	ld	s1,24(sp)
    8000465c:	6942                	ld	s2,16(sp)
    8000465e:	6145                	addi	sp,sp,48
    80004660:	8082                	ret
    return -1;
    80004662:	557d                	li	a0,-1
    80004664:	bfcd                	j	80004656 <argfd+0x4c>
    80004666:	557d                	li	a0,-1
    80004668:	b7fd                	j	80004656 <argfd+0x4c>

000000008000466a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000466a:	1101                	addi	sp,sp,-32
    8000466c:	ec06                	sd	ra,24(sp)
    8000466e:	e822                	sd	s0,16(sp)
    80004670:	e426                	sd	s1,8(sp)
    80004672:	1000                	addi	s0,sp,32
    80004674:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004676:	ffffd097          	auipc	ra,0xffffd
    8000467a:	8d2080e7          	jalr	-1838(ra) # 80000f48 <myproc>
    8000467e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004680:	0d850793          	addi	a5,a0,216
    80004684:	4501                	li	a0,0
    80004686:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004688:	6398                	ld	a4,0(a5)
    8000468a:	cb19                	beqz	a4,800046a0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000468c:	2505                	addiw	a0,a0,1
    8000468e:	07a1                	addi	a5,a5,8
    80004690:	fed51ce3          	bne	a0,a3,80004688 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004694:	557d                	li	a0,-1
}
    80004696:	60e2                	ld	ra,24(sp)
    80004698:	6442                	ld	s0,16(sp)
    8000469a:	64a2                	ld	s1,8(sp)
    8000469c:	6105                	addi	sp,sp,32
    8000469e:	8082                	ret
      p->ofile[fd] = f;
    800046a0:	01a50793          	addi	a5,a0,26
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	963e                	add	a2,a2,a5
    800046a8:	e604                	sd	s1,8(a2)
      return fd;
    800046aa:	b7f5                	j	80004696 <fdalloc+0x2c>

00000000800046ac <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ac:	715d                	addi	sp,sp,-80
    800046ae:	e486                	sd	ra,72(sp)
    800046b0:	e0a2                	sd	s0,64(sp)
    800046b2:	fc26                	sd	s1,56(sp)
    800046b4:	f84a                	sd	s2,48(sp)
    800046b6:	f44e                	sd	s3,40(sp)
    800046b8:	f052                	sd	s4,32(sp)
    800046ba:	ec56                	sd	s5,24(sp)
    800046bc:	e85a                	sd	s6,16(sp)
    800046be:	0880                	addi	s0,sp,80
    800046c0:	8b2e                	mv	s6,a1
    800046c2:	89b2                	mv	s3,a2
    800046c4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046c6:	fb040593          	addi	a1,s0,-80
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	e66080e7          	jalr	-410(ra) # 80003530 <nameiparent>
    800046d2:	84aa                	mv	s1,a0
    800046d4:	14050b63          	beqz	a0,8000482a <create+0x17e>
    return 0;

  ilock(dp);
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	694080e7          	jalr	1684(ra) # 80002d6c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046e0:	4601                	li	a2,0
    800046e2:	fb040593          	addi	a1,s0,-80
    800046e6:	8526                	mv	a0,s1
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	b68080e7          	jalr	-1176(ra) # 80003250 <dirlookup>
    800046f0:	8aaa                	mv	s5,a0
    800046f2:	c921                	beqz	a0,80004742 <create+0x96>
    iunlockput(dp);
    800046f4:	8526                	mv	a0,s1
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	8d8080e7          	jalr	-1832(ra) # 80002fce <iunlockput>
    ilock(ip);
    800046fe:	8556                	mv	a0,s5
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	66c080e7          	jalr	1644(ra) # 80002d6c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004708:	4789                	li	a5,2
    8000470a:	02fb1563          	bne	s6,a5,80004734 <create+0x88>
    8000470e:	044ad783          	lhu	a5,68(s5)
    80004712:	37f9                	addiw	a5,a5,-2
    80004714:	17c2                	slli	a5,a5,0x30
    80004716:	93c1                	srli	a5,a5,0x30
    80004718:	4705                	li	a4,1
    8000471a:	00f76d63          	bltu	a4,a5,80004734 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000471e:	8556                	mv	a0,s5
    80004720:	60a6                	ld	ra,72(sp)
    80004722:	6406                	ld	s0,64(sp)
    80004724:	74e2                	ld	s1,56(sp)
    80004726:	7942                	ld	s2,48(sp)
    80004728:	79a2                	ld	s3,40(sp)
    8000472a:	7a02                	ld	s4,32(sp)
    8000472c:	6ae2                	ld	s5,24(sp)
    8000472e:	6b42                	ld	s6,16(sp)
    80004730:	6161                	addi	sp,sp,80
    80004732:	8082                	ret
    iunlockput(ip);
    80004734:	8556                	mv	a0,s5
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	898080e7          	jalr	-1896(ra) # 80002fce <iunlockput>
    return 0;
    8000473e:	4a81                	li	s5,0
    80004740:	bff9                	j	8000471e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004742:	85da                	mv	a1,s6
    80004744:	4088                	lw	a0,0(s1)
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	48e080e7          	jalr	1166(ra) # 80002bd4 <ialloc>
    8000474e:	8a2a                	mv	s4,a0
    80004750:	c529                	beqz	a0,8000479a <create+0xee>
  ilock(ip);
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	61a080e7          	jalr	1562(ra) # 80002d6c <ilock>
  ip->major = major;
    8000475a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000475e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004762:	4905                	li	s2,1
    80004764:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004768:	8552                	mv	a0,s4
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	536080e7          	jalr	1334(ra) # 80002ca0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004772:	032b0b63          	beq	s6,s2,800047a8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004776:	004a2603          	lw	a2,4(s4)
    8000477a:	fb040593          	addi	a1,s0,-80
    8000477e:	8526                	mv	a0,s1
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	ce0080e7          	jalr	-800(ra) # 80003460 <dirlink>
    80004788:	06054f63          	bltz	a0,80004806 <create+0x15a>
  iunlockput(dp);
    8000478c:	8526                	mv	a0,s1
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	840080e7          	jalr	-1984(ra) # 80002fce <iunlockput>
  return ip;
    80004796:	8ad2                	mv	s5,s4
    80004798:	b759                	j	8000471e <create+0x72>
    iunlockput(dp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	832080e7          	jalr	-1998(ra) # 80002fce <iunlockput>
    return 0;
    800047a4:	8ad2                	mv	s5,s4
    800047a6:	bfa5                	j	8000471e <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047a8:	004a2603          	lw	a2,4(s4)
    800047ac:	00004597          	auipc	a1,0x4
    800047b0:	f3c58593          	addi	a1,a1,-196 # 800086e8 <syscalls+0x2e8>
    800047b4:	8552                	mv	a0,s4
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	caa080e7          	jalr	-854(ra) # 80003460 <dirlink>
    800047be:	04054463          	bltz	a0,80004806 <create+0x15a>
    800047c2:	40d0                	lw	a2,4(s1)
    800047c4:	00004597          	auipc	a1,0x4
    800047c8:	f2c58593          	addi	a1,a1,-212 # 800086f0 <syscalls+0x2f0>
    800047cc:	8552                	mv	a0,s4
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	c92080e7          	jalr	-878(ra) # 80003460 <dirlink>
    800047d6:	02054863          	bltz	a0,80004806 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800047da:	004a2603          	lw	a2,4(s4)
    800047de:	fb040593          	addi	a1,s0,-80
    800047e2:	8526                	mv	a0,s1
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	c7c080e7          	jalr	-900(ra) # 80003460 <dirlink>
    800047ec:	00054d63          	bltz	a0,80004806 <create+0x15a>
    dp->nlink++;  // for ".."
    800047f0:	04a4d783          	lhu	a5,74(s1)
    800047f4:	2785                	addiw	a5,a5,1
    800047f6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047fa:	8526                	mv	a0,s1
    800047fc:	ffffe097          	auipc	ra,0xffffe
    80004800:	4a4080e7          	jalr	1188(ra) # 80002ca0 <iupdate>
    80004804:	b761                	j	8000478c <create+0xe0>
  ip->nlink = 0;
    80004806:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000480a:	8552                	mv	a0,s4
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	494080e7          	jalr	1172(ra) # 80002ca0 <iupdate>
  iunlockput(ip);
    80004814:	8552                	mv	a0,s4
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	7b8080e7          	jalr	1976(ra) # 80002fce <iunlockput>
  iunlockput(dp);
    8000481e:	8526                	mv	a0,s1
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	7ae080e7          	jalr	1966(ra) # 80002fce <iunlockput>
  return 0;
    80004828:	bddd                	j	8000471e <create+0x72>
    return 0;
    8000482a:	8aaa                	mv	s5,a0
    8000482c:	bdcd                	j	8000471e <create+0x72>

000000008000482e <sys_dup>:
{
    8000482e:	7179                	addi	sp,sp,-48
    80004830:	f406                	sd	ra,40(sp)
    80004832:	f022                	sd	s0,32(sp)
    80004834:	ec26                	sd	s1,24(sp)
    80004836:	e84a                	sd	s2,16(sp)
    80004838:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000483a:	fd840613          	addi	a2,s0,-40
    8000483e:	4581                	li	a1,0
    80004840:	4501                	li	a0,0
    80004842:	00000097          	auipc	ra,0x0
    80004846:	dc8080e7          	jalr	-568(ra) # 8000460a <argfd>
    return -1;
    8000484a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000484c:	02054363          	bltz	a0,80004872 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004850:	fd843903          	ld	s2,-40(s0)
    80004854:	854a                	mv	a0,s2
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	e14080e7          	jalr	-492(ra) # 8000466a <fdalloc>
    8000485e:	84aa                	mv	s1,a0
    return -1;
    80004860:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004862:	00054863          	bltz	a0,80004872 <sys_dup+0x44>
  filedup(f);
    80004866:	854a                	mv	a0,s2
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	31c080e7          	jalr	796(ra) # 80003b84 <filedup>
  return fd;
    80004870:	87a6                	mv	a5,s1
}
    80004872:	853e                	mv	a0,a5
    80004874:	70a2                	ld	ra,40(sp)
    80004876:	7402                	ld	s0,32(sp)
    80004878:	64e2                	ld	s1,24(sp)
    8000487a:	6942                	ld	s2,16(sp)
    8000487c:	6145                	addi	sp,sp,48
    8000487e:	8082                	ret

0000000080004880 <sys_read>:
{
    80004880:	7179                	addi	sp,sp,-48
    80004882:	f406                	sd	ra,40(sp)
    80004884:	f022                	sd	s0,32(sp)
    80004886:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004888:	fd840593          	addi	a1,s0,-40
    8000488c:	4505                	li	a0,1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	93e080e7          	jalr	-1730(ra) # 800021cc <argaddr>
  argint(2, &n);
    80004896:	fe440593          	addi	a1,s0,-28
    8000489a:	4509                	li	a0,2
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	910080e7          	jalr	-1776(ra) # 800021ac <argint>
  if(argfd(0, 0, &f) < 0)
    800048a4:	fe840613          	addi	a2,s0,-24
    800048a8:	4581                	li	a1,0
    800048aa:	4501                	li	a0,0
    800048ac:	00000097          	auipc	ra,0x0
    800048b0:	d5e080e7          	jalr	-674(ra) # 8000460a <argfd>
    800048b4:	87aa                	mv	a5,a0
    return -1;
    800048b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048b8:	0007cc63          	bltz	a5,800048d0 <sys_read+0x50>
  return fileread(f, p, n);
    800048bc:	fe442603          	lw	a2,-28(s0)
    800048c0:	fd843583          	ld	a1,-40(s0)
    800048c4:	fe843503          	ld	a0,-24(s0)
    800048c8:	fffff097          	auipc	ra,0xfffff
    800048cc:	448080e7          	jalr	1096(ra) # 80003d10 <fileread>
}
    800048d0:	70a2                	ld	ra,40(sp)
    800048d2:	7402                	ld	s0,32(sp)
    800048d4:	6145                	addi	sp,sp,48
    800048d6:	8082                	ret

00000000800048d8 <sys_write>:
{
    800048d8:	7179                	addi	sp,sp,-48
    800048da:	f406                	sd	ra,40(sp)
    800048dc:	f022                	sd	s0,32(sp)
    800048de:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048e0:	fd840593          	addi	a1,s0,-40
    800048e4:	4505                	li	a0,1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	8e6080e7          	jalr	-1818(ra) # 800021cc <argaddr>
  argint(2, &n);
    800048ee:	fe440593          	addi	a1,s0,-28
    800048f2:	4509                	li	a0,2
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	8b8080e7          	jalr	-1864(ra) # 800021ac <argint>
  if(argfd(0, 0, &f) < 0)
    800048fc:	fe840613          	addi	a2,s0,-24
    80004900:	4581                	li	a1,0
    80004902:	4501                	li	a0,0
    80004904:	00000097          	auipc	ra,0x0
    80004908:	d06080e7          	jalr	-762(ra) # 8000460a <argfd>
    8000490c:	87aa                	mv	a5,a0
    return -1;
    8000490e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004910:	0007cc63          	bltz	a5,80004928 <sys_write+0x50>
  return filewrite(f, p, n);
    80004914:	fe442603          	lw	a2,-28(s0)
    80004918:	fd843583          	ld	a1,-40(s0)
    8000491c:	fe843503          	ld	a0,-24(s0)
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	4b2080e7          	jalr	1202(ra) # 80003dd2 <filewrite>
}
    80004928:	70a2                	ld	ra,40(sp)
    8000492a:	7402                	ld	s0,32(sp)
    8000492c:	6145                	addi	sp,sp,48
    8000492e:	8082                	ret

0000000080004930 <sys_close>:
{
    80004930:	1101                	addi	sp,sp,-32
    80004932:	ec06                	sd	ra,24(sp)
    80004934:	e822                	sd	s0,16(sp)
    80004936:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004938:	fe040613          	addi	a2,s0,-32
    8000493c:	fec40593          	addi	a1,s0,-20
    80004940:	4501                	li	a0,0
    80004942:	00000097          	auipc	ra,0x0
    80004946:	cc8080e7          	jalr	-824(ra) # 8000460a <argfd>
    return -1;
    8000494a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000494c:	02054463          	bltz	a0,80004974 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004950:	ffffc097          	auipc	ra,0xffffc
    80004954:	5f8080e7          	jalr	1528(ra) # 80000f48 <myproc>
    80004958:	fec42783          	lw	a5,-20(s0)
    8000495c:	07e9                	addi	a5,a5,26
    8000495e:	078e                	slli	a5,a5,0x3
    80004960:	953e                	add	a0,a0,a5
    80004962:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004966:	fe043503          	ld	a0,-32(s0)
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	26c080e7          	jalr	620(ra) # 80003bd6 <fileclose>
  return 0;
    80004972:	4781                	li	a5,0
}
    80004974:	853e                	mv	a0,a5
    80004976:	60e2                	ld	ra,24(sp)
    80004978:	6442                	ld	s0,16(sp)
    8000497a:	6105                	addi	sp,sp,32
    8000497c:	8082                	ret

000000008000497e <sys_fstat>:
{
    8000497e:	1101                	addi	sp,sp,-32
    80004980:	ec06                	sd	ra,24(sp)
    80004982:	e822                	sd	s0,16(sp)
    80004984:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004986:	fe040593          	addi	a1,s0,-32
    8000498a:	4505                	li	a0,1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	840080e7          	jalr	-1984(ra) # 800021cc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004994:	fe840613          	addi	a2,s0,-24
    80004998:	4581                	li	a1,0
    8000499a:	4501                	li	a0,0
    8000499c:	00000097          	auipc	ra,0x0
    800049a0:	c6e080e7          	jalr	-914(ra) # 8000460a <argfd>
    800049a4:	87aa                	mv	a5,a0
    return -1;
    800049a6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049a8:	0007ca63          	bltz	a5,800049bc <sys_fstat+0x3e>
  return filestat(f, st);
    800049ac:	fe043583          	ld	a1,-32(s0)
    800049b0:	fe843503          	ld	a0,-24(s0)
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	2ea080e7          	jalr	746(ra) # 80003c9e <filestat>
}
    800049bc:	60e2                	ld	ra,24(sp)
    800049be:	6442                	ld	s0,16(sp)
    800049c0:	6105                	addi	sp,sp,32
    800049c2:	8082                	ret

00000000800049c4 <sys_link>:
{
    800049c4:	7169                	addi	sp,sp,-304
    800049c6:	f606                	sd	ra,296(sp)
    800049c8:	f222                	sd	s0,288(sp)
    800049ca:	ee26                	sd	s1,280(sp)
    800049cc:	ea4a                	sd	s2,272(sp)
    800049ce:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d0:	08000613          	li	a2,128
    800049d4:	ed040593          	addi	a1,s0,-304
    800049d8:	4501                	li	a0,0
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	812080e7          	jalr	-2030(ra) # 800021ec <argstr>
    return -1;
    800049e2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049e4:	10054e63          	bltz	a0,80004b00 <sys_link+0x13c>
    800049e8:	08000613          	li	a2,128
    800049ec:	f5040593          	addi	a1,s0,-176
    800049f0:	4505                	li	a0,1
    800049f2:	ffffd097          	auipc	ra,0xffffd
    800049f6:	7fa080e7          	jalr	2042(ra) # 800021ec <argstr>
    return -1;
    800049fa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049fc:	10054263          	bltz	a0,80004b00 <sys_link+0x13c>
  begin_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	d12080e7          	jalr	-750(ra) # 80003712 <begin_op>
  if((ip = namei(old)) == 0){
    80004a08:	ed040513          	addi	a0,s0,-304
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	b06080e7          	jalr	-1274(ra) # 80003512 <namei>
    80004a14:	84aa                	mv	s1,a0
    80004a16:	c551                	beqz	a0,80004aa2 <sys_link+0xde>
  ilock(ip);
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	354080e7          	jalr	852(ra) # 80002d6c <ilock>
  if(ip->type == T_DIR){
    80004a20:	04449703          	lh	a4,68(s1)
    80004a24:	4785                	li	a5,1
    80004a26:	08f70463          	beq	a4,a5,80004aae <sys_link+0xea>
  ip->nlink++;
    80004a2a:	04a4d783          	lhu	a5,74(s1)
    80004a2e:	2785                	addiw	a5,a5,1
    80004a30:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	26a080e7          	jalr	618(ra) # 80002ca0 <iupdate>
  iunlock(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	3ee080e7          	jalr	1006(ra) # 80002e2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a48:	fd040593          	addi	a1,s0,-48
    80004a4c:	f5040513          	addi	a0,s0,-176
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	ae0080e7          	jalr	-1312(ra) # 80003530 <nameiparent>
    80004a58:	892a                	mv	s2,a0
    80004a5a:	c935                	beqz	a0,80004ace <sys_link+0x10a>
  ilock(dp);
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	310080e7          	jalr	784(ra) # 80002d6c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a64:	00092703          	lw	a4,0(s2)
    80004a68:	409c                	lw	a5,0(s1)
    80004a6a:	04f71d63          	bne	a4,a5,80004ac4 <sys_link+0x100>
    80004a6e:	40d0                	lw	a2,4(s1)
    80004a70:	fd040593          	addi	a1,s0,-48
    80004a74:	854a                	mv	a0,s2
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	9ea080e7          	jalr	-1558(ra) # 80003460 <dirlink>
    80004a7e:	04054363          	bltz	a0,80004ac4 <sys_link+0x100>
  iunlockput(dp);
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	54a080e7          	jalr	1354(ra) # 80002fce <iunlockput>
  iput(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	498080e7          	jalr	1176(ra) # 80002f26 <iput>
  end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	cf6080e7          	jalr	-778(ra) # 8000378c <end_op>
  return 0;
    80004a9e:	4781                	li	a5,0
    80004aa0:	a085                	j	80004b00 <sys_link+0x13c>
    end_op();
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	cea080e7          	jalr	-790(ra) # 8000378c <end_op>
    return -1;
    80004aaa:	57fd                	li	a5,-1
    80004aac:	a891                	j	80004b00 <sys_link+0x13c>
    iunlockput(ip);
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	51e080e7          	jalr	1310(ra) # 80002fce <iunlockput>
    end_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	cd4080e7          	jalr	-812(ra) # 8000378c <end_op>
    return -1;
    80004ac0:	57fd                	li	a5,-1
    80004ac2:	a83d                	j	80004b00 <sys_link+0x13c>
    iunlockput(dp);
    80004ac4:	854a                	mv	a0,s2
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	508080e7          	jalr	1288(ra) # 80002fce <iunlockput>
  ilock(ip);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	29c080e7          	jalr	668(ra) # 80002d6c <ilock>
  ip->nlink--;
    80004ad8:	04a4d783          	lhu	a5,74(s1)
    80004adc:	37fd                	addiw	a5,a5,-1
    80004ade:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	1bc080e7          	jalr	444(ra) # 80002ca0 <iupdate>
  iunlockput(ip);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	4e0080e7          	jalr	1248(ra) # 80002fce <iunlockput>
  end_op();
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	c96080e7          	jalr	-874(ra) # 8000378c <end_op>
  return -1;
    80004afe:	57fd                	li	a5,-1
}
    80004b00:	853e                	mv	a0,a5
    80004b02:	70b2                	ld	ra,296(sp)
    80004b04:	7412                	ld	s0,288(sp)
    80004b06:	64f2                	ld	s1,280(sp)
    80004b08:	6952                	ld	s2,272(sp)
    80004b0a:	6155                	addi	sp,sp,304
    80004b0c:	8082                	ret

0000000080004b0e <sys_unlink>:
{
    80004b0e:	7151                	addi	sp,sp,-240
    80004b10:	f586                	sd	ra,232(sp)
    80004b12:	f1a2                	sd	s0,224(sp)
    80004b14:	eda6                	sd	s1,216(sp)
    80004b16:	e9ca                	sd	s2,208(sp)
    80004b18:	e5ce                	sd	s3,200(sp)
    80004b1a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b1c:	08000613          	li	a2,128
    80004b20:	f3040593          	addi	a1,s0,-208
    80004b24:	4501                	li	a0,0
    80004b26:	ffffd097          	auipc	ra,0xffffd
    80004b2a:	6c6080e7          	jalr	1734(ra) # 800021ec <argstr>
    80004b2e:	18054163          	bltz	a0,80004cb0 <sys_unlink+0x1a2>
  begin_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	be0080e7          	jalr	-1056(ra) # 80003712 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b3a:	fb040593          	addi	a1,s0,-80
    80004b3e:	f3040513          	addi	a0,s0,-208
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	9ee080e7          	jalr	-1554(ra) # 80003530 <nameiparent>
    80004b4a:	84aa                	mv	s1,a0
    80004b4c:	c979                	beqz	a0,80004c22 <sys_unlink+0x114>
  ilock(dp);
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	21e080e7          	jalr	542(ra) # 80002d6c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b56:	00004597          	auipc	a1,0x4
    80004b5a:	b9258593          	addi	a1,a1,-1134 # 800086e8 <syscalls+0x2e8>
    80004b5e:	fb040513          	addi	a0,s0,-80
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	6d4080e7          	jalr	1748(ra) # 80003236 <namecmp>
    80004b6a:	14050a63          	beqz	a0,80004cbe <sys_unlink+0x1b0>
    80004b6e:	00004597          	auipc	a1,0x4
    80004b72:	b8258593          	addi	a1,a1,-1150 # 800086f0 <syscalls+0x2f0>
    80004b76:	fb040513          	addi	a0,s0,-80
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	6bc080e7          	jalr	1724(ra) # 80003236 <namecmp>
    80004b82:	12050e63          	beqz	a0,80004cbe <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b86:	f2c40613          	addi	a2,s0,-212
    80004b8a:	fb040593          	addi	a1,s0,-80
    80004b8e:	8526                	mv	a0,s1
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	6c0080e7          	jalr	1728(ra) # 80003250 <dirlookup>
    80004b98:	892a                	mv	s2,a0
    80004b9a:	12050263          	beqz	a0,80004cbe <sys_unlink+0x1b0>
  ilock(ip);
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	1ce080e7          	jalr	462(ra) # 80002d6c <ilock>
  if(ip->nlink < 1)
    80004ba6:	04a91783          	lh	a5,74(s2)
    80004baa:	08f05263          	blez	a5,80004c2e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bae:	04491703          	lh	a4,68(s2)
    80004bb2:	4785                	li	a5,1
    80004bb4:	08f70563          	beq	a4,a5,80004c3e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bb8:	4641                	li	a2,16
    80004bba:	4581                	li	a1,0
    80004bbc:	fc040513          	addi	a0,s0,-64
    80004bc0:	ffffb097          	auipc	ra,0xffffb
    80004bc4:	5ba080e7          	jalr	1466(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc8:	4741                	li	a4,16
    80004bca:	f2c42683          	lw	a3,-212(s0)
    80004bce:	fc040613          	addi	a2,s0,-64
    80004bd2:	4581                	li	a1,0
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	542080e7          	jalr	1346(ra) # 80003118 <writei>
    80004bde:	47c1                	li	a5,16
    80004be0:	0af51563          	bne	a0,a5,80004c8a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004be4:	04491703          	lh	a4,68(s2)
    80004be8:	4785                	li	a5,1
    80004bea:	0af70863          	beq	a4,a5,80004c9a <sys_unlink+0x18c>
  iunlockput(dp);
    80004bee:	8526                	mv	a0,s1
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	3de080e7          	jalr	990(ra) # 80002fce <iunlockput>
  ip->nlink--;
    80004bf8:	04a95783          	lhu	a5,74(s2)
    80004bfc:	37fd                	addiw	a5,a5,-1
    80004bfe:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c02:	854a                	mv	a0,s2
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	09c080e7          	jalr	156(ra) # 80002ca0 <iupdate>
  iunlockput(ip);
    80004c0c:	854a                	mv	a0,s2
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	3c0080e7          	jalr	960(ra) # 80002fce <iunlockput>
  end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	b76080e7          	jalr	-1162(ra) # 8000378c <end_op>
  return 0;
    80004c1e:	4501                	li	a0,0
    80004c20:	a84d                	j	80004cd2 <sys_unlink+0x1c4>
    end_op();
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	b6a080e7          	jalr	-1174(ra) # 8000378c <end_op>
    return -1;
    80004c2a:	557d                	li	a0,-1
    80004c2c:	a05d                	j	80004cd2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c2e:	00004517          	auipc	a0,0x4
    80004c32:	aca50513          	addi	a0,a0,-1334 # 800086f8 <syscalls+0x2f8>
    80004c36:	00001097          	auipc	ra,0x1
    80004c3a:	1a0080e7          	jalr	416(ra) # 80005dd6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c3e:	04c92703          	lw	a4,76(s2)
    80004c42:	02000793          	li	a5,32
    80004c46:	f6e7f9e3          	bgeu	a5,a4,80004bb8 <sys_unlink+0xaa>
    80004c4a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c4e:	4741                	li	a4,16
    80004c50:	86ce                	mv	a3,s3
    80004c52:	f1840613          	addi	a2,s0,-232
    80004c56:	4581                	li	a1,0
    80004c58:	854a                	mv	a0,s2
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	3c6080e7          	jalr	966(ra) # 80003020 <readi>
    80004c62:	47c1                	li	a5,16
    80004c64:	00f51b63          	bne	a0,a5,80004c7a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c68:	f1845783          	lhu	a5,-232(s0)
    80004c6c:	e7a1                	bnez	a5,80004cb4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c6e:	29c1                	addiw	s3,s3,16
    80004c70:	04c92783          	lw	a5,76(s2)
    80004c74:	fcf9ede3          	bltu	s3,a5,80004c4e <sys_unlink+0x140>
    80004c78:	b781                	j	80004bb8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c7a:	00004517          	auipc	a0,0x4
    80004c7e:	a9650513          	addi	a0,a0,-1386 # 80008710 <syscalls+0x310>
    80004c82:	00001097          	auipc	ra,0x1
    80004c86:	154080e7          	jalr	340(ra) # 80005dd6 <panic>
    panic("unlink: writei");
    80004c8a:	00004517          	auipc	a0,0x4
    80004c8e:	a9e50513          	addi	a0,a0,-1378 # 80008728 <syscalls+0x328>
    80004c92:	00001097          	auipc	ra,0x1
    80004c96:	144080e7          	jalr	324(ra) # 80005dd6 <panic>
    dp->nlink--;
    80004c9a:	04a4d783          	lhu	a5,74(s1)
    80004c9e:	37fd                	addiw	a5,a5,-1
    80004ca0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	ffa080e7          	jalr	-6(ra) # 80002ca0 <iupdate>
    80004cae:	b781                	j	80004bee <sys_unlink+0xe0>
    return -1;
    80004cb0:	557d                	li	a0,-1
    80004cb2:	a005                	j	80004cd2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cb4:	854a                	mv	a0,s2
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	318080e7          	jalr	792(ra) # 80002fce <iunlockput>
  iunlockput(dp);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	30e080e7          	jalr	782(ra) # 80002fce <iunlockput>
  end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	ac4080e7          	jalr	-1340(ra) # 8000378c <end_op>
  return -1;
    80004cd0:	557d                	li	a0,-1
}
    80004cd2:	70ae                	ld	ra,232(sp)
    80004cd4:	740e                	ld	s0,224(sp)
    80004cd6:	64ee                	ld	s1,216(sp)
    80004cd8:	694e                	ld	s2,208(sp)
    80004cda:	69ae                	ld	s3,200(sp)
    80004cdc:	616d                	addi	sp,sp,240
    80004cde:	8082                	ret

0000000080004ce0 <sys_open>:

uint64
sys_open(void)
{
    80004ce0:	7131                	addi	sp,sp,-192
    80004ce2:	fd06                	sd	ra,184(sp)
    80004ce4:	f922                	sd	s0,176(sp)
    80004ce6:	f526                	sd	s1,168(sp)
    80004ce8:	f14a                	sd	s2,160(sp)
    80004cea:	ed4e                	sd	s3,152(sp)
    80004cec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cee:	f4c40593          	addi	a1,s0,-180
    80004cf2:	4505                	li	a0,1
    80004cf4:	ffffd097          	auipc	ra,0xffffd
    80004cf8:	4b8080e7          	jalr	1208(ra) # 800021ac <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cfc:	08000613          	li	a2,128
    80004d00:	f5040593          	addi	a1,s0,-176
    80004d04:	4501                	li	a0,0
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	4e6080e7          	jalr	1254(ra) # 800021ec <argstr>
    80004d0e:	87aa                	mv	a5,a0
    return -1;
    80004d10:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d12:	0a07c863          	bltz	a5,80004dc2 <sys_open+0xe2>

  begin_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	9fc080e7          	jalr	-1540(ra) # 80003712 <begin_op>

  if(omode & O_CREATE){
    80004d1e:	f4c42783          	lw	a5,-180(s0)
    80004d22:	2007f793          	andi	a5,a5,512
    80004d26:	cbdd                	beqz	a5,80004ddc <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004d28:	4681                	li	a3,0
    80004d2a:	4601                	li	a2,0
    80004d2c:	4589                	li	a1,2
    80004d2e:	f5040513          	addi	a0,s0,-176
    80004d32:	00000097          	auipc	ra,0x0
    80004d36:	97a080e7          	jalr	-1670(ra) # 800046ac <create>
    80004d3a:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d3c:	c951                	beqz	a0,80004dd0 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d3e:	04449703          	lh	a4,68(s1)
    80004d42:	478d                	li	a5,3
    80004d44:	00f71763          	bne	a4,a5,80004d52 <sys_open+0x72>
    80004d48:	0464d703          	lhu	a4,70(s1)
    80004d4c:	47a5                	li	a5,9
    80004d4e:	0ce7ec63          	bltu	a5,a4,80004e26 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d52:	fffff097          	auipc	ra,0xfffff
    80004d56:	dc8080e7          	jalr	-568(ra) # 80003b1a <filealloc>
    80004d5a:	892a                	mv	s2,a0
    80004d5c:	c56d                	beqz	a0,80004e46 <sys_open+0x166>
    80004d5e:	00000097          	auipc	ra,0x0
    80004d62:	90c080e7          	jalr	-1780(ra) # 8000466a <fdalloc>
    80004d66:	89aa                	mv	s3,a0
    80004d68:	0c054a63          	bltz	a0,80004e3c <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d6c:	04449703          	lh	a4,68(s1)
    80004d70:	478d                	li	a5,3
    80004d72:	0ef70563          	beq	a4,a5,80004e5c <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d76:	4789                	li	a5,2
    80004d78:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d7c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d80:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d84:	f4c42783          	lw	a5,-180(s0)
    80004d88:	0017c713          	xori	a4,a5,1
    80004d8c:	8b05                	andi	a4,a4,1
    80004d8e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d92:	0037f713          	andi	a4,a5,3
    80004d96:	00e03733          	snez	a4,a4
    80004d9a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d9e:	4007f793          	andi	a5,a5,1024
    80004da2:	c791                	beqz	a5,80004dae <sys_open+0xce>
    80004da4:	04449703          	lh	a4,68(s1)
    80004da8:	4789                	li	a5,2
    80004daa:	0cf70063          	beq	a4,a5,80004e6a <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004dae:	8526                	mv	a0,s1
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	07e080e7          	jalr	126(ra) # 80002e2e <iunlock>
  end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	9d4080e7          	jalr	-1580(ra) # 8000378c <end_op>

  return fd;
    80004dc0:	854e                	mv	a0,s3
}
    80004dc2:	70ea                	ld	ra,184(sp)
    80004dc4:	744a                	ld	s0,176(sp)
    80004dc6:	74aa                	ld	s1,168(sp)
    80004dc8:	790a                	ld	s2,160(sp)
    80004dca:	69ea                	ld	s3,152(sp)
    80004dcc:	6129                	addi	sp,sp,192
    80004dce:	8082                	ret
      end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	9bc080e7          	jalr	-1604(ra) # 8000378c <end_op>
      return -1;
    80004dd8:	557d                	li	a0,-1
    80004dda:	b7e5                	j	80004dc2 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004ddc:	f5040513          	addi	a0,s0,-176
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	732080e7          	jalr	1842(ra) # 80003512 <namei>
    80004de8:	84aa                	mv	s1,a0
    80004dea:	c905                	beqz	a0,80004e1a <sys_open+0x13a>
    ilock(ip);
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	f80080e7          	jalr	-128(ra) # 80002d6c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004df4:	04449703          	lh	a4,68(s1)
    80004df8:	4785                	li	a5,1
    80004dfa:	f4f712e3          	bne	a4,a5,80004d3e <sys_open+0x5e>
    80004dfe:	f4c42783          	lw	a5,-180(s0)
    80004e02:	dba1                	beqz	a5,80004d52 <sys_open+0x72>
      iunlockput(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	1c8080e7          	jalr	456(ra) # 80002fce <iunlockput>
      end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	97e080e7          	jalr	-1666(ra) # 8000378c <end_op>
      return -1;
    80004e16:	557d                	li	a0,-1
    80004e18:	b76d                	j	80004dc2 <sys_open+0xe2>
      end_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	972080e7          	jalr	-1678(ra) # 8000378c <end_op>
      return -1;
    80004e22:	557d                	li	a0,-1
    80004e24:	bf79                	j	80004dc2 <sys_open+0xe2>
    iunlockput(ip);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	1a6080e7          	jalr	422(ra) # 80002fce <iunlockput>
    end_op();
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	95c080e7          	jalr	-1700(ra) # 8000378c <end_op>
    return -1;
    80004e38:	557d                	li	a0,-1
    80004e3a:	b761                	j	80004dc2 <sys_open+0xe2>
      fileclose(f);
    80004e3c:	854a                	mv	a0,s2
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	d98080e7          	jalr	-616(ra) # 80003bd6 <fileclose>
    iunlockput(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	186080e7          	jalr	390(ra) # 80002fce <iunlockput>
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	93c080e7          	jalr	-1732(ra) # 8000378c <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	b7a5                	j	80004dc2 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004e5c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e60:	04649783          	lh	a5,70(s1)
    80004e64:	02f91223          	sh	a5,36(s2)
    80004e68:	bf21                	j	80004d80 <sys_open+0xa0>
    itrunc(ip);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	00e080e7          	jalr	14(ra) # 80002e7a <itrunc>
    80004e74:	bf2d                	j	80004dae <sys_open+0xce>

0000000080004e76 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e76:	7175                	addi	sp,sp,-144
    80004e78:	e506                	sd	ra,136(sp)
    80004e7a:	e122                	sd	s0,128(sp)
    80004e7c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	894080e7          	jalr	-1900(ra) # 80003712 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e86:	08000613          	li	a2,128
    80004e8a:	f7040593          	addi	a1,s0,-144
    80004e8e:	4501                	li	a0,0
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	35c080e7          	jalr	860(ra) # 800021ec <argstr>
    80004e98:	02054963          	bltz	a0,80004eca <sys_mkdir+0x54>
    80004e9c:	4681                	li	a3,0
    80004e9e:	4601                	li	a2,0
    80004ea0:	4585                	li	a1,1
    80004ea2:	f7040513          	addi	a0,s0,-144
    80004ea6:	00000097          	auipc	ra,0x0
    80004eaa:	806080e7          	jalr	-2042(ra) # 800046ac <create>
    80004eae:	cd11                	beqz	a0,80004eca <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	11e080e7          	jalr	286(ra) # 80002fce <iunlockput>
  end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	8d4080e7          	jalr	-1836(ra) # 8000378c <end_op>
  return 0;
    80004ec0:	4501                	li	a0,0
}
    80004ec2:	60aa                	ld	ra,136(sp)
    80004ec4:	640a                	ld	s0,128(sp)
    80004ec6:	6149                	addi	sp,sp,144
    80004ec8:	8082                	ret
    end_op();
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	8c2080e7          	jalr	-1854(ra) # 8000378c <end_op>
    return -1;
    80004ed2:	557d                	li	a0,-1
    80004ed4:	b7fd                	j	80004ec2 <sys_mkdir+0x4c>

0000000080004ed6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ed6:	7135                	addi	sp,sp,-160
    80004ed8:	ed06                	sd	ra,152(sp)
    80004eda:	e922                	sd	s0,144(sp)
    80004edc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	834080e7          	jalr	-1996(ra) # 80003712 <begin_op>
  argint(1, &major);
    80004ee6:	f6c40593          	addi	a1,s0,-148
    80004eea:	4505                	li	a0,1
    80004eec:	ffffd097          	auipc	ra,0xffffd
    80004ef0:	2c0080e7          	jalr	704(ra) # 800021ac <argint>
  argint(2, &minor);
    80004ef4:	f6840593          	addi	a1,s0,-152
    80004ef8:	4509                	li	a0,2
    80004efa:	ffffd097          	auipc	ra,0xffffd
    80004efe:	2b2080e7          	jalr	690(ra) # 800021ac <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f02:	08000613          	li	a2,128
    80004f06:	f7040593          	addi	a1,s0,-144
    80004f0a:	4501                	li	a0,0
    80004f0c:	ffffd097          	auipc	ra,0xffffd
    80004f10:	2e0080e7          	jalr	736(ra) # 800021ec <argstr>
    80004f14:	02054b63          	bltz	a0,80004f4a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f18:	f6841683          	lh	a3,-152(s0)
    80004f1c:	f6c41603          	lh	a2,-148(s0)
    80004f20:	458d                	li	a1,3
    80004f22:	f7040513          	addi	a0,s0,-144
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	786080e7          	jalr	1926(ra) # 800046ac <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f2e:	cd11                	beqz	a0,80004f4a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	09e080e7          	jalr	158(ra) # 80002fce <iunlockput>
  end_op();
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	854080e7          	jalr	-1964(ra) # 8000378c <end_op>
  return 0;
    80004f40:	4501                	li	a0,0
}
    80004f42:	60ea                	ld	ra,152(sp)
    80004f44:	644a                	ld	s0,144(sp)
    80004f46:	610d                	addi	sp,sp,160
    80004f48:	8082                	ret
    end_op();
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	842080e7          	jalr	-1982(ra) # 8000378c <end_op>
    return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	b7fd                	j	80004f42 <sys_mknod+0x6c>

0000000080004f56 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f56:	7135                	addi	sp,sp,-160
    80004f58:	ed06                	sd	ra,152(sp)
    80004f5a:	e922                	sd	s0,144(sp)
    80004f5c:	e526                	sd	s1,136(sp)
    80004f5e:	e14a                	sd	s2,128(sp)
    80004f60:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f62:	ffffc097          	auipc	ra,0xffffc
    80004f66:	fe6080e7          	jalr	-26(ra) # 80000f48 <myproc>
    80004f6a:	892a                	mv	s2,a0
  
  begin_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	7a6080e7          	jalr	1958(ra) # 80003712 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f74:	08000613          	li	a2,128
    80004f78:	f6040593          	addi	a1,s0,-160
    80004f7c:	4501                	li	a0,0
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	26e080e7          	jalr	622(ra) # 800021ec <argstr>
    80004f86:	04054b63          	bltz	a0,80004fdc <sys_chdir+0x86>
    80004f8a:	f6040513          	addi	a0,s0,-160
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	584080e7          	jalr	1412(ra) # 80003512 <namei>
    80004f96:	84aa                	mv	s1,a0
    80004f98:	c131                	beqz	a0,80004fdc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	dd2080e7          	jalr	-558(ra) # 80002d6c <ilock>
  if(ip->type != T_DIR){
    80004fa2:	04449703          	lh	a4,68(s1)
    80004fa6:	4785                	li	a5,1
    80004fa8:	04f71063          	bne	a4,a5,80004fe8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fac:	8526                	mv	a0,s1
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	e80080e7          	jalr	-384(ra) # 80002e2e <iunlock>
  iput(p->cwd);
    80004fb6:	15893503          	ld	a0,344(s2)
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	f6c080e7          	jalr	-148(ra) # 80002f26 <iput>
  end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	7ca080e7          	jalr	1994(ra) # 8000378c <end_op>
  p->cwd = ip;
    80004fca:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fce:	4501                	li	a0,0
}
    80004fd0:	60ea                	ld	ra,152(sp)
    80004fd2:	644a                	ld	s0,144(sp)
    80004fd4:	64aa                	ld	s1,136(sp)
    80004fd6:	690a                	ld	s2,128(sp)
    80004fd8:	610d                	addi	sp,sp,160
    80004fda:	8082                	ret
    end_op();
    80004fdc:	ffffe097          	auipc	ra,0xffffe
    80004fe0:	7b0080e7          	jalr	1968(ra) # 8000378c <end_op>
    return -1;
    80004fe4:	557d                	li	a0,-1
    80004fe6:	b7ed                	j	80004fd0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fe8:	8526                	mv	a0,s1
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	fe4080e7          	jalr	-28(ra) # 80002fce <iunlockput>
    end_op();
    80004ff2:	ffffe097          	auipc	ra,0xffffe
    80004ff6:	79a080e7          	jalr	1946(ra) # 8000378c <end_op>
    return -1;
    80004ffa:	557d                	li	a0,-1
    80004ffc:	bfd1                	j	80004fd0 <sys_chdir+0x7a>

0000000080004ffe <sys_exec>:

uint64
sys_exec(void)
{
    80004ffe:	7121                	addi	sp,sp,-448
    80005000:	ff06                	sd	ra,440(sp)
    80005002:	fb22                	sd	s0,432(sp)
    80005004:	f726                	sd	s1,424(sp)
    80005006:	f34a                	sd	s2,416(sp)
    80005008:	ef4e                	sd	s3,408(sp)
    8000500a:	eb52                	sd	s4,400(sp)
    8000500c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000500e:	e4840593          	addi	a1,s0,-440
    80005012:	4505                	li	a0,1
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	1b8080e7          	jalr	440(ra) # 800021cc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000501c:	08000613          	li	a2,128
    80005020:	f5040593          	addi	a1,s0,-176
    80005024:	4501                	li	a0,0
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	1c6080e7          	jalr	454(ra) # 800021ec <argstr>
    8000502e:	87aa                	mv	a5,a0
    return -1;
    80005030:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005032:	0c07c263          	bltz	a5,800050f6 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80005036:	10000613          	li	a2,256
    8000503a:	4581                	li	a1,0
    8000503c:	e5040513          	addi	a0,s0,-432
    80005040:	ffffb097          	auipc	ra,0xffffb
    80005044:	13a080e7          	jalr	314(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005048:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000504c:	89a6                	mv	s3,s1
    8000504e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005050:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005054:	00391513          	slli	a0,s2,0x3
    80005058:	e4040593          	addi	a1,s0,-448
    8000505c:	e4843783          	ld	a5,-440(s0)
    80005060:	953e                	add	a0,a0,a5
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	0ac080e7          	jalr	172(ra) # 8000210e <fetchaddr>
    8000506a:	02054a63          	bltz	a0,8000509e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    8000506e:	e4043783          	ld	a5,-448(s0)
    80005072:	c3b9                	beqz	a5,800050b8 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005074:	ffffb097          	auipc	ra,0xffffb
    80005078:	0a6080e7          	jalr	166(ra) # 8000011a <kalloc>
    8000507c:	85aa                	mv	a1,a0
    8000507e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005082:	cd11                	beqz	a0,8000509e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005084:	6605                	lui	a2,0x1
    80005086:	e4043503          	ld	a0,-448(s0)
    8000508a:	ffffd097          	auipc	ra,0xffffd
    8000508e:	0d6080e7          	jalr	214(ra) # 80002160 <fetchstr>
    80005092:	00054663          	bltz	a0,8000509e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005096:	0905                	addi	s2,s2,1
    80005098:	09a1                	addi	s3,s3,8
    8000509a:	fb491de3          	bne	s2,s4,80005054 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509e:	f5040913          	addi	s2,s0,-176
    800050a2:	6088                	ld	a0,0(s1)
    800050a4:	c921                	beqz	a0,800050f4 <sys_exec+0xf6>
    kfree(argv[i]);
    800050a6:	ffffb097          	auipc	ra,0xffffb
    800050aa:	f76080e7          	jalr	-138(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ae:	04a1                	addi	s1,s1,8
    800050b0:	ff2499e3          	bne	s1,s2,800050a2 <sys_exec+0xa4>
  return -1;
    800050b4:	557d                	li	a0,-1
    800050b6:	a081                	j	800050f6 <sys_exec+0xf8>
      argv[i] = 0;
    800050b8:	0009079b          	sext.w	a5,s2
    800050bc:	078e                	slli	a5,a5,0x3
    800050be:	fd078793          	addi	a5,a5,-48
    800050c2:	97a2                	add	a5,a5,s0
    800050c4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050c8:	e5040593          	addi	a1,s0,-432
    800050cc:	f5040513          	addi	a0,s0,-176
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	17c080e7          	jalr	380(ra) # 8000424c <exec>
    800050d8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050da:	f5040993          	addi	s3,s0,-176
    800050de:	6088                	ld	a0,0(s1)
    800050e0:	c901                	beqz	a0,800050f0 <sys_exec+0xf2>
    kfree(argv[i]);
    800050e2:	ffffb097          	auipc	ra,0xffffb
    800050e6:	f3a080e7          	jalr	-198(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ea:	04a1                	addi	s1,s1,8
    800050ec:	ff3499e3          	bne	s1,s3,800050de <sys_exec+0xe0>
  return ret;
    800050f0:	854a                	mv	a0,s2
    800050f2:	a011                	j	800050f6 <sys_exec+0xf8>
  return -1;
    800050f4:	557d                	li	a0,-1
}
    800050f6:	70fa                	ld	ra,440(sp)
    800050f8:	745a                	ld	s0,432(sp)
    800050fa:	74ba                	ld	s1,424(sp)
    800050fc:	791a                	ld	s2,416(sp)
    800050fe:	69fa                	ld	s3,408(sp)
    80005100:	6a5a                	ld	s4,400(sp)
    80005102:	6139                	addi	sp,sp,448
    80005104:	8082                	ret

0000000080005106 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005106:	7139                	addi	sp,sp,-64
    80005108:	fc06                	sd	ra,56(sp)
    8000510a:	f822                	sd	s0,48(sp)
    8000510c:	f426                	sd	s1,40(sp)
    8000510e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005110:	ffffc097          	auipc	ra,0xffffc
    80005114:	e38080e7          	jalr	-456(ra) # 80000f48 <myproc>
    80005118:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000511a:	fd840593          	addi	a1,s0,-40
    8000511e:	4501                	li	a0,0
    80005120:	ffffd097          	auipc	ra,0xffffd
    80005124:	0ac080e7          	jalr	172(ra) # 800021cc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005128:	fc840593          	addi	a1,s0,-56
    8000512c:	fd040513          	addi	a0,s0,-48
    80005130:	fffff097          	auipc	ra,0xfffff
    80005134:	dd2080e7          	jalr	-558(ra) # 80003f02 <pipealloc>
    return -1;
    80005138:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000513a:	0c054463          	bltz	a0,80005202 <sys_pipe+0xfc>
  fd0 = -1;
    8000513e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005142:	fd043503          	ld	a0,-48(s0)
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	524080e7          	jalr	1316(ra) # 8000466a <fdalloc>
    8000514e:	fca42223          	sw	a0,-60(s0)
    80005152:	08054b63          	bltz	a0,800051e8 <sys_pipe+0xe2>
    80005156:	fc843503          	ld	a0,-56(s0)
    8000515a:	fffff097          	auipc	ra,0xfffff
    8000515e:	510080e7          	jalr	1296(ra) # 8000466a <fdalloc>
    80005162:	fca42023          	sw	a0,-64(s0)
    80005166:	06054863          	bltz	a0,800051d6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516a:	4691                	li	a3,4
    8000516c:	fc440613          	addi	a2,s0,-60
    80005170:	fd843583          	ld	a1,-40(s0)
    80005174:	68a8                	ld	a0,80(s1)
    80005176:	ffffc097          	auipc	ra,0xffffc
    8000517a:	99c080e7          	jalr	-1636(ra) # 80000b12 <copyout>
    8000517e:	02054063          	bltz	a0,8000519e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005182:	4691                	li	a3,4
    80005184:	fc040613          	addi	a2,s0,-64
    80005188:	fd843583          	ld	a1,-40(s0)
    8000518c:	0591                	addi	a1,a1,4
    8000518e:	68a8                	ld	a0,80(s1)
    80005190:	ffffc097          	auipc	ra,0xffffc
    80005194:	982080e7          	jalr	-1662(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005198:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000519a:	06055463          	bgez	a0,80005202 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000519e:	fc442783          	lw	a5,-60(s0)
    800051a2:	07e9                	addi	a5,a5,26
    800051a4:	078e                	slli	a5,a5,0x3
    800051a6:	97a6                	add	a5,a5,s1
    800051a8:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051ac:	fc042783          	lw	a5,-64(s0)
    800051b0:	07e9                	addi	a5,a5,26
    800051b2:	078e                	slli	a5,a5,0x3
    800051b4:	94be                	add	s1,s1,a5
    800051b6:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800051ba:	fd043503          	ld	a0,-48(s0)
    800051be:	fffff097          	auipc	ra,0xfffff
    800051c2:	a18080e7          	jalr	-1512(ra) # 80003bd6 <fileclose>
    fileclose(wf);
    800051c6:	fc843503          	ld	a0,-56(s0)
    800051ca:	fffff097          	auipc	ra,0xfffff
    800051ce:	a0c080e7          	jalr	-1524(ra) # 80003bd6 <fileclose>
    return -1;
    800051d2:	57fd                	li	a5,-1
    800051d4:	a03d                	j	80005202 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051d6:	fc442783          	lw	a5,-60(s0)
    800051da:	0007c763          	bltz	a5,800051e8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051de:	07e9                	addi	a5,a5,26
    800051e0:	078e                	slli	a5,a5,0x3
    800051e2:	97a6                	add	a5,a5,s1
    800051e4:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800051e8:	fd043503          	ld	a0,-48(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	9ea080e7          	jalr	-1558(ra) # 80003bd6 <fileclose>
    fileclose(wf);
    800051f4:	fc843503          	ld	a0,-56(s0)
    800051f8:	fffff097          	auipc	ra,0xfffff
    800051fc:	9de080e7          	jalr	-1570(ra) # 80003bd6 <fileclose>
    return -1;
    80005200:	57fd                	li	a5,-1
}
    80005202:	853e                	mv	a0,a5
    80005204:	70e2                	ld	ra,56(sp)
    80005206:	7442                	ld	s0,48(sp)
    80005208:	74a2                	ld	s1,40(sp)
    8000520a:	6121                	addi	sp,sp,64
    8000520c:	8082                	ret
	...

0000000080005210 <kernelvec>:
    80005210:	7111                	addi	sp,sp,-256
    80005212:	e006                	sd	ra,0(sp)
    80005214:	e40a                	sd	sp,8(sp)
    80005216:	e80e                	sd	gp,16(sp)
    80005218:	ec12                	sd	tp,24(sp)
    8000521a:	f016                	sd	t0,32(sp)
    8000521c:	f41a                	sd	t1,40(sp)
    8000521e:	f81e                	sd	t2,48(sp)
    80005220:	fc22                	sd	s0,56(sp)
    80005222:	e0a6                	sd	s1,64(sp)
    80005224:	e4aa                	sd	a0,72(sp)
    80005226:	e8ae                	sd	a1,80(sp)
    80005228:	ecb2                	sd	a2,88(sp)
    8000522a:	f0b6                	sd	a3,96(sp)
    8000522c:	f4ba                	sd	a4,104(sp)
    8000522e:	f8be                	sd	a5,112(sp)
    80005230:	fcc2                	sd	a6,120(sp)
    80005232:	e146                	sd	a7,128(sp)
    80005234:	e54a                	sd	s2,136(sp)
    80005236:	e94e                	sd	s3,144(sp)
    80005238:	ed52                	sd	s4,152(sp)
    8000523a:	f156                	sd	s5,160(sp)
    8000523c:	f55a                	sd	s6,168(sp)
    8000523e:	f95e                	sd	s7,176(sp)
    80005240:	fd62                	sd	s8,184(sp)
    80005242:	e1e6                	sd	s9,192(sp)
    80005244:	e5ea                	sd	s10,200(sp)
    80005246:	e9ee                	sd	s11,208(sp)
    80005248:	edf2                	sd	t3,216(sp)
    8000524a:	f1f6                	sd	t4,224(sp)
    8000524c:	f5fa                	sd	t5,232(sp)
    8000524e:	f9fe                	sd	t6,240(sp)
    80005250:	d8bfc0ef          	jal	ra,80001fda <kerneltrap>
    80005254:	6082                	ld	ra,0(sp)
    80005256:	6122                	ld	sp,8(sp)
    80005258:	61c2                	ld	gp,16(sp)
    8000525a:	7282                	ld	t0,32(sp)
    8000525c:	7322                	ld	t1,40(sp)
    8000525e:	73c2                	ld	t2,48(sp)
    80005260:	7462                	ld	s0,56(sp)
    80005262:	6486                	ld	s1,64(sp)
    80005264:	6526                	ld	a0,72(sp)
    80005266:	65c6                	ld	a1,80(sp)
    80005268:	6666                	ld	a2,88(sp)
    8000526a:	7686                	ld	a3,96(sp)
    8000526c:	7726                	ld	a4,104(sp)
    8000526e:	77c6                	ld	a5,112(sp)
    80005270:	7866                	ld	a6,120(sp)
    80005272:	688a                	ld	a7,128(sp)
    80005274:	692a                	ld	s2,136(sp)
    80005276:	69ca                	ld	s3,144(sp)
    80005278:	6a6a                	ld	s4,152(sp)
    8000527a:	7a8a                	ld	s5,160(sp)
    8000527c:	7b2a                	ld	s6,168(sp)
    8000527e:	7bca                	ld	s7,176(sp)
    80005280:	7c6a                	ld	s8,184(sp)
    80005282:	6c8e                	ld	s9,192(sp)
    80005284:	6d2e                	ld	s10,200(sp)
    80005286:	6dce                	ld	s11,208(sp)
    80005288:	6e6e                	ld	t3,216(sp)
    8000528a:	7e8e                	ld	t4,224(sp)
    8000528c:	7f2e                	ld	t5,232(sp)
    8000528e:	7fce                	ld	t6,240(sp)
    80005290:	6111                	addi	sp,sp,256
    80005292:	10200073          	sret
    80005296:	00000013          	nop
    8000529a:	00000013          	nop
    8000529e:	0001                	nop

00000000800052a0 <timervec>:
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	e10c                	sd	a1,0(a0)
    800052a6:	e510                	sd	a2,8(a0)
    800052a8:	e914                	sd	a3,16(a0)
    800052aa:	6d0c                	ld	a1,24(a0)
    800052ac:	7110                	ld	a2,32(a0)
    800052ae:	6194                	ld	a3,0(a1)
    800052b0:	96b2                	add	a3,a3,a2
    800052b2:	e194                	sd	a3,0(a1)
    800052b4:	4589                	li	a1,2
    800052b6:	14459073          	csrw	sip,a1
    800052ba:	6914                	ld	a3,16(a0)
    800052bc:	6510                	ld	a2,8(a0)
    800052be:	610c                	ld	a1,0(a0)
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	30200073          	mret
	...

00000000800052ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ca:	1141                	addi	sp,sp,-16
    800052cc:	e422                	sd	s0,8(sp)
    800052ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052d0:	0c0007b7          	lui	a5,0xc000
    800052d4:	4705                	li	a4,1
    800052d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052d8:	c3d8                	sw	a4,4(a5)
}
    800052da:	6422                	ld	s0,8(sp)
    800052dc:	0141                	addi	sp,sp,16
    800052de:	8082                	ret

00000000800052e0 <plicinithart>:

void
plicinithart(void)
{
    800052e0:	1141                	addi	sp,sp,-16
    800052e2:	e406                	sd	ra,8(sp)
    800052e4:	e022                	sd	s0,0(sp)
    800052e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	c34080e7          	jalr	-972(ra) # 80000f1c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052f0:	0085171b          	slliw	a4,a0,0x8
    800052f4:	0c0027b7          	lui	a5,0xc002
    800052f8:	97ba                	add	a5,a5,a4
    800052fa:	40200713          	li	a4,1026
    800052fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005302:	00d5151b          	slliw	a0,a0,0xd
    80005306:	0c2017b7          	lui	a5,0xc201
    8000530a:	97aa                	add	a5,a5,a0
    8000530c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005310:	60a2                	ld	ra,8(sp)
    80005312:	6402                	ld	s0,0(sp)
    80005314:	0141                	addi	sp,sp,16
    80005316:	8082                	ret

0000000080005318 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005318:	1141                	addi	sp,sp,-16
    8000531a:	e406                	sd	ra,8(sp)
    8000531c:	e022                	sd	s0,0(sp)
    8000531e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005320:	ffffc097          	auipc	ra,0xffffc
    80005324:	bfc080e7          	jalr	-1028(ra) # 80000f1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005328:	00d5151b          	slliw	a0,a0,0xd
    8000532c:	0c2017b7          	lui	a5,0xc201
    80005330:	97aa                	add	a5,a5,a0
  return irq;
}
    80005332:	43c8                	lw	a0,4(a5)
    80005334:	60a2                	ld	ra,8(sp)
    80005336:	6402                	ld	s0,0(sp)
    80005338:	0141                	addi	sp,sp,16
    8000533a:	8082                	ret

000000008000533c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000533c:	1101                	addi	sp,sp,-32
    8000533e:	ec06                	sd	ra,24(sp)
    80005340:	e822                	sd	s0,16(sp)
    80005342:	e426                	sd	s1,8(sp)
    80005344:	1000                	addi	s0,sp,32
    80005346:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	bd4080e7          	jalr	-1068(ra) # 80000f1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005350:	00d5151b          	slliw	a0,a0,0xd
    80005354:	0c2017b7          	lui	a5,0xc201
    80005358:	97aa                	add	a5,a5,a0
    8000535a:	c3c4                	sw	s1,4(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret

0000000080005366 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005366:	1141                	addi	sp,sp,-16
    80005368:	e406                	sd	ra,8(sp)
    8000536a:	e022                	sd	s0,0(sp)
    8000536c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000536e:	479d                	li	a5,7
    80005370:	04a7cc63          	blt	a5,a0,800053c8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005374:	00015797          	auipc	a5,0x15
    80005378:	8dc78793          	addi	a5,a5,-1828 # 80019c50 <disk>
    8000537c:	97aa                	add	a5,a5,a0
    8000537e:	0187c783          	lbu	a5,24(a5)
    80005382:	ebb9                	bnez	a5,800053d8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005384:	00451693          	slli	a3,a0,0x4
    80005388:	00015797          	auipc	a5,0x15
    8000538c:	8c878793          	addi	a5,a5,-1848 # 80019c50 <disk>
    80005390:	6398                	ld	a4,0(a5)
    80005392:	9736                	add	a4,a4,a3
    80005394:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005398:	6398                	ld	a4,0(a5)
    8000539a:	9736                	add	a4,a4,a3
    8000539c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053a0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053a4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053a8:	97aa                	add	a5,a5,a0
    800053aa:	4705                	li	a4,1
    800053ac:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053b0:	00015517          	auipc	a0,0x15
    800053b4:	8b850513          	addi	a0,a0,-1864 # 80019c68 <disk+0x18>
    800053b8:	ffffc097          	auipc	ra,0xffffc
    800053bc:	34a080e7          	jalr	842(ra) # 80001702 <wakeup>
}
    800053c0:	60a2                	ld	ra,8(sp)
    800053c2:	6402                	ld	s0,0(sp)
    800053c4:	0141                	addi	sp,sp,16
    800053c6:	8082                	ret
    panic("free_desc 1");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	37050513          	addi	a0,a0,880 # 80008738 <syscalls+0x338>
    800053d0:	00001097          	auipc	ra,0x1
    800053d4:	a06080e7          	jalr	-1530(ra) # 80005dd6 <panic>
    panic("free_desc 2");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	37050513          	addi	a0,a0,880 # 80008748 <syscalls+0x348>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	9f6080e7          	jalr	-1546(ra) # 80005dd6 <panic>

00000000800053e8 <virtio_disk_init>:
{
    800053e8:	1101                	addi	sp,sp,-32
    800053ea:	ec06                	sd	ra,24(sp)
    800053ec:	e822                	sd	s0,16(sp)
    800053ee:	e426                	sd	s1,8(sp)
    800053f0:	e04a                	sd	s2,0(sp)
    800053f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053f4:	00003597          	auipc	a1,0x3
    800053f8:	36458593          	addi	a1,a1,868 # 80008758 <syscalls+0x358>
    800053fc:	00015517          	auipc	a0,0x15
    80005400:	97c50513          	addi	a0,a0,-1668 # 80019d78 <disk+0x128>
    80005404:	00001097          	auipc	ra,0x1
    80005408:	e7a080e7          	jalr	-390(ra) # 8000627e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	4398                	lw	a4,0(a5)
    80005412:	2701                	sext.w	a4,a4
    80005414:	747277b7          	lui	a5,0x74727
    80005418:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000541c:	14f71b63          	bne	a4,a5,80005572 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005420:	100017b7          	lui	a5,0x10001
    80005424:	43dc                	lw	a5,4(a5)
    80005426:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005428:	4709                	li	a4,2
    8000542a:	14e79463          	bne	a5,a4,80005572 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	479c                	lw	a5,8(a5)
    80005434:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005436:	12e79e63          	bne	a5,a4,80005572 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000543a:	100017b7          	lui	a5,0x10001
    8000543e:	47d8                	lw	a4,12(a5)
    80005440:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005442:	554d47b7          	lui	a5,0x554d4
    80005446:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000544a:	12f71463          	bne	a4,a5,80005572 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544e:	100017b7          	lui	a5,0x10001
    80005452:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005456:	4705                	li	a4,1
    80005458:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000545a:	470d                	li	a4,3
    8000545c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000545e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005460:	c7ffe6b7          	lui	a3,0xc7ffe
    80005464:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc78f>
    80005468:	8f75                	and	a4,a4,a3
    8000546a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000546c:	472d                	li	a4,11
    8000546e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005470:	5bbc                	lw	a5,112(a5)
    80005472:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005476:	8ba1                	andi	a5,a5,8
    80005478:	10078563          	beqz	a5,80005582 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000547c:	100017b7          	lui	a5,0x10001
    80005480:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005484:	43fc                	lw	a5,68(a5)
    80005486:	2781                	sext.w	a5,a5
    80005488:	10079563          	bnez	a5,80005592 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000548c:	100017b7          	lui	a5,0x10001
    80005490:	5bdc                	lw	a5,52(a5)
    80005492:	2781                	sext.w	a5,a5
  if(max == 0)
    80005494:	10078763          	beqz	a5,800055a2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005498:	471d                	li	a4,7
    8000549a:	10f77c63          	bgeu	a4,a5,800055b2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	c7c080e7          	jalr	-900(ra) # 8000011a <kalloc>
    800054a6:	00014497          	auipc	s1,0x14
    800054aa:	7aa48493          	addi	s1,s1,1962 # 80019c50 <disk>
    800054ae:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054b0:	ffffb097          	auipc	ra,0xffffb
    800054b4:	c6a080e7          	jalr	-918(ra) # 8000011a <kalloc>
    800054b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054ba:	ffffb097          	auipc	ra,0xffffb
    800054be:	c60080e7          	jalr	-928(ra) # 8000011a <kalloc>
    800054c2:	87aa                	mv	a5,a0
    800054c4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054c6:	6088                	ld	a0,0(s1)
    800054c8:	cd6d                	beqz	a0,800055c2 <virtio_disk_init+0x1da>
    800054ca:	00014717          	auipc	a4,0x14
    800054ce:	78e73703          	ld	a4,1934(a4) # 80019c58 <disk+0x8>
    800054d2:	cb65                	beqz	a4,800055c2 <virtio_disk_init+0x1da>
    800054d4:	c7fd                	beqz	a5,800055c2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800054d6:	6605                	lui	a2,0x1
    800054d8:	4581                	li	a1,0
    800054da:	ffffb097          	auipc	ra,0xffffb
    800054de:	ca0080e7          	jalr	-864(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800054e2:	00014497          	auipc	s1,0x14
    800054e6:	76e48493          	addi	s1,s1,1902 # 80019c50 <disk>
    800054ea:	6605                	lui	a2,0x1
    800054ec:	4581                	li	a1,0
    800054ee:	6488                	ld	a0,8(s1)
    800054f0:	ffffb097          	auipc	ra,0xffffb
    800054f4:	c8a080e7          	jalr	-886(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800054f8:	6605                	lui	a2,0x1
    800054fa:	4581                	li	a1,0
    800054fc:	6888                	ld	a0,16(s1)
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	c7c080e7          	jalr	-900(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005506:	100017b7          	lui	a5,0x10001
    8000550a:	4721                	li	a4,8
    8000550c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000550e:	4098                	lw	a4,0(s1)
    80005510:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005514:	40d8                	lw	a4,4(s1)
    80005516:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000551a:	6498                	ld	a4,8(s1)
    8000551c:	0007069b          	sext.w	a3,a4
    80005520:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005524:	9701                	srai	a4,a4,0x20
    80005526:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000552a:	6898                	ld	a4,16(s1)
    8000552c:	0007069b          	sext.w	a3,a4
    80005530:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005534:	9701                	srai	a4,a4,0x20
    80005536:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000553a:	4705                	li	a4,1
    8000553c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000553e:	00e48c23          	sb	a4,24(s1)
    80005542:	00e48ca3          	sb	a4,25(s1)
    80005546:	00e48d23          	sb	a4,26(s1)
    8000554a:	00e48da3          	sb	a4,27(s1)
    8000554e:	00e48e23          	sb	a4,28(s1)
    80005552:	00e48ea3          	sb	a4,29(s1)
    80005556:	00e48f23          	sb	a4,30(s1)
    8000555a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000555e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005562:	0727a823          	sw	s2,112(a5)
}
    80005566:	60e2                	ld	ra,24(sp)
    80005568:	6442                	ld	s0,16(sp)
    8000556a:	64a2                	ld	s1,8(sp)
    8000556c:	6902                	ld	s2,0(sp)
    8000556e:	6105                	addi	sp,sp,32
    80005570:	8082                	ret
    panic("could not find virtio disk");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	1f650513          	addi	a0,a0,502 # 80008768 <syscalls+0x368>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	85c080e7          	jalr	-1956(ra) # 80005dd6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	20650513          	addi	a0,a0,518 # 80008788 <syscalls+0x388>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	84c080e7          	jalr	-1972(ra) # 80005dd6 <panic>
    panic("virtio disk should not be ready");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	21650513          	addi	a0,a0,534 # 800087a8 <syscalls+0x3a8>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	83c080e7          	jalr	-1988(ra) # 80005dd6 <panic>
    panic("virtio disk has no queue 0");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	22650513          	addi	a0,a0,550 # 800087c8 <syscalls+0x3c8>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	82c080e7          	jalr	-2004(ra) # 80005dd6 <panic>
    panic("virtio disk max queue too short");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	23650513          	addi	a0,a0,566 # 800087e8 <syscalls+0x3e8>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	81c080e7          	jalr	-2020(ra) # 80005dd6 <panic>
    panic("virtio disk kalloc");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	24650513          	addi	a0,a0,582 # 80008808 <syscalls+0x408>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	80c080e7          	jalr	-2036(ra) # 80005dd6 <panic>

00000000800055d2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055d2:	7159                	addi	sp,sp,-112
    800055d4:	f486                	sd	ra,104(sp)
    800055d6:	f0a2                	sd	s0,96(sp)
    800055d8:	eca6                	sd	s1,88(sp)
    800055da:	e8ca                	sd	s2,80(sp)
    800055dc:	e4ce                	sd	s3,72(sp)
    800055de:	e0d2                	sd	s4,64(sp)
    800055e0:	fc56                	sd	s5,56(sp)
    800055e2:	f85a                	sd	s6,48(sp)
    800055e4:	f45e                	sd	s7,40(sp)
    800055e6:	f062                	sd	s8,32(sp)
    800055e8:	ec66                	sd	s9,24(sp)
    800055ea:	e86a                	sd	s10,16(sp)
    800055ec:	1880                	addi	s0,sp,112
    800055ee:	8a2a                	mv	s4,a0
    800055f0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055f2:	00c52c83          	lw	s9,12(a0)
    800055f6:	001c9c9b          	slliw	s9,s9,0x1
    800055fa:	1c82                	slli	s9,s9,0x20
    800055fc:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005600:	00014517          	auipc	a0,0x14
    80005604:	77850513          	addi	a0,a0,1912 # 80019d78 <disk+0x128>
    80005608:	00001097          	auipc	ra,0x1
    8000560c:	d06080e7          	jalr	-762(ra) # 8000630e <acquire>
  for(int i = 0; i < 3; i++){
    80005610:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005612:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005614:	00014b17          	auipc	s6,0x14
    80005618:	63cb0b13          	addi	s6,s6,1596 # 80019c50 <disk>
  for(int i = 0; i < 3; i++){
    8000561c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000561e:	00014c17          	auipc	s8,0x14
    80005622:	75ac0c13          	addi	s8,s8,1882 # 80019d78 <disk+0x128>
    80005626:	a095                	j	8000568a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005628:	00fb0733          	add	a4,s6,a5
    8000562c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005630:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005632:	0207c563          	bltz	a5,8000565c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005636:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005638:	0591                	addi	a1,a1,4
    8000563a:	05560d63          	beq	a2,s5,80005694 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000563e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005640:	00014717          	auipc	a4,0x14
    80005644:	61070713          	addi	a4,a4,1552 # 80019c50 <disk>
    80005648:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000564a:	01874683          	lbu	a3,24(a4)
    8000564e:	fee9                	bnez	a3,80005628 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005650:	2785                	addiw	a5,a5,1
    80005652:	0705                	addi	a4,a4,1
    80005654:	fe979be3          	bne	a5,s1,8000564a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005658:	57fd                	li	a5,-1
    8000565a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000565c:	00c05e63          	blez	a2,80005678 <virtio_disk_rw+0xa6>
    80005660:	060a                	slli	a2,a2,0x2
    80005662:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005666:	0009a503          	lw	a0,0(s3)
    8000566a:	00000097          	auipc	ra,0x0
    8000566e:	cfc080e7          	jalr	-772(ra) # 80005366 <free_desc>
      for(int j = 0; j < i; j++)
    80005672:	0991                	addi	s3,s3,4
    80005674:	ffa999e3          	bne	s3,s10,80005666 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005678:	85e2                	mv	a1,s8
    8000567a:	00014517          	auipc	a0,0x14
    8000567e:	5ee50513          	addi	a0,a0,1518 # 80019c68 <disk+0x18>
    80005682:	ffffc097          	auipc	ra,0xffffc
    80005686:	01c080e7          	jalr	28(ra) # 8000169e <sleep>
  for(int i = 0; i < 3; i++){
    8000568a:	f9040993          	addi	s3,s0,-112
{
    8000568e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005690:	864a                	mv	a2,s2
    80005692:	b775                	j	8000563e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005694:	f9042503          	lw	a0,-112(s0)
    80005698:	00a50713          	addi	a4,a0,10
    8000569c:	0712                	slli	a4,a4,0x4

  if(write)
    8000569e:	00014797          	auipc	a5,0x14
    800056a2:	5b278793          	addi	a5,a5,1458 # 80019c50 <disk>
    800056a6:	00e786b3          	add	a3,a5,a4
    800056aa:	01703633          	snez	a2,s7
    800056ae:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056b0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800056b4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056b8:	f6070613          	addi	a2,a4,-160
    800056bc:	6394                	ld	a3,0(a5)
    800056be:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c0:	00870593          	addi	a1,a4,8
    800056c4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056c6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056c8:	0007b803          	ld	a6,0(a5)
    800056cc:	9642                	add	a2,a2,a6
    800056ce:	46c1                	li	a3,16
    800056d0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056d2:	4585                	li	a1,1
    800056d4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800056d8:	f9442683          	lw	a3,-108(s0)
    800056dc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056e0:	0692                	slli	a3,a3,0x4
    800056e2:	9836                	add	a6,a6,a3
    800056e4:	058a0613          	addi	a2,s4,88
    800056e8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800056ec:	0007b803          	ld	a6,0(a5)
    800056f0:	96c2                	add	a3,a3,a6
    800056f2:	40000613          	li	a2,1024
    800056f6:	c690                	sw	a2,8(a3)
  if(write)
    800056f8:	001bb613          	seqz	a2,s7
    800056fc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005700:	00166613          	ori	a2,a2,1
    80005704:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005708:	f9842603          	lw	a2,-104(s0)
    8000570c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005710:	00250693          	addi	a3,a0,2
    80005714:	0692                	slli	a3,a3,0x4
    80005716:	96be                	add	a3,a3,a5
    80005718:	58fd                	li	a7,-1
    8000571a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000571e:	0612                	slli	a2,a2,0x4
    80005720:	9832                	add	a6,a6,a2
    80005722:	f9070713          	addi	a4,a4,-112
    80005726:	973e                	add	a4,a4,a5
    80005728:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000572c:	6398                	ld	a4,0(a5)
    8000572e:	9732                	add	a4,a4,a2
    80005730:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005732:	4609                	li	a2,2
    80005734:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005738:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000573c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005740:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005744:	6794                	ld	a3,8(a5)
    80005746:	0026d703          	lhu	a4,2(a3)
    8000574a:	8b1d                	andi	a4,a4,7
    8000574c:	0706                	slli	a4,a4,0x1
    8000574e:	96ba                	add	a3,a3,a4
    80005750:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005754:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005758:	6798                	ld	a4,8(a5)
    8000575a:	00275783          	lhu	a5,2(a4)
    8000575e:	2785                	addiw	a5,a5,1
    80005760:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005764:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005768:	100017b7          	lui	a5,0x10001
    8000576c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005770:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005774:	00014917          	auipc	s2,0x14
    80005778:	60490913          	addi	s2,s2,1540 # 80019d78 <disk+0x128>
  while(b->disk == 1) {
    8000577c:	4485                	li	s1,1
    8000577e:	00b79c63          	bne	a5,a1,80005796 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005782:	85ca                	mv	a1,s2
    80005784:	8552                	mv	a0,s4
    80005786:	ffffc097          	auipc	ra,0xffffc
    8000578a:	f18080e7          	jalr	-232(ra) # 8000169e <sleep>
  while(b->disk == 1) {
    8000578e:	004a2783          	lw	a5,4(s4)
    80005792:	fe9788e3          	beq	a5,s1,80005782 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005796:	f9042903          	lw	s2,-112(s0)
    8000579a:	00290713          	addi	a4,s2,2
    8000579e:	0712                	slli	a4,a4,0x4
    800057a0:	00014797          	auipc	a5,0x14
    800057a4:	4b078793          	addi	a5,a5,1200 # 80019c50 <disk>
    800057a8:	97ba                	add	a5,a5,a4
    800057aa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ae:	00014997          	auipc	s3,0x14
    800057b2:	4a298993          	addi	s3,s3,1186 # 80019c50 <disk>
    800057b6:	00491713          	slli	a4,s2,0x4
    800057ba:	0009b783          	ld	a5,0(s3)
    800057be:	97ba                	add	a5,a5,a4
    800057c0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057c4:	854a                	mv	a0,s2
    800057c6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057ca:	00000097          	auipc	ra,0x0
    800057ce:	b9c080e7          	jalr	-1124(ra) # 80005366 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057d2:	8885                	andi	s1,s1,1
    800057d4:	f0ed                	bnez	s1,800057b6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057d6:	00014517          	auipc	a0,0x14
    800057da:	5a250513          	addi	a0,a0,1442 # 80019d78 <disk+0x128>
    800057de:	00001097          	auipc	ra,0x1
    800057e2:	be4080e7          	jalr	-1052(ra) # 800063c2 <release>
}
    800057e6:	70a6                	ld	ra,104(sp)
    800057e8:	7406                	ld	s0,96(sp)
    800057ea:	64e6                	ld	s1,88(sp)
    800057ec:	6946                	ld	s2,80(sp)
    800057ee:	69a6                	ld	s3,72(sp)
    800057f0:	6a06                	ld	s4,64(sp)
    800057f2:	7ae2                	ld	s5,56(sp)
    800057f4:	7b42                	ld	s6,48(sp)
    800057f6:	7ba2                	ld	s7,40(sp)
    800057f8:	7c02                	ld	s8,32(sp)
    800057fa:	6ce2                	ld	s9,24(sp)
    800057fc:	6d42                	ld	s10,16(sp)
    800057fe:	6165                	addi	sp,sp,112
    80005800:	8082                	ret

0000000080005802 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005802:	1101                	addi	sp,sp,-32
    80005804:	ec06                	sd	ra,24(sp)
    80005806:	e822                	sd	s0,16(sp)
    80005808:	e426                	sd	s1,8(sp)
    8000580a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000580c:	00014497          	auipc	s1,0x14
    80005810:	44448493          	addi	s1,s1,1092 # 80019c50 <disk>
    80005814:	00014517          	auipc	a0,0x14
    80005818:	56450513          	addi	a0,a0,1380 # 80019d78 <disk+0x128>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	af2080e7          	jalr	-1294(ra) # 8000630e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005824:	10001737          	lui	a4,0x10001
    80005828:	533c                	lw	a5,96(a4)
    8000582a:	8b8d                	andi	a5,a5,3
    8000582c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000582e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005832:	689c                	ld	a5,16(s1)
    80005834:	0204d703          	lhu	a4,32(s1)
    80005838:	0027d783          	lhu	a5,2(a5)
    8000583c:	04f70863          	beq	a4,a5,8000588c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005840:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005844:	6898                	ld	a4,16(s1)
    80005846:	0204d783          	lhu	a5,32(s1)
    8000584a:	8b9d                	andi	a5,a5,7
    8000584c:	078e                	slli	a5,a5,0x3
    8000584e:	97ba                	add	a5,a5,a4
    80005850:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005852:	00278713          	addi	a4,a5,2
    80005856:	0712                	slli	a4,a4,0x4
    80005858:	9726                	add	a4,a4,s1
    8000585a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000585e:	e721                	bnez	a4,800058a6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005860:	0789                	addi	a5,a5,2
    80005862:	0792                	slli	a5,a5,0x4
    80005864:	97a6                	add	a5,a5,s1
    80005866:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005868:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000586c:	ffffc097          	auipc	ra,0xffffc
    80005870:	e96080e7          	jalr	-362(ra) # 80001702 <wakeup>

    disk.used_idx += 1;
    80005874:	0204d783          	lhu	a5,32(s1)
    80005878:	2785                	addiw	a5,a5,1
    8000587a:	17c2                	slli	a5,a5,0x30
    8000587c:	93c1                	srli	a5,a5,0x30
    8000587e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005882:	6898                	ld	a4,16(s1)
    80005884:	00275703          	lhu	a4,2(a4)
    80005888:	faf71ce3          	bne	a4,a5,80005840 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000588c:	00014517          	auipc	a0,0x14
    80005890:	4ec50513          	addi	a0,a0,1260 # 80019d78 <disk+0x128>
    80005894:	00001097          	auipc	ra,0x1
    80005898:	b2e080e7          	jalr	-1234(ra) # 800063c2 <release>
}
    8000589c:	60e2                	ld	ra,24(sp)
    8000589e:	6442                	ld	s0,16(sp)
    800058a0:	64a2                	ld	s1,8(sp)
    800058a2:	6105                	addi	sp,sp,32
    800058a4:	8082                	ret
      panic("virtio_disk_intr status");
    800058a6:	00003517          	auipc	a0,0x3
    800058aa:	f7a50513          	addi	a0,a0,-134 # 80008820 <syscalls+0x420>
    800058ae:	00000097          	auipc	ra,0x0
    800058b2:	528080e7          	jalr	1320(ra) # 80005dd6 <panic>

00000000800058b6 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058b6:	1141                	addi	sp,sp,-16
    800058b8:	e422                	sd	s0,8(sp)
    800058ba:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058bc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058c0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058c4:	0037979b          	slliw	a5,a5,0x3
    800058c8:	02004737          	lui	a4,0x2004
    800058cc:	97ba                	add	a5,a5,a4
    800058ce:	0200c737          	lui	a4,0x200c
    800058d2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058d6:	000f4637          	lui	a2,0xf4
    800058da:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058de:	9732                	add	a4,a4,a2
    800058e0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058e2:	00259693          	slli	a3,a1,0x2
    800058e6:	96ae                	add	a3,a3,a1
    800058e8:	068e                	slli	a3,a3,0x3
    800058ea:	00014717          	auipc	a4,0x14
    800058ee:	4a670713          	addi	a4,a4,1190 # 80019d90 <timer_scratch>
    800058f2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058f4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058f6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058f8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058fc:	00000797          	auipc	a5,0x0
    80005900:	9a478793          	addi	a5,a5,-1628 # 800052a0 <timervec>
    80005904:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005908:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000590c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005910:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005914:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005918:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000591c:	30479073          	csrw	mie,a5
}
    80005920:	6422                	ld	s0,8(sp)
    80005922:	0141                	addi	sp,sp,16
    80005924:	8082                	ret

0000000080005926 <start>:
{
    80005926:	1141                	addi	sp,sp,-16
    80005928:	e406                	sd	ra,8(sp)
    8000592a:	e022                	sd	s0,0(sp)
    8000592c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000592e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005932:	7779                	lui	a4,0xffffe
    80005934:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc82f>
    80005938:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000593a:	6705                	lui	a4,0x1
    8000593c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005940:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005942:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005946:	ffffb797          	auipc	a5,0xffffb
    8000594a:	9d878793          	addi	a5,a5,-1576 # 8000031e <main>
    8000594e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005952:	4781                	li	a5,0
    80005954:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005958:	67c1                	lui	a5,0x10
    8000595a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000595c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005960:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005964:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005968:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000596c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005970:	57fd                	li	a5,-1
    80005972:	83a9                	srli	a5,a5,0xa
    80005974:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005978:	47bd                	li	a5,15
    8000597a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000597e:	00000097          	auipc	ra,0x0
    80005982:	f38080e7          	jalr	-200(ra) # 800058b6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005986:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000598a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000598c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000598e:	30200073          	mret
}
    80005992:	60a2                	ld	ra,8(sp)
    80005994:	6402                	ld	s0,0(sp)
    80005996:	0141                	addi	sp,sp,16
    80005998:	8082                	ret

000000008000599a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000599a:	715d                	addi	sp,sp,-80
    8000599c:	e486                	sd	ra,72(sp)
    8000599e:	e0a2                	sd	s0,64(sp)
    800059a0:	fc26                	sd	s1,56(sp)
    800059a2:	f84a                	sd	s2,48(sp)
    800059a4:	f44e                	sd	s3,40(sp)
    800059a6:	f052                	sd	s4,32(sp)
    800059a8:	ec56                	sd	s5,24(sp)
    800059aa:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ac:	04c05763          	blez	a2,800059fa <consolewrite+0x60>
    800059b0:	8a2a                	mv	s4,a0
    800059b2:	84ae                	mv	s1,a1
    800059b4:	89b2                	mv	s3,a2
    800059b6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059b8:	5afd                	li	s5,-1
    800059ba:	4685                	li	a3,1
    800059bc:	8626                	mv	a2,s1
    800059be:	85d2                	mv	a1,s4
    800059c0:	fbf40513          	addi	a0,s0,-65
    800059c4:	ffffc097          	auipc	ra,0xffffc
    800059c8:	138080e7          	jalr	312(ra) # 80001afc <either_copyin>
    800059cc:	01550d63          	beq	a0,s5,800059e6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059d0:	fbf44503          	lbu	a0,-65(s0)
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	780080e7          	jalr	1920(ra) # 80006154 <uartputc>
  for(i = 0; i < n; i++){
    800059dc:	2905                	addiw	s2,s2,1
    800059de:	0485                	addi	s1,s1,1
    800059e0:	fd299de3          	bne	s3,s2,800059ba <consolewrite+0x20>
    800059e4:	894e                	mv	s2,s3
  }

  return i;
}
    800059e6:	854a                	mv	a0,s2
    800059e8:	60a6                	ld	ra,72(sp)
    800059ea:	6406                	ld	s0,64(sp)
    800059ec:	74e2                	ld	s1,56(sp)
    800059ee:	7942                	ld	s2,48(sp)
    800059f0:	79a2                	ld	s3,40(sp)
    800059f2:	7a02                	ld	s4,32(sp)
    800059f4:	6ae2                	ld	s5,24(sp)
    800059f6:	6161                	addi	sp,sp,80
    800059f8:	8082                	ret
  for(i = 0; i < n; i++){
    800059fa:	4901                	li	s2,0
    800059fc:	b7ed                	j	800059e6 <consolewrite+0x4c>

00000000800059fe <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059fe:	711d                	addi	sp,sp,-96
    80005a00:	ec86                	sd	ra,88(sp)
    80005a02:	e8a2                	sd	s0,80(sp)
    80005a04:	e4a6                	sd	s1,72(sp)
    80005a06:	e0ca                	sd	s2,64(sp)
    80005a08:	fc4e                	sd	s3,56(sp)
    80005a0a:	f852                	sd	s4,48(sp)
    80005a0c:	f456                	sd	s5,40(sp)
    80005a0e:	f05a                	sd	s6,32(sp)
    80005a10:	ec5e                	sd	s7,24(sp)
    80005a12:	1080                	addi	s0,sp,96
    80005a14:	8aaa                	mv	s5,a0
    80005a16:	8a2e                	mv	s4,a1
    80005a18:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a1a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a1e:	0001c517          	auipc	a0,0x1c
    80005a22:	4b250513          	addi	a0,a0,1202 # 80021ed0 <cons>
    80005a26:	00001097          	auipc	ra,0x1
    80005a2a:	8e8080e7          	jalr	-1816(ra) # 8000630e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a2e:	0001c497          	auipc	s1,0x1c
    80005a32:	4a248493          	addi	s1,s1,1186 # 80021ed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a36:	0001c917          	auipc	s2,0x1c
    80005a3a:	53290913          	addi	s2,s2,1330 # 80021f68 <cons+0x98>
  while(n > 0){
    80005a3e:	09305263          	blez	s3,80005ac2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005a42:	0984a783          	lw	a5,152(s1)
    80005a46:	09c4a703          	lw	a4,156(s1)
    80005a4a:	02f71763          	bne	a4,a5,80005a78 <consoleread+0x7a>
      if(killed(myproc())){
    80005a4e:	ffffb097          	auipc	ra,0xffffb
    80005a52:	4fa080e7          	jalr	1274(ra) # 80000f48 <myproc>
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	ef0080e7          	jalr	-272(ra) # 80001946 <killed>
    80005a5e:	ed2d                	bnez	a0,80005ad8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005a60:	85a6                	mv	a1,s1
    80005a62:	854a                	mv	a0,s2
    80005a64:	ffffc097          	auipc	ra,0xffffc
    80005a68:	c3a080e7          	jalr	-966(ra) # 8000169e <sleep>
    while(cons.r == cons.w){
    80005a6c:	0984a783          	lw	a5,152(s1)
    80005a70:	09c4a703          	lw	a4,156(s1)
    80005a74:	fcf70de3          	beq	a4,a5,80005a4e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a78:	0001c717          	auipc	a4,0x1c
    80005a7c:	45870713          	addi	a4,a4,1112 # 80021ed0 <cons>
    80005a80:	0017869b          	addiw	a3,a5,1
    80005a84:	08d72c23          	sw	a3,152(a4)
    80005a88:	07f7f693          	andi	a3,a5,127
    80005a8c:	9736                	add	a4,a4,a3
    80005a8e:	01874703          	lbu	a4,24(a4)
    80005a92:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a96:	4691                	li	a3,4
    80005a98:	06db8463          	beq	s7,a3,80005b00 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a9c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aa0:	4685                	li	a3,1
    80005aa2:	faf40613          	addi	a2,s0,-81
    80005aa6:	85d2                	mv	a1,s4
    80005aa8:	8556                	mv	a0,s5
    80005aaa:	ffffc097          	auipc	ra,0xffffc
    80005aae:	ffc080e7          	jalr	-4(ra) # 80001aa6 <either_copyout>
    80005ab2:	57fd                	li	a5,-1
    80005ab4:	00f50763          	beq	a0,a5,80005ac2 <consoleread+0xc4>
      break;

    dst++;
    80005ab8:	0a05                	addi	s4,s4,1
    --n;
    80005aba:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005abc:	47a9                	li	a5,10
    80005abe:	f8fb90e3          	bne	s7,a5,80005a3e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ac2:	0001c517          	auipc	a0,0x1c
    80005ac6:	40e50513          	addi	a0,a0,1038 # 80021ed0 <cons>
    80005aca:	00001097          	auipc	ra,0x1
    80005ace:	8f8080e7          	jalr	-1800(ra) # 800063c2 <release>

  return target - n;
    80005ad2:	413b053b          	subw	a0,s6,s3
    80005ad6:	a811                	j	80005aea <consoleread+0xec>
        release(&cons.lock);
    80005ad8:	0001c517          	auipc	a0,0x1c
    80005adc:	3f850513          	addi	a0,a0,1016 # 80021ed0 <cons>
    80005ae0:	00001097          	auipc	ra,0x1
    80005ae4:	8e2080e7          	jalr	-1822(ra) # 800063c2 <release>
        return -1;
    80005ae8:	557d                	li	a0,-1
}
    80005aea:	60e6                	ld	ra,88(sp)
    80005aec:	6446                	ld	s0,80(sp)
    80005aee:	64a6                	ld	s1,72(sp)
    80005af0:	6906                	ld	s2,64(sp)
    80005af2:	79e2                	ld	s3,56(sp)
    80005af4:	7a42                	ld	s4,48(sp)
    80005af6:	7aa2                	ld	s5,40(sp)
    80005af8:	7b02                	ld	s6,32(sp)
    80005afa:	6be2                	ld	s7,24(sp)
    80005afc:	6125                	addi	sp,sp,96
    80005afe:	8082                	ret
      if(n < target){
    80005b00:	0009871b          	sext.w	a4,s3
    80005b04:	fb677fe3          	bgeu	a4,s6,80005ac2 <consoleread+0xc4>
        cons.r--;
    80005b08:	0001c717          	auipc	a4,0x1c
    80005b0c:	46f72023          	sw	a5,1120(a4) # 80021f68 <cons+0x98>
    80005b10:	bf4d                	j	80005ac2 <consoleread+0xc4>

0000000080005b12 <consputc>:
{
    80005b12:	1141                	addi	sp,sp,-16
    80005b14:	e406                	sd	ra,8(sp)
    80005b16:	e022                	sd	s0,0(sp)
    80005b18:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b1a:	10000793          	li	a5,256
    80005b1e:	00f50a63          	beq	a0,a5,80005b32 <consputc+0x20>
    uartputc_sync(c);
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	560080e7          	jalr	1376(ra) # 80006082 <uartputc_sync>
}
    80005b2a:	60a2                	ld	ra,8(sp)
    80005b2c:	6402                	ld	s0,0(sp)
    80005b2e:	0141                	addi	sp,sp,16
    80005b30:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b32:	4521                	li	a0,8
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	54e080e7          	jalr	1358(ra) # 80006082 <uartputc_sync>
    80005b3c:	02000513          	li	a0,32
    80005b40:	00000097          	auipc	ra,0x0
    80005b44:	542080e7          	jalr	1346(ra) # 80006082 <uartputc_sync>
    80005b48:	4521                	li	a0,8
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	538080e7          	jalr	1336(ra) # 80006082 <uartputc_sync>
    80005b52:	bfe1                	j	80005b2a <consputc+0x18>

0000000080005b54 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b54:	1101                	addi	sp,sp,-32
    80005b56:	ec06                	sd	ra,24(sp)
    80005b58:	e822                	sd	s0,16(sp)
    80005b5a:	e426                	sd	s1,8(sp)
    80005b5c:	e04a                	sd	s2,0(sp)
    80005b5e:	1000                	addi	s0,sp,32
    80005b60:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b62:	0001c517          	auipc	a0,0x1c
    80005b66:	36e50513          	addi	a0,a0,878 # 80021ed0 <cons>
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	7a4080e7          	jalr	1956(ra) # 8000630e <acquire>

  switch(c){
    80005b72:	47d5                	li	a5,21
    80005b74:	0af48663          	beq	s1,a5,80005c20 <consoleintr+0xcc>
    80005b78:	0297ca63          	blt	a5,s1,80005bac <consoleintr+0x58>
    80005b7c:	47a1                	li	a5,8
    80005b7e:	0ef48763          	beq	s1,a5,80005c6c <consoleintr+0x118>
    80005b82:	47c1                	li	a5,16
    80005b84:	10f49a63          	bne	s1,a5,80005c98 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b88:	ffffc097          	auipc	ra,0xffffc
    80005b8c:	fca080e7          	jalr	-54(ra) # 80001b52 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b90:	0001c517          	auipc	a0,0x1c
    80005b94:	34050513          	addi	a0,a0,832 # 80021ed0 <cons>
    80005b98:	00001097          	auipc	ra,0x1
    80005b9c:	82a080e7          	jalr	-2006(ra) # 800063c2 <release>
}
    80005ba0:	60e2                	ld	ra,24(sp)
    80005ba2:	6442                	ld	s0,16(sp)
    80005ba4:	64a2                	ld	s1,8(sp)
    80005ba6:	6902                	ld	s2,0(sp)
    80005ba8:	6105                	addi	sp,sp,32
    80005baa:	8082                	ret
  switch(c){
    80005bac:	07f00793          	li	a5,127
    80005bb0:	0af48e63          	beq	s1,a5,80005c6c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bb4:	0001c717          	auipc	a4,0x1c
    80005bb8:	31c70713          	addi	a4,a4,796 # 80021ed0 <cons>
    80005bbc:	0a072783          	lw	a5,160(a4)
    80005bc0:	09872703          	lw	a4,152(a4)
    80005bc4:	9f99                	subw	a5,a5,a4
    80005bc6:	07f00713          	li	a4,127
    80005bca:	fcf763e3          	bltu	a4,a5,80005b90 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bce:	47b5                	li	a5,13
    80005bd0:	0cf48763          	beq	s1,a5,80005c9e <consoleintr+0x14a>
      consputc(c);
    80005bd4:	8526                	mv	a0,s1
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	f3c080e7          	jalr	-196(ra) # 80005b12 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bde:	0001c797          	auipc	a5,0x1c
    80005be2:	2f278793          	addi	a5,a5,754 # 80021ed0 <cons>
    80005be6:	0a07a683          	lw	a3,160(a5)
    80005bea:	0016871b          	addiw	a4,a3,1
    80005bee:	0007061b          	sext.w	a2,a4
    80005bf2:	0ae7a023          	sw	a4,160(a5)
    80005bf6:	07f6f693          	andi	a3,a3,127
    80005bfa:	97b6                	add	a5,a5,a3
    80005bfc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c00:	47a9                	li	a5,10
    80005c02:	0cf48563          	beq	s1,a5,80005ccc <consoleintr+0x178>
    80005c06:	4791                	li	a5,4
    80005c08:	0cf48263          	beq	s1,a5,80005ccc <consoleintr+0x178>
    80005c0c:	0001c797          	auipc	a5,0x1c
    80005c10:	35c7a783          	lw	a5,860(a5) # 80021f68 <cons+0x98>
    80005c14:	9f1d                	subw	a4,a4,a5
    80005c16:	08000793          	li	a5,128
    80005c1a:	f6f71be3          	bne	a4,a5,80005b90 <consoleintr+0x3c>
    80005c1e:	a07d                	j	80005ccc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c20:	0001c717          	auipc	a4,0x1c
    80005c24:	2b070713          	addi	a4,a4,688 # 80021ed0 <cons>
    80005c28:	0a072783          	lw	a5,160(a4)
    80005c2c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c30:	0001c497          	auipc	s1,0x1c
    80005c34:	2a048493          	addi	s1,s1,672 # 80021ed0 <cons>
    while(cons.e != cons.w &&
    80005c38:	4929                	li	s2,10
    80005c3a:	f4f70be3          	beq	a4,a5,80005b90 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c3e:	37fd                	addiw	a5,a5,-1
    80005c40:	07f7f713          	andi	a4,a5,127
    80005c44:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c46:	01874703          	lbu	a4,24(a4)
    80005c4a:	f52703e3          	beq	a4,s2,80005b90 <consoleintr+0x3c>
      cons.e--;
    80005c4e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c52:	10000513          	li	a0,256
    80005c56:	00000097          	auipc	ra,0x0
    80005c5a:	ebc080e7          	jalr	-324(ra) # 80005b12 <consputc>
    while(cons.e != cons.w &&
    80005c5e:	0a04a783          	lw	a5,160(s1)
    80005c62:	09c4a703          	lw	a4,156(s1)
    80005c66:	fcf71ce3          	bne	a4,a5,80005c3e <consoleintr+0xea>
    80005c6a:	b71d                	j	80005b90 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c6c:	0001c717          	auipc	a4,0x1c
    80005c70:	26470713          	addi	a4,a4,612 # 80021ed0 <cons>
    80005c74:	0a072783          	lw	a5,160(a4)
    80005c78:	09c72703          	lw	a4,156(a4)
    80005c7c:	f0f70ae3          	beq	a4,a5,80005b90 <consoleintr+0x3c>
      cons.e--;
    80005c80:	37fd                	addiw	a5,a5,-1
    80005c82:	0001c717          	auipc	a4,0x1c
    80005c86:	2ef72723          	sw	a5,750(a4) # 80021f70 <cons+0xa0>
      consputc(BACKSPACE);
    80005c8a:	10000513          	li	a0,256
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	e84080e7          	jalr	-380(ra) # 80005b12 <consputc>
    80005c96:	bded                	j	80005b90 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c98:	ee048ce3          	beqz	s1,80005b90 <consoleintr+0x3c>
    80005c9c:	bf21                	j	80005bb4 <consoleintr+0x60>
      consputc(c);
    80005c9e:	4529                	li	a0,10
    80005ca0:	00000097          	auipc	ra,0x0
    80005ca4:	e72080e7          	jalr	-398(ra) # 80005b12 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ca8:	0001c797          	auipc	a5,0x1c
    80005cac:	22878793          	addi	a5,a5,552 # 80021ed0 <cons>
    80005cb0:	0a07a703          	lw	a4,160(a5)
    80005cb4:	0017069b          	addiw	a3,a4,1
    80005cb8:	0006861b          	sext.w	a2,a3
    80005cbc:	0ad7a023          	sw	a3,160(a5)
    80005cc0:	07f77713          	andi	a4,a4,127
    80005cc4:	97ba                	add	a5,a5,a4
    80005cc6:	4729                	li	a4,10
    80005cc8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ccc:	0001c797          	auipc	a5,0x1c
    80005cd0:	2ac7a023          	sw	a2,672(a5) # 80021f6c <cons+0x9c>
        wakeup(&cons.r);
    80005cd4:	0001c517          	auipc	a0,0x1c
    80005cd8:	29450513          	addi	a0,a0,660 # 80021f68 <cons+0x98>
    80005cdc:	ffffc097          	auipc	ra,0xffffc
    80005ce0:	a26080e7          	jalr	-1498(ra) # 80001702 <wakeup>
    80005ce4:	b575                	j	80005b90 <consoleintr+0x3c>

0000000080005ce6 <consoleinit>:

void
consoleinit(void)
{
    80005ce6:	1141                	addi	sp,sp,-16
    80005ce8:	e406                	sd	ra,8(sp)
    80005cea:	e022                	sd	s0,0(sp)
    80005cec:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cee:	00003597          	auipc	a1,0x3
    80005cf2:	b4a58593          	addi	a1,a1,-1206 # 80008838 <syscalls+0x438>
    80005cf6:	0001c517          	auipc	a0,0x1c
    80005cfa:	1da50513          	addi	a0,a0,474 # 80021ed0 <cons>
    80005cfe:	00000097          	auipc	ra,0x0
    80005d02:	580080e7          	jalr	1408(ra) # 8000627e <initlock>

  uartinit();
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	32c080e7          	jalr	812(ra) # 80006032 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d0e:	00013797          	auipc	a5,0x13
    80005d12:	eea78793          	addi	a5,a5,-278 # 80018bf8 <devsw>
    80005d16:	00000717          	auipc	a4,0x0
    80005d1a:	ce870713          	addi	a4,a4,-792 # 800059fe <consoleread>
    80005d1e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d20:	00000717          	auipc	a4,0x0
    80005d24:	c7a70713          	addi	a4,a4,-902 # 8000599a <consolewrite>
    80005d28:	ef98                	sd	a4,24(a5)
}
    80005d2a:	60a2                	ld	ra,8(sp)
    80005d2c:	6402                	ld	s0,0(sp)
    80005d2e:	0141                	addi	sp,sp,16
    80005d30:	8082                	ret

0000000080005d32 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d32:	7179                	addi	sp,sp,-48
    80005d34:	f406                	sd	ra,40(sp)
    80005d36:	f022                	sd	s0,32(sp)
    80005d38:	ec26                	sd	s1,24(sp)
    80005d3a:	e84a                	sd	s2,16(sp)
    80005d3c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d3e:	c219                	beqz	a2,80005d44 <printint+0x12>
    80005d40:	08054763          	bltz	a0,80005dce <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d44:	2501                	sext.w	a0,a0
    80005d46:	4881                	li	a7,0
    80005d48:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d4c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d4e:	2581                	sext.w	a1,a1
    80005d50:	00003617          	auipc	a2,0x3
    80005d54:	b1860613          	addi	a2,a2,-1256 # 80008868 <digits>
    80005d58:	883a                	mv	a6,a4
    80005d5a:	2705                	addiw	a4,a4,1
    80005d5c:	02b577bb          	remuw	a5,a0,a1
    80005d60:	1782                	slli	a5,a5,0x20
    80005d62:	9381                	srli	a5,a5,0x20
    80005d64:	97b2                	add	a5,a5,a2
    80005d66:	0007c783          	lbu	a5,0(a5)
    80005d6a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d6e:	0005079b          	sext.w	a5,a0
    80005d72:	02b5553b          	divuw	a0,a0,a1
    80005d76:	0685                	addi	a3,a3,1
    80005d78:	feb7f0e3          	bgeu	a5,a1,80005d58 <printint+0x26>

  if(sign)
    80005d7c:	00088c63          	beqz	a7,80005d94 <printint+0x62>
    buf[i++] = '-';
    80005d80:	fe070793          	addi	a5,a4,-32
    80005d84:	00878733          	add	a4,a5,s0
    80005d88:	02d00793          	li	a5,45
    80005d8c:	fef70823          	sb	a5,-16(a4)
    80005d90:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d94:	02e05763          	blez	a4,80005dc2 <printint+0x90>
    80005d98:	fd040793          	addi	a5,s0,-48
    80005d9c:	00e784b3          	add	s1,a5,a4
    80005da0:	fff78913          	addi	s2,a5,-1
    80005da4:	993a                	add	s2,s2,a4
    80005da6:	377d                	addiw	a4,a4,-1
    80005da8:	1702                	slli	a4,a4,0x20
    80005daa:	9301                	srli	a4,a4,0x20
    80005dac:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005db0:	fff4c503          	lbu	a0,-1(s1)
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	d5e080e7          	jalr	-674(ra) # 80005b12 <consputc>
  while(--i >= 0)
    80005dbc:	14fd                	addi	s1,s1,-1
    80005dbe:	ff2499e3          	bne	s1,s2,80005db0 <printint+0x7e>
}
    80005dc2:	70a2                	ld	ra,40(sp)
    80005dc4:	7402                	ld	s0,32(sp)
    80005dc6:	64e2                	ld	s1,24(sp)
    80005dc8:	6942                	ld	s2,16(sp)
    80005dca:	6145                	addi	sp,sp,48
    80005dcc:	8082                	ret
    x = -xx;
    80005dce:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dd2:	4885                	li	a7,1
    x = -xx;
    80005dd4:	bf95                	j	80005d48 <printint+0x16>

0000000080005dd6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dd6:	1101                	addi	sp,sp,-32
    80005dd8:	ec06                	sd	ra,24(sp)
    80005dda:	e822                	sd	s0,16(sp)
    80005ddc:	e426                	sd	s1,8(sp)
    80005dde:	1000                	addi	s0,sp,32
    80005de0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005de2:	0001c797          	auipc	a5,0x1c
    80005de6:	1a07a723          	sw	zero,430(a5) # 80021f90 <pr+0x18>
  printf("panic: ");
    80005dea:	00003517          	auipc	a0,0x3
    80005dee:	a5650513          	addi	a0,a0,-1450 # 80008840 <syscalls+0x440>
    80005df2:	00000097          	auipc	ra,0x0
    80005df6:	02e080e7          	jalr	46(ra) # 80005e20 <printf>
  printf(s);
    80005dfa:	8526                	mv	a0,s1
    80005dfc:	00000097          	auipc	ra,0x0
    80005e00:	024080e7          	jalr	36(ra) # 80005e20 <printf>
  printf("\n");
    80005e04:	00002517          	auipc	a0,0x2
    80005e08:	24450513          	addi	a0,a0,580 # 80008048 <etext+0x48>
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	014080e7          	jalr	20(ra) # 80005e20 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e14:	4785                	li	a5,1
    80005e16:	00003717          	auipc	a4,0x3
    80005e1a:	b2f72b23          	sw	a5,-1226(a4) # 8000894c <panicked>
  for(;;)
    80005e1e:	a001                	j	80005e1e <panic+0x48>

0000000080005e20 <printf>:
{
    80005e20:	7131                	addi	sp,sp,-192
    80005e22:	fc86                	sd	ra,120(sp)
    80005e24:	f8a2                	sd	s0,112(sp)
    80005e26:	f4a6                	sd	s1,104(sp)
    80005e28:	f0ca                	sd	s2,96(sp)
    80005e2a:	ecce                	sd	s3,88(sp)
    80005e2c:	e8d2                	sd	s4,80(sp)
    80005e2e:	e4d6                	sd	s5,72(sp)
    80005e30:	e0da                	sd	s6,64(sp)
    80005e32:	fc5e                	sd	s7,56(sp)
    80005e34:	f862                	sd	s8,48(sp)
    80005e36:	f466                	sd	s9,40(sp)
    80005e38:	f06a                	sd	s10,32(sp)
    80005e3a:	ec6e                	sd	s11,24(sp)
    80005e3c:	0100                	addi	s0,sp,128
    80005e3e:	8a2a                	mv	s4,a0
    80005e40:	e40c                	sd	a1,8(s0)
    80005e42:	e810                	sd	a2,16(s0)
    80005e44:	ec14                	sd	a3,24(s0)
    80005e46:	f018                	sd	a4,32(s0)
    80005e48:	f41c                	sd	a5,40(s0)
    80005e4a:	03043823          	sd	a6,48(s0)
    80005e4e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e52:	0001cd97          	auipc	s11,0x1c
    80005e56:	13edad83          	lw	s11,318(s11) # 80021f90 <pr+0x18>
  if(locking)
    80005e5a:	020d9b63          	bnez	s11,80005e90 <printf+0x70>
  if (fmt == 0)
    80005e5e:	040a0263          	beqz	s4,80005ea2 <printf+0x82>
  va_start(ap, fmt);
    80005e62:	00840793          	addi	a5,s0,8
    80005e66:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e6a:	000a4503          	lbu	a0,0(s4)
    80005e6e:	14050f63          	beqz	a0,80005fcc <printf+0x1ac>
    80005e72:	4981                	li	s3,0
    if(c != '%'){
    80005e74:	02500a93          	li	s5,37
    switch(c){
    80005e78:	07000b93          	li	s7,112
  consputc('x');
    80005e7c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e7e:	00003b17          	auipc	s6,0x3
    80005e82:	9eab0b13          	addi	s6,s6,-1558 # 80008868 <digits>
    switch(c){
    80005e86:	07300c93          	li	s9,115
    80005e8a:	06400c13          	li	s8,100
    80005e8e:	a82d                	j	80005ec8 <printf+0xa8>
    acquire(&pr.lock);
    80005e90:	0001c517          	auipc	a0,0x1c
    80005e94:	0e850513          	addi	a0,a0,232 # 80021f78 <pr>
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	476080e7          	jalr	1142(ra) # 8000630e <acquire>
    80005ea0:	bf7d                	j	80005e5e <printf+0x3e>
    panic("null fmt");
    80005ea2:	00003517          	auipc	a0,0x3
    80005ea6:	9ae50513          	addi	a0,a0,-1618 # 80008850 <syscalls+0x450>
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	f2c080e7          	jalr	-212(ra) # 80005dd6 <panic>
      consputc(c);
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	c60080e7          	jalr	-928(ra) # 80005b12 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eba:	2985                	addiw	s3,s3,1
    80005ebc:	013a07b3          	add	a5,s4,s3
    80005ec0:	0007c503          	lbu	a0,0(a5)
    80005ec4:	10050463          	beqz	a0,80005fcc <printf+0x1ac>
    if(c != '%'){
    80005ec8:	ff5515e3          	bne	a0,s5,80005eb2 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ecc:	2985                	addiw	s3,s3,1
    80005ece:	013a07b3          	add	a5,s4,s3
    80005ed2:	0007c783          	lbu	a5,0(a5)
    80005ed6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005eda:	cbed                	beqz	a5,80005fcc <printf+0x1ac>
    switch(c){
    80005edc:	05778a63          	beq	a5,s7,80005f30 <printf+0x110>
    80005ee0:	02fbf663          	bgeu	s7,a5,80005f0c <printf+0xec>
    80005ee4:	09978863          	beq	a5,s9,80005f74 <printf+0x154>
    80005ee8:	07800713          	li	a4,120
    80005eec:	0ce79563          	bne	a5,a4,80005fb6 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005ef0:	f8843783          	ld	a5,-120(s0)
    80005ef4:	00878713          	addi	a4,a5,8
    80005ef8:	f8e43423          	sd	a4,-120(s0)
    80005efc:	4605                	li	a2,1
    80005efe:	85ea                	mv	a1,s10
    80005f00:	4388                	lw	a0,0(a5)
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	e30080e7          	jalr	-464(ra) # 80005d32 <printint>
      break;
    80005f0a:	bf45                	j	80005eba <printf+0x9a>
    switch(c){
    80005f0c:	09578f63          	beq	a5,s5,80005faa <printf+0x18a>
    80005f10:	0b879363          	bne	a5,s8,80005fb6 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f14:	f8843783          	ld	a5,-120(s0)
    80005f18:	00878713          	addi	a4,a5,8
    80005f1c:	f8e43423          	sd	a4,-120(s0)
    80005f20:	4605                	li	a2,1
    80005f22:	45a9                	li	a1,10
    80005f24:	4388                	lw	a0,0(a5)
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	e0c080e7          	jalr	-500(ra) # 80005d32 <printint>
      break;
    80005f2e:	b771                	j	80005eba <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f30:	f8843783          	ld	a5,-120(s0)
    80005f34:	00878713          	addi	a4,a5,8
    80005f38:	f8e43423          	sd	a4,-120(s0)
    80005f3c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f40:	03000513          	li	a0,48
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	bce080e7          	jalr	-1074(ra) # 80005b12 <consputc>
  consputc('x');
    80005f4c:	07800513          	li	a0,120
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	bc2080e7          	jalr	-1086(ra) # 80005b12 <consputc>
    80005f58:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f5a:	03c95793          	srli	a5,s2,0x3c
    80005f5e:	97da                	add	a5,a5,s6
    80005f60:	0007c503          	lbu	a0,0(a5)
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	bae080e7          	jalr	-1106(ra) # 80005b12 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f6c:	0912                	slli	s2,s2,0x4
    80005f6e:	34fd                	addiw	s1,s1,-1
    80005f70:	f4ed                	bnez	s1,80005f5a <printf+0x13a>
    80005f72:	b7a1                	j	80005eba <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f74:	f8843783          	ld	a5,-120(s0)
    80005f78:	00878713          	addi	a4,a5,8
    80005f7c:	f8e43423          	sd	a4,-120(s0)
    80005f80:	6384                	ld	s1,0(a5)
    80005f82:	cc89                	beqz	s1,80005f9c <printf+0x17c>
      for(; *s; s++)
    80005f84:	0004c503          	lbu	a0,0(s1)
    80005f88:	d90d                	beqz	a0,80005eba <printf+0x9a>
        consputc(*s);
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	b88080e7          	jalr	-1144(ra) # 80005b12 <consputc>
      for(; *s; s++)
    80005f92:	0485                	addi	s1,s1,1
    80005f94:	0004c503          	lbu	a0,0(s1)
    80005f98:	f96d                	bnez	a0,80005f8a <printf+0x16a>
    80005f9a:	b705                	j	80005eba <printf+0x9a>
        s = "(null)";
    80005f9c:	00003497          	auipc	s1,0x3
    80005fa0:	8ac48493          	addi	s1,s1,-1876 # 80008848 <syscalls+0x448>
      for(; *s; s++)
    80005fa4:	02800513          	li	a0,40
    80005fa8:	b7cd                	j	80005f8a <printf+0x16a>
      consputc('%');
    80005faa:	8556                	mv	a0,s5
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	b66080e7          	jalr	-1178(ra) # 80005b12 <consputc>
      break;
    80005fb4:	b719                	j	80005eba <printf+0x9a>
      consputc('%');
    80005fb6:	8556                	mv	a0,s5
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	b5a080e7          	jalr	-1190(ra) # 80005b12 <consputc>
      consputc(c);
    80005fc0:	8526                	mv	a0,s1
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	b50080e7          	jalr	-1200(ra) # 80005b12 <consputc>
      break;
    80005fca:	bdc5                	j	80005eba <printf+0x9a>
  if(locking)
    80005fcc:	020d9163          	bnez	s11,80005fee <printf+0x1ce>
}
    80005fd0:	70e6                	ld	ra,120(sp)
    80005fd2:	7446                	ld	s0,112(sp)
    80005fd4:	74a6                	ld	s1,104(sp)
    80005fd6:	7906                	ld	s2,96(sp)
    80005fd8:	69e6                	ld	s3,88(sp)
    80005fda:	6a46                	ld	s4,80(sp)
    80005fdc:	6aa6                	ld	s5,72(sp)
    80005fde:	6b06                	ld	s6,64(sp)
    80005fe0:	7be2                	ld	s7,56(sp)
    80005fe2:	7c42                	ld	s8,48(sp)
    80005fe4:	7ca2                	ld	s9,40(sp)
    80005fe6:	7d02                	ld	s10,32(sp)
    80005fe8:	6de2                	ld	s11,24(sp)
    80005fea:	6129                	addi	sp,sp,192
    80005fec:	8082                	ret
    release(&pr.lock);
    80005fee:	0001c517          	auipc	a0,0x1c
    80005ff2:	f8a50513          	addi	a0,a0,-118 # 80021f78 <pr>
    80005ff6:	00000097          	auipc	ra,0x0
    80005ffa:	3cc080e7          	jalr	972(ra) # 800063c2 <release>
}
    80005ffe:	bfc9                	j	80005fd0 <printf+0x1b0>

0000000080006000 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006000:	1101                	addi	sp,sp,-32
    80006002:	ec06                	sd	ra,24(sp)
    80006004:	e822                	sd	s0,16(sp)
    80006006:	e426                	sd	s1,8(sp)
    80006008:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000600a:	0001c497          	auipc	s1,0x1c
    8000600e:	f6e48493          	addi	s1,s1,-146 # 80021f78 <pr>
    80006012:	00003597          	auipc	a1,0x3
    80006016:	84e58593          	addi	a1,a1,-1970 # 80008860 <syscalls+0x460>
    8000601a:	8526                	mv	a0,s1
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	262080e7          	jalr	610(ra) # 8000627e <initlock>
  pr.locking = 1;
    80006024:	4785                	li	a5,1
    80006026:	cc9c                	sw	a5,24(s1)
}
    80006028:	60e2                	ld	ra,24(sp)
    8000602a:	6442                	ld	s0,16(sp)
    8000602c:	64a2                	ld	s1,8(sp)
    8000602e:	6105                	addi	sp,sp,32
    80006030:	8082                	ret

0000000080006032 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006032:	1141                	addi	sp,sp,-16
    80006034:	e406                	sd	ra,8(sp)
    80006036:	e022                	sd	s0,0(sp)
    80006038:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000603a:	100007b7          	lui	a5,0x10000
    8000603e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006042:	f8000713          	li	a4,-128
    80006046:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000604a:	470d                	li	a4,3
    8000604c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006050:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006054:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006058:	469d                	li	a3,7
    8000605a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000605e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006062:	00003597          	auipc	a1,0x3
    80006066:	81e58593          	addi	a1,a1,-2018 # 80008880 <digits+0x18>
    8000606a:	0001c517          	auipc	a0,0x1c
    8000606e:	f2e50513          	addi	a0,a0,-210 # 80021f98 <uart_tx_lock>
    80006072:	00000097          	auipc	ra,0x0
    80006076:	20c080e7          	jalr	524(ra) # 8000627e <initlock>
}
    8000607a:	60a2                	ld	ra,8(sp)
    8000607c:	6402                	ld	s0,0(sp)
    8000607e:	0141                	addi	sp,sp,16
    80006080:	8082                	ret

0000000080006082 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
    8000608c:	84aa                	mv	s1,a0
  push_off();
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	234080e7          	jalr	564(ra) # 800062c2 <push_off>

  if(panicked){
    80006096:	00003797          	auipc	a5,0x3
    8000609a:	8b67a783          	lw	a5,-1866(a5) # 8000894c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609e:	10000737          	lui	a4,0x10000
  if(panicked){
    800060a2:	c391                	beqz	a5,800060a6 <uartputc_sync+0x24>
    for(;;)
    800060a4:	a001                	j	800060a4 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060a6:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060aa:	0207f793          	andi	a5,a5,32
    800060ae:	dfe5                	beqz	a5,800060a6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060b0:	0ff4f513          	zext.b	a0,s1
    800060b4:	100007b7          	lui	a5,0x10000
    800060b8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	2a6080e7          	jalr	678(ra) # 80006362 <pop_off>
}
    800060c4:	60e2                	ld	ra,24(sp)
    800060c6:	6442                	ld	s0,16(sp)
    800060c8:	64a2                	ld	s1,8(sp)
    800060ca:	6105                	addi	sp,sp,32
    800060cc:	8082                	ret

00000000800060ce <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ce:	00003797          	auipc	a5,0x3
    800060d2:	8827b783          	ld	a5,-1918(a5) # 80008950 <uart_tx_r>
    800060d6:	00003717          	auipc	a4,0x3
    800060da:	88273703          	ld	a4,-1918(a4) # 80008958 <uart_tx_w>
    800060de:	06f70a63          	beq	a4,a5,80006152 <uartstart+0x84>
{
    800060e2:	7139                	addi	sp,sp,-64
    800060e4:	fc06                	sd	ra,56(sp)
    800060e6:	f822                	sd	s0,48(sp)
    800060e8:	f426                	sd	s1,40(sp)
    800060ea:	f04a                	sd	s2,32(sp)
    800060ec:	ec4e                	sd	s3,24(sp)
    800060ee:	e852                	sd	s4,16(sp)
    800060f0:	e456                	sd	s5,8(sp)
    800060f2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f8:	0001ca17          	auipc	s4,0x1c
    800060fc:	ea0a0a13          	addi	s4,s4,-352 # 80021f98 <uart_tx_lock>
    uart_tx_r += 1;
    80006100:	00003497          	auipc	s1,0x3
    80006104:	85048493          	addi	s1,s1,-1968 # 80008950 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006108:	00003997          	auipc	s3,0x3
    8000610c:	85098993          	addi	s3,s3,-1968 # 80008958 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006110:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006114:	02077713          	andi	a4,a4,32
    80006118:	c705                	beqz	a4,80006140 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611a:	01f7f713          	andi	a4,a5,31
    8000611e:	9752                	add	a4,a4,s4
    80006120:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006124:	0785                	addi	a5,a5,1
    80006126:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006128:	8526                	mv	a0,s1
    8000612a:	ffffb097          	auipc	ra,0xffffb
    8000612e:	5d8080e7          	jalr	1496(ra) # 80001702 <wakeup>
    
    WriteReg(THR, c);
    80006132:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006136:	609c                	ld	a5,0(s1)
    80006138:	0009b703          	ld	a4,0(s3)
    8000613c:	fcf71ae3          	bne	a4,a5,80006110 <uartstart+0x42>
  }
}
    80006140:	70e2                	ld	ra,56(sp)
    80006142:	7442                	ld	s0,48(sp)
    80006144:	74a2                	ld	s1,40(sp)
    80006146:	7902                	ld	s2,32(sp)
    80006148:	69e2                	ld	s3,24(sp)
    8000614a:	6a42                	ld	s4,16(sp)
    8000614c:	6aa2                	ld	s5,8(sp)
    8000614e:	6121                	addi	sp,sp,64
    80006150:	8082                	ret
    80006152:	8082                	ret

0000000080006154 <uartputc>:
{
    80006154:	7179                	addi	sp,sp,-48
    80006156:	f406                	sd	ra,40(sp)
    80006158:	f022                	sd	s0,32(sp)
    8000615a:	ec26                	sd	s1,24(sp)
    8000615c:	e84a                	sd	s2,16(sp)
    8000615e:	e44e                	sd	s3,8(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006166:	0001c517          	auipc	a0,0x1c
    8000616a:	e3250513          	addi	a0,a0,-462 # 80021f98 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a0080e7          	jalr	416(ra) # 8000630e <acquire>
  if(panicked){
    80006176:	00002797          	auipc	a5,0x2
    8000617a:	7d67a783          	lw	a5,2006(a5) # 8000894c <panicked>
    8000617e:	e7c9                	bnez	a5,80006208 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006180:	00002717          	auipc	a4,0x2
    80006184:	7d873703          	ld	a4,2008(a4) # 80008958 <uart_tx_w>
    80006188:	00002797          	auipc	a5,0x2
    8000618c:	7c87b783          	ld	a5,1992(a5) # 80008950 <uart_tx_r>
    80006190:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006194:	0001c997          	auipc	s3,0x1c
    80006198:	e0498993          	addi	s3,s3,-508 # 80021f98 <uart_tx_lock>
    8000619c:	00002497          	auipc	s1,0x2
    800061a0:	7b448493          	addi	s1,s1,1972 # 80008950 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a4:	00002917          	auipc	s2,0x2
    800061a8:	7b490913          	addi	s2,s2,1972 # 80008958 <uart_tx_w>
    800061ac:	00e79f63          	bne	a5,a4,800061ca <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800061b0:	85ce                	mv	a1,s3
    800061b2:	8526                	mv	a0,s1
    800061b4:	ffffb097          	auipc	ra,0xffffb
    800061b8:	4ea080e7          	jalr	1258(ra) # 8000169e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061bc:	00093703          	ld	a4,0(s2)
    800061c0:	609c                	ld	a5,0(s1)
    800061c2:	02078793          	addi	a5,a5,32
    800061c6:	fee785e3          	beq	a5,a4,800061b0 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061ca:	0001c497          	auipc	s1,0x1c
    800061ce:	dce48493          	addi	s1,s1,-562 # 80021f98 <uart_tx_lock>
    800061d2:	01f77793          	andi	a5,a4,31
    800061d6:	97a6                	add	a5,a5,s1
    800061d8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800061dc:	0705                	addi	a4,a4,1
    800061de:	00002797          	auipc	a5,0x2
    800061e2:	76e7bd23          	sd	a4,1914(a5) # 80008958 <uart_tx_w>
  uartstart();
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	ee8080e7          	jalr	-280(ra) # 800060ce <uartstart>
  release(&uart_tx_lock);
    800061ee:	8526                	mv	a0,s1
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	1d2080e7          	jalr	466(ra) # 800063c2 <release>
}
    800061f8:	70a2                	ld	ra,40(sp)
    800061fa:	7402                	ld	s0,32(sp)
    800061fc:	64e2                	ld	s1,24(sp)
    800061fe:	6942                	ld	s2,16(sp)
    80006200:	69a2                	ld	s3,8(sp)
    80006202:	6a02                	ld	s4,0(sp)
    80006204:	6145                	addi	sp,sp,48
    80006206:	8082                	ret
    for(;;)
    80006208:	a001                	j	80006208 <uartputc+0xb4>

000000008000620a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000620a:	1141                	addi	sp,sp,-16
    8000620c:	e422                	sd	s0,8(sp)
    8000620e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006210:	100007b7          	lui	a5,0x10000
    80006214:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006218:	8b85                	andi	a5,a5,1
    8000621a:	cb81                	beqz	a5,8000622a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006224:	6422                	ld	s0,8(sp)
    80006226:	0141                	addi	sp,sp,16
    80006228:	8082                	ret
    return -1;
    8000622a:	557d                	li	a0,-1
    8000622c:	bfe5                	j	80006224 <uartgetc+0x1a>

000000008000622e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000622e:	1101                	addi	sp,sp,-32
    80006230:	ec06                	sd	ra,24(sp)
    80006232:	e822                	sd	s0,16(sp)
    80006234:	e426                	sd	s1,8(sp)
    80006236:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006238:	54fd                	li	s1,-1
    8000623a:	a029                	j	80006244 <uartintr+0x16>
      break;
    consoleintr(c);
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	918080e7          	jalr	-1768(ra) # 80005b54 <consoleintr>
    int c = uartgetc();
    80006244:	00000097          	auipc	ra,0x0
    80006248:	fc6080e7          	jalr	-58(ra) # 8000620a <uartgetc>
    if(c == -1)
    8000624c:	fe9518e3          	bne	a0,s1,8000623c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006250:	0001c497          	auipc	s1,0x1c
    80006254:	d4848493          	addi	s1,s1,-696 # 80021f98 <uart_tx_lock>
    80006258:	8526                	mv	a0,s1
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	0b4080e7          	jalr	180(ra) # 8000630e <acquire>
  uartstart();
    80006262:	00000097          	auipc	ra,0x0
    80006266:	e6c080e7          	jalr	-404(ra) # 800060ce <uartstart>
  release(&uart_tx_lock);
    8000626a:	8526                	mv	a0,s1
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	156080e7          	jalr	342(ra) # 800063c2 <release>
}
    80006274:	60e2                	ld	ra,24(sp)
    80006276:	6442                	ld	s0,16(sp)
    80006278:	64a2                	ld	s1,8(sp)
    8000627a:	6105                	addi	sp,sp,32
    8000627c:	8082                	ret

000000008000627e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000627e:	1141                	addi	sp,sp,-16
    80006280:	e422                	sd	s0,8(sp)
    80006282:	0800                	addi	s0,sp,16
  lk->name = name;
    80006284:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006286:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000628a:	00053823          	sd	zero,16(a0)
}
    8000628e:	6422                	ld	s0,8(sp)
    80006290:	0141                	addi	sp,sp,16
    80006292:	8082                	ret

0000000080006294 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006294:	411c                	lw	a5,0(a0)
    80006296:	e399                	bnez	a5,8000629c <holding+0x8>
    80006298:	4501                	li	a0,0
  return r;
}
    8000629a:	8082                	ret
{
    8000629c:	1101                	addi	sp,sp,-32
    8000629e:	ec06                	sd	ra,24(sp)
    800062a0:	e822                	sd	s0,16(sp)
    800062a2:	e426                	sd	s1,8(sp)
    800062a4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062a6:	6904                	ld	s1,16(a0)
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	c84080e7          	jalr	-892(ra) # 80000f2c <mycpu>
    800062b0:	40a48533          	sub	a0,s1,a0
    800062b4:	00153513          	seqz	a0,a0
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret

00000000800062c2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062c2:	1101                	addi	sp,sp,-32
    800062c4:	ec06                	sd	ra,24(sp)
    800062c6:	e822                	sd	s0,16(sp)
    800062c8:	e426                	sd	s1,8(sp)
    800062ca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062cc:	100024f3          	csrr	s1,sstatus
    800062d0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062d4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062d6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062da:	ffffb097          	auipc	ra,0xffffb
    800062de:	c52080e7          	jalr	-942(ra) # 80000f2c <mycpu>
    800062e2:	5d3c                	lw	a5,120(a0)
    800062e4:	cf89                	beqz	a5,800062fe <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062e6:	ffffb097          	auipc	ra,0xffffb
    800062ea:	c46080e7          	jalr	-954(ra) # 80000f2c <mycpu>
    800062ee:	5d3c                	lw	a5,120(a0)
    800062f0:	2785                	addiw	a5,a5,1
    800062f2:	dd3c                	sw	a5,120(a0)
}
    800062f4:	60e2                	ld	ra,24(sp)
    800062f6:	6442                	ld	s0,16(sp)
    800062f8:	64a2                	ld	s1,8(sp)
    800062fa:	6105                	addi	sp,sp,32
    800062fc:	8082                	ret
    mycpu()->intena = old;
    800062fe:	ffffb097          	auipc	ra,0xffffb
    80006302:	c2e080e7          	jalr	-978(ra) # 80000f2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006306:	8085                	srli	s1,s1,0x1
    80006308:	8885                	andi	s1,s1,1
    8000630a:	dd64                	sw	s1,124(a0)
    8000630c:	bfe9                	j	800062e6 <push_off+0x24>

000000008000630e <acquire>:
{
    8000630e:	1101                	addi	sp,sp,-32
    80006310:	ec06                	sd	ra,24(sp)
    80006312:	e822                	sd	s0,16(sp)
    80006314:	e426                	sd	s1,8(sp)
    80006316:	1000                	addi	s0,sp,32
    80006318:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	fa8080e7          	jalr	-88(ra) # 800062c2 <push_off>
  if(holding(lk))
    80006322:	8526                	mv	a0,s1
    80006324:	00000097          	auipc	ra,0x0
    80006328:	f70080e7          	jalr	-144(ra) # 80006294 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000632c:	4705                	li	a4,1
  if(holding(lk))
    8000632e:	e115                	bnez	a0,80006352 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006330:	87ba                	mv	a5,a4
    80006332:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006336:	2781                	sext.w	a5,a5
    80006338:	ffe5                	bnez	a5,80006330 <acquire+0x22>
  __sync_synchronize();
    8000633a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	bee080e7          	jalr	-1042(ra) # 80000f2c <mycpu>
    80006346:	e888                	sd	a0,16(s1)
}
    80006348:	60e2                	ld	ra,24(sp)
    8000634a:	6442                	ld	s0,16(sp)
    8000634c:	64a2                	ld	s1,8(sp)
    8000634e:	6105                	addi	sp,sp,32
    80006350:	8082                	ret
    panic("acquire");
    80006352:	00002517          	auipc	a0,0x2
    80006356:	53650513          	addi	a0,a0,1334 # 80008888 <digits+0x20>
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	a7c080e7          	jalr	-1412(ra) # 80005dd6 <panic>

0000000080006362 <pop_off>:

void
pop_off(void)
{
    80006362:	1141                	addi	sp,sp,-16
    80006364:	e406                	sd	ra,8(sp)
    80006366:	e022                	sd	s0,0(sp)
    80006368:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000636a:	ffffb097          	auipc	ra,0xffffb
    8000636e:	bc2080e7          	jalr	-1086(ra) # 80000f2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006372:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006376:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006378:	e78d                	bnez	a5,800063a2 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000637a:	5d3c                	lw	a5,120(a0)
    8000637c:	02f05b63          	blez	a5,800063b2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006380:	37fd                	addiw	a5,a5,-1
    80006382:	0007871b          	sext.w	a4,a5
    80006386:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006388:	eb09                	bnez	a4,8000639a <pop_off+0x38>
    8000638a:	5d7c                	lw	a5,124(a0)
    8000638c:	c799                	beqz	a5,8000639a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006392:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006396:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000639a:	60a2                	ld	ra,8(sp)
    8000639c:	6402                	ld	s0,0(sp)
    8000639e:	0141                	addi	sp,sp,16
    800063a0:	8082                	ret
    panic("pop_off - interruptible");
    800063a2:	00002517          	auipc	a0,0x2
    800063a6:	4ee50513          	addi	a0,a0,1262 # 80008890 <digits+0x28>
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	a2c080e7          	jalr	-1492(ra) # 80005dd6 <panic>
    panic("pop_off");
    800063b2:	00002517          	auipc	a0,0x2
    800063b6:	4f650513          	addi	a0,a0,1270 # 800088a8 <digits+0x40>
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	a1c080e7          	jalr	-1508(ra) # 80005dd6 <panic>

00000000800063c2 <release>:
{
    800063c2:	1101                	addi	sp,sp,-32
    800063c4:	ec06                	sd	ra,24(sp)
    800063c6:	e822                	sd	s0,16(sp)
    800063c8:	e426                	sd	s1,8(sp)
    800063ca:	1000                	addi	s0,sp,32
    800063cc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063ce:	00000097          	auipc	ra,0x0
    800063d2:	ec6080e7          	jalr	-314(ra) # 80006294 <holding>
    800063d6:	c115                	beqz	a0,800063fa <release+0x38>
  lk->cpu = 0;
    800063d8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063dc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063e0:	0f50000f          	fence	iorw,ow
    800063e4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	f7a080e7          	jalr	-134(ra) # 80006362 <pop_off>
}
    800063f0:	60e2                	ld	ra,24(sp)
    800063f2:	6442                	ld	s0,16(sp)
    800063f4:	64a2                	ld	s1,8(sp)
    800063f6:	6105                	addi	sp,sp,32
    800063f8:	8082                	ret
    panic("release");
    800063fa:	00002517          	auipc	a0,0x2
    800063fe:	4b650513          	addi	a0,a0,1206 # 800088b0 <digits+0x48>
    80006402:	00000097          	auipc	ra,0x0
    80006406:	9d4080e7          	jalr	-1580(ra) # 80005dd6 <panic>
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
