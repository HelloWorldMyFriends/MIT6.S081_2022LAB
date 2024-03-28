
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test3();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	00050513          	mv	a0,a0
  18:	00001097          	auipc	ra,0x1
  1c:	ba2080e7          	jalr	-1118(ra) # bba <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	fe850513          	addi	a0,a0,-24 # 1010 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	4ac080e7          	jalr	1196(ra) # 4dc <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	580080e7          	jalr	1408(ra) # 5ba <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	bea58593          	addi	a1,a1,-1046 # c40 <statistics+0x86>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	98e080e7          	jalr	-1650(ra) # 9ee <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	fa658593          	addi	a1,a1,-90 # 1010 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	bde50513          	addi	a0,a0,-1058 # c50 <statistics+0x96>
  7a:	00001097          	auipc	ra,0x1
  7e:	9a2080e7          	jalr	-1630(ra) # a1c <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

// Test concurrent kallocs and kfrees
void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	bc650513          	addi	a0,a0,-1082 # c58 <statistics+0x9e>
  9a:	00001097          	auipc	ra,0x1
  9e:	982080e7          	jalr	-1662(ra) # a1c <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	5fe080e7          	jalr	1534(ra) # 6ac <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	5f0080e7          	jalr	1520(ra) # 6ac <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	5f0080e7          	jalr	1520(ra) # 6bc <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	5e6080e7          	jalr	1510(ra) # 6bc <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	baa50513          	addi	a0,a0,-1110 # c88 <statistics+0xce>
  e6:	00001097          	auipc	ra,0x1
  ea:	936080e7          	jalr	-1738(ra) # a1c <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	b9850513          	addi	a0,a0,-1128 # c98 <statistics+0xde>
 108:	00001097          	auipc	ra,0x1
 10c:	914080e7          	jalr	-1772(ra) # a1c <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	b4a50513          	addi	a0,a0,-1206 # c68 <statistics+0xae>
 126:	00001097          	auipc	ra,0x1
 12a:	8f6080e7          	jalr	-1802(ra) # a1c <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	584080e7          	jalr	1412(ra) # 6b4 <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <base+0x16690>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	5fa080e7          	jalr	1530(ra) # 73c <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <freep+0x4>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	5ea080e7          	jalr	1514(ra) # 73c <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	54a080e7          	jalr	1354(ra) # 6b4 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	b0650513          	addi	a0,a0,-1274 # c78 <statistics+0xbe>
 17a:	00001097          	auipc	ra,0x1
 17e:	8a2080e7          	jalr	-1886(ra) # a1c <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	530080e7          	jalr	1328(ra) # 6b4 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	b1c50513          	addi	a0,a0,-1252 # ca8 <statistics+0xee>
 194:	00001097          	auipc	ra,0x1
 198:	888080e7          	jalr	-1912(ra) # a1c <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	58c080e7          	jalr	1420(ra) # 73c <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
 1c0:	a031                	j	1cc <countfree+0x2e>
 1c2:	6785                	lui	a5,0x1
 1c4:	97aa                	add	a5,a5,a0
 1c6:	ff378fa3          	sb	s3,-1(a5) # fff <digits+0x20f>
    n += 1;
 1ca:	2485                	addiw	s1,s1,1
    uint64 a = (uint64) sbrk(4096);
 1cc:	6505                	lui	a0,0x1
 1ce:	00000097          	auipc	ra,0x0
 1d2:	56e080e7          	jalr	1390(ra) # 73c <sbrk>
    if(a == 0xffffffffffffffff){
 1d6:	ff2516e3          	bne	a0,s2,1c2 <countfree+0x24>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	560080e7          	jalr	1376(ra) # 73c <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	554080e7          	jalr	1364(ra) # 73c <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

// Test stealing
void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	0880                	addi	s0,sp,80
  int free0 = countfree();
 218:	00000097          	auipc	ra,0x0
 21c:	f86080e7          	jalr	-122(ra) # 19e <countfree>
 220:	89aa                	mv	s3,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 222:	00001517          	auipc	a0,0x1
 226:	a9650513          	addi	a0,a0,-1386 # cb8 <statistics+0xfe>
 22a:	00000097          	auipc	ra,0x0
 22e:	7f2080e7          	jalr	2034(ra) # a1c <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 232:	6621                	lui	a2,0x8
 234:	85ce                	mv	a1,s3
 236:	00001517          	auipc	a0,0x1
 23a:	a9250513          	addi	a0,a0,-1390 # cc8 <statistics+0x10e>
 23e:	00000097          	auipc	ra,0x0
 242:	7de080e7          	jalr	2014(ra) # a1c <printf>
  if(n - free0 > 1000) {
 246:	67a1                	lui	a5,0x8
 248:	413787bb          	subw	a5,a5,s3
 24c:	3e800713          	li	a4,1000
 250:	00f74c63          	blt	a4,a5,268 <test2+0x66>
 254:	4481                	li	s1,0
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
    if(i % 10 == 9)
 256:	4b29                	li	s6,10
 258:	4aa5                	li	s5,9
      printf(".");
 25a:	00001b97          	auipc	s7,0x1
 25e:	aceb8b93          	addi	s7,s7,-1330 # d28 <statistics+0x16e>
  for (int i = 0; i < 50; i++) {
 262:	03200a13          	li	s4,50
 266:	a01d                	j	28c <test2+0x8a>
    printf("test2 FAILED: cannot allocate enough memory");
 268:	00001517          	auipc	a0,0x1
 26c:	a9050513          	addi	a0,a0,-1392 # cf8 <statistics+0x13e>
 270:	00000097          	auipc	ra,0x0
 274:	7ac080e7          	jalr	1964(ra) # a1c <printf>
    exit(-1);
 278:	557d                	li	a0,-1
 27a:	00000097          	auipc	ra,0x0
 27e:	43a080e7          	jalr	1082(ra) # 6b4 <exit>
    if(free1 != free0) {
 282:	03299463          	bne	s3,s2,2aa <test2+0xa8>
  for (int i = 0; i < 50; i++) {
 286:	2485                	addiw	s1,s1,1
 288:	03448e63          	beq	s1,s4,2c4 <test2+0xc2>
    free1 = countfree();
 28c:	00000097          	auipc	ra,0x0
 290:	f12080e7          	jalr	-238(ra) # 19e <countfree>
 294:	892a                	mv	s2,a0
    if(i % 10 == 9)
 296:	0364e7bb          	remw	a5,s1,s6
 29a:	ff5794e3          	bne	a5,s5,282 <test2+0x80>
      printf(".");
 29e:	855e                	mv	a0,s7
 2a0:	00000097          	auipc	ra,0x0
 2a4:	77c080e7          	jalr	1916(ra) # a1c <printf>
 2a8:	bfe9                	j	282 <test2+0x80>
      printf("test2 FAIL: losing pages\n");
 2aa:	00001517          	auipc	a0,0x1
 2ae:	a8650513          	addi	a0,a0,-1402 # d30 <statistics+0x176>
 2b2:	00000097          	auipc	ra,0x0
 2b6:	76a080e7          	jalr	1898(ra) # a1c <printf>
      exit(-1);
 2ba:	557d                	li	a0,-1
 2bc:	00000097          	auipc	ra,0x0
 2c0:	3f8080e7          	jalr	1016(ra) # 6b4 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2c4:	00001517          	auipc	a0,0x1
 2c8:	a8c50513          	addi	a0,a0,-1396 # d50 <statistics+0x196>
 2cc:	00000097          	auipc	ra,0x0
 2d0:	750080e7          	jalr	1872(ra) # a1c <printf>
}
 2d4:	60a6                	ld	ra,72(sp)
 2d6:	6406                	ld	s0,64(sp)
 2d8:	74e2                	ld	s1,56(sp)
 2da:	7942                	ld	s2,48(sp)
 2dc:	79a2                	ld	s3,40(sp)
 2de:	7a02                	ld	s4,32(sp)
 2e0:	6ae2                	ld	s5,24(sp)
 2e2:	6b42                	ld	s6,16(sp)
 2e4:	6ba2                	ld	s7,8(sp)
 2e6:	6161                	addi	sp,sp,80
 2e8:	8082                	ret

00000000000002ea <test3>:

// Test concurrent kalloc/kfree and stealing
void test3(void)
{
 2ea:	7179                	addi	sp,sp,-48
 2ec:	f406                	sd	ra,40(sp)
 2ee:	f022                	sd	s0,32(sp)
 2f0:	ec26                	sd	s1,24(sp)
 2f2:	e84a                	sd	s2,16(sp)
 2f4:	e44e                	sd	s3,8(sp)
 2f6:	e052                	sd	s4,0(sp)
 2f8:	1800                	addi	s0,sp,48
  void *a, *a1;
  printf("start test3\n");  
 2fa:	00001517          	auipc	a0,0x1
 2fe:	a6650513          	addi	a0,a0,-1434 # d60 <statistics+0x1a6>
 302:	00000097          	auipc	ra,0x0
 306:	71a080e7          	jalr	1818(ra) # a1c <printf>
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
 30a:	00000097          	auipc	ra,0x0
 30e:	3a2080e7          	jalr	930(ra) # 6ac <fork>
    if(pid < 0){
 312:	04054963          	bltz	a0,364 <test3+0x7a>
 316:	892a                	mv	s2,a0
    }
    if(pid == 0){
      if (i == 0) {
        for(i = 0; i < N; i++) {
          a = sbrk(4096);
          *(int *)(a+4) = 1;
 318:	4a05                	li	s4,1
        for(i = 0; i < N; i++) {
 31a:	69e1                	lui	s3,0x18
 31c:	6a098993          	addi	s3,s3,1696 # 186a0 <base+0x16690>
    if(pid == 0){
 320:	cd39                	beqz	a0,37e <test3+0x94>
    int pid = fork();
 322:	00000097          	auipc	ra,0x0
 326:	38a080e7          	jalr	906(ra) # 6ac <fork>
    if(pid < 0){
 32a:	02054d63          	bltz	a0,364 <test3+0x7a>
    if(pid == 0){
 32e:	c94d                	beqz	a0,3e0 <test3+0xf6>
      }
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 330:	4501                	li	a0,0
 332:	00000097          	auipc	ra,0x0
 336:	38a080e7          	jalr	906(ra) # 6bc <wait>
 33a:	4501                	li	a0,0
 33c:	00000097          	auipc	ra,0x0
 340:	380080e7          	jalr	896(ra) # 6bc <wait>
  }
  printf("test3 OK\n");
 344:	00001517          	auipc	a0,0x1
 348:	a3c50513          	addi	a0,a0,-1476 # d80 <statistics+0x1c6>
 34c:	00000097          	auipc	ra,0x0
 350:	6d0080e7          	jalr	1744(ra) # a1c <printf>
}
 354:	70a2                	ld	ra,40(sp)
 356:	7402                	ld	s0,32(sp)
 358:	64e2                	ld	s1,24(sp)
 35a:	6942                	ld	s2,16(sp)
 35c:	69a2                	ld	s3,8(sp)
 35e:	6a02                	ld	s4,0(sp)
 360:	6145                	addi	sp,sp,48
 362:	8082                	ret
      printf("fork failed");
 364:	00001517          	auipc	a0,0x1
 368:	90450513          	addi	a0,a0,-1788 # c68 <statistics+0xae>
 36c:	00000097          	auipc	ra,0x0
 370:	6b0080e7          	jalr	1712(ra) # a1c <printf>
      exit(-1);
 374:	557d                	li	a0,-1
 376:	00000097          	auipc	ra,0x0
 37a:	33e080e7          	jalr	830(ra) # 6b4 <exit>
          a = sbrk(4096);
 37e:	6505                	lui	a0,0x1
 380:	00000097          	auipc	ra,0x0
 384:	3bc080e7          	jalr	956(ra) # 73c <sbrk>
 388:	84aa                	mv	s1,a0
          *(int *)(a+4) = 1;
 38a:	01452223          	sw	s4,4(a0) # 1004 <freep+0x4>
          a1 = sbrk(-4096);
 38e:	757d                	lui	a0,0xfffff
 390:	00000097          	auipc	ra,0x0
 394:	3ac080e7          	jalr	940(ra) # 73c <sbrk>
          if (a1 != a + 4096) {
 398:	6785                	lui	a5,0x1
 39a:	94be                	add	s1,s1,a5
 39c:	02951563          	bne	a0,s1,3c6 <test3+0xdc>
        for(i = 0; i < N; i++) {
 3a0:	2905                	addiw	s2,s2,1
 3a2:	fd391ee3          	bne	s2,s3,37e <test3+0x94>
        printf("child done %d\n", i);
 3a6:	65e1                	lui	a1,0x18
 3a8:	6a058593          	addi	a1,a1,1696 # 186a0 <base+0x16690>
 3ac:	00001517          	auipc	a0,0x1
 3b0:	9c450513          	addi	a0,a0,-1596 # d70 <statistics+0x1b6>
 3b4:	00000097          	auipc	ra,0x0
 3b8:	668080e7          	jalr	1640(ra) # a1c <printf>
        exit(0);
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	2f6080e7          	jalr	758(ra) # 6b4 <exit>
            printf("wrong sbrk\n");
 3c6:	00001517          	auipc	a0,0x1
 3ca:	8b250513          	addi	a0,a0,-1870 # c78 <statistics+0xbe>
 3ce:	00000097          	auipc	ra,0x0
 3d2:	64e080e7          	jalr	1614(ra) # a1c <printf>
            exit(-1);
 3d6:	557d                	li	a0,-1
 3d8:	00000097          	auipc	ra,0x0
 3dc:	2dc080e7          	jalr	732(ra) # 6b4 <exit>
        countfree();
 3e0:	00000097          	auipc	ra,0x0
 3e4:	dbe080e7          	jalr	-578(ra) # 19e <countfree>
        printf("child done %d\n", i);
 3e8:	4585                	li	a1,1
 3ea:	00001517          	auipc	a0,0x1
 3ee:	98650513          	addi	a0,a0,-1658 # d70 <statistics+0x1b6>
 3f2:	00000097          	auipc	ra,0x0
 3f6:	62a080e7          	jalr	1578(ra) # a1c <printf>
        exit(0);
 3fa:	4501                	li	a0,0
 3fc:	00000097          	auipc	ra,0x0
 400:	2b8080e7          	jalr	696(ra) # 6b4 <exit>

0000000000000404 <main>:
{
 404:	1141                	addi	sp,sp,-16
 406:	e406                	sd	ra,8(sp)
 408:	e022                	sd	s0,0(sp)
 40a:	0800                	addi	s0,sp,16
  test1();
 40c:	00000097          	auipc	ra,0x0
 410:	c78080e7          	jalr	-904(ra) # 84 <test1>
  test2();
 414:	00000097          	auipc	ra,0x0
 418:	dee080e7          	jalr	-530(ra) # 202 <test2>
  test3();
 41c:	00000097          	auipc	ra,0x0
 420:	ece080e7          	jalr	-306(ra) # 2ea <test3>
  exit(0);
 424:	4501                	li	a0,0
 426:	00000097          	auipc	ra,0x0
 42a:	28e080e7          	jalr	654(ra) # 6b4 <exit>

000000000000042e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 42e:	1141                	addi	sp,sp,-16
 430:	e406                	sd	ra,8(sp)
 432:	e022                	sd	s0,0(sp)
 434:	0800                	addi	s0,sp,16
  extern int main();
  main();
 436:	00000097          	auipc	ra,0x0
 43a:	fce080e7          	jalr	-50(ra) # 404 <main>
  exit(0);
 43e:	4501                	li	a0,0
 440:	00000097          	auipc	ra,0x0
 444:	274080e7          	jalr	628(ra) # 6b4 <exit>

0000000000000448 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 448:	1141                	addi	sp,sp,-16
 44a:	e422                	sd	s0,8(sp)
 44c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 44e:	87aa                	mv	a5,a0
 450:	0585                	addi	a1,a1,1
 452:	0785                	addi	a5,a5,1 # 1001 <freep+0x1>
 454:	fff5c703          	lbu	a4,-1(a1)
 458:	fee78fa3          	sb	a4,-1(a5)
 45c:	fb75                	bnez	a4,450 <strcpy+0x8>
    ;
  return os;
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret

0000000000000464 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 46a:	00054783          	lbu	a5,0(a0)
 46e:	cb91                	beqz	a5,482 <strcmp+0x1e>
 470:	0005c703          	lbu	a4,0(a1)
 474:	00f71763          	bne	a4,a5,482 <strcmp+0x1e>
    p++, q++;
 478:	0505                	addi	a0,a0,1
 47a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 47c:	00054783          	lbu	a5,0(a0)
 480:	fbe5                	bnez	a5,470 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 482:	0005c503          	lbu	a0,0(a1)
}
 486:	40a7853b          	subw	a0,a5,a0
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret

0000000000000490 <strlen>:

uint
strlen(const char *s)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 496:	00054783          	lbu	a5,0(a0)
 49a:	cf91                	beqz	a5,4b6 <strlen+0x26>
 49c:	0505                	addi	a0,a0,1
 49e:	87aa                	mv	a5,a0
 4a0:	86be                	mv	a3,a5
 4a2:	0785                	addi	a5,a5,1
 4a4:	fff7c703          	lbu	a4,-1(a5)
 4a8:	ff65                	bnez	a4,4a0 <strlen+0x10>
 4aa:	40a6853b          	subw	a0,a3,a0
 4ae:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4b0:	6422                	ld	s0,8(sp)
 4b2:	0141                	addi	sp,sp,16
 4b4:	8082                	ret
  for(n = 0; s[n]; n++)
 4b6:	4501                	li	a0,0
 4b8:	bfe5                	j	4b0 <strlen+0x20>

00000000000004ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4c0:	ca19                	beqz	a2,4d6 <memset+0x1c>
 4c2:	87aa                	mv	a5,a0
 4c4:	1602                	slli	a2,a2,0x20
 4c6:	9201                	srli	a2,a2,0x20
 4c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4d0:	0785                	addi	a5,a5,1
 4d2:	fee79de3          	bne	a5,a4,4cc <memset+0x12>
  }
  return dst;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret

00000000000004dc <strchr>:

char*
strchr(const char *s, char c)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4e2:	00054783          	lbu	a5,0(a0)
 4e6:	cb99                	beqz	a5,4fc <strchr+0x20>
    if(*s == c)
 4e8:	00f58763          	beq	a1,a5,4f6 <strchr+0x1a>
  for(; *s; s++)
 4ec:	0505                	addi	a0,a0,1
 4ee:	00054783          	lbu	a5,0(a0)
 4f2:	fbfd                	bnez	a5,4e8 <strchr+0xc>
      return (char*)s;
  return 0;
 4f4:	4501                	li	a0,0
}
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  return 0;
 4fc:	4501                	li	a0,0
 4fe:	bfe5                	j	4f6 <strchr+0x1a>

0000000000000500 <gets>:

char*
gets(char *buf, int max)
{
 500:	711d                	addi	sp,sp,-96
 502:	ec86                	sd	ra,88(sp)
 504:	e8a2                	sd	s0,80(sp)
 506:	e4a6                	sd	s1,72(sp)
 508:	e0ca                	sd	s2,64(sp)
 50a:	fc4e                	sd	s3,56(sp)
 50c:	f852                	sd	s4,48(sp)
 50e:	f456                	sd	s5,40(sp)
 510:	f05a                	sd	s6,32(sp)
 512:	ec5e                	sd	s7,24(sp)
 514:	1080                	addi	s0,sp,96
 516:	8baa                	mv	s7,a0
 518:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 51a:	892a                	mv	s2,a0
 51c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 51e:	4aa9                	li	s5,10
 520:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 522:	89a6                	mv	s3,s1
 524:	2485                	addiw	s1,s1,1
 526:	0344d863          	bge	s1,s4,556 <gets+0x56>
    cc = read(0, &c, 1);
 52a:	4605                	li	a2,1
 52c:	faf40593          	addi	a1,s0,-81
 530:	4501                	li	a0,0
 532:	00000097          	auipc	ra,0x0
 536:	19a080e7          	jalr	410(ra) # 6cc <read>
    if(cc < 1)
 53a:	00a05e63          	blez	a0,556 <gets+0x56>
    buf[i++] = c;
 53e:	faf44783          	lbu	a5,-81(s0)
 542:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 546:	01578763          	beq	a5,s5,554 <gets+0x54>
 54a:	0905                	addi	s2,s2,1
 54c:	fd679be3          	bne	a5,s6,522 <gets+0x22>
  for(i=0; i+1 < max; ){
 550:	89a6                	mv	s3,s1
 552:	a011                	j	556 <gets+0x56>
 554:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 556:	99de                	add	s3,s3,s7
 558:	00098023          	sb	zero,0(s3)
  return buf;
}
 55c:	855e                	mv	a0,s7
 55e:	60e6                	ld	ra,88(sp)
 560:	6446                	ld	s0,80(sp)
 562:	64a6                	ld	s1,72(sp)
 564:	6906                	ld	s2,64(sp)
 566:	79e2                	ld	s3,56(sp)
 568:	7a42                	ld	s4,48(sp)
 56a:	7aa2                	ld	s5,40(sp)
 56c:	7b02                	ld	s6,32(sp)
 56e:	6be2                	ld	s7,24(sp)
 570:	6125                	addi	sp,sp,96
 572:	8082                	ret

0000000000000574 <stat>:

int
stat(const char *n, struct stat *st)
{
 574:	1101                	addi	sp,sp,-32
 576:	ec06                	sd	ra,24(sp)
 578:	e822                	sd	s0,16(sp)
 57a:	e426                	sd	s1,8(sp)
 57c:	e04a                	sd	s2,0(sp)
 57e:	1000                	addi	s0,sp,32
 580:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 582:	4581                	li	a1,0
 584:	00000097          	auipc	ra,0x0
 588:	170080e7          	jalr	368(ra) # 6f4 <open>
  if(fd < 0)
 58c:	02054563          	bltz	a0,5b6 <stat+0x42>
 590:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 592:	85ca                	mv	a1,s2
 594:	00000097          	auipc	ra,0x0
 598:	178080e7          	jalr	376(ra) # 70c <fstat>
 59c:	892a                	mv	s2,a0
  close(fd);
 59e:	8526                	mv	a0,s1
 5a0:	00000097          	auipc	ra,0x0
 5a4:	13c080e7          	jalr	316(ra) # 6dc <close>
  return r;
}
 5a8:	854a                	mv	a0,s2
 5aa:	60e2                	ld	ra,24(sp)
 5ac:	6442                	ld	s0,16(sp)
 5ae:	64a2                	ld	s1,8(sp)
 5b0:	6902                	ld	s2,0(sp)
 5b2:	6105                	addi	sp,sp,32
 5b4:	8082                	ret
    return -1;
 5b6:	597d                	li	s2,-1
 5b8:	bfc5                	j	5a8 <stat+0x34>

00000000000005ba <atoi>:

int
atoi(const char *s)
{
 5ba:	1141                	addi	sp,sp,-16
 5bc:	e422                	sd	s0,8(sp)
 5be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c0:	00054683          	lbu	a3,0(a0)
 5c4:	fd06879b          	addiw	a5,a3,-48
 5c8:	0ff7f793          	zext.b	a5,a5
 5cc:	4625                	li	a2,9
 5ce:	02f66863          	bltu	a2,a5,5fe <atoi+0x44>
 5d2:	872a                	mv	a4,a0
  n = 0;
 5d4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5d6:	0705                	addi	a4,a4,1
 5d8:	0025179b          	slliw	a5,a0,0x2
 5dc:	9fa9                	addw	a5,a5,a0
 5de:	0017979b          	slliw	a5,a5,0x1
 5e2:	9fb5                	addw	a5,a5,a3
 5e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5e8:	00074683          	lbu	a3,0(a4)
 5ec:	fd06879b          	addiw	a5,a3,-48
 5f0:	0ff7f793          	zext.b	a5,a5
 5f4:	fef671e3          	bgeu	a2,a5,5d6 <atoi+0x1c>
  return n;
}
 5f8:	6422                	ld	s0,8(sp)
 5fa:	0141                	addi	sp,sp,16
 5fc:	8082                	ret
  n = 0;
 5fe:	4501                	li	a0,0
 600:	bfe5                	j	5f8 <atoi+0x3e>

0000000000000602 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 602:	1141                	addi	sp,sp,-16
 604:	e422                	sd	s0,8(sp)
 606:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 608:	02b57463          	bgeu	a0,a1,630 <memmove+0x2e>
    while(n-- > 0)
 60c:	00c05f63          	blez	a2,62a <memmove+0x28>
 610:	1602                	slli	a2,a2,0x20
 612:	9201                	srli	a2,a2,0x20
 614:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 618:	872a                	mv	a4,a0
      *dst++ = *src++;
 61a:	0585                	addi	a1,a1,1
 61c:	0705                	addi	a4,a4,1
 61e:	fff5c683          	lbu	a3,-1(a1)
 622:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 626:	fee79ae3          	bne	a5,a4,61a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 62a:	6422                	ld	s0,8(sp)
 62c:	0141                	addi	sp,sp,16
 62e:	8082                	ret
    dst += n;
 630:	00c50733          	add	a4,a0,a2
    src += n;
 634:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 636:	fec05ae3          	blez	a2,62a <memmove+0x28>
 63a:	fff6079b          	addiw	a5,a2,-1 # 7fff <base+0x5fef>
 63e:	1782                	slli	a5,a5,0x20
 640:	9381                	srli	a5,a5,0x20
 642:	fff7c793          	not	a5,a5
 646:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 648:	15fd                	addi	a1,a1,-1
 64a:	177d                	addi	a4,a4,-1
 64c:	0005c683          	lbu	a3,0(a1)
 650:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 654:	fee79ae3          	bne	a5,a4,648 <memmove+0x46>
 658:	bfc9                	j	62a <memmove+0x28>

000000000000065a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 65a:	1141                	addi	sp,sp,-16
 65c:	e422                	sd	s0,8(sp)
 65e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 660:	ca05                	beqz	a2,690 <memcmp+0x36>
 662:	fff6069b          	addiw	a3,a2,-1
 666:	1682                	slli	a3,a3,0x20
 668:	9281                	srli	a3,a3,0x20
 66a:	0685                	addi	a3,a3,1
 66c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 66e:	00054783          	lbu	a5,0(a0)
 672:	0005c703          	lbu	a4,0(a1)
 676:	00e79863          	bne	a5,a4,686 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 67a:	0505                	addi	a0,a0,1
    p2++;
 67c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 67e:	fed518e3          	bne	a0,a3,66e <memcmp+0x14>
  }
  return 0;
 682:	4501                	li	a0,0
 684:	a019                	j	68a <memcmp+0x30>
      return *p1 - *p2;
 686:	40e7853b          	subw	a0,a5,a4
}
 68a:	6422                	ld	s0,8(sp)
 68c:	0141                	addi	sp,sp,16
 68e:	8082                	ret
  return 0;
 690:	4501                	li	a0,0
 692:	bfe5                	j	68a <memcmp+0x30>

0000000000000694 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 694:	1141                	addi	sp,sp,-16
 696:	e406                	sd	ra,8(sp)
 698:	e022                	sd	s0,0(sp)
 69a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 69c:	00000097          	auipc	ra,0x0
 6a0:	f66080e7          	jalr	-154(ra) # 602 <memmove>
}
 6a4:	60a2                	ld	ra,8(sp)
 6a6:	6402                	ld	s0,0(sp)
 6a8:	0141                	addi	sp,sp,16
 6aa:	8082                	ret

00000000000006ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ac:	4885                	li	a7,1
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6b4:	4889                	li	a7,2
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 6bc:	488d                	li	a7,3
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6c4:	4891                	li	a7,4
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <read>:
.global read
read:
 li a7, SYS_read
 6cc:	4895                	li	a7,5
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <write>:
.global write
write:
 li a7, SYS_write
 6d4:	48c1                	li	a7,16
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <close>:
.global close
close:
 li a7, SYS_close
 6dc:	48d5                	li	a7,21
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6e4:	4899                	li	a7,6
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 6ec:	489d                	li	a7,7
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <open>:
.global open
open:
 li a7, SYS_open
 6f4:	48bd                	li	a7,15
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6fc:	48c5                	li	a7,17
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 704:	48c9                	li	a7,18
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 70c:	48a1                	li	a7,8
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <link>:
.global link
link:
 li a7, SYS_link
 714:	48cd                	li	a7,19
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 71c:	48d1                	li	a7,20
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 724:	48a5                	li	a7,9
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <dup>:
.global dup
dup:
 li a7, SYS_dup
 72c:	48a9                	li	a7,10
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 734:	48ad                	li	a7,11
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 73c:	48b1                	li	a7,12
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 744:	48b5                	li	a7,13
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 74c:	48b9                	li	a7,14
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 754:	1101                	addi	sp,sp,-32
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 760:	4605                	li	a2,1
 762:	fef40593          	addi	a1,s0,-17
 766:	00000097          	auipc	ra,0x0
 76a:	f6e080e7          	jalr	-146(ra) # 6d4 <write>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6105                	addi	sp,sp,32
 774:	8082                	ret

0000000000000776 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 776:	7139                	addi	sp,sp,-64
 778:	fc06                	sd	ra,56(sp)
 77a:	f822                	sd	s0,48(sp)
 77c:	f426                	sd	s1,40(sp)
 77e:	f04a                	sd	s2,32(sp)
 780:	ec4e                	sd	s3,24(sp)
 782:	0080                	addi	s0,sp,64
 784:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 786:	c299                	beqz	a3,78c <printint+0x16>
 788:	0805c963          	bltz	a1,81a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 78c:	2581                	sext.w	a1,a1
  neg = 0;
 78e:	4881                	li	a7,0
 790:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 794:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 796:	2601                	sext.w	a2,a2
 798:	00000517          	auipc	a0,0x0
 79c:	65850513          	addi	a0,a0,1624 # df0 <digits>
 7a0:	883a                	mv	a6,a4
 7a2:	2705                	addiw	a4,a4,1
 7a4:	02c5f7bb          	remuw	a5,a1,a2
 7a8:	1782                	slli	a5,a5,0x20
 7aa:	9381                	srli	a5,a5,0x20
 7ac:	97aa                	add	a5,a5,a0
 7ae:	0007c783          	lbu	a5,0(a5)
 7b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7b6:	0005879b          	sext.w	a5,a1
 7ba:	02c5d5bb          	divuw	a1,a1,a2
 7be:	0685                	addi	a3,a3,1
 7c0:	fec7f0e3          	bgeu	a5,a2,7a0 <printint+0x2a>
  if(neg)
 7c4:	00088c63          	beqz	a7,7dc <printint+0x66>
    buf[i++] = '-';
 7c8:	fd070793          	addi	a5,a4,-48
 7cc:	00878733          	add	a4,a5,s0
 7d0:	02d00793          	li	a5,45
 7d4:	fef70823          	sb	a5,-16(a4)
 7d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7dc:	02e05863          	blez	a4,80c <printint+0x96>
 7e0:	fc040793          	addi	a5,s0,-64
 7e4:	00e78933          	add	s2,a5,a4
 7e8:	fff78993          	addi	s3,a5,-1
 7ec:	99ba                	add	s3,s3,a4
 7ee:	377d                	addiw	a4,a4,-1
 7f0:	1702                	slli	a4,a4,0x20
 7f2:	9301                	srli	a4,a4,0x20
 7f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7f8:	fff94583          	lbu	a1,-1(s2)
 7fc:	8526                	mv	a0,s1
 7fe:	00000097          	auipc	ra,0x0
 802:	f56080e7          	jalr	-170(ra) # 754 <putc>
  while(--i >= 0)
 806:	197d                	addi	s2,s2,-1
 808:	ff3918e3          	bne	s2,s3,7f8 <printint+0x82>
}
 80c:	70e2                	ld	ra,56(sp)
 80e:	7442                	ld	s0,48(sp)
 810:	74a2                	ld	s1,40(sp)
 812:	7902                	ld	s2,32(sp)
 814:	69e2                	ld	s3,24(sp)
 816:	6121                	addi	sp,sp,64
 818:	8082                	ret
    x = -xx;
 81a:	40b005bb          	negw	a1,a1
    neg = 1;
 81e:	4885                	li	a7,1
    x = -xx;
 820:	bf85                	j	790 <printint+0x1a>

0000000000000822 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 822:	715d                	addi	sp,sp,-80
 824:	e486                	sd	ra,72(sp)
 826:	e0a2                	sd	s0,64(sp)
 828:	fc26                	sd	s1,56(sp)
 82a:	f84a                	sd	s2,48(sp)
 82c:	f44e                	sd	s3,40(sp)
 82e:	f052                	sd	s4,32(sp)
 830:	ec56                	sd	s5,24(sp)
 832:	e85a                	sd	s6,16(sp)
 834:	e45e                	sd	s7,8(sp)
 836:	e062                	sd	s8,0(sp)
 838:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 83a:	0005c903          	lbu	s2,0(a1)
 83e:	18090c63          	beqz	s2,9d6 <vprintf+0x1b4>
 842:	8aaa                	mv	s5,a0
 844:	8bb2                	mv	s7,a2
 846:	00158493          	addi	s1,a1,1
  state = 0;
 84a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 84c:	02500a13          	li	s4,37
 850:	4b55                	li	s6,21
 852:	a839                	j	870 <vprintf+0x4e>
        putc(fd, c);
 854:	85ca                	mv	a1,s2
 856:	8556                	mv	a0,s5
 858:	00000097          	auipc	ra,0x0
 85c:	efc080e7          	jalr	-260(ra) # 754 <putc>
 860:	a019                	j	866 <vprintf+0x44>
    } else if(state == '%'){
 862:	01498d63          	beq	s3,s4,87c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 866:	0485                	addi	s1,s1,1
 868:	fff4c903          	lbu	s2,-1(s1)
 86c:	16090563          	beqz	s2,9d6 <vprintf+0x1b4>
    if(state == 0){
 870:	fe0999e3          	bnez	s3,862 <vprintf+0x40>
      if(c == '%'){
 874:	ff4910e3          	bne	s2,s4,854 <vprintf+0x32>
        state = '%';
 878:	89d2                	mv	s3,s4
 87a:	b7f5                	j	866 <vprintf+0x44>
      if(c == 'd'){
 87c:	13490263          	beq	s2,s4,9a0 <vprintf+0x17e>
 880:	f9d9079b          	addiw	a5,s2,-99
 884:	0ff7f793          	zext.b	a5,a5
 888:	12fb6563          	bltu	s6,a5,9b2 <vprintf+0x190>
 88c:	f9d9079b          	addiw	a5,s2,-99
 890:	0ff7f713          	zext.b	a4,a5
 894:	10eb6f63          	bltu	s6,a4,9b2 <vprintf+0x190>
 898:	00271793          	slli	a5,a4,0x2
 89c:	00000717          	auipc	a4,0x0
 8a0:	4fc70713          	addi	a4,a4,1276 # d98 <statistics+0x1de>
 8a4:	97ba                	add	a5,a5,a4
 8a6:	439c                	lw	a5,0(a5)
 8a8:	97ba                	add	a5,a5,a4
 8aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8ac:	008b8913          	addi	s2,s7,8
 8b0:	4685                	li	a3,1
 8b2:	4629                	li	a2,10
 8b4:	000ba583          	lw	a1,0(s7)
 8b8:	8556                	mv	a0,s5
 8ba:	00000097          	auipc	ra,0x0
 8be:	ebc080e7          	jalr	-324(ra) # 776 <printint>
 8c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	b745                	j	866 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	008b8913          	addi	s2,s7,8
 8cc:	4681                	li	a3,0
 8ce:	4629                	li	a2,10
 8d0:	000ba583          	lw	a1,0(s7)
 8d4:	8556                	mv	a0,s5
 8d6:	00000097          	auipc	ra,0x0
 8da:	ea0080e7          	jalr	-352(ra) # 776 <printint>
 8de:	8bca                	mv	s7,s2
      state = 0;
 8e0:	4981                	li	s3,0
 8e2:	b751                	j	866 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 8e4:	008b8913          	addi	s2,s7,8
 8e8:	4681                	li	a3,0
 8ea:	4641                	li	a2,16
 8ec:	000ba583          	lw	a1,0(s7)
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e84080e7          	jalr	-380(ra) # 776 <printint>
 8fa:	8bca                	mv	s7,s2
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	b7a5                	j	866 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 900:	008b8c13          	addi	s8,s7,8
 904:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 908:	03000593          	li	a1,48
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	e46080e7          	jalr	-442(ra) # 754 <putc>
  putc(fd, 'x');
 916:	07800593          	li	a1,120
 91a:	8556                	mv	a0,s5
 91c:	00000097          	auipc	ra,0x0
 920:	e38080e7          	jalr	-456(ra) # 754 <putc>
 924:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 926:	00000b97          	auipc	s7,0x0
 92a:	4cab8b93          	addi	s7,s7,1226 # df0 <digits>
 92e:	03c9d793          	srli	a5,s3,0x3c
 932:	97de                	add	a5,a5,s7
 934:	0007c583          	lbu	a1,0(a5)
 938:	8556                	mv	a0,s5
 93a:	00000097          	auipc	ra,0x0
 93e:	e1a080e7          	jalr	-486(ra) # 754 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 942:	0992                	slli	s3,s3,0x4
 944:	397d                	addiw	s2,s2,-1
 946:	fe0914e3          	bnez	s2,92e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 94a:	8be2                	mv	s7,s8
      state = 0;
 94c:	4981                	li	s3,0
 94e:	bf21                	j	866 <vprintf+0x44>
        s = va_arg(ap, char*);
 950:	008b8993          	addi	s3,s7,8
 954:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 958:	02090163          	beqz	s2,97a <vprintf+0x158>
        while(*s != 0){
 95c:	00094583          	lbu	a1,0(s2)
 960:	c9a5                	beqz	a1,9d0 <vprintf+0x1ae>
          putc(fd, *s);
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	df0080e7          	jalr	-528(ra) # 754 <putc>
          s++;
 96c:	0905                	addi	s2,s2,1
        while(*s != 0){
 96e:	00094583          	lbu	a1,0(s2)
 972:	f9e5                	bnez	a1,962 <vprintf+0x140>
        s = va_arg(ap, char*);
 974:	8bce                	mv	s7,s3
      state = 0;
 976:	4981                	li	s3,0
 978:	b5fd                	j	866 <vprintf+0x44>
          s = "(null)";
 97a:	00000917          	auipc	s2,0x0
 97e:	41690913          	addi	s2,s2,1046 # d90 <statistics+0x1d6>
        while(*s != 0){
 982:	02800593          	li	a1,40
 986:	bff1                	j	962 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 988:	008b8913          	addi	s2,s7,8
 98c:	000bc583          	lbu	a1,0(s7)
 990:	8556                	mv	a0,s5
 992:	00000097          	auipc	ra,0x0
 996:	dc2080e7          	jalr	-574(ra) # 754 <putc>
 99a:	8bca                	mv	s7,s2
      state = 0;
 99c:	4981                	li	s3,0
 99e:	b5e1                	j	866 <vprintf+0x44>
        putc(fd, c);
 9a0:	02500593          	li	a1,37
 9a4:	8556                	mv	a0,s5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	dae080e7          	jalr	-594(ra) # 754 <putc>
      state = 0;
 9ae:	4981                	li	s3,0
 9b0:	bd5d                	j	866 <vprintf+0x44>
        putc(fd, '%');
 9b2:	02500593          	li	a1,37
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	d9c080e7          	jalr	-612(ra) # 754 <putc>
        putc(fd, c);
 9c0:	85ca                	mv	a1,s2
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	d90080e7          	jalr	-624(ra) # 754 <putc>
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	bd61                	j	866 <vprintf+0x44>
        s = va_arg(ap, char*);
 9d0:	8bce                	mv	s7,s3
      state = 0;
 9d2:	4981                	li	s3,0
 9d4:	bd49                	j	866 <vprintf+0x44>
    }
  }
}
 9d6:	60a6                	ld	ra,72(sp)
 9d8:	6406                	ld	s0,64(sp)
 9da:	74e2                	ld	s1,56(sp)
 9dc:	7942                	ld	s2,48(sp)
 9de:	79a2                	ld	s3,40(sp)
 9e0:	7a02                	ld	s4,32(sp)
 9e2:	6ae2                	ld	s5,24(sp)
 9e4:	6b42                	ld	s6,16(sp)
 9e6:	6ba2                	ld	s7,8(sp)
 9e8:	6c02                	ld	s8,0(sp)
 9ea:	6161                	addi	sp,sp,80
 9ec:	8082                	ret

00000000000009ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ee:	715d                	addi	sp,sp,-80
 9f0:	ec06                	sd	ra,24(sp)
 9f2:	e822                	sd	s0,16(sp)
 9f4:	1000                	addi	s0,sp,32
 9f6:	e010                	sd	a2,0(s0)
 9f8:	e414                	sd	a3,8(s0)
 9fa:	e818                	sd	a4,16(s0)
 9fc:	ec1c                	sd	a5,24(s0)
 9fe:	03043023          	sd	a6,32(s0)
 a02:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a0a:	8622                	mv	a2,s0
 a0c:	00000097          	auipc	ra,0x0
 a10:	e16080e7          	jalr	-490(ra) # 822 <vprintf>
}
 a14:	60e2                	ld	ra,24(sp)
 a16:	6442                	ld	s0,16(sp)
 a18:	6161                	addi	sp,sp,80
 a1a:	8082                	ret

0000000000000a1c <printf>:

void
printf(const char *fmt, ...)
{
 a1c:	711d                	addi	sp,sp,-96
 a1e:	ec06                	sd	ra,24(sp)
 a20:	e822                	sd	s0,16(sp)
 a22:	1000                	addi	s0,sp,32
 a24:	e40c                	sd	a1,8(s0)
 a26:	e810                	sd	a2,16(s0)
 a28:	ec14                	sd	a3,24(s0)
 a2a:	f018                	sd	a4,32(s0)
 a2c:	f41c                	sd	a5,40(s0)
 a2e:	03043823          	sd	a6,48(s0)
 a32:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a36:	00840613          	addi	a2,s0,8
 a3a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a3e:	85aa                	mv	a1,a0
 a40:	4505                	li	a0,1
 a42:	00000097          	auipc	ra,0x0
 a46:	de0080e7          	jalr	-544(ra) # 822 <vprintf>
}
 a4a:	60e2                	ld	ra,24(sp)
 a4c:	6442                	ld	s0,16(sp)
 a4e:	6125                	addi	sp,sp,96
 a50:	8082                	ret

0000000000000a52 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a52:	1141                	addi	sp,sp,-16
 a54:	e422                	sd	s0,8(sp)
 a56:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a58:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5c:	00000797          	auipc	a5,0x0
 a60:	5a47b783          	ld	a5,1444(a5) # 1000 <freep>
 a64:	a02d                	j	a8e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a66:	4618                	lw	a4,8(a2)
 a68:	9f2d                	addw	a4,a4,a1
 a6a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6e:	6398                	ld	a4,0(a5)
 a70:	6310                	ld	a2,0(a4)
 a72:	a83d                	j	ab0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a74:	ff852703          	lw	a4,-8(a0)
 a78:	9f31                	addw	a4,a4,a2
 a7a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a7c:	ff053683          	ld	a3,-16(a0)
 a80:	a091                	j	ac4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a82:	6398                	ld	a4,0(a5)
 a84:	00e7e463          	bltu	a5,a4,a8c <free+0x3a>
 a88:	00e6ea63          	bltu	a3,a4,a9c <free+0x4a>
{
 a8c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8e:	fed7fae3          	bgeu	a5,a3,a82 <free+0x30>
 a92:	6398                	ld	a4,0(a5)
 a94:	00e6e463          	bltu	a3,a4,a9c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a98:	fee7eae3          	bltu	a5,a4,a8c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a9c:	ff852583          	lw	a1,-8(a0)
 aa0:	6390                	ld	a2,0(a5)
 aa2:	02059813          	slli	a6,a1,0x20
 aa6:	01c85713          	srli	a4,a6,0x1c
 aaa:	9736                	add	a4,a4,a3
 aac:	fae60de3          	beq	a2,a4,a66 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ab0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ab4:	4790                	lw	a2,8(a5)
 ab6:	02061593          	slli	a1,a2,0x20
 aba:	01c5d713          	srli	a4,a1,0x1c
 abe:	973e                	add	a4,a4,a5
 ac0:	fae68ae3          	beq	a3,a4,a74 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ac4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ac6:	00000717          	auipc	a4,0x0
 aca:	52f73d23          	sd	a5,1338(a4) # 1000 <freep>
}
 ace:	6422                	ld	s0,8(sp)
 ad0:	0141                	addi	sp,sp,16
 ad2:	8082                	ret

0000000000000ad4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ad4:	7139                	addi	sp,sp,-64
 ad6:	fc06                	sd	ra,56(sp)
 ad8:	f822                	sd	s0,48(sp)
 ada:	f426                	sd	s1,40(sp)
 adc:	f04a                	sd	s2,32(sp)
 ade:	ec4e                	sd	s3,24(sp)
 ae0:	e852                	sd	s4,16(sp)
 ae2:	e456                	sd	s5,8(sp)
 ae4:	e05a                	sd	s6,0(sp)
 ae6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae8:	02051493          	slli	s1,a0,0x20
 aec:	9081                	srli	s1,s1,0x20
 aee:	04bd                	addi	s1,s1,15
 af0:	8091                	srli	s1,s1,0x4
 af2:	0014899b          	addiw	s3,s1,1
 af6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 af8:	00000517          	auipc	a0,0x0
 afc:	50853503          	ld	a0,1288(a0) # 1000 <freep>
 b00:	c515                	beqz	a0,b2c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b02:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b04:	4798                	lw	a4,8(a5)
 b06:	02977f63          	bgeu	a4,s1,b44 <malloc+0x70>
  if(nu < 4096)
 b0a:	8a4e                	mv	s4,s3
 b0c:	0009871b          	sext.w	a4,s3
 b10:	6685                	lui	a3,0x1
 b12:	00d77363          	bgeu	a4,a3,b18 <malloc+0x44>
 b16:	6a05                	lui	s4,0x1
 b18:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b1c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b20:	00000917          	auipc	s2,0x0
 b24:	4e090913          	addi	s2,s2,1248 # 1000 <freep>
  if(p == (char*)-1)
 b28:	5afd                	li	s5,-1
 b2a:	a895                	j	b9e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b2c:	00001797          	auipc	a5,0x1
 b30:	4e478793          	addi	a5,a5,1252 # 2010 <base>
 b34:	00000717          	auipc	a4,0x0
 b38:	4cf73623          	sd	a5,1228(a4) # 1000 <freep>
 b3c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b3e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b42:	b7e1                	j	b0a <malloc+0x36>
      if(p->s.size == nunits)
 b44:	02e48c63          	beq	s1,a4,b7c <malloc+0xa8>
        p->s.size -= nunits;
 b48:	4137073b          	subw	a4,a4,s3
 b4c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b4e:	02071693          	slli	a3,a4,0x20
 b52:	01c6d713          	srli	a4,a3,0x1c
 b56:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b58:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b5c:	00000717          	auipc	a4,0x0
 b60:	4aa73223          	sd	a0,1188(a4) # 1000 <freep>
      return (void*)(p + 1);
 b64:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b68:	70e2                	ld	ra,56(sp)
 b6a:	7442                	ld	s0,48(sp)
 b6c:	74a2                	ld	s1,40(sp)
 b6e:	7902                	ld	s2,32(sp)
 b70:	69e2                	ld	s3,24(sp)
 b72:	6a42                	ld	s4,16(sp)
 b74:	6aa2                	ld	s5,8(sp)
 b76:	6b02                	ld	s6,0(sp)
 b78:	6121                	addi	sp,sp,64
 b7a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b7c:	6398                	ld	a4,0(a5)
 b7e:	e118                	sd	a4,0(a0)
 b80:	bff1                	j	b5c <malloc+0x88>
  hp->s.size = nu;
 b82:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b86:	0541                	addi	a0,a0,16
 b88:	00000097          	auipc	ra,0x0
 b8c:	eca080e7          	jalr	-310(ra) # a52 <free>
  return freep;
 b90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b94:	d971                	beqz	a0,b68 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b98:	4798                	lw	a4,8(a5)
 b9a:	fa9775e3          	bgeu	a4,s1,b44 <malloc+0x70>
    if(p == freep)
 b9e:	00093703          	ld	a4,0(s2)
 ba2:	853e                	mv	a0,a5
 ba4:	fef719e3          	bne	a4,a5,b96 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ba8:	8552                	mv	a0,s4
 baa:	00000097          	auipc	ra,0x0
 bae:	b92080e7          	jalr	-1134(ra) # 73c <sbrk>
  if(p == (char*)-1)
 bb2:	fd5518e3          	bne	a0,s5,b82 <malloc+0xae>
        return 0;
 bb6:	4501                	li	a0,0
 bb8:	bf45                	j	b68 <malloc+0x94>

0000000000000bba <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 bba:	7179                	addi	sp,sp,-48
 bbc:	f406                	sd	ra,40(sp)
 bbe:	f022                	sd	s0,32(sp)
 bc0:	ec26                	sd	s1,24(sp)
 bc2:	e84a                	sd	s2,16(sp)
 bc4:	e44e                	sd	s3,8(sp)
 bc6:	e052                	sd	s4,0(sp)
 bc8:	1800                	addi	s0,sp,48
 bca:	8a2a                	mv	s4,a0
 bcc:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 bce:	4581                	li	a1,0
 bd0:	00000517          	auipc	a0,0x0
 bd4:	23850513          	addi	a0,a0,568 # e08 <digits+0x18>
 bd8:	00000097          	auipc	ra,0x0
 bdc:	b1c080e7          	jalr	-1252(ra) # 6f4 <open>
  if(fd < 0) {
 be0:	04054263          	bltz	a0,c24 <statistics+0x6a>
 be4:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 be6:	4481                	li	s1,0
 be8:	03205063          	blez	s2,c08 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 bec:	4099063b          	subw	a2,s2,s1
 bf0:	009a05b3          	add	a1,s4,s1
 bf4:	854e                	mv	a0,s3
 bf6:	00000097          	auipc	ra,0x0
 bfa:	ad6080e7          	jalr	-1322(ra) # 6cc <read>
 bfe:	00054563          	bltz	a0,c08 <statistics+0x4e>
      break;
    }
    i += n;
 c02:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 c04:	ff24c4e3          	blt	s1,s2,bec <statistics+0x32>
  }
  close(fd);
 c08:	854e                	mv	a0,s3
 c0a:	00000097          	auipc	ra,0x0
 c0e:	ad2080e7          	jalr	-1326(ra) # 6dc <close>
  return i;
}
 c12:	8526                	mv	a0,s1
 c14:	70a2                	ld	ra,40(sp)
 c16:	7402                	ld	s0,32(sp)
 c18:	64e2                	ld	s1,24(sp)
 c1a:	6942                	ld	s2,16(sp)
 c1c:	69a2                	ld	s3,8(sp)
 c1e:	6a02                	ld	s4,0(sp)
 c20:	6145                	addi	sp,sp,48
 c22:	8082                	ret
      fprintf(2, "stats: open failed\n");
 c24:	00000597          	auipc	a1,0x0
 c28:	1f458593          	addi	a1,a1,500 # e18 <digits+0x28>
 c2c:	4509                	li	a0,2
 c2e:	00000097          	auipc	ra,0x0
 c32:	dc0080e7          	jalr	-576(ra) # 9ee <fprintf>
      exit(1);
 c36:	4505                	li	a0,1
 c38:	00000097          	auipc	ra,0x0
 c3c:	a7c080e7          	jalr	-1412(ra) # 6b4 <exit>
