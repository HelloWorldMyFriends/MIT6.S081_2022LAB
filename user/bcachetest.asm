
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	7f6080e7          	jalr	2038(ra) # 81e <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	addi	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	7b8080e7          	jalr	1976(ra) # 7fe <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addiw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	7a8080e7          	jalr	1960(ra) # 806 <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	addi	sp,sp,1072
  82:	8082                	ret
    printf("createfile %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	cea50513          	addi	a0,a0,-790 # d70 <statistics+0x8c>
  8e:	00001097          	auipc	ra,0x1
  92:	ab8080e7          	jalr	-1352(ra) # b46 <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	746080e7          	jalr	1862(ra) # 7de <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	ce650513          	addi	a0,a0,-794 # d88 <statistics+0xa4>
  aa:	00001097          	auipc	ra,0x1
  ae:	a9c080e7          	jalr	-1380(ra) # b46 <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	72a080e7          	jalr	1834(ra) # 7de <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	addi	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	72e080e7          	jalr	1838(ra) # 81e <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	addi	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	6ea080e7          	jalr	1770(ra) # 7f6 <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	6e4080e7          	jalr	1764(ra) # 806 <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	addi	sp,sp,1088
 14a:	8082                	ret
    printf("readfile: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c5450513          	addi	a0,a0,-940 # da0 <statistics+0xbc>
 154:	00001097          	auipc	ra,0x1
 158:	9f2080e7          	jalr	-1550(ra) # b46 <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	680080e7          	jalr	1664(ra) # 7de <exit>
    printf("readfile open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	c5850513          	addi	a0,a0,-936 # dc0 <statistics+0xdc>
 170:	00001097          	auipc	ra,0x1
 174:	9d6080e7          	jalr	-1578(ra) # b46 <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	664080e7          	jalr	1636(ra) # 7de <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	c5850513          	addi	a0,a0,-936 # de0 <statistics+0xfc>
 190:	00001097          	auipc	ra,0x1
 194:	9b6080e7          	jalr	-1610(ra) # b46 <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	644080e7          	jalr	1604(ra) # 7de <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
 1b0:	6585                	lui	a1,0x1
 1b2:	00001517          	auipc	a0,0x1
 1b6:	e5e50513          	addi	a0,a0,-418 # 1010 <buf>
 1ba:	00001097          	auipc	ra,0x1
 1be:	b2a080e7          	jalr	-1238(ra) # ce4 <statistics>
 1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
 1c6:	03d00593          	li	a1,61
 1ca:	00001517          	auipc	a0,0x1
 1ce:	e4650513          	addi	a0,a0,-442 # 1010 <buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	434080e7          	jalr	1076(ra) # 606 <strchr>
  n = atoi(c+2);
 1da:	0509                	addi	a0,a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	508080e7          	jalr	1288(ra) # 6e4 <atoi>
 1e4:	84aa                	mv	s1,a0
  if(print)
 1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
 1ea:	8526                	mv	a0,s1
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
 1f8:	00001597          	auipc	a1,0x1
 1fc:	c1058593          	addi	a1,a1,-1008 # e08 <statistics+0x124>
 200:	4509                	li	a0,2
 202:	00001097          	auipc	ra,0x1
 206:	916080e7          	jalr	-1770(ra) # b18 <fprintf>
 20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
 20c:	00001597          	auipc	a1,0x1
 210:	e0458593          	addi	a1,a1,-508 # 1010 <buf>
 214:	00001517          	auipc	a0,0x1
 218:	c0450513          	addi	a0,a0,-1020 # e18 <statistics+0x134>
 21c:	00001097          	auipc	ra,0x1
 220:	92a080e7          	jalr	-1750(ra) # b46 <printf>
 224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

// Test reading small files concurrently
void
test0()
{
 226:	7139                	addi	sp,sp,-64
 228:	fc06                	sd	ra,56(sp)
 22a:	f822                	sd	s0,48(sp)
 22c:	f426                	sd	s1,40(sp)
 22e:	f04a                	sd	s2,32(sp)
 230:	ec4e                	sd	s3,24(sp)
 232:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int m, n;

  dir[0] = '0';
 234:	03000793          	li	a5,48
 238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 240:	04600793          	li	a5,70
 244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 24c:	00001517          	auipc	a0,0x1
 250:	bd450513          	addi	a0,a0,-1068 # e20 <statistics+0x13c>
 254:	00001097          	auipc	ra,0x1
 258:	8f2080e7          	jalr	-1806(ra) # b46 <printf>
 25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 260:	00001997          	auipc	s3,0x1
 264:	be098993          	addi	s3,s3,-1056 # e40 <statistics+0x15c>
  for(int i = 0; i < NCHILD; i++){
 268:	03300913          	li	s2,51
    dir[0] = '0' + i;
 26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 270:	fc040513          	addi	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	5d2080e7          	jalr	1490(ra) # 846 <mkdir>
    if (chdir(dir) < 0) {
 27c:	fc040513          	addi	a0,s0,-64
 280:	00000097          	auipc	ra,0x0
 284:	5ce080e7          	jalr	1486(ra) # 84e <chdir>
 288:	0c054463          	bltz	a0,350 <test0+0x12a>
    unlink(file);
 28c:	fc840513          	addi	a0,s0,-56
 290:	00000097          	auipc	ra,0x0
 294:	59e080e7          	jalr	1438(ra) # 82e <unlink>
    createfile(file, N);
 298:	45a9                	li	a1,10
 29a:	fc840513          	addi	a0,s0,-56
 29e:	00000097          	auipc	ra,0x0
 2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 2a6:	854e                	mv	a0,s3
 2a8:	00000097          	auipc	ra,0x0
 2ac:	5a6080e7          	jalr	1446(ra) # 84e <chdir>
 2b0:	0a054d63          	bltz	a0,36a <test0+0x144>
  for(int i = 0; i < NCHILD; i++){
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0ff4f493          	zext.b	s1,s1
 2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
 2c8:	892a                	mv	s2,a0
 2ca:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 2ce:	03300993          	li	s3,51
    dir[0] = '0' + i;
 2d2:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 2d6:	00000097          	auipc	ra,0x0
 2da:	500080e7          	jalr	1280(ra) # 7d6 <fork>
    if(pid < 0){
 2de:	0a054363          	bltz	a0,384 <test0+0x15e>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2e2:	cd55                	beqz	a0,39e <test0+0x178>
  for(int i = 0; i < NCHILD; i++){
 2e4:	2485                	addiw	s1,s1,1
 2e6:	0ff4f493          	zext.b	s1,s1
 2ea:	ff3494e3          	bne	s1,s3,2d2 <test0+0xac>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	4f6080e7          	jalr	1270(ra) # 7e6 <wait>
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	4ec080e7          	jalr	1260(ra) # 7e6 <wait>
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	4e2080e7          	jalr	1250(ra) # 7e6 <wait>
  }
  printf("test0 results:\n");
 30c:	00001517          	auipc	a0,0x1
 310:	b4c50513          	addi	a0,a0,-1204 # e58 <statistics+0x174>
 314:	00001097          	auipc	ra,0x1
 318:	832080e7          	jalr	-1998(ra) # b46 <printf>
  n = ntas(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	e84080e7          	jalr	-380(ra) # 1a2 <ntas>
  if (n-m < 500)
 326:	4125053b          	subw	a0,a0,s2
 32a:	1f300793          	li	a5,499
 32e:	0aa7cc63          	blt	a5,a0,3e6 <test0+0x1c0>
    printf("test0: OK\n");
 332:	00001517          	auipc	a0,0x1
 336:	b3650513          	addi	a0,a0,-1226 # e68 <statistics+0x184>
 33a:	00001097          	auipc	ra,0x1
 33e:	80c080e7          	jalr	-2036(ra) # b46 <printf>
  else
    printf("test0: FAIL\n");
}
 342:	70e2                	ld	ra,56(sp)
 344:	7442                	ld	s0,48(sp)
 346:	74a2                	ld	s1,40(sp)
 348:	7902                	ld	s2,32(sp)
 34a:	69e2                	ld	s3,24(sp)
 34c:	6121                	addi	sp,sp,64
 34e:	8082                	ret
      printf("chdir failed\n");
 350:	00001517          	auipc	a0,0x1
 354:	ae050513          	addi	a0,a0,-1312 # e30 <statistics+0x14c>
 358:	00000097          	auipc	ra,0x0
 35c:	7ee080e7          	jalr	2030(ra) # b46 <printf>
      exit(1);
 360:	4505                	li	a0,1
 362:	00000097          	auipc	ra,0x0
 366:	47c080e7          	jalr	1148(ra) # 7de <exit>
      printf("chdir failed\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	ac650513          	addi	a0,a0,-1338 # e30 <statistics+0x14c>
 372:	00000097          	auipc	ra,0x0
 376:	7d4080e7          	jalr	2004(ra) # b46 <printf>
      exit(1);
 37a:	4505                	li	a0,1
 37c:	00000097          	auipc	ra,0x0
 380:	462080e7          	jalr	1122(ra) # 7de <exit>
      printf("fork failed");
 384:	00001517          	auipc	a0,0x1
 388:	ac450513          	addi	a0,a0,-1340 # e48 <statistics+0x164>
 38c:	00000097          	auipc	ra,0x0
 390:	7ba080e7          	jalr	1978(ra) # b46 <printf>
      exit(-1);
 394:	557d                	li	a0,-1
 396:	00000097          	auipc	ra,0x0
 39a:	448080e7          	jalr	1096(ra) # 7de <exit>
      if (chdir(dir) < 0) {
 39e:	fc040513          	addi	a0,s0,-64
 3a2:	00000097          	auipc	ra,0x0
 3a6:	4ac080e7          	jalr	1196(ra) # 84e <chdir>
 3aa:	02054163          	bltz	a0,3cc <test0+0x1a6>
      readfile(file, N*BSIZE, 1);
 3ae:	4605                	li	a2,1
 3b0:	658d                	lui	a1,0x3
 3b2:	80058593          	addi	a1,a1,-2048 # 2800 <base+0x7f0>
 3b6:	fc840513          	addi	a0,s0,-56
 3ba:	00000097          	auipc	ra,0x0
 3be:	d02080e7          	jalr	-766(ra) # bc <readfile>
      exit(0);
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	41a080e7          	jalr	1050(ra) # 7de <exit>
        printf("chdir failed\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	a6450513          	addi	a0,a0,-1436 # e30 <statistics+0x14c>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	772080e7          	jalr	1906(ra) # b46 <printf>
        exit(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	400080e7          	jalr	1024(ra) # 7de <exit>
    printf("test0: FAIL\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a9250513          	addi	a0,a0,-1390 # e78 <statistics+0x194>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	758080e7          	jalr	1880(ra) # b46 <printf>
}
 3f6:	b7b1                	j	342 <test0+0x11c>

00000000000003f8 <test1>:

// Test bcache evictions by reading a large file concurrently
void test1()
{
 3f8:	7179                	addi	sp,sp,-48
 3fa:	f406                	sd	ra,40(sp)
 3fc:	f022                	sd	s0,32(sp)
 3fe:	ec26                	sd	s1,24(sp)
 400:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 200, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 402:	00001517          	auipc	a0,0x1
 406:	a8650513          	addi	a0,a0,-1402 # e88 <statistics+0x1a4>
 40a:	00000097          	auipc	ra,0x0
 40e:	73c080e7          	jalr	1852(ra) # b46 <printf>
  file[0] = 'B';
 412:	04200793          	li	a5,66
 416:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 41a:	fc040d23          	sb	zero,-38(s0)
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 41e:	03000493          	li	s1,48
 422:	fc940ca3          	sb	s1,-39(s0)
    unlink(file);
 426:	fd840513          	addi	a0,s0,-40
 42a:	00000097          	auipc	ra,0x0
 42e:	404080e7          	jalr	1028(ra) # 82e <unlink>
    if (i == 0) {
      createfile(file, BIG);
 432:	06400593          	li	a1,100
 436:	fd840513          	addi	a0,s0,-40
 43a:	00000097          	auipc	ra,0x0
 43e:	bc6080e7          	jalr	-1082(ra) # 0 <createfile>
    file[1] = '0' + i;
 442:	03100793          	li	a5,49
 446:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 44a:	fd840513          	addi	a0,s0,-40
 44e:	00000097          	auipc	ra,0x0
 452:	3e0080e7          	jalr	992(ra) # 82e <unlink>
    } else {
      createfile(file, 1);
 456:	4585                	li	a1,1
 458:	fd840513          	addi	a0,s0,-40
 45c:	00000097          	auipc	ra,0x0
 460:	ba4080e7          	jalr	-1116(ra) # 0 <createfile>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 464:	fc940ca3          	sb	s1,-39(s0)
    int pid = fork();
 468:	00000097          	auipc	ra,0x0
 46c:	36e080e7          	jalr	878(ra) # 7d6 <fork>
    if(pid < 0){
 470:	04054563          	bltz	a0,4ba <test1+0xc2>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 474:	c125                	beqz	a0,4d4 <test1+0xdc>
    file[1] = '0' + i;
 476:	03100793          	li	a5,49
 47a:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 47e:	00000097          	auipc	ra,0x0
 482:	358080e7          	jalr	856(ra) # 7d6 <fork>
    if(pid < 0){
 486:	02054a63          	bltz	a0,4ba <test1+0xc2>
    if(pid == 0){
 48a:	cd2d                	beqz	a0,504 <test1+0x10c>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 48c:	4501                	li	a0,0
 48e:	00000097          	auipc	ra,0x0
 492:	358080e7          	jalr	856(ra) # 7e6 <wait>
 496:	4501                	li	a0,0
 498:	00000097          	auipc	ra,0x0
 49c:	34e080e7          	jalr	846(ra) # 7e6 <wait>
  }
  printf("test1 OK\n");
 4a0:	00001517          	auipc	a0,0x1
 4a4:	9f850513          	addi	a0,a0,-1544 # e98 <statistics+0x1b4>
 4a8:	00000097          	auipc	ra,0x0
 4ac:	69e080e7          	jalr	1694(ra) # b46 <printf>
}
 4b0:	70a2                	ld	ra,40(sp)
 4b2:	7402                	ld	s0,32(sp)
 4b4:	64e2                	ld	s1,24(sp)
 4b6:	6145                	addi	sp,sp,48
 4b8:	8082                	ret
      printf("fork failed");
 4ba:	00001517          	auipc	a0,0x1
 4be:	98e50513          	addi	a0,a0,-1650 # e48 <statistics+0x164>
 4c2:	00000097          	auipc	ra,0x0
 4c6:	684080e7          	jalr	1668(ra) # b46 <printf>
      exit(-1);
 4ca:	557d                	li	a0,-1
 4cc:	00000097          	auipc	ra,0x0
 4d0:	312080e7          	jalr	786(ra) # 7de <exit>
    if(pid == 0){
 4d4:	0c800493          	li	s1,200
          readfile(file, BIG*BSIZE, BSIZE);
 4d8:	40000613          	li	a2,1024
 4dc:	65e5                	lui	a1,0x19
 4de:	fd840513          	addi	a0,s0,-40
 4e2:	00000097          	auipc	ra,0x0
 4e6:	bda080e7          	jalr	-1062(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 4ea:	34fd                	addiw	s1,s1,-1
 4ec:	f4f5                	bnez	s1,4d8 <test1+0xe0>
        unlink(file);
 4ee:	fd840513          	addi	a0,s0,-40
 4f2:	00000097          	auipc	ra,0x0
 4f6:	33c080e7          	jalr	828(ra) # 82e <unlink>
        exit(0);
 4fa:	4501                	li	a0,0
 4fc:	00000097          	auipc	ra,0x0
 500:	2e2080e7          	jalr	738(ra) # 7de <exit>
 504:	6485                	lui	s1,0x1
 506:	fa048493          	addi	s1,s1,-96 # fa0 <digits+0x98>
          readfile(file, 1, BSIZE);
 50a:	40000613          	li	a2,1024
 50e:	4585                	li	a1,1
 510:	fd840513          	addi	a0,s0,-40
 514:	00000097          	auipc	ra,0x0
 518:	ba8080e7          	jalr	-1112(ra) # bc <readfile>
        for (i = 0; i < N*20; i++) {
 51c:	34fd                	addiw	s1,s1,-1
 51e:	f4f5                	bnez	s1,50a <test1+0x112>
        unlink(file);
 520:	fd840513          	addi	a0,s0,-40
 524:	00000097          	auipc	ra,0x0
 528:	30a080e7          	jalr	778(ra) # 82e <unlink>
      exit(0);
 52c:	4501                	li	a0,0
 52e:	00000097          	auipc	ra,0x0
 532:	2b0080e7          	jalr	688(ra) # 7de <exit>

0000000000000536 <main>:
{
 536:	1141                	addi	sp,sp,-16
 538:	e406                	sd	ra,8(sp)
 53a:	e022                	sd	s0,0(sp)
 53c:	0800                	addi	s0,sp,16
  test0();
 53e:	00000097          	auipc	ra,0x0
 542:	ce8080e7          	jalr	-792(ra) # 226 <test0>
  test1();
 546:	00000097          	auipc	ra,0x0
 54a:	eb2080e7          	jalr	-334(ra) # 3f8 <test1>
  exit(0);
 54e:	4501                	li	a0,0
 550:	00000097          	auipc	ra,0x0
 554:	28e080e7          	jalr	654(ra) # 7de <exit>

0000000000000558 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 558:	1141                	addi	sp,sp,-16
 55a:	e406                	sd	ra,8(sp)
 55c:	e022                	sd	s0,0(sp)
 55e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 560:	00000097          	auipc	ra,0x0
 564:	fd6080e7          	jalr	-42(ra) # 536 <main>
  exit(0);
 568:	4501                	li	a0,0
 56a:	00000097          	auipc	ra,0x0
 56e:	274080e7          	jalr	628(ra) # 7de <exit>

0000000000000572 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 572:	1141                	addi	sp,sp,-16
 574:	e422                	sd	s0,8(sp)
 576:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 578:	87aa                	mv	a5,a0
 57a:	0585                	addi	a1,a1,1 # 19001 <base+0x16ff1>
 57c:	0785                	addi	a5,a5,1
 57e:	fff5c703          	lbu	a4,-1(a1)
 582:	fee78fa3          	sb	a4,-1(a5)
 586:	fb75                	bnez	a4,57a <strcpy+0x8>
    ;
  return os;
}
 588:	6422                	ld	s0,8(sp)
 58a:	0141                	addi	sp,sp,16
 58c:	8082                	ret

000000000000058e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 58e:	1141                	addi	sp,sp,-16
 590:	e422                	sd	s0,8(sp)
 592:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 594:	00054783          	lbu	a5,0(a0)
 598:	cb91                	beqz	a5,5ac <strcmp+0x1e>
 59a:	0005c703          	lbu	a4,0(a1)
 59e:	00f71763          	bne	a4,a5,5ac <strcmp+0x1e>
    p++, q++;
 5a2:	0505                	addi	a0,a0,1
 5a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 5a6:	00054783          	lbu	a5,0(a0)
 5aa:	fbe5                	bnez	a5,59a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 5ac:	0005c503          	lbu	a0,0(a1)
}
 5b0:	40a7853b          	subw	a0,a5,a0
 5b4:	6422                	ld	s0,8(sp)
 5b6:	0141                	addi	sp,sp,16
 5b8:	8082                	ret

00000000000005ba <strlen>:

uint
strlen(const char *s)
{
 5ba:	1141                	addi	sp,sp,-16
 5bc:	e422                	sd	s0,8(sp)
 5be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5c0:	00054783          	lbu	a5,0(a0)
 5c4:	cf91                	beqz	a5,5e0 <strlen+0x26>
 5c6:	0505                	addi	a0,a0,1
 5c8:	87aa                	mv	a5,a0
 5ca:	86be                	mv	a3,a5
 5cc:	0785                	addi	a5,a5,1
 5ce:	fff7c703          	lbu	a4,-1(a5)
 5d2:	ff65                	bnez	a4,5ca <strlen+0x10>
 5d4:	40a6853b          	subw	a0,a3,a0
 5d8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 5da:	6422                	ld	s0,8(sp)
 5dc:	0141                	addi	sp,sp,16
 5de:	8082                	ret
  for(n = 0; s[n]; n++)
 5e0:	4501                	li	a0,0
 5e2:	bfe5                	j	5da <strlen+0x20>

00000000000005e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5e4:	1141                	addi	sp,sp,-16
 5e6:	e422                	sd	s0,8(sp)
 5e8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5ea:	ca19                	beqz	a2,600 <memset+0x1c>
 5ec:	87aa                	mv	a5,a0
 5ee:	1602                	slli	a2,a2,0x20
 5f0:	9201                	srli	a2,a2,0x20
 5f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5f6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5fa:	0785                	addi	a5,a5,1
 5fc:	fee79de3          	bne	a5,a4,5f6 <memset+0x12>
  }
  return dst;
}
 600:	6422                	ld	s0,8(sp)
 602:	0141                	addi	sp,sp,16
 604:	8082                	ret

0000000000000606 <strchr>:

char*
strchr(const char *s, char c)
{
 606:	1141                	addi	sp,sp,-16
 608:	e422                	sd	s0,8(sp)
 60a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 60c:	00054783          	lbu	a5,0(a0)
 610:	cb99                	beqz	a5,626 <strchr+0x20>
    if(*s == c)
 612:	00f58763          	beq	a1,a5,620 <strchr+0x1a>
  for(; *s; s++)
 616:	0505                	addi	a0,a0,1
 618:	00054783          	lbu	a5,0(a0)
 61c:	fbfd                	bnez	a5,612 <strchr+0xc>
      return (char*)s;
  return 0;
 61e:	4501                	li	a0,0
}
 620:	6422                	ld	s0,8(sp)
 622:	0141                	addi	sp,sp,16
 624:	8082                	ret
  return 0;
 626:	4501                	li	a0,0
 628:	bfe5                	j	620 <strchr+0x1a>

000000000000062a <gets>:

char*
gets(char *buf, int max)
{
 62a:	711d                	addi	sp,sp,-96
 62c:	ec86                	sd	ra,88(sp)
 62e:	e8a2                	sd	s0,80(sp)
 630:	e4a6                	sd	s1,72(sp)
 632:	e0ca                	sd	s2,64(sp)
 634:	fc4e                	sd	s3,56(sp)
 636:	f852                	sd	s4,48(sp)
 638:	f456                	sd	s5,40(sp)
 63a:	f05a                	sd	s6,32(sp)
 63c:	ec5e                	sd	s7,24(sp)
 63e:	1080                	addi	s0,sp,96
 640:	8baa                	mv	s7,a0
 642:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 644:	892a                	mv	s2,a0
 646:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 648:	4aa9                	li	s5,10
 64a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 64c:	89a6                	mv	s3,s1
 64e:	2485                	addiw	s1,s1,1
 650:	0344d863          	bge	s1,s4,680 <gets+0x56>
    cc = read(0, &c, 1);
 654:	4605                	li	a2,1
 656:	faf40593          	addi	a1,s0,-81
 65a:	4501                	li	a0,0
 65c:	00000097          	auipc	ra,0x0
 660:	19a080e7          	jalr	410(ra) # 7f6 <read>
    if(cc < 1)
 664:	00a05e63          	blez	a0,680 <gets+0x56>
    buf[i++] = c;
 668:	faf44783          	lbu	a5,-81(s0)
 66c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 670:	01578763          	beq	a5,s5,67e <gets+0x54>
 674:	0905                	addi	s2,s2,1
 676:	fd679be3          	bne	a5,s6,64c <gets+0x22>
  for(i=0; i+1 < max; ){
 67a:	89a6                	mv	s3,s1
 67c:	a011                	j	680 <gets+0x56>
 67e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 680:	99de                	add	s3,s3,s7
 682:	00098023          	sb	zero,0(s3)
  return buf;
}
 686:	855e                	mv	a0,s7
 688:	60e6                	ld	ra,88(sp)
 68a:	6446                	ld	s0,80(sp)
 68c:	64a6                	ld	s1,72(sp)
 68e:	6906                	ld	s2,64(sp)
 690:	79e2                	ld	s3,56(sp)
 692:	7a42                	ld	s4,48(sp)
 694:	7aa2                	ld	s5,40(sp)
 696:	7b02                	ld	s6,32(sp)
 698:	6be2                	ld	s7,24(sp)
 69a:	6125                	addi	sp,sp,96
 69c:	8082                	ret

000000000000069e <stat>:

int
stat(const char *n, struct stat *st)
{
 69e:	1101                	addi	sp,sp,-32
 6a0:	ec06                	sd	ra,24(sp)
 6a2:	e822                	sd	s0,16(sp)
 6a4:	e426                	sd	s1,8(sp)
 6a6:	e04a                	sd	s2,0(sp)
 6a8:	1000                	addi	s0,sp,32
 6aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6ac:	4581                	li	a1,0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	170080e7          	jalr	368(ra) # 81e <open>
  if(fd < 0)
 6b6:	02054563          	bltz	a0,6e0 <stat+0x42>
 6ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6bc:	85ca                	mv	a1,s2
 6be:	00000097          	auipc	ra,0x0
 6c2:	178080e7          	jalr	376(ra) # 836 <fstat>
 6c6:	892a                	mv	s2,a0
  close(fd);
 6c8:	8526                	mv	a0,s1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	13c080e7          	jalr	316(ra) # 806 <close>
  return r;
}
 6d2:	854a                	mv	a0,s2
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	64a2                	ld	s1,8(sp)
 6da:	6902                	ld	s2,0(sp)
 6dc:	6105                	addi	sp,sp,32
 6de:	8082                	ret
    return -1;
 6e0:	597d                	li	s2,-1
 6e2:	bfc5                	j	6d2 <stat+0x34>

00000000000006e4 <atoi>:

int
atoi(const char *s)
{
 6e4:	1141                	addi	sp,sp,-16
 6e6:	e422                	sd	s0,8(sp)
 6e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6ea:	00054683          	lbu	a3,0(a0)
 6ee:	fd06879b          	addiw	a5,a3,-48
 6f2:	0ff7f793          	zext.b	a5,a5
 6f6:	4625                	li	a2,9
 6f8:	02f66863          	bltu	a2,a5,728 <atoi+0x44>
 6fc:	872a                	mv	a4,a0
  n = 0;
 6fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 700:	0705                	addi	a4,a4,1
 702:	0025179b          	slliw	a5,a0,0x2
 706:	9fa9                	addw	a5,a5,a0
 708:	0017979b          	slliw	a5,a5,0x1
 70c:	9fb5                	addw	a5,a5,a3
 70e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 712:	00074683          	lbu	a3,0(a4)
 716:	fd06879b          	addiw	a5,a3,-48
 71a:	0ff7f793          	zext.b	a5,a5
 71e:	fef671e3          	bgeu	a2,a5,700 <atoi+0x1c>
  return n;
}
 722:	6422                	ld	s0,8(sp)
 724:	0141                	addi	sp,sp,16
 726:	8082                	ret
  n = 0;
 728:	4501                	li	a0,0
 72a:	bfe5                	j	722 <atoi+0x3e>

000000000000072c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 72c:	1141                	addi	sp,sp,-16
 72e:	e422                	sd	s0,8(sp)
 730:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 732:	02b57463          	bgeu	a0,a1,75a <memmove+0x2e>
    while(n-- > 0)
 736:	00c05f63          	blez	a2,754 <memmove+0x28>
 73a:	1602                	slli	a2,a2,0x20
 73c:	9201                	srli	a2,a2,0x20
 73e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 742:	872a                	mv	a4,a0
      *dst++ = *src++;
 744:	0585                	addi	a1,a1,1
 746:	0705                	addi	a4,a4,1
 748:	fff5c683          	lbu	a3,-1(a1)
 74c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 750:	fee79ae3          	bne	a5,a4,744 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 754:	6422                	ld	s0,8(sp)
 756:	0141                	addi	sp,sp,16
 758:	8082                	ret
    dst += n;
 75a:	00c50733          	add	a4,a0,a2
    src += n;
 75e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 760:	fec05ae3          	blez	a2,754 <memmove+0x28>
 764:	fff6079b          	addiw	a5,a2,-1
 768:	1782                	slli	a5,a5,0x20
 76a:	9381                	srli	a5,a5,0x20
 76c:	fff7c793          	not	a5,a5
 770:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 772:	15fd                	addi	a1,a1,-1
 774:	177d                	addi	a4,a4,-1
 776:	0005c683          	lbu	a3,0(a1)
 77a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 77e:	fee79ae3          	bne	a5,a4,772 <memmove+0x46>
 782:	bfc9                	j	754 <memmove+0x28>

0000000000000784 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 784:	1141                	addi	sp,sp,-16
 786:	e422                	sd	s0,8(sp)
 788:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 78a:	ca05                	beqz	a2,7ba <memcmp+0x36>
 78c:	fff6069b          	addiw	a3,a2,-1
 790:	1682                	slli	a3,a3,0x20
 792:	9281                	srli	a3,a3,0x20
 794:	0685                	addi	a3,a3,1
 796:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 798:	00054783          	lbu	a5,0(a0)
 79c:	0005c703          	lbu	a4,0(a1)
 7a0:	00e79863          	bne	a5,a4,7b0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7a4:	0505                	addi	a0,a0,1
    p2++;
 7a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 7a8:	fed518e3          	bne	a0,a3,798 <memcmp+0x14>
  }
  return 0;
 7ac:	4501                	li	a0,0
 7ae:	a019                	j	7b4 <memcmp+0x30>
      return *p1 - *p2;
 7b0:	40e7853b          	subw	a0,a5,a4
}
 7b4:	6422                	ld	s0,8(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret
  return 0;
 7ba:	4501                	li	a0,0
 7bc:	bfe5                	j	7b4 <memcmp+0x30>

00000000000007be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7be:	1141                	addi	sp,sp,-16
 7c0:	e406                	sd	ra,8(sp)
 7c2:	e022                	sd	s0,0(sp)
 7c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7c6:	00000097          	auipc	ra,0x0
 7ca:	f66080e7          	jalr	-154(ra) # 72c <memmove>
}
 7ce:	60a2                	ld	ra,8(sp)
 7d0:	6402                	ld	s0,0(sp)
 7d2:	0141                	addi	sp,sp,16
 7d4:	8082                	ret

00000000000007d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7d6:	4885                	li	a7,1
 ecall
 7d8:	00000073          	ecall
 ret
 7dc:	8082                	ret

00000000000007de <exit>:
.global exit
exit:
 li a7, SYS_exit
 7de:	4889                	li	a7,2
 ecall
 7e0:	00000073          	ecall
 ret
 7e4:	8082                	ret

00000000000007e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7e6:	488d                	li	a7,3
 ecall
 7e8:	00000073          	ecall
 ret
 7ec:	8082                	ret

00000000000007ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7ee:	4891                	li	a7,4
 ecall
 7f0:	00000073          	ecall
 ret
 7f4:	8082                	ret

00000000000007f6 <read>:
.global read
read:
 li a7, SYS_read
 7f6:	4895                	li	a7,5
 ecall
 7f8:	00000073          	ecall
 ret
 7fc:	8082                	ret

00000000000007fe <write>:
.global write
write:
 li a7, SYS_write
 7fe:	48c1                	li	a7,16
 ecall
 800:	00000073          	ecall
 ret
 804:	8082                	ret

0000000000000806 <close>:
.global close
close:
 li a7, SYS_close
 806:	48d5                	li	a7,21
 ecall
 808:	00000073          	ecall
 ret
 80c:	8082                	ret

000000000000080e <kill>:
.global kill
kill:
 li a7, SYS_kill
 80e:	4899                	li	a7,6
 ecall
 810:	00000073          	ecall
 ret
 814:	8082                	ret

0000000000000816 <exec>:
.global exec
exec:
 li a7, SYS_exec
 816:	489d                	li	a7,7
 ecall
 818:	00000073          	ecall
 ret
 81c:	8082                	ret

000000000000081e <open>:
.global open
open:
 li a7, SYS_open
 81e:	48bd                	li	a7,15
 ecall
 820:	00000073          	ecall
 ret
 824:	8082                	ret

0000000000000826 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 826:	48c5                	li	a7,17
 ecall
 828:	00000073          	ecall
 ret
 82c:	8082                	ret

000000000000082e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 82e:	48c9                	li	a7,18
 ecall
 830:	00000073          	ecall
 ret
 834:	8082                	ret

0000000000000836 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 836:	48a1                	li	a7,8
 ecall
 838:	00000073          	ecall
 ret
 83c:	8082                	ret

000000000000083e <link>:
.global link
link:
 li a7, SYS_link
 83e:	48cd                	li	a7,19
 ecall
 840:	00000073          	ecall
 ret
 844:	8082                	ret

0000000000000846 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 846:	48d1                	li	a7,20
 ecall
 848:	00000073          	ecall
 ret
 84c:	8082                	ret

000000000000084e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 84e:	48a5                	li	a7,9
 ecall
 850:	00000073          	ecall
 ret
 854:	8082                	ret

0000000000000856 <dup>:
.global dup
dup:
 li a7, SYS_dup
 856:	48a9                	li	a7,10
 ecall
 858:	00000073          	ecall
 ret
 85c:	8082                	ret

000000000000085e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 85e:	48ad                	li	a7,11
 ecall
 860:	00000073          	ecall
 ret
 864:	8082                	ret

0000000000000866 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 866:	48b1                	li	a7,12
 ecall
 868:	00000073          	ecall
 ret
 86c:	8082                	ret

000000000000086e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 86e:	48b5                	li	a7,13
 ecall
 870:	00000073          	ecall
 ret
 874:	8082                	ret

0000000000000876 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 876:	48b9                	li	a7,14
 ecall
 878:	00000073          	ecall
 ret
 87c:	8082                	ret

000000000000087e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 87e:	1101                	addi	sp,sp,-32
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	addi	s0,sp,32
 886:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 88a:	4605                	li	a2,1
 88c:	fef40593          	addi	a1,s0,-17
 890:	00000097          	auipc	ra,0x0
 894:	f6e080e7          	jalr	-146(ra) # 7fe <write>
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	6105                	addi	sp,sp,32
 89e:	8082                	ret

00000000000008a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8a0:	7139                	addi	sp,sp,-64
 8a2:	fc06                	sd	ra,56(sp)
 8a4:	f822                	sd	s0,48(sp)
 8a6:	f426                	sd	s1,40(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	0080                	addi	s0,sp,64
 8ae:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8b0:	c299                	beqz	a3,8b6 <printint+0x16>
 8b2:	0805c963          	bltz	a1,944 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8b6:	2581                	sext.w	a1,a1
  neg = 0;
 8b8:	4881                	li	a7,0
 8ba:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8be:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8c0:	2601                	sext.w	a2,a2
 8c2:	00000517          	auipc	a0,0x0
 8c6:	64650513          	addi	a0,a0,1606 # f08 <digits>
 8ca:	883a                	mv	a6,a4
 8cc:	2705                	addiw	a4,a4,1
 8ce:	02c5f7bb          	remuw	a5,a1,a2
 8d2:	1782                	slli	a5,a5,0x20
 8d4:	9381                	srli	a5,a5,0x20
 8d6:	97aa                	add	a5,a5,a0
 8d8:	0007c783          	lbu	a5,0(a5)
 8dc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8e0:	0005879b          	sext.w	a5,a1
 8e4:	02c5d5bb          	divuw	a1,a1,a2
 8e8:	0685                	addi	a3,a3,1
 8ea:	fec7f0e3          	bgeu	a5,a2,8ca <printint+0x2a>
  if(neg)
 8ee:	00088c63          	beqz	a7,906 <printint+0x66>
    buf[i++] = '-';
 8f2:	fd070793          	addi	a5,a4,-48
 8f6:	00878733          	add	a4,a5,s0
 8fa:	02d00793          	li	a5,45
 8fe:	fef70823          	sb	a5,-16(a4)
 902:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 906:	02e05863          	blez	a4,936 <printint+0x96>
 90a:	fc040793          	addi	a5,s0,-64
 90e:	00e78933          	add	s2,a5,a4
 912:	fff78993          	addi	s3,a5,-1
 916:	99ba                	add	s3,s3,a4
 918:	377d                	addiw	a4,a4,-1
 91a:	1702                	slli	a4,a4,0x20
 91c:	9301                	srli	a4,a4,0x20
 91e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 922:	fff94583          	lbu	a1,-1(s2)
 926:	8526                	mv	a0,s1
 928:	00000097          	auipc	ra,0x0
 92c:	f56080e7          	jalr	-170(ra) # 87e <putc>
  while(--i >= 0)
 930:	197d                	addi	s2,s2,-1
 932:	ff3918e3          	bne	s2,s3,922 <printint+0x82>
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	74a2                	ld	s1,40(sp)
 93c:	7902                	ld	s2,32(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
    x = -xx;
 944:	40b005bb          	negw	a1,a1
    neg = 1;
 948:	4885                	li	a7,1
    x = -xx;
 94a:	bf85                	j	8ba <printint+0x1a>

000000000000094c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 94c:	715d                	addi	sp,sp,-80
 94e:	e486                	sd	ra,72(sp)
 950:	e0a2                	sd	s0,64(sp)
 952:	fc26                	sd	s1,56(sp)
 954:	f84a                	sd	s2,48(sp)
 956:	f44e                	sd	s3,40(sp)
 958:	f052                	sd	s4,32(sp)
 95a:	ec56                	sd	s5,24(sp)
 95c:	e85a                	sd	s6,16(sp)
 95e:	e45e                	sd	s7,8(sp)
 960:	e062                	sd	s8,0(sp)
 962:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 964:	0005c903          	lbu	s2,0(a1)
 968:	18090c63          	beqz	s2,b00 <vprintf+0x1b4>
 96c:	8aaa                	mv	s5,a0
 96e:	8bb2                	mv	s7,a2
 970:	00158493          	addi	s1,a1,1
  state = 0;
 974:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 976:	02500a13          	li	s4,37
 97a:	4b55                	li	s6,21
 97c:	a839                	j	99a <vprintf+0x4e>
        putc(fd, c);
 97e:	85ca                	mv	a1,s2
 980:	8556                	mv	a0,s5
 982:	00000097          	auipc	ra,0x0
 986:	efc080e7          	jalr	-260(ra) # 87e <putc>
 98a:	a019                	j	990 <vprintf+0x44>
    } else if(state == '%'){
 98c:	01498d63          	beq	s3,s4,9a6 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 990:	0485                	addi	s1,s1,1
 992:	fff4c903          	lbu	s2,-1(s1)
 996:	16090563          	beqz	s2,b00 <vprintf+0x1b4>
    if(state == 0){
 99a:	fe0999e3          	bnez	s3,98c <vprintf+0x40>
      if(c == '%'){
 99e:	ff4910e3          	bne	s2,s4,97e <vprintf+0x32>
        state = '%';
 9a2:	89d2                	mv	s3,s4
 9a4:	b7f5                	j	990 <vprintf+0x44>
      if(c == 'd'){
 9a6:	13490263          	beq	s2,s4,aca <vprintf+0x17e>
 9aa:	f9d9079b          	addiw	a5,s2,-99
 9ae:	0ff7f793          	zext.b	a5,a5
 9b2:	12fb6563          	bltu	s6,a5,adc <vprintf+0x190>
 9b6:	f9d9079b          	addiw	a5,s2,-99
 9ba:	0ff7f713          	zext.b	a4,a5
 9be:	10eb6f63          	bltu	s6,a4,adc <vprintf+0x190>
 9c2:	00271793          	slli	a5,a4,0x2
 9c6:	00000717          	auipc	a4,0x0
 9ca:	4ea70713          	addi	a4,a4,1258 # eb0 <statistics+0x1cc>
 9ce:	97ba                	add	a5,a5,a4
 9d0:	439c                	lw	a5,0(a5)
 9d2:	97ba                	add	a5,a5,a4
 9d4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 9d6:	008b8913          	addi	s2,s7,8
 9da:	4685                	li	a3,1
 9dc:	4629                	li	a2,10
 9de:	000ba583          	lw	a1,0(s7)
 9e2:	8556                	mv	a0,s5
 9e4:	00000097          	auipc	ra,0x0
 9e8:	ebc080e7          	jalr	-324(ra) # 8a0 <printint>
 9ec:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9ee:	4981                	li	s3,0
 9f0:	b745                	j	990 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f2:	008b8913          	addi	s2,s7,8
 9f6:	4681                	li	a3,0
 9f8:	4629                	li	a2,10
 9fa:	000ba583          	lw	a1,0(s7)
 9fe:	8556                	mv	a0,s5
 a00:	00000097          	auipc	ra,0x0
 a04:	ea0080e7          	jalr	-352(ra) # 8a0 <printint>
 a08:	8bca                	mv	s7,s2
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b751                	j	990 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 a0e:	008b8913          	addi	s2,s7,8
 a12:	4681                	li	a3,0
 a14:	4641                	li	a2,16
 a16:	000ba583          	lw	a1,0(s7)
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e84080e7          	jalr	-380(ra) # 8a0 <printint>
 a24:	8bca                	mv	s7,s2
      state = 0;
 a26:	4981                	li	s3,0
 a28:	b7a5                	j	990 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 a2a:	008b8c13          	addi	s8,s7,8
 a2e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a32:	03000593          	li	a1,48
 a36:	8556                	mv	a0,s5
 a38:	00000097          	auipc	ra,0x0
 a3c:	e46080e7          	jalr	-442(ra) # 87e <putc>
  putc(fd, 'x');
 a40:	07800593          	li	a1,120
 a44:	8556                	mv	a0,s5
 a46:	00000097          	auipc	ra,0x0
 a4a:	e38080e7          	jalr	-456(ra) # 87e <putc>
 a4e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a50:	00000b97          	auipc	s7,0x0
 a54:	4b8b8b93          	addi	s7,s7,1208 # f08 <digits>
 a58:	03c9d793          	srli	a5,s3,0x3c
 a5c:	97de                	add	a5,a5,s7
 a5e:	0007c583          	lbu	a1,0(a5)
 a62:	8556                	mv	a0,s5
 a64:	00000097          	auipc	ra,0x0
 a68:	e1a080e7          	jalr	-486(ra) # 87e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a6c:	0992                	slli	s3,s3,0x4
 a6e:	397d                	addiw	s2,s2,-1
 a70:	fe0914e3          	bnez	s2,a58 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 a74:	8be2                	mv	s7,s8
      state = 0;
 a76:	4981                	li	s3,0
 a78:	bf21                	j	990 <vprintf+0x44>
        s = va_arg(ap, char*);
 a7a:	008b8993          	addi	s3,s7,8
 a7e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 a82:	02090163          	beqz	s2,aa4 <vprintf+0x158>
        while(*s != 0){
 a86:	00094583          	lbu	a1,0(s2)
 a8a:	c9a5                	beqz	a1,afa <vprintf+0x1ae>
          putc(fd, *s);
 a8c:	8556                	mv	a0,s5
 a8e:	00000097          	auipc	ra,0x0
 a92:	df0080e7          	jalr	-528(ra) # 87e <putc>
          s++;
 a96:	0905                	addi	s2,s2,1
        while(*s != 0){
 a98:	00094583          	lbu	a1,0(s2)
 a9c:	f9e5                	bnez	a1,a8c <vprintf+0x140>
        s = va_arg(ap, char*);
 a9e:	8bce                	mv	s7,s3
      state = 0;
 aa0:	4981                	li	s3,0
 aa2:	b5fd                	j	990 <vprintf+0x44>
          s = "(null)";
 aa4:	00000917          	auipc	s2,0x0
 aa8:	40490913          	addi	s2,s2,1028 # ea8 <statistics+0x1c4>
        while(*s != 0){
 aac:	02800593          	li	a1,40
 ab0:	bff1                	j	a8c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 ab2:	008b8913          	addi	s2,s7,8
 ab6:	000bc583          	lbu	a1,0(s7)
 aba:	8556                	mv	a0,s5
 abc:	00000097          	auipc	ra,0x0
 ac0:	dc2080e7          	jalr	-574(ra) # 87e <putc>
 ac4:	8bca                	mv	s7,s2
      state = 0;
 ac6:	4981                	li	s3,0
 ac8:	b5e1                	j	990 <vprintf+0x44>
        putc(fd, c);
 aca:	02500593          	li	a1,37
 ace:	8556                	mv	a0,s5
 ad0:	00000097          	auipc	ra,0x0
 ad4:	dae080e7          	jalr	-594(ra) # 87e <putc>
      state = 0;
 ad8:	4981                	li	s3,0
 ada:	bd5d                	j	990 <vprintf+0x44>
        putc(fd, '%');
 adc:	02500593          	li	a1,37
 ae0:	8556                	mv	a0,s5
 ae2:	00000097          	auipc	ra,0x0
 ae6:	d9c080e7          	jalr	-612(ra) # 87e <putc>
        putc(fd, c);
 aea:	85ca                	mv	a1,s2
 aec:	8556                	mv	a0,s5
 aee:	00000097          	auipc	ra,0x0
 af2:	d90080e7          	jalr	-624(ra) # 87e <putc>
      state = 0;
 af6:	4981                	li	s3,0
 af8:	bd61                	j	990 <vprintf+0x44>
        s = va_arg(ap, char*);
 afa:	8bce                	mv	s7,s3
      state = 0;
 afc:	4981                	li	s3,0
 afe:	bd49                	j	990 <vprintf+0x44>
    }
  }
}
 b00:	60a6                	ld	ra,72(sp)
 b02:	6406                	ld	s0,64(sp)
 b04:	74e2                	ld	s1,56(sp)
 b06:	7942                	ld	s2,48(sp)
 b08:	79a2                	ld	s3,40(sp)
 b0a:	7a02                	ld	s4,32(sp)
 b0c:	6ae2                	ld	s5,24(sp)
 b0e:	6b42                	ld	s6,16(sp)
 b10:	6ba2                	ld	s7,8(sp)
 b12:	6c02                	ld	s8,0(sp)
 b14:	6161                	addi	sp,sp,80
 b16:	8082                	ret

0000000000000b18 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b18:	715d                	addi	sp,sp,-80
 b1a:	ec06                	sd	ra,24(sp)
 b1c:	e822                	sd	s0,16(sp)
 b1e:	1000                	addi	s0,sp,32
 b20:	e010                	sd	a2,0(s0)
 b22:	e414                	sd	a3,8(s0)
 b24:	e818                	sd	a4,16(s0)
 b26:	ec1c                	sd	a5,24(s0)
 b28:	03043023          	sd	a6,32(s0)
 b2c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b30:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b34:	8622                	mv	a2,s0
 b36:	00000097          	auipc	ra,0x0
 b3a:	e16080e7          	jalr	-490(ra) # 94c <vprintf>
}
 b3e:	60e2                	ld	ra,24(sp)
 b40:	6442                	ld	s0,16(sp)
 b42:	6161                	addi	sp,sp,80
 b44:	8082                	ret

0000000000000b46 <printf>:

void
printf(const char *fmt, ...)
{
 b46:	711d                	addi	sp,sp,-96
 b48:	ec06                	sd	ra,24(sp)
 b4a:	e822                	sd	s0,16(sp)
 b4c:	1000                	addi	s0,sp,32
 b4e:	e40c                	sd	a1,8(s0)
 b50:	e810                	sd	a2,16(s0)
 b52:	ec14                	sd	a3,24(s0)
 b54:	f018                	sd	a4,32(s0)
 b56:	f41c                	sd	a5,40(s0)
 b58:	03043823          	sd	a6,48(s0)
 b5c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b60:	00840613          	addi	a2,s0,8
 b64:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b68:	85aa                	mv	a1,a0
 b6a:	4505                	li	a0,1
 b6c:	00000097          	auipc	ra,0x0
 b70:	de0080e7          	jalr	-544(ra) # 94c <vprintf>
}
 b74:	60e2                	ld	ra,24(sp)
 b76:	6442                	ld	s0,16(sp)
 b78:	6125                	addi	sp,sp,96
 b7a:	8082                	ret

0000000000000b7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b7c:	1141                	addi	sp,sp,-16
 b7e:	e422                	sd	s0,8(sp)
 b80:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b82:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b86:	00000797          	auipc	a5,0x0
 b8a:	47a7b783          	ld	a5,1146(a5) # 1000 <freep>
 b8e:	a02d                	j	bb8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b90:	4618                	lw	a4,8(a2)
 b92:	9f2d                	addw	a4,a4,a1
 b94:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b98:	6398                	ld	a4,0(a5)
 b9a:	6310                	ld	a2,0(a4)
 b9c:	a83d                	j	bda <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b9e:	ff852703          	lw	a4,-8(a0)
 ba2:	9f31                	addw	a4,a4,a2
 ba4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ba6:	ff053683          	ld	a3,-16(a0)
 baa:	a091                	j	bee <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bac:	6398                	ld	a4,0(a5)
 bae:	00e7e463          	bltu	a5,a4,bb6 <free+0x3a>
 bb2:	00e6ea63          	bltu	a3,a4,bc6 <free+0x4a>
{
 bb6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb8:	fed7fae3          	bgeu	a5,a3,bac <free+0x30>
 bbc:	6398                	ld	a4,0(a5)
 bbe:	00e6e463          	bltu	a3,a4,bc6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc2:	fee7eae3          	bltu	a5,a4,bb6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bc6:	ff852583          	lw	a1,-8(a0)
 bca:	6390                	ld	a2,0(a5)
 bcc:	02059813          	slli	a6,a1,0x20
 bd0:	01c85713          	srli	a4,a6,0x1c
 bd4:	9736                	add	a4,a4,a3
 bd6:	fae60de3          	beq	a2,a4,b90 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bda:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bde:	4790                	lw	a2,8(a5)
 be0:	02061593          	slli	a1,a2,0x20
 be4:	01c5d713          	srli	a4,a1,0x1c
 be8:	973e                	add	a4,a4,a5
 bea:	fae68ae3          	beq	a3,a4,b9e <free+0x22>
    p->s.ptr = bp->s.ptr;
 bee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bf0:	00000717          	auipc	a4,0x0
 bf4:	40f73823          	sd	a5,1040(a4) # 1000 <freep>
}
 bf8:	6422                	ld	s0,8(sp)
 bfa:	0141                	addi	sp,sp,16
 bfc:	8082                	ret

0000000000000bfe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bfe:	7139                	addi	sp,sp,-64
 c00:	fc06                	sd	ra,56(sp)
 c02:	f822                	sd	s0,48(sp)
 c04:	f426                	sd	s1,40(sp)
 c06:	f04a                	sd	s2,32(sp)
 c08:	ec4e                	sd	s3,24(sp)
 c0a:	e852                	sd	s4,16(sp)
 c0c:	e456                	sd	s5,8(sp)
 c0e:	e05a                	sd	s6,0(sp)
 c10:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c12:	02051493          	slli	s1,a0,0x20
 c16:	9081                	srli	s1,s1,0x20
 c18:	04bd                	addi	s1,s1,15
 c1a:	8091                	srli	s1,s1,0x4
 c1c:	0014899b          	addiw	s3,s1,1
 c20:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c22:	00000517          	auipc	a0,0x0
 c26:	3de53503          	ld	a0,990(a0) # 1000 <freep>
 c2a:	c515                	beqz	a0,c56 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c2e:	4798                	lw	a4,8(a5)
 c30:	02977f63          	bgeu	a4,s1,c6e <malloc+0x70>
  if(nu < 4096)
 c34:	8a4e                	mv	s4,s3
 c36:	0009871b          	sext.w	a4,s3
 c3a:	6685                	lui	a3,0x1
 c3c:	00d77363          	bgeu	a4,a3,c42 <malloc+0x44>
 c40:	6a05                	lui	s4,0x1
 c42:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c46:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c4a:	00000917          	auipc	s2,0x0
 c4e:	3b690913          	addi	s2,s2,950 # 1000 <freep>
  if(p == (char*)-1)
 c52:	5afd                	li	s5,-1
 c54:	a895                	j	cc8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 c56:	00001797          	auipc	a5,0x1
 c5a:	3ba78793          	addi	a5,a5,954 # 2010 <base>
 c5e:	00000717          	auipc	a4,0x0
 c62:	3af73123          	sd	a5,930(a4) # 1000 <freep>
 c66:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c68:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c6c:	b7e1                	j	c34 <malloc+0x36>
      if(p->s.size == nunits)
 c6e:	02e48c63          	beq	s1,a4,ca6 <malloc+0xa8>
        p->s.size -= nunits;
 c72:	4137073b          	subw	a4,a4,s3
 c76:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c78:	02071693          	slli	a3,a4,0x20
 c7c:	01c6d713          	srli	a4,a3,0x1c
 c80:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c82:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c86:	00000717          	auipc	a4,0x0
 c8a:	36a73d23          	sd	a0,890(a4) # 1000 <freep>
      return (void*)(p + 1);
 c8e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c92:	70e2                	ld	ra,56(sp)
 c94:	7442                	ld	s0,48(sp)
 c96:	74a2                	ld	s1,40(sp)
 c98:	7902                	ld	s2,32(sp)
 c9a:	69e2                	ld	s3,24(sp)
 c9c:	6a42                	ld	s4,16(sp)
 c9e:	6aa2                	ld	s5,8(sp)
 ca0:	6b02                	ld	s6,0(sp)
 ca2:	6121                	addi	sp,sp,64
 ca4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ca6:	6398                	ld	a4,0(a5)
 ca8:	e118                	sd	a4,0(a0)
 caa:	bff1                	j	c86 <malloc+0x88>
  hp->s.size = nu;
 cac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cb0:	0541                	addi	a0,a0,16
 cb2:	00000097          	auipc	ra,0x0
 cb6:	eca080e7          	jalr	-310(ra) # b7c <free>
  return freep;
 cba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cbe:	d971                	beqz	a0,c92 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc2:	4798                	lw	a4,8(a5)
 cc4:	fa9775e3          	bgeu	a4,s1,c6e <malloc+0x70>
    if(p == freep)
 cc8:	00093703          	ld	a4,0(s2)
 ccc:	853e                	mv	a0,a5
 cce:	fef719e3          	bne	a4,a5,cc0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 cd2:	8552                	mv	a0,s4
 cd4:	00000097          	auipc	ra,0x0
 cd8:	b92080e7          	jalr	-1134(ra) # 866 <sbrk>
  if(p == (char*)-1)
 cdc:	fd5518e3          	bne	a0,s5,cac <malloc+0xae>
        return 0;
 ce0:	4501                	li	a0,0
 ce2:	bf45                	j	c92 <malloc+0x94>

0000000000000ce4 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 ce4:	7179                	addi	sp,sp,-48
 ce6:	f406                	sd	ra,40(sp)
 ce8:	f022                	sd	s0,32(sp)
 cea:	ec26                	sd	s1,24(sp)
 cec:	e84a                	sd	s2,16(sp)
 cee:	e44e                	sd	s3,8(sp)
 cf0:	e052                	sd	s4,0(sp)
 cf2:	1800                	addi	s0,sp,48
 cf4:	8a2a                	mv	s4,a0
 cf6:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 cf8:	4581                	li	a1,0
 cfa:	00000517          	auipc	a0,0x0
 cfe:	22650513          	addi	a0,a0,550 # f20 <digits+0x18>
 d02:	00000097          	auipc	ra,0x0
 d06:	b1c080e7          	jalr	-1252(ra) # 81e <open>
  if(fd < 0) {
 d0a:	04054263          	bltz	a0,d4e <statistics+0x6a>
 d0e:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 d10:	4481                	li	s1,0
 d12:	03205063          	blez	s2,d32 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 d16:	4099063b          	subw	a2,s2,s1
 d1a:	009a05b3          	add	a1,s4,s1
 d1e:	854e                	mv	a0,s3
 d20:	00000097          	auipc	ra,0x0
 d24:	ad6080e7          	jalr	-1322(ra) # 7f6 <read>
 d28:	00054563          	bltz	a0,d32 <statistics+0x4e>
      break;
    }
    i += n;
 d2c:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 d2e:	ff24c4e3          	blt	s1,s2,d16 <statistics+0x32>
  }
  close(fd);
 d32:	854e                	mv	a0,s3
 d34:	00000097          	auipc	ra,0x0
 d38:	ad2080e7          	jalr	-1326(ra) # 806 <close>
  return i;
}
 d3c:	8526                	mv	a0,s1
 d3e:	70a2                	ld	ra,40(sp)
 d40:	7402                	ld	s0,32(sp)
 d42:	64e2                	ld	s1,24(sp)
 d44:	6942                	ld	s2,16(sp)
 d46:	69a2                	ld	s3,8(sp)
 d48:	6a02                	ld	s4,0(sp)
 d4a:	6145                	addi	sp,sp,48
 d4c:	8082                	ret
      fprintf(2, "stats: open failed\n");
 d4e:	00000597          	auipc	a1,0x0
 d52:	1e258593          	addi	a1,a1,482 # f30 <digits+0x28>
 d56:	4509                	li	a0,2
 d58:	00000097          	auipc	ra,0x0
 d5c:	dc0080e7          	jalr	-576(ra) # b18 <fprintf>
      exit(1);
 d60:	4505                	li	a0,1
 d62:	00000097          	auipc	ra,0x0
 d66:	a7c080e7          	jalr	-1412(ra) # 7de <exit>
