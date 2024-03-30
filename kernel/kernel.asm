
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7d0050ef          	jal	ra,800057e6 <start>

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
    80000030:	0001d797          	auipc	a5,0x1d
    80000034:	13078793          	addi	a5,a5,304 # 8001d160 <end>
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
    80000054:	89090913          	addi	s2,s2,-1904 # 800088e0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	174080e7          	jalr	372(ra) # 800061ce <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	214080e7          	jalr	532(ra) # 80006282 <release>
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
    8000008e:	c0c080e7          	jalr	-1012(ra) # 80005c96 <panic>

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
    800000ee:	00008517          	auipc	a0,0x8
    800000f2:	7f250513          	addi	a0,a0,2034 # 800088e0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	048080e7          	jalr	72(ra) # 8000613e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	0001d517          	auipc	a0,0x1d
    80000106:	05e50513          	addi	a0,a0,94 # 8001d160 <end>
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
    80000128:	7bc48493          	addi	s1,s1,1980 # 800088e0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	0a0080e7          	jalr	160(ra) # 800061ce <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00008517          	auipc	a0,0x8
    80000140:	7a450513          	addi	a0,a0,1956 # 800088e0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	13c080e7          	jalr	316(ra) # 80006282 <release>

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
    8000016c:	77850513          	addi	a0,a0,1912 # 800088e0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	112080e7          	jalr	274(ra) # 80006282 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe1ea1>
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
    80000332:	58270713          	addi	a4,a4,1410 # 800088b0 <started>
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
    80000358:	98c080e7          	jalr	-1652(ra) # 80005ce0 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	786080e7          	jalr	1926(ra) # 80001aea <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	e34080e7          	jalr	-460(ra) # 800051a0 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fd4080e7          	jalr	-44(ra) # 80001348 <scheduler>
    consoleinit();
    8000037c:	00006097          	auipc	ra,0x6
    80000380:	82a080e7          	jalr	-2006(ra) # 80005ba6 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b3c080e7          	jalr	-1220(ra) # 80005ec0 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	94c080e7          	jalr	-1716(ra) # 80005ce0 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	93c080e7          	jalr	-1732(ra) # 80005ce0 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	92c080e7          	jalr	-1748(ra) # 80005ce0 <printf>
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
    800003e0:	6e6080e7          	jalr	1766(ra) # 80001ac2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	706080e7          	jalr	1798(ra) # 80001aea <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d9e080e7          	jalr	-610(ra) # 8000518a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	dac080e7          	jalr	-596(ra) # 800051a0 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	e3c080e7          	jalr	-452(ra) # 80002238 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5ac080e7          	jalr	1452(ra) # 800029b0 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	5b8080e7          	jalr	1464(ra) # 800039c4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e94080e7          	jalr	-364(ra) # 800052a8 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d0e080e7          	jalr	-754(ra) # 8000112a <userinit>
    __sync_synchronize();
    80000424:	0ff0000f          	fence
    started = 1;
    80000428:	4785                	li	a5,1
    8000042a:	00008717          	auipc	a4,0x8
    8000042e:	48f72323          	sw	a5,1158(a4) # 800088b0 <started>
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
    80000442:	47a7b783          	ld	a5,1146(a5) # 800088b8 <kernel_pagetable>
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
    8000048e:	80c080e7          	jalr	-2036(ra) # 80005c96 <panic>
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
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffe1e97>
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
    800005b4:	6e6080e7          	jalr	1766(ra) # 80005c96 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	6d6080e7          	jalr	1750(ra) # 80005c96 <panic>
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
    80000610:	68a080e7          	jalr	1674(ra) # 80005c96 <panic>

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
    800006fe:	1aa7bf23          	sd	a0,446(a5) # 800088b8 <kernel_pagetable>
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
    8000075c:	53e080e7          	jalr	1342(ra) # 80005c96 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	52e080e7          	jalr	1326(ra) # 80005c96 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	51e080e7          	jalr	1310(ra) # 80005c96 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	50e080e7          	jalr	1294(ra) # 80005c96 <panic>
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
    8000086a:	430080e7          	jalr	1072(ra) # 80005c96 <panic>

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
    800009b6:	2e4080e7          	jalr	740(ra) # 80005c96 <panic>
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
    80000a94:	206080e7          	jalr	518(ra) # 80005c96 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	1f6080e7          	jalr	502(ra) # 80005c96 <panic>
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
    80000b0e:	18c080e7          	jalr	396(ra) # 80005c96 <panic>

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
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffe1ea0>
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
    80000cf6:	03e48493          	addi	s1,s1,62 # 80008d30 <proc>
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
    80000d0c:	00009a17          	auipc	s4,0x9
    80000d10:	e34a0a13          	addi	s4,s4,-460 # 80009b40 <tickslock>
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
    80000d46:	16848493          	addi	s1,s1,360
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
    80000d6e:	f2c080e7          	jalr	-212(ra) # 80005c96 <panic>

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
    80000d92:	b7250513          	addi	a0,a0,-1166 # 80008900 <pid_lock>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	3a8080e7          	jalr	936(ra) # 8000613e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	b7250513          	addi	a0,a0,-1166 # 80008918 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	390080e7          	jalr	912(ra) # 8000613e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00008497          	auipc	s1,0x8
    80000dba:	f7a48493          	addi	s1,s1,-134 # 80008d30 <proc>
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
    80000dd8:	00009997          	auipc	s3,0x9
    80000ddc:	d6898993          	addi	s3,s3,-664 # 80009b40 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	35a080e7          	jalr	858(ra) # 8000613e <initlock>
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
    80000e0a:	16848493          	addi	s1,s1,360
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
    80000e46:	aee50513          	addi	a0,a0,-1298 # 80008930 <cpus>
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
    80000e60:	326080e7          	jalr	806(ra) # 80006182 <push_off>
    80000e64:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e66:	2781                	sext.w	a5,a5
    80000e68:	079e                	slli	a5,a5,0x7
    80000e6a:	00008717          	auipc	a4,0x8
    80000e6e:	a9670713          	addi	a4,a4,-1386 # 80008900 <pid_lock>
    80000e72:	97ba                	add	a5,a5,a4
    80000e74:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	3ac080e7          	jalr	940(ra) # 80006222 <pop_off>
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
    80000e9e:	3e8080e7          	jalr	1000(ra) # 80006282 <release>

  if (first) {
    80000ea2:	00008797          	auipc	a5,0x8
    80000ea6:	99e7a783          	lw	a5,-1634(a5) # 80008840 <first.1>
    80000eaa:	eb89                	bnez	a5,80000ebc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eac:	00001097          	auipc	ra,0x1
    80000eb0:	c56080e7          	jalr	-938(ra) # 80001b02 <usertrapret>
}
    80000eb4:	60a2                	ld	ra,8(sp)
    80000eb6:	6402                	ld	s0,0(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
    first = 0;
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	9807a223          	sw	zero,-1660(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000ec4:	4505                	li	a0,1
    80000ec6:	00002097          	auipc	ra,0x2
    80000eca:	a6a080e7          	jalr	-1430(ra) # 80002930 <fsinit>
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
    80000ee0:	a2490913          	addi	s2,s2,-1500 # 80008900 <pid_lock>
    80000ee4:	854a                	mv	a0,s2
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	2e8080e7          	jalr	744(ra) # 800061ce <acquire>
  pid = nextpid;
    80000eee:	00008797          	auipc	a5,0x8
    80000ef2:	95678793          	addi	a5,a5,-1706 # 80008844 <nextpid>
    80000ef6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef8:	0014871b          	addiw	a4,s1,1
    80000efc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	382080e7          	jalr	898(ra) # 80006282 <release>
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
  if(p->pagetable)
    80001020:	68a8                	ld	a0,80(s1)
    80001022:	c511                	beqz	a0,8000102e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001024:	64ac                	ld	a1,72(s1)
    80001026:	00000097          	auipc	ra,0x0
    8000102a:	f8c080e7          	jalr	-116(ra) # 80000fb2 <proc_freepagetable>
  p->pagetable = 0;
    8000102e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001032:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001036:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000103a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000103e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001042:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001046:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000104a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000104e:	0004ac23          	sw	zero,24(s1)
}
    80001052:	60e2                	ld	ra,24(sp)
    80001054:	6442                	ld	s0,16(sp)
    80001056:	64a2                	ld	s1,8(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <allocproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	e04a                	sd	s2,0(sp)
    80001066:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001068:	00008497          	auipc	s1,0x8
    8000106c:	cc848493          	addi	s1,s1,-824 # 80008d30 <proc>
    80001070:	00009917          	auipc	s2,0x9
    80001074:	ad090913          	addi	s2,s2,-1328 # 80009b40 <tickslock>
    acquire(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	154080e7          	jalr	340(ra) # 800061ce <acquire>
    if(p->state == UNUSED) {
    80001082:	4c9c                	lw	a5,24(s1)
    80001084:	c395                	beqz	a5,800010a8 <allocproc+0x4c>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	1fa080e7          	jalr	506(ra) # 80006282 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	16848493          	addi	s1,s1,360
    80001094:	ff2492e3          	bne	s1,s2,80001078 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
}
    8000109a:	8526                	mv	a0,s1
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6902                	ld	s2,0(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret
  p->pid = allocpid();
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	e28080e7          	jalr	-472(ra) # 80000ed0 <allocpid>
    800010b0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b2:	4785                	li	a5,1
    800010b4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b6:	fffff097          	auipc	ra,0xfffff
    800010ba:	064080e7          	jalr	100(ra) # 8000011a <kalloc>
    800010be:	892a                	mv	s2,a0
    800010c0:	eca8                	sd	a0,88(s1)
    800010c2:	cd05                	beqz	a0,800010fa <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e50080e7          	jalr	-432(ra) # 80000f16 <proc_pagetable>
    800010ce:	892a                	mv	s2,a0
    800010d0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d2:	c121                	beqz	a0,80001112 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d4:	07000613          	li	a2,112
    800010d8:	4581                	li	a1,0
    800010da:	06048513          	addi	a0,s1,96
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	09c080e7          	jalr	156(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010e6:	00000797          	auipc	a5,0x0
    800010ea:	da478793          	addi	a5,a5,-604 # 80000e8a <forkret>
    800010ee:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010f0:	60bc                	ld	a5,64(s1)
    800010f2:	6705                	lui	a4,0x1
    800010f4:	97ba                	add	a5,a5,a4
    800010f6:	f4bc                	sd	a5,104(s1)
  return p;
    800010f8:	b74d                	j	8000109a <allocproc+0x3e>
    freeproc(p);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	f08080e7          	jalr	-248(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	00005097          	auipc	ra,0x5
    8000110a:	17c080e7          	jalr	380(ra) # 80006282 <release>
    return 0;
    8000110e:	84ca                	mv	s1,s2
    80001110:	b769                	j	8000109a <allocproc+0x3e>
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	164080e7          	jalr	356(ra) # 80006282 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	bf8d                	j	8000109a <allocproc+0x3e>

000000008000112a <userinit>:
{
    8000112a:	1101                	addi	sp,sp,-32
    8000112c:	ec06                	sd	ra,24(sp)
    8000112e:	e822                	sd	s0,16(sp)
    80001130:	e426                	sd	s1,8(sp)
    80001132:	1000                	addi	s0,sp,32
  p = allocproc();
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f28080e7          	jalr	-216(ra) # 8000105c <allocproc>
    8000113c:	84aa                	mv	s1,a0
  initproc = p;
    8000113e:	00007797          	auipc	a5,0x7
    80001142:	78a7b123          	sd	a0,1922(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001146:	03400613          	li	a2,52
    8000114a:	00007597          	auipc	a1,0x7
    8000114e:	70658593          	addi	a1,a1,1798 # 80008850 <initcode>
    80001152:	6928                	ld	a0,80(a0)
    80001154:	fffff097          	auipc	ra,0xfffff
    80001158:	6a8080e7          	jalr	1704(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    8000115c:	6785                	lui	a5,0x1
    8000115e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001160:	6cb8                	ld	a4,88(s1)
    80001162:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116a:	4641                	li	a2,16
    8000116c:	00007597          	auipc	a1,0x7
    80001170:	01458593          	addi	a1,a1,20 # 80008180 <etext+0x180>
    80001174:	15848513          	addi	a0,s1,344
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	14a080e7          	jalr	330(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001180:	00007517          	auipc	a0,0x7
    80001184:	01050513          	addi	a0,a0,16 # 80008190 <etext+0x190>
    80001188:	00002097          	auipc	ra,0x2
    8000118c:	25c080e7          	jalr	604(ra) # 800033e4 <namei>
    80001190:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001194:	478d                	li	a5,3
    80001196:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001198:	8526                	mv	a0,s1
    8000119a:	00005097          	auipc	ra,0x5
    8000119e:	0e8080e7          	jalr	232(ra) # 80006282 <release>
}
    800011a2:	60e2                	ld	ra,24(sp)
    800011a4:	6442                	ld	s0,16(sp)
    800011a6:	64a2                	ld	s1,8(sp)
    800011a8:	6105                	addi	sp,sp,32
    800011aa:	8082                	ret

00000000800011ac <growproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	c98080e7          	jalr	-872(ra) # 80000e52 <myproc>
    800011c2:	84aa                	mv	s1,a0
  sz = p->sz;
    800011c4:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011c6:	01204c63          	bgtz	s2,800011de <growproc+0x32>
  } else if(n < 0){
    800011ca:	02094663          	bltz	s2,800011f6 <growproc+0x4a>
  p->sz = sz;
    800011ce:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011de:	4691                	li	a3,4
    800011e0:	00b90633          	add	a2,s2,a1
    800011e4:	6928                	ld	a0,80(a0)
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	6d0080e7          	jalr	1744(ra) # 800008b6 <uvmalloc>
    800011ee:	85aa                	mv	a1,a0
    800011f0:	fd79                	bnez	a0,800011ce <growproc+0x22>
      return -1;
    800011f2:	557d                	li	a0,-1
    800011f4:	bff9                	j	800011d2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011f6:	00b90633          	add	a2,s2,a1
    800011fa:	6928                	ld	a0,80(a0)
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	672080e7          	jalr	1650(ra) # 8000086e <uvmdealloc>
    80001204:	85aa                	mv	a1,a0
    80001206:	b7e1                	j	800011ce <growproc+0x22>

0000000080001208 <fork>:
{
    80001208:	7139                	addi	sp,sp,-64
    8000120a:	fc06                	sd	ra,56(sp)
    8000120c:	f822                	sd	s0,48(sp)
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	c38080e7          	jalr	-968(ra) # 80000e52 <myproc>
    80001222:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001224:	00000097          	auipc	ra,0x0
    80001228:	e38080e7          	jalr	-456(ra) # 8000105c <allocproc>
    8000122c:	10050c63          	beqz	a0,80001344 <fork+0x13c>
    80001230:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001232:	048ab603          	ld	a2,72(s5)
    80001236:	692c                	ld	a1,80(a0)
    80001238:	050ab503          	ld	a0,80(s5)
    8000123c:	fffff097          	auipc	ra,0xfffff
    80001240:	7d2080e7          	jalr	2002(ra) # 80000a0e <uvmcopy>
    80001244:	04054863          	bltz	a0,80001294 <fork+0x8c>
  np->sz = p->sz;
    80001248:	048ab783          	ld	a5,72(s5)
    8000124c:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001250:	058ab683          	ld	a3,88(s5)
    80001254:	87b6                	mv	a5,a3
    80001256:	058a3703          	ld	a4,88(s4)
    8000125a:	12068693          	addi	a3,a3,288
    8000125e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001262:	6788                	ld	a0,8(a5)
    80001264:	6b8c                	ld	a1,16(a5)
    80001266:	6f90                	ld	a2,24(a5)
    80001268:	01073023          	sd	a6,0(a4)
    8000126c:	e708                	sd	a0,8(a4)
    8000126e:	eb0c                	sd	a1,16(a4)
    80001270:	ef10                	sd	a2,24(a4)
    80001272:	02078793          	addi	a5,a5,32
    80001276:	02070713          	addi	a4,a4,32
    8000127a:	fed792e3          	bne	a5,a3,8000125e <fork+0x56>
  np->trapframe->a0 = 0;
    8000127e:	058a3783          	ld	a5,88(s4)
    80001282:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001286:	0d0a8493          	addi	s1,s5,208
    8000128a:	0d0a0913          	addi	s2,s4,208
    8000128e:	150a8993          	addi	s3,s5,336
    80001292:	a00d                	j	800012b4 <fork+0xac>
    freeproc(np);
    80001294:	8552                	mv	a0,s4
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d6e080e7          	jalr	-658(ra) # 80001004 <freeproc>
    release(&np->lock);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	fe2080e7          	jalr	-30(ra) # 80006282 <release>
    return -1;
    800012a8:	597d                	li	s2,-1
    800012aa:	a059                	j	80001330 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ac:	04a1                	addi	s1,s1,8
    800012ae:	0921                	addi	s2,s2,8
    800012b0:	01348b63          	beq	s1,s3,800012c6 <fork+0xbe>
    if(p->ofile[i])
    800012b4:	6088                	ld	a0,0(s1)
    800012b6:	d97d                	beqz	a0,800012ac <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	79e080e7          	jalr	1950(ra) # 80003a56 <filedup>
    800012c0:	00a93023          	sd	a0,0(s2)
    800012c4:	b7e5                	j	800012ac <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012c6:	150ab503          	ld	a0,336(s5)
    800012ca:	00002097          	auipc	ra,0x2
    800012ce:	8a0080e7          	jalr	-1888(ra) # 80002b6a <idup>
    800012d2:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012d6:	4641                	li	a2,16
    800012d8:	158a8593          	addi	a1,s5,344
    800012dc:	158a0513          	addi	a0,s4,344
    800012e0:	fffff097          	auipc	ra,0xfffff
    800012e4:	fe2080e7          	jalr	-30(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    800012e8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00005097          	auipc	ra,0x5
    800012f2:	f94080e7          	jalr	-108(ra) # 80006282 <release>
  acquire(&wait_lock);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	62248493          	addi	s1,s1,1570 # 80008918 <wait_lock>
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	ece080e7          	jalr	-306(ra) # 800061ce <acquire>
  np->parent = p;
    80001308:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	f74080e7          	jalr	-140(ra) # 80006282 <release>
  acquire(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	eb6080e7          	jalr	-330(ra) # 800061ce <acquire>
  np->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001326:	8552                	mv	a0,s4
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	f5a080e7          	jalr	-166(ra) # 80006282 <release>
}
    80001330:	854a                	mv	a0,s2
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	74a2                	ld	s1,40(sp)
    80001338:	7902                	ld	s2,32(sp)
    8000133a:	69e2                	ld	s3,24(sp)
    8000133c:	6a42                	ld	s4,16(sp)
    8000133e:	6aa2                	ld	s5,8(sp)
    80001340:	6121                	addi	sp,sp,64
    80001342:	8082                	ret
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	b7ed                	j	80001330 <fork+0x128>

0000000080001348 <scheduler>:
{
    80001348:	7139                	addi	sp,sp,-64
    8000134a:	fc06                	sd	ra,56(sp)
    8000134c:	f822                	sd	s0,48(sp)
    8000134e:	f426                	sd	s1,40(sp)
    80001350:	f04a                	sd	s2,32(sp)
    80001352:	ec4e                	sd	s3,24(sp)
    80001354:	e852                	sd	s4,16(sp)
    80001356:	e456                	sd	s5,8(sp)
    80001358:	e05a                	sd	s6,0(sp)
    8000135a:	0080                	addi	s0,sp,64
    8000135c:	8792                	mv	a5,tp
  int id = r_tp();
    8000135e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001360:	00779a93          	slli	s5,a5,0x7
    80001364:	00007717          	auipc	a4,0x7
    80001368:	59c70713          	addi	a4,a4,1436 # 80008900 <pid_lock>
    8000136c:	9756                	add	a4,a4,s5
    8000136e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5c670713          	addi	a4,a4,1478 # 80008938 <cpus+0x8>
    8000137a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137c:	498d                	li	s3,3
        p->state = RUNNING;
    8000137e:	4b11                	li	s6,4
        c->proc = p;
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00007a17          	auipc	s4,0x7
    80001386:	57ea0a13          	addi	s4,s4,1406 # 80008900 <pid_lock>
    8000138a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138c:	00008917          	auipc	s2,0x8
    80001390:	7b490913          	addi	s2,s2,1972 # 80009b40 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001394:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001398:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139c:	10079073          	csrw	sstatus,a5
    800013a0:	00008497          	auipc	s1,0x8
    800013a4:	99048493          	addi	s1,s1,-1648 # 80008d30 <proc>
    800013a8:	a811                	j	800013bc <scheduler+0x74>
      release(&p->lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	ed6080e7          	jalr	-298(ra) # 80006282 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013b4:	16848493          	addi	s1,s1,360
    800013b8:	fd248ee3          	beq	s1,s2,80001394 <scheduler+0x4c>
      acquire(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	00005097          	auipc	ra,0x5
    800013c2:	e10080e7          	jalr	-496(ra) # 800061ce <acquire>
      if(p->state == RUNNABLE) {
    800013c6:	4c9c                	lw	a5,24(s1)
    800013c8:	ff3791e3          	bne	a5,s3,800013aa <scheduler+0x62>
        p->state = RUNNING;
    800013cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013d4:	06048593          	addi	a1,s1,96
    800013d8:	8556                	mv	a0,s5
    800013da:	00000097          	auipc	ra,0x0
    800013de:	67e080e7          	jalr	1662(ra) # 80001a58 <swtch>
        c->proc = 0;
    800013e2:	020a3823          	sd	zero,48(s4)
    800013e6:	b7d1                	j	800013aa <scheduler+0x62>

00000000800013e8 <sched>:
{
    800013e8:	7179                	addi	sp,sp,-48
    800013ea:	f406                	sd	ra,40(sp)
    800013ec:	f022                	sd	s0,32(sp)
    800013ee:	ec26                	sd	s1,24(sp)
    800013f0:	e84a                	sd	s2,16(sp)
    800013f2:	e44e                	sd	s3,8(sp)
    800013f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	a5c080e7          	jalr	-1444(ra) # 80000e52 <myproc>
    800013fe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001400:	00005097          	auipc	ra,0x5
    80001404:	d54080e7          	jalr	-684(ra) # 80006154 <holding>
    80001408:	c93d                	beqz	a0,8000147e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140c:	2781                	sext.w	a5,a5
    8000140e:	079e                	slli	a5,a5,0x7
    80001410:	00007717          	auipc	a4,0x7
    80001414:	4f070713          	addi	a4,a4,1264 # 80008900 <pid_lock>
    80001418:	97ba                	add	a5,a5,a4
    8000141a:	0a87a703          	lw	a4,168(a5)
    8000141e:	4785                	li	a5,1
    80001420:	06f71763          	bne	a4,a5,8000148e <sched+0xa6>
  if(p->state == RUNNING)
    80001424:	4c98                	lw	a4,24(s1)
    80001426:	4791                	li	a5,4
    80001428:	06f70b63          	beq	a4,a5,8000149e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001430:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001432:	efb5                	bnez	a5,800014ae <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001434:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001436:	00007917          	auipc	s2,0x7
    8000143a:	4ca90913          	addi	s2,s2,1226 # 80008900 <pid_lock>
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	97ca                	add	a5,a5,s2
    80001444:	0ac7a983          	lw	s3,172(a5)
    80001448:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	00007597          	auipc	a1,0x7
    80001452:	4ea58593          	addi	a1,a1,1258 # 80008938 <cpus+0x8>
    80001456:	95be                	add	a1,a1,a5
    80001458:	06048513          	addi	a0,s1,96
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	5fc080e7          	jalr	1532(ra) # 80001a58 <swtch>
    80001464:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	993e                	add	s2,s2,a5
    8000146c:	0b392623          	sw	s3,172(s2)
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret
    panic("sched p->lock");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	d1a50513          	addi	a0,a0,-742 # 80008198 <etext+0x198>
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	810080e7          	jalr	-2032(ra) # 80005c96 <panic>
    panic("sched locks");
    8000148e:	00007517          	auipc	a0,0x7
    80001492:	d1a50513          	addi	a0,a0,-742 # 800081a8 <etext+0x1a8>
    80001496:	00005097          	auipc	ra,0x5
    8000149a:	800080e7          	jalr	-2048(ra) # 80005c96 <panic>
    panic("sched running");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	d1a50513          	addi	a0,a0,-742 # 800081b8 <etext+0x1b8>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	7f0080e7          	jalr	2032(ra) # 80005c96 <panic>
    panic("sched interruptible");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	d1a50513          	addi	a0,a0,-742 # 800081c8 <etext+0x1c8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	7e0080e7          	jalr	2016(ra) # 80005c96 <panic>

00000000800014be <yield>:
{
    800014be:	1101                	addi	sp,sp,-32
    800014c0:	ec06                	sd	ra,24(sp)
    800014c2:	e822                	sd	s0,16(sp)
    800014c4:	e426                	sd	s1,8(sp)
    800014c6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	98a080e7          	jalr	-1654(ra) # 80000e52 <myproc>
    800014d0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	cfc080e7          	jalr	-772(ra) # 800061ce <acquire>
  p->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	cc9c                	sw	a5,24(s1)
  sched();
    800014de:	00000097          	auipc	ra,0x0
    800014e2:	f0a080e7          	jalr	-246(ra) # 800013e8 <sched>
  release(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	d9a080e7          	jalr	-614(ra) # 80006282 <release>
}
    800014f0:	60e2                	ld	ra,24(sp)
    800014f2:	6442                	ld	s0,16(sp)
    800014f4:	64a2                	ld	s1,8(sp)
    800014f6:	6105                	addi	sp,sp,32
    800014f8:	8082                	ret

00000000800014fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fa:	7179                	addi	sp,sp,-48
    800014fc:	f406                	sd	ra,40(sp)
    800014fe:	f022                	sd	s0,32(sp)
    80001500:	ec26                	sd	s1,24(sp)
    80001502:	e84a                	sd	s2,16(sp)
    80001504:	e44e                	sd	s3,8(sp)
    80001506:	1800                	addi	s0,sp,48
    80001508:	89aa                	mv	s3,a0
    8000150a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	946080e7          	jalr	-1722(ra) # 80000e52 <myproc>
    80001514:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	cb8080e7          	jalr	-840(ra) # 800061ce <acquire>
  release(lk);
    8000151e:	854a                	mv	a0,s2
    80001520:	00005097          	auipc	ra,0x5
    80001524:	d62080e7          	jalr	-670(ra) # 80006282 <release>

  // Go to sleep.
  p->chan = chan;
    80001528:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152c:	4789                	li	a5,2
    8000152e:	cc9c                	sw	a5,24(s1)

  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	eb8080e7          	jalr	-328(ra) # 800013e8 <sched>

  // Tidy up.
  p->chan = 0;
    80001538:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	d44080e7          	jalr	-700(ra) # 80006282 <release>
  acquire(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	c86080e7          	jalr	-890(ra) # 800061ce <acquire>
}
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6145                	addi	sp,sp,48
    8000155c:	8082                	ret

000000008000155e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000155e:	7179                	addi	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	e052                	sd	s4,0(sp)
    8000156c:	1800                	addi	s0,sp,48
    8000156e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001570:	00007497          	auipc	s1,0x7
    80001574:	7c048493          	addi	s1,s1,1984 # 80008d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001578:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000157a:	00008917          	auipc	s2,0x8
    8000157e:	5c690913          	addi	s2,s2,1478 # 80009b40 <tickslock>
    80001582:	a811                	j	80001596 <wakeup+0x38>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	cfc080e7          	jalr	-772(ra) # 80006282 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158e:	16848493          	addi	s1,s1,360
    80001592:	03248663          	beq	s1,s2,800015be <wakeup+0x60>
    if(p != myproc()){
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	8bc080e7          	jalr	-1860(ra) # 80000e52 <myproc>
    8000159e:	fea488e3          	beq	s1,a0,8000158e <wakeup+0x30>
      acquire(&p->lock);
    800015a2:	8526                	mv	a0,s1
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c2a080e7          	jalr	-982(ra) # 800061ce <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015ac:	4c9c                	lw	a5,24(s1)
    800015ae:	fd379be3          	bne	a5,s3,80001584 <wakeup+0x26>
    800015b2:	709c                	ld	a5,32(s1)
    800015b4:	fd4798e3          	bne	a5,s4,80001584 <wakeup+0x26>
        p->state = RUNNABLE;
    800015b8:	478d                	li	a5,3
    800015ba:	cc9c                	sw	a5,24(s1)
    800015bc:	b7e1                	j	80001584 <wakeup+0x26>
    }
  }
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6a02                	ld	s4,0(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret

00000000800015ce <reparent>:
{
    800015ce:	7179                	addi	sp,sp,-48
    800015d0:	f406                	sd	ra,40(sp)
    800015d2:	f022                	sd	s0,32(sp)
    800015d4:	ec26                	sd	s1,24(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	e44e                	sd	s3,8(sp)
    800015da:	e052                	sd	s4,0(sp)
    800015dc:	1800                	addi	s0,sp,48
    800015de:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e0:	00007497          	auipc	s1,0x7
    800015e4:	75048493          	addi	s1,s1,1872 # 80008d30 <proc>
      pp->parent = initproc;
    800015e8:	00007a17          	auipc	s4,0x7
    800015ec:	2d8a0a13          	addi	s4,s4,728 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f0:	00008997          	auipc	s3,0x8
    800015f4:	55098993          	addi	s3,s3,1360 # 80009b40 <tickslock>
    800015f8:	a029                	j	80001602 <reparent+0x34>
    800015fa:	16848493          	addi	s1,s1,360
    800015fe:	01348d63          	beq	s1,s3,80001618 <reparent+0x4a>
    if(pp->parent == p){
    80001602:	7c9c                	ld	a5,56(s1)
    80001604:	ff279be3          	bne	a5,s2,800015fa <reparent+0x2c>
      pp->parent = initproc;
    80001608:	000a3503          	ld	a0,0(s4)
    8000160c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	f50080e7          	jalr	-176(ra) # 8000155e <wakeup>
    80001616:	b7d5                	j	800015fa <reparent+0x2c>
}
    80001618:	70a2                	ld	ra,40(sp)
    8000161a:	7402                	ld	s0,32(sp)
    8000161c:	64e2                	ld	s1,24(sp)
    8000161e:	6942                	ld	s2,16(sp)
    80001620:	69a2                	ld	s3,8(sp)
    80001622:	6a02                	ld	s4,0(sp)
    80001624:	6145                	addi	sp,sp,48
    80001626:	8082                	ret

0000000080001628 <exit>:
{
    80001628:	7179                	addi	sp,sp,-48
    8000162a:	f406                	sd	ra,40(sp)
    8000162c:	f022                	sd	s0,32(sp)
    8000162e:	ec26                	sd	s1,24(sp)
    80001630:	e84a                	sd	s2,16(sp)
    80001632:	e44e                	sd	s3,8(sp)
    80001634:	e052                	sd	s4,0(sp)
    80001636:	1800                	addi	s0,sp,48
    80001638:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	818080e7          	jalr	-2024(ra) # 80000e52 <myproc>
    80001642:	89aa                	mv	s3,a0
  if(p == initproc)
    80001644:	00007797          	auipc	a5,0x7
    80001648:	27c7b783          	ld	a5,636(a5) # 800088c0 <initproc>
    8000164c:	0d050493          	addi	s1,a0,208
    80001650:	15050913          	addi	s2,a0,336
    80001654:	02a79363          	bne	a5,a0,8000167a <exit+0x52>
    panic("init exiting");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b8850513          	addi	a0,a0,-1144 # 800081e0 <etext+0x1e0>
    80001660:	00004097          	auipc	ra,0x4
    80001664:	636080e7          	jalr	1590(ra) # 80005c96 <panic>
      fileclose(f);
    80001668:	00002097          	auipc	ra,0x2
    8000166c:	440080e7          	jalr	1088(ra) # 80003aa8 <fileclose>
      p->ofile[fd] = 0;
    80001670:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001674:	04a1                	addi	s1,s1,8
    80001676:	01248563          	beq	s1,s2,80001680 <exit+0x58>
    if(p->ofile[fd]){
    8000167a:	6088                	ld	a0,0(s1)
    8000167c:	f575                	bnez	a0,80001668 <exit+0x40>
    8000167e:	bfdd                	j	80001674 <exit+0x4c>
  begin_op();
    80001680:	00002097          	auipc	ra,0x2
    80001684:	f64080e7          	jalr	-156(ra) # 800035e4 <begin_op>
  iput(p->cwd);
    80001688:	1509b503          	ld	a0,336(s3)
    8000168c:	00001097          	auipc	ra,0x1
    80001690:	76a080e7          	jalr	1898(ra) # 80002df6 <iput>
  end_op();
    80001694:	00002097          	auipc	ra,0x2
    80001698:	fca080e7          	jalr	-54(ra) # 8000365e <end_op>
  p->cwd = 0;
    8000169c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a0:	00007497          	auipc	s1,0x7
    800016a4:	27848493          	addi	s1,s1,632 # 80008918 <wait_lock>
    800016a8:	8526                	mv	a0,s1
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	b24080e7          	jalr	-1244(ra) # 800061ce <acquire>
  reparent(p);
    800016b2:	854e                	mv	a0,s3
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	f1a080e7          	jalr	-230(ra) # 800015ce <reparent>
  wakeup(p->parent);
    800016bc:	0389b503          	ld	a0,56(s3)
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	e9e080e7          	jalr	-354(ra) # 8000155e <wakeup>
  acquire(&p->lock);
    800016c8:	854e                	mv	a0,s3
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	b04080e7          	jalr	-1276(ra) # 800061ce <acquire>
  p->xstate = status;
    800016d2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016d6:	4795                	li	a5,5
    800016d8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	ba4080e7          	jalr	-1116(ra) # 80006282 <release>
  sched();
    800016e6:	00000097          	auipc	ra,0x0
    800016ea:	d02080e7          	jalr	-766(ra) # 800013e8 <sched>
  panic("zombie exit");
    800016ee:	00007517          	auipc	a0,0x7
    800016f2:	b0250513          	addi	a0,a0,-1278 # 800081f0 <etext+0x1f0>
    800016f6:	00004097          	auipc	ra,0x4
    800016fa:	5a0080e7          	jalr	1440(ra) # 80005c96 <panic>

00000000800016fe <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800016fe:	7179                	addi	sp,sp,-48
    80001700:	f406                	sd	ra,40(sp)
    80001702:	f022                	sd	s0,32(sp)
    80001704:	ec26                	sd	s1,24(sp)
    80001706:	e84a                	sd	s2,16(sp)
    80001708:	e44e                	sd	s3,8(sp)
    8000170a:	1800                	addi	s0,sp,48
    8000170c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000170e:	00007497          	auipc	s1,0x7
    80001712:	62248493          	addi	s1,s1,1570 # 80008d30 <proc>
    80001716:	00008997          	auipc	s3,0x8
    8000171a:	42a98993          	addi	s3,s3,1066 # 80009b40 <tickslock>
    acquire(&p->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	00005097          	auipc	ra,0x5
    80001724:	aae080e7          	jalr	-1362(ra) # 800061ce <acquire>
    if(p->pid == pid){
    80001728:	589c                	lw	a5,48(s1)
    8000172a:	03278363          	beq	a5,s2,80001750 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	b52080e7          	jalr	-1198(ra) # 80006282 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001738:	16848493          	addi	s1,s1,360
    8000173c:	ff3491e3          	bne	s1,s3,8000171e <kill+0x20>
  }
  return -1;
    80001740:	557d                	li	a0,-1
}
    80001742:	70a2                	ld	ra,40(sp)
    80001744:	7402                	ld	s0,32(sp)
    80001746:	64e2                	ld	s1,24(sp)
    80001748:	6942                	ld	s2,16(sp)
    8000174a:	69a2                	ld	s3,8(sp)
    8000174c:	6145                	addi	sp,sp,48
    8000174e:	8082                	ret
      p->killed = 1;
    80001750:	4785                	li	a5,1
    80001752:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001754:	4c98                	lw	a4,24(s1)
    80001756:	4789                	li	a5,2
    80001758:	00f70963          	beq	a4,a5,8000176a <kill+0x6c>
      release(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	b24080e7          	jalr	-1244(ra) # 80006282 <release>
      return 0;
    80001766:	4501                	li	a0,0
    80001768:	bfe9                	j	80001742 <kill+0x44>
        p->state = RUNNABLE;
    8000176a:	478d                	li	a5,3
    8000176c:	cc9c                	sw	a5,24(s1)
    8000176e:	b7fd                	j	8000175c <kill+0x5e>

0000000080001770 <setkilled>:

void
setkilled(struct proc *p)
{
    80001770:	1101                	addi	sp,sp,-32
    80001772:	ec06                	sd	ra,24(sp)
    80001774:	e822                	sd	s0,16(sp)
    80001776:	e426                	sd	s1,8(sp)
    80001778:	1000                	addi	s0,sp,32
    8000177a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	a52080e7          	jalr	-1454(ra) # 800061ce <acquire>
  p->killed = 1;
    80001784:	4785                	li	a5,1
    80001786:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001788:	8526                	mv	a0,s1
    8000178a:	00005097          	auipc	ra,0x5
    8000178e:	af8080e7          	jalr	-1288(ra) # 80006282 <release>
}
    80001792:	60e2                	ld	ra,24(sp)
    80001794:	6442                	ld	s0,16(sp)
    80001796:	64a2                	ld	s1,8(sp)
    80001798:	6105                	addi	sp,sp,32
    8000179a:	8082                	ret

000000008000179c <killed>:

int
killed(struct proc *p)
{
    8000179c:	1101                	addi	sp,sp,-32
    8000179e:	ec06                	sd	ra,24(sp)
    800017a0:	e822                	sd	s0,16(sp)
    800017a2:	e426                	sd	s1,8(sp)
    800017a4:	e04a                	sd	s2,0(sp)
    800017a6:	1000                	addi	s0,sp,32
    800017a8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	a24080e7          	jalr	-1500(ra) # 800061ce <acquire>
  k = p->killed;
    800017b2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017b6:	8526                	mv	a0,s1
    800017b8:	00005097          	auipc	ra,0x5
    800017bc:	aca080e7          	jalr	-1334(ra) # 80006282 <release>
  return k;
}
    800017c0:	854a                	mv	a0,s2
    800017c2:	60e2                	ld	ra,24(sp)
    800017c4:	6442                	ld	s0,16(sp)
    800017c6:	64a2                	ld	s1,8(sp)
    800017c8:	6902                	ld	s2,0(sp)
    800017ca:	6105                	addi	sp,sp,32
    800017cc:	8082                	ret

00000000800017ce <wait>:
{
    800017ce:	715d                	addi	sp,sp,-80
    800017d0:	e486                	sd	ra,72(sp)
    800017d2:	e0a2                	sd	s0,64(sp)
    800017d4:	fc26                	sd	s1,56(sp)
    800017d6:	f84a                	sd	s2,48(sp)
    800017d8:	f44e                	sd	s3,40(sp)
    800017da:	f052                	sd	s4,32(sp)
    800017dc:	ec56                	sd	s5,24(sp)
    800017de:	e85a                	sd	s6,16(sp)
    800017e0:	e45e                	sd	s7,8(sp)
    800017e2:	e062                	sd	s8,0(sp)
    800017e4:	0880                	addi	s0,sp,80
    800017e6:	8c2a                	mv	s8,a0
  struct proc *p = myproc();
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	66a080e7          	jalr	1642(ra) # 80000e52 <myproc>
    800017f0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017f2:	00007517          	auipc	a0,0x7
    800017f6:	12650513          	addi	a0,a0,294 # 80008918 <wait_lock>
    800017fa:	00005097          	auipc	ra,0x5
    800017fe:	9d4080e7          	jalr	-1580(ra) # 800061ce <acquire>
    havekids = 0;
    80001802:	4b01                	li	s6,0
        if(pp->state == ZOMBIE){
    80001804:	4a15                	li	s4,5
        havekids = 1;
    80001806:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001808:	00008997          	auipc	s3,0x8
    8000180c:	33898993          	addi	s3,s3,824 # 80009b40 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001810:	00007b97          	auipc	s7,0x7
    80001814:	108b8b93          	addi	s7,s7,264 # 80008918 <wait_lock>
    80001818:	a0d1                	j	800018dc <wait+0x10e>
          pid = pp->pid;
    8000181a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000181e:	000c0e63          	beqz	s8,8000183a <wait+0x6c>
    80001822:	4691                	li	a3,4
    80001824:	02c48613          	addi	a2,s1,44
    80001828:	85e2                	mv	a1,s8
    8000182a:	05093503          	ld	a0,80(s2)
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	2e4080e7          	jalr	740(ra) # 80000b12 <copyout>
    80001836:	04054163          	bltz	a0,80001878 <wait+0xaa>
          freeproc(pp);
    8000183a:	8526                	mv	a0,s1
    8000183c:	fffff097          	auipc	ra,0xfffff
    80001840:	7c8080e7          	jalr	1992(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	a3c080e7          	jalr	-1476(ra) # 80006282 <release>
          release(&wait_lock);
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	0ca50513          	addi	a0,a0,202 # 80008918 <wait_lock>
    80001856:	00005097          	auipc	ra,0x5
    8000185a:	a2c080e7          	jalr	-1492(ra) # 80006282 <release>
}
    8000185e:	854e                	mv	a0,s3
    80001860:	60a6                	ld	ra,72(sp)
    80001862:	6406                	ld	s0,64(sp)
    80001864:	74e2                	ld	s1,56(sp)
    80001866:	7942                	ld	s2,48(sp)
    80001868:	79a2                	ld	s3,40(sp)
    8000186a:	7a02                	ld	s4,32(sp)
    8000186c:	6ae2                	ld	s5,24(sp)
    8000186e:	6b42                	ld	s6,16(sp)
    80001870:	6ba2                	ld	s7,8(sp)
    80001872:	6c02                	ld	s8,0(sp)
    80001874:	6161                	addi	sp,sp,80
    80001876:	8082                	ret
            release(&pp->lock);
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	a08080e7          	jalr	-1528(ra) # 80006282 <release>
            release(&wait_lock);
    80001882:	00007517          	auipc	a0,0x7
    80001886:	09650513          	addi	a0,a0,150 # 80008918 <wait_lock>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	9f8080e7          	jalr	-1544(ra) # 80006282 <release>
            return -1;
    80001892:	59fd                	li	s3,-1
    80001894:	b7e9                	j	8000185e <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001896:	16848493          	addi	s1,s1,360
    8000189a:	03348463          	beq	s1,s3,800018c2 <wait+0xf4>
      if(pp->parent == p){
    8000189e:	7c9c                	ld	a5,56(s1)
    800018a0:	ff279be3          	bne	a5,s2,80001896 <wait+0xc8>
        acquire(&pp->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	928080e7          	jalr	-1752(ra) # 800061ce <acquire>
        if(pp->state == ZOMBIE){
    800018ae:	4c9c                	lw	a5,24(s1)
    800018b0:	f74785e3          	beq	a5,s4,8000181a <wait+0x4c>
        release(&pp->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	9cc080e7          	jalr	-1588(ra) # 80006282 <release>
        havekids = 1;
    800018be:	8756                	mv	a4,s5
    800018c0:	bfd9                	j	80001896 <wait+0xc8>
    if(!havekids || killed(p)){
    800018c2:	c31d                	beqz	a4,800018e8 <wait+0x11a>
    800018c4:	854a                	mv	a0,s2
    800018c6:	00000097          	auipc	ra,0x0
    800018ca:	ed6080e7          	jalr	-298(ra) # 8000179c <killed>
    800018ce:	ed09                	bnez	a0,800018e8 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018d0:	85de                	mv	a1,s7
    800018d2:	854a                	mv	a0,s2
    800018d4:	00000097          	auipc	ra,0x0
    800018d8:	c26080e7          	jalr	-986(ra) # 800014fa <sleep>
    havekids = 0;
    800018dc:	875a                	mv	a4,s6
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018de:	00007497          	auipc	s1,0x7
    800018e2:	45248493          	addi	s1,s1,1106 # 80008d30 <proc>
    800018e6:	bf65                	j	8000189e <wait+0xd0>
      release(&wait_lock);
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	03050513          	addi	a0,a0,48 # 80008918 <wait_lock>
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	992080e7          	jalr	-1646(ra) # 80006282 <release>
      return -1;
    800018f8:	59fd                	li	s3,-1
    800018fa:	b795                	j	8000185e <wait+0x90>

00000000800018fc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fc:	7179                	addi	sp,sp,-48
    800018fe:	f406                	sd	ra,40(sp)
    80001900:	f022                	sd	s0,32(sp)
    80001902:	ec26                	sd	s1,24(sp)
    80001904:	e84a                	sd	s2,16(sp)
    80001906:	e44e                	sd	s3,8(sp)
    80001908:	e052                	sd	s4,0(sp)
    8000190a:	1800                	addi	s0,sp,48
    8000190c:	84aa                	mv	s1,a0
    8000190e:	892e                	mv	s2,a1
    80001910:	89b2                	mv	s3,a2
    80001912:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	53e080e7          	jalr	1342(ra) # 80000e52 <myproc>
  if(user_dst){
    8000191c:	c08d                	beqz	s1,8000193e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191e:	86d2                	mv	a3,s4
    80001920:	864e                	mv	a2,s3
    80001922:	85ca                	mv	a1,s2
    80001924:	6928                	ld	a0,80(a0)
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	1ec080e7          	jalr	492(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192e:	70a2                	ld	ra,40(sp)
    80001930:	7402                	ld	s0,32(sp)
    80001932:	64e2                	ld	s1,24(sp)
    80001934:	6942                	ld	s2,16(sp)
    80001936:	69a2                	ld	s3,8(sp)
    80001938:	6a02                	ld	s4,0(sp)
    8000193a:	6145                	addi	sp,sp,48
    8000193c:	8082                	ret
    memmove((char *)dst, src, len);
    8000193e:	000a061b          	sext.w	a2,s4
    80001942:	85ce                	mv	a1,s3
    80001944:	854a                	mv	a0,s2
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	890080e7          	jalr	-1904(ra) # 800001d6 <memmove>
    return 0;
    8000194e:	8526                	mv	a0,s1
    80001950:	bff9                	j	8000192e <either_copyout+0x32>

0000000080001952 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	892a                	mv	s2,a0
    80001964:	84ae                	mv	s1,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	4e8080e7          	jalr	1256(ra) # 80000e52 <myproc>
  if(user_src){
    80001972:	c08d                	beqz	s1,80001994 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	222080e7          	jalr	546(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
    memmove(dst, (char*)src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	83a080e7          	jalr	-1990(ra) # 800001d6 <memmove>
    return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyin+0x32>

00000000800019a8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a8:	715d                	addi	sp,sp,-80
    800019aa:	e486                	sd	ra,72(sp)
    800019ac:	e0a2                	sd	s0,64(sp)
    800019ae:	fc26                	sd	s1,56(sp)
    800019b0:	f84a                	sd	s2,48(sp)
    800019b2:	f44e                	sd	s3,40(sp)
    800019b4:	f052                	sd	s4,32(sp)
    800019b6:	ec56                	sd	s5,24(sp)
    800019b8:	e85a                	sd	s6,16(sp)
    800019ba:	e45e                	sd	s7,8(sp)
    800019bc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019be:	00006517          	auipc	a0,0x6
    800019c2:	68a50513          	addi	a0,a0,1674 # 80008048 <etext+0x48>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	31a080e7          	jalr	794(ra) # 80005ce0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	00007497          	auipc	s1,0x7
    800019d2:	4ba48493          	addi	s1,s1,1210 # 80008e88 <proc+0x158>
    800019d6:	00008917          	auipc	s2,0x8
    800019da:	2c290913          	addi	s2,s2,706 # 80009c98 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019de:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e0:	00007997          	auipc	s3,0x7
    800019e4:	82098993          	addi	s3,s3,-2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e8:	00007a97          	auipc	s5,0x7
    800019ec:	820a8a93          	addi	s5,s5,-2016 # 80008208 <etext+0x208>
    printf("\n");
    800019f0:	00006a17          	auipc	s4,0x6
    800019f4:	658a0a13          	addi	s4,s4,1624 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f8:	00007b97          	auipc	s7,0x7
    800019fc:	850b8b93          	addi	s7,s7,-1968 # 80008248 <states.0>
    80001a00:	a00d                	j	80001a22 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a02:	ed86a583          	lw	a1,-296(a3)
    80001a06:	8556                	mv	a0,s5
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	2d8080e7          	jalr	728(ra) # 80005ce0 <printf>
    printf("\n");
    80001a10:	8552                	mv	a0,s4
    80001a12:	00004097          	auipc	ra,0x4
    80001a16:	2ce080e7          	jalr	718(ra) # 80005ce0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	16848493          	addi	s1,s1,360
    80001a1e:	03248263          	beq	s1,s2,80001a42 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a22:	86a6                	mv	a3,s1
    80001a24:	ec04a783          	lw	a5,-320(s1)
    80001a28:	dbed                	beqz	a5,80001a1a <procdump+0x72>
      state = "???";
    80001a2a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	fcfb6be3          	bltu	s6,a5,80001a02 <procdump+0x5a>
    80001a30:	02079713          	slli	a4,a5,0x20
    80001a34:	01d75793          	srli	a5,a4,0x1d
    80001a38:	97de                	add	a5,a5,s7
    80001a3a:	6390                	ld	a2,0(a5)
    80001a3c:	f279                	bnez	a2,80001a02 <procdump+0x5a>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    80001a40:	b7c9                	j	80001a02 <procdump+0x5a>
  }
}
    80001a42:	60a6                	ld	ra,72(sp)
    80001a44:	6406                	ld	s0,64(sp)
    80001a46:	74e2                	ld	s1,56(sp)
    80001a48:	7942                	ld	s2,48(sp)
    80001a4a:	79a2                	ld	s3,40(sp)
    80001a4c:	7a02                	ld	s4,32(sp)
    80001a4e:	6ae2                	ld	s5,24(sp)
    80001a50:	6b42                	ld	s6,16(sp)
    80001a52:	6ba2                	ld	s7,8(sp)
    80001a54:	6161                	addi	sp,sp,80
    80001a56:	8082                	ret

0000000080001a58 <swtch>:
    80001a58:	00153023          	sd	ra,0(a0)
    80001a5c:	00253423          	sd	sp,8(a0)
    80001a60:	e900                	sd	s0,16(a0)
    80001a62:	ed04                	sd	s1,24(a0)
    80001a64:	03253023          	sd	s2,32(a0)
    80001a68:	03353423          	sd	s3,40(a0)
    80001a6c:	03453823          	sd	s4,48(a0)
    80001a70:	03553c23          	sd	s5,56(a0)
    80001a74:	05653023          	sd	s6,64(a0)
    80001a78:	05753423          	sd	s7,72(a0)
    80001a7c:	05853823          	sd	s8,80(a0)
    80001a80:	05953c23          	sd	s9,88(a0)
    80001a84:	07a53023          	sd	s10,96(a0)
    80001a88:	07b53423          	sd	s11,104(a0)
    80001a8c:	0005b083          	ld	ra,0(a1)
    80001a90:	0085b103          	ld	sp,8(a1)
    80001a94:	6980                	ld	s0,16(a1)
    80001a96:	6d84                	ld	s1,24(a1)
    80001a98:	0205b903          	ld	s2,32(a1)
    80001a9c:	0285b983          	ld	s3,40(a1)
    80001aa0:	0305ba03          	ld	s4,48(a1)
    80001aa4:	0385ba83          	ld	s5,56(a1)
    80001aa8:	0405bb03          	ld	s6,64(a1)
    80001aac:	0485bb83          	ld	s7,72(a1)
    80001ab0:	0505bc03          	ld	s8,80(a1)
    80001ab4:	0585bc83          	ld	s9,88(a1)
    80001ab8:	0605bd03          	ld	s10,96(a1)
    80001abc:	0685bd83          	ld	s11,104(a1)
    80001ac0:	8082                	ret

0000000080001ac2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aca:	00006597          	auipc	a1,0x6
    80001ace:	7ae58593          	addi	a1,a1,1966 # 80008278 <states.0+0x30>
    80001ad2:	00008517          	auipc	a0,0x8
    80001ad6:	06e50513          	addi	a0,a0,110 # 80009b40 <tickslock>
    80001ada:	00004097          	auipc	ra,0x4
    80001ade:	664080e7          	jalr	1636(ra) # 8000613e <initlock>
}
    80001ae2:	60a2                	ld	ra,8(sp)
    80001ae4:	6402                	ld	s0,0(sp)
    80001ae6:	0141                	addi	sp,sp,16
    80001ae8:	8082                	ret

0000000080001aea <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aea:	1141                	addi	sp,sp,-16
    80001aec:	e422                	sd	s0,8(sp)
    80001aee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	00003797          	auipc	a5,0x3
    80001af4:	5e078793          	addi	a5,a5,1504 # 800050d0 <kernelvec>
    80001af8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afc:	6422                	ld	s0,8(sp)
    80001afe:	0141                	addi	sp,sp,16
    80001b00:	8082                	ret

0000000080001b02 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b02:	1141                	addi	sp,sp,-16
    80001b04:	e406                	sd	ra,8(sp)
    80001b06:	e022                	sd	s0,0(sp)
    80001b08:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	348080e7          	jalr	840(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b18:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b1c:	00005697          	auipc	a3,0x5
    80001b20:	4e468693          	addi	a3,a3,1252 # 80007000 <_trampoline>
    80001b24:	00005717          	auipc	a4,0x5
    80001b28:	4dc70713          	addi	a4,a4,1244 # 80007000 <_trampoline>
    80001b2c:	8f15                	sub	a4,a4,a3
    80001b2e:	040007b7          	lui	a5,0x4000
    80001b32:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b34:	07b2                	slli	a5,a5,0xc
    80001b36:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b38:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b3e:	18002673          	csrr	a2,satp
    80001b42:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b44:	6d30                	ld	a2,88(a0)
    80001b46:	6138                	ld	a4,64(a0)
    80001b48:	6585                	lui	a1,0x1
    80001b4a:	972e                	add	a4,a4,a1
    80001b4c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b4e:	6d38                	ld	a4,88(a0)
    80001b50:	00000617          	auipc	a2,0x0
    80001b54:	13460613          	addi	a2,a2,308 # 80001c84 <usertrap>
    80001b58:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5c:	8612                	mv	a2,tp
    80001b5e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b60:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b64:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b68:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b70:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b72:	6f18                	ld	a4,24(a4)
    80001b74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b78:	6928                	ld	a0,80(a0)
    80001b7a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b7c:	00005717          	auipc	a4,0x5
    80001b80:	52070713          	addi	a4,a4,1312 # 8000709c <userret>
    80001b84:	8f15                	sub	a4,a4,a3
    80001b86:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b88:	577d                	li	a4,-1
    80001b8a:	177e                	slli	a4,a4,0x3f
    80001b8c:	8d59                	or	a0,a0,a4
    80001b8e:	9782                	jalr	a5
}
    80001b90:	60a2                	ld	ra,8(sp)
    80001b92:	6402                	ld	s0,0(sp)
    80001b94:	0141                	addi	sp,sp,16
    80001b96:	8082                	ret

0000000080001b98 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b98:	1101                	addi	sp,sp,-32
    80001b9a:	ec06                	sd	ra,24(sp)
    80001b9c:	e822                	sd	s0,16(sp)
    80001b9e:	e426                	sd	s1,8(sp)
    80001ba0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba2:	00008497          	auipc	s1,0x8
    80001ba6:	f9e48493          	addi	s1,s1,-98 # 80009b40 <tickslock>
    80001baa:	8526                	mv	a0,s1
    80001bac:	00004097          	auipc	ra,0x4
    80001bb0:	622080e7          	jalr	1570(ra) # 800061ce <acquire>
  ticks++;
    80001bb4:	00007517          	auipc	a0,0x7
    80001bb8:	d1450513          	addi	a0,a0,-748 # 800088c8 <ticks>
    80001bbc:	411c                	lw	a5,0(a0)
    80001bbe:	2785                	addiw	a5,a5,1
    80001bc0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc2:	00000097          	auipc	ra,0x0
    80001bc6:	99c080e7          	jalr	-1636(ra) # 8000155e <wakeup>
  release(&tickslock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	00004097          	auipc	ra,0x4
    80001bd0:	6b6080e7          	jalr	1718(ra) # 80006282 <release>
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret

0000000080001bde <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bde:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001be2:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001be4:	0807df63          	bgez	a5,80001c82 <devintr+0xa4>
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bf2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bf6:	46a5                	li	a3,9
    80001bf8:	00d70d63          	beq	a4,a3,80001c12 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001bfc:	577d                	li	a4,-1
    80001bfe:	177e                	slli	a4,a4,0x3f
    80001c00:	0705                	addi	a4,a4,1
    return 0;
    80001c02:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c04:	04e78e63          	beq	a5,a4,80001c60 <devintr+0x82>
  }
}
    80001c08:	60e2                	ld	ra,24(sp)
    80001c0a:	6442                	ld	s0,16(sp)
    80001c0c:	64a2                	ld	s1,8(sp)
    80001c0e:	6105                	addi	sp,sp,32
    80001c10:	8082                	ret
    int irq = plic_claim();
    80001c12:	00003097          	auipc	ra,0x3
    80001c16:	5c6080e7          	jalr	1478(ra) # 800051d8 <plic_claim>
    80001c1a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c1c:	47a9                	li	a5,10
    80001c1e:	02f50763          	beq	a0,a5,80001c4c <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c22:	4785                	li	a5,1
    80001c24:	02f50963          	beq	a0,a5,80001c56 <devintr+0x78>
    return 1;
    80001c28:	4505                	li	a0,1
    } else if(irq){
    80001c2a:	dcf9                	beqz	s1,80001c08 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c2c:	85a6                	mv	a1,s1
    80001c2e:	00006517          	auipc	a0,0x6
    80001c32:	65250513          	addi	a0,a0,1618 # 80008280 <states.0+0x38>
    80001c36:	00004097          	auipc	ra,0x4
    80001c3a:	0aa080e7          	jalr	170(ra) # 80005ce0 <printf>
      plic_complete(irq);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00003097          	auipc	ra,0x3
    80001c44:	5bc080e7          	jalr	1468(ra) # 800051fc <plic_complete>
    return 1;
    80001c48:	4505                	li	a0,1
    80001c4a:	bf7d                	j	80001c08 <devintr+0x2a>
      uartintr();
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	4a2080e7          	jalr	1186(ra) # 800060ee <uartintr>
    if(irq)
    80001c54:	b7ed                	j	80001c3e <devintr+0x60>
      virtio_disk_intr();
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	a6c080e7          	jalr	-1428(ra) # 800056c2 <virtio_disk_intr>
    if(irq)
    80001c5e:	b7c5                	j	80001c3e <devintr+0x60>
    if(cpuid() == 0){
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	1c6080e7          	jalr	454(ra) # 80000e26 <cpuid>
    80001c68:	c901                	beqz	a0,80001c78 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c70:	14479073          	csrw	sip,a5
    return 2;
    80001c74:	4509                	li	a0,2
    80001c76:	bf49                	j	80001c08 <devintr+0x2a>
      clockintr();
    80001c78:	00000097          	auipc	ra,0x0
    80001c7c:	f20080e7          	jalr	-224(ra) # 80001b98 <clockintr>
    80001c80:	b7ed                	j	80001c6a <devintr+0x8c>
}
    80001c82:	8082                	ret

0000000080001c84 <usertrap>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	e04a                	sd	s2,0(sp)
    80001c8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c94:	1007f793          	andi	a5,a5,256
    80001c98:	e3b1                	bnez	a5,80001cdc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9a:	00003797          	auipc	a5,0x3
    80001c9e:	43678793          	addi	a5,a5,1078 # 800050d0 <kernelvec>
    80001ca2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	1ac080e7          	jalr	428(ra) # 80000e52 <myproc>
    80001cae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb2:	14102773          	csrr	a4,sepc
    80001cb6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbc:	47a1                	li	a5,8
    80001cbe:	02f70763          	beq	a4,a5,80001cec <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	f1c080e7          	jalr	-228(ra) # 80001bde <devintr>
    80001cca:	892a                	mv	s2,a0
    80001ccc:	c151                	beqz	a0,80001d50 <usertrap+0xcc>
  if(killed(p))
    80001cce:	8526                	mv	a0,s1
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	acc080e7          	jalr	-1332(ra) # 8000179c <killed>
    80001cd8:	c929                	beqz	a0,80001d2a <usertrap+0xa6>
    80001cda:	a099                	j	80001d20 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5c450513          	addi	a0,a0,1476 # 800082a0 <states.0+0x58>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	fb2080e7          	jalr	-78(ra) # 80005c96 <panic>
    if(killed(p))
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	ab0080e7          	jalr	-1360(ra) # 8000179c <killed>
    80001cf4:	e921                	bnez	a0,80001d44 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf6:	6cb8                	ld	a4,88(s1)
    80001cf8:	6f1c                	ld	a5,24(a4)
    80001cfa:	0791                	addi	a5,a5,4
    80001cfc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d02:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d06:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	2d4080e7          	jalr	724(ra) # 80001fde <syscall>
  if(killed(p))
    80001d12:	8526                	mv	a0,s1
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	a88080e7          	jalr	-1400(ra) # 8000179c <killed>
    80001d1c:	c911                	beqz	a0,80001d30 <usertrap+0xac>
    80001d1e:	4901                	li	s2,0
    exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	906080e7          	jalr	-1786(ra) # 80001628 <exit>
  if(which_dev == 2)
    80001d2a:	4789                	li	a5,2
    80001d2c:	04f90f63          	beq	s2,a5,80001d8a <usertrap+0x106>
  usertrapret();
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	dd2080e7          	jalr	-558(ra) # 80001b02 <usertrapret>
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
      exit(-1);
    80001d44:	557d                	li	a0,-1
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	8e2080e7          	jalr	-1822(ra) # 80001628 <exit>
    80001d4e:	b765                	j	80001cf6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d50:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d54:	5890                	lw	a2,48(s1)
    80001d56:	00006517          	auipc	a0,0x6
    80001d5a:	56a50513          	addi	a0,a0,1386 # 800082c0 <states.0+0x78>
    80001d5e:	00004097          	auipc	ra,0x4
    80001d62:	f82080e7          	jalr	-126(ra) # 80005ce0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6e:	00006517          	auipc	a0,0x6
    80001d72:	58250513          	addi	a0,a0,1410 # 800082f0 <states.0+0xa8>
    80001d76:	00004097          	auipc	ra,0x4
    80001d7a:	f6a080e7          	jalr	-150(ra) # 80005ce0 <printf>
    setkilled(p);
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	9f0080e7          	jalr	-1552(ra) # 80001770 <setkilled>
    80001d88:	b769                	j	80001d12 <usertrap+0x8e>
    yield();
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	734080e7          	jalr	1844(ra) # 800014be <yield>
    80001d92:	bf79                	j	80001d30 <usertrap+0xac>

0000000080001d94 <kerneltrap>:
{
    80001d94:	7179                	addi	sp,sp,-48
    80001d96:	f406                	sd	ra,40(sp)
    80001d98:	f022                	sd	s0,32(sp)
    80001d9a:	ec26                	sd	s1,24(sp)
    80001d9c:	e84a                	sd	s2,16(sp)
    80001d9e:	e44e                	sd	s3,8(sp)
    80001da0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dae:	1004f793          	andi	a5,s1,256
    80001db2:	cb85                	beqz	a5,80001de2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001db8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dba:	ef85                	bnez	a5,80001df2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	e22080e7          	jalr	-478(ra) # 80001bde <devintr>
    80001dc4:	cd1d                	beqz	a0,80001e02 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc6:	4789                	li	a5,2
    80001dc8:	06f50a63          	beq	a0,a5,80001e3c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dcc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd0:	10049073          	csrw	sstatus,s1
}
    80001dd4:	70a2                	ld	ra,40(sp)
    80001dd6:	7402                	ld	s0,32(sp)
    80001dd8:	64e2                	ld	s1,24(sp)
    80001dda:	6942                	ld	s2,16(sp)
    80001ddc:	69a2                	ld	s3,8(sp)
    80001dde:	6145                	addi	sp,sp,48
    80001de0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	52e50513          	addi	a0,a0,1326 # 80008310 <states.0+0xc8>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	eac080e7          	jalr	-340(ra) # 80005c96 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	54650513          	addi	a0,a0,1350 # 80008338 <states.0+0xf0>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	e9c080e7          	jalr	-356(ra) # 80005c96 <panic>
    printf("scause %p\n", scause);
    80001e02:	85ce                	mv	a1,s3
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	55450513          	addi	a0,a0,1364 # 80008358 <states.0+0x110>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	ed4080e7          	jalr	-300(ra) # 80005ce0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e14:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e18:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1c:	00006517          	auipc	a0,0x6
    80001e20:	54c50513          	addi	a0,a0,1356 # 80008368 <states.0+0x120>
    80001e24:	00004097          	auipc	ra,0x4
    80001e28:	ebc080e7          	jalr	-324(ra) # 80005ce0 <printf>
    panic("kerneltrap");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	55450513          	addi	a0,a0,1364 # 80008380 <states.0+0x138>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	e62080e7          	jalr	-414(ra) # 80005c96 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	016080e7          	jalr	22(ra) # 80000e52 <myproc>
    80001e44:	d541                	beqz	a0,80001dcc <kerneltrap+0x38>
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	00c080e7          	jalr	12(ra) # 80000e52 <myproc>
    80001e4e:	4d18                	lw	a4,24(a0)
    80001e50:	4791                	li	a5,4
    80001e52:	f6f71de3          	bne	a4,a5,80001dcc <kerneltrap+0x38>
    yield();
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	668080e7          	jalr	1640(ra) # 800014be <yield>
    80001e5e:	b7bd                	j	80001dcc <kerneltrap+0x38>

0000000080001e60 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	1000                	addi	s0,sp,32
    80001e6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	fe6080e7          	jalr	-26(ra) # 80000e52 <myproc>
  switch (n) {
    80001e74:	4795                	li	a5,5
    80001e76:	0497e163          	bltu	a5,s1,80001eb8 <argraw+0x58>
    80001e7a:	048a                	slli	s1,s1,0x2
    80001e7c:	00006717          	auipc	a4,0x6
    80001e80:	53c70713          	addi	a4,a4,1340 # 800083b8 <states.0+0x170>
    80001e84:	94ba                	add	s1,s1,a4
    80001e86:	409c                	lw	a5,0(s1)
    80001e88:	97ba                	add	a5,a5,a4
    80001e8a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e90:	60e2                	ld	ra,24(sp)
    80001e92:	6442                	ld	s0,16(sp)
    80001e94:	64a2                	ld	s1,8(sp)
    80001e96:	6105                	addi	sp,sp,32
    80001e98:	8082                	ret
    return p->trapframe->a1;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7fa8                	ld	a0,120(a5)
    80001e9e:	bfcd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a2;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	63c8                	ld	a0,128(a5)
    80001ea4:	b7f5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a3;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	67c8                	ld	a0,136(a5)
    80001eaa:	b7dd                	j	80001e90 <argraw+0x30>
    return p->trapframe->a4;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	6bc8                	ld	a0,144(a5)
    80001eb0:	b7c5                	j	80001e90 <argraw+0x30>
    return p->trapframe->a5;
    80001eb2:	6d3c                	ld	a5,88(a0)
    80001eb4:	6fc8                	ld	a0,152(a5)
    80001eb6:	bfe9                	j	80001e90 <argraw+0x30>
  panic("argraw");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	4d850513          	addi	a0,a0,1240 # 80008390 <states.0+0x148>
    80001ec0:	00004097          	auipc	ra,0x4
    80001ec4:	dd6080e7          	jalr	-554(ra) # 80005c96 <panic>

0000000080001ec8 <fetchaddr>:
{
    80001ec8:	1101                	addi	sp,sp,-32
    80001eca:	ec06                	sd	ra,24(sp)
    80001ecc:	e822                	sd	s0,16(sp)
    80001ece:	e426                	sd	s1,8(sp)
    80001ed0:	e04a                	sd	s2,0(sp)
    80001ed2:	1000                	addi	s0,sp,32
    80001ed4:	84aa                	mv	s1,a0
    80001ed6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f7a080e7          	jalr	-134(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee0:	653c                	ld	a5,72(a0)
    80001ee2:	02f4f863          	bgeu	s1,a5,80001f12 <fetchaddr+0x4a>
    80001ee6:	00848713          	addi	a4,s1,8
    80001eea:	02e7e663          	bltu	a5,a4,80001f16 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001eee:	46a1                	li	a3,8
    80001ef0:	8626                	mv	a2,s1
    80001ef2:	85ca                	mv	a1,s2
    80001ef4:	6928                	ld	a0,80(a0)
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	ca8080e7          	jalr	-856(ra) # 80000b9e <copyin>
    80001efe:	00a03533          	snez	a0,a0
    80001f02:	40a00533          	neg	a0,a0
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    return -1;
    80001f12:	557d                	li	a0,-1
    80001f14:	bfcd                	j	80001f06 <fetchaddr+0x3e>
    80001f16:	557d                	li	a0,-1
    80001f18:	b7fd                	j	80001f06 <fetchaddr+0x3e>

0000000080001f1a <fetchstr>:
{
    80001f1a:	7179                	addi	sp,sp,-48
    80001f1c:	f406                	sd	ra,40(sp)
    80001f1e:	f022                	sd	s0,32(sp)
    80001f20:	ec26                	sd	s1,24(sp)
    80001f22:	e84a                	sd	s2,16(sp)
    80001f24:	e44e                	sd	s3,8(sp)
    80001f26:	1800                	addi	s0,sp,48
    80001f28:	892a                	mv	s2,a0
    80001f2a:	84ae                	mv	s1,a1
    80001f2c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	f24080e7          	jalr	-220(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f36:	86ce                	mv	a3,s3
    80001f38:	864a                	mv	a2,s2
    80001f3a:	85a6                	mv	a1,s1
    80001f3c:	6928                	ld	a0,80(a0)
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	cee080e7          	jalr	-786(ra) # 80000c2c <copyinstr>
    80001f46:	00054e63          	bltz	a0,80001f62 <fetchstr+0x48>
  return strlen(buf);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	ffffe097          	auipc	ra,0xffffe
    80001f50:	3a8080e7          	jalr	936(ra) # 800002f4 <strlen>
}
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6145                	addi	sp,sp,48
    80001f60:	8082                	ret
    return -1;
    80001f62:	557d                	li	a0,-1
    80001f64:	bfc5                	j	80001f54 <fetchstr+0x3a>

0000000080001f66 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	eee080e7          	jalr	-274(ra) # 80001e60 <argraw>
    80001f7a:	c088                	sw	a0,0(s1)
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	ece080e7          	jalr	-306(ra) # 80001e60 <argraw>
    80001f9a:	e088                	sd	a0,0(s1)
}
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6105                	addi	sp,sp,32
    80001fa4:	8082                	ret

0000000080001fa6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa6:	7179                	addi	sp,sp,-48
    80001fa8:	f406                	sd	ra,40(sp)
    80001faa:	f022                	sd	s0,32(sp)
    80001fac:	ec26                	sd	s1,24(sp)
    80001fae:	e84a                	sd	s2,16(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	84ae                	mv	s1,a1
    80001fb4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb6:	fd840593          	addi	a1,s0,-40
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	fcc080e7          	jalr	-52(ra) # 80001f86 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	fd843503          	ld	a0,-40(s0)
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	f50080e7          	jalr	-176(ra) # 80001f1a <fetchstr>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	6145                	addi	sp,sp,48
    80001fdc:	8082                	ret

0000000080001fde <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e68080e7          	jalr	-408(ra) # 80000e52 <myproc>
    80001ff2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff4:	05853903          	ld	s2,88(a0)
    80001ff8:	0a893783          	ld	a5,168(s2)
    80001ffc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002000:	37fd                	addiw	a5,a5,-1
    80002002:	4751                	li	a4,20
    80002004:	00f76f63          	bltu	a4,a5,80002022 <syscall+0x44>
    80002008:	00369713          	slli	a4,a3,0x3
    8000200c:	00006797          	auipc	a5,0x6
    80002010:	3c478793          	addi	a5,a5,964 # 800083d0 <syscalls>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	639c                	ld	a5,0(a5)
    80002018:	c789                	beqz	a5,80002022 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000201a:	9782                	jalr	a5
    8000201c:	06a93823          	sd	a0,112(s2)
    80002020:	a839                	j	8000203e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002022:	15848613          	addi	a2,s1,344
    80002026:	588c                	lw	a1,48(s1)
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	37050513          	addi	a0,a0,880 # 80008398 <states.0+0x150>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	cb0080e7          	jalr	-848(ra) # 80005ce0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	577d                	li	a4,-1
    8000203c:	fbb8                	sd	a4,112(a5)
  }
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	f0e080e7          	jalr	-242(ra) # 80001f66 <argint>
  exit(n);
    80002060:	fec42503          	lw	a0,-20(s0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	5c4080e7          	jalr	1476(ra) # 80001628 <exit>
  return 0;  // not reached
}
    8000206c:	4501                	li	a0,0
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	6105                	addi	sp,sp,32
    80002074:	8082                	ret

0000000080002076 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002076:	1141                	addi	sp,sp,-16
    80002078:	e406                	sd	ra,8(sp)
    8000207a:	e022                	sd	s0,0(sp)
    8000207c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	dd4080e7          	jalr	-556(ra) # 80000e52 <myproc>
}
    80002086:	5908                	lw	a0,48(a0)
    80002088:	60a2                	ld	ra,8(sp)
    8000208a:	6402                	ld	s0,0(sp)
    8000208c:	0141                	addi	sp,sp,16
    8000208e:	8082                	ret

0000000080002090 <sys_fork>:

uint64
sys_fork(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return fork();
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	170080e7          	jalr	368(ra) # 80001208 <fork>
}
    800020a0:	60a2                	ld	ra,8(sp)
    800020a2:	6402                	ld	s0,0(sp)
    800020a4:	0141                	addi	sp,sp,16
    800020a6:	8082                	ret

00000000800020a8 <sys_wait>:

uint64
sys_wait(void)
{
    800020a8:	1101                	addi	sp,sp,-32
    800020aa:	ec06                	sd	ra,24(sp)
    800020ac:	e822                	sd	s0,16(sp)
    800020ae:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b0:	fe840593          	addi	a1,s0,-24
    800020b4:	4501                	li	a0,0
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	ed0080e7          	jalr	-304(ra) # 80001f86 <argaddr>
  return wait(p);
    800020be:	fe843503          	ld	a0,-24(s0)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	70c080e7          	jalr	1804(ra) # 800017ce <wait>
}
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020dc:	fdc40593          	addi	a1,s0,-36
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	e84080e7          	jalr	-380(ra) # 80001f66 <argint>
  addr = myproc()->sz;
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	d68080e7          	jalr	-664(ra) # 80000e52 <myproc>
    800020f2:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f4:	fdc42503          	lw	a0,-36(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	0b4080e7          	jalr	180(ra) # 800011ac <growproc>
    80002100:	00054863          	bltz	a0,80002110 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002104:	8526                	mv	a0,s1
    80002106:	70a2                	ld	ra,40(sp)
    80002108:	7402                	ld	s0,32(sp)
    8000210a:	64e2                	ld	s1,24(sp)
    8000210c:	6145                	addi	sp,sp,48
    8000210e:	8082                	ret
    return -1;
    80002110:	54fd                	li	s1,-1
    80002112:	bfcd                	j	80002104 <sys_sbrk+0x32>

0000000080002114 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002114:	7139                	addi	sp,sp,-64
    80002116:	fc06                	sd	ra,56(sp)
    80002118:	f822                	sd	s0,48(sp)
    8000211a:	f426                	sd	s1,40(sp)
    8000211c:	f04a                	sd	s2,32(sp)
    8000211e:	ec4e                	sd	s3,24(sp)
    80002120:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002122:	fcc40593          	addi	a1,s0,-52
    80002126:	4501                	li	a0,0
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	e3e080e7          	jalr	-450(ra) # 80001f66 <argint>
  if(n < 0)
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	0607cf63          	bltz	a5,800021b2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002138:	00008517          	auipc	a0,0x8
    8000213c:	a0850513          	addi	a0,a0,-1528 # 80009b40 <tickslock>
    80002140:	00004097          	auipc	ra,0x4
    80002144:	08e080e7          	jalr	142(ra) # 800061ce <acquire>
  ticks0 = ticks;
    80002148:	00006917          	auipc	s2,0x6
    8000214c:	78092903          	lw	s2,1920(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002150:	fcc42783          	lw	a5,-52(s0)
    80002154:	cf9d                	beqz	a5,80002192 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002156:	00008997          	auipc	s3,0x8
    8000215a:	9ea98993          	addi	s3,s3,-1558 # 80009b40 <tickslock>
    8000215e:	00006497          	auipc	s1,0x6
    80002162:	76a48493          	addi	s1,s1,1898 # 800088c8 <ticks>
    if(killed(myproc())){
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	cec080e7          	jalr	-788(ra) # 80000e52 <myproc>
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	62e080e7          	jalr	1582(ra) # 8000179c <killed>
    80002176:	e129                	bnez	a0,800021b8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002178:	85ce                	mv	a1,s3
    8000217a:	8526                	mv	a0,s1
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	37e080e7          	jalr	894(ra) # 800014fa <sleep>
  while(ticks - ticks0 < n){
    80002184:	409c                	lw	a5,0(s1)
    80002186:	412787bb          	subw	a5,a5,s2
    8000218a:	fcc42703          	lw	a4,-52(s0)
    8000218e:	fce7ece3          	bltu	a5,a4,80002166 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002192:	00008517          	auipc	a0,0x8
    80002196:	9ae50513          	addi	a0,a0,-1618 # 80009b40 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	0e8080e7          	jalr	232(ra) # 80006282 <release>
  return 0;
    800021a2:	4501                	li	a0,0
}
    800021a4:	70e2                	ld	ra,56(sp)
    800021a6:	7442                	ld	s0,48(sp)
    800021a8:	74a2                	ld	s1,40(sp)
    800021aa:	7902                	ld	s2,32(sp)
    800021ac:	69e2                	ld	s3,24(sp)
    800021ae:	6121                	addi	sp,sp,64
    800021b0:	8082                	ret
    n = 0;
    800021b2:	fc042623          	sw	zero,-52(s0)
    800021b6:	b749                	j	80002138 <sys_sleep+0x24>
      release(&tickslock);
    800021b8:	00008517          	auipc	a0,0x8
    800021bc:	98850513          	addi	a0,a0,-1656 # 80009b40 <tickslock>
    800021c0:	00004097          	auipc	ra,0x4
    800021c4:	0c2080e7          	jalr	194(ra) # 80006282 <release>
      return -1;
    800021c8:	557d                	li	a0,-1
    800021ca:	bfe9                	j	800021a4 <sys_sleep+0x90>

00000000800021cc <sys_kill>:

uint64
sys_kill(void)
{
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d4:	fec40593          	addi	a1,s0,-20
    800021d8:	4501                	li	a0,0
    800021da:	00000097          	auipc	ra,0x0
    800021de:	d8c080e7          	jalr	-628(ra) # 80001f66 <argint>
  return kill(pid);
    800021e2:	fec42503          	lw	a0,-20(s0)
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	518080e7          	jalr	1304(ra) # 800016fe <kill>
}
    800021ee:	60e2                	ld	ra,24(sp)
    800021f0:	6442                	ld	s0,16(sp)
    800021f2:	6105                	addi	sp,sp,32
    800021f4:	8082                	ret

00000000800021f6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002200:	00008517          	auipc	a0,0x8
    80002204:	94050513          	addi	a0,a0,-1728 # 80009b40 <tickslock>
    80002208:	00004097          	auipc	ra,0x4
    8000220c:	fc6080e7          	jalr	-58(ra) # 800061ce <acquire>
  xticks = ticks;
    80002210:	00006497          	auipc	s1,0x6
    80002214:	6b84a483          	lw	s1,1720(s1) # 800088c8 <ticks>
  release(&tickslock);
    80002218:	00008517          	auipc	a0,0x8
    8000221c:	92850513          	addi	a0,a0,-1752 # 80009b40 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	062080e7          	jalr	98(ra) # 80006282 <release>
  return xticks;
}
    80002228:	02049513          	slli	a0,s1,0x20
    8000222c:	9101                	srli	a0,a0,0x20
    8000222e:	60e2                	ld	ra,24(sp)
    80002230:	6442                	ld	s0,16(sp)
    80002232:	64a2                	ld	s1,8(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002238:	7179                	addi	sp,sp,-48
    8000223a:	f406                	sd	ra,40(sp)
    8000223c:	f022                	sd	s0,32(sp)
    8000223e:	ec26                	sd	s1,24(sp)
    80002240:	e84a                	sd	s2,16(sp)
    80002242:	e44e                	sd	s3,8(sp)
    80002244:	e052                	sd	s4,0(sp)
    80002246:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002248:	00006597          	auipc	a1,0x6
    8000224c:	23858593          	addi	a1,a1,568 # 80008480 <syscalls+0xb0>
    80002250:	00008517          	auipc	a0,0x8
    80002254:	90850513          	addi	a0,a0,-1784 # 80009b58 <bcache>
    80002258:	00004097          	auipc	ra,0x4
    8000225c:	ee6080e7          	jalr	-282(ra) # 8000613e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002260:	00010797          	auipc	a5,0x10
    80002264:	8f878793          	addi	a5,a5,-1800 # 80011b58 <bcache+0x8000>
    80002268:	00010717          	auipc	a4,0x10
    8000226c:	b5870713          	addi	a4,a4,-1192 # 80011dc0 <bcache+0x8268>
    80002270:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002274:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002278:	00008497          	auipc	s1,0x8
    8000227c:	8f848493          	addi	s1,s1,-1800 # 80009b70 <bcache+0x18>
    b->next = bcache.head.next;
    80002280:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002282:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002284:	00006a17          	auipc	s4,0x6
    80002288:	204a0a13          	addi	s4,s4,516 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000228c:	2b893783          	ld	a5,696(s2)
    80002290:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002292:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002296:	85d2                	mv	a1,s4
    80002298:	01048513          	addi	a0,s1,16
    8000229c:	00001097          	auipc	ra,0x1
    800022a0:	5fe080e7          	jalr	1534(ra) # 8000389a <initsleeplock>
    bcache.head.next->prev = b;
    800022a4:	2b893783          	ld	a5,696(s2)
    800022a8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022aa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ae:	45848493          	addi	s1,s1,1112
    800022b2:	fd349de3          	bne	s1,s3,8000228c <binit+0x54>
  }
}
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6a02                	ld	s4,0(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret

00000000800022c6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c6:	7179                	addi	sp,sp,-48
    800022c8:	f406                	sd	ra,40(sp)
    800022ca:	f022                	sd	s0,32(sp)
    800022cc:	ec26                	sd	s1,24(sp)
    800022ce:	e84a                	sd	s2,16(sp)
    800022d0:	e44e                	sd	s3,8(sp)
    800022d2:	1800                	addi	s0,sp,48
    800022d4:	892a                	mv	s2,a0
    800022d6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022d8:	00008517          	auipc	a0,0x8
    800022dc:	88050513          	addi	a0,a0,-1920 # 80009b58 <bcache>
    800022e0:	00004097          	auipc	ra,0x4
    800022e4:	eee080e7          	jalr	-274(ra) # 800061ce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022e8:	00010497          	auipc	s1,0x10
    800022ec:	b284b483          	ld	s1,-1240(s1) # 80011e10 <bcache+0x82b8>
    800022f0:	00010797          	auipc	a5,0x10
    800022f4:	ad078793          	addi	a5,a5,-1328 # 80011dc0 <bcache+0x8268>
    800022f8:	02f48f63          	beq	s1,a5,80002336 <bread+0x70>
    800022fc:	873e                	mv	a4,a5
    800022fe:	a021                	j	80002306 <bread+0x40>
    80002300:	68a4                	ld	s1,80(s1)
    80002302:	02e48a63          	beq	s1,a4,80002336 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002306:	449c                	lw	a5,8(s1)
    80002308:	ff279ce3          	bne	a5,s2,80002300 <bread+0x3a>
    8000230c:	44dc                	lw	a5,12(s1)
    8000230e:	ff3799e3          	bne	a5,s3,80002300 <bread+0x3a>
      b->refcnt++;
    80002312:	40bc                	lw	a5,64(s1)
    80002314:	2785                	addiw	a5,a5,1
    80002316:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002318:	00008517          	auipc	a0,0x8
    8000231c:	84050513          	addi	a0,a0,-1984 # 80009b58 <bcache>
    80002320:	00004097          	auipc	ra,0x4
    80002324:	f62080e7          	jalr	-158(ra) # 80006282 <release>
      acquiresleep(&b->lock);
    80002328:	01048513          	addi	a0,s1,16
    8000232c:	00001097          	auipc	ra,0x1
    80002330:	5a8080e7          	jalr	1448(ra) # 800038d4 <acquiresleep>
      return b;
    80002334:	a8b9                	j	80002392 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002336:	00010497          	auipc	s1,0x10
    8000233a:	ad24b483          	ld	s1,-1326(s1) # 80011e08 <bcache+0x82b0>
    8000233e:	00010797          	auipc	a5,0x10
    80002342:	a8278793          	addi	a5,a5,-1406 # 80011dc0 <bcache+0x8268>
    80002346:	00f48863          	beq	s1,a5,80002356 <bread+0x90>
    8000234a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000234c:	40bc                	lw	a5,64(s1)
    8000234e:	cf81                	beqz	a5,80002366 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002350:	64a4                	ld	s1,72(s1)
    80002352:	fee49de3          	bne	s1,a4,8000234c <bread+0x86>
  panic("bget: no buffers");
    80002356:	00006517          	auipc	a0,0x6
    8000235a:	13a50513          	addi	a0,a0,314 # 80008490 <syscalls+0xc0>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	938080e7          	jalr	-1736(ra) # 80005c96 <panic>
      b->dev = dev;
    80002366:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000236a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000236e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002372:	4785                	li	a5,1
    80002374:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002376:	00007517          	auipc	a0,0x7
    8000237a:	7e250513          	addi	a0,a0,2018 # 80009b58 <bcache>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	f04080e7          	jalr	-252(ra) # 80006282 <release>
      acquiresleep(&b->lock);
    80002386:	01048513          	addi	a0,s1,16
    8000238a:	00001097          	auipc	ra,0x1
    8000238e:	54a080e7          	jalr	1354(ra) # 800038d4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002392:	409c                	lw	a5,0(s1)
    80002394:	cb89                	beqz	a5,800023a6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002396:	8526                	mv	a0,s1
    80002398:	70a2                	ld	ra,40(sp)
    8000239a:	7402                	ld	s0,32(sp)
    8000239c:	64e2                	ld	s1,24(sp)
    8000239e:	6942                	ld	s2,16(sp)
    800023a0:	69a2                	ld	s3,8(sp)
    800023a2:	6145                	addi	sp,sp,48
    800023a4:	8082                	ret
    virtio_disk_rw(b, 0);
    800023a6:	4581                	li	a1,0
    800023a8:	8526                	mv	a0,s1
    800023aa:	00003097          	auipc	ra,0x3
    800023ae:	0e8080e7          	jalr	232(ra) # 80005492 <virtio_disk_rw>
    b->valid = 1;
    800023b2:	4785                	li	a5,1
    800023b4:	c09c                	sw	a5,0(s1)
  return b;
    800023b6:	b7c5                	j	80002396 <bread+0xd0>

00000000800023b8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023b8:	1101                	addi	sp,sp,-32
    800023ba:	ec06                	sd	ra,24(sp)
    800023bc:	e822                	sd	s0,16(sp)
    800023be:	e426                	sd	s1,8(sp)
    800023c0:	1000                	addi	s0,sp,32
    800023c2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c4:	0541                	addi	a0,a0,16
    800023c6:	00001097          	auipc	ra,0x1
    800023ca:	5a8080e7          	jalr	1448(ra) # 8000396e <holdingsleep>
    800023ce:	cd01                	beqz	a0,800023e6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d0:	4585                	li	a1,1
    800023d2:	8526                	mv	a0,s1
    800023d4:	00003097          	auipc	ra,0x3
    800023d8:	0be080e7          	jalr	190(ra) # 80005492 <virtio_disk_rw>
}
    800023dc:	60e2                	ld	ra,24(sp)
    800023de:	6442                	ld	s0,16(sp)
    800023e0:	64a2                	ld	s1,8(sp)
    800023e2:	6105                	addi	sp,sp,32
    800023e4:	8082                	ret
    panic("bwrite");
    800023e6:	00006517          	auipc	a0,0x6
    800023ea:	0c250513          	addi	a0,a0,194 # 800084a8 <syscalls+0xd8>
    800023ee:	00004097          	auipc	ra,0x4
    800023f2:	8a8080e7          	jalr	-1880(ra) # 80005c96 <panic>

00000000800023f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023f6:	1101                	addi	sp,sp,-32
    800023f8:	ec06                	sd	ra,24(sp)
    800023fa:	e822                	sd	s0,16(sp)
    800023fc:	e426                	sd	s1,8(sp)
    800023fe:	e04a                	sd	s2,0(sp)
    80002400:	1000                	addi	s0,sp,32
    80002402:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002404:	01050913          	addi	s2,a0,16
    80002408:	854a                	mv	a0,s2
    8000240a:	00001097          	auipc	ra,0x1
    8000240e:	564080e7          	jalr	1380(ra) # 8000396e <holdingsleep>
    80002412:	c925                	beqz	a0,80002482 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002414:	854a                	mv	a0,s2
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	514080e7          	jalr	1300(ra) # 8000392a <releasesleep>

  acquire(&bcache.lock);
    8000241e:	00007517          	auipc	a0,0x7
    80002422:	73a50513          	addi	a0,a0,1850 # 80009b58 <bcache>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	da8080e7          	jalr	-600(ra) # 800061ce <acquire>
  b->refcnt--;
    8000242e:	40bc                	lw	a5,64(s1)
    80002430:	37fd                	addiw	a5,a5,-1
    80002432:	0007871b          	sext.w	a4,a5
    80002436:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002438:	e71d                	bnez	a4,80002466 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000243a:	68b8                	ld	a4,80(s1)
    8000243c:	64bc                	ld	a5,72(s1)
    8000243e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002440:	68b8                	ld	a4,80(s1)
    80002442:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002444:	0000f797          	auipc	a5,0xf
    80002448:	71478793          	addi	a5,a5,1812 # 80011b58 <bcache+0x8000>
    8000244c:	2b87b703          	ld	a4,696(a5)
    80002450:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002452:	00010717          	auipc	a4,0x10
    80002456:	96e70713          	addi	a4,a4,-1682 # 80011dc0 <bcache+0x8268>
    8000245a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002462:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002466:	00007517          	auipc	a0,0x7
    8000246a:	6f250513          	addi	a0,a0,1778 # 80009b58 <bcache>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	e14080e7          	jalr	-492(ra) # 80006282 <release>
}
    80002476:	60e2                	ld	ra,24(sp)
    80002478:	6442                	ld	s0,16(sp)
    8000247a:	64a2                	ld	s1,8(sp)
    8000247c:	6902                	ld	s2,0(sp)
    8000247e:	6105                	addi	sp,sp,32
    80002480:	8082                	ret
    panic("brelse");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	02e50513          	addi	a0,a0,46 # 800084b0 <syscalls+0xe0>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	80c080e7          	jalr	-2036(ra) # 80005c96 <panic>

0000000080002492 <bpin>:

void
bpin(struct buf *b) {
    80002492:	1101                	addi	sp,sp,-32
    80002494:	ec06                	sd	ra,24(sp)
    80002496:	e822                	sd	s0,16(sp)
    80002498:	e426                	sd	s1,8(sp)
    8000249a:	1000                	addi	s0,sp,32
    8000249c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000249e:	00007517          	auipc	a0,0x7
    800024a2:	6ba50513          	addi	a0,a0,1722 # 80009b58 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	d28080e7          	jalr	-728(ra) # 800061ce <acquire>
  b->refcnt++;
    800024ae:	40bc                	lw	a5,64(s1)
    800024b0:	2785                	addiw	a5,a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b4:	00007517          	auipc	a0,0x7
    800024b8:	6a450513          	addi	a0,a0,1700 # 80009b58 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	dc6080e7          	jalr	-570(ra) # 80006282 <release>
}
    800024c4:	60e2                	ld	ra,24(sp)
    800024c6:	6442                	ld	s0,16(sp)
    800024c8:	64a2                	ld	s1,8(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret

00000000800024ce <bunpin>:

void
bunpin(struct buf *b) {
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	1000                	addi	s0,sp,32
    800024d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024da:	00007517          	auipc	a0,0x7
    800024de:	67e50513          	addi	a0,a0,1662 # 80009b58 <bcache>
    800024e2:	00004097          	auipc	ra,0x4
    800024e6:	cec080e7          	jalr	-788(ra) # 800061ce <acquire>
  b->refcnt--;
    800024ea:	40bc                	lw	a5,64(s1)
    800024ec:	37fd                	addiw	a5,a5,-1
    800024ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f0:	00007517          	auipc	a0,0x7
    800024f4:	66850513          	addi	a0,a0,1640 # 80009b58 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	d8a080e7          	jalr	-630(ra) # 80006282 <release>
}
    80002500:	60e2                	ld	ra,24(sp)
    80002502:	6442                	ld	s0,16(sp)
    80002504:	64a2                	ld	s1,8(sp)
    80002506:	6105                	addi	sp,sp,32
    80002508:	8082                	ret

000000008000250a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	addi	s0,sp,32
    80002516:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002518:	00d5d59b          	srliw	a1,a1,0xd
    8000251c:	00010797          	auipc	a5,0x10
    80002520:	d187a783          	lw	a5,-744(a5) # 80012234 <sb+0x1c>
    80002524:	9dbd                	addw	a1,a1,a5
    80002526:	00000097          	auipc	ra,0x0
    8000252a:	da0080e7          	jalr	-608(ra) # 800022c6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000252e:	0074f713          	andi	a4,s1,7
    80002532:	4785                	li	a5,1
    80002534:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002538:	14ce                	slli	s1,s1,0x33
    8000253a:	90d9                	srli	s1,s1,0x36
    8000253c:	00950733          	add	a4,a0,s1
    80002540:	05874703          	lbu	a4,88(a4)
    80002544:	00e7f6b3          	and	a3,a5,a4
    80002548:	c69d                	beqz	a3,80002576 <bfree+0x6c>
    8000254a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000254c:	94aa                	add	s1,s1,a0
    8000254e:	fff7c793          	not	a5,a5
    80002552:	8f7d                	and	a4,a4,a5
    80002554:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	25e080e7          	jalr	606(ra) # 800037b6 <log_write>
  brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e94080e7          	jalr	-364(ra) # 800023f6 <brelse>
}
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6902                	ld	s2,0(sp)
    80002572:	6105                	addi	sp,sp,32
    80002574:	8082                	ret
    panic("freeing free block");
    80002576:	00006517          	auipc	a0,0x6
    8000257a:	f4250513          	addi	a0,a0,-190 # 800084b8 <syscalls+0xe8>
    8000257e:	00003097          	auipc	ra,0x3
    80002582:	718080e7          	jalr	1816(ra) # 80005c96 <panic>

0000000080002586 <balloc>:
{
    80002586:	711d                	addi	sp,sp,-96
    80002588:	ec86                	sd	ra,88(sp)
    8000258a:	e8a2                	sd	s0,80(sp)
    8000258c:	e4a6                	sd	s1,72(sp)
    8000258e:	e0ca                	sd	s2,64(sp)
    80002590:	fc4e                	sd	s3,56(sp)
    80002592:	f852                	sd	s4,48(sp)
    80002594:	f456                	sd	s5,40(sp)
    80002596:	f05a                	sd	s6,32(sp)
    80002598:	ec5e                	sd	s7,24(sp)
    8000259a:	e862                	sd	s8,16(sp)
    8000259c:	e466                	sd	s9,8(sp)
    8000259e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025a0:	00010797          	auipc	a5,0x10
    800025a4:	c7c7a783          	lw	a5,-900(a5) # 8001221c <sb+0x4>
    800025a8:	cff5                	beqz	a5,800026a4 <balloc+0x11e>
    800025aa:	8baa                	mv	s7,a0
    800025ac:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025ae:	00010b17          	auipc	s6,0x10
    800025b2:	c6ab0b13          	addi	s6,s6,-918 # 80012218 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025b6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025b8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ba:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025bc:	6c89                	lui	s9,0x2
    800025be:	a061                	j	80002646 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025c0:	97ca                	add	a5,a5,s2
    800025c2:	8e55                	or	a2,a2,a3
    800025c4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025c8:	854a                	mv	a0,s2
    800025ca:	00001097          	auipc	ra,0x1
    800025ce:	1ec080e7          	jalr	492(ra) # 800037b6 <log_write>
        brelse(bp);
    800025d2:	854a                	mv	a0,s2
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	e22080e7          	jalr	-478(ra) # 800023f6 <brelse>
  bp = bread(dev, bno);
    800025dc:	85a6                	mv	a1,s1
    800025de:	855e                	mv	a0,s7
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	ce6080e7          	jalr	-794(ra) # 800022c6 <bread>
    800025e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025ea:	40000613          	li	a2,1024
    800025ee:	4581                	li	a1,0
    800025f0:	05850513          	addi	a0,a0,88
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	b86080e7          	jalr	-1146(ra) # 8000017a <memset>
  log_write(bp);
    800025fc:	854a                	mv	a0,s2
    800025fe:	00001097          	auipc	ra,0x1
    80002602:	1b8080e7          	jalr	440(ra) # 800037b6 <log_write>
  brelse(bp);
    80002606:	854a                	mv	a0,s2
    80002608:	00000097          	auipc	ra,0x0
    8000260c:	dee080e7          	jalr	-530(ra) # 800023f6 <brelse>
}
    80002610:	8526                	mv	a0,s1
    80002612:	60e6                	ld	ra,88(sp)
    80002614:	6446                	ld	s0,80(sp)
    80002616:	64a6                	ld	s1,72(sp)
    80002618:	6906                	ld	s2,64(sp)
    8000261a:	79e2                	ld	s3,56(sp)
    8000261c:	7a42                	ld	s4,48(sp)
    8000261e:	7aa2                	ld	s5,40(sp)
    80002620:	7b02                	ld	s6,32(sp)
    80002622:	6be2                	ld	s7,24(sp)
    80002624:	6c42                	ld	s8,16(sp)
    80002626:	6ca2                	ld	s9,8(sp)
    80002628:	6125                	addi	sp,sp,96
    8000262a:	8082                	ret
    brelse(bp);
    8000262c:	854a                	mv	a0,s2
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	dc8080e7          	jalr	-568(ra) # 800023f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002636:	015c87bb          	addw	a5,s9,s5
    8000263a:	00078a9b          	sext.w	s5,a5
    8000263e:	004b2703          	lw	a4,4(s6)
    80002642:	06eaf163          	bgeu	s5,a4,800026a4 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002646:	41fad79b          	sraiw	a5,s5,0x1f
    8000264a:	0137d79b          	srliw	a5,a5,0x13
    8000264e:	015787bb          	addw	a5,a5,s5
    80002652:	40d7d79b          	sraiw	a5,a5,0xd
    80002656:	01cb2583          	lw	a1,28(s6)
    8000265a:	9dbd                	addw	a1,a1,a5
    8000265c:	855e                	mv	a0,s7
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	c68080e7          	jalr	-920(ra) # 800022c6 <bread>
    80002666:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002668:	004b2503          	lw	a0,4(s6)
    8000266c:	000a849b          	sext.w	s1,s5
    80002670:	8762                	mv	a4,s8
    80002672:	faa4fde3          	bgeu	s1,a0,8000262c <balloc+0xa6>
      m = 1 << (bi % 8);
    80002676:	00777693          	andi	a3,a4,7
    8000267a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000267e:	41f7579b          	sraiw	a5,a4,0x1f
    80002682:	01d7d79b          	srliw	a5,a5,0x1d
    80002686:	9fb9                	addw	a5,a5,a4
    80002688:	4037d79b          	sraiw	a5,a5,0x3
    8000268c:	00f90633          	add	a2,s2,a5
    80002690:	05864603          	lbu	a2,88(a2)
    80002694:	00c6f5b3          	and	a1,a3,a2
    80002698:	d585                	beqz	a1,800025c0 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000269a:	2705                	addiw	a4,a4,1
    8000269c:	2485                	addiw	s1,s1,1
    8000269e:	fd471ae3          	bne	a4,s4,80002672 <balloc+0xec>
    800026a2:	b769                	j	8000262c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800026a4:	00006517          	auipc	a0,0x6
    800026a8:	e2c50513          	addi	a0,a0,-468 # 800084d0 <syscalls+0x100>
    800026ac:	00003097          	auipc	ra,0x3
    800026b0:	634080e7          	jalr	1588(ra) # 80005ce0 <printf>
  return 0;
    800026b4:	4481                	li	s1,0
    800026b6:	bfa9                	j	80002610 <balloc+0x8a>

00000000800026b8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026b8:	7139                	addi	sp,sp,-64
    800026ba:	fc06                	sd	ra,56(sp)
    800026bc:	f822                	sd	s0,48(sp)
    800026be:	f426                	sd	s1,40(sp)
    800026c0:	f04a                	sd	s2,32(sp)
    800026c2:	ec4e                	sd	s3,24(sp)
    800026c4:	e852                	sd	s4,16(sp)
    800026c6:	e456                	sd	s5,8(sp)
    800026c8:	0080                	addi	s0,sp,64
    800026ca:	89aa                	mv	s3,a0
  uint addr, *a, *b;
  struct buf *bp;

  if(bn < NDIRECT){
    800026cc:	47a9                	li	a5,10
    800026ce:	04b7e263          	bltu	a5,a1,80002712 <bmap+0x5a>
    if((addr = ip->addrs[bn]) == 0){
    800026d2:	02059793          	slli	a5,a1,0x20
    800026d6:	01e7d593          	srli	a1,a5,0x1e
    800026da:	00b504b3          	add	s1,a0,a1
    800026de:	0504a903          	lw	s2,80(s1)
    800026e2:	00090c63          	beqz	s2,800026fa <bmap+0x42>
    brelse(bp);
    return addr;
  }
   
  panic("bmap: out of range");
}
    800026e6:	854a                	mv	a0,s2
    800026e8:	70e2                	ld	ra,56(sp)
    800026ea:	7442                	ld	s0,48(sp)
    800026ec:	74a2                	ld	s1,40(sp)
    800026ee:	7902                	ld	s2,32(sp)
    800026f0:	69e2                	ld	s3,24(sp)
    800026f2:	6a42                	ld	s4,16(sp)
    800026f4:	6aa2                	ld	s5,8(sp)
    800026f6:	6121                	addi	sp,sp,64
    800026f8:	8082                	ret
      addr = balloc(ip->dev);
    800026fa:	4108                	lw	a0,0(a0)
    800026fc:	00000097          	auipc	ra,0x0
    80002700:	e8a080e7          	jalr	-374(ra) # 80002586 <balloc>
    80002704:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002708:	fc090fe3          	beqz	s2,800026e6 <bmap+0x2e>
      ip->addrs[bn] = addr;
    8000270c:	0524a823          	sw	s2,80(s1)
    80002710:	bfd9                	j	800026e6 <bmap+0x2e>
  bn -= NDIRECT;
    80002712:	ff55849b          	addiw	s1,a1,-11
    80002716:	0004871b          	sext.w	a4,s1
  if(bn < NINDIRECT){
    8000271a:	0ff00793          	li	a5,255
    8000271e:	06e7ec63          	bltu	a5,a4,80002796 <bmap+0xde>
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002722:	07c52903          	lw	s2,124(a0)
    80002726:	00091d63          	bnez	s2,80002740 <bmap+0x88>
      addr = balloc(ip->dev);
    8000272a:	4108                	lw	a0,0(a0)
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	e5a080e7          	jalr	-422(ra) # 80002586 <balloc>
    80002734:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002738:	fa0907e3          	beqz	s2,800026e6 <bmap+0x2e>
      ip->addrs[NDIRECT] = addr;
    8000273c:	0729ae23          	sw	s2,124(s3)
    bp = bread(ip->dev, addr);
    80002740:	85ca                	mv	a1,s2
    80002742:	0009a503          	lw	a0,0(s3)
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	b80080e7          	jalr	-1152(ra) # 800022c6 <bread>
    8000274e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002750:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002754:	02049713          	slli	a4,s1,0x20
    80002758:	01e75493          	srli	s1,a4,0x1e
    8000275c:	94be                	add	s1,s1,a5
    8000275e:	0004a903          	lw	s2,0(s1)
    80002762:	00090863          	beqz	s2,80002772 <bmap+0xba>
    brelse(bp);
    80002766:	8552                	mv	a0,s4
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	c8e080e7          	jalr	-882(ra) # 800023f6 <brelse>
    return addr;
    80002770:	bf9d                	j	800026e6 <bmap+0x2e>
      addr = balloc(ip->dev);
    80002772:	0009a503          	lw	a0,0(s3)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	e10080e7          	jalr	-496(ra) # 80002586 <balloc>
    8000277e:	0005091b          	sext.w	s2,a0
      if(addr){
    80002782:	fe0902e3          	beqz	s2,80002766 <bmap+0xae>
        a[bn] = addr;
    80002786:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000278a:	8552                	mv	a0,s4
    8000278c:	00001097          	auipc	ra,0x1
    80002790:	02a080e7          	jalr	42(ra) # 800037b6 <log_write>
    80002794:	bfc9                	j	80002766 <bmap+0xae>
  bn -= NINDIRECT;
    80002796:	ef55849b          	addiw	s1,a1,-267
    8000279a:	0004871b          	sext.w	a4,s1
  if(bn < NDINDIRECT){
    8000279e:	67c1                	lui	a5,0x10
    800027a0:	0cf77263          	bgeu	a4,a5,80002864 <bmap+0x1ac>
    if((addr = ip->addrs[NDIRECT + 1]) == 0){
    800027a4:	08052903          	lw	s2,128(a0)
    800027a8:	00091d63          	bnez	s2,800027c2 <bmap+0x10a>
      addr = balloc(ip->dev);
    800027ac:	4108                	lw	a0,0(a0)
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	dd8080e7          	jalr	-552(ra) # 80002586 <balloc>
    800027b6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027ba:	f20906e3          	beqz	s2,800026e6 <bmap+0x2e>
      ip->addrs[NDIRECT + 1] = addr;    
    800027be:	0929a023          	sw	s2,128(s3)
    bp = bread(ip->dev, addr);
    800027c2:	85ca                	mv	a1,s2
    800027c4:	0009a503          	lw	a0,0(s3)
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	afe080e7          	jalr	-1282(ra) # 800022c6 <bread>
    800027d0:	892a                	mv	s2,a0
    bn %= NINDIRECT;
    800027d2:	0ff4fa93          	zext.b	s5,s1
    a = (uint*)bp->data;    
    800027d6:	05850a13          	addi	s4,a0,88
    if((addr = a[entry]) == 0){
    800027da:	0084d59b          	srliw	a1,s1,0x8
    800027de:	058a                	slli	a1,a1,0x2
    800027e0:	9a2e                	add	s4,s4,a1
    800027e2:	000a2483          	lw	s1,0(s4) # 2000 <_entry-0x7fffe000>
    800027e6:	cc85                	beqz	s1,8000281e <bmap+0x166>
    brelse(bp);
    800027e8:	854a                	mv	a0,s2
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	c0c080e7          	jalr	-1012(ra) # 800023f6 <brelse>
    bp = bread(ip->dev, addr);
    800027f2:	85a6                	mv	a1,s1
    800027f4:	0009a503          	lw	a0,0(s3)
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	ace080e7          	jalr	-1330(ra) # 800022c6 <bread>
    80002800:	84aa                	mv	s1,a0
    b = (uint*)bp->data;
    80002802:	05850a13          	addi	s4,a0,88
    if((addr = b[bn]) == 0){
    80002806:	0a8a                	slli	s5,s5,0x2
    80002808:	9a56                	add	s4,s4,s5
    8000280a:	000a2903          	lw	s2,0(s4)
    8000280e:	02090963          	beqz	s2,80002840 <bmap+0x188>
    brelse(bp);
    80002812:	8526                	mv	a0,s1
    80002814:	00000097          	auipc	ra,0x0
    80002818:	be2080e7          	jalr	-1054(ra) # 800023f6 <brelse>
    return addr;
    8000281c:	b5e9                	j	800026e6 <bmap+0x2e>
      addr = balloc(ip->dev);
    8000281e:	0009a503          	lw	a0,0(s3)
    80002822:	00000097          	auipc	ra,0x0
    80002826:	d64080e7          	jalr	-668(ra) # 80002586 <balloc>
    8000282a:	0005049b          	sext.w	s1,a0
      if(addr){
    8000282e:	dccd                	beqz	s1,800027e8 <bmap+0x130>
        a[entry] = addr;
    80002830:	009a2023          	sw	s1,0(s4)
        log_write(bp);
    80002834:	854a                	mv	a0,s2
    80002836:	00001097          	auipc	ra,0x1
    8000283a:	f80080e7          	jalr	-128(ra) # 800037b6 <log_write>
    8000283e:	b76d                	j	800027e8 <bmap+0x130>
      addr = balloc(ip->dev);
    80002840:	0009a503          	lw	a0,0(s3)
    80002844:	00000097          	auipc	ra,0x0
    80002848:	d42080e7          	jalr	-702(ra) # 80002586 <balloc>
    8000284c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002850:	fc0901e3          	beqz	s2,80002812 <bmap+0x15a>
        b[bn] = addr;
    80002854:	012a2023          	sw	s2,0(s4)
        log_write(bp);
    80002858:	8526                	mv	a0,s1
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	f5c080e7          	jalr	-164(ra) # 800037b6 <log_write>
    80002862:	bf45                	j	80002812 <bmap+0x15a>
  panic("bmap: out of range");
    80002864:	00006517          	auipc	a0,0x6
    80002868:	c8450513          	addi	a0,a0,-892 # 800084e8 <syscalls+0x118>
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	42a080e7          	jalr	1066(ra) # 80005c96 <panic>

0000000080002874 <iget>:
{
    80002874:	7179                	addi	sp,sp,-48
    80002876:	f406                	sd	ra,40(sp)
    80002878:	f022                	sd	s0,32(sp)
    8000287a:	ec26                	sd	s1,24(sp)
    8000287c:	e84a                	sd	s2,16(sp)
    8000287e:	e44e                	sd	s3,8(sp)
    80002880:	e052                	sd	s4,0(sp)
    80002882:	1800                	addi	s0,sp,48
    80002884:	89aa                	mv	s3,a0
    80002886:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002888:	00010517          	auipc	a0,0x10
    8000288c:	9b050513          	addi	a0,a0,-1616 # 80012238 <itable>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	93e080e7          	jalr	-1730(ra) # 800061ce <acquire>
  empty = 0;
    80002898:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000289a:	00010497          	auipc	s1,0x10
    8000289e:	9b648493          	addi	s1,s1,-1610 # 80012250 <itable+0x18>
    800028a2:	00011697          	auipc	a3,0x11
    800028a6:	43e68693          	addi	a3,a3,1086 # 80013ce0 <log>
    800028aa:	a039                	j	800028b8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ac:	02090b63          	beqz	s2,800028e2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b0:	08848493          	addi	s1,s1,136
    800028b4:	02d48a63          	beq	s1,a3,800028e8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b8:	449c                	lw	a5,8(s1)
    800028ba:	fef059e3          	blez	a5,800028ac <iget+0x38>
    800028be:	4098                	lw	a4,0(s1)
    800028c0:	ff3716e3          	bne	a4,s3,800028ac <iget+0x38>
    800028c4:	40d8                	lw	a4,4(s1)
    800028c6:	ff4713e3          	bne	a4,s4,800028ac <iget+0x38>
      ip->ref++;
    800028ca:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    800028cc:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ce:	00010517          	auipc	a0,0x10
    800028d2:	96a50513          	addi	a0,a0,-1686 # 80012238 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	9ac080e7          	jalr	-1620(ra) # 80006282 <release>
      return ip;
    800028de:	8926                	mv	s2,s1
    800028e0:	a03d                	j	8000290e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028e2:	f7f9                	bnez	a5,800028b0 <iget+0x3c>
    800028e4:	8926                	mv	s2,s1
    800028e6:	b7e9                	j	800028b0 <iget+0x3c>
  if(empty == 0)
    800028e8:	02090c63          	beqz	s2,80002920 <iget+0xac>
  ip->dev = dev;
    800028ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f4:	4785                	li	a5,1
    800028f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fe:	00010517          	auipc	a0,0x10
    80002902:	93a50513          	addi	a0,a0,-1734 # 80012238 <itable>
    80002906:	00004097          	auipc	ra,0x4
    8000290a:	97c080e7          	jalr	-1668(ra) # 80006282 <release>
}
    8000290e:	854a                	mv	a0,s2
    80002910:	70a2                	ld	ra,40(sp)
    80002912:	7402                	ld	s0,32(sp)
    80002914:	64e2                	ld	s1,24(sp)
    80002916:	6942                	ld	s2,16(sp)
    80002918:	69a2                	ld	s3,8(sp)
    8000291a:	6a02                	ld	s4,0(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
    panic("iget: no inodes");
    80002920:	00006517          	auipc	a0,0x6
    80002924:	be050513          	addi	a0,a0,-1056 # 80008500 <syscalls+0x130>
    80002928:	00003097          	auipc	ra,0x3
    8000292c:	36e080e7          	jalr	878(ra) # 80005c96 <panic>

0000000080002930 <fsinit>:
fsinit(int dev) {
    80002930:	7179                	addi	sp,sp,-48
    80002932:	f406                	sd	ra,40(sp)
    80002934:	f022                	sd	s0,32(sp)
    80002936:	ec26                	sd	s1,24(sp)
    80002938:	e84a                	sd	s2,16(sp)
    8000293a:	e44e                	sd	s3,8(sp)
    8000293c:	1800                	addi	s0,sp,48
    8000293e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002940:	4585                	li	a1,1
    80002942:	00000097          	auipc	ra,0x0
    80002946:	984080e7          	jalr	-1660(ra) # 800022c6 <bread>
    8000294a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000294c:	00010997          	auipc	s3,0x10
    80002950:	8cc98993          	addi	s3,s3,-1844 # 80012218 <sb>
    80002954:	02000613          	li	a2,32
    80002958:	05850593          	addi	a1,a0,88
    8000295c:	854e                	mv	a0,s3
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	878080e7          	jalr	-1928(ra) # 800001d6 <memmove>
  brelse(bp);
    80002966:	8526                	mv	a0,s1
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	a8e080e7          	jalr	-1394(ra) # 800023f6 <brelse>
  if(sb.magic != FSMAGIC)
    80002970:	0009a703          	lw	a4,0(s3)
    80002974:	102037b7          	lui	a5,0x10203
    80002978:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000297c:	02f71263          	bne	a4,a5,800029a0 <fsinit+0x70>
  initlog(dev, &sb);
    80002980:	00010597          	auipc	a1,0x10
    80002984:	89858593          	addi	a1,a1,-1896 # 80012218 <sb>
    80002988:	854a                	mv	a0,s2
    8000298a:	00001097          	auipc	ra,0x1
    8000298e:	bc2080e7          	jalr	-1086(ra) # 8000354c <initlog>
}
    80002992:	70a2                	ld	ra,40(sp)
    80002994:	7402                	ld	s0,32(sp)
    80002996:	64e2                	ld	s1,24(sp)
    80002998:	6942                	ld	s2,16(sp)
    8000299a:	69a2                	ld	s3,8(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
    panic("invalid file system");
    800029a0:	00006517          	auipc	a0,0x6
    800029a4:	b7050513          	addi	a0,a0,-1168 # 80008510 <syscalls+0x140>
    800029a8:	00003097          	auipc	ra,0x3
    800029ac:	2ee080e7          	jalr	750(ra) # 80005c96 <panic>

00000000800029b0 <iinit>:
{
    800029b0:	7179                	addi	sp,sp,-48
    800029b2:	f406                	sd	ra,40(sp)
    800029b4:	f022                	sd	s0,32(sp)
    800029b6:	ec26                	sd	s1,24(sp)
    800029b8:	e84a                	sd	s2,16(sp)
    800029ba:	e44e                	sd	s3,8(sp)
    800029bc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029be:	00006597          	auipc	a1,0x6
    800029c2:	b6a58593          	addi	a1,a1,-1174 # 80008528 <syscalls+0x158>
    800029c6:	00010517          	auipc	a0,0x10
    800029ca:	87250513          	addi	a0,a0,-1934 # 80012238 <itable>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	770080e7          	jalr	1904(ra) # 8000613e <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d6:	00010497          	auipc	s1,0x10
    800029da:	88a48493          	addi	s1,s1,-1910 # 80012260 <itable+0x28>
    800029de:	00011997          	auipc	s3,0x11
    800029e2:	31298993          	addi	s3,s3,786 # 80013cf0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e6:	00006917          	auipc	s2,0x6
    800029ea:	b4a90913          	addi	s2,s2,-1206 # 80008530 <syscalls+0x160>
    800029ee:	85ca                	mv	a1,s2
    800029f0:	8526                	mv	a0,s1
    800029f2:	00001097          	auipc	ra,0x1
    800029f6:	ea8080e7          	jalr	-344(ra) # 8000389a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029fa:	08848493          	addi	s1,s1,136
    800029fe:	ff3498e3          	bne	s1,s3,800029ee <iinit+0x3e>
}
    80002a02:	70a2                	ld	ra,40(sp)
    80002a04:	7402                	ld	s0,32(sp)
    80002a06:	64e2                	ld	s1,24(sp)
    80002a08:	6942                	ld	s2,16(sp)
    80002a0a:	69a2                	ld	s3,8(sp)
    80002a0c:	6145                	addi	sp,sp,48
    80002a0e:	8082                	ret

0000000080002a10 <ialloc>:
{
    80002a10:	7139                	addi	sp,sp,-64
    80002a12:	fc06                	sd	ra,56(sp)
    80002a14:	f822                	sd	s0,48(sp)
    80002a16:	f426                	sd	s1,40(sp)
    80002a18:	f04a                	sd	s2,32(sp)
    80002a1a:	ec4e                	sd	s3,24(sp)
    80002a1c:	e852                	sd	s4,16(sp)
    80002a1e:	e456                	sd	s5,8(sp)
    80002a20:	e05a                	sd	s6,0(sp)
    80002a22:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a24:	00010717          	auipc	a4,0x10
    80002a28:	80072703          	lw	a4,-2048(a4) # 80012224 <sb+0xc>
    80002a2c:	4785                	li	a5,1
    80002a2e:	04e7f863          	bgeu	a5,a4,80002a7e <ialloc+0x6e>
    80002a32:	8aaa                	mv	s5,a0
    80002a34:	8b2e                	mv	s6,a1
    80002a36:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a38:	0000fa17          	auipc	s4,0xf
    80002a3c:	7e0a0a13          	addi	s4,s4,2016 # 80012218 <sb>
    80002a40:	00495593          	srli	a1,s2,0x4
    80002a44:	018a2783          	lw	a5,24(s4)
    80002a48:	9dbd                	addw	a1,a1,a5
    80002a4a:	8556                	mv	a0,s5
    80002a4c:	00000097          	auipc	ra,0x0
    80002a50:	87a080e7          	jalr	-1926(ra) # 800022c6 <bread>
    80002a54:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a56:	05850993          	addi	s3,a0,88
    80002a5a:	00f97793          	andi	a5,s2,15
    80002a5e:	079a                	slli	a5,a5,0x6
    80002a60:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a62:	00099783          	lh	a5,0(s3)
    80002a66:	cf9d                	beqz	a5,80002aa4 <ialloc+0x94>
    brelse(bp);
    80002a68:	00000097          	auipc	ra,0x0
    80002a6c:	98e080e7          	jalr	-1650(ra) # 800023f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a70:	0905                	addi	s2,s2,1
    80002a72:	00ca2703          	lw	a4,12(s4)
    80002a76:	0009079b          	sext.w	a5,s2
    80002a7a:	fce7e3e3          	bltu	a5,a4,80002a40 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a7e:	00006517          	auipc	a0,0x6
    80002a82:	aba50513          	addi	a0,a0,-1350 # 80008538 <syscalls+0x168>
    80002a86:	00003097          	auipc	ra,0x3
    80002a8a:	25a080e7          	jalr	602(ra) # 80005ce0 <printf>
  return 0;
    80002a8e:	4501                	li	a0,0
}
    80002a90:	70e2                	ld	ra,56(sp)
    80002a92:	7442                	ld	s0,48(sp)
    80002a94:	74a2                	ld	s1,40(sp)
    80002a96:	7902                	ld	s2,32(sp)
    80002a98:	69e2                	ld	s3,24(sp)
    80002a9a:	6a42                	ld	s4,16(sp)
    80002a9c:	6aa2                	ld	s5,8(sp)
    80002a9e:	6b02                	ld	s6,0(sp)
    80002aa0:	6121                	addi	sp,sp,64
    80002aa2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002aa4:	04000613          	li	a2,64
    80002aa8:	4581                	li	a1,0
    80002aaa:	854e                	mv	a0,s3
    80002aac:	ffffd097          	auipc	ra,0xffffd
    80002ab0:	6ce080e7          	jalr	1742(ra) # 8000017a <memset>
      dip->type = type;
    80002ab4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ab8:	8526                	mv	a0,s1
    80002aba:	00001097          	auipc	ra,0x1
    80002abe:	cfc080e7          	jalr	-772(ra) # 800037b6 <log_write>
      brelse(bp);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	932080e7          	jalr	-1742(ra) # 800023f6 <brelse>
      return iget(dev, inum);
    80002acc:	0009059b          	sext.w	a1,s2
    80002ad0:	8556                	mv	a0,s5
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	da2080e7          	jalr	-606(ra) # 80002874 <iget>
    80002ada:	bf5d                	j	80002a90 <ialloc+0x80>

0000000080002adc <iupdate>:
{
    80002adc:	1101                	addi	sp,sp,-32
    80002ade:	ec06                	sd	ra,24(sp)
    80002ae0:	e822                	sd	s0,16(sp)
    80002ae2:	e426                	sd	s1,8(sp)
    80002ae4:	e04a                	sd	s2,0(sp)
    80002ae6:	1000                	addi	s0,sp,32
    80002ae8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aea:	415c                	lw	a5,4(a0)
    80002aec:	0047d79b          	srliw	a5,a5,0x4
    80002af0:	0000f597          	auipc	a1,0xf
    80002af4:	7405a583          	lw	a1,1856(a1) # 80012230 <sb+0x18>
    80002af8:	9dbd                	addw	a1,a1,a5
    80002afa:	4108                	lw	a0,0(a0)
    80002afc:	fffff097          	auipc	ra,0xfffff
    80002b00:	7ca080e7          	jalr	1994(ra) # 800022c6 <bread>
    80002b04:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b06:	05850793          	addi	a5,a0,88
    80002b0a:	40d8                	lw	a4,4(s1)
    80002b0c:	8b3d                	andi	a4,a4,15
    80002b0e:	071a                	slli	a4,a4,0x6
    80002b10:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b12:	04449703          	lh	a4,68(s1)
    80002b16:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b1a:	04649703          	lh	a4,70(s1)
    80002b1e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b22:	04849703          	lh	a4,72(s1)
    80002b26:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b2a:	04a49703          	lh	a4,74(s1)
    80002b2e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b32:	44f8                	lw	a4,76(s1)
    80002b34:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b36:	03400613          	li	a2,52
    80002b3a:	05048593          	addi	a1,s1,80
    80002b3e:	00c78513          	addi	a0,a5,12
    80002b42:	ffffd097          	auipc	ra,0xffffd
    80002b46:	694080e7          	jalr	1684(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	c6a080e7          	jalr	-918(ra) # 800037b6 <log_write>
  brelse(bp);
    80002b54:	854a                	mv	a0,s2
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	8a0080e7          	jalr	-1888(ra) # 800023f6 <brelse>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6902                	ld	s2,0(sp)
    80002b66:	6105                	addi	sp,sp,32
    80002b68:	8082                	ret

0000000080002b6a <idup>:
{
    80002b6a:	1101                	addi	sp,sp,-32
    80002b6c:	ec06                	sd	ra,24(sp)
    80002b6e:	e822                	sd	s0,16(sp)
    80002b70:	e426                	sd	s1,8(sp)
    80002b72:	1000                	addi	s0,sp,32
    80002b74:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b76:	0000f517          	auipc	a0,0xf
    80002b7a:	6c250513          	addi	a0,a0,1730 # 80012238 <itable>
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	650080e7          	jalr	1616(ra) # 800061ce <acquire>
  ip->ref++;
    80002b86:	449c                	lw	a5,8(s1)
    80002b88:	2785                	addiw	a5,a5,1
    80002b8a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b8c:	0000f517          	auipc	a0,0xf
    80002b90:	6ac50513          	addi	a0,a0,1708 # 80012238 <itable>
    80002b94:	00003097          	auipc	ra,0x3
    80002b98:	6ee080e7          	jalr	1774(ra) # 80006282 <release>
}
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	60e2                	ld	ra,24(sp)
    80002ba0:	6442                	ld	s0,16(sp)
    80002ba2:	64a2                	ld	s1,8(sp)
    80002ba4:	6105                	addi	sp,sp,32
    80002ba6:	8082                	ret

0000000080002ba8 <ilock>:
{
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	e04a                	sd	s2,0(sp)
    80002bb2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bb4:	c115                	beqz	a0,80002bd8 <ilock+0x30>
    80002bb6:	84aa                	mv	s1,a0
    80002bb8:	451c                	lw	a5,8(a0)
    80002bba:	00f05f63          	blez	a5,80002bd8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bbe:	0541                	addi	a0,a0,16
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	d14080e7          	jalr	-748(ra) # 800038d4 <acquiresleep>
  if(ip->valid == 0){
    80002bc8:	40bc                	lw	a5,64(s1)
    80002bca:	cf99                	beqz	a5,80002be8 <ilock+0x40>
}
    80002bcc:	60e2                	ld	ra,24(sp)
    80002bce:	6442                	ld	s0,16(sp)
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	6902                	ld	s2,0(sp)
    80002bd4:	6105                	addi	sp,sp,32
    80002bd6:	8082                	ret
    panic("ilock");
    80002bd8:	00006517          	auipc	a0,0x6
    80002bdc:	97850513          	addi	a0,a0,-1672 # 80008550 <syscalls+0x180>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	0b6080e7          	jalr	182(ra) # 80005c96 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be8:	40dc                	lw	a5,4(s1)
    80002bea:	0047d79b          	srliw	a5,a5,0x4
    80002bee:	0000f597          	auipc	a1,0xf
    80002bf2:	6425a583          	lw	a1,1602(a1) # 80012230 <sb+0x18>
    80002bf6:	9dbd                	addw	a1,a1,a5
    80002bf8:	4088                	lw	a0,0(s1)
    80002bfa:	fffff097          	auipc	ra,0xfffff
    80002bfe:	6cc080e7          	jalr	1740(ra) # 800022c6 <bread>
    80002c02:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c04:	05850593          	addi	a1,a0,88
    80002c08:	40dc                	lw	a5,4(s1)
    80002c0a:	8bbd                	andi	a5,a5,15
    80002c0c:	079a                	slli	a5,a5,0x6
    80002c0e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c10:	00059783          	lh	a5,0(a1)
    80002c14:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c18:	00259783          	lh	a5,2(a1)
    80002c1c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c20:	00459783          	lh	a5,4(a1)
    80002c24:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c28:	00659783          	lh	a5,6(a1)
    80002c2c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c30:	459c                	lw	a5,8(a1)
    80002c32:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c34:	03400613          	li	a2,52
    80002c38:	05b1                	addi	a1,a1,12
    80002c3a:	05048513          	addi	a0,s1,80
    80002c3e:	ffffd097          	auipc	ra,0xffffd
    80002c42:	598080e7          	jalr	1432(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c46:	854a                	mv	a0,s2
    80002c48:	fffff097          	auipc	ra,0xfffff
    80002c4c:	7ae080e7          	jalr	1966(ra) # 800023f6 <brelse>
    ip->valid = 1;
    80002c50:	4785                	li	a5,1
    80002c52:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c54:	04449783          	lh	a5,68(s1)
    80002c58:	fbb5                	bnez	a5,80002bcc <ilock+0x24>
      panic("ilock: no type");
    80002c5a:	00006517          	auipc	a0,0x6
    80002c5e:	8fe50513          	addi	a0,a0,-1794 # 80008558 <syscalls+0x188>
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	034080e7          	jalr	52(ra) # 80005c96 <panic>

0000000080002c6a <iunlock>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	e04a                	sd	s2,0(sp)
    80002c74:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c76:	c905                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c78:	84aa                	mv	s1,a0
    80002c7a:	01050913          	addi	s2,a0,16
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	cee080e7          	jalr	-786(ra) # 8000396e <holdingsleep>
    80002c88:	cd19                	beqz	a0,80002ca6 <iunlock+0x3c>
    80002c8a:	449c                	lw	a5,8(s1)
    80002c8c:	00f05d63          	blez	a5,80002ca6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	c98080e7          	jalr	-872(ra) # 8000392a <releasesleep>
}
    80002c9a:	60e2                	ld	ra,24(sp)
    80002c9c:	6442                	ld	s0,16(sp)
    80002c9e:	64a2                	ld	s1,8(sp)
    80002ca0:	6902                	ld	s2,0(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret
    panic("iunlock");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	8c250513          	addi	a0,a0,-1854 # 80008568 <syscalls+0x198>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	fe8080e7          	jalr	-24(ra) # 80005c96 <panic>

0000000080002cb6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb6:	715d                	addi	sp,sp,-80
    80002cb8:	e486                	sd	ra,72(sp)
    80002cba:	e0a2                	sd	s0,64(sp)
    80002cbc:	fc26                	sd	s1,56(sp)
    80002cbe:	f84a                	sd	s2,48(sp)
    80002cc0:	f44e                	sd	s3,40(sp)
    80002cc2:	f052                	sd	s4,32(sp)
    80002cc4:	ec56                	sd	s5,24(sp)
    80002cc6:	e85a                	sd	s6,16(sp)
    80002cc8:	e45e                	sd	s7,8(sp)
    80002cca:	0880                	addi	s0,sp,80
    80002ccc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp, *bp2;
  uint *a, *a2;

  for(i = 0; i < NDIRECT; i++){
    80002cce:	05050493          	addi	s1,a0,80
    80002cd2:	07c50913          	addi	s2,a0,124
    80002cd6:	a021                	j	80002cde <itrunc+0x28>
    80002cd8:	0491                	addi	s1,s1,4
    80002cda:	01248d63          	beq	s1,s2,80002cf4 <itrunc+0x3e>
    if(ip->addrs[i]){
    80002cde:	408c                	lw	a1,0(s1)
    80002ce0:	dde5                	beqz	a1,80002cd8 <itrunc+0x22>
      bfree(ip->dev, ip->addrs[i]);
    80002ce2:	0009a503          	lw	a0,0(s3)
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	824080e7          	jalr	-2012(ra) # 8000250a <bfree>
      ip->addrs[i] = 0;
    80002cee:	0004a023          	sw	zero,0(s1)
    80002cf2:	b7dd                	j	80002cd8 <itrunc+0x22>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cf4:	07c9a583          	lw	a1,124(s3)
    80002cf8:	e595                	bnez	a1,80002d24 <itrunc+0x6e>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }


  if(ip->addrs[NDIRECT + 1]){
    80002cfa:	0809a583          	lw	a1,128(s3)
    80002cfe:	e9bd                	bnez	a1,80002d74 <itrunc+0xbe>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }

  ip->size = 0;
    80002d00:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d04:	854e                	mv	a0,s3
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	dd6080e7          	jalr	-554(ra) # 80002adc <iupdate>
}
    80002d0e:	60a6                	ld	ra,72(sp)
    80002d10:	6406                	ld	s0,64(sp)
    80002d12:	74e2                	ld	s1,56(sp)
    80002d14:	7942                	ld	s2,48(sp)
    80002d16:	79a2                	ld	s3,40(sp)
    80002d18:	7a02                	ld	s4,32(sp)
    80002d1a:	6ae2                	ld	s5,24(sp)
    80002d1c:	6b42                	ld	s6,16(sp)
    80002d1e:	6ba2                	ld	s7,8(sp)
    80002d20:	6161                	addi	sp,sp,80
    80002d22:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d24:	0009a503          	lw	a0,0(s3)
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	59e080e7          	jalr	1438(ra) # 800022c6 <bread>
    80002d30:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d32:	05850493          	addi	s1,a0,88
    80002d36:	45850913          	addi	s2,a0,1112
    80002d3a:	a021                	j	80002d42 <itrunc+0x8c>
    80002d3c:	0491                	addi	s1,s1,4
    80002d3e:	01248b63          	beq	s1,s2,80002d54 <itrunc+0x9e>
      if(a[j])
    80002d42:	408c                	lw	a1,0(s1)
    80002d44:	dde5                	beqz	a1,80002d3c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d46:	0009a503          	lw	a0,0(s3)
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	7c0080e7          	jalr	1984(ra) # 8000250a <bfree>
    80002d52:	b7ed                	j	80002d3c <itrunc+0x86>
    brelse(bp);
    80002d54:	8552                	mv	a0,s4
    80002d56:	fffff097          	auipc	ra,0xfffff
    80002d5a:	6a0080e7          	jalr	1696(ra) # 800023f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d5e:	07c9a583          	lw	a1,124(s3)
    80002d62:	0009a503          	lw	a0,0(s3)
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	7a4080e7          	jalr	1956(ra) # 8000250a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d6e:	0609ae23          	sw	zero,124(s3)
    80002d72:	b761                	j	80002cfa <itrunc+0x44>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d74:	0009a503          	lw	a0,0(s3)
    80002d78:	fffff097          	auipc	ra,0xfffff
    80002d7c:	54e080e7          	jalr	1358(ra) # 800022c6 <bread>
    80002d80:	8baa                	mv	s7,a0
    for(i = 0; i < NINDIRECT; i++){
    80002d82:	05850a13          	addi	s4,a0,88
    80002d86:	45850b13          	addi	s6,a0,1112
    80002d8a:	a03d                	j	80002db8 <itrunc+0x102>
      for(j = 0; j < NINDIRECT; j++){
    80002d8c:	0491                	addi	s1,s1,4
    80002d8e:	00990b63          	beq	s2,s1,80002da4 <itrunc+0xee>
        if(a2[j])
    80002d92:	408c                	lw	a1,0(s1)
    80002d94:	dde5                	beqz	a1,80002d8c <itrunc+0xd6>
          bfree(ip->dev, a2[j]);
    80002d96:	0009a503          	lw	a0,0(s3)
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	770080e7          	jalr	1904(ra) # 8000250a <bfree>
    80002da2:	b7ed                	j	80002d8c <itrunc+0xd6>
      a2[j] = 0;
    80002da4:	440aac23          	sw	zero,1112(s5)
      brelse(bp2);
    80002da8:	8556                	mv	a0,s5
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	64c080e7          	jalr	1612(ra) # 800023f6 <brelse>
    for(i = 0; i < NINDIRECT; i++){
    80002db2:	0a11                	addi	s4,s4,4
    80002db4:	034b0163          	beq	s6,s4,80002dd6 <itrunc+0x120>
      if(!a[i])
    80002db8:	000a2583          	lw	a1,0(s4)
    80002dbc:	d9fd                	beqz	a1,80002db2 <itrunc+0xfc>
      bp2 = bread(ip->dev, a[i]);
    80002dbe:	0009a503          	lw	a0,0(s3)
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	504080e7          	jalr	1284(ra) # 800022c6 <bread>
    80002dca:	8aaa                	mv	s5,a0
      for(j = 0; j < NINDIRECT; j++){
    80002dcc:	05850493          	addi	s1,a0,88
    80002dd0:	45850913          	addi	s2,a0,1112
    80002dd4:	bf7d                	j	80002d92 <itrunc+0xdc>
    brelse(bp);
    80002dd6:	855e                	mv	a0,s7
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	61e080e7          	jalr	1566(ra) # 800023f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002de0:	0809a583          	lw	a1,128(s3)
    80002de4:	0009a503          	lw	a0,0(s3)
    80002de8:	fffff097          	auipc	ra,0xfffff
    80002dec:	722080e7          	jalr	1826(ra) # 8000250a <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80002df0:	0809a023          	sw	zero,128(s3)
    80002df4:	b731                	j	80002d00 <itrunc+0x4a>

0000000080002df6 <iput>:
{
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	e426                	sd	s1,8(sp)
    80002dfe:	e04a                	sd	s2,0(sp)
    80002e00:	1000                	addi	s0,sp,32
    80002e02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e04:	0000f517          	auipc	a0,0xf
    80002e08:	43450513          	addi	a0,a0,1076 # 80012238 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	3c2080e7          	jalr	962(ra) # 800061ce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e14:	4498                	lw	a4,8(s1)
    80002e16:	4785                	li	a5,1
    80002e18:	02f70363          	beq	a4,a5,80002e3e <iput+0x48>
  ip->ref--;
    80002e1c:	449c                	lw	a5,8(s1)
    80002e1e:	37fd                	addiw	a5,a5,-1
    80002e20:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e22:	0000f517          	auipc	a0,0xf
    80002e26:	41650513          	addi	a0,a0,1046 # 80012238 <itable>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	458080e7          	jalr	1112(ra) # 80006282 <release>
}
    80002e32:	60e2                	ld	ra,24(sp)
    80002e34:	6442                	ld	s0,16(sp)
    80002e36:	64a2                	ld	s1,8(sp)
    80002e38:	6902                	ld	s2,0(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e3e:	40bc                	lw	a5,64(s1)
    80002e40:	dff1                	beqz	a5,80002e1c <iput+0x26>
    80002e42:	04a49783          	lh	a5,74(s1)
    80002e46:	fbf9                	bnez	a5,80002e1c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e48:	01048913          	addi	s2,s1,16
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	00001097          	auipc	ra,0x1
    80002e52:	a86080e7          	jalr	-1402(ra) # 800038d4 <acquiresleep>
    release(&itable.lock);
    80002e56:	0000f517          	auipc	a0,0xf
    80002e5a:	3e250513          	addi	a0,a0,994 # 80012238 <itable>
    80002e5e:	00003097          	auipc	ra,0x3
    80002e62:	424080e7          	jalr	1060(ra) # 80006282 <release>
    itrunc(ip);
    80002e66:	8526                	mv	a0,s1
    80002e68:	00000097          	auipc	ra,0x0
    80002e6c:	e4e080e7          	jalr	-434(ra) # 80002cb6 <itrunc>
    ip->type = 0;
    80002e70:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e74:	8526                	mv	a0,s1
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	c66080e7          	jalr	-922(ra) # 80002adc <iupdate>
    ip->valid = 0;
    80002e7e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e82:	854a                	mv	a0,s2
    80002e84:	00001097          	auipc	ra,0x1
    80002e88:	aa6080e7          	jalr	-1370(ra) # 8000392a <releasesleep>
    acquire(&itable.lock);
    80002e8c:	0000f517          	auipc	a0,0xf
    80002e90:	3ac50513          	addi	a0,a0,940 # 80012238 <itable>
    80002e94:	00003097          	auipc	ra,0x3
    80002e98:	33a080e7          	jalr	826(ra) # 800061ce <acquire>
    80002e9c:	b741                	j	80002e1c <iput+0x26>

0000000080002e9e <iunlockput>:
{
    80002e9e:	1101                	addi	sp,sp,-32
    80002ea0:	ec06                	sd	ra,24(sp)
    80002ea2:	e822                	sd	s0,16(sp)
    80002ea4:	e426                	sd	s1,8(sp)
    80002ea6:	1000                	addi	s0,sp,32
    80002ea8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	dc0080e7          	jalr	-576(ra) # 80002c6a <iunlock>
  iput(ip);
    80002eb2:	8526                	mv	a0,s1
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	f42080e7          	jalr	-190(ra) # 80002df6 <iput>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret

0000000080002ec6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ec6:	1141                	addi	sp,sp,-16
    80002ec8:	e422                	sd	s0,8(sp)
    80002eca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ecc:	411c                	lw	a5,0(a0)
    80002ece:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ed0:	415c                	lw	a5,4(a0)
    80002ed2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ed4:	04451783          	lh	a5,68(a0)
    80002ed8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002edc:	04a51783          	lh	a5,74(a0)
    80002ee0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ee4:	04c56783          	lwu	a5,76(a0)
    80002ee8:	e99c                	sd	a5,16(a1)
}
    80002eea:	6422                	ld	s0,8(sp)
    80002eec:	0141                	addi	sp,sp,16
    80002eee:	8082                	ret

0000000080002ef0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef0:	457c                	lw	a5,76(a0)
    80002ef2:	0ed7e963          	bltu	a5,a3,80002fe4 <readi+0xf4>
{
    80002ef6:	7159                	addi	sp,sp,-112
    80002ef8:	f486                	sd	ra,104(sp)
    80002efa:	f0a2                	sd	s0,96(sp)
    80002efc:	eca6                	sd	s1,88(sp)
    80002efe:	e8ca                	sd	s2,80(sp)
    80002f00:	e4ce                	sd	s3,72(sp)
    80002f02:	e0d2                	sd	s4,64(sp)
    80002f04:	fc56                	sd	s5,56(sp)
    80002f06:	f85a                	sd	s6,48(sp)
    80002f08:	f45e                	sd	s7,40(sp)
    80002f0a:	f062                	sd	s8,32(sp)
    80002f0c:	ec66                	sd	s9,24(sp)
    80002f0e:	e86a                	sd	s10,16(sp)
    80002f10:	e46e                	sd	s11,8(sp)
    80002f12:	1880                	addi	s0,sp,112
    80002f14:	8b2a                	mv	s6,a0
    80002f16:	8bae                	mv	s7,a1
    80002f18:	8a32                	mv	s4,a2
    80002f1a:	84b6                	mv	s1,a3
    80002f1c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f1e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f20:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f22:	0ad76063          	bltu	a4,a3,80002fc2 <readi+0xd2>
  if(off + n > ip->size)
    80002f26:	00e7f463          	bgeu	a5,a4,80002f2e <readi+0x3e>
    n = ip->size - off;
    80002f2a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f2e:	0a0a8963          	beqz	s5,80002fe0 <readi+0xf0>
    80002f32:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f34:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f38:	5c7d                	li	s8,-1
    80002f3a:	a82d                	j	80002f74 <readi+0x84>
    80002f3c:	020d1d93          	slli	s11,s10,0x20
    80002f40:	020ddd93          	srli	s11,s11,0x20
    80002f44:	05890613          	addi	a2,s2,88
    80002f48:	86ee                	mv	a3,s11
    80002f4a:	963a                	add	a2,a2,a4
    80002f4c:	85d2                	mv	a1,s4
    80002f4e:	855e                	mv	a0,s7
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	9ac080e7          	jalr	-1620(ra) # 800018fc <either_copyout>
    80002f58:	05850d63          	beq	a0,s8,80002fb2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	498080e7          	jalr	1176(ra) # 800023f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f66:	013d09bb          	addw	s3,s10,s3
    80002f6a:	009d04bb          	addw	s1,s10,s1
    80002f6e:	9a6e                	add	s4,s4,s11
    80002f70:	0559f763          	bgeu	s3,s5,80002fbe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f74:	00a4d59b          	srliw	a1,s1,0xa
    80002f78:	855a                	mv	a0,s6
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	73e080e7          	jalr	1854(ra) # 800026b8 <bmap>
    80002f82:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f86:	cd85                	beqz	a1,80002fbe <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f88:	000b2503          	lw	a0,0(s6)
    80002f8c:	fffff097          	auipc	ra,0xfffff
    80002f90:	33a080e7          	jalr	826(ra) # 800022c6 <bread>
    80002f94:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f96:	3ff4f713          	andi	a4,s1,1023
    80002f9a:	40ec87bb          	subw	a5,s9,a4
    80002f9e:	413a86bb          	subw	a3,s5,s3
    80002fa2:	8d3e                	mv	s10,a5
    80002fa4:	2781                	sext.w	a5,a5
    80002fa6:	0006861b          	sext.w	a2,a3
    80002faa:	f8f679e3          	bgeu	a2,a5,80002f3c <readi+0x4c>
    80002fae:	8d36                	mv	s10,a3
    80002fb0:	b771                	j	80002f3c <readi+0x4c>
      brelse(bp);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	442080e7          	jalr	1090(ra) # 800023f6 <brelse>
      tot = -1;
    80002fbc:	59fd                	li	s3,-1
  }
  return tot;
    80002fbe:	0009851b          	sext.w	a0,s3
}
    80002fc2:	70a6                	ld	ra,104(sp)
    80002fc4:	7406                	ld	s0,96(sp)
    80002fc6:	64e6                	ld	s1,88(sp)
    80002fc8:	6946                	ld	s2,80(sp)
    80002fca:	69a6                	ld	s3,72(sp)
    80002fcc:	6a06                	ld	s4,64(sp)
    80002fce:	7ae2                	ld	s5,56(sp)
    80002fd0:	7b42                	ld	s6,48(sp)
    80002fd2:	7ba2                	ld	s7,40(sp)
    80002fd4:	7c02                	ld	s8,32(sp)
    80002fd6:	6ce2                	ld	s9,24(sp)
    80002fd8:	6d42                	ld	s10,16(sp)
    80002fda:	6da2                	ld	s11,8(sp)
    80002fdc:	6165                	addi	sp,sp,112
    80002fde:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe0:	89d6                	mv	s3,s5
    80002fe2:	bff1                	j	80002fbe <readi+0xce>
    return 0;
    80002fe4:	4501                	li	a0,0
}
    80002fe6:	8082                	ret

0000000080002fe8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe8:	457c                	lw	a5,76(a0)
    80002fea:	10d7e963          	bltu	a5,a3,800030fc <writei+0x114>
{
    80002fee:	7159                	addi	sp,sp,-112
    80002ff0:	f486                	sd	ra,104(sp)
    80002ff2:	f0a2                	sd	s0,96(sp)
    80002ff4:	eca6                	sd	s1,88(sp)
    80002ff6:	e8ca                	sd	s2,80(sp)
    80002ff8:	e4ce                	sd	s3,72(sp)
    80002ffa:	e0d2                	sd	s4,64(sp)
    80002ffc:	fc56                	sd	s5,56(sp)
    80002ffe:	f85a                	sd	s6,48(sp)
    80003000:	f45e                	sd	s7,40(sp)
    80003002:	f062                	sd	s8,32(sp)
    80003004:	ec66                	sd	s9,24(sp)
    80003006:	e86a                	sd	s10,16(sp)
    80003008:	e46e                	sd	s11,8(sp)
    8000300a:	1880                	addi	s0,sp,112
    8000300c:	8aaa                	mv	s5,a0
    8000300e:	8bae                	mv	s7,a1
    80003010:	8a32                	mv	s4,a2
    80003012:	8936                	mv	s2,a3
    80003014:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003016:	9f35                	addw	a4,a4,a3
    80003018:	0ed76463          	bltu	a4,a3,80003100 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000301c:	040437b7          	lui	a5,0x4043
    80003020:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003024:	0ee7e063          	bltu	a5,a4,80003104 <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003028:	0c0b0863          	beqz	s6,800030f8 <writei+0x110>
    8000302c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003032:	5c7d                	li	s8,-1
    80003034:	a091                	j	80003078 <writei+0x90>
    80003036:	020d1d93          	slli	s11,s10,0x20
    8000303a:	020ddd93          	srli	s11,s11,0x20
    8000303e:	05848513          	addi	a0,s1,88
    80003042:	86ee                	mv	a3,s11
    80003044:	8652                	mv	a2,s4
    80003046:	85de                	mv	a1,s7
    80003048:	953a                	add	a0,a0,a4
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	908080e7          	jalr	-1784(ra) # 80001952 <either_copyin>
    80003052:	07850263          	beq	a0,s8,800030b6 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003056:	8526                	mv	a0,s1
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	75e080e7          	jalr	1886(ra) # 800037b6 <log_write>
    brelse(bp);
    80003060:	8526                	mv	a0,s1
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	394080e7          	jalr	916(ra) # 800023f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306a:	013d09bb          	addw	s3,s10,s3
    8000306e:	012d093b          	addw	s2,s10,s2
    80003072:	9a6e                	add	s4,s4,s11
    80003074:	0569f663          	bgeu	s3,s6,800030c0 <writei+0xd8>
    uint addr = bmap(ip, off/BSIZE);
    80003078:	00a9559b          	srliw	a1,s2,0xa
    8000307c:	8556                	mv	a0,s5
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	63a080e7          	jalr	1594(ra) # 800026b8 <bmap>
    80003086:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000308a:	c99d                	beqz	a1,800030c0 <writei+0xd8>
    bp = bread(ip->dev, addr);
    8000308c:	000aa503          	lw	a0,0(s5)
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	236080e7          	jalr	566(ra) # 800022c6 <bread>
    80003098:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309a:	3ff97713          	andi	a4,s2,1023
    8000309e:	40ec87bb          	subw	a5,s9,a4
    800030a2:	413b06bb          	subw	a3,s6,s3
    800030a6:	8d3e                	mv	s10,a5
    800030a8:	2781                	sext.w	a5,a5
    800030aa:	0006861b          	sext.w	a2,a3
    800030ae:	f8f674e3          	bgeu	a2,a5,80003036 <writei+0x4e>
    800030b2:	8d36                	mv	s10,a3
    800030b4:	b749                	j	80003036 <writei+0x4e>
      brelse(bp);
    800030b6:	8526                	mv	a0,s1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	33e080e7          	jalr	830(ra) # 800023f6 <brelse>
  }

  if(off > ip->size)
    800030c0:	04caa783          	lw	a5,76(s5)
    800030c4:	0127f463          	bgeu	a5,s2,800030cc <writei+0xe4>
    ip->size = off;
    800030c8:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030cc:	8556                	mv	a0,s5
    800030ce:	00000097          	auipc	ra,0x0
    800030d2:	a0e080e7          	jalr	-1522(ra) # 80002adc <iupdate>

  return tot;
    800030d6:	0009851b          	sext.w	a0,s3
}
    800030da:	70a6                	ld	ra,104(sp)
    800030dc:	7406                	ld	s0,96(sp)
    800030de:	64e6                	ld	s1,88(sp)
    800030e0:	6946                	ld	s2,80(sp)
    800030e2:	69a6                	ld	s3,72(sp)
    800030e4:	6a06                	ld	s4,64(sp)
    800030e6:	7ae2                	ld	s5,56(sp)
    800030e8:	7b42                	ld	s6,48(sp)
    800030ea:	7ba2                	ld	s7,40(sp)
    800030ec:	7c02                	ld	s8,32(sp)
    800030ee:	6ce2                	ld	s9,24(sp)
    800030f0:	6d42                	ld	s10,16(sp)
    800030f2:	6da2                	ld	s11,8(sp)
    800030f4:	6165                	addi	sp,sp,112
    800030f6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f8:	89da                	mv	s3,s6
    800030fa:	bfc9                	j	800030cc <writei+0xe4>
    return -1;
    800030fc:	557d                	li	a0,-1
}
    800030fe:	8082                	ret
    return -1;
    80003100:	557d                	li	a0,-1
    80003102:	bfe1                	j	800030da <writei+0xf2>
    return -1;
    80003104:	557d                	li	a0,-1
    80003106:	bfd1                	j	800030da <writei+0xf2>

0000000080003108 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003108:	1141                	addi	sp,sp,-16
    8000310a:	e406                	sd	ra,8(sp)
    8000310c:	e022                	sd	s0,0(sp)
    8000310e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003110:	4639                	li	a2,14
    80003112:	ffffd097          	auipc	ra,0xffffd
    80003116:	138080e7          	jalr	312(ra) # 8000024a <strncmp>
}
    8000311a:	60a2                	ld	ra,8(sp)
    8000311c:	6402                	ld	s0,0(sp)
    8000311e:	0141                	addi	sp,sp,16
    80003120:	8082                	ret

0000000080003122 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003122:	7139                	addi	sp,sp,-64
    80003124:	fc06                	sd	ra,56(sp)
    80003126:	f822                	sd	s0,48(sp)
    80003128:	f426                	sd	s1,40(sp)
    8000312a:	f04a                	sd	s2,32(sp)
    8000312c:	ec4e                	sd	s3,24(sp)
    8000312e:	e852                	sd	s4,16(sp)
    80003130:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003132:	04451703          	lh	a4,68(a0)
    80003136:	4785                	li	a5,1
    80003138:	00f71a63          	bne	a4,a5,8000314c <dirlookup+0x2a>
    8000313c:	892a                	mv	s2,a0
    8000313e:	89ae                	mv	s3,a1
    80003140:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003142:	457c                	lw	a5,76(a0)
    80003144:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003146:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003148:	e79d                	bnez	a5,80003176 <dirlookup+0x54>
    8000314a:	a8a5                	j	800031c2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000314c:	00005517          	auipc	a0,0x5
    80003150:	42450513          	addi	a0,a0,1060 # 80008570 <syscalls+0x1a0>
    80003154:	00003097          	auipc	ra,0x3
    80003158:	b42080e7          	jalr	-1214(ra) # 80005c96 <panic>
      panic("dirlookup read");
    8000315c:	00005517          	auipc	a0,0x5
    80003160:	42c50513          	addi	a0,a0,1068 # 80008588 <syscalls+0x1b8>
    80003164:	00003097          	auipc	ra,0x3
    80003168:	b32080e7          	jalr	-1230(ra) # 80005c96 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316c:	24c1                	addiw	s1,s1,16
    8000316e:	04c92783          	lw	a5,76(s2)
    80003172:	04f4f763          	bgeu	s1,a5,800031c0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003176:	4741                	li	a4,16
    80003178:	86a6                	mv	a3,s1
    8000317a:	fc040613          	addi	a2,s0,-64
    8000317e:	4581                	li	a1,0
    80003180:	854a                	mv	a0,s2
    80003182:	00000097          	auipc	ra,0x0
    80003186:	d6e080e7          	jalr	-658(ra) # 80002ef0 <readi>
    8000318a:	47c1                	li	a5,16
    8000318c:	fcf518e3          	bne	a0,a5,8000315c <dirlookup+0x3a>
    if(de.inum == 0)
    80003190:	fc045783          	lhu	a5,-64(s0)
    80003194:	dfe1                	beqz	a5,8000316c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003196:	fc240593          	addi	a1,s0,-62
    8000319a:	854e                	mv	a0,s3
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	f6c080e7          	jalr	-148(ra) # 80003108 <namecmp>
    800031a4:	f561                	bnez	a0,8000316c <dirlookup+0x4a>
      if(poff)
    800031a6:	000a0463          	beqz	s4,800031ae <dirlookup+0x8c>
        *poff = off;
    800031aa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ae:	fc045583          	lhu	a1,-64(s0)
    800031b2:	00092503          	lw	a0,0(s2)
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	6be080e7          	jalr	1726(ra) # 80002874 <iget>
    800031be:	a011                	j	800031c2 <dirlookup+0xa0>
  return 0;
    800031c0:	4501                	li	a0,0
}
    800031c2:	70e2                	ld	ra,56(sp)
    800031c4:	7442                	ld	s0,48(sp)
    800031c6:	74a2                	ld	s1,40(sp)
    800031c8:	7902                	ld	s2,32(sp)
    800031ca:	69e2                	ld	s3,24(sp)
    800031cc:	6a42                	ld	s4,16(sp)
    800031ce:	6121                	addi	sp,sp,64
    800031d0:	8082                	ret

00000000800031d2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031d2:	711d                	addi	sp,sp,-96
    800031d4:	ec86                	sd	ra,88(sp)
    800031d6:	e8a2                	sd	s0,80(sp)
    800031d8:	e4a6                	sd	s1,72(sp)
    800031da:	e0ca                	sd	s2,64(sp)
    800031dc:	fc4e                	sd	s3,56(sp)
    800031de:	f852                	sd	s4,48(sp)
    800031e0:	f456                	sd	s5,40(sp)
    800031e2:	f05a                	sd	s6,32(sp)
    800031e4:	ec5e                	sd	s7,24(sp)
    800031e6:	e862                	sd	s8,16(sp)
    800031e8:	e466                	sd	s9,8(sp)
    800031ea:	1080                	addi	s0,sp,96
    800031ec:	84aa                	mv	s1,a0
    800031ee:	8b2e                	mv	s6,a1
    800031f0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031f2:	00054703          	lbu	a4,0(a0)
    800031f6:	02f00793          	li	a5,47
    800031fa:	02f70263          	beq	a4,a5,8000321e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031fe:	ffffe097          	auipc	ra,0xffffe
    80003202:	c54080e7          	jalr	-940(ra) # 80000e52 <myproc>
    80003206:	15053503          	ld	a0,336(a0)
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	960080e7          	jalr	-1696(ra) # 80002b6a <idup>
    80003212:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003214:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003218:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000321a:	4b85                	li	s7,1
    8000321c:	a875                	j	800032d8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000321e:	4585                	li	a1,1
    80003220:	4505                	li	a0,1
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	652080e7          	jalr	1618(ra) # 80002874 <iget>
    8000322a:	8a2a                	mv	s4,a0
    8000322c:	b7e5                	j	80003214 <namex+0x42>
      iunlockput(ip);
    8000322e:	8552                	mv	a0,s4
    80003230:	00000097          	auipc	ra,0x0
    80003234:	c6e080e7          	jalr	-914(ra) # 80002e9e <iunlockput>
      return 0;
    80003238:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000323a:	8552                	mv	a0,s4
    8000323c:	60e6                	ld	ra,88(sp)
    8000323e:	6446                	ld	s0,80(sp)
    80003240:	64a6                	ld	s1,72(sp)
    80003242:	6906                	ld	s2,64(sp)
    80003244:	79e2                	ld	s3,56(sp)
    80003246:	7a42                	ld	s4,48(sp)
    80003248:	7aa2                	ld	s5,40(sp)
    8000324a:	7b02                	ld	s6,32(sp)
    8000324c:	6be2                	ld	s7,24(sp)
    8000324e:	6c42                	ld	s8,16(sp)
    80003250:	6ca2                	ld	s9,8(sp)
    80003252:	6125                	addi	sp,sp,96
    80003254:	8082                	ret
      iunlock(ip);
    80003256:	8552                	mv	a0,s4
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	a12080e7          	jalr	-1518(ra) # 80002c6a <iunlock>
      return ip;
    80003260:	bfe9                	j	8000323a <namex+0x68>
      iunlockput(ip);
    80003262:	8552                	mv	a0,s4
    80003264:	00000097          	auipc	ra,0x0
    80003268:	c3a080e7          	jalr	-966(ra) # 80002e9e <iunlockput>
      return 0;
    8000326c:	8a4e                	mv	s4,s3
    8000326e:	b7f1                	j	8000323a <namex+0x68>
  len = path - s;
    80003270:	40998633          	sub	a2,s3,s1
    80003274:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003278:	099c5863          	bge	s8,s9,80003308 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000327c:	4639                	li	a2,14
    8000327e:	85a6                	mv	a1,s1
    80003280:	8556                	mv	a0,s5
    80003282:	ffffd097          	auipc	ra,0xffffd
    80003286:	f54080e7          	jalr	-172(ra) # 800001d6 <memmove>
    8000328a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	01279763          	bne	a5,s2,8000329e <namex+0xcc>
    path++;
    80003294:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	ff278de3          	beq	a5,s2,80003294 <namex+0xc2>
    ilock(ip);
    8000329e:	8552                	mv	a0,s4
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	908080e7          	jalr	-1784(ra) # 80002ba8 <ilock>
    if(ip->type != T_DIR){
    800032a8:	044a1783          	lh	a5,68(s4)
    800032ac:	f97791e3          	bne	a5,s7,8000322e <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032b0:	000b0563          	beqz	s6,800032ba <namex+0xe8>
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	dfd9                	beqz	a5,80003256 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ba:	4601                	li	a2,0
    800032bc:	85d6                	mv	a1,s5
    800032be:	8552                	mv	a0,s4
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	e62080e7          	jalr	-414(ra) # 80003122 <dirlookup>
    800032c8:	89aa                	mv	s3,a0
    800032ca:	dd41                	beqz	a0,80003262 <namex+0x90>
    iunlockput(ip);
    800032cc:	8552                	mv	a0,s4
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	bd0080e7          	jalr	-1072(ra) # 80002e9e <iunlockput>
    ip = next;
    800032d6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032d8:	0004c783          	lbu	a5,0(s1)
    800032dc:	01279763          	bne	a5,s2,800032ea <namex+0x118>
    path++;
    800032e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e2:	0004c783          	lbu	a5,0(s1)
    800032e6:	ff278de3          	beq	a5,s2,800032e0 <namex+0x10e>
  if(*path == 0)
    800032ea:	cb9d                	beqz	a5,80003320 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032ec:	0004c783          	lbu	a5,0(s1)
    800032f0:	89a6                	mv	s3,s1
  len = path - s;
    800032f2:	4c81                	li	s9,0
    800032f4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032f6:	01278963          	beq	a5,s2,80003308 <namex+0x136>
    800032fa:	dbbd                	beqz	a5,80003270 <namex+0x9e>
    path++;
    800032fc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032fe:	0009c783          	lbu	a5,0(s3)
    80003302:	ff279ce3          	bne	a5,s2,800032fa <namex+0x128>
    80003306:	b7ad                	j	80003270 <namex+0x9e>
    memmove(name, s, len);
    80003308:	2601                	sext.w	a2,a2
    8000330a:	85a6                	mv	a1,s1
    8000330c:	8556                	mv	a0,s5
    8000330e:	ffffd097          	auipc	ra,0xffffd
    80003312:	ec8080e7          	jalr	-312(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003316:	9cd6                	add	s9,s9,s5
    80003318:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000331c:	84ce                	mv	s1,s3
    8000331e:	b7bd                	j	8000328c <namex+0xba>
  if(nameiparent){
    80003320:	f00b0de3          	beqz	s6,8000323a <namex+0x68>
    iput(ip);
    80003324:	8552                	mv	a0,s4
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	ad0080e7          	jalr	-1328(ra) # 80002df6 <iput>
    return 0;
    8000332e:	4a01                	li	s4,0
    80003330:	b729                	j	8000323a <namex+0x68>

0000000080003332 <dirlink>:
{
    80003332:	7139                	addi	sp,sp,-64
    80003334:	fc06                	sd	ra,56(sp)
    80003336:	f822                	sd	s0,48(sp)
    80003338:	f426                	sd	s1,40(sp)
    8000333a:	f04a                	sd	s2,32(sp)
    8000333c:	ec4e                	sd	s3,24(sp)
    8000333e:	e852                	sd	s4,16(sp)
    80003340:	0080                	addi	s0,sp,64
    80003342:	892a                	mv	s2,a0
    80003344:	8a2e                	mv	s4,a1
    80003346:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003348:	4601                	li	a2,0
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	dd8080e7          	jalr	-552(ra) # 80003122 <dirlookup>
    80003352:	e93d                	bnez	a0,800033c8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003354:	04c92483          	lw	s1,76(s2)
    80003358:	c49d                	beqz	s1,80003386 <dirlink+0x54>
    8000335a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335c:	4741                	li	a4,16
    8000335e:	86a6                	mv	a3,s1
    80003360:	fc040613          	addi	a2,s0,-64
    80003364:	4581                	li	a1,0
    80003366:	854a                	mv	a0,s2
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	b88080e7          	jalr	-1144(ra) # 80002ef0 <readi>
    80003370:	47c1                	li	a5,16
    80003372:	06f51163          	bne	a0,a5,800033d4 <dirlink+0xa2>
    if(de.inum == 0)
    80003376:	fc045783          	lhu	a5,-64(s0)
    8000337a:	c791                	beqz	a5,80003386 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337c:	24c1                	addiw	s1,s1,16
    8000337e:	04c92783          	lw	a5,76(s2)
    80003382:	fcf4ede3          	bltu	s1,a5,8000335c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003386:	4639                	li	a2,14
    80003388:	85d2                	mv	a1,s4
    8000338a:	fc240513          	addi	a0,s0,-62
    8000338e:	ffffd097          	auipc	ra,0xffffd
    80003392:	ef8080e7          	jalr	-264(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003396:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339a:	4741                	li	a4,16
    8000339c:	86a6                	mv	a3,s1
    8000339e:	fc040613          	addi	a2,s0,-64
    800033a2:	4581                	li	a1,0
    800033a4:	854a                	mv	a0,s2
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	c42080e7          	jalr	-958(ra) # 80002fe8 <writei>
    800033ae:	1541                	addi	a0,a0,-16
    800033b0:	00a03533          	snez	a0,a0
    800033b4:	40a00533          	neg	a0,a0
}
    800033b8:	70e2                	ld	ra,56(sp)
    800033ba:	7442                	ld	s0,48(sp)
    800033bc:	74a2                	ld	s1,40(sp)
    800033be:	7902                	ld	s2,32(sp)
    800033c0:	69e2                	ld	s3,24(sp)
    800033c2:	6a42                	ld	s4,16(sp)
    800033c4:	6121                	addi	sp,sp,64
    800033c6:	8082                	ret
    iput(ip);
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	a2e080e7          	jalr	-1490(ra) # 80002df6 <iput>
    return -1;
    800033d0:	557d                	li	a0,-1
    800033d2:	b7dd                	j	800033b8 <dirlink+0x86>
      panic("dirlink read");
    800033d4:	00005517          	auipc	a0,0x5
    800033d8:	1c450513          	addi	a0,a0,452 # 80008598 <syscalls+0x1c8>
    800033dc:	00003097          	auipc	ra,0x3
    800033e0:	8ba080e7          	jalr	-1862(ra) # 80005c96 <panic>

00000000800033e4 <namei>:

struct inode*
namei(char *path)
{
    800033e4:	1101                	addi	sp,sp,-32
    800033e6:	ec06                	sd	ra,24(sp)
    800033e8:	e822                	sd	s0,16(sp)
    800033ea:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ec:	fe040613          	addi	a2,s0,-32
    800033f0:	4581                	li	a1,0
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	de0080e7          	jalr	-544(ra) # 800031d2 <namex>
}
    800033fa:	60e2                	ld	ra,24(sp)
    800033fc:	6442                	ld	s0,16(sp)
    800033fe:	6105                	addi	sp,sp,32
    80003400:	8082                	ret

0000000080003402 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003402:	1141                	addi	sp,sp,-16
    80003404:	e406                	sd	ra,8(sp)
    80003406:	e022                	sd	s0,0(sp)
    80003408:	0800                	addi	s0,sp,16
    8000340a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000340c:	4585                	li	a1,1
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	dc4080e7          	jalr	-572(ra) # 800031d2 <namex>
}
    80003416:	60a2                	ld	ra,8(sp)
    80003418:	6402                	ld	s0,0(sp)
    8000341a:	0141                	addi	sp,sp,16
    8000341c:	8082                	ret

000000008000341e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000341e:	1101                	addi	sp,sp,-32
    80003420:	ec06                	sd	ra,24(sp)
    80003422:	e822                	sd	s0,16(sp)
    80003424:	e426                	sd	s1,8(sp)
    80003426:	e04a                	sd	s2,0(sp)
    80003428:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000342a:	00011917          	auipc	s2,0x11
    8000342e:	8b690913          	addi	s2,s2,-1866 # 80013ce0 <log>
    80003432:	01892583          	lw	a1,24(s2)
    80003436:	02892503          	lw	a0,40(s2)
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	e8c080e7          	jalr	-372(ra) # 800022c6 <bread>
    80003442:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003444:	02c92603          	lw	a2,44(s2)
    80003448:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000344a:	00c05f63          	blez	a2,80003468 <write_head+0x4a>
    8000344e:	00011717          	auipc	a4,0x11
    80003452:	8c270713          	addi	a4,a4,-1854 # 80013d10 <log+0x30>
    80003456:	87aa                	mv	a5,a0
    80003458:	060a                	slli	a2,a2,0x2
    8000345a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000345c:	4314                	lw	a3,0(a4)
    8000345e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003460:	0711                	addi	a4,a4,4
    80003462:	0791                	addi	a5,a5,4
    80003464:	fec79ce3          	bne	a5,a2,8000345c <write_head+0x3e>
  }
  bwrite(buf);
    80003468:	8526                	mv	a0,s1
    8000346a:	fffff097          	auipc	ra,0xfffff
    8000346e:	f4e080e7          	jalr	-178(ra) # 800023b8 <bwrite>
  brelse(buf);
    80003472:	8526                	mv	a0,s1
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	f82080e7          	jalr	-126(ra) # 800023f6 <brelse>
}
    8000347c:	60e2                	ld	ra,24(sp)
    8000347e:	6442                	ld	s0,16(sp)
    80003480:	64a2                	ld	s1,8(sp)
    80003482:	6902                	ld	s2,0(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003488:	00011797          	auipc	a5,0x11
    8000348c:	8847a783          	lw	a5,-1916(a5) # 80013d0c <log+0x2c>
    80003490:	0af05d63          	blez	a5,8000354a <install_trans+0xc2>
{
    80003494:	7139                	addi	sp,sp,-64
    80003496:	fc06                	sd	ra,56(sp)
    80003498:	f822                	sd	s0,48(sp)
    8000349a:	f426                	sd	s1,40(sp)
    8000349c:	f04a                	sd	s2,32(sp)
    8000349e:	ec4e                	sd	s3,24(sp)
    800034a0:	e852                	sd	s4,16(sp)
    800034a2:	e456                	sd	s5,8(sp)
    800034a4:	e05a                	sd	s6,0(sp)
    800034a6:	0080                	addi	s0,sp,64
    800034a8:	8b2a                	mv	s6,a0
    800034aa:	00011a97          	auipc	s5,0x11
    800034ae:	866a8a93          	addi	s5,s5,-1946 # 80013d10 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b4:	00011997          	auipc	s3,0x11
    800034b8:	82c98993          	addi	s3,s3,-2004 # 80013ce0 <log>
    800034bc:	a00d                	j	800034de <install_trans+0x56>
    brelse(lbuf);
    800034be:	854a                	mv	a0,s2
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	f36080e7          	jalr	-202(ra) # 800023f6 <brelse>
    brelse(dbuf);
    800034c8:	8526                	mv	a0,s1
    800034ca:	fffff097          	auipc	ra,0xfffff
    800034ce:	f2c080e7          	jalr	-212(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d2:	2a05                	addiw	s4,s4,1
    800034d4:	0a91                	addi	s5,s5,4
    800034d6:	02c9a783          	lw	a5,44(s3)
    800034da:	04fa5e63          	bge	s4,a5,80003536 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034de:	0189a583          	lw	a1,24(s3)
    800034e2:	014585bb          	addw	a1,a1,s4
    800034e6:	2585                	addiw	a1,a1,1
    800034e8:	0289a503          	lw	a0,40(s3)
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	dda080e7          	jalr	-550(ra) # 800022c6 <bread>
    800034f4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034f6:	000aa583          	lw	a1,0(s5)
    800034fa:	0289a503          	lw	a0,40(s3)
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	dc8080e7          	jalr	-568(ra) # 800022c6 <bread>
    80003506:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003508:	40000613          	li	a2,1024
    8000350c:	05890593          	addi	a1,s2,88
    80003510:	05850513          	addi	a0,a0,88
    80003514:	ffffd097          	auipc	ra,0xffffd
    80003518:	cc2080e7          	jalr	-830(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000351c:	8526                	mv	a0,s1
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	e9a080e7          	jalr	-358(ra) # 800023b8 <bwrite>
    if(recovering == 0)
    80003526:	f80b1ce3          	bnez	s6,800034be <install_trans+0x36>
      bunpin(dbuf);
    8000352a:	8526                	mv	a0,s1
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	fa2080e7          	jalr	-94(ra) # 800024ce <bunpin>
    80003534:	b769                	j	800034be <install_trans+0x36>
}
    80003536:	70e2                	ld	ra,56(sp)
    80003538:	7442                	ld	s0,48(sp)
    8000353a:	74a2                	ld	s1,40(sp)
    8000353c:	7902                	ld	s2,32(sp)
    8000353e:	69e2                	ld	s3,24(sp)
    80003540:	6a42                	ld	s4,16(sp)
    80003542:	6aa2                	ld	s5,8(sp)
    80003544:	6b02                	ld	s6,0(sp)
    80003546:	6121                	addi	sp,sp,64
    80003548:	8082                	ret
    8000354a:	8082                	ret

000000008000354c <initlog>:
{
    8000354c:	7179                	addi	sp,sp,-48
    8000354e:	f406                	sd	ra,40(sp)
    80003550:	f022                	sd	s0,32(sp)
    80003552:	ec26                	sd	s1,24(sp)
    80003554:	e84a                	sd	s2,16(sp)
    80003556:	e44e                	sd	s3,8(sp)
    80003558:	1800                	addi	s0,sp,48
    8000355a:	892a                	mv	s2,a0
    8000355c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355e:	00010497          	auipc	s1,0x10
    80003562:	78248493          	addi	s1,s1,1922 # 80013ce0 <log>
    80003566:	00005597          	auipc	a1,0x5
    8000356a:	04258593          	addi	a1,a1,66 # 800085a8 <syscalls+0x1d8>
    8000356e:	8526                	mv	a0,s1
    80003570:	00003097          	auipc	ra,0x3
    80003574:	bce080e7          	jalr	-1074(ra) # 8000613e <initlock>
  log.start = sb->logstart;
    80003578:	0149a583          	lw	a1,20(s3)
    8000357c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357e:	0109a783          	lw	a5,16(s3)
    80003582:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003584:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003588:	854a                	mv	a0,s2
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	d3c080e7          	jalr	-708(ra) # 800022c6 <bread>
  log.lh.n = lh->n;
    80003592:	4d30                	lw	a2,88(a0)
    80003594:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003596:	00c05f63          	blez	a2,800035b4 <initlog+0x68>
    8000359a:	87aa                	mv	a5,a0
    8000359c:	00010717          	auipc	a4,0x10
    800035a0:	77470713          	addi	a4,a4,1908 # 80013d10 <log+0x30>
    800035a4:	060a                	slli	a2,a2,0x2
    800035a6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035a8:	4ff4                	lw	a3,92(a5)
    800035aa:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035ac:	0791                	addi	a5,a5,4
    800035ae:	0711                	addi	a4,a4,4
    800035b0:	fec79ce3          	bne	a5,a2,800035a8 <initlog+0x5c>
  brelse(buf);
    800035b4:	fffff097          	auipc	ra,0xfffff
    800035b8:	e42080e7          	jalr	-446(ra) # 800023f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035bc:	4505                	li	a0,1
    800035be:	00000097          	auipc	ra,0x0
    800035c2:	eca080e7          	jalr	-310(ra) # 80003488 <install_trans>
  log.lh.n = 0;
    800035c6:	00010797          	auipc	a5,0x10
    800035ca:	7407a323          	sw	zero,1862(a5) # 80013d0c <log+0x2c>
  write_head(); // clear the log
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	e50080e7          	jalr	-432(ra) # 8000341e <write_head>
}
    800035d6:	70a2                	ld	ra,40(sp)
    800035d8:	7402                	ld	s0,32(sp)
    800035da:	64e2                	ld	s1,24(sp)
    800035dc:	6942                	ld	s2,16(sp)
    800035de:	69a2                	ld	s3,8(sp)
    800035e0:	6145                	addi	sp,sp,48
    800035e2:	8082                	ret

00000000800035e4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035e4:	1101                	addi	sp,sp,-32
    800035e6:	ec06                	sd	ra,24(sp)
    800035e8:	e822                	sd	s0,16(sp)
    800035ea:	e426                	sd	s1,8(sp)
    800035ec:	e04a                	sd	s2,0(sp)
    800035ee:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035f0:	00010517          	auipc	a0,0x10
    800035f4:	6f050513          	addi	a0,a0,1776 # 80013ce0 <log>
    800035f8:	00003097          	auipc	ra,0x3
    800035fc:	bd6080e7          	jalr	-1066(ra) # 800061ce <acquire>
  while(1){
    if(log.committing){
    80003600:	00010497          	auipc	s1,0x10
    80003604:	6e048493          	addi	s1,s1,1760 # 80013ce0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003608:	4979                	li	s2,30
    8000360a:	a039                	j	80003618 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000360c:	85a6                	mv	a1,s1
    8000360e:	8526                	mv	a0,s1
    80003610:	ffffe097          	auipc	ra,0xffffe
    80003614:	eea080e7          	jalr	-278(ra) # 800014fa <sleep>
    if(log.committing){
    80003618:	50dc                	lw	a5,36(s1)
    8000361a:	fbed                	bnez	a5,8000360c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361c:	5098                	lw	a4,32(s1)
    8000361e:	2705                	addiw	a4,a4,1
    80003620:	0027179b          	slliw	a5,a4,0x2
    80003624:	9fb9                	addw	a5,a5,a4
    80003626:	0017979b          	slliw	a5,a5,0x1
    8000362a:	54d4                	lw	a3,44(s1)
    8000362c:	9fb5                	addw	a5,a5,a3
    8000362e:	00f95963          	bge	s2,a5,80003640 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003632:	85a6                	mv	a1,s1
    80003634:	8526                	mv	a0,s1
    80003636:	ffffe097          	auipc	ra,0xffffe
    8000363a:	ec4080e7          	jalr	-316(ra) # 800014fa <sleep>
    8000363e:	bfe9                	j	80003618 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003640:	00010517          	auipc	a0,0x10
    80003644:	6a050513          	addi	a0,a0,1696 # 80013ce0 <log>
    80003648:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000364a:	00003097          	auipc	ra,0x3
    8000364e:	c38080e7          	jalr	-968(ra) # 80006282 <release>
      break;
    }
  }
}
    80003652:	60e2                	ld	ra,24(sp)
    80003654:	6442                	ld	s0,16(sp)
    80003656:	64a2                	ld	s1,8(sp)
    80003658:	6902                	ld	s2,0(sp)
    8000365a:	6105                	addi	sp,sp,32
    8000365c:	8082                	ret

000000008000365e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000365e:	7139                	addi	sp,sp,-64
    80003660:	fc06                	sd	ra,56(sp)
    80003662:	f822                	sd	s0,48(sp)
    80003664:	f426                	sd	s1,40(sp)
    80003666:	f04a                	sd	s2,32(sp)
    80003668:	ec4e                	sd	s3,24(sp)
    8000366a:	e852                	sd	s4,16(sp)
    8000366c:	e456                	sd	s5,8(sp)
    8000366e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003670:	00010497          	auipc	s1,0x10
    80003674:	67048493          	addi	s1,s1,1648 # 80013ce0 <log>
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	b54080e7          	jalr	-1196(ra) # 800061ce <acquire>
  log.outstanding -= 1;
    80003682:	509c                	lw	a5,32(s1)
    80003684:	37fd                	addiw	a5,a5,-1
    80003686:	0007891b          	sext.w	s2,a5
    8000368a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000368c:	50dc                	lw	a5,36(s1)
    8000368e:	e7b9                	bnez	a5,800036dc <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003690:	04091e63          	bnez	s2,800036ec <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003694:	00010497          	auipc	s1,0x10
    80003698:	64c48493          	addi	s1,s1,1612 # 80013ce0 <log>
    8000369c:	4785                	li	a5,1
    8000369e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036a0:	8526                	mv	a0,s1
    800036a2:	00003097          	auipc	ra,0x3
    800036a6:	be0080e7          	jalr	-1056(ra) # 80006282 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036aa:	54dc                	lw	a5,44(s1)
    800036ac:	06f04763          	bgtz	a5,8000371a <end_op+0xbc>
    acquire(&log.lock);
    800036b0:	00010497          	auipc	s1,0x10
    800036b4:	63048493          	addi	s1,s1,1584 # 80013ce0 <log>
    800036b8:	8526                	mv	a0,s1
    800036ba:	00003097          	auipc	ra,0x3
    800036be:	b14080e7          	jalr	-1260(ra) # 800061ce <acquire>
    log.committing = 0;
    800036c2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036c6:	8526                	mv	a0,s1
    800036c8:	ffffe097          	auipc	ra,0xffffe
    800036cc:	e96080e7          	jalr	-362(ra) # 8000155e <wakeup>
    release(&log.lock);
    800036d0:	8526                	mv	a0,s1
    800036d2:	00003097          	auipc	ra,0x3
    800036d6:	bb0080e7          	jalr	-1104(ra) # 80006282 <release>
}
    800036da:	a03d                	j	80003708 <end_op+0xaa>
    panic("log.committing");
    800036dc:	00005517          	auipc	a0,0x5
    800036e0:	ed450513          	addi	a0,a0,-300 # 800085b0 <syscalls+0x1e0>
    800036e4:	00002097          	auipc	ra,0x2
    800036e8:	5b2080e7          	jalr	1458(ra) # 80005c96 <panic>
    wakeup(&log);
    800036ec:	00010497          	auipc	s1,0x10
    800036f0:	5f448493          	addi	s1,s1,1524 # 80013ce0 <log>
    800036f4:	8526                	mv	a0,s1
    800036f6:	ffffe097          	auipc	ra,0xffffe
    800036fa:	e68080e7          	jalr	-408(ra) # 8000155e <wakeup>
  release(&log.lock);
    800036fe:	8526                	mv	a0,s1
    80003700:	00003097          	auipc	ra,0x3
    80003704:	b82080e7          	jalr	-1150(ra) # 80006282 <release>
}
    80003708:	70e2                	ld	ra,56(sp)
    8000370a:	7442                	ld	s0,48(sp)
    8000370c:	74a2                	ld	s1,40(sp)
    8000370e:	7902                	ld	s2,32(sp)
    80003710:	69e2                	ld	s3,24(sp)
    80003712:	6a42                	ld	s4,16(sp)
    80003714:	6aa2                	ld	s5,8(sp)
    80003716:	6121                	addi	sp,sp,64
    80003718:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371a:	00010a97          	auipc	s5,0x10
    8000371e:	5f6a8a93          	addi	s5,s5,1526 # 80013d10 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003722:	00010a17          	auipc	s4,0x10
    80003726:	5bea0a13          	addi	s4,s4,1470 # 80013ce0 <log>
    8000372a:	018a2583          	lw	a1,24(s4)
    8000372e:	012585bb          	addw	a1,a1,s2
    80003732:	2585                	addiw	a1,a1,1
    80003734:	028a2503          	lw	a0,40(s4)
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	b8e080e7          	jalr	-1138(ra) # 800022c6 <bread>
    80003740:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003742:	000aa583          	lw	a1,0(s5)
    80003746:	028a2503          	lw	a0,40(s4)
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	b7c080e7          	jalr	-1156(ra) # 800022c6 <bread>
    80003752:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003754:	40000613          	li	a2,1024
    80003758:	05850593          	addi	a1,a0,88
    8000375c:	05848513          	addi	a0,s1,88
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	a76080e7          	jalr	-1418(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003768:	8526                	mv	a0,s1
    8000376a:	fffff097          	auipc	ra,0xfffff
    8000376e:	c4e080e7          	jalr	-946(ra) # 800023b8 <bwrite>
    brelse(from);
    80003772:	854e                	mv	a0,s3
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	c82080e7          	jalr	-894(ra) # 800023f6 <brelse>
    brelse(to);
    8000377c:	8526                	mv	a0,s1
    8000377e:	fffff097          	auipc	ra,0xfffff
    80003782:	c78080e7          	jalr	-904(ra) # 800023f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003786:	2905                	addiw	s2,s2,1
    80003788:	0a91                	addi	s5,s5,4
    8000378a:	02ca2783          	lw	a5,44(s4)
    8000378e:	f8f94ee3          	blt	s2,a5,8000372a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003792:	00000097          	auipc	ra,0x0
    80003796:	c8c080e7          	jalr	-884(ra) # 8000341e <write_head>
    install_trans(0); // Now install writes to home locations
    8000379a:	4501                	li	a0,0
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	cec080e7          	jalr	-788(ra) # 80003488 <install_trans>
    log.lh.n = 0;
    800037a4:	00010797          	auipc	a5,0x10
    800037a8:	5607a423          	sw	zero,1384(a5) # 80013d0c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037ac:	00000097          	auipc	ra,0x0
    800037b0:	c72080e7          	jalr	-910(ra) # 8000341e <write_head>
    800037b4:	bdf5                	j	800036b0 <end_op+0x52>

00000000800037b6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037b6:	1101                	addi	sp,sp,-32
    800037b8:	ec06                	sd	ra,24(sp)
    800037ba:	e822                	sd	s0,16(sp)
    800037bc:	e426                	sd	s1,8(sp)
    800037be:	e04a                	sd	s2,0(sp)
    800037c0:	1000                	addi	s0,sp,32
    800037c2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037c4:	00010917          	auipc	s2,0x10
    800037c8:	51c90913          	addi	s2,s2,1308 # 80013ce0 <log>
    800037cc:	854a                	mv	a0,s2
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	a00080e7          	jalr	-1536(ra) # 800061ce <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037d6:	02c92603          	lw	a2,44(s2)
    800037da:	47f5                	li	a5,29
    800037dc:	06c7c563          	blt	a5,a2,80003846 <log_write+0x90>
    800037e0:	00010797          	auipc	a5,0x10
    800037e4:	51c7a783          	lw	a5,1308(a5) # 80013cfc <log+0x1c>
    800037e8:	37fd                	addiw	a5,a5,-1
    800037ea:	04f65e63          	bge	a2,a5,80003846 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ee:	00010797          	auipc	a5,0x10
    800037f2:	5127a783          	lw	a5,1298(a5) # 80013d00 <log+0x20>
    800037f6:	06f05063          	blez	a5,80003856 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037fa:	4781                	li	a5,0
    800037fc:	06c05563          	blez	a2,80003866 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003800:	44cc                	lw	a1,12(s1)
    80003802:	00010717          	auipc	a4,0x10
    80003806:	50e70713          	addi	a4,a4,1294 # 80013d10 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000380a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000380c:	4314                	lw	a3,0(a4)
    8000380e:	04b68c63          	beq	a3,a1,80003866 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003812:	2785                	addiw	a5,a5,1
    80003814:	0711                	addi	a4,a4,4
    80003816:	fef61be3          	bne	a2,a5,8000380c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000381a:	0621                	addi	a2,a2,8
    8000381c:	060a                	slli	a2,a2,0x2
    8000381e:	00010797          	auipc	a5,0x10
    80003822:	4c278793          	addi	a5,a5,1218 # 80013ce0 <log>
    80003826:	97b2                	add	a5,a5,a2
    80003828:	44d8                	lw	a4,12(s1)
    8000382a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000382c:	8526                	mv	a0,s1
    8000382e:	fffff097          	auipc	ra,0xfffff
    80003832:	c64080e7          	jalr	-924(ra) # 80002492 <bpin>
    log.lh.n++;
    80003836:	00010717          	auipc	a4,0x10
    8000383a:	4aa70713          	addi	a4,a4,1194 # 80013ce0 <log>
    8000383e:	575c                	lw	a5,44(a4)
    80003840:	2785                	addiw	a5,a5,1
    80003842:	d75c                	sw	a5,44(a4)
    80003844:	a82d                	j	8000387e <log_write+0xc8>
    panic("too big a transaction");
    80003846:	00005517          	auipc	a0,0x5
    8000384a:	d7a50513          	addi	a0,a0,-646 # 800085c0 <syscalls+0x1f0>
    8000384e:	00002097          	auipc	ra,0x2
    80003852:	448080e7          	jalr	1096(ra) # 80005c96 <panic>
    panic("log_write outside of trans");
    80003856:	00005517          	auipc	a0,0x5
    8000385a:	d8250513          	addi	a0,a0,-638 # 800085d8 <syscalls+0x208>
    8000385e:	00002097          	auipc	ra,0x2
    80003862:	438080e7          	jalr	1080(ra) # 80005c96 <panic>
  log.lh.block[i] = b->blockno;
    80003866:	00878693          	addi	a3,a5,8
    8000386a:	068a                	slli	a3,a3,0x2
    8000386c:	00010717          	auipc	a4,0x10
    80003870:	47470713          	addi	a4,a4,1140 # 80013ce0 <log>
    80003874:	9736                	add	a4,a4,a3
    80003876:	44d4                	lw	a3,12(s1)
    80003878:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000387a:	faf609e3          	beq	a2,a5,8000382c <log_write+0x76>
  }
  release(&log.lock);
    8000387e:	00010517          	auipc	a0,0x10
    80003882:	46250513          	addi	a0,a0,1122 # 80013ce0 <log>
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	9fc080e7          	jalr	-1540(ra) # 80006282 <release>
}
    8000388e:	60e2                	ld	ra,24(sp)
    80003890:	6442                	ld	s0,16(sp)
    80003892:	64a2                	ld	s1,8(sp)
    80003894:	6902                	ld	s2,0(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret

000000008000389a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	e04a                	sd	s2,0(sp)
    800038a4:	1000                	addi	s0,sp,32
    800038a6:	84aa                	mv	s1,a0
    800038a8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038aa:	00005597          	auipc	a1,0x5
    800038ae:	d4e58593          	addi	a1,a1,-690 # 800085f8 <syscalls+0x228>
    800038b2:	0521                	addi	a0,a0,8
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	88a080e7          	jalr	-1910(ra) # 8000613e <initlock>
  lk->name = name;
    800038bc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038c0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038c4:	0204a423          	sw	zero,40(s1)
}
    800038c8:	60e2                	ld	ra,24(sp)
    800038ca:	6442                	ld	s0,16(sp)
    800038cc:	64a2                	ld	s1,8(sp)
    800038ce:	6902                	ld	s2,0(sp)
    800038d0:	6105                	addi	sp,sp,32
    800038d2:	8082                	ret

00000000800038d4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038d4:	1101                	addi	sp,sp,-32
    800038d6:	ec06                	sd	ra,24(sp)
    800038d8:	e822                	sd	s0,16(sp)
    800038da:	e426                	sd	s1,8(sp)
    800038dc:	e04a                	sd	s2,0(sp)
    800038de:	1000                	addi	s0,sp,32
    800038e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e2:	00850913          	addi	s2,a0,8
    800038e6:	854a                	mv	a0,s2
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	8e6080e7          	jalr	-1818(ra) # 800061ce <acquire>
  while (lk->locked) {
    800038f0:	409c                	lw	a5,0(s1)
    800038f2:	cb89                	beqz	a5,80003904 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038f4:	85ca                	mv	a1,s2
    800038f6:	8526                	mv	a0,s1
    800038f8:	ffffe097          	auipc	ra,0xffffe
    800038fc:	c02080e7          	jalr	-1022(ra) # 800014fa <sleep>
  while (lk->locked) {
    80003900:	409c                	lw	a5,0(s1)
    80003902:	fbed                	bnez	a5,800038f4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003904:	4785                	li	a5,1
    80003906:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	54a080e7          	jalr	1354(ra) # 80000e52 <myproc>
    80003910:	591c                	lw	a5,48(a0)
    80003912:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	96c080e7          	jalr	-1684(ra) # 80006282 <release>
}
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6902                	ld	s2,0(sp)
    80003926:	6105                	addi	sp,sp,32
    80003928:	8082                	ret

000000008000392a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	e04a                	sd	s2,0(sp)
    80003934:	1000                	addi	s0,sp,32
    80003936:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003938:	00850913          	addi	s2,a0,8
    8000393c:	854a                	mv	a0,s2
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	890080e7          	jalr	-1904(ra) # 800061ce <acquire>
  lk->locked = 0;
    80003946:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000394a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000394e:	8526                	mv	a0,s1
    80003950:	ffffe097          	auipc	ra,0xffffe
    80003954:	c0e080e7          	jalr	-1010(ra) # 8000155e <wakeup>
  release(&lk->lk);
    80003958:	854a                	mv	a0,s2
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	928080e7          	jalr	-1752(ra) # 80006282 <release>
}
    80003962:	60e2                	ld	ra,24(sp)
    80003964:	6442                	ld	s0,16(sp)
    80003966:	64a2                	ld	s1,8(sp)
    80003968:	6902                	ld	s2,0(sp)
    8000396a:	6105                	addi	sp,sp,32
    8000396c:	8082                	ret

000000008000396e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000396e:	7179                	addi	sp,sp,-48
    80003970:	f406                	sd	ra,40(sp)
    80003972:	f022                	sd	s0,32(sp)
    80003974:	ec26                	sd	s1,24(sp)
    80003976:	e84a                	sd	s2,16(sp)
    80003978:	e44e                	sd	s3,8(sp)
    8000397a:	1800                	addi	s0,sp,48
    8000397c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000397e:	00850913          	addi	s2,a0,8
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	84a080e7          	jalr	-1974(ra) # 800061ce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398c:	409c                	lw	a5,0(s1)
    8000398e:	ef99                	bnez	a5,800039ac <holdingsleep+0x3e>
    80003990:	4481                	li	s1,0
  release(&lk->lk);
    80003992:	854a                	mv	a0,s2
    80003994:	00003097          	auipc	ra,0x3
    80003998:	8ee080e7          	jalr	-1810(ra) # 80006282 <release>
  return r;
}
    8000399c:	8526                	mv	a0,s1
    8000399e:	70a2                	ld	ra,40(sp)
    800039a0:	7402                	ld	s0,32(sp)
    800039a2:	64e2                	ld	s1,24(sp)
    800039a4:	6942                	ld	s2,16(sp)
    800039a6:	69a2                	ld	s3,8(sp)
    800039a8:	6145                	addi	sp,sp,48
    800039aa:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ac:	0284a983          	lw	s3,40(s1)
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	4a2080e7          	jalr	1186(ra) # 80000e52 <myproc>
    800039b8:	5904                	lw	s1,48(a0)
    800039ba:	413484b3          	sub	s1,s1,s3
    800039be:	0014b493          	seqz	s1,s1
    800039c2:	bfc1                	j	80003992 <holdingsleep+0x24>

00000000800039c4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039c4:	1141                	addi	sp,sp,-16
    800039c6:	e406                	sd	ra,8(sp)
    800039c8:	e022                	sd	s0,0(sp)
    800039ca:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039cc:	00005597          	auipc	a1,0x5
    800039d0:	c3c58593          	addi	a1,a1,-964 # 80008608 <syscalls+0x238>
    800039d4:	00010517          	auipc	a0,0x10
    800039d8:	45450513          	addi	a0,a0,1108 # 80013e28 <ftable>
    800039dc:	00002097          	auipc	ra,0x2
    800039e0:	762080e7          	jalr	1890(ra) # 8000613e <initlock>
}
    800039e4:	60a2                	ld	ra,8(sp)
    800039e6:	6402                	ld	s0,0(sp)
    800039e8:	0141                	addi	sp,sp,16
    800039ea:	8082                	ret

00000000800039ec <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039f6:	00010517          	auipc	a0,0x10
    800039fa:	43250513          	addi	a0,a0,1074 # 80013e28 <ftable>
    800039fe:	00002097          	auipc	ra,0x2
    80003a02:	7d0080e7          	jalr	2000(ra) # 800061ce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a06:	00010497          	auipc	s1,0x10
    80003a0a:	43a48493          	addi	s1,s1,1082 # 80013e40 <ftable+0x18>
    80003a0e:	00011717          	auipc	a4,0x11
    80003a12:	3d270713          	addi	a4,a4,978 # 80014de0 <disk>
    if(f->ref == 0){
    80003a16:	40dc                	lw	a5,4(s1)
    80003a18:	cf99                	beqz	a5,80003a36 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a1a:	02848493          	addi	s1,s1,40
    80003a1e:	fee49ce3          	bne	s1,a4,80003a16 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a22:	00010517          	auipc	a0,0x10
    80003a26:	40650513          	addi	a0,a0,1030 # 80013e28 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	858080e7          	jalr	-1960(ra) # 80006282 <release>
  return 0;
    80003a32:	4481                	li	s1,0
    80003a34:	a819                	j	80003a4a <filealloc+0x5e>
      f->ref = 1;
    80003a36:	4785                	li	a5,1
    80003a38:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a3a:	00010517          	auipc	a0,0x10
    80003a3e:	3ee50513          	addi	a0,a0,1006 # 80013e28 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	840080e7          	jalr	-1984(ra) # 80006282 <release>
}
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6105                	addi	sp,sp,32
    80003a54:	8082                	ret

0000000080003a56 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a56:	1101                	addi	sp,sp,-32
    80003a58:	ec06                	sd	ra,24(sp)
    80003a5a:	e822                	sd	s0,16(sp)
    80003a5c:	e426                	sd	s1,8(sp)
    80003a5e:	1000                	addi	s0,sp,32
    80003a60:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a62:	00010517          	auipc	a0,0x10
    80003a66:	3c650513          	addi	a0,a0,966 # 80013e28 <ftable>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	764080e7          	jalr	1892(ra) # 800061ce <acquire>
  if(f->ref < 1)
    80003a72:	40dc                	lw	a5,4(s1)
    80003a74:	02f05263          	blez	a5,80003a98 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a78:	2785                	addiw	a5,a5,1
    80003a7a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a7c:	00010517          	auipc	a0,0x10
    80003a80:	3ac50513          	addi	a0,a0,940 # 80013e28 <ftable>
    80003a84:	00002097          	auipc	ra,0x2
    80003a88:	7fe080e7          	jalr	2046(ra) # 80006282 <release>
  return f;
}
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	64a2                	ld	s1,8(sp)
    80003a94:	6105                	addi	sp,sp,32
    80003a96:	8082                	ret
    panic("filedup");
    80003a98:	00005517          	auipc	a0,0x5
    80003a9c:	b7850513          	addi	a0,a0,-1160 # 80008610 <syscalls+0x240>
    80003aa0:	00002097          	auipc	ra,0x2
    80003aa4:	1f6080e7          	jalr	502(ra) # 80005c96 <panic>

0000000080003aa8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aa8:	7139                	addi	sp,sp,-64
    80003aaa:	fc06                	sd	ra,56(sp)
    80003aac:	f822                	sd	s0,48(sp)
    80003aae:	f426                	sd	s1,40(sp)
    80003ab0:	f04a                	sd	s2,32(sp)
    80003ab2:	ec4e                	sd	s3,24(sp)
    80003ab4:	e852                	sd	s4,16(sp)
    80003ab6:	e456                	sd	s5,8(sp)
    80003ab8:	0080                	addi	s0,sp,64
    80003aba:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003abc:	00010517          	auipc	a0,0x10
    80003ac0:	36c50513          	addi	a0,a0,876 # 80013e28 <ftable>
    80003ac4:	00002097          	auipc	ra,0x2
    80003ac8:	70a080e7          	jalr	1802(ra) # 800061ce <acquire>
  if(f->ref < 1)
    80003acc:	40dc                	lw	a5,4(s1)
    80003ace:	06f05163          	blez	a5,80003b30 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ad2:	37fd                	addiw	a5,a5,-1
    80003ad4:	0007871b          	sext.w	a4,a5
    80003ad8:	c0dc                	sw	a5,4(s1)
    80003ada:	06e04363          	bgtz	a4,80003b40 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ade:	0004a903          	lw	s2,0(s1)
    80003ae2:	0094ca83          	lbu	s5,9(s1)
    80003ae6:	0104ba03          	ld	s4,16(s1)
    80003aea:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aee:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003af2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003af6:	00010517          	auipc	a0,0x10
    80003afa:	33250513          	addi	a0,a0,818 # 80013e28 <ftable>
    80003afe:	00002097          	auipc	ra,0x2
    80003b02:	784080e7          	jalr	1924(ra) # 80006282 <release>

  if(ff.type == FD_PIPE){
    80003b06:	4785                	li	a5,1
    80003b08:	04f90d63          	beq	s2,a5,80003b62 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b0c:	3979                	addiw	s2,s2,-2
    80003b0e:	4785                	li	a5,1
    80003b10:	0527e063          	bltu	a5,s2,80003b50 <fileclose+0xa8>
    begin_op();
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	ad0080e7          	jalr	-1328(ra) # 800035e4 <begin_op>
    iput(ff.ip);
    80003b1c:	854e                	mv	a0,s3
    80003b1e:	fffff097          	auipc	ra,0xfffff
    80003b22:	2d8080e7          	jalr	728(ra) # 80002df6 <iput>
    end_op();
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	b38080e7          	jalr	-1224(ra) # 8000365e <end_op>
    80003b2e:	a00d                	j	80003b50 <fileclose+0xa8>
    panic("fileclose");
    80003b30:	00005517          	auipc	a0,0x5
    80003b34:	ae850513          	addi	a0,a0,-1304 # 80008618 <syscalls+0x248>
    80003b38:	00002097          	auipc	ra,0x2
    80003b3c:	15e080e7          	jalr	350(ra) # 80005c96 <panic>
    release(&ftable.lock);
    80003b40:	00010517          	auipc	a0,0x10
    80003b44:	2e850513          	addi	a0,a0,744 # 80013e28 <ftable>
    80003b48:	00002097          	auipc	ra,0x2
    80003b4c:	73a080e7          	jalr	1850(ra) # 80006282 <release>
  }
}
    80003b50:	70e2                	ld	ra,56(sp)
    80003b52:	7442                	ld	s0,48(sp)
    80003b54:	74a2                	ld	s1,40(sp)
    80003b56:	7902                	ld	s2,32(sp)
    80003b58:	69e2                	ld	s3,24(sp)
    80003b5a:	6a42                	ld	s4,16(sp)
    80003b5c:	6aa2                	ld	s5,8(sp)
    80003b5e:	6121                	addi	sp,sp,64
    80003b60:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b62:	85d6                	mv	a1,s5
    80003b64:	8552                	mv	a0,s4
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	348080e7          	jalr	840(ra) # 80003eae <pipeclose>
    80003b6e:	b7cd                	j	80003b50 <fileclose+0xa8>

0000000080003b70 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b70:	715d                	addi	sp,sp,-80
    80003b72:	e486                	sd	ra,72(sp)
    80003b74:	e0a2                	sd	s0,64(sp)
    80003b76:	fc26                	sd	s1,56(sp)
    80003b78:	f84a                	sd	s2,48(sp)
    80003b7a:	f44e                	sd	s3,40(sp)
    80003b7c:	0880                	addi	s0,sp,80
    80003b7e:	84aa                	mv	s1,a0
    80003b80:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b82:	ffffd097          	auipc	ra,0xffffd
    80003b86:	2d0080e7          	jalr	720(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b8a:	409c                	lw	a5,0(s1)
    80003b8c:	37f9                	addiw	a5,a5,-2
    80003b8e:	4705                	li	a4,1
    80003b90:	04f76763          	bltu	a4,a5,80003bde <filestat+0x6e>
    80003b94:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	010080e7          	jalr	16(ra) # 80002ba8 <ilock>
    stati(f->ip, &st);
    80003ba0:	fb840593          	addi	a1,s0,-72
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	320080e7          	jalr	800(ra) # 80002ec6 <stati>
    iunlock(f->ip);
    80003bae:	6c88                	ld	a0,24(s1)
    80003bb0:	fffff097          	auipc	ra,0xfffff
    80003bb4:	0ba080e7          	jalr	186(ra) # 80002c6a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bb8:	46e1                	li	a3,24
    80003bba:	fb840613          	addi	a2,s0,-72
    80003bbe:	85ce                	mv	a1,s3
    80003bc0:	05093503          	ld	a0,80(s2)
    80003bc4:	ffffd097          	auipc	ra,0xffffd
    80003bc8:	f4e080e7          	jalr	-178(ra) # 80000b12 <copyout>
    80003bcc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bd0:	60a6                	ld	ra,72(sp)
    80003bd2:	6406                	ld	s0,64(sp)
    80003bd4:	74e2                	ld	s1,56(sp)
    80003bd6:	7942                	ld	s2,48(sp)
    80003bd8:	79a2                	ld	s3,40(sp)
    80003bda:	6161                	addi	sp,sp,80
    80003bdc:	8082                	ret
  return -1;
    80003bde:	557d                	li	a0,-1
    80003be0:	bfc5                	j	80003bd0 <filestat+0x60>

0000000080003be2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003be2:	7179                	addi	sp,sp,-48
    80003be4:	f406                	sd	ra,40(sp)
    80003be6:	f022                	sd	s0,32(sp)
    80003be8:	ec26                	sd	s1,24(sp)
    80003bea:	e84a                	sd	s2,16(sp)
    80003bec:	e44e                	sd	s3,8(sp)
    80003bee:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bf0:	00854783          	lbu	a5,8(a0)
    80003bf4:	c3d5                	beqz	a5,80003c98 <fileread+0xb6>
    80003bf6:	84aa                	mv	s1,a0
    80003bf8:	89ae                	mv	s3,a1
    80003bfa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bfc:	411c                	lw	a5,0(a0)
    80003bfe:	4705                	li	a4,1
    80003c00:	04e78963          	beq	a5,a4,80003c52 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c04:	470d                	li	a4,3
    80003c06:	04e78d63          	beq	a5,a4,80003c60 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c0a:	4709                	li	a4,2
    80003c0c:	06e79e63          	bne	a5,a4,80003c88 <fileread+0xa6>
    ilock(f->ip);
    80003c10:	6d08                	ld	a0,24(a0)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	f96080e7          	jalr	-106(ra) # 80002ba8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c1a:	874a                	mv	a4,s2
    80003c1c:	5094                	lw	a3,32(s1)
    80003c1e:	864e                	mv	a2,s3
    80003c20:	4585                	li	a1,1
    80003c22:	6c88                	ld	a0,24(s1)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	2cc080e7          	jalr	716(ra) # 80002ef0 <readi>
    80003c2c:	892a                	mv	s2,a0
    80003c2e:	00a05563          	blez	a0,80003c38 <fileread+0x56>
      f->off += r;
    80003c32:	509c                	lw	a5,32(s1)
    80003c34:	9fa9                	addw	a5,a5,a0
    80003c36:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c38:	6c88                	ld	a0,24(s1)
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	030080e7          	jalr	48(ra) # 80002c6a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c42:	854a                	mv	a0,s2
    80003c44:	70a2                	ld	ra,40(sp)
    80003c46:	7402                	ld	s0,32(sp)
    80003c48:	64e2                	ld	s1,24(sp)
    80003c4a:	6942                	ld	s2,16(sp)
    80003c4c:	69a2                	ld	s3,8(sp)
    80003c4e:	6145                	addi	sp,sp,48
    80003c50:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c52:	6908                	ld	a0,16(a0)
    80003c54:	00000097          	auipc	ra,0x0
    80003c58:	3c2080e7          	jalr	962(ra) # 80004016 <piperead>
    80003c5c:	892a                	mv	s2,a0
    80003c5e:	b7d5                	j	80003c42 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c60:	02451783          	lh	a5,36(a0)
    80003c64:	03079693          	slli	a3,a5,0x30
    80003c68:	92c1                	srli	a3,a3,0x30
    80003c6a:	4725                	li	a4,9
    80003c6c:	02d76863          	bltu	a4,a3,80003c9c <fileread+0xba>
    80003c70:	0792                	slli	a5,a5,0x4
    80003c72:	00010717          	auipc	a4,0x10
    80003c76:	11670713          	addi	a4,a4,278 # 80013d88 <devsw>
    80003c7a:	97ba                	add	a5,a5,a4
    80003c7c:	639c                	ld	a5,0(a5)
    80003c7e:	c38d                	beqz	a5,80003ca0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c80:	4505                	li	a0,1
    80003c82:	9782                	jalr	a5
    80003c84:	892a                	mv	s2,a0
    80003c86:	bf75                	j	80003c42 <fileread+0x60>
    panic("fileread");
    80003c88:	00005517          	auipc	a0,0x5
    80003c8c:	9a050513          	addi	a0,a0,-1632 # 80008628 <syscalls+0x258>
    80003c90:	00002097          	auipc	ra,0x2
    80003c94:	006080e7          	jalr	6(ra) # 80005c96 <panic>
    return -1;
    80003c98:	597d                	li	s2,-1
    80003c9a:	b765                	j	80003c42 <fileread+0x60>
      return -1;
    80003c9c:	597d                	li	s2,-1
    80003c9e:	b755                	j	80003c42 <fileread+0x60>
    80003ca0:	597d                	li	s2,-1
    80003ca2:	b745                	j	80003c42 <fileread+0x60>

0000000080003ca4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003ca4:	00954783          	lbu	a5,9(a0)
    80003ca8:	10078e63          	beqz	a5,80003dc4 <filewrite+0x120>
{
    80003cac:	715d                	addi	sp,sp,-80
    80003cae:	e486                	sd	ra,72(sp)
    80003cb0:	e0a2                	sd	s0,64(sp)
    80003cb2:	fc26                	sd	s1,56(sp)
    80003cb4:	f84a                	sd	s2,48(sp)
    80003cb6:	f44e                	sd	s3,40(sp)
    80003cb8:	f052                	sd	s4,32(sp)
    80003cba:	ec56                	sd	s5,24(sp)
    80003cbc:	e85a                	sd	s6,16(sp)
    80003cbe:	e45e                	sd	s7,8(sp)
    80003cc0:	e062                	sd	s8,0(sp)
    80003cc2:	0880                	addi	s0,sp,80
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	8b2e                	mv	s6,a1
    80003cc8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cca:	411c                	lw	a5,0(a0)
    80003ccc:	4705                	li	a4,1
    80003cce:	02e78263          	beq	a5,a4,80003cf2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cd2:	470d                	li	a4,3
    80003cd4:	02e78563          	beq	a5,a4,80003cfe <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cd8:	4709                	li	a4,2
    80003cda:	0ce79d63          	bne	a5,a4,80003db4 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cde:	0ac05b63          	blez	a2,80003d94 <filewrite+0xf0>
    int i = 0;
    80003ce2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ce4:	6b85                	lui	s7,0x1
    80003ce6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cea:	6c05                	lui	s8,0x1
    80003cec:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cf0:	a851                	j	80003d84 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003cf2:	6908                	ld	a0,16(a0)
    80003cf4:	00000097          	auipc	ra,0x0
    80003cf8:	22a080e7          	jalr	554(ra) # 80003f1e <pipewrite>
    80003cfc:	a045                	j	80003d9c <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cfe:	02451783          	lh	a5,36(a0)
    80003d02:	03079693          	slli	a3,a5,0x30
    80003d06:	92c1                	srli	a3,a3,0x30
    80003d08:	4725                	li	a4,9
    80003d0a:	0ad76f63          	bltu	a4,a3,80003dc8 <filewrite+0x124>
    80003d0e:	0792                	slli	a5,a5,0x4
    80003d10:	00010717          	auipc	a4,0x10
    80003d14:	07870713          	addi	a4,a4,120 # 80013d88 <devsw>
    80003d18:	97ba                	add	a5,a5,a4
    80003d1a:	679c                	ld	a5,8(a5)
    80003d1c:	cbc5                	beqz	a5,80003dcc <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d1e:	4505                	li	a0,1
    80003d20:	9782                	jalr	a5
    80003d22:	a8ad                	j	80003d9c <filewrite+0xf8>
      if(n1 > max)
    80003d24:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	8bc080e7          	jalr	-1860(ra) # 800035e4 <begin_op>
      ilock(f->ip);
    80003d30:	01893503          	ld	a0,24(s2)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	e74080e7          	jalr	-396(ra) # 80002ba8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d3c:	8756                	mv	a4,s5
    80003d3e:	02092683          	lw	a3,32(s2)
    80003d42:	01698633          	add	a2,s3,s6
    80003d46:	4585                	li	a1,1
    80003d48:	01893503          	ld	a0,24(s2)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	29c080e7          	jalr	668(ra) # 80002fe8 <writei>
    80003d54:	84aa                	mv	s1,a0
    80003d56:	00a05763          	blez	a0,80003d64 <filewrite+0xc0>
        f->off += r;
    80003d5a:	02092783          	lw	a5,32(s2)
    80003d5e:	9fa9                	addw	a5,a5,a0
    80003d60:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d64:	01893503          	ld	a0,24(s2)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	f02080e7          	jalr	-254(ra) # 80002c6a <iunlock>
      end_op();
    80003d70:	00000097          	auipc	ra,0x0
    80003d74:	8ee080e7          	jalr	-1810(ra) # 8000365e <end_op>

      if(r != n1){
    80003d78:	009a9f63          	bne	s5,s1,80003d96 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d7c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d80:	0149db63          	bge	s3,s4,80003d96 <filewrite+0xf2>
      int n1 = n - i;
    80003d84:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d88:	0004879b          	sext.w	a5,s1
    80003d8c:	f8fbdce3          	bge	s7,a5,80003d24 <filewrite+0x80>
    80003d90:	84e2                	mv	s1,s8
    80003d92:	bf49                	j	80003d24 <filewrite+0x80>
    int i = 0;
    80003d94:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d96:	033a1d63          	bne	s4,s3,80003dd0 <filewrite+0x12c>
    80003d9a:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d9c:	60a6                	ld	ra,72(sp)
    80003d9e:	6406                	ld	s0,64(sp)
    80003da0:	74e2                	ld	s1,56(sp)
    80003da2:	7942                	ld	s2,48(sp)
    80003da4:	79a2                	ld	s3,40(sp)
    80003da6:	7a02                	ld	s4,32(sp)
    80003da8:	6ae2                	ld	s5,24(sp)
    80003daa:	6b42                	ld	s6,16(sp)
    80003dac:	6ba2                	ld	s7,8(sp)
    80003dae:	6c02                	ld	s8,0(sp)
    80003db0:	6161                	addi	sp,sp,80
    80003db2:	8082                	ret
    panic("filewrite");
    80003db4:	00005517          	auipc	a0,0x5
    80003db8:	88450513          	addi	a0,a0,-1916 # 80008638 <syscalls+0x268>
    80003dbc:	00002097          	auipc	ra,0x2
    80003dc0:	eda080e7          	jalr	-294(ra) # 80005c96 <panic>
    return -1;
    80003dc4:	557d                	li	a0,-1
}
    80003dc6:	8082                	ret
      return -1;
    80003dc8:	557d                	li	a0,-1
    80003dca:	bfc9                	j	80003d9c <filewrite+0xf8>
    80003dcc:	557d                	li	a0,-1
    80003dce:	b7f9                	j	80003d9c <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003dd0:	557d                	li	a0,-1
    80003dd2:	b7e9                	j	80003d9c <filewrite+0xf8>

0000000080003dd4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dd4:	7179                	addi	sp,sp,-48
    80003dd6:	f406                	sd	ra,40(sp)
    80003dd8:	f022                	sd	s0,32(sp)
    80003dda:	ec26                	sd	s1,24(sp)
    80003ddc:	e84a                	sd	s2,16(sp)
    80003dde:	e44e                	sd	s3,8(sp)
    80003de0:	e052                	sd	s4,0(sp)
    80003de2:	1800                	addi	s0,sp,48
    80003de4:	84aa                	mv	s1,a0
    80003de6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003de8:	0005b023          	sd	zero,0(a1)
    80003dec:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	bfc080e7          	jalr	-1028(ra) # 800039ec <filealloc>
    80003df8:	e088                	sd	a0,0(s1)
    80003dfa:	c551                	beqz	a0,80003e86 <pipealloc+0xb2>
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	bf0080e7          	jalr	-1040(ra) # 800039ec <filealloc>
    80003e04:	00aa3023          	sd	a0,0(s4)
    80003e08:	c92d                	beqz	a0,80003e7a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e0a:	ffffc097          	auipc	ra,0xffffc
    80003e0e:	310080e7          	jalr	784(ra) # 8000011a <kalloc>
    80003e12:	892a                	mv	s2,a0
    80003e14:	c125                	beqz	a0,80003e74 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e16:	4985                	li	s3,1
    80003e18:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e1c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e20:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e24:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e28:	00005597          	auipc	a1,0x5
    80003e2c:	82058593          	addi	a1,a1,-2016 # 80008648 <syscalls+0x278>
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	30e080e7          	jalr	782(ra) # 8000613e <initlock>
  (*f0)->type = FD_PIPE;
    80003e38:	609c                	ld	a5,0(s1)
    80003e3a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e3e:	609c                	ld	a5,0(s1)
    80003e40:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e44:	609c                	ld	a5,0(s1)
    80003e46:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e4a:	609c                	ld	a5,0(s1)
    80003e4c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e50:	000a3783          	ld	a5,0(s4)
    80003e54:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e58:	000a3783          	ld	a5,0(s4)
    80003e5c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e60:	000a3783          	ld	a5,0(s4)
    80003e64:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e68:	000a3783          	ld	a5,0(s4)
    80003e6c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e70:	4501                	li	a0,0
    80003e72:	a025                	j	80003e9a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e74:	6088                	ld	a0,0(s1)
    80003e76:	e501                	bnez	a0,80003e7e <pipealloc+0xaa>
    80003e78:	a039                	j	80003e86 <pipealloc+0xb2>
    80003e7a:	6088                	ld	a0,0(s1)
    80003e7c:	c51d                	beqz	a0,80003eaa <pipealloc+0xd6>
    fileclose(*f0);
    80003e7e:	00000097          	auipc	ra,0x0
    80003e82:	c2a080e7          	jalr	-982(ra) # 80003aa8 <fileclose>
  if(*f1)
    80003e86:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e8a:	557d                	li	a0,-1
  if(*f1)
    80003e8c:	c799                	beqz	a5,80003e9a <pipealloc+0xc6>
    fileclose(*f1);
    80003e8e:	853e                	mv	a0,a5
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	c18080e7          	jalr	-1000(ra) # 80003aa8 <fileclose>
  return -1;
    80003e98:	557d                	li	a0,-1
}
    80003e9a:	70a2                	ld	ra,40(sp)
    80003e9c:	7402                	ld	s0,32(sp)
    80003e9e:	64e2                	ld	s1,24(sp)
    80003ea0:	6942                	ld	s2,16(sp)
    80003ea2:	69a2                	ld	s3,8(sp)
    80003ea4:	6a02                	ld	s4,0(sp)
    80003ea6:	6145                	addi	sp,sp,48
    80003ea8:	8082                	ret
  return -1;
    80003eaa:	557d                	li	a0,-1
    80003eac:	b7fd                	j	80003e9a <pipealloc+0xc6>

0000000080003eae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003eae:	1101                	addi	sp,sp,-32
    80003eb0:	ec06                	sd	ra,24(sp)
    80003eb2:	e822                	sd	s0,16(sp)
    80003eb4:	e426                	sd	s1,8(sp)
    80003eb6:	e04a                	sd	s2,0(sp)
    80003eb8:	1000                	addi	s0,sp,32
    80003eba:	84aa                	mv	s1,a0
    80003ebc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ebe:	00002097          	auipc	ra,0x2
    80003ec2:	310080e7          	jalr	784(ra) # 800061ce <acquire>
  if(writable){
    80003ec6:	02090d63          	beqz	s2,80003f00 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eca:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ece:	21848513          	addi	a0,s1,536
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	68c080e7          	jalr	1676(ra) # 8000155e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eda:	2204b783          	ld	a5,544(s1)
    80003ede:	eb95                	bnez	a5,80003f12 <pipeclose+0x64>
    release(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	3a0080e7          	jalr	928(ra) # 80006282 <release>
    kfree((char*)pi);
    80003eea:	8526                	mv	a0,s1
    80003eec:	ffffc097          	auipc	ra,0xffffc
    80003ef0:	130080e7          	jalr	304(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ef4:	60e2                	ld	ra,24(sp)
    80003ef6:	6442                	ld	s0,16(sp)
    80003ef8:	64a2                	ld	s1,8(sp)
    80003efa:	6902                	ld	s2,0(sp)
    80003efc:	6105                	addi	sp,sp,32
    80003efe:	8082                	ret
    pi->readopen = 0;
    80003f00:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f04:	21c48513          	addi	a0,s1,540
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	656080e7          	jalr	1622(ra) # 8000155e <wakeup>
    80003f10:	b7e9                	j	80003eda <pipeclose+0x2c>
    release(&pi->lock);
    80003f12:	8526                	mv	a0,s1
    80003f14:	00002097          	auipc	ra,0x2
    80003f18:	36e080e7          	jalr	878(ra) # 80006282 <release>
}
    80003f1c:	bfe1                	j	80003ef4 <pipeclose+0x46>

0000000080003f1e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f1e:	711d                	addi	sp,sp,-96
    80003f20:	ec86                	sd	ra,88(sp)
    80003f22:	e8a2                	sd	s0,80(sp)
    80003f24:	e4a6                	sd	s1,72(sp)
    80003f26:	e0ca                	sd	s2,64(sp)
    80003f28:	fc4e                	sd	s3,56(sp)
    80003f2a:	f852                	sd	s4,48(sp)
    80003f2c:	f456                	sd	s5,40(sp)
    80003f2e:	f05a                	sd	s6,32(sp)
    80003f30:	ec5e                	sd	s7,24(sp)
    80003f32:	e862                	sd	s8,16(sp)
    80003f34:	1080                	addi	s0,sp,96
    80003f36:	84aa                	mv	s1,a0
    80003f38:	8aae                	mv	s5,a1
    80003f3a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	f16080e7          	jalr	-234(ra) # 80000e52 <myproc>
    80003f44:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f46:	8526                	mv	a0,s1
    80003f48:	00002097          	auipc	ra,0x2
    80003f4c:	286080e7          	jalr	646(ra) # 800061ce <acquire>
  while(i < n){
    80003f50:	0b405663          	blez	s4,80003ffc <pipewrite+0xde>
  int i = 0;
    80003f54:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f56:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f58:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f5c:	21c48b93          	addi	s7,s1,540
    80003f60:	a089                	j	80003fa2 <pipewrite+0x84>
      release(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	31e080e7          	jalr	798(ra) # 80006282 <release>
      return -1;
    80003f6c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f6e:	854a                	mv	a0,s2
    80003f70:	60e6                	ld	ra,88(sp)
    80003f72:	6446                	ld	s0,80(sp)
    80003f74:	64a6                	ld	s1,72(sp)
    80003f76:	6906                	ld	s2,64(sp)
    80003f78:	79e2                	ld	s3,56(sp)
    80003f7a:	7a42                	ld	s4,48(sp)
    80003f7c:	7aa2                	ld	s5,40(sp)
    80003f7e:	7b02                	ld	s6,32(sp)
    80003f80:	6be2                	ld	s7,24(sp)
    80003f82:	6c42                	ld	s8,16(sp)
    80003f84:	6125                	addi	sp,sp,96
    80003f86:	8082                	ret
      wakeup(&pi->nread);
    80003f88:	8562                	mv	a0,s8
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	5d4080e7          	jalr	1492(ra) # 8000155e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f92:	85a6                	mv	a1,s1
    80003f94:	855e                	mv	a0,s7
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	564080e7          	jalr	1380(ra) # 800014fa <sleep>
  while(i < n){
    80003f9e:	07495063          	bge	s2,s4,80003ffe <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fa2:	2204a783          	lw	a5,544(s1)
    80003fa6:	dfd5                	beqz	a5,80003f62 <pipewrite+0x44>
    80003fa8:	854e                	mv	a0,s3
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	7f2080e7          	jalr	2034(ra) # 8000179c <killed>
    80003fb2:	f945                	bnez	a0,80003f62 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fb4:	2184a783          	lw	a5,536(s1)
    80003fb8:	21c4a703          	lw	a4,540(s1)
    80003fbc:	2007879b          	addiw	a5,a5,512
    80003fc0:	fcf704e3          	beq	a4,a5,80003f88 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc4:	4685                	li	a3,1
    80003fc6:	01590633          	add	a2,s2,s5
    80003fca:	faf40593          	addi	a1,s0,-81
    80003fce:	0509b503          	ld	a0,80(s3)
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	bcc080e7          	jalr	-1076(ra) # 80000b9e <copyin>
    80003fda:	03650263          	beq	a0,s6,80003ffe <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fde:	21c4a783          	lw	a5,540(s1)
    80003fe2:	0017871b          	addiw	a4,a5,1
    80003fe6:	20e4ae23          	sw	a4,540(s1)
    80003fea:	1ff7f793          	andi	a5,a5,511
    80003fee:	97a6                	add	a5,a5,s1
    80003ff0:	faf44703          	lbu	a4,-81(s0)
    80003ff4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ff8:	2905                	addiw	s2,s2,1
    80003ffa:	b755                	j	80003f9e <pipewrite+0x80>
  int i = 0;
    80003ffc:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ffe:	21848513          	addi	a0,s1,536
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	55c080e7          	jalr	1372(ra) # 8000155e <wakeup>
  release(&pi->lock);
    8000400a:	8526                	mv	a0,s1
    8000400c:	00002097          	auipc	ra,0x2
    80004010:	276080e7          	jalr	630(ra) # 80006282 <release>
  return i;
    80004014:	bfa9                	j	80003f6e <pipewrite+0x50>

0000000080004016 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004016:	715d                	addi	sp,sp,-80
    80004018:	e486                	sd	ra,72(sp)
    8000401a:	e0a2                	sd	s0,64(sp)
    8000401c:	fc26                	sd	s1,56(sp)
    8000401e:	f84a                	sd	s2,48(sp)
    80004020:	f44e                	sd	s3,40(sp)
    80004022:	f052                	sd	s4,32(sp)
    80004024:	ec56                	sd	s5,24(sp)
    80004026:	e85a                	sd	s6,16(sp)
    80004028:	0880                	addi	s0,sp,80
    8000402a:	84aa                	mv	s1,a0
    8000402c:	892e                	mv	s2,a1
    8000402e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	e22080e7          	jalr	-478(ra) # 80000e52 <myproc>
    80004038:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	192080e7          	jalr	402(ra) # 800061ce <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004044:	2184a703          	lw	a4,536(s1)
    80004048:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000404c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004050:	02f71763          	bne	a4,a5,8000407e <piperead+0x68>
    80004054:	2244a783          	lw	a5,548(s1)
    80004058:	c39d                	beqz	a5,8000407e <piperead+0x68>
    if(killed(pr)){
    8000405a:	8552                	mv	a0,s4
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	740080e7          	jalr	1856(ra) # 8000179c <killed>
    80004064:	e949                	bnez	a0,800040f6 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004066:	85a6                	mv	a1,s1
    80004068:	854e                	mv	a0,s3
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	490080e7          	jalr	1168(ra) # 800014fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004072:	2184a703          	lw	a4,536(s1)
    80004076:	21c4a783          	lw	a5,540(s1)
    8000407a:	fcf70de3          	beq	a4,a5,80004054 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000407e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004080:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004082:	05505463          	blez	s5,800040ca <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004086:	2184a783          	lw	a5,536(s1)
    8000408a:	21c4a703          	lw	a4,540(s1)
    8000408e:	02f70e63          	beq	a4,a5,800040ca <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004092:	0017871b          	addiw	a4,a5,1
    80004096:	20e4ac23          	sw	a4,536(s1)
    8000409a:	1ff7f793          	andi	a5,a5,511
    8000409e:	97a6                	add	a5,a5,s1
    800040a0:	0187c783          	lbu	a5,24(a5)
    800040a4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040a8:	4685                	li	a3,1
    800040aa:	fbf40613          	addi	a2,s0,-65
    800040ae:	85ca                	mv	a1,s2
    800040b0:	050a3503          	ld	a0,80(s4)
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	a5e080e7          	jalr	-1442(ra) # 80000b12 <copyout>
    800040bc:	01650763          	beq	a0,s6,800040ca <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040c0:	2985                	addiw	s3,s3,1
    800040c2:	0905                	addi	s2,s2,1
    800040c4:	fd3a91e3          	bne	s5,s3,80004086 <piperead+0x70>
    800040c8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ca:	21c48513          	addi	a0,s1,540
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	490080e7          	jalr	1168(ra) # 8000155e <wakeup>
  release(&pi->lock);
    800040d6:	8526                	mv	a0,s1
    800040d8:	00002097          	auipc	ra,0x2
    800040dc:	1aa080e7          	jalr	426(ra) # 80006282 <release>
  return i;
}
    800040e0:	854e                	mv	a0,s3
    800040e2:	60a6                	ld	ra,72(sp)
    800040e4:	6406                	ld	s0,64(sp)
    800040e6:	74e2                	ld	s1,56(sp)
    800040e8:	7942                	ld	s2,48(sp)
    800040ea:	79a2                	ld	s3,40(sp)
    800040ec:	7a02                	ld	s4,32(sp)
    800040ee:	6ae2                	ld	s5,24(sp)
    800040f0:	6b42                	ld	s6,16(sp)
    800040f2:	6161                	addi	sp,sp,80
    800040f4:	8082                	ret
      release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	18a080e7          	jalr	394(ra) # 80006282 <release>
      return -1;
    80004100:	59fd                	li	s3,-1
    80004102:	bff9                	j	800040e0 <piperead+0xca>

0000000080004104 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004104:	1141                	addi	sp,sp,-16
    80004106:	e422                	sd	s0,8(sp)
    80004108:	0800                	addi	s0,sp,16
    8000410a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000410c:	8905                	andi	a0,a0,1
    8000410e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004110:	8b89                	andi	a5,a5,2
    80004112:	c399                	beqz	a5,80004118 <flags2perm+0x14>
      perm |= PTE_W;
    80004114:	00456513          	ori	a0,a0,4
    return perm;
}
    80004118:	6422                	ld	s0,8(sp)
    8000411a:	0141                	addi	sp,sp,16
    8000411c:	8082                	ret

000000008000411e <exec>:

int
exec(char *path, char **argv)
{
    8000411e:	df010113          	addi	sp,sp,-528
    80004122:	20113423          	sd	ra,520(sp)
    80004126:	20813023          	sd	s0,512(sp)
    8000412a:	ffa6                	sd	s1,504(sp)
    8000412c:	fbca                	sd	s2,496(sp)
    8000412e:	f7ce                	sd	s3,488(sp)
    80004130:	f3d2                	sd	s4,480(sp)
    80004132:	efd6                	sd	s5,472(sp)
    80004134:	ebda                	sd	s6,464(sp)
    80004136:	e7de                	sd	s7,456(sp)
    80004138:	e3e2                	sd	s8,448(sp)
    8000413a:	ff66                	sd	s9,440(sp)
    8000413c:	fb6a                	sd	s10,432(sp)
    8000413e:	f76e                	sd	s11,424(sp)
    80004140:	0c00                	addi	s0,sp,528
    80004142:	892a                	mv	s2,a0
    80004144:	dea43c23          	sd	a0,-520(s0)
    80004148:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	d06080e7          	jalr	-762(ra) # 80000e52 <myproc>
    80004154:	84aa                	mv	s1,a0

  begin_op();
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	48e080e7          	jalr	1166(ra) # 800035e4 <begin_op>

  if((ip = namei(path)) == 0){
    8000415e:	854a                	mv	a0,s2
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	284080e7          	jalr	644(ra) # 800033e4 <namei>
    80004168:	c92d                	beqz	a0,800041da <exec+0xbc>
    8000416a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	a3c080e7          	jalr	-1476(ra) # 80002ba8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004174:	04000713          	li	a4,64
    80004178:	4681                	li	a3,0
    8000417a:	e5040613          	addi	a2,s0,-432
    8000417e:	4581                	li	a1,0
    80004180:	8552                	mv	a0,s4
    80004182:	fffff097          	auipc	ra,0xfffff
    80004186:	d6e080e7          	jalr	-658(ra) # 80002ef0 <readi>
    8000418a:	04000793          	li	a5,64
    8000418e:	00f51a63          	bne	a0,a5,800041a2 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004192:	e5042703          	lw	a4,-432(s0)
    80004196:	464c47b7          	lui	a5,0x464c4
    8000419a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000419e:	04f70463          	beq	a4,a5,800041e6 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041a2:	8552                	mv	a0,s4
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	cfa080e7          	jalr	-774(ra) # 80002e9e <iunlockput>
    end_op();
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	4b2080e7          	jalr	1202(ra) # 8000365e <end_op>
  }
  return -1;
    800041b4:	557d                	li	a0,-1
}
    800041b6:	20813083          	ld	ra,520(sp)
    800041ba:	20013403          	ld	s0,512(sp)
    800041be:	74fe                	ld	s1,504(sp)
    800041c0:	795e                	ld	s2,496(sp)
    800041c2:	79be                	ld	s3,488(sp)
    800041c4:	7a1e                	ld	s4,480(sp)
    800041c6:	6afe                	ld	s5,472(sp)
    800041c8:	6b5e                	ld	s6,464(sp)
    800041ca:	6bbe                	ld	s7,456(sp)
    800041cc:	6c1e                	ld	s8,448(sp)
    800041ce:	7cfa                	ld	s9,440(sp)
    800041d0:	7d5a                	ld	s10,432(sp)
    800041d2:	7dba                	ld	s11,424(sp)
    800041d4:	21010113          	addi	sp,sp,528
    800041d8:	8082                	ret
    end_op();
    800041da:	fffff097          	auipc	ra,0xfffff
    800041de:	484080e7          	jalr	1156(ra) # 8000365e <end_op>
    return -1;
    800041e2:	557d                	li	a0,-1
    800041e4:	bfc9                	j	800041b6 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041e6:	8526                	mv	a0,s1
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	d2e080e7          	jalr	-722(ra) # 80000f16 <proc_pagetable>
    800041f0:	8b2a                	mv	s6,a0
    800041f2:	d945                	beqz	a0,800041a2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f4:	e7042d03          	lw	s10,-400(s0)
    800041f8:	e8845783          	lhu	a5,-376(s0)
    800041fc:	10078463          	beqz	a5,80004304 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004200:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004202:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004204:	6c85                	lui	s9,0x1
    80004206:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000420a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000420e:	6a85                	lui	s5,0x1
    80004210:	a0b5                	j	8000427c <exec+0x15e>
      panic("loadseg: address should exist");
    80004212:	00004517          	auipc	a0,0x4
    80004216:	43e50513          	addi	a0,a0,1086 # 80008650 <syscalls+0x280>
    8000421a:	00002097          	auipc	ra,0x2
    8000421e:	a7c080e7          	jalr	-1412(ra) # 80005c96 <panic>
    if(sz - i < PGSIZE)
    80004222:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004224:	8726                	mv	a4,s1
    80004226:	012c06bb          	addw	a3,s8,s2
    8000422a:	4581                	li	a1,0
    8000422c:	8552                	mv	a0,s4
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	cc2080e7          	jalr	-830(ra) # 80002ef0 <readi>
    80004236:	2501                	sext.w	a0,a0
    80004238:	24a49863          	bne	s1,a0,80004488 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000423c:	012a893b          	addw	s2,s5,s2
    80004240:	03397563          	bgeu	s2,s3,8000426a <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004244:	02091593          	slli	a1,s2,0x20
    80004248:	9181                	srli	a1,a1,0x20
    8000424a:	95de                	add	a1,a1,s7
    8000424c:	855a                	mv	a0,s6
    8000424e:	ffffc097          	auipc	ra,0xffffc
    80004252:	2b4080e7          	jalr	692(ra) # 80000502 <walkaddr>
    80004256:	862a                	mv	a2,a0
    if(pa == 0)
    80004258:	dd4d                	beqz	a0,80004212 <exec+0xf4>
    if(sz - i < PGSIZE)
    8000425a:	412984bb          	subw	s1,s3,s2
    8000425e:	0004879b          	sext.w	a5,s1
    80004262:	fcfcf0e3          	bgeu	s9,a5,80004222 <exec+0x104>
    80004266:	84d6                	mv	s1,s5
    80004268:	bf6d                	j	80004222 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000426a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426e:	2d85                	addiw	s11,s11,1
    80004270:	038d0d1b          	addiw	s10,s10,56
    80004274:	e8845783          	lhu	a5,-376(s0)
    80004278:	08fdd763          	bge	s11,a5,80004306 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000427c:	2d01                	sext.w	s10,s10
    8000427e:	03800713          	li	a4,56
    80004282:	86ea                	mv	a3,s10
    80004284:	e1840613          	addi	a2,s0,-488
    80004288:	4581                	li	a1,0
    8000428a:	8552                	mv	a0,s4
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	c64080e7          	jalr	-924(ra) # 80002ef0 <readi>
    80004294:	03800793          	li	a5,56
    80004298:	1ef51663          	bne	a0,a5,80004484 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000429c:	e1842783          	lw	a5,-488(s0)
    800042a0:	4705                	li	a4,1
    800042a2:	fce796e3          	bne	a5,a4,8000426e <exec+0x150>
    if(ph.memsz < ph.filesz)
    800042a6:	e4043483          	ld	s1,-448(s0)
    800042aa:	e3843783          	ld	a5,-456(s0)
    800042ae:	1ef4e863          	bltu	s1,a5,8000449e <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042b2:	e2843783          	ld	a5,-472(s0)
    800042b6:	94be                	add	s1,s1,a5
    800042b8:	1ef4e663          	bltu	s1,a5,800044a4 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800042bc:	df043703          	ld	a4,-528(s0)
    800042c0:	8ff9                	and	a5,a5,a4
    800042c2:	1e079463          	bnez	a5,800044aa <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042c6:	e1c42503          	lw	a0,-484(s0)
    800042ca:	00000097          	auipc	ra,0x0
    800042ce:	e3a080e7          	jalr	-454(ra) # 80004104 <flags2perm>
    800042d2:	86aa                	mv	a3,a0
    800042d4:	8626                	mv	a2,s1
    800042d6:	85ca                	mv	a1,s2
    800042d8:	855a                	mv	a0,s6
    800042da:	ffffc097          	auipc	ra,0xffffc
    800042de:	5dc080e7          	jalr	1500(ra) # 800008b6 <uvmalloc>
    800042e2:	e0a43423          	sd	a0,-504(s0)
    800042e6:	1c050563          	beqz	a0,800044b0 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042ea:	e2843b83          	ld	s7,-472(s0)
    800042ee:	e2042c03          	lw	s8,-480(s0)
    800042f2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042f6:	00098463          	beqz	s3,800042fe <exec+0x1e0>
    800042fa:	4901                	li	s2,0
    800042fc:	b7a1                	j	80004244 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042fe:	e0843903          	ld	s2,-504(s0)
    80004302:	b7b5                	j	8000426e <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004304:	4901                	li	s2,0
  iunlockput(ip);
    80004306:	8552                	mv	a0,s4
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	b96080e7          	jalr	-1130(ra) # 80002e9e <iunlockput>
  end_op();
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	34e080e7          	jalr	846(ra) # 8000365e <end_op>
  p = myproc();
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	b3a080e7          	jalr	-1222(ra) # 80000e52 <myproc>
    80004320:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004322:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004326:	6985                	lui	s3,0x1
    80004328:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000432a:	99ca                	add	s3,s3,s2
    8000432c:	77fd                	lui	a5,0xfffff
    8000432e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004332:	4691                	li	a3,4
    80004334:	6609                	lui	a2,0x2
    80004336:	964e                	add	a2,a2,s3
    80004338:	85ce                	mv	a1,s3
    8000433a:	855a                	mv	a0,s6
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	57a080e7          	jalr	1402(ra) # 800008b6 <uvmalloc>
    80004344:	892a                	mv	s2,a0
    80004346:	e0a43423          	sd	a0,-504(s0)
    8000434a:	e509                	bnez	a0,80004354 <exec+0x236>
  if(pagetable)
    8000434c:	e1343423          	sd	s3,-504(s0)
    80004350:	4a01                	li	s4,0
    80004352:	aa1d                	j	80004488 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004354:	75f9                	lui	a1,0xffffe
    80004356:	95aa                	add	a1,a1,a0
    80004358:	855a                	mv	a0,s6
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	786080e7          	jalr	1926(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004362:	7bfd                	lui	s7,0xfffff
    80004364:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004366:	e0043783          	ld	a5,-512(s0)
    8000436a:	6388                	ld	a0,0(a5)
    8000436c:	c52d                	beqz	a0,800043d6 <exec+0x2b8>
    8000436e:	e9040993          	addi	s3,s0,-368
    80004372:	f9040c13          	addi	s8,s0,-112
    80004376:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	f7c080e7          	jalr	-132(ra) # 800002f4 <strlen>
    80004380:	0015079b          	addiw	a5,a0,1
    80004384:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004388:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000438c:	13796563          	bltu	s2,s7,800044b6 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004390:	e0043d03          	ld	s10,-512(s0)
    80004394:	000d3a03          	ld	s4,0(s10)
    80004398:	8552                	mv	a0,s4
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	f5a080e7          	jalr	-166(ra) # 800002f4 <strlen>
    800043a2:	0015069b          	addiw	a3,a0,1
    800043a6:	8652                	mv	a2,s4
    800043a8:	85ca                	mv	a1,s2
    800043aa:	855a                	mv	a0,s6
    800043ac:	ffffc097          	auipc	ra,0xffffc
    800043b0:	766080e7          	jalr	1894(ra) # 80000b12 <copyout>
    800043b4:	10054363          	bltz	a0,800044ba <exec+0x39c>
    ustack[argc] = sp;
    800043b8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043bc:	0485                	addi	s1,s1,1
    800043be:	008d0793          	addi	a5,s10,8
    800043c2:	e0f43023          	sd	a5,-512(s0)
    800043c6:	008d3503          	ld	a0,8(s10)
    800043ca:	c909                	beqz	a0,800043dc <exec+0x2be>
    if(argc >= MAXARG)
    800043cc:	09a1                	addi	s3,s3,8
    800043ce:	fb8995e3          	bne	s3,s8,80004378 <exec+0x25a>
  ip = 0;
    800043d2:	4a01                	li	s4,0
    800043d4:	a855                	j	80004488 <exec+0x36a>
  sp = sz;
    800043d6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043da:	4481                	li	s1,0
  ustack[argc] = 0;
    800043dc:	00349793          	slli	a5,s1,0x3
    800043e0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffe1e30>
    800043e4:	97a2                	add	a5,a5,s0
    800043e6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043ea:	00148693          	addi	a3,s1,1
    800043ee:	068e                	slli	a3,a3,0x3
    800043f0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043f4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800043f8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043fc:	f57968e3          	bltu	s2,s7,8000434c <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004400:	e9040613          	addi	a2,s0,-368
    80004404:	85ca                	mv	a1,s2
    80004406:	855a                	mv	a0,s6
    80004408:	ffffc097          	auipc	ra,0xffffc
    8000440c:	70a080e7          	jalr	1802(ra) # 80000b12 <copyout>
    80004410:	0a054763          	bltz	a0,800044be <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004414:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004418:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000441c:	df843783          	ld	a5,-520(s0)
    80004420:	0007c703          	lbu	a4,0(a5)
    80004424:	cf11                	beqz	a4,80004440 <exec+0x322>
    80004426:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004428:	02f00693          	li	a3,47
    8000442c:	a039                	j	8000443a <exec+0x31c>
      last = s+1;
    8000442e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004432:	0785                	addi	a5,a5,1
    80004434:	fff7c703          	lbu	a4,-1(a5)
    80004438:	c701                	beqz	a4,80004440 <exec+0x322>
    if(*s == '/')
    8000443a:	fed71ce3          	bne	a4,a3,80004432 <exec+0x314>
    8000443e:	bfc5                	j	8000442e <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004440:	4641                	li	a2,16
    80004442:	df843583          	ld	a1,-520(s0)
    80004446:	158a8513          	addi	a0,s5,344
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	e78080e7          	jalr	-392(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004452:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004456:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000445a:	e0843783          	ld	a5,-504(s0)
    8000445e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004462:	058ab783          	ld	a5,88(s5)
    80004466:	e6843703          	ld	a4,-408(s0)
    8000446a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000446c:	058ab783          	ld	a5,88(s5)
    80004470:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004474:	85e6                	mv	a1,s9
    80004476:	ffffd097          	auipc	ra,0xffffd
    8000447a:	b3c080e7          	jalr	-1220(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000447e:	0004851b          	sext.w	a0,s1
    80004482:	bb15                	j	800041b6 <exec+0x98>
    80004484:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004488:	e0843583          	ld	a1,-504(s0)
    8000448c:	855a                	mv	a0,s6
    8000448e:	ffffd097          	auipc	ra,0xffffd
    80004492:	b24080e7          	jalr	-1244(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    80004496:	557d                	li	a0,-1
  if(ip){
    80004498:	d00a0fe3          	beqz	s4,800041b6 <exec+0x98>
    8000449c:	b319                	j	800041a2 <exec+0x84>
    8000449e:	e1243423          	sd	s2,-504(s0)
    800044a2:	b7dd                	j	80004488 <exec+0x36a>
    800044a4:	e1243423          	sd	s2,-504(s0)
    800044a8:	b7c5                	j	80004488 <exec+0x36a>
    800044aa:	e1243423          	sd	s2,-504(s0)
    800044ae:	bfe9                	j	80004488 <exec+0x36a>
    800044b0:	e1243423          	sd	s2,-504(s0)
    800044b4:	bfd1                	j	80004488 <exec+0x36a>
  ip = 0;
    800044b6:	4a01                	li	s4,0
    800044b8:	bfc1                	j	80004488 <exec+0x36a>
    800044ba:	4a01                	li	s4,0
  if(pagetable)
    800044bc:	b7f1                	j	80004488 <exec+0x36a>
  sz = sz1;
    800044be:	e0843983          	ld	s3,-504(s0)
    800044c2:	b569                	j	8000434c <exec+0x22e>

00000000800044c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044c4:	7179                	addi	sp,sp,-48
    800044c6:	f406                	sd	ra,40(sp)
    800044c8:	f022                	sd	s0,32(sp)
    800044ca:	ec26                	sd	s1,24(sp)
    800044cc:	e84a                	sd	s2,16(sp)
    800044ce:	1800                	addi	s0,sp,48
    800044d0:	892e                	mv	s2,a1
    800044d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044d4:	fdc40593          	addi	a1,s0,-36
    800044d8:	ffffe097          	auipc	ra,0xffffe
    800044dc:	a8e080e7          	jalr	-1394(ra) # 80001f66 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044e0:	fdc42703          	lw	a4,-36(s0)
    800044e4:	47bd                	li	a5,15
    800044e6:	02e7eb63          	bltu	a5,a4,8000451c <argfd+0x58>
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	968080e7          	jalr	-1688(ra) # 80000e52 <myproc>
    800044f2:	fdc42703          	lw	a4,-36(s0)
    800044f6:	01a70793          	addi	a5,a4,26
    800044fa:	078e                	slli	a5,a5,0x3
    800044fc:	953e                	add	a0,a0,a5
    800044fe:	611c                	ld	a5,0(a0)
    80004500:	c385                	beqz	a5,80004520 <argfd+0x5c>
    return -1;
  if(pfd)
    80004502:	00090463          	beqz	s2,8000450a <argfd+0x46>
    *pfd = fd;
    80004506:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000450a:	4501                	li	a0,0
  if(pf)
    8000450c:	c091                	beqz	s1,80004510 <argfd+0x4c>
    *pf = f;
    8000450e:	e09c                	sd	a5,0(s1)
}
    80004510:	70a2                	ld	ra,40(sp)
    80004512:	7402                	ld	s0,32(sp)
    80004514:	64e2                	ld	s1,24(sp)
    80004516:	6942                	ld	s2,16(sp)
    80004518:	6145                	addi	sp,sp,48
    8000451a:	8082                	ret
    return -1;
    8000451c:	557d                	li	a0,-1
    8000451e:	bfcd                	j	80004510 <argfd+0x4c>
    80004520:	557d                	li	a0,-1
    80004522:	b7fd                	j	80004510 <argfd+0x4c>

0000000080004524 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004524:	1101                	addi	sp,sp,-32
    80004526:	ec06                	sd	ra,24(sp)
    80004528:	e822                	sd	s0,16(sp)
    8000452a:	e426                	sd	s1,8(sp)
    8000452c:	1000                	addi	s0,sp,32
    8000452e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004530:	ffffd097          	auipc	ra,0xffffd
    80004534:	922080e7          	jalr	-1758(ra) # 80000e52 <myproc>
    80004538:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000453a:	0d050793          	addi	a5,a0,208
    8000453e:	4501                	li	a0,0
    80004540:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004542:	6398                	ld	a4,0(a5)
    80004544:	cb19                	beqz	a4,8000455a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004546:	2505                	addiw	a0,a0,1
    80004548:	07a1                	addi	a5,a5,8
    8000454a:	fed51ce3          	bne	a0,a3,80004542 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000454e:	557d                	li	a0,-1
}
    80004550:	60e2                	ld	ra,24(sp)
    80004552:	6442                	ld	s0,16(sp)
    80004554:	64a2                	ld	s1,8(sp)
    80004556:	6105                	addi	sp,sp,32
    80004558:	8082                	ret
      p->ofile[fd] = f;
    8000455a:	01a50793          	addi	a5,a0,26
    8000455e:	078e                	slli	a5,a5,0x3
    80004560:	963e                	add	a2,a2,a5
    80004562:	e204                	sd	s1,0(a2)
      return fd;
    80004564:	b7f5                	j	80004550 <fdalloc+0x2c>

0000000080004566 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004566:	715d                	addi	sp,sp,-80
    80004568:	e486                	sd	ra,72(sp)
    8000456a:	e0a2                	sd	s0,64(sp)
    8000456c:	fc26                	sd	s1,56(sp)
    8000456e:	f84a                	sd	s2,48(sp)
    80004570:	f44e                	sd	s3,40(sp)
    80004572:	f052                	sd	s4,32(sp)
    80004574:	ec56                	sd	s5,24(sp)
    80004576:	e85a                	sd	s6,16(sp)
    80004578:	0880                	addi	s0,sp,80
    8000457a:	8b2e                	mv	s6,a1
    8000457c:	89b2                	mv	s3,a2
    8000457e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004580:	fb040593          	addi	a1,s0,-80
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	e7e080e7          	jalr	-386(ra) # 80003402 <nameiparent>
    8000458c:	84aa                	mv	s1,a0
    8000458e:	14050b63          	beqz	a0,800046e4 <create+0x17e>
    return 0;

  ilock(dp);
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	616080e7          	jalr	1558(ra) # 80002ba8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000459a:	4601                	li	a2,0
    8000459c:	fb040593          	addi	a1,s0,-80
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	b80080e7          	jalr	-1152(ra) # 80003122 <dirlookup>
    800045aa:	8aaa                	mv	s5,a0
    800045ac:	c921                	beqz	a0,800045fc <create+0x96>
    iunlockput(dp);
    800045ae:	8526                	mv	a0,s1
    800045b0:	fffff097          	auipc	ra,0xfffff
    800045b4:	8ee080e7          	jalr	-1810(ra) # 80002e9e <iunlockput>
    ilock(ip);
    800045b8:	8556                	mv	a0,s5
    800045ba:	ffffe097          	auipc	ra,0xffffe
    800045be:	5ee080e7          	jalr	1518(ra) # 80002ba8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045c2:	4789                	li	a5,2
    800045c4:	02fb1563          	bne	s6,a5,800045ee <create+0x88>
    800045c8:	044ad783          	lhu	a5,68(s5)
    800045cc:	37f9                	addiw	a5,a5,-2
    800045ce:	17c2                	slli	a5,a5,0x30
    800045d0:	93c1                	srli	a5,a5,0x30
    800045d2:	4705                	li	a4,1
    800045d4:	00f76d63          	bltu	a4,a5,800045ee <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045d8:	8556                	mv	a0,s5
    800045da:	60a6                	ld	ra,72(sp)
    800045dc:	6406                	ld	s0,64(sp)
    800045de:	74e2                	ld	s1,56(sp)
    800045e0:	7942                	ld	s2,48(sp)
    800045e2:	79a2                	ld	s3,40(sp)
    800045e4:	7a02                	ld	s4,32(sp)
    800045e6:	6ae2                	ld	s5,24(sp)
    800045e8:	6b42                	ld	s6,16(sp)
    800045ea:	6161                	addi	sp,sp,80
    800045ec:	8082                	ret
    iunlockput(ip);
    800045ee:	8556                	mv	a0,s5
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	8ae080e7          	jalr	-1874(ra) # 80002e9e <iunlockput>
    return 0;
    800045f8:	4a81                	li	s5,0
    800045fa:	bff9                	j	800045d8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045fc:	85da                	mv	a1,s6
    800045fe:	4088                	lw	a0,0(s1)
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	410080e7          	jalr	1040(ra) # 80002a10 <ialloc>
    80004608:	8a2a                	mv	s4,a0
    8000460a:	c529                	beqz	a0,80004654 <create+0xee>
  ilock(ip);
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	59c080e7          	jalr	1436(ra) # 80002ba8 <ilock>
  ip->major = major;
    80004614:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004618:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000461c:	4905                	li	s2,1
    8000461e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004622:	8552                	mv	a0,s4
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	4b8080e7          	jalr	1208(ra) # 80002adc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000462c:	032b0b63          	beq	s6,s2,80004662 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004630:	004a2603          	lw	a2,4(s4)
    80004634:	fb040593          	addi	a1,s0,-80
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	cf8080e7          	jalr	-776(ra) # 80003332 <dirlink>
    80004642:	06054f63          	bltz	a0,800046c0 <create+0x15a>
  iunlockput(dp);
    80004646:	8526                	mv	a0,s1
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	856080e7          	jalr	-1962(ra) # 80002e9e <iunlockput>
  return ip;
    80004650:	8ad2                	mv	s5,s4
    80004652:	b759                	j	800045d8 <create+0x72>
    iunlockput(dp);
    80004654:	8526                	mv	a0,s1
    80004656:	fffff097          	auipc	ra,0xfffff
    8000465a:	848080e7          	jalr	-1976(ra) # 80002e9e <iunlockput>
    return 0;
    8000465e:	8ad2                	mv	s5,s4
    80004660:	bfa5                	j	800045d8 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004662:	004a2603          	lw	a2,4(s4)
    80004666:	00004597          	auipc	a1,0x4
    8000466a:	00a58593          	addi	a1,a1,10 # 80008670 <syscalls+0x2a0>
    8000466e:	8552                	mv	a0,s4
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	cc2080e7          	jalr	-830(ra) # 80003332 <dirlink>
    80004678:	04054463          	bltz	a0,800046c0 <create+0x15a>
    8000467c:	40d0                	lw	a2,4(s1)
    8000467e:	00004597          	auipc	a1,0x4
    80004682:	ffa58593          	addi	a1,a1,-6 # 80008678 <syscalls+0x2a8>
    80004686:	8552                	mv	a0,s4
    80004688:	fffff097          	auipc	ra,0xfffff
    8000468c:	caa080e7          	jalr	-854(ra) # 80003332 <dirlink>
    80004690:	02054863          	bltz	a0,800046c0 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004694:	004a2603          	lw	a2,4(s4)
    80004698:	fb040593          	addi	a1,s0,-80
    8000469c:	8526                	mv	a0,s1
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	c94080e7          	jalr	-876(ra) # 80003332 <dirlink>
    800046a6:	00054d63          	bltz	a0,800046c0 <create+0x15a>
    dp->nlink++;  // for ".."
    800046aa:	04a4d783          	lhu	a5,74(s1)
    800046ae:	2785                	addiw	a5,a5,1
    800046b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046b4:	8526                	mv	a0,s1
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	426080e7          	jalr	1062(ra) # 80002adc <iupdate>
    800046be:	b761                	j	80004646 <create+0xe0>
  ip->nlink = 0;
    800046c0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046c4:	8552                	mv	a0,s4
    800046c6:	ffffe097          	auipc	ra,0xffffe
    800046ca:	416080e7          	jalr	1046(ra) # 80002adc <iupdate>
  iunlockput(ip);
    800046ce:	8552                	mv	a0,s4
    800046d0:	ffffe097          	auipc	ra,0xffffe
    800046d4:	7ce080e7          	jalr	1998(ra) # 80002e9e <iunlockput>
  iunlockput(dp);
    800046d8:	8526                	mv	a0,s1
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	7c4080e7          	jalr	1988(ra) # 80002e9e <iunlockput>
  return 0;
    800046e2:	bddd                	j	800045d8 <create+0x72>
    return 0;
    800046e4:	8aaa                	mv	s5,a0
    800046e6:	bdcd                	j	800045d8 <create+0x72>

00000000800046e8 <sys_dup>:
{
    800046e8:	7179                	addi	sp,sp,-48
    800046ea:	f406                	sd	ra,40(sp)
    800046ec:	f022                	sd	s0,32(sp)
    800046ee:	ec26                	sd	s1,24(sp)
    800046f0:	e84a                	sd	s2,16(sp)
    800046f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046f4:	fd840613          	addi	a2,s0,-40
    800046f8:	4581                	li	a1,0
    800046fa:	4501                	li	a0,0
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	dc8080e7          	jalr	-568(ra) # 800044c4 <argfd>
    return -1;
    80004704:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004706:	02054363          	bltz	a0,8000472c <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000470a:	fd843903          	ld	s2,-40(s0)
    8000470e:	854a                	mv	a0,s2
    80004710:	00000097          	auipc	ra,0x0
    80004714:	e14080e7          	jalr	-492(ra) # 80004524 <fdalloc>
    80004718:	84aa                	mv	s1,a0
    return -1;
    8000471a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000471c:	00054863          	bltz	a0,8000472c <sys_dup+0x44>
  filedup(f);
    80004720:	854a                	mv	a0,s2
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	334080e7          	jalr	820(ra) # 80003a56 <filedup>
  return fd;
    8000472a:	87a6                	mv	a5,s1
}
    8000472c:	853e                	mv	a0,a5
    8000472e:	70a2                	ld	ra,40(sp)
    80004730:	7402                	ld	s0,32(sp)
    80004732:	64e2                	ld	s1,24(sp)
    80004734:	6942                	ld	s2,16(sp)
    80004736:	6145                	addi	sp,sp,48
    80004738:	8082                	ret

000000008000473a <sys_read>:
{
    8000473a:	7179                	addi	sp,sp,-48
    8000473c:	f406                	sd	ra,40(sp)
    8000473e:	f022                	sd	s0,32(sp)
    80004740:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004742:	fd840593          	addi	a1,s0,-40
    80004746:	4505                	li	a0,1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	83e080e7          	jalr	-1986(ra) # 80001f86 <argaddr>
  argint(2, &n);
    80004750:	fe440593          	addi	a1,s0,-28
    80004754:	4509                	li	a0,2
    80004756:	ffffe097          	auipc	ra,0xffffe
    8000475a:	810080e7          	jalr	-2032(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    8000475e:	fe840613          	addi	a2,s0,-24
    80004762:	4581                	li	a1,0
    80004764:	4501                	li	a0,0
    80004766:	00000097          	auipc	ra,0x0
    8000476a:	d5e080e7          	jalr	-674(ra) # 800044c4 <argfd>
    8000476e:	87aa                	mv	a5,a0
    return -1;
    80004770:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004772:	0007cc63          	bltz	a5,8000478a <sys_read+0x50>
  return fileread(f, p, n);
    80004776:	fe442603          	lw	a2,-28(s0)
    8000477a:	fd843583          	ld	a1,-40(s0)
    8000477e:	fe843503          	ld	a0,-24(s0)
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	460080e7          	jalr	1120(ra) # 80003be2 <fileread>
}
    8000478a:	70a2                	ld	ra,40(sp)
    8000478c:	7402                	ld	s0,32(sp)
    8000478e:	6145                	addi	sp,sp,48
    80004790:	8082                	ret

0000000080004792 <sys_write>:
{
    80004792:	7179                	addi	sp,sp,-48
    80004794:	f406                	sd	ra,40(sp)
    80004796:	f022                	sd	s0,32(sp)
    80004798:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000479a:	fd840593          	addi	a1,s0,-40
    8000479e:	4505                	li	a0,1
    800047a0:	ffffd097          	auipc	ra,0xffffd
    800047a4:	7e6080e7          	jalr	2022(ra) # 80001f86 <argaddr>
  argint(2, &n);
    800047a8:	fe440593          	addi	a1,s0,-28
    800047ac:	4509                	li	a0,2
    800047ae:	ffffd097          	auipc	ra,0xffffd
    800047b2:	7b8080e7          	jalr	1976(ra) # 80001f66 <argint>
  if(argfd(0, 0, &f) < 0)
    800047b6:	fe840613          	addi	a2,s0,-24
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	d06080e7          	jalr	-762(ra) # 800044c4 <argfd>
    800047c6:	87aa                	mv	a5,a0
    return -1;
    800047c8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047ca:	0007cc63          	bltz	a5,800047e2 <sys_write+0x50>
  return filewrite(f, p, n);
    800047ce:	fe442603          	lw	a2,-28(s0)
    800047d2:	fd843583          	ld	a1,-40(s0)
    800047d6:	fe843503          	ld	a0,-24(s0)
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	4ca080e7          	jalr	1226(ra) # 80003ca4 <filewrite>
}
    800047e2:	70a2                	ld	ra,40(sp)
    800047e4:	7402                	ld	s0,32(sp)
    800047e6:	6145                	addi	sp,sp,48
    800047e8:	8082                	ret

00000000800047ea <sys_close>:
{
    800047ea:	1101                	addi	sp,sp,-32
    800047ec:	ec06                	sd	ra,24(sp)
    800047ee:	e822                	sd	s0,16(sp)
    800047f0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047f2:	fe040613          	addi	a2,s0,-32
    800047f6:	fec40593          	addi	a1,s0,-20
    800047fa:	4501                	li	a0,0
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	cc8080e7          	jalr	-824(ra) # 800044c4 <argfd>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004806:	02054463          	bltz	a0,8000482e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000480a:	ffffc097          	auipc	ra,0xffffc
    8000480e:	648080e7          	jalr	1608(ra) # 80000e52 <myproc>
    80004812:	fec42783          	lw	a5,-20(s0)
    80004816:	07e9                	addi	a5,a5,26
    80004818:	078e                	slli	a5,a5,0x3
    8000481a:	953e                	add	a0,a0,a5
    8000481c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004820:	fe043503          	ld	a0,-32(s0)
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	284080e7          	jalr	644(ra) # 80003aa8 <fileclose>
  return 0;
    8000482c:	4781                	li	a5,0
}
    8000482e:	853e                	mv	a0,a5
    80004830:	60e2                	ld	ra,24(sp)
    80004832:	6442                	ld	s0,16(sp)
    80004834:	6105                	addi	sp,sp,32
    80004836:	8082                	ret

0000000080004838 <sys_fstat>:
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004840:	fe040593          	addi	a1,s0,-32
    80004844:	4505                	li	a0,1
    80004846:	ffffd097          	auipc	ra,0xffffd
    8000484a:	740080e7          	jalr	1856(ra) # 80001f86 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000484e:	fe840613          	addi	a2,s0,-24
    80004852:	4581                	li	a1,0
    80004854:	4501                	li	a0,0
    80004856:	00000097          	auipc	ra,0x0
    8000485a:	c6e080e7          	jalr	-914(ra) # 800044c4 <argfd>
    8000485e:	87aa                	mv	a5,a0
    return -1;
    80004860:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004862:	0007ca63          	bltz	a5,80004876 <sys_fstat+0x3e>
  return filestat(f, st);
    80004866:	fe043583          	ld	a1,-32(s0)
    8000486a:	fe843503          	ld	a0,-24(s0)
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	302080e7          	jalr	770(ra) # 80003b70 <filestat>
}
    80004876:	60e2                	ld	ra,24(sp)
    80004878:	6442                	ld	s0,16(sp)
    8000487a:	6105                	addi	sp,sp,32
    8000487c:	8082                	ret

000000008000487e <sys_link>:
{
    8000487e:	7169                	addi	sp,sp,-304
    80004880:	f606                	sd	ra,296(sp)
    80004882:	f222                	sd	s0,288(sp)
    80004884:	ee26                	sd	s1,280(sp)
    80004886:	ea4a                	sd	s2,272(sp)
    80004888:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488a:	08000613          	li	a2,128
    8000488e:	ed040593          	addi	a1,s0,-304
    80004892:	4501                	li	a0,0
    80004894:	ffffd097          	auipc	ra,0xffffd
    80004898:	712080e7          	jalr	1810(ra) # 80001fa6 <argstr>
    return -1;
    8000489c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000489e:	10054e63          	bltz	a0,800049ba <sys_link+0x13c>
    800048a2:	08000613          	li	a2,128
    800048a6:	f5040593          	addi	a1,s0,-176
    800048aa:	4505                	li	a0,1
    800048ac:	ffffd097          	auipc	ra,0xffffd
    800048b0:	6fa080e7          	jalr	1786(ra) # 80001fa6 <argstr>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b6:	10054263          	bltz	a0,800049ba <sys_link+0x13c>
  begin_op();
    800048ba:	fffff097          	auipc	ra,0xfffff
    800048be:	d2a080e7          	jalr	-726(ra) # 800035e4 <begin_op>
  if((ip = namei(old)) == 0){
    800048c2:	ed040513          	addi	a0,s0,-304
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	b1e080e7          	jalr	-1250(ra) # 800033e4 <namei>
    800048ce:	84aa                	mv	s1,a0
    800048d0:	c551                	beqz	a0,8000495c <sys_link+0xde>
  ilock(ip);
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	2d6080e7          	jalr	726(ra) # 80002ba8 <ilock>
  if(ip->type == T_DIR){
    800048da:	04449703          	lh	a4,68(s1)
    800048de:	4785                	li	a5,1
    800048e0:	08f70463          	beq	a4,a5,80004968 <sys_link+0xea>
  ip->nlink++;
    800048e4:	04a4d783          	lhu	a5,74(s1)
    800048e8:	2785                	addiw	a5,a5,1
    800048ea:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ee:	8526                	mv	a0,s1
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	1ec080e7          	jalr	492(ra) # 80002adc <iupdate>
  iunlock(ip);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	370080e7          	jalr	880(ra) # 80002c6a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004902:	fd040593          	addi	a1,s0,-48
    80004906:	f5040513          	addi	a0,s0,-176
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	af8080e7          	jalr	-1288(ra) # 80003402 <nameiparent>
    80004912:	892a                	mv	s2,a0
    80004914:	c935                	beqz	a0,80004988 <sys_link+0x10a>
  ilock(dp);
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	292080e7          	jalr	658(ra) # 80002ba8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000491e:	00092703          	lw	a4,0(s2)
    80004922:	409c                	lw	a5,0(s1)
    80004924:	04f71d63          	bne	a4,a5,8000497e <sys_link+0x100>
    80004928:	40d0                	lw	a2,4(s1)
    8000492a:	fd040593          	addi	a1,s0,-48
    8000492e:	854a                	mv	a0,s2
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	a02080e7          	jalr	-1534(ra) # 80003332 <dirlink>
    80004938:	04054363          	bltz	a0,8000497e <sys_link+0x100>
  iunlockput(dp);
    8000493c:	854a                	mv	a0,s2
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	560080e7          	jalr	1376(ra) # 80002e9e <iunlockput>
  iput(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	4ae080e7          	jalr	1198(ra) # 80002df6 <iput>
  end_op();
    80004950:	fffff097          	auipc	ra,0xfffff
    80004954:	d0e080e7          	jalr	-754(ra) # 8000365e <end_op>
  return 0;
    80004958:	4781                	li	a5,0
    8000495a:	a085                	j	800049ba <sys_link+0x13c>
    end_op();
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	d02080e7          	jalr	-766(ra) # 8000365e <end_op>
    return -1;
    80004964:	57fd                	li	a5,-1
    80004966:	a891                	j	800049ba <sys_link+0x13c>
    iunlockput(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	534080e7          	jalr	1332(ra) # 80002e9e <iunlockput>
    end_op();
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	cec080e7          	jalr	-788(ra) # 8000365e <end_op>
    return -1;
    8000497a:	57fd                	li	a5,-1
    8000497c:	a83d                	j	800049ba <sys_link+0x13c>
    iunlockput(dp);
    8000497e:	854a                	mv	a0,s2
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	51e080e7          	jalr	1310(ra) # 80002e9e <iunlockput>
  ilock(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	21e080e7          	jalr	542(ra) # 80002ba8 <ilock>
  ip->nlink--;
    80004992:	04a4d783          	lhu	a5,74(s1)
    80004996:	37fd                	addiw	a5,a5,-1
    80004998:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	13e080e7          	jalr	318(ra) # 80002adc <iupdate>
  iunlockput(ip);
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	4f6080e7          	jalr	1270(ra) # 80002e9e <iunlockput>
  end_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	cae080e7          	jalr	-850(ra) # 8000365e <end_op>
  return -1;
    800049b8:	57fd                	li	a5,-1
}
    800049ba:	853e                	mv	a0,a5
    800049bc:	70b2                	ld	ra,296(sp)
    800049be:	7412                	ld	s0,288(sp)
    800049c0:	64f2                	ld	s1,280(sp)
    800049c2:	6952                	ld	s2,272(sp)
    800049c4:	6155                	addi	sp,sp,304
    800049c6:	8082                	ret

00000000800049c8 <sys_unlink>:
{
    800049c8:	7151                	addi	sp,sp,-240
    800049ca:	f586                	sd	ra,232(sp)
    800049cc:	f1a2                	sd	s0,224(sp)
    800049ce:	eda6                	sd	s1,216(sp)
    800049d0:	e9ca                	sd	s2,208(sp)
    800049d2:	e5ce                	sd	s3,200(sp)
    800049d4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049d6:	08000613          	li	a2,128
    800049da:	f3040593          	addi	a1,s0,-208
    800049de:	4501                	li	a0,0
    800049e0:	ffffd097          	auipc	ra,0xffffd
    800049e4:	5c6080e7          	jalr	1478(ra) # 80001fa6 <argstr>
    800049e8:	18054163          	bltz	a0,80004b6a <sys_unlink+0x1a2>
  begin_op();
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	bf8080e7          	jalr	-1032(ra) # 800035e4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049f4:	fb040593          	addi	a1,s0,-80
    800049f8:	f3040513          	addi	a0,s0,-208
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	a06080e7          	jalr	-1530(ra) # 80003402 <nameiparent>
    80004a04:	84aa                	mv	s1,a0
    80004a06:	c979                	beqz	a0,80004adc <sys_unlink+0x114>
  ilock(dp);
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	1a0080e7          	jalr	416(ra) # 80002ba8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a10:	00004597          	auipc	a1,0x4
    80004a14:	c6058593          	addi	a1,a1,-928 # 80008670 <syscalls+0x2a0>
    80004a18:	fb040513          	addi	a0,s0,-80
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	6ec080e7          	jalr	1772(ra) # 80003108 <namecmp>
    80004a24:	14050a63          	beqz	a0,80004b78 <sys_unlink+0x1b0>
    80004a28:	00004597          	auipc	a1,0x4
    80004a2c:	c5058593          	addi	a1,a1,-944 # 80008678 <syscalls+0x2a8>
    80004a30:	fb040513          	addi	a0,s0,-80
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	6d4080e7          	jalr	1748(ra) # 80003108 <namecmp>
    80004a3c:	12050e63          	beqz	a0,80004b78 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a40:	f2c40613          	addi	a2,s0,-212
    80004a44:	fb040593          	addi	a1,s0,-80
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	6d8080e7          	jalr	1752(ra) # 80003122 <dirlookup>
    80004a52:	892a                	mv	s2,a0
    80004a54:	12050263          	beqz	a0,80004b78 <sys_unlink+0x1b0>
  ilock(ip);
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	150080e7          	jalr	336(ra) # 80002ba8 <ilock>
  if(ip->nlink < 1)
    80004a60:	04a91783          	lh	a5,74(s2)
    80004a64:	08f05263          	blez	a5,80004ae8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a68:	04491703          	lh	a4,68(s2)
    80004a6c:	4785                	li	a5,1
    80004a6e:	08f70563          	beq	a4,a5,80004af8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a72:	4641                	li	a2,16
    80004a74:	4581                	li	a1,0
    80004a76:	fc040513          	addi	a0,s0,-64
    80004a7a:	ffffb097          	auipc	ra,0xffffb
    80004a7e:	700080e7          	jalr	1792(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a82:	4741                	li	a4,16
    80004a84:	f2c42683          	lw	a3,-212(s0)
    80004a88:	fc040613          	addi	a2,s0,-64
    80004a8c:	4581                	li	a1,0
    80004a8e:	8526                	mv	a0,s1
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	558080e7          	jalr	1368(ra) # 80002fe8 <writei>
    80004a98:	47c1                	li	a5,16
    80004a9a:	0af51563          	bne	a0,a5,80004b44 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a9e:	04491703          	lh	a4,68(s2)
    80004aa2:	4785                	li	a5,1
    80004aa4:	0af70863          	beq	a4,a5,80004b54 <sys_unlink+0x18c>
  iunlockput(dp);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	3f4080e7          	jalr	1012(ra) # 80002e9e <iunlockput>
  ip->nlink--;
    80004ab2:	04a95783          	lhu	a5,74(s2)
    80004ab6:	37fd                	addiw	a5,a5,-1
    80004ab8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	01e080e7          	jalr	30(ra) # 80002adc <iupdate>
  iunlockput(ip);
    80004ac6:	854a                	mv	a0,s2
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	3d6080e7          	jalr	982(ra) # 80002e9e <iunlockput>
  end_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	b8e080e7          	jalr	-1138(ra) # 8000365e <end_op>
  return 0;
    80004ad8:	4501                	li	a0,0
    80004ada:	a84d                	j	80004b8c <sys_unlink+0x1c4>
    end_op();
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	b82080e7          	jalr	-1150(ra) # 8000365e <end_op>
    return -1;
    80004ae4:	557d                	li	a0,-1
    80004ae6:	a05d                	j	80004b8c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ae8:	00004517          	auipc	a0,0x4
    80004aec:	b9850513          	addi	a0,a0,-1128 # 80008680 <syscalls+0x2b0>
    80004af0:	00001097          	auipc	ra,0x1
    80004af4:	1a6080e7          	jalr	422(ra) # 80005c96 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004af8:	04c92703          	lw	a4,76(s2)
    80004afc:	02000793          	li	a5,32
    80004b00:	f6e7f9e3          	bgeu	a5,a4,80004a72 <sys_unlink+0xaa>
    80004b04:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b08:	4741                	li	a4,16
    80004b0a:	86ce                	mv	a3,s3
    80004b0c:	f1840613          	addi	a2,s0,-232
    80004b10:	4581                	li	a1,0
    80004b12:	854a                	mv	a0,s2
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	3dc080e7          	jalr	988(ra) # 80002ef0 <readi>
    80004b1c:	47c1                	li	a5,16
    80004b1e:	00f51b63          	bne	a0,a5,80004b34 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b22:	f1845783          	lhu	a5,-232(s0)
    80004b26:	e7a1                	bnez	a5,80004b6e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b28:	29c1                	addiw	s3,s3,16
    80004b2a:	04c92783          	lw	a5,76(s2)
    80004b2e:	fcf9ede3          	bltu	s3,a5,80004b08 <sys_unlink+0x140>
    80004b32:	b781                	j	80004a72 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b34:	00004517          	auipc	a0,0x4
    80004b38:	b6450513          	addi	a0,a0,-1180 # 80008698 <syscalls+0x2c8>
    80004b3c:	00001097          	auipc	ra,0x1
    80004b40:	15a080e7          	jalr	346(ra) # 80005c96 <panic>
    panic("unlink: writei");
    80004b44:	00004517          	auipc	a0,0x4
    80004b48:	b6c50513          	addi	a0,a0,-1172 # 800086b0 <syscalls+0x2e0>
    80004b4c:	00001097          	auipc	ra,0x1
    80004b50:	14a080e7          	jalr	330(ra) # 80005c96 <panic>
    dp->nlink--;
    80004b54:	04a4d783          	lhu	a5,74(s1)
    80004b58:	37fd                	addiw	a5,a5,-1
    80004b5a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	f7c080e7          	jalr	-132(ra) # 80002adc <iupdate>
    80004b68:	b781                	j	80004aa8 <sys_unlink+0xe0>
    return -1;
    80004b6a:	557d                	li	a0,-1
    80004b6c:	a005                	j	80004b8c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b6e:	854a                	mv	a0,s2
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	32e080e7          	jalr	814(ra) # 80002e9e <iunlockput>
  iunlockput(dp);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	324080e7          	jalr	804(ra) # 80002e9e <iunlockput>
  end_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	adc080e7          	jalr	-1316(ra) # 8000365e <end_op>
  return -1;
    80004b8a:	557d                	li	a0,-1
}
    80004b8c:	70ae                	ld	ra,232(sp)
    80004b8e:	740e                	ld	s0,224(sp)
    80004b90:	64ee                	ld	s1,216(sp)
    80004b92:	694e                	ld	s2,208(sp)
    80004b94:	69ae                	ld	s3,200(sp)
    80004b96:	616d                	addi	sp,sp,240
    80004b98:	8082                	ret

0000000080004b9a <sys_open>:

uint64
sys_open(void)
{
    80004b9a:	7131                	addi	sp,sp,-192
    80004b9c:	fd06                	sd	ra,184(sp)
    80004b9e:	f922                	sd	s0,176(sp)
    80004ba0:	f526                	sd	s1,168(sp)
    80004ba2:	f14a                	sd	s2,160(sp)
    80004ba4:	ed4e                	sd	s3,152(sp)
    80004ba6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ba8:	f4c40593          	addi	a1,s0,-180
    80004bac:	4505                	li	a0,1
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	3b8080e7          	jalr	952(ra) # 80001f66 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bb6:	08000613          	li	a2,128
    80004bba:	f5040593          	addi	a1,s0,-176
    80004bbe:	4501                	li	a0,0
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	3e6080e7          	jalr	998(ra) # 80001fa6 <argstr>
    80004bc8:	87aa                	mv	a5,a0
    return -1;
    80004bca:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bcc:	0a07c863          	bltz	a5,80004c7c <sys_open+0xe2>

  begin_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	a14080e7          	jalr	-1516(ra) # 800035e4 <begin_op>

  if(omode & O_CREATE){
    80004bd8:	f4c42783          	lw	a5,-180(s0)
    80004bdc:	2007f793          	andi	a5,a5,512
    80004be0:	cbdd                	beqz	a5,80004c96 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004be2:	4681                	li	a3,0
    80004be4:	4601                	li	a2,0
    80004be6:	4589                	li	a1,2
    80004be8:	f5040513          	addi	a0,s0,-176
    80004bec:	00000097          	auipc	ra,0x0
    80004bf0:	97a080e7          	jalr	-1670(ra) # 80004566 <create>
    80004bf4:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bf6:	c951                	beqz	a0,80004c8a <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bf8:	04449703          	lh	a4,68(s1)
    80004bfc:	478d                	li	a5,3
    80004bfe:	00f71763          	bne	a4,a5,80004c0c <sys_open+0x72>
    80004c02:	0464d703          	lhu	a4,70(s1)
    80004c06:	47a5                	li	a5,9
    80004c08:	0ce7ec63          	bltu	a5,a4,80004ce0 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	de0080e7          	jalr	-544(ra) # 800039ec <filealloc>
    80004c14:	892a                	mv	s2,a0
    80004c16:	c56d                	beqz	a0,80004d00 <sys_open+0x166>
    80004c18:	00000097          	auipc	ra,0x0
    80004c1c:	90c080e7          	jalr	-1780(ra) # 80004524 <fdalloc>
    80004c20:	89aa                	mv	s3,a0
    80004c22:	0c054a63          	bltz	a0,80004cf6 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c26:	04449703          	lh	a4,68(s1)
    80004c2a:	478d                	li	a5,3
    80004c2c:	0ef70563          	beq	a4,a5,80004d16 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c30:	4789                	li	a5,2
    80004c32:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c36:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c3a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c3e:	f4c42783          	lw	a5,-180(s0)
    80004c42:	0017c713          	xori	a4,a5,1
    80004c46:	8b05                	andi	a4,a4,1
    80004c48:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c4c:	0037f713          	andi	a4,a5,3
    80004c50:	00e03733          	snez	a4,a4
    80004c54:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c58:	4007f793          	andi	a5,a5,1024
    80004c5c:	c791                	beqz	a5,80004c68 <sys_open+0xce>
    80004c5e:	04449703          	lh	a4,68(s1)
    80004c62:	4789                	li	a5,2
    80004c64:	0cf70063          	beq	a4,a5,80004d24 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c68:	8526                	mv	a0,s1
    80004c6a:	ffffe097          	auipc	ra,0xffffe
    80004c6e:	000080e7          	jalr	ra # 80002c6a <iunlock>
  end_op();
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	9ec080e7          	jalr	-1556(ra) # 8000365e <end_op>

  return fd;
    80004c7a:	854e                	mv	a0,s3
}
    80004c7c:	70ea                	ld	ra,184(sp)
    80004c7e:	744a                	ld	s0,176(sp)
    80004c80:	74aa                	ld	s1,168(sp)
    80004c82:	790a                	ld	s2,160(sp)
    80004c84:	69ea                	ld	s3,152(sp)
    80004c86:	6129                	addi	sp,sp,192
    80004c88:	8082                	ret
      end_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	9d4080e7          	jalr	-1580(ra) # 8000365e <end_op>
      return -1;
    80004c92:	557d                	li	a0,-1
    80004c94:	b7e5                	j	80004c7c <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c96:	f5040513          	addi	a0,s0,-176
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	74a080e7          	jalr	1866(ra) # 800033e4 <namei>
    80004ca2:	84aa                	mv	s1,a0
    80004ca4:	c905                	beqz	a0,80004cd4 <sys_open+0x13a>
    ilock(ip);
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	f02080e7          	jalr	-254(ra) # 80002ba8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cae:	04449703          	lh	a4,68(s1)
    80004cb2:	4785                	li	a5,1
    80004cb4:	f4f712e3          	bne	a4,a5,80004bf8 <sys_open+0x5e>
    80004cb8:	f4c42783          	lw	a5,-180(s0)
    80004cbc:	dba1                	beqz	a5,80004c0c <sys_open+0x72>
      iunlockput(ip);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	1de080e7          	jalr	478(ra) # 80002e9e <iunlockput>
      end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	996080e7          	jalr	-1642(ra) # 8000365e <end_op>
      return -1;
    80004cd0:	557d                	li	a0,-1
    80004cd2:	b76d                	j	80004c7c <sys_open+0xe2>
      end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	98a080e7          	jalr	-1654(ra) # 8000365e <end_op>
      return -1;
    80004cdc:	557d                	li	a0,-1
    80004cde:	bf79                	j	80004c7c <sys_open+0xe2>
    iunlockput(ip);
    80004ce0:	8526                	mv	a0,s1
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	1bc080e7          	jalr	444(ra) # 80002e9e <iunlockput>
    end_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	974080e7          	jalr	-1676(ra) # 8000365e <end_op>
    return -1;
    80004cf2:	557d                	li	a0,-1
    80004cf4:	b761                	j	80004c7c <sys_open+0xe2>
      fileclose(f);
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	db0080e7          	jalr	-592(ra) # 80003aa8 <fileclose>
    iunlockput(ip);
    80004d00:	8526                	mv	a0,s1
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	19c080e7          	jalr	412(ra) # 80002e9e <iunlockput>
    end_op();
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	954080e7          	jalr	-1708(ra) # 8000365e <end_op>
    return -1;
    80004d12:	557d                	li	a0,-1
    80004d14:	b7a5                	j	80004c7c <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d16:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d1a:	04649783          	lh	a5,70(s1)
    80004d1e:	02f91223          	sh	a5,36(s2)
    80004d22:	bf21                	j	80004c3a <sys_open+0xa0>
    itrunc(ip);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	f90080e7          	jalr	-112(ra) # 80002cb6 <itrunc>
    80004d2e:	bf2d                	j	80004c68 <sys_open+0xce>

0000000080004d30 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d30:	7175                	addi	sp,sp,-144
    80004d32:	e506                	sd	ra,136(sp)
    80004d34:	e122                	sd	s0,128(sp)
    80004d36:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	8ac080e7          	jalr	-1876(ra) # 800035e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d40:	08000613          	li	a2,128
    80004d44:	f7040593          	addi	a1,s0,-144
    80004d48:	4501                	li	a0,0
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	25c080e7          	jalr	604(ra) # 80001fa6 <argstr>
    80004d52:	02054963          	bltz	a0,80004d84 <sys_mkdir+0x54>
    80004d56:	4681                	li	a3,0
    80004d58:	4601                	li	a2,0
    80004d5a:	4585                	li	a1,1
    80004d5c:	f7040513          	addi	a0,s0,-144
    80004d60:	00000097          	auipc	ra,0x0
    80004d64:	806080e7          	jalr	-2042(ra) # 80004566 <create>
    80004d68:	cd11                	beqz	a0,80004d84 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	134080e7          	jalr	308(ra) # 80002e9e <iunlockput>
  end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	8ec080e7          	jalr	-1812(ra) # 8000365e <end_op>
  return 0;
    80004d7a:	4501                	li	a0,0
}
    80004d7c:	60aa                	ld	ra,136(sp)
    80004d7e:	640a                	ld	s0,128(sp)
    80004d80:	6149                	addi	sp,sp,144
    80004d82:	8082                	ret
    end_op();
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	8da080e7          	jalr	-1830(ra) # 8000365e <end_op>
    return -1;
    80004d8c:	557d                	li	a0,-1
    80004d8e:	b7fd                	j	80004d7c <sys_mkdir+0x4c>

0000000080004d90 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d90:	7135                	addi	sp,sp,-160
    80004d92:	ed06                	sd	ra,152(sp)
    80004d94:	e922                	sd	s0,144(sp)
    80004d96:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	84c080e7          	jalr	-1972(ra) # 800035e4 <begin_op>
  argint(1, &major);
    80004da0:	f6c40593          	addi	a1,s0,-148
    80004da4:	4505                	li	a0,1
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	1c0080e7          	jalr	448(ra) # 80001f66 <argint>
  argint(2, &minor);
    80004dae:	f6840593          	addi	a1,s0,-152
    80004db2:	4509                	li	a0,2
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	1b2080e7          	jalr	434(ra) # 80001f66 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dbc:	08000613          	li	a2,128
    80004dc0:	f7040593          	addi	a1,s0,-144
    80004dc4:	4501                	li	a0,0
    80004dc6:	ffffd097          	auipc	ra,0xffffd
    80004dca:	1e0080e7          	jalr	480(ra) # 80001fa6 <argstr>
    80004dce:	02054b63          	bltz	a0,80004e04 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dd2:	f6841683          	lh	a3,-152(s0)
    80004dd6:	f6c41603          	lh	a2,-148(s0)
    80004dda:	458d                	li	a1,3
    80004ddc:	f7040513          	addi	a0,s0,-144
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	786080e7          	jalr	1926(ra) # 80004566 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004de8:	cd11                	beqz	a0,80004e04 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	0b4080e7          	jalr	180(ra) # 80002e9e <iunlockput>
  end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	86c080e7          	jalr	-1940(ra) # 8000365e <end_op>
  return 0;
    80004dfa:	4501                	li	a0,0
}
    80004dfc:	60ea                	ld	ra,152(sp)
    80004dfe:	644a                	ld	s0,144(sp)
    80004e00:	610d                	addi	sp,sp,160
    80004e02:	8082                	ret
    end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	85a080e7          	jalr	-1958(ra) # 8000365e <end_op>
    return -1;
    80004e0c:	557d                	li	a0,-1
    80004e0e:	b7fd                	j	80004dfc <sys_mknod+0x6c>

0000000080004e10 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e10:	7135                	addi	sp,sp,-160
    80004e12:	ed06                	sd	ra,152(sp)
    80004e14:	e922                	sd	s0,144(sp)
    80004e16:	e526                	sd	s1,136(sp)
    80004e18:	e14a                	sd	s2,128(sp)
    80004e1a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e1c:	ffffc097          	auipc	ra,0xffffc
    80004e20:	036080e7          	jalr	54(ra) # 80000e52 <myproc>
    80004e24:	892a                	mv	s2,a0
  
  begin_op();
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	7be080e7          	jalr	1982(ra) # 800035e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e2e:	08000613          	li	a2,128
    80004e32:	f6040593          	addi	a1,s0,-160
    80004e36:	4501                	li	a0,0
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	16e080e7          	jalr	366(ra) # 80001fa6 <argstr>
    80004e40:	04054b63          	bltz	a0,80004e96 <sys_chdir+0x86>
    80004e44:	f6040513          	addi	a0,s0,-160
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	59c080e7          	jalr	1436(ra) # 800033e4 <namei>
    80004e50:	84aa                	mv	s1,a0
    80004e52:	c131                	beqz	a0,80004e96 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	d54080e7          	jalr	-684(ra) # 80002ba8 <ilock>
  if(ip->type != T_DIR){
    80004e5c:	04449703          	lh	a4,68(s1)
    80004e60:	4785                	li	a5,1
    80004e62:	04f71063          	bne	a4,a5,80004ea2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e66:	8526                	mv	a0,s1
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	e02080e7          	jalr	-510(ra) # 80002c6a <iunlock>
  iput(p->cwd);
    80004e70:	15093503          	ld	a0,336(s2)
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	f82080e7          	jalr	-126(ra) # 80002df6 <iput>
  end_op();
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	7e2080e7          	jalr	2018(ra) # 8000365e <end_op>
  p->cwd = ip;
    80004e84:	14993823          	sd	s1,336(s2)
  return 0;
    80004e88:	4501                	li	a0,0
}
    80004e8a:	60ea                	ld	ra,152(sp)
    80004e8c:	644a                	ld	s0,144(sp)
    80004e8e:	64aa                	ld	s1,136(sp)
    80004e90:	690a                	ld	s2,128(sp)
    80004e92:	610d                	addi	sp,sp,160
    80004e94:	8082                	ret
    end_op();
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	7c8080e7          	jalr	1992(ra) # 8000365e <end_op>
    return -1;
    80004e9e:	557d                	li	a0,-1
    80004ea0:	b7ed                	j	80004e8a <sys_chdir+0x7a>
    iunlockput(ip);
    80004ea2:	8526                	mv	a0,s1
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	ffa080e7          	jalr	-6(ra) # 80002e9e <iunlockput>
    end_op();
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	7b2080e7          	jalr	1970(ra) # 8000365e <end_op>
    return -1;
    80004eb4:	557d                	li	a0,-1
    80004eb6:	bfd1                	j	80004e8a <sys_chdir+0x7a>

0000000080004eb8 <sys_exec>:

uint64
sys_exec(void)
{
    80004eb8:	7121                	addi	sp,sp,-448
    80004eba:	ff06                	sd	ra,440(sp)
    80004ebc:	fb22                	sd	s0,432(sp)
    80004ebe:	f726                	sd	s1,424(sp)
    80004ec0:	f34a                	sd	s2,416(sp)
    80004ec2:	ef4e                	sd	s3,408(sp)
    80004ec4:	eb52                	sd	s4,400(sp)
    80004ec6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004ec8:	e4840593          	addi	a1,s0,-440
    80004ecc:	4505                	li	a0,1
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	0b8080e7          	jalr	184(ra) # 80001f86 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ed6:	08000613          	li	a2,128
    80004eda:	f5040593          	addi	a1,s0,-176
    80004ede:	4501                	li	a0,0
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	0c6080e7          	jalr	198(ra) # 80001fa6 <argstr>
    80004ee8:	87aa                	mv	a5,a0
    return -1;
    80004eea:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eec:	0c07c263          	bltz	a5,80004fb0 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004ef0:	10000613          	li	a2,256
    80004ef4:	4581                	li	a1,0
    80004ef6:	e5040513          	addi	a0,s0,-432
    80004efa:	ffffb097          	auipc	ra,0xffffb
    80004efe:	280080e7          	jalr	640(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f02:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004f06:	89a6                	mv	s3,s1
    80004f08:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f0a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f0e:	00391513          	slli	a0,s2,0x3
    80004f12:	e4040593          	addi	a1,s0,-448
    80004f16:	e4843783          	ld	a5,-440(s0)
    80004f1a:	953e                	add	a0,a0,a5
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	fac080e7          	jalr	-84(ra) # 80001ec8 <fetchaddr>
    80004f24:	02054a63          	bltz	a0,80004f58 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f28:	e4043783          	ld	a5,-448(s0)
    80004f2c:	c3b9                	beqz	a5,80004f72 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f2e:	ffffb097          	auipc	ra,0xffffb
    80004f32:	1ec080e7          	jalr	492(ra) # 8000011a <kalloc>
    80004f36:	85aa                	mv	a1,a0
    80004f38:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f3c:	cd11                	beqz	a0,80004f58 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f3e:	6605                	lui	a2,0x1
    80004f40:	e4043503          	ld	a0,-448(s0)
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	fd6080e7          	jalr	-42(ra) # 80001f1a <fetchstr>
    80004f4c:	00054663          	bltz	a0,80004f58 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f50:	0905                	addi	s2,s2,1
    80004f52:	09a1                	addi	s3,s3,8
    80004f54:	fb491de3          	bne	s2,s4,80004f0e <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f58:	f5040913          	addi	s2,s0,-176
    80004f5c:	6088                	ld	a0,0(s1)
    80004f5e:	c921                	beqz	a0,80004fae <sys_exec+0xf6>
    kfree(argv[i]);
    80004f60:	ffffb097          	auipc	ra,0xffffb
    80004f64:	0bc080e7          	jalr	188(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f68:	04a1                	addi	s1,s1,8
    80004f6a:	ff2499e3          	bne	s1,s2,80004f5c <sys_exec+0xa4>
  return -1;
    80004f6e:	557d                	li	a0,-1
    80004f70:	a081                	j	80004fb0 <sys_exec+0xf8>
      argv[i] = 0;
    80004f72:	0009079b          	sext.w	a5,s2
    80004f76:	078e                	slli	a5,a5,0x3
    80004f78:	fd078793          	addi	a5,a5,-48
    80004f7c:	97a2                	add	a5,a5,s0
    80004f7e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f82:	e5040593          	addi	a1,s0,-432
    80004f86:	f5040513          	addi	a0,s0,-176
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	194080e7          	jalr	404(ra) # 8000411e <exec>
    80004f92:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f94:	f5040993          	addi	s3,s0,-176
    80004f98:	6088                	ld	a0,0(s1)
    80004f9a:	c901                	beqz	a0,80004faa <sys_exec+0xf2>
    kfree(argv[i]);
    80004f9c:	ffffb097          	auipc	ra,0xffffb
    80004fa0:	080080e7          	jalr	128(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa4:	04a1                	addi	s1,s1,8
    80004fa6:	ff3499e3          	bne	s1,s3,80004f98 <sys_exec+0xe0>
  return ret;
    80004faa:	854a                	mv	a0,s2
    80004fac:	a011                	j	80004fb0 <sys_exec+0xf8>
  return -1;
    80004fae:	557d                	li	a0,-1
}
    80004fb0:	70fa                	ld	ra,440(sp)
    80004fb2:	745a                	ld	s0,432(sp)
    80004fb4:	74ba                	ld	s1,424(sp)
    80004fb6:	791a                	ld	s2,416(sp)
    80004fb8:	69fa                	ld	s3,408(sp)
    80004fba:	6a5a                	ld	s4,400(sp)
    80004fbc:	6139                	addi	sp,sp,448
    80004fbe:	8082                	ret

0000000080004fc0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fc0:	7139                	addi	sp,sp,-64
    80004fc2:	fc06                	sd	ra,56(sp)
    80004fc4:	f822                	sd	s0,48(sp)
    80004fc6:	f426                	sd	s1,40(sp)
    80004fc8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	e88080e7          	jalr	-376(ra) # 80000e52 <myproc>
    80004fd2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fd4:	fd840593          	addi	a1,s0,-40
    80004fd8:	4501                	li	a0,0
    80004fda:	ffffd097          	auipc	ra,0xffffd
    80004fde:	fac080e7          	jalr	-84(ra) # 80001f86 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fe2:	fc840593          	addi	a1,s0,-56
    80004fe6:	fd040513          	addi	a0,s0,-48
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	dea080e7          	jalr	-534(ra) # 80003dd4 <pipealloc>
    return -1;
    80004ff2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ff4:	0c054463          	bltz	a0,800050bc <sys_pipe+0xfc>
  fd0 = -1;
    80004ff8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ffc:	fd043503          	ld	a0,-48(s0)
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	524080e7          	jalr	1316(ra) # 80004524 <fdalloc>
    80005008:	fca42223          	sw	a0,-60(s0)
    8000500c:	08054b63          	bltz	a0,800050a2 <sys_pipe+0xe2>
    80005010:	fc843503          	ld	a0,-56(s0)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	510080e7          	jalr	1296(ra) # 80004524 <fdalloc>
    8000501c:	fca42023          	sw	a0,-64(s0)
    80005020:	06054863          	bltz	a0,80005090 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005024:	4691                	li	a3,4
    80005026:	fc440613          	addi	a2,s0,-60
    8000502a:	fd843583          	ld	a1,-40(s0)
    8000502e:	68a8                	ld	a0,80(s1)
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	ae2080e7          	jalr	-1310(ra) # 80000b12 <copyout>
    80005038:	02054063          	bltz	a0,80005058 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000503c:	4691                	li	a3,4
    8000503e:	fc040613          	addi	a2,s0,-64
    80005042:	fd843583          	ld	a1,-40(s0)
    80005046:	0591                	addi	a1,a1,4
    80005048:	68a8                	ld	a0,80(s1)
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	ac8080e7          	jalr	-1336(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005052:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005054:	06055463          	bgez	a0,800050bc <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005058:	fc442783          	lw	a5,-60(s0)
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	97a6                	add	a5,a5,s1
    80005062:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005066:	fc042783          	lw	a5,-64(s0)
    8000506a:	07e9                	addi	a5,a5,26
    8000506c:	078e                	slli	a5,a5,0x3
    8000506e:	94be                	add	s1,s1,a5
    80005070:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005074:	fd043503          	ld	a0,-48(s0)
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	a30080e7          	jalr	-1488(ra) # 80003aa8 <fileclose>
    fileclose(wf);
    80005080:	fc843503          	ld	a0,-56(s0)
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	a24080e7          	jalr	-1500(ra) # 80003aa8 <fileclose>
    return -1;
    8000508c:	57fd                	li	a5,-1
    8000508e:	a03d                	j	800050bc <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005090:	fc442783          	lw	a5,-60(s0)
    80005094:	0007c763          	bltz	a5,800050a2 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005098:	07e9                	addi	a5,a5,26
    8000509a:	078e                	slli	a5,a5,0x3
    8000509c:	97a6                	add	a5,a5,s1
    8000509e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050a2:	fd043503          	ld	a0,-48(s0)
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	a02080e7          	jalr	-1534(ra) # 80003aa8 <fileclose>
    fileclose(wf);
    800050ae:	fc843503          	ld	a0,-56(s0)
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	9f6080e7          	jalr	-1546(ra) # 80003aa8 <fileclose>
    return -1;
    800050ba:	57fd                	li	a5,-1
}
    800050bc:	853e                	mv	a0,a5
    800050be:	70e2                	ld	ra,56(sp)
    800050c0:	7442                	ld	s0,48(sp)
    800050c2:	74a2                	ld	s1,40(sp)
    800050c4:	6121                	addi	sp,sp,64
    800050c6:	8082                	ret
	...

00000000800050d0 <kernelvec>:
    800050d0:	7111                	addi	sp,sp,-256
    800050d2:	e006                	sd	ra,0(sp)
    800050d4:	e40a                	sd	sp,8(sp)
    800050d6:	e80e                	sd	gp,16(sp)
    800050d8:	ec12                	sd	tp,24(sp)
    800050da:	f016                	sd	t0,32(sp)
    800050dc:	f41a                	sd	t1,40(sp)
    800050de:	f81e                	sd	t2,48(sp)
    800050e0:	fc22                	sd	s0,56(sp)
    800050e2:	e0a6                	sd	s1,64(sp)
    800050e4:	e4aa                	sd	a0,72(sp)
    800050e6:	e8ae                	sd	a1,80(sp)
    800050e8:	ecb2                	sd	a2,88(sp)
    800050ea:	f0b6                	sd	a3,96(sp)
    800050ec:	f4ba                	sd	a4,104(sp)
    800050ee:	f8be                	sd	a5,112(sp)
    800050f0:	fcc2                	sd	a6,120(sp)
    800050f2:	e146                	sd	a7,128(sp)
    800050f4:	e54a                	sd	s2,136(sp)
    800050f6:	e94e                	sd	s3,144(sp)
    800050f8:	ed52                	sd	s4,152(sp)
    800050fa:	f156                	sd	s5,160(sp)
    800050fc:	f55a                	sd	s6,168(sp)
    800050fe:	f95e                	sd	s7,176(sp)
    80005100:	fd62                	sd	s8,184(sp)
    80005102:	e1e6                	sd	s9,192(sp)
    80005104:	e5ea                	sd	s10,200(sp)
    80005106:	e9ee                	sd	s11,208(sp)
    80005108:	edf2                	sd	t3,216(sp)
    8000510a:	f1f6                	sd	t4,224(sp)
    8000510c:	f5fa                	sd	t5,232(sp)
    8000510e:	f9fe                	sd	t6,240(sp)
    80005110:	c85fc0ef          	jal	ra,80001d94 <kerneltrap>
    80005114:	6082                	ld	ra,0(sp)
    80005116:	6122                	ld	sp,8(sp)
    80005118:	61c2                	ld	gp,16(sp)
    8000511a:	7282                	ld	t0,32(sp)
    8000511c:	7322                	ld	t1,40(sp)
    8000511e:	73c2                	ld	t2,48(sp)
    80005120:	7462                	ld	s0,56(sp)
    80005122:	6486                	ld	s1,64(sp)
    80005124:	6526                	ld	a0,72(sp)
    80005126:	65c6                	ld	a1,80(sp)
    80005128:	6666                	ld	a2,88(sp)
    8000512a:	7686                	ld	a3,96(sp)
    8000512c:	7726                	ld	a4,104(sp)
    8000512e:	77c6                	ld	a5,112(sp)
    80005130:	7866                	ld	a6,120(sp)
    80005132:	688a                	ld	a7,128(sp)
    80005134:	692a                	ld	s2,136(sp)
    80005136:	69ca                	ld	s3,144(sp)
    80005138:	6a6a                	ld	s4,152(sp)
    8000513a:	7a8a                	ld	s5,160(sp)
    8000513c:	7b2a                	ld	s6,168(sp)
    8000513e:	7bca                	ld	s7,176(sp)
    80005140:	7c6a                	ld	s8,184(sp)
    80005142:	6c8e                	ld	s9,192(sp)
    80005144:	6d2e                	ld	s10,200(sp)
    80005146:	6dce                	ld	s11,208(sp)
    80005148:	6e6e                	ld	t3,216(sp)
    8000514a:	7e8e                	ld	t4,224(sp)
    8000514c:	7f2e                	ld	t5,232(sp)
    8000514e:	7fce                	ld	t6,240(sp)
    80005150:	6111                	addi	sp,sp,256
    80005152:	10200073          	sret
    80005156:	00000013          	nop
    8000515a:	00000013          	nop
    8000515e:	0001                	nop

0000000080005160 <timervec>:
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	e10c                	sd	a1,0(a0)
    80005166:	e510                	sd	a2,8(a0)
    80005168:	e914                	sd	a3,16(a0)
    8000516a:	6d0c                	ld	a1,24(a0)
    8000516c:	7110                	ld	a2,32(a0)
    8000516e:	6194                	ld	a3,0(a1)
    80005170:	96b2                	add	a3,a3,a2
    80005172:	e194                	sd	a3,0(a1)
    80005174:	4589                	li	a1,2
    80005176:	14459073          	csrw	sip,a1
    8000517a:	6914                	ld	a3,16(a0)
    8000517c:	6510                	ld	a2,8(a0)
    8000517e:	610c                	ld	a1,0(a0)
    80005180:	34051573          	csrrw	a0,mscratch,a0
    80005184:	30200073          	mret
	...

000000008000518a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000518a:	1141                	addi	sp,sp,-16
    8000518c:	e422                	sd	s0,8(sp)
    8000518e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005190:	0c0007b7          	lui	a5,0xc000
    80005194:	4705                	li	a4,1
    80005196:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005198:	c3d8                	sw	a4,4(a5)
}
    8000519a:	6422                	ld	s0,8(sp)
    8000519c:	0141                	addi	sp,sp,16
    8000519e:	8082                	ret

00000000800051a0 <plicinithart>:

void
plicinithart(void)
{
    800051a0:	1141                	addi	sp,sp,-16
    800051a2:	e406                	sd	ra,8(sp)
    800051a4:	e022                	sd	s0,0(sp)
    800051a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	c7e080e7          	jalr	-898(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051b0:	0085171b          	slliw	a4,a0,0x8
    800051b4:	0c0027b7          	lui	a5,0xc002
    800051b8:	97ba                	add	a5,a5,a4
    800051ba:	40200713          	li	a4,1026
    800051be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051c2:	00d5151b          	slliw	a0,a0,0xd
    800051c6:	0c2017b7          	lui	a5,0xc201
    800051ca:	97aa                	add	a5,a5,a0
    800051cc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051d0:	60a2                	ld	ra,8(sp)
    800051d2:	6402                	ld	s0,0(sp)
    800051d4:	0141                	addi	sp,sp,16
    800051d6:	8082                	ret

00000000800051d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051d8:	1141                	addi	sp,sp,-16
    800051da:	e406                	sd	ra,8(sp)
    800051dc:	e022                	sd	s0,0(sp)
    800051de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051e0:	ffffc097          	auipc	ra,0xffffc
    800051e4:	c46080e7          	jalr	-954(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051e8:	00d5151b          	slliw	a0,a0,0xd
    800051ec:	0c2017b7          	lui	a5,0xc201
    800051f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051f2:	43c8                	lw	a0,4(a5)
    800051f4:	60a2                	ld	ra,8(sp)
    800051f6:	6402                	ld	s0,0(sp)
    800051f8:	0141                	addi	sp,sp,16
    800051fa:	8082                	ret

00000000800051fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051fc:	1101                	addi	sp,sp,-32
    800051fe:	ec06                	sd	ra,24(sp)
    80005200:	e822                	sd	s0,16(sp)
    80005202:	e426                	sd	s1,8(sp)
    80005204:	1000                	addi	s0,sp,32
    80005206:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c1e080e7          	jalr	-994(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005210:	00d5151b          	slliw	a0,a0,0xd
    80005214:	0c2017b7          	lui	a5,0xc201
    80005218:	97aa                	add	a5,a5,a0
    8000521a:	c3c4                	sw	s1,4(a5)
}
    8000521c:	60e2                	ld	ra,24(sp)
    8000521e:	6442                	ld	s0,16(sp)
    80005220:	64a2                	ld	s1,8(sp)
    80005222:	6105                	addi	sp,sp,32
    80005224:	8082                	ret

0000000080005226 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005226:	1141                	addi	sp,sp,-16
    80005228:	e406                	sd	ra,8(sp)
    8000522a:	e022                	sd	s0,0(sp)
    8000522c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000522e:	479d                	li	a5,7
    80005230:	04a7cc63          	blt	a5,a0,80005288 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005234:	00010797          	auipc	a5,0x10
    80005238:	bac78793          	addi	a5,a5,-1108 # 80014de0 <disk>
    8000523c:	97aa                	add	a5,a5,a0
    8000523e:	0187c783          	lbu	a5,24(a5)
    80005242:	ebb9                	bnez	a5,80005298 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005244:	00451693          	slli	a3,a0,0x4
    80005248:	00010797          	auipc	a5,0x10
    8000524c:	b9878793          	addi	a5,a5,-1128 # 80014de0 <disk>
    80005250:	6398                	ld	a4,0(a5)
    80005252:	9736                	add	a4,a4,a3
    80005254:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005258:	6398                	ld	a4,0(a5)
    8000525a:	9736                	add	a4,a4,a3
    8000525c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005260:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005264:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005268:	97aa                	add	a5,a5,a0
    8000526a:	4705                	li	a4,1
    8000526c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005270:	00010517          	auipc	a0,0x10
    80005274:	b8850513          	addi	a0,a0,-1144 # 80014df8 <disk+0x18>
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	2e6080e7          	jalr	742(ra) # 8000155e <wakeup>
}
    80005280:	60a2                	ld	ra,8(sp)
    80005282:	6402                	ld	s0,0(sp)
    80005284:	0141                	addi	sp,sp,16
    80005286:	8082                	ret
    panic("free_desc 1");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	43850513          	addi	a0,a0,1080 # 800086c0 <syscalls+0x2f0>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	a06080e7          	jalr	-1530(ra) # 80005c96 <panic>
    panic("free_desc 2");
    80005298:	00003517          	auipc	a0,0x3
    8000529c:	43850513          	addi	a0,a0,1080 # 800086d0 <syscalls+0x300>
    800052a0:	00001097          	auipc	ra,0x1
    800052a4:	9f6080e7          	jalr	-1546(ra) # 80005c96 <panic>

00000000800052a8 <virtio_disk_init>:
{
    800052a8:	1101                	addi	sp,sp,-32
    800052aa:	ec06                	sd	ra,24(sp)
    800052ac:	e822                	sd	s0,16(sp)
    800052ae:	e426                	sd	s1,8(sp)
    800052b0:	e04a                	sd	s2,0(sp)
    800052b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052b4:	00003597          	auipc	a1,0x3
    800052b8:	42c58593          	addi	a1,a1,1068 # 800086e0 <syscalls+0x310>
    800052bc:	00010517          	auipc	a0,0x10
    800052c0:	c4c50513          	addi	a0,a0,-948 # 80014f08 <disk+0x128>
    800052c4:	00001097          	auipc	ra,0x1
    800052c8:	e7a080e7          	jalr	-390(ra) # 8000613e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052cc:	100017b7          	lui	a5,0x10001
    800052d0:	4398                	lw	a4,0(a5)
    800052d2:	2701                	sext.w	a4,a4
    800052d4:	747277b7          	lui	a5,0x74727
    800052d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052dc:	14f71b63          	bne	a4,a5,80005432 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e0:	100017b7          	lui	a5,0x10001
    800052e4:	43dc                	lw	a5,4(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e8:	4709                	li	a4,2
    800052ea:	14e79463          	bne	a5,a4,80005432 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ee:	100017b7          	lui	a5,0x10001
    800052f2:	479c                	lw	a5,8(a5)
    800052f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052f6:	12e79e63          	bne	a5,a4,80005432 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052fa:	100017b7          	lui	a5,0x10001
    800052fe:	47d8                	lw	a4,12(a5)
    80005300:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005302:	554d47b7          	lui	a5,0x554d4
    80005306:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000530a:	12f71463          	bne	a4,a5,80005432 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530e:	100017b7          	lui	a5,0x10001
    80005312:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005316:	4705                	li	a4,1
    80005318:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531a:	470d                	li	a4,3
    8000531c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000531e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005320:	c7ffe6b7          	lui	a3,0xc7ffe
    80005324:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe15ff>
    80005328:	8f75                	and	a4,a4,a3
    8000532a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000532c:	472d                	li	a4,11
    8000532e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005330:	5bbc                	lw	a5,112(a5)
    80005332:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005336:	8ba1                	andi	a5,a5,8
    80005338:	10078563          	beqz	a5,80005442 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000533c:	100017b7          	lui	a5,0x10001
    80005340:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005344:	43fc                	lw	a5,68(a5)
    80005346:	2781                	sext.w	a5,a5
    80005348:	10079563          	bnez	a5,80005452 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	5bdc                	lw	a5,52(a5)
    80005352:	2781                	sext.w	a5,a5
  if(max == 0)
    80005354:	10078763          	beqz	a5,80005462 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005358:	471d                	li	a4,7
    8000535a:	10f77c63          	bgeu	a4,a5,80005472 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000535e:	ffffb097          	auipc	ra,0xffffb
    80005362:	dbc080e7          	jalr	-580(ra) # 8000011a <kalloc>
    80005366:	00010497          	auipc	s1,0x10
    8000536a:	a7a48493          	addi	s1,s1,-1414 # 80014de0 <disk>
    8000536e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005370:	ffffb097          	auipc	ra,0xffffb
    80005374:	daa080e7          	jalr	-598(ra) # 8000011a <kalloc>
    80005378:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	da0080e7          	jalr	-608(ra) # 8000011a <kalloc>
    80005382:	87aa                	mv	a5,a0
    80005384:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005386:	6088                	ld	a0,0(s1)
    80005388:	cd6d                	beqz	a0,80005482 <virtio_disk_init+0x1da>
    8000538a:	00010717          	auipc	a4,0x10
    8000538e:	a5e73703          	ld	a4,-1442(a4) # 80014de8 <disk+0x8>
    80005392:	cb65                	beqz	a4,80005482 <virtio_disk_init+0x1da>
    80005394:	c7fd                	beqz	a5,80005482 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005396:	6605                	lui	a2,0x1
    80005398:	4581                	li	a1,0
    8000539a:	ffffb097          	auipc	ra,0xffffb
    8000539e:	de0080e7          	jalr	-544(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800053a2:	00010497          	auipc	s1,0x10
    800053a6:	a3e48493          	addi	s1,s1,-1474 # 80014de0 <disk>
    800053aa:	6605                	lui	a2,0x1
    800053ac:	4581                	li	a1,0
    800053ae:	6488                	ld	a0,8(s1)
    800053b0:	ffffb097          	auipc	ra,0xffffb
    800053b4:	dca080e7          	jalr	-566(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800053b8:	6605                	lui	a2,0x1
    800053ba:	4581                	li	a1,0
    800053bc:	6888                	ld	a0,16(s1)
    800053be:	ffffb097          	auipc	ra,0xffffb
    800053c2:	dbc080e7          	jalr	-580(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053c6:	100017b7          	lui	a5,0x10001
    800053ca:	4721                	li	a4,8
    800053cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053ce:	4098                	lw	a4,0(s1)
    800053d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053d4:	40d8                	lw	a4,4(s1)
    800053d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053da:	6498                	ld	a4,8(s1)
    800053dc:	0007069b          	sext.w	a3,a4
    800053e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053e4:	9701                	srai	a4,a4,0x20
    800053e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053ea:	6898                	ld	a4,16(s1)
    800053ec:	0007069b          	sext.w	a3,a4
    800053f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053f4:	9701                	srai	a4,a4,0x20
    800053f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053fa:	4705                	li	a4,1
    800053fc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053fe:	00e48c23          	sb	a4,24(s1)
    80005402:	00e48ca3          	sb	a4,25(s1)
    80005406:	00e48d23          	sb	a4,26(s1)
    8000540a:	00e48da3          	sb	a4,27(s1)
    8000540e:	00e48e23          	sb	a4,28(s1)
    80005412:	00e48ea3          	sb	a4,29(s1)
    80005416:	00e48f23          	sb	a4,30(s1)
    8000541a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000541e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005422:	0727a823          	sw	s2,112(a5)
}
    80005426:	60e2                	ld	ra,24(sp)
    80005428:	6442                	ld	s0,16(sp)
    8000542a:	64a2                	ld	s1,8(sp)
    8000542c:	6902                	ld	s2,0(sp)
    8000542e:	6105                	addi	sp,sp,32
    80005430:	8082                	ret
    panic("could not find virtio disk");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	2be50513          	addi	a0,a0,702 # 800086f0 <syscalls+0x320>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	85c080e7          	jalr	-1956(ra) # 80005c96 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	2ce50513          	addi	a0,a0,718 # 80008710 <syscalls+0x340>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	84c080e7          	jalr	-1972(ra) # 80005c96 <panic>
    panic("virtio disk should not be ready");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	2de50513          	addi	a0,a0,734 # 80008730 <syscalls+0x360>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	83c080e7          	jalr	-1988(ra) # 80005c96 <panic>
    panic("virtio disk has no queue 0");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	2ee50513          	addi	a0,a0,750 # 80008750 <syscalls+0x380>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	82c080e7          	jalr	-2004(ra) # 80005c96 <panic>
    panic("virtio disk max queue too short");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	2fe50513          	addi	a0,a0,766 # 80008770 <syscalls+0x3a0>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	81c080e7          	jalr	-2020(ra) # 80005c96 <panic>
    panic("virtio disk kalloc");
    80005482:	00003517          	auipc	a0,0x3
    80005486:	30e50513          	addi	a0,a0,782 # 80008790 <syscalls+0x3c0>
    8000548a:	00001097          	auipc	ra,0x1
    8000548e:	80c080e7          	jalr	-2036(ra) # 80005c96 <panic>

0000000080005492 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005492:	7159                	addi	sp,sp,-112
    80005494:	f486                	sd	ra,104(sp)
    80005496:	f0a2                	sd	s0,96(sp)
    80005498:	eca6                	sd	s1,88(sp)
    8000549a:	e8ca                	sd	s2,80(sp)
    8000549c:	e4ce                	sd	s3,72(sp)
    8000549e:	e0d2                	sd	s4,64(sp)
    800054a0:	fc56                	sd	s5,56(sp)
    800054a2:	f85a                	sd	s6,48(sp)
    800054a4:	f45e                	sd	s7,40(sp)
    800054a6:	f062                	sd	s8,32(sp)
    800054a8:	ec66                	sd	s9,24(sp)
    800054aa:	e86a                	sd	s10,16(sp)
    800054ac:	1880                	addi	s0,sp,112
    800054ae:	8a2a                	mv	s4,a0
    800054b0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054b2:	00c52c83          	lw	s9,12(a0)
    800054b6:	001c9c9b          	slliw	s9,s9,0x1
    800054ba:	1c82                	slli	s9,s9,0x20
    800054bc:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054c0:	00010517          	auipc	a0,0x10
    800054c4:	a4850513          	addi	a0,a0,-1464 # 80014f08 <disk+0x128>
    800054c8:	00001097          	auipc	ra,0x1
    800054cc:	d06080e7          	jalr	-762(ra) # 800061ce <acquire>
  for(int i = 0; i < 3; i++){
    800054d0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054d2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054d4:	00010b17          	auipc	s6,0x10
    800054d8:	90cb0b13          	addi	s6,s6,-1780 # 80014de0 <disk>
  for(int i = 0; i < 3; i++){
    800054dc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054de:	00010c17          	auipc	s8,0x10
    800054e2:	a2ac0c13          	addi	s8,s8,-1494 # 80014f08 <disk+0x128>
    800054e6:	a095                	j	8000554a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054e8:	00fb0733          	add	a4,s6,a5
    800054ec:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054f0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054f2:	0207c563          	bltz	a5,8000551c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054f6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054f8:	0591                	addi	a1,a1,4
    800054fa:	05560d63          	beq	a2,s5,80005554 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054fe:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005500:	00010717          	auipc	a4,0x10
    80005504:	8e070713          	addi	a4,a4,-1824 # 80014de0 <disk>
    80005508:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000550a:	01874683          	lbu	a3,24(a4)
    8000550e:	fee9                	bnez	a3,800054e8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005510:	2785                	addiw	a5,a5,1
    80005512:	0705                	addi	a4,a4,1
    80005514:	fe979be3          	bne	a5,s1,8000550a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005518:	57fd                	li	a5,-1
    8000551a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000551c:	00c05e63          	blez	a2,80005538 <virtio_disk_rw+0xa6>
    80005520:	060a                	slli	a2,a2,0x2
    80005522:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005526:	0009a503          	lw	a0,0(s3)
    8000552a:	00000097          	auipc	ra,0x0
    8000552e:	cfc080e7          	jalr	-772(ra) # 80005226 <free_desc>
      for(int j = 0; j < i; j++)
    80005532:	0991                	addi	s3,s3,4
    80005534:	ffa999e3          	bne	s3,s10,80005526 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005538:	85e2                	mv	a1,s8
    8000553a:	00010517          	auipc	a0,0x10
    8000553e:	8be50513          	addi	a0,a0,-1858 # 80014df8 <disk+0x18>
    80005542:	ffffc097          	auipc	ra,0xffffc
    80005546:	fb8080e7          	jalr	-72(ra) # 800014fa <sleep>
  for(int i = 0; i < 3; i++){
    8000554a:	f9040993          	addi	s3,s0,-112
{
    8000554e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005550:	864a                	mv	a2,s2
    80005552:	b775                	j	800054fe <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005554:	f9042503          	lw	a0,-112(s0)
    80005558:	00a50713          	addi	a4,a0,10
    8000555c:	0712                	slli	a4,a4,0x4

  if(write)
    8000555e:	00010797          	auipc	a5,0x10
    80005562:	88278793          	addi	a5,a5,-1918 # 80014de0 <disk>
    80005566:	00e786b3          	add	a3,a5,a4
    8000556a:	01703633          	snez	a2,s7
    8000556e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005570:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005574:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005578:	f6070613          	addi	a2,a4,-160
    8000557c:	6394                	ld	a3,0(a5)
    8000557e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005580:	00870593          	addi	a1,a4,8
    80005584:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005586:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005588:	0007b803          	ld	a6,0(a5)
    8000558c:	9642                	add	a2,a2,a6
    8000558e:	46c1                	li	a3,16
    80005590:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005592:	4585                	li	a1,1
    80005594:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005598:	f9442683          	lw	a3,-108(s0)
    8000559c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055a0:	0692                	slli	a3,a3,0x4
    800055a2:	9836                	add	a6,a6,a3
    800055a4:	058a0613          	addi	a2,s4,88
    800055a8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800055ac:	0007b803          	ld	a6,0(a5)
    800055b0:	96c2                	add	a3,a3,a6
    800055b2:	40000613          	li	a2,1024
    800055b6:	c690                	sw	a2,8(a3)
  if(write)
    800055b8:	001bb613          	seqz	a2,s7
    800055bc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055c0:	00166613          	ori	a2,a2,1
    800055c4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055c8:	f9842603          	lw	a2,-104(s0)
    800055cc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055d0:	00250693          	addi	a3,a0,2
    800055d4:	0692                	slli	a3,a3,0x4
    800055d6:	96be                	add	a3,a3,a5
    800055d8:	58fd                	li	a7,-1
    800055da:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055de:	0612                	slli	a2,a2,0x4
    800055e0:	9832                	add	a6,a6,a2
    800055e2:	f9070713          	addi	a4,a4,-112
    800055e6:	973e                	add	a4,a4,a5
    800055e8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055ec:	6398                	ld	a4,0(a5)
    800055ee:	9732                	add	a4,a4,a2
    800055f0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055f2:	4609                	li	a2,2
    800055f4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055fc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005600:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005604:	6794                	ld	a3,8(a5)
    80005606:	0026d703          	lhu	a4,2(a3)
    8000560a:	8b1d                	andi	a4,a4,7
    8000560c:	0706                	slli	a4,a4,0x1
    8000560e:	96ba                	add	a3,a3,a4
    80005610:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005614:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005618:	6798                	ld	a4,8(a5)
    8000561a:	00275783          	lhu	a5,2(a4)
    8000561e:	2785                	addiw	a5,a5,1
    80005620:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005624:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005628:	100017b7          	lui	a5,0x10001
    8000562c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005630:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005634:	00010917          	auipc	s2,0x10
    80005638:	8d490913          	addi	s2,s2,-1836 # 80014f08 <disk+0x128>
  while(b->disk == 1) {
    8000563c:	4485                	li	s1,1
    8000563e:	00b79c63          	bne	a5,a1,80005656 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005642:	85ca                	mv	a1,s2
    80005644:	8552                	mv	a0,s4
    80005646:	ffffc097          	auipc	ra,0xffffc
    8000564a:	eb4080e7          	jalr	-332(ra) # 800014fa <sleep>
  while(b->disk == 1) {
    8000564e:	004a2783          	lw	a5,4(s4)
    80005652:	fe9788e3          	beq	a5,s1,80005642 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005656:	f9042903          	lw	s2,-112(s0)
    8000565a:	00290713          	addi	a4,s2,2
    8000565e:	0712                	slli	a4,a4,0x4
    80005660:	0000f797          	auipc	a5,0xf
    80005664:	78078793          	addi	a5,a5,1920 # 80014de0 <disk>
    80005668:	97ba                	add	a5,a5,a4
    8000566a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000566e:	0000f997          	auipc	s3,0xf
    80005672:	77298993          	addi	s3,s3,1906 # 80014de0 <disk>
    80005676:	00491713          	slli	a4,s2,0x4
    8000567a:	0009b783          	ld	a5,0(s3)
    8000567e:	97ba                	add	a5,a5,a4
    80005680:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005684:	854a                	mv	a0,s2
    80005686:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000568a:	00000097          	auipc	ra,0x0
    8000568e:	b9c080e7          	jalr	-1124(ra) # 80005226 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005692:	8885                	andi	s1,s1,1
    80005694:	f0ed                	bnez	s1,80005676 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005696:	00010517          	auipc	a0,0x10
    8000569a:	87250513          	addi	a0,a0,-1934 # 80014f08 <disk+0x128>
    8000569e:	00001097          	auipc	ra,0x1
    800056a2:	be4080e7          	jalr	-1052(ra) # 80006282 <release>
}
    800056a6:	70a6                	ld	ra,104(sp)
    800056a8:	7406                	ld	s0,96(sp)
    800056aa:	64e6                	ld	s1,88(sp)
    800056ac:	6946                	ld	s2,80(sp)
    800056ae:	69a6                	ld	s3,72(sp)
    800056b0:	6a06                	ld	s4,64(sp)
    800056b2:	7ae2                	ld	s5,56(sp)
    800056b4:	7b42                	ld	s6,48(sp)
    800056b6:	7ba2                	ld	s7,40(sp)
    800056b8:	7c02                	ld	s8,32(sp)
    800056ba:	6ce2                	ld	s9,24(sp)
    800056bc:	6d42                	ld	s10,16(sp)
    800056be:	6165                	addi	sp,sp,112
    800056c0:	8082                	ret

00000000800056c2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056c2:	1101                	addi	sp,sp,-32
    800056c4:	ec06                	sd	ra,24(sp)
    800056c6:	e822                	sd	s0,16(sp)
    800056c8:	e426                	sd	s1,8(sp)
    800056ca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056cc:	0000f497          	auipc	s1,0xf
    800056d0:	71448493          	addi	s1,s1,1812 # 80014de0 <disk>
    800056d4:	00010517          	auipc	a0,0x10
    800056d8:	83450513          	addi	a0,a0,-1996 # 80014f08 <disk+0x128>
    800056dc:	00001097          	auipc	ra,0x1
    800056e0:	af2080e7          	jalr	-1294(ra) # 800061ce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056e4:	10001737          	lui	a4,0x10001
    800056e8:	533c                	lw	a5,96(a4)
    800056ea:	8b8d                	andi	a5,a5,3
    800056ec:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056ee:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056f2:	689c                	ld	a5,16(s1)
    800056f4:	0204d703          	lhu	a4,32(s1)
    800056f8:	0027d783          	lhu	a5,2(a5)
    800056fc:	04f70863          	beq	a4,a5,8000574c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005700:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005704:	6898                	ld	a4,16(s1)
    80005706:	0204d783          	lhu	a5,32(s1)
    8000570a:	8b9d                	andi	a5,a5,7
    8000570c:	078e                	slli	a5,a5,0x3
    8000570e:	97ba                	add	a5,a5,a4
    80005710:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005712:	00278713          	addi	a4,a5,2
    80005716:	0712                	slli	a4,a4,0x4
    80005718:	9726                	add	a4,a4,s1
    8000571a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000571e:	e721                	bnez	a4,80005766 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005720:	0789                	addi	a5,a5,2
    80005722:	0792                	slli	a5,a5,0x4
    80005724:	97a6                	add	a5,a5,s1
    80005726:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005728:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000572c:	ffffc097          	auipc	ra,0xffffc
    80005730:	e32080e7          	jalr	-462(ra) # 8000155e <wakeup>

    disk.used_idx += 1;
    80005734:	0204d783          	lhu	a5,32(s1)
    80005738:	2785                	addiw	a5,a5,1
    8000573a:	17c2                	slli	a5,a5,0x30
    8000573c:	93c1                	srli	a5,a5,0x30
    8000573e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005742:	6898                	ld	a4,16(s1)
    80005744:	00275703          	lhu	a4,2(a4)
    80005748:	faf71ce3          	bne	a4,a5,80005700 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000574c:	0000f517          	auipc	a0,0xf
    80005750:	7bc50513          	addi	a0,a0,1980 # 80014f08 <disk+0x128>
    80005754:	00001097          	auipc	ra,0x1
    80005758:	b2e080e7          	jalr	-1234(ra) # 80006282 <release>
}
    8000575c:	60e2                	ld	ra,24(sp)
    8000575e:	6442                	ld	s0,16(sp)
    80005760:	64a2                	ld	s1,8(sp)
    80005762:	6105                	addi	sp,sp,32
    80005764:	8082                	ret
      panic("virtio_disk_intr status");
    80005766:	00003517          	auipc	a0,0x3
    8000576a:	04250513          	addi	a0,a0,66 # 800087a8 <syscalls+0x3d8>
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	528080e7          	jalr	1320(ra) # 80005c96 <panic>

0000000080005776 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e422                	sd	s0,8(sp)
    8000577a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000577c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005780:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005784:	0037979b          	slliw	a5,a5,0x3
    80005788:	02004737          	lui	a4,0x2004
    8000578c:	97ba                	add	a5,a5,a4
    8000578e:	0200c737          	lui	a4,0x200c
    80005792:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005796:	000f4637          	lui	a2,0xf4
    8000579a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000579e:	9732                	add	a4,a4,a2
    800057a0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057a2:	00259693          	slli	a3,a1,0x2
    800057a6:	96ae                	add	a3,a3,a1
    800057a8:	068e                	slli	a3,a3,0x3
    800057aa:	0000f717          	auipc	a4,0xf
    800057ae:	77670713          	addi	a4,a4,1910 # 80014f20 <timer_scratch>
    800057b2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057b4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057b6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057b8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057bc:	00000797          	auipc	a5,0x0
    800057c0:	9a478793          	addi	a5,a5,-1628 # 80005160 <timervec>
    800057c4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057c8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057cc:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057d4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057d8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057dc:	30479073          	csrw	mie,a5
}
    800057e0:	6422                	ld	s0,8(sp)
    800057e2:	0141                	addi	sp,sp,16
    800057e4:	8082                	ret

00000000800057e6 <start>:
{
    800057e6:	1141                	addi	sp,sp,-16
    800057e8:	e406                	sd	ra,8(sp)
    800057ea:	e022                	sd	s0,0(sp)
    800057ec:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ee:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057f2:	7779                	lui	a4,0xffffe
    800057f4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe169f>
    800057f8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057fa:	6705                	lui	a4,0x1
    800057fc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005800:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005802:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005806:	ffffb797          	auipc	a5,0xffffb
    8000580a:	b1878793          	addi	a5,a5,-1256 # 8000031e <main>
    8000580e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005812:	4781                	li	a5,0
    80005814:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005818:	67c1                	lui	a5,0x10
    8000581a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000581c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005820:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005824:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005828:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000582c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005830:	57fd                	li	a5,-1
    80005832:	83a9                	srli	a5,a5,0xa
    80005834:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005838:	47bd                	li	a5,15
    8000583a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000583e:	00000097          	auipc	ra,0x0
    80005842:	f38080e7          	jalr	-200(ra) # 80005776 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005846:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000584a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000584c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000584e:	30200073          	mret
}
    80005852:	60a2                	ld	ra,8(sp)
    80005854:	6402                	ld	s0,0(sp)
    80005856:	0141                	addi	sp,sp,16
    80005858:	8082                	ret

000000008000585a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000585a:	715d                	addi	sp,sp,-80
    8000585c:	e486                	sd	ra,72(sp)
    8000585e:	e0a2                	sd	s0,64(sp)
    80005860:	fc26                	sd	s1,56(sp)
    80005862:	f84a                	sd	s2,48(sp)
    80005864:	f44e                	sd	s3,40(sp)
    80005866:	f052                	sd	s4,32(sp)
    80005868:	ec56                	sd	s5,24(sp)
    8000586a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000586c:	04c05763          	blez	a2,800058ba <consolewrite+0x60>
    80005870:	8a2a                	mv	s4,a0
    80005872:	84ae                	mv	s1,a1
    80005874:	89b2                	mv	s3,a2
    80005876:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005878:	5afd                	li	s5,-1
    8000587a:	4685                	li	a3,1
    8000587c:	8626                	mv	a2,s1
    8000587e:	85d2                	mv	a1,s4
    80005880:	fbf40513          	addi	a0,s0,-65
    80005884:	ffffc097          	auipc	ra,0xffffc
    80005888:	0ce080e7          	jalr	206(ra) # 80001952 <either_copyin>
    8000588c:	01550d63          	beq	a0,s5,800058a6 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005890:	fbf44503          	lbu	a0,-65(s0)
    80005894:	00000097          	auipc	ra,0x0
    80005898:	780080e7          	jalr	1920(ra) # 80006014 <uartputc>
  for(i = 0; i < n; i++){
    8000589c:	2905                	addiw	s2,s2,1
    8000589e:	0485                	addi	s1,s1,1
    800058a0:	fd299de3          	bne	s3,s2,8000587a <consolewrite+0x20>
    800058a4:	894e                	mv	s2,s3
  }

  return i;
}
    800058a6:	854a                	mv	a0,s2
    800058a8:	60a6                	ld	ra,72(sp)
    800058aa:	6406                	ld	s0,64(sp)
    800058ac:	74e2                	ld	s1,56(sp)
    800058ae:	7942                	ld	s2,48(sp)
    800058b0:	79a2                	ld	s3,40(sp)
    800058b2:	7a02                	ld	s4,32(sp)
    800058b4:	6ae2                	ld	s5,24(sp)
    800058b6:	6161                	addi	sp,sp,80
    800058b8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ba:	4901                	li	s2,0
    800058bc:	b7ed                	j	800058a6 <consolewrite+0x4c>

00000000800058be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058be:	711d                	addi	sp,sp,-96
    800058c0:	ec86                	sd	ra,88(sp)
    800058c2:	e8a2                	sd	s0,80(sp)
    800058c4:	e4a6                	sd	s1,72(sp)
    800058c6:	e0ca                	sd	s2,64(sp)
    800058c8:	fc4e                	sd	s3,56(sp)
    800058ca:	f852                	sd	s4,48(sp)
    800058cc:	f456                	sd	s5,40(sp)
    800058ce:	f05a                	sd	s6,32(sp)
    800058d0:	ec5e                	sd	s7,24(sp)
    800058d2:	1080                	addi	s0,sp,96
    800058d4:	8aaa                	mv	s5,a0
    800058d6:	8a2e                	mv	s4,a1
    800058d8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058da:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058de:	00017517          	auipc	a0,0x17
    800058e2:	78250513          	addi	a0,a0,1922 # 8001d060 <cons>
    800058e6:	00001097          	auipc	ra,0x1
    800058ea:	8e8080e7          	jalr	-1816(ra) # 800061ce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058ee:	00017497          	auipc	s1,0x17
    800058f2:	77248493          	addi	s1,s1,1906 # 8001d060 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058f6:	00018917          	auipc	s2,0x18
    800058fa:	80290913          	addi	s2,s2,-2046 # 8001d0f8 <cons+0x98>
  while(n > 0){
    800058fe:	09305263          	blez	s3,80005982 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005902:	0984a783          	lw	a5,152(s1)
    80005906:	09c4a703          	lw	a4,156(s1)
    8000590a:	02f71763          	bne	a4,a5,80005938 <consoleread+0x7a>
      if(killed(myproc())){
    8000590e:	ffffb097          	auipc	ra,0xffffb
    80005912:	544080e7          	jalr	1348(ra) # 80000e52 <myproc>
    80005916:	ffffc097          	auipc	ra,0xffffc
    8000591a:	e86080e7          	jalr	-378(ra) # 8000179c <killed>
    8000591e:	ed2d                	bnez	a0,80005998 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005920:	85a6                	mv	a1,s1
    80005922:	854a                	mv	a0,s2
    80005924:	ffffc097          	auipc	ra,0xffffc
    80005928:	bd6080e7          	jalr	-1066(ra) # 800014fa <sleep>
    while(cons.r == cons.w){
    8000592c:	0984a783          	lw	a5,152(s1)
    80005930:	09c4a703          	lw	a4,156(s1)
    80005934:	fcf70de3          	beq	a4,a5,8000590e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005938:	00017717          	auipc	a4,0x17
    8000593c:	72870713          	addi	a4,a4,1832 # 8001d060 <cons>
    80005940:	0017869b          	addiw	a3,a5,1
    80005944:	08d72c23          	sw	a3,152(a4)
    80005948:	07f7f693          	andi	a3,a5,127
    8000594c:	9736                	add	a4,a4,a3
    8000594e:	01874703          	lbu	a4,24(a4)
    80005952:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005956:	4691                	li	a3,4
    80005958:	06db8463          	beq	s7,a3,800059c0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000595c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005960:	4685                	li	a3,1
    80005962:	faf40613          	addi	a2,s0,-81
    80005966:	85d2                	mv	a1,s4
    80005968:	8556                	mv	a0,s5
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	f92080e7          	jalr	-110(ra) # 800018fc <either_copyout>
    80005972:	57fd                	li	a5,-1
    80005974:	00f50763          	beq	a0,a5,80005982 <consoleread+0xc4>
      break;

    dst++;
    80005978:	0a05                	addi	s4,s4,1
    --n;
    8000597a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000597c:	47a9                	li	a5,10
    8000597e:	f8fb90e3          	bne	s7,a5,800058fe <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005982:	00017517          	auipc	a0,0x17
    80005986:	6de50513          	addi	a0,a0,1758 # 8001d060 <cons>
    8000598a:	00001097          	auipc	ra,0x1
    8000598e:	8f8080e7          	jalr	-1800(ra) # 80006282 <release>

  return target - n;
    80005992:	413b053b          	subw	a0,s6,s3
    80005996:	a811                	j	800059aa <consoleread+0xec>
        release(&cons.lock);
    80005998:	00017517          	auipc	a0,0x17
    8000599c:	6c850513          	addi	a0,a0,1736 # 8001d060 <cons>
    800059a0:	00001097          	auipc	ra,0x1
    800059a4:	8e2080e7          	jalr	-1822(ra) # 80006282 <release>
        return -1;
    800059a8:	557d                	li	a0,-1
}
    800059aa:	60e6                	ld	ra,88(sp)
    800059ac:	6446                	ld	s0,80(sp)
    800059ae:	64a6                	ld	s1,72(sp)
    800059b0:	6906                	ld	s2,64(sp)
    800059b2:	79e2                	ld	s3,56(sp)
    800059b4:	7a42                	ld	s4,48(sp)
    800059b6:	7aa2                	ld	s5,40(sp)
    800059b8:	7b02                	ld	s6,32(sp)
    800059ba:	6be2                	ld	s7,24(sp)
    800059bc:	6125                	addi	sp,sp,96
    800059be:	8082                	ret
      if(n < target){
    800059c0:	0009871b          	sext.w	a4,s3
    800059c4:	fb677fe3          	bgeu	a4,s6,80005982 <consoleread+0xc4>
        cons.r--;
    800059c8:	00017717          	auipc	a4,0x17
    800059cc:	72f72823          	sw	a5,1840(a4) # 8001d0f8 <cons+0x98>
    800059d0:	bf4d                	j	80005982 <consoleread+0xc4>

00000000800059d2 <consputc>:
{
    800059d2:	1141                	addi	sp,sp,-16
    800059d4:	e406                	sd	ra,8(sp)
    800059d6:	e022                	sd	s0,0(sp)
    800059d8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059da:	10000793          	li	a5,256
    800059de:	00f50a63          	beq	a0,a5,800059f2 <consputc+0x20>
    uartputc_sync(c);
    800059e2:	00000097          	auipc	ra,0x0
    800059e6:	560080e7          	jalr	1376(ra) # 80005f42 <uartputc_sync>
}
    800059ea:	60a2                	ld	ra,8(sp)
    800059ec:	6402                	ld	s0,0(sp)
    800059ee:	0141                	addi	sp,sp,16
    800059f0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059f2:	4521                	li	a0,8
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	54e080e7          	jalr	1358(ra) # 80005f42 <uartputc_sync>
    800059fc:	02000513          	li	a0,32
    80005a00:	00000097          	auipc	ra,0x0
    80005a04:	542080e7          	jalr	1346(ra) # 80005f42 <uartputc_sync>
    80005a08:	4521                	li	a0,8
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	538080e7          	jalr	1336(ra) # 80005f42 <uartputc_sync>
    80005a12:	bfe1                	j	800059ea <consputc+0x18>

0000000080005a14 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a14:	1101                	addi	sp,sp,-32
    80005a16:	ec06                	sd	ra,24(sp)
    80005a18:	e822                	sd	s0,16(sp)
    80005a1a:	e426                	sd	s1,8(sp)
    80005a1c:	e04a                	sd	s2,0(sp)
    80005a1e:	1000                	addi	s0,sp,32
    80005a20:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a22:	00017517          	auipc	a0,0x17
    80005a26:	63e50513          	addi	a0,a0,1598 # 8001d060 <cons>
    80005a2a:	00000097          	auipc	ra,0x0
    80005a2e:	7a4080e7          	jalr	1956(ra) # 800061ce <acquire>

  switch(c){
    80005a32:	47d5                	li	a5,21
    80005a34:	0af48663          	beq	s1,a5,80005ae0 <consoleintr+0xcc>
    80005a38:	0297ca63          	blt	a5,s1,80005a6c <consoleintr+0x58>
    80005a3c:	47a1                	li	a5,8
    80005a3e:	0ef48763          	beq	s1,a5,80005b2c <consoleintr+0x118>
    80005a42:	47c1                	li	a5,16
    80005a44:	10f49a63          	bne	s1,a5,80005b58 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a48:	ffffc097          	auipc	ra,0xffffc
    80005a4c:	f60080e7          	jalr	-160(ra) # 800019a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a50:	00017517          	auipc	a0,0x17
    80005a54:	61050513          	addi	a0,a0,1552 # 8001d060 <cons>
    80005a58:	00001097          	auipc	ra,0x1
    80005a5c:	82a080e7          	jalr	-2006(ra) # 80006282 <release>
}
    80005a60:	60e2                	ld	ra,24(sp)
    80005a62:	6442                	ld	s0,16(sp)
    80005a64:	64a2                	ld	s1,8(sp)
    80005a66:	6902                	ld	s2,0(sp)
    80005a68:	6105                	addi	sp,sp,32
    80005a6a:	8082                	ret
  switch(c){
    80005a6c:	07f00793          	li	a5,127
    80005a70:	0af48e63          	beq	s1,a5,80005b2c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a74:	00017717          	auipc	a4,0x17
    80005a78:	5ec70713          	addi	a4,a4,1516 # 8001d060 <cons>
    80005a7c:	0a072783          	lw	a5,160(a4)
    80005a80:	09872703          	lw	a4,152(a4)
    80005a84:	9f99                	subw	a5,a5,a4
    80005a86:	07f00713          	li	a4,127
    80005a8a:	fcf763e3          	bltu	a4,a5,80005a50 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a8e:	47b5                	li	a5,13
    80005a90:	0cf48763          	beq	s1,a5,80005b5e <consoleintr+0x14a>
      consputc(c);
    80005a94:	8526                	mv	a0,s1
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	f3c080e7          	jalr	-196(ra) # 800059d2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a9e:	00017797          	auipc	a5,0x17
    80005aa2:	5c278793          	addi	a5,a5,1474 # 8001d060 <cons>
    80005aa6:	0a07a683          	lw	a3,160(a5)
    80005aaa:	0016871b          	addiw	a4,a3,1
    80005aae:	0007061b          	sext.w	a2,a4
    80005ab2:	0ae7a023          	sw	a4,160(a5)
    80005ab6:	07f6f693          	andi	a3,a3,127
    80005aba:	97b6                	add	a5,a5,a3
    80005abc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ac0:	47a9                	li	a5,10
    80005ac2:	0cf48563          	beq	s1,a5,80005b8c <consoleintr+0x178>
    80005ac6:	4791                	li	a5,4
    80005ac8:	0cf48263          	beq	s1,a5,80005b8c <consoleintr+0x178>
    80005acc:	00017797          	auipc	a5,0x17
    80005ad0:	62c7a783          	lw	a5,1580(a5) # 8001d0f8 <cons+0x98>
    80005ad4:	9f1d                	subw	a4,a4,a5
    80005ad6:	08000793          	li	a5,128
    80005ada:	f6f71be3          	bne	a4,a5,80005a50 <consoleintr+0x3c>
    80005ade:	a07d                	j	80005b8c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ae0:	00017717          	auipc	a4,0x17
    80005ae4:	58070713          	addi	a4,a4,1408 # 8001d060 <cons>
    80005ae8:	0a072783          	lw	a5,160(a4)
    80005aec:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005af0:	00017497          	auipc	s1,0x17
    80005af4:	57048493          	addi	s1,s1,1392 # 8001d060 <cons>
    while(cons.e != cons.w &&
    80005af8:	4929                	li	s2,10
    80005afa:	f4f70be3          	beq	a4,a5,80005a50 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005afe:	37fd                	addiw	a5,a5,-1
    80005b00:	07f7f713          	andi	a4,a5,127
    80005b04:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b06:	01874703          	lbu	a4,24(a4)
    80005b0a:	f52703e3          	beq	a4,s2,80005a50 <consoleintr+0x3c>
      cons.e--;
    80005b0e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b12:	10000513          	li	a0,256
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	ebc080e7          	jalr	-324(ra) # 800059d2 <consputc>
    while(cons.e != cons.w &&
    80005b1e:	0a04a783          	lw	a5,160(s1)
    80005b22:	09c4a703          	lw	a4,156(s1)
    80005b26:	fcf71ce3          	bne	a4,a5,80005afe <consoleintr+0xea>
    80005b2a:	b71d                	j	80005a50 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b2c:	00017717          	auipc	a4,0x17
    80005b30:	53470713          	addi	a4,a4,1332 # 8001d060 <cons>
    80005b34:	0a072783          	lw	a5,160(a4)
    80005b38:	09c72703          	lw	a4,156(a4)
    80005b3c:	f0f70ae3          	beq	a4,a5,80005a50 <consoleintr+0x3c>
      cons.e--;
    80005b40:	37fd                	addiw	a5,a5,-1
    80005b42:	00017717          	auipc	a4,0x17
    80005b46:	5af72f23          	sw	a5,1470(a4) # 8001d100 <cons+0xa0>
      consputc(BACKSPACE);
    80005b4a:	10000513          	li	a0,256
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	e84080e7          	jalr	-380(ra) # 800059d2 <consputc>
    80005b56:	bded                	j	80005a50 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b58:	ee048ce3          	beqz	s1,80005a50 <consoleintr+0x3c>
    80005b5c:	bf21                	j	80005a74 <consoleintr+0x60>
      consputc(c);
    80005b5e:	4529                	li	a0,10
    80005b60:	00000097          	auipc	ra,0x0
    80005b64:	e72080e7          	jalr	-398(ra) # 800059d2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b68:	00017797          	auipc	a5,0x17
    80005b6c:	4f878793          	addi	a5,a5,1272 # 8001d060 <cons>
    80005b70:	0a07a703          	lw	a4,160(a5)
    80005b74:	0017069b          	addiw	a3,a4,1
    80005b78:	0006861b          	sext.w	a2,a3
    80005b7c:	0ad7a023          	sw	a3,160(a5)
    80005b80:	07f77713          	andi	a4,a4,127
    80005b84:	97ba                	add	a5,a5,a4
    80005b86:	4729                	li	a4,10
    80005b88:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b8c:	00017797          	auipc	a5,0x17
    80005b90:	56c7a823          	sw	a2,1392(a5) # 8001d0fc <cons+0x9c>
        wakeup(&cons.r);
    80005b94:	00017517          	auipc	a0,0x17
    80005b98:	56450513          	addi	a0,a0,1380 # 8001d0f8 <cons+0x98>
    80005b9c:	ffffc097          	auipc	ra,0xffffc
    80005ba0:	9c2080e7          	jalr	-1598(ra) # 8000155e <wakeup>
    80005ba4:	b575                	j	80005a50 <consoleintr+0x3c>

0000000080005ba6 <consoleinit>:

void
consoleinit(void)
{
    80005ba6:	1141                	addi	sp,sp,-16
    80005ba8:	e406                	sd	ra,8(sp)
    80005baa:	e022                	sd	s0,0(sp)
    80005bac:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bae:	00003597          	auipc	a1,0x3
    80005bb2:	c1258593          	addi	a1,a1,-1006 # 800087c0 <syscalls+0x3f0>
    80005bb6:	00017517          	auipc	a0,0x17
    80005bba:	4aa50513          	addi	a0,a0,1194 # 8001d060 <cons>
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	580080e7          	jalr	1408(ra) # 8000613e <initlock>

  uartinit();
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	32c080e7          	jalr	812(ra) # 80005ef2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bce:	0000e797          	auipc	a5,0xe
    80005bd2:	1ba78793          	addi	a5,a5,442 # 80013d88 <devsw>
    80005bd6:	00000717          	auipc	a4,0x0
    80005bda:	ce870713          	addi	a4,a4,-792 # 800058be <consoleread>
    80005bde:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005be0:	00000717          	auipc	a4,0x0
    80005be4:	c7a70713          	addi	a4,a4,-902 # 8000585a <consolewrite>
    80005be8:	ef98                	sd	a4,24(a5)
}
    80005bea:	60a2                	ld	ra,8(sp)
    80005bec:	6402                	ld	s0,0(sp)
    80005bee:	0141                	addi	sp,sp,16
    80005bf0:	8082                	ret

0000000080005bf2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bf2:	7179                	addi	sp,sp,-48
    80005bf4:	f406                	sd	ra,40(sp)
    80005bf6:	f022                	sd	s0,32(sp)
    80005bf8:	ec26                	sd	s1,24(sp)
    80005bfa:	e84a                	sd	s2,16(sp)
    80005bfc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bfe:	c219                	beqz	a2,80005c04 <printint+0x12>
    80005c00:	08054763          	bltz	a0,80005c8e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c04:	2501                	sext.w	a0,a0
    80005c06:	4881                	li	a7,0
    80005c08:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c0c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c0e:	2581                	sext.w	a1,a1
    80005c10:	00003617          	auipc	a2,0x3
    80005c14:	be060613          	addi	a2,a2,-1056 # 800087f0 <digits>
    80005c18:	883a                	mv	a6,a4
    80005c1a:	2705                	addiw	a4,a4,1
    80005c1c:	02b577bb          	remuw	a5,a0,a1
    80005c20:	1782                	slli	a5,a5,0x20
    80005c22:	9381                	srli	a5,a5,0x20
    80005c24:	97b2                	add	a5,a5,a2
    80005c26:	0007c783          	lbu	a5,0(a5)
    80005c2a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c2e:	0005079b          	sext.w	a5,a0
    80005c32:	02b5553b          	divuw	a0,a0,a1
    80005c36:	0685                	addi	a3,a3,1
    80005c38:	feb7f0e3          	bgeu	a5,a1,80005c18 <printint+0x26>

  if(sign)
    80005c3c:	00088c63          	beqz	a7,80005c54 <printint+0x62>
    buf[i++] = '-';
    80005c40:	fe070793          	addi	a5,a4,-32
    80005c44:	00878733          	add	a4,a5,s0
    80005c48:	02d00793          	li	a5,45
    80005c4c:	fef70823          	sb	a5,-16(a4)
    80005c50:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c54:	02e05763          	blez	a4,80005c82 <printint+0x90>
    80005c58:	fd040793          	addi	a5,s0,-48
    80005c5c:	00e784b3          	add	s1,a5,a4
    80005c60:	fff78913          	addi	s2,a5,-1
    80005c64:	993a                	add	s2,s2,a4
    80005c66:	377d                	addiw	a4,a4,-1
    80005c68:	1702                	slli	a4,a4,0x20
    80005c6a:	9301                	srli	a4,a4,0x20
    80005c6c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c70:	fff4c503          	lbu	a0,-1(s1)
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	d5e080e7          	jalr	-674(ra) # 800059d2 <consputc>
  while(--i >= 0)
    80005c7c:	14fd                	addi	s1,s1,-1
    80005c7e:	ff2499e3          	bne	s1,s2,80005c70 <printint+0x7e>
}
    80005c82:	70a2                	ld	ra,40(sp)
    80005c84:	7402                	ld	s0,32(sp)
    80005c86:	64e2                	ld	s1,24(sp)
    80005c88:	6942                	ld	s2,16(sp)
    80005c8a:	6145                	addi	sp,sp,48
    80005c8c:	8082                	ret
    x = -xx;
    80005c8e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c92:	4885                	li	a7,1
    x = -xx;
    80005c94:	bf95                	j	80005c08 <printint+0x16>

0000000080005c96 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c96:	1101                	addi	sp,sp,-32
    80005c98:	ec06                	sd	ra,24(sp)
    80005c9a:	e822                	sd	s0,16(sp)
    80005c9c:	e426                	sd	s1,8(sp)
    80005c9e:	1000                	addi	s0,sp,32
    80005ca0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ca2:	00017797          	auipc	a5,0x17
    80005ca6:	4607af23          	sw	zero,1150(a5) # 8001d120 <pr+0x18>
  printf("panic: ");
    80005caa:	00003517          	auipc	a0,0x3
    80005cae:	b1e50513          	addi	a0,a0,-1250 # 800087c8 <syscalls+0x3f8>
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	02e080e7          	jalr	46(ra) # 80005ce0 <printf>
  printf(s);
    80005cba:	8526                	mv	a0,s1
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	024080e7          	jalr	36(ra) # 80005ce0 <printf>
  printf("\n");
    80005cc4:	00002517          	auipc	a0,0x2
    80005cc8:	38450513          	addi	a0,a0,900 # 80008048 <etext+0x48>
    80005ccc:	00000097          	auipc	ra,0x0
    80005cd0:	014080e7          	jalr	20(ra) # 80005ce0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cd4:	4785                	li	a5,1
    80005cd6:	00003717          	auipc	a4,0x3
    80005cda:	bef72b23          	sw	a5,-1034(a4) # 800088cc <panicked>
  for(;;)
    80005cde:	a001                	j	80005cde <panic+0x48>

0000000080005ce0 <printf>:
{
    80005ce0:	7131                	addi	sp,sp,-192
    80005ce2:	fc86                	sd	ra,120(sp)
    80005ce4:	f8a2                	sd	s0,112(sp)
    80005ce6:	f4a6                	sd	s1,104(sp)
    80005ce8:	f0ca                	sd	s2,96(sp)
    80005cea:	ecce                	sd	s3,88(sp)
    80005cec:	e8d2                	sd	s4,80(sp)
    80005cee:	e4d6                	sd	s5,72(sp)
    80005cf0:	e0da                	sd	s6,64(sp)
    80005cf2:	fc5e                	sd	s7,56(sp)
    80005cf4:	f862                	sd	s8,48(sp)
    80005cf6:	f466                	sd	s9,40(sp)
    80005cf8:	f06a                	sd	s10,32(sp)
    80005cfa:	ec6e                	sd	s11,24(sp)
    80005cfc:	0100                	addi	s0,sp,128
    80005cfe:	8a2a                	mv	s4,a0
    80005d00:	e40c                	sd	a1,8(s0)
    80005d02:	e810                	sd	a2,16(s0)
    80005d04:	ec14                	sd	a3,24(s0)
    80005d06:	f018                	sd	a4,32(s0)
    80005d08:	f41c                	sd	a5,40(s0)
    80005d0a:	03043823          	sd	a6,48(s0)
    80005d0e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d12:	00017d97          	auipc	s11,0x17
    80005d16:	40edad83          	lw	s11,1038(s11) # 8001d120 <pr+0x18>
  if(locking)
    80005d1a:	020d9b63          	bnez	s11,80005d50 <printf+0x70>
  if (fmt == 0)
    80005d1e:	040a0263          	beqz	s4,80005d62 <printf+0x82>
  va_start(ap, fmt);
    80005d22:	00840793          	addi	a5,s0,8
    80005d26:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2a:	000a4503          	lbu	a0,0(s4)
    80005d2e:	14050f63          	beqz	a0,80005e8c <printf+0x1ac>
    80005d32:	4981                	li	s3,0
    if(c != '%'){
    80005d34:	02500a93          	li	s5,37
    switch(c){
    80005d38:	07000b93          	li	s7,112
  consputc('x');
    80005d3c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d3e:	00003b17          	auipc	s6,0x3
    80005d42:	ab2b0b13          	addi	s6,s6,-1358 # 800087f0 <digits>
    switch(c){
    80005d46:	07300c93          	li	s9,115
    80005d4a:	06400c13          	li	s8,100
    80005d4e:	a82d                	j	80005d88 <printf+0xa8>
    acquire(&pr.lock);
    80005d50:	00017517          	auipc	a0,0x17
    80005d54:	3b850513          	addi	a0,a0,952 # 8001d108 <pr>
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	476080e7          	jalr	1142(ra) # 800061ce <acquire>
    80005d60:	bf7d                	j	80005d1e <printf+0x3e>
    panic("null fmt");
    80005d62:	00003517          	auipc	a0,0x3
    80005d66:	a7650513          	addi	a0,a0,-1418 # 800087d8 <syscalls+0x408>
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	f2c080e7          	jalr	-212(ra) # 80005c96 <panic>
      consputc(c);
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	c60080e7          	jalr	-928(ra) # 800059d2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d7a:	2985                	addiw	s3,s3,1
    80005d7c:	013a07b3          	add	a5,s4,s3
    80005d80:	0007c503          	lbu	a0,0(a5)
    80005d84:	10050463          	beqz	a0,80005e8c <printf+0x1ac>
    if(c != '%'){
    80005d88:	ff5515e3          	bne	a0,s5,80005d72 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d8c:	2985                	addiw	s3,s3,1
    80005d8e:	013a07b3          	add	a5,s4,s3
    80005d92:	0007c783          	lbu	a5,0(a5)
    80005d96:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d9a:	cbed                	beqz	a5,80005e8c <printf+0x1ac>
    switch(c){
    80005d9c:	05778a63          	beq	a5,s7,80005df0 <printf+0x110>
    80005da0:	02fbf663          	bgeu	s7,a5,80005dcc <printf+0xec>
    80005da4:	09978863          	beq	a5,s9,80005e34 <printf+0x154>
    80005da8:	07800713          	li	a4,120
    80005dac:	0ce79563          	bne	a5,a4,80005e76 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005db0:	f8843783          	ld	a5,-120(s0)
    80005db4:	00878713          	addi	a4,a5,8
    80005db8:	f8e43423          	sd	a4,-120(s0)
    80005dbc:	4605                	li	a2,1
    80005dbe:	85ea                	mv	a1,s10
    80005dc0:	4388                	lw	a0,0(a5)
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	e30080e7          	jalr	-464(ra) # 80005bf2 <printint>
      break;
    80005dca:	bf45                	j	80005d7a <printf+0x9a>
    switch(c){
    80005dcc:	09578f63          	beq	a5,s5,80005e6a <printf+0x18a>
    80005dd0:	0b879363          	bne	a5,s8,80005e76 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005dd4:	f8843783          	ld	a5,-120(s0)
    80005dd8:	00878713          	addi	a4,a5,8
    80005ddc:	f8e43423          	sd	a4,-120(s0)
    80005de0:	4605                	li	a2,1
    80005de2:	45a9                	li	a1,10
    80005de4:	4388                	lw	a0,0(a5)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	e0c080e7          	jalr	-500(ra) # 80005bf2 <printint>
      break;
    80005dee:	b771                	j	80005d7a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005df0:	f8843783          	ld	a5,-120(s0)
    80005df4:	00878713          	addi	a4,a5,8
    80005df8:	f8e43423          	sd	a4,-120(s0)
    80005dfc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e00:	03000513          	li	a0,48
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	bce080e7          	jalr	-1074(ra) # 800059d2 <consputc>
  consputc('x');
    80005e0c:	07800513          	li	a0,120
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	bc2080e7          	jalr	-1086(ra) # 800059d2 <consputc>
    80005e18:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e1a:	03c95793          	srli	a5,s2,0x3c
    80005e1e:	97da                	add	a5,a5,s6
    80005e20:	0007c503          	lbu	a0,0(a5)
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	bae080e7          	jalr	-1106(ra) # 800059d2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e2c:	0912                	slli	s2,s2,0x4
    80005e2e:	34fd                	addiw	s1,s1,-1
    80005e30:	f4ed                	bnez	s1,80005e1a <printf+0x13a>
    80005e32:	b7a1                	j	80005d7a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e34:	f8843783          	ld	a5,-120(s0)
    80005e38:	00878713          	addi	a4,a5,8
    80005e3c:	f8e43423          	sd	a4,-120(s0)
    80005e40:	6384                	ld	s1,0(a5)
    80005e42:	cc89                	beqz	s1,80005e5c <printf+0x17c>
      for(; *s; s++)
    80005e44:	0004c503          	lbu	a0,0(s1)
    80005e48:	d90d                	beqz	a0,80005d7a <printf+0x9a>
        consputc(*s);
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b88080e7          	jalr	-1144(ra) # 800059d2 <consputc>
      for(; *s; s++)
    80005e52:	0485                	addi	s1,s1,1
    80005e54:	0004c503          	lbu	a0,0(s1)
    80005e58:	f96d                	bnez	a0,80005e4a <printf+0x16a>
    80005e5a:	b705                	j	80005d7a <printf+0x9a>
        s = "(null)";
    80005e5c:	00003497          	auipc	s1,0x3
    80005e60:	97448493          	addi	s1,s1,-1676 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005e64:	02800513          	li	a0,40
    80005e68:	b7cd                	j	80005e4a <printf+0x16a>
      consputc('%');
    80005e6a:	8556                	mv	a0,s5
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	b66080e7          	jalr	-1178(ra) # 800059d2 <consputc>
      break;
    80005e74:	b719                	j	80005d7a <printf+0x9a>
      consputc('%');
    80005e76:	8556                	mv	a0,s5
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	b5a080e7          	jalr	-1190(ra) # 800059d2 <consputc>
      consputc(c);
    80005e80:	8526                	mv	a0,s1
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	b50080e7          	jalr	-1200(ra) # 800059d2 <consputc>
      break;
    80005e8a:	bdc5                	j	80005d7a <printf+0x9a>
  if(locking)
    80005e8c:	020d9163          	bnez	s11,80005eae <printf+0x1ce>
}
    80005e90:	70e6                	ld	ra,120(sp)
    80005e92:	7446                	ld	s0,112(sp)
    80005e94:	74a6                	ld	s1,104(sp)
    80005e96:	7906                	ld	s2,96(sp)
    80005e98:	69e6                	ld	s3,88(sp)
    80005e9a:	6a46                	ld	s4,80(sp)
    80005e9c:	6aa6                	ld	s5,72(sp)
    80005e9e:	6b06                	ld	s6,64(sp)
    80005ea0:	7be2                	ld	s7,56(sp)
    80005ea2:	7c42                	ld	s8,48(sp)
    80005ea4:	7ca2                	ld	s9,40(sp)
    80005ea6:	7d02                	ld	s10,32(sp)
    80005ea8:	6de2                	ld	s11,24(sp)
    80005eaa:	6129                	addi	sp,sp,192
    80005eac:	8082                	ret
    release(&pr.lock);
    80005eae:	00017517          	auipc	a0,0x17
    80005eb2:	25a50513          	addi	a0,a0,602 # 8001d108 <pr>
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	3cc080e7          	jalr	972(ra) # 80006282 <release>
}
    80005ebe:	bfc9                	j	80005e90 <printf+0x1b0>

0000000080005ec0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ec0:	1101                	addi	sp,sp,-32
    80005ec2:	ec06                	sd	ra,24(sp)
    80005ec4:	e822                	sd	s0,16(sp)
    80005ec6:	e426                	sd	s1,8(sp)
    80005ec8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005eca:	00017497          	auipc	s1,0x17
    80005ece:	23e48493          	addi	s1,s1,574 # 8001d108 <pr>
    80005ed2:	00003597          	auipc	a1,0x3
    80005ed6:	91658593          	addi	a1,a1,-1770 # 800087e8 <syscalls+0x418>
    80005eda:	8526                	mv	a0,s1
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	262080e7          	jalr	610(ra) # 8000613e <initlock>
  pr.locking = 1;
    80005ee4:	4785                	li	a5,1
    80005ee6:	cc9c                	sw	a5,24(s1)
}
    80005ee8:	60e2                	ld	ra,24(sp)
    80005eea:	6442                	ld	s0,16(sp)
    80005eec:	64a2                	ld	s1,8(sp)
    80005eee:	6105                	addi	sp,sp,32
    80005ef0:	8082                	ret

0000000080005ef2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ef2:	1141                	addi	sp,sp,-16
    80005ef4:	e406                	sd	ra,8(sp)
    80005ef6:	e022                	sd	s0,0(sp)
    80005ef8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005efa:	100007b7          	lui	a5,0x10000
    80005efe:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f02:	f8000713          	li	a4,-128
    80005f06:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f0a:	470d                	li	a4,3
    80005f0c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f10:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f14:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f18:	469d                	li	a3,7
    80005f1a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f1e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f22:	00003597          	auipc	a1,0x3
    80005f26:	8e658593          	addi	a1,a1,-1818 # 80008808 <digits+0x18>
    80005f2a:	00017517          	auipc	a0,0x17
    80005f2e:	1fe50513          	addi	a0,a0,510 # 8001d128 <uart_tx_lock>
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	20c080e7          	jalr	524(ra) # 8000613e <initlock>
}
    80005f3a:	60a2                	ld	ra,8(sp)
    80005f3c:	6402                	ld	s0,0(sp)
    80005f3e:	0141                	addi	sp,sp,16
    80005f40:	8082                	ret

0000000080005f42 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f42:	1101                	addi	sp,sp,-32
    80005f44:	ec06                	sd	ra,24(sp)
    80005f46:	e822                	sd	s0,16(sp)
    80005f48:	e426                	sd	s1,8(sp)
    80005f4a:	1000                	addi	s0,sp,32
    80005f4c:	84aa                	mv	s1,a0
  push_off();
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	234080e7          	jalr	564(ra) # 80006182 <push_off>

  if(panicked){
    80005f56:	00003797          	auipc	a5,0x3
    80005f5a:	9767a783          	lw	a5,-1674(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f5e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f62:	c391                	beqz	a5,80005f66 <uartputc_sync+0x24>
    for(;;)
    80005f64:	a001                	j	80005f64 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f66:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f6a:	0207f793          	andi	a5,a5,32
    80005f6e:	dfe5                	beqz	a5,80005f66 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f70:	0ff4f513          	zext.b	a0,s1
    80005f74:	100007b7          	lui	a5,0x10000
    80005f78:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	2a6080e7          	jalr	678(ra) # 80006222 <pop_off>
}
    80005f84:	60e2                	ld	ra,24(sp)
    80005f86:	6442                	ld	s0,16(sp)
    80005f88:	64a2                	ld	s1,8(sp)
    80005f8a:	6105                	addi	sp,sp,32
    80005f8c:	8082                	ret

0000000080005f8e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f8e:	00003797          	auipc	a5,0x3
    80005f92:	9427b783          	ld	a5,-1726(a5) # 800088d0 <uart_tx_r>
    80005f96:	00003717          	auipc	a4,0x3
    80005f9a:	94273703          	ld	a4,-1726(a4) # 800088d8 <uart_tx_w>
    80005f9e:	06f70a63          	beq	a4,a5,80006012 <uartstart+0x84>
{
    80005fa2:	7139                	addi	sp,sp,-64
    80005fa4:	fc06                	sd	ra,56(sp)
    80005fa6:	f822                	sd	s0,48(sp)
    80005fa8:	f426                	sd	s1,40(sp)
    80005faa:	f04a                	sd	s2,32(sp)
    80005fac:	ec4e                	sd	s3,24(sp)
    80005fae:	e852                	sd	s4,16(sp)
    80005fb0:	e456                	sd	s5,8(sp)
    80005fb2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fb8:	00017a17          	auipc	s4,0x17
    80005fbc:	170a0a13          	addi	s4,s4,368 # 8001d128 <uart_tx_lock>
    uart_tx_r += 1;
    80005fc0:	00003497          	auipc	s1,0x3
    80005fc4:	91048493          	addi	s1,s1,-1776 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fc8:	00003997          	auipc	s3,0x3
    80005fcc:	91098993          	addi	s3,s3,-1776 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fd4:	02077713          	andi	a4,a4,32
    80005fd8:	c705                	beqz	a4,80006000 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fda:	01f7f713          	andi	a4,a5,31
    80005fde:	9752                	add	a4,a4,s4
    80005fe0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fe4:	0785                	addi	a5,a5,1
    80005fe6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fe8:	8526                	mv	a0,s1
    80005fea:	ffffb097          	auipc	ra,0xffffb
    80005fee:	574080e7          	jalr	1396(ra) # 8000155e <wakeup>
    
    WriteReg(THR, c);
    80005ff2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ff6:	609c                	ld	a5,0(s1)
    80005ff8:	0009b703          	ld	a4,0(s3)
    80005ffc:	fcf71ae3          	bne	a4,a5,80005fd0 <uartstart+0x42>
  }
}
    80006000:	70e2                	ld	ra,56(sp)
    80006002:	7442                	ld	s0,48(sp)
    80006004:	74a2                	ld	s1,40(sp)
    80006006:	7902                	ld	s2,32(sp)
    80006008:	69e2                	ld	s3,24(sp)
    8000600a:	6a42                	ld	s4,16(sp)
    8000600c:	6aa2                	ld	s5,8(sp)
    8000600e:	6121                	addi	sp,sp,64
    80006010:	8082                	ret
    80006012:	8082                	ret

0000000080006014 <uartputc>:
{
    80006014:	7179                	addi	sp,sp,-48
    80006016:	f406                	sd	ra,40(sp)
    80006018:	f022                	sd	s0,32(sp)
    8000601a:	ec26                	sd	s1,24(sp)
    8000601c:	e84a                	sd	s2,16(sp)
    8000601e:	e44e                	sd	s3,8(sp)
    80006020:	e052                	sd	s4,0(sp)
    80006022:	1800                	addi	s0,sp,48
    80006024:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006026:	00017517          	auipc	a0,0x17
    8000602a:	10250513          	addi	a0,a0,258 # 8001d128 <uart_tx_lock>
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	1a0080e7          	jalr	416(ra) # 800061ce <acquire>
  if(panicked){
    80006036:	00003797          	auipc	a5,0x3
    8000603a:	8967a783          	lw	a5,-1898(a5) # 800088cc <panicked>
    8000603e:	e7c9                	bnez	a5,800060c8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006040:	00003717          	auipc	a4,0x3
    80006044:	89873703          	ld	a4,-1896(a4) # 800088d8 <uart_tx_w>
    80006048:	00003797          	auipc	a5,0x3
    8000604c:	8887b783          	ld	a5,-1912(a5) # 800088d0 <uart_tx_r>
    80006050:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006054:	00017997          	auipc	s3,0x17
    80006058:	0d498993          	addi	s3,s3,212 # 8001d128 <uart_tx_lock>
    8000605c:	00003497          	auipc	s1,0x3
    80006060:	87448493          	addi	s1,s1,-1932 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006064:	00003917          	auipc	s2,0x3
    80006068:	87490913          	addi	s2,s2,-1932 # 800088d8 <uart_tx_w>
    8000606c:	00e79f63          	bne	a5,a4,8000608a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006070:	85ce                	mv	a1,s3
    80006072:	8526                	mv	a0,s1
    80006074:	ffffb097          	auipc	ra,0xffffb
    80006078:	486080e7          	jalr	1158(ra) # 800014fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607c:	00093703          	ld	a4,0(s2)
    80006080:	609c                	ld	a5,0(s1)
    80006082:	02078793          	addi	a5,a5,32
    80006086:	fee785e3          	beq	a5,a4,80006070 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000608a:	00017497          	auipc	s1,0x17
    8000608e:	09e48493          	addi	s1,s1,158 # 8001d128 <uart_tx_lock>
    80006092:	01f77793          	andi	a5,a4,31
    80006096:	97a6                	add	a5,a5,s1
    80006098:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000609c:	0705                	addi	a4,a4,1
    8000609e:	00003797          	auipc	a5,0x3
    800060a2:	82e7bd23          	sd	a4,-1990(a5) # 800088d8 <uart_tx_w>
  uartstart();
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	ee8080e7          	jalr	-280(ra) # 80005f8e <uartstart>
  release(&uart_tx_lock);
    800060ae:	8526                	mv	a0,s1
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	1d2080e7          	jalr	466(ra) # 80006282 <release>
}
    800060b8:	70a2                	ld	ra,40(sp)
    800060ba:	7402                	ld	s0,32(sp)
    800060bc:	64e2                	ld	s1,24(sp)
    800060be:	6942                	ld	s2,16(sp)
    800060c0:	69a2                	ld	s3,8(sp)
    800060c2:	6a02                	ld	s4,0(sp)
    800060c4:	6145                	addi	sp,sp,48
    800060c6:	8082                	ret
    for(;;)
    800060c8:	a001                	j	800060c8 <uartputc+0xb4>

00000000800060ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ca:	1141                	addi	sp,sp,-16
    800060cc:	e422                	sd	s0,8(sp)
    800060ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060d0:	100007b7          	lui	a5,0x10000
    800060d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060d8:	8b85                	andi	a5,a5,1
    800060da:	cb81                	beqz	a5,800060ea <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060dc:	100007b7          	lui	a5,0x10000
    800060e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060e4:	6422                	ld	s0,8(sp)
    800060e6:	0141                	addi	sp,sp,16
    800060e8:	8082                	ret
    return -1;
    800060ea:	557d                	li	a0,-1
    800060ec:	bfe5                	j	800060e4 <uartgetc+0x1a>

00000000800060ee <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060ee:	1101                	addi	sp,sp,-32
    800060f0:	ec06                	sd	ra,24(sp)
    800060f2:	e822                	sd	s0,16(sp)
    800060f4:	e426                	sd	s1,8(sp)
    800060f6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060f8:	54fd                	li	s1,-1
    800060fa:	a029                	j	80006104 <uartintr+0x16>
      break;
    consoleintr(c);
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	918080e7          	jalr	-1768(ra) # 80005a14 <consoleintr>
    int c = uartgetc();
    80006104:	00000097          	auipc	ra,0x0
    80006108:	fc6080e7          	jalr	-58(ra) # 800060ca <uartgetc>
    if(c == -1)
    8000610c:	fe9518e3          	bne	a0,s1,800060fc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006110:	00017497          	auipc	s1,0x17
    80006114:	01848493          	addi	s1,s1,24 # 8001d128 <uart_tx_lock>
    80006118:	8526                	mv	a0,s1
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	0b4080e7          	jalr	180(ra) # 800061ce <acquire>
  uartstart();
    80006122:	00000097          	auipc	ra,0x0
    80006126:	e6c080e7          	jalr	-404(ra) # 80005f8e <uartstart>
  release(&uart_tx_lock);
    8000612a:	8526                	mv	a0,s1
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	156080e7          	jalr	342(ra) # 80006282 <release>
}
    80006134:	60e2                	ld	ra,24(sp)
    80006136:	6442                	ld	s0,16(sp)
    80006138:	64a2                	ld	s1,8(sp)
    8000613a:	6105                	addi	sp,sp,32
    8000613c:	8082                	ret

000000008000613e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000613e:	1141                	addi	sp,sp,-16
    80006140:	e422                	sd	s0,8(sp)
    80006142:	0800                	addi	s0,sp,16
  lk->name = name;
    80006144:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006146:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000614a:	00053823          	sd	zero,16(a0)
}
    8000614e:	6422                	ld	s0,8(sp)
    80006150:	0141                	addi	sp,sp,16
    80006152:	8082                	ret

0000000080006154 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006154:	411c                	lw	a5,0(a0)
    80006156:	e399                	bnez	a5,8000615c <holding+0x8>
    80006158:	4501                	li	a0,0
  return r;
}
    8000615a:	8082                	ret
{
    8000615c:	1101                	addi	sp,sp,-32
    8000615e:	ec06                	sd	ra,24(sp)
    80006160:	e822                	sd	s0,16(sp)
    80006162:	e426                	sd	s1,8(sp)
    80006164:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006166:	6904                	ld	s1,16(a0)
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	cce080e7          	jalr	-818(ra) # 80000e36 <mycpu>
    80006170:	40a48533          	sub	a0,s1,a0
    80006174:	00153513          	seqz	a0,a0
}
    80006178:	60e2                	ld	ra,24(sp)
    8000617a:	6442                	ld	s0,16(sp)
    8000617c:	64a2                	ld	s1,8(sp)
    8000617e:	6105                	addi	sp,sp,32
    80006180:	8082                	ret

0000000080006182 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006182:	1101                	addi	sp,sp,-32
    80006184:	ec06                	sd	ra,24(sp)
    80006186:	e822                	sd	s0,16(sp)
    80006188:	e426                	sd	s1,8(sp)
    8000618a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000618c:	100024f3          	csrr	s1,sstatus
    80006190:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006194:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006196:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000619a:	ffffb097          	auipc	ra,0xffffb
    8000619e:	c9c080e7          	jalr	-868(ra) # 80000e36 <mycpu>
    800061a2:	5d3c                	lw	a5,120(a0)
    800061a4:	cf89                	beqz	a5,800061be <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061a6:	ffffb097          	auipc	ra,0xffffb
    800061aa:	c90080e7          	jalr	-880(ra) # 80000e36 <mycpu>
    800061ae:	5d3c                	lw	a5,120(a0)
    800061b0:	2785                	addiw	a5,a5,1
    800061b2:	dd3c                	sw	a5,120(a0)
}
    800061b4:	60e2                	ld	ra,24(sp)
    800061b6:	6442                	ld	s0,16(sp)
    800061b8:	64a2                	ld	s1,8(sp)
    800061ba:	6105                	addi	sp,sp,32
    800061bc:	8082                	ret
    mycpu()->intena = old;
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	c78080e7          	jalr	-904(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061c6:	8085                	srli	s1,s1,0x1
    800061c8:	8885                	andi	s1,s1,1
    800061ca:	dd64                	sw	s1,124(a0)
    800061cc:	bfe9                	j	800061a6 <push_off+0x24>

00000000800061ce <acquire>:
{
    800061ce:	1101                	addi	sp,sp,-32
    800061d0:	ec06                	sd	ra,24(sp)
    800061d2:	e822                	sd	s0,16(sp)
    800061d4:	e426                	sd	s1,8(sp)
    800061d6:	1000                	addi	s0,sp,32
    800061d8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061da:	00000097          	auipc	ra,0x0
    800061de:	fa8080e7          	jalr	-88(ra) # 80006182 <push_off>
  if(holding(lk))
    800061e2:	8526                	mv	a0,s1
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	f70080e7          	jalr	-144(ra) # 80006154 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ec:	4705                	li	a4,1
  if(holding(lk))
    800061ee:	e115                	bnez	a0,80006212 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f0:	87ba                	mv	a5,a4
    800061f2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061f6:	2781                	sext.w	a5,a5
    800061f8:	ffe5                	bnez	a5,800061f0 <acquire+0x22>
  __sync_synchronize();
    800061fa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061fe:	ffffb097          	auipc	ra,0xffffb
    80006202:	c38080e7          	jalr	-968(ra) # 80000e36 <mycpu>
    80006206:	e888                	sd	a0,16(s1)
}
    80006208:	60e2                	ld	ra,24(sp)
    8000620a:	6442                	ld	s0,16(sp)
    8000620c:	64a2                	ld	s1,8(sp)
    8000620e:	6105                	addi	sp,sp,32
    80006210:	8082                	ret
    panic("acquire");
    80006212:	00002517          	auipc	a0,0x2
    80006216:	5fe50513          	addi	a0,a0,1534 # 80008810 <digits+0x20>
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	a7c080e7          	jalr	-1412(ra) # 80005c96 <panic>

0000000080006222 <pop_off>:

void
pop_off(void)
{
    80006222:	1141                	addi	sp,sp,-16
    80006224:	e406                	sd	ra,8(sp)
    80006226:	e022                	sd	s0,0(sp)
    80006228:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000622a:	ffffb097          	auipc	ra,0xffffb
    8000622e:	c0c080e7          	jalr	-1012(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006232:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006236:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006238:	e78d                	bnez	a5,80006262 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000623a:	5d3c                	lw	a5,120(a0)
    8000623c:	02f05b63          	blez	a5,80006272 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006240:	37fd                	addiw	a5,a5,-1
    80006242:	0007871b          	sext.w	a4,a5
    80006246:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006248:	eb09                	bnez	a4,8000625a <pop_off+0x38>
    8000624a:	5d7c                	lw	a5,124(a0)
    8000624c:	c799                	beqz	a5,8000625a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000624e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006252:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006256:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000625a:	60a2                	ld	ra,8(sp)
    8000625c:	6402                	ld	s0,0(sp)
    8000625e:	0141                	addi	sp,sp,16
    80006260:	8082                	ret
    panic("pop_off - interruptible");
    80006262:	00002517          	auipc	a0,0x2
    80006266:	5b650513          	addi	a0,a0,1462 # 80008818 <digits+0x28>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	a2c080e7          	jalr	-1492(ra) # 80005c96 <panic>
    panic("pop_off");
    80006272:	00002517          	auipc	a0,0x2
    80006276:	5be50513          	addi	a0,a0,1470 # 80008830 <digits+0x40>
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	a1c080e7          	jalr	-1508(ra) # 80005c96 <panic>

0000000080006282 <release>:
{
    80006282:	1101                	addi	sp,sp,-32
    80006284:	ec06                	sd	ra,24(sp)
    80006286:	e822                	sd	s0,16(sp)
    80006288:	e426                	sd	s1,8(sp)
    8000628a:	1000                	addi	s0,sp,32
    8000628c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	ec6080e7          	jalr	-314(ra) # 80006154 <holding>
    80006296:	c115                	beqz	a0,800062ba <release+0x38>
  lk->cpu = 0;
    80006298:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000629c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062a0:	0f50000f          	fence	iorw,ow
    800062a4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	f7a080e7          	jalr	-134(ra) # 80006222 <pop_off>
}
    800062b0:	60e2                	ld	ra,24(sp)
    800062b2:	6442                	ld	s0,16(sp)
    800062b4:	64a2                	ld	s1,8(sp)
    800062b6:	6105                	addi	sp,sp,32
    800062b8:	8082                	ret
    panic("release");
    800062ba:	00002517          	auipc	a0,0x2
    800062be:	57e50513          	addi	a0,a0,1406 # 80008838 <digits+0x48>
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	9d4080e7          	jalr	-1580(ra) # 80005c96 <panic>
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
