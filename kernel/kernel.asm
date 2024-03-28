
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	49d050ef          	jal	ra,80005cb2 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	00028797          	auipc	a5,0x28
    8000003a:	b3278793          	addi	a5,a5,-1230 # 80027b68 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	214080e7          	jalr	532(ra) # 80000262 <memset>

  r = (struct run*)pa;
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	5e2080e7          	jalr	1506(ra) # 80006638 <push_off>
  int id = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	ec0080e7          	jalr	-320(ra) # 80000f1e <cpuid>
  acquire(&kmems[id].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	92aa8a93          	addi	s5,s5,-1750 # 80008990 <kmems>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	608080e7          	jalr	1544(ra) # 80006684 <acquire>
  r->next = kmems[id].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmems[id].freelist = r;  
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmems[id].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	6c4080e7          	jalr	1732(ra) # 80006754 <release>
  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	65c080e7          	jalr	1628(ra) # 800066f4 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	0a8080e7          	jalr	168(ra) # 80006162 <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	00e504b3          	add	s1,a0,a4
    800000dc:	777d                	lui	a4,0xfffff
    800000de:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3c>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x2a>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7179                	addi	sp,sp,-48
    80000110:	f406                	sd	ra,40(sp)
    80000112:	f022                	sd	s0,32(sp)
    80000114:	ec26                	sd	s1,24(sp)
    80000116:	e84a                	sd	s2,16(sp)
    80000118:	e44e                	sd	s3,8(sp)
    8000011a:	1800                	addi	s0,sp,48
  for(int i = 0; i < NCPU; ++i){
    8000011c:	00009497          	auipc	s1,0x9
    80000120:	87448493          	addi	s1,s1,-1932 # 80008990 <kmems>
    80000124:	00009997          	auipc	s3,0x9
    80000128:	9ac98993          	addi	s3,s3,-1620 # 80008ad0 <pid_lock>
    initlock(&kmems[i].lock, "kmem");
    8000012c:	00008917          	auipc	s2,0x8
    80000130:	eec90913          	addi	s2,s2,-276 # 80008018 <etext+0x18>
    80000134:	85ca                	mv	a1,s2
    80000136:	8526                	mv	a0,s1
    80000138:	00006097          	auipc	ra,0x6
    8000013c:	6c8080e7          	jalr	1736(ra) # 80006800 <initlock>
  for(int i = 0; i < NCPU; ++i){
    80000140:	02848493          	addi	s1,s1,40
    80000144:	ff3498e3          	bne	s1,s3,80000134 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    80000148:	45c5                	li	a1,17
    8000014a:	05ee                	slli	a1,a1,0x1b
    8000014c:	00028517          	auipc	a0,0x28
    80000150:	a1c50513          	addi	a0,a0,-1508 # 80027b68 <end>
    80000154:	00000097          	auipc	ra,0x0
    80000158:	f6e080e7          	jalr	-146(ra) # 800000c2 <freerange>
}
    8000015c:	70a2                	ld	ra,40(sp)
    8000015e:	7402                	ld	s0,32(sp)
    80000160:	64e2                	ld	s1,24(sp)
    80000162:	6942                	ld	s2,16(sp)
    80000164:	69a2                	ld	s3,8(sp)
    80000166:	6145                	addi	sp,sp,48
    80000168:	8082                	ret

000000008000016a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016a:	7139                	addi	sp,sp,-64
    8000016c:	fc06                	sd	ra,56(sp)
    8000016e:	f822                	sd	s0,48(sp)
    80000170:	f426                	sd	s1,40(sp)
    80000172:	f04a                	sd	s2,32(sp)
    80000174:	ec4e                	sd	s3,24(sp)
    80000176:	e852                	sd	s4,16(sp)
    80000178:	e456                	sd	s5,8(sp)
    8000017a:	e05a                	sd	s6,0(sp)
    8000017c:	0080                	addi	s0,sp,64
  struct run *r;
  push_off();
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	4ba080e7          	jalr	1210(ra) # 80006638 <push_off>
  int id = cpuid();
    80000186:	00001097          	auipc	ra,0x1
    8000018a:	d98080e7          	jalr	-616(ra) # 80000f1e <cpuid>
    8000018e:	84aa                	mv	s1,a0
  pop_off();
    80000190:	00006097          	auipc	ra,0x6
    80000194:	564080e7          	jalr	1380(ra) # 800066f4 <pop_off>
  acquire(&kmems[id].lock);
    80000198:	00249793          	slli	a5,s1,0x2
    8000019c:	97a6                	add	a5,a5,s1
    8000019e:	078e                	slli	a5,a5,0x3
    800001a0:	00008917          	auipc	s2,0x8
    800001a4:	7f090913          	addi	s2,s2,2032 # 80008990 <kmems>
    800001a8:	993e                	add	s2,s2,a5
    800001aa:	854a                	mv	a0,s2
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	4d8080e7          	jalr	1240(ra) # 80006684 <acquire>
  r = kmems[id].freelist;
    800001b4:	02093983          	ld	s3,32(s2)
  if(r){
    800001b8:	02098d63          	beqz	s3,800001f2 <kalloc+0x88>
    kmems[id].freelist = r->next;
    800001bc:	0009b683          	ld	a3,0(s3)
    800001c0:	02d93023          	sd	a3,32(s2)
      kmems[kalloc_i].freelist = r->next;
      release(&kmems[kalloc_i].lock);
      break;
    }
  }
  release(&kmems[id].lock);
    800001c4:	854a                	mv	a0,s2
    800001c6:	00006097          	auipc	ra,0x6
    800001ca:	58e080e7          	jalr	1422(ra) # 80006754 <release>
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001ce:	6605                	lui	a2,0x1
    800001d0:	4595                	li	a1,5
    800001d2:	854e                	mv	a0,s3
    800001d4:	00000097          	auipc	ra,0x0
    800001d8:	08e080e7          	jalr	142(ra) # 80000262 <memset>
  return (void*)r;
}
    800001dc:	854e                	mv	a0,s3
    800001de:	70e2                	ld	ra,56(sp)
    800001e0:	7442                	ld	s0,48(sp)
    800001e2:	74a2                	ld	s1,40(sp)
    800001e4:	7902                	ld	s2,32(sp)
    800001e6:	69e2                	ld	s3,24(sp)
    800001e8:	6a42                	ld	s4,16(sp)
    800001ea:	6aa2                	ld	s5,8(sp)
    800001ec:	6b02                	ld	s6,0(sp)
    800001ee:	6121                	addi	sp,sp,64
    800001f0:	8082                	ret
    for(int kalloc_i = 0; ; kalloc_i = (kalloc_i + 1) % NCPU){  //TODO
    800001f2:	4a81                	li	s5,0
      acquire(&kmems[kalloc_i].lock);
    800001f4:	00008b17          	auipc	s6,0x8
    800001f8:	79cb0b13          	addi	s6,s6,1948 # 80008990 <kmems>
      if(id == kalloc_i){
    800001fc:	049a8763          	beq	s5,s1,8000024a <kalloc+0xe0>
      acquire(&kmems[kalloc_i].lock);
    80000200:	002a9a13          	slli	s4,s5,0x2
    80000204:	9a56                	add	s4,s4,s5
    80000206:	0a0e                	slli	s4,s4,0x3
    80000208:	9a5a                	add	s4,s4,s6
    8000020a:	8552                	mv	a0,s4
    8000020c:	00006097          	auipc	ra,0x6
    80000210:	478080e7          	jalr	1144(ra) # 80006684 <acquire>
      if(!kmems[kalloc_i].freelist){
    80000214:	020a3983          	ld	s3,32(s4) # fffffffffffff020 <end+0xffffffff7ffd74b8>
    80000218:	02098463          	beqz	s3,80000240 <kalloc+0xd6>
      kmems[kalloc_i].freelist = r->next;
    8000021c:	0009b683          	ld	a3,0(s3)
    80000220:	002a9793          	slli	a5,s5,0x2
    80000224:	97d6                	add	a5,a5,s5
    80000226:	078e                	slli	a5,a5,0x3
    80000228:	00008717          	auipc	a4,0x8
    8000022c:	76870713          	addi	a4,a4,1896 # 80008990 <kmems>
    80000230:	97ba                	add	a5,a5,a4
    80000232:	f394                	sd	a3,32(a5)
      release(&kmems[kalloc_i].lock);
    80000234:	8552                	mv	a0,s4
    80000236:	00006097          	auipc	ra,0x6
    8000023a:	51e080e7          	jalr	1310(ra) # 80006754 <release>
      break;
    8000023e:	b759                	j	800001c4 <kalloc+0x5a>
        release(&kmems[kalloc_i].lock);
    80000240:	8552                	mv	a0,s4
    80000242:	00006097          	auipc	ra,0x6
    80000246:	512080e7          	jalr	1298(ra) # 80006754 <release>
    for(int kalloc_i = 0; ; kalloc_i = (kalloc_i + 1) % NCPU){  //TODO
    8000024a:	2a85                	addiw	s5,s5,1
    8000024c:	41fad79b          	sraiw	a5,s5,0x1f
    80000250:	01d7d79b          	srliw	a5,a5,0x1d
    80000254:	00fa8abb          	addw	s5,s5,a5
    80000258:	007afa93          	andi	s5,s5,7
    8000025c:	40fa8abb          	subw	s5,s5,a5
      if(id == kalloc_i){
    80000260:	bf71                	j	800001fc <kalloc+0x92>

0000000080000262 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000262:	1141                	addi	sp,sp,-16
    80000264:	e422                	sd	s0,8(sp)
    80000266:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000268:	ca19                	beqz	a2,8000027e <memset+0x1c>
    8000026a:	87aa                	mv	a5,a0
    8000026c:	1602                	slli	a2,a2,0x20
    8000026e:	9201                	srli	a2,a2,0x20
    80000270:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000274:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000278:	0785                	addi	a5,a5,1
    8000027a:	fee79de3          	bne	a5,a4,80000274 <memset+0x12>
  }
  return dst;
}
    8000027e:	6422                	ld	s0,8(sp)
    80000280:	0141                	addi	sp,sp,16
    80000282:	8082                	ret

0000000080000284 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000284:	1141                	addi	sp,sp,-16
    80000286:	e422                	sd	s0,8(sp)
    80000288:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000028a:	ca05                	beqz	a2,800002ba <memcmp+0x36>
    8000028c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000290:	1682                	slli	a3,a3,0x20
    80000292:	9281                	srli	a3,a3,0x20
    80000294:	0685                	addi	a3,a3,1
    80000296:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000298:	00054783          	lbu	a5,0(a0)
    8000029c:	0005c703          	lbu	a4,0(a1)
    800002a0:	00e79863          	bne	a5,a4,800002b0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002a4:	0505                	addi	a0,a0,1
    800002a6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002a8:	fed518e3          	bne	a0,a3,80000298 <memcmp+0x14>
  }

  return 0;
    800002ac:	4501                	li	a0,0
    800002ae:	a019                	j	800002b4 <memcmp+0x30>
      return *s1 - *s2;
    800002b0:	40e7853b          	subw	a0,a5,a4
}
    800002b4:	6422                	ld	s0,8(sp)
    800002b6:	0141                	addi	sp,sp,16
    800002b8:	8082                	ret
  return 0;
    800002ba:	4501                	li	a0,0
    800002bc:	bfe5                	j	800002b4 <memcmp+0x30>

00000000800002be <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002c4:	c205                	beqz	a2,800002e4 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002c6:	02a5e263          	bltu	a1,a0,800002ea <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002ca:	1602                	slli	a2,a2,0x20
    800002cc:	9201                	srli	a2,a2,0x20
    800002ce:	00c587b3          	add	a5,a1,a2
{
    800002d2:	872a                	mv	a4,a0
      *d++ = *s++;
    800002d4:	0585                	addi	a1,a1,1
    800002d6:	0705                	addi	a4,a4,1
    800002d8:	fff5c683          	lbu	a3,-1(a1)
    800002dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002e0:	fef59ae3          	bne	a1,a5,800002d4 <memmove+0x16>

  return dst;
}
    800002e4:	6422                	ld	s0,8(sp)
    800002e6:	0141                	addi	sp,sp,16
    800002e8:	8082                	ret
  if(s < d && s + n > d){
    800002ea:	02061693          	slli	a3,a2,0x20
    800002ee:	9281                	srli	a3,a3,0x20
    800002f0:	00d58733          	add	a4,a1,a3
    800002f4:	fce57be3          	bgeu	a0,a4,800002ca <memmove+0xc>
    d += n;
    800002f8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002fa:	fff6079b          	addiw	a5,a2,-1
    800002fe:	1782                	slli	a5,a5,0x20
    80000300:	9381                	srli	a5,a5,0x20
    80000302:	fff7c793          	not	a5,a5
    80000306:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000308:	177d                	addi	a4,a4,-1
    8000030a:	16fd                	addi	a3,a3,-1
    8000030c:	00074603          	lbu	a2,0(a4)
    80000310:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000314:	fee79ae3          	bne	a5,a4,80000308 <memmove+0x4a>
    80000318:	b7f1                	j	800002e4 <memmove+0x26>

000000008000031a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e406                	sd	ra,8(sp)
    8000031e:	e022                	sd	s0,0(sp)
    80000320:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000322:	00000097          	auipc	ra,0x0
    80000326:	f9c080e7          	jalr	-100(ra) # 800002be <memmove>
}
    8000032a:	60a2                	ld	ra,8(sp)
    8000032c:	6402                	ld	s0,0(sp)
    8000032e:	0141                	addi	sp,sp,16
    80000330:	8082                	ret

0000000080000332 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000332:	1141                	addi	sp,sp,-16
    80000334:	e422                	sd	s0,8(sp)
    80000336:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000338:	ce11                	beqz	a2,80000354 <strncmp+0x22>
    8000033a:	00054783          	lbu	a5,0(a0)
    8000033e:	cf89                	beqz	a5,80000358 <strncmp+0x26>
    80000340:	0005c703          	lbu	a4,0(a1)
    80000344:	00f71a63          	bne	a4,a5,80000358 <strncmp+0x26>
    n--, p++, q++;
    80000348:	367d                	addiw	a2,a2,-1
    8000034a:	0505                	addi	a0,a0,1
    8000034c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000034e:	f675                	bnez	a2,8000033a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000350:	4501                	li	a0,0
    80000352:	a809                	j	80000364 <strncmp+0x32>
    80000354:	4501                	li	a0,0
    80000356:	a039                	j	80000364 <strncmp+0x32>
  if(n == 0)
    80000358:	ca09                	beqz	a2,8000036a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000035a:	00054503          	lbu	a0,0(a0)
    8000035e:	0005c783          	lbu	a5,0(a1)
    80000362:	9d1d                	subw	a0,a0,a5
}
    80000364:	6422                	ld	s0,8(sp)
    80000366:	0141                	addi	sp,sp,16
    80000368:	8082                	ret
    return 0;
    8000036a:	4501                	li	a0,0
    8000036c:	bfe5                	j	80000364 <strncmp+0x32>

000000008000036e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000036e:	1141                	addi	sp,sp,-16
    80000370:	e422                	sd	s0,8(sp)
    80000372:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000374:	87aa                	mv	a5,a0
    80000376:	86b2                	mv	a3,a2
    80000378:	367d                	addiw	a2,a2,-1
    8000037a:	00d05963          	blez	a3,8000038c <strncpy+0x1e>
    8000037e:	0785                	addi	a5,a5,1
    80000380:	0005c703          	lbu	a4,0(a1)
    80000384:	fee78fa3          	sb	a4,-1(a5)
    80000388:	0585                	addi	a1,a1,1
    8000038a:	f775                	bnez	a4,80000376 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000038c:	873e                	mv	a4,a5
    8000038e:	9fb5                	addw	a5,a5,a3
    80000390:	37fd                	addiw	a5,a5,-1
    80000392:	00c05963          	blez	a2,800003a4 <strncpy+0x36>
    *s++ = 0;
    80000396:	0705                	addi	a4,a4,1
    80000398:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000039c:	40e786bb          	subw	a3,a5,a4
    800003a0:	fed04be3          	bgtz	a3,80000396 <strncpy+0x28>
  return os;
}
    800003a4:	6422                	ld	s0,8(sp)
    800003a6:	0141                	addi	sp,sp,16
    800003a8:	8082                	ret

00000000800003aa <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003aa:	1141                	addi	sp,sp,-16
    800003ac:	e422                	sd	s0,8(sp)
    800003ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003b0:	02c05363          	blez	a2,800003d6 <safestrcpy+0x2c>
    800003b4:	fff6069b          	addiw	a3,a2,-1
    800003b8:	1682                	slli	a3,a3,0x20
    800003ba:	9281                	srli	a3,a3,0x20
    800003bc:	96ae                	add	a3,a3,a1
    800003be:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003c0:	00d58963          	beq	a1,a3,800003d2 <safestrcpy+0x28>
    800003c4:	0585                	addi	a1,a1,1
    800003c6:	0785                	addi	a5,a5,1
    800003c8:	fff5c703          	lbu	a4,-1(a1)
    800003cc:	fee78fa3          	sb	a4,-1(a5)
    800003d0:	fb65                	bnez	a4,800003c0 <safestrcpy+0x16>
    ;
  *s = 0;
    800003d2:	00078023          	sb	zero,0(a5)
  return os;
}
    800003d6:	6422                	ld	s0,8(sp)
    800003d8:	0141                	addi	sp,sp,16
    800003da:	8082                	ret

00000000800003dc <strlen>:

int
strlen(const char *s)
{
    800003dc:	1141                	addi	sp,sp,-16
    800003de:	e422                	sd	s0,8(sp)
    800003e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003e2:	00054783          	lbu	a5,0(a0)
    800003e6:	cf91                	beqz	a5,80000402 <strlen+0x26>
    800003e8:	0505                	addi	a0,a0,1
    800003ea:	87aa                	mv	a5,a0
    800003ec:	86be                	mv	a3,a5
    800003ee:	0785                	addi	a5,a5,1
    800003f0:	fff7c703          	lbu	a4,-1(a5)
    800003f4:	ff65                	bnez	a4,800003ec <strlen+0x10>
    800003f6:	40a6853b          	subw	a0,a3,a0
    800003fa:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800003fc:	6422                	ld	s0,8(sp)
    800003fe:	0141                	addi	sp,sp,16
    80000400:	8082                	ret
  for(n = 0; s[n]; n++)
    80000402:	4501                	li	a0,0
    80000404:	bfe5                	j	800003fc <strlen+0x20>

0000000080000406 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000406:	1101                	addi	sp,sp,-32
    80000408:	ec06                	sd	ra,24(sp)
    8000040a:	e822                	sd	s0,16(sp)
    8000040c:	e426                	sd	s1,8(sp)
    8000040e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000410:	00001097          	auipc	ra,0x1
    80000414:	b0e080e7          	jalr	-1266(ra) # 80000f1e <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    80000418:	00008497          	auipc	s1,0x8
    8000041c:	54848493          	addi	s1,s1,1352 # 80008960 <started>
  if(cpuid() == 0){
    80000420:	c531                	beqz	a0,8000046c <main+0x66>
    while(atomic_read4((int *) &started) == 0)
    80000422:	8526                	mv	a0,s1
    80000424:	00006097          	auipc	ra,0x6
    80000428:	45c080e7          	jalr	1116(ra) # 80006880 <atomic_read4>
    8000042c:	d97d                	beqz	a0,80000422 <main+0x1c>
      ;
    __sync_synchronize();
    8000042e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000432:	00001097          	auipc	ra,0x1
    80000436:	aec080e7          	jalr	-1300(ra) # 80000f1e <cpuid>
    8000043a:	85aa                	mv	a1,a0
    8000043c:	00008517          	auipc	a0,0x8
    80000440:	bfc50513          	addi	a0,a0,-1028 # 80008038 <etext+0x38>
    80000444:	00006097          	auipc	ra,0x6
    80000448:	d68080e7          	jalr	-664(ra) # 800061ac <printf>
    kvminithart();    // turn on paging
    8000044c:	00000097          	auipc	ra,0x0
    80000450:	0e0080e7          	jalr	224(ra) # 8000052c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000454:	00001097          	auipc	ra,0x1
    80000458:	794080e7          	jalr	1940(ra) # 80001be8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000045c:	00005097          	auipc	ra,0x5
    80000460:	ed4080e7          	jalr	-300(ra) # 80005330 <plicinithart>
  }
  scheduler();        
    80000464:	00001097          	auipc	ra,0x1
    80000468:	fdc080e7          	jalr	-36(ra) # 80001440 <scheduler>
    consoleinit();
    8000046c:	00006097          	auipc	ra,0x6
    80000470:	c06080e7          	jalr	-1018(ra) # 80006072 <consoleinit>
    statsinit();
    80000474:	00005097          	auipc	ra,0x5
    80000478:	572080e7          	jalr	1394(ra) # 800059e6 <statsinit>
    printfinit();
    8000047c:	00006097          	auipc	ra,0x6
    80000480:	f10080e7          	jalr	-240(ra) # 8000638c <printfinit>
    printf("\n");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	41450513          	addi	a0,a0,1044 # 80008898 <digits+0x88>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	d20080e7          	jalr	-736(ra) # 800061ac <printf>
    printf("xv6 kernel is booting\n");
    80000494:	00008517          	auipc	a0,0x8
    80000498:	b8c50513          	addi	a0,a0,-1140 # 80008020 <etext+0x20>
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	d10080e7          	jalr	-752(ra) # 800061ac <printf>
    printf("\n");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	3f450513          	addi	a0,a0,1012 # 80008898 <digits+0x88>
    800004ac:	00006097          	auipc	ra,0x6
    800004b0:	d00080e7          	jalr	-768(ra) # 800061ac <printf>
    kinit();         // physical page allocator
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	c5a080e7          	jalr	-934(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	326080e7          	jalr	806(ra) # 800007e2 <kvminit>
    kvminithart();   // turn on paging
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	068080e7          	jalr	104(ra) # 8000052c <kvminithart>
    procinit();      // process table
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	99e080e7          	jalr	-1634(ra) # 80000e6a <procinit>
    trapinit();      // trap vectors
    800004d4:	00001097          	auipc	ra,0x1
    800004d8:	6ec080e7          	jalr	1772(ra) # 80001bc0 <trapinit>
    trapinithart();  // install kernel trap vector
    800004dc:	00001097          	auipc	ra,0x1
    800004e0:	70c080e7          	jalr	1804(ra) # 80001be8 <trapinithart>
    plicinit();      // set up interrupt controller
    800004e4:	00005097          	auipc	ra,0x5
    800004e8:	e36080e7          	jalr	-458(ra) # 8000531a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004ec:	00005097          	auipc	ra,0x5
    800004f0:	e44080e7          	jalr	-444(ra) # 80005330 <plicinithart>
    binit();         // buffer cache
    800004f4:	00002097          	auipc	ra,0x2
    800004f8:	e42080e7          	jalr	-446(ra) # 80002336 <binit>
    iinit();         // inode table
    800004fc:	00002097          	auipc	ra,0x2
    80000500:	6ba080e7          	jalr	1722(ra) # 80002bb6 <iinit>
    fileinit();      // file table
    80000504:	00003097          	auipc	ra,0x3
    80000508:	644080e7          	jalr	1604(ra) # 80003b48 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000050c:	00005097          	auipc	ra,0x5
    80000510:	f2c080e7          	jalr	-212(ra) # 80005438 <virtio_disk_init>
    userinit();      // first user process
    80000514:	00001097          	auipc	ra,0x1
    80000518:	d0e080e7          	jalr	-754(ra) # 80001222 <userinit>
    __sync_synchronize();
    8000051c:	0ff0000f          	fence
    started = 1;
    80000520:	4785                	li	a5,1
    80000522:	00008717          	auipc	a4,0x8
    80000526:	42f72f23          	sw	a5,1086(a4) # 80008960 <started>
    8000052a:	bf2d                	j	80000464 <main+0x5e>

000000008000052c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000052c:	1141                	addi	sp,sp,-16
    8000052e:	e422                	sd	s0,8(sp)
    80000530:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000532:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000536:	00008797          	auipc	a5,0x8
    8000053a:	4327b783          	ld	a5,1074(a5) # 80008968 <kernel_pagetable>
    8000053e:	83b1                	srli	a5,a5,0xc
    80000540:	577d                	li	a4,-1
    80000542:	177e                	slli	a4,a4,0x3f
    80000544:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000546:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000054a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000054e:	6422                	ld	s0,8(sp)
    80000550:	0141                	addi	sp,sp,16
    80000552:	8082                	ret

0000000080000554 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000554:	7139                	addi	sp,sp,-64
    80000556:	fc06                	sd	ra,56(sp)
    80000558:	f822                	sd	s0,48(sp)
    8000055a:	f426                	sd	s1,40(sp)
    8000055c:	f04a                	sd	s2,32(sp)
    8000055e:	ec4e                	sd	s3,24(sp)
    80000560:	e852                	sd	s4,16(sp)
    80000562:	e456                	sd	s5,8(sp)
    80000564:	e05a                	sd	s6,0(sp)
    80000566:	0080                	addi	s0,sp,64
    80000568:	84aa                	mv	s1,a0
    8000056a:	89ae                	mv	s3,a1
    8000056c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000056e:	57fd                	li	a5,-1
    80000570:	83e9                	srli	a5,a5,0x1a
    80000572:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000574:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000576:	04b7f263          	bgeu	a5,a1,800005ba <walk+0x66>
    panic("walk");
    8000057a:	00008517          	auipc	a0,0x8
    8000057e:	ad650513          	addi	a0,a0,-1322 # 80008050 <etext+0x50>
    80000582:	00006097          	auipc	ra,0x6
    80000586:	be0080e7          	jalr	-1056(ra) # 80006162 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000058a:	060a8663          	beqz	s5,800005f6 <walk+0xa2>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	bdc080e7          	jalr	-1060(ra) # 8000016a <kalloc>
    80000596:	84aa                	mv	s1,a0
    80000598:	c529                	beqz	a0,800005e2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000059a:	6605                	lui	a2,0x1
    8000059c:	4581                	li	a1,0
    8000059e:	00000097          	auipc	ra,0x0
    800005a2:	cc4080e7          	jalr	-828(ra) # 80000262 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005a6:	00c4d793          	srli	a5,s1,0xc
    800005aa:	07aa                	slli	a5,a5,0xa
    800005ac:	0017e793          	ori	a5,a5,1
    800005b0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005b4:	3a5d                	addiw	s4,s4,-9
    800005b6:	036a0063          	beq	s4,s6,800005d6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ba:	0149d933          	srl	s2,s3,s4
    800005be:	1ff97913          	andi	s2,s2,511
    800005c2:	090e                	slli	s2,s2,0x3
    800005c4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005c6:	00093483          	ld	s1,0(s2)
    800005ca:	0014f793          	andi	a5,s1,1
    800005ce:	dfd5                	beqz	a5,8000058a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005d0:	80a9                	srli	s1,s1,0xa
    800005d2:	04b2                	slli	s1,s1,0xc
    800005d4:	b7c5                	j	800005b4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005d6:	00c9d513          	srli	a0,s3,0xc
    800005da:	1ff57513          	andi	a0,a0,511
    800005de:	050e                	slli	a0,a0,0x3
    800005e0:	9526                	add	a0,a0,s1
}
    800005e2:	70e2                	ld	ra,56(sp)
    800005e4:	7442                	ld	s0,48(sp)
    800005e6:	74a2                	ld	s1,40(sp)
    800005e8:	7902                	ld	s2,32(sp)
    800005ea:	69e2                	ld	s3,24(sp)
    800005ec:	6a42                	ld	s4,16(sp)
    800005ee:	6aa2                	ld	s5,8(sp)
    800005f0:	6b02                	ld	s6,0(sp)
    800005f2:	6121                	addi	sp,sp,64
    800005f4:	8082                	ret
        return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	b7ed                	j	800005e2 <walk+0x8e>

00000000800005fa <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005fa:	57fd                	li	a5,-1
    800005fc:	83e9                	srli	a5,a5,0x1a
    800005fe:	00b7f463          	bgeu	a5,a1,80000606 <walkaddr+0xc>
    return 0;
    80000602:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000604:	8082                	ret
{
    80000606:	1141                	addi	sp,sp,-16
    80000608:	e406                	sd	ra,8(sp)
    8000060a:	e022                	sd	s0,0(sp)
    8000060c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000060e:	4601                	li	a2,0
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f44080e7          	jalr	-188(ra) # 80000554 <walk>
  if(pte == 0)
    80000618:	c105                	beqz	a0,80000638 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000061a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000061c:	0117f693          	andi	a3,a5,17
    80000620:	4745                	li	a4,17
    return 0;
    80000622:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000624:	00e68663          	beq	a3,a4,80000630 <walkaddr+0x36>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
  pa = PTE2PA(*pte);
    80000630:	83a9                	srli	a5,a5,0xa
    80000632:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000636:	bfcd                	j	80000628 <walkaddr+0x2e>
    return 0;
    80000638:	4501                	li	a0,0
    8000063a:	b7fd                	j	80000628 <walkaddr+0x2e>

000000008000063c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000063c:	715d                	addi	sp,sp,-80
    8000063e:	e486                	sd	ra,72(sp)
    80000640:	e0a2                	sd	s0,64(sp)
    80000642:	fc26                	sd	s1,56(sp)
    80000644:	f84a                	sd	s2,48(sp)
    80000646:	f44e                	sd	s3,40(sp)
    80000648:	f052                	sd	s4,32(sp)
    8000064a:	ec56                	sd	s5,24(sp)
    8000064c:	e85a                	sd	s6,16(sp)
    8000064e:	e45e                	sd	s7,8(sp)
    80000650:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000652:	c639                	beqz	a2,800006a0 <mappages+0x64>
    80000654:	8aaa                	mv	s5,a0
    80000656:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000658:	777d                	lui	a4,0xfffff
    8000065a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000065e:	fff58993          	addi	s3,a1,-1
    80000662:	99b2                	add	s3,s3,a2
    80000664:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000668:	893e                	mv	s2,a5
    8000066a:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000066e:	6b85                	lui	s7,0x1
    80000670:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000674:	4605                	li	a2,1
    80000676:	85ca                	mv	a1,s2
    80000678:	8556                	mv	a0,s5
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	eda080e7          	jalr	-294(ra) # 80000554 <walk>
    80000682:	cd1d                	beqz	a0,800006c0 <mappages+0x84>
    if(*pte & PTE_V)
    80000684:	611c                	ld	a5,0(a0)
    80000686:	8b85                	andi	a5,a5,1
    80000688:	e785                	bnez	a5,800006b0 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000068a:	80b1                	srli	s1,s1,0xc
    8000068c:	04aa                	slli	s1,s1,0xa
    8000068e:	0164e4b3          	or	s1,s1,s6
    80000692:	0014e493          	ori	s1,s1,1
    80000696:	e104                	sd	s1,0(a0)
    if(a == last)
    80000698:	05390063          	beq	s2,s3,800006d8 <mappages+0x9c>
    a += PGSIZE;
    8000069c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000069e:	bfc9                	j	80000670 <mappages+0x34>
    panic("mappages: size");
    800006a0:	00008517          	auipc	a0,0x8
    800006a4:	9b850513          	addi	a0,a0,-1608 # 80008058 <etext+0x58>
    800006a8:	00006097          	auipc	ra,0x6
    800006ac:	aba080e7          	jalr	-1350(ra) # 80006162 <panic>
      panic("mappages: remap");
    800006b0:	00008517          	auipc	a0,0x8
    800006b4:	9b850513          	addi	a0,a0,-1608 # 80008068 <etext+0x68>
    800006b8:	00006097          	auipc	ra,0x6
    800006bc:	aaa080e7          	jalr	-1366(ra) # 80006162 <panic>
      return -1;
    800006c0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006c2:	60a6                	ld	ra,72(sp)
    800006c4:	6406                	ld	s0,64(sp)
    800006c6:	74e2                	ld	s1,56(sp)
    800006c8:	7942                	ld	s2,48(sp)
    800006ca:	79a2                	ld	s3,40(sp)
    800006cc:	7a02                	ld	s4,32(sp)
    800006ce:	6ae2                	ld	s5,24(sp)
    800006d0:	6b42                	ld	s6,16(sp)
    800006d2:	6ba2                	ld	s7,8(sp)
    800006d4:	6161                	addi	sp,sp,80
    800006d6:	8082                	ret
  return 0;
    800006d8:	4501                	li	a0,0
    800006da:	b7e5                	j	800006c2 <mappages+0x86>

00000000800006dc <kvmmap>:
{
    800006dc:	1141                	addi	sp,sp,-16
    800006de:	e406                	sd	ra,8(sp)
    800006e0:	e022                	sd	s0,0(sp)
    800006e2:	0800                	addi	s0,sp,16
    800006e4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006e6:	86b2                	mv	a3,a2
    800006e8:	863e                	mv	a2,a5
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f52080e7          	jalr	-174(ra) # 8000063c <mappages>
    800006f2:	e509                	bnez	a0,800006fc <kvmmap+0x20>
}
    800006f4:	60a2                	ld	ra,8(sp)
    800006f6:	6402                	ld	s0,0(sp)
    800006f8:	0141                	addi	sp,sp,16
    800006fa:	8082                	ret
    panic("kvmmap");
    800006fc:	00008517          	auipc	a0,0x8
    80000700:	97c50513          	addi	a0,a0,-1668 # 80008078 <etext+0x78>
    80000704:	00006097          	auipc	ra,0x6
    80000708:	a5e080e7          	jalr	-1442(ra) # 80006162 <panic>

000000008000070c <kvmmake>:
{
    8000070c:	1101                	addi	sp,sp,-32
    8000070e:	ec06                	sd	ra,24(sp)
    80000710:	e822                	sd	s0,16(sp)
    80000712:	e426                	sd	s1,8(sp)
    80000714:	e04a                	sd	s2,0(sp)
    80000716:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	a52080e7          	jalr	-1454(ra) # 8000016a <kalloc>
    80000720:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000722:	6605                	lui	a2,0x1
    80000724:	4581                	li	a1,0
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b3c080e7          	jalr	-1220(ra) # 80000262 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000072e:	4719                	li	a4,6
    80000730:	6685                	lui	a3,0x1
    80000732:	10000637          	lui	a2,0x10000
    80000736:	100005b7          	lui	a1,0x10000
    8000073a:	8526                	mv	a0,s1
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	fa0080e7          	jalr	-96(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000744:	4719                	li	a4,6
    80000746:	6685                	lui	a3,0x1
    80000748:	10001637          	lui	a2,0x10001
    8000074c:	100015b7          	lui	a1,0x10001
    80000750:	8526                	mv	a0,s1
    80000752:	00000097          	auipc	ra,0x0
    80000756:	f8a080e7          	jalr	-118(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000075a:	4719                	li	a4,6
    8000075c:	004006b7          	lui	a3,0x400
    80000760:	0c000637          	lui	a2,0xc000
    80000764:	0c0005b7          	lui	a1,0xc000
    80000768:	8526                	mv	a0,s1
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	f72080e7          	jalr	-142(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000772:	00008917          	auipc	s2,0x8
    80000776:	88e90913          	addi	s2,s2,-1906 # 80008000 <etext>
    8000077a:	4729                	li	a4,10
    8000077c:	80008697          	auipc	a3,0x80008
    80000780:	88468693          	addi	a3,a3,-1916 # 8000 <_entry-0x7fff8000>
    80000784:	4605                	li	a2,1
    80000786:	067e                	slli	a2,a2,0x1f
    80000788:	85b2                	mv	a1,a2
    8000078a:	8526                	mv	a0,s1
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	f50080e7          	jalr	-176(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000794:	4719                	li	a4,6
    80000796:	46c5                	li	a3,17
    80000798:	06ee                	slli	a3,a3,0x1b
    8000079a:	412686b3          	sub	a3,a3,s2
    8000079e:	864a                	mv	a2,s2
    800007a0:	85ca                	mv	a1,s2
    800007a2:	8526                	mv	a0,s1
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	f38080e7          	jalr	-200(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007ac:	4729                	li	a4,10
    800007ae:	6685                	lui	a3,0x1
    800007b0:	00007617          	auipc	a2,0x7
    800007b4:	85060613          	addi	a2,a2,-1968 # 80007000 <_trampoline>
    800007b8:	040005b7          	lui	a1,0x4000
    800007bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007be:	05b2                	slli	a1,a1,0xc
    800007c0:	8526                	mv	a0,s1
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	f1a080e7          	jalr	-230(ra) # 800006dc <kvmmap>
  proc_mapstacks(kpgtbl);
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	608080e7          	jalr	1544(ra) # 80000dd4 <proc_mapstacks>
}
    800007d4:	8526                	mv	a0,s1
    800007d6:	60e2                	ld	ra,24(sp)
    800007d8:	6442                	ld	s0,16(sp)
    800007da:	64a2                	ld	s1,8(sp)
    800007dc:	6902                	ld	s2,0(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <kvminit>:
{
    800007e2:	1141                	addi	sp,sp,-16
    800007e4:	e406                	sd	ra,8(sp)
    800007e6:	e022                	sd	s0,0(sp)
    800007e8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f22080e7          	jalr	-222(ra) # 8000070c <kvmmake>
    800007f2:	00008797          	auipc	a5,0x8
    800007f6:	16a7bb23          	sd	a0,374(a5) # 80008968 <kernel_pagetable>
}
    800007fa:	60a2                	ld	ra,8(sp)
    800007fc:	6402                	ld	s0,0(sp)
    800007fe:	0141                	addi	sp,sp,16
    80000800:	8082                	ret

0000000080000802 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000802:	715d                	addi	sp,sp,-80
    80000804:	e486                	sd	ra,72(sp)
    80000806:	e0a2                	sd	s0,64(sp)
    80000808:	fc26                	sd	s1,56(sp)
    8000080a:	f84a                	sd	s2,48(sp)
    8000080c:	f44e                	sd	s3,40(sp)
    8000080e:	f052                	sd	s4,32(sp)
    80000810:	ec56                	sd	s5,24(sp)
    80000812:	e85a                	sd	s6,16(sp)
    80000814:	e45e                	sd	s7,8(sp)
    80000816:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000818:	03459793          	slli	a5,a1,0x34
    8000081c:	e795                	bnez	a5,80000848 <uvmunmap+0x46>
    8000081e:	8a2a                	mv	s4,a0
    80000820:	892e                	mv	s2,a1
    80000822:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000824:	0632                	slli	a2,a2,0xc
    80000826:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000082a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000082c:	6b05                	lui	s6,0x1
    8000082e:	0735e263          	bltu	a1,s3,80000892 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000832:	60a6                	ld	ra,72(sp)
    80000834:	6406                	ld	s0,64(sp)
    80000836:	74e2                	ld	s1,56(sp)
    80000838:	7942                	ld	s2,48(sp)
    8000083a:	79a2                	ld	s3,40(sp)
    8000083c:	7a02                	ld	s4,32(sp)
    8000083e:	6ae2                	ld	s5,24(sp)
    80000840:	6b42                	ld	s6,16(sp)
    80000842:	6ba2                	ld	s7,8(sp)
    80000844:	6161                	addi	sp,sp,80
    80000846:	8082                	ret
    panic("uvmunmap: not aligned");
    80000848:	00008517          	auipc	a0,0x8
    8000084c:	83850513          	addi	a0,a0,-1992 # 80008080 <etext+0x80>
    80000850:	00006097          	auipc	ra,0x6
    80000854:	912080e7          	jalr	-1774(ra) # 80006162 <panic>
      panic("uvmunmap: walk");
    80000858:	00008517          	auipc	a0,0x8
    8000085c:	84050513          	addi	a0,a0,-1984 # 80008098 <etext+0x98>
    80000860:	00006097          	auipc	ra,0x6
    80000864:	902080e7          	jalr	-1790(ra) # 80006162 <panic>
      panic("uvmunmap: not mapped");
    80000868:	00008517          	auipc	a0,0x8
    8000086c:	84050513          	addi	a0,a0,-1984 # 800080a8 <etext+0xa8>
    80000870:	00006097          	auipc	ra,0x6
    80000874:	8f2080e7          	jalr	-1806(ra) # 80006162 <panic>
      panic("uvmunmap: not a leaf");
    80000878:	00008517          	auipc	a0,0x8
    8000087c:	84850513          	addi	a0,a0,-1976 # 800080c0 <etext+0xc0>
    80000880:	00006097          	auipc	ra,0x6
    80000884:	8e2080e7          	jalr	-1822(ra) # 80006162 <panic>
    *pte = 0;
    80000888:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000088c:	995a                	add	s2,s2,s6
    8000088e:	fb3972e3          	bgeu	s2,s3,80000832 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000892:	4601                	li	a2,0
    80000894:	85ca                	mv	a1,s2
    80000896:	8552                	mv	a0,s4
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	cbc080e7          	jalr	-836(ra) # 80000554 <walk>
    800008a0:	84aa                	mv	s1,a0
    800008a2:	d95d                	beqz	a0,80000858 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008a4:	6108                	ld	a0,0(a0)
    800008a6:	00157793          	andi	a5,a0,1
    800008aa:	dfdd                	beqz	a5,80000868 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008ac:	3ff57793          	andi	a5,a0,1023
    800008b0:	fd7784e3          	beq	a5,s7,80000878 <uvmunmap+0x76>
    if(do_free){
    800008b4:	fc0a8ae3          	beqz	s5,80000888 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008b8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008ba:	0532                	slli	a0,a0,0xc
    800008bc:	fffff097          	auipc	ra,0xfffff
    800008c0:	760080e7          	jalr	1888(ra) # 8000001c <kfree>
    800008c4:	b7d1                	j	80000888 <uvmunmap+0x86>

00000000800008c6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008c6:	1101                	addi	sp,sp,-32
    800008c8:	ec06                	sd	ra,24(sp)
    800008ca:	e822                	sd	s0,16(sp)
    800008cc:	e426                	sd	s1,8(sp)
    800008ce:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	89a080e7          	jalr	-1894(ra) # 8000016a <kalloc>
    800008d8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008da:	c519                	beqz	a0,800008e8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008dc:	6605                	lui	a2,0x1
    800008de:	4581                	li	a1,0
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	982080e7          	jalr	-1662(ra) # 80000262 <memset>
  return pagetable;
}
    800008e8:	8526                	mv	a0,s1
    800008ea:	60e2                	ld	ra,24(sp)
    800008ec:	6442                	ld	s0,16(sp)
    800008ee:	64a2                	ld	s1,8(sp)
    800008f0:	6105                	addi	sp,sp,32
    800008f2:	8082                	ret

00000000800008f4 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800008f4:	7179                	addi	sp,sp,-48
    800008f6:	f406                	sd	ra,40(sp)
    800008f8:	f022                	sd	s0,32(sp)
    800008fa:	ec26                	sd	s1,24(sp)
    800008fc:	e84a                	sd	s2,16(sp)
    800008fe:	e44e                	sd	s3,8(sp)
    80000900:	e052                	sd	s4,0(sp)
    80000902:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000904:	6785                	lui	a5,0x1
    80000906:	04f67863          	bgeu	a2,a5,80000956 <uvmfirst+0x62>
    8000090a:	8a2a                	mv	s4,a0
    8000090c:	89ae                	mv	s3,a1
    8000090e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000910:	00000097          	auipc	ra,0x0
    80000914:	85a080e7          	jalr	-1958(ra) # 8000016a <kalloc>
    80000918:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000091a:	6605                	lui	a2,0x1
    8000091c:	4581                	li	a1,0
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	944080e7          	jalr	-1724(ra) # 80000262 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000926:	4779                	li	a4,30
    80000928:	86ca                	mv	a3,s2
    8000092a:	6605                	lui	a2,0x1
    8000092c:	4581                	li	a1,0
    8000092e:	8552                	mv	a0,s4
    80000930:	00000097          	auipc	ra,0x0
    80000934:	d0c080e7          	jalr	-756(ra) # 8000063c <mappages>
  memmove(mem, src, sz);
    80000938:	8626                	mv	a2,s1
    8000093a:	85ce                	mv	a1,s3
    8000093c:	854a                	mv	a0,s2
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	980080e7          	jalr	-1664(ra) # 800002be <memmove>
}
    80000946:	70a2                	ld	ra,40(sp)
    80000948:	7402                	ld	s0,32(sp)
    8000094a:	64e2                	ld	s1,24(sp)
    8000094c:	6942                	ld	s2,16(sp)
    8000094e:	69a2                	ld	s3,8(sp)
    80000950:	6a02                	ld	s4,0(sp)
    80000952:	6145                	addi	sp,sp,48
    80000954:	8082                	ret
    panic("uvmfirst: more than a page");
    80000956:	00007517          	auipc	a0,0x7
    8000095a:	78250513          	addi	a0,a0,1922 # 800080d8 <etext+0xd8>
    8000095e:	00006097          	auipc	ra,0x6
    80000962:	804080e7          	jalr	-2044(ra) # 80006162 <panic>

0000000080000966 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000966:	1101                	addi	sp,sp,-32
    80000968:	ec06                	sd	ra,24(sp)
    8000096a:	e822                	sd	s0,16(sp)
    8000096c:	e426                	sd	s1,8(sp)
    8000096e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000970:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000972:	00b67d63          	bgeu	a2,a1,8000098c <uvmdealloc+0x26>
    80000976:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000978:	6785                	lui	a5,0x1
    8000097a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000097c:	00f60733          	add	a4,a2,a5
    80000980:	76fd                	lui	a3,0xfffff
    80000982:	8f75                	and	a4,a4,a3
    80000984:	97ae                	add	a5,a5,a1
    80000986:	8ff5                	and	a5,a5,a3
    80000988:	00f76863          	bltu	a4,a5,80000998 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000098c:	8526                	mv	a0,s1
    8000098e:	60e2                	ld	ra,24(sp)
    80000990:	6442                	ld	s0,16(sp)
    80000992:	64a2                	ld	s1,8(sp)
    80000994:	6105                	addi	sp,sp,32
    80000996:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000998:	8f99                	sub	a5,a5,a4
    8000099a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000099c:	4685                	li	a3,1
    8000099e:	0007861b          	sext.w	a2,a5
    800009a2:	85ba                	mv	a1,a4
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	e5e080e7          	jalr	-418(ra) # 80000802 <uvmunmap>
    800009ac:	b7c5                	j	8000098c <uvmdealloc+0x26>

00000000800009ae <uvmalloc>:
  if(newsz < oldsz)
    800009ae:	0ab66563          	bltu	a2,a1,80000a58 <uvmalloc+0xaa>
{
    800009b2:	7139                	addi	sp,sp,-64
    800009b4:	fc06                	sd	ra,56(sp)
    800009b6:	f822                	sd	s0,48(sp)
    800009b8:	f426                	sd	s1,40(sp)
    800009ba:	f04a                	sd	s2,32(sp)
    800009bc:	ec4e                	sd	s3,24(sp)
    800009be:	e852                	sd	s4,16(sp)
    800009c0:	e456                	sd	s5,8(sp)
    800009c2:	e05a                	sd	s6,0(sp)
    800009c4:	0080                	addi	s0,sp,64
    800009c6:	8aaa                	mv	s5,a0
    800009c8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009ca:	6785                	lui	a5,0x1
    800009cc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009ce:	95be                	add	a1,a1,a5
    800009d0:	77fd                	lui	a5,0xfffff
    800009d2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009d6:	08c9f363          	bgeu	s3,a2,80000a5c <uvmalloc+0xae>
    800009da:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009dc:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009e0:	fffff097          	auipc	ra,0xfffff
    800009e4:	78a080e7          	jalr	1930(ra) # 8000016a <kalloc>
    800009e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800009ea:	c51d                	beqz	a0,80000a18 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009ec:	6605                	lui	a2,0x1
    800009ee:	4581                	li	a1,0
    800009f0:	00000097          	auipc	ra,0x0
    800009f4:	872080e7          	jalr	-1934(ra) # 80000262 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009f8:	875a                	mv	a4,s6
    800009fa:	86a6                	mv	a3,s1
    800009fc:	6605                	lui	a2,0x1
    800009fe:	85ca                	mv	a1,s2
    80000a00:	8556                	mv	a0,s5
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	c3a080e7          	jalr	-966(ra) # 8000063c <mappages>
    80000a0a:	e90d                	bnez	a0,80000a3c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a0c:	6785                	lui	a5,0x1
    80000a0e:	993e                	add	s2,s2,a5
    80000a10:	fd4968e3          	bltu	s2,s4,800009e0 <uvmalloc+0x32>
  return newsz;
    80000a14:	8552                	mv	a0,s4
    80000a16:	a809                	j	80000a28 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a18:	864e                	mv	a2,s3
    80000a1a:	85ca                	mv	a1,s2
    80000a1c:	8556                	mv	a0,s5
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f48080e7          	jalr	-184(ra) # 80000966 <uvmdealloc>
      return 0;
    80000a26:	4501                	li	a0,0
}
    80000a28:	70e2                	ld	ra,56(sp)
    80000a2a:	7442                	ld	s0,48(sp)
    80000a2c:	74a2                	ld	s1,40(sp)
    80000a2e:	7902                	ld	s2,32(sp)
    80000a30:	69e2                	ld	s3,24(sp)
    80000a32:	6a42                	ld	s4,16(sp)
    80000a34:	6aa2                	ld	s5,8(sp)
    80000a36:	6b02                	ld	s6,0(sp)
    80000a38:	6121                	addi	sp,sp,64
    80000a3a:	8082                	ret
      kfree(mem);
    80000a3c:	8526                	mv	a0,s1
    80000a3e:	fffff097          	auipc	ra,0xfffff
    80000a42:	5de080e7          	jalr	1502(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a46:	864e                	mv	a2,s3
    80000a48:	85ca                	mv	a1,s2
    80000a4a:	8556                	mv	a0,s5
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	f1a080e7          	jalr	-230(ra) # 80000966 <uvmdealloc>
      return 0;
    80000a54:	4501                	li	a0,0
    80000a56:	bfc9                	j	80000a28 <uvmalloc+0x7a>
    return oldsz;
    80000a58:	852e                	mv	a0,a1
}
    80000a5a:	8082                	ret
  return newsz;
    80000a5c:	8532                	mv	a0,a2
    80000a5e:	b7e9                	j	80000a28 <uvmalloc+0x7a>

0000000080000a60 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	e84a                	sd	s2,16(sp)
    80000a6a:	e44e                	sd	s3,8(sp)
    80000a6c:	e052                	sd	s4,0(sp)
    80000a6e:	1800                	addi	s0,sp,48
    80000a70:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a72:	84aa                	mv	s1,a0
    80000a74:	6905                	lui	s2,0x1
    80000a76:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a78:	4985                	li	s3,1
    80000a7a:	a829                	j	80000a94 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a7c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a7e:	00c79513          	slli	a0,a5,0xc
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	fde080e7          	jalr	-34(ra) # 80000a60 <freewalk>
      pagetable[i] = 0;
    80000a8a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a8e:	04a1                	addi	s1,s1,8
    80000a90:	03248163          	beq	s1,s2,80000ab2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a94:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a96:	00f7f713          	andi	a4,a5,15
    80000a9a:	ff3701e3          	beq	a4,s3,80000a7c <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a9e:	8b85                	andi	a5,a5,1
    80000aa0:	d7fd                	beqz	a5,80000a8e <freewalk+0x2e>
      panic("freewalk: leaf");
    80000aa2:	00007517          	auipc	a0,0x7
    80000aa6:	65650513          	addi	a0,a0,1622 # 800080f8 <etext+0xf8>
    80000aaa:	00005097          	auipc	ra,0x5
    80000aae:	6b8080e7          	jalr	1720(ra) # 80006162 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ab2:	8552                	mv	a0,s4
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	568080e7          	jalr	1384(ra) # 8000001c <kfree>
}
    80000abc:	70a2                	ld	ra,40(sp)
    80000abe:	7402                	ld	s0,32(sp)
    80000ac0:	64e2                	ld	s1,24(sp)
    80000ac2:	6942                	ld	s2,16(sp)
    80000ac4:	69a2                	ld	s3,8(sp)
    80000ac6:	6a02                	ld	s4,0(sp)
    80000ac8:	6145                	addi	sp,sp,48
    80000aca:	8082                	ret

0000000080000acc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000acc:	1101                	addi	sp,sp,-32
    80000ace:	ec06                	sd	ra,24(sp)
    80000ad0:	e822                	sd	s0,16(sp)
    80000ad2:	e426                	sd	s1,8(sp)
    80000ad4:	1000                	addi	s0,sp,32
    80000ad6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ad8:	e999                	bnez	a1,80000aee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ada:	8526                	mv	a0,s1
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	f84080e7          	jalr	-124(ra) # 80000a60 <freewalk>
}
    80000ae4:	60e2                	ld	ra,24(sp)
    80000ae6:	6442                	ld	s0,16(sp)
    80000ae8:	64a2                	ld	s1,8(sp)
    80000aea:	6105                	addi	sp,sp,32
    80000aec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aee:	6785                	lui	a5,0x1
    80000af0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000af2:	95be                	add	a1,a1,a5
    80000af4:	4685                	li	a3,1
    80000af6:	00c5d613          	srli	a2,a1,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	d06080e7          	jalr	-762(ra) # 80000802 <uvmunmap>
    80000b04:	bfd9                	j	80000ada <uvmfree+0xe>

0000000080000b06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b06:	c679                	beqz	a2,80000bd4 <uvmcopy+0xce>
{
    80000b08:	715d                	addi	sp,sp,-80
    80000b0a:	e486                	sd	ra,72(sp)
    80000b0c:	e0a2                	sd	s0,64(sp)
    80000b0e:	fc26                	sd	s1,56(sp)
    80000b10:	f84a                	sd	s2,48(sp)
    80000b12:	f44e                	sd	s3,40(sp)
    80000b14:	f052                	sd	s4,32(sp)
    80000b16:	ec56                	sd	s5,24(sp)
    80000b18:	e85a                	sd	s6,16(sp)
    80000b1a:	e45e                	sd	s7,8(sp)
    80000b1c:	0880                	addi	s0,sp,80
    80000b1e:	8b2a                	mv	s6,a0
    80000b20:	8aae                	mv	s5,a1
    80000b22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b26:	4601                	li	a2,0
    80000b28:	85ce                	mv	a1,s3
    80000b2a:	855a                	mv	a0,s6
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	a28080e7          	jalr	-1496(ra) # 80000554 <walk>
    80000b34:	c531                	beqz	a0,80000b80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b36:	6118                	ld	a4,0(a0)
    80000b38:	00177793          	andi	a5,a4,1
    80000b3c:	cbb1                	beqz	a5,80000b90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b3e:	00a75593          	srli	a1,a4,0xa
    80000b42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	620080e7          	jalr	1568(ra) # 8000016a <kalloc>
    80000b52:	892a                	mv	s2,a0
    80000b54:	c939                	beqz	a0,80000baa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b56:	6605                	lui	a2,0x1
    80000b58:	85de                	mv	a1,s7
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	764080e7          	jalr	1892(ra) # 800002be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b62:	8726                	mv	a4,s1
    80000b64:	86ca                	mv	a3,s2
    80000b66:	6605                	lui	a2,0x1
    80000b68:	85ce                	mv	a1,s3
    80000b6a:	8556                	mv	a0,s5
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	ad0080e7          	jalr	-1328(ra) # 8000063c <mappages>
    80000b74:	e515                	bnez	a0,80000ba0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b76:	6785                	lui	a5,0x1
    80000b78:	99be                	add	s3,s3,a5
    80000b7a:	fb49e6e3          	bltu	s3,s4,80000b26 <uvmcopy+0x20>
    80000b7e:	a081                	j	80000bbe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b80:	00007517          	auipc	a0,0x7
    80000b84:	58850513          	addi	a0,a0,1416 # 80008108 <etext+0x108>
    80000b88:	00005097          	auipc	ra,0x5
    80000b8c:	5da080e7          	jalr	1498(ra) # 80006162 <panic>
      panic("uvmcopy: page not present");
    80000b90:	00007517          	auipc	a0,0x7
    80000b94:	59850513          	addi	a0,a0,1432 # 80008128 <etext+0x128>
    80000b98:	00005097          	auipc	ra,0x5
    80000b9c:	5ca080e7          	jalr	1482(ra) # 80006162 <panic>
      kfree(mem);
    80000ba0:	854a                	mv	a0,s2
    80000ba2:	fffff097          	auipc	ra,0xfffff
    80000ba6:	47a080e7          	jalr	1146(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000baa:	4685                	li	a3,1
    80000bac:	00c9d613          	srli	a2,s3,0xc
    80000bb0:	4581                	li	a1,0
    80000bb2:	8556                	mv	a0,s5
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	c4e080e7          	jalr	-946(ra) # 80000802 <uvmunmap>
  return -1;
    80000bbc:	557d                	li	a0,-1
}
    80000bbe:	60a6                	ld	ra,72(sp)
    80000bc0:	6406                	ld	s0,64(sp)
    80000bc2:	74e2                	ld	s1,56(sp)
    80000bc4:	7942                	ld	s2,48(sp)
    80000bc6:	79a2                	ld	s3,40(sp)
    80000bc8:	7a02                	ld	s4,32(sp)
    80000bca:	6ae2                	ld	s5,24(sp)
    80000bcc:	6b42                	ld	s6,16(sp)
    80000bce:	6ba2                	ld	s7,8(sp)
    80000bd0:	6161                	addi	sp,sp,80
    80000bd2:	8082                	ret
  return 0;
    80000bd4:	4501                	li	a0,0
}
    80000bd6:	8082                	ret

0000000080000bd8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bd8:	1141                	addi	sp,sp,-16
    80000bda:	e406                	sd	ra,8(sp)
    80000bdc:	e022                	sd	s0,0(sp)
    80000bde:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000be0:	4601                	li	a2,0
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	972080e7          	jalr	-1678(ra) # 80000554 <walk>
  if(pte == 0)
    80000bea:	c901                	beqz	a0,80000bfa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bec:	611c                	ld	a5,0(a0)
    80000bee:	9bbd                	andi	a5,a5,-17
    80000bf0:	e11c                	sd	a5,0(a0)
}
    80000bf2:	60a2                	ld	ra,8(sp)
    80000bf4:	6402                	ld	s0,0(sp)
    80000bf6:	0141                	addi	sp,sp,16
    80000bf8:	8082                	ret
    panic("uvmclear");
    80000bfa:	00007517          	auipc	a0,0x7
    80000bfe:	54e50513          	addi	a0,a0,1358 # 80008148 <etext+0x148>
    80000c02:	00005097          	auipc	ra,0x5
    80000c06:	560080e7          	jalr	1376(ra) # 80006162 <panic>

0000000080000c0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c0a:	c6bd                	beqz	a3,80000c78 <copyout+0x6e>
{
    80000c0c:	715d                	addi	sp,sp,-80
    80000c0e:	e486                	sd	ra,72(sp)
    80000c10:	e0a2                	sd	s0,64(sp)
    80000c12:	fc26                	sd	s1,56(sp)
    80000c14:	f84a                	sd	s2,48(sp)
    80000c16:	f44e                	sd	s3,40(sp)
    80000c18:	f052                	sd	s4,32(sp)
    80000c1a:	ec56                	sd	s5,24(sp)
    80000c1c:	e85a                	sd	s6,16(sp)
    80000c1e:	e45e                	sd	s7,8(sp)
    80000c20:	e062                	sd	s8,0(sp)
    80000c22:	0880                	addi	s0,sp,80
    80000c24:	8b2a                	mv	s6,a0
    80000c26:	8c2e                	mv	s8,a1
    80000c28:	8a32                	mv	s4,a2
    80000c2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c2e:	6a85                	lui	s5,0x1
    80000c30:	a015                	j	80000c54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c32:	9562                	add	a0,a0,s8
    80000c34:	0004861b          	sext.w	a2,s1
    80000c38:	85d2                	mv	a1,s4
    80000c3a:	41250533          	sub	a0,a0,s2
    80000c3e:	fffff097          	auipc	ra,0xfffff
    80000c42:	680080e7          	jalr	1664(ra) # 800002be <memmove>

    len -= n;
    80000c46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c50:	02098263          	beqz	s3,80000c74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c58:	85ca                	mv	a1,s2
    80000c5a:	855a                	mv	a0,s6
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	99e080e7          	jalr	-1634(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000c64:	cd01                	beqz	a0,80000c7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c66:	418904b3          	sub	s1,s2,s8
    80000c6a:	94d6                	add	s1,s1,s5
    80000c6c:	fc99f3e3          	bgeu	s3,s1,80000c32 <copyout+0x28>
    80000c70:	84ce                	mv	s1,s3
    80000c72:	b7c1                	j	80000c32 <copyout+0x28>
  }
  return 0;
    80000c74:	4501                	li	a0,0
    80000c76:	a021                	j	80000c7e <copyout+0x74>
    80000c78:	4501                	li	a0,0
}
    80000c7a:	8082                	ret
      return -1;
    80000c7c:	557d                	li	a0,-1
}
    80000c7e:	60a6                	ld	ra,72(sp)
    80000c80:	6406                	ld	s0,64(sp)
    80000c82:	74e2                	ld	s1,56(sp)
    80000c84:	7942                	ld	s2,48(sp)
    80000c86:	79a2                	ld	s3,40(sp)
    80000c88:	7a02                	ld	s4,32(sp)
    80000c8a:	6ae2                	ld	s5,24(sp)
    80000c8c:	6b42                	ld	s6,16(sp)
    80000c8e:	6ba2                	ld	s7,8(sp)
    80000c90:	6c02                	ld	s8,0(sp)
    80000c92:	6161                	addi	sp,sp,80
    80000c94:	8082                	ret

0000000080000c96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c96:	caa5                	beqz	a3,80000d06 <copyin+0x70>
{
    80000c98:	715d                	addi	sp,sp,-80
    80000c9a:	e486                	sd	ra,72(sp)
    80000c9c:	e0a2                	sd	s0,64(sp)
    80000c9e:	fc26                	sd	s1,56(sp)
    80000ca0:	f84a                	sd	s2,48(sp)
    80000ca2:	f44e                	sd	s3,40(sp)
    80000ca4:	f052                	sd	s4,32(sp)
    80000ca6:	ec56                	sd	s5,24(sp)
    80000ca8:	e85a                	sd	s6,16(sp)
    80000caa:	e45e                	sd	s7,8(sp)
    80000cac:	e062                	sd	s8,0(sp)
    80000cae:	0880                	addi	s0,sp,80
    80000cb0:	8b2a                	mv	s6,a0
    80000cb2:	8a2e                	mv	s4,a1
    80000cb4:	8c32                	mv	s8,a2
    80000cb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cba:	6a85                	lui	s5,0x1
    80000cbc:	a01d                	j	80000ce2 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cbe:	018505b3          	add	a1,a0,s8
    80000cc2:	0004861b          	sext.w	a2,s1
    80000cc6:	412585b3          	sub	a1,a1,s2
    80000cca:	8552                	mv	a0,s4
    80000ccc:	fffff097          	auipc	ra,0xfffff
    80000cd0:	5f2080e7          	jalr	1522(ra) # 800002be <memmove>

    len -= n;
    80000cd4:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cd8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cda:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cde:	02098263          	beqz	s3,80000d02 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000ce2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ce6:	85ca                	mv	a1,s2
    80000ce8:	855a                	mv	a0,s6
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	910080e7          	jalr	-1776(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000cf2:	cd01                	beqz	a0,80000d0a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cf4:	418904b3          	sub	s1,s2,s8
    80000cf8:	94d6                	add	s1,s1,s5
    80000cfa:	fc99f2e3          	bgeu	s3,s1,80000cbe <copyin+0x28>
    80000cfe:	84ce                	mv	s1,s3
    80000d00:	bf7d                	j	80000cbe <copyin+0x28>
  }
  return 0;
    80000d02:	4501                	li	a0,0
    80000d04:	a021                	j	80000d0c <copyin+0x76>
    80000d06:	4501                	li	a0,0
}
    80000d08:	8082                	ret
      return -1;
    80000d0a:	557d                	li	a0,-1
}
    80000d0c:	60a6                	ld	ra,72(sp)
    80000d0e:	6406                	ld	s0,64(sp)
    80000d10:	74e2                	ld	s1,56(sp)
    80000d12:	7942                	ld	s2,48(sp)
    80000d14:	79a2                	ld	s3,40(sp)
    80000d16:	7a02                	ld	s4,32(sp)
    80000d18:	6ae2                	ld	s5,24(sp)
    80000d1a:	6b42                	ld	s6,16(sp)
    80000d1c:	6ba2                	ld	s7,8(sp)
    80000d1e:	6c02                	ld	s8,0(sp)
    80000d20:	6161                	addi	sp,sp,80
    80000d22:	8082                	ret

0000000080000d24 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d24:	c2dd                	beqz	a3,80000dca <copyinstr+0xa6>
{
    80000d26:	715d                	addi	sp,sp,-80
    80000d28:	e486                	sd	ra,72(sp)
    80000d2a:	e0a2                	sd	s0,64(sp)
    80000d2c:	fc26                	sd	s1,56(sp)
    80000d2e:	f84a                	sd	s2,48(sp)
    80000d30:	f44e                	sd	s3,40(sp)
    80000d32:	f052                	sd	s4,32(sp)
    80000d34:	ec56                	sd	s5,24(sp)
    80000d36:	e85a                	sd	s6,16(sp)
    80000d38:	e45e                	sd	s7,8(sp)
    80000d3a:	0880                	addi	s0,sp,80
    80000d3c:	8a2a                	mv	s4,a0
    80000d3e:	8b2e                	mv	s6,a1
    80000d40:	8bb2                	mv	s7,a2
    80000d42:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d44:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d46:	6985                	lui	s3,0x1
    80000d48:	a02d                	j	80000d72 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d4a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d4e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d50:	37fd                	addiw	a5,a5,-1
    80000d52:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d56:	60a6                	ld	ra,72(sp)
    80000d58:	6406                	ld	s0,64(sp)
    80000d5a:	74e2                	ld	s1,56(sp)
    80000d5c:	7942                	ld	s2,48(sp)
    80000d5e:	79a2                	ld	s3,40(sp)
    80000d60:	7a02                	ld	s4,32(sp)
    80000d62:	6ae2                	ld	s5,24(sp)
    80000d64:	6b42                	ld	s6,16(sp)
    80000d66:	6ba2                	ld	s7,8(sp)
    80000d68:	6161                	addi	sp,sp,80
    80000d6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d70:	c8a9                	beqz	s1,80000dc2 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d76:	85ca                	mv	a1,s2
    80000d78:	8552                	mv	a0,s4
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	880080e7          	jalr	-1920(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000d82:	c131                	beqz	a0,80000dc6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d84:	417906b3          	sub	a3,s2,s7
    80000d88:	96ce                	add	a3,a3,s3
    80000d8a:	00d4f363          	bgeu	s1,a3,80000d90 <copyinstr+0x6c>
    80000d8e:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d90:	955e                	add	a0,a0,s7
    80000d92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d96:	daf9                	beqz	a3,80000d6c <copyinstr+0x48>
    80000d98:	87da                	mv	a5,s6
    80000d9a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d9c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000da0:	96da                	add	a3,a3,s6
    80000da2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000da4:	00f60733          	add	a4,a2,a5
    80000da8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd7498>
    80000dac:	df59                	beqz	a4,80000d4a <copyinstr+0x26>
        *dst = *p;
    80000dae:	00e78023          	sb	a4,0(a5)
      dst++;
    80000db2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000db4:	fed797e3          	bne	a5,a3,80000da2 <copyinstr+0x7e>
    80000db8:	14fd                	addi	s1,s1,-1
    80000dba:	94c2                	add	s1,s1,a6
      --max;
    80000dbc:	8c8d                	sub	s1,s1,a1
      dst++;
    80000dbe:	8b3e                	mv	s6,a5
    80000dc0:	b775                	j	80000d6c <copyinstr+0x48>
    80000dc2:	4781                	li	a5,0
    80000dc4:	b771                	j	80000d50 <copyinstr+0x2c>
      return -1;
    80000dc6:	557d                	li	a0,-1
    80000dc8:	b779                	j	80000d56 <copyinstr+0x32>
  int got_null = 0;
    80000dca:	4781                	li	a5,0
  if(got_null){
    80000dcc:	37fd                	addiw	a5,a5,-1
    80000dce:	0007851b          	sext.w	a0,a5
}
    80000dd2:	8082                	ret

0000000080000dd4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dd4:	7139                	addi	sp,sp,-64
    80000dd6:	fc06                	sd	ra,56(sp)
    80000dd8:	f822                	sd	s0,48(sp)
    80000dda:	f426                	sd	s1,40(sp)
    80000ddc:	f04a                	sd	s2,32(sp)
    80000dde:	ec4e                	sd	s3,24(sp)
    80000de0:	e852                	sd	s4,16(sp)
    80000de2:	e456                	sd	s5,8(sp)
    80000de4:	e05a                	sd	s6,0(sp)
    80000de6:	0080                	addi	s0,sp,64
    80000de8:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dea:	00008497          	auipc	s1,0x8
    80000dee:	12648493          	addi	s1,s1,294 # 80008f10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df2:	8b26                	mv	s6,s1
    80000df4:	00007a97          	auipc	s5,0x7
    80000df8:	20ca8a93          	addi	s5,s5,524 # 80008000 <etext>
    80000dfc:	04000937          	lui	s2,0x4000
    80000e00:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e02:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e04:	0000ea17          	auipc	s4,0xe
    80000e08:	d0ca0a13          	addi	s4,s4,-756 # 8000eb10 <tickslock>
    char *pa = kalloc();
    80000e0c:	fffff097          	auipc	ra,0xfffff
    80000e10:	35e080e7          	jalr	862(ra) # 8000016a <kalloc>
    80000e14:	862a                	mv	a2,a0
    if(pa == 0)
    80000e16:	c131                	beqz	a0,80000e5a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e18:	416485b3          	sub	a1,s1,s6
    80000e1c:	8591                	srai	a1,a1,0x4
    80000e1e:	000ab783          	ld	a5,0(s5)
    80000e22:	02f585b3          	mul	a1,a1,a5
    80000e26:	2585                	addiw	a1,a1,1
    80000e28:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e2c:	4719                	li	a4,6
    80000e2e:	6685                	lui	a3,0x1
    80000e30:	40b905b3          	sub	a1,s2,a1
    80000e34:	854e                	mv	a0,s3
    80000e36:	00000097          	auipc	ra,0x0
    80000e3a:	8a6080e7          	jalr	-1882(ra) # 800006dc <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	17048493          	addi	s1,s1,368
    80000e42:	fd4495e3          	bne	s1,s4,80000e0c <proc_mapstacks+0x38>
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
    80000e5e:	2fe50513          	addi	a0,a0,766 # 80008158 <etext+0x158>
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	300080e7          	jalr	768(ra) # 80006162 <panic>

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
    80000e82:	2e258593          	addi	a1,a1,738 # 80008160 <etext+0x160>
    80000e86:	00008517          	auipc	a0,0x8
    80000e8a:	c4a50513          	addi	a0,a0,-950 # 80008ad0 <pid_lock>
    80000e8e:	00006097          	auipc	ra,0x6
    80000e92:	972080e7          	jalr	-1678(ra) # 80006800 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e96:	00007597          	auipc	a1,0x7
    80000e9a:	2d258593          	addi	a1,a1,722 # 80008168 <etext+0x168>
    80000e9e:	00008517          	auipc	a0,0x8
    80000ea2:	c5250513          	addi	a0,a0,-942 # 80008af0 <wait_lock>
    80000ea6:	00006097          	auipc	ra,0x6
    80000eaa:	95a080e7          	jalr	-1702(ra) # 80006800 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eae:	00008497          	auipc	s1,0x8
    80000eb2:	06248493          	addi	s1,s1,98 # 80008f10 <proc>
      initlock(&p->lock, "proc");
    80000eb6:	00007b17          	auipc	s6,0x7
    80000eba:	2c2b0b13          	addi	s6,s6,706 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ebe:	8aa6                	mv	s5,s1
    80000ec0:	00007a17          	auipc	s4,0x7
    80000ec4:	140a0a13          	addi	s4,s4,320 # 80008000 <etext>
    80000ec8:	04000937          	lui	s2,0x4000
    80000ecc:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ece:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed0:	0000e997          	auipc	s3,0xe
    80000ed4:	c4098993          	addi	s3,s3,-960 # 8000eb10 <tickslock>
      initlock(&p->lock, "proc");
    80000ed8:	85da                	mv	a1,s6
    80000eda:	8526                	mv	a0,s1
    80000edc:	00006097          	auipc	ra,0x6
    80000ee0:	924080e7          	jalr	-1756(ra) # 80006800 <initlock>
      p->state = UNUSED;
    80000ee4:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ee8:	415487b3          	sub	a5,s1,s5
    80000eec:	8791                	srai	a5,a5,0x4
    80000eee:	000a3703          	ld	a4,0(s4)
    80000ef2:	02e787b3          	mul	a5,a5,a4
    80000ef6:	2785                	addiw	a5,a5,1
    80000ef8:	00d7979b          	slliw	a5,a5,0xd
    80000efc:	40f907b3          	sub	a5,s2,a5
    80000f00:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f02:	17048493          	addi	s1,s1,368
    80000f06:	fd3499e3          	bne	s1,s3,80000ed8 <procinit+0x6e>
  }
}
    80000f0a:	70e2                	ld	ra,56(sp)
    80000f0c:	7442                	ld	s0,48(sp)
    80000f0e:	74a2                	ld	s1,40(sp)
    80000f10:	7902                	ld	s2,32(sp)
    80000f12:	69e2                	ld	s3,24(sp)
    80000f14:	6a42                	ld	s4,16(sp)
    80000f16:	6aa2                	ld	s5,8(sp)
    80000f18:	6b02                	ld	s6,0(sp)
    80000f1a:	6121                	addi	sp,sp,64
    80000f1c:	8082                	ret

0000000080000f1e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f1e:	1141                	addi	sp,sp,-16
    80000f20:	e422                	sd	s0,8(sp)
    80000f22:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f24:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f26:	2501                	sext.w	a0,a0
    80000f28:	6422                	ld	s0,8(sp)
    80000f2a:	0141                	addi	sp,sp,16
    80000f2c:	8082                	ret

0000000080000f2e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f2e:	1141                	addi	sp,sp,-16
    80000f30:	e422                	sd	s0,8(sp)
    80000f32:	0800                	addi	s0,sp,16
    80000f34:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f36:	2781                	sext.w	a5,a5
    80000f38:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f3a:	00008517          	auipc	a0,0x8
    80000f3e:	bd650513          	addi	a0,a0,-1066 # 80008b10 <cpus>
    80000f42:	953e                	add	a0,a0,a5
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f4a:	1101                	addi	sp,sp,-32
    80000f4c:	ec06                	sd	ra,24(sp)
    80000f4e:	e822                	sd	s0,16(sp)
    80000f50:	e426                	sd	s1,8(sp)
    80000f52:	1000                	addi	s0,sp,32
  push_off();
    80000f54:	00005097          	auipc	ra,0x5
    80000f58:	6e4080e7          	jalr	1764(ra) # 80006638 <push_off>
    80000f5c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f5e:	2781                	sext.w	a5,a5
    80000f60:	079e                	slli	a5,a5,0x7
    80000f62:	00008717          	auipc	a4,0x8
    80000f66:	b6e70713          	addi	a4,a4,-1170 # 80008ad0 <pid_lock>
    80000f6a:	97ba                	add	a5,a5,a4
    80000f6c:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	786080e7          	jalr	1926(ra) # 800066f4 <pop_off>
  return p;
}
    80000f76:	8526                	mv	a0,s1
    80000f78:	60e2                	ld	ra,24(sp)
    80000f7a:	6442                	ld	s0,16(sp)
    80000f7c:	64a2                	ld	s1,8(sp)
    80000f7e:	6105                	addi	sp,sp,32
    80000f80:	8082                	ret

0000000080000f82 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e406                	sd	ra,8(sp)
    80000f86:	e022                	sd	s0,0(sp)
    80000f88:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f8a:	00000097          	auipc	ra,0x0
    80000f8e:	fc0080e7          	jalr	-64(ra) # 80000f4a <myproc>
    80000f92:	00005097          	auipc	ra,0x5
    80000f96:	7c2080e7          	jalr	1986(ra) # 80006754 <release>

  if (first) {
    80000f9a:	00008797          	auipc	a5,0x8
    80000f9e:	9567a783          	lw	a5,-1706(a5) # 800088f0 <first.1>
    80000fa2:	eb89                	bnez	a5,80000fb4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fa4:	00001097          	auipc	ra,0x1
    80000fa8:	c5c080e7          	jalr	-932(ra) # 80001c00 <usertrapret>
}
    80000fac:	60a2                	ld	ra,8(sp)
    80000fae:	6402                	ld	s0,0(sp)
    80000fb0:	0141                	addi	sp,sp,16
    80000fb2:	8082                	ret
    first = 0;
    80000fb4:	00008797          	auipc	a5,0x8
    80000fb8:	9207ae23          	sw	zero,-1732(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    80000fbc:	4505                	li	a0,1
    80000fbe:	00002097          	auipc	ra,0x2
    80000fc2:	b78080e7          	jalr	-1160(ra) # 80002b36 <fsinit>
    80000fc6:	bff9                	j	80000fa4 <forkret+0x22>

0000000080000fc8 <allocpid>:
{
    80000fc8:	1101                	addi	sp,sp,-32
    80000fca:	ec06                	sd	ra,24(sp)
    80000fcc:	e822                	sd	s0,16(sp)
    80000fce:	e426                	sd	s1,8(sp)
    80000fd0:	e04a                	sd	s2,0(sp)
    80000fd2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fd4:	00008917          	auipc	s2,0x8
    80000fd8:	afc90913          	addi	s2,s2,-1284 # 80008ad0 <pid_lock>
    80000fdc:	854a                	mv	a0,s2
    80000fde:	00005097          	auipc	ra,0x5
    80000fe2:	6a6080e7          	jalr	1702(ra) # 80006684 <acquire>
  pid = nextpid;
    80000fe6:	00008797          	auipc	a5,0x8
    80000fea:	90e78793          	addi	a5,a5,-1778 # 800088f4 <nextpid>
    80000fee:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ff0:	0014871b          	addiw	a4,s1,1
    80000ff4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ff6:	854a                	mv	a0,s2
    80000ff8:	00005097          	auipc	ra,0x5
    80000ffc:	75c080e7          	jalr	1884(ra) # 80006754 <release>
}
    80001000:	8526                	mv	a0,s1
    80001002:	60e2                	ld	ra,24(sp)
    80001004:	6442                	ld	s0,16(sp)
    80001006:	64a2                	ld	s1,8(sp)
    80001008:	6902                	ld	s2,0(sp)
    8000100a:	6105                	addi	sp,sp,32
    8000100c:	8082                	ret

000000008000100e <proc_pagetable>:
{
    8000100e:	1101                	addi	sp,sp,-32
    80001010:	ec06                	sd	ra,24(sp)
    80001012:	e822                	sd	s0,16(sp)
    80001014:	e426                	sd	s1,8(sp)
    80001016:	e04a                	sd	s2,0(sp)
    80001018:	1000                	addi	s0,sp,32
    8000101a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	8aa080e7          	jalr	-1878(ra) # 800008c6 <uvmcreate>
    80001024:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001026:	c121                	beqz	a0,80001066 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001028:	4729                	li	a4,10
    8000102a:	00006697          	auipc	a3,0x6
    8000102e:	fd668693          	addi	a3,a3,-42 # 80007000 <_trampoline>
    80001032:	6605                	lui	a2,0x1
    80001034:	040005b7          	lui	a1,0x4000
    80001038:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000103a:	05b2                	slli	a1,a1,0xc
    8000103c:	fffff097          	auipc	ra,0xfffff
    80001040:	600080e7          	jalr	1536(ra) # 8000063c <mappages>
    80001044:	02054863          	bltz	a0,80001074 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001048:	4719                	li	a4,6
    8000104a:	06093683          	ld	a3,96(s2)
    8000104e:	6605                	lui	a2,0x1
    80001050:	020005b7          	lui	a1,0x2000
    80001054:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001056:	05b6                	slli	a1,a1,0xd
    80001058:	8526                	mv	a0,s1
    8000105a:	fffff097          	auipc	ra,0xfffff
    8000105e:	5e2080e7          	jalr	1506(ra) # 8000063c <mappages>
    80001062:	02054163          	bltz	a0,80001084 <proc_pagetable+0x76>
}
    80001066:	8526                	mv	a0,s1
    80001068:	60e2                	ld	ra,24(sp)
    8000106a:	6442                	ld	s0,16(sp)
    8000106c:	64a2                	ld	s1,8(sp)
    8000106e:	6902                	ld	s2,0(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret
    uvmfree(pagetable, 0);
    80001074:	4581                	li	a1,0
    80001076:	8526                	mv	a0,s1
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	a54080e7          	jalr	-1452(ra) # 80000acc <uvmfree>
    return 0;
    80001080:	4481                	li	s1,0
    80001082:	b7d5                	j	80001066 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001084:	4681                	li	a3,0
    80001086:	4605                	li	a2,1
    80001088:	040005b7          	lui	a1,0x4000
    8000108c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000108e:	05b2                	slli	a1,a1,0xc
    80001090:	8526                	mv	a0,s1
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	770080e7          	jalr	1904(ra) # 80000802 <uvmunmap>
    uvmfree(pagetable, 0);
    8000109a:	4581                	li	a1,0
    8000109c:	8526                	mv	a0,s1
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	a2e080e7          	jalr	-1490(ra) # 80000acc <uvmfree>
    return 0;
    800010a6:	4481                	li	s1,0
    800010a8:	bf7d                	j	80001066 <proc_pagetable+0x58>

00000000800010aa <proc_freepagetable>:
{
    800010aa:	1101                	addi	sp,sp,-32
    800010ac:	ec06                	sd	ra,24(sp)
    800010ae:	e822                	sd	s0,16(sp)
    800010b0:	e426                	sd	s1,8(sp)
    800010b2:	e04a                	sd	s2,0(sp)
    800010b4:	1000                	addi	s0,sp,32
    800010b6:	84aa                	mv	s1,a0
    800010b8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ba:	4681                	li	a3,0
    800010bc:	4605                	li	a2,1
    800010be:	040005b7          	lui	a1,0x4000
    800010c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c4:	05b2                	slli	a1,a1,0xc
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	73c080e7          	jalr	1852(ra) # 80000802 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010ce:	4681                	li	a3,0
    800010d0:	4605                	li	a2,1
    800010d2:	020005b7          	lui	a1,0x2000
    800010d6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010d8:	05b6                	slli	a1,a1,0xd
    800010da:	8526                	mv	a0,s1
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	726080e7          	jalr	1830(ra) # 80000802 <uvmunmap>
  uvmfree(pagetable, sz);
    800010e4:	85ca                	mv	a1,s2
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	9e4080e7          	jalr	-1564(ra) # 80000acc <uvmfree>
}
    800010f0:	60e2                	ld	ra,24(sp)
    800010f2:	6442                	ld	s0,16(sp)
    800010f4:	64a2                	ld	s1,8(sp)
    800010f6:	6902                	ld	s2,0(sp)
    800010f8:	6105                	addi	sp,sp,32
    800010fa:	8082                	ret

00000000800010fc <freeproc>:
{
    800010fc:	1101                	addi	sp,sp,-32
    800010fe:	ec06                	sd	ra,24(sp)
    80001100:	e822                	sd	s0,16(sp)
    80001102:	e426                	sd	s1,8(sp)
    80001104:	1000                	addi	s0,sp,32
    80001106:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001108:	7128                	ld	a0,96(a0)
    8000110a:	c509                	beqz	a0,80001114 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000110c:	fffff097          	auipc	ra,0xfffff
    80001110:	f10080e7          	jalr	-240(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001114:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001118:	6ca8                	ld	a0,88(s1)
    8000111a:	c511                	beqz	a0,80001126 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000111c:	68ac                	ld	a1,80(s1)
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	f8c080e7          	jalr	-116(ra) # 800010aa <proc_freepagetable>
  p->pagetable = 0;
    80001126:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000112a:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000112e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001132:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001136:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    8000113a:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000113e:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001142:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001146:	0204a023          	sw	zero,32(s1)
}
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6105                	addi	sp,sp,32
    80001152:	8082                	ret

0000000080001154 <allocproc>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	e04a                	sd	s2,0(sp)
    8000115e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001160:	00008497          	auipc	s1,0x8
    80001164:	db048493          	addi	s1,s1,-592 # 80008f10 <proc>
    80001168:	0000e917          	auipc	s2,0xe
    8000116c:	9a890913          	addi	s2,s2,-1624 # 8000eb10 <tickslock>
    acquire(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	512080e7          	jalr	1298(ra) # 80006684 <acquire>
    if(p->state == UNUSED) {
    8000117a:	509c                	lw	a5,32(s1)
    8000117c:	cf81                	beqz	a5,80001194 <allocproc+0x40>
      release(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	5d4080e7          	jalr	1492(ra) # 80006754 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001188:	17048493          	addi	s1,s1,368
    8000118c:	ff2492e3          	bne	s1,s2,80001170 <allocproc+0x1c>
  return 0;
    80001190:	4481                	li	s1,0
    80001192:	a889                	j	800011e4 <allocproc+0x90>
  p->pid = allocpid();
    80001194:	00000097          	auipc	ra,0x0
    80001198:	e34080e7          	jalr	-460(ra) # 80000fc8 <allocpid>
    8000119c:	dc88                	sw	a0,56(s1)
  p->state = USED;
    8000119e:	4785                	li	a5,1
    800011a0:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	fc8080e7          	jalr	-56(ra) # 8000016a <kalloc>
    800011aa:	892a                	mv	s2,a0
    800011ac:	f0a8                	sd	a0,96(s1)
    800011ae:	c131                	beqz	a0,800011f2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	e5c080e7          	jalr	-420(ra) # 8000100e <proc_pagetable>
    800011ba:	892a                	mv	s2,a0
    800011bc:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011be:	c531                	beqz	a0,8000120a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011c0:	07000613          	li	a2,112
    800011c4:	4581                	li	a1,0
    800011c6:	06848513          	addi	a0,s1,104
    800011ca:	fffff097          	auipc	ra,0xfffff
    800011ce:	098080e7          	jalr	152(ra) # 80000262 <memset>
  p->context.ra = (uint64)forkret;
    800011d2:	00000797          	auipc	a5,0x0
    800011d6:	db078793          	addi	a5,a5,-592 # 80000f82 <forkret>
    800011da:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011dc:	64bc                	ld	a5,72(s1)
    800011de:	6705                	lui	a4,0x1
    800011e0:	97ba                	add	a5,a5,a4
    800011e2:	f8bc                	sd	a5,112(s1)
}
    800011e4:	8526                	mv	a0,s1
    800011e6:	60e2                	ld	ra,24(sp)
    800011e8:	6442                	ld	s0,16(sp)
    800011ea:	64a2                	ld	s1,8(sp)
    800011ec:	6902                	ld	s2,0(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret
    freeproc(p);
    800011f2:	8526                	mv	a0,s1
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	f08080e7          	jalr	-248(ra) # 800010fc <freeproc>
    release(&p->lock);
    800011fc:	8526                	mv	a0,s1
    800011fe:	00005097          	auipc	ra,0x5
    80001202:	556080e7          	jalr	1366(ra) # 80006754 <release>
    return 0;
    80001206:	84ca                	mv	s1,s2
    80001208:	bff1                	j	800011e4 <allocproc+0x90>
    freeproc(p);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	ef0080e7          	jalr	-272(ra) # 800010fc <freeproc>
    release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	53e080e7          	jalr	1342(ra) # 80006754 <release>
    return 0;
    8000121e:	84ca                	mv	s1,s2
    80001220:	b7d1                	j	800011e4 <allocproc+0x90>

0000000080001222 <userinit>:
{
    80001222:	1101                	addi	sp,sp,-32
    80001224:	ec06                	sd	ra,24(sp)
    80001226:	e822                	sd	s0,16(sp)
    80001228:	e426                	sd	s1,8(sp)
    8000122a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	f28080e7          	jalr	-216(ra) # 80001154 <allocproc>
    80001234:	84aa                	mv	s1,a0
  initproc = p;
    80001236:	00007797          	auipc	a5,0x7
    8000123a:	72a7bd23          	sd	a0,1850(a5) # 80008970 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000123e:	03400613          	li	a2,52
    80001242:	00007597          	auipc	a1,0x7
    80001246:	6be58593          	addi	a1,a1,1726 # 80008900 <initcode>
    8000124a:	6d28                	ld	a0,88(a0)
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	6a8080e7          	jalr	1704(ra) # 800008f4 <uvmfirst>
  p->sz = PGSIZE;
    80001254:	6785                	lui	a5,0x1
    80001256:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001258:	70b8                	ld	a4,96(s1)
    8000125a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000125e:	70b8                	ld	a4,96(s1)
    80001260:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001262:	4641                	li	a2,16
    80001264:	00007597          	auipc	a1,0x7
    80001268:	f1c58593          	addi	a1,a1,-228 # 80008180 <etext+0x180>
    8000126c:	16048513          	addi	a0,s1,352
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	13a080e7          	jalr	314(ra) # 800003aa <safestrcpy>
  p->cwd = namei("/");
    80001278:	00007517          	auipc	a0,0x7
    8000127c:	f1850513          	addi	a0,a0,-232 # 80008190 <etext+0x190>
    80001280:	00002097          	auipc	ra,0x2
    80001284:	2e8080e7          	jalr	744(ra) # 80003568 <namei>
    80001288:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000128c:	478d                	li	a5,3
    8000128e:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00005097          	auipc	ra,0x5
    80001296:	4c2080e7          	jalr	1218(ra) # 80006754 <release>
}
    8000129a:	60e2                	ld	ra,24(sp)
    8000129c:	6442                	ld	s0,16(sp)
    8000129e:	64a2                	ld	s1,8(sp)
    800012a0:	6105                	addi	sp,sp,32
    800012a2:	8082                	ret

00000000800012a4 <growproc>:
{
    800012a4:	1101                	addi	sp,sp,-32
    800012a6:	ec06                	sd	ra,24(sp)
    800012a8:	e822                	sd	s0,16(sp)
    800012aa:	e426                	sd	s1,8(sp)
    800012ac:	e04a                	sd	s2,0(sp)
    800012ae:	1000                	addi	s0,sp,32
    800012b0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	c98080e7          	jalr	-872(ra) # 80000f4a <myproc>
    800012ba:	84aa                	mv	s1,a0
  sz = p->sz;
    800012bc:	692c                	ld	a1,80(a0)
  if(n > 0){
    800012be:	01204c63          	bgtz	s2,800012d6 <growproc+0x32>
  } else if(n < 0){
    800012c2:	02094663          	bltz	s2,800012ee <growproc+0x4a>
  p->sz = sz;
    800012c6:	e8ac                	sd	a1,80(s1)
  return 0;
    800012c8:	4501                	li	a0,0
}
    800012ca:	60e2                	ld	ra,24(sp)
    800012cc:	6442                	ld	s0,16(sp)
    800012ce:	64a2                	ld	s1,8(sp)
    800012d0:	6902                	ld	s2,0(sp)
    800012d2:	6105                	addi	sp,sp,32
    800012d4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012d6:	4691                	li	a3,4
    800012d8:	00b90633          	add	a2,s2,a1
    800012dc:	6d28                	ld	a0,88(a0)
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	6d0080e7          	jalr	1744(ra) # 800009ae <uvmalloc>
    800012e6:	85aa                	mv	a1,a0
    800012e8:	fd79                	bnez	a0,800012c6 <growproc+0x22>
      return -1;
    800012ea:	557d                	li	a0,-1
    800012ec:	bff9                	j	800012ca <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012ee:	00b90633          	add	a2,s2,a1
    800012f2:	6d28                	ld	a0,88(a0)
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	672080e7          	jalr	1650(ra) # 80000966 <uvmdealloc>
    800012fc:	85aa                	mv	a1,a0
    800012fe:	b7e1                	j	800012c6 <growproc+0x22>

0000000080001300 <fork>:
{
    80001300:	7139                	addi	sp,sp,-64
    80001302:	fc06                	sd	ra,56(sp)
    80001304:	f822                	sd	s0,48(sp)
    80001306:	f426                	sd	s1,40(sp)
    80001308:	f04a                	sd	s2,32(sp)
    8000130a:	ec4e                	sd	s3,24(sp)
    8000130c:	e852                	sd	s4,16(sp)
    8000130e:	e456                	sd	s5,8(sp)
    80001310:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001312:	00000097          	auipc	ra,0x0
    80001316:	c38080e7          	jalr	-968(ra) # 80000f4a <myproc>
    8000131a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	e38080e7          	jalr	-456(ra) # 80001154 <allocproc>
    80001324:	10050c63          	beqz	a0,8000143c <fork+0x13c>
    80001328:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000132a:	050ab603          	ld	a2,80(s5)
    8000132e:	6d2c                	ld	a1,88(a0)
    80001330:	058ab503          	ld	a0,88(s5)
    80001334:	fffff097          	auipc	ra,0xfffff
    80001338:	7d2080e7          	jalr	2002(ra) # 80000b06 <uvmcopy>
    8000133c:	04054863          	bltz	a0,8000138c <fork+0x8c>
  np->sz = p->sz;
    80001340:	050ab783          	ld	a5,80(s5)
    80001344:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001348:	060ab683          	ld	a3,96(s5)
    8000134c:	87b6                	mv	a5,a3
    8000134e:	060a3703          	ld	a4,96(s4)
    80001352:	12068693          	addi	a3,a3,288
    80001356:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000135a:	6788                	ld	a0,8(a5)
    8000135c:	6b8c                	ld	a1,16(a5)
    8000135e:	6f90                	ld	a2,24(a5)
    80001360:	01073023          	sd	a6,0(a4)
    80001364:	e708                	sd	a0,8(a4)
    80001366:	eb0c                	sd	a1,16(a4)
    80001368:	ef10                	sd	a2,24(a4)
    8000136a:	02078793          	addi	a5,a5,32
    8000136e:	02070713          	addi	a4,a4,32
    80001372:	fed792e3          	bne	a5,a3,80001356 <fork+0x56>
  np->trapframe->a0 = 0;
    80001376:	060a3783          	ld	a5,96(s4)
    8000137a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000137e:	0d8a8493          	addi	s1,s5,216
    80001382:	0d8a0913          	addi	s2,s4,216
    80001386:	158a8993          	addi	s3,s5,344
    8000138a:	a00d                	j	800013ac <fork+0xac>
    freeproc(np);
    8000138c:	8552                	mv	a0,s4
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	d6e080e7          	jalr	-658(ra) # 800010fc <freeproc>
    release(&np->lock);
    80001396:	8552                	mv	a0,s4
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	3bc080e7          	jalr	956(ra) # 80006754 <release>
    return -1;
    800013a0:	597d                	li	s2,-1
    800013a2:	a059                	j	80001428 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800013a4:	04a1                	addi	s1,s1,8
    800013a6:	0921                	addi	s2,s2,8
    800013a8:	01348b63          	beq	s1,s3,800013be <fork+0xbe>
    if(p->ofile[i])
    800013ac:	6088                	ld	a0,0(s1)
    800013ae:	d97d                	beqz	a0,800013a4 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800013b0:	00003097          	auipc	ra,0x3
    800013b4:	82a080e7          	jalr	-2006(ra) # 80003bda <filedup>
    800013b8:	00a93023          	sd	a0,0(s2)
    800013bc:	b7e5                	j	800013a4 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800013be:	158ab503          	ld	a0,344(s5)
    800013c2:	00002097          	auipc	ra,0x2
    800013c6:	9ae080e7          	jalr	-1618(ra) # 80002d70 <idup>
    800013ca:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013ce:	4641                	li	a2,16
    800013d0:	160a8593          	addi	a1,s5,352
    800013d4:	160a0513          	addi	a0,s4,352
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	fd2080e7          	jalr	-46(ra) # 800003aa <safestrcpy>
  pid = np->pid;
    800013e0:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    800013e4:	8552                	mv	a0,s4
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	36e080e7          	jalr	878(ra) # 80006754 <release>
  acquire(&wait_lock);
    800013ee:	00007497          	auipc	s1,0x7
    800013f2:	70248493          	addi	s1,s1,1794 # 80008af0 <wait_lock>
    800013f6:	8526                	mv	a0,s1
    800013f8:	00005097          	auipc	ra,0x5
    800013fc:	28c080e7          	jalr	652(ra) # 80006684 <acquire>
  np->parent = p;
    80001400:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	34e080e7          	jalr	846(ra) # 80006754 <release>
  acquire(&np->lock);
    8000140e:	8552                	mv	a0,s4
    80001410:	00005097          	auipc	ra,0x5
    80001414:	274080e7          	jalr	628(ra) # 80006684 <acquire>
  np->state = RUNNABLE;
    80001418:	478d                	li	a5,3
    8000141a:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    8000141e:	8552                	mv	a0,s4
    80001420:	00005097          	auipc	ra,0x5
    80001424:	334080e7          	jalr	820(ra) # 80006754 <release>
}
    80001428:	854a                	mv	a0,s2
    8000142a:	70e2                	ld	ra,56(sp)
    8000142c:	7442                	ld	s0,48(sp)
    8000142e:	74a2                	ld	s1,40(sp)
    80001430:	7902                	ld	s2,32(sp)
    80001432:	69e2                	ld	s3,24(sp)
    80001434:	6a42                	ld	s4,16(sp)
    80001436:	6aa2                	ld	s5,8(sp)
    80001438:	6121                	addi	sp,sp,64
    8000143a:	8082                	ret
    return -1;
    8000143c:	597d                	li	s2,-1
    8000143e:	b7ed                	j	80001428 <fork+0x128>

0000000080001440 <scheduler>:
{
    80001440:	7139                	addi	sp,sp,-64
    80001442:	fc06                	sd	ra,56(sp)
    80001444:	f822                	sd	s0,48(sp)
    80001446:	f426                	sd	s1,40(sp)
    80001448:	f04a                	sd	s2,32(sp)
    8000144a:	ec4e                	sd	s3,24(sp)
    8000144c:	e852                	sd	s4,16(sp)
    8000144e:	e456                	sd	s5,8(sp)
    80001450:	e05a                	sd	s6,0(sp)
    80001452:	0080                	addi	s0,sp,64
    80001454:	8792                	mv	a5,tp
  int id = r_tp();
    80001456:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001458:	00779a93          	slli	s5,a5,0x7
    8000145c:	00007717          	auipc	a4,0x7
    80001460:	67470713          	addi	a4,a4,1652 # 80008ad0 <pid_lock>
    80001464:	9756                	add	a4,a4,s5
    80001466:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    8000146a:	00007717          	auipc	a4,0x7
    8000146e:	6ae70713          	addi	a4,a4,1710 # 80008b18 <cpus+0x8>
    80001472:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001474:	498d                	li	s3,3
        p->state = RUNNING;
    80001476:	4b11                	li	s6,4
        c->proc = p;
    80001478:	079e                	slli	a5,a5,0x7
    8000147a:	00007a17          	auipc	s4,0x7
    8000147e:	656a0a13          	addi	s4,s4,1622 # 80008ad0 <pid_lock>
    80001482:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001484:	0000d917          	auipc	s2,0xd
    80001488:	68c90913          	addi	s2,s2,1676 # 8000eb10 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001490:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001494:	10079073          	csrw	sstatus,a5
    80001498:	00008497          	auipc	s1,0x8
    8000149c:	a7848493          	addi	s1,s1,-1416 # 80008f10 <proc>
    800014a0:	a811                	j	800014b4 <scheduler+0x74>
      release(&p->lock);
    800014a2:	8526                	mv	a0,s1
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	2b0080e7          	jalr	688(ra) # 80006754 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ac:	17048493          	addi	s1,s1,368
    800014b0:	fd248ee3          	beq	s1,s2,8000148c <scheduler+0x4c>
      acquire(&p->lock);
    800014b4:	8526                	mv	a0,s1
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	1ce080e7          	jalr	462(ra) # 80006684 <acquire>
      if(p->state == RUNNABLE) {
    800014be:	509c                	lw	a5,32(s1)
    800014c0:	ff3791e3          	bne	a5,s3,800014a2 <scheduler+0x62>
        p->state = RUNNING;
    800014c4:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014c8:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014cc:	06848593          	addi	a1,s1,104
    800014d0:	8556                	mv	a0,s5
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	684080e7          	jalr	1668(ra) # 80001b56 <swtch>
        c->proc = 0;
    800014da:	040a3023          	sd	zero,64(s4)
    800014de:	b7d1                	j	800014a2 <scheduler+0x62>

00000000800014e0 <sched>:
{
    800014e0:	7179                	addi	sp,sp,-48
    800014e2:	f406                	sd	ra,40(sp)
    800014e4:	f022                	sd	s0,32(sp)
    800014e6:	ec26                	sd	s1,24(sp)
    800014e8:	e84a                	sd	s2,16(sp)
    800014ea:	e44e                	sd	s3,8(sp)
    800014ec:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014ee:	00000097          	auipc	ra,0x0
    800014f2:	a5c080e7          	jalr	-1444(ra) # 80000f4a <myproc>
    800014f6:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	112080e7          	jalr	274(ra) # 8000660a <holding>
    80001500:	c93d                	beqz	a0,80001576 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001502:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	00007717          	auipc	a4,0x7
    8000150c:	5c870713          	addi	a4,a4,1480 # 80008ad0 <pid_lock>
    80001510:	97ba                	add	a5,a5,a4
    80001512:	0b87a703          	lw	a4,184(a5)
    80001516:	4785                	li	a5,1
    80001518:	06f71763          	bne	a4,a5,80001586 <sched+0xa6>
  if(p->state == RUNNING)
    8000151c:	5098                	lw	a4,32(s1)
    8000151e:	4791                	li	a5,4
    80001520:	06f70b63          	beq	a4,a5,80001596 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001524:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001528:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000152a:	efb5                	bnez	a5,800015a6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000152c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000152e:	00007917          	auipc	s2,0x7
    80001532:	5a290913          	addi	s2,s2,1442 # 80008ad0 <pid_lock>
    80001536:	2781                	sext.w	a5,a5
    80001538:	079e                	slli	a5,a5,0x7
    8000153a:	97ca                	add	a5,a5,s2
    8000153c:	0bc7a983          	lw	s3,188(a5)
    80001540:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001542:	2781                	sext.w	a5,a5
    80001544:	079e                	slli	a5,a5,0x7
    80001546:	00007597          	auipc	a1,0x7
    8000154a:	5d258593          	addi	a1,a1,1490 # 80008b18 <cpus+0x8>
    8000154e:	95be                	add	a1,a1,a5
    80001550:	06848513          	addi	a0,s1,104
    80001554:	00000097          	auipc	ra,0x0
    80001558:	602080e7          	jalr	1538(ra) # 80001b56 <swtch>
    8000155c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000155e:	2781                	sext.w	a5,a5
    80001560:	079e                	slli	a5,a5,0x7
    80001562:	993e                	add	s2,s2,a5
    80001564:	0b392e23          	sw	s3,188(s2)
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret
    panic("sched p->lock");
    80001576:	00007517          	auipc	a0,0x7
    8000157a:	c2250513          	addi	a0,a0,-990 # 80008198 <etext+0x198>
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	be4080e7          	jalr	-1052(ra) # 80006162 <panic>
    panic("sched locks");
    80001586:	00007517          	auipc	a0,0x7
    8000158a:	c2250513          	addi	a0,a0,-990 # 800081a8 <etext+0x1a8>
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	bd4080e7          	jalr	-1068(ra) # 80006162 <panic>
    panic("sched running");
    80001596:	00007517          	auipc	a0,0x7
    8000159a:	c2250513          	addi	a0,a0,-990 # 800081b8 <etext+0x1b8>
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	bc4080e7          	jalr	-1084(ra) # 80006162 <panic>
    panic("sched interruptible");
    800015a6:	00007517          	auipc	a0,0x7
    800015aa:	c2250513          	addi	a0,a0,-990 # 800081c8 <etext+0x1c8>
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	bb4080e7          	jalr	-1100(ra) # 80006162 <panic>

00000000800015b6 <yield>:
{
    800015b6:	1101                	addi	sp,sp,-32
    800015b8:	ec06                	sd	ra,24(sp)
    800015ba:	e822                	sd	s0,16(sp)
    800015bc:	e426                	sd	s1,8(sp)
    800015be:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	98a080e7          	jalr	-1654(ra) # 80000f4a <myproc>
    800015c8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	0ba080e7          	jalr	186(ra) # 80006684 <acquire>
  p->state = RUNNABLE;
    800015d2:	478d                	li	a5,3
    800015d4:	d09c                	sw	a5,32(s1)
  sched();
    800015d6:	00000097          	auipc	ra,0x0
    800015da:	f0a080e7          	jalr	-246(ra) # 800014e0 <sched>
  release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	174080e7          	jalr	372(ra) # 80006754 <release>
}
    800015e8:	60e2                	ld	ra,24(sp)
    800015ea:	6442                	ld	s0,16(sp)
    800015ec:	64a2                	ld	s1,8(sp)
    800015ee:	6105                	addi	sp,sp,32
    800015f0:	8082                	ret

00000000800015f2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015f2:	7179                	addi	sp,sp,-48
    800015f4:	f406                	sd	ra,40(sp)
    800015f6:	f022                	sd	s0,32(sp)
    800015f8:	ec26                	sd	s1,24(sp)
    800015fa:	e84a                	sd	s2,16(sp)
    800015fc:	e44e                	sd	s3,8(sp)
    800015fe:	1800                	addi	s0,sp,48
    80001600:	89aa                	mv	s3,a0
    80001602:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001604:	00000097          	auipc	ra,0x0
    80001608:	946080e7          	jalr	-1722(ra) # 80000f4a <myproc>
    8000160c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	076080e7          	jalr	118(ra) # 80006684 <acquire>
  release(lk);
    80001616:	854a                	mv	a0,s2
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	13c080e7          	jalr	316(ra) # 80006754 <release>

  // Go to sleep.
  p->chan = chan;
    80001620:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001624:	4789                	li	a5,2
    80001626:	d09c                	sw	a5,32(s1)

  sched();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	eb8080e7          	jalr	-328(ra) # 800014e0 <sched>

  // Tidy up.
  p->chan = 0;
    80001630:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	11e080e7          	jalr	286(ra) # 80006754 <release>
  acquire(lk);
    8000163e:	854a                	mv	a0,s2
    80001640:	00005097          	auipc	ra,0x5
    80001644:	044080e7          	jalr	68(ra) # 80006684 <acquire>
}
    80001648:	70a2                	ld	ra,40(sp)
    8000164a:	7402                	ld	s0,32(sp)
    8000164c:	64e2                	ld	s1,24(sp)
    8000164e:	6942                	ld	s2,16(sp)
    80001650:	69a2                	ld	s3,8(sp)
    80001652:	6145                	addi	sp,sp,48
    80001654:	8082                	ret

0000000080001656 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001656:	7139                	addi	sp,sp,-64
    80001658:	fc06                	sd	ra,56(sp)
    8000165a:	f822                	sd	s0,48(sp)
    8000165c:	f426                	sd	s1,40(sp)
    8000165e:	f04a                	sd	s2,32(sp)
    80001660:	ec4e                	sd	s3,24(sp)
    80001662:	e852                	sd	s4,16(sp)
    80001664:	e456                	sd	s5,8(sp)
    80001666:	0080                	addi	s0,sp,64
    80001668:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000166a:	00008497          	auipc	s1,0x8
    8000166e:	8a648493          	addi	s1,s1,-1882 # 80008f10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001672:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001674:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001676:	0000d917          	auipc	s2,0xd
    8000167a:	49a90913          	addi	s2,s2,1178 # 8000eb10 <tickslock>
    8000167e:	a811                	j	80001692 <wakeup+0x3c>
      }
      release(&p->lock);
    80001680:	8526                	mv	a0,s1
    80001682:	00005097          	auipc	ra,0x5
    80001686:	0d2080e7          	jalr	210(ra) # 80006754 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000168a:	17048493          	addi	s1,s1,368
    8000168e:	03248663          	beq	s1,s2,800016ba <wakeup+0x64>
    if(p != myproc()){
    80001692:	00000097          	auipc	ra,0x0
    80001696:	8b8080e7          	jalr	-1864(ra) # 80000f4a <myproc>
    8000169a:	fea488e3          	beq	s1,a0,8000168a <wakeup+0x34>
      acquire(&p->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	fe4080e7          	jalr	-28(ra) # 80006684 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016a8:	509c                	lw	a5,32(s1)
    800016aa:	fd379be3          	bne	a5,s3,80001680 <wakeup+0x2a>
    800016ae:	749c                	ld	a5,40(s1)
    800016b0:	fd4798e3          	bne	a5,s4,80001680 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016b4:	0354a023          	sw	s5,32(s1)
    800016b8:	b7e1                	j	80001680 <wakeup+0x2a>
    }
  }
}
    800016ba:	70e2                	ld	ra,56(sp)
    800016bc:	7442                	ld	s0,48(sp)
    800016be:	74a2                	ld	s1,40(sp)
    800016c0:	7902                	ld	s2,32(sp)
    800016c2:	69e2                	ld	s3,24(sp)
    800016c4:	6a42                	ld	s4,16(sp)
    800016c6:	6aa2                	ld	s5,8(sp)
    800016c8:	6121                	addi	sp,sp,64
    800016ca:	8082                	ret

00000000800016cc <reparent>:
{
    800016cc:	7179                	addi	sp,sp,-48
    800016ce:	f406                	sd	ra,40(sp)
    800016d0:	f022                	sd	s0,32(sp)
    800016d2:	ec26                	sd	s1,24(sp)
    800016d4:	e84a                	sd	s2,16(sp)
    800016d6:	e44e                	sd	s3,8(sp)
    800016d8:	e052                	sd	s4,0(sp)
    800016da:	1800                	addi	s0,sp,48
    800016dc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016de:	00008497          	auipc	s1,0x8
    800016e2:	83248493          	addi	s1,s1,-1998 # 80008f10 <proc>
      pp->parent = initproc;
    800016e6:	00007a17          	auipc	s4,0x7
    800016ea:	28aa0a13          	addi	s4,s4,650 # 80008970 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ee:	0000d997          	auipc	s3,0xd
    800016f2:	42298993          	addi	s3,s3,1058 # 8000eb10 <tickslock>
    800016f6:	a029                	j	80001700 <reparent+0x34>
    800016f8:	17048493          	addi	s1,s1,368
    800016fc:	01348d63          	beq	s1,s3,80001716 <reparent+0x4a>
    if(pp->parent == p){
    80001700:	60bc                	ld	a5,64(s1)
    80001702:	ff279be3          	bne	a5,s2,800016f8 <reparent+0x2c>
      pp->parent = initproc;
    80001706:	000a3503          	ld	a0,0(s4)
    8000170a:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	f4a080e7          	jalr	-182(ra) # 80001656 <wakeup>
    80001714:	b7d5                	j	800016f8 <reparent+0x2c>
}
    80001716:	70a2                	ld	ra,40(sp)
    80001718:	7402                	ld	s0,32(sp)
    8000171a:	64e2                	ld	s1,24(sp)
    8000171c:	6942                	ld	s2,16(sp)
    8000171e:	69a2                	ld	s3,8(sp)
    80001720:	6a02                	ld	s4,0(sp)
    80001722:	6145                	addi	sp,sp,48
    80001724:	8082                	ret

0000000080001726 <exit>:
{
    80001726:	7179                	addi	sp,sp,-48
    80001728:	f406                	sd	ra,40(sp)
    8000172a:	f022                	sd	s0,32(sp)
    8000172c:	ec26                	sd	s1,24(sp)
    8000172e:	e84a                	sd	s2,16(sp)
    80001730:	e44e                	sd	s3,8(sp)
    80001732:	e052                	sd	s4,0(sp)
    80001734:	1800                	addi	s0,sp,48
    80001736:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	812080e7          	jalr	-2030(ra) # 80000f4a <myproc>
    80001740:	89aa                	mv	s3,a0
  if(p == initproc)
    80001742:	00007797          	auipc	a5,0x7
    80001746:	22e7b783          	ld	a5,558(a5) # 80008970 <initproc>
    8000174a:	0d850493          	addi	s1,a0,216
    8000174e:	15850913          	addi	s2,a0,344
    80001752:	02a79363          	bne	a5,a0,80001778 <exit+0x52>
    panic("init exiting");
    80001756:	00007517          	auipc	a0,0x7
    8000175a:	a8a50513          	addi	a0,a0,-1398 # 800081e0 <etext+0x1e0>
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	a04080e7          	jalr	-1532(ra) # 80006162 <panic>
      fileclose(f);
    80001766:	00002097          	auipc	ra,0x2
    8000176a:	4c6080e7          	jalr	1222(ra) # 80003c2c <fileclose>
      p->ofile[fd] = 0;
    8000176e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001772:	04a1                	addi	s1,s1,8
    80001774:	01248563          	beq	s1,s2,8000177e <exit+0x58>
    if(p->ofile[fd]){
    80001778:	6088                	ld	a0,0(s1)
    8000177a:	f575                	bnez	a0,80001766 <exit+0x40>
    8000177c:	bfdd                	j	80001772 <exit+0x4c>
  begin_op();
    8000177e:	00002097          	auipc	ra,0x2
    80001782:	fea080e7          	jalr	-22(ra) # 80003768 <begin_op>
  iput(p->cwd);
    80001786:	1589b503          	ld	a0,344(s3)
    8000178a:	00001097          	auipc	ra,0x1
    8000178e:	7f2080e7          	jalr	2034(ra) # 80002f7c <iput>
  end_op();
    80001792:	00002097          	auipc	ra,0x2
    80001796:	050080e7          	jalr	80(ra) # 800037e2 <end_op>
  p->cwd = 0;
    8000179a:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000179e:	00007497          	auipc	s1,0x7
    800017a2:	35248493          	addi	s1,s1,850 # 80008af0 <wait_lock>
    800017a6:	8526                	mv	a0,s1
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	edc080e7          	jalr	-292(ra) # 80006684 <acquire>
  reparent(p);
    800017b0:	854e                	mv	a0,s3
    800017b2:	00000097          	auipc	ra,0x0
    800017b6:	f1a080e7          	jalr	-230(ra) # 800016cc <reparent>
  wakeup(p->parent);
    800017ba:	0409b503          	ld	a0,64(s3)
    800017be:	00000097          	auipc	ra,0x0
    800017c2:	e98080e7          	jalr	-360(ra) # 80001656 <wakeup>
  acquire(&p->lock);
    800017c6:	854e                	mv	a0,s3
    800017c8:	00005097          	auipc	ra,0x5
    800017cc:	ebc080e7          	jalr	-324(ra) # 80006684 <acquire>
  p->xstate = status;
    800017d0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800017d4:	4795                	li	a5,5
    800017d6:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800017da:	8526                	mv	a0,s1
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	f78080e7          	jalr	-136(ra) # 80006754 <release>
  sched();
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	cfc080e7          	jalr	-772(ra) # 800014e0 <sched>
  panic("zombie exit");
    800017ec:	00007517          	auipc	a0,0x7
    800017f0:	a0450513          	addi	a0,a0,-1532 # 800081f0 <etext+0x1f0>
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	96e080e7          	jalr	-1682(ra) # 80006162 <panic>

00000000800017fc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017fc:	7179                	addi	sp,sp,-48
    800017fe:	f406                	sd	ra,40(sp)
    80001800:	f022                	sd	s0,32(sp)
    80001802:	ec26                	sd	s1,24(sp)
    80001804:	e84a                	sd	s2,16(sp)
    80001806:	e44e                	sd	s3,8(sp)
    80001808:	1800                	addi	s0,sp,48
    8000180a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000180c:	00007497          	auipc	s1,0x7
    80001810:	70448493          	addi	s1,s1,1796 # 80008f10 <proc>
    80001814:	0000d997          	auipc	s3,0xd
    80001818:	2fc98993          	addi	s3,s3,764 # 8000eb10 <tickslock>
    acquire(&p->lock);
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	e66080e7          	jalr	-410(ra) # 80006684 <acquire>
    if(p->pid == pid){
    80001826:	5c9c                	lw	a5,56(s1)
    80001828:	01278d63          	beq	a5,s2,80001842 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000182c:	8526                	mv	a0,s1
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	f26080e7          	jalr	-218(ra) # 80006754 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001836:	17048493          	addi	s1,s1,368
    8000183a:	ff3491e3          	bne	s1,s3,8000181c <kill+0x20>
  }
  return -1;
    8000183e:	557d                	li	a0,-1
    80001840:	a829                	j	8000185a <kill+0x5e>
      p->killed = 1;
    80001842:	4785                	li	a5,1
    80001844:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001846:	5098                	lw	a4,32(s1)
    80001848:	4789                	li	a5,2
    8000184a:	00f70f63          	beq	a4,a5,80001868 <kill+0x6c>
      release(&p->lock);
    8000184e:	8526                	mv	a0,s1
    80001850:	00005097          	auipc	ra,0x5
    80001854:	f04080e7          	jalr	-252(ra) # 80006754 <release>
      return 0;
    80001858:	4501                	li	a0,0
}
    8000185a:	70a2                	ld	ra,40(sp)
    8000185c:	7402                	ld	s0,32(sp)
    8000185e:	64e2                	ld	s1,24(sp)
    80001860:	6942                	ld	s2,16(sp)
    80001862:	69a2                	ld	s3,8(sp)
    80001864:	6145                	addi	sp,sp,48
    80001866:	8082                	ret
        p->state = RUNNABLE;
    80001868:	478d                	li	a5,3
    8000186a:	d09c                	sw	a5,32(s1)
    8000186c:	b7cd                	j	8000184e <kill+0x52>

000000008000186e <setkilled>:

void
setkilled(struct proc *p)
{
    8000186e:	1101                	addi	sp,sp,-32
    80001870:	ec06                	sd	ra,24(sp)
    80001872:	e822                	sd	s0,16(sp)
    80001874:	e426                	sd	s1,8(sp)
    80001876:	1000                	addi	s0,sp,32
    80001878:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	e0a080e7          	jalr	-502(ra) # 80006684 <acquire>
  p->killed = 1;
    80001882:	4785                	li	a5,1
    80001884:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	ecc080e7          	jalr	-308(ra) # 80006754 <release>
}
    80001890:	60e2                	ld	ra,24(sp)
    80001892:	6442                	ld	s0,16(sp)
    80001894:	64a2                	ld	s1,8(sp)
    80001896:	6105                	addi	sp,sp,32
    80001898:	8082                	ret

000000008000189a <killed>:

int
killed(struct proc *p)
{
    8000189a:	1101                	addi	sp,sp,-32
    8000189c:	ec06                	sd	ra,24(sp)
    8000189e:	e822                	sd	s0,16(sp)
    800018a0:	e426                	sd	s1,8(sp)
    800018a2:	e04a                	sd	s2,0(sp)
    800018a4:	1000                	addi	s0,sp,32
    800018a6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	ddc080e7          	jalr	-548(ra) # 80006684 <acquire>
  k = p->killed;
    800018b0:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    800018b4:	8526                	mv	a0,s1
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	e9e080e7          	jalr	-354(ra) # 80006754 <release>
  return k;
}
    800018be:	854a                	mv	a0,s2
    800018c0:	60e2                	ld	ra,24(sp)
    800018c2:	6442                	ld	s0,16(sp)
    800018c4:	64a2                	ld	s1,8(sp)
    800018c6:	6902                	ld	s2,0(sp)
    800018c8:	6105                	addi	sp,sp,32
    800018ca:	8082                	ret

00000000800018cc <wait>:
{
    800018cc:	715d                	addi	sp,sp,-80
    800018ce:	e486                	sd	ra,72(sp)
    800018d0:	e0a2                	sd	s0,64(sp)
    800018d2:	fc26                	sd	s1,56(sp)
    800018d4:	f84a                	sd	s2,48(sp)
    800018d6:	f44e                	sd	s3,40(sp)
    800018d8:	f052                	sd	s4,32(sp)
    800018da:	ec56                	sd	s5,24(sp)
    800018dc:	e85a                	sd	s6,16(sp)
    800018de:	e45e                	sd	s7,8(sp)
    800018e0:	e062                	sd	s8,0(sp)
    800018e2:	0880                	addi	s0,sp,80
    800018e4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018e6:	fffff097          	auipc	ra,0xfffff
    800018ea:	664080e7          	jalr	1636(ra) # 80000f4a <myproc>
    800018ee:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018f0:	00007517          	auipc	a0,0x7
    800018f4:	20050513          	addi	a0,a0,512 # 80008af0 <wait_lock>
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	d8c080e7          	jalr	-628(ra) # 80006684 <acquire>
    havekids = 0;
    80001900:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001902:	4a15                	li	s4,5
        havekids = 1;
    80001904:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001906:	0000d997          	auipc	s3,0xd
    8000190a:	20a98993          	addi	s3,s3,522 # 8000eb10 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000190e:	00007c17          	auipc	s8,0x7
    80001912:	1e2c0c13          	addi	s8,s8,482 # 80008af0 <wait_lock>
    80001916:	a0d1                	j	800019da <wait+0x10e>
          pid = pp->pid;
    80001918:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000191c:	000b0e63          	beqz	s6,80001938 <wait+0x6c>
    80001920:	4691                	li	a3,4
    80001922:	03448613          	addi	a2,s1,52
    80001926:	85da                	mv	a1,s6
    80001928:	05893503          	ld	a0,88(s2)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	2de080e7          	jalr	734(ra) # 80000c0a <copyout>
    80001934:	04054163          	bltz	a0,80001976 <wait+0xaa>
          freeproc(pp);
    80001938:	8526                	mv	a0,s1
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	7c2080e7          	jalr	1986(ra) # 800010fc <freeproc>
          release(&pp->lock);
    80001942:	8526                	mv	a0,s1
    80001944:	00005097          	auipc	ra,0x5
    80001948:	e10080e7          	jalr	-496(ra) # 80006754 <release>
          release(&wait_lock);
    8000194c:	00007517          	auipc	a0,0x7
    80001950:	1a450513          	addi	a0,a0,420 # 80008af0 <wait_lock>
    80001954:	00005097          	auipc	ra,0x5
    80001958:	e00080e7          	jalr	-512(ra) # 80006754 <release>
}
    8000195c:	854e                	mv	a0,s3
    8000195e:	60a6                	ld	ra,72(sp)
    80001960:	6406                	ld	s0,64(sp)
    80001962:	74e2                	ld	s1,56(sp)
    80001964:	7942                	ld	s2,48(sp)
    80001966:	79a2                	ld	s3,40(sp)
    80001968:	7a02                	ld	s4,32(sp)
    8000196a:	6ae2                	ld	s5,24(sp)
    8000196c:	6b42                	ld	s6,16(sp)
    8000196e:	6ba2                	ld	s7,8(sp)
    80001970:	6c02                	ld	s8,0(sp)
    80001972:	6161                	addi	sp,sp,80
    80001974:	8082                	ret
            release(&pp->lock);
    80001976:	8526                	mv	a0,s1
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	ddc080e7          	jalr	-548(ra) # 80006754 <release>
            release(&wait_lock);
    80001980:	00007517          	auipc	a0,0x7
    80001984:	17050513          	addi	a0,a0,368 # 80008af0 <wait_lock>
    80001988:	00005097          	auipc	ra,0x5
    8000198c:	dcc080e7          	jalr	-564(ra) # 80006754 <release>
            return -1;
    80001990:	59fd                	li	s3,-1
    80001992:	b7e9                	j	8000195c <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001994:	17048493          	addi	s1,s1,368
    80001998:	03348463          	beq	s1,s3,800019c0 <wait+0xf4>
      if(pp->parent == p){
    8000199c:	60bc                	ld	a5,64(s1)
    8000199e:	ff279be3          	bne	a5,s2,80001994 <wait+0xc8>
        acquire(&pp->lock);
    800019a2:	8526                	mv	a0,s1
    800019a4:	00005097          	auipc	ra,0x5
    800019a8:	ce0080e7          	jalr	-800(ra) # 80006684 <acquire>
        if(pp->state == ZOMBIE){
    800019ac:	509c                	lw	a5,32(s1)
    800019ae:	f74785e3          	beq	a5,s4,80001918 <wait+0x4c>
        release(&pp->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	da0080e7          	jalr	-608(ra) # 80006754 <release>
        havekids = 1;
    800019bc:	8756                	mv	a4,s5
    800019be:	bfd9                	j	80001994 <wait+0xc8>
    if(!havekids || killed(p)){
    800019c0:	c31d                	beqz	a4,800019e6 <wait+0x11a>
    800019c2:	854a                	mv	a0,s2
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	ed6080e7          	jalr	-298(ra) # 8000189a <killed>
    800019cc:	ed09                	bnez	a0,800019e6 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019ce:	85e2                	mv	a1,s8
    800019d0:	854a                	mv	a0,s2
    800019d2:	00000097          	auipc	ra,0x0
    800019d6:	c20080e7          	jalr	-992(ra) # 800015f2 <sleep>
    havekids = 0;
    800019da:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019dc:	00007497          	auipc	s1,0x7
    800019e0:	53448493          	addi	s1,s1,1332 # 80008f10 <proc>
    800019e4:	bf65                	j	8000199c <wait+0xd0>
      release(&wait_lock);
    800019e6:	00007517          	auipc	a0,0x7
    800019ea:	10a50513          	addi	a0,a0,266 # 80008af0 <wait_lock>
    800019ee:	00005097          	auipc	ra,0x5
    800019f2:	d66080e7          	jalr	-666(ra) # 80006754 <release>
      return -1;
    800019f6:	59fd                	li	s3,-1
    800019f8:	b795                	j	8000195c <wait+0x90>

00000000800019fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019fa:	7179                	addi	sp,sp,-48
    800019fc:	f406                	sd	ra,40(sp)
    800019fe:	f022                	sd	s0,32(sp)
    80001a00:	ec26                	sd	s1,24(sp)
    80001a02:	e84a                	sd	s2,16(sp)
    80001a04:	e44e                	sd	s3,8(sp)
    80001a06:	e052                	sd	s4,0(sp)
    80001a08:	1800                	addi	s0,sp,48
    80001a0a:	84aa                	mv	s1,a0
    80001a0c:	892e                	mv	s2,a1
    80001a0e:	89b2                	mv	s3,a2
    80001a10:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	538080e7          	jalr	1336(ra) # 80000f4a <myproc>
  if(user_dst){
    80001a1a:	c08d                	beqz	s1,80001a3c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a1c:	86d2                	mv	a3,s4
    80001a1e:	864e                	mv	a2,s3
    80001a20:	85ca                	mv	a1,s2
    80001a22:	6d28                	ld	a0,88(a0)
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	1e6080e7          	jalr	486(ra) # 80000c0a <copyout>
  } else {
    memmove((char *)dst, src, len);
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
    memmove((char *)dst, src, len);
    80001a3c:	000a061b          	sext.w	a2,s4
    80001a40:	85ce                	mv	a1,s3
    80001a42:	854a                	mv	a0,s2
    80001a44:	fffff097          	auipc	ra,0xfffff
    80001a48:	87a080e7          	jalr	-1926(ra) # 800002be <memmove>
    return 0;
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	bff9                	j	80001a2c <either_copyout+0x32>

0000000080001a50 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a50:	7179                	addi	sp,sp,-48
    80001a52:	f406                	sd	ra,40(sp)
    80001a54:	f022                	sd	s0,32(sp)
    80001a56:	ec26                	sd	s1,24(sp)
    80001a58:	e84a                	sd	s2,16(sp)
    80001a5a:	e44e                	sd	s3,8(sp)
    80001a5c:	e052                	sd	s4,0(sp)
    80001a5e:	1800                	addi	s0,sp,48
    80001a60:	892a                	mv	s2,a0
    80001a62:	84ae                	mv	s1,a1
    80001a64:	89b2                	mv	s3,a2
    80001a66:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	4e2080e7          	jalr	1250(ra) # 80000f4a <myproc>
  if(user_src){
    80001a70:	c08d                	beqz	s1,80001a92 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a72:	86d2                	mv	a3,s4
    80001a74:	864e                	mv	a2,s3
    80001a76:	85ca                	mv	a1,s2
    80001a78:	6d28                	ld	a0,88(a0)
    80001a7a:	fffff097          	auipc	ra,0xfffff
    80001a7e:	21c080e7          	jalr	540(ra) # 80000c96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a82:	70a2                	ld	ra,40(sp)
    80001a84:	7402                	ld	s0,32(sp)
    80001a86:	64e2                	ld	s1,24(sp)
    80001a88:	6942                	ld	s2,16(sp)
    80001a8a:	69a2                	ld	s3,8(sp)
    80001a8c:	6a02                	ld	s4,0(sp)
    80001a8e:	6145                	addi	sp,sp,48
    80001a90:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a92:	000a061b          	sext.w	a2,s4
    80001a96:	85ce                	mv	a1,s3
    80001a98:	854a                	mv	a0,s2
    80001a9a:	fffff097          	auipc	ra,0xfffff
    80001a9e:	824080e7          	jalr	-2012(ra) # 800002be <memmove>
    return 0;
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	bff9                	j	80001a82 <either_copyin+0x32>

0000000080001aa6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aa6:	715d                	addi	sp,sp,-80
    80001aa8:	e486                	sd	ra,72(sp)
    80001aaa:	e0a2                	sd	s0,64(sp)
    80001aac:	fc26                	sd	s1,56(sp)
    80001aae:	f84a                	sd	s2,48(sp)
    80001ab0:	f44e                	sd	s3,40(sp)
    80001ab2:	f052                	sd	s4,32(sp)
    80001ab4:	ec56                	sd	s5,24(sp)
    80001ab6:	e85a                	sd	s6,16(sp)
    80001ab8:	e45e                	sd	s7,8(sp)
    80001aba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001abc:	00007517          	auipc	a0,0x7
    80001ac0:	ddc50513          	addi	a0,a0,-548 # 80008898 <digits+0x88>
    80001ac4:	00004097          	auipc	ra,0x4
    80001ac8:	6e8080e7          	jalr	1768(ra) # 800061ac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001acc:	00007497          	auipc	s1,0x7
    80001ad0:	5a448493          	addi	s1,s1,1444 # 80009070 <proc+0x160>
    80001ad4:	0000d917          	auipc	s2,0xd
    80001ad8:	19c90913          	addi	s2,s2,412 # 8000ec70 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001adc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ade:	00006997          	auipc	s3,0x6
    80001ae2:	72298993          	addi	s3,s3,1826 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae6:	00006a97          	auipc	s5,0x6
    80001aea:	722a8a93          	addi	s5,s5,1826 # 80008208 <etext+0x208>
    printf("\n");
    80001aee:	00007a17          	auipc	s4,0x7
    80001af2:	daaa0a13          	addi	s4,s4,-598 # 80008898 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af6:	00006b97          	auipc	s7,0x6
    80001afa:	752b8b93          	addi	s7,s7,1874 # 80008248 <states.0>
    80001afe:	a00d                	j	80001b20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b00:	ed86a583          	lw	a1,-296(a3)
    80001b04:	8556                	mv	a0,s5
    80001b06:	00004097          	auipc	ra,0x4
    80001b0a:	6a6080e7          	jalr	1702(ra) # 800061ac <printf>
    printf("\n");
    80001b0e:	8552                	mv	a0,s4
    80001b10:	00004097          	auipc	ra,0x4
    80001b14:	69c080e7          	jalr	1692(ra) # 800061ac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b18:	17048493          	addi	s1,s1,368
    80001b1c:	03248263          	beq	s1,s2,80001b40 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b20:	86a6                	mv	a3,s1
    80001b22:	ec04a783          	lw	a5,-320(s1)
    80001b26:	dbed                	beqz	a5,80001b18 <procdump+0x72>
      state = "???";
    80001b28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b2a:	fcfb6be3          	bltu	s6,a5,80001b00 <procdump+0x5a>
    80001b2e:	02079713          	slli	a4,a5,0x20
    80001b32:	01d75793          	srli	a5,a4,0x1d
    80001b36:	97de                	add	a5,a5,s7
    80001b38:	6390                	ld	a2,0(a5)
    80001b3a:	f279                	bnez	a2,80001b00 <procdump+0x5a>
      state = "???";
    80001b3c:	864e                	mv	a2,s3
    80001b3e:	b7c9                	j	80001b00 <procdump+0x5a>
  }
}
    80001b40:	60a6                	ld	ra,72(sp)
    80001b42:	6406                	ld	s0,64(sp)
    80001b44:	74e2                	ld	s1,56(sp)
    80001b46:	7942                	ld	s2,48(sp)
    80001b48:	79a2                	ld	s3,40(sp)
    80001b4a:	7a02                	ld	s4,32(sp)
    80001b4c:	6ae2                	ld	s5,24(sp)
    80001b4e:	6b42                	ld	s6,16(sp)
    80001b50:	6ba2                	ld	s7,8(sp)
    80001b52:	6161                	addi	sp,sp,80
    80001b54:	8082                	ret

0000000080001b56 <swtch>:
    80001b56:	00153023          	sd	ra,0(a0)
    80001b5a:	00253423          	sd	sp,8(a0)
    80001b5e:	e900                	sd	s0,16(a0)
    80001b60:	ed04                	sd	s1,24(a0)
    80001b62:	03253023          	sd	s2,32(a0)
    80001b66:	03353423          	sd	s3,40(a0)
    80001b6a:	03453823          	sd	s4,48(a0)
    80001b6e:	03553c23          	sd	s5,56(a0)
    80001b72:	05653023          	sd	s6,64(a0)
    80001b76:	05753423          	sd	s7,72(a0)
    80001b7a:	05853823          	sd	s8,80(a0)
    80001b7e:	05953c23          	sd	s9,88(a0)
    80001b82:	07a53023          	sd	s10,96(a0)
    80001b86:	07b53423          	sd	s11,104(a0)
    80001b8a:	0005b083          	ld	ra,0(a1)
    80001b8e:	0085b103          	ld	sp,8(a1)
    80001b92:	6980                	ld	s0,16(a1)
    80001b94:	6d84                	ld	s1,24(a1)
    80001b96:	0205b903          	ld	s2,32(a1)
    80001b9a:	0285b983          	ld	s3,40(a1)
    80001b9e:	0305ba03          	ld	s4,48(a1)
    80001ba2:	0385ba83          	ld	s5,56(a1)
    80001ba6:	0405bb03          	ld	s6,64(a1)
    80001baa:	0485bb83          	ld	s7,72(a1)
    80001bae:	0505bc03          	ld	s8,80(a1)
    80001bb2:	0585bc83          	ld	s9,88(a1)
    80001bb6:	0605bd03          	ld	s10,96(a1)
    80001bba:	0685bd83          	ld	s11,104(a1)
    80001bbe:	8082                	ret

0000000080001bc0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bc0:	1141                	addi	sp,sp,-16
    80001bc2:	e406                	sd	ra,8(sp)
    80001bc4:	e022                	sd	s0,0(sp)
    80001bc6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bc8:	00006597          	auipc	a1,0x6
    80001bcc:	6b058593          	addi	a1,a1,1712 # 80008278 <states.0+0x30>
    80001bd0:	0000d517          	auipc	a0,0xd
    80001bd4:	f4050513          	addi	a0,a0,-192 # 8000eb10 <tickslock>
    80001bd8:	00005097          	auipc	ra,0x5
    80001bdc:	c28080e7          	jalr	-984(ra) # 80006800 <initlock>
}
    80001be0:	60a2                	ld	ra,8(sp)
    80001be2:	6402                	ld	s0,0(sp)
    80001be4:	0141                	addi	sp,sp,16
    80001be6:	8082                	ret

0000000080001be8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001be8:	1141                	addi	sp,sp,-16
    80001bea:	e422                	sd	s0,8(sp)
    80001bec:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bee:	00003797          	auipc	a5,0x3
    80001bf2:	67278793          	addi	a5,a5,1650 # 80005260 <kernelvec>
    80001bf6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bfa:	6422                	ld	s0,8(sp)
    80001bfc:	0141                	addi	sp,sp,16
    80001bfe:	8082                	ret

0000000080001c00 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c00:	1141                	addi	sp,sp,-16
    80001c02:	e406                	sd	ra,8(sp)
    80001c04:	e022                	sd	s0,0(sp)
    80001c06:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	342080e7          	jalr	834(ra) # 80000f4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c16:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c1a:	00005697          	auipc	a3,0x5
    80001c1e:	3e668693          	addi	a3,a3,998 # 80007000 <_trampoline>
    80001c22:	00005717          	auipc	a4,0x5
    80001c26:	3de70713          	addi	a4,a4,990 # 80007000 <_trampoline>
    80001c2a:	8f15                	sub	a4,a4,a3
    80001c2c:	040007b7          	lui	a5,0x4000
    80001c30:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c32:	07b2                	slli	a5,a5,0xc
    80001c34:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c36:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c3a:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c3c:	18002673          	csrr	a2,satp
    80001c40:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c42:	7130                	ld	a2,96(a0)
    80001c44:	6538                	ld	a4,72(a0)
    80001c46:	6585                	lui	a1,0x1
    80001c48:	972e                	add	a4,a4,a1
    80001c4a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c4c:	7138                	ld	a4,96(a0)
    80001c4e:	00000617          	auipc	a2,0x0
    80001c52:	13460613          	addi	a2,a2,308 # 80001d82 <usertrap>
    80001c56:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c58:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c5a:	8612                	mv	a2,tp
    80001c5c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c5e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c62:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c66:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c6a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c6e:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c70:	6f18                	ld	a4,24(a4)
    80001c72:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c76:	6d28                	ld	a0,88(a0)
    80001c78:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c7a:	00005717          	auipc	a4,0x5
    80001c7e:	42270713          	addi	a4,a4,1058 # 8000709c <userret>
    80001c82:	8f15                	sub	a4,a4,a3
    80001c84:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c86:	577d                	li	a4,-1
    80001c88:	177e                	slli	a4,a4,0x3f
    80001c8a:	8d59                	or	a0,a0,a4
    80001c8c:	9782                	jalr	a5
}
    80001c8e:	60a2                	ld	ra,8(sp)
    80001c90:	6402                	ld	s0,0(sp)
    80001c92:	0141                	addi	sp,sp,16
    80001c94:	8082                	ret

0000000080001c96 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c96:	1101                	addi	sp,sp,-32
    80001c98:	ec06                	sd	ra,24(sp)
    80001c9a:	e822                	sd	s0,16(sp)
    80001c9c:	e426                	sd	s1,8(sp)
    80001c9e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ca0:	0000d497          	auipc	s1,0xd
    80001ca4:	e7048493          	addi	s1,s1,-400 # 8000eb10 <tickslock>
    80001ca8:	8526                	mv	a0,s1
    80001caa:	00005097          	auipc	ra,0x5
    80001cae:	9da080e7          	jalr	-1574(ra) # 80006684 <acquire>
  ticks++;
    80001cb2:	00007517          	auipc	a0,0x7
    80001cb6:	cc650513          	addi	a0,a0,-826 # 80008978 <ticks>
    80001cba:	411c                	lw	a5,0(a0)
    80001cbc:	2785                	addiw	a5,a5,1
    80001cbe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	996080e7          	jalr	-1642(ra) # 80001656 <wakeup>
  release(&tickslock);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	00005097          	auipc	ra,0x5
    80001cce:	a8a080e7          	jalr	-1398(ra) # 80006754 <release>
}
    80001cd2:	60e2                	ld	ra,24(sp)
    80001cd4:	6442                	ld	s0,16(sp)
    80001cd6:	64a2                	ld	s1,8(sp)
    80001cd8:	6105                	addi	sp,sp,32
    80001cda:	8082                	ret

0000000080001cdc <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cdc:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ce0:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ce2:	0807df63          	bgez	a5,80001d80 <devintr+0xa4>
{
    80001ce6:	1101                	addi	sp,sp,-32
    80001ce8:	ec06                	sd	ra,24(sp)
    80001cea:	e822                	sd	s0,16(sp)
    80001cec:	e426                	sd	s1,8(sp)
    80001cee:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cf0:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cf4:	46a5                	li	a3,9
    80001cf6:	00d70d63          	beq	a4,a3,80001d10 <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001cfa:	577d                	li	a4,-1
    80001cfc:	177e                	slli	a4,a4,0x3f
    80001cfe:	0705                	addi	a4,a4,1
    return 0;
    80001d00:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d02:	04e78e63          	beq	a5,a4,80001d5e <devintr+0x82>
  }
}
    80001d06:	60e2                	ld	ra,24(sp)
    80001d08:	6442                	ld	s0,16(sp)
    80001d0a:	64a2                	ld	s1,8(sp)
    80001d0c:	6105                	addi	sp,sp,32
    80001d0e:	8082                	ret
    int irq = plic_claim();
    80001d10:	00003097          	auipc	ra,0x3
    80001d14:	658080e7          	jalr	1624(ra) # 80005368 <plic_claim>
    80001d18:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d1a:	47a9                	li	a5,10
    80001d1c:	02f50763          	beq	a0,a5,80001d4a <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001d20:	4785                	li	a5,1
    80001d22:	02f50963          	beq	a0,a5,80001d54 <devintr+0x78>
    return 1;
    80001d26:	4505                	li	a0,1
    } else if(irq){
    80001d28:	dcf9                	beqz	s1,80001d06 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d2a:	85a6                	mv	a1,s1
    80001d2c:	00006517          	auipc	a0,0x6
    80001d30:	55450513          	addi	a0,a0,1364 # 80008280 <states.0+0x38>
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	478080e7          	jalr	1144(ra) # 800061ac <printf>
      plic_complete(irq);
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	00003097          	auipc	ra,0x3
    80001d42:	64e080e7          	jalr	1614(ra) # 8000538c <plic_complete>
    return 1;
    80001d46:	4505                	li	a0,1
    80001d48:	bf7d                	j	80001d06 <devintr+0x2a>
      uartintr();
    80001d4a:	00005097          	auipc	ra,0x5
    80001d4e:	870080e7          	jalr	-1936(ra) # 800065ba <uartintr>
    if(irq)
    80001d52:	b7ed                	j	80001d3c <devintr+0x60>
      virtio_disk_intr();
    80001d54:	00004097          	auipc	ra,0x4
    80001d58:	afe080e7          	jalr	-1282(ra) # 80005852 <virtio_disk_intr>
    if(irq)
    80001d5c:	b7c5                	j	80001d3c <devintr+0x60>
    if(cpuid() == 0){
    80001d5e:	fffff097          	auipc	ra,0xfffff
    80001d62:	1c0080e7          	jalr	448(ra) # 80000f1e <cpuid>
    80001d66:	c901                	beqz	a0,80001d76 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d68:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d6e:	14479073          	csrw	sip,a5
    return 2;
    80001d72:	4509                	li	a0,2
    80001d74:	bf49                	j	80001d06 <devintr+0x2a>
      clockintr();
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	f20080e7          	jalr	-224(ra) # 80001c96 <clockintr>
    80001d7e:	b7ed                	j	80001d68 <devintr+0x8c>
}
    80001d80:	8082                	ret

0000000080001d82 <usertrap>:
{
    80001d82:	1101                	addi	sp,sp,-32
    80001d84:	ec06                	sd	ra,24(sp)
    80001d86:	e822                	sd	s0,16(sp)
    80001d88:	e426                	sd	s1,8(sp)
    80001d8a:	e04a                	sd	s2,0(sp)
    80001d8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d92:	1007f793          	andi	a5,a5,256
    80001d96:	e3b1                	bnez	a5,80001dda <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d98:	00003797          	auipc	a5,0x3
    80001d9c:	4c878793          	addi	a5,a5,1224 # 80005260 <kernelvec>
    80001da0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	1a6080e7          	jalr	422(ra) # 80000f4a <myproc>
    80001dac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dae:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db0:	14102773          	csrr	a4,sepc
    80001db4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dba:	47a1                	li	a5,8
    80001dbc:	02f70763          	beq	a4,a5,80001dea <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	f1c080e7          	jalr	-228(ra) # 80001cdc <devintr>
    80001dc8:	892a                	mv	s2,a0
    80001dca:	c151                	beqz	a0,80001e4e <usertrap+0xcc>
  if(killed(p))
    80001dcc:	8526                	mv	a0,s1
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	acc080e7          	jalr	-1332(ra) # 8000189a <killed>
    80001dd6:	c929                	beqz	a0,80001e28 <usertrap+0xa6>
    80001dd8:	a099                	j	80001e1e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001dda:	00006517          	auipc	a0,0x6
    80001dde:	4c650513          	addi	a0,a0,1222 # 800082a0 <states.0+0x58>
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	380080e7          	jalr	896(ra) # 80006162 <panic>
    if(killed(p))
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	ab0080e7          	jalr	-1360(ra) # 8000189a <killed>
    80001df2:	e921                	bnez	a0,80001e42 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001df4:	70b8                	ld	a4,96(s1)
    80001df6:	6f1c                	ld	a5,24(a4)
    80001df8:	0791                	addi	a5,a5,4
    80001dfa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e04:	10079073          	csrw	sstatus,a5
    syscall();
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	2d4080e7          	jalr	724(ra) # 800020dc <syscall>
  if(killed(p))
    80001e10:	8526                	mv	a0,s1
    80001e12:	00000097          	auipc	ra,0x0
    80001e16:	a88080e7          	jalr	-1400(ra) # 8000189a <killed>
    80001e1a:	c911                	beqz	a0,80001e2e <usertrap+0xac>
    80001e1c:	4901                	li	s2,0
    exit(-1);
    80001e1e:	557d                	li	a0,-1
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	906080e7          	jalr	-1786(ra) # 80001726 <exit>
  if(which_dev == 2)
    80001e28:	4789                	li	a5,2
    80001e2a:	04f90f63          	beq	s2,a5,80001e88 <usertrap+0x106>
  usertrapret();
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	dd2080e7          	jalr	-558(ra) # 80001c00 <usertrapret>
}
    80001e36:	60e2                	ld	ra,24(sp)
    80001e38:	6442                	ld	s0,16(sp)
    80001e3a:	64a2                	ld	s1,8(sp)
    80001e3c:	6902                	ld	s2,0(sp)
    80001e3e:	6105                	addi	sp,sp,32
    80001e40:	8082                	ret
      exit(-1);
    80001e42:	557d                	li	a0,-1
    80001e44:	00000097          	auipc	ra,0x0
    80001e48:	8e2080e7          	jalr	-1822(ra) # 80001726 <exit>
    80001e4c:	b765                	j	80001df4 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e4e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e52:	5c90                	lw	a2,56(s1)
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	46c50513          	addi	a0,a0,1132 # 800082c0 <states.0+0x78>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	350080e7          	jalr	848(ra) # 800061ac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e68:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	48450513          	addi	a0,a0,1156 # 800082f0 <states.0+0xa8>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	338080e7          	jalr	824(ra) # 800061ac <printf>
    setkilled(p);
    80001e7c:	8526                	mv	a0,s1
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	9f0080e7          	jalr	-1552(ra) # 8000186e <setkilled>
    80001e86:	b769                	j	80001e10 <usertrap+0x8e>
    yield();
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	72e080e7          	jalr	1838(ra) # 800015b6 <yield>
    80001e90:	bf79                	j	80001e2e <usertrap+0xac>

0000000080001e92 <kerneltrap>:
{
    80001e92:	7179                	addi	sp,sp,-48
    80001e94:	f406                	sd	ra,40(sp)
    80001e96:	f022                	sd	s0,32(sp)
    80001e98:	ec26                	sd	s1,24(sp)
    80001e9a:	e84a                	sd	s2,16(sp)
    80001e9c:	e44e                	sd	s3,8(sp)
    80001e9e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001eac:	1004f793          	andi	a5,s1,256
    80001eb0:	cb85                	beqz	a5,80001ee0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eb6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001eb8:	ef85                	bnez	a5,80001ef0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001eba:	00000097          	auipc	ra,0x0
    80001ebe:	e22080e7          	jalr	-478(ra) # 80001cdc <devintr>
    80001ec2:	cd1d                	beqz	a0,80001f00 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec4:	4789                	li	a5,2
    80001ec6:	06f50a63          	beq	a0,a5,80001f3a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eca:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ece:	10049073          	csrw	sstatus,s1
}
    80001ed2:	70a2                	ld	ra,40(sp)
    80001ed4:	7402                	ld	s0,32(sp)
    80001ed6:	64e2                	ld	s1,24(sp)
    80001ed8:	6942                	ld	s2,16(sp)
    80001eda:	69a2                	ld	s3,8(sp)
    80001edc:	6145                	addi	sp,sp,48
    80001ede:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ee0:	00006517          	auipc	a0,0x6
    80001ee4:	43050513          	addi	a0,a0,1072 # 80008310 <states.0+0xc8>
    80001ee8:	00004097          	auipc	ra,0x4
    80001eec:	27a080e7          	jalr	634(ra) # 80006162 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	44850513          	addi	a0,a0,1096 # 80008338 <states.0+0xf0>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	26a080e7          	jalr	618(ra) # 80006162 <panic>
    printf("scause %p\n", scause);
    80001f00:	85ce                	mv	a1,s3
    80001f02:	00006517          	auipc	a0,0x6
    80001f06:	45650513          	addi	a0,a0,1110 # 80008358 <states.0+0x110>
    80001f0a:	00004097          	auipc	ra,0x4
    80001f0e:	2a2080e7          	jalr	674(ra) # 800061ac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f12:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f16:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f1a:	00006517          	auipc	a0,0x6
    80001f1e:	44e50513          	addi	a0,a0,1102 # 80008368 <states.0+0x120>
    80001f22:	00004097          	auipc	ra,0x4
    80001f26:	28a080e7          	jalr	650(ra) # 800061ac <printf>
    panic("kerneltrap");
    80001f2a:	00006517          	auipc	a0,0x6
    80001f2e:	45650513          	addi	a0,a0,1110 # 80008380 <states.0+0x138>
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	230080e7          	jalr	560(ra) # 80006162 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	010080e7          	jalr	16(ra) # 80000f4a <myproc>
    80001f42:	d541                	beqz	a0,80001eca <kerneltrap+0x38>
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	006080e7          	jalr	6(ra) # 80000f4a <myproc>
    80001f4c:	5118                	lw	a4,32(a0)
    80001f4e:	4791                	li	a5,4
    80001f50:	f6f71de3          	bne	a4,a5,80001eca <kerneltrap+0x38>
    yield();
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	662080e7          	jalr	1634(ra) # 800015b6 <yield>
    80001f5c:	b7bd                	j	80001eca <kerneltrap+0x38>

0000000080001f5e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f5e:	1101                	addi	sp,sp,-32
    80001f60:	ec06                	sd	ra,24(sp)
    80001f62:	e822                	sd	s0,16(sp)
    80001f64:	e426                	sd	s1,8(sp)
    80001f66:	1000                	addi	s0,sp,32
    80001f68:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	fe0080e7          	jalr	-32(ra) # 80000f4a <myproc>
  switch (n) {
    80001f72:	4795                	li	a5,5
    80001f74:	0497e163          	bltu	a5,s1,80001fb6 <argraw+0x58>
    80001f78:	048a                	slli	s1,s1,0x2
    80001f7a:	00006717          	auipc	a4,0x6
    80001f7e:	43e70713          	addi	a4,a4,1086 # 800083b8 <states.0+0x170>
    80001f82:	94ba                	add	s1,s1,a4
    80001f84:	409c                	lw	a5,0(s1)
    80001f86:	97ba                	add	a5,a5,a4
    80001f88:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f8a:	713c                	ld	a5,96(a0)
    80001f8c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f8e:	60e2                	ld	ra,24(sp)
    80001f90:	6442                	ld	s0,16(sp)
    80001f92:	64a2                	ld	s1,8(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret
    return p->trapframe->a1;
    80001f98:	713c                	ld	a5,96(a0)
    80001f9a:	7fa8                	ld	a0,120(a5)
    80001f9c:	bfcd                	j	80001f8e <argraw+0x30>
    return p->trapframe->a2;
    80001f9e:	713c                	ld	a5,96(a0)
    80001fa0:	63c8                	ld	a0,128(a5)
    80001fa2:	b7f5                	j	80001f8e <argraw+0x30>
    return p->trapframe->a3;
    80001fa4:	713c                	ld	a5,96(a0)
    80001fa6:	67c8                	ld	a0,136(a5)
    80001fa8:	b7dd                	j	80001f8e <argraw+0x30>
    return p->trapframe->a4;
    80001faa:	713c                	ld	a5,96(a0)
    80001fac:	6bc8                	ld	a0,144(a5)
    80001fae:	b7c5                	j	80001f8e <argraw+0x30>
    return p->trapframe->a5;
    80001fb0:	713c                	ld	a5,96(a0)
    80001fb2:	6fc8                	ld	a0,152(a5)
    80001fb4:	bfe9                	j	80001f8e <argraw+0x30>
  panic("argraw");
    80001fb6:	00006517          	auipc	a0,0x6
    80001fba:	3da50513          	addi	a0,a0,986 # 80008390 <states.0+0x148>
    80001fbe:	00004097          	auipc	ra,0x4
    80001fc2:	1a4080e7          	jalr	420(ra) # 80006162 <panic>

0000000080001fc6 <fetchaddr>:
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	e04a                	sd	s2,0(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84aa                	mv	s1,a0
    80001fd4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f74080e7          	jalr	-140(ra) # 80000f4a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fde:	693c                	ld	a5,80(a0)
    80001fe0:	02f4f863          	bgeu	s1,a5,80002010 <fetchaddr+0x4a>
    80001fe4:	00848713          	addi	a4,s1,8
    80001fe8:	02e7e663          	bltu	a5,a4,80002014 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fec:	46a1                	li	a3,8
    80001fee:	8626                	mv	a2,s1
    80001ff0:	85ca                	mv	a1,s2
    80001ff2:	6d28                	ld	a0,88(a0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	ca2080e7          	jalr	-862(ra) # 80000c96 <copyin>
    80001ffc:	00a03533          	snez	a0,a0
    80002000:	40a00533          	neg	a0,a0
}
    80002004:	60e2                	ld	ra,24(sp)
    80002006:	6442                	ld	s0,16(sp)
    80002008:	64a2                	ld	s1,8(sp)
    8000200a:	6902                	ld	s2,0(sp)
    8000200c:	6105                	addi	sp,sp,32
    8000200e:	8082                	ret
    return -1;
    80002010:	557d                	li	a0,-1
    80002012:	bfcd                	j	80002004 <fetchaddr+0x3e>
    80002014:	557d                	li	a0,-1
    80002016:	b7fd                	j	80002004 <fetchaddr+0x3e>

0000000080002018 <fetchstr>:
{
    80002018:	7179                	addi	sp,sp,-48
    8000201a:	f406                	sd	ra,40(sp)
    8000201c:	f022                	sd	s0,32(sp)
    8000201e:	ec26                	sd	s1,24(sp)
    80002020:	e84a                	sd	s2,16(sp)
    80002022:	e44e                	sd	s3,8(sp)
    80002024:	1800                	addi	s0,sp,48
    80002026:	892a                	mv	s2,a0
    80002028:	84ae                	mv	s1,a1
    8000202a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	f1e080e7          	jalr	-226(ra) # 80000f4a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002034:	86ce                	mv	a3,s3
    80002036:	864a                	mv	a2,s2
    80002038:	85a6                	mv	a1,s1
    8000203a:	6d28                	ld	a0,88(a0)
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	ce8080e7          	jalr	-792(ra) # 80000d24 <copyinstr>
    80002044:	00054e63          	bltz	a0,80002060 <fetchstr+0x48>
  return strlen(buf);
    80002048:	8526                	mv	a0,s1
    8000204a:	ffffe097          	auipc	ra,0xffffe
    8000204e:	392080e7          	jalr	914(ra) # 800003dc <strlen>
}
    80002052:	70a2                	ld	ra,40(sp)
    80002054:	7402                	ld	s0,32(sp)
    80002056:	64e2                	ld	s1,24(sp)
    80002058:	6942                	ld	s2,16(sp)
    8000205a:	69a2                	ld	s3,8(sp)
    8000205c:	6145                	addi	sp,sp,48
    8000205e:	8082                	ret
    return -1;
    80002060:	557d                	li	a0,-1
    80002062:	bfc5                	j	80002052 <fetchstr+0x3a>

0000000080002064 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002064:	1101                	addi	sp,sp,-32
    80002066:	ec06                	sd	ra,24(sp)
    80002068:	e822                	sd	s0,16(sp)
    8000206a:	e426                	sd	s1,8(sp)
    8000206c:	1000                	addi	s0,sp,32
    8000206e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002070:	00000097          	auipc	ra,0x0
    80002074:	eee080e7          	jalr	-274(ra) # 80001f5e <argraw>
    80002078:	c088                	sw	a0,0(s1)
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6105                	addi	sp,sp,32
    80002082:	8082                	ret

0000000080002084 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002084:	1101                	addi	sp,sp,-32
    80002086:	ec06                	sd	ra,24(sp)
    80002088:	e822                	sd	s0,16(sp)
    8000208a:	e426                	sd	s1,8(sp)
    8000208c:	1000                	addi	s0,sp,32
    8000208e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002090:	00000097          	auipc	ra,0x0
    80002094:	ece080e7          	jalr	-306(ra) # 80001f5e <argraw>
    80002098:	e088                	sd	a0,0(s1)
}
    8000209a:	60e2                	ld	ra,24(sp)
    8000209c:	6442                	ld	s0,16(sp)
    8000209e:	64a2                	ld	s1,8(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020a4:	7179                	addi	sp,sp,-48
    800020a6:	f406                	sd	ra,40(sp)
    800020a8:	f022                	sd	s0,32(sp)
    800020aa:	ec26                	sd	s1,24(sp)
    800020ac:	e84a                	sd	s2,16(sp)
    800020ae:	1800                	addi	s0,sp,48
    800020b0:	84ae                	mv	s1,a1
    800020b2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800020b4:	fd840593          	addi	a1,s0,-40
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	fcc080e7          	jalr	-52(ra) # 80002084 <argaddr>
  return fetchstr(addr, buf, max);
    800020c0:	864a                	mv	a2,s2
    800020c2:	85a6                	mv	a1,s1
    800020c4:	fd843503          	ld	a0,-40(s0)
    800020c8:	00000097          	auipc	ra,0x0
    800020cc:	f50080e7          	jalr	-176(ra) # 80002018 <fetchstr>
}
    800020d0:	70a2                	ld	ra,40(sp)
    800020d2:	7402                	ld	s0,32(sp)
    800020d4:	64e2                	ld	s1,24(sp)
    800020d6:	6942                	ld	s2,16(sp)
    800020d8:	6145                	addi	sp,sp,48
    800020da:	8082                	ret

00000000800020dc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020dc:	1101                	addi	sp,sp,-32
    800020de:	ec06                	sd	ra,24(sp)
    800020e0:	e822                	sd	s0,16(sp)
    800020e2:	e426                	sd	s1,8(sp)
    800020e4:	e04a                	sd	s2,0(sp)
    800020e6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	e62080e7          	jalr	-414(ra) # 80000f4a <myproc>
    800020f0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020f2:	06053903          	ld	s2,96(a0)
    800020f6:	0a893783          	ld	a5,168(s2)
    800020fa:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020fe:	37fd                	addiw	a5,a5,-1
    80002100:	4751                	li	a4,20
    80002102:	00f76f63          	bltu	a4,a5,80002120 <syscall+0x44>
    80002106:	00369713          	slli	a4,a3,0x3
    8000210a:	00006797          	auipc	a5,0x6
    8000210e:	2c678793          	addi	a5,a5,710 # 800083d0 <syscalls>
    80002112:	97ba                	add	a5,a5,a4
    80002114:	639c                	ld	a5,0(a5)
    80002116:	c789                	beqz	a5,80002120 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002118:	9782                	jalr	a5
    8000211a:	06a93823          	sd	a0,112(s2)
    8000211e:	a839                	j	8000213c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002120:	16048613          	addi	a2,s1,352
    80002124:	5c8c                	lw	a1,56(s1)
    80002126:	00006517          	auipc	a0,0x6
    8000212a:	27250513          	addi	a0,a0,626 # 80008398 <states.0+0x150>
    8000212e:	00004097          	auipc	ra,0x4
    80002132:	07e080e7          	jalr	126(ra) # 800061ac <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002136:	70bc                	ld	a5,96(s1)
    80002138:	577d                	li	a4,-1
    8000213a:	fbb8                	sd	a4,112(a5)
  }
}
    8000213c:	60e2                	ld	ra,24(sp)
    8000213e:	6442                	ld	s0,16(sp)
    80002140:	64a2                	ld	s1,8(sp)
    80002142:	6902                	ld	s2,0(sp)
    80002144:	6105                	addi	sp,sp,32
    80002146:	8082                	ret

0000000080002148 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002150:	fec40593          	addi	a1,s0,-20
    80002154:	4501                	li	a0,0
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	f0e080e7          	jalr	-242(ra) # 80002064 <argint>
  exit(n);
    8000215e:	fec42503          	lw	a0,-20(s0)
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	5c4080e7          	jalr	1476(ra) # 80001726 <exit>
  return 0;  // not reached
}
    8000216a:	4501                	li	a0,0
    8000216c:	60e2                	ld	ra,24(sp)
    8000216e:	6442                	ld	s0,16(sp)
    80002170:	6105                	addi	sp,sp,32
    80002172:	8082                	ret

0000000080002174 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002174:	1141                	addi	sp,sp,-16
    80002176:	e406                	sd	ra,8(sp)
    80002178:	e022                	sd	s0,0(sp)
    8000217a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	dce080e7          	jalr	-562(ra) # 80000f4a <myproc>
}
    80002184:	5d08                	lw	a0,56(a0)
    80002186:	60a2                	ld	ra,8(sp)
    80002188:	6402                	ld	s0,0(sp)
    8000218a:	0141                	addi	sp,sp,16
    8000218c:	8082                	ret

000000008000218e <sys_fork>:

uint64
sys_fork(void)
{
    8000218e:	1141                	addi	sp,sp,-16
    80002190:	e406                	sd	ra,8(sp)
    80002192:	e022                	sd	s0,0(sp)
    80002194:	0800                	addi	s0,sp,16
  return fork();
    80002196:	fffff097          	auipc	ra,0xfffff
    8000219a:	16a080e7          	jalr	362(ra) # 80001300 <fork>
}
    8000219e:	60a2                	ld	ra,8(sp)
    800021a0:	6402                	ld	s0,0(sp)
    800021a2:	0141                	addi	sp,sp,16
    800021a4:	8082                	ret

00000000800021a6 <sys_wait>:

uint64
sys_wait(void)
{
    800021a6:	1101                	addi	sp,sp,-32
    800021a8:	ec06                	sd	ra,24(sp)
    800021aa:	e822                	sd	s0,16(sp)
    800021ac:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021ae:	fe840593          	addi	a1,s0,-24
    800021b2:	4501                	li	a0,0
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	ed0080e7          	jalr	-304(ra) # 80002084 <argaddr>
  return wait(p);
    800021bc:	fe843503          	ld	a0,-24(s0)
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	70c080e7          	jalr	1804(ra) # 800018cc <wait>
}
    800021c8:	60e2                	ld	ra,24(sp)
    800021ca:	6442                	ld	s0,16(sp)
    800021cc:	6105                	addi	sp,sp,32
    800021ce:	8082                	ret

00000000800021d0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021d0:	7179                	addi	sp,sp,-48
    800021d2:	f406                	sd	ra,40(sp)
    800021d4:	f022                	sd	s0,32(sp)
    800021d6:	ec26                	sd	s1,24(sp)
    800021d8:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021da:	fdc40593          	addi	a1,s0,-36
    800021de:	4501                	li	a0,0
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	e84080e7          	jalr	-380(ra) # 80002064 <argint>
  addr = myproc()->sz;
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	d62080e7          	jalr	-670(ra) # 80000f4a <myproc>
    800021f0:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    800021f2:	fdc42503          	lw	a0,-36(s0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	0ae080e7          	jalr	174(ra) # 800012a4 <growproc>
    800021fe:	00054863          	bltz	a0,8000220e <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002202:	8526                	mv	a0,s1
    80002204:	70a2                	ld	ra,40(sp)
    80002206:	7402                	ld	s0,32(sp)
    80002208:	64e2                	ld	s1,24(sp)
    8000220a:	6145                	addi	sp,sp,48
    8000220c:	8082                	ret
    return -1;
    8000220e:	54fd                	li	s1,-1
    80002210:	bfcd                	j	80002202 <sys_sbrk+0x32>

0000000080002212 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002212:	7139                	addi	sp,sp,-64
    80002214:	fc06                	sd	ra,56(sp)
    80002216:	f822                	sd	s0,48(sp)
    80002218:	f426                	sd	s1,40(sp)
    8000221a:	f04a                	sd	s2,32(sp)
    8000221c:	ec4e                	sd	s3,24(sp)
    8000221e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002220:	fcc40593          	addi	a1,s0,-52
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	e3e080e7          	jalr	-450(ra) # 80002064 <argint>
  if(n < 0)
    8000222e:	fcc42783          	lw	a5,-52(s0)
    80002232:	0607cf63          	bltz	a5,800022b0 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002236:	0000d517          	auipc	a0,0xd
    8000223a:	8da50513          	addi	a0,a0,-1830 # 8000eb10 <tickslock>
    8000223e:	00004097          	auipc	ra,0x4
    80002242:	446080e7          	jalr	1094(ra) # 80006684 <acquire>
  ticks0 = ticks;
    80002246:	00006917          	auipc	s2,0x6
    8000224a:	73292903          	lw	s2,1842(s2) # 80008978 <ticks>
  while(ticks - ticks0 < n){
    8000224e:	fcc42783          	lw	a5,-52(s0)
    80002252:	cf9d                	beqz	a5,80002290 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002254:	0000d997          	auipc	s3,0xd
    80002258:	8bc98993          	addi	s3,s3,-1860 # 8000eb10 <tickslock>
    8000225c:	00006497          	auipc	s1,0x6
    80002260:	71c48493          	addi	s1,s1,1820 # 80008978 <ticks>
    if(killed(myproc())){
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	ce6080e7          	jalr	-794(ra) # 80000f4a <myproc>
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	62e080e7          	jalr	1582(ra) # 8000189a <killed>
    80002274:	e129                	bnez	a0,800022b6 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002276:	85ce                	mv	a1,s3
    80002278:	8526                	mv	a0,s1
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	378080e7          	jalr	888(ra) # 800015f2 <sleep>
  while(ticks - ticks0 < n){
    80002282:	409c                	lw	a5,0(s1)
    80002284:	412787bb          	subw	a5,a5,s2
    80002288:	fcc42703          	lw	a4,-52(s0)
    8000228c:	fce7ece3          	bltu	a5,a4,80002264 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002290:	0000d517          	auipc	a0,0xd
    80002294:	88050513          	addi	a0,a0,-1920 # 8000eb10 <tickslock>
    80002298:	00004097          	auipc	ra,0x4
    8000229c:	4bc080e7          	jalr	1212(ra) # 80006754 <release>
  return 0;
    800022a0:	4501                	li	a0,0
}
    800022a2:	70e2                	ld	ra,56(sp)
    800022a4:	7442                	ld	s0,48(sp)
    800022a6:	74a2                	ld	s1,40(sp)
    800022a8:	7902                	ld	s2,32(sp)
    800022aa:	69e2                	ld	s3,24(sp)
    800022ac:	6121                	addi	sp,sp,64
    800022ae:	8082                	ret
    n = 0;
    800022b0:	fc042623          	sw	zero,-52(s0)
    800022b4:	b749                	j	80002236 <sys_sleep+0x24>
      release(&tickslock);
    800022b6:	0000d517          	auipc	a0,0xd
    800022ba:	85a50513          	addi	a0,a0,-1958 # 8000eb10 <tickslock>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	496080e7          	jalr	1174(ra) # 80006754 <release>
      return -1;
    800022c6:	557d                	li	a0,-1
    800022c8:	bfe9                	j	800022a2 <sys_sleep+0x90>

00000000800022ca <sys_kill>:

uint64
sys_kill(void)
{
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022d2:	fec40593          	addi	a1,s0,-20
    800022d6:	4501                	li	a0,0
    800022d8:	00000097          	auipc	ra,0x0
    800022dc:	d8c080e7          	jalr	-628(ra) # 80002064 <argint>
  return kill(pid);
    800022e0:	fec42503          	lw	a0,-20(s0)
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	518080e7          	jalr	1304(ra) # 800017fc <kill>
}
    800022ec:	60e2                	ld	ra,24(sp)
    800022ee:	6442                	ld	s0,16(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022f4:	1101                	addi	sp,sp,-32
    800022f6:	ec06                	sd	ra,24(sp)
    800022f8:	e822                	sd	s0,16(sp)
    800022fa:	e426                	sd	s1,8(sp)
    800022fc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022fe:	0000d517          	auipc	a0,0xd
    80002302:	81250513          	addi	a0,a0,-2030 # 8000eb10 <tickslock>
    80002306:	00004097          	auipc	ra,0x4
    8000230a:	37e080e7          	jalr	894(ra) # 80006684 <acquire>
  xticks = ticks;
    8000230e:	00006497          	auipc	s1,0x6
    80002312:	66a4a483          	lw	s1,1642(s1) # 80008978 <ticks>
  release(&tickslock);
    80002316:	0000c517          	auipc	a0,0xc
    8000231a:	7fa50513          	addi	a0,a0,2042 # 8000eb10 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	436080e7          	jalr	1078(ra) # 80006754 <release>
  return xticks;
}
    80002326:	02049513          	slli	a0,s1,0x20
    8000232a:	9101                	srli	a0,a0,0x20
    8000232c:	60e2                	ld	ra,24(sp)
    8000232e:	6442                	ld	s0,16(sp)
    80002330:	64a2                	ld	s1,8(sp)
    80002332:	6105                	addi	sp,sp,32
    80002334:	8082                	ret

0000000080002336 <binit>:



void
binit(void) 
{
    80002336:	7139                	addi	sp,sp,-64
    80002338:	fc06                	sd	ra,56(sp)
    8000233a:	f822                	sd	s0,48(sp)
    8000233c:	f426                	sd	s1,40(sp)
    8000233e:	f04a                	sd	s2,32(sp)
    80002340:	ec4e                	sd	s3,24(sp)
    80002342:	e852                	sd	s4,16(sp)
    80002344:	e456                	sd	s5,8(sp)
    80002346:	0080                	addi	s0,sp,64
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002348:	00006597          	auipc	a1,0x6
    8000234c:	13858593          	addi	a1,a1,312 # 80008480 <syscalls+0xb0>
    80002350:	0000c517          	auipc	a0,0xc
    80002354:	7e050513          	addi	a0,a0,2016 # 8000eb30 <bcache>
    80002358:	00004097          	auipc	ra,0x4
    8000235c:	4a8080e7          	jalr	1192(ra) # 80006800 <initlock>

  // Create hash backets of buffers
  for(int i = 0; i < NBKT; ++i){
    80002360:	00015917          	auipc	s2,0x15
    80002364:	c2090913          	addi	s2,s2,-992 # 80016f80 <bcache+0x8450>
    80002368:	00015497          	auipc	s1,0x15
    8000236c:	db848493          	addi	s1,s1,-584 # 80017120 <bcache+0x85f0>
    80002370:	00018a17          	auipc	s4,0x18
    80002374:	6f8a0a13          	addi	s4,s4,1784 # 8001aa68 <sb>
    initlock(&bcache.headlock[i], "bcache");
    80002378:	00006997          	auipc	s3,0x6
    8000237c:	10898993          	addi	s3,s3,264 # 80008480 <syscalls+0xb0>
    80002380:	85ce                	mv	a1,s3
    80002382:	854a                	mv	a0,s2
    80002384:	00004097          	auipc	ra,0x4
    80002388:	47c080e7          	jalr	1148(ra) # 80006800 <initlock>
    bcache.head[i].next = &bcache.head[i];
    8000238c:	eca4                	sd	s1,88(s1)
    bcache.head[i].prev = &bcache.head[i];
    8000238e:	e8a4                	sd	s1,80(s1)
  for(int i = 0; i < NBKT; ++i){
    80002390:	02090913          	addi	s2,s2,32
    80002394:	46848493          	addi	s1,s1,1128
    80002398:	ff4494e3          	bne	s1,s4,80002380 <binit+0x4a>
  }
  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf + NBUF; b++){
    8000239c:	0000c497          	auipc	s1,0xc
    800023a0:	7b448493          	addi	s1,s1,1972 # 8000eb50 <bcache+0x20>
    b->next = bcache.head[0].next;
    800023a4:	00014917          	auipc	s2,0x14
    800023a8:	78c90913          	addi	s2,s2,1932 # 80016b30 <bcache+0x8000>
    b->prev = &bcache.head[0];
    800023ac:	00015a97          	auipc	s5,0x15
    800023b0:	d74a8a93          	addi	s5,s5,-652 # 80017120 <bcache+0x85f0>
    initsleeplock(&b->lock, "buffer");
    800023b4:	00006a17          	auipc	s4,0x6
    800023b8:	0d4a0a13          	addi	s4,s4,212 # 80008488 <syscalls+0xb8>
  for(b = bcache.buf; b < bcache.buf + NBUF; b++){
    800023bc:	00015997          	auipc	s3,0x15
    800023c0:	bc498993          	addi	s3,s3,-1084 # 80016f80 <bcache+0x8450>
    b->next = bcache.head[0].next;
    800023c4:	64893783          	ld	a5,1608(s2)
    800023c8:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head[0];
    800023ca:	0554b823          	sd	s5,80(s1)
    initsleeplock(&b->lock, "buffer");
    800023ce:	85d2                	mv	a1,s4
    800023d0:	01048513          	addi	a0,s1,16
    800023d4:	00001097          	auipc	ra,0x1
    800023d8:	64a080e7          	jalr	1610(ra) # 80003a1e <initsleeplock>
    bcache.head[0].next->prev = b;
    800023dc:	64893783          	ld	a5,1608(s2)
    800023e0:	eba4                	sd	s1,80(a5)
    bcache.head[0].next = b;
    800023e2:	64993423          	sd	s1,1608(s2)
  for(b = bcache.buf; b < bcache.buf + NBUF; b++){
    800023e6:	46848493          	addi	s1,s1,1128
    800023ea:	fd349de3          	bne	s1,s3,800023c4 <binit+0x8e>
  }

  
}
    800023ee:	70e2                	ld	ra,56(sp)
    800023f0:	7442                	ld	s0,48(sp)
    800023f2:	74a2                	ld	s1,40(sp)
    800023f4:	7902                	ld	s2,32(sp)
    800023f6:	69e2                	ld	s3,24(sp)
    800023f8:	6a42                	ld	s4,16(sp)
    800023fa:	6aa2                	ld	s5,8(sp)
    800023fc:	6121                	addi	sp,sp,64
    800023fe:	8082                	ret

0000000080002400 <bread>:


// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002400:	7119                	addi	sp,sp,-128
    80002402:	fc86                	sd	ra,120(sp)
    80002404:	f8a2                	sd	s0,112(sp)
    80002406:	f4a6                	sd	s1,104(sp)
    80002408:	f0ca                	sd	s2,96(sp)
    8000240a:	ecce                	sd	s3,88(sp)
    8000240c:	e8d2                	sd	s4,80(sp)
    8000240e:	e4d6                	sd	s5,72(sp)
    80002410:	e0da                	sd	s6,64(sp)
    80002412:	fc5e                	sd	s7,56(sp)
    80002414:	f862                	sd	s8,48(sp)
    80002416:	f466                	sd	s9,40(sp)
    80002418:	f06a                	sd	s10,32(sp)
    8000241a:	ec6e                	sd	s11,24(sp)
    8000241c:	0100                	addi	s0,sp,128
    8000241e:	89aa                	mv	s3,a0
    80002420:	8c2e                	mv	s8,a1
  int id = HASH(blockno); //index of hash backets
    80002422:	4cb5                	li	s9,13
    80002424:	0395fcbb          	remuw	s9,a1,s9
  acquire(&bcache.headlock[id]);  //TODO
    80002428:	005c9d13          	slli	s10,s9,0x5
    8000242c:	6a21                	lui	s4,0x8
    8000242e:	450a0793          	addi	a5,s4,1104 # 8450 <_entry-0x7fff7bb0>
    80002432:	9d3e                	add	s10,s10,a5
    80002434:	0000ca97          	auipc	s5,0xc
    80002438:	6fca8a93          	addi	s5,s5,1788 # 8000eb30 <bcache>
    8000243c:	9d56                	add	s10,s10,s5
    8000243e:	856a                	mv	a0,s10
    80002440:	00004097          	auipc	ra,0x4
    80002444:	244080e7          	jalr	580(ra) # 80006684 <acquire>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    80002448:	46800913          	li	s2,1128
    8000244c:	032c8933          	mul	s2,s9,s2
    80002450:	012a87b3          	add	a5,s5,s2
    80002454:	97d2                	add	a5,a5,s4
    80002456:	6487b483          	ld	s1,1608(a5)
    8000245a:	5f0a0a13          	addi	s4,s4,1520
    8000245e:	9952                	add	s2,s2,s4
    80002460:	9956                	add	s2,s2,s5
    80002462:	05249863          	bne	s1,s2,800024b2 <bread+0xb2>
  release(&bcache.headlock[id]);
    80002466:	856a                	mv	a0,s10
    80002468:	00004097          	auipc	ra,0x4
    8000246c:	2ec080e7          	jalr	748(ra) # 80006754 <release>
  acquire(&bcache.lock);
    80002470:	0000c517          	auipc	a0,0xc
    80002474:	6c050513          	addi	a0,a0,1728 # 8000eb30 <bcache>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	20c080e7          	jalr	524(ra) # 80006684 <acquire>
  acquire(&bcache.headlock[id]);  
    80002480:	856a                	mv	a0,s10
    80002482:	00004097          	auipc	ra,0x4
    80002486:	202080e7          	jalr	514(ra) # 80006684 <acquire>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){  
    8000248a:	46800793          	li	a5,1128
    8000248e:	02fc87b3          	mul	a5,s9,a5
    80002492:	0000c717          	auipc	a4,0xc
    80002496:	69e70713          	addi	a4,a4,1694 # 8000eb30 <bcache>
    8000249a:	973e                	add	a4,a4,a5
    8000249c:	67a1                	lui	a5,0x8
    8000249e:	97ba                	add	a5,a5,a4
    800024a0:	6487b703          	ld	a4,1608(a5) # 8648 <_entry-0x7fff79b8>
    800024a4:	0b270163          	beq	a4,s2,80002546 <bread+0x146>
    800024a8:	84ba                	mv	s1,a4
    800024aa:	a8b1                	j	80002506 <bread+0x106>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    800024ac:	6ca4                	ld	s1,88(s1)
    800024ae:	fb248ce3          	beq	s1,s2,80002466 <bread+0x66>
    if(b->dev == dev && b->blockno == blockno){
    800024b2:	449c                	lw	a5,8(s1)
    800024b4:	ff379ce3          	bne	a5,s3,800024ac <bread+0xac>
    800024b8:	44dc                	lw	a5,12(s1)
    800024ba:	ff8799e3          	bne	a5,s8,800024ac <bread+0xac>
      b->refcnt++;
    800024be:	44bc                	lw	a5,72(s1)
    800024c0:	2785                	addiw	a5,a5,1
    800024c2:	c4bc                	sw	a5,72(s1)
      release(&bcache.headlock[id]);
    800024c4:	856a                	mv	a0,s10
    800024c6:	00004097          	auipc	ra,0x4
    800024ca:	28e080e7          	jalr	654(ra) # 80006754 <release>
      acquiresleep(&b->lock);
    800024ce:	01048513          	addi	a0,s1,16
    800024d2:	00001097          	auipc	ra,0x1
    800024d6:	586080e7          	jalr	1414(ra) # 80003a58 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024da:	409c                	lw	a5,0(s1)
    800024dc:	16078e63          	beqz	a5,80002658 <bread+0x258>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024e0:	8526                	mv	a0,s1
    800024e2:	70e6                	ld	ra,120(sp)
    800024e4:	7446                	ld	s0,112(sp)
    800024e6:	74a6                	ld	s1,104(sp)
    800024e8:	7906                	ld	s2,96(sp)
    800024ea:	69e6                	ld	s3,88(sp)
    800024ec:	6a46                	ld	s4,80(sp)
    800024ee:	6aa6                	ld	s5,72(sp)
    800024f0:	6b06                	ld	s6,64(sp)
    800024f2:	7be2                	ld	s7,56(sp)
    800024f4:	7c42                	ld	s8,48(sp)
    800024f6:	7ca2                	ld	s9,40(sp)
    800024f8:	7d02                	ld	s10,32(sp)
    800024fa:	6de2                	ld	s11,24(sp)
    800024fc:	6109                	addi	sp,sp,128
    800024fe:	8082                	ret
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){  
    80002500:	6ca4                	ld	s1,88(s1)
    80002502:	03248f63          	beq	s1,s2,80002540 <bread+0x140>
    if(b->dev == dev && b->blockno == blockno){
    80002506:	449c                	lw	a5,8(s1)
    80002508:	ff379ce3          	bne	a5,s3,80002500 <bread+0x100>
    8000250c:	44dc                	lw	a5,12(s1)
    8000250e:	ff8799e3          	bne	a5,s8,80002500 <bread+0x100>
      b->refcnt++;
    80002512:	44bc                	lw	a5,72(s1)
    80002514:	2785                	addiw	a5,a5,1
    80002516:	c4bc                	sw	a5,72(s1)
      release(&bcache.headlock[id]);
    80002518:	856a                	mv	a0,s10
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	23a080e7          	jalr	570(ra) # 80006754 <release>
      release(&bcache.lock);
    80002522:	0000c517          	auipc	a0,0xc
    80002526:	60e50513          	addi	a0,a0,1550 # 8000eb30 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	22a080e7          	jalr	554(ra) # 80006754 <release>
      acquiresleep(&b->lock);
    80002532:	01048513          	addi	a0,s1,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	522080e7          	jalr	1314(ra) # 80003a58 <acquiresleep>
      return b;
    8000253e:	bf71                	j	800024da <bread+0xda>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){
    80002540:	6f38                	ld	a4,88(a4)
    80002542:	ff271fe3          	bne	a4,s2,80002540 <bread+0x140>
    80002546:	00015b17          	auipc	s6,0x15
    8000254a:	a3ab0b13          	addi	s6,s6,-1478 # 80016f80 <bcache+0x8450>
    8000254e:	00015a97          	auipc	s5,0x15
    80002552:	bd2a8a93          	addi	s5,s5,-1070 # 80017120 <bcache+0x85f0>
  for(b = bcache.head[id].next; b != &bcache.head[id]; b = b->next){  
    80002556:	4b81                	li	s7,0
    80002558:	4a01                	li	s4,0
  for(int j = 0; j < NBKT; j++){
    8000255a:	4db5                	li	s11,13
    8000255c:	a081                	j	8000259c <bread+0x19c>
        min_ticks = b->lastuse;
    8000255e:	4607ab83          	lw	s7,1120(a5)
    80002562:	84be                	mv	s1,a5
    for(b = bcache.head[j].next; b != &bcache.head[j]; b = b->next){
    80002564:	6fbc                	ld	a5,88(a5)
    80002566:	04d78b63          	beq	a5,a3,800025bc <bread+0x1bc>
      if((b->refcnt == 0) && ((b2 == 0) || (b->lastuse < min_ticks))){
    8000256a:	47b8                	lw	a4,72(a5)
    8000256c:	e719                	bnez	a4,8000257a <bread+0x17a>
    8000256e:	d8e5                	beqz	s1,8000255e <bread+0x15e>
    80002570:	4607a703          	lw	a4,1120(a5)
    80002574:	ff7778e3          	bgeu	a4,s7,80002564 <bread+0x164>
    80002578:	b7dd                	j	8000255e <bread+0x15e>
    for(b = bcache.head[j].next; b != &bcache.head[j]; b = b->next){
    8000257a:	6fbc                	ld	a5,88(a5)
    8000257c:	fed797e3          	bne	a5,a3,8000256a <bread+0x16a>
    if(b2){ 
    80002580:	ec95                	bnez	s1,800025bc <bread+0x1bc>
    release(&bcache.headlock[j]);
    80002582:	f8843503          	ld	a0,-120(s0)
    80002586:	00004097          	auipc	ra,0x4
    8000258a:	1ce080e7          	jalr	462(ra) # 80006754 <release>
  for(int j = 0; j < NBKT; j++){
    8000258e:	2a05                	addiw	s4,s4,1
    80002590:	020b0b13          	addi	s6,s6,32
    80002594:	468a8a93          	addi	s5,s5,1128
    80002598:	09ba0b63          	beq	s4,s11,8000262e <bread+0x22e>
    if(j == id){
    8000259c:	ff4c89e3          	beq	s9,s4,8000258e <bread+0x18e>
    acquire(&bcache.headlock[j]);
    800025a0:	f9643423          	sd	s6,-120(s0)
    800025a4:	855a                	mv	a0,s6
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	0de080e7          	jalr	222(ra) # 80006684 <acquire>
    for(b = bcache.head[j].next; b != &bcache.head[j]; b = b->next){
    800025ae:	86d6                	mv	a3,s5
    800025b0:	058ab783          	ld	a5,88(s5)
    800025b4:	fd5787e3          	beq	a5,s5,80002582 <bread+0x182>
    800025b8:	4481                	li	s1,0
    800025ba:	bf45                	j	8000256a <bread+0x16a>
      b2->dev = dev;
    800025bc:	0134a423          	sw	s3,8(s1)
      b2->blockno = blockno;
    800025c0:	0184a623          	sw	s8,12(s1)
      b2->valid = 0;
    800025c4:	0004a023          	sw	zero,0(s1)
      b2->refcnt = 1;
    800025c8:	4785                	li	a5,1
    800025ca:	c4bc                	sw	a5,72(s1)
      b2->next->prev = b2->prev;
    800025cc:	6cb8                	ld	a4,88(s1)
    800025ce:	68bc                	ld	a5,80(s1)
    800025d0:	eb3c                	sd	a5,80(a4)
      b2->prev->next = b2->next;
    800025d2:	6cb8                	ld	a4,88(s1)
    800025d4:	efb8                	sd	a4,88(a5)
      release(&bcache.headlock[j]);   // 上面两句已经切断了head[j]中b2的前后依赖,
    800025d6:	f8843503          	ld	a0,-120(s0)
    800025da:	00004097          	auipc	ra,0x4
    800025de:	17a080e7          	jalr	378(ra) # 80006754 <release>
      b2->next = bcache.head[id].next;
    800025e2:	0000c997          	auipc	s3,0xc
    800025e6:	54e98993          	addi	s3,s3,1358 # 8000eb30 <bcache>
    800025ea:	46800713          	li	a4,1128
    800025ee:	02ec8733          	mul	a4,s9,a4
    800025f2:	974e                	add	a4,a4,s3
    800025f4:	67a1                	lui	a5,0x8
    800025f6:	97ba                	add	a5,a5,a4
    800025f8:	6487b703          	ld	a4,1608(a5) # 8648 <_entry-0x7fff79b8>
    800025fc:	ecb8                	sd	a4,88(s1)
      b2->prev = &bcache.head[id];
    800025fe:	0524b823          	sd	s2,80(s1)
      bcache.head[id].next->prev = b2;
    80002602:	6487b703          	ld	a4,1608(a5)
    80002606:	eb24                	sd	s1,80(a4)
      bcache.head[id].next = b2;
    80002608:	6497b423          	sd	s1,1608(a5)
      release(&bcache.headlock[id]);
    8000260c:	856a                	mv	a0,s10
    8000260e:	00004097          	auipc	ra,0x4
    80002612:	146080e7          	jalr	326(ra) # 80006754 <release>
      release(&bcache.lock);
    80002616:	854e                	mv	a0,s3
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	13c080e7          	jalr	316(ra) # 80006754 <release>
      acquiresleep(&b2->lock);
    80002620:	01048513          	addi	a0,s1,16
    80002624:	00001097          	auipc	ra,0x1
    80002628:	434080e7          	jalr	1076(ra) # 80003a58 <acquiresleep>
      return b2;
    8000262c:	b57d                	j	800024da <bread+0xda>
  release(&bcache.headlock[id]);
    8000262e:	856a                	mv	a0,s10
    80002630:	00004097          	auipc	ra,0x4
    80002634:	124080e7          	jalr	292(ra) # 80006754 <release>
  release(&bcache.lock);
    80002638:	0000c517          	auipc	a0,0xc
    8000263c:	4f850513          	addi	a0,a0,1272 # 8000eb30 <bcache>
    80002640:	00004097          	auipc	ra,0x4
    80002644:	114080e7          	jalr	276(ra) # 80006754 <release>
  panic("bget: no buffers");
    80002648:	00006517          	auipc	a0,0x6
    8000264c:	e4850513          	addi	a0,a0,-440 # 80008490 <syscalls+0xc0>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	b12080e7          	jalr	-1262(ra) # 80006162 <panic>
    virtio_disk_rw(b, 0);
    80002658:	4581                	li	a1,0
    8000265a:	8526                	mv	a0,s1
    8000265c:	00003097          	auipc	ra,0x3
    80002660:	fc6080e7          	jalr	-58(ra) # 80005622 <virtio_disk_rw>
    b->valid = 1;
    80002664:	4785                	li	a5,1
    80002666:	c09c                	sw	a5,0(s1)
  return b;
    80002668:	bda5                	j	800024e0 <bread+0xe0>

000000008000266a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000266a:	1101                	addi	sp,sp,-32
    8000266c:	ec06                	sd	ra,24(sp)
    8000266e:	e822                	sd	s0,16(sp)
    80002670:	e426                	sd	s1,8(sp)
    80002672:	1000                	addi	s0,sp,32
    80002674:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002676:	0541                	addi	a0,a0,16
    80002678:	00001097          	auipc	ra,0x1
    8000267c:	47a080e7          	jalr	1146(ra) # 80003af2 <holdingsleep>
    80002680:	cd01                	beqz	a0,80002698 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002682:	4585                	li	a1,1
    80002684:	8526                	mv	a0,s1
    80002686:	00003097          	auipc	ra,0x3
    8000268a:	f9c080e7          	jalr	-100(ra) # 80005622 <virtio_disk_rw>
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6105                	addi	sp,sp,32
    80002696:	8082                	ret
    panic("bwrite");
    80002698:	00006517          	auipc	a0,0x6
    8000269c:	e1050513          	addi	a0,a0,-496 # 800084a8 <syscalls+0xd8>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	ac2080e7          	jalr	-1342(ra) # 80006162 <panic>

00000000800026a8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	e04a                	sd	s2,0(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	892a                	mv	s2,a0
  if(!holdingsleep(&b->lock))
    800026b6:	01050493          	addi	s1,a0,16
    800026ba:	8526                	mv	a0,s1
    800026bc:	00001097          	auipc	ra,0x1
    800026c0:	436080e7          	jalr	1078(ra) # 80003af2 <holdingsleep>
    800026c4:	c13d                	beqz	a0,8000272a <brelse+0x82>
    panic("brelse");

  releasesleep(&b->lock);
    800026c6:	8526                	mv	a0,s1
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	3e6080e7          	jalr	998(ra) # 80003aae <releasesleep>

  int id = HASH(b->blockno);
    800026d0:	00c92483          	lw	s1,12(s2)
  acquire(&bcache.headlock[id]);
    800026d4:	47b5                	li	a5,13
    800026d6:	02f4f4bb          	remuw	s1,s1,a5
    800026da:	0496                	slli	s1,s1,0x5
    800026dc:	67a1                	lui	a5,0x8
    800026de:	45078793          	addi	a5,a5,1104 # 8450 <_entry-0x7fff7bb0>
    800026e2:	94be                	add	s1,s1,a5
    800026e4:	0000c797          	auipc	a5,0xc
    800026e8:	44c78793          	addi	a5,a5,1100 # 8000eb30 <bcache>
    800026ec:	94be                	add	s1,s1,a5
    800026ee:	8526                	mv	a0,s1
    800026f0:	00004097          	auipc	ra,0x4
    800026f4:	f94080e7          	jalr	-108(ra) # 80006684 <acquire>
  b->refcnt--;
    800026f8:	04892783          	lw	a5,72(s2)
    800026fc:	37fd                	addiw	a5,a5,-1
    800026fe:	0007871b          	sext.w	a4,a5
    80002702:	04f92423          	sw	a5,72(s2)
  if (b->refcnt == 0) {
    80002706:	e719                	bnez	a4,80002714 <brelse+0x6c>
    // no one is waiting for it.
    b->lastuse = ticks;
    80002708:	00006797          	auipc	a5,0x6
    8000270c:	2707a783          	lw	a5,624(a5) # 80008978 <ticks>
    80002710:	46f92023          	sw	a5,1120(s2)
  }
  release(&bcache.headlock[id]);
    80002714:	8526                	mv	a0,s1
    80002716:	00004097          	auipc	ra,0x4
    8000271a:	03e080e7          	jalr	62(ra) # 80006754 <release>
}
    8000271e:	60e2                	ld	ra,24(sp)
    80002720:	6442                	ld	s0,16(sp)
    80002722:	64a2                	ld	s1,8(sp)
    80002724:	6902                	ld	s2,0(sp)
    80002726:	6105                	addi	sp,sp,32
    80002728:	8082                	ret
    panic("brelse");
    8000272a:	00006517          	auipc	a0,0x6
    8000272e:	d8650513          	addi	a0,a0,-634 # 800084b0 <syscalls+0xe0>
    80002732:	00004097          	auipc	ra,0x4
    80002736:	a30080e7          	jalr	-1488(ra) # 80006162 <panic>

000000008000273a <bpin>:

void
bpin(struct buf *b) {
    8000273a:	1101                	addi	sp,sp,-32
    8000273c:	ec06                	sd	ra,24(sp)
    8000273e:	e822                	sd	s0,16(sp)
    80002740:	e426                	sd	s1,8(sp)
    80002742:	e04a                	sd	s2,0(sp)
    80002744:	1000                	addi	s0,sp,32
    80002746:	892a                	mv	s2,a0
  int id = HASH(b->blockno);;
    80002748:	4544                	lw	s1,12(a0)
  acquire(&bcache.headlock[id]);
    8000274a:	47b5                	li	a5,13
    8000274c:	02f4f4bb          	remuw	s1,s1,a5
    80002750:	0496                	slli	s1,s1,0x5
    80002752:	67a1                	lui	a5,0x8
    80002754:	45078793          	addi	a5,a5,1104 # 8450 <_entry-0x7fff7bb0>
    80002758:	94be                	add	s1,s1,a5
    8000275a:	0000c797          	auipc	a5,0xc
    8000275e:	3d678793          	addi	a5,a5,982 # 8000eb30 <bcache>
    80002762:	94be                	add	s1,s1,a5
    80002764:	8526                	mv	a0,s1
    80002766:	00004097          	auipc	ra,0x4
    8000276a:	f1e080e7          	jalr	-226(ra) # 80006684 <acquire>
  b->refcnt++;
    8000276e:	04892783          	lw	a5,72(s2)
    80002772:	2785                	addiw	a5,a5,1
    80002774:	04f92423          	sw	a5,72(s2)
  release(&bcache.headlock[id]);
    80002778:	8526                	mv	a0,s1
    8000277a:	00004097          	auipc	ra,0x4
    8000277e:	fda080e7          	jalr	-38(ra) # 80006754 <release>
}
    80002782:	60e2                	ld	ra,24(sp)
    80002784:	6442                	ld	s0,16(sp)
    80002786:	64a2                	ld	s1,8(sp)
    80002788:	6902                	ld	s2,0(sp)
    8000278a:	6105                	addi	sp,sp,32
    8000278c:	8082                	ret

000000008000278e <bunpin>:

void
bunpin(struct buf *b) {
    8000278e:	1101                	addi	sp,sp,-32
    80002790:	ec06                	sd	ra,24(sp)
    80002792:	e822                	sd	s0,16(sp)
    80002794:	e426                	sd	s1,8(sp)
    80002796:	e04a                	sd	s2,0(sp)
    80002798:	1000                	addi	s0,sp,32
    8000279a:	892a                	mv	s2,a0
  int id = HASH(b->blockno);;
    8000279c:	4544                	lw	s1,12(a0)
  acquire(&bcache.headlock[id]);
    8000279e:	47b5                	li	a5,13
    800027a0:	02f4f4bb          	remuw	s1,s1,a5
    800027a4:	0496                	slli	s1,s1,0x5
    800027a6:	67a1                	lui	a5,0x8
    800027a8:	45078793          	addi	a5,a5,1104 # 8450 <_entry-0x7fff7bb0>
    800027ac:	94be                	add	s1,s1,a5
    800027ae:	0000c797          	auipc	a5,0xc
    800027b2:	38278793          	addi	a5,a5,898 # 8000eb30 <bcache>
    800027b6:	94be                	add	s1,s1,a5
    800027b8:	8526                	mv	a0,s1
    800027ba:	00004097          	auipc	ra,0x4
    800027be:	eca080e7          	jalr	-310(ra) # 80006684 <acquire>
  b->refcnt--;
    800027c2:	04892783          	lw	a5,72(s2)
    800027c6:	37fd                	addiw	a5,a5,-1
    800027c8:	04f92423          	sw	a5,72(s2)
  release(&bcache.headlock[id]);
    800027cc:	8526                	mv	a0,s1
    800027ce:	00004097          	auipc	ra,0x4
    800027d2:	f86080e7          	jalr	-122(ra) # 80006754 <release>
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6902                	ld	s2,0(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	e04a                	sd	s2,0(sp)
    800027ec:	1000                	addi	s0,sp,32
    800027ee:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027f0:	00d5d59b          	srliw	a1,a1,0xd
    800027f4:	00018797          	auipc	a5,0x18
    800027f8:	2907a783          	lw	a5,656(a5) # 8001aa84 <sb+0x1c>
    800027fc:	9dbd                	addw	a1,a1,a5
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	c02080e7          	jalr	-1022(ra) # 80002400 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002806:	0074f713          	andi	a4,s1,7
    8000280a:	4785                	li	a5,1
    8000280c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002810:	14ce                	slli	s1,s1,0x33
    80002812:	90d9                	srli	s1,s1,0x36
    80002814:	00950733          	add	a4,a0,s1
    80002818:	06074703          	lbu	a4,96(a4)
    8000281c:	00e7f6b3          	and	a3,a5,a4
    80002820:	c69d                	beqz	a3,8000284e <bfree+0x6c>
    80002822:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002824:	94aa                	add	s1,s1,a0
    80002826:	fff7c793          	not	a5,a5
    8000282a:	8f7d                	and	a4,a4,a5
    8000282c:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    80002830:	00001097          	auipc	ra,0x1
    80002834:	10a080e7          	jalr	266(ra) # 8000393a <log_write>
  brelse(bp);
    80002838:	854a                	mv	a0,s2
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e6e080e7          	jalr	-402(ra) # 800026a8 <brelse>
}
    80002842:	60e2                	ld	ra,24(sp)
    80002844:	6442                	ld	s0,16(sp)
    80002846:	64a2                	ld	s1,8(sp)
    80002848:	6902                	ld	s2,0(sp)
    8000284a:	6105                	addi	sp,sp,32
    8000284c:	8082                	ret
    panic("freeing free block");
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	c6a50513          	addi	a0,a0,-918 # 800084b8 <syscalls+0xe8>
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	90c080e7          	jalr	-1780(ra) # 80006162 <panic>

000000008000285e <balloc>:
{
    8000285e:	711d                	addi	sp,sp,-96
    80002860:	ec86                	sd	ra,88(sp)
    80002862:	e8a2                	sd	s0,80(sp)
    80002864:	e4a6                	sd	s1,72(sp)
    80002866:	e0ca                	sd	s2,64(sp)
    80002868:	fc4e                	sd	s3,56(sp)
    8000286a:	f852                	sd	s4,48(sp)
    8000286c:	f456                	sd	s5,40(sp)
    8000286e:	f05a                	sd	s6,32(sp)
    80002870:	ec5e                	sd	s7,24(sp)
    80002872:	e862                	sd	s8,16(sp)
    80002874:	e466                	sd	s9,8(sp)
    80002876:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002878:	00018797          	auipc	a5,0x18
    8000287c:	1f47a783          	lw	a5,500(a5) # 8001aa6c <sb+0x4>
    80002880:	cff5                	beqz	a5,8000297c <balloc+0x11e>
    80002882:	8baa                	mv	s7,a0
    80002884:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002886:	00018b17          	auipc	s6,0x18
    8000288a:	1e2b0b13          	addi	s6,s6,482 # 8001aa68 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000288e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002890:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002892:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002894:	6c89                	lui	s9,0x2
    80002896:	a061                	j	8000291e <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002898:	97ca                	add	a5,a5,s2
    8000289a:	8e55                	or	a2,a2,a3
    8000289c:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	098080e7          	jalr	152(ra) # 8000393a <log_write>
        brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	dfc080e7          	jalr	-516(ra) # 800026a8 <brelse>
  bp = bread(dev, bno);
    800028b4:	85a6                	mv	a1,s1
    800028b6:	855e                	mv	a0,s7
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	b48080e7          	jalr	-1208(ra) # 80002400 <bread>
    800028c0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028c2:	40000613          	li	a2,1024
    800028c6:	4581                	li	a1,0
    800028c8:	06050513          	addi	a0,a0,96
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	996080e7          	jalr	-1642(ra) # 80000262 <memset>
  log_write(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00001097          	auipc	ra,0x1
    800028da:	064080e7          	jalr	100(ra) # 8000393a <log_write>
  brelse(bp);
    800028de:	854a                	mv	a0,s2
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	dc8080e7          	jalr	-568(ra) # 800026a8 <brelse>
}
    800028e8:	8526                	mv	a0,s1
    800028ea:	60e6                	ld	ra,88(sp)
    800028ec:	6446                	ld	s0,80(sp)
    800028ee:	64a6                	ld	s1,72(sp)
    800028f0:	6906                	ld	s2,64(sp)
    800028f2:	79e2                	ld	s3,56(sp)
    800028f4:	7a42                	ld	s4,48(sp)
    800028f6:	7aa2                	ld	s5,40(sp)
    800028f8:	7b02                	ld	s6,32(sp)
    800028fa:	6be2                	ld	s7,24(sp)
    800028fc:	6c42                	ld	s8,16(sp)
    800028fe:	6ca2                	ld	s9,8(sp)
    80002900:	6125                	addi	sp,sp,96
    80002902:	8082                	ret
    brelse(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	da2080e7          	jalr	-606(ra) # 800026a8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000290e:	015c87bb          	addw	a5,s9,s5
    80002912:	00078a9b          	sext.w	s5,a5
    80002916:	004b2703          	lw	a4,4(s6)
    8000291a:	06eaf163          	bgeu	s5,a4,8000297c <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    8000291e:	41fad79b          	sraiw	a5,s5,0x1f
    80002922:	0137d79b          	srliw	a5,a5,0x13
    80002926:	015787bb          	addw	a5,a5,s5
    8000292a:	40d7d79b          	sraiw	a5,a5,0xd
    8000292e:	01cb2583          	lw	a1,28(s6)
    80002932:	9dbd                	addw	a1,a1,a5
    80002934:	855e                	mv	a0,s7
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	aca080e7          	jalr	-1334(ra) # 80002400 <bread>
    8000293e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002940:	004b2503          	lw	a0,4(s6)
    80002944:	000a849b          	sext.w	s1,s5
    80002948:	8762                	mv	a4,s8
    8000294a:	faa4fde3          	bgeu	s1,a0,80002904 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000294e:	00777693          	andi	a3,a4,7
    80002952:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002956:	41f7579b          	sraiw	a5,a4,0x1f
    8000295a:	01d7d79b          	srliw	a5,a5,0x1d
    8000295e:	9fb9                	addw	a5,a5,a4
    80002960:	4037d79b          	sraiw	a5,a5,0x3
    80002964:	00f90633          	add	a2,s2,a5
    80002968:	06064603          	lbu	a2,96(a2)
    8000296c:	00c6f5b3          	and	a1,a3,a2
    80002970:	d585                	beqz	a1,80002898 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002972:	2705                	addiw	a4,a4,1
    80002974:	2485                	addiw	s1,s1,1
    80002976:	fd471ae3          	bne	a4,s4,8000294a <balloc+0xec>
    8000297a:	b769                	j	80002904 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000297c:	00006517          	auipc	a0,0x6
    80002980:	b5450513          	addi	a0,a0,-1196 # 800084d0 <syscalls+0x100>
    80002984:	00004097          	auipc	ra,0x4
    80002988:	828080e7          	jalr	-2008(ra) # 800061ac <printf>
  return 0;
    8000298c:	4481                	li	s1,0
    8000298e:	bfa9                	j	800028e8 <balloc+0x8a>

0000000080002990 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002990:	7179                	addi	sp,sp,-48
    80002992:	f406                	sd	ra,40(sp)
    80002994:	f022                	sd	s0,32(sp)
    80002996:	ec26                	sd	s1,24(sp)
    80002998:	e84a                	sd	s2,16(sp)
    8000299a:	e44e                	sd	s3,8(sp)
    8000299c:	e052                	sd	s4,0(sp)
    8000299e:	1800                	addi	s0,sp,48
    800029a0:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029a2:	47ad                	li	a5,11
    800029a4:	02b7e863          	bltu	a5,a1,800029d4 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800029a8:	02059793          	slli	a5,a1,0x20
    800029ac:	01e7d593          	srli	a1,a5,0x1e
    800029b0:	00b504b3          	add	s1,a0,a1
    800029b4:	0584a903          	lw	s2,88(s1)
    800029b8:	06091e63          	bnez	s2,80002a34 <bmap+0xa4>
      addr = balloc(ip->dev);
    800029bc:	4108                	lw	a0,0(a0)
    800029be:	00000097          	auipc	ra,0x0
    800029c2:	ea0080e7          	jalr	-352(ra) # 8000285e <balloc>
    800029c6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029ca:	06090563          	beqz	s2,80002a34 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800029ce:	0524ac23          	sw	s2,88(s1)
    800029d2:	a08d                	j	80002a34 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029d4:	ff45849b          	addiw	s1,a1,-12
    800029d8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029dc:	0ff00793          	li	a5,255
    800029e0:	08e7e563          	bltu	a5,a4,80002a6a <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029e4:	08852903          	lw	s2,136(a0)
    800029e8:	00091d63          	bnez	s2,80002a02 <bmap+0x72>
      addr = balloc(ip->dev);
    800029ec:	4108                	lw	a0,0(a0)
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	e70080e7          	jalr	-400(ra) # 8000285e <balloc>
    800029f6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029fa:	02090d63          	beqz	s2,80002a34 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029fe:	0929a423          	sw	s2,136(s3)
    }
    bp = bread(ip->dev, addr);
    80002a02:	85ca                	mv	a1,s2
    80002a04:	0009a503          	lw	a0,0(s3)
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	9f8080e7          	jalr	-1544(ra) # 80002400 <bread>
    80002a10:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a12:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002a16:	02049713          	slli	a4,s1,0x20
    80002a1a:	01e75593          	srli	a1,a4,0x1e
    80002a1e:	00b784b3          	add	s1,a5,a1
    80002a22:	0004a903          	lw	s2,0(s1)
    80002a26:	02090063          	beqz	s2,80002a46 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a2a:	8552                	mv	a0,s4
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	c7c080e7          	jalr	-900(ra) # 800026a8 <brelse>
    return addr;
  }
  panic("bmap: out of range");
}
    80002a34:	854a                	mv	a0,s2
    80002a36:	70a2                	ld	ra,40(sp)
    80002a38:	7402                	ld	s0,32(sp)
    80002a3a:	64e2                	ld	s1,24(sp)
    80002a3c:	6942                	ld	s2,16(sp)
    80002a3e:	69a2                	ld	s3,8(sp)
    80002a40:	6a02                	ld	s4,0(sp)
    80002a42:	6145                	addi	sp,sp,48
    80002a44:	8082                	ret
      addr = balloc(ip->dev);
    80002a46:	0009a503          	lw	a0,0(s3)
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	e14080e7          	jalr	-492(ra) # 8000285e <balloc>
    80002a52:	0005091b          	sext.w	s2,a0
      if(addr){
    80002a56:	fc090ae3          	beqz	s2,80002a2a <bmap+0x9a>
        a[bn] = addr;
    80002a5a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a5e:	8552                	mv	a0,s4
    80002a60:	00001097          	auipc	ra,0x1
    80002a64:	eda080e7          	jalr	-294(ra) # 8000393a <log_write>
    80002a68:	b7c9                	j	80002a2a <bmap+0x9a>
  panic("bmap: out of range");
    80002a6a:	00006517          	auipc	a0,0x6
    80002a6e:	a7e50513          	addi	a0,a0,-1410 # 800084e8 <syscalls+0x118>
    80002a72:	00003097          	auipc	ra,0x3
    80002a76:	6f0080e7          	jalr	1776(ra) # 80006162 <panic>

0000000080002a7a <iget>:
{
    80002a7a:	7179                	addi	sp,sp,-48
    80002a7c:	f406                	sd	ra,40(sp)
    80002a7e:	f022                	sd	s0,32(sp)
    80002a80:	ec26                	sd	s1,24(sp)
    80002a82:	e84a                	sd	s2,16(sp)
    80002a84:	e44e                	sd	s3,8(sp)
    80002a86:	e052                	sd	s4,0(sp)
    80002a88:	1800                	addi	s0,sp,48
    80002a8a:	89aa                	mv	s3,a0
    80002a8c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a8e:	00018517          	auipc	a0,0x18
    80002a92:	ffa50513          	addi	a0,a0,-6 # 8001aa88 <itable>
    80002a96:	00004097          	auipc	ra,0x4
    80002a9a:	bee080e7          	jalr	-1042(ra) # 80006684 <acquire>
  empty = 0;
    80002a9e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aa0:	00018497          	auipc	s1,0x18
    80002aa4:	00848493          	addi	s1,s1,8 # 8001aaa8 <itable+0x20>
    80002aa8:	0001a697          	auipc	a3,0x1a
    80002aac:	c2068693          	addi	a3,a3,-992 # 8001c6c8 <log>
    80002ab0:	a039                	j	80002abe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ab2:	02090b63          	beqz	s2,80002ae8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ab6:	09048493          	addi	s1,s1,144
    80002aba:	02d48a63          	beq	s1,a3,80002aee <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002abe:	449c                	lw	a5,8(s1)
    80002ac0:	fef059e3          	blez	a5,80002ab2 <iget+0x38>
    80002ac4:	4098                	lw	a4,0(s1)
    80002ac6:	ff3716e3          	bne	a4,s3,80002ab2 <iget+0x38>
    80002aca:	40d8                	lw	a4,4(s1)
    80002acc:	ff4713e3          	bne	a4,s4,80002ab2 <iget+0x38>
      ip->ref++;
    80002ad0:	2785                	addiw	a5,a5,1
    80002ad2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ad4:	00018517          	auipc	a0,0x18
    80002ad8:	fb450513          	addi	a0,a0,-76 # 8001aa88 <itable>
    80002adc:	00004097          	auipc	ra,0x4
    80002ae0:	c78080e7          	jalr	-904(ra) # 80006754 <release>
      return ip;
    80002ae4:	8926                	mv	s2,s1
    80002ae6:	a03d                	j	80002b14 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ae8:	f7f9                	bnez	a5,80002ab6 <iget+0x3c>
    80002aea:	8926                	mv	s2,s1
    80002aec:	b7e9                	j	80002ab6 <iget+0x3c>
  if(empty == 0)
    80002aee:	02090c63          	beqz	s2,80002b26 <iget+0xac>
  ip->dev = dev;
    80002af2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002af6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002afa:	4785                	li	a5,1
    80002afc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b00:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b04:	00018517          	auipc	a0,0x18
    80002b08:	f8450513          	addi	a0,a0,-124 # 8001aa88 <itable>
    80002b0c:	00004097          	auipc	ra,0x4
    80002b10:	c48080e7          	jalr	-952(ra) # 80006754 <release>
}
    80002b14:	854a                	mv	a0,s2
    80002b16:	70a2                	ld	ra,40(sp)
    80002b18:	7402                	ld	s0,32(sp)
    80002b1a:	64e2                	ld	s1,24(sp)
    80002b1c:	6942                	ld	s2,16(sp)
    80002b1e:	69a2                	ld	s3,8(sp)
    80002b20:	6a02                	ld	s4,0(sp)
    80002b22:	6145                	addi	sp,sp,48
    80002b24:	8082                	ret
    panic("iget: no inodes");
    80002b26:	00006517          	auipc	a0,0x6
    80002b2a:	9da50513          	addi	a0,a0,-1574 # 80008500 <syscalls+0x130>
    80002b2e:	00003097          	auipc	ra,0x3
    80002b32:	634080e7          	jalr	1588(ra) # 80006162 <panic>

0000000080002b36 <fsinit>:
fsinit(int dev) {
    80002b36:	7179                	addi	sp,sp,-48
    80002b38:	f406                	sd	ra,40(sp)
    80002b3a:	f022                	sd	s0,32(sp)
    80002b3c:	ec26                	sd	s1,24(sp)
    80002b3e:	e84a                	sd	s2,16(sp)
    80002b40:	e44e                	sd	s3,8(sp)
    80002b42:	1800                	addi	s0,sp,48
    80002b44:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b46:	4585                	li	a1,1
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	8b8080e7          	jalr	-1864(ra) # 80002400 <bread>
    80002b50:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b52:	00018997          	auipc	s3,0x18
    80002b56:	f1698993          	addi	s3,s3,-234 # 8001aa68 <sb>
    80002b5a:	02000613          	li	a2,32
    80002b5e:	06050593          	addi	a1,a0,96
    80002b62:	854e                	mv	a0,s3
    80002b64:	ffffd097          	auipc	ra,0xffffd
    80002b68:	75a080e7          	jalr	1882(ra) # 800002be <memmove>
  brelse(bp);
    80002b6c:	8526                	mv	a0,s1
    80002b6e:	00000097          	auipc	ra,0x0
    80002b72:	b3a080e7          	jalr	-1222(ra) # 800026a8 <brelse>
  if(sb.magic != FSMAGIC)
    80002b76:	0009a703          	lw	a4,0(s3)
    80002b7a:	102037b7          	lui	a5,0x10203
    80002b7e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b82:	02f71263          	bne	a4,a5,80002ba6 <fsinit+0x70>
  initlog(dev, &sb);
    80002b86:	00018597          	auipc	a1,0x18
    80002b8a:	ee258593          	addi	a1,a1,-286 # 8001aa68 <sb>
    80002b8e:	854a                	mv	a0,s2
    80002b90:	00001097          	auipc	ra,0x1
    80002b94:	b40080e7          	jalr	-1216(ra) # 800036d0 <initlog>
}
    80002b98:	70a2                	ld	ra,40(sp)
    80002b9a:	7402                	ld	s0,32(sp)
    80002b9c:	64e2                	ld	s1,24(sp)
    80002b9e:	6942                	ld	s2,16(sp)
    80002ba0:	69a2                	ld	s3,8(sp)
    80002ba2:	6145                	addi	sp,sp,48
    80002ba4:	8082                	ret
    panic("invalid file system");
    80002ba6:	00006517          	auipc	a0,0x6
    80002baa:	96a50513          	addi	a0,a0,-1686 # 80008510 <syscalls+0x140>
    80002bae:	00003097          	auipc	ra,0x3
    80002bb2:	5b4080e7          	jalr	1460(ra) # 80006162 <panic>

0000000080002bb6 <iinit>:
{
    80002bb6:	7179                	addi	sp,sp,-48
    80002bb8:	f406                	sd	ra,40(sp)
    80002bba:	f022                	sd	s0,32(sp)
    80002bbc:	ec26                	sd	s1,24(sp)
    80002bbe:	e84a                	sd	s2,16(sp)
    80002bc0:	e44e                	sd	s3,8(sp)
    80002bc2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bc4:	00006597          	auipc	a1,0x6
    80002bc8:	96458593          	addi	a1,a1,-1692 # 80008528 <syscalls+0x158>
    80002bcc:	00018517          	auipc	a0,0x18
    80002bd0:	ebc50513          	addi	a0,a0,-324 # 8001aa88 <itable>
    80002bd4:	00004097          	auipc	ra,0x4
    80002bd8:	c2c080e7          	jalr	-980(ra) # 80006800 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bdc:	00018497          	auipc	s1,0x18
    80002be0:	edc48493          	addi	s1,s1,-292 # 8001aab8 <itable+0x30>
    80002be4:	0001a997          	auipc	s3,0x1a
    80002be8:	af498993          	addi	s3,s3,-1292 # 8001c6d8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bec:	00006917          	auipc	s2,0x6
    80002bf0:	94490913          	addi	s2,s2,-1724 # 80008530 <syscalls+0x160>
    80002bf4:	85ca                	mv	a1,s2
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	00001097          	auipc	ra,0x1
    80002bfc:	e26080e7          	jalr	-474(ra) # 80003a1e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c00:	09048493          	addi	s1,s1,144
    80002c04:	ff3498e3          	bne	s1,s3,80002bf4 <iinit+0x3e>
}
    80002c08:	70a2                	ld	ra,40(sp)
    80002c0a:	7402                	ld	s0,32(sp)
    80002c0c:	64e2                	ld	s1,24(sp)
    80002c0e:	6942                	ld	s2,16(sp)
    80002c10:	69a2                	ld	s3,8(sp)
    80002c12:	6145                	addi	sp,sp,48
    80002c14:	8082                	ret

0000000080002c16 <ialloc>:
{
    80002c16:	7139                	addi	sp,sp,-64
    80002c18:	fc06                	sd	ra,56(sp)
    80002c1a:	f822                	sd	s0,48(sp)
    80002c1c:	f426                	sd	s1,40(sp)
    80002c1e:	f04a                	sd	s2,32(sp)
    80002c20:	ec4e                	sd	s3,24(sp)
    80002c22:	e852                	sd	s4,16(sp)
    80002c24:	e456                	sd	s5,8(sp)
    80002c26:	e05a                	sd	s6,0(sp)
    80002c28:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c2a:	00018717          	auipc	a4,0x18
    80002c2e:	e4a72703          	lw	a4,-438(a4) # 8001aa74 <sb+0xc>
    80002c32:	4785                	li	a5,1
    80002c34:	04e7f863          	bgeu	a5,a4,80002c84 <ialloc+0x6e>
    80002c38:	8aaa                	mv	s5,a0
    80002c3a:	8b2e                	mv	s6,a1
    80002c3c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c3e:	00018a17          	auipc	s4,0x18
    80002c42:	e2aa0a13          	addi	s4,s4,-470 # 8001aa68 <sb>
    80002c46:	00495593          	srli	a1,s2,0x4
    80002c4a:	018a2783          	lw	a5,24(s4)
    80002c4e:	9dbd                	addw	a1,a1,a5
    80002c50:	8556                	mv	a0,s5
    80002c52:	fffff097          	auipc	ra,0xfffff
    80002c56:	7ae080e7          	jalr	1966(ra) # 80002400 <bread>
    80002c5a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c5c:	06050993          	addi	s3,a0,96
    80002c60:	00f97793          	andi	a5,s2,15
    80002c64:	079a                	slli	a5,a5,0x6
    80002c66:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c68:	00099783          	lh	a5,0(s3)
    80002c6c:	cf9d                	beqz	a5,80002caa <ialloc+0x94>
    brelse(bp);
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	a3a080e7          	jalr	-1478(ra) # 800026a8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c76:	0905                	addi	s2,s2,1
    80002c78:	00ca2703          	lw	a4,12(s4)
    80002c7c:	0009079b          	sext.w	a5,s2
    80002c80:	fce7e3e3          	bltu	a5,a4,80002c46 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002c84:	00006517          	auipc	a0,0x6
    80002c88:	8b450513          	addi	a0,a0,-1868 # 80008538 <syscalls+0x168>
    80002c8c:	00003097          	auipc	ra,0x3
    80002c90:	520080e7          	jalr	1312(ra) # 800061ac <printf>
  return 0;
    80002c94:	4501                	li	a0,0
}
    80002c96:	70e2                	ld	ra,56(sp)
    80002c98:	7442                	ld	s0,48(sp)
    80002c9a:	74a2                	ld	s1,40(sp)
    80002c9c:	7902                	ld	s2,32(sp)
    80002c9e:	69e2                	ld	s3,24(sp)
    80002ca0:	6a42                	ld	s4,16(sp)
    80002ca2:	6aa2                	ld	s5,8(sp)
    80002ca4:	6b02                	ld	s6,0(sp)
    80002ca6:	6121                	addi	sp,sp,64
    80002ca8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002caa:	04000613          	li	a2,64
    80002cae:	4581                	li	a1,0
    80002cb0:	854e                	mv	a0,s3
    80002cb2:	ffffd097          	auipc	ra,0xffffd
    80002cb6:	5b0080e7          	jalr	1456(ra) # 80000262 <memset>
      dip->type = type;
    80002cba:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cbe:	8526                	mv	a0,s1
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	c7a080e7          	jalr	-902(ra) # 8000393a <log_write>
      brelse(bp);
    80002cc8:	8526                	mv	a0,s1
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	9de080e7          	jalr	-1570(ra) # 800026a8 <brelse>
      return iget(dev, inum);
    80002cd2:	0009059b          	sext.w	a1,s2
    80002cd6:	8556                	mv	a0,s5
    80002cd8:	00000097          	auipc	ra,0x0
    80002cdc:	da2080e7          	jalr	-606(ra) # 80002a7a <iget>
    80002ce0:	bf5d                	j	80002c96 <ialloc+0x80>

0000000080002ce2 <iupdate>:
{
    80002ce2:	1101                	addi	sp,sp,-32
    80002ce4:	ec06                	sd	ra,24(sp)
    80002ce6:	e822                	sd	s0,16(sp)
    80002ce8:	e426                	sd	s1,8(sp)
    80002cea:	e04a                	sd	s2,0(sp)
    80002cec:	1000                	addi	s0,sp,32
    80002cee:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cf0:	415c                	lw	a5,4(a0)
    80002cf2:	0047d79b          	srliw	a5,a5,0x4
    80002cf6:	00018597          	auipc	a1,0x18
    80002cfa:	d8a5a583          	lw	a1,-630(a1) # 8001aa80 <sb+0x18>
    80002cfe:	9dbd                	addw	a1,a1,a5
    80002d00:	4108                	lw	a0,0(a0)
    80002d02:	fffff097          	auipc	ra,0xfffff
    80002d06:	6fe080e7          	jalr	1790(ra) # 80002400 <bread>
    80002d0a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d0c:	06050793          	addi	a5,a0,96
    80002d10:	40d8                	lw	a4,4(s1)
    80002d12:	8b3d                	andi	a4,a4,15
    80002d14:	071a                	slli	a4,a4,0x6
    80002d16:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d18:	04c49703          	lh	a4,76(s1)
    80002d1c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d20:	04e49703          	lh	a4,78(s1)
    80002d24:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d28:	05049703          	lh	a4,80(s1)
    80002d2c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d30:	05249703          	lh	a4,82(s1)
    80002d34:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d38:	48f8                	lw	a4,84(s1)
    80002d3a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d3c:	03400613          	li	a2,52
    80002d40:	05848593          	addi	a1,s1,88
    80002d44:	00c78513          	addi	a0,a5,12
    80002d48:	ffffd097          	auipc	ra,0xffffd
    80002d4c:	576080e7          	jalr	1398(ra) # 800002be <memmove>
  log_write(bp);
    80002d50:	854a                	mv	a0,s2
    80002d52:	00001097          	auipc	ra,0x1
    80002d56:	be8080e7          	jalr	-1048(ra) # 8000393a <log_write>
  brelse(bp);
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	94c080e7          	jalr	-1716(ra) # 800026a8 <brelse>
}
    80002d64:	60e2                	ld	ra,24(sp)
    80002d66:	6442                	ld	s0,16(sp)
    80002d68:	64a2                	ld	s1,8(sp)
    80002d6a:	6902                	ld	s2,0(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret

0000000080002d70 <idup>:
{
    80002d70:	1101                	addi	sp,sp,-32
    80002d72:	ec06                	sd	ra,24(sp)
    80002d74:	e822                	sd	s0,16(sp)
    80002d76:	e426                	sd	s1,8(sp)
    80002d78:	1000                	addi	s0,sp,32
    80002d7a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d7c:	00018517          	auipc	a0,0x18
    80002d80:	d0c50513          	addi	a0,a0,-756 # 8001aa88 <itable>
    80002d84:	00004097          	auipc	ra,0x4
    80002d88:	900080e7          	jalr	-1792(ra) # 80006684 <acquire>
  ip->ref++;
    80002d8c:	449c                	lw	a5,8(s1)
    80002d8e:	2785                	addiw	a5,a5,1
    80002d90:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d92:	00018517          	auipc	a0,0x18
    80002d96:	cf650513          	addi	a0,a0,-778 # 8001aa88 <itable>
    80002d9a:	00004097          	auipc	ra,0x4
    80002d9e:	9ba080e7          	jalr	-1606(ra) # 80006754 <release>
}
    80002da2:	8526                	mv	a0,s1
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	64a2                	ld	s1,8(sp)
    80002daa:	6105                	addi	sp,sp,32
    80002dac:	8082                	ret

0000000080002dae <ilock>:
{
    80002dae:	1101                	addi	sp,sp,-32
    80002db0:	ec06                	sd	ra,24(sp)
    80002db2:	e822                	sd	s0,16(sp)
    80002db4:	e426                	sd	s1,8(sp)
    80002db6:	e04a                	sd	s2,0(sp)
    80002db8:	1000                	addi	s0,sp,32
  if(ip == 0 || atomic_read4(&ip->ref) < 1)
    80002dba:	c51d                	beqz	a0,80002de8 <ilock+0x3a>
    80002dbc:	84aa                	mv	s1,a0
    80002dbe:	0521                	addi	a0,a0,8
    80002dc0:	00004097          	auipc	ra,0x4
    80002dc4:	ac0080e7          	jalr	-1344(ra) # 80006880 <atomic_read4>
    80002dc8:	02a05063          	blez	a0,80002de8 <ilock+0x3a>
  acquiresleep(&ip->lock);
    80002dcc:	01048513          	addi	a0,s1,16
    80002dd0:	00001097          	auipc	ra,0x1
    80002dd4:	c88080e7          	jalr	-888(ra) # 80003a58 <acquiresleep>
  if(ip->valid == 0){
    80002dd8:	44bc                	lw	a5,72(s1)
    80002dda:	cf99                	beqz	a5,80002df8 <ilock+0x4a>
}
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6902                	ld	s2,0(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret
    panic("ilock");
    80002de8:	00005517          	auipc	a0,0x5
    80002dec:	76850513          	addi	a0,a0,1896 # 80008550 <syscalls+0x180>
    80002df0:	00003097          	auipc	ra,0x3
    80002df4:	372080e7          	jalr	882(ra) # 80006162 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002df8:	40dc                	lw	a5,4(s1)
    80002dfa:	0047d79b          	srliw	a5,a5,0x4
    80002dfe:	00018597          	auipc	a1,0x18
    80002e02:	c825a583          	lw	a1,-894(a1) # 8001aa80 <sb+0x18>
    80002e06:	9dbd                	addw	a1,a1,a5
    80002e08:	4088                	lw	a0,0(s1)
    80002e0a:	fffff097          	auipc	ra,0xfffff
    80002e0e:	5f6080e7          	jalr	1526(ra) # 80002400 <bread>
    80002e12:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e14:	06050593          	addi	a1,a0,96
    80002e18:	40dc                	lw	a5,4(s1)
    80002e1a:	8bbd                	andi	a5,a5,15
    80002e1c:	079a                	slli	a5,a5,0x6
    80002e1e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e20:	00059783          	lh	a5,0(a1)
    80002e24:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002e28:	00259783          	lh	a5,2(a1)
    80002e2c:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002e30:	00459783          	lh	a5,4(a1)
    80002e34:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002e38:	00659783          	lh	a5,6(a1)
    80002e3c:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002e40:	459c                	lw	a5,8(a1)
    80002e42:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e44:	03400613          	li	a2,52
    80002e48:	05b1                	addi	a1,a1,12
    80002e4a:	05848513          	addi	a0,s1,88
    80002e4e:	ffffd097          	auipc	ra,0xffffd
    80002e52:	470080e7          	jalr	1136(ra) # 800002be <memmove>
    brelse(bp);
    80002e56:	854a                	mv	a0,s2
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	850080e7          	jalr	-1968(ra) # 800026a8 <brelse>
    ip->valid = 1;
    80002e60:	4785                	li	a5,1
    80002e62:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e64:	04c49783          	lh	a5,76(s1)
    80002e68:	fbb5                	bnez	a5,80002ddc <ilock+0x2e>
      panic("ilock: no type");
    80002e6a:	00005517          	auipc	a0,0x5
    80002e6e:	6ee50513          	addi	a0,a0,1774 # 80008558 <syscalls+0x188>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	2f0080e7          	jalr	752(ra) # 80006162 <panic>

0000000080002e7a <iunlock>:
{
    80002e7a:	1101                	addi	sp,sp,-32
    80002e7c:	ec06                	sd	ra,24(sp)
    80002e7e:	e822                	sd	s0,16(sp)
    80002e80:	e426                	sd	s1,8(sp)
    80002e82:	e04a                	sd	s2,0(sp)
    80002e84:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || atomic_read4(&ip->ref) < 1)
    80002e86:	cd0d                	beqz	a0,80002ec0 <iunlock+0x46>
    80002e88:	84aa                	mv	s1,a0
    80002e8a:	01050913          	addi	s2,a0,16
    80002e8e:	854a                	mv	a0,s2
    80002e90:	00001097          	auipc	ra,0x1
    80002e94:	c62080e7          	jalr	-926(ra) # 80003af2 <holdingsleep>
    80002e98:	c505                	beqz	a0,80002ec0 <iunlock+0x46>
    80002e9a:	00848513          	addi	a0,s1,8
    80002e9e:	00004097          	auipc	ra,0x4
    80002ea2:	9e2080e7          	jalr	-1566(ra) # 80006880 <atomic_read4>
    80002ea6:	00a05d63          	blez	a0,80002ec0 <iunlock+0x46>
  releasesleep(&ip->lock);
    80002eaa:	854a                	mv	a0,s2
    80002eac:	00001097          	auipc	ra,0x1
    80002eb0:	c02080e7          	jalr	-1022(ra) # 80003aae <releasesleep>
}
    80002eb4:	60e2                	ld	ra,24(sp)
    80002eb6:	6442                	ld	s0,16(sp)
    80002eb8:	64a2                	ld	s1,8(sp)
    80002eba:	6902                	ld	s2,0(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret
    panic("iunlock");
    80002ec0:	00005517          	auipc	a0,0x5
    80002ec4:	6a850513          	addi	a0,a0,1704 # 80008568 <syscalls+0x198>
    80002ec8:	00003097          	auipc	ra,0x3
    80002ecc:	29a080e7          	jalr	666(ra) # 80006162 <panic>

0000000080002ed0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ed0:	7179                	addi	sp,sp,-48
    80002ed2:	f406                	sd	ra,40(sp)
    80002ed4:	f022                	sd	s0,32(sp)
    80002ed6:	ec26                	sd	s1,24(sp)
    80002ed8:	e84a                	sd	s2,16(sp)
    80002eda:	e44e                	sd	s3,8(sp)
    80002edc:	e052                	sd	s4,0(sp)
    80002ede:	1800                	addi	s0,sp,48
    80002ee0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ee2:	05850493          	addi	s1,a0,88
    80002ee6:	08850913          	addi	s2,a0,136
    80002eea:	a021                	j	80002ef2 <itrunc+0x22>
    80002eec:	0491                	addi	s1,s1,4
    80002eee:	01248d63          	beq	s1,s2,80002f08 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ef2:	408c                	lw	a1,0(s1)
    80002ef4:	dde5                	beqz	a1,80002eec <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ef6:	0009a503          	lw	a0,0(s3)
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	8e8080e7          	jalr	-1816(ra) # 800027e2 <bfree>
      ip->addrs[i] = 0;
    80002f02:	0004a023          	sw	zero,0(s1)
    80002f06:	b7dd                	j	80002eec <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f08:	0889a583          	lw	a1,136(s3)
    80002f0c:	e185                	bnez	a1,80002f2c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  ip->size = 0;
    80002f0e:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f12:	854e                	mv	a0,s3
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	dce080e7          	jalr	-562(ra) # 80002ce2 <iupdate>
}
    80002f1c:	70a2                	ld	ra,40(sp)
    80002f1e:	7402                	ld	s0,32(sp)
    80002f20:	64e2                	ld	s1,24(sp)
    80002f22:	6942                	ld	s2,16(sp)
    80002f24:	69a2                	ld	s3,8(sp)
    80002f26:	6a02                	ld	s4,0(sp)
    80002f28:	6145                	addi	sp,sp,48
    80002f2a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f2c:	0009a503          	lw	a0,0(s3)
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	4d0080e7          	jalr	1232(ra) # 80002400 <bread>
    80002f38:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f3a:	06050493          	addi	s1,a0,96
    80002f3e:	46050913          	addi	s2,a0,1120
    80002f42:	a021                	j	80002f4a <itrunc+0x7a>
    80002f44:	0491                	addi	s1,s1,4
    80002f46:	01248b63          	beq	s1,s2,80002f5c <itrunc+0x8c>
      if(a[j])
    80002f4a:	408c                	lw	a1,0(s1)
    80002f4c:	dde5                	beqz	a1,80002f44 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f4e:	0009a503          	lw	a0,0(s3)
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	890080e7          	jalr	-1904(ra) # 800027e2 <bfree>
    80002f5a:	b7ed                	j	80002f44 <itrunc+0x74>
    brelse(bp);
    80002f5c:	8552                	mv	a0,s4
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	74a080e7          	jalr	1866(ra) # 800026a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f66:	0889a583          	lw	a1,136(s3)
    80002f6a:	0009a503          	lw	a0,0(s3)
    80002f6e:	00000097          	auipc	ra,0x0
    80002f72:	874080e7          	jalr	-1932(ra) # 800027e2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f76:	0809a423          	sw	zero,136(s3)
    80002f7a:	bf51                	j	80002f0e <itrunc+0x3e>

0000000080002f7c <iput>:
{
    80002f7c:	1101                	addi	sp,sp,-32
    80002f7e:	ec06                	sd	ra,24(sp)
    80002f80:	e822                	sd	s0,16(sp)
    80002f82:	e426                	sd	s1,8(sp)
    80002f84:	e04a                	sd	s2,0(sp)
    80002f86:	1000                	addi	s0,sp,32
    80002f88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f8a:	00018517          	auipc	a0,0x18
    80002f8e:	afe50513          	addi	a0,a0,-1282 # 8001aa88 <itable>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	6f2080e7          	jalr	1778(ra) # 80006684 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f9a:	4498                	lw	a4,8(s1)
    80002f9c:	4785                	li	a5,1
    80002f9e:	02f70363          	beq	a4,a5,80002fc4 <iput+0x48>
  ip->ref--;
    80002fa2:	449c                	lw	a5,8(s1)
    80002fa4:	37fd                	addiw	a5,a5,-1
    80002fa6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fa8:	00018517          	auipc	a0,0x18
    80002fac:	ae050513          	addi	a0,a0,-1312 # 8001aa88 <itable>
    80002fb0:	00003097          	auipc	ra,0x3
    80002fb4:	7a4080e7          	jalr	1956(ra) # 80006754 <release>
}
    80002fb8:	60e2                	ld	ra,24(sp)
    80002fba:	6442                	ld	s0,16(sp)
    80002fbc:	64a2                	ld	s1,8(sp)
    80002fbe:	6902                	ld	s2,0(sp)
    80002fc0:	6105                	addi	sp,sp,32
    80002fc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fc4:	44bc                	lw	a5,72(s1)
    80002fc6:	dff1                	beqz	a5,80002fa2 <iput+0x26>
    80002fc8:	05249783          	lh	a5,82(s1)
    80002fcc:	fbf9                	bnez	a5,80002fa2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002fce:	01048913          	addi	s2,s1,16
    80002fd2:	854a                	mv	a0,s2
    80002fd4:	00001097          	auipc	ra,0x1
    80002fd8:	a84080e7          	jalr	-1404(ra) # 80003a58 <acquiresleep>
    release(&itable.lock);
    80002fdc:	00018517          	auipc	a0,0x18
    80002fe0:	aac50513          	addi	a0,a0,-1364 # 8001aa88 <itable>
    80002fe4:	00003097          	auipc	ra,0x3
    80002fe8:	770080e7          	jalr	1904(ra) # 80006754 <release>
    itrunc(ip);
    80002fec:	8526                	mv	a0,s1
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	ee2080e7          	jalr	-286(ra) # 80002ed0 <itrunc>
    ip->type = 0;
    80002ff6:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	00000097          	auipc	ra,0x0
    80003000:	ce6080e7          	jalr	-794(ra) # 80002ce2 <iupdate>
    ip->valid = 0;
    80003004:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003008:	854a                	mv	a0,s2
    8000300a:	00001097          	auipc	ra,0x1
    8000300e:	aa4080e7          	jalr	-1372(ra) # 80003aae <releasesleep>
    acquire(&itable.lock);
    80003012:	00018517          	auipc	a0,0x18
    80003016:	a7650513          	addi	a0,a0,-1418 # 8001aa88 <itable>
    8000301a:	00003097          	auipc	ra,0x3
    8000301e:	66a080e7          	jalr	1642(ra) # 80006684 <acquire>
    80003022:	b741                	j	80002fa2 <iput+0x26>

0000000080003024 <iunlockput>:
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	1000                	addi	s0,sp,32
    8000302e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003030:	00000097          	auipc	ra,0x0
    80003034:	e4a080e7          	jalr	-438(ra) # 80002e7a <iunlock>
  iput(ip);
    80003038:	8526                	mv	a0,s1
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	f42080e7          	jalr	-190(ra) # 80002f7c <iput>
}
    80003042:	60e2                	ld	ra,24(sp)
    80003044:	6442                	ld	s0,16(sp)
    80003046:	64a2                	ld	s1,8(sp)
    80003048:	6105                	addi	sp,sp,32
    8000304a:	8082                	ret

000000008000304c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000304c:	1141                	addi	sp,sp,-16
    8000304e:	e422                	sd	s0,8(sp)
    80003050:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003052:	411c                	lw	a5,0(a0)
    80003054:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003056:	415c                	lw	a5,4(a0)
    80003058:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000305a:	04c51783          	lh	a5,76(a0)
    8000305e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003062:	05251783          	lh	a5,82(a0)
    80003066:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000306a:	05456783          	lwu	a5,84(a0)
    8000306e:	e99c                	sd	a5,16(a1)
}
    80003070:	6422                	ld	s0,8(sp)
    80003072:	0141                	addi	sp,sp,16
    80003074:	8082                	ret

0000000080003076 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003076:	497c                	lw	a5,84(a0)
    80003078:	0ed7e963          	bltu	a5,a3,8000316a <readi+0xf4>
{
    8000307c:	7159                	addi	sp,sp,-112
    8000307e:	f486                	sd	ra,104(sp)
    80003080:	f0a2                	sd	s0,96(sp)
    80003082:	eca6                	sd	s1,88(sp)
    80003084:	e8ca                	sd	s2,80(sp)
    80003086:	e4ce                	sd	s3,72(sp)
    80003088:	e0d2                	sd	s4,64(sp)
    8000308a:	fc56                	sd	s5,56(sp)
    8000308c:	f85a                	sd	s6,48(sp)
    8000308e:	f45e                	sd	s7,40(sp)
    80003090:	f062                	sd	s8,32(sp)
    80003092:	ec66                	sd	s9,24(sp)
    80003094:	e86a                	sd	s10,16(sp)
    80003096:	e46e                	sd	s11,8(sp)
    80003098:	1880                	addi	s0,sp,112
    8000309a:	8b2a                	mv	s6,a0
    8000309c:	8bae                	mv	s7,a1
    8000309e:	8a32                	mv	s4,a2
    800030a0:	84b6                	mv	s1,a3
    800030a2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800030a4:	9f35                	addw	a4,a4,a3
    return 0;
    800030a6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030a8:	0ad76063          	bltu	a4,a3,80003148 <readi+0xd2>
  if(off + n > ip->size)
    800030ac:	00e7f463          	bgeu	a5,a4,800030b4 <readi+0x3e>
    n = ip->size - off;
    800030b0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b4:	0a0a8963          	beqz	s5,80003166 <readi+0xf0>
    800030b8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ba:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030be:	5c7d                	li	s8,-1
    800030c0:	a82d                	j	800030fa <readi+0x84>
    800030c2:	020d1d93          	slli	s11,s10,0x20
    800030c6:	020ddd93          	srli	s11,s11,0x20
    800030ca:	06090613          	addi	a2,s2,96
    800030ce:	86ee                	mv	a3,s11
    800030d0:	963a                	add	a2,a2,a4
    800030d2:	85d2                	mv	a1,s4
    800030d4:	855e                	mv	a0,s7
    800030d6:	fffff097          	auipc	ra,0xfffff
    800030da:	924080e7          	jalr	-1756(ra) # 800019fa <either_copyout>
    800030de:	05850d63          	beq	a0,s8,80003138 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030e2:	854a                	mv	a0,s2
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	5c4080e7          	jalr	1476(ra) # 800026a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ec:	013d09bb          	addw	s3,s10,s3
    800030f0:	009d04bb          	addw	s1,s10,s1
    800030f4:	9a6e                	add	s4,s4,s11
    800030f6:	0559f763          	bgeu	s3,s5,80003144 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800030fa:	00a4d59b          	srliw	a1,s1,0xa
    800030fe:	855a                	mv	a0,s6
    80003100:	00000097          	auipc	ra,0x0
    80003104:	890080e7          	jalr	-1904(ra) # 80002990 <bmap>
    80003108:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000310c:	cd85                	beqz	a1,80003144 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000310e:	000b2503          	lw	a0,0(s6)
    80003112:	fffff097          	auipc	ra,0xfffff
    80003116:	2ee080e7          	jalr	750(ra) # 80002400 <bread>
    8000311a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311c:	3ff4f713          	andi	a4,s1,1023
    80003120:	40ec87bb          	subw	a5,s9,a4
    80003124:	413a86bb          	subw	a3,s5,s3
    80003128:	8d3e                	mv	s10,a5
    8000312a:	2781                	sext.w	a5,a5
    8000312c:	0006861b          	sext.w	a2,a3
    80003130:	f8f679e3          	bgeu	a2,a5,800030c2 <readi+0x4c>
    80003134:	8d36                	mv	s10,a3
    80003136:	b771                	j	800030c2 <readi+0x4c>
      brelse(bp);
    80003138:	854a                	mv	a0,s2
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	56e080e7          	jalr	1390(ra) # 800026a8 <brelse>
      tot = -1;
    80003142:	59fd                	li	s3,-1
  }
  return tot;
    80003144:	0009851b          	sext.w	a0,s3
}
    80003148:	70a6                	ld	ra,104(sp)
    8000314a:	7406                	ld	s0,96(sp)
    8000314c:	64e6                	ld	s1,88(sp)
    8000314e:	6946                	ld	s2,80(sp)
    80003150:	69a6                	ld	s3,72(sp)
    80003152:	6a06                	ld	s4,64(sp)
    80003154:	7ae2                	ld	s5,56(sp)
    80003156:	7b42                	ld	s6,48(sp)
    80003158:	7ba2                	ld	s7,40(sp)
    8000315a:	7c02                	ld	s8,32(sp)
    8000315c:	6ce2                	ld	s9,24(sp)
    8000315e:	6d42                	ld	s10,16(sp)
    80003160:	6da2                	ld	s11,8(sp)
    80003162:	6165                	addi	sp,sp,112
    80003164:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003166:	89d6                	mv	s3,s5
    80003168:	bff1                	j	80003144 <readi+0xce>
    return 0;
    8000316a:	4501                	li	a0,0
}
    8000316c:	8082                	ret

000000008000316e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000316e:	497c                	lw	a5,84(a0)
    80003170:	10d7e863          	bltu	a5,a3,80003280 <writei+0x112>
{
    80003174:	7159                	addi	sp,sp,-112
    80003176:	f486                	sd	ra,104(sp)
    80003178:	f0a2                	sd	s0,96(sp)
    8000317a:	eca6                	sd	s1,88(sp)
    8000317c:	e8ca                	sd	s2,80(sp)
    8000317e:	e4ce                	sd	s3,72(sp)
    80003180:	e0d2                	sd	s4,64(sp)
    80003182:	fc56                	sd	s5,56(sp)
    80003184:	f85a                	sd	s6,48(sp)
    80003186:	f45e                	sd	s7,40(sp)
    80003188:	f062                	sd	s8,32(sp)
    8000318a:	ec66                	sd	s9,24(sp)
    8000318c:	e86a                	sd	s10,16(sp)
    8000318e:	e46e                	sd	s11,8(sp)
    80003190:	1880                	addi	s0,sp,112
    80003192:	8aaa                	mv	s5,a0
    80003194:	8bae                	mv	s7,a1
    80003196:	8a32                	mv	s4,a2
    80003198:	8936                	mv	s2,a3
    8000319a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000319c:	00e687bb          	addw	a5,a3,a4
    800031a0:	0ed7e263          	bltu	a5,a3,80003284 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031a4:	00043737          	lui	a4,0x43
    800031a8:	0ef76063          	bltu	a4,a5,80003288 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ac:	0c0b0863          	beqz	s6,8000327c <writei+0x10e>
    800031b0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031b6:	5c7d                	li	s8,-1
    800031b8:	a091                	j	800031fc <writei+0x8e>
    800031ba:	020d1d93          	slli	s11,s10,0x20
    800031be:	020ddd93          	srli	s11,s11,0x20
    800031c2:	06048513          	addi	a0,s1,96
    800031c6:	86ee                	mv	a3,s11
    800031c8:	8652                	mv	a2,s4
    800031ca:	85de                	mv	a1,s7
    800031cc:	953a                	add	a0,a0,a4
    800031ce:	fffff097          	auipc	ra,0xfffff
    800031d2:	882080e7          	jalr	-1918(ra) # 80001a50 <either_copyin>
    800031d6:	07850263          	beq	a0,s8,8000323a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031da:	8526                	mv	a0,s1
    800031dc:	00000097          	auipc	ra,0x0
    800031e0:	75e080e7          	jalr	1886(ra) # 8000393a <log_write>
    brelse(bp);
    800031e4:	8526                	mv	a0,s1
    800031e6:	fffff097          	auipc	ra,0xfffff
    800031ea:	4c2080e7          	jalr	1218(ra) # 800026a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ee:	013d09bb          	addw	s3,s10,s3
    800031f2:	012d093b          	addw	s2,s10,s2
    800031f6:	9a6e                	add	s4,s4,s11
    800031f8:	0569f663          	bgeu	s3,s6,80003244 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800031fc:	00a9559b          	srliw	a1,s2,0xa
    80003200:	8556                	mv	a0,s5
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	78e080e7          	jalr	1934(ra) # 80002990 <bmap>
    8000320a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000320e:	c99d                	beqz	a1,80003244 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003210:	000aa503          	lw	a0,0(s5)
    80003214:	fffff097          	auipc	ra,0xfffff
    80003218:	1ec080e7          	jalr	492(ra) # 80002400 <bread>
    8000321c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000321e:	3ff97713          	andi	a4,s2,1023
    80003222:	40ec87bb          	subw	a5,s9,a4
    80003226:	413b06bb          	subw	a3,s6,s3
    8000322a:	8d3e                	mv	s10,a5
    8000322c:	2781                	sext.w	a5,a5
    8000322e:	0006861b          	sext.w	a2,a3
    80003232:	f8f674e3          	bgeu	a2,a5,800031ba <writei+0x4c>
    80003236:	8d36                	mv	s10,a3
    80003238:	b749                	j	800031ba <writei+0x4c>
      brelse(bp);
    8000323a:	8526                	mv	a0,s1
    8000323c:	fffff097          	auipc	ra,0xfffff
    80003240:	46c080e7          	jalr	1132(ra) # 800026a8 <brelse>
  }

  if(off > ip->size)
    80003244:	054aa783          	lw	a5,84(s5)
    80003248:	0127f463          	bgeu	a5,s2,80003250 <writei+0xe2>
    ip->size = off;
    8000324c:	052aaa23          	sw	s2,84(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003250:	8556                	mv	a0,s5
    80003252:	00000097          	auipc	ra,0x0
    80003256:	a90080e7          	jalr	-1392(ra) # 80002ce2 <iupdate>

  return tot;
    8000325a:	0009851b          	sext.w	a0,s3
}
    8000325e:	70a6                	ld	ra,104(sp)
    80003260:	7406                	ld	s0,96(sp)
    80003262:	64e6                	ld	s1,88(sp)
    80003264:	6946                	ld	s2,80(sp)
    80003266:	69a6                	ld	s3,72(sp)
    80003268:	6a06                	ld	s4,64(sp)
    8000326a:	7ae2                	ld	s5,56(sp)
    8000326c:	7b42                	ld	s6,48(sp)
    8000326e:	7ba2                	ld	s7,40(sp)
    80003270:	7c02                	ld	s8,32(sp)
    80003272:	6ce2                	ld	s9,24(sp)
    80003274:	6d42                	ld	s10,16(sp)
    80003276:	6da2                	ld	s11,8(sp)
    80003278:	6165                	addi	sp,sp,112
    8000327a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000327c:	89da                	mv	s3,s6
    8000327e:	bfc9                	j	80003250 <writei+0xe2>
    return -1;
    80003280:	557d                	li	a0,-1
}
    80003282:	8082                	ret
    return -1;
    80003284:	557d                	li	a0,-1
    80003286:	bfe1                	j	8000325e <writei+0xf0>
    return -1;
    80003288:	557d                	li	a0,-1
    8000328a:	bfd1                	j	8000325e <writei+0xf0>

000000008000328c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000328c:	1141                	addi	sp,sp,-16
    8000328e:	e406                	sd	ra,8(sp)
    80003290:	e022                	sd	s0,0(sp)
    80003292:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003294:	4639                	li	a2,14
    80003296:	ffffd097          	auipc	ra,0xffffd
    8000329a:	09c080e7          	jalr	156(ra) # 80000332 <strncmp>
}
    8000329e:	60a2                	ld	ra,8(sp)
    800032a0:	6402                	ld	s0,0(sp)
    800032a2:	0141                	addi	sp,sp,16
    800032a4:	8082                	ret

00000000800032a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032a6:	7139                	addi	sp,sp,-64
    800032a8:	fc06                	sd	ra,56(sp)
    800032aa:	f822                	sd	s0,48(sp)
    800032ac:	f426                	sd	s1,40(sp)
    800032ae:	f04a                	sd	s2,32(sp)
    800032b0:	ec4e                	sd	s3,24(sp)
    800032b2:	e852                	sd	s4,16(sp)
    800032b4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032b6:	04c51703          	lh	a4,76(a0)
    800032ba:	4785                	li	a5,1
    800032bc:	00f71a63          	bne	a4,a5,800032d0 <dirlookup+0x2a>
    800032c0:	892a                	mv	s2,a0
    800032c2:	89ae                	mv	s3,a1
    800032c4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c6:	497c                	lw	a5,84(a0)
    800032c8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032ca:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032cc:	e79d                	bnez	a5,800032fa <dirlookup+0x54>
    800032ce:	a8a5                	j	80003346 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032d0:	00005517          	auipc	a0,0x5
    800032d4:	2a050513          	addi	a0,a0,672 # 80008570 <syscalls+0x1a0>
    800032d8:	00003097          	auipc	ra,0x3
    800032dc:	e8a080e7          	jalr	-374(ra) # 80006162 <panic>
      panic("dirlookup read");
    800032e0:	00005517          	auipc	a0,0x5
    800032e4:	2a850513          	addi	a0,a0,680 # 80008588 <syscalls+0x1b8>
    800032e8:	00003097          	auipc	ra,0x3
    800032ec:	e7a080e7          	jalr	-390(ra) # 80006162 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f0:	24c1                	addiw	s1,s1,16
    800032f2:	05492783          	lw	a5,84(s2)
    800032f6:	04f4f763          	bgeu	s1,a5,80003344 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032fa:	4741                	li	a4,16
    800032fc:	86a6                	mv	a3,s1
    800032fe:	fc040613          	addi	a2,s0,-64
    80003302:	4581                	li	a1,0
    80003304:	854a                	mv	a0,s2
    80003306:	00000097          	auipc	ra,0x0
    8000330a:	d70080e7          	jalr	-656(ra) # 80003076 <readi>
    8000330e:	47c1                	li	a5,16
    80003310:	fcf518e3          	bne	a0,a5,800032e0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003314:	fc045783          	lhu	a5,-64(s0)
    80003318:	dfe1                	beqz	a5,800032f0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000331a:	fc240593          	addi	a1,s0,-62
    8000331e:	854e                	mv	a0,s3
    80003320:	00000097          	auipc	ra,0x0
    80003324:	f6c080e7          	jalr	-148(ra) # 8000328c <namecmp>
    80003328:	f561                	bnez	a0,800032f0 <dirlookup+0x4a>
      if(poff)
    8000332a:	000a0463          	beqz	s4,80003332 <dirlookup+0x8c>
        *poff = off;
    8000332e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003332:	fc045583          	lhu	a1,-64(s0)
    80003336:	00092503          	lw	a0,0(s2)
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	740080e7          	jalr	1856(ra) # 80002a7a <iget>
    80003342:	a011                	j	80003346 <dirlookup+0xa0>
  return 0;
    80003344:	4501                	li	a0,0
}
    80003346:	70e2                	ld	ra,56(sp)
    80003348:	7442                	ld	s0,48(sp)
    8000334a:	74a2                	ld	s1,40(sp)
    8000334c:	7902                	ld	s2,32(sp)
    8000334e:	69e2                	ld	s3,24(sp)
    80003350:	6a42                	ld	s4,16(sp)
    80003352:	6121                	addi	sp,sp,64
    80003354:	8082                	ret

0000000080003356 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003356:	711d                	addi	sp,sp,-96
    80003358:	ec86                	sd	ra,88(sp)
    8000335a:	e8a2                	sd	s0,80(sp)
    8000335c:	e4a6                	sd	s1,72(sp)
    8000335e:	e0ca                	sd	s2,64(sp)
    80003360:	fc4e                	sd	s3,56(sp)
    80003362:	f852                	sd	s4,48(sp)
    80003364:	f456                	sd	s5,40(sp)
    80003366:	f05a                	sd	s6,32(sp)
    80003368:	ec5e                	sd	s7,24(sp)
    8000336a:	e862                	sd	s8,16(sp)
    8000336c:	e466                	sd	s9,8(sp)
    8000336e:	1080                	addi	s0,sp,96
    80003370:	84aa                	mv	s1,a0
    80003372:	8b2e                	mv	s6,a1
    80003374:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003376:	00054703          	lbu	a4,0(a0)
    8000337a:	02f00793          	li	a5,47
    8000337e:	02f70263          	beq	a4,a5,800033a2 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003382:	ffffe097          	auipc	ra,0xffffe
    80003386:	bc8080e7          	jalr	-1080(ra) # 80000f4a <myproc>
    8000338a:	15853503          	ld	a0,344(a0)
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	9e2080e7          	jalr	-1566(ra) # 80002d70 <idup>
    80003396:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003398:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000339c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000339e:	4b85                	li	s7,1
    800033a0:	a875                	j	8000345c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800033a2:	4585                	li	a1,1
    800033a4:	4505                	li	a0,1
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	6d4080e7          	jalr	1748(ra) # 80002a7a <iget>
    800033ae:	8a2a                	mv	s4,a0
    800033b0:	b7e5                	j	80003398 <namex+0x42>
      iunlockput(ip);
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	c70080e7          	jalr	-912(ra) # 80003024 <iunlockput>
      return 0;
    800033bc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033be:	8552                	mv	a0,s4
    800033c0:	60e6                	ld	ra,88(sp)
    800033c2:	6446                	ld	s0,80(sp)
    800033c4:	64a6                	ld	s1,72(sp)
    800033c6:	6906                	ld	s2,64(sp)
    800033c8:	79e2                	ld	s3,56(sp)
    800033ca:	7a42                	ld	s4,48(sp)
    800033cc:	7aa2                	ld	s5,40(sp)
    800033ce:	7b02                	ld	s6,32(sp)
    800033d0:	6be2                	ld	s7,24(sp)
    800033d2:	6c42                	ld	s8,16(sp)
    800033d4:	6ca2                	ld	s9,8(sp)
    800033d6:	6125                	addi	sp,sp,96
    800033d8:	8082                	ret
      iunlock(ip);
    800033da:	8552                	mv	a0,s4
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	a9e080e7          	jalr	-1378(ra) # 80002e7a <iunlock>
      return ip;
    800033e4:	bfe9                	j	800033be <namex+0x68>
      iunlockput(ip);
    800033e6:	8552                	mv	a0,s4
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	c3c080e7          	jalr	-964(ra) # 80003024 <iunlockput>
      return 0;
    800033f0:	8a4e                	mv	s4,s3
    800033f2:	b7f1                	j	800033be <namex+0x68>
  len = path - s;
    800033f4:	40998633          	sub	a2,s3,s1
    800033f8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033fc:	099c5863          	bge	s8,s9,8000348c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003400:	4639                	li	a2,14
    80003402:	85a6                	mv	a1,s1
    80003404:	8556                	mv	a0,s5
    80003406:	ffffd097          	auipc	ra,0xffffd
    8000340a:	eb8080e7          	jalr	-328(ra) # 800002be <memmove>
    8000340e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003410:	0004c783          	lbu	a5,0(s1)
    80003414:	01279763          	bne	a5,s2,80003422 <namex+0xcc>
    path++;
    80003418:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000341a:	0004c783          	lbu	a5,0(s1)
    8000341e:	ff278de3          	beq	a5,s2,80003418 <namex+0xc2>
    ilock(ip);
    80003422:	8552                	mv	a0,s4
    80003424:	00000097          	auipc	ra,0x0
    80003428:	98a080e7          	jalr	-1654(ra) # 80002dae <ilock>
    if(ip->type != T_DIR){
    8000342c:	04ca1783          	lh	a5,76(s4)
    80003430:	f97791e3          	bne	a5,s7,800033b2 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003434:	000b0563          	beqz	s6,8000343e <namex+0xe8>
    80003438:	0004c783          	lbu	a5,0(s1)
    8000343c:	dfd9                	beqz	a5,800033da <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000343e:	4601                	li	a2,0
    80003440:	85d6                	mv	a1,s5
    80003442:	8552                	mv	a0,s4
    80003444:	00000097          	auipc	ra,0x0
    80003448:	e62080e7          	jalr	-414(ra) # 800032a6 <dirlookup>
    8000344c:	89aa                	mv	s3,a0
    8000344e:	dd41                	beqz	a0,800033e6 <namex+0x90>
    iunlockput(ip);
    80003450:	8552                	mv	a0,s4
    80003452:	00000097          	auipc	ra,0x0
    80003456:	bd2080e7          	jalr	-1070(ra) # 80003024 <iunlockput>
    ip = next;
    8000345a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000345c:	0004c783          	lbu	a5,0(s1)
    80003460:	01279763          	bne	a5,s2,8000346e <namex+0x118>
    path++;
    80003464:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003466:	0004c783          	lbu	a5,0(s1)
    8000346a:	ff278de3          	beq	a5,s2,80003464 <namex+0x10e>
  if(*path == 0)
    8000346e:	cb9d                	beqz	a5,800034a4 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003470:	0004c783          	lbu	a5,0(s1)
    80003474:	89a6                	mv	s3,s1
  len = path - s;
    80003476:	4c81                	li	s9,0
    80003478:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000347a:	01278963          	beq	a5,s2,8000348c <namex+0x136>
    8000347e:	dbbd                	beqz	a5,800033f4 <namex+0x9e>
    path++;
    80003480:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003482:	0009c783          	lbu	a5,0(s3)
    80003486:	ff279ce3          	bne	a5,s2,8000347e <namex+0x128>
    8000348a:	b7ad                	j	800033f4 <namex+0x9e>
    memmove(name, s, len);
    8000348c:	2601                	sext.w	a2,a2
    8000348e:	85a6                	mv	a1,s1
    80003490:	8556                	mv	a0,s5
    80003492:	ffffd097          	auipc	ra,0xffffd
    80003496:	e2c080e7          	jalr	-468(ra) # 800002be <memmove>
    name[len] = 0;
    8000349a:	9cd6                	add	s9,s9,s5
    8000349c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800034a0:	84ce                	mv	s1,s3
    800034a2:	b7bd                	j	80003410 <namex+0xba>
  if(nameiparent){
    800034a4:	f00b0de3          	beqz	s6,800033be <namex+0x68>
    iput(ip);
    800034a8:	8552                	mv	a0,s4
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	ad2080e7          	jalr	-1326(ra) # 80002f7c <iput>
    return 0;
    800034b2:	4a01                	li	s4,0
    800034b4:	b729                	j	800033be <namex+0x68>

00000000800034b6 <dirlink>:
{
    800034b6:	7139                	addi	sp,sp,-64
    800034b8:	fc06                	sd	ra,56(sp)
    800034ba:	f822                	sd	s0,48(sp)
    800034bc:	f426                	sd	s1,40(sp)
    800034be:	f04a                	sd	s2,32(sp)
    800034c0:	ec4e                	sd	s3,24(sp)
    800034c2:	e852                	sd	s4,16(sp)
    800034c4:	0080                	addi	s0,sp,64
    800034c6:	892a                	mv	s2,a0
    800034c8:	8a2e                	mv	s4,a1
    800034ca:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034cc:	4601                	li	a2,0
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	dd8080e7          	jalr	-552(ra) # 800032a6 <dirlookup>
    800034d6:	e93d                	bnez	a0,8000354c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034d8:	05492483          	lw	s1,84(s2)
    800034dc:	c49d                	beqz	s1,8000350a <dirlink+0x54>
    800034de:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034e0:	4741                	li	a4,16
    800034e2:	86a6                	mv	a3,s1
    800034e4:	fc040613          	addi	a2,s0,-64
    800034e8:	4581                	li	a1,0
    800034ea:	854a                	mv	a0,s2
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	b8a080e7          	jalr	-1142(ra) # 80003076 <readi>
    800034f4:	47c1                	li	a5,16
    800034f6:	06f51163          	bne	a0,a5,80003558 <dirlink+0xa2>
    if(de.inum == 0)
    800034fa:	fc045783          	lhu	a5,-64(s0)
    800034fe:	c791                	beqz	a5,8000350a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003500:	24c1                	addiw	s1,s1,16
    80003502:	05492783          	lw	a5,84(s2)
    80003506:	fcf4ede3          	bltu	s1,a5,800034e0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000350a:	4639                	li	a2,14
    8000350c:	85d2                	mv	a1,s4
    8000350e:	fc240513          	addi	a0,s0,-62
    80003512:	ffffd097          	auipc	ra,0xffffd
    80003516:	e5c080e7          	jalr	-420(ra) # 8000036e <strncpy>
  de.inum = inum;
    8000351a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000351e:	4741                	li	a4,16
    80003520:	86a6                	mv	a3,s1
    80003522:	fc040613          	addi	a2,s0,-64
    80003526:	4581                	li	a1,0
    80003528:	854a                	mv	a0,s2
    8000352a:	00000097          	auipc	ra,0x0
    8000352e:	c44080e7          	jalr	-956(ra) # 8000316e <writei>
    80003532:	1541                	addi	a0,a0,-16
    80003534:	00a03533          	snez	a0,a0
    80003538:	40a00533          	neg	a0,a0
}
    8000353c:	70e2                	ld	ra,56(sp)
    8000353e:	7442                	ld	s0,48(sp)
    80003540:	74a2                	ld	s1,40(sp)
    80003542:	7902                	ld	s2,32(sp)
    80003544:	69e2                	ld	s3,24(sp)
    80003546:	6a42                	ld	s4,16(sp)
    80003548:	6121                	addi	sp,sp,64
    8000354a:	8082                	ret
    iput(ip);
    8000354c:	00000097          	auipc	ra,0x0
    80003550:	a30080e7          	jalr	-1488(ra) # 80002f7c <iput>
    return -1;
    80003554:	557d                	li	a0,-1
    80003556:	b7dd                	j	8000353c <dirlink+0x86>
      panic("dirlink read");
    80003558:	00005517          	auipc	a0,0x5
    8000355c:	04050513          	addi	a0,a0,64 # 80008598 <syscalls+0x1c8>
    80003560:	00003097          	auipc	ra,0x3
    80003564:	c02080e7          	jalr	-1022(ra) # 80006162 <panic>

0000000080003568 <namei>:

struct inode*
namei(char *path)
{
    80003568:	1101                	addi	sp,sp,-32
    8000356a:	ec06                	sd	ra,24(sp)
    8000356c:	e822                	sd	s0,16(sp)
    8000356e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003570:	fe040613          	addi	a2,s0,-32
    80003574:	4581                	li	a1,0
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	de0080e7          	jalr	-544(ra) # 80003356 <namex>
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret

0000000080003586 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003586:	1141                	addi	sp,sp,-16
    80003588:	e406                	sd	ra,8(sp)
    8000358a:	e022                	sd	s0,0(sp)
    8000358c:	0800                	addi	s0,sp,16
    8000358e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003590:	4585                	li	a1,1
    80003592:	00000097          	auipc	ra,0x0
    80003596:	dc4080e7          	jalr	-572(ra) # 80003356 <namex>
}
    8000359a:	60a2                	ld	ra,8(sp)
    8000359c:	6402                	ld	s0,0(sp)
    8000359e:	0141                	addi	sp,sp,16
    800035a0:	8082                	ret

00000000800035a2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035a2:	1101                	addi	sp,sp,-32
    800035a4:	ec06                	sd	ra,24(sp)
    800035a6:	e822                	sd	s0,16(sp)
    800035a8:	e426                	sd	s1,8(sp)
    800035aa:	e04a                	sd	s2,0(sp)
    800035ac:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035ae:	00019917          	auipc	s2,0x19
    800035b2:	11a90913          	addi	s2,s2,282 # 8001c6c8 <log>
    800035b6:	02092583          	lw	a1,32(s2)
    800035ba:	03092503          	lw	a0,48(s2)
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	e42080e7          	jalr	-446(ra) # 80002400 <bread>
    800035c6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035c8:	03492603          	lw	a2,52(s2)
    800035cc:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035ce:	00c05f63          	blez	a2,800035ec <write_head+0x4a>
    800035d2:	00019717          	auipc	a4,0x19
    800035d6:	12e70713          	addi	a4,a4,302 # 8001c700 <log+0x38>
    800035da:	87aa                	mv	a5,a0
    800035dc:	060a                	slli	a2,a2,0x2
    800035de:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035e0:	4314                	lw	a3,0(a4)
    800035e2:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035e4:	0711                	addi	a4,a4,4
    800035e6:	0791                	addi	a5,a5,4
    800035e8:	fec79ce3          	bne	a5,a2,800035e0 <write_head+0x3e>
  }
  bwrite(buf);
    800035ec:	8526                	mv	a0,s1
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	07c080e7          	jalr	124(ra) # 8000266a <bwrite>
  brelse(buf);
    800035f6:	8526                	mv	a0,s1
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	0b0080e7          	jalr	176(ra) # 800026a8 <brelse>
}
    80003600:	60e2                	ld	ra,24(sp)
    80003602:	6442                	ld	s0,16(sp)
    80003604:	64a2                	ld	s1,8(sp)
    80003606:	6902                	ld	s2,0(sp)
    80003608:	6105                	addi	sp,sp,32
    8000360a:	8082                	ret

000000008000360c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360c:	00019797          	auipc	a5,0x19
    80003610:	0f07a783          	lw	a5,240(a5) # 8001c6fc <log+0x34>
    80003614:	0af05d63          	blez	a5,800036ce <install_trans+0xc2>
{
    80003618:	7139                	addi	sp,sp,-64
    8000361a:	fc06                	sd	ra,56(sp)
    8000361c:	f822                	sd	s0,48(sp)
    8000361e:	f426                	sd	s1,40(sp)
    80003620:	f04a                	sd	s2,32(sp)
    80003622:	ec4e                	sd	s3,24(sp)
    80003624:	e852                	sd	s4,16(sp)
    80003626:	e456                	sd	s5,8(sp)
    80003628:	e05a                	sd	s6,0(sp)
    8000362a:	0080                	addi	s0,sp,64
    8000362c:	8b2a                	mv	s6,a0
    8000362e:	00019a97          	auipc	s5,0x19
    80003632:	0d2a8a93          	addi	s5,s5,210 # 8001c700 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003636:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003638:	00019997          	auipc	s3,0x19
    8000363c:	09098993          	addi	s3,s3,144 # 8001c6c8 <log>
    80003640:	a00d                	j	80003662 <install_trans+0x56>
    brelse(lbuf);
    80003642:	854a                	mv	a0,s2
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	064080e7          	jalr	100(ra) # 800026a8 <brelse>
    brelse(dbuf);
    8000364c:	8526                	mv	a0,s1
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	05a080e7          	jalr	90(ra) # 800026a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003656:	2a05                	addiw	s4,s4,1
    80003658:	0a91                	addi	s5,s5,4
    8000365a:	0349a783          	lw	a5,52(s3)
    8000365e:	04fa5e63          	bge	s4,a5,800036ba <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003662:	0209a583          	lw	a1,32(s3)
    80003666:	014585bb          	addw	a1,a1,s4
    8000366a:	2585                	addiw	a1,a1,1
    8000366c:	0309a503          	lw	a0,48(s3)
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	d90080e7          	jalr	-624(ra) # 80002400 <bread>
    80003678:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000367a:	000aa583          	lw	a1,0(s5)
    8000367e:	0309a503          	lw	a0,48(s3)
    80003682:	fffff097          	auipc	ra,0xfffff
    80003686:	d7e080e7          	jalr	-642(ra) # 80002400 <bread>
    8000368a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000368c:	40000613          	li	a2,1024
    80003690:	06090593          	addi	a1,s2,96
    80003694:	06050513          	addi	a0,a0,96
    80003698:	ffffd097          	auipc	ra,0xffffd
    8000369c:	c26080e7          	jalr	-986(ra) # 800002be <memmove>
    bwrite(dbuf);  // write dst to disk
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	fc8080e7          	jalr	-56(ra) # 8000266a <bwrite>
    if(recovering == 0)
    800036aa:	f80b1ce3          	bnez	s6,80003642 <install_trans+0x36>
      bunpin(dbuf);
    800036ae:	8526                	mv	a0,s1
    800036b0:	fffff097          	auipc	ra,0xfffff
    800036b4:	0de080e7          	jalr	222(ra) # 8000278e <bunpin>
    800036b8:	b769                	j	80003642 <install_trans+0x36>
}
    800036ba:	70e2                	ld	ra,56(sp)
    800036bc:	7442                	ld	s0,48(sp)
    800036be:	74a2                	ld	s1,40(sp)
    800036c0:	7902                	ld	s2,32(sp)
    800036c2:	69e2                	ld	s3,24(sp)
    800036c4:	6a42                	ld	s4,16(sp)
    800036c6:	6aa2                	ld	s5,8(sp)
    800036c8:	6b02                	ld	s6,0(sp)
    800036ca:	6121                	addi	sp,sp,64
    800036cc:	8082                	ret
    800036ce:	8082                	ret

00000000800036d0 <initlog>:
{
    800036d0:	7179                	addi	sp,sp,-48
    800036d2:	f406                	sd	ra,40(sp)
    800036d4:	f022                	sd	s0,32(sp)
    800036d6:	ec26                	sd	s1,24(sp)
    800036d8:	e84a                	sd	s2,16(sp)
    800036da:	e44e                	sd	s3,8(sp)
    800036dc:	1800                	addi	s0,sp,48
    800036de:	892a                	mv	s2,a0
    800036e0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036e2:	00019497          	auipc	s1,0x19
    800036e6:	fe648493          	addi	s1,s1,-26 # 8001c6c8 <log>
    800036ea:	00005597          	auipc	a1,0x5
    800036ee:	ebe58593          	addi	a1,a1,-322 # 800085a8 <syscalls+0x1d8>
    800036f2:	8526                	mv	a0,s1
    800036f4:	00003097          	auipc	ra,0x3
    800036f8:	10c080e7          	jalr	268(ra) # 80006800 <initlock>
  log.start = sb->logstart;
    800036fc:	0149a583          	lw	a1,20(s3)
    80003700:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003702:	0109a783          	lw	a5,16(s3)
    80003706:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    80003708:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000370c:	854a                	mv	a0,s2
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	cf2080e7          	jalr	-782(ra) # 80002400 <bread>
  log.lh.n = lh->n;
    80003716:	5130                	lw	a2,96(a0)
    80003718:	d8d0                	sw	a2,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000371a:	00c05f63          	blez	a2,80003738 <initlog+0x68>
    8000371e:	87aa                	mv	a5,a0
    80003720:	00019717          	auipc	a4,0x19
    80003724:	fe070713          	addi	a4,a4,-32 # 8001c700 <log+0x38>
    80003728:	060a                	slli	a2,a2,0x2
    8000372a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000372c:	53f4                	lw	a3,100(a5)
    8000372e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003730:	0791                	addi	a5,a5,4
    80003732:	0711                	addi	a4,a4,4
    80003734:	fec79ce3          	bne	a5,a2,8000372c <initlog+0x5c>
  brelse(buf);
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	f70080e7          	jalr	-144(ra) # 800026a8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003740:	4505                	li	a0,1
    80003742:	00000097          	auipc	ra,0x0
    80003746:	eca080e7          	jalr	-310(ra) # 8000360c <install_trans>
  log.lh.n = 0;
    8000374a:	00019797          	auipc	a5,0x19
    8000374e:	fa07a923          	sw	zero,-78(a5) # 8001c6fc <log+0x34>
  write_head(); // clear the log
    80003752:	00000097          	auipc	ra,0x0
    80003756:	e50080e7          	jalr	-432(ra) # 800035a2 <write_head>
}
    8000375a:	70a2                	ld	ra,40(sp)
    8000375c:	7402                	ld	s0,32(sp)
    8000375e:	64e2                	ld	s1,24(sp)
    80003760:	6942                	ld	s2,16(sp)
    80003762:	69a2                	ld	s3,8(sp)
    80003764:	6145                	addi	sp,sp,48
    80003766:	8082                	ret

0000000080003768 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003768:	1101                	addi	sp,sp,-32
    8000376a:	ec06                	sd	ra,24(sp)
    8000376c:	e822                	sd	s0,16(sp)
    8000376e:	e426                	sd	s1,8(sp)
    80003770:	e04a                	sd	s2,0(sp)
    80003772:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003774:	00019517          	auipc	a0,0x19
    80003778:	f5450513          	addi	a0,a0,-172 # 8001c6c8 <log>
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	f08080e7          	jalr	-248(ra) # 80006684 <acquire>
  while(1){
    if(log.committing){
    80003784:	00019497          	auipc	s1,0x19
    80003788:	f4448493          	addi	s1,s1,-188 # 8001c6c8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000378c:	4979                	li	s2,30
    8000378e:	a039                	j	8000379c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003790:	85a6                	mv	a1,s1
    80003792:	8526                	mv	a0,s1
    80003794:	ffffe097          	auipc	ra,0xffffe
    80003798:	e5e080e7          	jalr	-418(ra) # 800015f2 <sleep>
    if(log.committing){
    8000379c:	54dc                	lw	a5,44(s1)
    8000379e:	fbed                	bnez	a5,80003790 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a0:	5498                	lw	a4,40(s1)
    800037a2:	2705                	addiw	a4,a4,1
    800037a4:	0027179b          	slliw	a5,a4,0x2
    800037a8:	9fb9                	addw	a5,a5,a4
    800037aa:	0017979b          	slliw	a5,a5,0x1
    800037ae:	58d4                	lw	a3,52(s1)
    800037b0:	9fb5                	addw	a5,a5,a3
    800037b2:	00f95963          	bge	s2,a5,800037c4 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037b6:	85a6                	mv	a1,s1
    800037b8:	8526                	mv	a0,s1
    800037ba:	ffffe097          	auipc	ra,0xffffe
    800037be:	e38080e7          	jalr	-456(ra) # 800015f2 <sleep>
    800037c2:	bfe9                	j	8000379c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037c4:	00019517          	auipc	a0,0x19
    800037c8:	f0450513          	addi	a0,a0,-252 # 8001c6c8 <log>
    800037cc:	d518                	sw	a4,40(a0)
      release(&log.lock);
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	f86080e7          	jalr	-122(ra) # 80006754 <release>
      break;
    }
  }
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret

00000000800037e2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037e2:	7139                	addi	sp,sp,-64
    800037e4:	fc06                	sd	ra,56(sp)
    800037e6:	f822                	sd	s0,48(sp)
    800037e8:	f426                	sd	s1,40(sp)
    800037ea:	f04a                	sd	s2,32(sp)
    800037ec:	ec4e                	sd	s3,24(sp)
    800037ee:	e852                	sd	s4,16(sp)
    800037f0:	e456                	sd	s5,8(sp)
    800037f2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037f4:	00019497          	auipc	s1,0x19
    800037f8:	ed448493          	addi	s1,s1,-300 # 8001c6c8 <log>
    800037fc:	8526                	mv	a0,s1
    800037fe:	00003097          	auipc	ra,0x3
    80003802:	e86080e7          	jalr	-378(ra) # 80006684 <acquire>
  log.outstanding -= 1;
    80003806:	549c                	lw	a5,40(s1)
    80003808:	37fd                	addiw	a5,a5,-1
    8000380a:	0007891b          	sext.w	s2,a5
    8000380e:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003810:	54dc                	lw	a5,44(s1)
    80003812:	e7b9                	bnez	a5,80003860 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003814:	04091e63          	bnez	s2,80003870 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003818:	00019497          	auipc	s1,0x19
    8000381c:	eb048493          	addi	s1,s1,-336 # 8001c6c8 <log>
    80003820:	4785                	li	a5,1
    80003822:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003824:	8526                	mv	a0,s1
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	f2e080e7          	jalr	-210(ra) # 80006754 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000382e:	58dc                	lw	a5,52(s1)
    80003830:	06f04763          	bgtz	a5,8000389e <end_op+0xbc>
    acquire(&log.lock);
    80003834:	00019497          	auipc	s1,0x19
    80003838:	e9448493          	addi	s1,s1,-364 # 8001c6c8 <log>
    8000383c:	8526                	mv	a0,s1
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	e46080e7          	jalr	-442(ra) # 80006684 <acquire>
    log.committing = 0;
    80003846:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    8000384a:	8526                	mv	a0,s1
    8000384c:	ffffe097          	auipc	ra,0xffffe
    80003850:	e0a080e7          	jalr	-502(ra) # 80001656 <wakeup>
    release(&log.lock);
    80003854:	8526                	mv	a0,s1
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	efe080e7          	jalr	-258(ra) # 80006754 <release>
}
    8000385e:	a03d                	j	8000388c <end_op+0xaa>
    panic("log.committing");
    80003860:	00005517          	auipc	a0,0x5
    80003864:	d5050513          	addi	a0,a0,-688 # 800085b0 <syscalls+0x1e0>
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	8fa080e7          	jalr	-1798(ra) # 80006162 <panic>
    wakeup(&log);
    80003870:	00019497          	auipc	s1,0x19
    80003874:	e5848493          	addi	s1,s1,-424 # 8001c6c8 <log>
    80003878:	8526                	mv	a0,s1
    8000387a:	ffffe097          	auipc	ra,0xffffe
    8000387e:	ddc080e7          	jalr	-548(ra) # 80001656 <wakeup>
  release(&log.lock);
    80003882:	8526                	mv	a0,s1
    80003884:	00003097          	auipc	ra,0x3
    80003888:	ed0080e7          	jalr	-304(ra) # 80006754 <release>
}
    8000388c:	70e2                	ld	ra,56(sp)
    8000388e:	7442                	ld	s0,48(sp)
    80003890:	74a2                	ld	s1,40(sp)
    80003892:	7902                	ld	s2,32(sp)
    80003894:	69e2                	ld	s3,24(sp)
    80003896:	6a42                	ld	s4,16(sp)
    80003898:	6aa2                	ld	s5,8(sp)
    8000389a:	6121                	addi	sp,sp,64
    8000389c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000389e:	00019a97          	auipc	s5,0x19
    800038a2:	e62a8a93          	addi	s5,s5,-414 # 8001c700 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038a6:	00019a17          	auipc	s4,0x19
    800038aa:	e22a0a13          	addi	s4,s4,-478 # 8001c6c8 <log>
    800038ae:	020a2583          	lw	a1,32(s4)
    800038b2:	012585bb          	addw	a1,a1,s2
    800038b6:	2585                	addiw	a1,a1,1
    800038b8:	030a2503          	lw	a0,48(s4)
    800038bc:	fffff097          	auipc	ra,0xfffff
    800038c0:	b44080e7          	jalr	-1212(ra) # 80002400 <bread>
    800038c4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038c6:	000aa583          	lw	a1,0(s5)
    800038ca:	030a2503          	lw	a0,48(s4)
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	b32080e7          	jalr	-1230(ra) # 80002400 <bread>
    800038d6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038d8:	40000613          	li	a2,1024
    800038dc:	06050593          	addi	a1,a0,96
    800038e0:	06048513          	addi	a0,s1,96
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	9da080e7          	jalr	-1574(ra) # 800002be <memmove>
    bwrite(to);  // write the log
    800038ec:	8526                	mv	a0,s1
    800038ee:	fffff097          	auipc	ra,0xfffff
    800038f2:	d7c080e7          	jalr	-644(ra) # 8000266a <bwrite>
    brelse(from);
    800038f6:	854e                	mv	a0,s3
    800038f8:	fffff097          	auipc	ra,0xfffff
    800038fc:	db0080e7          	jalr	-592(ra) # 800026a8 <brelse>
    brelse(to);
    80003900:	8526                	mv	a0,s1
    80003902:	fffff097          	auipc	ra,0xfffff
    80003906:	da6080e7          	jalr	-602(ra) # 800026a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000390a:	2905                	addiw	s2,s2,1
    8000390c:	0a91                	addi	s5,s5,4
    8000390e:	034a2783          	lw	a5,52(s4)
    80003912:	f8f94ee3          	blt	s2,a5,800038ae <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003916:	00000097          	auipc	ra,0x0
    8000391a:	c8c080e7          	jalr	-884(ra) # 800035a2 <write_head>
    install_trans(0); // Now install writes to home locations
    8000391e:	4501                	li	a0,0
    80003920:	00000097          	auipc	ra,0x0
    80003924:	cec080e7          	jalr	-788(ra) # 8000360c <install_trans>
    log.lh.n = 0;
    80003928:	00019797          	auipc	a5,0x19
    8000392c:	dc07aa23          	sw	zero,-556(a5) # 8001c6fc <log+0x34>
    write_head();    // Erase the transaction from the log
    80003930:	00000097          	auipc	ra,0x0
    80003934:	c72080e7          	jalr	-910(ra) # 800035a2 <write_head>
    80003938:	bdf5                	j	80003834 <end_op+0x52>

000000008000393a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000393a:	1101                	addi	sp,sp,-32
    8000393c:	ec06                	sd	ra,24(sp)
    8000393e:	e822                	sd	s0,16(sp)
    80003940:	e426                	sd	s1,8(sp)
    80003942:	e04a                	sd	s2,0(sp)
    80003944:	1000                	addi	s0,sp,32
    80003946:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003948:	00019917          	auipc	s2,0x19
    8000394c:	d8090913          	addi	s2,s2,-640 # 8001c6c8 <log>
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	d32080e7          	jalr	-718(ra) # 80006684 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000395a:	03492603          	lw	a2,52(s2)
    8000395e:	47f5                	li	a5,29
    80003960:	06c7c563          	blt	a5,a2,800039ca <log_write+0x90>
    80003964:	00019797          	auipc	a5,0x19
    80003968:	d887a783          	lw	a5,-632(a5) # 8001c6ec <log+0x24>
    8000396c:	37fd                	addiw	a5,a5,-1
    8000396e:	04f65e63          	bge	a2,a5,800039ca <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003972:	00019797          	auipc	a5,0x19
    80003976:	d7e7a783          	lw	a5,-642(a5) # 8001c6f0 <log+0x28>
    8000397a:	06f05063          	blez	a5,800039da <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000397e:	4781                	li	a5,0
    80003980:	06c05563          	blez	a2,800039ea <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003984:	44cc                	lw	a1,12(s1)
    80003986:	00019717          	auipc	a4,0x19
    8000398a:	d7a70713          	addi	a4,a4,-646 # 8001c700 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    8000398e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003990:	4314                	lw	a3,0(a4)
    80003992:	04b68c63          	beq	a3,a1,800039ea <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003996:	2785                	addiw	a5,a5,1
    80003998:	0711                	addi	a4,a4,4
    8000399a:	fef61be3          	bne	a2,a5,80003990 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000399e:	0631                	addi	a2,a2,12
    800039a0:	060a                	slli	a2,a2,0x2
    800039a2:	00019797          	auipc	a5,0x19
    800039a6:	d2678793          	addi	a5,a5,-730 # 8001c6c8 <log>
    800039aa:	97b2                	add	a5,a5,a2
    800039ac:	44d8                	lw	a4,12(s1)
    800039ae:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039b0:	8526                	mv	a0,s1
    800039b2:	fffff097          	auipc	ra,0xfffff
    800039b6:	d88080e7          	jalr	-632(ra) # 8000273a <bpin>
    log.lh.n++;
    800039ba:	00019717          	auipc	a4,0x19
    800039be:	d0e70713          	addi	a4,a4,-754 # 8001c6c8 <log>
    800039c2:	5b5c                	lw	a5,52(a4)
    800039c4:	2785                	addiw	a5,a5,1
    800039c6:	db5c                	sw	a5,52(a4)
    800039c8:	a82d                	j	80003a02 <log_write+0xc8>
    panic("too big a transaction");
    800039ca:	00005517          	auipc	a0,0x5
    800039ce:	bf650513          	addi	a0,a0,-1034 # 800085c0 <syscalls+0x1f0>
    800039d2:	00002097          	auipc	ra,0x2
    800039d6:	790080e7          	jalr	1936(ra) # 80006162 <panic>
    panic("log_write outside of trans");
    800039da:	00005517          	auipc	a0,0x5
    800039de:	bfe50513          	addi	a0,a0,-1026 # 800085d8 <syscalls+0x208>
    800039e2:	00002097          	auipc	ra,0x2
    800039e6:	780080e7          	jalr	1920(ra) # 80006162 <panic>
  log.lh.block[i] = b->blockno;
    800039ea:	00c78693          	addi	a3,a5,12
    800039ee:	068a                	slli	a3,a3,0x2
    800039f0:	00019717          	auipc	a4,0x19
    800039f4:	cd870713          	addi	a4,a4,-808 # 8001c6c8 <log>
    800039f8:	9736                	add	a4,a4,a3
    800039fa:	44d4                	lw	a3,12(s1)
    800039fc:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039fe:	faf609e3          	beq	a2,a5,800039b0 <log_write+0x76>
  }
  release(&log.lock);
    80003a02:	00019517          	auipc	a0,0x19
    80003a06:	cc650513          	addi	a0,a0,-826 # 8001c6c8 <log>
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	d4a080e7          	jalr	-694(ra) # 80006754 <release>
}
    80003a12:	60e2                	ld	ra,24(sp)
    80003a14:	6442                	ld	s0,16(sp)
    80003a16:	64a2                	ld	s1,8(sp)
    80003a18:	6902                	ld	s2,0(sp)
    80003a1a:	6105                	addi	sp,sp,32
    80003a1c:	8082                	ret

0000000080003a1e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a1e:	1101                	addi	sp,sp,-32
    80003a20:	ec06                	sd	ra,24(sp)
    80003a22:	e822                	sd	s0,16(sp)
    80003a24:	e426                	sd	s1,8(sp)
    80003a26:	e04a                	sd	s2,0(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
    80003a2c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a2e:	00005597          	auipc	a1,0x5
    80003a32:	bca58593          	addi	a1,a1,-1078 # 800085f8 <syscalls+0x228>
    80003a36:	0521                	addi	a0,a0,8
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	dc8080e7          	jalr	-568(ra) # 80006800 <initlock>
  lk->name = name;
    80003a40:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a44:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a48:	0204a823          	sw	zero,48(s1)
}
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6902                	ld	s2,0(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
    80003a70:	c18080e7          	jalr	-1000(ra) # 80006684 <acquire>
  while (lk->locked) {
    80003a74:	409c                	lw	a5,0(s1)
    80003a76:	cb89                	beqz	a5,80003a88 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a78:	85ca                	mv	a1,s2
    80003a7a:	8526                	mv	a0,s1
    80003a7c:	ffffe097          	auipc	ra,0xffffe
    80003a80:	b76080e7          	jalr	-1162(ra) # 800015f2 <sleep>
  while (lk->locked) {
    80003a84:	409c                	lw	a5,0(s1)
    80003a86:	fbed                	bnez	a5,80003a78 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a88:	4785                	li	a5,1
    80003a8a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	4be080e7          	jalr	1214(ra) # 80000f4a <myproc>
    80003a94:	5d1c                	lw	a5,56(a0)
    80003a96:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a98:	854a                	mv	a0,s2
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	cba080e7          	jalr	-838(ra) # 80006754 <release>
}
    80003aa2:	60e2                	ld	ra,24(sp)
    80003aa4:	6442                	ld	s0,16(sp)
    80003aa6:	64a2                	ld	s1,8(sp)
    80003aa8:	6902                	ld	s2,0(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	e04a                	sd	s2,0(sp)
    80003ab8:	1000                	addi	s0,sp,32
    80003aba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003abc:	00850913          	addi	s2,a0,8
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	bc2080e7          	jalr	-1086(ra) # 80006684 <acquire>
  lk->locked = 0;
    80003aca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ace:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003ad2:	8526                	mv	a0,s1
    80003ad4:	ffffe097          	auipc	ra,0xffffe
    80003ad8:	b82080e7          	jalr	-1150(ra) # 80001656 <wakeup>
  release(&lk->lk);
    80003adc:	854a                	mv	a0,s2
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	c76080e7          	jalr	-906(ra) # 80006754 <release>
}
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6902                	ld	s2,0(sp)
    80003aee:	6105                	addi	sp,sp,32
    80003af0:	8082                	ret

0000000080003af2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003af2:	7179                	addi	sp,sp,-48
    80003af4:	f406                	sd	ra,40(sp)
    80003af6:	f022                	sd	s0,32(sp)
    80003af8:	ec26                	sd	s1,24(sp)
    80003afa:	e84a                	sd	s2,16(sp)
    80003afc:	e44e                	sd	s3,8(sp)
    80003afe:	1800                	addi	s0,sp,48
    80003b00:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b02:	00850913          	addi	s2,a0,8
    80003b06:	854a                	mv	a0,s2
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	b7c080e7          	jalr	-1156(ra) # 80006684 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b10:	409c                	lw	a5,0(s1)
    80003b12:	ef99                	bnez	a5,80003b30 <holdingsleep+0x3e>
    80003b14:	4481                	li	s1,0
  release(&lk->lk);
    80003b16:	854a                	mv	a0,s2
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	c3c080e7          	jalr	-964(ra) # 80006754 <release>
  return r;
}
    80003b20:	8526                	mv	a0,s1
    80003b22:	70a2                	ld	ra,40(sp)
    80003b24:	7402                	ld	s0,32(sp)
    80003b26:	64e2                	ld	s1,24(sp)
    80003b28:	6942                	ld	s2,16(sp)
    80003b2a:	69a2                	ld	s3,8(sp)
    80003b2c:	6145                	addi	sp,sp,48
    80003b2e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b30:	0304a983          	lw	s3,48(s1)
    80003b34:	ffffd097          	auipc	ra,0xffffd
    80003b38:	416080e7          	jalr	1046(ra) # 80000f4a <myproc>
    80003b3c:	5d04                	lw	s1,56(a0)
    80003b3e:	413484b3          	sub	s1,s1,s3
    80003b42:	0014b493          	seqz	s1,s1
    80003b46:	bfc1                	j	80003b16 <holdingsleep+0x24>

0000000080003b48 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b48:	1141                	addi	sp,sp,-16
    80003b4a:	e406                	sd	ra,8(sp)
    80003b4c:	e022                	sd	s0,0(sp)
    80003b4e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b50:	00005597          	auipc	a1,0x5
    80003b54:	ab858593          	addi	a1,a1,-1352 # 80008608 <syscalls+0x238>
    80003b58:	00019517          	auipc	a0,0x19
    80003b5c:	cc050513          	addi	a0,a0,-832 # 8001c818 <ftable>
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	ca0080e7          	jalr	-864(ra) # 80006800 <initlock>
}
    80003b68:	60a2                	ld	ra,8(sp)
    80003b6a:	6402                	ld	s0,0(sp)
    80003b6c:	0141                	addi	sp,sp,16
    80003b6e:	8082                	ret

0000000080003b70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b70:	1101                	addi	sp,sp,-32
    80003b72:	ec06                	sd	ra,24(sp)
    80003b74:	e822                	sd	s0,16(sp)
    80003b76:	e426                	sd	s1,8(sp)
    80003b78:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b7a:	00019517          	auipc	a0,0x19
    80003b7e:	c9e50513          	addi	a0,a0,-866 # 8001c818 <ftable>
    80003b82:	00003097          	auipc	ra,0x3
    80003b86:	b02080e7          	jalr	-1278(ra) # 80006684 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b8a:	00019497          	auipc	s1,0x19
    80003b8e:	cae48493          	addi	s1,s1,-850 # 8001c838 <ftable+0x20>
    80003b92:	0001a717          	auipc	a4,0x1a
    80003b96:	c4670713          	addi	a4,a4,-954 # 8001d7d8 <disk>
    if(f->ref == 0){
    80003b9a:	40dc                	lw	a5,4(s1)
    80003b9c:	cf99                	beqz	a5,80003bba <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b9e:	02848493          	addi	s1,s1,40
    80003ba2:	fee49ce3          	bne	s1,a4,80003b9a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ba6:	00019517          	auipc	a0,0x19
    80003baa:	c7250513          	addi	a0,a0,-910 # 8001c818 <ftable>
    80003bae:	00003097          	auipc	ra,0x3
    80003bb2:	ba6080e7          	jalr	-1114(ra) # 80006754 <release>
  return 0;
    80003bb6:	4481                	li	s1,0
    80003bb8:	a819                	j	80003bce <filealloc+0x5e>
      f->ref = 1;
    80003bba:	4785                	li	a5,1
    80003bbc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bbe:	00019517          	auipc	a0,0x19
    80003bc2:	c5a50513          	addi	a0,a0,-934 # 8001c818 <ftable>
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	b8e080e7          	jalr	-1138(ra) # 80006754 <release>
}
    80003bce:	8526                	mv	a0,s1
    80003bd0:	60e2                	ld	ra,24(sp)
    80003bd2:	6442                	ld	s0,16(sp)
    80003bd4:	64a2                	ld	s1,8(sp)
    80003bd6:	6105                	addi	sp,sp,32
    80003bd8:	8082                	ret

0000000080003bda <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bda:	1101                	addi	sp,sp,-32
    80003bdc:	ec06                	sd	ra,24(sp)
    80003bde:	e822                	sd	s0,16(sp)
    80003be0:	e426                	sd	s1,8(sp)
    80003be2:	1000                	addi	s0,sp,32
    80003be4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003be6:	00019517          	auipc	a0,0x19
    80003bea:	c3250513          	addi	a0,a0,-974 # 8001c818 <ftable>
    80003bee:	00003097          	auipc	ra,0x3
    80003bf2:	a96080e7          	jalr	-1386(ra) # 80006684 <acquire>
  if(f->ref < 1)
    80003bf6:	40dc                	lw	a5,4(s1)
    80003bf8:	02f05263          	blez	a5,80003c1c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bfc:	2785                	addiw	a5,a5,1
    80003bfe:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c00:	00019517          	auipc	a0,0x19
    80003c04:	c1850513          	addi	a0,a0,-1000 # 8001c818 <ftable>
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	b4c080e7          	jalr	-1204(ra) # 80006754 <release>
  return f;
}
    80003c10:	8526                	mv	a0,s1
    80003c12:	60e2                	ld	ra,24(sp)
    80003c14:	6442                	ld	s0,16(sp)
    80003c16:	64a2                	ld	s1,8(sp)
    80003c18:	6105                	addi	sp,sp,32
    80003c1a:	8082                	ret
    panic("filedup");
    80003c1c:	00005517          	auipc	a0,0x5
    80003c20:	9f450513          	addi	a0,a0,-1548 # 80008610 <syscalls+0x240>
    80003c24:	00002097          	auipc	ra,0x2
    80003c28:	53e080e7          	jalr	1342(ra) # 80006162 <panic>

0000000080003c2c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c2c:	7139                	addi	sp,sp,-64
    80003c2e:	fc06                	sd	ra,56(sp)
    80003c30:	f822                	sd	s0,48(sp)
    80003c32:	f426                	sd	s1,40(sp)
    80003c34:	f04a                	sd	s2,32(sp)
    80003c36:	ec4e                	sd	s3,24(sp)
    80003c38:	e852                	sd	s4,16(sp)
    80003c3a:	e456                	sd	s5,8(sp)
    80003c3c:	0080                	addi	s0,sp,64
    80003c3e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c40:	00019517          	auipc	a0,0x19
    80003c44:	bd850513          	addi	a0,a0,-1064 # 8001c818 <ftable>
    80003c48:	00003097          	auipc	ra,0x3
    80003c4c:	a3c080e7          	jalr	-1476(ra) # 80006684 <acquire>
  if(f->ref < 1)
    80003c50:	40dc                	lw	a5,4(s1)
    80003c52:	06f05163          	blez	a5,80003cb4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c56:	37fd                	addiw	a5,a5,-1
    80003c58:	0007871b          	sext.w	a4,a5
    80003c5c:	c0dc                	sw	a5,4(s1)
    80003c5e:	06e04363          	bgtz	a4,80003cc4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c62:	0004a903          	lw	s2,0(s1)
    80003c66:	0094ca83          	lbu	s5,9(s1)
    80003c6a:	0104ba03          	ld	s4,16(s1)
    80003c6e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c72:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c76:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c7a:	00019517          	auipc	a0,0x19
    80003c7e:	b9e50513          	addi	a0,a0,-1122 # 8001c818 <ftable>
    80003c82:	00003097          	auipc	ra,0x3
    80003c86:	ad2080e7          	jalr	-1326(ra) # 80006754 <release>

  if(ff.type == FD_PIPE){
    80003c8a:	4785                	li	a5,1
    80003c8c:	04f90d63          	beq	s2,a5,80003ce6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c90:	3979                	addiw	s2,s2,-2
    80003c92:	4785                	li	a5,1
    80003c94:	0527e063          	bltu	a5,s2,80003cd4 <fileclose+0xa8>
    begin_op();
    80003c98:	00000097          	auipc	ra,0x0
    80003c9c:	ad0080e7          	jalr	-1328(ra) # 80003768 <begin_op>
    iput(ff.ip);
    80003ca0:	854e                	mv	a0,s3
    80003ca2:	fffff097          	auipc	ra,0xfffff
    80003ca6:	2da080e7          	jalr	730(ra) # 80002f7c <iput>
    end_op();
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	b38080e7          	jalr	-1224(ra) # 800037e2 <end_op>
    80003cb2:	a00d                	j	80003cd4 <fileclose+0xa8>
    panic("fileclose");
    80003cb4:	00005517          	auipc	a0,0x5
    80003cb8:	96450513          	addi	a0,a0,-1692 # 80008618 <syscalls+0x248>
    80003cbc:	00002097          	auipc	ra,0x2
    80003cc0:	4a6080e7          	jalr	1190(ra) # 80006162 <panic>
    release(&ftable.lock);
    80003cc4:	00019517          	auipc	a0,0x19
    80003cc8:	b5450513          	addi	a0,a0,-1196 # 8001c818 <ftable>
    80003ccc:	00003097          	auipc	ra,0x3
    80003cd0:	a88080e7          	jalr	-1400(ra) # 80006754 <release>
  }
}
    80003cd4:	70e2                	ld	ra,56(sp)
    80003cd6:	7442                	ld	s0,48(sp)
    80003cd8:	74a2                	ld	s1,40(sp)
    80003cda:	7902                	ld	s2,32(sp)
    80003cdc:	69e2                	ld	s3,24(sp)
    80003cde:	6a42                	ld	s4,16(sp)
    80003ce0:	6aa2                	ld	s5,8(sp)
    80003ce2:	6121                	addi	sp,sp,64
    80003ce4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ce6:	85d6                	mv	a1,s5
    80003ce8:	8552                	mv	a0,s4
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	348080e7          	jalr	840(ra) # 80004032 <pipeclose>
    80003cf2:	b7cd                	j	80003cd4 <fileclose+0xa8>

0000000080003cf4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cf4:	715d                	addi	sp,sp,-80
    80003cf6:	e486                	sd	ra,72(sp)
    80003cf8:	e0a2                	sd	s0,64(sp)
    80003cfa:	fc26                	sd	s1,56(sp)
    80003cfc:	f84a                	sd	s2,48(sp)
    80003cfe:	f44e                	sd	s3,40(sp)
    80003d00:	0880                	addi	s0,sp,80
    80003d02:	84aa                	mv	s1,a0
    80003d04:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	244080e7          	jalr	580(ra) # 80000f4a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d0e:	409c                	lw	a5,0(s1)
    80003d10:	37f9                	addiw	a5,a5,-2
    80003d12:	4705                	li	a4,1
    80003d14:	04f76763          	bltu	a4,a5,80003d62 <filestat+0x6e>
    80003d18:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d1a:	6c88                	ld	a0,24(s1)
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	092080e7          	jalr	146(ra) # 80002dae <ilock>
    stati(f->ip, &st);
    80003d24:	fb840593          	addi	a1,s0,-72
    80003d28:	6c88                	ld	a0,24(s1)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	322080e7          	jalr	802(ra) # 8000304c <stati>
    iunlock(f->ip);
    80003d32:	6c88                	ld	a0,24(s1)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	146080e7          	jalr	326(ra) # 80002e7a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d3c:	46e1                	li	a3,24
    80003d3e:	fb840613          	addi	a2,s0,-72
    80003d42:	85ce                	mv	a1,s3
    80003d44:	05893503          	ld	a0,88(s2)
    80003d48:	ffffd097          	auipc	ra,0xffffd
    80003d4c:	ec2080e7          	jalr	-318(ra) # 80000c0a <copyout>
    80003d50:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d54:	60a6                	ld	ra,72(sp)
    80003d56:	6406                	ld	s0,64(sp)
    80003d58:	74e2                	ld	s1,56(sp)
    80003d5a:	7942                	ld	s2,48(sp)
    80003d5c:	79a2                	ld	s3,40(sp)
    80003d5e:	6161                	addi	sp,sp,80
    80003d60:	8082                	ret
  return -1;
    80003d62:	557d                	li	a0,-1
    80003d64:	bfc5                	j	80003d54 <filestat+0x60>

0000000080003d66 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d66:	7179                	addi	sp,sp,-48
    80003d68:	f406                	sd	ra,40(sp)
    80003d6a:	f022                	sd	s0,32(sp)
    80003d6c:	ec26                	sd	s1,24(sp)
    80003d6e:	e84a                	sd	s2,16(sp)
    80003d70:	e44e                	sd	s3,8(sp)
    80003d72:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d74:	00854783          	lbu	a5,8(a0)
    80003d78:	c3d5                	beqz	a5,80003e1c <fileread+0xb6>
    80003d7a:	84aa                	mv	s1,a0
    80003d7c:	89ae                	mv	s3,a1
    80003d7e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d80:	411c                	lw	a5,0(a0)
    80003d82:	4705                	li	a4,1
    80003d84:	04e78963          	beq	a5,a4,80003dd6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d88:	470d                	li	a4,3
    80003d8a:	04e78d63          	beq	a5,a4,80003de4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d8e:	4709                	li	a4,2
    80003d90:	06e79e63          	bne	a5,a4,80003e0c <fileread+0xa6>
    ilock(f->ip);
    80003d94:	6d08                	ld	a0,24(a0)
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	018080e7          	jalr	24(ra) # 80002dae <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d9e:	874a                	mv	a4,s2
    80003da0:	5094                	lw	a3,32(s1)
    80003da2:	864e                	mv	a2,s3
    80003da4:	4585                	li	a1,1
    80003da6:	6c88                	ld	a0,24(s1)
    80003da8:	fffff097          	auipc	ra,0xfffff
    80003dac:	2ce080e7          	jalr	718(ra) # 80003076 <readi>
    80003db0:	892a                	mv	s2,a0
    80003db2:	00a05563          	blez	a0,80003dbc <fileread+0x56>
      f->off += r;
    80003db6:	509c                	lw	a5,32(s1)
    80003db8:	9fa9                	addw	a5,a5,a0
    80003dba:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dbc:	6c88                	ld	a0,24(s1)
    80003dbe:	fffff097          	auipc	ra,0xfffff
    80003dc2:	0bc080e7          	jalr	188(ra) # 80002e7a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003dc6:	854a                	mv	a0,s2
    80003dc8:	70a2                	ld	ra,40(sp)
    80003dca:	7402                	ld	s0,32(sp)
    80003dcc:	64e2                	ld	s1,24(sp)
    80003dce:	6942                	ld	s2,16(sp)
    80003dd0:	69a2                	ld	s3,8(sp)
    80003dd2:	6145                	addi	sp,sp,48
    80003dd4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dd6:	6908                	ld	a0,16(a0)
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	3cc080e7          	jalr	972(ra) # 800041a4 <piperead>
    80003de0:	892a                	mv	s2,a0
    80003de2:	b7d5                	j	80003dc6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003de4:	02451783          	lh	a5,36(a0)
    80003de8:	03079693          	slli	a3,a5,0x30
    80003dec:	92c1                	srli	a3,a3,0x30
    80003dee:	4725                	li	a4,9
    80003df0:	02d76863          	bltu	a4,a3,80003e20 <fileread+0xba>
    80003df4:	0792                	slli	a5,a5,0x4
    80003df6:	00019717          	auipc	a4,0x19
    80003dfa:	98270713          	addi	a4,a4,-1662 # 8001c778 <devsw>
    80003dfe:	97ba                	add	a5,a5,a4
    80003e00:	639c                	ld	a5,0(a5)
    80003e02:	c38d                	beqz	a5,80003e24 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e04:	4505                	li	a0,1
    80003e06:	9782                	jalr	a5
    80003e08:	892a                	mv	s2,a0
    80003e0a:	bf75                	j	80003dc6 <fileread+0x60>
    panic("fileread");
    80003e0c:	00005517          	auipc	a0,0x5
    80003e10:	81c50513          	addi	a0,a0,-2020 # 80008628 <syscalls+0x258>
    80003e14:	00002097          	auipc	ra,0x2
    80003e18:	34e080e7          	jalr	846(ra) # 80006162 <panic>
    return -1;
    80003e1c:	597d                	li	s2,-1
    80003e1e:	b765                	j	80003dc6 <fileread+0x60>
      return -1;
    80003e20:	597d                	li	s2,-1
    80003e22:	b755                	j	80003dc6 <fileread+0x60>
    80003e24:	597d                	li	s2,-1
    80003e26:	b745                	j	80003dc6 <fileread+0x60>

0000000080003e28 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e28:	00954783          	lbu	a5,9(a0)
    80003e2c:	10078e63          	beqz	a5,80003f48 <filewrite+0x120>
{
    80003e30:	715d                	addi	sp,sp,-80
    80003e32:	e486                	sd	ra,72(sp)
    80003e34:	e0a2                	sd	s0,64(sp)
    80003e36:	fc26                	sd	s1,56(sp)
    80003e38:	f84a                	sd	s2,48(sp)
    80003e3a:	f44e                	sd	s3,40(sp)
    80003e3c:	f052                	sd	s4,32(sp)
    80003e3e:	ec56                	sd	s5,24(sp)
    80003e40:	e85a                	sd	s6,16(sp)
    80003e42:	e45e                	sd	s7,8(sp)
    80003e44:	e062                	sd	s8,0(sp)
    80003e46:	0880                	addi	s0,sp,80
    80003e48:	892a                	mv	s2,a0
    80003e4a:	8b2e                	mv	s6,a1
    80003e4c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e4e:	411c                	lw	a5,0(a0)
    80003e50:	4705                	li	a4,1
    80003e52:	02e78263          	beq	a5,a4,80003e76 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e56:	470d                	li	a4,3
    80003e58:	02e78563          	beq	a5,a4,80003e82 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e5c:	4709                	li	a4,2
    80003e5e:	0ce79d63          	bne	a5,a4,80003f38 <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e62:	0ac05b63          	blez	a2,80003f18 <filewrite+0xf0>
    int i = 0;
    80003e66:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e68:	6b85                	lui	s7,0x1
    80003e6a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e6e:	6c05                	lui	s8,0x1
    80003e70:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e74:	a851                	j	80003f08 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e76:	6908                	ld	a0,16(a0)
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	234080e7          	jalr	564(ra) # 800040ac <pipewrite>
    80003e80:	a045                	j	80003f20 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e82:	02451783          	lh	a5,36(a0)
    80003e86:	03079693          	slli	a3,a5,0x30
    80003e8a:	92c1                	srli	a3,a3,0x30
    80003e8c:	4725                	li	a4,9
    80003e8e:	0ad76f63          	bltu	a4,a3,80003f4c <filewrite+0x124>
    80003e92:	0792                	slli	a5,a5,0x4
    80003e94:	00019717          	auipc	a4,0x19
    80003e98:	8e470713          	addi	a4,a4,-1820 # 8001c778 <devsw>
    80003e9c:	97ba                	add	a5,a5,a4
    80003e9e:	679c                	ld	a5,8(a5)
    80003ea0:	cbc5                	beqz	a5,80003f50 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003ea2:	4505                	li	a0,1
    80003ea4:	9782                	jalr	a5
    80003ea6:	a8ad                	j	80003f20 <filewrite+0xf8>
      if(n1 > max)
    80003ea8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	8bc080e7          	jalr	-1860(ra) # 80003768 <begin_op>
      ilock(f->ip);
    80003eb4:	01893503          	ld	a0,24(s2)
    80003eb8:	fffff097          	auipc	ra,0xfffff
    80003ebc:	ef6080e7          	jalr	-266(ra) # 80002dae <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ec0:	8756                	mv	a4,s5
    80003ec2:	02092683          	lw	a3,32(s2)
    80003ec6:	01698633          	add	a2,s3,s6
    80003eca:	4585                	li	a1,1
    80003ecc:	01893503          	ld	a0,24(s2)
    80003ed0:	fffff097          	auipc	ra,0xfffff
    80003ed4:	29e080e7          	jalr	670(ra) # 8000316e <writei>
    80003ed8:	84aa                	mv	s1,a0
    80003eda:	00a05763          	blez	a0,80003ee8 <filewrite+0xc0>
        f->off += r;
    80003ede:	02092783          	lw	a5,32(s2)
    80003ee2:	9fa9                	addw	a5,a5,a0
    80003ee4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ee8:	01893503          	ld	a0,24(s2)
    80003eec:	fffff097          	auipc	ra,0xfffff
    80003ef0:	f8e080e7          	jalr	-114(ra) # 80002e7a <iunlock>
      end_op();
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	8ee080e7          	jalr	-1810(ra) # 800037e2 <end_op>

      if(r != n1){
    80003efc:	009a9f63          	bne	s5,s1,80003f1a <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003f00:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f04:	0149db63          	bge	s3,s4,80003f1a <filewrite+0xf2>
      int n1 = n - i;
    80003f08:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f0c:	0004879b          	sext.w	a5,s1
    80003f10:	f8fbdce3          	bge	s7,a5,80003ea8 <filewrite+0x80>
    80003f14:	84e2                	mv	s1,s8
    80003f16:	bf49                	j	80003ea8 <filewrite+0x80>
    int i = 0;
    80003f18:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f1a:	033a1d63          	bne	s4,s3,80003f54 <filewrite+0x12c>
    80003f1e:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f20:	60a6                	ld	ra,72(sp)
    80003f22:	6406                	ld	s0,64(sp)
    80003f24:	74e2                	ld	s1,56(sp)
    80003f26:	7942                	ld	s2,48(sp)
    80003f28:	79a2                	ld	s3,40(sp)
    80003f2a:	7a02                	ld	s4,32(sp)
    80003f2c:	6ae2                	ld	s5,24(sp)
    80003f2e:	6b42                	ld	s6,16(sp)
    80003f30:	6ba2                	ld	s7,8(sp)
    80003f32:	6c02                	ld	s8,0(sp)
    80003f34:	6161                	addi	sp,sp,80
    80003f36:	8082                	ret
    panic("filewrite");
    80003f38:	00004517          	auipc	a0,0x4
    80003f3c:	70050513          	addi	a0,a0,1792 # 80008638 <syscalls+0x268>
    80003f40:	00002097          	auipc	ra,0x2
    80003f44:	222080e7          	jalr	546(ra) # 80006162 <panic>
    return -1;
    80003f48:	557d                	li	a0,-1
}
    80003f4a:	8082                	ret
      return -1;
    80003f4c:	557d                	li	a0,-1
    80003f4e:	bfc9                	j	80003f20 <filewrite+0xf8>
    80003f50:	557d                	li	a0,-1
    80003f52:	b7f9                	j	80003f20 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003f54:	557d                	li	a0,-1
    80003f56:	b7e9                	j	80003f20 <filewrite+0xf8>

0000000080003f58 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f58:	7179                	addi	sp,sp,-48
    80003f5a:	f406                	sd	ra,40(sp)
    80003f5c:	f022                	sd	s0,32(sp)
    80003f5e:	ec26                	sd	s1,24(sp)
    80003f60:	e84a                	sd	s2,16(sp)
    80003f62:	e44e                	sd	s3,8(sp)
    80003f64:	e052                	sd	s4,0(sp)
    80003f66:	1800                	addi	s0,sp,48
    80003f68:	84aa                	mv	s1,a0
    80003f6a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f6c:	0005b023          	sd	zero,0(a1)
    80003f70:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f74:	00000097          	auipc	ra,0x0
    80003f78:	bfc080e7          	jalr	-1028(ra) # 80003b70 <filealloc>
    80003f7c:	e088                	sd	a0,0(s1)
    80003f7e:	c551                	beqz	a0,8000400a <pipealloc+0xb2>
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	bf0080e7          	jalr	-1040(ra) # 80003b70 <filealloc>
    80003f88:	00aa3023          	sd	a0,0(s4)
    80003f8c:	c92d                	beqz	a0,80003ffe <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f8e:	ffffc097          	auipc	ra,0xffffc
    80003f92:	1dc080e7          	jalr	476(ra) # 8000016a <kalloc>
    80003f96:	892a                	mv	s2,a0
    80003f98:	c125                	beqz	a0,80003ff8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f9a:	4985                	li	s3,1
    80003f9c:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003fa0:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003fa4:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003fa8:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003fac:	00004597          	auipc	a1,0x4
    80003fb0:	69c58593          	addi	a1,a1,1692 # 80008648 <syscalls+0x278>
    80003fb4:	00003097          	auipc	ra,0x3
    80003fb8:	84c080e7          	jalr	-1972(ra) # 80006800 <initlock>
  (*f0)->type = FD_PIPE;
    80003fbc:	609c                	ld	a5,0(s1)
    80003fbe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fc2:	609c                	ld	a5,0(s1)
    80003fc4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fc8:	609c                	ld	a5,0(s1)
    80003fca:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fce:	609c                	ld	a5,0(s1)
    80003fd0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fd4:	000a3783          	ld	a5,0(s4)
    80003fd8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fdc:	000a3783          	ld	a5,0(s4)
    80003fe0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fe4:	000a3783          	ld	a5,0(s4)
    80003fe8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fec:	000a3783          	ld	a5,0(s4)
    80003ff0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ff4:	4501                	li	a0,0
    80003ff6:	a025                	j	8000401e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ff8:	6088                	ld	a0,0(s1)
    80003ffa:	e501                	bnez	a0,80004002 <pipealloc+0xaa>
    80003ffc:	a039                	j	8000400a <pipealloc+0xb2>
    80003ffe:	6088                	ld	a0,0(s1)
    80004000:	c51d                	beqz	a0,8000402e <pipealloc+0xd6>
    fileclose(*f0);
    80004002:	00000097          	auipc	ra,0x0
    80004006:	c2a080e7          	jalr	-982(ra) # 80003c2c <fileclose>
  if(*f1)
    8000400a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000400e:	557d                	li	a0,-1
  if(*f1)
    80004010:	c799                	beqz	a5,8000401e <pipealloc+0xc6>
    fileclose(*f1);
    80004012:	853e                	mv	a0,a5
    80004014:	00000097          	auipc	ra,0x0
    80004018:	c18080e7          	jalr	-1000(ra) # 80003c2c <fileclose>
  return -1;
    8000401c:	557d                	li	a0,-1
}
    8000401e:	70a2                	ld	ra,40(sp)
    80004020:	7402                	ld	s0,32(sp)
    80004022:	64e2                	ld	s1,24(sp)
    80004024:	6942                	ld	s2,16(sp)
    80004026:	69a2                	ld	s3,8(sp)
    80004028:	6a02                	ld	s4,0(sp)
    8000402a:	6145                	addi	sp,sp,48
    8000402c:	8082                	ret
  return -1;
    8000402e:	557d                	li	a0,-1
    80004030:	b7fd                	j	8000401e <pipealloc+0xc6>

0000000080004032 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004032:	1101                	addi	sp,sp,-32
    80004034:	ec06                	sd	ra,24(sp)
    80004036:	e822                	sd	s0,16(sp)
    80004038:	e426                	sd	s1,8(sp)
    8000403a:	e04a                	sd	s2,0(sp)
    8000403c:	1000                	addi	s0,sp,32
    8000403e:	84aa                	mv	s1,a0
    80004040:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004042:	00002097          	auipc	ra,0x2
    80004046:	642080e7          	jalr	1602(ra) # 80006684 <acquire>
  if(writable){
    8000404a:	04090263          	beqz	s2,8000408e <pipeclose+0x5c>
    pi->writeopen = 0;
    8000404e:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004052:	22048513          	addi	a0,s1,544
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	600080e7          	jalr	1536(ra) # 80001656 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000405e:	2284b783          	ld	a5,552(s1)
    80004062:	ef9d                	bnez	a5,800040a0 <pipeclose+0x6e>
    release(&pi->lock);
    80004064:	8526                	mv	a0,s1
    80004066:	00002097          	auipc	ra,0x2
    8000406a:	6ee080e7          	jalr	1774(ra) # 80006754 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	72c080e7          	jalr	1836(ra) # 8000679c <freelock>
#endif    
    kfree((char*)pi);
    80004078:	8526                	mv	a0,s1
    8000407a:	ffffc097          	auipc	ra,0xffffc
    8000407e:	fa2080e7          	jalr	-94(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004082:	60e2                	ld	ra,24(sp)
    80004084:	6442                	ld	s0,16(sp)
    80004086:	64a2                	ld	s1,8(sp)
    80004088:	6902                	ld	s2,0(sp)
    8000408a:	6105                	addi	sp,sp,32
    8000408c:	8082                	ret
    pi->readopen = 0;
    8000408e:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004092:	22448513          	addi	a0,s1,548
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	5c0080e7          	jalr	1472(ra) # 80001656 <wakeup>
    8000409e:	b7c1                	j	8000405e <pipeclose+0x2c>
    release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	6b2080e7          	jalr	1714(ra) # 80006754 <release>
}
    800040aa:	bfe1                	j	80004082 <pipeclose+0x50>

00000000800040ac <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040ac:	711d                	addi	sp,sp,-96
    800040ae:	ec86                	sd	ra,88(sp)
    800040b0:	e8a2                	sd	s0,80(sp)
    800040b2:	e4a6                	sd	s1,72(sp)
    800040b4:	e0ca                	sd	s2,64(sp)
    800040b6:	fc4e                	sd	s3,56(sp)
    800040b8:	f852                	sd	s4,48(sp)
    800040ba:	f456                	sd	s5,40(sp)
    800040bc:	f05a                	sd	s6,32(sp)
    800040be:	ec5e                	sd	s7,24(sp)
    800040c0:	e862                	sd	s8,16(sp)
    800040c2:	1080                	addi	s0,sp,96
    800040c4:	84aa                	mv	s1,a0
    800040c6:	8aae                	mv	s5,a1
    800040c8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	e80080e7          	jalr	-384(ra) # 80000f4a <myproc>
    800040d2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040d4:	8526                	mv	a0,s1
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	5ae080e7          	jalr	1454(ra) # 80006684 <acquire>
  while(i < n){
    800040de:	0b405663          	blez	s4,8000418a <pipewrite+0xde>
  int i = 0;
    800040e2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040e4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040e6:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800040ea:	22448b93          	addi	s7,s1,548
    800040ee:	a089                	j	80004130 <pipewrite+0x84>
      release(&pi->lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	00002097          	auipc	ra,0x2
    800040f6:	662080e7          	jalr	1634(ra) # 80006754 <release>
      return -1;
    800040fa:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040fc:	854a                	mv	a0,s2
    800040fe:	60e6                	ld	ra,88(sp)
    80004100:	6446                	ld	s0,80(sp)
    80004102:	64a6                	ld	s1,72(sp)
    80004104:	6906                	ld	s2,64(sp)
    80004106:	79e2                	ld	s3,56(sp)
    80004108:	7a42                	ld	s4,48(sp)
    8000410a:	7aa2                	ld	s5,40(sp)
    8000410c:	7b02                	ld	s6,32(sp)
    8000410e:	6be2                	ld	s7,24(sp)
    80004110:	6c42                	ld	s8,16(sp)
    80004112:	6125                	addi	sp,sp,96
    80004114:	8082                	ret
      wakeup(&pi->nread);
    80004116:	8562                	mv	a0,s8
    80004118:	ffffd097          	auipc	ra,0xffffd
    8000411c:	53e080e7          	jalr	1342(ra) # 80001656 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004120:	85a6                	mv	a1,s1
    80004122:	855e                	mv	a0,s7
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	4ce080e7          	jalr	1230(ra) # 800015f2 <sleep>
  while(i < n){
    8000412c:	07495063          	bge	s2,s4,8000418c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004130:	2284a783          	lw	a5,552(s1)
    80004134:	dfd5                	beqz	a5,800040f0 <pipewrite+0x44>
    80004136:	854e                	mv	a0,s3
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	762080e7          	jalr	1890(ra) # 8000189a <killed>
    80004140:	f945                	bnez	a0,800040f0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004142:	2204a783          	lw	a5,544(s1)
    80004146:	2244a703          	lw	a4,548(s1)
    8000414a:	2007879b          	addiw	a5,a5,512
    8000414e:	fcf704e3          	beq	a4,a5,80004116 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004152:	4685                	li	a3,1
    80004154:	01590633          	add	a2,s2,s5
    80004158:	faf40593          	addi	a1,s0,-81
    8000415c:	0589b503          	ld	a0,88(s3)
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	b36080e7          	jalr	-1226(ra) # 80000c96 <copyin>
    80004168:	03650263          	beq	a0,s6,8000418c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000416c:	2244a783          	lw	a5,548(s1)
    80004170:	0017871b          	addiw	a4,a5,1
    80004174:	22e4a223          	sw	a4,548(s1)
    80004178:	1ff7f793          	andi	a5,a5,511
    8000417c:	97a6                	add	a5,a5,s1
    8000417e:	faf44703          	lbu	a4,-81(s0)
    80004182:	02e78023          	sb	a4,32(a5)
      i++;
    80004186:	2905                	addiw	s2,s2,1
    80004188:	b755                	j	8000412c <pipewrite+0x80>
  int i = 0;
    8000418a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000418c:	22048513          	addi	a0,s1,544
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	4c6080e7          	jalr	1222(ra) # 80001656 <wakeup>
  release(&pi->lock);
    80004198:	8526                	mv	a0,s1
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	5ba080e7          	jalr	1466(ra) # 80006754 <release>
  return i;
    800041a2:	bfa9                	j	800040fc <pipewrite+0x50>

00000000800041a4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041a4:	715d                	addi	sp,sp,-80
    800041a6:	e486                	sd	ra,72(sp)
    800041a8:	e0a2                	sd	s0,64(sp)
    800041aa:	fc26                	sd	s1,56(sp)
    800041ac:	f84a                	sd	s2,48(sp)
    800041ae:	f44e                	sd	s3,40(sp)
    800041b0:	f052                	sd	s4,32(sp)
    800041b2:	ec56                	sd	s5,24(sp)
    800041b4:	e85a                	sd	s6,16(sp)
    800041b6:	0880                	addi	s0,sp,80
    800041b8:	84aa                	mv	s1,a0
    800041ba:	892e                	mv	s2,a1
    800041bc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	d8c080e7          	jalr	-628(ra) # 80000f4a <myproc>
    800041c6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041c8:	8526                	mv	a0,s1
    800041ca:	00002097          	auipc	ra,0x2
    800041ce:	4ba080e7          	jalr	1210(ra) # 80006684 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041d2:	2204a703          	lw	a4,544(s1)
    800041d6:	2244a783          	lw	a5,548(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041da:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041de:	02f71763          	bne	a4,a5,8000420c <piperead+0x68>
    800041e2:	22c4a783          	lw	a5,556(s1)
    800041e6:	c39d                	beqz	a5,8000420c <piperead+0x68>
    if(killed(pr)){
    800041e8:	8552                	mv	a0,s4
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	6b0080e7          	jalr	1712(ra) # 8000189a <killed>
    800041f2:	e949                	bnez	a0,80004284 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041f4:	85a6                	mv	a1,s1
    800041f6:	854e                	mv	a0,s3
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	3fa080e7          	jalr	1018(ra) # 800015f2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004200:	2204a703          	lw	a4,544(s1)
    80004204:	2244a783          	lw	a5,548(s1)
    80004208:	fcf70de3          	beq	a4,a5,800041e2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000420e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004210:	05505463          	blez	s5,80004258 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004214:	2204a783          	lw	a5,544(s1)
    80004218:	2244a703          	lw	a4,548(s1)
    8000421c:	02f70e63          	beq	a4,a5,80004258 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004220:	0017871b          	addiw	a4,a5,1
    80004224:	22e4a023          	sw	a4,544(s1)
    80004228:	1ff7f793          	andi	a5,a5,511
    8000422c:	97a6                	add	a5,a5,s1
    8000422e:	0207c783          	lbu	a5,32(a5)
    80004232:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004236:	4685                	li	a3,1
    80004238:	fbf40613          	addi	a2,s0,-65
    8000423c:	85ca                	mv	a1,s2
    8000423e:	058a3503          	ld	a0,88(s4)
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	9c8080e7          	jalr	-1592(ra) # 80000c0a <copyout>
    8000424a:	01650763          	beq	a0,s6,80004258 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424e:	2985                	addiw	s3,s3,1
    80004250:	0905                	addi	s2,s2,1
    80004252:	fd3a91e3          	bne	s5,s3,80004214 <piperead+0x70>
    80004256:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004258:	22448513          	addi	a0,s1,548
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	3fa080e7          	jalr	1018(ra) # 80001656 <wakeup>
  release(&pi->lock);
    80004264:	8526                	mv	a0,s1
    80004266:	00002097          	auipc	ra,0x2
    8000426a:	4ee080e7          	jalr	1262(ra) # 80006754 <release>
  return i;
}
    8000426e:	854e                	mv	a0,s3
    80004270:	60a6                	ld	ra,72(sp)
    80004272:	6406                	ld	s0,64(sp)
    80004274:	74e2                	ld	s1,56(sp)
    80004276:	7942                	ld	s2,48(sp)
    80004278:	79a2                	ld	s3,40(sp)
    8000427a:	7a02                	ld	s4,32(sp)
    8000427c:	6ae2                	ld	s5,24(sp)
    8000427e:	6b42                	ld	s6,16(sp)
    80004280:	6161                	addi	sp,sp,80
    80004282:	8082                	ret
      release(&pi->lock);
    80004284:	8526                	mv	a0,s1
    80004286:	00002097          	auipc	ra,0x2
    8000428a:	4ce080e7          	jalr	1230(ra) # 80006754 <release>
      return -1;
    8000428e:	59fd                	li	s3,-1
    80004290:	bff9                	j	8000426e <piperead+0xca>

0000000080004292 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004292:	1141                	addi	sp,sp,-16
    80004294:	e422                	sd	s0,8(sp)
    80004296:	0800                	addi	s0,sp,16
    80004298:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000429a:	8905                	andi	a0,a0,1
    8000429c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000429e:	8b89                	andi	a5,a5,2
    800042a0:	c399                	beqz	a5,800042a6 <flags2perm+0x14>
      perm |= PTE_W;
    800042a2:	00456513          	ori	a0,a0,4
    return perm;
}
    800042a6:	6422                	ld	s0,8(sp)
    800042a8:	0141                	addi	sp,sp,16
    800042aa:	8082                	ret

00000000800042ac <exec>:

int
exec(char *path, char **argv)
{
    800042ac:	df010113          	addi	sp,sp,-528
    800042b0:	20113423          	sd	ra,520(sp)
    800042b4:	20813023          	sd	s0,512(sp)
    800042b8:	ffa6                	sd	s1,504(sp)
    800042ba:	fbca                	sd	s2,496(sp)
    800042bc:	f7ce                	sd	s3,488(sp)
    800042be:	f3d2                	sd	s4,480(sp)
    800042c0:	efd6                	sd	s5,472(sp)
    800042c2:	ebda                	sd	s6,464(sp)
    800042c4:	e7de                	sd	s7,456(sp)
    800042c6:	e3e2                	sd	s8,448(sp)
    800042c8:	ff66                	sd	s9,440(sp)
    800042ca:	fb6a                	sd	s10,432(sp)
    800042cc:	f76e                	sd	s11,424(sp)
    800042ce:	0c00                	addi	s0,sp,528
    800042d0:	892a                	mv	s2,a0
    800042d2:	dea43c23          	sd	a0,-520(s0)
    800042d6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	c70080e7          	jalr	-912(ra) # 80000f4a <myproc>
    800042e2:	84aa                	mv	s1,a0

  begin_op();
    800042e4:	fffff097          	auipc	ra,0xfffff
    800042e8:	484080e7          	jalr	1156(ra) # 80003768 <begin_op>

  if((ip = namei(path)) == 0){
    800042ec:	854a                	mv	a0,s2
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	27a080e7          	jalr	634(ra) # 80003568 <namei>
    800042f6:	c92d                	beqz	a0,80004368 <exec+0xbc>
    800042f8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042fa:	fffff097          	auipc	ra,0xfffff
    800042fe:	ab4080e7          	jalr	-1356(ra) # 80002dae <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004302:	04000713          	li	a4,64
    80004306:	4681                	li	a3,0
    80004308:	e5040613          	addi	a2,s0,-432
    8000430c:	4581                	li	a1,0
    8000430e:	8552                	mv	a0,s4
    80004310:	fffff097          	auipc	ra,0xfffff
    80004314:	d66080e7          	jalr	-666(ra) # 80003076 <readi>
    80004318:	04000793          	li	a5,64
    8000431c:	00f51a63          	bne	a0,a5,80004330 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004320:	e5042703          	lw	a4,-432(s0)
    80004324:	464c47b7          	lui	a5,0x464c4
    80004328:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000432c:	04f70463          	beq	a4,a5,80004374 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004330:	8552                	mv	a0,s4
    80004332:	fffff097          	auipc	ra,0xfffff
    80004336:	cf2080e7          	jalr	-782(ra) # 80003024 <iunlockput>
    end_op();
    8000433a:	fffff097          	auipc	ra,0xfffff
    8000433e:	4a8080e7          	jalr	1192(ra) # 800037e2 <end_op>
  }
  return -1;
    80004342:	557d                	li	a0,-1
}
    80004344:	20813083          	ld	ra,520(sp)
    80004348:	20013403          	ld	s0,512(sp)
    8000434c:	74fe                	ld	s1,504(sp)
    8000434e:	795e                	ld	s2,496(sp)
    80004350:	79be                	ld	s3,488(sp)
    80004352:	7a1e                	ld	s4,480(sp)
    80004354:	6afe                	ld	s5,472(sp)
    80004356:	6b5e                	ld	s6,464(sp)
    80004358:	6bbe                	ld	s7,456(sp)
    8000435a:	6c1e                	ld	s8,448(sp)
    8000435c:	7cfa                	ld	s9,440(sp)
    8000435e:	7d5a                	ld	s10,432(sp)
    80004360:	7dba                	ld	s11,424(sp)
    80004362:	21010113          	addi	sp,sp,528
    80004366:	8082                	ret
    end_op();
    80004368:	fffff097          	auipc	ra,0xfffff
    8000436c:	47a080e7          	jalr	1146(ra) # 800037e2 <end_op>
    return -1;
    80004370:	557d                	li	a0,-1
    80004372:	bfc9                	j	80004344 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004374:	8526                	mv	a0,s1
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	c98080e7          	jalr	-872(ra) # 8000100e <proc_pagetable>
    8000437e:	8b2a                	mv	s6,a0
    80004380:	d945                	beqz	a0,80004330 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004382:	e7042d03          	lw	s10,-400(s0)
    80004386:	e8845783          	lhu	a5,-376(s0)
    8000438a:	10078463          	beqz	a5,80004492 <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000438e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004390:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004392:	6c85                	lui	s9,0x1
    80004394:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004398:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000439c:	6a85                	lui	s5,0x1
    8000439e:	a0b5                	j	8000440a <exec+0x15e>
      panic("loadseg: address should exist");
    800043a0:	00004517          	auipc	a0,0x4
    800043a4:	2b050513          	addi	a0,a0,688 # 80008650 <syscalls+0x280>
    800043a8:	00002097          	auipc	ra,0x2
    800043ac:	dba080e7          	jalr	-582(ra) # 80006162 <panic>
    if(sz - i < PGSIZE)
    800043b0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043b2:	8726                	mv	a4,s1
    800043b4:	012c06bb          	addw	a3,s8,s2
    800043b8:	4581                	li	a1,0
    800043ba:	8552                	mv	a0,s4
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	cba080e7          	jalr	-838(ra) # 80003076 <readi>
    800043c4:	2501                	sext.w	a0,a0
    800043c6:	24a49863          	bne	s1,a0,80004616 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800043ca:	012a893b          	addw	s2,s5,s2
    800043ce:	03397563          	bgeu	s2,s3,800043f8 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800043d2:	02091593          	slli	a1,s2,0x20
    800043d6:	9181                	srli	a1,a1,0x20
    800043d8:	95de                	add	a1,a1,s7
    800043da:	855a                	mv	a0,s6
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	21e080e7          	jalr	542(ra) # 800005fa <walkaddr>
    800043e4:	862a                	mv	a2,a0
    if(pa == 0)
    800043e6:	dd4d                	beqz	a0,800043a0 <exec+0xf4>
    if(sz - i < PGSIZE)
    800043e8:	412984bb          	subw	s1,s3,s2
    800043ec:	0004879b          	sext.w	a5,s1
    800043f0:	fcfcf0e3          	bgeu	s9,a5,800043b0 <exec+0x104>
    800043f4:	84d6                	mv	s1,s5
    800043f6:	bf6d                	j	800043b0 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043f8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043fc:	2d85                	addiw	s11,s11,1
    800043fe:	038d0d1b          	addiw	s10,s10,56
    80004402:	e8845783          	lhu	a5,-376(s0)
    80004406:	08fdd763          	bge	s11,a5,80004494 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000440a:	2d01                	sext.w	s10,s10
    8000440c:	03800713          	li	a4,56
    80004410:	86ea                	mv	a3,s10
    80004412:	e1840613          	addi	a2,s0,-488
    80004416:	4581                	li	a1,0
    80004418:	8552                	mv	a0,s4
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	c5c080e7          	jalr	-932(ra) # 80003076 <readi>
    80004422:	03800793          	li	a5,56
    80004426:	1ef51663          	bne	a0,a5,80004612 <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    8000442a:	e1842783          	lw	a5,-488(s0)
    8000442e:	4705                	li	a4,1
    80004430:	fce796e3          	bne	a5,a4,800043fc <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004434:	e4043483          	ld	s1,-448(s0)
    80004438:	e3843783          	ld	a5,-456(s0)
    8000443c:	1ef4e863          	bltu	s1,a5,8000462c <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004440:	e2843783          	ld	a5,-472(s0)
    80004444:	94be                	add	s1,s1,a5
    80004446:	1ef4e663          	bltu	s1,a5,80004632 <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    8000444a:	df043703          	ld	a4,-528(s0)
    8000444e:	8ff9                	and	a5,a5,a4
    80004450:	1e079463          	bnez	a5,80004638 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004454:	e1c42503          	lw	a0,-484(s0)
    80004458:	00000097          	auipc	ra,0x0
    8000445c:	e3a080e7          	jalr	-454(ra) # 80004292 <flags2perm>
    80004460:	86aa                	mv	a3,a0
    80004462:	8626                	mv	a2,s1
    80004464:	85ca                	mv	a1,s2
    80004466:	855a                	mv	a0,s6
    80004468:	ffffc097          	auipc	ra,0xffffc
    8000446c:	546080e7          	jalr	1350(ra) # 800009ae <uvmalloc>
    80004470:	e0a43423          	sd	a0,-504(s0)
    80004474:	1c050563          	beqz	a0,8000463e <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004478:	e2843b83          	ld	s7,-472(s0)
    8000447c:	e2042c03          	lw	s8,-480(s0)
    80004480:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004484:	00098463          	beqz	s3,8000448c <exec+0x1e0>
    80004488:	4901                	li	s2,0
    8000448a:	b7a1                	j	800043d2 <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448c:	e0843903          	ld	s2,-504(s0)
    80004490:	b7b5                	j	800043fc <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004492:	4901                	li	s2,0
  iunlockput(ip);
    80004494:	8552                	mv	a0,s4
    80004496:	fffff097          	auipc	ra,0xfffff
    8000449a:	b8e080e7          	jalr	-1138(ra) # 80003024 <iunlockput>
  end_op();
    8000449e:	fffff097          	auipc	ra,0xfffff
    800044a2:	344080e7          	jalr	836(ra) # 800037e2 <end_op>
  p = myproc();
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	aa4080e7          	jalr	-1372(ra) # 80000f4a <myproc>
    800044ae:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044b0:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    800044b4:	6985                	lui	s3,0x1
    800044b6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044b8:	99ca                	add	s3,s3,s2
    800044ba:	77fd                	lui	a5,0xfffff
    800044bc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800044c0:	4691                	li	a3,4
    800044c2:	6609                	lui	a2,0x2
    800044c4:	964e                	add	a2,a2,s3
    800044c6:	85ce                	mv	a1,s3
    800044c8:	855a                	mv	a0,s6
    800044ca:	ffffc097          	auipc	ra,0xffffc
    800044ce:	4e4080e7          	jalr	1252(ra) # 800009ae <uvmalloc>
    800044d2:	892a                	mv	s2,a0
    800044d4:	e0a43423          	sd	a0,-504(s0)
    800044d8:	e509                	bnez	a0,800044e2 <exec+0x236>
  if(pagetable)
    800044da:	e1343423          	sd	s3,-504(s0)
    800044de:	4a01                	li	s4,0
    800044e0:	aa1d                	j	80004616 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044e2:	75f9                	lui	a1,0xffffe
    800044e4:	95aa                	add	a1,a1,a0
    800044e6:	855a                	mv	a0,s6
    800044e8:	ffffc097          	auipc	ra,0xffffc
    800044ec:	6f0080e7          	jalr	1776(ra) # 80000bd8 <uvmclear>
  stackbase = sp - PGSIZE;
    800044f0:	7bfd                	lui	s7,0xfffff
    800044f2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800044f4:	e0043783          	ld	a5,-512(s0)
    800044f8:	6388                	ld	a0,0(a5)
    800044fa:	c52d                	beqz	a0,80004564 <exec+0x2b8>
    800044fc:	e9040993          	addi	s3,s0,-368
    80004500:	f9040c13          	addi	s8,s0,-112
    80004504:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	ed6080e7          	jalr	-298(ra) # 800003dc <strlen>
    8000450e:	0015079b          	addiw	a5,a0,1
    80004512:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004516:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000451a:	13796563          	bltu	s2,s7,80004644 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000451e:	e0043d03          	ld	s10,-512(s0)
    80004522:	000d3a03          	ld	s4,0(s10)
    80004526:	8552                	mv	a0,s4
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	eb4080e7          	jalr	-332(ra) # 800003dc <strlen>
    80004530:	0015069b          	addiw	a3,a0,1
    80004534:	8652                	mv	a2,s4
    80004536:	85ca                	mv	a1,s2
    80004538:	855a                	mv	a0,s6
    8000453a:	ffffc097          	auipc	ra,0xffffc
    8000453e:	6d0080e7          	jalr	1744(ra) # 80000c0a <copyout>
    80004542:	10054363          	bltz	a0,80004648 <exec+0x39c>
    ustack[argc] = sp;
    80004546:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000454a:	0485                	addi	s1,s1,1
    8000454c:	008d0793          	addi	a5,s10,8
    80004550:	e0f43023          	sd	a5,-512(s0)
    80004554:	008d3503          	ld	a0,8(s10)
    80004558:	c909                	beqz	a0,8000456a <exec+0x2be>
    if(argc >= MAXARG)
    8000455a:	09a1                	addi	s3,s3,8
    8000455c:	fb8995e3          	bne	s3,s8,80004506 <exec+0x25a>
  ip = 0;
    80004560:	4a01                	li	s4,0
    80004562:	a855                	j	80004616 <exec+0x36a>
  sp = sz;
    80004564:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004568:	4481                	li	s1,0
  ustack[argc] = 0;
    8000456a:	00349793          	slli	a5,s1,0x3
    8000456e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd7428>
    80004572:	97a2                	add	a5,a5,s0
    80004574:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004578:	00148693          	addi	a3,s1,1
    8000457c:	068e                	slli	a3,a3,0x3
    8000457e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004582:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004586:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000458a:	f57968e3          	bltu	s2,s7,800044da <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000458e:	e9040613          	addi	a2,s0,-368
    80004592:	85ca                	mv	a1,s2
    80004594:	855a                	mv	a0,s6
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	674080e7          	jalr	1652(ra) # 80000c0a <copyout>
    8000459e:	0a054763          	bltz	a0,8000464c <exec+0x3a0>
  p->trapframe->a1 = sp;
    800045a2:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    800045a6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045aa:	df843783          	ld	a5,-520(s0)
    800045ae:	0007c703          	lbu	a4,0(a5)
    800045b2:	cf11                	beqz	a4,800045ce <exec+0x322>
    800045b4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045b6:	02f00693          	li	a3,47
    800045ba:	a039                	j	800045c8 <exec+0x31c>
      last = s+1;
    800045bc:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045c0:	0785                	addi	a5,a5,1
    800045c2:	fff7c703          	lbu	a4,-1(a5)
    800045c6:	c701                	beqz	a4,800045ce <exec+0x322>
    if(*s == '/')
    800045c8:	fed71ce3          	bne	a4,a3,800045c0 <exec+0x314>
    800045cc:	bfc5                	j	800045bc <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800045ce:	4641                	li	a2,16
    800045d0:	df843583          	ld	a1,-520(s0)
    800045d4:	160a8513          	addi	a0,s5,352
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	dd2080e7          	jalr	-558(ra) # 800003aa <safestrcpy>
  oldpagetable = p->pagetable;
    800045e0:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800045e4:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800045e8:	e0843783          	ld	a5,-504(s0)
    800045ec:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045f0:	060ab783          	ld	a5,96(s5)
    800045f4:	e6843703          	ld	a4,-408(s0)
    800045f8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045fa:	060ab783          	ld	a5,96(s5)
    800045fe:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004602:	85e6                	mv	a1,s9
    80004604:	ffffd097          	auipc	ra,0xffffd
    80004608:	aa6080e7          	jalr	-1370(ra) # 800010aa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000460c:	0004851b          	sext.w	a0,s1
    80004610:	bb15                	j	80004344 <exec+0x98>
    80004612:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004616:	e0843583          	ld	a1,-504(s0)
    8000461a:	855a                	mv	a0,s6
    8000461c:	ffffd097          	auipc	ra,0xffffd
    80004620:	a8e080e7          	jalr	-1394(ra) # 800010aa <proc_freepagetable>
  return -1;
    80004624:	557d                	li	a0,-1
  if(ip){
    80004626:	d00a0fe3          	beqz	s4,80004344 <exec+0x98>
    8000462a:	b319                	j	80004330 <exec+0x84>
    8000462c:	e1243423          	sd	s2,-504(s0)
    80004630:	b7dd                	j	80004616 <exec+0x36a>
    80004632:	e1243423          	sd	s2,-504(s0)
    80004636:	b7c5                	j	80004616 <exec+0x36a>
    80004638:	e1243423          	sd	s2,-504(s0)
    8000463c:	bfe9                	j	80004616 <exec+0x36a>
    8000463e:	e1243423          	sd	s2,-504(s0)
    80004642:	bfd1                	j	80004616 <exec+0x36a>
  ip = 0;
    80004644:	4a01                	li	s4,0
    80004646:	bfc1                	j	80004616 <exec+0x36a>
    80004648:	4a01                	li	s4,0
  if(pagetable)
    8000464a:	b7f1                	j	80004616 <exec+0x36a>
  sz = sz1;
    8000464c:	e0843983          	ld	s3,-504(s0)
    80004650:	b569                	j	800044da <exec+0x22e>

0000000080004652 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004652:	7179                	addi	sp,sp,-48
    80004654:	f406                	sd	ra,40(sp)
    80004656:	f022                	sd	s0,32(sp)
    80004658:	ec26                	sd	s1,24(sp)
    8000465a:	e84a                	sd	s2,16(sp)
    8000465c:	1800                	addi	s0,sp,48
    8000465e:	892e                	mv	s2,a1
    80004660:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004662:	fdc40593          	addi	a1,s0,-36
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	9fe080e7          	jalr	-1538(ra) # 80002064 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000466e:	fdc42703          	lw	a4,-36(s0)
    80004672:	47bd                	li	a5,15
    80004674:	02e7eb63          	bltu	a5,a4,800046aa <argfd+0x58>
    80004678:	ffffd097          	auipc	ra,0xffffd
    8000467c:	8d2080e7          	jalr	-1838(ra) # 80000f4a <myproc>
    80004680:	fdc42703          	lw	a4,-36(s0)
    80004684:	01a70793          	addi	a5,a4,26
    80004688:	078e                	slli	a5,a5,0x3
    8000468a:	953e                	add	a0,a0,a5
    8000468c:	651c                	ld	a5,8(a0)
    8000468e:	c385                	beqz	a5,800046ae <argfd+0x5c>
    return -1;
  if(pfd)
    80004690:	00090463          	beqz	s2,80004698 <argfd+0x46>
    *pfd = fd;
    80004694:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004698:	4501                	li	a0,0
  if(pf)
    8000469a:	c091                	beqz	s1,8000469e <argfd+0x4c>
    *pf = f;
    8000469c:	e09c                	sd	a5,0(s1)
}
    8000469e:	70a2                	ld	ra,40(sp)
    800046a0:	7402                	ld	s0,32(sp)
    800046a2:	64e2                	ld	s1,24(sp)
    800046a4:	6942                	ld	s2,16(sp)
    800046a6:	6145                	addi	sp,sp,48
    800046a8:	8082                	ret
    return -1;
    800046aa:	557d                	li	a0,-1
    800046ac:	bfcd                	j	8000469e <argfd+0x4c>
    800046ae:	557d                	li	a0,-1
    800046b0:	b7fd                	j	8000469e <argfd+0x4c>

00000000800046b2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046b2:	1101                	addi	sp,sp,-32
    800046b4:	ec06                	sd	ra,24(sp)
    800046b6:	e822                	sd	s0,16(sp)
    800046b8:	e426                	sd	s1,8(sp)
    800046ba:	1000                	addi	s0,sp,32
    800046bc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046be:	ffffd097          	auipc	ra,0xffffd
    800046c2:	88c080e7          	jalr	-1908(ra) # 80000f4a <myproc>
    800046c6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046c8:	0d850793          	addi	a5,a0,216
    800046cc:	4501                	li	a0,0
    800046ce:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046d0:	6398                	ld	a4,0(a5)
    800046d2:	cb19                	beqz	a4,800046e8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046d4:	2505                	addiw	a0,a0,1
    800046d6:	07a1                	addi	a5,a5,8
    800046d8:	fed51ce3          	bne	a0,a3,800046d0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046dc:	557d                	li	a0,-1
}
    800046de:	60e2                	ld	ra,24(sp)
    800046e0:	6442                	ld	s0,16(sp)
    800046e2:	64a2                	ld	s1,8(sp)
    800046e4:	6105                	addi	sp,sp,32
    800046e6:	8082                	ret
      p->ofile[fd] = f;
    800046e8:	01a50793          	addi	a5,a0,26
    800046ec:	078e                	slli	a5,a5,0x3
    800046ee:	963e                	add	a2,a2,a5
    800046f0:	e604                	sd	s1,8(a2)
      return fd;
    800046f2:	b7f5                	j	800046de <fdalloc+0x2c>

00000000800046f4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046f4:	715d                	addi	sp,sp,-80
    800046f6:	e486                	sd	ra,72(sp)
    800046f8:	e0a2                	sd	s0,64(sp)
    800046fa:	fc26                	sd	s1,56(sp)
    800046fc:	f84a                	sd	s2,48(sp)
    800046fe:	f44e                	sd	s3,40(sp)
    80004700:	f052                	sd	s4,32(sp)
    80004702:	ec56                	sd	s5,24(sp)
    80004704:	e85a                	sd	s6,16(sp)
    80004706:	0880                	addi	s0,sp,80
    80004708:	8b2e                	mv	s6,a1
    8000470a:	89b2                	mv	s3,a2
    8000470c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000470e:	fb040593          	addi	a1,s0,-80
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	e74080e7          	jalr	-396(ra) # 80003586 <nameiparent>
    8000471a:	84aa                	mv	s1,a0
    8000471c:	14050b63          	beqz	a0,80004872 <create+0x17e>
    return 0;

  ilock(dp);
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	68e080e7          	jalr	1678(ra) # 80002dae <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004728:	4601                	li	a2,0
    8000472a:	fb040593          	addi	a1,s0,-80
    8000472e:	8526                	mv	a0,s1
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	b76080e7          	jalr	-1162(ra) # 800032a6 <dirlookup>
    80004738:	8aaa                	mv	s5,a0
    8000473a:	c921                	beqz	a0,8000478a <create+0x96>
    iunlockput(dp);
    8000473c:	8526                	mv	a0,s1
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	8e6080e7          	jalr	-1818(ra) # 80003024 <iunlockput>
    ilock(ip);
    80004746:	8556                	mv	a0,s5
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	666080e7          	jalr	1638(ra) # 80002dae <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004750:	4789                	li	a5,2
    80004752:	02fb1563          	bne	s6,a5,8000477c <create+0x88>
    80004756:	04cad783          	lhu	a5,76(s5)
    8000475a:	37f9                	addiw	a5,a5,-2
    8000475c:	17c2                	slli	a5,a5,0x30
    8000475e:	93c1                	srli	a5,a5,0x30
    80004760:	4705                	li	a4,1
    80004762:	00f76d63          	bltu	a4,a5,8000477c <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004766:	8556                	mv	a0,s5
    80004768:	60a6                	ld	ra,72(sp)
    8000476a:	6406                	ld	s0,64(sp)
    8000476c:	74e2                	ld	s1,56(sp)
    8000476e:	7942                	ld	s2,48(sp)
    80004770:	79a2                	ld	s3,40(sp)
    80004772:	7a02                	ld	s4,32(sp)
    80004774:	6ae2                	ld	s5,24(sp)
    80004776:	6b42                	ld	s6,16(sp)
    80004778:	6161                	addi	sp,sp,80
    8000477a:	8082                	ret
    iunlockput(ip);
    8000477c:	8556                	mv	a0,s5
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	8a6080e7          	jalr	-1882(ra) # 80003024 <iunlockput>
    return 0;
    80004786:	4a81                	li	s5,0
    80004788:	bff9                	j	80004766 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000478a:	85da                	mv	a1,s6
    8000478c:	4088                	lw	a0,0(s1)
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	488080e7          	jalr	1160(ra) # 80002c16 <ialloc>
    80004796:	8a2a                	mv	s4,a0
    80004798:	c529                	beqz	a0,800047e2 <create+0xee>
  ilock(ip);
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	614080e7          	jalr	1556(ra) # 80002dae <ilock>
  ip->major = major;
    800047a2:	053a1723          	sh	s3,78(s4)
  ip->minor = minor;
    800047a6:	052a1823          	sh	s2,80(s4)
  ip->nlink = 1;
    800047aa:	4905                	li	s2,1
    800047ac:	052a1923          	sh	s2,82(s4)
  iupdate(ip);
    800047b0:	8552                	mv	a0,s4
    800047b2:	ffffe097          	auipc	ra,0xffffe
    800047b6:	530080e7          	jalr	1328(ra) # 80002ce2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047ba:	032b0b63          	beq	s6,s2,800047f0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800047be:	004a2603          	lw	a2,4(s4)
    800047c2:	fb040593          	addi	a1,s0,-80
    800047c6:	8526                	mv	a0,s1
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	cee080e7          	jalr	-786(ra) # 800034b6 <dirlink>
    800047d0:	06054f63          	bltz	a0,8000484e <create+0x15a>
  iunlockput(dp);
    800047d4:	8526                	mv	a0,s1
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	84e080e7          	jalr	-1970(ra) # 80003024 <iunlockput>
  return ip;
    800047de:	8ad2                	mv	s5,s4
    800047e0:	b759                	j	80004766 <create+0x72>
    iunlockput(dp);
    800047e2:	8526                	mv	a0,s1
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	840080e7          	jalr	-1984(ra) # 80003024 <iunlockput>
    return 0;
    800047ec:	8ad2                	mv	s5,s4
    800047ee:	bfa5                	j	80004766 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047f0:	004a2603          	lw	a2,4(s4)
    800047f4:	00004597          	auipc	a1,0x4
    800047f8:	e7c58593          	addi	a1,a1,-388 # 80008670 <syscalls+0x2a0>
    800047fc:	8552                	mv	a0,s4
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	cb8080e7          	jalr	-840(ra) # 800034b6 <dirlink>
    80004806:	04054463          	bltz	a0,8000484e <create+0x15a>
    8000480a:	40d0                	lw	a2,4(s1)
    8000480c:	00004597          	auipc	a1,0x4
    80004810:	e6c58593          	addi	a1,a1,-404 # 80008678 <syscalls+0x2a8>
    80004814:	8552                	mv	a0,s4
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	ca0080e7          	jalr	-864(ra) # 800034b6 <dirlink>
    8000481e:	02054863          	bltz	a0,8000484e <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80004822:	004a2603          	lw	a2,4(s4)
    80004826:	fb040593          	addi	a1,s0,-80
    8000482a:	8526                	mv	a0,s1
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	c8a080e7          	jalr	-886(ra) # 800034b6 <dirlink>
    80004834:	00054d63          	bltz	a0,8000484e <create+0x15a>
    dp->nlink++;  // for ".."
    80004838:	0524d783          	lhu	a5,82(s1)
    8000483c:	2785                	addiw	a5,a5,1
    8000483e:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004842:	8526                	mv	a0,s1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	49e080e7          	jalr	1182(ra) # 80002ce2 <iupdate>
    8000484c:	b761                	j	800047d4 <create+0xe0>
  ip->nlink = 0;
    8000484e:	040a1923          	sh	zero,82(s4)
  iupdate(ip);
    80004852:	8552                	mv	a0,s4
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	48e080e7          	jalr	1166(ra) # 80002ce2 <iupdate>
  iunlockput(ip);
    8000485c:	8552                	mv	a0,s4
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	7c6080e7          	jalr	1990(ra) # 80003024 <iunlockput>
  iunlockput(dp);
    80004866:	8526                	mv	a0,s1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	7bc080e7          	jalr	1980(ra) # 80003024 <iunlockput>
  return 0;
    80004870:	bddd                	j	80004766 <create+0x72>
    return 0;
    80004872:	8aaa                	mv	s5,a0
    80004874:	bdcd                	j	80004766 <create+0x72>

0000000080004876 <sys_dup>:
{
    80004876:	7179                	addi	sp,sp,-48
    80004878:	f406                	sd	ra,40(sp)
    8000487a:	f022                	sd	s0,32(sp)
    8000487c:	ec26                	sd	s1,24(sp)
    8000487e:	e84a                	sd	s2,16(sp)
    80004880:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004882:	fd840613          	addi	a2,s0,-40
    80004886:	4581                	li	a1,0
    80004888:	4501                	li	a0,0
    8000488a:	00000097          	auipc	ra,0x0
    8000488e:	dc8080e7          	jalr	-568(ra) # 80004652 <argfd>
    return -1;
    80004892:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004894:	02054363          	bltz	a0,800048ba <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004898:	fd843903          	ld	s2,-40(s0)
    8000489c:	854a                	mv	a0,s2
    8000489e:	00000097          	auipc	ra,0x0
    800048a2:	e14080e7          	jalr	-492(ra) # 800046b2 <fdalloc>
    800048a6:	84aa                	mv	s1,a0
    return -1;
    800048a8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048aa:	00054863          	bltz	a0,800048ba <sys_dup+0x44>
  filedup(f);
    800048ae:	854a                	mv	a0,s2
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	32a080e7          	jalr	810(ra) # 80003bda <filedup>
  return fd;
    800048b8:	87a6                	mv	a5,s1
}
    800048ba:	853e                	mv	a0,a5
    800048bc:	70a2                	ld	ra,40(sp)
    800048be:	7402                	ld	s0,32(sp)
    800048c0:	64e2                	ld	s1,24(sp)
    800048c2:	6942                	ld	s2,16(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret

00000000800048c8 <sys_read>:
{
    800048c8:	7179                	addi	sp,sp,-48
    800048ca:	f406                	sd	ra,40(sp)
    800048cc:	f022                	sd	s0,32(sp)
    800048ce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048d0:	fd840593          	addi	a1,s0,-40
    800048d4:	4505                	li	a0,1
    800048d6:	ffffd097          	auipc	ra,0xffffd
    800048da:	7ae080e7          	jalr	1966(ra) # 80002084 <argaddr>
  argint(2, &n);
    800048de:	fe440593          	addi	a1,s0,-28
    800048e2:	4509                	li	a0,2
    800048e4:	ffffd097          	auipc	ra,0xffffd
    800048e8:	780080e7          	jalr	1920(ra) # 80002064 <argint>
  if(argfd(0, 0, &f) < 0)
    800048ec:	fe840613          	addi	a2,s0,-24
    800048f0:	4581                	li	a1,0
    800048f2:	4501                	li	a0,0
    800048f4:	00000097          	auipc	ra,0x0
    800048f8:	d5e080e7          	jalr	-674(ra) # 80004652 <argfd>
    800048fc:	87aa                	mv	a5,a0
    return -1;
    800048fe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004900:	0007cc63          	bltz	a5,80004918 <sys_read+0x50>
  return fileread(f, p, n);
    80004904:	fe442603          	lw	a2,-28(s0)
    80004908:	fd843583          	ld	a1,-40(s0)
    8000490c:	fe843503          	ld	a0,-24(s0)
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	456080e7          	jalr	1110(ra) # 80003d66 <fileread>
}
    80004918:	70a2                	ld	ra,40(sp)
    8000491a:	7402                	ld	s0,32(sp)
    8000491c:	6145                	addi	sp,sp,48
    8000491e:	8082                	ret

0000000080004920 <sys_write>:
{
    80004920:	7179                	addi	sp,sp,-48
    80004922:	f406                	sd	ra,40(sp)
    80004924:	f022                	sd	s0,32(sp)
    80004926:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004928:	fd840593          	addi	a1,s0,-40
    8000492c:	4505                	li	a0,1
    8000492e:	ffffd097          	auipc	ra,0xffffd
    80004932:	756080e7          	jalr	1878(ra) # 80002084 <argaddr>
  argint(2, &n);
    80004936:	fe440593          	addi	a1,s0,-28
    8000493a:	4509                	li	a0,2
    8000493c:	ffffd097          	auipc	ra,0xffffd
    80004940:	728080e7          	jalr	1832(ra) # 80002064 <argint>
  if(argfd(0, 0, &f) < 0)
    80004944:	fe840613          	addi	a2,s0,-24
    80004948:	4581                	li	a1,0
    8000494a:	4501                	li	a0,0
    8000494c:	00000097          	auipc	ra,0x0
    80004950:	d06080e7          	jalr	-762(ra) # 80004652 <argfd>
    80004954:	87aa                	mv	a5,a0
    return -1;
    80004956:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004958:	0007cc63          	bltz	a5,80004970 <sys_write+0x50>
  return filewrite(f, p, n);
    8000495c:	fe442603          	lw	a2,-28(s0)
    80004960:	fd843583          	ld	a1,-40(s0)
    80004964:	fe843503          	ld	a0,-24(s0)
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	4c0080e7          	jalr	1216(ra) # 80003e28 <filewrite>
}
    80004970:	70a2                	ld	ra,40(sp)
    80004972:	7402                	ld	s0,32(sp)
    80004974:	6145                	addi	sp,sp,48
    80004976:	8082                	ret

0000000080004978 <sys_close>:
{
    80004978:	1101                	addi	sp,sp,-32
    8000497a:	ec06                	sd	ra,24(sp)
    8000497c:	e822                	sd	s0,16(sp)
    8000497e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004980:	fe040613          	addi	a2,s0,-32
    80004984:	fec40593          	addi	a1,s0,-20
    80004988:	4501                	li	a0,0
    8000498a:	00000097          	auipc	ra,0x0
    8000498e:	cc8080e7          	jalr	-824(ra) # 80004652 <argfd>
    return -1;
    80004992:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004994:	02054463          	bltz	a0,800049bc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004998:	ffffc097          	auipc	ra,0xffffc
    8000499c:	5b2080e7          	jalr	1458(ra) # 80000f4a <myproc>
    800049a0:	fec42783          	lw	a5,-20(s0)
    800049a4:	07e9                	addi	a5,a5,26
    800049a6:	078e                	slli	a5,a5,0x3
    800049a8:	953e                	add	a0,a0,a5
    800049aa:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800049ae:	fe043503          	ld	a0,-32(s0)
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	27a080e7          	jalr	634(ra) # 80003c2c <fileclose>
  return 0;
    800049ba:	4781                	li	a5,0
}
    800049bc:	853e                	mv	a0,a5
    800049be:	60e2                	ld	ra,24(sp)
    800049c0:	6442                	ld	s0,16(sp)
    800049c2:	6105                	addi	sp,sp,32
    800049c4:	8082                	ret

00000000800049c6 <sys_fstat>:
{
    800049c6:	1101                	addi	sp,sp,-32
    800049c8:	ec06                	sd	ra,24(sp)
    800049ca:	e822                	sd	s0,16(sp)
    800049cc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049ce:	fe040593          	addi	a1,s0,-32
    800049d2:	4505                	li	a0,1
    800049d4:	ffffd097          	auipc	ra,0xffffd
    800049d8:	6b0080e7          	jalr	1712(ra) # 80002084 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049dc:	fe840613          	addi	a2,s0,-24
    800049e0:	4581                	li	a1,0
    800049e2:	4501                	li	a0,0
    800049e4:	00000097          	auipc	ra,0x0
    800049e8:	c6e080e7          	jalr	-914(ra) # 80004652 <argfd>
    800049ec:	87aa                	mv	a5,a0
    return -1;
    800049ee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049f0:	0007ca63          	bltz	a5,80004a04 <sys_fstat+0x3e>
  return filestat(f, st);
    800049f4:	fe043583          	ld	a1,-32(s0)
    800049f8:	fe843503          	ld	a0,-24(s0)
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	2f8080e7          	jalr	760(ra) # 80003cf4 <filestat>
}
    80004a04:	60e2                	ld	ra,24(sp)
    80004a06:	6442                	ld	s0,16(sp)
    80004a08:	6105                	addi	sp,sp,32
    80004a0a:	8082                	ret

0000000080004a0c <sys_link>:
{
    80004a0c:	7169                	addi	sp,sp,-304
    80004a0e:	f606                	sd	ra,296(sp)
    80004a10:	f222                	sd	s0,288(sp)
    80004a12:	ee26                	sd	s1,280(sp)
    80004a14:	ea4a                	sd	s2,272(sp)
    80004a16:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a18:	08000613          	li	a2,128
    80004a1c:	ed040593          	addi	a1,s0,-304
    80004a20:	4501                	li	a0,0
    80004a22:	ffffd097          	auipc	ra,0xffffd
    80004a26:	682080e7          	jalr	1666(ra) # 800020a4 <argstr>
    return -1;
    80004a2a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a2c:	10054e63          	bltz	a0,80004b48 <sys_link+0x13c>
    80004a30:	08000613          	li	a2,128
    80004a34:	f5040593          	addi	a1,s0,-176
    80004a38:	4505                	li	a0,1
    80004a3a:	ffffd097          	auipc	ra,0xffffd
    80004a3e:	66a080e7          	jalr	1642(ra) # 800020a4 <argstr>
    return -1;
    80004a42:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a44:	10054263          	bltz	a0,80004b48 <sys_link+0x13c>
  begin_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	d20080e7          	jalr	-736(ra) # 80003768 <begin_op>
  if((ip = namei(old)) == 0){
    80004a50:	ed040513          	addi	a0,s0,-304
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	b14080e7          	jalr	-1260(ra) # 80003568 <namei>
    80004a5c:	84aa                	mv	s1,a0
    80004a5e:	c551                	beqz	a0,80004aea <sys_link+0xde>
  ilock(ip);
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	34e080e7          	jalr	846(ra) # 80002dae <ilock>
  if(ip->type == T_DIR){
    80004a68:	04c49703          	lh	a4,76(s1)
    80004a6c:	4785                	li	a5,1
    80004a6e:	08f70463          	beq	a4,a5,80004af6 <sys_link+0xea>
  ip->nlink++;
    80004a72:	0524d783          	lhu	a5,82(s1)
    80004a76:	2785                	addiw	a5,a5,1
    80004a78:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	264080e7          	jalr	612(ra) # 80002ce2 <iupdate>
  iunlock(ip);
    80004a86:	8526                	mv	a0,s1
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	3f2080e7          	jalr	1010(ra) # 80002e7a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a90:	fd040593          	addi	a1,s0,-48
    80004a94:	f5040513          	addi	a0,s0,-176
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	aee080e7          	jalr	-1298(ra) # 80003586 <nameiparent>
    80004aa0:	892a                	mv	s2,a0
    80004aa2:	c935                	beqz	a0,80004b16 <sys_link+0x10a>
  ilock(dp);
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	30a080e7          	jalr	778(ra) # 80002dae <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aac:	00092703          	lw	a4,0(s2)
    80004ab0:	409c                	lw	a5,0(s1)
    80004ab2:	04f71d63          	bne	a4,a5,80004b0c <sys_link+0x100>
    80004ab6:	40d0                	lw	a2,4(s1)
    80004ab8:	fd040593          	addi	a1,s0,-48
    80004abc:	854a                	mv	a0,s2
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	9f8080e7          	jalr	-1544(ra) # 800034b6 <dirlink>
    80004ac6:	04054363          	bltz	a0,80004b0c <sys_link+0x100>
  iunlockput(dp);
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	558080e7          	jalr	1368(ra) # 80003024 <iunlockput>
  iput(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	4a6080e7          	jalr	1190(ra) # 80002f7c <iput>
  end_op();
    80004ade:	fffff097          	auipc	ra,0xfffff
    80004ae2:	d04080e7          	jalr	-764(ra) # 800037e2 <end_op>
  return 0;
    80004ae6:	4781                	li	a5,0
    80004ae8:	a085                	j	80004b48 <sys_link+0x13c>
    end_op();
    80004aea:	fffff097          	auipc	ra,0xfffff
    80004aee:	cf8080e7          	jalr	-776(ra) # 800037e2 <end_op>
    return -1;
    80004af2:	57fd                	li	a5,-1
    80004af4:	a891                	j	80004b48 <sys_link+0x13c>
    iunlockput(ip);
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	52c080e7          	jalr	1324(ra) # 80003024 <iunlockput>
    end_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	ce2080e7          	jalr	-798(ra) # 800037e2 <end_op>
    return -1;
    80004b08:	57fd                	li	a5,-1
    80004b0a:	a83d                	j	80004b48 <sys_link+0x13c>
    iunlockput(dp);
    80004b0c:	854a                	mv	a0,s2
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	516080e7          	jalr	1302(ra) # 80003024 <iunlockput>
  ilock(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	296080e7          	jalr	662(ra) # 80002dae <ilock>
  ip->nlink--;
    80004b20:	0524d783          	lhu	a5,82(s1)
    80004b24:	37fd                	addiw	a5,a5,-1
    80004b26:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	1b6080e7          	jalr	438(ra) # 80002ce2 <iupdate>
  iunlockput(ip);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	4ee080e7          	jalr	1262(ra) # 80003024 <iunlockput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	ca4080e7          	jalr	-860(ra) # 800037e2 <end_op>
  return -1;
    80004b46:	57fd                	li	a5,-1
}
    80004b48:	853e                	mv	a0,a5
    80004b4a:	70b2                	ld	ra,296(sp)
    80004b4c:	7412                	ld	s0,288(sp)
    80004b4e:	64f2                	ld	s1,280(sp)
    80004b50:	6952                	ld	s2,272(sp)
    80004b52:	6155                	addi	sp,sp,304
    80004b54:	8082                	ret

0000000080004b56 <sys_unlink>:
{
    80004b56:	7151                	addi	sp,sp,-240
    80004b58:	f586                	sd	ra,232(sp)
    80004b5a:	f1a2                	sd	s0,224(sp)
    80004b5c:	eda6                	sd	s1,216(sp)
    80004b5e:	e9ca                	sd	s2,208(sp)
    80004b60:	e5ce                	sd	s3,200(sp)
    80004b62:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b64:	08000613          	li	a2,128
    80004b68:	f3040593          	addi	a1,s0,-208
    80004b6c:	4501                	li	a0,0
    80004b6e:	ffffd097          	auipc	ra,0xffffd
    80004b72:	536080e7          	jalr	1334(ra) # 800020a4 <argstr>
    80004b76:	18054163          	bltz	a0,80004cf8 <sys_unlink+0x1a2>
  begin_op();
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	bee080e7          	jalr	-1042(ra) # 80003768 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b82:	fb040593          	addi	a1,s0,-80
    80004b86:	f3040513          	addi	a0,s0,-208
    80004b8a:	fffff097          	auipc	ra,0xfffff
    80004b8e:	9fc080e7          	jalr	-1540(ra) # 80003586 <nameiparent>
    80004b92:	84aa                	mv	s1,a0
    80004b94:	c979                	beqz	a0,80004c6a <sys_unlink+0x114>
  ilock(dp);
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	218080e7          	jalr	536(ra) # 80002dae <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b9e:	00004597          	auipc	a1,0x4
    80004ba2:	ad258593          	addi	a1,a1,-1326 # 80008670 <syscalls+0x2a0>
    80004ba6:	fb040513          	addi	a0,s0,-80
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	6e2080e7          	jalr	1762(ra) # 8000328c <namecmp>
    80004bb2:	14050a63          	beqz	a0,80004d06 <sys_unlink+0x1b0>
    80004bb6:	00004597          	auipc	a1,0x4
    80004bba:	ac258593          	addi	a1,a1,-1342 # 80008678 <syscalls+0x2a8>
    80004bbe:	fb040513          	addi	a0,s0,-80
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	6ca080e7          	jalr	1738(ra) # 8000328c <namecmp>
    80004bca:	12050e63          	beqz	a0,80004d06 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bce:	f2c40613          	addi	a2,s0,-212
    80004bd2:	fb040593          	addi	a1,s0,-80
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	6ce080e7          	jalr	1742(ra) # 800032a6 <dirlookup>
    80004be0:	892a                	mv	s2,a0
    80004be2:	12050263          	beqz	a0,80004d06 <sys_unlink+0x1b0>
  ilock(ip);
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	1c8080e7          	jalr	456(ra) # 80002dae <ilock>
  if(ip->nlink < 1)
    80004bee:	05291783          	lh	a5,82(s2)
    80004bf2:	08f05263          	blez	a5,80004c76 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bf6:	04c91703          	lh	a4,76(s2)
    80004bfa:	4785                	li	a5,1
    80004bfc:	08f70563          	beq	a4,a5,80004c86 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c00:	4641                	li	a2,16
    80004c02:	4581                	li	a1,0
    80004c04:	fc040513          	addi	a0,s0,-64
    80004c08:	ffffb097          	auipc	ra,0xffffb
    80004c0c:	65a080e7          	jalr	1626(ra) # 80000262 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c10:	4741                	li	a4,16
    80004c12:	f2c42683          	lw	a3,-212(s0)
    80004c16:	fc040613          	addi	a2,s0,-64
    80004c1a:	4581                	li	a1,0
    80004c1c:	8526                	mv	a0,s1
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	550080e7          	jalr	1360(ra) # 8000316e <writei>
    80004c26:	47c1                	li	a5,16
    80004c28:	0af51563          	bne	a0,a5,80004cd2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c2c:	04c91703          	lh	a4,76(s2)
    80004c30:	4785                	li	a5,1
    80004c32:	0af70863          	beq	a4,a5,80004ce2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c36:	8526                	mv	a0,s1
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	3ec080e7          	jalr	1004(ra) # 80003024 <iunlockput>
  ip->nlink--;
    80004c40:	05295783          	lhu	a5,82(s2)
    80004c44:	37fd                	addiw	a5,a5,-1
    80004c46:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c4a:	854a                	mv	a0,s2
    80004c4c:	ffffe097          	auipc	ra,0xffffe
    80004c50:	096080e7          	jalr	150(ra) # 80002ce2 <iupdate>
  iunlockput(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	3ce080e7          	jalr	974(ra) # 80003024 <iunlockput>
  end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	b84080e7          	jalr	-1148(ra) # 800037e2 <end_op>
  return 0;
    80004c66:	4501                	li	a0,0
    80004c68:	a84d                	j	80004d1a <sys_unlink+0x1c4>
    end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	b78080e7          	jalr	-1160(ra) # 800037e2 <end_op>
    return -1;
    80004c72:	557d                	li	a0,-1
    80004c74:	a05d                	j	80004d1a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c76:	00004517          	auipc	a0,0x4
    80004c7a:	a0a50513          	addi	a0,a0,-1526 # 80008680 <syscalls+0x2b0>
    80004c7e:	00001097          	auipc	ra,0x1
    80004c82:	4e4080e7          	jalr	1252(ra) # 80006162 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c86:	05492703          	lw	a4,84(s2)
    80004c8a:	02000793          	li	a5,32
    80004c8e:	f6e7f9e3          	bgeu	a5,a4,80004c00 <sys_unlink+0xaa>
    80004c92:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c96:	4741                	li	a4,16
    80004c98:	86ce                	mv	a3,s3
    80004c9a:	f1840613          	addi	a2,s0,-232
    80004c9e:	4581                	li	a1,0
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	3d4080e7          	jalr	980(ra) # 80003076 <readi>
    80004caa:	47c1                	li	a5,16
    80004cac:	00f51b63          	bne	a0,a5,80004cc2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cb0:	f1845783          	lhu	a5,-232(s0)
    80004cb4:	e7a1                	bnez	a5,80004cfc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb6:	29c1                	addiw	s3,s3,16
    80004cb8:	05492783          	lw	a5,84(s2)
    80004cbc:	fcf9ede3          	bltu	s3,a5,80004c96 <sys_unlink+0x140>
    80004cc0:	b781                	j	80004c00 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cc2:	00004517          	auipc	a0,0x4
    80004cc6:	9d650513          	addi	a0,a0,-1578 # 80008698 <syscalls+0x2c8>
    80004cca:	00001097          	auipc	ra,0x1
    80004cce:	498080e7          	jalr	1176(ra) # 80006162 <panic>
    panic("unlink: writei");
    80004cd2:	00004517          	auipc	a0,0x4
    80004cd6:	9de50513          	addi	a0,a0,-1570 # 800086b0 <syscalls+0x2e0>
    80004cda:	00001097          	auipc	ra,0x1
    80004cde:	488080e7          	jalr	1160(ra) # 80006162 <panic>
    dp->nlink--;
    80004ce2:	0524d783          	lhu	a5,82(s1)
    80004ce6:	37fd                	addiw	a5,a5,-1
    80004ce8:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004cec:	8526                	mv	a0,s1
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	ff4080e7          	jalr	-12(ra) # 80002ce2 <iupdate>
    80004cf6:	b781                	j	80004c36 <sys_unlink+0xe0>
    return -1;
    80004cf8:	557d                	li	a0,-1
    80004cfa:	a005                	j	80004d1a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cfc:	854a                	mv	a0,s2
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	326080e7          	jalr	806(ra) # 80003024 <iunlockput>
  iunlockput(dp);
    80004d06:	8526                	mv	a0,s1
    80004d08:	ffffe097          	auipc	ra,0xffffe
    80004d0c:	31c080e7          	jalr	796(ra) # 80003024 <iunlockput>
  end_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	ad2080e7          	jalr	-1326(ra) # 800037e2 <end_op>
  return -1;
    80004d18:	557d                	li	a0,-1
}
    80004d1a:	70ae                	ld	ra,232(sp)
    80004d1c:	740e                	ld	s0,224(sp)
    80004d1e:	64ee                	ld	s1,216(sp)
    80004d20:	694e                	ld	s2,208(sp)
    80004d22:	69ae                	ld	s3,200(sp)
    80004d24:	616d                	addi	sp,sp,240
    80004d26:	8082                	ret

0000000080004d28 <sys_open>:

uint64
sys_open(void)
{
    80004d28:	7131                	addi	sp,sp,-192
    80004d2a:	fd06                	sd	ra,184(sp)
    80004d2c:	f922                	sd	s0,176(sp)
    80004d2e:	f526                	sd	s1,168(sp)
    80004d30:	f14a                	sd	s2,160(sp)
    80004d32:	ed4e                	sd	s3,152(sp)
    80004d34:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d36:	f4c40593          	addi	a1,s0,-180
    80004d3a:	4505                	li	a0,1
    80004d3c:	ffffd097          	auipc	ra,0xffffd
    80004d40:	328080e7          	jalr	808(ra) # 80002064 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d44:	08000613          	li	a2,128
    80004d48:	f5040593          	addi	a1,s0,-176
    80004d4c:	4501                	li	a0,0
    80004d4e:	ffffd097          	auipc	ra,0xffffd
    80004d52:	356080e7          	jalr	854(ra) # 800020a4 <argstr>
    80004d56:	87aa                	mv	a5,a0
    return -1;
    80004d58:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d5a:	0a07c863          	bltz	a5,80004e0a <sys_open+0xe2>

  begin_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	a0a080e7          	jalr	-1526(ra) # 80003768 <begin_op>

  if(omode & O_CREATE){
    80004d66:	f4c42783          	lw	a5,-180(s0)
    80004d6a:	2007f793          	andi	a5,a5,512
    80004d6e:	cbdd                	beqz	a5,80004e24 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004d70:	4681                	li	a3,0
    80004d72:	4601                	li	a2,0
    80004d74:	4589                	li	a1,2
    80004d76:	f5040513          	addi	a0,s0,-176
    80004d7a:	00000097          	auipc	ra,0x0
    80004d7e:	97a080e7          	jalr	-1670(ra) # 800046f4 <create>
    80004d82:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d84:	c951                	beqz	a0,80004e18 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d86:	04c49703          	lh	a4,76(s1)
    80004d8a:	478d                	li	a5,3
    80004d8c:	00f71763          	bne	a4,a5,80004d9a <sys_open+0x72>
    80004d90:	04e4d703          	lhu	a4,78(s1)
    80004d94:	47a5                	li	a5,9
    80004d96:	0ce7ec63          	bltu	a5,a4,80004e6e <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	dd6080e7          	jalr	-554(ra) # 80003b70 <filealloc>
    80004da2:	892a                	mv	s2,a0
    80004da4:	c56d                	beqz	a0,80004e8e <sys_open+0x166>
    80004da6:	00000097          	auipc	ra,0x0
    80004daa:	90c080e7          	jalr	-1780(ra) # 800046b2 <fdalloc>
    80004dae:	89aa                	mv	s3,a0
    80004db0:	0c054a63          	bltz	a0,80004e84 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004db4:	04c49703          	lh	a4,76(s1)
    80004db8:	478d                	li	a5,3
    80004dba:	0ef70563          	beq	a4,a5,80004ea4 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dbe:	4789                	li	a5,2
    80004dc0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004dc4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004dc8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004dcc:	f4c42783          	lw	a5,-180(s0)
    80004dd0:	0017c713          	xori	a4,a5,1
    80004dd4:	8b05                	andi	a4,a4,1
    80004dd6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dda:	0037f713          	andi	a4,a5,3
    80004dde:	00e03733          	snez	a4,a4
    80004de2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004de6:	4007f793          	andi	a5,a5,1024
    80004dea:	c791                	beqz	a5,80004df6 <sys_open+0xce>
    80004dec:	04c49703          	lh	a4,76(s1)
    80004df0:	4789                	li	a5,2
    80004df2:	0cf70063          	beq	a4,a5,80004eb2 <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004df6:	8526                	mv	a0,s1
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	082080e7          	jalr	130(ra) # 80002e7a <iunlock>
  end_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	9e2080e7          	jalr	-1566(ra) # 800037e2 <end_op>

  return fd;
    80004e08:	854e                	mv	a0,s3
}
    80004e0a:	70ea                	ld	ra,184(sp)
    80004e0c:	744a                	ld	s0,176(sp)
    80004e0e:	74aa                	ld	s1,168(sp)
    80004e10:	790a                	ld	s2,160(sp)
    80004e12:	69ea                	ld	s3,152(sp)
    80004e14:	6129                	addi	sp,sp,192
    80004e16:	8082                	ret
      end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	9ca080e7          	jalr	-1590(ra) # 800037e2 <end_op>
      return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	b7e5                	j	80004e0a <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004e24:	f5040513          	addi	a0,s0,-176
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	740080e7          	jalr	1856(ra) # 80003568 <namei>
    80004e30:	84aa                	mv	s1,a0
    80004e32:	c905                	beqz	a0,80004e62 <sys_open+0x13a>
    ilock(ip);
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	f7a080e7          	jalr	-134(ra) # 80002dae <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e3c:	04c49703          	lh	a4,76(s1)
    80004e40:	4785                	li	a5,1
    80004e42:	f4f712e3          	bne	a4,a5,80004d86 <sys_open+0x5e>
    80004e46:	f4c42783          	lw	a5,-180(s0)
    80004e4a:	dba1                	beqz	a5,80004d9a <sys_open+0x72>
      iunlockput(ip);
    80004e4c:	8526                	mv	a0,s1
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	1d6080e7          	jalr	470(ra) # 80003024 <iunlockput>
      end_op();
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	98c080e7          	jalr	-1652(ra) # 800037e2 <end_op>
      return -1;
    80004e5e:	557d                	li	a0,-1
    80004e60:	b76d                	j	80004e0a <sys_open+0xe2>
      end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	980080e7          	jalr	-1664(ra) # 800037e2 <end_op>
      return -1;
    80004e6a:	557d                	li	a0,-1
    80004e6c:	bf79                	j	80004e0a <sys_open+0xe2>
    iunlockput(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	1b4080e7          	jalr	436(ra) # 80003024 <iunlockput>
    end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	96a080e7          	jalr	-1686(ra) # 800037e2 <end_op>
    return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b761                	j	80004e0a <sys_open+0xe2>
      fileclose(f);
    80004e84:	854a                	mv	a0,s2
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	da6080e7          	jalr	-602(ra) # 80003c2c <fileclose>
    iunlockput(ip);
    80004e8e:	8526                	mv	a0,s1
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	194080e7          	jalr	404(ra) # 80003024 <iunlockput>
    end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	94a080e7          	jalr	-1718(ra) # 800037e2 <end_op>
    return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	b7a5                	j	80004e0a <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004ea4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ea8:	04e49783          	lh	a5,78(s1)
    80004eac:	02f91223          	sh	a5,36(s2)
    80004eb0:	bf21                	j	80004dc8 <sys_open+0xa0>
    itrunc(ip);
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	01c080e7          	jalr	28(ra) # 80002ed0 <itrunc>
    80004ebc:	bf2d                	j	80004df6 <sys_open+0xce>

0000000080004ebe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ebe:	7175                	addi	sp,sp,-144
    80004ec0:	e506                	sd	ra,136(sp)
    80004ec2:	e122                	sd	s0,128(sp)
    80004ec4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	8a2080e7          	jalr	-1886(ra) # 80003768 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ece:	08000613          	li	a2,128
    80004ed2:	f7040593          	addi	a1,s0,-144
    80004ed6:	4501                	li	a0,0
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	1cc080e7          	jalr	460(ra) # 800020a4 <argstr>
    80004ee0:	02054963          	bltz	a0,80004f12 <sys_mkdir+0x54>
    80004ee4:	4681                	li	a3,0
    80004ee6:	4601                	li	a2,0
    80004ee8:	4585                	li	a1,1
    80004eea:	f7040513          	addi	a0,s0,-144
    80004eee:	00000097          	auipc	ra,0x0
    80004ef2:	806080e7          	jalr	-2042(ra) # 800046f4 <create>
    80004ef6:	cd11                	beqz	a0,80004f12 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	12c080e7          	jalr	300(ra) # 80003024 <iunlockput>
  end_op();
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	8e2080e7          	jalr	-1822(ra) # 800037e2 <end_op>
  return 0;
    80004f08:	4501                	li	a0,0
}
    80004f0a:	60aa                	ld	ra,136(sp)
    80004f0c:	640a                	ld	s0,128(sp)
    80004f0e:	6149                	addi	sp,sp,144
    80004f10:	8082                	ret
    end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	8d0080e7          	jalr	-1840(ra) # 800037e2 <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	b7fd                	j	80004f0a <sys_mkdir+0x4c>

0000000080004f1e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f1e:	7135                	addi	sp,sp,-160
    80004f20:	ed06                	sd	ra,152(sp)
    80004f22:	e922                	sd	s0,144(sp)
    80004f24:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	842080e7          	jalr	-1982(ra) # 80003768 <begin_op>
  argint(1, &major);
    80004f2e:	f6c40593          	addi	a1,s0,-148
    80004f32:	4505                	li	a0,1
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	130080e7          	jalr	304(ra) # 80002064 <argint>
  argint(2, &minor);
    80004f3c:	f6840593          	addi	a1,s0,-152
    80004f40:	4509                	li	a0,2
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	122080e7          	jalr	290(ra) # 80002064 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f4a:	08000613          	li	a2,128
    80004f4e:	f7040593          	addi	a1,s0,-144
    80004f52:	4501                	li	a0,0
    80004f54:	ffffd097          	auipc	ra,0xffffd
    80004f58:	150080e7          	jalr	336(ra) # 800020a4 <argstr>
    80004f5c:	02054b63          	bltz	a0,80004f92 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f60:	f6841683          	lh	a3,-152(s0)
    80004f64:	f6c41603          	lh	a2,-148(s0)
    80004f68:	458d                	li	a1,3
    80004f6a:	f7040513          	addi	a0,s0,-144
    80004f6e:	fffff097          	auipc	ra,0xfffff
    80004f72:	786080e7          	jalr	1926(ra) # 800046f4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f76:	cd11                	beqz	a0,80004f92 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f78:	ffffe097          	auipc	ra,0xffffe
    80004f7c:	0ac080e7          	jalr	172(ra) # 80003024 <iunlockput>
  end_op();
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	862080e7          	jalr	-1950(ra) # 800037e2 <end_op>
  return 0;
    80004f88:	4501                	li	a0,0
}
    80004f8a:	60ea                	ld	ra,152(sp)
    80004f8c:	644a                	ld	s0,144(sp)
    80004f8e:	610d                	addi	sp,sp,160
    80004f90:	8082                	ret
    end_op();
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	850080e7          	jalr	-1968(ra) # 800037e2 <end_op>
    return -1;
    80004f9a:	557d                	li	a0,-1
    80004f9c:	b7fd                	j	80004f8a <sys_mknod+0x6c>

0000000080004f9e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f9e:	7135                	addi	sp,sp,-160
    80004fa0:	ed06                	sd	ra,152(sp)
    80004fa2:	e922                	sd	s0,144(sp)
    80004fa4:	e526                	sd	s1,136(sp)
    80004fa6:	e14a                	sd	s2,128(sp)
    80004fa8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004faa:	ffffc097          	auipc	ra,0xffffc
    80004fae:	fa0080e7          	jalr	-96(ra) # 80000f4a <myproc>
    80004fb2:	892a                	mv	s2,a0
  
  begin_op();
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	7b4080e7          	jalr	1972(ra) # 80003768 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fbc:	08000613          	li	a2,128
    80004fc0:	f6040593          	addi	a1,s0,-160
    80004fc4:	4501                	li	a0,0
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	0de080e7          	jalr	222(ra) # 800020a4 <argstr>
    80004fce:	04054b63          	bltz	a0,80005024 <sys_chdir+0x86>
    80004fd2:	f6040513          	addi	a0,s0,-160
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	592080e7          	jalr	1426(ra) # 80003568 <namei>
    80004fde:	84aa                	mv	s1,a0
    80004fe0:	c131                	beqz	a0,80005024 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	dcc080e7          	jalr	-564(ra) # 80002dae <ilock>
  if(ip->type != T_DIR){
    80004fea:	04c49703          	lh	a4,76(s1)
    80004fee:	4785                	li	a5,1
    80004ff0:	04f71063          	bne	a4,a5,80005030 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	e84080e7          	jalr	-380(ra) # 80002e7a <iunlock>
  iput(p->cwd);
    80004ffe:	15893503          	ld	a0,344(s2)
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	f7a080e7          	jalr	-134(ra) # 80002f7c <iput>
  end_op();
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	7d8080e7          	jalr	2008(ra) # 800037e2 <end_op>
  p->cwd = ip;
    80005012:	14993c23          	sd	s1,344(s2)
  return 0;
    80005016:	4501                	li	a0,0
}
    80005018:	60ea                	ld	ra,152(sp)
    8000501a:	644a                	ld	s0,144(sp)
    8000501c:	64aa                	ld	s1,136(sp)
    8000501e:	690a                	ld	s2,128(sp)
    80005020:	610d                	addi	sp,sp,160
    80005022:	8082                	ret
    end_op();
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	7be080e7          	jalr	1982(ra) # 800037e2 <end_op>
    return -1;
    8000502c:	557d                	li	a0,-1
    8000502e:	b7ed                	j	80005018 <sys_chdir+0x7a>
    iunlockput(ip);
    80005030:	8526                	mv	a0,s1
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	ff2080e7          	jalr	-14(ra) # 80003024 <iunlockput>
    end_op();
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	7a8080e7          	jalr	1960(ra) # 800037e2 <end_op>
    return -1;
    80005042:	557d                	li	a0,-1
    80005044:	bfd1                	j	80005018 <sys_chdir+0x7a>

0000000080005046 <sys_exec>:

uint64
sys_exec(void)
{
    80005046:	7121                	addi	sp,sp,-448
    80005048:	ff06                	sd	ra,440(sp)
    8000504a:	fb22                	sd	s0,432(sp)
    8000504c:	f726                	sd	s1,424(sp)
    8000504e:	f34a                	sd	s2,416(sp)
    80005050:	ef4e                	sd	s3,408(sp)
    80005052:	eb52                	sd	s4,400(sp)
    80005054:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005056:	e4840593          	addi	a1,s0,-440
    8000505a:	4505                	li	a0,1
    8000505c:	ffffd097          	auipc	ra,0xffffd
    80005060:	028080e7          	jalr	40(ra) # 80002084 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005064:	08000613          	li	a2,128
    80005068:	f5040593          	addi	a1,s0,-176
    8000506c:	4501                	li	a0,0
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	036080e7          	jalr	54(ra) # 800020a4 <argstr>
    80005076:	87aa                	mv	a5,a0
    return -1;
    80005078:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000507a:	0c07c263          	bltz	a5,8000513e <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    8000507e:	10000613          	li	a2,256
    80005082:	4581                	li	a1,0
    80005084:	e5040513          	addi	a0,s0,-432
    80005088:	ffffb097          	auipc	ra,0xffffb
    8000508c:	1da080e7          	jalr	474(ra) # 80000262 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005090:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005094:	89a6                	mv	s3,s1
    80005096:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005098:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000509c:	00391513          	slli	a0,s2,0x3
    800050a0:	e4040593          	addi	a1,s0,-448
    800050a4:	e4843783          	ld	a5,-440(s0)
    800050a8:	953e                	add	a0,a0,a5
    800050aa:	ffffd097          	auipc	ra,0xffffd
    800050ae:	f1c080e7          	jalr	-228(ra) # 80001fc6 <fetchaddr>
    800050b2:	02054a63          	bltz	a0,800050e6 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800050b6:	e4043783          	ld	a5,-448(s0)
    800050ba:	c3b9                	beqz	a5,80005100 <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	0ae080e7          	jalr	174(ra) # 8000016a <kalloc>
    800050c4:	85aa                	mv	a1,a0
    800050c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050ca:	cd11                	beqz	a0,800050e6 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050cc:	6605                	lui	a2,0x1
    800050ce:	e4043503          	ld	a0,-448(s0)
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	f46080e7          	jalr	-186(ra) # 80002018 <fetchstr>
    800050da:	00054663          	bltz	a0,800050e6 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    800050de:	0905                	addi	s2,s2,1
    800050e0:	09a1                	addi	s3,s3,8
    800050e2:	fb491de3          	bne	s2,s4,8000509c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e6:	f5040913          	addi	s2,s0,-176
    800050ea:	6088                	ld	a0,0(s1)
    800050ec:	c921                	beqz	a0,8000513c <sys_exec+0xf6>
    kfree(argv[i]);
    800050ee:	ffffb097          	auipc	ra,0xffffb
    800050f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	04a1                	addi	s1,s1,8
    800050f8:	ff2499e3          	bne	s1,s2,800050ea <sys_exec+0xa4>
  return -1;
    800050fc:	557d                	li	a0,-1
    800050fe:	a081                	j	8000513e <sys_exec+0xf8>
      argv[i] = 0;
    80005100:	0009079b          	sext.w	a5,s2
    80005104:	078e                	slli	a5,a5,0x3
    80005106:	fd078793          	addi	a5,a5,-48
    8000510a:	97a2                	add	a5,a5,s0
    8000510c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005110:	e5040593          	addi	a1,s0,-432
    80005114:	f5040513          	addi	a0,s0,-176
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	194080e7          	jalr	404(ra) # 800042ac <exec>
    80005120:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005122:	f5040993          	addi	s3,s0,-176
    80005126:	6088                	ld	a0,0(s1)
    80005128:	c901                	beqz	a0,80005138 <sys_exec+0xf2>
    kfree(argv[i]);
    8000512a:	ffffb097          	auipc	ra,0xffffb
    8000512e:	ef2080e7          	jalr	-270(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005132:	04a1                	addi	s1,s1,8
    80005134:	ff3499e3          	bne	s1,s3,80005126 <sys_exec+0xe0>
  return ret;
    80005138:	854a                	mv	a0,s2
    8000513a:	a011                	j	8000513e <sys_exec+0xf8>
  return -1;
    8000513c:	557d                	li	a0,-1
}
    8000513e:	70fa                	ld	ra,440(sp)
    80005140:	745a                	ld	s0,432(sp)
    80005142:	74ba                	ld	s1,424(sp)
    80005144:	791a                	ld	s2,416(sp)
    80005146:	69fa                	ld	s3,408(sp)
    80005148:	6a5a                	ld	s4,400(sp)
    8000514a:	6139                	addi	sp,sp,448
    8000514c:	8082                	ret

000000008000514e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000514e:	7139                	addi	sp,sp,-64
    80005150:	fc06                	sd	ra,56(sp)
    80005152:	f822                	sd	s0,48(sp)
    80005154:	f426                	sd	s1,40(sp)
    80005156:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	df2080e7          	jalr	-526(ra) # 80000f4a <myproc>
    80005160:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005162:	fd840593          	addi	a1,s0,-40
    80005166:	4501                	li	a0,0
    80005168:	ffffd097          	auipc	ra,0xffffd
    8000516c:	f1c080e7          	jalr	-228(ra) # 80002084 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005170:	fc840593          	addi	a1,s0,-56
    80005174:	fd040513          	addi	a0,s0,-48
    80005178:	fffff097          	auipc	ra,0xfffff
    8000517c:	de0080e7          	jalr	-544(ra) # 80003f58 <pipealloc>
    return -1;
    80005180:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005182:	0c054463          	bltz	a0,8000524a <sys_pipe+0xfc>
  fd0 = -1;
    80005186:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000518a:	fd043503          	ld	a0,-48(s0)
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	524080e7          	jalr	1316(ra) # 800046b2 <fdalloc>
    80005196:	fca42223          	sw	a0,-60(s0)
    8000519a:	08054b63          	bltz	a0,80005230 <sys_pipe+0xe2>
    8000519e:	fc843503          	ld	a0,-56(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	510080e7          	jalr	1296(ra) # 800046b2 <fdalloc>
    800051aa:	fca42023          	sw	a0,-64(s0)
    800051ae:	06054863          	bltz	a0,8000521e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b2:	4691                	li	a3,4
    800051b4:	fc440613          	addi	a2,s0,-60
    800051b8:	fd843583          	ld	a1,-40(s0)
    800051bc:	6ca8                	ld	a0,88(s1)
    800051be:	ffffc097          	auipc	ra,0xffffc
    800051c2:	a4c080e7          	jalr	-1460(ra) # 80000c0a <copyout>
    800051c6:	02054063          	bltz	a0,800051e6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051ca:	4691                	li	a3,4
    800051cc:	fc040613          	addi	a2,s0,-64
    800051d0:	fd843583          	ld	a1,-40(s0)
    800051d4:	0591                	addi	a1,a1,4
    800051d6:	6ca8                	ld	a0,88(s1)
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	a32080e7          	jalr	-1486(ra) # 80000c0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051e0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e2:	06055463          	bgez	a0,8000524a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051e6:	fc442783          	lw	a5,-60(s0)
    800051ea:	07e9                	addi	a5,a5,26
    800051ec:	078e                	slli	a5,a5,0x3
    800051ee:	97a6                	add	a5,a5,s1
    800051f0:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051f4:	fc042783          	lw	a5,-64(s0)
    800051f8:	07e9                	addi	a5,a5,26
    800051fa:	078e                	slli	a5,a5,0x3
    800051fc:	94be                	add	s1,s1,a5
    800051fe:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005202:	fd043503          	ld	a0,-48(s0)
    80005206:	fffff097          	auipc	ra,0xfffff
    8000520a:	a26080e7          	jalr	-1498(ra) # 80003c2c <fileclose>
    fileclose(wf);
    8000520e:	fc843503          	ld	a0,-56(s0)
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	a1a080e7          	jalr	-1510(ra) # 80003c2c <fileclose>
    return -1;
    8000521a:	57fd                	li	a5,-1
    8000521c:	a03d                	j	8000524a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000521e:	fc442783          	lw	a5,-60(s0)
    80005222:	0007c763          	bltz	a5,80005230 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005226:	07e9                	addi	a5,a5,26
    80005228:	078e                	slli	a5,a5,0x3
    8000522a:	97a6                	add	a5,a5,s1
    8000522c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005230:	fd043503          	ld	a0,-48(s0)
    80005234:	fffff097          	auipc	ra,0xfffff
    80005238:	9f8080e7          	jalr	-1544(ra) # 80003c2c <fileclose>
    fileclose(wf);
    8000523c:	fc843503          	ld	a0,-56(s0)
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	9ec080e7          	jalr	-1556(ra) # 80003c2c <fileclose>
    return -1;
    80005248:	57fd                	li	a5,-1
}
    8000524a:	853e                	mv	a0,a5
    8000524c:	70e2                	ld	ra,56(sp)
    8000524e:	7442                	ld	s0,48(sp)
    80005250:	74a2                	ld	s1,40(sp)
    80005252:	6121                	addi	sp,sp,64
    80005254:	8082                	ret
	...

0000000080005260 <kernelvec>:
    80005260:	7111                	addi	sp,sp,-256
    80005262:	e006                	sd	ra,0(sp)
    80005264:	e40a                	sd	sp,8(sp)
    80005266:	e80e                	sd	gp,16(sp)
    80005268:	ec12                	sd	tp,24(sp)
    8000526a:	f016                	sd	t0,32(sp)
    8000526c:	f41a                	sd	t1,40(sp)
    8000526e:	f81e                	sd	t2,48(sp)
    80005270:	fc22                	sd	s0,56(sp)
    80005272:	e0a6                	sd	s1,64(sp)
    80005274:	e4aa                	sd	a0,72(sp)
    80005276:	e8ae                	sd	a1,80(sp)
    80005278:	ecb2                	sd	a2,88(sp)
    8000527a:	f0b6                	sd	a3,96(sp)
    8000527c:	f4ba                	sd	a4,104(sp)
    8000527e:	f8be                	sd	a5,112(sp)
    80005280:	fcc2                	sd	a6,120(sp)
    80005282:	e146                	sd	a7,128(sp)
    80005284:	e54a                	sd	s2,136(sp)
    80005286:	e94e                	sd	s3,144(sp)
    80005288:	ed52                	sd	s4,152(sp)
    8000528a:	f156                	sd	s5,160(sp)
    8000528c:	f55a                	sd	s6,168(sp)
    8000528e:	f95e                	sd	s7,176(sp)
    80005290:	fd62                	sd	s8,184(sp)
    80005292:	e1e6                	sd	s9,192(sp)
    80005294:	e5ea                	sd	s10,200(sp)
    80005296:	e9ee                	sd	s11,208(sp)
    80005298:	edf2                	sd	t3,216(sp)
    8000529a:	f1f6                	sd	t4,224(sp)
    8000529c:	f5fa                	sd	t5,232(sp)
    8000529e:	f9fe                	sd	t6,240(sp)
    800052a0:	bf3fc0ef          	jal	ra,80001e92 <kerneltrap>
    800052a4:	6082                	ld	ra,0(sp)
    800052a6:	6122                	ld	sp,8(sp)
    800052a8:	61c2                	ld	gp,16(sp)
    800052aa:	7282                	ld	t0,32(sp)
    800052ac:	7322                	ld	t1,40(sp)
    800052ae:	73c2                	ld	t2,48(sp)
    800052b0:	7462                	ld	s0,56(sp)
    800052b2:	6486                	ld	s1,64(sp)
    800052b4:	6526                	ld	a0,72(sp)
    800052b6:	65c6                	ld	a1,80(sp)
    800052b8:	6666                	ld	a2,88(sp)
    800052ba:	7686                	ld	a3,96(sp)
    800052bc:	7726                	ld	a4,104(sp)
    800052be:	77c6                	ld	a5,112(sp)
    800052c0:	7866                	ld	a6,120(sp)
    800052c2:	688a                	ld	a7,128(sp)
    800052c4:	692a                	ld	s2,136(sp)
    800052c6:	69ca                	ld	s3,144(sp)
    800052c8:	6a6a                	ld	s4,152(sp)
    800052ca:	7a8a                	ld	s5,160(sp)
    800052cc:	7b2a                	ld	s6,168(sp)
    800052ce:	7bca                	ld	s7,176(sp)
    800052d0:	7c6a                	ld	s8,184(sp)
    800052d2:	6c8e                	ld	s9,192(sp)
    800052d4:	6d2e                	ld	s10,200(sp)
    800052d6:	6dce                	ld	s11,208(sp)
    800052d8:	6e6e                	ld	t3,216(sp)
    800052da:	7e8e                	ld	t4,224(sp)
    800052dc:	7f2e                	ld	t5,232(sp)
    800052de:	7fce                	ld	t6,240(sp)
    800052e0:	6111                	addi	sp,sp,256
    800052e2:	10200073          	sret
    800052e6:	00000013          	nop
    800052ea:	00000013          	nop
    800052ee:	0001                	nop

00000000800052f0 <timervec>:
    800052f0:	34051573          	csrrw	a0,mscratch,a0
    800052f4:	e10c                	sd	a1,0(a0)
    800052f6:	e510                	sd	a2,8(a0)
    800052f8:	e914                	sd	a3,16(a0)
    800052fa:	6d0c                	ld	a1,24(a0)
    800052fc:	7110                	ld	a2,32(a0)
    800052fe:	6194                	ld	a3,0(a1)
    80005300:	96b2                	add	a3,a3,a2
    80005302:	e194                	sd	a3,0(a1)
    80005304:	4589                	li	a1,2
    80005306:	14459073          	csrw	sip,a1
    8000530a:	6914                	ld	a3,16(a0)
    8000530c:	6510                	ld	a2,8(a0)
    8000530e:	610c                	ld	a1,0(a0)
    80005310:	34051573          	csrrw	a0,mscratch,a0
    80005314:	30200073          	mret
	...

000000008000531a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000531a:	1141                	addi	sp,sp,-16
    8000531c:	e422                	sd	s0,8(sp)
    8000531e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005320:	0c0007b7          	lui	a5,0xc000
    80005324:	4705                	li	a4,1
    80005326:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005328:	c3d8                	sw	a4,4(a5)
}
    8000532a:	6422                	ld	s0,8(sp)
    8000532c:	0141                	addi	sp,sp,16
    8000532e:	8082                	ret

0000000080005330 <plicinithart>:

void
plicinithart(void)
{
    80005330:	1141                	addi	sp,sp,-16
    80005332:	e406                	sd	ra,8(sp)
    80005334:	e022                	sd	s0,0(sp)
    80005336:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	be6080e7          	jalr	-1050(ra) # 80000f1e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005340:	0085171b          	slliw	a4,a0,0x8
    80005344:	0c0027b7          	lui	a5,0xc002
    80005348:	97ba                	add	a5,a5,a4
    8000534a:	40200713          	li	a4,1026
    8000534e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005352:	00d5151b          	slliw	a0,a0,0xd
    80005356:	0c2017b7          	lui	a5,0xc201
    8000535a:	97aa                	add	a5,a5,a0
    8000535c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005360:	60a2                	ld	ra,8(sp)
    80005362:	6402                	ld	s0,0(sp)
    80005364:	0141                	addi	sp,sp,16
    80005366:	8082                	ret

0000000080005368 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005368:	1141                	addi	sp,sp,-16
    8000536a:	e406                	sd	ra,8(sp)
    8000536c:	e022                	sd	s0,0(sp)
    8000536e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005370:	ffffc097          	auipc	ra,0xffffc
    80005374:	bae080e7          	jalr	-1106(ra) # 80000f1e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005378:	00d5151b          	slliw	a0,a0,0xd
    8000537c:	0c2017b7          	lui	a5,0xc201
    80005380:	97aa                	add	a5,a5,a0
  return irq;
}
    80005382:	43c8                	lw	a0,4(a5)
    80005384:	60a2                	ld	ra,8(sp)
    80005386:	6402                	ld	s0,0(sp)
    80005388:	0141                	addi	sp,sp,16
    8000538a:	8082                	ret

000000008000538c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000538c:	1101                	addi	sp,sp,-32
    8000538e:	ec06                	sd	ra,24(sp)
    80005390:	e822                	sd	s0,16(sp)
    80005392:	e426                	sd	s1,8(sp)
    80005394:	1000                	addi	s0,sp,32
    80005396:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	b86080e7          	jalr	-1146(ra) # 80000f1e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053a0:	00d5151b          	slliw	a0,a0,0xd
    800053a4:	0c2017b7          	lui	a5,0xc201
    800053a8:	97aa                	add	a5,a5,a0
    800053aa:	c3c4                	sw	s1,4(a5)
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6105                	addi	sp,sp,32
    800053b4:	8082                	ret

00000000800053b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053b6:	1141                	addi	sp,sp,-16
    800053b8:	e406                	sd	ra,8(sp)
    800053ba:	e022                	sd	s0,0(sp)
    800053bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053be:	479d                	li	a5,7
    800053c0:	04a7cc63          	blt	a5,a0,80005418 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053c4:	00018797          	auipc	a5,0x18
    800053c8:	41478793          	addi	a5,a5,1044 # 8001d7d8 <disk>
    800053cc:	97aa                	add	a5,a5,a0
    800053ce:	0187c783          	lbu	a5,24(a5)
    800053d2:	ebb9                	bnez	a5,80005428 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053d4:	00451693          	slli	a3,a0,0x4
    800053d8:	00018797          	auipc	a5,0x18
    800053dc:	40078793          	addi	a5,a5,1024 # 8001d7d8 <disk>
    800053e0:	6398                	ld	a4,0(a5)
    800053e2:	9736                	add	a4,a4,a3
    800053e4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053e8:	6398                	ld	a4,0(a5)
    800053ea:	9736                	add	a4,a4,a3
    800053ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053f8:	97aa                	add	a5,a5,a0
    800053fa:	4705                	li	a4,1
    800053fc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005400:	00018517          	auipc	a0,0x18
    80005404:	3f050513          	addi	a0,a0,1008 # 8001d7f0 <disk+0x18>
    80005408:	ffffc097          	auipc	ra,0xffffc
    8000540c:	24e080e7          	jalr	590(ra) # 80001656 <wakeup>
}
    80005410:	60a2                	ld	ra,8(sp)
    80005412:	6402                	ld	s0,0(sp)
    80005414:	0141                	addi	sp,sp,16
    80005416:	8082                	ret
    panic("free_desc 1");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	2a850513          	addi	a0,a0,680 # 800086c0 <syscalls+0x2f0>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	d42080e7          	jalr	-702(ra) # 80006162 <panic>
    panic("free_desc 2");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	2a850513          	addi	a0,a0,680 # 800086d0 <syscalls+0x300>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	d32080e7          	jalr	-718(ra) # 80006162 <panic>

0000000080005438 <virtio_disk_init>:
{
    80005438:	1101                	addi	sp,sp,-32
    8000543a:	ec06                	sd	ra,24(sp)
    8000543c:	e822                	sd	s0,16(sp)
    8000543e:	e426                	sd	s1,8(sp)
    80005440:	e04a                	sd	s2,0(sp)
    80005442:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005444:	00003597          	auipc	a1,0x3
    80005448:	29c58593          	addi	a1,a1,668 # 800086e0 <syscalls+0x310>
    8000544c:	00018517          	auipc	a0,0x18
    80005450:	4b450513          	addi	a0,a0,1204 # 8001d900 <disk+0x128>
    80005454:	00001097          	auipc	ra,0x1
    80005458:	3ac080e7          	jalr	940(ra) # 80006800 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000545c:	100017b7          	lui	a5,0x10001
    80005460:	4398                	lw	a4,0(a5)
    80005462:	2701                	sext.w	a4,a4
    80005464:	747277b7          	lui	a5,0x74727
    80005468:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000546c:	14f71b63          	bne	a4,a5,800055c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005470:	100017b7          	lui	a5,0x10001
    80005474:	43dc                	lw	a5,4(a5)
    80005476:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005478:	4709                	li	a4,2
    8000547a:	14e79463          	bne	a5,a4,800055c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000547e:	100017b7          	lui	a5,0x10001
    80005482:	479c                	lw	a5,8(a5)
    80005484:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005486:	12e79e63          	bne	a5,a4,800055c2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000548a:	100017b7          	lui	a5,0x10001
    8000548e:	47d8                	lw	a4,12(a5)
    80005490:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005492:	554d47b7          	lui	a5,0x554d4
    80005496:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000549a:	12f71463          	bne	a4,a5,800055c2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549e:	100017b7          	lui	a5,0x10001
    800054a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a6:	4705                	li	a4,1
    800054a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054aa:	470d                	li	a4,3
    800054ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054ae:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800054b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6bf7>
    800054b8:	8f75                	and	a4,a4,a3
    800054ba:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054bc:	472d                	li	a4,11
    800054be:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054c0:	5bbc                	lw	a5,112(a5)
    800054c2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054c6:	8ba1                	andi	a5,a5,8
    800054c8:	10078563          	beqz	a5,800055d2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054cc:	100017b7          	lui	a5,0x10001
    800054d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054d4:	43fc                	lw	a5,68(a5)
    800054d6:	2781                	sext.w	a5,a5
    800054d8:	10079563          	bnez	a5,800055e2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054dc:	100017b7          	lui	a5,0x10001
    800054e0:	5bdc                	lw	a5,52(a5)
    800054e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054e4:	10078763          	beqz	a5,800055f2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800054e8:	471d                	li	a4,7
    800054ea:	10f77c63          	bgeu	a4,a5,80005602 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800054ee:	ffffb097          	auipc	ra,0xffffb
    800054f2:	c7c080e7          	jalr	-900(ra) # 8000016a <kalloc>
    800054f6:	00018497          	auipc	s1,0x18
    800054fa:	2e248493          	addi	s1,s1,738 # 8001d7d8 <disk>
    800054fe:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005500:	ffffb097          	auipc	ra,0xffffb
    80005504:	c6a080e7          	jalr	-918(ra) # 8000016a <kalloc>
    80005508:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000550a:	ffffb097          	auipc	ra,0xffffb
    8000550e:	c60080e7          	jalr	-928(ra) # 8000016a <kalloc>
    80005512:	87aa                	mv	a5,a0
    80005514:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005516:	6088                	ld	a0,0(s1)
    80005518:	cd6d                	beqz	a0,80005612 <virtio_disk_init+0x1da>
    8000551a:	00018717          	auipc	a4,0x18
    8000551e:	2c673703          	ld	a4,710(a4) # 8001d7e0 <disk+0x8>
    80005522:	cb65                	beqz	a4,80005612 <virtio_disk_init+0x1da>
    80005524:	c7fd                	beqz	a5,80005612 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005526:	6605                	lui	a2,0x1
    80005528:	4581                	li	a1,0
    8000552a:	ffffb097          	auipc	ra,0xffffb
    8000552e:	d38080e7          	jalr	-712(ra) # 80000262 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005532:	00018497          	auipc	s1,0x18
    80005536:	2a648493          	addi	s1,s1,678 # 8001d7d8 <disk>
    8000553a:	6605                	lui	a2,0x1
    8000553c:	4581                	li	a1,0
    8000553e:	6488                	ld	a0,8(s1)
    80005540:	ffffb097          	auipc	ra,0xffffb
    80005544:	d22080e7          	jalr	-734(ra) # 80000262 <memset>
  memset(disk.used, 0, PGSIZE);
    80005548:	6605                	lui	a2,0x1
    8000554a:	4581                	li	a1,0
    8000554c:	6888                	ld	a0,16(s1)
    8000554e:	ffffb097          	auipc	ra,0xffffb
    80005552:	d14080e7          	jalr	-748(ra) # 80000262 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005556:	100017b7          	lui	a5,0x10001
    8000555a:	4721                	li	a4,8
    8000555c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000555e:	4098                	lw	a4,0(s1)
    80005560:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005564:	40d8                	lw	a4,4(s1)
    80005566:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000556a:	6498                	ld	a4,8(s1)
    8000556c:	0007069b          	sext.w	a3,a4
    80005570:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005574:	9701                	srai	a4,a4,0x20
    80005576:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000557a:	6898                	ld	a4,16(s1)
    8000557c:	0007069b          	sext.w	a3,a4
    80005580:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005584:	9701                	srai	a4,a4,0x20
    80005586:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000558a:	4705                	li	a4,1
    8000558c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000558e:	00e48c23          	sb	a4,24(s1)
    80005592:	00e48ca3          	sb	a4,25(s1)
    80005596:	00e48d23          	sb	a4,26(s1)
    8000559a:	00e48da3          	sb	a4,27(s1)
    8000559e:	00e48e23          	sb	a4,28(s1)
    800055a2:	00e48ea3          	sb	a4,29(s1)
    800055a6:	00e48f23          	sb	a4,30(s1)
    800055aa:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055ae:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b2:	0727a823          	sw	s2,112(a5)
}
    800055b6:	60e2                	ld	ra,24(sp)
    800055b8:	6442                	ld	s0,16(sp)
    800055ba:	64a2                	ld	s1,8(sp)
    800055bc:	6902                	ld	s2,0(sp)
    800055be:	6105                	addi	sp,sp,32
    800055c0:	8082                	ret
    panic("could not find virtio disk");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	12e50513          	addi	a0,a0,302 # 800086f0 <syscalls+0x320>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	b98080e7          	jalr	-1128(ra) # 80006162 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	13e50513          	addi	a0,a0,318 # 80008710 <syscalls+0x340>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	b88080e7          	jalr	-1144(ra) # 80006162 <panic>
    panic("virtio disk should not be ready");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	14e50513          	addi	a0,a0,334 # 80008730 <syscalls+0x360>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	b78080e7          	jalr	-1160(ra) # 80006162 <panic>
    panic("virtio disk has no queue 0");
    800055f2:	00003517          	auipc	a0,0x3
    800055f6:	15e50513          	addi	a0,a0,350 # 80008750 <syscalls+0x380>
    800055fa:	00001097          	auipc	ra,0x1
    800055fe:	b68080e7          	jalr	-1176(ra) # 80006162 <panic>
    panic("virtio disk max queue too short");
    80005602:	00003517          	auipc	a0,0x3
    80005606:	16e50513          	addi	a0,a0,366 # 80008770 <syscalls+0x3a0>
    8000560a:	00001097          	auipc	ra,0x1
    8000560e:	b58080e7          	jalr	-1192(ra) # 80006162 <panic>
    panic("virtio disk kalloc");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	17e50513          	addi	a0,a0,382 # 80008790 <syscalls+0x3c0>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	b48080e7          	jalr	-1208(ra) # 80006162 <panic>

0000000080005622 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005622:	7159                	addi	sp,sp,-112
    80005624:	f486                	sd	ra,104(sp)
    80005626:	f0a2                	sd	s0,96(sp)
    80005628:	eca6                	sd	s1,88(sp)
    8000562a:	e8ca                	sd	s2,80(sp)
    8000562c:	e4ce                	sd	s3,72(sp)
    8000562e:	e0d2                	sd	s4,64(sp)
    80005630:	fc56                	sd	s5,56(sp)
    80005632:	f85a                	sd	s6,48(sp)
    80005634:	f45e                	sd	s7,40(sp)
    80005636:	f062                	sd	s8,32(sp)
    80005638:	ec66                	sd	s9,24(sp)
    8000563a:	e86a                	sd	s10,16(sp)
    8000563c:	1880                	addi	s0,sp,112
    8000563e:	8a2a                	mv	s4,a0
    80005640:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005642:	00c52c83          	lw	s9,12(a0)
    80005646:	001c9c9b          	slliw	s9,s9,0x1
    8000564a:	1c82                	slli	s9,s9,0x20
    8000564c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005650:	00018517          	auipc	a0,0x18
    80005654:	2b050513          	addi	a0,a0,688 # 8001d900 <disk+0x128>
    80005658:	00001097          	auipc	ra,0x1
    8000565c:	02c080e7          	jalr	44(ra) # 80006684 <acquire>
  for(int i = 0; i < 3; i++){
    80005660:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80005662:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005664:	00018b17          	auipc	s6,0x18
    80005668:	174b0b13          	addi	s6,s6,372 # 8001d7d8 <disk>
  for(int i = 0; i < 3; i++){
    8000566c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000566e:	00018c17          	auipc	s8,0x18
    80005672:	292c0c13          	addi	s8,s8,658 # 8001d900 <disk+0x128>
    80005676:	a095                	j	800056da <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005678:	00fb0733          	add	a4,s6,a5
    8000567c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005680:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    80005682:	0207c563          	bltz	a5,800056ac <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    80005686:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80005688:	0591                	addi	a1,a1,4
    8000568a:	05560d63          	beq	a2,s5,800056e4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    8000568e:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    80005690:	00018717          	auipc	a4,0x18
    80005694:	14870713          	addi	a4,a4,328 # 8001d7d8 <disk>
    80005698:	87ca                	mv	a5,s2
    if(disk.free[i]){
    8000569a:	01874683          	lbu	a3,24(a4)
    8000569e:	fee9                	bnez	a3,80005678 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800056a0:	2785                	addiw	a5,a5,1
    800056a2:	0705                	addi	a4,a4,1
    800056a4:	fe979be3          	bne	a5,s1,8000569a <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800056a8:	57fd                	li	a5,-1
    800056aa:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800056ac:	00c05e63          	blez	a2,800056c8 <virtio_disk_rw+0xa6>
    800056b0:	060a                	slli	a2,a2,0x2
    800056b2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800056b6:	0009a503          	lw	a0,0(s3)
    800056ba:	00000097          	auipc	ra,0x0
    800056be:	cfc080e7          	jalr	-772(ra) # 800053b6 <free_desc>
      for(int j = 0; j < i; j++)
    800056c2:	0991                	addi	s3,s3,4
    800056c4:	ffa999e3          	bne	s3,s10,800056b6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c8:	85e2                	mv	a1,s8
    800056ca:	00018517          	auipc	a0,0x18
    800056ce:	12650513          	addi	a0,a0,294 # 8001d7f0 <disk+0x18>
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	f20080e7          	jalr	-224(ra) # 800015f2 <sleep>
  for(int i = 0; i < 3; i++){
    800056da:	f9040993          	addi	s3,s0,-112
{
    800056de:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    800056e0:	864a                	mv	a2,s2
    800056e2:	b775                	j	8000568e <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e4:	f9042503          	lw	a0,-112(s0)
    800056e8:	00a50713          	addi	a4,a0,10
    800056ec:	0712                	slli	a4,a4,0x4

  if(write)
    800056ee:	00018797          	auipc	a5,0x18
    800056f2:	0ea78793          	addi	a5,a5,234 # 8001d7d8 <disk>
    800056f6:	00e786b3          	add	a3,a5,a4
    800056fa:	01703633          	snez	a2,s7
    800056fe:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005700:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005704:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005708:	f6070613          	addi	a2,a4,-160
    8000570c:	6394                	ld	a3,0(a5)
    8000570e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005710:	00870593          	addi	a1,a4,8
    80005714:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005716:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005718:	0007b803          	ld	a6,0(a5)
    8000571c:	9642                	add	a2,a2,a6
    8000571e:	46c1                	li	a3,16
    80005720:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005722:	4585                	li	a1,1
    80005724:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005728:	f9442683          	lw	a3,-108(s0)
    8000572c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005730:	0692                	slli	a3,a3,0x4
    80005732:	9836                	add	a6,a6,a3
    80005734:	060a0613          	addi	a2,s4,96
    80005738:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000573c:	0007b803          	ld	a6,0(a5)
    80005740:	96c2                	add	a3,a3,a6
    80005742:	40000613          	li	a2,1024
    80005746:	c690                	sw	a2,8(a3)
  if(write)
    80005748:	001bb613          	seqz	a2,s7
    8000574c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005750:	00166613          	ori	a2,a2,1
    80005754:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005758:	f9842603          	lw	a2,-104(s0)
    8000575c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005760:	00250693          	addi	a3,a0,2
    80005764:	0692                	slli	a3,a3,0x4
    80005766:	96be                	add	a3,a3,a5
    80005768:	58fd                	li	a7,-1
    8000576a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000576e:	0612                	slli	a2,a2,0x4
    80005770:	9832                	add	a6,a6,a2
    80005772:	f9070713          	addi	a4,a4,-112
    80005776:	973e                	add	a4,a4,a5
    80005778:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000577c:	6398                	ld	a4,0(a5)
    8000577e:	9732                	add	a4,a4,a2
    80005780:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005782:	4609                	li	a2,2
    80005784:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005788:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000578c:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    80005790:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005794:	6794                	ld	a3,8(a5)
    80005796:	0026d703          	lhu	a4,2(a3)
    8000579a:	8b1d                	andi	a4,a4,7
    8000579c:	0706                	slli	a4,a4,0x1
    8000579e:	96ba                	add	a3,a3,a4
    800057a0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057a4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057a8:	6798                	ld	a4,8(a5)
    800057aa:	00275783          	lhu	a5,2(a4)
    800057ae:	2785                	addiw	a5,a5,1
    800057b0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057b4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057b8:	100017b7          	lui	a5,0x10001
    800057bc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057c0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057c4:	00018917          	auipc	s2,0x18
    800057c8:	13c90913          	addi	s2,s2,316 # 8001d900 <disk+0x128>
  while(b->disk == 1) {
    800057cc:	4485                	li	s1,1
    800057ce:	00b79c63          	bne	a5,a1,800057e6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057d2:	85ca                	mv	a1,s2
    800057d4:	8552                	mv	a0,s4
    800057d6:	ffffc097          	auipc	ra,0xffffc
    800057da:	e1c080e7          	jalr	-484(ra) # 800015f2 <sleep>
  while(b->disk == 1) {
    800057de:	004a2783          	lw	a5,4(s4)
    800057e2:	fe9788e3          	beq	a5,s1,800057d2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057e6:	f9042903          	lw	s2,-112(s0)
    800057ea:	00290713          	addi	a4,s2,2
    800057ee:	0712                	slli	a4,a4,0x4
    800057f0:	00018797          	auipc	a5,0x18
    800057f4:	fe878793          	addi	a5,a5,-24 # 8001d7d8 <disk>
    800057f8:	97ba                	add	a5,a5,a4
    800057fa:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057fe:	00018997          	auipc	s3,0x18
    80005802:	fda98993          	addi	s3,s3,-38 # 8001d7d8 <disk>
    80005806:	00491713          	slli	a4,s2,0x4
    8000580a:	0009b783          	ld	a5,0(s3)
    8000580e:	97ba                	add	a5,a5,a4
    80005810:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005814:	854a                	mv	a0,s2
    80005816:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000581a:	00000097          	auipc	ra,0x0
    8000581e:	b9c080e7          	jalr	-1124(ra) # 800053b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005822:	8885                	andi	s1,s1,1
    80005824:	f0ed                	bnez	s1,80005806 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005826:	00018517          	auipc	a0,0x18
    8000582a:	0da50513          	addi	a0,a0,218 # 8001d900 <disk+0x128>
    8000582e:	00001097          	auipc	ra,0x1
    80005832:	f26080e7          	jalr	-218(ra) # 80006754 <release>
}
    80005836:	70a6                	ld	ra,104(sp)
    80005838:	7406                	ld	s0,96(sp)
    8000583a:	64e6                	ld	s1,88(sp)
    8000583c:	6946                	ld	s2,80(sp)
    8000583e:	69a6                	ld	s3,72(sp)
    80005840:	6a06                	ld	s4,64(sp)
    80005842:	7ae2                	ld	s5,56(sp)
    80005844:	7b42                	ld	s6,48(sp)
    80005846:	7ba2                	ld	s7,40(sp)
    80005848:	7c02                	ld	s8,32(sp)
    8000584a:	6ce2                	ld	s9,24(sp)
    8000584c:	6d42                	ld	s10,16(sp)
    8000584e:	6165                	addi	sp,sp,112
    80005850:	8082                	ret

0000000080005852 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005852:	1101                	addi	sp,sp,-32
    80005854:	ec06                	sd	ra,24(sp)
    80005856:	e822                	sd	s0,16(sp)
    80005858:	e426                	sd	s1,8(sp)
    8000585a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000585c:	00018497          	auipc	s1,0x18
    80005860:	f7c48493          	addi	s1,s1,-132 # 8001d7d8 <disk>
    80005864:	00018517          	auipc	a0,0x18
    80005868:	09c50513          	addi	a0,a0,156 # 8001d900 <disk+0x128>
    8000586c:	00001097          	auipc	ra,0x1
    80005870:	e18080e7          	jalr	-488(ra) # 80006684 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005874:	10001737          	lui	a4,0x10001
    80005878:	533c                	lw	a5,96(a4)
    8000587a:	8b8d                	andi	a5,a5,3
    8000587c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000587e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005882:	689c                	ld	a5,16(s1)
    80005884:	0204d703          	lhu	a4,32(s1)
    80005888:	0027d783          	lhu	a5,2(a5)
    8000588c:	04f70863          	beq	a4,a5,800058dc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005890:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005894:	6898                	ld	a4,16(s1)
    80005896:	0204d783          	lhu	a5,32(s1)
    8000589a:	8b9d                	andi	a5,a5,7
    8000589c:	078e                	slli	a5,a5,0x3
    8000589e:	97ba                	add	a5,a5,a4
    800058a0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058a2:	00278713          	addi	a4,a5,2
    800058a6:	0712                	slli	a4,a4,0x4
    800058a8:	9726                	add	a4,a4,s1
    800058aa:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058ae:	e721                	bnez	a4,800058f6 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058b0:	0789                	addi	a5,a5,2
    800058b2:	0792                	slli	a5,a5,0x4
    800058b4:	97a6                	add	a5,a5,s1
    800058b6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058b8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058bc:	ffffc097          	auipc	ra,0xffffc
    800058c0:	d9a080e7          	jalr	-614(ra) # 80001656 <wakeup>

    disk.used_idx += 1;
    800058c4:	0204d783          	lhu	a5,32(s1)
    800058c8:	2785                	addiw	a5,a5,1
    800058ca:	17c2                	slli	a5,a5,0x30
    800058cc:	93c1                	srli	a5,a5,0x30
    800058ce:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058d2:	6898                	ld	a4,16(s1)
    800058d4:	00275703          	lhu	a4,2(a4)
    800058d8:	faf71ce3          	bne	a4,a5,80005890 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058dc:	00018517          	auipc	a0,0x18
    800058e0:	02450513          	addi	a0,a0,36 # 8001d900 <disk+0x128>
    800058e4:	00001097          	auipc	ra,0x1
    800058e8:	e70080e7          	jalr	-400(ra) # 80006754 <release>
}
    800058ec:	60e2                	ld	ra,24(sp)
    800058ee:	6442                	ld	s0,16(sp)
    800058f0:	64a2                	ld	s1,8(sp)
    800058f2:	6105                	addi	sp,sp,32
    800058f4:	8082                	ret
      panic("virtio_disk_intr status");
    800058f6:	00003517          	auipc	a0,0x3
    800058fa:	eb250513          	addi	a0,a0,-334 # 800087a8 <syscalls+0x3d8>
    800058fe:	00001097          	auipc	ra,0x1
    80005902:	864080e7          	jalr	-1948(ra) # 80006162 <panic>

0000000080005906 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005906:	1141                	addi	sp,sp,-16
    80005908:	e422                	sd	s0,8(sp)
    8000590a:	0800                	addi	s0,sp,16
  return -1;
}
    8000590c:	557d                	li	a0,-1
    8000590e:	6422                	ld	s0,8(sp)
    80005910:	0141                	addi	sp,sp,16
    80005912:	8082                	ret

0000000080005914 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005914:	7179                	addi	sp,sp,-48
    80005916:	f406                	sd	ra,40(sp)
    80005918:	f022                	sd	s0,32(sp)
    8000591a:	ec26                	sd	s1,24(sp)
    8000591c:	e84a                	sd	s2,16(sp)
    8000591e:	e44e                	sd	s3,8(sp)
    80005920:	e052                	sd	s4,0(sp)
    80005922:	1800                	addi	s0,sp,48
    80005924:	892a                	mv	s2,a0
    80005926:	89ae                	mv	s3,a1
    80005928:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000592a:	00018517          	auipc	a0,0x18
    8000592e:	ff650513          	addi	a0,a0,-10 # 8001d920 <stats>
    80005932:	00001097          	auipc	ra,0x1
    80005936:	d52080e7          	jalr	-686(ra) # 80006684 <acquire>

  if(stats.sz == 0) {
    8000593a:	00019797          	auipc	a5,0x19
    8000593e:	0067a783          	lw	a5,6(a5) # 8001e940 <stats+0x1020>
    80005942:	cbb5                	beqz	a5,800059b6 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005944:	00019797          	auipc	a5,0x19
    80005948:	fdc78793          	addi	a5,a5,-36 # 8001e920 <stats+0x1000>
    8000594c:	53d8                	lw	a4,36(a5)
    8000594e:	539c                	lw	a5,32(a5)
    80005950:	9f99                	subw	a5,a5,a4
    80005952:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005956:	06d05e63          	blez	a3,800059d2 <statsread+0xbe>
    if(m > n)
    8000595a:	8a3e                	mv	s4,a5
    8000595c:	00d4d363          	bge	s1,a3,80005962 <statsread+0x4e>
    80005960:	8a26                	mv	s4,s1
    80005962:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005966:	86a6                	mv	a3,s1
    80005968:	00018617          	auipc	a2,0x18
    8000596c:	fd860613          	addi	a2,a2,-40 # 8001d940 <stats+0x20>
    80005970:	963a                	add	a2,a2,a4
    80005972:	85ce                	mv	a1,s3
    80005974:	854a                	mv	a0,s2
    80005976:	ffffc097          	auipc	ra,0xffffc
    8000597a:	084080e7          	jalr	132(ra) # 800019fa <either_copyout>
    8000597e:	57fd                	li	a5,-1
    80005980:	00f50a63          	beq	a0,a5,80005994 <statsread+0x80>
      stats.off += m;
    80005984:	00019717          	auipc	a4,0x19
    80005988:	f9c70713          	addi	a4,a4,-100 # 8001e920 <stats+0x1000>
    8000598c:	535c                	lw	a5,36(a4)
    8000598e:	00fa07bb          	addw	a5,s4,a5
    80005992:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005994:	00018517          	auipc	a0,0x18
    80005998:	f8c50513          	addi	a0,a0,-116 # 8001d920 <stats>
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	db8080e7          	jalr	-584(ra) # 80006754 <release>
  return m;
}
    800059a4:	8526                	mv	a0,s1
    800059a6:	70a2                	ld	ra,40(sp)
    800059a8:	7402                	ld	s0,32(sp)
    800059aa:	64e2                	ld	s1,24(sp)
    800059ac:	6942                	ld	s2,16(sp)
    800059ae:	69a2                	ld	s3,8(sp)
    800059b0:	6a02                	ld	s4,0(sp)
    800059b2:	6145                	addi	sp,sp,48
    800059b4:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    800059b6:	6585                	lui	a1,0x1
    800059b8:	00018517          	auipc	a0,0x18
    800059bc:	f8850513          	addi	a0,a0,-120 # 8001d940 <stats+0x20>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	f04080e7          	jalr	-252(ra) # 800068c4 <statslock>
    800059c8:	00019797          	auipc	a5,0x19
    800059cc:	f6a7ac23          	sw	a0,-136(a5) # 8001e940 <stats+0x1020>
    800059d0:	bf95                	j	80005944 <statsread+0x30>
    stats.sz = 0;
    800059d2:	00019797          	auipc	a5,0x19
    800059d6:	f4e78793          	addi	a5,a5,-178 # 8001e920 <stats+0x1000>
    800059da:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    800059de:	0207a223          	sw	zero,36(a5)
    m = -1;
    800059e2:	54fd                	li	s1,-1
    800059e4:	bf45                	j	80005994 <statsread+0x80>

00000000800059e6 <statsinit>:

void
statsinit(void)
{
    800059e6:	1141                	addi	sp,sp,-16
    800059e8:	e406                	sd	ra,8(sp)
    800059ea:	e022                	sd	s0,0(sp)
    800059ec:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    800059ee:	00003597          	auipc	a1,0x3
    800059f2:	dd258593          	addi	a1,a1,-558 # 800087c0 <syscalls+0x3f0>
    800059f6:	00018517          	auipc	a0,0x18
    800059fa:	f2a50513          	addi	a0,a0,-214 # 8001d920 <stats>
    800059fe:	00001097          	auipc	ra,0x1
    80005a02:	e02080e7          	jalr	-510(ra) # 80006800 <initlock>

  devsw[STATS].read = statsread;
    80005a06:	00017797          	auipc	a5,0x17
    80005a0a:	d7278793          	addi	a5,a5,-654 # 8001c778 <devsw>
    80005a0e:	00000717          	auipc	a4,0x0
    80005a12:	f0670713          	addi	a4,a4,-250 # 80005914 <statsread>
    80005a16:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005a18:	00000717          	auipc	a4,0x0
    80005a1c:	eee70713          	addi	a4,a4,-274 # 80005906 <statswrite>
    80005a20:	f798                	sd	a4,40(a5)
}
    80005a22:	60a2                	ld	ra,8(sp)
    80005a24:	6402                	ld	s0,0(sp)
    80005a26:	0141                	addi	sp,sp,16
    80005a28:	8082                	ret

0000000080005a2a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a2a:	1101                	addi	sp,sp,-32
    80005a2c:	ec22                	sd	s0,24(sp)
    80005a2e:	1000                	addi	s0,sp,32
    80005a30:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a32:	c299                	beqz	a3,80005a38 <sprintint+0xe>
    80005a34:	0805c263          	bltz	a1,80005ab8 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005a38:	2581                	sext.w	a1,a1
    80005a3a:	4301                	li	t1,0

  i = 0;
    80005a3c:	fe040713          	addi	a4,s0,-32
    80005a40:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005a42:	2601                	sext.w	a2,a2
    80005a44:	00003697          	auipc	a3,0x3
    80005a48:	d9c68693          	addi	a3,a3,-612 # 800087e0 <digits>
    80005a4c:	88aa                	mv	a7,a0
    80005a4e:	2505                	addiw	a0,a0,1
    80005a50:	02c5f7bb          	remuw	a5,a1,a2
    80005a54:	1782                	slli	a5,a5,0x20
    80005a56:	9381                	srli	a5,a5,0x20
    80005a58:	97b6                	add	a5,a5,a3
    80005a5a:	0007c783          	lbu	a5,0(a5)
    80005a5e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a62:	0005879b          	sext.w	a5,a1
    80005a66:	02c5d5bb          	divuw	a1,a1,a2
    80005a6a:	0705                	addi	a4,a4,1
    80005a6c:	fec7f0e3          	bgeu	a5,a2,80005a4c <sprintint+0x22>

  if(sign)
    80005a70:	00030b63          	beqz	t1,80005a86 <sprintint+0x5c>
    buf[i++] = '-';
    80005a74:	ff050793          	addi	a5,a0,-16
    80005a78:	97a2                	add	a5,a5,s0
    80005a7a:	02d00713          	li	a4,45
    80005a7e:	fee78823          	sb	a4,-16(a5)
    80005a82:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005a86:	02a05d63          	blez	a0,80005ac0 <sprintint+0x96>
    80005a8a:	fe040793          	addi	a5,s0,-32
    80005a8e:	00a78733          	add	a4,a5,a0
    80005a92:	87c2                	mv	a5,a6
    80005a94:	00180613          	addi	a2,a6,1
    80005a98:	fff5069b          	addiw	a3,a0,-1
    80005a9c:	1682                	slli	a3,a3,0x20
    80005a9e:	9281                	srli	a3,a3,0x20
    80005aa0:	9636                	add	a2,a2,a3
  *s = c;
    80005aa2:	fff74683          	lbu	a3,-1(a4)
    80005aa6:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005aaa:	177d                	addi	a4,a4,-1
    80005aac:	0785                	addi	a5,a5,1
    80005aae:	fec79ae3          	bne	a5,a2,80005aa2 <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005ab2:	6462                	ld	s0,24(sp)
    80005ab4:	6105                	addi	sp,sp,32
    80005ab6:	8082                	ret
    x = -xx;
    80005ab8:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005abc:	4305                	li	t1,1
    x = -xx;
    80005abe:	bfbd                	j	80005a3c <sprintint+0x12>
  while(--i >= 0)
    80005ac0:	4501                	li	a0,0
    80005ac2:	bfc5                	j	80005ab2 <sprintint+0x88>

0000000080005ac4 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005ac4:	7135                	addi	sp,sp,-160
    80005ac6:	f486                	sd	ra,104(sp)
    80005ac8:	f0a2                	sd	s0,96(sp)
    80005aca:	eca6                	sd	s1,88(sp)
    80005acc:	e8ca                	sd	s2,80(sp)
    80005ace:	e4ce                	sd	s3,72(sp)
    80005ad0:	e0d2                	sd	s4,64(sp)
    80005ad2:	fc56                	sd	s5,56(sp)
    80005ad4:	f85a                	sd	s6,48(sp)
    80005ad6:	f45e                	sd	s7,40(sp)
    80005ad8:	f062                	sd	s8,32(sp)
    80005ada:	ec66                	sd	s9,24(sp)
    80005adc:	1880                	addi	s0,sp,112
    80005ade:	e414                	sd	a3,8(s0)
    80005ae0:	e818                	sd	a4,16(s0)
    80005ae2:	ec1c                	sd	a5,24(s0)
    80005ae4:	03043023          	sd	a6,32(s0)
    80005ae8:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005aec:	c60d                	beqz	a2,80005b16 <snprintf+0x52>
    80005aee:	8baa                	mv	s7,a0
    80005af0:	8aae                	mv	s5,a1
    80005af2:	89b2                	mv	s3,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005af4:	00840793          	addi	a5,s0,8
    80005af8:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005afc:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005afe:	4901                	li	s2,0
    80005b00:	02b05363          	blez	a1,80005b26 <snprintf+0x62>
    if(c != '%'){
    80005b04:	02500a13          	li	s4,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005b08:	07300b13          	li	s6,115
    80005b0c:	07800c93          	li	s9,120
    80005b10:	06400c13          	li	s8,100
    80005b14:	a01d                	j	80005b3a <snprintf+0x76>
    panic("null fmt");
    80005b16:	00003517          	auipc	a0,0x3
    80005b1a:	cba50513          	addi	a0,a0,-838 # 800087d0 <syscalls+0x400>
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	644080e7          	jalr	1604(ra) # 80006162 <panic>
  int off = 0;
    80005b26:	4481                	li	s1,0
    80005b28:	a0f9                	j	80005bf6 <snprintf+0x132>
  *s = c;
    80005b2a:	009b8733          	add	a4,s7,s1
    80005b2e:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b32:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b34:	2905                	addiw	s2,s2,1
    80005b36:	0d54d063          	bge	s1,s5,80005bf6 <snprintf+0x132>
    80005b3a:	012987b3          	add	a5,s3,s2
    80005b3e:	0007c783          	lbu	a5,0(a5)
    80005b42:	0007871b          	sext.w	a4,a5
    80005b46:	cbc5                	beqz	a5,80005bf6 <snprintf+0x132>
    if(c != '%'){
    80005b48:	ff4711e3          	bne	a4,s4,80005b2a <snprintf+0x66>
    c = fmt[++i] & 0xff;
    80005b4c:	2905                	addiw	s2,s2,1
    80005b4e:	012987b3          	add	a5,s3,s2
    80005b52:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005b56:	c3c5                	beqz	a5,80005bf6 <snprintf+0x132>
    switch(c){
    80005b58:	05678c63          	beq	a5,s6,80005bb0 <snprintf+0xec>
    80005b5c:	02fb6763          	bltu	s6,a5,80005b8a <snprintf+0xc6>
    80005b60:	0d478063          	beq	a5,s4,80005c20 <snprintf+0x15c>
    80005b64:	0d879463          	bne	a5,s8,80005c2c <snprintf+0x168>
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005b68:	f9843783          	ld	a5,-104(s0)
    80005b6c:	00878713          	addi	a4,a5,8
    80005b70:	f8e43c23          	sd	a4,-104(s0)
    80005b74:	4685                	li	a3,1
    80005b76:	4629                	li	a2,10
    80005b78:	438c                	lw	a1,0(a5)
    80005b7a:	009b8533          	add	a0,s7,s1
    80005b7e:	00000097          	auipc	ra,0x0
    80005b82:	eac080e7          	jalr	-340(ra) # 80005a2a <sprintint>
    80005b86:	9ca9                	addw	s1,s1,a0
      break;
    80005b88:	b775                	j	80005b34 <snprintf+0x70>
    switch(c){
    80005b8a:	0b979163          	bne	a5,s9,80005c2c <snprintf+0x168>
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005b8e:	f9843783          	ld	a5,-104(s0)
    80005b92:	00878713          	addi	a4,a5,8
    80005b96:	f8e43c23          	sd	a4,-104(s0)
    80005b9a:	4685                	li	a3,1
    80005b9c:	4641                	li	a2,16
    80005b9e:	438c                	lw	a1,0(a5)
    80005ba0:	009b8533          	add	a0,s7,s1
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	e86080e7          	jalr	-378(ra) # 80005a2a <sprintint>
    80005bac:	9ca9                	addw	s1,s1,a0
      break;
    80005bae:	b759                	j	80005b34 <snprintf+0x70>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80005bb0:	f9843783          	ld	a5,-104(s0)
    80005bb4:	00878713          	addi	a4,a5,8
    80005bb8:	f8e43c23          	sd	a4,-104(s0)
    80005bbc:	6388                	ld	a0,0(a5)
    80005bbe:	c931                	beqz	a0,80005c12 <snprintf+0x14e>
        s = "(null)";
      for(; *s && off < sz; s++)
    80005bc0:	00054703          	lbu	a4,0(a0)
    80005bc4:	db25                	beqz	a4,80005b34 <snprintf+0x70>
    80005bc6:	0354d863          	bge	s1,s5,80005bf6 <snprintf+0x132>
    80005bca:	009b86b3          	add	a3,s7,s1
    80005bce:	409a863b          	subw	a2,s5,s1
    80005bd2:	1602                	slli	a2,a2,0x20
    80005bd4:	9201                	srli	a2,a2,0x20
    80005bd6:	962a                	add	a2,a2,a0
    80005bd8:	87aa                	mv	a5,a0
        off += sputc(buf+off, *s);
    80005bda:	0014859b          	addiw	a1,s1,1
    80005bde:	9d89                	subw	a1,a1,a0
  *s = c;
    80005be0:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005be4:	00f584bb          	addw	s1,a1,a5
      for(; *s && off < sz; s++)
    80005be8:	0785                	addi	a5,a5,1
    80005bea:	0007c703          	lbu	a4,0(a5)
    80005bee:	d339                	beqz	a4,80005b34 <snprintf+0x70>
    80005bf0:	0685                	addi	a3,a3,1
    80005bf2:	fec797e3          	bne	a5,a2,80005be0 <snprintf+0x11c>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005bf6:	8526                	mv	a0,s1
    80005bf8:	70a6                	ld	ra,104(sp)
    80005bfa:	7406                	ld	s0,96(sp)
    80005bfc:	64e6                	ld	s1,88(sp)
    80005bfe:	6946                	ld	s2,80(sp)
    80005c00:	69a6                	ld	s3,72(sp)
    80005c02:	6a06                	ld	s4,64(sp)
    80005c04:	7ae2                	ld	s5,56(sp)
    80005c06:	7b42                	ld	s6,48(sp)
    80005c08:	7ba2                	ld	s7,40(sp)
    80005c0a:	7c02                	ld	s8,32(sp)
    80005c0c:	6ce2                	ld	s9,24(sp)
    80005c0e:	610d                	addi	sp,sp,160
    80005c10:	8082                	ret
      for(; *s && off < sz; s++)
    80005c12:	02800713          	li	a4,40
        s = "(null)";
    80005c16:	00003517          	auipc	a0,0x3
    80005c1a:	bb250513          	addi	a0,a0,-1102 # 800087c8 <syscalls+0x3f8>
    80005c1e:	b765                	j	80005bc6 <snprintf+0x102>
  *s = c;
    80005c20:	009b87b3          	add	a5,s7,s1
    80005c24:	01478023          	sb	s4,0(a5)
      off += sputc(buf+off, '%');
    80005c28:	2485                	addiw	s1,s1,1
      break;
    80005c2a:	b729                	j	80005b34 <snprintf+0x70>
  *s = c;
    80005c2c:	009b8733          	add	a4,s7,s1
    80005c30:	01470023          	sb	s4,0(a4)
      off += sputc(buf+off, c);
    80005c34:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c38:	975e                	add	a4,a4,s7
    80005c3a:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c3e:	2489                	addiw	s1,s1,2
      break;
    80005c40:	bdd5                	j	80005b34 <snprintf+0x70>

0000000080005c42 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c42:	1141                	addi	sp,sp,-16
    80005c44:	e422                	sd	s0,8(sp)
    80005c46:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c48:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c4c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c50:	0037979b          	slliw	a5,a5,0x3
    80005c54:	02004737          	lui	a4,0x2004
    80005c58:	97ba                	add	a5,a5,a4
    80005c5a:	0200c737          	lui	a4,0x200c
    80005c5e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c62:	000f4637          	lui	a2,0xf4
    80005c66:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c6a:	9732                	add	a4,a4,a2
    80005c6c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c6e:	00259693          	slli	a3,a1,0x2
    80005c72:	96ae                	add	a3,a3,a1
    80005c74:	068e                	slli	a3,a3,0x3
    80005c76:	00019717          	auipc	a4,0x19
    80005c7a:	cda70713          	addi	a4,a4,-806 # 8001e950 <timer_scratch>
    80005c7e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c80:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c82:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c84:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c88:	fffff797          	auipc	a5,0xfffff
    80005c8c:	66878793          	addi	a5,a5,1640 # 800052f0 <timervec>
    80005c90:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c94:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c98:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c9c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005ca0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005ca4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ca8:	30479073          	csrw	mie,a5
}
    80005cac:	6422                	ld	s0,8(sp)
    80005cae:	0141                	addi	sp,sp,16
    80005cb0:	8082                	ret

0000000080005cb2 <start>:
{
    80005cb2:	1141                	addi	sp,sp,-16
    80005cb4:	e406                	sd	ra,8(sp)
    80005cb6:	e022                	sd	s0,0(sp)
    80005cb8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005cba:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005cbe:	7779                	lui	a4,0xffffe
    80005cc0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd6c97>
    80005cc4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005cc6:	6705                	lui	a4,0x1
    80005cc8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005ccc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005cce:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005cd2:	ffffa797          	auipc	a5,0xffffa
    80005cd6:	73478793          	addi	a5,a5,1844 # 80000406 <main>
    80005cda:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005cde:	4781                	li	a5,0
    80005ce0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005ce4:	67c1                	lui	a5,0x10
    80005ce6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005ce8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005cec:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cf0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cf4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cf8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cfc:	57fd                	li	a5,-1
    80005cfe:	83a9                	srli	a5,a5,0xa
    80005d00:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005d04:	47bd                	li	a5,15
    80005d06:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	f38080e7          	jalr	-200(ra) # 80005c42 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d12:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d16:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d18:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d1a:	30200073          	mret
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret

0000000080005d26 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d26:	715d                	addi	sp,sp,-80
    80005d28:	e486                	sd	ra,72(sp)
    80005d2a:	e0a2                	sd	s0,64(sp)
    80005d2c:	fc26                	sd	s1,56(sp)
    80005d2e:	f84a                	sd	s2,48(sp)
    80005d30:	f44e                	sd	s3,40(sp)
    80005d32:	f052                	sd	s4,32(sp)
    80005d34:	ec56                	sd	s5,24(sp)
    80005d36:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d38:	04c05763          	blez	a2,80005d86 <consolewrite+0x60>
    80005d3c:	8a2a                	mv	s4,a0
    80005d3e:	84ae                	mv	s1,a1
    80005d40:	89b2                	mv	s3,a2
    80005d42:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d44:	5afd                	li	s5,-1
    80005d46:	4685                	li	a3,1
    80005d48:	8626                	mv	a2,s1
    80005d4a:	85d2                	mv	a1,s4
    80005d4c:	fbf40513          	addi	a0,s0,-65
    80005d50:	ffffc097          	auipc	ra,0xffffc
    80005d54:	d00080e7          	jalr	-768(ra) # 80001a50 <either_copyin>
    80005d58:	01550d63          	beq	a0,s5,80005d72 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005d5c:	fbf44503          	lbu	a0,-65(s0)
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	780080e7          	jalr	1920(ra) # 800064e0 <uartputc>
  for(i = 0; i < n; i++){
    80005d68:	2905                	addiw	s2,s2,1
    80005d6a:	0485                	addi	s1,s1,1
    80005d6c:	fd299de3          	bne	s3,s2,80005d46 <consolewrite+0x20>
    80005d70:	894e                	mv	s2,s3
  }

  return i;
}
    80005d72:	854a                	mv	a0,s2
    80005d74:	60a6                	ld	ra,72(sp)
    80005d76:	6406                	ld	s0,64(sp)
    80005d78:	74e2                	ld	s1,56(sp)
    80005d7a:	7942                	ld	s2,48(sp)
    80005d7c:	79a2                	ld	s3,40(sp)
    80005d7e:	7a02                	ld	s4,32(sp)
    80005d80:	6ae2                	ld	s5,24(sp)
    80005d82:	6161                	addi	sp,sp,80
    80005d84:	8082                	ret
  for(i = 0; i < n; i++){
    80005d86:	4901                	li	s2,0
    80005d88:	b7ed                	j	80005d72 <consolewrite+0x4c>

0000000080005d8a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d8a:	711d                	addi	sp,sp,-96
    80005d8c:	ec86                	sd	ra,88(sp)
    80005d8e:	e8a2                	sd	s0,80(sp)
    80005d90:	e4a6                	sd	s1,72(sp)
    80005d92:	e0ca                	sd	s2,64(sp)
    80005d94:	fc4e                	sd	s3,56(sp)
    80005d96:	f852                	sd	s4,48(sp)
    80005d98:	f456                	sd	s5,40(sp)
    80005d9a:	f05a                	sd	s6,32(sp)
    80005d9c:	ec5e                	sd	s7,24(sp)
    80005d9e:	1080                	addi	s0,sp,96
    80005da0:	8aaa                	mv	s5,a0
    80005da2:	8a2e                	mv	s4,a1
    80005da4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005da6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005daa:	00021517          	auipc	a0,0x21
    80005dae:	ce650513          	addi	a0,a0,-794 # 80026a90 <cons>
    80005db2:	00001097          	auipc	ra,0x1
    80005db6:	8d2080e7          	jalr	-1838(ra) # 80006684 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005dba:	00021497          	auipc	s1,0x21
    80005dbe:	cd648493          	addi	s1,s1,-810 # 80026a90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005dc2:	00021917          	auipc	s2,0x21
    80005dc6:	d6e90913          	addi	s2,s2,-658 # 80026b30 <cons+0xa0>
  while(n > 0){
    80005dca:	09305263          	blez	s3,80005e4e <consoleread+0xc4>
    while(cons.r == cons.w){
    80005dce:	0a04a783          	lw	a5,160(s1)
    80005dd2:	0a44a703          	lw	a4,164(s1)
    80005dd6:	02f71763          	bne	a4,a5,80005e04 <consoleread+0x7a>
      if(killed(myproc())){
    80005dda:	ffffb097          	auipc	ra,0xffffb
    80005dde:	170080e7          	jalr	368(ra) # 80000f4a <myproc>
    80005de2:	ffffc097          	auipc	ra,0xffffc
    80005de6:	ab8080e7          	jalr	-1352(ra) # 8000189a <killed>
    80005dea:	ed2d                	bnez	a0,80005e64 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    80005dec:	85a6                	mv	a1,s1
    80005dee:	854a                	mv	a0,s2
    80005df0:	ffffc097          	auipc	ra,0xffffc
    80005df4:	802080e7          	jalr	-2046(ra) # 800015f2 <sleep>
    while(cons.r == cons.w){
    80005df8:	0a04a783          	lw	a5,160(s1)
    80005dfc:	0a44a703          	lw	a4,164(s1)
    80005e00:	fcf70de3          	beq	a4,a5,80005dda <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005e04:	00021717          	auipc	a4,0x21
    80005e08:	c8c70713          	addi	a4,a4,-884 # 80026a90 <cons>
    80005e0c:	0017869b          	addiw	a3,a5,1
    80005e10:	0ad72023          	sw	a3,160(a4)
    80005e14:	07f7f693          	andi	a3,a5,127
    80005e18:	9736                	add	a4,a4,a3
    80005e1a:	02074703          	lbu	a4,32(a4)
    80005e1e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005e22:	4691                	li	a3,4
    80005e24:	06db8463          	beq	s7,a3,80005e8c <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005e28:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e2c:	4685                	li	a3,1
    80005e2e:	faf40613          	addi	a2,s0,-81
    80005e32:	85d2                	mv	a1,s4
    80005e34:	8556                	mv	a0,s5
    80005e36:	ffffc097          	auipc	ra,0xffffc
    80005e3a:	bc4080e7          	jalr	-1084(ra) # 800019fa <either_copyout>
    80005e3e:	57fd                	li	a5,-1
    80005e40:	00f50763          	beq	a0,a5,80005e4e <consoleread+0xc4>
      break;

    dst++;
    80005e44:	0a05                	addi	s4,s4,1
    --n;
    80005e46:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005e48:	47a9                	li	a5,10
    80005e4a:	f8fb90e3          	bne	s7,a5,80005dca <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005e4e:	00021517          	auipc	a0,0x21
    80005e52:	c4250513          	addi	a0,a0,-958 # 80026a90 <cons>
    80005e56:	00001097          	auipc	ra,0x1
    80005e5a:	8fe080e7          	jalr	-1794(ra) # 80006754 <release>

  return target - n;
    80005e5e:	413b053b          	subw	a0,s6,s3
    80005e62:	a811                	j	80005e76 <consoleread+0xec>
        release(&cons.lock);
    80005e64:	00021517          	auipc	a0,0x21
    80005e68:	c2c50513          	addi	a0,a0,-980 # 80026a90 <cons>
    80005e6c:	00001097          	auipc	ra,0x1
    80005e70:	8e8080e7          	jalr	-1816(ra) # 80006754 <release>
        return -1;
    80005e74:	557d                	li	a0,-1
}
    80005e76:	60e6                	ld	ra,88(sp)
    80005e78:	6446                	ld	s0,80(sp)
    80005e7a:	64a6                	ld	s1,72(sp)
    80005e7c:	6906                	ld	s2,64(sp)
    80005e7e:	79e2                	ld	s3,56(sp)
    80005e80:	7a42                	ld	s4,48(sp)
    80005e82:	7aa2                	ld	s5,40(sp)
    80005e84:	7b02                	ld	s6,32(sp)
    80005e86:	6be2                	ld	s7,24(sp)
    80005e88:	6125                	addi	sp,sp,96
    80005e8a:	8082                	ret
      if(n < target){
    80005e8c:	0009871b          	sext.w	a4,s3
    80005e90:	fb677fe3          	bgeu	a4,s6,80005e4e <consoleread+0xc4>
        cons.r--;
    80005e94:	00021717          	auipc	a4,0x21
    80005e98:	c8f72e23          	sw	a5,-868(a4) # 80026b30 <cons+0xa0>
    80005e9c:	bf4d                	j	80005e4e <consoleread+0xc4>

0000000080005e9e <consputc>:
{
    80005e9e:	1141                	addi	sp,sp,-16
    80005ea0:	e406                	sd	ra,8(sp)
    80005ea2:	e022                	sd	s0,0(sp)
    80005ea4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ea6:	10000793          	li	a5,256
    80005eaa:	00f50a63          	beq	a0,a5,80005ebe <consputc+0x20>
    uartputc_sync(c);
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	560080e7          	jalr	1376(ra) # 8000640e <uartputc_sync>
}
    80005eb6:	60a2                	ld	ra,8(sp)
    80005eb8:	6402                	ld	s0,0(sp)
    80005eba:	0141                	addi	sp,sp,16
    80005ebc:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ebe:	4521                	li	a0,8
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	54e080e7          	jalr	1358(ra) # 8000640e <uartputc_sync>
    80005ec8:	02000513          	li	a0,32
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	542080e7          	jalr	1346(ra) # 8000640e <uartputc_sync>
    80005ed4:	4521                	li	a0,8
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	538080e7          	jalr	1336(ra) # 8000640e <uartputc_sync>
    80005ede:	bfe1                	j	80005eb6 <consputc+0x18>

0000000080005ee0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ee0:	1101                	addi	sp,sp,-32
    80005ee2:	ec06                	sd	ra,24(sp)
    80005ee4:	e822                	sd	s0,16(sp)
    80005ee6:	e426                	sd	s1,8(sp)
    80005ee8:	e04a                	sd	s2,0(sp)
    80005eea:	1000                	addi	s0,sp,32
    80005eec:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005eee:	00021517          	auipc	a0,0x21
    80005ef2:	ba250513          	addi	a0,a0,-1118 # 80026a90 <cons>
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	78e080e7          	jalr	1934(ra) # 80006684 <acquire>

  switch(c){
    80005efe:	47d5                	li	a5,21
    80005f00:	0af48663          	beq	s1,a5,80005fac <consoleintr+0xcc>
    80005f04:	0297ca63          	blt	a5,s1,80005f38 <consoleintr+0x58>
    80005f08:	47a1                	li	a5,8
    80005f0a:	0ef48763          	beq	s1,a5,80005ff8 <consoleintr+0x118>
    80005f0e:	47c1                	li	a5,16
    80005f10:	10f49a63          	bne	s1,a5,80006024 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005f14:	ffffc097          	auipc	ra,0xffffc
    80005f18:	b92080e7          	jalr	-1134(ra) # 80001aa6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f1c:	00021517          	auipc	a0,0x21
    80005f20:	b7450513          	addi	a0,a0,-1164 # 80026a90 <cons>
    80005f24:	00001097          	auipc	ra,0x1
    80005f28:	830080e7          	jalr	-2000(ra) # 80006754 <release>
}
    80005f2c:	60e2                	ld	ra,24(sp)
    80005f2e:	6442                	ld	s0,16(sp)
    80005f30:	64a2                	ld	s1,8(sp)
    80005f32:	6902                	ld	s2,0(sp)
    80005f34:	6105                	addi	sp,sp,32
    80005f36:	8082                	ret
  switch(c){
    80005f38:	07f00793          	li	a5,127
    80005f3c:	0af48e63          	beq	s1,a5,80005ff8 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005f40:	00021717          	auipc	a4,0x21
    80005f44:	b5070713          	addi	a4,a4,-1200 # 80026a90 <cons>
    80005f48:	0a872783          	lw	a5,168(a4)
    80005f4c:	0a072703          	lw	a4,160(a4)
    80005f50:	9f99                	subw	a5,a5,a4
    80005f52:	07f00713          	li	a4,127
    80005f56:	fcf763e3          	bltu	a4,a5,80005f1c <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f5a:	47b5                	li	a5,13
    80005f5c:	0cf48763          	beq	s1,a5,8000602a <consoleintr+0x14a>
      consputc(c);
    80005f60:	8526                	mv	a0,s1
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	f3c080e7          	jalr	-196(ra) # 80005e9e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f6a:	00021797          	auipc	a5,0x21
    80005f6e:	b2678793          	addi	a5,a5,-1242 # 80026a90 <cons>
    80005f72:	0a87a683          	lw	a3,168(a5)
    80005f76:	0016871b          	addiw	a4,a3,1
    80005f7a:	0007061b          	sext.w	a2,a4
    80005f7e:	0ae7a423          	sw	a4,168(a5)
    80005f82:	07f6f693          	andi	a3,a3,127
    80005f86:	97b6                	add	a5,a5,a3
    80005f88:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005f8c:	47a9                	li	a5,10
    80005f8e:	0cf48563          	beq	s1,a5,80006058 <consoleintr+0x178>
    80005f92:	4791                	li	a5,4
    80005f94:	0cf48263          	beq	s1,a5,80006058 <consoleintr+0x178>
    80005f98:	00021797          	auipc	a5,0x21
    80005f9c:	b987a783          	lw	a5,-1128(a5) # 80026b30 <cons+0xa0>
    80005fa0:	9f1d                	subw	a4,a4,a5
    80005fa2:	08000793          	li	a5,128
    80005fa6:	f6f71be3          	bne	a4,a5,80005f1c <consoleintr+0x3c>
    80005faa:	a07d                	j	80006058 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005fac:	00021717          	auipc	a4,0x21
    80005fb0:	ae470713          	addi	a4,a4,-1308 # 80026a90 <cons>
    80005fb4:	0a872783          	lw	a5,168(a4)
    80005fb8:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005fbc:	00021497          	auipc	s1,0x21
    80005fc0:	ad448493          	addi	s1,s1,-1324 # 80026a90 <cons>
    while(cons.e != cons.w &&
    80005fc4:	4929                	li	s2,10
    80005fc6:	f4f70be3          	beq	a4,a5,80005f1c <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005fca:	37fd                	addiw	a5,a5,-1
    80005fcc:	07f7f713          	andi	a4,a5,127
    80005fd0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005fd2:	02074703          	lbu	a4,32(a4)
    80005fd6:	f52703e3          	beq	a4,s2,80005f1c <consoleintr+0x3c>
      cons.e--;
    80005fda:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005fde:	10000513          	li	a0,256
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	ebc080e7          	jalr	-324(ra) # 80005e9e <consputc>
    while(cons.e != cons.w &&
    80005fea:	0a84a783          	lw	a5,168(s1)
    80005fee:	0a44a703          	lw	a4,164(s1)
    80005ff2:	fcf71ce3          	bne	a4,a5,80005fca <consoleintr+0xea>
    80005ff6:	b71d                	j	80005f1c <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ff8:	00021717          	auipc	a4,0x21
    80005ffc:	a9870713          	addi	a4,a4,-1384 # 80026a90 <cons>
    80006000:	0a872783          	lw	a5,168(a4)
    80006004:	0a472703          	lw	a4,164(a4)
    80006008:	f0f70ae3          	beq	a4,a5,80005f1c <consoleintr+0x3c>
      cons.e--;
    8000600c:	37fd                	addiw	a5,a5,-1
    8000600e:	00021717          	auipc	a4,0x21
    80006012:	b2f72523          	sw	a5,-1238(a4) # 80026b38 <cons+0xa8>
      consputc(BACKSPACE);
    80006016:	10000513          	li	a0,256
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	e84080e7          	jalr	-380(ra) # 80005e9e <consputc>
    80006022:	bded                	j	80005f1c <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80006024:	ee048ce3          	beqz	s1,80005f1c <consoleintr+0x3c>
    80006028:	bf21                	j	80005f40 <consoleintr+0x60>
      consputc(c);
    8000602a:	4529                	li	a0,10
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	e72080e7          	jalr	-398(ra) # 80005e9e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80006034:	00021797          	auipc	a5,0x21
    80006038:	a5c78793          	addi	a5,a5,-1444 # 80026a90 <cons>
    8000603c:	0a87a703          	lw	a4,168(a5)
    80006040:	0017069b          	addiw	a3,a4,1
    80006044:	0006861b          	sext.w	a2,a3
    80006048:	0ad7a423          	sw	a3,168(a5)
    8000604c:	07f77713          	andi	a4,a4,127
    80006050:	97ba                	add	a5,a5,a4
    80006052:	4729                	li	a4,10
    80006054:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80006058:	00021797          	auipc	a5,0x21
    8000605c:	acc7ae23          	sw	a2,-1316(a5) # 80026b34 <cons+0xa4>
        wakeup(&cons.r);
    80006060:	00021517          	auipc	a0,0x21
    80006064:	ad050513          	addi	a0,a0,-1328 # 80026b30 <cons+0xa0>
    80006068:	ffffb097          	auipc	ra,0xffffb
    8000606c:	5ee080e7          	jalr	1518(ra) # 80001656 <wakeup>
    80006070:	b575                	j	80005f1c <consoleintr+0x3c>

0000000080006072 <consoleinit>:

void
consoleinit(void)
{
    80006072:	1141                	addi	sp,sp,-16
    80006074:	e406                	sd	ra,8(sp)
    80006076:	e022                	sd	s0,0(sp)
    80006078:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000607a:	00002597          	auipc	a1,0x2
    8000607e:	77e58593          	addi	a1,a1,1918 # 800087f8 <digits+0x18>
    80006082:	00021517          	auipc	a0,0x21
    80006086:	a0e50513          	addi	a0,a0,-1522 # 80026a90 <cons>
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	776080e7          	jalr	1910(ra) # 80006800 <initlock>

  uartinit();
    80006092:	00000097          	auipc	ra,0x0
    80006096:	32c080e7          	jalr	812(ra) # 800063be <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000609a:	00016797          	auipc	a5,0x16
    8000609e:	6de78793          	addi	a5,a5,1758 # 8001c778 <devsw>
    800060a2:	00000717          	auipc	a4,0x0
    800060a6:	ce870713          	addi	a4,a4,-792 # 80005d8a <consoleread>
    800060aa:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800060ac:	00000717          	auipc	a4,0x0
    800060b0:	c7a70713          	addi	a4,a4,-902 # 80005d26 <consolewrite>
    800060b4:	ef98                	sd	a4,24(a5)
}
    800060b6:	60a2                	ld	ra,8(sp)
    800060b8:	6402                	ld	s0,0(sp)
    800060ba:	0141                	addi	sp,sp,16
    800060bc:	8082                	ret

00000000800060be <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800060be:	7179                	addi	sp,sp,-48
    800060c0:	f406                	sd	ra,40(sp)
    800060c2:	f022                	sd	s0,32(sp)
    800060c4:	ec26                	sd	s1,24(sp)
    800060c6:	e84a                	sd	s2,16(sp)
    800060c8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060ca:	c219                	beqz	a2,800060d0 <printint+0x12>
    800060cc:	08054763          	bltz	a0,8000615a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800060d0:	2501                	sext.w	a0,a0
    800060d2:	4881                	li	a7,0
    800060d4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060d8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060da:	2581                	sext.w	a1,a1
    800060dc:	00002617          	auipc	a2,0x2
    800060e0:	73460613          	addi	a2,a2,1844 # 80008810 <digits>
    800060e4:	883a                	mv	a6,a4
    800060e6:	2705                	addiw	a4,a4,1
    800060e8:	02b577bb          	remuw	a5,a0,a1
    800060ec:	1782                	slli	a5,a5,0x20
    800060ee:	9381                	srli	a5,a5,0x20
    800060f0:	97b2                	add	a5,a5,a2
    800060f2:	0007c783          	lbu	a5,0(a5)
    800060f6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060fa:	0005079b          	sext.w	a5,a0
    800060fe:	02b5553b          	divuw	a0,a0,a1
    80006102:	0685                	addi	a3,a3,1
    80006104:	feb7f0e3          	bgeu	a5,a1,800060e4 <printint+0x26>

  if(sign)
    80006108:	00088c63          	beqz	a7,80006120 <printint+0x62>
    buf[i++] = '-';
    8000610c:	fe070793          	addi	a5,a4,-32
    80006110:	00878733          	add	a4,a5,s0
    80006114:	02d00793          	li	a5,45
    80006118:	fef70823          	sb	a5,-16(a4)
    8000611c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006120:	02e05763          	blez	a4,8000614e <printint+0x90>
    80006124:	fd040793          	addi	a5,s0,-48
    80006128:	00e784b3          	add	s1,a5,a4
    8000612c:	fff78913          	addi	s2,a5,-1
    80006130:	993a                	add	s2,s2,a4
    80006132:	377d                	addiw	a4,a4,-1
    80006134:	1702                	slli	a4,a4,0x20
    80006136:	9301                	srli	a4,a4,0x20
    80006138:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000613c:	fff4c503          	lbu	a0,-1(s1)
    80006140:	00000097          	auipc	ra,0x0
    80006144:	d5e080e7          	jalr	-674(ra) # 80005e9e <consputc>
  while(--i >= 0)
    80006148:	14fd                	addi	s1,s1,-1
    8000614a:	ff2499e3          	bne	s1,s2,8000613c <printint+0x7e>
}
    8000614e:	70a2                	ld	ra,40(sp)
    80006150:	7402                	ld	s0,32(sp)
    80006152:	64e2                	ld	s1,24(sp)
    80006154:	6942                	ld	s2,16(sp)
    80006156:	6145                	addi	sp,sp,48
    80006158:	8082                	ret
    x = -xx;
    8000615a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000615e:	4885                	li	a7,1
    x = -xx;
    80006160:	bf95                	j	800060d4 <printint+0x16>

0000000080006162 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006162:	1101                	addi	sp,sp,-32
    80006164:	ec06                	sd	ra,24(sp)
    80006166:	e822                	sd	s0,16(sp)
    80006168:	e426                	sd	s1,8(sp)
    8000616a:	1000                	addi	s0,sp,32
    8000616c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000616e:	00021797          	auipc	a5,0x21
    80006172:	9e07a923          	sw	zero,-1550(a5) # 80026b60 <pr+0x20>
  printf("panic: ");
    80006176:	00002517          	auipc	a0,0x2
    8000617a:	68a50513          	addi	a0,a0,1674 # 80008800 <digits+0x20>
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	02e080e7          	jalr	46(ra) # 800061ac <printf>
  printf(s);
    80006186:	8526                	mv	a0,s1
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	024080e7          	jalr	36(ra) # 800061ac <printf>
  printf("\n");
    80006190:	00002517          	auipc	a0,0x2
    80006194:	70850513          	addi	a0,a0,1800 # 80008898 <digits+0x88>
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	014080e7          	jalr	20(ra) # 800061ac <printf>
  panicked = 1; // freeze uart output from other CPUs
    800061a0:	4785                	li	a5,1
    800061a2:	00002717          	auipc	a4,0x2
    800061a6:	7cf72d23          	sw	a5,2010(a4) # 8000897c <panicked>
  for(;;)
    800061aa:	a001                	j	800061aa <panic+0x48>

00000000800061ac <printf>:
{
    800061ac:	7131                	addi	sp,sp,-192
    800061ae:	fc86                	sd	ra,120(sp)
    800061b0:	f8a2                	sd	s0,112(sp)
    800061b2:	f4a6                	sd	s1,104(sp)
    800061b4:	f0ca                	sd	s2,96(sp)
    800061b6:	ecce                	sd	s3,88(sp)
    800061b8:	e8d2                	sd	s4,80(sp)
    800061ba:	e4d6                	sd	s5,72(sp)
    800061bc:	e0da                	sd	s6,64(sp)
    800061be:	fc5e                	sd	s7,56(sp)
    800061c0:	f862                	sd	s8,48(sp)
    800061c2:	f466                	sd	s9,40(sp)
    800061c4:	f06a                	sd	s10,32(sp)
    800061c6:	ec6e                	sd	s11,24(sp)
    800061c8:	0100                	addi	s0,sp,128
    800061ca:	8a2a                	mv	s4,a0
    800061cc:	e40c                	sd	a1,8(s0)
    800061ce:	e810                	sd	a2,16(s0)
    800061d0:	ec14                	sd	a3,24(s0)
    800061d2:	f018                	sd	a4,32(s0)
    800061d4:	f41c                	sd	a5,40(s0)
    800061d6:	03043823          	sd	a6,48(s0)
    800061da:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061de:	00021d97          	auipc	s11,0x21
    800061e2:	982dad83          	lw	s11,-1662(s11) # 80026b60 <pr+0x20>
  if(locking)
    800061e6:	020d9b63          	bnez	s11,8000621c <printf+0x70>
  if (fmt == 0)
    800061ea:	040a0263          	beqz	s4,8000622e <printf+0x82>
  va_start(ap, fmt);
    800061ee:	00840793          	addi	a5,s0,8
    800061f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061f6:	000a4503          	lbu	a0,0(s4)
    800061fa:	14050f63          	beqz	a0,80006358 <printf+0x1ac>
    800061fe:	4981                	li	s3,0
    if(c != '%'){
    80006200:	02500a93          	li	s5,37
    switch(c){
    80006204:	07000b93          	li	s7,112
  consputc('x');
    80006208:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000620a:	00002b17          	auipc	s6,0x2
    8000620e:	606b0b13          	addi	s6,s6,1542 # 80008810 <digits>
    switch(c){
    80006212:	07300c93          	li	s9,115
    80006216:	06400c13          	li	s8,100
    8000621a:	a82d                	j	80006254 <printf+0xa8>
    acquire(&pr.lock);
    8000621c:	00021517          	auipc	a0,0x21
    80006220:	92450513          	addi	a0,a0,-1756 # 80026b40 <pr>
    80006224:	00000097          	auipc	ra,0x0
    80006228:	460080e7          	jalr	1120(ra) # 80006684 <acquire>
    8000622c:	bf7d                	j	800061ea <printf+0x3e>
    panic("null fmt");
    8000622e:	00002517          	auipc	a0,0x2
    80006232:	5a250513          	addi	a0,a0,1442 # 800087d0 <syscalls+0x400>
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	f2c080e7          	jalr	-212(ra) # 80006162 <panic>
      consputc(c);
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	c60080e7          	jalr	-928(ra) # 80005e9e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006246:	2985                	addiw	s3,s3,1
    80006248:	013a07b3          	add	a5,s4,s3
    8000624c:	0007c503          	lbu	a0,0(a5)
    80006250:	10050463          	beqz	a0,80006358 <printf+0x1ac>
    if(c != '%'){
    80006254:	ff5515e3          	bne	a0,s5,8000623e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006258:	2985                	addiw	s3,s3,1
    8000625a:	013a07b3          	add	a5,s4,s3
    8000625e:	0007c783          	lbu	a5,0(a5)
    80006262:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006266:	cbed                	beqz	a5,80006358 <printf+0x1ac>
    switch(c){
    80006268:	05778a63          	beq	a5,s7,800062bc <printf+0x110>
    8000626c:	02fbf663          	bgeu	s7,a5,80006298 <printf+0xec>
    80006270:	09978863          	beq	a5,s9,80006300 <printf+0x154>
    80006274:	07800713          	li	a4,120
    80006278:	0ce79563          	bne	a5,a4,80006342 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000627c:	f8843783          	ld	a5,-120(s0)
    80006280:	00878713          	addi	a4,a5,8
    80006284:	f8e43423          	sd	a4,-120(s0)
    80006288:	4605                	li	a2,1
    8000628a:	85ea                	mv	a1,s10
    8000628c:	4388                	lw	a0,0(a5)
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	e30080e7          	jalr	-464(ra) # 800060be <printint>
      break;
    80006296:	bf45                	j	80006246 <printf+0x9a>
    switch(c){
    80006298:	09578f63          	beq	a5,s5,80006336 <printf+0x18a>
    8000629c:	0b879363          	bne	a5,s8,80006342 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    800062a0:	f8843783          	ld	a5,-120(s0)
    800062a4:	00878713          	addi	a4,a5,8
    800062a8:	f8e43423          	sd	a4,-120(s0)
    800062ac:	4605                	li	a2,1
    800062ae:	45a9                	li	a1,10
    800062b0:	4388                	lw	a0,0(a5)
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	e0c080e7          	jalr	-500(ra) # 800060be <printint>
      break;
    800062ba:	b771                	j	80006246 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800062bc:	f8843783          	ld	a5,-120(s0)
    800062c0:	00878713          	addi	a4,a5,8
    800062c4:	f8e43423          	sd	a4,-120(s0)
    800062c8:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800062cc:	03000513          	li	a0,48
    800062d0:	00000097          	auipc	ra,0x0
    800062d4:	bce080e7          	jalr	-1074(ra) # 80005e9e <consputc>
  consputc('x');
    800062d8:	07800513          	li	a0,120
    800062dc:	00000097          	auipc	ra,0x0
    800062e0:	bc2080e7          	jalr	-1086(ra) # 80005e9e <consputc>
    800062e4:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062e6:	03c95793          	srli	a5,s2,0x3c
    800062ea:	97da                	add	a5,a5,s6
    800062ec:	0007c503          	lbu	a0,0(a5)
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	bae080e7          	jalr	-1106(ra) # 80005e9e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062f8:	0912                	slli	s2,s2,0x4
    800062fa:	34fd                	addiw	s1,s1,-1
    800062fc:	f4ed                	bnez	s1,800062e6 <printf+0x13a>
    800062fe:	b7a1                	j	80006246 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006300:	f8843783          	ld	a5,-120(s0)
    80006304:	00878713          	addi	a4,a5,8
    80006308:	f8e43423          	sd	a4,-120(s0)
    8000630c:	6384                	ld	s1,0(a5)
    8000630e:	cc89                	beqz	s1,80006328 <printf+0x17c>
      for(; *s; s++)
    80006310:	0004c503          	lbu	a0,0(s1)
    80006314:	d90d                	beqz	a0,80006246 <printf+0x9a>
        consputc(*s);
    80006316:	00000097          	auipc	ra,0x0
    8000631a:	b88080e7          	jalr	-1144(ra) # 80005e9e <consputc>
      for(; *s; s++)
    8000631e:	0485                	addi	s1,s1,1
    80006320:	0004c503          	lbu	a0,0(s1)
    80006324:	f96d                	bnez	a0,80006316 <printf+0x16a>
    80006326:	b705                	j	80006246 <printf+0x9a>
        s = "(null)";
    80006328:	00002497          	auipc	s1,0x2
    8000632c:	4a048493          	addi	s1,s1,1184 # 800087c8 <syscalls+0x3f8>
      for(; *s; s++)
    80006330:	02800513          	li	a0,40
    80006334:	b7cd                	j	80006316 <printf+0x16a>
      consputc('%');
    80006336:	8556                	mv	a0,s5
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	b66080e7          	jalr	-1178(ra) # 80005e9e <consputc>
      break;
    80006340:	b719                	j	80006246 <printf+0x9a>
      consputc('%');
    80006342:	8556                	mv	a0,s5
    80006344:	00000097          	auipc	ra,0x0
    80006348:	b5a080e7          	jalr	-1190(ra) # 80005e9e <consputc>
      consputc(c);
    8000634c:	8526                	mv	a0,s1
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	b50080e7          	jalr	-1200(ra) # 80005e9e <consputc>
      break;
    80006356:	bdc5                	j	80006246 <printf+0x9a>
  if(locking)
    80006358:	020d9163          	bnez	s11,8000637a <printf+0x1ce>
}
    8000635c:	70e6                	ld	ra,120(sp)
    8000635e:	7446                	ld	s0,112(sp)
    80006360:	74a6                	ld	s1,104(sp)
    80006362:	7906                	ld	s2,96(sp)
    80006364:	69e6                	ld	s3,88(sp)
    80006366:	6a46                	ld	s4,80(sp)
    80006368:	6aa6                	ld	s5,72(sp)
    8000636a:	6b06                	ld	s6,64(sp)
    8000636c:	7be2                	ld	s7,56(sp)
    8000636e:	7c42                	ld	s8,48(sp)
    80006370:	7ca2                	ld	s9,40(sp)
    80006372:	7d02                	ld	s10,32(sp)
    80006374:	6de2                	ld	s11,24(sp)
    80006376:	6129                	addi	sp,sp,192
    80006378:	8082                	ret
    release(&pr.lock);
    8000637a:	00020517          	auipc	a0,0x20
    8000637e:	7c650513          	addi	a0,a0,1990 # 80026b40 <pr>
    80006382:	00000097          	auipc	ra,0x0
    80006386:	3d2080e7          	jalr	978(ra) # 80006754 <release>
}
    8000638a:	bfc9                	j	8000635c <printf+0x1b0>

000000008000638c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006396:	00020497          	auipc	s1,0x20
    8000639a:	7aa48493          	addi	s1,s1,1962 # 80026b40 <pr>
    8000639e:	00002597          	auipc	a1,0x2
    800063a2:	46a58593          	addi	a1,a1,1130 # 80008808 <digits+0x28>
    800063a6:	8526                	mv	a0,s1
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	458080e7          	jalr	1112(ra) # 80006800 <initlock>
  pr.locking = 1;
    800063b0:	4785                	li	a5,1
    800063b2:	d09c                	sw	a5,32(s1)
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret

00000000800063be <uartinit>:

void uartstart();

void
uartinit(void)
{
    800063be:	1141                	addi	sp,sp,-16
    800063c0:	e406                	sd	ra,8(sp)
    800063c2:	e022                	sd	s0,0(sp)
    800063c4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063c6:	100007b7          	lui	a5,0x10000
    800063ca:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800063ce:	f8000713          	li	a4,-128
    800063d2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800063d6:	470d                	li	a4,3
    800063d8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800063dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800063e0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063e4:	469d                	li	a3,7
    800063e6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063ea:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063ee:	00002597          	auipc	a1,0x2
    800063f2:	43a58593          	addi	a1,a1,1082 # 80008828 <digits+0x18>
    800063f6:	00020517          	auipc	a0,0x20
    800063fa:	77250513          	addi	a0,a0,1906 # 80026b68 <uart_tx_lock>
    800063fe:	00000097          	auipc	ra,0x0
    80006402:	402080e7          	jalr	1026(ra) # 80006800 <initlock>
}
    80006406:	60a2                	ld	ra,8(sp)
    80006408:	6402                	ld	s0,0(sp)
    8000640a:	0141                	addi	sp,sp,16
    8000640c:	8082                	ret

000000008000640e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000640e:	1101                	addi	sp,sp,-32
    80006410:	ec06                	sd	ra,24(sp)
    80006412:	e822                	sd	s0,16(sp)
    80006414:	e426                	sd	s1,8(sp)
    80006416:	1000                	addi	s0,sp,32
    80006418:	84aa                	mv	s1,a0
  push_off();
    8000641a:	00000097          	auipc	ra,0x0
    8000641e:	21e080e7          	jalr	542(ra) # 80006638 <push_off>

  if(panicked){
    80006422:	00002797          	auipc	a5,0x2
    80006426:	55a7a783          	lw	a5,1370(a5) # 8000897c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000642a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000642e:	c391                	beqz	a5,80006432 <uartputc_sync+0x24>
    for(;;)
    80006430:	a001                	j	80006430 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006432:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006436:	0207f793          	andi	a5,a5,32
    8000643a:	dfe5                	beqz	a5,80006432 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000643c:	0ff4f513          	zext.b	a0,s1
    80006440:	100007b7          	lui	a5,0x10000
    80006444:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006448:	00000097          	auipc	ra,0x0
    8000644c:	2ac080e7          	jalr	684(ra) # 800066f4 <pop_off>
}
    80006450:	60e2                	ld	ra,24(sp)
    80006452:	6442                	ld	s0,16(sp)
    80006454:	64a2                	ld	s1,8(sp)
    80006456:	6105                	addi	sp,sp,32
    80006458:	8082                	ret

000000008000645a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000645a:	00002797          	auipc	a5,0x2
    8000645e:	5267b783          	ld	a5,1318(a5) # 80008980 <uart_tx_r>
    80006462:	00002717          	auipc	a4,0x2
    80006466:	52673703          	ld	a4,1318(a4) # 80008988 <uart_tx_w>
    8000646a:	06f70a63          	beq	a4,a5,800064de <uartstart+0x84>
{
    8000646e:	7139                	addi	sp,sp,-64
    80006470:	fc06                	sd	ra,56(sp)
    80006472:	f822                	sd	s0,48(sp)
    80006474:	f426                	sd	s1,40(sp)
    80006476:	f04a                	sd	s2,32(sp)
    80006478:	ec4e                	sd	s3,24(sp)
    8000647a:	e852                	sd	s4,16(sp)
    8000647c:	e456                	sd	s5,8(sp)
    8000647e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006480:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006484:	00020a17          	auipc	s4,0x20
    80006488:	6e4a0a13          	addi	s4,s4,1764 # 80026b68 <uart_tx_lock>
    uart_tx_r += 1;
    8000648c:	00002497          	auipc	s1,0x2
    80006490:	4f448493          	addi	s1,s1,1268 # 80008980 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006494:	00002997          	auipc	s3,0x2
    80006498:	4f498993          	addi	s3,s3,1268 # 80008988 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000649c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800064a0:	02077713          	andi	a4,a4,32
    800064a4:	c705                	beqz	a4,800064cc <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064a6:	01f7f713          	andi	a4,a5,31
    800064aa:	9752                	add	a4,a4,s4
    800064ac:	02074a83          	lbu	s5,32(a4)
    uart_tx_r += 1;
    800064b0:	0785                	addi	a5,a5,1
    800064b2:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800064b4:	8526                	mv	a0,s1
    800064b6:	ffffb097          	auipc	ra,0xffffb
    800064ba:	1a0080e7          	jalr	416(ra) # 80001656 <wakeup>
    
    WriteReg(THR, c);
    800064be:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800064c2:	609c                	ld	a5,0(s1)
    800064c4:	0009b703          	ld	a4,0(s3)
    800064c8:	fcf71ae3          	bne	a4,a5,8000649c <uartstart+0x42>
  }
}
    800064cc:	70e2                	ld	ra,56(sp)
    800064ce:	7442                	ld	s0,48(sp)
    800064d0:	74a2                	ld	s1,40(sp)
    800064d2:	7902                	ld	s2,32(sp)
    800064d4:	69e2                	ld	s3,24(sp)
    800064d6:	6a42                	ld	s4,16(sp)
    800064d8:	6aa2                	ld	s5,8(sp)
    800064da:	6121                	addi	sp,sp,64
    800064dc:	8082                	ret
    800064de:	8082                	ret

00000000800064e0 <uartputc>:
{
    800064e0:	7179                	addi	sp,sp,-48
    800064e2:	f406                	sd	ra,40(sp)
    800064e4:	f022                	sd	s0,32(sp)
    800064e6:	ec26                	sd	s1,24(sp)
    800064e8:	e84a                	sd	s2,16(sp)
    800064ea:	e44e                	sd	s3,8(sp)
    800064ec:	e052                	sd	s4,0(sp)
    800064ee:	1800                	addi	s0,sp,48
    800064f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800064f2:	00020517          	auipc	a0,0x20
    800064f6:	67650513          	addi	a0,a0,1654 # 80026b68 <uart_tx_lock>
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	18a080e7          	jalr	394(ra) # 80006684 <acquire>
  if(panicked){
    80006502:	00002797          	auipc	a5,0x2
    80006506:	47a7a783          	lw	a5,1146(a5) # 8000897c <panicked>
    8000650a:	e7c9                	bnez	a5,80006594 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000650c:	00002717          	auipc	a4,0x2
    80006510:	47c73703          	ld	a4,1148(a4) # 80008988 <uart_tx_w>
    80006514:	00002797          	auipc	a5,0x2
    80006518:	46c7b783          	ld	a5,1132(a5) # 80008980 <uart_tx_r>
    8000651c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006520:	00020997          	auipc	s3,0x20
    80006524:	64898993          	addi	s3,s3,1608 # 80026b68 <uart_tx_lock>
    80006528:	00002497          	auipc	s1,0x2
    8000652c:	45848493          	addi	s1,s1,1112 # 80008980 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006530:	00002917          	auipc	s2,0x2
    80006534:	45890913          	addi	s2,s2,1112 # 80008988 <uart_tx_w>
    80006538:	00e79f63          	bne	a5,a4,80006556 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000653c:	85ce                	mv	a1,s3
    8000653e:	8526                	mv	a0,s1
    80006540:	ffffb097          	auipc	ra,0xffffb
    80006544:	0b2080e7          	jalr	178(ra) # 800015f2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006548:	00093703          	ld	a4,0(s2)
    8000654c:	609c                	ld	a5,0(s1)
    8000654e:	02078793          	addi	a5,a5,32
    80006552:	fee785e3          	beq	a5,a4,8000653c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006556:	00020497          	auipc	s1,0x20
    8000655a:	61248493          	addi	s1,s1,1554 # 80026b68 <uart_tx_lock>
    8000655e:	01f77793          	andi	a5,a4,31
    80006562:	97a6                	add	a5,a5,s1
    80006564:	03478023          	sb	s4,32(a5)
  uart_tx_w += 1;
    80006568:	0705                	addi	a4,a4,1
    8000656a:	00002797          	auipc	a5,0x2
    8000656e:	40e7bf23          	sd	a4,1054(a5) # 80008988 <uart_tx_w>
  uartstart();
    80006572:	00000097          	auipc	ra,0x0
    80006576:	ee8080e7          	jalr	-280(ra) # 8000645a <uartstart>
  release(&uart_tx_lock);
    8000657a:	8526                	mv	a0,s1
    8000657c:	00000097          	auipc	ra,0x0
    80006580:	1d8080e7          	jalr	472(ra) # 80006754 <release>
}
    80006584:	70a2                	ld	ra,40(sp)
    80006586:	7402                	ld	s0,32(sp)
    80006588:	64e2                	ld	s1,24(sp)
    8000658a:	6942                	ld	s2,16(sp)
    8000658c:	69a2                	ld	s3,8(sp)
    8000658e:	6a02                	ld	s4,0(sp)
    80006590:	6145                	addi	sp,sp,48
    80006592:	8082                	ret
    for(;;)
    80006594:	a001                	j	80006594 <uartputc+0xb4>

0000000080006596 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006596:	1141                	addi	sp,sp,-16
    80006598:	e422                	sd	s0,8(sp)
    8000659a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000659c:	100007b7          	lui	a5,0x10000
    800065a0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800065a4:	8b85                	andi	a5,a5,1
    800065a6:	cb81                	beqz	a5,800065b6 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800065a8:	100007b7          	lui	a5,0x10000
    800065ac:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800065b0:	6422                	ld	s0,8(sp)
    800065b2:	0141                	addi	sp,sp,16
    800065b4:	8082                	ret
    return -1;
    800065b6:	557d                	li	a0,-1
    800065b8:	bfe5                	j	800065b0 <uartgetc+0x1a>

00000000800065ba <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800065ba:	1101                	addi	sp,sp,-32
    800065bc:	ec06                	sd	ra,24(sp)
    800065be:	e822                	sd	s0,16(sp)
    800065c0:	e426                	sd	s1,8(sp)
    800065c2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800065c4:	54fd                	li	s1,-1
    800065c6:	a029                	j	800065d0 <uartintr+0x16>
      break;
    consoleintr(c);
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	918080e7          	jalr	-1768(ra) # 80005ee0 <consoleintr>
    int c = uartgetc();
    800065d0:	00000097          	auipc	ra,0x0
    800065d4:	fc6080e7          	jalr	-58(ra) # 80006596 <uartgetc>
    if(c == -1)
    800065d8:	fe9518e3          	bne	a0,s1,800065c8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065dc:	00020497          	auipc	s1,0x20
    800065e0:	58c48493          	addi	s1,s1,1420 # 80026b68 <uart_tx_lock>
    800065e4:	8526                	mv	a0,s1
    800065e6:	00000097          	auipc	ra,0x0
    800065ea:	09e080e7          	jalr	158(ra) # 80006684 <acquire>
  uartstart();
    800065ee:	00000097          	auipc	ra,0x0
    800065f2:	e6c080e7          	jalr	-404(ra) # 8000645a <uartstart>
  release(&uart_tx_lock);
    800065f6:	8526                	mv	a0,s1
    800065f8:	00000097          	auipc	ra,0x0
    800065fc:	15c080e7          	jalr	348(ra) # 80006754 <release>
}
    80006600:	60e2                	ld	ra,24(sp)
    80006602:	6442                	ld	s0,16(sp)
    80006604:	64a2                	ld	s1,8(sp)
    80006606:	6105                	addi	sp,sp,32
    80006608:	8082                	ret

000000008000660a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000660a:	411c                	lw	a5,0(a0)
    8000660c:	e399                	bnez	a5,80006612 <holding+0x8>
    8000660e:	4501                	li	a0,0
  return r;
}
    80006610:	8082                	ret
{
    80006612:	1101                	addi	sp,sp,-32
    80006614:	ec06                	sd	ra,24(sp)
    80006616:	e822                	sd	s0,16(sp)
    80006618:	e426                	sd	s1,8(sp)
    8000661a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000661c:	6904                	ld	s1,16(a0)
    8000661e:	ffffb097          	auipc	ra,0xffffb
    80006622:	910080e7          	jalr	-1776(ra) # 80000f2e <mycpu>
    80006626:	40a48533          	sub	a0,s1,a0
    8000662a:	00153513          	seqz	a0,a0
}
    8000662e:	60e2                	ld	ra,24(sp)
    80006630:	6442                	ld	s0,16(sp)
    80006632:	64a2                	ld	s1,8(sp)
    80006634:	6105                	addi	sp,sp,32
    80006636:	8082                	ret

0000000080006638 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006638:	1101                	addi	sp,sp,-32
    8000663a:	ec06                	sd	ra,24(sp)
    8000663c:	e822                	sd	s0,16(sp)
    8000663e:	e426                	sd	s1,8(sp)
    80006640:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006642:	100024f3          	csrr	s1,sstatus
    80006646:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000664a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000664c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006650:	ffffb097          	auipc	ra,0xffffb
    80006654:	8de080e7          	jalr	-1826(ra) # 80000f2e <mycpu>
    80006658:	5d3c                	lw	a5,120(a0)
    8000665a:	cf89                	beqz	a5,80006674 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000665c:	ffffb097          	auipc	ra,0xffffb
    80006660:	8d2080e7          	jalr	-1838(ra) # 80000f2e <mycpu>
    80006664:	5d3c                	lw	a5,120(a0)
    80006666:	2785                	addiw	a5,a5,1
    80006668:	dd3c                	sw	a5,120(a0)
}
    8000666a:	60e2                	ld	ra,24(sp)
    8000666c:	6442                	ld	s0,16(sp)
    8000666e:	64a2                	ld	s1,8(sp)
    80006670:	6105                	addi	sp,sp,32
    80006672:	8082                	ret
    mycpu()->intena = old;
    80006674:	ffffb097          	auipc	ra,0xffffb
    80006678:	8ba080e7          	jalr	-1862(ra) # 80000f2e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000667c:	8085                	srli	s1,s1,0x1
    8000667e:	8885                	andi	s1,s1,1
    80006680:	dd64                	sw	s1,124(a0)
    80006682:	bfe9                	j	8000665c <push_off+0x24>

0000000080006684 <acquire>:
{
    80006684:	1101                	addi	sp,sp,-32
    80006686:	ec06                	sd	ra,24(sp)
    80006688:	e822                	sd	s0,16(sp)
    8000668a:	e426                	sd	s1,8(sp)
    8000668c:	1000                	addi	s0,sp,32
    8000668e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006690:	00000097          	auipc	ra,0x0
    80006694:	fa8080e7          	jalr	-88(ra) # 80006638 <push_off>
  if(holding(lk))
    80006698:	8526                	mv	a0,s1
    8000669a:	00000097          	auipc	ra,0x0
    8000669e:	f70080e7          	jalr	-144(ra) # 8000660a <holding>
    800066a2:	e911                	bnez	a0,800066b6 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    800066a4:	4785                	li	a5,1
    800066a6:	01c48713          	addi	a4,s1,28
    800066aa:	0f50000f          	fence	iorw,ow
    800066ae:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066b2:	4705                	li	a4,1
    800066b4:	a839                	j	800066d2 <acquire+0x4e>
    panic("acquire");
    800066b6:	00002517          	auipc	a0,0x2
    800066ba:	17a50513          	addi	a0,a0,378 # 80008830 <digits+0x20>
    800066be:	00000097          	auipc	ra,0x0
    800066c2:	aa4080e7          	jalr	-1372(ra) # 80006162 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800066c6:	01848793          	addi	a5,s1,24
    800066ca:	0f50000f          	fence	iorw,ow
    800066ce:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066d2:	87ba                	mv	a5,a4
    800066d4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800066d8:	2781                	sext.w	a5,a5
    800066da:	f7f5                	bnez	a5,800066c6 <acquire+0x42>
  __sync_synchronize();
    800066dc:	0ff0000f          	fence
  lk->cpu = mycpu();
    800066e0:	ffffb097          	auipc	ra,0xffffb
    800066e4:	84e080e7          	jalr	-1970(ra) # 80000f2e <mycpu>
    800066e8:	e888                	sd	a0,16(s1)
}
    800066ea:	60e2                	ld	ra,24(sp)
    800066ec:	6442                	ld	s0,16(sp)
    800066ee:	64a2                	ld	s1,8(sp)
    800066f0:	6105                	addi	sp,sp,32
    800066f2:	8082                	ret

00000000800066f4 <pop_off>:

void
pop_off(void)
{
    800066f4:	1141                	addi	sp,sp,-16
    800066f6:	e406                	sd	ra,8(sp)
    800066f8:	e022                	sd	s0,0(sp)
    800066fa:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066fc:	ffffb097          	auipc	ra,0xffffb
    80006700:	832080e7          	jalr	-1998(ra) # 80000f2e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006704:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006708:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000670a:	e78d                	bnez	a5,80006734 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000670c:	5d3c                	lw	a5,120(a0)
    8000670e:	02f05b63          	blez	a5,80006744 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006712:	37fd                	addiw	a5,a5,-1
    80006714:	0007871b          	sext.w	a4,a5
    80006718:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000671a:	eb09                	bnez	a4,8000672c <pop_off+0x38>
    8000671c:	5d7c                	lw	a5,124(a0)
    8000671e:	c799                	beqz	a5,8000672c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006720:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006724:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006728:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000672c:	60a2                	ld	ra,8(sp)
    8000672e:	6402                	ld	s0,0(sp)
    80006730:	0141                	addi	sp,sp,16
    80006732:	8082                	ret
    panic("pop_off - interruptible");
    80006734:	00002517          	auipc	a0,0x2
    80006738:	10450513          	addi	a0,a0,260 # 80008838 <digits+0x28>
    8000673c:	00000097          	auipc	ra,0x0
    80006740:	a26080e7          	jalr	-1498(ra) # 80006162 <panic>
    panic("pop_off");
    80006744:	00002517          	auipc	a0,0x2
    80006748:	10c50513          	addi	a0,a0,268 # 80008850 <digits+0x40>
    8000674c:	00000097          	auipc	ra,0x0
    80006750:	a16080e7          	jalr	-1514(ra) # 80006162 <panic>

0000000080006754 <release>:
{
    80006754:	1101                	addi	sp,sp,-32
    80006756:	ec06                	sd	ra,24(sp)
    80006758:	e822                	sd	s0,16(sp)
    8000675a:	e426                	sd	s1,8(sp)
    8000675c:	1000                	addi	s0,sp,32
    8000675e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006760:	00000097          	auipc	ra,0x0
    80006764:	eaa080e7          	jalr	-342(ra) # 8000660a <holding>
    80006768:	c115                	beqz	a0,8000678c <release+0x38>
  lk->cpu = 0;
    8000676a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000676e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006772:	0f50000f          	fence	iorw,ow
    80006776:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000677a:	00000097          	auipc	ra,0x0
    8000677e:	f7a080e7          	jalr	-134(ra) # 800066f4 <pop_off>
}
    80006782:	60e2                	ld	ra,24(sp)
    80006784:	6442                	ld	s0,16(sp)
    80006786:	64a2                	ld	s1,8(sp)
    80006788:	6105                	addi	sp,sp,32
    8000678a:	8082                	ret
    panic("release");
    8000678c:	00002517          	auipc	a0,0x2
    80006790:	0cc50513          	addi	a0,a0,204 # 80008858 <digits+0x48>
    80006794:	00000097          	auipc	ra,0x0
    80006798:	9ce080e7          	jalr	-1586(ra) # 80006162 <panic>

000000008000679c <freelock>:
{
    8000679c:	1101                	addi	sp,sp,-32
    8000679e:	ec06                	sd	ra,24(sp)
    800067a0:	e822                	sd	s0,16(sp)
    800067a2:	e426                	sd	s1,8(sp)
    800067a4:	1000                	addi	s0,sp,32
    800067a6:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800067a8:	00020517          	auipc	a0,0x20
    800067ac:	40050513          	addi	a0,a0,1024 # 80026ba8 <lock_locks>
    800067b0:	00000097          	auipc	ra,0x0
    800067b4:	ed4080e7          	jalr	-300(ra) # 80006684 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800067b8:	00020717          	auipc	a4,0x20
    800067bc:	41070713          	addi	a4,a4,1040 # 80026bc8 <locks>
    800067c0:	4781                	li	a5,0
    800067c2:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800067c6:	6314                	ld	a3,0(a4)
    800067c8:	00968763          	beq	a3,s1,800067d6 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800067cc:	2785                	addiw	a5,a5,1
    800067ce:	0721                	addi	a4,a4,8
    800067d0:	fec79be3          	bne	a5,a2,800067c6 <freelock+0x2a>
    800067d4:	a809                	j	800067e6 <freelock+0x4a>
      locks[i] = 0;
    800067d6:	078e                	slli	a5,a5,0x3
    800067d8:	00020717          	auipc	a4,0x20
    800067dc:	3f070713          	addi	a4,a4,1008 # 80026bc8 <locks>
    800067e0:	97ba                	add	a5,a5,a4
    800067e2:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800067e6:	00020517          	auipc	a0,0x20
    800067ea:	3c250513          	addi	a0,a0,962 # 80026ba8 <lock_locks>
    800067ee:	00000097          	auipc	ra,0x0
    800067f2:	f66080e7          	jalr	-154(ra) # 80006754 <release>
}
    800067f6:	60e2                	ld	ra,24(sp)
    800067f8:	6442                	ld	s0,16(sp)
    800067fa:	64a2                	ld	s1,8(sp)
    800067fc:	6105                	addi	sp,sp,32
    800067fe:	8082                	ret

0000000080006800 <initlock>:
{
    80006800:	1101                	addi	sp,sp,-32
    80006802:	ec06                	sd	ra,24(sp)
    80006804:	e822                	sd	s0,16(sp)
    80006806:	e426                	sd	s1,8(sp)
    80006808:	1000                	addi	s0,sp,32
    8000680a:	84aa                	mv	s1,a0
  lk->name = name;
    8000680c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000680e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006812:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006816:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    8000681a:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000681e:	00020517          	auipc	a0,0x20
    80006822:	38a50513          	addi	a0,a0,906 # 80026ba8 <lock_locks>
    80006826:	00000097          	auipc	ra,0x0
    8000682a:	e5e080e7          	jalr	-418(ra) # 80006684 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000682e:	00020717          	auipc	a4,0x20
    80006832:	39a70713          	addi	a4,a4,922 # 80026bc8 <locks>
    80006836:	4781                	li	a5,0
    80006838:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    8000683c:	6314                	ld	a3,0(a4)
    8000683e:	ce89                	beqz	a3,80006858 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    80006840:	2785                	addiw	a5,a5,1
    80006842:	0721                	addi	a4,a4,8
    80006844:	fec79ce3          	bne	a5,a2,8000683c <initlock+0x3c>
  panic("findslot");
    80006848:	00002517          	auipc	a0,0x2
    8000684c:	01850513          	addi	a0,a0,24 # 80008860 <digits+0x50>
    80006850:	00000097          	auipc	ra,0x0
    80006854:	912080e7          	jalr	-1774(ra) # 80006162 <panic>
      locks[i] = lk;
    80006858:	078e                	slli	a5,a5,0x3
    8000685a:	00020717          	auipc	a4,0x20
    8000685e:	36e70713          	addi	a4,a4,878 # 80026bc8 <locks>
    80006862:	97ba                	add	a5,a5,a4
    80006864:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006866:	00020517          	auipc	a0,0x20
    8000686a:	34250513          	addi	a0,a0,834 # 80026ba8 <lock_locks>
    8000686e:	00000097          	auipc	ra,0x0
    80006872:	ee6080e7          	jalr	-282(ra) # 80006754 <release>
}
    80006876:	60e2                	ld	ra,24(sp)
    80006878:	6442                	ld	s0,16(sp)
    8000687a:	64a2                	ld	s1,8(sp)
    8000687c:	6105                	addi	sp,sp,32
    8000687e:	8082                	ret

0000000080006880 <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    80006880:	1141                	addi	sp,sp,-16
    80006882:	e422                	sd	s0,8(sp)
    80006884:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006886:	0ff0000f          	fence
    8000688a:	4108                	lw	a0,0(a0)
    8000688c:	0ff0000f          	fence
  return val;
}
    80006890:	6422                	ld	s0,8(sp)
    80006892:	0141                	addi	sp,sp,16
    80006894:	8082                	ret

0000000080006896 <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    80006896:	4e5c                	lw	a5,28(a2)
    80006898:	00f04463          	bgtz	a5,800068a0 <snprint_lock+0xa>
  int n = 0;
    8000689c:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    8000689e:	8082                	ret
{
    800068a0:	1141                	addi	sp,sp,-16
    800068a2:	e406                	sd	ra,8(sp)
    800068a4:	e022                	sd	s0,0(sp)
    800068a6:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800068a8:	4e18                	lw	a4,24(a2)
    800068aa:	6614                	ld	a3,8(a2)
    800068ac:	00002617          	auipc	a2,0x2
    800068b0:	fc460613          	addi	a2,a2,-60 # 80008870 <digits+0x60>
    800068b4:	fffff097          	auipc	ra,0xfffff
    800068b8:	210080e7          	jalr	528(ra) # 80005ac4 <snprintf>
}
    800068bc:	60a2                	ld	ra,8(sp)
    800068be:	6402                	ld	s0,0(sp)
    800068c0:	0141                	addi	sp,sp,16
    800068c2:	8082                	ret

00000000800068c4 <statslock>:

int
statslock(char *buf, int sz) {
    800068c4:	7159                	addi	sp,sp,-112
    800068c6:	f486                	sd	ra,104(sp)
    800068c8:	f0a2                	sd	s0,96(sp)
    800068ca:	eca6                	sd	s1,88(sp)
    800068cc:	e8ca                	sd	s2,80(sp)
    800068ce:	e4ce                	sd	s3,72(sp)
    800068d0:	e0d2                	sd	s4,64(sp)
    800068d2:	fc56                	sd	s5,56(sp)
    800068d4:	f85a                	sd	s6,48(sp)
    800068d6:	f45e                	sd	s7,40(sp)
    800068d8:	f062                	sd	s8,32(sp)
    800068da:	ec66                	sd	s9,24(sp)
    800068dc:	e86a                	sd	s10,16(sp)
    800068de:	e46e                	sd	s11,8(sp)
    800068e0:	1880                	addi	s0,sp,112
    800068e2:	8aaa                	mv	s5,a0
    800068e4:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800068e6:	00020517          	auipc	a0,0x20
    800068ea:	2c250513          	addi	a0,a0,706 # 80026ba8 <lock_locks>
    800068ee:	00000097          	auipc	ra,0x0
    800068f2:	d96080e7          	jalr	-618(ra) # 80006684 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800068f6:	00002617          	auipc	a2,0x2
    800068fa:	faa60613          	addi	a2,a2,-86 # 800088a0 <digits+0x90>
    800068fe:	85da                	mv	a1,s6
    80006900:	8556                	mv	a0,s5
    80006902:	fffff097          	auipc	ra,0xfffff
    80006906:	1c2080e7          	jalr	450(ra) # 80005ac4 <snprintf>
    8000690a:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    8000690c:	00020c97          	auipc	s9,0x20
    80006910:	2bcc8c93          	addi	s9,s9,700 # 80026bc8 <locks>
    80006914:	00021c17          	auipc	s8,0x21
    80006918:	254c0c13          	addi	s8,s8,596 # 80027b68 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000691c:	84e6                	mv	s1,s9
  int tot = 0;
    8000691e:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006920:	00002b97          	auipc	s7,0x2
    80006924:	b60b8b93          	addi	s7,s7,-1184 # 80008480 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006928:	00001d17          	auipc	s10,0x1
    8000692c:	6f0d0d13          	addi	s10,s10,1776 # 80008018 <etext+0x18>
    80006930:	a01d                	j	80006956 <statslock+0x92>
      tot += locks[i]->nts;
    80006932:	0009b603          	ld	a2,0(s3)
    80006936:	4e1c                	lw	a5,24(a2)
    80006938:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    8000693c:	412b05bb          	subw	a1,s6,s2
    80006940:	012a8533          	add	a0,s5,s2
    80006944:	00000097          	auipc	ra,0x0
    80006948:	f52080e7          	jalr	-174(ra) # 80006896 <snprint_lock>
    8000694c:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006950:	04a1                	addi	s1,s1,8
    80006952:	05848763          	beq	s1,s8,800069a0 <statslock+0xdc>
    if(locks[i] == 0)
    80006956:	89a6                	mv	s3,s1
    80006958:	609c                	ld	a5,0(s1)
    8000695a:	c3b9                	beqz	a5,800069a0 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    8000695c:	0087bd83          	ld	s11,8(a5)
    80006960:	855e                	mv	a0,s7
    80006962:	ffffa097          	auipc	ra,0xffffa
    80006966:	a7a080e7          	jalr	-1414(ra) # 800003dc <strlen>
    8000696a:	0005061b          	sext.w	a2,a0
    8000696e:	85de                	mv	a1,s7
    80006970:	856e                	mv	a0,s11
    80006972:	ffffa097          	auipc	ra,0xffffa
    80006976:	9c0080e7          	jalr	-1600(ra) # 80000332 <strncmp>
    8000697a:	dd45                	beqz	a0,80006932 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    8000697c:	609c                	ld	a5,0(s1)
    8000697e:	0087bd83          	ld	s11,8(a5)
    80006982:	856a                	mv	a0,s10
    80006984:	ffffa097          	auipc	ra,0xffffa
    80006988:	a58080e7          	jalr	-1448(ra) # 800003dc <strlen>
    8000698c:	0005061b          	sext.w	a2,a0
    80006990:	85ea                	mv	a1,s10
    80006992:	856e                	mv	a0,s11
    80006994:	ffffa097          	auipc	ra,0xffffa
    80006998:	99e080e7          	jalr	-1634(ra) # 80000332 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    8000699c:	f955                	bnez	a0,80006950 <statslock+0x8c>
    8000699e:	bf51                	j	80006932 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800069a0:	00002617          	auipc	a2,0x2
    800069a4:	f2060613          	addi	a2,a2,-224 # 800088c0 <digits+0xb0>
    800069a8:	412b05bb          	subw	a1,s6,s2
    800069ac:	012a8533          	add	a0,s5,s2
    800069b0:	fffff097          	auipc	ra,0xfffff
    800069b4:	114080e7          	jalr	276(ra) # 80005ac4 <snprintf>
    800069b8:	012509bb          	addw	s3,a0,s2
    800069bc:	4b95                	li	s7,5
  int last = 100000000;
    800069be:	05f5e537          	lui	a0,0x5f5e
    800069c2:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    800069c6:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069c8:	00020497          	auipc	s1,0x20
    800069cc:	20048493          	addi	s1,s1,512 # 80026bc8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    800069d0:	1f400913          	li	s2,500
    800069d4:	a891                	j	80006a28 <statslock+0x164>
    800069d6:	2705                	addiw	a4,a4,1
    800069d8:	06a1                	addi	a3,a3,8
    800069da:	03270063          	beq	a4,s2,800069fa <statslock+0x136>
      if(locks[i] == 0)
    800069de:	629c                	ld	a5,0(a3)
    800069e0:	cf89                	beqz	a5,800069fa <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069e2:	4f90                	lw	a2,24(a5)
    800069e4:	00359793          	slli	a5,a1,0x3
    800069e8:	97a6                	add	a5,a5,s1
    800069ea:	639c                	ld	a5,0(a5)
    800069ec:	4f9c                	lw	a5,24(a5)
    800069ee:	fec7d4e3          	bge	a5,a2,800069d6 <statslock+0x112>
    800069f2:	fea652e3          	bge	a2,a0,800069d6 <statslock+0x112>
    800069f6:	85ba                	mv	a1,a4
    800069f8:	bff9                	j	800069d6 <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    800069fa:	058e                	slli	a1,a1,0x3
    800069fc:	00b48d33          	add	s10,s1,a1
    80006a00:	000d3603          	ld	a2,0(s10)
    80006a04:	413b05bb          	subw	a1,s6,s3
    80006a08:	013a8533          	add	a0,s5,s3
    80006a0c:	00000097          	auipc	ra,0x0
    80006a10:	e8a080e7          	jalr	-374(ra) # 80006896 <snprint_lock>
    80006a14:	01350dbb          	addw	s11,a0,s3
    80006a18:	000d899b          	sext.w	s3,s11
    last = locks[top]->nts;
    80006a1c:	000d3783          	ld	a5,0(s10)
    80006a20:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006a22:	3bfd                	addiw	s7,s7,-1
    80006a24:	000b8663          	beqz	s7,80006a30 <statslock+0x16c>
  int tot = 0;
    80006a28:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006a2a:	8762                	mv	a4,s8
    int top = 0;
    80006a2c:	85e2                	mv	a1,s8
    80006a2e:	bf45                	j	800069de <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006a30:	86d2                	mv	a3,s4
    80006a32:	00002617          	auipc	a2,0x2
    80006a36:	eae60613          	addi	a2,a2,-338 # 800088e0 <digits+0xd0>
    80006a3a:	41bb05bb          	subw	a1,s6,s11
    80006a3e:	013a8533          	add	a0,s5,s3
    80006a42:	fffff097          	auipc	ra,0xfffff
    80006a46:	082080e7          	jalr	130(ra) # 80005ac4 <snprintf>
    80006a4a:	00ad8dbb          	addw	s11,s11,a0
  release(&lock_locks);  
    80006a4e:	00020517          	auipc	a0,0x20
    80006a52:	15a50513          	addi	a0,a0,346 # 80026ba8 <lock_locks>
    80006a56:	00000097          	auipc	ra,0x0
    80006a5a:	cfe080e7          	jalr	-770(ra) # 80006754 <release>
  return n;
}
    80006a5e:	856e                	mv	a0,s11
    80006a60:	70a6                	ld	ra,104(sp)
    80006a62:	7406                	ld	s0,96(sp)
    80006a64:	64e6                	ld	s1,88(sp)
    80006a66:	6946                	ld	s2,80(sp)
    80006a68:	69a6                	ld	s3,72(sp)
    80006a6a:	6a06                	ld	s4,64(sp)
    80006a6c:	7ae2                	ld	s5,56(sp)
    80006a6e:	7b42                	ld	s6,48(sp)
    80006a70:	7ba2                	ld	s7,40(sp)
    80006a72:	7c02                	ld	s8,32(sp)
    80006a74:	6ce2                	ld	s9,24(sp)
    80006a76:	6d42                	ld	s10,16(sp)
    80006a78:	6da2                	ld	s11,8(sp)
    80006a7a:	6165                	addi	sp,sp,112
    80006a7c:	8082                	ret
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
