
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	6585                	lui	a1,0x1
   e:	80058593          	addi	a1,a1,-2048 # 800 <gets+0x5e>
  12:	00001097          	auipc	ra,0x1
  16:	984080e7          	jalr	-1660(ra) # 996 <open>
  if(fd < 0)
  1a:	02054063          	bltz	a0,3a <stat_slink+0x3a>
    return -1;
  if(fstat(fd, st) != 0)
  1e:	85a6                	mv	a1,s1
  20:	00001097          	auipc	ra,0x1
  24:	98e080e7          	jalr	-1650(ra) # 9ae <fstat>
  28:	00a03533          	snez	a0,a0
  2c:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  30:	60e2                	ld	ra,24(sp)
  32:	6442                	ld	s0,16(sp)
  34:	64a2                	ld	s1,8(sp)
  36:	6105                	addi	sp,sp,32
  38:	8082                	ret
    return -1;
  3a:	557d                	li	a0,-1
  3c:	bfd5                	j	30 <stat_slink+0x30>

000000000000003e <main>:
{
  3e:	7119                	addi	sp,sp,-128
  40:	fc86                	sd	ra,120(sp)
  42:	f8a2                	sd	s0,112(sp)
  44:	f4a6                	sd	s1,104(sp)
  46:	f0ca                	sd	s2,96(sp)
  48:	ecce                	sd	s3,88(sp)
  4a:	e8d2                	sd	s4,80(sp)
  4c:	e4d6                	sd	s5,72(sp)
  4e:	e0da                	sd	s6,64(sp)
  50:	fc5e                	sd	s7,56(sp)
  52:	f862                	sd	s8,48(sp)
  54:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  56:	00001517          	auipc	a0,0x1
  5a:	e1a50513          	addi	a0,a0,-486 # e70 <malloc+0xf2>
  5e:	00001097          	auipc	ra,0x1
  62:	948080e7          	jalr	-1720(ra) # 9a6 <unlink>
  unlink("/testsymlink/b");
  66:	00001517          	auipc	a0,0x1
  6a:	e1a50513          	addi	a0,a0,-486 # e80 <malloc+0x102>
  6e:	00001097          	auipc	ra,0x1
  72:	938080e7          	jalr	-1736(ra) # 9a6 <unlink>
  unlink("/testsymlink/c");
  76:	00001517          	auipc	a0,0x1
  7a:	e1a50513          	addi	a0,a0,-486 # e90 <malloc+0x112>
  7e:	00001097          	auipc	ra,0x1
  82:	928080e7          	jalr	-1752(ra) # 9a6 <unlink>
  unlink("/testsymlink/1");
  86:	00001517          	auipc	a0,0x1
  8a:	e1a50513          	addi	a0,a0,-486 # ea0 <malloc+0x122>
  8e:	00001097          	auipc	ra,0x1
  92:	918080e7          	jalr	-1768(ra) # 9a6 <unlink>
  unlink("/testsymlink/2");
  96:	00001517          	auipc	a0,0x1
  9a:	e1a50513          	addi	a0,a0,-486 # eb0 <malloc+0x132>
  9e:	00001097          	auipc	ra,0x1
  a2:	908080e7          	jalr	-1784(ra) # 9a6 <unlink>
  unlink("/testsymlink/3");
  a6:	00001517          	auipc	a0,0x1
  aa:	e1a50513          	addi	a0,a0,-486 # ec0 <malloc+0x142>
  ae:	00001097          	auipc	ra,0x1
  b2:	8f8080e7          	jalr	-1800(ra) # 9a6 <unlink>
  unlink("/testsymlink/4");
  b6:	00001517          	auipc	a0,0x1
  ba:	e1a50513          	addi	a0,a0,-486 # ed0 <malloc+0x152>
  be:	00001097          	auipc	ra,0x1
  c2:	8e8080e7          	jalr	-1816(ra) # 9a6 <unlink>
  unlink("/testsymlink/z");
  c6:	00001517          	auipc	a0,0x1
  ca:	e1a50513          	addi	a0,a0,-486 # ee0 <malloc+0x162>
  ce:	00001097          	auipc	ra,0x1
  d2:	8d8080e7          	jalr	-1832(ra) # 9a6 <unlink>
  unlink("/testsymlink/y");
  d6:	00001517          	auipc	a0,0x1
  da:	e1a50513          	addi	a0,a0,-486 # ef0 <malloc+0x172>
  de:	00001097          	auipc	ra,0x1
  e2:	8c8080e7          	jalr	-1848(ra) # 9a6 <unlink>
  unlink("/testsymlink");
  e6:	00001517          	auipc	a0,0x1
  ea:	e1a50513          	addi	a0,a0,-486 # f00 <malloc+0x182>
  ee:	00001097          	auipc	ra,0x1
  f2:	8b8080e7          	jalr	-1864(ra) # 9a6 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f6:	646367b7          	lui	a5,0x64636
  fa:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
  fe:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
 102:	f8040723          	sb	zero,-114(s0)
 106:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	e0650513          	addi	a0,a0,-506 # f10 <malloc+0x192>
 112:	00001097          	auipc	ra,0x1
 116:	bb4080e7          	jalr	-1100(ra) # cc6 <printf>

  mkdir("/testsymlink");
 11a:	00001517          	auipc	a0,0x1
 11e:	de650513          	addi	a0,a0,-538 # f00 <malloc+0x182>
 122:	00001097          	auipc	ra,0x1
 126:	89c080e7          	jalr	-1892(ra) # 9be <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 12a:	20200593          	li	a1,514
 12e:	00001517          	auipc	a0,0x1
 132:	d4250513          	addi	a0,a0,-702 # e70 <malloc+0xf2>
 136:	00001097          	auipc	ra,0x1
 13a:	860080e7          	jalr	-1952(ra) # 996 <open>
 13e:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 140:	0e054f63          	bltz	a0,23e <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 144:	00001597          	auipc	a1,0x1
 148:	d3c58593          	addi	a1,a1,-708 # e80 <malloc+0x102>
 14c:	00001517          	auipc	a0,0x1
 150:	d2450513          	addi	a0,a0,-732 # e70 <malloc+0xf2>
 154:	00001097          	auipc	ra,0x1
 158:	8a2080e7          	jalr	-1886(ra) # 9f6 <symlink>
  if(r < 0)
 15c:	10054063          	bltz	a0,25c <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 160:	4611                	li	a2,4
 162:	f9040593          	addi	a1,s0,-112
 166:	8526                	mv	a0,s1
 168:	00001097          	auipc	ra,0x1
 16c:	80e080e7          	jalr	-2034(ra) # 976 <write>
 170:	4791                	li	a5,4
 172:	10f50463          	beq	a0,a5,27a <main+0x23c>
    fail("failed to write to a");
 176:	00001517          	auipc	a0,0x1
 17a:	df250513          	addi	a0,a0,-526 # f68 <malloc+0x1ea>
 17e:	00001097          	auipc	ra,0x1
 182:	b48080e7          	jalr	-1208(ra) # cc6 <printf>
 186:	4785                	li	a5,1
 188:	00002717          	auipc	a4,0x2
 18c:	e6f72c23          	sw	a5,-392(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 190:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	7ea080e7          	jalr	2026(ra) # 97e <close>
  close(fd2);
 19c:	854a                	mv	a0,s2
 19e:	00000097          	auipc	ra,0x0
 1a2:	7e0080e7          	jalr	2016(ra) # 97e <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a6:	00001517          	auipc	a0,0x1
 1aa:	0a250513          	addi	a0,a0,162 # 1248 <malloc+0x4ca>
 1ae:	00001097          	auipc	ra,0x1
 1b2:	b18080e7          	jalr	-1256(ra) # cc6 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b6:	20200593          	li	a1,514
 1ba:	00001517          	auipc	a0,0x1
 1be:	d2650513          	addi	a0,a0,-730 # ee0 <malloc+0x162>
 1c2:	00000097          	auipc	ra,0x0
 1c6:	7d4080e7          	jalr	2004(ra) # 996 <open>
  if(fd < 0) {
 1ca:	42054263          	bltz	a0,5ee <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1ce:	00000097          	auipc	ra,0x0
 1d2:	7b0080e7          	jalr	1968(ra) # 97e <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d6:	00000097          	auipc	ra,0x0
 1da:	778080e7          	jalr	1912(ra) # 94e <fork>
    if(pid < 0){
 1de:	42054563          	bltz	a0,608 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1e2:	44050063          	beqz	a0,622 <main+0x5e4>
    pid = fork();
 1e6:	00000097          	auipc	ra,0x0
 1ea:	768080e7          	jalr	1896(ra) # 94e <fork>
    if(pid < 0){
 1ee:	40054d63          	bltz	a0,608 <main+0x5ca>
    if(pid == 0) {
 1f2:	42050863          	beqz	a0,622 <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f6:	f9840513          	addi	a0,s0,-104
 1fa:	00000097          	auipc	ra,0x0
 1fe:	764080e7          	jalr	1892(ra) # 95e <wait>
    if(r != 0) {
 202:	f9842783          	lw	a5,-104(s0)
 206:	4a079863          	bnez	a5,6b6 <main+0x678>
    wait(&r);
 20a:	f9840513          	addi	a0,s0,-104
 20e:	00000097          	auipc	ra,0x0
 212:	750080e7          	jalr	1872(ra) # 95e <wait>
    if(r != 0) {
 216:	f9842783          	lw	a5,-104(s0)
 21a:	48079e63          	bnez	a5,6b6 <main+0x678>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21e:	00001517          	auipc	a0,0x1
 222:	0ca50513          	addi	a0,a0,202 # 12e8 <malloc+0x56a>
 226:	00001097          	auipc	ra,0x1
 22a:	aa0080e7          	jalr	-1376(ra) # cc6 <printf>
  exit(failed);
 22e:	00002517          	auipc	a0,0x2
 232:	dd252503          	lw	a0,-558(a0) # 2000 <failed>
 236:	00000097          	auipc	ra,0x0
 23a:	720080e7          	jalr	1824(ra) # 956 <exit>
  if(fd1 < 0) fail("failed to open a");
 23e:	00001517          	auipc	a0,0x1
 242:	cea50513          	addi	a0,a0,-790 # f28 <malloc+0x1aa>
 246:	00001097          	auipc	ra,0x1
 24a:	a80080e7          	jalr	-1408(ra) # cc6 <printf>
 24e:	4785                	li	a5,1
 250:	00002717          	auipc	a4,0x2
 254:	daf72823          	sw	a5,-592(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 258:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 25a:	bf25                	j	192 <main+0x154>
    fail("symlink b -> a failed");
 25c:	00001517          	auipc	a0,0x1
 260:	cec50513          	addi	a0,a0,-788 # f48 <malloc+0x1ca>
 264:	00001097          	auipc	ra,0x1
 268:	a62080e7          	jalr	-1438(ra) # cc6 <printf>
 26c:	4785                	li	a5,1
 26e:	00002717          	auipc	a4,0x2
 272:	d8f72923          	sw	a5,-622(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 276:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 278:	bf29                	j	192 <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 27a:	f9840593          	addi	a1,s0,-104
 27e:	00001517          	auipc	a0,0x1
 282:	c0250513          	addi	a0,a0,-1022 # e80 <malloc+0x102>
 286:	00000097          	auipc	ra,0x0
 28a:	d7a080e7          	jalr	-646(ra) # 0 <stat_slink>
 28e:	e50d                	bnez	a0,2b8 <main+0x27a>
  if(st.type != T_SYMLINK)
 290:	fa041703          	lh	a4,-96(s0)
 294:	4791                	li	a5,4
 296:	04f70063          	beq	a4,a5,2d6 <main+0x298>
    fail("b isn't a symlink");
 29a:	00001517          	auipc	a0,0x1
 29e:	d0e50513          	addi	a0,a0,-754 # fa8 <malloc+0x22a>
 2a2:	00001097          	auipc	ra,0x1
 2a6:	a24080e7          	jalr	-1500(ra) # cc6 <printf>
 2aa:	4785                	li	a5,1
 2ac:	00002717          	auipc	a4,0x2
 2b0:	d4f72a23          	sw	a5,-684(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b4:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b6:	bdf1                	j	192 <main+0x154>
    fail("failed to stat b");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	cd050513          	addi	a0,a0,-816 # f88 <malloc+0x20a>
 2c0:	00001097          	auipc	ra,0x1
 2c4:	a06080e7          	jalr	-1530(ra) # cc6 <printf>
 2c8:	4785                	li	a5,1
 2ca:	00002717          	auipc	a4,0x2
 2ce:	d2f72b23          	sw	a5,-714(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 2d2:	597d                	li	s2,-1
    fail("failed to stat b");
 2d4:	bd7d                	j	192 <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d6:	4589                	li	a1,2
 2d8:	00001517          	auipc	a0,0x1
 2dc:	ba850513          	addi	a0,a0,-1112 # e80 <malloc+0x102>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	6b6080e7          	jalr	1718(ra) # 996 <open>
 2e8:	892a                	mv	s2,a0
  if(fd2 < 0)
 2ea:	02054d63          	bltz	a0,324 <main+0x2e6>
  read(fd2, &c, 1);
 2ee:	4605                	li	a2,1
 2f0:	f8e40593          	addi	a1,s0,-114
 2f4:	00000097          	auipc	ra,0x0
 2f8:	67a080e7          	jalr	1658(ra) # 96e <read>
  if (c != 'a')
 2fc:	f8e44703          	lbu	a4,-114(s0)
 300:	06100793          	li	a5,97
 304:	02f70e63          	beq	a4,a5,340 <main+0x302>
    fail("failed to read bytes from b");
 308:	00001517          	auipc	a0,0x1
 30c:	ce050513          	addi	a0,a0,-800 # fe8 <malloc+0x26a>
 310:	00001097          	auipc	ra,0x1
 314:	9b6080e7          	jalr	-1610(ra) # cc6 <printf>
 318:	4785                	li	a5,1
 31a:	00002717          	auipc	a4,0x2
 31e:	cef72323          	sw	a5,-794(a4) # 2000 <failed>
 322:	bd85                	j	192 <main+0x154>
    fail("failed to open b");
 324:	00001517          	auipc	a0,0x1
 328:	ca450513          	addi	a0,a0,-860 # fc8 <malloc+0x24a>
 32c:	00001097          	auipc	ra,0x1
 330:	99a080e7          	jalr	-1638(ra) # cc6 <printf>
 334:	4785                	li	a5,1
 336:	00002717          	auipc	a4,0x2
 33a:	ccf72523          	sw	a5,-822(a4) # 2000 <failed>
 33e:	bd91                	j	192 <main+0x154>
  unlink("/testsymlink/a");
 340:	00001517          	auipc	a0,0x1
 344:	b3050513          	addi	a0,a0,-1232 # e70 <malloc+0xf2>
 348:	00000097          	auipc	ra,0x0
 34c:	65e080e7          	jalr	1630(ra) # 9a6 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 350:	4589                	li	a1,2
 352:	00001517          	auipc	a0,0x1
 356:	b2e50513          	addi	a0,a0,-1234 # e80 <malloc+0x102>
 35a:	00000097          	auipc	ra,0x0
 35e:	63c080e7          	jalr	1596(ra) # 996 <open>
 362:	12055263          	bgez	a0,486 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 366:	00001597          	auipc	a1,0x1
 36a:	b0a58593          	addi	a1,a1,-1270 # e70 <malloc+0xf2>
 36e:	00001517          	auipc	a0,0x1
 372:	b1250513          	addi	a0,a0,-1262 # e80 <malloc+0x102>
 376:	00000097          	auipc	ra,0x0
 37a:	680080e7          	jalr	1664(ra) # 9f6 <symlink>
  if(r < 0)
 37e:	12054263          	bltz	a0,4a2 <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 382:	4589                	li	a1,2
 384:	00001517          	auipc	a0,0x1
 388:	afc50513          	addi	a0,a0,-1284 # e80 <malloc+0x102>
 38c:	00000097          	auipc	ra,0x0
 390:	60a080e7          	jalr	1546(ra) # 996 <open>
  if(r >= 0)
 394:	12055563          	bgez	a0,4be <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 398:	00001597          	auipc	a1,0x1
 39c:	af858593          	addi	a1,a1,-1288 # e90 <malloc+0x112>
 3a0:	00001517          	auipc	a0,0x1
 3a4:	d0850513          	addi	a0,a0,-760 # 10a8 <malloc+0x32a>
 3a8:	00000097          	auipc	ra,0x0
 3ac:	64e080e7          	jalr	1614(ra) # 9f6 <symlink>
  if(r != 0)
 3b0:	12051563          	bnez	a0,4da <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b4:	00001597          	auipc	a1,0x1
 3b8:	aec58593          	addi	a1,a1,-1300 # ea0 <malloc+0x122>
 3bc:	00001517          	auipc	a0,0x1
 3c0:	af450513          	addi	a0,a0,-1292 # eb0 <malloc+0x132>
 3c4:	00000097          	auipc	ra,0x0
 3c8:	632080e7          	jalr	1586(ra) # 9f6 <symlink>
  if(r) fail("Failed to link 1->2");
 3cc:	12051563          	bnez	a0,4f6 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3d0:	00001597          	auipc	a1,0x1
 3d4:	ae058593          	addi	a1,a1,-1312 # eb0 <malloc+0x132>
 3d8:	00001517          	auipc	a0,0x1
 3dc:	ae850513          	addi	a0,a0,-1304 # ec0 <malloc+0x142>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	616080e7          	jalr	1558(ra) # 9f6 <symlink>
  if(r) fail("Failed to link 2->3");
 3e8:	12051563          	bnez	a0,512 <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3ec:	00001597          	auipc	a1,0x1
 3f0:	ad458593          	addi	a1,a1,-1324 # ec0 <malloc+0x142>
 3f4:	00001517          	auipc	a0,0x1
 3f8:	adc50513          	addi	a0,a0,-1316 # ed0 <malloc+0x152>
 3fc:	00000097          	auipc	ra,0x0
 400:	5fa080e7          	jalr	1530(ra) # 9f6 <symlink>
  if(r) fail("Failed to link 3->4");
 404:	12051563          	bnez	a0,52e <main+0x4f0>
  close(fd1);
 408:	8526                	mv	a0,s1
 40a:	00000097          	auipc	ra,0x0
 40e:	574080e7          	jalr	1396(ra) # 97e <close>
  close(fd2);
 412:	854a                	mv	a0,s2
 414:	00000097          	auipc	ra,0x0
 418:	56a080e7          	jalr	1386(ra) # 97e <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 41c:	20200593          	li	a1,514
 420:	00001517          	auipc	a0,0x1
 424:	ab050513          	addi	a0,a0,-1360 # ed0 <malloc+0x152>
 428:	00000097          	auipc	ra,0x0
 42c:	56e080e7          	jalr	1390(ra) # 996 <open>
 430:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 432:	10054c63          	bltz	a0,54a <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 436:	4589                	li	a1,2
 438:	00001517          	auipc	a0,0x1
 43c:	a6850513          	addi	a0,a0,-1432 # ea0 <malloc+0x122>
 440:	00000097          	auipc	ra,0x0
 444:	556080e7          	jalr	1366(ra) # 996 <open>
 448:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 44a:	10054e63          	bltz	a0,566 <main+0x528>
  c = '#';
 44e:	02300793          	li	a5,35
 452:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 456:	4605                	li	a2,1
 458:	f8e40593          	addi	a1,s0,-114
 45c:	00000097          	auipc	ra,0x0
 460:	51a080e7          	jalr	1306(ra) # 976 <write>
  if(r!=1) fail("Failed to write to 1\n");
 464:	4785                	li	a5,1
 466:	10f50e63          	beq	a0,a5,582 <main+0x544>
 46a:	00001517          	auipc	a0,0x1
 46e:	d3e50513          	addi	a0,a0,-706 # 11a8 <malloc+0x42a>
 472:	00001097          	auipc	ra,0x1
 476:	854080e7          	jalr	-1964(ra) # cc6 <printf>
 47a:	4785                	li	a5,1
 47c:	00002717          	auipc	a4,0x2
 480:	b8f72223          	sw	a5,-1148(a4) # 2000 <failed>
 484:	b339                	j	192 <main+0x154>
    fail("Should not be able to open b after deleting a");
 486:	00001517          	auipc	a0,0x1
 48a:	b8a50513          	addi	a0,a0,-1142 # 1010 <malloc+0x292>
 48e:	00001097          	auipc	ra,0x1
 492:	838080e7          	jalr	-1992(ra) # cc6 <printf>
 496:	4785                	li	a5,1
 498:	00002717          	auipc	a4,0x2
 49c:	b6f72423          	sw	a5,-1176(a4) # 2000 <failed>
 4a0:	b9cd                	j	192 <main+0x154>
    fail("symlink a -> b failed");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	ba650513          	addi	a0,a0,-1114 # 1048 <malloc+0x2ca>
 4aa:	00001097          	auipc	ra,0x1
 4ae:	81c080e7          	jalr	-2020(ra) # cc6 <printf>
 4b2:	4785                	li	a5,1
 4b4:	00002717          	auipc	a4,0x2
 4b8:	b4f72623          	sw	a5,-1204(a4) # 2000 <failed>
 4bc:	b9d9                	j	192 <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	baa50513          	addi	a0,a0,-1110 # 1068 <malloc+0x2ea>
 4c6:	00001097          	auipc	ra,0x1
 4ca:	800080e7          	jalr	-2048(ra) # cc6 <printf>
 4ce:	4785                	li	a5,1
 4d0:	00002717          	auipc	a4,0x2
 4d4:	b2f72823          	sw	a5,-1232(a4) # 2000 <failed>
 4d8:	b96d                	j	192 <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4da:	00001517          	auipc	a0,0x1
 4de:	bee50513          	addi	a0,a0,-1042 # 10c8 <malloc+0x34a>
 4e2:	00000097          	auipc	ra,0x0
 4e6:	7e4080e7          	jalr	2020(ra) # cc6 <printf>
 4ea:	4785                	li	a5,1
 4ec:	00002717          	auipc	a4,0x2
 4f0:	b0f72a23          	sw	a5,-1260(a4) # 2000 <failed>
 4f4:	b979                	j	192 <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f6:	00001517          	auipc	a0,0x1
 4fa:	c1250513          	addi	a0,a0,-1006 # 1108 <malloc+0x38a>
 4fe:	00000097          	auipc	ra,0x0
 502:	7c8080e7          	jalr	1992(ra) # cc6 <printf>
 506:	4785                	li	a5,1
 508:	00002717          	auipc	a4,0x2
 50c:	aef72c23          	sw	a5,-1288(a4) # 2000 <failed>
 510:	b149                	j	192 <main+0x154>
  if(r) fail("Failed to link 2->3");
 512:	00001517          	auipc	a0,0x1
 516:	c1650513          	addi	a0,a0,-1002 # 1128 <malloc+0x3aa>
 51a:	00000097          	auipc	ra,0x0
 51e:	7ac080e7          	jalr	1964(ra) # cc6 <printf>
 522:	4785                	li	a5,1
 524:	00002717          	auipc	a4,0x2
 528:	acf72e23          	sw	a5,-1316(a4) # 2000 <failed>
 52c:	b19d                	j	192 <main+0x154>
  if(r) fail("Failed to link 3->4");
 52e:	00001517          	auipc	a0,0x1
 532:	c1a50513          	addi	a0,a0,-998 # 1148 <malloc+0x3ca>
 536:	00000097          	auipc	ra,0x0
 53a:	790080e7          	jalr	1936(ra) # cc6 <printf>
 53e:	4785                	li	a5,1
 540:	00002717          	auipc	a4,0x2
 544:	acf72023          	sw	a5,-1344(a4) # 2000 <failed>
 548:	b1a9                	j	192 <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 54a:	00001517          	auipc	a0,0x1
 54e:	c1e50513          	addi	a0,a0,-994 # 1168 <malloc+0x3ea>
 552:	00000097          	auipc	ra,0x0
 556:	774080e7          	jalr	1908(ra) # cc6 <printf>
 55a:	4785                	li	a5,1
 55c:	00002717          	auipc	a4,0x2
 560:	aaf72223          	sw	a5,-1372(a4) # 2000 <failed>
 564:	b13d                	j	192 <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 566:	00001517          	auipc	a0,0x1
 56a:	c2250513          	addi	a0,a0,-990 # 1188 <malloc+0x40a>
 56e:	00000097          	auipc	ra,0x0
 572:	758080e7          	jalr	1880(ra) # cc6 <printf>
 576:	4785                	li	a5,1
 578:	00002717          	auipc	a4,0x2
 57c:	a8f72423          	sw	a5,-1400(a4) # 2000 <failed>
 580:	b909                	j	192 <main+0x154>
  r = read(fd1, &c2, 1);
 582:	4605                	li	a2,1
 584:	f8f40593          	addi	a1,s0,-113
 588:	8526                	mv	a0,s1
 58a:	00000097          	auipc	ra,0x0
 58e:	3e4080e7          	jalr	996(ra) # 96e <read>
  if(r!=1) fail("Failed to read from 4\n");
 592:	4785                	li	a5,1
 594:	02f51663          	bne	a0,a5,5c0 <main+0x582>
  if(c!=c2)
 598:	f8e44703          	lbu	a4,-114(s0)
 59c:	f8f44783          	lbu	a5,-113(s0)
 5a0:	02f70e63          	beq	a4,a5,5dc <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a4:	00001517          	auipc	a0,0x1
 5a8:	c4c50513          	addi	a0,a0,-948 # 11f0 <malloc+0x472>
 5ac:	00000097          	auipc	ra,0x0
 5b0:	71a080e7          	jalr	1818(ra) # cc6 <printf>
 5b4:	4785                	li	a5,1
 5b6:	00002717          	auipc	a4,0x2
 5ba:	a4f72523          	sw	a5,-1462(a4) # 2000 <failed>
 5be:	bed1                	j	192 <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5c0:	00001517          	auipc	a0,0x1
 5c4:	c0850513          	addi	a0,a0,-1016 # 11c8 <malloc+0x44a>
 5c8:	00000097          	auipc	ra,0x0
 5cc:	6fe080e7          	jalr	1790(ra) # cc6 <printf>
 5d0:	4785                	li	a5,1
 5d2:	00002717          	auipc	a4,0x2
 5d6:	a2f72723          	sw	a5,-1490(a4) # 2000 <failed>
 5da:	be65                	j	192 <main+0x154>
  printf("test symlinks: ok\n");
 5dc:	00001517          	auipc	a0,0x1
 5e0:	c5450513          	addi	a0,a0,-940 # 1230 <malloc+0x4b2>
 5e4:	00000097          	auipc	ra,0x0
 5e8:	6e2080e7          	jalr	1762(ra) # cc6 <printf>
 5ec:	b65d                	j	192 <main+0x154>
    printf("FAILED: open failed");
 5ee:	00001517          	auipc	a0,0x1
 5f2:	c8250513          	addi	a0,a0,-894 # 1270 <malloc+0x4f2>
 5f6:	00000097          	auipc	ra,0x0
 5fa:	6d0080e7          	jalr	1744(ra) # cc6 <printf>
    exit(1);
 5fe:	4505                	li	a0,1
 600:	00000097          	auipc	ra,0x0
 604:	356080e7          	jalr	854(ra) # 956 <exit>
      printf("FAILED: fork failed\n");
 608:	00001517          	auipc	a0,0x1
 60c:	c8050513          	addi	a0,a0,-896 # 1288 <malloc+0x50a>
 610:	00000097          	auipc	ra,0x0
 614:	6b6080e7          	jalr	1718(ra) # cc6 <printf>
      exit(1);
 618:	4505                	li	a0,1
 61a:	00000097          	auipc	ra,0x0
 61e:	33c080e7          	jalr	828(ra) # 956 <exit>
  int r, fd1 = -1, fd2 = -1;
 622:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 626:	06100913          	li	s2,97
        x = x * 1103515245 + 12345;
 62a:	41c65ab7          	lui	s5,0x41c65
 62e:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c62e5d>
 632:	6a0d                	lui	s4,0x3
 634:	039a0a1b          	addiw	s4,s4,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
 638:	4b0d                	li	s6,3
          unlink("/testsymlink/y");
 63a:	00001997          	auipc	s3,0x1
 63e:	8b698993          	addi	s3,s3,-1866 # ef0 <malloc+0x172>
          symlink("/testsymlink/z", "/testsymlink/y");
 642:	00001b97          	auipc	s7,0x1
 646:	89eb8b93          	addi	s7,s7,-1890 # ee0 <malloc+0x162>
            if(st.type != T_SYMLINK) {
 64a:	4c11                	li	s8,4
 64c:	a801                	j	65c <main+0x61e>
          unlink("/testsymlink/y");
 64e:	854e                	mv	a0,s3
 650:	00000097          	auipc	ra,0x0
 654:	356080e7          	jalr	854(ra) # 9a6 <unlink>
      for(i = 0; i < 100; i++){
 658:	34fd                	addiw	s1,s1,-1
 65a:	c8a9                	beqz	s1,6ac <main+0x66e>
        x = x * 1103515245 + 12345;
 65c:	035907bb          	mulw	a5,s2,s5
 660:	014787bb          	addw	a5,a5,s4
 664:	0007891b          	sext.w	s2,a5
        if((x % 3) == 0) {
 668:	0367f7bb          	remuw	a5,a5,s6
 66c:	f3ed                	bnez	a5,64e <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66e:	85ce                	mv	a1,s3
 670:	855e                	mv	a0,s7
 672:	00000097          	auipc	ra,0x0
 676:	384080e7          	jalr	900(ra) # 9f6 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 67a:	f9840593          	addi	a1,s0,-104
 67e:	854e                	mv	a0,s3
 680:	00000097          	auipc	ra,0x0
 684:	980080e7          	jalr	-1664(ra) # 0 <stat_slink>
 688:	f961                	bnez	a0,658 <main+0x61a>
            if(st.type != T_SYMLINK) {
 68a:	fa041583          	lh	a1,-96(s0)
 68e:	fd8585e3          	beq	a1,s8,658 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 692:	00001517          	auipc	a0,0x1
 696:	c0e50513          	addi	a0,a0,-1010 # 12a0 <malloc+0x522>
 69a:	00000097          	auipc	ra,0x0
 69e:	62c080e7          	jalr	1580(ra) # cc6 <printf>
              exit(1);
 6a2:	4505                	li	a0,1
 6a4:	00000097          	auipc	ra,0x0
 6a8:	2b2080e7          	jalr	690(ra) # 956 <exit>
      exit(0);
 6ac:	4501                	li	a0,0
 6ae:	00000097          	auipc	ra,0x0
 6b2:	2a8080e7          	jalr	680(ra) # 956 <exit>
      printf("test concurrent symlinks: failed\n");
 6b6:	00001517          	auipc	a0,0x1
 6ba:	c0a50513          	addi	a0,a0,-1014 # 12c0 <malloc+0x542>
 6be:	00000097          	auipc	ra,0x0
 6c2:	608080e7          	jalr	1544(ra) # cc6 <printf>
      exit(1);
 6c6:	4505                	li	a0,1
 6c8:	00000097          	auipc	ra,0x0
 6cc:	28e080e7          	jalr	654(ra) # 956 <exit>

00000000000006d0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 6d0:	1141                	addi	sp,sp,-16
 6d2:	e406                	sd	ra,8(sp)
 6d4:	e022                	sd	s0,0(sp)
 6d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 6d8:	00000097          	auipc	ra,0x0
 6dc:	966080e7          	jalr	-1690(ra) # 3e <main>
  exit(0);
 6e0:	4501                	li	a0,0
 6e2:	00000097          	auipc	ra,0x0
 6e6:	274080e7          	jalr	628(ra) # 956 <exit>

00000000000006ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e422                	sd	s0,8(sp)
 6ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6f0:	87aa                	mv	a5,a0
 6f2:	0585                	addi	a1,a1,1
 6f4:	0785                	addi	a5,a5,1
 6f6:	fff5c703          	lbu	a4,-1(a1)
 6fa:	fee78fa3          	sb	a4,-1(a5)
 6fe:	fb75                	bnez	a4,6f2 <strcpy+0x8>
    ;
  return os;
}
 700:	6422                	ld	s0,8(sp)
 702:	0141                	addi	sp,sp,16
 704:	8082                	ret

0000000000000706 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 70c:	00054783          	lbu	a5,0(a0)
 710:	cb91                	beqz	a5,724 <strcmp+0x1e>
 712:	0005c703          	lbu	a4,0(a1)
 716:	00f71763          	bne	a4,a5,724 <strcmp+0x1e>
    p++, q++;
 71a:	0505                	addi	a0,a0,1
 71c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 71e:	00054783          	lbu	a5,0(a0)
 722:	fbe5                	bnez	a5,712 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 724:	0005c503          	lbu	a0,0(a1)
}
 728:	40a7853b          	subw	a0,a5,a0
 72c:	6422                	ld	s0,8(sp)
 72e:	0141                	addi	sp,sp,16
 730:	8082                	ret

0000000000000732 <strlen>:

uint
strlen(const char *s)
{
 732:	1141                	addi	sp,sp,-16
 734:	e422                	sd	s0,8(sp)
 736:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 738:	00054783          	lbu	a5,0(a0)
 73c:	cf91                	beqz	a5,758 <strlen+0x26>
 73e:	0505                	addi	a0,a0,1
 740:	87aa                	mv	a5,a0
 742:	86be                	mv	a3,a5
 744:	0785                	addi	a5,a5,1
 746:	fff7c703          	lbu	a4,-1(a5)
 74a:	ff65                	bnez	a4,742 <strlen+0x10>
 74c:	40a6853b          	subw	a0,a3,a0
 750:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 752:	6422                	ld	s0,8(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret
  for(n = 0; s[n]; n++)
 758:	4501                	li	a0,0
 75a:	bfe5                	j	752 <strlen+0x20>

000000000000075c <memset>:

void*
memset(void *dst, int c, uint n)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e422                	sd	s0,8(sp)
 760:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 762:	ca19                	beqz	a2,778 <memset+0x1c>
 764:	87aa                	mv	a5,a0
 766:	1602                	slli	a2,a2,0x20
 768:	9201                	srli	a2,a2,0x20
 76a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 76e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 772:	0785                	addi	a5,a5,1
 774:	fee79de3          	bne	a5,a4,76e <memset+0x12>
  }
  return dst;
}
 778:	6422                	ld	s0,8(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

000000000000077e <strchr>:

char*
strchr(const char *s, char c)
{
 77e:	1141                	addi	sp,sp,-16
 780:	e422                	sd	s0,8(sp)
 782:	0800                	addi	s0,sp,16
  for(; *s; s++)
 784:	00054783          	lbu	a5,0(a0)
 788:	cb99                	beqz	a5,79e <strchr+0x20>
    if(*s == c)
 78a:	00f58763          	beq	a1,a5,798 <strchr+0x1a>
  for(; *s; s++)
 78e:	0505                	addi	a0,a0,1
 790:	00054783          	lbu	a5,0(a0)
 794:	fbfd                	bnez	a5,78a <strchr+0xc>
      return (char*)s;
  return 0;
 796:	4501                	li	a0,0
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret
  return 0;
 79e:	4501                	li	a0,0
 7a0:	bfe5                	j	798 <strchr+0x1a>

00000000000007a2 <gets>:

char*
gets(char *buf, int max)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec86                	sd	ra,88(sp)
 7a6:	e8a2                	sd	s0,80(sp)
 7a8:	e4a6                	sd	s1,72(sp)
 7aa:	e0ca                	sd	s2,64(sp)
 7ac:	fc4e                	sd	s3,56(sp)
 7ae:	f852                	sd	s4,48(sp)
 7b0:	f456                	sd	s5,40(sp)
 7b2:	f05a                	sd	s6,32(sp)
 7b4:	ec5e                	sd	s7,24(sp)
 7b6:	1080                	addi	s0,sp,96
 7b8:	8baa                	mv	s7,a0
 7ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7bc:	892a                	mv	s2,a0
 7be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7c0:	4aa9                	li	s5,10
 7c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7c4:	89a6                	mv	s3,s1
 7c6:	2485                	addiw	s1,s1,1
 7c8:	0344d863          	bge	s1,s4,7f8 <gets+0x56>
    cc = read(0, &c, 1);
 7cc:	4605                	li	a2,1
 7ce:	faf40593          	addi	a1,s0,-81
 7d2:	4501                	li	a0,0
 7d4:	00000097          	auipc	ra,0x0
 7d8:	19a080e7          	jalr	410(ra) # 96e <read>
    if(cc < 1)
 7dc:	00a05e63          	blez	a0,7f8 <gets+0x56>
    buf[i++] = c;
 7e0:	faf44783          	lbu	a5,-81(s0)
 7e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7e8:	01578763          	beq	a5,s5,7f6 <gets+0x54>
 7ec:	0905                	addi	s2,s2,1
 7ee:	fd679be3          	bne	a5,s6,7c4 <gets+0x22>
  for(i=0; i+1 < max; ){
 7f2:	89a6                	mv	s3,s1
 7f4:	a011                	j	7f8 <gets+0x56>
 7f6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7f8:	99de                	add	s3,s3,s7
 7fa:	00098023          	sb	zero,0(s3)
  return buf;
}
 7fe:	855e                	mv	a0,s7
 800:	60e6                	ld	ra,88(sp)
 802:	6446                	ld	s0,80(sp)
 804:	64a6                	ld	s1,72(sp)
 806:	6906                	ld	s2,64(sp)
 808:	79e2                	ld	s3,56(sp)
 80a:	7a42                	ld	s4,48(sp)
 80c:	7aa2                	ld	s5,40(sp)
 80e:	7b02                	ld	s6,32(sp)
 810:	6be2                	ld	s7,24(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <stat>:

int
stat(const char *n, struct stat *st)
{
 816:	1101                	addi	sp,sp,-32
 818:	ec06                	sd	ra,24(sp)
 81a:	e822                	sd	s0,16(sp)
 81c:	e426                	sd	s1,8(sp)
 81e:	e04a                	sd	s2,0(sp)
 820:	1000                	addi	s0,sp,32
 822:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 824:	4581                	li	a1,0
 826:	00000097          	auipc	ra,0x0
 82a:	170080e7          	jalr	368(ra) # 996 <open>
  if(fd < 0)
 82e:	02054563          	bltz	a0,858 <stat+0x42>
 832:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 834:	85ca                	mv	a1,s2
 836:	00000097          	auipc	ra,0x0
 83a:	178080e7          	jalr	376(ra) # 9ae <fstat>
 83e:	892a                	mv	s2,a0
  close(fd);
 840:	8526                	mv	a0,s1
 842:	00000097          	auipc	ra,0x0
 846:	13c080e7          	jalr	316(ra) # 97e <close>
  return r;
}
 84a:	854a                	mv	a0,s2
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	64a2                	ld	s1,8(sp)
 852:	6902                	ld	s2,0(sp)
 854:	6105                	addi	sp,sp,32
 856:	8082                	ret
    return -1;
 858:	597d                	li	s2,-1
 85a:	bfc5                	j	84a <stat+0x34>

000000000000085c <atoi>:

int
atoi(const char *s)
{
 85c:	1141                	addi	sp,sp,-16
 85e:	e422                	sd	s0,8(sp)
 860:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 862:	00054683          	lbu	a3,0(a0)
 866:	fd06879b          	addiw	a5,a3,-48
 86a:	0ff7f793          	zext.b	a5,a5
 86e:	4625                	li	a2,9
 870:	02f66863          	bltu	a2,a5,8a0 <atoi+0x44>
 874:	872a                	mv	a4,a0
  n = 0;
 876:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 878:	0705                	addi	a4,a4,1
 87a:	0025179b          	slliw	a5,a0,0x2
 87e:	9fa9                	addw	a5,a5,a0
 880:	0017979b          	slliw	a5,a5,0x1
 884:	9fb5                	addw	a5,a5,a3
 886:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 88a:	00074683          	lbu	a3,0(a4)
 88e:	fd06879b          	addiw	a5,a3,-48
 892:	0ff7f793          	zext.b	a5,a5
 896:	fef671e3          	bgeu	a2,a5,878 <atoi+0x1c>
  return n;
}
 89a:	6422                	ld	s0,8(sp)
 89c:	0141                	addi	sp,sp,16
 89e:	8082                	ret
  n = 0;
 8a0:	4501                	li	a0,0
 8a2:	bfe5                	j	89a <atoi+0x3e>

00000000000008a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8a4:	1141                	addi	sp,sp,-16
 8a6:	e422                	sd	s0,8(sp)
 8a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 8aa:	02b57463          	bgeu	a0,a1,8d2 <memmove+0x2e>
    while(n-- > 0)
 8ae:	00c05f63          	blez	a2,8cc <memmove+0x28>
 8b2:	1602                	slli	a2,a2,0x20
 8b4:	9201                	srli	a2,a2,0x20
 8b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 8bc:	0585                	addi	a1,a1,1
 8be:	0705                	addi	a4,a4,1
 8c0:	fff5c683          	lbu	a3,-1(a1)
 8c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8c8:	fee79ae3          	bne	a5,a4,8bc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8cc:	6422                	ld	s0,8(sp)
 8ce:	0141                	addi	sp,sp,16
 8d0:	8082                	ret
    dst += n;
 8d2:	00c50733          	add	a4,a0,a2
    src += n;
 8d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8d8:	fec05ae3          	blez	a2,8cc <memmove+0x28>
 8dc:	fff6079b          	addiw	a5,a2,-1
 8e0:	1782                	slli	a5,a5,0x20
 8e2:	9381                	srli	a5,a5,0x20
 8e4:	fff7c793          	not	a5,a5
 8e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8ea:	15fd                	addi	a1,a1,-1
 8ec:	177d                	addi	a4,a4,-1
 8ee:	0005c683          	lbu	a3,0(a1)
 8f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8f6:	fee79ae3          	bne	a5,a4,8ea <memmove+0x46>
 8fa:	bfc9                	j	8cc <memmove+0x28>

00000000000008fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8fc:	1141                	addi	sp,sp,-16
 8fe:	e422                	sd	s0,8(sp)
 900:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 902:	ca05                	beqz	a2,932 <memcmp+0x36>
 904:	fff6069b          	addiw	a3,a2,-1
 908:	1682                	slli	a3,a3,0x20
 90a:	9281                	srli	a3,a3,0x20
 90c:	0685                	addi	a3,a3,1
 90e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 910:	00054783          	lbu	a5,0(a0)
 914:	0005c703          	lbu	a4,0(a1)
 918:	00e79863          	bne	a5,a4,928 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 91c:	0505                	addi	a0,a0,1
    p2++;
 91e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 920:	fed518e3          	bne	a0,a3,910 <memcmp+0x14>
  }
  return 0;
 924:	4501                	li	a0,0
 926:	a019                	j	92c <memcmp+0x30>
      return *p1 - *p2;
 928:	40e7853b          	subw	a0,a5,a4
}
 92c:	6422                	ld	s0,8(sp)
 92e:	0141                	addi	sp,sp,16
 930:	8082                	ret
  return 0;
 932:	4501                	li	a0,0
 934:	bfe5                	j	92c <memcmp+0x30>

0000000000000936 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 936:	1141                	addi	sp,sp,-16
 938:	e406                	sd	ra,8(sp)
 93a:	e022                	sd	s0,0(sp)
 93c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 93e:	00000097          	auipc	ra,0x0
 942:	f66080e7          	jalr	-154(ra) # 8a4 <memmove>
}
 946:	60a2                	ld	ra,8(sp)
 948:	6402                	ld	s0,0(sp)
 94a:	0141                	addi	sp,sp,16
 94c:	8082                	ret

000000000000094e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 94e:	4885                	li	a7,1
 ecall
 950:	00000073          	ecall
 ret
 954:	8082                	ret

0000000000000956 <exit>:
.global exit
exit:
 li a7, SYS_exit
 956:	4889                	li	a7,2
 ecall
 958:	00000073          	ecall
 ret
 95c:	8082                	ret

000000000000095e <wait>:
.global wait
wait:
 li a7, SYS_wait
 95e:	488d                	li	a7,3
 ecall
 960:	00000073          	ecall
 ret
 964:	8082                	ret

0000000000000966 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 966:	4891                	li	a7,4
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <read>:
.global read
read:
 li a7, SYS_read
 96e:	4895                	li	a7,5
 ecall
 970:	00000073          	ecall
 ret
 974:	8082                	ret

0000000000000976 <write>:
.global write
write:
 li a7, SYS_write
 976:	48c1                	li	a7,16
 ecall
 978:	00000073          	ecall
 ret
 97c:	8082                	ret

000000000000097e <close>:
.global close
close:
 li a7, SYS_close
 97e:	48d5                	li	a7,21
 ecall
 980:	00000073          	ecall
 ret
 984:	8082                	ret

0000000000000986 <kill>:
.global kill
kill:
 li a7, SYS_kill
 986:	4899                	li	a7,6
 ecall
 988:	00000073          	ecall
 ret
 98c:	8082                	ret

000000000000098e <exec>:
.global exec
exec:
 li a7, SYS_exec
 98e:	489d                	li	a7,7
 ecall
 990:	00000073          	ecall
 ret
 994:	8082                	ret

0000000000000996 <open>:
.global open
open:
 li a7, SYS_open
 996:	48bd                	li	a7,15
 ecall
 998:	00000073          	ecall
 ret
 99c:	8082                	ret

000000000000099e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 99e:	48c5                	li	a7,17
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 9a6:	48c9                	li	a7,18
 ecall
 9a8:	00000073          	ecall
 ret
 9ac:	8082                	ret

00000000000009ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 9ae:	48a1                	li	a7,8
 ecall
 9b0:	00000073          	ecall
 ret
 9b4:	8082                	ret

00000000000009b6 <link>:
.global link
link:
 li a7, SYS_link
 9b6:	48cd                	li	a7,19
 ecall
 9b8:	00000073          	ecall
 ret
 9bc:	8082                	ret

00000000000009be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9be:	48d1                	li	a7,20
 ecall
 9c0:	00000073          	ecall
 ret
 9c4:	8082                	ret

00000000000009c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9c6:	48a5                	li	a7,9
 ecall
 9c8:	00000073          	ecall
 ret
 9cc:	8082                	ret

00000000000009ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 9ce:	48a9                	li	a7,10
 ecall
 9d0:	00000073          	ecall
 ret
 9d4:	8082                	ret

00000000000009d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9d6:	48ad                	li	a7,11
 ecall
 9d8:	00000073          	ecall
 ret
 9dc:	8082                	ret

00000000000009de <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9de:	48b1                	li	a7,12
 ecall
 9e0:	00000073          	ecall
 ret
 9e4:	8082                	ret

00000000000009e6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9e6:	48b5                	li	a7,13
 ecall
 9e8:	00000073          	ecall
 ret
 9ec:	8082                	ret

00000000000009ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9ee:	48b9                	li	a7,14
 ecall
 9f0:	00000073          	ecall
 ret
 9f4:	8082                	ret

00000000000009f6 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9f6:	48d9                	li	a7,22
 ecall
 9f8:	00000073          	ecall
 ret
 9fc:	8082                	ret

00000000000009fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9fe:	1101                	addi	sp,sp,-32
 a00:	ec06                	sd	ra,24(sp)
 a02:	e822                	sd	s0,16(sp)
 a04:	1000                	addi	s0,sp,32
 a06:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 a0a:	4605                	li	a2,1
 a0c:	fef40593          	addi	a1,s0,-17
 a10:	00000097          	auipc	ra,0x0
 a14:	f66080e7          	jalr	-154(ra) # 976 <write>
}
 a18:	60e2                	ld	ra,24(sp)
 a1a:	6442                	ld	s0,16(sp)
 a1c:	6105                	addi	sp,sp,32
 a1e:	8082                	ret

0000000000000a20 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a20:	7139                	addi	sp,sp,-64
 a22:	fc06                	sd	ra,56(sp)
 a24:	f822                	sd	s0,48(sp)
 a26:	f426                	sd	s1,40(sp)
 a28:	f04a                	sd	s2,32(sp)
 a2a:	ec4e                	sd	s3,24(sp)
 a2c:	0080                	addi	s0,sp,64
 a2e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a30:	c299                	beqz	a3,a36 <printint+0x16>
 a32:	0805c963          	bltz	a1,ac4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a36:	2581                	sext.w	a1,a1
  neg = 0;
 a38:	4881                	li	a7,0
 a3a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a3e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a40:	2601                	sext.w	a2,a2
 a42:	00001517          	auipc	a0,0x1
 a46:	92650513          	addi	a0,a0,-1754 # 1368 <digits>
 a4a:	883a                	mv	a6,a4
 a4c:	2705                	addiw	a4,a4,1
 a4e:	02c5f7bb          	remuw	a5,a1,a2
 a52:	1782                	slli	a5,a5,0x20
 a54:	9381                	srli	a5,a5,0x20
 a56:	97aa                	add	a5,a5,a0
 a58:	0007c783          	lbu	a5,0(a5)
 a5c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a60:	0005879b          	sext.w	a5,a1
 a64:	02c5d5bb          	divuw	a1,a1,a2
 a68:	0685                	addi	a3,a3,1
 a6a:	fec7f0e3          	bgeu	a5,a2,a4a <printint+0x2a>
  if(neg)
 a6e:	00088c63          	beqz	a7,a86 <printint+0x66>
    buf[i++] = '-';
 a72:	fd070793          	addi	a5,a4,-48
 a76:	00878733          	add	a4,a5,s0
 a7a:	02d00793          	li	a5,45
 a7e:	fef70823          	sb	a5,-16(a4)
 a82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a86:	02e05863          	blez	a4,ab6 <printint+0x96>
 a8a:	fc040793          	addi	a5,s0,-64
 a8e:	00e78933          	add	s2,a5,a4
 a92:	fff78993          	addi	s3,a5,-1
 a96:	99ba                	add	s3,s3,a4
 a98:	377d                	addiw	a4,a4,-1
 a9a:	1702                	slli	a4,a4,0x20
 a9c:	9301                	srli	a4,a4,0x20
 a9e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 aa2:	fff94583          	lbu	a1,-1(s2)
 aa6:	8526                	mv	a0,s1
 aa8:	00000097          	auipc	ra,0x0
 aac:	f56080e7          	jalr	-170(ra) # 9fe <putc>
  while(--i >= 0)
 ab0:	197d                	addi	s2,s2,-1
 ab2:	ff3918e3          	bne	s2,s3,aa2 <printint+0x82>
}
 ab6:	70e2                	ld	ra,56(sp)
 ab8:	7442                	ld	s0,48(sp)
 aba:	74a2                	ld	s1,40(sp)
 abc:	7902                	ld	s2,32(sp)
 abe:	69e2                	ld	s3,24(sp)
 ac0:	6121                	addi	sp,sp,64
 ac2:	8082                	ret
    x = -xx;
 ac4:	40b005bb          	negw	a1,a1
    neg = 1;
 ac8:	4885                	li	a7,1
    x = -xx;
 aca:	bf85                	j	a3a <printint+0x1a>

0000000000000acc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 acc:	715d                	addi	sp,sp,-80
 ace:	e486                	sd	ra,72(sp)
 ad0:	e0a2                	sd	s0,64(sp)
 ad2:	fc26                	sd	s1,56(sp)
 ad4:	f84a                	sd	s2,48(sp)
 ad6:	f44e                	sd	s3,40(sp)
 ad8:	f052                	sd	s4,32(sp)
 ada:	ec56                	sd	s5,24(sp)
 adc:	e85a                	sd	s6,16(sp)
 ade:	e45e                	sd	s7,8(sp)
 ae0:	e062                	sd	s8,0(sp)
 ae2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ae4:	0005c903          	lbu	s2,0(a1)
 ae8:	18090c63          	beqz	s2,c80 <vprintf+0x1b4>
 aec:	8aaa                	mv	s5,a0
 aee:	8bb2                	mv	s7,a2
 af0:	00158493          	addi	s1,a1,1
  state = 0;
 af4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 af6:	02500a13          	li	s4,37
 afa:	4b55                	li	s6,21
 afc:	a839                	j	b1a <vprintf+0x4e>
        putc(fd, c);
 afe:	85ca                	mv	a1,s2
 b00:	8556                	mv	a0,s5
 b02:	00000097          	auipc	ra,0x0
 b06:	efc080e7          	jalr	-260(ra) # 9fe <putc>
 b0a:	a019                	j	b10 <vprintf+0x44>
    } else if(state == '%'){
 b0c:	01498d63          	beq	s3,s4,b26 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 b10:	0485                	addi	s1,s1,1
 b12:	fff4c903          	lbu	s2,-1(s1)
 b16:	16090563          	beqz	s2,c80 <vprintf+0x1b4>
    if(state == 0){
 b1a:	fe0999e3          	bnez	s3,b0c <vprintf+0x40>
      if(c == '%'){
 b1e:	ff4910e3          	bne	s2,s4,afe <vprintf+0x32>
        state = '%';
 b22:	89d2                	mv	s3,s4
 b24:	b7f5                	j	b10 <vprintf+0x44>
      if(c == 'd'){
 b26:	13490263          	beq	s2,s4,c4a <vprintf+0x17e>
 b2a:	f9d9079b          	addiw	a5,s2,-99
 b2e:	0ff7f793          	zext.b	a5,a5
 b32:	12fb6563          	bltu	s6,a5,c5c <vprintf+0x190>
 b36:	f9d9079b          	addiw	a5,s2,-99
 b3a:	0ff7f713          	zext.b	a4,a5
 b3e:	10eb6f63          	bltu	s6,a4,c5c <vprintf+0x190>
 b42:	00271793          	slli	a5,a4,0x2
 b46:	00000717          	auipc	a4,0x0
 b4a:	7ca70713          	addi	a4,a4,1994 # 1310 <malloc+0x592>
 b4e:	97ba                	add	a5,a5,a4
 b50:	439c                	lw	a5,0(a5)
 b52:	97ba                	add	a5,a5,a4
 b54:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b56:	008b8913          	addi	s2,s7,8
 b5a:	4685                	li	a3,1
 b5c:	4629                	li	a2,10
 b5e:	000ba583          	lw	a1,0(s7)
 b62:	8556                	mv	a0,s5
 b64:	00000097          	auipc	ra,0x0
 b68:	ebc080e7          	jalr	-324(ra) # a20 <printint>
 b6c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b6e:	4981                	li	s3,0
 b70:	b745                	j	b10 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b72:	008b8913          	addi	s2,s7,8
 b76:	4681                	li	a3,0
 b78:	4629                	li	a2,10
 b7a:	000ba583          	lw	a1,0(s7)
 b7e:	8556                	mv	a0,s5
 b80:	00000097          	auipc	ra,0x0
 b84:	ea0080e7          	jalr	-352(ra) # a20 <printint>
 b88:	8bca                	mv	s7,s2
      state = 0;
 b8a:	4981                	li	s3,0
 b8c:	b751                	j	b10 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 b8e:	008b8913          	addi	s2,s7,8
 b92:	4681                	li	a3,0
 b94:	4641                	li	a2,16
 b96:	000ba583          	lw	a1,0(s7)
 b9a:	8556                	mv	a0,s5
 b9c:	00000097          	auipc	ra,0x0
 ba0:	e84080e7          	jalr	-380(ra) # a20 <printint>
 ba4:	8bca                	mv	s7,s2
      state = 0;
 ba6:	4981                	li	s3,0
 ba8:	b7a5                	j	b10 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 baa:	008b8c13          	addi	s8,s7,8
 bae:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 bb2:	03000593          	li	a1,48
 bb6:	8556                	mv	a0,s5
 bb8:	00000097          	auipc	ra,0x0
 bbc:	e46080e7          	jalr	-442(ra) # 9fe <putc>
  putc(fd, 'x');
 bc0:	07800593          	li	a1,120
 bc4:	8556                	mv	a0,s5
 bc6:	00000097          	auipc	ra,0x0
 bca:	e38080e7          	jalr	-456(ra) # 9fe <putc>
 bce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bd0:	00000b97          	auipc	s7,0x0
 bd4:	798b8b93          	addi	s7,s7,1944 # 1368 <digits>
 bd8:	03c9d793          	srli	a5,s3,0x3c
 bdc:	97de                	add	a5,a5,s7
 bde:	0007c583          	lbu	a1,0(a5)
 be2:	8556                	mv	a0,s5
 be4:	00000097          	auipc	ra,0x0
 be8:	e1a080e7          	jalr	-486(ra) # 9fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bec:	0992                	slli	s3,s3,0x4
 bee:	397d                	addiw	s2,s2,-1
 bf0:	fe0914e3          	bnez	s2,bd8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 bf4:	8be2                	mv	s7,s8
      state = 0;
 bf6:	4981                	li	s3,0
 bf8:	bf21                	j	b10 <vprintf+0x44>
        s = va_arg(ap, char*);
 bfa:	008b8993          	addi	s3,s7,8
 bfe:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 c02:	02090163          	beqz	s2,c24 <vprintf+0x158>
        while(*s != 0){
 c06:	00094583          	lbu	a1,0(s2)
 c0a:	c9a5                	beqz	a1,c7a <vprintf+0x1ae>
          putc(fd, *s);
 c0c:	8556                	mv	a0,s5
 c0e:	00000097          	auipc	ra,0x0
 c12:	df0080e7          	jalr	-528(ra) # 9fe <putc>
          s++;
 c16:	0905                	addi	s2,s2,1
        while(*s != 0){
 c18:	00094583          	lbu	a1,0(s2)
 c1c:	f9e5                	bnez	a1,c0c <vprintf+0x140>
        s = va_arg(ap, char*);
 c1e:	8bce                	mv	s7,s3
      state = 0;
 c20:	4981                	li	s3,0
 c22:	b5fd                	j	b10 <vprintf+0x44>
          s = "(null)";
 c24:	00000917          	auipc	s2,0x0
 c28:	6e490913          	addi	s2,s2,1764 # 1308 <malloc+0x58a>
        while(*s != 0){
 c2c:	02800593          	li	a1,40
 c30:	bff1                	j	c0c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 c32:	008b8913          	addi	s2,s7,8
 c36:	000bc583          	lbu	a1,0(s7)
 c3a:	8556                	mv	a0,s5
 c3c:	00000097          	auipc	ra,0x0
 c40:	dc2080e7          	jalr	-574(ra) # 9fe <putc>
 c44:	8bca                	mv	s7,s2
      state = 0;
 c46:	4981                	li	s3,0
 c48:	b5e1                	j	b10 <vprintf+0x44>
        putc(fd, c);
 c4a:	02500593          	li	a1,37
 c4e:	8556                	mv	a0,s5
 c50:	00000097          	auipc	ra,0x0
 c54:	dae080e7          	jalr	-594(ra) # 9fe <putc>
      state = 0;
 c58:	4981                	li	s3,0
 c5a:	bd5d                	j	b10 <vprintf+0x44>
        putc(fd, '%');
 c5c:	02500593          	li	a1,37
 c60:	8556                	mv	a0,s5
 c62:	00000097          	auipc	ra,0x0
 c66:	d9c080e7          	jalr	-612(ra) # 9fe <putc>
        putc(fd, c);
 c6a:	85ca                	mv	a1,s2
 c6c:	8556                	mv	a0,s5
 c6e:	00000097          	auipc	ra,0x0
 c72:	d90080e7          	jalr	-624(ra) # 9fe <putc>
      state = 0;
 c76:	4981                	li	s3,0
 c78:	bd61                	j	b10 <vprintf+0x44>
        s = va_arg(ap, char*);
 c7a:	8bce                	mv	s7,s3
      state = 0;
 c7c:	4981                	li	s3,0
 c7e:	bd49                	j	b10 <vprintf+0x44>
    }
  }
}
 c80:	60a6                	ld	ra,72(sp)
 c82:	6406                	ld	s0,64(sp)
 c84:	74e2                	ld	s1,56(sp)
 c86:	7942                	ld	s2,48(sp)
 c88:	79a2                	ld	s3,40(sp)
 c8a:	7a02                	ld	s4,32(sp)
 c8c:	6ae2                	ld	s5,24(sp)
 c8e:	6b42                	ld	s6,16(sp)
 c90:	6ba2                	ld	s7,8(sp)
 c92:	6c02                	ld	s8,0(sp)
 c94:	6161                	addi	sp,sp,80
 c96:	8082                	ret

0000000000000c98 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c98:	715d                	addi	sp,sp,-80
 c9a:	ec06                	sd	ra,24(sp)
 c9c:	e822                	sd	s0,16(sp)
 c9e:	1000                	addi	s0,sp,32
 ca0:	e010                	sd	a2,0(s0)
 ca2:	e414                	sd	a3,8(s0)
 ca4:	e818                	sd	a4,16(s0)
 ca6:	ec1c                	sd	a5,24(s0)
 ca8:	03043023          	sd	a6,32(s0)
 cac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cb0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cb4:	8622                	mv	a2,s0
 cb6:	00000097          	auipc	ra,0x0
 cba:	e16080e7          	jalr	-490(ra) # acc <vprintf>
}
 cbe:	60e2                	ld	ra,24(sp)
 cc0:	6442                	ld	s0,16(sp)
 cc2:	6161                	addi	sp,sp,80
 cc4:	8082                	ret

0000000000000cc6 <printf>:

void
printf(const char *fmt, ...)
{
 cc6:	711d                	addi	sp,sp,-96
 cc8:	ec06                	sd	ra,24(sp)
 cca:	e822                	sd	s0,16(sp)
 ccc:	1000                	addi	s0,sp,32
 cce:	e40c                	sd	a1,8(s0)
 cd0:	e810                	sd	a2,16(s0)
 cd2:	ec14                	sd	a3,24(s0)
 cd4:	f018                	sd	a4,32(s0)
 cd6:	f41c                	sd	a5,40(s0)
 cd8:	03043823          	sd	a6,48(s0)
 cdc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ce0:	00840613          	addi	a2,s0,8
 ce4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ce8:	85aa                	mv	a1,a0
 cea:	4505                	li	a0,1
 cec:	00000097          	auipc	ra,0x0
 cf0:	de0080e7          	jalr	-544(ra) # acc <vprintf>
}
 cf4:	60e2                	ld	ra,24(sp)
 cf6:	6442                	ld	s0,16(sp)
 cf8:	6125                	addi	sp,sp,96
 cfa:	8082                	ret

0000000000000cfc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cfc:	1141                	addi	sp,sp,-16
 cfe:	e422                	sd	s0,8(sp)
 d00:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d02:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d06:	00001797          	auipc	a5,0x1
 d0a:	3027b783          	ld	a5,770(a5) # 2008 <freep>
 d0e:	a02d                	j	d38 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d10:	4618                	lw	a4,8(a2)
 d12:	9f2d                	addw	a4,a4,a1
 d14:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d18:	6398                	ld	a4,0(a5)
 d1a:	6310                	ld	a2,0(a4)
 d1c:	a83d                	j	d5a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d1e:	ff852703          	lw	a4,-8(a0)
 d22:	9f31                	addw	a4,a4,a2
 d24:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d26:	ff053683          	ld	a3,-16(a0)
 d2a:	a091                	j	d6e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d2c:	6398                	ld	a4,0(a5)
 d2e:	00e7e463          	bltu	a5,a4,d36 <free+0x3a>
 d32:	00e6ea63          	bltu	a3,a4,d46 <free+0x4a>
{
 d36:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d38:	fed7fae3          	bgeu	a5,a3,d2c <free+0x30>
 d3c:	6398                	ld	a4,0(a5)
 d3e:	00e6e463          	bltu	a3,a4,d46 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d42:	fee7eae3          	bltu	a5,a4,d36 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d46:	ff852583          	lw	a1,-8(a0)
 d4a:	6390                	ld	a2,0(a5)
 d4c:	02059813          	slli	a6,a1,0x20
 d50:	01c85713          	srli	a4,a6,0x1c
 d54:	9736                	add	a4,a4,a3
 d56:	fae60de3          	beq	a2,a4,d10 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d5a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d5e:	4790                	lw	a2,8(a5)
 d60:	02061593          	slli	a1,a2,0x20
 d64:	01c5d713          	srli	a4,a1,0x1c
 d68:	973e                	add	a4,a4,a5
 d6a:	fae68ae3          	beq	a3,a4,d1e <free+0x22>
    p->s.ptr = bp->s.ptr;
 d6e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d70:	00001717          	auipc	a4,0x1
 d74:	28f73c23          	sd	a5,664(a4) # 2008 <freep>
}
 d78:	6422                	ld	s0,8(sp)
 d7a:	0141                	addi	sp,sp,16
 d7c:	8082                	ret

0000000000000d7e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d7e:	7139                	addi	sp,sp,-64
 d80:	fc06                	sd	ra,56(sp)
 d82:	f822                	sd	s0,48(sp)
 d84:	f426                	sd	s1,40(sp)
 d86:	f04a                	sd	s2,32(sp)
 d88:	ec4e                	sd	s3,24(sp)
 d8a:	e852                	sd	s4,16(sp)
 d8c:	e456                	sd	s5,8(sp)
 d8e:	e05a                	sd	s6,0(sp)
 d90:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d92:	02051493          	slli	s1,a0,0x20
 d96:	9081                	srli	s1,s1,0x20
 d98:	04bd                	addi	s1,s1,15
 d9a:	8091                	srli	s1,s1,0x4
 d9c:	0014899b          	addiw	s3,s1,1
 da0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 da2:	00001517          	auipc	a0,0x1
 da6:	26653503          	ld	a0,614(a0) # 2008 <freep>
 daa:	c515                	beqz	a0,dd6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dae:	4798                	lw	a4,8(a5)
 db0:	02977f63          	bgeu	a4,s1,dee <malloc+0x70>
  if(nu < 4096)
 db4:	8a4e                	mv	s4,s3
 db6:	0009871b          	sext.w	a4,s3
 dba:	6685                	lui	a3,0x1
 dbc:	00d77363          	bgeu	a4,a3,dc2 <malloc+0x44>
 dc0:	6a05                	lui	s4,0x1
 dc2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dc6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dca:	00001917          	auipc	s2,0x1
 dce:	23e90913          	addi	s2,s2,574 # 2008 <freep>
  if(p == (char*)-1)
 dd2:	5afd                	li	s5,-1
 dd4:	a895                	j	e48 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 dd6:	00001797          	auipc	a5,0x1
 dda:	23a78793          	addi	a5,a5,570 # 2010 <base>
 dde:	00001717          	auipc	a4,0x1
 de2:	22f73523          	sd	a5,554(a4) # 2008 <freep>
 de6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 de8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 dec:	b7e1                	j	db4 <malloc+0x36>
      if(p->s.size == nunits)
 dee:	02e48c63          	beq	s1,a4,e26 <malloc+0xa8>
        p->s.size -= nunits;
 df2:	4137073b          	subw	a4,a4,s3
 df6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 df8:	02071693          	slli	a3,a4,0x20
 dfc:	01c6d713          	srli	a4,a3,0x1c
 e00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e06:	00001717          	auipc	a4,0x1
 e0a:	20a73123          	sd	a0,514(a4) # 2008 <freep>
      return (void*)(p + 1);
 e0e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e12:	70e2                	ld	ra,56(sp)
 e14:	7442                	ld	s0,48(sp)
 e16:	74a2                	ld	s1,40(sp)
 e18:	7902                	ld	s2,32(sp)
 e1a:	69e2                	ld	s3,24(sp)
 e1c:	6a42                	ld	s4,16(sp)
 e1e:	6aa2                	ld	s5,8(sp)
 e20:	6b02                	ld	s6,0(sp)
 e22:	6121                	addi	sp,sp,64
 e24:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e26:	6398                	ld	a4,0(a5)
 e28:	e118                	sd	a4,0(a0)
 e2a:	bff1                	j	e06 <malloc+0x88>
  hp->s.size = nu;
 e2c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e30:	0541                	addi	a0,a0,16
 e32:	00000097          	auipc	ra,0x0
 e36:	eca080e7          	jalr	-310(ra) # cfc <free>
  return freep;
 e3a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e3e:	d971                	beqz	a0,e12 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e42:	4798                	lw	a4,8(a5)
 e44:	fa9775e3          	bgeu	a4,s1,dee <malloc+0x70>
    if(p == freep)
 e48:	00093703          	ld	a4,0(s2)
 e4c:	853e                	mv	a0,a5
 e4e:	fef719e3          	bne	a4,a5,e40 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e52:	8552                	mv	a0,s4
 e54:	00000097          	auipc	ra,0x0
 e58:	b8a080e7          	jalr	-1142(ra) # 9de <sbrk>
  if(p == (char*)-1)
 e5c:	fd5518e3          	bne	a0,s5,e2c <malloc+0xae>
        return 0;
 e60:	4501                	li	a0,0
 e62:	bf45                	j	e12 <malloc+0x94>
