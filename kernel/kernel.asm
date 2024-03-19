
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
    80000016:	750050ef          	jal	ra,80005766 <start>

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
    80000034:	15078793          	addi	a5,a5,336 # 80022180 <end>
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
    8000005e:	154080e7          	jalr	340(ra) # 800061ae <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1f4080e7          	jalr	500(ra) # 80006262 <release>
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
    8000008e:	c16080e7          	jalr	-1002(ra) # 80005ca0 <panic>

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
    800000fa:	028080e7          	jalr	40(ra) # 8000611e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	07e50513          	addi	a0,a0,126 # 80022180 <end>
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
    80000132:	080080e7          	jalr	128(ra) # 800061ae <acquire>
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
    8000014a:	11c080e7          	jalr	284(ra) # 80006262 <release>

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
    80000174:	0f2080e7          	jalr	242(ra) # 80006262 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdce81>
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
    80000358:	99e080e7          	jalr	-1634(ra) # 80005cf2 <printf>
    kvminithart();    // turn on paging
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	0d8080e7          	jalr	216(ra) # 80000434 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000364:	00001097          	auipc	ra,0x1
    80000368:	7e4080e7          	jalr	2020(ra) # 80001b48 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036c:	00005097          	auipc	ra,0x5
    80000370:	db4080e7          	jalr	-588(ra) # 80005120 <plicinithart>
  }

  scheduler();        
    80000374:	00001097          	auipc	ra,0x1
    80000378:	fec080e7          	jalr	-20(ra) # 80001360 <scheduler>
    consoleinit();
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	7aa080e7          	jalr	1962(ra) # 80005b26 <consoleinit>
    printfinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	892080e7          	jalr	-1902(ra) # 80005c16 <printfinit>
    printf("\n");
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	cbc50513          	addi	a0,a0,-836 # 80008048 <etext+0x48>
    80000394:	00006097          	auipc	ra,0x6
    80000398:	95e080e7          	jalr	-1698(ra) # 80005cf2 <printf>
    printf("xv6 kernel is booting\n");
    8000039c:	00008517          	auipc	a0,0x8
    800003a0:	c8450513          	addi	a0,a0,-892 # 80008020 <etext+0x20>
    800003a4:	00006097          	auipc	ra,0x6
    800003a8:	94e080e7          	jalr	-1714(ra) # 80005cf2 <printf>
    printf("\n");
    800003ac:	00008517          	auipc	a0,0x8
    800003b0:	c9c50513          	addi	a0,a0,-868 # 80008048 <etext+0x48>
    800003b4:	00006097          	auipc	ra,0x6
    800003b8:	93e080e7          	jalr	-1730(ra) # 80005cf2 <printf>
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
    800003e0:	744080e7          	jalr	1860(ra) # 80001b20 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	764080e7          	jalr	1892(ra) # 80001b48 <trapinithart>
    plicinit();      // set up interrupt controller
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	d1e080e7          	jalr	-738(ra) # 8000510a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d2c080e7          	jalr	-724(ra) # 80005120 <plicinithart>
    binit();         // buffer cache
    800003fc:	00002097          	auipc	ra,0x2
    80000400:	f26080e7          	jalr	-218(ra) # 80002322 <binit>
    iinit();         // inode table
    80000404:	00002097          	auipc	ra,0x2
    80000408:	5c4080e7          	jalr	1476(ra) # 800029c8 <iinit>
    fileinit();      // file table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	53a080e7          	jalr	1338(ra) # 80003946 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000414:	00005097          	auipc	ra,0x5
    80000418:	e14080e7          	jalr	-492(ra) # 80005228 <virtio_disk_init>
    userinit();      // first user process
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	d26080e7          	jalr	-730(ra) # 80001142 <userinit>
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
    8000048e:	816080e7          	jalr	-2026(ra) # 80005ca0 <panic>
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
    800004bc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdce77>
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
    800005b4:	6f0080e7          	jalr	1776(ra) # 80005ca0 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	6e0080e7          	jalr	1760(ra) # 80005ca0 <panic>
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
    80000610:	694080e7          	jalr	1684(ra) # 80005ca0 <panic>

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
    8000075c:	548080e7          	jalr	1352(ra) # 80005ca0 <panic>
      panic("uvmunmap: walk");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	93850513          	addi	a0,a0,-1736 # 80008098 <etext+0x98>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	538080e7          	jalr	1336(ra) # 80005ca0 <panic>
      panic("uvmunmap: not mapped");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	93850513          	addi	a0,a0,-1736 # 800080a8 <etext+0xa8>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	528080e7          	jalr	1320(ra) # 80005ca0 <panic>
      panic("uvmunmap: not a leaf");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	94050513          	addi	a0,a0,-1728 # 800080c0 <etext+0xc0>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	518080e7          	jalr	1304(ra) # 80005ca0 <panic>
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
    8000086a:	43a080e7          	jalr	1082(ra) # 80005ca0 <panic>

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
    800009b6:	2ee080e7          	jalr	750(ra) # 80005ca0 <panic>
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
    80000a94:	210080e7          	jalr	528(ra) # 80005ca0 <panic>
      panic("uvmcopy: page not present");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	200080e7          	jalr	512(ra) # 80005ca0 <panic>
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
    80000b0e:	196080e7          	jalr	406(ra) # 80005ca0 <panic>

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
    80000cb0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdce80>
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
    80000d10:	e54a0a13          	addi	s4,s4,-428 # 8000eb60 <tickslock>
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
    80000d46:	17848493          	addi	s1,s1,376
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
    80000d6e:	f36080e7          	jalr	-202(ra) # 80005ca0 <panic>

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
    80000d9a:	388080e7          	jalr	904(ra) # 8000611e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d9e:	00007597          	auipc	a1,0x7
    80000da2:	3ca58593          	addi	a1,a1,970 # 80008168 <etext+0x168>
    80000da6:	00008517          	auipc	a0,0x8
    80000daa:	ba250513          	addi	a0,a0,-1118 # 80008948 <wait_lock>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	370080e7          	jalr	880(ra) # 8000611e <initlock>
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
    80000ddc:	d8898993          	addi	s3,s3,-632 # 8000eb60 <tickslock>
      initlock(&p->lock, "proc");
    80000de0:	85da                	mv	a1,s6
    80000de2:	8526                	mv	a0,s1
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	33a080e7          	jalr	826(ra) # 8000611e <initlock>
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
    80000e0a:	17848493          	addi	s1,s1,376
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
    80000e60:	306080e7          	jalr	774(ra) # 80006162 <push_off>
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
    80000e7a:	38c080e7          	jalr	908(ra) # 80006202 <pop_off>
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
    80000e9e:	3c8080e7          	jalr	968(ra) # 80006262 <release>

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
    80000eb0:	cb4080e7          	jalr	-844(ra) # 80001b60 <usertrapret>
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
    80000eca:	a82080e7          	jalr	-1406(ra) # 80002948 <fsinit>
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
    80000eea:	2c8080e7          	jalr	712(ra) # 800061ae <acquire>
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
    80000f04:	362080e7          	jalr	866(ra) # 80006262 <release>
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
  p->ticks = 0;
    8000104e:	1604a423          	sw	zero,360(s1)
  p->alarm_past = 0;
    80001052:	1604a623          	sw	zero,364(s1)
  p->handler = 0;
    80001056:	1604b823          	sd	zero,368(s1)
  p->state = UNUSED;
    8000105a:	0004ac23          	sw	zero,24(s1)
}
    8000105e:	60e2                	ld	ra,24(sp)
    80001060:	6442                	ld	s0,16(sp)
    80001062:	64a2                	ld	s1,8(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret

0000000080001068 <allocproc>:
{
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	e04a                	sd	s2,0(sp)
    80001072:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001074:	00008497          	auipc	s1,0x8
    80001078:	cec48493          	addi	s1,s1,-788 # 80008d60 <proc>
    8000107c:	0000e917          	auipc	s2,0xe
    80001080:	ae490913          	addi	s2,s2,-1308 # 8000eb60 <tickslock>
    acquire(&p->lock);
    80001084:	8526                	mv	a0,s1
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	128080e7          	jalr	296(ra) # 800061ae <acquire>
    if(p->state == UNUSED) {
    8000108e:	4c9c                	lw	a5,24(s1)
    80001090:	cf81                	beqz	a5,800010a8 <allocproc+0x40>
      release(&p->lock);
    80001092:	8526                	mv	a0,s1
    80001094:	00005097          	auipc	ra,0x5
    80001098:	1ce080e7          	jalr	462(ra) # 80006262 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109c:	17848493          	addi	s1,s1,376
    800010a0:	ff2492e3          	bne	s1,s2,80001084 <allocproc+0x1c>
  return 0;
    800010a4:	4481                	li	s1,0
    800010a6:	a8b9                	j	80001104 <allocproc+0x9c>
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
    800010c2:	c921                	beqz	a0,80001112 <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e50080e7          	jalr	-432(ra) # 80000f16 <proc_pagetable>
    800010ce:	892a                	mv	s2,a0
    800010d0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d2:	cd21                	beqz	a0,8000112a <allocproc+0xc2>
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
  p->ticks = 0;
    800010f8:	1604a423          	sw	zero,360(s1)
  p->alarm_past = 0;
    800010fc:	1604a623          	sw	zero,364(s1)
  p->handler = (void*)0;
    80001100:	1604b823          	sd	zero,368(s1)
}
    80001104:	8526                	mv	a0,s1
    80001106:	60e2                	ld	ra,24(sp)
    80001108:	6442                	ld	s0,16(sp)
    8000110a:	64a2                	ld	s1,8(sp)
    8000110c:	6902                	ld	s2,0(sp)
    8000110e:	6105                	addi	sp,sp,32
    80001110:	8082                	ret
    freeproc(p);
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	ef0080e7          	jalr	-272(ra) # 80001004 <freeproc>
    release(&p->lock);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00005097          	auipc	ra,0x5
    80001122:	144080e7          	jalr	324(ra) # 80006262 <release>
    return 0;
    80001126:	84ca                	mv	s1,s2
    80001128:	bff1                	j	80001104 <allocproc+0x9c>
    freeproc(p);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	ed8080e7          	jalr	-296(ra) # 80001004 <freeproc>
    release(&p->lock);
    80001134:	8526                	mv	a0,s1
    80001136:	00005097          	auipc	ra,0x5
    8000113a:	12c080e7          	jalr	300(ra) # 80006262 <release>
    return 0;
    8000113e:	84ca                	mv	s1,s2
    80001140:	b7d1                	j	80001104 <allocproc+0x9c>

0000000080001142 <userinit>:
{
    80001142:	1101                	addi	sp,sp,-32
    80001144:	ec06                	sd	ra,24(sp)
    80001146:	e822                	sd	s0,16(sp)
    80001148:	e426                	sd	s1,8(sp)
    8000114a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f1c080e7          	jalr	-228(ra) # 80001068 <allocproc>
    80001154:	84aa                	mv	s1,a0
  initproc = p;
    80001156:	00007797          	auipc	a5,0x7
    8000115a:	78a7bd23          	sd	a0,1946(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000115e:	03400613          	li	a2,52
    80001162:	00007597          	auipc	a1,0x7
    80001166:	71e58593          	addi	a1,a1,1822 # 80008880 <initcode>
    8000116a:	6928                	ld	a0,80(a0)
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	690080e7          	jalr	1680(ra) # 800007fc <uvmfirst>
  p->sz = PGSIZE;
    80001174:	6785                	lui	a5,0x1
    80001176:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001178:	6cb8                	ld	a4,88(s1)
    8000117a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000117e:	6cb8                	ld	a4,88(s1)
    80001180:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001182:	4641                	li	a2,16
    80001184:	00007597          	auipc	a1,0x7
    80001188:	ffc58593          	addi	a1,a1,-4 # 80008180 <etext+0x180>
    8000118c:	15848513          	addi	a0,s1,344
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	132080e7          	jalr	306(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    80001198:	00007517          	auipc	a0,0x7
    8000119c:	ff850513          	addi	a0,a0,-8 # 80008190 <etext+0x190>
    800011a0:	00002097          	auipc	ra,0x2
    800011a4:	1c6080e7          	jalr	454(ra) # 80003366 <namei>
    800011a8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ac:	478d                	li	a5,3
    800011ae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00005097          	auipc	ra,0x5
    800011b6:	0b0080e7          	jalr	176(ra) # 80006262 <release>
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <growproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
    800011d0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	c80080e7          	jalr	-896(ra) # 80000e52 <myproc>
    800011da:	84aa                	mv	s1,a0
  sz = p->sz;
    800011dc:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011de:	01204c63          	bgtz	s2,800011f6 <growproc+0x32>
  } else if(n < 0){
    800011e2:	02094663          	bltz	s2,8000120e <growproc+0x4a>
  p->sz = sz;
    800011e6:	e4ac                	sd	a1,72(s1)
  return 0;
    800011e8:	4501                	li	a0,0
}
    800011ea:	60e2                	ld	ra,24(sp)
    800011ec:	6442                	ld	s0,16(sp)
    800011ee:	64a2                	ld	s1,8(sp)
    800011f0:	6902                	ld	s2,0(sp)
    800011f2:	6105                	addi	sp,sp,32
    800011f4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011f6:	4691                	li	a3,4
    800011f8:	00b90633          	add	a2,s2,a1
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	6b8080e7          	jalr	1720(ra) # 800008b6 <uvmalloc>
    80001206:	85aa                	mv	a1,a0
    80001208:	fd79                	bnez	a0,800011e6 <growproc+0x22>
      return -1;
    8000120a:	557d                	li	a0,-1
    8000120c:	bff9                	j	800011ea <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120e:	00b90633          	add	a2,s2,a1
    80001212:	6928                	ld	a0,80(a0)
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	65a080e7          	jalr	1626(ra) # 8000086e <uvmdealloc>
    8000121c:	85aa                	mv	a1,a0
    8000121e:	b7e1                	j	800011e6 <growproc+0x22>

0000000080001220 <fork>:
{
    80001220:	7139                	addi	sp,sp,-64
    80001222:	fc06                	sd	ra,56(sp)
    80001224:	f822                	sd	s0,48(sp)
    80001226:	f426                	sd	s1,40(sp)
    80001228:	f04a                	sd	s2,32(sp)
    8000122a:	ec4e                	sd	s3,24(sp)
    8000122c:	e852                	sd	s4,16(sp)
    8000122e:	e456                	sd	s5,8(sp)
    80001230:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001232:	00000097          	auipc	ra,0x0
    80001236:	c20080e7          	jalr	-992(ra) # 80000e52 <myproc>
    8000123a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	e2c080e7          	jalr	-468(ra) # 80001068 <allocproc>
    80001244:	10050c63          	beqz	a0,8000135c <fork+0x13c>
    80001248:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000124a:	048ab603          	ld	a2,72(s5)
    8000124e:	692c                	ld	a1,80(a0)
    80001250:	050ab503          	ld	a0,80(s5)
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	7ba080e7          	jalr	1978(ra) # 80000a0e <uvmcopy>
    8000125c:	04054863          	bltz	a0,800012ac <fork+0x8c>
  np->sz = p->sz;
    80001260:	048ab783          	ld	a5,72(s5)
    80001264:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001268:	058ab683          	ld	a3,88(s5)
    8000126c:	87b6                	mv	a5,a3
    8000126e:	058a3703          	ld	a4,88(s4)
    80001272:	12068693          	addi	a3,a3,288
    80001276:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000127a:	6788                	ld	a0,8(a5)
    8000127c:	6b8c                	ld	a1,16(a5)
    8000127e:	6f90                	ld	a2,24(a5)
    80001280:	01073023          	sd	a6,0(a4)
    80001284:	e708                	sd	a0,8(a4)
    80001286:	eb0c                	sd	a1,16(a4)
    80001288:	ef10                	sd	a2,24(a4)
    8000128a:	02078793          	addi	a5,a5,32
    8000128e:	02070713          	addi	a4,a4,32
    80001292:	fed792e3          	bne	a5,a3,80001276 <fork+0x56>
  np->trapframe->a0 = 0;
    80001296:	058a3783          	ld	a5,88(s4)
    8000129a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000129e:	0d0a8493          	addi	s1,s5,208
    800012a2:	0d0a0913          	addi	s2,s4,208
    800012a6:	150a8993          	addi	s3,s5,336
    800012aa:	a00d                	j	800012cc <fork+0xac>
    freeproc(np);
    800012ac:	8552                	mv	a0,s4
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	d56080e7          	jalr	-682(ra) # 80001004 <freeproc>
    release(&np->lock);
    800012b6:	8552                	mv	a0,s4
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	faa080e7          	jalr	-86(ra) # 80006262 <release>
    return -1;
    800012c0:	597d                	li	s2,-1
    800012c2:	a059                	j	80001348 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012c4:	04a1                	addi	s1,s1,8
    800012c6:	0921                	addi	s2,s2,8
    800012c8:	01348b63          	beq	s1,s3,800012de <fork+0xbe>
    if(p->ofile[i])
    800012cc:	6088                	ld	a0,0(s1)
    800012ce:	d97d                	beqz	a0,800012c4 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012d0:	00002097          	auipc	ra,0x2
    800012d4:	708080e7          	jalr	1800(ra) # 800039d8 <filedup>
    800012d8:	00a93023          	sd	a0,0(s2)
    800012dc:	b7e5                	j	800012c4 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012de:	150ab503          	ld	a0,336(s5)
    800012e2:	00002097          	auipc	ra,0x2
    800012e6:	8a0080e7          	jalr	-1888(ra) # 80002b82 <idup>
    800012ea:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012ee:	4641                	li	a2,16
    800012f0:	158a8593          	addi	a1,s5,344
    800012f4:	158a0513          	addi	a0,s4,344
    800012f8:	fffff097          	auipc	ra,0xfffff
    800012fc:	fca080e7          	jalr	-54(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001300:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001304:	8552                	mv	a0,s4
    80001306:	00005097          	auipc	ra,0x5
    8000130a:	f5c080e7          	jalr	-164(ra) # 80006262 <release>
  acquire(&wait_lock);
    8000130e:	00007497          	auipc	s1,0x7
    80001312:	63a48493          	addi	s1,s1,1594 # 80008948 <wait_lock>
    80001316:	8526                	mv	a0,s1
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	e96080e7          	jalr	-362(ra) # 800061ae <acquire>
  np->parent = p;
    80001320:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001324:	8526                	mv	a0,s1
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	f3c080e7          	jalr	-196(ra) # 80006262 <release>
  acquire(&np->lock);
    8000132e:	8552                	mv	a0,s4
    80001330:	00005097          	auipc	ra,0x5
    80001334:	e7e080e7          	jalr	-386(ra) # 800061ae <acquire>
  np->state = RUNNABLE;
    80001338:	478d                	li	a5,3
    8000133a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000133e:	8552                	mv	a0,s4
    80001340:	00005097          	auipc	ra,0x5
    80001344:	f22080e7          	jalr	-222(ra) # 80006262 <release>
}
    80001348:	854a                	mv	a0,s2
    8000134a:	70e2                	ld	ra,56(sp)
    8000134c:	7442                	ld	s0,48(sp)
    8000134e:	74a2                	ld	s1,40(sp)
    80001350:	7902                	ld	s2,32(sp)
    80001352:	69e2                	ld	s3,24(sp)
    80001354:	6a42                	ld	s4,16(sp)
    80001356:	6aa2                	ld	s5,8(sp)
    80001358:	6121                	addi	sp,sp,64
    8000135a:	8082                	ret
    return -1;
    8000135c:	597d                	li	s2,-1
    8000135e:	b7ed                	j	80001348 <fork+0x128>

0000000080001360 <scheduler>:
{
    80001360:	7139                	addi	sp,sp,-64
    80001362:	fc06                	sd	ra,56(sp)
    80001364:	f822                	sd	s0,48(sp)
    80001366:	f426                	sd	s1,40(sp)
    80001368:	f04a                	sd	s2,32(sp)
    8000136a:	ec4e                	sd	s3,24(sp)
    8000136c:	e852                	sd	s4,16(sp)
    8000136e:	e456                	sd	s5,8(sp)
    80001370:	e05a                	sd	s6,0(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8792                	mv	a5,tp
  int id = r_tp();
    80001376:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001378:	00779a93          	slli	s5,a5,0x7
    8000137c:	00007717          	auipc	a4,0x7
    80001380:	5b470713          	addi	a4,a4,1460 # 80008930 <pid_lock>
    80001384:	9756                	add	a4,a4,s5
    80001386:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000138a:	00007717          	auipc	a4,0x7
    8000138e:	5de70713          	addi	a4,a4,1502 # 80008968 <cpus+0x8>
    80001392:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001394:	498d                	li	s3,3
        p->state = RUNNING;
    80001396:	4b11                	li	s6,4
        c->proc = p;
    80001398:	079e                	slli	a5,a5,0x7
    8000139a:	00007a17          	auipc	s4,0x7
    8000139e:	596a0a13          	addi	s4,s4,1430 # 80008930 <pid_lock>
    800013a2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a4:	0000d917          	auipc	s2,0xd
    800013a8:	7bc90913          	addi	s2,s2,1980 # 8000eb60 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b4:	10079073          	csrw	sstatus,a5
    800013b8:	00008497          	auipc	s1,0x8
    800013bc:	9a848493          	addi	s1,s1,-1624 # 80008d60 <proc>
    800013c0:	a811                	j	800013d4 <scheduler+0x74>
      release(&p->lock);
    800013c2:	8526                	mv	a0,s1
    800013c4:	00005097          	auipc	ra,0x5
    800013c8:	e9e080e7          	jalr	-354(ra) # 80006262 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013cc:	17848493          	addi	s1,s1,376
    800013d0:	fd248ee3          	beq	s1,s2,800013ac <scheduler+0x4c>
      acquire(&p->lock);
    800013d4:	8526                	mv	a0,s1
    800013d6:	00005097          	auipc	ra,0x5
    800013da:	dd8080e7          	jalr	-552(ra) # 800061ae <acquire>
      if(p->state == RUNNABLE) {
    800013de:	4c9c                	lw	a5,24(s1)
    800013e0:	ff3791e3          	bne	a5,s3,800013c2 <scheduler+0x62>
        p->state = RUNNING;
    800013e4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013e8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ec:	06048593          	addi	a1,s1,96
    800013f0:	8556                	mv	a0,s5
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	6c4080e7          	jalr	1732(ra) # 80001ab6 <swtch>
        c->proc = 0;
    800013fa:	020a3823          	sd	zero,48(s4)
    800013fe:	b7d1                	j	800013c2 <scheduler+0x62>

0000000080001400 <sched>:
{
    80001400:	7179                	addi	sp,sp,-48
    80001402:	f406                	sd	ra,40(sp)
    80001404:	f022                	sd	s0,32(sp)
    80001406:	ec26                	sd	s1,24(sp)
    80001408:	e84a                	sd	s2,16(sp)
    8000140a:	e44e                	sd	s3,8(sp)
    8000140c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	a44080e7          	jalr	-1468(ra) # 80000e52 <myproc>
    80001416:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	d1c080e7          	jalr	-740(ra) # 80006134 <holding>
    80001420:	c93d                	beqz	a0,80001496 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001422:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	00007717          	auipc	a4,0x7
    8000142c:	50870713          	addi	a4,a4,1288 # 80008930 <pid_lock>
    80001430:	97ba                	add	a5,a5,a4
    80001432:	0a87a703          	lw	a4,168(a5)
    80001436:	4785                	li	a5,1
    80001438:	06f71763          	bne	a4,a5,800014a6 <sched+0xa6>
  if(p->state == RUNNING)
    8000143c:	4c98                	lw	a4,24(s1)
    8000143e:	4791                	li	a5,4
    80001440:	06f70b63          	beq	a4,a5,800014b6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001444:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001448:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000144a:	efb5                	bnez	a5,800014c6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144e:	00007917          	auipc	s2,0x7
    80001452:	4e290913          	addi	s2,s2,1250 # 80008930 <pid_lock>
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	97ca                	add	a5,a5,s2
    8000145c:	0ac7a983          	lw	s3,172(a5)
    80001460:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	00007597          	auipc	a1,0x7
    8000146a:	50258593          	addi	a1,a1,1282 # 80008968 <cpus+0x8>
    8000146e:	95be                	add	a1,a1,a5
    80001470:	06048513          	addi	a0,s1,96
    80001474:	00000097          	auipc	ra,0x0
    80001478:	642080e7          	jalr	1602(ra) # 80001ab6 <swtch>
    8000147c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	993e                	add	s2,s2,a5
    80001484:	0b392623          	sw	s3,172(s2)
}
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6145                	addi	sp,sp,48
    80001494:	8082                	ret
    panic("sched p->lock");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	d0250513          	addi	a0,a0,-766 # 80008198 <etext+0x198>
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	802080e7          	jalr	-2046(ra) # 80005ca0 <panic>
    panic("sched locks");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	d0250513          	addi	a0,a0,-766 # 800081a8 <etext+0x1a8>
    800014ae:	00004097          	auipc	ra,0x4
    800014b2:	7f2080e7          	jalr	2034(ra) # 80005ca0 <panic>
    panic("sched running");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	d0250513          	addi	a0,a0,-766 # 800081b8 <etext+0x1b8>
    800014be:	00004097          	auipc	ra,0x4
    800014c2:	7e2080e7          	jalr	2018(ra) # 80005ca0 <panic>
    panic("sched interruptible");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	d0250513          	addi	a0,a0,-766 # 800081c8 <etext+0x1c8>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	7d2080e7          	jalr	2002(ra) # 80005ca0 <panic>

00000000800014d6 <yield>:
{
    800014d6:	1101                	addi	sp,sp,-32
    800014d8:	ec06                	sd	ra,24(sp)
    800014da:	e822                	sd	s0,16(sp)
    800014dc:	e426                	sd	s1,8(sp)
    800014de:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	972080e7          	jalr	-1678(ra) # 80000e52 <myproc>
    800014e8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	cc4080e7          	jalr	-828(ra) # 800061ae <acquire>
  p->state = RUNNABLE;
    800014f2:	478d                	li	a5,3
    800014f4:	cc9c                	sw	a5,24(s1)
  sched();
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	f0a080e7          	jalr	-246(ra) # 80001400 <sched>
  release(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	d62080e7          	jalr	-670(ra) # 80006262 <release>
}
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001512:	7179                	addi	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	1800                	addi	s0,sp,48
    80001520:	89aa                	mv	s3,a0
    80001522:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	92e080e7          	jalr	-1746(ra) # 80000e52 <myproc>
    8000152c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	c80080e7          	jalr	-896(ra) # 800061ae <acquire>
  release(lk);
    80001536:	854a                	mv	a0,s2
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	d2a080e7          	jalr	-726(ra) # 80006262 <release>

  // Go to sleep.
  p->chan = chan;
    80001540:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001544:	4789                	li	a5,2
    80001546:	cc9c                	sw	a5,24(s1)

  sched();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	eb8080e7          	jalr	-328(ra) # 80001400 <sched>

  // Tidy up.
  p->chan = 0;
    80001550:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d0c080e7          	jalr	-756(ra) # 80006262 <release>
  acquire(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	c4e080e7          	jalr	-946(ra) # 800061ae <acquire>
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret

0000000080001576 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001576:	7139                	addi	sp,sp,-64
    80001578:	fc06                	sd	ra,56(sp)
    8000157a:	f822                	sd	s0,48(sp)
    8000157c:	f426                	sd	s1,40(sp)
    8000157e:	f04a                	sd	s2,32(sp)
    80001580:	ec4e                	sd	s3,24(sp)
    80001582:	e852                	sd	s4,16(sp)
    80001584:	e456                	sd	s5,8(sp)
    80001586:	0080                	addi	s0,sp,64
    80001588:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000158a:	00007497          	auipc	s1,0x7
    8000158e:	7d648493          	addi	s1,s1,2006 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001592:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001594:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001596:	0000d917          	auipc	s2,0xd
    8000159a:	5ca90913          	addi	s2,s2,1482 # 8000eb60 <tickslock>
    8000159e:	a811                	j	800015b2 <wakeup+0x3c>
      }
      release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	cc0080e7          	jalr	-832(ra) # 80006262 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015aa:	17848493          	addi	s1,s1,376
    800015ae:	03248663          	beq	s1,s2,800015da <wakeup+0x64>
    if(p != myproc()){
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	8a0080e7          	jalr	-1888(ra) # 80000e52 <myproc>
    800015ba:	fea488e3          	beq	s1,a0,800015aa <wakeup+0x34>
      acquire(&p->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	00005097          	auipc	ra,0x5
    800015c4:	bee080e7          	jalr	-1042(ra) # 800061ae <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015c8:	4c9c                	lw	a5,24(s1)
    800015ca:	fd379be3          	bne	a5,s3,800015a0 <wakeup+0x2a>
    800015ce:	709c                	ld	a5,32(s1)
    800015d0:	fd4798e3          	bne	a5,s4,800015a0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015d4:	0154ac23          	sw	s5,24(s1)
    800015d8:	b7e1                	j	800015a0 <wakeup+0x2a>
    }
  }
}
    800015da:	70e2                	ld	ra,56(sp)
    800015dc:	7442                	ld	s0,48(sp)
    800015de:	74a2                	ld	s1,40(sp)
    800015e0:	7902                	ld	s2,32(sp)
    800015e2:	69e2                	ld	s3,24(sp)
    800015e4:	6a42                	ld	s4,16(sp)
    800015e6:	6aa2                	ld	s5,8(sp)
    800015e8:	6121                	addi	sp,sp,64
    800015ea:	8082                	ret

00000000800015ec <reparent>:
{
    800015ec:	7179                	addi	sp,sp,-48
    800015ee:	f406                	sd	ra,40(sp)
    800015f0:	f022                	sd	s0,32(sp)
    800015f2:	ec26                	sd	s1,24(sp)
    800015f4:	e84a                	sd	s2,16(sp)
    800015f6:	e44e                	sd	s3,8(sp)
    800015f8:	e052                	sd	s4,0(sp)
    800015fa:	1800                	addi	s0,sp,48
    800015fc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015fe:	00007497          	auipc	s1,0x7
    80001602:	76248493          	addi	s1,s1,1890 # 80008d60 <proc>
      pp->parent = initproc;
    80001606:	00007a17          	auipc	s4,0x7
    8000160a:	2eaa0a13          	addi	s4,s4,746 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000160e:	0000d997          	auipc	s3,0xd
    80001612:	55298993          	addi	s3,s3,1362 # 8000eb60 <tickslock>
    80001616:	a029                	j	80001620 <reparent+0x34>
    80001618:	17848493          	addi	s1,s1,376
    8000161c:	01348d63          	beq	s1,s3,80001636 <reparent+0x4a>
    if(pp->parent == p){
    80001620:	7c9c                	ld	a5,56(s1)
    80001622:	ff279be3          	bne	a5,s2,80001618 <reparent+0x2c>
      pp->parent = initproc;
    80001626:	000a3503          	ld	a0,0(s4)
    8000162a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	f4a080e7          	jalr	-182(ra) # 80001576 <wakeup>
    80001634:	b7d5                	j	80001618 <reparent+0x2c>
}
    80001636:	70a2                	ld	ra,40(sp)
    80001638:	7402                	ld	s0,32(sp)
    8000163a:	64e2                	ld	s1,24(sp)
    8000163c:	6942                	ld	s2,16(sp)
    8000163e:	69a2                	ld	s3,8(sp)
    80001640:	6a02                	ld	s4,0(sp)
    80001642:	6145                	addi	sp,sp,48
    80001644:	8082                	ret

0000000080001646 <exit>:
{
    80001646:	7179                	addi	sp,sp,-48
    80001648:	f406                	sd	ra,40(sp)
    8000164a:	f022                	sd	s0,32(sp)
    8000164c:	ec26                	sd	s1,24(sp)
    8000164e:	e84a                	sd	s2,16(sp)
    80001650:	e44e                	sd	s3,8(sp)
    80001652:	e052                	sd	s4,0(sp)
    80001654:	1800                	addi	s0,sp,48
    80001656:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001658:	fffff097          	auipc	ra,0xfffff
    8000165c:	7fa080e7          	jalr	2042(ra) # 80000e52 <myproc>
    80001660:	89aa                	mv	s3,a0
  if(p == initproc)
    80001662:	00007797          	auipc	a5,0x7
    80001666:	28e7b783          	ld	a5,654(a5) # 800088f0 <initproc>
    8000166a:	0d050493          	addi	s1,a0,208
    8000166e:	15050913          	addi	s2,a0,336
    80001672:	02a79363          	bne	a5,a0,80001698 <exit+0x52>
    panic("init exiting");
    80001676:	00007517          	auipc	a0,0x7
    8000167a:	b6a50513          	addi	a0,a0,-1174 # 800081e0 <etext+0x1e0>
    8000167e:	00004097          	auipc	ra,0x4
    80001682:	622080e7          	jalr	1570(ra) # 80005ca0 <panic>
      fileclose(f);
    80001686:	00002097          	auipc	ra,0x2
    8000168a:	3a4080e7          	jalr	932(ra) # 80003a2a <fileclose>
      p->ofile[fd] = 0;
    8000168e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001692:	04a1                	addi	s1,s1,8
    80001694:	01248563          	beq	s1,s2,8000169e <exit+0x58>
    if(p->ofile[fd]){
    80001698:	6088                	ld	a0,0(s1)
    8000169a:	f575                	bnez	a0,80001686 <exit+0x40>
    8000169c:	bfdd                	j	80001692 <exit+0x4c>
  begin_op();
    8000169e:	00002097          	auipc	ra,0x2
    800016a2:	ec8080e7          	jalr	-312(ra) # 80003566 <begin_op>
  iput(p->cwd);
    800016a6:	1509b503          	ld	a0,336(s3)
    800016aa:	00001097          	auipc	ra,0x1
    800016ae:	6d0080e7          	jalr	1744(ra) # 80002d7a <iput>
  end_op();
    800016b2:	00002097          	auipc	ra,0x2
    800016b6:	f2e080e7          	jalr	-210(ra) # 800035e0 <end_op>
  p->cwd = 0;
    800016ba:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016be:	00007497          	auipc	s1,0x7
    800016c2:	28a48493          	addi	s1,s1,650 # 80008948 <wait_lock>
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	ae6080e7          	jalr	-1306(ra) # 800061ae <acquire>
  reparent(p);
    800016d0:	854e                	mv	a0,s3
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	f1a080e7          	jalr	-230(ra) # 800015ec <reparent>
  wakeup(p->parent);
    800016da:	0389b503          	ld	a0,56(s3)
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	e98080e7          	jalr	-360(ra) # 80001576 <wakeup>
  acquire(&p->lock);
    800016e6:	854e                	mv	a0,s3
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	ac6080e7          	jalr	-1338(ra) # 800061ae <acquire>
  p->xstate = status;
    800016f0:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016f4:	4795                	li	a5,5
    800016f6:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016fa:	8526                	mv	a0,s1
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	b66080e7          	jalr	-1178(ra) # 80006262 <release>
  sched();
    80001704:	00000097          	auipc	ra,0x0
    80001708:	cfc080e7          	jalr	-772(ra) # 80001400 <sched>
  panic("zombie exit");
    8000170c:	00007517          	auipc	a0,0x7
    80001710:	ae450513          	addi	a0,a0,-1308 # 800081f0 <etext+0x1f0>
    80001714:	00004097          	auipc	ra,0x4
    80001718:	58c080e7          	jalr	1420(ra) # 80005ca0 <panic>

000000008000171c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000171c:	7179                	addi	sp,sp,-48
    8000171e:	f406                	sd	ra,40(sp)
    80001720:	f022                	sd	s0,32(sp)
    80001722:	ec26                	sd	s1,24(sp)
    80001724:	e84a                	sd	s2,16(sp)
    80001726:	e44e                	sd	s3,8(sp)
    80001728:	1800                	addi	s0,sp,48
    8000172a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000172c:	00007497          	auipc	s1,0x7
    80001730:	63448493          	addi	s1,s1,1588 # 80008d60 <proc>
    80001734:	0000d997          	auipc	s3,0xd
    80001738:	42c98993          	addi	s3,s3,1068 # 8000eb60 <tickslock>
    acquire(&p->lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	a70080e7          	jalr	-1424(ra) # 800061ae <acquire>
    if(p->pid == pid){
    80001746:	589c                	lw	a5,48(s1)
    80001748:	01278d63          	beq	a5,s2,80001762 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000174c:	8526                	mv	a0,s1
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	b14080e7          	jalr	-1260(ra) # 80006262 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001756:	17848493          	addi	s1,s1,376
    8000175a:	ff3491e3          	bne	s1,s3,8000173c <kill+0x20>
  }
  return -1;
    8000175e:	557d                	li	a0,-1
    80001760:	a829                	j	8000177a <kill+0x5e>
      p->killed = 1;
    80001762:	4785                	li	a5,1
    80001764:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001766:	4c98                	lw	a4,24(s1)
    80001768:	4789                	li	a5,2
    8000176a:	00f70f63          	beq	a4,a5,80001788 <kill+0x6c>
      release(&p->lock);
    8000176e:	8526                	mv	a0,s1
    80001770:	00005097          	auipc	ra,0x5
    80001774:	af2080e7          	jalr	-1294(ra) # 80006262 <release>
      return 0;
    80001778:	4501                	li	a0,0
}
    8000177a:	70a2                	ld	ra,40(sp)
    8000177c:	7402                	ld	s0,32(sp)
    8000177e:	64e2                	ld	s1,24(sp)
    80001780:	6942                	ld	s2,16(sp)
    80001782:	69a2                	ld	s3,8(sp)
    80001784:	6145                	addi	sp,sp,48
    80001786:	8082                	ret
        p->state = RUNNABLE;
    80001788:	478d                	li	a5,3
    8000178a:	cc9c                	sw	a5,24(s1)
    8000178c:	b7cd                	j	8000176e <kill+0x52>

000000008000178e <setkilled>:

void
setkilled(struct proc *p)
{
    8000178e:	1101                	addi	sp,sp,-32
    80001790:	ec06                	sd	ra,24(sp)
    80001792:	e822                	sd	s0,16(sp)
    80001794:	e426                	sd	s1,8(sp)
    80001796:	1000                	addi	s0,sp,32
    80001798:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	a14080e7          	jalr	-1516(ra) # 800061ae <acquire>
  p->killed = 1;
    800017a2:	4785                	li	a5,1
    800017a4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017a6:	8526                	mv	a0,s1
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	aba080e7          	jalr	-1350(ra) # 80006262 <release>
}
    800017b0:	60e2                	ld	ra,24(sp)
    800017b2:	6442                	ld	s0,16(sp)
    800017b4:	64a2                	ld	s1,8(sp)
    800017b6:	6105                	addi	sp,sp,32
    800017b8:	8082                	ret

00000000800017ba <killed>:

int
killed(struct proc *p)
{
    800017ba:	1101                	addi	sp,sp,-32
    800017bc:	ec06                	sd	ra,24(sp)
    800017be:	e822                	sd	s0,16(sp)
    800017c0:	e426                	sd	s1,8(sp)
    800017c2:	e04a                	sd	s2,0(sp)
    800017c4:	1000                	addi	s0,sp,32
    800017c6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	9e6080e7          	jalr	-1562(ra) # 800061ae <acquire>
  k = p->killed;
    800017d0:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	a8c080e7          	jalr	-1396(ra) # 80006262 <release>
  return k;
}
    800017de:	854a                	mv	a0,s2
    800017e0:	60e2                	ld	ra,24(sp)
    800017e2:	6442                	ld	s0,16(sp)
    800017e4:	64a2                	ld	s1,8(sp)
    800017e6:	6902                	ld	s2,0(sp)
    800017e8:	6105                	addi	sp,sp,32
    800017ea:	8082                	ret

00000000800017ec <wait>:
{
    800017ec:	715d                	addi	sp,sp,-80
    800017ee:	e486                	sd	ra,72(sp)
    800017f0:	e0a2                	sd	s0,64(sp)
    800017f2:	fc26                	sd	s1,56(sp)
    800017f4:	f84a                	sd	s2,48(sp)
    800017f6:	f44e                	sd	s3,40(sp)
    800017f8:	f052                	sd	s4,32(sp)
    800017fa:	ec56                	sd	s5,24(sp)
    800017fc:	e85a                	sd	s6,16(sp)
    800017fe:	e45e                	sd	s7,8(sp)
    80001800:	e062                	sd	s8,0(sp)
    80001802:	0880                	addi	s0,sp,80
    80001804:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001806:	fffff097          	auipc	ra,0xfffff
    8000180a:	64c080e7          	jalr	1612(ra) # 80000e52 <myproc>
    8000180e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001810:	00007517          	auipc	a0,0x7
    80001814:	13850513          	addi	a0,a0,312 # 80008948 <wait_lock>
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	996080e7          	jalr	-1642(ra) # 800061ae <acquire>
    havekids = 0;
    80001820:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001822:	4a15                	li	s4,5
        havekids = 1;
    80001824:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001826:	0000d997          	auipc	s3,0xd
    8000182a:	33a98993          	addi	s3,s3,826 # 8000eb60 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000182e:	00007c17          	auipc	s8,0x7
    80001832:	11ac0c13          	addi	s8,s8,282 # 80008948 <wait_lock>
    80001836:	a0d1                	j	800018fa <wait+0x10e>
          pid = pp->pid;
    80001838:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000183c:	000b0e63          	beqz	s6,80001858 <wait+0x6c>
    80001840:	4691                	li	a3,4
    80001842:	02c48613          	addi	a2,s1,44
    80001846:	85da                	mv	a1,s6
    80001848:	05093503          	ld	a0,80(s2)
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	2c6080e7          	jalr	710(ra) # 80000b12 <copyout>
    80001854:	04054163          	bltz	a0,80001896 <wait+0xaa>
          freeproc(pp);
    80001858:	8526                	mv	a0,s1
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	7aa080e7          	jalr	1962(ra) # 80001004 <freeproc>
          release(&pp->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	9fe080e7          	jalr	-1538(ra) # 80006262 <release>
          release(&wait_lock);
    8000186c:	00007517          	auipc	a0,0x7
    80001870:	0dc50513          	addi	a0,a0,220 # 80008948 <wait_lock>
    80001874:	00005097          	auipc	ra,0x5
    80001878:	9ee080e7          	jalr	-1554(ra) # 80006262 <release>
}
    8000187c:	854e                	mv	a0,s3
    8000187e:	60a6                	ld	ra,72(sp)
    80001880:	6406                	ld	s0,64(sp)
    80001882:	74e2                	ld	s1,56(sp)
    80001884:	7942                	ld	s2,48(sp)
    80001886:	79a2                	ld	s3,40(sp)
    80001888:	7a02                	ld	s4,32(sp)
    8000188a:	6ae2                	ld	s5,24(sp)
    8000188c:	6b42                	ld	s6,16(sp)
    8000188e:	6ba2                	ld	s7,8(sp)
    80001890:	6c02                	ld	s8,0(sp)
    80001892:	6161                	addi	sp,sp,80
    80001894:	8082                	ret
            release(&pp->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	9ca080e7          	jalr	-1590(ra) # 80006262 <release>
            release(&wait_lock);
    800018a0:	00007517          	auipc	a0,0x7
    800018a4:	0a850513          	addi	a0,a0,168 # 80008948 <wait_lock>
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	9ba080e7          	jalr	-1606(ra) # 80006262 <release>
            return -1;
    800018b0:	59fd                	li	s3,-1
    800018b2:	b7e9                	j	8000187c <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b4:	17848493          	addi	s1,s1,376
    800018b8:	03348463          	beq	s1,s3,800018e0 <wait+0xf4>
      if(pp->parent == p){
    800018bc:	7c9c                	ld	a5,56(s1)
    800018be:	ff279be3          	bne	a5,s2,800018b4 <wait+0xc8>
        acquire(&pp->lock);
    800018c2:	8526                	mv	a0,s1
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	8ea080e7          	jalr	-1814(ra) # 800061ae <acquire>
        if(pp->state == ZOMBIE){
    800018cc:	4c9c                	lw	a5,24(s1)
    800018ce:	f74785e3          	beq	a5,s4,80001838 <wait+0x4c>
        release(&pp->lock);
    800018d2:	8526                	mv	a0,s1
    800018d4:	00005097          	auipc	ra,0x5
    800018d8:	98e080e7          	jalr	-1650(ra) # 80006262 <release>
        havekids = 1;
    800018dc:	8756                	mv	a4,s5
    800018de:	bfd9                	j	800018b4 <wait+0xc8>
    if(!havekids || killed(p)){
    800018e0:	c31d                	beqz	a4,80001906 <wait+0x11a>
    800018e2:	854a                	mv	a0,s2
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	ed6080e7          	jalr	-298(ra) # 800017ba <killed>
    800018ec:	ed09                	bnez	a0,80001906 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018ee:	85e2                	mv	a1,s8
    800018f0:	854a                	mv	a0,s2
    800018f2:	00000097          	auipc	ra,0x0
    800018f6:	c20080e7          	jalr	-992(ra) # 80001512 <sleep>
    havekids = 0;
    800018fa:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018fc:	00007497          	auipc	s1,0x7
    80001900:	46448493          	addi	s1,s1,1124 # 80008d60 <proc>
    80001904:	bf65                	j	800018bc <wait+0xd0>
      release(&wait_lock);
    80001906:	00007517          	auipc	a0,0x7
    8000190a:	04250513          	addi	a0,a0,66 # 80008948 <wait_lock>
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	954080e7          	jalr	-1708(ra) # 80006262 <release>
      return -1;
    80001916:	59fd                	li	s3,-1
    80001918:	b795                	j	8000187c <wait+0x90>

000000008000191a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000191a:	7179                	addi	sp,sp,-48
    8000191c:	f406                	sd	ra,40(sp)
    8000191e:	f022                	sd	s0,32(sp)
    80001920:	ec26                	sd	s1,24(sp)
    80001922:	e84a                	sd	s2,16(sp)
    80001924:	e44e                	sd	s3,8(sp)
    80001926:	e052                	sd	s4,0(sp)
    80001928:	1800                	addi	s0,sp,48
    8000192a:	84aa                	mv	s1,a0
    8000192c:	892e                	mv	s2,a1
    8000192e:	89b2                	mv	s3,a2
    80001930:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	520080e7          	jalr	1312(ra) # 80000e52 <myproc>
  if(user_dst){
    8000193a:	c08d                	beqz	s1,8000195c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000193c:	86d2                	mv	a3,s4
    8000193e:	864e                	mv	a2,s3
    80001940:	85ca                	mv	a1,s2
    80001942:	6928                	ld	a0,80(a0)
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	1ce080e7          	jalr	462(ra) # 80000b12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000194c:	70a2                	ld	ra,40(sp)
    8000194e:	7402                	ld	s0,32(sp)
    80001950:	64e2                	ld	s1,24(sp)
    80001952:	6942                	ld	s2,16(sp)
    80001954:	69a2                	ld	s3,8(sp)
    80001956:	6a02                	ld	s4,0(sp)
    80001958:	6145                	addi	sp,sp,48
    8000195a:	8082                	ret
    memmove((char *)dst, src, len);
    8000195c:	000a061b          	sext.w	a2,s4
    80001960:	85ce                	mv	a1,s3
    80001962:	854a                	mv	a0,s2
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	872080e7          	jalr	-1934(ra) # 800001d6 <memmove>
    return 0;
    8000196c:	8526                	mv	a0,s1
    8000196e:	bff9                	j	8000194c <either_copyout+0x32>

0000000080001970 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001970:	7179                	addi	sp,sp,-48
    80001972:	f406                	sd	ra,40(sp)
    80001974:	f022                	sd	s0,32(sp)
    80001976:	ec26                	sd	s1,24(sp)
    80001978:	e84a                	sd	s2,16(sp)
    8000197a:	e44e                	sd	s3,8(sp)
    8000197c:	e052                	sd	s4,0(sp)
    8000197e:	1800                	addi	s0,sp,48
    80001980:	892a                	mv	s2,a0
    80001982:	84ae                	mv	s1,a1
    80001984:	89b2                	mv	s3,a2
    80001986:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	4ca080e7          	jalr	1226(ra) # 80000e52 <myproc>
  if(user_src){
    80001990:	c08d                	beqz	s1,800019b2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001992:	86d2                	mv	a3,s4
    80001994:	864e                	mv	a2,s3
    80001996:	85ca                	mv	a1,s2
    80001998:	6928                	ld	a0,80(a0)
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	204080e7          	jalr	516(ra) # 80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019a2:	70a2                	ld	ra,40(sp)
    800019a4:	7402                	ld	s0,32(sp)
    800019a6:	64e2                	ld	s1,24(sp)
    800019a8:	6942                	ld	s2,16(sp)
    800019aa:	69a2                	ld	s3,8(sp)
    800019ac:	6a02                	ld	s4,0(sp)
    800019ae:	6145                	addi	sp,sp,48
    800019b0:	8082                	ret
    memmove(dst, (char*)src, len);
    800019b2:	000a061b          	sext.w	a2,s4
    800019b6:	85ce                	mv	a1,s3
    800019b8:	854a                	mv	a0,s2
    800019ba:	fffff097          	auipc	ra,0xfffff
    800019be:	81c080e7          	jalr	-2020(ra) # 800001d6 <memmove>
    return 0;
    800019c2:	8526                	mv	a0,s1
    800019c4:	bff9                	j	800019a2 <either_copyin+0x32>

00000000800019c6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019c6:	715d                	addi	sp,sp,-80
    800019c8:	e486                	sd	ra,72(sp)
    800019ca:	e0a2                	sd	s0,64(sp)
    800019cc:	fc26                	sd	s1,56(sp)
    800019ce:	f84a                	sd	s2,48(sp)
    800019d0:	f44e                	sd	s3,40(sp)
    800019d2:	f052                	sd	s4,32(sp)
    800019d4:	ec56                	sd	s5,24(sp)
    800019d6:	e85a                	sd	s6,16(sp)
    800019d8:	e45e                	sd	s7,8(sp)
    800019da:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019dc:	00006517          	auipc	a0,0x6
    800019e0:	66c50513          	addi	a0,a0,1644 # 80008048 <etext+0x48>
    800019e4:	00004097          	auipc	ra,0x4
    800019e8:	30e080e7          	jalr	782(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ec:	00007497          	auipc	s1,0x7
    800019f0:	4cc48493          	addi	s1,s1,1228 # 80008eb8 <proc+0x158>
    800019f4:	0000d917          	auipc	s2,0xd
    800019f8:	2c490913          	addi	s2,s2,708 # 8000ecb8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019fe:	00007997          	auipc	s3,0x7
    80001a02:	80298993          	addi	s3,s3,-2046 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a06:	00007a97          	auipc	s5,0x7
    80001a0a:	802a8a93          	addi	s5,s5,-2046 # 80008208 <etext+0x208>
    printf("\n");
    80001a0e:	00006a17          	auipc	s4,0x6
    80001a12:	63aa0a13          	addi	s4,s4,1594 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a16:	00007b97          	auipc	s7,0x7
    80001a1a:	832b8b93          	addi	s7,s7,-1998 # 80008248 <states.0>
    80001a1e:	a00d                	j	80001a40 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a20:	ed86a583          	lw	a1,-296(a3)
    80001a24:	8556                	mv	a0,s5
    80001a26:	00004097          	auipc	ra,0x4
    80001a2a:	2cc080e7          	jalr	716(ra) # 80005cf2 <printf>
    printf("\n");
    80001a2e:	8552                	mv	a0,s4
    80001a30:	00004097          	auipc	ra,0x4
    80001a34:	2c2080e7          	jalr	706(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a38:	17848493          	addi	s1,s1,376
    80001a3c:	03248263          	beq	s1,s2,80001a60 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a40:	86a6                	mv	a3,s1
    80001a42:	ec04a783          	lw	a5,-320(s1)
    80001a46:	dbed                	beqz	a5,80001a38 <procdump+0x72>
      state = "???";
    80001a48:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a4a:	fcfb6be3          	bltu	s6,a5,80001a20 <procdump+0x5a>
    80001a4e:	02079713          	slli	a4,a5,0x20
    80001a52:	01d75793          	srli	a5,a4,0x1d
    80001a56:	97de                	add	a5,a5,s7
    80001a58:	6390                	ld	a2,0(a5)
    80001a5a:	f279                	bnez	a2,80001a20 <procdump+0x5a>
      state = "???";
    80001a5c:	864e                	mv	a2,s3
    80001a5e:	b7c9                	j	80001a20 <procdump+0x5a>
  }
}
    80001a60:	60a6                	ld	ra,72(sp)
    80001a62:	6406                	ld	s0,64(sp)
    80001a64:	74e2                	ld	s1,56(sp)
    80001a66:	7942                	ld	s2,48(sp)
    80001a68:	79a2                	ld	s3,40(sp)
    80001a6a:	7a02                	ld	s4,32(sp)
    80001a6c:	6ae2                	ld	s5,24(sp)
    80001a6e:	6b42                	ld	s6,16(sp)
    80001a70:	6ba2                	ld	s7,8(sp)
    80001a72:	6161                	addi	sp,sp,80
    80001a74:	8082                	ret

0000000080001a76 <sigalarm>:

int
sigalarm(int ticks, void (*handler)(void)){/*TODO*/
    80001a76:	1101                	addi	sp,sp,-32
    80001a78:	ec06                	sd	ra,24(sp)
    80001a7a:	e822                	sd	s0,16(sp)
    80001a7c:	e426                	sd	s1,8(sp)
    80001a7e:	e04a                	sd	s2,0(sp)
    80001a80:	1000                	addi	s0,sp,32
    80001a82:	892a                	mv	s2,a0
    80001a84:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	3cc080e7          	jalr	972(ra) # 80000e52 <myproc>
  p->ticks = ticks;
    80001a8e:	17252423          	sw	s2,360(a0)
  p->handler = handler;
    80001a92:	16953823          	sd	s1,368(a0)
  p->alarm_past = 0;
    80001a96:	16052623          	sw	zero,364(a0)
  return 0;
}
    80001a9a:	4501                	li	a0,0
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	64a2                	ld	s1,8(sp)
    80001aa2:	6902                	ld	s2,0(sp)
    80001aa4:	6105                	addi	sp,sp,32
    80001aa6:	8082                	ret

0000000080001aa8 <sigreturn>:



int
sigreturn(){/*TODO*/
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e422                	sd	s0,8(sp)
    80001aac:	0800                	addi	s0,sp,16
  return 0;
    80001aae:	4501                	li	a0,0
    80001ab0:	6422                	ld	s0,8(sp)
    80001ab2:	0141                	addi	sp,sp,16
    80001ab4:	8082                	ret

0000000080001ab6 <swtch>:
    80001ab6:	00153023          	sd	ra,0(a0)
    80001aba:	00253423          	sd	sp,8(a0)
    80001abe:	e900                	sd	s0,16(a0)
    80001ac0:	ed04                	sd	s1,24(a0)
    80001ac2:	03253023          	sd	s2,32(a0)
    80001ac6:	03353423          	sd	s3,40(a0)
    80001aca:	03453823          	sd	s4,48(a0)
    80001ace:	03553c23          	sd	s5,56(a0)
    80001ad2:	05653023          	sd	s6,64(a0)
    80001ad6:	05753423          	sd	s7,72(a0)
    80001ada:	05853823          	sd	s8,80(a0)
    80001ade:	05953c23          	sd	s9,88(a0)
    80001ae2:	07a53023          	sd	s10,96(a0)
    80001ae6:	07b53423          	sd	s11,104(a0)
    80001aea:	0005b083          	ld	ra,0(a1)
    80001aee:	0085b103          	ld	sp,8(a1)
    80001af2:	6980                	ld	s0,16(a1)
    80001af4:	6d84                	ld	s1,24(a1)
    80001af6:	0205b903          	ld	s2,32(a1)
    80001afa:	0285b983          	ld	s3,40(a1)
    80001afe:	0305ba03          	ld	s4,48(a1)
    80001b02:	0385ba83          	ld	s5,56(a1)
    80001b06:	0405bb03          	ld	s6,64(a1)
    80001b0a:	0485bb83          	ld	s7,72(a1)
    80001b0e:	0505bc03          	ld	s8,80(a1)
    80001b12:	0585bc83          	ld	s9,88(a1)
    80001b16:	0605bd03          	ld	s10,96(a1)
    80001b1a:	0685bd83          	ld	s11,104(a1)
    80001b1e:	8082                	ret

0000000080001b20 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b20:	1141                	addi	sp,sp,-16
    80001b22:	e406                	sd	ra,8(sp)
    80001b24:	e022                	sd	s0,0(sp)
    80001b26:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b28:	00006597          	auipc	a1,0x6
    80001b2c:	75058593          	addi	a1,a1,1872 # 80008278 <states.0+0x30>
    80001b30:	0000d517          	auipc	a0,0xd
    80001b34:	03050513          	addi	a0,a0,48 # 8000eb60 <tickslock>
    80001b38:	00004097          	auipc	ra,0x4
    80001b3c:	5e6080e7          	jalr	1510(ra) # 8000611e <initlock>
}
    80001b40:	60a2                	ld	ra,8(sp)
    80001b42:	6402                	ld	s0,0(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b48:	1141                	addi	sp,sp,-16
    80001b4a:	e422                	sd	s0,8(sp)
    80001b4c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4e:	00003797          	auipc	a5,0x3
    80001b52:	50278793          	addi	a5,a5,1282 # 80005050 <kernelvec>
    80001b56:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5a:	6422                	ld	s0,8(sp)
    80001b5c:	0141                	addi	sp,sp,16
    80001b5e:	8082                	ret

0000000080001b60 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b60:	1141                	addi	sp,sp,-16
    80001b62:	e406                	sd	ra,8(sp)
    80001b64:	e022                	sd	s0,0(sp)
    80001b66:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	2ea080e7          	jalr	746(ra) # 80000e52 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b74:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b76:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7a:	00005697          	auipc	a3,0x5
    80001b7e:	48668693          	addi	a3,a3,1158 # 80007000 <_trampoline>
    80001b82:	00005717          	auipc	a4,0x5
    80001b86:	47e70713          	addi	a4,a4,1150 # 80007000 <_trampoline>
    80001b8a:	8f15                	sub	a4,a4,a3
    80001b8c:	040007b7          	lui	a5,0x4000
    80001b90:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b92:	07b2                	slli	a5,a5,0xc
    80001b94:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b96:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9c:	18002673          	csrr	a2,satp
    80001ba0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba2:	6d30                	ld	a2,88(a0)
    80001ba4:	6138                	ld	a4,64(a0)
    80001ba6:	6585                	lui	a1,0x1
    80001ba8:	972e                	add	a4,a4,a1
    80001baa:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bac:	6d38                	ld	a4,88(a0)
    80001bae:	00000617          	auipc	a2,0x0
    80001bb2:	13460613          	addi	a2,a2,308 # 80001ce2 <usertrap>
    80001bb6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bba:	8612                	mv	a2,tp
    80001bbc:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bbe:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bca:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bce:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd0:	6f18                	ld	a4,24(a4)
    80001bd2:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd6:	6928                	ld	a0,80(a0)
    80001bd8:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bda:	00005717          	auipc	a4,0x5
    80001bde:	4c270713          	addi	a4,a4,1218 # 8000709c <userret>
    80001be2:	8f15                	sub	a4,a4,a3
    80001be4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001be6:	577d                	li	a4,-1
    80001be8:	177e                	slli	a4,a4,0x3f
    80001bea:	8d59                	or	a0,a0,a4
    80001bec:	9782                	jalr	a5
}
    80001bee:	60a2                	ld	ra,8(sp)
    80001bf0:	6402                	ld	s0,0(sp)
    80001bf2:	0141                	addi	sp,sp,16
    80001bf4:	8082                	ret

0000000080001bf6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf6:	1101                	addi	sp,sp,-32
    80001bf8:	ec06                	sd	ra,24(sp)
    80001bfa:	e822                	sd	s0,16(sp)
    80001bfc:	e426                	sd	s1,8(sp)
    80001bfe:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c00:	0000d497          	auipc	s1,0xd
    80001c04:	f6048493          	addi	s1,s1,-160 # 8000eb60 <tickslock>
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	5a4080e7          	jalr	1444(ra) # 800061ae <acquire>
  ticks++;
    80001c12:	00007517          	auipc	a0,0x7
    80001c16:	ce650513          	addi	a0,a0,-794 # 800088f8 <ticks>
    80001c1a:	411c                	lw	a5,0(a0)
    80001c1c:	2785                	addiw	a5,a5,1
    80001c1e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c20:	00000097          	auipc	ra,0x0
    80001c24:	956080e7          	jalr	-1706(ra) # 80001576 <wakeup>
  release(&tickslock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	638080e7          	jalr	1592(ra) # 80006262 <release>
}
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6105                	addi	sp,sp,32
    80001c3a:	8082                	ret

0000000080001c3c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c3c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c40:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c42:	0807df63          	bgez	a5,80001ce0 <devintr+0xa4>
{
    80001c46:	1101                	addi	sp,sp,-32
    80001c48:	ec06                	sd	ra,24(sp)
    80001c4a:	e822                	sd	s0,16(sp)
    80001c4c:	e426                	sd	s1,8(sp)
    80001c4e:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c50:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c54:	46a5                	li	a3,9
    80001c56:	00d70d63          	beq	a4,a3,80001c70 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c5a:	577d                	li	a4,-1
    80001c5c:	177e                	slli	a4,a4,0x3f
    80001c5e:	0705                	addi	a4,a4,1
    return 0;
    80001c60:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c62:	04e78e63          	beq	a5,a4,80001cbe <devintr+0x82>
  }
}
    80001c66:	60e2                	ld	ra,24(sp)
    80001c68:	6442                	ld	s0,16(sp)
    80001c6a:	64a2                	ld	s1,8(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret
    int irq = plic_claim();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	4e8080e7          	jalr	1256(ra) # 80005158 <plic_claim>
    80001c78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7a:	47a9                	li	a5,10
    80001c7c:	02f50763          	beq	a0,a5,80001caa <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c80:	4785                	li	a5,1
    80001c82:	02f50963          	beq	a0,a5,80001cb4 <devintr+0x78>
    return 1;
    80001c86:	4505                	li	a0,1
    } else if(irq){
    80001c88:	dcf9                	beqz	s1,80001c66 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8a:	85a6                	mv	a1,s1
    80001c8c:	00006517          	auipc	a0,0x6
    80001c90:	5f450513          	addi	a0,a0,1524 # 80008280 <states.0+0x38>
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	05e080e7          	jalr	94(ra) # 80005cf2 <printf>
      plic_complete(irq);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	4de080e7          	jalr	1246(ra) # 8000517c <plic_complete>
    return 1;
    80001ca6:	4505                	li	a0,1
    80001ca8:	bf7d                	j	80001c66 <devintr+0x2a>
      uartintr();
    80001caa:	00004097          	auipc	ra,0x4
    80001cae:	424080e7          	jalr	1060(ra) # 800060ce <uartintr>
    if(irq)
    80001cb2:	b7ed                	j	80001c9c <devintr+0x60>
      virtio_disk_intr();
    80001cb4:	00004097          	auipc	ra,0x4
    80001cb8:	98e080e7          	jalr	-1650(ra) # 80005642 <virtio_disk_intr>
    if(irq)
    80001cbc:	b7c5                	j	80001c9c <devintr+0x60>
    if(cpuid() == 0){
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	168080e7          	jalr	360(ra) # 80000e26 <cpuid>
    80001cc6:	c901                	beqz	a0,80001cd6 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ccc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cce:	14479073          	csrw	sip,a5
    return 2;
    80001cd2:	4509                	li	a0,2
    80001cd4:	bf49                	j	80001c66 <devintr+0x2a>
      clockintr();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	f20080e7          	jalr	-224(ra) # 80001bf6 <clockintr>
    80001cde:	b7ed                	j	80001cc8 <devintr+0x8c>
}
    80001ce0:	8082                	ret

0000000080001ce2 <usertrap>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	e04a                	sd	s2,0(sp)
    80001cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf2:	1007f793          	andi	a5,a5,256
    80001cf6:	e3b1                	bnez	a5,80001d3a <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	00003797          	auipc	a5,0x3
    80001cfc:	35878793          	addi	a5,a5,856 # 80005050 <kernelvec>
    80001d00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	14e080e7          	jalr	334(ra) # 80000e52 <myproc>
    80001d0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102773          	csrr	a4,sepc
    80001d14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1a:	47a1                	li	a5,8
    80001d1c:	02f70763          	beq	a4,a5,80001d4a <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	f1c080e7          	jalr	-228(ra) # 80001c3c <devintr>
    80001d28:	892a                	mv	s2,a0
    80001d2a:	c92d                	beqz	a0,80001d9c <usertrap+0xba>
  if(killed(p))
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	a8c080e7          	jalr	-1396(ra) # 800017ba <killed>
    80001d36:	c555                	beqz	a0,80001de2 <usertrap+0x100>
    80001d38:	a045                	j	80001dd8 <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	56650513          	addi	a0,a0,1382 # 800082a0 <states.0+0x58>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	f5e080e7          	jalr	-162(ra) # 80005ca0 <panic>
    if(killed(p))
    80001d4a:	00000097          	auipc	ra,0x0
    80001d4e:	a70080e7          	jalr	-1424(ra) # 800017ba <killed>
    80001d52:	ed1d                	bnez	a0,80001d90 <usertrap+0xae>
    p->trapframe->epc += 4;
    80001d54:	6cb8                	ld	a4,88(s1)
    80001d56:	6f1c                	ld	a5,24(a4)
    80001d58:	0791                	addi	a5,a5,4
    80001d5a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d64:	10079073          	csrw	sstatus,a5
    syscall();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	2fa080e7          	jalr	762(ra) # 80002062 <syscall>
  if(killed(p))
    80001d70:	8526                	mv	a0,s1
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	a48080e7          	jalr	-1464(ra) # 800017ba <killed>
    80001d7a:	ed31                	bnez	a0,80001dd6 <usertrap+0xf4>
  usertrapret();
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	de4080e7          	jalr	-540(ra) # 80001b60 <usertrapret>
}
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
      exit(-1);
    80001d90:	557d                	li	a0,-1
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	8b4080e7          	jalr	-1868(ra) # 80001646 <exit>
    80001d9a:	bf6d                	j	80001d54 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da0:	5890                	lw	a2,48(s1)
    80001da2:	00006517          	auipc	a0,0x6
    80001da6:	51e50513          	addi	a0,a0,1310 # 800082c0 <states.0+0x78>
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	f48080e7          	jalr	-184(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dba:	00006517          	auipc	a0,0x6
    80001dbe:	53650513          	addi	a0,a0,1334 # 800082f0 <states.0+0xa8>
    80001dc2:	00004097          	auipc	ra,0x4
    80001dc6:	f30080e7          	jalr	-208(ra) # 80005cf2 <printf>
    setkilled(p);
    80001dca:	8526                	mv	a0,s1
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	9c2080e7          	jalr	-1598(ra) # 8000178e <setkilled>
    80001dd4:	bf71                	j	80001d70 <usertrap+0x8e>
  if(killed(p))
    80001dd6:	4901                	li	s2,0
    exit(-1);
    80001dd8:	557d                	li	a0,-1
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	86c080e7          	jalr	-1940(ra) # 80001646 <exit>
  if(which_dev == 2){ /*TODO*/
    80001de2:	4789                	li	a5,2
    80001de4:	f8f91ce3          	bne	s2,a5,80001d7c <usertrap+0x9a>
    if(p->ticks && (++p->alarm_past == p->ticks)){
    80001de8:	1684a783          	lw	a5,360(s1)
    80001dec:	cb91                	beqz	a5,80001e00 <usertrap+0x11e>
    80001dee:	16c4a703          	lw	a4,364(s1)
    80001df2:	2705                	addiw	a4,a4,1
    80001df4:	0007069b          	sext.w	a3,a4
    80001df8:	00d78963          	beq	a5,a3,80001e0a <usertrap+0x128>
    80001dfc:	16e4a623          	sw	a4,364(s1)
    yield();
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	6d6080e7          	jalr	1750(ra) # 800014d6 <yield>
    80001e08:	bf95                	j	80001d7c <usertrap+0x9a>
      p->alarm_past = 0;
    80001e0a:	1604a623          	sw	zero,364(s1)
      p->trapframe->epc = (uint64)p->handler;
    80001e0e:	6cbc                	ld	a5,88(s1)
    80001e10:	1704b703          	ld	a4,368(s1)
    80001e14:	ef98                	sd	a4,24(a5)
    80001e16:	b7ed                	j	80001e00 <usertrap+0x11e>

0000000080001e18 <kerneltrap>:
{
    80001e18:	7179                	addi	sp,sp,-48
    80001e1a:	f406                	sd	ra,40(sp)
    80001e1c:	f022                	sd	s0,32(sp)
    80001e1e:	ec26                	sd	s1,24(sp)
    80001e20:	e84a                	sd	s2,16(sp)
    80001e22:	e44e                	sd	s3,8(sp)
    80001e24:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e26:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e32:	1004f793          	andi	a5,s1,256
    80001e36:	cb85                	beqz	a5,80001e66 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e3c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e3e:	ef85                	bnez	a5,80001e76 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	dfc080e7          	jalr	-516(ra) # 80001c3c <devintr>
    80001e48:	cd1d                	beqz	a0,80001e86 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4a:	4789                	li	a5,2
    80001e4c:	06f50a63          	beq	a0,a5,80001ec0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e50:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e54:	10049073          	csrw	sstatus,s1
}
    80001e58:	70a2                	ld	ra,40(sp)
    80001e5a:	7402                	ld	s0,32(sp)
    80001e5c:	64e2                	ld	s1,24(sp)
    80001e5e:	6942                	ld	s2,16(sp)
    80001e60:	69a2                	ld	s3,8(sp)
    80001e62:	6145                	addi	sp,sp,48
    80001e64:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	4aa50513          	addi	a0,a0,1194 # 80008310 <states.0+0xc8>
    80001e6e:	00004097          	auipc	ra,0x4
    80001e72:	e32080e7          	jalr	-462(ra) # 80005ca0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	4c250513          	addi	a0,a0,1218 # 80008338 <states.0+0xf0>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	e22080e7          	jalr	-478(ra) # 80005ca0 <panic>
    printf("scause %p\n", scause);
    80001e86:	85ce                	mv	a1,s3
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4d050513          	addi	a0,a0,1232 # 80008358 <states.0+0x110>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	e62080e7          	jalr	-414(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e98:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e9c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea0:	00006517          	auipc	a0,0x6
    80001ea4:	4c850513          	addi	a0,a0,1224 # 80008368 <states.0+0x120>
    80001ea8:	00004097          	auipc	ra,0x4
    80001eac:	e4a080e7          	jalr	-438(ra) # 80005cf2 <printf>
    panic("kerneltrap");
    80001eb0:	00006517          	auipc	a0,0x6
    80001eb4:	4d050513          	addi	a0,a0,1232 # 80008380 <states.0+0x138>
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	de8080e7          	jalr	-536(ra) # 80005ca0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	f92080e7          	jalr	-110(ra) # 80000e52 <myproc>
    80001ec8:	d541                	beqz	a0,80001e50 <kerneltrap+0x38>
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	f88080e7          	jalr	-120(ra) # 80000e52 <myproc>
    80001ed2:	4d18                	lw	a4,24(a0)
    80001ed4:	4791                	li	a5,4
    80001ed6:	f6f71de3          	bne	a4,a5,80001e50 <kerneltrap+0x38>
    yield();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	5fc080e7          	jalr	1532(ra) # 800014d6 <yield>
    80001ee2:	b7bd                	j	80001e50 <kerneltrap+0x38>

0000000080001ee4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ee4:	1101                	addi	sp,sp,-32
    80001ee6:	ec06                	sd	ra,24(sp)
    80001ee8:	e822                	sd	s0,16(sp)
    80001eea:	e426                	sd	s1,8(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f62080e7          	jalr	-158(ra) # 80000e52 <myproc>
  switch (n) {
    80001ef8:	4795                	li	a5,5
    80001efa:	0497e163          	bltu	a5,s1,80001f3c <argraw+0x58>
    80001efe:	048a                	slli	s1,s1,0x2
    80001f00:	00006717          	auipc	a4,0x6
    80001f04:	4b870713          	addi	a4,a4,1208 # 800083b8 <states.0+0x170>
    80001f08:	94ba                	add	s1,s1,a4
    80001f0a:	409c                	lw	a5,0(s1)
    80001f0c:	97ba                	add	a5,a5,a4
    80001f0e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret
    return p->trapframe->a1;
    80001f1e:	6d3c                	ld	a5,88(a0)
    80001f20:	7fa8                	ld	a0,120(a5)
    80001f22:	bfcd                	j	80001f14 <argraw+0x30>
    return p->trapframe->a2;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	63c8                	ld	a0,128(a5)
    80001f28:	b7f5                	j	80001f14 <argraw+0x30>
    return p->trapframe->a3;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	67c8                	ld	a0,136(a5)
    80001f2e:	b7dd                	j	80001f14 <argraw+0x30>
    return p->trapframe->a4;
    80001f30:	6d3c                	ld	a5,88(a0)
    80001f32:	6bc8                	ld	a0,144(a5)
    80001f34:	b7c5                	j	80001f14 <argraw+0x30>
    return p->trapframe->a5;
    80001f36:	6d3c                	ld	a5,88(a0)
    80001f38:	6fc8                	ld	a0,152(a5)
    80001f3a:	bfe9                	j	80001f14 <argraw+0x30>
  panic("argraw");
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	45450513          	addi	a0,a0,1108 # 80008390 <states.0+0x148>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	d5c080e7          	jalr	-676(ra) # 80005ca0 <panic>

0000000080001f4c <fetchaddr>:
{
    80001f4c:	1101                	addi	sp,sp,-32
    80001f4e:	ec06                	sd	ra,24(sp)
    80001f50:	e822                	sd	s0,16(sp)
    80001f52:	e426                	sd	s1,8(sp)
    80001f54:	e04a                	sd	s2,0(sp)
    80001f56:	1000                	addi	s0,sp,32
    80001f58:	84aa                	mv	s1,a0
    80001f5a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	ef6080e7          	jalr	-266(ra) # 80000e52 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f64:	653c                	ld	a5,72(a0)
    80001f66:	02f4f863          	bgeu	s1,a5,80001f96 <fetchaddr+0x4a>
    80001f6a:	00848713          	addi	a4,s1,8
    80001f6e:	02e7e663          	bltu	a5,a4,80001f9a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f72:	46a1                	li	a3,8
    80001f74:	8626                	mv	a2,s1
    80001f76:	85ca                	mv	a1,s2
    80001f78:	6928                	ld	a0,80(a0)
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	c24080e7          	jalr	-988(ra) # 80000b9e <copyin>
    80001f82:	00a03533          	snez	a0,a0
    80001f86:	40a00533          	neg	a0,a0
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6902                	ld	s2,0(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret
    return -1;
    80001f96:	557d                	li	a0,-1
    80001f98:	bfcd                	j	80001f8a <fetchaddr+0x3e>
    80001f9a:	557d                	li	a0,-1
    80001f9c:	b7fd                	j	80001f8a <fetchaddr+0x3e>

0000000080001f9e <fetchstr>:
{
    80001f9e:	7179                	addi	sp,sp,-48
    80001fa0:	f406                	sd	ra,40(sp)
    80001fa2:	f022                	sd	s0,32(sp)
    80001fa4:	ec26                	sd	s1,24(sp)
    80001fa6:	e84a                	sd	s2,16(sp)
    80001fa8:	e44e                	sd	s3,8(sp)
    80001faa:	1800                	addi	s0,sp,48
    80001fac:	892a                	mv	s2,a0
    80001fae:	84ae                	mv	s1,a1
    80001fb0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	ea0080e7          	jalr	-352(ra) # 80000e52 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fba:	86ce                	mv	a3,s3
    80001fbc:	864a                	mv	a2,s2
    80001fbe:	85a6                	mv	a1,s1
    80001fc0:	6928                	ld	a0,80(a0)
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	c6a080e7          	jalr	-918(ra) # 80000c2c <copyinstr>
    80001fca:	00054e63          	bltz	a0,80001fe6 <fetchstr+0x48>
  return strlen(buf);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	ffffe097          	auipc	ra,0xffffe
    80001fd4:	324080e7          	jalr	804(ra) # 800002f4 <strlen>
}
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6942                	ld	s2,16(sp)
    80001fe0:	69a2                	ld	s3,8(sp)
    80001fe2:	6145                	addi	sp,sp,48
    80001fe4:	8082                	ret
    return -1;
    80001fe6:	557d                	li	a0,-1
    80001fe8:	bfc5                	j	80001fd8 <fetchstr+0x3a>

0000000080001fea <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fea:	1101                	addi	sp,sp,-32
    80001fec:	ec06                	sd	ra,24(sp)
    80001fee:	e822                	sd	s0,16(sp)
    80001ff0:	e426                	sd	s1,8(sp)
    80001ff2:	1000                	addi	s0,sp,32
    80001ff4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	eee080e7          	jalr	-274(ra) # 80001ee4 <argraw>
    80001ffe:	c088                	sw	a0,0(s1)
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret

000000008000200a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	ece080e7          	jalr	-306(ra) # 80001ee4 <argraw>
    8000201e:	e088                	sd	a0,0(s1)
}
    80002020:	60e2                	ld	ra,24(sp)
    80002022:	6442                	ld	s0,16(sp)
    80002024:	64a2                	ld	s1,8(sp)
    80002026:	6105                	addi	sp,sp,32
    80002028:	8082                	ret

000000008000202a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000202a:	7179                	addi	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	1800                	addi	s0,sp,48
    80002036:	84ae                	mv	s1,a1
    80002038:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000203a:	fd840593          	addi	a1,s0,-40
    8000203e:	00000097          	auipc	ra,0x0
    80002042:	fcc080e7          	jalr	-52(ra) # 8000200a <argaddr>
  return fetchstr(addr, buf, max);
    80002046:	864a                	mv	a2,s2
    80002048:	85a6                	mv	a1,s1
    8000204a:	fd843503          	ld	a0,-40(s0)
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	f50080e7          	jalr	-176(ra) # 80001f9e <fetchstr>
}
    80002056:	70a2                	ld	ra,40(sp)
    80002058:	7402                	ld	s0,32(sp)
    8000205a:	64e2                	ld	s1,24(sp)
    8000205c:	6942                	ld	s2,16(sp)
    8000205e:	6145                	addi	sp,sp,48
    80002060:	8082                	ret

0000000080002062 <syscall>:
[SYS_sigreturn] sys_sigreturn 
};

void
syscall(void)
{
    80002062:	1101                	addi	sp,sp,-32
    80002064:	ec06                	sd	ra,24(sp)
    80002066:	e822                	sd	s0,16(sp)
    80002068:	e426                	sd	s1,8(sp)
    8000206a:	e04a                	sd	s2,0(sp)
    8000206c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	de4080e7          	jalr	-540(ra) # 80000e52 <myproc>
    80002076:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002078:	05853903          	ld	s2,88(a0)
    8000207c:	0a893783          	ld	a5,168(s2)
    80002080:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002084:	37fd                	addiw	a5,a5,-1
    80002086:	4759                	li	a4,22
    80002088:	00f76f63          	bltu	a4,a5,800020a6 <syscall+0x44>
    8000208c:	00369713          	slli	a4,a3,0x3
    80002090:	00006797          	auipc	a5,0x6
    80002094:	34078793          	addi	a5,a5,832 # 800083d0 <syscalls>
    80002098:	97ba                	add	a5,a5,a4
    8000209a:	639c                	ld	a5,0(a5)
    8000209c:	c789                	beqz	a5,800020a6 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000209e:	9782                	jalr	a5
    800020a0:	06a93823          	sd	a0,112(s2)
    800020a4:	a839                	j	800020c2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020a6:	15848613          	addi	a2,s1,344
    800020aa:	588c                	lw	a1,48(s1)
    800020ac:	00006517          	auipc	a0,0x6
    800020b0:	2ec50513          	addi	a0,a0,748 # 80008398 <states.0+0x150>
    800020b4:	00004097          	auipc	ra,0x4
    800020b8:	c3e080e7          	jalr	-962(ra) # 80005cf2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020bc:	6cbc                	ld	a5,88(s1)
    800020be:	577d                	li	a4,-1
    800020c0:	fbb8                	sd	a4,112(a5)
  }
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020d6:	fec40593          	addi	a1,s0,-20
    800020da:	4501                	li	a0,0
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	f0e080e7          	jalr	-242(ra) # 80001fea <argint>
  exit(n);
    800020e4:	fec42503          	lw	a0,-20(s0)
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	55e080e7          	jalr	1374(ra) # 80001646 <exit>
  return 0;  // not reached
}
    800020f0:	4501                	li	a0,0
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret

00000000800020fa <sys_getpid>:

uint64
sys_getpid(void)
{
    800020fa:	1141                	addi	sp,sp,-16
    800020fc:	e406                	sd	ra,8(sp)
    800020fe:	e022                	sd	s0,0(sp)
    80002100:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d50080e7          	jalr	-688(ra) # 80000e52 <myproc>
}
    8000210a:	5908                	lw	a0,48(a0)
    8000210c:	60a2                	ld	ra,8(sp)
    8000210e:	6402                	ld	s0,0(sp)
    80002110:	0141                	addi	sp,sp,16
    80002112:	8082                	ret

0000000080002114 <sys_fork>:

uint64
sys_fork(void)
{
    80002114:	1141                	addi	sp,sp,-16
    80002116:	e406                	sd	ra,8(sp)
    80002118:	e022                	sd	s0,0(sp)
    8000211a:	0800                	addi	s0,sp,16
  return fork();
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	104080e7          	jalr	260(ra) # 80001220 <fork>
}
    80002124:	60a2                	ld	ra,8(sp)
    80002126:	6402                	ld	s0,0(sp)
    80002128:	0141                	addi	sp,sp,16
    8000212a:	8082                	ret

000000008000212c <sys_wait>:

uint64
sys_wait(void)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002134:	fe840593          	addi	a1,s0,-24
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	ed0080e7          	jalr	-304(ra) # 8000200a <argaddr>
  return wait(p);
    80002142:	fe843503          	ld	a0,-24(s0)
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	6a6080e7          	jalr	1702(ra) # 800017ec <wait>
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002156:	7179                	addi	sp,sp,-48
    80002158:	f406                	sd	ra,40(sp)
    8000215a:	f022                	sd	s0,32(sp)
    8000215c:	ec26                	sd	s1,24(sp)
    8000215e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002160:	fdc40593          	addi	a1,s0,-36
    80002164:	4501                	li	a0,0
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	e84080e7          	jalr	-380(ra) # 80001fea <argint>
  addr = myproc()->sz;
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	ce4080e7          	jalr	-796(ra) # 80000e52 <myproc>
    80002176:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002178:	fdc42503          	lw	a0,-36(s0)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	048080e7          	jalr	72(ra) # 800011c4 <growproc>
    80002184:	00054863          	bltz	a0,80002194 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002188:	8526                	mv	a0,s1
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6145                	addi	sp,sp,48
    80002192:	8082                	ret
    return -1;
    80002194:	54fd                	li	s1,-1
    80002196:	bfcd                	j	80002188 <sys_sbrk+0x32>

0000000080002198 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002198:	7139                	addi	sp,sp,-64
    8000219a:	fc06                	sd	ra,56(sp)
    8000219c:	f822                	sd	s0,48(sp)
    8000219e:	f426                	sd	s1,40(sp)
    800021a0:	f04a                	sd	s2,32(sp)
    800021a2:	ec4e                	sd	s3,24(sp)
    800021a4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	aa2080e7          	jalr	-1374(ra) # 80005c48 <backtrace>
  argint(0, &n);
    800021ae:	fcc40593          	addi	a1,s0,-52
    800021b2:	4501                	li	a0,0
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	e36080e7          	jalr	-458(ra) # 80001fea <argint>
  if(n < 0)
    800021bc:	fcc42783          	lw	a5,-52(s0)
    800021c0:	0607cf63          	bltz	a5,8000223e <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    800021c4:	0000d517          	auipc	a0,0xd
    800021c8:	99c50513          	addi	a0,a0,-1636 # 8000eb60 <tickslock>
    800021cc:	00004097          	auipc	ra,0x4
    800021d0:	fe2080e7          	jalr	-30(ra) # 800061ae <acquire>
  ticks0 = ticks;
    800021d4:	00006917          	auipc	s2,0x6
    800021d8:	72492903          	lw	s2,1828(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800021dc:	fcc42783          	lw	a5,-52(s0)
    800021e0:	cf9d                	beqz	a5,8000221e <sys_sleep+0x86>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e2:	0000d997          	auipc	s3,0xd
    800021e6:	97e98993          	addi	s3,s3,-1666 # 8000eb60 <tickslock>
    800021ea:	00006497          	auipc	s1,0x6
    800021ee:	70e48493          	addi	s1,s1,1806 # 800088f8 <ticks>
    if(killed(myproc())){
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	c60080e7          	jalr	-928(ra) # 80000e52 <myproc>
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	5c0080e7          	jalr	1472(ra) # 800017ba <killed>
    80002202:	e129                	bnez	a0,80002244 <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    80002204:	85ce                	mv	a1,s3
    80002206:	8526                	mv	a0,s1
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	30a080e7          	jalr	778(ra) # 80001512 <sleep>
  while(ticks - ticks0 < n){
    80002210:	409c                	lw	a5,0(s1)
    80002212:	412787bb          	subw	a5,a5,s2
    80002216:	fcc42703          	lw	a4,-52(s0)
    8000221a:	fce7ece3          	bltu	a5,a4,800021f2 <sys_sleep+0x5a>
  }
  release(&tickslock);
    8000221e:	0000d517          	auipc	a0,0xd
    80002222:	94250513          	addi	a0,a0,-1726 # 8000eb60 <tickslock>
    80002226:	00004097          	auipc	ra,0x4
    8000222a:	03c080e7          	jalr	60(ra) # 80006262 <release>
  
  return 0;
    8000222e:	4501                	li	a0,0
}
    80002230:	70e2                	ld	ra,56(sp)
    80002232:	7442                	ld	s0,48(sp)
    80002234:	74a2                	ld	s1,40(sp)
    80002236:	7902                	ld	s2,32(sp)
    80002238:	69e2                	ld	s3,24(sp)
    8000223a:	6121                	addi	sp,sp,64
    8000223c:	8082                	ret
    n = 0;
    8000223e:	fc042623          	sw	zero,-52(s0)
    80002242:	b749                	j	800021c4 <sys_sleep+0x2c>
      release(&tickslock);
    80002244:	0000d517          	auipc	a0,0xd
    80002248:	91c50513          	addi	a0,a0,-1764 # 8000eb60 <tickslock>
    8000224c:	00004097          	auipc	ra,0x4
    80002250:	016080e7          	jalr	22(ra) # 80006262 <release>
      return -1;
    80002254:	557d                	li	a0,-1
    80002256:	bfe9                	j	80002230 <sys_sleep+0x98>

0000000080002258 <sys_kill>:

uint64
sys_kill(void)
{
    80002258:	1101                	addi	sp,sp,-32
    8000225a:	ec06                	sd	ra,24(sp)
    8000225c:	e822                	sd	s0,16(sp)
    8000225e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002260:	fec40593          	addi	a1,s0,-20
    80002264:	4501                	li	a0,0
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	d84080e7          	jalr	-636(ra) # 80001fea <argint>
  return kill(pid);
    8000226e:	fec42503          	lw	a0,-20(s0)
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	4aa080e7          	jalr	1194(ra) # 8000171c <kill>
}
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	6105                	addi	sp,sp,32
    80002280:	8082                	ret

0000000080002282 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002282:	1101                	addi	sp,sp,-32
    80002284:	ec06                	sd	ra,24(sp)
    80002286:	e822                	sd	s0,16(sp)
    80002288:	e426                	sd	s1,8(sp)
    8000228a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000228c:	0000d517          	auipc	a0,0xd
    80002290:	8d450513          	addi	a0,a0,-1836 # 8000eb60 <tickslock>
    80002294:	00004097          	auipc	ra,0x4
    80002298:	f1a080e7          	jalr	-230(ra) # 800061ae <acquire>
  xticks = ticks;
    8000229c:	00006497          	auipc	s1,0x6
    800022a0:	65c4a483          	lw	s1,1628(s1) # 800088f8 <ticks>
  release(&tickslock);
    800022a4:	0000d517          	auipc	a0,0xd
    800022a8:	8bc50513          	addi	a0,a0,-1860 # 8000eb60 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	fb6080e7          	jalr	-74(ra) # 80006262 <release>
  return xticks;
}
    800022b4:	02049513          	slli	a0,s1,0x20
    800022b8:	9101                	srli	a0,a0,0x20
    800022ba:	60e2                	ld	ra,24(sp)
    800022bc:	6442                	ld	s0,16(sp)
    800022be:	64a2                	ld	s1,8(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret

00000000800022c4 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    800022c4:	1101                	addi	sp,sp,-32
    800022c6:	ec06                	sd	ra,24(sp)
    800022c8:	e822                	sd	s0,16(sp)
    800022ca:	1000                	addi	s0,sp,32
  int ticks;
  uint64 handler;
  argint(0, &ticks);
    800022cc:	fec40593          	addi	a1,s0,-20
    800022d0:	4501                	li	a0,0
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	d18080e7          	jalr	-744(ra) # 80001fea <argint>
  argaddr(1, &handler);
    800022da:	fe040593          	addi	a1,s0,-32
    800022de:	4505                	li	a0,1
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	d2a080e7          	jalr	-726(ra) # 8000200a <argaddr>
  if(!(ticks | handler))return -1;
    800022e8:	fec42783          	lw	a5,-20(s0)
    800022ec:	fe043583          	ld	a1,-32(s0)
    800022f0:	00b7e733          	or	a4,a5,a1
    800022f4:	557d                	li	a0,-1
    800022f6:	c711                	beqz	a4,80002302 <sys_sigalarm+0x3e>
  return sigalarm(ticks, (void(*)())handler);
    800022f8:	853e                	mv	a0,a5
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	77c080e7          	jalr	1916(ra) # 80001a76 <sigalarm>
}
    80002302:	60e2                	ld	ra,24(sp)
    80002304:	6442                	ld	s0,16(sp)
    80002306:	6105                	addi	sp,sp,32
    80002308:	8082                	ret

000000008000230a <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000230a:	1141                	addi	sp,sp,-16
    8000230c:	e406                	sd	ra,8(sp)
    8000230e:	e022                	sd	s0,0(sp)
    80002310:	0800                	addi	s0,sp,16
  return sigreturn();
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	796080e7          	jalr	1942(ra) # 80001aa8 <sigreturn>
    8000231a:	60a2                	ld	ra,8(sp)
    8000231c:	6402                	ld	s0,0(sp)
    8000231e:	0141                	addi	sp,sp,16
    80002320:	8082                	ret

0000000080002322 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002322:	7179                	addi	sp,sp,-48
    80002324:	f406                	sd	ra,40(sp)
    80002326:	f022                	sd	s0,32(sp)
    80002328:	ec26                	sd	s1,24(sp)
    8000232a:	e84a                	sd	s2,16(sp)
    8000232c:	e44e                	sd	s3,8(sp)
    8000232e:	e052                	sd	s4,0(sp)
    80002330:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002332:	00006597          	auipc	a1,0x6
    80002336:	15e58593          	addi	a1,a1,350 # 80008490 <syscalls+0xc0>
    8000233a:	0000d517          	auipc	a0,0xd
    8000233e:	83e50513          	addi	a0,a0,-1986 # 8000eb78 <bcache>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	ddc080e7          	jalr	-548(ra) # 8000611e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000234a:	00015797          	auipc	a5,0x15
    8000234e:	82e78793          	addi	a5,a5,-2002 # 80016b78 <bcache+0x8000>
    80002352:	00015717          	auipc	a4,0x15
    80002356:	a8e70713          	addi	a4,a4,-1394 # 80016de0 <bcache+0x8268>
    8000235a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000235e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002362:	0000d497          	auipc	s1,0xd
    80002366:	82e48493          	addi	s1,s1,-2002 # 8000eb90 <bcache+0x18>
    b->next = bcache.head.next;
    8000236a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000236c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000236e:	00006a17          	auipc	s4,0x6
    80002372:	12aa0a13          	addi	s4,s4,298 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002376:	2b893783          	ld	a5,696(s2)
    8000237a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000237c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002380:	85d2                	mv	a1,s4
    80002382:	01048513          	addi	a0,s1,16
    80002386:	00001097          	auipc	ra,0x1
    8000238a:	496080e7          	jalr	1174(ra) # 8000381c <initsleeplock>
    bcache.head.next->prev = b;
    8000238e:	2b893783          	ld	a5,696(s2)
    80002392:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002394:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002398:	45848493          	addi	s1,s1,1112
    8000239c:	fd349de3          	bne	s1,s3,80002376 <binit+0x54>
  }
}
    800023a0:	70a2                	ld	ra,40(sp)
    800023a2:	7402                	ld	s0,32(sp)
    800023a4:	64e2                	ld	s1,24(sp)
    800023a6:	6942                	ld	s2,16(sp)
    800023a8:	69a2                	ld	s3,8(sp)
    800023aa:	6a02                	ld	s4,0(sp)
    800023ac:	6145                	addi	sp,sp,48
    800023ae:	8082                	ret

00000000800023b0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023b0:	7179                	addi	sp,sp,-48
    800023b2:	f406                	sd	ra,40(sp)
    800023b4:	f022                	sd	s0,32(sp)
    800023b6:	ec26                	sd	s1,24(sp)
    800023b8:	e84a                	sd	s2,16(sp)
    800023ba:	e44e                	sd	s3,8(sp)
    800023bc:	1800                	addi	s0,sp,48
    800023be:	892a                	mv	s2,a0
    800023c0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023c2:	0000c517          	auipc	a0,0xc
    800023c6:	7b650513          	addi	a0,a0,1974 # 8000eb78 <bcache>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	de4080e7          	jalr	-540(ra) # 800061ae <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023d2:	00015497          	auipc	s1,0x15
    800023d6:	a5e4b483          	ld	s1,-1442(s1) # 80016e30 <bcache+0x82b8>
    800023da:	00015797          	auipc	a5,0x15
    800023de:	a0678793          	addi	a5,a5,-1530 # 80016de0 <bcache+0x8268>
    800023e2:	02f48f63          	beq	s1,a5,80002420 <bread+0x70>
    800023e6:	873e                	mv	a4,a5
    800023e8:	a021                	j	800023f0 <bread+0x40>
    800023ea:	68a4                	ld	s1,80(s1)
    800023ec:	02e48a63          	beq	s1,a4,80002420 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023f0:	449c                	lw	a5,8(s1)
    800023f2:	ff279ce3          	bne	a5,s2,800023ea <bread+0x3a>
    800023f6:	44dc                	lw	a5,12(s1)
    800023f8:	ff3799e3          	bne	a5,s3,800023ea <bread+0x3a>
      b->refcnt++;
    800023fc:	40bc                	lw	a5,64(s1)
    800023fe:	2785                	addiw	a5,a5,1
    80002400:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002402:	0000c517          	auipc	a0,0xc
    80002406:	77650513          	addi	a0,a0,1910 # 8000eb78 <bcache>
    8000240a:	00004097          	auipc	ra,0x4
    8000240e:	e58080e7          	jalr	-424(ra) # 80006262 <release>
      acquiresleep(&b->lock);
    80002412:	01048513          	addi	a0,s1,16
    80002416:	00001097          	auipc	ra,0x1
    8000241a:	440080e7          	jalr	1088(ra) # 80003856 <acquiresleep>
      return b;
    8000241e:	a8b9                	j	8000247c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002420:	00015497          	auipc	s1,0x15
    80002424:	a084b483          	ld	s1,-1528(s1) # 80016e28 <bcache+0x82b0>
    80002428:	00015797          	auipc	a5,0x15
    8000242c:	9b878793          	addi	a5,a5,-1608 # 80016de0 <bcache+0x8268>
    80002430:	00f48863          	beq	s1,a5,80002440 <bread+0x90>
    80002434:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002436:	40bc                	lw	a5,64(s1)
    80002438:	cf81                	beqz	a5,80002450 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000243a:	64a4                	ld	s1,72(s1)
    8000243c:	fee49de3          	bne	s1,a4,80002436 <bread+0x86>
  panic("bget: no buffers");
    80002440:	00006517          	auipc	a0,0x6
    80002444:	06050513          	addi	a0,a0,96 # 800084a0 <syscalls+0xd0>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	858080e7          	jalr	-1960(ra) # 80005ca0 <panic>
      b->dev = dev;
    80002450:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002454:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002458:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000245c:	4785                	li	a5,1
    8000245e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002460:	0000c517          	auipc	a0,0xc
    80002464:	71850513          	addi	a0,a0,1816 # 8000eb78 <bcache>
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	dfa080e7          	jalr	-518(ra) # 80006262 <release>
      acquiresleep(&b->lock);
    80002470:	01048513          	addi	a0,s1,16
    80002474:	00001097          	auipc	ra,0x1
    80002478:	3e2080e7          	jalr	994(ra) # 80003856 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000247c:	409c                	lw	a5,0(s1)
    8000247e:	cb89                	beqz	a5,80002490 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002480:	8526                	mv	a0,s1
    80002482:	70a2                	ld	ra,40(sp)
    80002484:	7402                	ld	s0,32(sp)
    80002486:	64e2                	ld	s1,24(sp)
    80002488:	6942                	ld	s2,16(sp)
    8000248a:	69a2                	ld	s3,8(sp)
    8000248c:	6145                	addi	sp,sp,48
    8000248e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002490:	4581                	li	a1,0
    80002492:	8526                	mv	a0,s1
    80002494:	00003097          	auipc	ra,0x3
    80002498:	f7e080e7          	jalr	-130(ra) # 80005412 <virtio_disk_rw>
    b->valid = 1;
    8000249c:	4785                	li	a5,1
    8000249e:	c09c                	sw	a5,0(s1)
  return b;
    800024a0:	b7c5                	j	80002480 <bread+0xd0>

00000000800024a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024a2:	1101                	addi	sp,sp,-32
    800024a4:	ec06                	sd	ra,24(sp)
    800024a6:	e822                	sd	s0,16(sp)
    800024a8:	e426                	sd	s1,8(sp)
    800024aa:	1000                	addi	s0,sp,32
    800024ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ae:	0541                	addi	a0,a0,16
    800024b0:	00001097          	auipc	ra,0x1
    800024b4:	440080e7          	jalr	1088(ra) # 800038f0 <holdingsleep>
    800024b8:	cd01                	beqz	a0,800024d0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ba:	4585                	li	a1,1
    800024bc:	8526                	mv	a0,s1
    800024be:	00003097          	auipc	ra,0x3
    800024c2:	f54080e7          	jalr	-172(ra) # 80005412 <virtio_disk_rw>
}
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	64a2                	ld	s1,8(sp)
    800024cc:	6105                	addi	sp,sp,32
    800024ce:	8082                	ret
    panic("bwrite");
    800024d0:	00006517          	auipc	a0,0x6
    800024d4:	fe850513          	addi	a0,a0,-24 # 800084b8 <syscalls+0xe8>
    800024d8:	00003097          	auipc	ra,0x3
    800024dc:	7c8080e7          	jalr	1992(ra) # 80005ca0 <panic>

00000000800024e0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024e0:	1101                	addi	sp,sp,-32
    800024e2:	ec06                	sd	ra,24(sp)
    800024e4:	e822                	sd	s0,16(sp)
    800024e6:	e426                	sd	s1,8(sp)
    800024e8:	e04a                	sd	s2,0(sp)
    800024ea:	1000                	addi	s0,sp,32
    800024ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ee:	01050913          	addi	s2,a0,16
    800024f2:	854a                	mv	a0,s2
    800024f4:	00001097          	auipc	ra,0x1
    800024f8:	3fc080e7          	jalr	1020(ra) # 800038f0 <holdingsleep>
    800024fc:	c925                	beqz	a0,8000256c <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800024fe:	854a                	mv	a0,s2
    80002500:	00001097          	auipc	ra,0x1
    80002504:	3ac080e7          	jalr	940(ra) # 800038ac <releasesleep>

  acquire(&bcache.lock);
    80002508:	0000c517          	auipc	a0,0xc
    8000250c:	67050513          	addi	a0,a0,1648 # 8000eb78 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	c9e080e7          	jalr	-866(ra) # 800061ae <acquire>
  b->refcnt--;
    80002518:	40bc                	lw	a5,64(s1)
    8000251a:	37fd                	addiw	a5,a5,-1
    8000251c:	0007871b          	sext.w	a4,a5
    80002520:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002522:	e71d                	bnez	a4,80002550 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002524:	68b8                	ld	a4,80(s1)
    80002526:	64bc                	ld	a5,72(s1)
    80002528:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000252a:	68b8                	ld	a4,80(s1)
    8000252c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000252e:	00014797          	auipc	a5,0x14
    80002532:	64a78793          	addi	a5,a5,1610 # 80016b78 <bcache+0x8000>
    80002536:	2b87b703          	ld	a4,696(a5)
    8000253a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000253c:	00015717          	auipc	a4,0x15
    80002540:	8a470713          	addi	a4,a4,-1884 # 80016de0 <bcache+0x8268>
    80002544:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002546:	2b87b703          	ld	a4,696(a5)
    8000254a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000254c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002550:	0000c517          	auipc	a0,0xc
    80002554:	62850513          	addi	a0,a0,1576 # 8000eb78 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	d0a080e7          	jalr	-758(ra) # 80006262 <release>
}
    80002560:	60e2                	ld	ra,24(sp)
    80002562:	6442                	ld	s0,16(sp)
    80002564:	64a2                	ld	s1,8(sp)
    80002566:	6902                	ld	s2,0(sp)
    80002568:	6105                	addi	sp,sp,32
    8000256a:	8082                	ret
    panic("brelse");
    8000256c:	00006517          	auipc	a0,0x6
    80002570:	f5450513          	addi	a0,a0,-172 # 800084c0 <syscalls+0xf0>
    80002574:	00003097          	auipc	ra,0x3
    80002578:	72c080e7          	jalr	1836(ra) # 80005ca0 <panic>

000000008000257c <bpin>:

void
bpin(struct buf *b) {
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002588:	0000c517          	auipc	a0,0xc
    8000258c:	5f050513          	addi	a0,a0,1520 # 8000eb78 <bcache>
    80002590:	00004097          	auipc	ra,0x4
    80002594:	c1e080e7          	jalr	-994(ra) # 800061ae <acquire>
  b->refcnt++;
    80002598:	40bc                	lw	a5,64(s1)
    8000259a:	2785                	addiw	a5,a5,1
    8000259c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000259e:	0000c517          	auipc	a0,0xc
    800025a2:	5da50513          	addi	a0,a0,1498 # 8000eb78 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	cbc080e7          	jalr	-836(ra) # 80006262 <release>
}
    800025ae:	60e2                	ld	ra,24(sp)
    800025b0:	6442                	ld	s0,16(sp)
    800025b2:	64a2                	ld	s1,8(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret

00000000800025b8 <bunpin>:

void
bunpin(struct buf *b) {
    800025b8:	1101                	addi	sp,sp,-32
    800025ba:	ec06                	sd	ra,24(sp)
    800025bc:	e822                	sd	s0,16(sp)
    800025be:	e426                	sd	s1,8(sp)
    800025c0:	1000                	addi	s0,sp,32
    800025c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c4:	0000c517          	auipc	a0,0xc
    800025c8:	5b450513          	addi	a0,a0,1460 # 8000eb78 <bcache>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	be2080e7          	jalr	-1054(ra) # 800061ae <acquire>
  b->refcnt--;
    800025d4:	40bc                	lw	a5,64(s1)
    800025d6:	37fd                	addiw	a5,a5,-1
    800025d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025da:	0000c517          	auipc	a0,0xc
    800025de:	59e50513          	addi	a0,a0,1438 # 8000eb78 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	c80080e7          	jalr	-896(ra) # 80006262 <release>
}
    800025ea:	60e2                	ld	ra,24(sp)
    800025ec:	6442                	ld	s0,16(sp)
    800025ee:	64a2                	ld	s1,8(sp)
    800025f0:	6105                	addi	sp,sp,32
    800025f2:	8082                	ret

00000000800025f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	e04a                	sd	s2,0(sp)
    800025fe:	1000                	addi	s0,sp,32
    80002600:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002602:	00d5d59b          	srliw	a1,a1,0xd
    80002606:	00015797          	auipc	a5,0x15
    8000260a:	c4e7a783          	lw	a5,-946(a5) # 80017254 <sb+0x1c>
    8000260e:	9dbd                	addw	a1,a1,a5
    80002610:	00000097          	auipc	ra,0x0
    80002614:	da0080e7          	jalr	-608(ra) # 800023b0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002618:	0074f713          	andi	a4,s1,7
    8000261c:	4785                	li	a5,1
    8000261e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002622:	14ce                	slli	s1,s1,0x33
    80002624:	90d9                	srli	s1,s1,0x36
    80002626:	00950733          	add	a4,a0,s1
    8000262a:	05874703          	lbu	a4,88(a4)
    8000262e:	00e7f6b3          	and	a3,a5,a4
    80002632:	c69d                	beqz	a3,80002660 <bfree+0x6c>
    80002634:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002636:	94aa                	add	s1,s1,a0
    80002638:	fff7c793          	not	a5,a5
    8000263c:	8f7d                	and	a4,a4,a5
    8000263e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002642:	00001097          	auipc	ra,0x1
    80002646:	0f6080e7          	jalr	246(ra) # 80003738 <log_write>
  brelse(bp);
    8000264a:	854a                	mv	a0,s2
    8000264c:	00000097          	auipc	ra,0x0
    80002650:	e94080e7          	jalr	-364(ra) # 800024e0 <brelse>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret
    panic("freeing free block");
    80002660:	00006517          	auipc	a0,0x6
    80002664:	e6850513          	addi	a0,a0,-408 # 800084c8 <syscalls+0xf8>
    80002668:	00003097          	auipc	ra,0x3
    8000266c:	638080e7          	jalr	1592(ra) # 80005ca0 <panic>

0000000080002670 <balloc>:
{
    80002670:	711d                	addi	sp,sp,-96
    80002672:	ec86                	sd	ra,88(sp)
    80002674:	e8a2                	sd	s0,80(sp)
    80002676:	e4a6                	sd	s1,72(sp)
    80002678:	e0ca                	sd	s2,64(sp)
    8000267a:	fc4e                	sd	s3,56(sp)
    8000267c:	f852                	sd	s4,48(sp)
    8000267e:	f456                	sd	s5,40(sp)
    80002680:	f05a                	sd	s6,32(sp)
    80002682:	ec5e                	sd	s7,24(sp)
    80002684:	e862                	sd	s8,16(sp)
    80002686:	e466                	sd	s9,8(sp)
    80002688:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000268a:	00015797          	auipc	a5,0x15
    8000268e:	bb27a783          	lw	a5,-1102(a5) # 8001723c <sb+0x4>
    80002692:	cff5                	beqz	a5,8000278e <balloc+0x11e>
    80002694:	8baa                	mv	s7,a0
    80002696:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002698:	00015b17          	auipc	s6,0x15
    8000269c:	ba0b0b13          	addi	s6,s6,-1120 # 80017238 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026a2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026a6:	6c89                	lui	s9,0x2
    800026a8:	a061                	j	80002730 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026aa:	97ca                	add	a5,a5,s2
    800026ac:	8e55                	or	a2,a2,a3
    800026ae:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026b2:	854a                	mv	a0,s2
    800026b4:	00001097          	auipc	ra,0x1
    800026b8:	084080e7          	jalr	132(ra) # 80003738 <log_write>
        brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	e22080e7          	jalr	-478(ra) # 800024e0 <brelse>
  bp = bread(dev, bno);
    800026c6:	85a6                	mv	a1,s1
    800026c8:	855e                	mv	a0,s7
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	ce6080e7          	jalr	-794(ra) # 800023b0 <bread>
    800026d2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026d4:	40000613          	li	a2,1024
    800026d8:	4581                	li	a1,0
    800026da:	05850513          	addi	a0,a0,88
    800026de:	ffffe097          	auipc	ra,0xffffe
    800026e2:	a9c080e7          	jalr	-1380(ra) # 8000017a <memset>
  log_write(bp);
    800026e6:	854a                	mv	a0,s2
    800026e8:	00001097          	auipc	ra,0x1
    800026ec:	050080e7          	jalr	80(ra) # 80003738 <log_write>
  brelse(bp);
    800026f0:	854a                	mv	a0,s2
    800026f2:	00000097          	auipc	ra,0x0
    800026f6:	dee080e7          	jalr	-530(ra) # 800024e0 <brelse>
}
    800026fa:	8526                	mv	a0,s1
    800026fc:	60e6                	ld	ra,88(sp)
    800026fe:	6446                	ld	s0,80(sp)
    80002700:	64a6                	ld	s1,72(sp)
    80002702:	6906                	ld	s2,64(sp)
    80002704:	79e2                	ld	s3,56(sp)
    80002706:	7a42                	ld	s4,48(sp)
    80002708:	7aa2                	ld	s5,40(sp)
    8000270a:	7b02                	ld	s6,32(sp)
    8000270c:	6be2                	ld	s7,24(sp)
    8000270e:	6c42                	ld	s8,16(sp)
    80002710:	6ca2                	ld	s9,8(sp)
    80002712:	6125                	addi	sp,sp,96
    80002714:	8082                	ret
    brelse(bp);
    80002716:	854a                	mv	a0,s2
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	dc8080e7          	jalr	-568(ra) # 800024e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002720:	015c87bb          	addw	a5,s9,s5
    80002724:	00078a9b          	sext.w	s5,a5
    80002728:	004b2703          	lw	a4,4(s6)
    8000272c:	06eaf163          	bgeu	s5,a4,8000278e <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002730:	41fad79b          	sraiw	a5,s5,0x1f
    80002734:	0137d79b          	srliw	a5,a5,0x13
    80002738:	015787bb          	addw	a5,a5,s5
    8000273c:	40d7d79b          	sraiw	a5,a5,0xd
    80002740:	01cb2583          	lw	a1,28(s6)
    80002744:	9dbd                	addw	a1,a1,a5
    80002746:	855e                	mv	a0,s7
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	c68080e7          	jalr	-920(ra) # 800023b0 <bread>
    80002750:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002752:	004b2503          	lw	a0,4(s6)
    80002756:	000a849b          	sext.w	s1,s5
    8000275a:	8762                	mv	a4,s8
    8000275c:	faa4fde3          	bgeu	s1,a0,80002716 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002760:	00777693          	andi	a3,a4,7
    80002764:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002768:	41f7579b          	sraiw	a5,a4,0x1f
    8000276c:	01d7d79b          	srliw	a5,a5,0x1d
    80002770:	9fb9                	addw	a5,a5,a4
    80002772:	4037d79b          	sraiw	a5,a5,0x3
    80002776:	00f90633          	add	a2,s2,a5
    8000277a:	05864603          	lbu	a2,88(a2)
    8000277e:	00c6f5b3          	and	a1,a3,a2
    80002782:	d585                	beqz	a1,800026aa <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002784:	2705                	addiw	a4,a4,1
    80002786:	2485                	addiw	s1,s1,1
    80002788:	fd471ae3          	bne	a4,s4,8000275c <balloc+0xec>
    8000278c:	b769                	j	80002716 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000278e:	00006517          	auipc	a0,0x6
    80002792:	d5250513          	addi	a0,a0,-686 # 800084e0 <syscalls+0x110>
    80002796:	00003097          	auipc	ra,0x3
    8000279a:	55c080e7          	jalr	1372(ra) # 80005cf2 <printf>
  return 0;
    8000279e:	4481                	li	s1,0
    800027a0:	bfa9                	j	800026fa <balloc+0x8a>

00000000800027a2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	e052                	sd	s4,0(sp)
    800027b0:	1800                	addi	s0,sp,48
    800027b2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027b4:	47ad                	li	a5,11
    800027b6:	02b7e863          	bltu	a5,a1,800027e6 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800027ba:	02059793          	slli	a5,a1,0x20
    800027be:	01e7d593          	srli	a1,a5,0x1e
    800027c2:	00b504b3          	add	s1,a0,a1
    800027c6:	0504a903          	lw	s2,80(s1)
    800027ca:	06091e63          	bnez	s2,80002846 <bmap+0xa4>
      addr = balloc(ip->dev);
    800027ce:	4108                	lw	a0,0(a0)
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	ea0080e7          	jalr	-352(ra) # 80002670 <balloc>
    800027d8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027dc:	06090563          	beqz	s2,80002846 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800027e0:	0524a823          	sw	s2,80(s1)
    800027e4:	a08d                	j	80002846 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027e6:	ff45849b          	addiw	s1,a1,-12
    800027ea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027ee:	0ff00793          	li	a5,255
    800027f2:	08e7e563          	bltu	a5,a4,8000287c <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800027f6:	08052903          	lw	s2,128(a0)
    800027fa:	00091d63          	bnez	s2,80002814 <bmap+0x72>
      addr = balloc(ip->dev);
    800027fe:	4108                	lw	a0,0(a0)
    80002800:	00000097          	auipc	ra,0x0
    80002804:	e70080e7          	jalr	-400(ra) # 80002670 <balloc>
    80002808:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000280c:	02090d63          	beqz	s2,80002846 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002810:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002814:	85ca                	mv	a1,s2
    80002816:	0009a503          	lw	a0,0(s3)
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	b96080e7          	jalr	-1130(ra) # 800023b0 <bread>
    80002822:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002824:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002828:	02049713          	slli	a4,s1,0x20
    8000282c:	01e75593          	srli	a1,a4,0x1e
    80002830:	00b784b3          	add	s1,a5,a1
    80002834:	0004a903          	lw	s2,0(s1)
    80002838:	02090063          	beqz	s2,80002858 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000283c:	8552                	mv	a0,s4
    8000283e:	00000097          	auipc	ra,0x0
    80002842:	ca2080e7          	jalr	-862(ra) # 800024e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002846:	854a                	mv	a0,s2
    80002848:	70a2                	ld	ra,40(sp)
    8000284a:	7402                	ld	s0,32(sp)
    8000284c:	64e2                	ld	s1,24(sp)
    8000284e:	6942                	ld	s2,16(sp)
    80002850:	69a2                	ld	s3,8(sp)
    80002852:	6a02                	ld	s4,0(sp)
    80002854:	6145                	addi	sp,sp,48
    80002856:	8082                	ret
      addr = balloc(ip->dev);
    80002858:	0009a503          	lw	a0,0(s3)
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e14080e7          	jalr	-492(ra) # 80002670 <balloc>
    80002864:	0005091b          	sext.w	s2,a0
      if(addr){
    80002868:	fc090ae3          	beqz	s2,8000283c <bmap+0x9a>
        a[bn] = addr;
    8000286c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002870:	8552                	mv	a0,s4
    80002872:	00001097          	auipc	ra,0x1
    80002876:	ec6080e7          	jalr	-314(ra) # 80003738 <log_write>
    8000287a:	b7c9                	j	8000283c <bmap+0x9a>
  panic("bmap: out of range");
    8000287c:	00006517          	auipc	a0,0x6
    80002880:	c7c50513          	addi	a0,a0,-900 # 800084f8 <syscalls+0x128>
    80002884:	00003097          	auipc	ra,0x3
    80002888:	41c080e7          	jalr	1052(ra) # 80005ca0 <panic>

000000008000288c <iget>:
{
    8000288c:	7179                	addi	sp,sp,-48
    8000288e:	f406                	sd	ra,40(sp)
    80002890:	f022                	sd	s0,32(sp)
    80002892:	ec26                	sd	s1,24(sp)
    80002894:	e84a                	sd	s2,16(sp)
    80002896:	e44e                	sd	s3,8(sp)
    80002898:	e052                	sd	s4,0(sp)
    8000289a:	1800                	addi	s0,sp,48
    8000289c:	89aa                	mv	s3,a0
    8000289e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a0:	00015517          	auipc	a0,0x15
    800028a4:	9b850513          	addi	a0,a0,-1608 # 80017258 <itable>
    800028a8:	00004097          	auipc	ra,0x4
    800028ac:	906080e7          	jalr	-1786(ra) # 800061ae <acquire>
  empty = 0;
    800028b0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b2:	00015497          	auipc	s1,0x15
    800028b6:	9be48493          	addi	s1,s1,-1602 # 80017270 <itable+0x18>
    800028ba:	00016697          	auipc	a3,0x16
    800028be:	44668693          	addi	a3,a3,1094 # 80018d00 <log>
    800028c2:	a039                	j	800028d0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c4:	02090b63          	beqz	s2,800028fa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c8:	08848493          	addi	s1,s1,136
    800028cc:	02d48a63          	beq	s1,a3,80002900 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d0:	449c                	lw	a5,8(s1)
    800028d2:	fef059e3          	blez	a5,800028c4 <iget+0x38>
    800028d6:	4098                	lw	a4,0(s1)
    800028d8:	ff3716e3          	bne	a4,s3,800028c4 <iget+0x38>
    800028dc:	40d8                	lw	a4,4(s1)
    800028de:	ff4713e3          	bne	a4,s4,800028c4 <iget+0x38>
      ip->ref++;
    800028e2:	2785                	addiw	a5,a5,1
    800028e4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e6:	00015517          	auipc	a0,0x15
    800028ea:	97250513          	addi	a0,a0,-1678 # 80017258 <itable>
    800028ee:	00004097          	auipc	ra,0x4
    800028f2:	974080e7          	jalr	-1676(ra) # 80006262 <release>
      return ip;
    800028f6:	8926                	mv	s2,s1
    800028f8:	a03d                	j	80002926 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fa:	f7f9                	bnez	a5,800028c8 <iget+0x3c>
    800028fc:	8926                	mv	s2,s1
    800028fe:	b7e9                	j	800028c8 <iget+0x3c>
  if(empty == 0)
    80002900:	02090c63          	beqz	s2,80002938 <iget+0xac>
  ip->dev = dev;
    80002904:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002908:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000290c:	4785                	li	a5,1
    8000290e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002912:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002916:	00015517          	auipc	a0,0x15
    8000291a:	94250513          	addi	a0,a0,-1726 # 80017258 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	944080e7          	jalr	-1724(ra) # 80006262 <release>
}
    80002926:	854a                	mv	a0,s2
    80002928:	70a2                	ld	ra,40(sp)
    8000292a:	7402                	ld	s0,32(sp)
    8000292c:	64e2                	ld	s1,24(sp)
    8000292e:	6942                	ld	s2,16(sp)
    80002930:	69a2                	ld	s3,8(sp)
    80002932:	6a02                	ld	s4,0(sp)
    80002934:	6145                	addi	sp,sp,48
    80002936:	8082                	ret
    panic("iget: no inodes");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	bd850513          	addi	a0,a0,-1064 # 80008510 <syscalls+0x140>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	360080e7          	jalr	864(ra) # 80005ca0 <panic>

0000000080002948 <fsinit>:
fsinit(int dev) {
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	1800                	addi	s0,sp,48
    80002956:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002958:	4585                	li	a1,1
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	a56080e7          	jalr	-1450(ra) # 800023b0 <bread>
    80002962:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002964:	00015997          	auipc	s3,0x15
    80002968:	8d498993          	addi	s3,s3,-1836 # 80017238 <sb>
    8000296c:	02000613          	li	a2,32
    80002970:	05850593          	addi	a1,a0,88
    80002974:	854e                	mv	a0,s3
    80002976:	ffffe097          	auipc	ra,0xffffe
    8000297a:	860080e7          	jalr	-1952(ra) # 800001d6 <memmove>
  brelse(bp);
    8000297e:	8526                	mv	a0,s1
    80002980:	00000097          	auipc	ra,0x0
    80002984:	b60080e7          	jalr	-1184(ra) # 800024e0 <brelse>
  if(sb.magic != FSMAGIC)
    80002988:	0009a703          	lw	a4,0(s3)
    8000298c:	102037b7          	lui	a5,0x10203
    80002990:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002994:	02f71263          	bne	a4,a5,800029b8 <fsinit+0x70>
  initlog(dev, &sb);
    80002998:	00015597          	auipc	a1,0x15
    8000299c:	8a058593          	addi	a1,a1,-1888 # 80017238 <sb>
    800029a0:	854a                	mv	a0,s2
    800029a2:	00001097          	auipc	ra,0x1
    800029a6:	b2c080e7          	jalr	-1236(ra) # 800034ce <initlog>
}
    800029aa:	70a2                	ld	ra,40(sp)
    800029ac:	7402                	ld	s0,32(sp)
    800029ae:	64e2                	ld	s1,24(sp)
    800029b0:	6942                	ld	s2,16(sp)
    800029b2:	69a2                	ld	s3,8(sp)
    800029b4:	6145                	addi	sp,sp,48
    800029b6:	8082                	ret
    panic("invalid file system");
    800029b8:	00006517          	auipc	a0,0x6
    800029bc:	b6850513          	addi	a0,a0,-1176 # 80008520 <syscalls+0x150>
    800029c0:	00003097          	auipc	ra,0x3
    800029c4:	2e0080e7          	jalr	736(ra) # 80005ca0 <panic>

00000000800029c8 <iinit>:
{
    800029c8:	7179                	addi	sp,sp,-48
    800029ca:	f406                	sd	ra,40(sp)
    800029cc:	f022                	sd	s0,32(sp)
    800029ce:	ec26                	sd	s1,24(sp)
    800029d0:	e84a                	sd	s2,16(sp)
    800029d2:	e44e                	sd	s3,8(sp)
    800029d4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d6:	00006597          	auipc	a1,0x6
    800029da:	b6258593          	addi	a1,a1,-1182 # 80008538 <syscalls+0x168>
    800029de:	00015517          	auipc	a0,0x15
    800029e2:	87a50513          	addi	a0,a0,-1926 # 80017258 <itable>
    800029e6:	00003097          	auipc	ra,0x3
    800029ea:	738080e7          	jalr	1848(ra) # 8000611e <initlock>
  for(i = 0; i < NINODE; i++) {
    800029ee:	00015497          	auipc	s1,0x15
    800029f2:	89248493          	addi	s1,s1,-1902 # 80017280 <itable+0x28>
    800029f6:	00016997          	auipc	s3,0x16
    800029fa:	31a98993          	addi	s3,s3,794 # 80018d10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029fe:	00006917          	auipc	s2,0x6
    80002a02:	b4290913          	addi	s2,s2,-1214 # 80008540 <syscalls+0x170>
    80002a06:	85ca                	mv	a1,s2
    80002a08:	8526                	mv	a0,s1
    80002a0a:	00001097          	auipc	ra,0x1
    80002a0e:	e12080e7          	jalr	-494(ra) # 8000381c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a12:	08848493          	addi	s1,s1,136
    80002a16:	ff3498e3          	bne	s1,s3,80002a06 <iinit+0x3e>
}
    80002a1a:	70a2                	ld	ra,40(sp)
    80002a1c:	7402                	ld	s0,32(sp)
    80002a1e:	64e2                	ld	s1,24(sp)
    80002a20:	6942                	ld	s2,16(sp)
    80002a22:	69a2                	ld	s3,8(sp)
    80002a24:	6145                	addi	sp,sp,48
    80002a26:	8082                	ret

0000000080002a28 <ialloc>:
{
    80002a28:	7139                	addi	sp,sp,-64
    80002a2a:	fc06                	sd	ra,56(sp)
    80002a2c:	f822                	sd	s0,48(sp)
    80002a2e:	f426                	sd	s1,40(sp)
    80002a30:	f04a                	sd	s2,32(sp)
    80002a32:	ec4e                	sd	s3,24(sp)
    80002a34:	e852                	sd	s4,16(sp)
    80002a36:	e456                	sd	s5,8(sp)
    80002a38:	e05a                	sd	s6,0(sp)
    80002a3a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a3c:	00015717          	auipc	a4,0x15
    80002a40:	80872703          	lw	a4,-2040(a4) # 80017244 <sb+0xc>
    80002a44:	4785                	li	a5,1
    80002a46:	04e7f863          	bgeu	a5,a4,80002a96 <ialloc+0x6e>
    80002a4a:	8aaa                	mv	s5,a0
    80002a4c:	8b2e                	mv	s6,a1
    80002a4e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a50:	00014a17          	auipc	s4,0x14
    80002a54:	7e8a0a13          	addi	s4,s4,2024 # 80017238 <sb>
    80002a58:	00495593          	srli	a1,s2,0x4
    80002a5c:	018a2783          	lw	a5,24(s4)
    80002a60:	9dbd                	addw	a1,a1,a5
    80002a62:	8556                	mv	a0,s5
    80002a64:	00000097          	auipc	ra,0x0
    80002a68:	94c080e7          	jalr	-1716(ra) # 800023b0 <bread>
    80002a6c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a6e:	05850993          	addi	s3,a0,88
    80002a72:	00f97793          	andi	a5,s2,15
    80002a76:	079a                	slli	a5,a5,0x6
    80002a78:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a7a:	00099783          	lh	a5,0(s3)
    80002a7e:	cf9d                	beqz	a5,80002abc <ialloc+0x94>
    brelse(bp);
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	a60080e7          	jalr	-1440(ra) # 800024e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a88:	0905                	addi	s2,s2,1
    80002a8a:	00ca2703          	lw	a4,12(s4)
    80002a8e:	0009079b          	sext.w	a5,s2
    80002a92:	fce7e3e3          	bltu	a5,a4,80002a58 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a96:	00006517          	auipc	a0,0x6
    80002a9a:	ab250513          	addi	a0,a0,-1358 # 80008548 <syscalls+0x178>
    80002a9e:	00003097          	auipc	ra,0x3
    80002aa2:	254080e7          	jalr	596(ra) # 80005cf2 <printf>
  return 0;
    80002aa6:	4501                	li	a0,0
}
    80002aa8:	70e2                	ld	ra,56(sp)
    80002aaa:	7442                	ld	s0,48(sp)
    80002aac:	74a2                	ld	s1,40(sp)
    80002aae:	7902                	ld	s2,32(sp)
    80002ab0:	69e2                	ld	s3,24(sp)
    80002ab2:	6a42                	ld	s4,16(sp)
    80002ab4:	6aa2                	ld	s5,8(sp)
    80002ab6:	6b02                	ld	s6,0(sp)
    80002ab8:	6121                	addi	sp,sp,64
    80002aba:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002abc:	04000613          	li	a2,64
    80002ac0:	4581                	li	a1,0
    80002ac2:	854e                	mv	a0,s3
    80002ac4:	ffffd097          	auipc	ra,0xffffd
    80002ac8:	6b6080e7          	jalr	1718(ra) # 8000017a <memset>
      dip->type = type;
    80002acc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ad0:	8526                	mv	a0,s1
    80002ad2:	00001097          	auipc	ra,0x1
    80002ad6:	c66080e7          	jalr	-922(ra) # 80003738 <log_write>
      brelse(bp);
    80002ada:	8526                	mv	a0,s1
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	a04080e7          	jalr	-1532(ra) # 800024e0 <brelse>
      return iget(dev, inum);
    80002ae4:	0009059b          	sext.w	a1,s2
    80002ae8:	8556                	mv	a0,s5
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	da2080e7          	jalr	-606(ra) # 8000288c <iget>
    80002af2:	bf5d                	j	80002aa8 <ialloc+0x80>

0000000080002af4 <iupdate>:
{
    80002af4:	1101                	addi	sp,sp,-32
    80002af6:	ec06                	sd	ra,24(sp)
    80002af8:	e822                	sd	s0,16(sp)
    80002afa:	e426                	sd	s1,8(sp)
    80002afc:	e04a                	sd	s2,0(sp)
    80002afe:	1000                	addi	s0,sp,32
    80002b00:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b02:	415c                	lw	a5,4(a0)
    80002b04:	0047d79b          	srliw	a5,a5,0x4
    80002b08:	00014597          	auipc	a1,0x14
    80002b0c:	7485a583          	lw	a1,1864(a1) # 80017250 <sb+0x18>
    80002b10:	9dbd                	addw	a1,a1,a5
    80002b12:	4108                	lw	a0,0(a0)
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	89c080e7          	jalr	-1892(ra) # 800023b0 <bread>
    80002b1c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b1e:	05850793          	addi	a5,a0,88
    80002b22:	40d8                	lw	a4,4(s1)
    80002b24:	8b3d                	andi	a4,a4,15
    80002b26:	071a                	slli	a4,a4,0x6
    80002b28:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b2a:	04449703          	lh	a4,68(s1)
    80002b2e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b32:	04649703          	lh	a4,70(s1)
    80002b36:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b3a:	04849703          	lh	a4,72(s1)
    80002b3e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b42:	04a49703          	lh	a4,74(s1)
    80002b46:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b4a:	44f8                	lw	a4,76(s1)
    80002b4c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b4e:	03400613          	li	a2,52
    80002b52:	05048593          	addi	a1,s1,80
    80002b56:	00c78513          	addi	a0,a5,12
    80002b5a:	ffffd097          	auipc	ra,0xffffd
    80002b5e:	67c080e7          	jalr	1660(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b62:	854a                	mv	a0,s2
    80002b64:	00001097          	auipc	ra,0x1
    80002b68:	bd4080e7          	jalr	-1068(ra) # 80003738 <log_write>
  brelse(bp);
    80002b6c:	854a                	mv	a0,s2
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	972080e7          	jalr	-1678(ra) # 800024e0 <brelse>
}
    80002b76:	60e2                	ld	ra,24(sp)
    80002b78:	6442                	ld	s0,16(sp)
    80002b7a:	64a2                	ld	s1,8(sp)
    80002b7c:	6902                	ld	s2,0(sp)
    80002b7e:	6105                	addi	sp,sp,32
    80002b80:	8082                	ret

0000000080002b82 <idup>:
{
    80002b82:	1101                	addi	sp,sp,-32
    80002b84:	ec06                	sd	ra,24(sp)
    80002b86:	e822                	sd	s0,16(sp)
    80002b88:	e426                	sd	s1,8(sp)
    80002b8a:	1000                	addi	s0,sp,32
    80002b8c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b8e:	00014517          	auipc	a0,0x14
    80002b92:	6ca50513          	addi	a0,a0,1738 # 80017258 <itable>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	618080e7          	jalr	1560(ra) # 800061ae <acquire>
  ip->ref++;
    80002b9e:	449c                	lw	a5,8(s1)
    80002ba0:	2785                	addiw	a5,a5,1
    80002ba2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba4:	00014517          	auipc	a0,0x14
    80002ba8:	6b450513          	addi	a0,a0,1716 # 80017258 <itable>
    80002bac:	00003097          	auipc	ra,0x3
    80002bb0:	6b6080e7          	jalr	1718(ra) # 80006262 <release>
}
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	60e2                	ld	ra,24(sp)
    80002bb8:	6442                	ld	s0,16(sp)
    80002bba:	64a2                	ld	s1,8(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret

0000000080002bc0 <ilock>:
{
    80002bc0:	1101                	addi	sp,sp,-32
    80002bc2:	ec06                	sd	ra,24(sp)
    80002bc4:	e822                	sd	s0,16(sp)
    80002bc6:	e426                	sd	s1,8(sp)
    80002bc8:	e04a                	sd	s2,0(sp)
    80002bca:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bcc:	c115                	beqz	a0,80002bf0 <ilock+0x30>
    80002bce:	84aa                	mv	s1,a0
    80002bd0:	451c                	lw	a5,8(a0)
    80002bd2:	00f05f63          	blez	a5,80002bf0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bd6:	0541                	addi	a0,a0,16
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c7e080e7          	jalr	-898(ra) # 80003856 <acquiresleep>
  if(ip->valid == 0){
    80002be0:	40bc                	lw	a5,64(s1)
    80002be2:	cf99                	beqz	a5,80002c00 <ilock+0x40>
}
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6902                	ld	s2,0(sp)
    80002bec:	6105                	addi	sp,sp,32
    80002bee:	8082                	ret
    panic("ilock");
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	97050513          	addi	a0,a0,-1680 # 80008560 <syscalls+0x190>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	0a8080e7          	jalr	168(ra) # 80005ca0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c00:	40dc                	lw	a5,4(s1)
    80002c02:	0047d79b          	srliw	a5,a5,0x4
    80002c06:	00014597          	auipc	a1,0x14
    80002c0a:	64a5a583          	lw	a1,1610(a1) # 80017250 <sb+0x18>
    80002c0e:	9dbd                	addw	a1,a1,a5
    80002c10:	4088                	lw	a0,0(s1)
    80002c12:	fffff097          	auipc	ra,0xfffff
    80002c16:	79e080e7          	jalr	1950(ra) # 800023b0 <bread>
    80002c1a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1c:	05850593          	addi	a1,a0,88
    80002c20:	40dc                	lw	a5,4(s1)
    80002c22:	8bbd                	andi	a5,a5,15
    80002c24:	079a                	slli	a5,a5,0x6
    80002c26:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c28:	00059783          	lh	a5,0(a1)
    80002c2c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c30:	00259783          	lh	a5,2(a1)
    80002c34:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c38:	00459783          	lh	a5,4(a1)
    80002c3c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c40:	00659783          	lh	a5,6(a1)
    80002c44:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c48:	459c                	lw	a5,8(a1)
    80002c4a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4c:	03400613          	li	a2,52
    80002c50:	05b1                	addi	a1,a1,12
    80002c52:	05048513          	addi	a0,s1,80
    80002c56:	ffffd097          	auipc	ra,0xffffd
    80002c5a:	580080e7          	jalr	1408(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c5e:	854a                	mv	a0,s2
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	880080e7          	jalr	-1920(ra) # 800024e0 <brelse>
    ip->valid = 1;
    80002c68:	4785                	li	a5,1
    80002c6a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6c:	04449783          	lh	a5,68(s1)
    80002c70:	fbb5                	bnez	a5,80002be4 <ilock+0x24>
      panic("ilock: no type");
    80002c72:	00006517          	auipc	a0,0x6
    80002c76:	8f650513          	addi	a0,a0,-1802 # 80008568 <syscalls+0x198>
    80002c7a:	00003097          	auipc	ra,0x3
    80002c7e:	026080e7          	jalr	38(ra) # 80005ca0 <panic>

0000000080002c82 <iunlock>:
{
    80002c82:	1101                	addi	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	e426                	sd	s1,8(sp)
    80002c8a:	e04a                	sd	s2,0(sp)
    80002c8c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c8e:	c905                	beqz	a0,80002cbe <iunlock+0x3c>
    80002c90:	84aa                	mv	s1,a0
    80002c92:	01050913          	addi	s2,a0,16
    80002c96:	854a                	mv	a0,s2
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	c58080e7          	jalr	-936(ra) # 800038f0 <holdingsleep>
    80002ca0:	cd19                	beqz	a0,80002cbe <iunlock+0x3c>
    80002ca2:	449c                	lw	a5,8(s1)
    80002ca4:	00f05d63          	blez	a5,80002cbe <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00001097          	auipc	ra,0x1
    80002cae:	c02080e7          	jalr	-1022(ra) # 800038ac <releasesleep>
}
    80002cb2:	60e2                	ld	ra,24(sp)
    80002cb4:	6442                	ld	s0,16(sp)
    80002cb6:	64a2                	ld	s1,8(sp)
    80002cb8:	6902                	ld	s2,0(sp)
    80002cba:	6105                	addi	sp,sp,32
    80002cbc:	8082                	ret
    panic("iunlock");
    80002cbe:	00006517          	auipc	a0,0x6
    80002cc2:	8ba50513          	addi	a0,a0,-1862 # 80008578 <syscalls+0x1a8>
    80002cc6:	00003097          	auipc	ra,0x3
    80002cca:	fda080e7          	jalr	-38(ra) # 80005ca0 <panic>

0000000080002cce <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cce:	7179                	addi	sp,sp,-48
    80002cd0:	f406                	sd	ra,40(sp)
    80002cd2:	f022                	sd	s0,32(sp)
    80002cd4:	ec26                	sd	s1,24(sp)
    80002cd6:	e84a                	sd	s2,16(sp)
    80002cd8:	e44e                	sd	s3,8(sp)
    80002cda:	e052                	sd	s4,0(sp)
    80002cdc:	1800                	addi	s0,sp,48
    80002cde:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce0:	05050493          	addi	s1,a0,80
    80002ce4:	08050913          	addi	s2,a0,128
    80002ce8:	a021                	j	80002cf0 <itrunc+0x22>
    80002cea:	0491                	addi	s1,s1,4
    80002cec:	01248d63          	beq	s1,s2,80002d06 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cf0:	408c                	lw	a1,0(s1)
    80002cf2:	dde5                	beqz	a1,80002cea <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cf4:	0009a503          	lw	a0,0(s3)
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	8fc080e7          	jalr	-1796(ra) # 800025f4 <bfree>
      ip->addrs[i] = 0;
    80002d00:	0004a023          	sw	zero,0(s1)
    80002d04:	b7dd                	j	80002cea <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d06:	0809a583          	lw	a1,128(s3)
    80002d0a:	e185                	bnez	a1,80002d2a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d0c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d10:	854e                	mv	a0,s3
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	de2080e7          	jalr	-542(ra) # 80002af4 <iupdate>
}
    80002d1a:	70a2                	ld	ra,40(sp)
    80002d1c:	7402                	ld	s0,32(sp)
    80002d1e:	64e2                	ld	s1,24(sp)
    80002d20:	6942                	ld	s2,16(sp)
    80002d22:	69a2                	ld	s3,8(sp)
    80002d24:	6a02                	ld	s4,0(sp)
    80002d26:	6145                	addi	sp,sp,48
    80002d28:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d2a:	0009a503          	lw	a0,0(s3)
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	682080e7          	jalr	1666(ra) # 800023b0 <bread>
    80002d36:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d38:	05850493          	addi	s1,a0,88
    80002d3c:	45850913          	addi	s2,a0,1112
    80002d40:	a021                	j	80002d48 <itrunc+0x7a>
    80002d42:	0491                	addi	s1,s1,4
    80002d44:	01248b63          	beq	s1,s2,80002d5a <itrunc+0x8c>
      if(a[j])
    80002d48:	408c                	lw	a1,0(s1)
    80002d4a:	dde5                	beqz	a1,80002d42 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	8a4080e7          	jalr	-1884(ra) # 800025f4 <bfree>
    80002d58:	b7ed                	j	80002d42 <itrunc+0x74>
    brelse(bp);
    80002d5a:	8552                	mv	a0,s4
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	784080e7          	jalr	1924(ra) # 800024e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d64:	0809a583          	lw	a1,128(s3)
    80002d68:	0009a503          	lw	a0,0(s3)
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	888080e7          	jalr	-1912(ra) # 800025f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d74:	0809a023          	sw	zero,128(s3)
    80002d78:	bf51                	j	80002d0c <itrunc+0x3e>

0000000080002d7a <iput>:
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	e04a                	sd	s2,0(sp)
    80002d84:	1000                	addi	s0,sp,32
    80002d86:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d88:	00014517          	auipc	a0,0x14
    80002d8c:	4d050513          	addi	a0,a0,1232 # 80017258 <itable>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	41e080e7          	jalr	1054(ra) # 800061ae <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d98:	4498                	lw	a4,8(s1)
    80002d9a:	4785                	li	a5,1
    80002d9c:	02f70363          	beq	a4,a5,80002dc2 <iput+0x48>
  ip->ref--;
    80002da0:	449c                	lw	a5,8(s1)
    80002da2:	37fd                	addiw	a5,a5,-1
    80002da4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002da6:	00014517          	auipc	a0,0x14
    80002daa:	4b250513          	addi	a0,a0,1202 # 80017258 <itable>
    80002dae:	00003097          	auipc	ra,0x3
    80002db2:	4b4080e7          	jalr	1204(ra) # 80006262 <release>
}
    80002db6:	60e2                	ld	ra,24(sp)
    80002db8:	6442                	ld	s0,16(sp)
    80002dba:	64a2                	ld	s1,8(sp)
    80002dbc:	6902                	ld	s2,0(sp)
    80002dbe:	6105                	addi	sp,sp,32
    80002dc0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc2:	40bc                	lw	a5,64(s1)
    80002dc4:	dff1                	beqz	a5,80002da0 <iput+0x26>
    80002dc6:	04a49783          	lh	a5,74(s1)
    80002dca:	fbf9                	bnez	a5,80002da0 <iput+0x26>
    acquiresleep(&ip->lock);
    80002dcc:	01048913          	addi	s2,s1,16
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	00001097          	auipc	ra,0x1
    80002dd6:	a84080e7          	jalr	-1404(ra) # 80003856 <acquiresleep>
    release(&itable.lock);
    80002dda:	00014517          	auipc	a0,0x14
    80002dde:	47e50513          	addi	a0,a0,1150 # 80017258 <itable>
    80002de2:	00003097          	auipc	ra,0x3
    80002de6:	480080e7          	jalr	1152(ra) # 80006262 <release>
    itrunc(ip);
    80002dea:	8526                	mv	a0,s1
    80002dec:	00000097          	auipc	ra,0x0
    80002df0:	ee2080e7          	jalr	-286(ra) # 80002cce <itrunc>
    ip->type = 0;
    80002df4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002df8:	8526                	mv	a0,s1
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	cfa080e7          	jalr	-774(ra) # 80002af4 <iupdate>
    ip->valid = 0;
    80002e02:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e06:	854a                	mv	a0,s2
    80002e08:	00001097          	auipc	ra,0x1
    80002e0c:	aa4080e7          	jalr	-1372(ra) # 800038ac <releasesleep>
    acquire(&itable.lock);
    80002e10:	00014517          	auipc	a0,0x14
    80002e14:	44850513          	addi	a0,a0,1096 # 80017258 <itable>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	396080e7          	jalr	918(ra) # 800061ae <acquire>
    80002e20:	b741                	j	80002da0 <iput+0x26>

0000000080002e22 <iunlockput>:
{
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	1000                	addi	s0,sp,32
    80002e2c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	e54080e7          	jalr	-428(ra) # 80002c82 <iunlock>
  iput(ip);
    80002e36:	8526                	mv	a0,s1
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	f42080e7          	jalr	-190(ra) # 80002d7a <iput>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	64a2                	ld	s1,8(sp)
    80002e46:	6105                	addi	sp,sp,32
    80002e48:	8082                	ret

0000000080002e4a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e4a:	1141                	addi	sp,sp,-16
    80002e4c:	e422                	sd	s0,8(sp)
    80002e4e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e50:	411c                	lw	a5,0(a0)
    80002e52:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e54:	415c                	lw	a5,4(a0)
    80002e56:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e58:	04451783          	lh	a5,68(a0)
    80002e5c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e60:	04a51783          	lh	a5,74(a0)
    80002e64:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e68:	04c56783          	lwu	a5,76(a0)
    80002e6c:	e99c                	sd	a5,16(a1)
}
    80002e6e:	6422                	ld	s0,8(sp)
    80002e70:	0141                	addi	sp,sp,16
    80002e72:	8082                	ret

0000000080002e74 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e74:	457c                	lw	a5,76(a0)
    80002e76:	0ed7e963          	bltu	a5,a3,80002f68 <readi+0xf4>
{
    80002e7a:	7159                	addi	sp,sp,-112
    80002e7c:	f486                	sd	ra,104(sp)
    80002e7e:	f0a2                	sd	s0,96(sp)
    80002e80:	eca6                	sd	s1,88(sp)
    80002e82:	e8ca                	sd	s2,80(sp)
    80002e84:	e4ce                	sd	s3,72(sp)
    80002e86:	e0d2                	sd	s4,64(sp)
    80002e88:	fc56                	sd	s5,56(sp)
    80002e8a:	f85a                	sd	s6,48(sp)
    80002e8c:	f45e                	sd	s7,40(sp)
    80002e8e:	f062                	sd	s8,32(sp)
    80002e90:	ec66                	sd	s9,24(sp)
    80002e92:	e86a                	sd	s10,16(sp)
    80002e94:	e46e                	sd	s11,8(sp)
    80002e96:	1880                	addi	s0,sp,112
    80002e98:	8b2a                	mv	s6,a0
    80002e9a:	8bae                	mv	s7,a1
    80002e9c:	8a32                	mv	s4,a2
    80002e9e:	84b6                	mv	s1,a3
    80002ea0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ea2:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea6:	0ad76063          	bltu	a4,a3,80002f46 <readi+0xd2>
  if(off + n > ip->size)
    80002eaa:	00e7f463          	bgeu	a5,a4,80002eb2 <readi+0x3e>
    n = ip->size - off;
    80002eae:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb2:	0a0a8963          	beqz	s5,80002f64 <readi+0xf0>
    80002eb6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eb8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ebc:	5c7d                	li	s8,-1
    80002ebe:	a82d                	j	80002ef8 <readi+0x84>
    80002ec0:	020d1d93          	slli	s11,s10,0x20
    80002ec4:	020ddd93          	srli	s11,s11,0x20
    80002ec8:	05890613          	addi	a2,s2,88
    80002ecc:	86ee                	mv	a3,s11
    80002ece:	963a                	add	a2,a2,a4
    80002ed0:	85d2                	mv	a1,s4
    80002ed2:	855e                	mv	a0,s7
    80002ed4:	fffff097          	auipc	ra,0xfffff
    80002ed8:	a46080e7          	jalr	-1466(ra) # 8000191a <either_copyout>
    80002edc:	05850d63          	beq	a0,s8,80002f36 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ee0:	854a                	mv	a0,s2
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	5fe080e7          	jalr	1534(ra) # 800024e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eea:	013d09bb          	addw	s3,s10,s3
    80002eee:	009d04bb          	addw	s1,s10,s1
    80002ef2:	9a6e                	add	s4,s4,s11
    80002ef4:	0559f763          	bgeu	s3,s5,80002f42 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ef8:	00a4d59b          	srliw	a1,s1,0xa
    80002efc:	855a                	mv	a0,s6
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	8a4080e7          	jalr	-1884(ra) # 800027a2 <bmap>
    80002f06:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f0a:	cd85                	beqz	a1,80002f42 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f0c:	000b2503          	lw	a0,0(s6)
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	4a0080e7          	jalr	1184(ra) # 800023b0 <bread>
    80002f18:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1a:	3ff4f713          	andi	a4,s1,1023
    80002f1e:	40ec87bb          	subw	a5,s9,a4
    80002f22:	413a86bb          	subw	a3,s5,s3
    80002f26:	8d3e                	mv	s10,a5
    80002f28:	2781                	sext.w	a5,a5
    80002f2a:	0006861b          	sext.w	a2,a3
    80002f2e:	f8f679e3          	bgeu	a2,a5,80002ec0 <readi+0x4c>
    80002f32:	8d36                	mv	s10,a3
    80002f34:	b771                	j	80002ec0 <readi+0x4c>
      brelse(bp);
    80002f36:	854a                	mv	a0,s2
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	5a8080e7          	jalr	1448(ra) # 800024e0 <brelse>
      tot = -1;
    80002f40:	59fd                	li	s3,-1
  }
  return tot;
    80002f42:	0009851b          	sext.w	a0,s3
}
    80002f46:	70a6                	ld	ra,104(sp)
    80002f48:	7406                	ld	s0,96(sp)
    80002f4a:	64e6                	ld	s1,88(sp)
    80002f4c:	6946                	ld	s2,80(sp)
    80002f4e:	69a6                	ld	s3,72(sp)
    80002f50:	6a06                	ld	s4,64(sp)
    80002f52:	7ae2                	ld	s5,56(sp)
    80002f54:	7b42                	ld	s6,48(sp)
    80002f56:	7ba2                	ld	s7,40(sp)
    80002f58:	7c02                	ld	s8,32(sp)
    80002f5a:	6ce2                	ld	s9,24(sp)
    80002f5c:	6d42                	ld	s10,16(sp)
    80002f5e:	6da2                	ld	s11,8(sp)
    80002f60:	6165                	addi	sp,sp,112
    80002f62:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f64:	89d6                	mv	s3,s5
    80002f66:	bff1                	j	80002f42 <readi+0xce>
    return 0;
    80002f68:	4501                	li	a0,0
}
    80002f6a:	8082                	ret

0000000080002f6c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f6c:	457c                	lw	a5,76(a0)
    80002f6e:	10d7e863          	bltu	a5,a3,8000307e <writei+0x112>
{
    80002f72:	7159                	addi	sp,sp,-112
    80002f74:	f486                	sd	ra,104(sp)
    80002f76:	f0a2                	sd	s0,96(sp)
    80002f78:	eca6                	sd	s1,88(sp)
    80002f7a:	e8ca                	sd	s2,80(sp)
    80002f7c:	e4ce                	sd	s3,72(sp)
    80002f7e:	e0d2                	sd	s4,64(sp)
    80002f80:	fc56                	sd	s5,56(sp)
    80002f82:	f85a                	sd	s6,48(sp)
    80002f84:	f45e                	sd	s7,40(sp)
    80002f86:	f062                	sd	s8,32(sp)
    80002f88:	ec66                	sd	s9,24(sp)
    80002f8a:	e86a                	sd	s10,16(sp)
    80002f8c:	e46e                	sd	s11,8(sp)
    80002f8e:	1880                	addi	s0,sp,112
    80002f90:	8aaa                	mv	s5,a0
    80002f92:	8bae                	mv	s7,a1
    80002f94:	8a32                	mv	s4,a2
    80002f96:	8936                	mv	s2,a3
    80002f98:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f9a:	00e687bb          	addw	a5,a3,a4
    80002f9e:	0ed7e263          	bltu	a5,a3,80003082 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa2:	00043737          	lui	a4,0x43
    80002fa6:	0ef76063          	bltu	a4,a5,80003086 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002faa:	0c0b0863          	beqz	s6,8000307a <writei+0x10e>
    80002fae:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fb4:	5c7d                	li	s8,-1
    80002fb6:	a091                	j	80002ffa <writei+0x8e>
    80002fb8:	020d1d93          	slli	s11,s10,0x20
    80002fbc:	020ddd93          	srli	s11,s11,0x20
    80002fc0:	05848513          	addi	a0,s1,88
    80002fc4:	86ee                	mv	a3,s11
    80002fc6:	8652                	mv	a2,s4
    80002fc8:	85de                	mv	a1,s7
    80002fca:	953a                	add	a0,a0,a4
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	9a4080e7          	jalr	-1628(ra) # 80001970 <either_copyin>
    80002fd4:	07850263          	beq	a0,s8,80003038 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fd8:	8526                	mv	a0,s1
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	75e080e7          	jalr	1886(ra) # 80003738 <log_write>
    brelse(bp);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	4fc080e7          	jalr	1276(ra) # 800024e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fec:	013d09bb          	addw	s3,s10,s3
    80002ff0:	012d093b          	addw	s2,s10,s2
    80002ff4:	9a6e                	add	s4,s4,s11
    80002ff6:	0569f663          	bgeu	s3,s6,80003042 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002ffa:	00a9559b          	srliw	a1,s2,0xa
    80002ffe:	8556                	mv	a0,s5
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	7a2080e7          	jalr	1954(ra) # 800027a2 <bmap>
    80003008:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000300c:	c99d                	beqz	a1,80003042 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000300e:	000aa503          	lw	a0,0(s5)
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	39e080e7          	jalr	926(ra) # 800023b0 <bread>
    8000301a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000301c:	3ff97713          	andi	a4,s2,1023
    80003020:	40ec87bb          	subw	a5,s9,a4
    80003024:	413b06bb          	subw	a3,s6,s3
    80003028:	8d3e                	mv	s10,a5
    8000302a:	2781                	sext.w	a5,a5
    8000302c:	0006861b          	sext.w	a2,a3
    80003030:	f8f674e3          	bgeu	a2,a5,80002fb8 <writei+0x4c>
    80003034:	8d36                	mv	s10,a3
    80003036:	b749                	j	80002fb8 <writei+0x4c>
      brelse(bp);
    80003038:	8526                	mv	a0,s1
    8000303a:	fffff097          	auipc	ra,0xfffff
    8000303e:	4a6080e7          	jalr	1190(ra) # 800024e0 <brelse>
  }

  if(off > ip->size)
    80003042:	04caa783          	lw	a5,76(s5)
    80003046:	0127f463          	bgeu	a5,s2,8000304e <writei+0xe2>
    ip->size = off;
    8000304a:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000304e:	8556                	mv	a0,s5
    80003050:	00000097          	auipc	ra,0x0
    80003054:	aa4080e7          	jalr	-1372(ra) # 80002af4 <iupdate>

  return tot;
    80003058:	0009851b          	sext.w	a0,s3
}
    8000305c:	70a6                	ld	ra,104(sp)
    8000305e:	7406                	ld	s0,96(sp)
    80003060:	64e6                	ld	s1,88(sp)
    80003062:	6946                	ld	s2,80(sp)
    80003064:	69a6                	ld	s3,72(sp)
    80003066:	6a06                	ld	s4,64(sp)
    80003068:	7ae2                	ld	s5,56(sp)
    8000306a:	7b42                	ld	s6,48(sp)
    8000306c:	7ba2                	ld	s7,40(sp)
    8000306e:	7c02                	ld	s8,32(sp)
    80003070:	6ce2                	ld	s9,24(sp)
    80003072:	6d42                	ld	s10,16(sp)
    80003074:	6da2                	ld	s11,8(sp)
    80003076:	6165                	addi	sp,sp,112
    80003078:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000307a:	89da                	mv	s3,s6
    8000307c:	bfc9                	j	8000304e <writei+0xe2>
    return -1;
    8000307e:	557d                	li	a0,-1
}
    80003080:	8082                	ret
    return -1;
    80003082:	557d                	li	a0,-1
    80003084:	bfe1                	j	8000305c <writei+0xf0>
    return -1;
    80003086:	557d                	li	a0,-1
    80003088:	bfd1                	j	8000305c <writei+0xf0>

000000008000308a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000308a:	1141                	addi	sp,sp,-16
    8000308c:	e406                	sd	ra,8(sp)
    8000308e:	e022                	sd	s0,0(sp)
    80003090:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003092:	4639                	li	a2,14
    80003094:	ffffd097          	auipc	ra,0xffffd
    80003098:	1b6080e7          	jalr	438(ra) # 8000024a <strncmp>
}
    8000309c:	60a2                	ld	ra,8(sp)
    8000309e:	6402                	ld	s0,0(sp)
    800030a0:	0141                	addi	sp,sp,16
    800030a2:	8082                	ret

00000000800030a4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030a4:	7139                	addi	sp,sp,-64
    800030a6:	fc06                	sd	ra,56(sp)
    800030a8:	f822                	sd	s0,48(sp)
    800030aa:	f426                	sd	s1,40(sp)
    800030ac:	f04a                	sd	s2,32(sp)
    800030ae:	ec4e                	sd	s3,24(sp)
    800030b0:	e852                	sd	s4,16(sp)
    800030b2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030b4:	04451703          	lh	a4,68(a0)
    800030b8:	4785                	li	a5,1
    800030ba:	00f71a63          	bne	a4,a5,800030ce <dirlookup+0x2a>
    800030be:	892a                	mv	s2,a0
    800030c0:	89ae                	mv	s3,a1
    800030c2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c4:	457c                	lw	a5,76(a0)
    800030c6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030c8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ca:	e79d                	bnez	a5,800030f8 <dirlookup+0x54>
    800030cc:	a8a5                	j	80003144 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ce:	00005517          	auipc	a0,0x5
    800030d2:	4b250513          	addi	a0,a0,1202 # 80008580 <syscalls+0x1b0>
    800030d6:	00003097          	auipc	ra,0x3
    800030da:	bca080e7          	jalr	-1078(ra) # 80005ca0 <panic>
      panic("dirlookup read");
    800030de:	00005517          	auipc	a0,0x5
    800030e2:	4ba50513          	addi	a0,a0,1210 # 80008598 <syscalls+0x1c8>
    800030e6:	00003097          	auipc	ra,0x3
    800030ea:	bba080e7          	jalr	-1094(ra) # 80005ca0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	24c1                	addiw	s1,s1,16
    800030f0:	04c92783          	lw	a5,76(s2)
    800030f4:	04f4f763          	bgeu	s1,a5,80003142 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030f8:	4741                	li	a4,16
    800030fa:	86a6                	mv	a3,s1
    800030fc:	fc040613          	addi	a2,s0,-64
    80003100:	4581                	li	a1,0
    80003102:	854a                	mv	a0,s2
    80003104:	00000097          	auipc	ra,0x0
    80003108:	d70080e7          	jalr	-656(ra) # 80002e74 <readi>
    8000310c:	47c1                	li	a5,16
    8000310e:	fcf518e3          	bne	a0,a5,800030de <dirlookup+0x3a>
    if(de.inum == 0)
    80003112:	fc045783          	lhu	a5,-64(s0)
    80003116:	dfe1                	beqz	a5,800030ee <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003118:	fc240593          	addi	a1,s0,-62
    8000311c:	854e                	mv	a0,s3
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	f6c080e7          	jalr	-148(ra) # 8000308a <namecmp>
    80003126:	f561                	bnez	a0,800030ee <dirlookup+0x4a>
      if(poff)
    80003128:	000a0463          	beqz	s4,80003130 <dirlookup+0x8c>
        *poff = off;
    8000312c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003130:	fc045583          	lhu	a1,-64(s0)
    80003134:	00092503          	lw	a0,0(s2)
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	754080e7          	jalr	1876(ra) # 8000288c <iget>
    80003140:	a011                	j	80003144 <dirlookup+0xa0>
  return 0;
    80003142:	4501                	li	a0,0
}
    80003144:	70e2                	ld	ra,56(sp)
    80003146:	7442                	ld	s0,48(sp)
    80003148:	74a2                	ld	s1,40(sp)
    8000314a:	7902                	ld	s2,32(sp)
    8000314c:	69e2                	ld	s3,24(sp)
    8000314e:	6a42                	ld	s4,16(sp)
    80003150:	6121                	addi	sp,sp,64
    80003152:	8082                	ret

0000000080003154 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003154:	711d                	addi	sp,sp,-96
    80003156:	ec86                	sd	ra,88(sp)
    80003158:	e8a2                	sd	s0,80(sp)
    8000315a:	e4a6                	sd	s1,72(sp)
    8000315c:	e0ca                	sd	s2,64(sp)
    8000315e:	fc4e                	sd	s3,56(sp)
    80003160:	f852                	sd	s4,48(sp)
    80003162:	f456                	sd	s5,40(sp)
    80003164:	f05a                	sd	s6,32(sp)
    80003166:	ec5e                	sd	s7,24(sp)
    80003168:	e862                	sd	s8,16(sp)
    8000316a:	e466                	sd	s9,8(sp)
    8000316c:	1080                	addi	s0,sp,96
    8000316e:	84aa                	mv	s1,a0
    80003170:	8b2e                	mv	s6,a1
    80003172:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003174:	00054703          	lbu	a4,0(a0)
    80003178:	02f00793          	li	a5,47
    8000317c:	02f70263          	beq	a4,a5,800031a0 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003180:	ffffe097          	auipc	ra,0xffffe
    80003184:	cd2080e7          	jalr	-814(ra) # 80000e52 <myproc>
    80003188:	15053503          	ld	a0,336(a0)
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	9f6080e7          	jalr	-1546(ra) # 80002b82 <idup>
    80003194:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003196:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000319a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000319c:	4b85                	li	s7,1
    8000319e:	a875                	j	8000325a <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031a0:	4585                	li	a1,1
    800031a2:	4505                	li	a0,1
    800031a4:	fffff097          	auipc	ra,0xfffff
    800031a8:	6e8080e7          	jalr	1768(ra) # 8000288c <iget>
    800031ac:	8a2a                	mv	s4,a0
    800031ae:	b7e5                	j	80003196 <namex+0x42>
      iunlockput(ip);
    800031b0:	8552                	mv	a0,s4
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	c70080e7          	jalr	-912(ra) # 80002e22 <iunlockput>
      return 0;
    800031ba:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031bc:	8552                	mv	a0,s4
    800031be:	60e6                	ld	ra,88(sp)
    800031c0:	6446                	ld	s0,80(sp)
    800031c2:	64a6                	ld	s1,72(sp)
    800031c4:	6906                	ld	s2,64(sp)
    800031c6:	79e2                	ld	s3,56(sp)
    800031c8:	7a42                	ld	s4,48(sp)
    800031ca:	7aa2                	ld	s5,40(sp)
    800031cc:	7b02                	ld	s6,32(sp)
    800031ce:	6be2                	ld	s7,24(sp)
    800031d0:	6c42                	ld	s8,16(sp)
    800031d2:	6ca2                	ld	s9,8(sp)
    800031d4:	6125                	addi	sp,sp,96
    800031d6:	8082                	ret
      iunlock(ip);
    800031d8:	8552                	mv	a0,s4
    800031da:	00000097          	auipc	ra,0x0
    800031de:	aa8080e7          	jalr	-1368(ra) # 80002c82 <iunlock>
      return ip;
    800031e2:	bfe9                	j	800031bc <namex+0x68>
      iunlockput(ip);
    800031e4:	8552                	mv	a0,s4
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	c3c080e7          	jalr	-964(ra) # 80002e22 <iunlockput>
      return 0;
    800031ee:	8a4e                	mv	s4,s3
    800031f0:	b7f1                	j	800031bc <namex+0x68>
  len = path - s;
    800031f2:	40998633          	sub	a2,s3,s1
    800031f6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800031fa:	099c5863          	bge	s8,s9,8000328a <namex+0x136>
    memmove(name, s, DIRSIZ);
    800031fe:	4639                	li	a2,14
    80003200:	85a6                	mv	a1,s1
    80003202:	8556                	mv	a0,s5
    80003204:	ffffd097          	auipc	ra,0xffffd
    80003208:	fd2080e7          	jalr	-46(ra) # 800001d6 <memmove>
    8000320c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000320e:	0004c783          	lbu	a5,0(s1)
    80003212:	01279763          	bne	a5,s2,80003220 <namex+0xcc>
    path++;
    80003216:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	ff278de3          	beq	a5,s2,80003216 <namex+0xc2>
    ilock(ip);
    80003220:	8552                	mv	a0,s4
    80003222:	00000097          	auipc	ra,0x0
    80003226:	99e080e7          	jalr	-1634(ra) # 80002bc0 <ilock>
    if(ip->type != T_DIR){
    8000322a:	044a1783          	lh	a5,68(s4)
    8000322e:	f97791e3          	bne	a5,s7,800031b0 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003232:	000b0563          	beqz	s6,8000323c <namex+0xe8>
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	dfd9                	beqz	a5,800031d8 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000323c:	4601                	li	a2,0
    8000323e:	85d6                	mv	a1,s5
    80003240:	8552                	mv	a0,s4
    80003242:	00000097          	auipc	ra,0x0
    80003246:	e62080e7          	jalr	-414(ra) # 800030a4 <dirlookup>
    8000324a:	89aa                	mv	s3,a0
    8000324c:	dd41                	beqz	a0,800031e4 <namex+0x90>
    iunlockput(ip);
    8000324e:	8552                	mv	a0,s4
    80003250:	00000097          	auipc	ra,0x0
    80003254:	bd2080e7          	jalr	-1070(ra) # 80002e22 <iunlockput>
    ip = next;
    80003258:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	01279763          	bne	a5,s2,8000326c <namex+0x118>
    path++;
    80003262:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003264:	0004c783          	lbu	a5,0(s1)
    80003268:	ff278de3          	beq	a5,s2,80003262 <namex+0x10e>
  if(*path == 0)
    8000326c:	cb9d                	beqz	a5,800032a2 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000326e:	0004c783          	lbu	a5,0(s1)
    80003272:	89a6                	mv	s3,s1
  len = path - s;
    80003274:	4c81                	li	s9,0
    80003276:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003278:	01278963          	beq	a5,s2,8000328a <namex+0x136>
    8000327c:	dbbd                	beqz	a5,800031f2 <namex+0x9e>
    path++;
    8000327e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003280:	0009c783          	lbu	a5,0(s3)
    80003284:	ff279ce3          	bne	a5,s2,8000327c <namex+0x128>
    80003288:	b7ad                	j	800031f2 <namex+0x9e>
    memmove(name, s, len);
    8000328a:	2601                	sext.w	a2,a2
    8000328c:	85a6                	mv	a1,s1
    8000328e:	8556                	mv	a0,s5
    80003290:	ffffd097          	auipc	ra,0xffffd
    80003294:	f46080e7          	jalr	-186(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003298:	9cd6                	add	s9,s9,s5
    8000329a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000329e:	84ce                	mv	s1,s3
    800032a0:	b7bd                	j	8000320e <namex+0xba>
  if(nameiparent){
    800032a2:	f00b0de3          	beqz	s6,800031bc <namex+0x68>
    iput(ip);
    800032a6:	8552                	mv	a0,s4
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	ad2080e7          	jalr	-1326(ra) # 80002d7a <iput>
    return 0;
    800032b0:	4a01                	li	s4,0
    800032b2:	b729                	j	800031bc <namex+0x68>

00000000800032b4 <dirlink>:
{
    800032b4:	7139                	addi	sp,sp,-64
    800032b6:	fc06                	sd	ra,56(sp)
    800032b8:	f822                	sd	s0,48(sp)
    800032ba:	f426                	sd	s1,40(sp)
    800032bc:	f04a                	sd	s2,32(sp)
    800032be:	ec4e                	sd	s3,24(sp)
    800032c0:	e852                	sd	s4,16(sp)
    800032c2:	0080                	addi	s0,sp,64
    800032c4:	892a                	mv	s2,a0
    800032c6:	8a2e                	mv	s4,a1
    800032c8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ca:	4601                	li	a2,0
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	dd8080e7          	jalr	-552(ra) # 800030a4 <dirlookup>
    800032d4:	e93d                	bnez	a0,8000334a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d6:	04c92483          	lw	s1,76(s2)
    800032da:	c49d                	beqz	s1,80003308 <dirlink+0x54>
    800032dc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032de:	4741                	li	a4,16
    800032e0:	86a6                	mv	a3,s1
    800032e2:	fc040613          	addi	a2,s0,-64
    800032e6:	4581                	li	a1,0
    800032e8:	854a                	mv	a0,s2
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	b8a080e7          	jalr	-1142(ra) # 80002e74 <readi>
    800032f2:	47c1                	li	a5,16
    800032f4:	06f51163          	bne	a0,a5,80003356 <dirlink+0xa2>
    if(de.inum == 0)
    800032f8:	fc045783          	lhu	a5,-64(s0)
    800032fc:	c791                	beqz	a5,80003308 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fe:	24c1                	addiw	s1,s1,16
    80003300:	04c92783          	lw	a5,76(s2)
    80003304:	fcf4ede3          	bltu	s1,a5,800032de <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003308:	4639                	li	a2,14
    8000330a:	85d2                	mv	a1,s4
    8000330c:	fc240513          	addi	a0,s0,-62
    80003310:	ffffd097          	auipc	ra,0xffffd
    80003314:	f76080e7          	jalr	-138(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003318:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331c:	4741                	li	a4,16
    8000331e:	86a6                	mv	a3,s1
    80003320:	fc040613          	addi	a2,s0,-64
    80003324:	4581                	li	a1,0
    80003326:	854a                	mv	a0,s2
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	c44080e7          	jalr	-956(ra) # 80002f6c <writei>
    80003330:	1541                	addi	a0,a0,-16
    80003332:	00a03533          	snez	a0,a0
    80003336:	40a00533          	neg	a0,a0
}
    8000333a:	70e2                	ld	ra,56(sp)
    8000333c:	7442                	ld	s0,48(sp)
    8000333e:	74a2                	ld	s1,40(sp)
    80003340:	7902                	ld	s2,32(sp)
    80003342:	69e2                	ld	s3,24(sp)
    80003344:	6a42                	ld	s4,16(sp)
    80003346:	6121                	addi	sp,sp,64
    80003348:	8082                	ret
    iput(ip);
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	a30080e7          	jalr	-1488(ra) # 80002d7a <iput>
    return -1;
    80003352:	557d                	li	a0,-1
    80003354:	b7dd                	j	8000333a <dirlink+0x86>
      panic("dirlink read");
    80003356:	00005517          	auipc	a0,0x5
    8000335a:	25250513          	addi	a0,a0,594 # 800085a8 <syscalls+0x1d8>
    8000335e:	00003097          	auipc	ra,0x3
    80003362:	942080e7          	jalr	-1726(ra) # 80005ca0 <panic>

0000000080003366 <namei>:

struct inode*
namei(char *path)
{
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000336e:	fe040613          	addi	a2,s0,-32
    80003372:	4581                	li	a1,0
    80003374:	00000097          	auipc	ra,0x0
    80003378:	de0080e7          	jalr	-544(ra) # 80003154 <namex>
}
    8000337c:	60e2                	ld	ra,24(sp)
    8000337e:	6442                	ld	s0,16(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003384:	1141                	addi	sp,sp,-16
    80003386:	e406                	sd	ra,8(sp)
    80003388:	e022                	sd	s0,0(sp)
    8000338a:	0800                	addi	s0,sp,16
    8000338c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000338e:	4585                	li	a1,1
    80003390:	00000097          	auipc	ra,0x0
    80003394:	dc4080e7          	jalr	-572(ra) # 80003154 <namex>
}
    80003398:	60a2                	ld	ra,8(sp)
    8000339a:	6402                	ld	s0,0(sp)
    8000339c:	0141                	addi	sp,sp,16
    8000339e:	8082                	ret

00000000800033a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033a0:	1101                	addi	sp,sp,-32
    800033a2:	ec06                	sd	ra,24(sp)
    800033a4:	e822                	sd	s0,16(sp)
    800033a6:	e426                	sd	s1,8(sp)
    800033a8:	e04a                	sd	s2,0(sp)
    800033aa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033ac:	00016917          	auipc	s2,0x16
    800033b0:	95490913          	addi	s2,s2,-1708 # 80018d00 <log>
    800033b4:	01892583          	lw	a1,24(s2)
    800033b8:	02892503          	lw	a0,40(s2)
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	ff4080e7          	jalr	-12(ra) # 800023b0 <bread>
    800033c4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033c6:	02c92603          	lw	a2,44(s2)
    800033ca:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033cc:	00c05f63          	blez	a2,800033ea <write_head+0x4a>
    800033d0:	00016717          	auipc	a4,0x16
    800033d4:	96070713          	addi	a4,a4,-1696 # 80018d30 <log+0x30>
    800033d8:	87aa                	mv	a5,a0
    800033da:	060a                	slli	a2,a2,0x2
    800033dc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800033de:	4314                	lw	a3,0(a4)
    800033e0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800033e2:	0711                	addi	a4,a4,4
    800033e4:	0791                	addi	a5,a5,4
    800033e6:	fec79ce3          	bne	a5,a2,800033de <write_head+0x3e>
  }
  bwrite(buf);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	0b6080e7          	jalr	182(ra) # 800024a2 <bwrite>
  brelse(buf);
    800033f4:	8526                	mv	a0,s1
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	0ea080e7          	jalr	234(ra) # 800024e0 <brelse>
}
    800033fe:	60e2                	ld	ra,24(sp)
    80003400:	6442                	ld	s0,16(sp)
    80003402:	64a2                	ld	s1,8(sp)
    80003404:	6902                	ld	s2,0(sp)
    80003406:	6105                	addi	sp,sp,32
    80003408:	8082                	ret

000000008000340a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340a:	00016797          	auipc	a5,0x16
    8000340e:	9227a783          	lw	a5,-1758(a5) # 80018d2c <log+0x2c>
    80003412:	0af05d63          	blez	a5,800034cc <install_trans+0xc2>
{
    80003416:	7139                	addi	sp,sp,-64
    80003418:	fc06                	sd	ra,56(sp)
    8000341a:	f822                	sd	s0,48(sp)
    8000341c:	f426                	sd	s1,40(sp)
    8000341e:	f04a                	sd	s2,32(sp)
    80003420:	ec4e                	sd	s3,24(sp)
    80003422:	e852                	sd	s4,16(sp)
    80003424:	e456                	sd	s5,8(sp)
    80003426:	e05a                	sd	s6,0(sp)
    80003428:	0080                	addi	s0,sp,64
    8000342a:	8b2a                	mv	s6,a0
    8000342c:	00016a97          	auipc	s5,0x16
    80003430:	904a8a93          	addi	s5,s5,-1788 # 80018d30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003436:	00016997          	auipc	s3,0x16
    8000343a:	8ca98993          	addi	s3,s3,-1846 # 80018d00 <log>
    8000343e:	a00d                	j	80003460 <install_trans+0x56>
    brelse(lbuf);
    80003440:	854a                	mv	a0,s2
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	09e080e7          	jalr	158(ra) # 800024e0 <brelse>
    brelse(dbuf);
    8000344a:	8526                	mv	a0,s1
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	094080e7          	jalr	148(ra) # 800024e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003454:	2a05                	addiw	s4,s4,1
    80003456:	0a91                	addi	s5,s5,4
    80003458:	02c9a783          	lw	a5,44(s3)
    8000345c:	04fa5e63          	bge	s4,a5,800034b8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	0189a583          	lw	a1,24(s3)
    80003464:	014585bb          	addw	a1,a1,s4
    80003468:	2585                	addiw	a1,a1,1
    8000346a:	0289a503          	lw	a0,40(s3)
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	f42080e7          	jalr	-190(ra) # 800023b0 <bread>
    80003476:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003478:	000aa583          	lw	a1,0(s5)
    8000347c:	0289a503          	lw	a0,40(s3)
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	f30080e7          	jalr	-208(ra) # 800023b0 <bread>
    80003488:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000348a:	40000613          	li	a2,1024
    8000348e:	05890593          	addi	a1,s2,88
    80003492:	05850513          	addi	a0,a0,88
    80003496:	ffffd097          	auipc	ra,0xffffd
    8000349a:	d40080e7          	jalr	-704(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000349e:	8526                	mv	a0,s1
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	002080e7          	jalr	2(ra) # 800024a2 <bwrite>
    if(recovering == 0)
    800034a8:	f80b1ce3          	bnez	s6,80003440 <install_trans+0x36>
      bunpin(dbuf);
    800034ac:	8526                	mv	a0,s1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	10a080e7          	jalr	266(ra) # 800025b8 <bunpin>
    800034b6:	b769                	j	80003440 <install_trans+0x36>
}
    800034b8:	70e2                	ld	ra,56(sp)
    800034ba:	7442                	ld	s0,48(sp)
    800034bc:	74a2                	ld	s1,40(sp)
    800034be:	7902                	ld	s2,32(sp)
    800034c0:	69e2                	ld	s3,24(sp)
    800034c2:	6a42                	ld	s4,16(sp)
    800034c4:	6aa2                	ld	s5,8(sp)
    800034c6:	6b02                	ld	s6,0(sp)
    800034c8:	6121                	addi	sp,sp,64
    800034ca:	8082                	ret
    800034cc:	8082                	ret

00000000800034ce <initlog>:
{
    800034ce:	7179                	addi	sp,sp,-48
    800034d0:	f406                	sd	ra,40(sp)
    800034d2:	f022                	sd	s0,32(sp)
    800034d4:	ec26                	sd	s1,24(sp)
    800034d6:	e84a                	sd	s2,16(sp)
    800034d8:	e44e                	sd	s3,8(sp)
    800034da:	1800                	addi	s0,sp,48
    800034dc:	892a                	mv	s2,a0
    800034de:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e0:	00016497          	auipc	s1,0x16
    800034e4:	82048493          	addi	s1,s1,-2016 # 80018d00 <log>
    800034e8:	00005597          	auipc	a1,0x5
    800034ec:	0d058593          	addi	a1,a1,208 # 800085b8 <syscalls+0x1e8>
    800034f0:	8526                	mv	a0,s1
    800034f2:	00003097          	auipc	ra,0x3
    800034f6:	c2c080e7          	jalr	-980(ra) # 8000611e <initlock>
  log.start = sb->logstart;
    800034fa:	0149a583          	lw	a1,20(s3)
    800034fe:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003500:	0109a783          	lw	a5,16(s3)
    80003504:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003506:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000350a:	854a                	mv	a0,s2
    8000350c:	fffff097          	auipc	ra,0xfffff
    80003510:	ea4080e7          	jalr	-348(ra) # 800023b0 <bread>
  log.lh.n = lh->n;
    80003514:	4d30                	lw	a2,88(a0)
    80003516:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003518:	00c05f63          	blez	a2,80003536 <initlog+0x68>
    8000351c:	87aa                	mv	a5,a0
    8000351e:	00016717          	auipc	a4,0x16
    80003522:	81270713          	addi	a4,a4,-2030 # 80018d30 <log+0x30>
    80003526:	060a                	slli	a2,a2,0x2
    80003528:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000352a:	4ff4                	lw	a3,92(a5)
    8000352c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000352e:	0791                	addi	a5,a5,4
    80003530:	0711                	addi	a4,a4,4
    80003532:	fec79ce3          	bne	a5,a2,8000352a <initlog+0x5c>
  brelse(buf);
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	faa080e7          	jalr	-86(ra) # 800024e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000353e:	4505                	li	a0,1
    80003540:	00000097          	auipc	ra,0x0
    80003544:	eca080e7          	jalr	-310(ra) # 8000340a <install_trans>
  log.lh.n = 0;
    80003548:	00015797          	auipc	a5,0x15
    8000354c:	7e07a223          	sw	zero,2020(a5) # 80018d2c <log+0x2c>
  write_head(); // clear the log
    80003550:	00000097          	auipc	ra,0x0
    80003554:	e50080e7          	jalr	-432(ra) # 800033a0 <write_head>
}
    80003558:	70a2                	ld	ra,40(sp)
    8000355a:	7402                	ld	s0,32(sp)
    8000355c:	64e2                	ld	s1,24(sp)
    8000355e:	6942                	ld	s2,16(sp)
    80003560:	69a2                	ld	s3,8(sp)
    80003562:	6145                	addi	sp,sp,48
    80003564:	8082                	ret

0000000080003566 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003566:	1101                	addi	sp,sp,-32
    80003568:	ec06                	sd	ra,24(sp)
    8000356a:	e822                	sd	s0,16(sp)
    8000356c:	e426                	sd	s1,8(sp)
    8000356e:	e04a                	sd	s2,0(sp)
    80003570:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003572:	00015517          	auipc	a0,0x15
    80003576:	78e50513          	addi	a0,a0,1934 # 80018d00 <log>
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	c34080e7          	jalr	-972(ra) # 800061ae <acquire>
  while(1){
    if(log.committing){
    80003582:	00015497          	auipc	s1,0x15
    80003586:	77e48493          	addi	s1,s1,1918 # 80018d00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000358a:	4979                	li	s2,30
    8000358c:	a039                	j	8000359a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000358e:	85a6                	mv	a1,s1
    80003590:	8526                	mv	a0,s1
    80003592:	ffffe097          	auipc	ra,0xffffe
    80003596:	f80080e7          	jalr	-128(ra) # 80001512 <sleep>
    if(log.committing){
    8000359a:	50dc                	lw	a5,36(s1)
    8000359c:	fbed                	bnez	a5,8000358e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359e:	5098                	lw	a4,32(s1)
    800035a0:	2705                	addiw	a4,a4,1
    800035a2:	0027179b          	slliw	a5,a4,0x2
    800035a6:	9fb9                	addw	a5,a5,a4
    800035a8:	0017979b          	slliw	a5,a5,0x1
    800035ac:	54d4                	lw	a3,44(s1)
    800035ae:	9fb5                	addw	a5,a5,a3
    800035b0:	00f95963          	bge	s2,a5,800035c2 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035b4:	85a6                	mv	a1,s1
    800035b6:	8526                	mv	a0,s1
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	f5a080e7          	jalr	-166(ra) # 80001512 <sleep>
    800035c0:	bfe9                	j	8000359a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035c2:	00015517          	auipc	a0,0x15
    800035c6:	73e50513          	addi	a0,a0,1854 # 80018d00 <log>
    800035ca:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	c96080e7          	jalr	-874(ra) # 80006262 <release>
      break;
    }
  }
}
    800035d4:	60e2                	ld	ra,24(sp)
    800035d6:	6442                	ld	s0,16(sp)
    800035d8:	64a2                	ld	s1,8(sp)
    800035da:	6902                	ld	s2,0(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret

00000000800035e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e0:	7139                	addi	sp,sp,-64
    800035e2:	fc06                	sd	ra,56(sp)
    800035e4:	f822                	sd	s0,48(sp)
    800035e6:	f426                	sd	s1,40(sp)
    800035e8:	f04a                	sd	s2,32(sp)
    800035ea:	ec4e                	sd	s3,24(sp)
    800035ec:	e852                	sd	s4,16(sp)
    800035ee:	e456                	sd	s5,8(sp)
    800035f0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035f2:	00015497          	auipc	s1,0x15
    800035f6:	70e48493          	addi	s1,s1,1806 # 80018d00 <log>
    800035fa:	8526                	mv	a0,s1
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	bb2080e7          	jalr	-1102(ra) # 800061ae <acquire>
  log.outstanding -= 1;
    80003604:	509c                	lw	a5,32(s1)
    80003606:	37fd                	addiw	a5,a5,-1
    80003608:	0007891b          	sext.w	s2,a5
    8000360c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000360e:	50dc                	lw	a5,36(s1)
    80003610:	e7b9                	bnez	a5,8000365e <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003612:	04091e63          	bnez	s2,8000366e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003616:	00015497          	auipc	s1,0x15
    8000361a:	6ea48493          	addi	s1,s1,1770 # 80018d00 <log>
    8000361e:	4785                	li	a5,1
    80003620:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003622:	8526                	mv	a0,s1
    80003624:	00003097          	auipc	ra,0x3
    80003628:	c3e080e7          	jalr	-962(ra) # 80006262 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000362c:	54dc                	lw	a5,44(s1)
    8000362e:	06f04763          	bgtz	a5,8000369c <end_op+0xbc>
    acquire(&log.lock);
    80003632:	00015497          	auipc	s1,0x15
    80003636:	6ce48493          	addi	s1,s1,1742 # 80018d00 <log>
    8000363a:	8526                	mv	a0,s1
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	b72080e7          	jalr	-1166(ra) # 800061ae <acquire>
    log.committing = 0;
    80003644:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003648:	8526                	mv	a0,s1
    8000364a:	ffffe097          	auipc	ra,0xffffe
    8000364e:	f2c080e7          	jalr	-212(ra) # 80001576 <wakeup>
    release(&log.lock);
    80003652:	8526                	mv	a0,s1
    80003654:	00003097          	auipc	ra,0x3
    80003658:	c0e080e7          	jalr	-1010(ra) # 80006262 <release>
}
    8000365c:	a03d                	j	8000368a <end_op+0xaa>
    panic("log.committing");
    8000365e:	00005517          	auipc	a0,0x5
    80003662:	f6250513          	addi	a0,a0,-158 # 800085c0 <syscalls+0x1f0>
    80003666:	00002097          	auipc	ra,0x2
    8000366a:	63a080e7          	jalr	1594(ra) # 80005ca0 <panic>
    wakeup(&log);
    8000366e:	00015497          	auipc	s1,0x15
    80003672:	69248493          	addi	s1,s1,1682 # 80018d00 <log>
    80003676:	8526                	mv	a0,s1
    80003678:	ffffe097          	auipc	ra,0xffffe
    8000367c:	efe080e7          	jalr	-258(ra) # 80001576 <wakeup>
  release(&log.lock);
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	be0080e7          	jalr	-1056(ra) # 80006262 <release>
}
    8000368a:	70e2                	ld	ra,56(sp)
    8000368c:	7442                	ld	s0,48(sp)
    8000368e:	74a2                	ld	s1,40(sp)
    80003690:	7902                	ld	s2,32(sp)
    80003692:	69e2                	ld	s3,24(sp)
    80003694:	6a42                	ld	s4,16(sp)
    80003696:	6aa2                	ld	s5,8(sp)
    80003698:	6121                	addi	sp,sp,64
    8000369a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369c:	00015a97          	auipc	s5,0x15
    800036a0:	694a8a93          	addi	s5,s5,1684 # 80018d30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036a4:	00015a17          	auipc	s4,0x15
    800036a8:	65ca0a13          	addi	s4,s4,1628 # 80018d00 <log>
    800036ac:	018a2583          	lw	a1,24(s4)
    800036b0:	012585bb          	addw	a1,a1,s2
    800036b4:	2585                	addiw	a1,a1,1
    800036b6:	028a2503          	lw	a0,40(s4)
    800036ba:	fffff097          	auipc	ra,0xfffff
    800036be:	cf6080e7          	jalr	-778(ra) # 800023b0 <bread>
    800036c2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036c4:	000aa583          	lw	a1,0(s5)
    800036c8:	028a2503          	lw	a0,40(s4)
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	ce4080e7          	jalr	-796(ra) # 800023b0 <bread>
    800036d4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036d6:	40000613          	li	a2,1024
    800036da:	05850593          	addi	a1,a0,88
    800036de:	05848513          	addi	a0,s1,88
    800036e2:	ffffd097          	auipc	ra,0xffffd
    800036e6:	af4080e7          	jalr	-1292(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800036ea:	8526                	mv	a0,s1
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	db6080e7          	jalr	-586(ra) # 800024a2 <bwrite>
    brelse(from);
    800036f4:	854e                	mv	a0,s3
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	dea080e7          	jalr	-534(ra) # 800024e0 <brelse>
    brelse(to);
    800036fe:	8526                	mv	a0,s1
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	de0080e7          	jalr	-544(ra) # 800024e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003708:	2905                	addiw	s2,s2,1
    8000370a:	0a91                	addi	s5,s5,4
    8000370c:	02ca2783          	lw	a5,44(s4)
    80003710:	f8f94ee3          	blt	s2,a5,800036ac <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003714:	00000097          	auipc	ra,0x0
    80003718:	c8c080e7          	jalr	-884(ra) # 800033a0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000371c:	4501                	li	a0,0
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	cec080e7          	jalr	-788(ra) # 8000340a <install_trans>
    log.lh.n = 0;
    80003726:	00015797          	auipc	a5,0x15
    8000372a:	6007a323          	sw	zero,1542(a5) # 80018d2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	c72080e7          	jalr	-910(ra) # 800033a0 <write_head>
    80003736:	bdf5                	j	80003632 <end_op+0x52>

0000000080003738 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003738:	1101                	addi	sp,sp,-32
    8000373a:	ec06                	sd	ra,24(sp)
    8000373c:	e822                	sd	s0,16(sp)
    8000373e:	e426                	sd	s1,8(sp)
    80003740:	e04a                	sd	s2,0(sp)
    80003742:	1000                	addi	s0,sp,32
    80003744:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003746:	00015917          	auipc	s2,0x15
    8000374a:	5ba90913          	addi	s2,s2,1466 # 80018d00 <log>
    8000374e:	854a                	mv	a0,s2
    80003750:	00003097          	auipc	ra,0x3
    80003754:	a5e080e7          	jalr	-1442(ra) # 800061ae <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003758:	02c92603          	lw	a2,44(s2)
    8000375c:	47f5                	li	a5,29
    8000375e:	06c7c563          	blt	a5,a2,800037c8 <log_write+0x90>
    80003762:	00015797          	auipc	a5,0x15
    80003766:	5ba7a783          	lw	a5,1466(a5) # 80018d1c <log+0x1c>
    8000376a:	37fd                	addiw	a5,a5,-1
    8000376c:	04f65e63          	bge	a2,a5,800037c8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003770:	00015797          	auipc	a5,0x15
    80003774:	5b07a783          	lw	a5,1456(a5) # 80018d20 <log+0x20>
    80003778:	06f05063          	blez	a5,800037d8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000377c:	4781                	li	a5,0
    8000377e:	06c05563          	blez	a2,800037e8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003782:	44cc                	lw	a1,12(s1)
    80003784:	00015717          	auipc	a4,0x15
    80003788:	5ac70713          	addi	a4,a4,1452 # 80018d30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000378c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378e:	4314                	lw	a3,0(a4)
    80003790:	04b68c63          	beq	a3,a1,800037e8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003794:	2785                	addiw	a5,a5,1
    80003796:	0711                	addi	a4,a4,4
    80003798:	fef61be3          	bne	a2,a5,8000378e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000379c:	0621                	addi	a2,a2,8
    8000379e:	060a                	slli	a2,a2,0x2
    800037a0:	00015797          	auipc	a5,0x15
    800037a4:	56078793          	addi	a5,a5,1376 # 80018d00 <log>
    800037a8:	97b2                	add	a5,a5,a2
    800037aa:	44d8                	lw	a4,12(s1)
    800037ac:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ae:	8526                	mv	a0,s1
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	dcc080e7          	jalr	-564(ra) # 8000257c <bpin>
    log.lh.n++;
    800037b8:	00015717          	auipc	a4,0x15
    800037bc:	54870713          	addi	a4,a4,1352 # 80018d00 <log>
    800037c0:	575c                	lw	a5,44(a4)
    800037c2:	2785                	addiw	a5,a5,1
    800037c4:	d75c                	sw	a5,44(a4)
    800037c6:	a82d                	j	80003800 <log_write+0xc8>
    panic("too big a transaction");
    800037c8:	00005517          	auipc	a0,0x5
    800037cc:	e0850513          	addi	a0,a0,-504 # 800085d0 <syscalls+0x200>
    800037d0:	00002097          	auipc	ra,0x2
    800037d4:	4d0080e7          	jalr	1232(ra) # 80005ca0 <panic>
    panic("log_write outside of trans");
    800037d8:	00005517          	auipc	a0,0x5
    800037dc:	e1050513          	addi	a0,a0,-496 # 800085e8 <syscalls+0x218>
    800037e0:	00002097          	auipc	ra,0x2
    800037e4:	4c0080e7          	jalr	1216(ra) # 80005ca0 <panic>
  log.lh.block[i] = b->blockno;
    800037e8:	00878693          	addi	a3,a5,8
    800037ec:	068a                	slli	a3,a3,0x2
    800037ee:	00015717          	auipc	a4,0x15
    800037f2:	51270713          	addi	a4,a4,1298 # 80018d00 <log>
    800037f6:	9736                	add	a4,a4,a3
    800037f8:	44d4                	lw	a3,12(s1)
    800037fa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037fc:	faf609e3          	beq	a2,a5,800037ae <log_write+0x76>
  }
  release(&log.lock);
    80003800:	00015517          	auipc	a0,0x15
    80003804:	50050513          	addi	a0,a0,1280 # 80018d00 <log>
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	a5a080e7          	jalr	-1446(ra) # 80006262 <release>
}
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6902                	ld	s2,0(sp)
    80003818:	6105                	addi	sp,sp,32
    8000381a:	8082                	ret

000000008000381c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000381c:	1101                	addi	sp,sp,-32
    8000381e:	ec06                	sd	ra,24(sp)
    80003820:	e822                	sd	s0,16(sp)
    80003822:	e426                	sd	s1,8(sp)
    80003824:	e04a                	sd	s2,0(sp)
    80003826:	1000                	addi	s0,sp,32
    80003828:	84aa                	mv	s1,a0
    8000382a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000382c:	00005597          	auipc	a1,0x5
    80003830:	ddc58593          	addi	a1,a1,-548 # 80008608 <syscalls+0x238>
    80003834:	0521                	addi	a0,a0,8
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	8e8080e7          	jalr	-1816(ra) # 8000611e <initlock>
  lk->name = name;
    8000383e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003842:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003846:	0204a423          	sw	zero,40(s1)
}
    8000384a:	60e2                	ld	ra,24(sp)
    8000384c:	6442                	ld	s0,16(sp)
    8000384e:	64a2                	ld	s1,8(sp)
    80003850:	6902                	ld	s2,0(sp)
    80003852:	6105                	addi	sp,sp,32
    80003854:	8082                	ret

0000000080003856 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	e04a                	sd	s2,0(sp)
    80003860:	1000                	addi	s0,sp,32
    80003862:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003864:	00850913          	addi	s2,a0,8
    80003868:	854a                	mv	a0,s2
    8000386a:	00003097          	auipc	ra,0x3
    8000386e:	944080e7          	jalr	-1724(ra) # 800061ae <acquire>
  while (lk->locked) {
    80003872:	409c                	lw	a5,0(s1)
    80003874:	cb89                	beqz	a5,80003886 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003876:	85ca                	mv	a1,s2
    80003878:	8526                	mv	a0,s1
    8000387a:	ffffe097          	auipc	ra,0xffffe
    8000387e:	c98080e7          	jalr	-872(ra) # 80001512 <sleep>
  while (lk->locked) {
    80003882:	409c                	lw	a5,0(s1)
    80003884:	fbed                	bnez	a5,80003876 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003886:	4785                	li	a5,1
    80003888:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000388a:	ffffd097          	auipc	ra,0xffffd
    8000388e:	5c8080e7          	jalr	1480(ra) # 80000e52 <myproc>
    80003892:	591c                	lw	a5,48(a0)
    80003894:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003896:	854a                	mv	a0,s2
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	9ca080e7          	jalr	-1590(ra) # 80006262 <release>
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret

00000000800038ac <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	e426                	sd	s1,8(sp)
    800038b4:	e04a                	sd	s2,0(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ba:	00850913          	addi	s2,a0,8
    800038be:	854a                	mv	a0,s2
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	8ee080e7          	jalr	-1810(ra) # 800061ae <acquire>
  lk->locked = 0;
    800038c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038cc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038d0:	8526                	mv	a0,s1
    800038d2:	ffffe097          	auipc	ra,0xffffe
    800038d6:	ca4080e7          	jalr	-860(ra) # 80001576 <wakeup>
  release(&lk->lk);
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	986080e7          	jalr	-1658(ra) # 80006262 <release>
}
    800038e4:	60e2                	ld	ra,24(sp)
    800038e6:	6442                	ld	s0,16(sp)
    800038e8:	64a2                	ld	s1,8(sp)
    800038ea:	6902                	ld	s2,0(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret

00000000800038f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038f0:	7179                	addi	sp,sp,-48
    800038f2:	f406                	sd	ra,40(sp)
    800038f4:	f022                	sd	s0,32(sp)
    800038f6:	ec26                	sd	s1,24(sp)
    800038f8:	e84a                	sd	s2,16(sp)
    800038fa:	e44e                	sd	s3,8(sp)
    800038fc:	1800                	addi	s0,sp,48
    800038fe:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003900:	00850913          	addi	s2,a0,8
    80003904:	854a                	mv	a0,s2
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	8a8080e7          	jalr	-1880(ra) # 800061ae <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000390e:	409c                	lw	a5,0(s1)
    80003910:	ef99                	bnez	a5,8000392e <holdingsleep+0x3e>
    80003912:	4481                	li	s1,0
  release(&lk->lk);
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	94c080e7          	jalr	-1716(ra) # 80006262 <release>
  return r;
}
    8000391e:	8526                	mv	a0,s1
    80003920:	70a2                	ld	ra,40(sp)
    80003922:	7402                	ld	s0,32(sp)
    80003924:	64e2                	ld	s1,24(sp)
    80003926:	6942                	ld	s2,16(sp)
    80003928:	69a2                	ld	s3,8(sp)
    8000392a:	6145                	addi	sp,sp,48
    8000392c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000392e:	0284a983          	lw	s3,40(s1)
    80003932:	ffffd097          	auipc	ra,0xffffd
    80003936:	520080e7          	jalr	1312(ra) # 80000e52 <myproc>
    8000393a:	5904                	lw	s1,48(a0)
    8000393c:	413484b3          	sub	s1,s1,s3
    80003940:	0014b493          	seqz	s1,s1
    80003944:	bfc1                	j	80003914 <holdingsleep+0x24>

0000000080003946 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003946:	1141                	addi	sp,sp,-16
    80003948:	e406                	sd	ra,8(sp)
    8000394a:	e022                	sd	s0,0(sp)
    8000394c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000394e:	00005597          	auipc	a1,0x5
    80003952:	cca58593          	addi	a1,a1,-822 # 80008618 <syscalls+0x248>
    80003956:	00015517          	auipc	a0,0x15
    8000395a:	4f250513          	addi	a0,a0,1266 # 80018e48 <ftable>
    8000395e:	00002097          	auipc	ra,0x2
    80003962:	7c0080e7          	jalr	1984(ra) # 8000611e <initlock>
}
    80003966:	60a2                	ld	ra,8(sp)
    80003968:	6402                	ld	s0,0(sp)
    8000396a:	0141                	addi	sp,sp,16
    8000396c:	8082                	ret

000000008000396e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000396e:	1101                	addi	sp,sp,-32
    80003970:	ec06                	sd	ra,24(sp)
    80003972:	e822                	sd	s0,16(sp)
    80003974:	e426                	sd	s1,8(sp)
    80003976:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003978:	00015517          	auipc	a0,0x15
    8000397c:	4d050513          	addi	a0,a0,1232 # 80018e48 <ftable>
    80003980:	00003097          	auipc	ra,0x3
    80003984:	82e080e7          	jalr	-2002(ra) # 800061ae <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003988:	00015497          	auipc	s1,0x15
    8000398c:	4d848493          	addi	s1,s1,1240 # 80018e60 <ftable+0x18>
    80003990:	00016717          	auipc	a4,0x16
    80003994:	47070713          	addi	a4,a4,1136 # 80019e00 <disk>
    if(f->ref == 0){
    80003998:	40dc                	lw	a5,4(s1)
    8000399a:	cf99                	beqz	a5,800039b8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000399c:	02848493          	addi	s1,s1,40
    800039a0:	fee49ce3          	bne	s1,a4,80003998 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039a4:	00015517          	auipc	a0,0x15
    800039a8:	4a450513          	addi	a0,a0,1188 # 80018e48 <ftable>
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	8b6080e7          	jalr	-1866(ra) # 80006262 <release>
  return 0;
    800039b4:	4481                	li	s1,0
    800039b6:	a819                	j	800039cc <filealloc+0x5e>
      f->ref = 1;
    800039b8:	4785                	li	a5,1
    800039ba:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039bc:	00015517          	auipc	a0,0x15
    800039c0:	48c50513          	addi	a0,a0,1164 # 80018e48 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	89e080e7          	jalr	-1890(ra) # 80006262 <release>
}
    800039cc:	8526                	mv	a0,s1
    800039ce:	60e2                	ld	ra,24(sp)
    800039d0:	6442                	ld	s0,16(sp)
    800039d2:	64a2                	ld	s1,8(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret

00000000800039d8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039d8:	1101                	addi	sp,sp,-32
    800039da:	ec06                	sd	ra,24(sp)
    800039dc:	e822                	sd	s0,16(sp)
    800039de:	e426                	sd	s1,8(sp)
    800039e0:	1000                	addi	s0,sp,32
    800039e2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039e4:	00015517          	auipc	a0,0x15
    800039e8:	46450513          	addi	a0,a0,1124 # 80018e48 <ftable>
    800039ec:	00002097          	auipc	ra,0x2
    800039f0:	7c2080e7          	jalr	1986(ra) # 800061ae <acquire>
  if(f->ref < 1)
    800039f4:	40dc                	lw	a5,4(s1)
    800039f6:	02f05263          	blez	a5,80003a1a <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039fa:	2785                	addiw	a5,a5,1
    800039fc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039fe:	00015517          	auipc	a0,0x15
    80003a02:	44a50513          	addi	a0,a0,1098 # 80018e48 <ftable>
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	85c080e7          	jalr	-1956(ra) # 80006262 <release>
  return f;
}
    80003a0e:	8526                	mv	a0,s1
    80003a10:	60e2                	ld	ra,24(sp)
    80003a12:	6442                	ld	s0,16(sp)
    80003a14:	64a2                	ld	s1,8(sp)
    80003a16:	6105                	addi	sp,sp,32
    80003a18:	8082                	ret
    panic("filedup");
    80003a1a:	00005517          	auipc	a0,0x5
    80003a1e:	c0650513          	addi	a0,a0,-1018 # 80008620 <syscalls+0x250>
    80003a22:	00002097          	auipc	ra,0x2
    80003a26:	27e080e7          	jalr	638(ra) # 80005ca0 <panic>

0000000080003a2a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a2a:	7139                	addi	sp,sp,-64
    80003a2c:	fc06                	sd	ra,56(sp)
    80003a2e:	f822                	sd	s0,48(sp)
    80003a30:	f426                	sd	s1,40(sp)
    80003a32:	f04a                	sd	s2,32(sp)
    80003a34:	ec4e                	sd	s3,24(sp)
    80003a36:	e852                	sd	s4,16(sp)
    80003a38:	e456                	sd	s5,8(sp)
    80003a3a:	0080                	addi	s0,sp,64
    80003a3c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a3e:	00015517          	auipc	a0,0x15
    80003a42:	40a50513          	addi	a0,a0,1034 # 80018e48 <ftable>
    80003a46:	00002097          	auipc	ra,0x2
    80003a4a:	768080e7          	jalr	1896(ra) # 800061ae <acquire>
  if(f->ref < 1)
    80003a4e:	40dc                	lw	a5,4(s1)
    80003a50:	06f05163          	blez	a5,80003ab2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a54:	37fd                	addiw	a5,a5,-1
    80003a56:	0007871b          	sext.w	a4,a5
    80003a5a:	c0dc                	sw	a5,4(s1)
    80003a5c:	06e04363          	bgtz	a4,80003ac2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a60:	0004a903          	lw	s2,0(s1)
    80003a64:	0094ca83          	lbu	s5,9(s1)
    80003a68:	0104ba03          	ld	s4,16(s1)
    80003a6c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a70:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a74:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a78:	00015517          	auipc	a0,0x15
    80003a7c:	3d050513          	addi	a0,a0,976 # 80018e48 <ftable>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	7e2080e7          	jalr	2018(ra) # 80006262 <release>

  if(ff.type == FD_PIPE){
    80003a88:	4785                	li	a5,1
    80003a8a:	04f90d63          	beq	s2,a5,80003ae4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a8e:	3979                	addiw	s2,s2,-2
    80003a90:	4785                	li	a5,1
    80003a92:	0527e063          	bltu	a5,s2,80003ad2 <fileclose+0xa8>
    begin_op();
    80003a96:	00000097          	auipc	ra,0x0
    80003a9a:	ad0080e7          	jalr	-1328(ra) # 80003566 <begin_op>
    iput(ff.ip);
    80003a9e:	854e                	mv	a0,s3
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	2da080e7          	jalr	730(ra) # 80002d7a <iput>
    end_op();
    80003aa8:	00000097          	auipc	ra,0x0
    80003aac:	b38080e7          	jalr	-1224(ra) # 800035e0 <end_op>
    80003ab0:	a00d                	j	80003ad2 <fileclose+0xa8>
    panic("fileclose");
    80003ab2:	00005517          	auipc	a0,0x5
    80003ab6:	b7650513          	addi	a0,a0,-1162 # 80008628 <syscalls+0x258>
    80003aba:	00002097          	auipc	ra,0x2
    80003abe:	1e6080e7          	jalr	486(ra) # 80005ca0 <panic>
    release(&ftable.lock);
    80003ac2:	00015517          	auipc	a0,0x15
    80003ac6:	38650513          	addi	a0,a0,902 # 80018e48 <ftable>
    80003aca:	00002097          	auipc	ra,0x2
    80003ace:	798080e7          	jalr	1944(ra) # 80006262 <release>
  }
}
    80003ad2:	70e2                	ld	ra,56(sp)
    80003ad4:	7442                	ld	s0,48(sp)
    80003ad6:	74a2                	ld	s1,40(sp)
    80003ad8:	7902                	ld	s2,32(sp)
    80003ada:	69e2                	ld	s3,24(sp)
    80003adc:	6a42                	ld	s4,16(sp)
    80003ade:	6aa2                	ld	s5,8(sp)
    80003ae0:	6121                	addi	sp,sp,64
    80003ae2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ae4:	85d6                	mv	a1,s5
    80003ae6:	8552                	mv	a0,s4
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	348080e7          	jalr	840(ra) # 80003e30 <pipeclose>
    80003af0:	b7cd                	j	80003ad2 <fileclose+0xa8>

0000000080003af2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003af2:	715d                	addi	sp,sp,-80
    80003af4:	e486                	sd	ra,72(sp)
    80003af6:	e0a2                	sd	s0,64(sp)
    80003af8:	fc26                	sd	s1,56(sp)
    80003afa:	f84a                	sd	s2,48(sp)
    80003afc:	f44e                	sd	s3,40(sp)
    80003afe:	0880                	addi	s0,sp,80
    80003b00:	84aa                	mv	s1,a0
    80003b02:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b04:	ffffd097          	auipc	ra,0xffffd
    80003b08:	34e080e7          	jalr	846(ra) # 80000e52 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b0c:	409c                	lw	a5,0(s1)
    80003b0e:	37f9                	addiw	a5,a5,-2
    80003b10:	4705                	li	a4,1
    80003b12:	04f76763          	bltu	a4,a5,80003b60 <filestat+0x6e>
    80003b16:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b18:	6c88                	ld	a0,24(s1)
    80003b1a:	fffff097          	auipc	ra,0xfffff
    80003b1e:	0a6080e7          	jalr	166(ra) # 80002bc0 <ilock>
    stati(f->ip, &st);
    80003b22:	fb840593          	addi	a1,s0,-72
    80003b26:	6c88                	ld	a0,24(s1)
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	322080e7          	jalr	802(ra) # 80002e4a <stati>
    iunlock(f->ip);
    80003b30:	6c88                	ld	a0,24(s1)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	150080e7          	jalr	336(ra) # 80002c82 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b3a:	46e1                	li	a3,24
    80003b3c:	fb840613          	addi	a2,s0,-72
    80003b40:	85ce                	mv	a1,s3
    80003b42:	05093503          	ld	a0,80(s2)
    80003b46:	ffffd097          	auipc	ra,0xffffd
    80003b4a:	fcc080e7          	jalr	-52(ra) # 80000b12 <copyout>
    80003b4e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b52:	60a6                	ld	ra,72(sp)
    80003b54:	6406                	ld	s0,64(sp)
    80003b56:	74e2                	ld	s1,56(sp)
    80003b58:	7942                	ld	s2,48(sp)
    80003b5a:	79a2                	ld	s3,40(sp)
    80003b5c:	6161                	addi	sp,sp,80
    80003b5e:	8082                	ret
  return -1;
    80003b60:	557d                	li	a0,-1
    80003b62:	bfc5                	j	80003b52 <filestat+0x60>

0000000080003b64 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b64:	7179                	addi	sp,sp,-48
    80003b66:	f406                	sd	ra,40(sp)
    80003b68:	f022                	sd	s0,32(sp)
    80003b6a:	ec26                	sd	s1,24(sp)
    80003b6c:	e84a                	sd	s2,16(sp)
    80003b6e:	e44e                	sd	s3,8(sp)
    80003b70:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b72:	00854783          	lbu	a5,8(a0)
    80003b76:	c3d5                	beqz	a5,80003c1a <fileread+0xb6>
    80003b78:	84aa                	mv	s1,a0
    80003b7a:	89ae                	mv	s3,a1
    80003b7c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b7e:	411c                	lw	a5,0(a0)
    80003b80:	4705                	li	a4,1
    80003b82:	04e78963          	beq	a5,a4,80003bd4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b86:	470d                	li	a4,3
    80003b88:	04e78d63          	beq	a5,a4,80003be2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b8c:	4709                	li	a4,2
    80003b8e:	06e79e63          	bne	a5,a4,80003c0a <fileread+0xa6>
    ilock(f->ip);
    80003b92:	6d08                	ld	a0,24(a0)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	02c080e7          	jalr	44(ra) # 80002bc0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b9c:	874a                	mv	a4,s2
    80003b9e:	5094                	lw	a3,32(s1)
    80003ba0:	864e                	mv	a2,s3
    80003ba2:	4585                	li	a1,1
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	2ce080e7          	jalr	718(ra) # 80002e74 <readi>
    80003bae:	892a                	mv	s2,a0
    80003bb0:	00a05563          	blez	a0,80003bba <fileread+0x56>
      f->off += r;
    80003bb4:	509c                	lw	a5,32(s1)
    80003bb6:	9fa9                	addw	a5,a5,a0
    80003bb8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bba:	6c88                	ld	a0,24(s1)
    80003bbc:	fffff097          	auipc	ra,0xfffff
    80003bc0:	0c6080e7          	jalr	198(ra) # 80002c82 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bc4:	854a                	mv	a0,s2
    80003bc6:	70a2                	ld	ra,40(sp)
    80003bc8:	7402                	ld	s0,32(sp)
    80003bca:	64e2                	ld	s1,24(sp)
    80003bcc:	6942                	ld	s2,16(sp)
    80003bce:	69a2                	ld	s3,8(sp)
    80003bd0:	6145                	addi	sp,sp,48
    80003bd2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bd4:	6908                	ld	a0,16(a0)
    80003bd6:	00000097          	auipc	ra,0x0
    80003bda:	3c2080e7          	jalr	962(ra) # 80003f98 <piperead>
    80003bde:	892a                	mv	s2,a0
    80003be0:	b7d5                	j	80003bc4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003be2:	02451783          	lh	a5,36(a0)
    80003be6:	03079693          	slli	a3,a5,0x30
    80003bea:	92c1                	srli	a3,a3,0x30
    80003bec:	4725                	li	a4,9
    80003bee:	02d76863          	bltu	a4,a3,80003c1e <fileread+0xba>
    80003bf2:	0792                	slli	a5,a5,0x4
    80003bf4:	00015717          	auipc	a4,0x15
    80003bf8:	1b470713          	addi	a4,a4,436 # 80018da8 <devsw>
    80003bfc:	97ba                	add	a5,a5,a4
    80003bfe:	639c                	ld	a5,0(a5)
    80003c00:	c38d                	beqz	a5,80003c22 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c02:	4505                	li	a0,1
    80003c04:	9782                	jalr	a5
    80003c06:	892a                	mv	s2,a0
    80003c08:	bf75                	j	80003bc4 <fileread+0x60>
    panic("fileread");
    80003c0a:	00005517          	auipc	a0,0x5
    80003c0e:	a2e50513          	addi	a0,a0,-1490 # 80008638 <syscalls+0x268>
    80003c12:	00002097          	auipc	ra,0x2
    80003c16:	08e080e7          	jalr	142(ra) # 80005ca0 <panic>
    return -1;
    80003c1a:	597d                	li	s2,-1
    80003c1c:	b765                	j	80003bc4 <fileread+0x60>
      return -1;
    80003c1e:	597d                	li	s2,-1
    80003c20:	b755                	j	80003bc4 <fileread+0x60>
    80003c22:	597d                	li	s2,-1
    80003c24:	b745                	j	80003bc4 <fileread+0x60>

0000000080003c26 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c26:	00954783          	lbu	a5,9(a0)
    80003c2a:	10078e63          	beqz	a5,80003d46 <filewrite+0x120>
{
    80003c2e:	715d                	addi	sp,sp,-80
    80003c30:	e486                	sd	ra,72(sp)
    80003c32:	e0a2                	sd	s0,64(sp)
    80003c34:	fc26                	sd	s1,56(sp)
    80003c36:	f84a                	sd	s2,48(sp)
    80003c38:	f44e                	sd	s3,40(sp)
    80003c3a:	f052                	sd	s4,32(sp)
    80003c3c:	ec56                	sd	s5,24(sp)
    80003c3e:	e85a                	sd	s6,16(sp)
    80003c40:	e45e                	sd	s7,8(sp)
    80003c42:	e062                	sd	s8,0(sp)
    80003c44:	0880                	addi	s0,sp,80
    80003c46:	892a                	mv	s2,a0
    80003c48:	8b2e                	mv	s6,a1
    80003c4a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c4c:	411c                	lw	a5,0(a0)
    80003c4e:	4705                	li	a4,1
    80003c50:	02e78263          	beq	a5,a4,80003c74 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c54:	470d                	li	a4,3
    80003c56:	02e78563          	beq	a5,a4,80003c80 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c5a:	4709                	li	a4,2
    80003c5c:	0ce79d63          	bne	a5,a4,80003d36 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c60:	0ac05b63          	blez	a2,80003d16 <filewrite+0xf0>
    int i = 0;
    80003c64:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c66:	6b85                	lui	s7,0x1
    80003c68:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c6c:	6c05                	lui	s8,0x1
    80003c6e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c72:	a851                	j	80003d06 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c74:	6908                	ld	a0,16(a0)
    80003c76:	00000097          	auipc	ra,0x0
    80003c7a:	22a080e7          	jalr	554(ra) # 80003ea0 <pipewrite>
    80003c7e:	a045                	j	80003d1e <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c80:	02451783          	lh	a5,36(a0)
    80003c84:	03079693          	slli	a3,a5,0x30
    80003c88:	92c1                	srli	a3,a3,0x30
    80003c8a:	4725                	li	a4,9
    80003c8c:	0ad76f63          	bltu	a4,a3,80003d4a <filewrite+0x124>
    80003c90:	0792                	slli	a5,a5,0x4
    80003c92:	00015717          	auipc	a4,0x15
    80003c96:	11670713          	addi	a4,a4,278 # 80018da8 <devsw>
    80003c9a:	97ba                	add	a5,a5,a4
    80003c9c:	679c                	ld	a5,8(a5)
    80003c9e:	cbc5                	beqz	a5,80003d4e <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003ca0:	4505                	li	a0,1
    80003ca2:	9782                	jalr	a5
    80003ca4:	a8ad                	j	80003d1e <filewrite+0xf8>
      if(n1 > max)
    80003ca6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	8bc080e7          	jalr	-1860(ra) # 80003566 <begin_op>
      ilock(f->ip);
    80003cb2:	01893503          	ld	a0,24(s2)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	f0a080e7          	jalr	-246(ra) # 80002bc0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cbe:	8756                	mv	a4,s5
    80003cc0:	02092683          	lw	a3,32(s2)
    80003cc4:	01698633          	add	a2,s3,s6
    80003cc8:	4585                	li	a1,1
    80003cca:	01893503          	ld	a0,24(s2)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	29e080e7          	jalr	670(ra) # 80002f6c <writei>
    80003cd6:	84aa                	mv	s1,a0
    80003cd8:	00a05763          	blez	a0,80003ce6 <filewrite+0xc0>
        f->off += r;
    80003cdc:	02092783          	lw	a5,32(s2)
    80003ce0:	9fa9                	addw	a5,a5,a0
    80003ce2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ce6:	01893503          	ld	a0,24(s2)
    80003cea:	fffff097          	auipc	ra,0xfffff
    80003cee:	f98080e7          	jalr	-104(ra) # 80002c82 <iunlock>
      end_op();
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	8ee080e7          	jalr	-1810(ra) # 800035e0 <end_op>

      if(r != n1){
    80003cfa:	009a9f63          	bne	s5,s1,80003d18 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003cfe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d02:	0149db63          	bge	s3,s4,80003d18 <filewrite+0xf2>
      int n1 = n - i;
    80003d06:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d0a:	0004879b          	sext.w	a5,s1
    80003d0e:	f8fbdce3          	bge	s7,a5,80003ca6 <filewrite+0x80>
    80003d12:	84e2                	mv	s1,s8
    80003d14:	bf49                	j	80003ca6 <filewrite+0x80>
    int i = 0;
    80003d16:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d18:	033a1d63          	bne	s4,s3,80003d52 <filewrite+0x12c>
    80003d1c:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d1e:	60a6                	ld	ra,72(sp)
    80003d20:	6406                	ld	s0,64(sp)
    80003d22:	74e2                	ld	s1,56(sp)
    80003d24:	7942                	ld	s2,48(sp)
    80003d26:	79a2                	ld	s3,40(sp)
    80003d28:	7a02                	ld	s4,32(sp)
    80003d2a:	6ae2                	ld	s5,24(sp)
    80003d2c:	6b42                	ld	s6,16(sp)
    80003d2e:	6ba2                	ld	s7,8(sp)
    80003d30:	6c02                	ld	s8,0(sp)
    80003d32:	6161                	addi	sp,sp,80
    80003d34:	8082                	ret
    panic("filewrite");
    80003d36:	00005517          	auipc	a0,0x5
    80003d3a:	91250513          	addi	a0,a0,-1774 # 80008648 <syscalls+0x278>
    80003d3e:	00002097          	auipc	ra,0x2
    80003d42:	f62080e7          	jalr	-158(ra) # 80005ca0 <panic>
    return -1;
    80003d46:	557d                	li	a0,-1
}
    80003d48:	8082                	ret
      return -1;
    80003d4a:	557d                	li	a0,-1
    80003d4c:	bfc9                	j	80003d1e <filewrite+0xf8>
    80003d4e:	557d                	li	a0,-1
    80003d50:	b7f9                	j	80003d1e <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003d52:	557d                	li	a0,-1
    80003d54:	b7e9                	j	80003d1e <filewrite+0xf8>

0000000080003d56 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d56:	7179                	addi	sp,sp,-48
    80003d58:	f406                	sd	ra,40(sp)
    80003d5a:	f022                	sd	s0,32(sp)
    80003d5c:	ec26                	sd	s1,24(sp)
    80003d5e:	e84a                	sd	s2,16(sp)
    80003d60:	e44e                	sd	s3,8(sp)
    80003d62:	e052                	sd	s4,0(sp)
    80003d64:	1800                	addi	s0,sp,48
    80003d66:	84aa                	mv	s1,a0
    80003d68:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d6a:	0005b023          	sd	zero,0(a1)
    80003d6e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	bfc080e7          	jalr	-1028(ra) # 8000396e <filealloc>
    80003d7a:	e088                	sd	a0,0(s1)
    80003d7c:	c551                	beqz	a0,80003e08 <pipealloc+0xb2>
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	bf0080e7          	jalr	-1040(ra) # 8000396e <filealloc>
    80003d86:	00aa3023          	sd	a0,0(s4)
    80003d8a:	c92d                	beqz	a0,80003dfc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d8c:	ffffc097          	auipc	ra,0xffffc
    80003d90:	38e080e7          	jalr	910(ra) # 8000011a <kalloc>
    80003d94:	892a                	mv	s2,a0
    80003d96:	c125                	beqz	a0,80003df6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d98:	4985                	li	s3,1
    80003d9a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d9e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003da2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003da6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003daa:	00005597          	auipc	a1,0x5
    80003dae:	8ae58593          	addi	a1,a1,-1874 # 80008658 <syscalls+0x288>
    80003db2:	00002097          	auipc	ra,0x2
    80003db6:	36c080e7          	jalr	876(ra) # 8000611e <initlock>
  (*f0)->type = FD_PIPE;
    80003dba:	609c                	ld	a5,0(s1)
    80003dbc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dc0:	609c                	ld	a5,0(s1)
    80003dc2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dc6:	609c                	ld	a5,0(s1)
    80003dc8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dcc:	609c                	ld	a5,0(s1)
    80003dce:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dd2:	000a3783          	ld	a5,0(s4)
    80003dd6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dda:	000a3783          	ld	a5,0(s4)
    80003dde:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003de2:	000a3783          	ld	a5,0(s4)
    80003de6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dea:	000a3783          	ld	a5,0(s4)
    80003dee:	0127b823          	sd	s2,16(a5)
  return 0;
    80003df2:	4501                	li	a0,0
    80003df4:	a025                	j	80003e1c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003df6:	6088                	ld	a0,0(s1)
    80003df8:	e501                	bnez	a0,80003e00 <pipealloc+0xaa>
    80003dfa:	a039                	j	80003e08 <pipealloc+0xb2>
    80003dfc:	6088                	ld	a0,0(s1)
    80003dfe:	c51d                	beqz	a0,80003e2c <pipealloc+0xd6>
    fileclose(*f0);
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	c2a080e7          	jalr	-982(ra) # 80003a2a <fileclose>
  if(*f1)
    80003e08:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e0c:	557d                	li	a0,-1
  if(*f1)
    80003e0e:	c799                	beqz	a5,80003e1c <pipealloc+0xc6>
    fileclose(*f1);
    80003e10:	853e                	mv	a0,a5
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	c18080e7          	jalr	-1000(ra) # 80003a2a <fileclose>
  return -1;
    80003e1a:	557d                	li	a0,-1
}
    80003e1c:	70a2                	ld	ra,40(sp)
    80003e1e:	7402                	ld	s0,32(sp)
    80003e20:	64e2                	ld	s1,24(sp)
    80003e22:	6942                	ld	s2,16(sp)
    80003e24:	69a2                	ld	s3,8(sp)
    80003e26:	6a02                	ld	s4,0(sp)
    80003e28:	6145                	addi	sp,sp,48
    80003e2a:	8082                	ret
  return -1;
    80003e2c:	557d                	li	a0,-1
    80003e2e:	b7fd                	j	80003e1c <pipealloc+0xc6>

0000000080003e30 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e30:	1101                	addi	sp,sp,-32
    80003e32:	ec06                	sd	ra,24(sp)
    80003e34:	e822                	sd	s0,16(sp)
    80003e36:	e426                	sd	s1,8(sp)
    80003e38:	e04a                	sd	s2,0(sp)
    80003e3a:	1000                	addi	s0,sp,32
    80003e3c:	84aa                	mv	s1,a0
    80003e3e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e40:	00002097          	auipc	ra,0x2
    80003e44:	36e080e7          	jalr	878(ra) # 800061ae <acquire>
  if(writable){
    80003e48:	02090d63          	beqz	s2,80003e82 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e4c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e50:	21848513          	addi	a0,s1,536
    80003e54:	ffffd097          	auipc	ra,0xffffd
    80003e58:	722080e7          	jalr	1826(ra) # 80001576 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e5c:	2204b783          	ld	a5,544(s1)
    80003e60:	eb95                	bnez	a5,80003e94 <pipeclose+0x64>
    release(&pi->lock);
    80003e62:	8526                	mv	a0,s1
    80003e64:	00002097          	auipc	ra,0x2
    80003e68:	3fe080e7          	jalr	1022(ra) # 80006262 <release>
    kfree((char*)pi);
    80003e6c:	8526                	mv	a0,s1
    80003e6e:	ffffc097          	auipc	ra,0xffffc
    80003e72:	1ae080e7          	jalr	430(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e76:	60e2                	ld	ra,24(sp)
    80003e78:	6442                	ld	s0,16(sp)
    80003e7a:	64a2                	ld	s1,8(sp)
    80003e7c:	6902                	ld	s2,0(sp)
    80003e7e:	6105                	addi	sp,sp,32
    80003e80:	8082                	ret
    pi->readopen = 0;
    80003e82:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e86:	21c48513          	addi	a0,s1,540
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	6ec080e7          	jalr	1772(ra) # 80001576 <wakeup>
    80003e92:	b7e9                	j	80003e5c <pipeclose+0x2c>
    release(&pi->lock);
    80003e94:	8526                	mv	a0,s1
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	3cc080e7          	jalr	972(ra) # 80006262 <release>
}
    80003e9e:	bfe1                	j	80003e76 <pipeclose+0x46>

0000000080003ea0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ea0:	711d                	addi	sp,sp,-96
    80003ea2:	ec86                	sd	ra,88(sp)
    80003ea4:	e8a2                	sd	s0,80(sp)
    80003ea6:	e4a6                	sd	s1,72(sp)
    80003ea8:	e0ca                	sd	s2,64(sp)
    80003eaa:	fc4e                	sd	s3,56(sp)
    80003eac:	f852                	sd	s4,48(sp)
    80003eae:	f456                	sd	s5,40(sp)
    80003eb0:	f05a                	sd	s6,32(sp)
    80003eb2:	ec5e                	sd	s7,24(sp)
    80003eb4:	e862                	sd	s8,16(sp)
    80003eb6:	1080                	addi	s0,sp,96
    80003eb8:	84aa                	mv	s1,a0
    80003eba:	8aae                	mv	s5,a1
    80003ebc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ebe:	ffffd097          	auipc	ra,0xffffd
    80003ec2:	f94080e7          	jalr	-108(ra) # 80000e52 <myproc>
    80003ec6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	00002097          	auipc	ra,0x2
    80003ece:	2e4080e7          	jalr	740(ra) # 800061ae <acquire>
  while(i < n){
    80003ed2:	0b405663          	blez	s4,80003f7e <pipewrite+0xde>
  int i = 0;
    80003ed6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ed8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003eda:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ede:	21c48b93          	addi	s7,s1,540
    80003ee2:	a089                	j	80003f24 <pipewrite+0x84>
      release(&pi->lock);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	37c080e7          	jalr	892(ra) # 80006262 <release>
      return -1;
    80003eee:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ef0:	854a                	mv	a0,s2
    80003ef2:	60e6                	ld	ra,88(sp)
    80003ef4:	6446                	ld	s0,80(sp)
    80003ef6:	64a6                	ld	s1,72(sp)
    80003ef8:	6906                	ld	s2,64(sp)
    80003efa:	79e2                	ld	s3,56(sp)
    80003efc:	7a42                	ld	s4,48(sp)
    80003efe:	7aa2                	ld	s5,40(sp)
    80003f00:	7b02                	ld	s6,32(sp)
    80003f02:	6be2                	ld	s7,24(sp)
    80003f04:	6c42                	ld	s8,16(sp)
    80003f06:	6125                	addi	sp,sp,96
    80003f08:	8082                	ret
      wakeup(&pi->nread);
    80003f0a:	8562                	mv	a0,s8
    80003f0c:	ffffd097          	auipc	ra,0xffffd
    80003f10:	66a080e7          	jalr	1642(ra) # 80001576 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f14:	85a6                	mv	a1,s1
    80003f16:	855e                	mv	a0,s7
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	5fa080e7          	jalr	1530(ra) # 80001512 <sleep>
  while(i < n){
    80003f20:	07495063          	bge	s2,s4,80003f80 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f24:	2204a783          	lw	a5,544(s1)
    80003f28:	dfd5                	beqz	a5,80003ee4 <pipewrite+0x44>
    80003f2a:	854e                	mv	a0,s3
    80003f2c:	ffffe097          	auipc	ra,0xffffe
    80003f30:	88e080e7          	jalr	-1906(ra) # 800017ba <killed>
    80003f34:	f945                	bnez	a0,80003ee4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f36:	2184a783          	lw	a5,536(s1)
    80003f3a:	21c4a703          	lw	a4,540(s1)
    80003f3e:	2007879b          	addiw	a5,a5,512
    80003f42:	fcf704e3          	beq	a4,a5,80003f0a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f46:	4685                	li	a3,1
    80003f48:	01590633          	add	a2,s2,s5
    80003f4c:	faf40593          	addi	a1,s0,-81
    80003f50:	0509b503          	ld	a0,80(s3)
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	c4a080e7          	jalr	-950(ra) # 80000b9e <copyin>
    80003f5c:	03650263          	beq	a0,s6,80003f80 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f60:	21c4a783          	lw	a5,540(s1)
    80003f64:	0017871b          	addiw	a4,a5,1
    80003f68:	20e4ae23          	sw	a4,540(s1)
    80003f6c:	1ff7f793          	andi	a5,a5,511
    80003f70:	97a6                	add	a5,a5,s1
    80003f72:	faf44703          	lbu	a4,-81(s0)
    80003f76:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f7a:	2905                	addiw	s2,s2,1
    80003f7c:	b755                	j	80003f20 <pipewrite+0x80>
  int i = 0;
    80003f7e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f80:	21848513          	addi	a0,s1,536
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	5f2080e7          	jalr	1522(ra) # 80001576 <wakeup>
  release(&pi->lock);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	00002097          	auipc	ra,0x2
    80003f92:	2d4080e7          	jalr	724(ra) # 80006262 <release>
  return i;
    80003f96:	bfa9                	j	80003ef0 <pipewrite+0x50>

0000000080003f98 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f98:	715d                	addi	sp,sp,-80
    80003f9a:	e486                	sd	ra,72(sp)
    80003f9c:	e0a2                	sd	s0,64(sp)
    80003f9e:	fc26                	sd	s1,56(sp)
    80003fa0:	f84a                	sd	s2,48(sp)
    80003fa2:	f44e                	sd	s3,40(sp)
    80003fa4:	f052                	sd	s4,32(sp)
    80003fa6:	ec56                	sd	s5,24(sp)
    80003fa8:	e85a                	sd	s6,16(sp)
    80003faa:	0880                	addi	s0,sp,80
    80003fac:	84aa                	mv	s1,a0
    80003fae:	892e                	mv	s2,a1
    80003fb0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fb2:	ffffd097          	auipc	ra,0xffffd
    80003fb6:	ea0080e7          	jalr	-352(ra) # 80000e52 <myproc>
    80003fba:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fbc:	8526                	mv	a0,s1
    80003fbe:	00002097          	auipc	ra,0x2
    80003fc2:	1f0080e7          	jalr	496(ra) # 800061ae <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fc6:	2184a703          	lw	a4,536(s1)
    80003fca:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fce:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd2:	02f71763          	bne	a4,a5,80004000 <piperead+0x68>
    80003fd6:	2244a783          	lw	a5,548(s1)
    80003fda:	c39d                	beqz	a5,80004000 <piperead+0x68>
    if(killed(pr)){
    80003fdc:	8552                	mv	a0,s4
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	7dc080e7          	jalr	2012(ra) # 800017ba <killed>
    80003fe6:	e949                	bnez	a0,80004078 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe8:	85a6                	mv	a1,s1
    80003fea:	854e                	mv	a0,s3
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	526080e7          	jalr	1318(ra) # 80001512 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff4:	2184a703          	lw	a4,536(s1)
    80003ff8:	21c4a783          	lw	a5,540(s1)
    80003ffc:	fcf70de3          	beq	a4,a5,80003fd6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004000:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004002:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004004:	05505463          	blez	s5,8000404c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004008:	2184a783          	lw	a5,536(s1)
    8000400c:	21c4a703          	lw	a4,540(s1)
    80004010:	02f70e63          	beq	a4,a5,8000404c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004014:	0017871b          	addiw	a4,a5,1
    80004018:	20e4ac23          	sw	a4,536(s1)
    8000401c:	1ff7f793          	andi	a5,a5,511
    80004020:	97a6                	add	a5,a5,s1
    80004022:	0187c783          	lbu	a5,24(a5)
    80004026:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000402a:	4685                	li	a3,1
    8000402c:	fbf40613          	addi	a2,s0,-65
    80004030:	85ca                	mv	a1,s2
    80004032:	050a3503          	ld	a0,80(s4)
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	adc080e7          	jalr	-1316(ra) # 80000b12 <copyout>
    8000403e:	01650763          	beq	a0,s6,8000404c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004042:	2985                	addiw	s3,s3,1
    80004044:	0905                	addi	s2,s2,1
    80004046:	fd3a91e3          	bne	s5,s3,80004008 <piperead+0x70>
    8000404a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000404c:	21c48513          	addi	a0,s1,540
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	526080e7          	jalr	1318(ra) # 80001576 <wakeup>
  release(&pi->lock);
    80004058:	8526                	mv	a0,s1
    8000405a:	00002097          	auipc	ra,0x2
    8000405e:	208080e7          	jalr	520(ra) # 80006262 <release>
  return i;
}
    80004062:	854e                	mv	a0,s3
    80004064:	60a6                	ld	ra,72(sp)
    80004066:	6406                	ld	s0,64(sp)
    80004068:	74e2                	ld	s1,56(sp)
    8000406a:	7942                	ld	s2,48(sp)
    8000406c:	79a2                	ld	s3,40(sp)
    8000406e:	7a02                	ld	s4,32(sp)
    80004070:	6ae2                	ld	s5,24(sp)
    80004072:	6b42                	ld	s6,16(sp)
    80004074:	6161                	addi	sp,sp,80
    80004076:	8082                	ret
      release(&pi->lock);
    80004078:	8526                	mv	a0,s1
    8000407a:	00002097          	auipc	ra,0x2
    8000407e:	1e8080e7          	jalr	488(ra) # 80006262 <release>
      return -1;
    80004082:	59fd                	li	s3,-1
    80004084:	bff9                	j	80004062 <piperead+0xca>

0000000080004086 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004086:	1141                	addi	sp,sp,-16
    80004088:	e422                	sd	s0,8(sp)
    8000408a:	0800                	addi	s0,sp,16
    8000408c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000408e:	8905                	andi	a0,a0,1
    80004090:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004092:	8b89                	andi	a5,a5,2
    80004094:	c399                	beqz	a5,8000409a <flags2perm+0x14>
      perm |= PTE_W;
    80004096:	00456513          	ori	a0,a0,4
    return perm;
}
    8000409a:	6422                	ld	s0,8(sp)
    8000409c:	0141                	addi	sp,sp,16
    8000409e:	8082                	ret

00000000800040a0 <exec>:

int
exec(char *path, char **argv)
{
    800040a0:	df010113          	addi	sp,sp,-528
    800040a4:	20113423          	sd	ra,520(sp)
    800040a8:	20813023          	sd	s0,512(sp)
    800040ac:	ffa6                	sd	s1,504(sp)
    800040ae:	fbca                	sd	s2,496(sp)
    800040b0:	f7ce                	sd	s3,488(sp)
    800040b2:	f3d2                	sd	s4,480(sp)
    800040b4:	efd6                	sd	s5,472(sp)
    800040b6:	ebda                	sd	s6,464(sp)
    800040b8:	e7de                	sd	s7,456(sp)
    800040ba:	e3e2                	sd	s8,448(sp)
    800040bc:	ff66                	sd	s9,440(sp)
    800040be:	fb6a                	sd	s10,432(sp)
    800040c0:	f76e                	sd	s11,424(sp)
    800040c2:	0c00                	addi	s0,sp,528
    800040c4:	892a                	mv	s2,a0
    800040c6:	dea43c23          	sd	a0,-520(s0)
    800040ca:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	d84080e7          	jalr	-636(ra) # 80000e52 <myproc>
    800040d6:	84aa                	mv	s1,a0

  begin_op();
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	48e080e7          	jalr	1166(ra) # 80003566 <begin_op>

  if((ip = namei(path)) == 0){
    800040e0:	854a                	mv	a0,s2
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	284080e7          	jalr	644(ra) # 80003366 <namei>
    800040ea:	c92d                	beqz	a0,8000415c <exec+0xbc>
    800040ec:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040ee:	fffff097          	auipc	ra,0xfffff
    800040f2:	ad2080e7          	jalr	-1326(ra) # 80002bc0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040f6:	04000713          	li	a4,64
    800040fa:	4681                	li	a3,0
    800040fc:	e5040613          	addi	a2,s0,-432
    80004100:	4581                	li	a1,0
    80004102:	8552                	mv	a0,s4
    80004104:	fffff097          	auipc	ra,0xfffff
    80004108:	d70080e7          	jalr	-656(ra) # 80002e74 <readi>
    8000410c:	04000793          	li	a5,64
    80004110:	00f51a63          	bne	a0,a5,80004124 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004114:	e5042703          	lw	a4,-432(s0)
    80004118:	464c47b7          	lui	a5,0x464c4
    8000411c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004120:	04f70463          	beq	a4,a5,80004168 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004124:	8552                	mv	a0,s4
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	cfc080e7          	jalr	-772(ra) # 80002e22 <iunlockput>
    end_op();
    8000412e:	fffff097          	auipc	ra,0xfffff
    80004132:	4b2080e7          	jalr	1202(ra) # 800035e0 <end_op>
  }
  return -1;
    80004136:	557d                	li	a0,-1
}
    80004138:	20813083          	ld	ra,520(sp)
    8000413c:	20013403          	ld	s0,512(sp)
    80004140:	74fe                	ld	s1,504(sp)
    80004142:	795e                	ld	s2,496(sp)
    80004144:	79be                	ld	s3,488(sp)
    80004146:	7a1e                	ld	s4,480(sp)
    80004148:	6afe                	ld	s5,472(sp)
    8000414a:	6b5e                	ld	s6,464(sp)
    8000414c:	6bbe                	ld	s7,456(sp)
    8000414e:	6c1e                	ld	s8,448(sp)
    80004150:	7cfa                	ld	s9,440(sp)
    80004152:	7d5a                	ld	s10,432(sp)
    80004154:	7dba                	ld	s11,424(sp)
    80004156:	21010113          	addi	sp,sp,528
    8000415a:	8082                	ret
    end_op();
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	484080e7          	jalr	1156(ra) # 800035e0 <end_op>
    return -1;
    80004164:	557d                	li	a0,-1
    80004166:	bfc9                	j	80004138 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004168:	8526                	mv	a0,s1
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	dac080e7          	jalr	-596(ra) # 80000f16 <proc_pagetable>
    80004172:	8b2a                	mv	s6,a0
    80004174:	d945                	beqz	a0,80004124 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004176:	e7042d03          	lw	s10,-400(s0)
    8000417a:	e8845783          	lhu	a5,-376(s0)
    8000417e:	10078463          	beqz	a5,80004286 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004182:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004184:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004186:	6c85                	lui	s9,0x1
    80004188:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000418c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004190:	6a85                	lui	s5,0x1
    80004192:	a0b5                	j	800041fe <exec+0x15e>
      panic("loadseg: address should exist");
    80004194:	00004517          	auipc	a0,0x4
    80004198:	4cc50513          	addi	a0,a0,1228 # 80008660 <syscalls+0x290>
    8000419c:	00002097          	auipc	ra,0x2
    800041a0:	b04080e7          	jalr	-1276(ra) # 80005ca0 <panic>
    if(sz - i < PGSIZE)
    800041a4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a6:	8726                	mv	a4,s1
    800041a8:	012c06bb          	addw	a3,s8,s2
    800041ac:	4581                	li	a1,0
    800041ae:	8552                	mv	a0,s4
    800041b0:	fffff097          	auipc	ra,0xfffff
    800041b4:	cc4080e7          	jalr	-828(ra) # 80002e74 <readi>
    800041b8:	2501                	sext.w	a0,a0
    800041ba:	24a49863          	bne	s1,a0,8000440a <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800041be:	012a893b          	addw	s2,s5,s2
    800041c2:	03397563          	bgeu	s2,s3,800041ec <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800041c6:	02091593          	slli	a1,s2,0x20
    800041ca:	9181                	srli	a1,a1,0x20
    800041cc:	95de                	add	a1,a1,s7
    800041ce:	855a                	mv	a0,s6
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	332080e7          	jalr	818(ra) # 80000502 <walkaddr>
    800041d8:	862a                	mv	a2,a0
    if(pa == 0)
    800041da:	dd4d                	beqz	a0,80004194 <exec+0xf4>
    if(sz - i < PGSIZE)
    800041dc:	412984bb          	subw	s1,s3,s2
    800041e0:	0004879b          	sext.w	a5,s1
    800041e4:	fcfcf0e3          	bgeu	s9,a5,800041a4 <exec+0x104>
    800041e8:	84d6                	mv	s1,s5
    800041ea:	bf6d                	j	800041a4 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041ec:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f0:	2d85                	addiw	s11,s11,1
    800041f2:	038d0d1b          	addiw	s10,s10,56
    800041f6:	e8845783          	lhu	a5,-376(s0)
    800041fa:	08fdd763          	bge	s11,a5,80004288 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041fe:	2d01                	sext.w	s10,s10
    80004200:	03800713          	li	a4,56
    80004204:	86ea                	mv	a3,s10
    80004206:	e1840613          	addi	a2,s0,-488
    8000420a:	4581                	li	a1,0
    8000420c:	8552                	mv	a0,s4
    8000420e:	fffff097          	auipc	ra,0xfffff
    80004212:	c66080e7          	jalr	-922(ra) # 80002e74 <readi>
    80004216:	03800793          	li	a5,56
    8000421a:	1ef51663          	bne	a0,a5,80004406 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000421e:	e1842783          	lw	a5,-488(s0)
    80004222:	4705                	li	a4,1
    80004224:	fce796e3          	bne	a5,a4,800041f0 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004228:	e4043483          	ld	s1,-448(s0)
    8000422c:	e3843783          	ld	a5,-456(s0)
    80004230:	1ef4e863          	bltu	s1,a5,80004420 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004234:	e2843783          	ld	a5,-472(s0)
    80004238:	94be                	add	s1,s1,a5
    8000423a:	1ef4e663          	bltu	s1,a5,80004426 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    8000423e:	df043703          	ld	a4,-528(s0)
    80004242:	8ff9                	and	a5,a5,a4
    80004244:	1e079463          	bnez	a5,8000442c <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004248:	e1c42503          	lw	a0,-484(s0)
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	e3a080e7          	jalr	-454(ra) # 80004086 <flags2perm>
    80004254:	86aa                	mv	a3,a0
    80004256:	8626                	mv	a2,s1
    80004258:	85ca                	mv	a1,s2
    8000425a:	855a                	mv	a0,s6
    8000425c:	ffffc097          	auipc	ra,0xffffc
    80004260:	65a080e7          	jalr	1626(ra) # 800008b6 <uvmalloc>
    80004264:	e0a43423          	sd	a0,-504(s0)
    80004268:	1c050563          	beqz	a0,80004432 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000426c:	e2843b83          	ld	s7,-472(s0)
    80004270:	e2042c03          	lw	s8,-480(s0)
    80004274:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004278:	00098463          	beqz	s3,80004280 <exec+0x1e0>
    8000427c:	4901                	li	s2,0
    8000427e:	b7a1                	j	800041c6 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004280:	e0843903          	ld	s2,-504(s0)
    80004284:	b7b5                	j	800041f0 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004286:	4901                	li	s2,0
  iunlockput(ip);
    80004288:	8552                	mv	a0,s4
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	b98080e7          	jalr	-1128(ra) # 80002e22 <iunlockput>
  end_op();
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	34e080e7          	jalr	846(ra) # 800035e0 <end_op>
  p = myproc();
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	bb8080e7          	jalr	-1096(ra) # 80000e52 <myproc>
    800042a2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042a4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800042a8:	6985                	lui	s3,0x1
    800042aa:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042ac:	99ca                	add	s3,s3,s2
    800042ae:	77fd                	lui	a5,0xfffff
    800042b0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042b4:	4691                	li	a3,4
    800042b6:	6609                	lui	a2,0x2
    800042b8:	964e                	add	a2,a2,s3
    800042ba:	85ce                	mv	a1,s3
    800042bc:	855a                	mv	a0,s6
    800042be:	ffffc097          	auipc	ra,0xffffc
    800042c2:	5f8080e7          	jalr	1528(ra) # 800008b6 <uvmalloc>
    800042c6:	892a                	mv	s2,a0
    800042c8:	e0a43423          	sd	a0,-504(s0)
    800042cc:	e509                	bnez	a0,800042d6 <exec+0x236>
  if(pagetable)
    800042ce:	e1343423          	sd	s3,-504(s0)
    800042d2:	4a01                	li	s4,0
    800042d4:	aa1d                	j	8000440a <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042d6:	75f9                	lui	a1,0xffffe
    800042d8:	95aa                	add	a1,a1,a0
    800042da:	855a                	mv	a0,s6
    800042dc:	ffffd097          	auipc	ra,0xffffd
    800042e0:	804080e7          	jalr	-2044(ra) # 80000ae0 <uvmclear>
  stackbase = sp - PGSIZE;
    800042e4:	7bfd                	lui	s7,0xfffff
    800042e6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800042e8:	e0043783          	ld	a5,-512(s0)
    800042ec:	6388                	ld	a0,0(a5)
    800042ee:	c52d                	beqz	a0,80004358 <exec+0x2b8>
    800042f0:	e9040993          	addi	s3,s0,-368
    800042f4:	f9040c13          	addi	s8,s0,-112
    800042f8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042fa:	ffffc097          	auipc	ra,0xffffc
    800042fe:	ffa080e7          	jalr	-6(ra) # 800002f4 <strlen>
    80004302:	0015079b          	addiw	a5,a0,1
    80004306:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000430a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000430e:	13796563          	bltu	s2,s7,80004438 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004312:	e0043d03          	ld	s10,-512(s0)
    80004316:	000d3a03          	ld	s4,0(s10)
    8000431a:	8552                	mv	a0,s4
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	fd8080e7          	jalr	-40(ra) # 800002f4 <strlen>
    80004324:	0015069b          	addiw	a3,a0,1
    80004328:	8652                	mv	a2,s4
    8000432a:	85ca                	mv	a1,s2
    8000432c:	855a                	mv	a0,s6
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	7e4080e7          	jalr	2020(ra) # 80000b12 <copyout>
    80004336:	10054363          	bltz	a0,8000443c <exec+0x39c>
    ustack[argc] = sp;
    8000433a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000433e:	0485                	addi	s1,s1,1
    80004340:	008d0793          	addi	a5,s10,8
    80004344:	e0f43023          	sd	a5,-512(s0)
    80004348:	008d3503          	ld	a0,8(s10)
    8000434c:	c909                	beqz	a0,8000435e <exec+0x2be>
    if(argc >= MAXARG)
    8000434e:	09a1                	addi	s3,s3,8
    80004350:	fb8995e3          	bne	s3,s8,800042fa <exec+0x25a>
  ip = 0;
    80004354:	4a01                	li	s4,0
    80004356:	a855                	j	8000440a <exec+0x36a>
  sp = sz;
    80004358:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000435c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000435e:	00349793          	slli	a5,s1,0x3
    80004362:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdce10>
    80004366:	97a2                	add	a5,a5,s0
    80004368:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000436c:	00148693          	addi	a3,s1,1
    80004370:	068e                	slli	a3,a3,0x3
    80004372:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004376:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000437a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000437e:	f57968e3          	bltu	s2,s7,800042ce <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004382:	e9040613          	addi	a2,s0,-368
    80004386:	85ca                	mv	a1,s2
    80004388:	855a                	mv	a0,s6
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	788080e7          	jalr	1928(ra) # 80000b12 <copyout>
    80004392:	0a054763          	bltz	a0,80004440 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004396:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000439a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000439e:	df843783          	ld	a5,-520(s0)
    800043a2:	0007c703          	lbu	a4,0(a5)
    800043a6:	cf11                	beqz	a4,800043c2 <exec+0x322>
    800043a8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043aa:	02f00693          	li	a3,47
    800043ae:	a039                	j	800043bc <exec+0x31c>
      last = s+1;
    800043b0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043b4:	0785                	addi	a5,a5,1
    800043b6:	fff7c703          	lbu	a4,-1(a5)
    800043ba:	c701                	beqz	a4,800043c2 <exec+0x322>
    if(*s == '/')
    800043bc:	fed71ce3          	bne	a4,a3,800043b4 <exec+0x314>
    800043c0:	bfc5                	j	800043b0 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800043c2:	4641                	li	a2,16
    800043c4:	df843583          	ld	a1,-520(s0)
    800043c8:	158a8513          	addi	a0,s5,344
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	ef6080e7          	jalr	-266(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043d4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043d8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043dc:	e0843783          	ld	a5,-504(s0)
    800043e0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043e4:	058ab783          	ld	a5,88(s5)
    800043e8:	e6843703          	ld	a4,-408(s0)
    800043ec:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043ee:	058ab783          	ld	a5,88(s5)
    800043f2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043f6:	85e6                	mv	a1,s9
    800043f8:	ffffd097          	auipc	ra,0xffffd
    800043fc:	bba080e7          	jalr	-1094(ra) # 80000fb2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004400:	0004851b          	sext.w	a0,s1
    80004404:	bb15                	j	80004138 <exec+0x98>
    80004406:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000440a:	e0843583          	ld	a1,-504(s0)
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	ba2080e7          	jalr	-1118(ra) # 80000fb2 <proc_freepagetable>
  return -1;
    80004418:	557d                	li	a0,-1
  if(ip){
    8000441a:	d00a0fe3          	beqz	s4,80004138 <exec+0x98>
    8000441e:	b319                	j	80004124 <exec+0x84>
    80004420:	e1243423          	sd	s2,-504(s0)
    80004424:	b7dd                	j	8000440a <exec+0x36a>
    80004426:	e1243423          	sd	s2,-504(s0)
    8000442a:	b7c5                	j	8000440a <exec+0x36a>
    8000442c:	e1243423          	sd	s2,-504(s0)
    80004430:	bfe9                	j	8000440a <exec+0x36a>
    80004432:	e1243423          	sd	s2,-504(s0)
    80004436:	bfd1                	j	8000440a <exec+0x36a>
  ip = 0;
    80004438:	4a01                	li	s4,0
    8000443a:	bfc1                	j	8000440a <exec+0x36a>
    8000443c:	4a01                	li	s4,0
  if(pagetable)
    8000443e:	b7f1                	j	8000440a <exec+0x36a>
  sz = sz1;
    80004440:	e0843983          	ld	s3,-504(s0)
    80004444:	b569                	j	800042ce <exec+0x22e>

0000000080004446 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004446:	7179                	addi	sp,sp,-48
    80004448:	f406                	sd	ra,40(sp)
    8000444a:	f022                	sd	s0,32(sp)
    8000444c:	ec26                	sd	s1,24(sp)
    8000444e:	e84a                	sd	s2,16(sp)
    80004450:	1800                	addi	s0,sp,48
    80004452:	892e                	mv	s2,a1
    80004454:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004456:	fdc40593          	addi	a1,s0,-36
    8000445a:	ffffe097          	auipc	ra,0xffffe
    8000445e:	b90080e7          	jalr	-1136(ra) # 80001fea <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004462:	fdc42703          	lw	a4,-36(s0)
    80004466:	47bd                	li	a5,15
    80004468:	02e7eb63          	bltu	a5,a4,8000449e <argfd+0x58>
    8000446c:	ffffd097          	auipc	ra,0xffffd
    80004470:	9e6080e7          	jalr	-1562(ra) # 80000e52 <myproc>
    80004474:	fdc42703          	lw	a4,-36(s0)
    80004478:	01a70793          	addi	a5,a4,26
    8000447c:	078e                	slli	a5,a5,0x3
    8000447e:	953e                	add	a0,a0,a5
    80004480:	611c                	ld	a5,0(a0)
    80004482:	c385                	beqz	a5,800044a2 <argfd+0x5c>
    return -1;
  if(pfd)
    80004484:	00090463          	beqz	s2,8000448c <argfd+0x46>
    *pfd = fd;
    80004488:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000448c:	4501                	li	a0,0
  if(pf)
    8000448e:	c091                	beqz	s1,80004492 <argfd+0x4c>
    *pf = f;
    80004490:	e09c                	sd	a5,0(s1)
}
    80004492:	70a2                	ld	ra,40(sp)
    80004494:	7402                	ld	s0,32(sp)
    80004496:	64e2                	ld	s1,24(sp)
    80004498:	6942                	ld	s2,16(sp)
    8000449a:	6145                	addi	sp,sp,48
    8000449c:	8082                	ret
    return -1;
    8000449e:	557d                	li	a0,-1
    800044a0:	bfcd                	j	80004492 <argfd+0x4c>
    800044a2:	557d                	li	a0,-1
    800044a4:	b7fd                	j	80004492 <argfd+0x4c>

00000000800044a6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044a6:	1101                	addi	sp,sp,-32
    800044a8:	ec06                	sd	ra,24(sp)
    800044aa:	e822                	sd	s0,16(sp)
    800044ac:	e426                	sd	s1,8(sp)
    800044ae:	1000                	addi	s0,sp,32
    800044b0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044b2:	ffffd097          	auipc	ra,0xffffd
    800044b6:	9a0080e7          	jalr	-1632(ra) # 80000e52 <myproc>
    800044ba:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044bc:	0d050793          	addi	a5,a0,208
    800044c0:	4501                	li	a0,0
    800044c2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044c4:	6398                	ld	a4,0(a5)
    800044c6:	cb19                	beqz	a4,800044dc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044c8:	2505                	addiw	a0,a0,1
    800044ca:	07a1                	addi	a5,a5,8
    800044cc:	fed51ce3          	bne	a0,a3,800044c4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044d0:	557d                	li	a0,-1
}
    800044d2:	60e2                	ld	ra,24(sp)
    800044d4:	6442                	ld	s0,16(sp)
    800044d6:	64a2                	ld	s1,8(sp)
    800044d8:	6105                	addi	sp,sp,32
    800044da:	8082                	ret
      p->ofile[fd] = f;
    800044dc:	01a50793          	addi	a5,a0,26
    800044e0:	078e                	slli	a5,a5,0x3
    800044e2:	963e                	add	a2,a2,a5
    800044e4:	e204                	sd	s1,0(a2)
      return fd;
    800044e6:	b7f5                	j	800044d2 <fdalloc+0x2c>

00000000800044e8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044e8:	715d                	addi	sp,sp,-80
    800044ea:	e486                	sd	ra,72(sp)
    800044ec:	e0a2                	sd	s0,64(sp)
    800044ee:	fc26                	sd	s1,56(sp)
    800044f0:	f84a                	sd	s2,48(sp)
    800044f2:	f44e                	sd	s3,40(sp)
    800044f4:	f052                	sd	s4,32(sp)
    800044f6:	ec56                	sd	s5,24(sp)
    800044f8:	e85a                	sd	s6,16(sp)
    800044fa:	0880                	addi	s0,sp,80
    800044fc:	8b2e                	mv	s6,a1
    800044fe:	89b2                	mv	s3,a2
    80004500:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004502:	fb040593          	addi	a1,s0,-80
    80004506:	fffff097          	auipc	ra,0xfffff
    8000450a:	e7e080e7          	jalr	-386(ra) # 80003384 <nameiparent>
    8000450e:	84aa                	mv	s1,a0
    80004510:	14050b63          	beqz	a0,80004666 <create+0x17e>
    return 0;

  ilock(dp);
    80004514:	ffffe097          	auipc	ra,0xffffe
    80004518:	6ac080e7          	jalr	1708(ra) # 80002bc0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000451c:	4601                	li	a2,0
    8000451e:	fb040593          	addi	a1,s0,-80
    80004522:	8526                	mv	a0,s1
    80004524:	fffff097          	auipc	ra,0xfffff
    80004528:	b80080e7          	jalr	-1152(ra) # 800030a4 <dirlookup>
    8000452c:	8aaa                	mv	s5,a0
    8000452e:	c921                	beqz	a0,8000457e <create+0x96>
    iunlockput(dp);
    80004530:	8526                	mv	a0,s1
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	8f0080e7          	jalr	-1808(ra) # 80002e22 <iunlockput>
    ilock(ip);
    8000453a:	8556                	mv	a0,s5
    8000453c:	ffffe097          	auipc	ra,0xffffe
    80004540:	684080e7          	jalr	1668(ra) # 80002bc0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004544:	4789                	li	a5,2
    80004546:	02fb1563          	bne	s6,a5,80004570 <create+0x88>
    8000454a:	044ad783          	lhu	a5,68(s5)
    8000454e:	37f9                	addiw	a5,a5,-2
    80004550:	17c2                	slli	a5,a5,0x30
    80004552:	93c1                	srli	a5,a5,0x30
    80004554:	4705                	li	a4,1
    80004556:	00f76d63          	bltu	a4,a5,80004570 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000455a:	8556                	mv	a0,s5
    8000455c:	60a6                	ld	ra,72(sp)
    8000455e:	6406                	ld	s0,64(sp)
    80004560:	74e2                	ld	s1,56(sp)
    80004562:	7942                	ld	s2,48(sp)
    80004564:	79a2                	ld	s3,40(sp)
    80004566:	7a02                	ld	s4,32(sp)
    80004568:	6ae2                	ld	s5,24(sp)
    8000456a:	6b42                	ld	s6,16(sp)
    8000456c:	6161                	addi	sp,sp,80
    8000456e:	8082                	ret
    iunlockput(ip);
    80004570:	8556                	mv	a0,s5
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	8b0080e7          	jalr	-1872(ra) # 80002e22 <iunlockput>
    return 0;
    8000457a:	4a81                	li	s5,0
    8000457c:	bff9                	j	8000455a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000457e:	85da                	mv	a1,s6
    80004580:	4088                	lw	a0,0(s1)
    80004582:	ffffe097          	auipc	ra,0xffffe
    80004586:	4a6080e7          	jalr	1190(ra) # 80002a28 <ialloc>
    8000458a:	8a2a                	mv	s4,a0
    8000458c:	c529                	beqz	a0,800045d6 <create+0xee>
  ilock(ip);
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	632080e7          	jalr	1586(ra) # 80002bc0 <ilock>
  ip->major = major;
    80004596:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000459a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000459e:	4905                	li	s2,1
    800045a0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045a4:	8552                	mv	a0,s4
    800045a6:	ffffe097          	auipc	ra,0xffffe
    800045aa:	54e080e7          	jalr	1358(ra) # 80002af4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ae:	032b0b63          	beq	s6,s2,800045e4 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045b2:	004a2603          	lw	a2,4(s4)
    800045b6:	fb040593          	addi	a1,s0,-80
    800045ba:	8526                	mv	a0,s1
    800045bc:	fffff097          	auipc	ra,0xfffff
    800045c0:	cf8080e7          	jalr	-776(ra) # 800032b4 <dirlink>
    800045c4:	06054f63          	bltz	a0,80004642 <create+0x15a>
  iunlockput(dp);
    800045c8:	8526                	mv	a0,s1
    800045ca:	fffff097          	auipc	ra,0xfffff
    800045ce:	858080e7          	jalr	-1960(ra) # 80002e22 <iunlockput>
  return ip;
    800045d2:	8ad2                	mv	s5,s4
    800045d4:	b759                	j	8000455a <create+0x72>
    iunlockput(dp);
    800045d6:	8526                	mv	a0,s1
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	84a080e7          	jalr	-1974(ra) # 80002e22 <iunlockput>
    return 0;
    800045e0:	8ad2                	mv	s5,s4
    800045e2:	bfa5                	j	8000455a <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e4:	004a2603          	lw	a2,4(s4)
    800045e8:	00004597          	auipc	a1,0x4
    800045ec:	09858593          	addi	a1,a1,152 # 80008680 <syscalls+0x2b0>
    800045f0:	8552                	mv	a0,s4
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	cc2080e7          	jalr	-830(ra) # 800032b4 <dirlink>
    800045fa:	04054463          	bltz	a0,80004642 <create+0x15a>
    800045fe:	40d0                	lw	a2,4(s1)
    80004600:	00004597          	auipc	a1,0x4
    80004604:	08858593          	addi	a1,a1,136 # 80008688 <syscalls+0x2b8>
    80004608:	8552                	mv	a0,s4
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	caa080e7          	jalr	-854(ra) # 800032b4 <dirlink>
    80004612:	02054863          	bltz	a0,80004642 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004616:	004a2603          	lw	a2,4(s4)
    8000461a:	fb040593          	addi	a1,s0,-80
    8000461e:	8526                	mv	a0,s1
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	c94080e7          	jalr	-876(ra) # 800032b4 <dirlink>
    80004628:	00054d63          	bltz	a0,80004642 <create+0x15a>
    dp->nlink++;  // for ".."
    8000462c:	04a4d783          	lhu	a5,74(s1)
    80004630:	2785                	addiw	a5,a5,1
    80004632:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004636:	8526                	mv	a0,s1
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	4bc080e7          	jalr	1212(ra) # 80002af4 <iupdate>
    80004640:	b761                	j	800045c8 <create+0xe0>
  ip->nlink = 0;
    80004642:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004646:	8552                	mv	a0,s4
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	4ac080e7          	jalr	1196(ra) # 80002af4 <iupdate>
  iunlockput(ip);
    80004650:	8552                	mv	a0,s4
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	7d0080e7          	jalr	2000(ra) # 80002e22 <iunlockput>
  iunlockput(dp);
    8000465a:	8526                	mv	a0,s1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	7c6080e7          	jalr	1990(ra) # 80002e22 <iunlockput>
  return 0;
    80004664:	bddd                	j	8000455a <create+0x72>
    return 0;
    80004666:	8aaa                	mv	s5,a0
    80004668:	bdcd                	j	8000455a <create+0x72>

000000008000466a <sys_dup>:
{
    8000466a:	7179                	addi	sp,sp,-48
    8000466c:	f406                	sd	ra,40(sp)
    8000466e:	f022                	sd	s0,32(sp)
    80004670:	ec26                	sd	s1,24(sp)
    80004672:	e84a                	sd	s2,16(sp)
    80004674:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004676:	fd840613          	addi	a2,s0,-40
    8000467a:	4581                	li	a1,0
    8000467c:	4501                	li	a0,0
    8000467e:	00000097          	auipc	ra,0x0
    80004682:	dc8080e7          	jalr	-568(ra) # 80004446 <argfd>
    return -1;
    80004686:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004688:	02054363          	bltz	a0,800046ae <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000468c:	fd843903          	ld	s2,-40(s0)
    80004690:	854a                	mv	a0,s2
    80004692:	00000097          	auipc	ra,0x0
    80004696:	e14080e7          	jalr	-492(ra) # 800044a6 <fdalloc>
    8000469a:	84aa                	mv	s1,a0
    return -1;
    8000469c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000469e:	00054863          	bltz	a0,800046ae <sys_dup+0x44>
  filedup(f);
    800046a2:	854a                	mv	a0,s2
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	334080e7          	jalr	820(ra) # 800039d8 <filedup>
  return fd;
    800046ac:	87a6                	mv	a5,s1
}
    800046ae:	853e                	mv	a0,a5
    800046b0:	70a2                	ld	ra,40(sp)
    800046b2:	7402                	ld	s0,32(sp)
    800046b4:	64e2                	ld	s1,24(sp)
    800046b6:	6942                	ld	s2,16(sp)
    800046b8:	6145                	addi	sp,sp,48
    800046ba:	8082                	ret

00000000800046bc <sys_read>:
{
    800046bc:	7179                	addi	sp,sp,-48
    800046be:	f406                	sd	ra,40(sp)
    800046c0:	f022                	sd	s0,32(sp)
    800046c2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046c4:	fd840593          	addi	a1,s0,-40
    800046c8:	4505                	li	a0,1
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	940080e7          	jalr	-1728(ra) # 8000200a <argaddr>
  argint(2, &n);
    800046d2:	fe440593          	addi	a1,s0,-28
    800046d6:	4509                	li	a0,2
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	912080e7          	jalr	-1774(ra) # 80001fea <argint>
  if(argfd(0, 0, &f) < 0)
    800046e0:	fe840613          	addi	a2,s0,-24
    800046e4:	4581                	li	a1,0
    800046e6:	4501                	li	a0,0
    800046e8:	00000097          	auipc	ra,0x0
    800046ec:	d5e080e7          	jalr	-674(ra) # 80004446 <argfd>
    800046f0:	87aa                	mv	a5,a0
    return -1;
    800046f2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046f4:	0007cc63          	bltz	a5,8000470c <sys_read+0x50>
  return fileread(f, p, n);
    800046f8:	fe442603          	lw	a2,-28(s0)
    800046fc:	fd843583          	ld	a1,-40(s0)
    80004700:	fe843503          	ld	a0,-24(s0)
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	460080e7          	jalr	1120(ra) # 80003b64 <fileread>
}
    8000470c:	70a2                	ld	ra,40(sp)
    8000470e:	7402                	ld	s0,32(sp)
    80004710:	6145                	addi	sp,sp,48
    80004712:	8082                	ret

0000000080004714 <sys_write>:
{
    80004714:	7179                	addi	sp,sp,-48
    80004716:	f406                	sd	ra,40(sp)
    80004718:	f022                	sd	s0,32(sp)
    8000471a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000471c:	fd840593          	addi	a1,s0,-40
    80004720:	4505                	li	a0,1
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	8e8080e7          	jalr	-1816(ra) # 8000200a <argaddr>
  argint(2, &n);
    8000472a:	fe440593          	addi	a1,s0,-28
    8000472e:	4509                	li	a0,2
    80004730:	ffffe097          	auipc	ra,0xffffe
    80004734:	8ba080e7          	jalr	-1862(ra) # 80001fea <argint>
  if(argfd(0, 0, &f) < 0)
    80004738:	fe840613          	addi	a2,s0,-24
    8000473c:	4581                	li	a1,0
    8000473e:	4501                	li	a0,0
    80004740:	00000097          	auipc	ra,0x0
    80004744:	d06080e7          	jalr	-762(ra) # 80004446 <argfd>
    80004748:	87aa                	mv	a5,a0
    return -1;
    8000474a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000474c:	0007cc63          	bltz	a5,80004764 <sys_write+0x50>
  return filewrite(f, p, n);
    80004750:	fe442603          	lw	a2,-28(s0)
    80004754:	fd843583          	ld	a1,-40(s0)
    80004758:	fe843503          	ld	a0,-24(s0)
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	4ca080e7          	jalr	1226(ra) # 80003c26 <filewrite>
}
    80004764:	70a2                	ld	ra,40(sp)
    80004766:	7402                	ld	s0,32(sp)
    80004768:	6145                	addi	sp,sp,48
    8000476a:	8082                	ret

000000008000476c <sys_close>:
{
    8000476c:	1101                	addi	sp,sp,-32
    8000476e:	ec06                	sd	ra,24(sp)
    80004770:	e822                	sd	s0,16(sp)
    80004772:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004774:	fe040613          	addi	a2,s0,-32
    80004778:	fec40593          	addi	a1,s0,-20
    8000477c:	4501                	li	a0,0
    8000477e:	00000097          	auipc	ra,0x0
    80004782:	cc8080e7          	jalr	-824(ra) # 80004446 <argfd>
    return -1;
    80004786:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004788:	02054463          	bltz	a0,800047b0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000478c:	ffffc097          	auipc	ra,0xffffc
    80004790:	6c6080e7          	jalr	1734(ra) # 80000e52 <myproc>
    80004794:	fec42783          	lw	a5,-20(s0)
    80004798:	07e9                	addi	a5,a5,26
    8000479a:	078e                	slli	a5,a5,0x3
    8000479c:	953e                	add	a0,a0,a5
    8000479e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047a2:	fe043503          	ld	a0,-32(s0)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	284080e7          	jalr	644(ra) # 80003a2a <fileclose>
  return 0;
    800047ae:	4781                	li	a5,0
}
    800047b0:	853e                	mv	a0,a5
    800047b2:	60e2                	ld	ra,24(sp)
    800047b4:	6442                	ld	s0,16(sp)
    800047b6:	6105                	addi	sp,sp,32
    800047b8:	8082                	ret

00000000800047ba <sys_fstat>:
{
    800047ba:	1101                	addi	sp,sp,-32
    800047bc:	ec06                	sd	ra,24(sp)
    800047be:	e822                	sd	s0,16(sp)
    800047c0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800047c2:	fe040593          	addi	a1,s0,-32
    800047c6:	4505                	li	a0,1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	842080e7          	jalr	-1982(ra) # 8000200a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047d0:	fe840613          	addi	a2,s0,-24
    800047d4:	4581                	li	a1,0
    800047d6:	4501                	li	a0,0
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	c6e080e7          	jalr	-914(ra) # 80004446 <argfd>
    800047e0:	87aa                	mv	a5,a0
    return -1;
    800047e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047e4:	0007ca63          	bltz	a5,800047f8 <sys_fstat+0x3e>
  return filestat(f, st);
    800047e8:	fe043583          	ld	a1,-32(s0)
    800047ec:	fe843503          	ld	a0,-24(s0)
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	302080e7          	jalr	770(ra) # 80003af2 <filestat>
}
    800047f8:	60e2                	ld	ra,24(sp)
    800047fa:	6442                	ld	s0,16(sp)
    800047fc:	6105                	addi	sp,sp,32
    800047fe:	8082                	ret

0000000080004800 <sys_link>:
{
    80004800:	7169                	addi	sp,sp,-304
    80004802:	f606                	sd	ra,296(sp)
    80004804:	f222                	sd	s0,288(sp)
    80004806:	ee26                	sd	s1,280(sp)
    80004808:	ea4a                	sd	s2,272(sp)
    8000480a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000480c:	08000613          	li	a2,128
    80004810:	ed040593          	addi	a1,s0,-304
    80004814:	4501                	li	a0,0
    80004816:	ffffe097          	auipc	ra,0xffffe
    8000481a:	814080e7          	jalr	-2028(ra) # 8000202a <argstr>
    return -1;
    8000481e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004820:	10054e63          	bltz	a0,8000493c <sys_link+0x13c>
    80004824:	08000613          	li	a2,128
    80004828:	f5040593          	addi	a1,s0,-176
    8000482c:	4505                	li	a0,1
    8000482e:	ffffd097          	auipc	ra,0xffffd
    80004832:	7fc080e7          	jalr	2044(ra) # 8000202a <argstr>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004838:	10054263          	bltz	a0,8000493c <sys_link+0x13c>
  begin_op();
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	d2a080e7          	jalr	-726(ra) # 80003566 <begin_op>
  if((ip = namei(old)) == 0){
    80004844:	ed040513          	addi	a0,s0,-304
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	b1e080e7          	jalr	-1250(ra) # 80003366 <namei>
    80004850:	84aa                	mv	s1,a0
    80004852:	c551                	beqz	a0,800048de <sys_link+0xde>
  ilock(ip);
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	36c080e7          	jalr	876(ra) # 80002bc0 <ilock>
  if(ip->type == T_DIR){
    8000485c:	04449703          	lh	a4,68(s1)
    80004860:	4785                	li	a5,1
    80004862:	08f70463          	beq	a4,a5,800048ea <sys_link+0xea>
  ip->nlink++;
    80004866:	04a4d783          	lhu	a5,74(s1)
    8000486a:	2785                	addiw	a5,a5,1
    8000486c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004870:	8526                	mv	a0,s1
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	282080e7          	jalr	642(ra) # 80002af4 <iupdate>
  iunlock(ip);
    8000487a:	8526                	mv	a0,s1
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	406080e7          	jalr	1030(ra) # 80002c82 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004884:	fd040593          	addi	a1,s0,-48
    80004888:	f5040513          	addi	a0,s0,-176
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	af8080e7          	jalr	-1288(ra) # 80003384 <nameiparent>
    80004894:	892a                	mv	s2,a0
    80004896:	c935                	beqz	a0,8000490a <sys_link+0x10a>
  ilock(dp);
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	328080e7          	jalr	808(ra) # 80002bc0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048a0:	00092703          	lw	a4,0(s2)
    800048a4:	409c                	lw	a5,0(s1)
    800048a6:	04f71d63          	bne	a4,a5,80004900 <sys_link+0x100>
    800048aa:	40d0                	lw	a2,4(s1)
    800048ac:	fd040593          	addi	a1,s0,-48
    800048b0:	854a                	mv	a0,s2
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	a02080e7          	jalr	-1534(ra) # 800032b4 <dirlink>
    800048ba:	04054363          	bltz	a0,80004900 <sys_link+0x100>
  iunlockput(dp);
    800048be:	854a                	mv	a0,s2
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	562080e7          	jalr	1378(ra) # 80002e22 <iunlockput>
  iput(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	4b0080e7          	jalr	1200(ra) # 80002d7a <iput>
  end_op();
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	d0e080e7          	jalr	-754(ra) # 800035e0 <end_op>
  return 0;
    800048da:	4781                	li	a5,0
    800048dc:	a085                	j	8000493c <sys_link+0x13c>
    end_op();
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	d02080e7          	jalr	-766(ra) # 800035e0 <end_op>
    return -1;
    800048e6:	57fd                	li	a5,-1
    800048e8:	a891                	j	8000493c <sys_link+0x13c>
    iunlockput(ip);
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	536080e7          	jalr	1334(ra) # 80002e22 <iunlockput>
    end_op();
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	cec080e7          	jalr	-788(ra) # 800035e0 <end_op>
    return -1;
    800048fc:	57fd                	li	a5,-1
    800048fe:	a83d                	j	8000493c <sys_link+0x13c>
    iunlockput(dp);
    80004900:	854a                	mv	a0,s2
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	520080e7          	jalr	1312(ra) # 80002e22 <iunlockput>
  ilock(ip);
    8000490a:	8526                	mv	a0,s1
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	2b4080e7          	jalr	692(ra) # 80002bc0 <ilock>
  ip->nlink--;
    80004914:	04a4d783          	lhu	a5,74(s1)
    80004918:	37fd                	addiw	a5,a5,-1
    8000491a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000491e:	8526                	mv	a0,s1
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	1d4080e7          	jalr	468(ra) # 80002af4 <iupdate>
  iunlockput(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	4f8080e7          	jalr	1272(ra) # 80002e22 <iunlockput>
  end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	cae080e7          	jalr	-850(ra) # 800035e0 <end_op>
  return -1;
    8000493a:	57fd                	li	a5,-1
}
    8000493c:	853e                	mv	a0,a5
    8000493e:	70b2                	ld	ra,296(sp)
    80004940:	7412                	ld	s0,288(sp)
    80004942:	64f2                	ld	s1,280(sp)
    80004944:	6952                	ld	s2,272(sp)
    80004946:	6155                	addi	sp,sp,304
    80004948:	8082                	ret

000000008000494a <sys_unlink>:
{
    8000494a:	7151                	addi	sp,sp,-240
    8000494c:	f586                	sd	ra,232(sp)
    8000494e:	f1a2                	sd	s0,224(sp)
    80004950:	eda6                	sd	s1,216(sp)
    80004952:	e9ca                	sd	s2,208(sp)
    80004954:	e5ce                	sd	s3,200(sp)
    80004956:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004958:	08000613          	li	a2,128
    8000495c:	f3040593          	addi	a1,s0,-208
    80004960:	4501                	li	a0,0
    80004962:	ffffd097          	auipc	ra,0xffffd
    80004966:	6c8080e7          	jalr	1736(ra) # 8000202a <argstr>
    8000496a:	18054163          	bltz	a0,80004aec <sys_unlink+0x1a2>
  begin_op();
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	bf8080e7          	jalr	-1032(ra) # 80003566 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004976:	fb040593          	addi	a1,s0,-80
    8000497a:	f3040513          	addi	a0,s0,-208
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	a06080e7          	jalr	-1530(ra) # 80003384 <nameiparent>
    80004986:	84aa                	mv	s1,a0
    80004988:	c979                	beqz	a0,80004a5e <sys_unlink+0x114>
  ilock(dp);
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	236080e7          	jalr	566(ra) # 80002bc0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004992:	00004597          	auipc	a1,0x4
    80004996:	cee58593          	addi	a1,a1,-786 # 80008680 <syscalls+0x2b0>
    8000499a:	fb040513          	addi	a0,s0,-80
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	6ec080e7          	jalr	1772(ra) # 8000308a <namecmp>
    800049a6:	14050a63          	beqz	a0,80004afa <sys_unlink+0x1b0>
    800049aa:	00004597          	auipc	a1,0x4
    800049ae:	cde58593          	addi	a1,a1,-802 # 80008688 <syscalls+0x2b8>
    800049b2:	fb040513          	addi	a0,s0,-80
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	6d4080e7          	jalr	1748(ra) # 8000308a <namecmp>
    800049be:	12050e63          	beqz	a0,80004afa <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049c2:	f2c40613          	addi	a2,s0,-212
    800049c6:	fb040593          	addi	a1,s0,-80
    800049ca:	8526                	mv	a0,s1
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	6d8080e7          	jalr	1752(ra) # 800030a4 <dirlookup>
    800049d4:	892a                	mv	s2,a0
    800049d6:	12050263          	beqz	a0,80004afa <sys_unlink+0x1b0>
  ilock(ip);
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	1e6080e7          	jalr	486(ra) # 80002bc0 <ilock>
  if(ip->nlink < 1)
    800049e2:	04a91783          	lh	a5,74(s2)
    800049e6:	08f05263          	blez	a5,80004a6a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049ea:	04491703          	lh	a4,68(s2)
    800049ee:	4785                	li	a5,1
    800049f0:	08f70563          	beq	a4,a5,80004a7a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049f4:	4641                	li	a2,16
    800049f6:	4581                	li	a1,0
    800049f8:	fc040513          	addi	a0,s0,-64
    800049fc:	ffffb097          	auipc	ra,0xffffb
    80004a00:	77e080e7          	jalr	1918(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a04:	4741                	li	a4,16
    80004a06:	f2c42683          	lw	a3,-212(s0)
    80004a0a:	fc040613          	addi	a2,s0,-64
    80004a0e:	4581                	li	a1,0
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	55a080e7          	jalr	1370(ra) # 80002f6c <writei>
    80004a1a:	47c1                	li	a5,16
    80004a1c:	0af51563          	bne	a0,a5,80004ac6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a20:	04491703          	lh	a4,68(s2)
    80004a24:	4785                	li	a5,1
    80004a26:	0af70863          	beq	a4,a5,80004ad6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	3f6080e7          	jalr	1014(ra) # 80002e22 <iunlockput>
  ip->nlink--;
    80004a34:	04a95783          	lhu	a5,74(s2)
    80004a38:	37fd                	addiw	a5,a5,-1
    80004a3a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	0b4080e7          	jalr	180(ra) # 80002af4 <iupdate>
  iunlockput(ip);
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	3d8080e7          	jalr	984(ra) # 80002e22 <iunlockput>
  end_op();
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	b8e080e7          	jalr	-1138(ra) # 800035e0 <end_op>
  return 0;
    80004a5a:	4501                	li	a0,0
    80004a5c:	a84d                	j	80004b0e <sys_unlink+0x1c4>
    end_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	b82080e7          	jalr	-1150(ra) # 800035e0 <end_op>
    return -1;
    80004a66:	557d                	li	a0,-1
    80004a68:	a05d                	j	80004b0e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a6a:	00004517          	auipc	a0,0x4
    80004a6e:	c2650513          	addi	a0,a0,-986 # 80008690 <syscalls+0x2c0>
    80004a72:	00001097          	auipc	ra,0x1
    80004a76:	22e080e7          	jalr	558(ra) # 80005ca0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a7a:	04c92703          	lw	a4,76(s2)
    80004a7e:	02000793          	li	a5,32
    80004a82:	f6e7f9e3          	bgeu	a5,a4,800049f4 <sys_unlink+0xaa>
    80004a86:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a8a:	4741                	li	a4,16
    80004a8c:	86ce                	mv	a3,s3
    80004a8e:	f1840613          	addi	a2,s0,-232
    80004a92:	4581                	li	a1,0
    80004a94:	854a                	mv	a0,s2
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	3de080e7          	jalr	990(ra) # 80002e74 <readi>
    80004a9e:	47c1                	li	a5,16
    80004aa0:	00f51b63          	bne	a0,a5,80004ab6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aa4:	f1845783          	lhu	a5,-232(s0)
    80004aa8:	e7a1                	bnez	a5,80004af0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aaa:	29c1                	addiw	s3,s3,16
    80004aac:	04c92783          	lw	a5,76(s2)
    80004ab0:	fcf9ede3          	bltu	s3,a5,80004a8a <sys_unlink+0x140>
    80004ab4:	b781                	j	800049f4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	bf250513          	addi	a0,a0,-1038 # 800086a8 <syscalls+0x2d8>
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	1e2080e7          	jalr	482(ra) # 80005ca0 <panic>
    panic("unlink: writei");
    80004ac6:	00004517          	auipc	a0,0x4
    80004aca:	bfa50513          	addi	a0,a0,-1030 # 800086c0 <syscalls+0x2f0>
    80004ace:	00001097          	auipc	ra,0x1
    80004ad2:	1d2080e7          	jalr	466(ra) # 80005ca0 <panic>
    dp->nlink--;
    80004ad6:	04a4d783          	lhu	a5,74(s1)
    80004ada:	37fd                	addiw	a5,a5,-1
    80004adc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	012080e7          	jalr	18(ra) # 80002af4 <iupdate>
    80004aea:	b781                	j	80004a2a <sys_unlink+0xe0>
    return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	a005                	j	80004b0e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004af0:	854a                	mv	a0,s2
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	330080e7          	jalr	816(ra) # 80002e22 <iunlockput>
  iunlockput(dp);
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	326080e7          	jalr	806(ra) # 80002e22 <iunlockput>
  end_op();
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	adc080e7          	jalr	-1316(ra) # 800035e0 <end_op>
  return -1;
    80004b0c:	557d                	li	a0,-1
}
    80004b0e:	70ae                	ld	ra,232(sp)
    80004b10:	740e                	ld	s0,224(sp)
    80004b12:	64ee                	ld	s1,216(sp)
    80004b14:	694e                	ld	s2,208(sp)
    80004b16:	69ae                	ld	s3,200(sp)
    80004b18:	616d                	addi	sp,sp,240
    80004b1a:	8082                	ret

0000000080004b1c <sys_open>:

uint64
sys_open(void)
{
    80004b1c:	7131                	addi	sp,sp,-192
    80004b1e:	fd06                	sd	ra,184(sp)
    80004b20:	f922                	sd	s0,176(sp)
    80004b22:	f526                	sd	s1,168(sp)
    80004b24:	f14a                	sd	s2,160(sp)
    80004b26:	ed4e                	sd	s3,152(sp)
    80004b28:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b2a:	f4c40593          	addi	a1,s0,-180
    80004b2e:	4505                	li	a0,1
    80004b30:	ffffd097          	auipc	ra,0xffffd
    80004b34:	4ba080e7          	jalr	1210(ra) # 80001fea <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b38:	08000613          	li	a2,128
    80004b3c:	f5040593          	addi	a1,s0,-176
    80004b40:	4501                	li	a0,0
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	4e8080e7          	jalr	1256(ra) # 8000202a <argstr>
    80004b4a:	87aa                	mv	a5,a0
    return -1;
    80004b4c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b4e:	0a07c863          	bltz	a5,80004bfe <sys_open+0xe2>

  begin_op();
    80004b52:	fffff097          	auipc	ra,0xfffff
    80004b56:	a14080e7          	jalr	-1516(ra) # 80003566 <begin_op>

  if(omode & O_CREATE){
    80004b5a:	f4c42783          	lw	a5,-180(s0)
    80004b5e:	2007f793          	andi	a5,a5,512
    80004b62:	cbdd                	beqz	a5,80004c18 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004b64:	4681                	li	a3,0
    80004b66:	4601                	li	a2,0
    80004b68:	4589                	li	a1,2
    80004b6a:	f5040513          	addi	a0,s0,-176
    80004b6e:	00000097          	auipc	ra,0x0
    80004b72:	97a080e7          	jalr	-1670(ra) # 800044e8 <create>
    80004b76:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b78:	c951                	beqz	a0,80004c0c <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b7a:	04449703          	lh	a4,68(s1)
    80004b7e:	478d                	li	a5,3
    80004b80:	00f71763          	bne	a4,a5,80004b8e <sys_open+0x72>
    80004b84:	0464d703          	lhu	a4,70(s1)
    80004b88:	47a5                	li	a5,9
    80004b8a:	0ce7ec63          	bltu	a5,a4,80004c62 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b8e:	fffff097          	auipc	ra,0xfffff
    80004b92:	de0080e7          	jalr	-544(ra) # 8000396e <filealloc>
    80004b96:	892a                	mv	s2,a0
    80004b98:	c56d                	beqz	a0,80004c82 <sys_open+0x166>
    80004b9a:	00000097          	auipc	ra,0x0
    80004b9e:	90c080e7          	jalr	-1780(ra) # 800044a6 <fdalloc>
    80004ba2:	89aa                	mv	s3,a0
    80004ba4:	0c054a63          	bltz	a0,80004c78 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba8:	04449703          	lh	a4,68(s1)
    80004bac:	478d                	li	a5,3
    80004bae:	0ef70563          	beq	a4,a5,80004c98 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bb2:	4789                	li	a5,2
    80004bb4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004bb8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004bbc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004bc0:	f4c42783          	lw	a5,-180(s0)
    80004bc4:	0017c713          	xori	a4,a5,1
    80004bc8:	8b05                	andi	a4,a4,1
    80004bca:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bce:	0037f713          	andi	a4,a5,3
    80004bd2:	00e03733          	snez	a4,a4
    80004bd6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bda:	4007f793          	andi	a5,a5,1024
    80004bde:	c791                	beqz	a5,80004bea <sys_open+0xce>
    80004be0:	04449703          	lh	a4,68(s1)
    80004be4:	4789                	li	a5,2
    80004be6:	0cf70063          	beq	a4,a5,80004ca6 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	096080e7          	jalr	150(ra) # 80002c82 <iunlock>
  end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	9ec080e7          	jalr	-1556(ra) # 800035e0 <end_op>

  return fd;
    80004bfc:	854e                	mv	a0,s3
}
    80004bfe:	70ea                	ld	ra,184(sp)
    80004c00:	744a                	ld	s0,176(sp)
    80004c02:	74aa                	ld	s1,168(sp)
    80004c04:	790a                	ld	s2,160(sp)
    80004c06:	69ea                	ld	s3,152(sp)
    80004c08:	6129                	addi	sp,sp,192
    80004c0a:	8082                	ret
      end_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	9d4080e7          	jalr	-1580(ra) # 800035e0 <end_op>
      return -1;
    80004c14:	557d                	li	a0,-1
    80004c16:	b7e5                	j	80004bfe <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c18:	f5040513          	addi	a0,s0,-176
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	74a080e7          	jalr	1866(ra) # 80003366 <namei>
    80004c24:	84aa                	mv	s1,a0
    80004c26:	c905                	beqz	a0,80004c56 <sys_open+0x13a>
    ilock(ip);
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	f98080e7          	jalr	-104(ra) # 80002bc0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c30:	04449703          	lh	a4,68(s1)
    80004c34:	4785                	li	a5,1
    80004c36:	f4f712e3          	bne	a4,a5,80004b7a <sys_open+0x5e>
    80004c3a:	f4c42783          	lw	a5,-180(s0)
    80004c3e:	dba1                	beqz	a5,80004b8e <sys_open+0x72>
      iunlockput(ip);
    80004c40:	8526                	mv	a0,s1
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	1e0080e7          	jalr	480(ra) # 80002e22 <iunlockput>
      end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	996080e7          	jalr	-1642(ra) # 800035e0 <end_op>
      return -1;
    80004c52:	557d                	li	a0,-1
    80004c54:	b76d                	j	80004bfe <sys_open+0xe2>
      end_op();
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	98a080e7          	jalr	-1654(ra) # 800035e0 <end_op>
      return -1;
    80004c5e:	557d                	li	a0,-1
    80004c60:	bf79                	j	80004bfe <sys_open+0xe2>
    iunlockput(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	1be080e7          	jalr	446(ra) # 80002e22 <iunlockput>
    end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	974080e7          	jalr	-1676(ra) # 800035e0 <end_op>
    return -1;
    80004c74:	557d                	li	a0,-1
    80004c76:	b761                	j	80004bfe <sys_open+0xe2>
      fileclose(f);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	db0080e7          	jalr	-592(ra) # 80003a2a <fileclose>
    iunlockput(ip);
    80004c82:	8526                	mv	a0,s1
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	19e080e7          	jalr	414(ra) # 80002e22 <iunlockput>
    end_op();
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	954080e7          	jalr	-1708(ra) # 800035e0 <end_op>
    return -1;
    80004c94:	557d                	li	a0,-1
    80004c96:	b7a5                	j	80004bfe <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004c98:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c9c:	04649783          	lh	a5,70(s1)
    80004ca0:	02f91223          	sh	a5,36(s2)
    80004ca4:	bf21                	j	80004bbc <sys_open+0xa0>
    itrunc(ip);
    80004ca6:	8526                	mv	a0,s1
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	026080e7          	jalr	38(ra) # 80002cce <itrunc>
    80004cb0:	bf2d                	j	80004bea <sys_open+0xce>

0000000080004cb2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cb2:	7175                	addi	sp,sp,-144
    80004cb4:	e506                	sd	ra,136(sp)
    80004cb6:	e122                	sd	s0,128(sp)
    80004cb8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	8ac080e7          	jalr	-1876(ra) # 80003566 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cc2:	08000613          	li	a2,128
    80004cc6:	f7040593          	addi	a1,s0,-144
    80004cca:	4501                	li	a0,0
    80004ccc:	ffffd097          	auipc	ra,0xffffd
    80004cd0:	35e080e7          	jalr	862(ra) # 8000202a <argstr>
    80004cd4:	02054963          	bltz	a0,80004d06 <sys_mkdir+0x54>
    80004cd8:	4681                	li	a3,0
    80004cda:	4601                	li	a2,0
    80004cdc:	4585                	li	a1,1
    80004cde:	f7040513          	addi	a0,s0,-144
    80004ce2:	00000097          	auipc	ra,0x0
    80004ce6:	806080e7          	jalr	-2042(ra) # 800044e8 <create>
    80004cea:	cd11                	beqz	a0,80004d06 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	136080e7          	jalr	310(ra) # 80002e22 <iunlockput>
  end_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	8ec080e7          	jalr	-1812(ra) # 800035e0 <end_op>
  return 0;
    80004cfc:	4501                	li	a0,0
}
    80004cfe:	60aa                	ld	ra,136(sp)
    80004d00:	640a                	ld	s0,128(sp)
    80004d02:	6149                	addi	sp,sp,144
    80004d04:	8082                	ret
    end_op();
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	8da080e7          	jalr	-1830(ra) # 800035e0 <end_op>
    return -1;
    80004d0e:	557d                	li	a0,-1
    80004d10:	b7fd                	j	80004cfe <sys_mkdir+0x4c>

0000000080004d12 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d12:	7135                	addi	sp,sp,-160
    80004d14:	ed06                	sd	ra,152(sp)
    80004d16:	e922                	sd	s0,144(sp)
    80004d18:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	84c080e7          	jalr	-1972(ra) # 80003566 <begin_op>
  argint(1, &major);
    80004d22:	f6c40593          	addi	a1,s0,-148
    80004d26:	4505                	li	a0,1
    80004d28:	ffffd097          	auipc	ra,0xffffd
    80004d2c:	2c2080e7          	jalr	706(ra) # 80001fea <argint>
  argint(2, &minor);
    80004d30:	f6840593          	addi	a1,s0,-152
    80004d34:	4509                	li	a0,2
    80004d36:	ffffd097          	auipc	ra,0xffffd
    80004d3a:	2b4080e7          	jalr	692(ra) # 80001fea <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d3e:	08000613          	li	a2,128
    80004d42:	f7040593          	addi	a1,s0,-144
    80004d46:	4501                	li	a0,0
    80004d48:	ffffd097          	auipc	ra,0xffffd
    80004d4c:	2e2080e7          	jalr	738(ra) # 8000202a <argstr>
    80004d50:	02054b63          	bltz	a0,80004d86 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d54:	f6841683          	lh	a3,-152(s0)
    80004d58:	f6c41603          	lh	a2,-148(s0)
    80004d5c:	458d                	li	a1,3
    80004d5e:	f7040513          	addi	a0,s0,-144
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	786080e7          	jalr	1926(ra) # 800044e8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d6a:	cd11                	beqz	a0,80004d86 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	0b6080e7          	jalr	182(ra) # 80002e22 <iunlockput>
  end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	86c080e7          	jalr	-1940(ra) # 800035e0 <end_op>
  return 0;
    80004d7c:	4501                	li	a0,0
}
    80004d7e:	60ea                	ld	ra,152(sp)
    80004d80:	644a                	ld	s0,144(sp)
    80004d82:	610d                	addi	sp,sp,160
    80004d84:	8082                	ret
    end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	85a080e7          	jalr	-1958(ra) # 800035e0 <end_op>
    return -1;
    80004d8e:	557d                	li	a0,-1
    80004d90:	b7fd                	j	80004d7e <sys_mknod+0x6c>

0000000080004d92 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d92:	7135                	addi	sp,sp,-160
    80004d94:	ed06                	sd	ra,152(sp)
    80004d96:	e922                	sd	s0,144(sp)
    80004d98:	e526                	sd	s1,136(sp)
    80004d9a:	e14a                	sd	s2,128(sp)
    80004d9c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	0b4080e7          	jalr	180(ra) # 80000e52 <myproc>
    80004da6:	892a                	mv	s2,a0
  
  begin_op();
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	7be080e7          	jalr	1982(ra) # 80003566 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004db0:	08000613          	li	a2,128
    80004db4:	f6040593          	addi	a1,s0,-160
    80004db8:	4501                	li	a0,0
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	270080e7          	jalr	624(ra) # 8000202a <argstr>
    80004dc2:	04054b63          	bltz	a0,80004e18 <sys_chdir+0x86>
    80004dc6:	f6040513          	addi	a0,s0,-160
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	59c080e7          	jalr	1436(ra) # 80003366 <namei>
    80004dd2:	84aa                	mv	s1,a0
    80004dd4:	c131                	beqz	a0,80004e18 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	dea080e7          	jalr	-534(ra) # 80002bc0 <ilock>
  if(ip->type != T_DIR){
    80004dde:	04449703          	lh	a4,68(s1)
    80004de2:	4785                	li	a5,1
    80004de4:	04f71063          	bne	a4,a5,80004e24 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de8:	8526                	mv	a0,s1
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	e98080e7          	jalr	-360(ra) # 80002c82 <iunlock>
  iput(p->cwd);
    80004df2:	15093503          	ld	a0,336(s2)
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	f84080e7          	jalr	-124(ra) # 80002d7a <iput>
  end_op();
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	7e2080e7          	jalr	2018(ra) # 800035e0 <end_op>
  p->cwd = ip;
    80004e06:	14993823          	sd	s1,336(s2)
  return 0;
    80004e0a:	4501                	li	a0,0
}
    80004e0c:	60ea                	ld	ra,152(sp)
    80004e0e:	644a                	ld	s0,144(sp)
    80004e10:	64aa                	ld	s1,136(sp)
    80004e12:	690a                	ld	s2,128(sp)
    80004e14:	610d                	addi	sp,sp,160
    80004e16:	8082                	ret
    end_op();
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	7c8080e7          	jalr	1992(ra) # 800035e0 <end_op>
    return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	b7ed                	j	80004e0c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	ffc080e7          	jalr	-4(ra) # 80002e22 <iunlockput>
    end_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	7b2080e7          	jalr	1970(ra) # 800035e0 <end_op>
    return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	bfd1                	j	80004e0c <sys_chdir+0x7a>

0000000080004e3a <sys_exec>:

uint64
sys_exec(void)
{
    80004e3a:	7121                	addi	sp,sp,-448
    80004e3c:	ff06                	sd	ra,440(sp)
    80004e3e:	fb22                	sd	s0,432(sp)
    80004e40:	f726                	sd	s1,424(sp)
    80004e42:	f34a                	sd	s2,416(sp)
    80004e44:	ef4e                	sd	s3,408(sp)
    80004e46:	eb52                	sd	s4,400(sp)
    80004e48:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e4a:	e4840593          	addi	a1,s0,-440
    80004e4e:	4505                	li	a0,1
    80004e50:	ffffd097          	auipc	ra,0xffffd
    80004e54:	1ba080e7          	jalr	442(ra) # 8000200a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e58:	08000613          	li	a2,128
    80004e5c:	f5040593          	addi	a1,s0,-176
    80004e60:	4501                	li	a0,0
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	1c8080e7          	jalr	456(ra) # 8000202a <argstr>
    80004e6a:	87aa                	mv	a5,a0
    return -1;
    80004e6c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e6e:	0c07c263          	bltz	a5,80004f32 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004e72:	10000613          	li	a2,256
    80004e76:	4581                	li	a1,0
    80004e78:	e5040513          	addi	a0,s0,-432
    80004e7c:	ffffb097          	auipc	ra,0xffffb
    80004e80:	2fe080e7          	jalr	766(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e84:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e88:	89a6                	mv	s3,s1
    80004e8a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e8c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e90:	00391513          	slli	a0,s2,0x3
    80004e94:	e4040593          	addi	a1,s0,-448
    80004e98:	e4843783          	ld	a5,-440(s0)
    80004e9c:	953e                	add	a0,a0,a5
    80004e9e:	ffffd097          	auipc	ra,0xffffd
    80004ea2:	0ae080e7          	jalr	174(ra) # 80001f4c <fetchaddr>
    80004ea6:	02054a63          	bltz	a0,80004eda <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004eaa:	e4043783          	ld	a5,-448(s0)
    80004eae:	c3b9                	beqz	a5,80004ef4 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb0:	ffffb097          	auipc	ra,0xffffb
    80004eb4:	26a080e7          	jalr	618(ra) # 8000011a <kalloc>
    80004eb8:	85aa                	mv	a1,a0
    80004eba:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ebe:	cd11                	beqz	a0,80004eda <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec0:	6605                	lui	a2,0x1
    80004ec2:	e4043503          	ld	a0,-448(s0)
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	0d8080e7          	jalr	216(ra) # 80001f9e <fetchstr>
    80004ece:	00054663          	bltz	a0,80004eda <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004ed2:	0905                	addi	s2,s2,1
    80004ed4:	09a1                	addi	s3,s3,8
    80004ed6:	fb491de3          	bne	s2,s4,80004e90 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eda:	f5040913          	addi	s2,s0,-176
    80004ede:	6088                	ld	a0,0(s1)
    80004ee0:	c921                	beqz	a0,80004f30 <sys_exec+0xf6>
    kfree(argv[i]);
    80004ee2:	ffffb097          	auipc	ra,0xffffb
    80004ee6:	13a080e7          	jalr	314(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eea:	04a1                	addi	s1,s1,8
    80004eec:	ff2499e3          	bne	s1,s2,80004ede <sys_exec+0xa4>
  return -1;
    80004ef0:	557d                	li	a0,-1
    80004ef2:	a081                	j	80004f32 <sys_exec+0xf8>
      argv[i] = 0;
    80004ef4:	0009079b          	sext.w	a5,s2
    80004ef8:	078e                	slli	a5,a5,0x3
    80004efa:	fd078793          	addi	a5,a5,-48
    80004efe:	97a2                	add	a5,a5,s0
    80004f00:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f04:	e5040593          	addi	a1,s0,-432
    80004f08:	f5040513          	addi	a0,s0,-176
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	194080e7          	jalr	404(ra) # 800040a0 <exec>
    80004f14:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f16:	f5040993          	addi	s3,s0,-176
    80004f1a:	6088                	ld	a0,0(s1)
    80004f1c:	c901                	beqz	a0,80004f2c <sys_exec+0xf2>
    kfree(argv[i]);
    80004f1e:	ffffb097          	auipc	ra,0xffffb
    80004f22:	0fe080e7          	jalr	254(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f26:	04a1                	addi	s1,s1,8
    80004f28:	ff3499e3          	bne	s1,s3,80004f1a <sys_exec+0xe0>
  return ret;
    80004f2c:	854a                	mv	a0,s2
    80004f2e:	a011                	j	80004f32 <sys_exec+0xf8>
  return -1;
    80004f30:	557d                	li	a0,-1
}
    80004f32:	70fa                	ld	ra,440(sp)
    80004f34:	745a                	ld	s0,432(sp)
    80004f36:	74ba                	ld	s1,424(sp)
    80004f38:	791a                	ld	s2,416(sp)
    80004f3a:	69fa                	ld	s3,408(sp)
    80004f3c:	6a5a                	ld	s4,400(sp)
    80004f3e:	6139                	addi	sp,sp,448
    80004f40:	8082                	ret

0000000080004f42 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f42:	7139                	addi	sp,sp,-64
    80004f44:	fc06                	sd	ra,56(sp)
    80004f46:	f822                	sd	s0,48(sp)
    80004f48:	f426                	sd	s1,40(sp)
    80004f4a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f4c:	ffffc097          	auipc	ra,0xffffc
    80004f50:	f06080e7          	jalr	-250(ra) # 80000e52 <myproc>
    80004f54:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f56:	fd840593          	addi	a1,s0,-40
    80004f5a:	4501                	li	a0,0
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	0ae080e7          	jalr	174(ra) # 8000200a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f64:	fc840593          	addi	a1,s0,-56
    80004f68:	fd040513          	addi	a0,s0,-48
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	dea080e7          	jalr	-534(ra) # 80003d56 <pipealloc>
    return -1;
    80004f74:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f76:	0c054463          	bltz	a0,8000503e <sys_pipe+0xfc>
  fd0 = -1;
    80004f7a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f7e:	fd043503          	ld	a0,-48(s0)
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	524080e7          	jalr	1316(ra) # 800044a6 <fdalloc>
    80004f8a:	fca42223          	sw	a0,-60(s0)
    80004f8e:	08054b63          	bltz	a0,80005024 <sys_pipe+0xe2>
    80004f92:	fc843503          	ld	a0,-56(s0)
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	510080e7          	jalr	1296(ra) # 800044a6 <fdalloc>
    80004f9e:	fca42023          	sw	a0,-64(s0)
    80004fa2:	06054863          	bltz	a0,80005012 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fa6:	4691                	li	a3,4
    80004fa8:	fc440613          	addi	a2,s0,-60
    80004fac:	fd843583          	ld	a1,-40(s0)
    80004fb0:	68a8                	ld	a0,80(s1)
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	b60080e7          	jalr	-1184(ra) # 80000b12 <copyout>
    80004fba:	02054063          	bltz	a0,80004fda <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fbe:	4691                	li	a3,4
    80004fc0:	fc040613          	addi	a2,s0,-64
    80004fc4:	fd843583          	ld	a1,-40(s0)
    80004fc8:	0591                	addi	a1,a1,4
    80004fca:	68a8                	ld	a0,80(s1)
    80004fcc:	ffffc097          	auipc	ra,0xffffc
    80004fd0:	b46080e7          	jalr	-1210(ra) # 80000b12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fd4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fd6:	06055463          	bgez	a0,8000503e <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fda:	fc442783          	lw	a5,-60(s0)
    80004fde:	07e9                	addi	a5,a5,26
    80004fe0:	078e                	slli	a5,a5,0x3
    80004fe2:	97a6                	add	a5,a5,s1
    80004fe4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fe8:	fc042783          	lw	a5,-64(s0)
    80004fec:	07e9                	addi	a5,a5,26
    80004fee:	078e                	slli	a5,a5,0x3
    80004ff0:	94be                	add	s1,s1,a5
    80004ff2:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004ff6:	fd043503          	ld	a0,-48(s0)
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	a30080e7          	jalr	-1488(ra) # 80003a2a <fileclose>
    fileclose(wf);
    80005002:	fc843503          	ld	a0,-56(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	a24080e7          	jalr	-1500(ra) # 80003a2a <fileclose>
    return -1;
    8000500e:	57fd                	li	a5,-1
    80005010:	a03d                	j	8000503e <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005012:	fc442783          	lw	a5,-60(s0)
    80005016:	0007c763          	bltz	a5,80005024 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000501a:	07e9                	addi	a5,a5,26
    8000501c:	078e                	slli	a5,a5,0x3
    8000501e:	97a6                	add	a5,a5,s1
    80005020:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005024:	fd043503          	ld	a0,-48(s0)
    80005028:	fffff097          	auipc	ra,0xfffff
    8000502c:	a02080e7          	jalr	-1534(ra) # 80003a2a <fileclose>
    fileclose(wf);
    80005030:	fc843503          	ld	a0,-56(s0)
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	9f6080e7          	jalr	-1546(ra) # 80003a2a <fileclose>
    return -1;
    8000503c:	57fd                	li	a5,-1
}
    8000503e:	853e                	mv	a0,a5
    80005040:	70e2                	ld	ra,56(sp)
    80005042:	7442                	ld	s0,48(sp)
    80005044:	74a2                	ld	s1,40(sp)
    80005046:	6121                	addi	sp,sp,64
    80005048:	8082                	ret
    8000504a:	0000                	unimp
    8000504c:	0000                	unimp
	...

0000000080005050 <kernelvec>:
    80005050:	7111                	addi	sp,sp,-256
    80005052:	e006                	sd	ra,0(sp)
    80005054:	e40a                	sd	sp,8(sp)
    80005056:	e80e                	sd	gp,16(sp)
    80005058:	ec12                	sd	tp,24(sp)
    8000505a:	f016                	sd	t0,32(sp)
    8000505c:	f41a                	sd	t1,40(sp)
    8000505e:	f81e                	sd	t2,48(sp)
    80005060:	fc22                	sd	s0,56(sp)
    80005062:	e0a6                	sd	s1,64(sp)
    80005064:	e4aa                	sd	a0,72(sp)
    80005066:	e8ae                	sd	a1,80(sp)
    80005068:	ecb2                	sd	a2,88(sp)
    8000506a:	f0b6                	sd	a3,96(sp)
    8000506c:	f4ba                	sd	a4,104(sp)
    8000506e:	f8be                	sd	a5,112(sp)
    80005070:	fcc2                	sd	a6,120(sp)
    80005072:	e146                	sd	a7,128(sp)
    80005074:	e54a                	sd	s2,136(sp)
    80005076:	e94e                	sd	s3,144(sp)
    80005078:	ed52                	sd	s4,152(sp)
    8000507a:	f156                	sd	s5,160(sp)
    8000507c:	f55a                	sd	s6,168(sp)
    8000507e:	f95e                	sd	s7,176(sp)
    80005080:	fd62                	sd	s8,184(sp)
    80005082:	e1e6                	sd	s9,192(sp)
    80005084:	e5ea                	sd	s10,200(sp)
    80005086:	e9ee                	sd	s11,208(sp)
    80005088:	edf2                	sd	t3,216(sp)
    8000508a:	f1f6                	sd	t4,224(sp)
    8000508c:	f5fa                	sd	t5,232(sp)
    8000508e:	f9fe                	sd	t6,240(sp)
    80005090:	d89fc0ef          	jal	ra,80001e18 <kerneltrap>
    80005094:	6082                	ld	ra,0(sp)
    80005096:	6122                	ld	sp,8(sp)
    80005098:	61c2                	ld	gp,16(sp)
    8000509a:	7282                	ld	t0,32(sp)
    8000509c:	7322                	ld	t1,40(sp)
    8000509e:	73c2                	ld	t2,48(sp)
    800050a0:	7462                	ld	s0,56(sp)
    800050a2:	6486                	ld	s1,64(sp)
    800050a4:	6526                	ld	a0,72(sp)
    800050a6:	65c6                	ld	a1,80(sp)
    800050a8:	6666                	ld	a2,88(sp)
    800050aa:	7686                	ld	a3,96(sp)
    800050ac:	7726                	ld	a4,104(sp)
    800050ae:	77c6                	ld	a5,112(sp)
    800050b0:	7866                	ld	a6,120(sp)
    800050b2:	688a                	ld	a7,128(sp)
    800050b4:	692a                	ld	s2,136(sp)
    800050b6:	69ca                	ld	s3,144(sp)
    800050b8:	6a6a                	ld	s4,152(sp)
    800050ba:	7a8a                	ld	s5,160(sp)
    800050bc:	7b2a                	ld	s6,168(sp)
    800050be:	7bca                	ld	s7,176(sp)
    800050c0:	7c6a                	ld	s8,184(sp)
    800050c2:	6c8e                	ld	s9,192(sp)
    800050c4:	6d2e                	ld	s10,200(sp)
    800050c6:	6dce                	ld	s11,208(sp)
    800050c8:	6e6e                	ld	t3,216(sp)
    800050ca:	7e8e                	ld	t4,224(sp)
    800050cc:	7f2e                	ld	t5,232(sp)
    800050ce:	7fce                	ld	t6,240(sp)
    800050d0:	6111                	addi	sp,sp,256
    800050d2:	10200073          	sret
    800050d6:	00000013          	nop
    800050da:	00000013          	nop
    800050de:	0001                	nop

00000000800050e0 <timervec>:
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	e10c                	sd	a1,0(a0)
    800050e6:	e510                	sd	a2,8(a0)
    800050e8:	e914                	sd	a3,16(a0)
    800050ea:	6d0c                	ld	a1,24(a0)
    800050ec:	7110                	ld	a2,32(a0)
    800050ee:	6194                	ld	a3,0(a1)
    800050f0:	96b2                	add	a3,a3,a2
    800050f2:	e194                	sd	a3,0(a1)
    800050f4:	4589                	li	a1,2
    800050f6:	14459073          	csrw	sip,a1
    800050fa:	6914                	ld	a3,16(a0)
    800050fc:	6510                	ld	a2,8(a0)
    800050fe:	610c                	ld	a1,0(a0)
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	30200073          	mret
	...

000000008000510a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000510a:	1141                	addi	sp,sp,-16
    8000510c:	e422                	sd	s0,8(sp)
    8000510e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005110:	0c0007b7          	lui	a5,0xc000
    80005114:	4705                	li	a4,1
    80005116:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005118:	c3d8                	sw	a4,4(a5)
}
    8000511a:	6422                	ld	s0,8(sp)
    8000511c:	0141                	addi	sp,sp,16
    8000511e:	8082                	ret

0000000080005120 <plicinithart>:

void
plicinithart(void)
{
    80005120:	1141                	addi	sp,sp,-16
    80005122:	e406                	sd	ra,8(sp)
    80005124:	e022                	sd	s0,0(sp)
    80005126:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	cfe080e7          	jalr	-770(ra) # 80000e26 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005130:	0085171b          	slliw	a4,a0,0x8
    80005134:	0c0027b7          	lui	a5,0xc002
    80005138:	97ba                	add	a5,a5,a4
    8000513a:	40200713          	li	a4,1026
    8000513e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005142:	00d5151b          	slliw	a0,a0,0xd
    80005146:	0c2017b7          	lui	a5,0xc201
    8000514a:	97aa                	add	a5,a5,a0
    8000514c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005150:	60a2                	ld	ra,8(sp)
    80005152:	6402                	ld	s0,0(sp)
    80005154:	0141                	addi	sp,sp,16
    80005156:	8082                	ret

0000000080005158 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005158:	1141                	addi	sp,sp,-16
    8000515a:	e406                	sd	ra,8(sp)
    8000515c:	e022                	sd	s0,0(sp)
    8000515e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005160:	ffffc097          	auipc	ra,0xffffc
    80005164:	cc6080e7          	jalr	-826(ra) # 80000e26 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005168:	00d5151b          	slliw	a0,a0,0xd
    8000516c:	0c2017b7          	lui	a5,0xc201
    80005170:	97aa                	add	a5,a5,a0
  return irq;
}
    80005172:	43c8                	lw	a0,4(a5)
    80005174:	60a2                	ld	ra,8(sp)
    80005176:	6402                	ld	s0,0(sp)
    80005178:	0141                	addi	sp,sp,16
    8000517a:	8082                	ret

000000008000517c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000517c:	1101                	addi	sp,sp,-32
    8000517e:	ec06                	sd	ra,24(sp)
    80005180:	e822                	sd	s0,16(sp)
    80005182:	e426                	sd	s1,8(sp)
    80005184:	1000                	addi	s0,sp,32
    80005186:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	c9e080e7          	jalr	-866(ra) # 80000e26 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005190:	00d5151b          	slliw	a0,a0,0xd
    80005194:	0c2017b7          	lui	a5,0xc201
    80005198:	97aa                	add	a5,a5,a0
    8000519a:	c3c4                	sw	s1,4(a5)
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6105                	addi	sp,sp,32
    800051a4:	8082                	ret

00000000800051a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051a6:	1141                	addi	sp,sp,-16
    800051a8:	e406                	sd	ra,8(sp)
    800051aa:	e022                	sd	s0,0(sp)
    800051ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ae:	479d                	li	a5,7
    800051b0:	04a7cc63          	blt	a5,a0,80005208 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051b4:	00015797          	auipc	a5,0x15
    800051b8:	c4c78793          	addi	a5,a5,-948 # 80019e00 <disk>
    800051bc:	97aa                	add	a5,a5,a0
    800051be:	0187c783          	lbu	a5,24(a5)
    800051c2:	ebb9                	bnez	a5,80005218 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051c4:	00451693          	slli	a3,a0,0x4
    800051c8:	00015797          	auipc	a5,0x15
    800051cc:	c3878793          	addi	a5,a5,-968 # 80019e00 <disk>
    800051d0:	6398                	ld	a4,0(a5)
    800051d2:	9736                	add	a4,a4,a3
    800051d4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800051d8:	6398                	ld	a4,0(a5)
    800051da:	9736                	add	a4,a4,a3
    800051dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	4705                	li	a4,1
    800051ec:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800051f0:	00015517          	auipc	a0,0x15
    800051f4:	c2850513          	addi	a0,a0,-984 # 80019e18 <disk+0x18>
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	37e080e7          	jalr	894(ra) # 80001576 <wakeup>
}
    80005200:	60a2                	ld	ra,8(sp)
    80005202:	6402                	ld	s0,0(sp)
    80005204:	0141                	addi	sp,sp,16
    80005206:	8082                	ret
    panic("free_desc 1");
    80005208:	00003517          	auipc	a0,0x3
    8000520c:	4c850513          	addi	a0,a0,1224 # 800086d0 <syscalls+0x300>
    80005210:	00001097          	auipc	ra,0x1
    80005214:	a90080e7          	jalr	-1392(ra) # 80005ca0 <panic>
    panic("free_desc 2");
    80005218:	00003517          	auipc	a0,0x3
    8000521c:	4c850513          	addi	a0,a0,1224 # 800086e0 <syscalls+0x310>
    80005220:	00001097          	auipc	ra,0x1
    80005224:	a80080e7          	jalr	-1408(ra) # 80005ca0 <panic>

0000000080005228 <virtio_disk_init>:
{
    80005228:	1101                	addi	sp,sp,-32
    8000522a:	ec06                	sd	ra,24(sp)
    8000522c:	e822                	sd	s0,16(sp)
    8000522e:	e426                	sd	s1,8(sp)
    80005230:	e04a                	sd	s2,0(sp)
    80005232:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005234:	00003597          	auipc	a1,0x3
    80005238:	4bc58593          	addi	a1,a1,1212 # 800086f0 <syscalls+0x320>
    8000523c:	00015517          	auipc	a0,0x15
    80005240:	cec50513          	addi	a0,a0,-788 # 80019f28 <disk+0x128>
    80005244:	00001097          	auipc	ra,0x1
    80005248:	eda080e7          	jalr	-294(ra) # 8000611e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000524c:	100017b7          	lui	a5,0x10001
    80005250:	4398                	lw	a4,0(a5)
    80005252:	2701                	sext.w	a4,a4
    80005254:	747277b7          	lui	a5,0x74727
    80005258:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000525c:	14f71b63          	bne	a4,a5,800053b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005260:	100017b7          	lui	a5,0x10001
    80005264:	43dc                	lw	a5,4(a5)
    80005266:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005268:	4709                	li	a4,2
    8000526a:	14e79463          	bne	a5,a4,800053b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000526e:	100017b7          	lui	a5,0x10001
    80005272:	479c                	lw	a5,8(a5)
    80005274:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005276:	12e79e63          	bne	a5,a4,800053b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000527a:	100017b7          	lui	a5,0x10001
    8000527e:	47d8                	lw	a4,12(a5)
    80005280:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005282:	554d47b7          	lui	a5,0x554d4
    80005286:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000528a:	12f71463          	bne	a4,a5,800053b2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528e:	100017b7          	lui	a5,0x10001
    80005292:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005296:	4705                	li	a4,1
    80005298:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000529a:	470d                	li	a4,3
    8000529c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000529e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052a0:	c7ffe6b7          	lui	a3,0xc7ffe
    800052a4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc5df>
    800052a8:	8f75                	and	a4,a4,a3
    800052aa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ac:	472d                	li	a4,11
    800052ae:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052b0:	5bbc                	lw	a5,112(a5)
    800052b2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800052b6:	8ba1                	andi	a5,a5,8
    800052b8:	10078563          	beqz	a5,800053c2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052c4:	43fc                	lw	a5,68(a5)
    800052c6:	2781                	sext.w	a5,a5
    800052c8:	10079563          	bnez	a5,800053d2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052cc:	100017b7          	lui	a5,0x10001
    800052d0:	5bdc                	lw	a5,52(a5)
    800052d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800052d4:	10078763          	beqz	a5,800053e2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800052d8:	471d                	li	a4,7
    800052da:	10f77c63          	bgeu	a4,a5,800053f2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	e3c080e7          	jalr	-452(ra) # 8000011a <kalloc>
    800052e6:	00015497          	auipc	s1,0x15
    800052ea:	b1a48493          	addi	s1,s1,-1254 # 80019e00 <disk>
    800052ee:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052f0:	ffffb097          	auipc	ra,0xffffb
    800052f4:	e2a080e7          	jalr	-470(ra) # 8000011a <kalloc>
    800052f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052fa:	ffffb097          	auipc	ra,0xffffb
    800052fe:	e20080e7          	jalr	-480(ra) # 8000011a <kalloc>
    80005302:	87aa                	mv	a5,a0
    80005304:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005306:	6088                	ld	a0,0(s1)
    80005308:	cd6d                	beqz	a0,80005402 <virtio_disk_init+0x1da>
    8000530a:	00015717          	auipc	a4,0x15
    8000530e:	afe73703          	ld	a4,-1282(a4) # 80019e08 <disk+0x8>
    80005312:	cb65                	beqz	a4,80005402 <virtio_disk_init+0x1da>
    80005314:	c7fd                	beqz	a5,80005402 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005316:	6605                	lui	a2,0x1
    80005318:	4581                	li	a1,0
    8000531a:	ffffb097          	auipc	ra,0xffffb
    8000531e:	e60080e7          	jalr	-416(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005322:	00015497          	auipc	s1,0x15
    80005326:	ade48493          	addi	s1,s1,-1314 # 80019e00 <disk>
    8000532a:	6605                	lui	a2,0x1
    8000532c:	4581                	li	a1,0
    8000532e:	6488                	ld	a0,8(s1)
    80005330:	ffffb097          	auipc	ra,0xffffb
    80005334:	e4a080e7          	jalr	-438(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005338:	6605                	lui	a2,0x1
    8000533a:	4581                	li	a1,0
    8000533c:	6888                	ld	a0,16(s1)
    8000533e:	ffffb097          	auipc	ra,0xffffb
    80005342:	e3c080e7          	jalr	-452(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005346:	100017b7          	lui	a5,0x10001
    8000534a:	4721                	li	a4,8
    8000534c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000534e:	4098                	lw	a4,0(s1)
    80005350:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005354:	40d8                	lw	a4,4(s1)
    80005356:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000535a:	6498                	ld	a4,8(s1)
    8000535c:	0007069b          	sext.w	a3,a4
    80005360:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005364:	9701                	srai	a4,a4,0x20
    80005366:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000536a:	6898                	ld	a4,16(s1)
    8000536c:	0007069b          	sext.w	a3,a4
    80005370:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005374:	9701                	srai	a4,a4,0x20
    80005376:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000537a:	4705                	li	a4,1
    8000537c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000537e:	00e48c23          	sb	a4,24(s1)
    80005382:	00e48ca3          	sb	a4,25(s1)
    80005386:	00e48d23          	sb	a4,26(s1)
    8000538a:	00e48da3          	sb	a4,27(s1)
    8000538e:	00e48e23          	sb	a4,28(s1)
    80005392:	00e48ea3          	sb	a4,29(s1)
    80005396:	00e48f23          	sb	a4,30(s1)
    8000539a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000539e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a2:	0727a823          	sw	s2,112(a5)
}
    800053a6:	60e2                	ld	ra,24(sp)
    800053a8:	6442                	ld	s0,16(sp)
    800053aa:	64a2                	ld	s1,8(sp)
    800053ac:	6902                	ld	s2,0(sp)
    800053ae:	6105                	addi	sp,sp,32
    800053b0:	8082                	ret
    panic("could not find virtio disk");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	34e50513          	addi	a0,a0,846 # 80008700 <syscalls+0x330>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	8e6080e7          	jalr	-1818(ra) # 80005ca0 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	35e50513          	addi	a0,a0,862 # 80008720 <syscalls+0x350>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	8d6080e7          	jalr	-1834(ra) # 80005ca0 <panic>
    panic("virtio disk should not be ready");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	36e50513          	addi	a0,a0,878 # 80008740 <syscalls+0x370>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	8c6080e7          	jalr	-1850(ra) # 80005ca0 <panic>
    panic("virtio disk has no queue 0");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	37e50513          	addi	a0,a0,894 # 80008760 <syscalls+0x390>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	8b6080e7          	jalr	-1866(ra) # 80005ca0 <panic>
    panic("virtio disk max queue too short");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	38e50513          	addi	a0,a0,910 # 80008780 <syscalls+0x3b0>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	8a6080e7          	jalr	-1882(ra) # 80005ca0 <panic>
    panic("virtio disk kalloc");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	39e50513          	addi	a0,a0,926 # 800087a0 <syscalls+0x3d0>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	896080e7          	jalr	-1898(ra) # 80005ca0 <panic>

0000000080005412 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005412:	7159                	addi	sp,sp,-112
    80005414:	f486                	sd	ra,104(sp)
    80005416:	f0a2                	sd	s0,96(sp)
    80005418:	eca6                	sd	s1,88(sp)
    8000541a:	e8ca                	sd	s2,80(sp)
    8000541c:	e4ce                	sd	s3,72(sp)
    8000541e:	e0d2                	sd	s4,64(sp)
    80005420:	fc56                	sd	s5,56(sp)
    80005422:	f85a                	sd	s6,48(sp)
    80005424:	f45e                	sd	s7,40(sp)
    80005426:	f062                	sd	s8,32(sp)
    80005428:	ec66                	sd	s9,24(sp)
    8000542a:	e86a                	sd	s10,16(sp)
    8000542c:	1880                	addi	s0,sp,112
    8000542e:	8a2a                	mv	s4,a0
    80005430:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005432:	00c52c83          	lw	s9,12(a0)
    80005436:	001c9c9b          	slliw	s9,s9,0x1
    8000543a:	1c82                	slli	s9,s9,0x20
    8000543c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005440:	00015517          	auipc	a0,0x15
    80005444:	ae850513          	addi	a0,a0,-1304 # 80019f28 <disk+0x128>
    80005448:	00001097          	auipc	ra,0x1
    8000544c:	d66080e7          	jalr	-666(ra) # 800061ae <acquire>
  for(int i = 0; i < 3; i++){
    80005450:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005452:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005454:	00015b17          	auipc	s6,0x15
    80005458:	9acb0b13          	addi	s6,s6,-1620 # 80019e00 <disk>
  for(int i = 0; i < 3; i++){
    8000545c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000545e:	00015c17          	auipc	s8,0x15
    80005462:	acac0c13          	addi	s8,s8,-1334 # 80019f28 <disk+0x128>
    80005466:	a095                	j	800054ca <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005468:	00fb0733          	add	a4,s6,a5
    8000546c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005470:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005472:	0207c563          	bltz	a5,8000549c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005476:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005478:	0591                	addi	a1,a1,4
    8000547a:	05560d63          	beq	a2,s5,800054d4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000547e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005480:	00015717          	auipc	a4,0x15
    80005484:	98070713          	addi	a4,a4,-1664 # 80019e00 <disk>
    80005488:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000548a:	01874683          	lbu	a3,24(a4)
    8000548e:	fee9                	bnez	a3,80005468 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005490:	2785                	addiw	a5,a5,1
    80005492:	0705                	addi	a4,a4,1
    80005494:	fe979be3          	bne	a5,s1,8000548a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005498:	57fd                	li	a5,-1
    8000549a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000549c:	00c05e63          	blez	a2,800054b8 <virtio_disk_rw+0xa6>
    800054a0:	060a                	slli	a2,a2,0x2
    800054a2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800054a6:	0009a503          	lw	a0,0(s3)
    800054aa:	00000097          	auipc	ra,0x0
    800054ae:	cfc080e7          	jalr	-772(ra) # 800051a6 <free_desc>
      for(int j = 0; j < i; j++)
    800054b2:	0991                	addi	s3,s3,4
    800054b4:	ffa999e3          	bne	s3,s10,800054a6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b8:	85e2                	mv	a1,s8
    800054ba:	00015517          	auipc	a0,0x15
    800054be:	95e50513          	addi	a0,a0,-1698 # 80019e18 <disk+0x18>
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	050080e7          	jalr	80(ra) # 80001512 <sleep>
  for(int i = 0; i < 3; i++){
    800054ca:	f9040993          	addi	s3,s0,-112
{
    800054ce:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800054d0:	864a                	mv	a2,s2
    800054d2:	b775                	j	8000547e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054d4:	f9042503          	lw	a0,-112(s0)
    800054d8:	00a50713          	addi	a4,a0,10
    800054dc:	0712                	slli	a4,a4,0x4

  if(write)
    800054de:	00015797          	auipc	a5,0x15
    800054e2:	92278793          	addi	a5,a5,-1758 # 80019e00 <disk>
    800054e6:	00e786b3          	add	a3,a5,a4
    800054ea:	01703633          	snez	a2,s7
    800054ee:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054f0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800054f4:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f8:	f6070613          	addi	a2,a4,-160
    800054fc:	6394                	ld	a3,0(a5)
    800054fe:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005500:	00870593          	addi	a1,a4,8
    80005504:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005506:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005508:	0007b803          	ld	a6,0(a5)
    8000550c:	9642                	add	a2,a2,a6
    8000550e:	46c1                	li	a3,16
    80005510:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005512:	4585                	li	a1,1
    80005514:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005518:	f9442683          	lw	a3,-108(s0)
    8000551c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005520:	0692                	slli	a3,a3,0x4
    80005522:	9836                	add	a6,a6,a3
    80005524:	058a0613          	addi	a2,s4,88
    80005528:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000552c:	0007b803          	ld	a6,0(a5)
    80005530:	96c2                	add	a3,a3,a6
    80005532:	40000613          	li	a2,1024
    80005536:	c690                	sw	a2,8(a3)
  if(write)
    80005538:	001bb613          	seqz	a2,s7
    8000553c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005540:	00166613          	ori	a2,a2,1
    80005544:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005548:	f9842603          	lw	a2,-104(s0)
    8000554c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005550:	00250693          	addi	a3,a0,2
    80005554:	0692                	slli	a3,a3,0x4
    80005556:	96be                	add	a3,a3,a5
    80005558:	58fd                	li	a7,-1
    8000555a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000555e:	0612                	slli	a2,a2,0x4
    80005560:	9832                	add	a6,a6,a2
    80005562:	f9070713          	addi	a4,a4,-112
    80005566:	973e                	add	a4,a4,a5
    80005568:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000556c:	6398                	ld	a4,0(a5)
    8000556e:	9732                	add	a4,a4,a2
    80005570:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005572:	4609                	li	a2,2
    80005574:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005578:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000557c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005580:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005584:	6794                	ld	a3,8(a5)
    80005586:	0026d703          	lhu	a4,2(a3)
    8000558a:	8b1d                	andi	a4,a4,7
    8000558c:	0706                	slli	a4,a4,0x1
    8000558e:	96ba                	add	a3,a3,a4
    80005590:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005594:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005598:	6798                	ld	a4,8(a5)
    8000559a:	00275783          	lhu	a5,2(a4)
    8000559e:	2785                	addiw	a5,a5,1
    800055a0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055a4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055a8:	100017b7          	lui	a5,0x10001
    800055ac:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055b0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800055b4:	00015917          	auipc	s2,0x15
    800055b8:	97490913          	addi	s2,s2,-1676 # 80019f28 <disk+0x128>
  while(b->disk == 1) {
    800055bc:	4485                	li	s1,1
    800055be:	00b79c63          	bne	a5,a1,800055d6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800055c2:	85ca                	mv	a1,s2
    800055c4:	8552                	mv	a0,s4
    800055c6:	ffffc097          	auipc	ra,0xffffc
    800055ca:	f4c080e7          	jalr	-180(ra) # 80001512 <sleep>
  while(b->disk == 1) {
    800055ce:	004a2783          	lw	a5,4(s4)
    800055d2:	fe9788e3          	beq	a5,s1,800055c2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800055d6:	f9042903          	lw	s2,-112(s0)
    800055da:	00290713          	addi	a4,s2,2
    800055de:	0712                	slli	a4,a4,0x4
    800055e0:	00015797          	auipc	a5,0x15
    800055e4:	82078793          	addi	a5,a5,-2016 # 80019e00 <disk>
    800055e8:	97ba                	add	a5,a5,a4
    800055ea:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055ee:	00015997          	auipc	s3,0x15
    800055f2:	81298993          	addi	s3,s3,-2030 # 80019e00 <disk>
    800055f6:	00491713          	slli	a4,s2,0x4
    800055fa:	0009b783          	ld	a5,0(s3)
    800055fe:	97ba                	add	a5,a5,a4
    80005600:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005604:	854a                	mv	a0,s2
    80005606:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	b9c080e7          	jalr	-1124(ra) # 800051a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005612:	8885                	andi	s1,s1,1
    80005614:	f0ed                	bnez	s1,800055f6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005616:	00015517          	auipc	a0,0x15
    8000561a:	91250513          	addi	a0,a0,-1774 # 80019f28 <disk+0x128>
    8000561e:	00001097          	auipc	ra,0x1
    80005622:	c44080e7          	jalr	-956(ra) # 80006262 <release>
}
    80005626:	70a6                	ld	ra,104(sp)
    80005628:	7406                	ld	s0,96(sp)
    8000562a:	64e6                	ld	s1,88(sp)
    8000562c:	6946                	ld	s2,80(sp)
    8000562e:	69a6                	ld	s3,72(sp)
    80005630:	6a06                	ld	s4,64(sp)
    80005632:	7ae2                	ld	s5,56(sp)
    80005634:	7b42                	ld	s6,48(sp)
    80005636:	7ba2                	ld	s7,40(sp)
    80005638:	7c02                	ld	s8,32(sp)
    8000563a:	6ce2                	ld	s9,24(sp)
    8000563c:	6d42                	ld	s10,16(sp)
    8000563e:	6165                	addi	sp,sp,112
    80005640:	8082                	ret

0000000080005642 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005642:	1101                	addi	sp,sp,-32
    80005644:	ec06                	sd	ra,24(sp)
    80005646:	e822                	sd	s0,16(sp)
    80005648:	e426                	sd	s1,8(sp)
    8000564a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000564c:	00014497          	auipc	s1,0x14
    80005650:	7b448493          	addi	s1,s1,1972 # 80019e00 <disk>
    80005654:	00015517          	auipc	a0,0x15
    80005658:	8d450513          	addi	a0,a0,-1836 # 80019f28 <disk+0x128>
    8000565c:	00001097          	auipc	ra,0x1
    80005660:	b52080e7          	jalr	-1198(ra) # 800061ae <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005664:	10001737          	lui	a4,0x10001
    80005668:	533c                	lw	a5,96(a4)
    8000566a:	8b8d                	andi	a5,a5,3
    8000566c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000566e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005672:	689c                	ld	a5,16(s1)
    80005674:	0204d703          	lhu	a4,32(s1)
    80005678:	0027d783          	lhu	a5,2(a5)
    8000567c:	04f70863          	beq	a4,a5,800056cc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005680:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005684:	6898                	ld	a4,16(s1)
    80005686:	0204d783          	lhu	a5,32(s1)
    8000568a:	8b9d                	andi	a5,a5,7
    8000568c:	078e                	slli	a5,a5,0x3
    8000568e:	97ba                	add	a5,a5,a4
    80005690:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005692:	00278713          	addi	a4,a5,2
    80005696:	0712                	slli	a4,a4,0x4
    80005698:	9726                	add	a4,a4,s1
    8000569a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000569e:	e721                	bnez	a4,800056e6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056a0:	0789                	addi	a5,a5,2
    800056a2:	0792                	slli	a5,a5,0x4
    800056a4:	97a6                	add	a5,a5,s1
    800056a6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056a8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	eca080e7          	jalr	-310(ra) # 80001576 <wakeup>

    disk.used_idx += 1;
    800056b4:	0204d783          	lhu	a5,32(s1)
    800056b8:	2785                	addiw	a5,a5,1
    800056ba:	17c2                	slli	a5,a5,0x30
    800056bc:	93c1                	srli	a5,a5,0x30
    800056be:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056c2:	6898                	ld	a4,16(s1)
    800056c4:	00275703          	lhu	a4,2(a4)
    800056c8:	faf71ce3          	bne	a4,a5,80005680 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800056cc:	00015517          	auipc	a0,0x15
    800056d0:	85c50513          	addi	a0,a0,-1956 # 80019f28 <disk+0x128>
    800056d4:	00001097          	auipc	ra,0x1
    800056d8:	b8e080e7          	jalr	-1138(ra) # 80006262 <release>
}
    800056dc:	60e2                	ld	ra,24(sp)
    800056de:	6442                	ld	s0,16(sp)
    800056e0:	64a2                	ld	s1,8(sp)
    800056e2:	6105                	addi	sp,sp,32
    800056e4:	8082                	ret
      panic("virtio_disk_intr status");
    800056e6:	00003517          	auipc	a0,0x3
    800056ea:	0d250513          	addi	a0,a0,210 # 800087b8 <syscalls+0x3e8>
    800056ee:	00000097          	auipc	ra,0x0
    800056f2:	5b2080e7          	jalr	1458(ra) # 80005ca0 <panic>

00000000800056f6 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056f6:	1141                	addi	sp,sp,-16
    800056f8:	e422                	sd	s0,8(sp)
    800056fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005700:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005704:	0037979b          	slliw	a5,a5,0x3
    80005708:	02004737          	lui	a4,0x2004
    8000570c:	97ba                	add	a5,a5,a4
    8000570e:	0200c737          	lui	a4,0x200c
    80005712:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005716:	000f4637          	lui	a2,0xf4
    8000571a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000571e:	9732                	add	a4,a4,a2
    80005720:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005722:	00259693          	slli	a3,a1,0x2
    80005726:	96ae                	add	a3,a3,a1
    80005728:	068e                	slli	a3,a3,0x3
    8000572a:	00015717          	auipc	a4,0x15
    8000572e:	81670713          	addi	a4,a4,-2026 # 80019f40 <timer_scratch>
    80005732:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005734:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005736:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005738:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000573c:	00000797          	auipc	a5,0x0
    80005740:	9a478793          	addi	a5,a5,-1628 # 800050e0 <timervec>
    80005744:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005748:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000574c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005750:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005754:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005758:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000575c:	30479073          	csrw	mie,a5
}
    80005760:	6422                	ld	s0,8(sp)
    80005762:	0141                	addi	sp,sp,16
    80005764:	8082                	ret

0000000080005766 <start>:
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e406                	sd	ra,8(sp)
    8000576a:	e022                	sd	s0,0(sp)
    8000576c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000576e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005772:	7779                	lui	a4,0xffffe
    80005774:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc67f>
    80005778:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000577a:	6705                	lui	a4,0x1
    8000577c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005780:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005782:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005786:	ffffb797          	auipc	a5,0xffffb
    8000578a:	b9878793          	addi	a5,a5,-1128 # 8000031e <main>
    8000578e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005792:	4781                	li	a5,0
    80005794:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005798:	67c1                	lui	a5,0x10
    8000579a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000579c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057a0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057a4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057a8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ac:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057b0:	57fd                	li	a5,-1
    800057b2:	83a9                	srli	a5,a5,0xa
    800057b4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057b8:	47bd                	li	a5,15
    800057ba:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057be:	00000097          	auipc	ra,0x0
    800057c2:	f38080e7          	jalr	-200(ra) # 800056f6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057c6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057ca:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057cc:	823e                	mv	tp,a5
  asm volatile("mret");
    800057ce:	30200073          	mret
}
    800057d2:	60a2                	ld	ra,8(sp)
    800057d4:	6402                	ld	s0,0(sp)
    800057d6:	0141                	addi	sp,sp,16
    800057d8:	8082                	ret

00000000800057da <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057da:	715d                	addi	sp,sp,-80
    800057dc:	e486                	sd	ra,72(sp)
    800057de:	e0a2                	sd	s0,64(sp)
    800057e0:	fc26                	sd	s1,56(sp)
    800057e2:	f84a                	sd	s2,48(sp)
    800057e4:	f44e                	sd	s3,40(sp)
    800057e6:	f052                	sd	s4,32(sp)
    800057e8:	ec56                	sd	s5,24(sp)
    800057ea:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057ec:	04c05763          	blez	a2,8000583a <consolewrite+0x60>
    800057f0:	8a2a                	mv	s4,a0
    800057f2:	84ae                	mv	s1,a1
    800057f4:	89b2                	mv	s3,a2
    800057f6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057f8:	5afd                	li	s5,-1
    800057fa:	4685                	li	a3,1
    800057fc:	8626                	mv	a2,s1
    800057fe:	85d2                	mv	a1,s4
    80005800:	fbf40513          	addi	a0,s0,-65
    80005804:	ffffc097          	auipc	ra,0xffffc
    80005808:	16c080e7          	jalr	364(ra) # 80001970 <either_copyin>
    8000580c:	01550d63          	beq	a0,s5,80005826 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005810:	fbf44503          	lbu	a0,-65(s0)
    80005814:	00000097          	auipc	ra,0x0
    80005818:	7e0080e7          	jalr	2016(ra) # 80005ff4 <uartputc>
  for(i = 0; i < n; i++){
    8000581c:	2905                	addiw	s2,s2,1
    8000581e:	0485                	addi	s1,s1,1
    80005820:	fd299de3          	bne	s3,s2,800057fa <consolewrite+0x20>
    80005824:	894e                	mv	s2,s3
  }

  return i;
}
    80005826:	854a                	mv	a0,s2
    80005828:	60a6                	ld	ra,72(sp)
    8000582a:	6406                	ld	s0,64(sp)
    8000582c:	74e2                	ld	s1,56(sp)
    8000582e:	7942                	ld	s2,48(sp)
    80005830:	79a2                	ld	s3,40(sp)
    80005832:	7a02                	ld	s4,32(sp)
    80005834:	6ae2                	ld	s5,24(sp)
    80005836:	6161                	addi	sp,sp,80
    80005838:	8082                	ret
  for(i = 0; i < n; i++){
    8000583a:	4901                	li	s2,0
    8000583c:	b7ed                	j	80005826 <consolewrite+0x4c>

000000008000583e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000583e:	711d                	addi	sp,sp,-96
    80005840:	ec86                	sd	ra,88(sp)
    80005842:	e8a2                	sd	s0,80(sp)
    80005844:	e4a6                	sd	s1,72(sp)
    80005846:	e0ca                	sd	s2,64(sp)
    80005848:	fc4e                	sd	s3,56(sp)
    8000584a:	f852                	sd	s4,48(sp)
    8000584c:	f456                	sd	s5,40(sp)
    8000584e:	f05a                	sd	s6,32(sp)
    80005850:	ec5e                	sd	s7,24(sp)
    80005852:	1080                	addi	s0,sp,96
    80005854:	8aaa                	mv	s5,a0
    80005856:	8a2e                	mv	s4,a1
    80005858:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000585a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000585e:	0001d517          	auipc	a0,0x1d
    80005862:	82250513          	addi	a0,a0,-2014 # 80022080 <cons>
    80005866:	00001097          	auipc	ra,0x1
    8000586a:	948080e7          	jalr	-1720(ra) # 800061ae <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000586e:	0001d497          	auipc	s1,0x1d
    80005872:	81248493          	addi	s1,s1,-2030 # 80022080 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005876:	0001d917          	auipc	s2,0x1d
    8000587a:	8a290913          	addi	s2,s2,-1886 # 80022118 <cons+0x98>
  while(n > 0){
    8000587e:	09305263          	blez	s3,80005902 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005882:	0984a783          	lw	a5,152(s1)
    80005886:	09c4a703          	lw	a4,156(s1)
    8000588a:	02f71763          	bne	a4,a5,800058b8 <consoleread+0x7a>
      if(killed(myproc())){
    8000588e:	ffffb097          	auipc	ra,0xffffb
    80005892:	5c4080e7          	jalr	1476(ra) # 80000e52 <myproc>
    80005896:	ffffc097          	auipc	ra,0xffffc
    8000589a:	f24080e7          	jalr	-220(ra) # 800017ba <killed>
    8000589e:	ed2d                	bnez	a0,80005918 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800058a0:	85a6                	mv	a1,s1
    800058a2:	854a                	mv	a0,s2
    800058a4:	ffffc097          	auipc	ra,0xffffc
    800058a8:	c6e080e7          	jalr	-914(ra) # 80001512 <sleep>
    while(cons.r == cons.w){
    800058ac:	0984a783          	lw	a5,152(s1)
    800058b0:	09c4a703          	lw	a4,156(s1)
    800058b4:	fcf70de3          	beq	a4,a5,8000588e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800058b8:	0001c717          	auipc	a4,0x1c
    800058bc:	7c870713          	addi	a4,a4,1992 # 80022080 <cons>
    800058c0:	0017869b          	addiw	a3,a5,1
    800058c4:	08d72c23          	sw	a3,152(a4)
    800058c8:	07f7f693          	andi	a3,a5,127
    800058cc:	9736                	add	a4,a4,a3
    800058ce:	01874703          	lbu	a4,24(a4)
    800058d2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058d6:	4691                	li	a3,4
    800058d8:	06db8463          	beq	s7,a3,80005940 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058dc:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058e0:	4685                	li	a3,1
    800058e2:	faf40613          	addi	a2,s0,-81
    800058e6:	85d2                	mv	a1,s4
    800058e8:	8556                	mv	a0,s5
    800058ea:	ffffc097          	auipc	ra,0xffffc
    800058ee:	030080e7          	jalr	48(ra) # 8000191a <either_copyout>
    800058f2:	57fd                	li	a5,-1
    800058f4:	00f50763          	beq	a0,a5,80005902 <consoleread+0xc4>
      break;

    dst++;
    800058f8:	0a05                	addi	s4,s4,1
    --n;
    800058fa:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800058fc:	47a9                	li	a5,10
    800058fe:	f8fb90e3          	bne	s7,a5,8000587e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005902:	0001c517          	auipc	a0,0x1c
    80005906:	77e50513          	addi	a0,a0,1918 # 80022080 <cons>
    8000590a:	00001097          	auipc	ra,0x1
    8000590e:	958080e7          	jalr	-1704(ra) # 80006262 <release>

  return target - n;
    80005912:	413b053b          	subw	a0,s6,s3
    80005916:	a811                	j	8000592a <consoleread+0xec>
        release(&cons.lock);
    80005918:	0001c517          	auipc	a0,0x1c
    8000591c:	76850513          	addi	a0,a0,1896 # 80022080 <cons>
    80005920:	00001097          	auipc	ra,0x1
    80005924:	942080e7          	jalr	-1726(ra) # 80006262 <release>
        return -1;
    80005928:	557d                	li	a0,-1
}
    8000592a:	60e6                	ld	ra,88(sp)
    8000592c:	6446                	ld	s0,80(sp)
    8000592e:	64a6                	ld	s1,72(sp)
    80005930:	6906                	ld	s2,64(sp)
    80005932:	79e2                	ld	s3,56(sp)
    80005934:	7a42                	ld	s4,48(sp)
    80005936:	7aa2                	ld	s5,40(sp)
    80005938:	7b02                	ld	s6,32(sp)
    8000593a:	6be2                	ld	s7,24(sp)
    8000593c:	6125                	addi	sp,sp,96
    8000593e:	8082                	ret
      if(n < target){
    80005940:	0009871b          	sext.w	a4,s3
    80005944:	fb677fe3          	bgeu	a4,s6,80005902 <consoleread+0xc4>
        cons.r--;
    80005948:	0001c717          	auipc	a4,0x1c
    8000594c:	7cf72823          	sw	a5,2000(a4) # 80022118 <cons+0x98>
    80005950:	bf4d                	j	80005902 <consoleread+0xc4>

0000000080005952 <consputc>:
{
    80005952:	1141                	addi	sp,sp,-16
    80005954:	e406                	sd	ra,8(sp)
    80005956:	e022                	sd	s0,0(sp)
    80005958:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000595a:	10000793          	li	a5,256
    8000595e:	00f50a63          	beq	a0,a5,80005972 <consputc+0x20>
    uartputc_sync(c);
    80005962:	00000097          	auipc	ra,0x0
    80005966:	5c0080e7          	jalr	1472(ra) # 80005f22 <uartputc_sync>
}
    8000596a:	60a2                	ld	ra,8(sp)
    8000596c:	6402                	ld	s0,0(sp)
    8000596e:	0141                	addi	sp,sp,16
    80005970:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005972:	4521                	li	a0,8
    80005974:	00000097          	auipc	ra,0x0
    80005978:	5ae080e7          	jalr	1454(ra) # 80005f22 <uartputc_sync>
    8000597c:	02000513          	li	a0,32
    80005980:	00000097          	auipc	ra,0x0
    80005984:	5a2080e7          	jalr	1442(ra) # 80005f22 <uartputc_sync>
    80005988:	4521                	li	a0,8
    8000598a:	00000097          	auipc	ra,0x0
    8000598e:	598080e7          	jalr	1432(ra) # 80005f22 <uartputc_sync>
    80005992:	bfe1                	j	8000596a <consputc+0x18>

0000000080005994 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005994:	1101                	addi	sp,sp,-32
    80005996:	ec06                	sd	ra,24(sp)
    80005998:	e822                	sd	s0,16(sp)
    8000599a:	e426                	sd	s1,8(sp)
    8000599c:	e04a                	sd	s2,0(sp)
    8000599e:	1000                	addi	s0,sp,32
    800059a0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059a2:	0001c517          	auipc	a0,0x1c
    800059a6:	6de50513          	addi	a0,a0,1758 # 80022080 <cons>
    800059aa:	00001097          	auipc	ra,0x1
    800059ae:	804080e7          	jalr	-2044(ra) # 800061ae <acquire>

  switch(c){
    800059b2:	47d5                	li	a5,21
    800059b4:	0af48663          	beq	s1,a5,80005a60 <consoleintr+0xcc>
    800059b8:	0297ca63          	blt	a5,s1,800059ec <consoleintr+0x58>
    800059bc:	47a1                	li	a5,8
    800059be:	0ef48763          	beq	s1,a5,80005aac <consoleintr+0x118>
    800059c2:	47c1                	li	a5,16
    800059c4:	10f49a63          	bne	s1,a5,80005ad8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	ffe080e7          	jalr	-2(ra) # 800019c6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059d0:	0001c517          	auipc	a0,0x1c
    800059d4:	6b050513          	addi	a0,a0,1712 # 80022080 <cons>
    800059d8:	00001097          	auipc	ra,0x1
    800059dc:	88a080e7          	jalr	-1910(ra) # 80006262 <release>
}
    800059e0:	60e2                	ld	ra,24(sp)
    800059e2:	6442                	ld	s0,16(sp)
    800059e4:	64a2                	ld	s1,8(sp)
    800059e6:	6902                	ld	s2,0(sp)
    800059e8:	6105                	addi	sp,sp,32
    800059ea:	8082                	ret
  switch(c){
    800059ec:	07f00793          	li	a5,127
    800059f0:	0af48e63          	beq	s1,a5,80005aac <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059f4:	0001c717          	auipc	a4,0x1c
    800059f8:	68c70713          	addi	a4,a4,1676 # 80022080 <cons>
    800059fc:	0a072783          	lw	a5,160(a4)
    80005a00:	09872703          	lw	a4,152(a4)
    80005a04:	9f99                	subw	a5,a5,a4
    80005a06:	07f00713          	li	a4,127
    80005a0a:	fcf763e3          	bltu	a4,a5,800059d0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a0e:	47b5                	li	a5,13
    80005a10:	0cf48763          	beq	s1,a5,80005ade <consoleintr+0x14a>
      consputc(c);
    80005a14:	8526                	mv	a0,s1
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	f3c080e7          	jalr	-196(ra) # 80005952 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a1e:	0001c797          	auipc	a5,0x1c
    80005a22:	66278793          	addi	a5,a5,1634 # 80022080 <cons>
    80005a26:	0a07a683          	lw	a3,160(a5)
    80005a2a:	0016871b          	addiw	a4,a3,1
    80005a2e:	0007061b          	sext.w	a2,a4
    80005a32:	0ae7a023          	sw	a4,160(a5)
    80005a36:	07f6f693          	andi	a3,a3,127
    80005a3a:	97b6                	add	a5,a5,a3
    80005a3c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a40:	47a9                	li	a5,10
    80005a42:	0cf48563          	beq	s1,a5,80005b0c <consoleintr+0x178>
    80005a46:	4791                	li	a5,4
    80005a48:	0cf48263          	beq	s1,a5,80005b0c <consoleintr+0x178>
    80005a4c:	0001c797          	auipc	a5,0x1c
    80005a50:	6cc7a783          	lw	a5,1740(a5) # 80022118 <cons+0x98>
    80005a54:	9f1d                	subw	a4,a4,a5
    80005a56:	08000793          	li	a5,128
    80005a5a:	f6f71be3          	bne	a4,a5,800059d0 <consoleintr+0x3c>
    80005a5e:	a07d                	j	80005b0c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a60:	0001c717          	auipc	a4,0x1c
    80005a64:	62070713          	addi	a4,a4,1568 # 80022080 <cons>
    80005a68:	0a072783          	lw	a5,160(a4)
    80005a6c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a70:	0001c497          	auipc	s1,0x1c
    80005a74:	61048493          	addi	s1,s1,1552 # 80022080 <cons>
    while(cons.e != cons.w &&
    80005a78:	4929                	li	s2,10
    80005a7a:	f4f70be3          	beq	a4,a5,800059d0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a7e:	37fd                	addiw	a5,a5,-1
    80005a80:	07f7f713          	andi	a4,a5,127
    80005a84:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a86:	01874703          	lbu	a4,24(a4)
    80005a8a:	f52703e3          	beq	a4,s2,800059d0 <consoleintr+0x3c>
      cons.e--;
    80005a8e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a92:	10000513          	li	a0,256
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	ebc080e7          	jalr	-324(ra) # 80005952 <consputc>
    while(cons.e != cons.w &&
    80005a9e:	0a04a783          	lw	a5,160(s1)
    80005aa2:	09c4a703          	lw	a4,156(s1)
    80005aa6:	fcf71ce3          	bne	a4,a5,80005a7e <consoleintr+0xea>
    80005aaa:	b71d                	j	800059d0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005aac:	0001c717          	auipc	a4,0x1c
    80005ab0:	5d470713          	addi	a4,a4,1492 # 80022080 <cons>
    80005ab4:	0a072783          	lw	a5,160(a4)
    80005ab8:	09c72703          	lw	a4,156(a4)
    80005abc:	f0f70ae3          	beq	a4,a5,800059d0 <consoleintr+0x3c>
      cons.e--;
    80005ac0:	37fd                	addiw	a5,a5,-1
    80005ac2:	0001c717          	auipc	a4,0x1c
    80005ac6:	64f72f23          	sw	a5,1630(a4) # 80022120 <cons+0xa0>
      consputc(BACKSPACE);
    80005aca:	10000513          	li	a0,256
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	e84080e7          	jalr	-380(ra) # 80005952 <consputc>
    80005ad6:	bded                	j	800059d0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ad8:	ee048ce3          	beqz	s1,800059d0 <consoleintr+0x3c>
    80005adc:	bf21                	j	800059f4 <consoleintr+0x60>
      consputc(c);
    80005ade:	4529                	li	a0,10
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	e72080e7          	jalr	-398(ra) # 80005952 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ae8:	0001c797          	auipc	a5,0x1c
    80005aec:	59878793          	addi	a5,a5,1432 # 80022080 <cons>
    80005af0:	0a07a703          	lw	a4,160(a5)
    80005af4:	0017069b          	addiw	a3,a4,1
    80005af8:	0006861b          	sext.w	a2,a3
    80005afc:	0ad7a023          	sw	a3,160(a5)
    80005b00:	07f77713          	andi	a4,a4,127
    80005b04:	97ba                	add	a5,a5,a4
    80005b06:	4729                	li	a4,10
    80005b08:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b0c:	0001c797          	auipc	a5,0x1c
    80005b10:	60c7a823          	sw	a2,1552(a5) # 8002211c <cons+0x9c>
        wakeup(&cons.r);
    80005b14:	0001c517          	auipc	a0,0x1c
    80005b18:	60450513          	addi	a0,a0,1540 # 80022118 <cons+0x98>
    80005b1c:	ffffc097          	auipc	ra,0xffffc
    80005b20:	a5a080e7          	jalr	-1446(ra) # 80001576 <wakeup>
    80005b24:	b575                	j	800059d0 <consoleintr+0x3c>

0000000080005b26 <consoleinit>:

void
consoleinit(void)
{
    80005b26:	1141                	addi	sp,sp,-16
    80005b28:	e406                	sd	ra,8(sp)
    80005b2a:	e022                	sd	s0,0(sp)
    80005b2c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b2e:	00003597          	auipc	a1,0x3
    80005b32:	ca258593          	addi	a1,a1,-862 # 800087d0 <syscalls+0x400>
    80005b36:	0001c517          	auipc	a0,0x1c
    80005b3a:	54a50513          	addi	a0,a0,1354 # 80022080 <cons>
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	5e0080e7          	jalr	1504(ra) # 8000611e <initlock>

  uartinit();
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	38c080e7          	jalr	908(ra) # 80005ed2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b4e:	00013797          	auipc	a5,0x13
    80005b52:	25a78793          	addi	a5,a5,602 # 80018da8 <devsw>
    80005b56:	00000717          	auipc	a4,0x0
    80005b5a:	ce870713          	addi	a4,a4,-792 # 8000583e <consoleread>
    80005b5e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b60:	00000717          	auipc	a4,0x0
    80005b64:	c7a70713          	addi	a4,a4,-902 # 800057da <consolewrite>
    80005b68:	ef98                	sd	a4,24(a5)
}
    80005b6a:	60a2                	ld	ra,8(sp)
    80005b6c:	6402                	ld	s0,0(sp)
    80005b6e:	0141                	addi	sp,sp,16
    80005b70:	8082                	ret

0000000080005b72 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b72:	7179                	addi	sp,sp,-48
    80005b74:	f406                	sd	ra,40(sp)
    80005b76:	f022                	sd	s0,32(sp)
    80005b78:	ec26                	sd	s1,24(sp)
    80005b7a:	e84a                	sd	s2,16(sp)
    80005b7c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b7e:	c219                	beqz	a2,80005b84 <printint+0x12>
    80005b80:	08054763          	bltz	a0,80005c0e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b84:	2501                	sext.w	a0,a0
    80005b86:	4881                	li	a7,0
    80005b88:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b8c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b8e:	2581                	sext.w	a1,a1
    80005b90:	00003617          	auipc	a2,0x3
    80005b94:	c8860613          	addi	a2,a2,-888 # 80008818 <digits>
    80005b98:	883a                	mv	a6,a4
    80005b9a:	2705                	addiw	a4,a4,1
    80005b9c:	02b577bb          	remuw	a5,a0,a1
    80005ba0:	1782                	slli	a5,a5,0x20
    80005ba2:	9381                	srli	a5,a5,0x20
    80005ba4:	97b2                	add	a5,a5,a2
    80005ba6:	0007c783          	lbu	a5,0(a5)
    80005baa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bae:	0005079b          	sext.w	a5,a0
    80005bb2:	02b5553b          	divuw	a0,a0,a1
    80005bb6:	0685                	addi	a3,a3,1
    80005bb8:	feb7f0e3          	bgeu	a5,a1,80005b98 <printint+0x26>

  if(sign)
    80005bbc:	00088c63          	beqz	a7,80005bd4 <printint+0x62>
    buf[i++] = '-';
    80005bc0:	fe070793          	addi	a5,a4,-32
    80005bc4:	00878733          	add	a4,a5,s0
    80005bc8:	02d00793          	li	a5,45
    80005bcc:	fef70823          	sb	a5,-16(a4)
    80005bd0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bd4:	02e05763          	blez	a4,80005c02 <printint+0x90>
    80005bd8:	fd040793          	addi	a5,s0,-48
    80005bdc:	00e784b3          	add	s1,a5,a4
    80005be0:	fff78913          	addi	s2,a5,-1
    80005be4:	993a                	add	s2,s2,a4
    80005be6:	377d                	addiw	a4,a4,-1
    80005be8:	1702                	slli	a4,a4,0x20
    80005bea:	9301                	srli	a4,a4,0x20
    80005bec:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bf0:	fff4c503          	lbu	a0,-1(s1)
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	d5e080e7          	jalr	-674(ra) # 80005952 <consputc>
  while(--i >= 0)
    80005bfc:	14fd                	addi	s1,s1,-1
    80005bfe:	ff2499e3          	bne	s1,s2,80005bf0 <printint+0x7e>
}
    80005c02:	70a2                	ld	ra,40(sp)
    80005c04:	7402                	ld	s0,32(sp)
    80005c06:	64e2                	ld	s1,24(sp)
    80005c08:	6942                	ld	s2,16(sp)
    80005c0a:	6145                	addi	sp,sp,48
    80005c0c:	8082                	ret
    x = -xx;
    80005c0e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c12:	4885                	li	a7,1
    x = -xx;
    80005c14:	bf95                	j	80005b88 <printint+0x16>

0000000080005c16 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c16:	1101                	addi	sp,sp,-32
    80005c18:	ec06                	sd	ra,24(sp)
    80005c1a:	e822                	sd	s0,16(sp)
    80005c1c:	e426                	sd	s1,8(sp)
    80005c1e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c20:	0001c497          	auipc	s1,0x1c
    80005c24:	50848493          	addi	s1,s1,1288 # 80022128 <pr>
    80005c28:	00003597          	auipc	a1,0x3
    80005c2c:	bb058593          	addi	a1,a1,-1104 # 800087d8 <syscalls+0x408>
    80005c30:	8526                	mv	a0,s1
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	4ec080e7          	jalr	1260(ra) # 8000611e <initlock>
  pr.locking = 1;
    80005c3a:	4785                	li	a5,1
    80005c3c:	cc9c                	sw	a5,24(s1)
}
    80005c3e:	60e2                	ld	ra,24(sp)
    80005c40:	6442                	ld	s0,16(sp)
    80005c42:	64a2                	ld	s1,8(sp)
    80005c44:	6105                	addi	sp,sp,32
    80005c46:	8082                	ret

0000000080005c48 <backtrace>:


void  /*recause to implement*/
backtrace(void){
    80005c48:	7179                	addi	sp,sp,-48
    80005c4a:	f406                	sd	ra,40(sp)
    80005c4c:	f022                	sd	s0,32(sp)
    80005c4e:	ec26                	sd	s1,24(sp)
    80005c50:	e84a                	sd	s2,16(sp)
    80005c52:	e44e                	sd	s3,8(sp)
    80005c54:	1800                	addi	s0,sp,48
  
  printf("backtrace:\n");
    80005c56:	00003517          	auipc	a0,0x3
    80005c5a:	b8a50513          	addi	a0,a0,-1142 # 800087e0 <syscalls+0x410>
    80005c5e:	00000097          	auipc	ra,0x0
    80005c62:	094080e7          	jalr	148(ra) # 80005cf2 <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80005c66:	8922                	mv	s2,s0
  uint64 *fp = (uint64*)r_fp();
    80005c68:	84ca                	mv	s1,s2
  uint64 *end_fp = (uint64*)PGROUNDDOWN((uint64)fp);
    80005c6a:	77fd                	lui	a5,0xfffff
    80005c6c:	00f97933          	and	s2,s2,a5
  while(1){
    if(fp < end_fp)break;
    80005c70:	0324e163          	bltu	s1,s2,80005c92 <backtrace+0x4a>
    printf("%p\n", fp[-1]);
    80005c74:	00003997          	auipc	s3,0x3
    80005c78:	b7c98993          	addi	s3,s3,-1156 # 800087f0 <syscalls+0x420>
    80005c7c:	ff84b583          	ld	a1,-8(s1)
    80005c80:	854e                	mv	a0,s3
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	070080e7          	jalr	112(ra) # 80005cf2 <printf>
    fp = (uint64*)fp[-2];
    80005c8a:	ff04b483          	ld	s1,-16(s1)
    if(fp < end_fp)break;
    80005c8e:	ff24f7e3          	bgeu	s1,s2,80005c7c <backtrace+0x34>
  }
  return;
  /*TODO*/
   
    80005c92:	70a2                	ld	ra,40(sp)
    80005c94:	7402                	ld	s0,32(sp)
    80005c96:	64e2                	ld	s1,24(sp)
    80005c98:	6942                	ld	s2,16(sp)
    80005c9a:	69a2                	ld	s3,8(sp)
    80005c9c:	6145                	addi	sp,sp,48
    80005c9e:	8082                	ret

0000000080005ca0 <panic>:
{
    80005ca0:	1101                	addi	sp,sp,-32
    80005ca2:	ec06                	sd	ra,24(sp)
    80005ca4:	e822                	sd	s0,16(sp)
    80005ca6:	e426                	sd	s1,8(sp)
    80005ca8:	1000                	addi	s0,sp,32
    80005caa:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cac:	0001c797          	auipc	a5,0x1c
    80005cb0:	4807aa23          	sw	zero,1172(a5) # 80022140 <pr+0x18>
  printf("panic: ");
    80005cb4:	00003517          	auipc	a0,0x3
    80005cb8:	b4450513          	addi	a0,a0,-1212 # 800087f8 <syscalls+0x428>
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	036080e7          	jalr	54(ra) # 80005cf2 <printf>
  printf(s);
    80005cc4:	8526                	mv	a0,s1
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	02c080e7          	jalr	44(ra) # 80005cf2 <printf>
  printf("\n");
    80005cce:	00002517          	auipc	a0,0x2
    80005cd2:	37a50513          	addi	a0,a0,890 # 80008048 <etext+0x48>
    80005cd6:	00000097          	auipc	ra,0x0
    80005cda:	01c080e7          	jalr	28(ra) # 80005cf2 <printf>
  backtrace();
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	f6a080e7          	jalr	-150(ra) # 80005c48 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005ce6:	4785                	li	a5,1
    80005ce8:	00003717          	auipc	a4,0x3
    80005cec:	c0f72a23          	sw	a5,-1004(a4) # 800088fc <panicked>
  for(;;)
    80005cf0:	a001                	j	80005cf0 <panic+0x50>

0000000080005cf2 <printf>:
{
    80005cf2:	7131                	addi	sp,sp,-192
    80005cf4:	fc86                	sd	ra,120(sp)
    80005cf6:	f8a2                	sd	s0,112(sp)
    80005cf8:	f4a6                	sd	s1,104(sp)
    80005cfa:	f0ca                	sd	s2,96(sp)
    80005cfc:	ecce                	sd	s3,88(sp)
    80005cfe:	e8d2                	sd	s4,80(sp)
    80005d00:	e4d6                	sd	s5,72(sp)
    80005d02:	e0da                	sd	s6,64(sp)
    80005d04:	fc5e                	sd	s7,56(sp)
    80005d06:	f862                	sd	s8,48(sp)
    80005d08:	f466                	sd	s9,40(sp)
    80005d0a:	f06a                	sd	s10,32(sp)
    80005d0c:	ec6e                	sd	s11,24(sp)
    80005d0e:	0100                	addi	s0,sp,128
    80005d10:	8a2a                	mv	s4,a0
    80005d12:	e40c                	sd	a1,8(s0)
    80005d14:	e810                	sd	a2,16(s0)
    80005d16:	ec14                	sd	a3,24(s0)
    80005d18:	f018                	sd	a4,32(s0)
    80005d1a:	f41c                	sd	a5,40(s0)
    80005d1c:	03043823          	sd	a6,48(s0)
    80005d20:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d24:	0001cd97          	auipc	s11,0x1c
    80005d28:	41cdad83          	lw	s11,1052(s11) # 80022140 <pr+0x18>
  if(locking)
    80005d2c:	020d9b63          	bnez	s11,80005d62 <printf+0x70>
  if (fmt == 0)
    80005d30:	040a0263          	beqz	s4,80005d74 <printf+0x82>
  va_start(ap, fmt);
    80005d34:	00840793          	addi	a5,s0,8
    80005d38:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3c:	000a4503          	lbu	a0,0(s4)
    80005d40:	14050f63          	beqz	a0,80005e9e <printf+0x1ac>
    80005d44:	4981                	li	s3,0
    if(c != '%'){
    80005d46:	02500a93          	li	s5,37
    switch(c){
    80005d4a:	07000b93          	li	s7,112
  consputc('x');
    80005d4e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d50:	00003b17          	auipc	s6,0x3
    80005d54:	ac8b0b13          	addi	s6,s6,-1336 # 80008818 <digits>
    switch(c){
    80005d58:	07300c93          	li	s9,115
    80005d5c:	06400c13          	li	s8,100
    80005d60:	a82d                	j	80005d9a <printf+0xa8>
    acquire(&pr.lock);
    80005d62:	0001c517          	auipc	a0,0x1c
    80005d66:	3c650513          	addi	a0,a0,966 # 80022128 <pr>
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	444080e7          	jalr	1092(ra) # 800061ae <acquire>
    80005d72:	bf7d                	j	80005d30 <printf+0x3e>
    panic("null fmt");
    80005d74:	00003517          	auipc	a0,0x3
    80005d78:	a9450513          	addi	a0,a0,-1388 # 80008808 <syscalls+0x438>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	f24080e7          	jalr	-220(ra) # 80005ca0 <panic>
      consputc(c);
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	bce080e7          	jalr	-1074(ra) # 80005952 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8c:	2985                	addiw	s3,s3,1
    80005d8e:	013a07b3          	add	a5,s4,s3
    80005d92:	0007c503          	lbu	a0,0(a5)
    80005d96:	10050463          	beqz	a0,80005e9e <printf+0x1ac>
    if(c != '%'){
    80005d9a:	ff5515e3          	bne	a0,s5,80005d84 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d9e:	2985                	addiw	s3,s3,1
    80005da0:	013a07b3          	add	a5,s4,s3
    80005da4:	0007c783          	lbu	a5,0(a5)
    80005da8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dac:	cbed                	beqz	a5,80005e9e <printf+0x1ac>
    switch(c){
    80005dae:	05778a63          	beq	a5,s7,80005e02 <printf+0x110>
    80005db2:	02fbf663          	bgeu	s7,a5,80005dde <printf+0xec>
    80005db6:	09978863          	beq	a5,s9,80005e46 <printf+0x154>
    80005dba:	07800713          	li	a4,120
    80005dbe:	0ce79563          	bne	a5,a4,80005e88 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005dc2:	f8843783          	ld	a5,-120(s0)
    80005dc6:	00878713          	addi	a4,a5,8
    80005dca:	f8e43423          	sd	a4,-120(s0)
    80005dce:	4605                	li	a2,1
    80005dd0:	85ea                	mv	a1,s10
    80005dd2:	4388                	lw	a0,0(a5)
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	d9e080e7          	jalr	-610(ra) # 80005b72 <printint>
      break;
    80005ddc:	bf45                	j	80005d8c <printf+0x9a>
    switch(c){
    80005dde:	09578f63          	beq	a5,s5,80005e7c <printf+0x18a>
    80005de2:	0b879363          	bne	a5,s8,80005e88 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005de6:	f8843783          	ld	a5,-120(s0)
    80005dea:	00878713          	addi	a4,a5,8
    80005dee:	f8e43423          	sd	a4,-120(s0)
    80005df2:	4605                	li	a2,1
    80005df4:	45a9                	li	a1,10
    80005df6:	4388                	lw	a0,0(a5)
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	d7a080e7          	jalr	-646(ra) # 80005b72 <printint>
      break;
    80005e00:	b771                	j	80005d8c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e02:	f8843783          	ld	a5,-120(s0)
    80005e06:	00878713          	addi	a4,a5,8
    80005e0a:	f8e43423          	sd	a4,-120(s0)
    80005e0e:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e12:	03000513          	li	a0,48
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	b3c080e7          	jalr	-1220(ra) # 80005952 <consputc>
  consputc('x');
    80005e1e:	07800513          	li	a0,120
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	b30080e7          	jalr	-1232(ra) # 80005952 <consputc>
    80005e2a:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2c:	03c95793          	srli	a5,s2,0x3c
    80005e30:	97da                	add	a5,a5,s6
    80005e32:	0007c503          	lbu	a0,0(a5)
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	b1c080e7          	jalr	-1252(ra) # 80005952 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e3e:	0912                	slli	s2,s2,0x4
    80005e40:	34fd                	addiw	s1,s1,-1
    80005e42:	f4ed                	bnez	s1,80005e2c <printf+0x13a>
    80005e44:	b7a1                	j	80005d8c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e46:	f8843783          	ld	a5,-120(s0)
    80005e4a:	00878713          	addi	a4,a5,8
    80005e4e:	f8e43423          	sd	a4,-120(s0)
    80005e52:	6384                	ld	s1,0(a5)
    80005e54:	cc89                	beqz	s1,80005e6e <printf+0x17c>
      for(; *s; s++)
    80005e56:	0004c503          	lbu	a0,0(s1)
    80005e5a:	d90d                	beqz	a0,80005d8c <printf+0x9a>
        consputc(*s);
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	af6080e7          	jalr	-1290(ra) # 80005952 <consputc>
      for(; *s; s++)
    80005e64:	0485                	addi	s1,s1,1
    80005e66:	0004c503          	lbu	a0,0(s1)
    80005e6a:	f96d                	bnez	a0,80005e5c <printf+0x16a>
    80005e6c:	b705                	j	80005d8c <printf+0x9a>
        s = "(null)";
    80005e6e:	00003497          	auipc	s1,0x3
    80005e72:	99248493          	addi	s1,s1,-1646 # 80008800 <syscalls+0x430>
      for(; *s; s++)
    80005e76:	02800513          	li	a0,40
    80005e7a:	b7cd                	j	80005e5c <printf+0x16a>
      consputc('%');
    80005e7c:	8556                	mv	a0,s5
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	ad4080e7          	jalr	-1324(ra) # 80005952 <consputc>
      break;
    80005e86:	b719                	j	80005d8c <printf+0x9a>
      consputc('%');
    80005e88:	8556                	mv	a0,s5
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	ac8080e7          	jalr	-1336(ra) # 80005952 <consputc>
      consputc(c);
    80005e92:	8526                	mv	a0,s1
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	abe080e7          	jalr	-1346(ra) # 80005952 <consputc>
      break;
    80005e9c:	bdc5                	j	80005d8c <printf+0x9a>
  if(locking)
    80005e9e:	020d9163          	bnez	s11,80005ec0 <printf+0x1ce>
}
    80005ea2:	70e6                	ld	ra,120(sp)
    80005ea4:	7446                	ld	s0,112(sp)
    80005ea6:	74a6                	ld	s1,104(sp)
    80005ea8:	7906                	ld	s2,96(sp)
    80005eaa:	69e6                	ld	s3,88(sp)
    80005eac:	6a46                	ld	s4,80(sp)
    80005eae:	6aa6                	ld	s5,72(sp)
    80005eb0:	6b06                	ld	s6,64(sp)
    80005eb2:	7be2                	ld	s7,56(sp)
    80005eb4:	7c42                	ld	s8,48(sp)
    80005eb6:	7ca2                	ld	s9,40(sp)
    80005eb8:	7d02                	ld	s10,32(sp)
    80005eba:	6de2                	ld	s11,24(sp)
    80005ebc:	6129                	addi	sp,sp,192
    80005ebe:	8082                	ret
    release(&pr.lock);
    80005ec0:	0001c517          	auipc	a0,0x1c
    80005ec4:	26850513          	addi	a0,a0,616 # 80022128 <pr>
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	39a080e7          	jalr	922(ra) # 80006262 <release>
}
    80005ed0:	bfc9                	j	80005ea2 <printf+0x1b0>

0000000080005ed2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ed2:	1141                	addi	sp,sp,-16
    80005ed4:	e406                	sd	ra,8(sp)
    80005ed6:	e022                	sd	s0,0(sp)
    80005ed8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eda:	100007b7          	lui	a5,0x10000
    80005ede:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ee2:	f8000713          	li	a4,-128
    80005ee6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005eea:	470d                	li	a4,3
    80005eec:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ef0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ef4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ef8:	469d                	li	a3,7
    80005efa:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005efe:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f02:	00003597          	auipc	a1,0x3
    80005f06:	92e58593          	addi	a1,a1,-1746 # 80008830 <digits+0x18>
    80005f0a:	0001c517          	auipc	a0,0x1c
    80005f0e:	23e50513          	addi	a0,a0,574 # 80022148 <uart_tx_lock>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	20c080e7          	jalr	524(ra) # 8000611e <initlock>
}
    80005f1a:	60a2                	ld	ra,8(sp)
    80005f1c:	6402                	ld	s0,0(sp)
    80005f1e:	0141                	addi	sp,sp,16
    80005f20:	8082                	ret

0000000080005f22 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f22:	1101                	addi	sp,sp,-32
    80005f24:	ec06                	sd	ra,24(sp)
    80005f26:	e822                	sd	s0,16(sp)
    80005f28:	e426                	sd	s1,8(sp)
    80005f2a:	1000                	addi	s0,sp,32
    80005f2c:	84aa                	mv	s1,a0
  push_off();
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	234080e7          	jalr	564(ra) # 80006162 <push_off>

  if(panicked){
    80005f36:	00003797          	auipc	a5,0x3
    80005f3a:	9c67a783          	lw	a5,-1594(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f3e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f42:	c391                	beqz	a5,80005f46 <uartputc_sync+0x24>
    for(;;)
    80005f44:	a001                	j	80005f44 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f46:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f4a:	0207f793          	andi	a5,a5,32
    80005f4e:	dfe5                	beqz	a5,80005f46 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f50:	0ff4f513          	zext.b	a0,s1
    80005f54:	100007b7          	lui	a5,0x10000
    80005f58:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	2a6080e7          	jalr	678(ra) # 80006202 <pop_off>
}
    80005f64:	60e2                	ld	ra,24(sp)
    80005f66:	6442                	ld	s0,16(sp)
    80005f68:	64a2                	ld	s1,8(sp)
    80005f6a:	6105                	addi	sp,sp,32
    80005f6c:	8082                	ret

0000000080005f6e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f6e:	00003797          	auipc	a5,0x3
    80005f72:	9927b783          	ld	a5,-1646(a5) # 80008900 <uart_tx_r>
    80005f76:	00003717          	auipc	a4,0x3
    80005f7a:	99273703          	ld	a4,-1646(a4) # 80008908 <uart_tx_w>
    80005f7e:	06f70a63          	beq	a4,a5,80005ff2 <uartstart+0x84>
{
    80005f82:	7139                	addi	sp,sp,-64
    80005f84:	fc06                	sd	ra,56(sp)
    80005f86:	f822                	sd	s0,48(sp)
    80005f88:	f426                	sd	s1,40(sp)
    80005f8a:	f04a                	sd	s2,32(sp)
    80005f8c:	ec4e                	sd	s3,24(sp)
    80005f8e:	e852                	sd	s4,16(sp)
    80005f90:	e456                	sd	s5,8(sp)
    80005f92:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f94:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f98:	0001ca17          	auipc	s4,0x1c
    80005f9c:	1b0a0a13          	addi	s4,s4,432 # 80022148 <uart_tx_lock>
    uart_tx_r += 1;
    80005fa0:	00003497          	auipc	s1,0x3
    80005fa4:	96048493          	addi	s1,s1,-1696 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fa8:	00003997          	auipc	s3,0x3
    80005fac:	96098993          	addi	s3,s3,-1696 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fb4:	02077713          	andi	a4,a4,32
    80005fb8:	c705                	beqz	a4,80005fe0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fba:	01f7f713          	andi	a4,a5,31
    80005fbe:	9752                	add	a4,a4,s4
    80005fc0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fc4:	0785                	addi	a5,a5,1
    80005fc6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fc8:	8526                	mv	a0,s1
    80005fca:	ffffb097          	auipc	ra,0xffffb
    80005fce:	5ac080e7          	jalr	1452(ra) # 80001576 <wakeup>
    
    WriteReg(THR, c);
    80005fd2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fd6:	609c                	ld	a5,0(s1)
    80005fd8:	0009b703          	ld	a4,0(s3)
    80005fdc:	fcf71ae3          	bne	a4,a5,80005fb0 <uartstart+0x42>
  }
}
    80005fe0:	70e2                	ld	ra,56(sp)
    80005fe2:	7442                	ld	s0,48(sp)
    80005fe4:	74a2                	ld	s1,40(sp)
    80005fe6:	7902                	ld	s2,32(sp)
    80005fe8:	69e2                	ld	s3,24(sp)
    80005fea:	6a42                	ld	s4,16(sp)
    80005fec:	6aa2                	ld	s5,8(sp)
    80005fee:	6121                	addi	sp,sp,64
    80005ff0:	8082                	ret
    80005ff2:	8082                	ret

0000000080005ff4 <uartputc>:
{
    80005ff4:	7179                	addi	sp,sp,-48
    80005ff6:	f406                	sd	ra,40(sp)
    80005ff8:	f022                	sd	s0,32(sp)
    80005ffa:	ec26                	sd	s1,24(sp)
    80005ffc:	e84a                	sd	s2,16(sp)
    80005ffe:	e44e                	sd	s3,8(sp)
    80006000:	e052                	sd	s4,0(sp)
    80006002:	1800                	addi	s0,sp,48
    80006004:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006006:	0001c517          	auipc	a0,0x1c
    8000600a:	14250513          	addi	a0,a0,322 # 80022148 <uart_tx_lock>
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	1a0080e7          	jalr	416(ra) # 800061ae <acquire>
  if(panicked){
    80006016:	00003797          	auipc	a5,0x3
    8000601a:	8e67a783          	lw	a5,-1818(a5) # 800088fc <panicked>
    8000601e:	e7c9                	bnez	a5,800060a8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006020:	00003717          	auipc	a4,0x3
    80006024:	8e873703          	ld	a4,-1816(a4) # 80008908 <uart_tx_w>
    80006028:	00003797          	auipc	a5,0x3
    8000602c:	8d87b783          	ld	a5,-1832(a5) # 80008900 <uart_tx_r>
    80006030:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006034:	0001c997          	auipc	s3,0x1c
    80006038:	11498993          	addi	s3,s3,276 # 80022148 <uart_tx_lock>
    8000603c:	00003497          	auipc	s1,0x3
    80006040:	8c448493          	addi	s1,s1,-1852 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006044:	00003917          	auipc	s2,0x3
    80006048:	8c490913          	addi	s2,s2,-1852 # 80008908 <uart_tx_w>
    8000604c:	00e79f63          	bne	a5,a4,8000606a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006050:	85ce                	mv	a1,s3
    80006052:	8526                	mv	a0,s1
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	4be080e7          	jalr	1214(ra) # 80001512 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605c:	00093703          	ld	a4,0(s2)
    80006060:	609c                	ld	a5,0(s1)
    80006062:	02078793          	addi	a5,a5,32
    80006066:	fee785e3          	beq	a5,a4,80006050 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000606a:	0001c497          	auipc	s1,0x1c
    8000606e:	0de48493          	addi	s1,s1,222 # 80022148 <uart_tx_lock>
    80006072:	01f77793          	andi	a5,a4,31
    80006076:	97a6                	add	a5,a5,s1
    80006078:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000607c:	0705                	addi	a4,a4,1
    8000607e:	00003797          	auipc	a5,0x3
    80006082:	88e7b523          	sd	a4,-1910(a5) # 80008908 <uart_tx_w>
  uartstart();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	ee8080e7          	jalr	-280(ra) # 80005f6e <uartstart>
  release(&uart_tx_lock);
    8000608e:	8526                	mv	a0,s1
    80006090:	00000097          	auipc	ra,0x0
    80006094:	1d2080e7          	jalr	466(ra) # 80006262 <release>
}
    80006098:	70a2                	ld	ra,40(sp)
    8000609a:	7402                	ld	s0,32(sp)
    8000609c:	64e2                	ld	s1,24(sp)
    8000609e:	6942                	ld	s2,16(sp)
    800060a0:	69a2                	ld	s3,8(sp)
    800060a2:	6a02                	ld	s4,0(sp)
    800060a4:	6145                	addi	sp,sp,48
    800060a6:	8082                	ret
    for(;;)
    800060a8:	a001                	j	800060a8 <uartputc+0xb4>

00000000800060aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060aa:	1141                	addi	sp,sp,-16
    800060ac:	e422                	sd	s0,8(sp)
    800060ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060b0:	100007b7          	lui	a5,0x10000
    800060b4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060b8:	8b85                	andi	a5,a5,1
    800060ba:	cb81                	beqz	a5,800060ca <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060bc:	100007b7          	lui	a5,0x10000
    800060c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060c4:	6422                	ld	s0,8(sp)
    800060c6:	0141                	addi	sp,sp,16
    800060c8:	8082                	ret
    return -1;
    800060ca:	557d                	li	a0,-1
    800060cc:	bfe5                	j	800060c4 <uartgetc+0x1a>

00000000800060ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060ce:	1101                	addi	sp,sp,-32
    800060d0:	ec06                	sd	ra,24(sp)
    800060d2:	e822                	sd	s0,16(sp)
    800060d4:	e426                	sd	s1,8(sp)
    800060d6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060d8:	54fd                	li	s1,-1
    800060da:	a029                	j	800060e4 <uartintr+0x16>
      break;
    consoleintr(c);
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	8b8080e7          	jalr	-1864(ra) # 80005994 <consoleintr>
    int c = uartgetc();
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	fc6080e7          	jalr	-58(ra) # 800060aa <uartgetc>
    if(c == -1)
    800060ec:	fe9518e3          	bne	a0,s1,800060dc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060f0:	0001c497          	auipc	s1,0x1c
    800060f4:	05848493          	addi	s1,s1,88 # 80022148 <uart_tx_lock>
    800060f8:	8526                	mv	a0,s1
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	0b4080e7          	jalr	180(ra) # 800061ae <acquire>
  uartstart();
    80006102:	00000097          	auipc	ra,0x0
    80006106:	e6c080e7          	jalr	-404(ra) # 80005f6e <uartstart>
  release(&uart_tx_lock);
    8000610a:	8526                	mv	a0,s1
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	156080e7          	jalr	342(ra) # 80006262 <release>
}
    80006114:	60e2                	ld	ra,24(sp)
    80006116:	6442                	ld	s0,16(sp)
    80006118:	64a2                	ld	s1,8(sp)
    8000611a:	6105                	addi	sp,sp,32
    8000611c:	8082                	ret

000000008000611e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000611e:	1141                	addi	sp,sp,-16
    80006120:	e422                	sd	s0,8(sp)
    80006122:	0800                	addi	s0,sp,16
  lk->name = name;
    80006124:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006126:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000612a:	00053823          	sd	zero,16(a0)
}
    8000612e:	6422                	ld	s0,8(sp)
    80006130:	0141                	addi	sp,sp,16
    80006132:	8082                	ret

0000000080006134 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006134:	411c                	lw	a5,0(a0)
    80006136:	e399                	bnez	a5,8000613c <holding+0x8>
    80006138:	4501                	li	a0,0
  return r;
}
    8000613a:	8082                	ret
{
    8000613c:	1101                	addi	sp,sp,-32
    8000613e:	ec06                	sd	ra,24(sp)
    80006140:	e822                	sd	s0,16(sp)
    80006142:	e426                	sd	s1,8(sp)
    80006144:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006146:	6904                	ld	s1,16(a0)
    80006148:	ffffb097          	auipc	ra,0xffffb
    8000614c:	cee080e7          	jalr	-786(ra) # 80000e36 <mycpu>
    80006150:	40a48533          	sub	a0,s1,a0
    80006154:	00153513          	seqz	a0,a0
}
    80006158:	60e2                	ld	ra,24(sp)
    8000615a:	6442                	ld	s0,16(sp)
    8000615c:	64a2                	ld	s1,8(sp)
    8000615e:	6105                	addi	sp,sp,32
    80006160:	8082                	ret

0000000080006162 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006162:	1101                	addi	sp,sp,-32
    80006164:	ec06                	sd	ra,24(sp)
    80006166:	e822                	sd	s0,16(sp)
    80006168:	e426                	sd	s1,8(sp)
    8000616a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000616c:	100024f3          	csrr	s1,sstatus
    80006170:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006174:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006176:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000617a:	ffffb097          	auipc	ra,0xffffb
    8000617e:	cbc080e7          	jalr	-836(ra) # 80000e36 <mycpu>
    80006182:	5d3c                	lw	a5,120(a0)
    80006184:	cf89                	beqz	a5,8000619e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006186:	ffffb097          	auipc	ra,0xffffb
    8000618a:	cb0080e7          	jalr	-848(ra) # 80000e36 <mycpu>
    8000618e:	5d3c                	lw	a5,120(a0)
    80006190:	2785                	addiw	a5,a5,1
    80006192:	dd3c                	sw	a5,120(a0)
}
    80006194:	60e2                	ld	ra,24(sp)
    80006196:	6442                	ld	s0,16(sp)
    80006198:	64a2                	ld	s1,8(sp)
    8000619a:	6105                	addi	sp,sp,32
    8000619c:	8082                	ret
    mycpu()->intena = old;
    8000619e:	ffffb097          	auipc	ra,0xffffb
    800061a2:	c98080e7          	jalr	-872(ra) # 80000e36 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061a6:	8085                	srli	s1,s1,0x1
    800061a8:	8885                	andi	s1,s1,1
    800061aa:	dd64                	sw	s1,124(a0)
    800061ac:	bfe9                	j	80006186 <push_off+0x24>

00000000800061ae <acquire>:
{
    800061ae:	1101                	addi	sp,sp,-32
    800061b0:	ec06                	sd	ra,24(sp)
    800061b2:	e822                	sd	s0,16(sp)
    800061b4:	e426                	sd	s1,8(sp)
    800061b6:	1000                	addi	s0,sp,32
    800061b8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	fa8080e7          	jalr	-88(ra) # 80006162 <push_off>
  if(holding(lk))
    800061c2:	8526                	mv	a0,s1
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	f70080e7          	jalr	-144(ra) # 80006134 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061cc:	4705                	li	a4,1
  if(holding(lk))
    800061ce:	e115                	bnez	a0,800061f2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d0:	87ba                	mv	a5,a4
    800061d2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061d6:	2781                	sext.w	a5,a5
    800061d8:	ffe5                	bnez	a5,800061d0 <acquire+0x22>
  __sync_synchronize();
    800061da:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	c58080e7          	jalr	-936(ra) # 80000e36 <mycpu>
    800061e6:	e888                	sd	a0,16(s1)
}
    800061e8:	60e2                	ld	ra,24(sp)
    800061ea:	6442                	ld	s0,16(sp)
    800061ec:	64a2                	ld	s1,8(sp)
    800061ee:	6105                	addi	sp,sp,32
    800061f0:	8082                	ret
    panic("acquire");
    800061f2:	00002517          	auipc	a0,0x2
    800061f6:	64650513          	addi	a0,a0,1606 # 80008838 <digits+0x20>
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	aa6080e7          	jalr	-1370(ra) # 80005ca0 <panic>

0000000080006202 <pop_off>:

void
pop_off(void)
{
    80006202:	1141                	addi	sp,sp,-16
    80006204:	e406                	sd	ra,8(sp)
    80006206:	e022                	sd	s0,0(sp)
    80006208:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000620a:	ffffb097          	auipc	ra,0xffffb
    8000620e:	c2c080e7          	jalr	-980(ra) # 80000e36 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006212:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006216:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006218:	e78d                	bnez	a5,80006242 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000621a:	5d3c                	lw	a5,120(a0)
    8000621c:	02f05b63          	blez	a5,80006252 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006220:	37fd                	addiw	a5,a5,-1
    80006222:	0007871b          	sext.w	a4,a5
    80006226:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006228:	eb09                	bnez	a4,8000623a <pop_off+0x38>
    8000622a:	5d7c                	lw	a5,124(a0)
    8000622c:	c799                	beqz	a5,8000623a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000622e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006232:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006236:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000623a:	60a2                	ld	ra,8(sp)
    8000623c:	6402                	ld	s0,0(sp)
    8000623e:	0141                	addi	sp,sp,16
    80006240:	8082                	ret
    panic("pop_off - interruptible");
    80006242:	00002517          	auipc	a0,0x2
    80006246:	5fe50513          	addi	a0,a0,1534 # 80008840 <digits+0x28>
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	a56080e7          	jalr	-1450(ra) # 80005ca0 <panic>
    panic("pop_off");
    80006252:	00002517          	auipc	a0,0x2
    80006256:	60650513          	addi	a0,a0,1542 # 80008858 <digits+0x40>
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	a46080e7          	jalr	-1466(ra) # 80005ca0 <panic>

0000000080006262 <release>:
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
    8000626c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	ec6080e7          	jalr	-314(ra) # 80006134 <holding>
    80006276:	c115                	beqz	a0,8000629a <release+0x38>
  lk->cpu = 0;
    80006278:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000627c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006280:	0f50000f          	fence	iorw,ow
    80006284:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	f7a080e7          	jalr	-134(ra) # 80006202 <pop_off>
}
    80006290:	60e2                	ld	ra,24(sp)
    80006292:	6442                	ld	s0,16(sp)
    80006294:	64a2                	ld	s1,8(sp)
    80006296:	6105                	addi	sp,sp,32
    80006298:	8082                	ret
    panic("release");
    8000629a:	00002517          	auipc	a0,0x2
    8000629e:	5c650513          	addi	a0,a0,1478 # 80008860 <digits+0x48>
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	9fe080e7          	jalr	-1538(ra) # 80005ca0 <panic>
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
