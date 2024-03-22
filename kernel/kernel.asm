
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0f1050ef          	jal	ra,80005906 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <inc_ref>:
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
inc_ref(void *pa){
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
    80000028:	84aa                	mv	s1,a0
  acquire(&cow_ref_lock);
    8000002a:	00009917          	auipc	s2,0x9
    8000002e:	94690913          	addi	s2,s2,-1722 # 80008970 <cow_ref_lock>
    80000032:	854a                	mv	a0,s2
    80000034:	00006097          	auipc	ra,0x6
    80000038:	2ba080e7          	jalr	698(ra) # 800062ee <acquire>
  cow_count[PA2COUNT(pa)]++;
    8000003c:	800007b7          	lui	a5,0x80000
    80000040:	94be                	add	s1,s1,a5
    80000042:	80b1                	srli	s1,s1,0xc
    80000044:	048a                	slli	s1,s1,0x2
    80000046:	00009797          	auipc	a5,0x9
    8000004a:	96278793          	addi	a5,a5,-1694 # 800089a8 <cow_count>
    8000004e:	97a6                	add	a5,a5,s1
    80000050:	4398                	lw	a4,0(a5)
    80000052:	2705                	addiw	a4,a4,1
    80000054:	c398                	sw	a4,0(a5)
  release(&cow_ref_lock);
    80000056:	854a                	mv	a0,s2
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	34a080e7          	jalr	842(ra) # 800063a2 <release>
}
    80000060:	60e2                	ld	ra,24(sp)
    80000062:	6442                	ld	s0,16(sp)
    80000064:	64a2                	ld	s1,8(sp)
    80000066:	6902                	ld	s2,0(sp)
    80000068:	6105                	addi	sp,sp,32
    8000006a:	8082                	ret

000000008000006c <dec_ref>:

void
dec_ref(void *pa){
    8000006c:	1101                	addi	sp,sp,-32
    8000006e:	ec06                	sd	ra,24(sp)
    80000070:	e822                	sd	s0,16(sp)
    80000072:	e426                	sd	s1,8(sp)
    80000074:	e04a                	sd	s2,0(sp)
    80000076:	1000                	addi	s0,sp,32
    80000078:	84aa                	mv	s1,a0
  acquire(&cow_ref_lock);
    8000007a:	00009917          	auipc	s2,0x9
    8000007e:	8f690913          	addi	s2,s2,-1802 # 80008970 <cow_ref_lock>
    80000082:	854a                	mv	a0,s2
    80000084:	00006097          	auipc	ra,0x6
    80000088:	26a080e7          	jalr	618(ra) # 800062ee <acquire>
  cow_count[PA2COUNT(pa)]--;
    8000008c:	800007b7          	lui	a5,0x80000
    80000090:	94be                	add	s1,s1,a5
    80000092:	80b1                	srli	s1,s1,0xc
    80000094:	048a                	slli	s1,s1,0x2
    80000096:	00009797          	auipc	a5,0x9
    8000009a:	91278793          	addi	a5,a5,-1774 # 800089a8 <cow_count>
    8000009e:	97a6                	add	a5,a5,s1
    800000a0:	4398                	lw	a4,0(a5)
    800000a2:	377d                	addiw	a4,a4,-1
    800000a4:	c398                	sw	a4,0(a5)
  release(&cow_ref_lock);
    800000a6:	854a                	mv	a0,s2
    800000a8:	00006097          	auipc	ra,0x6
    800000ac:	2fa080e7          	jalr	762(ra) # 800063a2 <release>
}
    800000b0:	60e2                	ld	ra,24(sp)
    800000b2:	6442                	ld	s0,16(sp)
    800000b4:	64a2                	ld	s1,8(sp)
    800000b6:	6902                	ld	s2,0(sp)
    800000b8:	6105                	addi	sp,sp,32
    800000ba:	8082                	ret

00000000800000bc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000bc:	7179                	addi	sp,sp,-48
    800000be:	f406                	sd	ra,40(sp)
    800000c0:	f022                	sd	s0,32(sp)
    800000c2:	ec26                	sd	s1,24(sp)
    800000c4:	e84a                	sd	s2,16(sp)
    800000c6:	e44e                	sd	s3,8(sp)
    800000c8:	1800                	addi	s0,sp,48
    800000ca:	84aa                	mv	s1,a0
  dec_ref(pa);
    800000cc:	00000097          	auipc	ra,0x0
    800000d0:	fa0080e7          	jalr	-96(ra) # 8000006c <dec_ref>
  if(cow_count[PA2COUNT(pa)] > 0)
    800000d4:	800007b7          	lui	a5,0x80000
    800000d8:	97a6                	add	a5,a5,s1
    800000da:	83b1                	srli	a5,a5,0xc
    800000dc:	078a                	slli	a5,a5,0x2
    800000de:	00009717          	auipc	a4,0x9
    800000e2:	8ca70713          	addi	a4,a4,-1846 # 800089a8 <cow_count>
    800000e6:	97ba                	add	a5,a5,a4
    800000e8:	439c                	lw	a5,0(a5)
    800000ea:	04f04d63          	bgtz	a5,80000144 <kfree+0x88>
    return;

  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000ee:	03449793          	slli	a5,s1,0x34
    800000f2:	e3a5                	bnez	a5,80000152 <kfree+0x96>
    800000f4:	00042797          	auipc	a5,0x42
    800000f8:	d0c78793          	addi	a5,a5,-756 # 80041e00 <end>
    800000fc:	04f4eb63          	bltu	s1,a5,80000152 <kfree+0x96>
    80000100:	47c5                	li	a5,17
    80000102:	07ee                	slli	a5,a5,0x1b
    80000104:	04f4f763          	bgeu	s1,a5,80000152 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000108:	6605                	lui	a2,0x1
    8000010a:	4585                	li	a1,1
    8000010c:	8526                	mv	a0,s1
    8000010e:	00000097          	auipc	ra,0x0
    80000112:	176080e7          	jalr	374(ra) # 80000284 <memset>
  
  

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000116:	00009997          	auipc	s3,0x9
    8000011a:	85a98993          	addi	s3,s3,-1958 # 80008970 <cow_ref_lock>
    8000011e:	00009917          	auipc	s2,0x9
    80000122:	86a90913          	addi	s2,s2,-1942 # 80008988 <kmem>
    80000126:	854a                	mv	a0,s2
    80000128:	00006097          	auipc	ra,0x6
    8000012c:	1c6080e7          	jalr	454(ra) # 800062ee <acquire>
  r->next = kmem.freelist;
    80000130:	0309b783          	ld	a5,48(s3)
    80000134:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000136:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    8000013a:	854a                	mv	a0,s2
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	266080e7          	jalr	614(ra) # 800063a2 <release>
}
    80000144:	70a2                	ld	ra,40(sp)
    80000146:	7402                	ld	s0,32(sp)
    80000148:	64e2                	ld	s1,24(sp)
    8000014a:	6942                	ld	s2,16(sp)
    8000014c:	69a2                	ld	s3,8(sp)
    8000014e:	6145                	addi	sp,sp,48
    80000150:	8082                	ret
    panic("kfree");
    80000152:	00008517          	auipc	a0,0x8
    80000156:	ebe50513          	addi	a0,a0,-322 # 80008010 <etext+0x10>
    8000015a:	00006097          	auipc	ra,0x6
    8000015e:	c5c080e7          	jalr	-932(ra) # 80005db6 <panic>

0000000080000162 <freerange>:
{
    80000162:	7179                	addi	sp,sp,-48
    80000164:	f406                	sd	ra,40(sp)
    80000166:	f022                	sd	s0,32(sp)
    80000168:	ec26                	sd	s1,24(sp)
    8000016a:	e84a                	sd	s2,16(sp)
    8000016c:	e44e                	sd	s3,8(sp)
    8000016e:	e052                	sd	s4,0(sp)
    80000170:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000172:	6785                	lui	a5,0x1
    80000174:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000178:	00e504b3          	add	s1,a0,a4
    8000017c:	777d                	lui	a4,0xfffff
    8000017e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000180:	94be                	add	s1,s1,a5
    80000182:	0095ee63          	bltu	a1,s1,8000019e <freerange+0x3c>
    80000186:	892e                	mv	s2,a1
    kfree(p);
    80000188:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000018a:	6985                	lui	s3,0x1
    kfree(p);
    8000018c:	01448533          	add	a0,s1,s4
    80000190:	00000097          	auipc	ra,0x0
    80000194:	f2c080e7          	jalr	-212(ra) # 800000bc <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000198:	94ce                	add	s1,s1,s3
    8000019a:	fe9979e3          	bgeu	s2,s1,8000018c <freerange+0x2a>
}
    8000019e:	70a2                	ld	ra,40(sp)
    800001a0:	7402                	ld	s0,32(sp)
    800001a2:	64e2                	ld	s1,24(sp)
    800001a4:	6942                	ld	s2,16(sp)
    800001a6:	69a2                	ld	s3,8(sp)
    800001a8:	6a02                	ld	s4,0(sp)
    800001aa:	6145                	addi	sp,sp,48
    800001ac:	8082                	ret

00000000800001ae <kinit>:
{
    800001ae:	1141                	addi	sp,sp,-16
    800001b0:	e406                	sd	ra,8(sp)
    800001b2:	e022                	sd	s0,0(sp)
    800001b4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001b6:	00008597          	auipc	a1,0x8
    800001ba:	e6258593          	addi	a1,a1,-414 # 80008018 <etext+0x18>
    800001be:	00008517          	auipc	a0,0x8
    800001c2:	7ca50513          	addi	a0,a0,1994 # 80008988 <kmem>
    800001c6:	00006097          	auipc	ra,0x6
    800001ca:	098080e7          	jalr	152(ra) # 8000625e <initlock>
  initlock(&cow_ref_lock, "cow_ref_lock");
    800001ce:	00008597          	auipc	a1,0x8
    800001d2:	e5258593          	addi	a1,a1,-430 # 80008020 <etext+0x20>
    800001d6:	00008517          	auipc	a0,0x8
    800001da:	79a50513          	addi	a0,a0,1946 # 80008970 <cow_ref_lock>
    800001de:	00006097          	auipc	ra,0x6
    800001e2:	080080e7          	jalr	128(ra) # 8000625e <initlock>
  freerange(end, (void*)PHYSTOP);
    800001e6:	45c5                	li	a1,17
    800001e8:	05ee                	slli	a1,a1,0x1b
    800001ea:	00042517          	auipc	a0,0x42
    800001ee:	c1650513          	addi	a0,a0,-1002 # 80041e00 <end>
    800001f2:	00000097          	auipc	ra,0x0
    800001f6:	f70080e7          	jalr	-144(ra) # 80000162 <freerange>
}
    800001fa:	60a2                	ld	ra,8(sp)
    800001fc:	6402                	ld	s0,0(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret

0000000080000202 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000202:	1101                	addi	sp,sp,-32
    80000204:	ec06                	sd	ra,24(sp)
    80000206:	e822                	sd	s0,16(sp)
    80000208:	e426                	sd	s1,8(sp)
    8000020a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000020c:	00008517          	auipc	a0,0x8
    80000210:	77c50513          	addi	a0,a0,1916 # 80008988 <kmem>
    80000214:	00006097          	auipc	ra,0x6
    80000218:	0da080e7          	jalr	218(ra) # 800062ee <acquire>
  r = kmem.freelist;
    8000021c:	00008497          	auipc	s1,0x8
    80000220:	7844b483          	ld	s1,1924(s1) # 800089a0 <kmem+0x18>
  if(r)
    80000224:	c4b9                	beqz	s1,80000272 <kalloc+0x70>
    kmem.freelist = r->next;
    80000226:	609c                	ld	a5,0(s1)
    80000228:	00008717          	auipc	a4,0x8
    8000022c:	76f73c23          	sd	a5,1912(a4) # 800089a0 <kmem+0x18>
  release(&kmem.lock);
    80000230:	00008517          	auipc	a0,0x8
    80000234:	75850513          	addi	a0,a0,1880 # 80008988 <kmem>
    80000238:	00006097          	auipc	ra,0x6
    8000023c:	16a080e7          	jalr	362(ra) # 800063a2 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000240:	6605                	lui	a2,0x1
    80000242:	4595                	li	a1,5
    80000244:	8526                	mv	a0,s1
    80000246:	00000097          	auipc	ra,0x0
    8000024a:	03e080e7          	jalr	62(ra) # 80000284 <memset>
    cow_count[PA2COUNT(r)] = 1;
    8000024e:	800007b7          	lui	a5,0x80000
    80000252:	97a6                	add	a5,a5,s1
    80000254:	83b1                	srli	a5,a5,0xc
    80000256:	078a                	slli	a5,a5,0x2
    80000258:	00008717          	auipc	a4,0x8
    8000025c:	75070713          	addi	a4,a4,1872 # 800089a8 <cow_count>
    80000260:	97ba                	add	a5,a5,a4
    80000262:	4705                	li	a4,1
    80000264:	c398                	sw	a4,0(a5)
  }
  return (void*)r;
}
    80000266:	8526                	mv	a0,s1
    80000268:	60e2                	ld	ra,24(sp)
    8000026a:	6442                	ld	s0,16(sp)
    8000026c:	64a2                	ld	s1,8(sp)
    8000026e:	6105                	addi	sp,sp,32
    80000270:	8082                	ret
  release(&kmem.lock);
    80000272:	00008517          	auipc	a0,0x8
    80000276:	71650513          	addi	a0,a0,1814 # 80008988 <kmem>
    8000027a:	00006097          	auipc	ra,0x6
    8000027e:	128080e7          	jalr	296(ra) # 800063a2 <release>
  if(r){
    80000282:	b7d5                	j	80000266 <kalloc+0x64>

0000000080000284 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000028a:	ca19                	beqz	a2,800002a0 <memset+0x1c>
    8000028c:	87aa                	mv	a5,a0
    8000028e:	1602                	slli	a2,a2,0x20
    80000290:	9201                	srli	a2,a2,0x20
    80000292:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000296:	00b78023          	sb	a1,0(a5) # ffffffff80000000 <end+0xfffffffefffbe200>
  for(i = 0; i < n; i++){
    8000029a:	0785                	addi	a5,a5,1
    8000029c:	fee79de3          	bne	a5,a4,80000296 <memset+0x12>
  }
  return dst;
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret

00000000800002a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002a6:	1141                	addi	sp,sp,-16
    800002a8:	e422                	sd	s0,8(sp)
    800002aa:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002ac:	ca05                	beqz	a2,800002dc <memcmp+0x36>
    800002ae:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002b2:	1682                	slli	a3,a3,0x20
    800002b4:	9281                	srli	a3,a3,0x20
    800002b6:	0685                	addi	a3,a3,1
    800002b8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002ba:	00054783          	lbu	a5,0(a0)
    800002be:	0005c703          	lbu	a4,0(a1)
    800002c2:	00e79863          	bne	a5,a4,800002d2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002c6:	0505                	addi	a0,a0,1
    800002c8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002ca:	fed518e3          	bne	a0,a3,800002ba <memcmp+0x14>
  }

  return 0;
    800002ce:	4501                	li	a0,0
    800002d0:	a019                	j	800002d6 <memcmp+0x30>
      return *s1 - *s2;
    800002d2:	40e7853b          	subw	a0,a5,a4
}
    800002d6:	6422                	ld	s0,8(sp)
    800002d8:	0141                	addi	sp,sp,16
    800002da:	8082                	ret
  return 0;
    800002dc:	4501                	li	a0,0
    800002de:	bfe5                	j	800002d6 <memcmp+0x30>

00000000800002e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e0:	1141                	addi	sp,sp,-16
    800002e2:	e422                	sd	s0,8(sp)
    800002e4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002e6:	c205                	beqz	a2,80000306 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002e8:	02a5e263          	bltu	a1,a0,8000030c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002ec:	1602                	slli	a2,a2,0x20
    800002ee:	9201                	srli	a2,a2,0x20
    800002f0:	00c587b3          	add	a5,a1,a2
{
    800002f4:	872a                	mv	a4,a0
      *d++ = *s++;
    800002f6:	0585                	addi	a1,a1,1
    800002f8:	0705                	addi	a4,a4,1
    800002fa:	fff5c683          	lbu	a3,-1(a1)
    800002fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000302:	fef59ae3          	bne	a1,a5,800002f6 <memmove+0x16>

  return dst;
}
    80000306:	6422                	ld	s0,8(sp)
    80000308:	0141                	addi	sp,sp,16
    8000030a:	8082                	ret
  if(s < d && s + n > d){
    8000030c:	02061693          	slli	a3,a2,0x20
    80000310:	9281                	srli	a3,a3,0x20
    80000312:	00d58733          	add	a4,a1,a3
    80000316:	fce57be3          	bgeu	a0,a4,800002ec <memmove+0xc>
    d += n;
    8000031a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000031c:	fff6079b          	addiw	a5,a2,-1
    80000320:	1782                	slli	a5,a5,0x20
    80000322:	9381                	srli	a5,a5,0x20
    80000324:	fff7c793          	not	a5,a5
    80000328:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000032a:	177d                	addi	a4,a4,-1
    8000032c:	16fd                	addi	a3,a3,-1
    8000032e:	00074603          	lbu	a2,0(a4)
    80000332:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000336:	fee79ae3          	bne	a5,a4,8000032a <memmove+0x4a>
    8000033a:	b7f1                	j	80000306 <memmove+0x26>

000000008000033c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000033c:	1141                	addi	sp,sp,-16
    8000033e:	e406                	sd	ra,8(sp)
    80000340:	e022                	sd	s0,0(sp)
    80000342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000344:	00000097          	auipc	ra,0x0
    80000348:	f9c080e7          	jalr	-100(ra) # 800002e0 <memmove>
}
    8000034c:	60a2                	ld	ra,8(sp)
    8000034e:	6402                	ld	s0,0(sp)
    80000350:	0141                	addi	sp,sp,16
    80000352:	8082                	ret

0000000080000354 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000354:	1141                	addi	sp,sp,-16
    80000356:	e422                	sd	s0,8(sp)
    80000358:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000035a:	ce11                	beqz	a2,80000376 <strncmp+0x22>
    8000035c:	00054783          	lbu	a5,0(a0)
    80000360:	cf89                	beqz	a5,8000037a <strncmp+0x26>
    80000362:	0005c703          	lbu	a4,0(a1)
    80000366:	00f71a63          	bne	a4,a5,8000037a <strncmp+0x26>
    n--, p++, q++;
    8000036a:	367d                	addiw	a2,a2,-1
    8000036c:	0505                	addi	a0,a0,1
    8000036e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000370:	f675                	bnez	a2,8000035c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000372:	4501                	li	a0,0
    80000374:	a809                	j	80000386 <strncmp+0x32>
    80000376:	4501                	li	a0,0
    80000378:	a039                	j	80000386 <strncmp+0x32>
  if(n == 0)
    8000037a:	ca09                	beqz	a2,8000038c <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000037c:	00054503          	lbu	a0,0(a0)
    80000380:	0005c783          	lbu	a5,0(a1)
    80000384:	9d1d                	subw	a0,a0,a5
}
    80000386:	6422                	ld	s0,8(sp)
    80000388:	0141                	addi	sp,sp,16
    8000038a:	8082                	ret
    return 0;
    8000038c:	4501                	li	a0,0
    8000038e:	bfe5                	j	80000386 <strncmp+0x32>

0000000080000390 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000390:	1141                	addi	sp,sp,-16
    80000392:	e422                	sd	s0,8(sp)
    80000394:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000396:	87aa                	mv	a5,a0
    80000398:	86b2                	mv	a3,a2
    8000039a:	367d                	addiw	a2,a2,-1
    8000039c:	00d05963          	blez	a3,800003ae <strncpy+0x1e>
    800003a0:	0785                	addi	a5,a5,1
    800003a2:	0005c703          	lbu	a4,0(a1)
    800003a6:	fee78fa3          	sb	a4,-1(a5)
    800003aa:	0585                	addi	a1,a1,1
    800003ac:	f775                	bnez	a4,80000398 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003ae:	873e                	mv	a4,a5
    800003b0:	9fb5                	addw	a5,a5,a3
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	00c05963          	blez	a2,800003c6 <strncpy+0x36>
    *s++ = 0;
    800003b8:	0705                	addi	a4,a4,1
    800003ba:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003be:	40e786bb          	subw	a3,a5,a4
    800003c2:	fed04be3          	bgtz	a3,800003b8 <strncpy+0x28>
  return os;
}
    800003c6:	6422                	ld	s0,8(sp)
    800003c8:	0141                	addi	sp,sp,16
    800003ca:	8082                	ret

00000000800003cc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003cc:	1141                	addi	sp,sp,-16
    800003ce:	e422                	sd	s0,8(sp)
    800003d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003d2:	02c05363          	blez	a2,800003f8 <safestrcpy+0x2c>
    800003d6:	fff6069b          	addiw	a3,a2,-1
    800003da:	1682                	slli	a3,a3,0x20
    800003dc:	9281                	srli	a3,a3,0x20
    800003de:	96ae                	add	a3,a3,a1
    800003e0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003e2:	00d58963          	beq	a1,a3,800003f4 <safestrcpy+0x28>
    800003e6:	0585                	addi	a1,a1,1
    800003e8:	0785                	addi	a5,a5,1
    800003ea:	fff5c703          	lbu	a4,-1(a1)
    800003ee:	fee78fa3          	sb	a4,-1(a5)
    800003f2:	fb65                	bnez	a4,800003e2 <safestrcpy+0x16>
    ;
  *s = 0;
    800003f4:	00078023          	sb	zero,0(a5)
  return os;
}
    800003f8:	6422                	ld	s0,8(sp)
    800003fa:	0141                	addi	sp,sp,16
    800003fc:	8082                	ret

00000000800003fe <strlen>:

int
strlen(const char *s)
{
    800003fe:	1141                	addi	sp,sp,-16
    80000400:	e422                	sd	s0,8(sp)
    80000402:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000404:	00054783          	lbu	a5,0(a0)
    80000408:	cf91                	beqz	a5,80000424 <strlen+0x26>
    8000040a:	0505                	addi	a0,a0,1
    8000040c:	87aa                	mv	a5,a0
    8000040e:	86be                	mv	a3,a5
    80000410:	0785                	addi	a5,a5,1
    80000412:	fff7c703          	lbu	a4,-1(a5)
    80000416:	ff65                	bnez	a4,8000040e <strlen+0x10>
    80000418:	40a6853b          	subw	a0,a3,a0
    8000041c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000041e:	6422                	ld	s0,8(sp)
    80000420:	0141                	addi	sp,sp,16
    80000422:	8082                	ret
  for(n = 0; s[n]; n++)
    80000424:	4501                	li	a0,0
    80000426:	bfe5                	j	8000041e <strlen+0x20>

0000000080000428 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000428:	1141                	addi	sp,sp,-16
    8000042a:	e406                	sd	ra,8(sp)
    8000042c:	e022                	sd	s0,0(sp)
    8000042e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000430:	00001097          	auipc	ra,0x1
    80000434:	c34080e7          	jalr	-972(ra) # 80001064 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000438:	00008717          	auipc	a4,0x8
    8000043c:	50870713          	addi	a4,a4,1288 # 80008940 <started>
  if(cpuid() == 0){
    80000440:	c139                	beqz	a0,80000486 <main+0x5e>
    while(started == 0)
    80000442:	431c                	lw	a5,0(a4)
    80000444:	2781                	sext.w	a5,a5
    80000446:	dff5                	beqz	a5,80000442 <main+0x1a>
      ;
    __sync_synchronize();
    80000448:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000044c:	00001097          	auipc	ra,0x1
    80000450:	c18080e7          	jalr	-1000(ra) # 80001064 <cpuid>
    80000454:	85aa                	mv	a1,a0
    80000456:	00008517          	auipc	a0,0x8
    8000045a:	bf250513          	addi	a0,a0,-1038 # 80008048 <etext+0x48>
    8000045e:	00006097          	auipc	ra,0x6
    80000462:	9a2080e7          	jalr	-1630(ra) # 80005e00 <printf>
    kvminithart();    // turn on paging
    80000466:	00000097          	auipc	ra,0x0
    8000046a:	0d8080e7          	jalr	216(ra) # 8000053e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000046e:	00002097          	auipc	ra,0x2
    80000472:	8c0080e7          	jalr	-1856(ra) # 80001d2e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000476:	00005097          	auipc	ra,0x5
    8000047a:	e4a080e7          	jalr	-438(ra) # 800052c0 <plicinithart>
  }

  scheduler();        
    8000047e:	00001097          	auipc	ra,0x1
    80000482:	108080e7          	jalr	264(ra) # 80001586 <scheduler>
    consoleinit();
    80000486:	00006097          	auipc	ra,0x6
    8000048a:	840080e7          	jalr	-1984(ra) # 80005cc6 <consoleinit>
    printfinit();
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	b52080e7          	jalr	-1198(ra) # 80005fe0 <printfinit>
    printf("\n");
    80000496:	00008517          	auipc	a0,0x8
    8000049a:	bc250513          	addi	a0,a0,-1086 # 80008058 <etext+0x58>
    8000049e:	00006097          	auipc	ra,0x6
    800004a2:	962080e7          	jalr	-1694(ra) # 80005e00 <printf>
    printf("xv6 kernel is booting\n");
    800004a6:	00008517          	auipc	a0,0x8
    800004aa:	b8a50513          	addi	a0,a0,-1142 # 80008030 <etext+0x30>
    800004ae:	00006097          	auipc	ra,0x6
    800004b2:	952080e7          	jalr	-1710(ra) # 80005e00 <printf>
    printf("\n");
    800004b6:	00008517          	auipc	a0,0x8
    800004ba:	ba250513          	addi	a0,a0,-1118 # 80008058 <etext+0x58>
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	942080e7          	jalr	-1726(ra) # 80005e00 <printf>
    kinit();         // physical page allocator
    800004c6:	00000097          	auipc	ra,0x0
    800004ca:	ce8080e7          	jalr	-792(ra) # 800001ae <kinit>
    kvminit();       // create kernel page table
    800004ce:	00000097          	auipc	ra,0x0
    800004d2:	326080e7          	jalr	806(ra) # 800007f4 <kvminit>
    kvminithart();   // turn on paging
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	068080e7          	jalr	104(ra) # 8000053e <kvminithart>
    procinit();      // process table
    800004de:	00001097          	auipc	ra,0x1
    800004e2:	ad2080e7          	jalr	-1326(ra) # 80000fb0 <procinit>
    trapinit();      // trap vectors
    800004e6:	00002097          	auipc	ra,0x2
    800004ea:	820080e7          	jalr	-2016(ra) # 80001d06 <trapinit>
    trapinithart();  // install kernel trap vector
    800004ee:	00002097          	auipc	ra,0x2
    800004f2:	840080e7          	jalr	-1984(ra) # 80001d2e <trapinithart>
    plicinit();      // set up interrupt controller
    800004f6:	00005097          	auipc	ra,0x5
    800004fa:	db4080e7          	jalr	-588(ra) # 800052aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004fe:	00005097          	auipc	ra,0x5
    80000502:	dc2080e7          	jalr	-574(ra) # 800052c0 <plicinithart>
    binit();         // buffer cache
    80000506:	00002097          	auipc	ra,0x2
    8000050a:	fb8080e7          	jalr	-72(ra) # 800024be <binit>
    iinit();         // inode table
    8000050e:	00002097          	auipc	ra,0x2
    80000512:	656080e7          	jalr	1622(ra) # 80002b64 <iinit>
    fileinit();      // file table
    80000516:	00003097          	auipc	ra,0x3
    8000051a:	5cc080e7          	jalr	1484(ra) # 80003ae2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000051e:	00005097          	auipc	ra,0x5
    80000522:	eaa080e7          	jalr	-342(ra) # 800053c8 <virtio_disk_init>
    userinit();      // first user process
    80000526:	00001097          	auipc	ra,0x1
    8000052a:	e42080e7          	jalr	-446(ra) # 80001368 <userinit>
    __sync_synchronize();
    8000052e:	0ff0000f          	fence
    started = 1;
    80000532:	4785                	li	a5,1
    80000534:	00008717          	auipc	a4,0x8
    80000538:	40f72623          	sw	a5,1036(a4) # 80008940 <started>
    8000053c:	b789                	j	8000047e <main+0x56>

000000008000053e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000053e:	1141                	addi	sp,sp,-16
    80000540:	e422                	sd	s0,8(sp)
    80000542:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000544:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000548:	00008797          	auipc	a5,0x8
    8000054c:	4007b783          	ld	a5,1024(a5) # 80008948 <kernel_pagetable>
    80000550:	83b1                	srli	a5,a5,0xc
    80000552:	577d                	li	a4,-1
    80000554:	177e                	slli	a4,a4,0x3f
    80000556:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000558:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000055c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000560:	6422                	ld	s0,8(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret

0000000080000566 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000566:	7139                	addi	sp,sp,-64
    80000568:	fc06                	sd	ra,56(sp)
    8000056a:	f822                	sd	s0,48(sp)
    8000056c:	f426                	sd	s1,40(sp)
    8000056e:	f04a                	sd	s2,32(sp)
    80000570:	ec4e                	sd	s3,24(sp)
    80000572:	e852                	sd	s4,16(sp)
    80000574:	e456                	sd	s5,8(sp)
    80000576:	e05a                	sd	s6,0(sp)
    80000578:	0080                	addi	s0,sp,64
    8000057a:	84aa                	mv	s1,a0
    8000057c:	89ae                	mv	s3,a1
    8000057e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000580:	57fd                	li	a5,-1
    80000582:	83e9                	srli	a5,a5,0x1a
    80000584:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000586:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000588:	04b7f263          	bgeu	a5,a1,800005cc <walk+0x66>
    panic("walk");
    8000058c:	00008517          	auipc	a0,0x8
    80000590:	ad450513          	addi	a0,a0,-1324 # 80008060 <etext+0x60>
    80000594:	00006097          	auipc	ra,0x6
    80000598:	822080e7          	jalr	-2014(ra) # 80005db6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000059c:	060a8663          	beqz	s5,80000608 <walk+0xa2>
    800005a0:	00000097          	auipc	ra,0x0
    800005a4:	c62080e7          	jalr	-926(ra) # 80000202 <kalloc>
    800005a8:	84aa                	mv	s1,a0
    800005aa:	c529                	beqz	a0,800005f4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005ac:	6605                	lui	a2,0x1
    800005ae:	4581                	li	a1,0
    800005b0:	00000097          	auipc	ra,0x0
    800005b4:	cd4080e7          	jalr	-812(ra) # 80000284 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005b8:	00c4d793          	srli	a5,s1,0xc
    800005bc:	07aa                	slli	a5,a5,0xa
    800005be:	0017e793          	ori	a5,a5,1
    800005c2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005c6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffbd1f7>
    800005c8:	036a0063          	beq	s4,s6,800005e8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005cc:	0149d933          	srl	s2,s3,s4
    800005d0:	1ff97913          	andi	s2,s2,511
    800005d4:	090e                	slli	s2,s2,0x3
    800005d6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005d8:	00093483          	ld	s1,0(s2)
    800005dc:	0014f793          	andi	a5,s1,1
    800005e0:	dfd5                	beqz	a5,8000059c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005e2:	80a9                	srli	s1,s1,0xa
    800005e4:	04b2                	slli	s1,s1,0xc
    800005e6:	b7c5                	j	800005c6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005e8:	00c9d513          	srli	a0,s3,0xc
    800005ec:	1ff57513          	andi	a0,a0,511
    800005f0:	050e                	slli	a0,a0,0x3
    800005f2:	9526                	add	a0,a0,s1
}
    800005f4:	70e2                	ld	ra,56(sp)
    800005f6:	7442                	ld	s0,48(sp)
    800005f8:	74a2                	ld	s1,40(sp)
    800005fa:	7902                	ld	s2,32(sp)
    800005fc:	69e2                	ld	s3,24(sp)
    800005fe:	6a42                	ld	s4,16(sp)
    80000600:	6aa2                	ld	s5,8(sp)
    80000602:	6b02                	ld	s6,0(sp)
    80000604:	6121                	addi	sp,sp,64
    80000606:	8082                	ret
        return 0;
    80000608:	4501                	li	a0,0
    8000060a:	b7ed                	j	800005f4 <walk+0x8e>

000000008000060c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000060c:	57fd                	li	a5,-1
    8000060e:	83e9                	srli	a5,a5,0x1a
    80000610:	00b7f463          	bgeu	a5,a1,80000618 <walkaddr+0xc>
    return 0;
    80000614:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000616:	8082                	ret
{
    80000618:	1141                	addi	sp,sp,-16
    8000061a:	e406                	sd	ra,8(sp)
    8000061c:	e022                	sd	s0,0(sp)
    8000061e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000620:	4601                	li	a2,0
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f44080e7          	jalr	-188(ra) # 80000566 <walk>
  if(pte == 0)
    8000062a:	c105                	beqz	a0,8000064a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000062c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000062e:	0117f693          	andi	a3,a5,17
    80000632:	4745                	li	a4,17
    return 0;
    80000634:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000636:	00e68663          	beq	a3,a4,80000642 <walkaddr+0x36>
}
    8000063a:	60a2                	ld	ra,8(sp)
    8000063c:	6402                	ld	s0,0(sp)
    8000063e:	0141                	addi	sp,sp,16
    80000640:	8082                	ret
  pa = PTE2PA(*pte);
    80000642:	83a9                	srli	a5,a5,0xa
    80000644:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000648:	bfcd                	j	8000063a <walkaddr+0x2e>
    return 0;
    8000064a:	4501                	li	a0,0
    8000064c:	b7fd                	j	8000063a <walkaddr+0x2e>

000000008000064e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000064e:	715d                	addi	sp,sp,-80
    80000650:	e486                	sd	ra,72(sp)
    80000652:	e0a2                	sd	s0,64(sp)
    80000654:	fc26                	sd	s1,56(sp)
    80000656:	f84a                	sd	s2,48(sp)
    80000658:	f44e                	sd	s3,40(sp)
    8000065a:	f052                	sd	s4,32(sp)
    8000065c:	ec56                	sd	s5,24(sp)
    8000065e:	e85a                	sd	s6,16(sp)
    80000660:	e45e                	sd	s7,8(sp)
    80000662:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000664:	c639                	beqz	a2,800006b2 <mappages+0x64>
    80000666:	8aaa                	mv	s5,a0
    80000668:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000066a:	777d                	lui	a4,0xfffff
    8000066c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000670:	fff58993          	addi	s3,a1,-1
    80000674:	99b2                	add	s3,s3,a2
    80000676:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000067a:	893e                	mv	s2,a5
    8000067c:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000680:	6b85                	lui	s7,0x1
    80000682:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000686:	4605                	li	a2,1
    80000688:	85ca                	mv	a1,s2
    8000068a:	8556                	mv	a0,s5
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	eda080e7          	jalr	-294(ra) # 80000566 <walk>
    80000694:	cd1d                	beqz	a0,800006d2 <mappages+0x84>
    if(*pte & PTE_V)
    80000696:	611c                	ld	a5,0(a0)
    80000698:	8b85                	andi	a5,a5,1
    8000069a:	e785                	bnez	a5,800006c2 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000069c:	80b1                	srli	s1,s1,0xc
    8000069e:	04aa                	slli	s1,s1,0xa
    800006a0:	0164e4b3          	or	s1,s1,s6
    800006a4:	0014e493          	ori	s1,s1,1
    800006a8:	e104                	sd	s1,0(a0)
    if(a == last)
    800006aa:	05390063          	beq	s2,s3,800006ea <mappages+0x9c>
    a += PGSIZE;
    800006ae:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006b0:	bfc9                	j	80000682 <mappages+0x34>
    panic("mappages: size");
    800006b2:	00008517          	auipc	a0,0x8
    800006b6:	9b650513          	addi	a0,a0,-1610 # 80008068 <etext+0x68>
    800006ba:	00005097          	auipc	ra,0x5
    800006be:	6fc080e7          	jalr	1788(ra) # 80005db6 <panic>
      panic("mappages: remap");
    800006c2:	00008517          	auipc	a0,0x8
    800006c6:	9b650513          	addi	a0,a0,-1610 # 80008078 <etext+0x78>
    800006ca:	00005097          	auipc	ra,0x5
    800006ce:	6ec080e7          	jalr	1772(ra) # 80005db6 <panic>
      return -1;
    800006d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006d4:	60a6                	ld	ra,72(sp)
    800006d6:	6406                	ld	s0,64(sp)
    800006d8:	74e2                	ld	s1,56(sp)
    800006da:	7942                	ld	s2,48(sp)
    800006dc:	79a2                	ld	s3,40(sp)
    800006de:	7a02                	ld	s4,32(sp)
    800006e0:	6ae2                	ld	s5,24(sp)
    800006e2:	6b42                	ld	s6,16(sp)
    800006e4:	6ba2                	ld	s7,8(sp)
    800006e6:	6161                	addi	sp,sp,80
    800006e8:	8082                	ret
  return 0;
    800006ea:	4501                	li	a0,0
    800006ec:	b7e5                	j	800006d4 <mappages+0x86>

00000000800006ee <kvmmap>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
    800006f6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006f8:	86b2                	mv	a3,a2
    800006fa:	863e                	mv	a2,a5
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	f52080e7          	jalr	-174(ra) # 8000064e <mappages>
    80000704:	e509                	bnez	a0,8000070e <kvmmap+0x20>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret
    panic("kvmmap");
    8000070e:	00008517          	auipc	a0,0x8
    80000712:	97a50513          	addi	a0,a0,-1670 # 80008088 <etext+0x88>
    80000716:	00005097          	auipc	ra,0x5
    8000071a:	6a0080e7          	jalr	1696(ra) # 80005db6 <panic>

000000008000071e <kvmmake>:
{
    8000071e:	1101                	addi	sp,sp,-32
    80000720:	ec06                	sd	ra,24(sp)
    80000722:	e822                	sd	s0,16(sp)
    80000724:	e426                	sd	s1,8(sp)
    80000726:	e04a                	sd	s2,0(sp)
    80000728:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ad8080e7          	jalr	-1320(ra) # 80000202 <kalloc>
    80000732:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000734:	6605                	lui	a2,0x1
    80000736:	4581                	li	a1,0
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	b4c080e7          	jalr	-1204(ra) # 80000284 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000740:	4719                	li	a4,6
    80000742:	6685                	lui	a3,0x1
    80000744:	10000637          	lui	a2,0x10000
    80000748:	100005b7          	lui	a1,0x10000
    8000074c:	8526                	mv	a0,s1
    8000074e:	00000097          	auipc	ra,0x0
    80000752:	fa0080e7          	jalr	-96(ra) # 800006ee <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000756:	4719                	li	a4,6
    80000758:	6685                	lui	a3,0x1
    8000075a:	10001637          	lui	a2,0x10001
    8000075e:	100015b7          	lui	a1,0x10001
    80000762:	8526                	mv	a0,s1
    80000764:	00000097          	auipc	ra,0x0
    80000768:	f8a080e7          	jalr	-118(ra) # 800006ee <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000076c:	4719                	li	a4,6
    8000076e:	004006b7          	lui	a3,0x400
    80000772:	0c000637          	lui	a2,0xc000
    80000776:	0c0005b7          	lui	a1,0xc000
    8000077a:	8526                	mv	a0,s1
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	f72080e7          	jalr	-142(ra) # 800006ee <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000784:	00008917          	auipc	s2,0x8
    80000788:	87c90913          	addi	s2,s2,-1924 # 80008000 <etext>
    8000078c:	4729                	li	a4,10
    8000078e:	80008697          	auipc	a3,0x80008
    80000792:	87268693          	addi	a3,a3,-1934 # 8000 <_entry-0x7fff8000>
    80000796:	4605                	li	a2,1
    80000798:	067e                	slli	a2,a2,0x1f
    8000079a:	85b2                	mv	a1,a2
    8000079c:	8526                	mv	a0,s1
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	f50080e7          	jalr	-176(ra) # 800006ee <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007a6:	4719                	li	a4,6
    800007a8:	46c5                	li	a3,17
    800007aa:	06ee                	slli	a3,a3,0x1b
    800007ac:	412686b3          	sub	a3,a3,s2
    800007b0:	864a                	mv	a2,s2
    800007b2:	85ca                	mv	a1,s2
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	f38080e7          	jalr	-200(ra) # 800006ee <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007be:	4729                	li	a4,10
    800007c0:	6685                	lui	a3,0x1
    800007c2:	00007617          	auipc	a2,0x7
    800007c6:	83e60613          	addi	a2,a2,-1986 # 80007000 <_trampoline>
    800007ca:	040005b7          	lui	a1,0x4000
    800007ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007d0:	05b2                	slli	a1,a1,0xc
    800007d2:	8526                	mv	a0,s1
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	f1a080e7          	jalr	-230(ra) # 800006ee <kvmmap>
  proc_mapstacks(kpgtbl);
    800007dc:	8526                	mv	a0,s1
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	73c080e7          	jalr	1852(ra) # 80000f1a <proc_mapstacks>
}
    800007e6:	8526                	mv	a0,s1
    800007e8:	60e2                	ld	ra,24(sp)
    800007ea:	6442                	ld	s0,16(sp)
    800007ec:	64a2                	ld	s1,8(sp)
    800007ee:	6902                	ld	s2,0(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret

00000000800007f4 <kvminit>:
{
    800007f4:	1141                	addi	sp,sp,-16
    800007f6:	e406                	sd	ra,8(sp)
    800007f8:	e022                	sd	s0,0(sp)
    800007fa:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	f22080e7          	jalr	-222(ra) # 8000071e <kvmmake>
    80000804:	00008797          	auipc	a5,0x8
    80000808:	14a7b223          	sd	a0,324(a5) # 80008948 <kernel_pagetable>
}
    8000080c:	60a2                	ld	ra,8(sp)
    8000080e:	6402                	ld	s0,0(sp)
    80000810:	0141                	addi	sp,sp,16
    80000812:	8082                	ret

0000000080000814 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000814:	715d                	addi	sp,sp,-80
    80000816:	e486                	sd	ra,72(sp)
    80000818:	e0a2                	sd	s0,64(sp)
    8000081a:	fc26                	sd	s1,56(sp)
    8000081c:	f84a                	sd	s2,48(sp)
    8000081e:	f44e                	sd	s3,40(sp)
    80000820:	f052                	sd	s4,32(sp)
    80000822:	ec56                	sd	s5,24(sp)
    80000824:	e85a                	sd	s6,16(sp)
    80000826:	e45e                	sd	s7,8(sp)
    80000828:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000082a:	03459793          	slli	a5,a1,0x34
    8000082e:	e795                	bnez	a5,8000085a <uvmunmap+0x46>
    80000830:	8a2a                	mv	s4,a0
    80000832:	892e                	mv	s2,a1
    80000834:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000836:	0632                	slli	a2,a2,0xc
    80000838:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000083c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000083e:	6b05                	lui	s6,0x1
    80000840:	0735e263          	bltu	a1,s3,800008a4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000844:	60a6                	ld	ra,72(sp)
    80000846:	6406                	ld	s0,64(sp)
    80000848:	74e2                	ld	s1,56(sp)
    8000084a:	7942                	ld	s2,48(sp)
    8000084c:	79a2                	ld	s3,40(sp)
    8000084e:	7a02                	ld	s4,32(sp)
    80000850:	6ae2                	ld	s5,24(sp)
    80000852:	6b42                	ld	s6,16(sp)
    80000854:	6ba2                	ld	s7,8(sp)
    80000856:	6161                	addi	sp,sp,80
    80000858:	8082                	ret
    panic("uvmunmap: not aligned");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	83650513          	addi	a0,a0,-1994 # 80008090 <etext+0x90>
    80000862:	00005097          	auipc	ra,0x5
    80000866:	554080e7          	jalr	1364(ra) # 80005db6 <panic>
      panic("uvmunmap: walk");
    8000086a:	00008517          	auipc	a0,0x8
    8000086e:	83e50513          	addi	a0,a0,-1986 # 800080a8 <etext+0xa8>
    80000872:	00005097          	auipc	ra,0x5
    80000876:	544080e7          	jalr	1348(ra) # 80005db6 <panic>
      panic("uvmunmap: not mapped");
    8000087a:	00008517          	auipc	a0,0x8
    8000087e:	83e50513          	addi	a0,a0,-1986 # 800080b8 <etext+0xb8>
    80000882:	00005097          	auipc	ra,0x5
    80000886:	534080e7          	jalr	1332(ra) # 80005db6 <panic>
      panic("uvmunmap: not a leaf");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	84650513          	addi	a0,a0,-1978 # 800080d0 <etext+0xd0>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	524080e7          	jalr	1316(ra) # 80005db6 <panic>
    *pte = 0;
    8000089a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000089e:	995a                	add	s2,s2,s6
    800008a0:	fb3972e3          	bgeu	s2,s3,80000844 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008a4:	4601                	li	a2,0
    800008a6:	85ca                	mv	a1,s2
    800008a8:	8552                	mv	a0,s4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	cbc080e7          	jalr	-836(ra) # 80000566 <walk>
    800008b2:	84aa                	mv	s1,a0
    800008b4:	d95d                	beqz	a0,8000086a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008b6:	6108                	ld	a0,0(a0)
    800008b8:	00157793          	andi	a5,a0,1
    800008bc:	dfdd                	beqz	a5,8000087a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008be:	3ff57793          	andi	a5,a0,1023
    800008c2:	fd7784e3          	beq	a5,s7,8000088a <uvmunmap+0x76>
    if(do_free){
    800008c6:	fc0a8ae3          	beqz	s5,8000089a <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008ca:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008cc:	0532                	slli	a0,a0,0xc
    800008ce:	fffff097          	auipc	ra,0xfffff
    800008d2:	7ee080e7          	jalr	2030(ra) # 800000bc <kfree>
    800008d6:	b7d1                	j	8000089a <uvmunmap+0x86>

00000000800008d8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008d8:	1101                	addi	sp,sp,-32
    800008da:	ec06                	sd	ra,24(sp)
    800008dc:	e822                	sd	s0,16(sp)
    800008de:	e426                	sd	s1,8(sp)
    800008e0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	920080e7          	jalr	-1760(ra) # 80000202 <kalloc>
    800008ea:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008ec:	c519                	beqz	a0,800008fa <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008ee:	6605                	lui	a2,0x1
    800008f0:	4581                	li	a1,0
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	992080e7          	jalr	-1646(ra) # 80000284 <memset>
  return pagetable;
}
    800008fa:	8526                	mv	a0,s1
    800008fc:	60e2                	ld	ra,24(sp)
    800008fe:	6442                	ld	s0,16(sp)
    80000900:	64a2                	ld	s1,8(sp)
    80000902:	6105                	addi	sp,sp,32
    80000904:	8082                	ret

0000000080000906 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000906:	7179                	addi	sp,sp,-48
    80000908:	f406                	sd	ra,40(sp)
    8000090a:	f022                	sd	s0,32(sp)
    8000090c:	ec26                	sd	s1,24(sp)
    8000090e:	e84a                	sd	s2,16(sp)
    80000910:	e44e                	sd	s3,8(sp)
    80000912:	e052                	sd	s4,0(sp)
    80000914:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000916:	6785                	lui	a5,0x1
    80000918:	04f67863          	bgeu	a2,a5,80000968 <uvmfirst+0x62>
    8000091c:	8a2a                	mv	s4,a0
    8000091e:	89ae                	mv	s3,a1
    80000920:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000922:	00000097          	auipc	ra,0x0
    80000926:	8e0080e7          	jalr	-1824(ra) # 80000202 <kalloc>
    8000092a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000092c:	6605                	lui	a2,0x1
    8000092e:	4581                	li	a1,0
    80000930:	00000097          	auipc	ra,0x0
    80000934:	954080e7          	jalr	-1708(ra) # 80000284 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000938:	4779                	li	a4,30
    8000093a:	86ca                	mv	a3,s2
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	8552                	mv	a0,s4
    80000942:	00000097          	auipc	ra,0x0
    80000946:	d0c080e7          	jalr	-756(ra) # 8000064e <mappages>
  memmove(mem, src, sz);
    8000094a:	8626                	mv	a2,s1
    8000094c:	85ce                	mv	a1,s3
    8000094e:	854a                	mv	a0,s2
    80000950:	00000097          	auipc	ra,0x0
    80000954:	990080e7          	jalr	-1648(ra) # 800002e0 <memmove>
}
    80000958:	70a2                	ld	ra,40(sp)
    8000095a:	7402                	ld	s0,32(sp)
    8000095c:	64e2                	ld	s1,24(sp)
    8000095e:	6942                	ld	s2,16(sp)
    80000960:	69a2                	ld	s3,8(sp)
    80000962:	6a02                	ld	s4,0(sp)
    80000964:	6145                	addi	sp,sp,48
    80000966:	8082                	ret
    panic("uvmfirst: more than a page");
    80000968:	00007517          	auipc	a0,0x7
    8000096c:	78050513          	addi	a0,a0,1920 # 800080e8 <etext+0xe8>
    80000970:	00005097          	auipc	ra,0x5
    80000974:	446080e7          	jalr	1094(ra) # 80005db6 <panic>

0000000080000978 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000978:	1101                	addi	sp,sp,-32
    8000097a:	ec06                	sd	ra,24(sp)
    8000097c:	e822                	sd	s0,16(sp)
    8000097e:	e426                	sd	s1,8(sp)
    80000980:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000982:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000984:	00b67d63          	bgeu	a2,a1,8000099e <uvmdealloc+0x26>
    80000988:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000098a:	6785                	lui	a5,0x1
    8000098c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000098e:	00f60733          	add	a4,a2,a5
    80000992:	76fd                	lui	a3,0xfffff
    80000994:	8f75                	and	a4,a4,a3
    80000996:	97ae                	add	a5,a5,a1
    80000998:	8ff5                	and	a5,a5,a3
    8000099a:	00f76863          	bltu	a4,a5,800009aa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000099e:	8526                	mv	a0,s1
    800009a0:	60e2                	ld	ra,24(sp)
    800009a2:	6442                	ld	s0,16(sp)
    800009a4:	64a2                	ld	s1,8(sp)
    800009a6:	6105                	addi	sp,sp,32
    800009a8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009aa:	8f99                	sub	a5,a5,a4
    800009ac:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009ae:	4685                	li	a3,1
    800009b0:	0007861b          	sext.w	a2,a5
    800009b4:	85ba                	mv	a1,a4
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	e5e080e7          	jalr	-418(ra) # 80000814 <uvmunmap>
    800009be:	b7c5                	j	8000099e <uvmdealloc+0x26>

00000000800009c0 <uvmalloc>:
  if(newsz < oldsz)
    800009c0:	0ab66563          	bltu	a2,a1,80000a6a <uvmalloc+0xaa>
{
    800009c4:	7139                	addi	sp,sp,-64
    800009c6:	fc06                	sd	ra,56(sp)
    800009c8:	f822                	sd	s0,48(sp)
    800009ca:	f426                	sd	s1,40(sp)
    800009cc:	f04a                	sd	s2,32(sp)
    800009ce:	ec4e                	sd	s3,24(sp)
    800009d0:	e852                	sd	s4,16(sp)
    800009d2:	e456                	sd	s5,8(sp)
    800009d4:	e05a                	sd	s6,0(sp)
    800009d6:	0080                	addi	s0,sp,64
    800009d8:	8aaa                	mv	s5,a0
    800009da:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009dc:	6785                	lui	a5,0x1
    800009de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e0:	95be                	add	a1,a1,a5
    800009e2:	77fd                	lui	a5,0xfffff
    800009e4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009e8:	08c9f363          	bgeu	s3,a2,80000a6e <uvmalloc+0xae>
    800009ec:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009ee:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009f2:	00000097          	auipc	ra,0x0
    800009f6:	810080e7          	jalr	-2032(ra) # 80000202 <kalloc>
    800009fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800009fc:	c51d                	beqz	a0,80000a2a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4581                	li	a1,0
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	882080e7          	jalr	-1918(ra) # 80000284 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000a0a:	875a                	mv	a4,s6
    80000a0c:	86a6                	mv	a3,s1
    80000a0e:	6605                	lui	a2,0x1
    80000a10:	85ca                	mv	a1,s2
    80000a12:	8556                	mv	a0,s5
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	c3a080e7          	jalr	-966(ra) # 8000064e <mappages>
    80000a1c:	e90d                	bnez	a0,80000a4e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a1e:	6785                	lui	a5,0x1
    80000a20:	993e                	add	s2,s2,a5
    80000a22:	fd4968e3          	bltu	s2,s4,800009f2 <uvmalloc+0x32>
  return newsz;
    80000a26:	8552                	mv	a0,s4
    80000a28:	a809                	j	80000a3a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a2a:	864e                	mv	a2,s3
    80000a2c:	85ca                	mv	a1,s2
    80000a2e:	8556                	mv	a0,s5
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	f48080e7          	jalr	-184(ra) # 80000978 <uvmdealloc>
      return 0;
    80000a38:	4501                	li	a0,0
}
    80000a3a:	70e2                	ld	ra,56(sp)
    80000a3c:	7442                	ld	s0,48(sp)
    80000a3e:	74a2                	ld	s1,40(sp)
    80000a40:	7902                	ld	s2,32(sp)
    80000a42:	69e2                	ld	s3,24(sp)
    80000a44:	6a42                	ld	s4,16(sp)
    80000a46:	6aa2                	ld	s5,8(sp)
    80000a48:	6b02                	ld	s6,0(sp)
    80000a4a:	6121                	addi	sp,sp,64
    80000a4c:	8082                	ret
      kfree(mem);
    80000a4e:	8526                	mv	a0,s1
    80000a50:	fffff097          	auipc	ra,0xfffff
    80000a54:	66c080e7          	jalr	1644(ra) # 800000bc <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a58:	864e                	mv	a2,s3
    80000a5a:	85ca                	mv	a1,s2
    80000a5c:	8556                	mv	a0,s5
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	f1a080e7          	jalr	-230(ra) # 80000978 <uvmdealloc>
      return 0;
    80000a66:	4501                	li	a0,0
    80000a68:	bfc9                	j	80000a3a <uvmalloc+0x7a>
    return oldsz;
    80000a6a:	852e                	mv	a0,a1
}
    80000a6c:	8082                	ret
  return newsz;
    80000a6e:	8532                	mv	a0,a2
    80000a70:	b7e9                	j	80000a3a <uvmalloc+0x7a>

0000000080000a72 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a72:	7179                	addi	sp,sp,-48
    80000a74:	f406                	sd	ra,40(sp)
    80000a76:	f022                	sd	s0,32(sp)
    80000a78:	ec26                	sd	s1,24(sp)
    80000a7a:	e84a                	sd	s2,16(sp)
    80000a7c:	e44e                	sd	s3,8(sp)
    80000a7e:	e052                	sd	s4,0(sp)
    80000a80:	1800                	addi	s0,sp,48
    80000a82:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a84:	84aa                	mv	s1,a0
    80000a86:	6905                	lui	s2,0x1
    80000a88:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a8a:	4985                	li	s3,1
    80000a8c:	a829                	j	80000aa6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a8e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a90:	00c79513          	slli	a0,a5,0xc
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	fde080e7          	jalr	-34(ra) # 80000a72 <freewalk>
      pagetable[i] = 0;
    80000a9c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aa0:	04a1                	addi	s1,s1,8
    80000aa2:	03248163          	beq	s1,s2,80000ac4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aa6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa8:	00f7f713          	andi	a4,a5,15
    80000aac:	ff3701e3          	beq	a4,s3,80000a8e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ab0:	8b85                	andi	a5,a5,1
    80000ab2:	d7fd                	beqz	a5,80000aa0 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	65450513          	addi	a0,a0,1620 # 80008108 <etext+0x108>
    80000abc:	00005097          	auipc	ra,0x5
    80000ac0:	2fa080e7          	jalr	762(ra) # 80005db6 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ac4:	8552                	mv	a0,s4
    80000ac6:	fffff097          	auipc	ra,0xfffff
    80000aca:	5f6080e7          	jalr	1526(ra) # 800000bc <kfree>
}
    80000ace:	70a2                	ld	ra,40(sp)
    80000ad0:	7402                	ld	s0,32(sp)
    80000ad2:	64e2                	ld	s1,24(sp)
    80000ad4:	6942                	ld	s2,16(sp)
    80000ad6:	69a2                	ld	s3,8(sp)
    80000ad8:	6a02                	ld	s4,0(sp)
    80000ada:	6145                	addi	sp,sp,48
    80000adc:	8082                	ret

0000000080000ade <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ade:	1101                	addi	sp,sp,-32
    80000ae0:	ec06                	sd	ra,24(sp)
    80000ae2:	e822                	sd	s0,16(sp)
    80000ae4:	e426                	sd	s1,8(sp)
    80000ae6:	1000                	addi	s0,sp,32
    80000ae8:	84aa                	mv	s1,a0
  if(sz > 0)
    80000aea:	e999                	bnez	a1,80000b00 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000aec:	8526                	mv	a0,s1
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f84080e7          	jalr	-124(ra) # 80000a72 <freewalk>
}
    80000af6:	60e2                	ld	ra,24(sp)
    80000af8:	6442                	ld	s0,16(sp)
    80000afa:	64a2                	ld	s1,8(sp)
    80000afc:	6105                	addi	sp,sp,32
    80000afe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b00:	6785                	lui	a5,0x1
    80000b02:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b04:	95be                	add	a1,a1,a5
    80000b06:	4685                	li	a3,1
    80000b08:	00c5d613          	srli	a2,a1,0xc
    80000b0c:	4581                	li	a1,0
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	d06080e7          	jalr	-762(ra) # 80000814 <uvmunmap>
    80000b16:	bfd9                	j	80000aec <uvmfree+0xe>

0000000080000b18 <uvmcopy>:
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.

int /* TODO */
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b18:	7139                	addi	sp,sp,-64
    80000b1a:	fc06                	sd	ra,56(sp)
    80000b1c:	f822                	sd	s0,48(sp)
    80000b1e:	f426                	sd	s1,40(sp)
    80000b20:	f04a                	sd	s2,32(sp)
    80000b22:	ec4e                	sd	s3,24(sp)
    80000b24:	e852                	sd	s4,16(sp)
    80000b26:	e456                	sd	s5,8(sp)
    80000b28:	e05a                	sd	s6,0(sp)
    80000b2a:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  for(i = 0; i < sz; i += PGSIZE){
    80000b2c:	ca45                	beqz	a2,80000bdc <uvmcopy+0xc4>
    80000b2e:	8aaa                	mv	s5,a0
    80000b30:	8a2e                	mv	s4,a1
    80000b32:	89b2                	mv	s3,a2
    80000b34:	4481                	li	s1,0
    80000b36:	a891                	j	80000b8a <uvmcopy+0x72>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000b38:	00007517          	auipc	a0,0x7
    80000b3c:	5e050513          	addi	a0,a0,1504 # 80008118 <etext+0x118>
    80000b40:	00005097          	auipc	ra,0x5
    80000b44:	276080e7          	jalr	630(ra) # 80005db6 <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000b48:	00007517          	auipc	a0,0x7
    80000b4c:	5f050513          	addi	a0,a0,1520 # 80008138 <etext+0x138>
    80000b50:	00005097          	auipc	ra,0x5
    80000b54:	266080e7          	jalr	614(ra) # 80005db6 <panic>
    if(*pte & PTE_W){
      *pte &= ~PTE_W;
      *pte |= PTE_COW;
    }
    pa = PTE2PA(*pte);
    80000b58:	6118                	ld	a4,0(a0)
    80000b5a:	00a75913          	srli	s2,a4,0xa
    80000b5e:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000b60:	3ff77713          	andi	a4,a4,1023
    80000b64:	86ca                	mv	a3,s2
    80000b66:	6605                	lui	a2,0x1
    80000b68:	85a6                	mv	a1,s1
    80000b6a:	8552                	mv	a0,s4
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	ae2080e7          	jalr	-1310(ra) # 8000064e <mappages>
    80000b74:	8b2a                	mv	s6,a0
    80000b76:	ed15                	bnez	a0,80000bb2 <uvmcopy+0x9a>
      goto err;
    }
    inc_ref((void *)pa);
    80000b78:	854a                	mv	a0,s2
    80000b7a:	fffff097          	auipc	ra,0xfffff
    80000b7e:	4a2080e7          	jalr	1186(ra) # 8000001c <inc_ref>
  for(i = 0; i < sz; i += PGSIZE){
    80000b82:	6785                	lui	a5,0x1
    80000b84:	94be                	add	s1,s1,a5
    80000b86:	0534f063          	bgeu	s1,s3,80000bc6 <uvmcopy+0xae>
    if((pte = walk(old, i, 0)) == 0)
    80000b8a:	4601                	li	a2,0
    80000b8c:	85a6                	mv	a1,s1
    80000b8e:	8556                	mv	a0,s5
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	9d6080e7          	jalr	-1578(ra) # 80000566 <walk>
    80000b98:	d145                	beqz	a0,80000b38 <uvmcopy+0x20>
    if((*pte & PTE_V) == 0)
    80000b9a:	611c                	ld	a5,0(a0)
    80000b9c:	0017f713          	andi	a4,a5,1
    80000ba0:	d745                	beqz	a4,80000b48 <uvmcopy+0x30>
    if(*pte & PTE_W){
    80000ba2:	0047f713          	andi	a4,a5,4
    80000ba6:	db4d                	beqz	a4,80000b58 <uvmcopy+0x40>
      *pte &= ~PTE_W;
    80000ba8:	9bed                	andi	a5,a5,-5
      *pte |= PTE_COW;
    80000baa:	1007e793          	ori	a5,a5,256
    80000bae:	e11c                	sd	a5,0(a0)
    80000bb0:	b765                	j	80000b58 <uvmcopy+0x40>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bb2:	4685                	li	a3,1
    80000bb4:	00c4d613          	srli	a2,s1,0xc
    80000bb8:	4581                	li	a1,0
    80000bba:	8552                	mv	a0,s4
    80000bbc:	00000097          	auipc	ra,0x0
    80000bc0:	c58080e7          	jalr	-936(ra) # 80000814 <uvmunmap>
  return -1;
    80000bc4:	5b7d                	li	s6,-1
}
    80000bc6:	855a                	mv	a0,s6
    80000bc8:	70e2                	ld	ra,56(sp)
    80000bca:	7442                	ld	s0,48(sp)
    80000bcc:	74a2                	ld	s1,40(sp)
    80000bce:	7902                	ld	s2,32(sp)
    80000bd0:	69e2                	ld	s3,24(sp)
    80000bd2:	6a42                	ld	s4,16(sp)
    80000bd4:	6aa2                	ld	s5,8(sp)
    80000bd6:	6b02                	ld	s6,0(sp)
    80000bd8:	6121                	addi	sp,sp,64
    80000bda:	8082                	ret
  return 0;
    80000bdc:	4b01                	li	s6,0
    80000bde:	b7e5                	j	80000bc6 <uvmcopy+0xae>

0000000080000be0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000be0:	1141                	addi	sp,sp,-16
    80000be2:	e406                	sd	ra,8(sp)
    80000be4:	e022                	sd	s0,0(sp)
    80000be6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000be8:	4601                	li	a2,0
    80000bea:	00000097          	auipc	ra,0x0
    80000bee:	97c080e7          	jalr	-1668(ra) # 80000566 <walk>
  if(pte == 0)
    80000bf2:	c901                	beqz	a0,80000c02 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bf4:	611c                	ld	a5,0(a0)
    80000bf6:	9bbd                	andi	a5,a5,-17
    80000bf8:	e11c                	sd	a5,0(a0)
}
    80000bfa:	60a2                	ld	ra,8(sp)
    80000bfc:	6402                	ld	s0,0(sp)
    80000bfe:	0141                	addi	sp,sp,16
    80000c00:	8082                	ret
    panic("uvmclear");
    80000c02:	00007517          	auipc	a0,0x7
    80000c06:	55650513          	addi	a0,a0,1366 # 80008158 <etext+0x158>
    80000c0a:	00005097          	auipc	ra,0x5
    80000c0e:	1ac080e7          	jalr	428(ra) # 80005db6 <panic>

0000000080000c12 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c12:	caa5                	beqz	a3,80000c82 <copyin+0x70>
{
    80000c14:	715d                	addi	sp,sp,-80
    80000c16:	e486                	sd	ra,72(sp)
    80000c18:	e0a2                	sd	s0,64(sp)
    80000c1a:	fc26                	sd	s1,56(sp)
    80000c1c:	f84a                	sd	s2,48(sp)
    80000c1e:	f44e                	sd	s3,40(sp)
    80000c20:	f052                	sd	s4,32(sp)
    80000c22:	ec56                	sd	s5,24(sp)
    80000c24:	e85a                	sd	s6,16(sp)
    80000c26:	e45e                	sd	s7,8(sp)
    80000c28:	e062                	sd	s8,0(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8b2a                	mv	s6,a0
    80000c2e:	8a2e                	mv	s4,a1
    80000c30:	8c32                	mv	s8,a2
    80000c32:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c34:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c36:	6a85                	lui	s5,0x1
    80000c38:	a01d                	j	80000c5e <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c3a:	018505b3          	add	a1,a0,s8
    80000c3e:	0004861b          	sext.w	a2,s1
    80000c42:	412585b3          	sub	a1,a1,s2
    80000c46:	8552                	mv	a0,s4
    80000c48:	fffff097          	auipc	ra,0xfffff
    80000c4c:	698080e7          	jalr	1688(ra) # 800002e0 <memmove>

    len -= n;
    80000c50:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c54:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c56:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c5a:	02098263          	beqz	s3,80000c7e <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c62:	85ca                	mv	a1,s2
    80000c64:	855a                	mv	a0,s6
    80000c66:	00000097          	auipc	ra,0x0
    80000c6a:	9a6080e7          	jalr	-1626(ra) # 8000060c <walkaddr>
    if(pa0 == 0)
    80000c6e:	cd01                	beqz	a0,80000c86 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c70:	418904b3          	sub	s1,s2,s8
    80000c74:	94d6                	add	s1,s1,s5
    80000c76:	fc99f2e3          	bgeu	s3,s1,80000c3a <copyin+0x28>
    80000c7a:	84ce                	mv	s1,s3
    80000c7c:	bf7d                	j	80000c3a <copyin+0x28>
  }
  return 0;
    80000c7e:	4501                	li	a0,0
    80000c80:	a021                	j	80000c88 <copyin+0x76>
    80000c82:	4501                	li	a0,0
}
    80000c84:	8082                	ret
      return -1;
    80000c86:	557d                	li	a0,-1
}
    80000c88:	60a6                	ld	ra,72(sp)
    80000c8a:	6406                	ld	s0,64(sp)
    80000c8c:	74e2                	ld	s1,56(sp)
    80000c8e:	7942                	ld	s2,48(sp)
    80000c90:	79a2                	ld	s3,40(sp)
    80000c92:	7a02                	ld	s4,32(sp)
    80000c94:	6ae2                	ld	s5,24(sp)
    80000c96:	6b42                	ld	s6,16(sp)
    80000c98:	6ba2                	ld	s7,8(sp)
    80000c9a:	6c02                	ld	s8,0(sp)
    80000c9c:	6161                	addi	sp,sp,80
    80000c9e:	8082                	ret

0000000080000ca0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000ca0:	c2dd                	beqz	a3,80000d46 <copyinstr+0xa6>
{
    80000ca2:	715d                	addi	sp,sp,-80
    80000ca4:	e486                	sd	ra,72(sp)
    80000ca6:	e0a2                	sd	s0,64(sp)
    80000ca8:	fc26                	sd	s1,56(sp)
    80000caa:	f84a                	sd	s2,48(sp)
    80000cac:	f44e                	sd	s3,40(sp)
    80000cae:	f052                	sd	s4,32(sp)
    80000cb0:	ec56                	sd	s5,24(sp)
    80000cb2:	e85a                	sd	s6,16(sp)
    80000cb4:	e45e                	sd	s7,8(sp)
    80000cb6:	0880                	addi	s0,sp,80
    80000cb8:	8a2a                	mv	s4,a0
    80000cba:	8b2e                	mv	s6,a1
    80000cbc:	8bb2                	mv	s7,a2
    80000cbe:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cc0:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cc2:	6985                	lui	s3,0x1
    80000cc4:	a02d                	j	80000cee <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cc6:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cca:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ccc:	37fd                	addiw	a5,a5,-1
    80000cce:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cd2:	60a6                	ld	ra,72(sp)
    80000cd4:	6406                	ld	s0,64(sp)
    80000cd6:	74e2                	ld	s1,56(sp)
    80000cd8:	7942                	ld	s2,48(sp)
    80000cda:	79a2                	ld	s3,40(sp)
    80000cdc:	7a02                	ld	s4,32(sp)
    80000cde:	6ae2                	ld	s5,24(sp)
    80000ce0:	6b42                	ld	s6,16(sp)
    80000ce2:	6ba2                	ld	s7,8(sp)
    80000ce4:	6161                	addi	sp,sp,80
    80000ce6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ce8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cec:	c8a9                	beqz	s1,80000d3e <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cee:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cf2:	85ca                	mv	a1,s2
    80000cf4:	8552                	mv	a0,s4
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	916080e7          	jalr	-1770(ra) # 8000060c <walkaddr>
    if(pa0 == 0)
    80000cfe:	c131                	beqz	a0,80000d42 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d00:	417906b3          	sub	a3,s2,s7
    80000d04:	96ce                	add	a3,a3,s3
    80000d06:	00d4f363          	bgeu	s1,a3,80000d0c <copyinstr+0x6c>
    80000d0a:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d0c:	955e                	add	a0,a0,s7
    80000d0e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d12:	daf9                	beqz	a3,80000ce8 <copyinstr+0x48>
    80000d14:	87da                	mv	a5,s6
    80000d16:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d18:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d1c:	96da                	add	a3,a3,s6
    80000d1e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d20:	00f60733          	add	a4,a2,a5
    80000d24:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffbd200>
    80000d28:	df59                	beqz	a4,80000cc6 <copyinstr+0x26>
        *dst = *p;
    80000d2a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d2e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d30:	fed797e3          	bne	a5,a3,80000d1e <copyinstr+0x7e>
    80000d34:	14fd                	addi	s1,s1,-1
    80000d36:	94c2                	add	s1,s1,a6
      --max;
    80000d38:	8c8d                	sub	s1,s1,a1
      dst++;
    80000d3a:	8b3e                	mv	s6,a5
    80000d3c:	b775                	j	80000ce8 <copyinstr+0x48>
    80000d3e:	4781                	li	a5,0
    80000d40:	b771                	j	80000ccc <copyinstr+0x2c>
      return -1;
    80000d42:	557d                	li	a0,-1
    80000d44:	b779                	j	80000cd2 <copyinstr+0x32>
  int got_null = 0;
    80000d46:	4781                	li	a5,0
  if(got_null){
    80000d48:	37fd                	addiw	a5,a5,-1
    80000d4a:	0007851b          	sext.w	a0,a5
}
    80000d4e:	8082                	ret

0000000080000d50 <is_cow_fault>:

int
is_cow_fault(pagetable_t pagetable, uint64 va){
  if(va >= MAXVA){
    80000d50:	57fd                	li	a5,-1
    80000d52:	83e9                	srli	a5,a5,0x1a
    80000d54:	02b7e963          	bltu	a5,a1,80000d86 <is_cow_fault+0x36>
is_cow_fault(pagetable_t pagetable, uint64 va){
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
    goto is_cow_fault_error;
  }
  pte_t *pte;
  if((pte = walk(pagetable, PGROUNDDOWN(va), 0)) == 0)
    80000d60:	4601                	li	a2,0
    80000d62:	77fd                	lui	a5,0xfffff
    80000d64:	8dfd                	and	a1,a1,a5
    80000d66:	00000097          	auipc	ra,0x0
    80000d6a:	800080e7          	jalr	-2048(ra) # 80000566 <walk>
    80000d6e:	cd11                	beqz	a0,80000d8a <is_cow_fault+0x3a>
    goto is_cow_fault_error;
  // if(pte && (*pte & (PTE_V | PTE_U | PTE_COW))) /*TODO*/
    if(pte && (*pte & (PTE_COW))) /*TODO*/
    80000d70:	6108                	ld	a0,0(a0)
    80000d72:	8121                	srli	a0,a0,0x8
    80000d74:	00154513          	xori	a0,a0,1
    80000d78:	8905                	andi	a0,a0,1
    80000d7a:	40a00533          	neg	a0,a0
    return 0;
is_cow_fault_error:
  return -1;    
}
    80000d7e:	60a2                	ld	ra,8(sp)
    80000d80:	6402                	ld	s0,0(sp)
    80000d82:	0141                	addi	sp,sp,16
    80000d84:	8082                	ret
  return -1;    
    80000d86:	557d                	li	a0,-1
}
    80000d88:	8082                	ret
  return -1;    
    80000d8a:	557d                	li	a0,-1
    80000d8c:	bfcd                	j	80000d7e <is_cow_fault+0x2e>

0000000080000d8e <handle_cow_fault>:

// implement copy on write here
int
handle_cow_fault(pagetable_t pagetable, uint64 va){  
    80000d8e:	7139                	addi	sp,sp,-64
    80000d90:	fc06                	sd	ra,56(sp)
    80000d92:	f822                	sd	s0,48(sp)
    80000d94:	f426                	sd	s1,40(sp)
    80000d96:	f04a                	sd	s2,32(sp)
    80000d98:	ec4e                	sd	s3,24(sp)
    80000d9a:	e852                	sd	s4,16(sp)
    80000d9c:	e456                	sd	s5,8(sp)
    80000d9e:	0080                	addi	s0,sp,64
    80000da0:	8a2a                	mv	s4,a0
  pte_t *pte;
  uint64 pa, flags;
  char *mem;

  va = PGROUNDDOWN(va);
    80000da2:	77fd                	lui	a5,0xfffff
    80000da4:	00f5f933          	and	s2,a1,a5
  if((pte = walk(pagetable, va, 0)) == 0){
    80000da8:	4601                	li	a2,0
    80000daa:	85ca                	mv	a1,s2
    80000dac:	fffff097          	auipc	ra,0xfffff
    80000db0:	7ba080e7          	jalr	1978(ra) # 80000566 <walk>
    80000db4:	c12d                	beqz	a0,80000e16 <handle_cow_fault+0x88>
    printf("-----1-----\n");
    goto handle_cow_fault_error;

  }
  pa = PTE2PA(*pte);
    80000db6:	6118                	ld	a4,0(a0)
    80000db8:	00a75593          	srli	a1,a4,0xa
    80000dbc:	00c59a93          	slli	s5,a1,0xc
  flags = (PTE_FLAGS(*pte) & ~PTE_COW) | PTE_W;
    80000dc0:	2fb77713          	andi	a4,a4,763
    80000dc4:	00476493          	ori	s1,a4,4
  mem = (char *)kalloc();
    80000dc8:	fffff097          	auipc	ra,0xfffff
    80000dcc:	43a080e7          	jalr	1082(ra) # 80000202 <kalloc>
    80000dd0:	89aa                	mv	s3,a0
  if(!mem){
    80000dd2:	cd21                	beqz	a0,80000e2a <handle_cow_fault+0x9c>
    printf("-----2-----\n");
    goto handle_cow_fault_error;  
  }
  memmove(mem, (char *)pa, PGSIZE);
    80000dd4:	6605                	lui	a2,0x1
    80000dd6:	85d6                	mv	a1,s5
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	508080e7          	jalr	1288(ra) # 800002e0 <memmove>
  uvmunmap(pagetable, va, 1, 1);  /* why 1? */
    80000de0:	4685                	li	a3,1
    80000de2:	4605                	li	a2,1
    80000de4:	85ca                	mv	a1,s2
    80000de6:	8552                	mv	a0,s4
    80000de8:	00000097          	auipc	ra,0x0
    80000dec:	a2c080e7          	jalr	-1492(ra) # 80000814 <uvmunmap>
  if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags) != 0){
    80000df0:	8726                	mv	a4,s1
    80000df2:	86ce                	mv	a3,s3
    80000df4:	6605                	lui	a2,0x1
    80000df6:	85ca                	mv	a1,s2
    80000df8:	8552                	mv	a0,s4
    80000dfa:	00000097          	auipc	ra,0x0
    80000dfe:	854080e7          	jalr	-1964(ra) # 8000064e <mappages>
    80000e02:	ed15                	bnez	a0,80000e3e <handle_cow_fault+0xb0>
    goto handle_cow_fault_error;
  }
  return 0;
handle_cow_fault_error:
  return -1;  /* error */
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6121                	addi	sp,sp,64
    80000e14:	8082                	ret
    printf("-----1-----\n");
    80000e16:	00007517          	auipc	a0,0x7
    80000e1a:	35250513          	addi	a0,a0,850 # 80008168 <etext+0x168>
    80000e1e:	00005097          	auipc	ra,0x5
    80000e22:	fe2080e7          	jalr	-30(ra) # 80005e00 <printf>
  return -1;  /* error */
    80000e26:	557d                	li	a0,-1
    goto handle_cow_fault_error;
    80000e28:	bff1                	j	80000e04 <handle_cow_fault+0x76>
    printf("-----2-----\n");
    80000e2a:	00007517          	auipc	a0,0x7
    80000e2e:	34e50513          	addi	a0,a0,846 # 80008178 <etext+0x178>
    80000e32:	00005097          	auipc	ra,0x5
    80000e36:	fce080e7          	jalr	-50(ra) # 80005e00 <printf>
  return -1;  /* error */
    80000e3a:	557d                	li	a0,-1
    goto handle_cow_fault_error;  
    80000e3c:	b7e1                	j	80000e04 <handle_cow_fault+0x76>
    kfree(mem);
    80000e3e:	854e                	mv	a0,s3
    80000e40:	fffff097          	auipc	ra,0xfffff
    80000e44:	27c080e7          	jalr	636(ra) # 800000bc <kfree>
    printf("-----3-----\n");
    80000e48:	00007517          	auipc	a0,0x7
    80000e4c:	34050513          	addi	a0,a0,832 # 80008188 <etext+0x188>
    80000e50:	00005097          	auipc	ra,0x5
    80000e54:	fb0080e7          	jalr	-80(ra) # 80005e00 <printf>
  return -1;  /* error */
    80000e58:	557d                	li	a0,-1
    goto handle_cow_fault_error;
    80000e5a:	b76d                	j	80000e04 <handle_cow_fault+0x76>

0000000080000e5c <copyout>:
  while(len > 0){
    80000e5c:	c2c5                	beqz	a3,80000efc <copyout+0xa0>
{
    80000e5e:	715d                	addi	sp,sp,-80
    80000e60:	e486                	sd	ra,72(sp)
    80000e62:	e0a2                	sd	s0,64(sp)
    80000e64:	fc26                	sd	s1,56(sp)
    80000e66:	f84a                	sd	s2,48(sp)
    80000e68:	f44e                	sd	s3,40(sp)
    80000e6a:	f052                	sd	s4,32(sp)
    80000e6c:	ec56                	sd	s5,24(sp)
    80000e6e:	e85a                	sd	s6,16(sp)
    80000e70:	e45e                	sd	s7,8(sp)
    80000e72:	e062                	sd	s8,0(sp)
    80000e74:	0880                	addi	s0,sp,80
    80000e76:	8b2a                	mv	s6,a0
    80000e78:	84ae                	mv	s1,a1
    80000e7a:	8ab2                	mv	s5,a2
    80000e7c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000e7e:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80000e80:	6b85                	lui	s7,0x1
    80000e82:	a825                	j	80000eba <copyout+0x5e>
        printf("copyout(): copy and write failed!\n");
    80000e84:	00007517          	auipc	a0,0x7
    80000e88:	31450513          	addi	a0,a0,788 # 80008198 <etext+0x198>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	f74080e7          	jalr	-140(ra) # 80005e00 <printf>
        return -1;
    80000e94:	557d                	li	a0,-1
    80000e96:	a0b5                	j	80000f02 <copyout+0xa6>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000e98:	413484b3          	sub	s1,s1,s3
    80000e9c:	0009061b          	sext.w	a2,s2
    80000ea0:	85d6                	mv	a1,s5
    80000ea2:	9526                	add	a0,a0,s1
    80000ea4:	fffff097          	auipc	ra,0xfffff
    80000ea8:	43c080e7          	jalr	1084(ra) # 800002e0 <memmove>
    len -= n;
    80000eac:	412a0a33          	sub	s4,s4,s2
    src += n;
    80000eb0:	9aca                	add	s5,s5,s2
    dstva = va0 + PGSIZE;
    80000eb2:	017984b3          	add	s1,s3,s7
  while(len > 0){
    80000eb6:	040a0163          	beqz	s4,80000ef8 <copyout+0x9c>
    va0 = PGROUNDDOWN(dstva);
    80000eba:	0184f9b3          	and	s3,s1,s8
    if(is_cow_fault(pagetable, dstva) == 0){  /* 思考:为什么这里设置成 != 0 filetest就会报错 */
    80000ebe:	85a6                	mv	a1,s1
    80000ec0:	855a                	mv	a0,s6
    80000ec2:	00000097          	auipc	ra,0x0
    80000ec6:	e8e080e7          	jalr	-370(ra) # 80000d50 <is_cow_fault>
    80000eca:	e909                	bnez	a0,80000edc <copyout+0x80>
      if(handle_cow_fault(pagetable, dstva) < 0){
    80000ecc:	85a6                	mv	a1,s1
    80000ece:	855a                	mv	a0,s6
    80000ed0:	00000097          	auipc	ra,0x0
    80000ed4:	ebe080e7          	jalr	-322(ra) # 80000d8e <handle_cow_fault>
    80000ed8:	fa0546e3          	bltz	a0,80000e84 <copyout+0x28>
    pa0 = walkaddr(pagetable, va0);
    80000edc:	85ce                	mv	a1,s3
    80000ede:	855a                	mv	a0,s6
    80000ee0:	fffff097          	auipc	ra,0xfffff
    80000ee4:	72c080e7          	jalr	1836(ra) # 8000060c <walkaddr>
    if(pa0 == 0)
    80000ee8:	cd01                	beqz	a0,80000f00 <copyout+0xa4>
    n = PGSIZE - (dstva - va0);
    80000eea:	40998933          	sub	s2,s3,s1
    80000eee:	995e                	add	s2,s2,s7
    80000ef0:	fb2a74e3          	bgeu	s4,s2,80000e98 <copyout+0x3c>
    80000ef4:	8952                	mv	s2,s4
    80000ef6:	b74d                	j	80000e98 <copyout+0x3c>
  return 0;
    80000ef8:	4501                	li	a0,0
    80000efa:	a021                	j	80000f02 <copyout+0xa6>
    80000efc:	4501                	li	a0,0
}
    80000efe:	8082                	ret
      return -1;
    80000f00:	557d                	li	a0,-1
}
    80000f02:	60a6                	ld	ra,72(sp)
    80000f04:	6406                	ld	s0,64(sp)
    80000f06:	74e2                	ld	s1,56(sp)
    80000f08:	7942                	ld	s2,48(sp)
    80000f0a:	79a2                	ld	s3,40(sp)
    80000f0c:	7a02                	ld	s4,32(sp)
    80000f0e:	6ae2                	ld	s5,24(sp)
    80000f10:	6b42                	ld	s6,16(sp)
    80000f12:	6ba2                	ld	s7,8(sp)
    80000f14:	6c02                	ld	s8,0(sp)
    80000f16:	6161                	addi	sp,sp,80
    80000f18:	8082                	ret

0000000080000f1a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000f1a:	7139                	addi	sp,sp,-64
    80000f1c:	fc06                	sd	ra,56(sp)
    80000f1e:	f822                	sd	s0,48(sp)
    80000f20:	f426                	sd	s1,40(sp)
    80000f22:	f04a                	sd	s2,32(sp)
    80000f24:	ec4e                	sd	s3,24(sp)
    80000f26:	e852                	sd	s4,16(sp)
    80000f28:	e456                	sd	s5,8(sp)
    80000f2a:	e05a                	sd	s6,0(sp)
    80000f2c:	0080                	addi	s0,sp,64
    80000f2e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f30:	00028497          	auipc	s1,0x28
    80000f34:	ea848493          	addi	s1,s1,-344 # 80028dd8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f38:	8b26                	mv	s6,s1
    80000f3a:	00007a97          	auipc	s5,0x7
    80000f3e:	0c6a8a93          	addi	s5,s5,198 # 80008000 <etext>
    80000f42:	04000937          	lui	s2,0x4000
    80000f46:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f48:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4a:	0002ea17          	auipc	s4,0x2e
    80000f4e:	88ea0a13          	addi	s4,s4,-1906 # 8002e7d8 <tickslock>
    char *pa = kalloc();
    80000f52:	fffff097          	auipc	ra,0xfffff
    80000f56:	2b0080e7          	jalr	688(ra) # 80000202 <kalloc>
    80000f5a:	862a                	mv	a2,a0
    if(pa == 0)
    80000f5c:	c131                	beqz	a0,80000fa0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f5e:	416485b3          	sub	a1,s1,s6
    80000f62:	858d                	srai	a1,a1,0x3
    80000f64:	000ab783          	ld	a5,0(s5)
    80000f68:	02f585b3          	mul	a1,a1,a5
    80000f6c:	2585                	addiw	a1,a1,1
    80000f6e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f72:	4719                	li	a4,6
    80000f74:	6685                	lui	a3,0x1
    80000f76:	40b905b3          	sub	a1,s2,a1
    80000f7a:	854e                	mv	a0,s3
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	772080e7          	jalr	1906(ra) # 800006ee <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f84:	16848493          	addi	s1,s1,360
    80000f88:	fd4495e3          	bne	s1,s4,80000f52 <proc_mapstacks+0x38>
  }
}
    80000f8c:	70e2                	ld	ra,56(sp)
    80000f8e:	7442                	ld	s0,48(sp)
    80000f90:	74a2                	ld	s1,40(sp)
    80000f92:	7902                	ld	s2,32(sp)
    80000f94:	69e2                	ld	s3,24(sp)
    80000f96:	6a42                	ld	s4,16(sp)
    80000f98:	6aa2                	ld	s5,8(sp)
    80000f9a:	6b02                	ld	s6,0(sp)
    80000f9c:	6121                	addi	sp,sp,64
    80000f9e:	8082                	ret
      panic("kalloc");
    80000fa0:	00007517          	auipc	a0,0x7
    80000fa4:	22050513          	addi	a0,a0,544 # 800081c0 <etext+0x1c0>
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	e0e080e7          	jalr	-498(ra) # 80005db6 <panic>

0000000080000fb0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000fb0:	7139                	addi	sp,sp,-64
    80000fb2:	fc06                	sd	ra,56(sp)
    80000fb4:	f822                	sd	s0,48(sp)
    80000fb6:	f426                	sd	s1,40(sp)
    80000fb8:	f04a                	sd	s2,32(sp)
    80000fba:	ec4e                	sd	s3,24(sp)
    80000fbc:	e852                	sd	s4,16(sp)
    80000fbe:	e456                	sd	s5,8(sp)
    80000fc0:	e05a                	sd	s6,0(sp)
    80000fc2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fc4:	00007597          	auipc	a1,0x7
    80000fc8:	20458593          	addi	a1,a1,516 # 800081c8 <etext+0x1c8>
    80000fcc:	00028517          	auipc	a0,0x28
    80000fd0:	9dc50513          	addi	a0,a0,-1572 # 800289a8 <pid_lock>
    80000fd4:	00005097          	auipc	ra,0x5
    80000fd8:	28a080e7          	jalr	650(ra) # 8000625e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fdc:	00007597          	auipc	a1,0x7
    80000fe0:	1f458593          	addi	a1,a1,500 # 800081d0 <etext+0x1d0>
    80000fe4:	00028517          	auipc	a0,0x28
    80000fe8:	9dc50513          	addi	a0,a0,-1572 # 800289c0 <wait_lock>
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	272080e7          	jalr	626(ra) # 8000625e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff4:	00028497          	auipc	s1,0x28
    80000ff8:	de448493          	addi	s1,s1,-540 # 80028dd8 <proc>
      initlock(&p->lock, "proc");
    80000ffc:	00007b17          	auipc	s6,0x7
    80001000:	1e4b0b13          	addi	s6,s6,484 # 800081e0 <etext+0x1e0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001004:	8aa6                	mv	s5,s1
    80001006:	00007a17          	auipc	s4,0x7
    8000100a:	ffaa0a13          	addi	s4,s4,-6 # 80008000 <etext>
    8000100e:	04000937          	lui	s2,0x4000
    80001012:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001014:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001016:	0002d997          	auipc	s3,0x2d
    8000101a:	7c298993          	addi	s3,s3,1986 # 8002e7d8 <tickslock>
      initlock(&p->lock, "proc");
    8000101e:	85da                	mv	a1,s6
    80001020:	8526                	mv	a0,s1
    80001022:	00005097          	auipc	ra,0x5
    80001026:	23c080e7          	jalr	572(ra) # 8000625e <initlock>
      p->state = UNUSED;
    8000102a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000102e:	415487b3          	sub	a5,s1,s5
    80001032:	878d                	srai	a5,a5,0x3
    80001034:	000a3703          	ld	a4,0(s4)
    80001038:	02e787b3          	mul	a5,a5,a4
    8000103c:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffbd201>
    8000103e:	00d7979b          	slliw	a5,a5,0xd
    80001042:	40f907b3          	sub	a5,s2,a5
    80001046:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001048:	16848493          	addi	s1,s1,360
    8000104c:	fd3499e3          	bne	s1,s3,8000101e <procinit+0x6e>
  }
}
    80001050:	70e2                	ld	ra,56(sp)
    80001052:	7442                	ld	s0,48(sp)
    80001054:	74a2                	ld	s1,40(sp)
    80001056:	7902                	ld	s2,32(sp)
    80001058:	69e2                	ld	s3,24(sp)
    8000105a:	6a42                	ld	s4,16(sp)
    8000105c:	6aa2                	ld	s5,8(sp)
    8000105e:	6b02                	ld	s6,0(sp)
    80001060:	6121                	addi	sp,sp,64
    80001062:	8082                	ret

0000000080001064 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001064:	1141                	addi	sp,sp,-16
    80001066:	e422                	sd	s0,8(sp)
    80001068:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000106a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000106c:	2501                	sext.w	a0,a0
    8000106e:	6422                	ld	s0,8(sp)
    80001070:	0141                	addi	sp,sp,16
    80001072:	8082                	ret

0000000080001074 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001074:	1141                	addi	sp,sp,-16
    80001076:	e422                	sd	s0,8(sp)
    80001078:	0800                	addi	s0,sp,16
    8000107a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000107c:	2781                	sext.w	a5,a5
    8000107e:	079e                	slli	a5,a5,0x7
  return c;
}
    80001080:	00028517          	auipc	a0,0x28
    80001084:	95850513          	addi	a0,a0,-1704 # 800289d8 <cpus>
    80001088:	953e                	add	a0,a0,a5
    8000108a:	6422                	ld	s0,8(sp)
    8000108c:	0141                	addi	sp,sp,16
    8000108e:	8082                	ret

0000000080001090 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001090:	1101                	addi	sp,sp,-32
    80001092:	ec06                	sd	ra,24(sp)
    80001094:	e822                	sd	s0,16(sp)
    80001096:	e426                	sd	s1,8(sp)
    80001098:	1000                	addi	s0,sp,32
  push_off();
    8000109a:	00005097          	auipc	ra,0x5
    8000109e:	208080e7          	jalr	520(ra) # 800062a2 <push_off>
    800010a2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010a4:	2781                	sext.w	a5,a5
    800010a6:	079e                	slli	a5,a5,0x7
    800010a8:	00028717          	auipc	a4,0x28
    800010ac:	90070713          	addi	a4,a4,-1792 # 800289a8 <pid_lock>
    800010b0:	97ba                	add	a5,a5,a4
    800010b2:	7b84                	ld	s1,48(a5)
  pop_off();
    800010b4:	00005097          	auipc	ra,0x5
    800010b8:	28e080e7          	jalr	654(ra) # 80006342 <pop_off>
  return p;
}
    800010bc:	8526                	mv	a0,s1
    800010be:	60e2                	ld	ra,24(sp)
    800010c0:	6442                	ld	s0,16(sp)
    800010c2:	64a2                	ld	s1,8(sp)
    800010c4:	6105                	addi	sp,sp,32
    800010c6:	8082                	ret

00000000800010c8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e406                	sd	ra,8(sp)
    800010cc:	e022                	sd	s0,0(sp)
    800010ce:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010d0:	00000097          	auipc	ra,0x0
    800010d4:	fc0080e7          	jalr	-64(ra) # 80001090 <myproc>
    800010d8:	00005097          	auipc	ra,0x5
    800010dc:	2ca080e7          	jalr	714(ra) # 800063a2 <release>

  if (first) {
    800010e0:	00007797          	auipc	a5,0x7
    800010e4:	7f07a783          	lw	a5,2032(a5) # 800088d0 <first.1>
    800010e8:	eb89                	bnez	a5,800010fa <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010ea:	00001097          	auipc	ra,0x1
    800010ee:	c5c080e7          	jalr	-932(ra) # 80001d46 <usertrapret>
}
    800010f2:	60a2                	ld	ra,8(sp)
    800010f4:	6402                	ld	s0,0(sp)
    800010f6:	0141                	addi	sp,sp,16
    800010f8:	8082                	ret
    first = 0;
    800010fa:	00007797          	auipc	a5,0x7
    800010fe:	7c07ab23          	sw	zero,2006(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80001102:	4505                	li	a0,1
    80001104:	00002097          	auipc	ra,0x2
    80001108:	9e0080e7          	jalr	-1568(ra) # 80002ae4 <fsinit>
    8000110c:	bff9                	j	800010ea <forkret+0x22>

000000008000110e <allocpid>:
{
    8000110e:	1101                	addi	sp,sp,-32
    80001110:	ec06                	sd	ra,24(sp)
    80001112:	e822                	sd	s0,16(sp)
    80001114:	e426                	sd	s1,8(sp)
    80001116:	e04a                	sd	s2,0(sp)
    80001118:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000111a:	00028917          	auipc	s2,0x28
    8000111e:	88e90913          	addi	s2,s2,-1906 # 800289a8 <pid_lock>
    80001122:	854a                	mv	a0,s2
    80001124:	00005097          	auipc	ra,0x5
    80001128:	1ca080e7          	jalr	458(ra) # 800062ee <acquire>
  pid = nextpid;
    8000112c:	00007797          	auipc	a5,0x7
    80001130:	7a878793          	addi	a5,a5,1960 # 800088d4 <nextpid>
    80001134:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001136:	0014871b          	addiw	a4,s1,1
    8000113a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000113c:	854a                	mv	a0,s2
    8000113e:	00005097          	auipc	ra,0x5
    80001142:	264080e7          	jalr	612(ra) # 800063a2 <release>
}
    80001146:	8526                	mv	a0,s1
    80001148:	60e2                	ld	ra,24(sp)
    8000114a:	6442                	ld	s0,16(sp)
    8000114c:	64a2                	ld	s1,8(sp)
    8000114e:	6902                	ld	s2,0(sp)
    80001150:	6105                	addi	sp,sp,32
    80001152:	8082                	ret

0000000080001154 <proc_pagetable>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	e04a                	sd	s2,0(sp)
    8000115e:	1000                	addi	s0,sp,32
    80001160:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	776080e7          	jalr	1910(ra) # 800008d8 <uvmcreate>
    8000116a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000116c:	c121                	beqz	a0,800011ac <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000116e:	4729                	li	a4,10
    80001170:	00006697          	auipc	a3,0x6
    80001174:	e9068693          	addi	a3,a3,-368 # 80007000 <_trampoline>
    80001178:	6605                	lui	a2,0x1
    8000117a:	040005b7          	lui	a1,0x4000
    8000117e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001180:	05b2                	slli	a1,a1,0xc
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	4cc080e7          	jalr	1228(ra) # 8000064e <mappages>
    8000118a:	02054863          	bltz	a0,800011ba <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000118e:	4719                	li	a4,6
    80001190:	05893683          	ld	a3,88(s2)
    80001194:	6605                	lui	a2,0x1
    80001196:	020005b7          	lui	a1,0x2000
    8000119a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000119c:	05b6                	slli	a1,a1,0xd
    8000119e:	8526                	mv	a0,s1
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	4ae080e7          	jalr	1198(ra) # 8000064e <mappages>
    800011a8:	02054163          	bltz	a0,800011ca <proc_pagetable+0x76>
}
    800011ac:	8526                	mv	a0,s1
    800011ae:	60e2                	ld	ra,24(sp)
    800011b0:	6442                	ld	s0,16(sp)
    800011b2:	64a2                	ld	s1,8(sp)
    800011b4:	6902                	ld	s2,0(sp)
    800011b6:	6105                	addi	sp,sp,32
    800011b8:	8082                	ret
    uvmfree(pagetable, 0);
    800011ba:	4581                	li	a1,0
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	920080e7          	jalr	-1760(ra) # 80000ade <uvmfree>
    return 0;
    800011c6:	4481                	li	s1,0
    800011c8:	b7d5                	j	800011ac <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ca:	4681                	li	a3,0
    800011cc:	4605                	li	a2,1
    800011ce:	040005b7          	lui	a1,0x4000
    800011d2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d4:	05b2                	slli	a1,a1,0xc
    800011d6:	8526                	mv	a0,s1
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	63c080e7          	jalr	1596(ra) # 80000814 <uvmunmap>
    uvmfree(pagetable, 0);
    800011e0:	4581                	li	a1,0
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	8fa080e7          	jalr	-1798(ra) # 80000ade <uvmfree>
    return 0;
    800011ec:	4481                	li	s1,0
    800011ee:	bf7d                	j	800011ac <proc_pagetable+0x58>

00000000800011f0 <proc_freepagetable>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
    800011fc:	84aa                	mv	s1,a0
    800011fe:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001200:	4681                	li	a3,0
    80001202:	4605                	li	a2,1
    80001204:	040005b7          	lui	a1,0x4000
    80001208:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000120a:	05b2                	slli	a1,a1,0xc
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	608080e7          	jalr	1544(ra) # 80000814 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001214:	4681                	li	a3,0
    80001216:	4605                	li	a2,1
    80001218:	020005b7          	lui	a1,0x2000
    8000121c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000121e:	05b6                	slli	a1,a1,0xd
    80001220:	8526                	mv	a0,s1
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	5f2080e7          	jalr	1522(ra) # 80000814 <uvmunmap>
  uvmfree(pagetable, sz);
    8000122a:	85ca                	mv	a1,s2
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	8b0080e7          	jalr	-1872(ra) # 80000ade <uvmfree>
}
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret

0000000080001242 <freeproc>:
{
    80001242:	1101                	addi	sp,sp,-32
    80001244:	ec06                	sd	ra,24(sp)
    80001246:	e822                	sd	s0,16(sp)
    80001248:	e426                	sd	s1,8(sp)
    8000124a:	1000                	addi	s0,sp,32
    8000124c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000124e:	6d28                	ld	a0,88(a0)
    80001250:	c509                	beqz	a0,8000125a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	e6a080e7          	jalr	-406(ra) # 800000bc <kfree>
  p->trapframe = 0;
    8000125a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000125e:	68a8                	ld	a0,80(s1)
    80001260:	c511                	beqz	a0,8000126c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001262:	64ac                	ld	a1,72(s1)
    80001264:	00000097          	auipc	ra,0x0
    80001268:	f8c080e7          	jalr	-116(ra) # 800011f0 <proc_freepagetable>
  p->pagetable = 0;
    8000126c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001270:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001274:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001278:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000127c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001280:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001284:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001288:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000128c:	0004ac23          	sw	zero,24(s1)
}
    80001290:	60e2                	ld	ra,24(sp)
    80001292:	6442                	ld	s0,16(sp)
    80001294:	64a2                	ld	s1,8(sp)
    80001296:	6105                	addi	sp,sp,32
    80001298:	8082                	ret

000000008000129a <allocproc>:
{
    8000129a:	1101                	addi	sp,sp,-32
    8000129c:	ec06                	sd	ra,24(sp)
    8000129e:	e822                	sd	s0,16(sp)
    800012a0:	e426                	sd	s1,8(sp)
    800012a2:	e04a                	sd	s2,0(sp)
    800012a4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012a6:	00028497          	auipc	s1,0x28
    800012aa:	b3248493          	addi	s1,s1,-1230 # 80028dd8 <proc>
    800012ae:	0002d917          	auipc	s2,0x2d
    800012b2:	52a90913          	addi	s2,s2,1322 # 8002e7d8 <tickslock>
    acquire(&p->lock);
    800012b6:	8526                	mv	a0,s1
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	036080e7          	jalr	54(ra) # 800062ee <acquire>
    if(p->state == UNUSED) {
    800012c0:	4c9c                	lw	a5,24(s1)
    800012c2:	cf81                	beqz	a5,800012da <allocproc+0x40>
      release(&p->lock);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	0dc080e7          	jalr	220(ra) # 800063a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012ce:	16848493          	addi	s1,s1,360
    800012d2:	ff2492e3          	bne	s1,s2,800012b6 <allocproc+0x1c>
  return 0;
    800012d6:	4481                	li	s1,0
    800012d8:	a889                	j	8000132a <allocproc+0x90>
  p->pid = allocpid();
    800012da:	00000097          	auipc	ra,0x0
    800012de:	e34080e7          	jalr	-460(ra) # 8000110e <allocpid>
    800012e2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012e4:	4785                	li	a5,1
    800012e6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	f1a080e7          	jalr	-230(ra) # 80000202 <kalloc>
    800012f0:	892a                	mv	s2,a0
    800012f2:	eca8                	sd	a0,88(s1)
    800012f4:	c131                	beqz	a0,80001338 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012f6:	8526                	mv	a0,s1
    800012f8:	00000097          	auipc	ra,0x0
    800012fc:	e5c080e7          	jalr	-420(ra) # 80001154 <proc_pagetable>
    80001300:	892a                	mv	s2,a0
    80001302:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001304:	c531                	beqz	a0,80001350 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001306:	07000613          	li	a2,112
    8000130a:	4581                	li	a1,0
    8000130c:	06048513          	addi	a0,s1,96
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	f74080e7          	jalr	-140(ra) # 80000284 <memset>
  p->context.ra = (uint64)forkret;
    80001318:	00000797          	auipc	a5,0x0
    8000131c:	db078793          	addi	a5,a5,-592 # 800010c8 <forkret>
    80001320:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001322:	60bc                	ld	a5,64(s1)
    80001324:	6705                	lui	a4,0x1
    80001326:	97ba                	add	a5,a5,a4
    80001328:	f4bc                	sd	a5,104(s1)
}
    8000132a:	8526                	mv	a0,s1
    8000132c:	60e2                	ld	ra,24(sp)
    8000132e:	6442                	ld	s0,16(sp)
    80001330:	64a2                	ld	s1,8(sp)
    80001332:	6902                	ld	s2,0(sp)
    80001334:	6105                	addi	sp,sp,32
    80001336:	8082                	ret
    freeproc(p);
    80001338:	8526                	mv	a0,s1
    8000133a:	00000097          	auipc	ra,0x0
    8000133e:	f08080e7          	jalr	-248(ra) # 80001242 <freeproc>
    release(&p->lock);
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	05e080e7          	jalr	94(ra) # 800063a2 <release>
    return 0;
    8000134c:	84ca                	mv	s1,s2
    8000134e:	bff1                	j	8000132a <allocproc+0x90>
    freeproc(p);
    80001350:	8526                	mv	a0,s1
    80001352:	00000097          	auipc	ra,0x0
    80001356:	ef0080e7          	jalr	-272(ra) # 80001242 <freeproc>
    release(&p->lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	046080e7          	jalr	70(ra) # 800063a2 <release>
    return 0;
    80001364:	84ca                	mv	s1,s2
    80001366:	b7d1                	j	8000132a <allocproc+0x90>

0000000080001368 <userinit>:
{
    80001368:	1101                	addi	sp,sp,-32
    8000136a:	ec06                	sd	ra,24(sp)
    8000136c:	e822                	sd	s0,16(sp)
    8000136e:	e426                	sd	s1,8(sp)
    80001370:	1000                	addi	s0,sp,32
  p = allocproc();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	f28080e7          	jalr	-216(ra) # 8000129a <allocproc>
    8000137a:	84aa                	mv	s1,a0
  initproc = p;
    8000137c:	00007797          	auipc	a5,0x7
    80001380:	5ca7ba23          	sd	a0,1492(a5) # 80008950 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001384:	03400613          	li	a2,52
    80001388:	00007597          	auipc	a1,0x7
    8000138c:	55858593          	addi	a1,a1,1368 # 800088e0 <initcode>
    80001390:	6928                	ld	a0,80(a0)
    80001392:	fffff097          	auipc	ra,0xfffff
    80001396:	574080e7          	jalr	1396(ra) # 80000906 <uvmfirst>
  p->sz = PGSIZE;
    8000139a:	6785                	lui	a5,0x1
    8000139c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000139e:	6cb8                	ld	a4,88(s1)
    800013a0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013a4:	6cb8                	ld	a4,88(s1)
    800013a6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013a8:	4641                	li	a2,16
    800013aa:	00007597          	auipc	a1,0x7
    800013ae:	e3e58593          	addi	a1,a1,-450 # 800081e8 <etext+0x1e8>
    800013b2:	15848513          	addi	a0,s1,344
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	016080e7          	jalr	22(ra) # 800003cc <safestrcpy>
  p->cwd = namei("/");
    800013be:	00007517          	auipc	a0,0x7
    800013c2:	e3a50513          	addi	a0,a0,-454 # 800081f8 <etext+0x1f8>
    800013c6:	00002097          	auipc	ra,0x2
    800013ca:	13c080e7          	jalr	316(ra) # 80003502 <namei>
    800013ce:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013d2:	478d                	li	a5,3
    800013d4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013d6:	8526                	mv	a0,s1
    800013d8:	00005097          	auipc	ra,0x5
    800013dc:	fca080e7          	jalr	-54(ra) # 800063a2 <release>
}
    800013e0:	60e2                	ld	ra,24(sp)
    800013e2:	6442                	ld	s0,16(sp)
    800013e4:	64a2                	ld	s1,8(sp)
    800013e6:	6105                	addi	sp,sp,32
    800013e8:	8082                	ret

00000000800013ea <growproc>:
{
    800013ea:	1101                	addi	sp,sp,-32
    800013ec:	ec06                	sd	ra,24(sp)
    800013ee:	e822                	sd	s0,16(sp)
    800013f0:	e426                	sd	s1,8(sp)
    800013f2:	e04a                	sd	s2,0(sp)
    800013f4:	1000                	addi	s0,sp,32
    800013f6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	c98080e7          	jalr	-872(ra) # 80001090 <myproc>
    80001400:	84aa                	mv	s1,a0
  sz = p->sz;
    80001402:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001404:	01204c63          	bgtz	s2,8000141c <growproc+0x32>
  } else if(n < 0){
    80001408:	02094663          	bltz	s2,80001434 <growproc+0x4a>
  p->sz = sz;
    8000140c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000140e:	4501                	li	a0,0
}
    80001410:	60e2                	ld	ra,24(sp)
    80001412:	6442                	ld	s0,16(sp)
    80001414:	64a2                	ld	s1,8(sp)
    80001416:	6902                	ld	s2,0(sp)
    80001418:	6105                	addi	sp,sp,32
    8000141a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000141c:	4691                	li	a3,4
    8000141e:	00b90633          	add	a2,s2,a1
    80001422:	6928                	ld	a0,80(a0)
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	59c080e7          	jalr	1436(ra) # 800009c0 <uvmalloc>
    8000142c:	85aa                	mv	a1,a0
    8000142e:	fd79                	bnez	a0,8000140c <growproc+0x22>
      return -1;
    80001430:	557d                	li	a0,-1
    80001432:	bff9                	j	80001410 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001434:	00b90633          	add	a2,s2,a1
    80001438:	6928                	ld	a0,80(a0)
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	53e080e7          	jalr	1342(ra) # 80000978 <uvmdealloc>
    80001442:	85aa                	mv	a1,a0
    80001444:	b7e1                	j	8000140c <growproc+0x22>

0000000080001446 <fork>:
{
    80001446:	7139                	addi	sp,sp,-64
    80001448:	fc06                	sd	ra,56(sp)
    8000144a:	f822                	sd	s0,48(sp)
    8000144c:	f426                	sd	s1,40(sp)
    8000144e:	f04a                	sd	s2,32(sp)
    80001450:	ec4e                	sd	s3,24(sp)
    80001452:	e852                	sd	s4,16(sp)
    80001454:	e456                	sd	s5,8(sp)
    80001456:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	c38080e7          	jalr	-968(ra) # 80001090 <myproc>
    80001460:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001462:	00000097          	auipc	ra,0x0
    80001466:	e38080e7          	jalr	-456(ra) # 8000129a <allocproc>
    8000146a:	10050c63          	beqz	a0,80001582 <fork+0x13c>
    8000146e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001470:	048ab603          	ld	a2,72(s5)
    80001474:	692c                	ld	a1,80(a0)
    80001476:	050ab503          	ld	a0,80(s5)
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	69e080e7          	jalr	1694(ra) # 80000b18 <uvmcopy>
    80001482:	04054863          	bltz	a0,800014d2 <fork+0x8c>
  np->sz = p->sz;
    80001486:	048ab783          	ld	a5,72(s5)
    8000148a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000148e:	058ab683          	ld	a3,88(s5)
    80001492:	87b6                	mv	a5,a3
    80001494:	058a3703          	ld	a4,88(s4)
    80001498:	12068693          	addi	a3,a3,288
    8000149c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014a0:	6788                	ld	a0,8(a5)
    800014a2:	6b8c                	ld	a1,16(a5)
    800014a4:	6f90                	ld	a2,24(a5)
    800014a6:	01073023          	sd	a6,0(a4)
    800014aa:	e708                	sd	a0,8(a4)
    800014ac:	eb0c                	sd	a1,16(a4)
    800014ae:	ef10                	sd	a2,24(a4)
    800014b0:	02078793          	addi	a5,a5,32
    800014b4:	02070713          	addi	a4,a4,32
    800014b8:	fed792e3          	bne	a5,a3,8000149c <fork+0x56>
  np->trapframe->a0 = 0;
    800014bc:	058a3783          	ld	a5,88(s4)
    800014c0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014c4:	0d0a8493          	addi	s1,s5,208
    800014c8:	0d0a0913          	addi	s2,s4,208
    800014cc:	150a8993          	addi	s3,s5,336
    800014d0:	a00d                	j	800014f2 <fork+0xac>
    freeproc(np);
    800014d2:	8552                	mv	a0,s4
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	d6e080e7          	jalr	-658(ra) # 80001242 <freeproc>
    release(&np->lock);
    800014dc:	8552                	mv	a0,s4
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	ec4080e7          	jalr	-316(ra) # 800063a2 <release>
    return -1;
    800014e6:	597d                	li	s2,-1
    800014e8:	a059                	j	8000156e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800014ea:	04a1                	addi	s1,s1,8
    800014ec:	0921                	addi	s2,s2,8
    800014ee:	01348b63          	beq	s1,s3,80001504 <fork+0xbe>
    if(p->ofile[i])
    800014f2:	6088                	ld	a0,0(s1)
    800014f4:	d97d                	beqz	a0,800014ea <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800014f6:	00002097          	auipc	ra,0x2
    800014fa:	67e080e7          	jalr	1662(ra) # 80003b74 <filedup>
    800014fe:	00a93023          	sd	a0,0(s2)
    80001502:	b7e5                	j	800014ea <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001504:	150ab503          	ld	a0,336(s5)
    80001508:	00002097          	auipc	ra,0x2
    8000150c:	816080e7          	jalr	-2026(ra) # 80002d1e <idup>
    80001510:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001514:	4641                	li	a2,16
    80001516:	158a8593          	addi	a1,s5,344
    8000151a:	158a0513          	addi	a0,s4,344
    8000151e:	fffff097          	auipc	ra,0xfffff
    80001522:	eae080e7          	jalr	-338(ra) # 800003cc <safestrcpy>
  pid = np->pid;
    80001526:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000152a:	8552                	mv	a0,s4
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	e76080e7          	jalr	-394(ra) # 800063a2 <release>
  acquire(&wait_lock);
    80001534:	00027497          	auipc	s1,0x27
    80001538:	48c48493          	addi	s1,s1,1164 # 800289c0 <wait_lock>
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	db0080e7          	jalr	-592(ra) # 800062ee <acquire>
  np->parent = p;
    80001546:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	e56080e7          	jalr	-426(ra) # 800063a2 <release>
  acquire(&np->lock);
    80001554:	8552                	mv	a0,s4
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d98080e7          	jalr	-616(ra) # 800062ee <acquire>
  np->state = RUNNABLE;
    8000155e:	478d                	li	a5,3
    80001560:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001564:	8552                	mv	a0,s4
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	e3c080e7          	jalr	-452(ra) # 800063a2 <release>
}
    8000156e:	854a                	mv	a0,s2
    80001570:	70e2                	ld	ra,56(sp)
    80001572:	7442                	ld	s0,48(sp)
    80001574:	74a2                	ld	s1,40(sp)
    80001576:	7902                	ld	s2,32(sp)
    80001578:	69e2                	ld	s3,24(sp)
    8000157a:	6a42                	ld	s4,16(sp)
    8000157c:	6aa2                	ld	s5,8(sp)
    8000157e:	6121                	addi	sp,sp,64
    80001580:	8082                	ret
    return -1;
    80001582:	597d                	li	s2,-1
    80001584:	b7ed                	j	8000156e <fork+0x128>

0000000080001586 <scheduler>:
{
    80001586:	7139                	addi	sp,sp,-64
    80001588:	fc06                	sd	ra,56(sp)
    8000158a:	f822                	sd	s0,48(sp)
    8000158c:	f426                	sd	s1,40(sp)
    8000158e:	f04a                	sd	s2,32(sp)
    80001590:	ec4e                	sd	s3,24(sp)
    80001592:	e852                	sd	s4,16(sp)
    80001594:	e456                	sd	s5,8(sp)
    80001596:	e05a                	sd	s6,0(sp)
    80001598:	0080                	addi	s0,sp,64
    8000159a:	8792                	mv	a5,tp
  int id = r_tp();
    8000159c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000159e:	00779a93          	slli	s5,a5,0x7
    800015a2:	00027717          	auipc	a4,0x27
    800015a6:	40670713          	addi	a4,a4,1030 # 800289a8 <pid_lock>
    800015aa:	9756                	add	a4,a4,s5
    800015ac:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015b0:	00027717          	auipc	a4,0x27
    800015b4:	43070713          	addi	a4,a4,1072 # 800289e0 <cpus+0x8>
    800015b8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015ba:	498d                	li	s3,3
        p->state = RUNNING;
    800015bc:	4b11                	li	s6,4
        c->proc = p;
    800015be:	079e                	slli	a5,a5,0x7
    800015c0:	00027a17          	auipc	s4,0x27
    800015c4:	3e8a0a13          	addi	s4,s4,1000 # 800289a8 <pid_lock>
    800015c8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ca:	0002d917          	auipc	s2,0x2d
    800015ce:	20e90913          	addi	s2,s2,526 # 8002e7d8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015d6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015da:	10079073          	csrw	sstatus,a5
    800015de:	00027497          	auipc	s1,0x27
    800015e2:	7fa48493          	addi	s1,s1,2042 # 80028dd8 <proc>
    800015e6:	a811                	j	800015fa <scheduler+0x74>
      release(&p->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	db8080e7          	jalr	-584(ra) # 800063a2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015f2:	16848493          	addi	s1,s1,360
    800015f6:	fd248ee3          	beq	s1,s2,800015d2 <scheduler+0x4c>
      acquire(&p->lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	00005097          	auipc	ra,0x5
    80001600:	cf2080e7          	jalr	-782(ra) # 800062ee <acquire>
      if(p->state == RUNNABLE) {
    80001604:	4c9c                	lw	a5,24(s1)
    80001606:	ff3791e3          	bne	a5,s3,800015e8 <scheduler+0x62>
        p->state = RUNNING;
    8000160a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000160e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001612:	06048593          	addi	a1,s1,96
    80001616:	8556                	mv	a0,s5
    80001618:	00000097          	auipc	ra,0x0
    8000161c:	684080e7          	jalr	1668(ra) # 80001c9c <swtch>
        c->proc = 0;
    80001620:	020a3823          	sd	zero,48(s4)
    80001624:	b7d1                	j	800015e8 <scheduler+0x62>

0000000080001626 <sched>:
{
    80001626:	7179                	addi	sp,sp,-48
    80001628:	f406                	sd	ra,40(sp)
    8000162a:	f022                	sd	s0,32(sp)
    8000162c:	ec26                	sd	s1,24(sp)
    8000162e:	e84a                	sd	s2,16(sp)
    80001630:	e44e                	sd	s3,8(sp)
    80001632:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001634:	00000097          	auipc	ra,0x0
    80001638:	a5c080e7          	jalr	-1444(ra) # 80001090 <myproc>
    8000163c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	c36080e7          	jalr	-970(ra) # 80006274 <holding>
    80001646:	c93d                	beqz	a0,800016bc <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001648:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000164a:	2781                	sext.w	a5,a5
    8000164c:	079e                	slli	a5,a5,0x7
    8000164e:	00027717          	auipc	a4,0x27
    80001652:	35a70713          	addi	a4,a4,858 # 800289a8 <pid_lock>
    80001656:	97ba                	add	a5,a5,a4
    80001658:	0a87a703          	lw	a4,168(a5)
    8000165c:	4785                	li	a5,1
    8000165e:	06f71763          	bne	a4,a5,800016cc <sched+0xa6>
  if(p->state == RUNNING)
    80001662:	4c98                	lw	a4,24(s1)
    80001664:	4791                	li	a5,4
    80001666:	06f70b63          	beq	a4,a5,800016dc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000166a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000166e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001670:	efb5                	bnez	a5,800016ec <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001672:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001674:	00027917          	auipc	s2,0x27
    80001678:	33490913          	addi	s2,s2,820 # 800289a8 <pid_lock>
    8000167c:	2781                	sext.w	a5,a5
    8000167e:	079e                	slli	a5,a5,0x7
    80001680:	97ca                	add	a5,a5,s2
    80001682:	0ac7a983          	lw	s3,172(a5)
    80001686:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001688:	2781                	sext.w	a5,a5
    8000168a:	079e                	slli	a5,a5,0x7
    8000168c:	00027597          	auipc	a1,0x27
    80001690:	35458593          	addi	a1,a1,852 # 800289e0 <cpus+0x8>
    80001694:	95be                	add	a1,a1,a5
    80001696:	06048513          	addi	a0,s1,96
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	602080e7          	jalr	1538(ra) # 80001c9c <swtch>
    800016a2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016a4:	2781                	sext.w	a5,a5
    800016a6:	079e                	slli	a5,a5,0x7
    800016a8:	993e                	add	s2,s2,a5
    800016aa:	0b392623          	sw	s3,172(s2)
}
    800016ae:	70a2                	ld	ra,40(sp)
    800016b0:	7402                	ld	s0,32(sp)
    800016b2:	64e2                	ld	s1,24(sp)
    800016b4:	6942                	ld	s2,16(sp)
    800016b6:	69a2                	ld	s3,8(sp)
    800016b8:	6145                	addi	sp,sp,48
    800016ba:	8082                	ret
    panic("sched p->lock");
    800016bc:	00007517          	auipc	a0,0x7
    800016c0:	b4450513          	addi	a0,a0,-1212 # 80008200 <etext+0x200>
    800016c4:	00004097          	auipc	ra,0x4
    800016c8:	6f2080e7          	jalr	1778(ra) # 80005db6 <panic>
    panic("sched locks");
    800016cc:	00007517          	auipc	a0,0x7
    800016d0:	b4450513          	addi	a0,a0,-1212 # 80008210 <etext+0x210>
    800016d4:	00004097          	auipc	ra,0x4
    800016d8:	6e2080e7          	jalr	1762(ra) # 80005db6 <panic>
    panic("sched running");
    800016dc:	00007517          	auipc	a0,0x7
    800016e0:	b4450513          	addi	a0,a0,-1212 # 80008220 <etext+0x220>
    800016e4:	00004097          	auipc	ra,0x4
    800016e8:	6d2080e7          	jalr	1746(ra) # 80005db6 <panic>
    panic("sched interruptible");
    800016ec:	00007517          	auipc	a0,0x7
    800016f0:	b4450513          	addi	a0,a0,-1212 # 80008230 <etext+0x230>
    800016f4:	00004097          	auipc	ra,0x4
    800016f8:	6c2080e7          	jalr	1730(ra) # 80005db6 <panic>

00000000800016fc <yield>:
{
    800016fc:	1101                	addi	sp,sp,-32
    800016fe:	ec06                	sd	ra,24(sp)
    80001700:	e822                	sd	s0,16(sp)
    80001702:	e426                	sd	s1,8(sp)
    80001704:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	98a080e7          	jalr	-1654(ra) # 80001090 <myproc>
    8000170e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001710:	00005097          	auipc	ra,0x5
    80001714:	bde080e7          	jalr	-1058(ra) # 800062ee <acquire>
  p->state = RUNNABLE;
    80001718:	478d                	li	a5,3
    8000171a:	cc9c                	sw	a5,24(s1)
  sched();
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	f0a080e7          	jalr	-246(ra) # 80001626 <sched>
  release(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	c7c080e7          	jalr	-900(ra) # 800063a2 <release>
}
    8000172e:	60e2                	ld	ra,24(sp)
    80001730:	6442                	ld	s0,16(sp)
    80001732:	64a2                	ld	s1,8(sp)
    80001734:	6105                	addi	sp,sp,32
    80001736:	8082                	ret

0000000080001738 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001738:	7179                	addi	sp,sp,-48
    8000173a:	f406                	sd	ra,40(sp)
    8000173c:	f022                	sd	s0,32(sp)
    8000173e:	ec26                	sd	s1,24(sp)
    80001740:	e84a                	sd	s2,16(sp)
    80001742:	e44e                	sd	s3,8(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	89aa                	mv	s3,a0
    80001748:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	946080e7          	jalr	-1722(ra) # 80001090 <myproc>
    80001752:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001754:	00005097          	auipc	ra,0x5
    80001758:	b9a080e7          	jalr	-1126(ra) # 800062ee <acquire>
  release(lk);
    8000175c:	854a                	mv	a0,s2
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	c44080e7          	jalr	-956(ra) # 800063a2 <release>

  // Go to sleep.
  p->chan = chan;
    80001766:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000176a:	4789                	li	a5,2
    8000176c:	cc9c                	sw	a5,24(s1)

  sched();
    8000176e:	00000097          	auipc	ra,0x0
    80001772:	eb8080e7          	jalr	-328(ra) # 80001626 <sched>

  // Tidy up.
  p->chan = 0;
    80001776:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000177a:	8526                	mv	a0,s1
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	c26080e7          	jalr	-986(ra) # 800063a2 <release>
  acquire(lk);
    80001784:	854a                	mv	a0,s2
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	b68080e7          	jalr	-1176(ra) # 800062ee <acquire>
}
    8000178e:	70a2                	ld	ra,40(sp)
    80001790:	7402                	ld	s0,32(sp)
    80001792:	64e2                	ld	s1,24(sp)
    80001794:	6942                	ld	s2,16(sp)
    80001796:	69a2                	ld	s3,8(sp)
    80001798:	6145                	addi	sp,sp,48
    8000179a:	8082                	ret

000000008000179c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000179c:	7139                	addi	sp,sp,-64
    8000179e:	fc06                	sd	ra,56(sp)
    800017a0:	f822                	sd	s0,48(sp)
    800017a2:	f426                	sd	s1,40(sp)
    800017a4:	f04a                	sd	s2,32(sp)
    800017a6:	ec4e                	sd	s3,24(sp)
    800017a8:	e852                	sd	s4,16(sp)
    800017aa:	e456                	sd	s5,8(sp)
    800017ac:	0080                	addi	s0,sp,64
    800017ae:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017b0:	00027497          	auipc	s1,0x27
    800017b4:	62848493          	addi	s1,s1,1576 # 80028dd8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017b8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017ba:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017bc:	0002d917          	auipc	s2,0x2d
    800017c0:	01c90913          	addi	s2,s2,28 # 8002e7d8 <tickslock>
    800017c4:	a811                	j	800017d8 <wakeup+0x3c>
      }
      release(&p->lock);
    800017c6:	8526                	mv	a0,s1
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	bda080e7          	jalr	-1062(ra) # 800063a2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d0:	16848493          	addi	s1,s1,360
    800017d4:	03248663          	beq	s1,s2,80001800 <wakeup+0x64>
    if(p != myproc()){
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	8b8080e7          	jalr	-1864(ra) # 80001090 <myproc>
    800017e0:	fea488e3          	beq	s1,a0,800017d0 <wakeup+0x34>
      acquire(&p->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	b08080e7          	jalr	-1272(ra) # 800062ee <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017ee:	4c9c                	lw	a5,24(s1)
    800017f0:	fd379be3          	bne	a5,s3,800017c6 <wakeup+0x2a>
    800017f4:	709c                	ld	a5,32(s1)
    800017f6:	fd4798e3          	bne	a5,s4,800017c6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800017fa:	0154ac23          	sw	s5,24(s1)
    800017fe:	b7e1                	j	800017c6 <wakeup+0x2a>
    }
  }
}
    80001800:	70e2                	ld	ra,56(sp)
    80001802:	7442                	ld	s0,48(sp)
    80001804:	74a2                	ld	s1,40(sp)
    80001806:	7902                	ld	s2,32(sp)
    80001808:	69e2                	ld	s3,24(sp)
    8000180a:	6a42                	ld	s4,16(sp)
    8000180c:	6aa2                	ld	s5,8(sp)
    8000180e:	6121                	addi	sp,sp,64
    80001810:	8082                	ret

0000000080001812 <reparent>:
{
    80001812:	7179                	addi	sp,sp,-48
    80001814:	f406                	sd	ra,40(sp)
    80001816:	f022                	sd	s0,32(sp)
    80001818:	ec26                	sd	s1,24(sp)
    8000181a:	e84a                	sd	s2,16(sp)
    8000181c:	e44e                	sd	s3,8(sp)
    8000181e:	e052                	sd	s4,0(sp)
    80001820:	1800                	addi	s0,sp,48
    80001822:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001824:	00027497          	auipc	s1,0x27
    80001828:	5b448493          	addi	s1,s1,1460 # 80028dd8 <proc>
      pp->parent = initproc;
    8000182c:	00007a17          	auipc	s4,0x7
    80001830:	124a0a13          	addi	s4,s4,292 # 80008950 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001834:	0002d997          	auipc	s3,0x2d
    80001838:	fa498993          	addi	s3,s3,-92 # 8002e7d8 <tickslock>
    8000183c:	a029                	j	80001846 <reparent+0x34>
    8000183e:	16848493          	addi	s1,s1,360
    80001842:	01348d63          	beq	s1,s3,8000185c <reparent+0x4a>
    if(pp->parent == p){
    80001846:	7c9c                	ld	a5,56(s1)
    80001848:	ff279be3          	bne	a5,s2,8000183e <reparent+0x2c>
      pp->parent = initproc;
    8000184c:	000a3503          	ld	a0,0(s4)
    80001850:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001852:	00000097          	auipc	ra,0x0
    80001856:	f4a080e7          	jalr	-182(ra) # 8000179c <wakeup>
    8000185a:	b7d5                	j	8000183e <reparent+0x2c>
}
    8000185c:	70a2                	ld	ra,40(sp)
    8000185e:	7402                	ld	s0,32(sp)
    80001860:	64e2                	ld	s1,24(sp)
    80001862:	6942                	ld	s2,16(sp)
    80001864:	69a2                	ld	s3,8(sp)
    80001866:	6a02                	ld	s4,0(sp)
    80001868:	6145                	addi	sp,sp,48
    8000186a:	8082                	ret

000000008000186c <exit>:
{
    8000186c:	7179                	addi	sp,sp,-48
    8000186e:	f406                	sd	ra,40(sp)
    80001870:	f022                	sd	s0,32(sp)
    80001872:	ec26                	sd	s1,24(sp)
    80001874:	e84a                	sd	s2,16(sp)
    80001876:	e44e                	sd	s3,8(sp)
    80001878:	e052                	sd	s4,0(sp)
    8000187a:	1800                	addi	s0,sp,48
    8000187c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000187e:	00000097          	auipc	ra,0x0
    80001882:	812080e7          	jalr	-2030(ra) # 80001090 <myproc>
    80001886:	89aa                	mv	s3,a0
  if(p == initproc)
    80001888:	00007797          	auipc	a5,0x7
    8000188c:	0c87b783          	ld	a5,200(a5) # 80008950 <initproc>
    80001890:	0d050493          	addi	s1,a0,208
    80001894:	15050913          	addi	s2,a0,336
    80001898:	02a79363          	bne	a5,a0,800018be <exit+0x52>
    panic("init exiting");
    8000189c:	00007517          	auipc	a0,0x7
    800018a0:	9ac50513          	addi	a0,a0,-1620 # 80008248 <etext+0x248>
    800018a4:	00004097          	auipc	ra,0x4
    800018a8:	512080e7          	jalr	1298(ra) # 80005db6 <panic>
      fileclose(f);
    800018ac:	00002097          	auipc	ra,0x2
    800018b0:	31a080e7          	jalr	794(ra) # 80003bc6 <fileclose>
      p->ofile[fd] = 0;
    800018b4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018b8:	04a1                	addi	s1,s1,8
    800018ba:	01248563          	beq	s1,s2,800018c4 <exit+0x58>
    if(p->ofile[fd]){
    800018be:	6088                	ld	a0,0(s1)
    800018c0:	f575                	bnez	a0,800018ac <exit+0x40>
    800018c2:	bfdd                	j	800018b8 <exit+0x4c>
  begin_op();
    800018c4:	00002097          	auipc	ra,0x2
    800018c8:	e3e080e7          	jalr	-450(ra) # 80003702 <begin_op>
  iput(p->cwd);
    800018cc:	1509b503          	ld	a0,336(s3)
    800018d0:	00001097          	auipc	ra,0x1
    800018d4:	646080e7          	jalr	1606(ra) # 80002f16 <iput>
  end_op();
    800018d8:	00002097          	auipc	ra,0x2
    800018dc:	ea4080e7          	jalr	-348(ra) # 8000377c <end_op>
  p->cwd = 0;
    800018e0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800018e4:	00027497          	auipc	s1,0x27
    800018e8:	0dc48493          	addi	s1,s1,220 # 800289c0 <wait_lock>
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	a00080e7          	jalr	-1536(ra) # 800062ee <acquire>
  reparent(p);
    800018f6:	854e                	mv	a0,s3
    800018f8:	00000097          	auipc	ra,0x0
    800018fc:	f1a080e7          	jalr	-230(ra) # 80001812 <reparent>
  wakeup(p->parent);
    80001900:	0389b503          	ld	a0,56(s3)
    80001904:	00000097          	auipc	ra,0x0
    80001908:	e98080e7          	jalr	-360(ra) # 8000179c <wakeup>
  acquire(&p->lock);
    8000190c:	854e                	mv	a0,s3
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	9e0080e7          	jalr	-1568(ra) # 800062ee <acquire>
  p->xstate = status;
    80001916:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000191a:	4795                	li	a5,5
    8000191c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001920:	8526                	mv	a0,s1
    80001922:	00005097          	auipc	ra,0x5
    80001926:	a80080e7          	jalr	-1408(ra) # 800063a2 <release>
  sched();
    8000192a:	00000097          	auipc	ra,0x0
    8000192e:	cfc080e7          	jalr	-772(ra) # 80001626 <sched>
  panic("zombie exit");
    80001932:	00007517          	auipc	a0,0x7
    80001936:	92650513          	addi	a0,a0,-1754 # 80008258 <etext+0x258>
    8000193a:	00004097          	auipc	ra,0x4
    8000193e:	47c080e7          	jalr	1148(ra) # 80005db6 <panic>

0000000080001942 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001942:	7179                	addi	sp,sp,-48
    80001944:	f406                	sd	ra,40(sp)
    80001946:	f022                	sd	s0,32(sp)
    80001948:	ec26                	sd	s1,24(sp)
    8000194a:	e84a                	sd	s2,16(sp)
    8000194c:	e44e                	sd	s3,8(sp)
    8000194e:	1800                	addi	s0,sp,48
    80001950:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001952:	00027497          	auipc	s1,0x27
    80001956:	48648493          	addi	s1,s1,1158 # 80028dd8 <proc>
    8000195a:	0002d997          	auipc	s3,0x2d
    8000195e:	e7e98993          	addi	s3,s3,-386 # 8002e7d8 <tickslock>
    acquire(&p->lock);
    80001962:	8526                	mv	a0,s1
    80001964:	00005097          	auipc	ra,0x5
    80001968:	98a080e7          	jalr	-1654(ra) # 800062ee <acquire>
    if(p->pid == pid){
    8000196c:	589c                	lw	a5,48(s1)
    8000196e:	01278d63          	beq	a5,s2,80001988 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	a2e080e7          	jalr	-1490(ra) # 800063a2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197c:	16848493          	addi	s1,s1,360
    80001980:	ff3491e3          	bne	s1,s3,80001962 <kill+0x20>
  }
  return -1;
    80001984:	557d                	li	a0,-1
    80001986:	a829                	j	800019a0 <kill+0x5e>
      p->killed = 1;
    80001988:	4785                	li	a5,1
    8000198a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000198c:	4c98                	lw	a4,24(s1)
    8000198e:	4789                	li	a5,2
    80001990:	00f70f63          	beq	a4,a5,800019ae <kill+0x6c>
      release(&p->lock);
    80001994:	8526                	mv	a0,s1
    80001996:	00005097          	auipc	ra,0x5
    8000199a:	a0c080e7          	jalr	-1524(ra) # 800063a2 <release>
      return 0;
    8000199e:	4501                	li	a0,0
}
    800019a0:	70a2                	ld	ra,40(sp)
    800019a2:	7402                	ld	s0,32(sp)
    800019a4:	64e2                	ld	s1,24(sp)
    800019a6:	6942                	ld	s2,16(sp)
    800019a8:	69a2                	ld	s3,8(sp)
    800019aa:	6145                	addi	sp,sp,48
    800019ac:	8082                	ret
        p->state = RUNNABLE;
    800019ae:	478d                	li	a5,3
    800019b0:	cc9c                	sw	a5,24(s1)
    800019b2:	b7cd                	j	80001994 <kill+0x52>

00000000800019b4 <setkilled>:

void
setkilled(struct proc *p)
{
    800019b4:	1101                	addi	sp,sp,-32
    800019b6:	ec06                	sd	ra,24(sp)
    800019b8:	e822                	sd	s0,16(sp)
    800019ba:	e426                	sd	s1,8(sp)
    800019bc:	1000                	addi	s0,sp,32
    800019be:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	92e080e7          	jalr	-1746(ra) # 800062ee <acquire>
  p->killed = 1;
    800019c8:	4785                	li	a5,1
    800019ca:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	9d4080e7          	jalr	-1580(ra) # 800063a2 <release>
}
    800019d6:	60e2                	ld	ra,24(sp)
    800019d8:	6442                	ld	s0,16(sp)
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	6105                	addi	sp,sp,32
    800019de:	8082                	ret

00000000800019e0 <killed>:

int
killed(struct proc *p)
{
    800019e0:	1101                	addi	sp,sp,-32
    800019e2:	ec06                	sd	ra,24(sp)
    800019e4:	e822                	sd	s0,16(sp)
    800019e6:	e426                	sd	s1,8(sp)
    800019e8:	e04a                	sd	s2,0(sp)
    800019ea:	1000                	addi	s0,sp,32
    800019ec:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019ee:	00005097          	auipc	ra,0x5
    800019f2:	900080e7          	jalr	-1792(ra) # 800062ee <acquire>
  k = p->killed;
    800019f6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	00005097          	auipc	ra,0x5
    80001a00:	9a6080e7          	jalr	-1626(ra) # 800063a2 <release>
  return k;
}
    80001a04:	854a                	mv	a0,s2
    80001a06:	60e2                	ld	ra,24(sp)
    80001a08:	6442                	ld	s0,16(sp)
    80001a0a:	64a2                	ld	s1,8(sp)
    80001a0c:	6902                	ld	s2,0(sp)
    80001a0e:	6105                	addi	sp,sp,32
    80001a10:	8082                	ret

0000000080001a12 <wait>:
{
    80001a12:	715d                	addi	sp,sp,-80
    80001a14:	e486                	sd	ra,72(sp)
    80001a16:	e0a2                	sd	s0,64(sp)
    80001a18:	fc26                	sd	s1,56(sp)
    80001a1a:	f84a                	sd	s2,48(sp)
    80001a1c:	f44e                	sd	s3,40(sp)
    80001a1e:	f052                	sd	s4,32(sp)
    80001a20:	ec56                	sd	s5,24(sp)
    80001a22:	e85a                	sd	s6,16(sp)
    80001a24:	e45e                	sd	s7,8(sp)
    80001a26:	e062                	sd	s8,0(sp)
    80001a28:	0880                	addi	s0,sp,80
    80001a2a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	664080e7          	jalr	1636(ra) # 80001090 <myproc>
    80001a34:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a36:	00027517          	auipc	a0,0x27
    80001a3a:	f8a50513          	addi	a0,a0,-118 # 800289c0 <wait_lock>
    80001a3e:	00005097          	auipc	ra,0x5
    80001a42:	8b0080e7          	jalr	-1872(ra) # 800062ee <acquire>
    havekids = 0;
    80001a46:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a48:	4a15                	li	s4,5
        havekids = 1;
    80001a4a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a4c:	0002d997          	auipc	s3,0x2d
    80001a50:	d8c98993          	addi	s3,s3,-628 # 8002e7d8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a54:	00027c17          	auipc	s8,0x27
    80001a58:	f6cc0c13          	addi	s8,s8,-148 # 800289c0 <wait_lock>
    80001a5c:	a0d1                	j	80001b20 <wait+0x10e>
          pid = pp->pid;
    80001a5e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a62:	000b0e63          	beqz	s6,80001a7e <wait+0x6c>
    80001a66:	4691                	li	a3,4
    80001a68:	02c48613          	addi	a2,s1,44
    80001a6c:	85da                	mv	a1,s6
    80001a6e:	05093503          	ld	a0,80(s2)
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	3ea080e7          	jalr	1002(ra) # 80000e5c <copyout>
    80001a7a:	04054163          	bltz	a0,80001abc <wait+0xaa>
          freeproc(pp);
    80001a7e:	8526                	mv	a0,s1
    80001a80:	fffff097          	auipc	ra,0xfffff
    80001a84:	7c2080e7          	jalr	1986(ra) # 80001242 <freeproc>
          release(&pp->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	918080e7          	jalr	-1768(ra) # 800063a2 <release>
          release(&wait_lock);
    80001a92:	00027517          	auipc	a0,0x27
    80001a96:	f2e50513          	addi	a0,a0,-210 # 800289c0 <wait_lock>
    80001a9a:	00005097          	auipc	ra,0x5
    80001a9e:	908080e7          	jalr	-1784(ra) # 800063a2 <release>
}
    80001aa2:	854e                	mv	a0,s3
    80001aa4:	60a6                	ld	ra,72(sp)
    80001aa6:	6406                	ld	s0,64(sp)
    80001aa8:	74e2                	ld	s1,56(sp)
    80001aaa:	7942                	ld	s2,48(sp)
    80001aac:	79a2                	ld	s3,40(sp)
    80001aae:	7a02                	ld	s4,32(sp)
    80001ab0:	6ae2                	ld	s5,24(sp)
    80001ab2:	6b42                	ld	s6,16(sp)
    80001ab4:	6ba2                	ld	s7,8(sp)
    80001ab6:	6c02                	ld	s8,0(sp)
    80001ab8:	6161                	addi	sp,sp,80
    80001aba:	8082                	ret
            release(&pp->lock);
    80001abc:	8526                	mv	a0,s1
    80001abe:	00005097          	auipc	ra,0x5
    80001ac2:	8e4080e7          	jalr	-1820(ra) # 800063a2 <release>
            release(&wait_lock);
    80001ac6:	00027517          	auipc	a0,0x27
    80001aca:	efa50513          	addi	a0,a0,-262 # 800289c0 <wait_lock>
    80001ace:	00005097          	auipc	ra,0x5
    80001ad2:	8d4080e7          	jalr	-1836(ra) # 800063a2 <release>
            return -1;
    80001ad6:	59fd                	li	s3,-1
    80001ad8:	b7e9                	j	80001aa2 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ada:	16848493          	addi	s1,s1,360
    80001ade:	03348463          	beq	s1,s3,80001b06 <wait+0xf4>
      if(pp->parent == p){
    80001ae2:	7c9c                	ld	a5,56(s1)
    80001ae4:	ff279be3          	bne	a5,s2,80001ada <wait+0xc8>
        acquire(&pp->lock);
    80001ae8:	8526                	mv	a0,s1
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	804080e7          	jalr	-2044(ra) # 800062ee <acquire>
        if(pp->state == ZOMBIE){
    80001af2:	4c9c                	lw	a5,24(s1)
    80001af4:	f74785e3          	beq	a5,s4,80001a5e <wait+0x4c>
        release(&pp->lock);
    80001af8:	8526                	mv	a0,s1
    80001afa:	00005097          	auipc	ra,0x5
    80001afe:	8a8080e7          	jalr	-1880(ra) # 800063a2 <release>
        havekids = 1;
    80001b02:	8756                	mv	a4,s5
    80001b04:	bfd9                	j	80001ada <wait+0xc8>
    if(!havekids || killed(p)){
    80001b06:	c31d                	beqz	a4,80001b2c <wait+0x11a>
    80001b08:	854a                	mv	a0,s2
    80001b0a:	00000097          	auipc	ra,0x0
    80001b0e:	ed6080e7          	jalr	-298(ra) # 800019e0 <killed>
    80001b12:	ed09                	bnez	a0,80001b2c <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b14:	85e2                	mv	a1,s8
    80001b16:	854a                	mv	a0,s2
    80001b18:	00000097          	auipc	ra,0x0
    80001b1c:	c20080e7          	jalr	-992(ra) # 80001738 <sleep>
    havekids = 0;
    80001b20:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b22:	00027497          	auipc	s1,0x27
    80001b26:	2b648493          	addi	s1,s1,694 # 80028dd8 <proc>
    80001b2a:	bf65                	j	80001ae2 <wait+0xd0>
      release(&wait_lock);
    80001b2c:	00027517          	auipc	a0,0x27
    80001b30:	e9450513          	addi	a0,a0,-364 # 800289c0 <wait_lock>
    80001b34:	00005097          	auipc	ra,0x5
    80001b38:	86e080e7          	jalr	-1938(ra) # 800063a2 <release>
      return -1;
    80001b3c:	59fd                	li	s3,-1
    80001b3e:	b795                	j	80001aa2 <wait+0x90>

0000000080001b40 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b40:	7179                	addi	sp,sp,-48
    80001b42:	f406                	sd	ra,40(sp)
    80001b44:	f022                	sd	s0,32(sp)
    80001b46:	ec26                	sd	s1,24(sp)
    80001b48:	e84a                	sd	s2,16(sp)
    80001b4a:	e44e                	sd	s3,8(sp)
    80001b4c:	e052                	sd	s4,0(sp)
    80001b4e:	1800                	addi	s0,sp,48
    80001b50:	84aa                	mv	s1,a0
    80001b52:	892e                	mv	s2,a1
    80001b54:	89b2                	mv	s3,a2
    80001b56:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b58:	fffff097          	auipc	ra,0xfffff
    80001b5c:	538080e7          	jalr	1336(ra) # 80001090 <myproc>
  if(user_dst){
    80001b60:	c08d                	beqz	s1,80001b82 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b62:	86d2                	mv	a3,s4
    80001b64:	864e                	mv	a2,s3
    80001b66:	85ca                	mv	a1,s2
    80001b68:	6928                	ld	a0,80(a0)
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	2f2080e7          	jalr	754(ra) # 80000e5c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b72:	70a2                	ld	ra,40(sp)
    80001b74:	7402                	ld	s0,32(sp)
    80001b76:	64e2                	ld	s1,24(sp)
    80001b78:	6942                	ld	s2,16(sp)
    80001b7a:	69a2                	ld	s3,8(sp)
    80001b7c:	6a02                	ld	s4,0(sp)
    80001b7e:	6145                	addi	sp,sp,48
    80001b80:	8082                	ret
    memmove((char *)dst, src, len);
    80001b82:	000a061b          	sext.w	a2,s4
    80001b86:	85ce                	mv	a1,s3
    80001b88:	854a                	mv	a0,s2
    80001b8a:	ffffe097          	auipc	ra,0xffffe
    80001b8e:	756080e7          	jalr	1878(ra) # 800002e0 <memmove>
    return 0;
    80001b92:	8526                	mv	a0,s1
    80001b94:	bff9                	j	80001b72 <either_copyout+0x32>

0000000080001b96 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b96:	7179                	addi	sp,sp,-48
    80001b98:	f406                	sd	ra,40(sp)
    80001b9a:	f022                	sd	s0,32(sp)
    80001b9c:	ec26                	sd	s1,24(sp)
    80001b9e:	e84a                	sd	s2,16(sp)
    80001ba0:	e44e                	sd	s3,8(sp)
    80001ba2:	e052                	sd	s4,0(sp)
    80001ba4:	1800                	addi	s0,sp,48
    80001ba6:	892a                	mv	s2,a0
    80001ba8:	84ae                	mv	s1,a1
    80001baa:	89b2                	mv	s3,a2
    80001bac:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bae:	fffff097          	auipc	ra,0xfffff
    80001bb2:	4e2080e7          	jalr	1250(ra) # 80001090 <myproc>
  if(user_src){
    80001bb6:	c08d                	beqz	s1,80001bd8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bb8:	86d2                	mv	a3,s4
    80001bba:	864e                	mv	a2,s3
    80001bbc:	85ca                	mv	a1,s2
    80001bbe:	6928                	ld	a0,80(a0)
    80001bc0:	fffff097          	auipc	ra,0xfffff
    80001bc4:	052080e7          	jalr	82(ra) # 80000c12 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bc8:	70a2                	ld	ra,40(sp)
    80001bca:	7402                	ld	s0,32(sp)
    80001bcc:	64e2                	ld	s1,24(sp)
    80001bce:	6942                	ld	s2,16(sp)
    80001bd0:	69a2                	ld	s3,8(sp)
    80001bd2:	6a02                	ld	s4,0(sp)
    80001bd4:	6145                	addi	sp,sp,48
    80001bd6:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bd8:	000a061b          	sext.w	a2,s4
    80001bdc:	85ce                	mv	a1,s3
    80001bde:	854a                	mv	a0,s2
    80001be0:	ffffe097          	auipc	ra,0xffffe
    80001be4:	700080e7          	jalr	1792(ra) # 800002e0 <memmove>
    return 0;
    80001be8:	8526                	mv	a0,s1
    80001bea:	bff9                	j	80001bc8 <either_copyin+0x32>

0000000080001bec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001bec:	715d                	addi	sp,sp,-80
    80001bee:	e486                	sd	ra,72(sp)
    80001bf0:	e0a2                	sd	s0,64(sp)
    80001bf2:	fc26                	sd	s1,56(sp)
    80001bf4:	f84a                	sd	s2,48(sp)
    80001bf6:	f44e                	sd	s3,40(sp)
    80001bf8:	f052                	sd	s4,32(sp)
    80001bfa:	ec56                	sd	s5,24(sp)
    80001bfc:	e85a                	sd	s6,16(sp)
    80001bfe:	e45e                	sd	s7,8(sp)
    80001c00:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c02:	00006517          	auipc	a0,0x6
    80001c06:	45650513          	addi	a0,a0,1110 # 80008058 <etext+0x58>
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	1f6080e7          	jalr	502(ra) # 80005e00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c12:	00027497          	auipc	s1,0x27
    80001c16:	31e48493          	addi	s1,s1,798 # 80028f30 <proc+0x158>
    80001c1a:	0002d917          	auipc	s2,0x2d
    80001c1e:	d1690913          	addi	s2,s2,-746 # 8002e930 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c22:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c24:	00006997          	auipc	s3,0x6
    80001c28:	64498993          	addi	s3,s3,1604 # 80008268 <etext+0x268>
    printf("%d %s %s", p->pid, state, p->name);
    80001c2c:	00006a97          	auipc	s5,0x6
    80001c30:	644a8a93          	addi	s5,s5,1604 # 80008270 <etext+0x270>
    printf("\n");
    80001c34:	00006a17          	auipc	s4,0x6
    80001c38:	424a0a13          	addi	s4,s4,1060 # 80008058 <etext+0x58>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c3c:	00006b97          	auipc	s7,0x6
    80001c40:	674b8b93          	addi	s7,s7,1652 # 800082b0 <states.0>
    80001c44:	a00d                	j	80001c66 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c46:	ed86a583          	lw	a1,-296(a3)
    80001c4a:	8556                	mv	a0,s5
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	1b4080e7          	jalr	436(ra) # 80005e00 <printf>
    printf("\n");
    80001c54:	8552                	mv	a0,s4
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	1aa080e7          	jalr	426(ra) # 80005e00 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c5e:	16848493          	addi	s1,s1,360
    80001c62:	03248263          	beq	s1,s2,80001c86 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c66:	86a6                	mv	a3,s1
    80001c68:	ec04a783          	lw	a5,-320(s1)
    80001c6c:	dbed                	beqz	a5,80001c5e <procdump+0x72>
      state = "???";
    80001c6e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c70:	fcfb6be3          	bltu	s6,a5,80001c46 <procdump+0x5a>
    80001c74:	02079713          	slli	a4,a5,0x20
    80001c78:	01d75793          	srli	a5,a4,0x1d
    80001c7c:	97de                	add	a5,a5,s7
    80001c7e:	6390                	ld	a2,0(a5)
    80001c80:	f279                	bnez	a2,80001c46 <procdump+0x5a>
      state = "???";
    80001c82:	864e                	mv	a2,s3
    80001c84:	b7c9                	j	80001c46 <procdump+0x5a>
  }
}
    80001c86:	60a6                	ld	ra,72(sp)
    80001c88:	6406                	ld	s0,64(sp)
    80001c8a:	74e2                	ld	s1,56(sp)
    80001c8c:	7942                	ld	s2,48(sp)
    80001c8e:	79a2                	ld	s3,40(sp)
    80001c90:	7a02                	ld	s4,32(sp)
    80001c92:	6ae2                	ld	s5,24(sp)
    80001c94:	6b42                	ld	s6,16(sp)
    80001c96:	6ba2                	ld	s7,8(sp)
    80001c98:	6161                	addi	sp,sp,80
    80001c9a:	8082                	ret

0000000080001c9c <swtch>:
    80001c9c:	00153023          	sd	ra,0(a0)
    80001ca0:	00253423          	sd	sp,8(a0)
    80001ca4:	e900                	sd	s0,16(a0)
    80001ca6:	ed04                	sd	s1,24(a0)
    80001ca8:	03253023          	sd	s2,32(a0)
    80001cac:	03353423          	sd	s3,40(a0)
    80001cb0:	03453823          	sd	s4,48(a0)
    80001cb4:	03553c23          	sd	s5,56(a0)
    80001cb8:	05653023          	sd	s6,64(a0)
    80001cbc:	05753423          	sd	s7,72(a0)
    80001cc0:	05853823          	sd	s8,80(a0)
    80001cc4:	05953c23          	sd	s9,88(a0)
    80001cc8:	07a53023          	sd	s10,96(a0)
    80001ccc:	07b53423          	sd	s11,104(a0)
    80001cd0:	0005b083          	ld	ra,0(a1)
    80001cd4:	0085b103          	ld	sp,8(a1)
    80001cd8:	6980                	ld	s0,16(a1)
    80001cda:	6d84                	ld	s1,24(a1)
    80001cdc:	0205b903          	ld	s2,32(a1)
    80001ce0:	0285b983          	ld	s3,40(a1)
    80001ce4:	0305ba03          	ld	s4,48(a1)
    80001ce8:	0385ba83          	ld	s5,56(a1)
    80001cec:	0405bb03          	ld	s6,64(a1)
    80001cf0:	0485bb83          	ld	s7,72(a1)
    80001cf4:	0505bc03          	ld	s8,80(a1)
    80001cf8:	0585bc83          	ld	s9,88(a1)
    80001cfc:	0605bd03          	ld	s10,96(a1)
    80001d00:	0685bd83          	ld	s11,104(a1)
    80001d04:	8082                	ret

0000000080001d06 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d06:	1141                	addi	sp,sp,-16
    80001d08:	e406                	sd	ra,8(sp)
    80001d0a:	e022                	sd	s0,0(sp)
    80001d0c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d0e:	00006597          	auipc	a1,0x6
    80001d12:	5d258593          	addi	a1,a1,1490 # 800082e0 <states.0+0x30>
    80001d16:	0002d517          	auipc	a0,0x2d
    80001d1a:	ac250513          	addi	a0,a0,-1342 # 8002e7d8 <tickslock>
    80001d1e:	00004097          	auipc	ra,0x4
    80001d22:	540080e7          	jalr	1344(ra) # 8000625e <initlock>
}
    80001d26:	60a2                	ld	ra,8(sp)
    80001d28:	6402                	ld	s0,0(sp)
    80001d2a:	0141                	addi	sp,sp,16
    80001d2c:	8082                	ret

0000000080001d2e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d2e:	1141                	addi	sp,sp,-16
    80001d30:	e422                	sd	s0,8(sp)
    80001d32:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d34:	00003797          	auipc	a5,0x3
    80001d38:	4bc78793          	addi	a5,a5,1212 # 800051f0 <kernelvec>
    80001d3c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d40:	6422                	ld	s0,8(sp)
    80001d42:	0141                	addi	sp,sp,16
    80001d44:	8082                	ret

0000000080001d46 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d46:	1141                	addi	sp,sp,-16
    80001d48:	e406                	sd	ra,8(sp)
    80001d4a:	e022                	sd	s0,0(sp)
    80001d4c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d4e:	fffff097          	auipc	ra,0xfffff
    80001d52:	342080e7          	jalr	834(ra) # 80001090 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d60:	00005697          	auipc	a3,0x5
    80001d64:	2a068693          	addi	a3,a3,672 # 80007000 <_trampoline>
    80001d68:	00005717          	auipc	a4,0x5
    80001d6c:	29870713          	addi	a4,a4,664 # 80007000 <_trampoline>
    80001d70:	8f15                	sub	a4,a4,a3
    80001d72:	040007b7          	lui	a5,0x4000
    80001d76:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d78:	07b2                	slli	a5,a5,0xc
    80001d7a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d7c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d80:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d82:	18002673          	csrr	a2,satp
    80001d86:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d88:	6d30                	ld	a2,88(a0)
    80001d8a:	6138                	ld	a4,64(a0)
    80001d8c:	6585                	lui	a1,0x1
    80001d8e:	972e                	add	a4,a4,a1
    80001d90:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d92:	6d38                	ld	a4,88(a0)
    80001d94:	00000617          	auipc	a2,0x0
    80001d98:	13460613          	addi	a2,a2,308 # 80001ec8 <usertrap>
    80001d9c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d9e:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001da0:	8612                	mv	a2,tp
    80001da2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001da8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dac:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001db4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001db6:	6f18                	ld	a4,24(a4)
    80001db8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dbc:	6928                	ld	a0,80(a0)
    80001dbe:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001dc0:	00005717          	auipc	a4,0x5
    80001dc4:	2dc70713          	addi	a4,a4,732 # 8000709c <userret>
    80001dc8:	8f15                	sub	a4,a4,a3
    80001dca:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dcc:	577d                	li	a4,-1
    80001dce:	177e                	slli	a4,a4,0x3f
    80001dd0:	8d59                	or	a0,a0,a4
    80001dd2:	9782                	jalr	a5
}
    80001dd4:	60a2                	ld	ra,8(sp)
    80001dd6:	6402                	ld	s0,0(sp)
    80001dd8:	0141                	addi	sp,sp,16
    80001dda:	8082                	ret

0000000080001ddc <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ddc:	1101                	addi	sp,sp,-32
    80001dde:	ec06                	sd	ra,24(sp)
    80001de0:	e822                	sd	s0,16(sp)
    80001de2:	e426                	sd	s1,8(sp)
    80001de4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001de6:	0002d497          	auipc	s1,0x2d
    80001dea:	9f248493          	addi	s1,s1,-1550 # 8002e7d8 <tickslock>
    80001dee:	8526                	mv	a0,s1
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	4fe080e7          	jalr	1278(ra) # 800062ee <acquire>
  ticks++;
    80001df8:	00007517          	auipc	a0,0x7
    80001dfc:	b6050513          	addi	a0,a0,-1184 # 80008958 <ticks>
    80001e00:	411c                	lw	a5,0(a0)
    80001e02:	2785                	addiw	a5,a5,1
    80001e04:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e06:	00000097          	auipc	ra,0x0
    80001e0a:	996080e7          	jalr	-1642(ra) # 8000179c <wakeup>
  release(&tickslock);
    80001e0e:	8526                	mv	a0,s1
    80001e10:	00004097          	auipc	ra,0x4
    80001e14:	592080e7          	jalr	1426(ra) # 800063a2 <release>
}
    80001e18:	60e2                	ld	ra,24(sp)
    80001e1a:	6442                	ld	s0,16(sp)
    80001e1c:	64a2                	ld	s1,8(sp)
    80001e1e:	6105                	addi	sp,sp,32
    80001e20:	8082                	ret

0000000080001e22 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e22:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e26:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e28:	0807df63          	bgez	a5,80001ec6 <devintr+0xa4>
{
    80001e2c:	1101                	addi	sp,sp,-32
    80001e2e:	ec06                	sd	ra,24(sp)
    80001e30:	e822                	sd	s0,16(sp)
    80001e32:	e426                	sd	s1,8(sp)
    80001e34:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e36:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e3a:	46a5                	li	a3,9
    80001e3c:	00d70d63          	beq	a4,a3,80001e56 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001e40:	577d                	li	a4,-1
    80001e42:	177e                	slli	a4,a4,0x3f
    80001e44:	0705                	addi	a4,a4,1
    return 0;
    80001e46:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e48:	04e78e63          	beq	a5,a4,80001ea4 <devintr+0x82>
  }
}
    80001e4c:	60e2                	ld	ra,24(sp)
    80001e4e:	6442                	ld	s0,16(sp)
    80001e50:	64a2                	ld	s1,8(sp)
    80001e52:	6105                	addi	sp,sp,32
    80001e54:	8082                	ret
    int irq = plic_claim();
    80001e56:	00003097          	auipc	ra,0x3
    80001e5a:	4a2080e7          	jalr	1186(ra) # 800052f8 <plic_claim>
    80001e5e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e60:	47a9                	li	a5,10
    80001e62:	02f50763          	beq	a0,a5,80001e90 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001e66:	4785                	li	a5,1
    80001e68:	02f50963          	beq	a0,a5,80001e9a <devintr+0x78>
    return 1;
    80001e6c:	4505                	li	a0,1
    } else if(irq){
    80001e6e:	dcf9                	beqz	s1,80001e4c <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e70:	85a6                	mv	a1,s1
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	47650513          	addi	a0,a0,1142 # 800082e8 <states.0+0x38>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	f86080e7          	jalr	-122(ra) # 80005e00 <printf>
      plic_complete(irq);
    80001e82:	8526                	mv	a0,s1
    80001e84:	00003097          	auipc	ra,0x3
    80001e88:	498080e7          	jalr	1176(ra) # 8000531c <plic_complete>
    return 1;
    80001e8c:	4505                	li	a0,1
    80001e8e:	bf7d                	j	80001e4c <devintr+0x2a>
      uartintr();
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	37e080e7          	jalr	894(ra) # 8000620e <uartintr>
    if(irq)
    80001e98:	b7ed                	j	80001e82 <devintr+0x60>
      virtio_disk_intr();
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	948080e7          	jalr	-1720(ra) # 800057e2 <virtio_disk_intr>
    if(irq)
    80001ea2:	b7c5                	j	80001e82 <devintr+0x60>
    if(cpuid() == 0){
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	1c0080e7          	jalr	448(ra) # 80001064 <cpuid>
    80001eac:	c901                	beqz	a0,80001ebc <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001eae:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001eb2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001eb4:	14479073          	csrw	sip,a5
    return 2;
    80001eb8:	4509                	li	a0,2
    80001eba:	bf49                	j	80001e4c <devintr+0x2a>
      clockintr();
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	f20080e7          	jalr	-224(ra) # 80001ddc <clockintr>
    80001ec4:	b7ed                	j	80001eae <devintr+0x8c>
}
    80001ec6:	8082                	ret

0000000080001ec8 <usertrap>:
{
    80001ec8:	1101                	addi	sp,sp,-32
    80001eca:	ec06                	sd	ra,24(sp)
    80001ecc:	e822                	sd	s0,16(sp)
    80001ece:	e426                	sd	s1,8(sp)
    80001ed0:	e04a                	sd	s2,0(sp)
    80001ed2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ed8:	1007f793          	andi	a5,a5,256
    80001edc:	efad                	bnez	a5,80001f56 <usertrap+0x8e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ede:	00003797          	auipc	a5,0x3
    80001ee2:	31278793          	addi	a5,a5,786 # 800051f0 <kernelvec>
    80001ee6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	1a6080e7          	jalr	422(ra) # 80001090 <myproc>
    80001ef2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ef4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef6:	14102773          	csrr	a4,sepc
    80001efa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001efc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f00:	47a1                	li	a5,8
    80001f02:	06f70263          	beq	a4,a5,80001f66 <usertrap+0x9e>
  } else if((which_dev = devintr()) != 0){
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	f1c080e7          	jalr	-228(ra) # 80001e22 <devintr>
    80001f0e:	892a                	mv	s2,a0
    80001f10:	e165                	bnez	a0,80001ff0 <usertrap+0x128>
    80001f12:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15){  /*scause 15 is write fault*/
    80001f16:	47bd                	li	a5,15
    80001f18:	0af70063          	beq	a4,a5,80001fb8 <usertrap+0xf0>
    80001f1c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f20:	5890                	lw	a2,48(s1)
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	42e50513          	addi	a0,a0,1070 # 80008350 <states.0+0xa0>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	ed6080e7          	jalr	-298(ra) # 80005e00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f32:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f36:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f3a:	00006517          	auipc	a0,0x6
    80001f3e:	44650513          	addi	a0,a0,1094 # 80008380 <states.0+0xd0>
    80001f42:	00004097          	auipc	ra,0x4
    80001f46:	ebe080e7          	jalr	-322(ra) # 80005e00 <printf>
    setkilled(p);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	00000097          	auipc	ra,0x0
    80001f50:	a68080e7          	jalr	-1432(ra) # 800019b4 <setkilled>
    80001f54:	a825                	j	80001f8c <usertrap+0xc4>
    panic("usertrap: not from user mode");
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	3b250513          	addi	a0,a0,946 # 80008308 <states.0+0x58>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	e58080e7          	jalr	-424(ra) # 80005db6 <panic>
    if(killed(p))
    80001f66:	00000097          	auipc	ra,0x0
    80001f6a:	a7a080e7          	jalr	-1414(ra) # 800019e0 <killed>
    80001f6e:	ed1d                	bnez	a0,80001fac <usertrap+0xe4>
    p->trapframe->epc += 4;
    80001f70:	6cb8                	ld	a4,88(s1)
    80001f72:	6f1c                	ld	a5,24(a4)
    80001f74:	0791                	addi	a5,a5,4
    80001f76:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f7c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f80:	10079073          	csrw	sstatus,a5
    syscall();
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	2e0080e7          	jalr	736(ra) # 80002264 <syscall>
  if(killed(p))
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	a52080e7          	jalr	-1454(ra) # 800019e0 <killed>
    80001f96:	e525                	bnez	a0,80001ffe <usertrap+0x136>
  usertrapret();
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	dae080e7          	jalr	-594(ra) # 80001d46 <usertrapret>
}
    80001fa0:	60e2                	ld	ra,24(sp)
    80001fa2:	6442                	ld	s0,16(sp)
    80001fa4:	64a2                	ld	s1,8(sp)
    80001fa6:	6902                	ld	s2,0(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret
      exit(-1);
    80001fac:	557d                	li	a0,-1
    80001fae:	00000097          	auipc	ra,0x0
    80001fb2:	8be080e7          	jalr	-1858(ra) # 8000186c <exit>
    80001fb6:	bf6d                	j	80001f70 <usertrap+0xa8>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb8:	14302973          	csrr	s2,stval
      if(is_cow_fault(p->pagetable, stval) == 0){
    80001fbc:	85ca                	mv	a1,s2
    80001fbe:	68a8                	ld	a0,80(s1)
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	d90080e7          	jalr	-624(ra) # 80000d50 <is_cow_fault>
    80001fc8:	f931                	bnez	a0,80001f1c <usertrap+0x54>
        if(handle_cow_fault(p->pagetable, stval) < 0){
    80001fca:	85ca                	mv	a1,s2
    80001fcc:	68a8                	ld	a0,80(s1)
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	dc0080e7          	jalr	-576(ra) # 80000d8e <handle_cow_fault>
    80001fd6:	fa055be3          	bgez	a0,80001f8c <usertrap+0xc4>
          printf("usertrap(): copy and write failed!\n");
    80001fda:	00006517          	auipc	a0,0x6
    80001fde:	34e50513          	addi	a0,a0,846 # 80008328 <states.0+0x78>
    80001fe2:	00004097          	auipc	ra,0x4
    80001fe6:	e1e080e7          	jalr	-482(ra) # 80005e00 <printf>
          p->killed = 1;
    80001fea:	4785                	li	a5,1
    80001fec:	d49c                	sw	a5,40(s1)
    80001fee:	bf79                	j	80001f8c <usertrap+0xc4>
  if(killed(p))
    80001ff0:	8526                	mv	a0,s1
    80001ff2:	00000097          	auipc	ra,0x0
    80001ff6:	9ee080e7          	jalr	-1554(ra) # 800019e0 <killed>
    80001ffa:	c901                	beqz	a0,8000200a <usertrap+0x142>
    80001ffc:	a011                	j	80002000 <usertrap+0x138>
    80001ffe:	4901                	li	s2,0
    exit(-1);
    80002000:	557d                	li	a0,-1
    80002002:	00000097          	auipc	ra,0x0
    80002006:	86a080e7          	jalr	-1942(ra) # 8000186c <exit>
  if(which_dev == 2)
    8000200a:	4789                	li	a5,2
    8000200c:	f8f916e3          	bne	s2,a5,80001f98 <usertrap+0xd0>
    yield();
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	6ec080e7          	jalr	1772(ra) # 800016fc <yield>
    80002018:	b741                	j	80001f98 <usertrap+0xd0>

000000008000201a <kerneltrap>:
{
    8000201a:	7179                	addi	sp,sp,-48
    8000201c:	f406                	sd	ra,40(sp)
    8000201e:	f022                	sd	s0,32(sp)
    80002020:	ec26                	sd	s1,24(sp)
    80002022:	e84a                	sd	s2,16(sp)
    80002024:	e44e                	sd	s3,8(sp)
    80002026:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002028:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000202c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002030:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002034:	1004f793          	andi	a5,s1,256
    80002038:	cb85                	beqz	a5,80002068 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000203e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002040:	ef85                	bnez	a5,80002078 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002042:	00000097          	auipc	ra,0x0
    80002046:	de0080e7          	jalr	-544(ra) # 80001e22 <devintr>
    8000204a:	cd1d                	beqz	a0,80002088 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000204c:	4789                	li	a5,2
    8000204e:	06f50a63          	beq	a0,a5,800020c2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002052:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002056:	10049073          	csrw	sstatus,s1
}
    8000205a:	70a2                	ld	ra,40(sp)
    8000205c:	7402                	ld	s0,32(sp)
    8000205e:	64e2                	ld	s1,24(sp)
    80002060:	6942                	ld	s2,16(sp)
    80002062:	69a2                	ld	s3,8(sp)
    80002064:	6145                	addi	sp,sp,48
    80002066:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	33850513          	addi	a0,a0,824 # 800083a0 <states.0+0xf0>
    80002070:	00004097          	auipc	ra,0x4
    80002074:	d46080e7          	jalr	-698(ra) # 80005db6 <panic>
    panic("kerneltrap: interrupts enabled");
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	35050513          	addi	a0,a0,848 # 800083c8 <states.0+0x118>
    80002080:	00004097          	auipc	ra,0x4
    80002084:	d36080e7          	jalr	-714(ra) # 80005db6 <panic>
    printf("scause %p\n", scause);
    80002088:	85ce                	mv	a1,s3
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	35e50513          	addi	a0,a0,862 # 800083e8 <states.0+0x138>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	d6e080e7          	jalr	-658(ra) # 80005e00 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000209a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000209e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020a2:	00006517          	auipc	a0,0x6
    800020a6:	35650513          	addi	a0,a0,854 # 800083f8 <states.0+0x148>
    800020aa:	00004097          	auipc	ra,0x4
    800020ae:	d56080e7          	jalr	-682(ra) # 80005e00 <printf>
    panic("kerneltrap");
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	35e50513          	addi	a0,a0,862 # 80008410 <states.0+0x160>
    800020ba:	00004097          	auipc	ra,0x4
    800020be:	cfc080e7          	jalr	-772(ra) # 80005db6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	fce080e7          	jalr	-50(ra) # 80001090 <myproc>
    800020ca:	d541                	beqz	a0,80002052 <kerneltrap+0x38>
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	fc4080e7          	jalr	-60(ra) # 80001090 <myproc>
    800020d4:	4d18                	lw	a4,24(a0)
    800020d6:	4791                	li	a5,4
    800020d8:	f6f71de3          	bne	a4,a5,80002052 <kerneltrap+0x38>
    yield();
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	620080e7          	jalr	1568(ra) # 800016fc <yield>
    800020e4:	b7bd                	j	80002052 <kerneltrap+0x38>

00000000800020e6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020e6:	1101                	addi	sp,sp,-32
    800020e8:	ec06                	sd	ra,24(sp)
    800020ea:	e822                	sd	s0,16(sp)
    800020ec:	e426                	sd	s1,8(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020f2:	fffff097          	auipc	ra,0xfffff
    800020f6:	f9e080e7          	jalr	-98(ra) # 80001090 <myproc>
  switch (n) {
    800020fa:	4795                	li	a5,5
    800020fc:	0497e163          	bltu	a5,s1,8000213e <argraw+0x58>
    80002100:	048a                	slli	s1,s1,0x2
    80002102:	00006717          	auipc	a4,0x6
    80002106:	34670713          	addi	a4,a4,838 # 80008448 <states.0+0x198>
    8000210a:	94ba                	add	s1,s1,a4
    8000210c:	409c                	lw	a5,0(s1)
    8000210e:	97ba                	add	a5,a5,a4
    80002110:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002112:	6d3c                	ld	a5,88(a0)
    80002114:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret
    return p->trapframe->a1;
    80002120:	6d3c                	ld	a5,88(a0)
    80002122:	7fa8                	ld	a0,120(a5)
    80002124:	bfcd                	j	80002116 <argraw+0x30>
    return p->trapframe->a2;
    80002126:	6d3c                	ld	a5,88(a0)
    80002128:	63c8                	ld	a0,128(a5)
    8000212a:	b7f5                	j	80002116 <argraw+0x30>
    return p->trapframe->a3;
    8000212c:	6d3c                	ld	a5,88(a0)
    8000212e:	67c8                	ld	a0,136(a5)
    80002130:	b7dd                	j	80002116 <argraw+0x30>
    return p->trapframe->a4;
    80002132:	6d3c                	ld	a5,88(a0)
    80002134:	6bc8                	ld	a0,144(a5)
    80002136:	b7c5                	j	80002116 <argraw+0x30>
    return p->trapframe->a5;
    80002138:	6d3c                	ld	a5,88(a0)
    8000213a:	6fc8                	ld	a0,152(a5)
    8000213c:	bfe9                	j	80002116 <argraw+0x30>
  panic("argraw");
    8000213e:	00006517          	auipc	a0,0x6
    80002142:	2e250513          	addi	a0,a0,738 # 80008420 <states.0+0x170>
    80002146:	00004097          	auipc	ra,0x4
    8000214a:	c70080e7          	jalr	-912(ra) # 80005db6 <panic>

000000008000214e <fetchaddr>:
{
    8000214e:	1101                	addi	sp,sp,-32
    80002150:	ec06                	sd	ra,24(sp)
    80002152:	e822                	sd	s0,16(sp)
    80002154:	e426                	sd	s1,8(sp)
    80002156:	e04a                	sd	s2,0(sp)
    80002158:	1000                	addi	s0,sp,32
    8000215a:	84aa                	mv	s1,a0
    8000215c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	f32080e7          	jalr	-206(ra) # 80001090 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002166:	653c                	ld	a5,72(a0)
    80002168:	02f4f863          	bgeu	s1,a5,80002198 <fetchaddr+0x4a>
    8000216c:	00848713          	addi	a4,s1,8
    80002170:	02e7e663          	bltu	a5,a4,8000219c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002174:	46a1                	li	a3,8
    80002176:	8626                	mv	a2,s1
    80002178:	85ca                	mv	a1,s2
    8000217a:	6928                	ld	a0,80(a0)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	a96080e7          	jalr	-1386(ra) # 80000c12 <copyin>
    80002184:	00a03533          	snez	a0,a0
    80002188:	40a00533          	neg	a0,a0
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	64a2                	ld	s1,8(sp)
    80002192:	6902                	ld	s2,0(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret
    return -1;
    80002198:	557d                	li	a0,-1
    8000219a:	bfcd                	j	8000218c <fetchaddr+0x3e>
    8000219c:	557d                	li	a0,-1
    8000219e:	b7fd                	j	8000218c <fetchaddr+0x3e>

00000000800021a0 <fetchstr>:
{
    800021a0:	7179                	addi	sp,sp,-48
    800021a2:	f406                	sd	ra,40(sp)
    800021a4:	f022                	sd	s0,32(sp)
    800021a6:	ec26                	sd	s1,24(sp)
    800021a8:	e84a                	sd	s2,16(sp)
    800021aa:	e44e                	sd	s3,8(sp)
    800021ac:	1800                	addi	s0,sp,48
    800021ae:	892a                	mv	s2,a0
    800021b0:	84ae                	mv	s1,a1
    800021b2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	edc080e7          	jalr	-292(ra) # 80001090 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800021bc:	86ce                	mv	a3,s3
    800021be:	864a                	mv	a2,s2
    800021c0:	85a6                	mv	a1,s1
    800021c2:	6928                	ld	a0,80(a0)
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	adc080e7          	jalr	-1316(ra) # 80000ca0 <copyinstr>
    800021cc:	00054e63          	bltz	a0,800021e8 <fetchstr+0x48>
  return strlen(buf);
    800021d0:	8526                	mv	a0,s1
    800021d2:	ffffe097          	auipc	ra,0xffffe
    800021d6:	22c080e7          	jalr	556(ra) # 800003fe <strlen>
}
    800021da:	70a2                	ld	ra,40(sp)
    800021dc:	7402                	ld	s0,32(sp)
    800021de:	64e2                	ld	s1,24(sp)
    800021e0:	6942                	ld	s2,16(sp)
    800021e2:	69a2                	ld	s3,8(sp)
    800021e4:	6145                	addi	sp,sp,48
    800021e6:	8082                	ret
    return -1;
    800021e8:	557d                	li	a0,-1
    800021ea:	bfc5                	j	800021da <fetchstr+0x3a>

00000000800021ec <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	1000                	addi	s0,sp,32
    800021f6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	eee080e7          	jalr	-274(ra) # 800020e6 <argraw>
    80002200:	c088                	sw	a0,0(s1)
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret

000000008000220c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	1000                	addi	s0,sp,32
    80002216:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	ece080e7          	jalr	-306(ra) # 800020e6 <argraw>
    80002220:	e088                	sd	a0,0(s1)
}
    80002222:	60e2                	ld	ra,24(sp)
    80002224:	6442                	ld	s0,16(sp)
    80002226:	64a2                	ld	s1,8(sp)
    80002228:	6105                	addi	sp,sp,32
    8000222a:	8082                	ret

000000008000222c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000222c:	7179                	addi	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	1800                	addi	s0,sp,48
    80002238:	84ae                	mv	s1,a1
    8000223a:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000223c:	fd840593          	addi	a1,s0,-40
    80002240:	00000097          	auipc	ra,0x0
    80002244:	fcc080e7          	jalr	-52(ra) # 8000220c <argaddr>
  return fetchstr(addr, buf, max);
    80002248:	864a                	mv	a2,s2
    8000224a:	85a6                	mv	a1,s1
    8000224c:	fd843503          	ld	a0,-40(s0)
    80002250:	00000097          	auipc	ra,0x0
    80002254:	f50080e7          	jalr	-176(ra) # 800021a0 <fetchstr>
}
    80002258:	70a2                	ld	ra,40(sp)
    8000225a:	7402                	ld	s0,32(sp)
    8000225c:	64e2                	ld	s1,24(sp)
    8000225e:	6942                	ld	s2,16(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret

0000000080002264 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	e04a                	sd	s2,0(sp)
    8000226e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	e20080e7          	jalr	-480(ra) # 80001090 <myproc>
    80002278:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000227a:	05853903          	ld	s2,88(a0)
    8000227e:	0a893783          	ld	a5,168(s2)
    80002282:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002286:	37fd                	addiw	a5,a5,-1
    80002288:	4751                	li	a4,20
    8000228a:	00f76f63          	bltu	a4,a5,800022a8 <syscall+0x44>
    8000228e:	00369713          	slli	a4,a3,0x3
    80002292:	00006797          	auipc	a5,0x6
    80002296:	1ce78793          	addi	a5,a5,462 # 80008460 <syscalls>
    8000229a:	97ba                	add	a5,a5,a4
    8000229c:	639c                	ld	a5,0(a5)
    8000229e:	c789                	beqz	a5,800022a8 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800022a0:	9782                	jalr	a5
    800022a2:	06a93823          	sd	a0,112(s2)
    800022a6:	a839                	j	800022c4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022a8:	15848613          	addi	a2,s1,344
    800022ac:	588c                	lw	a1,48(s1)
    800022ae:	00006517          	auipc	a0,0x6
    800022b2:	17a50513          	addi	a0,a0,378 # 80008428 <states.0+0x178>
    800022b6:	00004097          	auipc	ra,0x4
    800022ba:	b4a080e7          	jalr	-1206(ra) # 80005e00 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022be:	6cbc                	ld	a5,88(s1)
    800022c0:	577d                	li	a4,-1
    800022c2:	fbb8                	sd	a4,112(a5)
  }
}
    800022c4:	60e2                	ld	ra,24(sp)
    800022c6:	6442                	ld	s0,16(sp)
    800022c8:	64a2                	ld	s1,8(sp)
    800022ca:	6902                	ld	s2,0(sp)
    800022cc:	6105                	addi	sp,sp,32
    800022ce:	8082                	ret

00000000800022d0 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022d0:	1101                	addi	sp,sp,-32
    800022d2:	ec06                	sd	ra,24(sp)
    800022d4:	e822                	sd	s0,16(sp)
    800022d6:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800022d8:	fec40593          	addi	a1,s0,-20
    800022dc:	4501                	li	a0,0
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	f0e080e7          	jalr	-242(ra) # 800021ec <argint>
  exit(n);
    800022e6:	fec42503          	lw	a0,-20(s0)
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	582080e7          	jalr	1410(ra) # 8000186c <exit>
  return 0;  // not reached
}
    800022f2:	4501                	li	a0,0
    800022f4:	60e2                	ld	ra,24(sp)
    800022f6:	6442                	ld	s0,16(sp)
    800022f8:	6105                	addi	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <sys_getpid>:

uint64
sys_getpid(void)
{
    800022fc:	1141                	addi	sp,sp,-16
    800022fe:	e406                	sd	ra,8(sp)
    80002300:	e022                	sd	s0,0(sp)
    80002302:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	d8c080e7          	jalr	-628(ra) # 80001090 <myproc>
}
    8000230c:	5908                	lw	a0,48(a0)
    8000230e:	60a2                	ld	ra,8(sp)
    80002310:	6402                	ld	s0,0(sp)
    80002312:	0141                	addi	sp,sp,16
    80002314:	8082                	ret

0000000080002316 <sys_fork>:

uint64
sys_fork(void)
{
    80002316:	1141                	addi	sp,sp,-16
    80002318:	e406                	sd	ra,8(sp)
    8000231a:	e022                	sd	s0,0(sp)
    8000231c:	0800                	addi	s0,sp,16
  return fork();
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	128080e7          	jalr	296(ra) # 80001446 <fork>
}
    80002326:	60a2                	ld	ra,8(sp)
    80002328:	6402                	ld	s0,0(sp)
    8000232a:	0141                	addi	sp,sp,16
    8000232c:	8082                	ret

000000008000232e <sys_wait>:

uint64
sys_wait(void)
{
    8000232e:	1101                	addi	sp,sp,-32
    80002330:	ec06                	sd	ra,24(sp)
    80002332:	e822                	sd	s0,16(sp)
    80002334:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002336:	fe840593          	addi	a1,s0,-24
    8000233a:	4501                	li	a0,0
    8000233c:	00000097          	auipc	ra,0x0
    80002340:	ed0080e7          	jalr	-304(ra) # 8000220c <argaddr>
  return wait(p);
    80002344:	fe843503          	ld	a0,-24(s0)
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	6ca080e7          	jalr	1738(ra) # 80001a12 <wait>
}
    80002350:	60e2                	ld	ra,24(sp)
    80002352:	6442                	ld	s0,16(sp)
    80002354:	6105                	addi	sp,sp,32
    80002356:	8082                	ret

0000000080002358 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002358:	7179                	addi	sp,sp,-48
    8000235a:	f406                	sd	ra,40(sp)
    8000235c:	f022                	sd	s0,32(sp)
    8000235e:	ec26                	sd	s1,24(sp)
    80002360:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002362:	fdc40593          	addi	a1,s0,-36
    80002366:	4501                	li	a0,0
    80002368:	00000097          	auipc	ra,0x0
    8000236c:	e84080e7          	jalr	-380(ra) # 800021ec <argint>
  addr = myproc()->sz;
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	d20080e7          	jalr	-736(ra) # 80001090 <myproc>
    80002378:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000237a:	fdc42503          	lw	a0,-36(s0)
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	06c080e7          	jalr	108(ra) # 800013ea <growproc>
    80002386:	00054863          	bltz	a0,80002396 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000238a:	8526                	mv	a0,s1
    8000238c:	70a2                	ld	ra,40(sp)
    8000238e:	7402                	ld	s0,32(sp)
    80002390:	64e2                	ld	s1,24(sp)
    80002392:	6145                	addi	sp,sp,48
    80002394:	8082                	ret
    return -1;
    80002396:	54fd                	li	s1,-1
    80002398:	bfcd                	j	8000238a <sys_sbrk+0x32>

000000008000239a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000239a:	7139                	addi	sp,sp,-64
    8000239c:	fc06                	sd	ra,56(sp)
    8000239e:	f822                	sd	s0,48(sp)
    800023a0:	f426                	sd	s1,40(sp)
    800023a2:	f04a                	sd	s2,32(sp)
    800023a4:	ec4e                	sd	s3,24(sp)
    800023a6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800023a8:	fcc40593          	addi	a1,s0,-52
    800023ac:	4501                	li	a0,0
    800023ae:	00000097          	auipc	ra,0x0
    800023b2:	e3e080e7          	jalr	-450(ra) # 800021ec <argint>
  if(n < 0)
    800023b6:	fcc42783          	lw	a5,-52(s0)
    800023ba:	0607cf63          	bltz	a5,80002438 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800023be:	0002c517          	auipc	a0,0x2c
    800023c2:	41a50513          	addi	a0,a0,1050 # 8002e7d8 <tickslock>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	f28080e7          	jalr	-216(ra) # 800062ee <acquire>
  ticks0 = ticks;
    800023ce:	00006917          	auipc	s2,0x6
    800023d2:	58a92903          	lw	s2,1418(s2) # 80008958 <ticks>
  while(ticks - ticks0 < n){
    800023d6:	fcc42783          	lw	a5,-52(s0)
    800023da:	cf9d                	beqz	a5,80002418 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023dc:	0002c997          	auipc	s3,0x2c
    800023e0:	3fc98993          	addi	s3,s3,1020 # 8002e7d8 <tickslock>
    800023e4:	00006497          	auipc	s1,0x6
    800023e8:	57448493          	addi	s1,s1,1396 # 80008958 <ticks>
    if(killed(myproc())){
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	ca4080e7          	jalr	-860(ra) # 80001090 <myproc>
    800023f4:	fffff097          	auipc	ra,0xfffff
    800023f8:	5ec080e7          	jalr	1516(ra) # 800019e0 <killed>
    800023fc:	e129                	bnez	a0,8000243e <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800023fe:	85ce                	mv	a1,s3
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	336080e7          	jalr	822(ra) # 80001738 <sleep>
  while(ticks - ticks0 < n){
    8000240a:	409c                	lw	a5,0(s1)
    8000240c:	412787bb          	subw	a5,a5,s2
    80002410:	fcc42703          	lw	a4,-52(s0)
    80002414:	fce7ece3          	bltu	a5,a4,800023ec <sys_sleep+0x52>
  }
  release(&tickslock);
    80002418:	0002c517          	auipc	a0,0x2c
    8000241c:	3c050513          	addi	a0,a0,960 # 8002e7d8 <tickslock>
    80002420:	00004097          	auipc	ra,0x4
    80002424:	f82080e7          	jalr	-126(ra) # 800063a2 <release>
  return 0;
    80002428:	4501                	li	a0,0
}
    8000242a:	70e2                	ld	ra,56(sp)
    8000242c:	7442                	ld	s0,48(sp)
    8000242e:	74a2                	ld	s1,40(sp)
    80002430:	7902                	ld	s2,32(sp)
    80002432:	69e2                	ld	s3,24(sp)
    80002434:	6121                	addi	sp,sp,64
    80002436:	8082                	ret
    n = 0;
    80002438:	fc042623          	sw	zero,-52(s0)
    8000243c:	b749                	j	800023be <sys_sleep+0x24>
      release(&tickslock);
    8000243e:	0002c517          	auipc	a0,0x2c
    80002442:	39a50513          	addi	a0,a0,922 # 8002e7d8 <tickslock>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	f5c080e7          	jalr	-164(ra) # 800063a2 <release>
      return -1;
    8000244e:	557d                	li	a0,-1
    80002450:	bfe9                	j	8000242a <sys_sleep+0x90>

0000000080002452 <sys_kill>:

uint64
sys_kill(void)
{
    80002452:	1101                	addi	sp,sp,-32
    80002454:	ec06                	sd	ra,24(sp)
    80002456:	e822                	sd	s0,16(sp)
    80002458:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000245a:	fec40593          	addi	a1,s0,-20
    8000245e:	4501                	li	a0,0
    80002460:	00000097          	auipc	ra,0x0
    80002464:	d8c080e7          	jalr	-628(ra) # 800021ec <argint>
  return kill(pid);
    80002468:	fec42503          	lw	a0,-20(s0)
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	4d6080e7          	jalr	1238(ra) # 80001942 <kill>
}
    80002474:	60e2                	ld	ra,24(sp)
    80002476:	6442                	ld	s0,16(sp)
    80002478:	6105                	addi	sp,sp,32
    8000247a:	8082                	ret

000000008000247c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000247c:	1101                	addi	sp,sp,-32
    8000247e:	ec06                	sd	ra,24(sp)
    80002480:	e822                	sd	s0,16(sp)
    80002482:	e426                	sd	s1,8(sp)
    80002484:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002486:	0002c517          	auipc	a0,0x2c
    8000248a:	35250513          	addi	a0,a0,850 # 8002e7d8 <tickslock>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	e60080e7          	jalr	-416(ra) # 800062ee <acquire>
  xticks = ticks;
    80002496:	00006497          	auipc	s1,0x6
    8000249a:	4c24a483          	lw	s1,1218(s1) # 80008958 <ticks>
  release(&tickslock);
    8000249e:	0002c517          	auipc	a0,0x2c
    800024a2:	33a50513          	addi	a0,a0,826 # 8002e7d8 <tickslock>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	efc080e7          	jalr	-260(ra) # 800063a2 <release>
  return xticks;
}
    800024ae:	02049513          	slli	a0,s1,0x20
    800024b2:	9101                	srli	a0,a0,0x20
    800024b4:	60e2                	ld	ra,24(sp)
    800024b6:	6442                	ld	s0,16(sp)
    800024b8:	64a2                	ld	s1,8(sp)
    800024ba:	6105                	addi	sp,sp,32
    800024bc:	8082                	ret

00000000800024be <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024be:	7179                	addi	sp,sp,-48
    800024c0:	f406                	sd	ra,40(sp)
    800024c2:	f022                	sd	s0,32(sp)
    800024c4:	ec26                	sd	s1,24(sp)
    800024c6:	e84a                	sd	s2,16(sp)
    800024c8:	e44e                	sd	s3,8(sp)
    800024ca:	e052                	sd	s4,0(sp)
    800024cc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024ce:	00006597          	auipc	a1,0x6
    800024d2:	04258593          	addi	a1,a1,66 # 80008510 <syscalls+0xb0>
    800024d6:	0002c517          	auipc	a0,0x2c
    800024da:	31a50513          	addi	a0,a0,794 # 8002e7f0 <bcache>
    800024de:	00004097          	auipc	ra,0x4
    800024e2:	d80080e7          	jalr	-640(ra) # 8000625e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024e6:	00034797          	auipc	a5,0x34
    800024ea:	30a78793          	addi	a5,a5,778 # 800367f0 <bcache+0x8000>
    800024ee:	00034717          	auipc	a4,0x34
    800024f2:	56a70713          	addi	a4,a4,1386 # 80036a58 <bcache+0x8268>
    800024f6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024fa:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024fe:	0002c497          	auipc	s1,0x2c
    80002502:	30a48493          	addi	s1,s1,778 # 8002e808 <bcache+0x18>
    b->next = bcache.head.next;
    80002506:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002508:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000250a:	00006a17          	auipc	s4,0x6
    8000250e:	00ea0a13          	addi	s4,s4,14 # 80008518 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002512:	2b893783          	ld	a5,696(s2)
    80002516:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002518:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000251c:	85d2                	mv	a1,s4
    8000251e:	01048513          	addi	a0,s1,16
    80002522:	00001097          	auipc	ra,0x1
    80002526:	496080e7          	jalr	1174(ra) # 800039b8 <initsleeplock>
    bcache.head.next->prev = b;
    8000252a:	2b893783          	ld	a5,696(s2)
    8000252e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002530:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002534:	45848493          	addi	s1,s1,1112
    80002538:	fd349de3          	bne	s1,s3,80002512 <binit+0x54>
  }
}
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6a02                	ld	s4,0(sp)
    80002548:	6145                	addi	sp,sp,48
    8000254a:	8082                	ret

000000008000254c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000254c:	7179                	addi	sp,sp,-48
    8000254e:	f406                	sd	ra,40(sp)
    80002550:	f022                	sd	s0,32(sp)
    80002552:	ec26                	sd	s1,24(sp)
    80002554:	e84a                	sd	s2,16(sp)
    80002556:	e44e                	sd	s3,8(sp)
    80002558:	1800                	addi	s0,sp,48
    8000255a:	892a                	mv	s2,a0
    8000255c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000255e:	0002c517          	auipc	a0,0x2c
    80002562:	29250513          	addi	a0,a0,658 # 8002e7f0 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	d88080e7          	jalr	-632(ra) # 800062ee <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000256e:	00034497          	auipc	s1,0x34
    80002572:	53a4b483          	ld	s1,1338(s1) # 80036aa8 <bcache+0x82b8>
    80002576:	00034797          	auipc	a5,0x34
    8000257a:	4e278793          	addi	a5,a5,1250 # 80036a58 <bcache+0x8268>
    8000257e:	02f48f63          	beq	s1,a5,800025bc <bread+0x70>
    80002582:	873e                	mv	a4,a5
    80002584:	a021                	j	8000258c <bread+0x40>
    80002586:	68a4                	ld	s1,80(s1)
    80002588:	02e48a63          	beq	s1,a4,800025bc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000258c:	449c                	lw	a5,8(s1)
    8000258e:	ff279ce3          	bne	a5,s2,80002586 <bread+0x3a>
    80002592:	44dc                	lw	a5,12(s1)
    80002594:	ff3799e3          	bne	a5,s3,80002586 <bread+0x3a>
      b->refcnt++;
    80002598:	40bc                	lw	a5,64(s1)
    8000259a:	2785                	addiw	a5,a5,1
    8000259c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000259e:	0002c517          	auipc	a0,0x2c
    800025a2:	25250513          	addi	a0,a0,594 # 8002e7f0 <bcache>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	dfc080e7          	jalr	-516(ra) # 800063a2 <release>
      acquiresleep(&b->lock);
    800025ae:	01048513          	addi	a0,s1,16
    800025b2:	00001097          	auipc	ra,0x1
    800025b6:	440080e7          	jalr	1088(ra) # 800039f2 <acquiresleep>
      return b;
    800025ba:	a8b9                	j	80002618 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025bc:	00034497          	auipc	s1,0x34
    800025c0:	4e44b483          	ld	s1,1252(s1) # 80036aa0 <bcache+0x82b0>
    800025c4:	00034797          	auipc	a5,0x34
    800025c8:	49478793          	addi	a5,a5,1172 # 80036a58 <bcache+0x8268>
    800025cc:	00f48863          	beq	s1,a5,800025dc <bread+0x90>
    800025d0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	cf81                	beqz	a5,800025ec <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025d6:	64a4                	ld	s1,72(s1)
    800025d8:	fee49de3          	bne	s1,a4,800025d2 <bread+0x86>
  panic("bget: no buffers");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	f4450513          	addi	a0,a0,-188 # 80008520 <syscalls+0xc0>
    800025e4:	00003097          	auipc	ra,0x3
    800025e8:	7d2080e7          	jalr	2002(ra) # 80005db6 <panic>
      b->dev = dev;
    800025ec:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025f0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025f4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025f8:	4785                	li	a5,1
    800025fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025fc:	0002c517          	auipc	a0,0x2c
    80002600:	1f450513          	addi	a0,a0,500 # 8002e7f0 <bcache>
    80002604:	00004097          	auipc	ra,0x4
    80002608:	d9e080e7          	jalr	-610(ra) # 800063a2 <release>
      acquiresleep(&b->lock);
    8000260c:	01048513          	addi	a0,s1,16
    80002610:	00001097          	auipc	ra,0x1
    80002614:	3e2080e7          	jalr	994(ra) # 800039f2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002618:	409c                	lw	a5,0(s1)
    8000261a:	cb89                	beqz	a5,8000262c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000261c:	8526                	mv	a0,s1
    8000261e:	70a2                	ld	ra,40(sp)
    80002620:	7402                	ld	s0,32(sp)
    80002622:	64e2                	ld	s1,24(sp)
    80002624:	6942                	ld	s2,16(sp)
    80002626:	69a2                	ld	s3,8(sp)
    80002628:	6145                	addi	sp,sp,48
    8000262a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000262c:	4581                	li	a1,0
    8000262e:	8526                	mv	a0,s1
    80002630:	00003097          	auipc	ra,0x3
    80002634:	f82080e7          	jalr	-126(ra) # 800055b2 <virtio_disk_rw>
    b->valid = 1;
    80002638:	4785                	li	a5,1
    8000263a:	c09c                	sw	a5,0(s1)
  return b;
    8000263c:	b7c5                	j	8000261c <bread+0xd0>

000000008000263e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000263e:	1101                	addi	sp,sp,-32
    80002640:	ec06                	sd	ra,24(sp)
    80002642:	e822                	sd	s0,16(sp)
    80002644:	e426                	sd	s1,8(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000264a:	0541                	addi	a0,a0,16
    8000264c:	00001097          	auipc	ra,0x1
    80002650:	440080e7          	jalr	1088(ra) # 80003a8c <holdingsleep>
    80002654:	cd01                	beqz	a0,8000266c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002656:	4585                	li	a1,1
    80002658:	8526                	mv	a0,s1
    8000265a:	00003097          	auipc	ra,0x3
    8000265e:	f58080e7          	jalr	-168(ra) # 800055b2 <virtio_disk_rw>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6105                	addi	sp,sp,32
    8000266a:	8082                	ret
    panic("bwrite");
    8000266c:	00006517          	auipc	a0,0x6
    80002670:	ecc50513          	addi	a0,a0,-308 # 80008538 <syscalls+0xd8>
    80002674:	00003097          	auipc	ra,0x3
    80002678:	742080e7          	jalr	1858(ra) # 80005db6 <panic>

000000008000267c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000267c:	1101                	addi	sp,sp,-32
    8000267e:	ec06                	sd	ra,24(sp)
    80002680:	e822                	sd	s0,16(sp)
    80002682:	e426                	sd	s1,8(sp)
    80002684:	e04a                	sd	s2,0(sp)
    80002686:	1000                	addi	s0,sp,32
    80002688:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000268a:	01050913          	addi	s2,a0,16
    8000268e:	854a                	mv	a0,s2
    80002690:	00001097          	auipc	ra,0x1
    80002694:	3fc080e7          	jalr	1020(ra) # 80003a8c <holdingsleep>
    80002698:	c925                	beqz	a0,80002708 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000269a:	854a                	mv	a0,s2
    8000269c:	00001097          	auipc	ra,0x1
    800026a0:	3ac080e7          	jalr	940(ra) # 80003a48 <releasesleep>

  acquire(&bcache.lock);
    800026a4:	0002c517          	auipc	a0,0x2c
    800026a8:	14c50513          	addi	a0,a0,332 # 8002e7f0 <bcache>
    800026ac:	00004097          	auipc	ra,0x4
    800026b0:	c42080e7          	jalr	-958(ra) # 800062ee <acquire>
  b->refcnt--;
    800026b4:	40bc                	lw	a5,64(s1)
    800026b6:	37fd                	addiw	a5,a5,-1
    800026b8:	0007871b          	sext.w	a4,a5
    800026bc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026be:	e71d                	bnez	a4,800026ec <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026c0:	68b8                	ld	a4,80(s1)
    800026c2:	64bc                	ld	a5,72(s1)
    800026c4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026c6:	68b8                	ld	a4,80(s1)
    800026c8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026ca:	00034797          	auipc	a5,0x34
    800026ce:	12678793          	addi	a5,a5,294 # 800367f0 <bcache+0x8000>
    800026d2:	2b87b703          	ld	a4,696(a5)
    800026d6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026d8:	00034717          	auipc	a4,0x34
    800026dc:	38070713          	addi	a4,a4,896 # 80036a58 <bcache+0x8268>
    800026e0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026e2:	2b87b703          	ld	a4,696(a5)
    800026e6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026e8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ec:	0002c517          	auipc	a0,0x2c
    800026f0:	10450513          	addi	a0,a0,260 # 8002e7f0 <bcache>
    800026f4:	00004097          	auipc	ra,0x4
    800026f8:	cae080e7          	jalr	-850(ra) # 800063a2 <release>
}
    800026fc:	60e2                	ld	ra,24(sp)
    800026fe:	6442                	ld	s0,16(sp)
    80002700:	64a2                	ld	s1,8(sp)
    80002702:	6902                	ld	s2,0(sp)
    80002704:	6105                	addi	sp,sp,32
    80002706:	8082                	ret
    panic("brelse");
    80002708:	00006517          	auipc	a0,0x6
    8000270c:	e3850513          	addi	a0,a0,-456 # 80008540 <syscalls+0xe0>
    80002710:	00003097          	auipc	ra,0x3
    80002714:	6a6080e7          	jalr	1702(ra) # 80005db6 <panic>

0000000080002718 <bpin>:

void
bpin(struct buf *b) {
    80002718:	1101                	addi	sp,sp,-32
    8000271a:	ec06                	sd	ra,24(sp)
    8000271c:	e822                	sd	s0,16(sp)
    8000271e:	e426                	sd	s1,8(sp)
    80002720:	1000                	addi	s0,sp,32
    80002722:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002724:	0002c517          	auipc	a0,0x2c
    80002728:	0cc50513          	addi	a0,a0,204 # 8002e7f0 <bcache>
    8000272c:	00004097          	auipc	ra,0x4
    80002730:	bc2080e7          	jalr	-1086(ra) # 800062ee <acquire>
  b->refcnt++;
    80002734:	40bc                	lw	a5,64(s1)
    80002736:	2785                	addiw	a5,a5,1
    80002738:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000273a:	0002c517          	auipc	a0,0x2c
    8000273e:	0b650513          	addi	a0,a0,182 # 8002e7f0 <bcache>
    80002742:	00004097          	auipc	ra,0x4
    80002746:	c60080e7          	jalr	-928(ra) # 800063a2 <release>
}
    8000274a:	60e2                	ld	ra,24(sp)
    8000274c:	6442                	ld	s0,16(sp)
    8000274e:	64a2                	ld	s1,8(sp)
    80002750:	6105                	addi	sp,sp,32
    80002752:	8082                	ret

0000000080002754 <bunpin>:

void
bunpin(struct buf *b) {
    80002754:	1101                	addi	sp,sp,-32
    80002756:	ec06                	sd	ra,24(sp)
    80002758:	e822                	sd	s0,16(sp)
    8000275a:	e426                	sd	s1,8(sp)
    8000275c:	1000                	addi	s0,sp,32
    8000275e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002760:	0002c517          	auipc	a0,0x2c
    80002764:	09050513          	addi	a0,a0,144 # 8002e7f0 <bcache>
    80002768:	00004097          	auipc	ra,0x4
    8000276c:	b86080e7          	jalr	-1146(ra) # 800062ee <acquire>
  b->refcnt--;
    80002770:	40bc                	lw	a5,64(s1)
    80002772:	37fd                	addiw	a5,a5,-1
    80002774:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002776:	0002c517          	auipc	a0,0x2c
    8000277a:	07a50513          	addi	a0,a0,122 # 8002e7f0 <bcache>
    8000277e:	00004097          	auipc	ra,0x4
    80002782:	c24080e7          	jalr	-988(ra) # 800063a2 <release>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret

0000000080002790 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002790:	1101                	addi	sp,sp,-32
    80002792:	ec06                	sd	ra,24(sp)
    80002794:	e822                	sd	s0,16(sp)
    80002796:	e426                	sd	s1,8(sp)
    80002798:	e04a                	sd	s2,0(sp)
    8000279a:	1000                	addi	s0,sp,32
    8000279c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000279e:	00d5d59b          	srliw	a1,a1,0xd
    800027a2:	00034797          	auipc	a5,0x34
    800027a6:	72a7a783          	lw	a5,1834(a5) # 80036ecc <sb+0x1c>
    800027aa:	9dbd                	addw	a1,a1,a5
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	da0080e7          	jalr	-608(ra) # 8000254c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027b4:	0074f713          	andi	a4,s1,7
    800027b8:	4785                	li	a5,1
    800027ba:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027be:	14ce                	slli	s1,s1,0x33
    800027c0:	90d9                	srli	s1,s1,0x36
    800027c2:	00950733          	add	a4,a0,s1
    800027c6:	05874703          	lbu	a4,88(a4)
    800027ca:	00e7f6b3          	and	a3,a5,a4
    800027ce:	c69d                	beqz	a3,800027fc <bfree+0x6c>
    800027d0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027d2:	94aa                	add	s1,s1,a0
    800027d4:	fff7c793          	not	a5,a5
    800027d8:	8f7d                	and	a4,a4,a5
    800027da:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027de:	00001097          	auipc	ra,0x1
    800027e2:	0f6080e7          	jalr	246(ra) # 800038d4 <log_write>
  brelse(bp);
    800027e6:	854a                	mv	a0,s2
    800027e8:	00000097          	auipc	ra,0x0
    800027ec:	e94080e7          	jalr	-364(ra) # 8000267c <brelse>
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6902                	ld	s2,0(sp)
    800027f8:	6105                	addi	sp,sp,32
    800027fa:	8082                	ret
    panic("freeing free block");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	d4c50513          	addi	a0,a0,-692 # 80008548 <syscalls+0xe8>
    80002804:	00003097          	auipc	ra,0x3
    80002808:	5b2080e7          	jalr	1458(ra) # 80005db6 <panic>

000000008000280c <balloc>:
{
    8000280c:	711d                	addi	sp,sp,-96
    8000280e:	ec86                	sd	ra,88(sp)
    80002810:	e8a2                	sd	s0,80(sp)
    80002812:	e4a6                	sd	s1,72(sp)
    80002814:	e0ca                	sd	s2,64(sp)
    80002816:	fc4e                	sd	s3,56(sp)
    80002818:	f852                	sd	s4,48(sp)
    8000281a:	f456                	sd	s5,40(sp)
    8000281c:	f05a                	sd	s6,32(sp)
    8000281e:	ec5e                	sd	s7,24(sp)
    80002820:	e862                	sd	s8,16(sp)
    80002822:	e466                	sd	s9,8(sp)
    80002824:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002826:	00034797          	auipc	a5,0x34
    8000282a:	68e7a783          	lw	a5,1678(a5) # 80036eb4 <sb+0x4>
    8000282e:	cff5                	beqz	a5,8000292a <balloc+0x11e>
    80002830:	8baa                	mv	s7,a0
    80002832:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002834:	00034b17          	auipc	s6,0x34
    80002838:	67cb0b13          	addi	s6,s6,1660 # 80036eb0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000283c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000283e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002842:	6c89                	lui	s9,0x2
    80002844:	a061                	j	800028cc <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002846:	97ca                	add	a5,a5,s2
    80002848:	8e55                	or	a2,a2,a3
    8000284a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000284e:	854a                	mv	a0,s2
    80002850:	00001097          	auipc	ra,0x1
    80002854:	084080e7          	jalr	132(ra) # 800038d4 <log_write>
        brelse(bp);
    80002858:	854a                	mv	a0,s2
    8000285a:	00000097          	auipc	ra,0x0
    8000285e:	e22080e7          	jalr	-478(ra) # 8000267c <brelse>
  bp = bread(dev, bno);
    80002862:	85a6                	mv	a1,s1
    80002864:	855e                	mv	a0,s7
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	ce6080e7          	jalr	-794(ra) # 8000254c <bread>
    8000286e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002870:	40000613          	li	a2,1024
    80002874:	4581                	li	a1,0
    80002876:	05850513          	addi	a0,a0,88
    8000287a:	ffffe097          	auipc	ra,0xffffe
    8000287e:	a0a080e7          	jalr	-1526(ra) # 80000284 <memset>
  log_write(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00001097          	auipc	ra,0x1
    80002888:	050080e7          	jalr	80(ra) # 800038d4 <log_write>
  brelse(bp);
    8000288c:	854a                	mv	a0,s2
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	dee080e7          	jalr	-530(ra) # 8000267c <brelse>
}
    80002896:	8526                	mv	a0,s1
    80002898:	60e6                	ld	ra,88(sp)
    8000289a:	6446                	ld	s0,80(sp)
    8000289c:	64a6                	ld	s1,72(sp)
    8000289e:	6906                	ld	s2,64(sp)
    800028a0:	79e2                	ld	s3,56(sp)
    800028a2:	7a42                	ld	s4,48(sp)
    800028a4:	7aa2                	ld	s5,40(sp)
    800028a6:	7b02                	ld	s6,32(sp)
    800028a8:	6be2                	ld	s7,24(sp)
    800028aa:	6c42                	ld	s8,16(sp)
    800028ac:	6ca2                	ld	s9,8(sp)
    800028ae:	6125                	addi	sp,sp,96
    800028b0:	8082                	ret
    brelse(bp);
    800028b2:	854a                	mv	a0,s2
    800028b4:	00000097          	auipc	ra,0x0
    800028b8:	dc8080e7          	jalr	-568(ra) # 8000267c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028bc:	015c87bb          	addw	a5,s9,s5
    800028c0:	00078a9b          	sext.w	s5,a5
    800028c4:	004b2703          	lw	a4,4(s6)
    800028c8:	06eaf163          	bgeu	s5,a4,8000292a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800028cc:	41fad79b          	sraiw	a5,s5,0x1f
    800028d0:	0137d79b          	srliw	a5,a5,0x13
    800028d4:	015787bb          	addw	a5,a5,s5
    800028d8:	40d7d79b          	sraiw	a5,a5,0xd
    800028dc:	01cb2583          	lw	a1,28(s6)
    800028e0:	9dbd                	addw	a1,a1,a5
    800028e2:	855e                	mv	a0,s7
    800028e4:	00000097          	auipc	ra,0x0
    800028e8:	c68080e7          	jalr	-920(ra) # 8000254c <bread>
    800028ec:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ee:	004b2503          	lw	a0,4(s6)
    800028f2:	000a849b          	sext.w	s1,s5
    800028f6:	8762                	mv	a4,s8
    800028f8:	faa4fde3          	bgeu	s1,a0,800028b2 <balloc+0xa6>
      m = 1 << (bi % 8);
    800028fc:	00777693          	andi	a3,a4,7
    80002900:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002904:	41f7579b          	sraiw	a5,a4,0x1f
    80002908:	01d7d79b          	srliw	a5,a5,0x1d
    8000290c:	9fb9                	addw	a5,a5,a4
    8000290e:	4037d79b          	sraiw	a5,a5,0x3
    80002912:	00f90633          	add	a2,s2,a5
    80002916:	05864603          	lbu	a2,88(a2)
    8000291a:	00c6f5b3          	and	a1,a3,a2
    8000291e:	d585                	beqz	a1,80002846 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002920:	2705                	addiw	a4,a4,1
    80002922:	2485                	addiw	s1,s1,1
    80002924:	fd471ae3          	bne	a4,s4,800028f8 <balloc+0xec>
    80002928:	b769                	j	800028b2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	c3650513          	addi	a0,a0,-970 # 80008560 <syscalls+0x100>
    80002932:	00003097          	auipc	ra,0x3
    80002936:	4ce080e7          	jalr	1230(ra) # 80005e00 <printf>
  return 0;
    8000293a:	4481                	li	s1,0
    8000293c:	bfa9                	j	80002896 <balloc+0x8a>

000000008000293e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000293e:	7179                	addi	sp,sp,-48
    80002940:	f406                	sd	ra,40(sp)
    80002942:	f022                	sd	s0,32(sp)
    80002944:	ec26                	sd	s1,24(sp)
    80002946:	e84a                	sd	s2,16(sp)
    80002948:	e44e                	sd	s3,8(sp)
    8000294a:	e052                	sd	s4,0(sp)
    8000294c:	1800                	addi	s0,sp,48
    8000294e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002950:	47ad                	li	a5,11
    80002952:	02b7e863          	bltu	a5,a1,80002982 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002956:	02059793          	slli	a5,a1,0x20
    8000295a:	01e7d593          	srli	a1,a5,0x1e
    8000295e:	00b504b3          	add	s1,a0,a1
    80002962:	0504a903          	lw	s2,80(s1)
    80002966:	06091e63          	bnez	s2,800029e2 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000296a:	4108                	lw	a0,0(a0)
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	ea0080e7          	jalr	-352(ra) # 8000280c <balloc>
    80002974:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002978:	06090563          	beqz	s2,800029e2 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000297c:	0524a823          	sw	s2,80(s1)
    80002980:	a08d                	j	800029e2 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002982:	ff45849b          	addiw	s1,a1,-12
    80002986:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000298a:	0ff00793          	li	a5,255
    8000298e:	08e7e563          	bltu	a5,a4,80002a18 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002992:	08052903          	lw	s2,128(a0)
    80002996:	00091d63          	bnez	s2,800029b0 <bmap+0x72>
      addr = balloc(ip->dev);
    8000299a:	4108                	lw	a0,0(a0)
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	e70080e7          	jalr	-400(ra) # 8000280c <balloc>
    800029a4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029a8:	02090d63          	beqz	s2,800029e2 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029ac:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029b0:	85ca                	mv	a1,s2
    800029b2:	0009a503          	lw	a0,0(s3)
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	b96080e7          	jalr	-1130(ra) # 8000254c <bread>
    800029be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029c0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029c4:	02049713          	slli	a4,s1,0x20
    800029c8:	01e75593          	srli	a1,a4,0x1e
    800029cc:	00b784b3          	add	s1,a5,a1
    800029d0:	0004a903          	lw	s2,0(s1)
    800029d4:	02090063          	beqz	s2,800029f4 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029d8:	8552                	mv	a0,s4
    800029da:	00000097          	auipc	ra,0x0
    800029de:	ca2080e7          	jalr	-862(ra) # 8000267c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029e2:	854a                	mv	a0,s2
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6a02                	ld	s4,0(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
      addr = balloc(ip->dev);
    800029f4:	0009a503          	lw	a0,0(s3)
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	e14080e7          	jalr	-492(ra) # 8000280c <balloc>
    80002a00:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a04:	fc090ae3          	beqz	s2,800029d8 <bmap+0x9a>
        a[bn] = addr;
    80002a08:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a0c:	8552                	mv	a0,s4
    80002a0e:	00001097          	auipc	ra,0x1
    80002a12:	ec6080e7          	jalr	-314(ra) # 800038d4 <log_write>
    80002a16:	b7c9                	j	800029d8 <bmap+0x9a>
  panic("bmap: out of range");
    80002a18:	00006517          	auipc	a0,0x6
    80002a1c:	b6050513          	addi	a0,a0,-1184 # 80008578 <syscalls+0x118>
    80002a20:	00003097          	auipc	ra,0x3
    80002a24:	396080e7          	jalr	918(ra) # 80005db6 <panic>

0000000080002a28 <iget>:
{
    80002a28:	7179                	addi	sp,sp,-48
    80002a2a:	f406                	sd	ra,40(sp)
    80002a2c:	f022                	sd	s0,32(sp)
    80002a2e:	ec26                	sd	s1,24(sp)
    80002a30:	e84a                	sd	s2,16(sp)
    80002a32:	e44e                	sd	s3,8(sp)
    80002a34:	e052                	sd	s4,0(sp)
    80002a36:	1800                	addi	s0,sp,48
    80002a38:	89aa                	mv	s3,a0
    80002a3a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a3c:	00034517          	auipc	a0,0x34
    80002a40:	49450513          	addi	a0,a0,1172 # 80036ed0 <itable>
    80002a44:	00004097          	auipc	ra,0x4
    80002a48:	8aa080e7          	jalr	-1878(ra) # 800062ee <acquire>
  empty = 0;
    80002a4c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a4e:	00034497          	auipc	s1,0x34
    80002a52:	49a48493          	addi	s1,s1,1178 # 80036ee8 <itable+0x18>
    80002a56:	00036697          	auipc	a3,0x36
    80002a5a:	f2268693          	addi	a3,a3,-222 # 80038978 <log>
    80002a5e:	a039                	j	80002a6c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a60:	02090b63          	beqz	s2,80002a96 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a64:	08848493          	addi	s1,s1,136
    80002a68:	02d48a63          	beq	s1,a3,80002a9c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a6c:	449c                	lw	a5,8(s1)
    80002a6e:	fef059e3          	blez	a5,80002a60 <iget+0x38>
    80002a72:	4098                	lw	a4,0(s1)
    80002a74:	ff3716e3          	bne	a4,s3,80002a60 <iget+0x38>
    80002a78:	40d8                	lw	a4,4(s1)
    80002a7a:	ff4713e3          	bne	a4,s4,80002a60 <iget+0x38>
      ip->ref++;
    80002a7e:	2785                	addiw	a5,a5,1
    80002a80:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a82:	00034517          	auipc	a0,0x34
    80002a86:	44e50513          	addi	a0,a0,1102 # 80036ed0 <itable>
    80002a8a:	00004097          	auipc	ra,0x4
    80002a8e:	918080e7          	jalr	-1768(ra) # 800063a2 <release>
      return ip;
    80002a92:	8926                	mv	s2,s1
    80002a94:	a03d                	j	80002ac2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a96:	f7f9                	bnez	a5,80002a64 <iget+0x3c>
    80002a98:	8926                	mv	s2,s1
    80002a9a:	b7e9                	j	80002a64 <iget+0x3c>
  if(empty == 0)
    80002a9c:	02090c63          	beqz	s2,80002ad4 <iget+0xac>
  ip->dev = dev;
    80002aa0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aa4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aa8:	4785                	li	a5,1
    80002aaa:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aae:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ab2:	00034517          	auipc	a0,0x34
    80002ab6:	41e50513          	addi	a0,a0,1054 # 80036ed0 <itable>
    80002aba:	00004097          	auipc	ra,0x4
    80002abe:	8e8080e7          	jalr	-1816(ra) # 800063a2 <release>
}
    80002ac2:	854a                	mv	a0,s2
    80002ac4:	70a2                	ld	ra,40(sp)
    80002ac6:	7402                	ld	s0,32(sp)
    80002ac8:	64e2                	ld	s1,24(sp)
    80002aca:	6942                	ld	s2,16(sp)
    80002acc:	69a2                	ld	s3,8(sp)
    80002ace:	6a02                	ld	s4,0(sp)
    80002ad0:	6145                	addi	sp,sp,48
    80002ad2:	8082                	ret
    panic("iget: no inodes");
    80002ad4:	00006517          	auipc	a0,0x6
    80002ad8:	abc50513          	addi	a0,a0,-1348 # 80008590 <syscalls+0x130>
    80002adc:	00003097          	auipc	ra,0x3
    80002ae0:	2da080e7          	jalr	730(ra) # 80005db6 <panic>

0000000080002ae4 <fsinit>:
fsinit(int dev) {
    80002ae4:	7179                	addi	sp,sp,-48
    80002ae6:	f406                	sd	ra,40(sp)
    80002ae8:	f022                	sd	s0,32(sp)
    80002aea:	ec26                	sd	s1,24(sp)
    80002aec:	e84a                	sd	s2,16(sp)
    80002aee:	e44e                	sd	s3,8(sp)
    80002af0:	1800                	addi	s0,sp,48
    80002af2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002af4:	4585                	li	a1,1
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	a56080e7          	jalr	-1450(ra) # 8000254c <bread>
    80002afe:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b00:	00034997          	auipc	s3,0x34
    80002b04:	3b098993          	addi	s3,s3,944 # 80036eb0 <sb>
    80002b08:	02000613          	li	a2,32
    80002b0c:	05850593          	addi	a1,a0,88
    80002b10:	854e                	mv	a0,s3
    80002b12:	ffffd097          	auipc	ra,0xffffd
    80002b16:	7ce080e7          	jalr	1998(ra) # 800002e0 <memmove>
  brelse(bp);
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	00000097          	auipc	ra,0x0
    80002b20:	b60080e7          	jalr	-1184(ra) # 8000267c <brelse>
  if(sb.magic != FSMAGIC)
    80002b24:	0009a703          	lw	a4,0(s3)
    80002b28:	102037b7          	lui	a5,0x10203
    80002b2c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b30:	02f71263          	bne	a4,a5,80002b54 <fsinit+0x70>
  initlog(dev, &sb);
    80002b34:	00034597          	auipc	a1,0x34
    80002b38:	37c58593          	addi	a1,a1,892 # 80036eb0 <sb>
    80002b3c:	854a                	mv	a0,s2
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	b2c080e7          	jalr	-1236(ra) # 8000366a <initlog>
}
    80002b46:	70a2                	ld	ra,40(sp)
    80002b48:	7402                	ld	s0,32(sp)
    80002b4a:	64e2                	ld	s1,24(sp)
    80002b4c:	6942                	ld	s2,16(sp)
    80002b4e:	69a2                	ld	s3,8(sp)
    80002b50:	6145                	addi	sp,sp,48
    80002b52:	8082                	ret
    panic("invalid file system");
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	a4c50513          	addi	a0,a0,-1460 # 800085a0 <syscalls+0x140>
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	25a080e7          	jalr	602(ra) # 80005db6 <panic>

0000000080002b64 <iinit>:
{
    80002b64:	7179                	addi	sp,sp,-48
    80002b66:	f406                	sd	ra,40(sp)
    80002b68:	f022                	sd	s0,32(sp)
    80002b6a:	ec26                	sd	s1,24(sp)
    80002b6c:	e84a                	sd	s2,16(sp)
    80002b6e:	e44e                	sd	s3,8(sp)
    80002b70:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b72:	00006597          	auipc	a1,0x6
    80002b76:	a4658593          	addi	a1,a1,-1466 # 800085b8 <syscalls+0x158>
    80002b7a:	00034517          	auipc	a0,0x34
    80002b7e:	35650513          	addi	a0,a0,854 # 80036ed0 <itable>
    80002b82:	00003097          	auipc	ra,0x3
    80002b86:	6dc080e7          	jalr	1756(ra) # 8000625e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b8a:	00034497          	auipc	s1,0x34
    80002b8e:	36e48493          	addi	s1,s1,878 # 80036ef8 <itable+0x28>
    80002b92:	00036997          	auipc	s3,0x36
    80002b96:	df698993          	addi	s3,s3,-522 # 80038988 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b9a:	00006917          	auipc	s2,0x6
    80002b9e:	a2690913          	addi	s2,s2,-1498 # 800085c0 <syscalls+0x160>
    80002ba2:	85ca                	mv	a1,s2
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	00001097          	auipc	ra,0x1
    80002baa:	e12080e7          	jalr	-494(ra) # 800039b8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bae:	08848493          	addi	s1,s1,136
    80002bb2:	ff3498e3          	bne	s1,s3,80002ba2 <iinit+0x3e>
}
    80002bb6:	70a2                	ld	ra,40(sp)
    80002bb8:	7402                	ld	s0,32(sp)
    80002bba:	64e2                	ld	s1,24(sp)
    80002bbc:	6942                	ld	s2,16(sp)
    80002bbe:	69a2                	ld	s3,8(sp)
    80002bc0:	6145                	addi	sp,sp,48
    80002bc2:	8082                	ret

0000000080002bc4 <ialloc>:
{
    80002bc4:	7139                	addi	sp,sp,-64
    80002bc6:	fc06                	sd	ra,56(sp)
    80002bc8:	f822                	sd	s0,48(sp)
    80002bca:	f426                	sd	s1,40(sp)
    80002bcc:	f04a                	sd	s2,32(sp)
    80002bce:	ec4e                	sd	s3,24(sp)
    80002bd0:	e852                	sd	s4,16(sp)
    80002bd2:	e456                	sd	s5,8(sp)
    80002bd4:	e05a                	sd	s6,0(sp)
    80002bd6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd8:	00034717          	auipc	a4,0x34
    80002bdc:	2e472703          	lw	a4,740(a4) # 80036ebc <sb+0xc>
    80002be0:	4785                	li	a5,1
    80002be2:	04e7f863          	bgeu	a5,a4,80002c32 <ialloc+0x6e>
    80002be6:	8aaa                	mv	s5,a0
    80002be8:	8b2e                	mv	s6,a1
    80002bea:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bec:	00034a17          	auipc	s4,0x34
    80002bf0:	2c4a0a13          	addi	s4,s4,708 # 80036eb0 <sb>
    80002bf4:	00495593          	srli	a1,s2,0x4
    80002bf8:	018a2783          	lw	a5,24(s4)
    80002bfc:	9dbd                	addw	a1,a1,a5
    80002bfe:	8556                	mv	a0,s5
    80002c00:	00000097          	auipc	ra,0x0
    80002c04:	94c080e7          	jalr	-1716(ra) # 8000254c <bread>
    80002c08:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c0a:	05850993          	addi	s3,a0,88
    80002c0e:	00f97793          	andi	a5,s2,15
    80002c12:	079a                	slli	a5,a5,0x6
    80002c14:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c16:	00099783          	lh	a5,0(s3)
    80002c1a:	cf9d                	beqz	a5,80002c58 <ialloc+0x94>
    brelse(bp);
    80002c1c:	00000097          	auipc	ra,0x0
    80002c20:	a60080e7          	jalr	-1440(ra) # 8000267c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c24:	0905                	addi	s2,s2,1
    80002c26:	00ca2703          	lw	a4,12(s4)
    80002c2a:	0009079b          	sext.w	a5,s2
    80002c2e:	fce7e3e3          	bltu	a5,a4,80002bf4 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002c32:	00006517          	auipc	a0,0x6
    80002c36:	99650513          	addi	a0,a0,-1642 # 800085c8 <syscalls+0x168>
    80002c3a:	00003097          	auipc	ra,0x3
    80002c3e:	1c6080e7          	jalr	454(ra) # 80005e00 <printf>
  return 0;
    80002c42:	4501                	li	a0,0
}
    80002c44:	70e2                	ld	ra,56(sp)
    80002c46:	7442                	ld	s0,48(sp)
    80002c48:	74a2                	ld	s1,40(sp)
    80002c4a:	7902                	ld	s2,32(sp)
    80002c4c:	69e2                	ld	s3,24(sp)
    80002c4e:	6a42                	ld	s4,16(sp)
    80002c50:	6aa2                	ld	s5,8(sp)
    80002c52:	6b02                	ld	s6,0(sp)
    80002c54:	6121                	addi	sp,sp,64
    80002c56:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c58:	04000613          	li	a2,64
    80002c5c:	4581                	li	a1,0
    80002c5e:	854e                	mv	a0,s3
    80002c60:	ffffd097          	auipc	ra,0xffffd
    80002c64:	624080e7          	jalr	1572(ra) # 80000284 <memset>
      dip->type = type;
    80002c68:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c6c:	8526                	mv	a0,s1
    80002c6e:	00001097          	auipc	ra,0x1
    80002c72:	c66080e7          	jalr	-922(ra) # 800038d4 <log_write>
      brelse(bp);
    80002c76:	8526                	mv	a0,s1
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	a04080e7          	jalr	-1532(ra) # 8000267c <brelse>
      return iget(dev, inum);
    80002c80:	0009059b          	sext.w	a1,s2
    80002c84:	8556                	mv	a0,s5
    80002c86:	00000097          	auipc	ra,0x0
    80002c8a:	da2080e7          	jalr	-606(ra) # 80002a28 <iget>
    80002c8e:	bf5d                	j	80002c44 <ialloc+0x80>

0000000080002c90 <iupdate>:
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	e426                	sd	s1,8(sp)
    80002c98:	e04a                	sd	s2,0(sp)
    80002c9a:	1000                	addi	s0,sp,32
    80002c9c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9e:	415c                	lw	a5,4(a0)
    80002ca0:	0047d79b          	srliw	a5,a5,0x4
    80002ca4:	00034597          	auipc	a1,0x34
    80002ca8:	2245a583          	lw	a1,548(a1) # 80036ec8 <sb+0x18>
    80002cac:	9dbd                	addw	a1,a1,a5
    80002cae:	4108                	lw	a0,0(a0)
    80002cb0:	00000097          	auipc	ra,0x0
    80002cb4:	89c080e7          	jalr	-1892(ra) # 8000254c <bread>
    80002cb8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cba:	05850793          	addi	a5,a0,88
    80002cbe:	40d8                	lw	a4,4(s1)
    80002cc0:	8b3d                	andi	a4,a4,15
    80002cc2:	071a                	slli	a4,a4,0x6
    80002cc4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cc6:	04449703          	lh	a4,68(s1)
    80002cca:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002cce:	04649703          	lh	a4,70(s1)
    80002cd2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cd6:	04849703          	lh	a4,72(s1)
    80002cda:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cde:	04a49703          	lh	a4,74(s1)
    80002ce2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ce6:	44f8                	lw	a4,76(s1)
    80002ce8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cea:	03400613          	li	a2,52
    80002cee:	05048593          	addi	a1,s1,80
    80002cf2:	00c78513          	addi	a0,a5,12
    80002cf6:	ffffd097          	auipc	ra,0xffffd
    80002cfa:	5ea080e7          	jalr	1514(ra) # 800002e0 <memmove>
  log_write(bp);
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	bd4080e7          	jalr	-1068(ra) # 800038d4 <log_write>
  brelse(bp);
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	972080e7          	jalr	-1678(ra) # 8000267c <brelse>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret

0000000080002d1e <idup>:
{
    80002d1e:	1101                	addi	sp,sp,-32
    80002d20:	ec06                	sd	ra,24(sp)
    80002d22:	e822                	sd	s0,16(sp)
    80002d24:	e426                	sd	s1,8(sp)
    80002d26:	1000                	addi	s0,sp,32
    80002d28:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d2a:	00034517          	auipc	a0,0x34
    80002d2e:	1a650513          	addi	a0,a0,422 # 80036ed0 <itable>
    80002d32:	00003097          	auipc	ra,0x3
    80002d36:	5bc080e7          	jalr	1468(ra) # 800062ee <acquire>
  ip->ref++;
    80002d3a:	449c                	lw	a5,8(s1)
    80002d3c:	2785                	addiw	a5,a5,1
    80002d3e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d40:	00034517          	auipc	a0,0x34
    80002d44:	19050513          	addi	a0,a0,400 # 80036ed0 <itable>
    80002d48:	00003097          	auipc	ra,0x3
    80002d4c:	65a080e7          	jalr	1626(ra) # 800063a2 <release>
}
    80002d50:	8526                	mv	a0,s1
    80002d52:	60e2                	ld	ra,24(sp)
    80002d54:	6442                	ld	s0,16(sp)
    80002d56:	64a2                	ld	s1,8(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret

0000000080002d5c <ilock>:
{
    80002d5c:	1101                	addi	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	e426                	sd	s1,8(sp)
    80002d64:	e04a                	sd	s2,0(sp)
    80002d66:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d68:	c115                	beqz	a0,80002d8c <ilock+0x30>
    80002d6a:	84aa                	mv	s1,a0
    80002d6c:	451c                	lw	a5,8(a0)
    80002d6e:	00f05f63          	blez	a5,80002d8c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d72:	0541                	addi	a0,a0,16
    80002d74:	00001097          	auipc	ra,0x1
    80002d78:	c7e080e7          	jalr	-898(ra) # 800039f2 <acquiresleep>
  if(ip->valid == 0){
    80002d7c:	40bc                	lw	a5,64(s1)
    80002d7e:	cf99                	beqz	a5,80002d9c <ilock+0x40>
}
    80002d80:	60e2                	ld	ra,24(sp)
    80002d82:	6442                	ld	s0,16(sp)
    80002d84:	64a2                	ld	s1,8(sp)
    80002d86:	6902                	ld	s2,0(sp)
    80002d88:	6105                	addi	sp,sp,32
    80002d8a:	8082                	ret
    panic("ilock");
    80002d8c:	00006517          	auipc	a0,0x6
    80002d90:	85450513          	addi	a0,a0,-1964 # 800085e0 <syscalls+0x180>
    80002d94:	00003097          	auipc	ra,0x3
    80002d98:	022080e7          	jalr	34(ra) # 80005db6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d9c:	40dc                	lw	a5,4(s1)
    80002d9e:	0047d79b          	srliw	a5,a5,0x4
    80002da2:	00034597          	auipc	a1,0x34
    80002da6:	1265a583          	lw	a1,294(a1) # 80036ec8 <sb+0x18>
    80002daa:	9dbd                	addw	a1,a1,a5
    80002dac:	4088                	lw	a0,0(s1)
    80002dae:	fffff097          	auipc	ra,0xfffff
    80002db2:	79e080e7          	jalr	1950(ra) # 8000254c <bread>
    80002db6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db8:	05850593          	addi	a1,a0,88
    80002dbc:	40dc                	lw	a5,4(s1)
    80002dbe:	8bbd                	andi	a5,a5,15
    80002dc0:	079a                	slli	a5,a5,0x6
    80002dc2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dc4:	00059783          	lh	a5,0(a1)
    80002dc8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dcc:	00259783          	lh	a5,2(a1)
    80002dd0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dd4:	00459783          	lh	a5,4(a1)
    80002dd8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ddc:	00659783          	lh	a5,6(a1)
    80002de0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002de4:	459c                	lw	a5,8(a1)
    80002de6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de8:	03400613          	li	a2,52
    80002dec:	05b1                	addi	a1,a1,12
    80002dee:	05048513          	addi	a0,s1,80
    80002df2:	ffffd097          	auipc	ra,0xffffd
    80002df6:	4ee080e7          	jalr	1262(ra) # 800002e0 <memmove>
    brelse(bp);
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	880080e7          	jalr	-1920(ra) # 8000267c <brelse>
    ip->valid = 1;
    80002e04:	4785                	li	a5,1
    80002e06:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e08:	04449783          	lh	a5,68(s1)
    80002e0c:	fbb5                	bnez	a5,80002d80 <ilock+0x24>
      panic("ilock: no type");
    80002e0e:	00005517          	auipc	a0,0x5
    80002e12:	7da50513          	addi	a0,a0,2010 # 800085e8 <syscalls+0x188>
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	fa0080e7          	jalr	-96(ra) # 80005db6 <panic>

0000000080002e1e <iunlock>:
{
    80002e1e:	1101                	addi	sp,sp,-32
    80002e20:	ec06                	sd	ra,24(sp)
    80002e22:	e822                	sd	s0,16(sp)
    80002e24:	e426                	sd	s1,8(sp)
    80002e26:	e04a                	sd	s2,0(sp)
    80002e28:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e2a:	c905                	beqz	a0,80002e5a <iunlock+0x3c>
    80002e2c:	84aa                	mv	s1,a0
    80002e2e:	01050913          	addi	s2,a0,16
    80002e32:	854a                	mv	a0,s2
    80002e34:	00001097          	auipc	ra,0x1
    80002e38:	c58080e7          	jalr	-936(ra) # 80003a8c <holdingsleep>
    80002e3c:	cd19                	beqz	a0,80002e5a <iunlock+0x3c>
    80002e3e:	449c                	lw	a5,8(s1)
    80002e40:	00f05d63          	blez	a5,80002e5a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e44:	854a                	mv	a0,s2
    80002e46:	00001097          	auipc	ra,0x1
    80002e4a:	c02080e7          	jalr	-1022(ra) # 80003a48 <releasesleep>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6902                	ld	s2,0(sp)
    80002e56:	6105                	addi	sp,sp,32
    80002e58:	8082                	ret
    panic("iunlock");
    80002e5a:	00005517          	auipc	a0,0x5
    80002e5e:	79e50513          	addi	a0,a0,1950 # 800085f8 <syscalls+0x198>
    80002e62:	00003097          	auipc	ra,0x3
    80002e66:	f54080e7          	jalr	-172(ra) # 80005db6 <panic>

0000000080002e6a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e6a:	7179                	addi	sp,sp,-48
    80002e6c:	f406                	sd	ra,40(sp)
    80002e6e:	f022                	sd	s0,32(sp)
    80002e70:	ec26                	sd	s1,24(sp)
    80002e72:	e84a                	sd	s2,16(sp)
    80002e74:	e44e                	sd	s3,8(sp)
    80002e76:	e052                	sd	s4,0(sp)
    80002e78:	1800                	addi	s0,sp,48
    80002e7a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e7c:	05050493          	addi	s1,a0,80
    80002e80:	08050913          	addi	s2,a0,128
    80002e84:	a021                	j	80002e8c <itrunc+0x22>
    80002e86:	0491                	addi	s1,s1,4
    80002e88:	01248d63          	beq	s1,s2,80002ea2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e8c:	408c                	lw	a1,0(s1)
    80002e8e:	dde5                	beqz	a1,80002e86 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e90:	0009a503          	lw	a0,0(s3)
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	8fc080e7          	jalr	-1796(ra) # 80002790 <bfree>
      ip->addrs[i] = 0;
    80002e9c:	0004a023          	sw	zero,0(s1)
    80002ea0:	b7dd                	j	80002e86 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ea2:	0809a583          	lw	a1,128(s3)
    80002ea6:	e185                	bnez	a1,80002ec6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eac:	854e                	mv	a0,s3
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	de2080e7          	jalr	-542(ra) # 80002c90 <iupdate>
}
    80002eb6:	70a2                	ld	ra,40(sp)
    80002eb8:	7402                	ld	s0,32(sp)
    80002eba:	64e2                	ld	s1,24(sp)
    80002ebc:	6942                	ld	s2,16(sp)
    80002ebe:	69a2                	ld	s3,8(sp)
    80002ec0:	6a02                	ld	s4,0(sp)
    80002ec2:	6145                	addi	sp,sp,48
    80002ec4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec6:	0009a503          	lw	a0,0(s3)
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	682080e7          	jalr	1666(ra) # 8000254c <bread>
    80002ed2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ed4:	05850493          	addi	s1,a0,88
    80002ed8:	45850913          	addi	s2,a0,1112
    80002edc:	a021                	j	80002ee4 <itrunc+0x7a>
    80002ede:	0491                	addi	s1,s1,4
    80002ee0:	01248b63          	beq	s1,s2,80002ef6 <itrunc+0x8c>
      if(a[j])
    80002ee4:	408c                	lw	a1,0(s1)
    80002ee6:	dde5                	beqz	a1,80002ede <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ee8:	0009a503          	lw	a0,0(s3)
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	8a4080e7          	jalr	-1884(ra) # 80002790 <bfree>
    80002ef4:	b7ed                	j	80002ede <itrunc+0x74>
    brelse(bp);
    80002ef6:	8552                	mv	a0,s4
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	784080e7          	jalr	1924(ra) # 8000267c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f00:	0809a583          	lw	a1,128(s3)
    80002f04:	0009a503          	lw	a0,0(s3)
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	888080e7          	jalr	-1912(ra) # 80002790 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f10:	0809a023          	sw	zero,128(s3)
    80002f14:	bf51                	j	80002ea8 <itrunc+0x3e>

0000000080002f16 <iput>:
{
    80002f16:	1101                	addi	sp,sp,-32
    80002f18:	ec06                	sd	ra,24(sp)
    80002f1a:	e822                	sd	s0,16(sp)
    80002f1c:	e426                	sd	s1,8(sp)
    80002f1e:	e04a                	sd	s2,0(sp)
    80002f20:	1000                	addi	s0,sp,32
    80002f22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f24:	00034517          	auipc	a0,0x34
    80002f28:	fac50513          	addi	a0,a0,-84 # 80036ed0 <itable>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	3c2080e7          	jalr	962(ra) # 800062ee <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f34:	4498                	lw	a4,8(s1)
    80002f36:	4785                	li	a5,1
    80002f38:	02f70363          	beq	a4,a5,80002f5e <iput+0x48>
  ip->ref--;
    80002f3c:	449c                	lw	a5,8(s1)
    80002f3e:	37fd                	addiw	a5,a5,-1
    80002f40:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f42:	00034517          	auipc	a0,0x34
    80002f46:	f8e50513          	addi	a0,a0,-114 # 80036ed0 <itable>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	458080e7          	jalr	1112(ra) # 800063a2 <release>
}
    80002f52:	60e2                	ld	ra,24(sp)
    80002f54:	6442                	ld	s0,16(sp)
    80002f56:	64a2                	ld	s1,8(sp)
    80002f58:	6902                	ld	s2,0(sp)
    80002f5a:	6105                	addi	sp,sp,32
    80002f5c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f5e:	40bc                	lw	a5,64(s1)
    80002f60:	dff1                	beqz	a5,80002f3c <iput+0x26>
    80002f62:	04a49783          	lh	a5,74(s1)
    80002f66:	fbf9                	bnez	a5,80002f3c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f68:	01048913          	addi	s2,s1,16
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	00001097          	auipc	ra,0x1
    80002f72:	a84080e7          	jalr	-1404(ra) # 800039f2 <acquiresleep>
    release(&itable.lock);
    80002f76:	00034517          	auipc	a0,0x34
    80002f7a:	f5a50513          	addi	a0,a0,-166 # 80036ed0 <itable>
    80002f7e:	00003097          	auipc	ra,0x3
    80002f82:	424080e7          	jalr	1060(ra) # 800063a2 <release>
    itrunc(ip);
    80002f86:	8526                	mv	a0,s1
    80002f88:	00000097          	auipc	ra,0x0
    80002f8c:	ee2080e7          	jalr	-286(ra) # 80002e6a <itrunc>
    ip->type = 0;
    80002f90:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f94:	8526                	mv	a0,s1
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	cfa080e7          	jalr	-774(ra) # 80002c90 <iupdate>
    ip->valid = 0;
    80002f9e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	00001097          	auipc	ra,0x1
    80002fa8:	aa4080e7          	jalr	-1372(ra) # 80003a48 <releasesleep>
    acquire(&itable.lock);
    80002fac:	00034517          	auipc	a0,0x34
    80002fb0:	f2450513          	addi	a0,a0,-220 # 80036ed0 <itable>
    80002fb4:	00003097          	auipc	ra,0x3
    80002fb8:	33a080e7          	jalr	826(ra) # 800062ee <acquire>
    80002fbc:	b741                	j	80002f3c <iput+0x26>

0000000080002fbe <iunlockput>:
{
    80002fbe:	1101                	addi	sp,sp,-32
    80002fc0:	ec06                	sd	ra,24(sp)
    80002fc2:	e822                	sd	s0,16(sp)
    80002fc4:	e426                	sd	s1,8(sp)
    80002fc6:	1000                	addi	s0,sp,32
    80002fc8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	e54080e7          	jalr	-428(ra) # 80002e1e <iunlock>
  iput(ip);
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	f42080e7          	jalr	-190(ra) # 80002f16 <iput>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6105                	addi	sp,sp,32
    80002fe4:	8082                	ret

0000000080002fe6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe6:	1141                	addi	sp,sp,-16
    80002fe8:	e422                	sd	s0,8(sp)
    80002fea:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fec:	411c                	lw	a5,0(a0)
    80002fee:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ff0:	415c                	lw	a5,4(a0)
    80002ff2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ff4:	04451783          	lh	a5,68(a0)
    80002ff8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ffc:	04a51783          	lh	a5,74(a0)
    80003000:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003004:	04c56783          	lwu	a5,76(a0)
    80003008:	e99c                	sd	a5,16(a1)
}
    8000300a:	6422                	ld	s0,8(sp)
    8000300c:	0141                	addi	sp,sp,16
    8000300e:	8082                	ret

0000000080003010 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003010:	457c                	lw	a5,76(a0)
    80003012:	0ed7e963          	bltu	a5,a3,80003104 <readi+0xf4>
{
    80003016:	7159                	addi	sp,sp,-112
    80003018:	f486                	sd	ra,104(sp)
    8000301a:	f0a2                	sd	s0,96(sp)
    8000301c:	eca6                	sd	s1,88(sp)
    8000301e:	e8ca                	sd	s2,80(sp)
    80003020:	e4ce                	sd	s3,72(sp)
    80003022:	e0d2                	sd	s4,64(sp)
    80003024:	fc56                	sd	s5,56(sp)
    80003026:	f85a                	sd	s6,48(sp)
    80003028:	f45e                	sd	s7,40(sp)
    8000302a:	f062                	sd	s8,32(sp)
    8000302c:	ec66                	sd	s9,24(sp)
    8000302e:	e86a                	sd	s10,16(sp)
    80003030:	e46e                	sd	s11,8(sp)
    80003032:	1880                	addi	s0,sp,112
    80003034:	8b2a                	mv	s6,a0
    80003036:	8bae                	mv	s7,a1
    80003038:	8a32                	mv	s4,a2
    8000303a:	84b6                	mv	s1,a3
    8000303c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000303e:	9f35                	addw	a4,a4,a3
    return 0;
    80003040:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003042:	0ad76063          	bltu	a4,a3,800030e2 <readi+0xd2>
  if(off + n > ip->size)
    80003046:	00e7f463          	bgeu	a5,a4,8000304e <readi+0x3e>
    n = ip->size - off;
    8000304a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304e:	0a0a8963          	beqz	s5,80003100 <readi+0xf0>
    80003052:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003054:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003058:	5c7d                	li	s8,-1
    8000305a:	a82d                	j	80003094 <readi+0x84>
    8000305c:	020d1d93          	slli	s11,s10,0x20
    80003060:	020ddd93          	srli	s11,s11,0x20
    80003064:	05890613          	addi	a2,s2,88
    80003068:	86ee                	mv	a3,s11
    8000306a:	963a                	add	a2,a2,a4
    8000306c:	85d2                	mv	a1,s4
    8000306e:	855e                	mv	a0,s7
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	ad0080e7          	jalr	-1328(ra) # 80001b40 <either_copyout>
    80003078:	05850d63          	beq	a0,s8,800030d2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000307c:	854a                	mv	a0,s2
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	5fe080e7          	jalr	1534(ra) # 8000267c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003086:	013d09bb          	addw	s3,s10,s3
    8000308a:	009d04bb          	addw	s1,s10,s1
    8000308e:	9a6e                	add	s4,s4,s11
    80003090:	0559f763          	bgeu	s3,s5,800030de <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003094:	00a4d59b          	srliw	a1,s1,0xa
    80003098:	855a                	mv	a0,s6
    8000309a:	00000097          	auipc	ra,0x0
    8000309e:	8a4080e7          	jalr	-1884(ra) # 8000293e <bmap>
    800030a2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030a6:	cd85                	beqz	a1,800030de <readi+0xce>
    bp = bread(ip->dev, addr);
    800030a8:	000b2503          	lw	a0,0(s6)
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	4a0080e7          	jalr	1184(ra) # 8000254c <bread>
    800030b4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b6:	3ff4f713          	andi	a4,s1,1023
    800030ba:	40ec87bb          	subw	a5,s9,a4
    800030be:	413a86bb          	subw	a3,s5,s3
    800030c2:	8d3e                	mv	s10,a5
    800030c4:	2781                	sext.w	a5,a5
    800030c6:	0006861b          	sext.w	a2,a3
    800030ca:	f8f679e3          	bgeu	a2,a5,8000305c <readi+0x4c>
    800030ce:	8d36                	mv	s10,a3
    800030d0:	b771                	j	8000305c <readi+0x4c>
      brelse(bp);
    800030d2:	854a                	mv	a0,s2
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	5a8080e7          	jalr	1448(ra) # 8000267c <brelse>
      tot = -1;
    800030dc:	59fd                	li	s3,-1
  }
  return tot;
    800030de:	0009851b          	sext.w	a0,s3
}
    800030e2:	70a6                	ld	ra,104(sp)
    800030e4:	7406                	ld	s0,96(sp)
    800030e6:	64e6                	ld	s1,88(sp)
    800030e8:	6946                	ld	s2,80(sp)
    800030ea:	69a6                	ld	s3,72(sp)
    800030ec:	6a06                	ld	s4,64(sp)
    800030ee:	7ae2                	ld	s5,56(sp)
    800030f0:	7b42                	ld	s6,48(sp)
    800030f2:	7ba2                	ld	s7,40(sp)
    800030f4:	7c02                	ld	s8,32(sp)
    800030f6:	6ce2                	ld	s9,24(sp)
    800030f8:	6d42                	ld	s10,16(sp)
    800030fa:	6da2                	ld	s11,8(sp)
    800030fc:	6165                	addi	sp,sp,112
    800030fe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003100:	89d6                	mv	s3,s5
    80003102:	bff1                	j	800030de <readi+0xce>
    return 0;
    80003104:	4501                	li	a0,0
}
    80003106:	8082                	ret

0000000080003108 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003108:	457c                	lw	a5,76(a0)
    8000310a:	10d7e863          	bltu	a5,a3,8000321a <writei+0x112>
{
    8000310e:	7159                	addi	sp,sp,-112
    80003110:	f486                	sd	ra,104(sp)
    80003112:	f0a2                	sd	s0,96(sp)
    80003114:	eca6                	sd	s1,88(sp)
    80003116:	e8ca                	sd	s2,80(sp)
    80003118:	e4ce                	sd	s3,72(sp)
    8000311a:	e0d2                	sd	s4,64(sp)
    8000311c:	fc56                	sd	s5,56(sp)
    8000311e:	f85a                	sd	s6,48(sp)
    80003120:	f45e                	sd	s7,40(sp)
    80003122:	f062                	sd	s8,32(sp)
    80003124:	ec66                	sd	s9,24(sp)
    80003126:	e86a                	sd	s10,16(sp)
    80003128:	e46e                	sd	s11,8(sp)
    8000312a:	1880                	addi	s0,sp,112
    8000312c:	8aaa                	mv	s5,a0
    8000312e:	8bae                	mv	s7,a1
    80003130:	8a32                	mv	s4,a2
    80003132:	8936                	mv	s2,a3
    80003134:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003136:	00e687bb          	addw	a5,a3,a4
    8000313a:	0ed7e263          	bltu	a5,a3,8000321e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000313e:	00043737          	lui	a4,0x43
    80003142:	0ef76063          	bltu	a4,a5,80003222 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003146:	0c0b0863          	beqz	s6,80003216 <writei+0x10e>
    8000314a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003150:	5c7d                	li	s8,-1
    80003152:	a091                	j	80003196 <writei+0x8e>
    80003154:	020d1d93          	slli	s11,s10,0x20
    80003158:	020ddd93          	srli	s11,s11,0x20
    8000315c:	05848513          	addi	a0,s1,88
    80003160:	86ee                	mv	a3,s11
    80003162:	8652                	mv	a2,s4
    80003164:	85de                	mv	a1,s7
    80003166:	953a                	add	a0,a0,a4
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	a2e080e7          	jalr	-1490(ra) # 80001b96 <either_copyin>
    80003170:	07850263          	beq	a0,s8,800031d4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003174:	8526                	mv	a0,s1
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	75e080e7          	jalr	1886(ra) # 800038d4 <log_write>
    brelse(bp);
    8000317e:	8526                	mv	a0,s1
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	4fc080e7          	jalr	1276(ra) # 8000267c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003188:	013d09bb          	addw	s3,s10,s3
    8000318c:	012d093b          	addw	s2,s10,s2
    80003190:	9a6e                	add	s4,s4,s11
    80003192:	0569f663          	bgeu	s3,s6,800031de <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003196:	00a9559b          	srliw	a1,s2,0xa
    8000319a:	8556                	mv	a0,s5
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	7a2080e7          	jalr	1954(ra) # 8000293e <bmap>
    800031a4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031a8:	c99d                	beqz	a1,800031de <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031aa:	000aa503          	lw	a0,0(s5)
    800031ae:	fffff097          	auipc	ra,0xfffff
    800031b2:	39e080e7          	jalr	926(ra) # 8000254c <bread>
    800031b6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b8:	3ff97713          	andi	a4,s2,1023
    800031bc:	40ec87bb          	subw	a5,s9,a4
    800031c0:	413b06bb          	subw	a3,s6,s3
    800031c4:	8d3e                	mv	s10,a5
    800031c6:	2781                	sext.w	a5,a5
    800031c8:	0006861b          	sext.w	a2,a3
    800031cc:	f8f674e3          	bgeu	a2,a5,80003154 <writei+0x4c>
    800031d0:	8d36                	mv	s10,a3
    800031d2:	b749                	j	80003154 <writei+0x4c>
      brelse(bp);
    800031d4:	8526                	mv	a0,s1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	4a6080e7          	jalr	1190(ra) # 8000267c <brelse>
  }

  if(off > ip->size)
    800031de:	04caa783          	lw	a5,76(s5)
    800031e2:	0127f463          	bgeu	a5,s2,800031ea <writei+0xe2>
    ip->size = off;
    800031e6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ea:	8556                	mv	a0,s5
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	aa4080e7          	jalr	-1372(ra) # 80002c90 <iupdate>

  return tot;
    800031f4:	0009851b          	sext.w	a0,s3
}
    800031f8:	70a6                	ld	ra,104(sp)
    800031fa:	7406                	ld	s0,96(sp)
    800031fc:	64e6                	ld	s1,88(sp)
    800031fe:	6946                	ld	s2,80(sp)
    80003200:	69a6                	ld	s3,72(sp)
    80003202:	6a06                	ld	s4,64(sp)
    80003204:	7ae2                	ld	s5,56(sp)
    80003206:	7b42                	ld	s6,48(sp)
    80003208:	7ba2                	ld	s7,40(sp)
    8000320a:	7c02                	ld	s8,32(sp)
    8000320c:	6ce2                	ld	s9,24(sp)
    8000320e:	6d42                	ld	s10,16(sp)
    80003210:	6da2                	ld	s11,8(sp)
    80003212:	6165                	addi	sp,sp,112
    80003214:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003216:	89da                	mv	s3,s6
    80003218:	bfc9                	j	800031ea <writei+0xe2>
    return -1;
    8000321a:	557d                	li	a0,-1
}
    8000321c:	8082                	ret
    return -1;
    8000321e:	557d                	li	a0,-1
    80003220:	bfe1                	j	800031f8 <writei+0xf0>
    return -1;
    80003222:	557d                	li	a0,-1
    80003224:	bfd1                	j	800031f8 <writei+0xf0>

0000000080003226 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003226:	1141                	addi	sp,sp,-16
    80003228:	e406                	sd	ra,8(sp)
    8000322a:	e022                	sd	s0,0(sp)
    8000322c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000322e:	4639                	li	a2,14
    80003230:	ffffd097          	auipc	ra,0xffffd
    80003234:	124080e7          	jalr	292(ra) # 80000354 <strncmp>
}
    80003238:	60a2                	ld	ra,8(sp)
    8000323a:	6402                	ld	s0,0(sp)
    8000323c:	0141                	addi	sp,sp,16
    8000323e:	8082                	ret

0000000080003240 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003240:	7139                	addi	sp,sp,-64
    80003242:	fc06                	sd	ra,56(sp)
    80003244:	f822                	sd	s0,48(sp)
    80003246:	f426                	sd	s1,40(sp)
    80003248:	f04a                	sd	s2,32(sp)
    8000324a:	ec4e                	sd	s3,24(sp)
    8000324c:	e852                	sd	s4,16(sp)
    8000324e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003250:	04451703          	lh	a4,68(a0)
    80003254:	4785                	li	a5,1
    80003256:	00f71a63          	bne	a4,a5,8000326a <dirlookup+0x2a>
    8000325a:	892a                	mv	s2,a0
    8000325c:	89ae                	mv	s3,a1
    8000325e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003260:	457c                	lw	a5,76(a0)
    80003262:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003264:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003266:	e79d                	bnez	a5,80003294 <dirlookup+0x54>
    80003268:	a8a5                	j	800032e0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000326a:	00005517          	auipc	a0,0x5
    8000326e:	39650513          	addi	a0,a0,918 # 80008600 <syscalls+0x1a0>
    80003272:	00003097          	auipc	ra,0x3
    80003276:	b44080e7          	jalr	-1212(ra) # 80005db6 <panic>
      panic("dirlookup read");
    8000327a:	00005517          	auipc	a0,0x5
    8000327e:	39e50513          	addi	a0,a0,926 # 80008618 <syscalls+0x1b8>
    80003282:	00003097          	auipc	ra,0x3
    80003286:	b34080e7          	jalr	-1228(ra) # 80005db6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328a:	24c1                	addiw	s1,s1,16
    8000328c:	04c92783          	lw	a5,76(s2)
    80003290:	04f4f763          	bgeu	s1,a5,800032de <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003294:	4741                	li	a4,16
    80003296:	86a6                	mv	a3,s1
    80003298:	fc040613          	addi	a2,s0,-64
    8000329c:	4581                	li	a1,0
    8000329e:	854a                	mv	a0,s2
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	d70080e7          	jalr	-656(ra) # 80003010 <readi>
    800032a8:	47c1                	li	a5,16
    800032aa:	fcf518e3          	bne	a0,a5,8000327a <dirlookup+0x3a>
    if(de.inum == 0)
    800032ae:	fc045783          	lhu	a5,-64(s0)
    800032b2:	dfe1                	beqz	a5,8000328a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032b4:	fc240593          	addi	a1,s0,-62
    800032b8:	854e                	mv	a0,s3
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	f6c080e7          	jalr	-148(ra) # 80003226 <namecmp>
    800032c2:	f561                	bnez	a0,8000328a <dirlookup+0x4a>
      if(poff)
    800032c4:	000a0463          	beqz	s4,800032cc <dirlookup+0x8c>
        *poff = off;
    800032c8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032cc:	fc045583          	lhu	a1,-64(s0)
    800032d0:	00092503          	lw	a0,0(s2)
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	754080e7          	jalr	1876(ra) # 80002a28 <iget>
    800032dc:	a011                	j	800032e0 <dirlookup+0xa0>
  return 0;
    800032de:	4501                	li	a0,0
}
    800032e0:	70e2                	ld	ra,56(sp)
    800032e2:	7442                	ld	s0,48(sp)
    800032e4:	74a2                	ld	s1,40(sp)
    800032e6:	7902                	ld	s2,32(sp)
    800032e8:	69e2                	ld	s3,24(sp)
    800032ea:	6a42                	ld	s4,16(sp)
    800032ec:	6121                	addi	sp,sp,64
    800032ee:	8082                	ret

00000000800032f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032f0:	711d                	addi	sp,sp,-96
    800032f2:	ec86                	sd	ra,88(sp)
    800032f4:	e8a2                	sd	s0,80(sp)
    800032f6:	e4a6                	sd	s1,72(sp)
    800032f8:	e0ca                	sd	s2,64(sp)
    800032fa:	fc4e                	sd	s3,56(sp)
    800032fc:	f852                	sd	s4,48(sp)
    800032fe:	f456                	sd	s5,40(sp)
    80003300:	f05a                	sd	s6,32(sp)
    80003302:	ec5e                	sd	s7,24(sp)
    80003304:	e862                	sd	s8,16(sp)
    80003306:	e466                	sd	s9,8(sp)
    80003308:	1080                	addi	s0,sp,96
    8000330a:	84aa                	mv	s1,a0
    8000330c:	8b2e                	mv	s6,a1
    8000330e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003310:	00054703          	lbu	a4,0(a0)
    80003314:	02f00793          	li	a5,47
    80003318:	02f70263          	beq	a4,a5,8000333c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000331c:	ffffe097          	auipc	ra,0xffffe
    80003320:	d74080e7          	jalr	-652(ra) # 80001090 <myproc>
    80003324:	15053503          	ld	a0,336(a0)
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	9f6080e7          	jalr	-1546(ra) # 80002d1e <idup>
    80003330:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003332:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003336:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003338:	4b85                	li	s7,1
    8000333a:	a875                	j	800033f6 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000333c:	4585                	li	a1,1
    8000333e:	4505                	li	a0,1
    80003340:	fffff097          	auipc	ra,0xfffff
    80003344:	6e8080e7          	jalr	1768(ra) # 80002a28 <iget>
    80003348:	8a2a                	mv	s4,a0
    8000334a:	b7e5                	j	80003332 <namex+0x42>
      iunlockput(ip);
    8000334c:	8552                	mv	a0,s4
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	c70080e7          	jalr	-912(ra) # 80002fbe <iunlockput>
      return 0;
    80003356:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003358:	8552                	mv	a0,s4
    8000335a:	60e6                	ld	ra,88(sp)
    8000335c:	6446                	ld	s0,80(sp)
    8000335e:	64a6                	ld	s1,72(sp)
    80003360:	6906                	ld	s2,64(sp)
    80003362:	79e2                	ld	s3,56(sp)
    80003364:	7a42                	ld	s4,48(sp)
    80003366:	7aa2                	ld	s5,40(sp)
    80003368:	7b02                	ld	s6,32(sp)
    8000336a:	6be2                	ld	s7,24(sp)
    8000336c:	6c42                	ld	s8,16(sp)
    8000336e:	6ca2                	ld	s9,8(sp)
    80003370:	6125                	addi	sp,sp,96
    80003372:	8082                	ret
      iunlock(ip);
    80003374:	8552                	mv	a0,s4
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	aa8080e7          	jalr	-1368(ra) # 80002e1e <iunlock>
      return ip;
    8000337e:	bfe9                	j	80003358 <namex+0x68>
      iunlockput(ip);
    80003380:	8552                	mv	a0,s4
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c3c080e7          	jalr	-964(ra) # 80002fbe <iunlockput>
      return 0;
    8000338a:	8a4e                	mv	s4,s3
    8000338c:	b7f1                	j	80003358 <namex+0x68>
  len = path - s;
    8000338e:	40998633          	sub	a2,s3,s1
    80003392:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003396:	099c5863          	bge	s8,s9,80003426 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000339a:	4639                	li	a2,14
    8000339c:	85a6                	mv	a1,s1
    8000339e:	8556                	mv	a0,s5
    800033a0:	ffffd097          	auipc	ra,0xffffd
    800033a4:	f40080e7          	jalr	-192(ra) # 800002e0 <memmove>
    800033a8:	84ce                	mv	s1,s3
  while(*path == '/')
    800033aa:	0004c783          	lbu	a5,0(s1)
    800033ae:	01279763          	bne	a5,s2,800033bc <namex+0xcc>
    path++;
    800033b2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b4:	0004c783          	lbu	a5,0(s1)
    800033b8:	ff278de3          	beq	a5,s2,800033b2 <namex+0xc2>
    ilock(ip);
    800033bc:	8552                	mv	a0,s4
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	99e080e7          	jalr	-1634(ra) # 80002d5c <ilock>
    if(ip->type != T_DIR){
    800033c6:	044a1783          	lh	a5,68(s4)
    800033ca:	f97791e3          	bne	a5,s7,8000334c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033ce:	000b0563          	beqz	s6,800033d8 <namex+0xe8>
    800033d2:	0004c783          	lbu	a5,0(s1)
    800033d6:	dfd9                	beqz	a5,80003374 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033d8:	4601                	li	a2,0
    800033da:	85d6                	mv	a1,s5
    800033dc:	8552                	mv	a0,s4
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	e62080e7          	jalr	-414(ra) # 80003240 <dirlookup>
    800033e6:	89aa                	mv	s3,a0
    800033e8:	dd41                	beqz	a0,80003380 <namex+0x90>
    iunlockput(ip);
    800033ea:	8552                	mv	a0,s4
    800033ec:	00000097          	auipc	ra,0x0
    800033f0:	bd2080e7          	jalr	-1070(ra) # 80002fbe <iunlockput>
    ip = next;
    800033f4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033f6:	0004c783          	lbu	a5,0(s1)
    800033fa:	01279763          	bne	a5,s2,80003408 <namex+0x118>
    path++;
    800033fe:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003400:	0004c783          	lbu	a5,0(s1)
    80003404:	ff278de3          	beq	a5,s2,800033fe <namex+0x10e>
  if(*path == 0)
    80003408:	cb9d                	beqz	a5,8000343e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000340a:	0004c783          	lbu	a5,0(s1)
    8000340e:	89a6                	mv	s3,s1
  len = path - s;
    80003410:	4c81                	li	s9,0
    80003412:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003414:	01278963          	beq	a5,s2,80003426 <namex+0x136>
    80003418:	dbbd                	beqz	a5,8000338e <namex+0x9e>
    path++;
    8000341a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000341c:	0009c783          	lbu	a5,0(s3)
    80003420:	ff279ce3          	bne	a5,s2,80003418 <namex+0x128>
    80003424:	b7ad                	j	8000338e <namex+0x9e>
    memmove(name, s, len);
    80003426:	2601                	sext.w	a2,a2
    80003428:	85a6                	mv	a1,s1
    8000342a:	8556                	mv	a0,s5
    8000342c:	ffffd097          	auipc	ra,0xffffd
    80003430:	eb4080e7          	jalr	-332(ra) # 800002e0 <memmove>
    name[len] = 0;
    80003434:	9cd6                	add	s9,s9,s5
    80003436:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000343a:	84ce                	mv	s1,s3
    8000343c:	b7bd                	j	800033aa <namex+0xba>
  if(nameiparent){
    8000343e:	f00b0de3          	beqz	s6,80003358 <namex+0x68>
    iput(ip);
    80003442:	8552                	mv	a0,s4
    80003444:	00000097          	auipc	ra,0x0
    80003448:	ad2080e7          	jalr	-1326(ra) # 80002f16 <iput>
    return 0;
    8000344c:	4a01                	li	s4,0
    8000344e:	b729                	j	80003358 <namex+0x68>

0000000080003450 <dirlink>:
{
    80003450:	7139                	addi	sp,sp,-64
    80003452:	fc06                	sd	ra,56(sp)
    80003454:	f822                	sd	s0,48(sp)
    80003456:	f426                	sd	s1,40(sp)
    80003458:	f04a                	sd	s2,32(sp)
    8000345a:	ec4e                	sd	s3,24(sp)
    8000345c:	e852                	sd	s4,16(sp)
    8000345e:	0080                	addi	s0,sp,64
    80003460:	892a                	mv	s2,a0
    80003462:	8a2e                	mv	s4,a1
    80003464:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003466:	4601                	li	a2,0
    80003468:	00000097          	auipc	ra,0x0
    8000346c:	dd8080e7          	jalr	-552(ra) # 80003240 <dirlookup>
    80003470:	e93d                	bnez	a0,800034e6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003472:	04c92483          	lw	s1,76(s2)
    80003476:	c49d                	beqz	s1,800034a4 <dirlink+0x54>
    80003478:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347a:	4741                	li	a4,16
    8000347c:	86a6                	mv	a3,s1
    8000347e:	fc040613          	addi	a2,s0,-64
    80003482:	4581                	li	a1,0
    80003484:	854a                	mv	a0,s2
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	b8a080e7          	jalr	-1142(ra) # 80003010 <readi>
    8000348e:	47c1                	li	a5,16
    80003490:	06f51163          	bne	a0,a5,800034f2 <dirlink+0xa2>
    if(de.inum == 0)
    80003494:	fc045783          	lhu	a5,-64(s0)
    80003498:	c791                	beqz	a5,800034a4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349a:	24c1                	addiw	s1,s1,16
    8000349c:	04c92783          	lw	a5,76(s2)
    800034a0:	fcf4ede3          	bltu	s1,a5,8000347a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034a4:	4639                	li	a2,14
    800034a6:	85d2                	mv	a1,s4
    800034a8:	fc240513          	addi	a0,s0,-62
    800034ac:	ffffd097          	auipc	ra,0xffffd
    800034b0:	ee4080e7          	jalr	-284(ra) # 80000390 <strncpy>
  de.inum = inum;
    800034b4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b8:	4741                	li	a4,16
    800034ba:	86a6                	mv	a3,s1
    800034bc:	fc040613          	addi	a2,s0,-64
    800034c0:	4581                	li	a1,0
    800034c2:	854a                	mv	a0,s2
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	c44080e7          	jalr	-956(ra) # 80003108 <writei>
    800034cc:	1541                	addi	a0,a0,-16
    800034ce:	00a03533          	snez	a0,a0
    800034d2:	40a00533          	neg	a0,a0
}
    800034d6:	70e2                	ld	ra,56(sp)
    800034d8:	7442                	ld	s0,48(sp)
    800034da:	74a2                	ld	s1,40(sp)
    800034dc:	7902                	ld	s2,32(sp)
    800034de:	69e2                	ld	s3,24(sp)
    800034e0:	6a42                	ld	s4,16(sp)
    800034e2:	6121                	addi	sp,sp,64
    800034e4:	8082                	ret
    iput(ip);
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	a30080e7          	jalr	-1488(ra) # 80002f16 <iput>
    return -1;
    800034ee:	557d                	li	a0,-1
    800034f0:	b7dd                	j	800034d6 <dirlink+0x86>
      panic("dirlink read");
    800034f2:	00005517          	auipc	a0,0x5
    800034f6:	13650513          	addi	a0,a0,310 # 80008628 <syscalls+0x1c8>
    800034fa:	00003097          	auipc	ra,0x3
    800034fe:	8bc080e7          	jalr	-1860(ra) # 80005db6 <panic>

0000000080003502 <namei>:

struct inode*
namei(char *path)
{
    80003502:	1101                	addi	sp,sp,-32
    80003504:	ec06                	sd	ra,24(sp)
    80003506:	e822                	sd	s0,16(sp)
    80003508:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000350a:	fe040613          	addi	a2,s0,-32
    8000350e:	4581                	li	a1,0
    80003510:	00000097          	auipc	ra,0x0
    80003514:	de0080e7          	jalr	-544(ra) # 800032f0 <namex>
}
    80003518:	60e2                	ld	ra,24(sp)
    8000351a:	6442                	ld	s0,16(sp)
    8000351c:	6105                	addi	sp,sp,32
    8000351e:	8082                	ret

0000000080003520 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003520:	1141                	addi	sp,sp,-16
    80003522:	e406                	sd	ra,8(sp)
    80003524:	e022                	sd	s0,0(sp)
    80003526:	0800                	addi	s0,sp,16
    80003528:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000352a:	4585                	li	a1,1
    8000352c:	00000097          	auipc	ra,0x0
    80003530:	dc4080e7          	jalr	-572(ra) # 800032f0 <namex>
}
    80003534:	60a2                	ld	ra,8(sp)
    80003536:	6402                	ld	s0,0(sp)
    80003538:	0141                	addi	sp,sp,16
    8000353a:	8082                	ret

000000008000353c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000353c:	1101                	addi	sp,sp,-32
    8000353e:	ec06                	sd	ra,24(sp)
    80003540:	e822                	sd	s0,16(sp)
    80003542:	e426                	sd	s1,8(sp)
    80003544:	e04a                	sd	s2,0(sp)
    80003546:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003548:	00035917          	auipc	s2,0x35
    8000354c:	43090913          	addi	s2,s2,1072 # 80038978 <log>
    80003550:	01892583          	lw	a1,24(s2)
    80003554:	02892503          	lw	a0,40(s2)
    80003558:	fffff097          	auipc	ra,0xfffff
    8000355c:	ff4080e7          	jalr	-12(ra) # 8000254c <bread>
    80003560:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003562:	02c92603          	lw	a2,44(s2)
    80003566:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003568:	00c05f63          	blez	a2,80003586 <write_head+0x4a>
    8000356c:	00035717          	auipc	a4,0x35
    80003570:	43c70713          	addi	a4,a4,1084 # 800389a8 <log+0x30>
    80003574:	87aa                	mv	a5,a0
    80003576:	060a                	slli	a2,a2,0x2
    80003578:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000357a:	4314                	lw	a3,0(a4)
    8000357c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000357e:	0711                	addi	a4,a4,4
    80003580:	0791                	addi	a5,a5,4
    80003582:	fec79ce3          	bne	a5,a2,8000357a <write_head+0x3e>
  }
  bwrite(buf);
    80003586:	8526                	mv	a0,s1
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	0b6080e7          	jalr	182(ra) # 8000263e <bwrite>
  brelse(buf);
    80003590:	8526                	mv	a0,s1
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	0ea080e7          	jalr	234(ra) # 8000267c <brelse>
}
    8000359a:	60e2                	ld	ra,24(sp)
    8000359c:	6442                	ld	s0,16(sp)
    8000359e:	64a2                	ld	s1,8(sp)
    800035a0:	6902                	ld	s2,0(sp)
    800035a2:	6105                	addi	sp,sp,32
    800035a4:	8082                	ret

00000000800035a6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a6:	00035797          	auipc	a5,0x35
    800035aa:	3fe7a783          	lw	a5,1022(a5) # 800389a4 <log+0x2c>
    800035ae:	0af05d63          	blez	a5,80003668 <install_trans+0xc2>
{
    800035b2:	7139                	addi	sp,sp,-64
    800035b4:	fc06                	sd	ra,56(sp)
    800035b6:	f822                	sd	s0,48(sp)
    800035b8:	f426                	sd	s1,40(sp)
    800035ba:	f04a                	sd	s2,32(sp)
    800035bc:	ec4e                	sd	s3,24(sp)
    800035be:	e852                	sd	s4,16(sp)
    800035c0:	e456                	sd	s5,8(sp)
    800035c2:	e05a                	sd	s6,0(sp)
    800035c4:	0080                	addi	s0,sp,64
    800035c6:	8b2a                	mv	s6,a0
    800035c8:	00035a97          	auipc	s5,0x35
    800035cc:	3e0a8a93          	addi	s5,s5,992 # 800389a8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d2:	00035997          	auipc	s3,0x35
    800035d6:	3a698993          	addi	s3,s3,934 # 80038978 <log>
    800035da:	a00d                	j	800035fc <install_trans+0x56>
    brelse(lbuf);
    800035dc:	854a                	mv	a0,s2
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	09e080e7          	jalr	158(ra) # 8000267c <brelse>
    brelse(dbuf);
    800035e6:	8526                	mv	a0,s1
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	094080e7          	jalr	148(ra) # 8000267c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f0:	2a05                	addiw	s4,s4,1
    800035f2:	0a91                	addi	s5,s5,4
    800035f4:	02c9a783          	lw	a5,44(s3)
    800035f8:	04fa5e63          	bge	s4,a5,80003654 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035fc:	0189a583          	lw	a1,24(s3)
    80003600:	014585bb          	addw	a1,a1,s4
    80003604:	2585                	addiw	a1,a1,1
    80003606:	0289a503          	lw	a0,40(s3)
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	f42080e7          	jalr	-190(ra) # 8000254c <bread>
    80003612:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003614:	000aa583          	lw	a1,0(s5)
    80003618:	0289a503          	lw	a0,40(s3)
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	f30080e7          	jalr	-208(ra) # 8000254c <bread>
    80003624:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003626:	40000613          	li	a2,1024
    8000362a:	05890593          	addi	a1,s2,88
    8000362e:	05850513          	addi	a0,a0,88
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	cae080e7          	jalr	-850(ra) # 800002e0 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000363a:	8526                	mv	a0,s1
    8000363c:	fffff097          	auipc	ra,0xfffff
    80003640:	002080e7          	jalr	2(ra) # 8000263e <bwrite>
    if(recovering == 0)
    80003644:	f80b1ce3          	bnez	s6,800035dc <install_trans+0x36>
      bunpin(dbuf);
    80003648:	8526                	mv	a0,s1
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	10a080e7          	jalr	266(ra) # 80002754 <bunpin>
    80003652:	b769                	j	800035dc <install_trans+0x36>
}
    80003654:	70e2                	ld	ra,56(sp)
    80003656:	7442                	ld	s0,48(sp)
    80003658:	74a2                	ld	s1,40(sp)
    8000365a:	7902                	ld	s2,32(sp)
    8000365c:	69e2                	ld	s3,24(sp)
    8000365e:	6a42                	ld	s4,16(sp)
    80003660:	6aa2                	ld	s5,8(sp)
    80003662:	6b02                	ld	s6,0(sp)
    80003664:	6121                	addi	sp,sp,64
    80003666:	8082                	ret
    80003668:	8082                	ret

000000008000366a <initlog>:
{
    8000366a:	7179                	addi	sp,sp,-48
    8000366c:	f406                	sd	ra,40(sp)
    8000366e:	f022                	sd	s0,32(sp)
    80003670:	ec26                	sd	s1,24(sp)
    80003672:	e84a                	sd	s2,16(sp)
    80003674:	e44e                	sd	s3,8(sp)
    80003676:	1800                	addi	s0,sp,48
    80003678:	892a                	mv	s2,a0
    8000367a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000367c:	00035497          	auipc	s1,0x35
    80003680:	2fc48493          	addi	s1,s1,764 # 80038978 <log>
    80003684:	00005597          	auipc	a1,0x5
    80003688:	fb458593          	addi	a1,a1,-76 # 80008638 <syscalls+0x1d8>
    8000368c:	8526                	mv	a0,s1
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	bd0080e7          	jalr	-1072(ra) # 8000625e <initlock>
  log.start = sb->logstart;
    80003696:	0149a583          	lw	a1,20(s3)
    8000369a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000369c:	0109a783          	lw	a5,16(s3)
    800036a0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036a2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036a6:	854a                	mv	a0,s2
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	ea4080e7          	jalr	-348(ra) # 8000254c <bread>
  log.lh.n = lh->n;
    800036b0:	4d30                	lw	a2,88(a0)
    800036b2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036b4:	00c05f63          	blez	a2,800036d2 <initlog+0x68>
    800036b8:	87aa                	mv	a5,a0
    800036ba:	00035717          	auipc	a4,0x35
    800036be:	2ee70713          	addi	a4,a4,750 # 800389a8 <log+0x30>
    800036c2:	060a                	slli	a2,a2,0x2
    800036c4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036c6:	4ff4                	lw	a3,92(a5)
    800036c8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036ca:	0791                	addi	a5,a5,4
    800036cc:	0711                	addi	a4,a4,4
    800036ce:	fec79ce3          	bne	a5,a2,800036c6 <initlog+0x5c>
  brelse(buf);
    800036d2:	fffff097          	auipc	ra,0xfffff
    800036d6:	faa080e7          	jalr	-86(ra) # 8000267c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036da:	4505                	li	a0,1
    800036dc:	00000097          	auipc	ra,0x0
    800036e0:	eca080e7          	jalr	-310(ra) # 800035a6 <install_trans>
  log.lh.n = 0;
    800036e4:	00035797          	auipc	a5,0x35
    800036e8:	2c07a023          	sw	zero,704(a5) # 800389a4 <log+0x2c>
  write_head(); // clear the log
    800036ec:	00000097          	auipc	ra,0x0
    800036f0:	e50080e7          	jalr	-432(ra) # 8000353c <write_head>
}
    800036f4:	70a2                	ld	ra,40(sp)
    800036f6:	7402                	ld	s0,32(sp)
    800036f8:	64e2                	ld	s1,24(sp)
    800036fa:	6942                	ld	s2,16(sp)
    800036fc:	69a2                	ld	s3,8(sp)
    800036fe:	6145                	addi	sp,sp,48
    80003700:	8082                	ret

0000000080003702 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003702:	1101                	addi	sp,sp,-32
    80003704:	ec06                	sd	ra,24(sp)
    80003706:	e822                	sd	s0,16(sp)
    80003708:	e426                	sd	s1,8(sp)
    8000370a:	e04a                	sd	s2,0(sp)
    8000370c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000370e:	00035517          	auipc	a0,0x35
    80003712:	26a50513          	addi	a0,a0,618 # 80038978 <log>
    80003716:	00003097          	auipc	ra,0x3
    8000371a:	bd8080e7          	jalr	-1064(ra) # 800062ee <acquire>
  while(1){
    if(log.committing){
    8000371e:	00035497          	auipc	s1,0x35
    80003722:	25a48493          	addi	s1,s1,602 # 80038978 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003726:	4979                	li	s2,30
    80003728:	a039                	j	80003736 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000372a:	85a6                	mv	a1,s1
    8000372c:	8526                	mv	a0,s1
    8000372e:	ffffe097          	auipc	ra,0xffffe
    80003732:	00a080e7          	jalr	10(ra) # 80001738 <sleep>
    if(log.committing){
    80003736:	50dc                	lw	a5,36(s1)
    80003738:	fbed                	bnez	a5,8000372a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000373a:	5098                	lw	a4,32(s1)
    8000373c:	2705                	addiw	a4,a4,1
    8000373e:	0027179b          	slliw	a5,a4,0x2
    80003742:	9fb9                	addw	a5,a5,a4
    80003744:	0017979b          	slliw	a5,a5,0x1
    80003748:	54d4                	lw	a3,44(s1)
    8000374a:	9fb5                	addw	a5,a5,a3
    8000374c:	00f95963          	bge	s2,a5,8000375e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003750:	85a6                	mv	a1,s1
    80003752:	8526                	mv	a0,s1
    80003754:	ffffe097          	auipc	ra,0xffffe
    80003758:	fe4080e7          	jalr	-28(ra) # 80001738 <sleep>
    8000375c:	bfe9                	j	80003736 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000375e:	00035517          	auipc	a0,0x35
    80003762:	21a50513          	addi	a0,a0,538 # 80038978 <log>
    80003766:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	c3a080e7          	jalr	-966(ra) # 800063a2 <release>
      break;
    }
  }
}
    80003770:	60e2                	ld	ra,24(sp)
    80003772:	6442                	ld	s0,16(sp)
    80003774:	64a2                	ld	s1,8(sp)
    80003776:	6902                	ld	s2,0(sp)
    80003778:	6105                	addi	sp,sp,32
    8000377a:	8082                	ret

000000008000377c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000377c:	7139                	addi	sp,sp,-64
    8000377e:	fc06                	sd	ra,56(sp)
    80003780:	f822                	sd	s0,48(sp)
    80003782:	f426                	sd	s1,40(sp)
    80003784:	f04a                	sd	s2,32(sp)
    80003786:	ec4e                	sd	s3,24(sp)
    80003788:	e852                	sd	s4,16(sp)
    8000378a:	e456                	sd	s5,8(sp)
    8000378c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000378e:	00035497          	auipc	s1,0x35
    80003792:	1ea48493          	addi	s1,s1,490 # 80038978 <log>
    80003796:	8526                	mv	a0,s1
    80003798:	00003097          	auipc	ra,0x3
    8000379c:	b56080e7          	jalr	-1194(ra) # 800062ee <acquire>
  log.outstanding -= 1;
    800037a0:	509c                	lw	a5,32(s1)
    800037a2:	37fd                	addiw	a5,a5,-1
    800037a4:	0007891b          	sext.w	s2,a5
    800037a8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037aa:	50dc                	lw	a5,36(s1)
    800037ac:	e7b9                	bnez	a5,800037fa <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ae:	04091e63          	bnez	s2,8000380a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037b2:	00035497          	auipc	s1,0x35
    800037b6:	1c648493          	addi	s1,s1,454 # 80038978 <log>
    800037ba:	4785                	li	a5,1
    800037bc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037be:	8526                	mv	a0,s1
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	be2080e7          	jalr	-1054(ra) # 800063a2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037c8:	54dc                	lw	a5,44(s1)
    800037ca:	06f04763          	bgtz	a5,80003838 <end_op+0xbc>
    acquire(&log.lock);
    800037ce:	00035497          	auipc	s1,0x35
    800037d2:	1aa48493          	addi	s1,s1,426 # 80038978 <log>
    800037d6:	8526                	mv	a0,s1
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	b16080e7          	jalr	-1258(ra) # 800062ee <acquire>
    log.committing = 0;
    800037e0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037e4:	8526                	mv	a0,s1
    800037e6:	ffffe097          	auipc	ra,0xffffe
    800037ea:	fb6080e7          	jalr	-74(ra) # 8000179c <wakeup>
    release(&log.lock);
    800037ee:	8526                	mv	a0,s1
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	bb2080e7          	jalr	-1102(ra) # 800063a2 <release>
}
    800037f8:	a03d                	j	80003826 <end_op+0xaa>
    panic("log.committing");
    800037fa:	00005517          	auipc	a0,0x5
    800037fe:	e4650513          	addi	a0,a0,-442 # 80008640 <syscalls+0x1e0>
    80003802:	00002097          	auipc	ra,0x2
    80003806:	5b4080e7          	jalr	1460(ra) # 80005db6 <panic>
    wakeup(&log);
    8000380a:	00035497          	auipc	s1,0x35
    8000380e:	16e48493          	addi	s1,s1,366 # 80038978 <log>
    80003812:	8526                	mv	a0,s1
    80003814:	ffffe097          	auipc	ra,0xffffe
    80003818:	f88080e7          	jalr	-120(ra) # 8000179c <wakeup>
  release(&log.lock);
    8000381c:	8526                	mv	a0,s1
    8000381e:	00003097          	auipc	ra,0x3
    80003822:	b84080e7          	jalr	-1148(ra) # 800063a2 <release>
}
    80003826:	70e2                	ld	ra,56(sp)
    80003828:	7442                	ld	s0,48(sp)
    8000382a:	74a2                	ld	s1,40(sp)
    8000382c:	7902                	ld	s2,32(sp)
    8000382e:	69e2                	ld	s3,24(sp)
    80003830:	6a42                	ld	s4,16(sp)
    80003832:	6aa2                	ld	s5,8(sp)
    80003834:	6121                	addi	sp,sp,64
    80003836:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003838:	00035a97          	auipc	s5,0x35
    8000383c:	170a8a93          	addi	s5,s5,368 # 800389a8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003840:	00035a17          	auipc	s4,0x35
    80003844:	138a0a13          	addi	s4,s4,312 # 80038978 <log>
    80003848:	018a2583          	lw	a1,24(s4)
    8000384c:	012585bb          	addw	a1,a1,s2
    80003850:	2585                	addiw	a1,a1,1
    80003852:	028a2503          	lw	a0,40(s4)
    80003856:	fffff097          	auipc	ra,0xfffff
    8000385a:	cf6080e7          	jalr	-778(ra) # 8000254c <bread>
    8000385e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003860:	000aa583          	lw	a1,0(s5)
    80003864:	028a2503          	lw	a0,40(s4)
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	ce4080e7          	jalr	-796(ra) # 8000254c <bread>
    80003870:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003872:	40000613          	li	a2,1024
    80003876:	05850593          	addi	a1,a0,88
    8000387a:	05848513          	addi	a0,s1,88
    8000387e:	ffffd097          	auipc	ra,0xffffd
    80003882:	a62080e7          	jalr	-1438(ra) # 800002e0 <memmove>
    bwrite(to);  // write the log
    80003886:	8526                	mv	a0,s1
    80003888:	fffff097          	auipc	ra,0xfffff
    8000388c:	db6080e7          	jalr	-586(ra) # 8000263e <bwrite>
    brelse(from);
    80003890:	854e                	mv	a0,s3
    80003892:	fffff097          	auipc	ra,0xfffff
    80003896:	dea080e7          	jalr	-534(ra) # 8000267c <brelse>
    brelse(to);
    8000389a:	8526                	mv	a0,s1
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	de0080e7          	jalr	-544(ra) # 8000267c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038a4:	2905                	addiw	s2,s2,1
    800038a6:	0a91                	addi	s5,s5,4
    800038a8:	02ca2783          	lw	a5,44(s4)
    800038ac:	f8f94ee3          	blt	s2,a5,80003848 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038b0:	00000097          	auipc	ra,0x0
    800038b4:	c8c080e7          	jalr	-884(ra) # 8000353c <write_head>
    install_trans(0); // Now install writes to home locations
    800038b8:	4501                	li	a0,0
    800038ba:	00000097          	auipc	ra,0x0
    800038be:	cec080e7          	jalr	-788(ra) # 800035a6 <install_trans>
    log.lh.n = 0;
    800038c2:	00035797          	auipc	a5,0x35
    800038c6:	0e07a123          	sw	zero,226(a5) # 800389a4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038ca:	00000097          	auipc	ra,0x0
    800038ce:	c72080e7          	jalr	-910(ra) # 8000353c <write_head>
    800038d2:	bdf5                	j	800037ce <end_op+0x52>

00000000800038d4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038d4:	1101                	addi	sp,sp,-32
    800038d6:	ec06                	sd	ra,24(sp)
    800038d8:	e822                	sd	s0,16(sp)
    800038da:	e426                	sd	s1,8(sp)
    800038dc:	e04a                	sd	s2,0(sp)
    800038de:	1000                	addi	s0,sp,32
    800038e0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038e2:	00035917          	auipc	s2,0x35
    800038e6:	09690913          	addi	s2,s2,150 # 80038978 <log>
    800038ea:	854a                	mv	a0,s2
    800038ec:	00003097          	auipc	ra,0x3
    800038f0:	a02080e7          	jalr	-1534(ra) # 800062ee <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038f4:	02c92603          	lw	a2,44(s2)
    800038f8:	47f5                	li	a5,29
    800038fa:	06c7c563          	blt	a5,a2,80003964 <log_write+0x90>
    800038fe:	00035797          	auipc	a5,0x35
    80003902:	0967a783          	lw	a5,150(a5) # 80038994 <log+0x1c>
    80003906:	37fd                	addiw	a5,a5,-1
    80003908:	04f65e63          	bge	a2,a5,80003964 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000390c:	00035797          	auipc	a5,0x35
    80003910:	08c7a783          	lw	a5,140(a5) # 80038998 <log+0x20>
    80003914:	06f05063          	blez	a5,80003974 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003918:	4781                	li	a5,0
    8000391a:	06c05563          	blez	a2,80003984 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000391e:	44cc                	lw	a1,12(s1)
    80003920:	00035717          	auipc	a4,0x35
    80003924:	08870713          	addi	a4,a4,136 # 800389a8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003928:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000392a:	4314                	lw	a3,0(a4)
    8000392c:	04b68c63          	beq	a3,a1,80003984 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003930:	2785                	addiw	a5,a5,1
    80003932:	0711                	addi	a4,a4,4
    80003934:	fef61be3          	bne	a2,a5,8000392a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003938:	0621                	addi	a2,a2,8
    8000393a:	060a                	slli	a2,a2,0x2
    8000393c:	00035797          	auipc	a5,0x35
    80003940:	03c78793          	addi	a5,a5,60 # 80038978 <log>
    80003944:	97b2                	add	a5,a5,a2
    80003946:	44d8                	lw	a4,12(s1)
    80003948:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000394a:	8526                	mv	a0,s1
    8000394c:	fffff097          	auipc	ra,0xfffff
    80003950:	dcc080e7          	jalr	-564(ra) # 80002718 <bpin>
    log.lh.n++;
    80003954:	00035717          	auipc	a4,0x35
    80003958:	02470713          	addi	a4,a4,36 # 80038978 <log>
    8000395c:	575c                	lw	a5,44(a4)
    8000395e:	2785                	addiw	a5,a5,1
    80003960:	d75c                	sw	a5,44(a4)
    80003962:	a82d                	j	8000399c <log_write+0xc8>
    panic("too big a transaction");
    80003964:	00005517          	auipc	a0,0x5
    80003968:	cec50513          	addi	a0,a0,-788 # 80008650 <syscalls+0x1f0>
    8000396c:	00002097          	auipc	ra,0x2
    80003970:	44a080e7          	jalr	1098(ra) # 80005db6 <panic>
    panic("log_write outside of trans");
    80003974:	00005517          	auipc	a0,0x5
    80003978:	cf450513          	addi	a0,a0,-780 # 80008668 <syscalls+0x208>
    8000397c:	00002097          	auipc	ra,0x2
    80003980:	43a080e7          	jalr	1082(ra) # 80005db6 <panic>
  log.lh.block[i] = b->blockno;
    80003984:	00878693          	addi	a3,a5,8
    80003988:	068a                	slli	a3,a3,0x2
    8000398a:	00035717          	auipc	a4,0x35
    8000398e:	fee70713          	addi	a4,a4,-18 # 80038978 <log>
    80003992:	9736                	add	a4,a4,a3
    80003994:	44d4                	lw	a3,12(s1)
    80003996:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003998:	faf609e3          	beq	a2,a5,8000394a <log_write+0x76>
  }
  release(&log.lock);
    8000399c:	00035517          	auipc	a0,0x35
    800039a0:	fdc50513          	addi	a0,a0,-36 # 80038978 <log>
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	9fe080e7          	jalr	-1538(ra) # 800063a2 <release>
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
    800039c6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039c8:	00005597          	auipc	a1,0x5
    800039cc:	cc058593          	addi	a1,a1,-832 # 80008688 <syscalls+0x228>
    800039d0:	0521                	addi	a0,a0,8
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	88c080e7          	jalr	-1908(ra) # 8000625e <initlock>
  lk->name = name;
    800039da:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039de:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039e2:	0204a423          	sw	zero,40(s1)
}
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6902                	ld	s2,0(sp)
    800039ee:	6105                	addi	sp,sp,32
    800039f0:	8082                	ret

00000000800039f2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	e04a                	sd	s2,0(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a00:	00850913          	addi	s2,a0,8
    80003a04:	854a                	mv	a0,s2
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	8e8080e7          	jalr	-1816(ra) # 800062ee <acquire>
  while (lk->locked) {
    80003a0e:	409c                	lw	a5,0(s1)
    80003a10:	cb89                	beqz	a5,80003a22 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a12:	85ca                	mv	a1,s2
    80003a14:	8526                	mv	a0,s1
    80003a16:	ffffe097          	auipc	ra,0xffffe
    80003a1a:	d22080e7          	jalr	-734(ra) # 80001738 <sleep>
  while (lk->locked) {
    80003a1e:	409c                	lw	a5,0(s1)
    80003a20:	fbed                	bnez	a5,80003a12 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a22:	4785                	li	a5,1
    80003a24:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a26:	ffffd097          	auipc	ra,0xffffd
    80003a2a:	66a080e7          	jalr	1642(ra) # 80001090 <myproc>
    80003a2e:	591c                	lw	a5,48(a0)
    80003a30:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a32:	854a                	mv	a0,s2
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	96e080e7          	jalr	-1682(ra) # 800063a2 <release>
}
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6902                	ld	s2,0(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	e04a                	sd	s2,0(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a56:	00850913          	addi	s2,a0,8
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	892080e7          	jalr	-1902(ra) # 800062ee <acquire>
  lk->locked = 0;
    80003a64:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a68:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	ffffe097          	auipc	ra,0xffffe
    80003a72:	d2e080e7          	jalr	-722(ra) # 8000179c <wakeup>
  release(&lk->lk);
    80003a76:	854a                	mv	a0,s2
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	92a080e7          	jalr	-1750(ra) # 800063a2 <release>
}
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6902                	ld	s2,0(sp)
    80003a88:	6105                	addi	sp,sp,32
    80003a8a:	8082                	ret

0000000080003a8c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a8c:	7179                	addi	sp,sp,-48
    80003a8e:	f406                	sd	ra,40(sp)
    80003a90:	f022                	sd	s0,32(sp)
    80003a92:	ec26                	sd	s1,24(sp)
    80003a94:	e84a                	sd	s2,16(sp)
    80003a96:	e44e                	sd	s3,8(sp)
    80003a98:	1800                	addi	s0,sp,48
    80003a9a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a9c:	00850913          	addi	s2,a0,8
    80003aa0:	854a                	mv	a0,s2
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	84c080e7          	jalr	-1972(ra) # 800062ee <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aaa:	409c                	lw	a5,0(s1)
    80003aac:	ef99                	bnez	a5,80003aca <holdingsleep+0x3e>
    80003aae:	4481                	li	s1,0
  release(&lk->lk);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	8f0080e7          	jalr	-1808(ra) # 800063a2 <release>
  return r;
}
    80003aba:	8526                	mv	a0,s1
    80003abc:	70a2                	ld	ra,40(sp)
    80003abe:	7402                	ld	s0,32(sp)
    80003ac0:	64e2                	ld	s1,24(sp)
    80003ac2:	6942                	ld	s2,16(sp)
    80003ac4:	69a2                	ld	s3,8(sp)
    80003ac6:	6145                	addi	sp,sp,48
    80003ac8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aca:	0284a983          	lw	s3,40(s1)
    80003ace:	ffffd097          	auipc	ra,0xffffd
    80003ad2:	5c2080e7          	jalr	1474(ra) # 80001090 <myproc>
    80003ad6:	5904                	lw	s1,48(a0)
    80003ad8:	413484b3          	sub	s1,s1,s3
    80003adc:	0014b493          	seqz	s1,s1
    80003ae0:	bfc1                	j	80003ab0 <holdingsleep+0x24>

0000000080003ae2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ae2:	1141                	addi	sp,sp,-16
    80003ae4:	e406                	sd	ra,8(sp)
    80003ae6:	e022                	sd	s0,0(sp)
    80003ae8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003aea:	00005597          	auipc	a1,0x5
    80003aee:	bae58593          	addi	a1,a1,-1106 # 80008698 <syscalls+0x238>
    80003af2:	00035517          	auipc	a0,0x35
    80003af6:	fce50513          	addi	a0,a0,-50 # 80038ac0 <ftable>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	764080e7          	jalr	1892(ra) # 8000625e <initlock>
}
    80003b02:	60a2                	ld	ra,8(sp)
    80003b04:	6402                	ld	s0,0(sp)
    80003b06:	0141                	addi	sp,sp,16
    80003b08:	8082                	ret

0000000080003b0a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b0a:	1101                	addi	sp,sp,-32
    80003b0c:	ec06                	sd	ra,24(sp)
    80003b0e:	e822                	sd	s0,16(sp)
    80003b10:	e426                	sd	s1,8(sp)
    80003b12:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b14:	00035517          	auipc	a0,0x35
    80003b18:	fac50513          	addi	a0,a0,-84 # 80038ac0 <ftable>
    80003b1c:	00002097          	auipc	ra,0x2
    80003b20:	7d2080e7          	jalr	2002(ra) # 800062ee <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b24:	00035497          	auipc	s1,0x35
    80003b28:	fb448493          	addi	s1,s1,-76 # 80038ad8 <ftable+0x18>
    80003b2c:	00036717          	auipc	a4,0x36
    80003b30:	f4c70713          	addi	a4,a4,-180 # 80039a78 <disk>
    if(f->ref == 0){
    80003b34:	40dc                	lw	a5,4(s1)
    80003b36:	cf99                	beqz	a5,80003b54 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b38:	02848493          	addi	s1,s1,40
    80003b3c:	fee49ce3          	bne	s1,a4,80003b34 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b40:	00035517          	auipc	a0,0x35
    80003b44:	f8050513          	addi	a0,a0,-128 # 80038ac0 <ftable>
    80003b48:	00003097          	auipc	ra,0x3
    80003b4c:	85a080e7          	jalr	-1958(ra) # 800063a2 <release>
  return 0;
    80003b50:	4481                	li	s1,0
    80003b52:	a819                	j	80003b68 <filealloc+0x5e>
      f->ref = 1;
    80003b54:	4785                	li	a5,1
    80003b56:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b58:	00035517          	auipc	a0,0x35
    80003b5c:	f6850513          	addi	a0,a0,-152 # 80038ac0 <ftable>
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	842080e7          	jalr	-1982(ra) # 800063a2 <release>
}
    80003b68:	8526                	mv	a0,s1
    80003b6a:	60e2                	ld	ra,24(sp)
    80003b6c:	6442                	ld	s0,16(sp)
    80003b6e:	64a2                	ld	s1,8(sp)
    80003b70:	6105                	addi	sp,sp,32
    80003b72:	8082                	ret

0000000080003b74 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b74:	1101                	addi	sp,sp,-32
    80003b76:	ec06                	sd	ra,24(sp)
    80003b78:	e822                	sd	s0,16(sp)
    80003b7a:	e426                	sd	s1,8(sp)
    80003b7c:	1000                	addi	s0,sp,32
    80003b7e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b80:	00035517          	auipc	a0,0x35
    80003b84:	f4050513          	addi	a0,a0,-192 # 80038ac0 <ftable>
    80003b88:	00002097          	auipc	ra,0x2
    80003b8c:	766080e7          	jalr	1894(ra) # 800062ee <acquire>
  if(f->ref < 1)
    80003b90:	40dc                	lw	a5,4(s1)
    80003b92:	02f05263          	blez	a5,80003bb6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b96:	2785                	addiw	a5,a5,1
    80003b98:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b9a:	00035517          	auipc	a0,0x35
    80003b9e:	f2650513          	addi	a0,a0,-218 # 80038ac0 <ftable>
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	800080e7          	jalr	-2048(ra) # 800063a2 <release>
  return f;
}
    80003baa:	8526                	mv	a0,s1
    80003bac:	60e2                	ld	ra,24(sp)
    80003bae:	6442                	ld	s0,16(sp)
    80003bb0:	64a2                	ld	s1,8(sp)
    80003bb2:	6105                	addi	sp,sp,32
    80003bb4:	8082                	ret
    panic("filedup");
    80003bb6:	00005517          	auipc	a0,0x5
    80003bba:	aea50513          	addi	a0,a0,-1302 # 800086a0 <syscalls+0x240>
    80003bbe:	00002097          	auipc	ra,0x2
    80003bc2:	1f8080e7          	jalr	504(ra) # 80005db6 <panic>

0000000080003bc6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bc6:	7139                	addi	sp,sp,-64
    80003bc8:	fc06                	sd	ra,56(sp)
    80003bca:	f822                	sd	s0,48(sp)
    80003bcc:	f426                	sd	s1,40(sp)
    80003bce:	f04a                	sd	s2,32(sp)
    80003bd0:	ec4e                	sd	s3,24(sp)
    80003bd2:	e852                	sd	s4,16(sp)
    80003bd4:	e456                	sd	s5,8(sp)
    80003bd6:	0080                	addi	s0,sp,64
    80003bd8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bda:	00035517          	auipc	a0,0x35
    80003bde:	ee650513          	addi	a0,a0,-282 # 80038ac0 <ftable>
    80003be2:	00002097          	auipc	ra,0x2
    80003be6:	70c080e7          	jalr	1804(ra) # 800062ee <acquire>
  if(f->ref < 1)
    80003bea:	40dc                	lw	a5,4(s1)
    80003bec:	06f05163          	blez	a5,80003c4e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bf0:	37fd                	addiw	a5,a5,-1
    80003bf2:	0007871b          	sext.w	a4,a5
    80003bf6:	c0dc                	sw	a5,4(s1)
    80003bf8:	06e04363          	bgtz	a4,80003c5e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bfc:	0004a903          	lw	s2,0(s1)
    80003c00:	0094ca83          	lbu	s5,9(s1)
    80003c04:	0104ba03          	ld	s4,16(s1)
    80003c08:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c0c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c10:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c14:	00035517          	auipc	a0,0x35
    80003c18:	eac50513          	addi	a0,a0,-340 # 80038ac0 <ftable>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	786080e7          	jalr	1926(ra) # 800063a2 <release>

  if(ff.type == FD_PIPE){
    80003c24:	4785                	li	a5,1
    80003c26:	04f90d63          	beq	s2,a5,80003c80 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c2a:	3979                	addiw	s2,s2,-2
    80003c2c:	4785                	li	a5,1
    80003c2e:	0527e063          	bltu	a5,s2,80003c6e <fileclose+0xa8>
    begin_op();
    80003c32:	00000097          	auipc	ra,0x0
    80003c36:	ad0080e7          	jalr	-1328(ra) # 80003702 <begin_op>
    iput(ff.ip);
    80003c3a:	854e                	mv	a0,s3
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	2da080e7          	jalr	730(ra) # 80002f16 <iput>
    end_op();
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	b38080e7          	jalr	-1224(ra) # 8000377c <end_op>
    80003c4c:	a00d                	j	80003c6e <fileclose+0xa8>
    panic("fileclose");
    80003c4e:	00005517          	auipc	a0,0x5
    80003c52:	a5a50513          	addi	a0,a0,-1446 # 800086a8 <syscalls+0x248>
    80003c56:	00002097          	auipc	ra,0x2
    80003c5a:	160080e7          	jalr	352(ra) # 80005db6 <panic>
    release(&ftable.lock);
    80003c5e:	00035517          	auipc	a0,0x35
    80003c62:	e6250513          	addi	a0,a0,-414 # 80038ac0 <ftable>
    80003c66:	00002097          	auipc	ra,0x2
    80003c6a:	73c080e7          	jalr	1852(ra) # 800063a2 <release>
  }
}
    80003c6e:	70e2                	ld	ra,56(sp)
    80003c70:	7442                	ld	s0,48(sp)
    80003c72:	74a2                	ld	s1,40(sp)
    80003c74:	7902                	ld	s2,32(sp)
    80003c76:	69e2                	ld	s3,24(sp)
    80003c78:	6a42                	ld	s4,16(sp)
    80003c7a:	6aa2                	ld	s5,8(sp)
    80003c7c:	6121                	addi	sp,sp,64
    80003c7e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c80:	85d6                	mv	a1,s5
    80003c82:	8552                	mv	a0,s4
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	348080e7          	jalr	840(ra) # 80003fcc <pipeclose>
    80003c8c:	b7cd                	j	80003c6e <fileclose+0xa8>

0000000080003c8e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c8e:	715d                	addi	sp,sp,-80
    80003c90:	e486                	sd	ra,72(sp)
    80003c92:	e0a2                	sd	s0,64(sp)
    80003c94:	fc26                	sd	s1,56(sp)
    80003c96:	f84a                	sd	s2,48(sp)
    80003c98:	f44e                	sd	s3,40(sp)
    80003c9a:	0880                	addi	s0,sp,80
    80003c9c:	84aa                	mv	s1,a0
    80003c9e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ca0:	ffffd097          	auipc	ra,0xffffd
    80003ca4:	3f0080e7          	jalr	1008(ra) # 80001090 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ca8:	409c                	lw	a5,0(s1)
    80003caa:	37f9                	addiw	a5,a5,-2
    80003cac:	4705                	li	a4,1
    80003cae:	04f76763          	bltu	a4,a5,80003cfc <filestat+0x6e>
    80003cb2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cb4:	6c88                	ld	a0,24(s1)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	0a6080e7          	jalr	166(ra) # 80002d5c <ilock>
    stati(f->ip, &st);
    80003cbe:	fb840593          	addi	a1,s0,-72
    80003cc2:	6c88                	ld	a0,24(s1)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	322080e7          	jalr	802(ra) # 80002fe6 <stati>
    iunlock(f->ip);
    80003ccc:	6c88                	ld	a0,24(s1)
    80003cce:	fffff097          	auipc	ra,0xfffff
    80003cd2:	150080e7          	jalr	336(ra) # 80002e1e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cd6:	46e1                	li	a3,24
    80003cd8:	fb840613          	addi	a2,s0,-72
    80003cdc:	85ce                	mv	a1,s3
    80003cde:	05093503          	ld	a0,80(s2)
    80003ce2:	ffffd097          	auipc	ra,0xffffd
    80003ce6:	17a080e7          	jalr	378(ra) # 80000e5c <copyout>
    80003cea:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cee:	60a6                	ld	ra,72(sp)
    80003cf0:	6406                	ld	s0,64(sp)
    80003cf2:	74e2                	ld	s1,56(sp)
    80003cf4:	7942                	ld	s2,48(sp)
    80003cf6:	79a2                	ld	s3,40(sp)
    80003cf8:	6161                	addi	sp,sp,80
    80003cfa:	8082                	ret
  return -1;
    80003cfc:	557d                	li	a0,-1
    80003cfe:	bfc5                	j	80003cee <filestat+0x60>

0000000080003d00 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d00:	7179                	addi	sp,sp,-48
    80003d02:	f406                	sd	ra,40(sp)
    80003d04:	f022                	sd	s0,32(sp)
    80003d06:	ec26                	sd	s1,24(sp)
    80003d08:	e84a                	sd	s2,16(sp)
    80003d0a:	e44e                	sd	s3,8(sp)
    80003d0c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d0e:	00854783          	lbu	a5,8(a0)
    80003d12:	c3d5                	beqz	a5,80003db6 <fileread+0xb6>
    80003d14:	84aa                	mv	s1,a0
    80003d16:	89ae                	mv	s3,a1
    80003d18:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d1a:	411c                	lw	a5,0(a0)
    80003d1c:	4705                	li	a4,1
    80003d1e:	04e78963          	beq	a5,a4,80003d70 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d22:	470d                	li	a4,3
    80003d24:	04e78d63          	beq	a5,a4,80003d7e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d28:	4709                	li	a4,2
    80003d2a:	06e79e63          	bne	a5,a4,80003da6 <fileread+0xa6>
    ilock(f->ip);
    80003d2e:	6d08                	ld	a0,24(a0)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	02c080e7          	jalr	44(ra) # 80002d5c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d38:	874a                	mv	a4,s2
    80003d3a:	5094                	lw	a3,32(s1)
    80003d3c:	864e                	mv	a2,s3
    80003d3e:	4585                	li	a1,1
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	2ce080e7          	jalr	718(ra) # 80003010 <readi>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	00a05563          	blez	a0,80003d56 <fileread+0x56>
      f->off += r;
    80003d50:	509c                	lw	a5,32(s1)
    80003d52:	9fa9                	addw	a5,a5,a0
    80003d54:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d56:	6c88                	ld	a0,24(s1)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	0c6080e7          	jalr	198(ra) # 80002e1e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d60:	854a                	mv	a0,s2
    80003d62:	70a2                	ld	ra,40(sp)
    80003d64:	7402                	ld	s0,32(sp)
    80003d66:	64e2                	ld	s1,24(sp)
    80003d68:	6942                	ld	s2,16(sp)
    80003d6a:	69a2                	ld	s3,8(sp)
    80003d6c:	6145                	addi	sp,sp,48
    80003d6e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d70:	6908                	ld	a0,16(a0)
    80003d72:	00000097          	auipc	ra,0x0
    80003d76:	3c2080e7          	jalr	962(ra) # 80004134 <piperead>
    80003d7a:	892a                	mv	s2,a0
    80003d7c:	b7d5                	j	80003d60 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d7e:	02451783          	lh	a5,36(a0)
    80003d82:	03079693          	slli	a3,a5,0x30
    80003d86:	92c1                	srli	a3,a3,0x30
    80003d88:	4725                	li	a4,9
    80003d8a:	02d76863          	bltu	a4,a3,80003dba <fileread+0xba>
    80003d8e:	0792                	slli	a5,a5,0x4
    80003d90:	00035717          	auipc	a4,0x35
    80003d94:	c9070713          	addi	a4,a4,-880 # 80038a20 <devsw>
    80003d98:	97ba                	add	a5,a5,a4
    80003d9a:	639c                	ld	a5,0(a5)
    80003d9c:	c38d                	beqz	a5,80003dbe <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d9e:	4505                	li	a0,1
    80003da0:	9782                	jalr	a5
    80003da2:	892a                	mv	s2,a0
    80003da4:	bf75                	j	80003d60 <fileread+0x60>
    panic("fileread");
    80003da6:	00005517          	auipc	a0,0x5
    80003daa:	91250513          	addi	a0,a0,-1774 # 800086b8 <syscalls+0x258>
    80003dae:	00002097          	auipc	ra,0x2
    80003db2:	008080e7          	jalr	8(ra) # 80005db6 <panic>
    return -1;
    80003db6:	597d                	li	s2,-1
    80003db8:	b765                	j	80003d60 <fileread+0x60>
      return -1;
    80003dba:	597d                	li	s2,-1
    80003dbc:	b755                	j	80003d60 <fileread+0x60>
    80003dbe:	597d                	li	s2,-1
    80003dc0:	b745                	j	80003d60 <fileread+0x60>

0000000080003dc2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dc2:	00954783          	lbu	a5,9(a0)
    80003dc6:	10078e63          	beqz	a5,80003ee2 <filewrite+0x120>
{
    80003dca:	715d                	addi	sp,sp,-80
    80003dcc:	e486                	sd	ra,72(sp)
    80003dce:	e0a2                	sd	s0,64(sp)
    80003dd0:	fc26                	sd	s1,56(sp)
    80003dd2:	f84a                	sd	s2,48(sp)
    80003dd4:	f44e                	sd	s3,40(sp)
    80003dd6:	f052                	sd	s4,32(sp)
    80003dd8:	ec56                	sd	s5,24(sp)
    80003dda:	e85a                	sd	s6,16(sp)
    80003ddc:	e45e                	sd	s7,8(sp)
    80003dde:	e062                	sd	s8,0(sp)
    80003de0:	0880                	addi	s0,sp,80
    80003de2:	892a                	mv	s2,a0
    80003de4:	8b2e                	mv	s6,a1
    80003de6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de8:	411c                	lw	a5,0(a0)
    80003dea:	4705                	li	a4,1
    80003dec:	02e78263          	beq	a5,a4,80003e10 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003df0:	470d                	li	a4,3
    80003df2:	02e78563          	beq	a5,a4,80003e1c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df6:	4709                	li	a4,2
    80003df8:	0ce79d63          	bne	a5,a4,80003ed2 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dfc:	0ac05b63          	blez	a2,80003eb2 <filewrite+0xf0>
    int i = 0;
    80003e00:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e02:	6b85                	lui	s7,0x1
    80003e04:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e08:	6c05                	lui	s8,0x1
    80003e0a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e0e:	a851                	j	80003ea2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e10:	6908                	ld	a0,16(a0)
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	22a080e7          	jalr	554(ra) # 8000403c <pipewrite>
    80003e1a:	a045                	j	80003eba <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e1c:	02451783          	lh	a5,36(a0)
    80003e20:	03079693          	slli	a3,a5,0x30
    80003e24:	92c1                	srli	a3,a3,0x30
    80003e26:	4725                	li	a4,9
    80003e28:	0ad76f63          	bltu	a4,a3,80003ee6 <filewrite+0x124>
    80003e2c:	0792                	slli	a5,a5,0x4
    80003e2e:	00035717          	auipc	a4,0x35
    80003e32:	bf270713          	addi	a4,a4,-1038 # 80038a20 <devsw>
    80003e36:	97ba                	add	a5,a5,a4
    80003e38:	679c                	ld	a5,8(a5)
    80003e3a:	cbc5                	beqz	a5,80003eea <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003e3c:	4505                	li	a0,1
    80003e3e:	9782                	jalr	a5
    80003e40:	a8ad                	j	80003eba <filewrite+0xf8>
      if(n1 > max)
    80003e42:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	8bc080e7          	jalr	-1860(ra) # 80003702 <begin_op>
      ilock(f->ip);
    80003e4e:	01893503          	ld	a0,24(s2)
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	f0a080e7          	jalr	-246(ra) # 80002d5c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e5a:	8756                	mv	a4,s5
    80003e5c:	02092683          	lw	a3,32(s2)
    80003e60:	01698633          	add	a2,s3,s6
    80003e64:	4585                	li	a1,1
    80003e66:	01893503          	ld	a0,24(s2)
    80003e6a:	fffff097          	auipc	ra,0xfffff
    80003e6e:	29e080e7          	jalr	670(ra) # 80003108 <writei>
    80003e72:	84aa                	mv	s1,a0
    80003e74:	00a05763          	blez	a0,80003e82 <filewrite+0xc0>
        f->off += r;
    80003e78:	02092783          	lw	a5,32(s2)
    80003e7c:	9fa9                	addw	a5,a5,a0
    80003e7e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e82:	01893503          	ld	a0,24(s2)
    80003e86:	fffff097          	auipc	ra,0xfffff
    80003e8a:	f98080e7          	jalr	-104(ra) # 80002e1e <iunlock>
      end_op();
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	8ee080e7          	jalr	-1810(ra) # 8000377c <end_op>

      if(r != n1){
    80003e96:	009a9f63          	bne	s5,s1,80003eb4 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003e9a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e9e:	0149db63          	bge	s3,s4,80003eb4 <filewrite+0xf2>
      int n1 = n - i;
    80003ea2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003ea6:	0004879b          	sext.w	a5,s1
    80003eaa:	f8fbdce3          	bge	s7,a5,80003e42 <filewrite+0x80>
    80003eae:	84e2                	mv	s1,s8
    80003eb0:	bf49                	j	80003e42 <filewrite+0x80>
    int i = 0;
    80003eb2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eb4:	033a1d63          	bne	s4,s3,80003eee <filewrite+0x12c>
    80003eb8:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eba:	60a6                	ld	ra,72(sp)
    80003ebc:	6406                	ld	s0,64(sp)
    80003ebe:	74e2                	ld	s1,56(sp)
    80003ec0:	7942                	ld	s2,48(sp)
    80003ec2:	79a2                	ld	s3,40(sp)
    80003ec4:	7a02                	ld	s4,32(sp)
    80003ec6:	6ae2                	ld	s5,24(sp)
    80003ec8:	6b42                	ld	s6,16(sp)
    80003eca:	6ba2                	ld	s7,8(sp)
    80003ecc:	6c02                	ld	s8,0(sp)
    80003ece:	6161                	addi	sp,sp,80
    80003ed0:	8082                	ret
    panic("filewrite");
    80003ed2:	00004517          	auipc	a0,0x4
    80003ed6:	7f650513          	addi	a0,a0,2038 # 800086c8 <syscalls+0x268>
    80003eda:	00002097          	auipc	ra,0x2
    80003ede:	edc080e7          	jalr	-292(ra) # 80005db6 <panic>
    return -1;
    80003ee2:	557d                	li	a0,-1
}
    80003ee4:	8082                	ret
      return -1;
    80003ee6:	557d                	li	a0,-1
    80003ee8:	bfc9                	j	80003eba <filewrite+0xf8>
    80003eea:	557d                	li	a0,-1
    80003eec:	b7f9                	j	80003eba <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003eee:	557d                	li	a0,-1
    80003ef0:	b7e9                	j	80003eba <filewrite+0xf8>

0000000080003ef2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ef2:	7179                	addi	sp,sp,-48
    80003ef4:	f406                	sd	ra,40(sp)
    80003ef6:	f022                	sd	s0,32(sp)
    80003ef8:	ec26                	sd	s1,24(sp)
    80003efa:	e84a                	sd	s2,16(sp)
    80003efc:	e44e                	sd	s3,8(sp)
    80003efe:	e052                	sd	s4,0(sp)
    80003f00:	1800                	addi	s0,sp,48
    80003f02:	84aa                	mv	s1,a0
    80003f04:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f06:	0005b023          	sd	zero,0(a1)
    80003f0a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f0e:	00000097          	auipc	ra,0x0
    80003f12:	bfc080e7          	jalr	-1028(ra) # 80003b0a <filealloc>
    80003f16:	e088                	sd	a0,0(s1)
    80003f18:	c551                	beqz	a0,80003fa4 <pipealloc+0xb2>
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	bf0080e7          	jalr	-1040(ra) # 80003b0a <filealloc>
    80003f22:	00aa3023          	sd	a0,0(s4)
    80003f26:	c92d                	beqz	a0,80003f98 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f28:	ffffc097          	auipc	ra,0xffffc
    80003f2c:	2da080e7          	jalr	730(ra) # 80000202 <kalloc>
    80003f30:	892a                	mv	s2,a0
    80003f32:	c125                	beqz	a0,80003f92 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f34:	4985                	li	s3,1
    80003f36:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f3a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f3e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f42:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f46:	00004597          	auipc	a1,0x4
    80003f4a:	79258593          	addi	a1,a1,1938 # 800086d8 <syscalls+0x278>
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	310080e7          	jalr	784(ra) # 8000625e <initlock>
  (*f0)->type = FD_PIPE;
    80003f56:	609c                	ld	a5,0(s1)
    80003f58:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f5c:	609c                	ld	a5,0(s1)
    80003f5e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f62:	609c                	ld	a5,0(s1)
    80003f64:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f68:	609c                	ld	a5,0(s1)
    80003f6a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f6e:	000a3783          	ld	a5,0(s4)
    80003f72:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f76:	000a3783          	ld	a5,0(s4)
    80003f7a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f7e:	000a3783          	ld	a5,0(s4)
    80003f82:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f86:	000a3783          	ld	a5,0(s4)
    80003f8a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f8e:	4501                	li	a0,0
    80003f90:	a025                	j	80003fb8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f92:	6088                	ld	a0,0(s1)
    80003f94:	e501                	bnez	a0,80003f9c <pipealloc+0xaa>
    80003f96:	a039                	j	80003fa4 <pipealloc+0xb2>
    80003f98:	6088                	ld	a0,0(s1)
    80003f9a:	c51d                	beqz	a0,80003fc8 <pipealloc+0xd6>
    fileclose(*f0);
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	c2a080e7          	jalr	-982(ra) # 80003bc6 <fileclose>
  if(*f1)
    80003fa4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fa8:	557d                	li	a0,-1
  if(*f1)
    80003faa:	c799                	beqz	a5,80003fb8 <pipealloc+0xc6>
    fileclose(*f1);
    80003fac:	853e                	mv	a0,a5
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	c18080e7          	jalr	-1000(ra) # 80003bc6 <fileclose>
  return -1;
    80003fb6:	557d                	li	a0,-1
}
    80003fb8:	70a2                	ld	ra,40(sp)
    80003fba:	7402                	ld	s0,32(sp)
    80003fbc:	64e2                	ld	s1,24(sp)
    80003fbe:	6942                	ld	s2,16(sp)
    80003fc0:	69a2                	ld	s3,8(sp)
    80003fc2:	6a02                	ld	s4,0(sp)
    80003fc4:	6145                	addi	sp,sp,48
    80003fc6:	8082                	ret
  return -1;
    80003fc8:	557d                	li	a0,-1
    80003fca:	b7fd                	j	80003fb8 <pipealloc+0xc6>

0000000080003fcc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fcc:	1101                	addi	sp,sp,-32
    80003fce:	ec06                	sd	ra,24(sp)
    80003fd0:	e822                	sd	s0,16(sp)
    80003fd2:	e426                	sd	s1,8(sp)
    80003fd4:	e04a                	sd	s2,0(sp)
    80003fd6:	1000                	addi	s0,sp,32
    80003fd8:	84aa                	mv	s1,a0
    80003fda:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fdc:	00002097          	auipc	ra,0x2
    80003fe0:	312080e7          	jalr	786(ra) # 800062ee <acquire>
  if(writable){
    80003fe4:	02090d63          	beqz	s2,8000401e <pipeclose+0x52>
    pi->writeopen = 0;
    80003fe8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fec:	21848513          	addi	a0,s1,536
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	7ac080e7          	jalr	1964(ra) # 8000179c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ff8:	2204b783          	ld	a5,544(s1)
    80003ffc:	eb95                	bnez	a5,80004030 <pipeclose+0x64>
    release(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00002097          	auipc	ra,0x2
    80004004:	3a2080e7          	jalr	930(ra) # 800063a2 <release>
    kfree((char*)pi);
    80004008:	8526                	mv	a0,s1
    8000400a:	ffffc097          	auipc	ra,0xffffc
    8000400e:	0b2080e7          	jalr	178(ra) # 800000bc <kfree>
  } else
    release(&pi->lock);
}
    80004012:	60e2                	ld	ra,24(sp)
    80004014:	6442                	ld	s0,16(sp)
    80004016:	64a2                	ld	s1,8(sp)
    80004018:	6902                	ld	s2,0(sp)
    8000401a:	6105                	addi	sp,sp,32
    8000401c:	8082                	ret
    pi->readopen = 0;
    8000401e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004022:	21c48513          	addi	a0,s1,540
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	776080e7          	jalr	1910(ra) # 8000179c <wakeup>
    8000402e:	b7e9                	j	80003ff8 <pipeclose+0x2c>
    release(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	370080e7          	jalr	880(ra) # 800063a2 <release>
}
    8000403a:	bfe1                	j	80004012 <pipeclose+0x46>

000000008000403c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000403c:	711d                	addi	sp,sp,-96
    8000403e:	ec86                	sd	ra,88(sp)
    80004040:	e8a2                	sd	s0,80(sp)
    80004042:	e4a6                	sd	s1,72(sp)
    80004044:	e0ca                	sd	s2,64(sp)
    80004046:	fc4e                	sd	s3,56(sp)
    80004048:	f852                	sd	s4,48(sp)
    8000404a:	f456                	sd	s5,40(sp)
    8000404c:	f05a                	sd	s6,32(sp)
    8000404e:	ec5e                	sd	s7,24(sp)
    80004050:	e862                	sd	s8,16(sp)
    80004052:	1080                	addi	s0,sp,96
    80004054:	84aa                	mv	s1,a0
    80004056:	8aae                	mv	s5,a1
    80004058:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	036080e7          	jalr	54(ra) # 80001090 <myproc>
    80004062:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004064:	8526                	mv	a0,s1
    80004066:	00002097          	auipc	ra,0x2
    8000406a:	288080e7          	jalr	648(ra) # 800062ee <acquire>
  while(i < n){
    8000406e:	0b405663          	blez	s4,8000411a <pipewrite+0xde>
  int i = 0;
    80004072:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004074:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004076:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000407a:	21c48b93          	addi	s7,s1,540
    8000407e:	a089                	j	800040c0 <pipewrite+0x84>
      release(&pi->lock);
    80004080:	8526                	mv	a0,s1
    80004082:	00002097          	auipc	ra,0x2
    80004086:	320080e7          	jalr	800(ra) # 800063a2 <release>
      return -1;
    8000408a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000408c:	854a                	mv	a0,s2
    8000408e:	60e6                	ld	ra,88(sp)
    80004090:	6446                	ld	s0,80(sp)
    80004092:	64a6                	ld	s1,72(sp)
    80004094:	6906                	ld	s2,64(sp)
    80004096:	79e2                	ld	s3,56(sp)
    80004098:	7a42                	ld	s4,48(sp)
    8000409a:	7aa2                	ld	s5,40(sp)
    8000409c:	7b02                	ld	s6,32(sp)
    8000409e:	6be2                	ld	s7,24(sp)
    800040a0:	6c42                	ld	s8,16(sp)
    800040a2:	6125                	addi	sp,sp,96
    800040a4:	8082                	ret
      wakeup(&pi->nread);
    800040a6:	8562                	mv	a0,s8
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	6f4080e7          	jalr	1780(ra) # 8000179c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040b0:	85a6                	mv	a1,s1
    800040b2:	855e                	mv	a0,s7
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	684080e7          	jalr	1668(ra) # 80001738 <sleep>
  while(i < n){
    800040bc:	07495063          	bge	s2,s4,8000411c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    800040c0:	2204a783          	lw	a5,544(s1)
    800040c4:	dfd5                	beqz	a5,80004080 <pipewrite+0x44>
    800040c6:	854e                	mv	a0,s3
    800040c8:	ffffe097          	auipc	ra,0xffffe
    800040cc:	918080e7          	jalr	-1768(ra) # 800019e0 <killed>
    800040d0:	f945                	bnez	a0,80004080 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040d2:	2184a783          	lw	a5,536(s1)
    800040d6:	21c4a703          	lw	a4,540(s1)
    800040da:	2007879b          	addiw	a5,a5,512
    800040de:	fcf704e3          	beq	a4,a5,800040a6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040e2:	4685                	li	a3,1
    800040e4:	01590633          	add	a2,s2,s5
    800040e8:	faf40593          	addi	a1,s0,-81
    800040ec:	0509b503          	ld	a0,80(s3)
    800040f0:	ffffd097          	auipc	ra,0xffffd
    800040f4:	b22080e7          	jalr	-1246(ra) # 80000c12 <copyin>
    800040f8:	03650263          	beq	a0,s6,8000411c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040fc:	21c4a783          	lw	a5,540(s1)
    80004100:	0017871b          	addiw	a4,a5,1
    80004104:	20e4ae23          	sw	a4,540(s1)
    80004108:	1ff7f793          	andi	a5,a5,511
    8000410c:	97a6                	add	a5,a5,s1
    8000410e:	faf44703          	lbu	a4,-81(s0)
    80004112:	00e78c23          	sb	a4,24(a5)
      i++;
    80004116:	2905                	addiw	s2,s2,1
    80004118:	b755                	j	800040bc <pipewrite+0x80>
  int i = 0;
    8000411a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000411c:	21848513          	addi	a0,s1,536
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	67c080e7          	jalr	1660(ra) # 8000179c <wakeup>
  release(&pi->lock);
    80004128:	8526                	mv	a0,s1
    8000412a:	00002097          	auipc	ra,0x2
    8000412e:	278080e7          	jalr	632(ra) # 800063a2 <release>
  return i;
    80004132:	bfa9                	j	8000408c <pipewrite+0x50>

0000000080004134 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004134:	715d                	addi	sp,sp,-80
    80004136:	e486                	sd	ra,72(sp)
    80004138:	e0a2                	sd	s0,64(sp)
    8000413a:	fc26                	sd	s1,56(sp)
    8000413c:	f84a                	sd	s2,48(sp)
    8000413e:	f44e                	sd	s3,40(sp)
    80004140:	f052                	sd	s4,32(sp)
    80004142:	ec56                	sd	s5,24(sp)
    80004144:	e85a                	sd	s6,16(sp)
    80004146:	0880                	addi	s0,sp,80
    80004148:	84aa                	mv	s1,a0
    8000414a:	892e                	mv	s2,a1
    8000414c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000414e:	ffffd097          	auipc	ra,0xffffd
    80004152:	f42080e7          	jalr	-190(ra) # 80001090 <myproc>
    80004156:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004158:	8526                	mv	a0,s1
    8000415a:	00002097          	auipc	ra,0x2
    8000415e:	194080e7          	jalr	404(ra) # 800062ee <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004162:	2184a703          	lw	a4,536(s1)
    80004166:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000416a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416e:	02f71763          	bne	a4,a5,8000419c <piperead+0x68>
    80004172:	2244a783          	lw	a5,548(s1)
    80004176:	c39d                	beqz	a5,8000419c <piperead+0x68>
    if(killed(pr)){
    80004178:	8552                	mv	a0,s4
    8000417a:	ffffe097          	auipc	ra,0xffffe
    8000417e:	866080e7          	jalr	-1946(ra) # 800019e0 <killed>
    80004182:	e949                	bnez	a0,80004214 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004184:	85a6                	mv	a1,s1
    80004186:	854e                	mv	a0,s3
    80004188:	ffffd097          	auipc	ra,0xffffd
    8000418c:	5b0080e7          	jalr	1456(ra) # 80001738 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004190:	2184a703          	lw	a4,536(s1)
    80004194:	21c4a783          	lw	a5,540(s1)
    80004198:	fcf70de3          	beq	a4,a5,80004172 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000419e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a0:	05505463          	blez	s5,800041e8 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800041a4:	2184a783          	lw	a5,536(s1)
    800041a8:	21c4a703          	lw	a4,540(s1)
    800041ac:	02f70e63          	beq	a4,a5,800041e8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041b0:	0017871b          	addiw	a4,a5,1
    800041b4:	20e4ac23          	sw	a4,536(s1)
    800041b8:	1ff7f793          	andi	a5,a5,511
    800041bc:	97a6                	add	a5,a5,s1
    800041be:	0187c783          	lbu	a5,24(a5)
    800041c2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c6:	4685                	li	a3,1
    800041c8:	fbf40613          	addi	a2,s0,-65
    800041cc:	85ca                	mv	a1,s2
    800041ce:	050a3503          	ld	a0,80(s4)
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	c8a080e7          	jalr	-886(ra) # 80000e5c <copyout>
    800041da:	01650763          	beq	a0,s6,800041e8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041de:	2985                	addiw	s3,s3,1
    800041e0:	0905                	addi	s2,s2,1
    800041e2:	fd3a91e3          	bne	s5,s3,800041a4 <piperead+0x70>
    800041e6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041e8:	21c48513          	addi	a0,s1,540
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	5b0080e7          	jalr	1456(ra) # 8000179c <wakeup>
  release(&pi->lock);
    800041f4:	8526                	mv	a0,s1
    800041f6:	00002097          	auipc	ra,0x2
    800041fa:	1ac080e7          	jalr	428(ra) # 800063a2 <release>
  return i;
}
    800041fe:	854e                	mv	a0,s3
    80004200:	60a6                	ld	ra,72(sp)
    80004202:	6406                	ld	s0,64(sp)
    80004204:	74e2                	ld	s1,56(sp)
    80004206:	7942                	ld	s2,48(sp)
    80004208:	79a2                	ld	s3,40(sp)
    8000420a:	7a02                	ld	s4,32(sp)
    8000420c:	6ae2                	ld	s5,24(sp)
    8000420e:	6b42                	ld	s6,16(sp)
    80004210:	6161                	addi	sp,sp,80
    80004212:	8082                	ret
      release(&pi->lock);
    80004214:	8526                	mv	a0,s1
    80004216:	00002097          	auipc	ra,0x2
    8000421a:	18c080e7          	jalr	396(ra) # 800063a2 <release>
      return -1;
    8000421e:	59fd                	li	s3,-1
    80004220:	bff9                	j	800041fe <piperead+0xca>

0000000080004222 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004222:	1141                	addi	sp,sp,-16
    80004224:	e422                	sd	s0,8(sp)
    80004226:	0800                	addi	s0,sp,16
    80004228:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000422a:	8905                	andi	a0,a0,1
    8000422c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000422e:	8b89                	andi	a5,a5,2
    80004230:	c399                	beqz	a5,80004236 <flags2perm+0x14>
      perm |= PTE_W;
    80004232:	00456513          	ori	a0,a0,4
    return perm;
}
    80004236:	6422                	ld	s0,8(sp)
    80004238:	0141                	addi	sp,sp,16
    8000423a:	8082                	ret

000000008000423c <exec>:

int
exec(char *path, char **argv)
{
    8000423c:	df010113          	addi	sp,sp,-528
    80004240:	20113423          	sd	ra,520(sp)
    80004244:	20813023          	sd	s0,512(sp)
    80004248:	ffa6                	sd	s1,504(sp)
    8000424a:	fbca                	sd	s2,496(sp)
    8000424c:	f7ce                	sd	s3,488(sp)
    8000424e:	f3d2                	sd	s4,480(sp)
    80004250:	efd6                	sd	s5,472(sp)
    80004252:	ebda                	sd	s6,464(sp)
    80004254:	e7de                	sd	s7,456(sp)
    80004256:	e3e2                	sd	s8,448(sp)
    80004258:	ff66                	sd	s9,440(sp)
    8000425a:	fb6a                	sd	s10,432(sp)
    8000425c:	f76e                	sd	s11,424(sp)
    8000425e:	0c00                	addi	s0,sp,528
    80004260:	892a                	mv	s2,a0
    80004262:	dea43c23          	sd	a0,-520(s0)
    80004266:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000426a:	ffffd097          	auipc	ra,0xffffd
    8000426e:	e26080e7          	jalr	-474(ra) # 80001090 <myproc>
    80004272:	84aa                	mv	s1,a0

  begin_op();
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	48e080e7          	jalr	1166(ra) # 80003702 <begin_op>

  if((ip = namei(path)) == 0){
    8000427c:	854a                	mv	a0,s2
    8000427e:	fffff097          	auipc	ra,0xfffff
    80004282:	284080e7          	jalr	644(ra) # 80003502 <namei>
    80004286:	c92d                	beqz	a0,800042f8 <exec+0xbc>
    80004288:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	ad2080e7          	jalr	-1326(ra) # 80002d5c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004292:	04000713          	li	a4,64
    80004296:	4681                	li	a3,0
    80004298:	e5040613          	addi	a2,s0,-432
    8000429c:	4581                	li	a1,0
    8000429e:	8552                	mv	a0,s4
    800042a0:	fffff097          	auipc	ra,0xfffff
    800042a4:	d70080e7          	jalr	-656(ra) # 80003010 <readi>
    800042a8:	04000793          	li	a5,64
    800042ac:	00f51a63          	bne	a0,a5,800042c0 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042b0:	e5042703          	lw	a4,-432(s0)
    800042b4:	464c47b7          	lui	a5,0x464c4
    800042b8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042bc:	04f70463          	beq	a4,a5,80004304 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042c0:	8552                	mv	a0,s4
    800042c2:	fffff097          	auipc	ra,0xfffff
    800042c6:	cfc080e7          	jalr	-772(ra) # 80002fbe <iunlockput>
    end_op();
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	4b2080e7          	jalr	1202(ra) # 8000377c <end_op>
  }
  return -1;
    800042d2:	557d                	li	a0,-1
}
    800042d4:	20813083          	ld	ra,520(sp)
    800042d8:	20013403          	ld	s0,512(sp)
    800042dc:	74fe                	ld	s1,504(sp)
    800042de:	795e                	ld	s2,496(sp)
    800042e0:	79be                	ld	s3,488(sp)
    800042e2:	7a1e                	ld	s4,480(sp)
    800042e4:	6afe                	ld	s5,472(sp)
    800042e6:	6b5e                	ld	s6,464(sp)
    800042e8:	6bbe                	ld	s7,456(sp)
    800042ea:	6c1e                	ld	s8,448(sp)
    800042ec:	7cfa                	ld	s9,440(sp)
    800042ee:	7d5a                	ld	s10,432(sp)
    800042f0:	7dba                	ld	s11,424(sp)
    800042f2:	21010113          	addi	sp,sp,528
    800042f6:	8082                	ret
    end_op();
    800042f8:	fffff097          	auipc	ra,0xfffff
    800042fc:	484080e7          	jalr	1156(ra) # 8000377c <end_op>
    return -1;
    80004300:	557d                	li	a0,-1
    80004302:	bfc9                	j	800042d4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004304:	8526                	mv	a0,s1
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	e4e080e7          	jalr	-434(ra) # 80001154 <proc_pagetable>
    8000430e:	8b2a                	mv	s6,a0
    80004310:	d945                	beqz	a0,800042c0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004312:	e7042d03          	lw	s10,-400(s0)
    80004316:	e8845783          	lhu	a5,-376(s0)
    8000431a:	10078463          	beqz	a5,80004422 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000431e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004320:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004322:	6c85                	lui	s9,0x1
    80004324:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004328:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000432c:	6a85                	lui	s5,0x1
    8000432e:	a0b5                	j	8000439a <exec+0x15e>
      panic("loadseg: address should exist");
    80004330:	00004517          	auipc	a0,0x4
    80004334:	3b050513          	addi	a0,a0,944 # 800086e0 <syscalls+0x280>
    80004338:	00002097          	auipc	ra,0x2
    8000433c:	a7e080e7          	jalr	-1410(ra) # 80005db6 <panic>
    if(sz - i < PGSIZE)
    80004340:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004342:	8726                	mv	a4,s1
    80004344:	012c06bb          	addw	a3,s8,s2
    80004348:	4581                	li	a1,0
    8000434a:	8552                	mv	a0,s4
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	cc4080e7          	jalr	-828(ra) # 80003010 <readi>
    80004354:	2501                	sext.w	a0,a0
    80004356:	24a49863          	bne	s1,a0,800045a6 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    8000435a:	012a893b          	addw	s2,s5,s2
    8000435e:	03397563          	bgeu	s2,s3,80004388 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    80004362:	02091593          	slli	a1,s2,0x20
    80004366:	9181                	srli	a1,a1,0x20
    80004368:	95de                	add	a1,a1,s7
    8000436a:	855a                	mv	a0,s6
    8000436c:	ffffc097          	auipc	ra,0xffffc
    80004370:	2a0080e7          	jalr	672(ra) # 8000060c <walkaddr>
    80004374:	862a                	mv	a2,a0
    if(pa == 0)
    80004376:	dd4d                	beqz	a0,80004330 <exec+0xf4>
    if(sz - i < PGSIZE)
    80004378:	412984bb          	subw	s1,s3,s2
    8000437c:	0004879b          	sext.w	a5,s1
    80004380:	fcfcf0e3          	bgeu	s9,a5,80004340 <exec+0x104>
    80004384:	84d6                	mv	s1,s5
    80004386:	bf6d                	j	80004340 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004388:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438c:	2d85                	addiw	s11,s11,1
    8000438e:	038d0d1b          	addiw	s10,s10,56
    80004392:	e8845783          	lhu	a5,-376(s0)
    80004396:	08fdd763          	bge	s11,a5,80004424 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000439a:	2d01                	sext.w	s10,s10
    8000439c:	03800713          	li	a4,56
    800043a0:	86ea                	mv	a3,s10
    800043a2:	e1840613          	addi	a2,s0,-488
    800043a6:	4581                	li	a1,0
    800043a8:	8552                	mv	a0,s4
    800043aa:	fffff097          	auipc	ra,0xfffff
    800043ae:	c66080e7          	jalr	-922(ra) # 80003010 <readi>
    800043b2:	03800793          	li	a5,56
    800043b6:	1ef51663          	bne	a0,a5,800045a2 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    800043ba:	e1842783          	lw	a5,-488(s0)
    800043be:	4705                	li	a4,1
    800043c0:	fce796e3          	bne	a5,a4,8000438c <exec+0x150>
    if(ph.memsz < ph.filesz)
    800043c4:	e4043483          	ld	s1,-448(s0)
    800043c8:	e3843783          	ld	a5,-456(s0)
    800043cc:	1ef4e863          	bltu	s1,a5,800045bc <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043d0:	e2843783          	ld	a5,-472(s0)
    800043d4:	94be                	add	s1,s1,a5
    800043d6:	1ef4e663          	bltu	s1,a5,800045c2 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    800043da:	df043703          	ld	a4,-528(s0)
    800043de:	8ff9                	and	a5,a5,a4
    800043e0:	1e079463          	bnez	a5,800045c8 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043e4:	e1c42503          	lw	a0,-484(s0)
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	e3a080e7          	jalr	-454(ra) # 80004222 <flags2perm>
    800043f0:	86aa                	mv	a3,a0
    800043f2:	8626                	mv	a2,s1
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855a                	mv	a0,s6
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	5c8080e7          	jalr	1480(ra) # 800009c0 <uvmalloc>
    80004400:	e0a43423          	sd	a0,-504(s0)
    80004404:	1c050563          	beqz	a0,800045ce <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004408:	e2843b83          	ld	s7,-472(s0)
    8000440c:	e2042c03          	lw	s8,-480(s0)
    80004410:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004414:	00098463          	beqz	s3,8000441c <exec+0x1e0>
    80004418:	4901                	li	s2,0
    8000441a:	b7a1                	j	80004362 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000441c:	e0843903          	ld	s2,-504(s0)
    80004420:	b7b5                	j	8000438c <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004422:	4901                	li	s2,0
  iunlockput(ip);
    80004424:	8552                	mv	a0,s4
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	b98080e7          	jalr	-1128(ra) # 80002fbe <iunlockput>
  end_op();
    8000442e:	fffff097          	auipc	ra,0xfffff
    80004432:	34e080e7          	jalr	846(ra) # 8000377c <end_op>
  p = myproc();
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	c5a080e7          	jalr	-934(ra) # 80001090 <myproc>
    8000443e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004440:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004444:	6985                	lui	s3,0x1
    80004446:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004448:	99ca                	add	s3,s3,s2
    8000444a:	77fd                	lui	a5,0xfffff
    8000444c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004450:	4691                	li	a3,4
    80004452:	6609                	lui	a2,0x2
    80004454:	964e                	add	a2,a2,s3
    80004456:	85ce                	mv	a1,s3
    80004458:	855a                	mv	a0,s6
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	566080e7          	jalr	1382(ra) # 800009c0 <uvmalloc>
    80004462:	892a                	mv	s2,a0
    80004464:	e0a43423          	sd	a0,-504(s0)
    80004468:	e509                	bnez	a0,80004472 <exec+0x236>
  if(pagetable)
    8000446a:	e1343423          	sd	s3,-504(s0)
    8000446e:	4a01                	li	s4,0
    80004470:	aa1d                	j	800045a6 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004472:	75f9                	lui	a1,0xffffe
    80004474:	95aa                	add	a1,a1,a0
    80004476:	855a                	mv	a0,s6
    80004478:	ffffc097          	auipc	ra,0xffffc
    8000447c:	768080e7          	jalr	1896(ra) # 80000be0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004480:	7bfd                	lui	s7,0xfffff
    80004482:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004484:	e0043783          	ld	a5,-512(s0)
    80004488:	6388                	ld	a0,0(a5)
    8000448a:	c52d                	beqz	a0,800044f4 <exec+0x2b8>
    8000448c:	e9040993          	addi	s3,s0,-368
    80004490:	f9040c13          	addi	s8,s0,-112
    80004494:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	f68080e7          	jalr	-152(ra) # 800003fe <strlen>
    8000449e:	0015079b          	addiw	a5,a0,1
    800044a2:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044a6:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044aa:	13796563          	bltu	s2,s7,800045d4 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044ae:	e0043d03          	ld	s10,-512(s0)
    800044b2:	000d3a03          	ld	s4,0(s10)
    800044b6:	8552                	mv	a0,s4
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	f46080e7          	jalr	-186(ra) # 800003fe <strlen>
    800044c0:	0015069b          	addiw	a3,a0,1
    800044c4:	8652                	mv	a2,s4
    800044c6:	85ca                	mv	a1,s2
    800044c8:	855a                	mv	a0,s6
    800044ca:	ffffd097          	auipc	ra,0xffffd
    800044ce:	992080e7          	jalr	-1646(ra) # 80000e5c <copyout>
    800044d2:	10054363          	bltz	a0,800045d8 <exec+0x39c>
    ustack[argc] = sp;
    800044d6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044da:	0485                	addi	s1,s1,1
    800044dc:	008d0793          	addi	a5,s10,8
    800044e0:	e0f43023          	sd	a5,-512(s0)
    800044e4:	008d3503          	ld	a0,8(s10)
    800044e8:	c909                	beqz	a0,800044fa <exec+0x2be>
    if(argc >= MAXARG)
    800044ea:	09a1                	addi	s3,s3,8
    800044ec:	fb8995e3          	bne	s3,s8,80004496 <exec+0x25a>
  ip = 0;
    800044f0:	4a01                	li	s4,0
    800044f2:	a855                	j	800045a6 <exec+0x36a>
  sp = sz;
    800044f4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800044fa:	00349793          	slli	a5,s1,0x3
    800044fe:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffbd190>
    80004502:	97a2                	add	a5,a5,s0
    80004504:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004508:	00148693          	addi	a3,s1,1
    8000450c:	068e                	slli	a3,a3,0x3
    8000450e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004512:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004516:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000451a:	f57968e3          	bltu	s2,s7,8000446a <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000451e:	e9040613          	addi	a2,s0,-368
    80004522:	85ca                	mv	a1,s2
    80004524:	855a                	mv	a0,s6
    80004526:	ffffd097          	auipc	ra,0xffffd
    8000452a:	936080e7          	jalr	-1738(ra) # 80000e5c <copyout>
    8000452e:	0a054763          	bltz	a0,800045dc <exec+0x3a0>
  p->trapframe->a1 = sp;
    80004532:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004536:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000453a:	df843783          	ld	a5,-520(s0)
    8000453e:	0007c703          	lbu	a4,0(a5)
    80004542:	cf11                	beqz	a4,8000455e <exec+0x322>
    80004544:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004546:	02f00693          	li	a3,47
    8000454a:	a039                	j	80004558 <exec+0x31c>
      last = s+1;
    8000454c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004550:	0785                	addi	a5,a5,1
    80004552:	fff7c703          	lbu	a4,-1(a5)
    80004556:	c701                	beqz	a4,8000455e <exec+0x322>
    if(*s == '/')
    80004558:	fed71ce3          	bne	a4,a3,80004550 <exec+0x314>
    8000455c:	bfc5                	j	8000454c <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000455e:	4641                	li	a2,16
    80004560:	df843583          	ld	a1,-520(s0)
    80004564:	158a8513          	addi	a0,s5,344
    80004568:	ffffc097          	auipc	ra,0xffffc
    8000456c:	e64080e7          	jalr	-412(ra) # 800003cc <safestrcpy>
  oldpagetable = p->pagetable;
    80004570:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004574:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004578:	e0843783          	ld	a5,-504(s0)
    8000457c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004580:	058ab783          	ld	a5,88(s5)
    80004584:	e6843703          	ld	a4,-408(s0)
    80004588:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000458a:	058ab783          	ld	a5,88(s5)
    8000458e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004592:	85e6                	mv	a1,s9
    80004594:	ffffd097          	auipc	ra,0xffffd
    80004598:	c5c080e7          	jalr	-932(ra) # 800011f0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000459c:	0004851b          	sext.w	a0,s1
    800045a0:	bb15                	j	800042d4 <exec+0x98>
    800045a2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045a6:	e0843583          	ld	a1,-504(s0)
    800045aa:	855a                	mv	a0,s6
    800045ac:	ffffd097          	auipc	ra,0xffffd
    800045b0:	c44080e7          	jalr	-956(ra) # 800011f0 <proc_freepagetable>
  return -1;
    800045b4:	557d                	li	a0,-1
  if(ip){
    800045b6:	d00a0fe3          	beqz	s4,800042d4 <exec+0x98>
    800045ba:	b319                	j	800042c0 <exec+0x84>
    800045bc:	e1243423          	sd	s2,-504(s0)
    800045c0:	b7dd                	j	800045a6 <exec+0x36a>
    800045c2:	e1243423          	sd	s2,-504(s0)
    800045c6:	b7c5                	j	800045a6 <exec+0x36a>
    800045c8:	e1243423          	sd	s2,-504(s0)
    800045cc:	bfe9                	j	800045a6 <exec+0x36a>
    800045ce:	e1243423          	sd	s2,-504(s0)
    800045d2:	bfd1                	j	800045a6 <exec+0x36a>
  ip = 0;
    800045d4:	4a01                	li	s4,0
    800045d6:	bfc1                	j	800045a6 <exec+0x36a>
    800045d8:	4a01                	li	s4,0
  if(pagetable)
    800045da:	b7f1                	j	800045a6 <exec+0x36a>
  sz = sz1;
    800045dc:	e0843983          	ld	s3,-504(s0)
    800045e0:	b569                	j	8000446a <exec+0x22e>

00000000800045e2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045e2:	7179                	addi	sp,sp,-48
    800045e4:	f406                	sd	ra,40(sp)
    800045e6:	f022                	sd	s0,32(sp)
    800045e8:	ec26                	sd	s1,24(sp)
    800045ea:	e84a                	sd	s2,16(sp)
    800045ec:	1800                	addi	s0,sp,48
    800045ee:	892e                	mv	s2,a1
    800045f0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045f2:	fdc40593          	addi	a1,s0,-36
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	bf6080e7          	jalr	-1034(ra) # 800021ec <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045fe:	fdc42703          	lw	a4,-36(s0)
    80004602:	47bd                	li	a5,15
    80004604:	02e7eb63          	bltu	a5,a4,8000463a <argfd+0x58>
    80004608:	ffffd097          	auipc	ra,0xffffd
    8000460c:	a88080e7          	jalr	-1400(ra) # 80001090 <myproc>
    80004610:	fdc42703          	lw	a4,-36(s0)
    80004614:	01a70793          	addi	a5,a4,26
    80004618:	078e                	slli	a5,a5,0x3
    8000461a:	953e                	add	a0,a0,a5
    8000461c:	611c                	ld	a5,0(a0)
    8000461e:	c385                	beqz	a5,8000463e <argfd+0x5c>
    return -1;
  if(pfd)
    80004620:	00090463          	beqz	s2,80004628 <argfd+0x46>
    *pfd = fd;
    80004624:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004628:	4501                	li	a0,0
  if(pf)
    8000462a:	c091                	beqz	s1,8000462e <argfd+0x4c>
    *pf = f;
    8000462c:	e09c                	sd	a5,0(s1)
}
    8000462e:	70a2                	ld	ra,40(sp)
    80004630:	7402                	ld	s0,32(sp)
    80004632:	64e2                	ld	s1,24(sp)
    80004634:	6942                	ld	s2,16(sp)
    80004636:	6145                	addi	sp,sp,48
    80004638:	8082                	ret
    return -1;
    8000463a:	557d                	li	a0,-1
    8000463c:	bfcd                	j	8000462e <argfd+0x4c>
    8000463e:	557d                	li	a0,-1
    80004640:	b7fd                	j	8000462e <argfd+0x4c>

0000000080004642 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004642:	1101                	addi	sp,sp,-32
    80004644:	ec06                	sd	ra,24(sp)
    80004646:	e822                	sd	s0,16(sp)
    80004648:	e426                	sd	s1,8(sp)
    8000464a:	1000                	addi	s0,sp,32
    8000464c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000464e:	ffffd097          	auipc	ra,0xffffd
    80004652:	a42080e7          	jalr	-1470(ra) # 80001090 <myproc>
    80004656:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004658:	0d050793          	addi	a5,a0,208
    8000465c:	4501                	li	a0,0
    8000465e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004660:	6398                	ld	a4,0(a5)
    80004662:	cb19                	beqz	a4,80004678 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004664:	2505                	addiw	a0,a0,1
    80004666:	07a1                	addi	a5,a5,8
    80004668:	fed51ce3          	bne	a0,a3,80004660 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000466c:	557d                	li	a0,-1
}
    8000466e:	60e2                	ld	ra,24(sp)
    80004670:	6442                	ld	s0,16(sp)
    80004672:	64a2                	ld	s1,8(sp)
    80004674:	6105                	addi	sp,sp,32
    80004676:	8082                	ret
      p->ofile[fd] = f;
    80004678:	01a50793          	addi	a5,a0,26
    8000467c:	078e                	slli	a5,a5,0x3
    8000467e:	963e                	add	a2,a2,a5
    80004680:	e204                	sd	s1,0(a2)
      return fd;
    80004682:	b7f5                	j	8000466e <fdalloc+0x2c>

0000000080004684 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004684:	715d                	addi	sp,sp,-80
    80004686:	e486                	sd	ra,72(sp)
    80004688:	e0a2                	sd	s0,64(sp)
    8000468a:	fc26                	sd	s1,56(sp)
    8000468c:	f84a                	sd	s2,48(sp)
    8000468e:	f44e                	sd	s3,40(sp)
    80004690:	f052                	sd	s4,32(sp)
    80004692:	ec56                	sd	s5,24(sp)
    80004694:	e85a                	sd	s6,16(sp)
    80004696:	0880                	addi	s0,sp,80
    80004698:	8b2e                	mv	s6,a1
    8000469a:	89b2                	mv	s3,a2
    8000469c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000469e:	fb040593          	addi	a1,s0,-80
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	e7e080e7          	jalr	-386(ra) # 80003520 <nameiparent>
    800046aa:	84aa                	mv	s1,a0
    800046ac:	14050b63          	beqz	a0,80004802 <create+0x17e>
    return 0;

  ilock(dp);
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	6ac080e7          	jalr	1708(ra) # 80002d5c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046b8:	4601                	li	a2,0
    800046ba:	fb040593          	addi	a1,s0,-80
    800046be:	8526                	mv	a0,s1
    800046c0:	fffff097          	auipc	ra,0xfffff
    800046c4:	b80080e7          	jalr	-1152(ra) # 80003240 <dirlookup>
    800046c8:	8aaa                	mv	s5,a0
    800046ca:	c921                	beqz	a0,8000471a <create+0x96>
    iunlockput(dp);
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	8f0080e7          	jalr	-1808(ra) # 80002fbe <iunlockput>
    ilock(ip);
    800046d6:	8556                	mv	a0,s5
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	684080e7          	jalr	1668(ra) # 80002d5c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046e0:	4789                	li	a5,2
    800046e2:	02fb1563          	bne	s6,a5,8000470c <create+0x88>
    800046e6:	044ad783          	lhu	a5,68(s5)
    800046ea:	37f9                	addiw	a5,a5,-2
    800046ec:	17c2                	slli	a5,a5,0x30
    800046ee:	93c1                	srli	a5,a5,0x30
    800046f0:	4705                	li	a4,1
    800046f2:	00f76d63          	bltu	a4,a5,8000470c <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046f6:	8556                	mv	a0,s5
    800046f8:	60a6                	ld	ra,72(sp)
    800046fa:	6406                	ld	s0,64(sp)
    800046fc:	74e2                	ld	s1,56(sp)
    800046fe:	7942                	ld	s2,48(sp)
    80004700:	79a2                	ld	s3,40(sp)
    80004702:	7a02                	ld	s4,32(sp)
    80004704:	6ae2                	ld	s5,24(sp)
    80004706:	6b42                	ld	s6,16(sp)
    80004708:	6161                	addi	sp,sp,80
    8000470a:	8082                	ret
    iunlockput(ip);
    8000470c:	8556                	mv	a0,s5
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	8b0080e7          	jalr	-1872(ra) # 80002fbe <iunlockput>
    return 0;
    80004716:	4a81                	li	s5,0
    80004718:	bff9                	j	800046f6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000471a:	85da                	mv	a1,s6
    8000471c:	4088                	lw	a0,0(s1)
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	4a6080e7          	jalr	1190(ra) # 80002bc4 <ialloc>
    80004726:	8a2a                	mv	s4,a0
    80004728:	c529                	beqz	a0,80004772 <create+0xee>
  ilock(ip);
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	632080e7          	jalr	1586(ra) # 80002d5c <ilock>
  ip->major = major;
    80004732:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004736:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000473a:	4905                	li	s2,1
    8000473c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004740:	8552                	mv	a0,s4
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	54e080e7          	jalr	1358(ra) # 80002c90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000474a:	032b0b63          	beq	s6,s2,80004780 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000474e:	004a2603          	lw	a2,4(s4)
    80004752:	fb040593          	addi	a1,s0,-80
    80004756:	8526                	mv	a0,s1
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	cf8080e7          	jalr	-776(ra) # 80003450 <dirlink>
    80004760:	06054f63          	bltz	a0,800047de <create+0x15a>
  iunlockput(dp);
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	858080e7          	jalr	-1960(ra) # 80002fbe <iunlockput>
  return ip;
    8000476e:	8ad2                	mv	s5,s4
    80004770:	b759                	j	800046f6 <create+0x72>
    iunlockput(dp);
    80004772:	8526                	mv	a0,s1
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	84a080e7          	jalr	-1974(ra) # 80002fbe <iunlockput>
    return 0;
    8000477c:	8ad2                	mv	s5,s4
    8000477e:	bfa5                	j	800046f6 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004780:	004a2603          	lw	a2,4(s4)
    80004784:	00004597          	auipc	a1,0x4
    80004788:	f7c58593          	addi	a1,a1,-132 # 80008700 <syscalls+0x2a0>
    8000478c:	8552                	mv	a0,s4
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	cc2080e7          	jalr	-830(ra) # 80003450 <dirlink>
    80004796:	04054463          	bltz	a0,800047de <create+0x15a>
    8000479a:	40d0                	lw	a2,4(s1)
    8000479c:	00004597          	auipc	a1,0x4
    800047a0:	f6c58593          	addi	a1,a1,-148 # 80008708 <syscalls+0x2a8>
    800047a4:	8552                	mv	a0,s4
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	caa080e7          	jalr	-854(ra) # 80003450 <dirlink>
    800047ae:	02054863          	bltz	a0,800047de <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    800047b2:	004a2603          	lw	a2,4(s4)
    800047b6:	fb040593          	addi	a1,s0,-80
    800047ba:	8526                	mv	a0,s1
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	c94080e7          	jalr	-876(ra) # 80003450 <dirlink>
    800047c4:	00054d63          	bltz	a0,800047de <create+0x15a>
    dp->nlink++;  // for ".."
    800047c8:	04a4d783          	lhu	a5,74(s1)
    800047cc:	2785                	addiw	a5,a5,1
    800047ce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047d2:	8526                	mv	a0,s1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	4bc080e7          	jalr	1212(ra) # 80002c90 <iupdate>
    800047dc:	b761                	j	80004764 <create+0xe0>
  ip->nlink = 0;
    800047de:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047e2:	8552                	mv	a0,s4
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	4ac080e7          	jalr	1196(ra) # 80002c90 <iupdate>
  iunlockput(ip);
    800047ec:	8552                	mv	a0,s4
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	7d0080e7          	jalr	2000(ra) # 80002fbe <iunlockput>
  iunlockput(dp);
    800047f6:	8526                	mv	a0,s1
    800047f8:	ffffe097          	auipc	ra,0xffffe
    800047fc:	7c6080e7          	jalr	1990(ra) # 80002fbe <iunlockput>
  return 0;
    80004800:	bddd                	j	800046f6 <create+0x72>
    return 0;
    80004802:	8aaa                	mv	s5,a0
    80004804:	bdcd                	j	800046f6 <create+0x72>

0000000080004806 <sys_dup>:
{
    80004806:	7179                	addi	sp,sp,-48
    80004808:	f406                	sd	ra,40(sp)
    8000480a:	f022                	sd	s0,32(sp)
    8000480c:	ec26                	sd	s1,24(sp)
    8000480e:	e84a                	sd	s2,16(sp)
    80004810:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004812:	fd840613          	addi	a2,s0,-40
    80004816:	4581                	li	a1,0
    80004818:	4501                	li	a0,0
    8000481a:	00000097          	auipc	ra,0x0
    8000481e:	dc8080e7          	jalr	-568(ra) # 800045e2 <argfd>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004824:	02054363          	bltz	a0,8000484a <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004828:	fd843903          	ld	s2,-40(s0)
    8000482c:	854a                	mv	a0,s2
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	e14080e7          	jalr	-492(ra) # 80004642 <fdalloc>
    80004836:	84aa                	mv	s1,a0
    return -1;
    80004838:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000483a:	00054863          	bltz	a0,8000484a <sys_dup+0x44>
  filedup(f);
    8000483e:	854a                	mv	a0,s2
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	334080e7          	jalr	820(ra) # 80003b74 <filedup>
  return fd;
    80004848:	87a6                	mv	a5,s1
}
    8000484a:	853e                	mv	a0,a5
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	64e2                	ld	s1,24(sp)
    80004852:	6942                	ld	s2,16(sp)
    80004854:	6145                	addi	sp,sp,48
    80004856:	8082                	ret

0000000080004858 <sys_read>:
{
    80004858:	7179                	addi	sp,sp,-48
    8000485a:	f406                	sd	ra,40(sp)
    8000485c:	f022                	sd	s0,32(sp)
    8000485e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004860:	fd840593          	addi	a1,s0,-40
    80004864:	4505                	li	a0,1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	9a6080e7          	jalr	-1626(ra) # 8000220c <argaddr>
  argint(2, &n);
    8000486e:	fe440593          	addi	a1,s0,-28
    80004872:	4509                	li	a0,2
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	978080e7          	jalr	-1672(ra) # 800021ec <argint>
  if(argfd(0, 0, &f) < 0)
    8000487c:	fe840613          	addi	a2,s0,-24
    80004880:	4581                	li	a1,0
    80004882:	4501                	li	a0,0
    80004884:	00000097          	auipc	ra,0x0
    80004888:	d5e080e7          	jalr	-674(ra) # 800045e2 <argfd>
    8000488c:	87aa                	mv	a5,a0
    return -1;
    8000488e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004890:	0007cc63          	bltz	a5,800048a8 <sys_read+0x50>
  return fileread(f, p, n);
    80004894:	fe442603          	lw	a2,-28(s0)
    80004898:	fd843583          	ld	a1,-40(s0)
    8000489c:	fe843503          	ld	a0,-24(s0)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	460080e7          	jalr	1120(ra) # 80003d00 <fileread>
}
    800048a8:	70a2                	ld	ra,40(sp)
    800048aa:	7402                	ld	s0,32(sp)
    800048ac:	6145                	addi	sp,sp,48
    800048ae:	8082                	ret

00000000800048b0 <sys_write>:
{
    800048b0:	7179                	addi	sp,sp,-48
    800048b2:	f406                	sd	ra,40(sp)
    800048b4:	f022                	sd	s0,32(sp)
    800048b6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048b8:	fd840593          	addi	a1,s0,-40
    800048bc:	4505                	li	a0,1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	94e080e7          	jalr	-1714(ra) # 8000220c <argaddr>
  argint(2, &n);
    800048c6:	fe440593          	addi	a1,s0,-28
    800048ca:	4509                	li	a0,2
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	920080e7          	jalr	-1760(ra) # 800021ec <argint>
  if(argfd(0, 0, &f) < 0)
    800048d4:	fe840613          	addi	a2,s0,-24
    800048d8:	4581                	li	a1,0
    800048da:	4501                	li	a0,0
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	d06080e7          	jalr	-762(ra) # 800045e2 <argfd>
    800048e4:	87aa                	mv	a5,a0
    return -1;
    800048e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048e8:	0007cc63          	bltz	a5,80004900 <sys_write+0x50>
  return filewrite(f, p, n);
    800048ec:	fe442603          	lw	a2,-28(s0)
    800048f0:	fd843583          	ld	a1,-40(s0)
    800048f4:	fe843503          	ld	a0,-24(s0)
    800048f8:	fffff097          	auipc	ra,0xfffff
    800048fc:	4ca080e7          	jalr	1226(ra) # 80003dc2 <filewrite>
}
    80004900:	70a2                	ld	ra,40(sp)
    80004902:	7402                	ld	s0,32(sp)
    80004904:	6145                	addi	sp,sp,48
    80004906:	8082                	ret

0000000080004908 <sys_close>:
{
    80004908:	1101                	addi	sp,sp,-32
    8000490a:	ec06                	sd	ra,24(sp)
    8000490c:	e822                	sd	s0,16(sp)
    8000490e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004910:	fe040613          	addi	a2,s0,-32
    80004914:	fec40593          	addi	a1,s0,-20
    80004918:	4501                	li	a0,0
    8000491a:	00000097          	auipc	ra,0x0
    8000491e:	cc8080e7          	jalr	-824(ra) # 800045e2 <argfd>
    return -1;
    80004922:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004924:	02054463          	bltz	a0,8000494c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004928:	ffffc097          	auipc	ra,0xffffc
    8000492c:	768080e7          	jalr	1896(ra) # 80001090 <myproc>
    80004930:	fec42783          	lw	a5,-20(s0)
    80004934:	07e9                	addi	a5,a5,26
    80004936:	078e                	slli	a5,a5,0x3
    80004938:	953e                	add	a0,a0,a5
    8000493a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000493e:	fe043503          	ld	a0,-32(s0)
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	284080e7          	jalr	644(ra) # 80003bc6 <fileclose>
  return 0;
    8000494a:	4781                	li	a5,0
}
    8000494c:	853e                	mv	a0,a5
    8000494e:	60e2                	ld	ra,24(sp)
    80004950:	6442                	ld	s0,16(sp)
    80004952:	6105                	addi	sp,sp,32
    80004954:	8082                	ret

0000000080004956 <sys_fstat>:
{
    80004956:	1101                	addi	sp,sp,-32
    80004958:	ec06                	sd	ra,24(sp)
    8000495a:	e822                	sd	s0,16(sp)
    8000495c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000495e:	fe040593          	addi	a1,s0,-32
    80004962:	4505                	li	a0,1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	8a8080e7          	jalr	-1880(ra) # 8000220c <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000496c:	fe840613          	addi	a2,s0,-24
    80004970:	4581                	li	a1,0
    80004972:	4501                	li	a0,0
    80004974:	00000097          	auipc	ra,0x0
    80004978:	c6e080e7          	jalr	-914(ra) # 800045e2 <argfd>
    8000497c:	87aa                	mv	a5,a0
    return -1;
    8000497e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004980:	0007ca63          	bltz	a5,80004994 <sys_fstat+0x3e>
  return filestat(f, st);
    80004984:	fe043583          	ld	a1,-32(s0)
    80004988:	fe843503          	ld	a0,-24(s0)
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	302080e7          	jalr	770(ra) # 80003c8e <filestat>
}
    80004994:	60e2                	ld	ra,24(sp)
    80004996:	6442                	ld	s0,16(sp)
    80004998:	6105                	addi	sp,sp,32
    8000499a:	8082                	ret

000000008000499c <sys_link>:
{
    8000499c:	7169                	addi	sp,sp,-304
    8000499e:	f606                	sd	ra,296(sp)
    800049a0:	f222                	sd	s0,288(sp)
    800049a2:	ee26                	sd	s1,280(sp)
    800049a4:	ea4a                	sd	s2,272(sp)
    800049a6:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049a8:	08000613          	li	a2,128
    800049ac:	ed040593          	addi	a1,s0,-304
    800049b0:	4501                	li	a0,0
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	87a080e7          	jalr	-1926(ra) # 8000222c <argstr>
    return -1;
    800049ba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049bc:	10054e63          	bltz	a0,80004ad8 <sys_link+0x13c>
    800049c0:	08000613          	li	a2,128
    800049c4:	f5040593          	addi	a1,s0,-176
    800049c8:	4505                	li	a0,1
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	862080e7          	jalr	-1950(ra) # 8000222c <argstr>
    return -1;
    800049d2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d4:	10054263          	bltz	a0,80004ad8 <sys_link+0x13c>
  begin_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	d2a080e7          	jalr	-726(ra) # 80003702 <begin_op>
  if((ip = namei(old)) == 0){
    800049e0:	ed040513          	addi	a0,s0,-304
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	b1e080e7          	jalr	-1250(ra) # 80003502 <namei>
    800049ec:	84aa                	mv	s1,a0
    800049ee:	c551                	beqz	a0,80004a7a <sys_link+0xde>
  ilock(ip);
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	36c080e7          	jalr	876(ra) # 80002d5c <ilock>
  if(ip->type == T_DIR){
    800049f8:	04449703          	lh	a4,68(s1)
    800049fc:	4785                	li	a5,1
    800049fe:	08f70463          	beq	a4,a5,80004a86 <sys_link+0xea>
  ip->nlink++;
    80004a02:	04a4d783          	lhu	a5,74(s1)
    80004a06:	2785                	addiw	a5,a5,1
    80004a08:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	282080e7          	jalr	642(ra) # 80002c90 <iupdate>
  iunlock(ip);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	406080e7          	jalr	1030(ra) # 80002e1e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a20:	fd040593          	addi	a1,s0,-48
    80004a24:	f5040513          	addi	a0,s0,-176
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	af8080e7          	jalr	-1288(ra) # 80003520 <nameiparent>
    80004a30:	892a                	mv	s2,a0
    80004a32:	c935                	beqz	a0,80004aa6 <sys_link+0x10a>
  ilock(dp);
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	328080e7          	jalr	808(ra) # 80002d5c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a3c:	00092703          	lw	a4,0(s2)
    80004a40:	409c                	lw	a5,0(s1)
    80004a42:	04f71d63          	bne	a4,a5,80004a9c <sys_link+0x100>
    80004a46:	40d0                	lw	a2,4(s1)
    80004a48:	fd040593          	addi	a1,s0,-48
    80004a4c:	854a                	mv	a0,s2
    80004a4e:	fffff097          	auipc	ra,0xfffff
    80004a52:	a02080e7          	jalr	-1534(ra) # 80003450 <dirlink>
    80004a56:	04054363          	bltz	a0,80004a9c <sys_link+0x100>
  iunlockput(dp);
    80004a5a:	854a                	mv	a0,s2
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	562080e7          	jalr	1378(ra) # 80002fbe <iunlockput>
  iput(ip);
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	4b0080e7          	jalr	1200(ra) # 80002f16 <iput>
  end_op();
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	d0e080e7          	jalr	-754(ra) # 8000377c <end_op>
  return 0;
    80004a76:	4781                	li	a5,0
    80004a78:	a085                	j	80004ad8 <sys_link+0x13c>
    end_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	d02080e7          	jalr	-766(ra) # 8000377c <end_op>
    return -1;
    80004a82:	57fd                	li	a5,-1
    80004a84:	a891                	j	80004ad8 <sys_link+0x13c>
    iunlockput(ip);
    80004a86:	8526                	mv	a0,s1
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	536080e7          	jalr	1334(ra) # 80002fbe <iunlockput>
    end_op();
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	cec080e7          	jalr	-788(ra) # 8000377c <end_op>
    return -1;
    80004a98:	57fd                	li	a5,-1
    80004a9a:	a83d                	j	80004ad8 <sys_link+0x13c>
    iunlockput(dp);
    80004a9c:	854a                	mv	a0,s2
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	520080e7          	jalr	1312(ra) # 80002fbe <iunlockput>
  ilock(ip);
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	2b4080e7          	jalr	692(ra) # 80002d5c <ilock>
  ip->nlink--;
    80004ab0:	04a4d783          	lhu	a5,74(s1)
    80004ab4:	37fd                	addiw	a5,a5,-1
    80004ab6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	1d4080e7          	jalr	468(ra) # 80002c90 <iupdate>
  iunlockput(ip);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	4f8080e7          	jalr	1272(ra) # 80002fbe <iunlockput>
  end_op();
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	cae080e7          	jalr	-850(ra) # 8000377c <end_op>
  return -1;
    80004ad6:	57fd                	li	a5,-1
}
    80004ad8:	853e                	mv	a0,a5
    80004ada:	70b2                	ld	ra,296(sp)
    80004adc:	7412                	ld	s0,288(sp)
    80004ade:	64f2                	ld	s1,280(sp)
    80004ae0:	6952                	ld	s2,272(sp)
    80004ae2:	6155                	addi	sp,sp,304
    80004ae4:	8082                	ret

0000000080004ae6 <sys_unlink>:
{
    80004ae6:	7151                	addi	sp,sp,-240
    80004ae8:	f586                	sd	ra,232(sp)
    80004aea:	f1a2                	sd	s0,224(sp)
    80004aec:	eda6                	sd	s1,216(sp)
    80004aee:	e9ca                	sd	s2,208(sp)
    80004af0:	e5ce                	sd	s3,200(sp)
    80004af2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004af4:	08000613          	li	a2,128
    80004af8:	f3040593          	addi	a1,s0,-208
    80004afc:	4501                	li	a0,0
    80004afe:	ffffd097          	auipc	ra,0xffffd
    80004b02:	72e080e7          	jalr	1838(ra) # 8000222c <argstr>
    80004b06:	18054163          	bltz	a0,80004c88 <sys_unlink+0x1a2>
  begin_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	bf8080e7          	jalr	-1032(ra) # 80003702 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b12:	fb040593          	addi	a1,s0,-80
    80004b16:	f3040513          	addi	a0,s0,-208
    80004b1a:	fffff097          	auipc	ra,0xfffff
    80004b1e:	a06080e7          	jalr	-1530(ra) # 80003520 <nameiparent>
    80004b22:	84aa                	mv	s1,a0
    80004b24:	c979                	beqz	a0,80004bfa <sys_unlink+0x114>
  ilock(dp);
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	236080e7          	jalr	566(ra) # 80002d5c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b2e:	00004597          	auipc	a1,0x4
    80004b32:	bd258593          	addi	a1,a1,-1070 # 80008700 <syscalls+0x2a0>
    80004b36:	fb040513          	addi	a0,s0,-80
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	6ec080e7          	jalr	1772(ra) # 80003226 <namecmp>
    80004b42:	14050a63          	beqz	a0,80004c96 <sys_unlink+0x1b0>
    80004b46:	00004597          	auipc	a1,0x4
    80004b4a:	bc258593          	addi	a1,a1,-1086 # 80008708 <syscalls+0x2a8>
    80004b4e:	fb040513          	addi	a0,s0,-80
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	6d4080e7          	jalr	1748(ra) # 80003226 <namecmp>
    80004b5a:	12050e63          	beqz	a0,80004c96 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b5e:	f2c40613          	addi	a2,s0,-212
    80004b62:	fb040593          	addi	a1,s0,-80
    80004b66:	8526                	mv	a0,s1
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	6d8080e7          	jalr	1752(ra) # 80003240 <dirlookup>
    80004b70:	892a                	mv	s2,a0
    80004b72:	12050263          	beqz	a0,80004c96 <sys_unlink+0x1b0>
  ilock(ip);
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	1e6080e7          	jalr	486(ra) # 80002d5c <ilock>
  if(ip->nlink < 1)
    80004b7e:	04a91783          	lh	a5,74(s2)
    80004b82:	08f05263          	blez	a5,80004c06 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b86:	04491703          	lh	a4,68(s2)
    80004b8a:	4785                	li	a5,1
    80004b8c:	08f70563          	beq	a4,a5,80004c16 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b90:	4641                	li	a2,16
    80004b92:	4581                	li	a1,0
    80004b94:	fc040513          	addi	a0,s0,-64
    80004b98:	ffffb097          	auipc	ra,0xffffb
    80004b9c:	6ec080e7          	jalr	1772(ra) # 80000284 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba0:	4741                	li	a4,16
    80004ba2:	f2c42683          	lw	a3,-212(s0)
    80004ba6:	fc040613          	addi	a2,s0,-64
    80004baa:	4581                	li	a1,0
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	55a080e7          	jalr	1370(ra) # 80003108 <writei>
    80004bb6:	47c1                	li	a5,16
    80004bb8:	0af51563          	bne	a0,a5,80004c62 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bbc:	04491703          	lh	a4,68(s2)
    80004bc0:	4785                	li	a5,1
    80004bc2:	0af70863          	beq	a4,a5,80004c72 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	3f6080e7          	jalr	1014(ra) # 80002fbe <iunlockput>
  ip->nlink--;
    80004bd0:	04a95783          	lhu	a5,74(s2)
    80004bd4:	37fd                	addiw	a5,a5,-1
    80004bd6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bda:	854a                	mv	a0,s2
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	0b4080e7          	jalr	180(ra) # 80002c90 <iupdate>
  iunlockput(ip);
    80004be4:	854a                	mv	a0,s2
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	3d8080e7          	jalr	984(ra) # 80002fbe <iunlockput>
  end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	b8e080e7          	jalr	-1138(ra) # 8000377c <end_op>
  return 0;
    80004bf6:	4501                	li	a0,0
    80004bf8:	a84d                	j	80004caa <sys_unlink+0x1c4>
    end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	b82080e7          	jalr	-1150(ra) # 8000377c <end_op>
    return -1;
    80004c02:	557d                	li	a0,-1
    80004c04:	a05d                	j	80004caa <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c06:	00004517          	auipc	a0,0x4
    80004c0a:	b0a50513          	addi	a0,a0,-1270 # 80008710 <syscalls+0x2b0>
    80004c0e:	00001097          	auipc	ra,0x1
    80004c12:	1a8080e7          	jalr	424(ra) # 80005db6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c16:	04c92703          	lw	a4,76(s2)
    80004c1a:	02000793          	li	a5,32
    80004c1e:	f6e7f9e3          	bgeu	a5,a4,80004b90 <sys_unlink+0xaa>
    80004c22:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c26:	4741                	li	a4,16
    80004c28:	86ce                	mv	a3,s3
    80004c2a:	f1840613          	addi	a2,s0,-232
    80004c2e:	4581                	li	a1,0
    80004c30:	854a                	mv	a0,s2
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	3de080e7          	jalr	990(ra) # 80003010 <readi>
    80004c3a:	47c1                	li	a5,16
    80004c3c:	00f51b63          	bne	a0,a5,80004c52 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c40:	f1845783          	lhu	a5,-232(s0)
    80004c44:	e7a1                	bnez	a5,80004c8c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c46:	29c1                	addiw	s3,s3,16
    80004c48:	04c92783          	lw	a5,76(s2)
    80004c4c:	fcf9ede3          	bltu	s3,a5,80004c26 <sys_unlink+0x140>
    80004c50:	b781                	j	80004b90 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c52:	00004517          	auipc	a0,0x4
    80004c56:	ad650513          	addi	a0,a0,-1322 # 80008728 <syscalls+0x2c8>
    80004c5a:	00001097          	auipc	ra,0x1
    80004c5e:	15c080e7          	jalr	348(ra) # 80005db6 <panic>
    panic("unlink: writei");
    80004c62:	00004517          	auipc	a0,0x4
    80004c66:	ade50513          	addi	a0,a0,-1314 # 80008740 <syscalls+0x2e0>
    80004c6a:	00001097          	auipc	ra,0x1
    80004c6e:	14c080e7          	jalr	332(ra) # 80005db6 <panic>
    dp->nlink--;
    80004c72:	04a4d783          	lhu	a5,74(s1)
    80004c76:	37fd                	addiw	a5,a5,-1
    80004c78:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	012080e7          	jalr	18(ra) # 80002c90 <iupdate>
    80004c86:	b781                	j	80004bc6 <sys_unlink+0xe0>
    return -1;
    80004c88:	557d                	li	a0,-1
    80004c8a:	a005                	j	80004caa <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c8c:	854a                	mv	a0,s2
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	330080e7          	jalr	816(ra) # 80002fbe <iunlockput>
  iunlockput(dp);
    80004c96:	8526                	mv	a0,s1
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	326080e7          	jalr	806(ra) # 80002fbe <iunlockput>
  end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	adc080e7          	jalr	-1316(ra) # 8000377c <end_op>
  return -1;
    80004ca8:	557d                	li	a0,-1
}
    80004caa:	70ae                	ld	ra,232(sp)
    80004cac:	740e                	ld	s0,224(sp)
    80004cae:	64ee                	ld	s1,216(sp)
    80004cb0:	694e                	ld	s2,208(sp)
    80004cb2:	69ae                	ld	s3,200(sp)
    80004cb4:	616d                	addi	sp,sp,240
    80004cb6:	8082                	ret

0000000080004cb8 <sys_open>:

uint64
sys_open(void)
{
    80004cb8:	7131                	addi	sp,sp,-192
    80004cba:	fd06                	sd	ra,184(sp)
    80004cbc:	f922                	sd	s0,176(sp)
    80004cbe:	f526                	sd	s1,168(sp)
    80004cc0:	f14a                	sd	s2,160(sp)
    80004cc2:	ed4e                	sd	s3,152(sp)
    80004cc4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cc6:	f4c40593          	addi	a1,s0,-180
    80004cca:	4505                	li	a0,1
    80004ccc:	ffffd097          	auipc	ra,0xffffd
    80004cd0:	520080e7          	jalr	1312(ra) # 800021ec <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cd4:	08000613          	li	a2,128
    80004cd8:	f5040593          	addi	a1,s0,-176
    80004cdc:	4501                	li	a0,0
    80004cde:	ffffd097          	auipc	ra,0xffffd
    80004ce2:	54e080e7          	jalr	1358(ra) # 8000222c <argstr>
    80004ce6:	87aa                	mv	a5,a0
    return -1;
    80004ce8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cea:	0a07c863          	bltz	a5,80004d9a <sys_open+0xe2>

  begin_op();
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	a14080e7          	jalr	-1516(ra) # 80003702 <begin_op>

  if(omode & O_CREATE){
    80004cf6:	f4c42783          	lw	a5,-180(s0)
    80004cfa:	2007f793          	andi	a5,a5,512
    80004cfe:	cbdd                	beqz	a5,80004db4 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004d00:	4681                	li	a3,0
    80004d02:	4601                	li	a2,0
    80004d04:	4589                	li	a1,2
    80004d06:	f5040513          	addi	a0,s0,-176
    80004d0a:	00000097          	auipc	ra,0x0
    80004d0e:	97a080e7          	jalr	-1670(ra) # 80004684 <create>
    80004d12:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d14:	c951                	beqz	a0,80004da8 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d16:	04449703          	lh	a4,68(s1)
    80004d1a:	478d                	li	a5,3
    80004d1c:	00f71763          	bne	a4,a5,80004d2a <sys_open+0x72>
    80004d20:	0464d703          	lhu	a4,70(s1)
    80004d24:	47a5                	li	a5,9
    80004d26:	0ce7ec63          	bltu	a5,a4,80004dfe <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	de0080e7          	jalr	-544(ra) # 80003b0a <filealloc>
    80004d32:	892a                	mv	s2,a0
    80004d34:	c56d                	beqz	a0,80004e1e <sys_open+0x166>
    80004d36:	00000097          	auipc	ra,0x0
    80004d3a:	90c080e7          	jalr	-1780(ra) # 80004642 <fdalloc>
    80004d3e:	89aa                	mv	s3,a0
    80004d40:	0c054a63          	bltz	a0,80004e14 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d44:	04449703          	lh	a4,68(s1)
    80004d48:	478d                	li	a5,3
    80004d4a:	0ef70563          	beq	a4,a5,80004e34 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d4e:	4789                	li	a5,2
    80004d50:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d54:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d58:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d5c:	f4c42783          	lw	a5,-180(s0)
    80004d60:	0017c713          	xori	a4,a5,1
    80004d64:	8b05                	andi	a4,a4,1
    80004d66:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d6a:	0037f713          	andi	a4,a5,3
    80004d6e:	00e03733          	snez	a4,a4
    80004d72:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d76:	4007f793          	andi	a5,a5,1024
    80004d7a:	c791                	beqz	a5,80004d86 <sys_open+0xce>
    80004d7c:	04449703          	lh	a4,68(s1)
    80004d80:	4789                	li	a5,2
    80004d82:	0cf70063          	beq	a4,a5,80004e42 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004d86:	8526                	mv	a0,s1
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	096080e7          	jalr	150(ra) # 80002e1e <iunlock>
  end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	9ec080e7          	jalr	-1556(ra) # 8000377c <end_op>

  return fd;
    80004d98:	854e                	mv	a0,s3
}
    80004d9a:	70ea                	ld	ra,184(sp)
    80004d9c:	744a                	ld	s0,176(sp)
    80004d9e:	74aa                	ld	s1,168(sp)
    80004da0:	790a                	ld	s2,160(sp)
    80004da2:	69ea                	ld	s3,152(sp)
    80004da4:	6129                	addi	sp,sp,192
    80004da6:	8082                	ret
      end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	9d4080e7          	jalr	-1580(ra) # 8000377c <end_op>
      return -1;
    80004db0:	557d                	li	a0,-1
    80004db2:	b7e5                	j	80004d9a <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004db4:	f5040513          	addi	a0,s0,-176
    80004db8:	ffffe097          	auipc	ra,0xffffe
    80004dbc:	74a080e7          	jalr	1866(ra) # 80003502 <namei>
    80004dc0:	84aa                	mv	s1,a0
    80004dc2:	c905                	beqz	a0,80004df2 <sys_open+0x13a>
    ilock(ip);
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	f98080e7          	jalr	-104(ra) # 80002d5c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dcc:	04449703          	lh	a4,68(s1)
    80004dd0:	4785                	li	a5,1
    80004dd2:	f4f712e3          	bne	a4,a5,80004d16 <sys_open+0x5e>
    80004dd6:	f4c42783          	lw	a5,-180(s0)
    80004dda:	dba1                	beqz	a5,80004d2a <sys_open+0x72>
      iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	1e0080e7          	jalr	480(ra) # 80002fbe <iunlockput>
      end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	996080e7          	jalr	-1642(ra) # 8000377c <end_op>
      return -1;
    80004dee:	557d                	li	a0,-1
    80004df0:	b76d                	j	80004d9a <sys_open+0xe2>
      end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	98a080e7          	jalr	-1654(ra) # 8000377c <end_op>
      return -1;
    80004dfa:	557d                	li	a0,-1
    80004dfc:	bf79                	j	80004d9a <sys_open+0xe2>
    iunlockput(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	1be080e7          	jalr	446(ra) # 80002fbe <iunlockput>
    end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	974080e7          	jalr	-1676(ra) # 8000377c <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	b761                	j	80004d9a <sys_open+0xe2>
      fileclose(f);
    80004e14:	854a                	mv	a0,s2
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	db0080e7          	jalr	-592(ra) # 80003bc6 <fileclose>
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	19e080e7          	jalr	414(ra) # 80002fbe <iunlockput>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	954080e7          	jalr	-1708(ra) # 8000377c <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	b7a5                	j	80004d9a <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004e34:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e38:	04649783          	lh	a5,70(s1)
    80004e3c:	02f91223          	sh	a5,36(s2)
    80004e40:	bf21                	j	80004d58 <sys_open+0xa0>
    itrunc(ip);
    80004e42:	8526                	mv	a0,s1
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	026080e7          	jalr	38(ra) # 80002e6a <itrunc>
    80004e4c:	bf2d                	j	80004d86 <sys_open+0xce>

0000000080004e4e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e4e:	7175                	addi	sp,sp,-144
    80004e50:	e506                	sd	ra,136(sp)
    80004e52:	e122                	sd	s0,128(sp)
    80004e54:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	8ac080e7          	jalr	-1876(ra) # 80003702 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e5e:	08000613          	li	a2,128
    80004e62:	f7040593          	addi	a1,s0,-144
    80004e66:	4501                	li	a0,0
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	3c4080e7          	jalr	964(ra) # 8000222c <argstr>
    80004e70:	02054963          	bltz	a0,80004ea2 <sys_mkdir+0x54>
    80004e74:	4681                	li	a3,0
    80004e76:	4601                	li	a2,0
    80004e78:	4585                	li	a1,1
    80004e7a:	f7040513          	addi	a0,s0,-144
    80004e7e:	00000097          	auipc	ra,0x0
    80004e82:	806080e7          	jalr	-2042(ra) # 80004684 <create>
    80004e86:	cd11                	beqz	a0,80004ea2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	136080e7          	jalr	310(ra) # 80002fbe <iunlockput>
  end_op();
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	8ec080e7          	jalr	-1812(ra) # 8000377c <end_op>
  return 0;
    80004e98:	4501                	li	a0,0
}
    80004e9a:	60aa                	ld	ra,136(sp)
    80004e9c:	640a                	ld	s0,128(sp)
    80004e9e:	6149                	addi	sp,sp,144
    80004ea0:	8082                	ret
    end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	8da080e7          	jalr	-1830(ra) # 8000377c <end_op>
    return -1;
    80004eaa:	557d                	li	a0,-1
    80004eac:	b7fd                	j	80004e9a <sys_mkdir+0x4c>

0000000080004eae <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eae:	7135                	addi	sp,sp,-160
    80004eb0:	ed06                	sd	ra,152(sp)
    80004eb2:	e922                	sd	s0,144(sp)
    80004eb4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	84c080e7          	jalr	-1972(ra) # 80003702 <begin_op>
  argint(1, &major);
    80004ebe:	f6c40593          	addi	a1,s0,-148
    80004ec2:	4505                	li	a0,1
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	328080e7          	jalr	808(ra) # 800021ec <argint>
  argint(2, &minor);
    80004ecc:	f6840593          	addi	a1,s0,-152
    80004ed0:	4509                	li	a0,2
    80004ed2:	ffffd097          	auipc	ra,0xffffd
    80004ed6:	31a080e7          	jalr	794(ra) # 800021ec <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eda:	08000613          	li	a2,128
    80004ede:	f7040593          	addi	a1,s0,-144
    80004ee2:	4501                	li	a0,0
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	348080e7          	jalr	840(ra) # 8000222c <argstr>
    80004eec:	02054b63          	bltz	a0,80004f22 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ef0:	f6841683          	lh	a3,-152(s0)
    80004ef4:	f6c41603          	lh	a2,-148(s0)
    80004ef8:	458d                	li	a1,3
    80004efa:	f7040513          	addi	a0,s0,-144
    80004efe:	fffff097          	auipc	ra,0xfffff
    80004f02:	786080e7          	jalr	1926(ra) # 80004684 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f06:	cd11                	beqz	a0,80004f22 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	0b6080e7          	jalr	182(ra) # 80002fbe <iunlockput>
  end_op();
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	86c080e7          	jalr	-1940(ra) # 8000377c <end_op>
  return 0;
    80004f18:	4501                	li	a0,0
}
    80004f1a:	60ea                	ld	ra,152(sp)
    80004f1c:	644a                	ld	s0,144(sp)
    80004f1e:	610d                	addi	sp,sp,160
    80004f20:	8082                	ret
    end_op();
    80004f22:	fffff097          	auipc	ra,0xfffff
    80004f26:	85a080e7          	jalr	-1958(ra) # 8000377c <end_op>
    return -1;
    80004f2a:	557d                	li	a0,-1
    80004f2c:	b7fd                	j	80004f1a <sys_mknod+0x6c>

0000000080004f2e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f2e:	7135                	addi	sp,sp,-160
    80004f30:	ed06                	sd	ra,152(sp)
    80004f32:	e922                	sd	s0,144(sp)
    80004f34:	e526                	sd	s1,136(sp)
    80004f36:	e14a                	sd	s2,128(sp)
    80004f38:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f3a:	ffffc097          	auipc	ra,0xffffc
    80004f3e:	156080e7          	jalr	342(ra) # 80001090 <myproc>
    80004f42:	892a                	mv	s2,a0
  
  begin_op();
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	7be080e7          	jalr	1982(ra) # 80003702 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f4c:	08000613          	li	a2,128
    80004f50:	f6040593          	addi	a1,s0,-160
    80004f54:	4501                	li	a0,0
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	2d6080e7          	jalr	726(ra) # 8000222c <argstr>
    80004f5e:	04054b63          	bltz	a0,80004fb4 <sys_chdir+0x86>
    80004f62:	f6040513          	addi	a0,s0,-160
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	59c080e7          	jalr	1436(ra) # 80003502 <namei>
    80004f6e:	84aa                	mv	s1,a0
    80004f70:	c131                	beqz	a0,80004fb4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	dea080e7          	jalr	-534(ra) # 80002d5c <ilock>
  if(ip->type != T_DIR){
    80004f7a:	04449703          	lh	a4,68(s1)
    80004f7e:	4785                	li	a5,1
    80004f80:	04f71063          	bne	a4,a5,80004fc0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f84:	8526                	mv	a0,s1
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	e98080e7          	jalr	-360(ra) # 80002e1e <iunlock>
  iput(p->cwd);
    80004f8e:	15093503          	ld	a0,336(s2)
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	f84080e7          	jalr	-124(ra) # 80002f16 <iput>
  end_op();
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	7e2080e7          	jalr	2018(ra) # 8000377c <end_op>
  p->cwd = ip;
    80004fa2:	14993823          	sd	s1,336(s2)
  return 0;
    80004fa6:	4501                	li	a0,0
}
    80004fa8:	60ea                	ld	ra,152(sp)
    80004faa:	644a                	ld	s0,144(sp)
    80004fac:	64aa                	ld	s1,136(sp)
    80004fae:	690a                	ld	s2,128(sp)
    80004fb0:	610d                	addi	sp,sp,160
    80004fb2:	8082                	ret
    end_op();
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	7c8080e7          	jalr	1992(ra) # 8000377c <end_op>
    return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	b7ed                	j	80004fa8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	ffc080e7          	jalr	-4(ra) # 80002fbe <iunlockput>
    end_op();
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	7b2080e7          	jalr	1970(ra) # 8000377c <end_op>
    return -1;
    80004fd2:	557d                	li	a0,-1
    80004fd4:	bfd1                	j	80004fa8 <sys_chdir+0x7a>

0000000080004fd6 <sys_exec>:

uint64
sys_exec(void)
{
    80004fd6:	7121                	addi	sp,sp,-448
    80004fd8:	ff06                	sd	ra,440(sp)
    80004fda:	fb22                	sd	s0,432(sp)
    80004fdc:	f726                	sd	s1,424(sp)
    80004fde:	f34a                	sd	s2,416(sp)
    80004fe0:	ef4e                	sd	s3,408(sp)
    80004fe2:	eb52                	sd	s4,400(sp)
    80004fe4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fe6:	e4840593          	addi	a1,s0,-440
    80004fea:	4505                	li	a0,1
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	220080e7          	jalr	544(ra) # 8000220c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ff4:	08000613          	li	a2,128
    80004ff8:	f5040593          	addi	a1,s0,-176
    80004ffc:	4501                	li	a0,0
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	22e080e7          	jalr	558(ra) # 8000222c <argstr>
    80005006:	87aa                	mv	a5,a0
    return -1;
    80005008:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000500a:	0c07c263          	bltz	a5,800050ce <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    8000500e:	10000613          	li	a2,256
    80005012:	4581                	li	a1,0
    80005014:	e5040513          	addi	a0,s0,-432
    80005018:	ffffb097          	auipc	ra,0xffffb
    8000501c:	26c080e7          	jalr	620(ra) # 80000284 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005020:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005024:	89a6                	mv	s3,s1
    80005026:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005028:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000502c:	00391513          	slli	a0,s2,0x3
    80005030:	e4040593          	addi	a1,s0,-448
    80005034:	e4843783          	ld	a5,-440(s0)
    80005038:	953e                	add	a0,a0,a5
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	114080e7          	jalr	276(ra) # 8000214e <fetchaddr>
    80005042:	02054a63          	bltz	a0,80005076 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005046:	e4043783          	ld	a5,-448(s0)
    8000504a:	c3b9                	beqz	a5,80005090 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000504c:	ffffb097          	auipc	ra,0xffffb
    80005050:	1b6080e7          	jalr	438(ra) # 80000202 <kalloc>
    80005054:	85aa                	mv	a1,a0
    80005056:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000505a:	cd11                	beqz	a0,80005076 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000505c:	6605                	lui	a2,0x1
    8000505e:	e4043503          	ld	a0,-448(s0)
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	13e080e7          	jalr	318(ra) # 800021a0 <fetchstr>
    8000506a:	00054663          	bltz	a0,80005076 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000506e:	0905                	addi	s2,s2,1
    80005070:	09a1                	addi	s3,s3,8
    80005072:	fb491de3          	bne	s2,s4,8000502c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005076:	f5040913          	addi	s2,s0,-176
    8000507a:	6088                	ld	a0,0(s1)
    8000507c:	c921                	beqz	a0,800050cc <sys_exec+0xf6>
    kfree(argv[i]);
    8000507e:	ffffb097          	auipc	ra,0xffffb
    80005082:	03e080e7          	jalr	62(ra) # 800000bc <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005086:	04a1                	addi	s1,s1,8
    80005088:	ff2499e3          	bne	s1,s2,8000507a <sys_exec+0xa4>
  return -1;
    8000508c:	557d                	li	a0,-1
    8000508e:	a081                	j	800050ce <sys_exec+0xf8>
      argv[i] = 0;
    80005090:	0009079b          	sext.w	a5,s2
    80005094:	078e                	slli	a5,a5,0x3
    80005096:	fd078793          	addi	a5,a5,-48
    8000509a:	97a2                	add	a5,a5,s0
    8000509c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050a0:	e5040593          	addi	a1,s0,-432
    800050a4:	f5040513          	addi	a0,s0,-176
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	194080e7          	jalr	404(ra) # 8000423c <exec>
    800050b0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b2:	f5040993          	addi	s3,s0,-176
    800050b6:	6088                	ld	a0,0(s1)
    800050b8:	c901                	beqz	a0,800050c8 <sys_exec+0xf2>
    kfree(argv[i]);
    800050ba:	ffffb097          	auipc	ra,0xffffb
    800050be:	002080e7          	jalr	2(ra) # 800000bc <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c2:	04a1                	addi	s1,s1,8
    800050c4:	ff3499e3          	bne	s1,s3,800050b6 <sys_exec+0xe0>
  return ret;
    800050c8:	854a                	mv	a0,s2
    800050ca:	a011                	j	800050ce <sys_exec+0xf8>
  return -1;
    800050cc:	557d                	li	a0,-1
}
    800050ce:	70fa                	ld	ra,440(sp)
    800050d0:	745a                	ld	s0,432(sp)
    800050d2:	74ba                	ld	s1,424(sp)
    800050d4:	791a                	ld	s2,416(sp)
    800050d6:	69fa                	ld	s3,408(sp)
    800050d8:	6a5a                	ld	s4,400(sp)
    800050da:	6139                	addi	sp,sp,448
    800050dc:	8082                	ret

00000000800050de <sys_pipe>:

uint64
sys_pipe(void)
{
    800050de:	7139                	addi	sp,sp,-64
    800050e0:	fc06                	sd	ra,56(sp)
    800050e2:	f822                	sd	s0,48(sp)
    800050e4:	f426                	sd	s1,40(sp)
    800050e6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	fa8080e7          	jalr	-88(ra) # 80001090 <myproc>
    800050f0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050f2:	fd840593          	addi	a1,s0,-40
    800050f6:	4501                	li	a0,0
    800050f8:	ffffd097          	auipc	ra,0xffffd
    800050fc:	114080e7          	jalr	276(ra) # 8000220c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005100:	fc840593          	addi	a1,s0,-56
    80005104:	fd040513          	addi	a0,s0,-48
    80005108:	fffff097          	auipc	ra,0xfffff
    8000510c:	dea080e7          	jalr	-534(ra) # 80003ef2 <pipealloc>
    return -1;
    80005110:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005112:	0c054463          	bltz	a0,800051da <sys_pipe+0xfc>
  fd0 = -1;
    80005116:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000511a:	fd043503          	ld	a0,-48(s0)
    8000511e:	fffff097          	auipc	ra,0xfffff
    80005122:	524080e7          	jalr	1316(ra) # 80004642 <fdalloc>
    80005126:	fca42223          	sw	a0,-60(s0)
    8000512a:	08054b63          	bltz	a0,800051c0 <sys_pipe+0xe2>
    8000512e:	fc843503          	ld	a0,-56(s0)
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	510080e7          	jalr	1296(ra) # 80004642 <fdalloc>
    8000513a:	fca42023          	sw	a0,-64(s0)
    8000513e:	06054863          	bltz	a0,800051ae <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005142:	4691                	li	a3,4
    80005144:	fc440613          	addi	a2,s0,-60
    80005148:	fd843583          	ld	a1,-40(s0)
    8000514c:	68a8                	ld	a0,80(s1)
    8000514e:	ffffc097          	auipc	ra,0xffffc
    80005152:	d0e080e7          	jalr	-754(ra) # 80000e5c <copyout>
    80005156:	02054063          	bltz	a0,80005176 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000515a:	4691                	li	a3,4
    8000515c:	fc040613          	addi	a2,s0,-64
    80005160:	fd843583          	ld	a1,-40(s0)
    80005164:	0591                	addi	a1,a1,4
    80005166:	68a8                	ld	a0,80(s1)
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cf4080e7          	jalr	-780(ra) # 80000e5c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005170:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005172:	06055463          	bgez	a0,800051da <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005176:	fc442783          	lw	a5,-60(s0)
    8000517a:	07e9                	addi	a5,a5,26
    8000517c:	078e                	slli	a5,a5,0x3
    8000517e:	97a6                	add	a5,a5,s1
    80005180:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005184:	fc042783          	lw	a5,-64(s0)
    80005188:	07e9                	addi	a5,a5,26
    8000518a:	078e                	slli	a5,a5,0x3
    8000518c:	94be                	add	s1,s1,a5
    8000518e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005192:	fd043503          	ld	a0,-48(s0)
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	a30080e7          	jalr	-1488(ra) # 80003bc6 <fileclose>
    fileclose(wf);
    8000519e:	fc843503          	ld	a0,-56(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	a24080e7          	jalr	-1500(ra) # 80003bc6 <fileclose>
    return -1;
    800051aa:	57fd                	li	a5,-1
    800051ac:	a03d                	j	800051da <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051ae:	fc442783          	lw	a5,-60(s0)
    800051b2:	0007c763          	bltz	a5,800051c0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051b6:	07e9                	addi	a5,a5,26
    800051b8:	078e                	slli	a5,a5,0x3
    800051ba:	97a6                	add	a5,a5,s1
    800051bc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051c0:	fd043503          	ld	a0,-48(s0)
    800051c4:	fffff097          	auipc	ra,0xfffff
    800051c8:	a02080e7          	jalr	-1534(ra) # 80003bc6 <fileclose>
    fileclose(wf);
    800051cc:	fc843503          	ld	a0,-56(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	9f6080e7          	jalr	-1546(ra) # 80003bc6 <fileclose>
    return -1;
    800051d8:	57fd                	li	a5,-1
}
    800051da:	853e                	mv	a0,a5
    800051dc:	70e2                	ld	ra,56(sp)
    800051de:	7442                	ld	s0,48(sp)
    800051e0:	74a2                	ld	s1,40(sp)
    800051e2:	6121                	addi	sp,sp,64
    800051e4:	8082                	ret
	...

00000000800051f0 <kernelvec>:
    800051f0:	7111                	addi	sp,sp,-256
    800051f2:	e006                	sd	ra,0(sp)
    800051f4:	e40a                	sd	sp,8(sp)
    800051f6:	e80e                	sd	gp,16(sp)
    800051f8:	ec12                	sd	tp,24(sp)
    800051fa:	f016                	sd	t0,32(sp)
    800051fc:	f41a                	sd	t1,40(sp)
    800051fe:	f81e                	sd	t2,48(sp)
    80005200:	fc22                	sd	s0,56(sp)
    80005202:	e0a6                	sd	s1,64(sp)
    80005204:	e4aa                	sd	a0,72(sp)
    80005206:	e8ae                	sd	a1,80(sp)
    80005208:	ecb2                	sd	a2,88(sp)
    8000520a:	f0b6                	sd	a3,96(sp)
    8000520c:	f4ba                	sd	a4,104(sp)
    8000520e:	f8be                	sd	a5,112(sp)
    80005210:	fcc2                	sd	a6,120(sp)
    80005212:	e146                	sd	a7,128(sp)
    80005214:	e54a                	sd	s2,136(sp)
    80005216:	e94e                	sd	s3,144(sp)
    80005218:	ed52                	sd	s4,152(sp)
    8000521a:	f156                	sd	s5,160(sp)
    8000521c:	f55a                	sd	s6,168(sp)
    8000521e:	f95e                	sd	s7,176(sp)
    80005220:	fd62                	sd	s8,184(sp)
    80005222:	e1e6                	sd	s9,192(sp)
    80005224:	e5ea                	sd	s10,200(sp)
    80005226:	e9ee                	sd	s11,208(sp)
    80005228:	edf2                	sd	t3,216(sp)
    8000522a:	f1f6                	sd	t4,224(sp)
    8000522c:	f5fa                	sd	t5,232(sp)
    8000522e:	f9fe                	sd	t6,240(sp)
    80005230:	debfc0ef          	jal	ra,8000201a <kerneltrap>
    80005234:	6082                	ld	ra,0(sp)
    80005236:	6122                	ld	sp,8(sp)
    80005238:	61c2                	ld	gp,16(sp)
    8000523a:	7282                	ld	t0,32(sp)
    8000523c:	7322                	ld	t1,40(sp)
    8000523e:	73c2                	ld	t2,48(sp)
    80005240:	7462                	ld	s0,56(sp)
    80005242:	6486                	ld	s1,64(sp)
    80005244:	6526                	ld	a0,72(sp)
    80005246:	65c6                	ld	a1,80(sp)
    80005248:	6666                	ld	a2,88(sp)
    8000524a:	7686                	ld	a3,96(sp)
    8000524c:	7726                	ld	a4,104(sp)
    8000524e:	77c6                	ld	a5,112(sp)
    80005250:	7866                	ld	a6,120(sp)
    80005252:	688a                	ld	a7,128(sp)
    80005254:	692a                	ld	s2,136(sp)
    80005256:	69ca                	ld	s3,144(sp)
    80005258:	6a6a                	ld	s4,152(sp)
    8000525a:	7a8a                	ld	s5,160(sp)
    8000525c:	7b2a                	ld	s6,168(sp)
    8000525e:	7bca                	ld	s7,176(sp)
    80005260:	7c6a                	ld	s8,184(sp)
    80005262:	6c8e                	ld	s9,192(sp)
    80005264:	6d2e                	ld	s10,200(sp)
    80005266:	6dce                	ld	s11,208(sp)
    80005268:	6e6e                	ld	t3,216(sp)
    8000526a:	7e8e                	ld	t4,224(sp)
    8000526c:	7f2e                	ld	t5,232(sp)
    8000526e:	7fce                	ld	t6,240(sp)
    80005270:	6111                	addi	sp,sp,256
    80005272:	10200073          	sret
    80005276:	00000013          	nop
    8000527a:	00000013          	nop
    8000527e:	0001                	nop

0000000080005280 <timervec>:
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	e10c                	sd	a1,0(a0)
    80005286:	e510                	sd	a2,8(a0)
    80005288:	e914                	sd	a3,16(a0)
    8000528a:	6d0c                	ld	a1,24(a0)
    8000528c:	7110                	ld	a2,32(a0)
    8000528e:	6194                	ld	a3,0(a1)
    80005290:	96b2                	add	a3,a3,a2
    80005292:	e194                	sd	a3,0(a1)
    80005294:	4589                	li	a1,2
    80005296:	14459073          	csrw	sip,a1
    8000529a:	6914                	ld	a3,16(a0)
    8000529c:	6510                	ld	a2,8(a0)
    8000529e:	610c                	ld	a1,0(a0)
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	30200073          	mret
	...

00000000800052aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052aa:	1141                	addi	sp,sp,-16
    800052ac:	e422                	sd	s0,8(sp)
    800052ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052b0:	0c0007b7          	lui	a5,0xc000
    800052b4:	4705                	li	a4,1
    800052b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052b8:	c3d8                	sw	a4,4(a5)
}
    800052ba:	6422                	ld	s0,8(sp)
    800052bc:	0141                	addi	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <plicinithart>:

void
plicinithart(void)
{
    800052c0:	1141                	addi	sp,sp,-16
    800052c2:	e406                	sd	ra,8(sp)
    800052c4:	e022                	sd	s0,0(sp)
    800052c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	d9c080e7          	jalr	-612(ra) # 80001064 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052d0:	0085171b          	slliw	a4,a0,0x8
    800052d4:	0c0027b7          	lui	a5,0xc002
    800052d8:	97ba                	add	a5,a5,a4
    800052da:	40200713          	li	a4,1026
    800052de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052e2:	00d5151b          	slliw	a0,a0,0xd
    800052e6:	0c2017b7          	lui	a5,0xc201
    800052ea:	97aa                	add	a5,a5,a0
    800052ec:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	addi	sp,sp,16
    800052f6:	8082                	ret

00000000800052f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052f8:	1141                	addi	sp,sp,-16
    800052fa:	e406                	sd	ra,8(sp)
    800052fc:	e022                	sd	s0,0(sp)
    800052fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	d64080e7          	jalr	-668(ra) # 80001064 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005308:	00d5151b          	slliw	a0,a0,0xd
    8000530c:	0c2017b7          	lui	a5,0xc201
    80005310:	97aa                	add	a5,a5,a0
  return irq;
}
    80005312:	43c8                	lw	a0,4(a5)
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000531c:	1101                	addi	sp,sp,-32
    8000531e:	ec06                	sd	ra,24(sp)
    80005320:	e822                	sd	s0,16(sp)
    80005322:	e426                	sd	s1,8(sp)
    80005324:	1000                	addi	s0,sp,32
    80005326:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	d3c080e7          	jalr	-708(ra) # 80001064 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005330:	00d5151b          	slliw	a0,a0,0xd
    80005334:	0c2017b7          	lui	a5,0xc201
    80005338:	97aa                	add	a5,a5,a0
    8000533a:	c3c4                	sw	s1,4(a5)
}
    8000533c:	60e2                	ld	ra,24(sp)
    8000533e:	6442                	ld	s0,16(sp)
    80005340:	64a2                	ld	s1,8(sp)
    80005342:	6105                	addi	sp,sp,32
    80005344:	8082                	ret

0000000080005346 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005346:	1141                	addi	sp,sp,-16
    80005348:	e406                	sd	ra,8(sp)
    8000534a:	e022                	sd	s0,0(sp)
    8000534c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000534e:	479d                	li	a5,7
    80005350:	04a7cc63          	blt	a5,a0,800053a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005354:	00034797          	auipc	a5,0x34
    80005358:	72478793          	addi	a5,a5,1828 # 80039a78 <disk>
    8000535c:	97aa                	add	a5,a5,a0
    8000535e:	0187c783          	lbu	a5,24(a5)
    80005362:	ebb9                	bnez	a5,800053b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005364:	00451693          	slli	a3,a0,0x4
    80005368:	00034797          	auipc	a5,0x34
    8000536c:	71078793          	addi	a5,a5,1808 # 80039a78 <disk>
    80005370:	6398                	ld	a4,0(a5)
    80005372:	9736                	add	a4,a4,a3
    80005374:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005378:	6398                	ld	a4,0(a5)
    8000537a:	9736                	add	a4,a4,a3
    8000537c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005380:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005384:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005388:	97aa                	add	a5,a5,a0
    8000538a:	4705                	li	a4,1
    8000538c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005390:	00034517          	auipc	a0,0x34
    80005394:	70050513          	addi	a0,a0,1792 # 80039a90 <disk+0x18>
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	404080e7          	jalr	1028(ra) # 8000179c <wakeup>
}
    800053a0:	60a2                	ld	ra,8(sp)
    800053a2:	6402                	ld	s0,0(sp)
    800053a4:	0141                	addi	sp,sp,16
    800053a6:	8082                	ret
    panic("free_desc 1");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	3a850513          	addi	a0,a0,936 # 80008750 <syscalls+0x2f0>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	a06080e7          	jalr	-1530(ra) # 80005db6 <panic>
    panic("free_desc 2");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	3a850513          	addi	a0,a0,936 # 80008760 <syscalls+0x300>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	9f6080e7          	jalr	-1546(ra) # 80005db6 <panic>

00000000800053c8 <virtio_disk_init>:
{
    800053c8:	1101                	addi	sp,sp,-32
    800053ca:	ec06                	sd	ra,24(sp)
    800053cc:	e822                	sd	s0,16(sp)
    800053ce:	e426                	sd	s1,8(sp)
    800053d0:	e04a                	sd	s2,0(sp)
    800053d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053d4:	00003597          	auipc	a1,0x3
    800053d8:	39c58593          	addi	a1,a1,924 # 80008770 <syscalls+0x310>
    800053dc:	00034517          	auipc	a0,0x34
    800053e0:	7c450513          	addi	a0,a0,1988 # 80039ba0 <disk+0x128>
    800053e4:	00001097          	auipc	ra,0x1
    800053e8:	e7a080e7          	jalr	-390(ra) # 8000625e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053ec:	100017b7          	lui	a5,0x10001
    800053f0:	4398                	lw	a4,0(a5)
    800053f2:	2701                	sext.w	a4,a4
    800053f4:	747277b7          	lui	a5,0x74727
    800053f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053fc:	14f71b63          	bne	a4,a5,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005400:	100017b7          	lui	a5,0x10001
    80005404:	43dc                	lw	a5,4(a5)
    80005406:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005408:	4709                	li	a4,2
    8000540a:	14e79463          	bne	a5,a4,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	479c                	lw	a5,8(a5)
    80005414:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005416:	12e79e63          	bne	a5,a4,80005552 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000541a:	100017b7          	lui	a5,0x10001
    8000541e:	47d8                	lw	a4,12(a5)
    80005420:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005422:	554d47b7          	lui	a5,0x554d4
    80005426:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000542a:	12f71463          	bne	a4,a5,80005552 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	4705                	li	a4,1
    80005438:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543a:	470d                	li	a4,3
    8000543c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000543e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005440:	c7ffe6b7          	lui	a3,0xc7ffe
    80005444:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fbc95f>
    80005448:	8f75                	and	a4,a4,a3
    8000544a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544c:	472d                	li	a4,11
    8000544e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005450:	5bbc                	lw	a5,112(a5)
    80005452:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005456:	8ba1                	andi	a5,a5,8
    80005458:	10078563          	beqz	a5,80005562 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000545c:	100017b7          	lui	a5,0x10001
    80005460:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005464:	43fc                	lw	a5,68(a5)
    80005466:	2781                	sext.w	a5,a5
    80005468:	10079563          	bnez	a5,80005572 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000546c:	100017b7          	lui	a5,0x10001
    80005470:	5bdc                	lw	a5,52(a5)
    80005472:	2781                	sext.w	a5,a5
  if(max == 0)
    80005474:	10078763          	beqz	a5,80005582 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005478:	471d                	li	a4,7
    8000547a:	10f77c63          	bgeu	a4,a5,80005592 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000547e:	ffffb097          	auipc	ra,0xffffb
    80005482:	d84080e7          	jalr	-636(ra) # 80000202 <kalloc>
    80005486:	00034497          	auipc	s1,0x34
    8000548a:	5f248493          	addi	s1,s1,1522 # 80039a78 <disk>
    8000548e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005490:	ffffb097          	auipc	ra,0xffffb
    80005494:	d72080e7          	jalr	-654(ra) # 80000202 <kalloc>
    80005498:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000549a:	ffffb097          	auipc	ra,0xffffb
    8000549e:	d68080e7          	jalr	-664(ra) # 80000202 <kalloc>
    800054a2:	87aa                	mv	a5,a0
    800054a4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054a6:	6088                	ld	a0,0(s1)
    800054a8:	cd6d                	beqz	a0,800055a2 <virtio_disk_init+0x1da>
    800054aa:	00034717          	auipc	a4,0x34
    800054ae:	5d673703          	ld	a4,1494(a4) # 80039a80 <disk+0x8>
    800054b2:	cb65                	beqz	a4,800055a2 <virtio_disk_init+0x1da>
    800054b4:	c7fd                	beqz	a5,800055a2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800054b6:	6605                	lui	a2,0x1
    800054b8:	4581                	li	a1,0
    800054ba:	ffffb097          	auipc	ra,0xffffb
    800054be:	dca080e7          	jalr	-566(ra) # 80000284 <memset>
  memset(disk.avail, 0, PGSIZE);
    800054c2:	00034497          	auipc	s1,0x34
    800054c6:	5b648493          	addi	s1,s1,1462 # 80039a78 <disk>
    800054ca:	6605                	lui	a2,0x1
    800054cc:	4581                	li	a1,0
    800054ce:	6488                	ld	a0,8(s1)
    800054d0:	ffffb097          	auipc	ra,0xffffb
    800054d4:	db4080e7          	jalr	-588(ra) # 80000284 <memset>
  memset(disk.used, 0, PGSIZE);
    800054d8:	6605                	lui	a2,0x1
    800054da:	4581                	li	a1,0
    800054dc:	6888                	ld	a0,16(s1)
    800054de:	ffffb097          	auipc	ra,0xffffb
    800054e2:	da6080e7          	jalr	-602(ra) # 80000284 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054e6:	100017b7          	lui	a5,0x10001
    800054ea:	4721                	li	a4,8
    800054ec:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054ee:	4098                	lw	a4,0(s1)
    800054f0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054f4:	40d8                	lw	a4,4(s1)
    800054f6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054fa:	6498                	ld	a4,8(s1)
    800054fc:	0007069b          	sext.w	a3,a4
    80005500:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005504:	9701                	srai	a4,a4,0x20
    80005506:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000550a:	6898                	ld	a4,16(s1)
    8000550c:	0007069b          	sext.w	a3,a4
    80005510:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005514:	9701                	srai	a4,a4,0x20
    80005516:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000551a:	4705                	li	a4,1
    8000551c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000551e:	00e48c23          	sb	a4,24(s1)
    80005522:	00e48ca3          	sb	a4,25(s1)
    80005526:	00e48d23          	sb	a4,26(s1)
    8000552a:	00e48da3          	sb	a4,27(s1)
    8000552e:	00e48e23          	sb	a4,28(s1)
    80005532:	00e48ea3          	sb	a4,29(s1)
    80005536:	00e48f23          	sb	a4,30(s1)
    8000553a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000553e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005542:	0727a823          	sw	s2,112(a5)
}
    80005546:	60e2                	ld	ra,24(sp)
    80005548:	6442                	ld	s0,16(sp)
    8000554a:	64a2                	ld	s1,8(sp)
    8000554c:	6902                	ld	s2,0(sp)
    8000554e:	6105                	addi	sp,sp,32
    80005550:	8082                	ret
    panic("could not find virtio disk");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	22e50513          	addi	a0,a0,558 # 80008780 <syscalls+0x320>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	85c080e7          	jalr	-1956(ra) # 80005db6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	23e50513          	addi	a0,a0,574 # 800087a0 <syscalls+0x340>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	84c080e7          	jalr	-1972(ra) # 80005db6 <panic>
    panic("virtio disk should not be ready");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	24e50513          	addi	a0,a0,590 # 800087c0 <syscalls+0x360>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	83c080e7          	jalr	-1988(ra) # 80005db6 <panic>
    panic("virtio disk has no queue 0");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	25e50513          	addi	a0,a0,606 # 800087e0 <syscalls+0x380>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	82c080e7          	jalr	-2004(ra) # 80005db6 <panic>
    panic("virtio disk max queue too short");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	26e50513          	addi	a0,a0,622 # 80008800 <syscalls+0x3a0>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	81c080e7          	jalr	-2020(ra) # 80005db6 <panic>
    panic("virtio disk kalloc");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	27e50513          	addi	a0,a0,638 # 80008820 <syscalls+0x3c0>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	80c080e7          	jalr	-2036(ra) # 80005db6 <panic>

00000000800055b2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055b2:	7159                	addi	sp,sp,-112
    800055b4:	f486                	sd	ra,104(sp)
    800055b6:	f0a2                	sd	s0,96(sp)
    800055b8:	eca6                	sd	s1,88(sp)
    800055ba:	e8ca                	sd	s2,80(sp)
    800055bc:	e4ce                	sd	s3,72(sp)
    800055be:	e0d2                	sd	s4,64(sp)
    800055c0:	fc56                	sd	s5,56(sp)
    800055c2:	f85a                	sd	s6,48(sp)
    800055c4:	f45e                	sd	s7,40(sp)
    800055c6:	f062                	sd	s8,32(sp)
    800055c8:	ec66                	sd	s9,24(sp)
    800055ca:	e86a                	sd	s10,16(sp)
    800055cc:	1880                	addi	s0,sp,112
    800055ce:	8a2a                	mv	s4,a0
    800055d0:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055d2:	00c52c83          	lw	s9,12(a0)
    800055d6:	001c9c9b          	slliw	s9,s9,0x1
    800055da:	1c82                	slli	s9,s9,0x20
    800055dc:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055e0:	00034517          	auipc	a0,0x34
    800055e4:	5c050513          	addi	a0,a0,1472 # 80039ba0 <disk+0x128>
    800055e8:	00001097          	auipc	ra,0x1
    800055ec:	d06080e7          	jalr	-762(ra) # 800062ee <acquire>
  for(int i = 0; i < 3; i++){
    800055f0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800055f2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055f4:	00034b17          	auipc	s6,0x34
    800055f8:	484b0b13          	addi	s6,s6,1156 # 80039a78 <disk>
  for(int i = 0; i < 3; i++){
    800055fc:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055fe:	00034c17          	auipc	s8,0x34
    80005602:	5a2c0c13          	addi	s8,s8,1442 # 80039ba0 <disk+0x128>
    80005606:	a095                	j	8000566a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005608:	00fb0733          	add	a4,s6,a5
    8000560c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005610:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005612:	0207c563          	bltz	a5,8000563c <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005616:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005618:	0591                	addi	a1,a1,4
    8000561a:	05560d63          	beq	a2,s5,80005674 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000561e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005620:	00034717          	auipc	a4,0x34
    80005624:	45870713          	addi	a4,a4,1112 # 80039a78 <disk>
    80005628:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000562a:	01874683          	lbu	a3,24(a4)
    8000562e:	fee9                	bnez	a3,80005608 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    80005630:	2785                	addiw	a5,a5,1
    80005632:	0705                	addi	a4,a4,1
    80005634:	fe979be3          	bne	a5,s1,8000562a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    80005638:	57fd                	li	a5,-1
    8000563a:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    8000563c:	00c05e63          	blez	a2,80005658 <virtio_disk_rw+0xa6>
    80005640:	060a                	slli	a2,a2,0x2
    80005642:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    80005646:	0009a503          	lw	a0,0(s3)
    8000564a:	00000097          	auipc	ra,0x0
    8000564e:	cfc080e7          	jalr	-772(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    80005652:	0991                	addi	s3,s3,4
    80005654:	ffa999e3          	bne	s3,s10,80005646 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005658:	85e2                	mv	a1,s8
    8000565a:	00034517          	auipc	a0,0x34
    8000565e:	43650513          	addi	a0,a0,1078 # 80039a90 <disk+0x18>
    80005662:	ffffc097          	auipc	ra,0xffffc
    80005666:	0d6080e7          	jalr	214(ra) # 80001738 <sleep>
  for(int i = 0; i < 3; i++){
    8000566a:	f9040993          	addi	s3,s0,-112
{
    8000566e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005670:	864a                	mv	a2,s2
    80005672:	b775                	j	8000561e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005674:	f9042503          	lw	a0,-112(s0)
    80005678:	00a50713          	addi	a4,a0,10
    8000567c:	0712                	slli	a4,a4,0x4

  if(write)
    8000567e:	00034797          	auipc	a5,0x34
    80005682:	3fa78793          	addi	a5,a5,1018 # 80039a78 <disk>
    80005686:	00e786b3          	add	a3,a5,a4
    8000568a:	01703633          	snez	a2,s7
    8000568e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005690:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005694:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005698:	f6070613          	addi	a2,a4,-160
    8000569c:	6394                	ld	a3,0(a5)
    8000569e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056a0:	00870593          	addi	a1,a4,8
    800056a4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056a6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056a8:	0007b803          	ld	a6,0(a5)
    800056ac:	9642                	add	a2,a2,a6
    800056ae:	46c1                	li	a3,16
    800056b0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056b2:	4585                	li	a1,1
    800056b4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800056b8:	f9442683          	lw	a3,-108(s0)
    800056bc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056c0:	0692                	slli	a3,a3,0x4
    800056c2:	9836                	add	a6,a6,a3
    800056c4:	058a0613          	addi	a2,s4,88
    800056c8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800056cc:	0007b803          	ld	a6,0(a5)
    800056d0:	96c2                	add	a3,a3,a6
    800056d2:	40000613          	li	a2,1024
    800056d6:	c690                	sw	a2,8(a3)
  if(write)
    800056d8:	001bb613          	seqz	a2,s7
    800056dc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056e0:	00166613          	ori	a2,a2,1
    800056e4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056e8:	f9842603          	lw	a2,-104(s0)
    800056ec:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f0:	00250693          	addi	a3,a0,2
    800056f4:	0692                	slli	a3,a3,0x4
    800056f6:	96be                	add	a3,a3,a5
    800056f8:	58fd                	li	a7,-1
    800056fa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056fe:	0612                	slli	a2,a2,0x4
    80005700:	9832                	add	a6,a6,a2
    80005702:	f9070713          	addi	a4,a4,-112
    80005706:	973e                	add	a4,a4,a5
    80005708:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000570c:	6398                	ld	a4,0(a5)
    8000570e:	9732                	add	a4,a4,a2
    80005710:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005712:	4609                	li	a2,2
    80005714:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005718:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000571c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005720:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005724:	6794                	ld	a3,8(a5)
    80005726:	0026d703          	lhu	a4,2(a3)
    8000572a:	8b1d                	andi	a4,a4,7
    8000572c:	0706                	slli	a4,a4,0x1
    8000572e:	96ba                	add	a3,a3,a4
    80005730:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005734:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005738:	6798                	ld	a4,8(a5)
    8000573a:	00275783          	lhu	a5,2(a4)
    8000573e:	2785                	addiw	a5,a5,1
    80005740:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005744:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005748:	100017b7          	lui	a5,0x10001
    8000574c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005750:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005754:	00034917          	auipc	s2,0x34
    80005758:	44c90913          	addi	s2,s2,1100 # 80039ba0 <disk+0x128>
  while(b->disk == 1) {
    8000575c:	4485                	li	s1,1
    8000575e:	00b79c63          	bne	a5,a1,80005776 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005762:	85ca                	mv	a1,s2
    80005764:	8552                	mv	a0,s4
    80005766:	ffffc097          	auipc	ra,0xffffc
    8000576a:	fd2080e7          	jalr	-46(ra) # 80001738 <sleep>
  while(b->disk == 1) {
    8000576e:	004a2783          	lw	a5,4(s4)
    80005772:	fe9788e3          	beq	a5,s1,80005762 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005776:	f9042903          	lw	s2,-112(s0)
    8000577a:	00290713          	addi	a4,s2,2
    8000577e:	0712                	slli	a4,a4,0x4
    80005780:	00034797          	auipc	a5,0x34
    80005784:	2f878793          	addi	a5,a5,760 # 80039a78 <disk>
    80005788:	97ba                	add	a5,a5,a4
    8000578a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000578e:	00034997          	auipc	s3,0x34
    80005792:	2ea98993          	addi	s3,s3,746 # 80039a78 <disk>
    80005796:	00491713          	slli	a4,s2,0x4
    8000579a:	0009b783          	ld	a5,0(s3)
    8000579e:	97ba                	add	a5,a5,a4
    800057a0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057a4:	854a                	mv	a0,s2
    800057a6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057aa:	00000097          	auipc	ra,0x0
    800057ae:	b9c080e7          	jalr	-1124(ra) # 80005346 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057b2:	8885                	andi	s1,s1,1
    800057b4:	f0ed                	bnez	s1,80005796 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057b6:	00034517          	auipc	a0,0x34
    800057ba:	3ea50513          	addi	a0,a0,1002 # 80039ba0 <disk+0x128>
    800057be:	00001097          	auipc	ra,0x1
    800057c2:	be4080e7          	jalr	-1052(ra) # 800063a2 <release>
}
    800057c6:	70a6                	ld	ra,104(sp)
    800057c8:	7406                	ld	s0,96(sp)
    800057ca:	64e6                	ld	s1,88(sp)
    800057cc:	6946                	ld	s2,80(sp)
    800057ce:	69a6                	ld	s3,72(sp)
    800057d0:	6a06                	ld	s4,64(sp)
    800057d2:	7ae2                	ld	s5,56(sp)
    800057d4:	7b42                	ld	s6,48(sp)
    800057d6:	7ba2                	ld	s7,40(sp)
    800057d8:	7c02                	ld	s8,32(sp)
    800057da:	6ce2                	ld	s9,24(sp)
    800057dc:	6d42                	ld	s10,16(sp)
    800057de:	6165                	addi	sp,sp,112
    800057e0:	8082                	ret

00000000800057e2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057e2:	1101                	addi	sp,sp,-32
    800057e4:	ec06                	sd	ra,24(sp)
    800057e6:	e822                	sd	s0,16(sp)
    800057e8:	e426                	sd	s1,8(sp)
    800057ea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057ec:	00034497          	auipc	s1,0x34
    800057f0:	28c48493          	addi	s1,s1,652 # 80039a78 <disk>
    800057f4:	00034517          	auipc	a0,0x34
    800057f8:	3ac50513          	addi	a0,a0,940 # 80039ba0 <disk+0x128>
    800057fc:	00001097          	auipc	ra,0x1
    80005800:	af2080e7          	jalr	-1294(ra) # 800062ee <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005804:	10001737          	lui	a4,0x10001
    80005808:	533c                	lw	a5,96(a4)
    8000580a:	8b8d                	andi	a5,a5,3
    8000580c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000580e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005812:	689c                	ld	a5,16(s1)
    80005814:	0204d703          	lhu	a4,32(s1)
    80005818:	0027d783          	lhu	a5,2(a5)
    8000581c:	04f70863          	beq	a4,a5,8000586c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005820:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005824:	6898                	ld	a4,16(s1)
    80005826:	0204d783          	lhu	a5,32(s1)
    8000582a:	8b9d                	andi	a5,a5,7
    8000582c:	078e                	slli	a5,a5,0x3
    8000582e:	97ba                	add	a5,a5,a4
    80005830:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005832:	00278713          	addi	a4,a5,2
    80005836:	0712                	slli	a4,a4,0x4
    80005838:	9726                	add	a4,a4,s1
    8000583a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000583e:	e721                	bnez	a4,80005886 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005840:	0789                	addi	a5,a5,2
    80005842:	0792                	slli	a5,a5,0x4
    80005844:	97a6                	add	a5,a5,s1
    80005846:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005848:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	f50080e7          	jalr	-176(ra) # 8000179c <wakeup>

    disk.used_idx += 1;
    80005854:	0204d783          	lhu	a5,32(s1)
    80005858:	2785                	addiw	a5,a5,1
    8000585a:	17c2                	slli	a5,a5,0x30
    8000585c:	93c1                	srli	a5,a5,0x30
    8000585e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005862:	6898                	ld	a4,16(s1)
    80005864:	00275703          	lhu	a4,2(a4)
    80005868:	faf71ce3          	bne	a4,a5,80005820 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000586c:	00034517          	auipc	a0,0x34
    80005870:	33450513          	addi	a0,a0,820 # 80039ba0 <disk+0x128>
    80005874:	00001097          	auipc	ra,0x1
    80005878:	b2e080e7          	jalr	-1234(ra) # 800063a2 <release>
}
    8000587c:	60e2                	ld	ra,24(sp)
    8000587e:	6442                	ld	s0,16(sp)
    80005880:	64a2                	ld	s1,8(sp)
    80005882:	6105                	addi	sp,sp,32
    80005884:	8082                	ret
      panic("virtio_disk_intr status");
    80005886:	00003517          	auipc	a0,0x3
    8000588a:	fb250513          	addi	a0,a0,-78 # 80008838 <syscalls+0x3d8>
    8000588e:	00000097          	auipc	ra,0x0
    80005892:	528080e7          	jalr	1320(ra) # 80005db6 <panic>

0000000080005896 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005896:	1141                	addi	sp,sp,-16
    80005898:	e422                	sd	s0,8(sp)
    8000589a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000589c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058a0:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058a4:	0037979b          	slliw	a5,a5,0x3
    800058a8:	02004737          	lui	a4,0x2004
    800058ac:	97ba                	add	a5,a5,a4
    800058ae:	0200c737          	lui	a4,0x200c
    800058b2:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058b6:	000f4637          	lui	a2,0xf4
    800058ba:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058be:	9732                	add	a4,a4,a2
    800058c0:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058c2:	00259693          	slli	a3,a1,0x2
    800058c6:	96ae                	add	a3,a3,a1
    800058c8:	068e                	slli	a3,a3,0x3
    800058ca:	00034717          	auipc	a4,0x34
    800058ce:	2f670713          	addi	a4,a4,758 # 80039bc0 <timer_scratch>
    800058d2:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058d4:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058d6:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058d8:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058dc:	00000797          	auipc	a5,0x0
    800058e0:	9a478793          	addi	a5,a5,-1628 # 80005280 <timervec>
    800058e4:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058e8:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058ec:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058f0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058f4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058f8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058fc:	30479073          	csrw	mie,a5
}
    80005900:	6422                	ld	s0,8(sp)
    80005902:	0141                	addi	sp,sp,16
    80005904:	8082                	ret

0000000080005906 <start>:
{
    80005906:	1141                	addi	sp,sp,-16
    80005908:	e406                	sd	ra,8(sp)
    8000590a:	e022                	sd	s0,0(sp)
    8000590c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000590e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005912:	7779                	lui	a4,0xffffe
    80005914:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbc9ff>
    80005918:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000591a:	6705                	lui	a4,0x1
    8000591c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005920:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005922:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005926:	ffffb797          	auipc	a5,0xffffb
    8000592a:	b0278793          	addi	a5,a5,-1278 # 80000428 <main>
    8000592e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005932:	4781                	li	a5,0
    80005934:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005938:	67c1                	lui	a5,0x10
    8000593a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000593c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005940:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005944:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005948:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000594c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005950:	57fd                	li	a5,-1
    80005952:	83a9                	srli	a5,a5,0xa
    80005954:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005958:	47bd                	li	a5,15
    8000595a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000595e:	00000097          	auipc	ra,0x0
    80005962:	f38080e7          	jalr	-200(ra) # 80005896 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005966:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000596a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000596c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000596e:	30200073          	mret
}
    80005972:	60a2                	ld	ra,8(sp)
    80005974:	6402                	ld	s0,0(sp)
    80005976:	0141                	addi	sp,sp,16
    80005978:	8082                	ret

000000008000597a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000597a:	715d                	addi	sp,sp,-80
    8000597c:	e486                	sd	ra,72(sp)
    8000597e:	e0a2                	sd	s0,64(sp)
    80005980:	fc26                	sd	s1,56(sp)
    80005982:	f84a                	sd	s2,48(sp)
    80005984:	f44e                	sd	s3,40(sp)
    80005986:	f052                	sd	s4,32(sp)
    80005988:	ec56                	sd	s5,24(sp)
    8000598a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000598c:	04c05763          	blez	a2,800059da <consolewrite+0x60>
    80005990:	8a2a                	mv	s4,a0
    80005992:	84ae                	mv	s1,a1
    80005994:	89b2                	mv	s3,a2
    80005996:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005998:	5afd                	li	s5,-1
    8000599a:	4685                	li	a3,1
    8000599c:	8626                	mv	a2,s1
    8000599e:	85d2                	mv	a1,s4
    800059a0:	fbf40513          	addi	a0,s0,-65
    800059a4:	ffffc097          	auipc	ra,0xffffc
    800059a8:	1f2080e7          	jalr	498(ra) # 80001b96 <either_copyin>
    800059ac:	01550d63          	beq	a0,s5,800059c6 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059b0:	fbf44503          	lbu	a0,-65(s0)
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	780080e7          	jalr	1920(ra) # 80006134 <uartputc>
  for(i = 0; i < n; i++){
    800059bc:	2905                	addiw	s2,s2,1
    800059be:	0485                	addi	s1,s1,1
    800059c0:	fd299de3          	bne	s3,s2,8000599a <consolewrite+0x20>
    800059c4:	894e                	mv	s2,s3
  }

  return i;
}
    800059c6:	854a                	mv	a0,s2
    800059c8:	60a6                	ld	ra,72(sp)
    800059ca:	6406                	ld	s0,64(sp)
    800059cc:	74e2                	ld	s1,56(sp)
    800059ce:	7942                	ld	s2,48(sp)
    800059d0:	79a2                	ld	s3,40(sp)
    800059d2:	7a02                	ld	s4,32(sp)
    800059d4:	6ae2                	ld	s5,24(sp)
    800059d6:	6161                	addi	sp,sp,80
    800059d8:	8082                	ret
  for(i = 0; i < n; i++){
    800059da:	4901                	li	s2,0
    800059dc:	b7ed                	j	800059c6 <consolewrite+0x4c>

00000000800059de <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059de:	711d                	addi	sp,sp,-96
    800059e0:	ec86                	sd	ra,88(sp)
    800059e2:	e8a2                	sd	s0,80(sp)
    800059e4:	e4a6                	sd	s1,72(sp)
    800059e6:	e0ca                	sd	s2,64(sp)
    800059e8:	fc4e                	sd	s3,56(sp)
    800059ea:	f852                	sd	s4,48(sp)
    800059ec:	f456                	sd	s5,40(sp)
    800059ee:	f05a                	sd	s6,32(sp)
    800059f0:	ec5e                	sd	s7,24(sp)
    800059f2:	1080                	addi	s0,sp,96
    800059f4:	8aaa                	mv	s5,a0
    800059f6:	8a2e                	mv	s4,a1
    800059f8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059fa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059fe:	0003c517          	auipc	a0,0x3c
    80005a02:	30250513          	addi	a0,a0,770 # 80041d00 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	8e8080e7          	jalr	-1816(ra) # 800062ee <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a0e:	0003c497          	auipc	s1,0x3c
    80005a12:	2f248493          	addi	s1,s1,754 # 80041d00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a16:	0003c917          	auipc	s2,0x3c
    80005a1a:	38290913          	addi	s2,s2,898 # 80041d98 <cons+0x98>
  while(n > 0){
    80005a1e:	09305263          	blez	s3,80005aa2 <consoleread+0xc4>
    while(cons.r == cons.w){
    80005a22:	0984a783          	lw	a5,152(s1)
    80005a26:	09c4a703          	lw	a4,156(s1)
    80005a2a:	02f71763          	bne	a4,a5,80005a58 <consoleread+0x7a>
      if(killed(myproc())){
    80005a2e:	ffffb097          	auipc	ra,0xffffb
    80005a32:	662080e7          	jalr	1634(ra) # 80001090 <myproc>
    80005a36:	ffffc097          	auipc	ra,0xffffc
    80005a3a:	faa080e7          	jalr	-86(ra) # 800019e0 <killed>
    80005a3e:	ed2d                	bnez	a0,80005ab8 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005a40:	85a6                	mv	a1,s1
    80005a42:	854a                	mv	a0,s2
    80005a44:	ffffc097          	auipc	ra,0xffffc
    80005a48:	cf4080e7          	jalr	-780(ra) # 80001738 <sleep>
    while(cons.r == cons.w){
    80005a4c:	0984a783          	lw	a5,152(s1)
    80005a50:	09c4a703          	lw	a4,156(s1)
    80005a54:	fcf70de3          	beq	a4,a5,80005a2e <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a58:	0003c717          	auipc	a4,0x3c
    80005a5c:	2a870713          	addi	a4,a4,680 # 80041d00 <cons>
    80005a60:	0017869b          	addiw	a3,a5,1
    80005a64:	08d72c23          	sw	a3,152(a4)
    80005a68:	07f7f693          	andi	a3,a5,127
    80005a6c:	9736                	add	a4,a4,a3
    80005a6e:	01874703          	lbu	a4,24(a4)
    80005a72:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a76:	4691                	li	a3,4
    80005a78:	06db8463          	beq	s7,a3,80005ae0 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a7c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a80:	4685                	li	a3,1
    80005a82:	faf40613          	addi	a2,s0,-81
    80005a86:	85d2                	mv	a1,s4
    80005a88:	8556                	mv	a0,s5
    80005a8a:	ffffc097          	auipc	ra,0xffffc
    80005a8e:	0b6080e7          	jalr	182(ra) # 80001b40 <either_copyout>
    80005a92:	57fd                	li	a5,-1
    80005a94:	00f50763          	beq	a0,a5,80005aa2 <consoleread+0xc4>
      break;

    dst++;
    80005a98:	0a05                	addi	s4,s4,1
    --n;
    80005a9a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a9c:	47a9                	li	a5,10
    80005a9e:	f8fb90e3          	bne	s7,a5,80005a1e <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aa2:	0003c517          	auipc	a0,0x3c
    80005aa6:	25e50513          	addi	a0,a0,606 # 80041d00 <cons>
    80005aaa:	00001097          	auipc	ra,0x1
    80005aae:	8f8080e7          	jalr	-1800(ra) # 800063a2 <release>

  return target - n;
    80005ab2:	413b053b          	subw	a0,s6,s3
    80005ab6:	a811                	j	80005aca <consoleread+0xec>
        release(&cons.lock);
    80005ab8:	0003c517          	auipc	a0,0x3c
    80005abc:	24850513          	addi	a0,a0,584 # 80041d00 <cons>
    80005ac0:	00001097          	auipc	ra,0x1
    80005ac4:	8e2080e7          	jalr	-1822(ra) # 800063a2 <release>
        return -1;
    80005ac8:	557d                	li	a0,-1
}
    80005aca:	60e6                	ld	ra,88(sp)
    80005acc:	6446                	ld	s0,80(sp)
    80005ace:	64a6                	ld	s1,72(sp)
    80005ad0:	6906                	ld	s2,64(sp)
    80005ad2:	79e2                	ld	s3,56(sp)
    80005ad4:	7a42                	ld	s4,48(sp)
    80005ad6:	7aa2                	ld	s5,40(sp)
    80005ad8:	7b02                	ld	s6,32(sp)
    80005ada:	6be2                	ld	s7,24(sp)
    80005adc:	6125                	addi	sp,sp,96
    80005ade:	8082                	ret
      if(n < target){
    80005ae0:	0009871b          	sext.w	a4,s3
    80005ae4:	fb677fe3          	bgeu	a4,s6,80005aa2 <consoleread+0xc4>
        cons.r--;
    80005ae8:	0003c717          	auipc	a4,0x3c
    80005aec:	2af72823          	sw	a5,688(a4) # 80041d98 <cons+0x98>
    80005af0:	bf4d                	j	80005aa2 <consoleread+0xc4>

0000000080005af2 <consputc>:
{
    80005af2:	1141                	addi	sp,sp,-16
    80005af4:	e406                	sd	ra,8(sp)
    80005af6:	e022                	sd	s0,0(sp)
    80005af8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005afa:	10000793          	li	a5,256
    80005afe:	00f50a63          	beq	a0,a5,80005b12 <consputc+0x20>
    uartputc_sync(c);
    80005b02:	00000097          	auipc	ra,0x0
    80005b06:	560080e7          	jalr	1376(ra) # 80006062 <uartputc_sync>
}
    80005b0a:	60a2                	ld	ra,8(sp)
    80005b0c:	6402                	ld	s0,0(sp)
    80005b0e:	0141                	addi	sp,sp,16
    80005b10:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b12:	4521                	li	a0,8
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	54e080e7          	jalr	1358(ra) # 80006062 <uartputc_sync>
    80005b1c:	02000513          	li	a0,32
    80005b20:	00000097          	auipc	ra,0x0
    80005b24:	542080e7          	jalr	1346(ra) # 80006062 <uartputc_sync>
    80005b28:	4521                	li	a0,8
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	538080e7          	jalr	1336(ra) # 80006062 <uartputc_sync>
    80005b32:	bfe1                	j	80005b0a <consputc+0x18>

0000000080005b34 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b34:	1101                	addi	sp,sp,-32
    80005b36:	ec06                	sd	ra,24(sp)
    80005b38:	e822                	sd	s0,16(sp)
    80005b3a:	e426                	sd	s1,8(sp)
    80005b3c:	e04a                	sd	s2,0(sp)
    80005b3e:	1000                	addi	s0,sp,32
    80005b40:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b42:	0003c517          	auipc	a0,0x3c
    80005b46:	1be50513          	addi	a0,a0,446 # 80041d00 <cons>
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	7a4080e7          	jalr	1956(ra) # 800062ee <acquire>

  switch(c){
    80005b52:	47d5                	li	a5,21
    80005b54:	0af48663          	beq	s1,a5,80005c00 <consoleintr+0xcc>
    80005b58:	0297ca63          	blt	a5,s1,80005b8c <consoleintr+0x58>
    80005b5c:	47a1                	li	a5,8
    80005b5e:	0ef48763          	beq	s1,a5,80005c4c <consoleintr+0x118>
    80005b62:	47c1                	li	a5,16
    80005b64:	10f49a63          	bne	s1,a5,80005c78 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b68:	ffffc097          	auipc	ra,0xffffc
    80005b6c:	084080e7          	jalr	132(ra) # 80001bec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b70:	0003c517          	auipc	a0,0x3c
    80005b74:	19050513          	addi	a0,a0,400 # 80041d00 <cons>
    80005b78:	00001097          	auipc	ra,0x1
    80005b7c:	82a080e7          	jalr	-2006(ra) # 800063a2 <release>
}
    80005b80:	60e2                	ld	ra,24(sp)
    80005b82:	6442                	ld	s0,16(sp)
    80005b84:	64a2                	ld	s1,8(sp)
    80005b86:	6902                	ld	s2,0(sp)
    80005b88:	6105                	addi	sp,sp,32
    80005b8a:	8082                	ret
  switch(c){
    80005b8c:	07f00793          	li	a5,127
    80005b90:	0af48e63          	beq	s1,a5,80005c4c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b94:	0003c717          	auipc	a4,0x3c
    80005b98:	16c70713          	addi	a4,a4,364 # 80041d00 <cons>
    80005b9c:	0a072783          	lw	a5,160(a4)
    80005ba0:	09872703          	lw	a4,152(a4)
    80005ba4:	9f99                	subw	a5,a5,a4
    80005ba6:	07f00713          	li	a4,127
    80005baa:	fcf763e3          	bltu	a4,a5,80005b70 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bae:	47b5                	li	a5,13
    80005bb0:	0cf48763          	beq	s1,a5,80005c7e <consoleintr+0x14a>
      consputc(c);
    80005bb4:	8526                	mv	a0,s1
    80005bb6:	00000097          	auipc	ra,0x0
    80005bba:	f3c080e7          	jalr	-196(ra) # 80005af2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bbe:	0003c797          	auipc	a5,0x3c
    80005bc2:	14278793          	addi	a5,a5,322 # 80041d00 <cons>
    80005bc6:	0a07a683          	lw	a3,160(a5)
    80005bca:	0016871b          	addiw	a4,a3,1
    80005bce:	0007061b          	sext.w	a2,a4
    80005bd2:	0ae7a023          	sw	a4,160(a5)
    80005bd6:	07f6f693          	andi	a3,a3,127
    80005bda:	97b6                	add	a5,a5,a3
    80005bdc:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005be0:	47a9                	li	a5,10
    80005be2:	0cf48563          	beq	s1,a5,80005cac <consoleintr+0x178>
    80005be6:	4791                	li	a5,4
    80005be8:	0cf48263          	beq	s1,a5,80005cac <consoleintr+0x178>
    80005bec:	0003c797          	auipc	a5,0x3c
    80005bf0:	1ac7a783          	lw	a5,428(a5) # 80041d98 <cons+0x98>
    80005bf4:	9f1d                	subw	a4,a4,a5
    80005bf6:	08000793          	li	a5,128
    80005bfa:	f6f71be3          	bne	a4,a5,80005b70 <consoleintr+0x3c>
    80005bfe:	a07d                	j	80005cac <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c00:	0003c717          	auipc	a4,0x3c
    80005c04:	10070713          	addi	a4,a4,256 # 80041d00 <cons>
    80005c08:	0a072783          	lw	a5,160(a4)
    80005c0c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c10:	0003c497          	auipc	s1,0x3c
    80005c14:	0f048493          	addi	s1,s1,240 # 80041d00 <cons>
    while(cons.e != cons.w &&
    80005c18:	4929                	li	s2,10
    80005c1a:	f4f70be3          	beq	a4,a5,80005b70 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c1e:	37fd                	addiw	a5,a5,-1
    80005c20:	07f7f713          	andi	a4,a5,127
    80005c24:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c26:	01874703          	lbu	a4,24(a4)
    80005c2a:	f52703e3          	beq	a4,s2,80005b70 <consoleintr+0x3c>
      cons.e--;
    80005c2e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c32:	10000513          	li	a0,256
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	ebc080e7          	jalr	-324(ra) # 80005af2 <consputc>
    while(cons.e != cons.w &&
    80005c3e:	0a04a783          	lw	a5,160(s1)
    80005c42:	09c4a703          	lw	a4,156(s1)
    80005c46:	fcf71ce3          	bne	a4,a5,80005c1e <consoleintr+0xea>
    80005c4a:	b71d                	j	80005b70 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c4c:	0003c717          	auipc	a4,0x3c
    80005c50:	0b470713          	addi	a4,a4,180 # 80041d00 <cons>
    80005c54:	0a072783          	lw	a5,160(a4)
    80005c58:	09c72703          	lw	a4,156(a4)
    80005c5c:	f0f70ae3          	beq	a4,a5,80005b70 <consoleintr+0x3c>
      cons.e--;
    80005c60:	37fd                	addiw	a5,a5,-1
    80005c62:	0003c717          	auipc	a4,0x3c
    80005c66:	12f72f23          	sw	a5,318(a4) # 80041da0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c6a:	10000513          	li	a0,256
    80005c6e:	00000097          	auipc	ra,0x0
    80005c72:	e84080e7          	jalr	-380(ra) # 80005af2 <consputc>
    80005c76:	bded                	j	80005b70 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c78:	ee048ce3          	beqz	s1,80005b70 <consoleintr+0x3c>
    80005c7c:	bf21                	j	80005b94 <consoleintr+0x60>
      consputc(c);
    80005c7e:	4529                	li	a0,10
    80005c80:	00000097          	auipc	ra,0x0
    80005c84:	e72080e7          	jalr	-398(ra) # 80005af2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c88:	0003c797          	auipc	a5,0x3c
    80005c8c:	07878793          	addi	a5,a5,120 # 80041d00 <cons>
    80005c90:	0a07a703          	lw	a4,160(a5)
    80005c94:	0017069b          	addiw	a3,a4,1
    80005c98:	0006861b          	sext.w	a2,a3
    80005c9c:	0ad7a023          	sw	a3,160(a5)
    80005ca0:	07f77713          	andi	a4,a4,127
    80005ca4:	97ba                	add	a5,a5,a4
    80005ca6:	4729                	li	a4,10
    80005ca8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cac:	0003c797          	auipc	a5,0x3c
    80005cb0:	0ec7a823          	sw	a2,240(a5) # 80041d9c <cons+0x9c>
        wakeup(&cons.r);
    80005cb4:	0003c517          	auipc	a0,0x3c
    80005cb8:	0e450513          	addi	a0,a0,228 # 80041d98 <cons+0x98>
    80005cbc:	ffffc097          	auipc	ra,0xffffc
    80005cc0:	ae0080e7          	jalr	-1312(ra) # 8000179c <wakeup>
    80005cc4:	b575                	j	80005b70 <consoleintr+0x3c>

0000000080005cc6 <consoleinit>:

void
consoleinit(void)
{
    80005cc6:	1141                	addi	sp,sp,-16
    80005cc8:	e406                	sd	ra,8(sp)
    80005cca:	e022                	sd	s0,0(sp)
    80005ccc:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cce:	00003597          	auipc	a1,0x3
    80005cd2:	b8258593          	addi	a1,a1,-1150 # 80008850 <syscalls+0x3f0>
    80005cd6:	0003c517          	auipc	a0,0x3c
    80005cda:	02a50513          	addi	a0,a0,42 # 80041d00 <cons>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	580080e7          	jalr	1408(ra) # 8000625e <initlock>

  uartinit();
    80005ce6:	00000097          	auipc	ra,0x0
    80005cea:	32c080e7          	jalr	812(ra) # 80006012 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cee:	00033797          	auipc	a5,0x33
    80005cf2:	d3278793          	addi	a5,a5,-718 # 80038a20 <devsw>
    80005cf6:	00000717          	auipc	a4,0x0
    80005cfa:	ce870713          	addi	a4,a4,-792 # 800059de <consoleread>
    80005cfe:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d00:	00000717          	auipc	a4,0x0
    80005d04:	c7a70713          	addi	a4,a4,-902 # 8000597a <consolewrite>
    80005d08:	ef98                	sd	a4,24(a5)
}
    80005d0a:	60a2                	ld	ra,8(sp)
    80005d0c:	6402                	ld	s0,0(sp)
    80005d0e:	0141                	addi	sp,sp,16
    80005d10:	8082                	ret

0000000080005d12 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d12:	7179                	addi	sp,sp,-48
    80005d14:	f406                	sd	ra,40(sp)
    80005d16:	f022                	sd	s0,32(sp)
    80005d18:	ec26                	sd	s1,24(sp)
    80005d1a:	e84a                	sd	s2,16(sp)
    80005d1c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d1e:	c219                	beqz	a2,80005d24 <printint+0x12>
    80005d20:	08054763          	bltz	a0,80005dae <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d24:	2501                	sext.w	a0,a0
    80005d26:	4881                	li	a7,0
    80005d28:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d2c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d2e:	2581                	sext.w	a1,a1
    80005d30:	00003617          	auipc	a2,0x3
    80005d34:	b5060613          	addi	a2,a2,-1200 # 80008880 <digits>
    80005d38:	883a                	mv	a6,a4
    80005d3a:	2705                	addiw	a4,a4,1
    80005d3c:	02b577bb          	remuw	a5,a0,a1
    80005d40:	1782                	slli	a5,a5,0x20
    80005d42:	9381                	srli	a5,a5,0x20
    80005d44:	97b2                	add	a5,a5,a2
    80005d46:	0007c783          	lbu	a5,0(a5)
    80005d4a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d4e:	0005079b          	sext.w	a5,a0
    80005d52:	02b5553b          	divuw	a0,a0,a1
    80005d56:	0685                	addi	a3,a3,1
    80005d58:	feb7f0e3          	bgeu	a5,a1,80005d38 <printint+0x26>

  if(sign)
    80005d5c:	00088c63          	beqz	a7,80005d74 <printint+0x62>
    buf[i++] = '-';
    80005d60:	fe070793          	addi	a5,a4,-32
    80005d64:	00878733          	add	a4,a5,s0
    80005d68:	02d00793          	li	a5,45
    80005d6c:	fef70823          	sb	a5,-16(a4)
    80005d70:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d74:	02e05763          	blez	a4,80005da2 <printint+0x90>
    80005d78:	fd040793          	addi	a5,s0,-48
    80005d7c:	00e784b3          	add	s1,a5,a4
    80005d80:	fff78913          	addi	s2,a5,-1
    80005d84:	993a                	add	s2,s2,a4
    80005d86:	377d                	addiw	a4,a4,-1
    80005d88:	1702                	slli	a4,a4,0x20
    80005d8a:	9301                	srli	a4,a4,0x20
    80005d8c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d90:	fff4c503          	lbu	a0,-1(s1)
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	d5e080e7          	jalr	-674(ra) # 80005af2 <consputc>
  while(--i >= 0)
    80005d9c:	14fd                	addi	s1,s1,-1
    80005d9e:	ff2499e3          	bne	s1,s2,80005d90 <printint+0x7e>
}
    80005da2:	70a2                	ld	ra,40(sp)
    80005da4:	7402                	ld	s0,32(sp)
    80005da6:	64e2                	ld	s1,24(sp)
    80005da8:	6942                	ld	s2,16(sp)
    80005daa:	6145                	addi	sp,sp,48
    80005dac:	8082                	ret
    x = -xx;
    80005dae:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005db2:	4885                	li	a7,1
    x = -xx;
    80005db4:	bf95                	j	80005d28 <printint+0x16>

0000000080005db6 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005db6:	1101                	addi	sp,sp,-32
    80005db8:	ec06                	sd	ra,24(sp)
    80005dba:	e822                	sd	s0,16(sp)
    80005dbc:	e426                	sd	s1,8(sp)
    80005dbe:	1000                	addi	s0,sp,32
    80005dc0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dc2:	0003c797          	auipc	a5,0x3c
    80005dc6:	fe07af23          	sw	zero,-2(a5) # 80041dc0 <pr+0x18>
  printf("panic: ");
    80005dca:	00003517          	auipc	a0,0x3
    80005dce:	a8e50513          	addi	a0,a0,-1394 # 80008858 <syscalls+0x3f8>
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	02e080e7          	jalr	46(ra) # 80005e00 <printf>
  printf(s);
    80005dda:	8526                	mv	a0,s1
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	024080e7          	jalr	36(ra) # 80005e00 <printf>
  printf("\n");
    80005de4:	00002517          	auipc	a0,0x2
    80005de8:	27450513          	addi	a0,a0,628 # 80008058 <etext+0x58>
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	014080e7          	jalr	20(ra) # 80005e00 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005df4:	4785                	li	a5,1
    80005df6:	00003717          	auipc	a4,0x3
    80005dfa:	b6f72323          	sw	a5,-1178(a4) # 8000895c <panicked>
  for(;;)
    80005dfe:	a001                	j	80005dfe <panic+0x48>

0000000080005e00 <printf>:
{
    80005e00:	7131                	addi	sp,sp,-192
    80005e02:	fc86                	sd	ra,120(sp)
    80005e04:	f8a2                	sd	s0,112(sp)
    80005e06:	f4a6                	sd	s1,104(sp)
    80005e08:	f0ca                	sd	s2,96(sp)
    80005e0a:	ecce                	sd	s3,88(sp)
    80005e0c:	e8d2                	sd	s4,80(sp)
    80005e0e:	e4d6                	sd	s5,72(sp)
    80005e10:	e0da                	sd	s6,64(sp)
    80005e12:	fc5e                	sd	s7,56(sp)
    80005e14:	f862                	sd	s8,48(sp)
    80005e16:	f466                	sd	s9,40(sp)
    80005e18:	f06a                	sd	s10,32(sp)
    80005e1a:	ec6e                	sd	s11,24(sp)
    80005e1c:	0100                	addi	s0,sp,128
    80005e1e:	8a2a                	mv	s4,a0
    80005e20:	e40c                	sd	a1,8(s0)
    80005e22:	e810                	sd	a2,16(s0)
    80005e24:	ec14                	sd	a3,24(s0)
    80005e26:	f018                	sd	a4,32(s0)
    80005e28:	f41c                	sd	a5,40(s0)
    80005e2a:	03043823          	sd	a6,48(s0)
    80005e2e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e32:	0003cd97          	auipc	s11,0x3c
    80005e36:	f8edad83          	lw	s11,-114(s11) # 80041dc0 <pr+0x18>
  if(locking)
    80005e3a:	020d9b63          	bnez	s11,80005e70 <printf+0x70>
  if (fmt == 0)
    80005e3e:	040a0263          	beqz	s4,80005e82 <printf+0x82>
  va_start(ap, fmt);
    80005e42:	00840793          	addi	a5,s0,8
    80005e46:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e4a:	000a4503          	lbu	a0,0(s4)
    80005e4e:	14050f63          	beqz	a0,80005fac <printf+0x1ac>
    80005e52:	4981                	li	s3,0
    if(c != '%'){
    80005e54:	02500a93          	li	s5,37
    switch(c){
    80005e58:	07000b93          	li	s7,112
  consputc('x');
    80005e5c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e5e:	00003b17          	auipc	s6,0x3
    80005e62:	a22b0b13          	addi	s6,s6,-1502 # 80008880 <digits>
    switch(c){
    80005e66:	07300c93          	li	s9,115
    80005e6a:	06400c13          	li	s8,100
    80005e6e:	a82d                	j	80005ea8 <printf+0xa8>
    acquire(&pr.lock);
    80005e70:	0003c517          	auipc	a0,0x3c
    80005e74:	f3850513          	addi	a0,a0,-200 # 80041da8 <pr>
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	476080e7          	jalr	1142(ra) # 800062ee <acquire>
    80005e80:	bf7d                	j	80005e3e <printf+0x3e>
    panic("null fmt");
    80005e82:	00003517          	auipc	a0,0x3
    80005e86:	9e650513          	addi	a0,a0,-1562 # 80008868 <syscalls+0x408>
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	f2c080e7          	jalr	-212(ra) # 80005db6 <panic>
      consputc(c);
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	c60080e7          	jalr	-928(ra) # 80005af2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e9a:	2985                	addiw	s3,s3,1
    80005e9c:	013a07b3          	add	a5,s4,s3
    80005ea0:	0007c503          	lbu	a0,0(a5)
    80005ea4:	10050463          	beqz	a0,80005fac <printf+0x1ac>
    if(c != '%'){
    80005ea8:	ff5515e3          	bne	a0,s5,80005e92 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eac:	2985                	addiw	s3,s3,1
    80005eae:	013a07b3          	add	a5,s4,s3
    80005eb2:	0007c783          	lbu	a5,0(a5)
    80005eb6:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005eba:	cbed                	beqz	a5,80005fac <printf+0x1ac>
    switch(c){
    80005ebc:	05778a63          	beq	a5,s7,80005f10 <printf+0x110>
    80005ec0:	02fbf663          	bgeu	s7,a5,80005eec <printf+0xec>
    80005ec4:	09978863          	beq	a5,s9,80005f54 <printf+0x154>
    80005ec8:	07800713          	li	a4,120
    80005ecc:	0ce79563          	bne	a5,a4,80005f96 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005ed0:	f8843783          	ld	a5,-120(s0)
    80005ed4:	00878713          	addi	a4,a5,8
    80005ed8:	f8e43423          	sd	a4,-120(s0)
    80005edc:	4605                	li	a2,1
    80005ede:	85ea                	mv	a1,s10
    80005ee0:	4388                	lw	a0,0(a5)
    80005ee2:	00000097          	auipc	ra,0x0
    80005ee6:	e30080e7          	jalr	-464(ra) # 80005d12 <printint>
      break;
    80005eea:	bf45                	j	80005e9a <printf+0x9a>
    switch(c){
    80005eec:	09578f63          	beq	a5,s5,80005f8a <printf+0x18a>
    80005ef0:	0b879363          	bne	a5,s8,80005f96 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ef4:	f8843783          	ld	a5,-120(s0)
    80005ef8:	00878713          	addi	a4,a5,8
    80005efc:	f8e43423          	sd	a4,-120(s0)
    80005f00:	4605                	li	a2,1
    80005f02:	45a9                	li	a1,10
    80005f04:	4388                	lw	a0,0(a5)
    80005f06:	00000097          	auipc	ra,0x0
    80005f0a:	e0c080e7          	jalr	-500(ra) # 80005d12 <printint>
      break;
    80005f0e:	b771                	j	80005e9a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f10:	f8843783          	ld	a5,-120(s0)
    80005f14:	00878713          	addi	a4,a5,8
    80005f18:	f8e43423          	sd	a4,-120(s0)
    80005f1c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f20:	03000513          	li	a0,48
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	bce080e7          	jalr	-1074(ra) # 80005af2 <consputc>
  consputc('x');
    80005f2c:	07800513          	li	a0,120
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	bc2080e7          	jalr	-1086(ra) # 80005af2 <consputc>
    80005f38:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f3a:	03c95793          	srli	a5,s2,0x3c
    80005f3e:	97da                	add	a5,a5,s6
    80005f40:	0007c503          	lbu	a0,0(a5)
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	bae080e7          	jalr	-1106(ra) # 80005af2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f4c:	0912                	slli	s2,s2,0x4
    80005f4e:	34fd                	addiw	s1,s1,-1
    80005f50:	f4ed                	bnez	s1,80005f3a <printf+0x13a>
    80005f52:	b7a1                	j	80005e9a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f54:	f8843783          	ld	a5,-120(s0)
    80005f58:	00878713          	addi	a4,a5,8
    80005f5c:	f8e43423          	sd	a4,-120(s0)
    80005f60:	6384                	ld	s1,0(a5)
    80005f62:	cc89                	beqz	s1,80005f7c <printf+0x17c>
      for(; *s; s++)
    80005f64:	0004c503          	lbu	a0,0(s1)
    80005f68:	d90d                	beqz	a0,80005e9a <printf+0x9a>
        consputc(*s);
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	b88080e7          	jalr	-1144(ra) # 80005af2 <consputc>
      for(; *s; s++)
    80005f72:	0485                	addi	s1,s1,1
    80005f74:	0004c503          	lbu	a0,0(s1)
    80005f78:	f96d                	bnez	a0,80005f6a <printf+0x16a>
    80005f7a:	b705                	j	80005e9a <printf+0x9a>
        s = "(null)";
    80005f7c:	00003497          	auipc	s1,0x3
    80005f80:	8e448493          	addi	s1,s1,-1820 # 80008860 <syscalls+0x400>
      for(; *s; s++)
    80005f84:	02800513          	li	a0,40
    80005f88:	b7cd                	j	80005f6a <printf+0x16a>
      consputc('%');
    80005f8a:	8556                	mv	a0,s5
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	b66080e7          	jalr	-1178(ra) # 80005af2 <consputc>
      break;
    80005f94:	b719                	j	80005e9a <printf+0x9a>
      consputc('%');
    80005f96:	8556                	mv	a0,s5
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	b5a080e7          	jalr	-1190(ra) # 80005af2 <consputc>
      consputc(c);
    80005fa0:	8526                	mv	a0,s1
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	b50080e7          	jalr	-1200(ra) # 80005af2 <consputc>
      break;
    80005faa:	bdc5                	j	80005e9a <printf+0x9a>
  if(locking)
    80005fac:	020d9163          	bnez	s11,80005fce <printf+0x1ce>
}
    80005fb0:	70e6                	ld	ra,120(sp)
    80005fb2:	7446                	ld	s0,112(sp)
    80005fb4:	74a6                	ld	s1,104(sp)
    80005fb6:	7906                	ld	s2,96(sp)
    80005fb8:	69e6                	ld	s3,88(sp)
    80005fba:	6a46                	ld	s4,80(sp)
    80005fbc:	6aa6                	ld	s5,72(sp)
    80005fbe:	6b06                	ld	s6,64(sp)
    80005fc0:	7be2                	ld	s7,56(sp)
    80005fc2:	7c42                	ld	s8,48(sp)
    80005fc4:	7ca2                	ld	s9,40(sp)
    80005fc6:	7d02                	ld	s10,32(sp)
    80005fc8:	6de2                	ld	s11,24(sp)
    80005fca:	6129                	addi	sp,sp,192
    80005fcc:	8082                	ret
    release(&pr.lock);
    80005fce:	0003c517          	auipc	a0,0x3c
    80005fd2:	dda50513          	addi	a0,a0,-550 # 80041da8 <pr>
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	3cc080e7          	jalr	972(ra) # 800063a2 <release>
}
    80005fde:	bfc9                	j	80005fb0 <printf+0x1b0>

0000000080005fe0 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fe0:	1101                	addi	sp,sp,-32
    80005fe2:	ec06                	sd	ra,24(sp)
    80005fe4:	e822                	sd	s0,16(sp)
    80005fe6:	e426                	sd	s1,8(sp)
    80005fe8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fea:	0003c497          	auipc	s1,0x3c
    80005fee:	dbe48493          	addi	s1,s1,-578 # 80041da8 <pr>
    80005ff2:	00003597          	auipc	a1,0x3
    80005ff6:	88658593          	addi	a1,a1,-1914 # 80008878 <syscalls+0x418>
    80005ffa:	8526                	mv	a0,s1
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	262080e7          	jalr	610(ra) # 8000625e <initlock>
  pr.locking = 1;
    80006004:	4785                	li	a5,1
    80006006:	cc9c                	sw	a5,24(s1)
}
    80006008:	60e2                	ld	ra,24(sp)
    8000600a:	6442                	ld	s0,16(sp)
    8000600c:	64a2                	ld	s1,8(sp)
    8000600e:	6105                	addi	sp,sp,32
    80006010:	8082                	ret

0000000080006012 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006012:	1141                	addi	sp,sp,-16
    80006014:	e406                	sd	ra,8(sp)
    80006016:	e022                	sd	s0,0(sp)
    80006018:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000601a:	100007b7          	lui	a5,0x10000
    8000601e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006022:	f8000713          	li	a4,-128
    80006026:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000602a:	470d                	li	a4,3
    8000602c:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006030:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006034:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006038:	469d                	li	a3,7
    8000603a:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000603e:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006042:	00003597          	auipc	a1,0x3
    80006046:	85658593          	addi	a1,a1,-1962 # 80008898 <digits+0x18>
    8000604a:	0003c517          	auipc	a0,0x3c
    8000604e:	d7e50513          	addi	a0,a0,-642 # 80041dc8 <uart_tx_lock>
    80006052:	00000097          	auipc	ra,0x0
    80006056:	20c080e7          	jalr	524(ra) # 8000625e <initlock>
}
    8000605a:	60a2                	ld	ra,8(sp)
    8000605c:	6402                	ld	s0,0(sp)
    8000605e:	0141                	addi	sp,sp,16
    80006060:	8082                	ret

0000000080006062 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006062:	1101                	addi	sp,sp,-32
    80006064:	ec06                	sd	ra,24(sp)
    80006066:	e822                	sd	s0,16(sp)
    80006068:	e426                	sd	s1,8(sp)
    8000606a:	1000                	addi	s0,sp,32
    8000606c:	84aa                	mv	s1,a0
  push_off();
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	234080e7          	jalr	564(ra) # 800062a2 <push_off>

  if(panicked){
    80006076:	00003797          	auipc	a5,0x3
    8000607a:	8e67a783          	lw	a5,-1818(a5) # 8000895c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000607e:	10000737          	lui	a4,0x10000
  if(panicked){
    80006082:	c391                	beqz	a5,80006086 <uartputc_sync+0x24>
    for(;;)
    80006084:	a001                	j	80006084 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006086:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000608a:	0207f793          	andi	a5,a5,32
    8000608e:	dfe5                	beqz	a5,80006086 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006090:	0ff4f513          	zext.b	a0,s1
    80006094:	100007b7          	lui	a5,0x10000
    80006098:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	2a6080e7          	jalr	678(ra) # 80006342 <pop_off>
}
    800060a4:	60e2                	ld	ra,24(sp)
    800060a6:	6442                	ld	s0,16(sp)
    800060a8:	64a2                	ld	s1,8(sp)
    800060aa:	6105                	addi	sp,sp,32
    800060ac:	8082                	ret

00000000800060ae <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ae:	00003797          	auipc	a5,0x3
    800060b2:	8b27b783          	ld	a5,-1870(a5) # 80008960 <uart_tx_r>
    800060b6:	00003717          	auipc	a4,0x3
    800060ba:	8b273703          	ld	a4,-1870(a4) # 80008968 <uart_tx_w>
    800060be:	06f70a63          	beq	a4,a5,80006132 <uartstart+0x84>
{
    800060c2:	7139                	addi	sp,sp,-64
    800060c4:	fc06                	sd	ra,56(sp)
    800060c6:	f822                	sd	s0,48(sp)
    800060c8:	f426                	sd	s1,40(sp)
    800060ca:	f04a                	sd	s2,32(sp)
    800060cc:	ec4e                	sd	s3,24(sp)
    800060ce:	e852                	sd	s4,16(sp)
    800060d0:	e456                	sd	s5,8(sp)
    800060d2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060d4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060d8:	0003ca17          	auipc	s4,0x3c
    800060dc:	cf0a0a13          	addi	s4,s4,-784 # 80041dc8 <uart_tx_lock>
    uart_tx_r += 1;
    800060e0:	00003497          	auipc	s1,0x3
    800060e4:	88048493          	addi	s1,s1,-1920 # 80008960 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060e8:	00003997          	auipc	s3,0x3
    800060ec:	88098993          	addi	s3,s3,-1920 # 80008968 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060f4:	02077713          	andi	a4,a4,32
    800060f8:	c705                	beqz	a4,80006120 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060fa:	01f7f713          	andi	a4,a5,31
    800060fe:	9752                	add	a4,a4,s4
    80006100:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006104:	0785                	addi	a5,a5,1
    80006106:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006108:	8526                	mv	a0,s1
    8000610a:	ffffb097          	auipc	ra,0xffffb
    8000610e:	692080e7          	jalr	1682(ra) # 8000179c <wakeup>
    
    WriteReg(THR, c);
    80006112:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006116:	609c                	ld	a5,0(s1)
    80006118:	0009b703          	ld	a4,0(s3)
    8000611c:	fcf71ae3          	bne	a4,a5,800060f0 <uartstart+0x42>
  }
}
    80006120:	70e2                	ld	ra,56(sp)
    80006122:	7442                	ld	s0,48(sp)
    80006124:	74a2                	ld	s1,40(sp)
    80006126:	7902                	ld	s2,32(sp)
    80006128:	69e2                	ld	s3,24(sp)
    8000612a:	6a42                	ld	s4,16(sp)
    8000612c:	6aa2                	ld	s5,8(sp)
    8000612e:	6121                	addi	sp,sp,64
    80006130:	8082                	ret
    80006132:	8082                	ret

0000000080006134 <uartputc>:
{
    80006134:	7179                	addi	sp,sp,-48
    80006136:	f406                	sd	ra,40(sp)
    80006138:	f022                	sd	s0,32(sp)
    8000613a:	ec26                	sd	s1,24(sp)
    8000613c:	e84a                	sd	s2,16(sp)
    8000613e:	e44e                	sd	s3,8(sp)
    80006140:	e052                	sd	s4,0(sp)
    80006142:	1800                	addi	s0,sp,48
    80006144:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006146:	0003c517          	auipc	a0,0x3c
    8000614a:	c8250513          	addi	a0,a0,-894 # 80041dc8 <uart_tx_lock>
    8000614e:	00000097          	auipc	ra,0x0
    80006152:	1a0080e7          	jalr	416(ra) # 800062ee <acquire>
  if(panicked){
    80006156:	00003797          	auipc	a5,0x3
    8000615a:	8067a783          	lw	a5,-2042(a5) # 8000895c <panicked>
    8000615e:	e7c9                	bnez	a5,800061e8 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006160:	00003717          	auipc	a4,0x3
    80006164:	80873703          	ld	a4,-2040(a4) # 80008968 <uart_tx_w>
    80006168:	00002797          	auipc	a5,0x2
    8000616c:	7f87b783          	ld	a5,2040(a5) # 80008960 <uart_tx_r>
    80006170:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006174:	0003c997          	auipc	s3,0x3c
    80006178:	c5498993          	addi	s3,s3,-940 # 80041dc8 <uart_tx_lock>
    8000617c:	00002497          	auipc	s1,0x2
    80006180:	7e448493          	addi	s1,s1,2020 # 80008960 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006184:	00002917          	auipc	s2,0x2
    80006188:	7e490913          	addi	s2,s2,2020 # 80008968 <uart_tx_w>
    8000618c:	00e79f63          	bne	a5,a4,800061aa <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006190:	85ce                	mv	a1,s3
    80006192:	8526                	mv	a0,s1
    80006194:	ffffb097          	auipc	ra,0xffffb
    80006198:	5a4080e7          	jalr	1444(ra) # 80001738 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000619c:	00093703          	ld	a4,0(s2)
    800061a0:	609c                	ld	a5,0(s1)
    800061a2:	02078793          	addi	a5,a5,32
    800061a6:	fee785e3          	beq	a5,a4,80006190 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061aa:	0003c497          	auipc	s1,0x3c
    800061ae:	c1e48493          	addi	s1,s1,-994 # 80041dc8 <uart_tx_lock>
    800061b2:	01f77793          	andi	a5,a4,31
    800061b6:	97a6                	add	a5,a5,s1
    800061b8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800061bc:	0705                	addi	a4,a4,1
    800061be:	00002797          	auipc	a5,0x2
    800061c2:	7ae7b523          	sd	a4,1962(a5) # 80008968 <uart_tx_w>
  uartstart();
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	ee8080e7          	jalr	-280(ra) # 800060ae <uartstart>
  release(&uart_tx_lock);
    800061ce:	8526                	mv	a0,s1
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	1d2080e7          	jalr	466(ra) # 800063a2 <release>
}
    800061d8:	70a2                	ld	ra,40(sp)
    800061da:	7402                	ld	s0,32(sp)
    800061dc:	64e2                	ld	s1,24(sp)
    800061de:	6942                	ld	s2,16(sp)
    800061e0:	69a2                	ld	s3,8(sp)
    800061e2:	6a02                	ld	s4,0(sp)
    800061e4:	6145                	addi	sp,sp,48
    800061e6:	8082                	ret
    for(;;)
    800061e8:	a001                	j	800061e8 <uartputc+0xb4>

00000000800061ea <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061ea:	1141                	addi	sp,sp,-16
    800061ec:	e422                	sd	s0,8(sp)
    800061ee:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061f0:	100007b7          	lui	a5,0x10000
    800061f4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061f8:	8b85                	andi	a5,a5,1
    800061fa:	cb81                	beqz	a5,8000620a <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061fc:	100007b7          	lui	a5,0x10000
    80006200:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006204:	6422                	ld	s0,8(sp)
    80006206:	0141                	addi	sp,sp,16
    80006208:	8082                	ret
    return -1;
    8000620a:	557d                	li	a0,-1
    8000620c:	bfe5                	j	80006204 <uartgetc+0x1a>

000000008000620e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000620e:	1101                	addi	sp,sp,-32
    80006210:	ec06                	sd	ra,24(sp)
    80006212:	e822                	sd	s0,16(sp)
    80006214:	e426                	sd	s1,8(sp)
    80006216:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006218:	54fd                	li	s1,-1
    8000621a:	a029                	j	80006224 <uartintr+0x16>
      break;
    consoleintr(c);
    8000621c:	00000097          	auipc	ra,0x0
    80006220:	918080e7          	jalr	-1768(ra) # 80005b34 <consoleintr>
    int c = uartgetc();
    80006224:	00000097          	auipc	ra,0x0
    80006228:	fc6080e7          	jalr	-58(ra) # 800061ea <uartgetc>
    if(c == -1)
    8000622c:	fe9518e3          	bne	a0,s1,8000621c <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006230:	0003c497          	auipc	s1,0x3c
    80006234:	b9848493          	addi	s1,s1,-1128 # 80041dc8 <uart_tx_lock>
    80006238:	8526                	mv	a0,s1
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	0b4080e7          	jalr	180(ra) # 800062ee <acquire>
  uartstart();
    80006242:	00000097          	auipc	ra,0x0
    80006246:	e6c080e7          	jalr	-404(ra) # 800060ae <uartstart>
  release(&uart_tx_lock);
    8000624a:	8526                	mv	a0,s1
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	156080e7          	jalr	342(ra) # 800063a2 <release>
}
    80006254:	60e2                	ld	ra,24(sp)
    80006256:	6442                	ld	s0,16(sp)
    80006258:	64a2                	ld	s1,8(sp)
    8000625a:	6105                	addi	sp,sp,32
    8000625c:	8082                	ret

000000008000625e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000625e:	1141                	addi	sp,sp,-16
    80006260:	e422                	sd	s0,8(sp)
    80006262:	0800                	addi	s0,sp,16
  lk->name = name;
    80006264:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006266:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000626a:	00053823          	sd	zero,16(a0)
}
    8000626e:	6422                	ld	s0,8(sp)
    80006270:	0141                	addi	sp,sp,16
    80006272:	8082                	ret

0000000080006274 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006274:	411c                	lw	a5,0(a0)
    80006276:	e399                	bnez	a5,8000627c <holding+0x8>
    80006278:	4501                	li	a0,0
  return r;
}
    8000627a:	8082                	ret
{
    8000627c:	1101                	addi	sp,sp,-32
    8000627e:	ec06                	sd	ra,24(sp)
    80006280:	e822                	sd	s0,16(sp)
    80006282:	e426                	sd	s1,8(sp)
    80006284:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006286:	6904                	ld	s1,16(a0)
    80006288:	ffffb097          	auipc	ra,0xffffb
    8000628c:	dec080e7          	jalr	-532(ra) # 80001074 <mycpu>
    80006290:	40a48533          	sub	a0,s1,a0
    80006294:	00153513          	seqz	a0,a0
}
    80006298:	60e2                	ld	ra,24(sp)
    8000629a:	6442                	ld	s0,16(sp)
    8000629c:	64a2                	ld	s1,8(sp)
    8000629e:	6105                	addi	sp,sp,32
    800062a0:	8082                	ret

00000000800062a2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062ac:	100024f3          	csrr	s1,sstatus
    800062b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062b4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062b6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062ba:	ffffb097          	auipc	ra,0xffffb
    800062be:	dba080e7          	jalr	-582(ra) # 80001074 <mycpu>
    800062c2:	5d3c                	lw	a5,120(a0)
    800062c4:	cf89                	beqz	a5,800062de <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062c6:	ffffb097          	auipc	ra,0xffffb
    800062ca:	dae080e7          	jalr	-594(ra) # 80001074 <mycpu>
    800062ce:	5d3c                	lw	a5,120(a0)
    800062d0:	2785                	addiw	a5,a5,1
    800062d2:	dd3c                	sw	a5,120(a0)
}
    800062d4:	60e2                	ld	ra,24(sp)
    800062d6:	6442                	ld	s0,16(sp)
    800062d8:	64a2                	ld	s1,8(sp)
    800062da:	6105                	addi	sp,sp,32
    800062dc:	8082                	ret
    mycpu()->intena = old;
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	d96080e7          	jalr	-618(ra) # 80001074 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062e6:	8085                	srli	s1,s1,0x1
    800062e8:	8885                	andi	s1,s1,1
    800062ea:	dd64                	sw	s1,124(a0)
    800062ec:	bfe9                	j	800062c6 <push_off+0x24>

00000000800062ee <acquire>:
{
    800062ee:	1101                	addi	sp,sp,-32
    800062f0:	ec06                	sd	ra,24(sp)
    800062f2:	e822                	sd	s0,16(sp)
    800062f4:	e426                	sd	s1,8(sp)
    800062f6:	1000                	addi	s0,sp,32
    800062f8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	fa8080e7          	jalr	-88(ra) # 800062a2 <push_off>
  if(holding(lk))
    80006302:	8526                	mv	a0,s1
    80006304:	00000097          	auipc	ra,0x0
    80006308:	f70080e7          	jalr	-144(ra) # 80006274 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000630c:	4705                	li	a4,1
  if(holding(lk))
    8000630e:	e115                	bnez	a0,80006332 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006310:	87ba                	mv	a5,a4
    80006312:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006316:	2781                	sext.w	a5,a5
    80006318:	ffe5                	bnez	a5,80006310 <acquire+0x22>
  __sync_synchronize();
    8000631a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000631e:	ffffb097          	auipc	ra,0xffffb
    80006322:	d56080e7          	jalr	-682(ra) # 80001074 <mycpu>
    80006326:	e888                	sd	a0,16(s1)
}
    80006328:	60e2                	ld	ra,24(sp)
    8000632a:	6442                	ld	s0,16(sp)
    8000632c:	64a2                	ld	s1,8(sp)
    8000632e:	6105                	addi	sp,sp,32
    80006330:	8082                	ret
    panic("acquire");
    80006332:	00002517          	auipc	a0,0x2
    80006336:	56e50513          	addi	a0,a0,1390 # 800088a0 <digits+0x20>
    8000633a:	00000097          	auipc	ra,0x0
    8000633e:	a7c080e7          	jalr	-1412(ra) # 80005db6 <panic>

0000000080006342 <pop_off>:

void
pop_off(void)
{
    80006342:	1141                	addi	sp,sp,-16
    80006344:	e406                	sd	ra,8(sp)
    80006346:	e022                	sd	s0,0(sp)
    80006348:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	d2a080e7          	jalr	-726(ra) # 80001074 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006352:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006356:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006358:	e78d                	bnez	a5,80006382 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000635a:	5d3c                	lw	a5,120(a0)
    8000635c:	02f05b63          	blez	a5,80006392 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006360:	37fd                	addiw	a5,a5,-1
    80006362:	0007871b          	sext.w	a4,a5
    80006366:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006368:	eb09                	bnez	a4,8000637a <pop_off+0x38>
    8000636a:	5d7c                	lw	a5,124(a0)
    8000636c:	c799                	beqz	a5,8000637a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000636e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006372:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006376:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000637a:	60a2                	ld	ra,8(sp)
    8000637c:	6402                	ld	s0,0(sp)
    8000637e:	0141                	addi	sp,sp,16
    80006380:	8082                	ret
    panic("pop_off - interruptible");
    80006382:	00002517          	auipc	a0,0x2
    80006386:	52650513          	addi	a0,a0,1318 # 800088a8 <digits+0x28>
    8000638a:	00000097          	auipc	ra,0x0
    8000638e:	a2c080e7          	jalr	-1492(ra) # 80005db6 <panic>
    panic("pop_off");
    80006392:	00002517          	auipc	a0,0x2
    80006396:	52e50513          	addi	a0,a0,1326 # 800088c0 <digits+0x40>
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	a1c080e7          	jalr	-1508(ra) # 80005db6 <panic>

00000000800063a2 <release>:
{
    800063a2:	1101                	addi	sp,sp,-32
    800063a4:	ec06                	sd	ra,24(sp)
    800063a6:	e822                	sd	s0,16(sp)
    800063a8:	e426                	sd	s1,8(sp)
    800063aa:	1000                	addi	s0,sp,32
    800063ac:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	ec6080e7          	jalr	-314(ra) # 80006274 <holding>
    800063b6:	c115                	beqz	a0,800063da <release+0x38>
  lk->cpu = 0;
    800063b8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063bc:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063c0:	0f50000f          	fence	iorw,ow
    800063c4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	f7a080e7          	jalr	-134(ra) # 80006342 <pop_off>
}
    800063d0:	60e2                	ld	ra,24(sp)
    800063d2:	6442                	ld	s0,16(sp)
    800063d4:	64a2                	ld	s1,8(sp)
    800063d6:	6105                	addi	sp,sp,32
    800063d8:	8082                	ret
    panic("release");
    800063da:	00002517          	auipc	a0,0x2
    800063de:	4ee50513          	addi	a0,a0,1262 # 800088c8 <digits+0x48>
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	9d4080e7          	jalr	-1580(ra) # 80005db6 <panic>
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
