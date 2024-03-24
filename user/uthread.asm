
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);

void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d9a78793          	addi	a5,a5,-614 # da0 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d8f73123          	sd	a5,-638(a4) # d90 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d8f72423          	sw	a5,-632(a4) # 2da0 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void) /* TODO */
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d6233303          	ld	t1,-670(t1) # d90 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb07>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f4080813          	addi	a6,a6,-192 # 8f80 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb07>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d3a58593          	addi	a1,a1,-710 # da0 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b9050513          	addi	a0,a0,-1136 # c00 <malloc+0xea>
  78:	00001097          	auipc	ra,0x1
  7c:	9e6080e7          	jalr	-1562(ra) # a5e <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	674080e7          	jalr	1652(ra) # 6f6 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ceb7bc23          	sd	a1,-776(a5) # d90 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64)&t->thread_context, (uint64)&next_thread->thread_context);
  a0:	0521                	addi	a0,a0,8 # 2008 <__global_pointer$+0xa97>
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	360080e7          	jalr	864(ra) # 406 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)()) /* TODO */
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {  /* allocate free thread */
  bc:	00001797          	auipc	a5,0x1
  c0:	ce478793          	addi	a5,a5,-796 # da0 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {  /* allocate free thread */
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb07>
  ca:	00009617          	auipc	a2,0x9
  ce:	eb660613          	addi	a2,a2,-330 # 8f80 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {  /* allocate free thread */
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	00e786b3          	add	a3,a5,a4
  e6:	4609                	li	a2,2
  e8:	c290                	sw	a2,0(a3)
  // YOUR CODE HERE

  /* func is a address that we should store in ra so that we can use thread_scheduler
    to switch context
  */
  t->thread_context.ra = (uint64)func;
  ea:	e688                	sd	a0,8(a3)
  /* we should allocate page for thread stack */
  t->thread_context.sp = (uint64)&t->stack[STACK_SIZE - 1];
  ec:	177d                	addi	a4,a4,-1 # 1fff <__global_pointer$+0xa8e>
  ee:	97ba                	add	a5,a5,a4
  f0:	ea9c                	sd	a5,16(a3)
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <thread_yield>:

void 
thread_yield(void)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 100:	00001797          	auipc	a5,0x1
 104:	c907b783          	ld	a5,-880(a5) # d90 <current_thread>
 108:	6709                	lui	a4,0x2
 10a:	97ba                	add	a5,a5,a4
 10c:	4709                	li	a4,2
 10e:	c398                	sw	a4,0(a5)
  thread_schedule();
 110:	00000097          	auipc	ra,0x0
 114:	f16080e7          	jalr	-234(ra) # 26 <thread_schedule>
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 120:	7179                	addi	sp,sp,-48
 122:	f406                	sd	ra,40(sp)
 124:	f022                	sd	s0,32(sp)
 126:	ec26                	sd	s1,24(sp)
 128:	e84a                	sd	s2,16(sp)
 12a:	e44e                	sd	s3,8(sp)
 12c:	e052                	sd	s4,0(sp)
 12e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 130:	00001517          	auipc	a0,0x1
 134:	af850513          	addi	a0,a0,-1288 # c28 <malloc+0x112>
 138:	00001097          	auipc	ra,0x1
 13c:	926080e7          	jalr	-1754(ra) # a5e <printf>
  a_started = 1;
 140:	4785                	li	a5,1
 142:	00001717          	auipc	a4,0x1
 146:	c4f72523          	sw	a5,-950(a4) # d8c <a_started>
  while(b_started == 0 || c_started == 0)
 14a:	00001497          	auipc	s1,0x1
 14e:	c3e48493          	addi	s1,s1,-962 # d88 <b_started>
 152:	00001917          	auipc	s2,0x1
 156:	c3290913          	addi	s2,s2,-974 # d84 <c_started>
 15a:	a029                	j	164 <thread_a+0x44>
    thread_yield();
 15c:	00000097          	auipc	ra,0x0
 160:	f9c080e7          	jalr	-100(ra) # f8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 164:	409c                	lw	a5,0(s1)
 166:	2781                	sext.w	a5,a5
 168:	dbf5                	beqz	a5,15c <thread_a+0x3c>
 16a:	00092783          	lw	a5,0(s2)
 16e:	2781                	sext.w	a5,a5
 170:	d7f5                	beqz	a5,15c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 172:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 174:	00001a17          	auipc	s4,0x1
 178:	acca0a13          	addi	s4,s4,-1332 # c40 <malloc+0x12a>
    a_n += 1;
 17c:	00001917          	auipc	s2,0x1
 180:	c0490913          	addi	s2,s2,-1020 # d80 <a_n>
  for (i = 0; i < 100; i++) {
 184:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 188:	85a6                	mv	a1,s1
 18a:	8552                	mv	a0,s4
 18c:	00001097          	auipc	ra,0x1
 190:	8d2080e7          	jalr	-1838(ra) # a5e <printf>
    a_n += 1;
 194:	00092783          	lw	a5,0(s2)
 198:	2785                	addiw	a5,a5,1
 19a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f5a080e7          	jalr	-166(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a6:	2485                	addiw	s1,s1,1
 1a8:	ff3490e3          	bne	s1,s3,188 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1ac:	00001597          	auipc	a1,0x1
 1b0:	bd45a583          	lw	a1,-1068(a1) # d80 <a_n>
 1b4:	00001517          	auipc	a0,0x1
 1b8:	a9c50513          	addi	a0,a0,-1380 # c50 <malloc+0x13a>
 1bc:	00001097          	auipc	ra,0x1
 1c0:	8a2080e7          	jalr	-1886(ra) # a5e <printf>

  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	bcc7b783          	ld	a5,-1076(a5) # d90 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e52080e7          	jalr	-430(ra) # 26 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6a02                	ld	s4,0(sp)
 1e8:	6145                	addi	sp,sp,48
 1ea:	8082                	ret

00000000000001ec <thread_b>:

void 
thread_b(void)
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fc:	00001517          	auipc	a0,0x1
 200:	a7450513          	addi	a0,a0,-1420 # c70 <malloc+0x15a>
 204:	00001097          	auipc	ra,0x1
 208:	85a080e7          	jalr	-1958(ra) # a5e <printf>
  b_started = 1;
 20c:	4785                	li	a5,1
 20e:	00001717          	auipc	a4,0x1
 212:	b6f72d23          	sw	a5,-1158(a4) # d88 <b_started>
  while(a_started == 0 || c_started == 0)
 216:	00001497          	auipc	s1,0x1
 21a:	b7648493          	addi	s1,s1,-1162 # d8c <a_started>
 21e:	00001917          	auipc	s2,0x1
 222:	b6690913          	addi	s2,s2,-1178 # d84 <c_started>
 226:	a029                	j	230 <thread_b+0x44>
    thread_yield();
 228:	00000097          	auipc	ra,0x0
 22c:	ed0080e7          	jalr	-304(ra) # f8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 230:	409c                	lw	a5,0(s1)
 232:	2781                	sext.w	a5,a5
 234:	dbf5                	beqz	a5,228 <thread_b+0x3c>
 236:	00092783          	lw	a5,0(s2)
 23a:	2781                	sext.w	a5,a5
 23c:	d7f5                	beqz	a5,228 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 240:	00001a17          	auipc	s4,0x1
 244:	a48a0a13          	addi	s4,s4,-1464 # c88 <malloc+0x172>
    b_n += 1;
 248:	00001917          	auipc	s2,0x1
 24c:	b3490913          	addi	s2,s2,-1228 # d7c <b_n>
  for (i = 0; i < 100; i++) {
 250:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 254:	85a6                	mv	a1,s1
 256:	8552                	mv	a0,s4
 258:	00001097          	auipc	ra,0x1
 25c:	806080e7          	jalr	-2042(ra) # a5e <printf>
    b_n += 1;
 260:	00092783          	lw	a5,0(s2)
 264:	2785                	addiw	a5,a5,1
 266:	00f92023          	sw	a5,0(s2)
    thread_yield();
 26a:	00000097          	auipc	ra,0x0
 26e:	e8e080e7          	jalr	-370(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 272:	2485                	addiw	s1,s1,1
 274:	ff3490e3          	bne	s1,s3,254 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 278:	00001597          	auipc	a1,0x1
 27c:	b045a583          	lw	a1,-1276(a1) # d7c <b_n>
 280:	00001517          	auipc	a0,0x1
 284:	a1850513          	addi	a0,a0,-1512 # c98 <malloc+0x182>
 288:	00000097          	auipc	ra,0x0
 28c:	7d6080e7          	jalr	2006(ra) # a5e <printf>

  current_thread->state = FREE;
 290:	00001797          	auipc	a5,0x1
 294:	b007b783          	ld	a5,-1280(a5) # d90 <current_thread>
 298:	6709                	lui	a4,0x2
 29a:	97ba                	add	a5,a5,a4
 29c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	d86080e7          	jalr	-634(ra) # 26 <thread_schedule>
}
 2a8:	70a2                	ld	ra,40(sp)
 2aa:	7402                	ld	s0,32(sp)
 2ac:	64e2                	ld	s1,24(sp)
 2ae:	6942                	ld	s2,16(sp)
 2b0:	69a2                	ld	s3,8(sp)
 2b2:	6a02                	ld	s4,0(sp)
 2b4:	6145                	addi	sp,sp,48
 2b6:	8082                	ret

00000000000002b8 <thread_c>:

void 
thread_c(void)
{
 2b8:	7179                	addi	sp,sp,-48
 2ba:	f406                	sd	ra,40(sp)
 2bc:	f022                	sd	s0,32(sp)
 2be:	ec26                	sd	s1,24(sp)
 2c0:	e84a                	sd	s2,16(sp)
 2c2:	e44e                	sd	s3,8(sp)
 2c4:	e052                	sd	s4,0(sp)
 2c6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	9f050513          	addi	a0,a0,-1552 # cb8 <malloc+0x1a2>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	78e080e7          	jalr	1934(ra) # a5e <printf>
  c_started = 1;
 2d8:	4785                	li	a5,1
 2da:	00001717          	auipc	a4,0x1
 2de:	aaf72523          	sw	a5,-1366(a4) # d84 <c_started>
  while(a_started == 0 || b_started == 0)
 2e2:	00001497          	auipc	s1,0x1
 2e6:	aaa48493          	addi	s1,s1,-1366 # d8c <a_started>
 2ea:	00001917          	auipc	s2,0x1
 2ee:	a9e90913          	addi	s2,s2,-1378 # d88 <b_started>
 2f2:	a029                	j	2fc <thread_c+0x44>
    thread_yield();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	e04080e7          	jalr	-508(ra) # f8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fc:	409c                	lw	a5,0(s1)
 2fe:	2781                	sext.w	a5,a5
 300:	dbf5                	beqz	a5,2f4 <thread_c+0x3c>
 302:	00092783          	lw	a5,0(s2)
 306:	2781                	sext.w	a5,a5
 308:	d7f5                	beqz	a5,2f4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 30a:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30c:	00001a17          	auipc	s4,0x1
 310:	9c4a0a13          	addi	s4,s4,-1596 # cd0 <malloc+0x1ba>
    c_n += 1;
 314:	00001917          	auipc	s2,0x1
 318:	a6490913          	addi	s2,s2,-1436 # d78 <c_n>
  for (i = 0; i < 100; i++) {
 31c:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 320:	85a6                	mv	a1,s1
 322:	8552                	mv	a0,s4
 324:	00000097          	auipc	ra,0x0
 328:	73a080e7          	jalr	1850(ra) # a5e <printf>
    c_n += 1;
 32c:	00092783          	lw	a5,0(s2)
 330:	2785                	addiw	a5,a5,1
 332:	00f92023          	sw	a5,0(s2)
    thread_yield();
 336:	00000097          	auipc	ra,0x0
 33a:	dc2080e7          	jalr	-574(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 33e:	2485                	addiw	s1,s1,1
 340:	ff3490e3          	bne	s1,s3,320 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 344:	00001597          	auipc	a1,0x1
 348:	a345a583          	lw	a1,-1484(a1) # d78 <c_n>
 34c:	00001517          	auipc	a0,0x1
 350:	99450513          	addi	a0,a0,-1644 # ce0 <malloc+0x1ca>
 354:	00000097          	auipc	ra,0x0
 358:	70a080e7          	jalr	1802(ra) # a5e <printf>

  current_thread->state = FREE;
 35c:	00001797          	auipc	a5,0x1
 360:	a347b783          	ld	a5,-1484(a5) # d90 <current_thread>
 364:	6709                	lui	a4,0x2
 366:	97ba                	add	a5,a5,a4
 368:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 36c:	00000097          	auipc	ra,0x0
 370:	cba080e7          	jalr	-838(ra) # 26 <thread_schedule>
}
 374:	70a2                	ld	ra,40(sp)
 376:	7402                	ld	s0,32(sp)
 378:	64e2                	ld	s1,24(sp)
 37a:	6942                	ld	s2,16(sp)
 37c:	69a2                	ld	s3,8(sp)
 37e:	6a02                	ld	s4,0(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

0000000000000384 <main>:

int 
main(int argc, char *argv[]) 
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 38c:	00001797          	auipc	a5,0x1
 390:	9e07ac23          	sw	zero,-1544(a5) # d84 <c_started>
 394:	00001797          	auipc	a5,0x1
 398:	9e07aa23          	sw	zero,-1548(a5) # d88 <b_started>
 39c:	00001797          	auipc	a5,0x1
 3a0:	9e07a823          	sw	zero,-1552(a5) # d8c <a_started>
  a_n = b_n = c_n = 0;
 3a4:	00001797          	auipc	a5,0x1
 3a8:	9c07aa23          	sw	zero,-1580(a5) # d78 <c_n>
 3ac:	00001797          	auipc	a5,0x1
 3b0:	9c07a823          	sw	zero,-1584(a5) # d7c <b_n>
 3b4:	00001797          	auipc	a5,0x1
 3b8:	9c07a623          	sw	zero,-1588(a5) # d80 <a_n>
  thread_init();
 3bc:	00000097          	auipc	ra,0x0
 3c0:	c44080e7          	jalr	-956(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	d5c50513          	addi	a0,a0,-676 # 120 <thread_a>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cea080e7          	jalr	-790(ra) # b6 <thread_create>
  thread_create(thread_b);
 3d4:	00000517          	auipc	a0,0x0
 3d8:	e1850513          	addi	a0,a0,-488 # 1ec <thread_b>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	cda080e7          	jalr	-806(ra) # b6 <thread_create>
  thread_create(thread_c);
 3e4:	00000517          	auipc	a0,0x0
 3e8:	ed450513          	addi	a0,a0,-300 # 2b8 <thread_c>
 3ec:	00000097          	auipc	ra,0x0
 3f0:	cca080e7          	jalr	-822(ra) # b6 <thread_create>
  thread_schedule();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	c32080e7          	jalr	-974(ra) # 26 <thread_schedule>
  exit(0);
 3fc:	4501                	li	a0,0
 3fe:	00000097          	auipc	ra,0x0
 402:	2f8080e7          	jalr	760(ra) # 6f6 <exit>

0000000000000406 <thread_switch>:
	.globl thread_switch
thread_switch: /* TODO */
	/* YOUR CODE HERE */

	/* save callee registers */
	sd ra, 0(a0)
 406:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
 40a:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
 40e:	e900                	sd	s0,16(a0)
    sd s1, 24(a0)
 410:	ed04                	sd	s1,24(a0)
    sd s2, 32(a0)
 412:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 416:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 41a:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 41e:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 422:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 426:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 42a:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 42e:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 432:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 436:	07b53423          	sd	s11,104(a0)

    ld ra, 0(a1)
 43a:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
 43e:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
 442:	6980                	ld	s0,16(a1)
    ld s1, 24(a1)
 444:	6d84                	ld	s1,24(a1)
    ld s2, 32(a1)
 446:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 44a:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 44e:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 452:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 456:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 45a:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 45e:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 462:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 466:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 46a:	0685bd83          	ld	s11,104(a1)
        

	ret    /* return to ra */
 46e:	8082                	ret

0000000000000470 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  extern int main();
  main();
 478:	00000097          	auipc	ra,0x0
 47c:	f0c080e7          	jalr	-244(ra) # 384 <main>
  exit(0);
 480:	4501                	li	a0,0
 482:	00000097          	auipc	ra,0x0
 486:	274080e7          	jalr	628(ra) # 6f6 <exit>

000000000000048a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 490:	87aa                	mv	a5,a0
 492:	0585                	addi	a1,a1,1
 494:	0785                	addi	a5,a5,1
 496:	fff5c703          	lbu	a4,-1(a1)
 49a:	fee78fa3          	sb	a4,-1(a5)
 49e:	fb75                	bnez	a4,492 <strcpy+0x8>
    ;
  return os;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	cb91                	beqz	a5,4c4 <strcmp+0x1e>
 4b2:	0005c703          	lbu	a4,0(a1)
 4b6:	00f71763          	bne	a4,a5,4c4 <strcmp+0x1e>
    p++, q++;
 4ba:	0505                	addi	a0,a0,1
 4bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	fbe5                	bnez	a5,4b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4c4:	0005c503          	lbu	a0,0(a1)
}
 4c8:	40a7853b          	subw	a0,a5,a0
 4cc:	6422                	ld	s0,8(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret

00000000000004d2 <strlen>:

uint
strlen(const char *s)
{
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e422                	sd	s0,8(sp)
 4d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	cf91                	beqz	a5,4f8 <strlen+0x26>
 4de:	0505                	addi	a0,a0,1
 4e0:	87aa                	mv	a5,a0
 4e2:	86be                	mv	a3,a5
 4e4:	0785                	addi	a5,a5,1
 4e6:	fff7c703          	lbu	a4,-1(a5)
 4ea:	ff65                	bnez	a4,4e2 <strlen+0x10>
 4ec:	40a6853b          	subw	a0,a3,a0
 4f0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4f2:	6422                	ld	s0,8(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
  for(n = 0; s[n]; n++)
 4f8:	4501                	li	a0,0
 4fa:	bfe5                	j	4f2 <strlen+0x20>

00000000000004fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e422                	sd	s0,8(sp)
 500:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 502:	ca19                	beqz	a2,518 <memset+0x1c>
 504:	87aa                	mv	a5,a0
 506:	1602                	slli	a2,a2,0x20
 508:	9201                	srli	a2,a2,0x20
 50a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 50e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 512:	0785                	addi	a5,a5,1
 514:	fee79de3          	bne	a5,a4,50e <memset+0x12>
  }
  return dst;
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret

000000000000051e <strchr>:

char*
strchr(const char *s, char c)
{
 51e:	1141                	addi	sp,sp,-16
 520:	e422                	sd	s0,8(sp)
 522:	0800                	addi	s0,sp,16
  for(; *s; s++)
 524:	00054783          	lbu	a5,0(a0)
 528:	cb99                	beqz	a5,53e <strchr+0x20>
    if(*s == c)
 52a:	00f58763          	beq	a1,a5,538 <strchr+0x1a>
  for(; *s; s++)
 52e:	0505                	addi	a0,a0,1
 530:	00054783          	lbu	a5,0(a0)
 534:	fbfd                	bnez	a5,52a <strchr+0xc>
      return (char*)s;
  return 0;
 536:	4501                	li	a0,0
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret
  return 0;
 53e:	4501                	li	a0,0
 540:	bfe5                	j	538 <strchr+0x1a>

0000000000000542 <gets>:

char*
gets(char *buf, int max)
{
 542:	711d                	addi	sp,sp,-96
 544:	ec86                	sd	ra,88(sp)
 546:	e8a2                	sd	s0,80(sp)
 548:	e4a6                	sd	s1,72(sp)
 54a:	e0ca                	sd	s2,64(sp)
 54c:	fc4e                	sd	s3,56(sp)
 54e:	f852                	sd	s4,48(sp)
 550:	f456                	sd	s5,40(sp)
 552:	f05a                	sd	s6,32(sp)
 554:	ec5e                	sd	s7,24(sp)
 556:	1080                	addi	s0,sp,96
 558:	8baa                	mv	s7,a0
 55a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 55c:	892a                	mv	s2,a0
 55e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 560:	4aa9                	li	s5,10
 562:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 564:	89a6                	mv	s3,s1
 566:	2485                	addiw	s1,s1,1
 568:	0344d863          	bge	s1,s4,598 <gets+0x56>
    cc = read(0, &c, 1);
 56c:	4605                	li	a2,1
 56e:	faf40593          	addi	a1,s0,-81
 572:	4501                	li	a0,0
 574:	00000097          	auipc	ra,0x0
 578:	19a080e7          	jalr	410(ra) # 70e <read>
    if(cc < 1)
 57c:	00a05e63          	blez	a0,598 <gets+0x56>
    buf[i++] = c;
 580:	faf44783          	lbu	a5,-81(s0)
 584:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 588:	01578763          	beq	a5,s5,596 <gets+0x54>
 58c:	0905                	addi	s2,s2,1
 58e:	fd679be3          	bne	a5,s6,564 <gets+0x22>
  for(i=0; i+1 < max; ){
 592:	89a6                	mv	s3,s1
 594:	a011                	j	598 <gets+0x56>
 596:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 598:	99de                	add	s3,s3,s7
 59a:	00098023          	sb	zero,0(s3)
  return buf;
}
 59e:	855e                	mv	a0,s7
 5a0:	60e6                	ld	ra,88(sp)
 5a2:	6446                	ld	s0,80(sp)
 5a4:	64a6                	ld	s1,72(sp)
 5a6:	6906                	ld	s2,64(sp)
 5a8:	79e2                	ld	s3,56(sp)
 5aa:	7a42                	ld	s4,48(sp)
 5ac:	7aa2                	ld	s5,40(sp)
 5ae:	7b02                	ld	s6,32(sp)
 5b0:	6be2                	ld	s7,24(sp)
 5b2:	6125                	addi	sp,sp,96
 5b4:	8082                	ret

00000000000005b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 5b6:	1101                	addi	sp,sp,-32
 5b8:	ec06                	sd	ra,24(sp)
 5ba:	e822                	sd	s0,16(sp)
 5bc:	e426                	sd	s1,8(sp)
 5be:	e04a                	sd	s2,0(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c4:	4581                	li	a1,0
 5c6:	00000097          	auipc	ra,0x0
 5ca:	170080e7          	jalr	368(ra) # 736 <open>
  if(fd < 0)
 5ce:	02054563          	bltz	a0,5f8 <stat+0x42>
 5d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5d4:	85ca                	mv	a1,s2
 5d6:	00000097          	auipc	ra,0x0
 5da:	178080e7          	jalr	376(ra) # 74e <fstat>
 5de:	892a                	mv	s2,a0
  close(fd);
 5e0:	8526                	mv	a0,s1
 5e2:	00000097          	auipc	ra,0x0
 5e6:	13c080e7          	jalr	316(ra) # 71e <close>
  return r;
}
 5ea:	854a                	mv	a0,s2
 5ec:	60e2                	ld	ra,24(sp)
 5ee:	6442                	ld	s0,16(sp)
 5f0:	64a2                	ld	s1,8(sp)
 5f2:	6902                	ld	s2,0(sp)
 5f4:	6105                	addi	sp,sp,32
 5f6:	8082                	ret
    return -1;
 5f8:	597d                	li	s2,-1
 5fa:	bfc5                	j	5ea <stat+0x34>

00000000000005fc <atoi>:

int
atoi(const char *s)
{
 5fc:	1141                	addi	sp,sp,-16
 5fe:	e422                	sd	s0,8(sp)
 600:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 602:	00054683          	lbu	a3,0(a0)
 606:	fd06879b          	addiw	a5,a3,-48
 60a:	0ff7f793          	zext.b	a5,a5
 60e:	4625                	li	a2,9
 610:	02f66863          	bltu	a2,a5,640 <atoi+0x44>
 614:	872a                	mv	a4,a0
  n = 0;
 616:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 618:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xa90>
 61a:	0025179b          	slliw	a5,a0,0x2
 61e:	9fa9                	addw	a5,a5,a0
 620:	0017979b          	slliw	a5,a5,0x1
 624:	9fb5                	addw	a5,a5,a3
 626:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 62a:	00074683          	lbu	a3,0(a4)
 62e:	fd06879b          	addiw	a5,a3,-48
 632:	0ff7f793          	zext.b	a5,a5
 636:	fef671e3          	bgeu	a2,a5,618 <atoi+0x1c>
  return n;
}
 63a:	6422                	ld	s0,8(sp)
 63c:	0141                	addi	sp,sp,16
 63e:	8082                	ret
  n = 0;
 640:	4501                	li	a0,0
 642:	bfe5                	j	63a <atoi+0x3e>

0000000000000644 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 644:	1141                	addi	sp,sp,-16
 646:	e422                	sd	s0,8(sp)
 648:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 64a:	02b57463          	bgeu	a0,a1,672 <memmove+0x2e>
    while(n-- > 0)
 64e:	00c05f63          	blez	a2,66c <memmove+0x28>
 652:	1602                	slli	a2,a2,0x20
 654:	9201                	srli	a2,a2,0x20
 656:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 65a:	872a                	mv	a4,a0
      *dst++ = *src++;
 65c:	0585                	addi	a1,a1,1
 65e:	0705                	addi	a4,a4,1
 660:	fff5c683          	lbu	a3,-1(a1)
 664:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 668:	fee79ae3          	bne	a5,a4,65c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 66c:	6422                	ld	s0,8(sp)
 66e:	0141                	addi	sp,sp,16
 670:	8082                	ret
    dst += n;
 672:	00c50733          	add	a4,a0,a2
    src += n;
 676:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 678:	fec05ae3          	blez	a2,66c <memmove+0x28>
 67c:	fff6079b          	addiw	a5,a2,-1
 680:	1782                	slli	a5,a5,0x20
 682:	9381                	srli	a5,a5,0x20
 684:	fff7c793          	not	a5,a5
 688:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 68a:	15fd                	addi	a1,a1,-1
 68c:	177d                	addi	a4,a4,-1
 68e:	0005c683          	lbu	a3,0(a1)
 692:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 696:	fee79ae3          	bne	a5,a4,68a <memmove+0x46>
 69a:	bfc9                	j	66c <memmove+0x28>

000000000000069c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e422                	sd	s0,8(sp)
 6a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6a2:	ca05                	beqz	a2,6d2 <memcmp+0x36>
 6a4:	fff6069b          	addiw	a3,a2,-1
 6a8:	1682                	slli	a3,a3,0x20
 6aa:	9281                	srli	a3,a3,0x20
 6ac:	0685                	addi	a3,a3,1
 6ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6b0:	00054783          	lbu	a5,0(a0)
 6b4:	0005c703          	lbu	a4,0(a1)
 6b8:	00e79863          	bne	a5,a4,6c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6bc:	0505                	addi	a0,a0,1
    p2++;
 6be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6c0:	fed518e3          	bne	a0,a3,6b0 <memcmp+0x14>
  }
  return 0;
 6c4:	4501                	li	a0,0
 6c6:	a019                	j	6cc <memcmp+0x30>
      return *p1 - *p2;
 6c8:	40e7853b          	subw	a0,a5,a4
}
 6cc:	6422                	ld	s0,8(sp)
 6ce:	0141                	addi	sp,sp,16
 6d0:	8082                	ret
  return 0;
 6d2:	4501                	li	a0,0
 6d4:	bfe5                	j	6cc <memcmp+0x30>

00000000000006d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e406                	sd	ra,8(sp)
 6da:	e022                	sd	s0,0(sp)
 6dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6de:	00000097          	auipc	ra,0x0
 6e2:	f66080e7          	jalr	-154(ra) # 644 <memmove>
}
 6e6:	60a2                	ld	ra,8(sp)
 6e8:	6402                	ld	s0,0(sp)
 6ea:	0141                	addi	sp,sp,16
 6ec:	8082                	ret

00000000000006ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ee:	4885                	li	a7,1
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6f6:	4889                	li	a7,2
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 6fe:	488d                	li	a7,3
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 706:	4891                	li	a7,4
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <read>:
.global read
read:
 li a7, SYS_read
 70e:	4895                	li	a7,5
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <write>:
.global write
write:
 li a7, SYS_write
 716:	48c1                	li	a7,16
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <close>:
.global close
close:
 li a7, SYS_close
 71e:	48d5                	li	a7,21
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <kill>:
.global kill
kill:
 li a7, SYS_kill
 726:	4899                	li	a7,6
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <exec>:
.global exec
exec:
 li a7, SYS_exec
 72e:	489d                	li	a7,7
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <open>:
.global open
open:
 li a7, SYS_open
 736:	48bd                	li	a7,15
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 73e:	48c5                	li	a7,17
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 746:	48c9                	li	a7,18
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 74e:	48a1                	li	a7,8
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <link>:
.global link
link:
 li a7, SYS_link
 756:	48cd                	li	a7,19
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 75e:	48d1                	li	a7,20
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 766:	48a5                	li	a7,9
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <dup>:
.global dup
dup:
 li a7, SYS_dup
 76e:	48a9                	li	a7,10
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 776:	48ad                	li	a7,11
 ecall
 778:	00000073          	ecall
 ret
 77c:	8082                	ret

000000000000077e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 77e:	48b1                	li	a7,12
 ecall
 780:	00000073          	ecall
 ret
 784:	8082                	ret

0000000000000786 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 786:	48b5                	li	a7,13
 ecall
 788:	00000073          	ecall
 ret
 78c:	8082                	ret

000000000000078e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 78e:	48b9                	li	a7,14
 ecall
 790:	00000073          	ecall
 ret
 794:	8082                	ret

0000000000000796 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 796:	1101                	addi	sp,sp,-32
 798:	ec06                	sd	ra,24(sp)
 79a:	e822                	sd	s0,16(sp)
 79c:	1000                	addi	s0,sp,32
 79e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7a2:	4605                	li	a2,1
 7a4:	fef40593          	addi	a1,s0,-17
 7a8:	00000097          	auipc	ra,0x0
 7ac:	f6e080e7          	jalr	-146(ra) # 716 <write>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6105                	addi	sp,sp,32
 7b6:	8082                	ret

00000000000007b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b8:	7139                	addi	sp,sp,-64
 7ba:	fc06                	sd	ra,56(sp)
 7bc:	f822                	sd	s0,48(sp)
 7be:	f426                	sd	s1,40(sp)
 7c0:	f04a                	sd	s2,32(sp)
 7c2:	ec4e                	sd	s3,24(sp)
 7c4:	0080                	addi	s0,sp,64
 7c6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7c8:	c299                	beqz	a3,7ce <printint+0x16>
 7ca:	0805c963          	bltz	a1,85c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ce:	2581                	sext.w	a1,a1
  neg = 0;
 7d0:	4881                	li	a7,0
 7d2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7d8:	2601                	sext.w	a2,a2
 7da:	00000517          	auipc	a0,0x0
 7de:	58650513          	addi	a0,a0,1414 # d60 <digits>
 7e2:	883a                	mv	a6,a4
 7e4:	2705                	addiw	a4,a4,1
 7e6:	02c5f7bb          	remuw	a5,a1,a2
 7ea:	1782                	slli	a5,a5,0x20
 7ec:	9381                	srli	a5,a5,0x20
 7ee:	97aa                	add	a5,a5,a0
 7f0:	0007c783          	lbu	a5,0(a5)
 7f4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7f8:	0005879b          	sext.w	a5,a1
 7fc:	02c5d5bb          	divuw	a1,a1,a2
 800:	0685                	addi	a3,a3,1
 802:	fec7f0e3          	bgeu	a5,a2,7e2 <printint+0x2a>
  if(neg)
 806:	00088c63          	beqz	a7,81e <printint+0x66>
    buf[i++] = '-';
 80a:	fd070793          	addi	a5,a4,-48
 80e:	00878733          	add	a4,a5,s0
 812:	02d00793          	li	a5,45
 816:	fef70823          	sb	a5,-16(a4)
 81a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 81e:	02e05863          	blez	a4,84e <printint+0x96>
 822:	fc040793          	addi	a5,s0,-64
 826:	00e78933          	add	s2,a5,a4
 82a:	fff78993          	addi	s3,a5,-1
 82e:	99ba                	add	s3,s3,a4
 830:	377d                	addiw	a4,a4,-1
 832:	1702                	slli	a4,a4,0x20
 834:	9301                	srli	a4,a4,0x20
 836:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 83a:	fff94583          	lbu	a1,-1(s2)
 83e:	8526                	mv	a0,s1
 840:	00000097          	auipc	ra,0x0
 844:	f56080e7          	jalr	-170(ra) # 796 <putc>
  while(--i >= 0)
 848:	197d                	addi	s2,s2,-1
 84a:	ff3918e3          	bne	s2,s3,83a <printint+0x82>
}
 84e:	70e2                	ld	ra,56(sp)
 850:	7442                	ld	s0,48(sp)
 852:	74a2                	ld	s1,40(sp)
 854:	7902                	ld	s2,32(sp)
 856:	69e2                	ld	s3,24(sp)
 858:	6121                	addi	sp,sp,64
 85a:	8082                	ret
    x = -xx;
 85c:	40b005bb          	negw	a1,a1
    neg = 1;
 860:	4885                	li	a7,1
    x = -xx;
 862:	bf85                	j	7d2 <printint+0x1a>

0000000000000864 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 864:	715d                	addi	sp,sp,-80
 866:	e486                	sd	ra,72(sp)
 868:	e0a2                	sd	s0,64(sp)
 86a:	fc26                	sd	s1,56(sp)
 86c:	f84a                	sd	s2,48(sp)
 86e:	f44e                	sd	s3,40(sp)
 870:	f052                	sd	s4,32(sp)
 872:	ec56                	sd	s5,24(sp)
 874:	e85a                	sd	s6,16(sp)
 876:	e45e                	sd	s7,8(sp)
 878:	e062                	sd	s8,0(sp)
 87a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 87c:	0005c903          	lbu	s2,0(a1)
 880:	18090c63          	beqz	s2,a18 <vprintf+0x1b4>
 884:	8aaa                	mv	s5,a0
 886:	8bb2                	mv	s7,a2
 888:	00158493          	addi	s1,a1,1
  state = 0;
 88c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 88e:	02500a13          	li	s4,37
 892:	4b55                	li	s6,21
 894:	a839                	j	8b2 <vprintf+0x4e>
        putc(fd, c);
 896:	85ca                	mv	a1,s2
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	efc080e7          	jalr	-260(ra) # 796 <putc>
 8a2:	a019                	j	8a8 <vprintf+0x44>
    } else if(state == '%'){
 8a4:	01498d63          	beq	s3,s4,8be <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 8a8:	0485                	addi	s1,s1,1
 8aa:	fff4c903          	lbu	s2,-1(s1)
 8ae:	16090563          	beqz	s2,a18 <vprintf+0x1b4>
    if(state == 0){
 8b2:	fe0999e3          	bnez	s3,8a4 <vprintf+0x40>
      if(c == '%'){
 8b6:	ff4910e3          	bne	s2,s4,896 <vprintf+0x32>
        state = '%';
 8ba:	89d2                	mv	s3,s4
 8bc:	b7f5                	j	8a8 <vprintf+0x44>
      if(c == 'd'){
 8be:	13490263          	beq	s2,s4,9e2 <vprintf+0x17e>
 8c2:	f9d9079b          	addiw	a5,s2,-99
 8c6:	0ff7f793          	zext.b	a5,a5
 8ca:	12fb6563          	bltu	s6,a5,9f4 <vprintf+0x190>
 8ce:	f9d9079b          	addiw	a5,s2,-99
 8d2:	0ff7f713          	zext.b	a4,a5
 8d6:	10eb6f63          	bltu	s6,a4,9f4 <vprintf+0x190>
 8da:	00271793          	slli	a5,a4,0x2
 8de:	00000717          	auipc	a4,0x0
 8e2:	42a70713          	addi	a4,a4,1066 # d08 <malloc+0x1f2>
 8e6:	97ba                	add	a5,a5,a4
 8e8:	439c                	lw	a5,0(a5)
 8ea:	97ba                	add	a5,a5,a4
 8ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8ee:	008b8913          	addi	s2,s7,8
 8f2:	4685                	li	a3,1
 8f4:	4629                	li	a2,10
 8f6:	000ba583          	lw	a1,0(s7)
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	ebc080e7          	jalr	-324(ra) # 7b8 <printint>
 904:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 906:	4981                	li	s3,0
 908:	b745                	j	8a8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 90a:	008b8913          	addi	s2,s7,8
 90e:	4681                	li	a3,0
 910:	4629                	li	a2,10
 912:	000ba583          	lw	a1,0(s7)
 916:	8556                	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	ea0080e7          	jalr	-352(ra) # 7b8 <printint>
 920:	8bca                	mv	s7,s2
      state = 0;
 922:	4981                	li	s3,0
 924:	b751                	j	8a8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 926:	008b8913          	addi	s2,s7,8
 92a:	4681                	li	a3,0
 92c:	4641                	li	a2,16
 92e:	000ba583          	lw	a1,0(s7)
 932:	8556                	mv	a0,s5
 934:	00000097          	auipc	ra,0x0
 938:	e84080e7          	jalr	-380(ra) # 7b8 <printint>
 93c:	8bca                	mv	s7,s2
      state = 0;
 93e:	4981                	li	s3,0
 940:	b7a5                	j	8a8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 942:	008b8c13          	addi	s8,s7,8
 946:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 94a:	03000593          	li	a1,48
 94e:	8556                	mv	a0,s5
 950:	00000097          	auipc	ra,0x0
 954:	e46080e7          	jalr	-442(ra) # 796 <putc>
  putc(fd, 'x');
 958:	07800593          	li	a1,120
 95c:	8556                	mv	a0,s5
 95e:	00000097          	auipc	ra,0x0
 962:	e38080e7          	jalr	-456(ra) # 796 <putc>
 966:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 968:	00000b97          	auipc	s7,0x0
 96c:	3f8b8b93          	addi	s7,s7,1016 # d60 <digits>
 970:	03c9d793          	srli	a5,s3,0x3c
 974:	97de                	add	a5,a5,s7
 976:	0007c583          	lbu	a1,0(a5)
 97a:	8556                	mv	a0,s5
 97c:	00000097          	auipc	ra,0x0
 980:	e1a080e7          	jalr	-486(ra) # 796 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 984:	0992                	slli	s3,s3,0x4
 986:	397d                	addiw	s2,s2,-1
 988:	fe0914e3          	bnez	s2,970 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 98c:	8be2                	mv	s7,s8
      state = 0;
 98e:	4981                	li	s3,0
 990:	bf21                	j	8a8 <vprintf+0x44>
        s = va_arg(ap, char*);
 992:	008b8993          	addi	s3,s7,8
 996:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 99a:	02090163          	beqz	s2,9bc <vprintf+0x158>
        while(*s != 0){
 99e:	00094583          	lbu	a1,0(s2)
 9a2:	c9a5                	beqz	a1,a12 <vprintf+0x1ae>
          putc(fd, *s);
 9a4:	8556                	mv	a0,s5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	df0080e7          	jalr	-528(ra) # 796 <putc>
          s++;
 9ae:	0905                	addi	s2,s2,1
        while(*s != 0){
 9b0:	00094583          	lbu	a1,0(s2)
 9b4:	f9e5                	bnez	a1,9a4 <vprintf+0x140>
        s = va_arg(ap, char*);
 9b6:	8bce                	mv	s7,s3
      state = 0;
 9b8:	4981                	li	s3,0
 9ba:	b5fd                	j	8a8 <vprintf+0x44>
          s = "(null)";
 9bc:	00000917          	auipc	s2,0x0
 9c0:	34490913          	addi	s2,s2,836 # d00 <malloc+0x1ea>
        while(*s != 0){
 9c4:	02800593          	li	a1,40
 9c8:	bff1                	j	9a4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 9ca:	008b8913          	addi	s2,s7,8
 9ce:	000bc583          	lbu	a1,0(s7)
 9d2:	8556                	mv	a0,s5
 9d4:	00000097          	auipc	ra,0x0
 9d8:	dc2080e7          	jalr	-574(ra) # 796 <putc>
 9dc:	8bca                	mv	s7,s2
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	b5e1                	j	8a8 <vprintf+0x44>
        putc(fd, c);
 9e2:	02500593          	li	a1,37
 9e6:	8556                	mv	a0,s5
 9e8:	00000097          	auipc	ra,0x0
 9ec:	dae080e7          	jalr	-594(ra) # 796 <putc>
      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	bd5d                	j	8a8 <vprintf+0x44>
        putc(fd, '%');
 9f4:	02500593          	li	a1,37
 9f8:	8556                	mv	a0,s5
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d9c080e7          	jalr	-612(ra) # 796 <putc>
        putc(fd, c);
 a02:	85ca                	mv	a1,s2
 a04:	8556                	mv	a0,s5
 a06:	00000097          	auipc	ra,0x0
 a0a:	d90080e7          	jalr	-624(ra) # 796 <putc>
      state = 0;
 a0e:	4981                	li	s3,0
 a10:	bd61                	j	8a8 <vprintf+0x44>
        s = va_arg(ap, char*);
 a12:	8bce                	mv	s7,s3
      state = 0;
 a14:	4981                	li	s3,0
 a16:	bd49                	j	8a8 <vprintf+0x44>
    }
  }
}
 a18:	60a6                	ld	ra,72(sp)
 a1a:	6406                	ld	s0,64(sp)
 a1c:	74e2                	ld	s1,56(sp)
 a1e:	7942                	ld	s2,48(sp)
 a20:	79a2                	ld	s3,40(sp)
 a22:	7a02                	ld	s4,32(sp)
 a24:	6ae2                	ld	s5,24(sp)
 a26:	6b42                	ld	s6,16(sp)
 a28:	6ba2                	ld	s7,8(sp)
 a2a:	6c02                	ld	s8,0(sp)
 a2c:	6161                	addi	sp,sp,80
 a2e:	8082                	ret

0000000000000a30 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a30:	715d                	addi	sp,sp,-80
 a32:	ec06                	sd	ra,24(sp)
 a34:	e822                	sd	s0,16(sp)
 a36:	1000                	addi	s0,sp,32
 a38:	e010                	sd	a2,0(s0)
 a3a:	e414                	sd	a3,8(s0)
 a3c:	e818                	sd	a4,16(s0)
 a3e:	ec1c                	sd	a5,24(s0)
 a40:	03043023          	sd	a6,32(s0)
 a44:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a48:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a4c:	8622                	mv	a2,s0
 a4e:	00000097          	auipc	ra,0x0
 a52:	e16080e7          	jalr	-490(ra) # 864 <vprintf>
}
 a56:	60e2                	ld	ra,24(sp)
 a58:	6442                	ld	s0,16(sp)
 a5a:	6161                	addi	sp,sp,80
 a5c:	8082                	ret

0000000000000a5e <printf>:

void
printf(const char *fmt, ...)
{
 a5e:	711d                	addi	sp,sp,-96
 a60:	ec06                	sd	ra,24(sp)
 a62:	e822                	sd	s0,16(sp)
 a64:	1000                	addi	s0,sp,32
 a66:	e40c                	sd	a1,8(s0)
 a68:	e810                	sd	a2,16(s0)
 a6a:	ec14                	sd	a3,24(s0)
 a6c:	f018                	sd	a4,32(s0)
 a6e:	f41c                	sd	a5,40(s0)
 a70:	03043823          	sd	a6,48(s0)
 a74:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a78:	00840613          	addi	a2,s0,8
 a7c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a80:	85aa                	mv	a1,a0
 a82:	4505                	li	a0,1
 a84:	00000097          	auipc	ra,0x0
 a88:	de0080e7          	jalr	-544(ra) # 864 <vprintf>
}
 a8c:	60e2                	ld	ra,24(sp)
 a8e:	6442                	ld	s0,16(sp)
 a90:	6125                	addi	sp,sp,96
 a92:	8082                	ret

0000000000000a94 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a94:	1141                	addi	sp,sp,-16
 a96:	e422                	sd	s0,8(sp)
 a98:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a9a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9e:	00000797          	auipc	a5,0x0
 aa2:	2fa7b783          	ld	a5,762(a5) # d98 <freep>
 aa6:	a02d                	j	ad0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa8:	4618                	lw	a4,8(a2)
 aaa:	9f2d                	addw	a4,a4,a1
 aac:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab0:	6398                	ld	a4,0(a5)
 ab2:	6310                	ld	a2,0(a4)
 ab4:	a83d                	j	af2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab6:	ff852703          	lw	a4,-8(a0)
 aba:	9f31                	addw	a4,a4,a2
 abc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 abe:	ff053683          	ld	a3,-16(a0)
 ac2:	a091                	j	b06 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac4:	6398                	ld	a4,0(a5)
 ac6:	00e7e463          	bltu	a5,a4,ace <free+0x3a>
 aca:	00e6ea63          	bltu	a3,a4,ade <free+0x4a>
{
 ace:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad0:	fed7fae3          	bgeu	a5,a3,ac4 <free+0x30>
 ad4:	6398                	ld	a4,0(a5)
 ad6:	00e6e463          	bltu	a3,a4,ade <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ada:	fee7eae3          	bltu	a5,a4,ace <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ade:	ff852583          	lw	a1,-8(a0)
 ae2:	6390                	ld	a2,0(a5)
 ae4:	02059813          	slli	a6,a1,0x20
 ae8:	01c85713          	srli	a4,a6,0x1c
 aec:	9736                	add	a4,a4,a3
 aee:	fae60de3          	beq	a2,a4,aa8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 af2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af6:	4790                	lw	a2,8(a5)
 af8:	02061593          	slli	a1,a2,0x20
 afc:	01c5d713          	srli	a4,a1,0x1c
 b00:	973e                	add	a4,a4,a5
 b02:	fae68ae3          	beq	a3,a4,ab6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b06:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b08:	00000717          	auipc	a4,0x0
 b0c:	28f73823          	sd	a5,656(a4) # d98 <freep>
}
 b10:	6422                	ld	s0,8(sp)
 b12:	0141                	addi	sp,sp,16
 b14:	8082                	ret

0000000000000b16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b16:	7139                	addi	sp,sp,-64
 b18:	fc06                	sd	ra,56(sp)
 b1a:	f822                	sd	s0,48(sp)
 b1c:	f426                	sd	s1,40(sp)
 b1e:	f04a                	sd	s2,32(sp)
 b20:	ec4e                	sd	s3,24(sp)
 b22:	e852                	sd	s4,16(sp)
 b24:	e456                	sd	s5,8(sp)
 b26:	e05a                	sd	s6,0(sp)
 b28:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2a:	02051493          	slli	s1,a0,0x20
 b2e:	9081                	srli	s1,s1,0x20
 b30:	04bd                	addi	s1,s1,15
 b32:	8091                	srli	s1,s1,0x4
 b34:	0014899b          	addiw	s3,s1,1
 b38:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b3a:	00000517          	auipc	a0,0x0
 b3e:	25e53503          	ld	a0,606(a0) # d98 <freep>
 b42:	c515                	beqz	a0,b6e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b46:	4798                	lw	a4,8(a5)
 b48:	02977f63          	bgeu	a4,s1,b86 <malloc+0x70>
  if(nu < 4096)
 b4c:	8a4e                	mv	s4,s3
 b4e:	0009871b          	sext.w	a4,s3
 b52:	6685                	lui	a3,0x1
 b54:	00d77363          	bgeu	a4,a3,b5a <malloc+0x44>
 b58:	6a05                	lui	s4,0x1
 b5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b5e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b62:	00000917          	auipc	s2,0x0
 b66:	23690913          	addi	s2,s2,566 # d98 <freep>
  if(p == (char*)-1)
 b6a:	5afd                	li	s5,-1
 b6c:	a895                	j	be0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b6e:	00008797          	auipc	a5,0x8
 b72:	41278793          	addi	a5,a5,1042 # 8f80 <base>
 b76:	00000717          	auipc	a4,0x0
 b7a:	22f73123          	sd	a5,546(a4) # d98 <freep>
 b7e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b84:	b7e1                	j	b4c <malloc+0x36>
      if(p->s.size == nunits)
 b86:	02e48c63          	beq	s1,a4,bbe <malloc+0xa8>
        p->s.size -= nunits;
 b8a:	4137073b          	subw	a4,a4,s3
 b8e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b90:	02071693          	slli	a3,a4,0x20
 b94:	01c6d713          	srli	a4,a3,0x1c
 b98:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b9a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b9e:	00000717          	auipc	a4,0x0
 ba2:	1ea73d23          	sd	a0,506(a4) # d98 <freep>
      return (void*)(p + 1);
 ba6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 baa:	70e2                	ld	ra,56(sp)
 bac:	7442                	ld	s0,48(sp)
 bae:	74a2                	ld	s1,40(sp)
 bb0:	7902                	ld	s2,32(sp)
 bb2:	69e2                	ld	s3,24(sp)
 bb4:	6a42                	ld	s4,16(sp)
 bb6:	6aa2                	ld	s5,8(sp)
 bb8:	6b02                	ld	s6,0(sp)
 bba:	6121                	addi	sp,sp,64
 bbc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bbe:	6398                	ld	a4,0(a5)
 bc0:	e118                	sd	a4,0(a0)
 bc2:	bff1                	j	b9e <malloc+0x88>
  hp->s.size = nu;
 bc4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc8:	0541                	addi	a0,a0,16
 bca:	00000097          	auipc	ra,0x0
 bce:	eca080e7          	jalr	-310(ra) # a94 <free>
  return freep;
 bd2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bd6:	d971                	beqz	a0,baa <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bda:	4798                	lw	a4,8(a5)
 bdc:	fa9775e3          	bgeu	a4,s1,b86 <malloc+0x70>
    if(p == freep)
 be0:	00093703          	ld	a4,0(s2)
 be4:	853e                	mv	a0,a5
 be6:	fef719e3          	bne	a4,a5,bd8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bea:	8552                	mv	a0,s4
 bec:	00000097          	auipc	ra,0x0
 bf0:	b92080e7          	jalr	-1134(ra) # 77e <sbrk>
  if(p == (char*)-1)
 bf4:	fd5518e3          	bne	a0,s5,bc4 <malloc+0xae>
        return 0;
 bf8:	4501                	li	a0,0
 bfa:	bf45                	j	baa <malloc+0x94>
