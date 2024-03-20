
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c013103          	ld	sp,-1856(sp) # 800088c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	021050ef          	jal	ra,80005836 <start>

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
    80000034:	55078793          	addi	a5,a5,1360 # 80022580 <end>
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
    80000054:	8c090913          	addi	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	224080e7          	jalr	548(ra) # 8000627e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2c4080e7          	jalr	708(ra) # 80006332 <release>
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
    8000008e:	ce6080e7          	jalr	-794(ra) # 80005d70 <panic>

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
    800000f2:	82250513          	addi	a0,a0,-2014 # 80008910 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0f8080e7          	jalr	248(ra) # 800061ee <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	47e50513          	addi	a0,a0,1150 # 80022580 <end>
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
    80000124:	00008497          	auipc	s1,0x8
    80000128:	7ec48493          	addi	s1,s1,2028 # 80008910 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	150080e7          	jalr	336(ra) # 8000627e <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7d450513          	addi	a0,a0,2004 # 80008910 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	1ec080e7          	jalr	492(ra) # 80006332 <release>

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
    8000016c:	7a850513          	addi	a0,a0,1960 # 80008910 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1c2080e7          	jalr	450(ra) # 80006332 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdca81>
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
    8000032a:	b00080e7          	jalr	-1280(ra) # 80000e26 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000032e:	00008717          	auipc	a4,0x8
    80000332:	5b270713          	addi	a4,a4,1458 # 800088e0 <started>
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
    80000346:	ae4080e7          	jalr	-1308(ra) # 80000e26 <cpuid>
    8000034a:	85aa                	mv	a1,a0
    8000034c:	00008517          	auipc	a0,0x8
    80000350:	cec50513          	addi	a0,a0,-788 # 80008038 <etext+0x38>
    80000354:	00006097          	auipc	ra,0x6
    80000358:	a6e080e7          	jalr	-1426(ra) # 80005dc2 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00002097          	auipc	ra,0x2
    80000368:	876080e7          	jalr	-1930(ra) # 80001bda <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	e84080e7          	jalr	-380(ra) # 800051f0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	02e080e7          	jalr	46(ra) # 800013a2 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	87a080e7          	jalr	-1926(ra) # 80005bf6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	962080e7          	jalr	-1694(ra) # 80005ce6 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	a2e080e7          	jalr	-1490(ra) # 80005dc2 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	a1e080e7          	jalr	-1506(ra) # 80005dc2 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	a0e080e7          	jalr	-1522(ra) # 80005dc2 <printf>
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
    800003d8:	99e080e7          	jalr	-1634(ra) # 80000d72 <procinit>
    trapinit();      // trap vectors
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	7d6080e7          	jalr	2006(ra) # 80001bb2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	7f6080e7          	jalr	2038(ra) # 80001bda <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	dee080e7          	jalr	-530(ra) # 800051da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	dfc080e7          	jalr	-516(ra) # 800051f0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	ff0080e7          	jalr	-16(ra) # 800023ec <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	68e080e7          	jalr	1678(ra) # 80002a92 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	604080e7          	jalr	1540(ra) # 80003a10 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	ee4080e7          	jalr	-284(ra) # 800052f8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d68080e7          	jalr	-664(ra) # 80001184 <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	4af72b23          	sw	a5,1206(a4) # 800088e0 <started>
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
    80000442:	4aa7b783          	ld	a5,1194(a5) # 800088e8 <kernel_pagetable>
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
    8000048e:	8e6080e7          	jalr	-1818(ra) # 80005d70 <panic>
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
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdca77>
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
    800005b4:	7c0080e7          	jalr	1984(ra) # 80005d70 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	7b0080e7          	jalr	1968(ra) # 80005d70 <panic>
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
    80000610:	764080e7          	jalr	1892(ra) # 80005d70 <panic>

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
    800006d8:	608080e7          	jalr	1544(ra) # 80000cdc <proc_mapstacks>
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
    800006fe:	1ea7b723          	sd	a0,494(a5) # 800088e8 <kernel_pagetable>
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
    8000075c:	618080e7          	jalr	1560(ra) # 80005d70 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	608080e7          	jalr	1544(ra) # 80005d70 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	5f8080e7          	jalr	1528(ra) # 80005d70 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	5e8080e7          	jalr	1512(ra) # 80005d70 <panic>
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
    8000086a:	50a080e7          	jalr	1290(ra) # 80005d70 <panic>

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
    800009b6:	3be080e7          	jalr	958(ra) # 80005d70 <panic>
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
    80000a94:	2e0080e7          	jalr	736(ra) # 80005d70 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	2d0080e7          	jalr	720(ra) # 80005d70 <panic>
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
    80000b0e:	266080e7          	jalr	614(ra) # 80005d70 <panic>

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
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdca80>
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

0000000080000cdc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cdc:	7139                	addi	sp,sp,-64
    80000cde:	fc06                	sd	ra,56(sp)
    80000ce0:	f822                	sd	s0,48(sp)
    80000ce2:	f426                	sd	s1,40(sp)
    80000ce4:	f04a                	sd	s2,32(sp)
    80000ce6:	ec4e                	sd	s3,24(sp)
    80000ce8:	e852                	sd	s4,16(sp)
    80000cea:	e456                	sd	s5,8(sp)
    80000cec:	e05a                	sd	s6,0(sp)
    80000cee:	0080                	addi	s0,sp,64
    80000cf0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf2:	00008497          	auipc	s1,0x8
    80000cf6:	06e48493          	addi	s1,s1,110 # 80008d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cfa:	8b26                	mv	s6,s1
    80000cfc:	00007a97          	auipc	s5,0x7
    80000d00:	304a8a93          	addi	s5,s5,772 # 80008000 <etext>
    80000d04:	04000937          	lui	s2,0x4000
    80000d08:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d0a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	0000ea17          	auipc	s4,0xe
    80000d10:	254a0a13          	addi	s4,s4,596 # 8000ef60 <tickslock>
    char *pa = kalloc();
    80000d14:	fffff097          	auipc	ra,0xfffff
    80000d18:	406080e7          	jalr	1030(ra) # 8000011a <kalloc>
    80000d1c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d1e:	c131                	beqz	a0,80000d62 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d20:	416485b3          	sub	a1,s1,s6
    80000d24:	858d                	srai	a1,a1,0x3
    80000d26:	000ab783          	ld	a5,0(s5)
    80000d2a:	02f585b3          	mul	a1,a1,a5
    80000d2e:	2585                	addiw	a1,a1,1
    80000d30:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d34:	4719                	li	a4,6
    80000d36:	6685                	lui	a3,0x1
    80000d38:	40b905b3          	sub	a1,s2,a1
    80000d3c:	854e                	mv	a0,s3
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	8a6080e7          	jalr	-1882(ra) # 800005e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d46:	18848493          	addi	s1,s1,392
    80000d4a:	fd4495e3          	bne	s1,s4,80000d14 <proc_mapstacks+0x38>
  }
}
    80000d4e:	70e2                	ld	ra,56(sp)
    80000d50:	7442                	ld	s0,48(sp)
    80000d52:	74a2                	ld	s1,40(sp)
    80000d54:	7902                	ld	s2,32(sp)
    80000d56:	69e2                	ld	s3,24(sp)
    80000d58:	6a42                	ld	s4,16(sp)
    80000d5a:	6aa2                	ld	s5,8(sp)
    80000d5c:	6b02                	ld	s6,0(sp)
    80000d5e:	6121                	addi	sp,sp,64
    80000d60:	8082                	ret
      panic("kalloc");
    80000d62:	00007517          	auipc	a0,0x7
    80000d66:	3f650513          	addi	a0,a0,1014 # 80008158 <etext+0x158>
    80000d6a:	00005097          	auipc	ra,0x5
    80000d6e:	006080e7          	jalr	6(ra) # 80005d70 <panic>

0000000080000d72 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d72:	7139                	addi	sp,sp,-64
    80000d74:	fc06                	sd	ra,56(sp)
    80000d76:	f822                	sd	s0,48(sp)
    80000d78:	f426                	sd	s1,40(sp)
    80000d7a:	f04a                	sd	s2,32(sp)
    80000d7c:	ec4e                	sd	s3,24(sp)
    80000d7e:	e852                	sd	s4,16(sp)
    80000d80:	e456                	sd	s5,8(sp)
    80000d82:	e05a                	sd	s6,0(sp)
    80000d84:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d86:	00007597          	auipc	a1,0x7
    80000d8a:	3da58593          	addi	a1,a1,986 # 80008160 <etext+0x160>
    80000d8e:	00008517          	auipc	a0,0x8
    80000d92:	ba250513          	addi	a0,a0,-1118 # 80008930 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	458080e7          	jalr	1112(ra) # 800061ee <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	ba250513          	addi	a0,a0,-1118 # 80008948 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	440080e7          	jalr	1088(ra) # 800061ee <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	faa48493          	addi	s1,s1,-86 # 80008d60 <proc>
      initlock(&p->lock, "proc");
    80000dbe:	00007b17          	auipc	s6,0x7
    80000dc2:	3bab0b13          	addi	s6,s6,954 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dc6:	8aa6                	mv	s5,s1
    80000dc8:	00007a17          	auipc	s4,0x7
    80000dcc:	238a0a13          	addi	s4,s4,568 # 80008000 <etext>
    80000dd0:	04000937          	lui	s2,0x4000
    80000dd4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dd6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	0000e997          	auipc	s3,0xe
    80000ddc:	18898993          	addi	s3,s3,392 # 8000ef60 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	40a080e7          	jalr	1034(ra) # 800061ee <initlock>
      p->state = UNUSED;
    80000dec:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	415487b3          	sub	a5,s1,s5
    80000df4:	878d                	srai	a5,a5,0x3
    80000df6:	000a3703          	ld	a4,0(s4)
    80000dfa:	02e787b3          	mul	a5,a5,a4
    80000dfe:	2785                	addiw	a5,a5,1
    80000e00:	00d7979b          	slliw	a5,a5,0xd
    80000e04:	40f907b3          	sub	a5,s2,a5
    80000e08:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	18848493          	addi	s1,s1,392
    80000e0e:	fd3499e3          	bne	s1,s3,80000de0 <procinit+0x6e>
  }
}
    80000e12:	70e2                	ld	ra,56(sp)
    80000e14:	7442                	ld	s0,48(sp)
    80000e16:	74a2                	ld	s1,40(sp)
    80000e18:	7902                	ld	s2,32(sp)
    80000e1a:	69e2                	ld	s3,24(sp)
    80000e1c:	6a42                	ld	s4,16(sp)
    80000e1e:	6aa2                	ld	s5,8(sp)
    80000e20:	6b02                	ld	s6,0(sp)
    80000e22:	6121                	addi	sp,sp,64
    80000e24:	8082                	ret

0000000080000e26 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e26:	1141                	addi	sp,sp,-16
    80000e28:	e422                	sd	s0,8(sp)
    80000e2a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e2c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e2e:	2501                	sext.w	a0,a0
    80000e30:	6422                	ld	s0,8(sp)
    80000e32:	0141                	addi	sp,sp,16
    80000e34:	8082                	ret

0000000080000e36 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
    80000e3c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e42:	00008517          	auipc	a0,0x8
    80000e46:	b1e50513          	addi	a0,a0,-1250 # 80008960 <cpus>
    80000e4a:	953e                	add	a0,a0,a5
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e52:	1101                	addi	sp,sp,-32
    80000e54:	ec06                	sd	ra,24(sp)
    80000e56:	e822                	sd	s0,16(sp)
    80000e58:	e426                	sd	s1,8(sp)
    80000e5a:	1000                	addi	s0,sp,32
  push_off();
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	3d6080e7          	jalr	982(ra) # 80006232 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	ac670713          	addi	a4,a4,-1338 # 80008930 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	45c080e7          	jalr	1116(ra) # 800062d2 <pop_off>
  return p;
}
    80000e7e:	8526                	mv	a0,s1
    80000e80:	60e2                	ld	ra,24(sp)
    80000e82:	6442                	ld	s0,16(sp)
    80000e84:	64a2                	ld	s1,8(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e406                	sd	ra,8(sp)
    80000e8e:	e022                	sd	s0,0(sp)
    80000e90:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e92:	00000097          	auipc	ra,0x0
    80000e96:	fc0080e7          	jalr	-64(ra) # 80000e52 <myproc>
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	498080e7          	jalr	1176(ra) # 80006332 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	9ce7a783          	lw	a5,-1586(a5) # 80008870 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	d46080e7          	jalr	-698(ra) # 80001bf2 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9a07aa23          	sw	zero,-1612(a5) # 80008870 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	b4c080e7          	jalr	-1204(ra) # 80002a12 <fsinit>
    80000ece:	bff9                	j	80000eac <forkret+0x22>

0000000080000ed0 <allocpid>:
{
    80000ed0:	1101                	addi	sp,sp,-32
    80000ed2:	ec06                	sd	ra,24(sp)
    80000ed4:	e822                	sd	s0,16(sp)
    80000ed6:	e426                	sd	s1,8(sp)
    80000ed8:	e04a                	sd	s2,0(sp)
    80000eda:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000edc:	00008917          	auipc	s2,0x8
    80000ee0:	a5490913          	addi	s2,s2,-1452 # 80008930 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	398080e7          	jalr	920(ra) # 8000627e <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	98678793          	addi	a5,a5,-1658 # 80008874 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	432080e7          	jalr	1074(ra) # 80006332 <release>
}
    80000f08:	8526                	mv	a0,s1
    80000f0a:	60e2                	ld	ra,24(sp)
    80000f0c:	6442                	ld	s0,16(sp)
    80000f0e:	64a2                	ld	s1,8(sp)
    80000f10:	6902                	ld	s2,0(sp)
    80000f12:	6105                	addi	sp,sp,32
    80000f14:	8082                	ret

0000000080000f16 <proc_pagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	8aa080e7          	jalr	-1878(ra) # 800007ce <uvmcreate>
    80000f2c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f30:	4729                	li	a4,10
    80000f32:	00006697          	auipc	a3,0x6
    80000f36:	0ce68693          	addi	a3,a3,206 # 80007000 <_trampoline>
    80000f3a:	6605                	lui	a2,0x1
    80000f3c:	040005b7          	lui	a1,0x4000
    80000f40:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f42:	05b2                	slli	a1,a1,0xc
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	600080e7          	jalr	1536(ra) # 80000544 <mappages>
    80000f4c:	02054863          	bltz	a0,80000f7c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f50:	4719                	li	a4,6
    80000f52:	05893683          	ld	a3,88(s2)
    80000f56:	6605                	lui	a2,0x1
    80000f58:	020005b7          	lui	a1,0x2000
    80000f5c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5e:	05b6                	slli	a1,a1,0xd
    80000f60:	8526                	mv	a0,s1
    80000f62:	fffff097          	auipc	ra,0xfffff
    80000f66:	5e2080e7          	jalr	1506(ra) # 80000544 <mappages>
    80000f6a:	02054163          	bltz	a0,80000f8c <proc_pagetable+0x76>
}
    80000f6e:	8526                	mv	a0,s1
    80000f70:	60e2                	ld	ra,24(sp)
    80000f72:	6442                	ld	s0,16(sp)
    80000f74:	64a2                	ld	s1,8(sp)
    80000f76:	6902                	ld	s2,0(sp)
    80000f78:	6105                	addi	sp,sp,32
    80000f7a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f7c:	4581                	li	a1,0
    80000f7e:	8526                	mv	a0,s1
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	a54080e7          	jalr	-1452(ra) # 800009d4 <uvmfree>
    return 0;
    80000f88:	4481                	li	s1,0
    80000f8a:	b7d5                	j	80000f6e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f8c:	4681                	li	a3,0
    80000f8e:	4605                	li	a2,1
    80000f90:	040005b7          	lui	a1,0x4000
    80000f94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f96:	05b2                	slli	a1,a1,0xc
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	770080e7          	jalr	1904(ra) # 8000070a <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa2:	4581                	li	a1,0
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	a2e080e7          	jalr	-1490(ra) # 800009d4 <uvmfree>
    return 0;
    80000fae:	4481                	li	s1,0
    80000fb0:	bf7d                	j	80000f6e <proc_pagetable+0x58>

0000000080000fb2 <proc_freepagetable>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
    80000fbe:	84aa                	mv	s1,a0
    80000fc0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	040005b7          	lui	a1,0x4000
    80000fca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fcc:	05b2                	slli	a1,a1,0xc
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	73c080e7          	jalr	1852(ra) # 8000070a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	020005b7          	lui	a1,0x2000
    80000fde:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe0:	05b6                	slli	a1,a1,0xd
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	726080e7          	jalr	1830(ra) # 8000070a <uvmunmap>
  uvmfree(pagetable, sz);
    80000fec:	85ca                	mv	a1,s2
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	9e4080e7          	jalr	-1564(ra) # 800009d4 <uvmfree>
}
    80000ff8:	60e2                	ld	ra,24(sp)
    80000ffa:	6442                	ld	s0,16(sp)
    80000ffc:	64a2                	ld	s1,8(sp)
    80000ffe:	6902                	ld	s2,0(sp)
    80001000:	6105                	addi	sp,sp,32
    80001002:	8082                	ret

0000000080001004 <freeproc>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001010:	6d28                	ld	a0,88(a0)
    80001012:	c509                	beqz	a0,8000101c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001014:	fffff097          	auipc	ra,0xfffff
    80001018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000101c:	0404bc23          	sd	zero,88(s1)
  if(p->copy_trapframe)
    80001020:	1804b503          	ld	a0,384(s1)
    80001024:	c509                	beqz	a0,8000102e <freeproc+0x2a>
    kfree((void*)p->copy_trapframe);  
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	ff6080e7          	jalr	-10(ra) # 8000001c <kfree>
  p->copy_trapframe = 0;
    8000102e:	1804b023          	sd	zero,384(s1)
  if(p->pagetable)
    80001032:	68a8                	ld	a0,80(s1)
    80001034:	c511                	beqz	a0,80001040 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    80001036:	64ac                	ld	a1,72(s1)
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	f7a080e7          	jalr	-134(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    80001040:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001044:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001048:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000104c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001050:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001054:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001058:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000105c:	0204a623          	sw	zero,44(s1)
  p->ticks = 0;
    80001060:	1604a423          	sw	zero,360(s1)
  p->alarm_past = 0;
    80001064:	1604a623          	sw	zero,364(s1)
  p->handler = 0;
    80001068:	1604b823          	sd	zero,368(s1)
  p->alarm_sigreturn = 0;
    8000106c:	1604ac23          	sw	zero,376(s1)
  p->state = UNUSED;
    80001070:	0004ac23          	sw	zero,24(s1)
}
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret

000000008000107e <allocproc>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	e04a                	sd	s2,0(sp)
    80001088:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000108a:	00008497          	auipc	s1,0x8
    8000108e:	cd648493          	addi	s1,s1,-810 # 80008d60 <proc>
    80001092:	0000e917          	auipc	s2,0xe
    80001096:	ece90913          	addi	s2,s2,-306 # 8000ef60 <tickslock>
    acquire(&p->lock);
    8000109a:	8526                	mv	a0,s1
    8000109c:	00005097          	auipc	ra,0x5
    800010a0:	1e2080e7          	jalr	482(ra) # 8000627e <acquire>
    if(p->state == UNUSED) {
    800010a4:	4c9c                	lw	a5,24(s1)
    800010a6:	cf81                	beqz	a5,800010be <allocproc+0x40>
      release(&p->lock);
    800010a8:	8526                	mv	a0,s1
    800010aa:	00005097          	auipc	ra,0x5
    800010ae:	288080e7          	jalr	648(ra) # 80006332 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b2:	18848493          	addi	s1,s1,392
    800010b6:	ff2492e3          	bne	s1,s2,8000109a <allocproc+0x1c>
  return 0;
    800010ba:	4481                	li	s1,0
    800010bc:	a88d                	j	8000112e <allocproc+0xb0>
  p->pid = allocpid();
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	e12080e7          	jalr	-494(ra) # 80000ed0 <allocpid>
    800010c6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010c8:	4785                	li	a5,1
    800010ca:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010cc:	fffff097          	auipc	ra,0xfffff
    800010d0:	04e080e7          	jalr	78(ra) # 8000011a <kalloc>
    800010d4:	892a                	mv	s2,a0
    800010d6:	eca8                	sd	a0,88(s1)
    800010d8:	c135                	beqz	a0,8000113c <allocproc+0xbe>
  if((p->copy_trapframe = (struct trapframe *)kalloc()) == 0){
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	040080e7          	jalr	64(ra) # 8000011a <kalloc>
    800010e2:	892a                	mv	s2,a0
    800010e4:	18a4b023          	sd	a0,384(s1)
    800010e8:	c535                	beqz	a0,80001154 <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	e2a080e7          	jalr	-470(ra) # 80000f16 <proc_pagetable>
    800010f4:	892a                	mv	s2,a0
    800010f6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f8:	c935                	beqz	a0,8000116c <allocproc+0xee>
  memset(&p->context, 0, sizeof(p->context));
    800010fa:	07000613          	li	a2,112
    800010fe:	4581                	li	a1,0
    80001100:	06048513          	addi	a0,s1,96
    80001104:	fffff097          	auipc	ra,0xfffff
    80001108:	076080e7          	jalr	118(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000110c:	00000797          	auipc	a5,0x0
    80001110:	d7e78793          	addi	a5,a5,-642 # 80000e8a <forkret>
    80001114:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001116:	60bc                	ld	a5,64(s1)
    80001118:	6705                	lui	a4,0x1
    8000111a:	97ba                	add	a5,a5,a4
    8000111c:	f4bc                	sd	a5,104(s1)
  p->ticks = 0;
    8000111e:	1604a423          	sw	zero,360(s1)
  p->alarm_past = 0;
    80001122:	1604a623          	sw	zero,364(s1)
  p->handler = (void*)0;
    80001126:	1604b823          	sd	zero,368(s1)
  p->alarm_sigreturn = 0;
    8000112a:	1604ac23          	sw	zero,376(s1)
}
    8000112e:	8526                	mv	a0,s1
    80001130:	60e2                	ld	ra,24(sp)
    80001132:	6442                	ld	s0,16(sp)
    80001134:	64a2                	ld	s1,8(sp)
    80001136:	6902                	ld	s2,0(sp)
    80001138:	6105                	addi	sp,sp,32
    8000113a:	8082                	ret
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ec6080e7          	jalr	-314(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	1ea080e7          	jalr	490(ra) # 80006332 <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	bff1                	j	8000112e <allocproc+0xb0>
    freeproc(p);
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	eae080e7          	jalr	-338(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000115e:	8526                	mv	a0,s1
    80001160:	00005097          	auipc	ra,0x5
    80001164:	1d2080e7          	jalr	466(ra) # 80006332 <release>
    return 0;
    80001168:	84ca                	mv	s1,s2
    8000116a:	b7d1                	j	8000112e <allocproc+0xb0>
    freeproc(p);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	e96080e7          	jalr	-362(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001176:	8526                	mv	a0,s1
    80001178:	00005097          	auipc	ra,0x5
    8000117c:	1ba080e7          	jalr	442(ra) # 80006332 <release>
    return 0;
    80001180:	84ca                	mv	s1,s2
    80001182:	b775                	j	8000112e <allocproc+0xb0>

0000000080001184 <userinit>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	ef0080e7          	jalr	-272(ra) # 8000107e <allocproc>
    80001196:	84aa                	mv	s1,a0
  initproc = p;
    80001198:	00007797          	auipc	a5,0x7
    8000119c:	74a7bc23          	sd	a0,1880(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a0:	03400613          	li	a2,52
    800011a4:	00007597          	auipc	a1,0x7
    800011a8:	6dc58593          	addi	a1,a1,1756 # 80008880 <initcode>
    800011ac:	6928                	ld	a0,80(a0)
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	64e080e7          	jalr	1614(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    800011b6:	6785                	lui	a5,0x1
    800011b8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ba:	6cb8                	ld	a4,88(s1)
    800011bc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c0:	6cb8                	ld	a4,88(s1)
    800011c2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c4:	4641                	li	a2,16
    800011c6:	00007597          	auipc	a1,0x7
    800011ca:	fba58593          	addi	a1,a1,-70 # 80008180 <etext+0x180>
    800011ce:	15848513          	addi	a0,s1,344
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	0f0080e7          	jalr	240(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011da:	00007517          	auipc	a0,0x7
    800011de:	fb650513          	addi	a0,a0,-74 # 80008190 <etext+0x190>
    800011e2:	00002097          	auipc	ra,0x2
    800011e6:	24e080e7          	jalr	590(ra) # 80003430 <namei>
    800011ea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ee:	478d                	li	a5,3
    800011f0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00005097          	auipc	ra,0x5
    800011f8:	13e080e7          	jalr	318(ra) # 80006332 <release>
}
    800011fc:	60e2                	ld	ra,24(sp)
    800011fe:	6442                	ld	s0,16(sp)
    80001200:	64a2                	ld	s1,8(sp)
    80001202:	6105                	addi	sp,sp,32
    80001204:	8082                	ret

0000000080001206 <growproc>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	e04a                	sd	s2,0(sp)
    80001210:	1000                	addi	s0,sp,32
    80001212:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001214:	00000097          	auipc	ra,0x0
    80001218:	c3e080e7          	jalr	-962(ra) # 80000e52 <myproc>
    8000121c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000121e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001220:	01204c63          	bgtz	s2,80001238 <growproc+0x32>
  } else if(n < 0){
    80001224:	02094663          	bltz	s2,80001250 <growproc+0x4a>
  p->sz = sz;
    80001228:	e4ac                	sd	a1,72(s1)
  return 0;
    8000122a:	4501                	li	a0,0
}
    8000122c:	60e2                	ld	ra,24(sp)
    8000122e:	6442                	ld	s0,16(sp)
    80001230:	64a2                	ld	s1,8(sp)
    80001232:	6902                	ld	s2,0(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001238:	4691                	li	a3,4
    8000123a:	00b90633          	add	a2,s2,a1
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	676080e7          	jalr	1654(ra) # 800008b6 <uvmalloc>
    80001248:	85aa                	mv	a1,a0
    8000124a:	fd79                	bnez	a0,80001228 <growproc+0x22>
      return -1;
    8000124c:	557d                	li	a0,-1
    8000124e:	bff9                	j	8000122c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001250:	00b90633          	add	a2,s2,a1
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	618080e7          	jalr	1560(ra) # 8000086e <uvmdealloc>
    8000125e:	85aa                	mv	a1,a0
    80001260:	b7e1                	j	80001228 <growproc+0x22>

0000000080001262 <fork>:
{
    80001262:	7139                	addi	sp,sp,-64
    80001264:	fc06                	sd	ra,56(sp)
    80001266:	f822                	sd	s0,48(sp)
    80001268:	f426                	sd	s1,40(sp)
    8000126a:	f04a                	sd	s2,32(sp)
    8000126c:	ec4e                	sd	s3,24(sp)
    8000126e:	e852                	sd	s4,16(sp)
    80001270:	e456                	sd	s5,8(sp)
    80001272:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001274:	00000097          	auipc	ra,0x0
    80001278:	bde080e7          	jalr	-1058(ra) # 80000e52 <myproc>
    8000127c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	e00080e7          	jalr	-512(ra) # 8000107e <allocproc>
    80001286:	10050c63          	beqz	a0,8000139e <fork+0x13c>
    8000128a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128c:	048ab603          	ld	a2,72(s5)
    80001290:	692c                	ld	a1,80(a0)
    80001292:	050ab503          	ld	a0,80(s5)
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	778080e7          	jalr	1912(ra) # 80000a0e <uvmcopy>
    8000129e:	04054863          	bltz	a0,800012ee <fork+0x8c>
  np->sz = p->sz;
    800012a2:	048ab783          	ld	a5,72(s5)
    800012a6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012aa:	058ab683          	ld	a3,88(s5)
    800012ae:	87b6                	mv	a5,a3
    800012b0:	058a3703          	ld	a4,88(s4)
    800012b4:	12068693          	addi	a3,a3,288
    800012b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012bc:	6788                	ld	a0,8(a5)
    800012be:	6b8c                	ld	a1,16(a5)
    800012c0:	6f90                	ld	a2,24(a5)
    800012c2:	01073023          	sd	a6,0(a4)
    800012c6:	e708                	sd	a0,8(a4)
    800012c8:	eb0c                	sd	a1,16(a4)
    800012ca:	ef10                	sd	a2,24(a4)
    800012cc:	02078793          	addi	a5,a5,32
    800012d0:	02070713          	addi	a4,a4,32
    800012d4:	fed792e3          	bne	a5,a3,800012b8 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d8:	058a3783          	ld	a5,88(s4)
    800012dc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012e0:	0d0a8493          	addi	s1,s5,208
    800012e4:	0d0a0913          	addi	s2,s4,208
    800012e8:	150a8993          	addi	s3,s5,336
    800012ec:	a00d                	j	8000130e <fork+0xac>
    freeproc(np);
    800012ee:	8552                	mv	a0,s4
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d14080e7          	jalr	-748(ra) # 80001004 <freeproc>
    release(&np->lock);
    800012f8:	8552                	mv	a0,s4
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	038080e7          	jalr	56(ra) # 80006332 <release>
    return -1;
    80001302:	597d                	li	s2,-1
    80001304:	a059                	j	8000138a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	0921                	addi	s2,s2,8
    8000130a:	01348b63          	beq	s1,s3,80001320 <fork+0xbe>
    if(p->ofile[i])
    8000130e:	6088                	ld	a0,0(s1)
    80001310:	d97d                	beqz	a0,80001306 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001312:	00002097          	auipc	ra,0x2
    80001316:	790080e7          	jalr	1936(ra) # 80003aa2 <filedup>
    8000131a:	00a93023          	sd	a0,0(s2)
    8000131e:	b7e5                	j	80001306 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001320:	150ab503          	ld	a0,336(s5)
    80001324:	00002097          	auipc	ra,0x2
    80001328:	928080e7          	jalr	-1752(ra) # 80002c4c <idup>
    8000132c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001330:	4641                	li	a2,16
    80001332:	158a8593          	addi	a1,s5,344
    80001336:	158a0513          	addi	a0,s4,344
    8000133a:	fffff097          	auipc	ra,0xfffff
    8000133e:	f88080e7          	jalr	-120(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001342:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001346:	8552                	mv	a0,s4
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	fea080e7          	jalr	-22(ra) # 80006332 <release>
  acquire(&wait_lock);
    80001350:	00007497          	auipc	s1,0x7
    80001354:	5f848493          	addi	s1,s1,1528 # 80008948 <wait_lock>
    80001358:	8526                	mv	a0,s1
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	f24080e7          	jalr	-220(ra) # 8000627e <acquire>
  np->parent = p;
    80001362:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001366:	8526                	mv	a0,s1
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	fca080e7          	jalr	-54(ra) # 80006332 <release>
  acquire(&np->lock);
    80001370:	8552                	mv	a0,s4
    80001372:	00005097          	auipc	ra,0x5
    80001376:	f0c080e7          	jalr	-244(ra) # 8000627e <acquire>
  np->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001380:	8552                	mv	a0,s4
    80001382:	00005097          	auipc	ra,0x5
    80001386:	fb0080e7          	jalr	-80(ra) # 80006332 <release>
}
    8000138a:	854a                	mv	a0,s2
    8000138c:	70e2                	ld	ra,56(sp)
    8000138e:	7442                	ld	s0,48(sp)
    80001390:	74a2                	ld	s1,40(sp)
    80001392:	7902                	ld	s2,32(sp)
    80001394:	69e2                	ld	s3,24(sp)
    80001396:	6a42                	ld	s4,16(sp)
    80001398:	6aa2                	ld	s5,8(sp)
    8000139a:	6121                	addi	sp,sp,64
    8000139c:	8082                	ret
    return -1;
    8000139e:	597d                	li	s2,-1
    800013a0:	b7ed                	j	8000138a <fork+0x128>

00000000800013a2 <scheduler>:
{
    800013a2:	7139                	addi	sp,sp,-64
    800013a4:	fc06                	sd	ra,56(sp)
    800013a6:	f822                	sd	s0,48(sp)
    800013a8:	f426                	sd	s1,40(sp)
    800013aa:	f04a                	sd	s2,32(sp)
    800013ac:	ec4e                	sd	s3,24(sp)
    800013ae:	e852                	sd	s4,16(sp)
    800013b0:	e456                	sd	s5,8(sp)
    800013b2:	e05a                	sd	s6,0(sp)
    800013b4:	0080                	addi	s0,sp,64
    800013b6:	8792                	mv	a5,tp
  int id = r_tp();
    800013b8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ba:	00779a93          	slli	s5,a5,0x7
    800013be:	00007717          	auipc	a4,0x7
    800013c2:	57270713          	addi	a4,a4,1394 # 80008930 <pid_lock>
    800013c6:	9756                	add	a4,a4,s5
    800013c8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013cc:	00007717          	auipc	a4,0x7
    800013d0:	59c70713          	addi	a4,a4,1436 # 80008968 <cpus+0x8>
    800013d4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d6:	498d                	li	s3,3
        p->state = RUNNING;
    800013d8:	4b11                	li	s6,4
        c->proc = p;
    800013da:	079e                	slli	a5,a5,0x7
    800013dc:	00007a17          	auipc	s4,0x7
    800013e0:	554a0a13          	addi	s4,s4,1364 # 80008930 <pid_lock>
    800013e4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	0000e917          	auipc	s2,0xe
    800013ea:	b7a90913          	addi	s2,s2,-1158 # 8000ef60 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f6:	10079073          	csrw	sstatus,a5
    800013fa:	00008497          	auipc	s1,0x8
    800013fe:	96648493          	addi	s1,s1,-1690 # 80008d60 <proc>
    80001402:	a811                	j	80001416 <scheduler+0x74>
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	f2c080e7          	jalr	-212(ra) # 80006332 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	18848493          	addi	s1,s1,392
    80001412:	fd248ee3          	beq	s1,s2,800013ee <scheduler+0x4c>
      acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	e66080e7          	jalr	-410(ra) # 8000627e <acquire>
      if(p->state == RUNNABLE) {
    80001420:	4c9c                	lw	a5,24(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <scheduler+0x62>
        p->state = RUNNING;
    80001426:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000142a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142e:	06048593          	addi	a1,s1,96
    80001432:	8556                	mv	a0,s5
    80001434:	00000097          	auipc	ra,0x0
    80001438:	714080e7          	jalr	1812(ra) # 80001b48 <swtch>
        c->proc = 0;
    8000143c:	020a3823          	sd	zero,48(s4)
    80001440:	b7d1                	j	80001404 <scheduler+0x62>

0000000080001442 <sched>:
{
    80001442:	7179                	addi	sp,sp,-48
    80001444:	f406                	sd	ra,40(sp)
    80001446:	f022                	sd	s0,32(sp)
    80001448:	ec26                	sd	s1,24(sp)
    8000144a:	e84a                	sd	s2,16(sp)
    8000144c:	e44e                	sd	s3,8(sp)
    8000144e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001450:	00000097          	auipc	ra,0x0
    80001454:	a02080e7          	jalr	-1534(ra) # 80000e52 <myproc>
    80001458:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	daa080e7          	jalr	-598(ra) # 80006204 <holding>
    80001462:	c93d                	beqz	a0,800014d8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	00007717          	auipc	a4,0x7
    8000146e:	4c670713          	addi	a4,a4,1222 # 80008930 <pid_lock>
    80001472:	97ba                	add	a5,a5,a4
    80001474:	0a87a703          	lw	a4,168(a5)
    80001478:	4785                	li	a5,1
    8000147a:	06f71763          	bne	a4,a5,800014e8 <sched+0xa6>
  if(p->state == RUNNING)
    8000147e:	4c98                	lw	a4,24(s1)
    80001480:	4791                	li	a5,4
    80001482:	06f70b63          	beq	a4,a5,800014f8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001486:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148c:	efb5                	bnez	a5,80001508 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001490:	00007917          	auipc	s2,0x7
    80001494:	4a090913          	addi	s2,s2,1184 # 80008930 <pid_lock>
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	97ca                	add	a5,a5,s2
    8000149e:	0ac7a983          	lw	s3,172(a5)
    800014a2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	00007597          	auipc	a1,0x7
    800014ac:	4c058593          	addi	a1,a1,1216 # 80008968 <cpus+0x8>
    800014b0:	95be                	add	a1,a1,a5
    800014b2:	06048513          	addi	a0,s1,96
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	692080e7          	jalr	1682(ra) # 80001b48 <swtch>
    800014be:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	993e                	add	s2,s2,a5
    800014c6:	0b392623          	sw	s3,172(s2)
}
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6145                	addi	sp,sp,48
    800014d6:	8082                	ret
    panic("sched p->lock");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	cc050513          	addi	a0,a0,-832 # 80008198 <etext+0x198>
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	890080e7          	jalr	-1904(ra) # 80005d70 <panic>
    panic("sched locks");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	cc050513          	addi	a0,a0,-832 # 800081a8 <etext+0x1a8>
    800014f0:	00005097          	auipc	ra,0x5
    800014f4:	880080e7          	jalr	-1920(ra) # 80005d70 <panic>
    panic("sched running");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	cc050513          	addi	a0,a0,-832 # 800081b8 <etext+0x1b8>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	870080e7          	jalr	-1936(ra) # 80005d70 <panic>
    panic("sched interruptible");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	cc050513          	addi	a0,a0,-832 # 800081c8 <etext+0x1c8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	860080e7          	jalr	-1952(ra) # 80005d70 <panic>

0000000080001518 <yield>:
{
    80001518:	1101                	addi	sp,sp,-32
    8000151a:	ec06                	sd	ra,24(sp)
    8000151c:	e822                	sd	s0,16(sp)
    8000151e:	e426                	sd	s1,8(sp)
    80001520:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001522:	00000097          	auipc	ra,0x0
    80001526:	930080e7          	jalr	-1744(ra) # 80000e52 <myproc>
    8000152a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	d52080e7          	jalr	-686(ra) # 8000627e <acquire>
  p->state = RUNNABLE;
    80001534:	478d                	li	a5,3
    80001536:	cc9c                	sw	a5,24(s1)
  sched();
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	f0a080e7          	jalr	-246(ra) # 80001442 <sched>
  release(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00005097          	auipc	ra,0x5
    80001546:	df0080e7          	jalr	-528(ra) # 80006332 <release>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret

0000000080001554 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001554:	7179                	addi	sp,sp,-48
    80001556:	f406                	sd	ra,40(sp)
    80001558:	f022                	sd	s0,32(sp)
    8000155a:	ec26                	sd	s1,24(sp)
    8000155c:	e84a                	sd	s2,16(sp)
    8000155e:	e44e                	sd	s3,8(sp)
    80001560:	1800                	addi	s0,sp,48
    80001562:	89aa                	mv	s3,a0
    80001564:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	8ec080e7          	jalr	-1812(ra) # 80000e52 <myproc>
    8000156e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	d0e080e7          	jalr	-754(ra) # 8000627e <acquire>
  release(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	db8080e7          	jalr	-584(ra) # 80006332 <release>

  // Go to sleep.
  p->chan = chan;
    80001582:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001586:	4789                	li	a5,2
    80001588:	cc9c                	sw	a5,24(s1)

  sched();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	eb8080e7          	jalr	-328(ra) # 80001442 <sched>

  // Tidy up.
  p->chan = 0;
    80001592:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	d9a080e7          	jalr	-614(ra) # 80006332 <release>
  acquire(lk);
    800015a0:	854a                	mv	a0,s2
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	cdc080e7          	jalr	-804(ra) # 8000627e <acquire>
}
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	64e2                	ld	s1,24(sp)
    800015b0:	6942                	ld	s2,16(sp)
    800015b2:	69a2                	ld	s3,8(sp)
    800015b4:	6145                	addi	sp,sp,48
    800015b6:	8082                	ret

00000000800015b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015b8:	7139                	addi	sp,sp,-64
    800015ba:	fc06                	sd	ra,56(sp)
    800015bc:	f822                	sd	s0,48(sp)
    800015be:	f426                	sd	s1,40(sp)
    800015c0:	f04a                	sd	s2,32(sp)
    800015c2:	ec4e                	sd	s3,24(sp)
    800015c4:	e852                	sd	s4,16(sp)
    800015c6:	e456                	sd	s5,8(sp)
    800015c8:	0080                	addi	s0,sp,64
    800015ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015cc:	00007497          	auipc	s1,0x7
    800015d0:	79448493          	addi	s1,s1,1940 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d8:	0000e917          	auipc	s2,0xe
    800015dc:	98890913          	addi	s2,s2,-1656 # 8000ef60 <tickslock>
    800015e0:	a811                	j	800015f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00005097          	auipc	ra,0x5
    800015e8:	d4e080e7          	jalr	-690(ra) # 80006332 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ec:	18848493          	addi	s1,s1,392
    800015f0:	03248663          	beq	s1,s2,8000161c <wakeup+0x64>
    if(p != myproc()){
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	85e080e7          	jalr	-1954(ra) # 80000e52 <myproc>
    800015fc:	fea488e3          	beq	s1,a0,800015ec <wakeup+0x34>
      acquire(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	00005097          	auipc	ra,0x5
    80001606:	c7c080e7          	jalr	-900(ra) # 8000627e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000160a:	4c9c                	lw	a5,24(s1)
    8000160c:	fd379be3          	bne	a5,s3,800015e2 <wakeup+0x2a>
    80001610:	709c                	ld	a5,32(s1)
    80001612:	fd4798e3          	bne	a5,s4,800015e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001616:	0154ac23          	sw	s5,24(s1)
    8000161a:	b7e1                	j	800015e2 <wakeup+0x2a>
    }
  }
}
    8000161c:	70e2                	ld	ra,56(sp)
    8000161e:	7442                	ld	s0,48(sp)
    80001620:	74a2                	ld	s1,40(sp)
    80001622:	7902                	ld	s2,32(sp)
    80001624:	69e2                	ld	s3,24(sp)
    80001626:	6a42                	ld	s4,16(sp)
    80001628:	6aa2                	ld	s5,8(sp)
    8000162a:	6121                	addi	sp,sp,64
    8000162c:	8082                	ret

000000008000162e <reparent>:
{
    8000162e:	7179                	addi	sp,sp,-48
    80001630:	f406                	sd	ra,40(sp)
    80001632:	f022                	sd	s0,32(sp)
    80001634:	ec26                	sd	s1,24(sp)
    80001636:	e84a                	sd	s2,16(sp)
    80001638:	e44e                	sd	s3,8(sp)
    8000163a:	e052                	sd	s4,0(sp)
    8000163c:	1800                	addi	s0,sp,48
    8000163e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001640:	00007497          	auipc	s1,0x7
    80001644:	72048493          	addi	s1,s1,1824 # 80008d60 <proc>
      pp->parent = initproc;
    80001648:	00007a17          	auipc	s4,0x7
    8000164c:	2a8a0a13          	addi	s4,s4,680 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001650:	0000e997          	auipc	s3,0xe
    80001654:	91098993          	addi	s3,s3,-1776 # 8000ef60 <tickslock>
    80001658:	a029                	j	80001662 <reparent+0x34>
    8000165a:	18848493          	addi	s1,s1,392
    8000165e:	01348d63          	beq	s1,s3,80001678 <reparent+0x4a>
    if(pp->parent == p){
    80001662:	7c9c                	ld	a5,56(s1)
    80001664:	ff279be3          	bne	a5,s2,8000165a <reparent+0x2c>
      pp->parent = initproc;
    80001668:	000a3503          	ld	a0,0(s4)
    8000166c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	f4a080e7          	jalr	-182(ra) # 800015b8 <wakeup>
    80001676:	b7d5                	j	8000165a <reparent+0x2c>
}
    80001678:	70a2                	ld	ra,40(sp)
    8000167a:	7402                	ld	s0,32(sp)
    8000167c:	64e2                	ld	s1,24(sp)
    8000167e:	6942                	ld	s2,16(sp)
    80001680:	69a2                	ld	s3,8(sp)
    80001682:	6a02                	ld	s4,0(sp)
    80001684:	6145                	addi	sp,sp,48
    80001686:	8082                	ret

0000000080001688 <exit>:
{
    80001688:	7179                	addi	sp,sp,-48
    8000168a:	f406                	sd	ra,40(sp)
    8000168c:	f022                	sd	s0,32(sp)
    8000168e:	ec26                	sd	s1,24(sp)
    80001690:	e84a                	sd	s2,16(sp)
    80001692:	e44e                	sd	s3,8(sp)
    80001694:	e052                	sd	s4,0(sp)
    80001696:	1800                	addi	s0,sp,48
    80001698:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000169a:	fffff097          	auipc	ra,0xfffff
    8000169e:	7b8080e7          	jalr	1976(ra) # 80000e52 <myproc>
    800016a2:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a4:	00007797          	auipc	a5,0x7
    800016a8:	24c7b783          	ld	a5,588(a5) # 800088f0 <initproc>
    800016ac:	0d050493          	addi	s1,a0,208
    800016b0:	15050913          	addi	s2,a0,336
    800016b4:	02a79363          	bne	a5,a0,800016da <exit+0x52>
    panic("init exiting");
    800016b8:	00007517          	auipc	a0,0x7
    800016bc:	b2850513          	addi	a0,a0,-1240 # 800081e0 <etext+0x1e0>
    800016c0:	00004097          	auipc	ra,0x4
    800016c4:	6b0080e7          	jalr	1712(ra) # 80005d70 <panic>
      fileclose(f);
    800016c8:	00002097          	auipc	ra,0x2
    800016cc:	42c080e7          	jalr	1068(ra) # 80003af4 <fileclose>
      p->ofile[fd] = 0;
    800016d0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d4:	04a1                	addi	s1,s1,8
    800016d6:	01248563          	beq	s1,s2,800016e0 <exit+0x58>
    if(p->ofile[fd]){
    800016da:	6088                	ld	a0,0(s1)
    800016dc:	f575                	bnez	a0,800016c8 <exit+0x40>
    800016de:	bfdd                	j	800016d4 <exit+0x4c>
  begin_op();
    800016e0:	00002097          	auipc	ra,0x2
    800016e4:	f50080e7          	jalr	-176(ra) # 80003630 <begin_op>
  iput(p->cwd);
    800016e8:	1509b503          	ld	a0,336(s3)
    800016ec:	00001097          	auipc	ra,0x1
    800016f0:	758080e7          	jalr	1880(ra) # 80002e44 <iput>
  end_op();
    800016f4:	00002097          	auipc	ra,0x2
    800016f8:	fb6080e7          	jalr	-74(ra) # 800036aa <end_op>
  p->cwd = 0;
    800016fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001700:	00007497          	auipc	s1,0x7
    80001704:	24848493          	addi	s1,s1,584 # 80008948 <wait_lock>
    80001708:	8526                	mv	a0,s1
    8000170a:	00005097          	auipc	ra,0x5
    8000170e:	b74080e7          	jalr	-1164(ra) # 8000627e <acquire>
  reparent(p);
    80001712:	854e                	mv	a0,s3
    80001714:	00000097          	auipc	ra,0x0
    80001718:	f1a080e7          	jalr	-230(ra) # 8000162e <reparent>
  wakeup(p->parent);
    8000171c:	0389b503          	ld	a0,56(s3)
    80001720:	00000097          	auipc	ra,0x0
    80001724:	e98080e7          	jalr	-360(ra) # 800015b8 <wakeup>
  acquire(&p->lock);
    80001728:	854e                	mv	a0,s3
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	b54080e7          	jalr	-1196(ra) # 8000627e <acquire>
  p->xstate = status;
    80001732:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001736:	4795                	li	a5,5
    80001738:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	bf4080e7          	jalr	-1036(ra) # 80006332 <release>
  sched();
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	cfc080e7          	jalr	-772(ra) # 80001442 <sched>
  panic("zombie exit");
    8000174e:	00007517          	auipc	a0,0x7
    80001752:	aa250513          	addi	a0,a0,-1374 # 800081f0 <etext+0x1f0>
    80001756:	00004097          	auipc	ra,0x4
    8000175a:	61a080e7          	jalr	1562(ra) # 80005d70 <panic>

000000008000175e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000176e:	00007497          	auipc	s1,0x7
    80001772:	5f248493          	addi	s1,s1,1522 # 80008d60 <proc>
    80001776:	0000d997          	auipc	s3,0xd
    8000177a:	7ea98993          	addi	s3,s3,2026 # 8000ef60 <tickslock>
    acquire(&p->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	afe080e7          	jalr	-1282(ra) # 8000627e <acquire>
    if(p->pid == pid){
    80001788:	589c                	lw	a5,48(s1)
    8000178a:	01278d63          	beq	a5,s2,800017a4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	ba2080e7          	jalr	-1118(ra) # 80006332 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001798:	18848493          	addi	s1,s1,392
    8000179c:	ff3491e3          	bne	s1,s3,8000177e <kill+0x20>
  }
  return -1;
    800017a0:	557d                	li	a0,-1
    800017a2:	a829                	j	800017bc <kill+0x5e>
      p->killed = 1;
    800017a4:	4785                	li	a5,1
    800017a6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017a8:	4c98                	lw	a4,24(s1)
    800017aa:	4789                	li	a5,2
    800017ac:	00f70f63          	beq	a4,a5,800017ca <kill+0x6c>
      release(&p->lock);
    800017b0:	8526                	mv	a0,s1
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	b80080e7          	jalr	-1152(ra) # 80006332 <release>
      return 0;
    800017ba:	4501                	li	a0,0
}
    800017bc:	70a2                	ld	ra,40(sp)
    800017be:	7402                	ld	s0,32(sp)
    800017c0:	64e2                	ld	s1,24(sp)
    800017c2:	6942                	ld	s2,16(sp)
    800017c4:	69a2                	ld	s3,8(sp)
    800017c6:	6145                	addi	sp,sp,48
    800017c8:	8082                	ret
        p->state = RUNNABLE;
    800017ca:	478d                	li	a5,3
    800017cc:	cc9c                	sw	a5,24(s1)
    800017ce:	b7cd                	j	800017b0 <kill+0x52>

00000000800017d0 <setkilled>:

void
setkilled(struct proc *p)
{
    800017d0:	1101                	addi	sp,sp,-32
    800017d2:	ec06                	sd	ra,24(sp)
    800017d4:	e822                	sd	s0,16(sp)
    800017d6:	e426                	sd	s1,8(sp)
    800017d8:	1000                	addi	s0,sp,32
    800017da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	aa2080e7          	jalr	-1374(ra) # 8000627e <acquire>
  p->killed = 1;
    800017e4:	4785                	li	a5,1
    800017e6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017e8:	8526                	mv	a0,s1
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	b48080e7          	jalr	-1208(ra) # 80006332 <release>
}
    800017f2:	60e2                	ld	ra,24(sp)
    800017f4:	6442                	ld	s0,16(sp)
    800017f6:	64a2                	ld	s1,8(sp)
    800017f8:	6105                	addi	sp,sp,32
    800017fa:	8082                	ret

00000000800017fc <killed>:

int
killed(struct proc *p)
{
    800017fc:	1101                	addi	sp,sp,-32
    800017fe:	ec06                	sd	ra,24(sp)
    80001800:	e822                	sd	s0,16(sp)
    80001802:	e426                	sd	s1,8(sp)
    80001804:	e04a                	sd	s2,0(sp)
    80001806:	1000                	addi	s0,sp,32
    80001808:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	a74080e7          	jalr	-1420(ra) # 8000627e <acquire>
  k = p->killed;
    80001812:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	b1a080e7          	jalr	-1254(ra) # 80006332 <release>
  return k;
}
    80001820:	854a                	mv	a0,s2
    80001822:	60e2                	ld	ra,24(sp)
    80001824:	6442                	ld	s0,16(sp)
    80001826:	64a2                	ld	s1,8(sp)
    80001828:	6902                	ld	s2,0(sp)
    8000182a:	6105                	addi	sp,sp,32
    8000182c:	8082                	ret

000000008000182e <wait>:
{
    8000182e:	715d                	addi	sp,sp,-80
    80001830:	e486                	sd	ra,72(sp)
    80001832:	e0a2                	sd	s0,64(sp)
    80001834:	fc26                	sd	s1,56(sp)
    80001836:	f84a                	sd	s2,48(sp)
    80001838:	f44e                	sd	s3,40(sp)
    8000183a:	f052                	sd	s4,32(sp)
    8000183c:	ec56                	sd	s5,24(sp)
    8000183e:	e85a                	sd	s6,16(sp)
    80001840:	e45e                	sd	s7,8(sp)
    80001842:	e062                	sd	s8,0(sp)
    80001844:	0880                	addi	s0,sp,80
    80001846:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	60a080e7          	jalr	1546(ra) # 80000e52 <myproc>
    80001850:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001852:	00007517          	auipc	a0,0x7
    80001856:	0f650513          	addi	a0,a0,246 # 80008948 <wait_lock>
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	a24080e7          	jalr	-1500(ra) # 8000627e <acquire>
    havekids = 0;
    80001862:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001864:	4a15                	li	s4,5
        havekids = 1;
    80001866:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001868:	0000d997          	auipc	s3,0xd
    8000186c:	6f898993          	addi	s3,s3,1784 # 8000ef60 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001870:	00007c17          	auipc	s8,0x7
    80001874:	0d8c0c13          	addi	s8,s8,216 # 80008948 <wait_lock>
    80001878:	a0d1                	j	8000193c <wait+0x10e>
          pid = pp->pid;
    8000187a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000187e:	000b0e63          	beqz	s6,8000189a <wait+0x6c>
    80001882:	4691                	li	a3,4
    80001884:	02c48613          	addi	a2,s1,44
    80001888:	85da                	mv	a1,s6
    8000188a:	05093503          	ld	a0,80(s2)
    8000188e:	fffff097          	auipc	ra,0xfffff
    80001892:	284080e7          	jalr	644(ra) # 80000b12 <copyout>
    80001896:	04054163          	bltz	a0,800018d8 <wait+0xaa>
          freeproc(pp);
    8000189a:	8526                	mv	a0,s1
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	768080e7          	jalr	1896(ra) # 80001004 <freeproc>
          release(&pp->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	a8c080e7          	jalr	-1396(ra) # 80006332 <release>
          release(&wait_lock);
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	09a50513          	addi	a0,a0,154 # 80008948 <wait_lock>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	a7c080e7          	jalr	-1412(ra) # 80006332 <release>
}
    800018be:	854e                	mv	a0,s3
    800018c0:	60a6                	ld	ra,72(sp)
    800018c2:	6406                	ld	s0,64(sp)
    800018c4:	74e2                	ld	s1,56(sp)
    800018c6:	7942                	ld	s2,48(sp)
    800018c8:	79a2                	ld	s3,40(sp)
    800018ca:	7a02                	ld	s4,32(sp)
    800018cc:	6ae2                	ld	s5,24(sp)
    800018ce:	6b42                	ld	s6,16(sp)
    800018d0:	6ba2                	ld	s7,8(sp)
    800018d2:	6c02                	ld	s8,0(sp)
    800018d4:	6161                	addi	sp,sp,80
    800018d6:	8082                	ret
            release(&pp->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	a58080e7          	jalr	-1448(ra) # 80006332 <release>
            release(&wait_lock);
    800018e2:	00007517          	auipc	a0,0x7
    800018e6:	06650513          	addi	a0,a0,102 # 80008948 <wait_lock>
    800018ea:	00005097          	auipc	ra,0x5
    800018ee:	a48080e7          	jalr	-1464(ra) # 80006332 <release>
            return -1;
    800018f2:	59fd                	li	s3,-1
    800018f4:	b7e9                	j	800018be <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f6:	18848493          	addi	s1,s1,392
    800018fa:	03348463          	beq	s1,s3,80001922 <wait+0xf4>
      if(pp->parent == p){
    800018fe:	7c9c                	ld	a5,56(s1)
    80001900:	ff279be3          	bne	a5,s2,800018f6 <wait+0xc8>
        acquire(&pp->lock);
    80001904:	8526                	mv	a0,s1
    80001906:	00005097          	auipc	ra,0x5
    8000190a:	978080e7          	jalr	-1672(ra) # 8000627e <acquire>
        if(pp->state == ZOMBIE){
    8000190e:	4c9c                	lw	a5,24(s1)
    80001910:	f74785e3          	beq	a5,s4,8000187a <wait+0x4c>
        release(&pp->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	a1c080e7          	jalr	-1508(ra) # 80006332 <release>
        havekids = 1;
    8000191e:	8756                	mv	a4,s5
    80001920:	bfd9                	j	800018f6 <wait+0xc8>
    if(!havekids || killed(p)){
    80001922:	c31d                	beqz	a4,80001948 <wait+0x11a>
    80001924:	854a                	mv	a0,s2
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	ed6080e7          	jalr	-298(ra) # 800017fc <killed>
    8000192e:	ed09                	bnez	a0,80001948 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001930:	85e2                	mv	a1,s8
    80001932:	854a                	mv	a0,s2
    80001934:	00000097          	auipc	ra,0x0
    80001938:	c20080e7          	jalr	-992(ra) # 80001554 <sleep>
    havekids = 0;
    8000193c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193e:	00007497          	auipc	s1,0x7
    80001942:	42248493          	addi	s1,s1,1058 # 80008d60 <proc>
    80001946:	bf65                	j	800018fe <wait+0xd0>
      release(&wait_lock);
    80001948:	00007517          	auipc	a0,0x7
    8000194c:	00050513          	mv	a0,a0
    80001950:	00005097          	auipc	ra,0x5
    80001954:	9e2080e7          	jalr	-1566(ra) # 80006332 <release>
      return -1;
    80001958:	59fd                	li	s3,-1
    8000195a:	b795                	j	800018be <wait+0x90>

000000008000195c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000195c:	7179                	addi	sp,sp,-48
    8000195e:	f406                	sd	ra,40(sp)
    80001960:	f022                	sd	s0,32(sp)
    80001962:	ec26                	sd	s1,24(sp)
    80001964:	e84a                	sd	s2,16(sp)
    80001966:	e44e                	sd	s3,8(sp)
    80001968:	e052                	sd	s4,0(sp)
    8000196a:	1800                	addi	s0,sp,48
    8000196c:	84aa                	mv	s1,a0
    8000196e:	892e                	mv	s2,a1
    80001970:	89b2                	mv	s3,a2
    80001972:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	4de080e7          	jalr	1246(ra) # 80000e52 <myproc>
  if(user_dst){
    8000197c:	c08d                	beqz	s1,8000199e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197e:	86d2                	mv	a3,s4
    80001980:	864e                	mv	a2,s3
    80001982:	85ca                	mv	a1,s2
    80001984:	6928                	ld	a0,80(a0)
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	18c080e7          	jalr	396(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198e:	70a2                	ld	ra,40(sp)
    80001990:	7402                	ld	s0,32(sp)
    80001992:	64e2                	ld	s1,24(sp)
    80001994:	6942                	ld	s2,16(sp)
    80001996:	69a2                	ld	s3,8(sp)
    80001998:	6a02                	ld	s4,0(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
    memmove((char *)dst, src, len);
    8000199e:	000a061b          	sext.w	a2,s4
    800019a2:	85ce                	mv	a1,s3
    800019a4:	854a                	mv	a0,s2
    800019a6:	fffff097          	auipc	ra,0xfffff
    800019aa:	830080e7          	jalr	-2000(ra) # 800001d6 <memmove>
    return 0;
    800019ae:	8526                	mv	a0,s1
    800019b0:	bff9                	j	8000198e <either_copyout+0x32>

00000000800019b2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b2:	7179                	addi	sp,sp,-48
    800019b4:	f406                	sd	ra,40(sp)
    800019b6:	f022                	sd	s0,32(sp)
    800019b8:	ec26                	sd	s1,24(sp)
    800019ba:	e84a                	sd	s2,16(sp)
    800019bc:	e44e                	sd	s3,8(sp)
    800019be:	e052                	sd	s4,0(sp)
    800019c0:	1800                	addi	s0,sp,48
    800019c2:	892a                	mv	s2,a0
    800019c4:	84ae                	mv	s1,a1
    800019c6:	89b2                	mv	s3,a2
    800019c8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	488080e7          	jalr	1160(ra) # 80000e52 <myproc>
  if(user_src){
    800019d2:	c08d                	beqz	s1,800019f4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d4:	86d2                	mv	a3,s4
    800019d6:	864e                	mv	a2,s3
    800019d8:	85ca                	mv	a1,s2
    800019da:	6928                	ld	a0,80(a0)
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	1c2080e7          	jalr	450(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e4:	70a2                	ld	ra,40(sp)
    800019e6:	7402                	ld	s0,32(sp)
    800019e8:	64e2                	ld	s1,24(sp)
    800019ea:	6942                	ld	s2,16(sp)
    800019ec:	69a2                	ld	s3,8(sp)
    800019ee:	6a02                	ld	s4,0(sp)
    800019f0:	6145                	addi	sp,sp,48
    800019f2:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f4:	000a061b          	sext.w	a2,s4
    800019f8:	85ce                	mv	a1,s3
    800019fa:	854a                	mv	a0,s2
    800019fc:	ffffe097          	auipc	ra,0xffffe
    80001a00:	7da080e7          	jalr	2010(ra) # 800001d6 <memmove>
    return 0;
    80001a04:	8526                	mv	a0,s1
    80001a06:	bff9                	j	800019e4 <either_copyin+0x32>

0000000080001a08 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a08:	715d                	addi	sp,sp,-80
    80001a0a:	e486                	sd	ra,72(sp)
    80001a0c:	e0a2                	sd	s0,64(sp)
    80001a0e:	fc26                	sd	s1,56(sp)
    80001a10:	f84a                	sd	s2,48(sp)
    80001a12:	f44e                	sd	s3,40(sp)
    80001a14:	f052                	sd	s4,32(sp)
    80001a16:	ec56                	sd	s5,24(sp)
    80001a18:	e85a                	sd	s6,16(sp)
    80001a1a:	e45e                	sd	s7,8(sp)
    80001a1c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1e:	00006517          	auipc	a0,0x6
    80001a22:	62a50513          	addi	a0,a0,1578 # 80008048 <etext+0x48>
    80001a26:	00004097          	auipc	ra,0x4
    80001a2a:	39c080e7          	jalr	924(ra) # 80005dc2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2e:	00007497          	auipc	s1,0x7
    80001a32:	48a48493          	addi	s1,s1,1162 # 80008eb8 <proc+0x158>
    80001a36:	0000d917          	auipc	s2,0xd
    80001a3a:	68290913          	addi	s2,s2,1666 # 8000f0b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a40:	00006997          	auipc	s3,0x6
    80001a44:	7c098993          	addi	s3,s3,1984 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a48:	00006a97          	auipc	s5,0x6
    80001a4c:	7c0a8a93          	addi	s5,s5,1984 # 80008208 <etext+0x208>
    printf("\n");
    80001a50:	00006a17          	auipc	s4,0x6
    80001a54:	5f8a0a13          	addi	s4,s4,1528 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a58:	00006b97          	auipc	s7,0x6
    80001a5c:	7f0b8b93          	addi	s7,s7,2032 # 80008248 <states.0>
    80001a60:	a00d                	j	80001a82 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a62:	ed86a583          	lw	a1,-296(a3)
    80001a66:	8556                	mv	a0,s5
    80001a68:	00004097          	auipc	ra,0x4
    80001a6c:	35a080e7          	jalr	858(ra) # 80005dc2 <printf>
    printf("\n");
    80001a70:	8552                	mv	a0,s4
    80001a72:	00004097          	auipc	ra,0x4
    80001a76:	350080e7          	jalr	848(ra) # 80005dc2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a7a:	18848493          	addi	s1,s1,392
    80001a7e:	03248263          	beq	s1,s2,80001aa2 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a82:	86a6                	mv	a3,s1
    80001a84:	ec04a783          	lw	a5,-320(s1)
    80001a88:	dbed                	beqz	a5,80001a7a <procdump+0x72>
      state = "???";
    80001a8a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8c:	fcfb6be3          	bltu	s6,a5,80001a62 <procdump+0x5a>
    80001a90:	02079713          	slli	a4,a5,0x20
    80001a94:	01d75793          	srli	a5,a4,0x1d
    80001a98:	97de                	add	a5,a5,s7
    80001a9a:	6390                	ld	a2,0(a5)
    80001a9c:	f279                	bnez	a2,80001a62 <procdump+0x5a>
      state = "???";
    80001a9e:	864e                	mv	a2,s3
    80001aa0:	b7c9                	j	80001a62 <procdump+0x5a>
  }
}
    80001aa2:	60a6                	ld	ra,72(sp)
    80001aa4:	6406                	ld	s0,64(sp)
    80001aa6:	74e2                	ld	s1,56(sp)
    80001aa8:	7942                	ld	s2,48(sp)
    80001aaa:	79a2                	ld	s3,40(sp)
    80001aac:	7a02                	ld	s4,32(sp)
    80001aae:	6ae2                	ld	s5,24(sp)
    80001ab0:	6b42                	ld	s6,16(sp)
    80001ab2:	6ba2                	ld	s7,8(sp)
    80001ab4:	6161                	addi	sp,sp,80
    80001ab6:	8082                	ret

0000000080001ab8 <sigalarm>:

int
sigalarm(int ticks, void (*handler)(void)){/*TODO*/
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	addi	s0,sp,32
    80001ac4:	892a                	mv	s2,a0
    80001ac6:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	38a080e7          	jalr	906(ra) # 80000e52 <myproc>

  p->alarm_sigreturn = 0;
    80001ad0:	16052c23          	sw	zero,376(a0)
  p->ticks = ticks;
    80001ad4:	17252423          	sw	s2,360(a0)
  p->handler = handler;
    80001ad8:	16953823          	sd	s1,368(a0)
  p->alarm_past = 0;
    80001adc:	16052623          	sw	zero,364(a0)
  return 0;
}
    80001ae0:	4501                	li	a0,0
    80001ae2:	60e2                	ld	ra,24(sp)
    80001ae4:	6442                	ld	s0,16(sp)
    80001ae6:	64a2                	ld	s1,8(sp)
    80001ae8:	6902                	ld	s2,0(sp)
    80001aea:	6105                	addi	sp,sp,32
    80001aec:	8082                	ret

0000000080001aee <sigreturn>:



int
sigreturn(){/*TODO*/
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e406                	sd	ra,8(sp)
    80001af2:	e022                	sd	s0,0(sp)
    80001af4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af6:	fffff097          	auipc	ra,0xfffff
    80001afa:	35c080e7          	jalr	860(ra) # 80000e52 <myproc>
  if(p->alarm_sigreturn){
    80001afe:	17852783          	lw	a5,376(a0)
    80001b02:	cf8d                	beqz	a5,80001b3c <sigreturn+0x4e>
      p->alarm_sigreturn = 0;
    80001b04:	16052c23          	sw	zero,376(a0)
      p->alarm_past = 0;
    80001b08:	16052623          	sw	zero,364(a0)
      *(p->trapframe) = *(p->copy_trapframe);
    80001b0c:	18053683          	ld	a3,384(a0)
    80001b10:	87b6                	mv	a5,a3
    80001b12:	6d38                	ld	a4,88(a0)
    80001b14:	12068693          	addi	a3,a3,288
    80001b18:	0007b883          	ld	a7,0(a5)
    80001b1c:	0087b803          	ld	a6,8(a5)
    80001b20:	6b8c                	ld	a1,16(a5)
    80001b22:	6f90                	ld	a2,24(a5)
    80001b24:	01173023          	sd	a7,0(a4)
    80001b28:	01073423          	sd	a6,8(a4)
    80001b2c:	eb0c                	sd	a1,16(a4)
    80001b2e:	ef10                	sd	a2,24(a4)
    80001b30:	02078793          	addi	a5,a5,32
    80001b34:	02070713          	addi	a4,a4,32
    80001b38:	fed790e3          	bne	a5,a3,80001b18 <sigreturn+0x2a>
  }
  return p->trapframe->a0;
    80001b3c:	6d3c                	ld	a5,88(a0)
    80001b3e:	5ba8                	lw	a0,112(a5)
    80001b40:	60a2                	ld	ra,8(sp)
    80001b42:	6402                	ld	s0,0(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <swtch>:
    80001b48:	00153023          	sd	ra,0(a0)
    80001b4c:	00253423          	sd	sp,8(a0)
    80001b50:	e900                	sd	s0,16(a0)
    80001b52:	ed04                	sd	s1,24(a0)
    80001b54:	03253023          	sd	s2,32(a0)
    80001b58:	03353423          	sd	s3,40(a0)
    80001b5c:	03453823          	sd	s4,48(a0)
    80001b60:	03553c23          	sd	s5,56(a0)
    80001b64:	05653023          	sd	s6,64(a0)
    80001b68:	05753423          	sd	s7,72(a0)
    80001b6c:	05853823          	sd	s8,80(a0)
    80001b70:	05953c23          	sd	s9,88(a0)
    80001b74:	07a53023          	sd	s10,96(a0)
    80001b78:	07b53423          	sd	s11,104(a0)
    80001b7c:	0005b083          	ld	ra,0(a1)
    80001b80:	0085b103          	ld	sp,8(a1)
    80001b84:	6980                	ld	s0,16(a1)
    80001b86:	6d84                	ld	s1,24(a1)
    80001b88:	0205b903          	ld	s2,32(a1)
    80001b8c:	0285b983          	ld	s3,40(a1)
    80001b90:	0305ba03          	ld	s4,48(a1)
    80001b94:	0385ba83          	ld	s5,56(a1)
    80001b98:	0405bb03          	ld	s6,64(a1)
    80001b9c:	0485bb83          	ld	s7,72(a1)
    80001ba0:	0505bc03          	ld	s8,80(a1)
    80001ba4:	0585bc83          	ld	s9,88(a1)
    80001ba8:	0605bd03          	ld	s10,96(a1)
    80001bac:	0685bd83          	ld	s11,104(a1)
    80001bb0:	8082                	ret

0000000080001bb2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bb2:	1141                	addi	sp,sp,-16
    80001bb4:	e406                	sd	ra,8(sp)
    80001bb6:	e022                	sd	s0,0(sp)
    80001bb8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bba:	00006597          	auipc	a1,0x6
    80001bbe:	6be58593          	addi	a1,a1,1726 # 80008278 <states.0+0x30>
    80001bc2:	0000d517          	auipc	a0,0xd
    80001bc6:	39e50513          	addi	a0,a0,926 # 8000ef60 <tickslock>
    80001bca:	00004097          	auipc	ra,0x4
    80001bce:	624080e7          	jalr	1572(ra) # 800061ee <initlock>
}
    80001bd2:	60a2                	ld	ra,8(sp)
    80001bd4:	6402                	ld	s0,0(sp)
    80001bd6:	0141                	addi	sp,sp,16
    80001bd8:	8082                	ret

0000000080001bda <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bda:	1141                	addi	sp,sp,-16
    80001bdc:	e422                	sd	s0,8(sp)
    80001bde:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001be0:	00003797          	auipc	a5,0x3
    80001be4:	54078793          	addi	a5,a5,1344 # 80005120 <kernelvec>
    80001be8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bec:	6422                	ld	s0,8(sp)
    80001bee:	0141                	addi	sp,sp,16
    80001bf0:	8082                	ret

0000000080001bf2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bf2:	1141                	addi	sp,sp,-16
    80001bf4:	e406                	sd	ra,8(sp)
    80001bf6:	e022                	sd	s0,0(sp)
    80001bf8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	258080e7          	jalr	600(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c02:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c06:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c08:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c0c:	00005697          	auipc	a3,0x5
    80001c10:	3f468693          	addi	a3,a3,1012 # 80007000 <_trampoline>
    80001c14:	00005717          	auipc	a4,0x5
    80001c18:	3ec70713          	addi	a4,a4,1004 # 80007000 <_trampoline>
    80001c1c:	8f15                	sub	a4,a4,a3
    80001c1e:	040007b7          	lui	a5,0x4000
    80001c22:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c24:	07b2                	slli	a5,a5,0xc
    80001c26:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c28:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c2c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c2e:	18002673          	csrr	a2,satp
    80001c32:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c34:	6d30                	ld	a2,88(a0)
    80001c36:	6138                	ld	a4,64(a0)
    80001c38:	6585                	lui	a1,0x1
    80001c3a:	972e                	add	a4,a4,a1
    80001c3c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c3e:	6d38                	ld	a4,88(a0)
    80001c40:	00000617          	auipc	a2,0x0
    80001c44:	13460613          	addi	a2,a2,308 # 80001d74 <usertrap>
    80001c48:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c4a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c4c:	8612                	mv	a2,tp
    80001c4e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c50:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c54:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c58:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c5c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c60:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c62:	6f18                	ld	a4,24(a4)
    80001c64:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c68:	6928                	ld	a0,80(a0)
    80001c6a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c6c:	00005717          	auipc	a4,0x5
    80001c70:	43070713          	addi	a4,a4,1072 # 8000709c <userret>
    80001c74:	8f15                	sub	a4,a4,a3
    80001c76:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c78:	577d                	li	a4,-1
    80001c7a:	177e                	slli	a4,a4,0x3f
    80001c7c:	8d59                	or	a0,a0,a4
    80001c7e:	9782                	jalr	a5
}
    80001c80:	60a2                	ld	ra,8(sp)
    80001c82:	6402                	ld	s0,0(sp)
    80001c84:	0141                	addi	sp,sp,16
    80001c86:	8082                	ret

0000000080001c88 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c92:	0000d497          	auipc	s1,0xd
    80001c96:	2ce48493          	addi	s1,s1,718 # 8000ef60 <tickslock>
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	00004097          	auipc	ra,0x4
    80001ca0:	5e2080e7          	jalr	1506(ra) # 8000627e <acquire>
  ticks++;
    80001ca4:	00007517          	auipc	a0,0x7
    80001ca8:	c5450513          	addi	a0,a0,-940 # 800088f8 <ticks>
    80001cac:	411c                	lw	a5,0(a0)
    80001cae:	2785                	addiw	a5,a5,1
    80001cb0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	906080e7          	jalr	-1786(ra) # 800015b8 <wakeup>
  release(&tickslock);
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	676080e7          	jalr	1654(ra) # 80006332 <release>
}
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret

0000000080001cce <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cce:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cd2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001cd4:	0807df63          	bgez	a5,80001d72 <devintr+0xa4>
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001ce2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001ce6:	46a5                	li	a3,9
    80001ce8:	00d70d63          	beq	a4,a3,80001d02 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001cec:	577d                	li	a4,-1
    80001cee:	177e                	slli	a4,a4,0x3f
    80001cf0:	0705                	addi	a4,a4,1
    return 0;
    80001cf2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cf4:	04e78e63          	beq	a5,a4,80001d50 <devintr+0x82>
  }
}
    80001cf8:	60e2                	ld	ra,24(sp)
    80001cfa:	6442                	ld	s0,16(sp)
    80001cfc:	64a2                	ld	s1,8(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret
    int irq = plic_claim();
    80001d02:	00003097          	auipc	ra,0x3
    80001d06:	526080e7          	jalr	1318(ra) # 80005228 <plic_claim>
    80001d0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d0c:	47a9                	li	a5,10
    80001d0e:	02f50763          	beq	a0,a5,80001d3c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001d12:	4785                	li	a5,1
    80001d14:	02f50963          	beq	a0,a5,80001d46 <devintr+0x78>
    return 1;
    80001d18:	4505                	li	a0,1
    } else if(irq){
    80001d1a:	dcf9                	beqz	s1,80001cf8 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d1c:	85a6                	mv	a1,s1
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	56250513          	addi	a0,a0,1378 # 80008280 <states.0+0x38>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	09c080e7          	jalr	156(ra) # 80005dc2 <printf>
      plic_complete(irq);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	00003097          	auipc	ra,0x3
    80001d34:	51c080e7          	jalr	1308(ra) # 8000524c <plic_complete>
    return 1;
    80001d38:	4505                	li	a0,1
    80001d3a:	bf7d                	j	80001cf8 <devintr+0x2a>
      uartintr();
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	462080e7          	jalr	1122(ra) # 8000619e <uartintr>
    if(irq)
    80001d44:	b7ed                	j	80001d2e <devintr+0x60>
      virtio_disk_intr();
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	9cc080e7          	jalr	-1588(ra) # 80005712 <virtio_disk_intr>
    if(irq)
    80001d4e:	b7c5                	j	80001d2e <devintr+0x60>
    if(cpuid() == 0){
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	0d6080e7          	jalr	214(ra) # 80000e26 <cpuid>
    80001d58:	c901                	beqz	a0,80001d68 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d60:	14479073          	csrw	sip,a5
    return 2;
    80001d64:	4509                	li	a0,2
    80001d66:	bf49                	j	80001cf8 <devintr+0x2a>
      clockintr();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	f20080e7          	jalr	-224(ra) # 80001c88 <clockintr>
    80001d70:	b7ed                	j	80001d5a <devintr+0x8c>
}
    80001d72:	8082                	ret

0000000080001d74 <usertrap>:
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	e04a                	sd	s2,0(sp)
    80001d7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d80:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d84:	1007f793          	andi	a5,a5,256
    80001d88:	e3b1                	bnez	a5,80001dcc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d8a:	00003797          	auipc	a5,0x3
    80001d8e:	39678793          	addi	a5,a5,918 # 80005120 <kernelvec>
    80001d92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	0bc080e7          	jalr	188(ra) # 80000e52 <myproc>
    80001d9e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001da0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102773          	csrr	a4,sepc
    80001da6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dac:	47a1                	li	a5,8
    80001dae:	02f70763          	beq	a4,a5,80001ddc <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	f1c080e7          	jalr	-228(ra) # 80001cce <devintr>
    80001dba:	892a                	mv	s2,a0
    80001dbc:	c92d                	beqz	a0,80001e2e <usertrap+0xba>
  if(killed(p))
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	a3c080e7          	jalr	-1476(ra) # 800017fc <killed>
    80001dc8:	c555                	beqz	a0,80001e74 <usertrap+0x100>
    80001dca:	a045                	j	80001e6a <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	4d450513          	addi	a0,a0,1236 # 800082a0 <states.0+0x58>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	f9c080e7          	jalr	-100(ra) # 80005d70 <panic>
    if(killed(p))
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	a20080e7          	jalr	-1504(ra) # 800017fc <killed>
    80001de4:	ed1d                	bnez	a0,80001e22 <usertrap+0xae>
    p->trapframe->epc += 4;
    80001de6:	6cb8                	ld	a4,88(s1)
    80001de8:	6f1c                	ld	a5,24(a4)
    80001dea:	0791                	addi	a5,a5,4
    80001dec:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001df2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df6:	10079073          	csrw	sstatus,a5
    syscall();
    80001dfa:	00000097          	auipc	ra,0x0
    80001dfe:	332080e7          	jalr	818(ra) # 8000212c <syscall>
  if(killed(p))
    80001e02:	8526                	mv	a0,s1
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	9f8080e7          	jalr	-1544(ra) # 800017fc <killed>
    80001e0c:	ed31                	bnez	a0,80001e68 <usertrap+0xf4>
  usertrapret();
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	de4080e7          	jalr	-540(ra) # 80001bf2 <usertrapret>
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	64a2                	ld	s1,8(sp)
    80001e1c:	6902                	ld	s2,0(sp)
    80001e1e:	6105                	addi	sp,sp,32
    80001e20:	8082                	ret
      exit(-1);
    80001e22:	557d                	li	a0,-1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	864080e7          	jalr	-1948(ra) # 80001688 <exit>
    80001e2c:	bf6d                	j	80001de6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e32:	5890                	lw	a2,48(s1)
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	48c50513          	addi	a0,a0,1164 # 800082c0 <states.0+0x78>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	f86080e7          	jalr	-122(ra) # 80005dc2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e44:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e48:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	4a450513          	addi	a0,a0,1188 # 800082f0 <states.0+0xa8>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	f6e080e7          	jalr	-146(ra) # 80005dc2 <printf>
    setkilled(p);
    80001e5c:	8526                	mv	a0,s1
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	972080e7          	jalr	-1678(ra) # 800017d0 <setkilled>
    80001e66:	bf71                	j	80001e02 <usertrap+0x8e>
  if(killed(p))
    80001e68:	4901                	li	s2,0
    exit(-1);
    80001e6a:	557d                	li	a0,-1
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	81c080e7          	jalr	-2020(ra) # 80001688 <exit>
  if(which_dev == 2){ /*TODO*/
    80001e74:	4789                	li	a5,2
    80001e76:	f8f91ce3          	bne	s2,a5,80001e0e <usertrap+0x9a>
    if(!p->alarm_sigreturn && p->ticks && (++p->alarm_past == p->ticks)){
    80001e7a:	1784a783          	lw	a5,376(s1)
    80001e7e:	ef89                	bnez	a5,80001e98 <usertrap+0x124>
    80001e80:	1684a783          	lw	a5,360(s1)
    80001e84:	cb91                	beqz	a5,80001e98 <usertrap+0x124>
    80001e86:	16c4a703          	lw	a4,364(s1)
    80001e8a:	2705                	addiw	a4,a4,1
    80001e8c:	0007069b          	sext.w	a3,a4
    80001e90:	00d78963          	beq	a5,a3,80001ea2 <usertrap+0x12e>
    80001e94:	16e4a623          	sw	a4,364(s1)
    yield();
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	680080e7          	jalr	1664(ra) # 80001518 <yield>
    80001ea0:	b7bd                	j	80001e0e <usertrap+0x9a>
      p->alarm_past = 0;
    80001ea2:	1604a623          	sw	zero,364(s1)
      p->alarm_sigreturn = 1;
    80001ea6:	4785                	li	a5,1
    80001ea8:	16f4ac23          	sw	a5,376(s1)
      *(p->copy_trapframe) = *(p->trapframe);
    80001eac:	6cb4                	ld	a3,88(s1)
    80001eae:	87b6                	mv	a5,a3
    80001eb0:	1804b703          	ld	a4,384(s1)
    80001eb4:	12068693          	addi	a3,a3,288
    80001eb8:	0007b803          	ld	a6,0(a5)
    80001ebc:	6788                	ld	a0,8(a5)
    80001ebe:	6b8c                	ld	a1,16(a5)
    80001ec0:	6f90                	ld	a2,24(a5)
    80001ec2:	01073023          	sd	a6,0(a4)
    80001ec6:	e708                	sd	a0,8(a4)
    80001ec8:	eb0c                	sd	a1,16(a4)
    80001eca:	ef10                	sd	a2,24(a4)
    80001ecc:	02078793          	addi	a5,a5,32
    80001ed0:	02070713          	addi	a4,a4,32
    80001ed4:	fed792e3          	bne	a5,a3,80001eb8 <usertrap+0x144>
      p->trapframe->epc = (uint64)p->handler;
    80001ed8:	6cbc                	ld	a5,88(s1)
    80001eda:	1704b703          	ld	a4,368(s1)
    80001ede:	ef98                	sd	a4,24(a5)
    80001ee0:	bf65                	j	80001e98 <usertrap+0x124>

0000000080001ee2 <kerneltrap>:
{
    80001ee2:	7179                	addi	sp,sp,-48
    80001ee4:	f406                	sd	ra,40(sp)
    80001ee6:	f022                	sd	s0,32(sp)
    80001ee8:	ec26                	sd	s1,24(sp)
    80001eea:	e84a                	sd	s2,16(sp)
    80001eec:	e44e                	sd	s3,8(sp)
    80001eee:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001efc:	1004f793          	andi	a5,s1,256
    80001f00:	cb85                	beqz	a5,80001f30 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f02:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f06:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f08:	ef85                	bnez	a5,80001f40 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f0a:	00000097          	auipc	ra,0x0
    80001f0e:	dc4080e7          	jalr	-572(ra) # 80001cce <devintr>
    80001f12:	cd1d                	beqz	a0,80001f50 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f14:	4789                	li	a5,2
    80001f16:	06f50a63          	beq	a0,a5,80001f8a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f1a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f1e:	10049073          	csrw	sstatus,s1
}
    80001f22:	70a2                	ld	ra,40(sp)
    80001f24:	7402                	ld	s0,32(sp)
    80001f26:	64e2                	ld	s1,24(sp)
    80001f28:	6942                	ld	s2,16(sp)
    80001f2a:	69a2                	ld	s3,8(sp)
    80001f2c:	6145                	addi	sp,sp,48
    80001f2e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f30:	00006517          	auipc	a0,0x6
    80001f34:	3e050513          	addi	a0,a0,992 # 80008310 <states.0+0xc8>
    80001f38:	00004097          	auipc	ra,0x4
    80001f3c:	e38080e7          	jalr	-456(ra) # 80005d70 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	3f850513          	addi	a0,a0,1016 # 80008338 <states.0+0xf0>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	e28080e7          	jalr	-472(ra) # 80005d70 <panic>
    printf("scause %p\n", scause);
    80001f50:	85ce                	mv	a1,s3
    80001f52:	00006517          	auipc	a0,0x6
    80001f56:	40650513          	addi	a0,a0,1030 # 80008358 <states.0+0x110>
    80001f5a:	00004097          	auipc	ra,0x4
    80001f5e:	e68080e7          	jalr	-408(ra) # 80005dc2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f62:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f66:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f6a:	00006517          	auipc	a0,0x6
    80001f6e:	3fe50513          	addi	a0,a0,1022 # 80008368 <states.0+0x120>
    80001f72:	00004097          	auipc	ra,0x4
    80001f76:	e50080e7          	jalr	-432(ra) # 80005dc2 <printf>
    panic("kerneltrap");
    80001f7a:	00006517          	auipc	a0,0x6
    80001f7e:	40650513          	addi	a0,a0,1030 # 80008380 <states.0+0x138>
    80001f82:	00004097          	auipc	ra,0x4
    80001f86:	dee080e7          	jalr	-530(ra) # 80005d70 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	ec8080e7          	jalr	-312(ra) # 80000e52 <myproc>
    80001f92:	d541                	beqz	a0,80001f1a <kerneltrap+0x38>
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	ebe080e7          	jalr	-322(ra) # 80000e52 <myproc>
    80001f9c:	4d18                	lw	a4,24(a0)
    80001f9e:	4791                	li	a5,4
    80001fa0:	f6f71de3          	bne	a4,a5,80001f1a <kerneltrap+0x38>
    yield();
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	574080e7          	jalr	1396(ra) # 80001518 <yield>
    80001fac:	b7bd                	j	80001f1a <kerneltrap+0x38>

0000000080001fae <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fae:	1101                	addi	sp,sp,-32
    80001fb0:	ec06                	sd	ra,24(sp)
    80001fb2:	e822                	sd	s0,16(sp)
    80001fb4:	e426                	sd	s1,8(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	e98080e7          	jalr	-360(ra) # 80000e52 <myproc>
  switch (n) {
    80001fc2:	4795                	li	a5,5
    80001fc4:	0497e163          	bltu	a5,s1,80002006 <argraw+0x58>
    80001fc8:	048a                	slli	s1,s1,0x2
    80001fca:	00006717          	auipc	a4,0x6
    80001fce:	3ee70713          	addi	a4,a4,1006 # 800083b8 <states.0+0x170>
    80001fd2:	94ba                	add	s1,s1,a4
    80001fd4:	409c                	lw	a5,0(s1)
    80001fd6:	97ba                	add	a5,a5,a4
    80001fd8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret
    return p->trapframe->a1;
    80001fe8:	6d3c                	ld	a5,88(a0)
    80001fea:	7fa8                	ld	a0,120(a5)
    80001fec:	bfcd                	j	80001fde <argraw+0x30>
    return p->trapframe->a2;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	63c8                	ld	a0,128(a5)
    80001ff2:	b7f5                	j	80001fde <argraw+0x30>
    return p->trapframe->a3;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	67c8                	ld	a0,136(a5)
    80001ff8:	b7dd                	j	80001fde <argraw+0x30>
    return p->trapframe->a4;
    80001ffa:	6d3c                	ld	a5,88(a0)
    80001ffc:	6bc8                	ld	a0,144(a5)
    80001ffe:	b7c5                	j	80001fde <argraw+0x30>
    return p->trapframe->a5;
    80002000:	6d3c                	ld	a5,88(a0)
    80002002:	6fc8                	ld	a0,152(a5)
    80002004:	bfe9                	j	80001fde <argraw+0x30>
  panic("argraw");
    80002006:	00006517          	auipc	a0,0x6
    8000200a:	38a50513          	addi	a0,a0,906 # 80008390 <states.0+0x148>
    8000200e:	00004097          	auipc	ra,0x4
    80002012:	d62080e7          	jalr	-670(ra) # 80005d70 <panic>

0000000080002016 <fetchaddr>:
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	e04a                	sd	s2,0(sp)
    80002020:	1000                	addi	s0,sp,32
    80002022:	84aa                	mv	s1,a0
    80002024:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	e2c080e7          	jalr	-468(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000202e:	653c                	ld	a5,72(a0)
    80002030:	02f4f863          	bgeu	s1,a5,80002060 <fetchaddr+0x4a>
    80002034:	00848713          	addi	a4,s1,8
    80002038:	02e7e663          	bltu	a5,a4,80002064 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000203c:	46a1                	li	a3,8
    8000203e:	8626                	mv	a2,s1
    80002040:	85ca                	mv	a1,s2
    80002042:	6928                	ld	a0,80(a0)
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	b5a080e7          	jalr	-1190(ra) # 80000b9e <copyin>
    8000204c:	00a03533          	snez	a0,a0
    80002050:	40a00533          	neg	a0,a0
}
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6902                	ld	s2,0(sp)
    8000205c:	6105                	addi	sp,sp,32
    8000205e:	8082                	ret
    return -1;
    80002060:	557d                	li	a0,-1
    80002062:	bfcd                	j	80002054 <fetchaddr+0x3e>
    80002064:	557d                	li	a0,-1
    80002066:	b7fd                	j	80002054 <fetchaddr+0x3e>

0000000080002068 <fetchstr>:
{
    80002068:	7179                	addi	sp,sp,-48
    8000206a:	f406                	sd	ra,40(sp)
    8000206c:	f022                	sd	s0,32(sp)
    8000206e:	ec26                	sd	s1,24(sp)
    80002070:	e84a                	sd	s2,16(sp)
    80002072:	e44e                	sd	s3,8(sp)
    80002074:	1800                	addi	s0,sp,48
    80002076:	892a                	mv	s2,a0
    80002078:	84ae                	mv	s1,a1
    8000207a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	dd6080e7          	jalr	-554(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002084:	86ce                	mv	a3,s3
    80002086:	864a                	mv	a2,s2
    80002088:	85a6                	mv	a1,s1
    8000208a:	6928                	ld	a0,80(a0)
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	ba0080e7          	jalr	-1120(ra) # 80000c2c <copyinstr>
    80002094:	00054e63          	bltz	a0,800020b0 <fetchstr+0x48>
  return strlen(buf);
    80002098:	8526                	mv	a0,s1
    8000209a:	ffffe097          	auipc	ra,0xffffe
    8000209e:	25a080e7          	jalr	602(ra) # 800002f4 <strlen>
}
    800020a2:	70a2                	ld	ra,40(sp)
    800020a4:	7402                	ld	s0,32(sp)
    800020a6:	64e2                	ld	s1,24(sp)
    800020a8:	6942                	ld	s2,16(sp)
    800020aa:	69a2                	ld	s3,8(sp)
    800020ac:	6145                	addi	sp,sp,48
    800020ae:	8082                	ret
    return -1;
    800020b0:	557d                	li	a0,-1
    800020b2:	bfc5                	j	800020a2 <fetchstr+0x3a>

00000000800020b4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	1000                	addi	s0,sp,32
    800020be:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	eee080e7          	jalr	-274(ra) # 80001fae <argraw>
    800020c8:	c088                	sw	a0,0(s1)
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	64a2                	ld	s1,8(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	ece080e7          	jalr	-306(ra) # 80001fae <argraw>
    800020e8:	e088                	sd	a0,0(s1)
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020f4:	7179                	addi	sp,sp,-48
    800020f6:	f406                	sd	ra,40(sp)
    800020f8:	f022                	sd	s0,32(sp)
    800020fa:	ec26                	sd	s1,24(sp)
    800020fc:	e84a                	sd	s2,16(sp)
    800020fe:	1800                	addi	s0,sp,48
    80002100:	84ae                	mv	s1,a1
    80002102:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002104:	fd840593          	addi	a1,s0,-40
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	fcc080e7          	jalr	-52(ra) # 800020d4 <argaddr>
  return fetchstr(addr, buf, max);
    80002110:	864a                	mv	a2,s2
    80002112:	85a6                	mv	a1,s1
    80002114:	fd843503          	ld	a0,-40(s0)
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	f50080e7          	jalr	-176(ra) # 80002068 <fetchstr>
}
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	64e2                	ld	s1,24(sp)
    80002126:	6942                	ld	s2,16(sp)
    80002128:	6145                	addi	sp,sp,48
    8000212a:	8082                	ret

000000008000212c <syscall>:
[SYS_sigreturn] sys_sigreturn 
};

void
syscall(void)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	e426                	sd	s1,8(sp)
    80002134:	e04a                	sd	s2,0(sp)
    80002136:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	d1a080e7          	jalr	-742(ra) # 80000e52 <myproc>
    80002140:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002142:	05853903          	ld	s2,88(a0)
    80002146:	0a893783          	ld	a5,168(s2)
    8000214a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000214e:	37fd                	addiw	a5,a5,-1
    80002150:	4759                	li	a4,22
    80002152:	00f76f63          	bltu	a4,a5,80002170 <syscall+0x44>
    80002156:	00369713          	slli	a4,a3,0x3
    8000215a:	00006797          	auipc	a5,0x6
    8000215e:	27678793          	addi	a5,a5,630 # 800083d0 <syscalls>
    80002162:	97ba                	add	a5,a5,a4
    80002164:	639c                	ld	a5,0(a5)
    80002166:	c789                	beqz	a5,80002170 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002168:	9782                	jalr	a5
    8000216a:	06a93823          	sd	a0,112(s2)
    8000216e:	a839                	j	8000218c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002170:	15848613          	addi	a2,s1,344
    80002174:	588c                	lw	a1,48(s1)
    80002176:	00006517          	auipc	a0,0x6
    8000217a:	22250513          	addi	a0,a0,546 # 80008398 <states.0+0x150>
    8000217e:	00004097          	auipc	ra,0x4
    80002182:	c44080e7          	jalr	-956(ra) # 80005dc2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002186:	6cbc                	ld	a5,88(s1)
    80002188:	577d                	li	a4,-1
    8000218a:	fbb8                	sd	a4,112(a5)
  }
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	64a2                	ld	s1,8(sp)
    80002192:	6902                	ld	s2,0(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002198:	1101                	addi	sp,sp,-32
    8000219a:	ec06                	sd	ra,24(sp)
    8000219c:	e822                	sd	s0,16(sp)
    8000219e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021a0:	fec40593          	addi	a1,s0,-20
    800021a4:	4501                	li	a0,0
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	f0e080e7          	jalr	-242(ra) # 800020b4 <argint>
  exit(n);
    800021ae:	fec42503          	lw	a0,-20(s0)
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	4d6080e7          	jalr	1238(ra) # 80001688 <exit>
  return 0;  // not reached
}
    800021ba:	4501                	li	a0,0
    800021bc:	60e2                	ld	ra,24(sp)
    800021be:	6442                	ld	s0,16(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021c4:	1141                	addi	sp,sp,-16
    800021c6:	e406                	sd	ra,8(sp)
    800021c8:	e022                	sd	s0,0(sp)
    800021ca:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	c86080e7          	jalr	-890(ra) # 80000e52 <myproc>
}
    800021d4:	5908                	lw	a0,48(a0)
    800021d6:	60a2                	ld	ra,8(sp)
    800021d8:	6402                	ld	s0,0(sp)
    800021da:	0141                	addi	sp,sp,16
    800021dc:	8082                	ret

00000000800021de <sys_fork>:

uint64
sys_fork(void)
{
    800021de:	1141                	addi	sp,sp,-16
    800021e0:	e406                	sd	ra,8(sp)
    800021e2:	e022                	sd	s0,0(sp)
    800021e4:	0800                	addi	s0,sp,16
  return fork();
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	07c080e7          	jalr	124(ra) # 80001262 <fork>
}
    800021ee:	60a2                	ld	ra,8(sp)
    800021f0:	6402                	ld	s0,0(sp)
    800021f2:	0141                	addi	sp,sp,16
    800021f4:	8082                	ret

00000000800021f6 <sys_wait>:

uint64
sys_wait(void)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021fe:	fe840593          	addi	a1,s0,-24
    80002202:	4501                	li	a0,0
    80002204:	00000097          	auipc	ra,0x0
    80002208:	ed0080e7          	jalr	-304(ra) # 800020d4 <argaddr>
  return wait(p);
    8000220c:	fe843503          	ld	a0,-24(s0)
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	61e080e7          	jalr	1566(ra) # 8000182e <wait>
}
    80002218:	60e2                	ld	ra,24(sp)
    8000221a:	6442                	ld	s0,16(sp)
    8000221c:	6105                	addi	sp,sp,32
    8000221e:	8082                	ret

0000000080002220 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002220:	7179                	addi	sp,sp,-48
    80002222:	f406                	sd	ra,40(sp)
    80002224:	f022                	sd	s0,32(sp)
    80002226:	ec26                	sd	s1,24(sp)
    80002228:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000222a:	fdc40593          	addi	a1,s0,-36
    8000222e:	4501                	li	a0,0
    80002230:	00000097          	auipc	ra,0x0
    80002234:	e84080e7          	jalr	-380(ra) # 800020b4 <argint>
  addr = myproc()->sz;
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	c1a080e7          	jalr	-998(ra) # 80000e52 <myproc>
    80002240:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002242:	fdc42503          	lw	a0,-36(s0)
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	fc0080e7          	jalr	-64(ra) # 80001206 <growproc>
    8000224e:	00054863          	bltz	a0,8000225e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002252:	8526                	mv	a0,s1
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6145                	addi	sp,sp,48
    8000225c:	8082                	ret
    return -1;
    8000225e:	54fd                	li	s1,-1
    80002260:	bfcd                	j	80002252 <sys_sbrk+0x32>

0000000080002262 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002262:	7139                	addi	sp,sp,-64
    80002264:	fc06                	sd	ra,56(sp)
    80002266:	f822                	sd	s0,48(sp)
    80002268:	f426                	sd	s1,40(sp)
    8000226a:	f04a                	sd	s2,32(sp)
    8000226c:	ec4e                	sd	s3,24(sp)
    8000226e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    80002270:	00004097          	auipc	ra,0x4
    80002274:	aa8080e7          	jalr	-1368(ra) # 80005d18 <backtrace>
  argint(0, &n);
    80002278:	fcc40593          	addi	a1,s0,-52
    8000227c:	4501                	li	a0,0
    8000227e:	00000097          	auipc	ra,0x0
    80002282:	e36080e7          	jalr	-458(ra) # 800020b4 <argint>
  if(n < 0)
    80002286:	fcc42783          	lw	a5,-52(s0)
    8000228a:	0607cf63          	bltz	a5,80002308 <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    8000228e:	0000d517          	auipc	a0,0xd
    80002292:	cd250513          	addi	a0,a0,-814 # 8000ef60 <tickslock>
    80002296:	00004097          	auipc	ra,0x4
    8000229a:	fe8080e7          	jalr	-24(ra) # 8000627e <acquire>
  ticks0 = ticks;
    8000229e:	00006917          	auipc	s2,0x6
    800022a2:	65a92903          	lw	s2,1626(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800022a6:	fcc42783          	lw	a5,-52(s0)
    800022aa:	cf9d                	beqz	a5,800022e8 <sys_sleep+0x86>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ac:	0000d997          	auipc	s3,0xd
    800022b0:	cb498993          	addi	s3,s3,-844 # 8000ef60 <tickslock>
    800022b4:	00006497          	auipc	s1,0x6
    800022b8:	64448493          	addi	s1,s1,1604 # 800088f8 <ticks>
    if(killed(myproc())){
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	b96080e7          	jalr	-1130(ra) # 80000e52 <myproc>
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	538080e7          	jalr	1336(ra) # 800017fc <killed>
    800022cc:	e129                	bnez	a0,8000230e <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    800022ce:	85ce                	mv	a1,s3
    800022d0:	8526                	mv	a0,s1
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	282080e7          	jalr	642(ra) # 80001554 <sleep>
  while(ticks - ticks0 < n){
    800022da:	409c                	lw	a5,0(s1)
    800022dc:	412787bb          	subw	a5,a5,s2
    800022e0:	fcc42703          	lw	a4,-52(s0)
    800022e4:	fce7ece3          	bltu	a5,a4,800022bc <sys_sleep+0x5a>
  }
  release(&tickslock);
    800022e8:	0000d517          	auipc	a0,0xd
    800022ec:	c7850513          	addi	a0,a0,-904 # 8000ef60 <tickslock>
    800022f0:	00004097          	auipc	ra,0x4
    800022f4:	042080e7          	jalr	66(ra) # 80006332 <release>
  
  return 0;
    800022f8:	4501                	li	a0,0
}
    800022fa:	70e2                	ld	ra,56(sp)
    800022fc:	7442                	ld	s0,48(sp)
    800022fe:	74a2                	ld	s1,40(sp)
    80002300:	7902                	ld	s2,32(sp)
    80002302:	69e2                	ld	s3,24(sp)
    80002304:	6121                	addi	sp,sp,64
    80002306:	8082                	ret
    n = 0;
    80002308:	fc042623          	sw	zero,-52(s0)
    8000230c:	b749                	j	8000228e <sys_sleep+0x2c>
      release(&tickslock);
    8000230e:	0000d517          	auipc	a0,0xd
    80002312:	c5250513          	addi	a0,a0,-942 # 8000ef60 <tickslock>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	01c080e7          	jalr	28(ra) # 80006332 <release>
      return -1;
    8000231e:	557d                	li	a0,-1
    80002320:	bfe9                	j	800022fa <sys_sleep+0x98>

0000000080002322 <sys_kill>:

uint64
sys_kill(void)
{
    80002322:	1101                	addi	sp,sp,-32
    80002324:	ec06                	sd	ra,24(sp)
    80002326:	e822                	sd	s0,16(sp)
    80002328:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000232a:	fec40593          	addi	a1,s0,-20
    8000232e:	4501                	li	a0,0
    80002330:	00000097          	auipc	ra,0x0
    80002334:	d84080e7          	jalr	-636(ra) # 800020b4 <argint>
  return kill(pid);
    80002338:	fec42503          	lw	a0,-20(s0)
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	422080e7          	jalr	1058(ra) # 8000175e <kill>
}
    80002344:	60e2                	ld	ra,24(sp)
    80002346:	6442                	ld	s0,16(sp)
    80002348:	6105                	addi	sp,sp,32
    8000234a:	8082                	ret

000000008000234c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000234c:	1101                	addi	sp,sp,-32
    8000234e:	ec06                	sd	ra,24(sp)
    80002350:	e822                	sd	s0,16(sp)
    80002352:	e426                	sd	s1,8(sp)
    80002354:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002356:	0000d517          	auipc	a0,0xd
    8000235a:	c0a50513          	addi	a0,a0,-1014 # 8000ef60 <tickslock>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	f20080e7          	jalr	-224(ra) # 8000627e <acquire>
  xticks = ticks;
    80002366:	00006497          	auipc	s1,0x6
    8000236a:	5924a483          	lw	s1,1426(s1) # 800088f8 <ticks>
  release(&tickslock);
    8000236e:	0000d517          	auipc	a0,0xd
    80002372:	bf250513          	addi	a0,a0,-1038 # 8000ef60 <tickslock>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	fbc080e7          	jalr	-68(ra) # 80006332 <release>
  return xticks;
}
    8000237e:	02049513          	slli	a0,s1,0x20
    80002382:	9101                	srli	a0,a0,0x20
    80002384:	60e2                	ld	ra,24(sp)
    80002386:	6442                	ld	s0,16(sp)
    80002388:	64a2                	ld	s1,8(sp)
    8000238a:	6105                	addi	sp,sp,32
    8000238c:	8082                	ret

000000008000238e <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    8000238e:	1101                	addi	sp,sp,-32
    80002390:	ec06                	sd	ra,24(sp)
    80002392:	e822                	sd	s0,16(sp)
    80002394:	1000                	addi	s0,sp,32
  int ticks;
  uint64 handler;
  argint(0, &ticks);
    80002396:	fec40593          	addi	a1,s0,-20
    8000239a:	4501                	li	a0,0
    8000239c:	00000097          	auipc	ra,0x0
    800023a0:	d18080e7          	jalr	-744(ra) # 800020b4 <argint>
  argaddr(1, &handler);
    800023a4:	fe040593          	addi	a1,s0,-32
    800023a8:	4505                	li	a0,1
    800023aa:	00000097          	auipc	ra,0x0
    800023ae:	d2a080e7          	jalr	-726(ra) # 800020d4 <argaddr>
  if(!(ticks | handler))return -1;
    800023b2:	fec42783          	lw	a5,-20(s0)
    800023b6:	fe043583          	ld	a1,-32(s0)
    800023ba:	00b7e733          	or	a4,a5,a1
    800023be:	557d                	li	a0,-1
    800023c0:	c711                	beqz	a4,800023cc <sys_sigalarm+0x3e>
  return sigalarm(ticks, (void(*)())handler);
    800023c2:	853e                	mv	a0,a5
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	6f4080e7          	jalr	1780(ra) # 80001ab8 <sigalarm>
}
    800023cc:	60e2                	ld	ra,24(sp)
    800023ce:	6442                	ld	s0,16(sp)
    800023d0:	6105                	addi	sp,sp,32
    800023d2:	8082                	ret

00000000800023d4 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    800023d4:	1141                	addi	sp,sp,-16
    800023d6:	e406                	sd	ra,8(sp)
    800023d8:	e022                	sd	s0,0(sp)
    800023da:	0800                	addi	s0,sp,16
  return sigreturn();
    800023dc:	fffff097          	auipc	ra,0xfffff
    800023e0:	712080e7          	jalr	1810(ra) # 80001aee <sigreturn>
    800023e4:	60a2                	ld	ra,8(sp)
    800023e6:	6402                	ld	s0,0(sp)
    800023e8:	0141                	addi	sp,sp,16
    800023ea:	8082                	ret

00000000800023ec <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023ec:	7179                	addi	sp,sp,-48
    800023ee:	f406                	sd	ra,40(sp)
    800023f0:	f022                	sd	s0,32(sp)
    800023f2:	ec26                	sd	s1,24(sp)
    800023f4:	e84a                	sd	s2,16(sp)
    800023f6:	e44e                	sd	s3,8(sp)
    800023f8:	e052                	sd	s4,0(sp)
    800023fa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023fc:	00006597          	auipc	a1,0x6
    80002400:	09458593          	addi	a1,a1,148 # 80008490 <syscalls+0xc0>
    80002404:	0000d517          	auipc	a0,0xd
    80002408:	b7450513          	addi	a0,a0,-1164 # 8000ef78 <bcache>
    8000240c:	00004097          	auipc	ra,0x4
    80002410:	de2080e7          	jalr	-542(ra) # 800061ee <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002414:	00015797          	auipc	a5,0x15
    80002418:	b6478793          	addi	a5,a5,-1180 # 80016f78 <bcache+0x8000>
    8000241c:	00015717          	auipc	a4,0x15
    80002420:	dc470713          	addi	a4,a4,-572 # 800171e0 <bcache+0x8268>
    80002424:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002428:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000242c:	0000d497          	auipc	s1,0xd
    80002430:	b6448493          	addi	s1,s1,-1180 # 8000ef90 <bcache+0x18>
    b->next = bcache.head.next;
    80002434:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002436:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002438:	00006a17          	auipc	s4,0x6
    8000243c:	060a0a13          	addi	s4,s4,96 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002440:	2b893783          	ld	a5,696(s2)
    80002444:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002446:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000244a:	85d2                	mv	a1,s4
    8000244c:	01048513          	addi	a0,s1,16
    80002450:	00001097          	auipc	ra,0x1
    80002454:	496080e7          	jalr	1174(ra) # 800038e6 <initsleeplock>
    bcache.head.next->prev = b;
    80002458:	2b893783          	ld	a5,696(s2)
    8000245c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000245e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002462:	45848493          	addi	s1,s1,1112
    80002466:	fd349de3          	bne	s1,s3,80002440 <binit+0x54>
  }
}
    8000246a:	70a2                	ld	ra,40(sp)
    8000246c:	7402                	ld	s0,32(sp)
    8000246e:	64e2                	ld	s1,24(sp)
    80002470:	6942                	ld	s2,16(sp)
    80002472:	69a2                	ld	s3,8(sp)
    80002474:	6a02                	ld	s4,0(sp)
    80002476:	6145                	addi	sp,sp,48
    80002478:	8082                	ret

000000008000247a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	e84a                	sd	s2,16(sp)
    80002484:	e44e                	sd	s3,8(sp)
    80002486:	1800                	addi	s0,sp,48
    80002488:	892a                	mv	s2,a0
    8000248a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000248c:	0000d517          	auipc	a0,0xd
    80002490:	aec50513          	addi	a0,a0,-1300 # 8000ef78 <bcache>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	dea080e7          	jalr	-534(ra) # 8000627e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000249c:	00015497          	auipc	s1,0x15
    800024a0:	d944b483          	ld	s1,-620(s1) # 80017230 <bcache+0x82b8>
    800024a4:	00015797          	auipc	a5,0x15
    800024a8:	d3c78793          	addi	a5,a5,-708 # 800171e0 <bcache+0x8268>
    800024ac:	02f48f63          	beq	s1,a5,800024ea <bread+0x70>
    800024b0:	873e                	mv	a4,a5
    800024b2:	a021                	j	800024ba <bread+0x40>
    800024b4:	68a4                	ld	s1,80(s1)
    800024b6:	02e48a63          	beq	s1,a4,800024ea <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024ba:	449c                	lw	a5,8(s1)
    800024bc:	ff279ce3          	bne	a5,s2,800024b4 <bread+0x3a>
    800024c0:	44dc                	lw	a5,12(s1)
    800024c2:	ff3799e3          	bne	a5,s3,800024b4 <bread+0x3a>
      b->refcnt++;
    800024c6:	40bc                	lw	a5,64(s1)
    800024c8:	2785                	addiw	a5,a5,1
    800024ca:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024cc:	0000d517          	auipc	a0,0xd
    800024d0:	aac50513          	addi	a0,a0,-1364 # 8000ef78 <bcache>
    800024d4:	00004097          	auipc	ra,0x4
    800024d8:	e5e080e7          	jalr	-418(ra) # 80006332 <release>
      acquiresleep(&b->lock);
    800024dc:	01048513          	addi	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	440080e7          	jalr	1088(ra) # 80003920 <acquiresleep>
      return b;
    800024e8:	a8b9                	j	80002546 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ea:	00015497          	auipc	s1,0x15
    800024ee:	d3e4b483          	ld	s1,-706(s1) # 80017228 <bcache+0x82b0>
    800024f2:	00015797          	auipc	a5,0x15
    800024f6:	cee78793          	addi	a5,a5,-786 # 800171e0 <bcache+0x8268>
    800024fa:	00f48863          	beq	s1,a5,8000250a <bread+0x90>
    800024fe:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002500:	40bc                	lw	a5,64(s1)
    80002502:	cf81                	beqz	a5,8000251a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002504:	64a4                	ld	s1,72(s1)
    80002506:	fee49de3          	bne	s1,a4,80002500 <bread+0x86>
  panic("bget: no buffers");
    8000250a:	00006517          	auipc	a0,0x6
    8000250e:	f9650513          	addi	a0,a0,-106 # 800084a0 <syscalls+0xd0>
    80002512:	00004097          	auipc	ra,0x4
    80002516:	85e080e7          	jalr	-1954(ra) # 80005d70 <panic>
      b->dev = dev;
    8000251a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000251e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002522:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002526:	4785                	li	a5,1
    80002528:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000252a:	0000d517          	auipc	a0,0xd
    8000252e:	a4e50513          	addi	a0,a0,-1458 # 8000ef78 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	e00080e7          	jalr	-512(ra) # 80006332 <release>
      acquiresleep(&b->lock);
    8000253a:	01048513          	addi	a0,s1,16
    8000253e:	00001097          	auipc	ra,0x1
    80002542:	3e2080e7          	jalr	994(ra) # 80003920 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002546:	409c                	lw	a5,0(s1)
    80002548:	cb89                	beqz	a5,8000255a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000254a:	8526                	mv	a0,s1
    8000254c:	70a2                	ld	ra,40(sp)
    8000254e:	7402                	ld	s0,32(sp)
    80002550:	64e2                	ld	s1,24(sp)
    80002552:	6942                	ld	s2,16(sp)
    80002554:	69a2                	ld	s3,8(sp)
    80002556:	6145                	addi	sp,sp,48
    80002558:	8082                	ret
    virtio_disk_rw(b, 0);
    8000255a:	4581                	li	a1,0
    8000255c:	8526                	mv	a0,s1
    8000255e:	00003097          	auipc	ra,0x3
    80002562:	f84080e7          	jalr	-124(ra) # 800054e2 <virtio_disk_rw>
    b->valid = 1;
    80002566:	4785                	li	a5,1
    80002568:	c09c                	sw	a5,0(s1)
  return b;
    8000256a:	b7c5                	j	8000254a <bread+0xd0>

000000008000256c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	1000                	addi	s0,sp,32
    80002576:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002578:	0541                	addi	a0,a0,16
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	440080e7          	jalr	1088(ra) # 800039ba <holdingsleep>
    80002582:	cd01                	beqz	a0,8000259a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002584:	4585                	li	a1,1
    80002586:	8526                	mv	a0,s1
    80002588:	00003097          	auipc	ra,0x3
    8000258c:	f5a080e7          	jalr	-166(ra) # 800054e2 <virtio_disk_rw>
}
    80002590:	60e2                	ld	ra,24(sp)
    80002592:	6442                	ld	s0,16(sp)
    80002594:	64a2                	ld	s1,8(sp)
    80002596:	6105                	addi	sp,sp,32
    80002598:	8082                	ret
    panic("bwrite");
    8000259a:	00006517          	auipc	a0,0x6
    8000259e:	f1e50513          	addi	a0,a0,-226 # 800084b8 <syscalls+0xe8>
    800025a2:	00003097          	auipc	ra,0x3
    800025a6:	7ce080e7          	jalr	1998(ra) # 80005d70 <panic>

00000000800025aa <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025aa:	1101                	addi	sp,sp,-32
    800025ac:	ec06                	sd	ra,24(sp)
    800025ae:	e822                	sd	s0,16(sp)
    800025b0:	e426                	sd	s1,8(sp)
    800025b2:	e04a                	sd	s2,0(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025b8:	01050913          	addi	s2,a0,16
    800025bc:	854a                	mv	a0,s2
    800025be:	00001097          	auipc	ra,0x1
    800025c2:	3fc080e7          	jalr	1020(ra) # 800039ba <holdingsleep>
    800025c6:	c925                	beqz	a0,80002636 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800025c8:	854a                	mv	a0,s2
    800025ca:	00001097          	auipc	ra,0x1
    800025ce:	3ac080e7          	jalr	940(ra) # 80003976 <releasesleep>

  acquire(&bcache.lock);
    800025d2:	0000d517          	auipc	a0,0xd
    800025d6:	9a650513          	addi	a0,a0,-1626 # 8000ef78 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	ca4080e7          	jalr	-860(ra) # 8000627e <acquire>
  b->refcnt--;
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	37fd                	addiw	a5,a5,-1
    800025e6:	0007871b          	sext.w	a4,a5
    800025ea:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025ec:	e71d                	bnez	a4,8000261a <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025ee:	68b8                	ld	a4,80(s1)
    800025f0:	64bc                	ld	a5,72(s1)
    800025f2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025f4:	68b8                	ld	a4,80(s1)
    800025f6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025f8:	00015797          	auipc	a5,0x15
    800025fc:	98078793          	addi	a5,a5,-1664 # 80016f78 <bcache+0x8000>
    80002600:	2b87b703          	ld	a4,696(a5)
    80002604:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002606:	00015717          	auipc	a4,0x15
    8000260a:	bda70713          	addi	a4,a4,-1062 # 800171e0 <bcache+0x8268>
    8000260e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002610:	2b87b703          	ld	a4,696(a5)
    80002614:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002616:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000261a:	0000d517          	auipc	a0,0xd
    8000261e:	95e50513          	addi	a0,a0,-1698 # 8000ef78 <bcache>
    80002622:	00004097          	auipc	ra,0x4
    80002626:	d10080e7          	jalr	-752(ra) # 80006332 <release>
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6902                	ld	s2,0(sp)
    80002632:	6105                	addi	sp,sp,32
    80002634:	8082                	ret
    panic("brelse");
    80002636:	00006517          	auipc	a0,0x6
    8000263a:	e8a50513          	addi	a0,a0,-374 # 800084c0 <syscalls+0xf0>
    8000263e:	00003097          	auipc	ra,0x3
    80002642:	732080e7          	jalr	1842(ra) # 80005d70 <panic>

0000000080002646 <bpin>:

void
bpin(struct buf *b) {
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	1000                	addi	s0,sp,32
    80002650:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002652:	0000d517          	auipc	a0,0xd
    80002656:	92650513          	addi	a0,a0,-1754 # 8000ef78 <bcache>
    8000265a:	00004097          	auipc	ra,0x4
    8000265e:	c24080e7          	jalr	-988(ra) # 8000627e <acquire>
  b->refcnt++;
    80002662:	40bc                	lw	a5,64(s1)
    80002664:	2785                	addiw	a5,a5,1
    80002666:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002668:	0000d517          	auipc	a0,0xd
    8000266c:	91050513          	addi	a0,a0,-1776 # 8000ef78 <bcache>
    80002670:	00004097          	auipc	ra,0x4
    80002674:	cc2080e7          	jalr	-830(ra) # 80006332 <release>
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	6105                	addi	sp,sp,32
    80002680:	8082                	ret

0000000080002682 <bunpin>:

void
bunpin(struct buf *b) {
    80002682:	1101                	addi	sp,sp,-32
    80002684:	ec06                	sd	ra,24(sp)
    80002686:	e822                	sd	s0,16(sp)
    80002688:	e426                	sd	s1,8(sp)
    8000268a:	1000                	addi	s0,sp,32
    8000268c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000268e:	0000d517          	auipc	a0,0xd
    80002692:	8ea50513          	addi	a0,a0,-1814 # 8000ef78 <bcache>
    80002696:	00004097          	auipc	ra,0x4
    8000269a:	be8080e7          	jalr	-1048(ra) # 8000627e <acquire>
  b->refcnt--;
    8000269e:	40bc                	lw	a5,64(s1)
    800026a0:	37fd                	addiw	a5,a5,-1
    800026a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026a4:	0000d517          	auipc	a0,0xd
    800026a8:	8d450513          	addi	a0,a0,-1836 # 8000ef78 <bcache>
    800026ac:	00004097          	auipc	ra,0x4
    800026b0:	c86080e7          	jalr	-890(ra) # 80006332 <release>
}
    800026b4:	60e2                	ld	ra,24(sp)
    800026b6:	6442                	ld	s0,16(sp)
    800026b8:	64a2                	ld	s1,8(sp)
    800026ba:	6105                	addi	sp,sp,32
    800026bc:	8082                	ret

00000000800026be <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026be:	1101                	addi	sp,sp,-32
    800026c0:	ec06                	sd	ra,24(sp)
    800026c2:	e822                	sd	s0,16(sp)
    800026c4:	e426                	sd	s1,8(sp)
    800026c6:	e04a                	sd	s2,0(sp)
    800026c8:	1000                	addi	s0,sp,32
    800026ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026cc:	00d5d59b          	srliw	a1,a1,0xd
    800026d0:	00015797          	auipc	a5,0x15
    800026d4:	f847a783          	lw	a5,-124(a5) # 80017654 <sb+0x1c>
    800026d8:	9dbd                	addw	a1,a1,a5
    800026da:	00000097          	auipc	ra,0x0
    800026de:	da0080e7          	jalr	-608(ra) # 8000247a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026e2:	0074f713          	andi	a4,s1,7
    800026e6:	4785                	li	a5,1
    800026e8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026ec:	14ce                	slli	s1,s1,0x33
    800026ee:	90d9                	srli	s1,s1,0x36
    800026f0:	00950733          	add	a4,a0,s1
    800026f4:	05874703          	lbu	a4,88(a4)
    800026f8:	00e7f6b3          	and	a3,a5,a4
    800026fc:	c69d                	beqz	a3,8000272a <bfree+0x6c>
    800026fe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002700:	94aa                	add	s1,s1,a0
    80002702:	fff7c793          	not	a5,a5
    80002706:	8f7d                	and	a4,a4,a5
    80002708:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000270c:	00001097          	auipc	ra,0x1
    80002710:	0f6080e7          	jalr	246(ra) # 80003802 <log_write>
  brelse(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	e94080e7          	jalr	-364(ra) # 800025aa <brelse>
}
    8000271e:	60e2                	ld	ra,24(sp)
    80002720:	6442                	ld	s0,16(sp)
    80002722:	64a2                	ld	s1,8(sp)
    80002724:	6902                	ld	s2,0(sp)
    80002726:	6105                	addi	sp,sp,32
    80002728:	8082                	ret
    panic("freeing free block");
    8000272a:	00006517          	auipc	a0,0x6
    8000272e:	d9e50513          	addi	a0,a0,-610 # 800084c8 <syscalls+0xf8>
    80002732:	00003097          	auipc	ra,0x3
    80002736:	63e080e7          	jalr	1598(ra) # 80005d70 <panic>

000000008000273a <balloc>:
{
    8000273a:	711d                	addi	sp,sp,-96
    8000273c:	ec86                	sd	ra,88(sp)
    8000273e:	e8a2                	sd	s0,80(sp)
    80002740:	e4a6                	sd	s1,72(sp)
    80002742:	e0ca                	sd	s2,64(sp)
    80002744:	fc4e                	sd	s3,56(sp)
    80002746:	f852                	sd	s4,48(sp)
    80002748:	f456                	sd	s5,40(sp)
    8000274a:	f05a                	sd	s6,32(sp)
    8000274c:	ec5e                	sd	s7,24(sp)
    8000274e:	e862                	sd	s8,16(sp)
    80002750:	e466                	sd	s9,8(sp)
    80002752:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002754:	00015797          	auipc	a5,0x15
    80002758:	ee87a783          	lw	a5,-280(a5) # 8001763c <sb+0x4>
    8000275c:	cff5                	beqz	a5,80002858 <balloc+0x11e>
    8000275e:	8baa                	mv	s7,a0
    80002760:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002762:	00015b17          	auipc	s6,0x15
    80002766:	ed6b0b13          	addi	s6,s6,-298 # 80017638 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000276c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002770:	6c89                	lui	s9,0x2
    80002772:	a061                	j	800027fa <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002774:	97ca                	add	a5,a5,s2
    80002776:	8e55                	or	a2,a2,a3
    80002778:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00001097          	auipc	ra,0x1
    80002782:	084080e7          	jalr	132(ra) # 80003802 <log_write>
        brelse(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	e22080e7          	jalr	-478(ra) # 800025aa <brelse>
  bp = bread(dev, bno);
    80002790:	85a6                	mv	a1,s1
    80002792:	855e                	mv	a0,s7
    80002794:	00000097          	auipc	ra,0x0
    80002798:	ce6080e7          	jalr	-794(ra) # 8000247a <bread>
    8000279c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000279e:	40000613          	li	a2,1024
    800027a2:	4581                	li	a1,0
    800027a4:	05850513          	addi	a0,a0,88
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	9d2080e7          	jalr	-1582(ra) # 8000017a <memset>
  log_write(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00001097          	auipc	ra,0x1
    800027b6:	050080e7          	jalr	80(ra) # 80003802 <log_write>
  brelse(bp);
    800027ba:	854a                	mv	a0,s2
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	dee080e7          	jalr	-530(ra) # 800025aa <brelse>
}
    800027c4:	8526                	mv	a0,s1
    800027c6:	60e6                	ld	ra,88(sp)
    800027c8:	6446                	ld	s0,80(sp)
    800027ca:	64a6                	ld	s1,72(sp)
    800027cc:	6906                	ld	s2,64(sp)
    800027ce:	79e2                	ld	s3,56(sp)
    800027d0:	7a42                	ld	s4,48(sp)
    800027d2:	7aa2                	ld	s5,40(sp)
    800027d4:	7b02                	ld	s6,32(sp)
    800027d6:	6be2                	ld	s7,24(sp)
    800027d8:	6c42                	ld	s8,16(sp)
    800027da:	6ca2                	ld	s9,8(sp)
    800027dc:	6125                	addi	sp,sp,96
    800027de:	8082                	ret
    brelse(bp);
    800027e0:	854a                	mv	a0,s2
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	dc8080e7          	jalr	-568(ra) # 800025aa <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027ea:	015c87bb          	addw	a5,s9,s5
    800027ee:	00078a9b          	sext.w	s5,a5
    800027f2:	004b2703          	lw	a4,4(s6)
    800027f6:	06eaf163          	bgeu	s5,a4,80002858 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027fa:	41fad79b          	sraiw	a5,s5,0x1f
    800027fe:	0137d79b          	srliw	a5,a5,0x13
    80002802:	015787bb          	addw	a5,a5,s5
    80002806:	40d7d79b          	sraiw	a5,a5,0xd
    8000280a:	01cb2583          	lw	a1,28(s6)
    8000280e:	9dbd                	addw	a1,a1,a5
    80002810:	855e                	mv	a0,s7
    80002812:	00000097          	auipc	ra,0x0
    80002816:	c68080e7          	jalr	-920(ra) # 8000247a <bread>
    8000281a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000281c:	004b2503          	lw	a0,4(s6)
    80002820:	000a849b          	sext.w	s1,s5
    80002824:	8762                	mv	a4,s8
    80002826:	faa4fde3          	bgeu	s1,a0,800027e0 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000282a:	00777693          	andi	a3,a4,7
    8000282e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002832:	41f7579b          	sraiw	a5,a4,0x1f
    80002836:	01d7d79b          	srliw	a5,a5,0x1d
    8000283a:	9fb9                	addw	a5,a5,a4
    8000283c:	4037d79b          	sraiw	a5,a5,0x3
    80002840:	00f90633          	add	a2,s2,a5
    80002844:	05864603          	lbu	a2,88(a2)
    80002848:	00c6f5b3          	and	a1,a3,a2
    8000284c:	d585                	beqz	a1,80002774 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284e:	2705                	addiw	a4,a4,1
    80002850:	2485                	addiw	s1,s1,1
    80002852:	fd471ae3          	bne	a4,s4,80002826 <balloc+0xec>
    80002856:	b769                	j	800027e0 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	c8850513          	addi	a0,a0,-888 # 800084e0 <syscalls+0x110>
    80002860:	00003097          	auipc	ra,0x3
    80002864:	562080e7          	jalr	1378(ra) # 80005dc2 <printf>
  return 0;
    80002868:	4481                	li	s1,0
    8000286a:	bfa9                	j	800027c4 <balloc+0x8a>

000000008000286c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000286c:	7179                	addi	sp,sp,-48
    8000286e:	f406                	sd	ra,40(sp)
    80002870:	f022                	sd	s0,32(sp)
    80002872:	ec26                	sd	s1,24(sp)
    80002874:	e84a                	sd	s2,16(sp)
    80002876:	e44e                	sd	s3,8(sp)
    80002878:	e052                	sd	s4,0(sp)
    8000287a:	1800                	addi	s0,sp,48
    8000287c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000287e:	47ad                	li	a5,11
    80002880:	02b7e863          	bltu	a5,a1,800028b0 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002884:	02059793          	slli	a5,a1,0x20
    80002888:	01e7d593          	srli	a1,a5,0x1e
    8000288c:	00b504b3          	add	s1,a0,a1
    80002890:	0504a903          	lw	s2,80(s1)
    80002894:	06091e63          	bnez	s2,80002910 <bmap+0xa4>
      addr = balloc(ip->dev);
    80002898:	4108                	lw	a0,0(a0)
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	ea0080e7          	jalr	-352(ra) # 8000273a <balloc>
    800028a2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028a6:	06090563          	beqz	s2,80002910 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800028aa:	0524a823          	sw	s2,80(s1)
    800028ae:	a08d                	j	80002910 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028b0:	ff45849b          	addiw	s1,a1,-12
    800028b4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028b8:	0ff00793          	li	a5,255
    800028bc:	08e7e563          	bltu	a5,a4,80002946 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028c0:	08052903          	lw	s2,128(a0)
    800028c4:	00091d63          	bnez	s2,800028de <bmap+0x72>
      addr = balloc(ip->dev);
    800028c8:	4108                	lw	a0,0(a0)
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	e70080e7          	jalr	-400(ra) # 8000273a <balloc>
    800028d2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028d6:	02090d63          	beqz	s2,80002910 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028da:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028de:	85ca                	mv	a1,s2
    800028e0:	0009a503          	lw	a0,0(s3)
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	b96080e7          	jalr	-1130(ra) # 8000247a <bread>
    800028ec:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028ee:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028f2:	02049713          	slli	a4,s1,0x20
    800028f6:	01e75593          	srli	a1,a4,0x1e
    800028fa:	00b784b3          	add	s1,a5,a1
    800028fe:	0004a903          	lw	s2,0(s1)
    80002902:	02090063          	beqz	s2,80002922 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002906:	8552                	mv	a0,s4
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	ca2080e7          	jalr	-862(ra) # 800025aa <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002910:	854a                	mv	a0,s2
    80002912:	70a2                	ld	ra,40(sp)
    80002914:	7402                	ld	s0,32(sp)
    80002916:	64e2                	ld	s1,24(sp)
    80002918:	6942                	ld	s2,16(sp)
    8000291a:	69a2                	ld	s3,8(sp)
    8000291c:	6a02                	ld	s4,0(sp)
    8000291e:	6145                	addi	sp,sp,48
    80002920:	8082                	ret
      addr = balloc(ip->dev);
    80002922:	0009a503          	lw	a0,0(s3)
    80002926:	00000097          	auipc	ra,0x0
    8000292a:	e14080e7          	jalr	-492(ra) # 8000273a <balloc>
    8000292e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002932:	fc090ae3          	beqz	s2,80002906 <bmap+0x9a>
        a[bn] = addr;
    80002936:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000293a:	8552                	mv	a0,s4
    8000293c:	00001097          	auipc	ra,0x1
    80002940:	ec6080e7          	jalr	-314(ra) # 80003802 <log_write>
    80002944:	b7c9                	j	80002906 <bmap+0x9a>
  panic("bmap: out of range");
    80002946:	00006517          	auipc	a0,0x6
    8000294a:	bb250513          	addi	a0,a0,-1102 # 800084f8 <syscalls+0x128>
    8000294e:	00003097          	auipc	ra,0x3
    80002952:	422080e7          	jalr	1058(ra) # 80005d70 <panic>

0000000080002956 <iget>:
{
    80002956:	7179                	addi	sp,sp,-48
    80002958:	f406                	sd	ra,40(sp)
    8000295a:	f022                	sd	s0,32(sp)
    8000295c:	ec26                	sd	s1,24(sp)
    8000295e:	e84a                	sd	s2,16(sp)
    80002960:	e44e                	sd	s3,8(sp)
    80002962:	e052                	sd	s4,0(sp)
    80002964:	1800                	addi	s0,sp,48
    80002966:	89aa                	mv	s3,a0
    80002968:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000296a:	00015517          	auipc	a0,0x15
    8000296e:	cee50513          	addi	a0,a0,-786 # 80017658 <itable>
    80002972:	00004097          	auipc	ra,0x4
    80002976:	90c080e7          	jalr	-1780(ra) # 8000627e <acquire>
  empty = 0;
    8000297a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000297c:	00015497          	auipc	s1,0x15
    80002980:	cf448493          	addi	s1,s1,-780 # 80017670 <itable+0x18>
    80002984:	00016697          	auipc	a3,0x16
    80002988:	77c68693          	addi	a3,a3,1916 # 80019100 <log>
    8000298c:	a039                	j	8000299a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000298e:	02090b63          	beqz	s2,800029c4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002992:	08848493          	addi	s1,s1,136
    80002996:	02d48a63          	beq	s1,a3,800029ca <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000299a:	449c                	lw	a5,8(s1)
    8000299c:	fef059e3          	blez	a5,8000298e <iget+0x38>
    800029a0:	4098                	lw	a4,0(s1)
    800029a2:	ff3716e3          	bne	a4,s3,8000298e <iget+0x38>
    800029a6:	40d8                	lw	a4,4(s1)
    800029a8:	ff4713e3          	bne	a4,s4,8000298e <iget+0x38>
      ip->ref++;
    800029ac:	2785                	addiw	a5,a5,1
    800029ae:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029b0:	00015517          	auipc	a0,0x15
    800029b4:	ca850513          	addi	a0,a0,-856 # 80017658 <itable>
    800029b8:	00004097          	auipc	ra,0x4
    800029bc:	97a080e7          	jalr	-1670(ra) # 80006332 <release>
      return ip;
    800029c0:	8926                	mv	s2,s1
    800029c2:	a03d                	j	800029f0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029c4:	f7f9                	bnez	a5,80002992 <iget+0x3c>
    800029c6:	8926                	mv	s2,s1
    800029c8:	b7e9                	j	80002992 <iget+0x3c>
  if(empty == 0)
    800029ca:	02090c63          	beqz	s2,80002a02 <iget+0xac>
  ip->dev = dev;
    800029ce:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029d2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029d6:	4785                	li	a5,1
    800029d8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029dc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029e0:	00015517          	auipc	a0,0x15
    800029e4:	c7850513          	addi	a0,a0,-904 # 80017658 <itable>
    800029e8:	00004097          	auipc	ra,0x4
    800029ec:	94a080e7          	jalr	-1718(ra) # 80006332 <release>
}
    800029f0:	854a                	mv	a0,s2
    800029f2:	70a2                	ld	ra,40(sp)
    800029f4:	7402                	ld	s0,32(sp)
    800029f6:	64e2                	ld	s1,24(sp)
    800029f8:	6942                	ld	s2,16(sp)
    800029fa:	69a2                	ld	s3,8(sp)
    800029fc:	6a02                	ld	s4,0(sp)
    800029fe:	6145                	addi	sp,sp,48
    80002a00:	8082                	ret
    panic("iget: no inodes");
    80002a02:	00006517          	auipc	a0,0x6
    80002a06:	b0e50513          	addi	a0,a0,-1266 # 80008510 <syscalls+0x140>
    80002a0a:	00003097          	auipc	ra,0x3
    80002a0e:	366080e7          	jalr	870(ra) # 80005d70 <panic>

0000000080002a12 <fsinit>:
fsinit(int dev) {
    80002a12:	7179                	addi	sp,sp,-48
    80002a14:	f406                	sd	ra,40(sp)
    80002a16:	f022                	sd	s0,32(sp)
    80002a18:	ec26                	sd	s1,24(sp)
    80002a1a:	e84a                	sd	s2,16(sp)
    80002a1c:	e44e                	sd	s3,8(sp)
    80002a1e:	1800                	addi	s0,sp,48
    80002a20:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a22:	4585                	li	a1,1
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	a56080e7          	jalr	-1450(ra) # 8000247a <bread>
    80002a2c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a2e:	00015997          	auipc	s3,0x15
    80002a32:	c0a98993          	addi	s3,s3,-1014 # 80017638 <sb>
    80002a36:	02000613          	li	a2,32
    80002a3a:	05850593          	addi	a1,a0,88
    80002a3e:	854e                	mv	a0,s3
    80002a40:	ffffd097          	auipc	ra,0xffffd
    80002a44:	796080e7          	jalr	1942(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a48:	8526                	mv	a0,s1
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	b60080e7          	jalr	-1184(ra) # 800025aa <brelse>
  if(sb.magic != FSMAGIC)
    80002a52:	0009a703          	lw	a4,0(s3)
    80002a56:	102037b7          	lui	a5,0x10203
    80002a5a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a5e:	02f71263          	bne	a4,a5,80002a82 <fsinit+0x70>
  initlog(dev, &sb);
    80002a62:	00015597          	auipc	a1,0x15
    80002a66:	bd658593          	addi	a1,a1,-1066 # 80017638 <sb>
    80002a6a:	854a                	mv	a0,s2
    80002a6c:	00001097          	auipc	ra,0x1
    80002a70:	b2c080e7          	jalr	-1236(ra) # 80003598 <initlog>
}
    80002a74:	70a2                	ld	ra,40(sp)
    80002a76:	7402                	ld	s0,32(sp)
    80002a78:	64e2                	ld	s1,24(sp)
    80002a7a:	6942                	ld	s2,16(sp)
    80002a7c:	69a2                	ld	s3,8(sp)
    80002a7e:	6145                	addi	sp,sp,48
    80002a80:	8082                	ret
    panic("invalid file system");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	a9e50513          	addi	a0,a0,-1378 # 80008520 <syscalls+0x150>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	2e6080e7          	jalr	742(ra) # 80005d70 <panic>

0000000080002a92 <iinit>:
{
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aa0:	00006597          	auipc	a1,0x6
    80002aa4:	a9858593          	addi	a1,a1,-1384 # 80008538 <syscalls+0x168>
    80002aa8:	00015517          	auipc	a0,0x15
    80002aac:	bb050513          	addi	a0,a0,-1104 # 80017658 <itable>
    80002ab0:	00003097          	auipc	ra,0x3
    80002ab4:	73e080e7          	jalr	1854(ra) # 800061ee <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab8:	00015497          	auipc	s1,0x15
    80002abc:	bc848493          	addi	s1,s1,-1080 # 80017680 <itable+0x28>
    80002ac0:	00016997          	auipc	s3,0x16
    80002ac4:	65098993          	addi	s3,s3,1616 # 80019110 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac8:	00006917          	auipc	s2,0x6
    80002acc:	a7890913          	addi	s2,s2,-1416 # 80008540 <syscalls+0x170>
    80002ad0:	85ca                	mv	a1,s2
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	00001097          	auipc	ra,0x1
    80002ad8:	e12080e7          	jalr	-494(ra) # 800038e6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002adc:	08848493          	addi	s1,s1,136
    80002ae0:	ff3498e3          	bne	s1,s3,80002ad0 <iinit+0x3e>
}
    80002ae4:	70a2                	ld	ra,40(sp)
    80002ae6:	7402                	ld	s0,32(sp)
    80002ae8:	64e2                	ld	s1,24(sp)
    80002aea:	6942                	ld	s2,16(sp)
    80002aec:	69a2                	ld	s3,8(sp)
    80002aee:	6145                	addi	sp,sp,48
    80002af0:	8082                	ret

0000000080002af2 <ialloc>:
{
    80002af2:	7139                	addi	sp,sp,-64
    80002af4:	fc06                	sd	ra,56(sp)
    80002af6:	f822                	sd	s0,48(sp)
    80002af8:	f426                	sd	s1,40(sp)
    80002afa:	f04a                	sd	s2,32(sp)
    80002afc:	ec4e                	sd	s3,24(sp)
    80002afe:	e852                	sd	s4,16(sp)
    80002b00:	e456                	sd	s5,8(sp)
    80002b02:	e05a                	sd	s6,0(sp)
    80002b04:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b06:	00015717          	auipc	a4,0x15
    80002b0a:	b3e72703          	lw	a4,-1218(a4) # 80017644 <sb+0xc>
    80002b0e:	4785                	li	a5,1
    80002b10:	04e7f863          	bgeu	a5,a4,80002b60 <ialloc+0x6e>
    80002b14:	8aaa                	mv	s5,a0
    80002b16:	8b2e                	mv	s6,a1
    80002b18:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b1a:	00015a17          	auipc	s4,0x15
    80002b1e:	b1ea0a13          	addi	s4,s4,-1250 # 80017638 <sb>
    80002b22:	00495593          	srli	a1,s2,0x4
    80002b26:	018a2783          	lw	a5,24(s4)
    80002b2a:	9dbd                	addw	a1,a1,a5
    80002b2c:	8556                	mv	a0,s5
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	94c080e7          	jalr	-1716(ra) # 8000247a <bread>
    80002b36:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b38:	05850993          	addi	s3,a0,88
    80002b3c:	00f97793          	andi	a5,s2,15
    80002b40:	079a                	slli	a5,a5,0x6
    80002b42:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b44:	00099783          	lh	a5,0(s3)
    80002b48:	cf9d                	beqz	a5,80002b86 <ialloc+0x94>
    brelse(bp);
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	a60080e7          	jalr	-1440(ra) # 800025aa <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b52:	0905                	addi	s2,s2,1
    80002b54:	00ca2703          	lw	a4,12(s4)
    80002b58:	0009079b          	sext.w	a5,s2
    80002b5c:	fce7e3e3          	bltu	a5,a4,80002b22 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	9e850513          	addi	a0,a0,-1560 # 80008548 <syscalls+0x178>
    80002b68:	00003097          	auipc	ra,0x3
    80002b6c:	25a080e7          	jalr	602(ra) # 80005dc2 <printf>
  return 0;
    80002b70:	4501                	li	a0,0
}
    80002b72:	70e2                	ld	ra,56(sp)
    80002b74:	7442                	ld	s0,48(sp)
    80002b76:	74a2                	ld	s1,40(sp)
    80002b78:	7902                	ld	s2,32(sp)
    80002b7a:	69e2                	ld	s3,24(sp)
    80002b7c:	6a42                	ld	s4,16(sp)
    80002b7e:	6aa2                	ld	s5,8(sp)
    80002b80:	6b02                	ld	s6,0(sp)
    80002b82:	6121                	addi	sp,sp,64
    80002b84:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b86:	04000613          	li	a2,64
    80002b8a:	4581                	li	a1,0
    80002b8c:	854e                	mv	a0,s3
    80002b8e:	ffffd097          	auipc	ra,0xffffd
    80002b92:	5ec080e7          	jalr	1516(ra) # 8000017a <memset>
      dip->type = type;
    80002b96:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b9a:	8526                	mv	a0,s1
    80002b9c:	00001097          	auipc	ra,0x1
    80002ba0:	c66080e7          	jalr	-922(ra) # 80003802 <log_write>
      brelse(bp);
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	a04080e7          	jalr	-1532(ra) # 800025aa <brelse>
      return iget(dev, inum);
    80002bae:	0009059b          	sext.w	a1,s2
    80002bb2:	8556                	mv	a0,s5
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	da2080e7          	jalr	-606(ra) # 80002956 <iget>
    80002bbc:	bf5d                	j	80002b72 <ialloc+0x80>

0000000080002bbe <iupdate>:
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	e04a                	sd	s2,0(sp)
    80002bc8:	1000                	addi	s0,sp,32
    80002bca:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bcc:	415c                	lw	a5,4(a0)
    80002bce:	0047d79b          	srliw	a5,a5,0x4
    80002bd2:	00015597          	auipc	a1,0x15
    80002bd6:	a7e5a583          	lw	a1,-1410(a1) # 80017650 <sb+0x18>
    80002bda:	9dbd                	addw	a1,a1,a5
    80002bdc:	4108                	lw	a0,0(a0)
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	89c080e7          	jalr	-1892(ra) # 8000247a <bread>
    80002be6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be8:	05850793          	addi	a5,a0,88
    80002bec:	40d8                	lw	a4,4(s1)
    80002bee:	8b3d                	andi	a4,a4,15
    80002bf0:	071a                	slli	a4,a4,0x6
    80002bf2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bf4:	04449703          	lh	a4,68(s1)
    80002bf8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bfc:	04649703          	lh	a4,70(s1)
    80002c00:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c04:	04849703          	lh	a4,72(s1)
    80002c08:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c0c:	04a49703          	lh	a4,74(s1)
    80002c10:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c14:	44f8                	lw	a4,76(s1)
    80002c16:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c18:	03400613          	li	a2,52
    80002c1c:	05048593          	addi	a1,s1,80
    80002c20:	00c78513          	addi	a0,a5,12
    80002c24:	ffffd097          	auipc	ra,0xffffd
    80002c28:	5b2080e7          	jalr	1458(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	00001097          	auipc	ra,0x1
    80002c32:	bd4080e7          	jalr	-1068(ra) # 80003802 <log_write>
  brelse(bp);
    80002c36:	854a                	mv	a0,s2
    80002c38:	00000097          	auipc	ra,0x0
    80002c3c:	972080e7          	jalr	-1678(ra) # 800025aa <brelse>
}
    80002c40:	60e2                	ld	ra,24(sp)
    80002c42:	6442                	ld	s0,16(sp)
    80002c44:	64a2                	ld	s1,8(sp)
    80002c46:	6902                	ld	s2,0(sp)
    80002c48:	6105                	addi	sp,sp,32
    80002c4a:	8082                	ret

0000000080002c4c <idup>:
{
    80002c4c:	1101                	addi	sp,sp,-32
    80002c4e:	ec06                	sd	ra,24(sp)
    80002c50:	e822                	sd	s0,16(sp)
    80002c52:	e426                	sd	s1,8(sp)
    80002c54:	1000                	addi	s0,sp,32
    80002c56:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c58:	00015517          	auipc	a0,0x15
    80002c5c:	a0050513          	addi	a0,a0,-1536 # 80017658 <itable>
    80002c60:	00003097          	auipc	ra,0x3
    80002c64:	61e080e7          	jalr	1566(ra) # 8000627e <acquire>
  ip->ref++;
    80002c68:	449c                	lw	a5,8(s1)
    80002c6a:	2785                	addiw	a5,a5,1
    80002c6c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c6e:	00015517          	auipc	a0,0x15
    80002c72:	9ea50513          	addi	a0,a0,-1558 # 80017658 <itable>
    80002c76:	00003097          	auipc	ra,0x3
    80002c7a:	6bc080e7          	jalr	1724(ra) # 80006332 <release>
}
    80002c7e:	8526                	mv	a0,s1
    80002c80:	60e2                	ld	ra,24(sp)
    80002c82:	6442                	ld	s0,16(sp)
    80002c84:	64a2                	ld	s1,8(sp)
    80002c86:	6105                	addi	sp,sp,32
    80002c88:	8082                	ret

0000000080002c8a <ilock>:
{
    80002c8a:	1101                	addi	sp,sp,-32
    80002c8c:	ec06                	sd	ra,24(sp)
    80002c8e:	e822                	sd	s0,16(sp)
    80002c90:	e426                	sd	s1,8(sp)
    80002c92:	e04a                	sd	s2,0(sp)
    80002c94:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c96:	c115                	beqz	a0,80002cba <ilock+0x30>
    80002c98:	84aa                	mv	s1,a0
    80002c9a:	451c                	lw	a5,8(a0)
    80002c9c:	00f05f63          	blez	a5,80002cba <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ca0:	0541                	addi	a0,a0,16
    80002ca2:	00001097          	auipc	ra,0x1
    80002ca6:	c7e080e7          	jalr	-898(ra) # 80003920 <acquiresleep>
  if(ip->valid == 0){
    80002caa:	40bc                	lw	a5,64(s1)
    80002cac:	cf99                	beqz	a5,80002cca <ilock+0x40>
}
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6902                	ld	s2,0(sp)
    80002cb6:	6105                	addi	sp,sp,32
    80002cb8:	8082                	ret
    panic("ilock");
    80002cba:	00006517          	auipc	a0,0x6
    80002cbe:	8a650513          	addi	a0,a0,-1882 # 80008560 <syscalls+0x190>
    80002cc2:	00003097          	auipc	ra,0x3
    80002cc6:	0ae080e7          	jalr	174(ra) # 80005d70 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cca:	40dc                	lw	a5,4(s1)
    80002ccc:	0047d79b          	srliw	a5,a5,0x4
    80002cd0:	00015597          	auipc	a1,0x15
    80002cd4:	9805a583          	lw	a1,-1664(a1) # 80017650 <sb+0x18>
    80002cd8:	9dbd                	addw	a1,a1,a5
    80002cda:	4088                	lw	a0,0(s1)
    80002cdc:	fffff097          	auipc	ra,0xfffff
    80002ce0:	79e080e7          	jalr	1950(ra) # 8000247a <bread>
    80002ce4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ce6:	05850593          	addi	a1,a0,88
    80002cea:	40dc                	lw	a5,4(s1)
    80002cec:	8bbd                	andi	a5,a5,15
    80002cee:	079a                	slli	a5,a5,0x6
    80002cf0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cf2:	00059783          	lh	a5,0(a1)
    80002cf6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cfa:	00259783          	lh	a5,2(a1)
    80002cfe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d02:	00459783          	lh	a5,4(a1)
    80002d06:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d0a:	00659783          	lh	a5,6(a1)
    80002d0e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d12:	459c                	lw	a5,8(a1)
    80002d14:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d16:	03400613          	li	a2,52
    80002d1a:	05b1                	addi	a1,a1,12
    80002d1c:	05048513          	addi	a0,s1,80
    80002d20:	ffffd097          	auipc	ra,0xffffd
    80002d24:	4b6080e7          	jalr	1206(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d28:	854a                	mv	a0,s2
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	880080e7          	jalr	-1920(ra) # 800025aa <brelse>
    ip->valid = 1;
    80002d32:	4785                	li	a5,1
    80002d34:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d36:	04449783          	lh	a5,68(s1)
    80002d3a:	fbb5                	bnez	a5,80002cae <ilock+0x24>
      panic("ilock: no type");
    80002d3c:	00006517          	auipc	a0,0x6
    80002d40:	82c50513          	addi	a0,a0,-2004 # 80008568 <syscalls+0x198>
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	02c080e7          	jalr	44(ra) # 80005d70 <panic>

0000000080002d4c <iunlock>:
{
    80002d4c:	1101                	addi	sp,sp,-32
    80002d4e:	ec06                	sd	ra,24(sp)
    80002d50:	e822                	sd	s0,16(sp)
    80002d52:	e426                	sd	s1,8(sp)
    80002d54:	e04a                	sd	s2,0(sp)
    80002d56:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d58:	c905                	beqz	a0,80002d88 <iunlock+0x3c>
    80002d5a:	84aa                	mv	s1,a0
    80002d5c:	01050913          	addi	s2,a0,16
    80002d60:	854a                	mv	a0,s2
    80002d62:	00001097          	auipc	ra,0x1
    80002d66:	c58080e7          	jalr	-936(ra) # 800039ba <holdingsleep>
    80002d6a:	cd19                	beqz	a0,80002d88 <iunlock+0x3c>
    80002d6c:	449c                	lw	a5,8(s1)
    80002d6e:	00f05d63          	blez	a5,80002d88 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d72:	854a                	mv	a0,s2
    80002d74:	00001097          	auipc	ra,0x1
    80002d78:	c02080e7          	jalr	-1022(ra) # 80003976 <releasesleep>
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6902                	ld	s2,0(sp)
    80002d84:	6105                	addi	sp,sp,32
    80002d86:	8082                	ret
    panic("iunlock");
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	7f050513          	addi	a0,a0,2032 # 80008578 <syscalls+0x1a8>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	fe0080e7          	jalr	-32(ra) # 80005d70 <panic>

0000000080002d98 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d98:	7179                	addi	sp,sp,-48
    80002d9a:	f406                	sd	ra,40(sp)
    80002d9c:	f022                	sd	s0,32(sp)
    80002d9e:	ec26                	sd	s1,24(sp)
    80002da0:	e84a                	sd	s2,16(sp)
    80002da2:	e44e                	sd	s3,8(sp)
    80002da4:	e052                	sd	s4,0(sp)
    80002da6:	1800                	addi	s0,sp,48
    80002da8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002daa:	05050493          	addi	s1,a0,80
    80002dae:	08050913          	addi	s2,a0,128
    80002db2:	a021                	j	80002dba <itrunc+0x22>
    80002db4:	0491                	addi	s1,s1,4
    80002db6:	01248d63          	beq	s1,s2,80002dd0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dba:	408c                	lw	a1,0(s1)
    80002dbc:	dde5                	beqz	a1,80002db4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dbe:	0009a503          	lw	a0,0(s3)
    80002dc2:	00000097          	auipc	ra,0x0
    80002dc6:	8fc080e7          	jalr	-1796(ra) # 800026be <bfree>
      ip->addrs[i] = 0;
    80002dca:	0004a023          	sw	zero,0(s1)
    80002dce:	b7dd                	j	80002db4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dd0:	0809a583          	lw	a1,128(s3)
    80002dd4:	e185                	bnez	a1,80002df4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dd6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dda:	854e                	mv	a0,s3
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	de2080e7          	jalr	-542(ra) # 80002bbe <iupdate>
}
    80002de4:	70a2                	ld	ra,40(sp)
    80002de6:	7402                	ld	s0,32(sp)
    80002de8:	64e2                	ld	s1,24(sp)
    80002dea:	6942                	ld	s2,16(sp)
    80002dec:	69a2                	ld	s3,8(sp)
    80002dee:	6a02                	ld	s4,0(sp)
    80002df0:	6145                	addi	sp,sp,48
    80002df2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002df4:	0009a503          	lw	a0,0(s3)
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	682080e7          	jalr	1666(ra) # 8000247a <bread>
    80002e00:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e02:	05850493          	addi	s1,a0,88
    80002e06:	45850913          	addi	s2,a0,1112
    80002e0a:	a021                	j	80002e12 <itrunc+0x7a>
    80002e0c:	0491                	addi	s1,s1,4
    80002e0e:	01248b63          	beq	s1,s2,80002e24 <itrunc+0x8c>
      if(a[j])
    80002e12:	408c                	lw	a1,0(s1)
    80002e14:	dde5                	beqz	a1,80002e0c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e16:	0009a503          	lw	a0,0(s3)
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	8a4080e7          	jalr	-1884(ra) # 800026be <bfree>
    80002e22:	b7ed                	j	80002e0c <itrunc+0x74>
    brelse(bp);
    80002e24:	8552                	mv	a0,s4
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	784080e7          	jalr	1924(ra) # 800025aa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e2e:	0809a583          	lw	a1,128(s3)
    80002e32:	0009a503          	lw	a0,0(s3)
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	888080e7          	jalr	-1912(ra) # 800026be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e3e:	0809a023          	sw	zero,128(s3)
    80002e42:	bf51                	j	80002dd6 <itrunc+0x3e>

0000000080002e44 <iput>:
{
    80002e44:	1101                	addi	sp,sp,-32
    80002e46:	ec06                	sd	ra,24(sp)
    80002e48:	e822                	sd	s0,16(sp)
    80002e4a:	e426                	sd	s1,8(sp)
    80002e4c:	e04a                	sd	s2,0(sp)
    80002e4e:	1000                	addi	s0,sp,32
    80002e50:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e52:	00015517          	auipc	a0,0x15
    80002e56:	80650513          	addi	a0,a0,-2042 # 80017658 <itable>
    80002e5a:	00003097          	auipc	ra,0x3
    80002e5e:	424080e7          	jalr	1060(ra) # 8000627e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e62:	4498                	lw	a4,8(s1)
    80002e64:	4785                	li	a5,1
    80002e66:	02f70363          	beq	a4,a5,80002e8c <iput+0x48>
  ip->ref--;
    80002e6a:	449c                	lw	a5,8(s1)
    80002e6c:	37fd                	addiw	a5,a5,-1
    80002e6e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e70:	00014517          	auipc	a0,0x14
    80002e74:	7e850513          	addi	a0,a0,2024 # 80017658 <itable>
    80002e78:	00003097          	auipc	ra,0x3
    80002e7c:	4ba080e7          	jalr	1210(ra) # 80006332 <release>
}
    80002e80:	60e2                	ld	ra,24(sp)
    80002e82:	6442                	ld	s0,16(sp)
    80002e84:	64a2                	ld	s1,8(sp)
    80002e86:	6902                	ld	s2,0(sp)
    80002e88:	6105                	addi	sp,sp,32
    80002e8a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e8c:	40bc                	lw	a5,64(s1)
    80002e8e:	dff1                	beqz	a5,80002e6a <iput+0x26>
    80002e90:	04a49783          	lh	a5,74(s1)
    80002e94:	fbf9                	bnez	a5,80002e6a <iput+0x26>
    acquiresleep(&ip->lock);
    80002e96:	01048913          	addi	s2,s1,16
    80002e9a:	854a                	mv	a0,s2
    80002e9c:	00001097          	auipc	ra,0x1
    80002ea0:	a84080e7          	jalr	-1404(ra) # 80003920 <acquiresleep>
    release(&itable.lock);
    80002ea4:	00014517          	auipc	a0,0x14
    80002ea8:	7b450513          	addi	a0,a0,1972 # 80017658 <itable>
    80002eac:	00003097          	auipc	ra,0x3
    80002eb0:	486080e7          	jalr	1158(ra) # 80006332 <release>
    itrunc(ip);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	ee2080e7          	jalr	-286(ra) # 80002d98 <itrunc>
    ip->type = 0;
    80002ebe:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ec2:	8526                	mv	a0,s1
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	cfa080e7          	jalr	-774(ra) # 80002bbe <iupdate>
    ip->valid = 0;
    80002ecc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	00001097          	auipc	ra,0x1
    80002ed6:	aa4080e7          	jalr	-1372(ra) # 80003976 <releasesleep>
    acquire(&itable.lock);
    80002eda:	00014517          	auipc	a0,0x14
    80002ede:	77e50513          	addi	a0,a0,1918 # 80017658 <itable>
    80002ee2:	00003097          	auipc	ra,0x3
    80002ee6:	39c080e7          	jalr	924(ra) # 8000627e <acquire>
    80002eea:	b741                	j	80002e6a <iput+0x26>

0000000080002eec <iunlockput>:
{
    80002eec:	1101                	addi	sp,sp,-32
    80002eee:	ec06                	sd	ra,24(sp)
    80002ef0:	e822                	sd	s0,16(sp)
    80002ef2:	e426                	sd	s1,8(sp)
    80002ef4:	1000                	addi	s0,sp,32
    80002ef6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef8:	00000097          	auipc	ra,0x0
    80002efc:	e54080e7          	jalr	-428(ra) # 80002d4c <iunlock>
  iput(ip);
    80002f00:	8526                	mv	a0,s1
    80002f02:	00000097          	auipc	ra,0x0
    80002f06:	f42080e7          	jalr	-190(ra) # 80002e44 <iput>
}
    80002f0a:	60e2                	ld	ra,24(sp)
    80002f0c:	6442                	ld	s0,16(sp)
    80002f0e:	64a2                	ld	s1,8(sp)
    80002f10:	6105                	addi	sp,sp,32
    80002f12:	8082                	ret

0000000080002f14 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f14:	1141                	addi	sp,sp,-16
    80002f16:	e422                	sd	s0,8(sp)
    80002f18:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f1a:	411c                	lw	a5,0(a0)
    80002f1c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f1e:	415c                	lw	a5,4(a0)
    80002f20:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f22:	04451783          	lh	a5,68(a0)
    80002f26:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f2a:	04a51783          	lh	a5,74(a0)
    80002f2e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f32:	04c56783          	lwu	a5,76(a0)
    80002f36:	e99c                	sd	a5,16(a1)
}
    80002f38:	6422                	ld	s0,8(sp)
    80002f3a:	0141                	addi	sp,sp,16
    80002f3c:	8082                	ret

0000000080002f3e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f3e:	457c                	lw	a5,76(a0)
    80002f40:	0ed7e963          	bltu	a5,a3,80003032 <readi+0xf4>
{
    80002f44:	7159                	addi	sp,sp,-112
    80002f46:	f486                	sd	ra,104(sp)
    80002f48:	f0a2                	sd	s0,96(sp)
    80002f4a:	eca6                	sd	s1,88(sp)
    80002f4c:	e8ca                	sd	s2,80(sp)
    80002f4e:	e4ce                	sd	s3,72(sp)
    80002f50:	e0d2                	sd	s4,64(sp)
    80002f52:	fc56                	sd	s5,56(sp)
    80002f54:	f85a                	sd	s6,48(sp)
    80002f56:	f45e                	sd	s7,40(sp)
    80002f58:	f062                	sd	s8,32(sp)
    80002f5a:	ec66                	sd	s9,24(sp)
    80002f5c:	e86a                	sd	s10,16(sp)
    80002f5e:	e46e                	sd	s11,8(sp)
    80002f60:	1880                	addi	s0,sp,112
    80002f62:	8b2a                	mv	s6,a0
    80002f64:	8bae                	mv	s7,a1
    80002f66:	8a32                	mv	s4,a2
    80002f68:	84b6                	mv	s1,a3
    80002f6a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f6c:	9f35                	addw	a4,a4,a3
    return 0;
    80002f6e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f70:	0ad76063          	bltu	a4,a3,80003010 <readi+0xd2>
  if(off + n > ip->size)
    80002f74:	00e7f463          	bgeu	a5,a4,80002f7c <readi+0x3e>
    n = ip->size - off;
    80002f78:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7c:	0a0a8963          	beqz	s5,8000302e <readi+0xf0>
    80002f80:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f82:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f86:	5c7d                	li	s8,-1
    80002f88:	a82d                	j	80002fc2 <readi+0x84>
    80002f8a:	020d1d93          	slli	s11,s10,0x20
    80002f8e:	020ddd93          	srli	s11,s11,0x20
    80002f92:	05890613          	addi	a2,s2,88
    80002f96:	86ee                	mv	a3,s11
    80002f98:	963a                	add	a2,a2,a4
    80002f9a:	85d2                	mv	a1,s4
    80002f9c:	855e                	mv	a0,s7
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	9be080e7          	jalr	-1602(ra) # 8000195c <either_copyout>
    80002fa6:	05850d63          	beq	a0,s8,80003000 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002faa:	854a                	mv	a0,s2
    80002fac:	fffff097          	auipc	ra,0xfffff
    80002fb0:	5fe080e7          	jalr	1534(ra) # 800025aa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb4:	013d09bb          	addw	s3,s10,s3
    80002fb8:	009d04bb          	addw	s1,s10,s1
    80002fbc:	9a6e                	add	s4,s4,s11
    80002fbe:	0559f763          	bgeu	s3,s5,8000300c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fc2:	00a4d59b          	srliw	a1,s1,0xa
    80002fc6:	855a                	mv	a0,s6
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	8a4080e7          	jalr	-1884(ra) # 8000286c <bmap>
    80002fd0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fd4:	cd85                	beqz	a1,8000300c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fd6:	000b2503          	lw	a0,0(s6)
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	4a0080e7          	jalr	1184(ra) # 8000247a <bread>
    80002fe2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe4:	3ff4f713          	andi	a4,s1,1023
    80002fe8:	40ec87bb          	subw	a5,s9,a4
    80002fec:	413a86bb          	subw	a3,s5,s3
    80002ff0:	8d3e                	mv	s10,a5
    80002ff2:	2781                	sext.w	a5,a5
    80002ff4:	0006861b          	sext.w	a2,a3
    80002ff8:	f8f679e3          	bgeu	a2,a5,80002f8a <readi+0x4c>
    80002ffc:	8d36                	mv	s10,a3
    80002ffe:	b771                	j	80002f8a <readi+0x4c>
      brelse(bp);
    80003000:	854a                	mv	a0,s2
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	5a8080e7          	jalr	1448(ra) # 800025aa <brelse>
      tot = -1;
    8000300a:	59fd                	li	s3,-1
  }
  return tot;
    8000300c:	0009851b          	sext.w	a0,s3
}
    80003010:	70a6                	ld	ra,104(sp)
    80003012:	7406                	ld	s0,96(sp)
    80003014:	64e6                	ld	s1,88(sp)
    80003016:	6946                	ld	s2,80(sp)
    80003018:	69a6                	ld	s3,72(sp)
    8000301a:	6a06                	ld	s4,64(sp)
    8000301c:	7ae2                	ld	s5,56(sp)
    8000301e:	7b42                	ld	s6,48(sp)
    80003020:	7ba2                	ld	s7,40(sp)
    80003022:	7c02                	ld	s8,32(sp)
    80003024:	6ce2                	ld	s9,24(sp)
    80003026:	6d42                	ld	s10,16(sp)
    80003028:	6da2                	ld	s11,8(sp)
    8000302a:	6165                	addi	sp,sp,112
    8000302c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000302e:	89d6                	mv	s3,s5
    80003030:	bff1                	j	8000300c <readi+0xce>
    return 0;
    80003032:	4501                	li	a0,0
}
    80003034:	8082                	ret

0000000080003036 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003036:	457c                	lw	a5,76(a0)
    80003038:	10d7e863          	bltu	a5,a3,80003148 <writei+0x112>
{
    8000303c:	7159                	addi	sp,sp,-112
    8000303e:	f486                	sd	ra,104(sp)
    80003040:	f0a2                	sd	s0,96(sp)
    80003042:	eca6                	sd	s1,88(sp)
    80003044:	e8ca                	sd	s2,80(sp)
    80003046:	e4ce                	sd	s3,72(sp)
    80003048:	e0d2                	sd	s4,64(sp)
    8000304a:	fc56                	sd	s5,56(sp)
    8000304c:	f85a                	sd	s6,48(sp)
    8000304e:	f45e                	sd	s7,40(sp)
    80003050:	f062                	sd	s8,32(sp)
    80003052:	ec66                	sd	s9,24(sp)
    80003054:	e86a                	sd	s10,16(sp)
    80003056:	e46e                	sd	s11,8(sp)
    80003058:	1880                	addi	s0,sp,112
    8000305a:	8aaa                	mv	s5,a0
    8000305c:	8bae                	mv	s7,a1
    8000305e:	8a32                	mv	s4,a2
    80003060:	8936                	mv	s2,a3
    80003062:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003064:	00e687bb          	addw	a5,a3,a4
    80003068:	0ed7e263          	bltu	a5,a3,8000314c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000306c:	00043737          	lui	a4,0x43
    80003070:	0ef76063          	bltu	a4,a5,80003150 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003074:	0c0b0863          	beqz	s6,80003144 <writei+0x10e>
    80003078:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000307a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000307e:	5c7d                	li	s8,-1
    80003080:	a091                	j	800030c4 <writei+0x8e>
    80003082:	020d1d93          	slli	s11,s10,0x20
    80003086:	020ddd93          	srli	s11,s11,0x20
    8000308a:	05848513          	addi	a0,s1,88
    8000308e:	86ee                	mv	a3,s11
    80003090:	8652                	mv	a2,s4
    80003092:	85de                	mv	a1,s7
    80003094:	953a                	add	a0,a0,a4
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	91c080e7          	jalr	-1764(ra) # 800019b2 <either_copyin>
    8000309e:	07850263          	beq	a0,s8,80003102 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030a2:	8526                	mv	a0,s1
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	75e080e7          	jalr	1886(ra) # 80003802 <log_write>
    brelse(bp);
    800030ac:	8526                	mv	a0,s1
    800030ae:	fffff097          	auipc	ra,0xfffff
    800030b2:	4fc080e7          	jalr	1276(ra) # 800025aa <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b6:	013d09bb          	addw	s3,s10,s3
    800030ba:	012d093b          	addw	s2,s10,s2
    800030be:	9a6e                	add	s4,s4,s11
    800030c0:	0569f663          	bgeu	s3,s6,8000310c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030c4:	00a9559b          	srliw	a1,s2,0xa
    800030c8:	8556                	mv	a0,s5
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	7a2080e7          	jalr	1954(ra) # 8000286c <bmap>
    800030d2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030d6:	c99d                	beqz	a1,8000310c <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030d8:	000aa503          	lw	a0,0(s5)
    800030dc:	fffff097          	auipc	ra,0xfffff
    800030e0:	39e080e7          	jalr	926(ra) # 8000247a <bread>
    800030e4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e6:	3ff97713          	andi	a4,s2,1023
    800030ea:	40ec87bb          	subw	a5,s9,a4
    800030ee:	413b06bb          	subw	a3,s6,s3
    800030f2:	8d3e                	mv	s10,a5
    800030f4:	2781                	sext.w	a5,a5
    800030f6:	0006861b          	sext.w	a2,a3
    800030fa:	f8f674e3          	bgeu	a2,a5,80003082 <writei+0x4c>
    800030fe:	8d36                	mv	s10,a3
    80003100:	b749                	j	80003082 <writei+0x4c>
      brelse(bp);
    80003102:	8526                	mv	a0,s1
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	4a6080e7          	jalr	1190(ra) # 800025aa <brelse>
  }

  if(off > ip->size)
    8000310c:	04caa783          	lw	a5,76(s5)
    80003110:	0127f463          	bgeu	a5,s2,80003118 <writei+0xe2>
    ip->size = off;
    80003114:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003118:	8556                	mv	a0,s5
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	aa4080e7          	jalr	-1372(ra) # 80002bbe <iupdate>

  return tot;
    80003122:	0009851b          	sext.w	a0,s3
}
    80003126:	70a6                	ld	ra,104(sp)
    80003128:	7406                	ld	s0,96(sp)
    8000312a:	64e6                	ld	s1,88(sp)
    8000312c:	6946                	ld	s2,80(sp)
    8000312e:	69a6                	ld	s3,72(sp)
    80003130:	6a06                	ld	s4,64(sp)
    80003132:	7ae2                	ld	s5,56(sp)
    80003134:	7b42                	ld	s6,48(sp)
    80003136:	7ba2                	ld	s7,40(sp)
    80003138:	7c02                	ld	s8,32(sp)
    8000313a:	6ce2                	ld	s9,24(sp)
    8000313c:	6d42                	ld	s10,16(sp)
    8000313e:	6da2                	ld	s11,8(sp)
    80003140:	6165                	addi	sp,sp,112
    80003142:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003144:	89da                	mv	s3,s6
    80003146:	bfc9                	j	80003118 <writei+0xe2>
    return -1;
    80003148:	557d                	li	a0,-1
}
    8000314a:	8082                	ret
    return -1;
    8000314c:	557d                	li	a0,-1
    8000314e:	bfe1                	j	80003126 <writei+0xf0>
    return -1;
    80003150:	557d                	li	a0,-1
    80003152:	bfd1                	j	80003126 <writei+0xf0>

0000000080003154 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003154:	1141                	addi	sp,sp,-16
    80003156:	e406                	sd	ra,8(sp)
    80003158:	e022                	sd	s0,0(sp)
    8000315a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000315c:	4639                	li	a2,14
    8000315e:	ffffd097          	auipc	ra,0xffffd
    80003162:	0ec080e7          	jalr	236(ra) # 8000024a <strncmp>
}
    80003166:	60a2                	ld	ra,8(sp)
    80003168:	6402                	ld	s0,0(sp)
    8000316a:	0141                	addi	sp,sp,16
    8000316c:	8082                	ret

000000008000316e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000316e:	7139                	addi	sp,sp,-64
    80003170:	fc06                	sd	ra,56(sp)
    80003172:	f822                	sd	s0,48(sp)
    80003174:	f426                	sd	s1,40(sp)
    80003176:	f04a                	sd	s2,32(sp)
    80003178:	ec4e                	sd	s3,24(sp)
    8000317a:	e852                	sd	s4,16(sp)
    8000317c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000317e:	04451703          	lh	a4,68(a0)
    80003182:	4785                	li	a5,1
    80003184:	00f71a63          	bne	a4,a5,80003198 <dirlookup+0x2a>
    80003188:	892a                	mv	s2,a0
    8000318a:	89ae                	mv	s3,a1
    8000318c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318e:	457c                	lw	a5,76(a0)
    80003190:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003192:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003194:	e79d                	bnez	a5,800031c2 <dirlookup+0x54>
    80003196:	a8a5                	j	8000320e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003198:	00005517          	auipc	a0,0x5
    8000319c:	3e850513          	addi	a0,a0,1000 # 80008580 <syscalls+0x1b0>
    800031a0:	00003097          	auipc	ra,0x3
    800031a4:	bd0080e7          	jalr	-1072(ra) # 80005d70 <panic>
      panic("dirlookup read");
    800031a8:	00005517          	auipc	a0,0x5
    800031ac:	3f050513          	addi	a0,a0,1008 # 80008598 <syscalls+0x1c8>
    800031b0:	00003097          	auipc	ra,0x3
    800031b4:	bc0080e7          	jalr	-1088(ra) # 80005d70 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b8:	24c1                	addiw	s1,s1,16
    800031ba:	04c92783          	lw	a5,76(s2)
    800031be:	04f4f763          	bgeu	s1,a5,8000320c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031c2:	4741                	li	a4,16
    800031c4:	86a6                	mv	a3,s1
    800031c6:	fc040613          	addi	a2,s0,-64
    800031ca:	4581                	li	a1,0
    800031cc:	854a                	mv	a0,s2
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	d70080e7          	jalr	-656(ra) # 80002f3e <readi>
    800031d6:	47c1                	li	a5,16
    800031d8:	fcf518e3          	bne	a0,a5,800031a8 <dirlookup+0x3a>
    if(de.inum == 0)
    800031dc:	fc045783          	lhu	a5,-64(s0)
    800031e0:	dfe1                	beqz	a5,800031b8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031e2:	fc240593          	addi	a1,s0,-62
    800031e6:	854e                	mv	a0,s3
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	f6c080e7          	jalr	-148(ra) # 80003154 <namecmp>
    800031f0:	f561                	bnez	a0,800031b8 <dirlookup+0x4a>
      if(poff)
    800031f2:	000a0463          	beqz	s4,800031fa <dirlookup+0x8c>
        *poff = off;
    800031f6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031fa:	fc045583          	lhu	a1,-64(s0)
    800031fe:	00092503          	lw	a0,0(s2)
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	754080e7          	jalr	1876(ra) # 80002956 <iget>
    8000320a:	a011                	j	8000320e <dirlookup+0xa0>
  return 0;
    8000320c:	4501                	li	a0,0
}
    8000320e:	70e2                	ld	ra,56(sp)
    80003210:	7442                	ld	s0,48(sp)
    80003212:	74a2                	ld	s1,40(sp)
    80003214:	7902                	ld	s2,32(sp)
    80003216:	69e2                	ld	s3,24(sp)
    80003218:	6a42                	ld	s4,16(sp)
    8000321a:	6121                	addi	sp,sp,64
    8000321c:	8082                	ret

000000008000321e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000321e:	711d                	addi	sp,sp,-96
    80003220:	ec86                	sd	ra,88(sp)
    80003222:	e8a2                	sd	s0,80(sp)
    80003224:	e4a6                	sd	s1,72(sp)
    80003226:	e0ca                	sd	s2,64(sp)
    80003228:	fc4e                	sd	s3,56(sp)
    8000322a:	f852                	sd	s4,48(sp)
    8000322c:	f456                	sd	s5,40(sp)
    8000322e:	f05a                	sd	s6,32(sp)
    80003230:	ec5e                	sd	s7,24(sp)
    80003232:	e862                	sd	s8,16(sp)
    80003234:	e466                	sd	s9,8(sp)
    80003236:	1080                	addi	s0,sp,96
    80003238:	84aa                	mv	s1,a0
    8000323a:	8b2e                	mv	s6,a1
    8000323c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000323e:	00054703          	lbu	a4,0(a0)
    80003242:	02f00793          	li	a5,47
    80003246:	02f70263          	beq	a4,a5,8000326a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000324a:	ffffe097          	auipc	ra,0xffffe
    8000324e:	c08080e7          	jalr	-1016(ra) # 80000e52 <myproc>
    80003252:	15053503          	ld	a0,336(a0)
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	9f6080e7          	jalr	-1546(ra) # 80002c4c <idup>
    8000325e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003260:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003264:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003266:	4b85                	li	s7,1
    80003268:	a875                	j	80003324 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000326a:	4585                	li	a1,1
    8000326c:	4505                	li	a0,1
    8000326e:	fffff097          	auipc	ra,0xfffff
    80003272:	6e8080e7          	jalr	1768(ra) # 80002956 <iget>
    80003276:	8a2a                	mv	s4,a0
    80003278:	b7e5                	j	80003260 <namex+0x42>
      iunlockput(ip);
    8000327a:	8552                	mv	a0,s4
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	c70080e7          	jalr	-912(ra) # 80002eec <iunlockput>
      return 0;
    80003284:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003286:	8552                	mv	a0,s4
    80003288:	60e6                	ld	ra,88(sp)
    8000328a:	6446                	ld	s0,80(sp)
    8000328c:	64a6                	ld	s1,72(sp)
    8000328e:	6906                	ld	s2,64(sp)
    80003290:	79e2                	ld	s3,56(sp)
    80003292:	7a42                	ld	s4,48(sp)
    80003294:	7aa2                	ld	s5,40(sp)
    80003296:	7b02                	ld	s6,32(sp)
    80003298:	6be2                	ld	s7,24(sp)
    8000329a:	6c42                	ld	s8,16(sp)
    8000329c:	6ca2                	ld	s9,8(sp)
    8000329e:	6125                	addi	sp,sp,96
    800032a0:	8082                	ret
      iunlock(ip);
    800032a2:	8552                	mv	a0,s4
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	aa8080e7          	jalr	-1368(ra) # 80002d4c <iunlock>
      return ip;
    800032ac:	bfe9                	j	80003286 <namex+0x68>
      iunlockput(ip);
    800032ae:	8552                	mv	a0,s4
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	c3c080e7          	jalr	-964(ra) # 80002eec <iunlockput>
      return 0;
    800032b8:	8a4e                	mv	s4,s3
    800032ba:	b7f1                	j	80003286 <namex+0x68>
  len = path - s;
    800032bc:	40998633          	sub	a2,s3,s1
    800032c0:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032c4:	099c5863          	bge	s8,s9,80003354 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032c8:	4639                	li	a2,14
    800032ca:	85a6                	mv	a1,s1
    800032cc:	8556                	mv	a0,s5
    800032ce:	ffffd097          	auipc	ra,0xffffd
    800032d2:	f08080e7          	jalr	-248(ra) # 800001d6 <memmove>
    800032d6:	84ce                	mv	s1,s3
  while(*path == '/')
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	01279763          	bne	a5,s2,800032ea <namex+0xcc>
    path++;
    800032e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e2:	0004c783          	lbu	a5,0(s1)
    800032e6:	ff278de3          	beq	a5,s2,800032e0 <namex+0xc2>
    ilock(ip);
    800032ea:	8552                	mv	a0,s4
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	99e080e7          	jalr	-1634(ra) # 80002c8a <ilock>
    if(ip->type != T_DIR){
    800032f4:	044a1783          	lh	a5,68(s4)
    800032f8:	f97791e3          	bne	a5,s7,8000327a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032fc:	000b0563          	beqz	s6,80003306 <namex+0xe8>
    80003300:	0004c783          	lbu	a5,0(s1)
    80003304:	dfd9                	beqz	a5,800032a2 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003306:	4601                	li	a2,0
    80003308:	85d6                	mv	a1,s5
    8000330a:	8552                	mv	a0,s4
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	e62080e7          	jalr	-414(ra) # 8000316e <dirlookup>
    80003314:	89aa                	mv	s3,a0
    80003316:	dd41                	beqz	a0,800032ae <namex+0x90>
    iunlockput(ip);
    80003318:	8552                	mv	a0,s4
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	bd2080e7          	jalr	-1070(ra) # 80002eec <iunlockput>
    ip = next;
    80003322:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003324:	0004c783          	lbu	a5,0(s1)
    80003328:	01279763          	bne	a5,s2,80003336 <namex+0x118>
    path++;
    8000332c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	ff278de3          	beq	a5,s2,8000332c <namex+0x10e>
  if(*path == 0)
    80003336:	cb9d                	beqz	a5,8000336c <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003338:	0004c783          	lbu	a5,0(s1)
    8000333c:	89a6                	mv	s3,s1
  len = path - s;
    8000333e:	4c81                	li	s9,0
    80003340:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003342:	01278963          	beq	a5,s2,80003354 <namex+0x136>
    80003346:	dbbd                	beqz	a5,800032bc <namex+0x9e>
    path++;
    80003348:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000334a:	0009c783          	lbu	a5,0(s3)
    8000334e:	ff279ce3          	bne	a5,s2,80003346 <namex+0x128>
    80003352:	b7ad                	j	800032bc <namex+0x9e>
    memmove(name, s, len);
    80003354:	2601                	sext.w	a2,a2
    80003356:	85a6                	mv	a1,s1
    80003358:	8556                	mv	a0,s5
    8000335a:	ffffd097          	auipc	ra,0xffffd
    8000335e:	e7c080e7          	jalr	-388(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003362:	9cd6                	add	s9,s9,s5
    80003364:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003368:	84ce                	mv	s1,s3
    8000336a:	b7bd                	j	800032d8 <namex+0xba>
  if(nameiparent){
    8000336c:	f00b0de3          	beqz	s6,80003286 <namex+0x68>
    iput(ip);
    80003370:	8552                	mv	a0,s4
    80003372:	00000097          	auipc	ra,0x0
    80003376:	ad2080e7          	jalr	-1326(ra) # 80002e44 <iput>
    return 0;
    8000337a:	4a01                	li	s4,0
    8000337c:	b729                	j	80003286 <namex+0x68>

000000008000337e <dirlink>:
{
    8000337e:	7139                	addi	sp,sp,-64
    80003380:	fc06                	sd	ra,56(sp)
    80003382:	f822                	sd	s0,48(sp)
    80003384:	f426                	sd	s1,40(sp)
    80003386:	f04a                	sd	s2,32(sp)
    80003388:	ec4e                	sd	s3,24(sp)
    8000338a:	e852                	sd	s4,16(sp)
    8000338c:	0080                	addi	s0,sp,64
    8000338e:	892a                	mv	s2,a0
    80003390:	8a2e                	mv	s4,a1
    80003392:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003394:	4601                	li	a2,0
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	dd8080e7          	jalr	-552(ra) # 8000316e <dirlookup>
    8000339e:	e93d                	bnez	a0,80003414 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a0:	04c92483          	lw	s1,76(s2)
    800033a4:	c49d                	beqz	s1,800033d2 <dirlink+0x54>
    800033a6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a8:	4741                	li	a4,16
    800033aa:	86a6                	mv	a3,s1
    800033ac:	fc040613          	addi	a2,s0,-64
    800033b0:	4581                	li	a1,0
    800033b2:	854a                	mv	a0,s2
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	b8a080e7          	jalr	-1142(ra) # 80002f3e <readi>
    800033bc:	47c1                	li	a5,16
    800033be:	06f51163          	bne	a0,a5,80003420 <dirlink+0xa2>
    if(de.inum == 0)
    800033c2:	fc045783          	lhu	a5,-64(s0)
    800033c6:	c791                	beqz	a5,800033d2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c8:	24c1                	addiw	s1,s1,16
    800033ca:	04c92783          	lw	a5,76(s2)
    800033ce:	fcf4ede3          	bltu	s1,a5,800033a8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033d2:	4639                	li	a2,14
    800033d4:	85d2                	mv	a1,s4
    800033d6:	fc240513          	addi	a0,s0,-62
    800033da:	ffffd097          	auipc	ra,0xffffd
    800033de:	eac080e7          	jalr	-340(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033e2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e6:	4741                	li	a4,16
    800033e8:	86a6                	mv	a3,s1
    800033ea:	fc040613          	addi	a2,s0,-64
    800033ee:	4581                	li	a1,0
    800033f0:	854a                	mv	a0,s2
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	c44080e7          	jalr	-956(ra) # 80003036 <writei>
    800033fa:	1541                	addi	a0,a0,-16
    800033fc:	00a03533          	snez	a0,a0
    80003400:	40a00533          	neg	a0,a0
}
    80003404:	70e2                	ld	ra,56(sp)
    80003406:	7442                	ld	s0,48(sp)
    80003408:	74a2                	ld	s1,40(sp)
    8000340a:	7902                	ld	s2,32(sp)
    8000340c:	69e2                	ld	s3,24(sp)
    8000340e:	6a42                	ld	s4,16(sp)
    80003410:	6121                	addi	sp,sp,64
    80003412:	8082                	ret
    iput(ip);
    80003414:	00000097          	auipc	ra,0x0
    80003418:	a30080e7          	jalr	-1488(ra) # 80002e44 <iput>
    return -1;
    8000341c:	557d                	li	a0,-1
    8000341e:	b7dd                	j	80003404 <dirlink+0x86>
      panic("dirlink read");
    80003420:	00005517          	auipc	a0,0x5
    80003424:	18850513          	addi	a0,a0,392 # 800085a8 <syscalls+0x1d8>
    80003428:	00003097          	auipc	ra,0x3
    8000342c:	948080e7          	jalr	-1720(ra) # 80005d70 <panic>

0000000080003430 <namei>:

struct inode*
namei(char *path)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003438:	fe040613          	addi	a2,s0,-32
    8000343c:	4581                	li	a1,0
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	de0080e7          	jalr	-544(ra) # 8000321e <namex>
}
    80003446:	60e2                	ld	ra,24(sp)
    80003448:	6442                	ld	s0,16(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000344e:	1141                	addi	sp,sp,-16
    80003450:	e406                	sd	ra,8(sp)
    80003452:	e022                	sd	s0,0(sp)
    80003454:	0800                	addi	s0,sp,16
    80003456:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003458:	4585                	li	a1,1
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	dc4080e7          	jalr	-572(ra) # 8000321e <namex>
}
    80003462:	60a2                	ld	ra,8(sp)
    80003464:	6402                	ld	s0,0(sp)
    80003466:	0141                	addi	sp,sp,16
    80003468:	8082                	ret

000000008000346a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000346a:	1101                	addi	sp,sp,-32
    8000346c:	ec06                	sd	ra,24(sp)
    8000346e:	e822                	sd	s0,16(sp)
    80003470:	e426                	sd	s1,8(sp)
    80003472:	e04a                	sd	s2,0(sp)
    80003474:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003476:	00016917          	auipc	s2,0x16
    8000347a:	c8a90913          	addi	s2,s2,-886 # 80019100 <log>
    8000347e:	01892583          	lw	a1,24(s2)
    80003482:	02892503          	lw	a0,40(s2)
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	ff4080e7          	jalr	-12(ra) # 8000247a <bread>
    8000348e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003490:	02c92603          	lw	a2,44(s2)
    80003494:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003496:	00c05f63          	blez	a2,800034b4 <write_head+0x4a>
    8000349a:	00016717          	auipc	a4,0x16
    8000349e:	c9670713          	addi	a4,a4,-874 # 80019130 <log+0x30>
    800034a2:	87aa                	mv	a5,a0
    800034a4:	060a                	slli	a2,a2,0x2
    800034a6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034a8:	4314                	lw	a3,0(a4)
    800034aa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034ac:	0711                	addi	a4,a4,4
    800034ae:	0791                	addi	a5,a5,4
    800034b0:	fec79ce3          	bne	a5,a2,800034a8 <write_head+0x3e>
  }
  bwrite(buf);
    800034b4:	8526                	mv	a0,s1
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	0b6080e7          	jalr	182(ra) # 8000256c <bwrite>
  brelse(buf);
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	0ea080e7          	jalr	234(ra) # 800025aa <brelse>
}
    800034c8:	60e2                	ld	ra,24(sp)
    800034ca:	6442                	ld	s0,16(sp)
    800034cc:	64a2                	ld	s1,8(sp)
    800034ce:	6902                	ld	s2,0(sp)
    800034d0:	6105                	addi	sp,sp,32
    800034d2:	8082                	ret

00000000800034d4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d4:	00016797          	auipc	a5,0x16
    800034d8:	c587a783          	lw	a5,-936(a5) # 8001912c <log+0x2c>
    800034dc:	0af05d63          	blez	a5,80003596 <install_trans+0xc2>
{
    800034e0:	7139                	addi	sp,sp,-64
    800034e2:	fc06                	sd	ra,56(sp)
    800034e4:	f822                	sd	s0,48(sp)
    800034e6:	f426                	sd	s1,40(sp)
    800034e8:	f04a                	sd	s2,32(sp)
    800034ea:	ec4e                	sd	s3,24(sp)
    800034ec:	e852                	sd	s4,16(sp)
    800034ee:	e456                	sd	s5,8(sp)
    800034f0:	e05a                	sd	s6,0(sp)
    800034f2:	0080                	addi	s0,sp,64
    800034f4:	8b2a                	mv	s6,a0
    800034f6:	00016a97          	auipc	s5,0x16
    800034fa:	c3aa8a93          	addi	s5,s5,-966 # 80019130 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034fe:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003500:	00016997          	auipc	s3,0x16
    80003504:	c0098993          	addi	s3,s3,-1024 # 80019100 <log>
    80003508:	a00d                	j	8000352a <install_trans+0x56>
    brelse(lbuf);
    8000350a:	854a                	mv	a0,s2
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	09e080e7          	jalr	158(ra) # 800025aa <brelse>
    brelse(dbuf);
    80003514:	8526                	mv	a0,s1
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	094080e7          	jalr	148(ra) # 800025aa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000351e:	2a05                	addiw	s4,s4,1
    80003520:	0a91                	addi	s5,s5,4
    80003522:	02c9a783          	lw	a5,44(s3)
    80003526:	04fa5e63          	bge	s4,a5,80003582 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000352a:	0189a583          	lw	a1,24(s3)
    8000352e:	014585bb          	addw	a1,a1,s4
    80003532:	2585                	addiw	a1,a1,1
    80003534:	0289a503          	lw	a0,40(s3)
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	f42080e7          	jalr	-190(ra) # 8000247a <bread>
    80003540:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003542:	000aa583          	lw	a1,0(s5)
    80003546:	0289a503          	lw	a0,40(s3)
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	f30080e7          	jalr	-208(ra) # 8000247a <bread>
    80003552:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003554:	40000613          	li	a2,1024
    80003558:	05890593          	addi	a1,s2,88
    8000355c:	05850513          	addi	a0,a0,88
    80003560:	ffffd097          	auipc	ra,0xffffd
    80003564:	c76080e7          	jalr	-906(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003568:	8526                	mv	a0,s1
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	002080e7          	jalr	2(ra) # 8000256c <bwrite>
    if(recovering == 0)
    80003572:	f80b1ce3          	bnez	s6,8000350a <install_trans+0x36>
      bunpin(dbuf);
    80003576:	8526                	mv	a0,s1
    80003578:	fffff097          	auipc	ra,0xfffff
    8000357c:	10a080e7          	jalr	266(ra) # 80002682 <bunpin>
    80003580:	b769                	j	8000350a <install_trans+0x36>
}
    80003582:	70e2                	ld	ra,56(sp)
    80003584:	7442                	ld	s0,48(sp)
    80003586:	74a2                	ld	s1,40(sp)
    80003588:	7902                	ld	s2,32(sp)
    8000358a:	69e2                	ld	s3,24(sp)
    8000358c:	6a42                	ld	s4,16(sp)
    8000358e:	6aa2                	ld	s5,8(sp)
    80003590:	6b02                	ld	s6,0(sp)
    80003592:	6121                	addi	sp,sp,64
    80003594:	8082                	ret
    80003596:	8082                	ret

0000000080003598 <initlog>:
{
    80003598:	7179                	addi	sp,sp,-48
    8000359a:	f406                	sd	ra,40(sp)
    8000359c:	f022                	sd	s0,32(sp)
    8000359e:	ec26                	sd	s1,24(sp)
    800035a0:	e84a                	sd	s2,16(sp)
    800035a2:	e44e                	sd	s3,8(sp)
    800035a4:	1800                	addi	s0,sp,48
    800035a6:	892a                	mv	s2,a0
    800035a8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035aa:	00016497          	auipc	s1,0x16
    800035ae:	b5648493          	addi	s1,s1,-1194 # 80019100 <log>
    800035b2:	00005597          	auipc	a1,0x5
    800035b6:	00658593          	addi	a1,a1,6 # 800085b8 <syscalls+0x1e8>
    800035ba:	8526                	mv	a0,s1
    800035bc:	00003097          	auipc	ra,0x3
    800035c0:	c32080e7          	jalr	-974(ra) # 800061ee <initlock>
  log.start = sb->logstart;
    800035c4:	0149a583          	lw	a1,20(s3)
    800035c8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035ca:	0109a783          	lw	a5,16(s3)
    800035ce:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035d0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035d4:	854a                	mv	a0,s2
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	ea4080e7          	jalr	-348(ra) # 8000247a <bread>
  log.lh.n = lh->n;
    800035de:	4d30                	lw	a2,88(a0)
    800035e0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035e2:	00c05f63          	blez	a2,80003600 <initlog+0x68>
    800035e6:	87aa                	mv	a5,a0
    800035e8:	00016717          	auipc	a4,0x16
    800035ec:	b4870713          	addi	a4,a4,-1208 # 80019130 <log+0x30>
    800035f0:	060a                	slli	a2,a2,0x2
    800035f2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035f4:	4ff4                	lw	a3,92(a5)
    800035f6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035f8:	0791                	addi	a5,a5,4
    800035fa:	0711                	addi	a4,a4,4
    800035fc:	fec79ce3          	bne	a5,a2,800035f4 <initlog+0x5c>
  brelse(buf);
    80003600:	fffff097          	auipc	ra,0xfffff
    80003604:	faa080e7          	jalr	-86(ra) # 800025aa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003608:	4505                	li	a0,1
    8000360a:	00000097          	auipc	ra,0x0
    8000360e:	eca080e7          	jalr	-310(ra) # 800034d4 <install_trans>
  log.lh.n = 0;
    80003612:	00016797          	auipc	a5,0x16
    80003616:	b007ad23          	sw	zero,-1254(a5) # 8001912c <log+0x2c>
  write_head(); // clear the log
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	e50080e7          	jalr	-432(ra) # 8000346a <write_head>
}
    80003622:	70a2                	ld	ra,40(sp)
    80003624:	7402                	ld	s0,32(sp)
    80003626:	64e2                	ld	s1,24(sp)
    80003628:	6942                	ld	s2,16(sp)
    8000362a:	69a2                	ld	s3,8(sp)
    8000362c:	6145                	addi	sp,sp,48
    8000362e:	8082                	ret

0000000080003630 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003630:	1101                	addi	sp,sp,-32
    80003632:	ec06                	sd	ra,24(sp)
    80003634:	e822                	sd	s0,16(sp)
    80003636:	e426                	sd	s1,8(sp)
    80003638:	e04a                	sd	s2,0(sp)
    8000363a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000363c:	00016517          	auipc	a0,0x16
    80003640:	ac450513          	addi	a0,a0,-1340 # 80019100 <log>
    80003644:	00003097          	auipc	ra,0x3
    80003648:	c3a080e7          	jalr	-966(ra) # 8000627e <acquire>
  while(1){
    if(log.committing){
    8000364c:	00016497          	auipc	s1,0x16
    80003650:	ab448493          	addi	s1,s1,-1356 # 80019100 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003654:	4979                	li	s2,30
    80003656:	a039                	j	80003664 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003658:	85a6                	mv	a1,s1
    8000365a:	8526                	mv	a0,s1
    8000365c:	ffffe097          	auipc	ra,0xffffe
    80003660:	ef8080e7          	jalr	-264(ra) # 80001554 <sleep>
    if(log.committing){
    80003664:	50dc                	lw	a5,36(s1)
    80003666:	fbed                	bnez	a5,80003658 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003668:	5098                	lw	a4,32(s1)
    8000366a:	2705                	addiw	a4,a4,1
    8000366c:	0027179b          	slliw	a5,a4,0x2
    80003670:	9fb9                	addw	a5,a5,a4
    80003672:	0017979b          	slliw	a5,a5,0x1
    80003676:	54d4                	lw	a3,44(s1)
    80003678:	9fb5                	addw	a5,a5,a3
    8000367a:	00f95963          	bge	s2,a5,8000368c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000367e:	85a6                	mv	a1,s1
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	ed2080e7          	jalr	-302(ra) # 80001554 <sleep>
    8000368a:	bfe9                	j	80003664 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000368c:	00016517          	auipc	a0,0x16
    80003690:	a7450513          	addi	a0,a0,-1420 # 80019100 <log>
    80003694:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	c9c080e7          	jalr	-868(ra) # 80006332 <release>
      break;
    }
  }
}
    8000369e:	60e2                	ld	ra,24(sp)
    800036a0:	6442                	ld	s0,16(sp)
    800036a2:	64a2                	ld	s1,8(sp)
    800036a4:	6902                	ld	s2,0(sp)
    800036a6:	6105                	addi	sp,sp,32
    800036a8:	8082                	ret

00000000800036aa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036aa:	7139                	addi	sp,sp,-64
    800036ac:	fc06                	sd	ra,56(sp)
    800036ae:	f822                	sd	s0,48(sp)
    800036b0:	f426                	sd	s1,40(sp)
    800036b2:	f04a                	sd	s2,32(sp)
    800036b4:	ec4e                	sd	s3,24(sp)
    800036b6:	e852                	sd	s4,16(sp)
    800036b8:	e456                	sd	s5,8(sp)
    800036ba:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036bc:	00016497          	auipc	s1,0x16
    800036c0:	a4448493          	addi	s1,s1,-1468 # 80019100 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	bb8080e7          	jalr	-1096(ra) # 8000627e <acquire>
  log.outstanding -= 1;
    800036ce:	509c                	lw	a5,32(s1)
    800036d0:	37fd                	addiw	a5,a5,-1
    800036d2:	0007891b          	sext.w	s2,a5
    800036d6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036d8:	50dc                	lw	a5,36(s1)
    800036da:	e7b9                	bnez	a5,80003728 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036dc:	04091e63          	bnez	s2,80003738 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036e0:	00016497          	auipc	s1,0x16
    800036e4:	a2048493          	addi	s1,s1,-1504 # 80019100 <log>
    800036e8:	4785                	li	a5,1
    800036ea:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ec:	8526                	mv	a0,s1
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	c44080e7          	jalr	-956(ra) # 80006332 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036f6:	54dc                	lw	a5,44(s1)
    800036f8:	06f04763          	bgtz	a5,80003766 <end_op+0xbc>
    acquire(&log.lock);
    800036fc:	00016497          	auipc	s1,0x16
    80003700:	a0448493          	addi	s1,s1,-1532 # 80019100 <log>
    80003704:	8526                	mv	a0,s1
    80003706:	00003097          	auipc	ra,0x3
    8000370a:	b78080e7          	jalr	-1160(ra) # 8000627e <acquire>
    log.committing = 0;
    8000370e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	ea4080e7          	jalr	-348(ra) # 800015b8 <wakeup>
    release(&log.lock);
    8000371c:	8526                	mv	a0,s1
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	c14080e7          	jalr	-1004(ra) # 80006332 <release>
}
    80003726:	a03d                	j	80003754 <end_op+0xaa>
    panic("log.committing");
    80003728:	00005517          	auipc	a0,0x5
    8000372c:	e9850513          	addi	a0,a0,-360 # 800085c0 <syscalls+0x1f0>
    80003730:	00002097          	auipc	ra,0x2
    80003734:	640080e7          	jalr	1600(ra) # 80005d70 <panic>
    wakeup(&log);
    80003738:	00016497          	auipc	s1,0x16
    8000373c:	9c848493          	addi	s1,s1,-1592 # 80019100 <log>
    80003740:	8526                	mv	a0,s1
    80003742:	ffffe097          	auipc	ra,0xffffe
    80003746:	e76080e7          	jalr	-394(ra) # 800015b8 <wakeup>
  release(&log.lock);
    8000374a:	8526                	mv	a0,s1
    8000374c:	00003097          	auipc	ra,0x3
    80003750:	be6080e7          	jalr	-1050(ra) # 80006332 <release>
}
    80003754:	70e2                	ld	ra,56(sp)
    80003756:	7442                	ld	s0,48(sp)
    80003758:	74a2                	ld	s1,40(sp)
    8000375a:	7902                	ld	s2,32(sp)
    8000375c:	69e2                	ld	s3,24(sp)
    8000375e:	6a42                	ld	s4,16(sp)
    80003760:	6aa2                	ld	s5,8(sp)
    80003762:	6121                	addi	sp,sp,64
    80003764:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003766:	00016a97          	auipc	s5,0x16
    8000376a:	9caa8a93          	addi	s5,s5,-1590 # 80019130 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000376e:	00016a17          	auipc	s4,0x16
    80003772:	992a0a13          	addi	s4,s4,-1646 # 80019100 <log>
    80003776:	018a2583          	lw	a1,24(s4)
    8000377a:	012585bb          	addw	a1,a1,s2
    8000377e:	2585                	addiw	a1,a1,1
    80003780:	028a2503          	lw	a0,40(s4)
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	cf6080e7          	jalr	-778(ra) # 8000247a <bread>
    8000378c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000378e:	000aa583          	lw	a1,0(s5)
    80003792:	028a2503          	lw	a0,40(s4)
    80003796:	fffff097          	auipc	ra,0xfffff
    8000379a:	ce4080e7          	jalr	-796(ra) # 8000247a <bread>
    8000379e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037a0:	40000613          	li	a2,1024
    800037a4:	05850593          	addi	a1,a0,88
    800037a8:	05848513          	addi	a0,s1,88
    800037ac:	ffffd097          	auipc	ra,0xffffd
    800037b0:	a2a080e7          	jalr	-1494(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037b4:	8526                	mv	a0,s1
    800037b6:	fffff097          	auipc	ra,0xfffff
    800037ba:	db6080e7          	jalr	-586(ra) # 8000256c <bwrite>
    brelse(from);
    800037be:	854e                	mv	a0,s3
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	dea080e7          	jalr	-534(ra) # 800025aa <brelse>
    brelse(to);
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	de0080e7          	jalr	-544(ra) # 800025aa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037d2:	2905                	addiw	s2,s2,1
    800037d4:	0a91                	addi	s5,s5,4
    800037d6:	02ca2783          	lw	a5,44(s4)
    800037da:	f8f94ee3          	blt	s2,a5,80003776 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037de:	00000097          	auipc	ra,0x0
    800037e2:	c8c080e7          	jalr	-884(ra) # 8000346a <write_head>
    install_trans(0); // Now install writes to home locations
    800037e6:	4501                	li	a0,0
    800037e8:	00000097          	auipc	ra,0x0
    800037ec:	cec080e7          	jalr	-788(ra) # 800034d4 <install_trans>
    log.lh.n = 0;
    800037f0:	00016797          	auipc	a5,0x16
    800037f4:	9207ae23          	sw	zero,-1732(a5) # 8001912c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	c72080e7          	jalr	-910(ra) # 8000346a <write_head>
    80003800:	bdf5                	j	800036fc <end_op+0x52>

0000000080003802 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003802:	1101                	addi	sp,sp,-32
    80003804:	ec06                	sd	ra,24(sp)
    80003806:	e822                	sd	s0,16(sp)
    80003808:	e426                	sd	s1,8(sp)
    8000380a:	e04a                	sd	s2,0(sp)
    8000380c:	1000                	addi	s0,sp,32
    8000380e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003810:	00016917          	auipc	s2,0x16
    80003814:	8f090913          	addi	s2,s2,-1808 # 80019100 <log>
    80003818:	854a                	mv	a0,s2
    8000381a:	00003097          	auipc	ra,0x3
    8000381e:	a64080e7          	jalr	-1436(ra) # 8000627e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003822:	02c92603          	lw	a2,44(s2)
    80003826:	47f5                	li	a5,29
    80003828:	06c7c563          	blt	a5,a2,80003892 <log_write+0x90>
    8000382c:	00016797          	auipc	a5,0x16
    80003830:	8f07a783          	lw	a5,-1808(a5) # 8001911c <log+0x1c>
    80003834:	37fd                	addiw	a5,a5,-1
    80003836:	04f65e63          	bge	a2,a5,80003892 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000383a:	00016797          	auipc	a5,0x16
    8000383e:	8e67a783          	lw	a5,-1818(a5) # 80019120 <log+0x20>
    80003842:	06f05063          	blez	a5,800038a2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003846:	4781                	li	a5,0
    80003848:	06c05563          	blez	a2,800038b2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000384c:	44cc                	lw	a1,12(s1)
    8000384e:	00016717          	auipc	a4,0x16
    80003852:	8e270713          	addi	a4,a4,-1822 # 80019130 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003856:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003858:	4314                	lw	a3,0(a4)
    8000385a:	04b68c63          	beq	a3,a1,800038b2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000385e:	2785                	addiw	a5,a5,1
    80003860:	0711                	addi	a4,a4,4
    80003862:	fef61be3          	bne	a2,a5,80003858 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003866:	0621                	addi	a2,a2,8
    80003868:	060a                	slli	a2,a2,0x2
    8000386a:	00016797          	auipc	a5,0x16
    8000386e:	89678793          	addi	a5,a5,-1898 # 80019100 <log>
    80003872:	97b2                	add	a5,a5,a2
    80003874:	44d8                	lw	a4,12(s1)
    80003876:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003878:	8526                	mv	a0,s1
    8000387a:	fffff097          	auipc	ra,0xfffff
    8000387e:	dcc080e7          	jalr	-564(ra) # 80002646 <bpin>
    log.lh.n++;
    80003882:	00016717          	auipc	a4,0x16
    80003886:	87e70713          	addi	a4,a4,-1922 # 80019100 <log>
    8000388a:	575c                	lw	a5,44(a4)
    8000388c:	2785                	addiw	a5,a5,1
    8000388e:	d75c                	sw	a5,44(a4)
    80003890:	a82d                	j	800038ca <log_write+0xc8>
    panic("too big a transaction");
    80003892:	00005517          	auipc	a0,0x5
    80003896:	d3e50513          	addi	a0,a0,-706 # 800085d0 <syscalls+0x200>
    8000389a:	00002097          	auipc	ra,0x2
    8000389e:	4d6080e7          	jalr	1238(ra) # 80005d70 <panic>
    panic("log_write outside of trans");
    800038a2:	00005517          	auipc	a0,0x5
    800038a6:	d4650513          	addi	a0,a0,-698 # 800085e8 <syscalls+0x218>
    800038aa:	00002097          	auipc	ra,0x2
    800038ae:	4c6080e7          	jalr	1222(ra) # 80005d70 <panic>
  log.lh.block[i] = b->blockno;
    800038b2:	00878693          	addi	a3,a5,8
    800038b6:	068a                	slli	a3,a3,0x2
    800038b8:	00016717          	auipc	a4,0x16
    800038bc:	84870713          	addi	a4,a4,-1976 # 80019100 <log>
    800038c0:	9736                	add	a4,a4,a3
    800038c2:	44d4                	lw	a3,12(s1)
    800038c4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038c6:	faf609e3          	beq	a2,a5,80003878 <log_write+0x76>
  }
  release(&log.lock);
    800038ca:	00016517          	auipc	a0,0x16
    800038ce:	83650513          	addi	a0,a0,-1994 # 80019100 <log>
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	a60080e7          	jalr	-1440(ra) # 80006332 <release>
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	addi	s0,sp,32
    800038f2:	84aa                	mv	s1,a0
    800038f4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038f6:	00005597          	auipc	a1,0x5
    800038fa:	d1258593          	addi	a1,a1,-750 # 80008608 <syscalls+0x238>
    800038fe:	0521                	addi	a0,a0,8
    80003900:	00003097          	auipc	ra,0x3
    80003904:	8ee080e7          	jalr	-1810(ra) # 800061ee <initlock>
  lk->name = name;
    80003908:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000390c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003910:	0204a423          	sw	zero,40(s1)
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	addi	sp,sp,32
    8000391e:	8082                	ret

0000000080003920 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003920:	1101                	addi	sp,sp,-32
    80003922:	ec06                	sd	ra,24(sp)
    80003924:	e822                	sd	s0,16(sp)
    80003926:	e426                	sd	s1,8(sp)
    80003928:	e04a                	sd	s2,0(sp)
    8000392a:	1000                	addi	s0,sp,32
    8000392c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392e:	00850913          	addi	s2,a0,8
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	94a080e7          	jalr	-1718(ra) # 8000627e <acquire>
  while (lk->locked) {
    8000393c:	409c                	lw	a5,0(s1)
    8000393e:	cb89                	beqz	a5,80003950 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003940:	85ca                	mv	a1,s2
    80003942:	8526                	mv	a0,s1
    80003944:	ffffe097          	auipc	ra,0xffffe
    80003948:	c10080e7          	jalr	-1008(ra) # 80001554 <sleep>
  while (lk->locked) {
    8000394c:	409c                	lw	a5,0(s1)
    8000394e:	fbed                	bnez	a5,80003940 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003950:	4785                	li	a5,1
    80003952:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003954:	ffffd097          	auipc	ra,0xffffd
    80003958:	4fe080e7          	jalr	1278(ra) # 80000e52 <myproc>
    8000395c:	591c                	lw	a5,48(a0)
    8000395e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003960:	854a                	mv	a0,s2
    80003962:	00003097          	auipc	ra,0x3
    80003966:	9d0080e7          	jalr	-1584(ra) # 80006332 <release>
}
    8000396a:	60e2                	ld	ra,24(sp)
    8000396c:	6442                	ld	s0,16(sp)
    8000396e:	64a2                	ld	s1,8(sp)
    80003970:	6902                	ld	s2,0(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	e04a                	sd	s2,0(sp)
    80003980:	1000                	addi	s0,sp,32
    80003982:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003984:	00850913          	addi	s2,a0,8
    80003988:	854a                	mv	a0,s2
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	8f4080e7          	jalr	-1804(ra) # 8000627e <acquire>
  lk->locked = 0;
    80003992:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003996:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000399a:	8526                	mv	a0,s1
    8000399c:	ffffe097          	auipc	ra,0xffffe
    800039a0:	c1c080e7          	jalr	-996(ra) # 800015b8 <wakeup>
  release(&lk->lk);
    800039a4:	854a                	mv	a0,s2
    800039a6:	00003097          	auipc	ra,0x3
    800039aa:	98c080e7          	jalr	-1652(ra) # 80006332 <release>
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6902                	ld	s2,0(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret

00000000800039ba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039ba:	7179                	addi	sp,sp,-48
    800039bc:	f406                	sd	ra,40(sp)
    800039be:	f022                	sd	s0,32(sp)
    800039c0:	ec26                	sd	s1,24(sp)
    800039c2:	e84a                	sd	s2,16(sp)
    800039c4:	e44e                	sd	s3,8(sp)
    800039c6:	1800                	addi	s0,sp,48
    800039c8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039ca:	00850913          	addi	s2,a0,8
    800039ce:	854a                	mv	a0,s2
    800039d0:	00003097          	auipc	ra,0x3
    800039d4:	8ae080e7          	jalr	-1874(ra) # 8000627e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d8:	409c                	lw	a5,0(s1)
    800039da:	ef99                	bnez	a5,800039f8 <holdingsleep+0x3e>
    800039dc:	4481                	li	s1,0
  release(&lk->lk);
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	952080e7          	jalr	-1710(ra) # 80006332 <release>
  return r;
}
    800039e8:	8526                	mv	a0,s1
    800039ea:	70a2                	ld	ra,40(sp)
    800039ec:	7402                	ld	s0,32(sp)
    800039ee:	64e2                	ld	s1,24(sp)
    800039f0:	6942                	ld	s2,16(sp)
    800039f2:	69a2                	ld	s3,8(sp)
    800039f4:	6145                	addi	sp,sp,48
    800039f6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039f8:	0284a983          	lw	s3,40(s1)
    800039fc:	ffffd097          	auipc	ra,0xffffd
    80003a00:	456080e7          	jalr	1110(ra) # 80000e52 <myproc>
    80003a04:	5904                	lw	s1,48(a0)
    80003a06:	413484b3          	sub	s1,s1,s3
    80003a0a:	0014b493          	seqz	s1,s1
    80003a0e:	bfc1                	j	800039de <holdingsleep+0x24>

0000000080003a10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a10:	1141                	addi	sp,sp,-16
    80003a12:	e406                	sd	ra,8(sp)
    80003a14:	e022                	sd	s0,0(sp)
    80003a16:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a18:	00005597          	auipc	a1,0x5
    80003a1c:	c0058593          	addi	a1,a1,-1024 # 80008618 <syscalls+0x248>
    80003a20:	00016517          	auipc	a0,0x16
    80003a24:	82850513          	addi	a0,a0,-2008 # 80019248 <ftable>
    80003a28:	00002097          	auipc	ra,0x2
    80003a2c:	7c6080e7          	jalr	1990(ra) # 800061ee <initlock>
}
    80003a30:	60a2                	ld	ra,8(sp)
    80003a32:	6402                	ld	s0,0(sp)
    80003a34:	0141                	addi	sp,sp,16
    80003a36:	8082                	ret

0000000080003a38 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a38:	1101                	addi	sp,sp,-32
    80003a3a:	ec06                	sd	ra,24(sp)
    80003a3c:	e822                	sd	s0,16(sp)
    80003a3e:	e426                	sd	s1,8(sp)
    80003a40:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a42:	00016517          	auipc	a0,0x16
    80003a46:	80650513          	addi	a0,a0,-2042 # 80019248 <ftable>
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	834080e7          	jalr	-1996(ra) # 8000627e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a52:	00016497          	auipc	s1,0x16
    80003a56:	80e48493          	addi	s1,s1,-2034 # 80019260 <ftable+0x18>
    80003a5a:	00016717          	auipc	a4,0x16
    80003a5e:	7a670713          	addi	a4,a4,1958 # 8001a200 <disk>
    if(f->ref == 0){
    80003a62:	40dc                	lw	a5,4(s1)
    80003a64:	cf99                	beqz	a5,80003a82 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a66:	02848493          	addi	s1,s1,40
    80003a6a:	fee49ce3          	bne	s1,a4,80003a62 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	7da50513          	addi	a0,a0,2010 # 80019248 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	8bc080e7          	jalr	-1860(ra) # 80006332 <release>
  return 0;
    80003a7e:	4481                	li	s1,0
    80003a80:	a819                	j	80003a96 <filealloc+0x5e>
      f->ref = 1;
    80003a82:	4785                	li	a5,1
    80003a84:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a86:	00015517          	auipc	a0,0x15
    80003a8a:	7c250513          	addi	a0,a0,1986 # 80019248 <ftable>
    80003a8e:	00003097          	auipc	ra,0x3
    80003a92:	8a4080e7          	jalr	-1884(ra) # 80006332 <release>
}
    80003a96:	8526                	mv	a0,s1
    80003a98:	60e2                	ld	ra,24(sp)
    80003a9a:	6442                	ld	s0,16(sp)
    80003a9c:	64a2                	ld	s1,8(sp)
    80003a9e:	6105                	addi	sp,sp,32
    80003aa0:	8082                	ret

0000000080003aa2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003aa2:	1101                	addi	sp,sp,-32
    80003aa4:	ec06                	sd	ra,24(sp)
    80003aa6:	e822                	sd	s0,16(sp)
    80003aa8:	e426                	sd	s1,8(sp)
    80003aaa:	1000                	addi	s0,sp,32
    80003aac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aae:	00015517          	auipc	a0,0x15
    80003ab2:	79a50513          	addi	a0,a0,1946 # 80019248 <ftable>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	7c8080e7          	jalr	1992(ra) # 8000627e <acquire>
  if(f->ref < 1)
    80003abe:	40dc                	lw	a5,4(s1)
    80003ac0:	02f05263          	blez	a5,80003ae4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ac4:	2785                	addiw	a5,a5,1
    80003ac6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ac8:	00015517          	auipc	a0,0x15
    80003acc:	78050513          	addi	a0,a0,1920 # 80019248 <ftable>
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	862080e7          	jalr	-1950(ra) # 80006332 <release>
  return f;
}
    80003ad8:	8526                	mv	a0,s1
    80003ada:	60e2                	ld	ra,24(sp)
    80003adc:	6442                	ld	s0,16(sp)
    80003ade:	64a2                	ld	s1,8(sp)
    80003ae0:	6105                	addi	sp,sp,32
    80003ae2:	8082                	ret
    panic("filedup");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	b3c50513          	addi	a0,a0,-1220 # 80008620 <syscalls+0x250>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	284080e7          	jalr	644(ra) # 80005d70 <panic>

0000000080003af4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003af4:	7139                	addi	sp,sp,-64
    80003af6:	fc06                	sd	ra,56(sp)
    80003af8:	f822                	sd	s0,48(sp)
    80003afa:	f426                	sd	s1,40(sp)
    80003afc:	f04a                	sd	s2,32(sp)
    80003afe:	ec4e                	sd	s3,24(sp)
    80003b00:	e852                	sd	s4,16(sp)
    80003b02:	e456                	sd	s5,8(sp)
    80003b04:	0080                	addi	s0,sp,64
    80003b06:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b08:	00015517          	auipc	a0,0x15
    80003b0c:	74050513          	addi	a0,a0,1856 # 80019248 <ftable>
    80003b10:	00002097          	auipc	ra,0x2
    80003b14:	76e080e7          	jalr	1902(ra) # 8000627e <acquire>
  if(f->ref < 1)
    80003b18:	40dc                	lw	a5,4(s1)
    80003b1a:	06f05163          	blez	a5,80003b7c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b1e:	37fd                	addiw	a5,a5,-1
    80003b20:	0007871b          	sext.w	a4,a5
    80003b24:	c0dc                	sw	a5,4(s1)
    80003b26:	06e04363          	bgtz	a4,80003b8c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b2a:	0004a903          	lw	s2,0(s1)
    80003b2e:	0094ca83          	lbu	s5,9(s1)
    80003b32:	0104ba03          	ld	s4,16(s1)
    80003b36:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b3a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b3e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b42:	00015517          	auipc	a0,0x15
    80003b46:	70650513          	addi	a0,a0,1798 # 80019248 <ftable>
    80003b4a:	00002097          	auipc	ra,0x2
    80003b4e:	7e8080e7          	jalr	2024(ra) # 80006332 <release>

  if(ff.type == FD_PIPE){
    80003b52:	4785                	li	a5,1
    80003b54:	04f90d63          	beq	s2,a5,80003bae <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b58:	3979                	addiw	s2,s2,-2
    80003b5a:	4785                	li	a5,1
    80003b5c:	0527e063          	bltu	a5,s2,80003b9c <fileclose+0xa8>
    begin_op();
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	ad0080e7          	jalr	-1328(ra) # 80003630 <begin_op>
    iput(ff.ip);
    80003b68:	854e                	mv	a0,s3
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	2da080e7          	jalr	730(ra) # 80002e44 <iput>
    end_op();
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	b38080e7          	jalr	-1224(ra) # 800036aa <end_op>
    80003b7a:	a00d                	j	80003b9c <fileclose+0xa8>
    panic("fileclose");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	aac50513          	addi	a0,a0,-1364 # 80008628 <syscalls+0x258>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	1ec080e7          	jalr	492(ra) # 80005d70 <panic>
    release(&ftable.lock);
    80003b8c:	00015517          	auipc	a0,0x15
    80003b90:	6bc50513          	addi	a0,a0,1724 # 80019248 <ftable>
    80003b94:	00002097          	auipc	ra,0x2
    80003b98:	79e080e7          	jalr	1950(ra) # 80006332 <release>
  }
}
    80003b9c:	70e2                	ld	ra,56(sp)
    80003b9e:	7442                	ld	s0,48(sp)
    80003ba0:	74a2                	ld	s1,40(sp)
    80003ba2:	7902                	ld	s2,32(sp)
    80003ba4:	69e2                	ld	s3,24(sp)
    80003ba6:	6a42                	ld	s4,16(sp)
    80003ba8:	6aa2                	ld	s5,8(sp)
    80003baa:	6121                	addi	sp,sp,64
    80003bac:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bae:	85d6                	mv	a1,s5
    80003bb0:	8552                	mv	a0,s4
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	348080e7          	jalr	840(ra) # 80003efa <pipeclose>
    80003bba:	b7cd                	j	80003b9c <fileclose+0xa8>

0000000080003bbc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bbc:	715d                	addi	sp,sp,-80
    80003bbe:	e486                	sd	ra,72(sp)
    80003bc0:	e0a2                	sd	s0,64(sp)
    80003bc2:	fc26                	sd	s1,56(sp)
    80003bc4:	f84a                	sd	s2,48(sp)
    80003bc6:	f44e                	sd	s3,40(sp)
    80003bc8:	0880                	addi	s0,sp,80
    80003bca:	84aa                	mv	s1,a0
    80003bcc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bce:	ffffd097          	auipc	ra,0xffffd
    80003bd2:	284080e7          	jalr	644(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bd6:	409c                	lw	a5,0(s1)
    80003bd8:	37f9                	addiw	a5,a5,-2
    80003bda:	4705                	li	a4,1
    80003bdc:	04f76763          	bltu	a4,a5,80003c2a <filestat+0x6e>
    80003be0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003be2:	6c88                	ld	a0,24(s1)
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	0a6080e7          	jalr	166(ra) # 80002c8a <ilock>
    stati(f->ip, &st);
    80003bec:	fb840593          	addi	a1,s0,-72
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	322080e7          	jalr	802(ra) # 80002f14 <stati>
    iunlock(f->ip);
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	150080e7          	jalr	336(ra) # 80002d4c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c04:	46e1                	li	a3,24
    80003c06:	fb840613          	addi	a2,s0,-72
    80003c0a:	85ce                	mv	a1,s3
    80003c0c:	05093503          	ld	a0,80(s2)
    80003c10:	ffffd097          	auipc	ra,0xffffd
    80003c14:	f02080e7          	jalr	-254(ra) # 80000b12 <copyout>
    80003c18:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c1c:	60a6                	ld	ra,72(sp)
    80003c1e:	6406                	ld	s0,64(sp)
    80003c20:	74e2                	ld	s1,56(sp)
    80003c22:	7942                	ld	s2,48(sp)
    80003c24:	79a2                	ld	s3,40(sp)
    80003c26:	6161                	addi	sp,sp,80
    80003c28:	8082                	ret
  return -1;
    80003c2a:	557d                	li	a0,-1
    80003c2c:	bfc5                	j	80003c1c <filestat+0x60>

0000000080003c2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c2e:	7179                	addi	sp,sp,-48
    80003c30:	f406                	sd	ra,40(sp)
    80003c32:	f022                	sd	s0,32(sp)
    80003c34:	ec26                	sd	s1,24(sp)
    80003c36:	e84a                	sd	s2,16(sp)
    80003c38:	e44e                	sd	s3,8(sp)
    80003c3a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c3c:	00854783          	lbu	a5,8(a0)
    80003c40:	c3d5                	beqz	a5,80003ce4 <fileread+0xb6>
    80003c42:	84aa                	mv	s1,a0
    80003c44:	89ae                	mv	s3,a1
    80003c46:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c48:	411c                	lw	a5,0(a0)
    80003c4a:	4705                	li	a4,1
    80003c4c:	04e78963          	beq	a5,a4,80003c9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c50:	470d                	li	a4,3
    80003c52:	04e78d63          	beq	a5,a4,80003cac <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c56:	4709                	li	a4,2
    80003c58:	06e79e63          	bne	a5,a4,80003cd4 <fileread+0xa6>
    ilock(f->ip);
    80003c5c:	6d08                	ld	a0,24(a0)
    80003c5e:	fffff097          	auipc	ra,0xfffff
    80003c62:	02c080e7          	jalr	44(ra) # 80002c8a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c66:	874a                	mv	a4,s2
    80003c68:	5094                	lw	a3,32(s1)
    80003c6a:	864e                	mv	a2,s3
    80003c6c:	4585                	li	a1,1
    80003c6e:	6c88                	ld	a0,24(s1)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	2ce080e7          	jalr	718(ra) # 80002f3e <readi>
    80003c78:	892a                	mv	s2,a0
    80003c7a:	00a05563          	blez	a0,80003c84 <fileread+0x56>
      f->off += r;
    80003c7e:	509c                	lw	a5,32(s1)
    80003c80:	9fa9                	addw	a5,a5,a0
    80003c82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	0c6080e7          	jalr	198(ra) # 80002d4c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c8e:	854a                	mv	a0,s2
    80003c90:	70a2                	ld	ra,40(sp)
    80003c92:	7402                	ld	s0,32(sp)
    80003c94:	64e2                	ld	s1,24(sp)
    80003c96:	6942                	ld	s2,16(sp)
    80003c98:	69a2                	ld	s3,8(sp)
    80003c9a:	6145                	addi	sp,sp,48
    80003c9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c9e:	6908                	ld	a0,16(a0)
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	3c2080e7          	jalr	962(ra) # 80004062 <piperead>
    80003ca8:	892a                	mv	s2,a0
    80003caa:	b7d5                	j	80003c8e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cac:	02451783          	lh	a5,36(a0)
    80003cb0:	03079693          	slli	a3,a5,0x30
    80003cb4:	92c1                	srli	a3,a3,0x30
    80003cb6:	4725                	li	a4,9
    80003cb8:	02d76863          	bltu	a4,a3,80003ce8 <fileread+0xba>
    80003cbc:	0792                	slli	a5,a5,0x4
    80003cbe:	00015717          	auipc	a4,0x15
    80003cc2:	4ea70713          	addi	a4,a4,1258 # 800191a8 <devsw>
    80003cc6:	97ba                	add	a5,a5,a4
    80003cc8:	639c                	ld	a5,0(a5)
    80003cca:	c38d                	beqz	a5,80003cec <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ccc:	4505                	li	a0,1
    80003cce:	9782                	jalr	a5
    80003cd0:	892a                	mv	s2,a0
    80003cd2:	bf75                	j	80003c8e <fileread+0x60>
    panic("fileread");
    80003cd4:	00005517          	auipc	a0,0x5
    80003cd8:	96450513          	addi	a0,a0,-1692 # 80008638 <syscalls+0x268>
    80003cdc:	00002097          	auipc	ra,0x2
    80003ce0:	094080e7          	jalr	148(ra) # 80005d70 <panic>
    return -1;
    80003ce4:	597d                	li	s2,-1
    80003ce6:	b765                	j	80003c8e <fileread+0x60>
      return -1;
    80003ce8:	597d                	li	s2,-1
    80003cea:	b755                	j	80003c8e <fileread+0x60>
    80003cec:	597d                	li	s2,-1
    80003cee:	b745                	j	80003c8e <fileread+0x60>

0000000080003cf0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cf0:	00954783          	lbu	a5,9(a0)
    80003cf4:	10078e63          	beqz	a5,80003e10 <filewrite+0x120>
{
    80003cf8:	715d                	addi	sp,sp,-80
    80003cfa:	e486                	sd	ra,72(sp)
    80003cfc:	e0a2                	sd	s0,64(sp)
    80003cfe:	fc26                	sd	s1,56(sp)
    80003d00:	f84a                	sd	s2,48(sp)
    80003d02:	f44e                	sd	s3,40(sp)
    80003d04:	f052                	sd	s4,32(sp)
    80003d06:	ec56                	sd	s5,24(sp)
    80003d08:	e85a                	sd	s6,16(sp)
    80003d0a:	e45e                	sd	s7,8(sp)
    80003d0c:	e062                	sd	s8,0(sp)
    80003d0e:	0880                	addi	s0,sp,80
    80003d10:	892a                	mv	s2,a0
    80003d12:	8b2e                	mv	s6,a1
    80003d14:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d16:	411c                	lw	a5,0(a0)
    80003d18:	4705                	li	a4,1
    80003d1a:	02e78263          	beq	a5,a4,80003d3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d1e:	470d                	li	a4,3
    80003d20:	02e78563          	beq	a5,a4,80003d4a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d24:	4709                	li	a4,2
    80003d26:	0ce79d63          	bne	a5,a4,80003e00 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d2a:	0ac05b63          	blez	a2,80003de0 <filewrite+0xf0>
    int i = 0;
    80003d2e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d30:	6b85                	lui	s7,0x1
    80003d32:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d36:	6c05                	lui	s8,0x1
    80003d38:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d3c:	a851                	j	80003dd0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d3e:	6908                	ld	a0,16(a0)
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	22a080e7          	jalr	554(ra) # 80003f6a <pipewrite>
    80003d48:	a045                	j	80003de8 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d4a:	02451783          	lh	a5,36(a0)
    80003d4e:	03079693          	slli	a3,a5,0x30
    80003d52:	92c1                	srli	a3,a3,0x30
    80003d54:	4725                	li	a4,9
    80003d56:	0ad76f63          	bltu	a4,a3,80003e14 <filewrite+0x124>
    80003d5a:	0792                	slli	a5,a5,0x4
    80003d5c:	00015717          	auipc	a4,0x15
    80003d60:	44c70713          	addi	a4,a4,1100 # 800191a8 <devsw>
    80003d64:	97ba                	add	a5,a5,a4
    80003d66:	679c                	ld	a5,8(a5)
    80003d68:	cbc5                	beqz	a5,80003e18 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d6a:	4505                	li	a0,1
    80003d6c:	9782                	jalr	a5
    80003d6e:	a8ad                	j	80003de8 <filewrite+0xf8>
      if(n1 > max)
    80003d70:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	8bc080e7          	jalr	-1860(ra) # 80003630 <begin_op>
      ilock(f->ip);
    80003d7c:	01893503          	ld	a0,24(s2)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	f0a080e7          	jalr	-246(ra) # 80002c8a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d88:	8756                	mv	a4,s5
    80003d8a:	02092683          	lw	a3,32(s2)
    80003d8e:	01698633          	add	a2,s3,s6
    80003d92:	4585                	li	a1,1
    80003d94:	01893503          	ld	a0,24(s2)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	29e080e7          	jalr	670(ra) # 80003036 <writei>
    80003da0:	84aa                	mv	s1,a0
    80003da2:	00a05763          	blez	a0,80003db0 <filewrite+0xc0>
        f->off += r;
    80003da6:	02092783          	lw	a5,32(s2)
    80003daa:	9fa9                	addw	a5,a5,a0
    80003dac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db0:	01893503          	ld	a0,24(s2)
    80003db4:	fffff097          	auipc	ra,0xfffff
    80003db8:	f98080e7          	jalr	-104(ra) # 80002d4c <iunlock>
      end_op();
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	8ee080e7          	jalr	-1810(ra) # 800036aa <end_op>

      if(r != n1){
    80003dc4:	009a9f63          	bne	s5,s1,80003de2 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003dc8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dcc:	0149db63          	bge	s3,s4,80003de2 <filewrite+0xf2>
      int n1 = n - i;
    80003dd0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dd4:	0004879b          	sext.w	a5,s1
    80003dd8:	f8fbdce3          	bge	s7,a5,80003d70 <filewrite+0x80>
    80003ddc:	84e2                	mv	s1,s8
    80003dde:	bf49                	j	80003d70 <filewrite+0x80>
    int i = 0;
    80003de0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003de2:	033a1d63          	bne	s4,s3,80003e1c <filewrite+0x12c>
    80003de6:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003de8:	60a6                	ld	ra,72(sp)
    80003dea:	6406                	ld	s0,64(sp)
    80003dec:	74e2                	ld	s1,56(sp)
    80003dee:	7942                	ld	s2,48(sp)
    80003df0:	79a2                	ld	s3,40(sp)
    80003df2:	7a02                	ld	s4,32(sp)
    80003df4:	6ae2                	ld	s5,24(sp)
    80003df6:	6b42                	ld	s6,16(sp)
    80003df8:	6ba2                	ld	s7,8(sp)
    80003dfa:	6c02                	ld	s8,0(sp)
    80003dfc:	6161                	addi	sp,sp,80
    80003dfe:	8082                	ret
    panic("filewrite");
    80003e00:	00005517          	auipc	a0,0x5
    80003e04:	84850513          	addi	a0,a0,-1976 # 80008648 <syscalls+0x278>
    80003e08:	00002097          	auipc	ra,0x2
    80003e0c:	f68080e7          	jalr	-152(ra) # 80005d70 <panic>
    return -1;
    80003e10:	557d                	li	a0,-1
}
    80003e12:	8082                	ret
      return -1;
    80003e14:	557d                	li	a0,-1
    80003e16:	bfc9                	j	80003de8 <filewrite+0xf8>
    80003e18:	557d                	li	a0,-1
    80003e1a:	b7f9                	j	80003de8 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003e1c:	557d                	li	a0,-1
    80003e1e:	b7e9                	j	80003de8 <filewrite+0xf8>

0000000080003e20 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e20:	7179                	addi	sp,sp,-48
    80003e22:	f406                	sd	ra,40(sp)
    80003e24:	f022                	sd	s0,32(sp)
    80003e26:	ec26                	sd	s1,24(sp)
    80003e28:	e84a                	sd	s2,16(sp)
    80003e2a:	e44e                	sd	s3,8(sp)
    80003e2c:	e052                	sd	s4,0(sp)
    80003e2e:	1800                	addi	s0,sp,48
    80003e30:	84aa                	mv	s1,a0
    80003e32:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e34:	0005b023          	sd	zero,0(a1)
    80003e38:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	bfc080e7          	jalr	-1028(ra) # 80003a38 <filealloc>
    80003e44:	e088                	sd	a0,0(s1)
    80003e46:	c551                	beqz	a0,80003ed2 <pipealloc+0xb2>
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	bf0080e7          	jalr	-1040(ra) # 80003a38 <filealloc>
    80003e50:	00aa3023          	sd	a0,0(s4)
    80003e54:	c92d                	beqz	a0,80003ec6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e56:	ffffc097          	auipc	ra,0xffffc
    80003e5a:	2c4080e7          	jalr	708(ra) # 8000011a <kalloc>
    80003e5e:	892a                	mv	s2,a0
    80003e60:	c125                	beqz	a0,80003ec0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e62:	4985                	li	s3,1
    80003e64:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e68:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e6c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e70:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e74:	00004597          	auipc	a1,0x4
    80003e78:	7e458593          	addi	a1,a1,2020 # 80008658 <syscalls+0x288>
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	372080e7          	jalr	882(ra) # 800061ee <initlock>
  (*f0)->type = FD_PIPE;
    80003e84:	609c                	ld	a5,0(s1)
    80003e86:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e8a:	609c                	ld	a5,0(s1)
    80003e8c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e90:	609c                	ld	a5,0(s1)
    80003e92:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e96:	609c                	ld	a5,0(s1)
    80003e98:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e9c:	000a3783          	ld	a5,0(s4)
    80003ea0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ea4:	000a3783          	ld	a5,0(s4)
    80003ea8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eac:	000a3783          	ld	a5,0(s4)
    80003eb0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eb4:	000a3783          	ld	a5,0(s4)
    80003eb8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ebc:	4501                	li	a0,0
    80003ebe:	a025                	j	80003ee6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ec0:	6088                	ld	a0,0(s1)
    80003ec2:	e501                	bnez	a0,80003eca <pipealloc+0xaa>
    80003ec4:	a039                	j	80003ed2 <pipealloc+0xb2>
    80003ec6:	6088                	ld	a0,0(s1)
    80003ec8:	c51d                	beqz	a0,80003ef6 <pipealloc+0xd6>
    fileclose(*f0);
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	c2a080e7          	jalr	-982(ra) # 80003af4 <fileclose>
  if(*f1)
    80003ed2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ed6:	557d                	li	a0,-1
  if(*f1)
    80003ed8:	c799                	beqz	a5,80003ee6 <pipealloc+0xc6>
    fileclose(*f1);
    80003eda:	853e                	mv	a0,a5
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	c18080e7          	jalr	-1000(ra) # 80003af4 <fileclose>
  return -1;
    80003ee4:	557d                	li	a0,-1
}
    80003ee6:	70a2                	ld	ra,40(sp)
    80003ee8:	7402                	ld	s0,32(sp)
    80003eea:	64e2                	ld	s1,24(sp)
    80003eec:	6942                	ld	s2,16(sp)
    80003eee:	69a2                	ld	s3,8(sp)
    80003ef0:	6a02                	ld	s4,0(sp)
    80003ef2:	6145                	addi	sp,sp,48
    80003ef4:	8082                	ret
  return -1;
    80003ef6:	557d                	li	a0,-1
    80003ef8:	b7fd                	j	80003ee6 <pipealloc+0xc6>

0000000080003efa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003efa:	1101                	addi	sp,sp,-32
    80003efc:	ec06                	sd	ra,24(sp)
    80003efe:	e822                	sd	s0,16(sp)
    80003f00:	e426                	sd	s1,8(sp)
    80003f02:	e04a                	sd	s2,0(sp)
    80003f04:	1000                	addi	s0,sp,32
    80003f06:	84aa                	mv	s1,a0
    80003f08:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f0a:	00002097          	auipc	ra,0x2
    80003f0e:	374080e7          	jalr	884(ra) # 8000627e <acquire>
  if(writable){
    80003f12:	02090d63          	beqz	s2,80003f4c <pipeclose+0x52>
    pi->writeopen = 0;
    80003f16:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f1a:	21848513          	addi	a0,s1,536
    80003f1e:	ffffd097          	auipc	ra,0xffffd
    80003f22:	69a080e7          	jalr	1690(ra) # 800015b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f26:	2204b783          	ld	a5,544(s1)
    80003f2a:	eb95                	bnez	a5,80003f5e <pipeclose+0x64>
    release(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	404080e7          	jalr	1028(ra) # 80006332 <release>
    kfree((char*)pi);
    80003f36:	8526                	mv	a0,s1
    80003f38:	ffffc097          	auipc	ra,0xffffc
    80003f3c:	0e4080e7          	jalr	228(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f40:	60e2                	ld	ra,24(sp)
    80003f42:	6442                	ld	s0,16(sp)
    80003f44:	64a2                	ld	s1,8(sp)
    80003f46:	6902                	ld	s2,0(sp)
    80003f48:	6105                	addi	sp,sp,32
    80003f4a:	8082                	ret
    pi->readopen = 0;
    80003f4c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f50:	21c48513          	addi	a0,s1,540
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	664080e7          	jalr	1636(ra) # 800015b8 <wakeup>
    80003f5c:	b7e9                	j	80003f26 <pipeclose+0x2c>
    release(&pi->lock);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	3d2080e7          	jalr	978(ra) # 80006332 <release>
}
    80003f68:	bfe1                	j	80003f40 <pipeclose+0x46>

0000000080003f6a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f6a:	711d                	addi	sp,sp,-96
    80003f6c:	ec86                	sd	ra,88(sp)
    80003f6e:	e8a2                	sd	s0,80(sp)
    80003f70:	e4a6                	sd	s1,72(sp)
    80003f72:	e0ca                	sd	s2,64(sp)
    80003f74:	fc4e                	sd	s3,56(sp)
    80003f76:	f852                	sd	s4,48(sp)
    80003f78:	f456                	sd	s5,40(sp)
    80003f7a:	f05a                	sd	s6,32(sp)
    80003f7c:	ec5e                	sd	s7,24(sp)
    80003f7e:	e862                	sd	s8,16(sp)
    80003f80:	1080                	addi	s0,sp,96
    80003f82:	84aa                	mv	s1,a0
    80003f84:	8aae                	mv	s5,a1
    80003f86:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	eca080e7          	jalr	-310(ra) # 80000e52 <myproc>
    80003f90:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f92:	8526                	mv	a0,s1
    80003f94:	00002097          	auipc	ra,0x2
    80003f98:	2ea080e7          	jalr	746(ra) # 8000627e <acquire>
  while(i < n){
    80003f9c:	0b405663          	blez	s4,80004048 <pipewrite+0xde>
  int i = 0;
    80003fa0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fa4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fa8:	21c48b93          	addi	s7,s1,540
    80003fac:	a089                	j	80003fee <pipewrite+0x84>
      release(&pi->lock);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00002097          	auipc	ra,0x2
    80003fb4:	382080e7          	jalr	898(ra) # 80006332 <release>
      return -1;
    80003fb8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fba:	854a                	mv	a0,s2
    80003fbc:	60e6                	ld	ra,88(sp)
    80003fbe:	6446                	ld	s0,80(sp)
    80003fc0:	64a6                	ld	s1,72(sp)
    80003fc2:	6906                	ld	s2,64(sp)
    80003fc4:	79e2                	ld	s3,56(sp)
    80003fc6:	7a42                	ld	s4,48(sp)
    80003fc8:	7aa2                	ld	s5,40(sp)
    80003fca:	7b02                	ld	s6,32(sp)
    80003fcc:	6be2                	ld	s7,24(sp)
    80003fce:	6c42                	ld	s8,16(sp)
    80003fd0:	6125                	addi	sp,sp,96
    80003fd2:	8082                	ret
      wakeup(&pi->nread);
    80003fd4:	8562                	mv	a0,s8
    80003fd6:	ffffd097          	auipc	ra,0xffffd
    80003fda:	5e2080e7          	jalr	1506(ra) # 800015b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fde:	85a6                	mv	a1,s1
    80003fe0:	855e                	mv	a0,s7
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	572080e7          	jalr	1394(ra) # 80001554 <sleep>
  while(i < n){
    80003fea:	07495063          	bge	s2,s4,8000404a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fee:	2204a783          	lw	a5,544(s1)
    80003ff2:	dfd5                	beqz	a5,80003fae <pipewrite+0x44>
    80003ff4:	854e                	mv	a0,s3
    80003ff6:	ffffe097          	auipc	ra,0xffffe
    80003ffa:	806080e7          	jalr	-2042(ra) # 800017fc <killed>
    80003ffe:	f945                	bnez	a0,80003fae <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004000:	2184a783          	lw	a5,536(s1)
    80004004:	21c4a703          	lw	a4,540(s1)
    80004008:	2007879b          	addiw	a5,a5,512
    8000400c:	fcf704e3          	beq	a4,a5,80003fd4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004010:	4685                	li	a3,1
    80004012:	01590633          	add	a2,s2,s5
    80004016:	faf40593          	addi	a1,s0,-81
    8000401a:	0509b503          	ld	a0,80(s3)
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	b80080e7          	jalr	-1152(ra) # 80000b9e <copyin>
    80004026:	03650263          	beq	a0,s6,8000404a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000402a:	21c4a783          	lw	a5,540(s1)
    8000402e:	0017871b          	addiw	a4,a5,1
    80004032:	20e4ae23          	sw	a4,540(s1)
    80004036:	1ff7f793          	andi	a5,a5,511
    8000403a:	97a6                	add	a5,a5,s1
    8000403c:	faf44703          	lbu	a4,-81(s0)
    80004040:	00e78c23          	sb	a4,24(a5)
      i++;
    80004044:	2905                	addiw	s2,s2,1
    80004046:	b755                	j	80003fea <pipewrite+0x80>
  int i = 0;
    80004048:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000404a:	21848513          	addi	a0,s1,536
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	56a080e7          	jalr	1386(ra) # 800015b8 <wakeup>
  release(&pi->lock);
    80004056:	8526                	mv	a0,s1
    80004058:	00002097          	auipc	ra,0x2
    8000405c:	2da080e7          	jalr	730(ra) # 80006332 <release>
  return i;
    80004060:	bfa9                	j	80003fba <pipewrite+0x50>

0000000080004062 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004062:	715d                	addi	sp,sp,-80
    80004064:	e486                	sd	ra,72(sp)
    80004066:	e0a2                	sd	s0,64(sp)
    80004068:	fc26                	sd	s1,56(sp)
    8000406a:	f84a                	sd	s2,48(sp)
    8000406c:	f44e                	sd	s3,40(sp)
    8000406e:	f052                	sd	s4,32(sp)
    80004070:	ec56                	sd	s5,24(sp)
    80004072:	e85a                	sd	s6,16(sp)
    80004074:	0880                	addi	s0,sp,80
    80004076:	84aa                	mv	s1,a0
    80004078:	892e                	mv	s2,a1
    8000407a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000407c:	ffffd097          	auipc	ra,0xffffd
    80004080:	dd6080e7          	jalr	-554(ra) # 80000e52 <myproc>
    80004084:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	1f6080e7          	jalr	502(ra) # 8000627e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004090:	2184a703          	lw	a4,536(s1)
    80004094:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004098:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000409c:	02f71763          	bne	a4,a5,800040ca <piperead+0x68>
    800040a0:	2244a783          	lw	a5,548(s1)
    800040a4:	c39d                	beqz	a5,800040ca <piperead+0x68>
    if(killed(pr)){
    800040a6:	8552                	mv	a0,s4
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	754080e7          	jalr	1876(ra) # 800017fc <killed>
    800040b0:	e949                	bnez	a0,80004142 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b2:	85a6                	mv	a1,s1
    800040b4:	854e                	mv	a0,s3
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	49e080e7          	jalr	1182(ra) # 80001554 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040be:	2184a703          	lw	a4,536(s1)
    800040c2:	21c4a783          	lw	a5,540(s1)
    800040c6:	fcf70de3          	beq	a4,a5,800040a0 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ca:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040cc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ce:	05505463          	blez	s5,80004116 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040d2:	2184a783          	lw	a5,536(s1)
    800040d6:	21c4a703          	lw	a4,540(s1)
    800040da:	02f70e63          	beq	a4,a5,80004116 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040de:	0017871b          	addiw	a4,a5,1
    800040e2:	20e4ac23          	sw	a4,536(s1)
    800040e6:	1ff7f793          	andi	a5,a5,511
    800040ea:	97a6                	add	a5,a5,s1
    800040ec:	0187c783          	lbu	a5,24(a5)
    800040f0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f4:	4685                	li	a3,1
    800040f6:	fbf40613          	addi	a2,s0,-65
    800040fa:	85ca                	mv	a1,s2
    800040fc:	050a3503          	ld	a0,80(s4)
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	a12080e7          	jalr	-1518(ra) # 80000b12 <copyout>
    80004108:	01650763          	beq	a0,s6,80004116 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000410c:	2985                	addiw	s3,s3,1
    8000410e:	0905                	addi	s2,s2,1
    80004110:	fd3a91e3          	bne	s5,s3,800040d2 <piperead+0x70>
    80004114:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004116:	21c48513          	addi	a0,s1,540
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	49e080e7          	jalr	1182(ra) # 800015b8 <wakeup>
  release(&pi->lock);
    80004122:	8526                	mv	a0,s1
    80004124:	00002097          	auipc	ra,0x2
    80004128:	20e080e7          	jalr	526(ra) # 80006332 <release>
  return i;
}
    8000412c:	854e                	mv	a0,s3
    8000412e:	60a6                	ld	ra,72(sp)
    80004130:	6406                	ld	s0,64(sp)
    80004132:	74e2                	ld	s1,56(sp)
    80004134:	7942                	ld	s2,48(sp)
    80004136:	79a2                	ld	s3,40(sp)
    80004138:	7a02                	ld	s4,32(sp)
    8000413a:	6ae2                	ld	s5,24(sp)
    8000413c:	6b42                	ld	s6,16(sp)
    8000413e:	6161                	addi	sp,sp,80
    80004140:	8082                	ret
      release(&pi->lock);
    80004142:	8526                	mv	a0,s1
    80004144:	00002097          	auipc	ra,0x2
    80004148:	1ee080e7          	jalr	494(ra) # 80006332 <release>
      return -1;
    8000414c:	59fd                	li	s3,-1
    8000414e:	bff9                	j	8000412c <piperead+0xca>

0000000080004150 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004150:	1141                	addi	sp,sp,-16
    80004152:	e422                	sd	s0,8(sp)
    80004154:	0800                	addi	s0,sp,16
    80004156:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004158:	8905                	andi	a0,a0,1
    8000415a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000415c:	8b89                	andi	a5,a5,2
    8000415e:	c399                	beqz	a5,80004164 <flags2perm+0x14>
      perm |= PTE_W;
    80004160:	00456513          	ori	a0,a0,4
    return perm;
}
    80004164:	6422                	ld	s0,8(sp)
    80004166:	0141                	addi	sp,sp,16
    80004168:	8082                	ret

000000008000416a <exec>:

int
exec(char *path, char **argv)
{
    8000416a:	df010113          	addi	sp,sp,-528
    8000416e:	20113423          	sd	ra,520(sp)
    80004172:	20813023          	sd	s0,512(sp)
    80004176:	ffa6                	sd	s1,504(sp)
    80004178:	fbca                	sd	s2,496(sp)
    8000417a:	f7ce                	sd	s3,488(sp)
    8000417c:	f3d2                	sd	s4,480(sp)
    8000417e:	efd6                	sd	s5,472(sp)
    80004180:	ebda                	sd	s6,464(sp)
    80004182:	e7de                	sd	s7,456(sp)
    80004184:	e3e2                	sd	s8,448(sp)
    80004186:	ff66                	sd	s9,440(sp)
    80004188:	fb6a                	sd	s10,432(sp)
    8000418a:	f76e                	sd	s11,424(sp)
    8000418c:	0c00                	addi	s0,sp,528
    8000418e:	892a                	mv	s2,a0
    80004190:	dea43c23          	sd	a0,-520(s0)
    80004194:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	cba080e7          	jalr	-838(ra) # 80000e52 <myproc>
    800041a0:	84aa                	mv	s1,a0

  begin_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	48e080e7          	jalr	1166(ra) # 80003630 <begin_op>

  if((ip = namei(path)) == 0){
    800041aa:	854a                	mv	a0,s2
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	284080e7          	jalr	644(ra) # 80003430 <namei>
    800041b4:	c92d                	beqz	a0,80004226 <exec+0xbc>
    800041b6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	ad2080e7          	jalr	-1326(ra) # 80002c8a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041c0:	04000713          	li	a4,64
    800041c4:	4681                	li	a3,0
    800041c6:	e5040613          	addi	a2,s0,-432
    800041ca:	4581                	li	a1,0
    800041cc:	8552                	mv	a0,s4
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	d70080e7          	jalr	-656(ra) # 80002f3e <readi>
    800041d6:	04000793          	li	a5,64
    800041da:	00f51a63          	bne	a0,a5,800041ee <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041de:	e5042703          	lw	a4,-432(s0)
    800041e2:	464c47b7          	lui	a5,0x464c4
    800041e6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ea:	04f70463          	beq	a4,a5,80004232 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ee:	8552                	mv	a0,s4
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	cfc080e7          	jalr	-772(ra) # 80002eec <iunlockput>
    end_op();
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	4b2080e7          	jalr	1202(ra) # 800036aa <end_op>
  }
  return -1;
    80004200:	557d                	li	a0,-1
}
    80004202:	20813083          	ld	ra,520(sp)
    80004206:	20013403          	ld	s0,512(sp)
    8000420a:	74fe                	ld	s1,504(sp)
    8000420c:	795e                	ld	s2,496(sp)
    8000420e:	79be                	ld	s3,488(sp)
    80004210:	7a1e                	ld	s4,480(sp)
    80004212:	6afe                	ld	s5,472(sp)
    80004214:	6b5e                	ld	s6,464(sp)
    80004216:	6bbe                	ld	s7,456(sp)
    80004218:	6c1e                	ld	s8,448(sp)
    8000421a:	7cfa                	ld	s9,440(sp)
    8000421c:	7d5a                	ld	s10,432(sp)
    8000421e:	7dba                	ld	s11,424(sp)
    80004220:	21010113          	addi	sp,sp,528
    80004224:	8082                	ret
    end_op();
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	484080e7          	jalr	1156(ra) # 800036aa <end_op>
    return -1;
    8000422e:	557d                	li	a0,-1
    80004230:	bfc9                	j	80004202 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004232:	8526                	mv	a0,s1
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	ce2080e7          	jalr	-798(ra) # 80000f16 <proc_pagetable>
    8000423c:	8b2a                	mv	s6,a0
    8000423e:	d945                	beqz	a0,800041ee <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004240:	e7042d03          	lw	s10,-400(s0)
    80004244:	e8845783          	lhu	a5,-376(s0)
    80004248:	10078463          	beqz	a5,80004350 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000424c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000424e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004250:	6c85                	lui	s9,0x1
    80004252:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004256:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000425a:	6a85                	lui	s5,0x1
    8000425c:	a0b5                	j	800042c8 <exec+0x15e>
      panic("loadseg: address should exist");
    8000425e:	00004517          	auipc	a0,0x4
    80004262:	40250513          	addi	a0,a0,1026 # 80008660 <syscalls+0x290>
    80004266:	00002097          	auipc	ra,0x2
    8000426a:	b0a080e7          	jalr	-1270(ra) # 80005d70 <panic>
    if(sz - i < PGSIZE)
    8000426e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004270:	8726                	mv	a4,s1
    80004272:	012c06bb          	addw	a3,s8,s2
    80004276:	4581                	li	a1,0
    80004278:	8552                	mv	a0,s4
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	cc4080e7          	jalr	-828(ra) # 80002f3e <readi>
    80004282:	2501                	sext.w	a0,a0
    80004284:	24a49863          	bne	s1,a0,800044d4 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004288:	012a893b          	addw	s2,s5,s2
    8000428c:	03397563          	bgeu	s2,s3,800042b6 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004290:	02091593          	slli	a1,s2,0x20
    80004294:	9181                	srli	a1,a1,0x20
    80004296:	95de                	add	a1,a1,s7
    80004298:	855a                	mv	a0,s6
    8000429a:	ffffc097          	auipc	ra,0xffffc
    8000429e:	268080e7          	jalr	616(ra) # 80000502 <walkaddr>
    800042a2:	862a                	mv	a2,a0
    if(pa == 0)
    800042a4:	dd4d                	beqz	a0,8000425e <exec+0xf4>
    if(sz - i < PGSIZE)
    800042a6:	412984bb          	subw	s1,s3,s2
    800042aa:	0004879b          	sext.w	a5,s1
    800042ae:	fcfcf0e3          	bgeu	s9,a5,8000426e <exec+0x104>
    800042b2:	84d6                	mv	s1,s5
    800042b4:	bf6d                	j	8000426e <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042b6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ba:	2d85                	addiw	s11,s11,1
    800042bc:	038d0d1b          	addiw	s10,s10,56
    800042c0:	e8845783          	lhu	a5,-376(s0)
    800042c4:	08fdd763          	bge	s11,a5,80004352 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042c8:	2d01                	sext.w	s10,s10
    800042ca:	03800713          	li	a4,56
    800042ce:	86ea                	mv	a3,s10
    800042d0:	e1840613          	addi	a2,s0,-488
    800042d4:	4581                	li	a1,0
    800042d6:	8552                	mv	a0,s4
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	c66080e7          	jalr	-922(ra) # 80002f3e <readi>
    800042e0:	03800793          	li	a5,56
    800042e4:	1ef51663          	bne	a0,a5,800044d0 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800042e8:	e1842783          	lw	a5,-488(s0)
    800042ec:	4705                	li	a4,1
    800042ee:	fce796e3          	bne	a5,a4,800042ba <exec+0x150>
    if(ph.memsz < ph.filesz)
    800042f2:	e4043483          	ld	s1,-448(s0)
    800042f6:	e3843783          	ld	a5,-456(s0)
    800042fa:	1ef4e863          	bltu	s1,a5,800044ea <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042fe:	e2843783          	ld	a5,-472(s0)
    80004302:	94be                	add	s1,s1,a5
    80004304:	1ef4e663          	bltu	s1,a5,800044f0 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004308:	df043703          	ld	a4,-528(s0)
    8000430c:	8ff9                	and	a5,a5,a4
    8000430e:	1e079463          	bnez	a5,800044f6 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004312:	e1c42503          	lw	a0,-484(s0)
    80004316:	00000097          	auipc	ra,0x0
    8000431a:	e3a080e7          	jalr	-454(ra) # 80004150 <flags2perm>
    8000431e:	86aa                	mv	a3,a0
    80004320:	8626                	mv	a2,s1
    80004322:	85ca                	mv	a1,s2
    80004324:	855a                	mv	a0,s6
    80004326:	ffffc097          	auipc	ra,0xffffc
    8000432a:	590080e7          	jalr	1424(ra) # 800008b6 <uvmalloc>
    8000432e:	e0a43423          	sd	a0,-504(s0)
    80004332:	1c050563          	beqz	a0,800044fc <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004336:	e2843b83          	ld	s7,-472(s0)
    8000433a:	e2042c03          	lw	s8,-480(s0)
    8000433e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004342:	00098463          	beqz	s3,8000434a <exec+0x1e0>
    80004346:	4901                	li	s2,0
    80004348:	b7a1                	j	80004290 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000434a:	e0843903          	ld	s2,-504(s0)
    8000434e:	b7b5                	j	800042ba <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004350:	4901                	li	s2,0
  iunlockput(ip);
    80004352:	8552                	mv	a0,s4
    80004354:	fffff097          	auipc	ra,0xfffff
    80004358:	b98080e7          	jalr	-1128(ra) # 80002eec <iunlockput>
  end_op();
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	34e080e7          	jalr	846(ra) # 800036aa <end_op>
  p = myproc();
    80004364:	ffffd097          	auipc	ra,0xffffd
    80004368:	aee080e7          	jalr	-1298(ra) # 80000e52 <myproc>
    8000436c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000436e:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004372:	6985                	lui	s3,0x1
    80004374:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004376:	99ca                	add	s3,s3,s2
    80004378:	77fd                	lui	a5,0xfffff
    8000437a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000437e:	4691                	li	a3,4
    80004380:	6609                	lui	a2,0x2
    80004382:	964e                	add	a2,a2,s3
    80004384:	85ce                	mv	a1,s3
    80004386:	855a                	mv	a0,s6
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	52e080e7          	jalr	1326(ra) # 800008b6 <uvmalloc>
    80004390:	892a                	mv	s2,a0
    80004392:	e0a43423          	sd	a0,-504(s0)
    80004396:	e509                	bnez	a0,800043a0 <exec+0x236>
  if(pagetable)
    80004398:	e1343423          	sd	s3,-504(s0)
    8000439c:	4a01                	li	s4,0
    8000439e:	aa1d                	j	800044d4 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043a0:	75f9                	lui	a1,0xffffe
    800043a2:	95aa                	add	a1,a1,a0
    800043a4:	855a                	mv	a0,s6
    800043a6:	ffffc097          	auipc	ra,0xffffc
    800043aa:	73a080e7          	jalr	1850(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ae:	7bfd                	lui	s7,0xfffff
    800043b0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043b2:	e0043783          	ld	a5,-512(s0)
    800043b6:	6388                	ld	a0,0(a5)
    800043b8:	c52d                	beqz	a0,80004422 <exec+0x2b8>
    800043ba:	e9040993          	addi	s3,s0,-368
    800043be:	f9040c13          	addi	s8,s0,-112
    800043c2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	f30080e7          	jalr	-208(ra) # 800002f4 <strlen>
    800043cc:	0015079b          	addiw	a5,a0,1
    800043d0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043d8:	13796563          	bltu	s2,s7,80004502 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043dc:	e0043d03          	ld	s10,-512(s0)
    800043e0:	000d3a03          	ld	s4,0(s10)
    800043e4:	8552                	mv	a0,s4
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	f0e080e7          	jalr	-242(ra) # 800002f4 <strlen>
    800043ee:	0015069b          	addiw	a3,a0,1
    800043f2:	8652                	mv	a2,s4
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855a                	mv	a0,s6
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	71a080e7          	jalr	1818(ra) # 80000b12 <copyout>
    80004400:	10054363          	bltz	a0,80004506 <exec+0x39c>
    ustack[argc] = sp;
    80004404:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004408:	0485                	addi	s1,s1,1
    8000440a:	008d0793          	addi	a5,s10,8
    8000440e:	e0f43023          	sd	a5,-512(s0)
    80004412:	008d3503          	ld	a0,8(s10)
    80004416:	c909                	beqz	a0,80004428 <exec+0x2be>
    if(argc >= MAXARG)
    80004418:	09a1                	addi	s3,s3,8
    8000441a:	fb8995e3          	bne	s3,s8,800043c4 <exec+0x25a>
  ip = 0;
    8000441e:	4a01                	li	s4,0
    80004420:	a855                	j	800044d4 <exec+0x36a>
  sp = sz;
    80004422:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004426:	4481                	li	s1,0
  ustack[argc] = 0;
    80004428:	00349793          	slli	a5,s1,0x3
    8000442c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdca10>
    80004430:	97a2                	add	a5,a5,s0
    80004432:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004436:	00148693          	addi	a3,s1,1
    8000443a:	068e                	slli	a3,a3,0x3
    8000443c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004440:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004444:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004448:	f57968e3          	bltu	s2,s7,80004398 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000444c:	e9040613          	addi	a2,s0,-368
    80004450:	85ca                	mv	a1,s2
    80004452:	855a                	mv	a0,s6
    80004454:	ffffc097          	auipc	ra,0xffffc
    80004458:	6be080e7          	jalr	1726(ra) # 80000b12 <copyout>
    8000445c:	0a054763          	bltz	a0,8000450a <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004460:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004464:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004468:	df843783          	ld	a5,-520(s0)
    8000446c:	0007c703          	lbu	a4,0(a5)
    80004470:	cf11                	beqz	a4,8000448c <exec+0x322>
    80004472:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004474:	02f00693          	li	a3,47
    80004478:	a039                	j	80004486 <exec+0x31c>
      last = s+1;
    8000447a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000447e:	0785                	addi	a5,a5,1
    80004480:	fff7c703          	lbu	a4,-1(a5)
    80004484:	c701                	beqz	a4,8000448c <exec+0x322>
    if(*s == '/')
    80004486:	fed71ce3          	bne	a4,a3,8000447e <exec+0x314>
    8000448a:	bfc5                	j	8000447a <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000448c:	4641                	li	a2,16
    8000448e:	df843583          	ld	a1,-520(s0)
    80004492:	158a8513          	addi	a0,s5,344
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	e2c080e7          	jalr	-468(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    8000449e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044a2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800044a6:	e0843783          	ld	a5,-504(s0)
    800044aa:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044ae:	058ab783          	ld	a5,88(s5)
    800044b2:	e6843703          	ld	a4,-408(s0)
    800044b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044b8:	058ab783          	ld	a5,88(s5)
    800044bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c0:	85e6                	mv	a1,s9
    800044c2:	ffffd097          	auipc	ra,0xffffd
    800044c6:	af0080e7          	jalr	-1296(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ca:	0004851b          	sext.w	a0,s1
    800044ce:	bb15                	j	80004202 <exec+0x98>
    800044d0:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044d4:	e0843583          	ld	a1,-504(s0)
    800044d8:	855a                	mv	a0,s6
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	ad8080e7          	jalr	-1320(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    800044e2:	557d                	li	a0,-1
  if(ip){
    800044e4:	d00a0fe3          	beqz	s4,80004202 <exec+0x98>
    800044e8:	b319                	j	800041ee <exec+0x84>
    800044ea:	e1243423          	sd	s2,-504(s0)
    800044ee:	b7dd                	j	800044d4 <exec+0x36a>
    800044f0:	e1243423          	sd	s2,-504(s0)
    800044f4:	b7c5                	j	800044d4 <exec+0x36a>
    800044f6:	e1243423          	sd	s2,-504(s0)
    800044fa:	bfe9                	j	800044d4 <exec+0x36a>
    800044fc:	e1243423          	sd	s2,-504(s0)
    80004500:	bfd1                	j	800044d4 <exec+0x36a>
  ip = 0;
    80004502:	4a01                	li	s4,0
    80004504:	bfc1                	j	800044d4 <exec+0x36a>
    80004506:	4a01                	li	s4,0
  if(pagetable)
    80004508:	b7f1                	j	800044d4 <exec+0x36a>
  sz = sz1;
    8000450a:	e0843983          	ld	s3,-504(s0)
    8000450e:	b569                	j	80004398 <exec+0x22e>

0000000080004510 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004510:	7179                	addi	sp,sp,-48
    80004512:	f406                	sd	ra,40(sp)
    80004514:	f022                	sd	s0,32(sp)
    80004516:	ec26                	sd	s1,24(sp)
    80004518:	e84a                	sd	s2,16(sp)
    8000451a:	1800                	addi	s0,sp,48
    8000451c:	892e                	mv	s2,a1
    8000451e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004520:	fdc40593          	addi	a1,s0,-36
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	b90080e7          	jalr	-1136(ra) # 800020b4 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000452c:	fdc42703          	lw	a4,-36(s0)
    80004530:	47bd                	li	a5,15
    80004532:	02e7eb63          	bltu	a5,a4,80004568 <argfd+0x58>
    80004536:	ffffd097          	auipc	ra,0xffffd
    8000453a:	91c080e7          	jalr	-1764(ra) # 80000e52 <myproc>
    8000453e:	fdc42703          	lw	a4,-36(s0)
    80004542:	01a70793          	addi	a5,a4,26
    80004546:	078e                	slli	a5,a5,0x3
    80004548:	953e                	add	a0,a0,a5
    8000454a:	611c                	ld	a5,0(a0)
    8000454c:	c385                	beqz	a5,8000456c <argfd+0x5c>
    return -1;
  if(pfd)
    8000454e:	00090463          	beqz	s2,80004556 <argfd+0x46>
    *pfd = fd;
    80004552:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004556:	4501                	li	a0,0
  if(pf)
    80004558:	c091                	beqz	s1,8000455c <argfd+0x4c>
    *pf = f;
    8000455a:	e09c                	sd	a5,0(s1)
}
    8000455c:	70a2                	ld	ra,40(sp)
    8000455e:	7402                	ld	s0,32(sp)
    80004560:	64e2                	ld	s1,24(sp)
    80004562:	6942                	ld	s2,16(sp)
    80004564:	6145                	addi	sp,sp,48
    80004566:	8082                	ret
    return -1;
    80004568:	557d                	li	a0,-1
    8000456a:	bfcd                	j	8000455c <argfd+0x4c>
    8000456c:	557d                	li	a0,-1
    8000456e:	b7fd                	j	8000455c <argfd+0x4c>

0000000080004570 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004570:	1101                	addi	sp,sp,-32
    80004572:	ec06                	sd	ra,24(sp)
    80004574:	e822                	sd	s0,16(sp)
    80004576:	e426                	sd	s1,8(sp)
    80004578:	1000                	addi	s0,sp,32
    8000457a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	8d6080e7          	jalr	-1834(ra) # 80000e52 <myproc>
    80004584:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004586:	0d050793          	addi	a5,a0,208
    8000458a:	4501                	li	a0,0
    8000458c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000458e:	6398                	ld	a4,0(a5)
    80004590:	cb19                	beqz	a4,800045a6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004592:	2505                	addiw	a0,a0,1
    80004594:	07a1                	addi	a5,a5,8
    80004596:	fed51ce3          	bne	a0,a3,8000458e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000459a:	557d                	li	a0,-1
}
    8000459c:	60e2                	ld	ra,24(sp)
    8000459e:	6442                	ld	s0,16(sp)
    800045a0:	64a2                	ld	s1,8(sp)
    800045a2:	6105                	addi	sp,sp,32
    800045a4:	8082                	ret
      p->ofile[fd] = f;
    800045a6:	01a50793          	addi	a5,a0,26
    800045aa:	078e                	slli	a5,a5,0x3
    800045ac:	963e                	add	a2,a2,a5
    800045ae:	e204                	sd	s1,0(a2)
      return fd;
    800045b0:	b7f5                	j	8000459c <fdalloc+0x2c>

00000000800045b2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045b2:	715d                	addi	sp,sp,-80
    800045b4:	e486                	sd	ra,72(sp)
    800045b6:	e0a2                	sd	s0,64(sp)
    800045b8:	fc26                	sd	s1,56(sp)
    800045ba:	f84a                	sd	s2,48(sp)
    800045bc:	f44e                	sd	s3,40(sp)
    800045be:	f052                	sd	s4,32(sp)
    800045c0:	ec56                	sd	s5,24(sp)
    800045c2:	e85a                	sd	s6,16(sp)
    800045c4:	0880                	addi	s0,sp,80
    800045c6:	8b2e                	mv	s6,a1
    800045c8:	89b2                	mv	s3,a2
    800045ca:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045cc:	fb040593          	addi	a1,s0,-80
    800045d0:	fffff097          	auipc	ra,0xfffff
    800045d4:	e7e080e7          	jalr	-386(ra) # 8000344e <nameiparent>
    800045d8:	84aa                	mv	s1,a0
    800045da:	14050b63          	beqz	a0,80004730 <create+0x17e>
    return 0;

  ilock(dp);
    800045de:	ffffe097          	auipc	ra,0xffffe
    800045e2:	6ac080e7          	jalr	1708(ra) # 80002c8a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045e6:	4601                	li	a2,0
    800045e8:	fb040593          	addi	a1,s0,-80
    800045ec:	8526                	mv	a0,s1
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	b80080e7          	jalr	-1152(ra) # 8000316e <dirlookup>
    800045f6:	8aaa                	mv	s5,a0
    800045f8:	c921                	beqz	a0,80004648 <create+0x96>
    iunlockput(dp);
    800045fa:	8526                	mv	a0,s1
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	8f0080e7          	jalr	-1808(ra) # 80002eec <iunlockput>
    ilock(ip);
    80004604:	8556                	mv	a0,s5
    80004606:	ffffe097          	auipc	ra,0xffffe
    8000460a:	684080e7          	jalr	1668(ra) # 80002c8a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000460e:	4789                	li	a5,2
    80004610:	02fb1563          	bne	s6,a5,8000463a <create+0x88>
    80004614:	044ad783          	lhu	a5,68(s5)
    80004618:	37f9                	addiw	a5,a5,-2
    8000461a:	17c2                	slli	a5,a5,0x30
    8000461c:	93c1                	srli	a5,a5,0x30
    8000461e:	4705                	li	a4,1
    80004620:	00f76d63          	bltu	a4,a5,8000463a <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004624:	8556                	mv	a0,s5
    80004626:	60a6                	ld	ra,72(sp)
    80004628:	6406                	ld	s0,64(sp)
    8000462a:	74e2                	ld	s1,56(sp)
    8000462c:	7942                	ld	s2,48(sp)
    8000462e:	79a2                	ld	s3,40(sp)
    80004630:	7a02                	ld	s4,32(sp)
    80004632:	6ae2                	ld	s5,24(sp)
    80004634:	6b42                	ld	s6,16(sp)
    80004636:	6161                	addi	sp,sp,80
    80004638:	8082                	ret
    iunlockput(ip);
    8000463a:	8556                	mv	a0,s5
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	8b0080e7          	jalr	-1872(ra) # 80002eec <iunlockput>
    return 0;
    80004644:	4a81                	li	s5,0
    80004646:	bff9                	j	80004624 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004648:	85da                	mv	a1,s6
    8000464a:	4088                	lw	a0,0(s1)
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	4a6080e7          	jalr	1190(ra) # 80002af2 <ialloc>
    80004654:	8a2a                	mv	s4,a0
    80004656:	c529                	beqz	a0,800046a0 <create+0xee>
  ilock(ip);
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	632080e7          	jalr	1586(ra) # 80002c8a <ilock>
  ip->major = major;
    80004660:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004664:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004668:	4905                	li	s2,1
    8000466a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000466e:	8552                	mv	a0,s4
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	54e080e7          	jalr	1358(ra) # 80002bbe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004678:	032b0b63          	beq	s6,s2,800046ae <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000467c:	004a2603          	lw	a2,4(s4)
    80004680:	fb040593          	addi	a1,s0,-80
    80004684:	8526                	mv	a0,s1
    80004686:	fffff097          	auipc	ra,0xfffff
    8000468a:	cf8080e7          	jalr	-776(ra) # 8000337e <dirlink>
    8000468e:	06054f63          	bltz	a0,8000470c <create+0x15a>
  iunlockput(dp);
    80004692:	8526                	mv	a0,s1
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	858080e7          	jalr	-1960(ra) # 80002eec <iunlockput>
  return ip;
    8000469c:	8ad2                	mv	s5,s4
    8000469e:	b759                	j	80004624 <create+0x72>
    iunlockput(dp);
    800046a0:	8526                	mv	a0,s1
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	84a080e7          	jalr	-1974(ra) # 80002eec <iunlockput>
    return 0;
    800046aa:	8ad2                	mv	s5,s4
    800046ac:	bfa5                	j	80004624 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ae:	004a2603          	lw	a2,4(s4)
    800046b2:	00004597          	auipc	a1,0x4
    800046b6:	fce58593          	addi	a1,a1,-50 # 80008680 <syscalls+0x2b0>
    800046ba:	8552                	mv	a0,s4
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	cc2080e7          	jalr	-830(ra) # 8000337e <dirlink>
    800046c4:	04054463          	bltz	a0,8000470c <create+0x15a>
    800046c8:	40d0                	lw	a2,4(s1)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	fbe58593          	addi	a1,a1,-66 # 80008688 <syscalls+0x2b8>
    800046d2:	8552                	mv	a0,s4
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	caa080e7          	jalr	-854(ra) # 8000337e <dirlink>
    800046dc:	02054863          	bltz	a0,8000470c <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800046e0:	004a2603          	lw	a2,4(s4)
    800046e4:	fb040593          	addi	a1,s0,-80
    800046e8:	8526                	mv	a0,s1
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	c94080e7          	jalr	-876(ra) # 8000337e <dirlink>
    800046f2:	00054d63          	bltz	a0,8000470c <create+0x15a>
    dp->nlink++;  // for ".."
    800046f6:	04a4d783          	lhu	a5,74(s1)
    800046fa:	2785                	addiw	a5,a5,1
    800046fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffe097          	auipc	ra,0xffffe
    80004706:	4bc080e7          	jalr	1212(ra) # 80002bbe <iupdate>
    8000470a:	b761                	j	80004692 <create+0xe0>
  ip->nlink = 0;
    8000470c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004710:	8552                	mv	a0,s4
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	4ac080e7          	jalr	1196(ra) # 80002bbe <iupdate>
  iunlockput(ip);
    8000471a:	8552                	mv	a0,s4
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	7d0080e7          	jalr	2000(ra) # 80002eec <iunlockput>
  iunlockput(dp);
    80004724:	8526                	mv	a0,s1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	7c6080e7          	jalr	1990(ra) # 80002eec <iunlockput>
  return 0;
    8000472e:	bddd                	j	80004624 <create+0x72>
    return 0;
    80004730:	8aaa                	mv	s5,a0
    80004732:	bdcd                	j	80004624 <create+0x72>

0000000080004734 <sys_dup>:
{
    80004734:	7179                	addi	sp,sp,-48
    80004736:	f406                	sd	ra,40(sp)
    80004738:	f022                	sd	s0,32(sp)
    8000473a:	ec26                	sd	s1,24(sp)
    8000473c:	e84a                	sd	s2,16(sp)
    8000473e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004740:	fd840613          	addi	a2,s0,-40
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	dc8080e7          	jalr	-568(ra) # 80004510 <argfd>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004752:	02054363          	bltz	a0,80004778 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004756:	fd843903          	ld	s2,-40(s0)
    8000475a:	854a                	mv	a0,s2
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	e14080e7          	jalr	-492(ra) # 80004570 <fdalloc>
    80004764:	84aa                	mv	s1,a0
    return -1;
    80004766:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004768:	00054863          	bltz	a0,80004778 <sys_dup+0x44>
  filedup(f);
    8000476c:	854a                	mv	a0,s2
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	334080e7          	jalr	820(ra) # 80003aa2 <filedup>
  return fd;
    80004776:	87a6                	mv	a5,s1
}
    80004778:	853e                	mv	a0,a5
    8000477a:	70a2                	ld	ra,40(sp)
    8000477c:	7402                	ld	s0,32(sp)
    8000477e:	64e2                	ld	s1,24(sp)
    80004780:	6942                	ld	s2,16(sp)
    80004782:	6145                	addi	sp,sp,48
    80004784:	8082                	ret

0000000080004786 <sys_read>:
{
    80004786:	7179                	addi	sp,sp,-48
    80004788:	f406                	sd	ra,40(sp)
    8000478a:	f022                	sd	s0,32(sp)
    8000478c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000478e:	fd840593          	addi	a1,s0,-40
    80004792:	4505                	li	a0,1
    80004794:	ffffe097          	auipc	ra,0xffffe
    80004798:	940080e7          	jalr	-1728(ra) # 800020d4 <argaddr>
  argint(2, &n);
    8000479c:	fe440593          	addi	a1,s0,-28
    800047a0:	4509                	li	a0,2
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	912080e7          	jalr	-1774(ra) # 800020b4 <argint>
  if(argfd(0, 0, &f) < 0)
    800047aa:	fe840613          	addi	a2,s0,-24
    800047ae:	4581                	li	a1,0
    800047b0:	4501                	li	a0,0
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	d5e080e7          	jalr	-674(ra) # 80004510 <argfd>
    800047ba:	87aa                	mv	a5,a0
    return -1;
    800047bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047be:	0007cc63          	bltz	a5,800047d6 <sys_read+0x50>
  return fileread(f, p, n);
    800047c2:	fe442603          	lw	a2,-28(s0)
    800047c6:	fd843583          	ld	a1,-40(s0)
    800047ca:	fe843503          	ld	a0,-24(s0)
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	460080e7          	jalr	1120(ra) # 80003c2e <fileread>
}
    800047d6:	70a2                	ld	ra,40(sp)
    800047d8:	7402                	ld	s0,32(sp)
    800047da:	6145                	addi	sp,sp,48
    800047dc:	8082                	ret

00000000800047de <sys_write>:
{
    800047de:	7179                	addi	sp,sp,-48
    800047e0:	f406                	sd	ra,40(sp)
    800047e2:	f022                	sd	s0,32(sp)
    800047e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047e6:	fd840593          	addi	a1,s0,-40
    800047ea:	4505                	li	a0,1
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	8e8080e7          	jalr	-1816(ra) # 800020d4 <argaddr>
  argint(2, &n);
    800047f4:	fe440593          	addi	a1,s0,-28
    800047f8:	4509                	li	a0,2
    800047fa:	ffffe097          	auipc	ra,0xffffe
    800047fe:	8ba080e7          	jalr	-1862(ra) # 800020b4 <argint>
  if(argfd(0, 0, &f) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	d06080e7          	jalr	-762(ra) # 80004510 <argfd>
    80004812:	87aa                	mv	a5,a0
    return -1;
    80004814:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004816:	0007cc63          	bltz	a5,8000482e <sys_write+0x50>
  return filewrite(f, p, n);
    8000481a:	fe442603          	lw	a2,-28(s0)
    8000481e:	fd843583          	ld	a1,-40(s0)
    80004822:	fe843503          	ld	a0,-24(s0)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	4ca080e7          	jalr	1226(ra) # 80003cf0 <filewrite>
}
    8000482e:	70a2                	ld	ra,40(sp)
    80004830:	7402                	ld	s0,32(sp)
    80004832:	6145                	addi	sp,sp,48
    80004834:	8082                	ret

0000000080004836 <sys_close>:
{
    80004836:	1101                	addi	sp,sp,-32
    80004838:	ec06                	sd	ra,24(sp)
    8000483a:	e822                	sd	s0,16(sp)
    8000483c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000483e:	fe040613          	addi	a2,s0,-32
    80004842:	fec40593          	addi	a1,s0,-20
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	cc8080e7          	jalr	-824(ra) # 80004510 <argfd>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004852:	02054463          	bltz	a0,8000487a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004856:	ffffc097          	auipc	ra,0xffffc
    8000485a:	5fc080e7          	jalr	1532(ra) # 80000e52 <myproc>
    8000485e:	fec42783          	lw	a5,-20(s0)
    80004862:	07e9                	addi	a5,a5,26
    80004864:	078e                	slli	a5,a5,0x3
    80004866:	953e                	add	a0,a0,a5
    80004868:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000486c:	fe043503          	ld	a0,-32(s0)
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	284080e7          	jalr	644(ra) # 80003af4 <fileclose>
  return 0;
    80004878:	4781                	li	a5,0
}
    8000487a:	853e                	mv	a0,a5
    8000487c:	60e2                	ld	ra,24(sp)
    8000487e:	6442                	ld	s0,16(sp)
    80004880:	6105                	addi	sp,sp,32
    80004882:	8082                	ret

0000000080004884 <sys_fstat>:
{
    80004884:	1101                	addi	sp,sp,-32
    80004886:	ec06                	sd	ra,24(sp)
    80004888:	e822                	sd	s0,16(sp)
    8000488a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000488c:	fe040593          	addi	a1,s0,-32
    80004890:	4505                	li	a0,1
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	842080e7          	jalr	-1982(ra) # 800020d4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000489a:	fe840613          	addi	a2,s0,-24
    8000489e:	4581                	li	a1,0
    800048a0:	4501                	li	a0,0
    800048a2:	00000097          	auipc	ra,0x0
    800048a6:	c6e080e7          	jalr	-914(ra) # 80004510 <argfd>
    800048aa:	87aa                	mv	a5,a0
    return -1;
    800048ac:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048ae:	0007ca63          	bltz	a5,800048c2 <sys_fstat+0x3e>
  return filestat(f, st);
    800048b2:	fe043583          	ld	a1,-32(s0)
    800048b6:	fe843503          	ld	a0,-24(s0)
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	302080e7          	jalr	770(ra) # 80003bbc <filestat>
}
    800048c2:	60e2                	ld	ra,24(sp)
    800048c4:	6442                	ld	s0,16(sp)
    800048c6:	6105                	addi	sp,sp,32
    800048c8:	8082                	ret

00000000800048ca <sys_link>:
{
    800048ca:	7169                	addi	sp,sp,-304
    800048cc:	f606                	sd	ra,296(sp)
    800048ce:	f222                	sd	s0,288(sp)
    800048d0:	ee26                	sd	s1,280(sp)
    800048d2:	ea4a                	sd	s2,272(sp)
    800048d4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048d6:	08000613          	li	a2,128
    800048da:	ed040593          	addi	a1,s0,-304
    800048de:	4501                	li	a0,0
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	814080e7          	jalr	-2028(ra) # 800020f4 <argstr>
    return -1;
    800048e8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ea:	10054e63          	bltz	a0,80004a06 <sys_link+0x13c>
    800048ee:	08000613          	li	a2,128
    800048f2:	f5040593          	addi	a1,s0,-176
    800048f6:	4505                	li	a0,1
    800048f8:	ffffd097          	auipc	ra,0xffffd
    800048fc:	7fc080e7          	jalr	2044(ra) # 800020f4 <argstr>
    return -1;
    80004900:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004902:	10054263          	bltz	a0,80004a06 <sys_link+0x13c>
  begin_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	d2a080e7          	jalr	-726(ra) # 80003630 <begin_op>
  if((ip = namei(old)) == 0){
    8000490e:	ed040513          	addi	a0,s0,-304
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	b1e080e7          	jalr	-1250(ra) # 80003430 <namei>
    8000491a:	84aa                	mv	s1,a0
    8000491c:	c551                	beqz	a0,800049a8 <sys_link+0xde>
  ilock(ip);
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	36c080e7          	jalr	876(ra) # 80002c8a <ilock>
  if(ip->type == T_DIR){
    80004926:	04449703          	lh	a4,68(s1)
    8000492a:	4785                	li	a5,1
    8000492c:	08f70463          	beq	a4,a5,800049b4 <sys_link+0xea>
  ip->nlink++;
    80004930:	04a4d783          	lhu	a5,74(s1)
    80004934:	2785                	addiw	a5,a5,1
    80004936:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	282080e7          	jalr	642(ra) # 80002bbe <iupdate>
  iunlock(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	406080e7          	jalr	1030(ra) # 80002d4c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000494e:	fd040593          	addi	a1,s0,-48
    80004952:	f5040513          	addi	a0,s0,-176
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	af8080e7          	jalr	-1288(ra) # 8000344e <nameiparent>
    8000495e:	892a                	mv	s2,a0
    80004960:	c935                	beqz	a0,800049d4 <sys_link+0x10a>
  ilock(dp);
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	328080e7          	jalr	808(ra) # 80002c8a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000496a:	00092703          	lw	a4,0(s2)
    8000496e:	409c                	lw	a5,0(s1)
    80004970:	04f71d63          	bne	a4,a5,800049ca <sys_link+0x100>
    80004974:	40d0                	lw	a2,4(s1)
    80004976:	fd040593          	addi	a1,s0,-48
    8000497a:	854a                	mv	a0,s2
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	a02080e7          	jalr	-1534(ra) # 8000337e <dirlink>
    80004984:	04054363          	bltz	a0,800049ca <sys_link+0x100>
  iunlockput(dp);
    80004988:	854a                	mv	a0,s2
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	562080e7          	jalr	1378(ra) # 80002eec <iunlockput>
  iput(ip);
    80004992:	8526                	mv	a0,s1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	4b0080e7          	jalr	1200(ra) # 80002e44 <iput>
  end_op();
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	d0e080e7          	jalr	-754(ra) # 800036aa <end_op>
  return 0;
    800049a4:	4781                	li	a5,0
    800049a6:	a085                	j	80004a06 <sys_link+0x13c>
    end_op();
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	d02080e7          	jalr	-766(ra) # 800036aa <end_op>
    return -1;
    800049b0:	57fd                	li	a5,-1
    800049b2:	a891                	j	80004a06 <sys_link+0x13c>
    iunlockput(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	536080e7          	jalr	1334(ra) # 80002eec <iunlockput>
    end_op();
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	cec080e7          	jalr	-788(ra) # 800036aa <end_op>
    return -1;
    800049c6:	57fd                	li	a5,-1
    800049c8:	a83d                	j	80004a06 <sys_link+0x13c>
    iunlockput(dp);
    800049ca:	854a                	mv	a0,s2
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	520080e7          	jalr	1312(ra) # 80002eec <iunlockput>
  ilock(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	2b4080e7          	jalr	692(ra) # 80002c8a <ilock>
  ip->nlink--;
    800049de:	04a4d783          	lhu	a5,74(s1)
    800049e2:	37fd                	addiw	a5,a5,-1
    800049e4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	1d4080e7          	jalr	468(ra) # 80002bbe <iupdate>
  iunlockput(ip);
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	4f8080e7          	jalr	1272(ra) # 80002eec <iunlockput>
  end_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	cae080e7          	jalr	-850(ra) # 800036aa <end_op>
  return -1;
    80004a04:	57fd                	li	a5,-1
}
    80004a06:	853e                	mv	a0,a5
    80004a08:	70b2                	ld	ra,296(sp)
    80004a0a:	7412                	ld	s0,288(sp)
    80004a0c:	64f2                	ld	s1,280(sp)
    80004a0e:	6952                	ld	s2,272(sp)
    80004a10:	6155                	addi	sp,sp,304
    80004a12:	8082                	ret

0000000080004a14 <sys_unlink>:
{
    80004a14:	7151                	addi	sp,sp,-240
    80004a16:	f586                	sd	ra,232(sp)
    80004a18:	f1a2                	sd	s0,224(sp)
    80004a1a:	eda6                	sd	s1,216(sp)
    80004a1c:	e9ca                	sd	s2,208(sp)
    80004a1e:	e5ce                	sd	s3,200(sp)
    80004a20:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a22:	08000613          	li	a2,128
    80004a26:	f3040593          	addi	a1,s0,-208
    80004a2a:	4501                	li	a0,0
    80004a2c:	ffffd097          	auipc	ra,0xffffd
    80004a30:	6c8080e7          	jalr	1736(ra) # 800020f4 <argstr>
    80004a34:	18054163          	bltz	a0,80004bb6 <sys_unlink+0x1a2>
  begin_op();
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	bf8080e7          	jalr	-1032(ra) # 80003630 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a40:	fb040593          	addi	a1,s0,-80
    80004a44:	f3040513          	addi	a0,s0,-208
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	a06080e7          	jalr	-1530(ra) # 8000344e <nameiparent>
    80004a50:	84aa                	mv	s1,a0
    80004a52:	c979                	beqz	a0,80004b28 <sys_unlink+0x114>
  ilock(dp);
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	236080e7          	jalr	566(ra) # 80002c8a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a5c:	00004597          	auipc	a1,0x4
    80004a60:	c2458593          	addi	a1,a1,-988 # 80008680 <syscalls+0x2b0>
    80004a64:	fb040513          	addi	a0,s0,-80
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	6ec080e7          	jalr	1772(ra) # 80003154 <namecmp>
    80004a70:	14050a63          	beqz	a0,80004bc4 <sys_unlink+0x1b0>
    80004a74:	00004597          	auipc	a1,0x4
    80004a78:	c1458593          	addi	a1,a1,-1004 # 80008688 <syscalls+0x2b8>
    80004a7c:	fb040513          	addi	a0,s0,-80
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	6d4080e7          	jalr	1748(ra) # 80003154 <namecmp>
    80004a88:	12050e63          	beqz	a0,80004bc4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a8c:	f2c40613          	addi	a2,s0,-212
    80004a90:	fb040593          	addi	a1,s0,-80
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	6d8080e7          	jalr	1752(ra) # 8000316e <dirlookup>
    80004a9e:	892a                	mv	s2,a0
    80004aa0:	12050263          	beqz	a0,80004bc4 <sys_unlink+0x1b0>
  ilock(ip);
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	1e6080e7          	jalr	486(ra) # 80002c8a <ilock>
  if(ip->nlink < 1)
    80004aac:	04a91783          	lh	a5,74(s2)
    80004ab0:	08f05263          	blez	a5,80004b34 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ab4:	04491703          	lh	a4,68(s2)
    80004ab8:	4785                	li	a5,1
    80004aba:	08f70563          	beq	a4,a5,80004b44 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004abe:	4641                	li	a2,16
    80004ac0:	4581                	li	a1,0
    80004ac2:	fc040513          	addi	a0,s0,-64
    80004ac6:	ffffb097          	auipc	ra,0xffffb
    80004aca:	6b4080e7          	jalr	1716(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ace:	4741                	li	a4,16
    80004ad0:	f2c42683          	lw	a3,-212(s0)
    80004ad4:	fc040613          	addi	a2,s0,-64
    80004ad8:	4581                	li	a1,0
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	55a080e7          	jalr	1370(ra) # 80003036 <writei>
    80004ae4:	47c1                	li	a5,16
    80004ae6:	0af51563          	bne	a0,a5,80004b90 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004aea:	04491703          	lh	a4,68(s2)
    80004aee:	4785                	li	a5,1
    80004af0:	0af70863          	beq	a4,a5,80004ba0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	3f6080e7          	jalr	1014(ra) # 80002eec <iunlockput>
  ip->nlink--;
    80004afe:	04a95783          	lhu	a5,74(s2)
    80004b02:	37fd                	addiw	a5,a5,-1
    80004b04:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b08:	854a                	mv	a0,s2
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	0b4080e7          	jalr	180(ra) # 80002bbe <iupdate>
  iunlockput(ip);
    80004b12:	854a                	mv	a0,s2
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	3d8080e7          	jalr	984(ra) # 80002eec <iunlockput>
  end_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	b8e080e7          	jalr	-1138(ra) # 800036aa <end_op>
  return 0;
    80004b24:	4501                	li	a0,0
    80004b26:	a84d                	j	80004bd8 <sys_unlink+0x1c4>
    end_op();
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	b82080e7          	jalr	-1150(ra) # 800036aa <end_op>
    return -1;
    80004b30:	557d                	li	a0,-1
    80004b32:	a05d                	j	80004bd8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b34:	00004517          	auipc	a0,0x4
    80004b38:	b5c50513          	addi	a0,a0,-1188 # 80008690 <syscalls+0x2c0>
    80004b3c:	00001097          	auipc	ra,0x1
    80004b40:	234080e7          	jalr	564(ra) # 80005d70 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b44:	04c92703          	lw	a4,76(s2)
    80004b48:	02000793          	li	a5,32
    80004b4c:	f6e7f9e3          	bgeu	a5,a4,80004abe <sys_unlink+0xaa>
    80004b50:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b54:	4741                	li	a4,16
    80004b56:	86ce                	mv	a3,s3
    80004b58:	f1840613          	addi	a2,s0,-232
    80004b5c:	4581                	li	a1,0
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	3de080e7          	jalr	990(ra) # 80002f3e <readi>
    80004b68:	47c1                	li	a5,16
    80004b6a:	00f51b63          	bne	a0,a5,80004b80 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b6e:	f1845783          	lhu	a5,-232(s0)
    80004b72:	e7a1                	bnez	a5,80004bba <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b74:	29c1                	addiw	s3,s3,16
    80004b76:	04c92783          	lw	a5,76(s2)
    80004b7a:	fcf9ede3          	bltu	s3,a5,80004b54 <sys_unlink+0x140>
    80004b7e:	b781                	j	80004abe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b80:	00004517          	auipc	a0,0x4
    80004b84:	b2850513          	addi	a0,a0,-1240 # 800086a8 <syscalls+0x2d8>
    80004b88:	00001097          	auipc	ra,0x1
    80004b8c:	1e8080e7          	jalr	488(ra) # 80005d70 <panic>
    panic("unlink: writei");
    80004b90:	00004517          	auipc	a0,0x4
    80004b94:	b3050513          	addi	a0,a0,-1232 # 800086c0 <syscalls+0x2f0>
    80004b98:	00001097          	auipc	ra,0x1
    80004b9c:	1d8080e7          	jalr	472(ra) # 80005d70 <panic>
    dp->nlink--;
    80004ba0:	04a4d783          	lhu	a5,74(s1)
    80004ba4:	37fd                	addiw	a5,a5,-1
    80004ba6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	012080e7          	jalr	18(ra) # 80002bbe <iupdate>
    80004bb4:	b781                	j	80004af4 <sys_unlink+0xe0>
    return -1;
    80004bb6:	557d                	li	a0,-1
    80004bb8:	a005                	j	80004bd8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bba:	854a                	mv	a0,s2
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	330080e7          	jalr	816(ra) # 80002eec <iunlockput>
  iunlockput(dp);
    80004bc4:	8526                	mv	a0,s1
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	326080e7          	jalr	806(ra) # 80002eec <iunlockput>
  end_op();
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	adc080e7          	jalr	-1316(ra) # 800036aa <end_op>
  return -1;
    80004bd6:	557d                	li	a0,-1
}
    80004bd8:	70ae                	ld	ra,232(sp)
    80004bda:	740e                	ld	s0,224(sp)
    80004bdc:	64ee                	ld	s1,216(sp)
    80004bde:	694e                	ld	s2,208(sp)
    80004be0:	69ae                	ld	s3,200(sp)
    80004be2:	616d                	addi	sp,sp,240
    80004be4:	8082                	ret

0000000080004be6 <sys_open>:

uint64
sys_open(void)
{
    80004be6:	7131                	addi	sp,sp,-192
    80004be8:	fd06                	sd	ra,184(sp)
    80004bea:	f922                	sd	s0,176(sp)
    80004bec:	f526                	sd	s1,168(sp)
    80004bee:	f14a                	sd	s2,160(sp)
    80004bf0:	ed4e                	sd	s3,152(sp)
    80004bf2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004bf4:	f4c40593          	addi	a1,s0,-180
    80004bf8:	4505                	li	a0,1
    80004bfa:	ffffd097          	auipc	ra,0xffffd
    80004bfe:	4ba080e7          	jalr	1210(ra) # 800020b4 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c02:	08000613          	li	a2,128
    80004c06:	f5040593          	addi	a1,s0,-176
    80004c0a:	4501                	li	a0,0
    80004c0c:	ffffd097          	auipc	ra,0xffffd
    80004c10:	4e8080e7          	jalr	1256(ra) # 800020f4 <argstr>
    80004c14:	87aa                	mv	a5,a0
    return -1;
    80004c16:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c18:	0a07c863          	bltz	a5,80004cc8 <sys_open+0xe2>

  begin_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	a14080e7          	jalr	-1516(ra) # 80003630 <begin_op>

  if(omode & O_CREATE){
    80004c24:	f4c42783          	lw	a5,-180(s0)
    80004c28:	2007f793          	andi	a5,a5,512
    80004c2c:	cbdd                	beqz	a5,80004ce2 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004c2e:	4681                	li	a3,0
    80004c30:	4601                	li	a2,0
    80004c32:	4589                	li	a1,2
    80004c34:	f5040513          	addi	a0,s0,-176
    80004c38:	00000097          	auipc	ra,0x0
    80004c3c:	97a080e7          	jalr	-1670(ra) # 800045b2 <create>
    80004c40:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c42:	c951                	beqz	a0,80004cd6 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c44:	04449703          	lh	a4,68(s1)
    80004c48:	478d                	li	a5,3
    80004c4a:	00f71763          	bne	a4,a5,80004c58 <sys_open+0x72>
    80004c4e:	0464d703          	lhu	a4,70(s1)
    80004c52:	47a5                	li	a5,9
    80004c54:	0ce7ec63          	bltu	a5,a4,80004d2c <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	de0080e7          	jalr	-544(ra) # 80003a38 <filealloc>
    80004c60:	892a                	mv	s2,a0
    80004c62:	c56d                	beqz	a0,80004d4c <sys_open+0x166>
    80004c64:	00000097          	auipc	ra,0x0
    80004c68:	90c080e7          	jalr	-1780(ra) # 80004570 <fdalloc>
    80004c6c:	89aa                	mv	s3,a0
    80004c6e:	0c054a63          	bltz	a0,80004d42 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c72:	04449703          	lh	a4,68(s1)
    80004c76:	478d                	li	a5,3
    80004c78:	0ef70563          	beq	a4,a5,80004d62 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c7c:	4789                	li	a5,2
    80004c7e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c82:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c86:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c8a:	f4c42783          	lw	a5,-180(s0)
    80004c8e:	0017c713          	xori	a4,a5,1
    80004c92:	8b05                	andi	a4,a4,1
    80004c94:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c98:	0037f713          	andi	a4,a5,3
    80004c9c:	00e03733          	snez	a4,a4
    80004ca0:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ca4:	4007f793          	andi	a5,a5,1024
    80004ca8:	c791                	beqz	a5,80004cb4 <sys_open+0xce>
    80004caa:	04449703          	lh	a4,68(s1)
    80004cae:	4789                	li	a5,2
    80004cb0:	0cf70063          	beq	a4,a5,80004d70 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	096080e7          	jalr	150(ra) # 80002d4c <iunlock>
  end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	9ec080e7          	jalr	-1556(ra) # 800036aa <end_op>

  return fd;
    80004cc6:	854e                	mv	a0,s3
}
    80004cc8:	70ea                	ld	ra,184(sp)
    80004cca:	744a                	ld	s0,176(sp)
    80004ccc:	74aa                	ld	s1,168(sp)
    80004cce:	790a                	ld	s2,160(sp)
    80004cd0:	69ea                	ld	s3,152(sp)
    80004cd2:	6129                	addi	sp,sp,192
    80004cd4:	8082                	ret
      end_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	9d4080e7          	jalr	-1580(ra) # 800036aa <end_op>
      return -1;
    80004cde:	557d                	li	a0,-1
    80004ce0:	b7e5                	j	80004cc8 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004ce2:	f5040513          	addi	a0,s0,-176
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	74a080e7          	jalr	1866(ra) # 80003430 <namei>
    80004cee:	84aa                	mv	s1,a0
    80004cf0:	c905                	beqz	a0,80004d20 <sys_open+0x13a>
    ilock(ip);
    80004cf2:	ffffe097          	auipc	ra,0xffffe
    80004cf6:	f98080e7          	jalr	-104(ra) # 80002c8a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cfa:	04449703          	lh	a4,68(s1)
    80004cfe:	4785                	li	a5,1
    80004d00:	f4f712e3          	bne	a4,a5,80004c44 <sys_open+0x5e>
    80004d04:	f4c42783          	lw	a5,-180(s0)
    80004d08:	dba1                	beqz	a5,80004c58 <sys_open+0x72>
      iunlockput(ip);
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	1e0080e7          	jalr	480(ra) # 80002eec <iunlockput>
      end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	996080e7          	jalr	-1642(ra) # 800036aa <end_op>
      return -1;
    80004d1c:	557d                	li	a0,-1
    80004d1e:	b76d                	j	80004cc8 <sys_open+0xe2>
      end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	98a080e7          	jalr	-1654(ra) # 800036aa <end_op>
      return -1;
    80004d28:	557d                	li	a0,-1
    80004d2a:	bf79                	j	80004cc8 <sys_open+0xe2>
    iunlockput(ip);
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	1be080e7          	jalr	446(ra) # 80002eec <iunlockput>
    end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	974080e7          	jalr	-1676(ra) # 800036aa <end_op>
    return -1;
    80004d3e:	557d                	li	a0,-1
    80004d40:	b761                	j	80004cc8 <sys_open+0xe2>
      fileclose(f);
    80004d42:	854a                	mv	a0,s2
    80004d44:	fffff097          	auipc	ra,0xfffff
    80004d48:	db0080e7          	jalr	-592(ra) # 80003af4 <fileclose>
    iunlockput(ip);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	19e080e7          	jalr	414(ra) # 80002eec <iunlockput>
    end_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	954080e7          	jalr	-1708(ra) # 800036aa <end_op>
    return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	b7a5                	j	80004cc8 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d62:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d66:	04649783          	lh	a5,70(s1)
    80004d6a:	02f91223          	sh	a5,36(s2)
    80004d6e:	bf21                	j	80004c86 <sys_open+0xa0>
    itrunc(ip);
    80004d70:	8526                	mv	a0,s1
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	026080e7          	jalr	38(ra) # 80002d98 <itrunc>
    80004d7a:	bf2d                	j	80004cb4 <sys_open+0xce>

0000000080004d7c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d7c:	7175                	addi	sp,sp,-144
    80004d7e:	e506                	sd	ra,136(sp)
    80004d80:	e122                	sd	s0,128(sp)
    80004d82:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	8ac080e7          	jalr	-1876(ra) # 80003630 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d8c:	08000613          	li	a2,128
    80004d90:	f7040593          	addi	a1,s0,-144
    80004d94:	4501                	li	a0,0
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	35e080e7          	jalr	862(ra) # 800020f4 <argstr>
    80004d9e:	02054963          	bltz	a0,80004dd0 <sys_mkdir+0x54>
    80004da2:	4681                	li	a3,0
    80004da4:	4601                	li	a2,0
    80004da6:	4585                	li	a1,1
    80004da8:	f7040513          	addi	a0,s0,-144
    80004dac:	00000097          	auipc	ra,0x0
    80004db0:	806080e7          	jalr	-2042(ra) # 800045b2 <create>
    80004db4:	cd11                	beqz	a0,80004dd0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	136080e7          	jalr	310(ra) # 80002eec <iunlockput>
  end_op();
    80004dbe:	fffff097          	auipc	ra,0xfffff
    80004dc2:	8ec080e7          	jalr	-1812(ra) # 800036aa <end_op>
  return 0;
    80004dc6:	4501                	li	a0,0
}
    80004dc8:	60aa                	ld	ra,136(sp)
    80004dca:	640a                	ld	s0,128(sp)
    80004dcc:	6149                	addi	sp,sp,144
    80004dce:	8082                	ret
    end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	8da080e7          	jalr	-1830(ra) # 800036aa <end_op>
    return -1;
    80004dd8:	557d                	li	a0,-1
    80004dda:	b7fd                	j	80004dc8 <sys_mkdir+0x4c>

0000000080004ddc <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ddc:	7135                	addi	sp,sp,-160
    80004dde:	ed06                	sd	ra,152(sp)
    80004de0:	e922                	sd	s0,144(sp)
    80004de2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	84c080e7          	jalr	-1972(ra) # 80003630 <begin_op>
  argint(1, &major);
    80004dec:	f6c40593          	addi	a1,s0,-148
    80004df0:	4505                	li	a0,1
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	2c2080e7          	jalr	706(ra) # 800020b4 <argint>
  argint(2, &minor);
    80004dfa:	f6840593          	addi	a1,s0,-152
    80004dfe:	4509                	li	a0,2
    80004e00:	ffffd097          	auipc	ra,0xffffd
    80004e04:	2b4080e7          	jalr	692(ra) # 800020b4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e08:	08000613          	li	a2,128
    80004e0c:	f7040593          	addi	a1,s0,-144
    80004e10:	4501                	li	a0,0
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	2e2080e7          	jalr	738(ra) # 800020f4 <argstr>
    80004e1a:	02054b63          	bltz	a0,80004e50 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e1e:	f6841683          	lh	a3,-152(s0)
    80004e22:	f6c41603          	lh	a2,-148(s0)
    80004e26:	458d                	li	a1,3
    80004e28:	f7040513          	addi	a0,s0,-144
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	786080e7          	jalr	1926(ra) # 800045b2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e34:	cd11                	beqz	a0,80004e50 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	0b6080e7          	jalr	182(ra) # 80002eec <iunlockput>
  end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	86c080e7          	jalr	-1940(ra) # 800036aa <end_op>
  return 0;
    80004e46:	4501                	li	a0,0
}
    80004e48:	60ea                	ld	ra,152(sp)
    80004e4a:	644a                	ld	s0,144(sp)
    80004e4c:	610d                	addi	sp,sp,160
    80004e4e:	8082                	ret
    end_op();
    80004e50:	fffff097          	auipc	ra,0xfffff
    80004e54:	85a080e7          	jalr	-1958(ra) # 800036aa <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	b7fd                	j	80004e48 <sys_mknod+0x6c>

0000000080004e5c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e5c:	7135                	addi	sp,sp,-160
    80004e5e:	ed06                	sd	ra,152(sp)
    80004e60:	e922                	sd	s0,144(sp)
    80004e62:	e526                	sd	s1,136(sp)
    80004e64:	e14a                	sd	s2,128(sp)
    80004e66:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e68:	ffffc097          	auipc	ra,0xffffc
    80004e6c:	fea080e7          	jalr	-22(ra) # 80000e52 <myproc>
    80004e70:	892a                	mv	s2,a0
  
  begin_op();
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	7be080e7          	jalr	1982(ra) # 80003630 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e7a:	08000613          	li	a2,128
    80004e7e:	f6040593          	addi	a1,s0,-160
    80004e82:	4501                	li	a0,0
    80004e84:	ffffd097          	auipc	ra,0xffffd
    80004e88:	270080e7          	jalr	624(ra) # 800020f4 <argstr>
    80004e8c:	04054b63          	bltz	a0,80004ee2 <sys_chdir+0x86>
    80004e90:	f6040513          	addi	a0,s0,-160
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	59c080e7          	jalr	1436(ra) # 80003430 <namei>
    80004e9c:	84aa                	mv	s1,a0
    80004e9e:	c131                	beqz	a0,80004ee2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ea0:	ffffe097          	auipc	ra,0xffffe
    80004ea4:	dea080e7          	jalr	-534(ra) # 80002c8a <ilock>
  if(ip->type != T_DIR){
    80004ea8:	04449703          	lh	a4,68(s1)
    80004eac:	4785                	li	a5,1
    80004eae:	04f71063          	bne	a4,a5,80004eee <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	e98080e7          	jalr	-360(ra) # 80002d4c <iunlock>
  iput(p->cwd);
    80004ebc:	15093503          	ld	a0,336(s2)
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	f84080e7          	jalr	-124(ra) # 80002e44 <iput>
  end_op();
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	7e2080e7          	jalr	2018(ra) # 800036aa <end_op>
  p->cwd = ip;
    80004ed0:	14993823          	sd	s1,336(s2)
  return 0;
    80004ed4:	4501                	li	a0,0
}
    80004ed6:	60ea                	ld	ra,152(sp)
    80004ed8:	644a                	ld	s0,144(sp)
    80004eda:	64aa                	ld	s1,136(sp)
    80004edc:	690a                	ld	s2,128(sp)
    80004ede:	610d                	addi	sp,sp,160
    80004ee0:	8082                	ret
    end_op();
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	7c8080e7          	jalr	1992(ra) # 800036aa <end_op>
    return -1;
    80004eea:	557d                	li	a0,-1
    80004eec:	b7ed                	j	80004ed6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004eee:	8526                	mv	a0,s1
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	ffc080e7          	jalr	-4(ra) # 80002eec <iunlockput>
    end_op();
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	7b2080e7          	jalr	1970(ra) # 800036aa <end_op>
    return -1;
    80004f00:	557d                	li	a0,-1
    80004f02:	bfd1                	j	80004ed6 <sys_chdir+0x7a>

0000000080004f04 <sys_exec>:

uint64
sys_exec(void)
{
    80004f04:	7121                	addi	sp,sp,-448
    80004f06:	ff06                	sd	ra,440(sp)
    80004f08:	fb22                	sd	s0,432(sp)
    80004f0a:	f726                	sd	s1,424(sp)
    80004f0c:	f34a                	sd	s2,416(sp)
    80004f0e:	ef4e                	sd	s3,408(sp)
    80004f10:	eb52                	sd	s4,400(sp)
    80004f12:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f14:	e4840593          	addi	a1,s0,-440
    80004f18:	4505                	li	a0,1
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	1ba080e7          	jalr	442(ra) # 800020d4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f22:	08000613          	li	a2,128
    80004f26:	f5040593          	addi	a1,s0,-176
    80004f2a:	4501                	li	a0,0
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	1c8080e7          	jalr	456(ra) # 800020f4 <argstr>
    80004f34:	87aa                	mv	a5,a0
    return -1;
    80004f36:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f38:	0c07c263          	bltz	a5,80004ffc <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004f3c:	10000613          	li	a2,256
    80004f40:	4581                	li	a1,0
    80004f42:	e5040513          	addi	a0,s0,-432
    80004f46:	ffffb097          	auipc	ra,0xffffb
    80004f4a:	234080e7          	jalr	564(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f4e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f52:	89a6                	mv	s3,s1
    80004f54:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f56:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f5a:	00391513          	slli	a0,s2,0x3
    80004f5e:	e4040593          	addi	a1,s0,-448
    80004f62:	e4843783          	ld	a5,-440(s0)
    80004f66:	953e                	add	a0,a0,a5
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	0ae080e7          	jalr	174(ra) # 80002016 <fetchaddr>
    80004f70:	02054a63          	bltz	a0,80004fa4 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f74:	e4043783          	ld	a5,-448(s0)
    80004f78:	c3b9                	beqz	a5,80004fbe <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f7a:	ffffb097          	auipc	ra,0xffffb
    80004f7e:	1a0080e7          	jalr	416(ra) # 8000011a <kalloc>
    80004f82:	85aa                	mv	a1,a0
    80004f84:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f88:	cd11                	beqz	a0,80004fa4 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f8a:	6605                	lui	a2,0x1
    80004f8c:	e4043503          	ld	a0,-448(s0)
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	0d8080e7          	jalr	216(ra) # 80002068 <fetchstr>
    80004f98:	00054663          	bltz	a0,80004fa4 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f9c:	0905                	addi	s2,s2,1
    80004f9e:	09a1                	addi	s3,s3,8
    80004fa0:	fb491de3          	bne	s2,s4,80004f5a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa4:	f5040913          	addi	s2,s0,-176
    80004fa8:	6088                	ld	a0,0(s1)
    80004faa:	c921                	beqz	a0,80004ffa <sys_exec+0xf6>
    kfree(argv[i]);
    80004fac:	ffffb097          	auipc	ra,0xffffb
    80004fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb4:	04a1                	addi	s1,s1,8
    80004fb6:	ff2499e3          	bne	s1,s2,80004fa8 <sys_exec+0xa4>
  return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	a081                	j	80004ffc <sys_exec+0xf8>
      argv[i] = 0;
    80004fbe:	0009079b          	sext.w	a5,s2
    80004fc2:	078e                	slli	a5,a5,0x3
    80004fc4:	fd078793          	addi	a5,a5,-48
    80004fc8:	97a2                	add	a5,a5,s0
    80004fca:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004fce:	e5040593          	addi	a1,s0,-432
    80004fd2:	f5040513          	addi	a0,s0,-176
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	194080e7          	jalr	404(ra) # 8000416a <exec>
    80004fde:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe0:	f5040993          	addi	s3,s0,-176
    80004fe4:	6088                	ld	a0,0(s1)
    80004fe6:	c901                	beqz	a0,80004ff6 <sys_exec+0xf2>
    kfree(argv[i]);
    80004fe8:	ffffb097          	auipc	ra,0xffffb
    80004fec:	034080e7          	jalr	52(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff0:	04a1                	addi	s1,s1,8
    80004ff2:	ff3499e3          	bne	s1,s3,80004fe4 <sys_exec+0xe0>
  return ret;
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	a011                	j	80004ffc <sys_exec+0xf8>
  return -1;
    80004ffa:	557d                	li	a0,-1
}
    80004ffc:	70fa                	ld	ra,440(sp)
    80004ffe:	745a                	ld	s0,432(sp)
    80005000:	74ba                	ld	s1,424(sp)
    80005002:	791a                	ld	s2,416(sp)
    80005004:	69fa                	ld	s3,408(sp)
    80005006:	6a5a                	ld	s4,400(sp)
    80005008:	6139                	addi	sp,sp,448
    8000500a:	8082                	ret

000000008000500c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000500c:	7139                	addi	sp,sp,-64
    8000500e:	fc06                	sd	ra,56(sp)
    80005010:	f822                	sd	s0,48(sp)
    80005012:	f426                	sd	s1,40(sp)
    80005014:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005016:	ffffc097          	auipc	ra,0xffffc
    8000501a:	e3c080e7          	jalr	-452(ra) # 80000e52 <myproc>
    8000501e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005020:	fd840593          	addi	a1,s0,-40
    80005024:	4501                	li	a0,0
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	0ae080e7          	jalr	174(ra) # 800020d4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000502e:	fc840593          	addi	a1,s0,-56
    80005032:	fd040513          	addi	a0,s0,-48
    80005036:	fffff097          	auipc	ra,0xfffff
    8000503a:	dea080e7          	jalr	-534(ra) # 80003e20 <pipealloc>
    return -1;
    8000503e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005040:	0c054463          	bltz	a0,80005108 <sys_pipe+0xfc>
  fd0 = -1;
    80005044:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005048:	fd043503          	ld	a0,-48(s0)
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	524080e7          	jalr	1316(ra) # 80004570 <fdalloc>
    80005054:	fca42223          	sw	a0,-60(s0)
    80005058:	08054b63          	bltz	a0,800050ee <sys_pipe+0xe2>
    8000505c:	fc843503          	ld	a0,-56(s0)
    80005060:	fffff097          	auipc	ra,0xfffff
    80005064:	510080e7          	jalr	1296(ra) # 80004570 <fdalloc>
    80005068:	fca42023          	sw	a0,-64(s0)
    8000506c:	06054863          	bltz	a0,800050dc <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005070:	4691                	li	a3,4
    80005072:	fc440613          	addi	a2,s0,-60
    80005076:	fd843583          	ld	a1,-40(s0)
    8000507a:	68a8                	ld	a0,80(s1)
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	a96080e7          	jalr	-1386(ra) # 80000b12 <copyout>
    80005084:	02054063          	bltz	a0,800050a4 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005088:	4691                	li	a3,4
    8000508a:	fc040613          	addi	a2,s0,-64
    8000508e:	fd843583          	ld	a1,-40(s0)
    80005092:	0591                	addi	a1,a1,4
    80005094:	68a8                	ld	a0,80(s1)
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	a7c080e7          	jalr	-1412(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000509e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a0:	06055463          	bgez	a0,80005108 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050a4:	fc442783          	lw	a5,-60(s0)
    800050a8:	07e9                	addi	a5,a5,26
    800050aa:	078e                	slli	a5,a5,0x3
    800050ac:	97a6                	add	a5,a5,s1
    800050ae:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050b2:	fc042783          	lw	a5,-64(s0)
    800050b6:	07e9                	addi	a5,a5,26
    800050b8:	078e                	slli	a5,a5,0x3
    800050ba:	94be                	add	s1,s1,a5
    800050bc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050c0:	fd043503          	ld	a0,-48(s0)
    800050c4:	fffff097          	auipc	ra,0xfffff
    800050c8:	a30080e7          	jalr	-1488(ra) # 80003af4 <fileclose>
    fileclose(wf);
    800050cc:	fc843503          	ld	a0,-56(s0)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	a24080e7          	jalr	-1500(ra) # 80003af4 <fileclose>
    return -1;
    800050d8:	57fd                	li	a5,-1
    800050da:	a03d                	j	80005108 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800050dc:	fc442783          	lw	a5,-60(s0)
    800050e0:	0007c763          	bltz	a5,800050ee <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800050e4:	07e9                	addi	a5,a5,26
    800050e6:	078e                	slli	a5,a5,0x3
    800050e8:	97a6                	add	a5,a5,s1
    800050ea:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050ee:	fd043503          	ld	a0,-48(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	a02080e7          	jalr	-1534(ra) # 80003af4 <fileclose>
    fileclose(wf);
    800050fa:	fc843503          	ld	a0,-56(s0)
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	9f6080e7          	jalr	-1546(ra) # 80003af4 <fileclose>
    return -1;
    80005106:	57fd                	li	a5,-1
}
    80005108:	853e                	mv	a0,a5
    8000510a:	70e2                	ld	ra,56(sp)
    8000510c:	7442                	ld	s0,48(sp)
    8000510e:	74a2                	ld	s1,40(sp)
    80005110:	6121                	addi	sp,sp,64
    80005112:	8082                	ret
	...

0000000080005120 <kernelvec>:
    80005120:	7111                	addi	sp,sp,-256
    80005122:	e006                	sd	ra,0(sp)
    80005124:	e40a                	sd	sp,8(sp)
    80005126:	e80e                	sd	gp,16(sp)
    80005128:	ec12                	sd	tp,24(sp)
    8000512a:	f016                	sd	t0,32(sp)
    8000512c:	f41a                	sd	t1,40(sp)
    8000512e:	f81e                	sd	t2,48(sp)
    80005130:	fc22                	sd	s0,56(sp)
    80005132:	e0a6                	sd	s1,64(sp)
    80005134:	e4aa                	sd	a0,72(sp)
    80005136:	e8ae                	sd	a1,80(sp)
    80005138:	ecb2                	sd	a2,88(sp)
    8000513a:	f0b6                	sd	a3,96(sp)
    8000513c:	f4ba                	sd	a4,104(sp)
    8000513e:	f8be                	sd	a5,112(sp)
    80005140:	fcc2                	sd	a6,120(sp)
    80005142:	e146                	sd	a7,128(sp)
    80005144:	e54a                	sd	s2,136(sp)
    80005146:	e94e                	sd	s3,144(sp)
    80005148:	ed52                	sd	s4,152(sp)
    8000514a:	f156                	sd	s5,160(sp)
    8000514c:	f55a                	sd	s6,168(sp)
    8000514e:	f95e                	sd	s7,176(sp)
    80005150:	fd62                	sd	s8,184(sp)
    80005152:	e1e6                	sd	s9,192(sp)
    80005154:	e5ea                	sd	s10,200(sp)
    80005156:	e9ee                	sd	s11,208(sp)
    80005158:	edf2                	sd	t3,216(sp)
    8000515a:	f1f6                	sd	t4,224(sp)
    8000515c:	f5fa                	sd	t5,232(sp)
    8000515e:	f9fe                	sd	t6,240(sp)
    80005160:	d83fc0ef          	jal	ra,80001ee2 <kerneltrap>
    80005164:	6082                	ld	ra,0(sp)
    80005166:	6122                	ld	sp,8(sp)
    80005168:	61c2                	ld	gp,16(sp)
    8000516a:	7282                	ld	t0,32(sp)
    8000516c:	7322                	ld	t1,40(sp)
    8000516e:	73c2                	ld	t2,48(sp)
    80005170:	7462                	ld	s0,56(sp)
    80005172:	6486                	ld	s1,64(sp)
    80005174:	6526                	ld	a0,72(sp)
    80005176:	65c6                	ld	a1,80(sp)
    80005178:	6666                	ld	a2,88(sp)
    8000517a:	7686                	ld	a3,96(sp)
    8000517c:	7726                	ld	a4,104(sp)
    8000517e:	77c6                	ld	a5,112(sp)
    80005180:	7866                	ld	a6,120(sp)
    80005182:	688a                	ld	a7,128(sp)
    80005184:	692a                	ld	s2,136(sp)
    80005186:	69ca                	ld	s3,144(sp)
    80005188:	6a6a                	ld	s4,152(sp)
    8000518a:	7a8a                	ld	s5,160(sp)
    8000518c:	7b2a                	ld	s6,168(sp)
    8000518e:	7bca                	ld	s7,176(sp)
    80005190:	7c6a                	ld	s8,184(sp)
    80005192:	6c8e                	ld	s9,192(sp)
    80005194:	6d2e                	ld	s10,200(sp)
    80005196:	6dce                	ld	s11,208(sp)
    80005198:	6e6e                	ld	t3,216(sp)
    8000519a:	7e8e                	ld	t4,224(sp)
    8000519c:	7f2e                	ld	t5,232(sp)
    8000519e:	7fce                	ld	t6,240(sp)
    800051a0:	6111                	addi	sp,sp,256
    800051a2:	10200073          	sret
    800051a6:	00000013          	nop
    800051aa:	00000013          	nop
    800051ae:	0001                	nop

00000000800051b0 <timervec>:
    800051b0:	34051573          	csrrw	a0,mscratch,a0
    800051b4:	e10c                	sd	a1,0(a0)
    800051b6:	e510                	sd	a2,8(a0)
    800051b8:	e914                	sd	a3,16(a0)
    800051ba:	6d0c                	ld	a1,24(a0)
    800051bc:	7110                	ld	a2,32(a0)
    800051be:	6194                	ld	a3,0(a1)
    800051c0:	96b2                	add	a3,a3,a2
    800051c2:	e194                	sd	a3,0(a1)
    800051c4:	4589                	li	a1,2
    800051c6:	14459073          	csrw	sip,a1
    800051ca:	6914                	ld	a3,16(a0)
    800051cc:	6510                	ld	a2,8(a0)
    800051ce:	610c                	ld	a1,0(a0)
    800051d0:	34051573          	csrrw	a0,mscratch,a0
    800051d4:	30200073          	mret
	...

00000000800051da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800051da:	1141                	addi	sp,sp,-16
    800051dc:	e422                	sd	s0,8(sp)
    800051de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800051e0:	0c0007b7          	lui	a5,0xc000
    800051e4:	4705                	li	a4,1
    800051e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800051e8:	c3d8                	sw	a4,4(a5)
}
    800051ea:	6422                	ld	s0,8(sp)
    800051ec:	0141                	addi	sp,sp,16
    800051ee:	8082                	ret

00000000800051f0 <plicinithart>:

void
plicinithart(void)
{
    800051f0:	1141                	addi	sp,sp,-16
    800051f2:	e406                	sd	ra,8(sp)
    800051f4:	e022                	sd	s0,0(sp)
    800051f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c2e080e7          	jalr	-978(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005200:	0085171b          	slliw	a4,a0,0x8
    80005204:	0c0027b7          	lui	a5,0xc002
    80005208:	97ba                	add	a5,a5,a4
    8000520a:	40200713          	li	a4,1026
    8000520e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005212:	00d5151b          	slliw	a0,a0,0xd
    80005216:	0c2017b7          	lui	a5,0xc201
    8000521a:	97aa                	add	a5,a5,a0
    8000521c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005220:	60a2                	ld	ra,8(sp)
    80005222:	6402                	ld	s0,0(sp)
    80005224:	0141                	addi	sp,sp,16
    80005226:	8082                	ret

0000000080005228 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005228:	1141                	addi	sp,sp,-16
    8000522a:	e406                	sd	ra,8(sp)
    8000522c:	e022                	sd	s0,0(sp)
    8000522e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005230:	ffffc097          	auipc	ra,0xffffc
    80005234:	bf6080e7          	jalr	-1034(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005238:	00d5151b          	slliw	a0,a0,0xd
    8000523c:	0c2017b7          	lui	a5,0xc201
    80005240:	97aa                	add	a5,a5,a0
  return irq;
}
    80005242:	43c8                	lw	a0,4(a5)
    80005244:	60a2                	ld	ra,8(sp)
    80005246:	6402                	ld	s0,0(sp)
    80005248:	0141                	addi	sp,sp,16
    8000524a:	8082                	ret

000000008000524c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000524c:	1101                	addi	sp,sp,-32
    8000524e:	ec06                	sd	ra,24(sp)
    80005250:	e822                	sd	s0,16(sp)
    80005252:	e426                	sd	s1,8(sp)
    80005254:	1000                	addi	s0,sp,32
    80005256:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	bce080e7          	jalr	-1074(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005260:	00d5151b          	slliw	a0,a0,0xd
    80005264:	0c2017b7          	lui	a5,0xc201
    80005268:	97aa                	add	a5,a5,a0
    8000526a:	c3c4                	sw	s1,4(a5)
}
    8000526c:	60e2                	ld	ra,24(sp)
    8000526e:	6442                	ld	s0,16(sp)
    80005270:	64a2                	ld	s1,8(sp)
    80005272:	6105                	addi	sp,sp,32
    80005274:	8082                	ret

0000000080005276 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005276:	1141                	addi	sp,sp,-16
    80005278:	e406                	sd	ra,8(sp)
    8000527a:	e022                	sd	s0,0(sp)
    8000527c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000527e:	479d                	li	a5,7
    80005280:	04a7cc63          	blt	a5,a0,800052d8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005284:	00015797          	auipc	a5,0x15
    80005288:	f7c78793          	addi	a5,a5,-132 # 8001a200 <disk>
    8000528c:	97aa                	add	a5,a5,a0
    8000528e:	0187c783          	lbu	a5,24(a5)
    80005292:	ebb9                	bnez	a5,800052e8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005294:	00451693          	slli	a3,a0,0x4
    80005298:	00015797          	auipc	a5,0x15
    8000529c:	f6878793          	addi	a5,a5,-152 # 8001a200 <disk>
    800052a0:	6398                	ld	a4,0(a5)
    800052a2:	9736                	add	a4,a4,a3
    800052a4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052a8:	6398                	ld	a4,0(a5)
    800052aa:	9736                	add	a4,a4,a3
    800052ac:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052b0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052b4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052b8:	97aa                	add	a5,a5,a0
    800052ba:	4705                	li	a4,1
    800052bc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052c0:	00015517          	auipc	a0,0x15
    800052c4:	f5850513          	addi	a0,a0,-168 # 8001a218 <disk+0x18>
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	2f0080e7          	jalr	752(ra) # 800015b8 <wakeup>
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret
    panic("free_desc 1");
    800052d8:	00003517          	auipc	a0,0x3
    800052dc:	3f850513          	addi	a0,a0,1016 # 800086d0 <syscalls+0x300>
    800052e0:	00001097          	auipc	ra,0x1
    800052e4:	a90080e7          	jalr	-1392(ra) # 80005d70 <panic>
    panic("free_desc 2");
    800052e8:	00003517          	auipc	a0,0x3
    800052ec:	3f850513          	addi	a0,a0,1016 # 800086e0 <syscalls+0x310>
    800052f0:	00001097          	auipc	ra,0x1
    800052f4:	a80080e7          	jalr	-1408(ra) # 80005d70 <panic>

00000000800052f8 <virtio_disk_init>:
{
    800052f8:	1101                	addi	sp,sp,-32
    800052fa:	ec06                	sd	ra,24(sp)
    800052fc:	e822                	sd	s0,16(sp)
    800052fe:	e426                	sd	s1,8(sp)
    80005300:	e04a                	sd	s2,0(sp)
    80005302:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005304:	00003597          	auipc	a1,0x3
    80005308:	3ec58593          	addi	a1,a1,1004 # 800086f0 <syscalls+0x320>
    8000530c:	00015517          	auipc	a0,0x15
    80005310:	01c50513          	addi	a0,a0,28 # 8001a328 <disk+0x128>
    80005314:	00001097          	auipc	ra,0x1
    80005318:	eda080e7          	jalr	-294(ra) # 800061ee <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000531c:	100017b7          	lui	a5,0x10001
    80005320:	4398                	lw	a4,0(a5)
    80005322:	2701                	sext.w	a4,a4
    80005324:	747277b7          	lui	a5,0x74727
    80005328:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000532c:	14f71b63          	bne	a4,a5,80005482 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005330:	100017b7          	lui	a5,0x10001
    80005334:	43dc                	lw	a5,4(a5)
    80005336:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005338:	4709                	li	a4,2
    8000533a:	14e79463          	bne	a5,a4,80005482 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000533e:	100017b7          	lui	a5,0x10001
    80005342:	479c                	lw	a5,8(a5)
    80005344:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005346:	12e79e63          	bne	a5,a4,80005482 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000534a:	100017b7          	lui	a5,0x10001
    8000534e:	47d8                	lw	a4,12(a5)
    80005350:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005352:	554d47b7          	lui	a5,0x554d4
    80005356:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000535a:	12f71463          	bne	a4,a5,80005482 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000535e:	100017b7          	lui	a5,0x10001
    80005362:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005366:	4705                	li	a4,1
    80005368:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000536a:	470d                	li	a4,3
    8000536c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000536e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005370:	c7ffe6b7          	lui	a3,0xc7ffe
    80005374:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc1df>
    80005378:	8f75                	and	a4,a4,a3
    8000537a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000537c:	472d                	li	a4,11
    8000537e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005380:	5bbc                	lw	a5,112(a5)
    80005382:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005386:	8ba1                	andi	a5,a5,8
    80005388:	10078563          	beqz	a5,80005492 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000538c:	100017b7          	lui	a5,0x10001
    80005390:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005394:	43fc                	lw	a5,68(a5)
    80005396:	2781                	sext.w	a5,a5
    80005398:	10079563          	bnez	a5,800054a2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	5bdc                	lw	a5,52(a5)
    800053a2:	2781                	sext.w	a5,a5
  if(max == 0)
    800053a4:	10078763          	beqz	a5,800054b2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800053a8:	471d                	li	a4,7
    800053aa:	10f77c63          	bgeu	a4,a5,800054c2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800053ae:	ffffb097          	auipc	ra,0xffffb
    800053b2:	d6c080e7          	jalr	-660(ra) # 8000011a <kalloc>
    800053b6:	00015497          	auipc	s1,0x15
    800053ba:	e4a48493          	addi	s1,s1,-438 # 8001a200 <disk>
    800053be:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053c0:	ffffb097          	auipc	ra,0xffffb
    800053c4:	d5a080e7          	jalr	-678(ra) # 8000011a <kalloc>
    800053c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053ca:	ffffb097          	auipc	ra,0xffffb
    800053ce:	d50080e7          	jalr	-688(ra) # 8000011a <kalloc>
    800053d2:	87aa                	mv	a5,a0
    800053d4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800053d6:	6088                	ld	a0,0(s1)
    800053d8:	cd6d                	beqz	a0,800054d2 <virtio_disk_init+0x1da>
    800053da:	00015717          	auipc	a4,0x15
    800053de:	e2e73703          	ld	a4,-466(a4) # 8001a208 <disk+0x8>
    800053e2:	cb65                	beqz	a4,800054d2 <virtio_disk_init+0x1da>
    800053e4:	c7fd                	beqz	a5,800054d2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800053e6:	6605                	lui	a2,0x1
    800053e8:	4581                	li	a1,0
    800053ea:	ffffb097          	auipc	ra,0xffffb
    800053ee:	d90080e7          	jalr	-624(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053f2:	00015497          	auipc	s1,0x15
    800053f6:	e0e48493          	addi	s1,s1,-498 # 8001a200 <disk>
    800053fa:	6605                	lui	a2,0x1
    800053fc:	4581                	li	a1,0
    800053fe:	6488                	ld	a0,8(s1)
    80005400:	ffffb097          	auipc	ra,0xffffb
    80005404:	d7a080e7          	jalr	-646(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005408:	6605                	lui	a2,0x1
    8000540a:	4581                	li	a1,0
    8000540c:	6888                	ld	a0,16(s1)
    8000540e:	ffffb097          	auipc	ra,0xffffb
    80005412:	d6c080e7          	jalr	-660(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005416:	100017b7          	lui	a5,0x10001
    8000541a:	4721                	li	a4,8
    8000541c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000541e:	4098                	lw	a4,0(s1)
    80005420:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005424:	40d8                	lw	a4,4(s1)
    80005426:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000542a:	6498                	ld	a4,8(s1)
    8000542c:	0007069b          	sext.w	a3,a4
    80005430:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005434:	9701                	srai	a4,a4,0x20
    80005436:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000543a:	6898                	ld	a4,16(s1)
    8000543c:	0007069b          	sext.w	a3,a4
    80005440:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005444:	9701                	srai	a4,a4,0x20
    80005446:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000544a:	4705                	li	a4,1
    8000544c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000544e:	00e48c23          	sb	a4,24(s1)
    80005452:	00e48ca3          	sb	a4,25(s1)
    80005456:	00e48d23          	sb	a4,26(s1)
    8000545a:	00e48da3          	sb	a4,27(s1)
    8000545e:	00e48e23          	sb	a4,28(s1)
    80005462:	00e48ea3          	sb	a4,29(s1)
    80005466:	00e48f23          	sb	a4,30(s1)
    8000546a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000546e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005472:	0727a823          	sw	s2,112(a5)
}
    80005476:	60e2                	ld	ra,24(sp)
    80005478:	6442                	ld	s0,16(sp)
    8000547a:	64a2                	ld	s1,8(sp)
    8000547c:	6902                	ld	s2,0(sp)
    8000547e:	6105                	addi	sp,sp,32
    80005480:	8082                	ret
    panic("could not find virtio disk");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	27e50513          	addi	a0,a0,638 # 80008700 <syscalls+0x330>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	8e6080e7          	jalr	-1818(ra) # 80005d70 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	28e50513          	addi	a0,a0,654 # 80008720 <syscalls+0x350>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	8d6080e7          	jalr	-1834(ra) # 80005d70 <panic>
    panic("virtio disk should not be ready");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	29e50513          	addi	a0,a0,670 # 80008740 <syscalls+0x370>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	8c6080e7          	jalr	-1850(ra) # 80005d70 <panic>
    panic("virtio disk has no queue 0");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2ae50513          	addi	a0,a0,686 # 80008760 <syscalls+0x390>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	8b6080e7          	jalr	-1866(ra) # 80005d70 <panic>
    panic("virtio disk max queue too short");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	2be50513          	addi	a0,a0,702 # 80008780 <syscalls+0x3b0>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	8a6080e7          	jalr	-1882(ra) # 80005d70 <panic>
    panic("virtio disk kalloc");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	2ce50513          	addi	a0,a0,718 # 800087a0 <syscalls+0x3d0>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	896080e7          	jalr	-1898(ra) # 80005d70 <panic>

00000000800054e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054e2:	7159                	addi	sp,sp,-112
    800054e4:	f486                	sd	ra,104(sp)
    800054e6:	f0a2                	sd	s0,96(sp)
    800054e8:	eca6                	sd	s1,88(sp)
    800054ea:	e8ca                	sd	s2,80(sp)
    800054ec:	e4ce                	sd	s3,72(sp)
    800054ee:	e0d2                	sd	s4,64(sp)
    800054f0:	fc56                	sd	s5,56(sp)
    800054f2:	f85a                	sd	s6,48(sp)
    800054f4:	f45e                	sd	s7,40(sp)
    800054f6:	f062                	sd	s8,32(sp)
    800054f8:	ec66                	sd	s9,24(sp)
    800054fa:	e86a                	sd	s10,16(sp)
    800054fc:	1880                	addi	s0,sp,112
    800054fe:	8a2a                	mv	s4,a0
    80005500:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005502:	00c52c83          	lw	s9,12(a0)
    80005506:	001c9c9b          	slliw	s9,s9,0x1
    8000550a:	1c82                	slli	s9,s9,0x20
    8000550c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005510:	00015517          	auipc	a0,0x15
    80005514:	e1850513          	addi	a0,a0,-488 # 8001a328 <disk+0x128>
    80005518:	00001097          	auipc	ra,0x1
    8000551c:	d66080e7          	jalr	-666(ra) # 8000627e <acquire>
  for(int i = 0; i < 3; i++){
    80005520:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005522:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005524:	00015b17          	auipc	s6,0x15
    80005528:	cdcb0b13          	addi	s6,s6,-804 # 8001a200 <disk>
  for(int i = 0; i < 3; i++){
    8000552c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000552e:	00015c17          	auipc	s8,0x15
    80005532:	dfac0c13          	addi	s8,s8,-518 # 8001a328 <disk+0x128>
    80005536:	a095                	j	8000559a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005538:	00fb0733          	add	a4,s6,a5
    8000553c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005540:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005542:	0207c563          	bltz	a5,8000556c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005546:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005548:	0591                	addi	a1,a1,4
    8000554a:	05560d63          	beq	a2,s5,800055a4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000554e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005550:	00015717          	auipc	a4,0x15
    80005554:	cb070713          	addi	a4,a4,-848 # 8001a200 <disk>
    80005558:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000555a:	01874683          	lbu	a3,24(a4)
    8000555e:	fee9                	bnez	a3,80005538 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005560:	2785                	addiw	a5,a5,1
    80005562:	0705                	addi	a4,a4,1
    80005564:	fe979be3          	bne	a5,s1,8000555a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005568:	57fd                	li	a5,-1
    8000556a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000556c:	00c05e63          	blez	a2,80005588 <virtio_disk_rw+0xa6>
    80005570:	060a                	slli	a2,a2,0x2
    80005572:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005576:	0009a503          	lw	a0,0(s3)
    8000557a:	00000097          	auipc	ra,0x0
    8000557e:	cfc080e7          	jalr	-772(ra) # 80005276 <free_desc>
      for(int j = 0; j < i; j++)
    80005582:	0991                	addi	s3,s3,4
    80005584:	ffa999e3          	bne	s3,s10,80005576 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005588:	85e2                	mv	a1,s8
    8000558a:	00015517          	auipc	a0,0x15
    8000558e:	c8e50513          	addi	a0,a0,-882 # 8001a218 <disk+0x18>
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	fc2080e7          	jalr	-62(ra) # 80001554 <sleep>
  for(int i = 0; i < 3; i++){
    8000559a:	f9040993          	addi	s3,s0,-112
{
    8000559e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800055a0:	864a                	mv	a2,s2
    800055a2:	b775                	j	8000554e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055a4:	f9042503          	lw	a0,-112(s0)
    800055a8:	00a50713          	addi	a4,a0,10
    800055ac:	0712                	slli	a4,a4,0x4

  if(write)
    800055ae:	00015797          	auipc	a5,0x15
    800055b2:	c5278793          	addi	a5,a5,-942 # 8001a200 <disk>
    800055b6:	00e786b3          	add	a3,a5,a4
    800055ba:	01703633          	snez	a2,s7
    800055be:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055c0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055c4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055c8:	f6070613          	addi	a2,a4,-160
    800055cc:	6394                	ld	a3,0(a5)
    800055ce:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d0:	00870593          	addi	a1,a4,8
    800055d4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055d8:	0007b803          	ld	a6,0(a5)
    800055dc:	9642                	add	a2,a2,a6
    800055de:	46c1                	li	a3,16
    800055e0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055e2:	4585                	li	a1,1
    800055e4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800055e8:	f9442683          	lw	a3,-108(s0)
    800055ec:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055f0:	0692                	slli	a3,a3,0x4
    800055f2:	9836                	add	a6,a6,a3
    800055f4:	058a0613          	addi	a2,s4,88
    800055f8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055fc:	0007b803          	ld	a6,0(a5)
    80005600:	96c2                	add	a3,a3,a6
    80005602:	40000613          	li	a2,1024
    80005606:	c690                	sw	a2,8(a3)
  if(write)
    80005608:	001bb613          	seqz	a2,s7
    8000560c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005610:	00166613          	ori	a2,a2,1
    80005614:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005618:	f9842603          	lw	a2,-104(s0)
    8000561c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005620:	00250693          	addi	a3,a0,2
    80005624:	0692                	slli	a3,a3,0x4
    80005626:	96be                	add	a3,a3,a5
    80005628:	58fd                	li	a7,-1
    8000562a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000562e:	0612                	slli	a2,a2,0x4
    80005630:	9832                	add	a6,a6,a2
    80005632:	f9070713          	addi	a4,a4,-112
    80005636:	973e                	add	a4,a4,a5
    80005638:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000563c:	6398                	ld	a4,0(a5)
    8000563e:	9732                	add	a4,a4,a2
    80005640:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005642:	4609                	li	a2,2
    80005644:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005648:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000564c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005650:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005654:	6794                	ld	a3,8(a5)
    80005656:	0026d703          	lhu	a4,2(a3)
    8000565a:	8b1d                	andi	a4,a4,7
    8000565c:	0706                	slli	a4,a4,0x1
    8000565e:	96ba                	add	a3,a3,a4
    80005660:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005664:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005668:	6798                	ld	a4,8(a5)
    8000566a:	00275783          	lhu	a5,2(a4)
    8000566e:	2785                	addiw	a5,a5,1
    80005670:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005674:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005680:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005684:	00015917          	auipc	s2,0x15
    80005688:	ca490913          	addi	s2,s2,-860 # 8001a328 <disk+0x128>
  while(b->disk == 1) {
    8000568c:	4485                	li	s1,1
    8000568e:	00b79c63          	bne	a5,a1,800056a6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005692:	85ca                	mv	a1,s2
    80005694:	8552                	mv	a0,s4
    80005696:	ffffc097          	auipc	ra,0xffffc
    8000569a:	ebe080e7          	jalr	-322(ra) # 80001554 <sleep>
  while(b->disk == 1) {
    8000569e:	004a2783          	lw	a5,4(s4)
    800056a2:	fe9788e3          	beq	a5,s1,80005692 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056a6:	f9042903          	lw	s2,-112(s0)
    800056aa:	00290713          	addi	a4,s2,2
    800056ae:	0712                	slli	a4,a4,0x4
    800056b0:	00015797          	auipc	a5,0x15
    800056b4:	b5078793          	addi	a5,a5,-1200 # 8001a200 <disk>
    800056b8:	97ba                	add	a5,a5,a4
    800056ba:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056be:	00015997          	auipc	s3,0x15
    800056c2:	b4298993          	addi	s3,s3,-1214 # 8001a200 <disk>
    800056c6:	00491713          	slli	a4,s2,0x4
    800056ca:	0009b783          	ld	a5,0(s3)
    800056ce:	97ba                	add	a5,a5,a4
    800056d0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056d4:	854a                	mv	a0,s2
    800056d6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056da:	00000097          	auipc	ra,0x0
    800056de:	b9c080e7          	jalr	-1124(ra) # 80005276 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056e2:	8885                	andi	s1,s1,1
    800056e4:	f0ed                	bnez	s1,800056c6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056e6:	00015517          	auipc	a0,0x15
    800056ea:	c4250513          	addi	a0,a0,-958 # 8001a328 <disk+0x128>
    800056ee:	00001097          	auipc	ra,0x1
    800056f2:	c44080e7          	jalr	-956(ra) # 80006332 <release>
}
    800056f6:	70a6                	ld	ra,104(sp)
    800056f8:	7406                	ld	s0,96(sp)
    800056fa:	64e6                	ld	s1,88(sp)
    800056fc:	6946                	ld	s2,80(sp)
    800056fe:	69a6                	ld	s3,72(sp)
    80005700:	6a06                	ld	s4,64(sp)
    80005702:	7ae2                	ld	s5,56(sp)
    80005704:	7b42                	ld	s6,48(sp)
    80005706:	7ba2                	ld	s7,40(sp)
    80005708:	7c02                	ld	s8,32(sp)
    8000570a:	6ce2                	ld	s9,24(sp)
    8000570c:	6d42                	ld	s10,16(sp)
    8000570e:	6165                	addi	sp,sp,112
    80005710:	8082                	ret

0000000080005712 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005712:	1101                	addi	sp,sp,-32
    80005714:	ec06                	sd	ra,24(sp)
    80005716:	e822                	sd	s0,16(sp)
    80005718:	e426                	sd	s1,8(sp)
    8000571a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000571c:	00015497          	auipc	s1,0x15
    80005720:	ae448493          	addi	s1,s1,-1308 # 8001a200 <disk>
    80005724:	00015517          	auipc	a0,0x15
    80005728:	c0450513          	addi	a0,a0,-1020 # 8001a328 <disk+0x128>
    8000572c:	00001097          	auipc	ra,0x1
    80005730:	b52080e7          	jalr	-1198(ra) # 8000627e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005734:	10001737          	lui	a4,0x10001
    80005738:	533c                	lw	a5,96(a4)
    8000573a:	8b8d                	andi	a5,a5,3
    8000573c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000573e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005742:	689c                	ld	a5,16(s1)
    80005744:	0204d703          	lhu	a4,32(s1)
    80005748:	0027d783          	lhu	a5,2(a5)
    8000574c:	04f70863          	beq	a4,a5,8000579c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005750:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005754:	6898                	ld	a4,16(s1)
    80005756:	0204d783          	lhu	a5,32(s1)
    8000575a:	8b9d                	andi	a5,a5,7
    8000575c:	078e                	slli	a5,a5,0x3
    8000575e:	97ba                	add	a5,a5,a4
    80005760:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005762:	00278713          	addi	a4,a5,2
    80005766:	0712                	slli	a4,a4,0x4
    80005768:	9726                	add	a4,a4,s1
    8000576a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000576e:	e721                	bnez	a4,800057b6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005770:	0789                	addi	a5,a5,2
    80005772:	0792                	slli	a5,a5,0x4
    80005774:	97a6                	add	a5,a5,s1
    80005776:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005778:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	e3c080e7          	jalr	-452(ra) # 800015b8 <wakeup>

    disk.used_idx += 1;
    80005784:	0204d783          	lhu	a5,32(s1)
    80005788:	2785                	addiw	a5,a5,1
    8000578a:	17c2                	slli	a5,a5,0x30
    8000578c:	93c1                	srli	a5,a5,0x30
    8000578e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005792:	6898                	ld	a4,16(s1)
    80005794:	00275703          	lhu	a4,2(a4)
    80005798:	faf71ce3          	bne	a4,a5,80005750 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000579c:	00015517          	auipc	a0,0x15
    800057a0:	b8c50513          	addi	a0,a0,-1140 # 8001a328 <disk+0x128>
    800057a4:	00001097          	auipc	ra,0x1
    800057a8:	b8e080e7          	jalr	-1138(ra) # 80006332 <release>
}
    800057ac:	60e2                	ld	ra,24(sp)
    800057ae:	6442                	ld	s0,16(sp)
    800057b0:	64a2                	ld	s1,8(sp)
    800057b2:	6105                	addi	sp,sp,32
    800057b4:	8082                	ret
      panic("virtio_disk_intr status");
    800057b6:	00003517          	auipc	a0,0x3
    800057ba:	00250513          	addi	a0,a0,2 # 800087b8 <syscalls+0x3e8>
    800057be:	00000097          	auipc	ra,0x0
    800057c2:	5b2080e7          	jalr	1458(ra) # 80005d70 <panic>

00000000800057c6 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057c6:	1141                	addi	sp,sp,-16
    800057c8:	e422                	sd	s0,8(sp)
    800057ca:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057cc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057d0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057d4:	0037979b          	slliw	a5,a5,0x3
    800057d8:	02004737          	lui	a4,0x2004
    800057dc:	97ba                	add	a5,a5,a4
    800057de:	0200c737          	lui	a4,0x200c
    800057e2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057e6:	000f4637          	lui	a2,0xf4
    800057ea:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057ee:	9732                	add	a4,a4,a2
    800057f0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057f2:	00259693          	slli	a3,a1,0x2
    800057f6:	96ae                	add	a3,a3,a1
    800057f8:	068e                	slli	a3,a3,0x3
    800057fa:	00015717          	auipc	a4,0x15
    800057fe:	b4670713          	addi	a4,a4,-1210 # 8001a340 <timer_scratch>
    80005802:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005804:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005806:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005808:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000580c:	00000797          	auipc	a5,0x0
    80005810:	9a478793          	addi	a5,a5,-1628 # 800051b0 <timervec>
    80005814:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005818:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000581c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005820:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005824:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005828:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000582c:	30479073          	csrw	mie,a5
}
    80005830:	6422                	ld	s0,8(sp)
    80005832:	0141                	addi	sp,sp,16
    80005834:	8082                	ret

0000000080005836 <start>:
{
    80005836:	1141                	addi	sp,sp,-16
    80005838:	e406                	sd	ra,8(sp)
    8000583a:	e022                	sd	s0,0(sp)
    8000583c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000583e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005842:	7779                	lui	a4,0xffffe
    80005844:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc27f>
    80005848:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000584a:	6705                	lui	a4,0x1
    8000584c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005850:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005852:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005856:	ffffb797          	auipc	a5,0xffffb
    8000585a:	ac878793          	addi	a5,a5,-1336 # 8000031e <main>
    8000585e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005862:	4781                	li	a5,0
    80005864:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005868:	67c1                	lui	a5,0x10
    8000586a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000586c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005870:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005874:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005878:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000587c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005880:	57fd                	li	a5,-1
    80005882:	83a9                	srli	a5,a5,0xa
    80005884:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005888:	47bd                	li	a5,15
    8000588a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000588e:	00000097          	auipc	ra,0x0
    80005892:	f38080e7          	jalr	-200(ra) # 800057c6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005896:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000589a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000589c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000589e:	30200073          	mret
}
    800058a2:	60a2                	ld	ra,8(sp)
    800058a4:	6402                	ld	s0,0(sp)
    800058a6:	0141                	addi	sp,sp,16
    800058a8:	8082                	ret

00000000800058aa <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058aa:	715d                	addi	sp,sp,-80
    800058ac:	e486                	sd	ra,72(sp)
    800058ae:	e0a2                	sd	s0,64(sp)
    800058b0:	fc26                	sd	s1,56(sp)
    800058b2:	f84a                	sd	s2,48(sp)
    800058b4:	f44e                	sd	s3,40(sp)
    800058b6:	f052                	sd	s4,32(sp)
    800058b8:	ec56                	sd	s5,24(sp)
    800058ba:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058bc:	04c05763          	blez	a2,8000590a <consolewrite+0x60>
    800058c0:	8a2a                	mv	s4,a0
    800058c2:	84ae                	mv	s1,a1
    800058c4:	89b2                	mv	s3,a2
    800058c6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058c8:	5afd                	li	s5,-1
    800058ca:	4685                	li	a3,1
    800058cc:	8626                	mv	a2,s1
    800058ce:	85d2                	mv	a1,s4
    800058d0:	fbf40513          	addi	a0,s0,-65
    800058d4:	ffffc097          	auipc	ra,0xffffc
    800058d8:	0de080e7          	jalr	222(ra) # 800019b2 <either_copyin>
    800058dc:	01550d63          	beq	a0,s5,800058f6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800058e0:	fbf44503          	lbu	a0,-65(s0)
    800058e4:	00000097          	auipc	ra,0x0
    800058e8:	7e0080e7          	jalr	2016(ra) # 800060c4 <uartputc>
  for(i = 0; i < n; i++){
    800058ec:	2905                	addiw	s2,s2,1
    800058ee:	0485                	addi	s1,s1,1
    800058f0:	fd299de3          	bne	s3,s2,800058ca <consolewrite+0x20>
    800058f4:	894e                	mv	s2,s3
  }

  return i;
}
    800058f6:	854a                	mv	a0,s2
    800058f8:	60a6                	ld	ra,72(sp)
    800058fa:	6406                	ld	s0,64(sp)
    800058fc:	74e2                	ld	s1,56(sp)
    800058fe:	7942                	ld	s2,48(sp)
    80005900:	79a2                	ld	s3,40(sp)
    80005902:	7a02                	ld	s4,32(sp)
    80005904:	6ae2                	ld	s5,24(sp)
    80005906:	6161                	addi	sp,sp,80
    80005908:	8082                	ret
  for(i = 0; i < n; i++){
    8000590a:	4901                	li	s2,0
    8000590c:	b7ed                	j	800058f6 <consolewrite+0x4c>

000000008000590e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000590e:	711d                	addi	sp,sp,-96
    80005910:	ec86                	sd	ra,88(sp)
    80005912:	e8a2                	sd	s0,80(sp)
    80005914:	e4a6                	sd	s1,72(sp)
    80005916:	e0ca                	sd	s2,64(sp)
    80005918:	fc4e                	sd	s3,56(sp)
    8000591a:	f852                	sd	s4,48(sp)
    8000591c:	f456                	sd	s5,40(sp)
    8000591e:	f05a                	sd	s6,32(sp)
    80005920:	ec5e                	sd	s7,24(sp)
    80005922:	1080                	addi	s0,sp,96
    80005924:	8aaa                	mv	s5,a0
    80005926:	8a2e                	mv	s4,a1
    80005928:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000592a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000592e:	0001d517          	auipc	a0,0x1d
    80005932:	b5250513          	addi	a0,a0,-1198 # 80022480 <cons>
    80005936:	00001097          	auipc	ra,0x1
    8000593a:	948080e7          	jalr	-1720(ra) # 8000627e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000593e:	0001d497          	auipc	s1,0x1d
    80005942:	b4248493          	addi	s1,s1,-1214 # 80022480 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005946:	0001d917          	auipc	s2,0x1d
    8000594a:	bd290913          	addi	s2,s2,-1070 # 80022518 <cons+0x98>
  while(n > 0){
    8000594e:	09305263          	blez	s3,800059d2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005952:	0984a783          	lw	a5,152(s1)
    80005956:	09c4a703          	lw	a4,156(s1)
    8000595a:	02f71763          	bne	a4,a5,80005988 <consoleread+0x7a>
      if(killed(myproc())){
    8000595e:	ffffb097          	auipc	ra,0xffffb
    80005962:	4f4080e7          	jalr	1268(ra) # 80000e52 <myproc>
    80005966:	ffffc097          	auipc	ra,0xffffc
    8000596a:	e96080e7          	jalr	-362(ra) # 800017fc <killed>
    8000596e:	ed2d                	bnez	a0,800059e8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005970:	85a6                	mv	a1,s1
    80005972:	854a                	mv	a0,s2
    80005974:	ffffc097          	auipc	ra,0xffffc
    80005978:	be0080e7          	jalr	-1056(ra) # 80001554 <sleep>
    while(cons.r == cons.w){
    8000597c:	0984a783          	lw	a5,152(s1)
    80005980:	09c4a703          	lw	a4,156(s1)
    80005984:	fcf70de3          	beq	a4,a5,8000595e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005988:	0001d717          	auipc	a4,0x1d
    8000598c:	af870713          	addi	a4,a4,-1288 # 80022480 <cons>
    80005990:	0017869b          	addiw	a3,a5,1
    80005994:	08d72c23          	sw	a3,152(a4)
    80005998:	07f7f693          	andi	a3,a5,127
    8000599c:	9736                	add	a4,a4,a3
    8000599e:	01874703          	lbu	a4,24(a4)
    800059a2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800059a6:	4691                	li	a3,4
    800059a8:	06db8463          	beq	s7,a3,80005a10 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800059ac:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059b0:	4685                	li	a3,1
    800059b2:	faf40613          	addi	a2,s0,-81
    800059b6:	85d2                	mv	a1,s4
    800059b8:	8556                	mv	a0,s5
    800059ba:	ffffc097          	auipc	ra,0xffffc
    800059be:	fa2080e7          	jalr	-94(ra) # 8000195c <either_copyout>
    800059c2:	57fd                	li	a5,-1
    800059c4:	00f50763          	beq	a0,a5,800059d2 <consoleread+0xc4>
      break;

    dst++;
    800059c8:	0a05                	addi	s4,s4,1
    --n;
    800059ca:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800059cc:	47a9                	li	a5,10
    800059ce:	f8fb90e3          	bne	s7,a5,8000594e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059d2:	0001d517          	auipc	a0,0x1d
    800059d6:	aae50513          	addi	a0,a0,-1362 # 80022480 <cons>
    800059da:	00001097          	auipc	ra,0x1
    800059de:	958080e7          	jalr	-1704(ra) # 80006332 <release>

  return target - n;
    800059e2:	413b053b          	subw	a0,s6,s3
    800059e6:	a811                	j	800059fa <consoleread+0xec>
        release(&cons.lock);
    800059e8:	0001d517          	auipc	a0,0x1d
    800059ec:	a9850513          	addi	a0,a0,-1384 # 80022480 <cons>
    800059f0:	00001097          	auipc	ra,0x1
    800059f4:	942080e7          	jalr	-1726(ra) # 80006332 <release>
        return -1;
    800059f8:	557d                	li	a0,-1
}
    800059fa:	60e6                	ld	ra,88(sp)
    800059fc:	6446                	ld	s0,80(sp)
    800059fe:	64a6                	ld	s1,72(sp)
    80005a00:	6906                	ld	s2,64(sp)
    80005a02:	79e2                	ld	s3,56(sp)
    80005a04:	7a42                	ld	s4,48(sp)
    80005a06:	7aa2                	ld	s5,40(sp)
    80005a08:	7b02                	ld	s6,32(sp)
    80005a0a:	6be2                	ld	s7,24(sp)
    80005a0c:	6125                	addi	sp,sp,96
    80005a0e:	8082                	ret
      if(n < target){
    80005a10:	0009871b          	sext.w	a4,s3
    80005a14:	fb677fe3          	bgeu	a4,s6,800059d2 <consoleread+0xc4>
        cons.r--;
    80005a18:	0001d717          	auipc	a4,0x1d
    80005a1c:	b0f72023          	sw	a5,-1280(a4) # 80022518 <cons+0x98>
    80005a20:	bf4d                	j	800059d2 <consoleread+0xc4>

0000000080005a22 <consputc>:
{
    80005a22:	1141                	addi	sp,sp,-16
    80005a24:	e406                	sd	ra,8(sp)
    80005a26:	e022                	sd	s0,0(sp)
    80005a28:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a2a:	10000793          	li	a5,256
    80005a2e:	00f50a63          	beq	a0,a5,80005a42 <consputc+0x20>
    uartputc_sync(c);
    80005a32:	00000097          	auipc	ra,0x0
    80005a36:	5c0080e7          	jalr	1472(ra) # 80005ff2 <uartputc_sync>
}
    80005a3a:	60a2                	ld	ra,8(sp)
    80005a3c:	6402                	ld	s0,0(sp)
    80005a3e:	0141                	addi	sp,sp,16
    80005a40:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a42:	4521                	li	a0,8
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	5ae080e7          	jalr	1454(ra) # 80005ff2 <uartputc_sync>
    80005a4c:	02000513          	li	a0,32
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	5a2080e7          	jalr	1442(ra) # 80005ff2 <uartputc_sync>
    80005a58:	4521                	li	a0,8
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	598080e7          	jalr	1432(ra) # 80005ff2 <uartputc_sync>
    80005a62:	bfe1                	j	80005a3a <consputc+0x18>

0000000080005a64 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a64:	1101                	addi	sp,sp,-32
    80005a66:	ec06                	sd	ra,24(sp)
    80005a68:	e822                	sd	s0,16(sp)
    80005a6a:	e426                	sd	s1,8(sp)
    80005a6c:	e04a                	sd	s2,0(sp)
    80005a6e:	1000                	addi	s0,sp,32
    80005a70:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a72:	0001d517          	auipc	a0,0x1d
    80005a76:	a0e50513          	addi	a0,a0,-1522 # 80022480 <cons>
    80005a7a:	00001097          	auipc	ra,0x1
    80005a7e:	804080e7          	jalr	-2044(ra) # 8000627e <acquire>

  switch(c){
    80005a82:	47d5                	li	a5,21
    80005a84:	0af48663          	beq	s1,a5,80005b30 <consoleintr+0xcc>
    80005a88:	0297ca63          	blt	a5,s1,80005abc <consoleintr+0x58>
    80005a8c:	47a1                	li	a5,8
    80005a8e:	0ef48763          	beq	s1,a5,80005b7c <consoleintr+0x118>
    80005a92:	47c1                	li	a5,16
    80005a94:	10f49a63          	bne	s1,a5,80005ba8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a98:	ffffc097          	auipc	ra,0xffffc
    80005a9c:	f70080e7          	jalr	-144(ra) # 80001a08 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005aa0:	0001d517          	auipc	a0,0x1d
    80005aa4:	9e050513          	addi	a0,a0,-1568 # 80022480 <cons>
    80005aa8:	00001097          	auipc	ra,0x1
    80005aac:	88a080e7          	jalr	-1910(ra) # 80006332 <release>
}
    80005ab0:	60e2                	ld	ra,24(sp)
    80005ab2:	6442                	ld	s0,16(sp)
    80005ab4:	64a2                	ld	s1,8(sp)
    80005ab6:	6902                	ld	s2,0(sp)
    80005ab8:	6105                	addi	sp,sp,32
    80005aba:	8082                	ret
  switch(c){
    80005abc:	07f00793          	li	a5,127
    80005ac0:	0af48e63          	beq	s1,a5,80005b7c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ac4:	0001d717          	auipc	a4,0x1d
    80005ac8:	9bc70713          	addi	a4,a4,-1604 # 80022480 <cons>
    80005acc:	0a072783          	lw	a5,160(a4)
    80005ad0:	09872703          	lw	a4,152(a4)
    80005ad4:	9f99                	subw	a5,a5,a4
    80005ad6:	07f00713          	li	a4,127
    80005ada:	fcf763e3          	bltu	a4,a5,80005aa0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ade:	47b5                	li	a5,13
    80005ae0:	0cf48763          	beq	s1,a5,80005bae <consoleintr+0x14a>
      consputc(c);
    80005ae4:	8526                	mv	a0,s1
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	f3c080e7          	jalr	-196(ra) # 80005a22 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005aee:	0001d797          	auipc	a5,0x1d
    80005af2:	99278793          	addi	a5,a5,-1646 # 80022480 <cons>
    80005af6:	0a07a683          	lw	a3,160(a5)
    80005afa:	0016871b          	addiw	a4,a3,1
    80005afe:	0007061b          	sext.w	a2,a4
    80005b02:	0ae7a023          	sw	a4,160(a5)
    80005b06:	07f6f693          	andi	a3,a3,127
    80005b0a:	97b6                	add	a5,a5,a3
    80005b0c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b10:	47a9                	li	a5,10
    80005b12:	0cf48563          	beq	s1,a5,80005bdc <consoleintr+0x178>
    80005b16:	4791                	li	a5,4
    80005b18:	0cf48263          	beq	s1,a5,80005bdc <consoleintr+0x178>
    80005b1c:	0001d797          	auipc	a5,0x1d
    80005b20:	9fc7a783          	lw	a5,-1540(a5) # 80022518 <cons+0x98>
    80005b24:	9f1d                	subw	a4,a4,a5
    80005b26:	08000793          	li	a5,128
    80005b2a:	f6f71be3          	bne	a4,a5,80005aa0 <consoleintr+0x3c>
    80005b2e:	a07d                	j	80005bdc <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b30:	0001d717          	auipc	a4,0x1d
    80005b34:	95070713          	addi	a4,a4,-1712 # 80022480 <cons>
    80005b38:	0a072783          	lw	a5,160(a4)
    80005b3c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b40:	0001d497          	auipc	s1,0x1d
    80005b44:	94048493          	addi	s1,s1,-1728 # 80022480 <cons>
    while(cons.e != cons.w &&
    80005b48:	4929                	li	s2,10
    80005b4a:	f4f70be3          	beq	a4,a5,80005aa0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b4e:	37fd                	addiw	a5,a5,-1
    80005b50:	07f7f713          	andi	a4,a5,127
    80005b54:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b56:	01874703          	lbu	a4,24(a4)
    80005b5a:	f52703e3          	beq	a4,s2,80005aa0 <consoleintr+0x3c>
      cons.e--;
    80005b5e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b62:	10000513          	li	a0,256
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	ebc080e7          	jalr	-324(ra) # 80005a22 <consputc>
    while(cons.e != cons.w &&
    80005b6e:	0a04a783          	lw	a5,160(s1)
    80005b72:	09c4a703          	lw	a4,156(s1)
    80005b76:	fcf71ce3          	bne	a4,a5,80005b4e <consoleintr+0xea>
    80005b7a:	b71d                	j	80005aa0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b7c:	0001d717          	auipc	a4,0x1d
    80005b80:	90470713          	addi	a4,a4,-1788 # 80022480 <cons>
    80005b84:	0a072783          	lw	a5,160(a4)
    80005b88:	09c72703          	lw	a4,156(a4)
    80005b8c:	f0f70ae3          	beq	a4,a5,80005aa0 <consoleintr+0x3c>
      cons.e--;
    80005b90:	37fd                	addiw	a5,a5,-1
    80005b92:	0001d717          	auipc	a4,0x1d
    80005b96:	98f72723          	sw	a5,-1650(a4) # 80022520 <cons+0xa0>
      consputc(BACKSPACE);
    80005b9a:	10000513          	li	a0,256
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	e84080e7          	jalr	-380(ra) # 80005a22 <consputc>
    80005ba6:	bded                	j	80005aa0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ba8:	ee048ce3          	beqz	s1,80005aa0 <consoleintr+0x3c>
    80005bac:	bf21                	j	80005ac4 <consoleintr+0x60>
      consputc(c);
    80005bae:	4529                	li	a0,10
    80005bb0:	00000097          	auipc	ra,0x0
    80005bb4:	e72080e7          	jalr	-398(ra) # 80005a22 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bb8:	0001d797          	auipc	a5,0x1d
    80005bbc:	8c878793          	addi	a5,a5,-1848 # 80022480 <cons>
    80005bc0:	0a07a703          	lw	a4,160(a5)
    80005bc4:	0017069b          	addiw	a3,a4,1
    80005bc8:	0006861b          	sext.w	a2,a3
    80005bcc:	0ad7a023          	sw	a3,160(a5)
    80005bd0:	07f77713          	andi	a4,a4,127
    80005bd4:	97ba                	add	a5,a5,a4
    80005bd6:	4729                	li	a4,10
    80005bd8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bdc:	0001d797          	auipc	a5,0x1d
    80005be0:	94c7a023          	sw	a2,-1728(a5) # 8002251c <cons+0x9c>
        wakeup(&cons.r);
    80005be4:	0001d517          	auipc	a0,0x1d
    80005be8:	93450513          	addi	a0,a0,-1740 # 80022518 <cons+0x98>
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	9cc080e7          	jalr	-1588(ra) # 800015b8 <wakeup>
    80005bf4:	b575                	j	80005aa0 <consoleintr+0x3c>

0000000080005bf6 <consoleinit>:

void
consoleinit(void)
{
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e406                	sd	ra,8(sp)
    80005bfa:	e022                	sd	s0,0(sp)
    80005bfc:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bfe:	00003597          	auipc	a1,0x3
    80005c02:	bd258593          	addi	a1,a1,-1070 # 800087d0 <syscalls+0x400>
    80005c06:	0001d517          	auipc	a0,0x1d
    80005c0a:	87a50513          	addi	a0,a0,-1926 # 80022480 <cons>
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	5e0080e7          	jalr	1504(ra) # 800061ee <initlock>

  uartinit();
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	38c080e7          	jalr	908(ra) # 80005fa2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c1e:	00013797          	auipc	a5,0x13
    80005c22:	58a78793          	addi	a5,a5,1418 # 800191a8 <devsw>
    80005c26:	00000717          	auipc	a4,0x0
    80005c2a:	ce870713          	addi	a4,a4,-792 # 8000590e <consoleread>
    80005c2e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c30:	00000717          	auipc	a4,0x0
    80005c34:	c7a70713          	addi	a4,a4,-902 # 800058aa <consolewrite>
    80005c38:	ef98                	sd	a4,24(a5)
}
    80005c3a:	60a2                	ld	ra,8(sp)
    80005c3c:	6402                	ld	s0,0(sp)
    80005c3e:	0141                	addi	sp,sp,16
    80005c40:	8082                	ret

0000000080005c42 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c42:	7179                	addi	sp,sp,-48
    80005c44:	f406                	sd	ra,40(sp)
    80005c46:	f022                	sd	s0,32(sp)
    80005c48:	ec26                	sd	s1,24(sp)
    80005c4a:	e84a                	sd	s2,16(sp)
    80005c4c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c4e:	c219                	beqz	a2,80005c54 <printint+0x12>
    80005c50:	08054763          	bltz	a0,80005cde <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c54:	2501                	sext.w	a0,a0
    80005c56:	4881                	li	a7,0
    80005c58:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c5c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c5e:	2581                	sext.w	a1,a1
    80005c60:	00003617          	auipc	a2,0x3
    80005c64:	bb860613          	addi	a2,a2,-1096 # 80008818 <digits>
    80005c68:	883a                	mv	a6,a4
    80005c6a:	2705                	addiw	a4,a4,1
    80005c6c:	02b577bb          	remuw	a5,a0,a1
    80005c70:	1782                	slli	a5,a5,0x20
    80005c72:	9381                	srli	a5,a5,0x20
    80005c74:	97b2                	add	a5,a5,a2
    80005c76:	0007c783          	lbu	a5,0(a5)
    80005c7a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c7e:	0005079b          	sext.w	a5,a0
    80005c82:	02b5553b          	divuw	a0,a0,a1
    80005c86:	0685                	addi	a3,a3,1
    80005c88:	feb7f0e3          	bgeu	a5,a1,80005c68 <printint+0x26>

  if(sign)
    80005c8c:	00088c63          	beqz	a7,80005ca4 <printint+0x62>
    buf[i++] = '-';
    80005c90:	fe070793          	addi	a5,a4,-32
    80005c94:	00878733          	add	a4,a5,s0
    80005c98:	02d00793          	li	a5,45
    80005c9c:	fef70823          	sb	a5,-16(a4)
    80005ca0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ca4:	02e05763          	blez	a4,80005cd2 <printint+0x90>
    80005ca8:	fd040793          	addi	a5,s0,-48
    80005cac:	00e784b3          	add	s1,a5,a4
    80005cb0:	fff78913          	addi	s2,a5,-1
    80005cb4:	993a                	add	s2,s2,a4
    80005cb6:	377d                	addiw	a4,a4,-1
    80005cb8:	1702                	slli	a4,a4,0x20
    80005cba:	9301                	srli	a4,a4,0x20
    80005cbc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cc0:	fff4c503          	lbu	a0,-1(s1)
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	d5e080e7          	jalr	-674(ra) # 80005a22 <consputc>
  while(--i >= 0)
    80005ccc:	14fd                	addi	s1,s1,-1
    80005cce:	ff2499e3          	bne	s1,s2,80005cc0 <printint+0x7e>
}
    80005cd2:	70a2                	ld	ra,40(sp)
    80005cd4:	7402                	ld	s0,32(sp)
    80005cd6:	64e2                	ld	s1,24(sp)
    80005cd8:	6942                	ld	s2,16(sp)
    80005cda:	6145                	addi	sp,sp,48
    80005cdc:	8082                	ret
    x = -xx;
    80005cde:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ce2:	4885                	li	a7,1
    x = -xx;
    80005ce4:	bf95                	j	80005c58 <printint+0x16>

0000000080005ce6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ce6:	1101                	addi	sp,sp,-32
    80005ce8:	ec06                	sd	ra,24(sp)
    80005cea:	e822                	sd	s0,16(sp)
    80005cec:	e426                	sd	s1,8(sp)
    80005cee:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005cf0:	0001d497          	auipc	s1,0x1d
    80005cf4:	83848493          	addi	s1,s1,-1992 # 80022528 <pr>
    80005cf8:	00003597          	auipc	a1,0x3
    80005cfc:	ae058593          	addi	a1,a1,-1312 # 800087d8 <syscalls+0x408>
    80005d00:	8526                	mv	a0,s1
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	4ec080e7          	jalr	1260(ra) # 800061ee <initlock>
  pr.locking = 1;
    80005d0a:	4785                	li	a5,1
    80005d0c:	cc9c                	sw	a5,24(s1)
}
    80005d0e:	60e2                	ld	ra,24(sp)
    80005d10:	6442                	ld	s0,16(sp)
    80005d12:	64a2                	ld	s1,8(sp)
    80005d14:	6105                	addi	sp,sp,32
    80005d16:	8082                	ret

0000000080005d18 <backtrace>:


void  /*recause to implement*/
backtrace(void){
    80005d18:	7179                	addi	sp,sp,-48
    80005d1a:	f406                	sd	ra,40(sp)
    80005d1c:	f022                	sd	s0,32(sp)
    80005d1e:	ec26                	sd	s1,24(sp)
    80005d20:	e84a                	sd	s2,16(sp)
    80005d22:	e44e                	sd	s3,8(sp)
    80005d24:	1800                	addi	s0,sp,48
  
  printf("backtrace:\n");
    80005d26:	00003517          	auipc	a0,0x3
    80005d2a:	aba50513          	addi	a0,a0,-1350 # 800087e0 <syscalls+0x410>
    80005d2e:	00000097          	auipc	ra,0x0
    80005d32:	094080e7          	jalr	148(ra) # 80005dc2 <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80005d36:	8922                	mv	s2,s0
  uint64 *fp = (uint64*)r_fp();
    80005d38:	84ca                	mv	s1,s2
  uint64 *end_fp = (uint64*)PGROUNDDOWN((uint64)fp);
    80005d3a:	77fd                	lui	a5,0xfffff
    80005d3c:	00f97933          	and	s2,s2,a5
  while(1){
    if(fp < end_fp)break;
    80005d40:	0324e163          	bltu	s1,s2,80005d62 <backtrace+0x4a>
    printf("%p\n", fp[-1]);
    80005d44:	00003997          	auipc	s3,0x3
    80005d48:	aac98993          	addi	s3,s3,-1364 # 800087f0 <syscalls+0x420>
    80005d4c:	ff84b583          	ld	a1,-8(s1)
    80005d50:	854e                	mv	a0,s3
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	070080e7          	jalr	112(ra) # 80005dc2 <printf>
    fp = (uint64*)fp[-2];
    80005d5a:	ff04b483          	ld	s1,-16(s1)
    if(fp < end_fp)break;
    80005d5e:	ff24f7e3          	bgeu	s1,s2,80005d4c <backtrace+0x34>
  }
  return;
    80005d62:	70a2                	ld	ra,40(sp)
    80005d64:	7402                	ld	s0,32(sp)
    80005d66:	64e2                	ld	s1,24(sp)
    80005d68:	6942                	ld	s2,16(sp)
    80005d6a:	69a2                	ld	s3,8(sp)
    80005d6c:	6145                	addi	sp,sp,48
    80005d6e:	8082                	ret

0000000080005d70 <panic>:
{
    80005d70:	1101                	addi	sp,sp,-32
    80005d72:	ec06                	sd	ra,24(sp)
    80005d74:	e822                	sd	s0,16(sp)
    80005d76:	e426                	sd	s1,8(sp)
    80005d78:	1000                	addi	s0,sp,32
    80005d7a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d7c:	0001c797          	auipc	a5,0x1c
    80005d80:	7c07a223          	sw	zero,1988(a5) # 80022540 <pr+0x18>
  printf("panic: ");
    80005d84:	00003517          	auipc	a0,0x3
    80005d88:	a7450513          	addi	a0,a0,-1420 # 800087f8 <syscalls+0x428>
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	036080e7          	jalr	54(ra) # 80005dc2 <printf>
  printf(s);
    80005d94:	8526                	mv	a0,s1
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	02c080e7          	jalr	44(ra) # 80005dc2 <printf>
  printf("\n");
    80005d9e:	00002517          	auipc	a0,0x2
    80005da2:	2aa50513          	addi	a0,a0,682 # 80008048 <etext+0x48>
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	01c080e7          	jalr	28(ra) # 80005dc2 <printf>
  backtrace();
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	f6a080e7          	jalr	-150(ra) # 80005d18 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005db6:	4785                	li	a5,1
    80005db8:	00003717          	auipc	a4,0x3
    80005dbc:	b4f72223          	sw	a5,-1212(a4) # 800088fc <panicked>
  for(;;)
    80005dc0:	a001                	j	80005dc0 <panic+0x50>

0000000080005dc2 <printf>:
{
    80005dc2:	7131                	addi	sp,sp,-192
    80005dc4:	fc86                	sd	ra,120(sp)
    80005dc6:	f8a2                	sd	s0,112(sp)
    80005dc8:	f4a6                	sd	s1,104(sp)
    80005dca:	f0ca                	sd	s2,96(sp)
    80005dcc:	ecce                	sd	s3,88(sp)
    80005dce:	e8d2                	sd	s4,80(sp)
    80005dd0:	e4d6                	sd	s5,72(sp)
    80005dd2:	e0da                	sd	s6,64(sp)
    80005dd4:	fc5e                	sd	s7,56(sp)
    80005dd6:	f862                	sd	s8,48(sp)
    80005dd8:	f466                	sd	s9,40(sp)
    80005dda:	f06a                	sd	s10,32(sp)
    80005ddc:	ec6e                	sd	s11,24(sp)
    80005dde:	0100                	addi	s0,sp,128
    80005de0:	8a2a                	mv	s4,a0
    80005de2:	e40c                	sd	a1,8(s0)
    80005de4:	e810                	sd	a2,16(s0)
    80005de6:	ec14                	sd	a3,24(s0)
    80005de8:	f018                	sd	a4,32(s0)
    80005dea:	f41c                	sd	a5,40(s0)
    80005dec:	03043823          	sd	a6,48(s0)
    80005df0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005df4:	0001cd97          	auipc	s11,0x1c
    80005df8:	74cdad83          	lw	s11,1868(s11) # 80022540 <pr+0x18>
  if(locking)
    80005dfc:	020d9b63          	bnez	s11,80005e32 <printf+0x70>
  if (fmt == 0)
    80005e00:	040a0263          	beqz	s4,80005e44 <printf+0x82>
  va_start(ap, fmt);
    80005e04:	00840793          	addi	a5,s0,8
    80005e08:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e0c:	000a4503          	lbu	a0,0(s4)
    80005e10:	14050f63          	beqz	a0,80005f6e <printf+0x1ac>
    80005e14:	4981                	li	s3,0
    if(c != '%'){
    80005e16:	02500a93          	li	s5,37
    switch(c){
    80005e1a:	07000b93          	li	s7,112
  consputc('x');
    80005e1e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e20:	00003b17          	auipc	s6,0x3
    80005e24:	9f8b0b13          	addi	s6,s6,-1544 # 80008818 <digits>
    switch(c){
    80005e28:	07300c93          	li	s9,115
    80005e2c:	06400c13          	li	s8,100
    80005e30:	a82d                	j	80005e6a <printf+0xa8>
    acquire(&pr.lock);
    80005e32:	0001c517          	auipc	a0,0x1c
    80005e36:	6f650513          	addi	a0,a0,1782 # 80022528 <pr>
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	444080e7          	jalr	1092(ra) # 8000627e <acquire>
    80005e42:	bf7d                	j	80005e00 <printf+0x3e>
    panic("null fmt");
    80005e44:	00003517          	auipc	a0,0x3
    80005e48:	9c450513          	addi	a0,a0,-1596 # 80008808 <syscalls+0x438>
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	f24080e7          	jalr	-220(ra) # 80005d70 <panic>
      consputc(c);
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	bce080e7          	jalr	-1074(ra) # 80005a22 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e5c:	2985                	addiw	s3,s3,1
    80005e5e:	013a07b3          	add	a5,s4,s3
    80005e62:	0007c503          	lbu	a0,0(a5)
    80005e66:	10050463          	beqz	a0,80005f6e <printf+0x1ac>
    if(c != '%'){
    80005e6a:	ff5515e3          	bne	a0,s5,80005e54 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e6e:	2985                	addiw	s3,s3,1
    80005e70:	013a07b3          	add	a5,s4,s3
    80005e74:	0007c783          	lbu	a5,0(a5)
    80005e78:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e7c:	cbed                	beqz	a5,80005f6e <printf+0x1ac>
    switch(c){
    80005e7e:	05778a63          	beq	a5,s7,80005ed2 <printf+0x110>
    80005e82:	02fbf663          	bgeu	s7,a5,80005eae <printf+0xec>
    80005e86:	09978863          	beq	a5,s9,80005f16 <printf+0x154>
    80005e8a:	07800713          	li	a4,120
    80005e8e:	0ce79563          	bne	a5,a4,80005f58 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e92:	f8843783          	ld	a5,-120(s0)
    80005e96:	00878713          	addi	a4,a5,8
    80005e9a:	f8e43423          	sd	a4,-120(s0)
    80005e9e:	4605                	li	a2,1
    80005ea0:	85ea                	mv	a1,s10
    80005ea2:	4388                	lw	a0,0(a5)
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	d9e080e7          	jalr	-610(ra) # 80005c42 <printint>
      break;
    80005eac:	bf45                	j	80005e5c <printf+0x9a>
    switch(c){
    80005eae:	09578f63          	beq	a5,s5,80005f4c <printf+0x18a>
    80005eb2:	0b879363          	bne	a5,s8,80005f58 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005eb6:	f8843783          	ld	a5,-120(s0)
    80005eba:	00878713          	addi	a4,a5,8
    80005ebe:	f8e43423          	sd	a4,-120(s0)
    80005ec2:	4605                	li	a2,1
    80005ec4:	45a9                	li	a1,10
    80005ec6:	4388                	lw	a0,0(a5)
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	d7a080e7          	jalr	-646(ra) # 80005c42 <printint>
      break;
    80005ed0:	b771                	j	80005e5c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ed2:	f8843783          	ld	a5,-120(s0)
    80005ed6:	00878713          	addi	a4,a5,8
    80005eda:	f8e43423          	sd	a4,-120(s0)
    80005ede:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ee2:	03000513          	li	a0,48
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	b3c080e7          	jalr	-1220(ra) # 80005a22 <consputc>
  consputc('x');
    80005eee:	07800513          	li	a0,120
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	b30080e7          	jalr	-1232(ra) # 80005a22 <consputc>
    80005efa:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005efc:	03c95793          	srli	a5,s2,0x3c
    80005f00:	97da                	add	a5,a5,s6
    80005f02:	0007c503          	lbu	a0,0(a5)
    80005f06:	00000097          	auipc	ra,0x0
    80005f0a:	b1c080e7          	jalr	-1252(ra) # 80005a22 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f0e:	0912                	slli	s2,s2,0x4
    80005f10:	34fd                	addiw	s1,s1,-1
    80005f12:	f4ed                	bnez	s1,80005efc <printf+0x13a>
    80005f14:	b7a1                	j	80005e5c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f16:	f8843783          	ld	a5,-120(s0)
    80005f1a:	00878713          	addi	a4,a5,8
    80005f1e:	f8e43423          	sd	a4,-120(s0)
    80005f22:	6384                	ld	s1,0(a5)
    80005f24:	cc89                	beqz	s1,80005f3e <printf+0x17c>
      for(; *s; s++)
    80005f26:	0004c503          	lbu	a0,0(s1)
    80005f2a:	d90d                	beqz	a0,80005e5c <printf+0x9a>
        consputc(*s);
    80005f2c:	00000097          	auipc	ra,0x0
    80005f30:	af6080e7          	jalr	-1290(ra) # 80005a22 <consputc>
      for(; *s; s++)
    80005f34:	0485                	addi	s1,s1,1
    80005f36:	0004c503          	lbu	a0,0(s1)
    80005f3a:	f96d                	bnez	a0,80005f2c <printf+0x16a>
    80005f3c:	b705                	j	80005e5c <printf+0x9a>
        s = "(null)";
    80005f3e:	00003497          	auipc	s1,0x3
    80005f42:	8c248493          	addi	s1,s1,-1854 # 80008800 <syscalls+0x430>
      for(; *s; s++)
    80005f46:	02800513          	li	a0,40
    80005f4a:	b7cd                	j	80005f2c <printf+0x16a>
      consputc('%');
    80005f4c:	8556                	mv	a0,s5
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	ad4080e7          	jalr	-1324(ra) # 80005a22 <consputc>
      break;
    80005f56:	b719                	j	80005e5c <printf+0x9a>
      consputc('%');
    80005f58:	8556                	mv	a0,s5
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	ac8080e7          	jalr	-1336(ra) # 80005a22 <consputc>
      consputc(c);
    80005f62:	8526                	mv	a0,s1
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	abe080e7          	jalr	-1346(ra) # 80005a22 <consputc>
      break;
    80005f6c:	bdc5                	j	80005e5c <printf+0x9a>
  if(locking)
    80005f6e:	020d9163          	bnez	s11,80005f90 <printf+0x1ce>
}
    80005f72:	70e6                	ld	ra,120(sp)
    80005f74:	7446                	ld	s0,112(sp)
    80005f76:	74a6                	ld	s1,104(sp)
    80005f78:	7906                	ld	s2,96(sp)
    80005f7a:	69e6                	ld	s3,88(sp)
    80005f7c:	6a46                	ld	s4,80(sp)
    80005f7e:	6aa6                	ld	s5,72(sp)
    80005f80:	6b06                	ld	s6,64(sp)
    80005f82:	7be2                	ld	s7,56(sp)
    80005f84:	7c42                	ld	s8,48(sp)
    80005f86:	7ca2                	ld	s9,40(sp)
    80005f88:	7d02                	ld	s10,32(sp)
    80005f8a:	6de2                	ld	s11,24(sp)
    80005f8c:	6129                	addi	sp,sp,192
    80005f8e:	8082                	ret
    release(&pr.lock);
    80005f90:	0001c517          	auipc	a0,0x1c
    80005f94:	59850513          	addi	a0,a0,1432 # 80022528 <pr>
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	39a080e7          	jalr	922(ra) # 80006332 <release>
}
    80005fa0:	bfc9                	j	80005f72 <printf+0x1b0>

0000000080005fa2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fa2:	1141                	addi	sp,sp,-16
    80005fa4:	e406                	sd	ra,8(sp)
    80005fa6:	e022                	sd	s0,0(sp)
    80005fa8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005faa:	100007b7          	lui	a5,0x10000
    80005fae:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fb2:	f8000713          	li	a4,-128
    80005fb6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fba:	470d                	li	a4,3
    80005fbc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fc0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fc4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fc8:	469d                	li	a3,7
    80005fca:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fce:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fd2:	00003597          	auipc	a1,0x3
    80005fd6:	85e58593          	addi	a1,a1,-1954 # 80008830 <digits+0x18>
    80005fda:	0001c517          	auipc	a0,0x1c
    80005fde:	56e50513          	addi	a0,a0,1390 # 80022548 <uart_tx_lock>
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	20c080e7          	jalr	524(ra) # 800061ee <initlock>
}
    80005fea:	60a2                	ld	ra,8(sp)
    80005fec:	6402                	ld	s0,0(sp)
    80005fee:	0141                	addi	sp,sp,16
    80005ff0:	8082                	ret

0000000080005ff2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ff2:	1101                	addi	sp,sp,-32
    80005ff4:	ec06                	sd	ra,24(sp)
    80005ff6:	e822                	sd	s0,16(sp)
    80005ff8:	e426                	sd	s1,8(sp)
    80005ffa:	1000                	addi	s0,sp,32
    80005ffc:	84aa                	mv	s1,a0
  push_off();
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	234080e7          	jalr	564(ra) # 80006232 <push_off>

  if(panicked){
    80006006:	00003797          	auipc	a5,0x3
    8000600a:	8f67a783          	lw	a5,-1802(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000600e:	10000737          	lui	a4,0x10000
  if(panicked){
    80006012:	c391                	beqz	a5,80006016 <uartputc_sync+0x24>
    for(;;)
    80006014:	a001                	j	80006014 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006016:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000601a:	0207f793          	andi	a5,a5,32
    8000601e:	dfe5                	beqz	a5,80006016 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006020:	0ff4f513          	zext.b	a0,s1
    80006024:	100007b7          	lui	a5,0x10000
    80006028:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	2a6080e7          	jalr	678(ra) # 800062d2 <pop_off>
}
    80006034:	60e2                	ld	ra,24(sp)
    80006036:	6442                	ld	s0,16(sp)
    80006038:	64a2                	ld	s1,8(sp)
    8000603a:	6105                	addi	sp,sp,32
    8000603c:	8082                	ret

000000008000603e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000603e:	00003797          	auipc	a5,0x3
    80006042:	8c27b783          	ld	a5,-1854(a5) # 80008900 <uart_tx_r>
    80006046:	00003717          	auipc	a4,0x3
    8000604a:	8c273703          	ld	a4,-1854(a4) # 80008908 <uart_tx_w>
    8000604e:	06f70a63          	beq	a4,a5,800060c2 <uartstart+0x84>
{
    80006052:	7139                	addi	sp,sp,-64
    80006054:	fc06                	sd	ra,56(sp)
    80006056:	f822                	sd	s0,48(sp)
    80006058:	f426                	sd	s1,40(sp)
    8000605a:	f04a                	sd	s2,32(sp)
    8000605c:	ec4e                	sd	s3,24(sp)
    8000605e:	e852                	sd	s4,16(sp)
    80006060:	e456                	sd	s5,8(sp)
    80006062:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006064:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006068:	0001ca17          	auipc	s4,0x1c
    8000606c:	4e0a0a13          	addi	s4,s4,1248 # 80022548 <uart_tx_lock>
    uart_tx_r += 1;
    80006070:	00003497          	auipc	s1,0x3
    80006074:	89048493          	addi	s1,s1,-1904 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006078:	00003997          	auipc	s3,0x3
    8000607c:	89098993          	addi	s3,s3,-1904 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006080:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006084:	02077713          	andi	a4,a4,32
    80006088:	c705                	beqz	a4,800060b0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000608a:	01f7f713          	andi	a4,a5,31
    8000608e:	9752                	add	a4,a4,s4
    80006090:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006094:	0785                	addi	a5,a5,1
    80006096:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006098:	8526                	mv	a0,s1
    8000609a:	ffffb097          	auipc	ra,0xffffb
    8000609e:	51e080e7          	jalr	1310(ra) # 800015b8 <wakeup>
    
    WriteReg(THR, c);
    800060a2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060a6:	609c                	ld	a5,0(s1)
    800060a8:	0009b703          	ld	a4,0(s3)
    800060ac:	fcf71ae3          	bne	a4,a5,80006080 <uartstart+0x42>
  }
}
    800060b0:	70e2                	ld	ra,56(sp)
    800060b2:	7442                	ld	s0,48(sp)
    800060b4:	74a2                	ld	s1,40(sp)
    800060b6:	7902                	ld	s2,32(sp)
    800060b8:	69e2                	ld	s3,24(sp)
    800060ba:	6a42                	ld	s4,16(sp)
    800060bc:	6aa2                	ld	s5,8(sp)
    800060be:	6121                	addi	sp,sp,64
    800060c0:	8082                	ret
    800060c2:	8082                	ret

00000000800060c4 <uartputc>:
{
    800060c4:	7179                	addi	sp,sp,-48
    800060c6:	f406                	sd	ra,40(sp)
    800060c8:	f022                	sd	s0,32(sp)
    800060ca:	ec26                	sd	s1,24(sp)
    800060cc:	e84a                	sd	s2,16(sp)
    800060ce:	e44e                	sd	s3,8(sp)
    800060d0:	e052                	sd	s4,0(sp)
    800060d2:	1800                	addi	s0,sp,48
    800060d4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060d6:	0001c517          	auipc	a0,0x1c
    800060da:	47250513          	addi	a0,a0,1138 # 80022548 <uart_tx_lock>
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	1a0080e7          	jalr	416(ra) # 8000627e <acquire>
  if(panicked){
    800060e6:	00003797          	auipc	a5,0x3
    800060ea:	8167a783          	lw	a5,-2026(a5) # 800088fc <panicked>
    800060ee:	e7c9                	bnez	a5,80006178 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f0:	00003717          	auipc	a4,0x3
    800060f4:	81873703          	ld	a4,-2024(a4) # 80008908 <uart_tx_w>
    800060f8:	00003797          	auipc	a5,0x3
    800060fc:	8087b783          	ld	a5,-2040(a5) # 80008900 <uart_tx_r>
    80006100:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006104:	0001c997          	auipc	s3,0x1c
    80006108:	44498993          	addi	s3,s3,1092 # 80022548 <uart_tx_lock>
    8000610c:	00002497          	auipc	s1,0x2
    80006110:	7f448493          	addi	s1,s1,2036 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006114:	00002917          	auipc	s2,0x2
    80006118:	7f490913          	addi	s2,s2,2036 # 80008908 <uart_tx_w>
    8000611c:	00e79f63          	bne	a5,a4,8000613a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006120:	85ce                	mv	a1,s3
    80006122:	8526                	mv	a0,s1
    80006124:	ffffb097          	auipc	ra,0xffffb
    80006128:	430080e7          	jalr	1072(ra) # 80001554 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612c:	00093703          	ld	a4,0(s2)
    80006130:	609c                	ld	a5,0(s1)
    80006132:	02078793          	addi	a5,a5,32
    80006136:	fee785e3          	beq	a5,a4,80006120 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000613a:	0001c497          	auipc	s1,0x1c
    8000613e:	40e48493          	addi	s1,s1,1038 # 80022548 <uart_tx_lock>
    80006142:	01f77793          	andi	a5,a4,31
    80006146:	97a6                	add	a5,a5,s1
    80006148:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000614c:	0705                	addi	a4,a4,1
    8000614e:	00002797          	auipc	a5,0x2
    80006152:	7ae7bd23          	sd	a4,1978(a5) # 80008908 <uart_tx_w>
  uartstart();
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	ee8080e7          	jalr	-280(ra) # 8000603e <uartstart>
  release(&uart_tx_lock);
    8000615e:	8526                	mv	a0,s1
    80006160:	00000097          	auipc	ra,0x0
    80006164:	1d2080e7          	jalr	466(ra) # 80006332 <release>
}
    80006168:	70a2                	ld	ra,40(sp)
    8000616a:	7402                	ld	s0,32(sp)
    8000616c:	64e2                	ld	s1,24(sp)
    8000616e:	6942                	ld	s2,16(sp)
    80006170:	69a2                	ld	s3,8(sp)
    80006172:	6a02                	ld	s4,0(sp)
    80006174:	6145                	addi	sp,sp,48
    80006176:	8082                	ret
    for(;;)
    80006178:	a001                	j	80006178 <uartputc+0xb4>

000000008000617a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000617a:	1141                	addi	sp,sp,-16
    8000617c:	e422                	sd	s0,8(sp)
    8000617e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006180:	100007b7          	lui	a5,0x10000
    80006184:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006188:	8b85                	andi	a5,a5,1
    8000618a:	cb81                	beqz	a5,8000619a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000618c:	100007b7          	lui	a5,0x10000
    80006190:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006194:	6422                	ld	s0,8(sp)
    80006196:	0141                	addi	sp,sp,16
    80006198:	8082                	ret
    return -1;
    8000619a:	557d                	li	a0,-1
    8000619c:	bfe5                	j	80006194 <uartgetc+0x1a>

000000008000619e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000619e:	1101                	addi	sp,sp,-32
    800061a0:	ec06                	sd	ra,24(sp)
    800061a2:	e822                	sd	s0,16(sp)
    800061a4:	e426                	sd	s1,8(sp)
    800061a6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061a8:	54fd                	li	s1,-1
    800061aa:	a029                	j	800061b4 <uartintr+0x16>
      break;
    consoleintr(c);
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	8b8080e7          	jalr	-1864(ra) # 80005a64 <consoleintr>
    int c = uartgetc();
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	fc6080e7          	jalr	-58(ra) # 8000617a <uartgetc>
    if(c == -1)
    800061bc:	fe9518e3          	bne	a0,s1,800061ac <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061c0:	0001c497          	auipc	s1,0x1c
    800061c4:	38848493          	addi	s1,s1,904 # 80022548 <uart_tx_lock>
    800061c8:	8526                	mv	a0,s1
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	0b4080e7          	jalr	180(ra) # 8000627e <acquire>
  uartstart();
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	e6c080e7          	jalr	-404(ra) # 8000603e <uartstart>
  release(&uart_tx_lock);
    800061da:	8526                	mv	a0,s1
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	156080e7          	jalr	342(ra) # 80006332 <release>
}
    800061e4:	60e2                	ld	ra,24(sp)
    800061e6:	6442                	ld	s0,16(sp)
    800061e8:	64a2                	ld	s1,8(sp)
    800061ea:	6105                	addi	sp,sp,32
    800061ec:	8082                	ret

00000000800061ee <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061ee:	1141                	addi	sp,sp,-16
    800061f0:	e422                	sd	s0,8(sp)
    800061f2:	0800                	addi	s0,sp,16
  lk->name = name;
    800061f4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061f6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061fa:	00053823          	sd	zero,16(a0)
}
    800061fe:	6422                	ld	s0,8(sp)
    80006200:	0141                	addi	sp,sp,16
    80006202:	8082                	ret

0000000080006204 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006204:	411c                	lw	a5,0(a0)
    80006206:	e399                	bnez	a5,8000620c <holding+0x8>
    80006208:	4501                	li	a0,0
  return r;
}
    8000620a:	8082                	ret
{
    8000620c:	1101                	addi	sp,sp,-32
    8000620e:	ec06                	sd	ra,24(sp)
    80006210:	e822                	sd	s0,16(sp)
    80006212:	e426                	sd	s1,8(sp)
    80006214:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006216:	6904                	ld	s1,16(a0)
    80006218:	ffffb097          	auipc	ra,0xffffb
    8000621c:	c1e080e7          	jalr	-994(ra) # 80000e36 <mycpu>
    80006220:	40a48533          	sub	a0,s1,a0
    80006224:	00153513          	seqz	a0,a0
}
    80006228:	60e2                	ld	ra,24(sp)
    8000622a:	6442                	ld	s0,16(sp)
    8000622c:	64a2                	ld	s1,8(sp)
    8000622e:	6105                	addi	sp,sp,32
    80006230:	8082                	ret

0000000080006232 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623c:	100024f3          	csrr	s1,sstatus
    80006240:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006244:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006246:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	bec080e7          	jalr	-1044(ra) # 80000e36 <mycpu>
    80006252:	5d3c                	lw	a5,120(a0)
    80006254:	cf89                	beqz	a5,8000626e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006256:	ffffb097          	auipc	ra,0xffffb
    8000625a:	be0080e7          	jalr	-1056(ra) # 80000e36 <mycpu>
    8000625e:	5d3c                	lw	a5,120(a0)
    80006260:	2785                	addiw	a5,a5,1
    80006262:	dd3c                	sw	a5,120(a0)
}
    80006264:	60e2                	ld	ra,24(sp)
    80006266:	6442                	ld	s0,16(sp)
    80006268:	64a2                	ld	s1,8(sp)
    8000626a:	6105                	addi	sp,sp,32
    8000626c:	8082                	ret
    mycpu()->intena = old;
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	bc8080e7          	jalr	-1080(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006276:	8085                	srli	s1,s1,0x1
    80006278:	8885                	andi	s1,s1,1
    8000627a:	dd64                	sw	s1,124(a0)
    8000627c:	bfe9                	j	80006256 <push_off+0x24>

000000008000627e <acquire>:
{
    8000627e:	1101                	addi	sp,sp,-32
    80006280:	ec06                	sd	ra,24(sp)
    80006282:	e822                	sd	s0,16(sp)
    80006284:	e426                	sd	s1,8(sp)
    80006286:	1000                	addi	s0,sp,32
    80006288:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	fa8080e7          	jalr	-88(ra) # 80006232 <push_off>
  if(holding(lk))
    80006292:	8526                	mv	a0,s1
    80006294:	00000097          	auipc	ra,0x0
    80006298:	f70080e7          	jalr	-144(ra) # 80006204 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000629c:	4705                	li	a4,1
  if(holding(lk))
    8000629e:	e115                	bnez	a0,800062c2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062a0:	87ba                	mv	a5,a4
    800062a2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062a6:	2781                	sext.w	a5,a5
    800062a8:	ffe5                	bnez	a5,800062a0 <acquire+0x22>
  __sync_synchronize();
    800062aa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062ae:	ffffb097          	auipc	ra,0xffffb
    800062b2:	b88080e7          	jalr	-1144(ra) # 80000e36 <mycpu>
    800062b6:	e888                	sd	a0,16(s1)
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret
    panic("acquire");
    800062c2:	00002517          	auipc	a0,0x2
    800062c6:	57650513          	addi	a0,a0,1398 # 80008838 <digits+0x20>
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	aa6080e7          	jalr	-1370(ra) # 80005d70 <panic>

00000000800062d2 <pop_off>:

void
pop_off(void)
{
    800062d2:	1141                	addi	sp,sp,-16
    800062d4:	e406                	sd	ra,8(sp)
    800062d6:	e022                	sd	s0,0(sp)
    800062d8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062da:	ffffb097          	auipc	ra,0xffffb
    800062de:	b5c080e7          	jalr	-1188(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062e2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062e6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062e8:	e78d                	bnez	a5,80006312 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062ea:	5d3c                	lw	a5,120(a0)
    800062ec:	02f05b63          	blez	a5,80006322 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062f0:	37fd                	addiw	a5,a5,-1
    800062f2:	0007871b          	sext.w	a4,a5
    800062f6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062f8:	eb09                	bnez	a4,8000630a <pop_off+0x38>
    800062fa:	5d7c                	lw	a5,124(a0)
    800062fc:	c799                	beqz	a5,8000630a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006302:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006306:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000630a:	60a2                	ld	ra,8(sp)
    8000630c:	6402                	ld	s0,0(sp)
    8000630e:	0141                	addi	sp,sp,16
    80006310:	8082                	ret
    panic("pop_off - interruptible");
    80006312:	00002517          	auipc	a0,0x2
    80006316:	52e50513          	addi	a0,a0,1326 # 80008840 <digits+0x28>
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	a56080e7          	jalr	-1450(ra) # 80005d70 <panic>
    panic("pop_off");
    80006322:	00002517          	auipc	a0,0x2
    80006326:	53650513          	addi	a0,a0,1334 # 80008858 <digits+0x40>
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	a46080e7          	jalr	-1466(ra) # 80005d70 <panic>

0000000080006332 <release>:
{
    80006332:	1101                	addi	sp,sp,-32
    80006334:	ec06                	sd	ra,24(sp)
    80006336:	e822                	sd	s0,16(sp)
    80006338:	e426                	sd	s1,8(sp)
    8000633a:	1000                	addi	s0,sp,32
    8000633c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	ec6080e7          	jalr	-314(ra) # 80006204 <holding>
    80006346:	c115                	beqz	a0,8000636a <release+0x38>
  lk->cpu = 0;
    80006348:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000634c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006350:	0f50000f          	fence	iorw,ow
    80006354:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	f7a080e7          	jalr	-134(ra) # 800062d2 <pop_off>
}
    80006360:	60e2                	ld	ra,24(sp)
    80006362:	6442                	ld	s0,16(sp)
    80006364:	64a2                	ld	s1,8(sp)
    80006366:	6105                	addi	sp,sp,32
    80006368:	8082                	ret
    panic("release");
    8000636a:	00002517          	auipc	a0,0x2
    8000636e:	4f650513          	addi	a0,a0,1270 # 80008860 <digits+0x48>
    80006372:	00000097          	auipc	ra,0x0
    80006376:	9fe080e7          	jalr	-1538(ra) # 80005d70 <panic>
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
