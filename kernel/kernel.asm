
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	94013103          	ld	sp,-1728(sp) # 80009940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	524060ef          	jal	ra,8000653a <start>

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
    80000030:	00023797          	auipc	a5,0x23
    80000034:	35078793          	addi	a5,a5,848 # 80023380 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	96090913          	addi	s2,s2,-1696 # 800099b0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	ec8080e7          	jalr	-312(ra) # 80006f22 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	f68080e7          	jalr	-152(ra) # 80006fd6 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	960080e7          	jalr	-1696(ra) # 800069ea <panic>

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
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f3258593          	addi	a1,a1,-206 # 80009018 <etext+0x18>
    800000ee:	0000a517          	auipc	a0,0xa
    800000f2:	8c250513          	addi	a0,a0,-1854 # 800099b0 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	d9c080e7          	jalr	-612(ra) # 80006e92 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00023517          	auipc	a0,0x23
    80000106:	27e50513          	addi	a0,a0,638 # 80023380 <end>
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
    80000124:	0000a497          	auipc	s1,0xa
    80000128:	88c48493          	addi	s1,s1,-1908 # 800099b0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	df4080e7          	jalr	-524(ra) # 80006f22 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000a517          	auipc	a0,0xa
    80000140:	87450513          	addi	a0,a0,-1932 # 800099b0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	e90080e7          	jalr	-368(ra) # 80006fd6 <release>

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
    80000168:	0000a517          	auipc	a0,0xa
    8000016c:	84850513          	addi	a0,a0,-1976 # 800099b0 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	e66080e7          	jalr	-410(ra) # 80006fd6 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbc81>
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
    8000031e:	1101                	addi	sp,sp,-32
    80000320:	ec06                	sd	ra,24(sp)
    80000322:	e822                	sd	s0,16(sp)
    80000324:	e426                	sd	s1,8(sp)
    80000326:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	b56080e7          	jalr	-1194(ra) # 80000e7e <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000330:	00009497          	auipc	s1,0x9
    80000334:	63048493          	addi	s1,s1,1584 # 80009960 <started>
  if(cpuid() == 0){
    80000338:	c531                	beqz	a0,80000384 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000033a:	8526                	mv	a0,s1
    8000033c:	00007097          	auipc	ra,0x7
    80000340:	cf8080e7          	jalr	-776(ra) # 80007034 <lockfree_read4>
    80000344:	d97d                	beqz	a0,8000033a <main+0x1c>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	b34080e7          	jalr	-1228(ra) # 80000e7e <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00009517          	auipc	a0,0x9
    80000358:	ce450513          	addi	a0,a0,-796 # 80009038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	6d8080e7          	jalr	1752(ra) # 80006a34 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0e8080e7          	jalr	232(ra) # 8000044c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7dc080e7          	jalr	2012(ra) # 80001b48 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	df0080e7          	jalr	-528(ra) # 80005164 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	024080e7          	jalr	36(ra) # 800013a0 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	576080e7          	jalr	1398(ra) # 800068fa <consoleinit>
    printfinit();
    8000038c:	00007097          	auipc	ra,0x7
    80000390:	888080e7          	jalr	-1912(ra) # 80006c14 <printfinit>
    printf("\n");
    80000394:	00009517          	auipc	a0,0x9
    80000398:	cb450513          	addi	a0,a0,-844 # 80009048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	698080e7          	jalr	1688(ra) # 80006a34 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00009517          	auipc	a0,0x9
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80009020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	688080e7          	jalr	1672(ra) # 80006a34 <printf>
    printf("\n");
    800003b4:	00009517          	auipc	a0,0x9
    800003b8:	c9450513          	addi	a0,a0,-876 # 80009048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	678080e7          	jalr	1656(ra) # 80006a34 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d1a080e7          	jalr	-742(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	366080e7          	jalr	870(ra) # 80000732 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	078080e7          	jalr	120(ra) # 8000044c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9f0080e7          	jalr	-1552(ra) # 80000dcc <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	73c080e7          	jalr	1852(ra) # 80001b20 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	75c080e7          	jalr	1884(ra) # 80001b48 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d46080e7          	jalr	-698(ra) # 8000513a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d68080e7          	jalr	-664(ra) # 80005164 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	ea4080e7          	jalr	-348(ra) # 800022a8 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	542080e7          	jalr	1346(ra) # 8000294e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	4b8080e7          	jalr	1208(ra) # 800038cc <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e56080e7          	jalr	-426(ra) # 80005272 <virtio_disk_init>
    pci_init();
    80000424:	00006097          	auipc	ra,0x6
    80000428:	01a080e7          	jalr	26(ra) # 8000643e <pci_init>
    sockinit();
    8000042c:	00006097          	auipc	ra,0x6
    80000430:	c06080e7          	jalr	-1018(ra) # 80006032 <sockinit>
    userinit();      // first user process
    80000434:	00001097          	auipc	ra,0x1
    80000438:	d4e080e7          	jalr	-690(ra) # 80001182 <userinit>
    __sync_synchronize();
    8000043c:	0ff0000f          	fence
    started = 1;
    80000440:	4785                	li	a5,1
    80000442:	00009717          	auipc	a4,0x9
    80000446:	50f72f23          	sw	a5,1310(a4) # 80009960 <started>
    8000044a:	bf0d                	j	8000037c <main+0x5e>

000000008000044c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000044c:	1141                	addi	sp,sp,-16
    8000044e:	e422                	sd	s0,8(sp)
    80000450:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000452:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000456:	00009797          	auipc	a5,0x9
    8000045a:	5127b783          	ld	a5,1298(a5) # 80009968 <kernel_pagetable>
    8000045e:	83b1                	srli	a5,a5,0xc
    80000460:	577d                	li	a4,-1
    80000462:	177e                	slli	a4,a4,0x3f
    80000464:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000466:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000046a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000046e:	6422                	ld	s0,8(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret

0000000080000474 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000474:	7139                	addi	sp,sp,-64
    80000476:	fc06                	sd	ra,56(sp)
    80000478:	f822                	sd	s0,48(sp)
    8000047a:	f426                	sd	s1,40(sp)
    8000047c:	f04a                	sd	s2,32(sp)
    8000047e:	ec4e                	sd	s3,24(sp)
    80000480:	e852                	sd	s4,16(sp)
    80000482:	e456                	sd	s5,8(sp)
    80000484:	e05a                	sd	s6,0(sp)
    80000486:	0080                	addi	s0,sp,64
    80000488:	84aa                	mv	s1,a0
    8000048a:	89ae                	mv	s3,a1
    8000048c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000048e:	57fd                	li	a5,-1
    80000490:	83e9                	srli	a5,a5,0x1a
    80000492:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000494:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000496:	04b7f263          	bgeu	a5,a1,800004da <walk+0x66>
    panic("walk");
    8000049a:	00009517          	auipc	a0,0x9
    8000049e:	bb650513          	addi	a0,a0,-1098 # 80009050 <etext+0x50>
    800004a2:	00006097          	auipc	ra,0x6
    800004a6:	548080e7          	jalr	1352(ra) # 800069ea <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004aa:	060a8663          	beqz	s5,80000516 <walk+0xa2>
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	c6c080e7          	jalr	-916(ra) # 8000011a <kalloc>
    800004b6:	84aa                	mv	s1,a0
    800004b8:	c529                	beqz	a0,80000502 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ba:	6605                	lui	a2,0x1
    800004bc:	4581                	li	a1,0
    800004be:	00000097          	auipc	ra,0x0
    800004c2:	cbc080e7          	jalr	-836(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004c6:	00c4d793          	srli	a5,s1,0xc
    800004ca:	07aa                	slli	a5,a5,0xa
    800004cc:	0017e793          	ori	a5,a5,1
    800004d0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004d4:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbc77>
    800004d6:	036a0063          	beq	s4,s6,800004f6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004da:	0149d933          	srl	s2,s3,s4
    800004de:	1ff97913          	andi	s2,s2,511
    800004e2:	090e                	slli	s2,s2,0x3
    800004e4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004e6:	00093483          	ld	s1,0(s2)
    800004ea:	0014f793          	andi	a5,s1,1
    800004ee:	dfd5                	beqz	a5,800004aa <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f0:	80a9                	srli	s1,s1,0xa
    800004f2:	04b2                	slli	s1,s1,0xc
    800004f4:	b7c5                	j	800004d4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004f6:	00c9d513          	srli	a0,s3,0xc
    800004fa:	1ff57513          	andi	a0,a0,511
    800004fe:	050e                	slli	a0,a0,0x3
    80000500:	9526                	add	a0,a0,s1
}
    80000502:	70e2                	ld	ra,56(sp)
    80000504:	7442                	ld	s0,48(sp)
    80000506:	74a2                	ld	s1,40(sp)
    80000508:	7902                	ld	s2,32(sp)
    8000050a:	69e2                	ld	s3,24(sp)
    8000050c:	6a42                	ld	s4,16(sp)
    8000050e:	6aa2                	ld	s5,8(sp)
    80000510:	6b02                	ld	s6,0(sp)
    80000512:	6121                	addi	sp,sp,64
    80000514:	8082                	ret
        return 0;
    80000516:	4501                	li	a0,0
    80000518:	b7ed                	j	80000502 <walk+0x8e>

000000008000051a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000051a:	57fd                	li	a5,-1
    8000051c:	83e9                	srli	a5,a5,0x1a
    8000051e:	00b7f463          	bgeu	a5,a1,80000526 <walkaddr+0xc>
    return 0;
    80000522:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000524:	8082                	ret
{
    80000526:	1141                	addi	sp,sp,-16
    80000528:	e406                	sd	ra,8(sp)
    8000052a:	e022                	sd	s0,0(sp)
    8000052c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000052e:	4601                	li	a2,0
    80000530:	00000097          	auipc	ra,0x0
    80000534:	f44080e7          	jalr	-188(ra) # 80000474 <walk>
  if(pte == 0)
    80000538:	c105                	beqz	a0,80000558 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000053a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000053c:	0117f693          	andi	a3,a5,17
    80000540:	4745                	li	a4,17
    return 0;
    80000542:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000544:	00e68663          	beq	a3,a4,80000550 <walkaddr+0x36>
}
    80000548:	60a2                	ld	ra,8(sp)
    8000054a:	6402                	ld	s0,0(sp)
    8000054c:	0141                	addi	sp,sp,16
    8000054e:	8082                	ret
  pa = PTE2PA(*pte);
    80000550:	83a9                	srli	a5,a5,0xa
    80000552:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000556:	bfcd                	j	80000548 <walkaddr+0x2e>
    return 0;
    80000558:	4501                	li	a0,0
    8000055a:	b7fd                	j	80000548 <walkaddr+0x2e>

000000008000055c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000055c:	715d                	addi	sp,sp,-80
    8000055e:	e486                	sd	ra,72(sp)
    80000560:	e0a2                	sd	s0,64(sp)
    80000562:	fc26                	sd	s1,56(sp)
    80000564:	f84a                	sd	s2,48(sp)
    80000566:	f44e                	sd	s3,40(sp)
    80000568:	f052                	sd	s4,32(sp)
    8000056a:	ec56                	sd	s5,24(sp)
    8000056c:	e85a                	sd	s6,16(sp)
    8000056e:	e45e                	sd	s7,8(sp)
    80000570:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000572:	c639                	beqz	a2,800005c0 <mappages+0x64>
    80000574:	8aaa                	mv	s5,a0
    80000576:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000578:	777d                	lui	a4,0xfffff
    8000057a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000057e:	fff58993          	addi	s3,a1,-1
    80000582:	99b2                	add	s3,s3,a2
    80000584:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000588:	893e                	mv	s2,a5
    8000058a:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000058e:	6b85                	lui	s7,0x1
    80000590:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000594:	4605                	li	a2,1
    80000596:	85ca                	mv	a1,s2
    80000598:	8556                	mv	a0,s5
    8000059a:	00000097          	auipc	ra,0x0
    8000059e:	eda080e7          	jalr	-294(ra) # 80000474 <walk>
    800005a2:	cd1d                	beqz	a0,800005e0 <mappages+0x84>
    if(*pte & PTE_V)
    800005a4:	611c                	ld	a5,0(a0)
    800005a6:	8b85                	andi	a5,a5,1
    800005a8:	e785                	bnez	a5,800005d0 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005aa:	80b1                	srli	s1,s1,0xc
    800005ac:	04aa                	slli	s1,s1,0xa
    800005ae:	0164e4b3          	or	s1,s1,s6
    800005b2:	0014e493          	ori	s1,s1,1
    800005b6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005b8:	05390063          	beq	s2,s3,800005f8 <mappages+0x9c>
    a += PGSIZE;
    800005bc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005be:	bfc9                	j	80000590 <mappages+0x34>
    panic("mappages: size");
    800005c0:	00009517          	auipc	a0,0x9
    800005c4:	a9850513          	addi	a0,a0,-1384 # 80009058 <etext+0x58>
    800005c8:	00006097          	auipc	ra,0x6
    800005cc:	422080e7          	jalr	1058(ra) # 800069ea <panic>
      panic("mappages: remap");
    800005d0:	00009517          	auipc	a0,0x9
    800005d4:	a9850513          	addi	a0,a0,-1384 # 80009068 <etext+0x68>
    800005d8:	00006097          	auipc	ra,0x6
    800005dc:	412080e7          	jalr	1042(ra) # 800069ea <panic>
      return -1;
    800005e0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e2:	60a6                	ld	ra,72(sp)
    800005e4:	6406                	ld	s0,64(sp)
    800005e6:	74e2                	ld	s1,56(sp)
    800005e8:	7942                	ld	s2,48(sp)
    800005ea:	79a2                	ld	s3,40(sp)
    800005ec:	7a02                	ld	s4,32(sp)
    800005ee:	6ae2                	ld	s5,24(sp)
    800005f0:	6b42                	ld	s6,16(sp)
    800005f2:	6ba2                	ld	s7,8(sp)
    800005f4:	6161                	addi	sp,sp,80
    800005f6:	8082                	ret
  return 0;
    800005f8:	4501                	li	a0,0
    800005fa:	b7e5                	j	800005e2 <mappages+0x86>

00000000800005fc <kvmmap>:
{
    800005fc:	1141                	addi	sp,sp,-16
    800005fe:	e406                	sd	ra,8(sp)
    80000600:	e022                	sd	s0,0(sp)
    80000602:	0800                	addi	s0,sp,16
    80000604:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000606:	86b2                	mv	a3,a2
    80000608:	863e                	mv	a2,a5
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	f52080e7          	jalr	-174(ra) # 8000055c <mappages>
    80000612:	e509                	bnez	a0,8000061c <kvmmap+0x20>
}
    80000614:	60a2                	ld	ra,8(sp)
    80000616:	6402                	ld	s0,0(sp)
    80000618:	0141                	addi	sp,sp,16
    8000061a:	8082                	ret
    panic("kvmmap");
    8000061c:	00009517          	auipc	a0,0x9
    80000620:	a5c50513          	addi	a0,a0,-1444 # 80009078 <etext+0x78>
    80000624:	00006097          	auipc	ra,0x6
    80000628:	3c6080e7          	jalr	966(ra) # 800069ea <panic>

000000008000062c <kvmmake>:
{
    8000062c:	1101                	addi	sp,sp,-32
    8000062e:	ec06                	sd	ra,24(sp)
    80000630:	e822                	sd	s0,16(sp)
    80000632:	e426                	sd	s1,8(sp)
    80000634:	e04a                	sd	s2,0(sp)
    80000636:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000638:	00000097          	auipc	ra,0x0
    8000063c:	ae2080e7          	jalr	-1310(ra) # 8000011a <kalloc>
    80000640:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000642:	6605                	lui	a2,0x1
    80000644:	4581                	li	a1,0
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	b34080e7          	jalr	-1228(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10000637          	lui	a2,0x10000
    80000656:	100005b7          	lui	a1,0x10000
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	fa0080e7          	jalr	-96(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	6685                	lui	a3,0x1
    80000668:	10001637          	lui	a2,0x10001
    8000066c:	100015b7          	lui	a1,0x10001
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f8a080e7          	jalr	-118(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    8000067a:	4719                	li	a4,6
    8000067c:	100006b7          	lui	a3,0x10000
    80000680:	30000637          	lui	a2,0x30000
    80000684:	300005b7          	lui	a1,0x30000
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f72080e7          	jalr	-142(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000692:	4719                	li	a4,6
    80000694:	000206b7          	lui	a3,0x20
    80000698:	40000637          	lui	a2,0x40000
    8000069c:	400005b7          	lui	a1,0x40000
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f5a080e7          	jalr	-166(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006aa:	4719                	li	a4,6
    800006ac:	004006b7          	lui	a3,0x400
    800006b0:	0c000637          	lui	a2,0xc000
    800006b4:	0c0005b7          	lui	a1,0xc000
    800006b8:	8526                	mv	a0,s1
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f42080e7          	jalr	-190(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c2:	00009917          	auipc	s2,0x9
    800006c6:	93e90913          	addi	s2,s2,-1730 # 80009000 <etext>
    800006ca:	4729                	li	a4,10
    800006cc:	80009697          	auipc	a3,0x80009
    800006d0:	93468693          	addi	a3,a3,-1740 # 9000 <_entry-0x7fff7000>
    800006d4:	4605                	li	a2,1
    800006d6:	067e                	slli	a2,a2,0x1f
    800006d8:	85b2                	mv	a1,a2
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	f20080e7          	jalr	-224(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e4:	4719                	li	a4,6
    800006e6:	46c5                	li	a3,17
    800006e8:	06ee                	slli	a3,a3,0x1b
    800006ea:	412686b3          	sub	a3,a3,s2
    800006ee:	864a                	mv	a2,s2
    800006f0:	85ca                	mv	a1,s2
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f08080e7          	jalr	-248(ra) # 800005fc <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fc:	4729                	li	a4,10
    800006fe:	6685                	lui	a3,0x1
    80000700:	00008617          	auipc	a2,0x8
    80000704:	90060613          	addi	a2,a2,-1792 # 80008000 <_trampoline>
    80000708:	040005b7          	lui	a1,0x4000
    8000070c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070e:	05b2                	slli	a1,a1,0xc
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	eea080e7          	jalr	-278(ra) # 800005fc <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	61c080e7          	jalr	1564(ra) # 80000d38 <proc_mapstacks>
}
    80000724:	8526                	mv	a0,s1
    80000726:	60e2                	ld	ra,24(sp)
    80000728:	6442                	ld	s0,16(sp)
    8000072a:	64a2                	ld	s1,8(sp)
    8000072c:	6902                	ld	s2,0(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kvminit>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	ef2080e7          	jalr	-270(ra) # 8000062c <kvmmake>
    80000742:	00009797          	auipc	a5,0x9
    80000746:	22a7b323          	sd	a0,550(a5) # 80009968 <kernel_pagetable>
}
    8000074a:	60a2                	ld	ra,8(sp)
    8000074c:	6402                	ld	s0,0(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret

0000000080000752 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000752:	715d                	addi	sp,sp,-80
    80000754:	e486                	sd	ra,72(sp)
    80000756:	e0a2                	sd	s0,64(sp)
    80000758:	fc26                	sd	s1,56(sp)
    8000075a:	f84a                	sd	s2,48(sp)
    8000075c:	f44e                	sd	s3,40(sp)
    8000075e:	f052                	sd	s4,32(sp)
    80000760:	ec56                	sd	s5,24(sp)
    80000762:	e85a                	sd	s6,16(sp)
    80000764:	e45e                	sd	s7,8(sp)
    80000766:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000768:	03459793          	slli	a5,a1,0x34
    8000076c:	e795                	bnez	a5,80000798 <uvmunmap+0x46>
    8000076e:	8a2a                	mv	s4,a0
    80000770:	892e                	mv	s2,a1
    80000772:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	0632                	slli	a2,a2,0xc
    80000776:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	6b05                	lui	s6,0x1
    8000077e:	0735eb63          	bltu	a1,s3,800007f4 <uvmunmap+0xa2>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000782:	60a6                	ld	ra,72(sp)
    80000784:	6406                	ld	s0,64(sp)
    80000786:	74e2                	ld	s1,56(sp)
    80000788:	7942                	ld	s2,48(sp)
    8000078a:	79a2                	ld	s3,40(sp)
    8000078c:	7a02                	ld	s4,32(sp)
    8000078e:	6ae2                	ld	s5,24(sp)
    80000790:	6b42                	ld	s6,16(sp)
    80000792:	6ba2                	ld	s7,8(sp)
    80000794:	6161                	addi	sp,sp,80
    80000796:	8082                	ret
    panic("uvmunmap: not aligned");
    80000798:	00009517          	auipc	a0,0x9
    8000079c:	8e850513          	addi	a0,a0,-1816 # 80009080 <etext+0x80>
    800007a0:	00006097          	auipc	ra,0x6
    800007a4:	24a080e7          	jalr	586(ra) # 800069ea <panic>
      panic("uvmunmap: walk");
    800007a8:	00009517          	auipc	a0,0x9
    800007ac:	8f050513          	addi	a0,a0,-1808 # 80009098 <etext+0x98>
    800007b0:	00006097          	auipc	ra,0x6
    800007b4:	23a080e7          	jalr	570(ra) # 800069ea <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007b8:	85ca                	mv	a1,s2
    800007ba:	00009517          	auipc	a0,0x9
    800007be:	8ee50513          	addi	a0,a0,-1810 # 800090a8 <etext+0xa8>
    800007c2:	00006097          	auipc	ra,0x6
    800007c6:	272080e7          	jalr	626(ra) # 80006a34 <printf>
      panic("uvmunmap: not mapped");
    800007ca:	00009517          	auipc	a0,0x9
    800007ce:	8ee50513          	addi	a0,a0,-1810 # 800090b8 <etext+0xb8>
    800007d2:	00006097          	auipc	ra,0x6
    800007d6:	218080e7          	jalr	536(ra) # 800069ea <panic>
      panic("uvmunmap: not a leaf");
    800007da:	00009517          	auipc	a0,0x9
    800007de:	8f650513          	addi	a0,a0,-1802 # 800090d0 <etext+0xd0>
    800007e2:	00006097          	auipc	ra,0x6
    800007e6:	208080e7          	jalr	520(ra) # 800069ea <panic>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f93979e3          	bgeu	s2,s3,80000782 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	c7a080e7          	jalr	-902(ra) # 80000474 <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d155                	beqz	a0,800007a8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    80000806:	6110                	ld	a2,0(a0)
    80000808:	00167793          	andi	a5,a2,1
    8000080c:	d7d5                	beqz	a5,800007b8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff67793          	andi	a5,a2,1023
    80000812:	fd7784e3          	beq	a5,s7,800007da <uvmunmap+0x88>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x98>
      uint64 pa = PTE2PA(*pte);
    8000081a:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    8000081c:	00c61513          	slli	a0,a2,0xc
    80000820:	fffff097          	auipc	ra,0xfffff
    80000824:	7fc080e7          	jalr	2044(ra) # 8000001c <kfree>
    80000828:	b7c9                	j	800007ea <uvmunmap+0x98>

000000008000082a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000082a:	1101                	addi	sp,sp,-32
    8000082c:	ec06                	sd	ra,24(sp)
    8000082e:	e822                	sd	s0,16(sp)
    80000830:	e426                	sd	s1,8(sp)
    80000832:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000834:	00000097          	auipc	ra,0x0
    80000838:	8e6080e7          	jalr	-1818(ra) # 8000011a <kalloc>
    8000083c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000083e:	c519                	beqz	a0,8000084c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	00000097          	auipc	ra,0x0
    80000848:	936080e7          	jalr	-1738(ra) # 8000017a <memset>
  return pagetable;
}
    8000084c:	8526                	mv	a0,s1
    8000084e:	60e2                	ld	ra,24(sp)
    80000850:	6442                	ld	s0,16(sp)
    80000852:	64a2                	ld	s1,8(sp)
    80000854:	6105                	addi	sp,sp,32
    80000856:	8082                	ret

0000000080000858 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000858:	7179                	addi	sp,sp,-48
    8000085a:	f406                	sd	ra,40(sp)
    8000085c:	f022                	sd	s0,32(sp)
    8000085e:	ec26                	sd	s1,24(sp)
    80000860:	e84a                	sd	s2,16(sp)
    80000862:	e44e                	sd	s3,8(sp)
    80000864:	e052                	sd	s4,0(sp)
    80000866:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000868:	6785                	lui	a5,0x1
    8000086a:	04f67863          	bgeu	a2,a5,800008ba <uvmfirst+0x62>
    8000086e:	8a2a                	mv	s4,a0
    80000870:	89ae                	mv	s3,a1
    80000872:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000874:	00000097          	auipc	ra,0x0
    80000878:	8a6080e7          	jalr	-1882(ra) # 8000011a <kalloc>
    8000087c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000087e:	6605                	lui	a2,0x1
    80000880:	4581                	li	a1,0
    80000882:	00000097          	auipc	ra,0x0
    80000886:	8f8080e7          	jalr	-1800(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000088a:	4779                	li	a4,30
    8000088c:	86ca                	mv	a3,s2
    8000088e:	6605                	lui	a2,0x1
    80000890:	4581                	li	a1,0
    80000892:	8552                	mv	a0,s4
    80000894:	00000097          	auipc	ra,0x0
    80000898:	cc8080e7          	jalr	-824(ra) # 8000055c <mappages>
  memmove(mem, src, sz);
    8000089c:	8626                	mv	a2,s1
    8000089e:	85ce                	mv	a1,s3
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	934080e7          	jalr	-1740(ra) # 800001d6 <memmove>
}
    800008aa:	70a2                	ld	ra,40(sp)
    800008ac:	7402                	ld	s0,32(sp)
    800008ae:	64e2                	ld	s1,24(sp)
    800008b0:	6942                	ld	s2,16(sp)
    800008b2:	69a2                	ld	s3,8(sp)
    800008b4:	6a02                	ld	s4,0(sp)
    800008b6:	6145                	addi	sp,sp,48
    800008b8:	8082                	ret
    panic("uvmfirst: more than a page");
    800008ba:	00009517          	auipc	a0,0x9
    800008be:	82e50513          	addi	a0,a0,-2002 # 800090e8 <etext+0xe8>
    800008c2:	00006097          	auipc	ra,0x6
    800008c6:	128080e7          	jalr	296(ra) # 800069ea <panic>

00000000800008ca <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008ca:	1101                	addi	sp,sp,-32
    800008cc:	ec06                	sd	ra,24(sp)
    800008ce:	e822                	sd	s0,16(sp)
    800008d0:	e426                	sd	s1,8(sp)
    800008d2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d6:	00b67d63          	bgeu	a2,a1,800008f0 <uvmdealloc+0x26>
    800008da:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008dc:	6785                	lui	a5,0x1
    800008de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008e0:	00f60733          	add	a4,a2,a5
    800008e4:	76fd                	lui	a3,0xfffff
    800008e6:	8f75                	and	a4,a4,a3
    800008e8:	97ae                	add	a5,a5,a1
    800008ea:	8ff5                	and	a5,a5,a3
    800008ec:	00f76863          	bltu	a4,a5,800008fc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f0:	8526                	mv	a0,s1
    800008f2:	60e2                	ld	ra,24(sp)
    800008f4:	6442                	ld	s0,16(sp)
    800008f6:	64a2                	ld	s1,8(sp)
    800008f8:	6105                	addi	sp,sp,32
    800008fa:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008fc:	8f99                	sub	a5,a5,a4
    800008fe:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000900:	4685                	li	a3,1
    80000902:	0007861b          	sext.w	a2,a5
    80000906:	85ba                	mv	a1,a4
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	e4a080e7          	jalr	-438(ra) # 80000752 <uvmunmap>
    80000910:	b7c5                	j	800008f0 <uvmdealloc+0x26>

0000000080000912 <uvmalloc>:
  if(newsz < oldsz)
    80000912:	0ab66563          	bltu	a2,a1,800009bc <uvmalloc+0xaa>
{
    80000916:	7139                	addi	sp,sp,-64
    80000918:	fc06                	sd	ra,56(sp)
    8000091a:	f822                	sd	s0,48(sp)
    8000091c:	f426                	sd	s1,40(sp)
    8000091e:	f04a                	sd	s2,32(sp)
    80000920:	ec4e                	sd	s3,24(sp)
    80000922:	e852                	sd	s4,16(sp)
    80000924:	e456                	sd	s5,8(sp)
    80000926:	e05a                	sd	s6,0(sp)
    80000928:	0080                	addi	s0,sp,64
    8000092a:	8aaa                	mv	s5,a0
    8000092c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000092e:	6785                	lui	a5,0x1
    80000930:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000932:	95be                	add	a1,a1,a5
    80000934:	77fd                	lui	a5,0xfffff
    80000936:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093a:	08c9f363          	bgeu	s3,a2,800009c0 <uvmalloc+0xae>
    8000093e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000940:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000944:	fffff097          	auipc	ra,0xfffff
    80000948:	7d6080e7          	jalr	2006(ra) # 8000011a <kalloc>
    8000094c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000094e:	c51d                	beqz	a0,8000097c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000950:	6605                	lui	a2,0x1
    80000952:	4581                	li	a1,0
    80000954:	00000097          	auipc	ra,0x0
    80000958:	826080e7          	jalr	-2010(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000095c:	875a                	mv	a4,s6
    8000095e:	86a6                	mv	a3,s1
    80000960:	6605                	lui	a2,0x1
    80000962:	85ca                	mv	a1,s2
    80000964:	8556                	mv	a0,s5
    80000966:	00000097          	auipc	ra,0x0
    8000096a:	bf6080e7          	jalr	-1034(ra) # 8000055c <mappages>
    8000096e:	e90d                	bnez	a0,800009a0 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000970:	6785                	lui	a5,0x1
    80000972:	993e                	add	s2,s2,a5
    80000974:	fd4968e3          	bltu	s2,s4,80000944 <uvmalloc+0x32>
  return newsz;
    80000978:	8552                	mv	a0,s4
    8000097a:	a809                	j	8000098c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000097c:	864e                	mv	a2,s3
    8000097e:	85ca                	mv	a1,s2
    80000980:	8556                	mv	a0,s5
    80000982:	00000097          	auipc	ra,0x0
    80000986:	f48080e7          	jalr	-184(ra) # 800008ca <uvmdealloc>
      return 0;
    8000098a:	4501                	li	a0,0
}
    8000098c:	70e2                	ld	ra,56(sp)
    8000098e:	7442                	ld	s0,48(sp)
    80000990:	74a2                	ld	s1,40(sp)
    80000992:	7902                	ld	s2,32(sp)
    80000994:	69e2                	ld	s3,24(sp)
    80000996:	6a42                	ld	s4,16(sp)
    80000998:	6aa2                	ld	s5,8(sp)
    8000099a:	6b02                	ld	s6,0(sp)
    8000099c:	6121                	addi	sp,sp,64
    8000099e:	8082                	ret
      kfree(mem);
    800009a0:	8526                	mv	a0,s1
    800009a2:	fffff097          	auipc	ra,0xfffff
    800009a6:	67a080e7          	jalr	1658(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009aa:	864e                	mv	a2,s3
    800009ac:	85ca                	mv	a1,s2
    800009ae:	8556                	mv	a0,s5
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	f1a080e7          	jalr	-230(ra) # 800008ca <uvmdealloc>
      return 0;
    800009b8:	4501                	li	a0,0
    800009ba:	bfc9                	j	8000098c <uvmalloc+0x7a>
    return oldsz;
    800009bc:	852e                	mv	a0,a1
}
    800009be:	8082                	ret
  return newsz;
    800009c0:	8532                	mv	a0,a2
    800009c2:	b7e9                	j	8000098c <uvmalloc+0x7a>

00000000800009c4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009c4:	7179                	addi	sp,sp,-48
    800009c6:	f406                	sd	ra,40(sp)
    800009c8:	f022                	sd	s0,32(sp)
    800009ca:	ec26                	sd	s1,24(sp)
    800009cc:	e84a                	sd	s2,16(sp)
    800009ce:	e44e                	sd	s3,8(sp)
    800009d0:	e052                	sd	s4,0(sp)
    800009d2:	1800                	addi	s0,sp,48
    800009d4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009d6:	84aa                	mv	s1,a0
    800009d8:	6905                	lui	s2,0x1
    800009da:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009dc:	4985                	li	s3,1
    800009de:	a829                	j	800009f8 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009e0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009e2:	00c79513          	slli	a0,a5,0xc
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	fde080e7          	jalr	-34(ra) # 800009c4 <freewalk>
      pagetable[i] = 0;
    800009ee:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009f2:	04a1                	addi	s1,s1,8
    800009f4:	03248163          	beq	s1,s2,80000a16 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009f8:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009fa:	00f7f713          	andi	a4,a5,15
    800009fe:	ff3701e3          	beq	a4,s3,800009e0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a02:	8b85                	andi	a5,a5,1
    80000a04:	d7fd                	beqz	a5,800009f2 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a06:	00008517          	auipc	a0,0x8
    80000a0a:	70250513          	addi	a0,a0,1794 # 80009108 <etext+0x108>
    80000a0e:	00006097          	auipc	ra,0x6
    80000a12:	fdc080e7          	jalr	-36(ra) # 800069ea <panic>
    }
  }
  kfree((void*)pagetable);
    80000a16:	8552                	mv	a0,s4
    80000a18:	fffff097          	auipc	ra,0xfffff
    80000a1c:	604080e7          	jalr	1540(ra) # 8000001c <kfree>
}
    80000a20:	70a2                	ld	ra,40(sp)
    80000a22:	7402                	ld	s0,32(sp)
    80000a24:	64e2                	ld	s1,24(sp)
    80000a26:	6942                	ld	s2,16(sp)
    80000a28:	69a2                	ld	s3,8(sp)
    80000a2a:	6a02                	ld	s4,0(sp)
    80000a2c:	6145                	addi	sp,sp,48
    80000a2e:	8082                	ret

0000000080000a30 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a30:	1101                	addi	sp,sp,-32
    80000a32:	ec06                	sd	ra,24(sp)
    80000a34:	e822                	sd	s0,16(sp)
    80000a36:	e426                	sd	s1,8(sp)
    80000a38:	1000                	addi	s0,sp,32
    80000a3a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a3c:	e999                	bnez	a1,80000a52 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a3e:	8526                	mv	a0,s1
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	f84080e7          	jalr	-124(ra) # 800009c4 <freewalk>
}
    80000a48:	60e2                	ld	ra,24(sp)
    80000a4a:	6442                	ld	s0,16(sp)
    80000a4c:	64a2                	ld	s1,8(sp)
    80000a4e:	6105                	addi	sp,sp,32
    80000a50:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a52:	6785                	lui	a5,0x1
    80000a54:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a56:	95be                	add	a1,a1,a5
    80000a58:	4685                	li	a3,1
    80000a5a:	00c5d613          	srli	a2,a1,0xc
    80000a5e:	4581                	li	a1,0
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	cf2080e7          	jalr	-782(ra) # 80000752 <uvmunmap>
    80000a68:	bfd9                	j	80000a3e <uvmfree+0xe>

0000000080000a6a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a6a:	c679                	beqz	a2,80000b38 <uvmcopy+0xce>
{
    80000a6c:	715d                	addi	sp,sp,-80
    80000a6e:	e486                	sd	ra,72(sp)
    80000a70:	e0a2                	sd	s0,64(sp)
    80000a72:	fc26                	sd	s1,56(sp)
    80000a74:	f84a                	sd	s2,48(sp)
    80000a76:	f44e                	sd	s3,40(sp)
    80000a78:	f052                	sd	s4,32(sp)
    80000a7a:	ec56                	sd	s5,24(sp)
    80000a7c:	e85a                	sd	s6,16(sp)
    80000a7e:	e45e                	sd	s7,8(sp)
    80000a80:	0880                	addi	s0,sp,80
    80000a82:	8b2a                	mv	s6,a0
    80000a84:	8aae                	mv	s5,a1
    80000a86:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a88:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a8a:	4601                	li	a2,0
    80000a8c:	85ce                	mv	a1,s3
    80000a8e:	855a                	mv	a0,s6
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	9e4080e7          	jalr	-1564(ra) # 80000474 <walk>
    80000a98:	c531                	beqz	a0,80000ae4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a9a:	6118                	ld	a4,0(a0)
    80000a9c:	00177793          	andi	a5,a4,1
    80000aa0:	cbb1                	beqz	a5,80000af4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aa2:	00a75593          	srli	a1,a4,0xa
    80000aa6:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aaa:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	66c080e7          	jalr	1644(ra) # 8000011a <kalloc>
    80000ab6:	892a                	mv	s2,a0
    80000ab8:	c939                	beqz	a0,80000b0e <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aba:	6605                	lui	a2,0x1
    80000abc:	85de                	mv	a1,s7
    80000abe:	fffff097          	auipc	ra,0xfffff
    80000ac2:	718080e7          	jalr	1816(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ac6:	8726                	mv	a4,s1
    80000ac8:	86ca                	mv	a3,s2
    80000aca:	6605                	lui	a2,0x1
    80000acc:	85ce                	mv	a1,s3
    80000ace:	8556                	mv	a0,s5
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	a8c080e7          	jalr	-1396(ra) # 8000055c <mappages>
    80000ad8:	e515                	bnez	a0,80000b04 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ada:	6785                	lui	a5,0x1
    80000adc:	99be                	add	s3,s3,a5
    80000ade:	fb49e6e3          	bltu	s3,s4,80000a8a <uvmcopy+0x20>
    80000ae2:	a081                	j	80000b22 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ae4:	00008517          	auipc	a0,0x8
    80000ae8:	63450513          	addi	a0,a0,1588 # 80009118 <etext+0x118>
    80000aec:	00006097          	auipc	ra,0x6
    80000af0:	efe080e7          	jalr	-258(ra) # 800069ea <panic>
      panic("uvmcopy: page not present");
    80000af4:	00008517          	auipc	a0,0x8
    80000af8:	64450513          	addi	a0,a0,1604 # 80009138 <etext+0x138>
    80000afc:	00006097          	auipc	ra,0x6
    80000b00:	eee080e7          	jalr	-274(ra) # 800069ea <panic>
      kfree(mem);
    80000b04:	854a                	mv	a0,s2
    80000b06:	fffff097          	auipc	ra,0xfffff
    80000b0a:	516080e7          	jalr	1302(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b0e:	4685                	li	a3,1
    80000b10:	00c9d613          	srli	a2,s3,0xc
    80000b14:	4581                	li	a1,0
    80000b16:	8556                	mv	a0,s5
    80000b18:	00000097          	auipc	ra,0x0
    80000b1c:	c3a080e7          	jalr	-966(ra) # 80000752 <uvmunmap>
  return -1;
    80000b20:	557d                	li	a0,-1
}
    80000b22:	60a6                	ld	ra,72(sp)
    80000b24:	6406                	ld	s0,64(sp)
    80000b26:	74e2                	ld	s1,56(sp)
    80000b28:	7942                	ld	s2,48(sp)
    80000b2a:	79a2                	ld	s3,40(sp)
    80000b2c:	7a02                	ld	s4,32(sp)
    80000b2e:	6ae2                	ld	s5,24(sp)
    80000b30:	6b42                	ld	s6,16(sp)
    80000b32:	6ba2                	ld	s7,8(sp)
    80000b34:	6161                	addi	sp,sp,80
    80000b36:	8082                	ret
  return 0;
    80000b38:	4501                	li	a0,0
}
    80000b3a:	8082                	ret

0000000080000b3c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b3c:	1141                	addi	sp,sp,-16
    80000b3e:	e406                	sd	ra,8(sp)
    80000b40:	e022                	sd	s0,0(sp)
    80000b42:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b44:	4601                	li	a2,0
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	92e080e7          	jalr	-1746(ra) # 80000474 <walk>
  if(pte == 0)
    80000b4e:	c901                	beqz	a0,80000b5e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b50:	611c                	ld	a5,0(a0)
    80000b52:	9bbd                	andi	a5,a5,-17
    80000b54:	e11c                	sd	a5,0(a0)
}
    80000b56:	60a2                	ld	ra,8(sp)
    80000b58:	6402                	ld	s0,0(sp)
    80000b5a:	0141                	addi	sp,sp,16
    80000b5c:	8082                	ret
    panic("uvmclear");
    80000b5e:	00008517          	auipc	a0,0x8
    80000b62:	5fa50513          	addi	a0,a0,1530 # 80009158 <etext+0x158>
    80000b66:	00006097          	auipc	ra,0x6
    80000b6a:	e84080e7          	jalr	-380(ra) # 800069ea <panic>

0000000080000b6e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b6e:	c6bd                	beqz	a3,80000bdc <copyout+0x6e>
{
    80000b70:	715d                	addi	sp,sp,-80
    80000b72:	e486                	sd	ra,72(sp)
    80000b74:	e0a2                	sd	s0,64(sp)
    80000b76:	fc26                	sd	s1,56(sp)
    80000b78:	f84a                	sd	s2,48(sp)
    80000b7a:	f44e                	sd	s3,40(sp)
    80000b7c:	f052                	sd	s4,32(sp)
    80000b7e:	ec56                	sd	s5,24(sp)
    80000b80:	e85a                	sd	s6,16(sp)
    80000b82:	e45e                	sd	s7,8(sp)
    80000b84:	e062                	sd	s8,0(sp)
    80000b86:	0880                	addi	s0,sp,80
    80000b88:	8b2a                	mv	s6,a0
    80000b8a:	8c2e                	mv	s8,a1
    80000b8c:	8a32                	mv	s4,a2
    80000b8e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b90:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b92:	6a85                	lui	s5,0x1
    80000b94:	a015                	j	80000bb8 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b96:	9562                	add	a0,a0,s8
    80000b98:	0004861b          	sext.w	a2,s1
    80000b9c:	85d2                	mv	a1,s4
    80000b9e:	41250533          	sub	a0,a0,s2
    80000ba2:	fffff097          	auipc	ra,0xfffff
    80000ba6:	634080e7          	jalr	1588(ra) # 800001d6 <memmove>

    len -= n;
    80000baa:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bae:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bb0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bb4:	02098263          	beqz	s3,80000bd8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bb8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bbc:	85ca                	mv	a1,s2
    80000bbe:	855a                	mv	a0,s6
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	95a080e7          	jalr	-1702(ra) # 8000051a <walkaddr>
    if(pa0 == 0)
    80000bc8:	cd01                	beqz	a0,80000be0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bca:	418904b3          	sub	s1,s2,s8
    80000bce:	94d6                	add	s1,s1,s5
    80000bd0:	fc99f3e3          	bgeu	s3,s1,80000b96 <copyout+0x28>
    80000bd4:	84ce                	mv	s1,s3
    80000bd6:	b7c1                	j	80000b96 <copyout+0x28>
  }
  return 0;
    80000bd8:	4501                	li	a0,0
    80000bda:	a021                	j	80000be2 <copyout+0x74>
    80000bdc:	4501                	li	a0,0
}
    80000bde:	8082                	ret
      return -1;
    80000be0:	557d                	li	a0,-1
}
    80000be2:	60a6                	ld	ra,72(sp)
    80000be4:	6406                	ld	s0,64(sp)
    80000be6:	74e2                	ld	s1,56(sp)
    80000be8:	7942                	ld	s2,48(sp)
    80000bea:	79a2                	ld	s3,40(sp)
    80000bec:	7a02                	ld	s4,32(sp)
    80000bee:	6ae2                	ld	s5,24(sp)
    80000bf0:	6b42                	ld	s6,16(sp)
    80000bf2:	6ba2                	ld	s7,8(sp)
    80000bf4:	6c02                	ld	s8,0(sp)
    80000bf6:	6161                	addi	sp,sp,80
    80000bf8:	8082                	ret

0000000080000bfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000bfa:	caa5                	beqz	a3,80000c6a <copyin+0x70>
{
    80000bfc:	715d                	addi	sp,sp,-80
    80000bfe:	e486                	sd	ra,72(sp)
    80000c00:	e0a2                	sd	s0,64(sp)
    80000c02:	fc26                	sd	s1,56(sp)
    80000c04:	f84a                	sd	s2,48(sp)
    80000c06:	f44e                	sd	s3,40(sp)
    80000c08:	f052                	sd	s4,32(sp)
    80000c0a:	ec56                	sd	s5,24(sp)
    80000c0c:	e85a                	sd	s6,16(sp)
    80000c0e:	e45e                	sd	s7,8(sp)
    80000c10:	e062                	sd	s8,0(sp)
    80000c12:	0880                	addi	s0,sp,80
    80000c14:	8b2a                	mv	s6,a0
    80000c16:	8a2e                	mv	s4,a1
    80000c18:	8c32                	mv	s8,a2
    80000c1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1e:	6a85                	lui	s5,0x1
    80000c20:	a01d                	j	80000c46 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c22:	018505b3          	add	a1,a0,s8
    80000c26:	0004861b          	sext.w	a2,s1
    80000c2a:	412585b3          	sub	a1,a1,s2
    80000c2e:	8552                	mv	a0,s4
    80000c30:	fffff097          	auipc	ra,0xfffff
    80000c34:	5a6080e7          	jalr	1446(ra) # 800001d6 <memmove>

    len -= n;
    80000c38:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c42:	02098263          	beqz	s3,80000c66 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c46:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c4a:	85ca                	mv	a1,s2
    80000c4c:	855a                	mv	a0,s6
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	8cc080e7          	jalr	-1844(ra) # 8000051a <walkaddr>
    if(pa0 == 0)
    80000c56:	cd01                	beqz	a0,80000c6e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c58:	418904b3          	sub	s1,s2,s8
    80000c5c:	94d6                	add	s1,s1,s5
    80000c5e:	fc99f2e3          	bgeu	s3,s1,80000c22 <copyin+0x28>
    80000c62:	84ce                	mv	s1,s3
    80000c64:	bf7d                	j	80000c22 <copyin+0x28>
  }
  return 0;
    80000c66:	4501                	li	a0,0
    80000c68:	a021                	j	80000c70 <copyin+0x76>
    80000c6a:	4501                	li	a0,0
}
    80000c6c:	8082                	ret
      return -1;
    80000c6e:	557d                	li	a0,-1
}
    80000c70:	60a6                	ld	ra,72(sp)
    80000c72:	6406                	ld	s0,64(sp)
    80000c74:	74e2                	ld	s1,56(sp)
    80000c76:	7942                	ld	s2,48(sp)
    80000c78:	79a2                	ld	s3,40(sp)
    80000c7a:	7a02                	ld	s4,32(sp)
    80000c7c:	6ae2                	ld	s5,24(sp)
    80000c7e:	6b42                	ld	s6,16(sp)
    80000c80:	6ba2                	ld	s7,8(sp)
    80000c82:	6c02                	ld	s8,0(sp)
    80000c84:	6161                	addi	sp,sp,80
    80000c86:	8082                	ret

0000000080000c88 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c88:	c2dd                	beqz	a3,80000d2e <copyinstr+0xa6>
{
    80000c8a:	715d                	addi	sp,sp,-80
    80000c8c:	e486                	sd	ra,72(sp)
    80000c8e:	e0a2                	sd	s0,64(sp)
    80000c90:	fc26                	sd	s1,56(sp)
    80000c92:	f84a                	sd	s2,48(sp)
    80000c94:	f44e                	sd	s3,40(sp)
    80000c96:	f052                	sd	s4,32(sp)
    80000c98:	ec56                	sd	s5,24(sp)
    80000c9a:	e85a                	sd	s6,16(sp)
    80000c9c:	e45e                	sd	s7,8(sp)
    80000c9e:	0880                	addi	s0,sp,80
    80000ca0:	8a2a                	mv	s4,a0
    80000ca2:	8b2e                	mv	s6,a1
    80000ca4:	8bb2                	mv	s7,a2
    80000ca6:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000caa:	6985                	lui	s3,0x1
    80000cac:	a02d                	j	80000cd6 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cae:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb4:	37fd                	addiw	a5,a5,-1
    80000cb6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cba:	60a6                	ld	ra,72(sp)
    80000cbc:	6406                	ld	s0,64(sp)
    80000cbe:	74e2                	ld	s1,56(sp)
    80000cc0:	7942                	ld	s2,48(sp)
    80000cc2:	79a2                	ld	s3,40(sp)
    80000cc4:	7a02                	ld	s4,32(sp)
    80000cc6:	6ae2                	ld	s5,24(sp)
    80000cc8:	6b42                	ld	s6,16(sp)
    80000cca:	6ba2                	ld	s7,8(sp)
    80000ccc:	6161                	addi	sp,sp,80
    80000cce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd4:	c8a9                	beqz	s1,80000d26 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cda:	85ca                	mv	a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	83c080e7          	jalr	-1988(ra) # 8000051a <walkaddr>
    if(pa0 == 0)
    80000ce6:	c131                	beqz	a0,80000d2a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ce8:	417906b3          	sub	a3,s2,s7
    80000cec:	96ce                	add	a3,a3,s3
    80000cee:	00d4f363          	bgeu	s1,a3,80000cf4 <copyinstr+0x6c>
    80000cf2:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf4:	955e                	add	a0,a0,s7
    80000cf6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfa:	daf9                	beqz	a3,80000cd0 <copyinstr+0x48>
    80000cfc:	87da                	mv	a5,s6
    80000cfe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d04:	96da                	add	a3,a3,s6
    80000d06:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d08:	00f60733          	add	a4,a2,a5
    80000d0c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdbc80>
    80000d10:	df59                	beqz	a4,80000cae <copyinstr+0x26>
        *dst = *p;
    80000d12:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d18:	fed797e3          	bne	a5,a3,80000d06 <copyinstr+0x7e>
    80000d1c:	14fd                	addi	s1,s1,-1
    80000d1e:	94c2                	add	s1,s1,a6
      --max;
    80000d20:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d22:	8b3e                	mv	s6,a5
    80000d24:	b775                	j	80000cd0 <copyinstr+0x48>
    80000d26:	4781                	li	a5,0
    80000d28:	b771                	j	80000cb4 <copyinstr+0x2c>
      return -1;
    80000d2a:	557d                	li	a0,-1
    80000d2c:	b779                	j	80000cba <copyinstr+0x32>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	37fd                	addiw	a5,a5,-1
    80000d32:	0007851b          	sext.w	a0,a5
}
    80000d36:	8082                	ret

0000000080000d38 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d38:	7139                	addi	sp,sp,-64
    80000d3a:	fc06                	sd	ra,56(sp)
    80000d3c:	f822                	sd	s0,48(sp)
    80000d3e:	f426                	sd	s1,40(sp)
    80000d40:	f04a                	sd	s2,32(sp)
    80000d42:	ec4e                	sd	s3,24(sp)
    80000d44:	e852                	sd	s4,16(sp)
    80000d46:	e456                	sd	s5,8(sp)
    80000d48:	e05a                	sd	s6,0(sp)
    80000d4a:	0080                	addi	s0,sp,64
    80000d4c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4e:	00009497          	auipc	s1,0x9
    80000d52:	0b248493          	addi	s1,s1,178 # 80009e00 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d56:	8b26                	mv	s6,s1
    80000d58:	00008a97          	auipc	s5,0x8
    80000d5c:	2a8a8a93          	addi	s5,s5,680 # 80009000 <etext>
    80000d60:	01000937          	lui	s2,0x1000
    80000d64:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d66:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d68:	0000fa17          	auipc	s4,0xf
    80000d6c:	a98a0a13          	addi	s4,s4,-1384 # 8000f800 <tickslock>
    char *pa = kalloc();
    80000d70:	fffff097          	auipc	ra,0xfffff
    80000d74:	3aa080e7          	jalr	938(ra) # 8000011a <kalloc>
    80000d78:	862a                	mv	a2,a0
    if(pa == 0)
    80000d7a:	c129                	beqz	a0,80000dbc <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d7c:	416485b3          	sub	a1,s1,s6
    80000d80:	858d                	srai	a1,a1,0x3
    80000d82:	000ab783          	ld	a5,0(s5)
    80000d86:	02f585b3          	mul	a1,a1,a5
    80000d8a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d8e:	4719                	li	a4,6
    80000d90:	6685                	lui	a3,0x1
    80000d92:	40b905b3          	sub	a1,s2,a1
    80000d96:	854e                	mv	a0,s3
    80000d98:	00000097          	auipc	ra,0x0
    80000d9c:	864080e7          	jalr	-1948(ra) # 800005fc <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da0:	16848493          	addi	s1,s1,360
    80000da4:	fd4496e3          	bne	s1,s4,80000d70 <proc_mapstacks+0x38>
  }
}
    80000da8:	70e2                	ld	ra,56(sp)
    80000daa:	7442                	ld	s0,48(sp)
    80000dac:	74a2                	ld	s1,40(sp)
    80000dae:	7902                	ld	s2,32(sp)
    80000db0:	69e2                	ld	s3,24(sp)
    80000db2:	6a42                	ld	s4,16(sp)
    80000db4:	6aa2                	ld	s5,8(sp)
    80000db6:	6b02                	ld	s6,0(sp)
    80000db8:	6121                	addi	sp,sp,64
    80000dba:	8082                	ret
      panic("kalloc");
    80000dbc:	00008517          	auipc	a0,0x8
    80000dc0:	3ac50513          	addi	a0,a0,940 # 80009168 <etext+0x168>
    80000dc4:	00006097          	auipc	ra,0x6
    80000dc8:	c26080e7          	jalr	-986(ra) # 800069ea <panic>

0000000080000dcc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dcc:	7139                	addi	sp,sp,-64
    80000dce:	fc06                	sd	ra,56(sp)
    80000dd0:	f822                	sd	s0,48(sp)
    80000dd2:	f426                	sd	s1,40(sp)
    80000dd4:	f04a                	sd	s2,32(sp)
    80000dd6:	ec4e                	sd	s3,24(sp)
    80000dd8:	e852                	sd	s4,16(sp)
    80000dda:	e456                	sd	s5,8(sp)
    80000ddc:	e05a                	sd	s6,0(sp)
    80000dde:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000de0:	00008597          	auipc	a1,0x8
    80000de4:	39058593          	addi	a1,a1,912 # 80009170 <etext+0x170>
    80000de8:	00009517          	auipc	a0,0x9
    80000dec:	be850513          	addi	a0,a0,-1048 # 800099d0 <pid_lock>
    80000df0:	00006097          	auipc	ra,0x6
    80000df4:	0a2080e7          	jalr	162(ra) # 80006e92 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df8:	00008597          	auipc	a1,0x8
    80000dfc:	38058593          	addi	a1,a1,896 # 80009178 <etext+0x178>
    80000e00:	00009517          	auipc	a0,0x9
    80000e04:	be850513          	addi	a0,a0,-1048 # 800099e8 <wait_lock>
    80000e08:	00006097          	auipc	ra,0x6
    80000e0c:	08a080e7          	jalr	138(ra) # 80006e92 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	00009497          	auipc	s1,0x9
    80000e14:	ff048493          	addi	s1,s1,-16 # 80009e00 <proc>
      initlock(&p->lock, "proc");
    80000e18:	00008b17          	auipc	s6,0x8
    80000e1c:	370b0b13          	addi	s6,s6,880 # 80009188 <etext+0x188>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e20:	8aa6                	mv	s5,s1
    80000e22:	00008a17          	auipc	s4,0x8
    80000e26:	1dea0a13          	addi	s4,s4,478 # 80009000 <etext>
    80000e2a:	01000937          	lui	s2,0x1000
    80000e2e:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e30:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e32:	0000f997          	auipc	s3,0xf
    80000e36:	9ce98993          	addi	s3,s3,-1586 # 8000f800 <tickslock>
      initlock(&p->lock, "proc");
    80000e3a:	85da                	mv	a1,s6
    80000e3c:	8526                	mv	a0,s1
    80000e3e:	00006097          	auipc	ra,0x6
    80000e42:	054080e7          	jalr	84(ra) # 80006e92 <initlock>
      p->state = UNUSED;
    80000e46:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e4a:	415487b3          	sub	a5,s1,s5
    80000e4e:	878d                	srai	a5,a5,0x3
    80000e50:	000a3703          	ld	a4,0(s4)
    80000e54:	02e787b3          	mul	a5,a5,a4
    80000e58:	00d7979b          	slliw	a5,a5,0xd
    80000e5c:	40f907b3          	sub	a5,s2,a5
    80000e60:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	16848493          	addi	s1,s1,360
    80000e66:	fd349ae3          	bne	s1,s3,80000e3a <procinit+0x6e>
  }
}
    80000e6a:	70e2                	ld	ra,56(sp)
    80000e6c:	7442                	ld	s0,48(sp)
    80000e6e:	74a2                	ld	s1,40(sp)
    80000e70:	7902                	ld	s2,32(sp)
    80000e72:	69e2                	ld	s3,24(sp)
    80000e74:	6a42                	ld	s4,16(sp)
    80000e76:	6aa2                	ld	s5,8(sp)
    80000e78:	6b02                	ld	s6,0(sp)
    80000e7a:	6121                	addi	sp,sp,64
    80000e7c:	8082                	ret

0000000080000e7e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e7e:	1141                	addi	sp,sp,-16
    80000e80:	e422                	sd	s0,8(sp)
    80000e82:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e84:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e86:	2501                	sext.w	a0,a0
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e8e:	1141                	addi	sp,sp,-16
    80000e90:	e422                	sd	s0,8(sp)
    80000e92:	0800                	addi	s0,sp,16
    80000e94:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e96:	2781                	sext.w	a5,a5
    80000e98:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e9a:	00009517          	auipc	a0,0x9
    80000e9e:	b6650513          	addi	a0,a0,-1178 # 80009a00 <cpus>
    80000ea2:	953e                	add	a0,a0,a5
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eaa:	1101                	addi	sp,sp,-32
    80000eac:	ec06                	sd	ra,24(sp)
    80000eae:	e822                	sd	s0,16(sp)
    80000eb0:	e426                	sd	s1,8(sp)
    80000eb2:	1000                	addi	s0,sp,32
  push_off();
    80000eb4:	00006097          	auipc	ra,0x6
    80000eb8:	022080e7          	jalr	34(ra) # 80006ed6 <push_off>
    80000ebc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ebe:	2781                	sext.w	a5,a5
    80000ec0:	079e                	slli	a5,a5,0x7
    80000ec2:	00009717          	auipc	a4,0x9
    80000ec6:	b0e70713          	addi	a4,a4,-1266 # 800099d0 <pid_lock>
    80000eca:	97ba                	add	a5,a5,a4
    80000ecc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ece:	00006097          	auipc	ra,0x6
    80000ed2:	0a8080e7          	jalr	168(ra) # 80006f76 <pop_off>
  return p;
}
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	60e2                	ld	ra,24(sp)
    80000eda:	6442                	ld	s0,16(sp)
    80000edc:	64a2                	ld	s1,8(sp)
    80000ede:	6105                	addi	sp,sp,32
    80000ee0:	8082                	ret

0000000080000ee2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eea:	00000097          	auipc	ra,0x0
    80000eee:	fc0080e7          	jalr	-64(ra) # 80000eaa <myproc>
    80000ef2:	00006097          	auipc	ra,0x6
    80000ef6:	0e4080e7          	jalr	228(ra) # 80006fd6 <release>

  if (first) {
    80000efa:	00009797          	auipc	a5,0x9
    80000efe:	9e67a783          	lw	a5,-1562(a5) # 800098e0 <first.1>
    80000f02:	eb89                	bnez	a5,80000f14 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	c5c080e7          	jalr	-932(ra) # 80001b60 <usertrapret>
}
    80000f0c:	60a2                	ld	ra,8(sp)
    80000f0e:	6402                	ld	s0,0(sp)
    80000f10:	0141                	addi	sp,sp,16
    80000f12:	8082                	ret
    first = 0;
    80000f14:	00009797          	auipc	a5,0x9
    80000f18:	9c07a623          	sw	zero,-1588(a5) # 800098e0 <first.1>
    fsinit(ROOTDEV);
    80000f1c:	4505                	li	a0,1
    80000f1e:	00002097          	auipc	ra,0x2
    80000f22:	9b0080e7          	jalr	-1616(ra) # 800028ce <fsinit>
    80000f26:	bff9                	j	80000f04 <forkret+0x22>

0000000080000f28 <allocpid>:
{
    80000f28:	1101                	addi	sp,sp,-32
    80000f2a:	ec06                	sd	ra,24(sp)
    80000f2c:	e822                	sd	s0,16(sp)
    80000f2e:	e426                	sd	s1,8(sp)
    80000f30:	e04a                	sd	s2,0(sp)
    80000f32:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f34:	00009917          	auipc	s2,0x9
    80000f38:	a9c90913          	addi	s2,s2,-1380 # 800099d0 <pid_lock>
    80000f3c:	854a                	mv	a0,s2
    80000f3e:	00006097          	auipc	ra,0x6
    80000f42:	fe4080e7          	jalr	-28(ra) # 80006f22 <acquire>
  pid = nextpid;
    80000f46:	00009797          	auipc	a5,0x9
    80000f4a:	99e78793          	addi	a5,a5,-1634 # 800098e4 <nextpid>
    80000f4e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f50:	0014871b          	addiw	a4,s1,1
    80000f54:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f56:	854a                	mv	a0,s2
    80000f58:	00006097          	auipc	ra,0x6
    80000f5c:	07e080e7          	jalr	126(ra) # 80006fd6 <release>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret

0000000080000f6e <proc_pagetable>:
{
    80000f6e:	1101                	addi	sp,sp,-32
    80000f70:	ec06                	sd	ra,24(sp)
    80000f72:	e822                	sd	s0,16(sp)
    80000f74:	e426                	sd	s1,8(sp)
    80000f76:	e04a                	sd	s2,0(sp)
    80000f78:	1000                	addi	s0,sp,32
    80000f7a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f7c:	00000097          	auipc	ra,0x0
    80000f80:	8ae080e7          	jalr	-1874(ra) # 8000082a <uvmcreate>
    80000f84:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f86:	c121                	beqz	a0,80000fc6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f88:	4729                	li	a4,10
    80000f8a:	00007697          	auipc	a3,0x7
    80000f8e:	07668693          	addi	a3,a3,118 # 80008000 <_trampoline>
    80000f92:	6605                	lui	a2,0x1
    80000f94:	040005b7          	lui	a1,0x4000
    80000f98:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f9a:	05b2                	slli	a1,a1,0xc
    80000f9c:	fffff097          	auipc	ra,0xfffff
    80000fa0:	5c0080e7          	jalr	1472(ra) # 8000055c <mappages>
    80000fa4:	02054863          	bltz	a0,80000fd4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fa8:	4719                	li	a4,6
    80000faa:	05893683          	ld	a3,88(s2)
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	020005b7          	lui	a1,0x2000
    80000fb4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fb6:	05b6                	slli	a1,a1,0xd
    80000fb8:	8526                	mv	a0,s1
    80000fba:	fffff097          	auipc	ra,0xfffff
    80000fbe:	5a2080e7          	jalr	1442(ra) # 8000055c <mappages>
    80000fc2:	02054163          	bltz	a0,80000fe4 <proc_pagetable+0x76>
}
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	60e2                	ld	ra,24(sp)
    80000fca:	6442                	ld	s0,16(sp)
    80000fcc:	64a2                	ld	s1,8(sp)
    80000fce:	6902                	ld	s2,0(sp)
    80000fd0:	6105                	addi	sp,sp,32
    80000fd2:	8082                	ret
    uvmfree(pagetable, 0);
    80000fd4:	4581                	li	a1,0
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	a58080e7          	jalr	-1448(ra) # 80000a30 <uvmfree>
    return 0;
    80000fe0:	4481                	li	s1,0
    80000fe2:	b7d5                	j	80000fc6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fe4:	4681                	li	a3,0
    80000fe6:	4605                	li	a2,1
    80000fe8:	040005b7          	lui	a1,0x4000
    80000fec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fee:	05b2                	slli	a1,a1,0xc
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	fffff097          	auipc	ra,0xfffff
    80000ff6:	760080e7          	jalr	1888(ra) # 80000752 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ffa:	4581                	li	a1,0
    80000ffc:	8526                	mv	a0,s1
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	a32080e7          	jalr	-1486(ra) # 80000a30 <uvmfree>
    return 0;
    80001006:	4481                	li	s1,0
    80001008:	bf7d                	j	80000fc6 <proc_pagetable+0x58>

000000008000100a <proc_freepagetable>:
{
    8000100a:	1101                	addi	sp,sp,-32
    8000100c:	ec06                	sd	ra,24(sp)
    8000100e:	e822                	sd	s0,16(sp)
    80001010:	e426                	sd	s1,8(sp)
    80001012:	e04a                	sd	s2,0(sp)
    80001014:	1000                	addi	s0,sp,32
    80001016:	84aa                	mv	s1,a0
    80001018:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000101a:	4681                	li	a3,0
    8000101c:	4605                	li	a2,1
    8000101e:	040005b7          	lui	a1,0x4000
    80001022:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001024:	05b2                	slli	a1,a1,0xc
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	72c080e7          	jalr	1836(ra) # 80000752 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000102e:	4681                	li	a3,0
    80001030:	4605                	li	a2,1
    80001032:	020005b7          	lui	a1,0x2000
    80001036:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001038:	05b6                	slli	a1,a1,0xd
    8000103a:	8526                	mv	a0,s1
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	716080e7          	jalr	1814(ra) # 80000752 <uvmunmap>
  uvmfree(pagetable, sz);
    80001044:	85ca                	mv	a1,s2
    80001046:	8526                	mv	a0,s1
    80001048:	00000097          	auipc	ra,0x0
    8000104c:	9e8080e7          	jalr	-1560(ra) # 80000a30 <uvmfree>
}
    80001050:	60e2                	ld	ra,24(sp)
    80001052:	6442                	ld	s0,16(sp)
    80001054:	64a2                	ld	s1,8(sp)
    80001056:	6902                	ld	s2,0(sp)
    80001058:	6105                	addi	sp,sp,32
    8000105a:	8082                	ret

000000008000105c <freeproc>:
{
    8000105c:	1101                	addi	sp,sp,-32
    8000105e:	ec06                	sd	ra,24(sp)
    80001060:	e822                	sd	s0,16(sp)
    80001062:	e426                	sd	s1,8(sp)
    80001064:	1000                	addi	s0,sp,32
    80001066:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001068:	6d28                	ld	a0,88(a0)
    8000106a:	c509                	beqz	a0,80001074 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	fb0080e7          	jalr	-80(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001074:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001078:	68a8                	ld	a0,80(s1)
    8000107a:	c511                	beqz	a0,80001086 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000107c:	64ac                	ld	a1,72(s1)
    8000107e:	00000097          	auipc	ra,0x0
    80001082:	f8c080e7          	jalr	-116(ra) # 8000100a <proc_freepagetable>
  p->pagetable = 0;
    80001086:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000108a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000108e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001092:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001096:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000109a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000109e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010a2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010a6:	0004ac23          	sw	zero,24(s1)
}
    800010aa:	60e2                	ld	ra,24(sp)
    800010ac:	6442                	ld	s0,16(sp)
    800010ae:	64a2                	ld	s1,8(sp)
    800010b0:	6105                	addi	sp,sp,32
    800010b2:	8082                	ret

00000000800010b4 <allocproc>:
{
    800010b4:	1101                	addi	sp,sp,-32
    800010b6:	ec06                	sd	ra,24(sp)
    800010b8:	e822                	sd	s0,16(sp)
    800010ba:	e426                	sd	s1,8(sp)
    800010bc:	e04a                	sd	s2,0(sp)
    800010be:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c0:	00009497          	auipc	s1,0x9
    800010c4:	d4048493          	addi	s1,s1,-704 # 80009e00 <proc>
    800010c8:	0000e917          	auipc	s2,0xe
    800010cc:	73890913          	addi	s2,s2,1848 # 8000f800 <tickslock>
    acquire(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00006097          	auipc	ra,0x6
    800010d6:	e50080e7          	jalr	-432(ra) # 80006f22 <acquire>
    if(p->state == UNUSED) {
    800010da:	4c9c                	lw	a5,24(s1)
    800010dc:	cf81                	beqz	a5,800010f4 <allocproc+0x40>
      release(&p->lock);
    800010de:	8526                	mv	a0,s1
    800010e0:	00006097          	auipc	ra,0x6
    800010e4:	ef6080e7          	jalr	-266(ra) # 80006fd6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e8:	16848493          	addi	s1,s1,360
    800010ec:	ff2492e3          	bne	s1,s2,800010d0 <allocproc+0x1c>
  return 0;
    800010f0:	4481                	li	s1,0
    800010f2:	a889                	j	80001144 <allocproc+0x90>
  p->pid = allocpid();
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	e34080e7          	jalr	-460(ra) # 80000f28 <allocpid>
    800010fc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010fe:	4785                	li	a5,1
    80001100:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	018080e7          	jalr	24(ra) # 8000011a <kalloc>
    8000110a:	892a                	mv	s2,a0
    8000110c:	eca8                	sd	a0,88(s1)
    8000110e:	c131                	beqz	a0,80001152 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001110:	8526                	mv	a0,s1
    80001112:	00000097          	auipc	ra,0x0
    80001116:	e5c080e7          	jalr	-420(ra) # 80000f6e <proc_pagetable>
    8000111a:	892a                	mv	s2,a0
    8000111c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000111e:	c531                	beqz	a0,8000116a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001120:	07000613          	li	a2,112
    80001124:	4581                	li	a1,0
    80001126:	06048513          	addi	a0,s1,96
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	050080e7          	jalr	80(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001132:	00000797          	auipc	a5,0x0
    80001136:	db078793          	addi	a5,a5,-592 # 80000ee2 <forkret>
    8000113a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000113c:	60bc                	ld	a5,64(s1)
    8000113e:	6705                	lui	a4,0x1
    80001140:	97ba                	add	a5,a5,a4
    80001142:	f4bc                	sd	a5,104(s1)
}
    80001144:	8526                	mv	a0,s1
    80001146:	60e2                	ld	ra,24(sp)
    80001148:	6442                	ld	s0,16(sp)
    8000114a:	64a2                	ld	s1,8(sp)
    8000114c:	6902                	ld	s2,0(sp)
    8000114e:	6105                	addi	sp,sp,32
    80001150:	8082                	ret
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	f08080e7          	jalr	-248(ra) # 8000105c <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00006097          	auipc	ra,0x6
    80001162:	e78080e7          	jalr	-392(ra) # 80006fd6 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	bff1                	j	80001144 <allocproc+0x90>
    freeproc(p);
    8000116a:	8526                	mv	a0,s1
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	ef0080e7          	jalr	-272(ra) # 8000105c <freeproc>
    release(&p->lock);
    80001174:	8526                	mv	a0,s1
    80001176:	00006097          	auipc	ra,0x6
    8000117a:	e60080e7          	jalr	-416(ra) # 80006fd6 <release>
    return 0;
    8000117e:	84ca                	mv	s1,s2
    80001180:	b7d1                	j	80001144 <allocproc+0x90>

0000000080001182 <userinit>:
{
    80001182:	1101                	addi	sp,sp,-32
    80001184:	ec06                	sd	ra,24(sp)
    80001186:	e822                	sd	s0,16(sp)
    80001188:	e426                	sd	s1,8(sp)
    8000118a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	f28080e7          	jalr	-216(ra) # 800010b4 <allocproc>
    80001194:	84aa                	mv	s1,a0
  initproc = p;
    80001196:	00008797          	auipc	a5,0x8
    8000119a:	7ca7bd23          	sd	a0,2010(a5) # 80009970 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000119e:	03400613          	li	a2,52
    800011a2:	00008597          	auipc	a1,0x8
    800011a6:	75e58593          	addi	a1,a1,1886 # 80009900 <initcode>
    800011aa:	6928                	ld	a0,80(a0)
    800011ac:	fffff097          	auipc	ra,0xfffff
    800011b0:	6ac080e7          	jalr	1708(ra) # 80000858 <uvmfirst>
  p->sz = PGSIZE;
    800011b4:	6785                	lui	a5,0x1
    800011b6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011b8:	6cb8                	ld	a4,88(s1)
    800011ba:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011be:	6cb8                	ld	a4,88(s1)
    800011c0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c2:	4641                	li	a2,16
    800011c4:	00008597          	auipc	a1,0x8
    800011c8:	fcc58593          	addi	a1,a1,-52 # 80009190 <etext+0x190>
    800011cc:	15848513          	addi	a0,s1,344
    800011d0:	fffff097          	auipc	ra,0xfffff
    800011d4:	0f2080e7          	jalr	242(ra) # 800002c2 <safestrcpy>
  p->cwd = namei("/");
    800011d8:	00008517          	auipc	a0,0x8
    800011dc:	fc850513          	addi	a0,a0,-56 # 800091a0 <etext+0x1a0>
    800011e0:	00002097          	auipc	ra,0x2
    800011e4:	10c080e7          	jalr	268(ra) # 800032ec <namei>
    800011e8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011ec:	478d                	li	a5,3
    800011ee:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f0:	8526                	mv	a0,s1
    800011f2:	00006097          	auipc	ra,0x6
    800011f6:	de4080e7          	jalr	-540(ra) # 80006fd6 <release>
}
    800011fa:	60e2                	ld	ra,24(sp)
    800011fc:	6442                	ld	s0,16(sp)
    800011fe:	64a2                	ld	s1,8(sp)
    80001200:	6105                	addi	sp,sp,32
    80001202:	8082                	ret

0000000080001204 <growproc>:
{
    80001204:	1101                	addi	sp,sp,-32
    80001206:	ec06                	sd	ra,24(sp)
    80001208:	e822                	sd	s0,16(sp)
    8000120a:	e426                	sd	s1,8(sp)
    8000120c:	e04a                	sd	s2,0(sp)
    8000120e:	1000                	addi	s0,sp,32
    80001210:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001212:	00000097          	auipc	ra,0x0
    80001216:	c98080e7          	jalr	-872(ra) # 80000eaa <myproc>
    8000121a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000121c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000121e:	01204c63          	bgtz	s2,80001236 <growproc+0x32>
  } else if(n < 0){
    80001222:	02094663          	bltz	s2,8000124e <growproc+0x4a>
  p->sz = sz;
    80001226:	e4ac                	sd	a1,72(s1)
  return 0;
    80001228:	4501                	li	a0,0
}
    8000122a:	60e2                	ld	ra,24(sp)
    8000122c:	6442                	ld	s0,16(sp)
    8000122e:	64a2                	ld	s1,8(sp)
    80001230:	6902                	ld	s2,0(sp)
    80001232:	6105                	addi	sp,sp,32
    80001234:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001236:	4691                	li	a3,4
    80001238:	00b90633          	add	a2,s2,a1
    8000123c:	6928                	ld	a0,80(a0)
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	6d4080e7          	jalr	1748(ra) # 80000912 <uvmalloc>
    80001246:	85aa                	mv	a1,a0
    80001248:	fd79                	bnez	a0,80001226 <growproc+0x22>
      return -1;
    8000124a:	557d                	li	a0,-1
    8000124c:	bff9                	j	8000122a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000124e:	00b90633          	add	a2,s2,a1
    80001252:	6928                	ld	a0,80(a0)
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	676080e7          	jalr	1654(ra) # 800008ca <uvmdealloc>
    8000125c:	85aa                	mv	a1,a0
    8000125e:	b7e1                	j	80001226 <growproc+0x22>

0000000080001260 <fork>:
{
    80001260:	7139                	addi	sp,sp,-64
    80001262:	fc06                	sd	ra,56(sp)
    80001264:	f822                	sd	s0,48(sp)
    80001266:	f426                	sd	s1,40(sp)
    80001268:	f04a                	sd	s2,32(sp)
    8000126a:	ec4e                	sd	s3,24(sp)
    8000126c:	e852                	sd	s4,16(sp)
    8000126e:	e456                	sd	s5,8(sp)
    80001270:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c38080e7          	jalr	-968(ra) # 80000eaa <myproc>
    8000127a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	e38080e7          	jalr	-456(ra) # 800010b4 <allocproc>
    80001284:	10050c63          	beqz	a0,8000139c <fork+0x13c>
    80001288:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128a:	048ab603          	ld	a2,72(s5)
    8000128e:	692c                	ld	a1,80(a0)
    80001290:	050ab503          	ld	a0,80(s5)
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	7d6080e7          	jalr	2006(ra) # 80000a6a <uvmcopy>
    8000129c:	04054863          	bltz	a0,800012ec <fork+0x8c>
  np->sz = p->sz;
    800012a0:	048ab783          	ld	a5,72(s5)
    800012a4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012a8:	058ab683          	ld	a3,88(s5)
    800012ac:	87b6                	mv	a5,a3
    800012ae:	058a3703          	ld	a4,88(s4)
    800012b2:	12068693          	addi	a3,a3,288
    800012b6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ba:	6788                	ld	a0,8(a5)
    800012bc:	6b8c                	ld	a1,16(a5)
    800012be:	6f90                	ld	a2,24(a5)
    800012c0:	01073023          	sd	a6,0(a4)
    800012c4:	e708                	sd	a0,8(a4)
    800012c6:	eb0c                	sd	a1,16(a4)
    800012c8:	ef10                	sd	a2,24(a4)
    800012ca:	02078793          	addi	a5,a5,32
    800012ce:	02070713          	addi	a4,a4,32
    800012d2:	fed792e3          	bne	a5,a3,800012b6 <fork+0x56>
  np->trapframe->a0 = 0;
    800012d6:	058a3783          	ld	a5,88(s4)
    800012da:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012de:	0d0a8493          	addi	s1,s5,208
    800012e2:	0d0a0913          	addi	s2,s4,208
    800012e6:	150a8993          	addi	s3,s5,336
    800012ea:	a00d                	j	8000130c <fork+0xac>
    freeproc(np);
    800012ec:	8552                	mv	a0,s4
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	d6e080e7          	jalr	-658(ra) # 8000105c <freeproc>
    release(&np->lock);
    800012f6:	8552                	mv	a0,s4
    800012f8:	00006097          	auipc	ra,0x6
    800012fc:	cde080e7          	jalr	-802(ra) # 80006fd6 <release>
    return -1;
    80001300:	597d                	li	s2,-1
    80001302:	a059                	j	80001388 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001304:	04a1                	addi	s1,s1,8
    80001306:	0921                	addi	s2,s2,8
    80001308:	01348b63          	beq	s1,s3,8000131e <fork+0xbe>
    if(p->ofile[i])
    8000130c:	6088                	ld	a0,0(s1)
    8000130e:	d97d                	beqz	a0,80001304 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001310:	00002097          	auipc	ra,0x2
    80001314:	64e080e7          	jalr	1614(ra) # 8000395e <filedup>
    80001318:	00a93023          	sd	a0,0(s2)
    8000131c:	b7e5                	j	80001304 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000131e:	150ab503          	ld	a0,336(s5)
    80001322:	00001097          	auipc	ra,0x1
    80001326:	7e6080e7          	jalr	2022(ra) # 80002b08 <idup>
    8000132a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132e:	4641                	li	a2,16
    80001330:	158a8593          	addi	a1,s5,344
    80001334:	158a0513          	addi	a0,s4,344
    80001338:	fffff097          	auipc	ra,0xfffff
    8000133c:	f8a080e7          	jalr	-118(ra) # 800002c2 <safestrcpy>
  pid = np->pid;
    80001340:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001344:	8552                	mv	a0,s4
    80001346:	00006097          	auipc	ra,0x6
    8000134a:	c90080e7          	jalr	-880(ra) # 80006fd6 <release>
  acquire(&wait_lock);
    8000134e:	00008497          	auipc	s1,0x8
    80001352:	69a48493          	addi	s1,s1,1690 # 800099e8 <wait_lock>
    80001356:	8526                	mv	a0,s1
    80001358:	00006097          	auipc	ra,0x6
    8000135c:	bca080e7          	jalr	-1078(ra) # 80006f22 <acquire>
  np->parent = p;
    80001360:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001364:	8526                	mv	a0,s1
    80001366:	00006097          	auipc	ra,0x6
    8000136a:	c70080e7          	jalr	-912(ra) # 80006fd6 <release>
  acquire(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00006097          	auipc	ra,0x6
    80001374:	bb2080e7          	jalr	-1102(ra) # 80006f22 <acquire>
  np->state = RUNNABLE;
    80001378:	478d                	li	a5,3
    8000137a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000137e:	8552                	mv	a0,s4
    80001380:	00006097          	auipc	ra,0x6
    80001384:	c56080e7          	jalr	-938(ra) # 80006fd6 <release>
}
    80001388:	854a                	mv	a0,s2
    8000138a:	70e2                	ld	ra,56(sp)
    8000138c:	7442                	ld	s0,48(sp)
    8000138e:	74a2                	ld	s1,40(sp)
    80001390:	7902                	ld	s2,32(sp)
    80001392:	69e2                	ld	s3,24(sp)
    80001394:	6a42                	ld	s4,16(sp)
    80001396:	6aa2                	ld	s5,8(sp)
    80001398:	6121                	addi	sp,sp,64
    8000139a:	8082                	ret
    return -1;
    8000139c:	597d                	li	s2,-1
    8000139e:	b7ed                	j	80001388 <fork+0x128>

00000000800013a0 <scheduler>:
{
    800013a0:	7139                	addi	sp,sp,-64
    800013a2:	fc06                	sd	ra,56(sp)
    800013a4:	f822                	sd	s0,48(sp)
    800013a6:	f426                	sd	s1,40(sp)
    800013a8:	f04a                	sd	s2,32(sp)
    800013aa:	ec4e                	sd	s3,24(sp)
    800013ac:	e852                	sd	s4,16(sp)
    800013ae:	e456                	sd	s5,8(sp)
    800013b0:	e05a                	sd	s6,0(sp)
    800013b2:	0080                	addi	s0,sp,64
    800013b4:	8792                	mv	a5,tp
  int id = r_tp();
    800013b6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b8:	00779a93          	slli	s5,a5,0x7
    800013bc:	00008717          	auipc	a4,0x8
    800013c0:	61470713          	addi	a4,a4,1556 # 800099d0 <pid_lock>
    800013c4:	9756                	add	a4,a4,s5
    800013c6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ca:	00008717          	auipc	a4,0x8
    800013ce:	63e70713          	addi	a4,a4,1598 # 80009a08 <cpus+0x8>
    800013d2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d4:	498d                	li	s3,3
        p->state = RUNNING;
    800013d6:	4b11                	li	s6,4
        c->proc = p;
    800013d8:	079e                	slli	a5,a5,0x7
    800013da:	00008a17          	auipc	s4,0x8
    800013de:	5f6a0a13          	addi	s4,s4,1526 # 800099d0 <pid_lock>
    800013e2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e4:	0000e917          	auipc	s2,0xe
    800013e8:	41c90913          	addi	s2,s2,1052 # 8000f800 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f4:	10079073          	csrw	sstatus,a5
    800013f8:	00009497          	auipc	s1,0x9
    800013fc:	a0848493          	addi	s1,s1,-1528 # 80009e00 <proc>
    80001400:	a811                	j	80001414 <scheduler+0x74>
      release(&p->lock);
    80001402:	8526                	mv	a0,s1
    80001404:	00006097          	auipc	ra,0x6
    80001408:	bd2080e7          	jalr	-1070(ra) # 80006fd6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140c:	16848493          	addi	s1,s1,360
    80001410:	fd248ee3          	beq	s1,s2,800013ec <scheduler+0x4c>
      acquire(&p->lock);
    80001414:	8526                	mv	a0,s1
    80001416:	00006097          	auipc	ra,0x6
    8000141a:	b0c080e7          	jalr	-1268(ra) # 80006f22 <acquire>
      if(p->state == RUNNABLE) {
    8000141e:	4c9c                	lw	a5,24(s1)
    80001420:	ff3791e3          	bne	a5,s3,80001402 <scheduler+0x62>
        p->state = RUNNING;
    80001424:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001428:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000142c:	06048593          	addi	a1,s1,96
    80001430:	8556                	mv	a0,s5
    80001432:	00000097          	auipc	ra,0x0
    80001436:	684080e7          	jalr	1668(ra) # 80001ab6 <swtch>
        c->proc = 0;
    8000143a:	020a3823          	sd	zero,48(s4)
    8000143e:	b7d1                	j	80001402 <scheduler+0x62>

0000000080001440 <sched>:
{
    80001440:	7179                	addi	sp,sp,-48
    80001442:	f406                	sd	ra,40(sp)
    80001444:	f022                	sd	s0,32(sp)
    80001446:	ec26                	sd	s1,24(sp)
    80001448:	e84a                	sd	s2,16(sp)
    8000144a:	e44e                	sd	s3,8(sp)
    8000144c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000144e:	00000097          	auipc	ra,0x0
    80001452:	a5c080e7          	jalr	-1444(ra) # 80000eaa <myproc>
    80001456:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001458:	00006097          	auipc	ra,0x6
    8000145c:	a50080e7          	jalr	-1456(ra) # 80006ea8 <holding>
    80001460:	c93d                	beqz	a0,800014d6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001462:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001464:	2781                	sext.w	a5,a5
    80001466:	079e                	slli	a5,a5,0x7
    80001468:	00008717          	auipc	a4,0x8
    8000146c:	56870713          	addi	a4,a4,1384 # 800099d0 <pid_lock>
    80001470:	97ba                	add	a5,a5,a4
    80001472:	0a87a703          	lw	a4,168(a5)
    80001476:	4785                	li	a5,1
    80001478:	06f71763          	bne	a4,a5,800014e6 <sched+0xa6>
  if(p->state == RUNNING)
    8000147c:	4c98                	lw	a4,24(s1)
    8000147e:	4791                	li	a5,4
    80001480:	06f70b63          	beq	a4,a5,800014f6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001484:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001488:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148a:	efb5                	bnez	a5,80001506 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000148c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000148e:	00008917          	auipc	s2,0x8
    80001492:	54290913          	addi	s2,s2,1346 # 800099d0 <pid_lock>
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	97ca                	add	a5,a5,s2
    8000149c:	0ac7a983          	lw	s3,172(a5)
    800014a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a2:	2781                	sext.w	a5,a5
    800014a4:	079e                	slli	a5,a5,0x7
    800014a6:	00008597          	auipc	a1,0x8
    800014aa:	56258593          	addi	a1,a1,1378 # 80009a08 <cpus+0x8>
    800014ae:	95be                	add	a1,a1,a5
    800014b0:	06048513          	addi	a0,s1,96
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	602080e7          	jalr	1538(ra) # 80001ab6 <swtch>
    800014bc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014be:	2781                	sext.w	a5,a5
    800014c0:	079e                	slli	a5,a5,0x7
    800014c2:	993e                	add	s2,s2,a5
    800014c4:	0b392623          	sw	s3,172(s2)
}
    800014c8:	70a2                	ld	ra,40(sp)
    800014ca:	7402                	ld	s0,32(sp)
    800014cc:	64e2                	ld	s1,24(sp)
    800014ce:	6942                	ld	s2,16(sp)
    800014d0:	69a2                	ld	s3,8(sp)
    800014d2:	6145                	addi	sp,sp,48
    800014d4:	8082                	ret
    panic("sched p->lock");
    800014d6:	00008517          	auipc	a0,0x8
    800014da:	cd250513          	addi	a0,a0,-814 # 800091a8 <etext+0x1a8>
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	50c080e7          	jalr	1292(ra) # 800069ea <panic>
    panic("sched locks");
    800014e6:	00008517          	auipc	a0,0x8
    800014ea:	cd250513          	addi	a0,a0,-814 # 800091b8 <etext+0x1b8>
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	4fc080e7          	jalr	1276(ra) # 800069ea <panic>
    panic("sched running");
    800014f6:	00008517          	auipc	a0,0x8
    800014fa:	cd250513          	addi	a0,a0,-814 # 800091c8 <etext+0x1c8>
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	4ec080e7          	jalr	1260(ra) # 800069ea <panic>
    panic("sched interruptible");
    80001506:	00008517          	auipc	a0,0x8
    8000150a:	cd250513          	addi	a0,a0,-814 # 800091d8 <etext+0x1d8>
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	4dc080e7          	jalr	1244(ra) # 800069ea <panic>

0000000080001516 <yield>:
{
    80001516:	1101                	addi	sp,sp,-32
    80001518:	ec06                	sd	ra,24(sp)
    8000151a:	e822                	sd	s0,16(sp)
    8000151c:	e426                	sd	s1,8(sp)
    8000151e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001520:	00000097          	auipc	ra,0x0
    80001524:	98a080e7          	jalr	-1654(ra) # 80000eaa <myproc>
    80001528:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152a:	00006097          	auipc	ra,0x6
    8000152e:	9f8080e7          	jalr	-1544(ra) # 80006f22 <acquire>
  p->state = RUNNABLE;
    80001532:	478d                	li	a5,3
    80001534:	cc9c                	sw	a5,24(s1)
  sched();
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	f0a080e7          	jalr	-246(ra) # 80001440 <sched>
  release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00006097          	auipc	ra,0x6
    80001544:	a96080e7          	jalr	-1386(ra) # 80006fd6 <release>
}
    80001548:	60e2                	ld	ra,24(sp)
    8000154a:	6442                	ld	s0,16(sp)
    8000154c:	64a2                	ld	s1,8(sp)
    8000154e:	6105                	addi	sp,sp,32
    80001550:	8082                	ret

0000000080001552 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001552:	7179                	addi	sp,sp,-48
    80001554:	f406                	sd	ra,40(sp)
    80001556:	f022                	sd	s0,32(sp)
    80001558:	ec26                	sd	s1,24(sp)
    8000155a:	e84a                	sd	s2,16(sp)
    8000155c:	e44e                	sd	s3,8(sp)
    8000155e:	1800                	addi	s0,sp,48
    80001560:	89aa                	mv	s3,a0
    80001562:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001564:	00000097          	auipc	ra,0x0
    80001568:	946080e7          	jalr	-1722(ra) # 80000eaa <myproc>
    8000156c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000156e:	00006097          	auipc	ra,0x6
    80001572:	9b4080e7          	jalr	-1612(ra) # 80006f22 <acquire>
  release(lk);
    80001576:	854a                	mv	a0,s2
    80001578:	00006097          	auipc	ra,0x6
    8000157c:	a5e080e7          	jalr	-1442(ra) # 80006fd6 <release>

  // Go to sleep.
  p->chan = chan;
    80001580:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001584:	4789                	li	a5,2
    80001586:	cc9c                	sw	a5,24(s1)

  sched();
    80001588:	00000097          	auipc	ra,0x0
    8000158c:	eb8080e7          	jalr	-328(ra) # 80001440 <sched>

  // Tidy up.
  p->chan = 0;
    80001590:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001594:	8526                	mv	a0,s1
    80001596:	00006097          	auipc	ra,0x6
    8000159a:	a40080e7          	jalr	-1472(ra) # 80006fd6 <release>
  acquire(lk);
    8000159e:	854a                	mv	a0,s2
    800015a0:	00006097          	auipc	ra,0x6
    800015a4:	982080e7          	jalr	-1662(ra) # 80006f22 <acquire>
}
    800015a8:	70a2                	ld	ra,40(sp)
    800015aa:	7402                	ld	s0,32(sp)
    800015ac:	64e2                	ld	s1,24(sp)
    800015ae:	6942                	ld	s2,16(sp)
    800015b0:	69a2                	ld	s3,8(sp)
    800015b2:	6145                	addi	sp,sp,48
    800015b4:	8082                	ret

00000000800015b6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015b6:	7139                	addi	sp,sp,-64
    800015b8:	fc06                	sd	ra,56(sp)
    800015ba:	f822                	sd	s0,48(sp)
    800015bc:	f426                	sd	s1,40(sp)
    800015be:	f04a                	sd	s2,32(sp)
    800015c0:	ec4e                	sd	s3,24(sp)
    800015c2:	e852                	sd	s4,16(sp)
    800015c4:	e456                	sd	s5,8(sp)
    800015c6:	0080                	addi	s0,sp,64
    800015c8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015ca:	00009497          	auipc	s1,0x9
    800015ce:	83648493          	addi	s1,s1,-1994 # 80009e00 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015d2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015d4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d6:	0000e917          	auipc	s2,0xe
    800015da:	22a90913          	addi	s2,s2,554 # 8000f800 <tickslock>
    800015de:	a811                	j	800015f2 <wakeup+0x3c>
      }
      release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00006097          	auipc	ra,0x6
    800015e6:	9f4080e7          	jalr	-1548(ra) # 80006fd6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ea:	16848493          	addi	s1,s1,360
    800015ee:	03248663          	beq	s1,s2,8000161a <wakeup+0x64>
    if(p != myproc()){
    800015f2:	00000097          	auipc	ra,0x0
    800015f6:	8b8080e7          	jalr	-1864(ra) # 80000eaa <myproc>
    800015fa:	fea488e3          	beq	s1,a0,800015ea <wakeup+0x34>
      acquire(&p->lock);
    800015fe:	8526                	mv	a0,s1
    80001600:	00006097          	auipc	ra,0x6
    80001604:	922080e7          	jalr	-1758(ra) # 80006f22 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001608:	4c9c                	lw	a5,24(s1)
    8000160a:	fd379be3          	bne	a5,s3,800015e0 <wakeup+0x2a>
    8000160e:	709c                	ld	a5,32(s1)
    80001610:	fd4798e3          	bne	a5,s4,800015e0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001614:	0154ac23          	sw	s5,24(s1)
    80001618:	b7e1                	j	800015e0 <wakeup+0x2a>
    }
  }
}
    8000161a:	70e2                	ld	ra,56(sp)
    8000161c:	7442                	ld	s0,48(sp)
    8000161e:	74a2                	ld	s1,40(sp)
    80001620:	7902                	ld	s2,32(sp)
    80001622:	69e2                	ld	s3,24(sp)
    80001624:	6a42                	ld	s4,16(sp)
    80001626:	6aa2                	ld	s5,8(sp)
    80001628:	6121                	addi	sp,sp,64
    8000162a:	8082                	ret

000000008000162c <reparent>:
{
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	e052                	sd	s4,0(sp)
    8000163a:	1800                	addi	s0,sp,48
    8000163c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000163e:	00008497          	auipc	s1,0x8
    80001642:	7c248493          	addi	s1,s1,1986 # 80009e00 <proc>
      pp->parent = initproc;
    80001646:	00008a17          	auipc	s4,0x8
    8000164a:	32aa0a13          	addi	s4,s4,810 # 80009970 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000164e:	0000e997          	auipc	s3,0xe
    80001652:	1b298993          	addi	s3,s3,434 # 8000f800 <tickslock>
    80001656:	a029                	j	80001660 <reparent+0x34>
    80001658:	16848493          	addi	s1,s1,360
    8000165c:	01348d63          	beq	s1,s3,80001676 <reparent+0x4a>
    if(pp->parent == p){
    80001660:	7c9c                	ld	a5,56(s1)
    80001662:	ff279be3          	bne	a5,s2,80001658 <reparent+0x2c>
      pp->parent = initproc;
    80001666:	000a3503          	ld	a0,0(s4)
    8000166a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000166c:	00000097          	auipc	ra,0x0
    80001670:	f4a080e7          	jalr	-182(ra) # 800015b6 <wakeup>
    80001674:	b7d5                	j	80001658 <reparent+0x2c>
}
    80001676:	70a2                	ld	ra,40(sp)
    80001678:	7402                	ld	s0,32(sp)
    8000167a:	64e2                	ld	s1,24(sp)
    8000167c:	6942                	ld	s2,16(sp)
    8000167e:	69a2                	ld	s3,8(sp)
    80001680:	6a02                	ld	s4,0(sp)
    80001682:	6145                	addi	sp,sp,48
    80001684:	8082                	ret

0000000080001686 <exit>:
{
    80001686:	7179                	addi	sp,sp,-48
    80001688:	f406                	sd	ra,40(sp)
    8000168a:	f022                	sd	s0,32(sp)
    8000168c:	ec26                	sd	s1,24(sp)
    8000168e:	e84a                	sd	s2,16(sp)
    80001690:	e44e                	sd	s3,8(sp)
    80001692:	e052                	sd	s4,0(sp)
    80001694:	1800                	addi	s0,sp,48
    80001696:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	812080e7          	jalr	-2030(ra) # 80000eaa <myproc>
    800016a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800016a2:	00008797          	auipc	a5,0x8
    800016a6:	2ce7b783          	ld	a5,718(a5) # 80009970 <initproc>
    800016aa:	0d050493          	addi	s1,a0,208
    800016ae:	15050913          	addi	s2,a0,336
    800016b2:	02a79363          	bne	a5,a0,800016d8 <exit+0x52>
    panic("init exiting");
    800016b6:	00008517          	auipc	a0,0x8
    800016ba:	b3a50513          	addi	a0,a0,-1222 # 800091f0 <etext+0x1f0>
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	32c080e7          	jalr	812(ra) # 800069ea <panic>
      fileclose(f);
    800016c6:	00002097          	auipc	ra,0x2
    800016ca:	2ea080e7          	jalr	746(ra) # 800039b0 <fileclose>
      p->ofile[fd] = 0;
    800016ce:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016d2:	04a1                	addi	s1,s1,8
    800016d4:	01248563          	beq	s1,s2,800016de <exit+0x58>
    if(p->ofile[fd]){
    800016d8:	6088                	ld	a0,0(s1)
    800016da:	f575                	bnez	a0,800016c6 <exit+0x40>
    800016dc:	bfdd                	j	800016d2 <exit+0x4c>
  begin_op();
    800016de:	00002097          	auipc	ra,0x2
    800016e2:	e0e080e7          	jalr	-498(ra) # 800034ec <begin_op>
  iput(p->cwd);
    800016e6:	1509b503          	ld	a0,336(s3)
    800016ea:	00001097          	auipc	ra,0x1
    800016ee:	616080e7          	jalr	1558(ra) # 80002d00 <iput>
  end_op();
    800016f2:	00002097          	auipc	ra,0x2
    800016f6:	e74080e7          	jalr	-396(ra) # 80003566 <end_op>
  p->cwd = 0;
    800016fa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016fe:	00008497          	auipc	s1,0x8
    80001702:	2ea48493          	addi	s1,s1,746 # 800099e8 <wait_lock>
    80001706:	8526                	mv	a0,s1
    80001708:	00006097          	auipc	ra,0x6
    8000170c:	81a080e7          	jalr	-2022(ra) # 80006f22 <acquire>
  reparent(p);
    80001710:	854e                	mv	a0,s3
    80001712:	00000097          	auipc	ra,0x0
    80001716:	f1a080e7          	jalr	-230(ra) # 8000162c <reparent>
  wakeup(p->parent);
    8000171a:	0389b503          	ld	a0,56(s3)
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	e98080e7          	jalr	-360(ra) # 800015b6 <wakeup>
  acquire(&p->lock);
    80001726:	854e                	mv	a0,s3
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	7fa080e7          	jalr	2042(ra) # 80006f22 <acquire>
  p->xstate = status;
    80001730:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001734:	4795                	li	a5,5
    80001736:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000173a:	8526                	mv	a0,s1
    8000173c:	00006097          	auipc	ra,0x6
    80001740:	89a080e7          	jalr	-1894(ra) # 80006fd6 <release>
  sched();
    80001744:	00000097          	auipc	ra,0x0
    80001748:	cfc080e7          	jalr	-772(ra) # 80001440 <sched>
  panic("zombie exit");
    8000174c:	00008517          	auipc	a0,0x8
    80001750:	ab450513          	addi	a0,a0,-1356 # 80009200 <etext+0x200>
    80001754:	00005097          	auipc	ra,0x5
    80001758:	296080e7          	jalr	662(ra) # 800069ea <panic>

000000008000175c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	1800                	addi	s0,sp,48
    8000176a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000176c:	00008497          	auipc	s1,0x8
    80001770:	69448493          	addi	s1,s1,1684 # 80009e00 <proc>
    80001774:	0000e997          	auipc	s3,0xe
    80001778:	08c98993          	addi	s3,s3,140 # 8000f800 <tickslock>
    acquire(&p->lock);
    8000177c:	8526                	mv	a0,s1
    8000177e:	00005097          	auipc	ra,0x5
    80001782:	7a4080e7          	jalr	1956(ra) # 80006f22 <acquire>
    if(p->pid == pid){
    80001786:	589c                	lw	a5,48(s1)
    80001788:	01278d63          	beq	a5,s2,800017a2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000178c:	8526                	mv	a0,s1
    8000178e:	00006097          	auipc	ra,0x6
    80001792:	848080e7          	jalr	-1976(ra) # 80006fd6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001796:	16848493          	addi	s1,s1,360
    8000179a:	ff3491e3          	bne	s1,s3,8000177c <kill+0x20>
  }
  return -1;
    8000179e:	557d                	li	a0,-1
    800017a0:	a829                	j	800017ba <kill+0x5e>
      p->killed = 1;
    800017a2:	4785                	li	a5,1
    800017a4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017a6:	4c98                	lw	a4,24(s1)
    800017a8:	4789                	li	a5,2
    800017aa:	00f70f63          	beq	a4,a5,800017c8 <kill+0x6c>
      release(&p->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00006097          	auipc	ra,0x6
    800017b4:	826080e7          	jalr	-2010(ra) # 80006fd6 <release>
      return 0;
    800017b8:	4501                	li	a0,0
}
    800017ba:	70a2                	ld	ra,40(sp)
    800017bc:	7402                	ld	s0,32(sp)
    800017be:	64e2                	ld	s1,24(sp)
    800017c0:	6942                	ld	s2,16(sp)
    800017c2:	69a2                	ld	s3,8(sp)
    800017c4:	6145                	addi	sp,sp,48
    800017c6:	8082                	ret
        p->state = RUNNABLE;
    800017c8:	478d                	li	a5,3
    800017ca:	cc9c                	sw	a5,24(s1)
    800017cc:	b7cd                	j	800017ae <kill+0x52>

00000000800017ce <setkilled>:

void
setkilled(struct proc *p)
{
    800017ce:	1101                	addi	sp,sp,-32
    800017d0:	ec06                	sd	ra,24(sp)
    800017d2:	e822                	sd	s0,16(sp)
    800017d4:	e426                	sd	s1,8(sp)
    800017d6:	1000                	addi	s0,sp,32
    800017d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017da:	00005097          	auipc	ra,0x5
    800017de:	748080e7          	jalr	1864(ra) # 80006f22 <acquire>
  p->killed = 1;
    800017e2:	4785                	li	a5,1
    800017e4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017e6:	8526                	mv	a0,s1
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	7ee080e7          	jalr	2030(ra) # 80006fd6 <release>
}
    800017f0:	60e2                	ld	ra,24(sp)
    800017f2:	6442                	ld	s0,16(sp)
    800017f4:	64a2                	ld	s1,8(sp)
    800017f6:	6105                	addi	sp,sp,32
    800017f8:	8082                	ret

00000000800017fa <killed>:

int
killed(struct proc *p)
{
    800017fa:	1101                	addi	sp,sp,-32
    800017fc:	ec06                	sd	ra,24(sp)
    800017fe:	e822                	sd	s0,16(sp)
    80001800:	e426                	sd	s1,8(sp)
    80001802:	e04a                	sd	s2,0(sp)
    80001804:	1000                	addi	s0,sp,32
    80001806:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	71a080e7          	jalr	1818(ra) # 80006f22 <acquire>
  k = p->killed;
    80001810:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	7c0080e7          	jalr	1984(ra) # 80006fd6 <release>
  return k;
}
    8000181e:	854a                	mv	a0,s2
    80001820:	60e2                	ld	ra,24(sp)
    80001822:	6442                	ld	s0,16(sp)
    80001824:	64a2                	ld	s1,8(sp)
    80001826:	6902                	ld	s2,0(sp)
    80001828:	6105                	addi	sp,sp,32
    8000182a:	8082                	ret

000000008000182c <wait>:
{
    8000182c:	715d                	addi	sp,sp,-80
    8000182e:	e486                	sd	ra,72(sp)
    80001830:	e0a2                	sd	s0,64(sp)
    80001832:	fc26                	sd	s1,56(sp)
    80001834:	f84a                	sd	s2,48(sp)
    80001836:	f44e                	sd	s3,40(sp)
    80001838:	f052                	sd	s4,32(sp)
    8000183a:	ec56                	sd	s5,24(sp)
    8000183c:	e85a                	sd	s6,16(sp)
    8000183e:	e45e                	sd	s7,8(sp)
    80001840:	e062                	sd	s8,0(sp)
    80001842:	0880                	addi	s0,sp,80
    80001844:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001846:	fffff097          	auipc	ra,0xfffff
    8000184a:	664080e7          	jalr	1636(ra) # 80000eaa <myproc>
    8000184e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001850:	00008517          	auipc	a0,0x8
    80001854:	19850513          	addi	a0,a0,408 # 800099e8 <wait_lock>
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	6ca080e7          	jalr	1738(ra) # 80006f22 <acquire>
    havekids = 0;
    80001860:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001862:	4a15                	li	s4,5
        havekids = 1;
    80001864:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001866:	0000e997          	auipc	s3,0xe
    8000186a:	f9a98993          	addi	s3,s3,-102 # 8000f800 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000186e:	00008c17          	auipc	s8,0x8
    80001872:	17ac0c13          	addi	s8,s8,378 # 800099e8 <wait_lock>
    80001876:	a0d1                	j	8000193a <wait+0x10e>
          pid = pp->pid;
    80001878:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000187c:	000b0e63          	beqz	s6,80001898 <wait+0x6c>
    80001880:	4691                	li	a3,4
    80001882:	02c48613          	addi	a2,s1,44
    80001886:	85da                	mv	a1,s6
    80001888:	05093503          	ld	a0,80(s2)
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	2e2080e7          	jalr	738(ra) # 80000b6e <copyout>
    80001894:	04054163          	bltz	a0,800018d6 <wait+0xaa>
          freeproc(pp);
    80001898:	8526                	mv	a0,s1
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	7c2080e7          	jalr	1986(ra) # 8000105c <freeproc>
          release(&pp->lock);
    800018a2:	8526                	mv	a0,s1
    800018a4:	00005097          	auipc	ra,0x5
    800018a8:	732080e7          	jalr	1842(ra) # 80006fd6 <release>
          release(&wait_lock);
    800018ac:	00008517          	auipc	a0,0x8
    800018b0:	13c50513          	addi	a0,a0,316 # 800099e8 <wait_lock>
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	722080e7          	jalr	1826(ra) # 80006fd6 <release>
}
    800018bc:	854e                	mv	a0,s3
    800018be:	60a6                	ld	ra,72(sp)
    800018c0:	6406                	ld	s0,64(sp)
    800018c2:	74e2                	ld	s1,56(sp)
    800018c4:	7942                	ld	s2,48(sp)
    800018c6:	79a2                	ld	s3,40(sp)
    800018c8:	7a02                	ld	s4,32(sp)
    800018ca:	6ae2                	ld	s5,24(sp)
    800018cc:	6b42                	ld	s6,16(sp)
    800018ce:	6ba2                	ld	s7,8(sp)
    800018d0:	6c02                	ld	s8,0(sp)
    800018d2:	6161                	addi	sp,sp,80
    800018d4:	8082                	ret
            release(&pp->lock);
    800018d6:	8526                	mv	a0,s1
    800018d8:	00005097          	auipc	ra,0x5
    800018dc:	6fe080e7          	jalr	1790(ra) # 80006fd6 <release>
            release(&wait_lock);
    800018e0:	00008517          	auipc	a0,0x8
    800018e4:	10850513          	addi	a0,a0,264 # 800099e8 <wait_lock>
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	6ee080e7          	jalr	1774(ra) # 80006fd6 <release>
            return -1;
    800018f0:	59fd                	li	s3,-1
    800018f2:	b7e9                	j	800018bc <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	16848493          	addi	s1,s1,360
    800018f8:	03348463          	beq	s1,s3,80001920 <wait+0xf4>
      if(pp->parent == p){
    800018fc:	7c9c                	ld	a5,56(s1)
    800018fe:	ff279be3          	bne	a5,s2,800018f4 <wait+0xc8>
        acquire(&pp->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	61e080e7          	jalr	1566(ra) # 80006f22 <acquire>
        if(pp->state == ZOMBIE){
    8000190c:	4c9c                	lw	a5,24(s1)
    8000190e:	f74785e3          	beq	a5,s4,80001878 <wait+0x4c>
        release(&pp->lock);
    80001912:	8526                	mv	a0,s1
    80001914:	00005097          	auipc	ra,0x5
    80001918:	6c2080e7          	jalr	1730(ra) # 80006fd6 <release>
        havekids = 1;
    8000191c:	8756                	mv	a4,s5
    8000191e:	bfd9                	j	800018f4 <wait+0xc8>
    if(!havekids || killed(p)){
    80001920:	c31d                	beqz	a4,80001946 <wait+0x11a>
    80001922:	854a                	mv	a0,s2
    80001924:	00000097          	auipc	ra,0x0
    80001928:	ed6080e7          	jalr	-298(ra) # 800017fa <killed>
    8000192c:	ed09                	bnez	a0,80001946 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000192e:	85e2                	mv	a1,s8
    80001930:	854a                	mv	a0,s2
    80001932:	00000097          	auipc	ra,0x0
    80001936:	c20080e7          	jalr	-992(ra) # 80001552 <sleep>
    havekids = 0;
    8000193a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193c:	00008497          	auipc	s1,0x8
    80001940:	4c448493          	addi	s1,s1,1220 # 80009e00 <proc>
    80001944:	bf65                	j	800018fc <wait+0xd0>
      release(&wait_lock);
    80001946:	00008517          	auipc	a0,0x8
    8000194a:	0a250513          	addi	a0,a0,162 # 800099e8 <wait_lock>
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	688080e7          	jalr	1672(ra) # 80006fd6 <release>
      return -1;
    80001956:	59fd                	li	s3,-1
    80001958:	b795                	j	800018bc <wait+0x90>

000000008000195a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	84aa                	mv	s1,a0
    8000196c:	892e                	mv	s2,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	538080e7          	jalr	1336(ra) # 80000eaa <myproc>
  if(user_dst){
    8000197a:	c08d                	beqz	s1,8000199c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	1ea080e7          	jalr	490(ra) # 80000b6e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove((char *)dst, src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	832080e7          	jalr	-1998(ra) # 800001d6 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyout+0x32>

00000000800019b0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019b0:	7179                	addi	sp,sp,-48
    800019b2:	f406                	sd	ra,40(sp)
    800019b4:	f022                	sd	s0,32(sp)
    800019b6:	ec26                	sd	s1,24(sp)
    800019b8:	e84a                	sd	s2,16(sp)
    800019ba:	e44e                	sd	s3,8(sp)
    800019bc:	e052                	sd	s4,0(sp)
    800019be:	1800                	addi	s0,sp,48
    800019c0:	892a                	mv	s2,a0
    800019c2:	84ae                	mv	s1,a1
    800019c4:	89b2                	mv	s3,a2
    800019c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	4e2080e7          	jalr	1250(ra) # 80000eaa <myproc>
  if(user_src){
    800019d0:	c08d                	beqz	s1,800019f2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019d2:	86d2                	mv	a3,s4
    800019d4:	864e                	mv	a2,s3
    800019d6:	85ca                	mv	a1,s2
    800019d8:	6928                	ld	a0,80(a0)
    800019da:	fffff097          	auipc	ra,0xfffff
    800019de:	220080e7          	jalr	544(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019e2:	70a2                	ld	ra,40(sp)
    800019e4:	7402                	ld	s0,32(sp)
    800019e6:	64e2                	ld	s1,24(sp)
    800019e8:	6942                	ld	s2,16(sp)
    800019ea:	69a2                	ld	s3,8(sp)
    800019ec:	6a02                	ld	s4,0(sp)
    800019ee:	6145                	addi	sp,sp,48
    800019f0:	8082                	ret
    memmove(dst, (char*)src, len);
    800019f2:	000a061b          	sext.w	a2,s4
    800019f6:	85ce                	mv	a1,s3
    800019f8:	854a                	mv	a0,s2
    800019fa:	ffffe097          	auipc	ra,0xffffe
    800019fe:	7dc080e7          	jalr	2012(ra) # 800001d6 <memmove>
    return 0;
    80001a02:	8526                	mv	a0,s1
    80001a04:	bff9                	j	800019e2 <either_copyin+0x32>

0000000080001a06 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a06:	715d                	addi	sp,sp,-80
    80001a08:	e486                	sd	ra,72(sp)
    80001a0a:	e0a2                	sd	s0,64(sp)
    80001a0c:	fc26                	sd	s1,56(sp)
    80001a0e:	f84a                	sd	s2,48(sp)
    80001a10:	f44e                	sd	s3,40(sp)
    80001a12:	f052                	sd	s4,32(sp)
    80001a14:	ec56                	sd	s5,24(sp)
    80001a16:	e85a                	sd	s6,16(sp)
    80001a18:	e45e                	sd	s7,8(sp)
    80001a1a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a1c:	00007517          	auipc	a0,0x7
    80001a20:	62c50513          	addi	a0,a0,1580 # 80009048 <etext+0x48>
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	010080e7          	jalr	16(ra) # 80006a34 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2c:	00008497          	auipc	s1,0x8
    80001a30:	52c48493          	addi	s1,s1,1324 # 80009f58 <proc+0x158>
    80001a34:	0000e917          	auipc	s2,0xe
    80001a38:	f2490913          	addi	s2,s2,-220 # 8000f958 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a3e:	00007997          	auipc	s3,0x7
    80001a42:	7d298993          	addi	s3,s3,2002 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001a46:	00007a97          	auipc	s5,0x7
    80001a4a:	7d2a8a93          	addi	s5,s5,2002 # 80009218 <etext+0x218>
    printf("\n");
    80001a4e:	00007a17          	auipc	s4,0x7
    80001a52:	5faa0a13          	addi	s4,s4,1530 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a56:	00008b97          	auipc	s7,0x8
    80001a5a:	802b8b93          	addi	s7,s7,-2046 # 80009258 <states.0>
    80001a5e:	a00d                	j	80001a80 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a60:	ed86a583          	lw	a1,-296(a3)
    80001a64:	8556                	mv	a0,s5
    80001a66:	00005097          	auipc	ra,0x5
    80001a6a:	fce080e7          	jalr	-50(ra) # 80006a34 <printf>
    printf("\n");
    80001a6e:	8552                	mv	a0,s4
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	fc4080e7          	jalr	-60(ra) # 80006a34 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a78:	16848493          	addi	s1,s1,360
    80001a7c:	03248263          	beq	s1,s2,80001aa0 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a80:	86a6                	mv	a3,s1
    80001a82:	ec04a783          	lw	a5,-320(s1)
    80001a86:	dbed                	beqz	a5,80001a78 <procdump+0x72>
      state = "???";
    80001a88:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a8a:	fcfb6be3          	bltu	s6,a5,80001a60 <procdump+0x5a>
    80001a8e:	02079713          	slli	a4,a5,0x20
    80001a92:	01d75793          	srli	a5,a4,0x1d
    80001a96:	97de                	add	a5,a5,s7
    80001a98:	6390                	ld	a2,0(a5)
    80001a9a:	f279                	bnez	a2,80001a60 <procdump+0x5a>
      state = "???";
    80001a9c:	864e                	mv	a2,s3
    80001a9e:	b7c9                	j	80001a60 <procdump+0x5a>
  }
}
    80001aa0:	60a6                	ld	ra,72(sp)
    80001aa2:	6406                	ld	s0,64(sp)
    80001aa4:	74e2                	ld	s1,56(sp)
    80001aa6:	7942                	ld	s2,48(sp)
    80001aa8:	79a2                	ld	s3,40(sp)
    80001aaa:	7a02                	ld	s4,32(sp)
    80001aac:	6ae2                	ld	s5,24(sp)
    80001aae:	6b42                	ld	s6,16(sp)
    80001ab0:	6ba2                	ld	s7,8(sp)
    80001ab2:	6161                	addi	sp,sp,80
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
    80001b28:	00007597          	auipc	a1,0x7
    80001b2c:	76058593          	addi	a1,a1,1888 # 80009288 <states.0+0x30>
    80001b30:	0000e517          	auipc	a0,0xe
    80001b34:	cd050513          	addi	a0,a0,-816 # 8000f800 <tickslock>
    80001b38:	00005097          	auipc	ra,0x5
    80001b3c:	35a080e7          	jalr	858(ra) # 80006e92 <initlock>
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
    80001b52:	53278793          	addi	a5,a5,1330 # 80005080 <kernelvec>
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
    80001b6c:	342080e7          	jalr	834(ra) # 80000eaa <myproc>
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
    80001b7a:	00006697          	auipc	a3,0x6
    80001b7e:	48668693          	addi	a3,a3,1158 # 80008000 <_trampoline>
    80001b82:	00006717          	auipc	a4,0x6
    80001b86:	47e70713          	addi	a4,a4,1150 # 80008000 <_trampoline>
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
    80001bb2:	14660613          	addi	a2,a2,326 # 80001cf4 <usertrap>
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
    80001bda:	00006717          	auipc	a4,0x6
    80001bde:	4c270713          	addi	a4,a4,1218 # 8000809c <userret>
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
    80001c00:	0000e497          	auipc	s1,0xe
    80001c04:	c0048493          	addi	s1,s1,-1024 # 8000f800 <tickslock>
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00005097          	auipc	ra,0x5
    80001c0e:	318080e7          	jalr	792(ra) # 80006f22 <acquire>
  ticks++;
    80001c12:	00008517          	auipc	a0,0x8
    80001c16:	d6650513          	addi	a0,a0,-666 # 80009978 <ticks>
    80001c1a:	411c                	lw	a5,0(a0)
    80001c1c:	2785                	addiw	a5,a5,1
    80001c1e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c20:	00000097          	auipc	ra,0x0
    80001c24:	996080e7          	jalr	-1642(ra) # 800015b6 <wakeup>
  release(&tickslock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00005097          	auipc	ra,0x5
    80001c2e:	3ac080e7          	jalr	940(ra) # 80006fd6 <release>
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
    80001c42:	0a07d863          	bgez	a5,80001cf2 <devintr+0xb6>
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
    80001c62:	06e78763          	beq	a5,a4,80001cd0 <devintr+0x94>
  }
}
    80001c66:	60e2                	ld	ra,24(sp)
    80001c68:	6442                	ld	s0,16(sp)
    80001c6a:	64a2                	ld	s1,8(sp)
    80001c6c:	6105                	addi	sp,sp,32
    80001c6e:	8082                	ret
    int irq = plic_claim();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	532080e7          	jalr	1330(ra) # 800051a2 <plic_claim>
    80001c78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7a:	47a9                	li	a5,10
    80001c7c:	02f50563          	beq	a0,a5,80001ca6 <devintr+0x6a>
    } else if(irq == VIRTIO0_IRQ){
    80001c80:	4785                	li	a5,1
    80001c82:	02f50d63          	beq	a0,a5,80001cbc <devintr+0x80>
    else if(irq == E1000_IRQ){
    80001c86:	02100793          	li	a5,33
    80001c8a:	02f50e63          	beq	a0,a5,80001cc6 <devintr+0x8a>
    return 1;
    80001c8e:	4505                	li	a0,1
    else if(irq){
    80001c90:	d8f9                	beqz	s1,80001c66 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c92:	85a6                	mv	a1,s1
    80001c94:	00007517          	auipc	a0,0x7
    80001c98:	5fc50513          	addi	a0,a0,1532 # 80009290 <states.0+0x38>
    80001c9c:	00005097          	auipc	ra,0x5
    80001ca0:	d98080e7          	jalr	-616(ra) # 80006a34 <printf>
    if(irq)
    80001ca4:	a029                	j	80001cae <devintr+0x72>
      uartintr();
    80001ca6:	00005097          	auipc	ra,0x5
    80001caa:	19c080e7          	jalr	412(ra) # 80006e42 <uartintr>
      plic_complete(irq);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	00003097          	auipc	ra,0x3
    80001cb4:	516080e7          	jalr	1302(ra) # 800051c6 <plic_complete>
    return 1;
    80001cb8:	4505                	li	a0,1
    80001cba:	b775                	j	80001c66 <devintr+0x2a>
      virtio_disk_intr();
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	9d0080e7          	jalr	-1584(ra) # 8000568c <virtio_disk_intr>
    if(irq)
    80001cc4:	b7ed                	j	80001cae <devintr+0x72>
      e1000_intr();
    80001cc6:	00004097          	auipc	ra,0x4
    80001cca:	c3a080e7          	jalr	-966(ra) # 80005900 <e1000_intr>
    if(irq)
    80001cce:	b7c5                	j	80001cae <devintr+0x72>
    if(cpuid() == 0){
    80001cd0:	fffff097          	auipc	ra,0xfffff
    80001cd4:	1ae080e7          	jalr	430(ra) # 80000e7e <cpuid>
    80001cd8:	c901                	beqz	a0,80001ce8 <devintr+0xac>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cda:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce0:	14479073          	csrw	sip,a5
    return 2;
    80001ce4:	4509                	li	a0,2
    80001ce6:	b741                	j	80001c66 <devintr+0x2a>
      clockintr();
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	f0e080e7          	jalr	-242(ra) # 80001bf6 <clockintr>
    80001cf0:	b7ed                	j	80001cda <devintr+0x9e>
}
    80001cf2:	8082                	ret

0000000080001cf4 <usertrap>:
{
    80001cf4:	1101                	addi	sp,sp,-32
    80001cf6:	ec06                	sd	ra,24(sp)
    80001cf8:	e822                	sd	s0,16(sp)
    80001cfa:	e426                	sd	s1,8(sp)
    80001cfc:	e04a                	sd	s2,0(sp)
    80001cfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d00:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d04:	1007f793          	andi	a5,a5,256
    80001d08:	e3b1                	bnez	a5,80001d4c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d0a:	00003797          	auipc	a5,0x3
    80001d0e:	37678793          	addi	a5,a5,886 # 80005080 <kernelvec>
    80001d12:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	194080e7          	jalr	404(ra) # 80000eaa <myproc>
    80001d1e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d20:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d22:	14102773          	csrr	a4,sepc
    80001d26:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d28:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d2c:	47a1                	li	a5,8
    80001d2e:	02f70763          	beq	a4,a5,80001d5c <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	f0a080e7          	jalr	-246(ra) # 80001c3c <devintr>
    80001d3a:	892a                	mv	s2,a0
    80001d3c:	c151                	beqz	a0,80001dc0 <usertrap+0xcc>
  if(killed(p))
    80001d3e:	8526                	mv	a0,s1
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	aba080e7          	jalr	-1350(ra) # 800017fa <killed>
    80001d48:	c929                	beqz	a0,80001d9a <usertrap+0xa6>
    80001d4a:	a099                	j	80001d90 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d4c:	00007517          	auipc	a0,0x7
    80001d50:	56450513          	addi	a0,a0,1380 # 800092b0 <states.0+0x58>
    80001d54:	00005097          	auipc	ra,0x5
    80001d58:	c96080e7          	jalr	-874(ra) # 800069ea <panic>
    if(killed(p))
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	a9e080e7          	jalr	-1378(ra) # 800017fa <killed>
    80001d64:	e921                	bnez	a0,80001db4 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d66:	6cb8                	ld	a4,88(s1)
    80001d68:	6f1c                	ld	a5,24(a4)
    80001d6a:	0791                	addi	a5,a5,4
    80001d6c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d76:	10079073          	csrw	sstatus,a5
    syscall();
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	2d4080e7          	jalr	724(ra) # 8000204e <syscall>
  if(killed(p))
    80001d82:	8526                	mv	a0,s1
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	a76080e7          	jalr	-1418(ra) # 800017fa <killed>
    80001d8c:	c911                	beqz	a0,80001da0 <usertrap+0xac>
    80001d8e:	4901                	li	s2,0
    exit(-1);
    80001d90:	557d                	li	a0,-1
    80001d92:	00000097          	auipc	ra,0x0
    80001d96:	8f4080e7          	jalr	-1804(ra) # 80001686 <exit>
  if(which_dev == 2)
    80001d9a:	4789                	li	a5,2
    80001d9c:	04f90f63          	beq	s2,a5,80001dfa <usertrap+0x106>
  usertrapret();
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	dc0080e7          	jalr	-576(ra) # 80001b60 <usertrapret>
}
    80001da8:	60e2                	ld	ra,24(sp)
    80001daa:	6442                	ld	s0,16(sp)
    80001dac:	64a2                	ld	s1,8(sp)
    80001dae:	6902                	ld	s2,0(sp)
    80001db0:	6105                	addi	sp,sp,32
    80001db2:	8082                	ret
      exit(-1);
    80001db4:	557d                	li	a0,-1
    80001db6:	00000097          	auipc	ra,0x0
    80001dba:	8d0080e7          	jalr	-1840(ra) # 80001686 <exit>
    80001dbe:	b765                	j	80001d66 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dc4:	5890                	lw	a2,48(s1)
    80001dc6:	00007517          	auipc	a0,0x7
    80001dca:	50a50513          	addi	a0,a0,1290 # 800092d0 <states.0+0x78>
    80001dce:	00005097          	auipc	ra,0x5
    80001dd2:	c66080e7          	jalr	-922(ra) # 80006a34 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dd6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dda:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dde:	00007517          	auipc	a0,0x7
    80001de2:	52250513          	addi	a0,a0,1314 # 80009300 <states.0+0xa8>
    80001de6:	00005097          	auipc	ra,0x5
    80001dea:	c4e080e7          	jalr	-946(ra) # 80006a34 <printf>
    setkilled(p);
    80001dee:	8526                	mv	a0,s1
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	9de080e7          	jalr	-1570(ra) # 800017ce <setkilled>
    80001df8:	b769                	j	80001d82 <usertrap+0x8e>
    yield();
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	71c080e7          	jalr	1820(ra) # 80001516 <yield>
    80001e02:	bf79                	j	80001da0 <usertrap+0xac>

0000000080001e04 <kerneltrap>:
{
    80001e04:	7179                	addi	sp,sp,-48
    80001e06:	f406                	sd	ra,40(sp)
    80001e08:	f022                	sd	s0,32(sp)
    80001e0a:	ec26                	sd	s1,24(sp)
    80001e0c:	e84a                	sd	s2,16(sp)
    80001e0e:	e44e                	sd	s3,8(sp)
    80001e10:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e12:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e16:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e1a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e1e:	1004f793          	andi	a5,s1,256
    80001e22:	cb85                	beqz	a5,80001e52 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e28:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e2a:	ef85                	bnez	a5,80001e62 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	e10080e7          	jalr	-496(ra) # 80001c3c <devintr>
    80001e34:	cd1d                	beqz	a0,80001e72 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e36:	4789                	li	a5,2
    80001e38:	06f50a63          	beq	a0,a5,80001eac <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e3c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e40:	10049073          	csrw	sstatus,s1
}
    80001e44:	70a2                	ld	ra,40(sp)
    80001e46:	7402                	ld	s0,32(sp)
    80001e48:	64e2                	ld	s1,24(sp)
    80001e4a:	6942                	ld	s2,16(sp)
    80001e4c:	69a2                	ld	s3,8(sp)
    80001e4e:	6145                	addi	sp,sp,48
    80001e50:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e52:	00007517          	auipc	a0,0x7
    80001e56:	4ce50513          	addi	a0,a0,1230 # 80009320 <states.0+0xc8>
    80001e5a:	00005097          	auipc	ra,0x5
    80001e5e:	b90080e7          	jalr	-1136(ra) # 800069ea <panic>
    panic("kerneltrap: interrupts enabled");
    80001e62:	00007517          	auipc	a0,0x7
    80001e66:	4e650513          	addi	a0,a0,1254 # 80009348 <states.0+0xf0>
    80001e6a:	00005097          	auipc	ra,0x5
    80001e6e:	b80080e7          	jalr	-1152(ra) # 800069ea <panic>
    printf("scause %p\n", scause);
    80001e72:	85ce                	mv	a1,s3
    80001e74:	00007517          	auipc	a0,0x7
    80001e78:	4f450513          	addi	a0,a0,1268 # 80009368 <states.0+0x110>
    80001e7c:	00005097          	auipc	ra,0x5
    80001e80:	bb8080e7          	jalr	-1096(ra) # 80006a34 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e88:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8c:	00007517          	auipc	a0,0x7
    80001e90:	4ec50513          	addi	a0,a0,1260 # 80009378 <states.0+0x120>
    80001e94:	00005097          	auipc	ra,0x5
    80001e98:	ba0080e7          	jalr	-1120(ra) # 80006a34 <printf>
    panic("kerneltrap");
    80001e9c:	00007517          	auipc	a0,0x7
    80001ea0:	4f450513          	addi	a0,a0,1268 # 80009390 <states.0+0x138>
    80001ea4:	00005097          	auipc	ra,0x5
    80001ea8:	b46080e7          	jalr	-1210(ra) # 800069ea <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eac:	fffff097          	auipc	ra,0xfffff
    80001eb0:	ffe080e7          	jalr	-2(ra) # 80000eaa <myproc>
    80001eb4:	d541                	beqz	a0,80001e3c <kerneltrap+0x38>
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	ff4080e7          	jalr	-12(ra) # 80000eaa <myproc>
    80001ebe:	4d18                	lw	a4,24(a0)
    80001ec0:	4791                	li	a5,4
    80001ec2:	f6f71de3          	bne	a4,a5,80001e3c <kerneltrap+0x38>
    yield();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	650080e7          	jalr	1616(ra) # 80001516 <yield>
    80001ece:	b7bd                	j	80001e3c <kerneltrap+0x38>

0000000080001ed0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ed0:	1101                	addi	sp,sp,-32
    80001ed2:	ec06                	sd	ra,24(sp)
    80001ed4:	e822                	sd	s0,16(sp)
    80001ed6:	e426                	sd	s1,8(sp)
    80001ed8:	1000                	addi	s0,sp,32
    80001eda:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	fce080e7          	jalr	-50(ra) # 80000eaa <myproc>
  switch (n) {
    80001ee4:	4795                	li	a5,5
    80001ee6:	0497e163          	bltu	a5,s1,80001f28 <argraw+0x58>
    80001eea:	048a                	slli	s1,s1,0x2
    80001eec:	00007717          	auipc	a4,0x7
    80001ef0:	4dc70713          	addi	a4,a4,1244 # 800093c8 <states.0+0x170>
    80001ef4:	94ba                	add	s1,s1,a4
    80001ef6:	409c                	lw	a5,0(s1)
    80001ef8:	97ba                	add	a5,a5,a4
    80001efa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	64a2                	ld	s1,8(sp)
    80001f06:	6105                	addi	sp,sp,32
    80001f08:	8082                	ret
    return p->trapframe->a1;
    80001f0a:	6d3c                	ld	a5,88(a0)
    80001f0c:	7fa8                	ld	a0,120(a5)
    80001f0e:	bfcd                	j	80001f00 <argraw+0x30>
    return p->trapframe->a2;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	63c8                	ld	a0,128(a5)
    80001f14:	b7f5                	j	80001f00 <argraw+0x30>
    return p->trapframe->a3;
    80001f16:	6d3c                	ld	a5,88(a0)
    80001f18:	67c8                	ld	a0,136(a5)
    80001f1a:	b7dd                	j	80001f00 <argraw+0x30>
    return p->trapframe->a4;
    80001f1c:	6d3c                	ld	a5,88(a0)
    80001f1e:	6bc8                	ld	a0,144(a5)
    80001f20:	b7c5                	j	80001f00 <argraw+0x30>
    return p->trapframe->a5;
    80001f22:	6d3c                	ld	a5,88(a0)
    80001f24:	6fc8                	ld	a0,152(a5)
    80001f26:	bfe9                	j	80001f00 <argraw+0x30>
  panic("argraw");
    80001f28:	00007517          	auipc	a0,0x7
    80001f2c:	47850513          	addi	a0,a0,1144 # 800093a0 <states.0+0x148>
    80001f30:	00005097          	auipc	ra,0x5
    80001f34:	aba080e7          	jalr	-1350(ra) # 800069ea <panic>

0000000080001f38 <fetchaddr>:
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84aa                	mv	s1,a0
    80001f46:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	f62080e7          	jalr	-158(ra) # 80000eaa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f50:	653c                	ld	a5,72(a0)
    80001f52:	02f4f863          	bgeu	s1,a5,80001f82 <fetchaddr+0x4a>
    80001f56:	00848713          	addi	a4,s1,8
    80001f5a:	02e7e663          	bltu	a5,a4,80001f86 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f5e:	46a1                	li	a3,8
    80001f60:	8626                	mv	a2,s1
    80001f62:	85ca                	mv	a1,s2
    80001f64:	6928                	ld	a0,80(a0)
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	c94080e7          	jalr	-876(ra) # 80000bfa <copyin>
    80001f6e:	00a03533          	snez	a0,a0
    80001f72:	40a00533          	neg	a0,a0
}
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6902                	ld	s2,0(sp)
    80001f7e:	6105                	addi	sp,sp,32
    80001f80:	8082                	ret
    return -1;
    80001f82:	557d                	li	a0,-1
    80001f84:	bfcd                	j	80001f76 <fetchaddr+0x3e>
    80001f86:	557d                	li	a0,-1
    80001f88:	b7fd                	j	80001f76 <fetchaddr+0x3e>

0000000080001f8a <fetchstr>:
{
    80001f8a:	7179                	addi	sp,sp,-48
    80001f8c:	f406                	sd	ra,40(sp)
    80001f8e:	f022                	sd	s0,32(sp)
    80001f90:	ec26                	sd	s1,24(sp)
    80001f92:	e84a                	sd	s2,16(sp)
    80001f94:	e44e                	sd	s3,8(sp)
    80001f96:	1800                	addi	s0,sp,48
    80001f98:	892a                	mv	s2,a0
    80001f9a:	84ae                	mv	s1,a1
    80001f9c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	f0c080e7          	jalr	-244(ra) # 80000eaa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fa6:	86ce                	mv	a3,s3
    80001fa8:	864a                	mv	a2,s2
    80001faa:	85a6                	mv	a1,s1
    80001fac:	6928                	ld	a0,80(a0)
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	cda080e7          	jalr	-806(ra) # 80000c88 <copyinstr>
    80001fb6:	00054e63          	bltz	a0,80001fd2 <fetchstr+0x48>
  return strlen(buf);
    80001fba:	8526                	mv	a0,s1
    80001fbc:	ffffe097          	auipc	ra,0xffffe
    80001fc0:	338080e7          	jalr	824(ra) # 800002f4 <strlen>
}
    80001fc4:	70a2                	ld	ra,40(sp)
    80001fc6:	7402                	ld	s0,32(sp)
    80001fc8:	64e2                	ld	s1,24(sp)
    80001fca:	6942                	ld	s2,16(sp)
    80001fcc:	69a2                	ld	s3,8(sp)
    80001fce:	6145                	addi	sp,sp,48
    80001fd0:	8082                	ret
    return -1;
    80001fd2:	557d                	li	a0,-1
    80001fd4:	bfc5                	j	80001fc4 <fetchstr+0x3a>

0000000080001fd6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fd6:	1101                	addi	sp,sp,-32
    80001fd8:	ec06                	sd	ra,24(sp)
    80001fda:	e822                	sd	s0,16(sp)
    80001fdc:	e426                	sd	s1,8(sp)
    80001fde:	1000                	addi	s0,sp,32
    80001fe0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	eee080e7          	jalr	-274(ra) # 80001ed0 <argraw>
    80001fea:	c088                	sw	a0,0(s1)
}
    80001fec:	60e2                	ld	ra,24(sp)
    80001fee:	6442                	ld	s0,16(sp)
    80001ff0:	64a2                	ld	s1,8(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret

0000000080001ff6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001ff6:	1101                	addi	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	1000                	addi	s0,sp,32
    80002000:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002002:	00000097          	auipc	ra,0x0
    80002006:	ece080e7          	jalr	-306(ra) # 80001ed0 <argraw>
    8000200a:	e088                	sd	a0,0(s1)
}
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002016:	7179                	addi	sp,sp,-48
    80002018:	f406                	sd	ra,40(sp)
    8000201a:	f022                	sd	s0,32(sp)
    8000201c:	ec26                	sd	s1,24(sp)
    8000201e:	e84a                	sd	s2,16(sp)
    80002020:	1800                	addi	s0,sp,48
    80002022:	84ae                	mv	s1,a1
    80002024:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002026:	fd840593          	addi	a1,s0,-40
    8000202a:	00000097          	auipc	ra,0x0
    8000202e:	fcc080e7          	jalr	-52(ra) # 80001ff6 <argaddr>
  return fetchstr(addr, buf, max);
    80002032:	864a                	mv	a2,s2
    80002034:	85a6                	mv	a1,s1
    80002036:	fd843503          	ld	a0,-40(s0)
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	f50080e7          	jalr	-176(ra) # 80001f8a <fetchstr>
}
    80002042:	70a2                	ld	ra,40(sp)
    80002044:	7402                	ld	s0,32(sp)
    80002046:	64e2                	ld	s1,24(sp)
    80002048:	6942                	ld	s2,16(sp)
    8000204a:	6145                	addi	sp,sp,48
    8000204c:	8082                	ret

000000008000204e <syscall>:



void
syscall(void)
{
    8000204e:	1101                	addi	sp,sp,-32
    80002050:	ec06                	sd	ra,24(sp)
    80002052:	e822                	sd	s0,16(sp)
    80002054:	e426                	sd	s1,8(sp)
    80002056:	e04a                	sd	s2,0(sp)
    80002058:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	e50080e7          	jalr	-432(ra) # 80000eaa <myproc>
    80002062:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002064:	05853903          	ld	s2,88(a0)
    80002068:	0a893783          	ld	a5,168(s2)
    8000206c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002070:	37fd                	addiw	a5,a5,-1
    80002072:	4771                	li	a4,28
    80002074:	00f76f63          	bltu	a4,a5,80002092 <syscall+0x44>
    80002078:	00369713          	slli	a4,a3,0x3
    8000207c:	00007797          	auipc	a5,0x7
    80002080:	36478793          	addi	a5,a5,868 # 800093e0 <syscalls>
    80002084:	97ba                	add	a5,a5,a4
    80002086:	639c                	ld	a5,0(a5)
    80002088:	c789                	beqz	a5,80002092 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000208a:	9782                	jalr	a5
    8000208c:	06a93823          	sd	a0,112(s2)
    80002090:	a839                	j	800020ae <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002092:	15848613          	addi	a2,s1,344
    80002096:	588c                	lw	a1,48(s1)
    80002098:	00007517          	auipc	a0,0x7
    8000209c:	31050513          	addi	a0,a0,784 # 800093a8 <states.0+0x150>
    800020a0:	00005097          	auipc	ra,0x5
    800020a4:	994080e7          	jalr	-1644(ra) # 80006a34 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020a8:	6cbc                	ld	a5,88(s1)
    800020aa:	577d                	li	a4,-1
    800020ac:	fbb8                	sd	a4,112(a5)
  }
}
    800020ae:	60e2                	ld	ra,24(sp)
    800020b0:	6442                	ld	s0,16(sp)
    800020b2:	64a2                	ld	s1,8(sp)
    800020b4:	6902                	ld	s2,0(sp)
    800020b6:	6105                	addi	sp,sp,32
    800020b8:	8082                	ret

00000000800020ba <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ba:	1101                	addi	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020c2:	fec40593          	addi	a1,s0,-20
    800020c6:	4501                	li	a0,0
    800020c8:	00000097          	auipc	ra,0x0
    800020cc:	f0e080e7          	jalr	-242(ra) # 80001fd6 <argint>
  exit(n);
    800020d0:	fec42503          	lw	a0,-20(s0)
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	5b2080e7          	jalr	1458(ra) # 80001686 <exit>
  return 0;  // not reached
}
    800020dc:	4501                	li	a0,0
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	dbc080e7          	jalr	-580(ra) # 80000eaa <myproc>
}
    800020f6:	5908                	lw	a0,48(a0)
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_fork>:

uint64
sys_fork(void)
{
    80002100:	1141                	addi	sp,sp,-16
    80002102:	e406                	sd	ra,8(sp)
    80002104:	e022                	sd	s0,0(sp)
    80002106:	0800                	addi	s0,sp,16
  return fork();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	158080e7          	jalr	344(ra) # 80001260 <fork>
}
    80002110:	60a2                	ld	ra,8(sp)
    80002112:	6402                	ld	s0,0(sp)
    80002114:	0141                	addi	sp,sp,16
    80002116:	8082                	ret

0000000080002118 <sys_wait>:

uint64
sys_wait(void)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002120:	fe840593          	addi	a1,s0,-24
    80002124:	4501                	li	a0,0
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	ed0080e7          	jalr	-304(ra) # 80001ff6 <argaddr>
  return wait(p);
    8000212e:	fe843503          	ld	a0,-24(s0)
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	6fa080e7          	jalr	1786(ra) # 8000182c <wait>
}
    8000213a:	60e2                	ld	ra,24(sp)
    8000213c:	6442                	ld	s0,16(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002142:	7179                	addi	sp,sp,-48
    80002144:	f406                	sd	ra,40(sp)
    80002146:	f022                	sd	s0,32(sp)
    80002148:	ec26                	sd	s1,24(sp)
    8000214a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000214c:	fdc40593          	addi	a1,s0,-36
    80002150:	4501                	li	a0,0
    80002152:	00000097          	auipc	ra,0x0
    80002156:	e84080e7          	jalr	-380(ra) # 80001fd6 <argint>
  addr = myproc()->sz;
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	d50080e7          	jalr	-688(ra) # 80000eaa <myproc>
    80002162:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002164:	fdc42503          	lw	a0,-36(s0)
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	09c080e7          	jalr	156(ra) # 80001204 <growproc>
    80002170:	00054863          	bltz	a0,80002180 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002174:	8526                	mv	a0,s1
    80002176:	70a2                	ld	ra,40(sp)
    80002178:	7402                	ld	s0,32(sp)
    8000217a:	64e2                	ld	s1,24(sp)
    8000217c:	6145                	addi	sp,sp,48
    8000217e:	8082                	ret
    return -1;
    80002180:	54fd                	li	s1,-1
    80002182:	bfcd                	j	80002174 <sys_sbrk+0x32>

0000000080002184 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002184:	7139                	addi	sp,sp,-64
    80002186:	fc06                	sd	ra,56(sp)
    80002188:	f822                	sd	s0,48(sp)
    8000218a:	f426                	sd	s1,40(sp)
    8000218c:	f04a                	sd	s2,32(sp)
    8000218e:	ec4e                	sd	s3,24(sp)
    80002190:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002192:	fcc40593          	addi	a1,s0,-52
    80002196:	4501                	li	a0,0
    80002198:	00000097          	auipc	ra,0x0
    8000219c:	e3e080e7          	jalr	-450(ra) # 80001fd6 <argint>
  if(n < 0)
    800021a0:	fcc42783          	lw	a5,-52(s0)
    800021a4:	0607cf63          	bltz	a5,80002222 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021a8:	0000d517          	auipc	a0,0xd
    800021ac:	65850513          	addi	a0,a0,1624 # 8000f800 <tickslock>
    800021b0:	00005097          	auipc	ra,0x5
    800021b4:	d72080e7          	jalr	-654(ra) # 80006f22 <acquire>
  ticks0 = ticks;
    800021b8:	00007917          	auipc	s2,0x7
    800021bc:	7c092903          	lw	s2,1984(s2) # 80009978 <ticks>
  while(ticks - ticks0 < n){
    800021c0:	fcc42783          	lw	a5,-52(s0)
    800021c4:	cf9d                	beqz	a5,80002202 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021c6:	0000d997          	auipc	s3,0xd
    800021ca:	63a98993          	addi	s3,s3,1594 # 8000f800 <tickslock>
    800021ce:	00007497          	auipc	s1,0x7
    800021d2:	7aa48493          	addi	s1,s1,1962 # 80009978 <ticks>
    if(killed(myproc())){
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	cd4080e7          	jalr	-812(ra) # 80000eaa <myproc>
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	61c080e7          	jalr	1564(ra) # 800017fa <killed>
    800021e6:	e129                	bnez	a0,80002228 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021e8:	85ce                	mv	a1,s3
    800021ea:	8526                	mv	a0,s1
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	366080e7          	jalr	870(ra) # 80001552 <sleep>
  while(ticks - ticks0 < n){
    800021f4:	409c                	lw	a5,0(s1)
    800021f6:	412787bb          	subw	a5,a5,s2
    800021fa:	fcc42703          	lw	a4,-52(s0)
    800021fe:	fce7ece3          	bltu	a5,a4,800021d6 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002202:	0000d517          	auipc	a0,0xd
    80002206:	5fe50513          	addi	a0,a0,1534 # 8000f800 <tickslock>
    8000220a:	00005097          	auipc	ra,0x5
    8000220e:	dcc080e7          	jalr	-564(ra) # 80006fd6 <release>
  return 0;
    80002212:	4501                	li	a0,0
}
    80002214:	70e2                	ld	ra,56(sp)
    80002216:	7442                	ld	s0,48(sp)
    80002218:	74a2                	ld	s1,40(sp)
    8000221a:	7902                	ld	s2,32(sp)
    8000221c:	69e2                	ld	s3,24(sp)
    8000221e:	6121                	addi	sp,sp,64
    80002220:	8082                	ret
    n = 0;
    80002222:	fc042623          	sw	zero,-52(s0)
    80002226:	b749                	j	800021a8 <sys_sleep+0x24>
      release(&tickslock);
    80002228:	0000d517          	auipc	a0,0xd
    8000222c:	5d850513          	addi	a0,a0,1496 # 8000f800 <tickslock>
    80002230:	00005097          	auipc	ra,0x5
    80002234:	da6080e7          	jalr	-602(ra) # 80006fd6 <release>
      return -1;
    80002238:	557d                	li	a0,-1
    8000223a:	bfe9                	j	80002214 <sys_sleep+0x90>

000000008000223c <sys_kill>:

uint64
sys_kill(void)
{
    8000223c:	1101                	addi	sp,sp,-32
    8000223e:	ec06                	sd	ra,24(sp)
    80002240:	e822                	sd	s0,16(sp)
    80002242:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002244:	fec40593          	addi	a1,s0,-20
    80002248:	4501                	li	a0,0
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	d8c080e7          	jalr	-628(ra) # 80001fd6 <argint>
  return kill(pid);
    80002252:	fec42503          	lw	a0,-20(s0)
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	506080e7          	jalr	1286(ra) # 8000175c <kill>
}
    8000225e:	60e2                	ld	ra,24(sp)
    80002260:	6442                	ld	s0,16(sp)
    80002262:	6105                	addi	sp,sp,32
    80002264:	8082                	ret

0000000080002266 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002266:	1101                	addi	sp,sp,-32
    80002268:	ec06                	sd	ra,24(sp)
    8000226a:	e822                	sd	s0,16(sp)
    8000226c:	e426                	sd	s1,8(sp)
    8000226e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	59050513          	addi	a0,a0,1424 # 8000f800 <tickslock>
    80002278:	00005097          	auipc	ra,0x5
    8000227c:	caa080e7          	jalr	-854(ra) # 80006f22 <acquire>
  xticks = ticks;
    80002280:	00007497          	auipc	s1,0x7
    80002284:	6f84a483          	lw	s1,1784(s1) # 80009978 <ticks>
  release(&tickslock);
    80002288:	0000d517          	auipc	a0,0xd
    8000228c:	57850513          	addi	a0,a0,1400 # 8000f800 <tickslock>
    80002290:	00005097          	auipc	ra,0x5
    80002294:	d46080e7          	jalr	-698(ra) # 80006fd6 <release>
  return xticks;
}
    80002298:	02049513          	slli	a0,s1,0x20
    8000229c:	9101                	srli	a0,a0,0x20
    8000229e:	60e2                	ld	ra,24(sp)
    800022a0:	6442                	ld	s0,16(sp)
    800022a2:	64a2                	ld	s1,8(sp)
    800022a4:	6105                	addi	sp,sp,32
    800022a6:	8082                	ret

00000000800022a8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022a8:	7179                	addi	sp,sp,-48
    800022aa:	f406                	sd	ra,40(sp)
    800022ac:	f022                	sd	s0,32(sp)
    800022ae:	ec26                	sd	s1,24(sp)
    800022b0:	e84a                	sd	s2,16(sp)
    800022b2:	e44e                	sd	s3,8(sp)
    800022b4:	e052                	sd	s4,0(sp)
    800022b6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022b8:	00007597          	auipc	a1,0x7
    800022bc:	21858593          	addi	a1,a1,536 # 800094d0 <syscalls+0xf0>
    800022c0:	0000d517          	auipc	a0,0xd
    800022c4:	55850513          	addi	a0,a0,1368 # 8000f818 <bcache>
    800022c8:	00005097          	auipc	ra,0x5
    800022cc:	bca080e7          	jalr	-1078(ra) # 80006e92 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022d0:	00015797          	auipc	a5,0x15
    800022d4:	54878793          	addi	a5,a5,1352 # 80017818 <bcache+0x8000>
    800022d8:	00015717          	auipc	a4,0x15
    800022dc:	7a870713          	addi	a4,a4,1960 # 80017a80 <bcache+0x8268>
    800022e0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022e4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022e8:	0000d497          	auipc	s1,0xd
    800022ec:	54848493          	addi	s1,s1,1352 # 8000f830 <bcache+0x18>
    b->next = bcache.head.next;
    800022f0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022f2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022f4:	00007a17          	auipc	s4,0x7
    800022f8:	1e4a0a13          	addi	s4,s4,484 # 800094d8 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022fc:	2b893783          	ld	a5,696(s2)
    80002300:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002302:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002306:	85d2                	mv	a1,s4
    80002308:	01048513          	addi	a0,s1,16
    8000230c:	00001097          	auipc	ra,0x1
    80002310:	496080e7          	jalr	1174(ra) # 800037a2 <initsleeplock>
    bcache.head.next->prev = b;
    80002314:	2b893783          	ld	a5,696(s2)
    80002318:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000231a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000231e:	45848493          	addi	s1,s1,1112
    80002322:	fd349de3          	bne	s1,s3,800022fc <binit+0x54>
  }
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	64e2                	ld	s1,24(sp)
    8000232c:	6942                	ld	s2,16(sp)
    8000232e:	69a2                	ld	s3,8(sp)
    80002330:	6a02                	ld	s4,0(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret

0000000080002336 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002336:	7179                	addi	sp,sp,-48
    80002338:	f406                	sd	ra,40(sp)
    8000233a:	f022                	sd	s0,32(sp)
    8000233c:	ec26                	sd	s1,24(sp)
    8000233e:	e84a                	sd	s2,16(sp)
    80002340:	e44e                	sd	s3,8(sp)
    80002342:	1800                	addi	s0,sp,48
    80002344:	892a                	mv	s2,a0
    80002346:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002348:	0000d517          	auipc	a0,0xd
    8000234c:	4d050513          	addi	a0,a0,1232 # 8000f818 <bcache>
    80002350:	00005097          	auipc	ra,0x5
    80002354:	bd2080e7          	jalr	-1070(ra) # 80006f22 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002358:	00015497          	auipc	s1,0x15
    8000235c:	7784b483          	ld	s1,1912(s1) # 80017ad0 <bcache+0x82b8>
    80002360:	00015797          	auipc	a5,0x15
    80002364:	72078793          	addi	a5,a5,1824 # 80017a80 <bcache+0x8268>
    80002368:	02f48f63          	beq	s1,a5,800023a6 <bread+0x70>
    8000236c:	873e                	mv	a4,a5
    8000236e:	a021                	j	80002376 <bread+0x40>
    80002370:	68a4                	ld	s1,80(s1)
    80002372:	02e48a63          	beq	s1,a4,800023a6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002376:	449c                	lw	a5,8(s1)
    80002378:	ff279ce3          	bne	a5,s2,80002370 <bread+0x3a>
    8000237c:	44dc                	lw	a5,12(s1)
    8000237e:	ff3799e3          	bne	a5,s3,80002370 <bread+0x3a>
      b->refcnt++;
    80002382:	40bc                	lw	a5,64(s1)
    80002384:	2785                	addiw	a5,a5,1
    80002386:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002388:	0000d517          	auipc	a0,0xd
    8000238c:	49050513          	addi	a0,a0,1168 # 8000f818 <bcache>
    80002390:	00005097          	auipc	ra,0x5
    80002394:	c46080e7          	jalr	-954(ra) # 80006fd6 <release>
      acquiresleep(&b->lock);
    80002398:	01048513          	addi	a0,s1,16
    8000239c:	00001097          	auipc	ra,0x1
    800023a0:	440080e7          	jalr	1088(ra) # 800037dc <acquiresleep>
      return b;
    800023a4:	a8b9                	j	80002402 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023a6:	00015497          	auipc	s1,0x15
    800023aa:	7224b483          	ld	s1,1826(s1) # 80017ac8 <bcache+0x82b0>
    800023ae:	00015797          	auipc	a5,0x15
    800023b2:	6d278793          	addi	a5,a5,1746 # 80017a80 <bcache+0x8268>
    800023b6:	00f48863          	beq	s1,a5,800023c6 <bread+0x90>
    800023ba:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023bc:	40bc                	lw	a5,64(s1)
    800023be:	cf81                	beqz	a5,800023d6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c0:	64a4                	ld	s1,72(s1)
    800023c2:	fee49de3          	bne	s1,a4,800023bc <bread+0x86>
  panic("bget: no buffers");
    800023c6:	00007517          	auipc	a0,0x7
    800023ca:	11a50513          	addi	a0,a0,282 # 800094e0 <syscalls+0x100>
    800023ce:	00004097          	auipc	ra,0x4
    800023d2:	61c080e7          	jalr	1564(ra) # 800069ea <panic>
      b->dev = dev;
    800023d6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023da:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023de:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023e2:	4785                	li	a5,1
    800023e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e6:	0000d517          	auipc	a0,0xd
    800023ea:	43250513          	addi	a0,a0,1074 # 8000f818 <bcache>
    800023ee:	00005097          	auipc	ra,0x5
    800023f2:	be8080e7          	jalr	-1048(ra) # 80006fd6 <release>
      acquiresleep(&b->lock);
    800023f6:	01048513          	addi	a0,s1,16
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	3e2080e7          	jalr	994(ra) # 800037dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002402:	409c                	lw	a5,0(s1)
    80002404:	cb89                	beqz	a5,80002416 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002406:	8526                	mv	a0,s1
    80002408:	70a2                	ld	ra,40(sp)
    8000240a:	7402                	ld	s0,32(sp)
    8000240c:	64e2                	ld	s1,24(sp)
    8000240e:	6942                	ld	s2,16(sp)
    80002410:	69a2                	ld	s3,8(sp)
    80002412:	6145                	addi	sp,sp,48
    80002414:	8082                	ret
    virtio_disk_rw(b, 0);
    80002416:	4581                	li	a1,0
    80002418:	8526                	mv	a0,s1
    8000241a:	00003097          	auipc	ra,0x3
    8000241e:	042080e7          	jalr	66(ra) # 8000545c <virtio_disk_rw>
    b->valid = 1;
    80002422:	4785                	li	a5,1
    80002424:	c09c                	sw	a5,0(s1)
  return b;
    80002426:	b7c5                	j	80002406 <bread+0xd0>

0000000080002428 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	addi	s0,sp,32
    80002432:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002434:	0541                	addi	a0,a0,16
    80002436:	00001097          	auipc	ra,0x1
    8000243a:	440080e7          	jalr	1088(ra) # 80003876 <holdingsleep>
    8000243e:	cd01                	beqz	a0,80002456 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002440:	4585                	li	a1,1
    80002442:	8526                	mv	a0,s1
    80002444:	00003097          	auipc	ra,0x3
    80002448:	018080e7          	jalr	24(ra) # 8000545c <virtio_disk_rw>
}
    8000244c:	60e2                	ld	ra,24(sp)
    8000244e:	6442                	ld	s0,16(sp)
    80002450:	64a2                	ld	s1,8(sp)
    80002452:	6105                	addi	sp,sp,32
    80002454:	8082                	ret
    panic("bwrite");
    80002456:	00007517          	auipc	a0,0x7
    8000245a:	0a250513          	addi	a0,a0,162 # 800094f8 <syscalls+0x118>
    8000245e:	00004097          	auipc	ra,0x4
    80002462:	58c080e7          	jalr	1420(ra) # 800069ea <panic>

0000000080002466 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002466:	1101                	addi	sp,sp,-32
    80002468:	ec06                	sd	ra,24(sp)
    8000246a:	e822                	sd	s0,16(sp)
    8000246c:	e426                	sd	s1,8(sp)
    8000246e:	e04a                	sd	s2,0(sp)
    80002470:	1000                	addi	s0,sp,32
    80002472:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002474:	01050913          	addi	s2,a0,16
    80002478:	854a                	mv	a0,s2
    8000247a:	00001097          	auipc	ra,0x1
    8000247e:	3fc080e7          	jalr	1020(ra) # 80003876 <holdingsleep>
    80002482:	c925                	beqz	a0,800024f2 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002484:	854a                	mv	a0,s2
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	3ac080e7          	jalr	940(ra) # 80003832 <releasesleep>

  acquire(&bcache.lock);
    8000248e:	0000d517          	auipc	a0,0xd
    80002492:	38a50513          	addi	a0,a0,906 # 8000f818 <bcache>
    80002496:	00005097          	auipc	ra,0x5
    8000249a:	a8c080e7          	jalr	-1396(ra) # 80006f22 <acquire>
  b->refcnt--;
    8000249e:	40bc                	lw	a5,64(s1)
    800024a0:	37fd                	addiw	a5,a5,-1
    800024a2:	0007871b          	sext.w	a4,a5
    800024a6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024a8:	e71d                	bnez	a4,800024d6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024aa:	68b8                	ld	a4,80(s1)
    800024ac:	64bc                	ld	a5,72(s1)
    800024ae:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024b0:	68b8                	ld	a4,80(s1)
    800024b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024b4:	00015797          	auipc	a5,0x15
    800024b8:	36478793          	addi	a5,a5,868 # 80017818 <bcache+0x8000>
    800024bc:	2b87b703          	ld	a4,696(a5)
    800024c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024c2:	00015717          	auipc	a4,0x15
    800024c6:	5be70713          	addi	a4,a4,1470 # 80017a80 <bcache+0x8268>
    800024ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024cc:	2b87b703          	ld	a4,696(a5)
    800024d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024d6:	0000d517          	auipc	a0,0xd
    800024da:	34250513          	addi	a0,a0,834 # 8000f818 <bcache>
    800024de:	00005097          	auipc	ra,0x5
    800024e2:	af8080e7          	jalr	-1288(ra) # 80006fd6 <release>
}
    800024e6:	60e2                	ld	ra,24(sp)
    800024e8:	6442                	ld	s0,16(sp)
    800024ea:	64a2                	ld	s1,8(sp)
    800024ec:	6902                	ld	s2,0(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret
    panic("brelse");
    800024f2:	00007517          	auipc	a0,0x7
    800024f6:	00e50513          	addi	a0,a0,14 # 80009500 <syscalls+0x120>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	4f0080e7          	jalr	1264(ra) # 800069ea <panic>

0000000080002502 <bpin>:

void
bpin(struct buf *b) {
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	1000                	addi	s0,sp,32
    8000250c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000250e:	0000d517          	auipc	a0,0xd
    80002512:	30a50513          	addi	a0,a0,778 # 8000f818 <bcache>
    80002516:	00005097          	auipc	ra,0x5
    8000251a:	a0c080e7          	jalr	-1524(ra) # 80006f22 <acquire>
  b->refcnt++;
    8000251e:	40bc                	lw	a5,64(s1)
    80002520:	2785                	addiw	a5,a5,1
    80002522:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002524:	0000d517          	auipc	a0,0xd
    80002528:	2f450513          	addi	a0,a0,756 # 8000f818 <bcache>
    8000252c:	00005097          	auipc	ra,0x5
    80002530:	aaa080e7          	jalr	-1366(ra) # 80006fd6 <release>
}
    80002534:	60e2                	ld	ra,24(sp)
    80002536:	6442                	ld	s0,16(sp)
    80002538:	64a2                	ld	s1,8(sp)
    8000253a:	6105                	addi	sp,sp,32
    8000253c:	8082                	ret

000000008000253e <bunpin>:

void
bunpin(struct buf *b) {
    8000253e:	1101                	addi	sp,sp,-32
    80002540:	ec06                	sd	ra,24(sp)
    80002542:	e822                	sd	s0,16(sp)
    80002544:	e426                	sd	s1,8(sp)
    80002546:	1000                	addi	s0,sp,32
    80002548:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000254a:	0000d517          	auipc	a0,0xd
    8000254e:	2ce50513          	addi	a0,a0,718 # 8000f818 <bcache>
    80002552:	00005097          	auipc	ra,0x5
    80002556:	9d0080e7          	jalr	-1584(ra) # 80006f22 <acquire>
  b->refcnt--;
    8000255a:	40bc                	lw	a5,64(s1)
    8000255c:	37fd                	addiw	a5,a5,-1
    8000255e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002560:	0000d517          	auipc	a0,0xd
    80002564:	2b850513          	addi	a0,a0,696 # 8000f818 <bcache>
    80002568:	00005097          	auipc	ra,0x5
    8000256c:	a6e080e7          	jalr	-1426(ra) # 80006fd6 <release>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	64a2                	ld	s1,8(sp)
    80002576:	6105                	addi	sp,sp,32
    80002578:	8082                	ret

000000008000257a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000257a:	1101                	addi	sp,sp,-32
    8000257c:	ec06                	sd	ra,24(sp)
    8000257e:	e822                	sd	s0,16(sp)
    80002580:	e426                	sd	s1,8(sp)
    80002582:	e04a                	sd	s2,0(sp)
    80002584:	1000                	addi	s0,sp,32
    80002586:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002588:	00d5d59b          	srliw	a1,a1,0xd
    8000258c:	00016797          	auipc	a5,0x16
    80002590:	9687a783          	lw	a5,-1688(a5) # 80017ef4 <sb+0x1c>
    80002594:	9dbd                	addw	a1,a1,a5
    80002596:	00000097          	auipc	ra,0x0
    8000259a:	da0080e7          	jalr	-608(ra) # 80002336 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000259e:	0074f713          	andi	a4,s1,7
    800025a2:	4785                	li	a5,1
    800025a4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025a8:	14ce                	slli	s1,s1,0x33
    800025aa:	90d9                	srli	s1,s1,0x36
    800025ac:	00950733          	add	a4,a0,s1
    800025b0:	05874703          	lbu	a4,88(a4)
    800025b4:	00e7f6b3          	and	a3,a5,a4
    800025b8:	c69d                	beqz	a3,800025e6 <bfree+0x6c>
    800025ba:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025bc:	94aa                	add	s1,s1,a0
    800025be:	fff7c793          	not	a5,a5
    800025c2:	8f7d                	and	a4,a4,a5
    800025c4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025c8:	00001097          	auipc	ra,0x1
    800025cc:	0f6080e7          	jalr	246(ra) # 800036be <log_write>
  brelse(bp);
    800025d0:	854a                	mv	a0,s2
    800025d2:	00000097          	auipc	ra,0x0
    800025d6:	e94080e7          	jalr	-364(ra) # 80002466 <brelse>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6902                	ld	s2,0(sp)
    800025e2:	6105                	addi	sp,sp,32
    800025e4:	8082                	ret
    panic("freeing free block");
    800025e6:	00007517          	auipc	a0,0x7
    800025ea:	f2250513          	addi	a0,a0,-222 # 80009508 <syscalls+0x128>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	3fc080e7          	jalr	1020(ra) # 800069ea <panic>

00000000800025f6 <balloc>:
{
    800025f6:	711d                	addi	sp,sp,-96
    800025f8:	ec86                	sd	ra,88(sp)
    800025fa:	e8a2                	sd	s0,80(sp)
    800025fc:	e4a6                	sd	s1,72(sp)
    800025fe:	e0ca                	sd	s2,64(sp)
    80002600:	fc4e                	sd	s3,56(sp)
    80002602:	f852                	sd	s4,48(sp)
    80002604:	f456                	sd	s5,40(sp)
    80002606:	f05a                	sd	s6,32(sp)
    80002608:	ec5e                	sd	s7,24(sp)
    8000260a:	e862                	sd	s8,16(sp)
    8000260c:	e466                	sd	s9,8(sp)
    8000260e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002610:	00016797          	auipc	a5,0x16
    80002614:	8cc7a783          	lw	a5,-1844(a5) # 80017edc <sb+0x4>
    80002618:	cff5                	beqz	a5,80002714 <balloc+0x11e>
    8000261a:	8baa                	mv	s7,a0
    8000261c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000261e:	00016b17          	auipc	s6,0x16
    80002622:	8bab0b13          	addi	s6,s6,-1862 # 80017ed8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002626:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002628:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000262a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000262c:	6c89                	lui	s9,0x2
    8000262e:	a061                	j	800026b6 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002630:	97ca                	add	a5,a5,s2
    80002632:	8e55                	or	a2,a2,a3
    80002634:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002638:	854a                	mv	a0,s2
    8000263a:	00001097          	auipc	ra,0x1
    8000263e:	084080e7          	jalr	132(ra) # 800036be <log_write>
        brelse(bp);
    80002642:	854a                	mv	a0,s2
    80002644:	00000097          	auipc	ra,0x0
    80002648:	e22080e7          	jalr	-478(ra) # 80002466 <brelse>
  bp = bread(dev, bno);
    8000264c:	85a6                	mv	a1,s1
    8000264e:	855e                	mv	a0,s7
    80002650:	00000097          	auipc	ra,0x0
    80002654:	ce6080e7          	jalr	-794(ra) # 80002336 <bread>
    80002658:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000265a:	40000613          	li	a2,1024
    8000265e:	4581                	li	a1,0
    80002660:	05850513          	addi	a0,a0,88
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	b16080e7          	jalr	-1258(ra) # 8000017a <memset>
  log_write(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	050080e7          	jalr	80(ra) # 800036be <log_write>
  brelse(bp);
    80002676:	854a                	mv	a0,s2
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	dee080e7          	jalr	-530(ra) # 80002466 <brelse>
}
    80002680:	8526                	mv	a0,s1
    80002682:	60e6                	ld	ra,88(sp)
    80002684:	6446                	ld	s0,80(sp)
    80002686:	64a6                	ld	s1,72(sp)
    80002688:	6906                	ld	s2,64(sp)
    8000268a:	79e2                	ld	s3,56(sp)
    8000268c:	7a42                	ld	s4,48(sp)
    8000268e:	7aa2                	ld	s5,40(sp)
    80002690:	7b02                	ld	s6,32(sp)
    80002692:	6be2                	ld	s7,24(sp)
    80002694:	6c42                	ld	s8,16(sp)
    80002696:	6ca2                	ld	s9,8(sp)
    80002698:	6125                	addi	sp,sp,96
    8000269a:	8082                	ret
    brelse(bp);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	dc8080e7          	jalr	-568(ra) # 80002466 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a6:	015c87bb          	addw	a5,s9,s5
    800026aa:	00078a9b          	sext.w	s5,a5
    800026ae:	004b2703          	lw	a4,4(s6)
    800026b2:	06eaf163          	bgeu	s5,a4,80002714 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800026b6:	41fad79b          	sraiw	a5,s5,0x1f
    800026ba:	0137d79b          	srliw	a5,a5,0x13
    800026be:	015787bb          	addw	a5,a5,s5
    800026c2:	40d7d79b          	sraiw	a5,a5,0xd
    800026c6:	01cb2583          	lw	a1,28(s6)
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	855e                	mv	a0,s7
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	c68080e7          	jalr	-920(ra) # 80002336 <bread>
    800026d6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d8:	004b2503          	lw	a0,4(s6)
    800026dc:	000a849b          	sext.w	s1,s5
    800026e0:	8762                	mv	a4,s8
    800026e2:	faa4fde3          	bgeu	s1,a0,8000269c <balloc+0xa6>
      m = 1 << (bi % 8);
    800026e6:	00777693          	andi	a3,a4,7
    800026ea:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026ee:	41f7579b          	sraiw	a5,a4,0x1f
    800026f2:	01d7d79b          	srliw	a5,a5,0x1d
    800026f6:	9fb9                	addw	a5,a5,a4
    800026f8:	4037d79b          	sraiw	a5,a5,0x3
    800026fc:	00f90633          	add	a2,s2,a5
    80002700:	05864603          	lbu	a2,88(a2)
    80002704:	00c6f5b3          	and	a1,a3,a2
    80002708:	d585                	beqz	a1,80002630 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270a:	2705                	addiw	a4,a4,1
    8000270c:	2485                	addiw	s1,s1,1
    8000270e:	fd471ae3          	bne	a4,s4,800026e2 <balloc+0xec>
    80002712:	b769                	j	8000269c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002714:	00007517          	auipc	a0,0x7
    80002718:	e0c50513          	addi	a0,a0,-500 # 80009520 <syscalls+0x140>
    8000271c:	00004097          	auipc	ra,0x4
    80002720:	318080e7          	jalr	792(ra) # 80006a34 <printf>
  return 0;
    80002724:	4481                	li	s1,0
    80002726:	bfa9                	j	80002680 <balloc+0x8a>

0000000080002728 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002728:	7179                	addi	sp,sp,-48
    8000272a:	f406                	sd	ra,40(sp)
    8000272c:	f022                	sd	s0,32(sp)
    8000272e:	ec26                	sd	s1,24(sp)
    80002730:	e84a                	sd	s2,16(sp)
    80002732:	e44e                	sd	s3,8(sp)
    80002734:	e052                	sd	s4,0(sp)
    80002736:	1800                	addi	s0,sp,48
    80002738:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000273a:	47ad                	li	a5,11
    8000273c:	02b7e863          	bltu	a5,a1,8000276c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002740:	02059793          	slli	a5,a1,0x20
    80002744:	01e7d593          	srli	a1,a5,0x1e
    80002748:	00b504b3          	add	s1,a0,a1
    8000274c:	0504a903          	lw	s2,80(s1)
    80002750:	06091e63          	bnez	s2,800027cc <bmap+0xa4>
      addr = balloc(ip->dev);
    80002754:	4108                	lw	a0,0(a0)
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	ea0080e7          	jalr	-352(ra) # 800025f6 <balloc>
    8000275e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002762:	06090563          	beqz	s2,800027cc <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002766:	0524a823          	sw	s2,80(s1)
    8000276a:	a08d                	j	800027cc <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000276c:	ff45849b          	addiw	s1,a1,-12
    80002770:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002774:	0ff00793          	li	a5,255
    80002778:	08e7e563          	bltu	a5,a4,80002802 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000277c:	08052903          	lw	s2,128(a0)
    80002780:	00091d63          	bnez	s2,8000279a <bmap+0x72>
      addr = balloc(ip->dev);
    80002784:	4108                	lw	a0,0(a0)
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	e70080e7          	jalr	-400(ra) # 800025f6 <balloc>
    8000278e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002792:	02090d63          	beqz	s2,800027cc <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002796:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000279a:	85ca                	mv	a1,s2
    8000279c:	0009a503          	lw	a0,0(s3)
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	b96080e7          	jalr	-1130(ra) # 80002336 <bread>
    800027a8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027aa:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ae:	02049713          	slli	a4,s1,0x20
    800027b2:	01e75593          	srli	a1,a4,0x1e
    800027b6:	00b784b3          	add	s1,a5,a1
    800027ba:	0004a903          	lw	s2,0(s1)
    800027be:	02090063          	beqz	s2,800027de <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027c2:	8552                	mv	a0,s4
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	ca2080e7          	jalr	-862(ra) # 80002466 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027cc:	854a                	mv	a0,s2
    800027ce:	70a2                	ld	ra,40(sp)
    800027d0:	7402                	ld	s0,32(sp)
    800027d2:	64e2                	ld	s1,24(sp)
    800027d4:	6942                	ld	s2,16(sp)
    800027d6:	69a2                	ld	s3,8(sp)
    800027d8:	6a02                	ld	s4,0(sp)
    800027da:	6145                	addi	sp,sp,48
    800027dc:	8082                	ret
      addr = balloc(ip->dev);
    800027de:	0009a503          	lw	a0,0(s3)
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	e14080e7          	jalr	-492(ra) # 800025f6 <balloc>
    800027ea:	0005091b          	sext.w	s2,a0
      if(addr){
    800027ee:	fc090ae3          	beqz	s2,800027c2 <bmap+0x9a>
        a[bn] = addr;
    800027f2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800027f6:	8552                	mv	a0,s4
    800027f8:	00001097          	auipc	ra,0x1
    800027fc:	ec6080e7          	jalr	-314(ra) # 800036be <log_write>
    80002800:	b7c9                	j	800027c2 <bmap+0x9a>
  panic("bmap: out of range");
    80002802:	00007517          	auipc	a0,0x7
    80002806:	d3650513          	addi	a0,a0,-714 # 80009538 <syscalls+0x158>
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	1e0080e7          	jalr	480(ra) # 800069ea <panic>

0000000080002812 <iget>:
{
    80002812:	7179                	addi	sp,sp,-48
    80002814:	f406                	sd	ra,40(sp)
    80002816:	f022                	sd	s0,32(sp)
    80002818:	ec26                	sd	s1,24(sp)
    8000281a:	e84a                	sd	s2,16(sp)
    8000281c:	e44e                	sd	s3,8(sp)
    8000281e:	e052                	sd	s4,0(sp)
    80002820:	1800                	addi	s0,sp,48
    80002822:	89aa                	mv	s3,a0
    80002824:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002826:	00015517          	auipc	a0,0x15
    8000282a:	6d250513          	addi	a0,a0,1746 # 80017ef8 <itable>
    8000282e:	00004097          	auipc	ra,0x4
    80002832:	6f4080e7          	jalr	1780(ra) # 80006f22 <acquire>
  empty = 0;
    80002836:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002838:	00015497          	auipc	s1,0x15
    8000283c:	6d848493          	addi	s1,s1,1752 # 80017f10 <itable+0x18>
    80002840:	00017697          	auipc	a3,0x17
    80002844:	16068693          	addi	a3,a3,352 # 800199a0 <log>
    80002848:	a039                	j	80002856 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000284a:	02090b63          	beqz	s2,80002880 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000284e:	08848493          	addi	s1,s1,136
    80002852:	02d48a63          	beq	s1,a3,80002886 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002856:	449c                	lw	a5,8(s1)
    80002858:	fef059e3          	blez	a5,8000284a <iget+0x38>
    8000285c:	4098                	lw	a4,0(s1)
    8000285e:	ff3716e3          	bne	a4,s3,8000284a <iget+0x38>
    80002862:	40d8                	lw	a4,4(s1)
    80002864:	ff4713e3          	bne	a4,s4,8000284a <iget+0x38>
      ip->ref++;
    80002868:	2785                	addiw	a5,a5,1
    8000286a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000286c:	00015517          	auipc	a0,0x15
    80002870:	68c50513          	addi	a0,a0,1676 # 80017ef8 <itable>
    80002874:	00004097          	auipc	ra,0x4
    80002878:	762080e7          	jalr	1890(ra) # 80006fd6 <release>
      return ip;
    8000287c:	8926                	mv	s2,s1
    8000287e:	a03d                	j	800028ac <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002880:	f7f9                	bnez	a5,8000284e <iget+0x3c>
    80002882:	8926                	mv	s2,s1
    80002884:	b7e9                	j	8000284e <iget+0x3c>
  if(empty == 0)
    80002886:	02090c63          	beqz	s2,800028be <iget+0xac>
  ip->dev = dev;
    8000288a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000288e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002892:	4785                	li	a5,1
    80002894:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002898:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000289c:	00015517          	auipc	a0,0x15
    800028a0:	65c50513          	addi	a0,a0,1628 # 80017ef8 <itable>
    800028a4:	00004097          	auipc	ra,0x4
    800028a8:	732080e7          	jalr	1842(ra) # 80006fd6 <release>
}
    800028ac:	854a                	mv	a0,s2
    800028ae:	70a2                	ld	ra,40(sp)
    800028b0:	7402                	ld	s0,32(sp)
    800028b2:	64e2                	ld	s1,24(sp)
    800028b4:	6942                	ld	s2,16(sp)
    800028b6:	69a2                	ld	s3,8(sp)
    800028b8:	6a02                	ld	s4,0(sp)
    800028ba:	6145                	addi	sp,sp,48
    800028bc:	8082                	ret
    panic("iget: no inodes");
    800028be:	00007517          	auipc	a0,0x7
    800028c2:	c9250513          	addi	a0,a0,-878 # 80009550 <syscalls+0x170>
    800028c6:	00004097          	auipc	ra,0x4
    800028ca:	124080e7          	jalr	292(ra) # 800069ea <panic>

00000000800028ce <fsinit>:
fsinit(int dev) {
    800028ce:	7179                	addi	sp,sp,-48
    800028d0:	f406                	sd	ra,40(sp)
    800028d2:	f022                	sd	s0,32(sp)
    800028d4:	ec26                	sd	s1,24(sp)
    800028d6:	e84a                	sd	s2,16(sp)
    800028d8:	e44e                	sd	s3,8(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028de:	4585                	li	a1,1
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	a56080e7          	jalr	-1450(ra) # 80002336 <bread>
    800028e8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028ea:	00015997          	auipc	s3,0x15
    800028ee:	5ee98993          	addi	s3,s3,1518 # 80017ed8 <sb>
    800028f2:	02000613          	li	a2,32
    800028f6:	05850593          	addi	a1,a0,88
    800028fa:	854e                	mv	a0,s3
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	8da080e7          	jalr	-1830(ra) # 800001d6 <memmove>
  brelse(bp);
    80002904:	8526                	mv	a0,s1
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	b60080e7          	jalr	-1184(ra) # 80002466 <brelse>
  if(sb.magic != FSMAGIC)
    8000290e:	0009a703          	lw	a4,0(s3)
    80002912:	102037b7          	lui	a5,0x10203
    80002916:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000291a:	02f71263          	bne	a4,a5,8000293e <fsinit+0x70>
  initlog(dev, &sb);
    8000291e:	00015597          	auipc	a1,0x15
    80002922:	5ba58593          	addi	a1,a1,1466 # 80017ed8 <sb>
    80002926:	854a                	mv	a0,s2
    80002928:	00001097          	auipc	ra,0x1
    8000292c:	b2c080e7          	jalr	-1236(ra) # 80003454 <initlog>
}
    80002930:	70a2                	ld	ra,40(sp)
    80002932:	7402                	ld	s0,32(sp)
    80002934:	64e2                	ld	s1,24(sp)
    80002936:	6942                	ld	s2,16(sp)
    80002938:	69a2                	ld	s3,8(sp)
    8000293a:	6145                	addi	sp,sp,48
    8000293c:	8082                	ret
    panic("invalid file system");
    8000293e:	00007517          	auipc	a0,0x7
    80002942:	c2250513          	addi	a0,a0,-990 # 80009560 <syscalls+0x180>
    80002946:	00004097          	auipc	ra,0x4
    8000294a:	0a4080e7          	jalr	164(ra) # 800069ea <panic>

000000008000294e <iinit>:
{
    8000294e:	7179                	addi	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	e84a                	sd	s2,16(sp)
    80002958:	e44e                	sd	s3,8(sp)
    8000295a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000295c:	00007597          	auipc	a1,0x7
    80002960:	c1c58593          	addi	a1,a1,-996 # 80009578 <syscalls+0x198>
    80002964:	00015517          	auipc	a0,0x15
    80002968:	59450513          	addi	a0,a0,1428 # 80017ef8 <itable>
    8000296c:	00004097          	auipc	ra,0x4
    80002970:	526080e7          	jalr	1318(ra) # 80006e92 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002974:	00015497          	auipc	s1,0x15
    80002978:	5ac48493          	addi	s1,s1,1452 # 80017f20 <itable+0x28>
    8000297c:	00017997          	auipc	s3,0x17
    80002980:	03498993          	addi	s3,s3,52 # 800199b0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002984:	00007917          	auipc	s2,0x7
    80002988:	bfc90913          	addi	s2,s2,-1028 # 80009580 <syscalls+0x1a0>
    8000298c:	85ca                	mv	a1,s2
    8000298e:	8526                	mv	a0,s1
    80002990:	00001097          	auipc	ra,0x1
    80002994:	e12080e7          	jalr	-494(ra) # 800037a2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002998:	08848493          	addi	s1,s1,136
    8000299c:	ff3498e3          	bne	s1,s3,8000298c <iinit+0x3e>
}
    800029a0:	70a2                	ld	ra,40(sp)
    800029a2:	7402                	ld	s0,32(sp)
    800029a4:	64e2                	ld	s1,24(sp)
    800029a6:	6942                	ld	s2,16(sp)
    800029a8:	69a2                	ld	s3,8(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret

00000000800029ae <ialloc>:
{
    800029ae:	7139                	addi	sp,sp,-64
    800029b0:	fc06                	sd	ra,56(sp)
    800029b2:	f822                	sd	s0,48(sp)
    800029b4:	f426                	sd	s1,40(sp)
    800029b6:	f04a                	sd	s2,32(sp)
    800029b8:	ec4e                	sd	s3,24(sp)
    800029ba:	e852                	sd	s4,16(sp)
    800029bc:	e456                	sd	s5,8(sp)
    800029be:	e05a                	sd	s6,0(sp)
    800029c0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029c2:	00015717          	auipc	a4,0x15
    800029c6:	52272703          	lw	a4,1314(a4) # 80017ee4 <sb+0xc>
    800029ca:	4785                	li	a5,1
    800029cc:	04e7f863          	bgeu	a5,a4,80002a1c <ialloc+0x6e>
    800029d0:	8aaa                	mv	s5,a0
    800029d2:	8b2e                	mv	s6,a1
    800029d4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029d6:	00015a17          	auipc	s4,0x15
    800029da:	502a0a13          	addi	s4,s4,1282 # 80017ed8 <sb>
    800029de:	00495593          	srli	a1,s2,0x4
    800029e2:	018a2783          	lw	a5,24(s4)
    800029e6:	9dbd                	addw	a1,a1,a5
    800029e8:	8556                	mv	a0,s5
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	94c080e7          	jalr	-1716(ra) # 80002336 <bread>
    800029f2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029f4:	05850993          	addi	s3,a0,88
    800029f8:	00f97793          	andi	a5,s2,15
    800029fc:	079a                	slli	a5,a5,0x6
    800029fe:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a00:	00099783          	lh	a5,0(s3)
    80002a04:	cf9d                	beqz	a5,80002a42 <ialloc+0x94>
    brelse(bp);
    80002a06:	00000097          	auipc	ra,0x0
    80002a0a:	a60080e7          	jalr	-1440(ra) # 80002466 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a0e:	0905                	addi	s2,s2,1
    80002a10:	00ca2703          	lw	a4,12(s4)
    80002a14:	0009079b          	sext.w	a5,s2
    80002a18:	fce7e3e3          	bltu	a5,a4,800029de <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002a1c:	00007517          	auipc	a0,0x7
    80002a20:	b6c50513          	addi	a0,a0,-1172 # 80009588 <syscalls+0x1a8>
    80002a24:	00004097          	auipc	ra,0x4
    80002a28:	010080e7          	jalr	16(ra) # 80006a34 <printf>
  return 0;
    80002a2c:	4501                	li	a0,0
}
    80002a2e:	70e2                	ld	ra,56(sp)
    80002a30:	7442                	ld	s0,48(sp)
    80002a32:	74a2                	ld	s1,40(sp)
    80002a34:	7902                	ld	s2,32(sp)
    80002a36:	69e2                	ld	s3,24(sp)
    80002a38:	6a42                	ld	s4,16(sp)
    80002a3a:	6aa2                	ld	s5,8(sp)
    80002a3c:	6b02                	ld	s6,0(sp)
    80002a3e:	6121                	addi	sp,sp,64
    80002a40:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a42:	04000613          	li	a2,64
    80002a46:	4581                	li	a1,0
    80002a48:	854e                	mv	a0,s3
    80002a4a:	ffffd097          	auipc	ra,0xffffd
    80002a4e:	730080e7          	jalr	1840(ra) # 8000017a <memset>
      dip->type = type;
    80002a52:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a56:	8526                	mv	a0,s1
    80002a58:	00001097          	auipc	ra,0x1
    80002a5c:	c66080e7          	jalr	-922(ra) # 800036be <log_write>
      brelse(bp);
    80002a60:	8526                	mv	a0,s1
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	a04080e7          	jalr	-1532(ra) # 80002466 <brelse>
      return iget(dev, inum);
    80002a6a:	0009059b          	sext.w	a1,s2
    80002a6e:	8556                	mv	a0,s5
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	da2080e7          	jalr	-606(ra) # 80002812 <iget>
    80002a78:	bf5d                	j	80002a2e <ialloc+0x80>

0000000080002a7a <iupdate>:
{
    80002a7a:	1101                	addi	sp,sp,-32
    80002a7c:	ec06                	sd	ra,24(sp)
    80002a7e:	e822                	sd	s0,16(sp)
    80002a80:	e426                	sd	s1,8(sp)
    80002a82:	e04a                	sd	s2,0(sp)
    80002a84:	1000                	addi	s0,sp,32
    80002a86:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a88:	415c                	lw	a5,4(a0)
    80002a8a:	0047d79b          	srliw	a5,a5,0x4
    80002a8e:	00015597          	auipc	a1,0x15
    80002a92:	4625a583          	lw	a1,1122(a1) # 80017ef0 <sb+0x18>
    80002a96:	9dbd                	addw	a1,a1,a5
    80002a98:	4108                	lw	a0,0(a0)
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	89c080e7          	jalr	-1892(ra) # 80002336 <bread>
    80002aa2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002aa4:	05850793          	addi	a5,a0,88
    80002aa8:	40d8                	lw	a4,4(s1)
    80002aaa:	8b3d                	andi	a4,a4,15
    80002aac:	071a                	slli	a4,a4,0x6
    80002aae:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002ab0:	04449703          	lh	a4,68(s1)
    80002ab4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ab8:	04649703          	lh	a4,70(s1)
    80002abc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ac0:	04849703          	lh	a4,72(s1)
    80002ac4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ac8:	04a49703          	lh	a4,74(s1)
    80002acc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ad0:	44f8                	lw	a4,76(s1)
    80002ad2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ad4:	03400613          	li	a2,52
    80002ad8:	05048593          	addi	a1,s1,80
    80002adc:	00c78513          	addi	a0,a5,12
    80002ae0:	ffffd097          	auipc	ra,0xffffd
    80002ae4:	6f6080e7          	jalr	1782(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ae8:	854a                	mv	a0,s2
    80002aea:	00001097          	auipc	ra,0x1
    80002aee:	bd4080e7          	jalr	-1068(ra) # 800036be <log_write>
  brelse(bp);
    80002af2:	854a                	mv	a0,s2
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	972080e7          	jalr	-1678(ra) # 80002466 <brelse>
}
    80002afc:	60e2                	ld	ra,24(sp)
    80002afe:	6442                	ld	s0,16(sp)
    80002b00:	64a2                	ld	s1,8(sp)
    80002b02:	6902                	ld	s2,0(sp)
    80002b04:	6105                	addi	sp,sp,32
    80002b06:	8082                	ret

0000000080002b08 <idup>:
{
    80002b08:	1101                	addi	sp,sp,-32
    80002b0a:	ec06                	sd	ra,24(sp)
    80002b0c:	e822                	sd	s0,16(sp)
    80002b0e:	e426                	sd	s1,8(sp)
    80002b10:	1000                	addi	s0,sp,32
    80002b12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b14:	00015517          	auipc	a0,0x15
    80002b18:	3e450513          	addi	a0,a0,996 # 80017ef8 <itable>
    80002b1c:	00004097          	auipc	ra,0x4
    80002b20:	406080e7          	jalr	1030(ra) # 80006f22 <acquire>
  ip->ref++;
    80002b24:	449c                	lw	a5,8(s1)
    80002b26:	2785                	addiw	a5,a5,1
    80002b28:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b2a:	00015517          	auipc	a0,0x15
    80002b2e:	3ce50513          	addi	a0,a0,974 # 80017ef8 <itable>
    80002b32:	00004097          	auipc	ra,0x4
    80002b36:	4a4080e7          	jalr	1188(ra) # 80006fd6 <release>
}
    80002b3a:	8526                	mv	a0,s1
    80002b3c:	60e2                	ld	ra,24(sp)
    80002b3e:	6442                	ld	s0,16(sp)
    80002b40:	64a2                	ld	s1,8(sp)
    80002b42:	6105                	addi	sp,sp,32
    80002b44:	8082                	ret

0000000080002b46 <ilock>:
{
    80002b46:	1101                	addi	sp,sp,-32
    80002b48:	ec06                	sd	ra,24(sp)
    80002b4a:	e822                	sd	s0,16(sp)
    80002b4c:	e426                	sd	s1,8(sp)
    80002b4e:	e04a                	sd	s2,0(sp)
    80002b50:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b52:	c115                	beqz	a0,80002b76 <ilock+0x30>
    80002b54:	84aa                	mv	s1,a0
    80002b56:	451c                	lw	a5,8(a0)
    80002b58:	00f05f63          	blez	a5,80002b76 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b5c:	0541                	addi	a0,a0,16
    80002b5e:	00001097          	auipc	ra,0x1
    80002b62:	c7e080e7          	jalr	-898(ra) # 800037dc <acquiresleep>
  if(ip->valid == 0){
    80002b66:	40bc                	lw	a5,64(s1)
    80002b68:	cf99                	beqz	a5,80002b86 <ilock+0x40>
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6902                	ld	s2,0(sp)
    80002b72:	6105                	addi	sp,sp,32
    80002b74:	8082                	ret
    panic("ilock");
    80002b76:	00007517          	auipc	a0,0x7
    80002b7a:	a2a50513          	addi	a0,a0,-1494 # 800095a0 <syscalls+0x1c0>
    80002b7e:	00004097          	auipc	ra,0x4
    80002b82:	e6c080e7          	jalr	-404(ra) # 800069ea <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b86:	40dc                	lw	a5,4(s1)
    80002b88:	0047d79b          	srliw	a5,a5,0x4
    80002b8c:	00015597          	auipc	a1,0x15
    80002b90:	3645a583          	lw	a1,868(a1) # 80017ef0 <sb+0x18>
    80002b94:	9dbd                	addw	a1,a1,a5
    80002b96:	4088                	lw	a0,0(s1)
    80002b98:	fffff097          	auipc	ra,0xfffff
    80002b9c:	79e080e7          	jalr	1950(ra) # 80002336 <bread>
    80002ba0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ba2:	05850593          	addi	a1,a0,88
    80002ba6:	40dc                	lw	a5,4(s1)
    80002ba8:	8bbd                	andi	a5,a5,15
    80002baa:	079a                	slli	a5,a5,0x6
    80002bac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bae:	00059783          	lh	a5,0(a1)
    80002bb2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bb6:	00259783          	lh	a5,2(a1)
    80002bba:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bbe:	00459783          	lh	a5,4(a1)
    80002bc2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bc6:	00659783          	lh	a5,6(a1)
    80002bca:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bce:	459c                	lw	a5,8(a1)
    80002bd0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bd2:	03400613          	li	a2,52
    80002bd6:	05b1                	addi	a1,a1,12
    80002bd8:	05048513          	addi	a0,s1,80
    80002bdc:	ffffd097          	auipc	ra,0xffffd
    80002be0:	5fa080e7          	jalr	1530(ra) # 800001d6 <memmove>
    brelse(bp);
    80002be4:	854a                	mv	a0,s2
    80002be6:	00000097          	auipc	ra,0x0
    80002bea:	880080e7          	jalr	-1920(ra) # 80002466 <brelse>
    ip->valid = 1;
    80002bee:	4785                	li	a5,1
    80002bf0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bf2:	04449783          	lh	a5,68(s1)
    80002bf6:	fbb5                	bnez	a5,80002b6a <ilock+0x24>
      panic("ilock: no type");
    80002bf8:	00007517          	auipc	a0,0x7
    80002bfc:	9b050513          	addi	a0,a0,-1616 # 800095a8 <syscalls+0x1c8>
    80002c00:	00004097          	auipc	ra,0x4
    80002c04:	dea080e7          	jalr	-534(ra) # 800069ea <panic>

0000000080002c08 <iunlock>:
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	e04a                	sd	s2,0(sp)
    80002c12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c14:	c905                	beqz	a0,80002c44 <iunlock+0x3c>
    80002c16:	84aa                	mv	s1,a0
    80002c18:	01050913          	addi	s2,a0,16
    80002c1c:	854a                	mv	a0,s2
    80002c1e:	00001097          	auipc	ra,0x1
    80002c22:	c58080e7          	jalr	-936(ra) # 80003876 <holdingsleep>
    80002c26:	cd19                	beqz	a0,80002c44 <iunlock+0x3c>
    80002c28:	449c                	lw	a5,8(s1)
    80002c2a:	00f05d63          	blez	a5,80002c44 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c2e:	854a                	mv	a0,s2
    80002c30:	00001097          	auipc	ra,0x1
    80002c34:	c02080e7          	jalr	-1022(ra) # 80003832 <releasesleep>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6902                	ld	s2,0(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret
    panic("iunlock");
    80002c44:	00007517          	auipc	a0,0x7
    80002c48:	97450513          	addi	a0,a0,-1676 # 800095b8 <syscalls+0x1d8>
    80002c4c:	00004097          	auipc	ra,0x4
    80002c50:	d9e080e7          	jalr	-610(ra) # 800069ea <panic>

0000000080002c54 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c54:	7179                	addi	sp,sp,-48
    80002c56:	f406                	sd	ra,40(sp)
    80002c58:	f022                	sd	s0,32(sp)
    80002c5a:	ec26                	sd	s1,24(sp)
    80002c5c:	e84a                	sd	s2,16(sp)
    80002c5e:	e44e                	sd	s3,8(sp)
    80002c60:	e052                	sd	s4,0(sp)
    80002c62:	1800                	addi	s0,sp,48
    80002c64:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c66:	05050493          	addi	s1,a0,80
    80002c6a:	08050913          	addi	s2,a0,128
    80002c6e:	a021                	j	80002c76 <itrunc+0x22>
    80002c70:	0491                	addi	s1,s1,4
    80002c72:	01248d63          	beq	s1,s2,80002c8c <itrunc+0x38>
    if(ip->addrs[i]){
    80002c76:	408c                	lw	a1,0(s1)
    80002c78:	dde5                	beqz	a1,80002c70 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c7a:	0009a503          	lw	a0,0(s3)
    80002c7e:	00000097          	auipc	ra,0x0
    80002c82:	8fc080e7          	jalr	-1796(ra) # 8000257a <bfree>
      ip->addrs[i] = 0;
    80002c86:	0004a023          	sw	zero,0(s1)
    80002c8a:	b7dd                	j	80002c70 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c8c:	0809a583          	lw	a1,128(s3)
    80002c90:	e185                	bnez	a1,80002cb0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c92:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c96:	854e                	mv	a0,s3
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	de2080e7          	jalr	-542(ra) # 80002a7a <iupdate>
}
    80002ca0:	70a2                	ld	ra,40(sp)
    80002ca2:	7402                	ld	s0,32(sp)
    80002ca4:	64e2                	ld	s1,24(sp)
    80002ca6:	6942                	ld	s2,16(sp)
    80002ca8:	69a2                	ld	s3,8(sp)
    80002caa:	6a02                	ld	s4,0(sp)
    80002cac:	6145                	addi	sp,sp,48
    80002cae:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cb0:	0009a503          	lw	a0,0(s3)
    80002cb4:	fffff097          	auipc	ra,0xfffff
    80002cb8:	682080e7          	jalr	1666(ra) # 80002336 <bread>
    80002cbc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cbe:	05850493          	addi	s1,a0,88
    80002cc2:	45850913          	addi	s2,a0,1112
    80002cc6:	a021                	j	80002cce <itrunc+0x7a>
    80002cc8:	0491                	addi	s1,s1,4
    80002cca:	01248b63          	beq	s1,s2,80002ce0 <itrunc+0x8c>
      if(a[j])
    80002cce:	408c                	lw	a1,0(s1)
    80002cd0:	dde5                	beqz	a1,80002cc8 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cd2:	0009a503          	lw	a0,0(s3)
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	8a4080e7          	jalr	-1884(ra) # 8000257a <bfree>
    80002cde:	b7ed                	j	80002cc8 <itrunc+0x74>
    brelse(bp);
    80002ce0:	8552                	mv	a0,s4
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	784080e7          	jalr	1924(ra) # 80002466 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cea:	0809a583          	lw	a1,128(s3)
    80002cee:	0009a503          	lw	a0,0(s3)
    80002cf2:	00000097          	auipc	ra,0x0
    80002cf6:	888080e7          	jalr	-1912(ra) # 8000257a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cfa:	0809a023          	sw	zero,128(s3)
    80002cfe:	bf51                	j	80002c92 <itrunc+0x3e>

0000000080002d00 <iput>:
{
    80002d00:	1101                	addi	sp,sp,-32
    80002d02:	ec06                	sd	ra,24(sp)
    80002d04:	e822                	sd	s0,16(sp)
    80002d06:	e426                	sd	s1,8(sp)
    80002d08:	e04a                	sd	s2,0(sp)
    80002d0a:	1000                	addi	s0,sp,32
    80002d0c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d0e:	00015517          	auipc	a0,0x15
    80002d12:	1ea50513          	addi	a0,a0,490 # 80017ef8 <itable>
    80002d16:	00004097          	auipc	ra,0x4
    80002d1a:	20c080e7          	jalr	524(ra) # 80006f22 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d1e:	4498                	lw	a4,8(s1)
    80002d20:	4785                	li	a5,1
    80002d22:	02f70363          	beq	a4,a5,80002d48 <iput+0x48>
  ip->ref--;
    80002d26:	449c                	lw	a5,8(s1)
    80002d28:	37fd                	addiw	a5,a5,-1
    80002d2a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d2c:	00015517          	auipc	a0,0x15
    80002d30:	1cc50513          	addi	a0,a0,460 # 80017ef8 <itable>
    80002d34:	00004097          	auipc	ra,0x4
    80002d38:	2a2080e7          	jalr	674(ra) # 80006fd6 <release>
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6902                	ld	s2,0(sp)
    80002d44:	6105                	addi	sp,sp,32
    80002d46:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d48:	40bc                	lw	a5,64(s1)
    80002d4a:	dff1                	beqz	a5,80002d26 <iput+0x26>
    80002d4c:	04a49783          	lh	a5,74(s1)
    80002d50:	fbf9                	bnez	a5,80002d26 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d52:	01048913          	addi	s2,s1,16
    80002d56:	854a                	mv	a0,s2
    80002d58:	00001097          	auipc	ra,0x1
    80002d5c:	a84080e7          	jalr	-1404(ra) # 800037dc <acquiresleep>
    release(&itable.lock);
    80002d60:	00015517          	auipc	a0,0x15
    80002d64:	19850513          	addi	a0,a0,408 # 80017ef8 <itable>
    80002d68:	00004097          	auipc	ra,0x4
    80002d6c:	26e080e7          	jalr	622(ra) # 80006fd6 <release>
    itrunc(ip);
    80002d70:	8526                	mv	a0,s1
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	ee2080e7          	jalr	-286(ra) # 80002c54 <itrunc>
    ip->type = 0;
    80002d7a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d7e:	8526                	mv	a0,s1
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	cfa080e7          	jalr	-774(ra) # 80002a7a <iupdate>
    ip->valid = 0;
    80002d88:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	00001097          	auipc	ra,0x1
    80002d92:	aa4080e7          	jalr	-1372(ra) # 80003832 <releasesleep>
    acquire(&itable.lock);
    80002d96:	00015517          	auipc	a0,0x15
    80002d9a:	16250513          	addi	a0,a0,354 # 80017ef8 <itable>
    80002d9e:	00004097          	auipc	ra,0x4
    80002da2:	184080e7          	jalr	388(ra) # 80006f22 <acquire>
    80002da6:	b741                	j	80002d26 <iput+0x26>

0000000080002da8 <iunlockput>:
{
    80002da8:	1101                	addi	sp,sp,-32
    80002daa:	ec06                	sd	ra,24(sp)
    80002dac:	e822                	sd	s0,16(sp)
    80002dae:	e426                	sd	s1,8(sp)
    80002db0:	1000                	addi	s0,sp,32
    80002db2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	e54080e7          	jalr	-428(ra) # 80002c08 <iunlock>
  iput(ip);
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	f42080e7          	jalr	-190(ra) # 80002d00 <iput>
}
    80002dc6:	60e2                	ld	ra,24(sp)
    80002dc8:	6442                	ld	s0,16(sp)
    80002dca:	64a2                	ld	s1,8(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret

0000000080002dd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dd0:	1141                	addi	sp,sp,-16
    80002dd2:	e422                	sd	s0,8(sp)
    80002dd4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dd6:	411c                	lw	a5,0(a0)
    80002dd8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dda:	415c                	lw	a5,4(a0)
    80002ddc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dde:	04451783          	lh	a5,68(a0)
    80002de2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002de6:	04a51783          	lh	a5,74(a0)
    80002dea:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dee:	04c56783          	lwu	a5,76(a0)
    80002df2:	e99c                	sd	a5,16(a1)
}
    80002df4:	6422                	ld	s0,8(sp)
    80002df6:	0141                	addi	sp,sp,16
    80002df8:	8082                	ret

0000000080002dfa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dfa:	457c                	lw	a5,76(a0)
    80002dfc:	0ed7e963          	bltu	a5,a3,80002eee <readi+0xf4>
{
    80002e00:	7159                	addi	sp,sp,-112
    80002e02:	f486                	sd	ra,104(sp)
    80002e04:	f0a2                	sd	s0,96(sp)
    80002e06:	eca6                	sd	s1,88(sp)
    80002e08:	e8ca                	sd	s2,80(sp)
    80002e0a:	e4ce                	sd	s3,72(sp)
    80002e0c:	e0d2                	sd	s4,64(sp)
    80002e0e:	fc56                	sd	s5,56(sp)
    80002e10:	f85a                	sd	s6,48(sp)
    80002e12:	f45e                	sd	s7,40(sp)
    80002e14:	f062                	sd	s8,32(sp)
    80002e16:	ec66                	sd	s9,24(sp)
    80002e18:	e86a                	sd	s10,16(sp)
    80002e1a:	e46e                	sd	s11,8(sp)
    80002e1c:	1880                	addi	s0,sp,112
    80002e1e:	8b2a                	mv	s6,a0
    80002e20:	8bae                	mv	s7,a1
    80002e22:	8a32                	mv	s4,a2
    80002e24:	84b6                	mv	s1,a3
    80002e26:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e28:	9f35                	addw	a4,a4,a3
    return 0;
    80002e2a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e2c:	0ad76063          	bltu	a4,a3,80002ecc <readi+0xd2>
  if(off + n > ip->size)
    80002e30:	00e7f463          	bgeu	a5,a4,80002e38 <readi+0x3e>
    n = ip->size - off;
    80002e34:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e38:	0a0a8963          	beqz	s5,80002eea <readi+0xf0>
    80002e3c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e3e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e42:	5c7d                	li	s8,-1
    80002e44:	a82d                	j	80002e7e <readi+0x84>
    80002e46:	020d1d93          	slli	s11,s10,0x20
    80002e4a:	020ddd93          	srli	s11,s11,0x20
    80002e4e:	05890613          	addi	a2,s2,88
    80002e52:	86ee                	mv	a3,s11
    80002e54:	963a                	add	a2,a2,a4
    80002e56:	85d2                	mv	a1,s4
    80002e58:	855e                	mv	a0,s7
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	b00080e7          	jalr	-1280(ra) # 8000195a <either_copyout>
    80002e62:	05850d63          	beq	a0,s8,80002ebc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e66:	854a                	mv	a0,s2
    80002e68:	fffff097          	auipc	ra,0xfffff
    80002e6c:	5fe080e7          	jalr	1534(ra) # 80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e70:	013d09bb          	addw	s3,s10,s3
    80002e74:	009d04bb          	addw	s1,s10,s1
    80002e78:	9a6e                	add	s4,s4,s11
    80002e7a:	0559f763          	bgeu	s3,s5,80002ec8 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e7e:	00a4d59b          	srliw	a1,s1,0xa
    80002e82:	855a                	mv	a0,s6
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	8a4080e7          	jalr	-1884(ra) # 80002728 <bmap>
    80002e8c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e90:	cd85                	beqz	a1,80002ec8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e92:	000b2503          	lw	a0,0(s6)
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	4a0080e7          	jalr	1184(ra) # 80002336 <bread>
    80002e9e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ea0:	3ff4f713          	andi	a4,s1,1023
    80002ea4:	40ec87bb          	subw	a5,s9,a4
    80002ea8:	413a86bb          	subw	a3,s5,s3
    80002eac:	8d3e                	mv	s10,a5
    80002eae:	2781                	sext.w	a5,a5
    80002eb0:	0006861b          	sext.w	a2,a3
    80002eb4:	f8f679e3          	bgeu	a2,a5,80002e46 <readi+0x4c>
    80002eb8:	8d36                	mv	s10,a3
    80002eba:	b771                	j	80002e46 <readi+0x4c>
      brelse(bp);
    80002ebc:	854a                	mv	a0,s2
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	5a8080e7          	jalr	1448(ra) # 80002466 <brelse>
      tot = -1;
    80002ec6:	59fd                	li	s3,-1
  }
  return tot;
    80002ec8:	0009851b          	sext.w	a0,s3
}
    80002ecc:	70a6                	ld	ra,104(sp)
    80002ece:	7406                	ld	s0,96(sp)
    80002ed0:	64e6                	ld	s1,88(sp)
    80002ed2:	6946                	ld	s2,80(sp)
    80002ed4:	69a6                	ld	s3,72(sp)
    80002ed6:	6a06                	ld	s4,64(sp)
    80002ed8:	7ae2                	ld	s5,56(sp)
    80002eda:	7b42                	ld	s6,48(sp)
    80002edc:	7ba2                	ld	s7,40(sp)
    80002ede:	7c02                	ld	s8,32(sp)
    80002ee0:	6ce2                	ld	s9,24(sp)
    80002ee2:	6d42                	ld	s10,16(sp)
    80002ee4:	6da2                	ld	s11,8(sp)
    80002ee6:	6165                	addi	sp,sp,112
    80002ee8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eea:	89d6                	mv	s3,s5
    80002eec:	bff1                	j	80002ec8 <readi+0xce>
    return 0;
    80002eee:	4501                	li	a0,0
}
    80002ef0:	8082                	ret

0000000080002ef2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef2:	457c                	lw	a5,76(a0)
    80002ef4:	10d7e863          	bltu	a5,a3,80003004 <writei+0x112>
{
    80002ef8:	7159                	addi	sp,sp,-112
    80002efa:	f486                	sd	ra,104(sp)
    80002efc:	f0a2                	sd	s0,96(sp)
    80002efe:	eca6                	sd	s1,88(sp)
    80002f00:	e8ca                	sd	s2,80(sp)
    80002f02:	e4ce                	sd	s3,72(sp)
    80002f04:	e0d2                	sd	s4,64(sp)
    80002f06:	fc56                	sd	s5,56(sp)
    80002f08:	f85a                	sd	s6,48(sp)
    80002f0a:	f45e                	sd	s7,40(sp)
    80002f0c:	f062                	sd	s8,32(sp)
    80002f0e:	ec66                	sd	s9,24(sp)
    80002f10:	e86a                	sd	s10,16(sp)
    80002f12:	e46e                	sd	s11,8(sp)
    80002f14:	1880                	addi	s0,sp,112
    80002f16:	8aaa                	mv	s5,a0
    80002f18:	8bae                	mv	s7,a1
    80002f1a:	8a32                	mv	s4,a2
    80002f1c:	8936                	mv	s2,a3
    80002f1e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f20:	00e687bb          	addw	a5,a3,a4
    80002f24:	0ed7e263          	bltu	a5,a3,80003008 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f28:	00043737          	lui	a4,0x43
    80002f2c:	0ef76063          	bltu	a4,a5,8000300c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f30:	0c0b0863          	beqz	s6,80003000 <writei+0x10e>
    80002f34:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f36:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f3a:	5c7d                	li	s8,-1
    80002f3c:	a091                	j	80002f80 <writei+0x8e>
    80002f3e:	020d1d93          	slli	s11,s10,0x20
    80002f42:	020ddd93          	srli	s11,s11,0x20
    80002f46:	05848513          	addi	a0,s1,88
    80002f4a:	86ee                	mv	a3,s11
    80002f4c:	8652                	mv	a2,s4
    80002f4e:	85de                	mv	a1,s7
    80002f50:	953a                	add	a0,a0,a4
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	a5e080e7          	jalr	-1442(ra) # 800019b0 <either_copyin>
    80002f5a:	07850263          	beq	a0,s8,80002fbe <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	75e080e7          	jalr	1886(ra) # 800036be <log_write>
    brelse(bp);
    80002f68:	8526                	mv	a0,s1
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	4fc080e7          	jalr	1276(ra) # 80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f72:	013d09bb          	addw	s3,s10,s3
    80002f76:	012d093b          	addw	s2,s10,s2
    80002f7a:	9a6e                	add	s4,s4,s11
    80002f7c:	0569f663          	bgeu	s3,s6,80002fc8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f80:	00a9559b          	srliw	a1,s2,0xa
    80002f84:	8556                	mv	a0,s5
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	7a2080e7          	jalr	1954(ra) # 80002728 <bmap>
    80002f8e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f92:	c99d                	beqz	a1,80002fc8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f94:	000aa503          	lw	a0,0(s5)
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	39e080e7          	jalr	926(ra) # 80002336 <bread>
    80002fa0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa2:	3ff97713          	andi	a4,s2,1023
    80002fa6:	40ec87bb          	subw	a5,s9,a4
    80002faa:	413b06bb          	subw	a3,s6,s3
    80002fae:	8d3e                	mv	s10,a5
    80002fb0:	2781                	sext.w	a5,a5
    80002fb2:	0006861b          	sext.w	a2,a3
    80002fb6:	f8f674e3          	bgeu	a2,a5,80002f3e <writei+0x4c>
    80002fba:	8d36                	mv	s10,a3
    80002fbc:	b749                	j	80002f3e <writei+0x4c>
      brelse(bp);
    80002fbe:	8526                	mv	a0,s1
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	4a6080e7          	jalr	1190(ra) # 80002466 <brelse>
  }

  if(off > ip->size)
    80002fc8:	04caa783          	lw	a5,76(s5)
    80002fcc:	0127f463          	bgeu	a5,s2,80002fd4 <writei+0xe2>
    ip->size = off;
    80002fd0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fd4:	8556                	mv	a0,s5
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	aa4080e7          	jalr	-1372(ra) # 80002a7a <iupdate>

  return tot;
    80002fde:	0009851b          	sext.w	a0,s3
}
    80002fe2:	70a6                	ld	ra,104(sp)
    80002fe4:	7406                	ld	s0,96(sp)
    80002fe6:	64e6                	ld	s1,88(sp)
    80002fe8:	6946                	ld	s2,80(sp)
    80002fea:	69a6                	ld	s3,72(sp)
    80002fec:	6a06                	ld	s4,64(sp)
    80002fee:	7ae2                	ld	s5,56(sp)
    80002ff0:	7b42                	ld	s6,48(sp)
    80002ff2:	7ba2                	ld	s7,40(sp)
    80002ff4:	7c02                	ld	s8,32(sp)
    80002ff6:	6ce2                	ld	s9,24(sp)
    80002ff8:	6d42                	ld	s10,16(sp)
    80002ffa:	6da2                	ld	s11,8(sp)
    80002ffc:	6165                	addi	sp,sp,112
    80002ffe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003000:	89da                	mv	s3,s6
    80003002:	bfc9                	j	80002fd4 <writei+0xe2>
    return -1;
    80003004:	557d                	li	a0,-1
}
    80003006:	8082                	ret
    return -1;
    80003008:	557d                	li	a0,-1
    8000300a:	bfe1                	j	80002fe2 <writei+0xf0>
    return -1;
    8000300c:	557d                	li	a0,-1
    8000300e:	bfd1                	j	80002fe2 <writei+0xf0>

0000000080003010 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003010:	1141                	addi	sp,sp,-16
    80003012:	e406                	sd	ra,8(sp)
    80003014:	e022                	sd	s0,0(sp)
    80003016:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003018:	4639                	li	a2,14
    8000301a:	ffffd097          	auipc	ra,0xffffd
    8000301e:	230080e7          	jalr	560(ra) # 8000024a <strncmp>
}
    80003022:	60a2                	ld	ra,8(sp)
    80003024:	6402                	ld	s0,0(sp)
    80003026:	0141                	addi	sp,sp,16
    80003028:	8082                	ret

000000008000302a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000302a:	7139                	addi	sp,sp,-64
    8000302c:	fc06                	sd	ra,56(sp)
    8000302e:	f822                	sd	s0,48(sp)
    80003030:	f426                	sd	s1,40(sp)
    80003032:	f04a                	sd	s2,32(sp)
    80003034:	ec4e                	sd	s3,24(sp)
    80003036:	e852                	sd	s4,16(sp)
    80003038:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000303a:	04451703          	lh	a4,68(a0)
    8000303e:	4785                	li	a5,1
    80003040:	00f71a63          	bne	a4,a5,80003054 <dirlookup+0x2a>
    80003044:	892a                	mv	s2,a0
    80003046:	89ae                	mv	s3,a1
    80003048:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000304a:	457c                	lw	a5,76(a0)
    8000304c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000304e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003050:	e79d                	bnez	a5,8000307e <dirlookup+0x54>
    80003052:	a8a5                	j	800030ca <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003054:	00006517          	auipc	a0,0x6
    80003058:	56c50513          	addi	a0,a0,1388 # 800095c0 <syscalls+0x1e0>
    8000305c:	00004097          	auipc	ra,0x4
    80003060:	98e080e7          	jalr	-1650(ra) # 800069ea <panic>
      panic("dirlookup read");
    80003064:	00006517          	auipc	a0,0x6
    80003068:	57450513          	addi	a0,a0,1396 # 800095d8 <syscalls+0x1f8>
    8000306c:	00004097          	auipc	ra,0x4
    80003070:	97e080e7          	jalr	-1666(ra) # 800069ea <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003074:	24c1                	addiw	s1,s1,16
    80003076:	04c92783          	lw	a5,76(s2)
    8000307a:	04f4f763          	bgeu	s1,a5,800030c8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000307e:	4741                	li	a4,16
    80003080:	86a6                	mv	a3,s1
    80003082:	fc040613          	addi	a2,s0,-64
    80003086:	4581                	li	a1,0
    80003088:	854a                	mv	a0,s2
    8000308a:	00000097          	auipc	ra,0x0
    8000308e:	d70080e7          	jalr	-656(ra) # 80002dfa <readi>
    80003092:	47c1                	li	a5,16
    80003094:	fcf518e3          	bne	a0,a5,80003064 <dirlookup+0x3a>
    if(de.inum == 0)
    80003098:	fc045783          	lhu	a5,-64(s0)
    8000309c:	dfe1                	beqz	a5,80003074 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000309e:	fc240593          	addi	a1,s0,-62
    800030a2:	854e                	mv	a0,s3
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	f6c080e7          	jalr	-148(ra) # 80003010 <namecmp>
    800030ac:	f561                	bnez	a0,80003074 <dirlookup+0x4a>
      if(poff)
    800030ae:	000a0463          	beqz	s4,800030b6 <dirlookup+0x8c>
        *poff = off;
    800030b2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030b6:	fc045583          	lhu	a1,-64(s0)
    800030ba:	00092503          	lw	a0,0(s2)
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	754080e7          	jalr	1876(ra) # 80002812 <iget>
    800030c6:	a011                	j	800030ca <dirlookup+0xa0>
  return 0;
    800030c8:	4501                	li	a0,0
}
    800030ca:	70e2                	ld	ra,56(sp)
    800030cc:	7442                	ld	s0,48(sp)
    800030ce:	74a2                	ld	s1,40(sp)
    800030d0:	7902                	ld	s2,32(sp)
    800030d2:	69e2                	ld	s3,24(sp)
    800030d4:	6a42                	ld	s4,16(sp)
    800030d6:	6121                	addi	sp,sp,64
    800030d8:	8082                	ret

00000000800030da <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030da:	711d                	addi	sp,sp,-96
    800030dc:	ec86                	sd	ra,88(sp)
    800030de:	e8a2                	sd	s0,80(sp)
    800030e0:	e4a6                	sd	s1,72(sp)
    800030e2:	e0ca                	sd	s2,64(sp)
    800030e4:	fc4e                	sd	s3,56(sp)
    800030e6:	f852                	sd	s4,48(sp)
    800030e8:	f456                	sd	s5,40(sp)
    800030ea:	f05a                	sd	s6,32(sp)
    800030ec:	ec5e                	sd	s7,24(sp)
    800030ee:	e862                	sd	s8,16(sp)
    800030f0:	e466                	sd	s9,8(sp)
    800030f2:	1080                	addi	s0,sp,96
    800030f4:	84aa                	mv	s1,a0
    800030f6:	8b2e                	mv	s6,a1
    800030f8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030fa:	00054703          	lbu	a4,0(a0)
    800030fe:	02f00793          	li	a5,47
    80003102:	02f70263          	beq	a4,a5,80003126 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003106:	ffffe097          	auipc	ra,0xffffe
    8000310a:	da4080e7          	jalr	-604(ra) # 80000eaa <myproc>
    8000310e:	15053503          	ld	a0,336(a0)
    80003112:	00000097          	auipc	ra,0x0
    80003116:	9f6080e7          	jalr	-1546(ra) # 80002b08 <idup>
    8000311a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000311c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003120:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003122:	4b85                	li	s7,1
    80003124:	a875                	j	800031e0 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003126:	4585                	li	a1,1
    80003128:	4505                	li	a0,1
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	6e8080e7          	jalr	1768(ra) # 80002812 <iget>
    80003132:	8a2a                	mv	s4,a0
    80003134:	b7e5                	j	8000311c <namex+0x42>
      iunlockput(ip);
    80003136:	8552                	mv	a0,s4
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	c70080e7          	jalr	-912(ra) # 80002da8 <iunlockput>
      return 0;
    80003140:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003142:	8552                	mv	a0,s4
    80003144:	60e6                	ld	ra,88(sp)
    80003146:	6446                	ld	s0,80(sp)
    80003148:	64a6                	ld	s1,72(sp)
    8000314a:	6906                	ld	s2,64(sp)
    8000314c:	79e2                	ld	s3,56(sp)
    8000314e:	7a42                	ld	s4,48(sp)
    80003150:	7aa2                	ld	s5,40(sp)
    80003152:	7b02                	ld	s6,32(sp)
    80003154:	6be2                	ld	s7,24(sp)
    80003156:	6c42                	ld	s8,16(sp)
    80003158:	6ca2                	ld	s9,8(sp)
    8000315a:	6125                	addi	sp,sp,96
    8000315c:	8082                	ret
      iunlock(ip);
    8000315e:	8552                	mv	a0,s4
    80003160:	00000097          	auipc	ra,0x0
    80003164:	aa8080e7          	jalr	-1368(ra) # 80002c08 <iunlock>
      return ip;
    80003168:	bfe9                	j	80003142 <namex+0x68>
      iunlockput(ip);
    8000316a:	8552                	mv	a0,s4
    8000316c:	00000097          	auipc	ra,0x0
    80003170:	c3c080e7          	jalr	-964(ra) # 80002da8 <iunlockput>
      return 0;
    80003174:	8a4e                	mv	s4,s3
    80003176:	b7f1                	j	80003142 <namex+0x68>
  len = path - s;
    80003178:	40998633          	sub	a2,s3,s1
    8000317c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003180:	099c5863          	bge	s8,s9,80003210 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003184:	4639                	li	a2,14
    80003186:	85a6                	mv	a1,s1
    80003188:	8556                	mv	a0,s5
    8000318a:	ffffd097          	auipc	ra,0xffffd
    8000318e:	04c080e7          	jalr	76(ra) # 800001d6 <memmove>
    80003192:	84ce                	mv	s1,s3
  while(*path == '/')
    80003194:	0004c783          	lbu	a5,0(s1)
    80003198:	01279763          	bne	a5,s2,800031a6 <namex+0xcc>
    path++;
    8000319c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000319e:	0004c783          	lbu	a5,0(s1)
    800031a2:	ff278de3          	beq	a5,s2,8000319c <namex+0xc2>
    ilock(ip);
    800031a6:	8552                	mv	a0,s4
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	99e080e7          	jalr	-1634(ra) # 80002b46 <ilock>
    if(ip->type != T_DIR){
    800031b0:	044a1783          	lh	a5,68(s4)
    800031b4:	f97791e3          	bne	a5,s7,80003136 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031b8:	000b0563          	beqz	s6,800031c2 <namex+0xe8>
    800031bc:	0004c783          	lbu	a5,0(s1)
    800031c0:	dfd9                	beqz	a5,8000315e <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031c2:	4601                	li	a2,0
    800031c4:	85d6                	mv	a1,s5
    800031c6:	8552                	mv	a0,s4
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	e62080e7          	jalr	-414(ra) # 8000302a <dirlookup>
    800031d0:	89aa                	mv	s3,a0
    800031d2:	dd41                	beqz	a0,8000316a <namex+0x90>
    iunlockput(ip);
    800031d4:	8552                	mv	a0,s4
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	bd2080e7          	jalr	-1070(ra) # 80002da8 <iunlockput>
    ip = next;
    800031de:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031e0:	0004c783          	lbu	a5,0(s1)
    800031e4:	01279763          	bne	a5,s2,800031f2 <namex+0x118>
    path++;
    800031e8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031ea:	0004c783          	lbu	a5,0(s1)
    800031ee:	ff278de3          	beq	a5,s2,800031e8 <namex+0x10e>
  if(*path == 0)
    800031f2:	cb9d                	beqz	a5,80003228 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800031f4:	0004c783          	lbu	a5,0(s1)
    800031f8:	89a6                	mv	s3,s1
  len = path - s;
    800031fa:	4c81                	li	s9,0
    800031fc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800031fe:	01278963          	beq	a5,s2,80003210 <namex+0x136>
    80003202:	dbbd                	beqz	a5,80003178 <namex+0x9e>
    path++;
    80003204:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003206:	0009c783          	lbu	a5,0(s3)
    8000320a:	ff279ce3          	bne	a5,s2,80003202 <namex+0x128>
    8000320e:	b7ad                	j	80003178 <namex+0x9e>
    memmove(name, s, len);
    80003210:	2601                	sext.w	a2,a2
    80003212:	85a6                	mv	a1,s1
    80003214:	8556                	mv	a0,s5
    80003216:	ffffd097          	auipc	ra,0xffffd
    8000321a:	fc0080e7          	jalr	-64(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000321e:	9cd6                	add	s9,s9,s5
    80003220:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003224:	84ce                	mv	s1,s3
    80003226:	b7bd                	j	80003194 <namex+0xba>
  if(nameiparent){
    80003228:	f00b0de3          	beqz	s6,80003142 <namex+0x68>
    iput(ip);
    8000322c:	8552                	mv	a0,s4
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	ad2080e7          	jalr	-1326(ra) # 80002d00 <iput>
    return 0;
    80003236:	4a01                	li	s4,0
    80003238:	b729                	j	80003142 <namex+0x68>

000000008000323a <dirlink>:
{
    8000323a:	7139                	addi	sp,sp,-64
    8000323c:	fc06                	sd	ra,56(sp)
    8000323e:	f822                	sd	s0,48(sp)
    80003240:	f426                	sd	s1,40(sp)
    80003242:	f04a                	sd	s2,32(sp)
    80003244:	ec4e                	sd	s3,24(sp)
    80003246:	e852                	sd	s4,16(sp)
    80003248:	0080                	addi	s0,sp,64
    8000324a:	892a                	mv	s2,a0
    8000324c:	8a2e                	mv	s4,a1
    8000324e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003250:	4601                	li	a2,0
    80003252:	00000097          	auipc	ra,0x0
    80003256:	dd8080e7          	jalr	-552(ra) # 8000302a <dirlookup>
    8000325a:	e93d                	bnez	a0,800032d0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325c:	04c92483          	lw	s1,76(s2)
    80003260:	c49d                	beqz	s1,8000328e <dirlink+0x54>
    80003262:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003264:	4741                	li	a4,16
    80003266:	86a6                	mv	a3,s1
    80003268:	fc040613          	addi	a2,s0,-64
    8000326c:	4581                	li	a1,0
    8000326e:	854a                	mv	a0,s2
    80003270:	00000097          	auipc	ra,0x0
    80003274:	b8a080e7          	jalr	-1142(ra) # 80002dfa <readi>
    80003278:	47c1                	li	a5,16
    8000327a:	06f51163          	bne	a0,a5,800032dc <dirlink+0xa2>
    if(de.inum == 0)
    8000327e:	fc045783          	lhu	a5,-64(s0)
    80003282:	c791                	beqz	a5,8000328e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	24c1                	addiw	s1,s1,16
    80003286:	04c92783          	lw	a5,76(s2)
    8000328a:	fcf4ede3          	bltu	s1,a5,80003264 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000328e:	4639                	li	a2,14
    80003290:	85d2                	mv	a1,s4
    80003292:	fc240513          	addi	a0,s0,-62
    80003296:	ffffd097          	auipc	ra,0xffffd
    8000329a:	ff0080e7          	jalr	-16(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000329e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a2:	4741                	li	a4,16
    800032a4:	86a6                	mv	a3,s1
    800032a6:	fc040613          	addi	a2,s0,-64
    800032aa:	4581                	li	a1,0
    800032ac:	854a                	mv	a0,s2
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	c44080e7          	jalr	-956(ra) # 80002ef2 <writei>
    800032b6:	1541                	addi	a0,a0,-16
    800032b8:	00a03533          	snez	a0,a0
    800032bc:	40a00533          	neg	a0,a0
}
    800032c0:	70e2                	ld	ra,56(sp)
    800032c2:	7442                	ld	s0,48(sp)
    800032c4:	74a2                	ld	s1,40(sp)
    800032c6:	7902                	ld	s2,32(sp)
    800032c8:	69e2                	ld	s3,24(sp)
    800032ca:	6a42                	ld	s4,16(sp)
    800032cc:	6121                	addi	sp,sp,64
    800032ce:	8082                	ret
    iput(ip);
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	a30080e7          	jalr	-1488(ra) # 80002d00 <iput>
    return -1;
    800032d8:	557d                	li	a0,-1
    800032da:	b7dd                	j	800032c0 <dirlink+0x86>
      panic("dirlink read");
    800032dc:	00006517          	auipc	a0,0x6
    800032e0:	30c50513          	addi	a0,a0,780 # 800095e8 <syscalls+0x208>
    800032e4:	00003097          	auipc	ra,0x3
    800032e8:	706080e7          	jalr	1798(ra) # 800069ea <panic>

00000000800032ec <namei>:

struct inode*
namei(char *path)
{
    800032ec:	1101                	addi	sp,sp,-32
    800032ee:	ec06                	sd	ra,24(sp)
    800032f0:	e822                	sd	s0,16(sp)
    800032f2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032f4:	fe040613          	addi	a2,s0,-32
    800032f8:	4581                	li	a1,0
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	de0080e7          	jalr	-544(ra) # 800030da <namex>
}
    80003302:	60e2                	ld	ra,24(sp)
    80003304:	6442                	ld	s0,16(sp)
    80003306:	6105                	addi	sp,sp,32
    80003308:	8082                	ret

000000008000330a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000330a:	1141                	addi	sp,sp,-16
    8000330c:	e406                	sd	ra,8(sp)
    8000330e:	e022                	sd	s0,0(sp)
    80003310:	0800                	addi	s0,sp,16
    80003312:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003314:	4585                	li	a1,1
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	dc4080e7          	jalr	-572(ra) # 800030da <namex>
}
    8000331e:	60a2                	ld	ra,8(sp)
    80003320:	6402                	ld	s0,0(sp)
    80003322:	0141                	addi	sp,sp,16
    80003324:	8082                	ret

0000000080003326 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003326:	1101                	addi	sp,sp,-32
    80003328:	ec06                	sd	ra,24(sp)
    8000332a:	e822                	sd	s0,16(sp)
    8000332c:	e426                	sd	s1,8(sp)
    8000332e:	e04a                	sd	s2,0(sp)
    80003330:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003332:	00016917          	auipc	s2,0x16
    80003336:	66e90913          	addi	s2,s2,1646 # 800199a0 <log>
    8000333a:	01892583          	lw	a1,24(s2)
    8000333e:	02892503          	lw	a0,40(s2)
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	ff4080e7          	jalr	-12(ra) # 80002336 <bread>
    8000334a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000334c:	02c92603          	lw	a2,44(s2)
    80003350:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003352:	00c05f63          	blez	a2,80003370 <write_head+0x4a>
    80003356:	00016717          	auipc	a4,0x16
    8000335a:	67a70713          	addi	a4,a4,1658 # 800199d0 <log+0x30>
    8000335e:	87aa                	mv	a5,a0
    80003360:	060a                	slli	a2,a2,0x2
    80003362:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003364:	4314                	lw	a3,0(a4)
    80003366:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003368:	0711                	addi	a4,a4,4
    8000336a:	0791                	addi	a5,a5,4
    8000336c:	fec79ce3          	bne	a5,a2,80003364 <write_head+0x3e>
  }
  bwrite(buf);
    80003370:	8526                	mv	a0,s1
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	0b6080e7          	jalr	182(ra) # 80002428 <bwrite>
  brelse(buf);
    8000337a:	8526                	mv	a0,s1
    8000337c:	fffff097          	auipc	ra,0xfffff
    80003380:	0ea080e7          	jalr	234(ra) # 80002466 <brelse>
}
    80003384:	60e2                	ld	ra,24(sp)
    80003386:	6442                	ld	s0,16(sp)
    80003388:	64a2                	ld	s1,8(sp)
    8000338a:	6902                	ld	s2,0(sp)
    8000338c:	6105                	addi	sp,sp,32
    8000338e:	8082                	ret

0000000080003390 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003390:	00016797          	auipc	a5,0x16
    80003394:	63c7a783          	lw	a5,1596(a5) # 800199cc <log+0x2c>
    80003398:	0af05d63          	blez	a5,80003452 <install_trans+0xc2>
{
    8000339c:	7139                	addi	sp,sp,-64
    8000339e:	fc06                	sd	ra,56(sp)
    800033a0:	f822                	sd	s0,48(sp)
    800033a2:	f426                	sd	s1,40(sp)
    800033a4:	f04a                	sd	s2,32(sp)
    800033a6:	ec4e                	sd	s3,24(sp)
    800033a8:	e852                	sd	s4,16(sp)
    800033aa:	e456                	sd	s5,8(sp)
    800033ac:	e05a                	sd	s6,0(sp)
    800033ae:	0080                	addi	s0,sp,64
    800033b0:	8b2a                	mv	s6,a0
    800033b2:	00016a97          	auipc	s5,0x16
    800033b6:	61ea8a93          	addi	s5,s5,1566 # 800199d0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ba:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033bc:	00016997          	auipc	s3,0x16
    800033c0:	5e498993          	addi	s3,s3,1508 # 800199a0 <log>
    800033c4:	a00d                	j	800033e6 <install_trans+0x56>
    brelse(lbuf);
    800033c6:	854a                	mv	a0,s2
    800033c8:	fffff097          	auipc	ra,0xfffff
    800033cc:	09e080e7          	jalr	158(ra) # 80002466 <brelse>
    brelse(dbuf);
    800033d0:	8526                	mv	a0,s1
    800033d2:	fffff097          	auipc	ra,0xfffff
    800033d6:	094080e7          	jalr	148(ra) # 80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033da:	2a05                	addiw	s4,s4,1
    800033dc:	0a91                	addi	s5,s5,4
    800033de:	02c9a783          	lw	a5,44(s3)
    800033e2:	04fa5e63          	bge	s4,a5,8000343e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033e6:	0189a583          	lw	a1,24(s3)
    800033ea:	014585bb          	addw	a1,a1,s4
    800033ee:	2585                	addiw	a1,a1,1
    800033f0:	0289a503          	lw	a0,40(s3)
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	f42080e7          	jalr	-190(ra) # 80002336 <bread>
    800033fc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033fe:	000aa583          	lw	a1,0(s5)
    80003402:	0289a503          	lw	a0,40(s3)
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	f30080e7          	jalr	-208(ra) # 80002336 <bread>
    8000340e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003410:	40000613          	li	a2,1024
    80003414:	05890593          	addi	a1,s2,88
    80003418:	05850513          	addi	a0,a0,88
    8000341c:	ffffd097          	auipc	ra,0xffffd
    80003420:	dba080e7          	jalr	-582(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003424:	8526                	mv	a0,s1
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	002080e7          	jalr	2(ra) # 80002428 <bwrite>
    if(recovering == 0)
    8000342e:	f80b1ce3          	bnez	s6,800033c6 <install_trans+0x36>
      bunpin(dbuf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	10a080e7          	jalr	266(ra) # 8000253e <bunpin>
    8000343c:	b769                	j	800033c6 <install_trans+0x36>
}
    8000343e:	70e2                	ld	ra,56(sp)
    80003440:	7442                	ld	s0,48(sp)
    80003442:	74a2                	ld	s1,40(sp)
    80003444:	7902                	ld	s2,32(sp)
    80003446:	69e2                	ld	s3,24(sp)
    80003448:	6a42                	ld	s4,16(sp)
    8000344a:	6aa2                	ld	s5,8(sp)
    8000344c:	6b02                	ld	s6,0(sp)
    8000344e:	6121                	addi	sp,sp,64
    80003450:	8082                	ret
    80003452:	8082                	ret

0000000080003454 <initlog>:
{
    80003454:	7179                	addi	sp,sp,-48
    80003456:	f406                	sd	ra,40(sp)
    80003458:	f022                	sd	s0,32(sp)
    8000345a:	ec26                	sd	s1,24(sp)
    8000345c:	e84a                	sd	s2,16(sp)
    8000345e:	e44e                	sd	s3,8(sp)
    80003460:	1800                	addi	s0,sp,48
    80003462:	892a                	mv	s2,a0
    80003464:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003466:	00016497          	auipc	s1,0x16
    8000346a:	53a48493          	addi	s1,s1,1338 # 800199a0 <log>
    8000346e:	00006597          	auipc	a1,0x6
    80003472:	18a58593          	addi	a1,a1,394 # 800095f8 <syscalls+0x218>
    80003476:	8526                	mv	a0,s1
    80003478:	00004097          	auipc	ra,0x4
    8000347c:	a1a080e7          	jalr	-1510(ra) # 80006e92 <initlock>
  log.start = sb->logstart;
    80003480:	0149a583          	lw	a1,20(s3)
    80003484:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003486:	0109a783          	lw	a5,16(s3)
    8000348a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000348c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003490:	854a                	mv	a0,s2
    80003492:	fffff097          	auipc	ra,0xfffff
    80003496:	ea4080e7          	jalr	-348(ra) # 80002336 <bread>
  log.lh.n = lh->n;
    8000349a:	4d30                	lw	a2,88(a0)
    8000349c:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000349e:	00c05f63          	blez	a2,800034bc <initlog+0x68>
    800034a2:	87aa                	mv	a5,a0
    800034a4:	00016717          	auipc	a4,0x16
    800034a8:	52c70713          	addi	a4,a4,1324 # 800199d0 <log+0x30>
    800034ac:	060a                	slli	a2,a2,0x2
    800034ae:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034b0:	4ff4                	lw	a3,92(a5)
    800034b2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034b4:	0791                	addi	a5,a5,4
    800034b6:	0711                	addi	a4,a4,4
    800034b8:	fec79ce3          	bne	a5,a2,800034b0 <initlog+0x5c>
  brelse(buf);
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	faa080e7          	jalr	-86(ra) # 80002466 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034c4:	4505                	li	a0,1
    800034c6:	00000097          	auipc	ra,0x0
    800034ca:	eca080e7          	jalr	-310(ra) # 80003390 <install_trans>
  log.lh.n = 0;
    800034ce:	00016797          	auipc	a5,0x16
    800034d2:	4e07af23          	sw	zero,1278(a5) # 800199cc <log+0x2c>
  write_head(); // clear the log
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	e50080e7          	jalr	-432(ra) # 80003326 <write_head>
}
    800034de:	70a2                	ld	ra,40(sp)
    800034e0:	7402                	ld	s0,32(sp)
    800034e2:	64e2                	ld	s1,24(sp)
    800034e4:	6942                	ld	s2,16(sp)
    800034e6:	69a2                	ld	s3,8(sp)
    800034e8:	6145                	addi	sp,sp,48
    800034ea:	8082                	ret

00000000800034ec <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034ec:	1101                	addi	sp,sp,-32
    800034ee:	ec06                	sd	ra,24(sp)
    800034f0:	e822                	sd	s0,16(sp)
    800034f2:	e426                	sd	s1,8(sp)
    800034f4:	e04a                	sd	s2,0(sp)
    800034f6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034f8:	00016517          	auipc	a0,0x16
    800034fc:	4a850513          	addi	a0,a0,1192 # 800199a0 <log>
    80003500:	00004097          	auipc	ra,0x4
    80003504:	a22080e7          	jalr	-1502(ra) # 80006f22 <acquire>
  while(1){
    if(log.committing){
    80003508:	00016497          	auipc	s1,0x16
    8000350c:	49848493          	addi	s1,s1,1176 # 800199a0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003510:	4979                	li	s2,30
    80003512:	a039                	j	80003520 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003514:	85a6                	mv	a1,s1
    80003516:	8526                	mv	a0,s1
    80003518:	ffffe097          	auipc	ra,0xffffe
    8000351c:	03a080e7          	jalr	58(ra) # 80001552 <sleep>
    if(log.committing){
    80003520:	50dc                	lw	a5,36(s1)
    80003522:	fbed                	bnez	a5,80003514 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003524:	5098                	lw	a4,32(s1)
    80003526:	2705                	addiw	a4,a4,1
    80003528:	0027179b          	slliw	a5,a4,0x2
    8000352c:	9fb9                	addw	a5,a5,a4
    8000352e:	0017979b          	slliw	a5,a5,0x1
    80003532:	54d4                	lw	a3,44(s1)
    80003534:	9fb5                	addw	a5,a5,a3
    80003536:	00f95963          	bge	s2,a5,80003548 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000353a:	85a6                	mv	a1,s1
    8000353c:	8526                	mv	a0,s1
    8000353e:	ffffe097          	auipc	ra,0xffffe
    80003542:	014080e7          	jalr	20(ra) # 80001552 <sleep>
    80003546:	bfe9                	j	80003520 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003548:	00016517          	auipc	a0,0x16
    8000354c:	45850513          	addi	a0,a0,1112 # 800199a0 <log>
    80003550:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003552:	00004097          	auipc	ra,0x4
    80003556:	a84080e7          	jalr	-1404(ra) # 80006fd6 <release>
      break;
    }
  }
}
    8000355a:	60e2                	ld	ra,24(sp)
    8000355c:	6442                	ld	s0,16(sp)
    8000355e:	64a2                	ld	s1,8(sp)
    80003560:	6902                	ld	s2,0(sp)
    80003562:	6105                	addi	sp,sp,32
    80003564:	8082                	ret

0000000080003566 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003566:	7139                	addi	sp,sp,-64
    80003568:	fc06                	sd	ra,56(sp)
    8000356a:	f822                	sd	s0,48(sp)
    8000356c:	f426                	sd	s1,40(sp)
    8000356e:	f04a                	sd	s2,32(sp)
    80003570:	ec4e                	sd	s3,24(sp)
    80003572:	e852                	sd	s4,16(sp)
    80003574:	e456                	sd	s5,8(sp)
    80003576:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003578:	00016497          	auipc	s1,0x16
    8000357c:	42848493          	addi	s1,s1,1064 # 800199a0 <log>
    80003580:	8526                	mv	a0,s1
    80003582:	00004097          	auipc	ra,0x4
    80003586:	9a0080e7          	jalr	-1632(ra) # 80006f22 <acquire>
  log.outstanding -= 1;
    8000358a:	509c                	lw	a5,32(s1)
    8000358c:	37fd                	addiw	a5,a5,-1
    8000358e:	0007891b          	sext.w	s2,a5
    80003592:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003594:	50dc                	lw	a5,36(s1)
    80003596:	e7b9                	bnez	a5,800035e4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003598:	04091e63          	bnez	s2,800035f4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000359c:	00016497          	auipc	s1,0x16
    800035a0:	40448493          	addi	s1,s1,1028 # 800199a0 <log>
    800035a4:	4785                	li	a5,1
    800035a6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035a8:	8526                	mv	a0,s1
    800035aa:	00004097          	auipc	ra,0x4
    800035ae:	a2c080e7          	jalr	-1492(ra) # 80006fd6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035b2:	54dc                	lw	a5,44(s1)
    800035b4:	06f04763          	bgtz	a5,80003622 <end_op+0xbc>
    acquire(&log.lock);
    800035b8:	00016497          	auipc	s1,0x16
    800035bc:	3e848493          	addi	s1,s1,1000 # 800199a0 <log>
    800035c0:	8526                	mv	a0,s1
    800035c2:	00004097          	auipc	ra,0x4
    800035c6:	960080e7          	jalr	-1696(ra) # 80006f22 <acquire>
    log.committing = 0;
    800035ca:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035ce:	8526                	mv	a0,s1
    800035d0:	ffffe097          	auipc	ra,0xffffe
    800035d4:	fe6080e7          	jalr	-26(ra) # 800015b6 <wakeup>
    release(&log.lock);
    800035d8:	8526                	mv	a0,s1
    800035da:	00004097          	auipc	ra,0x4
    800035de:	9fc080e7          	jalr	-1540(ra) # 80006fd6 <release>
}
    800035e2:	a03d                	j	80003610 <end_op+0xaa>
    panic("log.committing");
    800035e4:	00006517          	auipc	a0,0x6
    800035e8:	01c50513          	addi	a0,a0,28 # 80009600 <syscalls+0x220>
    800035ec:	00003097          	auipc	ra,0x3
    800035f0:	3fe080e7          	jalr	1022(ra) # 800069ea <panic>
    wakeup(&log);
    800035f4:	00016497          	auipc	s1,0x16
    800035f8:	3ac48493          	addi	s1,s1,940 # 800199a0 <log>
    800035fc:	8526                	mv	a0,s1
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	fb8080e7          	jalr	-72(ra) # 800015b6 <wakeup>
  release(&log.lock);
    80003606:	8526                	mv	a0,s1
    80003608:	00004097          	auipc	ra,0x4
    8000360c:	9ce080e7          	jalr	-1586(ra) # 80006fd6 <release>
}
    80003610:	70e2                	ld	ra,56(sp)
    80003612:	7442                	ld	s0,48(sp)
    80003614:	74a2                	ld	s1,40(sp)
    80003616:	7902                	ld	s2,32(sp)
    80003618:	69e2                	ld	s3,24(sp)
    8000361a:	6a42                	ld	s4,16(sp)
    8000361c:	6aa2                	ld	s5,8(sp)
    8000361e:	6121                	addi	sp,sp,64
    80003620:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003622:	00016a97          	auipc	s5,0x16
    80003626:	3aea8a93          	addi	s5,s5,942 # 800199d0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000362a:	00016a17          	auipc	s4,0x16
    8000362e:	376a0a13          	addi	s4,s4,886 # 800199a0 <log>
    80003632:	018a2583          	lw	a1,24(s4)
    80003636:	012585bb          	addw	a1,a1,s2
    8000363a:	2585                	addiw	a1,a1,1
    8000363c:	028a2503          	lw	a0,40(s4)
    80003640:	fffff097          	auipc	ra,0xfffff
    80003644:	cf6080e7          	jalr	-778(ra) # 80002336 <bread>
    80003648:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000364a:	000aa583          	lw	a1,0(s5)
    8000364e:	028a2503          	lw	a0,40(s4)
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	ce4080e7          	jalr	-796(ra) # 80002336 <bread>
    8000365a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000365c:	40000613          	li	a2,1024
    80003660:	05850593          	addi	a1,a0,88
    80003664:	05848513          	addi	a0,s1,88
    80003668:	ffffd097          	auipc	ra,0xffffd
    8000366c:	b6e080e7          	jalr	-1170(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003670:	8526                	mv	a0,s1
    80003672:	fffff097          	auipc	ra,0xfffff
    80003676:	db6080e7          	jalr	-586(ra) # 80002428 <bwrite>
    brelse(from);
    8000367a:	854e                	mv	a0,s3
    8000367c:	fffff097          	auipc	ra,0xfffff
    80003680:	dea080e7          	jalr	-534(ra) # 80002466 <brelse>
    brelse(to);
    80003684:	8526                	mv	a0,s1
    80003686:	fffff097          	auipc	ra,0xfffff
    8000368a:	de0080e7          	jalr	-544(ra) # 80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000368e:	2905                	addiw	s2,s2,1
    80003690:	0a91                	addi	s5,s5,4
    80003692:	02ca2783          	lw	a5,44(s4)
    80003696:	f8f94ee3          	blt	s2,a5,80003632 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	c8c080e7          	jalr	-884(ra) # 80003326 <write_head>
    install_trans(0); // Now install writes to home locations
    800036a2:	4501                	li	a0,0
    800036a4:	00000097          	auipc	ra,0x0
    800036a8:	cec080e7          	jalr	-788(ra) # 80003390 <install_trans>
    log.lh.n = 0;
    800036ac:	00016797          	auipc	a5,0x16
    800036b0:	3207a023          	sw	zero,800(a5) # 800199cc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036b4:	00000097          	auipc	ra,0x0
    800036b8:	c72080e7          	jalr	-910(ra) # 80003326 <write_head>
    800036bc:	bdf5                	j	800035b8 <end_op+0x52>

00000000800036be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036be:	1101                	addi	sp,sp,-32
    800036c0:	ec06                	sd	ra,24(sp)
    800036c2:	e822                	sd	s0,16(sp)
    800036c4:	e426                	sd	s1,8(sp)
    800036c6:	e04a                	sd	s2,0(sp)
    800036c8:	1000                	addi	s0,sp,32
    800036ca:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036cc:	00016917          	auipc	s2,0x16
    800036d0:	2d490913          	addi	s2,s2,724 # 800199a0 <log>
    800036d4:	854a                	mv	a0,s2
    800036d6:	00004097          	auipc	ra,0x4
    800036da:	84c080e7          	jalr	-1972(ra) # 80006f22 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036de:	02c92603          	lw	a2,44(s2)
    800036e2:	47f5                	li	a5,29
    800036e4:	06c7c563          	blt	a5,a2,8000374e <log_write+0x90>
    800036e8:	00016797          	auipc	a5,0x16
    800036ec:	2d47a783          	lw	a5,724(a5) # 800199bc <log+0x1c>
    800036f0:	37fd                	addiw	a5,a5,-1
    800036f2:	04f65e63          	bge	a2,a5,8000374e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036f6:	00016797          	auipc	a5,0x16
    800036fa:	2ca7a783          	lw	a5,714(a5) # 800199c0 <log+0x20>
    800036fe:	06f05063          	blez	a5,8000375e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003702:	4781                	li	a5,0
    80003704:	06c05563          	blez	a2,8000376e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003708:	44cc                	lw	a1,12(s1)
    8000370a:	00016717          	auipc	a4,0x16
    8000370e:	2c670713          	addi	a4,a4,710 # 800199d0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003712:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003714:	4314                	lw	a3,0(a4)
    80003716:	04b68c63          	beq	a3,a1,8000376e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000371a:	2785                	addiw	a5,a5,1
    8000371c:	0711                	addi	a4,a4,4
    8000371e:	fef61be3          	bne	a2,a5,80003714 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003722:	0621                	addi	a2,a2,8
    80003724:	060a                	slli	a2,a2,0x2
    80003726:	00016797          	auipc	a5,0x16
    8000372a:	27a78793          	addi	a5,a5,634 # 800199a0 <log>
    8000372e:	97b2                	add	a5,a5,a2
    80003730:	44d8                	lw	a4,12(s1)
    80003732:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003734:	8526                	mv	a0,s1
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	dcc080e7          	jalr	-564(ra) # 80002502 <bpin>
    log.lh.n++;
    8000373e:	00016717          	auipc	a4,0x16
    80003742:	26270713          	addi	a4,a4,610 # 800199a0 <log>
    80003746:	575c                	lw	a5,44(a4)
    80003748:	2785                	addiw	a5,a5,1
    8000374a:	d75c                	sw	a5,44(a4)
    8000374c:	a82d                	j	80003786 <log_write+0xc8>
    panic("too big a transaction");
    8000374e:	00006517          	auipc	a0,0x6
    80003752:	ec250513          	addi	a0,a0,-318 # 80009610 <syscalls+0x230>
    80003756:	00003097          	auipc	ra,0x3
    8000375a:	294080e7          	jalr	660(ra) # 800069ea <panic>
    panic("log_write outside of trans");
    8000375e:	00006517          	auipc	a0,0x6
    80003762:	eca50513          	addi	a0,a0,-310 # 80009628 <syscalls+0x248>
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	284080e7          	jalr	644(ra) # 800069ea <panic>
  log.lh.block[i] = b->blockno;
    8000376e:	00878693          	addi	a3,a5,8
    80003772:	068a                	slli	a3,a3,0x2
    80003774:	00016717          	auipc	a4,0x16
    80003778:	22c70713          	addi	a4,a4,556 # 800199a0 <log>
    8000377c:	9736                	add	a4,a4,a3
    8000377e:	44d4                	lw	a3,12(s1)
    80003780:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003782:	faf609e3          	beq	a2,a5,80003734 <log_write+0x76>
  }
  release(&log.lock);
    80003786:	00016517          	auipc	a0,0x16
    8000378a:	21a50513          	addi	a0,a0,538 # 800199a0 <log>
    8000378e:	00004097          	auipc	ra,0x4
    80003792:	848080e7          	jalr	-1976(ra) # 80006fd6 <release>
}
    80003796:	60e2                	ld	ra,24(sp)
    80003798:	6442                	ld	s0,16(sp)
    8000379a:	64a2                	ld	s1,8(sp)
    8000379c:	6902                	ld	s2,0(sp)
    8000379e:	6105                	addi	sp,sp,32
    800037a0:	8082                	ret

00000000800037a2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	e426                	sd	s1,8(sp)
    800037aa:	e04a                	sd	s2,0(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
    800037b0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037b2:	00006597          	auipc	a1,0x6
    800037b6:	e9658593          	addi	a1,a1,-362 # 80009648 <syscalls+0x268>
    800037ba:	0521                	addi	a0,a0,8
    800037bc:	00003097          	auipc	ra,0x3
    800037c0:	6d6080e7          	jalr	1750(ra) # 80006e92 <initlock>
  lk->name = name;
    800037c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037cc:	0204a423          	sw	zero,40(s1)
}
    800037d0:	60e2                	ld	ra,24(sp)
    800037d2:	6442                	ld	s0,16(sp)
    800037d4:	64a2                	ld	s1,8(sp)
    800037d6:	6902                	ld	s2,0(sp)
    800037d8:	6105                	addi	sp,sp,32
    800037da:	8082                	ret

00000000800037dc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037dc:	1101                	addi	sp,sp,-32
    800037de:	ec06                	sd	ra,24(sp)
    800037e0:	e822                	sd	s0,16(sp)
    800037e2:	e426                	sd	s1,8(sp)
    800037e4:	e04a                	sd	s2,0(sp)
    800037e6:	1000                	addi	s0,sp,32
    800037e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037ea:	00850913          	addi	s2,a0,8
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	732080e7          	jalr	1842(ra) # 80006f22 <acquire>
  while (lk->locked) {
    800037f8:	409c                	lw	a5,0(s1)
    800037fa:	cb89                	beqz	a5,8000380c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037fc:	85ca                	mv	a1,s2
    800037fe:	8526                	mv	a0,s1
    80003800:	ffffe097          	auipc	ra,0xffffe
    80003804:	d52080e7          	jalr	-686(ra) # 80001552 <sleep>
  while (lk->locked) {
    80003808:	409c                	lw	a5,0(s1)
    8000380a:	fbed                	bnez	a5,800037fc <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000380c:	4785                	li	a5,1
    8000380e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003810:	ffffd097          	auipc	ra,0xffffd
    80003814:	69a080e7          	jalr	1690(ra) # 80000eaa <myproc>
    80003818:	591c                	lw	a5,48(a0)
    8000381a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000381c:	854a                	mv	a0,s2
    8000381e:	00003097          	auipc	ra,0x3
    80003822:	7b8080e7          	jalr	1976(ra) # 80006fd6 <release>
}
    80003826:	60e2                	ld	ra,24(sp)
    80003828:	6442                	ld	s0,16(sp)
    8000382a:	64a2                	ld	s1,8(sp)
    8000382c:	6902                	ld	s2,0(sp)
    8000382e:	6105                	addi	sp,sp,32
    80003830:	8082                	ret

0000000080003832 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003832:	1101                	addi	sp,sp,-32
    80003834:	ec06                	sd	ra,24(sp)
    80003836:	e822                	sd	s0,16(sp)
    80003838:	e426                	sd	s1,8(sp)
    8000383a:	e04a                	sd	s2,0(sp)
    8000383c:	1000                	addi	s0,sp,32
    8000383e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003840:	00850913          	addi	s2,a0,8
    80003844:	854a                	mv	a0,s2
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	6dc080e7          	jalr	1756(ra) # 80006f22 <acquire>
  lk->locked = 0;
    8000384e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003852:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003856:	8526                	mv	a0,s1
    80003858:	ffffe097          	auipc	ra,0xffffe
    8000385c:	d5e080e7          	jalr	-674(ra) # 800015b6 <wakeup>
  release(&lk->lk);
    80003860:	854a                	mv	a0,s2
    80003862:	00003097          	auipc	ra,0x3
    80003866:	774080e7          	jalr	1908(ra) # 80006fd6 <release>
}
    8000386a:	60e2                	ld	ra,24(sp)
    8000386c:	6442                	ld	s0,16(sp)
    8000386e:	64a2                	ld	s1,8(sp)
    80003870:	6902                	ld	s2,0(sp)
    80003872:	6105                	addi	sp,sp,32
    80003874:	8082                	ret

0000000080003876 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003876:	7179                	addi	sp,sp,-48
    80003878:	f406                	sd	ra,40(sp)
    8000387a:	f022                	sd	s0,32(sp)
    8000387c:	ec26                	sd	s1,24(sp)
    8000387e:	e84a                	sd	s2,16(sp)
    80003880:	e44e                	sd	s3,8(sp)
    80003882:	1800                	addi	s0,sp,48
    80003884:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003886:	00850913          	addi	s2,a0,8
    8000388a:	854a                	mv	a0,s2
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	696080e7          	jalr	1686(ra) # 80006f22 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003894:	409c                	lw	a5,0(s1)
    80003896:	ef99                	bnez	a5,800038b4 <holdingsleep+0x3e>
    80003898:	4481                	li	s1,0
  release(&lk->lk);
    8000389a:	854a                	mv	a0,s2
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	73a080e7          	jalr	1850(ra) # 80006fd6 <release>
  return r;
}
    800038a4:	8526                	mv	a0,s1
    800038a6:	70a2                	ld	ra,40(sp)
    800038a8:	7402                	ld	s0,32(sp)
    800038aa:	64e2                	ld	s1,24(sp)
    800038ac:	6942                	ld	s2,16(sp)
    800038ae:	69a2                	ld	s3,8(sp)
    800038b0:	6145                	addi	sp,sp,48
    800038b2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b4:	0284a983          	lw	s3,40(s1)
    800038b8:	ffffd097          	auipc	ra,0xffffd
    800038bc:	5f2080e7          	jalr	1522(ra) # 80000eaa <myproc>
    800038c0:	5904                	lw	s1,48(a0)
    800038c2:	413484b3          	sub	s1,s1,s3
    800038c6:	0014b493          	seqz	s1,s1
    800038ca:	bfc1                	j	8000389a <holdingsleep+0x24>

00000000800038cc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038cc:	1141                	addi	sp,sp,-16
    800038ce:	e406                	sd	ra,8(sp)
    800038d0:	e022                	sd	s0,0(sp)
    800038d2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038d4:	00006597          	auipc	a1,0x6
    800038d8:	d8458593          	addi	a1,a1,-636 # 80009658 <syscalls+0x278>
    800038dc:	00016517          	auipc	a0,0x16
    800038e0:	20c50513          	addi	a0,a0,524 # 80019ae8 <ftable>
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	5ae080e7          	jalr	1454(ra) # 80006e92 <initlock>
}
    800038ec:	60a2                	ld	ra,8(sp)
    800038ee:	6402                	ld	s0,0(sp)
    800038f0:	0141                	addi	sp,sp,16
    800038f2:	8082                	ret

00000000800038f4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038fe:	00016517          	auipc	a0,0x16
    80003902:	1ea50513          	addi	a0,a0,490 # 80019ae8 <ftable>
    80003906:	00003097          	auipc	ra,0x3
    8000390a:	61c080e7          	jalr	1564(ra) # 80006f22 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000390e:	00016497          	auipc	s1,0x16
    80003912:	1f248493          	addi	s1,s1,498 # 80019b00 <ftable+0x18>
    80003916:	00017717          	auipc	a4,0x17
    8000391a:	4aa70713          	addi	a4,a4,1194 # 8001adc0 <disk>
    if(f->ref == 0){
    8000391e:	40dc                	lw	a5,4(s1)
    80003920:	cf99                	beqz	a5,8000393e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003922:	03048493          	addi	s1,s1,48
    80003926:	fee49ce3          	bne	s1,a4,8000391e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000392a:	00016517          	auipc	a0,0x16
    8000392e:	1be50513          	addi	a0,a0,446 # 80019ae8 <ftable>
    80003932:	00003097          	auipc	ra,0x3
    80003936:	6a4080e7          	jalr	1700(ra) # 80006fd6 <release>
  return 0;
    8000393a:	4481                	li	s1,0
    8000393c:	a819                	j	80003952 <filealloc+0x5e>
      f->ref = 1;
    8000393e:	4785                	li	a5,1
    80003940:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003942:	00016517          	auipc	a0,0x16
    80003946:	1a650513          	addi	a0,a0,422 # 80019ae8 <ftable>
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	68c080e7          	jalr	1676(ra) # 80006fd6 <release>
}
    80003952:	8526                	mv	a0,s1
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6105                	addi	sp,sp,32
    8000395c:	8082                	ret

000000008000395e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000395e:	1101                	addi	sp,sp,-32
    80003960:	ec06                	sd	ra,24(sp)
    80003962:	e822                	sd	s0,16(sp)
    80003964:	e426                	sd	s1,8(sp)
    80003966:	1000                	addi	s0,sp,32
    80003968:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000396a:	00016517          	auipc	a0,0x16
    8000396e:	17e50513          	addi	a0,a0,382 # 80019ae8 <ftable>
    80003972:	00003097          	auipc	ra,0x3
    80003976:	5b0080e7          	jalr	1456(ra) # 80006f22 <acquire>
  if(f->ref < 1)
    8000397a:	40dc                	lw	a5,4(s1)
    8000397c:	02f05263          	blez	a5,800039a0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003980:	2785                	addiw	a5,a5,1
    80003982:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003984:	00016517          	auipc	a0,0x16
    80003988:	16450513          	addi	a0,a0,356 # 80019ae8 <ftable>
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	64a080e7          	jalr	1610(ra) # 80006fd6 <release>
  return f;
}
    80003994:	8526                	mv	a0,s1
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6105                	addi	sp,sp,32
    8000399e:	8082                	ret
    panic("filedup");
    800039a0:	00006517          	auipc	a0,0x6
    800039a4:	cc050513          	addi	a0,a0,-832 # 80009660 <syscalls+0x280>
    800039a8:	00003097          	auipc	ra,0x3
    800039ac:	042080e7          	jalr	66(ra) # 800069ea <panic>

00000000800039b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039b0:	7139                	addi	sp,sp,-64
    800039b2:	fc06                	sd	ra,56(sp)
    800039b4:	f822                	sd	s0,48(sp)
    800039b6:	f426                	sd	s1,40(sp)
    800039b8:	f04a                	sd	s2,32(sp)
    800039ba:	ec4e                	sd	s3,24(sp)
    800039bc:	e852                	sd	s4,16(sp)
    800039be:	e456                	sd	s5,8(sp)
    800039c0:	e05a                	sd	s6,0(sp)
    800039c2:	0080                	addi	s0,sp,64
    800039c4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039c6:	00016517          	auipc	a0,0x16
    800039ca:	12250513          	addi	a0,a0,290 # 80019ae8 <ftable>
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	554080e7          	jalr	1364(ra) # 80006f22 <acquire>
  if(f->ref < 1)
    800039d6:	40dc                	lw	a5,4(s1)
    800039d8:	04f05f63          	blez	a5,80003a36 <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039dc:	37fd                	addiw	a5,a5,-1
    800039de:	0007871b          	sext.w	a4,a5
    800039e2:	c0dc                	sw	a5,4(s1)
    800039e4:	06e04163          	bgtz	a4,80003a46 <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039e8:	0004a903          	lw	s2,0(s1)
    800039ec:	0094ca83          	lbu	s5,9(s1)
    800039f0:	0104ba03          	ld	s4,16(s1)
    800039f4:	0184b983          	ld	s3,24(s1)
    800039f8:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    800039fc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a00:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a04:	00016517          	auipc	a0,0x16
    80003a08:	0e450513          	addi	a0,a0,228 # 80019ae8 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	5ca080e7          	jalr	1482(ra) # 80006fd6 <release>

  if(ff.type == FD_PIPE){
    80003a14:	4785                	li	a5,1
    80003a16:	04f90a63          	beq	s2,a5,80003a6a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a1a:	ffe9079b          	addiw	a5,s2,-2
    80003a1e:	4705                	li	a4,1
    80003a20:	04f77c63          	bgeu	a4,a5,80003a78 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a24:	4791                	li	a5,4
    80003a26:	02f91863          	bne	s2,a5,80003a56 <fileclose+0xa6>
    sockclose(ff.sock);
    80003a2a:	855a                	mv	a0,s6
    80003a2c:	00002097          	auipc	ra,0x2
    80003a30:	754080e7          	jalr	1876(ra) # 80006180 <sockclose>
    80003a34:	a00d                	j	80003a56 <fileclose+0xa6>
    panic("fileclose");
    80003a36:	00006517          	auipc	a0,0x6
    80003a3a:	c3250513          	addi	a0,a0,-974 # 80009668 <syscalls+0x288>
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	fac080e7          	jalr	-84(ra) # 800069ea <panic>
    release(&ftable.lock);
    80003a46:	00016517          	auipc	a0,0x16
    80003a4a:	0a250513          	addi	a0,a0,162 # 80019ae8 <ftable>
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	588080e7          	jalr	1416(ra) # 80006fd6 <release>
  }
#endif
}
    80003a56:	70e2                	ld	ra,56(sp)
    80003a58:	7442                	ld	s0,48(sp)
    80003a5a:	74a2                	ld	s1,40(sp)
    80003a5c:	7902                	ld	s2,32(sp)
    80003a5e:	69e2                	ld	s3,24(sp)
    80003a60:	6a42                	ld	s4,16(sp)
    80003a62:	6aa2                	ld	s5,8(sp)
    80003a64:	6b02                	ld	s6,0(sp)
    80003a66:	6121                	addi	sp,sp,64
    80003a68:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a6a:	85d6                	mv	a1,s5
    80003a6c:	8552                	mv	a0,s4
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	37e080e7          	jalr	894(ra) # 80003dec <pipeclose>
    80003a76:	b7c5                	j	80003a56 <fileclose+0xa6>
    begin_op();
    80003a78:	00000097          	auipc	ra,0x0
    80003a7c:	a74080e7          	jalr	-1420(ra) # 800034ec <begin_op>
    iput(ff.ip);
    80003a80:	854e                	mv	a0,s3
    80003a82:	fffff097          	auipc	ra,0xfffff
    80003a86:	27e080e7          	jalr	638(ra) # 80002d00 <iput>
    end_op();
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	adc080e7          	jalr	-1316(ra) # 80003566 <end_op>
    80003a92:	b7d1                	j	80003a56 <fileclose+0xa6>

0000000080003a94 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a94:	715d                	addi	sp,sp,-80
    80003a96:	e486                	sd	ra,72(sp)
    80003a98:	e0a2                	sd	s0,64(sp)
    80003a9a:	fc26                	sd	s1,56(sp)
    80003a9c:	f84a                	sd	s2,48(sp)
    80003a9e:	f44e                	sd	s3,40(sp)
    80003aa0:	0880                	addi	s0,sp,80
    80003aa2:	84aa                	mv	s1,a0
    80003aa4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	404080e7          	jalr	1028(ra) # 80000eaa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aae:	409c                	lw	a5,0(s1)
    80003ab0:	37f9                	addiw	a5,a5,-2
    80003ab2:	4705                	li	a4,1
    80003ab4:	04f76763          	bltu	a4,a5,80003b02 <filestat+0x6e>
    80003ab8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aba:	6c88                	ld	a0,24(s1)
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	08a080e7          	jalr	138(ra) # 80002b46 <ilock>
    stati(f->ip, &st);
    80003ac4:	fb840593          	addi	a1,s0,-72
    80003ac8:	6c88                	ld	a0,24(s1)
    80003aca:	fffff097          	auipc	ra,0xfffff
    80003ace:	306080e7          	jalr	774(ra) # 80002dd0 <stati>
    iunlock(f->ip);
    80003ad2:	6c88                	ld	a0,24(s1)
    80003ad4:	fffff097          	auipc	ra,0xfffff
    80003ad8:	134080e7          	jalr	308(ra) # 80002c08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003adc:	46e1                	li	a3,24
    80003ade:	fb840613          	addi	a2,s0,-72
    80003ae2:	85ce                	mv	a1,s3
    80003ae4:	05093503          	ld	a0,80(s2)
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	086080e7          	jalr	134(ra) # 80000b6e <copyout>
    80003af0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003af4:	60a6                	ld	ra,72(sp)
    80003af6:	6406                	ld	s0,64(sp)
    80003af8:	74e2                	ld	s1,56(sp)
    80003afa:	7942                	ld	s2,48(sp)
    80003afc:	79a2                	ld	s3,40(sp)
    80003afe:	6161                	addi	sp,sp,80
    80003b00:	8082                	ret
  return -1;
    80003b02:	557d                	li	a0,-1
    80003b04:	bfc5                	j	80003af4 <filestat+0x60>

0000000080003b06 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b06:	7179                	addi	sp,sp,-48
    80003b08:	f406                	sd	ra,40(sp)
    80003b0a:	f022                	sd	s0,32(sp)
    80003b0c:	ec26                	sd	s1,24(sp)
    80003b0e:	e84a                	sd	s2,16(sp)
    80003b10:	e44e                	sd	s3,8(sp)
    80003b12:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b14:	00854783          	lbu	a5,8(a0)
    80003b18:	cfc5                	beqz	a5,80003bd0 <fileread+0xca>
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	89ae                	mv	s3,a1
    80003b1e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b20:	411c                	lw	a5,0(a0)
    80003b22:	4705                	li	a4,1
    80003b24:	02e78963          	beq	a5,a4,80003b56 <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b28:	470d                	li	a4,3
    80003b2a:	02e78d63          	beq	a5,a4,80003b64 <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2e:	4709                	li	a4,2
    80003b30:	04e78e63          	beq	a5,a4,80003b8c <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b34:	4711                	li	a4,4
    80003b36:	08e79563          	bne	a5,a4,80003bc0 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b3a:	7108                	ld	a0,32(a0)
    80003b3c:	00002097          	auipc	ra,0x2
    80003b40:	6d4080e7          	jalr	1748(ra) # 80006210 <sockread>
    80003b44:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b46:	854a                	mv	a0,s2
    80003b48:	70a2                	ld	ra,40(sp)
    80003b4a:	7402                	ld	s0,32(sp)
    80003b4c:	64e2                	ld	s1,24(sp)
    80003b4e:	6942                	ld	s2,16(sp)
    80003b50:	69a2                	ld	s3,8(sp)
    80003b52:	6145                	addi	sp,sp,48
    80003b54:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b56:	6908                	ld	a0,16(a0)
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	3fc080e7          	jalr	1020(ra) # 80003f54 <piperead>
    80003b60:	892a                	mv	s2,a0
    80003b62:	b7d5                	j	80003b46 <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b64:	02c51783          	lh	a5,44(a0)
    80003b68:	03079693          	slli	a3,a5,0x30
    80003b6c:	92c1                	srli	a3,a3,0x30
    80003b6e:	4725                	li	a4,9
    80003b70:	06d76263          	bltu	a4,a3,80003bd4 <fileread+0xce>
    80003b74:	0792                	slli	a5,a5,0x4
    80003b76:	00016717          	auipc	a4,0x16
    80003b7a:	ed270713          	addi	a4,a4,-302 # 80019a48 <devsw>
    80003b7e:	97ba                	add	a5,a5,a4
    80003b80:	639c                	ld	a5,0(a5)
    80003b82:	cbb9                	beqz	a5,80003bd8 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003b84:	4505                	li	a0,1
    80003b86:	9782                	jalr	a5
    80003b88:	892a                	mv	s2,a0
    80003b8a:	bf75                	j	80003b46 <fileread+0x40>
    ilock(f->ip);
    80003b8c:	6d08                	ld	a0,24(a0)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	fb8080e7          	jalr	-72(ra) # 80002b46 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b96:	874a                	mv	a4,s2
    80003b98:	5494                	lw	a3,40(s1)
    80003b9a:	864e                	mv	a2,s3
    80003b9c:	4585                	li	a1,1
    80003b9e:	6c88                	ld	a0,24(s1)
    80003ba0:	fffff097          	auipc	ra,0xfffff
    80003ba4:	25a080e7          	jalr	602(ra) # 80002dfa <readi>
    80003ba8:	892a                	mv	s2,a0
    80003baa:	00a05563          	blez	a0,80003bb4 <fileread+0xae>
      f->off += r;
    80003bae:	549c                	lw	a5,40(s1)
    80003bb0:	9fa9                	addw	a5,a5,a0
    80003bb2:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	052080e7          	jalr	82(ra) # 80002c08 <iunlock>
    80003bbe:	b761                	j	80003b46 <fileread+0x40>
    panic("fileread");
    80003bc0:	00006517          	auipc	a0,0x6
    80003bc4:	ab850513          	addi	a0,a0,-1352 # 80009678 <syscalls+0x298>
    80003bc8:	00003097          	auipc	ra,0x3
    80003bcc:	e22080e7          	jalr	-478(ra) # 800069ea <panic>
    return -1;
    80003bd0:	597d                	li	s2,-1
    80003bd2:	bf95                	j	80003b46 <fileread+0x40>
      return -1;
    80003bd4:	597d                	li	s2,-1
    80003bd6:	bf85                	j	80003b46 <fileread+0x40>
    80003bd8:	597d                	li	s2,-1
    80003bda:	b7b5                	j	80003b46 <fileread+0x40>

0000000080003bdc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bdc:	00954783          	lbu	a5,9(a0)
    80003be0:	12078163          	beqz	a5,80003d02 <filewrite+0x126>
{
    80003be4:	715d                	addi	sp,sp,-80
    80003be6:	e486                	sd	ra,72(sp)
    80003be8:	e0a2                	sd	s0,64(sp)
    80003bea:	fc26                	sd	s1,56(sp)
    80003bec:	f84a                	sd	s2,48(sp)
    80003bee:	f44e                	sd	s3,40(sp)
    80003bf0:	f052                	sd	s4,32(sp)
    80003bf2:	ec56                	sd	s5,24(sp)
    80003bf4:	e85a                	sd	s6,16(sp)
    80003bf6:	e45e                	sd	s7,8(sp)
    80003bf8:	e062                	sd	s8,0(sp)
    80003bfa:	0880                	addi	s0,sp,80
    80003bfc:	84aa                	mv	s1,a0
    80003bfe:	8aae                	mv	s5,a1
    80003c00:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c02:	411c                	lw	a5,0(a0)
    80003c04:	4705                	li	a4,1
    80003c06:	02e78c63          	beq	a5,a4,80003c3e <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c0a:	470d                	li	a4,3
    80003c0c:	02e78f63          	beq	a5,a4,80003c4a <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c10:	4709                	li	a4,2
    80003c12:	04e78f63          	beq	a5,a4,80003c70 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003c16:	4711                	li	a4,4
    80003c18:	0ce79d63          	bne	a5,a4,80003cf2 <filewrite+0x116>
    ret = sockwrite(f->sock, addr, n);
    80003c1c:	7108                	ld	a0,32(a0)
    80003c1e:	00002097          	auipc	ra,0x2
    80003c22:	6c4080e7          	jalr	1732(ra) # 800062e2 <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c26:	60a6                	ld	ra,72(sp)
    80003c28:	6406                	ld	s0,64(sp)
    80003c2a:	74e2                	ld	s1,56(sp)
    80003c2c:	7942                	ld	s2,48(sp)
    80003c2e:	79a2                	ld	s3,40(sp)
    80003c30:	7a02                	ld	s4,32(sp)
    80003c32:	6ae2                	ld	s5,24(sp)
    80003c34:	6b42                	ld	s6,16(sp)
    80003c36:	6ba2                	ld	s7,8(sp)
    80003c38:	6c02                	ld	s8,0(sp)
    80003c3a:	6161                	addi	sp,sp,80
    80003c3c:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c3e:	6908                	ld	a0,16(a0)
    80003c40:	00000097          	auipc	ra,0x0
    80003c44:	21c080e7          	jalr	540(ra) # 80003e5c <pipewrite>
    80003c48:	bff9                	j	80003c26 <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c4a:	02c51783          	lh	a5,44(a0)
    80003c4e:	03079693          	slli	a3,a5,0x30
    80003c52:	92c1                	srli	a3,a3,0x30
    80003c54:	4725                	li	a4,9
    80003c56:	0ad76863          	bltu	a4,a3,80003d06 <filewrite+0x12a>
    80003c5a:	0792                	slli	a5,a5,0x4
    80003c5c:	00016717          	auipc	a4,0x16
    80003c60:	dec70713          	addi	a4,a4,-532 # 80019a48 <devsw>
    80003c64:	97ba                	add	a5,a5,a4
    80003c66:	679c                	ld	a5,8(a5)
    80003c68:	c3cd                	beqz	a5,80003d0a <filewrite+0x12e>
    ret = devsw[f->major].write(1, addr, n);
    80003c6a:	4505                	li	a0,1
    80003c6c:	9782                	jalr	a5
    80003c6e:	bf65                	j	80003c26 <filewrite+0x4a>
    while(i < n){
    80003c70:	06c05c63          	blez	a2,80003ce8 <filewrite+0x10c>
    int i = 0;
    80003c74:	4a01                	li	s4,0
      if(n1 > max)
    80003c76:	6b85                	lui	s7,0x1
    80003c78:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c7c:	6c05                	lui	s8,0x1
    80003c7e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c82:	a899                	j	80003cd8 <filewrite+0xfc>
    80003c84:	00098b1b          	sext.w	s6,s3
      begin_op();
    80003c88:	00000097          	auipc	ra,0x0
    80003c8c:	864080e7          	jalr	-1948(ra) # 800034ec <begin_op>
      ilock(f->ip);
    80003c90:	6c88                	ld	a0,24(s1)
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	eb4080e7          	jalr	-332(ra) # 80002b46 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c9a:	875a                	mv	a4,s6
    80003c9c:	5494                	lw	a3,40(s1)
    80003c9e:	015a0633          	add	a2,s4,s5
    80003ca2:	4585                	li	a1,1
    80003ca4:	6c88                	ld	a0,24(s1)
    80003ca6:	fffff097          	auipc	ra,0xfffff
    80003caa:	24c080e7          	jalr	588(ra) # 80002ef2 <writei>
    80003cae:	89aa                	mv	s3,a0
    80003cb0:	00a05563          	blez	a0,80003cba <filewrite+0xde>
        f->off += r;
    80003cb4:	549c                	lw	a5,40(s1)
    80003cb6:	9fa9                	addw	a5,a5,a0
    80003cb8:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003cba:	6c88                	ld	a0,24(s1)
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	f4c080e7          	jalr	-180(ra) # 80002c08 <iunlock>
      end_op();
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	8a2080e7          	jalr	-1886(ra) # 80003566 <end_op>
      if(r != n1){
    80003ccc:	013b1f63          	bne	s6,s3,80003cea <filewrite+0x10e>
      i += r;
    80003cd0:	01498a3b          	addw	s4,s3,s4
    while(i < n){
    80003cd4:	012a5b63          	bge	s4,s2,80003cea <filewrite+0x10e>
      int n1 = n - i;
    80003cd8:	414909bb          	subw	s3,s2,s4
      if(n1 > max)
    80003cdc:	0009879b          	sext.w	a5,s3
    80003ce0:	fafbd2e3          	bge	s7,a5,80003c84 <filewrite+0xa8>
    80003ce4:	89e2                	mv	s3,s8
    80003ce6:	bf79                	j	80003c84 <filewrite+0xa8>
    int i = 0;
    80003ce8:	4a01                	li	s4,0
    ret = (i == n ? n : -1);
    80003cea:	03491263          	bne	s2,s4,80003d0e <filewrite+0x132>
    80003cee:	854a                	mv	a0,s2
    80003cf0:	bf1d                	j	80003c26 <filewrite+0x4a>
    panic("filewrite");
    80003cf2:	00006517          	auipc	a0,0x6
    80003cf6:	99650513          	addi	a0,a0,-1642 # 80009688 <syscalls+0x2a8>
    80003cfa:	00003097          	auipc	ra,0x3
    80003cfe:	cf0080e7          	jalr	-784(ra) # 800069ea <panic>
    return -1;
    80003d02:	557d                	li	a0,-1
}
    80003d04:	8082                	ret
      return -1;
    80003d06:	557d                	li	a0,-1
    80003d08:	bf39                	j	80003c26 <filewrite+0x4a>
    80003d0a:	557d                	li	a0,-1
    80003d0c:	bf29                	j	80003c26 <filewrite+0x4a>
    ret = (i == n ? n : -1);
    80003d0e:	557d                	li	a0,-1
    80003d10:	bf19                	j	80003c26 <filewrite+0x4a>

0000000080003d12 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d12:	7179                	addi	sp,sp,-48
    80003d14:	f406                	sd	ra,40(sp)
    80003d16:	f022                	sd	s0,32(sp)
    80003d18:	ec26                	sd	s1,24(sp)
    80003d1a:	e84a                	sd	s2,16(sp)
    80003d1c:	e44e                	sd	s3,8(sp)
    80003d1e:	e052                	sd	s4,0(sp)
    80003d20:	1800                	addi	s0,sp,48
    80003d22:	84aa                	mv	s1,a0
    80003d24:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d26:	0005b023          	sd	zero,0(a1)
    80003d2a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d2e:	00000097          	auipc	ra,0x0
    80003d32:	bc6080e7          	jalr	-1082(ra) # 800038f4 <filealloc>
    80003d36:	e088                	sd	a0,0(s1)
    80003d38:	c551                	beqz	a0,80003dc4 <pipealloc+0xb2>
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	bba080e7          	jalr	-1094(ra) # 800038f4 <filealloc>
    80003d42:	00aa3023          	sd	a0,0(s4)
    80003d46:	c92d                	beqz	a0,80003db8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d48:	ffffc097          	auipc	ra,0xffffc
    80003d4c:	3d2080e7          	jalr	978(ra) # 8000011a <kalloc>
    80003d50:	892a                	mv	s2,a0
    80003d52:	c125                	beqz	a0,80003db2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d54:	4985                	li	s3,1
    80003d56:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d5a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d5e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d62:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d66:	00006597          	auipc	a1,0x6
    80003d6a:	93258593          	addi	a1,a1,-1742 # 80009698 <syscalls+0x2b8>
    80003d6e:	00003097          	auipc	ra,0x3
    80003d72:	124080e7          	jalr	292(ra) # 80006e92 <initlock>
  (*f0)->type = FD_PIPE;
    80003d76:	609c                	ld	a5,0(s1)
    80003d78:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d7c:	609c                	ld	a5,0(s1)
    80003d7e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d82:	609c                	ld	a5,0(s1)
    80003d84:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d88:	609c                	ld	a5,0(s1)
    80003d8a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d8e:	000a3783          	ld	a5,0(s4)
    80003d92:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d96:	000a3783          	ld	a5,0(s4)
    80003d9a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d9e:	000a3783          	ld	a5,0(s4)
    80003da2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003da6:	000a3783          	ld	a5,0(s4)
    80003daa:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dae:	4501                	li	a0,0
    80003db0:	a025                	j	80003dd8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003db2:	6088                	ld	a0,0(s1)
    80003db4:	e501                	bnez	a0,80003dbc <pipealloc+0xaa>
    80003db6:	a039                	j	80003dc4 <pipealloc+0xb2>
    80003db8:	6088                	ld	a0,0(s1)
    80003dba:	c51d                	beqz	a0,80003de8 <pipealloc+0xd6>
    fileclose(*f0);
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	bf4080e7          	jalr	-1036(ra) # 800039b0 <fileclose>
  if(*f1)
    80003dc4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dc8:	557d                	li	a0,-1
  if(*f1)
    80003dca:	c799                	beqz	a5,80003dd8 <pipealloc+0xc6>
    fileclose(*f1);
    80003dcc:	853e                	mv	a0,a5
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	be2080e7          	jalr	-1054(ra) # 800039b0 <fileclose>
  return -1;
    80003dd6:	557d                	li	a0,-1
}
    80003dd8:	70a2                	ld	ra,40(sp)
    80003dda:	7402                	ld	s0,32(sp)
    80003ddc:	64e2                	ld	s1,24(sp)
    80003dde:	6942                	ld	s2,16(sp)
    80003de0:	69a2                	ld	s3,8(sp)
    80003de2:	6a02                	ld	s4,0(sp)
    80003de4:	6145                	addi	sp,sp,48
    80003de6:	8082                	ret
  return -1;
    80003de8:	557d                	li	a0,-1
    80003dea:	b7fd                	j	80003dd8 <pipealloc+0xc6>

0000000080003dec <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dec:	1101                	addi	sp,sp,-32
    80003dee:	ec06                	sd	ra,24(sp)
    80003df0:	e822                	sd	s0,16(sp)
    80003df2:	e426                	sd	s1,8(sp)
    80003df4:	e04a                	sd	s2,0(sp)
    80003df6:	1000                	addi	s0,sp,32
    80003df8:	84aa                	mv	s1,a0
    80003dfa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003dfc:	00003097          	auipc	ra,0x3
    80003e00:	126080e7          	jalr	294(ra) # 80006f22 <acquire>
  if(writable){
    80003e04:	02090d63          	beqz	s2,80003e3e <pipeclose+0x52>
    pi->writeopen = 0;
    80003e08:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e0c:	21848513          	addi	a0,s1,536
    80003e10:	ffffd097          	auipc	ra,0xffffd
    80003e14:	7a6080e7          	jalr	1958(ra) # 800015b6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e18:	2204b783          	ld	a5,544(s1)
    80003e1c:	eb95                	bnez	a5,80003e50 <pipeclose+0x64>
    release(&pi->lock);
    80003e1e:	8526                	mv	a0,s1
    80003e20:	00003097          	auipc	ra,0x3
    80003e24:	1b6080e7          	jalr	438(ra) # 80006fd6 <release>
    kfree((char*)pi);
    80003e28:	8526                	mv	a0,s1
    80003e2a:	ffffc097          	auipc	ra,0xffffc
    80003e2e:	1f2080e7          	jalr	498(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e32:	60e2                	ld	ra,24(sp)
    80003e34:	6442                	ld	s0,16(sp)
    80003e36:	64a2                	ld	s1,8(sp)
    80003e38:	6902                	ld	s2,0(sp)
    80003e3a:	6105                	addi	sp,sp,32
    80003e3c:	8082                	ret
    pi->readopen = 0;
    80003e3e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e42:	21c48513          	addi	a0,s1,540
    80003e46:	ffffd097          	auipc	ra,0xffffd
    80003e4a:	770080e7          	jalr	1904(ra) # 800015b6 <wakeup>
    80003e4e:	b7e9                	j	80003e18 <pipeclose+0x2c>
    release(&pi->lock);
    80003e50:	8526                	mv	a0,s1
    80003e52:	00003097          	auipc	ra,0x3
    80003e56:	184080e7          	jalr	388(ra) # 80006fd6 <release>
}
    80003e5a:	bfe1                	j	80003e32 <pipeclose+0x46>

0000000080003e5c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e5c:	711d                	addi	sp,sp,-96
    80003e5e:	ec86                	sd	ra,88(sp)
    80003e60:	e8a2                	sd	s0,80(sp)
    80003e62:	e4a6                	sd	s1,72(sp)
    80003e64:	e0ca                	sd	s2,64(sp)
    80003e66:	fc4e                	sd	s3,56(sp)
    80003e68:	f852                	sd	s4,48(sp)
    80003e6a:	f456                	sd	s5,40(sp)
    80003e6c:	f05a                	sd	s6,32(sp)
    80003e6e:	ec5e                	sd	s7,24(sp)
    80003e70:	e862                	sd	s8,16(sp)
    80003e72:	1080                	addi	s0,sp,96
    80003e74:	84aa                	mv	s1,a0
    80003e76:	8aae                	mv	s5,a1
    80003e78:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e7a:	ffffd097          	auipc	ra,0xffffd
    80003e7e:	030080e7          	jalr	48(ra) # 80000eaa <myproc>
    80003e82:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e84:	8526                	mv	a0,s1
    80003e86:	00003097          	auipc	ra,0x3
    80003e8a:	09c080e7          	jalr	156(ra) # 80006f22 <acquire>
  while(i < n){
    80003e8e:	0b405663          	blez	s4,80003f3a <pipewrite+0xde>
  int i = 0;
    80003e92:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e94:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e96:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e9a:	21c48b93          	addi	s7,s1,540
    80003e9e:	a089                	j	80003ee0 <pipewrite+0x84>
      release(&pi->lock);
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	00003097          	auipc	ra,0x3
    80003ea6:	134080e7          	jalr	308(ra) # 80006fd6 <release>
      return -1;
    80003eaa:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003eac:	854a                	mv	a0,s2
    80003eae:	60e6                	ld	ra,88(sp)
    80003eb0:	6446                	ld	s0,80(sp)
    80003eb2:	64a6                	ld	s1,72(sp)
    80003eb4:	6906                	ld	s2,64(sp)
    80003eb6:	79e2                	ld	s3,56(sp)
    80003eb8:	7a42                	ld	s4,48(sp)
    80003eba:	7aa2                	ld	s5,40(sp)
    80003ebc:	7b02                	ld	s6,32(sp)
    80003ebe:	6be2                	ld	s7,24(sp)
    80003ec0:	6c42                	ld	s8,16(sp)
    80003ec2:	6125                	addi	sp,sp,96
    80003ec4:	8082                	ret
      wakeup(&pi->nread);
    80003ec6:	8562                	mv	a0,s8
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	6ee080e7          	jalr	1774(ra) # 800015b6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ed0:	85a6                	mv	a1,s1
    80003ed2:	855e                	mv	a0,s7
    80003ed4:	ffffd097          	auipc	ra,0xffffd
    80003ed8:	67e080e7          	jalr	1662(ra) # 80001552 <sleep>
  while(i < n){
    80003edc:	07495063          	bge	s2,s4,80003f3c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003ee0:	2204a783          	lw	a5,544(s1)
    80003ee4:	dfd5                	beqz	a5,80003ea0 <pipewrite+0x44>
    80003ee6:	854e                	mv	a0,s3
    80003ee8:	ffffe097          	auipc	ra,0xffffe
    80003eec:	912080e7          	jalr	-1774(ra) # 800017fa <killed>
    80003ef0:	f945                	bnez	a0,80003ea0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ef2:	2184a783          	lw	a5,536(s1)
    80003ef6:	21c4a703          	lw	a4,540(s1)
    80003efa:	2007879b          	addiw	a5,a5,512
    80003efe:	fcf704e3          	beq	a4,a5,80003ec6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f02:	4685                	li	a3,1
    80003f04:	01590633          	add	a2,s2,s5
    80003f08:	faf40593          	addi	a1,s0,-81
    80003f0c:	0509b503          	ld	a0,80(s3)
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	cea080e7          	jalr	-790(ra) # 80000bfa <copyin>
    80003f18:	03650263          	beq	a0,s6,80003f3c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f1c:	21c4a783          	lw	a5,540(s1)
    80003f20:	0017871b          	addiw	a4,a5,1
    80003f24:	20e4ae23          	sw	a4,540(s1)
    80003f28:	1ff7f793          	andi	a5,a5,511
    80003f2c:	97a6                	add	a5,a5,s1
    80003f2e:	faf44703          	lbu	a4,-81(s0)
    80003f32:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f36:	2905                	addiw	s2,s2,1
    80003f38:	b755                	j	80003edc <pipewrite+0x80>
  int i = 0;
    80003f3a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f3c:	21848513          	addi	a0,s1,536
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	676080e7          	jalr	1654(ra) # 800015b6 <wakeup>
  release(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00003097          	auipc	ra,0x3
    80003f4e:	08c080e7          	jalr	140(ra) # 80006fd6 <release>
  return i;
    80003f52:	bfa9                	j	80003eac <pipewrite+0x50>

0000000080003f54 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f54:	715d                	addi	sp,sp,-80
    80003f56:	e486                	sd	ra,72(sp)
    80003f58:	e0a2                	sd	s0,64(sp)
    80003f5a:	fc26                	sd	s1,56(sp)
    80003f5c:	f84a                	sd	s2,48(sp)
    80003f5e:	f44e                	sd	s3,40(sp)
    80003f60:	f052                	sd	s4,32(sp)
    80003f62:	ec56                	sd	s5,24(sp)
    80003f64:	e85a                	sd	s6,16(sp)
    80003f66:	0880                	addi	s0,sp,80
    80003f68:	84aa                	mv	s1,a0
    80003f6a:	892e                	mv	s2,a1
    80003f6c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	f3c080e7          	jalr	-196(ra) # 80000eaa <myproc>
    80003f76:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	00003097          	auipc	ra,0x3
    80003f7e:	fa8080e7          	jalr	-88(ra) # 80006f22 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f82:	2184a703          	lw	a4,536(s1)
    80003f86:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f8a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f8e:	02f71763          	bne	a4,a5,80003fbc <piperead+0x68>
    80003f92:	2244a783          	lw	a5,548(s1)
    80003f96:	c39d                	beqz	a5,80003fbc <piperead+0x68>
    if(killed(pr)){
    80003f98:	8552                	mv	a0,s4
    80003f9a:	ffffe097          	auipc	ra,0xffffe
    80003f9e:	860080e7          	jalr	-1952(ra) # 800017fa <killed>
    80003fa2:	e949                	bnez	a0,80004034 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fa4:	85a6                	mv	a1,s1
    80003fa6:	854e                	mv	a0,s3
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	5aa080e7          	jalr	1450(ra) # 80001552 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fb0:	2184a703          	lw	a4,536(s1)
    80003fb4:	21c4a783          	lw	a5,540(s1)
    80003fb8:	fcf70de3          	beq	a4,a5,80003f92 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fbc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fbe:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fc0:	05505463          	blez	s5,80004008 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80003fc4:	2184a783          	lw	a5,536(s1)
    80003fc8:	21c4a703          	lw	a4,540(s1)
    80003fcc:	02f70e63          	beq	a4,a5,80004008 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fd0:	0017871b          	addiw	a4,a5,1
    80003fd4:	20e4ac23          	sw	a4,536(s1)
    80003fd8:	1ff7f793          	andi	a5,a5,511
    80003fdc:	97a6                	add	a5,a5,s1
    80003fde:	0187c783          	lbu	a5,24(a5)
    80003fe2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fe6:	4685                	li	a3,1
    80003fe8:	fbf40613          	addi	a2,s0,-65
    80003fec:	85ca                	mv	a1,s2
    80003fee:	050a3503          	ld	a0,80(s4)
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	b7c080e7          	jalr	-1156(ra) # 80000b6e <copyout>
    80003ffa:	01650763          	beq	a0,s6,80004008 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ffe:	2985                	addiw	s3,s3,1
    80004000:	0905                	addi	s2,s2,1
    80004002:	fd3a91e3          	bne	s5,s3,80003fc4 <piperead+0x70>
    80004006:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004008:	21c48513          	addi	a0,s1,540
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	5aa080e7          	jalr	1450(ra) # 800015b6 <wakeup>
  release(&pi->lock);
    80004014:	8526                	mv	a0,s1
    80004016:	00003097          	auipc	ra,0x3
    8000401a:	fc0080e7          	jalr	-64(ra) # 80006fd6 <release>
  return i;
}
    8000401e:	854e                	mv	a0,s3
    80004020:	60a6                	ld	ra,72(sp)
    80004022:	6406                	ld	s0,64(sp)
    80004024:	74e2                	ld	s1,56(sp)
    80004026:	7942                	ld	s2,48(sp)
    80004028:	79a2                	ld	s3,40(sp)
    8000402a:	7a02                	ld	s4,32(sp)
    8000402c:	6ae2                	ld	s5,24(sp)
    8000402e:	6b42                	ld	s6,16(sp)
    80004030:	6161                	addi	sp,sp,80
    80004032:	8082                	ret
      release(&pi->lock);
    80004034:	8526                	mv	a0,s1
    80004036:	00003097          	auipc	ra,0x3
    8000403a:	fa0080e7          	jalr	-96(ra) # 80006fd6 <release>
      return -1;
    8000403e:	59fd                	li	s3,-1
    80004040:	bff9                	j	8000401e <piperead+0xca>

0000000080004042 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004042:	1141                	addi	sp,sp,-16
    80004044:	e422                	sd	s0,8(sp)
    80004046:	0800                	addi	s0,sp,16
    80004048:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000404a:	8905                	andi	a0,a0,1
    8000404c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000404e:	8b89                	andi	a5,a5,2
    80004050:	c399                	beqz	a5,80004056 <flags2perm+0x14>
      perm |= PTE_W;
    80004052:	00456513          	ori	a0,a0,4
    return perm;
}
    80004056:	6422                	ld	s0,8(sp)
    80004058:	0141                	addi	sp,sp,16
    8000405a:	8082                	ret

000000008000405c <exec>:

int
exec(char *path, char **argv)
{
    8000405c:	df010113          	addi	sp,sp,-528
    80004060:	20113423          	sd	ra,520(sp)
    80004064:	20813023          	sd	s0,512(sp)
    80004068:	ffa6                	sd	s1,504(sp)
    8000406a:	fbca                	sd	s2,496(sp)
    8000406c:	f7ce                	sd	s3,488(sp)
    8000406e:	f3d2                	sd	s4,480(sp)
    80004070:	efd6                	sd	s5,472(sp)
    80004072:	ebda                	sd	s6,464(sp)
    80004074:	e7de                	sd	s7,456(sp)
    80004076:	e3e2                	sd	s8,448(sp)
    80004078:	ff66                	sd	s9,440(sp)
    8000407a:	fb6a                	sd	s10,432(sp)
    8000407c:	f76e                	sd	s11,424(sp)
    8000407e:	0c00                	addi	s0,sp,528
    80004080:	892a                	mv	s2,a0
    80004082:	dea43c23          	sd	a0,-520(s0)
    80004086:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	e20080e7          	jalr	-480(ra) # 80000eaa <myproc>
    80004092:	84aa                	mv	s1,a0

  begin_op();
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	458080e7          	jalr	1112(ra) # 800034ec <begin_op>

  if((ip = namei(path)) == 0){
    8000409c:	854a                	mv	a0,s2
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	24e080e7          	jalr	590(ra) # 800032ec <namei>
    800040a6:	c92d                	beqz	a0,80004118 <exec+0xbc>
    800040a8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	a9c080e7          	jalr	-1380(ra) # 80002b46 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040b2:	04000713          	li	a4,64
    800040b6:	4681                	li	a3,0
    800040b8:	e5040613          	addi	a2,s0,-432
    800040bc:	4581                	li	a1,0
    800040be:	8552                	mv	a0,s4
    800040c0:	fffff097          	auipc	ra,0xfffff
    800040c4:	d3a080e7          	jalr	-710(ra) # 80002dfa <readi>
    800040c8:	04000793          	li	a5,64
    800040cc:	00f51a63          	bne	a0,a5,800040e0 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040d0:	e5042703          	lw	a4,-432(s0)
    800040d4:	464c47b7          	lui	a5,0x464c4
    800040d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040dc:	04f70463          	beq	a4,a5,80004124 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040e0:	8552                	mv	a0,s4
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	cc6080e7          	jalr	-826(ra) # 80002da8 <iunlockput>
    end_op();
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	47c080e7          	jalr	1148(ra) # 80003566 <end_op>
  }
  return -1;
    800040f2:	557d                	li	a0,-1
}
    800040f4:	20813083          	ld	ra,520(sp)
    800040f8:	20013403          	ld	s0,512(sp)
    800040fc:	74fe                	ld	s1,504(sp)
    800040fe:	795e                	ld	s2,496(sp)
    80004100:	79be                	ld	s3,488(sp)
    80004102:	7a1e                	ld	s4,480(sp)
    80004104:	6afe                	ld	s5,472(sp)
    80004106:	6b5e                	ld	s6,464(sp)
    80004108:	6bbe                	ld	s7,456(sp)
    8000410a:	6c1e                	ld	s8,448(sp)
    8000410c:	7cfa                	ld	s9,440(sp)
    8000410e:	7d5a                	ld	s10,432(sp)
    80004110:	7dba                	ld	s11,424(sp)
    80004112:	21010113          	addi	sp,sp,528
    80004116:	8082                	ret
    end_op();
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	44e080e7          	jalr	1102(ra) # 80003566 <end_op>
    return -1;
    80004120:	557d                	li	a0,-1
    80004122:	bfc9                	j	800040f4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004124:	8526                	mv	a0,s1
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	e48080e7          	jalr	-440(ra) # 80000f6e <proc_pagetable>
    8000412e:	8b2a                	mv	s6,a0
    80004130:	d945                	beqz	a0,800040e0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004132:	e7042d03          	lw	s10,-400(s0)
    80004136:	e8845783          	lhu	a5,-376(s0)
    8000413a:	10078463          	beqz	a5,80004242 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000413e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004140:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004142:	6c85                	lui	s9,0x1
    80004144:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004148:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000414c:	6a85                	lui	s5,0x1
    8000414e:	a0b5                	j	800041ba <exec+0x15e>
      panic("loadseg: address should exist");
    80004150:	00005517          	auipc	a0,0x5
    80004154:	55050513          	addi	a0,a0,1360 # 800096a0 <syscalls+0x2c0>
    80004158:	00003097          	auipc	ra,0x3
    8000415c:	892080e7          	jalr	-1902(ra) # 800069ea <panic>
    if(sz - i < PGSIZE)
    80004160:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004162:	8726                	mv	a4,s1
    80004164:	012c06bb          	addw	a3,s8,s2
    80004168:	4581                	li	a1,0
    8000416a:	8552                	mv	a0,s4
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	c8e080e7          	jalr	-882(ra) # 80002dfa <readi>
    80004174:	2501                	sext.w	a0,a0
    80004176:	24a49863          	bne	s1,a0,800043c6 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000417a:	012a893b          	addw	s2,s5,s2
    8000417e:	03397563          	bgeu	s2,s3,800041a8 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004182:	02091593          	slli	a1,s2,0x20
    80004186:	9181                	srli	a1,a1,0x20
    80004188:	95de                	add	a1,a1,s7
    8000418a:	855a                	mv	a0,s6
    8000418c:	ffffc097          	auipc	ra,0xffffc
    80004190:	38e080e7          	jalr	910(ra) # 8000051a <walkaddr>
    80004194:	862a                	mv	a2,a0
    if(pa == 0)
    80004196:	dd4d                	beqz	a0,80004150 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004198:	412984bb          	subw	s1,s3,s2
    8000419c:	0004879b          	sext.w	a5,s1
    800041a0:	fcfcf0e3          	bgeu	s9,a5,80004160 <exec+0x104>
    800041a4:	84d6                	mv	s1,s5
    800041a6:	bf6d                	j	80004160 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800041a8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ac:	2d85                	addiw	s11,s11,1
    800041ae:	038d0d1b          	addiw	s10,s10,56
    800041b2:	e8845783          	lhu	a5,-376(s0)
    800041b6:	08fdd763          	bge	s11,a5,80004244 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041ba:	2d01                	sext.w	s10,s10
    800041bc:	03800713          	li	a4,56
    800041c0:	86ea                	mv	a3,s10
    800041c2:	e1840613          	addi	a2,s0,-488
    800041c6:	4581                	li	a1,0
    800041c8:	8552                	mv	a0,s4
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	c30080e7          	jalr	-976(ra) # 80002dfa <readi>
    800041d2:	03800793          	li	a5,56
    800041d6:	1ef51663          	bne	a0,a5,800043c2 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800041da:	e1842783          	lw	a5,-488(s0)
    800041de:	4705                	li	a4,1
    800041e0:	fce796e3          	bne	a5,a4,800041ac <exec+0x150>
    if(ph.memsz < ph.filesz)
    800041e4:	e4043483          	ld	s1,-448(s0)
    800041e8:	e3843783          	ld	a5,-456(s0)
    800041ec:	1ef4e863          	bltu	s1,a5,800043dc <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041f0:	e2843783          	ld	a5,-472(s0)
    800041f4:	94be                	add	s1,s1,a5
    800041f6:	1ef4e663          	bltu	s1,a5,800043e2 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800041fa:	df043703          	ld	a4,-528(s0)
    800041fe:	8ff9                	and	a5,a5,a4
    80004200:	1e079463          	bnez	a5,800043e8 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004204:	e1c42503          	lw	a0,-484(s0)
    80004208:	00000097          	auipc	ra,0x0
    8000420c:	e3a080e7          	jalr	-454(ra) # 80004042 <flags2perm>
    80004210:	86aa                	mv	a3,a0
    80004212:	8626                	mv	a2,s1
    80004214:	85ca                	mv	a1,s2
    80004216:	855a                	mv	a0,s6
    80004218:	ffffc097          	auipc	ra,0xffffc
    8000421c:	6fa080e7          	jalr	1786(ra) # 80000912 <uvmalloc>
    80004220:	e0a43423          	sd	a0,-504(s0)
    80004224:	1c050563          	beqz	a0,800043ee <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004228:	e2843b83          	ld	s7,-472(s0)
    8000422c:	e2042c03          	lw	s8,-480(s0)
    80004230:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004234:	00098463          	beqz	s3,8000423c <exec+0x1e0>
    80004238:	4901                	li	s2,0
    8000423a:	b7a1                	j	80004182 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000423c:	e0843903          	ld	s2,-504(s0)
    80004240:	b7b5                	j	800041ac <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004242:	4901                	li	s2,0
  iunlockput(ip);
    80004244:	8552                	mv	a0,s4
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	b62080e7          	jalr	-1182(ra) # 80002da8 <iunlockput>
  end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	318080e7          	jalr	792(ra) # 80003566 <end_op>
  p = myproc();
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	c54080e7          	jalr	-940(ra) # 80000eaa <myproc>
    8000425e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004260:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004264:	6985                	lui	s3,0x1
    80004266:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004268:	99ca                	add	s3,s3,s2
    8000426a:	77fd                	lui	a5,0xfffff
    8000426c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004270:	4691                	li	a3,4
    80004272:	6609                	lui	a2,0x2
    80004274:	964e                	add	a2,a2,s3
    80004276:	85ce                	mv	a1,s3
    80004278:	855a                	mv	a0,s6
    8000427a:	ffffc097          	auipc	ra,0xffffc
    8000427e:	698080e7          	jalr	1688(ra) # 80000912 <uvmalloc>
    80004282:	892a                	mv	s2,a0
    80004284:	e0a43423          	sd	a0,-504(s0)
    80004288:	e509                	bnez	a0,80004292 <exec+0x236>
  if(pagetable)
    8000428a:	e1343423          	sd	s3,-504(s0)
    8000428e:	4a01                	li	s4,0
    80004290:	aa1d                	j	800043c6 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004292:	75f9                	lui	a1,0xffffe
    80004294:	95aa                	add	a1,a1,a0
    80004296:	855a                	mv	a0,s6
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	8a4080e7          	jalr	-1884(ra) # 80000b3c <uvmclear>
  stackbase = sp - PGSIZE;
    800042a0:	7bfd                	lui	s7,0xfffff
    800042a2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800042a4:	e0043783          	ld	a5,-512(s0)
    800042a8:	6388                	ld	a0,0(a5)
    800042aa:	c52d                	beqz	a0,80004314 <exec+0x2b8>
    800042ac:	e9040993          	addi	s3,s0,-368
    800042b0:	f9040c13          	addi	s8,s0,-112
    800042b4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042b6:	ffffc097          	auipc	ra,0xffffc
    800042ba:	03e080e7          	jalr	62(ra) # 800002f4 <strlen>
    800042be:	0015079b          	addiw	a5,a0,1
    800042c2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042c6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042ca:	13796563          	bltu	s2,s7,800043f4 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ce:	e0043d03          	ld	s10,-512(s0)
    800042d2:	000d3a03          	ld	s4,0(s10)
    800042d6:	8552                	mv	a0,s4
    800042d8:	ffffc097          	auipc	ra,0xffffc
    800042dc:	01c080e7          	jalr	28(ra) # 800002f4 <strlen>
    800042e0:	0015069b          	addiw	a3,a0,1
    800042e4:	8652                	mv	a2,s4
    800042e6:	85ca                	mv	a1,s2
    800042e8:	855a                	mv	a0,s6
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	884080e7          	jalr	-1916(ra) # 80000b6e <copyout>
    800042f2:	10054363          	bltz	a0,800043f8 <exec+0x39c>
    ustack[argc] = sp;
    800042f6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042fa:	0485                	addi	s1,s1,1
    800042fc:	008d0793          	addi	a5,s10,8
    80004300:	e0f43023          	sd	a5,-512(s0)
    80004304:	008d3503          	ld	a0,8(s10)
    80004308:	c909                	beqz	a0,8000431a <exec+0x2be>
    if(argc >= MAXARG)
    8000430a:	09a1                	addi	s3,s3,8
    8000430c:	fb8995e3          	bne	s3,s8,800042b6 <exec+0x25a>
  ip = 0;
    80004310:	4a01                	li	s4,0
    80004312:	a855                	j	800043c6 <exec+0x36a>
  sp = sz;
    80004314:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004318:	4481                	li	s1,0
  ustack[argc] = 0;
    8000431a:	00349793          	slli	a5,s1,0x3
    8000431e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdbc10>
    80004322:	97a2                	add	a5,a5,s0
    80004324:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004328:	00148693          	addi	a3,s1,1
    8000432c:	068e                	slli	a3,a3,0x3
    8000432e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004332:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004336:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000433a:	f57968e3          	bltu	s2,s7,8000428a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000433e:	e9040613          	addi	a2,s0,-368
    80004342:	85ca                	mv	a1,s2
    80004344:	855a                	mv	a0,s6
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	828080e7          	jalr	-2008(ra) # 80000b6e <copyout>
    8000434e:	0a054763          	bltz	a0,800043fc <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004352:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004356:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000435a:	df843783          	ld	a5,-520(s0)
    8000435e:	0007c703          	lbu	a4,0(a5)
    80004362:	cf11                	beqz	a4,8000437e <exec+0x322>
    80004364:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004366:	02f00693          	li	a3,47
    8000436a:	a039                	j	80004378 <exec+0x31c>
      last = s+1;
    8000436c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004370:	0785                	addi	a5,a5,1
    80004372:	fff7c703          	lbu	a4,-1(a5)
    80004376:	c701                	beqz	a4,8000437e <exec+0x322>
    if(*s == '/')
    80004378:	fed71ce3          	bne	a4,a3,80004370 <exec+0x314>
    8000437c:	bfc5                	j	8000436c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000437e:	4641                	li	a2,16
    80004380:	df843583          	ld	a1,-520(s0)
    80004384:	158a8513          	addi	a0,s5,344
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	f3a080e7          	jalr	-198(ra) # 800002c2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004390:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004394:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004398:	e0843783          	ld	a5,-504(s0)
    8000439c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043a0:	058ab783          	ld	a5,88(s5)
    800043a4:	e6843703          	ld	a4,-408(s0)
    800043a8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043aa:	058ab783          	ld	a5,88(s5)
    800043ae:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043b2:	85e6                	mv	a1,s9
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	c56080e7          	jalr	-938(ra) # 8000100a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043bc:	0004851b          	sext.w	a0,s1
    800043c0:	bb15                	j	800040f4 <exec+0x98>
    800043c2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043c6:	e0843583          	ld	a1,-504(s0)
    800043ca:	855a                	mv	a0,s6
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	c3e080e7          	jalr	-962(ra) # 8000100a <proc_freepagetable>
  return -1;
    800043d4:	557d                	li	a0,-1
  if(ip){
    800043d6:	d00a0fe3          	beqz	s4,800040f4 <exec+0x98>
    800043da:	b319                	j	800040e0 <exec+0x84>
    800043dc:	e1243423          	sd	s2,-504(s0)
    800043e0:	b7dd                	j	800043c6 <exec+0x36a>
    800043e2:	e1243423          	sd	s2,-504(s0)
    800043e6:	b7c5                	j	800043c6 <exec+0x36a>
    800043e8:	e1243423          	sd	s2,-504(s0)
    800043ec:	bfe9                	j	800043c6 <exec+0x36a>
    800043ee:	e1243423          	sd	s2,-504(s0)
    800043f2:	bfd1                	j	800043c6 <exec+0x36a>
  ip = 0;
    800043f4:	4a01                	li	s4,0
    800043f6:	bfc1                	j	800043c6 <exec+0x36a>
    800043f8:	4a01                	li	s4,0
  if(pagetable)
    800043fa:	b7f1                	j	800043c6 <exec+0x36a>
  sz = sz1;
    800043fc:	e0843983          	ld	s3,-504(s0)
    80004400:	b569                	j	8000428a <exec+0x22e>

0000000080004402 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004402:	7179                	addi	sp,sp,-48
    80004404:	f406                	sd	ra,40(sp)
    80004406:	f022                	sd	s0,32(sp)
    80004408:	ec26                	sd	s1,24(sp)
    8000440a:	e84a                	sd	s2,16(sp)
    8000440c:	1800                	addi	s0,sp,48
    8000440e:	892e                	mv	s2,a1
    80004410:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004412:	fdc40593          	addi	a1,s0,-36
    80004416:	ffffe097          	auipc	ra,0xffffe
    8000441a:	bc0080e7          	jalr	-1088(ra) # 80001fd6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000441e:	fdc42703          	lw	a4,-36(s0)
    80004422:	47bd                	li	a5,15
    80004424:	02e7eb63          	bltu	a5,a4,8000445a <argfd+0x58>
    80004428:	ffffd097          	auipc	ra,0xffffd
    8000442c:	a82080e7          	jalr	-1406(ra) # 80000eaa <myproc>
    80004430:	fdc42703          	lw	a4,-36(s0)
    80004434:	01a70793          	addi	a5,a4,26
    80004438:	078e                	slli	a5,a5,0x3
    8000443a:	953e                	add	a0,a0,a5
    8000443c:	611c                	ld	a5,0(a0)
    8000443e:	c385                	beqz	a5,8000445e <argfd+0x5c>
    return -1;
  if(pfd)
    80004440:	00090463          	beqz	s2,80004448 <argfd+0x46>
    *pfd = fd;
    80004444:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004448:	4501                	li	a0,0
  if(pf)
    8000444a:	c091                	beqz	s1,8000444e <argfd+0x4c>
    *pf = f;
    8000444c:	e09c                	sd	a5,0(s1)
}
    8000444e:	70a2                	ld	ra,40(sp)
    80004450:	7402                	ld	s0,32(sp)
    80004452:	64e2                	ld	s1,24(sp)
    80004454:	6942                	ld	s2,16(sp)
    80004456:	6145                	addi	sp,sp,48
    80004458:	8082                	ret
    return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	bfcd                	j	8000444e <argfd+0x4c>
    8000445e:	557d                	li	a0,-1
    80004460:	b7fd                	j	8000444e <argfd+0x4c>

0000000080004462 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004462:	1101                	addi	sp,sp,-32
    80004464:	ec06                	sd	ra,24(sp)
    80004466:	e822                	sd	s0,16(sp)
    80004468:	e426                	sd	s1,8(sp)
    8000446a:	1000                	addi	s0,sp,32
    8000446c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	a3c080e7          	jalr	-1476(ra) # 80000eaa <myproc>
    80004476:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004478:	0d050793          	addi	a5,a0,208
    8000447c:	4501                	li	a0,0
    8000447e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004480:	6398                	ld	a4,0(a5)
    80004482:	cb19                	beqz	a4,80004498 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004484:	2505                	addiw	a0,a0,1
    80004486:	07a1                	addi	a5,a5,8
    80004488:	fed51ce3          	bne	a0,a3,80004480 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000448c:	557d                	li	a0,-1
}
    8000448e:	60e2                	ld	ra,24(sp)
    80004490:	6442                	ld	s0,16(sp)
    80004492:	64a2                	ld	s1,8(sp)
    80004494:	6105                	addi	sp,sp,32
    80004496:	8082                	ret
      p->ofile[fd] = f;
    80004498:	01a50793          	addi	a5,a0,26
    8000449c:	078e                	slli	a5,a5,0x3
    8000449e:	963e                	add	a2,a2,a5
    800044a0:	e204                	sd	s1,0(a2)
      return fd;
    800044a2:	b7f5                	j	8000448e <fdalloc+0x2c>

00000000800044a4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044a4:	715d                	addi	sp,sp,-80
    800044a6:	e486                	sd	ra,72(sp)
    800044a8:	e0a2                	sd	s0,64(sp)
    800044aa:	fc26                	sd	s1,56(sp)
    800044ac:	f84a                	sd	s2,48(sp)
    800044ae:	f44e                	sd	s3,40(sp)
    800044b0:	f052                	sd	s4,32(sp)
    800044b2:	ec56                	sd	s5,24(sp)
    800044b4:	e85a                	sd	s6,16(sp)
    800044b6:	0880                	addi	s0,sp,80
    800044b8:	8b2e                	mv	s6,a1
    800044ba:	89b2                	mv	s3,a2
    800044bc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044be:	fb040593          	addi	a1,s0,-80
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	e48080e7          	jalr	-440(ra) # 8000330a <nameiparent>
    800044ca:	84aa                	mv	s1,a0
    800044cc:	14050b63          	beqz	a0,80004622 <create+0x17e>
    return 0;

  ilock(dp);
    800044d0:	ffffe097          	auipc	ra,0xffffe
    800044d4:	676080e7          	jalr	1654(ra) # 80002b46 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044d8:	4601                	li	a2,0
    800044da:	fb040593          	addi	a1,s0,-80
    800044de:	8526                	mv	a0,s1
    800044e0:	fffff097          	auipc	ra,0xfffff
    800044e4:	b4a080e7          	jalr	-1206(ra) # 8000302a <dirlookup>
    800044e8:	8aaa                	mv	s5,a0
    800044ea:	c921                	beqz	a0,8000453a <create+0x96>
    iunlockput(dp);
    800044ec:	8526                	mv	a0,s1
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	8ba080e7          	jalr	-1862(ra) # 80002da8 <iunlockput>
    ilock(ip);
    800044f6:	8556                	mv	a0,s5
    800044f8:	ffffe097          	auipc	ra,0xffffe
    800044fc:	64e080e7          	jalr	1614(ra) # 80002b46 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004500:	4789                	li	a5,2
    80004502:	02fb1563          	bne	s6,a5,8000452c <create+0x88>
    80004506:	044ad783          	lhu	a5,68(s5)
    8000450a:	37f9                	addiw	a5,a5,-2
    8000450c:	17c2                	slli	a5,a5,0x30
    8000450e:	93c1                	srli	a5,a5,0x30
    80004510:	4705                	li	a4,1
    80004512:	00f76d63          	bltu	a4,a5,8000452c <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004516:	8556                	mv	a0,s5
    80004518:	60a6                	ld	ra,72(sp)
    8000451a:	6406                	ld	s0,64(sp)
    8000451c:	74e2                	ld	s1,56(sp)
    8000451e:	7942                	ld	s2,48(sp)
    80004520:	79a2                	ld	s3,40(sp)
    80004522:	7a02                	ld	s4,32(sp)
    80004524:	6ae2                	ld	s5,24(sp)
    80004526:	6b42                	ld	s6,16(sp)
    80004528:	6161                	addi	sp,sp,80
    8000452a:	8082                	ret
    iunlockput(ip);
    8000452c:	8556                	mv	a0,s5
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	87a080e7          	jalr	-1926(ra) # 80002da8 <iunlockput>
    return 0;
    80004536:	4a81                	li	s5,0
    80004538:	bff9                	j	80004516 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000453a:	85da                	mv	a1,s6
    8000453c:	4088                	lw	a0,0(s1)
    8000453e:	ffffe097          	auipc	ra,0xffffe
    80004542:	470080e7          	jalr	1136(ra) # 800029ae <ialloc>
    80004546:	8a2a                	mv	s4,a0
    80004548:	c529                	beqz	a0,80004592 <create+0xee>
  ilock(ip);
    8000454a:	ffffe097          	auipc	ra,0xffffe
    8000454e:	5fc080e7          	jalr	1532(ra) # 80002b46 <ilock>
  ip->major = major;
    80004552:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004556:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000455a:	4905                	li	s2,1
    8000455c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004560:	8552                	mv	a0,s4
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	518080e7          	jalr	1304(ra) # 80002a7a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000456a:	032b0b63          	beq	s6,s2,800045a0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000456e:	004a2603          	lw	a2,4(s4)
    80004572:	fb040593          	addi	a1,s0,-80
    80004576:	8526                	mv	a0,s1
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	cc2080e7          	jalr	-830(ra) # 8000323a <dirlink>
    80004580:	06054f63          	bltz	a0,800045fe <create+0x15a>
  iunlockput(dp);
    80004584:	8526                	mv	a0,s1
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	822080e7          	jalr	-2014(ra) # 80002da8 <iunlockput>
  return ip;
    8000458e:	8ad2                	mv	s5,s4
    80004590:	b759                	j	80004516 <create+0x72>
    iunlockput(dp);
    80004592:	8526                	mv	a0,s1
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	814080e7          	jalr	-2028(ra) # 80002da8 <iunlockput>
    return 0;
    8000459c:	8ad2                	mv	s5,s4
    8000459e:	bfa5                	j	80004516 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045a0:	004a2603          	lw	a2,4(s4)
    800045a4:	00005597          	auipc	a1,0x5
    800045a8:	11c58593          	addi	a1,a1,284 # 800096c0 <syscalls+0x2e0>
    800045ac:	8552                	mv	a0,s4
    800045ae:	fffff097          	auipc	ra,0xfffff
    800045b2:	c8c080e7          	jalr	-884(ra) # 8000323a <dirlink>
    800045b6:	04054463          	bltz	a0,800045fe <create+0x15a>
    800045ba:	40d0                	lw	a2,4(s1)
    800045bc:	00005597          	auipc	a1,0x5
    800045c0:	10c58593          	addi	a1,a1,268 # 800096c8 <syscalls+0x2e8>
    800045c4:	8552                	mv	a0,s4
    800045c6:	fffff097          	auipc	ra,0xfffff
    800045ca:	c74080e7          	jalr	-908(ra) # 8000323a <dirlink>
    800045ce:	02054863          	bltz	a0,800045fe <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d2:	004a2603          	lw	a2,4(s4)
    800045d6:	fb040593          	addi	a1,s0,-80
    800045da:	8526                	mv	a0,s1
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	c5e080e7          	jalr	-930(ra) # 8000323a <dirlink>
    800045e4:	00054d63          	bltz	a0,800045fe <create+0x15a>
    dp->nlink++;  // for ".."
    800045e8:	04a4d783          	lhu	a5,74(s1)
    800045ec:	2785                	addiw	a5,a5,1
    800045ee:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045f2:	8526                	mv	a0,s1
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	486080e7          	jalr	1158(ra) # 80002a7a <iupdate>
    800045fc:	b761                	j	80004584 <create+0xe0>
  ip->nlink = 0;
    800045fe:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004602:	8552                	mv	a0,s4
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	476080e7          	jalr	1142(ra) # 80002a7a <iupdate>
  iunlockput(ip);
    8000460c:	8552                	mv	a0,s4
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	79a080e7          	jalr	1946(ra) # 80002da8 <iunlockput>
  iunlockput(dp);
    80004616:	8526                	mv	a0,s1
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	790080e7          	jalr	1936(ra) # 80002da8 <iunlockput>
  return 0;
    80004620:	bddd                	j	80004516 <create+0x72>
    return 0;
    80004622:	8aaa                	mv	s5,a0
    80004624:	bdcd                	j	80004516 <create+0x72>

0000000080004626 <sys_dup>:
{
    80004626:	7179                	addi	sp,sp,-48
    80004628:	f406                	sd	ra,40(sp)
    8000462a:	f022                	sd	s0,32(sp)
    8000462c:	ec26                	sd	s1,24(sp)
    8000462e:	e84a                	sd	s2,16(sp)
    80004630:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004632:	fd840613          	addi	a2,s0,-40
    80004636:	4581                	li	a1,0
    80004638:	4501                	li	a0,0
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	dc8080e7          	jalr	-568(ra) # 80004402 <argfd>
    return -1;
    80004642:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004644:	02054363          	bltz	a0,8000466a <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004648:	fd843903          	ld	s2,-40(s0)
    8000464c:	854a                	mv	a0,s2
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	e14080e7          	jalr	-492(ra) # 80004462 <fdalloc>
    80004656:	84aa                	mv	s1,a0
    return -1;
    80004658:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000465a:	00054863          	bltz	a0,8000466a <sys_dup+0x44>
  filedup(f);
    8000465e:	854a                	mv	a0,s2
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	2fe080e7          	jalr	766(ra) # 8000395e <filedup>
  return fd;
    80004668:	87a6                	mv	a5,s1
}
    8000466a:	853e                	mv	a0,a5
    8000466c:	70a2                	ld	ra,40(sp)
    8000466e:	7402                	ld	s0,32(sp)
    80004670:	64e2                	ld	s1,24(sp)
    80004672:	6942                	ld	s2,16(sp)
    80004674:	6145                	addi	sp,sp,48
    80004676:	8082                	ret

0000000080004678 <sys_read>:
{
    80004678:	7179                	addi	sp,sp,-48
    8000467a:	f406                	sd	ra,40(sp)
    8000467c:	f022                	sd	s0,32(sp)
    8000467e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004680:	fd840593          	addi	a1,s0,-40
    80004684:	4505                	li	a0,1
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	970080e7          	jalr	-1680(ra) # 80001ff6 <argaddr>
  argint(2, &n);
    8000468e:	fe440593          	addi	a1,s0,-28
    80004692:	4509                	li	a0,2
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	942080e7          	jalr	-1726(ra) # 80001fd6 <argint>
  if(argfd(0, 0, &f) < 0)
    8000469c:	fe840613          	addi	a2,s0,-24
    800046a0:	4581                	li	a1,0
    800046a2:	4501                	li	a0,0
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	d5e080e7          	jalr	-674(ra) # 80004402 <argfd>
    800046ac:	87aa                	mv	a5,a0
    return -1;
    800046ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046b0:	0007cc63          	bltz	a5,800046c8 <sys_read+0x50>
  return fileread(f, p, n);
    800046b4:	fe442603          	lw	a2,-28(s0)
    800046b8:	fd843583          	ld	a1,-40(s0)
    800046bc:	fe843503          	ld	a0,-24(s0)
    800046c0:	fffff097          	auipc	ra,0xfffff
    800046c4:	446080e7          	jalr	1094(ra) # 80003b06 <fileread>
}
    800046c8:	70a2                	ld	ra,40(sp)
    800046ca:	7402                	ld	s0,32(sp)
    800046cc:	6145                	addi	sp,sp,48
    800046ce:	8082                	ret

00000000800046d0 <sys_write>:
{
    800046d0:	7179                	addi	sp,sp,-48
    800046d2:	f406                	sd	ra,40(sp)
    800046d4:	f022                	sd	s0,32(sp)
    800046d6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046d8:	fd840593          	addi	a1,s0,-40
    800046dc:	4505                	li	a0,1
    800046de:	ffffe097          	auipc	ra,0xffffe
    800046e2:	918080e7          	jalr	-1768(ra) # 80001ff6 <argaddr>
  argint(2, &n);
    800046e6:	fe440593          	addi	a1,s0,-28
    800046ea:	4509                	li	a0,2
    800046ec:	ffffe097          	auipc	ra,0xffffe
    800046f0:	8ea080e7          	jalr	-1814(ra) # 80001fd6 <argint>
  if(argfd(0, 0, &f) < 0)
    800046f4:	fe840613          	addi	a2,s0,-24
    800046f8:	4581                	li	a1,0
    800046fa:	4501                	li	a0,0
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	d06080e7          	jalr	-762(ra) # 80004402 <argfd>
    80004704:	87aa                	mv	a5,a0
    return -1;
    80004706:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004708:	0007cc63          	bltz	a5,80004720 <sys_write+0x50>
  return filewrite(f, p, n);
    8000470c:	fe442603          	lw	a2,-28(s0)
    80004710:	fd843583          	ld	a1,-40(s0)
    80004714:	fe843503          	ld	a0,-24(s0)
    80004718:	fffff097          	auipc	ra,0xfffff
    8000471c:	4c4080e7          	jalr	1220(ra) # 80003bdc <filewrite>
}
    80004720:	70a2                	ld	ra,40(sp)
    80004722:	7402                	ld	s0,32(sp)
    80004724:	6145                	addi	sp,sp,48
    80004726:	8082                	ret

0000000080004728 <sys_close>:
{
    80004728:	1101                	addi	sp,sp,-32
    8000472a:	ec06                	sd	ra,24(sp)
    8000472c:	e822                	sd	s0,16(sp)
    8000472e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004730:	fe040613          	addi	a2,s0,-32
    80004734:	fec40593          	addi	a1,s0,-20
    80004738:	4501                	li	a0,0
    8000473a:	00000097          	auipc	ra,0x0
    8000473e:	cc8080e7          	jalr	-824(ra) # 80004402 <argfd>
    return -1;
    80004742:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004744:	02054463          	bltz	a0,8000476c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004748:	ffffc097          	auipc	ra,0xffffc
    8000474c:	762080e7          	jalr	1890(ra) # 80000eaa <myproc>
    80004750:	fec42783          	lw	a5,-20(s0)
    80004754:	07e9                	addi	a5,a5,26
    80004756:	078e                	slli	a5,a5,0x3
    80004758:	953e                	add	a0,a0,a5
    8000475a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000475e:	fe043503          	ld	a0,-32(s0)
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	24e080e7          	jalr	590(ra) # 800039b0 <fileclose>
  return 0;
    8000476a:	4781                	li	a5,0
}
    8000476c:	853e                	mv	a0,a5
    8000476e:	60e2                	ld	ra,24(sp)
    80004770:	6442                	ld	s0,16(sp)
    80004772:	6105                	addi	sp,sp,32
    80004774:	8082                	ret

0000000080004776 <sys_fstat>:
{
    80004776:	1101                	addi	sp,sp,-32
    80004778:	ec06                	sd	ra,24(sp)
    8000477a:	e822                	sd	s0,16(sp)
    8000477c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000477e:	fe040593          	addi	a1,s0,-32
    80004782:	4505                	li	a0,1
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	872080e7          	jalr	-1934(ra) # 80001ff6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000478c:	fe840613          	addi	a2,s0,-24
    80004790:	4581                	li	a1,0
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	c6e080e7          	jalr	-914(ra) # 80004402 <argfd>
    8000479c:	87aa                	mv	a5,a0
    return -1;
    8000479e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047a0:	0007ca63          	bltz	a5,800047b4 <sys_fstat+0x3e>
  return filestat(f, st);
    800047a4:	fe043583          	ld	a1,-32(s0)
    800047a8:	fe843503          	ld	a0,-24(s0)
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	2e8080e7          	jalr	744(ra) # 80003a94 <filestat>
}
    800047b4:	60e2                	ld	ra,24(sp)
    800047b6:	6442                	ld	s0,16(sp)
    800047b8:	6105                	addi	sp,sp,32
    800047ba:	8082                	ret

00000000800047bc <sys_link>:
{
    800047bc:	7169                	addi	sp,sp,-304
    800047be:	f606                	sd	ra,296(sp)
    800047c0:	f222                	sd	s0,288(sp)
    800047c2:	ee26                	sd	s1,280(sp)
    800047c4:	ea4a                	sd	s2,272(sp)
    800047c6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c8:	08000613          	li	a2,128
    800047cc:	ed040593          	addi	a1,s0,-304
    800047d0:	4501                	li	a0,0
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	844080e7          	jalr	-1980(ra) # 80002016 <argstr>
    return -1;
    800047da:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047dc:	10054e63          	bltz	a0,800048f8 <sys_link+0x13c>
    800047e0:	08000613          	li	a2,128
    800047e4:	f5040593          	addi	a1,s0,-176
    800047e8:	4505                	li	a0,1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	82c080e7          	jalr	-2004(ra) # 80002016 <argstr>
    return -1;
    800047f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f4:	10054263          	bltz	a0,800048f8 <sys_link+0x13c>
  begin_op();
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	cf4080e7          	jalr	-780(ra) # 800034ec <begin_op>
  if((ip = namei(old)) == 0){
    80004800:	ed040513          	addi	a0,s0,-304
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	ae8080e7          	jalr	-1304(ra) # 800032ec <namei>
    8000480c:	84aa                	mv	s1,a0
    8000480e:	c551                	beqz	a0,8000489a <sys_link+0xde>
  ilock(ip);
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	336080e7          	jalr	822(ra) # 80002b46 <ilock>
  if(ip->type == T_DIR){
    80004818:	04449703          	lh	a4,68(s1)
    8000481c:	4785                	li	a5,1
    8000481e:	08f70463          	beq	a4,a5,800048a6 <sys_link+0xea>
  ip->nlink++;
    80004822:	04a4d783          	lhu	a5,74(s1)
    80004826:	2785                	addiw	a5,a5,1
    80004828:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000482c:	8526                	mv	a0,s1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	24c080e7          	jalr	588(ra) # 80002a7a <iupdate>
  iunlock(ip);
    80004836:	8526                	mv	a0,s1
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	3d0080e7          	jalr	976(ra) # 80002c08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004840:	fd040593          	addi	a1,s0,-48
    80004844:	f5040513          	addi	a0,s0,-176
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	ac2080e7          	jalr	-1342(ra) # 8000330a <nameiparent>
    80004850:	892a                	mv	s2,a0
    80004852:	c935                	beqz	a0,800048c6 <sys_link+0x10a>
  ilock(dp);
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	2f2080e7          	jalr	754(ra) # 80002b46 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000485c:	00092703          	lw	a4,0(s2)
    80004860:	409c                	lw	a5,0(s1)
    80004862:	04f71d63          	bne	a4,a5,800048bc <sys_link+0x100>
    80004866:	40d0                	lw	a2,4(s1)
    80004868:	fd040593          	addi	a1,s0,-48
    8000486c:	854a                	mv	a0,s2
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	9cc080e7          	jalr	-1588(ra) # 8000323a <dirlink>
    80004876:	04054363          	bltz	a0,800048bc <sys_link+0x100>
  iunlockput(dp);
    8000487a:	854a                	mv	a0,s2
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	52c080e7          	jalr	1324(ra) # 80002da8 <iunlockput>
  iput(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	47a080e7          	jalr	1146(ra) # 80002d00 <iput>
  end_op();
    8000488e:	fffff097          	auipc	ra,0xfffff
    80004892:	cd8080e7          	jalr	-808(ra) # 80003566 <end_op>
  return 0;
    80004896:	4781                	li	a5,0
    80004898:	a085                	j	800048f8 <sys_link+0x13c>
    end_op();
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	ccc080e7          	jalr	-820(ra) # 80003566 <end_op>
    return -1;
    800048a2:	57fd                	li	a5,-1
    800048a4:	a891                	j	800048f8 <sys_link+0x13c>
    iunlockput(ip);
    800048a6:	8526                	mv	a0,s1
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	500080e7          	jalr	1280(ra) # 80002da8 <iunlockput>
    end_op();
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	cb6080e7          	jalr	-842(ra) # 80003566 <end_op>
    return -1;
    800048b8:	57fd                	li	a5,-1
    800048ba:	a83d                	j	800048f8 <sys_link+0x13c>
    iunlockput(dp);
    800048bc:	854a                	mv	a0,s2
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	4ea080e7          	jalr	1258(ra) # 80002da8 <iunlockput>
  ilock(ip);
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	27e080e7          	jalr	638(ra) # 80002b46 <ilock>
  ip->nlink--;
    800048d0:	04a4d783          	lhu	a5,74(s1)
    800048d4:	37fd                	addiw	a5,a5,-1
    800048d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	19e080e7          	jalr	414(ra) # 80002a7a <iupdate>
  iunlockput(ip);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	4c2080e7          	jalr	1218(ra) # 80002da8 <iunlockput>
  end_op();
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	c78080e7          	jalr	-904(ra) # 80003566 <end_op>
  return -1;
    800048f6:	57fd                	li	a5,-1
}
    800048f8:	853e                	mv	a0,a5
    800048fa:	70b2                	ld	ra,296(sp)
    800048fc:	7412                	ld	s0,288(sp)
    800048fe:	64f2                	ld	s1,280(sp)
    80004900:	6952                	ld	s2,272(sp)
    80004902:	6155                	addi	sp,sp,304
    80004904:	8082                	ret

0000000080004906 <sys_unlink>:
{
    80004906:	7151                	addi	sp,sp,-240
    80004908:	f586                	sd	ra,232(sp)
    8000490a:	f1a2                	sd	s0,224(sp)
    8000490c:	eda6                	sd	s1,216(sp)
    8000490e:	e9ca                	sd	s2,208(sp)
    80004910:	e5ce                	sd	s3,200(sp)
    80004912:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004914:	08000613          	li	a2,128
    80004918:	f3040593          	addi	a1,s0,-208
    8000491c:	4501                	li	a0,0
    8000491e:	ffffd097          	auipc	ra,0xffffd
    80004922:	6f8080e7          	jalr	1784(ra) # 80002016 <argstr>
    80004926:	18054163          	bltz	a0,80004aa8 <sys_unlink+0x1a2>
  begin_op();
    8000492a:	fffff097          	auipc	ra,0xfffff
    8000492e:	bc2080e7          	jalr	-1086(ra) # 800034ec <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004932:	fb040593          	addi	a1,s0,-80
    80004936:	f3040513          	addi	a0,s0,-208
    8000493a:	fffff097          	auipc	ra,0xfffff
    8000493e:	9d0080e7          	jalr	-1584(ra) # 8000330a <nameiparent>
    80004942:	84aa                	mv	s1,a0
    80004944:	c979                	beqz	a0,80004a1a <sys_unlink+0x114>
  ilock(dp);
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	200080e7          	jalr	512(ra) # 80002b46 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000494e:	00005597          	auipc	a1,0x5
    80004952:	d7258593          	addi	a1,a1,-654 # 800096c0 <syscalls+0x2e0>
    80004956:	fb040513          	addi	a0,s0,-80
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	6b6080e7          	jalr	1718(ra) # 80003010 <namecmp>
    80004962:	14050a63          	beqz	a0,80004ab6 <sys_unlink+0x1b0>
    80004966:	00005597          	auipc	a1,0x5
    8000496a:	d6258593          	addi	a1,a1,-670 # 800096c8 <syscalls+0x2e8>
    8000496e:	fb040513          	addi	a0,s0,-80
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	69e080e7          	jalr	1694(ra) # 80003010 <namecmp>
    8000497a:	12050e63          	beqz	a0,80004ab6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000497e:	f2c40613          	addi	a2,s0,-212
    80004982:	fb040593          	addi	a1,s0,-80
    80004986:	8526                	mv	a0,s1
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	6a2080e7          	jalr	1698(ra) # 8000302a <dirlookup>
    80004990:	892a                	mv	s2,a0
    80004992:	12050263          	beqz	a0,80004ab6 <sys_unlink+0x1b0>
  ilock(ip);
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	1b0080e7          	jalr	432(ra) # 80002b46 <ilock>
  if(ip->nlink < 1)
    8000499e:	04a91783          	lh	a5,74(s2)
    800049a2:	08f05263          	blez	a5,80004a26 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049a6:	04491703          	lh	a4,68(s2)
    800049aa:	4785                	li	a5,1
    800049ac:	08f70563          	beq	a4,a5,80004a36 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049b0:	4641                	li	a2,16
    800049b2:	4581                	li	a1,0
    800049b4:	fc040513          	addi	a0,s0,-64
    800049b8:	ffffb097          	auipc	ra,0xffffb
    800049bc:	7c2080e7          	jalr	1986(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049c0:	4741                	li	a4,16
    800049c2:	f2c42683          	lw	a3,-212(s0)
    800049c6:	fc040613          	addi	a2,s0,-64
    800049ca:	4581                	li	a1,0
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	524080e7          	jalr	1316(ra) # 80002ef2 <writei>
    800049d6:	47c1                	li	a5,16
    800049d8:	0af51563          	bne	a0,a5,80004a82 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049dc:	04491703          	lh	a4,68(s2)
    800049e0:	4785                	li	a5,1
    800049e2:	0af70863          	beq	a4,a5,80004a92 <sys_unlink+0x18c>
  iunlockput(dp);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	3c0080e7          	jalr	960(ra) # 80002da8 <iunlockput>
  ip->nlink--;
    800049f0:	04a95783          	lhu	a5,74(s2)
    800049f4:	37fd                	addiw	a5,a5,-1
    800049f6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049fa:	854a                	mv	a0,s2
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	07e080e7          	jalr	126(ra) # 80002a7a <iupdate>
  iunlockput(ip);
    80004a04:	854a                	mv	a0,s2
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	3a2080e7          	jalr	930(ra) # 80002da8 <iunlockput>
  end_op();
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	b58080e7          	jalr	-1192(ra) # 80003566 <end_op>
  return 0;
    80004a16:	4501                	li	a0,0
    80004a18:	a84d                	j	80004aca <sys_unlink+0x1c4>
    end_op();
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	b4c080e7          	jalr	-1204(ra) # 80003566 <end_op>
    return -1;
    80004a22:	557d                	li	a0,-1
    80004a24:	a05d                	j	80004aca <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a26:	00005517          	auipc	a0,0x5
    80004a2a:	caa50513          	addi	a0,a0,-854 # 800096d0 <syscalls+0x2f0>
    80004a2e:	00002097          	auipc	ra,0x2
    80004a32:	fbc080e7          	jalr	-68(ra) # 800069ea <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a36:	04c92703          	lw	a4,76(s2)
    80004a3a:	02000793          	li	a5,32
    80004a3e:	f6e7f9e3          	bgeu	a5,a4,800049b0 <sys_unlink+0xaa>
    80004a42:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a46:	4741                	li	a4,16
    80004a48:	86ce                	mv	a3,s3
    80004a4a:	f1840613          	addi	a2,s0,-232
    80004a4e:	4581                	li	a1,0
    80004a50:	854a                	mv	a0,s2
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	3a8080e7          	jalr	936(ra) # 80002dfa <readi>
    80004a5a:	47c1                	li	a5,16
    80004a5c:	00f51b63          	bne	a0,a5,80004a72 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a60:	f1845783          	lhu	a5,-232(s0)
    80004a64:	e7a1                	bnez	a5,80004aac <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a66:	29c1                	addiw	s3,s3,16
    80004a68:	04c92783          	lw	a5,76(s2)
    80004a6c:	fcf9ede3          	bltu	s3,a5,80004a46 <sys_unlink+0x140>
    80004a70:	b781                	j	800049b0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a72:	00005517          	auipc	a0,0x5
    80004a76:	c7650513          	addi	a0,a0,-906 # 800096e8 <syscalls+0x308>
    80004a7a:	00002097          	auipc	ra,0x2
    80004a7e:	f70080e7          	jalr	-144(ra) # 800069ea <panic>
    panic("unlink: writei");
    80004a82:	00005517          	auipc	a0,0x5
    80004a86:	c7e50513          	addi	a0,a0,-898 # 80009700 <syscalls+0x320>
    80004a8a:	00002097          	auipc	ra,0x2
    80004a8e:	f60080e7          	jalr	-160(ra) # 800069ea <panic>
    dp->nlink--;
    80004a92:	04a4d783          	lhu	a5,74(s1)
    80004a96:	37fd                	addiw	a5,a5,-1
    80004a98:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	fdc080e7          	jalr	-36(ra) # 80002a7a <iupdate>
    80004aa6:	b781                	j	800049e6 <sys_unlink+0xe0>
    return -1;
    80004aa8:	557d                	li	a0,-1
    80004aaa:	a005                	j	80004aca <sys_unlink+0x1c4>
    iunlockput(ip);
    80004aac:	854a                	mv	a0,s2
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	2fa080e7          	jalr	762(ra) # 80002da8 <iunlockput>
  iunlockput(dp);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	2f0080e7          	jalr	752(ra) # 80002da8 <iunlockput>
  end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	aa6080e7          	jalr	-1370(ra) # 80003566 <end_op>
  return -1;
    80004ac8:	557d                	li	a0,-1
}
    80004aca:	70ae                	ld	ra,232(sp)
    80004acc:	740e                	ld	s0,224(sp)
    80004ace:	64ee                	ld	s1,216(sp)
    80004ad0:	694e                	ld	s2,208(sp)
    80004ad2:	69ae                	ld	s3,200(sp)
    80004ad4:	616d                	addi	sp,sp,240
    80004ad6:	8082                	ret

0000000080004ad8 <sys_open>:

uint64
sys_open(void)
{
    80004ad8:	7131                	addi	sp,sp,-192
    80004ada:	fd06                	sd	ra,184(sp)
    80004adc:	f922                	sd	s0,176(sp)
    80004ade:	f526                	sd	s1,168(sp)
    80004ae0:	f14a                	sd	s2,160(sp)
    80004ae2:	ed4e                	sd	s3,152(sp)
    80004ae4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ae6:	f4c40593          	addi	a1,s0,-180
    80004aea:	4505                	li	a0,1
    80004aec:	ffffd097          	auipc	ra,0xffffd
    80004af0:	4ea080e7          	jalr	1258(ra) # 80001fd6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004af4:	08000613          	li	a2,128
    80004af8:	f5040593          	addi	a1,s0,-176
    80004afc:	4501                	li	a0,0
    80004afe:	ffffd097          	auipc	ra,0xffffd
    80004b02:	518080e7          	jalr	1304(ra) # 80002016 <argstr>
    80004b06:	87aa                	mv	a5,a0
    return -1;
    80004b08:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b0a:	0a07c863          	bltz	a5,80004bba <sys_open+0xe2>

  begin_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	9de080e7          	jalr	-1570(ra) # 800034ec <begin_op>

  if(omode & O_CREATE){
    80004b16:	f4c42783          	lw	a5,-180(s0)
    80004b1a:	2007f793          	andi	a5,a5,512
    80004b1e:	cbdd                	beqz	a5,80004bd4 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004b20:	4681                	li	a3,0
    80004b22:	4601                	li	a2,0
    80004b24:	4589                	li	a1,2
    80004b26:	f5040513          	addi	a0,s0,-176
    80004b2a:	00000097          	auipc	ra,0x0
    80004b2e:	97a080e7          	jalr	-1670(ra) # 800044a4 <create>
    80004b32:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b34:	c951                	beqz	a0,80004bc8 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b36:	04449703          	lh	a4,68(s1)
    80004b3a:	478d                	li	a5,3
    80004b3c:	00f71763          	bne	a4,a5,80004b4a <sys_open+0x72>
    80004b40:	0464d703          	lhu	a4,70(s1)
    80004b44:	47a5                	li	a5,9
    80004b46:	0ce7ec63          	bltu	a5,a4,80004c1e <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	daa080e7          	jalr	-598(ra) # 800038f4 <filealloc>
    80004b52:	892a                	mv	s2,a0
    80004b54:	c56d                	beqz	a0,80004c3e <sys_open+0x166>
    80004b56:	00000097          	auipc	ra,0x0
    80004b5a:	90c080e7          	jalr	-1780(ra) # 80004462 <fdalloc>
    80004b5e:	89aa                	mv	s3,a0
    80004b60:	0c054a63          	bltz	a0,80004c34 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b64:	04449703          	lh	a4,68(s1)
    80004b68:	478d                	li	a5,3
    80004b6a:	0ef70563          	beq	a4,a5,80004c54 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b6e:	4789                	li	a5,2
    80004b70:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004b74:	02092423          	sw	zero,40(s2)
  }
  f->ip = ip;
    80004b78:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004b7c:	f4c42783          	lw	a5,-180(s0)
    80004b80:	0017c713          	xori	a4,a5,1
    80004b84:	8b05                	andi	a4,a4,1
    80004b86:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b8a:	0037f713          	andi	a4,a5,3
    80004b8e:	00e03733          	snez	a4,a4
    80004b92:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b96:	4007f793          	andi	a5,a5,1024
    80004b9a:	c791                	beqz	a5,80004ba6 <sys_open+0xce>
    80004b9c:	04449703          	lh	a4,68(s1)
    80004ba0:	4789                	li	a5,2
    80004ba2:	0cf70063          	beq	a4,a5,80004c62 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	060080e7          	jalr	96(ra) # 80002c08 <iunlock>
  end_op();
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	9b6080e7          	jalr	-1610(ra) # 80003566 <end_op>

  return fd;
    80004bb8:	854e                	mv	a0,s3
}
    80004bba:	70ea                	ld	ra,184(sp)
    80004bbc:	744a                	ld	s0,176(sp)
    80004bbe:	74aa                	ld	s1,168(sp)
    80004bc0:	790a                	ld	s2,160(sp)
    80004bc2:	69ea                	ld	s3,152(sp)
    80004bc4:	6129                	addi	sp,sp,192
    80004bc6:	8082                	ret
      end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	99e080e7          	jalr	-1634(ra) # 80003566 <end_op>
      return -1;
    80004bd0:	557d                	li	a0,-1
    80004bd2:	b7e5                	j	80004bba <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004bd4:	f5040513          	addi	a0,s0,-176
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	714080e7          	jalr	1812(ra) # 800032ec <namei>
    80004be0:	84aa                	mv	s1,a0
    80004be2:	c905                	beqz	a0,80004c12 <sys_open+0x13a>
    ilock(ip);
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	f62080e7          	jalr	-158(ra) # 80002b46 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bec:	04449703          	lh	a4,68(s1)
    80004bf0:	4785                	li	a5,1
    80004bf2:	f4f712e3          	bne	a4,a5,80004b36 <sys_open+0x5e>
    80004bf6:	f4c42783          	lw	a5,-180(s0)
    80004bfa:	dba1                	beqz	a5,80004b4a <sys_open+0x72>
      iunlockput(ip);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	1aa080e7          	jalr	426(ra) # 80002da8 <iunlockput>
      end_op();
    80004c06:	fffff097          	auipc	ra,0xfffff
    80004c0a:	960080e7          	jalr	-1696(ra) # 80003566 <end_op>
      return -1;
    80004c0e:	557d                	li	a0,-1
    80004c10:	b76d                	j	80004bba <sys_open+0xe2>
      end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	954080e7          	jalr	-1708(ra) # 80003566 <end_op>
      return -1;
    80004c1a:	557d                	li	a0,-1
    80004c1c:	bf79                	j	80004bba <sys_open+0xe2>
    iunlockput(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	188080e7          	jalr	392(ra) # 80002da8 <iunlockput>
    end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	93e080e7          	jalr	-1730(ra) # 80003566 <end_op>
    return -1;
    80004c30:	557d                	li	a0,-1
    80004c32:	b761                	j	80004bba <sys_open+0xe2>
      fileclose(f);
    80004c34:	854a                	mv	a0,s2
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	d7a080e7          	jalr	-646(ra) # 800039b0 <fileclose>
    iunlockput(ip);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	168080e7          	jalr	360(ra) # 80002da8 <iunlockput>
    end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	91e080e7          	jalr	-1762(ra) # 80003566 <end_op>
    return -1;
    80004c50:	557d                	li	a0,-1
    80004c52:	b7a5                	j	80004bba <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004c54:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004c58:	04649783          	lh	a5,70(s1)
    80004c5c:	02f91623          	sh	a5,44(s2)
    80004c60:	bf21                	j	80004b78 <sys_open+0xa0>
    itrunc(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	ff0080e7          	jalr	-16(ra) # 80002c54 <itrunc>
    80004c6c:	bf2d                	j	80004ba6 <sys_open+0xce>

0000000080004c6e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c6e:	7175                	addi	sp,sp,-144
    80004c70:	e506                	sd	ra,136(sp)
    80004c72:	e122                	sd	s0,128(sp)
    80004c74:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	876080e7          	jalr	-1930(ra) # 800034ec <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c7e:	08000613          	li	a2,128
    80004c82:	f7040593          	addi	a1,s0,-144
    80004c86:	4501                	li	a0,0
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	38e080e7          	jalr	910(ra) # 80002016 <argstr>
    80004c90:	02054963          	bltz	a0,80004cc2 <sys_mkdir+0x54>
    80004c94:	4681                	li	a3,0
    80004c96:	4601                	li	a2,0
    80004c98:	4585                	li	a1,1
    80004c9a:	f7040513          	addi	a0,s0,-144
    80004c9e:	00000097          	auipc	ra,0x0
    80004ca2:	806080e7          	jalr	-2042(ra) # 800044a4 <create>
    80004ca6:	cd11                	beqz	a0,80004cc2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	100080e7          	jalr	256(ra) # 80002da8 <iunlockput>
  end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	8b6080e7          	jalr	-1866(ra) # 80003566 <end_op>
  return 0;
    80004cb8:	4501                	li	a0,0
}
    80004cba:	60aa                	ld	ra,136(sp)
    80004cbc:	640a                	ld	s0,128(sp)
    80004cbe:	6149                	addi	sp,sp,144
    80004cc0:	8082                	ret
    end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	8a4080e7          	jalr	-1884(ra) # 80003566 <end_op>
    return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	b7fd                	j	80004cba <sys_mkdir+0x4c>

0000000080004cce <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cce:	7135                	addi	sp,sp,-160
    80004cd0:	ed06                	sd	ra,152(sp)
    80004cd2:	e922                	sd	s0,144(sp)
    80004cd4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	816080e7          	jalr	-2026(ra) # 800034ec <begin_op>
  argint(1, &major);
    80004cde:	f6c40593          	addi	a1,s0,-148
    80004ce2:	4505                	li	a0,1
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	2f2080e7          	jalr	754(ra) # 80001fd6 <argint>
  argint(2, &minor);
    80004cec:	f6840593          	addi	a1,s0,-152
    80004cf0:	4509                	li	a0,2
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	2e4080e7          	jalr	740(ra) # 80001fd6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cfa:	08000613          	li	a2,128
    80004cfe:	f7040593          	addi	a1,s0,-144
    80004d02:	4501                	li	a0,0
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	312080e7          	jalr	786(ra) # 80002016 <argstr>
    80004d0c:	02054b63          	bltz	a0,80004d42 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d10:	f6841683          	lh	a3,-152(s0)
    80004d14:	f6c41603          	lh	a2,-148(s0)
    80004d18:	458d                	li	a1,3
    80004d1a:	f7040513          	addi	a0,s0,-144
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	786080e7          	jalr	1926(ra) # 800044a4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d26:	cd11                	beqz	a0,80004d42 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	080080e7          	jalr	128(ra) # 80002da8 <iunlockput>
  end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	836080e7          	jalr	-1994(ra) # 80003566 <end_op>
  return 0;
    80004d38:	4501                	li	a0,0
}
    80004d3a:	60ea                	ld	ra,152(sp)
    80004d3c:	644a                	ld	s0,144(sp)
    80004d3e:	610d                	addi	sp,sp,160
    80004d40:	8082                	ret
    end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	824080e7          	jalr	-2012(ra) # 80003566 <end_op>
    return -1;
    80004d4a:	557d                	li	a0,-1
    80004d4c:	b7fd                	j	80004d3a <sys_mknod+0x6c>

0000000080004d4e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d4e:	7135                	addi	sp,sp,-160
    80004d50:	ed06                	sd	ra,152(sp)
    80004d52:	e922                	sd	s0,144(sp)
    80004d54:	e526                	sd	s1,136(sp)
    80004d56:	e14a                	sd	s2,128(sp)
    80004d58:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d5a:	ffffc097          	auipc	ra,0xffffc
    80004d5e:	150080e7          	jalr	336(ra) # 80000eaa <myproc>
    80004d62:	892a                	mv	s2,a0
  
  begin_op();
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	788080e7          	jalr	1928(ra) # 800034ec <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d6c:	08000613          	li	a2,128
    80004d70:	f6040593          	addi	a1,s0,-160
    80004d74:	4501                	li	a0,0
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	2a0080e7          	jalr	672(ra) # 80002016 <argstr>
    80004d7e:	04054b63          	bltz	a0,80004dd4 <sys_chdir+0x86>
    80004d82:	f6040513          	addi	a0,s0,-160
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	566080e7          	jalr	1382(ra) # 800032ec <namei>
    80004d8e:	84aa                	mv	s1,a0
    80004d90:	c131                	beqz	a0,80004dd4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	db4080e7          	jalr	-588(ra) # 80002b46 <ilock>
  if(ip->type != T_DIR){
    80004d9a:	04449703          	lh	a4,68(s1)
    80004d9e:	4785                	li	a5,1
    80004da0:	04f71063          	bne	a4,a5,80004de0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	e62080e7          	jalr	-414(ra) # 80002c08 <iunlock>
  iput(p->cwd);
    80004dae:	15093503          	ld	a0,336(s2)
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	f4e080e7          	jalr	-178(ra) # 80002d00 <iput>
  end_op();
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	7ac080e7          	jalr	1964(ra) # 80003566 <end_op>
  p->cwd = ip;
    80004dc2:	14993823          	sd	s1,336(s2)
  return 0;
    80004dc6:	4501                	li	a0,0
}
    80004dc8:	60ea                	ld	ra,152(sp)
    80004dca:	644a                	ld	s0,144(sp)
    80004dcc:	64aa                	ld	s1,136(sp)
    80004dce:	690a                	ld	s2,128(sp)
    80004dd0:	610d                	addi	sp,sp,160
    80004dd2:	8082                	ret
    end_op();
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	792080e7          	jalr	1938(ra) # 80003566 <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	b7ed                	j	80004dc8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	fc6080e7          	jalr	-58(ra) # 80002da8 <iunlockput>
    end_op();
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	77c080e7          	jalr	1916(ra) # 80003566 <end_op>
    return -1;
    80004df2:	557d                	li	a0,-1
    80004df4:	bfd1                	j	80004dc8 <sys_chdir+0x7a>

0000000080004df6 <sys_exec>:

uint64
sys_exec(void)
{
    80004df6:	7121                	addi	sp,sp,-448
    80004df8:	ff06                	sd	ra,440(sp)
    80004dfa:	fb22                	sd	s0,432(sp)
    80004dfc:	f726                	sd	s1,424(sp)
    80004dfe:	f34a                	sd	s2,416(sp)
    80004e00:	ef4e                	sd	s3,408(sp)
    80004e02:	eb52                	sd	s4,400(sp)
    80004e04:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e06:	e4840593          	addi	a1,s0,-440
    80004e0a:	4505                	li	a0,1
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	1ea080e7          	jalr	490(ra) # 80001ff6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e14:	08000613          	li	a2,128
    80004e18:	f5040593          	addi	a1,s0,-176
    80004e1c:	4501                	li	a0,0
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	1f8080e7          	jalr	504(ra) # 80002016 <argstr>
    80004e26:	87aa                	mv	a5,a0
    return -1;
    80004e28:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e2a:	0c07c263          	bltz	a5,80004eee <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004e2e:	10000613          	li	a2,256
    80004e32:	4581                	li	a1,0
    80004e34:	e5040513          	addi	a0,s0,-432
    80004e38:	ffffb097          	auipc	ra,0xffffb
    80004e3c:	342080e7          	jalr	834(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e40:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e44:	89a6                	mv	s3,s1
    80004e46:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e48:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e4c:	00391513          	slli	a0,s2,0x3
    80004e50:	e4040593          	addi	a1,s0,-448
    80004e54:	e4843783          	ld	a5,-440(s0)
    80004e58:	953e                	add	a0,a0,a5
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	0de080e7          	jalr	222(ra) # 80001f38 <fetchaddr>
    80004e62:	02054a63          	bltz	a0,80004e96 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004e66:	e4043783          	ld	a5,-448(s0)
    80004e6a:	c3b9                	beqz	a5,80004eb0 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e6c:	ffffb097          	auipc	ra,0xffffb
    80004e70:	2ae080e7          	jalr	686(ra) # 8000011a <kalloc>
    80004e74:	85aa                	mv	a1,a0
    80004e76:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e7a:	cd11                	beqz	a0,80004e96 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e7c:	6605                	lui	a2,0x1
    80004e7e:	e4043503          	ld	a0,-448(s0)
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	108080e7          	jalr	264(ra) # 80001f8a <fetchstr>
    80004e8a:	00054663          	bltz	a0,80004e96 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004e8e:	0905                	addi	s2,s2,1
    80004e90:	09a1                	addi	s3,s3,8
    80004e92:	fb491de3          	bne	s2,s4,80004e4c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e96:	f5040913          	addi	s2,s0,-176
    80004e9a:	6088                	ld	a0,0(s1)
    80004e9c:	c921                	beqz	a0,80004eec <sys_exec+0xf6>
    kfree(argv[i]);
    80004e9e:	ffffb097          	auipc	ra,0xffffb
    80004ea2:	17e080e7          	jalr	382(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea6:	04a1                	addi	s1,s1,8
    80004ea8:	ff2499e3          	bne	s1,s2,80004e9a <sys_exec+0xa4>
  return -1;
    80004eac:	557d                	li	a0,-1
    80004eae:	a081                	j	80004eee <sys_exec+0xf8>
      argv[i] = 0;
    80004eb0:	0009079b          	sext.w	a5,s2
    80004eb4:	078e                	slli	a5,a5,0x3
    80004eb6:	fd078793          	addi	a5,a5,-48
    80004eba:	97a2                	add	a5,a5,s0
    80004ebc:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004ec0:	e5040593          	addi	a1,s0,-432
    80004ec4:	f5040513          	addi	a0,s0,-176
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	194080e7          	jalr	404(ra) # 8000405c <exec>
    80004ed0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed2:	f5040993          	addi	s3,s0,-176
    80004ed6:	6088                	ld	a0,0(s1)
    80004ed8:	c901                	beqz	a0,80004ee8 <sys_exec+0xf2>
    kfree(argv[i]);
    80004eda:	ffffb097          	auipc	ra,0xffffb
    80004ede:	142080e7          	jalr	322(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee2:	04a1                	addi	s1,s1,8
    80004ee4:	ff3499e3          	bne	s1,s3,80004ed6 <sys_exec+0xe0>
  return ret;
    80004ee8:	854a                	mv	a0,s2
    80004eea:	a011                	j	80004eee <sys_exec+0xf8>
  return -1;
    80004eec:	557d                	li	a0,-1
}
    80004eee:	70fa                	ld	ra,440(sp)
    80004ef0:	745a                	ld	s0,432(sp)
    80004ef2:	74ba                	ld	s1,424(sp)
    80004ef4:	791a                	ld	s2,416(sp)
    80004ef6:	69fa                	ld	s3,408(sp)
    80004ef8:	6a5a                	ld	s4,400(sp)
    80004efa:	6139                	addi	sp,sp,448
    80004efc:	8082                	ret

0000000080004efe <sys_pipe>:

uint64
sys_pipe(void)
{
    80004efe:	7139                	addi	sp,sp,-64
    80004f00:	fc06                	sd	ra,56(sp)
    80004f02:	f822                	sd	s0,48(sp)
    80004f04:	f426                	sd	s1,40(sp)
    80004f06:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	fa2080e7          	jalr	-94(ra) # 80000eaa <myproc>
    80004f10:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f12:	fd840593          	addi	a1,s0,-40
    80004f16:	4501                	li	a0,0
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	0de080e7          	jalr	222(ra) # 80001ff6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f20:	fc840593          	addi	a1,s0,-56
    80004f24:	fd040513          	addi	a0,s0,-48
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	dea080e7          	jalr	-534(ra) # 80003d12 <pipealloc>
    return -1;
    80004f30:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f32:	0c054463          	bltz	a0,80004ffa <sys_pipe+0xfc>
  fd0 = -1;
    80004f36:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f3a:	fd043503          	ld	a0,-48(s0)
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	524080e7          	jalr	1316(ra) # 80004462 <fdalloc>
    80004f46:	fca42223          	sw	a0,-60(s0)
    80004f4a:	08054b63          	bltz	a0,80004fe0 <sys_pipe+0xe2>
    80004f4e:	fc843503          	ld	a0,-56(s0)
    80004f52:	fffff097          	auipc	ra,0xfffff
    80004f56:	510080e7          	jalr	1296(ra) # 80004462 <fdalloc>
    80004f5a:	fca42023          	sw	a0,-64(s0)
    80004f5e:	06054863          	bltz	a0,80004fce <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f62:	4691                	li	a3,4
    80004f64:	fc440613          	addi	a2,s0,-60
    80004f68:	fd843583          	ld	a1,-40(s0)
    80004f6c:	68a8                	ld	a0,80(s1)
    80004f6e:	ffffc097          	auipc	ra,0xffffc
    80004f72:	c00080e7          	jalr	-1024(ra) # 80000b6e <copyout>
    80004f76:	02054063          	bltz	a0,80004f96 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f7a:	4691                	li	a3,4
    80004f7c:	fc040613          	addi	a2,s0,-64
    80004f80:	fd843583          	ld	a1,-40(s0)
    80004f84:	0591                	addi	a1,a1,4
    80004f86:	68a8                	ld	a0,80(s1)
    80004f88:	ffffc097          	auipc	ra,0xffffc
    80004f8c:	be6080e7          	jalr	-1050(ra) # 80000b6e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f90:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f92:	06055463          	bgez	a0,80004ffa <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f96:	fc442783          	lw	a5,-60(s0)
    80004f9a:	07e9                	addi	a5,a5,26
    80004f9c:	078e                	slli	a5,a5,0x3
    80004f9e:	97a6                	add	a5,a5,s1
    80004fa0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fa4:	fc042783          	lw	a5,-64(s0)
    80004fa8:	07e9                	addi	a5,a5,26
    80004faa:	078e                	slli	a5,a5,0x3
    80004fac:	94be                	add	s1,s1,a5
    80004fae:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fb2:	fd043503          	ld	a0,-48(s0)
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	9fa080e7          	jalr	-1542(ra) # 800039b0 <fileclose>
    fileclose(wf);
    80004fbe:	fc843503          	ld	a0,-56(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	9ee080e7          	jalr	-1554(ra) # 800039b0 <fileclose>
    return -1;
    80004fca:	57fd                	li	a5,-1
    80004fcc:	a03d                	j	80004ffa <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004fce:	fc442783          	lw	a5,-60(s0)
    80004fd2:	0007c763          	bltz	a5,80004fe0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004fd6:	07e9                	addi	a5,a5,26
    80004fd8:	078e                	slli	a5,a5,0x3
    80004fda:	97a6                	add	a5,a5,s1
    80004fdc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004fe0:	fd043503          	ld	a0,-48(s0)
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	9cc080e7          	jalr	-1588(ra) # 800039b0 <fileclose>
    fileclose(wf);
    80004fec:	fc843503          	ld	a0,-56(s0)
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	9c0080e7          	jalr	-1600(ra) # 800039b0 <fileclose>
    return -1;
    80004ff8:	57fd                	li	a5,-1
}
    80004ffa:	853e                	mv	a0,a5
    80004ffc:	70e2                	ld	ra,56(sp)
    80004ffe:	7442                	ld	s0,48(sp)
    80005000:	74a2                	ld	s1,40(sp)
    80005002:	6121                	addi	sp,sp,64
    80005004:	8082                	ret

0000000080005006 <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    80005006:	7179                	addi	sp,sp,-48
    80005008:	f406                	sd	ra,40(sp)
    8000500a:	f022                	sd	s0,32(sp)
    8000500c:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  argint(0, (int*)&raddr);
    8000500e:	fe440593          	addi	a1,s0,-28
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	fc2080e7          	jalr	-62(ra) # 80001fd6 <argint>
  argint(1, (int*)&lport);
    8000501c:	fdc40593          	addi	a1,s0,-36
    80005020:	4505                	li	a0,1
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	fb4080e7          	jalr	-76(ra) # 80001fd6 <argint>
  argint(2, (int*)&rport);
    8000502a:	fe040593          	addi	a1,s0,-32
    8000502e:	4509                	li	a0,2
    80005030:	ffffd097          	auipc	ra,0xffffd
    80005034:	fa6080e7          	jalr	-90(ra) # 80001fd6 <argint>

  if(sockalloc(&f, raddr, lport, rport) < 0)
    80005038:	fe045683          	lhu	a3,-32(s0)
    8000503c:	fdc45603          	lhu	a2,-36(s0)
    80005040:	fe442583          	lw	a1,-28(s0)
    80005044:	fe840513          	addi	a0,s0,-24
    80005048:	00001097          	auipc	ra,0x1
    8000504c:	012080e7          	jalr	18(ra) # 8000605a <sockalloc>
    80005050:	02054663          	bltz	a0,8000507c <sys_connect+0x76>
    return -1;
  if((fd=fdalloc(f)) < 0){
    80005054:	fe843503          	ld	a0,-24(s0)
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	40a080e7          	jalr	1034(ra) # 80004462 <fdalloc>
    80005060:	00054663          	bltz	a0,8000506c <sys_connect+0x66>
    fileclose(f);
    return -1;
  }

  return fd;
}
    80005064:	70a2                	ld	ra,40(sp)
    80005066:	7402                	ld	s0,32(sp)
    80005068:	6145                	addi	sp,sp,48
    8000506a:	8082                	ret
    fileclose(f);
    8000506c:	fe843503          	ld	a0,-24(s0)
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	940080e7          	jalr	-1728(ra) # 800039b0 <fileclose>
    return -1;
    80005078:	557d                	li	a0,-1
    8000507a:	b7ed                	j	80005064 <sys_connect+0x5e>
    return -1;
    8000507c:	557d                	li	a0,-1
    8000507e:	b7dd                	j	80005064 <sys_connect+0x5e>

0000000080005080 <kernelvec>:
    80005080:	7111                	addi	sp,sp,-256
    80005082:	e006                	sd	ra,0(sp)
    80005084:	e40a                	sd	sp,8(sp)
    80005086:	e80e                	sd	gp,16(sp)
    80005088:	ec12                	sd	tp,24(sp)
    8000508a:	f016                	sd	t0,32(sp)
    8000508c:	f41a                	sd	t1,40(sp)
    8000508e:	f81e                	sd	t2,48(sp)
    80005090:	fc22                	sd	s0,56(sp)
    80005092:	e0a6                	sd	s1,64(sp)
    80005094:	e4aa                	sd	a0,72(sp)
    80005096:	e8ae                	sd	a1,80(sp)
    80005098:	ecb2                	sd	a2,88(sp)
    8000509a:	f0b6                	sd	a3,96(sp)
    8000509c:	f4ba                	sd	a4,104(sp)
    8000509e:	f8be                	sd	a5,112(sp)
    800050a0:	fcc2                	sd	a6,120(sp)
    800050a2:	e146                	sd	a7,128(sp)
    800050a4:	e54a                	sd	s2,136(sp)
    800050a6:	e94e                	sd	s3,144(sp)
    800050a8:	ed52                	sd	s4,152(sp)
    800050aa:	f156                	sd	s5,160(sp)
    800050ac:	f55a                	sd	s6,168(sp)
    800050ae:	f95e                	sd	s7,176(sp)
    800050b0:	fd62                	sd	s8,184(sp)
    800050b2:	e1e6                	sd	s9,192(sp)
    800050b4:	e5ea                	sd	s10,200(sp)
    800050b6:	e9ee                	sd	s11,208(sp)
    800050b8:	edf2                	sd	t3,216(sp)
    800050ba:	f1f6                	sd	t4,224(sp)
    800050bc:	f5fa                	sd	t5,232(sp)
    800050be:	f9fe                	sd	t6,240(sp)
    800050c0:	d45fc0ef          	jal	ra,80001e04 <kerneltrap>
    800050c4:	6082                	ld	ra,0(sp)
    800050c6:	6122                	ld	sp,8(sp)
    800050c8:	61c2                	ld	gp,16(sp)
    800050ca:	7282                	ld	t0,32(sp)
    800050cc:	7322                	ld	t1,40(sp)
    800050ce:	73c2                	ld	t2,48(sp)
    800050d0:	7462                	ld	s0,56(sp)
    800050d2:	6486                	ld	s1,64(sp)
    800050d4:	6526                	ld	a0,72(sp)
    800050d6:	65c6                	ld	a1,80(sp)
    800050d8:	6666                	ld	a2,88(sp)
    800050da:	7686                	ld	a3,96(sp)
    800050dc:	7726                	ld	a4,104(sp)
    800050de:	77c6                	ld	a5,112(sp)
    800050e0:	7866                	ld	a6,120(sp)
    800050e2:	688a                	ld	a7,128(sp)
    800050e4:	692a                	ld	s2,136(sp)
    800050e6:	69ca                	ld	s3,144(sp)
    800050e8:	6a6a                	ld	s4,152(sp)
    800050ea:	7a8a                	ld	s5,160(sp)
    800050ec:	7b2a                	ld	s6,168(sp)
    800050ee:	7bca                	ld	s7,176(sp)
    800050f0:	7c6a                	ld	s8,184(sp)
    800050f2:	6c8e                	ld	s9,192(sp)
    800050f4:	6d2e                	ld	s10,200(sp)
    800050f6:	6dce                	ld	s11,208(sp)
    800050f8:	6e6e                	ld	t3,216(sp)
    800050fa:	7e8e                	ld	t4,224(sp)
    800050fc:	7f2e                	ld	t5,232(sp)
    800050fe:	7fce                	ld	t6,240(sp)
    80005100:	6111                	addi	sp,sp,256
    80005102:	10200073          	sret
    80005106:	00000013          	nop
    8000510a:	00000013          	nop
    8000510e:	0001                	nop

0000000080005110 <timervec>:
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	e10c                	sd	a1,0(a0)
    80005116:	e510                	sd	a2,8(a0)
    80005118:	e914                	sd	a3,16(a0)
    8000511a:	6d0c                	ld	a1,24(a0)
    8000511c:	7110                	ld	a2,32(a0)
    8000511e:	6194                	ld	a3,0(a1)
    80005120:	96b2                	add	a3,a3,a2
    80005122:	e194                	sd	a3,0(a1)
    80005124:	4589                	li	a1,2
    80005126:	14459073          	csrw	sip,a1
    8000512a:	6914                	ld	a3,16(a0)
    8000512c:	6510                	ld	a2,8(a0)
    8000512e:	610c                	ld	a1,0(a0)
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	30200073          	mret
	...

000000008000513a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000513a:	1141                	addi	sp,sp,-16
    8000513c:	e422                	sd	s0,8(sp)
    8000513e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005140:	0c0007b7          	lui	a5,0xc000
    80005144:	4705                	li	a4,1
    80005146:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005148:	c3d8                	sw	a4,4(a5)
    8000514a:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    8000514c:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    8000514e:	0c000737          	lui	a4,0xc000
    80005152:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    80005156:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    80005158:	0791                	addi	a5,a5,4
    8000515a:	fee79ee3          	bne	a5,a4,80005156 <plicinit+0x1c>
  }
#endif  
}
    8000515e:	6422                	ld	s0,8(sp)
    80005160:	0141                	addi	sp,sp,16
    80005162:	8082                	ret

0000000080005164 <plicinithart>:

void
plicinithart(void)
{
    80005164:	1141                	addi	sp,sp,-16
    80005166:	e406                	sd	ra,8(sp)
    80005168:	e022                	sd	s0,0(sp)
    8000516a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	d12080e7          	jalr	-750(ra) # 80000e7e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005174:	0085171b          	slliw	a4,a0,0x8
    80005178:	0c0027b7          	lui	a5,0xc002
    8000517c:	97ba                	add	a5,a5,a4
    8000517e:	40200713          	li	a4,1026
    80005182:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80005186:	577d                	li	a4,-1
    80005188:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000518c:	00d5151b          	slliw	a0,a0,0xd
    80005190:	0c2017b7          	lui	a5,0xc201
    80005194:	97aa                	add	a5,a5,a0
    80005196:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    8000519a:	60a2                	ld	ra,8(sp)
    8000519c:	6402                	ld	s0,0(sp)
    8000519e:	0141                	addi	sp,sp,16
    800051a0:	8082                	ret

00000000800051a2 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a2:	1141                	addi	sp,sp,-16
    800051a4:	e406                	sd	ra,8(sp)
    800051a6:	e022                	sd	s0,0(sp)
    800051a8:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	cd4080e7          	jalr	-812(ra) # 80000e7e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
  return irq;
}
    800051bc:	43c8                	lw	a0,4(a5)
    800051be:	60a2                	ld	ra,8(sp)
    800051c0:	6402                	ld	s0,0(sp)
    800051c2:	0141                	addi	sp,sp,16
    800051c4:	8082                	ret

00000000800051c6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051c6:	1101                	addi	sp,sp,-32
    800051c8:	ec06                	sd	ra,24(sp)
    800051ca:	e822                	sd	s0,16(sp)
    800051cc:	e426                	sd	s1,8(sp)
    800051ce:	1000                	addi	s0,sp,32
    800051d0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	cac080e7          	jalr	-852(ra) # 80000e7e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051da:	00d5151b          	slliw	a0,a0,0xd
    800051de:	0c2017b7          	lui	a5,0xc201
    800051e2:	97aa                	add	a5,a5,a0
    800051e4:	c3c4                	sw	s1,4(a5)
}
    800051e6:	60e2                	ld	ra,24(sp)
    800051e8:	6442                	ld	s0,16(sp)
    800051ea:	64a2                	ld	s1,8(sp)
    800051ec:	6105                	addi	sp,sp,32
    800051ee:	8082                	ret

00000000800051f0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f0:	1141                	addi	sp,sp,-16
    800051f2:	e406                	sd	ra,8(sp)
    800051f4:	e022                	sd	s0,0(sp)
    800051f6:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051f8:	479d                	li	a5,7
    800051fa:	04a7cc63          	blt	a5,a0,80005252 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800051fe:	00016797          	auipc	a5,0x16
    80005202:	bc278793          	addi	a5,a5,-1086 # 8001adc0 <disk>
    80005206:	97aa                	add	a5,a5,a0
    80005208:	0187c783          	lbu	a5,24(a5)
    8000520c:	ebb9                	bnez	a5,80005262 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000520e:	00451693          	slli	a3,a0,0x4
    80005212:	00016797          	auipc	a5,0x16
    80005216:	bae78793          	addi	a5,a5,-1106 # 8001adc0 <disk>
    8000521a:	6398                	ld	a4,0(a5)
    8000521c:	9736                	add	a4,a4,a3
    8000521e:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005222:	6398                	ld	a4,0(a5)
    80005224:	9736                	add	a4,a4,a3
    80005226:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000522a:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000522e:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005232:	97aa                	add	a5,a5,a0
    80005234:	4705                	li	a4,1
    80005236:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000523a:	00016517          	auipc	a0,0x16
    8000523e:	b9e50513          	addi	a0,a0,-1122 # 8001add8 <disk+0x18>
    80005242:	ffffc097          	auipc	ra,0xffffc
    80005246:	374080e7          	jalr	884(ra) # 800015b6 <wakeup>
}
    8000524a:	60a2                	ld	ra,8(sp)
    8000524c:	6402                	ld	s0,0(sp)
    8000524e:	0141                	addi	sp,sp,16
    80005250:	8082                	ret
    panic("free_desc 1");
    80005252:	00004517          	auipc	a0,0x4
    80005256:	4be50513          	addi	a0,a0,1214 # 80009710 <syscalls+0x330>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	790080e7          	jalr	1936(ra) # 800069ea <panic>
    panic("free_desc 2");
    80005262:	00004517          	auipc	a0,0x4
    80005266:	4be50513          	addi	a0,a0,1214 # 80009720 <syscalls+0x340>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	780080e7          	jalr	1920(ra) # 800069ea <panic>

0000000080005272 <virtio_disk_init>:
{
    80005272:	1101                	addi	sp,sp,-32
    80005274:	ec06                	sd	ra,24(sp)
    80005276:	e822                	sd	s0,16(sp)
    80005278:	e426                	sd	s1,8(sp)
    8000527a:	e04a                	sd	s2,0(sp)
    8000527c:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000527e:	00004597          	auipc	a1,0x4
    80005282:	4b258593          	addi	a1,a1,1202 # 80009730 <syscalls+0x350>
    80005286:	00016517          	auipc	a0,0x16
    8000528a:	c6250513          	addi	a0,a0,-926 # 8001aee8 <disk+0x128>
    8000528e:	00002097          	auipc	ra,0x2
    80005292:	c04080e7          	jalr	-1020(ra) # 80006e92 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	4398                	lw	a4,0(a5)
    8000529c:	2701                	sext.w	a4,a4
    8000529e:	747277b7          	lui	a5,0x74727
    800052a2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052a6:	14f71b63          	bne	a4,a5,800053fc <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052aa:	100017b7          	lui	a5,0x10001
    800052ae:	43dc                	lw	a5,4(a5)
    800052b0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b2:	4709                	li	a4,2
    800052b4:	14e79463          	bne	a5,a4,800053fc <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	479c                	lw	a5,8(a5)
    800052be:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052c0:	12e79e63          	bne	a5,a4,800053fc <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	47d8                	lw	a4,12(a5)
    800052ca:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052cc:	554d47b7          	lui	a5,0x554d4
    800052d0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052d4:	12f71463          	bne	a4,a5,800053fc <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e0:	4705                	li	a4,1
    800052e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e4:	470d                	li	a4,3
    800052e6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052e8:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052ea:	c7ffe6b7          	lui	a3,0xc7ffe
    800052ee:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb3df>
    800052f2:	8f75                	and	a4,a4,a3
    800052f4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f6:	472d                	li	a4,11
    800052f8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800052fa:	5bbc                	lw	a5,112(a5)
    800052fc:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005300:	8ba1                	andi	a5,a5,8
    80005302:	10078563          	beqz	a5,8000540c <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005306:	100017b7          	lui	a5,0x10001
    8000530a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000530e:	43fc                	lw	a5,68(a5)
    80005310:	2781                	sext.w	a5,a5
    80005312:	10079563          	bnez	a5,8000541c <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	5bdc                	lw	a5,52(a5)
    8000531c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000531e:	10078763          	beqz	a5,8000542c <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005322:	471d                	li	a4,7
    80005324:	10f77c63          	bgeu	a4,a5,8000543c <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    80005328:	ffffb097          	auipc	ra,0xffffb
    8000532c:	df2080e7          	jalr	-526(ra) # 8000011a <kalloc>
    80005330:	00016497          	auipc	s1,0x16
    80005334:	a9048493          	addi	s1,s1,-1392 # 8001adc0 <disk>
    80005338:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    8000533a:	ffffb097          	auipc	ra,0xffffb
    8000533e:	de0080e7          	jalr	-544(ra) # 8000011a <kalloc>
    80005342:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	dd6080e7          	jalr	-554(ra) # 8000011a <kalloc>
    8000534c:	87aa                	mv	a5,a0
    8000534e:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005350:	6088                	ld	a0,0(s1)
    80005352:	cd6d                	beqz	a0,8000544c <virtio_disk_init+0x1da>
    80005354:	00016717          	auipc	a4,0x16
    80005358:	a7473703          	ld	a4,-1420(a4) # 8001adc8 <disk+0x8>
    8000535c:	cb65                	beqz	a4,8000544c <virtio_disk_init+0x1da>
    8000535e:	c7fd                	beqz	a5,8000544c <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005360:	6605                	lui	a2,0x1
    80005362:	4581                	li	a1,0
    80005364:	ffffb097          	auipc	ra,0xffffb
    80005368:	e16080e7          	jalr	-490(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    8000536c:	00016497          	auipc	s1,0x16
    80005370:	a5448493          	addi	s1,s1,-1452 # 8001adc0 <disk>
    80005374:	6605                	lui	a2,0x1
    80005376:	4581                	li	a1,0
    80005378:	6488                	ld	a0,8(s1)
    8000537a:	ffffb097          	auipc	ra,0xffffb
    8000537e:	e00080e7          	jalr	-512(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005382:	6605                	lui	a2,0x1
    80005384:	4581                	li	a1,0
    80005386:	6888                	ld	a0,16(s1)
    80005388:	ffffb097          	auipc	ra,0xffffb
    8000538c:	df2080e7          	jalr	-526(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005390:	100017b7          	lui	a5,0x10001
    80005394:	4721                	li	a4,8
    80005396:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005398:	4098                	lw	a4,0(s1)
    8000539a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000539e:	40d8                	lw	a4,4(s1)
    800053a0:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053a4:	6498                	ld	a4,8(s1)
    800053a6:	0007069b          	sext.w	a3,a4
    800053aa:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053ae:	9701                	srai	a4,a4,0x20
    800053b0:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053b4:	6898                	ld	a4,16(s1)
    800053b6:	0007069b          	sext.w	a3,a4
    800053ba:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053be:	9701                	srai	a4,a4,0x20
    800053c0:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053c4:	4705                	li	a4,1
    800053c6:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053c8:	00e48c23          	sb	a4,24(s1)
    800053cc:	00e48ca3          	sb	a4,25(s1)
    800053d0:	00e48d23          	sb	a4,26(s1)
    800053d4:	00e48da3          	sb	a4,27(s1)
    800053d8:	00e48e23          	sb	a4,28(s1)
    800053dc:	00e48ea3          	sb	a4,29(s1)
    800053e0:	00e48f23          	sb	a4,30(s1)
    800053e4:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053e8:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ec:	0727a823          	sw	s2,112(a5)
}
    800053f0:	60e2                	ld	ra,24(sp)
    800053f2:	6442                	ld	s0,16(sp)
    800053f4:	64a2                	ld	s1,8(sp)
    800053f6:	6902                	ld	s2,0(sp)
    800053f8:	6105                	addi	sp,sp,32
    800053fa:	8082                	ret
    panic("could not find virtio disk");
    800053fc:	00004517          	auipc	a0,0x4
    80005400:	34450513          	addi	a0,a0,836 # 80009740 <syscalls+0x360>
    80005404:	00001097          	auipc	ra,0x1
    80005408:	5e6080e7          	jalr	1510(ra) # 800069ea <panic>
    panic("virtio disk FEATURES_OK unset");
    8000540c:	00004517          	auipc	a0,0x4
    80005410:	35450513          	addi	a0,a0,852 # 80009760 <syscalls+0x380>
    80005414:	00001097          	auipc	ra,0x1
    80005418:	5d6080e7          	jalr	1494(ra) # 800069ea <panic>
    panic("virtio disk should not be ready");
    8000541c:	00004517          	auipc	a0,0x4
    80005420:	36450513          	addi	a0,a0,868 # 80009780 <syscalls+0x3a0>
    80005424:	00001097          	auipc	ra,0x1
    80005428:	5c6080e7          	jalr	1478(ra) # 800069ea <panic>
    panic("virtio disk has no queue 0");
    8000542c:	00004517          	auipc	a0,0x4
    80005430:	37450513          	addi	a0,a0,884 # 800097a0 <syscalls+0x3c0>
    80005434:	00001097          	auipc	ra,0x1
    80005438:	5b6080e7          	jalr	1462(ra) # 800069ea <panic>
    panic("virtio disk max queue too short");
    8000543c:	00004517          	auipc	a0,0x4
    80005440:	38450513          	addi	a0,a0,900 # 800097c0 <syscalls+0x3e0>
    80005444:	00001097          	auipc	ra,0x1
    80005448:	5a6080e7          	jalr	1446(ra) # 800069ea <panic>
    panic("virtio disk kalloc");
    8000544c:	00004517          	auipc	a0,0x4
    80005450:	39450513          	addi	a0,a0,916 # 800097e0 <syscalls+0x400>
    80005454:	00001097          	auipc	ra,0x1
    80005458:	596080e7          	jalr	1430(ra) # 800069ea <panic>

000000008000545c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000545c:	7159                	addi	sp,sp,-112
    8000545e:	f486                	sd	ra,104(sp)
    80005460:	f0a2                	sd	s0,96(sp)
    80005462:	eca6                	sd	s1,88(sp)
    80005464:	e8ca                	sd	s2,80(sp)
    80005466:	e4ce                	sd	s3,72(sp)
    80005468:	e0d2                	sd	s4,64(sp)
    8000546a:	fc56                	sd	s5,56(sp)
    8000546c:	f85a                	sd	s6,48(sp)
    8000546e:	f45e                	sd	s7,40(sp)
    80005470:	f062                	sd	s8,32(sp)
    80005472:	ec66                	sd	s9,24(sp)
    80005474:	e86a                	sd	s10,16(sp)
    80005476:	1880                	addi	s0,sp,112
    80005478:	8a2a                	mv	s4,a0
    8000547a:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000547c:	00c52c83          	lw	s9,12(a0)
    80005480:	001c9c9b          	slliw	s9,s9,0x1
    80005484:	1c82                	slli	s9,s9,0x20
    80005486:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000548a:	00016517          	auipc	a0,0x16
    8000548e:	a5e50513          	addi	a0,a0,-1442 # 8001aee8 <disk+0x128>
    80005492:	00002097          	auipc	ra,0x2
    80005496:	a90080e7          	jalr	-1392(ra) # 80006f22 <acquire>
  for(int i = 0; i < 3; i++){
    8000549a:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    8000549c:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000549e:	00016b17          	auipc	s6,0x16
    800054a2:	922b0b13          	addi	s6,s6,-1758 # 8001adc0 <disk>
  for(int i = 0; i < 3; i++){
    800054a6:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a8:	00016c17          	auipc	s8,0x16
    800054ac:	a40c0c13          	addi	s8,s8,-1472 # 8001aee8 <disk+0x128>
    800054b0:	a095                	j	80005514 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054b2:	00fb0733          	add	a4,s6,a5
    800054b6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054ba:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054bc:	0207c563          	bltz	a5,800054e6 <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054c0:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054c2:	0591                	addi	a1,a1,4
    800054c4:	05560d63          	beq	a2,s5,8000551e <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054c8:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054ca:	00016717          	auipc	a4,0x16
    800054ce:	8f670713          	addi	a4,a4,-1802 # 8001adc0 <disk>
    800054d2:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054d4:	01874683          	lbu	a3,24(a4)
    800054d8:	fee9                	bnez	a3,800054b2 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800054da:	2785                	addiw	a5,a5,1
    800054dc:	0705                	addi	a4,a4,1
    800054de:	fe979be3          	bne	a5,s1,800054d4 <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800054e2:	57fd                	li	a5,-1
    800054e4:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800054e6:	00c05e63          	blez	a2,80005502 <virtio_disk_rw+0xa6>
    800054ea:	060a                	slli	a2,a2,0x2
    800054ec:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800054f0:	0009a503          	lw	a0,0(s3)
    800054f4:	00000097          	auipc	ra,0x0
    800054f8:	cfc080e7          	jalr	-772(ra) # 800051f0 <free_desc>
      for(int j = 0; j < i; j++)
    800054fc:	0991                	addi	s3,s3,4
    800054fe:	ffa999e3          	bne	s3,s10,800054f0 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005502:	85e2                	mv	a1,s8
    80005504:	00016517          	auipc	a0,0x16
    80005508:	8d450513          	addi	a0,a0,-1836 # 8001add8 <disk+0x18>
    8000550c:	ffffc097          	auipc	ra,0xffffc
    80005510:	046080e7          	jalr	70(ra) # 80001552 <sleep>
  for(int i = 0; i < 3; i++){
    80005514:	f9040993          	addi	s3,s0,-112
{
    80005518:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    8000551a:	864a                	mv	a2,s2
    8000551c:	b775                	j	800054c8 <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000551e:	f9042503          	lw	a0,-112(s0)
    80005522:	00a50713          	addi	a4,a0,10
    80005526:	0712                	slli	a4,a4,0x4

  if(write)
    80005528:	00016797          	auipc	a5,0x16
    8000552c:	89878793          	addi	a5,a5,-1896 # 8001adc0 <disk>
    80005530:	00e786b3          	add	a3,a5,a4
    80005534:	01703633          	snez	a2,s7
    80005538:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000553a:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    8000553e:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005542:	f6070613          	addi	a2,a4,-160
    80005546:	6394                	ld	a3,0(a5)
    80005548:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000554a:	00870593          	addi	a1,a4,8
    8000554e:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005550:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005552:	0007b803          	ld	a6,0(a5)
    80005556:	9642                	add	a2,a2,a6
    80005558:	46c1                	li	a3,16
    8000555a:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000555c:	4585                	li	a1,1
    8000555e:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005562:	f9442683          	lw	a3,-108(s0)
    80005566:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000556a:	0692                	slli	a3,a3,0x4
    8000556c:	9836                	add	a6,a6,a3
    8000556e:	058a0613          	addi	a2,s4,88
    80005572:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    80005576:	0007b803          	ld	a6,0(a5)
    8000557a:	96c2                	add	a3,a3,a6
    8000557c:	40000613          	li	a2,1024
    80005580:	c690                	sw	a2,8(a3)
  if(write)
    80005582:	001bb613          	seqz	a2,s7
    80005586:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000558a:	00166613          	ori	a2,a2,1
    8000558e:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005592:	f9842603          	lw	a2,-104(s0)
    80005596:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000559a:	00250693          	addi	a3,a0,2
    8000559e:	0692                	slli	a3,a3,0x4
    800055a0:	96be                	add	a3,a3,a5
    800055a2:	58fd                	li	a7,-1
    800055a4:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055a8:	0612                	slli	a2,a2,0x4
    800055aa:	9832                	add	a6,a6,a2
    800055ac:	f9070713          	addi	a4,a4,-112
    800055b0:	973e                	add	a4,a4,a5
    800055b2:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055b6:	6398                	ld	a4,0(a5)
    800055b8:	9732                	add	a4,a4,a2
    800055ba:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055bc:	4609                	li	a2,2
    800055be:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055c2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055c6:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055ca:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055ce:	6794                	ld	a3,8(a5)
    800055d0:	0026d703          	lhu	a4,2(a3)
    800055d4:	8b1d                	andi	a4,a4,7
    800055d6:	0706                	slli	a4,a4,0x1
    800055d8:	96ba                	add	a3,a3,a4
    800055da:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055de:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055e2:	6798                	ld	a4,8(a5)
    800055e4:	00275783          	lhu	a5,2(a4)
    800055e8:	2785                	addiw	a5,a5,1
    800055ea:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055ee:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055f2:	100017b7          	lui	a5,0x10001
    800055f6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055fa:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800055fe:	00016917          	auipc	s2,0x16
    80005602:	8ea90913          	addi	s2,s2,-1814 # 8001aee8 <disk+0x128>
  while(b->disk == 1) {
    80005606:	4485                	li	s1,1
    80005608:	00b79c63          	bne	a5,a1,80005620 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000560c:	85ca                	mv	a1,s2
    8000560e:	8552                	mv	a0,s4
    80005610:	ffffc097          	auipc	ra,0xffffc
    80005614:	f42080e7          	jalr	-190(ra) # 80001552 <sleep>
  while(b->disk == 1) {
    80005618:	004a2783          	lw	a5,4(s4)
    8000561c:	fe9788e3          	beq	a5,s1,8000560c <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005620:	f9042903          	lw	s2,-112(s0)
    80005624:	00290713          	addi	a4,s2,2
    80005628:	0712                	slli	a4,a4,0x4
    8000562a:	00015797          	auipc	a5,0x15
    8000562e:	79678793          	addi	a5,a5,1942 # 8001adc0 <disk>
    80005632:	97ba                	add	a5,a5,a4
    80005634:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005638:	00015997          	auipc	s3,0x15
    8000563c:	78898993          	addi	s3,s3,1928 # 8001adc0 <disk>
    80005640:	00491713          	slli	a4,s2,0x4
    80005644:	0009b783          	ld	a5,0(s3)
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000564e:	854a                	mv	a0,s2
    80005650:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005654:	00000097          	auipc	ra,0x0
    80005658:	b9c080e7          	jalr	-1124(ra) # 800051f0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000565c:	8885                	andi	s1,s1,1
    8000565e:	f0ed                	bnez	s1,80005640 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005660:	00016517          	auipc	a0,0x16
    80005664:	88850513          	addi	a0,a0,-1912 # 8001aee8 <disk+0x128>
    80005668:	00002097          	auipc	ra,0x2
    8000566c:	96e080e7          	jalr	-1682(ra) # 80006fd6 <release>
}
    80005670:	70a6                	ld	ra,104(sp)
    80005672:	7406                	ld	s0,96(sp)
    80005674:	64e6                	ld	s1,88(sp)
    80005676:	6946                	ld	s2,80(sp)
    80005678:	69a6                	ld	s3,72(sp)
    8000567a:	6a06                	ld	s4,64(sp)
    8000567c:	7ae2                	ld	s5,56(sp)
    8000567e:	7b42                	ld	s6,48(sp)
    80005680:	7ba2                	ld	s7,40(sp)
    80005682:	7c02                	ld	s8,32(sp)
    80005684:	6ce2                	ld	s9,24(sp)
    80005686:	6d42                	ld	s10,16(sp)
    80005688:	6165                	addi	sp,sp,112
    8000568a:	8082                	ret

000000008000568c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000568c:	1101                	addi	sp,sp,-32
    8000568e:	ec06                	sd	ra,24(sp)
    80005690:	e822                	sd	s0,16(sp)
    80005692:	e426                	sd	s1,8(sp)
    80005694:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005696:	00015497          	auipc	s1,0x15
    8000569a:	72a48493          	addi	s1,s1,1834 # 8001adc0 <disk>
    8000569e:	00016517          	auipc	a0,0x16
    800056a2:	84a50513          	addi	a0,a0,-1974 # 8001aee8 <disk+0x128>
    800056a6:	00002097          	auipc	ra,0x2
    800056aa:	87c080e7          	jalr	-1924(ra) # 80006f22 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056ae:	10001737          	lui	a4,0x10001
    800056b2:	533c                	lw	a5,96(a4)
    800056b4:	8b8d                	andi	a5,a5,3
    800056b6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b8:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056bc:	689c                	ld	a5,16(s1)
    800056be:	0204d703          	lhu	a4,32(s1)
    800056c2:	0027d783          	lhu	a5,2(a5)
    800056c6:	04f70863          	beq	a4,a5,80005716 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056ca:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ce:	6898                	ld	a4,16(s1)
    800056d0:	0204d783          	lhu	a5,32(s1)
    800056d4:	8b9d                	andi	a5,a5,7
    800056d6:	078e                	slli	a5,a5,0x3
    800056d8:	97ba                	add	a5,a5,a4
    800056da:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056dc:	00278713          	addi	a4,a5,2
    800056e0:	0712                	slli	a4,a4,0x4
    800056e2:	9726                	add	a4,a4,s1
    800056e4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056e8:	e721                	bnez	a4,80005730 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056ea:	0789                	addi	a5,a5,2
    800056ec:	0792                	slli	a5,a5,0x4
    800056ee:	97a6                	add	a5,a5,s1
    800056f0:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056f2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f6:	ffffc097          	auipc	ra,0xffffc
    800056fa:	ec0080e7          	jalr	-320(ra) # 800015b6 <wakeup>

    disk.used_idx += 1;
    800056fe:	0204d783          	lhu	a5,32(s1)
    80005702:	2785                	addiw	a5,a5,1
    80005704:	17c2                	slli	a5,a5,0x30
    80005706:	93c1                	srli	a5,a5,0x30
    80005708:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000570c:	6898                	ld	a4,16(s1)
    8000570e:	00275703          	lhu	a4,2(a4)
    80005712:	faf71ce3          	bne	a4,a5,800056ca <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005716:	00015517          	auipc	a0,0x15
    8000571a:	7d250513          	addi	a0,a0,2002 # 8001aee8 <disk+0x128>
    8000571e:	00002097          	auipc	ra,0x2
    80005722:	8b8080e7          	jalr	-1864(ra) # 80006fd6 <release>
}
    80005726:	60e2                	ld	ra,24(sp)
    80005728:	6442                	ld	s0,16(sp)
    8000572a:	64a2                	ld	s1,8(sp)
    8000572c:	6105                	addi	sp,sp,32
    8000572e:	8082                	ret
      panic("virtio_disk_intr status");
    80005730:	00004517          	auipc	a0,0x4
    80005734:	0c850513          	addi	a0,a0,200 # 800097f8 <syscalls+0x418>
    80005738:	00001097          	auipc	ra,0x1
    8000573c:	2b2080e7          	jalr	690(ra) # 800069ea <panic>

0000000080005740 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005740:	1101                	addi	sp,sp,-32
    80005742:	ec06                	sd	ra,24(sp)
    80005744:	e822                	sd	s0,16(sp)
    80005746:	e426                	sd	s1,8(sp)
    80005748:	e04a                	sd	s2,0(sp)
    8000574a:	1000                	addi	s0,sp,32
    8000574c:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    8000574e:	00004597          	auipc	a1,0x4
    80005752:	0c258593          	addi	a1,a1,194 # 80009810 <syscalls+0x430>
    80005756:	00015517          	auipc	a0,0x15
    8000575a:	7aa50513          	addi	a0,a0,1962 # 8001af00 <e1000_lock>
    8000575e:	00001097          	auipc	ra,0x1
    80005762:	734080e7          	jalr	1844(ra) # 80006e92 <initlock>

  regs = xregs;
    80005766:	00004917          	auipc	s2,0x4
    8000576a:	21a90913          	addi	s2,s2,538 # 80009980 <regs>
    8000576e:	00993023          	sd	s1,0(s2)

  printf("%d\n", sizeof(tx_ring));
    80005772:	10000593          	li	a1,256
    80005776:	00004517          	auipc	a0,0x4
    8000577a:	c4a50513          	addi	a0,a0,-950 # 800093c0 <states.0+0x168>
    8000577e:	00001097          	auipc	ra,0x1
    80005782:	2b6080e7          	jalr	694(ra) # 80006a34 <printf>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80005786:	00093783          	ld	a5,0(s2)
    8000578a:	0c07a823          	sw	zero,208(a5)
  regs[E1000_CTL] |= E1000_CTL_RST;
    8000578e:	4398                	lw	a4,0(a5)
    80005790:	004006b7          	lui	a3,0x400
    80005794:	8f55                	or	a4,a4,a3
    80005796:	c398                	sw	a4,0(a5)
  regs[E1000_IMS] = 0; // redisable interrupts
    80005798:	0c07a823          	sw	zero,208(a5)
  __sync_synchronize();
    8000579c:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    800057a0:	10000613          	li	a2,256
    800057a4:	4581                	li	a1,0
    800057a6:	00015517          	auipc	a0,0x15
    800057aa:	77a50513          	addi	a0,a0,1914 # 8001af20 <tx_ring>
    800057ae:	ffffb097          	auipc	ra,0xffffb
    800057b2:	9cc080e7          	jalr	-1588(ra) # 8000017a <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057b6:	00015797          	auipc	a5,0x15
    800057ba:	77678793          	addi	a5,a5,1910 # 8001af2c <tx_ring+0xc>
    800057be:	00016697          	auipc	a3,0x16
    800057c2:	86e68693          	addi	a3,a3,-1938 # 8001b02c <rx_ring+0xc>
    tx_ring[i].status = E1000_TXD_STAT_DD;  /* Descriptor Done */
    800057c6:	4705                	li	a4,1
    800057c8:	00e78023          	sb	a4,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057cc:	07c1                	addi	a5,a5,16
    800057ce:	fed79de3          	bne	a5,a3,800057c8 <e1000_init+0x88>
    tx_mbufs[i] = 0;
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    800057d2:	00015717          	auipc	a4,0x15
    800057d6:	74e70713          	addi	a4,a4,1870 # 8001af20 <tx_ring>
    800057da:	00004797          	auipc	a5,0x4
    800057de:	1a67b783          	ld	a5,422(a5) # 80009980 <regs>
    800057e2:	6691                	lui	a3,0x4
    800057e4:	97b6                	add	a5,a5,a3
    800057e6:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800057ea:	10000713          	li	a4,256
    800057ee:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800057f2:	8007ac23          	sw	zero,-2024(a5)
    800057f6:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    800057fa:	00016497          	auipc	s1,0x16
    800057fe:	82648493          	addi	s1,s1,-2010 # 8001b020 <rx_ring>
    80005802:	10000613          	li	a2,256
    80005806:	4581                	li	a1,0
    80005808:	8526                	mv	a0,s1
    8000580a:	ffffb097          	auipc	ra,0xffffb
    8000580e:	970080e7          	jalr	-1680(ra) # 8000017a <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005812:	00016917          	auipc	s2,0x16
    80005816:	90e90913          	addi	s2,s2,-1778 # 8001b120 <lock>
    rx_mbufs[i] = mbufalloc(0);
    8000581a:	4501                	li	a0,0
    8000581c:	00000097          	auipc	ra,0x0
    80005820:	2ae080e7          	jalr	686(ra) # 80005aca <mbufalloc>
    if (!rx_mbufs[i])
    80005824:	c54d                	beqz	a0,800058ce <e1000_init+0x18e>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    80005826:	651c                	ld	a5,8(a0)
    80005828:	e09c                	sd	a5,0(s1)
  for (i = 0; i < RX_RING_SIZE; i++) {
    8000582a:	04c1                	addi	s1,s1,16
    8000582c:	ff2497e3          	bne	s1,s2,8000581a <e1000_init+0xda>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80005830:	00004697          	auipc	a3,0x4
    80005834:	1506b683          	ld	a3,336(a3) # 80009980 <regs>
    80005838:	00015717          	auipc	a4,0x15
    8000583c:	7e870713          	addi	a4,a4,2024 # 8001b020 <rx_ring>
    80005840:	678d                	lui	a5,0x3
    80005842:	97b6                	add	a5,a5,a3
    80005844:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005848:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    8000584c:	473d                	li	a4,15
    8000584e:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80005852:	10000713          	li	a4,256
    80005856:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    8000585a:	6715                	lui	a4,0x5
    8000585c:	00e68633          	add	a2,a3,a4
    80005860:	120057b7          	lui	a5,0x12005
    80005864:	45278793          	addi	a5,a5,1106 # 12005452 <_entry-0x6dffabae>
    80005868:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    8000586c:	800057b7          	lui	a5,0x80005
    80005870:	63478793          	addi	a5,a5,1588 # ffffffff80005634 <end+0xfffffffefffe22b4>
    80005874:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80005878:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    8000587c:	97b6                	add	a5,a5,a3
    8000587e:	40070713          	addi	a4,a4,1024
    80005882:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80005884:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    80005888:	0791                	addi	a5,a5,4
    8000588a:	fee79de3          	bne	a5,a4,80005884 <e1000_init+0x144>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    8000588e:	000407b7          	lui	a5,0x40
    80005892:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80005896:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    8000589a:	006027b7          	lui	a5,0x602
    8000589e:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    800058a0:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    800058a4:	040087b7          	lui	a5,0x4008
    800058a8:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    800058aa:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    800058ae:	678d                	lui	a5,0x3
    800058b0:	97b6                	add	a5,a5,a3
    800058b2:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    800058b6:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    800058ba:	08000793          	li	a5,128
    800058be:	0cf6a823          	sw	a5,208(a3)
}
    800058c2:	60e2                	ld	ra,24(sp)
    800058c4:	6442                	ld	s0,16(sp)
    800058c6:	64a2                	ld	s1,8(sp)
    800058c8:	6902                	ld	s2,0(sp)
    800058ca:	6105                	addi	sp,sp,32
    800058cc:	8082                	ret
      panic("e1000");
    800058ce:	00004517          	auipc	a0,0x4
    800058d2:	f4250513          	addi	a0,a0,-190 # 80009810 <syscalls+0x430>
    800058d6:	00001097          	auipc	ra,0x1
    800058da:	114080e7          	jalr	276(ra) # 800069ea <panic>

00000000800058de <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    800058de:	1141                	addi	sp,sp,-16
    800058e0:	e406                	sd	ra,8(sp)
    800058e2:	e022                	sd	s0,0(sp)
    800058e4:	0800                	addi	s0,sp,16
  printf("---transmit---\n");
    800058e6:	00004517          	auipc	a0,0x4
    800058ea:	f3250513          	addi	a0,a0,-206 # 80009818 <syscalls+0x438>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	146080e7          	jalr	326(ra) # 80006a34 <printf>
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  
  return 0;
}
    800058f6:	4501                	li	a0,0
    800058f8:	60a2                	ld	ra,8(sp)
    800058fa:	6402                	ld	s0,0(sp)
    800058fc:	0141                	addi	sp,sp,16
    800058fe:	8082                	ret

0000000080005900 <e1000_intr>:
  //
}

void
e1000_intr(void)
{
    80005900:	1141                	addi	sp,sp,-16
    80005902:	e406                	sd	ra,8(sp)
    80005904:	e022                	sd	s0,0(sp)
    80005906:	0800                	addi	s0,sp,16
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005908:	00004797          	auipc	a5,0x4
    8000590c:	0787b783          	ld	a5,120(a5) # 80009980 <regs>
    80005910:	577d                	li	a4,-1
    80005912:	0ce7a023          	sw	a4,192(a5)
    printf("---recv---\n");
    80005916:	00004517          	auipc	a0,0x4
    8000591a:	f1250513          	addi	a0,a0,-238 # 80009828 <syscalls+0x448>
    8000591e:	00001097          	auipc	ra,0x1
    80005922:	116080e7          	jalr	278(ra) # 80006a34 <printf>

  e1000_recv();
}
    80005926:	60a2                	ld	ra,8(sp)
    80005928:	6402                	ld	s0,0(sp)
    8000592a:	0141                	addi	sp,sp,16
    8000592c:	8082                	ret

000000008000592e <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    8000592e:	1141                	addi	sp,sp,-16
    80005930:	e422                	sd	s0,8(sp)
    80005932:	0800                	addi	s0,sp,16
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005934:	4785                	li	a5,1
    80005936:	04b7db63          	bge	a5,a1,8000598c <in_cksum+0x5e>
    8000593a:	ffe5861b          	addiw	a2,a1,-2
    8000593e:	0016561b          	srliw	a2,a2,0x1
    80005942:	0016069b          	addiw	a3,a2,1
    80005946:	02069793          	slli	a5,a3,0x20
    8000594a:	01f7d693          	srli	a3,a5,0x1f
    8000594e:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    80005950:	4781                	li	a5,0
    sum += *w++;
    80005952:	0509                	addi	a0,a0,2
    80005954:	ffe55703          	lhu	a4,-2(a0)
    80005958:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    8000595a:	fed51ce3          	bne	a0,a3,80005952 <in_cksum+0x24>
    nleft -= 2;
    8000595e:	35f9                	addiw	a1,a1,-2
    80005960:	0016161b          	slliw	a2,a2,0x1
    80005964:	9d91                	subw	a1,a1,a2
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005966:	4705                	li	a4,1
    80005968:	02e58563          	beq	a1,a4,80005992 <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    8000596c:	03079713          	slli	a4,a5,0x30
    80005970:	9341                	srli	a4,a4,0x30
    80005972:	0107d79b          	srliw	a5,a5,0x10
    80005976:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    80005978:	0107d51b          	srliw	a0,a5,0x10
    8000597c:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    8000597e:	fff54513          	not	a0,a0
  return answer;
}
    80005982:	1542                	slli	a0,a0,0x30
    80005984:	9141                	srli	a0,a0,0x30
    80005986:	6422                	ld	s0,8(sp)
    80005988:	0141                	addi	sp,sp,16
    8000598a:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    8000598c:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    8000598e:	4781                	li	a5,0
    80005990:	bfd9                	j	80005966 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005992:	0006c703          	lbu	a4,0(a3)
    sum += answer;
    80005996:	9fb9                	addw	a5,a5,a4
    80005998:	bfd1                	j	8000596c <in_cksum+0x3e>

000000008000599a <mbufpull>:
{
    8000599a:	1141                	addi	sp,sp,-16
    8000599c:	e422                	sd	s0,8(sp)
    8000599e:	0800                	addi	s0,sp,16
    800059a0:	87aa                	mv	a5,a0
  char *tmp = m->head;
    800059a2:	6508                	ld	a0,8(a0)
  if (m->len < len)
    800059a4:	4b98                	lw	a4,16(a5)
    800059a6:	00b76b63          	bltu	a4,a1,800059bc <mbufpull+0x22>
  m->len -= len;
    800059aa:	9f0d                	subw	a4,a4,a1
    800059ac:	cb98                	sw	a4,16(a5)
  m->head += len;
    800059ae:	1582                	slli	a1,a1,0x20
    800059b0:	9181                	srli	a1,a1,0x20
    800059b2:	95aa                	add	a1,a1,a0
    800059b4:	e78c                	sd	a1,8(a5)
}
    800059b6:	6422                	ld	s0,8(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret
    return 0;
    800059bc:	4501                	li	a0,0
    800059be:	bfe5                	j	800059b6 <mbufpull+0x1c>

00000000800059c0 <mbufpush>:
{
    800059c0:	87aa                	mv	a5,a0
  m->head -= len;
    800059c2:	02059713          	slli	a4,a1,0x20
    800059c6:	9301                	srli	a4,a4,0x20
    800059c8:	6508                	ld	a0,8(a0)
    800059ca:	8d19                	sub	a0,a0,a4
    800059cc:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    800059ce:	01478713          	addi	a4,a5,20
    800059d2:	00e56663          	bltu	a0,a4,800059de <mbufpush+0x1e>
  m->len += len;
    800059d6:	4b98                	lw	a4,16(a5)
    800059d8:	9f2d                	addw	a4,a4,a1
    800059da:	cb98                	sw	a4,16(a5)
}
    800059dc:	8082                	ret
{
    800059de:	1141                	addi	sp,sp,-16
    800059e0:	e406                	sd	ra,8(sp)
    800059e2:	e022                	sd	s0,0(sp)
    800059e4:	0800                	addi	s0,sp,16
    panic("mbufpush");
    800059e6:	00004517          	auipc	a0,0x4
    800059ea:	e5250513          	addi	a0,a0,-430 # 80009838 <syscalls+0x458>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	ffc080e7          	jalr	-4(ra) # 800069ea <panic>

00000000800059f6 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    800059f6:	7179                	addi	sp,sp,-48
    800059f8:	f406                	sd	ra,40(sp)
    800059fa:	f022                	sd	s0,32(sp)
    800059fc:	ec26                	sd	s1,24(sp)
    800059fe:	e84a                	sd	s2,16(sp)
    80005a00:	e44e                	sd	s3,8(sp)
    80005a02:	1800                	addi	s0,sp,48
    80005a04:	89aa                	mv	s3,a0
    80005a06:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005a08:	45b9                	li	a1,14
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	fb6080e7          	jalr	-74(ra) # 800059c0 <mbufpush>
    80005a12:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005a14:	4619                	li	a2,6
    80005a16:	00004597          	auipc	a1,0x4
    80005a1a:	eda58593          	addi	a1,a1,-294 # 800098f0 <local_mac>
    80005a1e:	0519                	addi	a0,a0,6
    80005a20:	ffffa097          	auipc	ra,0xffffa
    80005a24:	7b6080e7          	jalr	1974(ra) # 800001d6 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005a28:	4619                	li	a2,6
    80005a2a:	00004597          	auipc	a1,0x4
    80005a2e:	ebe58593          	addi	a1,a1,-322 # 800098e8 <broadcast_mac>
    80005a32:	8526                	mv	a0,s1
    80005a34:	ffffa097          	auipc	ra,0xffffa
    80005a38:	7a2080e7          	jalr	1954(ra) # 800001d6 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005a3c:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005a40:	00f48623          	sb	a5,12(s1)
    80005a44:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005a48:	854e                	mv	a0,s3
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	e94080e7          	jalr	-364(ra) # 800058de <e1000_transmit>
    80005a52:	e901                	bnez	a0,80005a62 <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005a54:	70a2                	ld	ra,40(sp)
    80005a56:	7402                	ld	s0,32(sp)
    80005a58:	64e2                	ld	s1,24(sp)
    80005a5a:	6942                	ld	s2,16(sp)
    80005a5c:	69a2                	ld	s3,8(sp)
    80005a5e:	6145                	addi	sp,sp,48
    80005a60:	8082                	ret
  kfree(m);
    80005a62:	854e                	mv	a0,s3
    80005a64:	ffffa097          	auipc	ra,0xffffa
    80005a68:	5b8080e7          	jalr	1464(ra) # 8000001c <kfree>
}
    80005a6c:	b7e5                	j	80005a54 <net_tx_eth+0x5e>

0000000080005a6e <mbufput>:
{
    80005a6e:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005a70:	4918                	lw	a4,16(a0)
    80005a72:	02071693          	slli	a3,a4,0x20
    80005a76:	9281                	srli	a3,a3,0x20
    80005a78:	6508                	ld	a0,8(a0)
    80005a7a:	9536                	add	a0,a0,a3
  m->len += len;
    80005a7c:	9f2d                	addw	a4,a4,a1
    80005a7e:	0007069b          	sext.w	a3,a4
    80005a82:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005a84:	6785                	lui	a5,0x1
    80005a86:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005a8a:	00d7e363          	bltu	a5,a3,80005a90 <mbufput+0x22>
}
    80005a8e:	8082                	ret
{
    80005a90:	1141                	addi	sp,sp,-16
    80005a92:	e406                	sd	ra,8(sp)
    80005a94:	e022                	sd	s0,0(sp)
    80005a96:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005a98:	00004517          	auipc	a0,0x4
    80005a9c:	db050513          	addi	a0,a0,-592 # 80009848 <syscalls+0x468>
    80005aa0:	00001097          	auipc	ra,0x1
    80005aa4:	f4a080e7          	jalr	-182(ra) # 800069ea <panic>

0000000080005aa8 <mbuftrim>:
{
    80005aa8:	1141                	addi	sp,sp,-16
    80005aaa:	e422                	sd	s0,8(sp)
    80005aac:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005aae:	491c                	lw	a5,16(a0)
    80005ab0:	00b7eb63          	bltu	a5,a1,80005ac6 <mbuftrim+0x1e>
  m->len -= len;
    80005ab4:	9f8d                	subw	a5,a5,a1
    80005ab6:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005ab8:	1782                	slli	a5,a5,0x20
    80005aba:	9381                	srli	a5,a5,0x20
    80005abc:	6508                	ld	a0,8(a0)
    80005abe:	953e                	add	a0,a0,a5
}
    80005ac0:	6422                	ld	s0,8(sp)
    80005ac2:	0141                	addi	sp,sp,16
    80005ac4:	8082                	ret
    return 0;
    80005ac6:	4501                	li	a0,0
    80005ac8:	bfe5                	j	80005ac0 <mbuftrim+0x18>

0000000080005aca <mbufalloc>:
{
    80005aca:	1101                	addi	sp,sp,-32
    80005acc:	ec06                	sd	ra,24(sp)
    80005ace:	e822                	sd	s0,16(sp)
    80005ad0:	e426                	sd	s1,8(sp)
    80005ad2:	e04a                	sd	s2,0(sp)
    80005ad4:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005ad6:	6785                	lui	a5,0x1
    80005ad8:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005adc:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005ade:	02a7eb63          	bltu	a5,a0,80005b14 <mbufalloc+0x4a>
    80005ae2:	84aa                	mv	s1,a0
  m = kalloc();
    80005ae4:	ffffa097          	auipc	ra,0xffffa
    80005ae8:	636080e7          	jalr	1590(ra) # 8000011a <kalloc>
    80005aec:	892a                	mv	s2,a0
  if (m == 0)
    80005aee:	c11d                	beqz	a0,80005b14 <mbufalloc+0x4a>
  m->next = 0;
    80005af0:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005af4:	0551                	addi	a0,a0,20
    80005af6:	1482                	slli	s1,s1,0x20
    80005af8:	9081                	srli	s1,s1,0x20
    80005afa:	94aa                	add	s1,s1,a0
    80005afc:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005b00:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005b04:	6605                	lui	a2,0x1
    80005b06:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005b0a:	4581                	li	a1,0
    80005b0c:	ffffa097          	auipc	ra,0xffffa
    80005b10:	66e080e7          	jalr	1646(ra) # 8000017a <memset>
}
    80005b14:	854a                	mv	a0,s2
    80005b16:	60e2                	ld	ra,24(sp)
    80005b18:	6442                	ld	s0,16(sp)
    80005b1a:	64a2                	ld	s1,8(sp)
    80005b1c:	6902                	ld	s2,0(sp)
    80005b1e:	6105                	addi	sp,sp,32
    80005b20:	8082                	ret

0000000080005b22 <mbuffree>:
{
    80005b22:	1141                	addi	sp,sp,-16
    80005b24:	e406                	sd	ra,8(sp)
    80005b26:	e022                	sd	s0,0(sp)
    80005b28:	0800                	addi	s0,sp,16
  kfree(m);
    80005b2a:	ffffa097          	auipc	ra,0xffffa
    80005b2e:	4f2080e7          	jalr	1266(ra) # 8000001c <kfree>
}
    80005b32:	60a2                	ld	ra,8(sp)
    80005b34:	6402                	ld	s0,0(sp)
    80005b36:	0141                	addi	sp,sp,16
    80005b38:	8082                	ret

0000000080005b3a <mbufq_pushtail>:
{
    80005b3a:	1141                	addi	sp,sp,-16
    80005b3c:	e422                	sd	s0,8(sp)
    80005b3e:	0800                	addi	s0,sp,16
  m->next = 0;
    80005b40:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005b44:	611c                	ld	a5,0(a0)
    80005b46:	c799                	beqz	a5,80005b54 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005b48:	651c                	ld	a5,8(a0)
    80005b4a:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005b4c:	e50c                	sd	a1,8(a0)
}
    80005b4e:	6422                	ld	s0,8(sp)
    80005b50:	0141                	addi	sp,sp,16
    80005b52:	8082                	ret
    q->head = q->tail = m;
    80005b54:	e50c                	sd	a1,8(a0)
    80005b56:	e10c                	sd	a1,0(a0)
    return;
    80005b58:	bfdd                	j	80005b4e <mbufq_pushtail+0x14>

0000000080005b5a <mbufq_pophead>:
{
    80005b5a:	1141                	addi	sp,sp,-16
    80005b5c:	e422                	sd	s0,8(sp)
    80005b5e:	0800                	addi	s0,sp,16
    80005b60:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005b62:	6108                	ld	a0,0(a0)
  if (!head)
    80005b64:	c119                	beqz	a0,80005b6a <mbufq_pophead+0x10>
  q->head = head->next;
    80005b66:	6118                	ld	a4,0(a0)
    80005b68:	e398                	sd	a4,0(a5)
}
    80005b6a:	6422                	ld	s0,8(sp)
    80005b6c:	0141                	addi	sp,sp,16
    80005b6e:	8082                	ret

0000000080005b70 <mbufq_empty>:
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e422                	sd	s0,8(sp)
    80005b74:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005b76:	6108                	ld	a0,0(a0)
}
    80005b78:	00153513          	seqz	a0,a0
    80005b7c:	6422                	ld	s0,8(sp)
    80005b7e:	0141                	addi	sp,sp,16
    80005b80:	8082                	ret

0000000080005b82 <mbufq_init>:
{
    80005b82:	1141                	addi	sp,sp,-16
    80005b84:	e422                	sd	s0,8(sp)
    80005b86:	0800                	addi	s0,sp,16
  q->head = 0;
    80005b88:	00053023          	sd	zero,0(a0)
}
    80005b8c:	6422                	ld	s0,8(sp)
    80005b8e:	0141                	addi	sp,sp,16
    80005b90:	8082                	ret

0000000080005b92 <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005b92:	7179                	addi	sp,sp,-48
    80005b94:	f406                	sd	ra,40(sp)
    80005b96:	f022                	sd	s0,32(sp)
    80005b98:	ec26                	sd	s1,24(sp)
    80005b9a:	e84a                	sd	s2,16(sp)
    80005b9c:	e44e                	sd	s3,8(sp)
    80005b9e:	e052                	sd	s4,0(sp)
    80005ba0:	1800                	addi	s0,sp,48
    80005ba2:	89aa                	mv	s3,a0
    80005ba4:	892e                	mv	s2,a1
    80005ba6:	8a32                	mv	s4,a2
    80005ba8:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005baa:	45a1                	li	a1,8
    80005bac:	00000097          	auipc	ra,0x0
    80005bb0:	e14080e7          	jalr	-492(ra) # 800059c0 <mbufpush>
    80005bb4:	008a179b          	slliw	a5,s4,0x8
    80005bb8:	008a5a1b          	srliw	s4,s4,0x8
    80005bbc:	0147e7b3          	or	a5,a5,s4
  udphdr->sport = htons(sport);
    80005bc0:	00f51023          	sh	a5,0(a0)
    80005bc4:	0084979b          	slliw	a5,s1,0x8
    80005bc8:	0084d49b          	srliw	s1,s1,0x8
    80005bcc:	8fc5                	or	a5,a5,s1
  udphdr->dport = htons(dport);
    80005bce:	00f51123          	sh	a5,2(a0)
  udphdr->ulen = htons(m->len);
    80005bd2:	0109a783          	lw	a5,16(s3)
    80005bd6:	0087971b          	slliw	a4,a5,0x8
    80005bda:	0107979b          	slliw	a5,a5,0x10
    80005bde:	0107d79b          	srliw	a5,a5,0x10
    80005be2:	0087d79b          	srliw	a5,a5,0x8
    80005be6:	8fd9                	or	a5,a5,a4
    80005be8:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005bec:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005bf0:	45d1                	li	a1,20
    80005bf2:	854e                	mv	a0,s3
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	dcc080e7          	jalr	-564(ra) # 800059c0 <mbufpush>
    80005bfc:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005bfe:	4651                	li	a2,20
    80005c00:	4581                	li	a1,0
    80005c02:	ffffa097          	auipc	ra,0xffffa
    80005c06:	578080e7          	jalr	1400(ra) # 8000017a <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005c0a:	04500793          	li	a5,69
    80005c0e:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005c12:	47c5                	li	a5,17
    80005c14:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005c18:	0f0207b7          	lui	a5,0xf020
    80005c1c:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80005c1e:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005c20:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005c24:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005c28:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005c2a:	0089171b          	slliw	a4,s2,0x8
    80005c2e:	00ff06b7          	lui	a3,0xff0
    80005c32:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005c34:	8fd9                	or	a5,a5,a4
    80005c36:	0089591b          	srliw	s2,s2,0x8
    80005c3a:	6741                	lui	a4,0x10
    80005c3c:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005c40:	00e97933          	and	s2,s2,a4
    80005c44:	0127e7b3          	or	a5,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005c48:	c89c                	sw	a5,16(s1)
  iphdr->ip_len = htons(m->len);
    80005c4a:	0109a783          	lw	a5,16(s3)
  return (((val & 0x00ffU) << 8) |
    80005c4e:	0087971b          	slliw	a4,a5,0x8
    80005c52:	0107979b          	slliw	a5,a5,0x10
    80005c56:	0107d79b          	srliw	a5,a5,0x10
    80005c5a:	0087d79b          	srliw	a5,a5,0x8
    80005c5e:	8fd9                	or	a5,a5,a4
    80005c60:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005c64:	06400793          	li	a5,100
    80005c68:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005c6c:	45d1                	li	a1,20
    80005c6e:	8526                	mv	a0,s1
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	cbe080e7          	jalr	-834(ra) # 8000592e <in_cksum>
    80005c78:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005c7c:	6585                	lui	a1,0x1
    80005c7e:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005c82:	854e                	mv	a0,s3
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	d72080e7          	jalr	-654(ra) # 800059f6 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005c8c:	70a2                	ld	ra,40(sp)
    80005c8e:	7402                	ld	s0,32(sp)
    80005c90:	64e2                	ld	s1,24(sp)
    80005c92:	6942                	ld	s2,16(sp)
    80005c94:	69a2                	ld	s3,8(sp)
    80005c96:	6a02                	ld	s4,0(sp)
    80005c98:	6145                	addi	sp,sp,48
    80005c9a:	8082                	ret

0000000080005c9c <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005c9c:	715d                	addi	sp,sp,-80
    80005c9e:	e486                	sd	ra,72(sp)
    80005ca0:	e0a2                	sd	s0,64(sp)
    80005ca2:	fc26                	sd	s1,56(sp)
    80005ca4:	f84a                	sd	s2,48(sp)
    80005ca6:	f44e                	sd	s3,40(sp)
    80005ca8:	f052                	sd	s4,32(sp)
    80005caa:	ec56                	sd	s5,24(sp)
    80005cac:	0880                	addi	s0,sp,80
    80005cae:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005cb0:	45b9                	li	a1,14
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	ce8080e7          	jalr	-792(ra) # 8000599a <mbufpull>
  if (!ethhdr) {
    80005cba:	cd15                	beqz	a0,80005cf6 <net_rx+0x5a>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005cbc:	00c54683          	lbu	a3,12(a0)
    80005cc0:	00d54783          	lbu	a5,13(a0)
    80005cc4:	07a2                	slli	a5,a5,0x8
    80005cc6:	00d7e733          	or	a4,a5,a3
  if (type == ETHTYPE_IP)
    80005cca:	46a1                	li	a3,8
    80005ccc:	02d70b63          	beq	a4,a3,80005d02 <net_rx+0x66>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005cd0:	2701                	sext.w	a4,a4
    80005cd2:	60800793          	li	a5,1544
    80005cd6:	16f70863          	beq	a4,a5,80005e46 <net_rx+0x1aa>
  kfree(m);
    80005cda:	8526                	mv	a0,s1
    80005cdc:	ffffa097          	auipc	ra,0xffffa
    80005ce0:	340080e7          	jalr	832(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005ce4:	60a6                	ld	ra,72(sp)
    80005ce6:	6406                	ld	s0,64(sp)
    80005ce8:	74e2                	ld	s1,56(sp)
    80005cea:	7942                	ld	s2,48(sp)
    80005cec:	79a2                	ld	s3,40(sp)
    80005cee:	7a02                	ld	s4,32(sp)
    80005cf0:	6ae2                	ld	s5,24(sp)
    80005cf2:	6161                	addi	sp,sp,80
    80005cf4:	8082                	ret
  kfree(m);
    80005cf6:	8526                	mv	a0,s1
    80005cf8:	ffffa097          	auipc	ra,0xffffa
    80005cfc:	324080e7          	jalr	804(ra) # 8000001c <kfree>
}
    80005d00:	b7d5                	j	80005ce4 <net_rx+0x48>
  iphdr = mbufpullhdr(m, *iphdr);
    80005d02:	45d1                	li	a1,20
    80005d04:	8526                	mv	a0,s1
    80005d06:	00000097          	auipc	ra,0x0
    80005d0a:	c94080e7          	jalr	-876(ra) # 8000599a <mbufpull>
    80005d0e:	892a                	mv	s2,a0
  if (!iphdr)
    80005d10:	c125                	beqz	a0,80005d70 <net_rx+0xd4>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005d12:	00054703          	lbu	a4,0(a0)
    80005d16:	04500793          	li	a5,69
    80005d1a:	04f71b63          	bne	a4,a5,80005d70 <net_rx+0xd4>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005d1e:	45d1                	li	a1,20
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	c0e080e7          	jalr	-1010(ra) # 8000592e <in_cksum>
    80005d28:	e521                	bnez	a0,80005d70 <net_rx+0xd4>
  if (htons(iphdr->ip_off) != 0)
    80005d2a:	00695783          	lhu	a5,6(s2)
    80005d2e:	e3a9                	bnez	a5,80005d70 <net_rx+0xd4>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005d30:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005d34:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005d38:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005d3c:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005d3e:	0087169b          	slliw	a3,a4,0x8
    80005d42:	00ff0637          	lui	a2,0xff0
    80005d46:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005d48:	8fd5                	or	a5,a5,a3
    80005d4a:	0087571b          	srliw	a4,a4,0x8
    80005d4e:	66c1                	lui	a3,0x10
    80005d50:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005d54:	8f75                	and	a4,a4,a3
    80005d56:	8fd9                	or	a5,a5,a4
    80005d58:	2781                	sext.w	a5,a5
    80005d5a:	0a000737          	lui	a4,0xa000
    80005d5e:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005d62:	00e79763          	bne	a5,a4,80005d70 <net_rx+0xd4>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005d66:	00994703          	lbu	a4,9(s2)
    80005d6a:	47c5                	li	a5,17
    80005d6c:	00f70863          	beq	a4,a5,80005d7c <net_rx+0xe0>
  kfree(m);
    80005d70:	8526                	mv	a0,s1
    80005d72:	ffffa097          	auipc	ra,0xffffa
    80005d76:	2aa080e7          	jalr	682(ra) # 8000001c <kfree>
}
    80005d7a:	b7ad                	j	80005ce4 <net_rx+0x48>
  return (((val & 0x00ffU) << 8) |
    80005d7c:	00295783          	lhu	a5,2(s2)
    80005d80:	0087971b          	slliw	a4,a5,0x8
    80005d84:	83a1                	srli	a5,a5,0x8
    80005d86:	8fd9                	or	a5,a5,a4
    80005d88:	03079993          	slli	s3,a5,0x30
    80005d8c:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005d90:	fec9879b          	addiw	a5,s3,-20
    80005d94:	03079a13          	slli	s4,a5,0x30
    80005d98:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005d9c:	45a1                	li	a1,8
    80005d9e:	8526                	mv	a0,s1
    80005da0:	00000097          	auipc	ra,0x0
    80005da4:	bfa080e7          	jalr	-1030(ra) # 8000599a <mbufpull>
    80005da8:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005daa:	c51d                	beqz	a0,80005dd8 <net_rx+0x13c>
    80005dac:	00455783          	lhu	a5,4(a0)
    80005db0:	0087971b          	slliw	a4,a5,0x8
    80005db4:	83a1                	srli	a5,a5,0x8
    80005db6:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80005db8:	2a01                	sext.w	s4,s4
    80005dba:	17c2                	slli	a5,a5,0x30
    80005dbc:	93c1                	srli	a5,a5,0x30
    80005dbe:	00fa1d63          	bne	s4,a5,80005dd8 <net_rx+0x13c>
  len -= sizeof(*udphdr);
    80005dc2:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005dc6:	0107979b          	slliw	a5,a5,0x10
    80005dca:	0107d79b          	srliw	a5,a5,0x10
    80005dce:	0007871b          	sext.w	a4,a5
    80005dd2:	488c                	lw	a1,16(s1)
    80005dd4:	00e5f863          	bgeu	a1,a4,80005de4 <net_rx+0x148>
  kfree(m);
    80005dd8:	8526                	mv	a0,s1
    80005dda:	ffffa097          	auipc	ra,0xffffa
    80005dde:	242080e7          	jalr	578(ra) # 8000001c <kfree>
}
    80005de2:	b709                	j	80005ce4 <net_rx+0x48>
  mbuftrim(m, m->len - len);
    80005de4:	9d9d                	subw	a1,a1,a5
    80005de6:	8526                	mv	a0,s1
    80005de8:	00000097          	auipc	ra,0x0
    80005dec:	cc0080e7          	jalr	-832(ra) # 80005aa8 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005df0:	00c92783          	lw	a5,12(s2)
    80005df4:	000ad703          	lhu	a4,0(s5)
    80005df8:	0087169b          	slliw	a3,a4,0x8
    80005dfc:	8321                	srli	a4,a4,0x8
    80005dfe:	8ed9                	or	a3,a3,a4
    80005e00:	002ad703          	lhu	a4,2(s5)
    80005e04:	0087161b          	slliw	a2,a4,0x8
    80005e08:	8321                	srli	a4,a4,0x8
    80005e0a:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005e0c:	0187959b          	slliw	a1,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005e10:	0187d71b          	srliw	a4,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005e14:	8dd9                	or	a1,a1,a4
          ((val & 0x0000ff00UL) << 8) |
    80005e16:	0087971b          	slliw	a4,a5,0x8
    80005e1a:	00ff0537          	lui	a0,0xff0
    80005e1e:	8f69                	and	a4,a4,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005e20:	8dd9                	or	a1,a1,a4
    80005e22:	0087d79b          	srliw	a5,a5,0x8
    80005e26:	6741                	lui	a4,0x10
    80005e28:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005e2c:	8ff9                	and	a5,a5,a4
    80005e2e:	8ddd                	or	a1,a1,a5
  sockrecvudp(m, sip, dport, sport);
    80005e30:	16c2                	slli	a3,a3,0x30
    80005e32:	92c1                	srli	a3,a3,0x30
    80005e34:	1642                	slli	a2,a2,0x30
    80005e36:	9241                	srli	a2,a2,0x30
    80005e38:	2581                	sext.w	a1,a1
    80005e3a:	8526                	mv	a0,s1
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	53a080e7          	jalr	1338(ra) # 80006376 <sockrecvudp>
  return;
    80005e44:	b545                	j	80005ce4 <net_rx+0x48>
  arphdr = mbufpullhdr(m, *arphdr);
    80005e46:	45f1                	li	a1,28
    80005e48:	8526                	mv	a0,s1
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b50080e7          	jalr	-1200(ra) # 8000599a <mbufpull>
    80005e52:	892a                	mv	s2,a0
  if (!arphdr)
    80005e54:	c14d                	beqz	a0,80005ef6 <net_rx+0x25a>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80005e56:	00054703          	lbu	a4,0(a0) # ff0000 <_entry-0x7f010000>
    80005e5a:	00154783          	lbu	a5,1(a0)
    80005e5e:	07a2                	slli	a5,a5,0x8
    80005e60:	8fd9                	or	a5,a5,a4
    80005e62:	10000713          	li	a4,256
    80005e66:	08e79863          	bne	a5,a4,80005ef6 <net_rx+0x25a>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80005e6a:	00254703          	lbu	a4,2(a0)
    80005e6e:	00354783          	lbu	a5,3(a0)
    80005e72:	07a2                	slli	a5,a5,0x8
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80005e74:	8fd9                	or	a5,a5,a4
    80005e76:	4721                	li	a4,8
    80005e78:	06e79f63          	bne	a5,a4,80005ef6 <net_rx+0x25a>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80005e7c:	00454703          	lbu	a4,4(a0)
    80005e80:	4799                	li	a5,6
    80005e82:	06f71a63          	bne	a4,a5,80005ef6 <net_rx+0x25a>
      arphdr->hln != ETHADDR_LEN ||
    80005e86:	00554703          	lbu	a4,5(a0)
    80005e8a:	4791                	li	a5,4
    80005e8c:	06f71563          	bne	a4,a5,80005ef6 <net_rx+0x25a>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80005e90:	00654703          	lbu	a4,6(a0)
    80005e94:	00754783          	lbu	a5,7(a0)
    80005e98:	07a2                	slli	a5,a5,0x8
    80005e9a:	8fd9                	or	a5,a5,a4
    80005e9c:	10000713          	li	a4,256
    80005ea0:	04e79b63          	bne	a5,a4,80005ef6 <net_rx+0x25a>
  tip = ntohl(arphdr->tip); // target IP address
    80005ea4:	01854703          	lbu	a4,24(a0)
    80005ea8:	01954783          	lbu	a5,25(a0)
    80005eac:	07a2                	slli	a5,a5,0x8
    80005eae:	8fd9                	or	a5,a5,a4
    80005eb0:	01a54703          	lbu	a4,26(a0)
    80005eb4:	0742                	slli	a4,a4,0x10
    80005eb6:	8f5d                	or	a4,a4,a5
    80005eb8:	01b54783          	lbu	a5,27(a0)
    80005ebc:	07e2                	slli	a5,a5,0x18
    80005ebe:	8fd9                	or	a5,a5,a4
    80005ec0:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    80005ec4:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005ec8:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005ecc:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005ece:	0087169b          	slliw	a3,a4,0x8
    80005ed2:	00ff0637          	lui	a2,0xff0
    80005ed6:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005ed8:	8fd5                	or	a5,a5,a3
    80005eda:	0087571b          	srliw	a4,a4,0x8
    80005ede:	66c1                	lui	a3,0x10
    80005ee0:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005ee4:	8f75                	and	a4,a4,a3
    80005ee6:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80005ee8:	2781                	sext.w	a5,a5
    80005eea:	0a000737          	lui	a4,0xa000
    80005eee:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005ef2:	00e78863          	beq	a5,a4,80005f02 <net_rx+0x266>
  kfree(m);
    80005ef6:	8526                	mv	a0,s1
    80005ef8:	ffffa097          	auipc	ra,0xffffa
    80005efc:	124080e7          	jalr	292(ra) # 8000001c <kfree>
}
    80005f00:	b3d5                	j	80005ce4 <net_rx+0x48>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    80005f02:	4619                	li	a2,6
    80005f04:	00850593          	addi	a1,a0,8
    80005f08:	fb840513          	addi	a0,s0,-72
    80005f0c:	ffffa097          	auipc	ra,0xffffa
    80005f10:	2ca080e7          	jalr	714(ra) # 800001d6 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    80005f14:	00e94703          	lbu	a4,14(s2)
    80005f18:	00f94783          	lbu	a5,15(s2)
    80005f1c:	07a2                	slli	a5,a5,0x8
    80005f1e:	8fd9                	or	a5,a5,a4
    80005f20:	01094703          	lbu	a4,16(s2)
    80005f24:	0742                	slli	a4,a4,0x10
    80005f26:	8f5d                	or	a4,a4,a5
    80005f28:	01194783          	lbu	a5,17(s2)
    80005f2c:	07e2                	slli	a5,a5,0x18
    80005f2e:	8fd9                	or	a5,a5,a4
    80005f30:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    80005f34:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005f38:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f3c:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    80005f40:	0087179b          	slliw	a5,a4,0x8
    80005f44:	00ff06b7          	lui	a3,0xff0
    80005f48:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005f4a:	00f96933          	or	s2,s2,a5
    80005f4e:	0087579b          	srliw	a5,a4,0x8
    80005f52:	6741                	lui	a4,0x10
    80005f54:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005f58:	8ff9                	and	a5,a5,a4
    80005f5a:	00f96933          	or	s2,s2,a5
    80005f5e:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80005f60:	08000513          	li	a0,128
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	b66080e7          	jalr	-1178(ra) # 80005aca <mbufalloc>
    80005f6c:	8a2a                	mv	s4,a0
  if (!m)
    80005f6e:	d541                	beqz	a0,80005ef6 <net_rx+0x25a>
  arphdr = mbufputhdr(m, *arphdr);
    80005f70:	45f1                	li	a1,28
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	afc080e7          	jalr	-1284(ra) # 80005a6e <mbufput>
    80005f7a:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    80005f7c:	00050023          	sb	zero,0(a0)
    80005f80:	4785                	li	a5,1
    80005f82:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    80005f86:	47a1                	li	a5,8
    80005f88:	00f50123          	sb	a5,2(a0)
    80005f8c:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80005f90:	4799                	li	a5,6
    80005f92:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    80005f96:	4791                	li	a5,4
    80005f98:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    80005f9c:	00050323          	sb	zero,6(a0)
    80005fa0:	4a89                	li	s5,2
    80005fa2:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    80005fa6:	4619                	li	a2,6
    80005fa8:	00004597          	auipc	a1,0x4
    80005fac:	94858593          	addi	a1,a1,-1720 # 800098f0 <local_mac>
    80005fb0:	0521                	addi	a0,a0,8
    80005fb2:	ffffa097          	auipc	ra,0xffffa
    80005fb6:	224080e7          	jalr	548(ra) # 800001d6 <memmove>
  arphdr->sip = htonl(local_ip);
    80005fba:	47a9                	li	a5,10
    80005fbc:	00f98723          	sb	a5,14(s3)
    80005fc0:	000987a3          	sb	zero,15(s3)
    80005fc4:	01598823          	sb	s5,16(s3)
    80005fc8:	47bd                	li	a5,15
    80005fca:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    80005fce:	4619                	li	a2,6
    80005fd0:	fb840593          	addi	a1,s0,-72
    80005fd4:	01298513          	addi	a0,s3,18
    80005fd8:	ffffa097          	auipc	ra,0xffffa
    80005fdc:	1fe080e7          	jalr	510(ra) # 800001d6 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    80005fe0:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    80005fe4:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005fe8:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    80005fea:	0089179b          	slliw	a5,s2,0x8
    80005fee:	00ff06b7          	lui	a3,0xff0
    80005ff2:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005ff4:	8f5d                	or	a4,a4,a5
    80005ff6:	0089579b          	srliw	a5,s2,0x8
    80005ffa:	66c1                	lui	a3,0x10
    80005ffc:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80006000:	8ff5                	and	a5,a5,a3
    80006002:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    80006004:	00e98c23          	sb	a4,24(s3)
    80006008:	0087d71b          	srliw	a4,a5,0x8
    8000600c:	00e98ca3          	sb	a4,25(s3)
    80006010:	0107d71b          	srliw	a4,a5,0x10
    80006014:	00e98d23          	sb	a4,26(s3)
    80006018:	0187d79b          	srliw	a5,a5,0x18
    8000601c:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    80006020:	6585                	lui	a1,0x1
    80006022:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    80006026:	8552                	mv	a0,s4
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	9ce080e7          	jalr	-1586(ra) # 800059f6 <net_tx_eth>
  return 0;
    80006030:	b5d9                	j	80005ef6 <net_rx+0x25a>

0000000080006032 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    80006032:	1141                	addi	sp,sp,-16
    80006034:	e406                	sd	ra,8(sp)
    80006036:	e022                	sd	s0,0(sp)
    80006038:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    8000603a:	00004597          	auipc	a1,0x4
    8000603e:	81658593          	addi	a1,a1,-2026 # 80009850 <syscalls+0x470>
    80006042:	00015517          	auipc	a0,0x15
    80006046:	0de50513          	addi	a0,a0,222 # 8001b120 <lock>
    8000604a:	00001097          	auipc	ra,0x1
    8000604e:	e48080e7          	jalr	-440(ra) # 80006e92 <initlock>
}
    80006052:	60a2                	ld	ra,8(sp)
    80006054:	6402                	ld	s0,0(sp)
    80006056:	0141                	addi	sp,sp,16
    80006058:	8082                	ret

000000008000605a <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    8000605a:	7139                	addi	sp,sp,-64
    8000605c:	fc06                	sd	ra,56(sp)
    8000605e:	f822                	sd	s0,48(sp)
    80006060:	f426                	sd	s1,40(sp)
    80006062:	f04a                	sd	s2,32(sp)
    80006064:	ec4e                	sd	s3,24(sp)
    80006066:	e852                	sd	s4,16(sp)
    80006068:	e456                	sd	s5,8(sp)
    8000606a:	0080                	addi	s0,sp,64
    8000606c:	892a                	mv	s2,a0
    8000606e:	84ae                	mv	s1,a1
    80006070:	8a32                	mv	s4,a2
    80006072:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    80006074:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006078:	ffffe097          	auipc	ra,0xffffe
    8000607c:	87c080e7          	jalr	-1924(ra) # 800038f4 <filealloc>
    80006080:	00a93023          	sd	a0,0(s2)
    80006084:	c975                	beqz	a0,80006178 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    80006086:	ffffa097          	auipc	ra,0xffffa
    8000608a:	094080e7          	jalr	148(ra) # 8000011a <kalloc>
    8000608e:	8aaa                	mv	s5,a0
    80006090:	c15d                	beqz	a0,80006136 <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    80006092:	c504                	sw	s1,8(a0)
  si->lport = lport;
    80006094:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006098:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    8000609c:	00003597          	auipc	a1,0x3
    800060a0:	7bc58593          	addi	a1,a1,1980 # 80009858 <syscalls+0x478>
    800060a4:	0541                	addi	a0,a0,16
    800060a6:	00001097          	auipc	ra,0x1
    800060aa:	dec080e7          	jalr	-532(ra) # 80006e92 <initlock>
  mbufq_init(&si->rxq);
    800060ae:	028a8513          	addi	a0,s5,40
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	ad0080e7          	jalr	-1328(ra) # 80005b82 <mbufq_init>
  (*f)->type = FD_SOCK;
    800060ba:	00093783          	ld	a5,0(s2)
    800060be:	4711                	li	a4,4
    800060c0:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    800060c2:	00093703          	ld	a4,0(s2)
    800060c6:	4785                	li	a5,1
    800060c8:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    800060cc:	00093703          	ld	a4,0(s2)
    800060d0:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    800060d4:	00093783          	ld	a5,0(s2)
    800060d8:	0357b023          	sd	s5,32(a5)

  // add to list of sockets
  acquire(&lock);
    800060dc:	00015517          	auipc	a0,0x15
    800060e0:	04450513          	addi	a0,a0,68 # 8001b120 <lock>
    800060e4:	00001097          	auipc	ra,0x1
    800060e8:	e3e080e7          	jalr	-450(ra) # 80006f22 <acquire>
  pos = sockets;
    800060ec:	00004597          	auipc	a1,0x4
    800060f0:	89c5b583          	ld	a1,-1892(a1) # 80009988 <sockets>
  while (pos) {
    800060f4:	c9b1                	beqz	a1,80006148 <sockalloc+0xee>
  pos = sockets;
    800060f6:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    800060f8:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    800060fc:	0009869b          	sext.w	a3,s3
    80006100:	a019                	j	80006106 <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    80006102:	639c                	ld	a5,0(a5)
  while (pos) {
    80006104:	c3b1                	beqz	a5,80006148 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    80006106:	4798                	lw	a4,8(a5)
    80006108:	fe971de3          	bne	a4,s1,80006102 <sockalloc+0xa8>
    8000610c:	00c7d703          	lhu	a4,12(a5)
    80006110:	fec719e3          	bne	a4,a2,80006102 <sockalloc+0xa8>
        pos->lport == lport &&
    80006114:	00e7d703          	lhu	a4,14(a5)
    80006118:	fed715e3          	bne	a4,a3,80006102 <sockalloc+0xa8>
      release(&lock);
    8000611c:	00015517          	auipc	a0,0x15
    80006120:	00450513          	addi	a0,a0,4 # 8001b120 <lock>
    80006124:	00001097          	auipc	ra,0x1
    80006128:	eb2080e7          	jalr	-334(ra) # 80006fd6 <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    8000612c:	8556                	mv	a0,s5
    8000612e:	ffffa097          	auipc	ra,0xffffa
    80006132:	eee080e7          	jalr	-274(ra) # 8000001c <kfree>
  if (*f)
    80006136:	00093503          	ld	a0,0(s2)
    8000613a:	c129                	beqz	a0,8000617c <sockalloc+0x122>
    fileclose(*f);
    8000613c:	ffffe097          	auipc	ra,0xffffe
    80006140:	874080e7          	jalr	-1932(ra) # 800039b0 <fileclose>
  return -1;
    80006144:	557d                	li	a0,-1
    80006146:	a005                	j	80006166 <sockalloc+0x10c>
  si->next = sockets;
    80006148:	00bab023          	sd	a1,0(s5)
  sockets = si;
    8000614c:	00004797          	auipc	a5,0x4
    80006150:	8357be23          	sd	s5,-1988(a5) # 80009988 <sockets>
  release(&lock);
    80006154:	00015517          	auipc	a0,0x15
    80006158:	fcc50513          	addi	a0,a0,-52 # 8001b120 <lock>
    8000615c:	00001097          	auipc	ra,0x1
    80006160:	e7a080e7          	jalr	-390(ra) # 80006fd6 <release>
  return 0;
    80006164:	4501                	li	a0,0
}
    80006166:	70e2                	ld	ra,56(sp)
    80006168:	7442                	ld	s0,48(sp)
    8000616a:	74a2                	ld	s1,40(sp)
    8000616c:	7902                	ld	s2,32(sp)
    8000616e:	69e2                	ld	s3,24(sp)
    80006170:	6a42                	ld	s4,16(sp)
    80006172:	6aa2                	ld	s5,8(sp)
    80006174:	6121                	addi	sp,sp,64
    80006176:	8082                	ret
  return -1;
    80006178:	557d                	li	a0,-1
    8000617a:	b7f5                	j	80006166 <sockalloc+0x10c>
    8000617c:	557d                	li	a0,-1
    8000617e:	b7e5                	j	80006166 <sockalloc+0x10c>

0000000080006180 <sockclose>:

void
sockclose(struct sock *si)
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	e426                	sd	s1,8(sp)
    80006188:	e04a                	sd	s2,0(sp)
    8000618a:	1000                	addi	s0,sp,32
    8000618c:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    8000618e:	00015517          	auipc	a0,0x15
    80006192:	f9250513          	addi	a0,a0,-110 # 8001b120 <lock>
    80006196:	00001097          	auipc	ra,0x1
    8000619a:	d8c080e7          	jalr	-628(ra) # 80006f22 <acquire>
  pos = &sockets;
    8000619e:	00003797          	auipc	a5,0x3
    800061a2:	7ea7b783          	ld	a5,2026(a5) # 80009988 <sockets>
  while (*pos) {
    800061a6:	cb99                	beqz	a5,800061bc <sockclose+0x3c>
    if (*pos == si){
    800061a8:	04f90463          	beq	s2,a5,800061f0 <sockclose+0x70>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    800061ac:	873e                	mv	a4,a5
    800061ae:	639c                	ld	a5,0(a5)
  while (*pos) {
    800061b0:	c791                	beqz	a5,800061bc <sockclose+0x3c>
    if (*pos == si){
    800061b2:	fef91de3          	bne	s2,a5,800061ac <sockclose+0x2c>
      *pos = si->next;
    800061b6:	00093783          	ld	a5,0(s2)
    800061ba:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    800061bc:	00015517          	auipc	a0,0x15
    800061c0:	f6450513          	addi	a0,a0,-156 # 8001b120 <lock>
    800061c4:	00001097          	auipc	ra,0x1
    800061c8:	e12080e7          	jalr	-494(ra) # 80006fd6 <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    800061cc:	02890493          	addi	s1,s2,40
    800061d0:	8526                	mv	a0,s1
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	99e080e7          	jalr	-1634(ra) # 80005b70 <mbufq_empty>
    800061da:	e105                	bnez	a0,800061fa <sockclose+0x7a>
    m = mbufq_pophead(&si->rxq);
    800061dc:	8526                	mv	a0,s1
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	97c080e7          	jalr	-1668(ra) # 80005b5a <mbufq_pophead>
    mbuffree(m);
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	93c080e7          	jalr	-1732(ra) # 80005b22 <mbuffree>
    800061ee:	b7cd                	j	800061d0 <sockclose+0x50>
  pos = &sockets;
    800061f0:	00003717          	auipc	a4,0x3
    800061f4:	79870713          	addi	a4,a4,1944 # 80009988 <sockets>
    800061f8:	bf7d                	j	800061b6 <sockclose+0x36>
  }

  kfree((char*)si);
    800061fa:	854a                	mv	a0,s2
    800061fc:	ffffa097          	auipc	ra,0xffffa
    80006200:	e20080e7          	jalr	-480(ra) # 8000001c <kfree>
}
    80006204:	60e2                	ld	ra,24(sp)
    80006206:	6442                	ld	s0,16(sp)
    80006208:	64a2                	ld	s1,8(sp)
    8000620a:	6902                	ld	s2,0(sp)
    8000620c:	6105                	addi	sp,sp,32
    8000620e:	8082                	ret

0000000080006210 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    80006210:	7139                	addi	sp,sp,-64
    80006212:	fc06                	sd	ra,56(sp)
    80006214:	f822                	sd	s0,48(sp)
    80006216:	f426                	sd	s1,40(sp)
    80006218:	f04a                	sd	s2,32(sp)
    8000621a:	ec4e                	sd	s3,24(sp)
    8000621c:	e852                	sd	s4,16(sp)
    8000621e:	e456                	sd	s5,8(sp)
    80006220:	0080                	addi	s0,sp,64
    80006222:	84aa                	mv	s1,a0
    80006224:	8a2e                	mv	s4,a1
    80006226:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    80006228:	ffffb097          	auipc	ra,0xffffb
    8000622c:	c82080e7          	jalr	-894(ra) # 80000eaa <myproc>
    80006230:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    80006232:	01048993          	addi	s3,s1,16
    80006236:	854e                	mv	a0,s3
    80006238:	00001097          	auipc	ra,0x1
    8000623c:	cea080e7          	jalr	-790(ra) # 80006f22 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    80006240:	02848493          	addi	s1,s1,40
    80006244:	a039                	j	80006252 <sockread+0x42>
    sleep(&si->rxq, &si->lock);
    80006246:	85ce                	mv	a1,s3
    80006248:	8526                	mv	a0,s1
    8000624a:	ffffb097          	auipc	ra,0xffffb
    8000624e:	308080e7          	jalr	776(ra) # 80001552 <sleep>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    80006252:	8526                	mv	a0,s1
    80006254:	00000097          	auipc	ra,0x0
    80006258:	91c080e7          	jalr	-1764(ra) # 80005b70 <mbufq_empty>
    8000625c:	c919                	beqz	a0,80006272 <sockread+0x62>
    8000625e:	02892783          	lw	a5,40(s2)
    80006262:	d3f5                	beqz	a5,80006246 <sockread+0x36>
  }
  if (pr->killed) {
    release(&si->lock);
    80006264:	854e                	mv	a0,s3
    80006266:	00001097          	auipc	ra,0x1
    8000626a:	d70080e7          	jalr	-656(ra) # 80006fd6 <release>
    return -1;
    8000626e:	59fd                	li	s3,-1
    80006270:	a881                	j	800062c0 <sockread+0xb0>
  if (pr->killed) {
    80006272:	02892783          	lw	a5,40(s2)
    80006276:	f7fd                	bnez	a5,80006264 <sockread+0x54>
  }
  m = mbufq_pophead(&si->rxq);
    80006278:	8526                	mv	a0,s1
    8000627a:	00000097          	auipc	ra,0x0
    8000627e:	8e0080e7          	jalr	-1824(ra) # 80005b5a <mbufq_pophead>
    80006282:	84aa                	mv	s1,a0
  release(&si->lock);
    80006284:	854e                	mv	a0,s3
    80006286:	00001097          	auipc	ra,0x1
    8000628a:	d50080e7          	jalr	-688(ra) # 80006fd6 <release>

  len = m->len;
  if (len > n)
    8000628e:	489c                	lw	a5,16(s1)
    80006290:	89be                	mv	s3,a5
    80006292:	2781                	sext.w	a5,a5
    80006294:	00fad363          	bge	s5,a5,8000629a <sockread+0x8a>
    80006298:	89d6                	mv	s3,s5
    8000629a:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    8000629c:	86ce                	mv	a3,s3
    8000629e:	6490                	ld	a2,8(s1)
    800062a0:	85d2                	mv	a1,s4
    800062a2:	05093503          	ld	a0,80(s2)
    800062a6:	ffffb097          	auipc	ra,0xffffb
    800062aa:	8c8080e7          	jalr	-1848(ra) # 80000b6e <copyout>
    800062ae:	892a                	mv	s2,a0
    800062b0:	57fd                	li	a5,-1
    800062b2:	02f50163          	beq	a0,a5,800062d4 <sockread+0xc4>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    800062b6:	8526                	mv	a0,s1
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	86a080e7          	jalr	-1942(ra) # 80005b22 <mbuffree>
  return len;
}
    800062c0:	854e                	mv	a0,s3
    800062c2:	70e2                	ld	ra,56(sp)
    800062c4:	7442                	ld	s0,48(sp)
    800062c6:	74a2                	ld	s1,40(sp)
    800062c8:	7902                	ld	s2,32(sp)
    800062ca:	69e2                	ld	s3,24(sp)
    800062cc:	6a42                	ld	s4,16(sp)
    800062ce:	6aa2                	ld	s5,8(sp)
    800062d0:	6121                	addi	sp,sp,64
    800062d2:	8082                	ret
    mbuffree(m);
    800062d4:	8526                	mv	a0,s1
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	84c080e7          	jalr	-1972(ra) # 80005b22 <mbuffree>
    return -1;
    800062de:	89ca                	mv	s3,s2
    800062e0:	b7c5                	j	800062c0 <sockread+0xb0>

00000000800062e2 <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    800062e2:	7139                	addi	sp,sp,-64
    800062e4:	fc06                	sd	ra,56(sp)
    800062e6:	f822                	sd	s0,48(sp)
    800062e8:	f426                	sd	s1,40(sp)
    800062ea:	f04a                	sd	s2,32(sp)
    800062ec:	ec4e                	sd	s3,24(sp)
    800062ee:	e852                	sd	s4,16(sp)
    800062f0:	e456                	sd	s5,8(sp)
    800062f2:	0080                	addi	s0,sp,64
    800062f4:	8aaa                	mv	s5,a0
    800062f6:	89ae                	mv	s3,a1
    800062f8:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    800062fa:	ffffb097          	auipc	ra,0xffffb
    800062fe:	bb0080e7          	jalr	-1104(ra) # 80000eaa <myproc>
    80006302:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006304:	08000513          	li	a0,128
    80006308:	fffff097          	auipc	ra,0xfffff
    8000630c:	7c2080e7          	jalr	1986(ra) # 80005aca <mbufalloc>
  if (!m)
    80006310:	c12d                	beqz	a0,80006372 <sockwrite+0x90>
    80006312:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    80006314:	050a3a03          	ld	s4,80(s4)
    80006318:	85ca                	mv	a1,s2
    8000631a:	fffff097          	auipc	ra,0xfffff
    8000631e:	754080e7          	jalr	1876(ra) # 80005a6e <mbufput>
    80006322:	85aa                	mv	a1,a0
    80006324:	86ca                	mv	a3,s2
    80006326:	864e                	mv	a2,s3
    80006328:	8552                	mv	a0,s4
    8000632a:	ffffb097          	auipc	ra,0xffffb
    8000632e:	8d0080e7          	jalr	-1840(ra) # 80000bfa <copyin>
    80006332:	89aa                	mv	s3,a0
    80006334:	57fd                	li	a5,-1
    80006336:	02f50863          	beq	a0,a5,80006366 <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    8000633a:	00ead683          	lhu	a3,14(s5)
    8000633e:	00cad603          	lhu	a2,12(s5)
    80006342:	008aa583          	lw	a1,8(s5)
    80006346:	8526                	mv	a0,s1
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	84a080e7          	jalr	-1974(ra) # 80005b92 <net_tx_udp>
  return n;
    80006350:	89ca                	mv	s3,s2
}
    80006352:	854e                	mv	a0,s3
    80006354:	70e2                	ld	ra,56(sp)
    80006356:	7442                	ld	s0,48(sp)
    80006358:	74a2                	ld	s1,40(sp)
    8000635a:	7902                	ld	s2,32(sp)
    8000635c:	69e2                	ld	s3,24(sp)
    8000635e:	6a42                	ld	s4,16(sp)
    80006360:	6aa2                	ld	s5,8(sp)
    80006362:	6121                	addi	sp,sp,64
    80006364:	8082                	ret
    mbuffree(m);
    80006366:	8526                	mv	a0,s1
    80006368:	fffff097          	auipc	ra,0xfffff
    8000636c:	7ba080e7          	jalr	1978(ra) # 80005b22 <mbuffree>
    return -1;
    80006370:	b7cd                	j	80006352 <sockwrite+0x70>
    return -1;
    80006372:	59fd                	li	s3,-1
    80006374:	bff9                	j	80006352 <sockwrite+0x70>

0000000080006376 <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    80006376:	7139                	addi	sp,sp,-64
    80006378:	fc06                	sd	ra,56(sp)
    8000637a:	f822                	sd	s0,48(sp)
    8000637c:	f426                	sd	s1,40(sp)
    8000637e:	f04a                	sd	s2,32(sp)
    80006380:	ec4e                	sd	s3,24(sp)
    80006382:	e852                	sd	s4,16(sp)
    80006384:	e456                	sd	s5,8(sp)
    80006386:	0080                	addi	s0,sp,64
    80006388:	8a2a                	mv	s4,a0
    8000638a:	892e                	mv	s2,a1
    8000638c:	89b2                	mv	s3,a2
    8000638e:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    80006390:	00015517          	auipc	a0,0x15
    80006394:	d9050513          	addi	a0,a0,-624 # 8001b120 <lock>
    80006398:	00001097          	auipc	ra,0x1
    8000639c:	b8a080e7          	jalr	-1142(ra) # 80006f22 <acquire>
  si = sockets;
    800063a0:	00003497          	auipc	s1,0x3
    800063a4:	5e84b483          	ld	s1,1512(s1) # 80009988 <sockets>
  while (si) {
    800063a8:	c4ad                	beqz	s1,80006412 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800063aa:	0009871b          	sext.w	a4,s3
    800063ae:	000a869b          	sext.w	a3,s5
    800063b2:	a019                	j	800063b8 <sockrecvudp+0x42>
      goto found;
    si = si->next;
    800063b4:	6084                	ld	s1,0(s1)
  while (si) {
    800063b6:	ccb1                	beqz	s1,80006412 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800063b8:	449c                	lw	a5,8(s1)
    800063ba:	ff279de3          	bne	a5,s2,800063b4 <sockrecvudp+0x3e>
    800063be:	00c4d783          	lhu	a5,12(s1)
    800063c2:	fee799e3          	bne	a5,a4,800063b4 <sockrecvudp+0x3e>
    800063c6:	00e4d783          	lhu	a5,14(s1)
    800063ca:	fed795e3          	bne	a5,a3,800063b4 <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    800063ce:	01048913          	addi	s2,s1,16
    800063d2:	854a                	mv	a0,s2
    800063d4:	00001097          	auipc	ra,0x1
    800063d8:	b4e080e7          	jalr	-1202(ra) # 80006f22 <acquire>
  mbufq_pushtail(&si->rxq, m);
    800063dc:	02848493          	addi	s1,s1,40
    800063e0:	85d2                	mv	a1,s4
    800063e2:	8526                	mv	a0,s1
    800063e4:	fffff097          	auipc	ra,0xfffff
    800063e8:	756080e7          	jalr	1878(ra) # 80005b3a <mbufq_pushtail>
  wakeup(&si->rxq);
    800063ec:	8526                	mv	a0,s1
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	1c8080e7          	jalr	456(ra) # 800015b6 <wakeup>
  release(&si->lock);
    800063f6:	854a                	mv	a0,s2
    800063f8:	00001097          	auipc	ra,0x1
    800063fc:	bde080e7          	jalr	-1058(ra) # 80006fd6 <release>
  release(&lock);
    80006400:	00015517          	auipc	a0,0x15
    80006404:	d2050513          	addi	a0,a0,-736 # 8001b120 <lock>
    80006408:	00001097          	auipc	ra,0x1
    8000640c:	bce080e7          	jalr	-1074(ra) # 80006fd6 <release>
    80006410:	a831                	j	8000642c <sockrecvudp+0xb6>
  release(&lock);
    80006412:	00015517          	auipc	a0,0x15
    80006416:	d0e50513          	addi	a0,a0,-754 # 8001b120 <lock>
    8000641a:	00001097          	auipc	ra,0x1
    8000641e:	bbc080e7          	jalr	-1092(ra) # 80006fd6 <release>
  mbuffree(m);
    80006422:	8552                	mv	a0,s4
    80006424:	fffff097          	auipc	ra,0xfffff
    80006428:	6fe080e7          	jalr	1790(ra) # 80005b22 <mbuffree>
}
    8000642c:	70e2                	ld	ra,56(sp)
    8000642e:	7442                	ld	s0,48(sp)
    80006430:	74a2                	ld	s1,40(sp)
    80006432:	7902                	ld	s2,32(sp)
    80006434:	69e2                	ld	s3,24(sp)
    80006436:	6a42                	ld	s4,16(sp)
    80006438:	6aa2                	ld	s5,8(sp)
    8000643a:	6121                	addi	sp,sp,64
    8000643c:	8082                	ret

000000008000643e <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    8000643e:	715d                	addi	sp,sp,-80
    80006440:	e486                	sd	ra,72(sp)
    80006442:	e0a2                	sd	s0,64(sp)
    80006444:	fc26                	sd	s1,56(sp)
    80006446:	f84a                	sd	s2,48(sp)
    80006448:	f44e                	sd	s3,40(sp)
    8000644a:	f052                	sd	s4,32(sp)
    8000644c:	ec56                	sd	s5,24(sp)
    8000644e:	e85a                	sd	s6,16(sp)
    80006450:	e45e                	sd	s7,8(sp)
    80006452:	0880                	addi	s0,sp,80
    80006454:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    80006458:	100e8937          	lui	s2,0x100e8
    8000645c:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006460:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80006462:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80006464:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    80006468:	6a09                	lui	s4,0x2
    8000646a:	300409b7          	lui	s3,0x30040
    8000646e:	a819                	j	80006484 <pci_init+0x46>
      base[4+0] = e1000_regs;
    80006470:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80006474:	855a                	mv	a0,s6
    80006476:	fffff097          	auipc	ra,0xfffff
    8000647a:	2ca080e7          	jalr	714(ra) # 80005740 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    8000647e:	94d2                	add	s1,s1,s4
    80006480:	03348a63          	beq	s1,s3,800064b4 <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    80006484:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80006486:	409c                	lw	a5,0(s1)
    80006488:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    8000648a:	ff279ae3          	bne	a5,s2,8000647e <pci_init+0x40>
      base[1] = 7;
    8000648e:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80006492:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    80006496:	01048793          	addi	a5,s1,16
    8000649a:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    8000649e:	4398                	lw	a4,0(a5)
    800064a0:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    800064a2:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    800064a6:	0ff0000f          	fence
        base[4+i] = old;
    800064aa:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    800064ac:	0791                	addi	a5,a5,4
    800064ae:	fec798e3          	bne	a5,a2,8000649e <pci_init+0x60>
    800064b2:	bf7d                	j	80006470 <pci_init+0x32>
    }
  }
}
    800064b4:	60a6                	ld	ra,72(sp)
    800064b6:	6406                	ld	s0,64(sp)
    800064b8:	74e2                	ld	s1,56(sp)
    800064ba:	7942                	ld	s2,48(sp)
    800064bc:	79a2                	ld	s3,40(sp)
    800064be:	7a02                	ld	s4,32(sp)
    800064c0:	6ae2                	ld	s5,24(sp)
    800064c2:	6b42                	ld	s6,16(sp)
    800064c4:	6ba2                	ld	s7,8(sp)
    800064c6:	6161                	addi	sp,sp,80
    800064c8:	8082                	ret

00000000800064ca <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800064ca:	1141                	addi	sp,sp,-16
    800064cc:	e422                	sd	s0,8(sp)
    800064ce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800064d0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800064d4:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800064d8:	0037979b          	slliw	a5,a5,0x3
    800064dc:	02004737          	lui	a4,0x2004
    800064e0:	97ba                	add	a5,a5,a4
    800064e2:	0200c737          	lui	a4,0x200c
    800064e6:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800064ea:	000f4637          	lui	a2,0xf4
    800064ee:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800064f2:	9732                	add	a4,a4,a2
    800064f4:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800064f6:	00259693          	slli	a3,a1,0x2
    800064fa:	96ae                	add	a3,a3,a1
    800064fc:	068e                	slli	a3,a3,0x3
    800064fe:	00015717          	auipc	a4,0x15
    80006502:	c4270713          	addi	a4,a4,-958 # 8001b140 <timer_scratch>
    80006506:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80006508:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000650a:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000650c:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80006510:	fffff797          	auipc	a5,0xfffff
    80006514:	c0078793          	addi	a5,a5,-1024 # 80005110 <timervec>
    80006518:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000651c:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80006520:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006524:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80006528:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000652c:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80006530:	30479073          	csrw	mie,a5
}
    80006534:	6422                	ld	s0,8(sp)
    80006536:	0141                	addi	sp,sp,16
    80006538:	8082                	ret

000000008000653a <start>:
{
    8000653a:	1141                	addi	sp,sp,-16
    8000653c:	e406                	sd	ra,8(sp)
    8000653e:	e022                	sd	s0,0(sp)
    80006540:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006542:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006546:	7779                	lui	a4,0xffffe
    80006548:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb47f>
    8000654c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000654e:	6705                	lui	a4,0x1
    80006550:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80006554:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006556:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000655a:	ffffa797          	auipc	a5,0xffffa
    8000655e:	dc478793          	addi	a5,a5,-572 # 8000031e <main>
    80006562:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80006566:	4781                	li	a5,0
    80006568:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000656c:	67c1                	lui	a5,0x10
    8000656e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80006570:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80006574:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80006578:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000657c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80006580:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80006584:	57fd                	li	a5,-1
    80006586:	83a9                	srli	a5,a5,0xa
    80006588:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000658c:	47bd                	li	a5,15
    8000658e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80006592:	00000097          	auipc	ra,0x0
    80006596:	f38080e7          	jalr	-200(ra) # 800064ca <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000659a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000659e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800065a0:	823e                	mv	tp,a5
  asm volatile("mret");
    800065a2:	30200073          	mret
}
    800065a6:	60a2                	ld	ra,8(sp)
    800065a8:	6402                	ld	s0,0(sp)
    800065aa:	0141                	addi	sp,sp,16
    800065ac:	8082                	ret

00000000800065ae <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800065ae:	715d                	addi	sp,sp,-80
    800065b0:	e486                	sd	ra,72(sp)
    800065b2:	e0a2                	sd	s0,64(sp)
    800065b4:	fc26                	sd	s1,56(sp)
    800065b6:	f84a                	sd	s2,48(sp)
    800065b8:	f44e                	sd	s3,40(sp)
    800065ba:	f052                	sd	s4,32(sp)
    800065bc:	ec56                	sd	s5,24(sp)
    800065be:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800065c0:	04c05763          	blez	a2,8000660e <consolewrite+0x60>
    800065c4:	8a2a                	mv	s4,a0
    800065c6:	84ae                	mv	s1,a1
    800065c8:	89b2                	mv	s3,a2
    800065ca:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800065cc:	5afd                	li	s5,-1
    800065ce:	4685                	li	a3,1
    800065d0:	8626                	mv	a2,s1
    800065d2:	85d2                	mv	a1,s4
    800065d4:	fbf40513          	addi	a0,s0,-65
    800065d8:	ffffb097          	auipc	ra,0xffffb
    800065dc:	3d8080e7          	jalr	984(ra) # 800019b0 <either_copyin>
    800065e0:	01550d63          	beq	a0,s5,800065fa <consolewrite+0x4c>
      break;
    uartputc(c);
    800065e4:	fbf44503          	lbu	a0,-65(s0)
    800065e8:	00000097          	auipc	ra,0x0
    800065ec:	780080e7          	jalr	1920(ra) # 80006d68 <uartputc>
  for(i = 0; i < n; i++){
    800065f0:	2905                	addiw	s2,s2,1
    800065f2:	0485                	addi	s1,s1,1
    800065f4:	fd299de3          	bne	s3,s2,800065ce <consolewrite+0x20>
    800065f8:	894e                	mv	s2,s3
  }

  return i;
}
    800065fa:	854a                	mv	a0,s2
    800065fc:	60a6                	ld	ra,72(sp)
    800065fe:	6406                	ld	s0,64(sp)
    80006600:	74e2                	ld	s1,56(sp)
    80006602:	7942                	ld	s2,48(sp)
    80006604:	79a2                	ld	s3,40(sp)
    80006606:	7a02                	ld	s4,32(sp)
    80006608:	6ae2                	ld	s5,24(sp)
    8000660a:	6161                	addi	sp,sp,80
    8000660c:	8082                	ret
  for(i = 0; i < n; i++){
    8000660e:	4901                	li	s2,0
    80006610:	b7ed                	j	800065fa <consolewrite+0x4c>

0000000080006612 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80006612:	711d                	addi	sp,sp,-96
    80006614:	ec86                	sd	ra,88(sp)
    80006616:	e8a2                	sd	s0,80(sp)
    80006618:	e4a6                	sd	s1,72(sp)
    8000661a:	e0ca                	sd	s2,64(sp)
    8000661c:	fc4e                	sd	s3,56(sp)
    8000661e:	f852                	sd	s4,48(sp)
    80006620:	f456                	sd	s5,40(sp)
    80006622:	f05a                	sd	s6,32(sp)
    80006624:	ec5e                	sd	s7,24(sp)
    80006626:	1080                	addi	s0,sp,96
    80006628:	8aaa                	mv	s5,a0
    8000662a:	8a2e                	mv	s4,a1
    8000662c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000662e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80006632:	0001d517          	auipc	a0,0x1d
    80006636:	c4e50513          	addi	a0,a0,-946 # 80023280 <cons>
    8000663a:	00001097          	auipc	ra,0x1
    8000663e:	8e8080e7          	jalr	-1816(ra) # 80006f22 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80006642:	0001d497          	auipc	s1,0x1d
    80006646:	c3e48493          	addi	s1,s1,-962 # 80023280 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000664a:	0001d917          	auipc	s2,0x1d
    8000664e:	cce90913          	addi	s2,s2,-818 # 80023318 <cons+0x98>
  while(n > 0){
    80006652:	09305263          	blez	s3,800066d6 <consoleread+0xc4>
    while(cons.r == cons.w){
    80006656:	0984a783          	lw	a5,152(s1)
    8000665a:	09c4a703          	lw	a4,156(s1)
    8000665e:	02f71763          	bne	a4,a5,8000668c <consoleread+0x7a>
      if(killed(myproc())){
    80006662:	ffffb097          	auipc	ra,0xffffb
    80006666:	848080e7          	jalr	-1976(ra) # 80000eaa <myproc>
    8000666a:	ffffb097          	auipc	ra,0xffffb
    8000666e:	190080e7          	jalr	400(ra) # 800017fa <killed>
    80006672:	ed2d                	bnez	a0,800066ec <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80006674:	85a6                	mv	a1,s1
    80006676:	854a                	mv	a0,s2
    80006678:	ffffb097          	auipc	ra,0xffffb
    8000667c:	eda080e7          	jalr	-294(ra) # 80001552 <sleep>
    while(cons.r == cons.w){
    80006680:	0984a783          	lw	a5,152(s1)
    80006684:	09c4a703          	lw	a4,156(s1)
    80006688:	fcf70de3          	beq	a4,a5,80006662 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000668c:	0001d717          	auipc	a4,0x1d
    80006690:	bf470713          	addi	a4,a4,-1036 # 80023280 <cons>
    80006694:	0017869b          	addiw	a3,a5,1
    80006698:	08d72c23          	sw	a3,152(a4)
    8000669c:	07f7f693          	andi	a3,a5,127
    800066a0:	9736                	add	a4,a4,a3
    800066a2:	01874703          	lbu	a4,24(a4)
    800066a6:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800066aa:	4691                	li	a3,4
    800066ac:	06db8463          	beq	s7,a3,80006714 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800066b0:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800066b4:	4685                	li	a3,1
    800066b6:	faf40613          	addi	a2,s0,-81
    800066ba:	85d2                	mv	a1,s4
    800066bc:	8556                	mv	a0,s5
    800066be:	ffffb097          	auipc	ra,0xffffb
    800066c2:	29c080e7          	jalr	668(ra) # 8000195a <either_copyout>
    800066c6:	57fd                	li	a5,-1
    800066c8:	00f50763          	beq	a0,a5,800066d6 <consoleread+0xc4>
      break;

    dst++;
    800066cc:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    800066ce:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if(c == '\n'){
    800066d0:	47a9                	li	a5,10
    800066d2:	f8fb90e3          	bne	s7,a5,80006652 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800066d6:	0001d517          	auipc	a0,0x1d
    800066da:	baa50513          	addi	a0,a0,-1110 # 80023280 <cons>
    800066de:	00001097          	auipc	ra,0x1
    800066e2:	8f8080e7          	jalr	-1800(ra) # 80006fd6 <release>

  return target - n;
    800066e6:	413b053b          	subw	a0,s6,s3
    800066ea:	a811                	j	800066fe <consoleread+0xec>
        release(&cons.lock);
    800066ec:	0001d517          	auipc	a0,0x1d
    800066f0:	b9450513          	addi	a0,a0,-1132 # 80023280 <cons>
    800066f4:	00001097          	auipc	ra,0x1
    800066f8:	8e2080e7          	jalr	-1822(ra) # 80006fd6 <release>
        return -1;
    800066fc:	557d                	li	a0,-1
}
    800066fe:	60e6                	ld	ra,88(sp)
    80006700:	6446                	ld	s0,80(sp)
    80006702:	64a6                	ld	s1,72(sp)
    80006704:	6906                	ld	s2,64(sp)
    80006706:	79e2                	ld	s3,56(sp)
    80006708:	7a42                	ld	s4,48(sp)
    8000670a:	7aa2                	ld	s5,40(sp)
    8000670c:	7b02                	ld	s6,32(sp)
    8000670e:	6be2                	ld	s7,24(sp)
    80006710:	6125                	addi	sp,sp,96
    80006712:	8082                	ret
      if(n < target){
    80006714:	0009871b          	sext.w	a4,s3
    80006718:	fb677fe3          	bgeu	a4,s6,800066d6 <consoleread+0xc4>
        cons.r--;
    8000671c:	0001d717          	auipc	a4,0x1d
    80006720:	bef72e23          	sw	a5,-1028(a4) # 80023318 <cons+0x98>
    80006724:	bf4d                	j	800066d6 <consoleread+0xc4>

0000000080006726 <consputc>:
{
    80006726:	1141                	addi	sp,sp,-16
    80006728:	e406                	sd	ra,8(sp)
    8000672a:	e022                	sd	s0,0(sp)
    8000672c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000672e:	10000793          	li	a5,256
    80006732:	00f50a63          	beq	a0,a5,80006746 <consputc+0x20>
    uartputc_sync(c);
    80006736:	00000097          	auipc	ra,0x0
    8000673a:	560080e7          	jalr	1376(ra) # 80006c96 <uartputc_sync>
}
    8000673e:	60a2                	ld	ra,8(sp)
    80006740:	6402                	ld	s0,0(sp)
    80006742:	0141                	addi	sp,sp,16
    80006744:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80006746:	4521                	li	a0,8
    80006748:	00000097          	auipc	ra,0x0
    8000674c:	54e080e7          	jalr	1358(ra) # 80006c96 <uartputc_sync>
    80006750:	02000513          	li	a0,32
    80006754:	00000097          	auipc	ra,0x0
    80006758:	542080e7          	jalr	1346(ra) # 80006c96 <uartputc_sync>
    8000675c:	4521                	li	a0,8
    8000675e:	00000097          	auipc	ra,0x0
    80006762:	538080e7          	jalr	1336(ra) # 80006c96 <uartputc_sync>
    80006766:	bfe1                	j	8000673e <consputc+0x18>

0000000080006768 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006768:	1101                	addi	sp,sp,-32
    8000676a:	ec06                	sd	ra,24(sp)
    8000676c:	e822                	sd	s0,16(sp)
    8000676e:	e426                	sd	s1,8(sp)
    80006770:	e04a                	sd	s2,0(sp)
    80006772:	1000                	addi	s0,sp,32
    80006774:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006776:	0001d517          	auipc	a0,0x1d
    8000677a:	b0a50513          	addi	a0,a0,-1270 # 80023280 <cons>
    8000677e:	00000097          	auipc	ra,0x0
    80006782:	7a4080e7          	jalr	1956(ra) # 80006f22 <acquire>

  switch(c){
    80006786:	47d5                	li	a5,21
    80006788:	0af48663          	beq	s1,a5,80006834 <consoleintr+0xcc>
    8000678c:	0297ca63          	blt	a5,s1,800067c0 <consoleintr+0x58>
    80006790:	47a1                	li	a5,8
    80006792:	0ef48763          	beq	s1,a5,80006880 <consoleintr+0x118>
    80006796:	47c1                	li	a5,16
    80006798:	10f49a63          	bne	s1,a5,800068ac <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000679c:	ffffb097          	auipc	ra,0xffffb
    800067a0:	26a080e7          	jalr	618(ra) # 80001a06 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800067a4:	0001d517          	auipc	a0,0x1d
    800067a8:	adc50513          	addi	a0,a0,-1316 # 80023280 <cons>
    800067ac:	00001097          	auipc	ra,0x1
    800067b0:	82a080e7          	jalr	-2006(ra) # 80006fd6 <release>
}
    800067b4:	60e2                	ld	ra,24(sp)
    800067b6:	6442                	ld	s0,16(sp)
    800067b8:	64a2                	ld	s1,8(sp)
    800067ba:	6902                	ld	s2,0(sp)
    800067bc:	6105                	addi	sp,sp,32
    800067be:	8082                	ret
  switch(c){
    800067c0:	07f00793          	li	a5,127
    800067c4:	0af48e63          	beq	s1,a5,80006880 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800067c8:	0001d717          	auipc	a4,0x1d
    800067cc:	ab870713          	addi	a4,a4,-1352 # 80023280 <cons>
    800067d0:	0a072783          	lw	a5,160(a4)
    800067d4:	09872703          	lw	a4,152(a4)
    800067d8:	9f99                	subw	a5,a5,a4
    800067da:	07f00713          	li	a4,127
    800067de:	fcf763e3          	bltu	a4,a5,800067a4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800067e2:	47b5                	li	a5,13
    800067e4:	0cf48763          	beq	s1,a5,800068b2 <consoleintr+0x14a>
      consputc(c);
    800067e8:	8526                	mv	a0,s1
    800067ea:	00000097          	auipc	ra,0x0
    800067ee:	f3c080e7          	jalr	-196(ra) # 80006726 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800067f2:	0001d797          	auipc	a5,0x1d
    800067f6:	a8e78793          	addi	a5,a5,-1394 # 80023280 <cons>
    800067fa:	0a07a683          	lw	a3,160(a5)
    800067fe:	0016871b          	addiw	a4,a3,1
    80006802:	0007061b          	sext.w	a2,a4
    80006806:	0ae7a023          	sw	a4,160(a5)
    8000680a:	07f6f693          	andi	a3,a3,127
    8000680e:	97b6                	add	a5,a5,a3
    80006810:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80006814:	47a9                	li	a5,10
    80006816:	0cf48563          	beq	s1,a5,800068e0 <consoleintr+0x178>
    8000681a:	4791                	li	a5,4
    8000681c:	0cf48263          	beq	s1,a5,800068e0 <consoleintr+0x178>
    80006820:	0001d797          	auipc	a5,0x1d
    80006824:	af87a783          	lw	a5,-1288(a5) # 80023318 <cons+0x98>
    80006828:	9f1d                	subw	a4,a4,a5
    8000682a:	08000793          	li	a5,128
    8000682e:	f6f71be3          	bne	a4,a5,800067a4 <consoleintr+0x3c>
    80006832:	a07d                	j	800068e0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006834:	0001d717          	auipc	a4,0x1d
    80006838:	a4c70713          	addi	a4,a4,-1460 # 80023280 <cons>
    8000683c:	0a072783          	lw	a5,160(a4)
    80006840:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006844:	0001d497          	auipc	s1,0x1d
    80006848:	a3c48493          	addi	s1,s1,-1476 # 80023280 <cons>
    while(cons.e != cons.w &&
    8000684c:	4929                	li	s2,10
    8000684e:	f4f70be3          	beq	a4,a5,800067a4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80006852:	37fd                	addiw	a5,a5,-1
    80006854:	07f7f713          	andi	a4,a5,127
    80006858:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000685a:	01874703          	lbu	a4,24(a4)
    8000685e:	f52703e3          	beq	a4,s2,800067a4 <consoleintr+0x3c>
      cons.e--;
    80006862:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006866:	10000513          	li	a0,256
    8000686a:	00000097          	auipc	ra,0x0
    8000686e:	ebc080e7          	jalr	-324(ra) # 80006726 <consputc>
    while(cons.e != cons.w &&
    80006872:	0a04a783          	lw	a5,160(s1)
    80006876:	09c4a703          	lw	a4,156(s1)
    8000687a:	fcf71ce3          	bne	a4,a5,80006852 <consoleintr+0xea>
    8000687e:	b71d                	j	800067a4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006880:	0001d717          	auipc	a4,0x1d
    80006884:	a0070713          	addi	a4,a4,-1536 # 80023280 <cons>
    80006888:	0a072783          	lw	a5,160(a4)
    8000688c:	09c72703          	lw	a4,156(a4)
    80006890:	f0f70ae3          	beq	a4,a5,800067a4 <consoleintr+0x3c>
      cons.e--;
    80006894:	37fd                	addiw	a5,a5,-1
    80006896:	0001d717          	auipc	a4,0x1d
    8000689a:	a8f72523          	sw	a5,-1398(a4) # 80023320 <cons+0xa0>
      consputc(BACKSPACE);
    8000689e:	10000513          	li	a0,256
    800068a2:	00000097          	auipc	ra,0x0
    800068a6:	e84080e7          	jalr	-380(ra) # 80006726 <consputc>
    800068aa:	bded                	j	800067a4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800068ac:	ee048ce3          	beqz	s1,800067a4 <consoleintr+0x3c>
    800068b0:	bf21                	j	800067c8 <consoleintr+0x60>
      consputc(c);
    800068b2:	4529                	li	a0,10
    800068b4:	00000097          	auipc	ra,0x0
    800068b8:	e72080e7          	jalr	-398(ra) # 80006726 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800068bc:	0001d797          	auipc	a5,0x1d
    800068c0:	9c478793          	addi	a5,a5,-1596 # 80023280 <cons>
    800068c4:	0a07a703          	lw	a4,160(a5)
    800068c8:	0017069b          	addiw	a3,a4,1
    800068cc:	0006861b          	sext.w	a2,a3
    800068d0:	0ad7a023          	sw	a3,160(a5)
    800068d4:	07f77713          	andi	a4,a4,127
    800068d8:	97ba                	add	a5,a5,a4
    800068da:	4729                	li	a4,10
    800068dc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800068e0:	0001d797          	auipc	a5,0x1d
    800068e4:	a2c7ae23          	sw	a2,-1476(a5) # 8002331c <cons+0x9c>
        wakeup(&cons.r);
    800068e8:	0001d517          	auipc	a0,0x1d
    800068ec:	a3050513          	addi	a0,a0,-1488 # 80023318 <cons+0x98>
    800068f0:	ffffb097          	auipc	ra,0xffffb
    800068f4:	cc6080e7          	jalr	-826(ra) # 800015b6 <wakeup>
    800068f8:	b575                	j	800067a4 <consoleintr+0x3c>

00000000800068fa <consoleinit>:

void
consoleinit(void)
{
    800068fa:	1141                	addi	sp,sp,-16
    800068fc:	e406                	sd	ra,8(sp)
    800068fe:	e022                	sd	s0,0(sp)
    80006900:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006902:	00003597          	auipc	a1,0x3
    80006906:	f5e58593          	addi	a1,a1,-162 # 80009860 <syscalls+0x480>
    8000690a:	0001d517          	auipc	a0,0x1d
    8000690e:	97650513          	addi	a0,a0,-1674 # 80023280 <cons>
    80006912:	00000097          	auipc	ra,0x0
    80006916:	580080e7          	jalr	1408(ra) # 80006e92 <initlock>

  uartinit();
    8000691a:	00000097          	auipc	ra,0x0
    8000691e:	32c080e7          	jalr	812(ra) # 80006c46 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006922:	00013797          	auipc	a5,0x13
    80006926:	12678793          	addi	a5,a5,294 # 80019a48 <devsw>
    8000692a:	00000717          	auipc	a4,0x0
    8000692e:	ce870713          	addi	a4,a4,-792 # 80006612 <consoleread>
    80006932:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006934:	00000717          	auipc	a4,0x0
    80006938:	c7a70713          	addi	a4,a4,-902 # 800065ae <consolewrite>
    8000693c:	ef98                	sd	a4,24(a5)
}
    8000693e:	60a2                	ld	ra,8(sp)
    80006940:	6402                	ld	s0,0(sp)
    80006942:	0141                	addi	sp,sp,16
    80006944:	8082                	ret

0000000080006946 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006946:	7179                	addi	sp,sp,-48
    80006948:	f406                	sd	ra,40(sp)
    8000694a:	f022                	sd	s0,32(sp)
    8000694c:	ec26                	sd	s1,24(sp)
    8000694e:	e84a                	sd	s2,16(sp)
    80006950:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006952:	c219                	beqz	a2,80006958 <printint+0x12>
    80006954:	08054763          	bltz	a0,800069e2 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006958:	2501                	sext.w	a0,a0
    8000695a:	4881                	li	a7,0
    8000695c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006960:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006962:	2581                	sext.w	a1,a1
    80006964:	00003617          	auipc	a2,0x3
    80006968:	f2c60613          	addi	a2,a2,-212 # 80009890 <digits>
    8000696c:	883a                	mv	a6,a4
    8000696e:	2705                	addiw	a4,a4,1
    80006970:	02b577bb          	remuw	a5,a0,a1
    80006974:	1782                	slli	a5,a5,0x20
    80006976:	9381                	srli	a5,a5,0x20
    80006978:	97b2                	add	a5,a5,a2
    8000697a:	0007c783          	lbu	a5,0(a5)
    8000697e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006982:	0005079b          	sext.w	a5,a0
    80006986:	02b5553b          	divuw	a0,a0,a1
    8000698a:	0685                	addi	a3,a3,1
    8000698c:	feb7f0e3          	bgeu	a5,a1,8000696c <printint+0x26>

  if(sign)
    80006990:	00088c63          	beqz	a7,800069a8 <printint+0x62>
    buf[i++] = '-';
    80006994:	fe070793          	addi	a5,a4,-32
    80006998:	00878733          	add	a4,a5,s0
    8000699c:	02d00793          	li	a5,45
    800069a0:	fef70823          	sb	a5,-16(a4)
    800069a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800069a8:	02e05763          	blez	a4,800069d6 <printint+0x90>
    800069ac:	fd040793          	addi	a5,s0,-48
    800069b0:	00e784b3          	add	s1,a5,a4
    800069b4:	fff78913          	addi	s2,a5,-1
    800069b8:	993a                	add	s2,s2,a4
    800069ba:	377d                	addiw	a4,a4,-1
    800069bc:	1702                	slli	a4,a4,0x20
    800069be:	9301                	srli	a4,a4,0x20
    800069c0:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800069c4:	fff4c503          	lbu	a0,-1(s1)
    800069c8:	00000097          	auipc	ra,0x0
    800069cc:	d5e080e7          	jalr	-674(ra) # 80006726 <consputc>
  while(--i >= 0)
    800069d0:	14fd                	addi	s1,s1,-1
    800069d2:	ff2499e3          	bne	s1,s2,800069c4 <printint+0x7e>
}
    800069d6:	70a2                	ld	ra,40(sp)
    800069d8:	7402                	ld	s0,32(sp)
    800069da:	64e2                	ld	s1,24(sp)
    800069dc:	6942                	ld	s2,16(sp)
    800069de:	6145                	addi	sp,sp,48
    800069e0:	8082                	ret
    x = -xx;
    800069e2:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800069e6:	4885                	li	a7,1
    x = -xx;
    800069e8:	bf95                	j	8000695c <printint+0x16>

00000000800069ea <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800069ea:	1101                	addi	sp,sp,-32
    800069ec:	ec06                	sd	ra,24(sp)
    800069ee:	e822                	sd	s0,16(sp)
    800069f0:	e426                	sd	s1,8(sp)
    800069f2:	1000                	addi	s0,sp,32
    800069f4:	84aa                	mv	s1,a0
  pr.locking = 0;
    800069f6:	0001d797          	auipc	a5,0x1d
    800069fa:	9407a523          	sw	zero,-1718(a5) # 80023340 <pr+0x18>
  printf("panic: ");
    800069fe:	00003517          	auipc	a0,0x3
    80006a02:	e6a50513          	addi	a0,a0,-406 # 80009868 <syscalls+0x488>
    80006a06:	00000097          	auipc	ra,0x0
    80006a0a:	02e080e7          	jalr	46(ra) # 80006a34 <printf>
  printf(s);
    80006a0e:	8526                	mv	a0,s1
    80006a10:	00000097          	auipc	ra,0x0
    80006a14:	024080e7          	jalr	36(ra) # 80006a34 <printf>
  printf("\n");
    80006a18:	00002517          	auipc	a0,0x2
    80006a1c:	63050513          	addi	a0,a0,1584 # 80009048 <etext+0x48>
    80006a20:	00000097          	auipc	ra,0x0
    80006a24:	014080e7          	jalr	20(ra) # 80006a34 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006a28:	4785                	li	a5,1
    80006a2a:	00003717          	auipc	a4,0x3
    80006a2e:	f6f72323          	sw	a5,-154(a4) # 80009990 <panicked>
  for(;;)
    80006a32:	a001                	j	80006a32 <panic+0x48>

0000000080006a34 <printf>:
{
    80006a34:	7131                	addi	sp,sp,-192
    80006a36:	fc86                	sd	ra,120(sp)
    80006a38:	f8a2                	sd	s0,112(sp)
    80006a3a:	f4a6                	sd	s1,104(sp)
    80006a3c:	f0ca                	sd	s2,96(sp)
    80006a3e:	ecce                	sd	s3,88(sp)
    80006a40:	e8d2                	sd	s4,80(sp)
    80006a42:	e4d6                	sd	s5,72(sp)
    80006a44:	e0da                	sd	s6,64(sp)
    80006a46:	fc5e                	sd	s7,56(sp)
    80006a48:	f862                	sd	s8,48(sp)
    80006a4a:	f466                	sd	s9,40(sp)
    80006a4c:	f06a                	sd	s10,32(sp)
    80006a4e:	ec6e                	sd	s11,24(sp)
    80006a50:	0100                	addi	s0,sp,128
    80006a52:	8a2a                	mv	s4,a0
    80006a54:	e40c                	sd	a1,8(s0)
    80006a56:	e810                	sd	a2,16(s0)
    80006a58:	ec14                	sd	a3,24(s0)
    80006a5a:	f018                	sd	a4,32(s0)
    80006a5c:	f41c                	sd	a5,40(s0)
    80006a5e:	03043823          	sd	a6,48(s0)
    80006a62:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006a66:	0001dd97          	auipc	s11,0x1d
    80006a6a:	8dadad83          	lw	s11,-1830(s11) # 80023340 <pr+0x18>
  if(locking)
    80006a6e:	020d9b63          	bnez	s11,80006aa4 <printf+0x70>
  if (fmt == 0)
    80006a72:	040a0263          	beqz	s4,80006ab6 <printf+0x82>
  va_start(ap, fmt);
    80006a76:	00840793          	addi	a5,s0,8
    80006a7a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006a7e:	000a4503          	lbu	a0,0(s4)
    80006a82:	14050f63          	beqz	a0,80006be0 <printf+0x1ac>
    80006a86:	4981                	li	s3,0
    if(c != '%'){
    80006a88:	02500a93          	li	s5,37
    switch(c){
    80006a8c:	07000b93          	li	s7,112
  consputc('x');
    80006a90:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006a92:	00003b17          	auipc	s6,0x3
    80006a96:	dfeb0b13          	addi	s6,s6,-514 # 80009890 <digits>
    switch(c){
    80006a9a:	07300c93          	li	s9,115
    80006a9e:	06400c13          	li	s8,100
    80006aa2:	a82d                	j	80006adc <printf+0xa8>
    acquire(&pr.lock);
    80006aa4:	0001d517          	auipc	a0,0x1d
    80006aa8:	88450513          	addi	a0,a0,-1916 # 80023328 <pr>
    80006aac:	00000097          	auipc	ra,0x0
    80006ab0:	476080e7          	jalr	1142(ra) # 80006f22 <acquire>
    80006ab4:	bf7d                	j	80006a72 <printf+0x3e>
    panic("null fmt");
    80006ab6:	00003517          	auipc	a0,0x3
    80006aba:	dc250513          	addi	a0,a0,-574 # 80009878 <syscalls+0x498>
    80006abe:	00000097          	auipc	ra,0x0
    80006ac2:	f2c080e7          	jalr	-212(ra) # 800069ea <panic>
      consputc(c);
    80006ac6:	00000097          	auipc	ra,0x0
    80006aca:	c60080e7          	jalr	-928(ra) # 80006726 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006ace:	2985                	addiw	s3,s3,1
    80006ad0:	013a07b3          	add	a5,s4,s3
    80006ad4:	0007c503          	lbu	a0,0(a5)
    80006ad8:	10050463          	beqz	a0,80006be0 <printf+0x1ac>
    if(c != '%'){
    80006adc:	ff5515e3          	bne	a0,s5,80006ac6 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006ae0:	2985                	addiw	s3,s3,1
    80006ae2:	013a07b3          	add	a5,s4,s3
    80006ae6:	0007c783          	lbu	a5,0(a5)
    80006aea:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006aee:	cbed                	beqz	a5,80006be0 <printf+0x1ac>
    switch(c){
    80006af0:	05778a63          	beq	a5,s7,80006b44 <printf+0x110>
    80006af4:	02fbf663          	bgeu	s7,a5,80006b20 <printf+0xec>
    80006af8:	09978863          	beq	a5,s9,80006b88 <printf+0x154>
    80006afc:	07800713          	li	a4,120
    80006b00:	0ce79563          	bne	a5,a4,80006bca <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006b04:	f8843783          	ld	a5,-120(s0)
    80006b08:	00878713          	addi	a4,a5,8
    80006b0c:	f8e43423          	sd	a4,-120(s0)
    80006b10:	4605                	li	a2,1
    80006b12:	85ea                	mv	a1,s10
    80006b14:	4388                	lw	a0,0(a5)
    80006b16:	00000097          	auipc	ra,0x0
    80006b1a:	e30080e7          	jalr	-464(ra) # 80006946 <printint>
      break;
    80006b1e:	bf45                	j	80006ace <printf+0x9a>
    switch(c){
    80006b20:	09578f63          	beq	a5,s5,80006bbe <printf+0x18a>
    80006b24:	0b879363          	bne	a5,s8,80006bca <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006b28:	f8843783          	ld	a5,-120(s0)
    80006b2c:	00878713          	addi	a4,a5,8
    80006b30:	f8e43423          	sd	a4,-120(s0)
    80006b34:	4605                	li	a2,1
    80006b36:	45a9                	li	a1,10
    80006b38:	4388                	lw	a0,0(a5)
    80006b3a:	00000097          	auipc	ra,0x0
    80006b3e:	e0c080e7          	jalr	-500(ra) # 80006946 <printint>
      break;
    80006b42:	b771                	j	80006ace <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006b44:	f8843783          	ld	a5,-120(s0)
    80006b48:	00878713          	addi	a4,a5,8
    80006b4c:	f8e43423          	sd	a4,-120(s0)
    80006b50:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006b54:	03000513          	li	a0,48
    80006b58:	00000097          	auipc	ra,0x0
    80006b5c:	bce080e7          	jalr	-1074(ra) # 80006726 <consputc>
  consputc('x');
    80006b60:	07800513          	li	a0,120
    80006b64:	00000097          	auipc	ra,0x0
    80006b68:	bc2080e7          	jalr	-1086(ra) # 80006726 <consputc>
    80006b6c:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006b6e:	03c95793          	srli	a5,s2,0x3c
    80006b72:	97da                	add	a5,a5,s6
    80006b74:	0007c503          	lbu	a0,0(a5)
    80006b78:	00000097          	auipc	ra,0x0
    80006b7c:	bae080e7          	jalr	-1106(ra) # 80006726 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006b80:	0912                	slli	s2,s2,0x4
    80006b82:	34fd                	addiw	s1,s1,-1
    80006b84:	f4ed                	bnez	s1,80006b6e <printf+0x13a>
    80006b86:	b7a1                	j	80006ace <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006b88:	f8843783          	ld	a5,-120(s0)
    80006b8c:	00878713          	addi	a4,a5,8
    80006b90:	f8e43423          	sd	a4,-120(s0)
    80006b94:	6384                	ld	s1,0(a5)
    80006b96:	cc89                	beqz	s1,80006bb0 <printf+0x17c>
      for(; *s; s++)
    80006b98:	0004c503          	lbu	a0,0(s1)
    80006b9c:	d90d                	beqz	a0,80006ace <printf+0x9a>
        consputc(*s);
    80006b9e:	00000097          	auipc	ra,0x0
    80006ba2:	b88080e7          	jalr	-1144(ra) # 80006726 <consputc>
      for(; *s; s++)
    80006ba6:	0485                	addi	s1,s1,1
    80006ba8:	0004c503          	lbu	a0,0(s1)
    80006bac:	f96d                	bnez	a0,80006b9e <printf+0x16a>
    80006bae:	b705                	j	80006ace <printf+0x9a>
        s = "(null)";
    80006bb0:	00003497          	auipc	s1,0x3
    80006bb4:	cc048493          	addi	s1,s1,-832 # 80009870 <syscalls+0x490>
      for(; *s; s++)
    80006bb8:	02800513          	li	a0,40
    80006bbc:	b7cd                	j	80006b9e <printf+0x16a>
      consputc('%');
    80006bbe:	8556                	mv	a0,s5
    80006bc0:	00000097          	auipc	ra,0x0
    80006bc4:	b66080e7          	jalr	-1178(ra) # 80006726 <consputc>
      break;
    80006bc8:	b719                	j	80006ace <printf+0x9a>
      consputc('%');
    80006bca:	8556                	mv	a0,s5
    80006bcc:	00000097          	auipc	ra,0x0
    80006bd0:	b5a080e7          	jalr	-1190(ra) # 80006726 <consputc>
      consputc(c);
    80006bd4:	8526                	mv	a0,s1
    80006bd6:	00000097          	auipc	ra,0x0
    80006bda:	b50080e7          	jalr	-1200(ra) # 80006726 <consputc>
      break;
    80006bde:	bdc5                	j	80006ace <printf+0x9a>
  if(locking)
    80006be0:	020d9163          	bnez	s11,80006c02 <printf+0x1ce>
}
    80006be4:	70e6                	ld	ra,120(sp)
    80006be6:	7446                	ld	s0,112(sp)
    80006be8:	74a6                	ld	s1,104(sp)
    80006bea:	7906                	ld	s2,96(sp)
    80006bec:	69e6                	ld	s3,88(sp)
    80006bee:	6a46                	ld	s4,80(sp)
    80006bf0:	6aa6                	ld	s5,72(sp)
    80006bf2:	6b06                	ld	s6,64(sp)
    80006bf4:	7be2                	ld	s7,56(sp)
    80006bf6:	7c42                	ld	s8,48(sp)
    80006bf8:	7ca2                	ld	s9,40(sp)
    80006bfa:	7d02                	ld	s10,32(sp)
    80006bfc:	6de2                	ld	s11,24(sp)
    80006bfe:	6129                	addi	sp,sp,192
    80006c00:	8082                	ret
    release(&pr.lock);
    80006c02:	0001c517          	auipc	a0,0x1c
    80006c06:	72650513          	addi	a0,a0,1830 # 80023328 <pr>
    80006c0a:	00000097          	auipc	ra,0x0
    80006c0e:	3cc080e7          	jalr	972(ra) # 80006fd6 <release>
}
    80006c12:	bfc9                	j	80006be4 <printf+0x1b0>

0000000080006c14 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006c14:	1101                	addi	sp,sp,-32
    80006c16:	ec06                	sd	ra,24(sp)
    80006c18:	e822                	sd	s0,16(sp)
    80006c1a:	e426                	sd	s1,8(sp)
    80006c1c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006c1e:	0001c497          	auipc	s1,0x1c
    80006c22:	70a48493          	addi	s1,s1,1802 # 80023328 <pr>
    80006c26:	00003597          	auipc	a1,0x3
    80006c2a:	c6258593          	addi	a1,a1,-926 # 80009888 <syscalls+0x4a8>
    80006c2e:	8526                	mv	a0,s1
    80006c30:	00000097          	auipc	ra,0x0
    80006c34:	262080e7          	jalr	610(ra) # 80006e92 <initlock>
  pr.locking = 1;
    80006c38:	4785                	li	a5,1
    80006c3a:	cc9c                	sw	a5,24(s1)
}
    80006c3c:	60e2                	ld	ra,24(sp)
    80006c3e:	6442                	ld	s0,16(sp)
    80006c40:	64a2                	ld	s1,8(sp)
    80006c42:	6105                	addi	sp,sp,32
    80006c44:	8082                	ret

0000000080006c46 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006c46:	1141                	addi	sp,sp,-16
    80006c48:	e406                	sd	ra,8(sp)
    80006c4a:	e022                	sd	s0,0(sp)
    80006c4c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006c4e:	100007b7          	lui	a5,0x10000
    80006c52:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006c56:	f8000713          	li	a4,-128
    80006c5a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006c5e:	470d                	li	a4,3
    80006c60:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006c64:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006c68:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006c6c:	469d                	li	a3,7
    80006c6e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006c72:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006c76:	00003597          	auipc	a1,0x3
    80006c7a:	c3258593          	addi	a1,a1,-974 # 800098a8 <digits+0x18>
    80006c7e:	0001c517          	auipc	a0,0x1c
    80006c82:	6ca50513          	addi	a0,a0,1738 # 80023348 <uart_tx_lock>
    80006c86:	00000097          	auipc	ra,0x0
    80006c8a:	20c080e7          	jalr	524(ra) # 80006e92 <initlock>
}
    80006c8e:	60a2                	ld	ra,8(sp)
    80006c90:	6402                	ld	s0,0(sp)
    80006c92:	0141                	addi	sp,sp,16
    80006c94:	8082                	ret

0000000080006c96 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006c96:	1101                	addi	sp,sp,-32
    80006c98:	ec06                	sd	ra,24(sp)
    80006c9a:	e822                	sd	s0,16(sp)
    80006c9c:	e426                	sd	s1,8(sp)
    80006c9e:	1000                	addi	s0,sp,32
    80006ca0:	84aa                	mv	s1,a0
  push_off();
    80006ca2:	00000097          	auipc	ra,0x0
    80006ca6:	234080e7          	jalr	564(ra) # 80006ed6 <push_off>

  if(panicked){
    80006caa:	00003797          	auipc	a5,0x3
    80006cae:	ce67a783          	lw	a5,-794(a5) # 80009990 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006cb2:	10000737          	lui	a4,0x10000
  if(panicked){
    80006cb6:	c391                	beqz	a5,80006cba <uartputc_sync+0x24>
    for(;;)
    80006cb8:	a001                	j	80006cb8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006cba:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006cbe:	0207f793          	andi	a5,a5,32
    80006cc2:	dfe5                	beqz	a5,80006cba <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006cc4:	0ff4f513          	zext.b	a0,s1
    80006cc8:	100007b7          	lui	a5,0x10000
    80006ccc:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006cd0:	00000097          	auipc	ra,0x0
    80006cd4:	2a6080e7          	jalr	678(ra) # 80006f76 <pop_off>
}
    80006cd8:	60e2                	ld	ra,24(sp)
    80006cda:	6442                	ld	s0,16(sp)
    80006cdc:	64a2                	ld	s1,8(sp)
    80006cde:	6105                	addi	sp,sp,32
    80006ce0:	8082                	ret

0000000080006ce2 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006ce2:	00003797          	auipc	a5,0x3
    80006ce6:	cb67b783          	ld	a5,-842(a5) # 80009998 <uart_tx_r>
    80006cea:	00003717          	auipc	a4,0x3
    80006cee:	cb673703          	ld	a4,-842(a4) # 800099a0 <uart_tx_w>
    80006cf2:	06f70a63          	beq	a4,a5,80006d66 <uartstart+0x84>
{
    80006cf6:	7139                	addi	sp,sp,-64
    80006cf8:	fc06                	sd	ra,56(sp)
    80006cfa:	f822                	sd	s0,48(sp)
    80006cfc:	f426                	sd	s1,40(sp)
    80006cfe:	f04a                	sd	s2,32(sp)
    80006d00:	ec4e                	sd	s3,24(sp)
    80006d02:	e852                	sd	s4,16(sp)
    80006d04:	e456                	sd	s5,8(sp)
    80006d06:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006d08:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006d0c:	0001ca17          	auipc	s4,0x1c
    80006d10:	63ca0a13          	addi	s4,s4,1596 # 80023348 <uart_tx_lock>
    uart_tx_r += 1;
    80006d14:	00003497          	auipc	s1,0x3
    80006d18:	c8448493          	addi	s1,s1,-892 # 80009998 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006d1c:	00003997          	auipc	s3,0x3
    80006d20:	c8498993          	addi	s3,s3,-892 # 800099a0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006d24:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006d28:	02077713          	andi	a4,a4,32
    80006d2c:	c705                	beqz	a4,80006d54 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006d2e:	01f7f713          	andi	a4,a5,31
    80006d32:	9752                	add	a4,a4,s4
    80006d34:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006d38:	0785                	addi	a5,a5,1
    80006d3a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006d3c:	8526                	mv	a0,s1
    80006d3e:	ffffb097          	auipc	ra,0xffffb
    80006d42:	878080e7          	jalr	-1928(ra) # 800015b6 <wakeup>
    
    WriteReg(THR, c);
    80006d46:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006d4a:	609c                	ld	a5,0(s1)
    80006d4c:	0009b703          	ld	a4,0(s3)
    80006d50:	fcf71ae3          	bne	a4,a5,80006d24 <uartstart+0x42>
  }
}
    80006d54:	70e2                	ld	ra,56(sp)
    80006d56:	7442                	ld	s0,48(sp)
    80006d58:	74a2                	ld	s1,40(sp)
    80006d5a:	7902                	ld	s2,32(sp)
    80006d5c:	69e2                	ld	s3,24(sp)
    80006d5e:	6a42                	ld	s4,16(sp)
    80006d60:	6aa2                	ld	s5,8(sp)
    80006d62:	6121                	addi	sp,sp,64
    80006d64:	8082                	ret
    80006d66:	8082                	ret

0000000080006d68 <uartputc>:
{
    80006d68:	7179                	addi	sp,sp,-48
    80006d6a:	f406                	sd	ra,40(sp)
    80006d6c:	f022                	sd	s0,32(sp)
    80006d6e:	ec26                	sd	s1,24(sp)
    80006d70:	e84a                	sd	s2,16(sp)
    80006d72:	e44e                	sd	s3,8(sp)
    80006d74:	e052                	sd	s4,0(sp)
    80006d76:	1800                	addi	s0,sp,48
    80006d78:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006d7a:	0001c517          	auipc	a0,0x1c
    80006d7e:	5ce50513          	addi	a0,a0,1486 # 80023348 <uart_tx_lock>
    80006d82:	00000097          	auipc	ra,0x0
    80006d86:	1a0080e7          	jalr	416(ra) # 80006f22 <acquire>
  if(panicked){
    80006d8a:	00003797          	auipc	a5,0x3
    80006d8e:	c067a783          	lw	a5,-1018(a5) # 80009990 <panicked>
    80006d92:	e7c9                	bnez	a5,80006e1c <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006d94:	00003717          	auipc	a4,0x3
    80006d98:	c0c73703          	ld	a4,-1012(a4) # 800099a0 <uart_tx_w>
    80006d9c:	00003797          	auipc	a5,0x3
    80006da0:	bfc7b783          	ld	a5,-1028(a5) # 80009998 <uart_tx_r>
    80006da4:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006da8:	0001c997          	auipc	s3,0x1c
    80006dac:	5a098993          	addi	s3,s3,1440 # 80023348 <uart_tx_lock>
    80006db0:	00003497          	auipc	s1,0x3
    80006db4:	be848493          	addi	s1,s1,-1048 # 80009998 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006db8:	00003917          	auipc	s2,0x3
    80006dbc:	be890913          	addi	s2,s2,-1048 # 800099a0 <uart_tx_w>
    80006dc0:	00e79f63          	bne	a5,a4,80006dde <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006dc4:	85ce                	mv	a1,s3
    80006dc6:	8526                	mv	a0,s1
    80006dc8:	ffffa097          	auipc	ra,0xffffa
    80006dcc:	78a080e7          	jalr	1930(ra) # 80001552 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006dd0:	00093703          	ld	a4,0(s2)
    80006dd4:	609c                	ld	a5,0(s1)
    80006dd6:	02078793          	addi	a5,a5,32
    80006dda:	fee785e3          	beq	a5,a4,80006dc4 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006dde:	0001c497          	auipc	s1,0x1c
    80006de2:	56a48493          	addi	s1,s1,1386 # 80023348 <uart_tx_lock>
    80006de6:	01f77793          	andi	a5,a4,31
    80006dea:	97a6                	add	a5,a5,s1
    80006dec:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006df0:	0705                	addi	a4,a4,1
    80006df2:	00003797          	auipc	a5,0x3
    80006df6:	bae7b723          	sd	a4,-1106(a5) # 800099a0 <uart_tx_w>
  uartstart();
    80006dfa:	00000097          	auipc	ra,0x0
    80006dfe:	ee8080e7          	jalr	-280(ra) # 80006ce2 <uartstart>
  release(&uart_tx_lock);
    80006e02:	8526                	mv	a0,s1
    80006e04:	00000097          	auipc	ra,0x0
    80006e08:	1d2080e7          	jalr	466(ra) # 80006fd6 <release>
}
    80006e0c:	70a2                	ld	ra,40(sp)
    80006e0e:	7402                	ld	s0,32(sp)
    80006e10:	64e2                	ld	s1,24(sp)
    80006e12:	6942                	ld	s2,16(sp)
    80006e14:	69a2                	ld	s3,8(sp)
    80006e16:	6a02                	ld	s4,0(sp)
    80006e18:	6145                	addi	sp,sp,48
    80006e1a:	8082                	ret
    for(;;)
    80006e1c:	a001                	j	80006e1c <uartputc+0xb4>

0000000080006e1e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006e1e:	1141                	addi	sp,sp,-16
    80006e20:	e422                	sd	s0,8(sp)
    80006e22:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006e24:	100007b7          	lui	a5,0x10000
    80006e28:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006e2c:	8b85                	andi	a5,a5,1
    80006e2e:	cb81                	beqz	a5,80006e3e <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006e30:	100007b7          	lui	a5,0x10000
    80006e34:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006e38:	6422                	ld	s0,8(sp)
    80006e3a:	0141                	addi	sp,sp,16
    80006e3c:	8082                	ret
    return -1;
    80006e3e:	557d                	li	a0,-1
    80006e40:	bfe5                	j	80006e38 <uartgetc+0x1a>

0000000080006e42 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006e42:	1101                	addi	sp,sp,-32
    80006e44:	ec06                	sd	ra,24(sp)
    80006e46:	e822                	sd	s0,16(sp)
    80006e48:	e426                	sd	s1,8(sp)
    80006e4a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006e4c:	54fd                	li	s1,-1
    80006e4e:	a029                	j	80006e58 <uartintr+0x16>
      break;
    consoleintr(c);
    80006e50:	00000097          	auipc	ra,0x0
    80006e54:	918080e7          	jalr	-1768(ra) # 80006768 <consoleintr>
    int c = uartgetc();
    80006e58:	00000097          	auipc	ra,0x0
    80006e5c:	fc6080e7          	jalr	-58(ra) # 80006e1e <uartgetc>
    if(c == -1)
    80006e60:	fe9518e3          	bne	a0,s1,80006e50 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006e64:	0001c497          	auipc	s1,0x1c
    80006e68:	4e448493          	addi	s1,s1,1252 # 80023348 <uart_tx_lock>
    80006e6c:	8526                	mv	a0,s1
    80006e6e:	00000097          	auipc	ra,0x0
    80006e72:	0b4080e7          	jalr	180(ra) # 80006f22 <acquire>
  uartstart();
    80006e76:	00000097          	auipc	ra,0x0
    80006e7a:	e6c080e7          	jalr	-404(ra) # 80006ce2 <uartstart>
  release(&uart_tx_lock);
    80006e7e:	8526                	mv	a0,s1
    80006e80:	00000097          	auipc	ra,0x0
    80006e84:	156080e7          	jalr	342(ra) # 80006fd6 <release>
}
    80006e88:	60e2                	ld	ra,24(sp)
    80006e8a:	6442                	ld	s0,16(sp)
    80006e8c:	64a2                	ld	s1,8(sp)
    80006e8e:	6105                	addi	sp,sp,32
    80006e90:	8082                	ret

0000000080006e92 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80006e92:	1141                	addi	sp,sp,-16
    80006e94:	e422                	sd	s0,8(sp)
    80006e96:	0800                	addi	s0,sp,16
  lk->name = name;
    80006e98:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006e9a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006e9e:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80006ea2:	6422                	ld	s0,8(sp)
    80006ea4:	0141                	addi	sp,sp,16
    80006ea6:	8082                	ret

0000000080006ea8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006ea8:	411c                	lw	a5,0(a0)
    80006eaa:	e399                	bnez	a5,80006eb0 <holding+0x8>
    80006eac:	4501                	li	a0,0
  return r;
}
    80006eae:	8082                	ret
{
    80006eb0:	1101                	addi	sp,sp,-32
    80006eb2:	ec06                	sd	ra,24(sp)
    80006eb4:	e822                	sd	s0,16(sp)
    80006eb6:	e426                	sd	s1,8(sp)
    80006eb8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006eba:	6904                	ld	s1,16(a0)
    80006ebc:	ffffa097          	auipc	ra,0xffffa
    80006ec0:	fd2080e7          	jalr	-46(ra) # 80000e8e <mycpu>
    80006ec4:	40a48533          	sub	a0,s1,a0
    80006ec8:	00153513          	seqz	a0,a0
}
    80006ecc:	60e2                	ld	ra,24(sp)
    80006ece:	6442                	ld	s0,16(sp)
    80006ed0:	64a2                	ld	s1,8(sp)
    80006ed2:	6105                	addi	sp,sp,32
    80006ed4:	8082                	ret

0000000080006ed6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006ed6:	1101                	addi	sp,sp,-32
    80006ed8:	ec06                	sd	ra,24(sp)
    80006eda:	e822                	sd	s0,16(sp)
    80006edc:	e426                	sd	s1,8(sp)
    80006ede:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006ee0:	100024f3          	csrr	s1,sstatus
    80006ee4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006ee8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006eea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006eee:	ffffa097          	auipc	ra,0xffffa
    80006ef2:	fa0080e7          	jalr	-96(ra) # 80000e8e <mycpu>
    80006ef6:	5d3c                	lw	a5,120(a0)
    80006ef8:	cf89                	beqz	a5,80006f12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006efa:	ffffa097          	auipc	ra,0xffffa
    80006efe:	f94080e7          	jalr	-108(ra) # 80000e8e <mycpu>
    80006f02:	5d3c                	lw	a5,120(a0)
    80006f04:	2785                	addiw	a5,a5,1
    80006f06:	dd3c                	sw	a5,120(a0)
}
    80006f08:	60e2                	ld	ra,24(sp)
    80006f0a:	6442                	ld	s0,16(sp)
    80006f0c:	64a2                	ld	s1,8(sp)
    80006f0e:	6105                	addi	sp,sp,32
    80006f10:	8082                	ret
    mycpu()->intena = old;
    80006f12:	ffffa097          	auipc	ra,0xffffa
    80006f16:	f7c080e7          	jalr	-132(ra) # 80000e8e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006f1a:	8085                	srli	s1,s1,0x1
    80006f1c:	8885                	andi	s1,s1,1
    80006f1e:	dd64                	sw	s1,124(a0)
    80006f20:	bfe9                	j	80006efa <push_off+0x24>

0000000080006f22 <acquire>:
{
    80006f22:	1101                	addi	sp,sp,-32
    80006f24:	ec06                	sd	ra,24(sp)
    80006f26:	e822                	sd	s0,16(sp)
    80006f28:	e426                	sd	s1,8(sp)
    80006f2a:	1000                	addi	s0,sp,32
    80006f2c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006f2e:	00000097          	auipc	ra,0x0
    80006f32:	fa8080e7          	jalr	-88(ra) # 80006ed6 <push_off>
  if(holding(lk))
    80006f36:	8526                	mv	a0,s1
    80006f38:	00000097          	auipc	ra,0x0
    80006f3c:	f70080e7          	jalr	-144(ra) # 80006ea8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006f40:	4705                	li	a4,1
  if(holding(lk))
    80006f42:	e115                	bnez	a0,80006f66 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006f44:	87ba                	mv	a5,a4
    80006f46:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006f4a:	2781                	sext.w	a5,a5
    80006f4c:	ffe5                	bnez	a5,80006f44 <acquire+0x22>
  __sync_synchronize();
    80006f4e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006f52:	ffffa097          	auipc	ra,0xffffa
    80006f56:	f3c080e7          	jalr	-196(ra) # 80000e8e <mycpu>
    80006f5a:	e888                	sd	a0,16(s1)
}
    80006f5c:	60e2                	ld	ra,24(sp)
    80006f5e:	6442                	ld	s0,16(sp)
    80006f60:	64a2                	ld	s1,8(sp)
    80006f62:	6105                	addi	sp,sp,32
    80006f64:	8082                	ret
    panic("acquire");
    80006f66:	00003517          	auipc	a0,0x3
    80006f6a:	94a50513          	addi	a0,a0,-1718 # 800098b0 <digits+0x20>
    80006f6e:	00000097          	auipc	ra,0x0
    80006f72:	a7c080e7          	jalr	-1412(ra) # 800069ea <panic>

0000000080006f76 <pop_off>:

void
pop_off(void)
{
    80006f76:	1141                	addi	sp,sp,-16
    80006f78:	e406                	sd	ra,8(sp)
    80006f7a:	e022                	sd	s0,0(sp)
    80006f7c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006f7e:	ffffa097          	auipc	ra,0xffffa
    80006f82:	f10080e7          	jalr	-240(ra) # 80000e8e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006f86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006f8a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006f8c:	e78d                	bnez	a5,80006fb6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006f8e:	5d3c                	lw	a5,120(a0)
    80006f90:	02f05b63          	blez	a5,80006fc6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006f94:	37fd                	addiw	a5,a5,-1
    80006f96:	0007871b          	sext.w	a4,a5
    80006f9a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006f9c:	eb09                	bnez	a4,80006fae <pop_off+0x38>
    80006f9e:	5d7c                	lw	a5,124(a0)
    80006fa0:	c799                	beqz	a5,80006fae <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006fa2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006fa6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006faa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006fae:	60a2                	ld	ra,8(sp)
    80006fb0:	6402                	ld	s0,0(sp)
    80006fb2:	0141                	addi	sp,sp,16
    80006fb4:	8082                	ret
    panic("pop_off - interruptible");
    80006fb6:	00003517          	auipc	a0,0x3
    80006fba:	90250513          	addi	a0,a0,-1790 # 800098b8 <digits+0x28>
    80006fbe:	00000097          	auipc	ra,0x0
    80006fc2:	a2c080e7          	jalr	-1492(ra) # 800069ea <panic>
    panic("pop_off");
    80006fc6:	00003517          	auipc	a0,0x3
    80006fca:	90a50513          	addi	a0,a0,-1782 # 800098d0 <digits+0x40>
    80006fce:	00000097          	auipc	ra,0x0
    80006fd2:	a1c080e7          	jalr	-1508(ra) # 800069ea <panic>

0000000080006fd6 <release>:
{
    80006fd6:	1101                	addi	sp,sp,-32
    80006fd8:	ec06                	sd	ra,24(sp)
    80006fda:	e822                	sd	s0,16(sp)
    80006fdc:	e426                	sd	s1,8(sp)
    80006fde:	1000                	addi	s0,sp,32
    80006fe0:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006fe2:	00000097          	auipc	ra,0x0
    80006fe6:	ec6080e7          	jalr	-314(ra) # 80006ea8 <holding>
    80006fea:	c115                	beqz	a0,8000700e <release+0x38>
  lk->cpu = 0;
    80006fec:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006ff0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006ff4:	0f50000f          	fence	iorw,ow
    80006ff8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006ffc:	00000097          	auipc	ra,0x0
    80007000:	f7a080e7          	jalr	-134(ra) # 80006f76 <pop_off>
}
    80007004:	60e2                	ld	ra,24(sp)
    80007006:	6442                	ld	s0,16(sp)
    80007008:	64a2                	ld	s1,8(sp)
    8000700a:	6105                	addi	sp,sp,32
    8000700c:	8082                	ret
    panic("release");
    8000700e:	00003517          	auipc	a0,0x3
    80007012:	8ca50513          	addi	a0,a0,-1846 # 800098d8 <digits+0x48>
    80007016:	00000097          	auipc	ra,0x0
    8000701a:	9d4080e7          	jalr	-1580(ra) # 800069ea <panic>

000000008000701e <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000701e:	1141                	addi	sp,sp,-16
    80007020:	e422                	sd	s0,8(sp)
    80007022:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007024:	0ff0000f          	fence
    80007028:	6108                	ld	a0,0(a0)
    8000702a:	0ff0000f          	fence
  return val;
}
    8000702e:	6422                	ld	s0,8(sp)
    80007030:	0141                	addi	sp,sp,16
    80007032:	8082                	ret

0000000080007034 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80007034:	1141                	addi	sp,sp,-16
    80007036:	e422                	sd	s0,8(sp)
    80007038:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000703a:	0ff0000f          	fence
    8000703e:	4108                	lw	a0,0(a0)
    80007040:	0ff0000f          	fence
  return val;
}
    80007044:	6422                	ld	s0,8(sp)
    80007046:	0141                	addi	sp,sp,16
    80007048:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
