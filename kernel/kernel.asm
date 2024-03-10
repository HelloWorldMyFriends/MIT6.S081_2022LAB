
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a2013103          	ld	sp,-1504(sp) # 80008a20 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c0050ef          	jal	ra,800057d6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <freemem_size>:
  freerange(end, (void*)PHYSTOP);
}

void
freemem_size(uint64 *freemem)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *p = kmem.freelist;
    80000028:	00009917          	auipc	s2,0x9
    8000002c:	a6093903          	ld	s2,-1440(s2) # 80008a88 <kmem+0x18>
  (*freemem) = 0;
    80000030:	00053023          	sd	zero,0(a0) # 1000 <_entry-0x7ffff000>
  if(p){
    80000034:	04090063          	beqz	s2,80000074 <freemem_size+0x58>
    80000038:	84aa                	mv	s1,a0
    acquire(&kmem.lock);
    8000003a:	00009517          	auipc	a0,0x9
    8000003e:	a3650513          	addi	a0,a0,-1482 # 80008a70 <kmem>
    80000042:	00006097          	auipc	ra,0x6
    80000046:	17c080e7          	jalr	380(ra) # 800061be <acquire>
    (*freemem) += PGSIZE;
    8000004a:	609c                	ld	a5,0(s1)
    8000004c:	6705                	lui	a4,0x1
    8000004e:	97ba                	add	a5,a5,a4
    80000050:	e09c                	sd	a5,0(s1)
    while(p->next){
    80000052:	00093703          	ld	a4,0(s2)
    80000056:	c719                	beqz	a4,80000064 <freemem_size+0x48>
      p = p->next;
      (*freemem) += PGSIZE;
    80000058:	6685                	lui	a3,0x1
    8000005a:	609c                	ld	a5,0(s1)
    8000005c:	97b6                	add	a5,a5,a3
    8000005e:	e09c                	sd	a5,0(s1)
    while(p->next){
    80000060:	6318                	ld	a4,0(a4)
    80000062:	ff65                	bnez	a4,8000005a <freemem_size+0x3e>
    }
    release(&kmem.lock);
    80000064:	00009517          	auipc	a0,0x9
    80000068:	a0c50513          	addi	a0,a0,-1524 # 80008a70 <kmem>
    8000006c:	00006097          	auipc	ra,0x6
    80000070:	206080e7          	jalr	518(ra) # 80006272 <release>
  }
}
    80000074:	60e2                	ld	ra,24(sp)
    80000076:	6442                	ld	s0,16(sp)
    80000078:	64a2                	ld	s1,8(sp)
    8000007a:	6902                	ld	s2,0(sp)
    8000007c:	6105                	addi	sp,sp,32
    8000007e:	8082                	ret

0000000080000080 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000080:	1101                	addi	sp,sp,-32
    80000082:	ec06                	sd	ra,24(sp)
    80000084:	e822                	sd	s0,16(sp)
    80000086:	e426                	sd	s1,8(sp)
    80000088:	e04a                	sd	s2,0(sp)
    8000008a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000008c:	03451793          	slli	a5,a0,0x34
    80000090:	ebb9                	bnez	a5,800000e6 <kfree+0x66>
    80000092:	84aa                	mv	s1,a0
    80000094:	00022797          	auipc	a5,0x22
    80000098:	04c78793          	addi	a5,a5,76 # 800220e0 <end>
    8000009c:	04f56563          	bltu	a0,a5,800000e6 <kfree+0x66>
    800000a0:	47c5                	li	a5,17
    800000a2:	07ee                	slli	a5,a5,0x1b
    800000a4:	04f57163          	bgeu	a0,a5,800000e6 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800000a8:	6605                	lui	a2,0x1
    800000aa:	4585                	li	a1,1
    800000ac:	00000097          	auipc	ra,0x0
    800000b0:	132080e7          	jalr	306(ra) # 800001de <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800000b4:	00009917          	auipc	s2,0x9
    800000b8:	9bc90913          	addi	s2,s2,-1604 # 80008a70 <kmem>
    800000bc:	854a                	mv	a0,s2
    800000be:	00006097          	auipc	ra,0x6
    800000c2:	100080e7          	jalr	256(ra) # 800061be <acquire>
  r->next = kmem.freelist;
    800000c6:	01893783          	ld	a5,24(s2)
    800000ca:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000cc:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000d0:	854a                	mv	a0,s2
    800000d2:	00006097          	auipc	ra,0x6
    800000d6:	1a0080e7          	jalr	416(ra) # 80006272 <release>
}
    800000da:	60e2                	ld	ra,24(sp)
    800000dc:	6442                	ld	s0,16(sp)
    800000de:	64a2                	ld	s1,8(sp)
    800000e0:	6902                	ld	s2,0(sp)
    800000e2:	6105                	addi	sp,sp,32
    800000e4:	8082                	ret
    panic("kfree");
    800000e6:	00008517          	auipc	a0,0x8
    800000ea:	f2a50513          	addi	a0,a0,-214 # 80008010 <etext+0x10>
    800000ee:	00006097          	auipc	ra,0x6
    800000f2:	b98080e7          	jalr	-1128(ra) # 80005c86 <panic>

00000000800000f6 <freerange>:
{
    800000f6:	7179                	addi	sp,sp,-48
    800000f8:	f406                	sd	ra,40(sp)
    800000fa:	f022                	sd	s0,32(sp)
    800000fc:	ec26                	sd	s1,24(sp)
    800000fe:	e84a                	sd	s2,16(sp)
    80000100:	e44e                	sd	s3,8(sp)
    80000102:	e052                	sd	s4,0(sp)
    80000104:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000106:	6785                	lui	a5,0x1
    80000108:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000010c:	00e504b3          	add	s1,a0,a4
    80000110:	777d                	lui	a4,0xfffff
    80000112:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000114:	94be                	add	s1,s1,a5
    80000116:	0095ee63          	bltu	a1,s1,80000132 <freerange+0x3c>
    8000011a:	892e                	mv	s2,a1
    kfree(p);
    8000011c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000011e:	6985                	lui	s3,0x1
    kfree(p);
    80000120:	01448533          	add	a0,s1,s4
    80000124:	00000097          	auipc	ra,0x0
    80000128:	f5c080e7          	jalr	-164(ra) # 80000080 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000012c:	94ce                	add	s1,s1,s3
    8000012e:	fe9979e3          	bgeu	s2,s1,80000120 <freerange+0x2a>
}
    80000132:	70a2                	ld	ra,40(sp)
    80000134:	7402                	ld	s0,32(sp)
    80000136:	64e2                	ld	s1,24(sp)
    80000138:	6942                	ld	s2,16(sp)
    8000013a:	69a2                	ld	s3,8(sp)
    8000013c:	6a02                	ld	s4,0(sp)
    8000013e:	6145                	addi	sp,sp,48
    80000140:	8082                	ret

0000000080000142 <kinit>:
{
    80000142:	1141                	addi	sp,sp,-16
    80000144:	e406                	sd	ra,8(sp)
    80000146:	e022                	sd	s0,0(sp)
    80000148:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000014a:	00008597          	auipc	a1,0x8
    8000014e:	ece58593          	addi	a1,a1,-306 # 80008018 <etext+0x18>
    80000152:	00009517          	auipc	a0,0x9
    80000156:	91e50513          	addi	a0,a0,-1762 # 80008a70 <kmem>
    8000015a:	00006097          	auipc	ra,0x6
    8000015e:	fd4080e7          	jalr	-44(ra) # 8000612e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000162:	45c5                	li	a1,17
    80000164:	05ee                	slli	a1,a1,0x1b
    80000166:	00022517          	auipc	a0,0x22
    8000016a:	f7a50513          	addi	a0,a0,-134 # 800220e0 <end>
    8000016e:	00000097          	auipc	ra,0x0
    80000172:	f88080e7          	jalr	-120(ra) # 800000f6 <freerange>
}
    80000176:	60a2                	ld	ra,8(sp)
    80000178:	6402                	ld	s0,0(sp)
    8000017a:	0141                	addi	sp,sp,16
    8000017c:	8082                	ret

000000008000017e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000017e:	1101                	addi	sp,sp,-32
    80000180:	ec06                	sd	ra,24(sp)
    80000182:	e822                	sd	s0,16(sp)
    80000184:	e426                	sd	s1,8(sp)
    80000186:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000188:	00009497          	auipc	s1,0x9
    8000018c:	8e848493          	addi	s1,s1,-1816 # 80008a70 <kmem>
    80000190:	8526                	mv	a0,s1
    80000192:	00006097          	auipc	ra,0x6
    80000196:	02c080e7          	jalr	44(ra) # 800061be <acquire>
  r = kmem.freelist;
    8000019a:	6c84                	ld	s1,24(s1)
  if(r)
    8000019c:	c885                	beqz	s1,800001cc <kalloc+0x4e>
    kmem.freelist = r->next;
    8000019e:	609c                	ld	a5,0(s1)
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	8d050513          	addi	a0,a0,-1840 # 80008a70 <kmem>
    800001a8:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	0c8080e7          	jalr	200(ra) # 80006272 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001b2:	6605                	lui	a2,0x1
    800001b4:	4595                	li	a1,5
    800001b6:	8526                	mv	a0,s1
    800001b8:	00000097          	auipc	ra,0x0
    800001bc:	026080e7          	jalr	38(ra) # 800001de <memset>
  return (void*)r;
}
    800001c0:	8526                	mv	a0,s1
    800001c2:	60e2                	ld	ra,24(sp)
    800001c4:	6442                	ld	s0,16(sp)
    800001c6:	64a2                	ld	s1,8(sp)
    800001c8:	6105                	addi	sp,sp,32
    800001ca:	8082                	ret
  release(&kmem.lock);
    800001cc:	00009517          	auipc	a0,0x9
    800001d0:	8a450513          	addi	a0,a0,-1884 # 80008a70 <kmem>
    800001d4:	00006097          	auipc	ra,0x6
    800001d8:	09e080e7          	jalr	158(ra) # 80006272 <release>
  if(r)
    800001dc:	b7d5                	j	800001c0 <kalloc+0x42>

00000000800001de <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001de:	1141                	addi	sp,sp,-16
    800001e0:	e422                	sd	s0,8(sp)
    800001e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001e4:	ca19                	beqz	a2,800001fa <memset+0x1c>
    800001e6:	87aa                	mv	a5,a0
    800001e8:	1602                	slli	a2,a2,0x20
    800001ea:	9201                	srli	a2,a2,0x20
    800001ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001f4:	0785                	addi	a5,a5,1
    800001f6:	fee79de3          	bne	a5,a4,800001f0 <memset+0x12>
  }
  return dst;
}
    800001fa:	6422                	ld	s0,8(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret

0000000080000200 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000200:	1141                	addi	sp,sp,-16
    80000202:	e422                	sd	s0,8(sp)
    80000204:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000206:	ca05                	beqz	a2,80000236 <memcmp+0x36>
    80000208:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000020c:	1682                	slli	a3,a3,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	0685                	addi	a3,a3,1 # 1001 <_entry-0x7fffefff>
    80000212:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000214:	00054783          	lbu	a5,0(a0)
    80000218:	0005c703          	lbu	a4,0(a1)
    8000021c:	00e79863          	bne	a5,a4,8000022c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000220:	0505                	addi	a0,a0,1
    80000222:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000224:	fed518e3          	bne	a0,a3,80000214 <memcmp+0x14>
  }

  return 0;
    80000228:	4501                	li	a0,0
    8000022a:	a019                	j	80000230 <memcmp+0x30>
      return *s1 - *s2;
    8000022c:	40e7853b          	subw	a0,a5,a4
}
    80000230:	6422                	ld	s0,8(sp)
    80000232:	0141                	addi	sp,sp,16
    80000234:	8082                	ret
  return 0;
    80000236:	4501                	li	a0,0
    80000238:	bfe5                	j	80000230 <memcmp+0x30>

000000008000023a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000023a:	1141                	addi	sp,sp,-16
    8000023c:	e422                	sd	s0,8(sp)
    8000023e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000240:	c205                	beqz	a2,80000260 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000242:	02a5e263          	bltu	a1,a0,80000266 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000246:	1602                	slli	a2,a2,0x20
    80000248:	9201                	srli	a2,a2,0x20
    8000024a:	00c587b3          	add	a5,a1,a2
{
    8000024e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000250:	0585                	addi	a1,a1,1
    80000252:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcf21>
    80000254:	fff5c683          	lbu	a3,-1(a1)
    80000258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000025c:	fef59ae3          	bne	a1,a5,80000250 <memmove+0x16>

  return dst;
}
    80000260:	6422                	ld	s0,8(sp)
    80000262:	0141                	addi	sp,sp,16
    80000264:	8082                	ret
  if(s < d && s + n > d){
    80000266:	02061693          	slli	a3,a2,0x20
    8000026a:	9281                	srli	a3,a3,0x20
    8000026c:	00d58733          	add	a4,a1,a3
    80000270:	fce57be3          	bgeu	a0,a4,80000246 <memmove+0xc>
    d += n;
    80000274:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000276:	fff6079b          	addiw	a5,a2,-1
    8000027a:	1782                	slli	a5,a5,0x20
    8000027c:	9381                	srli	a5,a5,0x20
    8000027e:	fff7c793          	not	a5,a5
    80000282:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000284:	177d                	addi	a4,a4,-1
    80000286:	16fd                	addi	a3,a3,-1
    80000288:	00074603          	lbu	a2,0(a4)
    8000028c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000290:	fee79ae3          	bne	a5,a4,80000284 <memmove+0x4a>
    80000294:	b7f1                	j	80000260 <memmove+0x26>

0000000080000296 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000296:	1141                	addi	sp,sp,-16
    80000298:	e406                	sd	ra,8(sp)
    8000029a:	e022                	sd	s0,0(sp)
    8000029c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	f9c080e7          	jalr	-100(ra) # 8000023a <memmove>
}
    800002a6:	60a2                	ld	ra,8(sp)
    800002a8:	6402                	ld	s0,0(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret

00000000800002ae <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002ae:	1141                	addi	sp,sp,-16
    800002b0:	e422                	sd	s0,8(sp)
    800002b2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002b4:	ce11                	beqz	a2,800002d0 <strncmp+0x22>
    800002b6:	00054783          	lbu	a5,0(a0)
    800002ba:	cf89                	beqz	a5,800002d4 <strncmp+0x26>
    800002bc:	0005c703          	lbu	a4,0(a1)
    800002c0:	00f71a63          	bne	a4,a5,800002d4 <strncmp+0x26>
    n--, p++, q++;
    800002c4:	367d                	addiw	a2,a2,-1
    800002c6:	0505                	addi	a0,a0,1
    800002c8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002ca:	f675                	bnez	a2,800002b6 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	a809                	j	800002e0 <strncmp+0x32>
    800002d0:	4501                	li	a0,0
    800002d2:	a039                	j	800002e0 <strncmp+0x32>
  if(n == 0)
    800002d4:	ca09                	beqz	a2,800002e6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002d6:	00054503          	lbu	a0,0(a0)
    800002da:	0005c783          	lbu	a5,0(a1)
    800002de:	9d1d                	subw	a0,a0,a5
}
    800002e0:	6422                	ld	s0,8(sp)
    800002e2:	0141                	addi	sp,sp,16
    800002e4:	8082                	ret
    return 0;
    800002e6:	4501                	li	a0,0
    800002e8:	bfe5                	j	800002e0 <strncmp+0x32>

00000000800002ea <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ea:	1141                	addi	sp,sp,-16
    800002ec:	e422                	sd	s0,8(sp)
    800002ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002f0:	87aa                	mv	a5,a0
    800002f2:	86b2                	mv	a3,a2
    800002f4:	367d                	addiw	a2,a2,-1
    800002f6:	00d05963          	blez	a3,80000308 <strncpy+0x1e>
    800002fa:	0785                	addi	a5,a5,1
    800002fc:	0005c703          	lbu	a4,0(a1)
    80000300:	fee78fa3          	sb	a4,-1(a5)
    80000304:	0585                	addi	a1,a1,1
    80000306:	f775                	bnez	a4,800002f2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000308:	873e                	mv	a4,a5
    8000030a:	9fb5                	addw	a5,a5,a3
    8000030c:	37fd                	addiw	a5,a5,-1
    8000030e:	00c05963          	blez	a2,80000320 <strncpy+0x36>
    *s++ = 0;
    80000312:	0705                	addi	a4,a4,1
    80000314:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000318:	40e786bb          	subw	a3,a5,a4
    8000031c:	fed04be3          	bgtz	a3,80000312 <strncpy+0x28>
  return os;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret

0000000080000326 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e422                	sd	s0,8(sp)
    8000032a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000032c:	02c05363          	blez	a2,80000352 <safestrcpy+0x2c>
    80000330:	fff6069b          	addiw	a3,a2,-1
    80000334:	1682                	slli	a3,a3,0x20
    80000336:	9281                	srli	a3,a3,0x20
    80000338:	96ae                	add	a3,a3,a1
    8000033a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000033c:	00d58963          	beq	a1,a3,8000034e <safestrcpy+0x28>
    80000340:	0585                	addi	a1,a1,1
    80000342:	0785                	addi	a5,a5,1
    80000344:	fff5c703          	lbu	a4,-1(a1)
    80000348:	fee78fa3          	sb	a4,-1(a5)
    8000034c:	fb65                	bnez	a4,8000033c <safestrcpy+0x16>
    ;
  *s = 0;
    8000034e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000352:	6422                	ld	s0,8(sp)
    80000354:	0141                	addi	sp,sp,16
    80000356:	8082                	ret

0000000080000358 <strlen>:

int
strlen(const char *s)
{
    80000358:	1141                	addi	sp,sp,-16
    8000035a:	e422                	sd	s0,8(sp)
    8000035c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000035e:	00054783          	lbu	a5,0(a0)
    80000362:	cf91                	beqz	a5,8000037e <strlen+0x26>
    80000364:	0505                	addi	a0,a0,1
    80000366:	87aa                	mv	a5,a0
    80000368:	86be                	mv	a3,a5
    8000036a:	0785                	addi	a5,a5,1
    8000036c:	fff7c703          	lbu	a4,-1(a5)
    80000370:	ff65                	bnez	a4,80000368 <strlen+0x10>
    80000372:	40a6853b          	subw	a0,a3,a0
    80000376:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000378:	6422                	ld	s0,8(sp)
    8000037a:	0141                	addi	sp,sp,16
    8000037c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000037e:	4501                	li	a0,0
    80000380:	bfe5                	j	80000378 <strlen+0x20>

0000000080000382 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000382:	1141                	addi	sp,sp,-16
    80000384:	e406                	sd	ra,8(sp)
    80000386:	e022                	sd	s0,0(sp)
    80000388:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	b00080e7          	jalr	-1280(ra) # 80000e8a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000392:	00008717          	auipc	a4,0x8
    80000396:	6ae70713          	addi	a4,a4,1710 # 80008a40 <started>
  if(cpuid() == 0){
    8000039a:	c139                	beqz	a0,800003e0 <main+0x5e>
    while(started == 0)
    8000039c:	431c                	lw	a5,0(a4)
    8000039e:	2781                	sext.w	a5,a5
    800003a0:	dff5                	beqz	a5,8000039c <main+0x1a>
      ;
    __sync_synchronize();
    800003a2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003a6:	00001097          	auipc	ra,0x1
    800003aa:	ae4080e7          	jalr	-1308(ra) # 80000e8a <cpuid>
    800003ae:	85aa                	mv	a1,a0
    800003b0:	00008517          	auipc	a0,0x8
    800003b4:	c8850513          	addi	a0,a0,-888 # 80008038 <etext+0x38>
    800003b8:	00006097          	auipc	ra,0x6
    800003bc:	918080e7          	jalr	-1768(ra) # 80005cd0 <printf>
    kvminithart();    // turn on paging
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	0d8080e7          	jalr	216(ra) # 80000498 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003c8:	00001097          	auipc	ra,0x1
    800003cc:	7ca080e7          	jalr	1994(ra) # 80001b92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003d0:	00005097          	auipc	ra,0x5
    800003d4:	dc0080e7          	jalr	-576(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    800003d8:	00001097          	auipc	ra,0x1
    800003dc:	012080e7          	jalr	18(ra) # 800013ea <scheduler>
    consoleinit();
    800003e0:	00005097          	auipc	ra,0x5
    800003e4:	7b6080e7          	jalr	1974(ra) # 80005b96 <consoleinit>
    printfinit();
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	ac8080e7          	jalr	-1336(ra) # 80005eb0 <printfinit>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c5850513          	addi	a0,a0,-936 # 80008048 <etext+0x48>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	8d8080e7          	jalr	-1832(ra) # 80005cd0 <printf>
    printf("xv6 kernel is booting\n");
    80000400:	00008517          	auipc	a0,0x8
    80000404:	c2050513          	addi	a0,a0,-992 # 80008020 <etext+0x20>
    80000408:	00006097          	auipc	ra,0x6
    8000040c:	8c8080e7          	jalr	-1848(ra) # 80005cd0 <printf>
    printf("\n");
    80000410:	00008517          	auipc	a0,0x8
    80000414:	c3850513          	addi	a0,a0,-968 # 80008048 <etext+0x48>
    80000418:	00006097          	auipc	ra,0x6
    8000041c:	8b8080e7          	jalr	-1864(ra) # 80005cd0 <printf>
    kinit();         // physical page allocator
    80000420:	00000097          	auipc	ra,0x0
    80000424:	d22080e7          	jalr	-734(ra) # 80000142 <kinit>
    kvminit();       // create kernel page table
    80000428:	00000097          	auipc	ra,0x0
    8000042c:	326080e7          	jalr	806(ra) # 8000074e <kvminit>
    kvminithart();   // turn on paging
    80000430:	00000097          	auipc	ra,0x0
    80000434:	068080e7          	jalr	104(ra) # 80000498 <kvminithart>
    procinit();      // process table
    80000438:	00001097          	auipc	ra,0x1
    8000043c:	99e080e7          	jalr	-1634(ra) # 80000dd6 <procinit>
    trapinit();      // trap vectors
    80000440:	00001097          	auipc	ra,0x1
    80000444:	72a080e7          	jalr	1834(ra) # 80001b6a <trapinit>
    trapinithart();  // install kernel trap vector
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	74a080e7          	jalr	1866(ra) # 80001b92 <trapinithart>
    plicinit();      // set up interrupt controller
    80000450:	00005097          	auipc	ra,0x5
    80000454:	d2a080e7          	jalr	-726(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	d38080e7          	jalr	-712(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    80000460:	00002097          	auipc	ra,0x2
    80000464:	f32080e7          	jalr	-206(ra) # 80002392 <binit>
    iinit();         // inode table
    80000468:	00002097          	auipc	ra,0x2
    8000046c:	5d0080e7          	jalr	1488(ra) # 80002a38 <iinit>
    fileinit();      // file table
    80000470:	00003097          	auipc	ra,0x3
    80000474:	546080e7          	jalr	1350(ra) # 800039b6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000478:	00005097          	auipc	ra,0x5
    8000047c:	e20080e7          	jalr	-480(ra) # 80005298 <virtio_disk_init>
    userinit();      // first user process
    80000480:	00001097          	auipc	ra,0x1
    80000484:	d0e080e7          	jalr	-754(ra) # 8000118e <userinit>
    __sync_synchronize();
    80000488:	0ff0000f          	fence
    started = 1;
    8000048c:	4785                	li	a5,1
    8000048e:	00008717          	auipc	a4,0x8
    80000492:	5af72923          	sw	a5,1458(a4) # 80008a40 <started>
    80000496:	b789                	j	800003d8 <main+0x56>

0000000080000498 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000498:	1141                	addi	sp,sp,-16
    8000049a:	e422                	sd	s0,8(sp)
    8000049c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000049e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004a2:	00008797          	auipc	a5,0x8
    800004a6:	5a67b783          	ld	a5,1446(a5) # 80008a48 <kernel_pagetable>
    800004aa:	83b1                	srli	a5,a5,0xc
    800004ac:	577d                	li	a4,-1
    800004ae:	177e                	slli	a4,a4,0x3f
    800004b0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004b2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004b6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004ba:	6422                	ld	s0,8(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004c0:	7139                	addi	sp,sp,-64
    800004c2:	fc06                	sd	ra,56(sp)
    800004c4:	f822                	sd	s0,48(sp)
    800004c6:	f426                	sd	s1,40(sp)
    800004c8:	f04a                	sd	s2,32(sp)
    800004ca:	ec4e                	sd	s3,24(sp)
    800004cc:	e852                	sd	s4,16(sp)
    800004ce:	e456                	sd	s5,8(sp)
    800004d0:	e05a                	sd	s6,0(sp)
    800004d2:	0080                	addi	s0,sp,64
    800004d4:	84aa                	mv	s1,a0
    800004d6:	89ae                	mv	s3,a1
    800004d8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004da:	57fd                	li	a5,-1
    800004dc:	83e9                	srli	a5,a5,0x1a
    800004de:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004e0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004e2:	04b7f263          	bgeu	a5,a1,80000526 <walk+0x66>
    panic("walk");
    800004e6:	00008517          	auipc	a0,0x8
    800004ea:	b6a50513          	addi	a0,a0,-1174 # 80008050 <etext+0x50>
    800004ee:	00005097          	auipc	ra,0x5
    800004f2:	798080e7          	jalr	1944(ra) # 80005c86 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004f6:	060a8663          	beqz	s5,80000562 <walk+0xa2>
    800004fa:	00000097          	auipc	ra,0x0
    800004fe:	c84080e7          	jalr	-892(ra) # 8000017e <kalloc>
    80000502:	84aa                	mv	s1,a0
    80000504:	c529                	beqz	a0,8000054e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000506:	6605                	lui	a2,0x1
    80000508:	4581                	li	a1,0
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	cd4080e7          	jalr	-812(ra) # 800001de <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000512:	00c4d793          	srli	a5,s1,0xc
    80000516:	07aa                	slli	a5,a5,0xa
    80000518:	0017e793          	ori	a5,a5,1
    8000051c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000520:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcf17>
    80000522:	036a0063          	beq	s4,s6,80000542 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000526:	0149d933          	srl	s2,s3,s4
    8000052a:	1ff97913          	andi	s2,s2,511
    8000052e:	090e                	slli	s2,s2,0x3
    80000530:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000532:	00093483          	ld	s1,0(s2)
    80000536:	0014f793          	andi	a5,s1,1
    8000053a:	dfd5                	beqz	a5,800004f6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000053c:	80a9                	srli	s1,s1,0xa
    8000053e:	04b2                	slli	s1,s1,0xc
    80000540:	b7c5                	j	80000520 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000542:	00c9d513          	srli	a0,s3,0xc
    80000546:	1ff57513          	andi	a0,a0,511
    8000054a:	050e                	slli	a0,a0,0x3
    8000054c:	9526                	add	a0,a0,s1
}
    8000054e:	70e2                	ld	ra,56(sp)
    80000550:	7442                	ld	s0,48(sp)
    80000552:	74a2                	ld	s1,40(sp)
    80000554:	7902                	ld	s2,32(sp)
    80000556:	69e2                	ld	s3,24(sp)
    80000558:	6a42                	ld	s4,16(sp)
    8000055a:	6aa2                	ld	s5,8(sp)
    8000055c:	6b02                	ld	s6,0(sp)
    8000055e:	6121                	addi	sp,sp,64
    80000560:	8082                	ret
        return 0;
    80000562:	4501                	li	a0,0
    80000564:	b7ed                	j	8000054e <walk+0x8e>

0000000080000566 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000566:	57fd                	li	a5,-1
    80000568:	83e9                	srli	a5,a5,0x1a
    8000056a:	00b7f463          	bgeu	a5,a1,80000572 <walkaddr+0xc>
    return 0;
    8000056e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000570:	8082                	ret
{
    80000572:	1141                	addi	sp,sp,-16
    80000574:	e406                	sd	ra,8(sp)
    80000576:	e022                	sd	s0,0(sp)
    80000578:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000057a:	4601                	li	a2,0
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	f44080e7          	jalr	-188(ra) # 800004c0 <walk>
  if(pte == 0)
    80000584:	c105                	beqz	a0,800005a4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000586:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000588:	0117f693          	andi	a3,a5,17
    8000058c:	4745                	li	a4,17
    return 0;
    8000058e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000590:	00e68663          	beq	a3,a4,8000059c <walkaddr+0x36>
}
    80000594:	60a2                	ld	ra,8(sp)
    80000596:	6402                	ld	s0,0(sp)
    80000598:	0141                	addi	sp,sp,16
    8000059a:	8082                	ret
  pa = PTE2PA(*pte);
    8000059c:	83a9                	srli	a5,a5,0xa
    8000059e:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005a2:	bfcd                	j	80000594 <walkaddr+0x2e>
    return 0;
    800005a4:	4501                	li	a0,0
    800005a6:	b7fd                	j	80000594 <walkaddr+0x2e>

00000000800005a8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005a8:	715d                	addi	sp,sp,-80
    800005aa:	e486                	sd	ra,72(sp)
    800005ac:	e0a2                	sd	s0,64(sp)
    800005ae:	fc26                	sd	s1,56(sp)
    800005b0:	f84a                	sd	s2,48(sp)
    800005b2:	f44e                	sd	s3,40(sp)
    800005b4:	f052                	sd	s4,32(sp)
    800005b6:	ec56                	sd	s5,24(sp)
    800005b8:	e85a                	sd	s6,16(sp)
    800005ba:	e45e                	sd	s7,8(sp)
    800005bc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005be:	c639                	beqz	a2,8000060c <mappages+0x64>
    800005c0:	8aaa                	mv	s5,a0
    800005c2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005c4:	777d                	lui	a4,0xfffff
    800005c6:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005ca:	fff58993          	addi	s3,a1,-1
    800005ce:	99b2                	add	s3,s3,a2
    800005d0:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005d4:	893e                	mv	s2,a5
    800005d6:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005da:	6b85                	lui	s7,0x1
    800005dc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e0:	4605                	li	a2,1
    800005e2:	85ca                	mv	a1,s2
    800005e4:	8556                	mv	a0,s5
    800005e6:	00000097          	auipc	ra,0x0
    800005ea:	eda080e7          	jalr	-294(ra) # 800004c0 <walk>
    800005ee:	cd1d                	beqz	a0,8000062c <mappages+0x84>
    if(*pte & PTE_V)
    800005f0:	611c                	ld	a5,0(a0)
    800005f2:	8b85                	andi	a5,a5,1
    800005f4:	e785                	bnez	a5,8000061c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005f6:	80b1                	srli	s1,s1,0xc
    800005f8:	04aa                	slli	s1,s1,0xa
    800005fa:	0164e4b3          	or	s1,s1,s6
    800005fe:	0014e493          	ori	s1,s1,1
    80000602:	e104                	sd	s1,0(a0)
    if(a == last)
    80000604:	05390063          	beq	s2,s3,80000644 <mappages+0x9c>
    a += PGSIZE;
    80000608:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000060a:	bfc9                	j	800005dc <mappages+0x34>
    panic("mappages: size");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a4c50513          	addi	a0,a0,-1460 # 80008058 <etext+0x58>
    80000614:	00005097          	auipc	ra,0x5
    80000618:	672080e7          	jalr	1650(ra) # 80005c86 <panic>
      panic("mappages: remap");
    8000061c:	00008517          	auipc	a0,0x8
    80000620:	a4c50513          	addi	a0,a0,-1460 # 80008068 <etext+0x68>
    80000624:	00005097          	auipc	ra,0x5
    80000628:	662080e7          	jalr	1634(ra) # 80005c86 <panic>
      return -1;
    8000062c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000062e:	60a6                	ld	ra,72(sp)
    80000630:	6406                	ld	s0,64(sp)
    80000632:	74e2                	ld	s1,56(sp)
    80000634:	7942                	ld	s2,48(sp)
    80000636:	79a2                	ld	s3,40(sp)
    80000638:	7a02                	ld	s4,32(sp)
    8000063a:	6ae2                	ld	s5,24(sp)
    8000063c:	6b42                	ld	s6,16(sp)
    8000063e:	6ba2                	ld	s7,8(sp)
    80000640:	6161                	addi	sp,sp,80
    80000642:	8082                	ret
  return 0;
    80000644:	4501                	li	a0,0
    80000646:	b7e5                	j	8000062e <mappages+0x86>

0000000080000648 <kvmmap>:
{
    80000648:	1141                	addi	sp,sp,-16
    8000064a:	e406                	sd	ra,8(sp)
    8000064c:	e022                	sd	s0,0(sp)
    8000064e:	0800                	addi	s0,sp,16
    80000650:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000652:	86b2                	mv	a3,a2
    80000654:	863e                	mv	a2,a5
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f52080e7          	jalr	-174(ra) # 800005a8 <mappages>
    8000065e:	e509                	bnez	a0,80000668 <kvmmap+0x20>
}
    80000660:	60a2                	ld	ra,8(sp)
    80000662:	6402                	ld	s0,0(sp)
    80000664:	0141                	addi	sp,sp,16
    80000666:	8082                	ret
    panic("kvmmap");
    80000668:	00008517          	auipc	a0,0x8
    8000066c:	a1050513          	addi	a0,a0,-1520 # 80008078 <etext+0x78>
    80000670:	00005097          	auipc	ra,0x5
    80000674:	616080e7          	jalr	1558(ra) # 80005c86 <panic>

0000000080000678 <kvmmake>:
{
    80000678:	1101                	addi	sp,sp,-32
    8000067a:	ec06                	sd	ra,24(sp)
    8000067c:	e822                	sd	s0,16(sp)
    8000067e:	e426                	sd	s1,8(sp)
    80000680:	e04a                	sd	s2,0(sp)
    80000682:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000684:	00000097          	auipc	ra,0x0
    80000688:	afa080e7          	jalr	-1286(ra) # 8000017e <kalloc>
    8000068c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000068e:	6605                	lui	a2,0x1
    80000690:	4581                	li	a1,0
    80000692:	00000097          	auipc	ra,0x0
    80000696:	b4c080e7          	jalr	-1204(ra) # 800001de <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10000637          	lui	a2,0x10000
    800006a2:	100005b7          	lui	a1,0x10000
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	fa0080e7          	jalr	-96(ra) # 80000648 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	6685                	lui	a3,0x1
    800006b4:	10001637          	lui	a2,0x10001
    800006b8:	100015b7          	lui	a1,0x10001
    800006bc:	8526                	mv	a0,s1
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	f8a080e7          	jalr	-118(ra) # 80000648 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006c6:	4719                	li	a4,6
    800006c8:	004006b7          	lui	a3,0x400
    800006cc:	0c000637          	lui	a2,0xc000
    800006d0:	0c0005b7          	lui	a1,0xc000
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	f72080e7          	jalr	-142(ra) # 80000648 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006de:	00008917          	auipc	s2,0x8
    800006e2:	92290913          	addi	s2,s2,-1758 # 80008000 <etext>
    800006e6:	4729                	li	a4,10
    800006e8:	80008697          	auipc	a3,0x80008
    800006ec:	91868693          	addi	a3,a3,-1768 # 8000 <_entry-0x7fff8000>
    800006f0:	4605                	li	a2,1
    800006f2:	067e                	slli	a2,a2,0x1f
    800006f4:	85b2                	mv	a1,a2
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	f50080e7          	jalr	-176(ra) # 80000648 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000700:	4719                	li	a4,6
    80000702:	46c5                	li	a3,17
    80000704:	06ee                	slli	a3,a3,0x1b
    80000706:	412686b3          	sub	a3,a3,s2
    8000070a:	864a                	mv	a2,s2
    8000070c:	85ca                	mv	a1,s2
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f38080e7          	jalr	-200(ra) # 80000648 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000718:	4729                	li	a4,10
    8000071a:	6685                	lui	a3,0x1
    8000071c:	00007617          	auipc	a2,0x7
    80000720:	8e460613          	addi	a2,a2,-1820 # 80007000 <_trampoline>
    80000724:	040005b7          	lui	a1,0x4000
    80000728:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000072a:	05b2                	slli	a1,a1,0xc
    8000072c:	8526                	mv	a0,s1
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	f1a080e7          	jalr	-230(ra) # 80000648 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000736:	8526                	mv	a0,s1
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	608080e7          	jalr	1544(ra) # 80000d40 <proc_mapstacks>
}
    80000740:	8526                	mv	a0,s1
    80000742:	60e2                	ld	ra,24(sp)
    80000744:	6442                	ld	s0,16(sp)
    80000746:	64a2                	ld	s1,8(sp)
    80000748:	6902                	ld	s2,0(sp)
    8000074a:	6105                	addi	sp,sp,32
    8000074c:	8082                	ret

000000008000074e <kvminit>:
{
    8000074e:	1141                	addi	sp,sp,-16
    80000750:	e406                	sd	ra,8(sp)
    80000752:	e022                	sd	s0,0(sp)
    80000754:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	f22080e7          	jalr	-222(ra) # 80000678 <kvmmake>
    8000075e:	00008797          	auipc	a5,0x8
    80000762:	2ea7b523          	sd	a0,746(a5) # 80008a48 <kernel_pagetable>
}
    80000766:	60a2                	ld	ra,8(sp)
    80000768:	6402                	ld	s0,0(sp)
    8000076a:	0141                	addi	sp,sp,16
    8000076c:	8082                	ret

000000008000076e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000076e:	715d                	addi	sp,sp,-80
    80000770:	e486                	sd	ra,72(sp)
    80000772:	e0a2                	sd	s0,64(sp)
    80000774:	fc26                	sd	s1,56(sp)
    80000776:	f84a                	sd	s2,48(sp)
    80000778:	f44e                	sd	s3,40(sp)
    8000077a:	f052                	sd	s4,32(sp)
    8000077c:	ec56                	sd	s5,24(sp)
    8000077e:	e85a                	sd	s6,16(sp)
    80000780:	e45e                	sd	s7,8(sp)
    80000782:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000784:	03459793          	slli	a5,a1,0x34
    80000788:	e795                	bnez	a5,800007b4 <uvmunmap+0x46>
    8000078a:	8a2a                	mv	s4,a0
    8000078c:	892e                	mv	s2,a1
    8000078e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000790:	0632                	slli	a2,a2,0xc
    80000792:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000796:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000798:	6b05                	lui	s6,0x1
    8000079a:	0735e263          	bltu	a1,s3,800007fe <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000079e:	60a6                	ld	ra,72(sp)
    800007a0:	6406                	ld	s0,64(sp)
    800007a2:	74e2                	ld	s1,56(sp)
    800007a4:	7942                	ld	s2,48(sp)
    800007a6:	79a2                	ld	s3,40(sp)
    800007a8:	7a02                	ld	s4,32(sp)
    800007aa:	6ae2                	ld	s5,24(sp)
    800007ac:	6b42                	ld	s6,16(sp)
    800007ae:	6ba2                	ld	s7,8(sp)
    800007b0:	6161                	addi	sp,sp,80
    800007b2:	8082                	ret
    panic("uvmunmap: not aligned");
    800007b4:	00008517          	auipc	a0,0x8
    800007b8:	8cc50513          	addi	a0,a0,-1844 # 80008080 <etext+0x80>
    800007bc:	00005097          	auipc	ra,0x5
    800007c0:	4ca080e7          	jalr	1226(ra) # 80005c86 <panic>
      panic("uvmunmap: walk");
    800007c4:	00008517          	auipc	a0,0x8
    800007c8:	8d450513          	addi	a0,a0,-1836 # 80008098 <etext+0x98>
    800007cc:	00005097          	auipc	ra,0x5
    800007d0:	4ba080e7          	jalr	1210(ra) # 80005c86 <panic>
      panic("uvmunmap: not mapped");
    800007d4:	00008517          	auipc	a0,0x8
    800007d8:	8d450513          	addi	a0,a0,-1836 # 800080a8 <etext+0xa8>
    800007dc:	00005097          	auipc	ra,0x5
    800007e0:	4aa080e7          	jalr	1194(ra) # 80005c86 <panic>
      panic("uvmunmap: not a leaf");
    800007e4:	00008517          	auipc	a0,0x8
    800007e8:	8dc50513          	addi	a0,a0,-1828 # 800080c0 <etext+0xc0>
    800007ec:	00005097          	auipc	ra,0x5
    800007f0:	49a080e7          	jalr	1178(ra) # 80005c86 <panic>
    *pte = 0;
    800007f4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f8:	995a                	add	s2,s2,s6
    800007fa:	fb3972e3          	bgeu	s2,s3,8000079e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007fe:	4601                	li	a2,0
    80000800:	85ca                	mv	a1,s2
    80000802:	8552                	mv	a0,s4
    80000804:	00000097          	auipc	ra,0x0
    80000808:	cbc080e7          	jalr	-836(ra) # 800004c0 <walk>
    8000080c:	84aa                	mv	s1,a0
    8000080e:	d95d                	beqz	a0,800007c4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000810:	6108                	ld	a0,0(a0)
    80000812:	00157793          	andi	a5,a0,1
    80000816:	dfdd                	beqz	a5,800007d4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000818:	3ff57793          	andi	a5,a0,1023
    8000081c:	fd7784e3          	beq	a5,s7,800007e4 <uvmunmap+0x76>
    if(do_free){
    80000820:	fc0a8ae3          	beqz	s5,800007f4 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000824:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000826:	0532                	slli	a0,a0,0xc
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	858080e7          	jalr	-1960(ra) # 80000080 <kfree>
    80000830:	b7d1                	j	800007f4 <uvmunmap+0x86>

0000000080000832 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000832:	1101                	addi	sp,sp,-32
    80000834:	ec06                	sd	ra,24(sp)
    80000836:	e822                	sd	s0,16(sp)
    80000838:	e426                	sd	s1,8(sp)
    8000083a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	942080e7          	jalr	-1726(ra) # 8000017e <kalloc>
    80000844:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000846:	c519                	beqz	a0,80000854 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000848:	6605                	lui	a2,0x1
    8000084a:	4581                	li	a1,0
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	992080e7          	jalr	-1646(ra) # 800001de <memset>
  return pagetable;
}
    80000854:	8526                	mv	a0,s1
    80000856:	60e2                	ld	ra,24(sp)
    80000858:	6442                	ld	s0,16(sp)
    8000085a:	64a2                	ld	s1,8(sp)
    8000085c:	6105                	addi	sp,sp,32
    8000085e:	8082                	ret

0000000080000860 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000860:	7179                	addi	sp,sp,-48
    80000862:	f406                	sd	ra,40(sp)
    80000864:	f022                	sd	s0,32(sp)
    80000866:	ec26                	sd	s1,24(sp)
    80000868:	e84a                	sd	s2,16(sp)
    8000086a:	e44e                	sd	s3,8(sp)
    8000086c:	e052                	sd	s4,0(sp)
    8000086e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000870:	6785                	lui	a5,0x1
    80000872:	04f67863          	bgeu	a2,a5,800008c2 <uvmfirst+0x62>
    80000876:	8a2a                	mv	s4,a0
    80000878:	89ae                	mv	s3,a1
    8000087a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000087c:	00000097          	auipc	ra,0x0
    80000880:	902080e7          	jalr	-1790(ra) # 8000017e <kalloc>
    80000884:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000886:	6605                	lui	a2,0x1
    80000888:	4581                	li	a1,0
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	954080e7          	jalr	-1708(ra) # 800001de <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000892:	4779                	li	a4,30
    80000894:	86ca                	mv	a3,s2
    80000896:	6605                	lui	a2,0x1
    80000898:	4581                	li	a1,0
    8000089a:	8552                	mv	a0,s4
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	d0c080e7          	jalr	-756(ra) # 800005a8 <mappages>
  memmove(mem, src, sz);
    800008a4:	8626                	mv	a2,s1
    800008a6:	85ce                	mv	a1,s3
    800008a8:	854a                	mv	a0,s2
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	990080e7          	jalr	-1648(ra) # 8000023a <memmove>
}
    800008b2:	70a2                	ld	ra,40(sp)
    800008b4:	7402                	ld	s0,32(sp)
    800008b6:	64e2                	ld	s1,24(sp)
    800008b8:	6942                	ld	s2,16(sp)
    800008ba:	69a2                	ld	s3,8(sp)
    800008bc:	6a02                	ld	s4,0(sp)
    800008be:	6145                	addi	sp,sp,48
    800008c0:	8082                	ret
    panic("uvmfirst: more than a page");
    800008c2:	00008517          	auipc	a0,0x8
    800008c6:	81650513          	addi	a0,a0,-2026 # 800080d8 <etext+0xd8>
    800008ca:	00005097          	auipc	ra,0x5
    800008ce:	3bc080e7          	jalr	956(ra) # 80005c86 <panic>

00000000800008d2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008d2:	1101                	addi	sp,sp,-32
    800008d4:	ec06                	sd	ra,24(sp)
    800008d6:	e822                	sd	s0,16(sp)
    800008d8:	e426                	sd	s1,8(sp)
    800008da:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008dc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008de:	00b67d63          	bgeu	a2,a1,800008f8 <uvmdealloc+0x26>
    800008e2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008e4:	6785                	lui	a5,0x1
    800008e6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008e8:	00f60733          	add	a4,a2,a5
    800008ec:	76fd                	lui	a3,0xfffff
    800008ee:	8f75                	and	a4,a4,a3
    800008f0:	97ae                	add	a5,a5,a1
    800008f2:	8ff5                	and	a5,a5,a3
    800008f4:	00f76863          	bltu	a4,a5,80000904 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f8:	8526                	mv	a0,s1
    800008fa:	60e2                	ld	ra,24(sp)
    800008fc:	6442                	ld	s0,16(sp)
    800008fe:	64a2                	ld	s1,8(sp)
    80000900:	6105                	addi	sp,sp,32
    80000902:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000904:	8f99                	sub	a5,a5,a4
    80000906:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000908:	4685                	li	a3,1
    8000090a:	0007861b          	sext.w	a2,a5
    8000090e:	85ba                	mv	a1,a4
    80000910:	00000097          	auipc	ra,0x0
    80000914:	e5e080e7          	jalr	-418(ra) # 8000076e <uvmunmap>
    80000918:	b7c5                	j	800008f8 <uvmdealloc+0x26>

000000008000091a <uvmalloc>:
  if(newsz < oldsz)
    8000091a:	0ab66563          	bltu	a2,a1,800009c4 <uvmalloc+0xaa>
{
    8000091e:	7139                	addi	sp,sp,-64
    80000920:	fc06                	sd	ra,56(sp)
    80000922:	f822                	sd	s0,48(sp)
    80000924:	f426                	sd	s1,40(sp)
    80000926:	f04a                	sd	s2,32(sp)
    80000928:	ec4e                	sd	s3,24(sp)
    8000092a:	e852                	sd	s4,16(sp)
    8000092c:	e456                	sd	s5,8(sp)
    8000092e:	e05a                	sd	s6,0(sp)
    80000930:	0080                	addi	s0,sp,64
    80000932:	8aaa                	mv	s5,a0
    80000934:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000936:	6785                	lui	a5,0x1
    80000938:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000093a:	95be                	add	a1,a1,a5
    8000093c:	77fd                	lui	a5,0xfffff
    8000093e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	08c9f363          	bgeu	s3,a2,800009c8 <uvmalloc+0xae>
    80000946:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000948:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	832080e7          	jalr	-1998(ra) # 8000017e <kalloc>
    80000954:	84aa                	mv	s1,a0
    if(mem == 0){
    80000956:	c51d                	beqz	a0,80000984 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000958:	6605                	lui	a2,0x1
    8000095a:	4581                	li	a1,0
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	882080e7          	jalr	-1918(ra) # 800001de <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000964:	875a                	mv	a4,s6
    80000966:	86a6                	mv	a3,s1
    80000968:	6605                	lui	a2,0x1
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	c3a080e7          	jalr	-966(ra) # 800005a8 <mappages>
    80000976:	e90d                	bnez	a0,800009a8 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000978:	6785                	lui	a5,0x1
    8000097a:	993e                	add	s2,s2,a5
    8000097c:	fd4968e3          	bltu	s2,s4,8000094c <uvmalloc+0x32>
  return newsz;
    80000980:	8552                	mv	a0,s4
    80000982:	a809                	j	80000994 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000984:	864e                	mv	a2,s3
    80000986:	85ca                	mv	a1,s2
    80000988:	8556                	mv	a0,s5
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	f48080e7          	jalr	-184(ra) # 800008d2 <uvmdealloc>
      return 0;
    80000992:	4501                	li	a0,0
}
    80000994:	70e2                	ld	ra,56(sp)
    80000996:	7442                	ld	s0,48(sp)
    80000998:	74a2                	ld	s1,40(sp)
    8000099a:	7902                	ld	s2,32(sp)
    8000099c:	69e2                	ld	s3,24(sp)
    8000099e:	6a42                	ld	s4,16(sp)
    800009a0:	6aa2                	ld	s5,8(sp)
    800009a2:	6b02                	ld	s6,0(sp)
    800009a4:	6121                	addi	sp,sp,64
    800009a6:	8082                	ret
      kfree(mem);
    800009a8:	8526                	mv	a0,s1
    800009aa:	fffff097          	auipc	ra,0xfffff
    800009ae:	6d6080e7          	jalr	1750(ra) # 80000080 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009b2:	864e                	mv	a2,s3
    800009b4:	85ca                	mv	a1,s2
    800009b6:	8556                	mv	a0,s5
    800009b8:	00000097          	auipc	ra,0x0
    800009bc:	f1a080e7          	jalr	-230(ra) # 800008d2 <uvmdealloc>
      return 0;
    800009c0:	4501                	li	a0,0
    800009c2:	bfc9                	j	80000994 <uvmalloc+0x7a>
    return oldsz;
    800009c4:	852e                	mv	a0,a1
}
    800009c6:	8082                	ret
  return newsz;
    800009c8:	8532                	mv	a0,a2
    800009ca:	b7e9                	j	80000994 <uvmalloc+0x7a>

00000000800009cc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009cc:	7179                	addi	sp,sp,-48
    800009ce:	f406                	sd	ra,40(sp)
    800009d0:	f022                	sd	s0,32(sp)
    800009d2:	ec26                	sd	s1,24(sp)
    800009d4:	e84a                	sd	s2,16(sp)
    800009d6:	e44e                	sd	s3,8(sp)
    800009d8:	e052                	sd	s4,0(sp)
    800009da:	1800                	addi	s0,sp,48
    800009dc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009de:	84aa                	mv	s1,a0
    800009e0:	6905                	lui	s2,0x1
    800009e2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e4:	4985                	li	s3,1
    800009e6:	a829                	j	80000a00 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009e8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009ea:	00c79513          	slli	a0,a5,0xc
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	fde080e7          	jalr	-34(ra) # 800009cc <freewalk>
      pagetable[i] = 0;
    800009f6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009fa:	04a1                	addi	s1,s1,8
    800009fc:	03248163          	beq	s1,s2,80000a1e <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a00:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a02:	00f7f713          	andi	a4,a5,15
    80000a06:	ff3701e3          	beq	a4,s3,800009e8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a0a:	8b85                	andi	a5,a5,1
    80000a0c:	d7fd                	beqz	a5,800009fa <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a0e:	00007517          	auipc	a0,0x7
    80000a12:	6ea50513          	addi	a0,a0,1770 # 800080f8 <etext+0xf8>
    80000a16:	00005097          	auipc	ra,0x5
    80000a1a:	270080e7          	jalr	624(ra) # 80005c86 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a1e:	8552                	mv	a0,s4
    80000a20:	fffff097          	auipc	ra,0xfffff
    80000a24:	660080e7          	jalr	1632(ra) # 80000080 <kfree>
}
    80000a28:	70a2                	ld	ra,40(sp)
    80000a2a:	7402                	ld	s0,32(sp)
    80000a2c:	64e2                	ld	s1,24(sp)
    80000a2e:	6942                	ld	s2,16(sp)
    80000a30:	69a2                	ld	s3,8(sp)
    80000a32:	6a02                	ld	s4,0(sp)
    80000a34:	6145                	addi	sp,sp,48
    80000a36:	8082                	ret

0000000080000a38 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a38:	1101                	addi	sp,sp,-32
    80000a3a:	ec06                	sd	ra,24(sp)
    80000a3c:	e822                	sd	s0,16(sp)
    80000a3e:	e426                	sd	s1,8(sp)
    80000a40:	1000                	addi	s0,sp,32
    80000a42:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a44:	e999                	bnez	a1,80000a5a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a46:	8526                	mv	a0,s1
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	f84080e7          	jalr	-124(ra) # 800009cc <freewalk>
}
    80000a50:	60e2                	ld	ra,24(sp)
    80000a52:	6442                	ld	s0,16(sp)
    80000a54:	64a2                	ld	s1,8(sp)
    80000a56:	6105                	addi	sp,sp,32
    80000a58:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a5a:	6785                	lui	a5,0x1
    80000a5c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a5e:	95be                	add	a1,a1,a5
    80000a60:	4685                	li	a3,1
    80000a62:	00c5d613          	srli	a2,a1,0xc
    80000a66:	4581                	li	a1,0
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	d06080e7          	jalr	-762(ra) # 8000076e <uvmunmap>
    80000a70:	bfd9                	j	80000a46 <uvmfree+0xe>

0000000080000a72 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a72:	c679                	beqz	a2,80000b40 <uvmcopy+0xce>
{
    80000a74:	715d                	addi	sp,sp,-80
    80000a76:	e486                	sd	ra,72(sp)
    80000a78:	e0a2                	sd	s0,64(sp)
    80000a7a:	fc26                	sd	s1,56(sp)
    80000a7c:	f84a                	sd	s2,48(sp)
    80000a7e:	f44e                	sd	s3,40(sp)
    80000a80:	f052                	sd	s4,32(sp)
    80000a82:	ec56                	sd	s5,24(sp)
    80000a84:	e85a                	sd	s6,16(sp)
    80000a86:	e45e                	sd	s7,8(sp)
    80000a88:	0880                	addi	s0,sp,80
    80000a8a:	8b2a                	mv	s6,a0
    80000a8c:	8aae                	mv	s5,a1
    80000a8e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a90:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a92:	4601                	li	a2,0
    80000a94:	85ce                	mv	a1,s3
    80000a96:	855a                	mv	a0,s6
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	a28080e7          	jalr	-1496(ra) # 800004c0 <walk>
    80000aa0:	c531                	beqz	a0,80000aec <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000aa2:	6118                	ld	a4,0(a0)
    80000aa4:	00177793          	andi	a5,a4,1
    80000aa8:	cbb1                	beqz	a5,80000afc <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000aaa:	00a75593          	srli	a1,a4,0xa
    80000aae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000ab2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000ab6:	fffff097          	auipc	ra,0xfffff
    80000aba:	6c8080e7          	jalr	1736(ra) # 8000017e <kalloc>
    80000abe:	892a                	mv	s2,a0
    80000ac0:	c939                	beqz	a0,80000b16 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ac2:	6605                	lui	a2,0x1
    80000ac4:	85de                	mv	a1,s7
    80000ac6:	fffff097          	auipc	ra,0xfffff
    80000aca:	774080e7          	jalr	1908(ra) # 8000023a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ace:	8726                	mv	a4,s1
    80000ad0:	86ca                	mv	a3,s2
    80000ad2:	6605                	lui	a2,0x1
    80000ad4:	85ce                	mv	a1,s3
    80000ad6:	8556                	mv	a0,s5
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	ad0080e7          	jalr	-1328(ra) # 800005a8 <mappages>
    80000ae0:	e515                	bnez	a0,80000b0c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ae2:	6785                	lui	a5,0x1
    80000ae4:	99be                	add	s3,s3,a5
    80000ae6:	fb49e6e3          	bltu	s3,s4,80000a92 <uvmcopy+0x20>
    80000aea:	a081                	j	80000b2a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aec:	00007517          	auipc	a0,0x7
    80000af0:	61c50513          	addi	a0,a0,1564 # 80008108 <etext+0x108>
    80000af4:	00005097          	auipc	ra,0x5
    80000af8:	192080e7          	jalr	402(ra) # 80005c86 <panic>
      panic("uvmcopy: page not present");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	62c50513          	addi	a0,a0,1580 # 80008128 <etext+0x128>
    80000b04:	00005097          	auipc	ra,0x5
    80000b08:	182080e7          	jalr	386(ra) # 80005c86 <panic>
      kfree(mem);
    80000b0c:	854a                	mv	a0,s2
    80000b0e:	fffff097          	auipc	ra,0xfffff
    80000b12:	572080e7          	jalr	1394(ra) # 80000080 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b16:	4685                	li	a3,1
    80000b18:	00c9d613          	srli	a2,s3,0xc
    80000b1c:	4581                	li	a1,0
    80000b1e:	8556                	mv	a0,s5
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	c4e080e7          	jalr	-946(ra) # 8000076e <uvmunmap>
  return -1;
    80000b28:	557d                	li	a0,-1
}
    80000b2a:	60a6                	ld	ra,72(sp)
    80000b2c:	6406                	ld	s0,64(sp)
    80000b2e:	74e2                	ld	s1,56(sp)
    80000b30:	7942                	ld	s2,48(sp)
    80000b32:	79a2                	ld	s3,40(sp)
    80000b34:	7a02                	ld	s4,32(sp)
    80000b36:	6ae2                	ld	s5,24(sp)
    80000b38:	6b42                	ld	s6,16(sp)
    80000b3a:	6ba2                	ld	s7,8(sp)
    80000b3c:	6161                	addi	sp,sp,80
    80000b3e:	8082                	ret
  return 0;
    80000b40:	4501                	li	a0,0
}
    80000b42:	8082                	ret

0000000080000b44 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b44:	1141                	addi	sp,sp,-16
    80000b46:	e406                	sd	ra,8(sp)
    80000b48:	e022                	sd	s0,0(sp)
    80000b4a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b4c:	4601                	li	a2,0
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	972080e7          	jalr	-1678(ra) # 800004c0 <walk>
  if(pte == 0)
    80000b56:	c901                	beqz	a0,80000b66 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b58:	611c                	ld	a5,0(a0)
    80000b5a:	9bbd                	andi	a5,a5,-17
    80000b5c:	e11c                	sd	a5,0(a0)
}
    80000b5e:	60a2                	ld	ra,8(sp)
    80000b60:	6402                	ld	s0,0(sp)
    80000b62:	0141                	addi	sp,sp,16
    80000b64:	8082                	ret
    panic("uvmclear");
    80000b66:	00007517          	auipc	a0,0x7
    80000b6a:	5e250513          	addi	a0,a0,1506 # 80008148 <etext+0x148>
    80000b6e:	00005097          	auipc	ra,0x5
    80000b72:	118080e7          	jalr	280(ra) # 80005c86 <panic>

0000000080000b76 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b76:	c6bd                	beqz	a3,80000be4 <copyout+0x6e>
{
    80000b78:	715d                	addi	sp,sp,-80
    80000b7a:	e486                	sd	ra,72(sp)
    80000b7c:	e0a2                	sd	s0,64(sp)
    80000b7e:	fc26                	sd	s1,56(sp)
    80000b80:	f84a                	sd	s2,48(sp)
    80000b82:	f44e                	sd	s3,40(sp)
    80000b84:	f052                	sd	s4,32(sp)
    80000b86:	ec56                	sd	s5,24(sp)
    80000b88:	e85a                	sd	s6,16(sp)
    80000b8a:	e45e                	sd	s7,8(sp)
    80000b8c:	e062                	sd	s8,0(sp)
    80000b8e:	0880                	addi	s0,sp,80
    80000b90:	8b2a                	mv	s6,a0
    80000b92:	8c2e                	mv	s8,a1
    80000b94:	8a32                	mv	s4,a2
    80000b96:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b98:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b9a:	6a85                	lui	s5,0x1
    80000b9c:	a015                	j	80000bc0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b9e:	9562                	add	a0,a0,s8
    80000ba0:	0004861b          	sext.w	a2,s1
    80000ba4:	85d2                	mv	a1,s4
    80000ba6:	41250533          	sub	a0,a0,s2
    80000baa:	fffff097          	auipc	ra,0xfffff
    80000bae:	690080e7          	jalr	1680(ra) # 8000023a <memmove>

    len -= n;
    80000bb2:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bb6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bb8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bbc:	02098263          	beqz	s3,80000be0 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bc0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bc4:	85ca                	mv	a1,s2
    80000bc6:	855a                	mv	a0,s6
    80000bc8:	00000097          	auipc	ra,0x0
    80000bcc:	99e080e7          	jalr	-1634(ra) # 80000566 <walkaddr>
    if(pa0 == 0)
    80000bd0:	cd01                	beqz	a0,80000be8 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bd2:	418904b3          	sub	s1,s2,s8
    80000bd6:	94d6                	add	s1,s1,s5
    80000bd8:	fc99f3e3          	bgeu	s3,s1,80000b9e <copyout+0x28>
    80000bdc:	84ce                	mv	s1,s3
    80000bde:	b7c1                	j	80000b9e <copyout+0x28>
  }
  return 0;
    80000be0:	4501                	li	a0,0
    80000be2:	a021                	j	80000bea <copyout+0x74>
    80000be4:	4501                	li	a0,0
}
    80000be6:	8082                	ret
      return -1;
    80000be8:	557d                	li	a0,-1
}
    80000bea:	60a6                	ld	ra,72(sp)
    80000bec:	6406                	ld	s0,64(sp)
    80000bee:	74e2                	ld	s1,56(sp)
    80000bf0:	7942                	ld	s2,48(sp)
    80000bf2:	79a2                	ld	s3,40(sp)
    80000bf4:	7a02                	ld	s4,32(sp)
    80000bf6:	6ae2                	ld	s5,24(sp)
    80000bf8:	6b42                	ld	s6,16(sp)
    80000bfa:	6ba2                	ld	s7,8(sp)
    80000bfc:	6c02                	ld	s8,0(sp)
    80000bfe:	6161                	addi	sp,sp,80
    80000c00:	8082                	ret

0000000080000c02 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c02:	caa5                	beqz	a3,80000c72 <copyin+0x70>
{
    80000c04:	715d                	addi	sp,sp,-80
    80000c06:	e486                	sd	ra,72(sp)
    80000c08:	e0a2                	sd	s0,64(sp)
    80000c0a:	fc26                	sd	s1,56(sp)
    80000c0c:	f84a                	sd	s2,48(sp)
    80000c0e:	f44e                	sd	s3,40(sp)
    80000c10:	f052                	sd	s4,32(sp)
    80000c12:	ec56                	sd	s5,24(sp)
    80000c14:	e85a                	sd	s6,16(sp)
    80000c16:	e45e                	sd	s7,8(sp)
    80000c18:	e062                	sd	s8,0(sp)
    80000c1a:	0880                	addi	s0,sp,80
    80000c1c:	8b2a                	mv	s6,a0
    80000c1e:	8a2e                	mv	s4,a1
    80000c20:	8c32                	mv	s8,a2
    80000c22:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c24:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c26:	6a85                	lui	s5,0x1
    80000c28:	a01d                	j	80000c4e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c2a:	018505b3          	add	a1,a0,s8
    80000c2e:	0004861b          	sext.w	a2,s1
    80000c32:	412585b3          	sub	a1,a1,s2
    80000c36:	8552                	mv	a0,s4
    80000c38:	fffff097          	auipc	ra,0xfffff
    80000c3c:	602080e7          	jalr	1538(ra) # 8000023a <memmove>

    len -= n;
    80000c40:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c44:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c46:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c4a:	02098263          	beqz	s3,80000c6e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c52:	85ca                	mv	a1,s2
    80000c54:	855a                	mv	a0,s6
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	910080e7          	jalr	-1776(ra) # 80000566 <walkaddr>
    if(pa0 == 0)
    80000c5e:	cd01                	beqz	a0,80000c76 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c60:	418904b3          	sub	s1,s2,s8
    80000c64:	94d6                	add	s1,s1,s5
    80000c66:	fc99f2e3          	bgeu	s3,s1,80000c2a <copyin+0x28>
    80000c6a:	84ce                	mv	s1,s3
    80000c6c:	bf7d                	j	80000c2a <copyin+0x28>
  }
  return 0;
    80000c6e:	4501                	li	a0,0
    80000c70:	a021                	j	80000c78 <copyin+0x76>
    80000c72:	4501                	li	a0,0
}
    80000c74:	8082                	ret
      return -1;
    80000c76:	557d                	li	a0,-1
}
    80000c78:	60a6                	ld	ra,72(sp)
    80000c7a:	6406                	ld	s0,64(sp)
    80000c7c:	74e2                	ld	s1,56(sp)
    80000c7e:	7942                	ld	s2,48(sp)
    80000c80:	79a2                	ld	s3,40(sp)
    80000c82:	7a02                	ld	s4,32(sp)
    80000c84:	6ae2                	ld	s5,24(sp)
    80000c86:	6b42                	ld	s6,16(sp)
    80000c88:	6ba2                	ld	s7,8(sp)
    80000c8a:	6c02                	ld	s8,0(sp)
    80000c8c:	6161                	addi	sp,sp,80
    80000c8e:	8082                	ret

0000000080000c90 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c90:	c2dd                	beqz	a3,80000d36 <copyinstr+0xa6>
{
    80000c92:	715d                	addi	sp,sp,-80
    80000c94:	e486                	sd	ra,72(sp)
    80000c96:	e0a2                	sd	s0,64(sp)
    80000c98:	fc26                	sd	s1,56(sp)
    80000c9a:	f84a                	sd	s2,48(sp)
    80000c9c:	f44e                	sd	s3,40(sp)
    80000c9e:	f052                	sd	s4,32(sp)
    80000ca0:	ec56                	sd	s5,24(sp)
    80000ca2:	e85a                	sd	s6,16(sp)
    80000ca4:	e45e                	sd	s7,8(sp)
    80000ca6:	0880                	addi	s0,sp,80
    80000ca8:	8a2a                	mv	s4,a0
    80000caa:	8b2e                	mv	s6,a1
    80000cac:	8bb2                	mv	s7,a2
    80000cae:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cb0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cb2:	6985                	lui	s3,0x1
    80000cb4:	a02d                	j	80000cde <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cb6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cba:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cbc:	37fd                	addiw	a5,a5,-1
    80000cbe:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cc2:	60a6                	ld	ra,72(sp)
    80000cc4:	6406                	ld	s0,64(sp)
    80000cc6:	74e2                	ld	s1,56(sp)
    80000cc8:	7942                	ld	s2,48(sp)
    80000cca:	79a2                	ld	s3,40(sp)
    80000ccc:	7a02                	ld	s4,32(sp)
    80000cce:	6ae2                	ld	s5,24(sp)
    80000cd0:	6b42                	ld	s6,16(sp)
    80000cd2:	6ba2                	ld	s7,8(sp)
    80000cd4:	6161                	addi	sp,sp,80
    80000cd6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cdc:	c8a9                	beqz	s1,80000d2e <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cde:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ce2:	85ca                	mv	a1,s2
    80000ce4:	8552                	mv	a0,s4
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	880080e7          	jalr	-1920(ra) # 80000566 <walkaddr>
    if(pa0 == 0)
    80000cee:	c131                	beqz	a0,80000d32 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cf0:	417906b3          	sub	a3,s2,s7
    80000cf4:	96ce                	add	a3,a3,s3
    80000cf6:	00d4f363          	bgeu	s1,a3,80000cfc <copyinstr+0x6c>
    80000cfa:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cfc:	955e                	add	a0,a0,s7
    80000cfe:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d02:	daf9                	beqz	a3,80000cd8 <copyinstr+0x48>
    80000d04:	87da                	mv	a5,s6
    80000d06:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d08:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d0c:	96da                	add	a3,a3,s6
    80000d0e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d10:	00f60733          	add	a4,a2,a5
    80000d14:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf20>
    80000d18:	df59                	beqz	a4,80000cb6 <copyinstr+0x26>
        *dst = *p;
    80000d1a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d1e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d20:	fed797e3          	bne	a5,a3,80000d0e <copyinstr+0x7e>
    80000d24:	14fd                	addi	s1,s1,-1
    80000d26:	94c2                	add	s1,s1,a6
      --max;
    80000d28:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d2a:	8b3e                	mv	s6,a5
    80000d2c:	b775                	j	80000cd8 <copyinstr+0x48>
    80000d2e:	4781                	li	a5,0
    80000d30:	b771                	j	80000cbc <copyinstr+0x2c>
      return -1;
    80000d32:	557d                	li	a0,-1
    80000d34:	b779                	j	80000cc2 <copyinstr+0x32>
  int got_null = 0;
    80000d36:	4781                	li	a5,0
  if(got_null){
    80000d38:	37fd                	addiw	a5,a5,-1
    80000d3a:	0007851b          	sext.w	a0,a5
}
    80000d3e:	8082                	ret

0000000080000d40 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d40:	7139                	addi	sp,sp,-64
    80000d42:	fc06                	sd	ra,56(sp)
    80000d44:	f822                	sd	s0,48(sp)
    80000d46:	f426                	sd	s1,40(sp)
    80000d48:	f04a                	sd	s2,32(sp)
    80000d4a:	ec4e                	sd	s3,24(sp)
    80000d4c:	e852                	sd	s4,16(sp)
    80000d4e:	e456                	sd	s5,8(sp)
    80000d50:	e05a                	sd	s6,0(sp)
    80000d52:	0080                	addi	s0,sp,64
    80000d54:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d56:	00008497          	auipc	s1,0x8
    80000d5a:	16a48493          	addi	s1,s1,362 # 80008ec0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d5e:	8b26                	mv	s6,s1
    80000d60:	00007a97          	auipc	s5,0x7
    80000d64:	2a0a8a93          	addi	s5,s5,672 # 80008000 <etext>
    80000d68:	04000937          	lui	s2,0x4000
    80000d6c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d6e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d70:	0000ea17          	auipc	s4,0xe
    80000d74:	d50a0a13          	addi	s4,s4,-688 # 8000eac0 <tickslock>
    char *pa = kalloc();
    80000d78:	fffff097          	auipc	ra,0xfffff
    80000d7c:	406080e7          	jalr	1030(ra) # 8000017e <kalloc>
    80000d80:	862a                	mv	a2,a0
    if(pa == 0)
    80000d82:	c131                	beqz	a0,80000dc6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d84:	416485b3          	sub	a1,s1,s6
    80000d88:	8591                	srai	a1,a1,0x4
    80000d8a:	000ab783          	ld	a5,0(s5)
    80000d8e:	02f585b3          	mul	a1,a1,a5
    80000d92:	2585                	addiw	a1,a1,1
    80000d94:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d98:	4719                	li	a4,6
    80000d9a:	6685                	lui	a3,0x1
    80000d9c:	40b905b3          	sub	a1,s2,a1
    80000da0:	854e                	mv	a0,s3
    80000da2:	00000097          	auipc	ra,0x0
    80000da6:	8a6080e7          	jalr	-1882(ra) # 80000648 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000daa:	17048493          	addi	s1,s1,368
    80000dae:	fd4495e3          	bne	s1,s4,80000d78 <proc_mapstacks+0x38>
  }
}
    80000db2:	70e2                	ld	ra,56(sp)
    80000db4:	7442                	ld	s0,48(sp)
    80000db6:	74a2                	ld	s1,40(sp)
    80000db8:	7902                	ld	s2,32(sp)
    80000dba:	69e2                	ld	s3,24(sp)
    80000dbc:	6a42                	ld	s4,16(sp)
    80000dbe:	6aa2                	ld	s5,8(sp)
    80000dc0:	6b02                	ld	s6,0(sp)
    80000dc2:	6121                	addi	sp,sp,64
    80000dc4:	8082                	ret
      panic("kalloc");
    80000dc6:	00007517          	auipc	a0,0x7
    80000dca:	39250513          	addi	a0,a0,914 # 80008158 <etext+0x158>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	eb8080e7          	jalr	-328(ra) # 80005c86 <panic>

0000000080000dd6 <procinit>:

// initialize the proc table.
void
procinit(void)
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
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dea:	00007597          	auipc	a1,0x7
    80000dee:	37658593          	addi	a1,a1,886 # 80008160 <etext+0x160>
    80000df2:	00008517          	auipc	a0,0x8
    80000df6:	c9e50513          	addi	a0,a0,-866 # 80008a90 <pid_lock>
    80000dfa:	00005097          	auipc	ra,0x5
    80000dfe:	334080e7          	jalr	820(ra) # 8000612e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e02:	00007597          	auipc	a1,0x7
    80000e06:	36658593          	addi	a1,a1,870 # 80008168 <etext+0x168>
    80000e0a:	00008517          	auipc	a0,0x8
    80000e0e:	c9e50513          	addi	a0,a0,-866 # 80008aa8 <wait_lock>
    80000e12:	00005097          	auipc	ra,0x5
    80000e16:	31c080e7          	jalr	796(ra) # 8000612e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	00008497          	auipc	s1,0x8
    80000e1e:	0a648493          	addi	s1,s1,166 # 80008ec0 <proc>
      initlock(&p->lock, "proc");
    80000e22:	00007b17          	auipc	s6,0x7
    80000e26:	356b0b13          	addi	s6,s6,854 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e2a:	8aa6                	mv	s5,s1
    80000e2c:	00007a17          	auipc	s4,0x7
    80000e30:	1d4a0a13          	addi	s4,s4,468 # 80008000 <etext>
    80000e34:	04000937          	lui	s2,0x4000
    80000e38:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e3a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3c:	0000e997          	auipc	s3,0xe
    80000e40:	c8498993          	addi	s3,s3,-892 # 8000eac0 <tickslock>
      initlock(&p->lock, "proc");
    80000e44:	85da                	mv	a1,s6
    80000e46:	8526                	mv	a0,s1
    80000e48:	00005097          	auipc	ra,0x5
    80000e4c:	2e6080e7          	jalr	742(ra) # 8000612e <initlock>
      p->state = UNUSED;
    80000e50:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e54:	415487b3          	sub	a5,s1,s5
    80000e58:	8791                	srai	a5,a5,0x4
    80000e5a:	000a3703          	ld	a4,0(s4)
    80000e5e:	02e787b3          	mul	a5,a5,a4
    80000e62:	2785                	addiw	a5,a5,1
    80000e64:	00d7979b          	slliw	a5,a5,0xd
    80000e68:	40f907b3          	sub	a5,s2,a5
    80000e6c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e6e:	17048493          	addi	s1,s1,368
    80000e72:	fd3499e3          	bne	s1,s3,80000e44 <procinit+0x6e>
  }
}
    80000e76:	70e2                	ld	ra,56(sp)
    80000e78:	7442                	ld	s0,48(sp)
    80000e7a:	74a2                	ld	s1,40(sp)
    80000e7c:	7902                	ld	s2,32(sp)
    80000e7e:	69e2                	ld	s3,24(sp)
    80000e80:	6a42                	ld	s4,16(sp)
    80000e82:	6aa2                	ld	s5,8(sp)
    80000e84:	6b02                	ld	s6,0(sp)
    80000e86:	6121                	addi	sp,sp,64
    80000e88:	8082                	ret

0000000080000e8a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e8a:	1141                	addi	sp,sp,-16
    80000e8c:	e422                	sd	s0,8(sp)
    80000e8e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e90:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e92:	2501                	sext.w	a0,a0
    80000e94:	6422                	ld	s0,8(sp)
    80000e96:	0141                	addi	sp,sp,16
    80000e98:	8082                	ret

0000000080000e9a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	addi	s0,sp,16
    80000ea0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000ea2:	2781                	sext.w	a5,a5
    80000ea4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ea6:	00008517          	auipc	a0,0x8
    80000eaa:	c1a50513          	addi	a0,a0,-998 # 80008ac0 <cpus>
    80000eae:	953e                	add	a0,a0,a5
    80000eb0:	6422                	ld	s0,8(sp)
    80000eb2:	0141                	addi	sp,sp,16
    80000eb4:	8082                	ret

0000000080000eb6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000eb6:	1101                	addi	sp,sp,-32
    80000eb8:	ec06                	sd	ra,24(sp)
    80000eba:	e822                	sd	s0,16(sp)
    80000ebc:	e426                	sd	s1,8(sp)
    80000ebe:	1000                	addi	s0,sp,32
  push_off();
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	2b2080e7          	jalr	690(ra) # 80006172 <push_off>
    80000ec8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eca:	2781                	sext.w	a5,a5
    80000ecc:	079e                	slli	a5,a5,0x7
    80000ece:	00008717          	auipc	a4,0x8
    80000ed2:	bc270713          	addi	a4,a4,-1086 # 80008a90 <pid_lock>
    80000ed6:	97ba                	add	a5,a5,a4
    80000ed8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	338080e7          	jalr	824(ra) # 80006212 <pop_off>
  return p;
}
    80000ee2:	8526                	mv	a0,s1
    80000ee4:	60e2                	ld	ra,24(sp)
    80000ee6:	6442                	ld	s0,16(sp)
    80000ee8:	64a2                	ld	s1,8(sp)
    80000eea:	6105                	addi	sp,sp,32
    80000eec:	8082                	ret

0000000080000eee <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e406                	sd	ra,8(sp)
    80000ef2:	e022                	sd	s0,0(sp)
    80000ef4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ef6:	00000097          	auipc	ra,0x0
    80000efa:	fc0080e7          	jalr	-64(ra) # 80000eb6 <myproc>
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	374080e7          	jalr	884(ra) # 80006272 <release>

  if (first) {
    80000f06:	00008797          	auipc	a5,0x8
    80000f0a:	aca7a783          	lw	a5,-1334(a5) # 800089d0 <first.1>
    80000f0e:	eb89                	bnez	a5,80000f20 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f10:	00001097          	auipc	ra,0x1
    80000f14:	c9a080e7          	jalr	-870(ra) # 80001baa <usertrapret>
}
    80000f18:	60a2                	ld	ra,8(sp)
    80000f1a:	6402                	ld	s0,0(sp)
    80000f1c:	0141                	addi	sp,sp,16
    80000f1e:	8082                	ret
    first = 0;
    80000f20:	00008797          	auipc	a5,0x8
    80000f24:	aa07a823          	sw	zero,-1360(a5) # 800089d0 <first.1>
    fsinit(ROOTDEV);
    80000f28:	4505                	li	a0,1
    80000f2a:	00002097          	auipc	ra,0x2
    80000f2e:	a8e080e7          	jalr	-1394(ra) # 800029b8 <fsinit>
    80000f32:	bff9                	j	80000f10 <forkret+0x22>

0000000080000f34 <allocpid>:
{
    80000f34:	1101                	addi	sp,sp,-32
    80000f36:	ec06                	sd	ra,24(sp)
    80000f38:	e822                	sd	s0,16(sp)
    80000f3a:	e426                	sd	s1,8(sp)
    80000f3c:	e04a                	sd	s2,0(sp)
    80000f3e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f40:	00008917          	auipc	s2,0x8
    80000f44:	b5090913          	addi	s2,s2,-1200 # 80008a90 <pid_lock>
    80000f48:	854a                	mv	a0,s2
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	274080e7          	jalr	628(ra) # 800061be <acquire>
  pid = nextpid;
    80000f52:	00008797          	auipc	a5,0x8
    80000f56:	a8278793          	addi	a5,a5,-1406 # 800089d4 <nextpid>
    80000f5a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f5c:	0014871b          	addiw	a4,s1,1
    80000f60:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f62:	854a                	mv	a0,s2
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	30e080e7          	jalr	782(ra) # 80006272 <release>
}
    80000f6c:	8526                	mv	a0,s1
    80000f6e:	60e2                	ld	ra,24(sp)
    80000f70:	6442                	ld	s0,16(sp)
    80000f72:	64a2                	ld	s1,8(sp)
    80000f74:	6902                	ld	s2,0(sp)
    80000f76:	6105                	addi	sp,sp,32
    80000f78:	8082                	ret

0000000080000f7a <proc_pagetable>:
{
    80000f7a:	1101                	addi	sp,sp,-32
    80000f7c:	ec06                	sd	ra,24(sp)
    80000f7e:	e822                	sd	s0,16(sp)
    80000f80:	e426                	sd	s1,8(sp)
    80000f82:	e04a                	sd	s2,0(sp)
    80000f84:	1000                	addi	s0,sp,32
    80000f86:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f88:	00000097          	auipc	ra,0x0
    80000f8c:	8aa080e7          	jalr	-1878(ra) # 80000832 <uvmcreate>
    80000f90:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f92:	c121                	beqz	a0,80000fd2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f94:	4729                	li	a4,10
    80000f96:	00006697          	auipc	a3,0x6
    80000f9a:	06a68693          	addi	a3,a3,106 # 80007000 <_trampoline>
    80000f9e:	6605                	lui	a2,0x1
    80000fa0:	040005b7          	lui	a1,0x4000
    80000fa4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fa6:	05b2                	slli	a1,a1,0xc
    80000fa8:	fffff097          	auipc	ra,0xfffff
    80000fac:	600080e7          	jalr	1536(ra) # 800005a8 <mappages>
    80000fb0:	02054863          	bltz	a0,80000fe0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fb4:	4719                	li	a4,6
    80000fb6:	05893683          	ld	a3,88(s2)
    80000fba:	6605                	lui	a2,0x1
    80000fbc:	020005b7          	lui	a1,0x2000
    80000fc0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc2:	05b6                	slli	a1,a1,0xd
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	5e2080e7          	jalr	1506(ra) # 800005a8 <mappages>
    80000fce:	02054163          	bltz	a0,80000ff0 <proc_pagetable+0x76>
}
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret
    uvmfree(pagetable, 0);
    80000fe0:	4581                	li	a1,0
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	a54080e7          	jalr	-1452(ra) # 80000a38 <uvmfree>
    return 0;
    80000fec:	4481                	li	s1,0
    80000fee:	b7d5                	j	80000fd2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ff0:	4681                	li	a3,0
    80000ff2:	4605                	li	a2,1
    80000ff4:	040005b7          	lui	a1,0x4000
    80000ff8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ffa:	05b2                	slli	a1,a1,0xc
    80000ffc:	8526                	mv	a0,s1
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	770080e7          	jalr	1904(ra) # 8000076e <uvmunmap>
    uvmfree(pagetable, 0);
    80001006:	4581                	li	a1,0
    80001008:	8526                	mv	a0,s1
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	a2e080e7          	jalr	-1490(ra) # 80000a38 <uvmfree>
    return 0;
    80001012:	4481                	li	s1,0
    80001014:	bf7d                	j	80000fd2 <proc_pagetable+0x58>

0000000080001016 <proc_freepagetable>:
{
    80001016:	1101                	addi	sp,sp,-32
    80001018:	ec06                	sd	ra,24(sp)
    8000101a:	e822                	sd	s0,16(sp)
    8000101c:	e426                	sd	s1,8(sp)
    8000101e:	e04a                	sd	s2,0(sp)
    80001020:	1000                	addi	s0,sp,32
    80001022:	84aa                	mv	s1,a0
    80001024:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001026:	4681                	li	a3,0
    80001028:	4605                	li	a2,1
    8000102a:	040005b7          	lui	a1,0x4000
    8000102e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001030:	05b2                	slli	a1,a1,0xc
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	73c080e7          	jalr	1852(ra) # 8000076e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000103a:	4681                	li	a3,0
    8000103c:	4605                	li	a2,1
    8000103e:	020005b7          	lui	a1,0x2000
    80001042:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001044:	05b6                	slli	a1,a1,0xd
    80001046:	8526                	mv	a0,s1
    80001048:	fffff097          	auipc	ra,0xfffff
    8000104c:	726080e7          	jalr	1830(ra) # 8000076e <uvmunmap>
  uvmfree(pagetable, sz);
    80001050:	85ca                	mv	a1,s2
    80001052:	8526                	mv	a0,s1
    80001054:	00000097          	auipc	ra,0x0
    80001058:	9e4080e7          	jalr	-1564(ra) # 80000a38 <uvmfree>
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6902                	ld	s2,0(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret

0000000080001068 <freeproc>:
{
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	1000                	addi	s0,sp,32
    80001072:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001074:	6d28                	ld	a0,88(a0)
    80001076:	c509                	beqz	a0,80001080 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001078:	fffff097          	auipc	ra,0xfffff
    8000107c:	008080e7          	jalr	8(ra) # 80000080 <kfree>
  p->trapframe = 0;
    80001080:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001084:	68a8                	ld	a0,80(s1)
    80001086:	c511                	beqz	a0,80001092 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001088:	64ac                	ld	a1,72(s1)
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	f8c080e7          	jalr	-116(ra) # 80001016 <proc_freepagetable>
  p->pagetable = 0;
    80001092:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001096:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000109a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000109e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010a2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010a6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010aa:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010ae:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010b2:	0004ac23          	sw	zero,24(s1)
}
    800010b6:	60e2                	ld	ra,24(sp)
    800010b8:	6442                	ld	s0,16(sp)
    800010ba:	64a2                	ld	s1,8(sp)
    800010bc:	6105                	addi	sp,sp,32
    800010be:	8082                	ret

00000000800010c0 <allocproc>:
{
    800010c0:	1101                	addi	sp,sp,-32
    800010c2:	ec06                	sd	ra,24(sp)
    800010c4:	e822                	sd	s0,16(sp)
    800010c6:	e426                	sd	s1,8(sp)
    800010c8:	e04a                	sd	s2,0(sp)
    800010ca:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010cc:	00008497          	auipc	s1,0x8
    800010d0:	df448493          	addi	s1,s1,-524 # 80008ec0 <proc>
    800010d4:	0000e917          	auipc	s2,0xe
    800010d8:	9ec90913          	addi	s2,s2,-1556 # 8000eac0 <tickslock>
    acquire(&p->lock);
    800010dc:	8526                	mv	a0,s1
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	0e0080e7          	jalr	224(ra) # 800061be <acquire>
    if(p->state == UNUSED) {
    800010e6:	4c9c                	lw	a5,24(s1)
    800010e8:	cf81                	beqz	a5,80001100 <allocproc+0x40>
      release(&p->lock);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00005097          	auipc	ra,0x5
    800010f0:	186080e7          	jalr	390(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010f4:	17048493          	addi	s1,s1,368
    800010f8:	ff2492e3          	bne	s1,s2,800010dc <allocproc+0x1c>
  return 0;
    800010fc:	4481                	li	s1,0
    800010fe:	a889                	j	80001150 <allocproc+0x90>
  p->pid = allocpid();
    80001100:	00000097          	auipc	ra,0x0
    80001104:	e34080e7          	jalr	-460(ra) # 80000f34 <allocpid>
    80001108:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000110a:	4785                	li	a5,1
    8000110c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	070080e7          	jalr	112(ra) # 8000017e <kalloc>
    80001116:	892a                	mv	s2,a0
    80001118:	eca8                	sd	a0,88(s1)
    8000111a:	c131                	beqz	a0,8000115e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	e5c080e7          	jalr	-420(ra) # 80000f7a <proc_pagetable>
    80001126:	892a                	mv	s2,a0
    80001128:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000112a:	c531                	beqz	a0,80001176 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000112c:	07000613          	li	a2,112
    80001130:	4581                	li	a1,0
    80001132:	06048513          	addi	a0,s1,96
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	0a8080e7          	jalr	168(ra) # 800001de <memset>
  p->context.ra = (uint64)forkret;
    8000113e:	00000797          	auipc	a5,0x0
    80001142:	db078793          	addi	a5,a5,-592 # 80000eee <forkret>
    80001146:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001148:	60bc                	ld	a5,64(s1)
    8000114a:	6705                	lui	a4,0x1
    8000114c:	97ba                	add	a5,a5,a4
    8000114e:	f4bc                	sd	a5,104(s1)
}
    80001150:	8526                	mv	a0,s1
    80001152:	60e2                	ld	ra,24(sp)
    80001154:	6442                	ld	s0,16(sp)
    80001156:	64a2                	ld	s1,8(sp)
    80001158:	6902                	ld	s2,0(sp)
    8000115a:	6105                	addi	sp,sp,32
    8000115c:	8082                	ret
    freeproc(p);
    8000115e:	8526                	mv	a0,s1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f08080e7          	jalr	-248(ra) # 80001068 <freeproc>
    release(&p->lock);
    80001168:	8526                	mv	a0,s1
    8000116a:	00005097          	auipc	ra,0x5
    8000116e:	108080e7          	jalr	264(ra) # 80006272 <release>
    return 0;
    80001172:	84ca                	mv	s1,s2
    80001174:	bff1                	j	80001150 <allocproc+0x90>
    freeproc(p);
    80001176:	8526                	mv	a0,s1
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	ef0080e7          	jalr	-272(ra) # 80001068 <freeproc>
    release(&p->lock);
    80001180:	8526                	mv	a0,s1
    80001182:	00005097          	auipc	ra,0x5
    80001186:	0f0080e7          	jalr	240(ra) # 80006272 <release>
    return 0;
    8000118a:	84ca                	mv	s1,s2
    8000118c:	b7d1                	j	80001150 <allocproc+0x90>

000000008000118e <userinit>:
{
    8000118e:	1101                	addi	sp,sp,-32
    80001190:	ec06                	sd	ra,24(sp)
    80001192:	e822                	sd	s0,16(sp)
    80001194:	e426                	sd	s1,8(sp)
    80001196:	1000                	addi	s0,sp,32
  p = allocproc();
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	f28080e7          	jalr	-216(ra) # 800010c0 <allocproc>
    800011a0:	84aa                	mv	s1,a0
  initproc = p;
    800011a2:	00008797          	auipc	a5,0x8
    800011a6:	8aa7b723          	sd	a0,-1874(a5) # 80008a50 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011aa:	03400613          	li	a2,52
    800011ae:	00008597          	auipc	a1,0x8
    800011b2:	83258593          	addi	a1,a1,-1998 # 800089e0 <initcode>
    800011b6:	6928                	ld	a0,80(a0)
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	6a8080e7          	jalr	1704(ra) # 80000860 <uvmfirst>
  p->sz = PGSIZE;
    800011c0:	6785                	lui	a5,0x1
    800011c2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011c4:	6cb8                	ld	a4,88(s1)
    800011c6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ca:	6cb8                	ld	a4,88(s1)
    800011cc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ce:	4641                	li	a2,16
    800011d0:	00007597          	auipc	a1,0x7
    800011d4:	fb058593          	addi	a1,a1,-80 # 80008180 <etext+0x180>
    800011d8:	15848513          	addi	a0,s1,344
    800011dc:	fffff097          	auipc	ra,0xfffff
    800011e0:	14a080e7          	jalr	330(ra) # 80000326 <safestrcpy>
  p->cwd = namei("/");
    800011e4:	00007517          	auipc	a0,0x7
    800011e8:	fac50513          	addi	a0,a0,-84 # 80008190 <etext+0x190>
    800011ec:	00002097          	auipc	ra,0x2
    800011f0:	1ea080e7          	jalr	490(ra) # 800033d6 <namei>
    800011f4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f8:	478d                	li	a5,3
    800011fa:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00005097          	auipc	ra,0x5
    80001202:	074080e7          	jalr	116(ra) # 80006272 <release>
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6105                	addi	sp,sp,32
    8000120e:	8082                	ret

0000000080001210 <growproc>:
{
    80001210:	1101                	addi	sp,sp,-32
    80001212:	ec06                	sd	ra,24(sp)
    80001214:	e822                	sd	s0,16(sp)
    80001216:	e426                	sd	s1,8(sp)
    80001218:	e04a                	sd	s2,0(sp)
    8000121a:	1000                	addi	s0,sp,32
    8000121c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	c98080e7          	jalr	-872(ra) # 80000eb6 <myproc>
    80001226:	84aa                	mv	s1,a0
  sz = p->sz;
    80001228:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000122a:	01204c63          	bgtz	s2,80001242 <growproc+0x32>
  } else if(n < 0){
    8000122e:	02094663          	bltz	s2,8000125a <growproc+0x4a>
  p->sz = sz;
    80001232:	e4ac                	sd	a1,72(s1)
  return 0;
    80001234:	4501                	li	a0,0
}
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001242:	4691                	li	a3,4
    80001244:	00b90633          	add	a2,s2,a1
    80001248:	6928                	ld	a0,80(a0)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	6d0080e7          	jalr	1744(ra) # 8000091a <uvmalloc>
    80001252:	85aa                	mv	a1,a0
    80001254:	fd79                	bnez	a0,80001232 <growproc+0x22>
      return -1;
    80001256:	557d                	li	a0,-1
    80001258:	bff9                	j	80001236 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000125a:	00b90633          	add	a2,s2,a1
    8000125e:	6928                	ld	a0,80(a0)
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	672080e7          	jalr	1650(ra) # 800008d2 <uvmdealloc>
    80001268:	85aa                	mv	a1,a0
    8000126a:	b7e1                	j	80001232 <growproc+0x22>

000000008000126c <fork>:
{
    8000126c:	7139                	addi	sp,sp,-64
    8000126e:	fc06                	sd	ra,56(sp)
    80001270:	f822                	sd	s0,48(sp)
    80001272:	f426                	sd	s1,40(sp)
    80001274:	f04a                	sd	s2,32(sp)
    80001276:	ec4e                	sd	s3,24(sp)
    80001278:	e852                	sd	s4,16(sp)
    8000127a:	e456                	sd	s5,8(sp)
    8000127c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	c38080e7          	jalr	-968(ra) # 80000eb6 <myproc>
    80001286:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	e38080e7          	jalr	-456(ra) # 800010c0 <allocproc>
    80001290:	12050063          	beqz	a0,800013b0 <fork+0x144>
    80001294:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001296:	048ab603          	ld	a2,72(s5)
    8000129a:	692c                	ld	a1,80(a0)
    8000129c:	050ab503          	ld	a0,80(s5)
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	7d2080e7          	jalr	2002(ra) # 80000a72 <uvmcopy>
    800012a8:	04054863          	bltz	a0,800012f8 <fork+0x8c>
  np->sz = p->sz;
    800012ac:	048ab783          	ld	a5,72(s5)
    800012b0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b4:	058ab683          	ld	a3,88(s5)
    800012b8:	87b6                	mv	a5,a3
    800012ba:	0589b703          	ld	a4,88(s3)
    800012be:	12068693          	addi	a3,a3,288
    800012c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c6:	6788                	ld	a0,8(a5)
    800012c8:	6b8c                	ld	a1,16(a5)
    800012ca:	6f90                	ld	a2,24(a5)
    800012cc:	01073023          	sd	a6,0(a4)
    800012d0:	e708                	sd	a0,8(a4)
    800012d2:	eb0c                	sd	a1,16(a4)
    800012d4:	ef10                	sd	a2,24(a4)
    800012d6:	02078793          	addi	a5,a5,32
    800012da:	02070713          	addi	a4,a4,32
    800012de:	fed792e3          	bne	a5,a3,800012c2 <fork+0x56>
  np->trapframe->a0 = 0;
    800012e2:	0589b783          	ld	a5,88(s3)
    800012e6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ea:	0d0a8493          	addi	s1,s5,208
    800012ee:	0d098913          	addi	s2,s3,208
    800012f2:	150a8a13          	addi	s4,s5,336
    800012f6:	a00d                	j	80001318 <fork+0xac>
    freeproc(np);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	d6e080e7          	jalr	-658(ra) # 80001068 <freeproc>
    release(&np->lock);
    80001302:	854e                	mv	a0,s3
    80001304:	00005097          	auipc	ra,0x5
    80001308:	f6e080e7          	jalr	-146(ra) # 80006272 <release>
    return -1;
    8000130c:	597d                	li	s2,-1
    8000130e:	a079                	j	8000139c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001310:	04a1                	addi	s1,s1,8
    80001312:	0921                	addi	s2,s2,8
    80001314:	01448b63          	beq	s1,s4,8000132a <fork+0xbe>
    if(p->ofile[i])
    80001318:	6088                	ld	a0,0(s1)
    8000131a:	d97d                	beqz	a0,80001310 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131c:	00002097          	auipc	ra,0x2
    80001320:	72c080e7          	jalr	1836(ra) # 80003a48 <filedup>
    80001324:	00a93023          	sd	a0,0(s2)
    80001328:	b7e5                	j	80001310 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000132a:	150ab503          	ld	a0,336(s5)
    8000132e:	00002097          	auipc	ra,0x2
    80001332:	8c4080e7          	jalr	-1852(ra) # 80002bf2 <idup>
    80001336:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133a:	4641                	li	a2,16
    8000133c:	158a8593          	addi	a1,s5,344
    80001340:	15898513          	addi	a0,s3,344
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	fe2080e7          	jalr	-30(ra) # 80000326 <safestrcpy>
  np->trace_mask = p->trace_mask;
    8000134c:	168aa783          	lw	a5,360(s5)
    80001350:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001354:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001358:	854e                	mv	a0,s3
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	f18080e7          	jalr	-232(ra) # 80006272 <release>
  acquire(&wait_lock);
    80001362:	00007497          	auipc	s1,0x7
    80001366:	74648493          	addi	s1,s1,1862 # 80008aa8 <wait_lock>
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	e52080e7          	jalr	-430(ra) # 800061be <acquire>
  np->parent = p;
    80001374:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001378:	8526                	mv	a0,s1
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	ef8080e7          	jalr	-264(ra) # 80006272 <release>
  acquire(&np->lock);
    80001382:	854e                	mv	a0,s3
    80001384:	00005097          	auipc	ra,0x5
    80001388:	e3a080e7          	jalr	-454(ra) # 800061be <acquire>
  np->state = RUNNABLE;
    8000138c:	478d                	li	a5,3
    8000138e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001392:	854e                	mv	a0,s3
    80001394:	00005097          	auipc	ra,0x5
    80001398:	ede080e7          	jalr	-290(ra) # 80006272 <release>
}
    8000139c:	854a                	mv	a0,s2
    8000139e:	70e2                	ld	ra,56(sp)
    800013a0:	7442                	ld	s0,48(sp)
    800013a2:	74a2                	ld	s1,40(sp)
    800013a4:	7902                	ld	s2,32(sp)
    800013a6:	69e2                	ld	s3,24(sp)
    800013a8:	6a42                	ld	s4,16(sp)
    800013aa:	6aa2                	ld	s5,8(sp)
    800013ac:	6121                	addi	sp,sp,64
    800013ae:	8082                	ret
    return -1;
    800013b0:	597d                	li	s2,-1
    800013b2:	b7ed                	j	8000139c <fork+0x130>

00000000800013b4 <proc_num>:
void proc_num(uint64 *nproc){ /*fetch proc num*/
    800013b4:	1141                	addi	sp,sp,-16
    800013b6:	e422                	sd	s0,8(sp)
    800013b8:	0800                	addi	s0,sp,16
  *nproc = 0;
    800013ba:	00053023          	sd	zero,0(a0)
  for(p = proc; p < &proc[NPROC]; p++){
    800013be:	00008797          	auipc	a5,0x8
    800013c2:	b0278793          	addi	a5,a5,-1278 # 80008ec0 <proc>
    800013c6:	0000d697          	auipc	a3,0xd
    800013ca:	6fa68693          	addi	a3,a3,1786 # 8000eac0 <tickslock>
    800013ce:	a029                	j	800013d8 <proc_num+0x24>
    800013d0:	17078793          	addi	a5,a5,368
    800013d4:	00d78863          	beq	a5,a3,800013e4 <proc_num+0x30>
    if(p->state != UNUSED){
    800013d8:	4f98                	lw	a4,24(a5)
    800013da:	db7d                	beqz	a4,800013d0 <proc_num+0x1c>
      (*nproc)++;
    800013dc:	6118                	ld	a4,0(a0)
    800013de:	0705                	addi	a4,a4,1
    800013e0:	e118                	sd	a4,0(a0)
    800013e2:	b7fd                	j	800013d0 <proc_num+0x1c>
}
    800013e4:	6422                	ld	s0,8(sp)
    800013e6:	0141                	addi	sp,sp,16
    800013e8:	8082                	ret

00000000800013ea <scheduler>:
{
    800013ea:	7139                	addi	sp,sp,-64
    800013ec:	fc06                	sd	ra,56(sp)
    800013ee:	f822                	sd	s0,48(sp)
    800013f0:	f426                	sd	s1,40(sp)
    800013f2:	f04a                	sd	s2,32(sp)
    800013f4:	ec4e                	sd	s3,24(sp)
    800013f6:	e852                	sd	s4,16(sp)
    800013f8:	e456                	sd	s5,8(sp)
    800013fa:	e05a                	sd	s6,0(sp)
    800013fc:	0080                	addi	s0,sp,64
    800013fe:	8792                	mv	a5,tp
  int id = r_tp();
    80001400:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001402:	00779a93          	slli	s5,a5,0x7
    80001406:	00007717          	auipc	a4,0x7
    8000140a:	68a70713          	addi	a4,a4,1674 # 80008a90 <pid_lock>
    8000140e:	9756                	add	a4,a4,s5
    80001410:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001414:	00007717          	auipc	a4,0x7
    80001418:	6b470713          	addi	a4,a4,1716 # 80008ac8 <cpus+0x8>
    8000141c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000141e:	498d                	li	s3,3
        p->state = RUNNING;
    80001420:	4b11                	li	s6,4
        c->proc = p;
    80001422:	079e                	slli	a5,a5,0x7
    80001424:	00007a17          	auipc	s4,0x7
    80001428:	66ca0a13          	addi	s4,s4,1644 # 80008a90 <pid_lock>
    8000142c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142e:	0000d917          	auipc	s2,0xd
    80001432:	69290913          	addi	s2,s2,1682 # 8000eac0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000143a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143e:	10079073          	csrw	sstatus,a5
    80001442:	00008497          	auipc	s1,0x8
    80001446:	a7e48493          	addi	s1,s1,-1410 # 80008ec0 <proc>
    8000144a:	a811                	j	8000145e <scheduler+0x74>
      release(&p->lock);
    8000144c:	8526                	mv	a0,s1
    8000144e:	00005097          	auipc	ra,0x5
    80001452:	e24080e7          	jalr	-476(ra) # 80006272 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001456:	17048493          	addi	s1,s1,368
    8000145a:	fd248ee3          	beq	s1,s2,80001436 <scheduler+0x4c>
      acquire(&p->lock);
    8000145e:	8526                	mv	a0,s1
    80001460:	00005097          	auipc	ra,0x5
    80001464:	d5e080e7          	jalr	-674(ra) # 800061be <acquire>
      if(p->state == RUNNABLE) {
    80001468:	4c9c                	lw	a5,24(s1)
    8000146a:	ff3791e3          	bne	a5,s3,8000144c <scheduler+0x62>
        p->state = RUNNING;
    8000146e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001472:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001476:	06048593          	addi	a1,s1,96
    8000147a:	8556                	mv	a0,s5
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	684080e7          	jalr	1668(ra) # 80001b00 <swtch>
        c->proc = 0;
    80001484:	020a3823          	sd	zero,48(s4)
    80001488:	b7d1                	j	8000144c <scheduler+0x62>

000000008000148a <sched>:
{
    8000148a:	7179                	addi	sp,sp,-48
    8000148c:	f406                	sd	ra,40(sp)
    8000148e:	f022                	sd	s0,32(sp)
    80001490:	ec26                	sd	s1,24(sp)
    80001492:	e84a                	sd	s2,16(sp)
    80001494:	e44e                	sd	s3,8(sp)
    80001496:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	a1e080e7          	jalr	-1506(ra) # 80000eb6 <myproc>
    800014a0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	ca2080e7          	jalr	-862(ra) # 80006144 <holding>
    800014aa:	c93d                	beqz	a0,80001520 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ac:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	00007717          	auipc	a4,0x7
    800014b6:	5de70713          	addi	a4,a4,1502 # 80008a90 <pid_lock>
    800014ba:	97ba                	add	a5,a5,a4
    800014bc:	0a87a703          	lw	a4,168(a5)
    800014c0:	4785                	li	a5,1
    800014c2:	06f71763          	bne	a4,a5,80001530 <sched+0xa6>
  if(p->state == RUNNING)
    800014c6:	4c98                	lw	a4,24(s1)
    800014c8:	4791                	li	a5,4
    800014ca:	06f70b63          	beq	a4,a5,80001540 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014d4:	efb5                	bnez	a5,80001550 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d8:	00007917          	auipc	s2,0x7
    800014dc:	5b890913          	addi	s2,s2,1464 # 80008a90 <pid_lock>
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	97ca                	add	a5,a5,s2
    800014e6:	0ac7a983          	lw	s3,172(a5)
    800014ea:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ec:	2781                	sext.w	a5,a5
    800014ee:	079e                	slli	a5,a5,0x7
    800014f0:	00007597          	auipc	a1,0x7
    800014f4:	5d858593          	addi	a1,a1,1496 # 80008ac8 <cpus+0x8>
    800014f8:	95be                	add	a1,a1,a5
    800014fa:	06048513          	addi	a0,s1,96
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	602080e7          	jalr	1538(ra) # 80001b00 <swtch>
    80001506:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001508:	2781                	sext.w	a5,a5
    8000150a:	079e                	slli	a5,a5,0x7
    8000150c:	993e                	add	s2,s2,a5
    8000150e:	0b392623          	sw	s3,172(s2)
}
    80001512:	70a2                	ld	ra,40(sp)
    80001514:	7402                	ld	s0,32(sp)
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	6145                	addi	sp,sp,48
    8000151e:	8082                	ret
    panic("sched p->lock");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	c7850513          	addi	a0,a0,-904 # 80008198 <etext+0x198>
    80001528:	00004097          	auipc	ra,0x4
    8000152c:	75e080e7          	jalr	1886(ra) # 80005c86 <panic>
    panic("sched locks");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	c7850513          	addi	a0,a0,-904 # 800081a8 <etext+0x1a8>
    80001538:	00004097          	auipc	ra,0x4
    8000153c:	74e080e7          	jalr	1870(ra) # 80005c86 <panic>
    panic("sched running");
    80001540:	00007517          	auipc	a0,0x7
    80001544:	c7850513          	addi	a0,a0,-904 # 800081b8 <etext+0x1b8>
    80001548:	00004097          	auipc	ra,0x4
    8000154c:	73e080e7          	jalr	1854(ra) # 80005c86 <panic>
    panic("sched interruptible");
    80001550:	00007517          	auipc	a0,0x7
    80001554:	c7850513          	addi	a0,a0,-904 # 800081c8 <etext+0x1c8>
    80001558:	00004097          	auipc	ra,0x4
    8000155c:	72e080e7          	jalr	1838(ra) # 80005c86 <panic>

0000000080001560 <yield>:
{
    80001560:	1101                	addi	sp,sp,-32
    80001562:	ec06                	sd	ra,24(sp)
    80001564:	e822                	sd	s0,16(sp)
    80001566:	e426                	sd	s1,8(sp)
    80001568:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	94c080e7          	jalr	-1716(ra) # 80000eb6 <myproc>
    80001572:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001574:	00005097          	auipc	ra,0x5
    80001578:	c4a080e7          	jalr	-950(ra) # 800061be <acquire>
  p->state = RUNNABLE;
    8000157c:	478d                	li	a5,3
    8000157e:	cc9c                	sw	a5,24(s1)
  sched();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f0a080e7          	jalr	-246(ra) # 8000148a <sched>
  release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	ce8080e7          	jalr	-792(ra) # 80006272 <release>
}
    80001592:	60e2                	ld	ra,24(sp)
    80001594:	6442                	ld	s0,16(sp)
    80001596:	64a2                	ld	s1,8(sp)
    80001598:	6105                	addi	sp,sp,32
    8000159a:	8082                	ret

000000008000159c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000159c:	7179                	addi	sp,sp,-48
    8000159e:	f406                	sd	ra,40(sp)
    800015a0:	f022                	sd	s0,32(sp)
    800015a2:	ec26                	sd	s1,24(sp)
    800015a4:	e84a                	sd	s2,16(sp)
    800015a6:	e44e                	sd	s3,8(sp)
    800015a8:	1800                	addi	s0,sp,48
    800015aa:	89aa                	mv	s3,a0
    800015ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	908080e7          	jalr	-1784(ra) # 80000eb6 <myproc>
    800015b6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	c06080e7          	jalr	-1018(ra) # 800061be <acquire>
  release(lk);
    800015c0:	854a                	mv	a0,s2
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	cb0080e7          	jalr	-848(ra) # 80006272 <release>

  // Go to sleep.
  p->chan = chan;
    800015ca:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ce:	4789                	li	a5,2
    800015d0:	cc9c                	sw	a5,24(s1)

  sched();
    800015d2:	00000097          	auipc	ra,0x0
    800015d6:	eb8080e7          	jalr	-328(ra) # 8000148a <sched>

  // Tidy up.
  p->chan = 0;
    800015da:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	c92080e7          	jalr	-878(ra) # 80006272 <release>
  acquire(lk);
    800015e8:	854a                	mv	a0,s2
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	bd4080e7          	jalr	-1068(ra) # 800061be <acquire>
}
    800015f2:	70a2                	ld	ra,40(sp)
    800015f4:	7402                	ld	s0,32(sp)
    800015f6:	64e2                	ld	s1,24(sp)
    800015f8:	6942                	ld	s2,16(sp)
    800015fa:	69a2                	ld	s3,8(sp)
    800015fc:	6145                	addi	sp,sp,48
    800015fe:	8082                	ret

0000000080001600 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001600:	7139                	addi	sp,sp,-64
    80001602:	fc06                	sd	ra,56(sp)
    80001604:	f822                	sd	s0,48(sp)
    80001606:	f426                	sd	s1,40(sp)
    80001608:	f04a                	sd	s2,32(sp)
    8000160a:	ec4e                	sd	s3,24(sp)
    8000160c:	e852                	sd	s4,16(sp)
    8000160e:	e456                	sd	s5,8(sp)
    80001610:	0080                	addi	s0,sp,64
    80001612:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001614:	00008497          	auipc	s1,0x8
    80001618:	8ac48493          	addi	s1,s1,-1876 # 80008ec0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000161c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000161e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001620:	0000d917          	auipc	s2,0xd
    80001624:	4a090913          	addi	s2,s2,1184 # 8000eac0 <tickslock>
    80001628:	a811                	j	8000163c <wakeup+0x3c>
      }
      release(&p->lock);
    8000162a:	8526                	mv	a0,s1
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	c46080e7          	jalr	-954(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001634:	17048493          	addi	s1,s1,368
    80001638:	03248663          	beq	s1,s2,80001664 <wakeup+0x64>
    if(p != myproc()){
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	87a080e7          	jalr	-1926(ra) # 80000eb6 <myproc>
    80001644:	fea488e3          	beq	s1,a0,80001634 <wakeup+0x34>
      acquire(&p->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	b74080e7          	jalr	-1164(ra) # 800061be <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001652:	4c9c                	lw	a5,24(s1)
    80001654:	fd379be3          	bne	a5,s3,8000162a <wakeup+0x2a>
    80001658:	709c                	ld	a5,32(s1)
    8000165a:	fd4798e3          	bne	a5,s4,8000162a <wakeup+0x2a>
        p->state = RUNNABLE;
    8000165e:	0154ac23          	sw	s5,24(s1)
    80001662:	b7e1                	j	8000162a <wakeup+0x2a>
    }
  }
}
    80001664:	70e2                	ld	ra,56(sp)
    80001666:	7442                	ld	s0,48(sp)
    80001668:	74a2                	ld	s1,40(sp)
    8000166a:	7902                	ld	s2,32(sp)
    8000166c:	69e2                	ld	s3,24(sp)
    8000166e:	6a42                	ld	s4,16(sp)
    80001670:	6aa2                	ld	s5,8(sp)
    80001672:	6121                	addi	sp,sp,64
    80001674:	8082                	ret

0000000080001676 <reparent>:
{
    80001676:	7179                	addi	sp,sp,-48
    80001678:	f406                	sd	ra,40(sp)
    8000167a:	f022                	sd	s0,32(sp)
    8000167c:	ec26                	sd	s1,24(sp)
    8000167e:	e84a                	sd	s2,16(sp)
    80001680:	e44e                	sd	s3,8(sp)
    80001682:	e052                	sd	s4,0(sp)
    80001684:	1800                	addi	s0,sp,48
    80001686:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001688:	00008497          	auipc	s1,0x8
    8000168c:	83848493          	addi	s1,s1,-1992 # 80008ec0 <proc>
      pp->parent = initproc;
    80001690:	00007a17          	auipc	s4,0x7
    80001694:	3c0a0a13          	addi	s4,s4,960 # 80008a50 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001698:	0000d997          	auipc	s3,0xd
    8000169c:	42898993          	addi	s3,s3,1064 # 8000eac0 <tickslock>
    800016a0:	a029                	j	800016aa <reparent+0x34>
    800016a2:	17048493          	addi	s1,s1,368
    800016a6:	01348d63          	beq	s1,s3,800016c0 <reparent+0x4a>
    if(pp->parent == p){
    800016aa:	7c9c                	ld	a5,56(s1)
    800016ac:	ff279be3          	bne	a5,s2,800016a2 <reparent+0x2c>
      pp->parent = initproc;
    800016b0:	000a3503          	ld	a0,0(s4)
    800016b4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016b6:	00000097          	auipc	ra,0x0
    800016ba:	f4a080e7          	jalr	-182(ra) # 80001600 <wakeup>
    800016be:	b7d5                	j	800016a2 <reparent+0x2c>
}
    800016c0:	70a2                	ld	ra,40(sp)
    800016c2:	7402                	ld	s0,32(sp)
    800016c4:	64e2                	ld	s1,24(sp)
    800016c6:	6942                	ld	s2,16(sp)
    800016c8:	69a2                	ld	s3,8(sp)
    800016ca:	6a02                	ld	s4,0(sp)
    800016cc:	6145                	addi	sp,sp,48
    800016ce:	8082                	ret

00000000800016d0 <exit>:
{
    800016d0:	7179                	addi	sp,sp,-48
    800016d2:	f406                	sd	ra,40(sp)
    800016d4:	f022                	sd	s0,32(sp)
    800016d6:	ec26                	sd	s1,24(sp)
    800016d8:	e84a                	sd	s2,16(sp)
    800016da:	e44e                	sd	s3,8(sp)
    800016dc:	e052                	sd	s4,0(sp)
    800016de:	1800                	addi	s0,sp,48
    800016e0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016e2:	fffff097          	auipc	ra,0xfffff
    800016e6:	7d4080e7          	jalr	2004(ra) # 80000eb6 <myproc>
    800016ea:	89aa                	mv	s3,a0
  if(p == initproc)
    800016ec:	00007797          	auipc	a5,0x7
    800016f0:	3647b783          	ld	a5,868(a5) # 80008a50 <initproc>
    800016f4:	0d050493          	addi	s1,a0,208
    800016f8:	15050913          	addi	s2,a0,336
    800016fc:	02a79363          	bne	a5,a0,80001722 <exit+0x52>
    panic("init exiting");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ae050513          	addi	a0,a0,-1312 # 800081e0 <etext+0x1e0>
    80001708:	00004097          	auipc	ra,0x4
    8000170c:	57e080e7          	jalr	1406(ra) # 80005c86 <panic>
      fileclose(f);
    80001710:	00002097          	auipc	ra,0x2
    80001714:	38a080e7          	jalr	906(ra) # 80003a9a <fileclose>
      p->ofile[fd] = 0;
    80001718:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000171c:	04a1                	addi	s1,s1,8
    8000171e:	01248563          	beq	s1,s2,80001728 <exit+0x58>
    if(p->ofile[fd]){
    80001722:	6088                	ld	a0,0(s1)
    80001724:	f575                	bnez	a0,80001710 <exit+0x40>
    80001726:	bfdd                	j	8000171c <exit+0x4c>
  begin_op();
    80001728:	00002097          	auipc	ra,0x2
    8000172c:	eae080e7          	jalr	-338(ra) # 800035d6 <begin_op>
  iput(p->cwd);
    80001730:	1509b503          	ld	a0,336(s3)
    80001734:	00001097          	auipc	ra,0x1
    80001738:	6b6080e7          	jalr	1718(ra) # 80002dea <iput>
  end_op();
    8000173c:	00002097          	auipc	ra,0x2
    80001740:	f14080e7          	jalr	-236(ra) # 80003650 <end_op>
  p->cwd = 0;
    80001744:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001748:	00007497          	auipc	s1,0x7
    8000174c:	36048493          	addi	s1,s1,864 # 80008aa8 <wait_lock>
    80001750:	8526                	mv	a0,s1
    80001752:	00005097          	auipc	ra,0x5
    80001756:	a6c080e7          	jalr	-1428(ra) # 800061be <acquire>
  reparent(p);
    8000175a:	854e                	mv	a0,s3
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	f1a080e7          	jalr	-230(ra) # 80001676 <reparent>
  wakeup(p->parent);
    80001764:	0389b503          	ld	a0,56(s3)
    80001768:	00000097          	auipc	ra,0x0
    8000176c:	e98080e7          	jalr	-360(ra) # 80001600 <wakeup>
  acquire(&p->lock);
    80001770:	854e                	mv	a0,s3
    80001772:	00005097          	auipc	ra,0x5
    80001776:	a4c080e7          	jalr	-1460(ra) # 800061be <acquire>
  p->xstate = status;
    8000177a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000177e:	4795                	li	a5,5
    80001780:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001784:	8526                	mv	a0,s1
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	aec080e7          	jalr	-1300(ra) # 80006272 <release>
  sched();
    8000178e:	00000097          	auipc	ra,0x0
    80001792:	cfc080e7          	jalr	-772(ra) # 8000148a <sched>
  panic("zombie exit");
    80001796:	00007517          	auipc	a0,0x7
    8000179a:	a5a50513          	addi	a0,a0,-1446 # 800081f0 <etext+0x1f0>
    8000179e:	00004097          	auipc	ra,0x4
    800017a2:	4e8080e7          	jalr	1256(ra) # 80005c86 <panic>

00000000800017a6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017a6:	7179                	addi	sp,sp,-48
    800017a8:	f406                	sd	ra,40(sp)
    800017aa:	f022                	sd	s0,32(sp)
    800017ac:	ec26                	sd	s1,24(sp)
    800017ae:	e84a                	sd	s2,16(sp)
    800017b0:	e44e                	sd	s3,8(sp)
    800017b2:	1800                	addi	s0,sp,48
    800017b4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017b6:	00007497          	auipc	s1,0x7
    800017ba:	70a48493          	addi	s1,s1,1802 # 80008ec0 <proc>
    800017be:	0000d997          	auipc	s3,0xd
    800017c2:	30298993          	addi	s3,s3,770 # 8000eac0 <tickslock>
    acquire(&p->lock);
    800017c6:	8526                	mv	a0,s1
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	9f6080e7          	jalr	-1546(ra) # 800061be <acquire>
    if(p->pid == pid){
    800017d0:	589c                	lw	a5,48(s1)
    800017d2:	01278d63          	beq	a5,s2,800017ec <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017d6:	8526                	mv	a0,s1
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	a9a080e7          	jalr	-1382(ra) # 80006272 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017e0:	17048493          	addi	s1,s1,368
    800017e4:	ff3491e3          	bne	s1,s3,800017c6 <kill+0x20>
  }
  return -1;
    800017e8:	557d                	li	a0,-1
    800017ea:	a829                	j	80001804 <kill+0x5e>
      p->killed = 1;
    800017ec:	4785                	li	a5,1
    800017ee:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800017f0:	4c98                	lw	a4,24(s1)
    800017f2:	4789                	li	a5,2
    800017f4:	00f70f63          	beq	a4,a5,80001812 <kill+0x6c>
      release(&p->lock);
    800017f8:	8526                	mv	a0,s1
    800017fa:	00005097          	auipc	ra,0x5
    800017fe:	a78080e7          	jalr	-1416(ra) # 80006272 <release>
      return 0;
    80001802:	4501                	li	a0,0
}
    80001804:	70a2                	ld	ra,40(sp)
    80001806:	7402                	ld	s0,32(sp)
    80001808:	64e2                	ld	s1,24(sp)
    8000180a:	6942                	ld	s2,16(sp)
    8000180c:	69a2                	ld	s3,8(sp)
    8000180e:	6145                	addi	sp,sp,48
    80001810:	8082                	ret
        p->state = RUNNABLE;
    80001812:	478d                	li	a5,3
    80001814:	cc9c                	sw	a5,24(s1)
    80001816:	b7cd                	j	800017f8 <kill+0x52>

0000000080001818 <setkilled>:

void
setkilled(struct proc *p)
{
    80001818:	1101                	addi	sp,sp,-32
    8000181a:	ec06                	sd	ra,24(sp)
    8000181c:	e822                	sd	s0,16(sp)
    8000181e:	e426                	sd	s1,8(sp)
    80001820:	1000                	addi	s0,sp,32
    80001822:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001824:	00005097          	auipc	ra,0x5
    80001828:	99a080e7          	jalr	-1638(ra) # 800061be <acquire>
  p->killed = 1;
    8000182c:	4785                	li	a5,1
    8000182e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001830:	8526                	mv	a0,s1
    80001832:	00005097          	auipc	ra,0x5
    80001836:	a40080e7          	jalr	-1472(ra) # 80006272 <release>
}
    8000183a:	60e2                	ld	ra,24(sp)
    8000183c:	6442                	ld	s0,16(sp)
    8000183e:	64a2                	ld	s1,8(sp)
    80001840:	6105                	addi	sp,sp,32
    80001842:	8082                	ret

0000000080001844 <killed>:

int
killed(struct proc *p)
{
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	e04a                	sd	s2,0(sp)
    8000184e:	1000                	addi	s0,sp,32
    80001850:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001852:	00005097          	auipc	ra,0x5
    80001856:	96c080e7          	jalr	-1684(ra) # 800061be <acquire>
  k = p->killed;
    8000185a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000185e:	8526                	mv	a0,s1
    80001860:	00005097          	auipc	ra,0x5
    80001864:	a12080e7          	jalr	-1518(ra) # 80006272 <release>
  return k;
}
    80001868:	854a                	mv	a0,s2
    8000186a:	60e2                	ld	ra,24(sp)
    8000186c:	6442                	ld	s0,16(sp)
    8000186e:	64a2                	ld	s1,8(sp)
    80001870:	6902                	ld	s2,0(sp)
    80001872:	6105                	addi	sp,sp,32
    80001874:	8082                	ret

0000000080001876 <wait>:
{
    80001876:	715d                	addi	sp,sp,-80
    80001878:	e486                	sd	ra,72(sp)
    8000187a:	e0a2                	sd	s0,64(sp)
    8000187c:	fc26                	sd	s1,56(sp)
    8000187e:	f84a                	sd	s2,48(sp)
    80001880:	f44e                	sd	s3,40(sp)
    80001882:	f052                	sd	s4,32(sp)
    80001884:	ec56                	sd	s5,24(sp)
    80001886:	e85a                	sd	s6,16(sp)
    80001888:	e45e                	sd	s7,8(sp)
    8000188a:	e062                	sd	s8,0(sp)
    8000188c:	0880                	addi	s0,sp,80
    8000188e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001890:	fffff097          	auipc	ra,0xfffff
    80001894:	626080e7          	jalr	1574(ra) # 80000eb6 <myproc>
    80001898:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000189a:	00007517          	auipc	a0,0x7
    8000189e:	20e50513          	addi	a0,a0,526 # 80008aa8 <wait_lock>
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	91c080e7          	jalr	-1764(ra) # 800061be <acquire>
    havekids = 0;
    800018aa:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018ac:	4a15                	li	s4,5
        havekids = 1;
    800018ae:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b0:	0000d997          	auipc	s3,0xd
    800018b4:	21098993          	addi	s3,s3,528 # 8000eac0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018b8:	00007c17          	auipc	s8,0x7
    800018bc:	1f0c0c13          	addi	s8,s8,496 # 80008aa8 <wait_lock>
    800018c0:	a0d1                	j	80001984 <wait+0x10e>
          pid = pp->pid;
    800018c2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018c6:	000b0e63          	beqz	s6,800018e2 <wait+0x6c>
    800018ca:	4691                	li	a3,4
    800018cc:	02c48613          	addi	a2,s1,44
    800018d0:	85da                	mv	a1,s6
    800018d2:	05093503          	ld	a0,80(s2)
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	2a0080e7          	jalr	672(ra) # 80000b76 <copyout>
    800018de:	04054163          	bltz	a0,80001920 <wait+0xaa>
          freeproc(pp);
    800018e2:	8526                	mv	a0,s1
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	784080e7          	jalr	1924(ra) # 80001068 <freeproc>
          release(&pp->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	984080e7          	jalr	-1660(ra) # 80006272 <release>
          release(&wait_lock);
    800018f6:	00007517          	auipc	a0,0x7
    800018fa:	1b250513          	addi	a0,a0,434 # 80008aa8 <wait_lock>
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	974080e7          	jalr	-1676(ra) # 80006272 <release>
}
    80001906:	854e                	mv	a0,s3
    80001908:	60a6                	ld	ra,72(sp)
    8000190a:	6406                	ld	s0,64(sp)
    8000190c:	74e2                	ld	s1,56(sp)
    8000190e:	7942                	ld	s2,48(sp)
    80001910:	79a2                	ld	s3,40(sp)
    80001912:	7a02                	ld	s4,32(sp)
    80001914:	6ae2                	ld	s5,24(sp)
    80001916:	6b42                	ld	s6,16(sp)
    80001918:	6ba2                	ld	s7,8(sp)
    8000191a:	6c02                	ld	s8,0(sp)
    8000191c:	6161                	addi	sp,sp,80
    8000191e:	8082                	ret
            release(&pp->lock);
    80001920:	8526                	mv	a0,s1
    80001922:	00005097          	auipc	ra,0x5
    80001926:	950080e7          	jalr	-1712(ra) # 80006272 <release>
            release(&wait_lock);
    8000192a:	00007517          	auipc	a0,0x7
    8000192e:	17e50513          	addi	a0,a0,382 # 80008aa8 <wait_lock>
    80001932:	00005097          	auipc	ra,0x5
    80001936:	940080e7          	jalr	-1728(ra) # 80006272 <release>
            return -1;
    8000193a:	59fd                	li	s3,-1
    8000193c:	b7e9                	j	80001906 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193e:	17048493          	addi	s1,s1,368
    80001942:	03348463          	beq	s1,s3,8000196a <wait+0xf4>
      if(pp->parent == p){
    80001946:	7c9c                	ld	a5,56(s1)
    80001948:	ff279be3          	bne	a5,s2,8000193e <wait+0xc8>
        acquire(&pp->lock);
    8000194c:	8526                	mv	a0,s1
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	870080e7          	jalr	-1936(ra) # 800061be <acquire>
        if(pp->state == ZOMBIE){
    80001956:	4c9c                	lw	a5,24(s1)
    80001958:	f74785e3          	beq	a5,s4,800018c2 <wait+0x4c>
        release(&pp->lock);
    8000195c:	8526                	mv	a0,s1
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	914080e7          	jalr	-1772(ra) # 80006272 <release>
        havekids = 1;
    80001966:	8756                	mv	a4,s5
    80001968:	bfd9                	j	8000193e <wait+0xc8>
    if(!havekids || killed(p)){
    8000196a:	c31d                	beqz	a4,80001990 <wait+0x11a>
    8000196c:	854a                	mv	a0,s2
    8000196e:	00000097          	auipc	ra,0x0
    80001972:	ed6080e7          	jalr	-298(ra) # 80001844 <killed>
    80001976:	ed09                	bnez	a0,80001990 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001978:	85e2                	mv	a1,s8
    8000197a:	854a                	mv	a0,s2
    8000197c:	00000097          	auipc	ra,0x0
    80001980:	c20080e7          	jalr	-992(ra) # 8000159c <sleep>
    havekids = 0;
    80001984:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001986:	00007497          	auipc	s1,0x7
    8000198a:	53a48493          	addi	s1,s1,1338 # 80008ec0 <proc>
    8000198e:	bf65                	j	80001946 <wait+0xd0>
      release(&wait_lock);
    80001990:	00007517          	auipc	a0,0x7
    80001994:	11850513          	addi	a0,a0,280 # 80008aa8 <wait_lock>
    80001998:	00005097          	auipc	ra,0x5
    8000199c:	8da080e7          	jalr	-1830(ra) # 80006272 <release>
      return -1;
    800019a0:	59fd                	li	s3,-1
    800019a2:	b795                	j	80001906 <wait+0x90>

00000000800019a4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019a4:	7179                	addi	sp,sp,-48
    800019a6:	f406                	sd	ra,40(sp)
    800019a8:	f022                	sd	s0,32(sp)
    800019aa:	ec26                	sd	s1,24(sp)
    800019ac:	e84a                	sd	s2,16(sp)
    800019ae:	e44e                	sd	s3,8(sp)
    800019b0:	e052                	sd	s4,0(sp)
    800019b2:	1800                	addi	s0,sp,48
    800019b4:	84aa                	mv	s1,a0
    800019b6:	892e                	mv	s2,a1
    800019b8:	89b2                	mv	s3,a2
    800019ba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	4fa080e7          	jalr	1274(ra) # 80000eb6 <myproc>
  if(user_dst){
    800019c4:	c08d                	beqz	s1,800019e6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019c6:	86d2                	mv	a3,s4
    800019c8:	864e                	mv	a2,s3
    800019ca:	85ca                	mv	a1,s2
    800019cc:	6928                	ld	a0,80(a0)
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	1a8080e7          	jalr	424(ra) # 80000b76 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019d6:	70a2                	ld	ra,40(sp)
    800019d8:	7402                	ld	s0,32(sp)
    800019da:	64e2                	ld	s1,24(sp)
    800019dc:	6942                	ld	s2,16(sp)
    800019de:	69a2                	ld	s3,8(sp)
    800019e0:	6a02                	ld	s4,0(sp)
    800019e2:	6145                	addi	sp,sp,48
    800019e4:	8082                	ret
    memmove((char *)dst, src, len);
    800019e6:	000a061b          	sext.w	a2,s4
    800019ea:	85ce                	mv	a1,s3
    800019ec:	854a                	mv	a0,s2
    800019ee:	fffff097          	auipc	ra,0xfffff
    800019f2:	84c080e7          	jalr	-1972(ra) # 8000023a <memmove>
    return 0;
    800019f6:	8526                	mv	a0,s1
    800019f8:	bff9                	j	800019d6 <either_copyout+0x32>

00000000800019fa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019fa:	7179                	addi	sp,sp,-48
    800019fc:	f406                	sd	ra,40(sp)
    800019fe:	f022                	sd	s0,32(sp)
    80001a00:	ec26                	sd	s1,24(sp)
    80001a02:	e84a                	sd	s2,16(sp)
    80001a04:	e44e                	sd	s3,8(sp)
    80001a06:	e052                	sd	s4,0(sp)
    80001a08:	1800                	addi	s0,sp,48
    80001a0a:	892a                	mv	s2,a0
    80001a0c:	84ae                	mv	s1,a1
    80001a0e:	89b2                	mv	s3,a2
    80001a10:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	4a4080e7          	jalr	1188(ra) # 80000eb6 <myproc>
  if(user_src){
    80001a1a:	c08d                	beqz	s1,80001a3c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a1c:	86d2                	mv	a3,s4
    80001a1e:	864e                	mv	a2,s3
    80001a20:	85ca                	mv	a1,s2
    80001a22:	6928                	ld	a0,80(a0)
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	1de080e7          	jalr	478(ra) # 80000c02 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a2c:	70a2                	ld	ra,40(sp)
    80001a2e:	7402                	ld	s0,32(sp)
    80001a30:	64e2                	ld	s1,24(sp)
    80001a32:	6942                	ld	s2,16(sp)
    80001a34:	69a2                	ld	s3,8(sp)
    80001a36:	6a02                	ld	s4,0(sp)
    80001a38:	6145                	addi	sp,sp,48
    80001a3a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a3c:	000a061b          	sext.w	a2,s4
    80001a40:	85ce                	mv	a1,s3
    80001a42:	854a                	mv	a0,s2
    80001a44:	ffffe097          	auipc	ra,0xffffe
    80001a48:	7f6080e7          	jalr	2038(ra) # 8000023a <memmove>
    return 0;
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	bff9                	j	80001a2c <either_copyin+0x32>

0000000080001a50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a50:	715d                	addi	sp,sp,-80
    80001a52:	e486                	sd	ra,72(sp)
    80001a54:	e0a2                	sd	s0,64(sp)
    80001a56:	fc26                	sd	s1,56(sp)
    80001a58:	f84a                	sd	s2,48(sp)
    80001a5a:	f44e                	sd	s3,40(sp)
    80001a5c:	f052                	sd	s4,32(sp)
    80001a5e:	ec56                	sd	s5,24(sp)
    80001a60:	e85a                	sd	s6,16(sp)
    80001a62:	e45e                	sd	s7,8(sp)
    80001a64:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a66:	00006517          	auipc	a0,0x6
    80001a6a:	5e250513          	addi	a0,a0,1506 # 80008048 <etext+0x48>
    80001a6e:	00004097          	auipc	ra,0x4
    80001a72:	262080e7          	jalr	610(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a76:	00007497          	auipc	s1,0x7
    80001a7a:	5a248493          	addi	s1,s1,1442 # 80009018 <proc+0x158>
    80001a7e:	0000d917          	auipc	s2,0xd
    80001a82:	19a90913          	addi	s2,s2,410 # 8000ec18 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a86:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a88:	00006997          	auipc	s3,0x6
    80001a8c:	77898993          	addi	s3,s3,1912 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a90:	00006a97          	auipc	s5,0x6
    80001a94:	778a8a93          	addi	s5,s5,1912 # 80008208 <etext+0x208>
    printf("\n");
    80001a98:	00006a17          	auipc	s4,0x6
    80001a9c:	5b0a0a13          	addi	s4,s4,1456 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa0:	00006b97          	auipc	s7,0x6
    80001aa4:	7a8b8b93          	addi	s7,s7,1960 # 80008248 <states.0>
    80001aa8:	a00d                	j	80001aca <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aaa:	ed86a583          	lw	a1,-296(a3)
    80001aae:	8556                	mv	a0,s5
    80001ab0:	00004097          	auipc	ra,0x4
    80001ab4:	220080e7          	jalr	544(ra) # 80005cd0 <printf>
    printf("\n");
    80001ab8:	8552                	mv	a0,s4
    80001aba:	00004097          	auipc	ra,0x4
    80001abe:	216080e7          	jalr	534(ra) # 80005cd0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ac2:	17048493          	addi	s1,s1,368
    80001ac6:	03248263          	beq	s1,s2,80001aea <procdump+0x9a>
    if(p->state == UNUSED)
    80001aca:	86a6                	mv	a3,s1
    80001acc:	ec04a783          	lw	a5,-320(s1)
    80001ad0:	dbed                	beqz	a5,80001ac2 <procdump+0x72>
      state = "???";
    80001ad2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad4:	fcfb6be3          	bltu	s6,a5,80001aaa <procdump+0x5a>
    80001ad8:	02079713          	slli	a4,a5,0x20
    80001adc:	01d75793          	srli	a5,a4,0x1d
    80001ae0:	97de                	add	a5,a5,s7
    80001ae2:	6390                	ld	a2,0(a5)
    80001ae4:	f279                	bnez	a2,80001aaa <procdump+0x5a>
      state = "???";
    80001ae6:	864e                	mv	a2,s3
    80001ae8:	b7c9                	j	80001aaa <procdump+0x5a>
  }
}
    80001aea:	60a6                	ld	ra,72(sp)
    80001aec:	6406                	ld	s0,64(sp)
    80001aee:	74e2                	ld	s1,56(sp)
    80001af0:	7942                	ld	s2,48(sp)
    80001af2:	79a2                	ld	s3,40(sp)
    80001af4:	7a02                	ld	s4,32(sp)
    80001af6:	6ae2                	ld	s5,24(sp)
    80001af8:	6b42                	ld	s6,16(sp)
    80001afa:	6ba2                	ld	s7,8(sp)
    80001afc:	6161                	addi	sp,sp,80
    80001afe:	8082                	ret

0000000080001b00 <swtch>:
    80001b00:	00153023          	sd	ra,0(a0)
    80001b04:	00253423          	sd	sp,8(a0)
    80001b08:	e900                	sd	s0,16(a0)
    80001b0a:	ed04                	sd	s1,24(a0)
    80001b0c:	03253023          	sd	s2,32(a0)
    80001b10:	03353423          	sd	s3,40(a0)
    80001b14:	03453823          	sd	s4,48(a0)
    80001b18:	03553c23          	sd	s5,56(a0)
    80001b1c:	05653023          	sd	s6,64(a0)
    80001b20:	05753423          	sd	s7,72(a0)
    80001b24:	05853823          	sd	s8,80(a0)
    80001b28:	05953c23          	sd	s9,88(a0)
    80001b2c:	07a53023          	sd	s10,96(a0)
    80001b30:	07b53423          	sd	s11,104(a0)
    80001b34:	0005b083          	ld	ra,0(a1)
    80001b38:	0085b103          	ld	sp,8(a1)
    80001b3c:	6980                	ld	s0,16(a1)
    80001b3e:	6d84                	ld	s1,24(a1)
    80001b40:	0205b903          	ld	s2,32(a1)
    80001b44:	0285b983          	ld	s3,40(a1)
    80001b48:	0305ba03          	ld	s4,48(a1)
    80001b4c:	0385ba83          	ld	s5,56(a1)
    80001b50:	0405bb03          	ld	s6,64(a1)
    80001b54:	0485bb83          	ld	s7,72(a1)
    80001b58:	0505bc03          	ld	s8,80(a1)
    80001b5c:	0585bc83          	ld	s9,88(a1)
    80001b60:	0605bd03          	ld	s10,96(a1)
    80001b64:	0685bd83          	ld	s11,104(a1)
    80001b68:	8082                	ret

0000000080001b6a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b6a:	1141                	addi	sp,sp,-16
    80001b6c:	e406                	sd	ra,8(sp)
    80001b6e:	e022                	sd	s0,0(sp)
    80001b70:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b72:	00006597          	auipc	a1,0x6
    80001b76:	70658593          	addi	a1,a1,1798 # 80008278 <states.0+0x30>
    80001b7a:	0000d517          	auipc	a0,0xd
    80001b7e:	f4650513          	addi	a0,a0,-186 # 8000eac0 <tickslock>
    80001b82:	00004097          	auipc	ra,0x4
    80001b86:	5ac080e7          	jalr	1452(ra) # 8000612e <initlock>
}
    80001b8a:	60a2                	ld	ra,8(sp)
    80001b8c:	6402                	ld	s0,0(sp)
    80001b8e:	0141                	addi	sp,sp,16
    80001b90:	8082                	ret

0000000080001b92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b92:	1141                	addi	sp,sp,-16
    80001b94:	e422                	sd	s0,8(sp)
    80001b96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b98:	00003797          	auipc	a5,0x3
    80001b9c:	52878793          	addi	a5,a5,1320 # 800050c0 <kernelvec>
    80001ba0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ba4:	6422                	ld	s0,8(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001baa:	1141                	addi	sp,sp,-16
    80001bac:	e406                	sd	ra,8(sp)
    80001bae:	e022                	sd	s0,0(sp)
    80001bb0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	304080e7          	jalr	772(ra) # 80000eb6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bbe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001bc4:	00005697          	auipc	a3,0x5
    80001bc8:	43c68693          	addi	a3,a3,1084 # 80007000 <_trampoline>
    80001bcc:	00005717          	auipc	a4,0x5
    80001bd0:	43470713          	addi	a4,a4,1076 # 80007000 <_trampoline>
    80001bd4:	8f15                	sub	a4,a4,a3
    80001bd6:	040007b7          	lui	a5,0x4000
    80001bda:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bdc:	07b2                	slli	a5,a5,0xc
    80001bde:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001be0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001be4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001be6:	18002673          	csrr	a2,satp
    80001bea:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bec:	6d30                	ld	a2,88(a0)
    80001bee:	6138                	ld	a4,64(a0)
    80001bf0:	6585                	lui	a1,0x1
    80001bf2:	972e                	add	a4,a4,a1
    80001bf4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bf6:	6d38                	ld	a4,88(a0)
    80001bf8:	00000617          	auipc	a2,0x0
    80001bfc:	13460613          	addi	a2,a2,308 # 80001d2c <usertrap>
    80001c00:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c02:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c04:	8612                	mv	a2,tp
    80001c06:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c08:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c0c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c10:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c14:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c18:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c1a:	6f18                	ld	a4,24(a4)
    80001c1c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c20:	6928                	ld	a0,80(a0)
    80001c22:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c24:	00005717          	auipc	a4,0x5
    80001c28:	47870713          	addi	a4,a4,1144 # 8000709c <userret>
    80001c2c:	8f15                	sub	a4,a4,a3
    80001c2e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c30:	577d                	li	a4,-1
    80001c32:	177e                	slli	a4,a4,0x3f
    80001c34:	8d59                	or	a0,a0,a4
    80001c36:	9782                	jalr	a5
}
    80001c38:	60a2                	ld	ra,8(sp)
    80001c3a:	6402                	ld	s0,0(sp)
    80001c3c:	0141                	addi	sp,sp,16
    80001c3e:	8082                	ret

0000000080001c40 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c4a:	0000d497          	auipc	s1,0xd
    80001c4e:	e7648493          	addi	s1,s1,-394 # 8000eac0 <tickslock>
    80001c52:	8526                	mv	a0,s1
    80001c54:	00004097          	auipc	ra,0x4
    80001c58:	56a080e7          	jalr	1386(ra) # 800061be <acquire>
  ticks++;
    80001c5c:	00007517          	auipc	a0,0x7
    80001c60:	dfc50513          	addi	a0,a0,-516 # 80008a58 <ticks>
    80001c64:	411c                	lw	a5,0(a0)
    80001c66:	2785                	addiw	a5,a5,1
    80001c68:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c6a:	00000097          	auipc	ra,0x0
    80001c6e:	996080e7          	jalr	-1642(ra) # 80001600 <wakeup>
  release(&tickslock);
    80001c72:	8526                	mv	a0,s1
    80001c74:	00004097          	auipc	ra,0x4
    80001c78:	5fe080e7          	jalr	1534(ra) # 80006272 <release>
}
    80001c7c:	60e2                	ld	ra,24(sp)
    80001c7e:	6442                	ld	s0,16(sp)
    80001c80:	64a2                	ld	s1,8(sp)
    80001c82:	6105                	addi	sp,sp,32
    80001c84:	8082                	ret

0000000080001c86 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c86:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c8a:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c8c:	0807df63          	bgez	a5,80001d2a <devintr+0xa4>
{
    80001c90:	1101                	addi	sp,sp,-32
    80001c92:	ec06                	sd	ra,24(sp)
    80001c94:	e822                	sd	s0,16(sp)
    80001c96:	e426                	sd	s1,8(sp)
    80001c98:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c9a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c9e:	46a5                	li	a3,9
    80001ca0:	00d70d63          	beq	a4,a3,80001cba <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001ca4:	577d                	li	a4,-1
    80001ca6:	177e                	slli	a4,a4,0x3f
    80001ca8:	0705                	addi	a4,a4,1
    return 0;
    80001caa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cac:	04e78e63          	beq	a5,a4,80001d08 <devintr+0x82>
  }
}
    80001cb0:	60e2                	ld	ra,24(sp)
    80001cb2:	6442                	ld	s0,16(sp)
    80001cb4:	64a2                	ld	s1,8(sp)
    80001cb6:	6105                	addi	sp,sp,32
    80001cb8:	8082                	ret
    int irq = plic_claim();
    80001cba:	00003097          	auipc	ra,0x3
    80001cbe:	50e080e7          	jalr	1294(ra) # 800051c8 <plic_claim>
    80001cc2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cc4:	47a9                	li	a5,10
    80001cc6:	02f50763          	beq	a0,a5,80001cf4 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001cca:	4785                	li	a5,1
    80001ccc:	02f50963          	beq	a0,a5,80001cfe <devintr+0x78>
    return 1;
    80001cd0:	4505                	li	a0,1
    } else if(irq){
    80001cd2:	dcf9                	beqz	s1,80001cb0 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cd4:	85a6                	mv	a1,s1
    80001cd6:	00006517          	auipc	a0,0x6
    80001cda:	5aa50513          	addi	a0,a0,1450 # 80008280 <states.0+0x38>
    80001cde:	00004097          	auipc	ra,0x4
    80001ce2:	ff2080e7          	jalr	-14(ra) # 80005cd0 <printf>
      plic_complete(irq);
    80001ce6:	8526                	mv	a0,s1
    80001ce8:	00003097          	auipc	ra,0x3
    80001cec:	504080e7          	jalr	1284(ra) # 800051ec <plic_complete>
    return 1;
    80001cf0:	4505                	li	a0,1
    80001cf2:	bf7d                	j	80001cb0 <devintr+0x2a>
      uartintr();
    80001cf4:	00004097          	auipc	ra,0x4
    80001cf8:	3ea080e7          	jalr	1002(ra) # 800060de <uartintr>
    if(irq)
    80001cfc:	b7ed                	j	80001ce6 <devintr+0x60>
      virtio_disk_intr();
    80001cfe:	00004097          	auipc	ra,0x4
    80001d02:	9b4080e7          	jalr	-1612(ra) # 800056b2 <virtio_disk_intr>
    if(irq)
    80001d06:	b7c5                	j	80001ce6 <devintr+0x60>
    if(cpuid() == 0){
    80001d08:	fffff097          	auipc	ra,0xfffff
    80001d0c:	182080e7          	jalr	386(ra) # 80000e8a <cpuid>
    80001d10:	c901                	beqz	a0,80001d20 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d12:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d16:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d18:	14479073          	csrw	sip,a5
    return 2;
    80001d1c:	4509                	li	a0,2
    80001d1e:	bf49                	j	80001cb0 <devintr+0x2a>
      clockintr();
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	f20080e7          	jalr	-224(ra) # 80001c40 <clockintr>
    80001d28:	b7ed                	j	80001d12 <devintr+0x8c>
}
    80001d2a:	8082                	ret

0000000080001d2c <usertrap>:
{
    80001d2c:	1101                	addi	sp,sp,-32
    80001d2e:	ec06                	sd	ra,24(sp)
    80001d30:	e822                	sd	s0,16(sp)
    80001d32:	e426                	sd	s1,8(sp)
    80001d34:	e04a                	sd	s2,0(sp)
    80001d36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d3c:	1007f793          	andi	a5,a5,256
    80001d40:	e3b1                	bnez	a5,80001d84 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d42:	00003797          	auipc	a5,0x3
    80001d46:	37e78793          	addi	a5,a5,894 # 800050c0 <kernelvec>
    80001d4a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	168080e7          	jalr	360(ra) # 80000eb6 <myproc>
    80001d56:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d58:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d5a:	14102773          	csrr	a4,sepc
    80001d5e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d60:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d64:	47a1                	li	a5,8
    80001d66:	02f70763          	beq	a4,a5,80001d94 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	f1c080e7          	jalr	-228(ra) # 80001c86 <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c151                	beqz	a0,80001df8 <usertrap+0xcc>
  if(killed(p))
    80001d76:	8526                	mv	a0,s1
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	acc080e7          	jalr	-1332(ra) # 80001844 <killed>
    80001d80:	c929                	beqz	a0,80001dd2 <usertrap+0xa6>
    80001d82:	a099                	j	80001dc8 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	51c50513          	addi	a0,a0,1308 # 800082a0 <states.0+0x58>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	efa080e7          	jalr	-262(ra) # 80005c86 <panic>
    if(killed(p))
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	ab0080e7          	jalr	-1360(ra) # 80001844 <killed>
    80001d9c:	e921                	bnez	a0,80001dec <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d9e:	6cb8                	ld	a4,88(s1)
    80001da0:	6f1c                	ld	a5,24(a4)
    80001da2:	0791                	addi	a5,a5,4
    80001da4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001daa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dae:	10079073          	csrw	sstatus,a5
    syscall();
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	2d4080e7          	jalr	724(ra) # 80002086 <syscall>
  if(killed(p))
    80001dba:	8526                	mv	a0,s1
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	a88080e7          	jalr	-1400(ra) # 80001844 <killed>
    80001dc4:	c911                	beqz	a0,80001dd8 <usertrap+0xac>
    80001dc6:	4901                	li	s2,0
    exit(-1);
    80001dc8:	557d                	li	a0,-1
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	906080e7          	jalr	-1786(ra) # 800016d0 <exit>
  if(which_dev == 2)
    80001dd2:	4789                	li	a5,2
    80001dd4:	04f90f63          	beq	s2,a5,80001e32 <usertrap+0x106>
  usertrapret();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	dd2080e7          	jalr	-558(ra) # 80001baa <usertrapret>
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6902                	ld	s2,0(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret
      exit(-1);
    80001dec:	557d                	li	a0,-1
    80001dee:	00000097          	auipc	ra,0x0
    80001df2:	8e2080e7          	jalr	-1822(ra) # 800016d0 <exit>
    80001df6:	b765                	j	80001d9e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dfc:	5890                	lw	a2,48(s1)
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	4c250513          	addi	a0,a0,1218 # 800082c0 <states.0+0x78>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	eca080e7          	jalr	-310(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e12:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	4da50513          	addi	a0,a0,1242 # 800082f0 <states.0+0xa8>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	eb2080e7          	jalr	-334(ra) # 80005cd0 <printf>
    setkilled(p);
    80001e26:	8526                	mv	a0,s1
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	9f0080e7          	jalr	-1552(ra) # 80001818 <setkilled>
    80001e30:	b769                	j	80001dba <usertrap+0x8e>
    yield();
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	72e080e7          	jalr	1838(ra) # 80001560 <yield>
    80001e3a:	bf79                	j	80001dd8 <usertrap+0xac>

0000000080001e3c <kerneltrap>:
{
    80001e3c:	7179                	addi	sp,sp,-48
    80001e3e:	f406                	sd	ra,40(sp)
    80001e40:	f022                	sd	s0,32(sp)
    80001e42:	ec26                	sd	s1,24(sp)
    80001e44:	e84a                	sd	s2,16(sp)
    80001e46:	e44e                	sd	s3,8(sp)
    80001e48:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e52:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e56:	1004f793          	andi	a5,s1,256
    80001e5a:	cb85                	beqz	a5,80001e8a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e60:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e62:	ef85                	bnez	a5,80001e9a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	e22080e7          	jalr	-478(ra) # 80001c86 <devintr>
    80001e6c:	cd1d                	beqz	a0,80001eaa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e6e:	4789                	li	a5,2
    80001e70:	06f50a63          	beq	a0,a5,80001ee4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e74:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e78:	10049073          	csrw	sstatus,s1
}
    80001e7c:	70a2                	ld	ra,40(sp)
    80001e7e:	7402                	ld	s0,32(sp)
    80001e80:	64e2                	ld	s1,24(sp)
    80001e82:	6942                	ld	s2,16(sp)
    80001e84:	69a2                	ld	s3,8(sp)
    80001e86:	6145                	addi	sp,sp,48
    80001e88:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	48650513          	addi	a0,a0,1158 # 80008310 <states.0+0xc8>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	df4080e7          	jalr	-524(ra) # 80005c86 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	49e50513          	addi	a0,a0,1182 # 80008338 <states.0+0xf0>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	de4080e7          	jalr	-540(ra) # 80005c86 <panic>
    printf("scause %p\n", scause);
    80001eaa:	85ce                	mv	a1,s3
    80001eac:	00006517          	auipc	a0,0x6
    80001eb0:	4ac50513          	addi	a0,a0,1196 # 80008358 <states.0+0x110>
    80001eb4:	00004097          	auipc	ra,0x4
    80001eb8:	e1c080e7          	jalr	-484(ra) # 80005cd0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ebc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec4:	00006517          	auipc	a0,0x6
    80001ec8:	4a450513          	addi	a0,a0,1188 # 80008368 <states.0+0x120>
    80001ecc:	00004097          	auipc	ra,0x4
    80001ed0:	e04080e7          	jalr	-508(ra) # 80005cd0 <printf>
    panic("kerneltrap");
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	4ac50513          	addi	a0,a0,1196 # 80008380 <states.0+0x138>
    80001edc:	00004097          	auipc	ra,0x4
    80001ee0:	daa080e7          	jalr	-598(ra) # 80005c86 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	fd2080e7          	jalr	-46(ra) # 80000eb6 <myproc>
    80001eec:	d541                	beqz	a0,80001e74 <kerneltrap+0x38>
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	fc8080e7          	jalr	-56(ra) # 80000eb6 <myproc>
    80001ef6:	4d18                	lw	a4,24(a0)
    80001ef8:	4791                	li	a5,4
    80001efa:	f6f71de3          	bne	a4,a5,80001e74 <kerneltrap+0x38>
    yield();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	662080e7          	jalr	1634(ra) # 80001560 <yield>
    80001f06:	b7bd                	j	80001e74 <kerneltrap+0x38>

0000000080001f08 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f08:	1101                	addi	sp,sp,-32
    80001f0a:	ec06                	sd	ra,24(sp)
    80001f0c:	e822                	sd	s0,16(sp)
    80001f0e:	e426                	sd	s1,8(sp)
    80001f10:	1000                	addi	s0,sp,32
    80001f12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	fa2080e7          	jalr	-94(ra) # 80000eb6 <myproc>
  switch (n) {
    80001f1c:	4795                	li	a5,5
    80001f1e:	0497e163          	bltu	a5,s1,80001f60 <argraw+0x58>
    80001f22:	048a                	slli	s1,s1,0x2
    80001f24:	00006717          	auipc	a4,0x6
    80001f28:	55c70713          	addi	a4,a4,1372 # 80008480 <states.0+0x238>
    80001f2c:	94ba                	add	s1,s1,a4
    80001f2e:	409c                	lw	a5,0(s1)
    80001f30:	97ba                	add	a5,a5,a4
    80001f32:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f34:	6d3c                	ld	a5,88(a0)
    80001f36:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f38:	60e2                	ld	ra,24(sp)
    80001f3a:	6442                	ld	s0,16(sp)
    80001f3c:	64a2                	ld	s1,8(sp)
    80001f3e:	6105                	addi	sp,sp,32
    80001f40:	8082                	ret
    return p->trapframe->a1;
    80001f42:	6d3c                	ld	a5,88(a0)
    80001f44:	7fa8                	ld	a0,120(a5)
    80001f46:	bfcd                	j	80001f38 <argraw+0x30>
    return p->trapframe->a2;
    80001f48:	6d3c                	ld	a5,88(a0)
    80001f4a:	63c8                	ld	a0,128(a5)
    80001f4c:	b7f5                	j	80001f38 <argraw+0x30>
    return p->trapframe->a3;
    80001f4e:	6d3c                	ld	a5,88(a0)
    80001f50:	67c8                	ld	a0,136(a5)
    80001f52:	b7dd                	j	80001f38 <argraw+0x30>
    return p->trapframe->a4;
    80001f54:	6d3c                	ld	a5,88(a0)
    80001f56:	6bc8                	ld	a0,144(a5)
    80001f58:	b7c5                	j	80001f38 <argraw+0x30>
    return p->trapframe->a5;
    80001f5a:	6d3c                	ld	a5,88(a0)
    80001f5c:	6fc8                	ld	a0,152(a5)
    80001f5e:	bfe9                	j	80001f38 <argraw+0x30>
  panic("argraw");
    80001f60:	00006517          	auipc	a0,0x6
    80001f64:	43050513          	addi	a0,a0,1072 # 80008390 <states.0+0x148>
    80001f68:	00004097          	auipc	ra,0x4
    80001f6c:	d1e080e7          	jalr	-738(ra) # 80005c86 <panic>

0000000080001f70 <fetchaddr>:
{
    80001f70:	1101                	addi	sp,sp,-32
    80001f72:	ec06                	sd	ra,24(sp)
    80001f74:	e822                	sd	s0,16(sp)
    80001f76:	e426                	sd	s1,8(sp)
    80001f78:	e04a                	sd	s2,0(sp)
    80001f7a:	1000                	addi	s0,sp,32
    80001f7c:	84aa                	mv	s1,a0
    80001f7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	f36080e7          	jalr	-202(ra) # 80000eb6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f88:	653c                	ld	a5,72(a0)
    80001f8a:	02f4f863          	bgeu	s1,a5,80001fba <fetchaddr+0x4a>
    80001f8e:	00848713          	addi	a4,s1,8
    80001f92:	02e7e663          	bltu	a5,a4,80001fbe <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f96:	46a1                	li	a3,8
    80001f98:	8626                	mv	a2,s1
    80001f9a:	85ca                	mv	a1,s2
    80001f9c:	6928                	ld	a0,80(a0)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	c64080e7          	jalr	-924(ra) # 80000c02 <copyin>
    80001fa6:	00a03533          	snez	a0,a0
    80001faa:	40a00533          	neg	a0,a0
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6902                	ld	s2,0(sp)
    80001fb6:	6105                	addi	sp,sp,32
    80001fb8:	8082                	ret
    return -1;
    80001fba:	557d                	li	a0,-1
    80001fbc:	bfcd                	j	80001fae <fetchaddr+0x3e>
    80001fbe:	557d                	li	a0,-1
    80001fc0:	b7fd                	j	80001fae <fetchaddr+0x3e>

0000000080001fc2 <fetchstr>:
{
    80001fc2:	7179                	addi	sp,sp,-48
    80001fc4:	f406                	sd	ra,40(sp)
    80001fc6:	f022                	sd	s0,32(sp)
    80001fc8:	ec26                	sd	s1,24(sp)
    80001fca:	e84a                	sd	s2,16(sp)
    80001fcc:	e44e                	sd	s3,8(sp)
    80001fce:	1800                	addi	s0,sp,48
    80001fd0:	892a                	mv	s2,a0
    80001fd2:	84ae                	mv	s1,a1
    80001fd4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	ee0080e7          	jalr	-288(ra) # 80000eb6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fde:	86ce                	mv	a3,s3
    80001fe0:	864a                	mv	a2,s2
    80001fe2:	85a6                	mv	a1,s1
    80001fe4:	6928                	ld	a0,80(a0)
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	caa080e7          	jalr	-854(ra) # 80000c90 <copyinstr>
    80001fee:	00054e63          	bltz	a0,8000200a <fetchstr+0x48>
  return strlen(buf);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	ffffe097          	auipc	ra,0xffffe
    80001ff8:	364080e7          	jalr	868(ra) # 80000358 <strlen>
}
    80001ffc:	70a2                	ld	ra,40(sp)
    80001ffe:	7402                	ld	s0,32(sp)
    80002000:	64e2                	ld	s1,24(sp)
    80002002:	6942                	ld	s2,16(sp)
    80002004:	69a2                	ld	s3,8(sp)
    80002006:	6145                	addi	sp,sp,48
    80002008:	8082                	ret
    return -1;
    8000200a:	557d                	li	a0,-1
    8000200c:	bfc5                	j	80001ffc <fetchstr+0x3a>

000000008000200e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000200e:	1101                	addi	sp,sp,-32
    80002010:	ec06                	sd	ra,24(sp)
    80002012:	e822                	sd	s0,16(sp)
    80002014:	e426                	sd	s1,8(sp)
    80002016:	1000                	addi	s0,sp,32
    80002018:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	eee080e7          	jalr	-274(ra) # 80001f08 <argraw>
    80002022:	c088                	sw	a0,0(s1)
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret

000000008000202e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	1000                	addi	s0,sp,32
    80002038:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	ece080e7          	jalr	-306(ra) # 80001f08 <argraw>
    80002042:	e088                	sd	a0,0(s1)
}
    80002044:	60e2                	ld	ra,24(sp)
    80002046:	6442                	ld	s0,16(sp)
    80002048:	64a2                	ld	s1,8(sp)
    8000204a:	6105                	addi	sp,sp,32
    8000204c:	8082                	ret

000000008000204e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000204e:	7179                	addi	sp,sp,-48
    80002050:	f406                	sd	ra,40(sp)
    80002052:	f022                	sd	s0,32(sp)
    80002054:	ec26                	sd	s1,24(sp)
    80002056:	e84a                	sd	s2,16(sp)
    80002058:	1800                	addi	s0,sp,48
    8000205a:	84ae                	mv	s1,a1
    8000205c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000205e:	fd840593          	addi	a1,s0,-40
    80002062:	00000097          	auipc	ra,0x0
    80002066:	fcc080e7          	jalr	-52(ra) # 8000202e <argaddr>
  return fetchstr(addr, buf, max);
    8000206a:	864a                	mv	a2,s2
    8000206c:	85a6                	mv	a1,s1
    8000206e:	fd843503          	ld	a0,-40(s0)
    80002072:	00000097          	auipc	ra,0x0
    80002076:	f50080e7          	jalr	-176(ra) # 80001fc2 <fetchstr>
}
    8000207a:	70a2                	ld	ra,40(sp)
    8000207c:	7402                	ld	s0,32(sp)
    8000207e:	64e2                	ld	s1,24(sp)
    80002080:	6942                	ld	s2,16(sp)
    80002082:	6145                	addi	sp,sp,48
    80002084:	8082                	ret

0000000080002086 <syscall>:


/*TODO*/
void
syscall(void)
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	e22080e7          	jalr	-478(ra) # 80000eb6 <myproc>
    8000209c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000209e:	05853903          	ld	s2,88(a0)
    800020a2:	0a893783          	ld	a5,168(s2)
    800020a6:	0007899b          	sext.w	s3,a5
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020aa:	37fd                	addiw	a5,a5,-1
    800020ac:	4759                	li	a4,22
    800020ae:	04f76763          	bltu	a4,a5,800020fc <syscall+0x76>
    800020b2:	00399713          	slli	a4,s3,0x3
    800020b6:	00006797          	auipc	a5,0x6
    800020ba:	3e278793          	addi	a5,a5,994 # 80008498 <syscalls>
    800020be:	97ba                	add	a5,a5,a4
    800020c0:	639c                	ld	a5,0(a5)
    800020c2:	cf8d                	beqz	a5,800020fc <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num](); /*exec system call and return value to register a0*/
    800020c4:	9782                	jalr	a5
    800020c6:	06a93823          	sd	a0,112(s2)

    if((1<<num) & p->trace_mask){
    800020ca:	1684a783          	lw	a5,360(s1)
    800020ce:	4137d7bb          	sraw	a5,a5,s3
    800020d2:	8b85                	andi	a5,a5,1
    800020d4:	c3b9                	beqz	a5,8000211a <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscall_name[num], p->trapframe->a0); /*TODO*/
    800020d6:	6cb8                	ld	a4,88(s1)
    800020d8:	098e                	slli	s3,s3,0x3
    800020da:	00006797          	auipc	a5,0x6
    800020de:	3be78793          	addi	a5,a5,958 # 80008498 <syscalls>
    800020e2:	97ce                	add	a5,a5,s3
    800020e4:	7b34                	ld	a3,112(a4)
    800020e6:	63f0                	ld	a2,192(a5)
    800020e8:	588c                	lw	a1,48(s1)
    800020ea:	00006517          	auipc	a0,0x6
    800020ee:	2ae50513          	addi	a0,a0,686 # 80008398 <states.0+0x150>
    800020f2:	00004097          	auipc	ra,0x4
    800020f6:	bde080e7          	jalr	-1058(ra) # 80005cd0 <printf>
    800020fa:	a005                	j	8000211a <syscall+0x94>
    }

  } else {
    printf("%d %s: unknown sys call %d\n",
    800020fc:	86ce                	mv	a3,s3
    800020fe:	15848613          	addi	a2,s1,344
    80002102:	588c                	lw	a1,48(s1)
    80002104:	00006517          	auipc	a0,0x6
    80002108:	2ac50513          	addi	a0,a0,684 # 800083b0 <states.0+0x168>
    8000210c:	00004097          	auipc	ra,0x4
    80002110:	bc4080e7          	jalr	-1084(ra) # 80005cd0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002114:	6cbc                	ld	a5,88(s1)
    80002116:	577d                	li	a4,-1
    80002118:	fbb8                	sd	a4,112(a5)
  }
}
    8000211a:	70a2                	ld	ra,40(sp)
    8000211c:	7402                	ld	s0,32(sp)
    8000211e:	64e2                	ld	s1,24(sp)
    80002120:	6942                	ld	s2,16(sp)
    80002122:	69a2                	ld	s3,8(sp)
    80002124:	6145                	addi	sp,sp,48
    80002126:	8082                	ret

0000000080002128 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002128:	1101                	addi	sp,sp,-32
    8000212a:	ec06                	sd	ra,24(sp)
    8000212c:	e822                	sd	s0,16(sp)
    8000212e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002130:	fec40593          	addi	a1,s0,-20
    80002134:	4501                	li	a0,0
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	ed8080e7          	jalr	-296(ra) # 8000200e <argint>
  exit(n);
    8000213e:	fec42503          	lw	a0,-20(s0)
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	58e080e7          	jalr	1422(ra) # 800016d0 <exit>
  return 0;  // not reached
}
    8000214a:	4501                	li	a0,0
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002154:	1141                	addi	sp,sp,-16
    80002156:	e406                	sd	ra,8(sp)
    80002158:	e022                	sd	s0,0(sp)
    8000215a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	d5a080e7          	jalr	-678(ra) # 80000eb6 <myproc>
}
    80002164:	5908                	lw	a0,48(a0)
    80002166:	60a2                	ld	ra,8(sp)
    80002168:	6402                	ld	s0,0(sp)
    8000216a:	0141                	addi	sp,sp,16
    8000216c:	8082                	ret

000000008000216e <sys_fork>:

uint64
sys_fork(void)
{
    8000216e:	1141                	addi	sp,sp,-16
    80002170:	e406                	sd	ra,8(sp)
    80002172:	e022                	sd	s0,0(sp)
    80002174:	0800                	addi	s0,sp,16
  return fork();
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	0f6080e7          	jalr	246(ra) # 8000126c <fork>
}
    8000217e:	60a2                	ld	ra,8(sp)
    80002180:	6402                	ld	s0,0(sp)
    80002182:	0141                	addi	sp,sp,16
    80002184:	8082                	ret

0000000080002186 <sys_wait>:

uint64
sys_wait(void)
{
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000218e:	fe840593          	addi	a1,s0,-24
    80002192:	4501                	li	a0,0
    80002194:	00000097          	auipc	ra,0x0
    80002198:	e9a080e7          	jalr	-358(ra) # 8000202e <argaddr>
  return wait(p);
    8000219c:	fe843503          	ld	a0,-24(s0)
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	6d6080e7          	jalr	1750(ra) # 80001876 <wait>
}
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021b0:	7179                	addi	sp,sp,-48
    800021b2:	f406                	sd	ra,40(sp)
    800021b4:	f022                	sd	s0,32(sp)
    800021b6:	ec26                	sd	s1,24(sp)
    800021b8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021ba:	fdc40593          	addi	a1,s0,-36
    800021be:	4501                	li	a0,0
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	e4e080e7          	jalr	-434(ra) # 8000200e <argint>
  addr = myproc()->sz;
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	cee080e7          	jalr	-786(ra) # 80000eb6 <myproc>
    800021d0:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021d2:	fdc42503          	lw	a0,-36(s0)
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	03a080e7          	jalr	58(ra) # 80001210 <growproc>
    800021de:	00054863          	bltz	a0,800021ee <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021e2:	8526                	mv	a0,s1
    800021e4:	70a2                	ld	ra,40(sp)
    800021e6:	7402                	ld	s0,32(sp)
    800021e8:	64e2                	ld	s1,24(sp)
    800021ea:	6145                	addi	sp,sp,48
    800021ec:	8082                	ret
    return -1;
    800021ee:	54fd                	li	s1,-1
    800021f0:	bfcd                	j	800021e2 <sys_sbrk+0x32>

00000000800021f2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021f2:	7139                	addi	sp,sp,-64
    800021f4:	fc06                	sd	ra,56(sp)
    800021f6:	f822                	sd	s0,48(sp)
    800021f8:	f426                	sd	s1,40(sp)
    800021fa:	f04a                	sd	s2,32(sp)
    800021fc:	ec4e                	sd	s3,24(sp)
    800021fe:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002200:	fcc40593          	addi	a1,s0,-52
    80002204:	4501                	li	a0,0
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	e08080e7          	jalr	-504(ra) # 8000200e <argint>
  if(n < 0)
    8000220e:	fcc42783          	lw	a5,-52(s0)
    80002212:	0607cf63          	bltz	a5,80002290 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002216:	0000d517          	auipc	a0,0xd
    8000221a:	8aa50513          	addi	a0,a0,-1878 # 8000eac0 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	fa0080e7          	jalr	-96(ra) # 800061be <acquire>
  ticks0 = ticks;
    80002226:	00007917          	auipc	s2,0x7
    8000222a:	83292903          	lw	s2,-1998(s2) # 80008a58 <ticks>
  while(ticks - ticks0 < n){
    8000222e:	fcc42783          	lw	a5,-52(s0)
    80002232:	cf9d                	beqz	a5,80002270 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002234:	0000d997          	auipc	s3,0xd
    80002238:	88c98993          	addi	s3,s3,-1908 # 8000eac0 <tickslock>
    8000223c:	00007497          	auipc	s1,0x7
    80002240:	81c48493          	addi	s1,s1,-2020 # 80008a58 <ticks>
    if(killed(myproc())){
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	c72080e7          	jalr	-910(ra) # 80000eb6 <myproc>
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	5f8080e7          	jalr	1528(ra) # 80001844 <killed>
    80002254:	e129                	bnez	a0,80002296 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002256:	85ce                	mv	a1,s3
    80002258:	8526                	mv	a0,s1
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	342080e7          	jalr	834(ra) # 8000159c <sleep>
  while(ticks - ticks0 < n){
    80002262:	409c                	lw	a5,0(s1)
    80002264:	412787bb          	subw	a5,a5,s2
    80002268:	fcc42703          	lw	a4,-52(s0)
    8000226c:	fce7ece3          	bltu	a5,a4,80002244 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	85050513          	addi	a0,a0,-1968 # 8000eac0 <tickslock>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	ffa080e7          	jalr	-6(ra) # 80006272 <release>
  return 0;
    80002280:	4501                	li	a0,0
}
    80002282:	70e2                	ld	ra,56(sp)
    80002284:	7442                	ld	s0,48(sp)
    80002286:	74a2                	ld	s1,40(sp)
    80002288:	7902                	ld	s2,32(sp)
    8000228a:	69e2                	ld	s3,24(sp)
    8000228c:	6121                	addi	sp,sp,64
    8000228e:	8082                	ret
    n = 0;
    80002290:	fc042623          	sw	zero,-52(s0)
    80002294:	b749                	j	80002216 <sys_sleep+0x24>
      release(&tickslock);
    80002296:	0000d517          	auipc	a0,0xd
    8000229a:	82a50513          	addi	a0,a0,-2006 # 8000eac0 <tickslock>
    8000229e:	00004097          	auipc	ra,0x4
    800022a2:	fd4080e7          	jalr	-44(ra) # 80006272 <release>
      return -1;
    800022a6:	557d                	li	a0,-1
    800022a8:	bfe9                	j	80002282 <sys_sleep+0x90>

00000000800022aa <sys_kill>:

uint64
sys_kill(void)
{
    800022aa:	1101                	addi	sp,sp,-32
    800022ac:	ec06                	sd	ra,24(sp)
    800022ae:	e822                	sd	s0,16(sp)
    800022b0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022b2:	fec40593          	addi	a1,s0,-20
    800022b6:	4501                	li	a0,0
    800022b8:	00000097          	auipc	ra,0x0
    800022bc:	d56080e7          	jalr	-682(ra) # 8000200e <argint>
  return kill(pid);
    800022c0:	fec42503          	lw	a0,-20(s0)
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	4e2080e7          	jalr	1250(ra) # 800017a6 <kill>
}
    800022cc:	60e2                	ld	ra,24(sp)
    800022ce:	6442                	ld	s0,16(sp)
    800022d0:	6105                	addi	sp,sp,32
    800022d2:	8082                	ret

00000000800022d4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	e426                	sd	s1,8(sp)
    800022dc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022de:	0000c517          	auipc	a0,0xc
    800022e2:	7e250513          	addi	a0,a0,2018 # 8000eac0 <tickslock>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	ed8080e7          	jalr	-296(ra) # 800061be <acquire>
  xticks = ticks;
    800022ee:	00006497          	auipc	s1,0x6
    800022f2:	76a4a483          	lw	s1,1898(s1) # 80008a58 <ticks>
  release(&tickslock);
    800022f6:	0000c517          	auipc	a0,0xc
    800022fa:	7ca50513          	addi	a0,a0,1994 # 8000eac0 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	f74080e7          	jalr	-140(ra) # 80006272 <release>
  return xticks;
}
    80002306:	02049513          	slli	a0,s1,0x20
    8000230a:	9101                	srli	a0,a0,0x20
    8000230c:	60e2                	ld	ra,24(sp)
    8000230e:	6442                	ld	s0,16(sp)
    80002310:	64a2                	ld	s1,8(sp)
    80002312:	6105                	addi	sp,sp,32
    80002314:	8082                	ret

0000000080002316 <sys_trace>:

uint64
sys_trace(void)
{
    80002316:	1141                	addi	sp,sp,-16
    80002318:	e406                	sd	ra,8(sp)
    8000231a:	e022                	sd	s0,0(sp)
    8000231c:	0800                	addi	s0,sp,16
 argint(0, &(myproc()->trace_mask));
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	b98080e7          	jalr	-1128(ra) # 80000eb6 <myproc>
    80002326:	16850593          	addi	a1,a0,360
    8000232a:	4501                	li	a0,0
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	ce2080e7          	jalr	-798(ra) # 8000200e <argint>
 return 0;
}
    80002334:	4501                	li	a0,0
    80002336:	60a2                	ld	ra,8(sp)
    80002338:	6402                	ld	s0,0(sp)
    8000233a:	0141                	addi	sp,sp,16
    8000233c:	8082                	ret

000000008000233e <sys_sysinfo>:

uint64
sys_sysinfo(void) /*TODO*/
{
    8000233e:	7179                	addi	sp,sp,-48
    80002340:	f406                	sd	ra,40(sp)
    80002342:	f022                	sd	s0,32(sp)
    80002344:	1800                	addi	s0,sp,48
  struct sysinfo sysi;
  
  freemem_size(&sysi.freemem); /*kalloc.c*/
    80002346:	fe040513          	addi	a0,s0,-32
    8000234a:	ffffe097          	auipc	ra,0xffffe
    8000234e:	cd2080e7          	jalr	-814(ra) # 8000001c <freemem_size>
  proc_num(&sysi.nproc);       /*pro.c*/
    80002352:	fe840513          	addi	a0,s0,-24
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	05e080e7          	jalr	94(ra) # 800013b4 <proc_num>
  
  /*fetch virtual address*/
  uint64 p;
  argaddr(0, &p);
    8000235e:	fd840593          	addi	a1,s0,-40
    80002362:	4501                	li	a0,0
    80002364:	00000097          	auipc	ra,0x0
    80002368:	cca080e7          	jalr	-822(ra) # 8000202e <argaddr>

  if(copyout(myproc()->pagetable, p, (char *)&sysi, sizeof(sysi)) < 0)
    8000236c:	fffff097          	auipc	ra,0xfffff
    80002370:	b4a080e7          	jalr	-1206(ra) # 80000eb6 <myproc>
    80002374:	46c1                	li	a3,16
    80002376:	fe040613          	addi	a2,s0,-32
    8000237a:	fd843583          	ld	a1,-40(s0)
    8000237e:	6928                	ld	a0,80(a0)
    80002380:	ffffe097          	auipc	ra,0xffffe
    80002384:	7f6080e7          	jalr	2038(ra) # 80000b76 <copyout>
    return -1;
  return 0;
    80002388:	957d                	srai	a0,a0,0x3f
    8000238a:	70a2                	ld	ra,40(sp)
    8000238c:	7402                	ld	s0,32(sp)
    8000238e:	6145                	addi	sp,sp,48
    80002390:	8082                	ret

0000000080002392 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002392:	7179                	addi	sp,sp,-48
    80002394:	f406                	sd	ra,40(sp)
    80002396:	f022                	sd	s0,32(sp)
    80002398:	ec26                	sd	s1,24(sp)
    8000239a:	e84a                	sd	s2,16(sp)
    8000239c:	e44e                	sd	s3,8(sp)
    8000239e:	e052                	sd	s4,0(sp)
    800023a0:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023a2:	00006597          	auipc	a1,0x6
    800023a6:	27658593          	addi	a1,a1,630 # 80008618 <syscall_name+0xc0>
    800023aa:	0000c517          	auipc	a0,0xc
    800023ae:	72e50513          	addi	a0,a0,1838 # 8000ead8 <bcache>
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	d7c080e7          	jalr	-644(ra) # 8000612e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023ba:	00014797          	auipc	a5,0x14
    800023be:	71e78793          	addi	a5,a5,1822 # 80016ad8 <bcache+0x8000>
    800023c2:	00015717          	auipc	a4,0x15
    800023c6:	97e70713          	addi	a4,a4,-1666 # 80016d40 <bcache+0x8268>
    800023ca:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ce:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d2:	0000c497          	auipc	s1,0xc
    800023d6:	71e48493          	addi	s1,s1,1822 # 8000eaf0 <bcache+0x18>
    b->next = bcache.head.next;
    800023da:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023dc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023de:	00006a17          	auipc	s4,0x6
    800023e2:	242a0a13          	addi	s4,s4,578 # 80008620 <syscall_name+0xc8>
    b->next = bcache.head.next;
    800023e6:	2b893783          	ld	a5,696(s2)
    800023ea:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023ec:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023f0:	85d2                	mv	a1,s4
    800023f2:	01048513          	addi	a0,s1,16
    800023f6:	00001097          	auipc	ra,0x1
    800023fa:	496080e7          	jalr	1174(ra) # 8000388c <initsleeplock>
    bcache.head.next->prev = b;
    800023fe:	2b893783          	ld	a5,696(s2)
    80002402:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002404:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002408:	45848493          	addi	s1,s1,1112
    8000240c:	fd349de3          	bne	s1,s3,800023e6 <binit+0x54>
  }
}
    80002410:	70a2                	ld	ra,40(sp)
    80002412:	7402                	ld	s0,32(sp)
    80002414:	64e2                	ld	s1,24(sp)
    80002416:	6942                	ld	s2,16(sp)
    80002418:	69a2                	ld	s3,8(sp)
    8000241a:	6a02                	ld	s4,0(sp)
    8000241c:	6145                	addi	sp,sp,48
    8000241e:	8082                	ret

0000000080002420 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002420:	7179                	addi	sp,sp,-48
    80002422:	f406                	sd	ra,40(sp)
    80002424:	f022                	sd	s0,32(sp)
    80002426:	ec26                	sd	s1,24(sp)
    80002428:	e84a                	sd	s2,16(sp)
    8000242a:	e44e                	sd	s3,8(sp)
    8000242c:	1800                	addi	s0,sp,48
    8000242e:	892a                	mv	s2,a0
    80002430:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002432:	0000c517          	auipc	a0,0xc
    80002436:	6a650513          	addi	a0,a0,1702 # 8000ead8 <bcache>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	d84080e7          	jalr	-636(ra) # 800061be <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002442:	00015497          	auipc	s1,0x15
    80002446:	94e4b483          	ld	s1,-1714(s1) # 80016d90 <bcache+0x82b8>
    8000244a:	00015797          	auipc	a5,0x15
    8000244e:	8f678793          	addi	a5,a5,-1802 # 80016d40 <bcache+0x8268>
    80002452:	02f48f63          	beq	s1,a5,80002490 <bread+0x70>
    80002456:	873e                	mv	a4,a5
    80002458:	a021                	j	80002460 <bread+0x40>
    8000245a:	68a4                	ld	s1,80(s1)
    8000245c:	02e48a63          	beq	s1,a4,80002490 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002460:	449c                	lw	a5,8(s1)
    80002462:	ff279ce3          	bne	a5,s2,8000245a <bread+0x3a>
    80002466:	44dc                	lw	a5,12(s1)
    80002468:	ff3799e3          	bne	a5,s3,8000245a <bread+0x3a>
      b->refcnt++;
    8000246c:	40bc                	lw	a5,64(s1)
    8000246e:	2785                	addiw	a5,a5,1
    80002470:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002472:	0000c517          	auipc	a0,0xc
    80002476:	66650513          	addi	a0,a0,1638 # 8000ead8 <bcache>
    8000247a:	00004097          	auipc	ra,0x4
    8000247e:	df8080e7          	jalr	-520(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    80002482:	01048513          	addi	a0,s1,16
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	440080e7          	jalr	1088(ra) # 800038c6 <acquiresleep>
      return b;
    8000248e:	a8b9                	j	800024ec <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002490:	00015497          	auipc	s1,0x15
    80002494:	8f84b483          	ld	s1,-1800(s1) # 80016d88 <bcache+0x82b0>
    80002498:	00015797          	auipc	a5,0x15
    8000249c:	8a878793          	addi	a5,a5,-1880 # 80016d40 <bcache+0x8268>
    800024a0:	00f48863          	beq	s1,a5,800024b0 <bread+0x90>
    800024a4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024a6:	40bc                	lw	a5,64(s1)
    800024a8:	cf81                	beqz	a5,800024c0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024aa:	64a4                	ld	s1,72(s1)
    800024ac:	fee49de3          	bne	s1,a4,800024a6 <bread+0x86>
  panic("bget: no buffers");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	17850513          	addi	a0,a0,376 # 80008628 <syscall_name+0xd0>
    800024b8:	00003097          	auipc	ra,0x3
    800024bc:	7ce080e7          	jalr	1998(ra) # 80005c86 <panic>
      b->dev = dev;
    800024c0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024c4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024c8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024cc:	4785                	li	a5,1
    800024ce:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d0:	0000c517          	auipc	a0,0xc
    800024d4:	60850513          	addi	a0,a0,1544 # 8000ead8 <bcache>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	d9a080e7          	jalr	-614(ra) # 80006272 <release>
      acquiresleep(&b->lock);
    800024e0:	01048513          	addi	a0,s1,16
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	3e2080e7          	jalr	994(ra) # 800038c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024ec:	409c                	lw	a5,0(s1)
    800024ee:	cb89                	beqz	a5,80002500 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024f0:	8526                	mv	a0,s1
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6145                	addi	sp,sp,48
    800024fe:	8082                	ret
    virtio_disk_rw(b, 0);
    80002500:	4581                	li	a1,0
    80002502:	8526                	mv	a0,s1
    80002504:	00003097          	auipc	ra,0x3
    80002508:	f7e080e7          	jalr	-130(ra) # 80005482 <virtio_disk_rw>
    b->valid = 1;
    8000250c:	4785                	li	a5,1
    8000250e:	c09c                	sw	a5,0(s1)
  return b;
    80002510:	b7c5                	j	800024f0 <bread+0xd0>

0000000080002512 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002512:	1101                	addi	sp,sp,-32
    80002514:	ec06                	sd	ra,24(sp)
    80002516:	e822                	sd	s0,16(sp)
    80002518:	e426                	sd	s1,8(sp)
    8000251a:	1000                	addi	s0,sp,32
    8000251c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000251e:	0541                	addi	a0,a0,16
    80002520:	00001097          	auipc	ra,0x1
    80002524:	440080e7          	jalr	1088(ra) # 80003960 <holdingsleep>
    80002528:	cd01                	beqz	a0,80002540 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000252a:	4585                	li	a1,1
    8000252c:	8526                	mv	a0,s1
    8000252e:	00003097          	auipc	ra,0x3
    80002532:	f54080e7          	jalr	-172(ra) # 80005482 <virtio_disk_rw>
}
    80002536:	60e2                	ld	ra,24(sp)
    80002538:	6442                	ld	s0,16(sp)
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret
    panic("bwrite");
    80002540:	00006517          	auipc	a0,0x6
    80002544:	10050513          	addi	a0,a0,256 # 80008640 <syscall_name+0xe8>
    80002548:	00003097          	auipc	ra,0x3
    8000254c:	73e080e7          	jalr	1854(ra) # 80005c86 <panic>

0000000080002550 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002550:	1101                	addi	sp,sp,-32
    80002552:	ec06                	sd	ra,24(sp)
    80002554:	e822                	sd	s0,16(sp)
    80002556:	e426                	sd	s1,8(sp)
    80002558:	e04a                	sd	s2,0(sp)
    8000255a:	1000                	addi	s0,sp,32
    8000255c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000255e:	01050913          	addi	s2,a0,16
    80002562:	854a                	mv	a0,s2
    80002564:	00001097          	auipc	ra,0x1
    80002568:	3fc080e7          	jalr	1020(ra) # 80003960 <holdingsleep>
    8000256c:	c925                	beqz	a0,800025dc <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000256e:	854a                	mv	a0,s2
    80002570:	00001097          	auipc	ra,0x1
    80002574:	3ac080e7          	jalr	940(ra) # 8000391c <releasesleep>

  acquire(&bcache.lock);
    80002578:	0000c517          	auipc	a0,0xc
    8000257c:	56050513          	addi	a0,a0,1376 # 8000ead8 <bcache>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	c3e080e7          	jalr	-962(ra) # 800061be <acquire>
  b->refcnt--;
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	37fd                	addiw	a5,a5,-1
    8000258c:	0007871b          	sext.w	a4,a5
    80002590:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002592:	e71d                	bnez	a4,800025c0 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002594:	68b8                	ld	a4,80(s1)
    80002596:	64bc                	ld	a5,72(s1)
    80002598:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000259a:	68b8                	ld	a4,80(s1)
    8000259c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000259e:	00014797          	auipc	a5,0x14
    800025a2:	53a78793          	addi	a5,a5,1338 # 80016ad8 <bcache+0x8000>
    800025a6:	2b87b703          	ld	a4,696(a5)
    800025aa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025ac:	00014717          	auipc	a4,0x14
    800025b0:	79470713          	addi	a4,a4,1940 # 80016d40 <bcache+0x8268>
    800025b4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025b6:	2b87b703          	ld	a4,696(a5)
    800025ba:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025bc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025c0:	0000c517          	auipc	a0,0xc
    800025c4:	51850513          	addi	a0,a0,1304 # 8000ead8 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	caa080e7          	jalr	-854(ra) # 80006272 <release>
}
    800025d0:	60e2                	ld	ra,24(sp)
    800025d2:	6442                	ld	s0,16(sp)
    800025d4:	64a2                	ld	s1,8(sp)
    800025d6:	6902                	ld	s2,0(sp)
    800025d8:	6105                	addi	sp,sp,32
    800025da:	8082                	ret
    panic("brelse");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	06c50513          	addi	a0,a0,108 # 80008648 <syscall_name+0xf0>
    800025e4:	00003097          	auipc	ra,0x3
    800025e8:	6a2080e7          	jalr	1698(ra) # 80005c86 <panic>

00000000800025ec <bpin>:

void
bpin(struct buf *b) {
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	1000                	addi	s0,sp,32
    800025f6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f8:	0000c517          	auipc	a0,0xc
    800025fc:	4e050513          	addi	a0,a0,1248 # 8000ead8 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	bbe080e7          	jalr	-1090(ra) # 800061be <acquire>
  b->refcnt++;
    80002608:	40bc                	lw	a5,64(s1)
    8000260a:	2785                	addiw	a5,a5,1
    8000260c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260e:	0000c517          	auipc	a0,0xc
    80002612:	4ca50513          	addi	a0,a0,1226 # 8000ead8 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	c5c080e7          	jalr	-932(ra) # 80006272 <release>
}
    8000261e:	60e2                	ld	ra,24(sp)
    80002620:	6442                	ld	s0,16(sp)
    80002622:	64a2                	ld	s1,8(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret

0000000080002628 <bunpin>:

void
bunpin(struct buf *b) {
    80002628:	1101                	addi	sp,sp,-32
    8000262a:	ec06                	sd	ra,24(sp)
    8000262c:	e822                	sd	s0,16(sp)
    8000262e:	e426                	sd	s1,8(sp)
    80002630:	1000                	addi	s0,sp,32
    80002632:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002634:	0000c517          	auipc	a0,0xc
    80002638:	4a450513          	addi	a0,a0,1188 # 8000ead8 <bcache>
    8000263c:	00004097          	auipc	ra,0x4
    80002640:	b82080e7          	jalr	-1150(ra) # 800061be <acquire>
  b->refcnt--;
    80002644:	40bc                	lw	a5,64(s1)
    80002646:	37fd                	addiw	a5,a5,-1
    80002648:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000264a:	0000c517          	auipc	a0,0xc
    8000264e:	48e50513          	addi	a0,a0,1166 # 8000ead8 <bcache>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	c20080e7          	jalr	-992(ra) # 80006272 <release>
}
    8000265a:	60e2                	ld	ra,24(sp)
    8000265c:	6442                	ld	s0,16(sp)
    8000265e:	64a2                	ld	s1,8(sp)
    80002660:	6105                	addi	sp,sp,32
    80002662:	8082                	ret

0000000080002664 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002664:	1101                	addi	sp,sp,-32
    80002666:	ec06                	sd	ra,24(sp)
    80002668:	e822                	sd	s0,16(sp)
    8000266a:	e426                	sd	s1,8(sp)
    8000266c:	e04a                	sd	s2,0(sp)
    8000266e:	1000                	addi	s0,sp,32
    80002670:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002672:	00d5d59b          	srliw	a1,a1,0xd
    80002676:	00015797          	auipc	a5,0x15
    8000267a:	b3e7a783          	lw	a5,-1218(a5) # 800171b4 <sb+0x1c>
    8000267e:	9dbd                	addw	a1,a1,a5
    80002680:	00000097          	auipc	ra,0x0
    80002684:	da0080e7          	jalr	-608(ra) # 80002420 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002688:	0074f713          	andi	a4,s1,7
    8000268c:	4785                	li	a5,1
    8000268e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002692:	14ce                	slli	s1,s1,0x33
    80002694:	90d9                	srli	s1,s1,0x36
    80002696:	00950733          	add	a4,a0,s1
    8000269a:	05874703          	lbu	a4,88(a4)
    8000269e:	00e7f6b3          	and	a3,a5,a4
    800026a2:	c69d                	beqz	a3,800026d0 <bfree+0x6c>
    800026a4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026a6:	94aa                	add	s1,s1,a0
    800026a8:	fff7c793          	not	a5,a5
    800026ac:	8f7d                	and	a4,a4,a5
    800026ae:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	0f6080e7          	jalr	246(ra) # 800037a8 <log_write>
  brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	e94080e7          	jalr	-364(ra) # 80002550 <brelse>
}
    800026c4:	60e2                	ld	ra,24(sp)
    800026c6:	6442                	ld	s0,16(sp)
    800026c8:	64a2                	ld	s1,8(sp)
    800026ca:	6902                	ld	s2,0(sp)
    800026cc:	6105                	addi	sp,sp,32
    800026ce:	8082                	ret
    panic("freeing free block");
    800026d0:	00006517          	auipc	a0,0x6
    800026d4:	f8050513          	addi	a0,a0,-128 # 80008650 <syscall_name+0xf8>
    800026d8:	00003097          	auipc	ra,0x3
    800026dc:	5ae080e7          	jalr	1454(ra) # 80005c86 <panic>

00000000800026e0 <balloc>:
{
    800026e0:	711d                	addi	sp,sp,-96
    800026e2:	ec86                	sd	ra,88(sp)
    800026e4:	e8a2                	sd	s0,80(sp)
    800026e6:	e4a6                	sd	s1,72(sp)
    800026e8:	e0ca                	sd	s2,64(sp)
    800026ea:	fc4e                	sd	s3,56(sp)
    800026ec:	f852                	sd	s4,48(sp)
    800026ee:	f456                	sd	s5,40(sp)
    800026f0:	f05a                	sd	s6,32(sp)
    800026f2:	ec5e                	sd	s7,24(sp)
    800026f4:	e862                	sd	s8,16(sp)
    800026f6:	e466                	sd	s9,8(sp)
    800026f8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026fa:	00015797          	auipc	a5,0x15
    800026fe:	aa27a783          	lw	a5,-1374(a5) # 8001719c <sb+0x4>
    80002702:	cff5                	beqz	a5,800027fe <balloc+0x11e>
    80002704:	8baa                	mv	s7,a0
    80002706:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002708:	00015b17          	auipc	s6,0x15
    8000270c:	a90b0b13          	addi	s6,s6,-1392 # 80017198 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002712:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002714:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002716:	6c89                	lui	s9,0x2
    80002718:	a061                	j	800027a0 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000271a:	97ca                	add	a5,a5,s2
    8000271c:	8e55                	or	a2,a2,a3
    8000271e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002722:	854a                	mv	a0,s2
    80002724:	00001097          	auipc	ra,0x1
    80002728:	084080e7          	jalr	132(ra) # 800037a8 <log_write>
        brelse(bp);
    8000272c:	854a                	mv	a0,s2
    8000272e:	00000097          	auipc	ra,0x0
    80002732:	e22080e7          	jalr	-478(ra) # 80002550 <brelse>
  bp = bread(dev, bno);
    80002736:	85a6                	mv	a1,s1
    80002738:	855e                	mv	a0,s7
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	ce6080e7          	jalr	-794(ra) # 80002420 <bread>
    80002742:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002744:	40000613          	li	a2,1024
    80002748:	4581                	li	a1,0
    8000274a:	05850513          	addi	a0,a0,88
    8000274e:	ffffe097          	auipc	ra,0xffffe
    80002752:	a90080e7          	jalr	-1392(ra) # 800001de <memset>
  log_write(bp);
    80002756:	854a                	mv	a0,s2
    80002758:	00001097          	auipc	ra,0x1
    8000275c:	050080e7          	jalr	80(ra) # 800037a8 <log_write>
  brelse(bp);
    80002760:	854a                	mv	a0,s2
    80002762:	00000097          	auipc	ra,0x0
    80002766:	dee080e7          	jalr	-530(ra) # 80002550 <brelse>
}
    8000276a:	8526                	mv	a0,s1
    8000276c:	60e6                	ld	ra,88(sp)
    8000276e:	6446                	ld	s0,80(sp)
    80002770:	64a6                	ld	s1,72(sp)
    80002772:	6906                	ld	s2,64(sp)
    80002774:	79e2                	ld	s3,56(sp)
    80002776:	7a42                	ld	s4,48(sp)
    80002778:	7aa2                	ld	s5,40(sp)
    8000277a:	7b02                	ld	s6,32(sp)
    8000277c:	6be2                	ld	s7,24(sp)
    8000277e:	6c42                	ld	s8,16(sp)
    80002780:	6ca2                	ld	s9,8(sp)
    80002782:	6125                	addi	sp,sp,96
    80002784:	8082                	ret
    brelse(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	dc8080e7          	jalr	-568(ra) # 80002550 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002790:	015c87bb          	addw	a5,s9,s5
    80002794:	00078a9b          	sext.w	s5,a5
    80002798:	004b2703          	lw	a4,4(s6)
    8000279c:	06eaf163          	bgeu	s5,a4,800027fe <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027a0:	41fad79b          	sraiw	a5,s5,0x1f
    800027a4:	0137d79b          	srliw	a5,a5,0x13
    800027a8:	015787bb          	addw	a5,a5,s5
    800027ac:	40d7d79b          	sraiw	a5,a5,0xd
    800027b0:	01cb2583          	lw	a1,28(s6)
    800027b4:	9dbd                	addw	a1,a1,a5
    800027b6:	855e                	mv	a0,s7
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	c68080e7          	jalr	-920(ra) # 80002420 <bread>
    800027c0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c2:	004b2503          	lw	a0,4(s6)
    800027c6:	000a849b          	sext.w	s1,s5
    800027ca:	8762                	mv	a4,s8
    800027cc:	faa4fde3          	bgeu	s1,a0,80002786 <balloc+0xa6>
      m = 1 << (bi % 8);
    800027d0:	00777693          	andi	a3,a4,7
    800027d4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027d8:	41f7579b          	sraiw	a5,a4,0x1f
    800027dc:	01d7d79b          	srliw	a5,a5,0x1d
    800027e0:	9fb9                	addw	a5,a5,a4
    800027e2:	4037d79b          	sraiw	a5,a5,0x3
    800027e6:	00f90633          	add	a2,s2,a5
    800027ea:	05864603          	lbu	a2,88(a2)
    800027ee:	00c6f5b3          	and	a1,a3,a2
    800027f2:	d585                	beqz	a1,8000271a <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f4:	2705                	addiw	a4,a4,1
    800027f6:	2485                	addiw	s1,s1,1
    800027f8:	fd471ae3          	bne	a4,s4,800027cc <balloc+0xec>
    800027fc:	b769                	j	80002786 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027fe:	00006517          	auipc	a0,0x6
    80002802:	e6a50513          	addi	a0,a0,-406 # 80008668 <syscall_name+0x110>
    80002806:	00003097          	auipc	ra,0x3
    8000280a:	4ca080e7          	jalr	1226(ra) # 80005cd0 <printf>
  return 0;
    8000280e:	4481                	li	s1,0
    80002810:	bfa9                	j	8000276a <balloc+0x8a>

0000000080002812 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
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
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002824:	47ad                	li	a5,11
    80002826:	02b7e863          	bltu	a5,a1,80002856 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000282a:	02059793          	slli	a5,a1,0x20
    8000282e:	01e7d593          	srli	a1,a5,0x1e
    80002832:	00b504b3          	add	s1,a0,a1
    80002836:	0504a903          	lw	s2,80(s1)
    8000283a:	06091e63          	bnez	s2,800028b6 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000283e:	4108                	lw	a0,0(a0)
    80002840:	00000097          	auipc	ra,0x0
    80002844:	ea0080e7          	jalr	-352(ra) # 800026e0 <balloc>
    80002848:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000284c:	06090563          	beqz	s2,800028b6 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002850:	0524a823          	sw	s2,80(s1)
    80002854:	a08d                	j	800028b6 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002856:	ff45849b          	addiw	s1,a1,-12
    8000285a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000285e:	0ff00793          	li	a5,255
    80002862:	08e7e563          	bltu	a5,a4,800028ec <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002866:	08052903          	lw	s2,128(a0)
    8000286a:	00091d63          	bnez	s2,80002884 <bmap+0x72>
      addr = balloc(ip->dev);
    8000286e:	4108                	lw	a0,0(a0)
    80002870:	00000097          	auipc	ra,0x0
    80002874:	e70080e7          	jalr	-400(ra) # 800026e0 <balloc>
    80002878:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000287c:	02090d63          	beqz	s2,800028b6 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002880:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002884:	85ca                	mv	a1,s2
    80002886:	0009a503          	lw	a0,0(s3)
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	b96080e7          	jalr	-1130(ra) # 80002420 <bread>
    80002892:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002894:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002898:	02049713          	slli	a4,s1,0x20
    8000289c:	01e75593          	srli	a1,a4,0x1e
    800028a0:	00b784b3          	add	s1,a5,a1
    800028a4:	0004a903          	lw	s2,0(s1)
    800028a8:	02090063          	beqz	s2,800028c8 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028ac:	8552                	mv	a0,s4
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	ca2080e7          	jalr	-862(ra) # 80002550 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028b6:	854a                	mv	a0,s2
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6a02                	ld	s4,0(sp)
    800028c4:	6145                	addi	sp,sp,48
    800028c6:	8082                	ret
      addr = balloc(ip->dev);
    800028c8:	0009a503          	lw	a0,0(s3)
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	e14080e7          	jalr	-492(ra) # 800026e0 <balloc>
    800028d4:	0005091b          	sext.w	s2,a0
      if(addr){
    800028d8:	fc090ae3          	beqz	s2,800028ac <bmap+0x9a>
        a[bn] = addr;
    800028dc:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028e0:	8552                	mv	a0,s4
    800028e2:	00001097          	auipc	ra,0x1
    800028e6:	ec6080e7          	jalr	-314(ra) # 800037a8 <log_write>
    800028ea:	b7c9                	j	800028ac <bmap+0x9a>
  panic("bmap: out of range");
    800028ec:	00006517          	auipc	a0,0x6
    800028f0:	d9450513          	addi	a0,a0,-620 # 80008680 <syscall_name+0x128>
    800028f4:	00003097          	auipc	ra,0x3
    800028f8:	392080e7          	jalr	914(ra) # 80005c86 <panic>

00000000800028fc <iget>:
{
    800028fc:	7179                	addi	sp,sp,-48
    800028fe:	f406                	sd	ra,40(sp)
    80002900:	f022                	sd	s0,32(sp)
    80002902:	ec26                	sd	s1,24(sp)
    80002904:	e84a                	sd	s2,16(sp)
    80002906:	e44e                	sd	s3,8(sp)
    80002908:	e052                	sd	s4,0(sp)
    8000290a:	1800                	addi	s0,sp,48
    8000290c:	89aa                	mv	s3,a0
    8000290e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002910:	00015517          	auipc	a0,0x15
    80002914:	8a850513          	addi	a0,a0,-1880 # 800171b8 <itable>
    80002918:	00004097          	auipc	ra,0x4
    8000291c:	8a6080e7          	jalr	-1882(ra) # 800061be <acquire>
  empty = 0;
    80002920:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002922:	00015497          	auipc	s1,0x15
    80002926:	8ae48493          	addi	s1,s1,-1874 # 800171d0 <itable+0x18>
    8000292a:	00016697          	auipc	a3,0x16
    8000292e:	33668693          	addi	a3,a3,822 # 80018c60 <log>
    80002932:	a039                	j	80002940 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002934:	02090b63          	beqz	s2,8000296a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002938:	08848493          	addi	s1,s1,136
    8000293c:	02d48a63          	beq	s1,a3,80002970 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002940:	449c                	lw	a5,8(s1)
    80002942:	fef059e3          	blez	a5,80002934 <iget+0x38>
    80002946:	4098                	lw	a4,0(s1)
    80002948:	ff3716e3          	bne	a4,s3,80002934 <iget+0x38>
    8000294c:	40d8                	lw	a4,4(s1)
    8000294e:	ff4713e3          	bne	a4,s4,80002934 <iget+0x38>
      ip->ref++;
    80002952:	2785                	addiw	a5,a5,1
    80002954:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002956:	00015517          	auipc	a0,0x15
    8000295a:	86250513          	addi	a0,a0,-1950 # 800171b8 <itable>
    8000295e:	00004097          	auipc	ra,0x4
    80002962:	914080e7          	jalr	-1772(ra) # 80006272 <release>
      return ip;
    80002966:	8926                	mv	s2,s1
    80002968:	a03d                	j	80002996 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000296a:	f7f9                	bnez	a5,80002938 <iget+0x3c>
    8000296c:	8926                	mv	s2,s1
    8000296e:	b7e9                	j	80002938 <iget+0x3c>
  if(empty == 0)
    80002970:	02090c63          	beqz	s2,800029a8 <iget+0xac>
  ip->dev = dev;
    80002974:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002978:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000297c:	4785                	li	a5,1
    8000297e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002982:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002986:	00015517          	auipc	a0,0x15
    8000298a:	83250513          	addi	a0,a0,-1998 # 800171b8 <itable>
    8000298e:	00004097          	auipc	ra,0x4
    80002992:	8e4080e7          	jalr	-1820(ra) # 80006272 <release>
}
    80002996:	854a                	mv	a0,s2
    80002998:	70a2                	ld	ra,40(sp)
    8000299a:	7402                	ld	s0,32(sp)
    8000299c:	64e2                	ld	s1,24(sp)
    8000299e:	6942                	ld	s2,16(sp)
    800029a0:	69a2                	ld	s3,8(sp)
    800029a2:	6a02                	ld	s4,0(sp)
    800029a4:	6145                	addi	sp,sp,48
    800029a6:	8082                	ret
    panic("iget: no inodes");
    800029a8:	00006517          	auipc	a0,0x6
    800029ac:	cf050513          	addi	a0,a0,-784 # 80008698 <syscall_name+0x140>
    800029b0:	00003097          	auipc	ra,0x3
    800029b4:	2d6080e7          	jalr	726(ra) # 80005c86 <panic>

00000000800029b8 <fsinit>:
fsinit(int dev) {
    800029b8:	7179                	addi	sp,sp,-48
    800029ba:	f406                	sd	ra,40(sp)
    800029bc:	f022                	sd	s0,32(sp)
    800029be:	ec26                	sd	s1,24(sp)
    800029c0:	e84a                	sd	s2,16(sp)
    800029c2:	e44e                	sd	s3,8(sp)
    800029c4:	1800                	addi	s0,sp,48
    800029c6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029c8:	4585                	li	a1,1
    800029ca:	00000097          	auipc	ra,0x0
    800029ce:	a56080e7          	jalr	-1450(ra) # 80002420 <bread>
    800029d2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029d4:	00014997          	auipc	s3,0x14
    800029d8:	7c498993          	addi	s3,s3,1988 # 80017198 <sb>
    800029dc:	02000613          	li	a2,32
    800029e0:	05850593          	addi	a1,a0,88
    800029e4:	854e                	mv	a0,s3
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	854080e7          	jalr	-1964(ra) # 8000023a <memmove>
  brelse(bp);
    800029ee:	8526                	mv	a0,s1
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	b60080e7          	jalr	-1184(ra) # 80002550 <brelse>
  if(sb.magic != FSMAGIC)
    800029f8:	0009a703          	lw	a4,0(s3)
    800029fc:	102037b7          	lui	a5,0x10203
    80002a00:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a04:	02f71263          	bne	a4,a5,80002a28 <fsinit+0x70>
  initlog(dev, &sb);
    80002a08:	00014597          	auipc	a1,0x14
    80002a0c:	79058593          	addi	a1,a1,1936 # 80017198 <sb>
    80002a10:	854a                	mv	a0,s2
    80002a12:	00001097          	auipc	ra,0x1
    80002a16:	b2c080e7          	jalr	-1236(ra) # 8000353e <initlog>
}
    80002a1a:	70a2                	ld	ra,40(sp)
    80002a1c:	7402                	ld	s0,32(sp)
    80002a1e:	64e2                	ld	s1,24(sp)
    80002a20:	6942                	ld	s2,16(sp)
    80002a22:	69a2                	ld	s3,8(sp)
    80002a24:	6145                	addi	sp,sp,48
    80002a26:	8082                	ret
    panic("invalid file system");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	c8050513          	addi	a0,a0,-896 # 800086a8 <syscall_name+0x150>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	256080e7          	jalr	598(ra) # 80005c86 <panic>

0000000080002a38 <iinit>:
{
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a46:	00006597          	auipc	a1,0x6
    80002a4a:	c7a58593          	addi	a1,a1,-902 # 800086c0 <syscall_name+0x168>
    80002a4e:	00014517          	auipc	a0,0x14
    80002a52:	76a50513          	addi	a0,a0,1898 # 800171b8 <itable>
    80002a56:	00003097          	auipc	ra,0x3
    80002a5a:	6d8080e7          	jalr	1752(ra) # 8000612e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a5e:	00014497          	auipc	s1,0x14
    80002a62:	78248493          	addi	s1,s1,1922 # 800171e0 <itable+0x28>
    80002a66:	00016997          	auipc	s3,0x16
    80002a6a:	20a98993          	addi	s3,s3,522 # 80018c70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a6e:	00006917          	auipc	s2,0x6
    80002a72:	c5a90913          	addi	s2,s2,-934 # 800086c8 <syscall_name+0x170>
    80002a76:	85ca                	mv	a1,s2
    80002a78:	8526                	mv	a0,s1
    80002a7a:	00001097          	auipc	ra,0x1
    80002a7e:	e12080e7          	jalr	-494(ra) # 8000388c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a82:	08848493          	addi	s1,s1,136
    80002a86:	ff3498e3          	bne	s1,s3,80002a76 <iinit+0x3e>
}
    80002a8a:	70a2                	ld	ra,40(sp)
    80002a8c:	7402                	ld	s0,32(sp)
    80002a8e:	64e2                	ld	s1,24(sp)
    80002a90:	6942                	ld	s2,16(sp)
    80002a92:	69a2                	ld	s3,8(sp)
    80002a94:	6145                	addi	sp,sp,48
    80002a96:	8082                	ret

0000000080002a98 <ialloc>:
{
    80002a98:	7139                	addi	sp,sp,-64
    80002a9a:	fc06                	sd	ra,56(sp)
    80002a9c:	f822                	sd	s0,48(sp)
    80002a9e:	f426                	sd	s1,40(sp)
    80002aa0:	f04a                	sd	s2,32(sp)
    80002aa2:	ec4e                	sd	s3,24(sp)
    80002aa4:	e852                	sd	s4,16(sp)
    80002aa6:	e456                	sd	s5,8(sp)
    80002aa8:	e05a                	sd	s6,0(sp)
    80002aaa:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aac:	00014717          	auipc	a4,0x14
    80002ab0:	6f872703          	lw	a4,1784(a4) # 800171a4 <sb+0xc>
    80002ab4:	4785                	li	a5,1
    80002ab6:	04e7f863          	bgeu	a5,a4,80002b06 <ialloc+0x6e>
    80002aba:	8aaa                	mv	s5,a0
    80002abc:	8b2e                	mv	s6,a1
    80002abe:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac0:	00014a17          	auipc	s4,0x14
    80002ac4:	6d8a0a13          	addi	s4,s4,1752 # 80017198 <sb>
    80002ac8:	00495593          	srli	a1,s2,0x4
    80002acc:	018a2783          	lw	a5,24(s4)
    80002ad0:	9dbd                	addw	a1,a1,a5
    80002ad2:	8556                	mv	a0,s5
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	94c080e7          	jalr	-1716(ra) # 80002420 <bread>
    80002adc:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ade:	05850993          	addi	s3,a0,88
    80002ae2:	00f97793          	andi	a5,s2,15
    80002ae6:	079a                	slli	a5,a5,0x6
    80002ae8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aea:	00099783          	lh	a5,0(s3)
    80002aee:	cf9d                	beqz	a5,80002b2c <ialloc+0x94>
    brelse(bp);
    80002af0:	00000097          	auipc	ra,0x0
    80002af4:	a60080e7          	jalr	-1440(ra) # 80002550 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af8:	0905                	addi	s2,s2,1
    80002afa:	00ca2703          	lw	a4,12(s4)
    80002afe:	0009079b          	sext.w	a5,s2
    80002b02:	fce7e3e3          	bltu	a5,a4,80002ac8 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	bca50513          	addi	a0,a0,-1078 # 800086d0 <syscall_name+0x178>
    80002b0e:	00003097          	auipc	ra,0x3
    80002b12:	1c2080e7          	jalr	450(ra) # 80005cd0 <printf>
  return 0;
    80002b16:	4501                	li	a0,0
}
    80002b18:	70e2                	ld	ra,56(sp)
    80002b1a:	7442                	ld	s0,48(sp)
    80002b1c:	74a2                	ld	s1,40(sp)
    80002b1e:	7902                	ld	s2,32(sp)
    80002b20:	69e2                	ld	s3,24(sp)
    80002b22:	6a42                	ld	s4,16(sp)
    80002b24:	6aa2                	ld	s5,8(sp)
    80002b26:	6b02                	ld	s6,0(sp)
    80002b28:	6121                	addi	sp,sp,64
    80002b2a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b2c:	04000613          	li	a2,64
    80002b30:	4581                	li	a1,0
    80002b32:	854e                	mv	a0,s3
    80002b34:	ffffd097          	auipc	ra,0xffffd
    80002b38:	6aa080e7          	jalr	1706(ra) # 800001de <memset>
      dip->type = type;
    80002b3c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b40:	8526                	mv	a0,s1
    80002b42:	00001097          	auipc	ra,0x1
    80002b46:	c66080e7          	jalr	-922(ra) # 800037a8 <log_write>
      brelse(bp);
    80002b4a:	8526                	mv	a0,s1
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	a04080e7          	jalr	-1532(ra) # 80002550 <brelse>
      return iget(dev, inum);
    80002b54:	0009059b          	sext.w	a1,s2
    80002b58:	8556                	mv	a0,s5
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	da2080e7          	jalr	-606(ra) # 800028fc <iget>
    80002b62:	bf5d                	j	80002b18 <ialloc+0x80>

0000000080002b64 <iupdate>:
{
    80002b64:	1101                	addi	sp,sp,-32
    80002b66:	ec06                	sd	ra,24(sp)
    80002b68:	e822                	sd	s0,16(sp)
    80002b6a:	e426                	sd	s1,8(sp)
    80002b6c:	e04a                	sd	s2,0(sp)
    80002b6e:	1000                	addi	s0,sp,32
    80002b70:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b72:	415c                	lw	a5,4(a0)
    80002b74:	0047d79b          	srliw	a5,a5,0x4
    80002b78:	00014597          	auipc	a1,0x14
    80002b7c:	6385a583          	lw	a1,1592(a1) # 800171b0 <sb+0x18>
    80002b80:	9dbd                	addw	a1,a1,a5
    80002b82:	4108                	lw	a0,0(a0)
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	89c080e7          	jalr	-1892(ra) # 80002420 <bread>
    80002b8c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b8e:	05850793          	addi	a5,a0,88
    80002b92:	40d8                	lw	a4,4(s1)
    80002b94:	8b3d                	andi	a4,a4,15
    80002b96:	071a                	slli	a4,a4,0x6
    80002b98:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b9a:	04449703          	lh	a4,68(s1)
    80002b9e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ba2:	04649703          	lh	a4,70(s1)
    80002ba6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002baa:	04849703          	lh	a4,72(s1)
    80002bae:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bb2:	04a49703          	lh	a4,74(s1)
    80002bb6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bba:	44f8                	lw	a4,76(s1)
    80002bbc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bbe:	03400613          	li	a2,52
    80002bc2:	05048593          	addi	a1,s1,80
    80002bc6:	00c78513          	addi	a0,a5,12
    80002bca:	ffffd097          	auipc	ra,0xffffd
    80002bce:	670080e7          	jalr	1648(ra) # 8000023a <memmove>
  log_write(bp);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	bd4080e7          	jalr	-1068(ra) # 800037a8 <log_write>
  brelse(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	972080e7          	jalr	-1678(ra) # 80002550 <brelse>
}
    80002be6:	60e2                	ld	ra,24(sp)
    80002be8:	6442                	ld	s0,16(sp)
    80002bea:	64a2                	ld	s1,8(sp)
    80002bec:	6902                	ld	s2,0(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret

0000000080002bf2 <idup>:
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	1000                	addi	s0,sp,32
    80002bfc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bfe:	00014517          	auipc	a0,0x14
    80002c02:	5ba50513          	addi	a0,a0,1466 # 800171b8 <itable>
    80002c06:	00003097          	auipc	ra,0x3
    80002c0a:	5b8080e7          	jalr	1464(ra) # 800061be <acquire>
  ip->ref++;
    80002c0e:	449c                	lw	a5,8(s1)
    80002c10:	2785                	addiw	a5,a5,1
    80002c12:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c14:	00014517          	auipc	a0,0x14
    80002c18:	5a450513          	addi	a0,a0,1444 # 800171b8 <itable>
    80002c1c:	00003097          	auipc	ra,0x3
    80002c20:	656080e7          	jalr	1622(ra) # 80006272 <release>
}
    80002c24:	8526                	mv	a0,s1
    80002c26:	60e2                	ld	ra,24(sp)
    80002c28:	6442                	ld	s0,16(sp)
    80002c2a:	64a2                	ld	s1,8(sp)
    80002c2c:	6105                	addi	sp,sp,32
    80002c2e:	8082                	ret

0000000080002c30 <ilock>:
{
    80002c30:	1101                	addi	sp,sp,-32
    80002c32:	ec06                	sd	ra,24(sp)
    80002c34:	e822                	sd	s0,16(sp)
    80002c36:	e426                	sd	s1,8(sp)
    80002c38:	e04a                	sd	s2,0(sp)
    80002c3a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c3c:	c115                	beqz	a0,80002c60 <ilock+0x30>
    80002c3e:	84aa                	mv	s1,a0
    80002c40:	451c                	lw	a5,8(a0)
    80002c42:	00f05f63          	blez	a5,80002c60 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c46:	0541                	addi	a0,a0,16
    80002c48:	00001097          	auipc	ra,0x1
    80002c4c:	c7e080e7          	jalr	-898(ra) # 800038c6 <acquiresleep>
  if(ip->valid == 0){
    80002c50:	40bc                	lw	a5,64(s1)
    80002c52:	cf99                	beqz	a5,80002c70 <ilock+0x40>
}
    80002c54:	60e2                	ld	ra,24(sp)
    80002c56:	6442                	ld	s0,16(sp)
    80002c58:	64a2                	ld	s1,8(sp)
    80002c5a:	6902                	ld	s2,0(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret
    panic("ilock");
    80002c60:	00006517          	auipc	a0,0x6
    80002c64:	a8850513          	addi	a0,a0,-1400 # 800086e8 <syscall_name+0x190>
    80002c68:	00003097          	auipc	ra,0x3
    80002c6c:	01e080e7          	jalr	30(ra) # 80005c86 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c70:	40dc                	lw	a5,4(s1)
    80002c72:	0047d79b          	srliw	a5,a5,0x4
    80002c76:	00014597          	auipc	a1,0x14
    80002c7a:	53a5a583          	lw	a1,1338(a1) # 800171b0 <sb+0x18>
    80002c7e:	9dbd                	addw	a1,a1,a5
    80002c80:	4088                	lw	a0,0(s1)
    80002c82:	fffff097          	auipc	ra,0xfffff
    80002c86:	79e080e7          	jalr	1950(ra) # 80002420 <bread>
    80002c8a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8c:	05850593          	addi	a1,a0,88
    80002c90:	40dc                	lw	a5,4(s1)
    80002c92:	8bbd                	andi	a5,a5,15
    80002c94:	079a                	slli	a5,a5,0x6
    80002c96:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c98:	00059783          	lh	a5,0(a1)
    80002c9c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ca0:	00259783          	lh	a5,2(a1)
    80002ca4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ca8:	00459783          	lh	a5,4(a1)
    80002cac:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cb0:	00659783          	lh	a5,6(a1)
    80002cb4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cb8:	459c                	lw	a5,8(a1)
    80002cba:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cbc:	03400613          	li	a2,52
    80002cc0:	05b1                	addi	a1,a1,12
    80002cc2:	05048513          	addi	a0,s1,80
    80002cc6:	ffffd097          	auipc	ra,0xffffd
    80002cca:	574080e7          	jalr	1396(ra) # 8000023a <memmove>
    brelse(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	880080e7          	jalr	-1920(ra) # 80002550 <brelse>
    ip->valid = 1;
    80002cd8:	4785                	li	a5,1
    80002cda:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cdc:	04449783          	lh	a5,68(s1)
    80002ce0:	fbb5                	bnez	a5,80002c54 <ilock+0x24>
      panic("ilock: no type");
    80002ce2:	00006517          	auipc	a0,0x6
    80002ce6:	a0e50513          	addi	a0,a0,-1522 # 800086f0 <syscall_name+0x198>
    80002cea:	00003097          	auipc	ra,0x3
    80002cee:	f9c080e7          	jalr	-100(ra) # 80005c86 <panic>

0000000080002cf2 <iunlock>:
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	e04a                	sd	s2,0(sp)
    80002cfc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cfe:	c905                	beqz	a0,80002d2e <iunlock+0x3c>
    80002d00:	84aa                	mv	s1,a0
    80002d02:	01050913          	addi	s2,a0,16
    80002d06:	854a                	mv	a0,s2
    80002d08:	00001097          	auipc	ra,0x1
    80002d0c:	c58080e7          	jalr	-936(ra) # 80003960 <holdingsleep>
    80002d10:	cd19                	beqz	a0,80002d2e <iunlock+0x3c>
    80002d12:	449c                	lw	a5,8(s1)
    80002d14:	00f05d63          	blez	a5,80002d2e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d18:	854a                	mv	a0,s2
    80002d1a:	00001097          	auipc	ra,0x1
    80002d1e:	c02080e7          	jalr	-1022(ra) # 8000391c <releasesleep>
}
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6902                	ld	s2,0(sp)
    80002d2a:	6105                	addi	sp,sp,32
    80002d2c:	8082                	ret
    panic("iunlock");
    80002d2e:	00006517          	auipc	a0,0x6
    80002d32:	9d250513          	addi	a0,a0,-1582 # 80008700 <syscall_name+0x1a8>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	f50080e7          	jalr	-176(ra) # 80005c86 <panic>

0000000080002d3e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d3e:	7179                	addi	sp,sp,-48
    80002d40:	f406                	sd	ra,40(sp)
    80002d42:	f022                	sd	s0,32(sp)
    80002d44:	ec26                	sd	s1,24(sp)
    80002d46:	e84a                	sd	s2,16(sp)
    80002d48:	e44e                	sd	s3,8(sp)
    80002d4a:	e052                	sd	s4,0(sp)
    80002d4c:	1800                	addi	s0,sp,48
    80002d4e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d50:	05050493          	addi	s1,a0,80
    80002d54:	08050913          	addi	s2,a0,128
    80002d58:	a021                	j	80002d60 <itrunc+0x22>
    80002d5a:	0491                	addi	s1,s1,4
    80002d5c:	01248d63          	beq	s1,s2,80002d76 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d60:	408c                	lw	a1,0(s1)
    80002d62:	dde5                	beqz	a1,80002d5a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	8fc080e7          	jalr	-1796(ra) # 80002664 <bfree>
      ip->addrs[i] = 0;
    80002d70:	0004a023          	sw	zero,0(s1)
    80002d74:	b7dd                	j	80002d5a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d76:	0809a583          	lw	a1,128(s3)
    80002d7a:	e185                	bnez	a1,80002d9a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d7c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d80:	854e                	mv	a0,s3
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	de2080e7          	jalr	-542(ra) # 80002b64 <iupdate>
}
    80002d8a:	70a2                	ld	ra,40(sp)
    80002d8c:	7402                	ld	s0,32(sp)
    80002d8e:	64e2                	ld	s1,24(sp)
    80002d90:	6942                	ld	s2,16(sp)
    80002d92:	69a2                	ld	s3,8(sp)
    80002d94:	6a02                	ld	s4,0(sp)
    80002d96:	6145                	addi	sp,sp,48
    80002d98:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	fffff097          	auipc	ra,0xfffff
    80002da2:	682080e7          	jalr	1666(ra) # 80002420 <bread>
    80002da6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002da8:	05850493          	addi	s1,a0,88
    80002dac:	45850913          	addi	s2,a0,1112
    80002db0:	a021                	j	80002db8 <itrunc+0x7a>
    80002db2:	0491                	addi	s1,s1,4
    80002db4:	01248b63          	beq	s1,s2,80002dca <itrunc+0x8c>
      if(a[j])
    80002db8:	408c                	lw	a1,0(s1)
    80002dba:	dde5                	beqz	a1,80002db2 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002dbc:	0009a503          	lw	a0,0(s3)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	8a4080e7          	jalr	-1884(ra) # 80002664 <bfree>
    80002dc8:	b7ed                	j	80002db2 <itrunc+0x74>
    brelse(bp);
    80002dca:	8552                	mv	a0,s4
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	784080e7          	jalr	1924(ra) # 80002550 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dd4:	0809a583          	lw	a1,128(s3)
    80002dd8:	0009a503          	lw	a0,0(s3)
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	888080e7          	jalr	-1912(ra) # 80002664 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002de4:	0809a023          	sw	zero,128(s3)
    80002de8:	bf51                	j	80002d7c <itrunc+0x3e>

0000000080002dea <iput>:
{
    80002dea:	1101                	addi	sp,sp,-32
    80002dec:	ec06                	sd	ra,24(sp)
    80002dee:	e822                	sd	s0,16(sp)
    80002df0:	e426                	sd	s1,8(sp)
    80002df2:	e04a                	sd	s2,0(sp)
    80002df4:	1000                	addi	s0,sp,32
    80002df6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002df8:	00014517          	auipc	a0,0x14
    80002dfc:	3c050513          	addi	a0,a0,960 # 800171b8 <itable>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	3be080e7          	jalr	958(ra) # 800061be <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e08:	4498                	lw	a4,8(s1)
    80002e0a:	4785                	li	a5,1
    80002e0c:	02f70363          	beq	a4,a5,80002e32 <iput+0x48>
  ip->ref--;
    80002e10:	449c                	lw	a5,8(s1)
    80002e12:	37fd                	addiw	a5,a5,-1
    80002e14:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e16:	00014517          	auipc	a0,0x14
    80002e1a:	3a250513          	addi	a0,a0,930 # 800171b8 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	454080e7          	jalr	1108(ra) # 80006272 <release>
}
    80002e26:	60e2                	ld	ra,24(sp)
    80002e28:	6442                	ld	s0,16(sp)
    80002e2a:	64a2                	ld	s1,8(sp)
    80002e2c:	6902                	ld	s2,0(sp)
    80002e2e:	6105                	addi	sp,sp,32
    80002e30:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e32:	40bc                	lw	a5,64(s1)
    80002e34:	dff1                	beqz	a5,80002e10 <iput+0x26>
    80002e36:	04a49783          	lh	a5,74(s1)
    80002e3a:	fbf9                	bnez	a5,80002e10 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e3c:	01048913          	addi	s2,s1,16
    80002e40:	854a                	mv	a0,s2
    80002e42:	00001097          	auipc	ra,0x1
    80002e46:	a84080e7          	jalr	-1404(ra) # 800038c6 <acquiresleep>
    release(&itable.lock);
    80002e4a:	00014517          	auipc	a0,0x14
    80002e4e:	36e50513          	addi	a0,a0,878 # 800171b8 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	420080e7          	jalr	1056(ra) # 80006272 <release>
    itrunc(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	ee2080e7          	jalr	-286(ra) # 80002d3e <itrunc>
    ip->type = 0;
    80002e64:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	cfa080e7          	jalr	-774(ra) # 80002b64 <iupdate>
    ip->valid = 0;
    80002e72:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e76:	854a                	mv	a0,s2
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	aa4080e7          	jalr	-1372(ra) # 8000391c <releasesleep>
    acquire(&itable.lock);
    80002e80:	00014517          	auipc	a0,0x14
    80002e84:	33850513          	addi	a0,a0,824 # 800171b8 <itable>
    80002e88:	00003097          	auipc	ra,0x3
    80002e8c:	336080e7          	jalr	822(ra) # 800061be <acquire>
    80002e90:	b741                	j	80002e10 <iput+0x26>

0000000080002e92 <iunlockput>:
{
    80002e92:	1101                	addi	sp,sp,-32
    80002e94:	ec06                	sd	ra,24(sp)
    80002e96:	e822                	sd	s0,16(sp)
    80002e98:	e426                	sd	s1,8(sp)
    80002e9a:	1000                	addi	s0,sp,32
    80002e9c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e9e:	00000097          	auipc	ra,0x0
    80002ea2:	e54080e7          	jalr	-428(ra) # 80002cf2 <iunlock>
  iput(ip);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	f42080e7          	jalr	-190(ra) # 80002dea <iput>
}
    80002eb0:	60e2                	ld	ra,24(sp)
    80002eb2:	6442                	ld	s0,16(sp)
    80002eb4:	64a2                	ld	s1,8(sp)
    80002eb6:	6105                	addi	sp,sp,32
    80002eb8:	8082                	ret

0000000080002eba <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002eba:	1141                	addi	sp,sp,-16
    80002ebc:	e422                	sd	s0,8(sp)
    80002ebe:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ec0:	411c                	lw	a5,0(a0)
    80002ec2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ec4:	415c                	lw	a5,4(a0)
    80002ec6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ec8:	04451783          	lh	a5,68(a0)
    80002ecc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ed0:	04a51783          	lh	a5,74(a0)
    80002ed4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ed8:	04c56783          	lwu	a5,76(a0)
    80002edc:	e99c                	sd	a5,16(a1)
}
    80002ede:	6422                	ld	s0,8(sp)
    80002ee0:	0141                	addi	sp,sp,16
    80002ee2:	8082                	ret

0000000080002ee4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee4:	457c                	lw	a5,76(a0)
    80002ee6:	0ed7e963          	bltu	a5,a3,80002fd8 <readi+0xf4>
{
    80002eea:	7159                	addi	sp,sp,-112
    80002eec:	f486                	sd	ra,104(sp)
    80002eee:	f0a2                	sd	s0,96(sp)
    80002ef0:	eca6                	sd	s1,88(sp)
    80002ef2:	e8ca                	sd	s2,80(sp)
    80002ef4:	e4ce                	sd	s3,72(sp)
    80002ef6:	e0d2                	sd	s4,64(sp)
    80002ef8:	fc56                	sd	s5,56(sp)
    80002efa:	f85a                	sd	s6,48(sp)
    80002efc:	f45e                	sd	s7,40(sp)
    80002efe:	f062                	sd	s8,32(sp)
    80002f00:	ec66                	sd	s9,24(sp)
    80002f02:	e86a                	sd	s10,16(sp)
    80002f04:	e46e                	sd	s11,8(sp)
    80002f06:	1880                	addi	s0,sp,112
    80002f08:	8b2a                	mv	s6,a0
    80002f0a:	8bae                	mv	s7,a1
    80002f0c:	8a32                	mv	s4,a2
    80002f0e:	84b6                	mv	s1,a3
    80002f10:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f12:	9f35                	addw	a4,a4,a3
    return 0;
    80002f14:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f16:	0ad76063          	bltu	a4,a3,80002fb6 <readi+0xd2>
  if(off + n > ip->size)
    80002f1a:	00e7f463          	bgeu	a5,a4,80002f22 <readi+0x3e>
    n = ip->size - off;
    80002f1e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f22:	0a0a8963          	beqz	s5,80002fd4 <readi+0xf0>
    80002f26:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f2c:	5c7d                	li	s8,-1
    80002f2e:	a82d                	j	80002f68 <readi+0x84>
    80002f30:	020d1d93          	slli	s11,s10,0x20
    80002f34:	020ddd93          	srli	s11,s11,0x20
    80002f38:	05890613          	addi	a2,s2,88
    80002f3c:	86ee                	mv	a3,s11
    80002f3e:	963a                	add	a2,a2,a4
    80002f40:	85d2                	mv	a1,s4
    80002f42:	855e                	mv	a0,s7
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	a60080e7          	jalr	-1440(ra) # 800019a4 <either_copyout>
    80002f4c:	05850d63          	beq	a0,s8,80002fa6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f50:	854a                	mv	a0,s2
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	5fe080e7          	jalr	1534(ra) # 80002550 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5a:	013d09bb          	addw	s3,s10,s3
    80002f5e:	009d04bb          	addw	s1,s10,s1
    80002f62:	9a6e                	add	s4,s4,s11
    80002f64:	0559f763          	bgeu	s3,s5,80002fb2 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f68:	00a4d59b          	srliw	a1,s1,0xa
    80002f6c:	855a                	mv	a0,s6
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	8a4080e7          	jalr	-1884(ra) # 80002812 <bmap>
    80002f76:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f7a:	cd85                	beqz	a1,80002fb2 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f7c:	000b2503          	lw	a0,0(s6)
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	4a0080e7          	jalr	1184(ra) # 80002420 <bread>
    80002f88:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8a:	3ff4f713          	andi	a4,s1,1023
    80002f8e:	40ec87bb          	subw	a5,s9,a4
    80002f92:	413a86bb          	subw	a3,s5,s3
    80002f96:	8d3e                	mv	s10,a5
    80002f98:	2781                	sext.w	a5,a5
    80002f9a:	0006861b          	sext.w	a2,a3
    80002f9e:	f8f679e3          	bgeu	a2,a5,80002f30 <readi+0x4c>
    80002fa2:	8d36                	mv	s10,a3
    80002fa4:	b771                	j	80002f30 <readi+0x4c>
      brelse(bp);
    80002fa6:	854a                	mv	a0,s2
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	5a8080e7          	jalr	1448(ra) # 80002550 <brelse>
      tot = -1;
    80002fb0:	59fd                	li	s3,-1
  }
  return tot;
    80002fb2:	0009851b          	sext.w	a0,s3
}
    80002fb6:	70a6                	ld	ra,104(sp)
    80002fb8:	7406                	ld	s0,96(sp)
    80002fba:	64e6                	ld	s1,88(sp)
    80002fbc:	6946                	ld	s2,80(sp)
    80002fbe:	69a6                	ld	s3,72(sp)
    80002fc0:	6a06                	ld	s4,64(sp)
    80002fc2:	7ae2                	ld	s5,56(sp)
    80002fc4:	7b42                	ld	s6,48(sp)
    80002fc6:	7ba2                	ld	s7,40(sp)
    80002fc8:	7c02                	ld	s8,32(sp)
    80002fca:	6ce2                	ld	s9,24(sp)
    80002fcc:	6d42                	ld	s10,16(sp)
    80002fce:	6da2                	ld	s11,8(sp)
    80002fd0:	6165                	addi	sp,sp,112
    80002fd2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd4:	89d6                	mv	s3,s5
    80002fd6:	bff1                	j	80002fb2 <readi+0xce>
    return 0;
    80002fd8:	4501                	li	a0,0
}
    80002fda:	8082                	ret

0000000080002fdc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fdc:	457c                	lw	a5,76(a0)
    80002fde:	10d7e863          	bltu	a5,a3,800030ee <writei+0x112>
{
    80002fe2:	7159                	addi	sp,sp,-112
    80002fe4:	f486                	sd	ra,104(sp)
    80002fe6:	f0a2                	sd	s0,96(sp)
    80002fe8:	eca6                	sd	s1,88(sp)
    80002fea:	e8ca                	sd	s2,80(sp)
    80002fec:	e4ce                	sd	s3,72(sp)
    80002fee:	e0d2                	sd	s4,64(sp)
    80002ff0:	fc56                	sd	s5,56(sp)
    80002ff2:	f85a                	sd	s6,48(sp)
    80002ff4:	f45e                	sd	s7,40(sp)
    80002ff6:	f062                	sd	s8,32(sp)
    80002ff8:	ec66                	sd	s9,24(sp)
    80002ffa:	e86a                	sd	s10,16(sp)
    80002ffc:	e46e                	sd	s11,8(sp)
    80002ffe:	1880                	addi	s0,sp,112
    80003000:	8aaa                	mv	s5,a0
    80003002:	8bae                	mv	s7,a1
    80003004:	8a32                	mv	s4,a2
    80003006:	8936                	mv	s2,a3
    80003008:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000300a:	00e687bb          	addw	a5,a3,a4
    8000300e:	0ed7e263          	bltu	a5,a3,800030f2 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003012:	00043737          	lui	a4,0x43
    80003016:	0ef76063          	bltu	a4,a5,800030f6 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000301a:	0c0b0863          	beqz	s6,800030ea <writei+0x10e>
    8000301e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003020:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003024:	5c7d                	li	s8,-1
    80003026:	a091                	j	8000306a <writei+0x8e>
    80003028:	020d1d93          	slli	s11,s10,0x20
    8000302c:	020ddd93          	srli	s11,s11,0x20
    80003030:	05848513          	addi	a0,s1,88
    80003034:	86ee                	mv	a3,s11
    80003036:	8652                	mv	a2,s4
    80003038:	85de                	mv	a1,s7
    8000303a:	953a                	add	a0,a0,a4
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	9be080e7          	jalr	-1602(ra) # 800019fa <either_copyin>
    80003044:	07850263          	beq	a0,s8,800030a8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003048:	8526                	mv	a0,s1
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	75e080e7          	jalr	1886(ra) # 800037a8 <log_write>
    brelse(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	4fc080e7          	jalr	1276(ra) # 80002550 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305c:	013d09bb          	addw	s3,s10,s3
    80003060:	012d093b          	addw	s2,s10,s2
    80003064:	9a6e                	add	s4,s4,s11
    80003066:	0569f663          	bgeu	s3,s6,800030b2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000306a:	00a9559b          	srliw	a1,s2,0xa
    8000306e:	8556                	mv	a0,s5
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	7a2080e7          	jalr	1954(ra) # 80002812 <bmap>
    80003078:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000307c:	c99d                	beqz	a1,800030b2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000307e:	000aa503          	lw	a0,0(s5)
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	39e080e7          	jalr	926(ra) # 80002420 <bread>
    8000308a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308c:	3ff97713          	andi	a4,s2,1023
    80003090:	40ec87bb          	subw	a5,s9,a4
    80003094:	413b06bb          	subw	a3,s6,s3
    80003098:	8d3e                	mv	s10,a5
    8000309a:	2781                	sext.w	a5,a5
    8000309c:	0006861b          	sext.w	a2,a3
    800030a0:	f8f674e3          	bgeu	a2,a5,80003028 <writei+0x4c>
    800030a4:	8d36                	mv	s10,a3
    800030a6:	b749                	j	80003028 <writei+0x4c>
      brelse(bp);
    800030a8:	8526                	mv	a0,s1
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	4a6080e7          	jalr	1190(ra) # 80002550 <brelse>
  }

  if(off > ip->size)
    800030b2:	04caa783          	lw	a5,76(s5)
    800030b6:	0127f463          	bgeu	a5,s2,800030be <writei+0xe2>
    ip->size = off;
    800030ba:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030be:	8556                	mv	a0,s5
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	aa4080e7          	jalr	-1372(ra) # 80002b64 <iupdate>

  return tot;
    800030c8:	0009851b          	sext.w	a0,s3
}
    800030cc:	70a6                	ld	ra,104(sp)
    800030ce:	7406                	ld	s0,96(sp)
    800030d0:	64e6                	ld	s1,88(sp)
    800030d2:	6946                	ld	s2,80(sp)
    800030d4:	69a6                	ld	s3,72(sp)
    800030d6:	6a06                	ld	s4,64(sp)
    800030d8:	7ae2                	ld	s5,56(sp)
    800030da:	7b42                	ld	s6,48(sp)
    800030dc:	7ba2                	ld	s7,40(sp)
    800030de:	7c02                	ld	s8,32(sp)
    800030e0:	6ce2                	ld	s9,24(sp)
    800030e2:	6d42                	ld	s10,16(sp)
    800030e4:	6da2                	ld	s11,8(sp)
    800030e6:	6165                	addi	sp,sp,112
    800030e8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ea:	89da                	mv	s3,s6
    800030ec:	bfc9                	j	800030be <writei+0xe2>
    return -1;
    800030ee:	557d                	li	a0,-1
}
    800030f0:	8082                	ret
    return -1;
    800030f2:	557d                	li	a0,-1
    800030f4:	bfe1                	j	800030cc <writei+0xf0>
    return -1;
    800030f6:	557d                	li	a0,-1
    800030f8:	bfd1                	j	800030cc <writei+0xf0>

00000000800030fa <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030fa:	1141                	addi	sp,sp,-16
    800030fc:	e406                	sd	ra,8(sp)
    800030fe:	e022                	sd	s0,0(sp)
    80003100:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003102:	4639                	li	a2,14
    80003104:	ffffd097          	auipc	ra,0xffffd
    80003108:	1aa080e7          	jalr	426(ra) # 800002ae <strncmp>
}
    8000310c:	60a2                	ld	ra,8(sp)
    8000310e:	6402                	ld	s0,0(sp)
    80003110:	0141                	addi	sp,sp,16
    80003112:	8082                	ret

0000000080003114 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003114:	7139                	addi	sp,sp,-64
    80003116:	fc06                	sd	ra,56(sp)
    80003118:	f822                	sd	s0,48(sp)
    8000311a:	f426                	sd	s1,40(sp)
    8000311c:	f04a                	sd	s2,32(sp)
    8000311e:	ec4e                	sd	s3,24(sp)
    80003120:	e852                	sd	s4,16(sp)
    80003122:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003124:	04451703          	lh	a4,68(a0)
    80003128:	4785                	li	a5,1
    8000312a:	00f71a63          	bne	a4,a5,8000313e <dirlookup+0x2a>
    8000312e:	892a                	mv	s2,a0
    80003130:	89ae                	mv	s3,a1
    80003132:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003134:	457c                	lw	a5,76(a0)
    80003136:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003138:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313a:	e79d                	bnez	a5,80003168 <dirlookup+0x54>
    8000313c:	a8a5                	j	800031b4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	5ca50513          	addi	a0,a0,1482 # 80008708 <syscall_name+0x1b0>
    80003146:	00003097          	auipc	ra,0x3
    8000314a:	b40080e7          	jalr	-1216(ra) # 80005c86 <panic>
      panic("dirlookup read");
    8000314e:	00005517          	auipc	a0,0x5
    80003152:	5d250513          	addi	a0,a0,1490 # 80008720 <syscall_name+0x1c8>
    80003156:	00003097          	auipc	ra,0x3
    8000315a:	b30080e7          	jalr	-1232(ra) # 80005c86 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000315e:	24c1                	addiw	s1,s1,16
    80003160:	04c92783          	lw	a5,76(s2)
    80003164:	04f4f763          	bgeu	s1,a5,800031b2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003168:	4741                	li	a4,16
    8000316a:	86a6                	mv	a3,s1
    8000316c:	fc040613          	addi	a2,s0,-64
    80003170:	4581                	li	a1,0
    80003172:	854a                	mv	a0,s2
    80003174:	00000097          	auipc	ra,0x0
    80003178:	d70080e7          	jalr	-656(ra) # 80002ee4 <readi>
    8000317c:	47c1                	li	a5,16
    8000317e:	fcf518e3          	bne	a0,a5,8000314e <dirlookup+0x3a>
    if(de.inum == 0)
    80003182:	fc045783          	lhu	a5,-64(s0)
    80003186:	dfe1                	beqz	a5,8000315e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003188:	fc240593          	addi	a1,s0,-62
    8000318c:	854e                	mv	a0,s3
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	f6c080e7          	jalr	-148(ra) # 800030fa <namecmp>
    80003196:	f561                	bnez	a0,8000315e <dirlookup+0x4a>
      if(poff)
    80003198:	000a0463          	beqz	s4,800031a0 <dirlookup+0x8c>
        *poff = off;
    8000319c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031a0:	fc045583          	lhu	a1,-64(s0)
    800031a4:	00092503          	lw	a0,0(s2)
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	754080e7          	jalr	1876(ra) # 800028fc <iget>
    800031b0:	a011                	j	800031b4 <dirlookup+0xa0>
  return 0;
    800031b2:	4501                	li	a0,0
}
    800031b4:	70e2                	ld	ra,56(sp)
    800031b6:	7442                	ld	s0,48(sp)
    800031b8:	74a2                	ld	s1,40(sp)
    800031ba:	7902                	ld	s2,32(sp)
    800031bc:	69e2                	ld	s3,24(sp)
    800031be:	6a42                	ld	s4,16(sp)
    800031c0:	6121                	addi	sp,sp,64
    800031c2:	8082                	ret

00000000800031c4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031c4:	711d                	addi	sp,sp,-96
    800031c6:	ec86                	sd	ra,88(sp)
    800031c8:	e8a2                	sd	s0,80(sp)
    800031ca:	e4a6                	sd	s1,72(sp)
    800031cc:	e0ca                	sd	s2,64(sp)
    800031ce:	fc4e                	sd	s3,56(sp)
    800031d0:	f852                	sd	s4,48(sp)
    800031d2:	f456                	sd	s5,40(sp)
    800031d4:	f05a                	sd	s6,32(sp)
    800031d6:	ec5e                	sd	s7,24(sp)
    800031d8:	e862                	sd	s8,16(sp)
    800031da:	e466                	sd	s9,8(sp)
    800031dc:	1080                	addi	s0,sp,96
    800031de:	84aa                	mv	s1,a0
    800031e0:	8b2e                	mv	s6,a1
    800031e2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031e4:	00054703          	lbu	a4,0(a0)
    800031e8:	02f00793          	li	a5,47
    800031ec:	02f70263          	beq	a4,a5,80003210 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031f0:	ffffe097          	auipc	ra,0xffffe
    800031f4:	cc6080e7          	jalr	-826(ra) # 80000eb6 <myproc>
    800031f8:	15053503          	ld	a0,336(a0)
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	9f6080e7          	jalr	-1546(ra) # 80002bf2 <idup>
    80003204:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003206:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000320a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000320c:	4b85                	li	s7,1
    8000320e:	a875                	j	800032ca <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003210:	4585                	li	a1,1
    80003212:	4505                	li	a0,1
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	6e8080e7          	jalr	1768(ra) # 800028fc <iget>
    8000321c:	8a2a                	mv	s4,a0
    8000321e:	b7e5                	j	80003206 <namex+0x42>
      iunlockput(ip);
    80003220:	8552                	mv	a0,s4
    80003222:	00000097          	auipc	ra,0x0
    80003226:	c70080e7          	jalr	-912(ra) # 80002e92 <iunlockput>
      return 0;
    8000322a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000322c:	8552                	mv	a0,s4
    8000322e:	60e6                	ld	ra,88(sp)
    80003230:	6446                	ld	s0,80(sp)
    80003232:	64a6                	ld	s1,72(sp)
    80003234:	6906                	ld	s2,64(sp)
    80003236:	79e2                	ld	s3,56(sp)
    80003238:	7a42                	ld	s4,48(sp)
    8000323a:	7aa2                	ld	s5,40(sp)
    8000323c:	7b02                	ld	s6,32(sp)
    8000323e:	6be2                	ld	s7,24(sp)
    80003240:	6c42                	ld	s8,16(sp)
    80003242:	6ca2                	ld	s9,8(sp)
    80003244:	6125                	addi	sp,sp,96
    80003246:	8082                	ret
      iunlock(ip);
    80003248:	8552                	mv	a0,s4
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	aa8080e7          	jalr	-1368(ra) # 80002cf2 <iunlock>
      return ip;
    80003252:	bfe9                	j	8000322c <namex+0x68>
      iunlockput(ip);
    80003254:	8552                	mv	a0,s4
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	c3c080e7          	jalr	-964(ra) # 80002e92 <iunlockput>
      return 0;
    8000325e:	8a4e                	mv	s4,s3
    80003260:	b7f1                	j	8000322c <namex+0x68>
  len = path - s;
    80003262:	40998633          	sub	a2,s3,s1
    80003266:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000326a:	099c5863          	bge	s8,s9,800032fa <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000326e:	4639                	li	a2,14
    80003270:	85a6                	mv	a1,s1
    80003272:	8556                	mv	a0,s5
    80003274:	ffffd097          	auipc	ra,0xffffd
    80003278:	fc6080e7          	jalr	-58(ra) # 8000023a <memmove>
    8000327c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	01279763          	bne	a5,s2,80003290 <namex+0xcc>
    path++;
    80003286:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003288:	0004c783          	lbu	a5,0(s1)
    8000328c:	ff278de3          	beq	a5,s2,80003286 <namex+0xc2>
    ilock(ip);
    80003290:	8552                	mv	a0,s4
    80003292:	00000097          	auipc	ra,0x0
    80003296:	99e080e7          	jalr	-1634(ra) # 80002c30 <ilock>
    if(ip->type != T_DIR){
    8000329a:	044a1783          	lh	a5,68(s4)
    8000329e:	f97791e3          	bne	a5,s7,80003220 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032a2:	000b0563          	beqz	s6,800032ac <namex+0xe8>
    800032a6:	0004c783          	lbu	a5,0(s1)
    800032aa:	dfd9                	beqz	a5,80003248 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032ac:	4601                	li	a2,0
    800032ae:	85d6                	mv	a1,s5
    800032b0:	8552                	mv	a0,s4
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	e62080e7          	jalr	-414(ra) # 80003114 <dirlookup>
    800032ba:	89aa                	mv	s3,a0
    800032bc:	dd41                	beqz	a0,80003254 <namex+0x90>
    iunlockput(ip);
    800032be:	8552                	mv	a0,s4
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	bd2080e7          	jalr	-1070(ra) # 80002e92 <iunlockput>
    ip = next;
    800032c8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032ca:	0004c783          	lbu	a5,0(s1)
    800032ce:	01279763          	bne	a5,s2,800032dc <namex+0x118>
    path++;
    800032d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d4:	0004c783          	lbu	a5,0(s1)
    800032d8:	ff278de3          	beq	a5,s2,800032d2 <namex+0x10e>
  if(*path == 0)
    800032dc:	cb9d                	beqz	a5,80003312 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032de:	0004c783          	lbu	a5,0(s1)
    800032e2:	89a6                	mv	s3,s1
  len = path - s;
    800032e4:	4c81                	li	s9,0
    800032e6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032e8:	01278963          	beq	a5,s2,800032fa <namex+0x136>
    800032ec:	dbbd                	beqz	a5,80003262 <namex+0x9e>
    path++;
    800032ee:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032f0:	0009c783          	lbu	a5,0(s3)
    800032f4:	ff279ce3          	bne	a5,s2,800032ec <namex+0x128>
    800032f8:	b7ad                	j	80003262 <namex+0x9e>
    memmove(name, s, len);
    800032fa:	2601                	sext.w	a2,a2
    800032fc:	85a6                	mv	a1,s1
    800032fe:	8556                	mv	a0,s5
    80003300:	ffffd097          	auipc	ra,0xffffd
    80003304:	f3a080e7          	jalr	-198(ra) # 8000023a <memmove>
    name[len] = 0;
    80003308:	9cd6                	add	s9,s9,s5
    8000330a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000330e:	84ce                	mv	s1,s3
    80003310:	b7bd                	j	8000327e <namex+0xba>
  if(nameiparent){
    80003312:	f00b0de3          	beqz	s6,8000322c <namex+0x68>
    iput(ip);
    80003316:	8552                	mv	a0,s4
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	ad2080e7          	jalr	-1326(ra) # 80002dea <iput>
    return 0;
    80003320:	4a01                	li	s4,0
    80003322:	b729                	j	8000322c <namex+0x68>

0000000080003324 <dirlink>:
{
    80003324:	7139                	addi	sp,sp,-64
    80003326:	fc06                	sd	ra,56(sp)
    80003328:	f822                	sd	s0,48(sp)
    8000332a:	f426                	sd	s1,40(sp)
    8000332c:	f04a                	sd	s2,32(sp)
    8000332e:	ec4e                	sd	s3,24(sp)
    80003330:	e852                	sd	s4,16(sp)
    80003332:	0080                	addi	s0,sp,64
    80003334:	892a                	mv	s2,a0
    80003336:	8a2e                	mv	s4,a1
    80003338:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000333a:	4601                	li	a2,0
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	dd8080e7          	jalr	-552(ra) # 80003114 <dirlookup>
    80003344:	e93d                	bnez	a0,800033ba <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003346:	04c92483          	lw	s1,76(s2)
    8000334a:	c49d                	beqz	s1,80003378 <dirlink+0x54>
    8000334c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334e:	4741                	li	a4,16
    80003350:	86a6                	mv	a3,s1
    80003352:	fc040613          	addi	a2,s0,-64
    80003356:	4581                	li	a1,0
    80003358:	854a                	mv	a0,s2
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	b8a080e7          	jalr	-1142(ra) # 80002ee4 <readi>
    80003362:	47c1                	li	a5,16
    80003364:	06f51163          	bne	a0,a5,800033c6 <dirlink+0xa2>
    if(de.inum == 0)
    80003368:	fc045783          	lhu	a5,-64(s0)
    8000336c:	c791                	beqz	a5,80003378 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000336e:	24c1                	addiw	s1,s1,16
    80003370:	04c92783          	lw	a5,76(s2)
    80003374:	fcf4ede3          	bltu	s1,a5,8000334e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003378:	4639                	li	a2,14
    8000337a:	85d2                	mv	a1,s4
    8000337c:	fc240513          	addi	a0,s0,-62
    80003380:	ffffd097          	auipc	ra,0xffffd
    80003384:	f6a080e7          	jalr	-150(ra) # 800002ea <strncpy>
  de.inum = inum;
    80003388:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000338c:	4741                	li	a4,16
    8000338e:	86a6                	mv	a3,s1
    80003390:	fc040613          	addi	a2,s0,-64
    80003394:	4581                	li	a1,0
    80003396:	854a                	mv	a0,s2
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	c44080e7          	jalr	-956(ra) # 80002fdc <writei>
    800033a0:	1541                	addi	a0,a0,-16
    800033a2:	00a03533          	snez	a0,a0
    800033a6:	40a00533          	neg	a0,a0
}
    800033aa:	70e2                	ld	ra,56(sp)
    800033ac:	7442                	ld	s0,48(sp)
    800033ae:	74a2                	ld	s1,40(sp)
    800033b0:	7902                	ld	s2,32(sp)
    800033b2:	69e2                	ld	s3,24(sp)
    800033b4:	6a42                	ld	s4,16(sp)
    800033b6:	6121                	addi	sp,sp,64
    800033b8:	8082                	ret
    iput(ip);
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	a30080e7          	jalr	-1488(ra) # 80002dea <iput>
    return -1;
    800033c2:	557d                	li	a0,-1
    800033c4:	b7dd                	j	800033aa <dirlink+0x86>
      panic("dirlink read");
    800033c6:	00005517          	auipc	a0,0x5
    800033ca:	36a50513          	addi	a0,a0,874 # 80008730 <syscall_name+0x1d8>
    800033ce:	00003097          	auipc	ra,0x3
    800033d2:	8b8080e7          	jalr	-1864(ra) # 80005c86 <panic>

00000000800033d6 <namei>:

struct inode*
namei(char *path)
{
    800033d6:	1101                	addi	sp,sp,-32
    800033d8:	ec06                	sd	ra,24(sp)
    800033da:	e822                	sd	s0,16(sp)
    800033dc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033de:	fe040613          	addi	a2,s0,-32
    800033e2:	4581                	li	a1,0
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	de0080e7          	jalr	-544(ra) # 800031c4 <namex>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	6105                	addi	sp,sp,32
    800033f2:	8082                	ret

00000000800033f4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033f4:	1141                	addi	sp,sp,-16
    800033f6:	e406                	sd	ra,8(sp)
    800033f8:	e022                	sd	s0,0(sp)
    800033fa:	0800                	addi	s0,sp,16
    800033fc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033fe:	4585                	li	a1,1
    80003400:	00000097          	auipc	ra,0x0
    80003404:	dc4080e7          	jalr	-572(ra) # 800031c4 <namex>
}
    80003408:	60a2                	ld	ra,8(sp)
    8000340a:	6402                	ld	s0,0(sp)
    8000340c:	0141                	addi	sp,sp,16
    8000340e:	8082                	ret

0000000080003410 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003410:	1101                	addi	sp,sp,-32
    80003412:	ec06                	sd	ra,24(sp)
    80003414:	e822                	sd	s0,16(sp)
    80003416:	e426                	sd	s1,8(sp)
    80003418:	e04a                	sd	s2,0(sp)
    8000341a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000341c:	00016917          	auipc	s2,0x16
    80003420:	84490913          	addi	s2,s2,-1980 # 80018c60 <log>
    80003424:	01892583          	lw	a1,24(s2)
    80003428:	02892503          	lw	a0,40(s2)
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	ff4080e7          	jalr	-12(ra) # 80002420 <bread>
    80003434:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003436:	02c92603          	lw	a2,44(s2)
    8000343a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000343c:	00c05f63          	blez	a2,8000345a <write_head+0x4a>
    80003440:	00016717          	auipc	a4,0x16
    80003444:	85070713          	addi	a4,a4,-1968 # 80018c90 <log+0x30>
    80003448:	87aa                	mv	a5,a0
    8000344a:	060a                	slli	a2,a2,0x2
    8000344c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000344e:	4314                	lw	a3,0(a4)
    80003450:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003452:	0711                	addi	a4,a4,4
    80003454:	0791                	addi	a5,a5,4
    80003456:	fec79ce3          	bne	a5,a2,8000344e <write_head+0x3e>
  }
  bwrite(buf);
    8000345a:	8526                	mv	a0,s1
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	0b6080e7          	jalr	182(ra) # 80002512 <bwrite>
  brelse(buf);
    80003464:	8526                	mv	a0,s1
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	0ea080e7          	jalr	234(ra) # 80002550 <brelse>
}
    8000346e:	60e2                	ld	ra,24(sp)
    80003470:	6442                	ld	s0,16(sp)
    80003472:	64a2                	ld	s1,8(sp)
    80003474:	6902                	ld	s2,0(sp)
    80003476:	6105                	addi	sp,sp,32
    80003478:	8082                	ret

000000008000347a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347a:	00016797          	auipc	a5,0x16
    8000347e:	8127a783          	lw	a5,-2030(a5) # 80018c8c <log+0x2c>
    80003482:	0af05d63          	blez	a5,8000353c <install_trans+0xc2>
{
    80003486:	7139                	addi	sp,sp,-64
    80003488:	fc06                	sd	ra,56(sp)
    8000348a:	f822                	sd	s0,48(sp)
    8000348c:	f426                	sd	s1,40(sp)
    8000348e:	f04a                	sd	s2,32(sp)
    80003490:	ec4e                	sd	s3,24(sp)
    80003492:	e852                	sd	s4,16(sp)
    80003494:	e456                	sd	s5,8(sp)
    80003496:	e05a                	sd	s6,0(sp)
    80003498:	0080                	addi	s0,sp,64
    8000349a:	8b2a                	mv	s6,a0
    8000349c:	00015a97          	auipc	s5,0x15
    800034a0:	7f4a8a93          	addi	s5,s5,2036 # 80018c90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a6:	00015997          	auipc	s3,0x15
    800034aa:	7ba98993          	addi	s3,s3,1978 # 80018c60 <log>
    800034ae:	a00d                	j	800034d0 <install_trans+0x56>
    brelse(lbuf);
    800034b0:	854a                	mv	a0,s2
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	09e080e7          	jalr	158(ra) # 80002550 <brelse>
    brelse(dbuf);
    800034ba:	8526                	mv	a0,s1
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	094080e7          	jalr	148(ra) # 80002550 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c4:	2a05                	addiw	s4,s4,1
    800034c6:	0a91                	addi	s5,s5,4
    800034c8:	02c9a783          	lw	a5,44(s3)
    800034cc:	04fa5e63          	bge	s4,a5,80003528 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034d0:	0189a583          	lw	a1,24(s3)
    800034d4:	014585bb          	addw	a1,a1,s4
    800034d8:	2585                	addiw	a1,a1,1
    800034da:	0289a503          	lw	a0,40(s3)
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	f42080e7          	jalr	-190(ra) # 80002420 <bread>
    800034e6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034e8:	000aa583          	lw	a1,0(s5)
    800034ec:	0289a503          	lw	a0,40(s3)
    800034f0:	fffff097          	auipc	ra,0xfffff
    800034f4:	f30080e7          	jalr	-208(ra) # 80002420 <bread>
    800034f8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034fa:	40000613          	li	a2,1024
    800034fe:	05890593          	addi	a1,s2,88
    80003502:	05850513          	addi	a0,a0,88
    80003506:	ffffd097          	auipc	ra,0xffffd
    8000350a:	d34080e7          	jalr	-716(ra) # 8000023a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000350e:	8526                	mv	a0,s1
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	002080e7          	jalr	2(ra) # 80002512 <bwrite>
    if(recovering == 0)
    80003518:	f80b1ce3          	bnez	s6,800034b0 <install_trans+0x36>
      bunpin(dbuf);
    8000351c:	8526                	mv	a0,s1
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	10a080e7          	jalr	266(ra) # 80002628 <bunpin>
    80003526:	b769                	j	800034b0 <install_trans+0x36>
}
    80003528:	70e2                	ld	ra,56(sp)
    8000352a:	7442                	ld	s0,48(sp)
    8000352c:	74a2                	ld	s1,40(sp)
    8000352e:	7902                	ld	s2,32(sp)
    80003530:	69e2                	ld	s3,24(sp)
    80003532:	6a42                	ld	s4,16(sp)
    80003534:	6aa2                	ld	s5,8(sp)
    80003536:	6b02                	ld	s6,0(sp)
    80003538:	6121                	addi	sp,sp,64
    8000353a:	8082                	ret
    8000353c:	8082                	ret

000000008000353e <initlog>:
{
    8000353e:	7179                	addi	sp,sp,-48
    80003540:	f406                	sd	ra,40(sp)
    80003542:	f022                	sd	s0,32(sp)
    80003544:	ec26                	sd	s1,24(sp)
    80003546:	e84a                	sd	s2,16(sp)
    80003548:	e44e                	sd	s3,8(sp)
    8000354a:	1800                	addi	s0,sp,48
    8000354c:	892a                	mv	s2,a0
    8000354e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003550:	00015497          	auipc	s1,0x15
    80003554:	71048493          	addi	s1,s1,1808 # 80018c60 <log>
    80003558:	00005597          	auipc	a1,0x5
    8000355c:	1e858593          	addi	a1,a1,488 # 80008740 <syscall_name+0x1e8>
    80003560:	8526                	mv	a0,s1
    80003562:	00003097          	auipc	ra,0x3
    80003566:	bcc080e7          	jalr	-1076(ra) # 8000612e <initlock>
  log.start = sb->logstart;
    8000356a:	0149a583          	lw	a1,20(s3)
    8000356e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003570:	0109a783          	lw	a5,16(s3)
    80003574:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003576:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000357a:	854a                	mv	a0,s2
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	ea4080e7          	jalr	-348(ra) # 80002420 <bread>
  log.lh.n = lh->n;
    80003584:	4d30                	lw	a2,88(a0)
    80003586:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	00c05f63          	blez	a2,800035a6 <initlog+0x68>
    8000358c:	87aa                	mv	a5,a0
    8000358e:	00015717          	auipc	a4,0x15
    80003592:	70270713          	addi	a4,a4,1794 # 80018c90 <log+0x30>
    80003596:	060a                	slli	a2,a2,0x2
    80003598:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000359a:	4ff4                	lw	a3,92(a5)
    8000359c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000359e:	0791                	addi	a5,a5,4
    800035a0:	0711                	addi	a4,a4,4
    800035a2:	fec79ce3          	bne	a5,a2,8000359a <initlog+0x5c>
  brelse(buf);
    800035a6:	fffff097          	auipc	ra,0xfffff
    800035aa:	faa080e7          	jalr	-86(ra) # 80002550 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ae:	4505                	li	a0,1
    800035b0:	00000097          	auipc	ra,0x0
    800035b4:	eca080e7          	jalr	-310(ra) # 8000347a <install_trans>
  log.lh.n = 0;
    800035b8:	00015797          	auipc	a5,0x15
    800035bc:	6c07aa23          	sw	zero,1748(a5) # 80018c8c <log+0x2c>
  write_head(); // clear the log
    800035c0:	00000097          	auipc	ra,0x0
    800035c4:	e50080e7          	jalr	-432(ra) # 80003410 <write_head>
}
    800035c8:	70a2                	ld	ra,40(sp)
    800035ca:	7402                	ld	s0,32(sp)
    800035cc:	64e2                	ld	s1,24(sp)
    800035ce:	6942                	ld	s2,16(sp)
    800035d0:	69a2                	ld	s3,8(sp)
    800035d2:	6145                	addi	sp,sp,48
    800035d4:	8082                	ret

00000000800035d6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035d6:	1101                	addi	sp,sp,-32
    800035d8:	ec06                	sd	ra,24(sp)
    800035da:	e822                	sd	s0,16(sp)
    800035dc:	e426                	sd	s1,8(sp)
    800035de:	e04a                	sd	s2,0(sp)
    800035e0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035e2:	00015517          	auipc	a0,0x15
    800035e6:	67e50513          	addi	a0,a0,1662 # 80018c60 <log>
    800035ea:	00003097          	auipc	ra,0x3
    800035ee:	bd4080e7          	jalr	-1068(ra) # 800061be <acquire>
  while(1){
    if(log.committing){
    800035f2:	00015497          	auipc	s1,0x15
    800035f6:	66e48493          	addi	s1,s1,1646 # 80018c60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fa:	4979                	li	s2,30
    800035fc:	a039                	j	8000360a <begin_op+0x34>
      sleep(&log, &log.lock);
    800035fe:	85a6                	mv	a1,s1
    80003600:	8526                	mv	a0,s1
    80003602:	ffffe097          	auipc	ra,0xffffe
    80003606:	f9a080e7          	jalr	-102(ra) # 8000159c <sleep>
    if(log.committing){
    8000360a:	50dc                	lw	a5,36(s1)
    8000360c:	fbed                	bnez	a5,800035fe <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000360e:	5098                	lw	a4,32(s1)
    80003610:	2705                	addiw	a4,a4,1
    80003612:	0027179b          	slliw	a5,a4,0x2
    80003616:	9fb9                	addw	a5,a5,a4
    80003618:	0017979b          	slliw	a5,a5,0x1
    8000361c:	54d4                	lw	a3,44(s1)
    8000361e:	9fb5                	addw	a5,a5,a3
    80003620:	00f95963          	bge	s2,a5,80003632 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003624:	85a6                	mv	a1,s1
    80003626:	8526                	mv	a0,s1
    80003628:	ffffe097          	auipc	ra,0xffffe
    8000362c:	f74080e7          	jalr	-140(ra) # 8000159c <sleep>
    80003630:	bfe9                	j	8000360a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003632:	00015517          	auipc	a0,0x15
    80003636:	62e50513          	addi	a0,a0,1582 # 80018c60 <log>
    8000363a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	c36080e7          	jalr	-970(ra) # 80006272 <release>
      break;
    }
  }
}
    80003644:	60e2                	ld	ra,24(sp)
    80003646:	6442                	ld	s0,16(sp)
    80003648:	64a2                	ld	s1,8(sp)
    8000364a:	6902                	ld	s2,0(sp)
    8000364c:	6105                	addi	sp,sp,32
    8000364e:	8082                	ret

0000000080003650 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003650:	7139                	addi	sp,sp,-64
    80003652:	fc06                	sd	ra,56(sp)
    80003654:	f822                	sd	s0,48(sp)
    80003656:	f426                	sd	s1,40(sp)
    80003658:	f04a                	sd	s2,32(sp)
    8000365a:	ec4e                	sd	s3,24(sp)
    8000365c:	e852                	sd	s4,16(sp)
    8000365e:	e456                	sd	s5,8(sp)
    80003660:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003662:	00015497          	auipc	s1,0x15
    80003666:	5fe48493          	addi	s1,s1,1534 # 80018c60 <log>
    8000366a:	8526                	mv	a0,s1
    8000366c:	00003097          	auipc	ra,0x3
    80003670:	b52080e7          	jalr	-1198(ra) # 800061be <acquire>
  log.outstanding -= 1;
    80003674:	509c                	lw	a5,32(s1)
    80003676:	37fd                	addiw	a5,a5,-1
    80003678:	0007891b          	sext.w	s2,a5
    8000367c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000367e:	50dc                	lw	a5,36(s1)
    80003680:	e7b9                	bnez	a5,800036ce <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003682:	04091e63          	bnez	s2,800036de <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003686:	00015497          	auipc	s1,0x15
    8000368a:	5da48493          	addi	s1,s1,1498 # 80018c60 <log>
    8000368e:	4785                	li	a5,1
    80003690:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003692:	8526                	mv	a0,s1
    80003694:	00003097          	auipc	ra,0x3
    80003698:	bde080e7          	jalr	-1058(ra) # 80006272 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000369c:	54dc                	lw	a5,44(s1)
    8000369e:	06f04763          	bgtz	a5,8000370c <end_op+0xbc>
    acquire(&log.lock);
    800036a2:	00015497          	auipc	s1,0x15
    800036a6:	5be48493          	addi	s1,s1,1470 # 80018c60 <log>
    800036aa:	8526                	mv	a0,s1
    800036ac:	00003097          	auipc	ra,0x3
    800036b0:	b12080e7          	jalr	-1262(ra) # 800061be <acquire>
    log.committing = 0;
    800036b4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036b8:	8526                	mv	a0,s1
    800036ba:	ffffe097          	auipc	ra,0xffffe
    800036be:	f46080e7          	jalr	-186(ra) # 80001600 <wakeup>
    release(&log.lock);
    800036c2:	8526                	mv	a0,s1
    800036c4:	00003097          	auipc	ra,0x3
    800036c8:	bae080e7          	jalr	-1106(ra) # 80006272 <release>
}
    800036cc:	a03d                	j	800036fa <end_op+0xaa>
    panic("log.committing");
    800036ce:	00005517          	auipc	a0,0x5
    800036d2:	07a50513          	addi	a0,a0,122 # 80008748 <syscall_name+0x1f0>
    800036d6:	00002097          	auipc	ra,0x2
    800036da:	5b0080e7          	jalr	1456(ra) # 80005c86 <panic>
    wakeup(&log);
    800036de:	00015497          	auipc	s1,0x15
    800036e2:	58248493          	addi	s1,s1,1410 # 80018c60 <log>
    800036e6:	8526                	mv	a0,s1
    800036e8:	ffffe097          	auipc	ra,0xffffe
    800036ec:	f18080e7          	jalr	-232(ra) # 80001600 <wakeup>
  release(&log.lock);
    800036f0:	8526                	mv	a0,s1
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	b80080e7          	jalr	-1152(ra) # 80006272 <release>
}
    800036fa:	70e2                	ld	ra,56(sp)
    800036fc:	7442                	ld	s0,48(sp)
    800036fe:	74a2                	ld	s1,40(sp)
    80003700:	7902                	ld	s2,32(sp)
    80003702:	69e2                	ld	s3,24(sp)
    80003704:	6a42                	ld	s4,16(sp)
    80003706:	6aa2                	ld	s5,8(sp)
    80003708:	6121                	addi	sp,sp,64
    8000370a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370c:	00015a97          	auipc	s5,0x15
    80003710:	584a8a93          	addi	s5,s5,1412 # 80018c90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003714:	00015a17          	auipc	s4,0x15
    80003718:	54ca0a13          	addi	s4,s4,1356 # 80018c60 <log>
    8000371c:	018a2583          	lw	a1,24(s4)
    80003720:	012585bb          	addw	a1,a1,s2
    80003724:	2585                	addiw	a1,a1,1
    80003726:	028a2503          	lw	a0,40(s4)
    8000372a:	fffff097          	auipc	ra,0xfffff
    8000372e:	cf6080e7          	jalr	-778(ra) # 80002420 <bread>
    80003732:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003734:	000aa583          	lw	a1,0(s5)
    80003738:	028a2503          	lw	a0,40(s4)
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	ce4080e7          	jalr	-796(ra) # 80002420 <bread>
    80003744:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003746:	40000613          	li	a2,1024
    8000374a:	05850593          	addi	a1,a0,88
    8000374e:	05848513          	addi	a0,s1,88
    80003752:	ffffd097          	auipc	ra,0xffffd
    80003756:	ae8080e7          	jalr	-1304(ra) # 8000023a <memmove>
    bwrite(to);  // write the log
    8000375a:	8526                	mv	a0,s1
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	db6080e7          	jalr	-586(ra) # 80002512 <bwrite>
    brelse(from);
    80003764:	854e                	mv	a0,s3
    80003766:	fffff097          	auipc	ra,0xfffff
    8000376a:	dea080e7          	jalr	-534(ra) # 80002550 <brelse>
    brelse(to);
    8000376e:	8526                	mv	a0,s1
    80003770:	fffff097          	auipc	ra,0xfffff
    80003774:	de0080e7          	jalr	-544(ra) # 80002550 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003778:	2905                	addiw	s2,s2,1
    8000377a:	0a91                	addi	s5,s5,4
    8000377c:	02ca2783          	lw	a5,44(s4)
    80003780:	f8f94ee3          	blt	s2,a5,8000371c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003784:	00000097          	auipc	ra,0x0
    80003788:	c8c080e7          	jalr	-884(ra) # 80003410 <write_head>
    install_trans(0); // Now install writes to home locations
    8000378c:	4501                	li	a0,0
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	cec080e7          	jalr	-788(ra) # 8000347a <install_trans>
    log.lh.n = 0;
    80003796:	00015797          	auipc	a5,0x15
    8000379a:	4e07ab23          	sw	zero,1270(a5) # 80018c8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	c72080e7          	jalr	-910(ra) # 80003410 <write_head>
    800037a6:	bdf5                	j	800036a2 <end_op+0x52>

00000000800037a8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a8:	1101                	addi	sp,sp,-32
    800037aa:	ec06                	sd	ra,24(sp)
    800037ac:	e822                	sd	s0,16(sp)
    800037ae:	e426                	sd	s1,8(sp)
    800037b0:	e04a                	sd	s2,0(sp)
    800037b2:	1000                	addi	s0,sp,32
    800037b4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b6:	00015917          	auipc	s2,0x15
    800037ba:	4aa90913          	addi	s2,s2,1194 # 80018c60 <log>
    800037be:	854a                	mv	a0,s2
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	9fe080e7          	jalr	-1538(ra) # 800061be <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c8:	02c92603          	lw	a2,44(s2)
    800037cc:	47f5                	li	a5,29
    800037ce:	06c7c563          	blt	a5,a2,80003838 <log_write+0x90>
    800037d2:	00015797          	auipc	a5,0x15
    800037d6:	4aa7a783          	lw	a5,1194(a5) # 80018c7c <log+0x1c>
    800037da:	37fd                	addiw	a5,a5,-1
    800037dc:	04f65e63          	bge	a2,a5,80003838 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037e0:	00015797          	auipc	a5,0x15
    800037e4:	4a07a783          	lw	a5,1184(a5) # 80018c80 <log+0x20>
    800037e8:	06f05063          	blez	a5,80003848 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    800037ee:	06c05563          	blez	a2,80003858 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f2:	44cc                	lw	a1,12(s1)
    800037f4:	00015717          	auipc	a4,0x15
    800037f8:	49c70713          	addi	a4,a4,1180 # 80018c90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037fc:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fe:	4314                	lw	a3,0(a4)
    80003800:	04b68c63          	beq	a3,a1,80003858 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003804:	2785                	addiw	a5,a5,1
    80003806:	0711                	addi	a4,a4,4
    80003808:	fef61be3          	bne	a2,a5,800037fe <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000380c:	0621                	addi	a2,a2,8
    8000380e:	060a                	slli	a2,a2,0x2
    80003810:	00015797          	auipc	a5,0x15
    80003814:	45078793          	addi	a5,a5,1104 # 80018c60 <log>
    80003818:	97b2                	add	a5,a5,a2
    8000381a:	44d8                	lw	a4,12(s1)
    8000381c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000381e:	8526                	mv	a0,s1
    80003820:	fffff097          	auipc	ra,0xfffff
    80003824:	dcc080e7          	jalr	-564(ra) # 800025ec <bpin>
    log.lh.n++;
    80003828:	00015717          	auipc	a4,0x15
    8000382c:	43870713          	addi	a4,a4,1080 # 80018c60 <log>
    80003830:	575c                	lw	a5,44(a4)
    80003832:	2785                	addiw	a5,a5,1
    80003834:	d75c                	sw	a5,44(a4)
    80003836:	a82d                	j	80003870 <log_write+0xc8>
    panic("too big a transaction");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	f2050513          	addi	a0,a0,-224 # 80008758 <syscall_name+0x200>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	446080e7          	jalr	1094(ra) # 80005c86 <panic>
    panic("log_write outside of trans");
    80003848:	00005517          	auipc	a0,0x5
    8000384c:	f2850513          	addi	a0,a0,-216 # 80008770 <syscall_name+0x218>
    80003850:	00002097          	auipc	ra,0x2
    80003854:	436080e7          	jalr	1078(ra) # 80005c86 <panic>
  log.lh.block[i] = b->blockno;
    80003858:	00878693          	addi	a3,a5,8
    8000385c:	068a                	slli	a3,a3,0x2
    8000385e:	00015717          	auipc	a4,0x15
    80003862:	40270713          	addi	a4,a4,1026 # 80018c60 <log>
    80003866:	9736                	add	a4,a4,a3
    80003868:	44d4                	lw	a3,12(s1)
    8000386a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000386c:	faf609e3          	beq	a2,a5,8000381e <log_write+0x76>
  }
  release(&log.lock);
    80003870:	00015517          	auipc	a0,0x15
    80003874:	3f050513          	addi	a0,a0,1008 # 80018c60 <log>
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	9fa080e7          	jalr	-1542(ra) # 80006272 <release>
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
    8000389a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000389c:	00005597          	auipc	a1,0x5
    800038a0:	ef458593          	addi	a1,a1,-268 # 80008790 <syscall_name+0x238>
    800038a4:	0521                	addi	a0,a0,8
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	888080e7          	jalr	-1912(ra) # 8000612e <initlock>
  lk->name = name;
    800038ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b6:	0204a423          	sw	zero,40(s1)
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret

00000000800038c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
    800038d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d4:	00850913          	addi	s2,a0,8
    800038d8:	854a                	mv	a0,s2
    800038da:	00003097          	auipc	ra,0x3
    800038de:	8e4080e7          	jalr	-1820(ra) # 800061be <acquire>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	cb89                	beqz	a5,800038f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e6:	85ca                	mv	a1,s2
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	cb2080e7          	jalr	-846(ra) # 8000159c <sleep>
  while (lk->locked) {
    800038f2:	409c                	lw	a5,0(s1)
    800038f4:	fbed                	bnez	a5,800038e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f6:	4785                	li	a5,1
    800038f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	5bc080e7          	jalr	1468(ra) # 80000eb6 <myproc>
    80003902:	591c                	lw	a5,48(a0)
    80003904:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	96a080e7          	jalr	-1686(ra) # 80006272 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	e04a                	sd	s2,0(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392a:	00850913          	addi	s2,a0,8
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	88e080e7          	jalr	-1906(ra) # 800061be <acquire>
  lk->locked = 0;
    80003938:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003940:	8526                	mv	a0,s1
    80003942:	ffffe097          	auipc	ra,0xffffe
    80003946:	cbe080e7          	jalr	-834(ra) # 80001600 <wakeup>
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	926080e7          	jalr	-1754(ra) # 80006272 <release>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003960:	7179                	addi	sp,sp,-48
    80003962:	f406                	sd	ra,40(sp)
    80003964:	f022                	sd	s0,32(sp)
    80003966:	ec26                	sd	s1,24(sp)
    80003968:	e84a                	sd	s2,16(sp)
    8000396a:	e44e                	sd	s3,8(sp)
    8000396c:	1800                	addi	s0,sp,48
    8000396e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003970:	00850913          	addi	s2,a0,8
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	848080e7          	jalr	-1976(ra) # 800061be <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397e:	409c                	lw	a5,0(s1)
    80003980:	ef99                	bnez	a5,8000399e <holdingsleep+0x3e>
    80003982:	4481                	li	s1,0
  release(&lk->lk);
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	8ec080e7          	jalr	-1812(ra) # 80006272 <release>
  return r;
}
    8000398e:	8526                	mv	a0,s1
    80003990:	70a2                	ld	ra,40(sp)
    80003992:	7402                	ld	s0,32(sp)
    80003994:	64e2                	ld	s1,24(sp)
    80003996:	6942                	ld	s2,16(sp)
    80003998:	69a2                	ld	s3,8(sp)
    8000399a:	6145                	addi	sp,sp,48
    8000399c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399e:	0284a983          	lw	s3,40(s1)
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	514080e7          	jalr	1300(ra) # 80000eb6 <myproc>
    800039aa:	5904                	lw	s1,48(a0)
    800039ac:	413484b3          	sub	s1,s1,s3
    800039b0:	0014b493          	seqz	s1,s1
    800039b4:	bfc1                	j	80003984 <holdingsleep+0x24>

00000000800039b6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b6:	1141                	addi	sp,sp,-16
    800039b8:	e406                	sd	ra,8(sp)
    800039ba:	e022                	sd	s0,0(sp)
    800039bc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039be:	00005597          	auipc	a1,0x5
    800039c2:	de258593          	addi	a1,a1,-542 # 800087a0 <syscall_name+0x248>
    800039c6:	00015517          	auipc	a0,0x15
    800039ca:	3e250513          	addi	a0,a0,994 # 80018da8 <ftable>
    800039ce:	00002097          	auipc	ra,0x2
    800039d2:	760080e7          	jalr	1888(ra) # 8000612e <initlock>
}
    800039d6:	60a2                	ld	ra,8(sp)
    800039d8:	6402                	ld	s0,0(sp)
    800039da:	0141                	addi	sp,sp,16
    800039dc:	8082                	ret

00000000800039de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e8:	00015517          	auipc	a0,0x15
    800039ec:	3c050513          	addi	a0,a0,960 # 80018da8 <ftable>
    800039f0:	00002097          	auipc	ra,0x2
    800039f4:	7ce080e7          	jalr	1998(ra) # 800061be <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f8:	00015497          	auipc	s1,0x15
    800039fc:	3c848493          	addi	s1,s1,968 # 80018dc0 <ftable+0x18>
    80003a00:	00016717          	auipc	a4,0x16
    80003a04:	36070713          	addi	a4,a4,864 # 80019d60 <disk>
    if(f->ref == 0){
    80003a08:	40dc                	lw	a5,4(s1)
    80003a0a:	cf99                	beqz	a5,80003a28 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a0c:	02848493          	addi	s1,s1,40
    80003a10:	fee49ce3          	bne	s1,a4,80003a08 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	39450513          	addi	a0,a0,916 # 80018da8 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	856080e7          	jalr	-1962(ra) # 80006272 <release>
  return 0;
    80003a24:	4481                	li	s1,0
    80003a26:	a819                	j	80003a3c <filealloc+0x5e>
      f->ref = 1;
    80003a28:	4785                	li	a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	37c50513          	addi	a0,a0,892 # 80018da8 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	83e080e7          	jalr	-1986(ra) # 80006272 <release>
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	1000                	addi	s0,sp,32
    80003a52:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a54:	00015517          	auipc	a0,0x15
    80003a58:	35450513          	addi	a0,a0,852 # 80018da8 <ftable>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	762080e7          	jalr	1890(ra) # 800061be <acquire>
  if(f->ref < 1)
    80003a64:	40dc                	lw	a5,4(s1)
    80003a66:	02f05263          	blez	a5,80003a8a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a6a:	2785                	addiw	a5,a5,1
    80003a6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6e:	00015517          	auipc	a0,0x15
    80003a72:	33a50513          	addi	a0,a0,826 # 80018da8 <ftable>
    80003a76:	00002097          	auipc	ra,0x2
    80003a7a:	7fc080e7          	jalr	2044(ra) # 80006272 <release>
  return f;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret
    panic("filedup");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	d1e50513          	addi	a0,a0,-738 # 800087a8 <syscall_name+0x250>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	1f4080e7          	jalr	500(ra) # 80005c86 <panic>

0000000080003a9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a9a:	7139                	addi	sp,sp,-64
    80003a9c:	fc06                	sd	ra,56(sp)
    80003a9e:	f822                	sd	s0,48(sp)
    80003aa0:	f426                	sd	s1,40(sp)
    80003aa2:	f04a                	sd	s2,32(sp)
    80003aa4:	ec4e                	sd	s3,24(sp)
    80003aa6:	e852                	sd	s4,16(sp)
    80003aa8:	e456                	sd	s5,8(sp)
    80003aaa:	0080                	addi	s0,sp,64
    80003aac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aae:	00015517          	auipc	a0,0x15
    80003ab2:	2fa50513          	addi	a0,a0,762 # 80018da8 <ftable>
    80003ab6:	00002097          	auipc	ra,0x2
    80003aba:	708080e7          	jalr	1800(ra) # 800061be <acquire>
  if(f->ref < 1)
    80003abe:	40dc                	lw	a5,4(s1)
    80003ac0:	06f05163          	blez	a5,80003b22 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ac4:	37fd                	addiw	a5,a5,-1
    80003ac6:	0007871b          	sext.w	a4,a5
    80003aca:	c0dc                	sw	a5,4(s1)
    80003acc:	06e04363          	bgtz	a4,80003b32 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad0:	0004a903          	lw	s2,0(s1)
    80003ad4:	0094ca83          	lbu	s5,9(s1)
    80003ad8:	0104ba03          	ld	s4,16(s1)
    80003adc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae8:	00015517          	auipc	a0,0x15
    80003aec:	2c050513          	addi	a0,a0,704 # 80018da8 <ftable>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	782080e7          	jalr	1922(ra) # 80006272 <release>

  if(ff.type == FD_PIPE){
    80003af8:	4785                	li	a5,1
    80003afa:	04f90d63          	beq	s2,a5,80003b54 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afe:	3979                	addiw	s2,s2,-2
    80003b00:	4785                	li	a5,1
    80003b02:	0527e063          	bltu	a5,s2,80003b42 <fileclose+0xa8>
    begin_op();
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	ad0080e7          	jalr	-1328(ra) # 800035d6 <begin_op>
    iput(ff.ip);
    80003b0e:	854e                	mv	a0,s3
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	2da080e7          	jalr	730(ra) # 80002dea <iput>
    end_op();
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	b38080e7          	jalr	-1224(ra) # 80003650 <end_op>
    80003b20:	a00d                	j	80003b42 <fileclose+0xa8>
    panic("fileclose");
    80003b22:	00005517          	auipc	a0,0x5
    80003b26:	c8e50513          	addi	a0,a0,-882 # 800087b0 <syscall_name+0x258>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	15c080e7          	jalr	348(ra) # 80005c86 <panic>
    release(&ftable.lock);
    80003b32:	00015517          	auipc	a0,0x15
    80003b36:	27650513          	addi	a0,a0,630 # 80018da8 <ftable>
    80003b3a:	00002097          	auipc	ra,0x2
    80003b3e:	738080e7          	jalr	1848(ra) # 80006272 <release>
  }
}
    80003b42:	70e2                	ld	ra,56(sp)
    80003b44:	7442                	ld	s0,48(sp)
    80003b46:	74a2                	ld	s1,40(sp)
    80003b48:	7902                	ld	s2,32(sp)
    80003b4a:	69e2                	ld	s3,24(sp)
    80003b4c:	6a42                	ld	s4,16(sp)
    80003b4e:	6aa2                	ld	s5,8(sp)
    80003b50:	6121                	addi	sp,sp,64
    80003b52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b54:	85d6                	mv	a1,s5
    80003b56:	8552                	mv	a0,s4
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	348080e7          	jalr	840(ra) # 80003ea0 <pipeclose>
    80003b60:	b7cd                	j	80003b42 <fileclose+0xa8>

0000000080003b62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr) /*TODO*/
{
    80003b62:	715d                	addi	sp,sp,-80
    80003b64:	e486                	sd	ra,72(sp)
    80003b66:	e0a2                	sd	s0,64(sp)
    80003b68:	fc26                	sd	s1,56(sp)
    80003b6a:	f84a                	sd	s2,48(sp)
    80003b6c:	f44e                	sd	s3,40(sp)
    80003b6e:	0880                	addi	s0,sp,80
    80003b70:	84aa                	mv	s1,a0
    80003b72:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	342080e7          	jalr	834(ra) # 80000eb6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b7c:	409c                	lw	a5,0(s1)
    80003b7e:	37f9                	addiw	a5,a5,-2
    80003b80:	4705                	li	a4,1
    80003b82:	04f76763          	bltu	a4,a5,80003bd0 <filestat+0x6e>
    80003b86:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	0a6080e7          	jalr	166(ra) # 80002c30 <ilock>
    stati(f->ip, &st);
    80003b92:	fb840593          	addi	a1,s0,-72
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	322080e7          	jalr	802(ra) # 80002eba <stati>
    iunlock(f->ip);
    80003ba0:	6c88                	ld	a0,24(s1)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	150080e7          	jalr	336(ra) # 80002cf2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003baa:	46e1                	li	a3,24
    80003bac:	fb840613          	addi	a2,s0,-72
    80003bb0:	85ce                	mv	a1,s3
    80003bb2:	05093503          	ld	a0,80(s2)
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	fc0080e7          	jalr	-64(ra) # 80000b76 <copyout>
    80003bbe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bc2:	60a6                	ld	ra,72(sp)
    80003bc4:	6406                	ld	s0,64(sp)
    80003bc6:	74e2                	ld	s1,56(sp)
    80003bc8:	7942                	ld	s2,48(sp)
    80003bca:	79a2                	ld	s3,40(sp)
    80003bcc:	6161                	addi	sp,sp,80
    80003bce:	8082                	ret
  return -1;
    80003bd0:	557d                	li	a0,-1
    80003bd2:	bfc5                	j	80003bc2 <filestat+0x60>

0000000080003bd4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bd4:	7179                	addi	sp,sp,-48
    80003bd6:	f406                	sd	ra,40(sp)
    80003bd8:	f022                	sd	s0,32(sp)
    80003bda:	ec26                	sd	s1,24(sp)
    80003bdc:	e84a                	sd	s2,16(sp)
    80003bde:	e44e                	sd	s3,8(sp)
    80003be0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003be2:	00854783          	lbu	a5,8(a0)
    80003be6:	c3d5                	beqz	a5,80003c8a <fileread+0xb6>
    80003be8:	84aa                	mv	s1,a0
    80003bea:	89ae                	mv	s3,a1
    80003bec:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bee:	411c                	lw	a5,0(a0)
    80003bf0:	4705                	li	a4,1
    80003bf2:	04e78963          	beq	a5,a4,80003c44 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf6:	470d                	li	a4,3
    80003bf8:	04e78d63          	beq	a5,a4,80003c52 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfc:	4709                	li	a4,2
    80003bfe:	06e79e63          	bne	a5,a4,80003c7a <fileread+0xa6>
    ilock(f->ip);
    80003c02:	6d08                	ld	a0,24(a0)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	02c080e7          	jalr	44(ra) # 80002c30 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c0c:	874a                	mv	a4,s2
    80003c0e:	5094                	lw	a3,32(s1)
    80003c10:	864e                	mv	a2,s3
    80003c12:	4585                	li	a1,1
    80003c14:	6c88                	ld	a0,24(s1)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	2ce080e7          	jalr	718(ra) # 80002ee4 <readi>
    80003c1e:	892a                	mv	s2,a0
    80003c20:	00a05563          	blez	a0,80003c2a <fileread+0x56>
      f->off += r;
    80003c24:	509c                	lw	a5,32(s1)
    80003c26:	9fa9                	addw	a5,a5,a0
    80003c28:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	0c6080e7          	jalr	198(ra) # 80002cf2 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c34:	854a                	mv	a0,s2
    80003c36:	70a2                	ld	ra,40(sp)
    80003c38:	7402                	ld	s0,32(sp)
    80003c3a:	64e2                	ld	s1,24(sp)
    80003c3c:	6942                	ld	s2,16(sp)
    80003c3e:	69a2                	ld	s3,8(sp)
    80003c40:	6145                	addi	sp,sp,48
    80003c42:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c44:	6908                	ld	a0,16(a0)
    80003c46:	00000097          	auipc	ra,0x0
    80003c4a:	3c2080e7          	jalr	962(ra) # 80004008 <piperead>
    80003c4e:	892a                	mv	s2,a0
    80003c50:	b7d5                	j	80003c34 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c52:	02451783          	lh	a5,36(a0)
    80003c56:	03079693          	slli	a3,a5,0x30
    80003c5a:	92c1                	srli	a3,a3,0x30
    80003c5c:	4725                	li	a4,9
    80003c5e:	02d76863          	bltu	a4,a3,80003c8e <fileread+0xba>
    80003c62:	0792                	slli	a5,a5,0x4
    80003c64:	00015717          	auipc	a4,0x15
    80003c68:	0a470713          	addi	a4,a4,164 # 80018d08 <devsw>
    80003c6c:	97ba                	add	a5,a5,a4
    80003c6e:	639c                	ld	a5,0(a5)
    80003c70:	c38d                	beqz	a5,80003c92 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c72:	4505                	li	a0,1
    80003c74:	9782                	jalr	a5
    80003c76:	892a                	mv	s2,a0
    80003c78:	bf75                	j	80003c34 <fileread+0x60>
    panic("fileread");
    80003c7a:	00005517          	auipc	a0,0x5
    80003c7e:	b4650513          	addi	a0,a0,-1210 # 800087c0 <syscall_name+0x268>
    80003c82:	00002097          	auipc	ra,0x2
    80003c86:	004080e7          	jalr	4(ra) # 80005c86 <panic>
    return -1;
    80003c8a:	597d                	li	s2,-1
    80003c8c:	b765                	j	80003c34 <fileread+0x60>
      return -1;
    80003c8e:	597d                	li	s2,-1
    80003c90:	b755                	j	80003c34 <fileread+0x60>
    80003c92:	597d                	li	s2,-1
    80003c94:	b745                	j	80003c34 <fileread+0x60>

0000000080003c96 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c96:	00954783          	lbu	a5,9(a0)
    80003c9a:	10078e63          	beqz	a5,80003db6 <filewrite+0x120>
{
    80003c9e:	715d                	addi	sp,sp,-80
    80003ca0:	e486                	sd	ra,72(sp)
    80003ca2:	e0a2                	sd	s0,64(sp)
    80003ca4:	fc26                	sd	s1,56(sp)
    80003ca6:	f84a                	sd	s2,48(sp)
    80003ca8:	f44e                	sd	s3,40(sp)
    80003caa:	f052                	sd	s4,32(sp)
    80003cac:	ec56                	sd	s5,24(sp)
    80003cae:	e85a                	sd	s6,16(sp)
    80003cb0:	e45e                	sd	s7,8(sp)
    80003cb2:	e062                	sd	s8,0(sp)
    80003cb4:	0880                	addi	s0,sp,80
    80003cb6:	892a                	mv	s2,a0
    80003cb8:	8b2e                	mv	s6,a1
    80003cba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cbc:	411c                	lw	a5,0(a0)
    80003cbe:	4705                	li	a4,1
    80003cc0:	02e78263          	beq	a5,a4,80003ce4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc4:	470d                	li	a4,3
    80003cc6:	02e78563          	beq	a5,a4,80003cf0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cca:	4709                	li	a4,2
    80003ccc:	0ce79d63          	bne	a5,a4,80003da6 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cd0:	0ac05b63          	blez	a2,80003d86 <filewrite+0xf0>
    int i = 0;
    80003cd4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cd6:	6b85                	lui	s7,0x1
    80003cd8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cdc:	6c05                	lui	s8,0x1
    80003cde:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ce2:	a851                	j	80003d76 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003ce4:	6908                	ld	a0,16(a0)
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	22a080e7          	jalr	554(ra) # 80003f10 <pipewrite>
    80003cee:	a045                	j	80003d8e <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cf0:	02451783          	lh	a5,36(a0)
    80003cf4:	03079693          	slli	a3,a5,0x30
    80003cf8:	92c1                	srli	a3,a3,0x30
    80003cfa:	4725                	li	a4,9
    80003cfc:	0ad76f63          	bltu	a4,a3,80003dba <filewrite+0x124>
    80003d00:	0792                	slli	a5,a5,0x4
    80003d02:	00015717          	auipc	a4,0x15
    80003d06:	00670713          	addi	a4,a4,6 # 80018d08 <devsw>
    80003d0a:	97ba                	add	a5,a5,a4
    80003d0c:	679c                	ld	a5,8(a5)
    80003d0e:	cbc5                	beqz	a5,80003dbe <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003d10:	4505                	li	a0,1
    80003d12:	9782                	jalr	a5
    80003d14:	a8ad                	j	80003d8e <filewrite+0xf8>
      if(n1 > max)
    80003d16:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	8bc080e7          	jalr	-1860(ra) # 800035d6 <begin_op>
      ilock(f->ip);
    80003d22:	01893503          	ld	a0,24(s2)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	f0a080e7          	jalr	-246(ra) # 80002c30 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d2e:	8756                	mv	a4,s5
    80003d30:	02092683          	lw	a3,32(s2)
    80003d34:	01698633          	add	a2,s3,s6
    80003d38:	4585                	li	a1,1
    80003d3a:	01893503          	ld	a0,24(s2)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	29e080e7          	jalr	670(ra) # 80002fdc <writei>
    80003d46:	84aa                	mv	s1,a0
    80003d48:	00a05763          	blez	a0,80003d56 <filewrite+0xc0>
        f->off += r;
    80003d4c:	02092783          	lw	a5,32(s2)
    80003d50:	9fa9                	addw	a5,a5,a0
    80003d52:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d56:	01893503          	ld	a0,24(s2)
    80003d5a:	fffff097          	auipc	ra,0xfffff
    80003d5e:	f98080e7          	jalr	-104(ra) # 80002cf2 <iunlock>
      end_op();
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	8ee080e7          	jalr	-1810(ra) # 80003650 <end_op>

      if(r != n1){
    80003d6a:	009a9f63          	bne	s5,s1,80003d88 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d6e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d72:	0149db63          	bge	s3,s4,80003d88 <filewrite+0xf2>
      int n1 = n - i;
    80003d76:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d7a:	0004879b          	sext.w	a5,s1
    80003d7e:	f8fbdce3          	bge	s7,a5,80003d16 <filewrite+0x80>
    80003d82:	84e2                	mv	s1,s8
    80003d84:	bf49                	j	80003d16 <filewrite+0x80>
    int i = 0;
    80003d86:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d88:	033a1d63          	bne	s4,s3,80003dc2 <filewrite+0x12c>
    80003d8c:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d8e:	60a6                	ld	ra,72(sp)
    80003d90:	6406                	ld	s0,64(sp)
    80003d92:	74e2                	ld	s1,56(sp)
    80003d94:	7942                	ld	s2,48(sp)
    80003d96:	79a2                	ld	s3,40(sp)
    80003d98:	7a02                	ld	s4,32(sp)
    80003d9a:	6ae2                	ld	s5,24(sp)
    80003d9c:	6b42                	ld	s6,16(sp)
    80003d9e:	6ba2                	ld	s7,8(sp)
    80003da0:	6c02                	ld	s8,0(sp)
    80003da2:	6161                	addi	sp,sp,80
    80003da4:	8082                	ret
    panic("filewrite");
    80003da6:	00005517          	auipc	a0,0x5
    80003daa:	a2a50513          	addi	a0,a0,-1494 # 800087d0 <syscall_name+0x278>
    80003dae:	00002097          	auipc	ra,0x2
    80003db2:	ed8080e7          	jalr	-296(ra) # 80005c86 <panic>
    return -1;
    80003db6:	557d                	li	a0,-1
}
    80003db8:	8082                	ret
      return -1;
    80003dba:	557d                	li	a0,-1
    80003dbc:	bfc9                	j	80003d8e <filewrite+0xf8>
    80003dbe:	557d                	li	a0,-1
    80003dc0:	b7f9                	j	80003d8e <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003dc2:	557d                	li	a0,-1
    80003dc4:	b7e9                	j	80003d8e <filewrite+0xf8>

0000000080003dc6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dc6:	7179                	addi	sp,sp,-48
    80003dc8:	f406                	sd	ra,40(sp)
    80003dca:	f022                	sd	s0,32(sp)
    80003dcc:	ec26                	sd	s1,24(sp)
    80003dce:	e84a                	sd	s2,16(sp)
    80003dd0:	e44e                	sd	s3,8(sp)
    80003dd2:	e052                	sd	s4,0(sp)
    80003dd4:	1800                	addi	s0,sp,48
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dda:	0005b023          	sd	zero,0(a1)
    80003dde:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	bfc080e7          	jalr	-1028(ra) # 800039de <filealloc>
    80003dea:	e088                	sd	a0,0(s1)
    80003dec:	c551                	beqz	a0,80003e78 <pipealloc+0xb2>
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	bf0080e7          	jalr	-1040(ra) # 800039de <filealloc>
    80003df6:	00aa3023          	sd	a0,0(s4)
    80003dfa:	c92d                	beqz	a0,80003e6c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dfc:	ffffc097          	auipc	ra,0xffffc
    80003e00:	382080e7          	jalr	898(ra) # 8000017e <kalloc>
    80003e04:	892a                	mv	s2,a0
    80003e06:	c125                	beqz	a0,80003e66 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e08:	4985                	li	s3,1
    80003e0a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e0e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e12:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e16:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e1a:	00004597          	auipc	a1,0x4
    80003e1e:	5ce58593          	addi	a1,a1,1486 # 800083e8 <states.0+0x1a0>
    80003e22:	00002097          	auipc	ra,0x2
    80003e26:	30c080e7          	jalr	780(ra) # 8000612e <initlock>
  (*f0)->type = FD_PIPE;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e36:	609c                	ld	a5,0(s1)
    80003e38:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e3c:	609c                	ld	a5,0(s1)
    80003e3e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e42:	000a3783          	ld	a5,0(s4)
    80003e46:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e4a:	000a3783          	ld	a5,0(s4)
    80003e4e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e52:	000a3783          	ld	a5,0(s4)
    80003e56:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e5a:	000a3783          	ld	a5,0(s4)
    80003e5e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e62:	4501                	li	a0,0
    80003e64:	a025                	j	80003e8c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e66:	6088                	ld	a0,0(s1)
    80003e68:	e501                	bnez	a0,80003e70 <pipealloc+0xaa>
    80003e6a:	a039                	j	80003e78 <pipealloc+0xb2>
    80003e6c:	6088                	ld	a0,0(s1)
    80003e6e:	c51d                	beqz	a0,80003e9c <pipealloc+0xd6>
    fileclose(*f0);
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	c2a080e7          	jalr	-982(ra) # 80003a9a <fileclose>
  if(*f1)
    80003e78:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e7c:	557d                	li	a0,-1
  if(*f1)
    80003e7e:	c799                	beqz	a5,80003e8c <pipealloc+0xc6>
    fileclose(*f1);
    80003e80:	853e                	mv	a0,a5
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	c18080e7          	jalr	-1000(ra) # 80003a9a <fileclose>
  return -1;
    80003e8a:	557d                	li	a0,-1
}
    80003e8c:	70a2                	ld	ra,40(sp)
    80003e8e:	7402                	ld	s0,32(sp)
    80003e90:	64e2                	ld	s1,24(sp)
    80003e92:	6942                	ld	s2,16(sp)
    80003e94:	69a2                	ld	s3,8(sp)
    80003e96:	6a02                	ld	s4,0(sp)
    80003e98:	6145                	addi	sp,sp,48
    80003e9a:	8082                	ret
  return -1;
    80003e9c:	557d                	li	a0,-1
    80003e9e:	b7fd                	j	80003e8c <pipealloc+0xc6>

0000000080003ea0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ea0:	1101                	addi	sp,sp,-32
    80003ea2:	ec06                	sd	ra,24(sp)
    80003ea4:	e822                	sd	s0,16(sp)
    80003ea6:	e426                	sd	s1,8(sp)
    80003ea8:	e04a                	sd	s2,0(sp)
    80003eaa:	1000                	addi	s0,sp,32
    80003eac:	84aa                	mv	s1,a0
    80003eae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eb0:	00002097          	auipc	ra,0x2
    80003eb4:	30e080e7          	jalr	782(ra) # 800061be <acquire>
  if(writable){
    80003eb8:	02090d63          	beqz	s2,80003ef2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ebc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ec0:	21848513          	addi	a0,s1,536
    80003ec4:	ffffd097          	auipc	ra,0xffffd
    80003ec8:	73c080e7          	jalr	1852(ra) # 80001600 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ecc:	2204b783          	ld	a5,544(s1)
    80003ed0:	eb95                	bnez	a5,80003f04 <pipeclose+0x64>
    release(&pi->lock);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	00002097          	auipc	ra,0x2
    80003ed8:	39e080e7          	jalr	926(ra) # 80006272 <release>
    kfree((char*)pi);
    80003edc:	8526                	mv	a0,s1
    80003ede:	ffffc097          	auipc	ra,0xffffc
    80003ee2:	1a2080e7          	jalr	418(ra) # 80000080 <kfree>
  } else
    release(&pi->lock);
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	64a2                	ld	s1,8(sp)
    80003eec:	6902                	ld	s2,0(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret
    pi->readopen = 0;
    80003ef2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ef6:	21c48513          	addi	a0,s1,540
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	706080e7          	jalr	1798(ra) # 80001600 <wakeup>
    80003f02:	b7e9                	j	80003ecc <pipeclose+0x2c>
    release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	36c080e7          	jalr	876(ra) # 80006272 <release>
}
    80003f0e:	bfe1                	j	80003ee6 <pipeclose+0x46>

0000000080003f10 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f10:	711d                	addi	sp,sp,-96
    80003f12:	ec86                	sd	ra,88(sp)
    80003f14:	e8a2                	sd	s0,80(sp)
    80003f16:	e4a6                	sd	s1,72(sp)
    80003f18:	e0ca                	sd	s2,64(sp)
    80003f1a:	fc4e                	sd	s3,56(sp)
    80003f1c:	f852                	sd	s4,48(sp)
    80003f1e:	f456                	sd	s5,40(sp)
    80003f20:	f05a                	sd	s6,32(sp)
    80003f22:	ec5e                	sd	s7,24(sp)
    80003f24:	e862                	sd	s8,16(sp)
    80003f26:	1080                	addi	s0,sp,96
    80003f28:	84aa                	mv	s1,a0
    80003f2a:	8aae                	mv	s5,a1
    80003f2c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	f88080e7          	jalr	-120(ra) # 80000eb6 <myproc>
    80003f36:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f38:	8526                	mv	a0,s1
    80003f3a:	00002097          	auipc	ra,0x2
    80003f3e:	284080e7          	jalr	644(ra) # 800061be <acquire>
  while(i < n){
    80003f42:	0b405663          	blez	s4,80003fee <pipewrite+0xde>
  int i = 0;
    80003f46:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f48:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f4a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f4e:	21c48b93          	addi	s7,s1,540
    80003f52:	a089                	j	80003f94 <pipewrite+0x84>
      release(&pi->lock);
    80003f54:	8526                	mv	a0,s1
    80003f56:	00002097          	auipc	ra,0x2
    80003f5a:	31c080e7          	jalr	796(ra) # 80006272 <release>
      return -1;
    80003f5e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f60:	854a                	mv	a0,s2
    80003f62:	60e6                	ld	ra,88(sp)
    80003f64:	6446                	ld	s0,80(sp)
    80003f66:	64a6                	ld	s1,72(sp)
    80003f68:	6906                	ld	s2,64(sp)
    80003f6a:	79e2                	ld	s3,56(sp)
    80003f6c:	7a42                	ld	s4,48(sp)
    80003f6e:	7aa2                	ld	s5,40(sp)
    80003f70:	7b02                	ld	s6,32(sp)
    80003f72:	6be2                	ld	s7,24(sp)
    80003f74:	6c42                	ld	s8,16(sp)
    80003f76:	6125                	addi	sp,sp,96
    80003f78:	8082                	ret
      wakeup(&pi->nread);
    80003f7a:	8562                	mv	a0,s8
    80003f7c:	ffffd097          	auipc	ra,0xffffd
    80003f80:	684080e7          	jalr	1668(ra) # 80001600 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f84:	85a6                	mv	a1,s1
    80003f86:	855e                	mv	a0,s7
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	614080e7          	jalr	1556(ra) # 8000159c <sleep>
  while(i < n){
    80003f90:	07495063          	bge	s2,s4,80003ff0 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f94:	2204a783          	lw	a5,544(s1)
    80003f98:	dfd5                	beqz	a5,80003f54 <pipewrite+0x44>
    80003f9a:	854e                	mv	a0,s3
    80003f9c:	ffffe097          	auipc	ra,0xffffe
    80003fa0:	8a8080e7          	jalr	-1880(ra) # 80001844 <killed>
    80003fa4:	f945                	bnez	a0,80003f54 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fa6:	2184a783          	lw	a5,536(s1)
    80003faa:	21c4a703          	lw	a4,540(s1)
    80003fae:	2007879b          	addiw	a5,a5,512
    80003fb2:	fcf704e3          	beq	a4,a5,80003f7a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb6:	4685                	li	a3,1
    80003fb8:	01590633          	add	a2,s2,s5
    80003fbc:	faf40593          	addi	a1,s0,-81
    80003fc0:	0509b503          	ld	a0,80(s3)
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	c3e080e7          	jalr	-962(ra) # 80000c02 <copyin>
    80003fcc:	03650263          	beq	a0,s6,80003ff0 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fd0:	21c4a783          	lw	a5,540(s1)
    80003fd4:	0017871b          	addiw	a4,a5,1
    80003fd8:	20e4ae23          	sw	a4,540(s1)
    80003fdc:	1ff7f793          	andi	a5,a5,511
    80003fe0:	97a6                	add	a5,a5,s1
    80003fe2:	faf44703          	lbu	a4,-81(s0)
    80003fe6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fea:	2905                	addiw	s2,s2,1
    80003fec:	b755                	j	80003f90 <pipewrite+0x80>
  int i = 0;
    80003fee:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ff0:	21848513          	addi	a0,s1,536
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	60c080e7          	jalr	1548(ra) # 80001600 <wakeup>
  release(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	274080e7          	jalr	628(ra) # 80006272 <release>
  return i;
    80004006:	bfa9                	j	80003f60 <pipewrite+0x50>

0000000080004008 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004008:	715d                	addi	sp,sp,-80
    8000400a:	e486                	sd	ra,72(sp)
    8000400c:	e0a2                	sd	s0,64(sp)
    8000400e:	fc26                	sd	s1,56(sp)
    80004010:	f84a                	sd	s2,48(sp)
    80004012:	f44e                	sd	s3,40(sp)
    80004014:	f052                	sd	s4,32(sp)
    80004016:	ec56                	sd	s5,24(sp)
    80004018:	e85a                	sd	s6,16(sp)
    8000401a:	0880                	addi	s0,sp,80
    8000401c:	84aa                	mv	s1,a0
    8000401e:	892e                	mv	s2,a1
    80004020:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	e94080e7          	jalr	-364(ra) # 80000eb6 <myproc>
    8000402a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000402c:	8526                	mv	a0,s1
    8000402e:	00002097          	auipc	ra,0x2
    80004032:	190080e7          	jalr	400(ra) # 800061be <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004036:	2184a703          	lw	a4,536(s1)
    8000403a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004042:	02f71763          	bne	a4,a5,80004070 <piperead+0x68>
    80004046:	2244a783          	lw	a5,548(s1)
    8000404a:	c39d                	beqz	a5,80004070 <piperead+0x68>
    if(killed(pr)){
    8000404c:	8552                	mv	a0,s4
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	7f6080e7          	jalr	2038(ra) # 80001844 <killed>
    80004056:	e949                	bnez	a0,800040e8 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004058:	85a6                	mv	a1,s1
    8000405a:	854e                	mv	a0,s3
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	540080e7          	jalr	1344(ra) # 8000159c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004064:	2184a703          	lw	a4,536(s1)
    80004068:	21c4a783          	lw	a5,540(s1)
    8000406c:	fcf70de3          	beq	a4,a5,80004046 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004070:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004072:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004074:	05505463          	blez	s5,800040bc <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004078:	2184a783          	lw	a5,536(s1)
    8000407c:	21c4a703          	lw	a4,540(s1)
    80004080:	02f70e63          	beq	a4,a5,800040bc <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004084:	0017871b          	addiw	a4,a5,1
    80004088:	20e4ac23          	sw	a4,536(s1)
    8000408c:	1ff7f793          	andi	a5,a5,511
    80004090:	97a6                	add	a5,a5,s1
    80004092:	0187c783          	lbu	a5,24(a5)
    80004096:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000409a:	4685                	li	a3,1
    8000409c:	fbf40613          	addi	a2,s0,-65
    800040a0:	85ca                	mv	a1,s2
    800040a2:	050a3503          	ld	a0,80(s4)
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	ad0080e7          	jalr	-1328(ra) # 80000b76 <copyout>
    800040ae:	01650763          	beq	a0,s6,800040bc <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b2:	2985                	addiw	s3,s3,1
    800040b4:	0905                	addi	s2,s2,1
    800040b6:	fd3a91e3          	bne	s5,s3,80004078 <piperead+0x70>
    800040ba:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040bc:	21c48513          	addi	a0,s1,540
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	540080e7          	jalr	1344(ra) # 80001600 <wakeup>
  release(&pi->lock);
    800040c8:	8526                	mv	a0,s1
    800040ca:	00002097          	auipc	ra,0x2
    800040ce:	1a8080e7          	jalr	424(ra) # 80006272 <release>
  return i;
}
    800040d2:	854e                	mv	a0,s3
    800040d4:	60a6                	ld	ra,72(sp)
    800040d6:	6406                	ld	s0,64(sp)
    800040d8:	74e2                	ld	s1,56(sp)
    800040da:	7942                	ld	s2,48(sp)
    800040dc:	79a2                	ld	s3,40(sp)
    800040de:	7a02                	ld	s4,32(sp)
    800040e0:	6ae2                	ld	s5,24(sp)
    800040e2:	6b42                	ld	s6,16(sp)
    800040e4:	6161                	addi	sp,sp,80
    800040e6:	8082                	ret
      release(&pi->lock);
    800040e8:	8526                	mv	a0,s1
    800040ea:	00002097          	auipc	ra,0x2
    800040ee:	188080e7          	jalr	392(ra) # 80006272 <release>
      return -1;
    800040f2:	59fd                	li	s3,-1
    800040f4:	bff9                	j	800040d2 <piperead+0xca>

00000000800040f6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040f6:	1141                	addi	sp,sp,-16
    800040f8:	e422                	sd	s0,8(sp)
    800040fa:	0800                	addi	s0,sp,16
    800040fc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040fe:	8905                	andi	a0,a0,1
    80004100:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004102:	8b89                	andi	a5,a5,2
    80004104:	c399                	beqz	a5,8000410a <flags2perm+0x14>
      perm |= PTE_W;
    80004106:	00456513          	ori	a0,a0,4
    return perm;
}
    8000410a:	6422                	ld	s0,8(sp)
    8000410c:	0141                	addi	sp,sp,16
    8000410e:	8082                	ret

0000000080004110 <exec>:

int
exec(char *path, char **argv)
{
    80004110:	df010113          	addi	sp,sp,-528
    80004114:	20113423          	sd	ra,520(sp)
    80004118:	20813023          	sd	s0,512(sp)
    8000411c:	ffa6                	sd	s1,504(sp)
    8000411e:	fbca                	sd	s2,496(sp)
    80004120:	f7ce                	sd	s3,488(sp)
    80004122:	f3d2                	sd	s4,480(sp)
    80004124:	efd6                	sd	s5,472(sp)
    80004126:	ebda                	sd	s6,464(sp)
    80004128:	e7de                	sd	s7,456(sp)
    8000412a:	e3e2                	sd	s8,448(sp)
    8000412c:	ff66                	sd	s9,440(sp)
    8000412e:	fb6a                	sd	s10,432(sp)
    80004130:	f76e                	sd	s11,424(sp)
    80004132:	0c00                	addi	s0,sp,528
    80004134:	892a                	mv	s2,a0
    80004136:	dea43c23          	sd	a0,-520(s0)
    8000413a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	d78080e7          	jalr	-648(ra) # 80000eb6 <myproc>
    80004146:	84aa                	mv	s1,a0

  begin_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	48e080e7          	jalr	1166(ra) # 800035d6 <begin_op>

  if((ip = namei(path)) == 0){
    80004150:	854a                	mv	a0,s2
    80004152:	fffff097          	auipc	ra,0xfffff
    80004156:	284080e7          	jalr	644(ra) # 800033d6 <namei>
    8000415a:	c92d                	beqz	a0,800041cc <exec+0xbc>
    8000415c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	ad2080e7          	jalr	-1326(ra) # 80002c30 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004166:	04000713          	li	a4,64
    8000416a:	4681                	li	a3,0
    8000416c:	e5040613          	addi	a2,s0,-432
    80004170:	4581                	li	a1,0
    80004172:	8552                	mv	a0,s4
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	d70080e7          	jalr	-656(ra) # 80002ee4 <readi>
    8000417c:	04000793          	li	a5,64
    80004180:	00f51a63          	bne	a0,a5,80004194 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004184:	e5042703          	lw	a4,-432(s0)
    80004188:	464c47b7          	lui	a5,0x464c4
    8000418c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004190:	04f70463          	beq	a4,a5,800041d8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004194:	8552                	mv	a0,s4
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	cfc080e7          	jalr	-772(ra) # 80002e92 <iunlockput>
    end_op();
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	4b2080e7          	jalr	1202(ra) # 80003650 <end_op>
  }
  return -1;
    800041a6:	557d                	li	a0,-1
}
    800041a8:	20813083          	ld	ra,520(sp)
    800041ac:	20013403          	ld	s0,512(sp)
    800041b0:	74fe                	ld	s1,504(sp)
    800041b2:	795e                	ld	s2,496(sp)
    800041b4:	79be                	ld	s3,488(sp)
    800041b6:	7a1e                	ld	s4,480(sp)
    800041b8:	6afe                	ld	s5,472(sp)
    800041ba:	6b5e                	ld	s6,464(sp)
    800041bc:	6bbe                	ld	s7,456(sp)
    800041be:	6c1e                	ld	s8,448(sp)
    800041c0:	7cfa                	ld	s9,440(sp)
    800041c2:	7d5a                	ld	s10,432(sp)
    800041c4:	7dba                	ld	s11,424(sp)
    800041c6:	21010113          	addi	sp,sp,528
    800041ca:	8082                	ret
    end_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	484080e7          	jalr	1156(ra) # 80003650 <end_op>
    return -1;
    800041d4:	557d                	li	a0,-1
    800041d6:	bfc9                	j	800041a8 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041d8:	8526                	mv	a0,s1
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	da0080e7          	jalr	-608(ra) # 80000f7a <proc_pagetable>
    800041e2:	8b2a                	mv	s6,a0
    800041e4:	d945                	beqz	a0,80004194 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e6:	e7042d03          	lw	s10,-400(s0)
    800041ea:	e8845783          	lhu	a5,-376(s0)
    800041ee:	10078463          	beqz	a5,800042f6 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800041f6:	6c85                	lui	s9,0x1
    800041f8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041fc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004200:	6a85                	lui	s5,0x1
    80004202:	a0b5                	j	8000426e <exec+0x15e>
      panic("loadseg: address should exist");
    80004204:	00004517          	auipc	a0,0x4
    80004208:	5dc50513          	addi	a0,a0,1500 # 800087e0 <syscall_name+0x288>
    8000420c:	00002097          	auipc	ra,0x2
    80004210:	a7a080e7          	jalr	-1414(ra) # 80005c86 <panic>
    if(sz - i < PGSIZE)
    80004214:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004216:	8726                	mv	a4,s1
    80004218:	012c06bb          	addw	a3,s8,s2
    8000421c:	4581                	li	a1,0
    8000421e:	8552                	mv	a0,s4
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	cc4080e7          	jalr	-828(ra) # 80002ee4 <readi>
    80004228:	2501                	sext.w	a0,a0
    8000422a:	24a49863          	bne	s1,a0,8000447a <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000422e:	012a893b          	addw	s2,s5,s2
    80004232:	03397563          	bgeu	s2,s3,8000425c <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004236:	02091593          	slli	a1,s2,0x20
    8000423a:	9181                	srli	a1,a1,0x20
    8000423c:	95de                	add	a1,a1,s7
    8000423e:	855a                	mv	a0,s6
    80004240:	ffffc097          	auipc	ra,0xffffc
    80004244:	326080e7          	jalr	806(ra) # 80000566 <walkaddr>
    80004248:	862a                	mv	a2,a0
    if(pa == 0)
    8000424a:	dd4d                	beqz	a0,80004204 <exec+0xf4>
    if(sz - i < PGSIZE)
    8000424c:	412984bb          	subw	s1,s3,s2
    80004250:	0004879b          	sext.w	a5,s1
    80004254:	fcfcf0e3          	bgeu	s9,a5,80004214 <exec+0x104>
    80004258:	84d6                	mv	s1,s5
    8000425a:	bf6d                	j	80004214 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000425c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004260:	2d85                	addiw	s11,s11,1
    80004262:	038d0d1b          	addiw	s10,s10,56
    80004266:	e8845783          	lhu	a5,-376(s0)
    8000426a:	08fdd763          	bge	s11,a5,800042f8 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000426e:	2d01                	sext.w	s10,s10
    80004270:	03800713          	li	a4,56
    80004274:	86ea                	mv	a3,s10
    80004276:	e1840613          	addi	a2,s0,-488
    8000427a:	4581                	li	a1,0
    8000427c:	8552                	mv	a0,s4
    8000427e:	fffff097          	auipc	ra,0xfffff
    80004282:	c66080e7          	jalr	-922(ra) # 80002ee4 <readi>
    80004286:	03800793          	li	a5,56
    8000428a:	1ef51663          	bne	a0,a5,80004476 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000428e:	e1842783          	lw	a5,-488(s0)
    80004292:	4705                	li	a4,1
    80004294:	fce796e3          	bne	a5,a4,80004260 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004298:	e4043483          	ld	s1,-448(s0)
    8000429c:	e3843783          	ld	a5,-456(s0)
    800042a0:	1ef4e863          	bltu	s1,a5,80004490 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042a4:	e2843783          	ld	a5,-472(s0)
    800042a8:	94be                	add	s1,s1,a5
    800042aa:	1ef4e663          	bltu	s1,a5,80004496 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800042ae:	df043703          	ld	a4,-528(s0)
    800042b2:	8ff9                	and	a5,a5,a4
    800042b4:	1e079463          	bnez	a5,8000449c <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042b8:	e1c42503          	lw	a0,-484(s0)
    800042bc:	00000097          	auipc	ra,0x0
    800042c0:	e3a080e7          	jalr	-454(ra) # 800040f6 <flags2perm>
    800042c4:	86aa                	mv	a3,a0
    800042c6:	8626                	mv	a2,s1
    800042c8:	85ca                	mv	a1,s2
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	64e080e7          	jalr	1614(ra) # 8000091a <uvmalloc>
    800042d4:	e0a43423          	sd	a0,-504(s0)
    800042d8:	1c050563          	beqz	a0,800044a2 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042dc:	e2843b83          	ld	s7,-472(s0)
    800042e0:	e2042c03          	lw	s8,-480(s0)
    800042e4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042e8:	00098463          	beqz	s3,800042f0 <exec+0x1e0>
    800042ec:	4901                	li	s2,0
    800042ee:	b7a1                	j	80004236 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042f0:	e0843903          	ld	s2,-504(s0)
    800042f4:	b7b5                	j	80004260 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042f6:	4901                	li	s2,0
  iunlockput(ip);
    800042f8:	8552                	mv	a0,s4
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	b98080e7          	jalr	-1128(ra) # 80002e92 <iunlockput>
  end_op();
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	34e080e7          	jalr	846(ra) # 80003650 <end_op>
  p = myproc();
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	bac080e7          	jalr	-1108(ra) # 80000eb6 <myproc>
    80004312:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004314:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004318:	6985                	lui	s3,0x1
    8000431a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000431c:	99ca                	add	s3,s3,s2
    8000431e:	77fd                	lui	a5,0xfffff
    80004320:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004324:	4691                	li	a3,4
    80004326:	6609                	lui	a2,0x2
    80004328:	964e                	add	a2,a2,s3
    8000432a:	85ce                	mv	a1,s3
    8000432c:	855a                	mv	a0,s6
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	5ec080e7          	jalr	1516(ra) # 8000091a <uvmalloc>
    80004336:	892a                	mv	s2,a0
    80004338:	e0a43423          	sd	a0,-504(s0)
    8000433c:	e509                	bnez	a0,80004346 <exec+0x236>
  if(pagetable)
    8000433e:	e1343423          	sd	s3,-504(s0)
    80004342:	4a01                	li	s4,0
    80004344:	aa1d                	j	8000447a <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004346:	75f9                	lui	a1,0xffffe
    80004348:	95aa                	add	a1,a1,a0
    8000434a:	855a                	mv	a0,s6
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	7f8080e7          	jalr	2040(ra) # 80000b44 <uvmclear>
  stackbase = sp - PGSIZE;
    80004354:	7bfd                	lui	s7,0xfffff
    80004356:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004358:	e0043783          	ld	a5,-512(s0)
    8000435c:	6388                	ld	a0,0(a5)
    8000435e:	c52d                	beqz	a0,800043c8 <exec+0x2b8>
    80004360:	e9040993          	addi	s3,s0,-368
    80004364:	f9040c13          	addi	s8,s0,-112
    80004368:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	fee080e7          	jalr	-18(ra) # 80000358 <strlen>
    80004372:	0015079b          	addiw	a5,a0,1
    80004376:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000437a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000437e:	13796563          	bltu	s2,s7,800044a8 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004382:	e0043d03          	ld	s10,-512(s0)
    80004386:	000d3a03          	ld	s4,0(s10)
    8000438a:	8552                	mv	a0,s4
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	fcc080e7          	jalr	-52(ra) # 80000358 <strlen>
    80004394:	0015069b          	addiw	a3,a0,1
    80004398:	8652                	mv	a2,s4
    8000439a:	85ca                	mv	a1,s2
    8000439c:	855a                	mv	a0,s6
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	7d8080e7          	jalr	2008(ra) # 80000b76 <copyout>
    800043a6:	10054363          	bltz	a0,800044ac <exec+0x39c>
    ustack[argc] = sp;
    800043aa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ae:	0485                	addi	s1,s1,1
    800043b0:	008d0793          	addi	a5,s10,8
    800043b4:	e0f43023          	sd	a5,-512(s0)
    800043b8:	008d3503          	ld	a0,8(s10)
    800043bc:	c909                	beqz	a0,800043ce <exec+0x2be>
    if(argc >= MAXARG)
    800043be:	09a1                	addi	s3,s3,8
    800043c0:	fb8995e3          	bne	s3,s8,8000436a <exec+0x25a>
  ip = 0;
    800043c4:	4a01                	li	s4,0
    800043c6:	a855                	j	8000447a <exec+0x36a>
  sp = sz;
    800043c8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043cc:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ce:	00349793          	slli	a5,s1,0x3
    800043d2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdceb0>
    800043d6:	97a2                	add	a5,a5,s0
    800043d8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043dc:	00148693          	addi	a3,s1,1
    800043e0:	068e                	slli	a3,a3,0x3
    800043e2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043e6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800043ea:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043ee:	f57968e3          	bltu	s2,s7,8000433e <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043f2:	e9040613          	addi	a2,s0,-368
    800043f6:	85ca                	mv	a1,s2
    800043f8:	855a                	mv	a0,s6
    800043fa:	ffffc097          	auipc	ra,0xffffc
    800043fe:	77c080e7          	jalr	1916(ra) # 80000b76 <copyout>
    80004402:	0a054763          	bltz	a0,800044b0 <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004406:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000440a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000440e:	df843783          	ld	a5,-520(s0)
    80004412:	0007c703          	lbu	a4,0(a5)
    80004416:	cf11                	beqz	a4,80004432 <exec+0x322>
    80004418:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000441a:	02f00693          	li	a3,47
    8000441e:	a039                	j	8000442c <exec+0x31c>
      last = s+1;
    80004420:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004424:	0785                	addi	a5,a5,1
    80004426:	fff7c703          	lbu	a4,-1(a5)
    8000442a:	c701                	beqz	a4,80004432 <exec+0x322>
    if(*s == '/')
    8000442c:	fed71ce3          	bne	a4,a3,80004424 <exec+0x314>
    80004430:	bfc5                	j	80004420 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    80004432:	4641                	li	a2,16
    80004434:	df843583          	ld	a1,-520(s0)
    80004438:	158a8513          	addi	a0,s5,344
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	eea080e7          	jalr	-278(ra) # 80000326 <safestrcpy>
  oldpagetable = p->pagetable;
    80004444:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004448:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000444c:	e0843783          	ld	a5,-504(s0)
    80004450:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004454:	058ab783          	ld	a5,88(s5)
    80004458:	e6843703          	ld	a4,-408(s0)
    8000445c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000445e:	058ab783          	ld	a5,88(s5)
    80004462:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004466:	85e6                	mv	a1,s9
    80004468:	ffffd097          	auipc	ra,0xffffd
    8000446c:	bae080e7          	jalr	-1106(ra) # 80001016 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004470:	0004851b          	sext.w	a0,s1
    80004474:	bb15                	j	800041a8 <exec+0x98>
    80004476:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000447a:	e0843583          	ld	a1,-504(s0)
    8000447e:	855a                	mv	a0,s6
    80004480:	ffffd097          	auipc	ra,0xffffd
    80004484:	b96080e7          	jalr	-1130(ra) # 80001016 <proc_freepagetable>
  return -1;
    80004488:	557d                	li	a0,-1
  if(ip){
    8000448a:	d00a0fe3          	beqz	s4,800041a8 <exec+0x98>
    8000448e:	b319                	j	80004194 <exec+0x84>
    80004490:	e1243423          	sd	s2,-504(s0)
    80004494:	b7dd                	j	8000447a <exec+0x36a>
    80004496:	e1243423          	sd	s2,-504(s0)
    8000449a:	b7c5                	j	8000447a <exec+0x36a>
    8000449c:	e1243423          	sd	s2,-504(s0)
    800044a0:	bfe9                	j	8000447a <exec+0x36a>
    800044a2:	e1243423          	sd	s2,-504(s0)
    800044a6:	bfd1                	j	8000447a <exec+0x36a>
  ip = 0;
    800044a8:	4a01                	li	s4,0
    800044aa:	bfc1                	j	8000447a <exec+0x36a>
    800044ac:	4a01                	li	s4,0
  if(pagetable)
    800044ae:	b7f1                	j	8000447a <exec+0x36a>
  sz = sz1;
    800044b0:	e0843983          	ld	s3,-504(s0)
    800044b4:	b569                	j	8000433e <exec+0x22e>

00000000800044b6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044b6:	7179                	addi	sp,sp,-48
    800044b8:	f406                	sd	ra,40(sp)
    800044ba:	f022                	sd	s0,32(sp)
    800044bc:	ec26                	sd	s1,24(sp)
    800044be:	e84a                	sd	s2,16(sp)
    800044c0:	1800                	addi	s0,sp,48
    800044c2:	892e                	mv	s2,a1
    800044c4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044c6:	fdc40593          	addi	a1,s0,-36
    800044ca:	ffffe097          	auipc	ra,0xffffe
    800044ce:	b44080e7          	jalr	-1212(ra) # 8000200e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044d2:	fdc42703          	lw	a4,-36(s0)
    800044d6:	47bd                	li	a5,15
    800044d8:	02e7eb63          	bltu	a5,a4,8000450e <argfd+0x58>
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	9da080e7          	jalr	-1574(ra) # 80000eb6 <myproc>
    800044e4:	fdc42703          	lw	a4,-36(s0)
    800044e8:	01a70793          	addi	a5,a4,26
    800044ec:	078e                	slli	a5,a5,0x3
    800044ee:	953e                	add	a0,a0,a5
    800044f0:	611c                	ld	a5,0(a0)
    800044f2:	c385                	beqz	a5,80004512 <argfd+0x5c>
    return -1;
  if(pfd)
    800044f4:	00090463          	beqz	s2,800044fc <argfd+0x46>
    *pfd = fd;
    800044f8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044fc:	4501                	li	a0,0
  if(pf)
    800044fe:	c091                	beqz	s1,80004502 <argfd+0x4c>
    *pf = f;
    80004500:	e09c                	sd	a5,0(s1)
}
    80004502:	70a2                	ld	ra,40(sp)
    80004504:	7402                	ld	s0,32(sp)
    80004506:	64e2                	ld	s1,24(sp)
    80004508:	6942                	ld	s2,16(sp)
    8000450a:	6145                	addi	sp,sp,48
    8000450c:	8082                	ret
    return -1;
    8000450e:	557d                	li	a0,-1
    80004510:	bfcd                	j	80004502 <argfd+0x4c>
    80004512:	557d                	li	a0,-1
    80004514:	b7fd                	j	80004502 <argfd+0x4c>

0000000080004516 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004516:	1101                	addi	sp,sp,-32
    80004518:	ec06                	sd	ra,24(sp)
    8000451a:	e822                	sd	s0,16(sp)
    8000451c:	e426                	sd	s1,8(sp)
    8000451e:	1000                	addi	s0,sp,32
    80004520:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004522:	ffffd097          	auipc	ra,0xffffd
    80004526:	994080e7          	jalr	-1644(ra) # 80000eb6 <myproc>
    8000452a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000452c:	0d050793          	addi	a5,a0,208
    80004530:	4501                	li	a0,0
    80004532:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004534:	6398                	ld	a4,0(a5)
    80004536:	cb19                	beqz	a4,8000454c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004538:	2505                	addiw	a0,a0,1
    8000453a:	07a1                	addi	a5,a5,8
    8000453c:	fed51ce3          	bne	a0,a3,80004534 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004540:	557d                	li	a0,-1
}
    80004542:	60e2                	ld	ra,24(sp)
    80004544:	6442                	ld	s0,16(sp)
    80004546:	64a2                	ld	s1,8(sp)
    80004548:	6105                	addi	sp,sp,32
    8000454a:	8082                	ret
      p->ofile[fd] = f;
    8000454c:	01a50793          	addi	a5,a0,26
    80004550:	078e                	slli	a5,a5,0x3
    80004552:	963e                	add	a2,a2,a5
    80004554:	e204                	sd	s1,0(a2)
      return fd;
    80004556:	b7f5                	j	80004542 <fdalloc+0x2c>

0000000080004558 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004558:	715d                	addi	sp,sp,-80
    8000455a:	e486                	sd	ra,72(sp)
    8000455c:	e0a2                	sd	s0,64(sp)
    8000455e:	fc26                	sd	s1,56(sp)
    80004560:	f84a                	sd	s2,48(sp)
    80004562:	f44e                	sd	s3,40(sp)
    80004564:	f052                	sd	s4,32(sp)
    80004566:	ec56                	sd	s5,24(sp)
    80004568:	e85a                	sd	s6,16(sp)
    8000456a:	0880                	addi	s0,sp,80
    8000456c:	8b2e                	mv	s6,a1
    8000456e:	89b2                	mv	s3,a2
    80004570:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004572:	fb040593          	addi	a1,s0,-80
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	e7e080e7          	jalr	-386(ra) # 800033f4 <nameiparent>
    8000457e:	84aa                	mv	s1,a0
    80004580:	14050b63          	beqz	a0,800046d6 <create+0x17e>
    return 0;

  ilock(dp);
    80004584:	ffffe097          	auipc	ra,0xffffe
    80004588:	6ac080e7          	jalr	1708(ra) # 80002c30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000458c:	4601                	li	a2,0
    8000458e:	fb040593          	addi	a1,s0,-80
    80004592:	8526                	mv	a0,s1
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	b80080e7          	jalr	-1152(ra) # 80003114 <dirlookup>
    8000459c:	8aaa                	mv	s5,a0
    8000459e:	c921                	beqz	a0,800045ee <create+0x96>
    iunlockput(dp);
    800045a0:	8526                	mv	a0,s1
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	8f0080e7          	jalr	-1808(ra) # 80002e92 <iunlockput>
    ilock(ip);
    800045aa:	8556                	mv	a0,s5
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	684080e7          	jalr	1668(ra) # 80002c30 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045b4:	4789                	li	a5,2
    800045b6:	02fb1563          	bne	s6,a5,800045e0 <create+0x88>
    800045ba:	044ad783          	lhu	a5,68(s5)
    800045be:	37f9                	addiw	a5,a5,-2
    800045c0:	17c2                	slli	a5,a5,0x30
    800045c2:	93c1                	srli	a5,a5,0x30
    800045c4:	4705                	li	a4,1
    800045c6:	00f76d63          	bltu	a4,a5,800045e0 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045ca:	8556                	mv	a0,s5
    800045cc:	60a6                	ld	ra,72(sp)
    800045ce:	6406                	ld	s0,64(sp)
    800045d0:	74e2                	ld	s1,56(sp)
    800045d2:	7942                	ld	s2,48(sp)
    800045d4:	79a2                	ld	s3,40(sp)
    800045d6:	7a02                	ld	s4,32(sp)
    800045d8:	6ae2                	ld	s5,24(sp)
    800045da:	6b42                	ld	s6,16(sp)
    800045dc:	6161                	addi	sp,sp,80
    800045de:	8082                	ret
    iunlockput(ip);
    800045e0:	8556                	mv	a0,s5
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	8b0080e7          	jalr	-1872(ra) # 80002e92 <iunlockput>
    return 0;
    800045ea:	4a81                	li	s5,0
    800045ec:	bff9                	j	800045ca <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045ee:	85da                	mv	a1,s6
    800045f0:	4088                	lw	a0,0(s1)
    800045f2:	ffffe097          	auipc	ra,0xffffe
    800045f6:	4a6080e7          	jalr	1190(ra) # 80002a98 <ialloc>
    800045fa:	8a2a                	mv	s4,a0
    800045fc:	c529                	beqz	a0,80004646 <create+0xee>
  ilock(ip);
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	632080e7          	jalr	1586(ra) # 80002c30 <ilock>
  ip->major = major;
    80004606:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000460a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000460e:	4905                	li	s2,1
    80004610:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004614:	8552                	mv	a0,s4
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	54e080e7          	jalr	1358(ra) # 80002b64 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000461e:	032b0b63          	beq	s6,s2,80004654 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004622:	004a2603          	lw	a2,4(s4)
    80004626:	fb040593          	addi	a1,s0,-80
    8000462a:	8526                	mv	a0,s1
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	cf8080e7          	jalr	-776(ra) # 80003324 <dirlink>
    80004634:	06054f63          	bltz	a0,800046b2 <create+0x15a>
  iunlockput(dp);
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	858080e7          	jalr	-1960(ra) # 80002e92 <iunlockput>
  return ip;
    80004642:	8ad2                	mv	s5,s4
    80004644:	b759                	j	800045ca <create+0x72>
    iunlockput(dp);
    80004646:	8526                	mv	a0,s1
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	84a080e7          	jalr	-1974(ra) # 80002e92 <iunlockput>
    return 0;
    80004650:	8ad2                	mv	s5,s4
    80004652:	bfa5                	j	800045ca <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004654:	004a2603          	lw	a2,4(s4)
    80004658:	00004597          	auipc	a1,0x4
    8000465c:	1a858593          	addi	a1,a1,424 # 80008800 <syscall_name+0x2a8>
    80004660:	8552                	mv	a0,s4
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	cc2080e7          	jalr	-830(ra) # 80003324 <dirlink>
    8000466a:	04054463          	bltz	a0,800046b2 <create+0x15a>
    8000466e:	40d0                	lw	a2,4(s1)
    80004670:	00004597          	auipc	a1,0x4
    80004674:	19858593          	addi	a1,a1,408 # 80008808 <syscall_name+0x2b0>
    80004678:	8552                	mv	a0,s4
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	caa080e7          	jalr	-854(ra) # 80003324 <dirlink>
    80004682:	02054863          	bltz	a0,800046b2 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004686:	004a2603          	lw	a2,4(s4)
    8000468a:	fb040593          	addi	a1,s0,-80
    8000468e:	8526                	mv	a0,s1
    80004690:	fffff097          	auipc	ra,0xfffff
    80004694:	c94080e7          	jalr	-876(ra) # 80003324 <dirlink>
    80004698:	00054d63          	bltz	a0,800046b2 <create+0x15a>
    dp->nlink++;  // for ".."
    8000469c:	04a4d783          	lhu	a5,74(s1)
    800046a0:	2785                	addiw	a5,a5,1
    800046a2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046a6:	8526                	mv	a0,s1
    800046a8:	ffffe097          	auipc	ra,0xffffe
    800046ac:	4bc080e7          	jalr	1212(ra) # 80002b64 <iupdate>
    800046b0:	b761                	j	80004638 <create+0xe0>
  ip->nlink = 0;
    800046b2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046b6:	8552                	mv	a0,s4
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	4ac080e7          	jalr	1196(ra) # 80002b64 <iupdate>
  iunlockput(ip);
    800046c0:	8552                	mv	a0,s4
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	7d0080e7          	jalr	2000(ra) # 80002e92 <iunlockput>
  iunlockput(dp);
    800046ca:	8526                	mv	a0,s1
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	7c6080e7          	jalr	1990(ra) # 80002e92 <iunlockput>
  return 0;
    800046d4:	bddd                	j	800045ca <create+0x72>
    return 0;
    800046d6:	8aaa                	mv	s5,a0
    800046d8:	bdcd                	j	800045ca <create+0x72>

00000000800046da <sys_dup>:
{
    800046da:	7179                	addi	sp,sp,-48
    800046dc:	f406                	sd	ra,40(sp)
    800046de:	f022                	sd	s0,32(sp)
    800046e0:	ec26                	sd	s1,24(sp)
    800046e2:	e84a                	sd	s2,16(sp)
    800046e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046e6:	fd840613          	addi	a2,s0,-40
    800046ea:	4581                	li	a1,0
    800046ec:	4501                	li	a0,0
    800046ee:	00000097          	auipc	ra,0x0
    800046f2:	dc8080e7          	jalr	-568(ra) # 800044b6 <argfd>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046f8:	02054363          	bltz	a0,8000471e <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046fc:	fd843903          	ld	s2,-40(s0)
    80004700:	854a                	mv	a0,s2
    80004702:	00000097          	auipc	ra,0x0
    80004706:	e14080e7          	jalr	-492(ra) # 80004516 <fdalloc>
    8000470a:	84aa                	mv	s1,a0
    return -1;
    8000470c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000470e:	00054863          	bltz	a0,8000471e <sys_dup+0x44>
  filedup(f);
    80004712:	854a                	mv	a0,s2
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	334080e7          	jalr	820(ra) # 80003a48 <filedup>
  return fd;
    8000471c:	87a6                	mv	a5,s1
}
    8000471e:	853e                	mv	a0,a5
    80004720:	70a2                	ld	ra,40(sp)
    80004722:	7402                	ld	s0,32(sp)
    80004724:	64e2                	ld	s1,24(sp)
    80004726:	6942                	ld	s2,16(sp)
    80004728:	6145                	addi	sp,sp,48
    8000472a:	8082                	ret

000000008000472c <sys_read>:
{
    8000472c:	7179                	addi	sp,sp,-48
    8000472e:	f406                	sd	ra,40(sp)
    80004730:	f022                	sd	s0,32(sp)
    80004732:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004734:	fd840593          	addi	a1,s0,-40
    80004738:	4505                	li	a0,1
    8000473a:	ffffe097          	auipc	ra,0xffffe
    8000473e:	8f4080e7          	jalr	-1804(ra) # 8000202e <argaddr>
  argint(2, &n);
    80004742:	fe440593          	addi	a1,s0,-28
    80004746:	4509                	li	a0,2
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	8c6080e7          	jalr	-1850(ra) # 8000200e <argint>
  if(argfd(0, 0, &f) < 0)
    80004750:	fe840613          	addi	a2,s0,-24
    80004754:	4581                	li	a1,0
    80004756:	4501                	li	a0,0
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	d5e080e7          	jalr	-674(ra) # 800044b6 <argfd>
    80004760:	87aa                	mv	a5,a0
    return -1;
    80004762:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004764:	0007cc63          	bltz	a5,8000477c <sys_read+0x50>
  return fileread(f, p, n);
    80004768:	fe442603          	lw	a2,-28(s0)
    8000476c:	fd843583          	ld	a1,-40(s0)
    80004770:	fe843503          	ld	a0,-24(s0)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	460080e7          	jalr	1120(ra) # 80003bd4 <fileread>
}
    8000477c:	70a2                	ld	ra,40(sp)
    8000477e:	7402                	ld	s0,32(sp)
    80004780:	6145                	addi	sp,sp,48
    80004782:	8082                	ret

0000000080004784 <sys_write>:
{
    80004784:	7179                	addi	sp,sp,-48
    80004786:	f406                	sd	ra,40(sp)
    80004788:	f022                	sd	s0,32(sp)
    8000478a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000478c:	fd840593          	addi	a1,s0,-40
    80004790:	4505                	li	a0,1
    80004792:	ffffe097          	auipc	ra,0xffffe
    80004796:	89c080e7          	jalr	-1892(ra) # 8000202e <argaddr>
  argint(2, &n);
    8000479a:	fe440593          	addi	a1,s0,-28
    8000479e:	4509                	li	a0,2
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	86e080e7          	jalr	-1938(ra) # 8000200e <argint>
  if(argfd(0, 0, &f) < 0)
    800047a8:	fe840613          	addi	a2,s0,-24
    800047ac:	4581                	li	a1,0
    800047ae:	4501                	li	a0,0
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	d06080e7          	jalr	-762(ra) # 800044b6 <argfd>
    800047b8:	87aa                	mv	a5,a0
    return -1;
    800047ba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047bc:	0007cc63          	bltz	a5,800047d4 <sys_write+0x50>
  return filewrite(f, p, n);
    800047c0:	fe442603          	lw	a2,-28(s0)
    800047c4:	fd843583          	ld	a1,-40(s0)
    800047c8:	fe843503          	ld	a0,-24(s0)
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	4ca080e7          	jalr	1226(ra) # 80003c96 <filewrite>
}
    800047d4:	70a2                	ld	ra,40(sp)
    800047d6:	7402                	ld	s0,32(sp)
    800047d8:	6145                	addi	sp,sp,48
    800047da:	8082                	ret

00000000800047dc <sys_close>:
{
    800047dc:	1101                	addi	sp,sp,-32
    800047de:	ec06                	sd	ra,24(sp)
    800047e0:	e822                	sd	s0,16(sp)
    800047e2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047e4:	fe040613          	addi	a2,s0,-32
    800047e8:	fec40593          	addi	a1,s0,-20
    800047ec:	4501                	li	a0,0
    800047ee:	00000097          	auipc	ra,0x0
    800047f2:	cc8080e7          	jalr	-824(ra) # 800044b6 <argfd>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047f8:	02054463          	bltz	a0,80004820 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047fc:	ffffc097          	auipc	ra,0xffffc
    80004800:	6ba080e7          	jalr	1722(ra) # 80000eb6 <myproc>
    80004804:	fec42783          	lw	a5,-20(s0)
    80004808:	07e9                	addi	a5,a5,26
    8000480a:	078e                	slli	a5,a5,0x3
    8000480c:	953e                	add	a0,a0,a5
    8000480e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004812:	fe043503          	ld	a0,-32(s0)
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	284080e7          	jalr	644(ra) # 80003a9a <fileclose>
  return 0;
    8000481e:	4781                	li	a5,0
}
    80004820:	853e                	mv	a0,a5
    80004822:	60e2                	ld	ra,24(sp)
    80004824:	6442                	ld	s0,16(sp)
    80004826:	6105                	addi	sp,sp,32
    80004828:	8082                	ret

000000008000482a <sys_fstat>:
{
    8000482a:	1101                	addi	sp,sp,-32
    8000482c:	ec06                	sd	ra,24(sp)
    8000482e:	e822                	sd	s0,16(sp)
    80004830:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004832:	fe040593          	addi	a1,s0,-32
    80004836:	4505                	li	a0,1
    80004838:	ffffd097          	auipc	ra,0xffffd
    8000483c:	7f6080e7          	jalr	2038(ra) # 8000202e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004840:	fe840613          	addi	a2,s0,-24
    80004844:	4581                	li	a1,0
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	c6e080e7          	jalr	-914(ra) # 800044b6 <argfd>
    80004850:	87aa                	mv	a5,a0
    return -1;
    80004852:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004854:	0007ca63          	bltz	a5,80004868 <sys_fstat+0x3e>
  return filestat(f, st);
    80004858:	fe043583          	ld	a1,-32(s0)
    8000485c:	fe843503          	ld	a0,-24(s0)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	302080e7          	jalr	770(ra) # 80003b62 <filestat>
}
    80004868:	60e2                	ld	ra,24(sp)
    8000486a:	6442                	ld	s0,16(sp)
    8000486c:	6105                	addi	sp,sp,32
    8000486e:	8082                	ret

0000000080004870 <sys_link>:
{
    80004870:	7169                	addi	sp,sp,-304
    80004872:	f606                	sd	ra,296(sp)
    80004874:	f222                	sd	s0,288(sp)
    80004876:	ee26                	sd	s1,280(sp)
    80004878:	ea4a                	sd	s2,272(sp)
    8000487a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487c:	08000613          	li	a2,128
    80004880:	ed040593          	addi	a1,s0,-304
    80004884:	4501                	li	a0,0
    80004886:	ffffd097          	auipc	ra,0xffffd
    8000488a:	7c8080e7          	jalr	1992(ra) # 8000204e <argstr>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004890:	10054e63          	bltz	a0,800049ac <sys_link+0x13c>
    80004894:	08000613          	li	a2,128
    80004898:	f5040593          	addi	a1,s0,-176
    8000489c:	4505                	li	a0,1
    8000489e:	ffffd097          	auipc	ra,0xffffd
    800048a2:	7b0080e7          	jalr	1968(ra) # 8000204e <argstr>
    return -1;
    800048a6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a8:	10054263          	bltz	a0,800049ac <sys_link+0x13c>
  begin_op();
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	d2a080e7          	jalr	-726(ra) # 800035d6 <begin_op>
  if((ip = namei(old)) == 0){
    800048b4:	ed040513          	addi	a0,s0,-304
    800048b8:	fffff097          	auipc	ra,0xfffff
    800048bc:	b1e080e7          	jalr	-1250(ra) # 800033d6 <namei>
    800048c0:	84aa                	mv	s1,a0
    800048c2:	c551                	beqz	a0,8000494e <sys_link+0xde>
  ilock(ip);
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	36c080e7          	jalr	876(ra) # 80002c30 <ilock>
  if(ip->type == T_DIR){
    800048cc:	04449703          	lh	a4,68(s1)
    800048d0:	4785                	li	a5,1
    800048d2:	08f70463          	beq	a4,a5,8000495a <sys_link+0xea>
  ip->nlink++;
    800048d6:	04a4d783          	lhu	a5,74(s1)
    800048da:	2785                	addiw	a5,a5,1
    800048dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048e0:	8526                	mv	a0,s1
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	282080e7          	jalr	642(ra) # 80002b64 <iupdate>
  iunlock(ip);
    800048ea:	8526                	mv	a0,s1
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	406080e7          	jalr	1030(ra) # 80002cf2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048f4:	fd040593          	addi	a1,s0,-48
    800048f8:	f5040513          	addi	a0,s0,-176
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	af8080e7          	jalr	-1288(ra) # 800033f4 <nameiparent>
    80004904:	892a                	mv	s2,a0
    80004906:	c935                	beqz	a0,8000497a <sys_link+0x10a>
  ilock(dp);
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	328080e7          	jalr	808(ra) # 80002c30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004910:	00092703          	lw	a4,0(s2)
    80004914:	409c                	lw	a5,0(s1)
    80004916:	04f71d63          	bne	a4,a5,80004970 <sys_link+0x100>
    8000491a:	40d0                	lw	a2,4(s1)
    8000491c:	fd040593          	addi	a1,s0,-48
    80004920:	854a                	mv	a0,s2
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	a02080e7          	jalr	-1534(ra) # 80003324 <dirlink>
    8000492a:	04054363          	bltz	a0,80004970 <sys_link+0x100>
  iunlockput(dp);
    8000492e:	854a                	mv	a0,s2
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	562080e7          	jalr	1378(ra) # 80002e92 <iunlockput>
  iput(ip);
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	4b0080e7          	jalr	1200(ra) # 80002dea <iput>
  end_op();
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	d0e080e7          	jalr	-754(ra) # 80003650 <end_op>
  return 0;
    8000494a:	4781                	li	a5,0
    8000494c:	a085                	j	800049ac <sys_link+0x13c>
    end_op();
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	d02080e7          	jalr	-766(ra) # 80003650 <end_op>
    return -1;
    80004956:	57fd                	li	a5,-1
    80004958:	a891                	j	800049ac <sys_link+0x13c>
    iunlockput(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	536080e7          	jalr	1334(ra) # 80002e92 <iunlockput>
    end_op();
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	cec080e7          	jalr	-788(ra) # 80003650 <end_op>
    return -1;
    8000496c:	57fd                	li	a5,-1
    8000496e:	a83d                	j	800049ac <sys_link+0x13c>
    iunlockput(dp);
    80004970:	854a                	mv	a0,s2
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	520080e7          	jalr	1312(ra) # 80002e92 <iunlockput>
  ilock(ip);
    8000497a:	8526                	mv	a0,s1
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	2b4080e7          	jalr	692(ra) # 80002c30 <ilock>
  ip->nlink--;
    80004984:	04a4d783          	lhu	a5,74(s1)
    80004988:	37fd                	addiw	a5,a5,-1
    8000498a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	1d4080e7          	jalr	468(ra) # 80002b64 <iupdate>
  iunlockput(ip);
    80004998:	8526                	mv	a0,s1
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	4f8080e7          	jalr	1272(ra) # 80002e92 <iunlockput>
  end_op();
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	cae080e7          	jalr	-850(ra) # 80003650 <end_op>
  return -1;
    800049aa:	57fd                	li	a5,-1
}
    800049ac:	853e                	mv	a0,a5
    800049ae:	70b2                	ld	ra,296(sp)
    800049b0:	7412                	ld	s0,288(sp)
    800049b2:	64f2                	ld	s1,280(sp)
    800049b4:	6952                	ld	s2,272(sp)
    800049b6:	6155                	addi	sp,sp,304
    800049b8:	8082                	ret

00000000800049ba <sys_unlink>:
{
    800049ba:	7151                	addi	sp,sp,-240
    800049bc:	f586                	sd	ra,232(sp)
    800049be:	f1a2                	sd	s0,224(sp)
    800049c0:	eda6                	sd	s1,216(sp)
    800049c2:	e9ca                	sd	s2,208(sp)
    800049c4:	e5ce                	sd	s3,200(sp)
    800049c6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049c8:	08000613          	li	a2,128
    800049cc:	f3040593          	addi	a1,s0,-208
    800049d0:	4501                	li	a0,0
    800049d2:	ffffd097          	auipc	ra,0xffffd
    800049d6:	67c080e7          	jalr	1660(ra) # 8000204e <argstr>
    800049da:	18054163          	bltz	a0,80004b5c <sys_unlink+0x1a2>
  begin_op();
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	bf8080e7          	jalr	-1032(ra) # 800035d6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049e6:	fb040593          	addi	a1,s0,-80
    800049ea:	f3040513          	addi	a0,s0,-208
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	a06080e7          	jalr	-1530(ra) # 800033f4 <nameiparent>
    800049f6:	84aa                	mv	s1,a0
    800049f8:	c979                	beqz	a0,80004ace <sys_unlink+0x114>
  ilock(dp);
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	236080e7          	jalr	566(ra) # 80002c30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a02:	00004597          	auipc	a1,0x4
    80004a06:	dfe58593          	addi	a1,a1,-514 # 80008800 <syscall_name+0x2a8>
    80004a0a:	fb040513          	addi	a0,s0,-80
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	6ec080e7          	jalr	1772(ra) # 800030fa <namecmp>
    80004a16:	14050a63          	beqz	a0,80004b6a <sys_unlink+0x1b0>
    80004a1a:	00004597          	auipc	a1,0x4
    80004a1e:	dee58593          	addi	a1,a1,-530 # 80008808 <syscall_name+0x2b0>
    80004a22:	fb040513          	addi	a0,s0,-80
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	6d4080e7          	jalr	1748(ra) # 800030fa <namecmp>
    80004a2e:	12050e63          	beqz	a0,80004b6a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a32:	f2c40613          	addi	a2,s0,-212
    80004a36:	fb040593          	addi	a1,s0,-80
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	6d8080e7          	jalr	1752(ra) # 80003114 <dirlookup>
    80004a44:	892a                	mv	s2,a0
    80004a46:	12050263          	beqz	a0,80004b6a <sys_unlink+0x1b0>
  ilock(ip);
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	1e6080e7          	jalr	486(ra) # 80002c30 <ilock>
  if(ip->nlink < 1)
    80004a52:	04a91783          	lh	a5,74(s2)
    80004a56:	08f05263          	blez	a5,80004ada <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a5a:	04491703          	lh	a4,68(s2)
    80004a5e:	4785                	li	a5,1
    80004a60:	08f70563          	beq	a4,a5,80004aea <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a64:	4641                	li	a2,16
    80004a66:	4581                	li	a1,0
    80004a68:	fc040513          	addi	a0,s0,-64
    80004a6c:	ffffb097          	auipc	ra,0xffffb
    80004a70:	772080e7          	jalr	1906(ra) # 800001de <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a74:	4741                	li	a4,16
    80004a76:	f2c42683          	lw	a3,-212(s0)
    80004a7a:	fc040613          	addi	a2,s0,-64
    80004a7e:	4581                	li	a1,0
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	55a080e7          	jalr	1370(ra) # 80002fdc <writei>
    80004a8a:	47c1                	li	a5,16
    80004a8c:	0af51563          	bne	a0,a5,80004b36 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a90:	04491703          	lh	a4,68(s2)
    80004a94:	4785                	li	a5,1
    80004a96:	0af70863          	beq	a4,a5,80004b46 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	3f6080e7          	jalr	1014(ra) # 80002e92 <iunlockput>
  ip->nlink--;
    80004aa4:	04a95783          	lhu	a5,74(s2)
    80004aa8:	37fd                	addiw	a5,a5,-1
    80004aaa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	0b4080e7          	jalr	180(ra) # 80002b64 <iupdate>
  iunlockput(ip);
    80004ab8:	854a                	mv	a0,s2
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	3d8080e7          	jalr	984(ra) # 80002e92 <iunlockput>
  end_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	b8e080e7          	jalr	-1138(ra) # 80003650 <end_op>
  return 0;
    80004aca:	4501                	li	a0,0
    80004acc:	a84d                	j	80004b7e <sys_unlink+0x1c4>
    end_op();
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	b82080e7          	jalr	-1150(ra) # 80003650 <end_op>
    return -1;
    80004ad6:	557d                	li	a0,-1
    80004ad8:	a05d                	j	80004b7e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ada:	00004517          	auipc	a0,0x4
    80004ade:	d3650513          	addi	a0,a0,-714 # 80008810 <syscall_name+0x2b8>
    80004ae2:	00001097          	auipc	ra,0x1
    80004ae6:	1a4080e7          	jalr	420(ra) # 80005c86 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aea:	04c92703          	lw	a4,76(s2)
    80004aee:	02000793          	li	a5,32
    80004af2:	f6e7f9e3          	bgeu	a5,a4,80004a64 <sys_unlink+0xaa>
    80004af6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afa:	4741                	li	a4,16
    80004afc:	86ce                	mv	a3,s3
    80004afe:	f1840613          	addi	a2,s0,-232
    80004b02:	4581                	li	a1,0
    80004b04:	854a                	mv	a0,s2
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	3de080e7          	jalr	990(ra) # 80002ee4 <readi>
    80004b0e:	47c1                	li	a5,16
    80004b10:	00f51b63          	bne	a0,a5,80004b26 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b14:	f1845783          	lhu	a5,-232(s0)
    80004b18:	e7a1                	bnez	a5,80004b60 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b1a:	29c1                	addiw	s3,s3,16
    80004b1c:	04c92783          	lw	a5,76(s2)
    80004b20:	fcf9ede3          	bltu	s3,a5,80004afa <sys_unlink+0x140>
    80004b24:	b781                	j	80004a64 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b26:	00004517          	auipc	a0,0x4
    80004b2a:	d0250513          	addi	a0,a0,-766 # 80008828 <syscall_name+0x2d0>
    80004b2e:	00001097          	auipc	ra,0x1
    80004b32:	158080e7          	jalr	344(ra) # 80005c86 <panic>
    panic("unlink: writei");
    80004b36:	00004517          	auipc	a0,0x4
    80004b3a:	d0a50513          	addi	a0,a0,-758 # 80008840 <syscall_name+0x2e8>
    80004b3e:	00001097          	auipc	ra,0x1
    80004b42:	148080e7          	jalr	328(ra) # 80005c86 <panic>
    dp->nlink--;
    80004b46:	04a4d783          	lhu	a5,74(s1)
    80004b4a:	37fd                	addiw	a5,a5,-1
    80004b4c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b50:	8526                	mv	a0,s1
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	012080e7          	jalr	18(ra) # 80002b64 <iupdate>
    80004b5a:	b781                	j	80004a9a <sys_unlink+0xe0>
    return -1;
    80004b5c:	557d                	li	a0,-1
    80004b5e:	a005                	j	80004b7e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b60:	854a                	mv	a0,s2
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	330080e7          	jalr	816(ra) # 80002e92 <iunlockput>
  iunlockput(dp);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	326080e7          	jalr	806(ra) # 80002e92 <iunlockput>
  end_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	adc080e7          	jalr	-1316(ra) # 80003650 <end_op>
  return -1;
    80004b7c:	557d                	li	a0,-1
}
    80004b7e:	70ae                	ld	ra,232(sp)
    80004b80:	740e                	ld	s0,224(sp)
    80004b82:	64ee                	ld	s1,216(sp)
    80004b84:	694e                	ld	s2,208(sp)
    80004b86:	69ae                	ld	s3,200(sp)
    80004b88:	616d                	addi	sp,sp,240
    80004b8a:	8082                	ret

0000000080004b8c <sys_open>:

uint64
sys_open(void)
{
    80004b8c:	7131                	addi	sp,sp,-192
    80004b8e:	fd06                	sd	ra,184(sp)
    80004b90:	f922                	sd	s0,176(sp)
    80004b92:	f526                	sd	s1,168(sp)
    80004b94:	f14a                	sd	s2,160(sp)
    80004b96:	ed4e                	sd	s3,152(sp)
    80004b98:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b9a:	f4c40593          	addi	a1,s0,-180
    80004b9e:	4505                	li	a0,1
    80004ba0:	ffffd097          	auipc	ra,0xffffd
    80004ba4:	46e080e7          	jalr	1134(ra) # 8000200e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ba8:	08000613          	li	a2,128
    80004bac:	f5040593          	addi	a1,s0,-176
    80004bb0:	4501                	li	a0,0
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	49c080e7          	jalr	1180(ra) # 8000204e <argstr>
    80004bba:	87aa                	mv	a5,a0
    return -1;
    80004bbc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bbe:	0a07c863          	bltz	a5,80004c6e <sys_open+0xe2>

  begin_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	a14080e7          	jalr	-1516(ra) # 800035d6 <begin_op>

  if(omode & O_CREATE){
    80004bca:	f4c42783          	lw	a5,-180(s0)
    80004bce:	2007f793          	andi	a5,a5,512
    80004bd2:	cbdd                	beqz	a5,80004c88 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004bd4:	4681                	li	a3,0
    80004bd6:	4601                	li	a2,0
    80004bd8:	4589                	li	a1,2
    80004bda:	f5040513          	addi	a0,s0,-176
    80004bde:	00000097          	auipc	ra,0x0
    80004be2:	97a080e7          	jalr	-1670(ra) # 80004558 <create>
    80004be6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004be8:	c951                	beqz	a0,80004c7c <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bea:	04449703          	lh	a4,68(s1)
    80004bee:	478d                	li	a5,3
    80004bf0:	00f71763          	bne	a4,a5,80004bfe <sys_open+0x72>
    80004bf4:	0464d703          	lhu	a4,70(s1)
    80004bf8:	47a5                	li	a5,9
    80004bfa:	0ce7ec63          	bltu	a5,a4,80004cd2 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	de0080e7          	jalr	-544(ra) # 800039de <filealloc>
    80004c06:	892a                	mv	s2,a0
    80004c08:	c56d                	beqz	a0,80004cf2 <sys_open+0x166>
    80004c0a:	00000097          	auipc	ra,0x0
    80004c0e:	90c080e7          	jalr	-1780(ra) # 80004516 <fdalloc>
    80004c12:	89aa                	mv	s3,a0
    80004c14:	0c054a63          	bltz	a0,80004ce8 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c18:	04449703          	lh	a4,68(s1)
    80004c1c:	478d                	li	a5,3
    80004c1e:	0ef70563          	beq	a4,a5,80004d08 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c22:	4789                	li	a5,2
    80004c24:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c28:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c2c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c30:	f4c42783          	lw	a5,-180(s0)
    80004c34:	0017c713          	xori	a4,a5,1
    80004c38:	8b05                	andi	a4,a4,1
    80004c3a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c3e:	0037f713          	andi	a4,a5,3
    80004c42:	00e03733          	snez	a4,a4
    80004c46:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c4a:	4007f793          	andi	a5,a5,1024
    80004c4e:	c791                	beqz	a5,80004c5a <sys_open+0xce>
    80004c50:	04449703          	lh	a4,68(s1)
    80004c54:	4789                	li	a5,2
    80004c56:	0cf70063          	beq	a4,a5,80004d16 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c5a:	8526                	mv	a0,s1
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	096080e7          	jalr	150(ra) # 80002cf2 <iunlock>
  end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	9ec080e7          	jalr	-1556(ra) # 80003650 <end_op>

  return fd;
    80004c6c:	854e                	mv	a0,s3
}
    80004c6e:	70ea                	ld	ra,184(sp)
    80004c70:	744a                	ld	s0,176(sp)
    80004c72:	74aa                	ld	s1,168(sp)
    80004c74:	790a                	ld	s2,160(sp)
    80004c76:	69ea                	ld	s3,152(sp)
    80004c78:	6129                	addi	sp,sp,192
    80004c7a:	8082                	ret
      end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	9d4080e7          	jalr	-1580(ra) # 80003650 <end_op>
      return -1;
    80004c84:	557d                	li	a0,-1
    80004c86:	b7e5                	j	80004c6e <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c88:	f5040513          	addi	a0,s0,-176
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	74a080e7          	jalr	1866(ra) # 800033d6 <namei>
    80004c94:	84aa                	mv	s1,a0
    80004c96:	c905                	beqz	a0,80004cc6 <sys_open+0x13a>
    ilock(ip);
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	f98080e7          	jalr	-104(ra) # 80002c30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ca0:	04449703          	lh	a4,68(s1)
    80004ca4:	4785                	li	a5,1
    80004ca6:	f4f712e3          	bne	a4,a5,80004bea <sys_open+0x5e>
    80004caa:	f4c42783          	lw	a5,-180(s0)
    80004cae:	dba1                	beqz	a5,80004bfe <sys_open+0x72>
      iunlockput(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	1e0080e7          	jalr	480(ra) # 80002e92 <iunlockput>
      end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	996080e7          	jalr	-1642(ra) # 80003650 <end_op>
      return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	b76d                	j	80004c6e <sys_open+0xe2>
      end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	98a080e7          	jalr	-1654(ra) # 80003650 <end_op>
      return -1;
    80004cce:	557d                	li	a0,-1
    80004cd0:	bf79                	j	80004c6e <sys_open+0xe2>
    iunlockput(ip);
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	1be080e7          	jalr	446(ra) # 80002e92 <iunlockput>
    end_op();
    80004cdc:	fffff097          	auipc	ra,0xfffff
    80004ce0:	974080e7          	jalr	-1676(ra) # 80003650 <end_op>
    return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	b761                	j	80004c6e <sys_open+0xe2>
      fileclose(f);
    80004ce8:	854a                	mv	a0,s2
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	db0080e7          	jalr	-592(ra) # 80003a9a <fileclose>
    iunlockput(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	19e080e7          	jalr	414(ra) # 80002e92 <iunlockput>
    end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	954080e7          	jalr	-1708(ra) # 80003650 <end_op>
    return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	b7a5                	j	80004c6e <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004d08:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004d0c:	04649783          	lh	a5,70(s1)
    80004d10:	02f91223          	sh	a5,36(s2)
    80004d14:	bf21                	j	80004c2c <sys_open+0xa0>
    itrunc(ip);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	026080e7          	jalr	38(ra) # 80002d3e <itrunc>
    80004d20:	bf2d                	j	80004c5a <sys_open+0xce>

0000000080004d22 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d22:	7175                	addi	sp,sp,-144
    80004d24:	e506                	sd	ra,136(sp)
    80004d26:	e122                	sd	s0,128(sp)
    80004d28:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	8ac080e7          	jalr	-1876(ra) # 800035d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d32:	08000613          	li	a2,128
    80004d36:	f7040593          	addi	a1,s0,-144
    80004d3a:	4501                	li	a0,0
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	312080e7          	jalr	786(ra) # 8000204e <argstr>
    80004d44:	02054963          	bltz	a0,80004d76 <sys_mkdir+0x54>
    80004d48:	4681                	li	a3,0
    80004d4a:	4601                	li	a2,0
    80004d4c:	4585                	li	a1,1
    80004d4e:	f7040513          	addi	a0,s0,-144
    80004d52:	00000097          	auipc	ra,0x0
    80004d56:	806080e7          	jalr	-2042(ra) # 80004558 <create>
    80004d5a:	cd11                	beqz	a0,80004d76 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	136080e7          	jalr	310(ra) # 80002e92 <iunlockput>
  end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	8ec080e7          	jalr	-1812(ra) # 80003650 <end_op>
  return 0;
    80004d6c:	4501                	li	a0,0
}
    80004d6e:	60aa                	ld	ra,136(sp)
    80004d70:	640a                	ld	s0,128(sp)
    80004d72:	6149                	addi	sp,sp,144
    80004d74:	8082                	ret
    end_op();
    80004d76:	fffff097          	auipc	ra,0xfffff
    80004d7a:	8da080e7          	jalr	-1830(ra) # 80003650 <end_op>
    return -1;
    80004d7e:	557d                	li	a0,-1
    80004d80:	b7fd                	j	80004d6e <sys_mkdir+0x4c>

0000000080004d82 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d82:	7135                	addi	sp,sp,-160
    80004d84:	ed06                	sd	ra,152(sp)
    80004d86:	e922                	sd	s0,144(sp)
    80004d88:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	84c080e7          	jalr	-1972(ra) # 800035d6 <begin_op>
  argint(1, &major);
    80004d92:	f6c40593          	addi	a1,s0,-148
    80004d96:	4505                	li	a0,1
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	276080e7          	jalr	630(ra) # 8000200e <argint>
  argint(2, &minor);
    80004da0:	f6840593          	addi	a1,s0,-152
    80004da4:	4509                	li	a0,2
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	268080e7          	jalr	616(ra) # 8000200e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dae:	08000613          	li	a2,128
    80004db2:	f7040593          	addi	a1,s0,-144
    80004db6:	4501                	li	a0,0
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	296080e7          	jalr	662(ra) # 8000204e <argstr>
    80004dc0:	02054b63          	bltz	a0,80004df6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dc4:	f6841683          	lh	a3,-152(s0)
    80004dc8:	f6c41603          	lh	a2,-148(s0)
    80004dcc:	458d                	li	a1,3
    80004dce:	f7040513          	addi	a0,s0,-144
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	786080e7          	jalr	1926(ra) # 80004558 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dda:	cd11                	beqz	a0,80004df6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	0b6080e7          	jalr	182(ra) # 80002e92 <iunlockput>
  end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	86c080e7          	jalr	-1940(ra) # 80003650 <end_op>
  return 0;
    80004dec:	4501                	li	a0,0
}
    80004dee:	60ea                	ld	ra,152(sp)
    80004df0:	644a                	ld	s0,144(sp)
    80004df2:	610d                	addi	sp,sp,160
    80004df4:	8082                	ret
    end_op();
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	85a080e7          	jalr	-1958(ra) # 80003650 <end_op>
    return -1;
    80004dfe:	557d                	li	a0,-1
    80004e00:	b7fd                	j	80004dee <sys_mknod+0x6c>

0000000080004e02 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e02:	7135                	addi	sp,sp,-160
    80004e04:	ed06                	sd	ra,152(sp)
    80004e06:	e922                	sd	s0,144(sp)
    80004e08:	e526                	sd	s1,136(sp)
    80004e0a:	e14a                	sd	s2,128(sp)
    80004e0c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e0e:	ffffc097          	auipc	ra,0xffffc
    80004e12:	0a8080e7          	jalr	168(ra) # 80000eb6 <myproc>
    80004e16:	892a                	mv	s2,a0
  
  begin_op();
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	7be080e7          	jalr	1982(ra) # 800035d6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e20:	08000613          	li	a2,128
    80004e24:	f6040593          	addi	a1,s0,-160
    80004e28:	4501                	li	a0,0
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	224080e7          	jalr	548(ra) # 8000204e <argstr>
    80004e32:	04054b63          	bltz	a0,80004e88 <sys_chdir+0x86>
    80004e36:	f6040513          	addi	a0,s0,-160
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	59c080e7          	jalr	1436(ra) # 800033d6 <namei>
    80004e42:	84aa                	mv	s1,a0
    80004e44:	c131                	beqz	a0,80004e88 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	dea080e7          	jalr	-534(ra) # 80002c30 <ilock>
  if(ip->type != T_DIR){
    80004e4e:	04449703          	lh	a4,68(s1)
    80004e52:	4785                	li	a5,1
    80004e54:	04f71063          	bne	a4,a5,80004e94 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	e98080e7          	jalr	-360(ra) # 80002cf2 <iunlock>
  iput(p->cwd);
    80004e62:	15093503          	ld	a0,336(s2)
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	f84080e7          	jalr	-124(ra) # 80002dea <iput>
  end_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	7e2080e7          	jalr	2018(ra) # 80003650 <end_op>
  p->cwd = ip;
    80004e76:	14993823          	sd	s1,336(s2)
  return 0;
    80004e7a:	4501                	li	a0,0
}
    80004e7c:	60ea                	ld	ra,152(sp)
    80004e7e:	644a                	ld	s0,144(sp)
    80004e80:	64aa                	ld	s1,136(sp)
    80004e82:	690a                	ld	s2,128(sp)
    80004e84:	610d                	addi	sp,sp,160
    80004e86:	8082                	ret
    end_op();
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	7c8080e7          	jalr	1992(ra) # 80003650 <end_op>
    return -1;
    80004e90:	557d                	li	a0,-1
    80004e92:	b7ed                	j	80004e7c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	ffc080e7          	jalr	-4(ra) # 80002e92 <iunlockput>
    end_op();
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	7b2080e7          	jalr	1970(ra) # 80003650 <end_op>
    return -1;
    80004ea6:	557d                	li	a0,-1
    80004ea8:	bfd1                	j	80004e7c <sys_chdir+0x7a>

0000000080004eaa <sys_exec>:

uint64
sys_exec(void)
{
    80004eaa:	7121                	addi	sp,sp,-448
    80004eac:	ff06                	sd	ra,440(sp)
    80004eae:	fb22                	sd	s0,432(sp)
    80004eb0:	f726                	sd	s1,424(sp)
    80004eb2:	f34a                	sd	s2,416(sp)
    80004eb4:	ef4e                	sd	s3,408(sp)
    80004eb6:	eb52                	sd	s4,400(sp)
    80004eb8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004eba:	e4840593          	addi	a1,s0,-440
    80004ebe:	4505                	li	a0,1
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	16e080e7          	jalr	366(ra) # 8000202e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ec8:	08000613          	li	a2,128
    80004ecc:	f5040593          	addi	a1,s0,-176
    80004ed0:	4501                	li	a0,0
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	17c080e7          	jalr	380(ra) # 8000204e <argstr>
    80004eda:	87aa                	mv	a5,a0
    return -1;
    80004edc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ede:	0c07c263          	bltz	a5,80004fa2 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004ee2:	10000613          	li	a2,256
    80004ee6:	4581                	li	a1,0
    80004ee8:	e5040513          	addi	a0,s0,-432
    80004eec:	ffffb097          	auipc	ra,0xffffb
    80004ef0:	2f2080e7          	jalr	754(ra) # 800001de <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ef4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ef8:	89a6                	mv	s3,s1
    80004efa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004efc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f00:	00391513          	slli	a0,s2,0x3
    80004f04:	e4040593          	addi	a1,s0,-448
    80004f08:	e4843783          	ld	a5,-440(s0)
    80004f0c:	953e                	add	a0,a0,a5
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	062080e7          	jalr	98(ra) # 80001f70 <fetchaddr>
    80004f16:	02054a63          	bltz	a0,80004f4a <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004f1a:	e4043783          	ld	a5,-448(s0)
    80004f1e:	c3b9                	beqz	a5,80004f64 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f20:	ffffb097          	auipc	ra,0xffffb
    80004f24:	25e080e7          	jalr	606(ra) # 8000017e <kalloc>
    80004f28:	85aa                	mv	a1,a0
    80004f2a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f2e:	cd11                	beqz	a0,80004f4a <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f30:	6605                	lui	a2,0x1
    80004f32:	e4043503          	ld	a0,-448(s0)
    80004f36:	ffffd097          	auipc	ra,0xffffd
    80004f3a:	08c080e7          	jalr	140(ra) # 80001fc2 <fetchstr>
    80004f3e:	00054663          	bltz	a0,80004f4a <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f42:	0905                	addi	s2,s2,1
    80004f44:	09a1                	addi	s3,s3,8
    80004f46:	fb491de3          	bne	s2,s4,80004f00 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4a:	f5040913          	addi	s2,s0,-176
    80004f4e:	6088                	ld	a0,0(s1)
    80004f50:	c921                	beqz	a0,80004fa0 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f52:	ffffb097          	auipc	ra,0xffffb
    80004f56:	12e080e7          	jalr	302(ra) # 80000080 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5a:	04a1                	addi	s1,s1,8
    80004f5c:	ff2499e3          	bne	s1,s2,80004f4e <sys_exec+0xa4>
  return -1;
    80004f60:	557d                	li	a0,-1
    80004f62:	a081                	j	80004fa2 <sys_exec+0xf8>
      argv[i] = 0;
    80004f64:	0009079b          	sext.w	a5,s2
    80004f68:	078e                	slli	a5,a5,0x3
    80004f6a:	fd078793          	addi	a5,a5,-48
    80004f6e:	97a2                	add	a5,a5,s0
    80004f70:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f74:	e5040593          	addi	a1,s0,-432
    80004f78:	f5040513          	addi	a0,s0,-176
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	194080e7          	jalr	404(ra) # 80004110 <exec>
    80004f84:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f86:	f5040993          	addi	s3,s0,-176
    80004f8a:	6088                	ld	a0,0(s1)
    80004f8c:	c901                	beqz	a0,80004f9c <sys_exec+0xf2>
    kfree(argv[i]);
    80004f8e:	ffffb097          	auipc	ra,0xffffb
    80004f92:	0f2080e7          	jalr	242(ra) # 80000080 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f96:	04a1                	addi	s1,s1,8
    80004f98:	ff3499e3          	bne	s1,s3,80004f8a <sys_exec+0xe0>
  return ret;
    80004f9c:	854a                	mv	a0,s2
    80004f9e:	a011                	j	80004fa2 <sys_exec+0xf8>
  return -1;
    80004fa0:	557d                	li	a0,-1
}
    80004fa2:	70fa                	ld	ra,440(sp)
    80004fa4:	745a                	ld	s0,432(sp)
    80004fa6:	74ba                	ld	s1,424(sp)
    80004fa8:	791a                	ld	s2,416(sp)
    80004faa:	69fa                	ld	s3,408(sp)
    80004fac:	6a5a                	ld	s4,400(sp)
    80004fae:	6139                	addi	sp,sp,448
    80004fb0:	8082                	ret

0000000080004fb2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fb2:	7139                	addi	sp,sp,-64
    80004fb4:	fc06                	sd	ra,56(sp)
    80004fb6:	f822                	sd	s0,48(sp)
    80004fb8:	f426                	sd	s1,40(sp)
    80004fba:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	efa080e7          	jalr	-262(ra) # 80000eb6 <myproc>
    80004fc4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fc6:	fd840593          	addi	a1,s0,-40
    80004fca:	4501                	li	a0,0
    80004fcc:	ffffd097          	auipc	ra,0xffffd
    80004fd0:	062080e7          	jalr	98(ra) # 8000202e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fd4:	fc840593          	addi	a1,s0,-56
    80004fd8:	fd040513          	addi	a0,s0,-48
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	dea080e7          	jalr	-534(ra) # 80003dc6 <pipealloc>
    return -1;
    80004fe4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe6:	0c054463          	bltz	a0,800050ae <sys_pipe+0xfc>
  fd0 = -1;
    80004fea:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fee:	fd043503          	ld	a0,-48(s0)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	524080e7          	jalr	1316(ra) # 80004516 <fdalloc>
    80004ffa:	fca42223          	sw	a0,-60(s0)
    80004ffe:	08054b63          	bltz	a0,80005094 <sys_pipe+0xe2>
    80005002:	fc843503          	ld	a0,-56(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	510080e7          	jalr	1296(ra) # 80004516 <fdalloc>
    8000500e:	fca42023          	sw	a0,-64(s0)
    80005012:	06054863          	bltz	a0,80005082 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005016:	4691                	li	a3,4
    80005018:	fc440613          	addi	a2,s0,-60
    8000501c:	fd843583          	ld	a1,-40(s0)
    80005020:	68a8                	ld	a0,80(s1)
    80005022:	ffffc097          	auipc	ra,0xffffc
    80005026:	b54080e7          	jalr	-1196(ra) # 80000b76 <copyout>
    8000502a:	02054063          	bltz	a0,8000504a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000502e:	4691                	li	a3,4
    80005030:	fc040613          	addi	a2,s0,-64
    80005034:	fd843583          	ld	a1,-40(s0)
    80005038:	0591                	addi	a1,a1,4
    8000503a:	68a8                	ld	a0,80(s1)
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	b3a080e7          	jalr	-1222(ra) # 80000b76 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005044:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005046:	06055463          	bgez	a0,800050ae <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000504a:	fc442783          	lw	a5,-60(s0)
    8000504e:	07e9                	addi	a5,a5,26
    80005050:	078e                	slli	a5,a5,0x3
    80005052:	97a6                	add	a5,a5,s1
    80005054:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005058:	fc042783          	lw	a5,-64(s0)
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	94be                	add	s1,s1,a5
    80005062:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005066:	fd043503          	ld	a0,-48(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	a30080e7          	jalr	-1488(ra) # 80003a9a <fileclose>
    fileclose(wf);
    80005072:	fc843503          	ld	a0,-56(s0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	a24080e7          	jalr	-1500(ra) # 80003a9a <fileclose>
    return -1;
    8000507e:	57fd                	li	a5,-1
    80005080:	a03d                	j	800050ae <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005082:	fc442783          	lw	a5,-60(s0)
    80005086:	0007c763          	bltz	a5,80005094 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000508a:	07e9                	addi	a5,a5,26
    8000508c:	078e                	slli	a5,a5,0x3
    8000508e:	97a6                	add	a5,a5,s1
    80005090:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005094:	fd043503          	ld	a0,-48(s0)
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	a02080e7          	jalr	-1534(ra) # 80003a9a <fileclose>
    fileclose(wf);
    800050a0:	fc843503          	ld	a0,-56(s0)
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	9f6080e7          	jalr	-1546(ra) # 80003a9a <fileclose>
    return -1;
    800050ac:	57fd                	li	a5,-1
}
    800050ae:	853e                	mv	a0,a5
    800050b0:	70e2                	ld	ra,56(sp)
    800050b2:	7442                	ld	s0,48(sp)
    800050b4:	74a2                	ld	s1,40(sp)
    800050b6:	6121                	addi	sp,sp,64
    800050b8:	8082                	ret
    800050ba:	0000                	unimp
    800050bc:	0000                	unimp
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	d3dfc0ef          	jal	ra,80001e3c <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	addi	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	addi	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cf2080e7          	jalr	-782(ra) # 80000e8a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	slliw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
    800051bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	cba080e7          	jalr	-838(ra) # 80000e8a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5151b          	slliw	a0,a0,0xd
    800051dc:	0c2017b7          	lui	a5,0xc201
    800051e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e2:	43c8                	lw	a0,4(a5)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	addi	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	addi	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c92080e7          	jalr	-878(ra) # 80000e8a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	slliw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	04a7cc63          	blt	a5,a0,80005278 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00015797          	auipc	a5,0x15
    80005228:	b3c78793          	addi	a5,a5,-1220 # 80019d60 <disk>
    8000522c:	97aa                	add	a5,a5,a0
    8000522e:	0187c783          	lbu	a5,24(a5)
    80005232:	ebb9                	bnez	a5,80005288 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005234:	00451693          	slli	a3,a0,0x4
    80005238:	00015797          	auipc	a5,0x15
    8000523c:	b2878793          	addi	a5,a5,-1240 # 80019d60 <disk>
    80005240:	6398                	ld	a4,0(a5)
    80005242:	9736                	add	a4,a4,a3
    80005244:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	9736                	add	a4,a4,a3
    8000524c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005250:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005254:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005258:	97aa                	add	a5,a5,a0
    8000525a:	4705                	li	a4,1
    8000525c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005260:	00015517          	auipc	a0,0x15
    80005264:	b1850513          	addi	a0,a0,-1256 # 80019d78 <disk+0x18>
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	398080e7          	jalr	920(ra) # 80001600 <wakeup>
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret
    panic("free_desc 1");
    80005278:	00003517          	auipc	a0,0x3
    8000527c:	5d850513          	addi	a0,a0,1496 # 80008850 <syscall_name+0x2f8>
    80005280:	00001097          	auipc	ra,0x1
    80005284:	a06080e7          	jalr	-1530(ra) # 80005c86 <panic>
    panic("free_desc 2");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	5d850513          	addi	a0,a0,1496 # 80008860 <syscall_name+0x308>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	9f6080e7          	jalr	-1546(ra) # 80005c86 <panic>

0000000080005298 <virtio_disk_init>:
{
    80005298:	1101                	addi	sp,sp,-32
    8000529a:	ec06                	sd	ra,24(sp)
    8000529c:	e822                	sd	s0,16(sp)
    8000529e:	e426                	sd	s1,8(sp)
    800052a0:	e04a                	sd	s2,0(sp)
    800052a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052a4:	00003597          	auipc	a1,0x3
    800052a8:	5cc58593          	addi	a1,a1,1484 # 80008870 <syscall_name+0x318>
    800052ac:	00015517          	auipc	a0,0x15
    800052b0:	bdc50513          	addi	a0,a0,-1060 # 80019e88 <disk+0x128>
    800052b4:	00001097          	auipc	ra,0x1
    800052b8:	e7a080e7          	jalr	-390(ra) # 8000612e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	4398                	lw	a4,0(a5)
    800052c2:	2701                	sext.w	a4,a4
    800052c4:	747277b7          	lui	a5,0x74727
    800052c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052cc:	14f71b63          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052d0:	100017b7          	lui	a5,0x10001
    800052d4:	43dc                	lw	a5,4(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d8:	4709                	li	a4,2
    800052da:	14e79463          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e6:	12e79e63          	bne	a5,a4,80005422 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ea:	100017b7          	lui	a5,0x10001
    800052ee:	47d8                	lw	a4,12(a5)
    800052f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f2:	554d47b7          	lui	a5,0x554d4
    800052f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052fa:	12f71463          	bne	a4,a5,80005422 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005306:	4705                	li	a4,1
    80005308:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530a:	470d                	li	a4,3
    8000530c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000530e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	c7ffe6b7          	lui	a3,0xc7ffe
    80005314:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc67f>
    80005318:	8f75                	and	a4,a4,a3
    8000531a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531c:	472d                	li	a4,11
    8000531e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005320:	5bbc                	lw	a5,112(a5)
    80005322:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005326:	8ba1                	andi	a5,a5,8
    80005328:	10078563          	beqz	a5,80005432 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000532c:	100017b7          	lui	a5,0x10001
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005334:	43fc                	lw	a5,68(a5)
    80005336:	2781                	sext.w	a5,a5
    80005338:	10079563          	bnez	a5,80005442 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000533c:	100017b7          	lui	a5,0x10001
    80005340:	5bdc                	lw	a5,52(a5)
    80005342:	2781                	sext.w	a5,a5
  if(max == 0)
    80005344:	10078763          	beqz	a5,80005452 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005348:	471d                	li	a4,7
    8000534a:	10f77c63          	bgeu	a4,a5,80005462 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	e30080e7          	jalr	-464(ra) # 8000017e <kalloc>
    80005356:	00015497          	auipc	s1,0x15
    8000535a:	a0a48493          	addi	s1,s1,-1526 # 80019d60 <disk>
    8000535e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005360:	ffffb097          	auipc	ra,0xffffb
    80005364:	e1e080e7          	jalr	-482(ra) # 8000017e <kalloc>
    80005368:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000536a:	ffffb097          	auipc	ra,0xffffb
    8000536e:	e14080e7          	jalr	-492(ra) # 8000017e <kalloc>
    80005372:	87aa                	mv	a5,a0
    80005374:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005376:	6088                	ld	a0,0(s1)
    80005378:	cd6d                	beqz	a0,80005472 <virtio_disk_init+0x1da>
    8000537a:	00015717          	auipc	a4,0x15
    8000537e:	9ee73703          	ld	a4,-1554(a4) # 80019d68 <disk+0x8>
    80005382:	cb65                	beqz	a4,80005472 <virtio_disk_init+0x1da>
    80005384:	c7fd                	beqz	a5,80005472 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005386:	6605                	lui	a2,0x1
    80005388:	4581                	li	a1,0
    8000538a:	ffffb097          	auipc	ra,0xffffb
    8000538e:	e54080e7          	jalr	-428(ra) # 800001de <memset>
  memset(disk.avail, 0, PGSIZE);
    80005392:	00015497          	auipc	s1,0x15
    80005396:	9ce48493          	addi	s1,s1,-1586 # 80019d60 <disk>
    8000539a:	6605                	lui	a2,0x1
    8000539c:	4581                	li	a1,0
    8000539e:	6488                	ld	a0,8(s1)
    800053a0:	ffffb097          	auipc	ra,0xffffb
    800053a4:	e3e080e7          	jalr	-450(ra) # 800001de <memset>
  memset(disk.used, 0, PGSIZE);
    800053a8:	6605                	lui	a2,0x1
    800053aa:	4581                	li	a1,0
    800053ac:	6888                	ld	a0,16(s1)
    800053ae:	ffffb097          	auipc	ra,0xffffb
    800053b2:	e30080e7          	jalr	-464(ra) # 800001de <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053b6:	100017b7          	lui	a5,0x10001
    800053ba:	4721                	li	a4,8
    800053bc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053be:	4098                	lw	a4,0(s1)
    800053c0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053c4:	40d8                	lw	a4,4(s1)
    800053c6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ca:	6498                	ld	a4,8(s1)
    800053cc:	0007069b          	sext.w	a3,a4
    800053d0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053d4:	9701                	srai	a4,a4,0x20
    800053d6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053da:	6898                	ld	a4,16(s1)
    800053dc:	0007069b          	sext.w	a3,a4
    800053e0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053e4:	9701                	srai	a4,a4,0x20
    800053e6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ea:	4705                	li	a4,1
    800053ec:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053ee:	00e48c23          	sb	a4,24(s1)
    800053f2:	00e48ca3          	sb	a4,25(s1)
    800053f6:	00e48d23          	sb	a4,26(s1)
    800053fa:	00e48da3          	sb	a4,27(s1)
    800053fe:	00e48e23          	sb	a4,28(s1)
    80005402:	00e48ea3          	sb	a4,29(s1)
    80005406:	00e48f23          	sb	a4,30(s1)
    8000540a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000540e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005412:	0727a823          	sw	s2,112(a5)
}
    80005416:	60e2                	ld	ra,24(sp)
    80005418:	6442                	ld	s0,16(sp)
    8000541a:	64a2                	ld	s1,8(sp)
    8000541c:	6902                	ld	s2,0(sp)
    8000541e:	6105                	addi	sp,sp,32
    80005420:	8082                	ret
    panic("could not find virtio disk");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	45e50513          	addi	a0,a0,1118 # 80008880 <syscall_name+0x328>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	85c080e7          	jalr	-1956(ra) # 80005c86 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	46e50513          	addi	a0,a0,1134 # 800088a0 <syscall_name+0x348>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	84c080e7          	jalr	-1972(ra) # 80005c86 <panic>
    panic("virtio disk should not be ready");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	47e50513          	addi	a0,a0,1150 # 800088c0 <syscall_name+0x368>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	83c080e7          	jalr	-1988(ra) # 80005c86 <panic>
    panic("virtio disk has no queue 0");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	48e50513          	addi	a0,a0,1166 # 800088e0 <syscall_name+0x388>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	82c080e7          	jalr	-2004(ra) # 80005c86 <panic>
    panic("virtio disk max queue too short");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	49e50513          	addi	a0,a0,1182 # 80008900 <syscall_name+0x3a8>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	81c080e7          	jalr	-2020(ra) # 80005c86 <panic>
    panic("virtio disk kalloc");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	4ae50513          	addi	a0,a0,1198 # 80008920 <syscall_name+0x3c8>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	80c080e7          	jalr	-2036(ra) # 80005c86 <panic>

0000000080005482 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005482:	7159                	addi	sp,sp,-112
    80005484:	f486                	sd	ra,104(sp)
    80005486:	f0a2                	sd	s0,96(sp)
    80005488:	eca6                	sd	s1,88(sp)
    8000548a:	e8ca                	sd	s2,80(sp)
    8000548c:	e4ce                	sd	s3,72(sp)
    8000548e:	e0d2                	sd	s4,64(sp)
    80005490:	fc56                	sd	s5,56(sp)
    80005492:	f85a                	sd	s6,48(sp)
    80005494:	f45e                	sd	s7,40(sp)
    80005496:	f062                	sd	s8,32(sp)
    80005498:	ec66                	sd	s9,24(sp)
    8000549a:	e86a                	sd	s10,16(sp)
    8000549c:	1880                	addi	s0,sp,112
    8000549e:	8a2a                	mv	s4,a0
    800054a0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054a2:	00c52c83          	lw	s9,12(a0)
    800054a6:	001c9c9b          	slliw	s9,s9,0x1
    800054aa:	1c82                	slli	s9,s9,0x20
    800054ac:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054b0:	00015517          	auipc	a0,0x15
    800054b4:	9d850513          	addi	a0,a0,-1576 # 80019e88 <disk+0x128>
    800054b8:	00001097          	auipc	ra,0x1
    800054bc:	d06080e7          	jalr	-762(ra) # 800061be <acquire>
  for(int i = 0; i < 3; i++){
    800054c0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054c2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054c4:	00015b17          	auipc	s6,0x15
    800054c8:	89cb0b13          	addi	s6,s6,-1892 # 80019d60 <disk>
  for(int i = 0; i < 3; i++){
    800054cc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054ce:	00015c17          	auipc	s8,0x15
    800054d2:	9bac0c13          	addi	s8,s8,-1606 # 80019e88 <disk+0x128>
    800054d6:	a095                	j	8000553a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054d8:	00fb0733          	add	a4,s6,a5
    800054dc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054e0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054e2:	0207c563          	bltz	a5,8000550c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054e6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054e8:	0591                	addi	a1,a1,4
    800054ea:	05560d63          	beq	a2,s5,80005544 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054ee:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054f0:	00015717          	auipc	a4,0x15
    800054f4:	87070713          	addi	a4,a4,-1936 # 80019d60 <disk>
    800054f8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054fa:	01874683          	lbu	a3,24(a4)
    800054fe:	fee9                	bnez	a3,800054d8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005500:	2785                	addiw	a5,a5,1
    80005502:	0705                	addi	a4,a4,1
    80005504:	fe979be3          	bne	a5,s1,800054fa <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005508:	57fd                	li	a5,-1
    8000550a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000550c:	00c05e63          	blez	a2,80005528 <virtio_disk_rw+0xa6>
    80005510:	060a                	slli	a2,a2,0x2
    80005512:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005516:	0009a503          	lw	a0,0(s3)
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	cfc080e7          	jalr	-772(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    80005522:	0991                	addi	s3,s3,4
    80005524:	ffa999e3          	bne	s3,s10,80005516 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005528:	85e2                	mv	a1,s8
    8000552a:	00015517          	auipc	a0,0x15
    8000552e:	84e50513          	addi	a0,a0,-1970 # 80019d78 <disk+0x18>
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	06a080e7          	jalr	106(ra) # 8000159c <sleep>
  for(int i = 0; i < 3; i++){
    8000553a:	f9040993          	addi	s3,s0,-112
{
    8000553e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005540:	864a                	mv	a2,s2
    80005542:	b775                	j	800054ee <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005544:	f9042503          	lw	a0,-112(s0)
    80005548:	00a50713          	addi	a4,a0,10
    8000554c:	0712                	slli	a4,a4,0x4

  if(write)
    8000554e:	00015797          	auipc	a5,0x15
    80005552:	81278793          	addi	a5,a5,-2030 # 80019d60 <disk>
    80005556:	00e786b3          	add	a3,a5,a4
    8000555a:	01703633          	snez	a2,s7
    8000555e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005560:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005564:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005568:	f6070613          	addi	a2,a4,-160
    8000556c:	6394                	ld	a3,0(a5)
    8000556e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005570:	00870593          	addi	a1,a4,8
    80005574:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005576:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005578:	0007b803          	ld	a6,0(a5)
    8000557c:	9642                	add	a2,a2,a6
    8000557e:	46c1                	li	a3,16
    80005580:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005582:	4585                	li	a1,1
    80005584:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f9442683          	lw	a3,-108(s0)
    8000558c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005590:	0692                	slli	a3,a3,0x4
    80005592:	9836                	add	a6,a6,a3
    80005594:	058a0613          	addi	a2,s4,88
    80005598:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000559c:	0007b803          	ld	a6,0(a5)
    800055a0:	96c2                	add	a3,a3,a6
    800055a2:	40000613          	li	a2,1024
    800055a6:	c690                	sw	a2,8(a3)
  if(write)
    800055a8:	001bb613          	seqz	a2,s7
    800055ac:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055b0:	00166613          	ori	a2,a2,1
    800055b4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055b8:	f9842603          	lw	a2,-104(s0)
    800055bc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055c0:	00250693          	addi	a3,a0,2
    800055c4:	0692                	slli	a3,a3,0x4
    800055c6:	96be                	add	a3,a3,a5
    800055c8:	58fd                	li	a7,-1
    800055ca:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ce:	0612                	slli	a2,a2,0x4
    800055d0:	9832                	add	a6,a6,a2
    800055d2:	f9070713          	addi	a4,a4,-112
    800055d6:	973e                	add	a4,a4,a5
    800055d8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055dc:	6398                	ld	a4,0(a5)
    800055de:	9732                	add	a4,a4,a2
    800055e0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055e2:	4609                	li	a2,2
    800055e4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055e8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055ec:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055f0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055f4:	6794                	ld	a3,8(a5)
    800055f6:	0026d703          	lhu	a4,2(a3)
    800055fa:	8b1d                	andi	a4,a4,7
    800055fc:	0706                	slli	a4,a4,0x1
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005604:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005608:	6798                	ld	a4,8(a5)
    8000560a:	00275783          	lhu	a5,2(a4)
    8000560e:	2785                	addiw	a5,a5,1
    80005610:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005614:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005620:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005624:	00015917          	auipc	s2,0x15
    80005628:	86490913          	addi	s2,s2,-1948 # 80019e88 <disk+0x128>
  while(b->disk == 1) {
    8000562c:	4485                	li	s1,1
    8000562e:	00b79c63          	bne	a5,a1,80005646 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005632:	85ca                	mv	a1,s2
    80005634:	8552                	mv	a0,s4
    80005636:	ffffc097          	auipc	ra,0xffffc
    8000563a:	f66080e7          	jalr	-154(ra) # 8000159c <sleep>
  while(b->disk == 1) {
    8000563e:	004a2783          	lw	a5,4(s4)
    80005642:	fe9788e3          	beq	a5,s1,80005632 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005646:	f9042903          	lw	s2,-112(s0)
    8000564a:	00290713          	addi	a4,s2,2
    8000564e:	0712                	slli	a4,a4,0x4
    80005650:	00014797          	auipc	a5,0x14
    80005654:	71078793          	addi	a5,a5,1808 # 80019d60 <disk>
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000565e:	00014997          	auipc	s3,0x14
    80005662:	70298993          	addi	s3,s3,1794 # 80019d60 <disk>
    80005666:	00491713          	slli	a4,s2,0x4
    8000566a:	0009b783          	ld	a5,0(s3)
    8000566e:	97ba                	add	a5,a5,a4
    80005670:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005674:	854a                	mv	a0,s2
    80005676:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	b9c080e7          	jalr	-1124(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005682:	8885                	andi	s1,s1,1
    80005684:	f0ed                	bnez	s1,80005666 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005686:	00015517          	auipc	a0,0x15
    8000568a:	80250513          	addi	a0,a0,-2046 # 80019e88 <disk+0x128>
    8000568e:	00001097          	auipc	ra,0x1
    80005692:	be4080e7          	jalr	-1052(ra) # 80006272 <release>
}
    80005696:	70a6                	ld	ra,104(sp)
    80005698:	7406                	ld	s0,96(sp)
    8000569a:	64e6                	ld	s1,88(sp)
    8000569c:	6946                	ld	s2,80(sp)
    8000569e:	69a6                	ld	s3,72(sp)
    800056a0:	6a06                	ld	s4,64(sp)
    800056a2:	7ae2                	ld	s5,56(sp)
    800056a4:	7b42                	ld	s6,48(sp)
    800056a6:	7ba2                	ld	s7,40(sp)
    800056a8:	7c02                	ld	s8,32(sp)
    800056aa:	6ce2                	ld	s9,24(sp)
    800056ac:	6d42                	ld	s10,16(sp)
    800056ae:	6165                	addi	sp,sp,112
    800056b0:	8082                	ret

00000000800056b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056b2:	1101                	addi	sp,sp,-32
    800056b4:	ec06                	sd	ra,24(sp)
    800056b6:	e822                	sd	s0,16(sp)
    800056b8:	e426                	sd	s1,8(sp)
    800056ba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056bc:	00014497          	auipc	s1,0x14
    800056c0:	6a448493          	addi	s1,s1,1700 # 80019d60 <disk>
    800056c4:	00014517          	auipc	a0,0x14
    800056c8:	7c450513          	addi	a0,a0,1988 # 80019e88 <disk+0x128>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	af2080e7          	jalr	-1294(ra) # 800061be <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056d4:	10001737          	lui	a4,0x10001
    800056d8:	533c                	lw	a5,96(a4)
    800056da:	8b8d                	andi	a5,a5,3
    800056dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056e2:	689c                	ld	a5,16(s1)
    800056e4:	0204d703          	lhu	a4,32(s1)
    800056e8:	0027d783          	lhu	a5,2(a5)
    800056ec:	04f70863          	beq	a4,a5,8000573c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056f0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056f4:	6898                	ld	a4,16(s1)
    800056f6:	0204d783          	lhu	a5,32(s1)
    800056fa:	8b9d                	andi	a5,a5,7
    800056fc:	078e                	slli	a5,a5,0x3
    800056fe:	97ba                	add	a5,a5,a4
    80005700:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005702:	00278713          	addi	a4,a5,2
    80005706:	0712                	slli	a4,a4,0x4
    80005708:	9726                	add	a4,a4,s1
    8000570a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000570e:	e721                	bnez	a4,80005756 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005710:	0789                	addi	a5,a5,2
    80005712:	0792                	slli	a5,a5,0x4
    80005714:	97a6                	add	a5,a5,s1
    80005716:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005718:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000571c:	ffffc097          	auipc	ra,0xffffc
    80005720:	ee4080e7          	jalr	-284(ra) # 80001600 <wakeup>

    disk.used_idx += 1;
    80005724:	0204d783          	lhu	a5,32(s1)
    80005728:	2785                	addiw	a5,a5,1
    8000572a:	17c2                	slli	a5,a5,0x30
    8000572c:	93c1                	srli	a5,a5,0x30
    8000572e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005732:	6898                	ld	a4,16(s1)
    80005734:	00275703          	lhu	a4,2(a4)
    80005738:	faf71ce3          	bne	a4,a5,800056f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000573c:	00014517          	auipc	a0,0x14
    80005740:	74c50513          	addi	a0,a0,1868 # 80019e88 <disk+0x128>
    80005744:	00001097          	auipc	ra,0x1
    80005748:	b2e080e7          	jalr	-1234(ra) # 80006272 <release>
}
    8000574c:	60e2                	ld	ra,24(sp)
    8000574e:	6442                	ld	s0,16(sp)
    80005750:	64a2                	ld	s1,8(sp)
    80005752:	6105                	addi	sp,sp,32
    80005754:	8082                	ret
      panic("virtio_disk_intr status");
    80005756:	00003517          	auipc	a0,0x3
    8000575a:	1e250513          	addi	a0,a0,482 # 80008938 <syscall_name+0x3e0>
    8000575e:	00000097          	auipc	ra,0x0
    80005762:	528080e7          	jalr	1320(ra) # 80005c86 <panic>

0000000080005766 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e422                	sd	s0,8(sp)
    8000576a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000576c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005770:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005774:	0037979b          	slliw	a5,a5,0x3
    80005778:	02004737          	lui	a4,0x2004
    8000577c:	97ba                	add	a5,a5,a4
    8000577e:	0200c737          	lui	a4,0x200c
    80005782:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005786:	000f4637          	lui	a2,0xf4
    8000578a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000578e:	9732                	add	a4,a4,a2
    80005790:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005792:	00259693          	slli	a3,a1,0x2
    80005796:	96ae                	add	a3,a3,a1
    80005798:	068e                	slli	a3,a3,0x3
    8000579a:	00014717          	auipc	a4,0x14
    8000579e:	70670713          	addi	a4,a4,1798 # 80019ea0 <timer_scratch>
    800057a2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057a4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057a6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057a8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ac:	00000797          	auipc	a5,0x0
    800057b0:	9a478793          	addi	a5,a5,-1628 # 80005150 <timervec>
    800057b4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057bc:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057c4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057c8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057cc:	30479073          	csrw	mie,a5
}
    800057d0:	6422                	ld	s0,8(sp)
    800057d2:	0141                	addi	sp,sp,16
    800057d4:	8082                	ret

00000000800057d6 <start>:
{
    800057d6:	1141                	addi	sp,sp,-16
    800057d8:	e406                	sd	ra,8(sp)
    800057da:	e022                	sd	s0,0(sp)
    800057dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057de:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057e2:	7779                	lui	a4,0xffffe
    800057e4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc71f>
    800057e8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ea:	6705                	lui	a4,0x1
    800057ec:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057f6:	ffffb797          	auipc	a5,0xffffb
    800057fa:	b8c78793          	addi	a5,a5,-1140 # 80000382 <main>
    800057fe:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005802:	4781                	li	a5,0
    80005804:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005808:	67c1                	lui	a5,0x10
    8000580a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000580c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005810:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005814:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005818:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000581c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005820:	57fd                	li	a5,-1
    80005822:	83a9                	srli	a5,a5,0xa
    80005824:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005828:	47bd                	li	a5,15
    8000582a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	f38080e7          	jalr	-200(ra) # 80005766 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005836:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000583a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000583c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000583e:	30200073          	mret
}
    80005842:	60a2                	ld	ra,8(sp)
    80005844:	6402                	ld	s0,0(sp)
    80005846:	0141                	addi	sp,sp,16
    80005848:	8082                	ret

000000008000584a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000584a:	715d                	addi	sp,sp,-80
    8000584c:	e486                	sd	ra,72(sp)
    8000584e:	e0a2                	sd	s0,64(sp)
    80005850:	fc26                	sd	s1,56(sp)
    80005852:	f84a                	sd	s2,48(sp)
    80005854:	f44e                	sd	s3,40(sp)
    80005856:	f052                	sd	s4,32(sp)
    80005858:	ec56                	sd	s5,24(sp)
    8000585a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000585c:	04c05763          	blez	a2,800058aa <consolewrite+0x60>
    80005860:	8a2a                	mv	s4,a0
    80005862:	84ae                	mv	s1,a1
    80005864:	89b2                	mv	s3,a2
    80005866:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005868:	5afd                	li	s5,-1
    8000586a:	4685                	li	a3,1
    8000586c:	8626                	mv	a2,s1
    8000586e:	85d2                	mv	a1,s4
    80005870:	fbf40513          	addi	a0,s0,-65
    80005874:	ffffc097          	auipc	ra,0xffffc
    80005878:	186080e7          	jalr	390(ra) # 800019fa <either_copyin>
    8000587c:	01550d63          	beq	a0,s5,80005896 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005880:	fbf44503          	lbu	a0,-65(s0)
    80005884:	00000097          	auipc	ra,0x0
    80005888:	780080e7          	jalr	1920(ra) # 80006004 <uartputc>
  for(i = 0; i < n; i++){
    8000588c:	2905                	addiw	s2,s2,1
    8000588e:	0485                	addi	s1,s1,1
    80005890:	fd299de3          	bne	s3,s2,8000586a <consolewrite+0x20>
    80005894:	894e                	mv	s2,s3
  }

  return i;
}
    80005896:	854a                	mv	a0,s2
    80005898:	60a6                	ld	ra,72(sp)
    8000589a:	6406                	ld	s0,64(sp)
    8000589c:	74e2                	ld	s1,56(sp)
    8000589e:	7942                	ld	s2,48(sp)
    800058a0:	79a2                	ld	s3,40(sp)
    800058a2:	7a02                	ld	s4,32(sp)
    800058a4:	6ae2                	ld	s5,24(sp)
    800058a6:	6161                	addi	sp,sp,80
    800058a8:	8082                	ret
  for(i = 0; i < n; i++){
    800058aa:	4901                	li	s2,0
    800058ac:	b7ed                	j	80005896 <consolewrite+0x4c>

00000000800058ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ae:	711d                	addi	sp,sp,-96
    800058b0:	ec86                	sd	ra,88(sp)
    800058b2:	e8a2                	sd	s0,80(sp)
    800058b4:	e4a6                	sd	s1,72(sp)
    800058b6:	e0ca                	sd	s2,64(sp)
    800058b8:	fc4e                	sd	s3,56(sp)
    800058ba:	f852                	sd	s4,48(sp)
    800058bc:	f456                	sd	s5,40(sp)
    800058be:	f05a                	sd	s6,32(sp)
    800058c0:	ec5e                	sd	s7,24(sp)
    800058c2:	1080                	addi	s0,sp,96
    800058c4:	8aaa                	mv	s5,a0
    800058c6:	8a2e                	mv	s4,a1
    800058c8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058ca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058ce:	0001c517          	auipc	a0,0x1c
    800058d2:	71250513          	addi	a0,a0,1810 # 80021fe0 <cons>
    800058d6:	00001097          	auipc	ra,0x1
    800058da:	8e8080e7          	jalr	-1816(ra) # 800061be <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058de:	0001c497          	auipc	s1,0x1c
    800058e2:	70248493          	addi	s1,s1,1794 # 80021fe0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058e6:	0001c917          	auipc	s2,0x1c
    800058ea:	79290913          	addi	s2,s2,1938 # 80022078 <cons+0x98>
  while(n > 0){
    800058ee:	09305263          	blez	s3,80005972 <consoleread+0xc4>
    while(cons.r == cons.w){
    800058f2:	0984a783          	lw	a5,152(s1)
    800058f6:	09c4a703          	lw	a4,156(s1)
    800058fa:	02f71763          	bne	a4,a5,80005928 <consoleread+0x7a>
      if(killed(myproc())){
    800058fe:	ffffb097          	auipc	ra,0xffffb
    80005902:	5b8080e7          	jalr	1464(ra) # 80000eb6 <myproc>
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	f3e080e7          	jalr	-194(ra) # 80001844 <killed>
    8000590e:	ed2d                	bnez	a0,80005988 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005910:	85a6                	mv	a1,s1
    80005912:	854a                	mv	a0,s2
    80005914:	ffffc097          	auipc	ra,0xffffc
    80005918:	c88080e7          	jalr	-888(ra) # 8000159c <sleep>
    while(cons.r == cons.w){
    8000591c:	0984a783          	lw	a5,152(s1)
    80005920:	09c4a703          	lw	a4,156(s1)
    80005924:	fcf70de3          	beq	a4,a5,800058fe <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005928:	0001c717          	auipc	a4,0x1c
    8000592c:	6b870713          	addi	a4,a4,1720 # 80021fe0 <cons>
    80005930:	0017869b          	addiw	a3,a5,1
    80005934:	08d72c23          	sw	a3,152(a4)
    80005938:	07f7f693          	andi	a3,a5,127
    8000593c:	9736                	add	a4,a4,a3
    8000593e:	01874703          	lbu	a4,24(a4)
    80005942:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005946:	4691                	li	a3,4
    80005948:	06db8463          	beq	s7,a3,800059b0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000594c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005950:	4685                	li	a3,1
    80005952:	faf40613          	addi	a2,s0,-81
    80005956:	85d2                	mv	a1,s4
    80005958:	8556                	mv	a0,s5
    8000595a:	ffffc097          	auipc	ra,0xffffc
    8000595e:	04a080e7          	jalr	74(ra) # 800019a4 <either_copyout>
    80005962:	57fd                	li	a5,-1
    80005964:	00f50763          	beq	a0,a5,80005972 <consoleread+0xc4>
      break;

    dst++;
    80005968:	0a05                	addi	s4,s4,1
    --n;
    8000596a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000596c:	47a9                	li	a5,10
    8000596e:	f8fb90e3          	bne	s7,a5,800058ee <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005972:	0001c517          	auipc	a0,0x1c
    80005976:	66e50513          	addi	a0,a0,1646 # 80021fe0 <cons>
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	8f8080e7          	jalr	-1800(ra) # 80006272 <release>

  return target - n;
    80005982:	413b053b          	subw	a0,s6,s3
    80005986:	a811                	j	8000599a <consoleread+0xec>
        release(&cons.lock);
    80005988:	0001c517          	auipc	a0,0x1c
    8000598c:	65850513          	addi	a0,a0,1624 # 80021fe0 <cons>
    80005990:	00001097          	auipc	ra,0x1
    80005994:	8e2080e7          	jalr	-1822(ra) # 80006272 <release>
        return -1;
    80005998:	557d                	li	a0,-1
}
    8000599a:	60e6                	ld	ra,88(sp)
    8000599c:	6446                	ld	s0,80(sp)
    8000599e:	64a6                	ld	s1,72(sp)
    800059a0:	6906                	ld	s2,64(sp)
    800059a2:	79e2                	ld	s3,56(sp)
    800059a4:	7a42                	ld	s4,48(sp)
    800059a6:	7aa2                	ld	s5,40(sp)
    800059a8:	7b02                	ld	s6,32(sp)
    800059aa:	6be2                	ld	s7,24(sp)
    800059ac:	6125                	addi	sp,sp,96
    800059ae:	8082                	ret
      if(n < target){
    800059b0:	0009871b          	sext.w	a4,s3
    800059b4:	fb677fe3          	bgeu	a4,s6,80005972 <consoleread+0xc4>
        cons.r--;
    800059b8:	0001c717          	auipc	a4,0x1c
    800059bc:	6cf72023          	sw	a5,1728(a4) # 80022078 <cons+0x98>
    800059c0:	bf4d                	j	80005972 <consoleread+0xc4>

00000000800059c2 <consputc>:
{
    800059c2:	1141                	addi	sp,sp,-16
    800059c4:	e406                	sd	ra,8(sp)
    800059c6:	e022                	sd	s0,0(sp)
    800059c8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ca:	10000793          	li	a5,256
    800059ce:	00f50a63          	beq	a0,a5,800059e2 <consputc+0x20>
    uartputc_sync(c);
    800059d2:	00000097          	auipc	ra,0x0
    800059d6:	560080e7          	jalr	1376(ra) # 80005f32 <uartputc_sync>
}
    800059da:	60a2                	ld	ra,8(sp)
    800059dc:	6402                	ld	s0,0(sp)
    800059de:	0141                	addi	sp,sp,16
    800059e0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059e2:	4521                	li	a0,8
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	54e080e7          	jalr	1358(ra) # 80005f32 <uartputc_sync>
    800059ec:	02000513          	li	a0,32
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	542080e7          	jalr	1346(ra) # 80005f32 <uartputc_sync>
    800059f8:	4521                	li	a0,8
    800059fa:	00000097          	auipc	ra,0x0
    800059fe:	538080e7          	jalr	1336(ra) # 80005f32 <uartputc_sync>
    80005a02:	bfe1                	j	800059da <consputc+0x18>

0000000080005a04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a04:	1101                	addi	sp,sp,-32
    80005a06:	ec06                	sd	ra,24(sp)
    80005a08:	e822                	sd	s0,16(sp)
    80005a0a:	e426                	sd	s1,8(sp)
    80005a0c:	e04a                	sd	s2,0(sp)
    80005a0e:	1000                	addi	s0,sp,32
    80005a10:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a12:	0001c517          	auipc	a0,0x1c
    80005a16:	5ce50513          	addi	a0,a0,1486 # 80021fe0 <cons>
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	7a4080e7          	jalr	1956(ra) # 800061be <acquire>

  switch(c){
    80005a22:	47d5                	li	a5,21
    80005a24:	0af48663          	beq	s1,a5,80005ad0 <consoleintr+0xcc>
    80005a28:	0297ca63          	blt	a5,s1,80005a5c <consoleintr+0x58>
    80005a2c:	47a1                	li	a5,8
    80005a2e:	0ef48763          	beq	s1,a5,80005b1c <consoleintr+0x118>
    80005a32:	47c1                	li	a5,16
    80005a34:	10f49a63          	bne	s1,a5,80005b48 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a38:	ffffc097          	auipc	ra,0xffffc
    80005a3c:	018080e7          	jalr	24(ra) # 80001a50 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a40:	0001c517          	auipc	a0,0x1c
    80005a44:	5a050513          	addi	a0,a0,1440 # 80021fe0 <cons>
    80005a48:	00001097          	auipc	ra,0x1
    80005a4c:	82a080e7          	jalr	-2006(ra) # 80006272 <release>
}
    80005a50:	60e2                	ld	ra,24(sp)
    80005a52:	6442                	ld	s0,16(sp)
    80005a54:	64a2                	ld	s1,8(sp)
    80005a56:	6902                	ld	s2,0(sp)
    80005a58:	6105                	addi	sp,sp,32
    80005a5a:	8082                	ret
  switch(c){
    80005a5c:	07f00793          	li	a5,127
    80005a60:	0af48e63          	beq	s1,a5,80005b1c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a64:	0001c717          	auipc	a4,0x1c
    80005a68:	57c70713          	addi	a4,a4,1404 # 80021fe0 <cons>
    80005a6c:	0a072783          	lw	a5,160(a4)
    80005a70:	09872703          	lw	a4,152(a4)
    80005a74:	9f99                	subw	a5,a5,a4
    80005a76:	07f00713          	li	a4,127
    80005a7a:	fcf763e3          	bltu	a4,a5,80005a40 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a7e:	47b5                	li	a5,13
    80005a80:	0cf48763          	beq	s1,a5,80005b4e <consoleintr+0x14a>
      consputc(c);
    80005a84:	8526                	mv	a0,s1
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	f3c080e7          	jalr	-196(ra) # 800059c2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a8e:	0001c797          	auipc	a5,0x1c
    80005a92:	55278793          	addi	a5,a5,1362 # 80021fe0 <cons>
    80005a96:	0a07a683          	lw	a3,160(a5)
    80005a9a:	0016871b          	addiw	a4,a3,1
    80005a9e:	0007061b          	sext.w	a2,a4
    80005aa2:	0ae7a023          	sw	a4,160(a5)
    80005aa6:	07f6f693          	andi	a3,a3,127
    80005aaa:	97b6                	add	a5,a5,a3
    80005aac:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ab0:	47a9                	li	a5,10
    80005ab2:	0cf48563          	beq	s1,a5,80005b7c <consoleintr+0x178>
    80005ab6:	4791                	li	a5,4
    80005ab8:	0cf48263          	beq	s1,a5,80005b7c <consoleintr+0x178>
    80005abc:	0001c797          	auipc	a5,0x1c
    80005ac0:	5bc7a783          	lw	a5,1468(a5) # 80022078 <cons+0x98>
    80005ac4:	9f1d                	subw	a4,a4,a5
    80005ac6:	08000793          	li	a5,128
    80005aca:	f6f71be3          	bne	a4,a5,80005a40 <consoleintr+0x3c>
    80005ace:	a07d                	j	80005b7c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ad0:	0001c717          	auipc	a4,0x1c
    80005ad4:	51070713          	addi	a4,a4,1296 # 80021fe0 <cons>
    80005ad8:	0a072783          	lw	a5,160(a4)
    80005adc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ae0:	0001c497          	auipc	s1,0x1c
    80005ae4:	50048493          	addi	s1,s1,1280 # 80021fe0 <cons>
    while(cons.e != cons.w &&
    80005ae8:	4929                	li	s2,10
    80005aea:	f4f70be3          	beq	a4,a5,80005a40 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005aee:	37fd                	addiw	a5,a5,-1
    80005af0:	07f7f713          	andi	a4,a5,127
    80005af4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005af6:	01874703          	lbu	a4,24(a4)
    80005afa:	f52703e3          	beq	a4,s2,80005a40 <consoleintr+0x3c>
      cons.e--;
    80005afe:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b02:	10000513          	li	a0,256
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	ebc080e7          	jalr	-324(ra) # 800059c2 <consputc>
    while(cons.e != cons.w &&
    80005b0e:	0a04a783          	lw	a5,160(s1)
    80005b12:	09c4a703          	lw	a4,156(s1)
    80005b16:	fcf71ce3          	bne	a4,a5,80005aee <consoleintr+0xea>
    80005b1a:	b71d                	j	80005a40 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b1c:	0001c717          	auipc	a4,0x1c
    80005b20:	4c470713          	addi	a4,a4,1220 # 80021fe0 <cons>
    80005b24:	0a072783          	lw	a5,160(a4)
    80005b28:	09c72703          	lw	a4,156(a4)
    80005b2c:	f0f70ae3          	beq	a4,a5,80005a40 <consoleintr+0x3c>
      cons.e--;
    80005b30:	37fd                	addiw	a5,a5,-1
    80005b32:	0001c717          	auipc	a4,0x1c
    80005b36:	54f72723          	sw	a5,1358(a4) # 80022080 <cons+0xa0>
      consputc(BACKSPACE);
    80005b3a:	10000513          	li	a0,256
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	e84080e7          	jalr	-380(ra) # 800059c2 <consputc>
    80005b46:	bded                	j	80005a40 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b48:	ee048ce3          	beqz	s1,80005a40 <consoleintr+0x3c>
    80005b4c:	bf21                	j	80005a64 <consoleintr+0x60>
      consputc(c);
    80005b4e:	4529                	li	a0,10
    80005b50:	00000097          	auipc	ra,0x0
    80005b54:	e72080e7          	jalr	-398(ra) # 800059c2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b58:	0001c797          	auipc	a5,0x1c
    80005b5c:	48878793          	addi	a5,a5,1160 # 80021fe0 <cons>
    80005b60:	0a07a703          	lw	a4,160(a5)
    80005b64:	0017069b          	addiw	a3,a4,1
    80005b68:	0006861b          	sext.w	a2,a3
    80005b6c:	0ad7a023          	sw	a3,160(a5)
    80005b70:	07f77713          	andi	a4,a4,127
    80005b74:	97ba                	add	a5,a5,a4
    80005b76:	4729                	li	a4,10
    80005b78:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b7c:	0001c797          	auipc	a5,0x1c
    80005b80:	50c7a023          	sw	a2,1280(a5) # 8002207c <cons+0x9c>
        wakeup(&cons.r);
    80005b84:	0001c517          	auipc	a0,0x1c
    80005b88:	4f450513          	addi	a0,a0,1268 # 80022078 <cons+0x98>
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	a74080e7          	jalr	-1420(ra) # 80001600 <wakeup>
    80005b94:	b575                	j	80005a40 <consoleintr+0x3c>

0000000080005b96 <consoleinit>:

void
consoleinit(void)
{
    80005b96:	1141                	addi	sp,sp,-16
    80005b98:	e406                	sd	ra,8(sp)
    80005b9a:	e022                	sd	s0,0(sp)
    80005b9c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b9e:	00003597          	auipc	a1,0x3
    80005ba2:	db258593          	addi	a1,a1,-590 # 80008950 <syscall_name+0x3f8>
    80005ba6:	0001c517          	auipc	a0,0x1c
    80005baa:	43a50513          	addi	a0,a0,1082 # 80021fe0 <cons>
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	580080e7          	jalr	1408(ra) # 8000612e <initlock>

  uartinit();
    80005bb6:	00000097          	auipc	ra,0x0
    80005bba:	32c080e7          	jalr	812(ra) # 80005ee2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bbe:	00013797          	auipc	a5,0x13
    80005bc2:	14a78793          	addi	a5,a5,330 # 80018d08 <devsw>
    80005bc6:	00000717          	auipc	a4,0x0
    80005bca:	ce870713          	addi	a4,a4,-792 # 800058ae <consoleread>
    80005bce:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bd0:	00000717          	auipc	a4,0x0
    80005bd4:	c7a70713          	addi	a4,a4,-902 # 8000584a <consolewrite>
    80005bd8:	ef98                	sd	a4,24(a5)
}
    80005bda:	60a2                	ld	ra,8(sp)
    80005bdc:	6402                	ld	s0,0(sp)
    80005bde:	0141                	addi	sp,sp,16
    80005be0:	8082                	ret

0000000080005be2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005be2:	7179                	addi	sp,sp,-48
    80005be4:	f406                	sd	ra,40(sp)
    80005be6:	f022                	sd	s0,32(sp)
    80005be8:	ec26                	sd	s1,24(sp)
    80005bea:	e84a                	sd	s2,16(sp)
    80005bec:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bee:	c219                	beqz	a2,80005bf4 <printint+0x12>
    80005bf0:	08054763          	bltz	a0,80005c7e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bf4:	2501                	sext.w	a0,a0
    80005bf6:	4881                	li	a7,0
    80005bf8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bfc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bfe:	2581                	sext.w	a1,a1
    80005c00:	00003617          	auipc	a2,0x3
    80005c04:	d8060613          	addi	a2,a2,-640 # 80008980 <digits>
    80005c08:	883a                	mv	a6,a4
    80005c0a:	2705                	addiw	a4,a4,1
    80005c0c:	02b577bb          	remuw	a5,a0,a1
    80005c10:	1782                	slli	a5,a5,0x20
    80005c12:	9381                	srli	a5,a5,0x20
    80005c14:	97b2                	add	a5,a5,a2
    80005c16:	0007c783          	lbu	a5,0(a5)
    80005c1a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c1e:	0005079b          	sext.w	a5,a0
    80005c22:	02b5553b          	divuw	a0,a0,a1
    80005c26:	0685                	addi	a3,a3,1
    80005c28:	feb7f0e3          	bgeu	a5,a1,80005c08 <printint+0x26>

  if(sign)
    80005c2c:	00088c63          	beqz	a7,80005c44 <printint+0x62>
    buf[i++] = '-';
    80005c30:	fe070793          	addi	a5,a4,-32
    80005c34:	00878733          	add	a4,a5,s0
    80005c38:	02d00793          	li	a5,45
    80005c3c:	fef70823          	sb	a5,-16(a4)
    80005c40:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c44:	02e05763          	blez	a4,80005c72 <printint+0x90>
    80005c48:	fd040793          	addi	a5,s0,-48
    80005c4c:	00e784b3          	add	s1,a5,a4
    80005c50:	fff78913          	addi	s2,a5,-1
    80005c54:	993a                	add	s2,s2,a4
    80005c56:	377d                	addiw	a4,a4,-1
    80005c58:	1702                	slli	a4,a4,0x20
    80005c5a:	9301                	srli	a4,a4,0x20
    80005c5c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c60:	fff4c503          	lbu	a0,-1(s1)
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	d5e080e7          	jalr	-674(ra) # 800059c2 <consputc>
  while(--i >= 0)
    80005c6c:	14fd                	addi	s1,s1,-1
    80005c6e:	ff2499e3          	bne	s1,s2,80005c60 <printint+0x7e>
}
    80005c72:	70a2                	ld	ra,40(sp)
    80005c74:	7402                	ld	s0,32(sp)
    80005c76:	64e2                	ld	s1,24(sp)
    80005c78:	6942                	ld	s2,16(sp)
    80005c7a:	6145                	addi	sp,sp,48
    80005c7c:	8082                	ret
    x = -xx;
    80005c7e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c82:	4885                	li	a7,1
    x = -xx;
    80005c84:	bf95                	j	80005bf8 <printint+0x16>

0000000080005c86 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c86:	1101                	addi	sp,sp,-32
    80005c88:	ec06                	sd	ra,24(sp)
    80005c8a:	e822                	sd	s0,16(sp)
    80005c8c:	e426                	sd	s1,8(sp)
    80005c8e:	1000                	addi	s0,sp,32
    80005c90:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c92:	0001c797          	auipc	a5,0x1c
    80005c96:	4007a723          	sw	zero,1038(a5) # 800220a0 <pr+0x18>
  printf("panic: ");
    80005c9a:	00003517          	auipc	a0,0x3
    80005c9e:	cbe50513          	addi	a0,a0,-834 # 80008958 <syscall_name+0x400>
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	02e080e7          	jalr	46(ra) # 80005cd0 <printf>
  printf(s);
    80005caa:	8526                	mv	a0,s1
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	024080e7          	jalr	36(ra) # 80005cd0 <printf>
  printf("\n");
    80005cb4:	00002517          	auipc	a0,0x2
    80005cb8:	39450513          	addi	a0,a0,916 # 80008048 <etext+0x48>
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	014080e7          	jalr	20(ra) # 80005cd0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cc4:	4785                	li	a5,1
    80005cc6:	00003717          	auipc	a4,0x3
    80005cca:	d8f72b23          	sw	a5,-618(a4) # 80008a5c <panicked>
  for(;;)
    80005cce:	a001                	j	80005cce <panic+0x48>

0000000080005cd0 <printf>:
{
    80005cd0:	7131                	addi	sp,sp,-192
    80005cd2:	fc86                	sd	ra,120(sp)
    80005cd4:	f8a2                	sd	s0,112(sp)
    80005cd6:	f4a6                	sd	s1,104(sp)
    80005cd8:	f0ca                	sd	s2,96(sp)
    80005cda:	ecce                	sd	s3,88(sp)
    80005cdc:	e8d2                	sd	s4,80(sp)
    80005cde:	e4d6                	sd	s5,72(sp)
    80005ce0:	e0da                	sd	s6,64(sp)
    80005ce2:	fc5e                	sd	s7,56(sp)
    80005ce4:	f862                	sd	s8,48(sp)
    80005ce6:	f466                	sd	s9,40(sp)
    80005ce8:	f06a                	sd	s10,32(sp)
    80005cea:	ec6e                	sd	s11,24(sp)
    80005cec:	0100                	addi	s0,sp,128
    80005cee:	8a2a                	mv	s4,a0
    80005cf0:	e40c                	sd	a1,8(s0)
    80005cf2:	e810                	sd	a2,16(s0)
    80005cf4:	ec14                	sd	a3,24(s0)
    80005cf6:	f018                	sd	a4,32(s0)
    80005cf8:	f41c                	sd	a5,40(s0)
    80005cfa:	03043823          	sd	a6,48(s0)
    80005cfe:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d02:	0001cd97          	auipc	s11,0x1c
    80005d06:	39edad83          	lw	s11,926(s11) # 800220a0 <pr+0x18>
  if(locking)
    80005d0a:	020d9b63          	bnez	s11,80005d40 <printf+0x70>
  if (fmt == 0)
    80005d0e:	040a0263          	beqz	s4,80005d52 <printf+0x82>
  va_start(ap, fmt);
    80005d12:	00840793          	addi	a5,s0,8
    80005d16:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d1a:	000a4503          	lbu	a0,0(s4)
    80005d1e:	14050f63          	beqz	a0,80005e7c <printf+0x1ac>
    80005d22:	4981                	li	s3,0
    if(c != '%'){
    80005d24:	02500a93          	li	s5,37
    switch(c){
    80005d28:	07000b93          	li	s7,112
  consputc('x');
    80005d2c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d2e:	00003b17          	auipc	s6,0x3
    80005d32:	c52b0b13          	addi	s6,s6,-942 # 80008980 <digits>
    switch(c){
    80005d36:	07300c93          	li	s9,115
    80005d3a:	06400c13          	li	s8,100
    80005d3e:	a82d                	j	80005d78 <printf+0xa8>
    acquire(&pr.lock);
    80005d40:	0001c517          	auipc	a0,0x1c
    80005d44:	34850513          	addi	a0,a0,840 # 80022088 <pr>
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	476080e7          	jalr	1142(ra) # 800061be <acquire>
    80005d50:	bf7d                	j	80005d0e <printf+0x3e>
    panic("null fmt");
    80005d52:	00003517          	auipc	a0,0x3
    80005d56:	c1650513          	addi	a0,a0,-1002 # 80008968 <syscall_name+0x410>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	f2c080e7          	jalr	-212(ra) # 80005c86 <panic>
      consputc(c);
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	c60080e7          	jalr	-928(ra) # 800059c2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d6a:	2985                	addiw	s3,s3,1
    80005d6c:	013a07b3          	add	a5,s4,s3
    80005d70:	0007c503          	lbu	a0,0(a5)
    80005d74:	10050463          	beqz	a0,80005e7c <printf+0x1ac>
    if(c != '%'){
    80005d78:	ff5515e3          	bne	a0,s5,80005d62 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d7c:	2985                	addiw	s3,s3,1
    80005d7e:	013a07b3          	add	a5,s4,s3
    80005d82:	0007c783          	lbu	a5,0(a5)
    80005d86:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d8a:	cbed                	beqz	a5,80005e7c <printf+0x1ac>
    switch(c){
    80005d8c:	05778a63          	beq	a5,s7,80005de0 <printf+0x110>
    80005d90:	02fbf663          	bgeu	s7,a5,80005dbc <printf+0xec>
    80005d94:	09978863          	beq	a5,s9,80005e24 <printf+0x154>
    80005d98:	07800713          	li	a4,120
    80005d9c:	0ce79563          	bne	a5,a4,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	addi	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	85ea                	mv	a1,s10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	e30080e7          	jalr	-464(ra) # 80005be2 <printint>
      break;
    80005dba:	bf45                	j	80005d6a <printf+0x9a>
    switch(c){
    80005dbc:	09578f63          	beq	a5,s5,80005e5a <printf+0x18a>
    80005dc0:	0b879363          	bne	a5,s8,80005e66 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005dc4:	f8843783          	ld	a5,-120(s0)
    80005dc8:	00878713          	addi	a4,a5,8
    80005dcc:	f8e43423          	sd	a4,-120(s0)
    80005dd0:	4605                	li	a2,1
    80005dd2:	45a9                	li	a1,10
    80005dd4:	4388                	lw	a0,0(a5)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	e0c080e7          	jalr	-500(ra) # 80005be2 <printint>
      break;
    80005dde:	b771                	j	80005d6a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005de0:	f8843783          	ld	a5,-120(s0)
    80005de4:	00878713          	addi	a4,a5,8
    80005de8:	f8e43423          	sd	a4,-120(s0)
    80005dec:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005df0:	03000513          	li	a0,48
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	bce080e7          	jalr	-1074(ra) # 800059c2 <consputc>
  consputc('x');
    80005dfc:	07800513          	li	a0,120
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	bc2080e7          	jalr	-1086(ra) # 800059c2 <consputc>
    80005e08:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0a:	03c95793          	srli	a5,s2,0x3c
    80005e0e:	97da                	add	a5,a5,s6
    80005e10:	0007c503          	lbu	a0,0(a5)
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	bae080e7          	jalr	-1106(ra) # 800059c2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e1c:	0912                	slli	s2,s2,0x4
    80005e1e:	34fd                	addiw	s1,s1,-1
    80005e20:	f4ed                	bnez	s1,80005e0a <printf+0x13a>
    80005e22:	b7a1                	j	80005d6a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e24:	f8843783          	ld	a5,-120(s0)
    80005e28:	00878713          	addi	a4,a5,8
    80005e2c:	f8e43423          	sd	a4,-120(s0)
    80005e30:	6384                	ld	s1,0(a5)
    80005e32:	cc89                	beqz	s1,80005e4c <printf+0x17c>
      for(; *s; s++)
    80005e34:	0004c503          	lbu	a0,0(s1)
    80005e38:	d90d                	beqz	a0,80005d6a <printf+0x9a>
        consputc(*s);
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	b88080e7          	jalr	-1144(ra) # 800059c2 <consputc>
      for(; *s; s++)
    80005e42:	0485                	addi	s1,s1,1
    80005e44:	0004c503          	lbu	a0,0(s1)
    80005e48:	f96d                	bnez	a0,80005e3a <printf+0x16a>
    80005e4a:	b705                	j	80005d6a <printf+0x9a>
        s = "(null)";
    80005e4c:	00003497          	auipc	s1,0x3
    80005e50:	b1448493          	addi	s1,s1,-1260 # 80008960 <syscall_name+0x408>
      for(; *s; s++)
    80005e54:	02800513          	li	a0,40
    80005e58:	b7cd                	j	80005e3a <printf+0x16a>
      consputc('%');
    80005e5a:	8556                	mv	a0,s5
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	b66080e7          	jalr	-1178(ra) # 800059c2 <consputc>
      break;
    80005e64:	b719                	j	80005d6a <printf+0x9a>
      consputc('%');
    80005e66:	8556                	mv	a0,s5
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	b5a080e7          	jalr	-1190(ra) # 800059c2 <consputc>
      consputc(c);
    80005e70:	8526                	mv	a0,s1
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	b50080e7          	jalr	-1200(ra) # 800059c2 <consputc>
      break;
    80005e7a:	bdc5                	j	80005d6a <printf+0x9a>
  if(locking)
    80005e7c:	020d9163          	bnez	s11,80005e9e <printf+0x1ce>
}
    80005e80:	70e6                	ld	ra,120(sp)
    80005e82:	7446                	ld	s0,112(sp)
    80005e84:	74a6                	ld	s1,104(sp)
    80005e86:	7906                	ld	s2,96(sp)
    80005e88:	69e6                	ld	s3,88(sp)
    80005e8a:	6a46                	ld	s4,80(sp)
    80005e8c:	6aa6                	ld	s5,72(sp)
    80005e8e:	6b06                	ld	s6,64(sp)
    80005e90:	7be2                	ld	s7,56(sp)
    80005e92:	7c42                	ld	s8,48(sp)
    80005e94:	7ca2                	ld	s9,40(sp)
    80005e96:	7d02                	ld	s10,32(sp)
    80005e98:	6de2                	ld	s11,24(sp)
    80005e9a:	6129                	addi	sp,sp,192
    80005e9c:	8082                	ret
    release(&pr.lock);
    80005e9e:	0001c517          	auipc	a0,0x1c
    80005ea2:	1ea50513          	addi	a0,a0,490 # 80022088 <pr>
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	3cc080e7          	jalr	972(ra) # 80006272 <release>
}
    80005eae:	bfc9                	j	80005e80 <printf+0x1b0>

0000000080005eb0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005eb0:	1101                	addi	sp,sp,-32
    80005eb2:	ec06                	sd	ra,24(sp)
    80005eb4:	e822                	sd	s0,16(sp)
    80005eb6:	e426                	sd	s1,8(sp)
    80005eb8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005eba:	0001c497          	auipc	s1,0x1c
    80005ebe:	1ce48493          	addi	s1,s1,462 # 80022088 <pr>
    80005ec2:	00003597          	auipc	a1,0x3
    80005ec6:	ab658593          	addi	a1,a1,-1354 # 80008978 <syscall_name+0x420>
    80005eca:	8526                	mv	a0,s1
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	262080e7          	jalr	610(ra) # 8000612e <initlock>
  pr.locking = 1;
    80005ed4:	4785                	li	a5,1
    80005ed6:	cc9c                	sw	a5,24(s1)
}
    80005ed8:	60e2                	ld	ra,24(sp)
    80005eda:	6442                	ld	s0,16(sp)
    80005edc:	64a2                	ld	s1,8(sp)
    80005ede:	6105                	addi	sp,sp,32
    80005ee0:	8082                	ret

0000000080005ee2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ee2:	1141                	addi	sp,sp,-16
    80005ee4:	e406                	sd	ra,8(sp)
    80005ee6:	e022                	sd	s0,0(sp)
    80005ee8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eea:	100007b7          	lui	a5,0x10000
    80005eee:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ef2:	f8000713          	li	a4,-128
    80005ef6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005efa:	470d                	li	a4,3
    80005efc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f00:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f04:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f08:	469d                	li	a3,7
    80005f0a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f0e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f12:	00003597          	auipc	a1,0x3
    80005f16:	a8658593          	addi	a1,a1,-1402 # 80008998 <digits+0x18>
    80005f1a:	0001c517          	auipc	a0,0x1c
    80005f1e:	18e50513          	addi	a0,a0,398 # 800220a8 <uart_tx_lock>
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	20c080e7          	jalr	524(ra) # 8000612e <initlock>
}
    80005f2a:	60a2                	ld	ra,8(sp)
    80005f2c:	6402                	ld	s0,0(sp)
    80005f2e:	0141                	addi	sp,sp,16
    80005f30:	8082                	ret

0000000080005f32 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f32:	1101                	addi	sp,sp,-32
    80005f34:	ec06                	sd	ra,24(sp)
    80005f36:	e822                	sd	s0,16(sp)
    80005f38:	e426                	sd	s1,8(sp)
    80005f3a:	1000                	addi	s0,sp,32
    80005f3c:	84aa                	mv	s1,a0
  push_off();
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	234080e7          	jalr	564(ra) # 80006172 <push_off>

  if(panicked){
    80005f46:	00003797          	auipc	a5,0x3
    80005f4a:	b167a783          	lw	a5,-1258(a5) # 80008a5c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f4e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f52:	c391                	beqz	a5,80005f56 <uartputc_sync+0x24>
    for(;;)
    80005f54:	a001                	j	80005f54 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f56:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f5a:	0207f793          	andi	a5,a5,32
    80005f5e:	dfe5                	beqz	a5,80005f56 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f60:	0ff4f513          	zext.b	a0,s1
    80005f64:	100007b7          	lui	a5,0x10000
    80005f68:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f6c:	00000097          	auipc	ra,0x0
    80005f70:	2a6080e7          	jalr	678(ra) # 80006212 <pop_off>
}
    80005f74:	60e2                	ld	ra,24(sp)
    80005f76:	6442                	ld	s0,16(sp)
    80005f78:	64a2                	ld	s1,8(sp)
    80005f7a:	6105                	addi	sp,sp,32
    80005f7c:	8082                	ret

0000000080005f7e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f7e:	00003797          	auipc	a5,0x3
    80005f82:	ae27b783          	ld	a5,-1310(a5) # 80008a60 <uart_tx_r>
    80005f86:	00003717          	auipc	a4,0x3
    80005f8a:	ae273703          	ld	a4,-1310(a4) # 80008a68 <uart_tx_w>
    80005f8e:	06f70a63          	beq	a4,a5,80006002 <uartstart+0x84>
{
    80005f92:	7139                	addi	sp,sp,-64
    80005f94:	fc06                	sd	ra,56(sp)
    80005f96:	f822                	sd	s0,48(sp)
    80005f98:	f426                	sd	s1,40(sp)
    80005f9a:	f04a                	sd	s2,32(sp)
    80005f9c:	ec4e                	sd	s3,24(sp)
    80005f9e:	e852                	sd	s4,16(sp)
    80005fa0:	e456                	sd	s5,8(sp)
    80005fa2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fa4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fa8:	0001ca17          	auipc	s4,0x1c
    80005fac:	100a0a13          	addi	s4,s4,256 # 800220a8 <uart_tx_lock>
    uart_tx_r += 1;
    80005fb0:	00003497          	auipc	s1,0x3
    80005fb4:	ab048493          	addi	s1,s1,-1360 # 80008a60 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fb8:	00003997          	auipc	s3,0x3
    80005fbc:	ab098993          	addi	s3,s3,-1360 # 80008a68 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fc4:	02077713          	andi	a4,a4,32
    80005fc8:	c705                	beqz	a4,80005ff0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fca:	01f7f713          	andi	a4,a5,31
    80005fce:	9752                	add	a4,a4,s4
    80005fd0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fd4:	0785                	addi	a5,a5,1
    80005fd6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fd8:	8526                	mv	a0,s1
    80005fda:	ffffb097          	auipc	ra,0xffffb
    80005fde:	626080e7          	jalr	1574(ra) # 80001600 <wakeup>
    
    WriteReg(THR, c);
    80005fe2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fe6:	609c                	ld	a5,0(s1)
    80005fe8:	0009b703          	ld	a4,0(s3)
    80005fec:	fcf71ae3          	bne	a4,a5,80005fc0 <uartstart+0x42>
  }
}
    80005ff0:	70e2                	ld	ra,56(sp)
    80005ff2:	7442                	ld	s0,48(sp)
    80005ff4:	74a2                	ld	s1,40(sp)
    80005ff6:	7902                	ld	s2,32(sp)
    80005ff8:	69e2                	ld	s3,24(sp)
    80005ffa:	6a42                	ld	s4,16(sp)
    80005ffc:	6aa2                	ld	s5,8(sp)
    80005ffe:	6121                	addi	sp,sp,64
    80006000:	8082                	ret
    80006002:	8082                	ret

0000000080006004 <uartputc>:
{
    80006004:	7179                	addi	sp,sp,-48
    80006006:	f406                	sd	ra,40(sp)
    80006008:	f022                	sd	s0,32(sp)
    8000600a:	ec26                	sd	s1,24(sp)
    8000600c:	e84a                	sd	s2,16(sp)
    8000600e:	e44e                	sd	s3,8(sp)
    80006010:	e052                	sd	s4,0(sp)
    80006012:	1800                	addi	s0,sp,48
    80006014:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006016:	0001c517          	auipc	a0,0x1c
    8000601a:	09250513          	addi	a0,a0,146 # 800220a8 <uart_tx_lock>
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	1a0080e7          	jalr	416(ra) # 800061be <acquire>
  if(panicked){
    80006026:	00003797          	auipc	a5,0x3
    8000602a:	a367a783          	lw	a5,-1482(a5) # 80008a5c <panicked>
    8000602e:	e7c9                	bnez	a5,800060b8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006030:	00003717          	auipc	a4,0x3
    80006034:	a3873703          	ld	a4,-1480(a4) # 80008a68 <uart_tx_w>
    80006038:	00003797          	auipc	a5,0x3
    8000603c:	a287b783          	ld	a5,-1496(a5) # 80008a60 <uart_tx_r>
    80006040:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006044:	0001c997          	auipc	s3,0x1c
    80006048:	06498993          	addi	s3,s3,100 # 800220a8 <uart_tx_lock>
    8000604c:	00003497          	auipc	s1,0x3
    80006050:	a1448493          	addi	s1,s1,-1516 # 80008a60 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006054:	00003917          	auipc	s2,0x3
    80006058:	a1490913          	addi	s2,s2,-1516 # 80008a68 <uart_tx_w>
    8000605c:	00e79f63          	bne	a5,a4,8000607a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006060:	85ce                	mv	a1,s3
    80006062:	8526                	mv	a0,s1
    80006064:	ffffb097          	auipc	ra,0xffffb
    80006068:	538080e7          	jalr	1336(ra) # 8000159c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606c:	00093703          	ld	a4,0(s2)
    80006070:	609c                	ld	a5,0(s1)
    80006072:	02078793          	addi	a5,a5,32
    80006076:	fee785e3          	beq	a5,a4,80006060 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000607a:	0001c497          	auipc	s1,0x1c
    8000607e:	02e48493          	addi	s1,s1,46 # 800220a8 <uart_tx_lock>
    80006082:	01f77793          	andi	a5,a4,31
    80006086:	97a6                	add	a5,a5,s1
    80006088:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000608c:	0705                	addi	a4,a4,1
    8000608e:	00003797          	auipc	a5,0x3
    80006092:	9ce7bd23          	sd	a4,-1574(a5) # 80008a68 <uart_tx_w>
  uartstart();
    80006096:	00000097          	auipc	ra,0x0
    8000609a:	ee8080e7          	jalr	-280(ra) # 80005f7e <uartstart>
  release(&uart_tx_lock);
    8000609e:	8526                	mv	a0,s1
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	1d2080e7          	jalr	466(ra) # 80006272 <release>
}
    800060a8:	70a2                	ld	ra,40(sp)
    800060aa:	7402                	ld	s0,32(sp)
    800060ac:	64e2                	ld	s1,24(sp)
    800060ae:	6942                	ld	s2,16(sp)
    800060b0:	69a2                	ld	s3,8(sp)
    800060b2:	6a02                	ld	s4,0(sp)
    800060b4:	6145                	addi	sp,sp,48
    800060b6:	8082                	ret
    for(;;)
    800060b8:	a001                	j	800060b8 <uartputc+0xb4>

00000000800060ba <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ba:	1141                	addi	sp,sp,-16
    800060bc:	e422                	sd	s0,8(sp)
    800060be:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060c0:	100007b7          	lui	a5,0x10000
    800060c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060c8:	8b85                	andi	a5,a5,1
    800060ca:	cb81                	beqz	a5,800060da <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060cc:	100007b7          	lui	a5,0x10000
    800060d0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060d4:	6422                	ld	s0,8(sp)
    800060d6:	0141                	addi	sp,sp,16
    800060d8:	8082                	ret
    return -1;
    800060da:	557d                	li	a0,-1
    800060dc:	bfe5                	j	800060d4 <uartgetc+0x1a>

00000000800060de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060de:	1101                	addi	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060e8:	54fd                	li	s1,-1
    800060ea:	a029                	j	800060f4 <uartintr+0x16>
      break;
    consoleintr(c);
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	918080e7          	jalr	-1768(ra) # 80005a04 <consoleintr>
    int c = uartgetc();
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	fc6080e7          	jalr	-58(ra) # 800060ba <uartgetc>
    if(c == -1)
    800060fc:	fe9518e3          	bne	a0,s1,800060ec <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006100:	0001c497          	auipc	s1,0x1c
    80006104:	fa848493          	addi	s1,s1,-88 # 800220a8 <uart_tx_lock>
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	0b4080e7          	jalr	180(ra) # 800061be <acquire>
  uartstart();
    80006112:	00000097          	auipc	ra,0x0
    80006116:	e6c080e7          	jalr	-404(ra) # 80005f7e <uartstart>
  release(&uart_tx_lock);
    8000611a:	8526                	mv	a0,s1
    8000611c:	00000097          	auipc	ra,0x0
    80006120:	156080e7          	jalr	342(ra) # 80006272 <release>
}
    80006124:	60e2                	ld	ra,24(sp)
    80006126:	6442                	ld	s0,16(sp)
    80006128:	64a2                	ld	s1,8(sp)
    8000612a:	6105                	addi	sp,sp,32
    8000612c:	8082                	ret

000000008000612e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000612e:	1141                	addi	sp,sp,-16
    80006130:	e422                	sd	s0,8(sp)
    80006132:	0800                	addi	s0,sp,16
  lk->name = name;
    80006134:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006136:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000613a:	00053823          	sd	zero,16(a0)
}
    8000613e:	6422                	ld	s0,8(sp)
    80006140:	0141                	addi	sp,sp,16
    80006142:	8082                	ret

0000000080006144 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006144:	411c                	lw	a5,0(a0)
    80006146:	e399                	bnez	a5,8000614c <holding+0x8>
    80006148:	4501                	li	a0,0
  return r;
}
    8000614a:	8082                	ret
{
    8000614c:	1101                	addi	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006156:	6904                	ld	s1,16(a0)
    80006158:	ffffb097          	auipc	ra,0xffffb
    8000615c:	d42080e7          	jalr	-702(ra) # 80000e9a <mycpu>
    80006160:	40a48533          	sub	a0,s1,a0
    80006164:	00153513          	seqz	a0,a0
}
    80006168:	60e2                	ld	ra,24(sp)
    8000616a:	6442                	ld	s0,16(sp)
    8000616c:	64a2                	ld	s1,8(sp)
    8000616e:	6105                	addi	sp,sp,32
    80006170:	8082                	ret

0000000080006172 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006172:	1101                	addi	sp,sp,-32
    80006174:	ec06                	sd	ra,24(sp)
    80006176:	e822                	sd	s0,16(sp)
    80006178:	e426                	sd	s1,8(sp)
    8000617a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000617c:	100024f3          	csrr	s1,sstatus
    80006180:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006184:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006186:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	d10080e7          	jalr	-752(ra) # 80000e9a <mycpu>
    80006192:	5d3c                	lw	a5,120(a0)
    80006194:	cf89                	beqz	a5,800061ae <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	d04080e7          	jalr	-764(ra) # 80000e9a <mycpu>
    8000619e:	5d3c                	lw	a5,120(a0)
    800061a0:	2785                	addiw	a5,a5,1
    800061a2:	dd3c                	sw	a5,120(a0)
}
    800061a4:	60e2                	ld	ra,24(sp)
    800061a6:	6442                	ld	s0,16(sp)
    800061a8:	64a2                	ld	s1,8(sp)
    800061aa:	6105                	addi	sp,sp,32
    800061ac:	8082                	ret
    mycpu()->intena = old;
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	cec080e7          	jalr	-788(ra) # 80000e9a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061b6:	8085                	srli	s1,s1,0x1
    800061b8:	8885                	andi	s1,s1,1
    800061ba:	dd64                	sw	s1,124(a0)
    800061bc:	bfe9                	j	80006196 <push_off+0x24>

00000000800061be <acquire>:
{
    800061be:	1101                	addi	sp,sp,-32
    800061c0:	ec06                	sd	ra,24(sp)
    800061c2:	e822                	sd	s0,16(sp)
    800061c4:	e426                	sd	s1,8(sp)
    800061c6:	1000                	addi	s0,sp,32
    800061c8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	fa8080e7          	jalr	-88(ra) # 80006172 <push_off>
  if(holding(lk))
    800061d2:	8526                	mv	a0,s1
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	f70080e7          	jalr	-144(ra) # 80006144 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061dc:	4705                	li	a4,1
  if(holding(lk))
    800061de:	e115                	bnez	a0,80006202 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061e0:	87ba                	mv	a5,a4
    800061e2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061e6:	2781                	sext.w	a5,a5
    800061e8:	ffe5                	bnez	a5,800061e0 <acquire+0x22>
  __sync_synchronize();
    800061ea:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	cac080e7          	jalr	-852(ra) # 80000e9a <mycpu>
    800061f6:	e888                	sd	a0,16(s1)
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	addi	sp,sp,32
    80006200:	8082                	ret
    panic("acquire");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	79e50513          	addi	a0,a0,1950 # 800089a0 <digits+0x20>
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	a7c080e7          	jalr	-1412(ra) # 80005c86 <panic>

0000000080006212 <pop_off>:

void
pop_off(void)
{
    80006212:	1141                	addi	sp,sp,-16
    80006214:	e406                	sd	ra,8(sp)
    80006216:	e022                	sd	s0,0(sp)
    80006218:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000621a:	ffffb097          	auipc	ra,0xffffb
    8000621e:	c80080e7          	jalr	-896(ra) # 80000e9a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006222:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006226:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006228:	e78d                	bnez	a5,80006252 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000622a:	5d3c                	lw	a5,120(a0)
    8000622c:	02f05b63          	blez	a5,80006262 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006230:	37fd                	addiw	a5,a5,-1
    80006232:	0007871b          	sext.w	a4,a5
    80006236:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006238:	eb09                	bnez	a4,8000624a <pop_off+0x38>
    8000623a:	5d7c                	lw	a5,124(a0)
    8000623c:	c799                	beqz	a5,8000624a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000623e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006242:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006246:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000624a:	60a2                	ld	ra,8(sp)
    8000624c:	6402                	ld	s0,0(sp)
    8000624e:	0141                	addi	sp,sp,16
    80006250:	8082                	ret
    panic("pop_off - interruptible");
    80006252:	00002517          	auipc	a0,0x2
    80006256:	75650513          	addi	a0,a0,1878 # 800089a8 <digits+0x28>
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	a2c080e7          	jalr	-1492(ra) # 80005c86 <panic>
    panic("pop_off");
    80006262:	00002517          	auipc	a0,0x2
    80006266:	75e50513          	addi	a0,a0,1886 # 800089c0 <digits+0x40>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	a1c080e7          	jalr	-1508(ra) # 80005c86 <panic>

0000000080006272 <release>:
{
    80006272:	1101                	addi	sp,sp,-32
    80006274:	ec06                	sd	ra,24(sp)
    80006276:	e822                	sd	s0,16(sp)
    80006278:	e426                	sd	s1,8(sp)
    8000627a:	1000                	addi	s0,sp,32
    8000627c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	ec6080e7          	jalr	-314(ra) # 80006144 <holding>
    80006286:	c115                	beqz	a0,800062aa <release+0x38>
  lk->cpu = 0;
    80006288:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000628c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006290:	0f50000f          	fence	iorw,ow
    80006294:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	f7a080e7          	jalr	-134(ra) # 80006212 <pop_off>
}
    800062a0:	60e2                	ld	ra,24(sp)
    800062a2:	6442                	ld	s0,16(sp)
    800062a4:	64a2                	ld	s1,8(sp)
    800062a6:	6105                	addi	sp,sp,32
    800062a8:	8082                	ret
    panic("release");
    800062aa:	00002517          	auipc	a0,0x2
    800062ae:	71e50513          	addi	a0,a0,1822 # 800089c8 <digits+0x48>
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	9d4080e7          	jalr	-1580(ra) # 80005c86 <panic>
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
