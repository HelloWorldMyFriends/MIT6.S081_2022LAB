
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	bc2080e7          	jalr	-1086(ra) # 5bd2 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	bb0080e7          	jalr	-1104(ra) # 5bd2 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	06250513          	addi	a0,a0,98 # 60a0 <malloc+0xee>
      46:	00006097          	auipc	ra,0x6
      4a:	eb4080e7          	jalr	-332(ra) # 5efa <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b42080e7          	jalr	-1214(ra) # 5b92 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	04050513          	addi	a0,a0,64 # 60c0 <malloc+0x10e>
      88:	00006097          	auipc	ra,0x6
      8c:	e72080e7          	jalr	-398(ra) # 5efa <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b00080e7          	jalr	-1280(ra) # 5b92 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	03050513          	addi	a0,a0,48 # 60d8 <malloc+0x126>
      b0:	00006097          	auipc	ra,0x6
      b4:	b22080e7          	jalr	-1246(ra) # 5bd2 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	afe080e7          	jalr	-1282(ra) # 5bba <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	03250513          	addi	a0,a0,50 # 60f8 <malloc+0x146>
      ce:	00006097          	auipc	ra,0x6
      d2:	b04080e7          	jalr	-1276(ra) # 5bd2 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	ffa50513          	addi	a0,a0,-6 # 60e0 <malloc+0x12e>
      ee:	00006097          	auipc	ra,0x6
      f2:	e0c080e7          	jalr	-500(ra) # 5efa <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	a9a080e7          	jalr	-1382(ra) # 5b92 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	00650513          	addi	a0,a0,6 # 6108 <malloc+0x156>
     10a:	00006097          	auipc	ra,0x6
     10e:	df0080e7          	jalr	-528(ra) # 5efa <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a7e080e7          	jalr	-1410(ra) # 5b92 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	00450513          	addi	a0,a0,4 # 6130 <malloc+0x17e>
     134:	00006097          	auipc	ra,0x6
     138:	aae080e7          	jalr	-1362(ra) # 5be2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	ff050513          	addi	a0,a0,-16 # 6130 <malloc+0x17e>
     148:	00006097          	auipc	ra,0x6
     14c:	a8a080e7          	jalr	-1398(ra) # 5bd2 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	fec58593          	addi	a1,a1,-20 # 6140 <malloc+0x18e>
     15c:	00006097          	auipc	ra,0x6
     160:	a56080e7          	jalr	-1450(ra) # 5bb2 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	fc850513          	addi	a0,a0,-56 # 6130 <malloc+0x17e>
     170:	00006097          	auipc	ra,0x6
     174:	a62080e7          	jalr	-1438(ra) # 5bd2 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	fcc58593          	addi	a1,a1,-52 # 6148 <malloc+0x196>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a2c080e7          	jalr	-1492(ra) # 5bb2 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	f9c50513          	addi	a0,a0,-100 # 6130 <malloc+0x17e>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a46080e7          	jalr	-1466(ra) # 5be2 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a14080e7          	jalr	-1516(ra) # 5bba <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a0a080e7          	jalr	-1526(ra) # 5bba <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	f8650513          	addi	a0,a0,-122 # 6150 <malloc+0x19e>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d28080e7          	jalr	-728(ra) # 5efa <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	9b6080e7          	jalr	-1610(ra) # 5b92 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	9c2080e7          	jalr	-1598(ra) # 5bd2 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9a2080e7          	jalr	-1630(ra) # 5bba <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	99c080e7          	jalr	-1636(ra) # 5be2 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	efc50513          	addi	a0,a0,-260 # 6178 <malloc+0x1c6>
     284:	00006097          	auipc	ra,0x6
     288:	95e080e7          	jalr	-1698(ra) # 5be2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	ee8a8a93          	addi	s5,s5,-280 # 6178 <malloc+0x1c6>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	926080e7          	jalr	-1754(ra) # 5bd2 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	8f4080e7          	jalr	-1804(ra) # 5bb2 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	8e0080e7          	jalr	-1824(ra) # 5bb2 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	8da080e7          	jalr	-1830(ra) # 5bba <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	8f8080e7          	jalr	-1800(ra) # 5be2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	e7650513          	addi	a0,a0,-394 # 6188 <malloc+0x1d6>
     31a:	00006097          	auipc	ra,0x6
     31e:	be0080e7          	jalr	-1056(ra) # 5efa <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	86e080e7          	jalr	-1938(ra) # 5b92 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	e7450513          	addi	a0,a0,-396 # 61a8 <malloc+0x1f6>
     33c:	00006097          	auipc	ra,0x6
     340:	bbe080e7          	jalr	-1090(ra) # 5efa <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	84c080e7          	jalr	-1972(ra) # 5b92 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	e6250513          	addi	a0,a0,-414 # 61c0 <malloc+0x20e>
     366:	00006097          	auipc	ra,0x6
     36a:	87c080e7          	jalr	-1924(ra) # 5be2 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	e4e98993          	addi	s3,s3,-434 # 61c0 <malloc+0x20e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	84c080e7          	jalr	-1972(ra) # 5bd2 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	81a080e7          	jalr	-2022(ra) # 5bb2 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	818080e7          	jalr	-2024(ra) # 5bba <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	836080e7          	jalr	-1994(ra) # 5be2 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	e0250513          	addi	a0,a0,-510 # 61c0 <malloc+0x20e>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	80c080e7          	jalr	-2036(ra) # 5bd2 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	d7258593          	addi	a1,a1,-654 # 6148 <malloc+0x196>
     3de:	00005097          	auipc	ra,0x5
     3e2:	7d4080e7          	jalr	2004(ra) # 5bb2 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	df450513          	addi	a0,a0,-524 # 61e0 <malloc+0x22e>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b06080e7          	jalr	-1274(ra) # 5efa <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	794080e7          	jalr	1940(ra) # 5b92 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	dc250513          	addi	a0,a0,-574 # 61c8 <malloc+0x216>
     40e:	00006097          	auipc	ra,0x6
     412:	aec080e7          	jalr	-1300(ra) # 5efa <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	77a080e7          	jalr	1914(ra) # 5b92 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	da850513          	addi	a0,a0,-600 # 61c8 <malloc+0x216>
     428:	00006097          	auipc	ra,0x6
     42c:	ad2080e7          	jalr	-1326(ra) # 5efa <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	760080e7          	jalr	1888(ra) # 5b92 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	77e080e7          	jalr	1918(ra) # 5bba <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	d7c50513          	addi	a0,a0,-644 # 61c0 <malloc+0x20e>
     44c:	00005097          	auipc	ra,0x5
     450:	796080e7          	jalr	1942(ra) # 5be2 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	73c080e7          	jalr	1852(ra) # 5b92 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	738080e7          	jalr	1848(ra) # 5be2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	718080e7          	jalr	1816(ra) # 5bd2 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	6f4080e7          	jalr	1780(ra) # 5bba <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	6d0080e7          	jalr	1744(ra) # 5be2 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	ca0a0a13          	addi	s4,s4,-864 # 61f0 <malloc+0x23e>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	670080e7          	jalr	1648(ra) # 5bd2 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	63e080e7          	jalr	1598(ra) # 5bb2 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	638080e7          	jalr	1592(ra) # 5bba <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	656080e7          	jalr	1622(ra) # 5be2 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	618080e7          	jalr	1560(ra) # 5bb2 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	5f8080e7          	jalr	1528(ra) # 5ba2 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	5f4080e7          	jalr	1524(ra) # 5bb2 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	5ec080e7          	jalr	1516(ra) # 5bba <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	5e0080e7          	jalr	1504(ra) # 5bba <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	bfc50513          	addi	a0,a0,-1028 # 61f8 <malloc+0x246>
     604:	00006097          	auipc	ra,0x6
     608:	8f6080e7          	jalr	-1802(ra) # 5efa <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	584080e7          	jalr	1412(ra) # 5b92 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	bf650513          	addi	a0,a0,-1034 # 6210 <malloc+0x25e>
     622:	00006097          	auipc	ra,0x6
     626:	8d8080e7          	jalr	-1832(ra) # 5efa <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	566080e7          	jalr	1382(ra) # 5b92 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	c0850513          	addi	a0,a0,-1016 # 6240 <malloc+0x28e>
     640:	00006097          	auipc	ra,0x6
     644:	8ba080e7          	jalr	-1862(ra) # 5efa <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	548080e7          	jalr	1352(ra) # 5b92 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	c1e50513          	addi	a0,a0,-994 # 6270 <malloc+0x2be>
     65a:	00006097          	auipc	ra,0x6
     65e:	8a0080e7          	jalr	-1888(ra) # 5efa <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	52e080e7          	jalr	1326(ra) # 5b92 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	c1050513          	addi	a0,a0,-1008 # 6280 <malloc+0x2ce>
     678:	00006097          	auipc	ra,0x6
     67c:	882080e7          	jalr	-1918(ra) # 5efa <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	510080e7          	jalr	1296(ra) # 5b92 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	c02a0a13          	addi	s4,s4,-1022 # 62b0 <malloc+0x2fe>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	a92a8a93          	addi	s5,s5,-1390 # 6148 <malloc+0x196>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	50c080e7          	jalr	1292(ra) # 5bd2 <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	4d2080e7          	jalr	1234(ra) # 5baa <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	4d4080e7          	jalr	1236(ra) # 5bba <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	4b0080e7          	jalr	1200(ra) # 5ba2 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	4ac080e7          	jalr	1196(ra) # 5bb2 <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	48e080e7          	jalr	1166(ra) # 5baa <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	48e080e7          	jalr	1166(ra) # 5bba <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	482080e7          	jalr	1154(ra) # 5bba <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	b5c50513          	addi	a0,a0,-1188 # 62b8 <malloc+0x306>
     764:	00005097          	auipc	ra,0x5
     768:	796080e7          	jalr	1942(ra) # 5efa <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	424080e7          	jalr	1060(ra) # 5b92 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	b5650513          	addi	a0,a0,-1194 # 62d0 <malloc+0x31e>
     782:	00005097          	auipc	ra,0x5
     786:	778080e7          	jalr	1912(ra) # 5efa <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	406080e7          	jalr	1030(ra) # 5b92 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	adc50513          	addi	a0,a0,-1316 # 6270 <malloc+0x2be>
     79c:	00005097          	auipc	ra,0x5
     7a0:	75e080e7          	jalr	1886(ra) # 5efa <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	3ec080e7          	jalr	1004(ra) # 5b92 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	b5250513          	addi	a0,a0,-1198 # 6300 <malloc+0x34e>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	744080e7          	jalr	1860(ra) # 5efa <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	3d2080e7          	jalr	978(ra) # 5b92 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	b4c50513          	addi	a0,a0,-1204 # 6318 <malloc+0x366>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	726080e7          	jalr	1830(ra) # 5efa <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	3b4080e7          	jalr	948(ra) # 5b92 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	93650513          	addi	a0,a0,-1738 # 6130 <malloc+0x17e>
     802:	00005097          	auipc	ra,0x5
     806:	3e0080e7          	jalr	992(ra) # 5be2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	92250513          	addi	a0,a0,-1758 # 6130 <malloc+0x17e>
     816:	00005097          	auipc	ra,0x5
     81a:	3bc080e7          	jalr	956(ra) # 5bd2 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	91e58593          	addi	a1,a1,-1762 # 6140 <malloc+0x18e>
     82a:	00005097          	auipc	ra,0x5
     82e:	388080e7          	jalr	904(ra) # 5bb2 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	386080e7          	jalr	902(ra) # 5bba <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	8f250513          	addi	a0,a0,-1806 # 6130 <malloc+0x17e>
     846:	00005097          	auipc	ra,0x5
     84a:	38c080e7          	jalr	908(ra) # 5bd2 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	352080e7          	jalr	850(ra) # 5baa <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	8c650513          	addi	a0,a0,-1850 # 6130 <malloc+0x17e>
     872:	00005097          	auipc	ra,0x5
     876:	360080e7          	jalr	864(ra) # 5bd2 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	8b250513          	addi	a0,a0,-1870 # 6130 <malloc+0x17e>
     886:	00005097          	auipc	ra,0x5
     88a:	34c080e7          	jalr	844(ra) # 5bd2 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	312080e7          	jalr	786(ra) # 5baa <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	2fc080e7          	jalr	764(ra) # 5baa <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	aec58593          	addi	a1,a1,-1300 # 63a8 <malloc+0x3f6>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	2ec080e7          	jalr	748(ra) # 5bb2 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	2d2080e7          	jalr	722(ra) # 5baa <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	2ba080e7          	jalr	698(ra) # 5baa <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	83250513          	addi	a0,a0,-1998 # 6130 <malloc+0x17e>
     906:	00005097          	auipc	ra,0x5
     90a:	2dc080e7          	jalr	732(ra) # 5be2 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	2aa080e7          	jalr	682(ra) # 5bba <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	2a0080e7          	jalr	672(ra) # 5bba <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	296080e7          	jalr	662(ra) # 5bba <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	a0650513          	addi	a0,a0,-1530 # 6348 <malloc+0x396>
     94a:	00005097          	auipc	ra,0x5
     94e:	5b0080e7          	jalr	1456(ra) # 5efa <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	23e080e7          	jalr	574(ra) # 5b92 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	a0a50513          	addi	a0,a0,-1526 # 6368 <malloc+0x3b6>
     966:	00005097          	auipc	ra,0x5
     96a:	594080e7          	jalr	1428(ra) # 5efa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	a0650513          	addi	a0,a0,-1530 # 6378 <malloc+0x3c6>
     97a:	00005097          	auipc	ra,0x5
     97e:	580080e7          	jalr	1408(ra) # 5efa <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	20e080e7          	jalr	526(ra) # 5b92 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	a0a50513          	addi	a0,a0,-1526 # 6398 <malloc+0x3e6>
     996:	00005097          	auipc	ra,0x5
     99a:	564080e7          	jalr	1380(ra) # 5efa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	9d650513          	addi	a0,a0,-1578 # 6378 <malloc+0x3c6>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	550080e7          	jalr	1360(ra) # 5efa <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	1de080e7          	jalr	478(ra) # 5b92 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	9f050513          	addi	a0,a0,-1552 # 63b0 <malloc+0x3fe>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	532080e7          	jalr	1330(ra) # 5efa <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	1c0080e7          	jalr	448(ra) # 5b92 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	9f250513          	addi	a0,a0,-1550 # 63d0 <malloc+0x41e>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	514080e7          	jalr	1300(ra) # 5efa <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	1a2080e7          	jalr	418(ra) # 5b92 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	9de50513          	addi	a0,a0,-1570 # 63f0 <malloc+0x43e>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	1b8080e7          	jalr	440(ra) # 5bd2 <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	9ee98993          	addi	s3,s3,-1554 # 6418 <malloc+0x466>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	a1ea8a93          	addi	s5,s5,-1506 # 6450 <malloc+0x49e>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	16e080e7          	jalr	366(ra) # 5bb2 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	15a080e7          	jalr	346(ra) # 5bb2 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	14c080e7          	jalr	332(ra) # 5bba <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	97850513          	addi	a0,a0,-1672 # 63f0 <malloc+0x43e>
     a80:	00005097          	auipc	ra,0x5
     a84:	152080e7          	jalr	338(ra) # 5bd2 <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	addi	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	110080e7          	jalr	272(ra) # 5baa <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	10e080e7          	jalr	270(ra) # 5bba <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	93c50513          	addi	a0,a0,-1732 # 63f0 <malloc+0x43e>
     abc:	00005097          	auipc	ra,0x5
     ac0:	126080e7          	jalr	294(ra) # 5be2 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	91a50513          	addi	a0,a0,-1766 # 63f8 <malloc+0x446>
     ae6:	00005097          	auipc	ra,0x5
     aea:	414080e7          	jalr	1044(ra) # 5efa <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	0a2080e7          	jalr	162(ra) # 5b92 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	92c50513          	addi	a0,a0,-1748 # 6428 <malloc+0x476>
     b04:	00005097          	auipc	ra,0x5
     b08:	3f6080e7          	jalr	1014(ra) # 5efa <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	084080e7          	jalr	132(ra) # 5b92 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	94650513          	addi	a0,a0,-1722 # 6460 <malloc+0x4ae>
     b22:	00005097          	auipc	ra,0x5
     b26:	3d8080e7          	jalr	984(ra) # 5efa <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	066080e7          	jalr	102(ra) # 5b92 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	95250513          	addi	a0,a0,-1710 # 6488 <malloc+0x4d6>
     b3e:	00005097          	auipc	ra,0x5
     b42:	3bc080e7          	jalr	956(ra) # 5efa <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	04a080e7          	jalr	74(ra) # 5b92 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	95650513          	addi	a0,a0,-1706 # 64a8 <malloc+0x4f6>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	3a0080e7          	jalr	928(ra) # 5efa <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	02e080e7          	jalr	46(ra) # 5b92 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	95250513          	addi	a0,a0,-1710 # 64c0 <malloc+0x50e>
     b76:	00005097          	auipc	ra,0x5
     b7a:	384080e7          	jalr	900(ra) # 5efa <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	012080e7          	jalr	18(ra) # 5b92 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	94050513          	addi	a0,a0,-1728 # 64e0 <malloc+0x52e>
     ba8:	00005097          	auipc	ra,0x5
     bac:	02a080e7          	jalr	42(ra) # 5bd2 <open>
  if(fd < 0){
     bb0:	08054563          	bltz	a0,c3a <writebig+0xb2>
     bb4:	89aa                	mv	s3,a0
     bb6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb8:	0000c917          	auipc	s2,0xc
     bbc:	0c090913          	addi	s2,s2,192 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bc0:	6a41                	lui	s4,0x10
     bc2:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x493>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	fe0080e7          	jalr	-32(ra) # 5bb2 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3e>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	fd0080e7          	jalr	-48(ra) # 5bba <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	8ec50513          	addi	a0,a0,-1812 # 64e0 <malloc+0x52e>
     bfc:	00005097          	auipc	ra,0x5
     c00:	fd6080e7          	jalr	-42(ra) # 5bd2 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	07090913          	addi	s2,s2,112 # cc78 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	f8e080e7          	jalr	-114(ra) # 5baa <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x108>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x160>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17e>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	8ac50513          	addi	a0,a0,-1876 # 64e8 <malloc+0x536>
     c44:	00005097          	auipc	ra,0x5
     c48:	2b6080e7          	jalr	694(ra) # 5efa <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f44080e7          	jalr	-188(ra) # 5b92 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	8ae50513          	addi	a0,a0,-1874 # 6508 <malloc+0x556>
     c62:	00005097          	auipc	ra,0x5
     c66:	298080e7          	jalr	664(ra) # 5efa <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f26080e7          	jalr	-218(ra) # 5b92 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	8ba50513          	addi	a0,a0,-1862 # 6530 <malloc+0x57e>
     c7e:	00005097          	auipc	ra,0x5
     c82:	27c080e7          	jalr	636(ra) # 5efa <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f0a080e7          	jalr	-246(ra) # 5b92 <exit>
      if(n == MAXFILE - 1){
     c90:	67c1                	lui	a5,0x10
     c92:	10a78793          	addi	a5,a5,266 # 1010a <base+0x492>
     c96:	02f48a63          	beq	s1,a5,cca <writebig+0x142>
  close(fd);
     c9a:	854e                	mv	a0,s3
     c9c:	00005097          	auipc	ra,0x5
     ca0:	f1e080e7          	jalr	-226(ra) # 5bba <close>
  if(unlink("big") < 0){
     ca4:	00006517          	auipc	a0,0x6
     ca8:	83c50513          	addi	a0,a0,-1988 # 64e0 <malloc+0x52e>
     cac:	00005097          	auipc	ra,0x5
     cb0:	f36080e7          	jalr	-202(ra) # 5be2 <unlink>
     cb4:	06054863          	bltz	a0,d24 <writebig+0x19c>
}
     cb8:	70e2                	ld	ra,56(sp)
     cba:	7442                	ld	s0,48(sp)
     cbc:	74a2                	ld	s1,40(sp)
     cbe:	7902                	ld	s2,32(sp)
     cc0:	69e2                	ld	s3,24(sp)
     cc2:	6a42                	ld	s4,16(sp)
     cc4:	6aa2                	ld	s5,8(sp)
     cc6:	6121                	addi	sp,sp,64
     cc8:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cca:	863e                	mv	a2,a5
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	88250513          	addi	a0,a0,-1918 # 6550 <malloc+0x59e>
     cd6:	00005097          	auipc	ra,0x5
     cda:	224080e7          	jalr	548(ra) # 5efa <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	eb2080e7          	jalr	-334(ra) # 5b92 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	88c50513          	addi	a0,a0,-1908 # 6578 <malloc+0x5c6>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	206080e7          	jalr	518(ra) # 5efa <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	e94080e7          	jalr	-364(ra) # 5b92 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	88650513          	addi	a0,a0,-1914 # 6590 <malloc+0x5de>
     d12:	00005097          	auipc	ra,0x5
     d16:	1e8080e7          	jalr	488(ra) # 5efa <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	e76080e7          	jalr	-394(ra) # 5b92 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	89250513          	addi	a0,a0,-1902 # 65b8 <malloc+0x606>
     d2e:	00005097          	auipc	ra,0x5
     d32:	1cc080e7          	jalr	460(ra) # 5efa <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	e5a080e7          	jalr	-422(ra) # 5b92 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	87c50513          	addi	a0,a0,-1924 # 65d0 <malloc+0x61e>
     d5c:	00005097          	auipc	ra,0x5
     d60:	e76080e7          	jalr	-394(ra) # 5bd2 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	89458593          	addi	a1,a1,-1900 # 6600 <malloc+0x64e>
     d74:	00005097          	auipc	ra,0x5
     d78:	e3e080e7          	jalr	-450(ra) # 5bb2 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e3c080e7          	jalr	-452(ra) # 5bba <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	84850513          	addi	a0,a0,-1976 # 65d0 <malloc+0x61e>
     d90:	00005097          	auipc	ra,0x5
     d94:	e42080e7          	jalr	-446(ra) # 5bd2 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	83250513          	addi	a0,a0,-1998 # 65d0 <malloc+0x61e>
     da6:	00005097          	auipc	ra,0x5
     daa:	e3c080e7          	jalr	-452(ra) # 5be2 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	81c50513          	addi	a0,a0,-2020 # 65d0 <malloc+0x61e>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e16080e7          	jalr	-490(ra) # 5bd2 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	88058593          	addi	a1,a1,-1920 # 6648 <malloc+0x696>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	de2080e7          	jalr	-542(ra) # 5bb2 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	de0080e7          	jalr	-544(ra) # 5bba <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e9458593          	addi	a1,a1,-364 # cc78 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	dbc080e7          	jalr	-580(ra) # 5baa <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e7c74703          	lbu	a4,-388(a4) # cc78 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e6a58593          	addi	a1,a1,-406 # cc78 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	d9a080e7          	jalr	-614(ra) # 5bb2 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	d92080e7          	jalr	-622(ra) # 5bba <close>
  unlink("unlinkread");
     e30:	00005517          	auipc	a0,0x5
     e34:	7a050513          	addi	a0,a0,1952 # 65d0 <malloc+0x61e>
     e38:	00005097          	auipc	ra,0x5
     e3c:	daa080e7          	jalr	-598(ra) # 5be2 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00005517          	auipc	a0,0x5
     e54:	79050513          	addi	a0,a0,1936 # 65e0 <malloc+0x62e>
     e58:	00005097          	auipc	ra,0x5
     e5c:	0a2080e7          	jalr	162(ra) # 5efa <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d30080e7          	jalr	-720(ra) # 5b92 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00005517          	auipc	a0,0x5
     e70:	79c50513          	addi	a0,a0,1948 # 6608 <malloc+0x656>
     e74:	00005097          	auipc	ra,0x5
     e78:	086080e7          	jalr	134(ra) # 5efa <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d14080e7          	jalr	-748(ra) # 5b92 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00005517          	auipc	a0,0x5
     e8c:	7a050513          	addi	a0,a0,1952 # 6628 <malloc+0x676>
     e90:	00005097          	auipc	ra,0x5
     e94:	06a080e7          	jalr	106(ra) # 5efa <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	cf8080e7          	jalr	-776(ra) # 5b92 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00005517          	auipc	a0,0x5
     ea8:	7ac50513          	addi	a0,a0,1964 # 6650 <malloc+0x69e>
     eac:	00005097          	auipc	ra,0x5
     eb0:	04e080e7          	jalr	78(ra) # 5efa <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	cdc080e7          	jalr	-804(ra) # 5b92 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00005517          	auipc	a0,0x5
     ec4:	7b050513          	addi	a0,a0,1968 # 6670 <malloc+0x6be>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	032080e7          	jalr	50(ra) # 5efa <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	cc0080e7          	jalr	-832(ra) # 5b92 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00005517          	auipc	a0,0x5
     ee0:	7b450513          	addi	a0,a0,1972 # 6690 <malloc+0x6de>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	016080e7          	jalr	22(ra) # 5efa <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	ca4080e7          	jalr	-860(ra) # 5b92 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00005517          	auipc	a0,0x5
     f08:	7ac50513          	addi	a0,a0,1964 # 66b0 <malloc+0x6fe>
     f0c:	00005097          	auipc	ra,0x5
     f10:	cd6080e7          	jalr	-810(ra) # 5be2 <unlink>
  unlink("lf2");
     f14:	00005517          	auipc	a0,0x5
     f18:	7a450513          	addi	a0,a0,1956 # 66b8 <malloc+0x706>
     f1c:	00005097          	auipc	ra,0x5
     f20:	cc6080e7          	jalr	-826(ra) # 5be2 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00005517          	auipc	a0,0x5
     f2c:	78850513          	addi	a0,a0,1928 # 66b0 <malloc+0x6fe>
     f30:	00005097          	auipc	ra,0x5
     f34:	ca2080e7          	jalr	-862(ra) # 5bd2 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	6c058593          	addi	a1,a1,1728 # 6600 <malloc+0x64e>
     f48:	00005097          	auipc	ra,0x5
     f4c:	c6a080e7          	jalr	-918(ra) # 5bb2 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	c62080e7          	jalr	-926(ra) # 5bba <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	75858593          	addi	a1,a1,1880 # 66b8 <malloc+0x706>
     f68:	00005517          	auipc	a0,0x5
     f6c:	74850513          	addi	a0,a0,1864 # 66b0 <malloc+0x6fe>
     f70:	00005097          	auipc	ra,0x5
     f74:	c82080e7          	jalr	-894(ra) # 5bf2 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	73450513          	addi	a0,a0,1844 # 66b0 <malloc+0x6fe>
     f84:	00005097          	auipc	ra,0x5
     f88:	c5e080e7          	jalr	-930(ra) # 5be2 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	72250513          	addi	a0,a0,1826 # 66b0 <malloc+0x6fe>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c3c080e7          	jalr	-964(ra) # 5bd2 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	71450513          	addi	a0,a0,1812 # 66b8 <malloc+0x706>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c26080e7          	jalr	-986(ra) # 5bd2 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	cbc58593          	addi	a1,a1,-836 # cc78 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	be6080e7          	jalr	-1050(ra) # 5baa <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	be6080e7          	jalr	-1050(ra) # 5bba <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	6dc58593          	addi	a1,a1,1756 # 66b8 <malloc+0x706>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c0c080e7          	jalr	-1012(ra) # 5bf2 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	6c650513          	addi	a0,a0,1734 # 66b8 <malloc+0x706>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	be8080e7          	jalr	-1048(ra) # 5be2 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	6ae58593          	addi	a1,a1,1710 # 66b0 <malloc+0x6fe>
    100a:	00005517          	auipc	a0,0x5
    100e:	6ae50513          	addi	a0,a0,1710 # 66b8 <malloc+0x706>
    1012:	00005097          	auipc	ra,0x5
    1016:	be0080e7          	jalr	-1056(ra) # 5bf2 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	69258593          	addi	a1,a1,1682 # 66b0 <malloc+0x6fe>
    1026:	00005517          	auipc	a0,0x5
    102a:	79a50513          	addi	a0,a0,1946 # 67c0 <malloc+0x80e>
    102e:	00005097          	auipc	ra,0x5
    1032:	bc4080e7          	jalr	-1084(ra) # 5bf2 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	67850513          	addi	a0,a0,1656 # 66c0 <malloc+0x70e>
    1050:	00005097          	auipc	ra,0x5
    1054:	eaa080e7          	jalr	-342(ra) # 5efa <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b38080e7          	jalr	-1224(ra) # 5b92 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	67450513          	addi	a0,a0,1652 # 66d8 <malloc+0x726>
    106c:	00005097          	auipc	ra,0x5
    1070:	e8e080e7          	jalr	-370(ra) # 5efa <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b1c080e7          	jalr	-1252(ra) # 5b92 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	67050513          	addi	a0,a0,1648 # 66f0 <malloc+0x73e>
    1088:	00005097          	auipc	ra,0x5
    108c:	e72080e7          	jalr	-398(ra) # 5efa <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b00080e7          	jalr	-1280(ra) # 5b92 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	67450513          	addi	a0,a0,1652 # 6710 <malloc+0x75e>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	e56080e7          	jalr	-426(ra) # 5efa <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	ae4080e7          	jalr	-1308(ra) # 5b92 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	68850513          	addi	a0,a0,1672 # 6740 <malloc+0x78e>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	e3a080e7          	jalr	-454(ra) # 5efa <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	ac8080e7          	jalr	-1336(ra) # 5b92 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	68450513          	addi	a0,a0,1668 # 6758 <malloc+0x7a6>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e1e080e7          	jalr	-482(ra) # 5efa <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	aac080e7          	jalr	-1364(ra) # 5b92 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	68050513          	addi	a0,a0,1664 # 6770 <malloc+0x7be>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e02080e7          	jalr	-510(ra) # 5efa <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	a90080e7          	jalr	-1392(ra) # 5b92 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	68c50513          	addi	a0,a0,1676 # 6798 <malloc+0x7e6>
    1114:	00005097          	auipc	ra,0x5
    1118:	de6080e7          	jalr	-538(ra) # 5efa <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	a74080e7          	jalr	-1420(ra) # 5b92 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	6a050513          	addi	a0,a0,1696 # 67c8 <malloc+0x816>
    1130:	00005097          	auipc	ra,0x5
    1134:	dca080e7          	jalr	-566(ra) # 5efa <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	a58080e7          	jalr	-1448(ra) # 5b92 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	68e98993          	addi	s3,s3,1678 # 67e8 <malloc+0x836>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	a84080e7          	jalr	-1404(ra) # 5bf2 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	66250513          	addi	a0,a0,1634 # 67f8 <malloc+0x846>
    119e:	00005097          	auipc	ra,0x5
    11a2:	d5c080e7          	jalr	-676(ra) # 5efa <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	9ea080e7          	jalr	-1558(ra) # 5b92 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	65250513          	addi	a0,a0,1618 # 6818 <malloc+0x866>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a14080e7          	jalr	-1516(ra) # 5be2 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	63e50513          	addi	a0,a0,1598 # 6818 <malloc+0x866>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	9f0080e7          	jalr	-1552(ra) # 5bd2 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	9cc080e7          	jalr	-1588(ra) # 5bba <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	61ca0a13          	addi	s4,s4,1564 # 6818 <malloc+0x866>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9571b          	sraiw	a4,s2,0x1f
    1210:	01a7571b          	srliw	a4,a4,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	9b6080e7          	jalr	-1610(ra) # 5bf2 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	5ca50513          	addi	a0,a0,1482 # 6818 <malloc+0x866>
    1256:	00005097          	auipc	ra,0x5
    125a:	98c080e7          	jalr	-1652(ra) # 5be2 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d71b          	sraiw	a4,s1,0x1f
    126e:	01a7571b          	srliw	a4,a4,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	94a080e7          	jalr	-1718(ra) # 5be2 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	56250513          	addi	a0,a0,1378 # 6820 <malloc+0x86e>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	c34080e7          	jalr	-972(ra) # 5efa <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	8c2080e7          	jalr	-1854(ra) # 5b92 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	56250513          	addi	a0,a0,1378 # 6840 <malloc+0x88e>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c14080e7          	jalr	-1004(ra) # 5efa <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8a2080e7          	jalr	-1886(ra) # 5b92 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	56650513          	addi	a0,a0,1382 # 6860 <malloc+0x8ae>
    1302:	00005097          	auipc	ra,0x5
    1306:	bf8080e7          	jalr	-1032(ra) # 5efa <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	886080e7          	jalr	-1914(ra) # 5b92 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	89a080e7          	jalr	-1894(ra) # 5bca <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	868080e7          	jalr	-1944(ra) # 5ba2 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	84e080e7          	jalr	-1970(ra) # 5b92 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	d7298993          	addi	s3,s3,-654 # 60d8 <malloc+0x126>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	84e080e7          	jalr	-1970(ra) # 5bca <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	808080e7          	jalr	-2040(ra) # 5b92 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	82a080e7          	jalr	-2006(ra) # 5be2 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	804080e7          	jalr	-2044(ra) # 5bd2 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	810080e7          	jalr	-2032(ra) # 5bf2 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	6c878793          	addi	a5,a5,1736 # 7ab8 <malloc+0x1b06>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00004097          	auipc	ra,0x4
    140c:	7c2080e7          	jalr	1986(ra) # 5bca <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	774080e7          	jalr	1908(ra) # 5b8a <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	13a78793          	addi	a5,a5,314 # 9560 <big.0>
    142e:	00009697          	auipc	a3,0x9
    1432:	13268693          	addi	a3,a3,306 # a560 <big.0+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	10078e23          	sb	zero,284(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	0ac78793          	addi	a5,a5,172 # 84f8 <malloc+0x2546>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	c6850513          	addi	a0,a0,-920 # 60d8 <malloc+0x126>
    1478:	00004097          	auipc	ra,0x4
    147c:	752080e7          	jalr	1874(ra) # 5bca <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	48050513          	addi	a0,a0,1152 # 6908 <malloc+0x956>
    1490:	00005097          	auipc	ra,0x5
    1494:	a6a080e7          	jalr	-1430(ra) # 5efa <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	6f8080e7          	jalr	1784(ra) # 5b92 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	3d850513          	addi	a0,a0,984 # 6880 <malloc+0x8ce>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	a4a080e7          	jalr	-1462(ra) # 5efa <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	6d8080e7          	jalr	1752(ra) # 5b92 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	3d850513          	addi	a0,a0,984 # 68a0 <malloc+0x8ee>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a2a080e7          	jalr	-1494(ra) # 5efa <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	6b8080e7          	jalr	1720(ra) # 5b92 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	3d650513          	addi	a0,a0,982 # 68c0 <malloc+0x90e>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a08080e7          	jalr	-1528(ra) # 5efa <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	696080e7          	jalr	1686(ra) # 5b92 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	3de50513          	addi	a0,a0,990 # 68e8 <malloc+0x936>
    1512:	00005097          	auipc	ra,0x5
    1516:	9e8080e7          	jalr	-1560(ra) # 5efa <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	676080e7          	jalr	1654(ra) # 5b92 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	84450513          	addi	a0,a0,-1980 # 6d68 <malloc+0xdb6>
    152c:	00005097          	auipc	ra,0x5
    1530:	9ce080e7          	jalr	-1586(ra) # 5efa <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	65c080e7          	jalr	1628(ra) # 5b92 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	650080e7          	jalr	1616(ra) # 5b92 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	648080e7          	jalr	1608(ra) # 5b9a <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	3c250513          	addi	a0,a0,962 # 6930 <malloc+0x97e>
    1576:	00005097          	auipc	ra,0x5
    157a:	984080e7          	jalr	-1660(ra) # 5efa <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	612080e7          	jalr	1554(ra) # 5b92 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	b9050513          	addi	a0,a0,-1136 # 6130 <malloc+0x17e>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	62a080e7          	jalr	1578(ra) # 5bd2 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	60a080e7          	jalr	1546(ra) # 5bba <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	5d2080e7          	jalr	1490(ra) # 5b8a <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	b66a0a13          	addi	s4,s4,-1178 # 6130 <malloc+0x17e>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	3bea8a93          	addi	s5,s5,958 # 6990 <malloc+0x9de>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	5f4080e7          	jalr	1524(ra) # 5bd2 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	5c2080e7          	jalr	1474(ra) # 5bb2 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	5ba080e7          	jalr	1466(ra) # 5bba <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	5c6080e7          	jalr	1478(ra) # 5bd2 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	58c080e7          	jalr	1420(ra) # 5baa <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	592080e7          	jalr	1426(ra) # 5bba <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	55a080e7          	jalr	1370(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	31e50513          	addi	a0,a0,798 # 6960 <malloc+0x9ae>
    164a:	00005097          	auipc	ra,0x5
    164e:	8b0080e7          	jalr	-1872(ra) # 5efa <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	53e080e7          	jalr	1342(ra) # 5b92 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	31a50513          	addi	a0,a0,794 # 6978 <malloc+0x9c6>
    1666:	00005097          	auipc	ra,0x5
    166a:	894080e7          	jalr	-1900(ra) # 5efa <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	522080e7          	jalr	1314(ra) # 5b92 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	32450513          	addi	a0,a0,804 # 69a0 <malloc+0x9ee>
    1684:	00005097          	auipc	ra,0x5
    1688:	876080e7          	jalr	-1930(ra) # 5efa <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	504080e7          	jalr	1284(ra) # 5b92 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	a96a0a13          	addi	s4,s4,-1386 # 6130 <malloc+0x17e>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	31ea8a93          	addi	s5,s5,798 # 69c0 <malloc+0xa0e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	522080e7          	jalr	1314(ra) # 5bd2 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	4f0080e7          	jalr	1264(ra) # 5bb2 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	4e8080e7          	jalr	1256(ra) # 5bba <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	4b6080e7          	jalr	1206(ra) # 5b9a <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	a4450513          	addi	a0,a0,-1468 # 6130 <malloc+0x17e>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	4ee080e7          	jalr	1262(ra) # 5be2 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	492080e7          	jalr	1170(ra) # 5b92 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	26e50513          	addi	a0,a0,622 # 6978 <malloc+0x9c6>
    1712:	00004097          	auipc	ra,0x4
    1716:	7e8080e7          	jalr	2024(ra) # 5efa <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	476080e7          	jalr	1142(ra) # 5b92 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	2a050513          	addi	a0,a0,672 # 69c8 <malloc+0xa16>
    1730:	00004097          	auipc	ra,0x4
    1734:	7ca080e7          	jalr	1994(ra) # 5efa <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	458080e7          	jalr	1112(ra) # 5b92 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	98878793          	addi	a5,a5,-1656 # 60d8 <malloc+0x126>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	28c78793          	addi	a5,a5,652 # 69e8 <malloc+0xa36>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	28450513          	addi	a0,a0,644 # 69f0 <malloc+0xa3e>
    1774:	00004097          	auipc	ra,0x4
    1778:	46e080e7          	jalr	1134(ra) # 5be2 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	40e080e7          	jalr	1038(ra) # 5b8a <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	42c080e7          	jalr	1068(ra) # 5bba <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	25650513          	addi	a0,a0,598 # 69f0 <malloc+0xa3e>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	430080e7          	jalr	1072(ra) # 5bd2 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	25a50513          	addi	a0,a0,602 # 6a10 <malloc+0xa5e>
    17be:	00004097          	auipc	ra,0x4
    17c2:	73c080e7          	jalr	1852(ra) # 5efa <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	3ca080e7          	jalr	970(ra) # 5b92 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	18e50513          	addi	a0,a0,398 # 6960 <malloc+0x9ae>
    17da:	00004097          	auipc	ra,0x4
    17de:	720080e7          	jalr	1824(ra) # 5efa <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	3ae080e7          	jalr	942(ra) # 5b92 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	20a50513          	addi	a0,a0,522 # 69f8 <malloc+0xa46>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	704080e7          	jalr	1796(ra) # 5efa <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	392080e7          	jalr	914(ra) # 5b92 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	8cc50513          	addi	a0,a0,-1844 # 60d8 <malloc+0x126>
    1814:	00004097          	auipc	ra,0x4
    1818:	3b6080e7          	jalr	950(ra) # 5bca <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	376080e7          	jalr	886(ra) # 5b9a <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	35c080e7          	jalr	860(ra) # 5b92 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	1e050513          	addi	a0,a0,480 # 6a20 <malloc+0xa6e>
    1848:	00004097          	auipc	ra,0x4
    184c:	6b2080e7          	jalr	1714(ra) # 5efa <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	340080e7          	jalr	832(ra) # 5b92 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	1dc50513          	addi	a0,a0,476 # 6a38 <malloc+0xa86>
    1864:	00004097          	auipc	ra,0x4
    1868:	696080e7          	jalr	1686(ra) # 5efa <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	18050513          	addi	a0,a0,384 # 69f0 <malloc+0xa3e>
    1878:	00004097          	auipc	ra,0x4
    187c:	35a080e7          	jalr	858(ra) # 5bd2 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	320080e7          	jalr	800(ra) # 5baa <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c0e50513          	addi	a0,a0,-1010 # 64a8 <malloc+0x4f6>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	658080e7          	jalr	1624(ra) # 5efa <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	2e6080e7          	jalr	742(ra) # 5b92 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	0c250513          	addi	a0,a0,194 # 6978 <malloc+0x9c6>
    18be:	00004097          	auipc	ra,0x4
    18c2:	63c080e7          	jalr	1596(ra) # 5efa <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	2ca080e7          	jalr	714(ra) # 5b92 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	12050513          	addi	a0,a0,288 # 69f0 <malloc+0xa3e>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	30a080e7          	jalr	778(ra) # 5be2 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	15650513          	addi	a0,a0,342 # 6a50 <malloc+0xa9e>
    1902:	00004097          	auipc	ra,0x4
    1906:	5f8080e7          	jalr	1528(ra) # 5efa <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	286080e7          	jalr	646(ra) # 5b92 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	27c080e7          	jalr	636(ra) # 5b92 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	268080e7          	jalr	616(ra) # 5ba2 <pipe>
    1942:	e93d                	bnez	a0,19b8 <pipe1+0x9a>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	244080e7          	jalr	580(ra) # 5b8a <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c151                	beqz	a0,19d4 <pipe1+0xb6>
  } else if(pid > 0){
    1952:	16a05d63          	blez	a0,1acc <pipe1+0x1ae>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	260080e7          	jalr	608(ra) # 5bba <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	312a8a93          	addi	s5,s5,786 # cc78 <buf>
    196e:	864e                	mv	a2,s3
    1970:	85d6                	mv	a1,s5
    1972:	fa842503          	lw	a0,-88(s0)
    1976:	00004097          	auipc	ra,0x4
    197a:	234080e7          	jalr	564(ra) # 5baa <read>
    197e:	10a05263          	blez	a0,1a82 <pipe1+0x164>
      for(i = 0; i < n; i++){
    1982:	0000b717          	auipc	a4,0xb
    1986:	2f670713          	addi	a4,a4,758 # cc78 <buf>
    198a:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    198e:	00074683          	lbu	a3,0(a4)
    1992:	0ff4f793          	zext.b	a5,s1
    1996:	2485                	addiw	s1,s1,1
    1998:	0cf69163          	bne	a3,a5,1a5a <pipe1+0x13c>
      for(i = 0; i < n; i++){
    199c:	0705                	addi	a4,a4,1
    199e:	fec498e3          	bne	s1,a2,198e <pipe1+0x70>
      total += n;
    19a2:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a6:	0019979b          	slliw	a5,s3,0x1
    19aa:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19ae:	670d                	lui	a4,0x3
    19b0:	fb377fe3          	bgeu	a4,s3,196e <pipe1+0x50>
        cc = sizeof(buf);
    19b4:	698d                	lui	s3,0x3
    19b6:	bf65                	j	196e <pipe1+0x50>
    printf("%s: pipe() failed\n", s);
    19b8:	85ca                	mv	a1,s2
    19ba:	00005517          	auipc	a0,0x5
    19be:	0ae50513          	addi	a0,a0,174 # 6a68 <malloc+0xab6>
    19c2:	00004097          	auipc	ra,0x4
    19c6:	538080e7          	jalr	1336(ra) # 5efa <printf>
    exit(1);
    19ca:	4505                	li	a0,1
    19cc:	00004097          	auipc	ra,0x4
    19d0:	1c6080e7          	jalr	454(ra) # 5b92 <exit>
    close(fds[0]);
    19d4:	fa842503          	lw	a0,-88(s0)
    19d8:	00004097          	auipc	ra,0x4
    19dc:	1e2080e7          	jalr	482(ra) # 5bba <close>
    for(n = 0; n < N; n++){
    19e0:	0000bb17          	auipc	s6,0xb
    19e4:	298b0b13          	addi	s6,s6,664 # cc78 <buf>
    19e8:	416004bb          	negw	s1,s6
    19ec:	0ff4f493          	zext.b	s1,s1
    19f0:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f4:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f6:	6a85                	lui	s5,0x1
    19f8:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fc:	87da                	mv	a5,s6
        buf[i] = seq++;
    19fe:	0097873b          	addw	a4,a5,s1
    1a02:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a06:	0785                	addi	a5,a5,1
    1a08:	fef99be3          	bne	s3,a5,19fe <pipe1+0xe0>
        buf[i] = seq++;
    1a0c:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a10:	40900613          	li	a2,1033
    1a14:	85de                	mv	a1,s7
    1a16:	fac42503          	lw	a0,-84(s0)
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	198080e7          	jalr	408(ra) # 5bb2 <write>
    1a22:	40900793          	li	a5,1033
    1a26:	00f51c63          	bne	a0,a5,1a3e <pipe1+0x120>
    for(n = 0; n < N; n++){
    1a2a:	24a5                	addiw	s1,s1,9
    1a2c:	0ff4f493          	zext.b	s1,s1
    1a30:	fd5a16e3          	bne	s4,s5,19fc <pipe1+0xde>
    exit(0);
    1a34:	4501                	li	a0,0
    1a36:	00004097          	auipc	ra,0x4
    1a3a:	15c080e7          	jalr	348(ra) # 5b92 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a3e:	85ca                	mv	a1,s2
    1a40:	00005517          	auipc	a0,0x5
    1a44:	04050513          	addi	a0,a0,64 # 6a80 <malloc+0xace>
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	4b2080e7          	jalr	1202(ra) # 5efa <printf>
        exit(1);
    1a50:	4505                	li	a0,1
    1a52:	00004097          	auipc	ra,0x4
    1a56:	140080e7          	jalr	320(ra) # 5b92 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5a:	85ca                	mv	a1,s2
    1a5c:	00005517          	auipc	a0,0x5
    1a60:	03c50513          	addi	a0,a0,60 # 6a98 <malloc+0xae6>
    1a64:	00004097          	auipc	ra,0x4
    1a68:	496080e7          	jalr	1174(ra) # 5efa <printf>
}
    1a6c:	60e6                	ld	ra,88(sp)
    1a6e:	6446                	ld	s0,80(sp)
    1a70:	64a6                	ld	s1,72(sp)
    1a72:	6906                	ld	s2,64(sp)
    1a74:	79e2                	ld	s3,56(sp)
    1a76:	7a42                	ld	s4,48(sp)
    1a78:	7aa2                	ld	s5,40(sp)
    1a7a:	7b02                	ld	s6,32(sp)
    1a7c:	6be2                	ld	s7,24(sp)
    1a7e:	6125                	addi	sp,sp,96
    1a80:	8082                	ret
    if(total != N * SZ){
    1a82:	6785                	lui	a5,0x1
    1a84:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a88:	02fa0063          	beq	s4,a5,1aa8 <pipe1+0x18a>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8c:	85d2                	mv	a1,s4
    1a8e:	00005517          	auipc	a0,0x5
    1a92:	02250513          	addi	a0,a0,34 # 6ab0 <malloc+0xafe>
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	464080e7          	jalr	1124(ra) # 5efa <printf>
      exit(1);
    1a9e:	4505                	li	a0,1
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	0f2080e7          	jalr	242(ra) # 5b92 <exit>
    close(fds[0]);
    1aa8:	fa842503          	lw	a0,-88(s0)
    1aac:	00004097          	auipc	ra,0x4
    1ab0:	10e080e7          	jalr	270(ra) # 5bba <close>
    wait(&xstatus);
    1ab4:	fa440513          	addi	a0,s0,-92
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	0e2080e7          	jalr	226(ra) # 5b9a <wait>
    exit(xstatus);
    1ac0:	fa442503          	lw	a0,-92(s0)
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	0ce080e7          	jalr	206(ra) # 5b92 <exit>
    printf("%s: fork() failed\n", s);
    1acc:	85ca                	mv	a1,s2
    1ace:	00005517          	auipc	a0,0x5
    1ad2:	00250513          	addi	a0,a0,2 # 6ad0 <malloc+0xb1e>
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	424080e7          	jalr	1060(ra) # 5efa <printf>
    exit(1);
    1ade:	4505                	li	a0,1
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	0b2080e7          	jalr	178(ra) # 5b92 <exit>

0000000000001ae8 <exitwait>:
{
    1ae8:	7139                	addi	sp,sp,-64
    1aea:	fc06                	sd	ra,56(sp)
    1aec:	f822                	sd	s0,48(sp)
    1aee:	f426                	sd	s1,40(sp)
    1af0:	f04a                	sd	s2,32(sp)
    1af2:	ec4e                	sd	s3,24(sp)
    1af4:	e852                	sd	s4,16(sp)
    1af6:	0080                	addi	s0,sp,64
    1af8:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afa:	4901                	li	s2,0
    1afc:	06400993          	li	s3,100
    pid = fork();
    1b00:	00004097          	auipc	ra,0x4
    1b04:	08a080e7          	jalr	138(ra) # 5b8a <fork>
    1b08:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0a:	02054a63          	bltz	a0,1b3e <exitwait+0x56>
    if(pid){
    1b0e:	c151                	beqz	a0,1b92 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b10:	fcc40513          	addi	a0,s0,-52
    1b14:	00004097          	auipc	ra,0x4
    1b18:	086080e7          	jalr	134(ra) # 5b9a <wait>
    1b1c:	02951f63          	bne	a0,s1,1b5a <exitwait+0x72>
      if(i != xstate) {
    1b20:	fcc42783          	lw	a5,-52(s0)
    1b24:	05279963          	bne	a5,s2,1b76 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b28:	2905                	addiw	s2,s2,1
    1b2a:	fd391be3          	bne	s2,s3,1b00 <exitwait+0x18>
}
    1b2e:	70e2                	ld	ra,56(sp)
    1b30:	7442                	ld	s0,48(sp)
    1b32:	74a2                	ld	s1,40(sp)
    1b34:	7902                	ld	s2,32(sp)
    1b36:	69e2                	ld	s3,24(sp)
    1b38:	6a42                	ld	s4,16(sp)
    1b3a:	6121                	addi	sp,sp,64
    1b3c:	8082                	ret
      printf("%s: fork failed\n", s);
    1b3e:	85d2                	mv	a1,s4
    1b40:	00005517          	auipc	a0,0x5
    1b44:	e2050513          	addi	a0,a0,-480 # 6960 <malloc+0x9ae>
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	3b2080e7          	jalr	946(ra) # 5efa <printf>
      exit(1);
    1b50:	4505                	li	a0,1
    1b52:	00004097          	auipc	ra,0x4
    1b56:	040080e7          	jalr	64(ra) # 5b92 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5a:	85d2                	mv	a1,s4
    1b5c:	00005517          	auipc	a0,0x5
    1b60:	f8c50513          	addi	a0,a0,-116 # 6ae8 <malloc+0xb36>
    1b64:	00004097          	auipc	ra,0x4
    1b68:	396080e7          	jalr	918(ra) # 5efa <printf>
        exit(1);
    1b6c:	4505                	li	a0,1
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	024080e7          	jalr	36(ra) # 5b92 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b76:	85d2                	mv	a1,s4
    1b78:	00005517          	auipc	a0,0x5
    1b7c:	f8850513          	addi	a0,a0,-120 # 6b00 <malloc+0xb4e>
    1b80:	00004097          	auipc	ra,0x4
    1b84:	37a080e7          	jalr	890(ra) # 5efa <printf>
        exit(1);
    1b88:	4505                	li	a0,1
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	008080e7          	jalr	8(ra) # 5b92 <exit>
      exit(i);
    1b92:	854a                	mv	a0,s2
    1b94:	00004097          	auipc	ra,0x4
    1b98:	ffe080e7          	jalr	-2(ra) # 5b92 <exit>

0000000000001b9c <twochildren>:
{
    1b9c:	1101                	addi	sp,sp,-32
    1b9e:	ec06                	sd	ra,24(sp)
    1ba0:	e822                	sd	s0,16(sp)
    1ba2:	e426                	sd	s1,8(sp)
    1ba4:	e04a                	sd	s2,0(sp)
    1ba6:	1000                	addi	s0,sp,32
    1ba8:	892a                	mv	s2,a0
    1baa:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bae:	00004097          	auipc	ra,0x4
    1bb2:	fdc080e7          	jalr	-36(ra) # 5b8a <fork>
    if(pid1 < 0){
    1bb6:	02054c63          	bltz	a0,1bee <twochildren+0x52>
    if(pid1 == 0){
    1bba:	c921                	beqz	a0,1c0a <twochildren+0x6e>
      int pid2 = fork();
    1bbc:	00004097          	auipc	ra,0x4
    1bc0:	fce080e7          	jalr	-50(ra) # 5b8a <fork>
      if(pid2 < 0){
    1bc4:	04054763          	bltz	a0,1c12 <twochildren+0x76>
      if(pid2 == 0){
    1bc8:	c13d                	beqz	a0,1c2e <twochildren+0x92>
        wait(0);
    1bca:	4501                	li	a0,0
    1bcc:	00004097          	auipc	ra,0x4
    1bd0:	fce080e7          	jalr	-50(ra) # 5b9a <wait>
        wait(0);
    1bd4:	4501                	li	a0,0
    1bd6:	00004097          	auipc	ra,0x4
    1bda:	fc4080e7          	jalr	-60(ra) # 5b9a <wait>
  for(int i = 0; i < 1000; i++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4f9                	bnez	s1,1bae <twochildren+0x12>
}
    1be2:	60e2                	ld	ra,24(sp)
    1be4:	6442                	ld	s0,16(sp)
    1be6:	64a2                	ld	s1,8(sp)
    1be8:	6902                	ld	s2,0(sp)
    1bea:	6105                	addi	sp,sp,32
    1bec:	8082                	ret
      printf("%s: fork failed\n", s);
    1bee:	85ca                	mv	a1,s2
    1bf0:	00005517          	auipc	a0,0x5
    1bf4:	d7050513          	addi	a0,a0,-656 # 6960 <malloc+0x9ae>
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	302080e7          	jalr	770(ra) # 5efa <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	00004097          	auipc	ra,0x4
    1c06:	f90080e7          	jalr	-112(ra) # 5b92 <exit>
      exit(0);
    1c0a:	00004097          	auipc	ra,0x4
    1c0e:	f88080e7          	jalr	-120(ra) # 5b92 <exit>
        printf("%s: fork failed\n", s);
    1c12:	85ca                	mv	a1,s2
    1c14:	00005517          	auipc	a0,0x5
    1c18:	d4c50513          	addi	a0,a0,-692 # 6960 <malloc+0x9ae>
    1c1c:	00004097          	auipc	ra,0x4
    1c20:	2de080e7          	jalr	734(ra) # 5efa <printf>
        exit(1);
    1c24:	4505                	li	a0,1
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	f6c080e7          	jalr	-148(ra) # 5b92 <exit>
        exit(0);
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	f64080e7          	jalr	-156(ra) # 5b92 <exit>

0000000000001c36 <forkfork>:
{
    1c36:	7179                	addi	sp,sp,-48
    1c38:	f406                	sd	ra,40(sp)
    1c3a:	f022                	sd	s0,32(sp)
    1c3c:	ec26                	sd	s1,24(sp)
    1c3e:	1800                	addi	s0,sp,48
    1c40:	84aa                	mv	s1,a0
    int pid = fork();
    1c42:	00004097          	auipc	ra,0x4
    1c46:	f48080e7          	jalr	-184(ra) # 5b8a <fork>
    if(pid < 0){
    1c4a:	04054163          	bltz	a0,1c8c <forkfork+0x56>
    if(pid == 0){
    1c4e:	cd29                	beqz	a0,1ca8 <forkfork+0x72>
    int pid = fork();
    1c50:	00004097          	auipc	ra,0x4
    1c54:	f3a080e7          	jalr	-198(ra) # 5b8a <fork>
    if(pid < 0){
    1c58:	02054a63          	bltz	a0,1c8c <forkfork+0x56>
    if(pid == 0){
    1c5c:	c531                	beqz	a0,1ca8 <forkfork+0x72>
    wait(&xstatus);
    1c5e:	fdc40513          	addi	a0,s0,-36
    1c62:	00004097          	auipc	ra,0x4
    1c66:	f38080e7          	jalr	-200(ra) # 5b9a <wait>
    if(xstatus != 0) {
    1c6a:	fdc42783          	lw	a5,-36(s0)
    1c6e:	ebbd                	bnez	a5,1ce4 <forkfork+0xae>
    wait(&xstatus);
    1c70:	fdc40513          	addi	a0,s0,-36
    1c74:	00004097          	auipc	ra,0x4
    1c78:	f26080e7          	jalr	-218(ra) # 5b9a <wait>
    if(xstatus != 0) {
    1c7c:	fdc42783          	lw	a5,-36(s0)
    1c80:	e3b5                	bnez	a5,1ce4 <forkfork+0xae>
}
    1c82:	70a2                	ld	ra,40(sp)
    1c84:	7402                	ld	s0,32(sp)
    1c86:	64e2                	ld	s1,24(sp)
    1c88:	6145                	addi	sp,sp,48
    1c8a:	8082                	ret
      printf("%s: fork failed", s);
    1c8c:	85a6                	mv	a1,s1
    1c8e:	00005517          	auipc	a0,0x5
    1c92:	e9250513          	addi	a0,a0,-366 # 6b20 <malloc+0xb6e>
    1c96:	00004097          	auipc	ra,0x4
    1c9a:	264080e7          	jalr	612(ra) # 5efa <printf>
      exit(1);
    1c9e:	4505                	li	a0,1
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	ef2080e7          	jalr	-270(ra) # 5b92 <exit>
{
    1ca8:	0c800493          	li	s1,200
        int pid1 = fork();
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	ede080e7          	jalr	-290(ra) # 5b8a <fork>
        if(pid1 < 0){
    1cb4:	00054f63          	bltz	a0,1cd2 <forkfork+0x9c>
        if(pid1 == 0){
    1cb8:	c115                	beqz	a0,1cdc <forkfork+0xa6>
        wait(0);
    1cba:	4501                	li	a0,0
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	ede080e7          	jalr	-290(ra) # 5b9a <wait>
      for(int j = 0; j < 200; j++){
    1cc4:	34fd                	addiw	s1,s1,-1
    1cc6:	f0fd                	bnez	s1,1cac <forkfork+0x76>
      exit(0);
    1cc8:	4501                	li	a0,0
    1cca:	00004097          	auipc	ra,0x4
    1cce:	ec8080e7          	jalr	-312(ra) # 5b92 <exit>
          exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	00004097          	auipc	ra,0x4
    1cd8:	ebe080e7          	jalr	-322(ra) # 5b92 <exit>
          exit(0);
    1cdc:	00004097          	auipc	ra,0x4
    1ce0:	eb6080e7          	jalr	-330(ra) # 5b92 <exit>
      printf("%s: fork in child failed", s);
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00005517          	auipc	a0,0x5
    1cea:	e4a50513          	addi	a0,a0,-438 # 6b30 <malloc+0xb7e>
    1cee:	00004097          	auipc	ra,0x4
    1cf2:	20c080e7          	jalr	524(ra) # 5efa <printf>
      exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	00004097          	auipc	ra,0x4
    1cfc:	e9a080e7          	jalr	-358(ra) # 5b92 <exit>

0000000000001d00 <reparent2>:
{
    1d00:	1101                	addi	sp,sp,-32
    1d02:	ec06                	sd	ra,24(sp)
    1d04:	e822                	sd	s0,16(sp)
    1d06:	e426                	sd	s1,8(sp)
    1d08:	1000                	addi	s0,sp,32
    1d0a:	32000493          	li	s1,800
    int pid1 = fork();
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	e7c080e7          	jalr	-388(ra) # 5b8a <fork>
    if(pid1 < 0){
    1d16:	00054f63          	bltz	a0,1d34 <reparent2+0x34>
    if(pid1 == 0){
    1d1a:	c915                	beqz	a0,1d4e <reparent2+0x4e>
    wait(0);
    1d1c:	4501                	li	a0,0
    1d1e:	00004097          	auipc	ra,0x4
    1d22:	e7c080e7          	jalr	-388(ra) # 5b9a <wait>
  for(int i = 0; i < 800; i++){
    1d26:	34fd                	addiw	s1,s1,-1
    1d28:	f0fd                	bnez	s1,1d0e <reparent2+0xe>
  exit(0);
    1d2a:	4501                	li	a0,0
    1d2c:	00004097          	auipc	ra,0x4
    1d30:	e66080e7          	jalr	-410(ra) # 5b92 <exit>
      printf("fork failed\n");
    1d34:	00005517          	auipc	a0,0x5
    1d38:	03450513          	addi	a0,a0,52 # 6d68 <malloc+0xdb6>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	1be080e7          	jalr	446(ra) # 5efa <printf>
      exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	e4c080e7          	jalr	-436(ra) # 5b92 <exit>
      fork();
    1d4e:	00004097          	auipc	ra,0x4
    1d52:	e3c080e7          	jalr	-452(ra) # 5b8a <fork>
      fork();
    1d56:	00004097          	auipc	ra,0x4
    1d5a:	e34080e7          	jalr	-460(ra) # 5b8a <fork>
      exit(0);
    1d5e:	4501                	li	a0,0
    1d60:	00004097          	auipc	ra,0x4
    1d64:	e32080e7          	jalr	-462(ra) # 5b92 <exit>

0000000000001d68 <createdelete>:
{
    1d68:	7175                	addi	sp,sp,-144
    1d6a:	e506                	sd	ra,136(sp)
    1d6c:	e122                	sd	s0,128(sp)
    1d6e:	fca6                	sd	s1,120(sp)
    1d70:	f8ca                	sd	s2,112(sp)
    1d72:	f4ce                	sd	s3,104(sp)
    1d74:	f0d2                	sd	s4,96(sp)
    1d76:	ecd6                	sd	s5,88(sp)
    1d78:	e8da                	sd	s6,80(sp)
    1d7a:	e4de                	sd	s7,72(sp)
    1d7c:	e0e2                	sd	s8,64(sp)
    1d7e:	fc66                	sd	s9,56(sp)
    1d80:	0900                	addi	s0,sp,144
    1d82:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d84:	4901                	li	s2,0
    1d86:	4991                	li	s3,4
    pid = fork();
    1d88:	00004097          	auipc	ra,0x4
    1d8c:	e02080e7          	jalr	-510(ra) # 5b8a <fork>
    1d90:	84aa                	mv	s1,a0
    if(pid < 0){
    1d92:	02054f63          	bltz	a0,1dd0 <createdelete+0x68>
    if(pid == 0){
    1d96:	c939                	beqz	a0,1dec <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d98:	2905                	addiw	s2,s2,1
    1d9a:	ff3917e3          	bne	s2,s3,1d88 <createdelete+0x20>
    1d9e:	4491                	li	s1,4
    wait(&xstatus);
    1da0:	f7c40513          	addi	a0,s0,-132
    1da4:	00004097          	auipc	ra,0x4
    1da8:	df6080e7          	jalr	-522(ra) # 5b9a <wait>
    if(xstatus != 0)
    1dac:	f7c42903          	lw	s2,-132(s0)
    1db0:	0e091263          	bnez	s2,1e94 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db4:	34fd                	addiw	s1,s1,-1
    1db6:	f4ed                	bnez	s1,1da0 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1db8:	f8040123          	sb	zero,-126(s0)
    1dbc:	03000993          	li	s3,48
    1dc0:	5a7d                	li	s4,-1
    1dc2:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc6:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dc8:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dca:	07400a93          	li	s5,116
    1dce:	a29d                	j	1f34 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd0:	85e6                	mv	a1,s9
    1dd2:	00005517          	auipc	a0,0x5
    1dd6:	f9650513          	addi	a0,a0,-106 # 6d68 <malloc+0xdb6>
    1dda:	00004097          	auipc	ra,0x4
    1dde:	120080e7          	jalr	288(ra) # 5efa <printf>
      exit(1);
    1de2:	4505                	li	a0,1
    1de4:	00004097          	auipc	ra,0x4
    1de8:	dae080e7          	jalr	-594(ra) # 5b92 <exit>
      name[0] = 'p' + pi;
    1dec:	0709091b          	addiw	s2,s2,112
    1df0:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df4:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1df8:	4951                	li	s2,20
    1dfa:	a015                	j	1e1e <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	bfa50513          	addi	a0,a0,-1030 # 69f8 <malloc+0xa46>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	0f4080e7          	jalr	244(ra) # 5efa <printf>
          exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	d82080e7          	jalr	-638(ra) # 5b92 <exit>
      for(i = 0; i < N; i++){
    1e18:	2485                	addiw	s1,s1,1
    1e1a:	07248863          	beq	s1,s2,1e8a <createdelete+0x122>
        name[1] = '0' + i;
    1e1e:	0304879b          	addiw	a5,s1,48
    1e22:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e26:	20200593          	li	a1,514
    1e2a:	f8040513          	addi	a0,s0,-128
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	da4080e7          	jalr	-604(ra) # 5bd2 <open>
        if(fd < 0){
    1e36:	fc0543e3          	bltz	a0,1dfc <createdelete+0x94>
        close(fd);
    1e3a:	00004097          	auipc	ra,0x4
    1e3e:	d80080e7          	jalr	-640(ra) # 5bba <close>
        if(i > 0 && (i % 2 ) == 0){
    1e42:	fc905be3          	blez	s1,1e18 <createdelete+0xb0>
    1e46:	0014f793          	andi	a5,s1,1
    1e4a:	f7f9                	bnez	a5,1e18 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4c:	01f4d79b          	srliw	a5,s1,0x1f
    1e50:	9fa5                	addw	a5,a5,s1
    1e52:	4017d79b          	sraiw	a5,a5,0x1
    1e56:	0307879b          	addiw	a5,a5,48
    1e5a:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e5e:	f8040513          	addi	a0,s0,-128
    1e62:	00004097          	auipc	ra,0x4
    1e66:	d80080e7          	jalr	-640(ra) # 5be2 <unlink>
    1e6a:	fa0557e3          	bgez	a0,1e18 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e6e:	85e6                	mv	a1,s9
    1e70:	00005517          	auipc	a0,0x5
    1e74:	ce050513          	addi	a0,a0,-800 # 6b50 <malloc+0xb9e>
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	082080e7          	jalr	130(ra) # 5efa <printf>
            exit(1);
    1e80:	4505                	li	a0,1
    1e82:	00004097          	auipc	ra,0x4
    1e86:	d10080e7          	jalr	-752(ra) # 5b92 <exit>
      exit(0);
    1e8a:	4501                	li	a0,0
    1e8c:	00004097          	auipc	ra,0x4
    1e90:	d06080e7          	jalr	-762(ra) # 5b92 <exit>
      exit(1);
    1e94:	4505                	li	a0,1
    1e96:	00004097          	auipc	ra,0x4
    1e9a:	cfc080e7          	jalr	-772(ra) # 5b92 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1e9e:	f8040613          	addi	a2,s0,-128
    1ea2:	85e6                	mv	a1,s9
    1ea4:	00005517          	auipc	a0,0x5
    1ea8:	cc450513          	addi	a0,a0,-828 # 6b68 <malloc+0xbb6>
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	04e080e7          	jalr	78(ra) # 5efa <printf>
        exit(1);
    1eb4:	4505                	li	a0,1
    1eb6:	00004097          	auipc	ra,0x4
    1eba:	cdc080e7          	jalr	-804(ra) # 5b92 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ebe:	054b7163          	bgeu	s6,s4,1f00 <createdelete+0x198>
      if(fd >= 0)
    1ec2:	02055a63          	bgez	a0,1ef6 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec6:	2485                	addiw	s1,s1,1
    1ec8:	0ff4f493          	zext.b	s1,s1
    1ecc:	05548c63          	beq	s1,s5,1f24 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed4:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1ed8:	4581                	li	a1,0
    1eda:	f8040513          	addi	a0,s0,-128
    1ede:	00004097          	auipc	ra,0x4
    1ee2:	cf4080e7          	jalr	-780(ra) # 5bd2 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee6:	00090463          	beqz	s2,1eee <createdelete+0x186>
    1eea:	fd2bdae3          	bge	s7,s2,1ebe <createdelete+0x156>
    1eee:	fa0548e3          	bltz	a0,1e9e <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef2:	014b7963          	bgeu	s6,s4,1f04 <createdelete+0x19c>
        close(fd);
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	cc4080e7          	jalr	-828(ra) # 5bba <close>
    1efe:	b7e1                	j	1ec6 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f00:	fc0543e3          	bltz	a0,1ec6 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f04:	f8040613          	addi	a2,s0,-128
    1f08:	85e6                	mv	a1,s9
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	c8650513          	addi	a0,a0,-890 # 6b90 <malloc+0xbde>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	fe8080e7          	jalr	-24(ra) # 5efa <printf>
        exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	c76080e7          	jalr	-906(ra) # 5b92 <exit>
  for(i = 0; i < N; i++){
    1f24:	2905                	addiw	s2,s2,1
    1f26:	2a05                	addiw	s4,s4,1
    1f28:	2985                	addiw	s3,s3,1 # 3001 <execout+0xa5>
    1f2a:	0ff9f993          	zext.b	s3,s3
    1f2e:	47d1                	li	a5,20
    1f30:	02f90a63          	beq	s2,a5,1f64 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f34:	84e2                	mv	s1,s8
    1f36:	bf69                	j	1ed0 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f38:	2905                	addiw	s2,s2,1
    1f3a:	0ff97913          	zext.b	s2,s2
    1f3e:	2985                	addiw	s3,s3,1
    1f40:	0ff9f993          	zext.b	s3,s3
    1f44:	03490863          	beq	s2,s4,1f74 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f48:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4a:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f4e:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f52:	f8040513          	addi	a0,s0,-128
    1f56:	00004097          	auipc	ra,0x4
    1f5a:	c8c080e7          	jalr	-884(ra) # 5be2 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f5e:	34fd                	addiw	s1,s1,-1
    1f60:	f4ed                	bnez	s1,1f4a <createdelete+0x1e2>
    1f62:	bfd9                	j	1f38 <createdelete+0x1d0>
    1f64:	03000993          	li	s3,48
    1f68:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6c:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f6e:	08400a13          	li	s4,132
    1f72:	bfd9                	j	1f48 <createdelete+0x1e0>
}
    1f74:	60aa                	ld	ra,136(sp)
    1f76:	640a                	ld	s0,128(sp)
    1f78:	74e6                	ld	s1,120(sp)
    1f7a:	7946                	ld	s2,112(sp)
    1f7c:	79a6                	ld	s3,104(sp)
    1f7e:	7a06                	ld	s4,96(sp)
    1f80:	6ae6                	ld	s5,88(sp)
    1f82:	6b46                	ld	s6,80(sp)
    1f84:	6ba6                	ld	s7,72(sp)
    1f86:	6c06                	ld	s8,64(sp)
    1f88:	7ce2                	ld	s9,56(sp)
    1f8a:	6149                	addi	sp,sp,144
    1f8c:	8082                	ret

0000000000001f8e <linkunlink>:
{
    1f8e:	711d                	addi	sp,sp,-96
    1f90:	ec86                	sd	ra,88(sp)
    1f92:	e8a2                	sd	s0,80(sp)
    1f94:	e4a6                	sd	s1,72(sp)
    1f96:	e0ca                	sd	s2,64(sp)
    1f98:	fc4e                	sd	s3,56(sp)
    1f9a:	f852                	sd	s4,48(sp)
    1f9c:	f456                	sd	s5,40(sp)
    1f9e:	f05a                	sd	s6,32(sp)
    1fa0:	ec5e                	sd	s7,24(sp)
    1fa2:	e862                	sd	s8,16(sp)
    1fa4:	e466                	sd	s9,8(sp)
    1fa6:	1080                	addi	s0,sp,96
    1fa8:	84aa                	mv	s1,a0
  unlink("x");
    1faa:	00004517          	auipc	a0,0x4
    1fae:	19e50513          	addi	a0,a0,414 # 6148 <malloc+0x196>
    1fb2:	00004097          	auipc	ra,0x4
    1fb6:	c30080e7          	jalr	-976(ra) # 5be2 <unlink>
  pid = fork();
    1fba:	00004097          	auipc	ra,0x4
    1fbe:	bd0080e7          	jalr	-1072(ra) # 5b8a <fork>
  if(pid < 0){
    1fc2:	02054b63          	bltz	a0,1ff8 <linkunlink+0x6a>
    1fc6:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fc8:	06100c93          	li	s9,97
    1fcc:	c111                	beqz	a0,1fd0 <linkunlink+0x42>
    1fce:	4c85                	li	s9,1
    1fd0:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd4:	41c659b7          	lui	s3,0x41c65
    1fd8:	e6d9899b          	addiw	s3,s3,-403 # 41c64e6d <base+0x41c551f5>
    1fdc:	690d                	lui	s2,0x3
    1fde:	0399091b          	addiw	s2,s2,57 # 3039 <fourteen+0x19>
    if((x % 3) == 0){
    1fe2:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe4:	4b05                	li	s6,1
      unlink("x");
    1fe6:	00004a97          	auipc	s5,0x4
    1fea:	162a8a93          	addi	s5,s5,354 # 6148 <malloc+0x196>
      link("cat", "x");
    1fee:	00005b97          	auipc	s7,0x5
    1ff2:	bcab8b93          	addi	s7,s7,-1078 # 6bb8 <malloc+0xc06>
    1ff6:	a825                	j	202e <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1ff8:	85a6                	mv	a1,s1
    1ffa:	00005517          	auipc	a0,0x5
    1ffe:	96650513          	addi	a0,a0,-1690 # 6960 <malloc+0x9ae>
    2002:	00004097          	auipc	ra,0x4
    2006:	ef8080e7          	jalr	-264(ra) # 5efa <printf>
    exit(1);
    200a:	4505                	li	a0,1
    200c:	00004097          	auipc	ra,0x4
    2010:	b86080e7          	jalr	-1146(ra) # 5b92 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2014:	20200593          	li	a1,514
    2018:	8556                	mv	a0,s5
    201a:	00004097          	auipc	ra,0x4
    201e:	bb8080e7          	jalr	-1096(ra) # 5bd2 <open>
    2022:	00004097          	auipc	ra,0x4
    2026:	b98080e7          	jalr	-1128(ra) # 5bba <close>
  for(i = 0; i < 100; i++){
    202a:	34fd                	addiw	s1,s1,-1
    202c:	c88d                	beqz	s1,205e <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    202e:	033c87bb          	mulw	a5,s9,s3
    2032:	012787bb          	addw	a5,a5,s2
    2036:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    203a:	0347f7bb          	remuw	a5,a5,s4
    203e:	dbf9                	beqz	a5,2014 <linkunlink+0x86>
    } else if((x % 3) == 1){
    2040:	01678863          	beq	a5,s6,2050 <linkunlink+0xc2>
      unlink("x");
    2044:	8556                	mv	a0,s5
    2046:	00004097          	auipc	ra,0x4
    204a:	b9c080e7          	jalr	-1124(ra) # 5be2 <unlink>
    204e:	bff1                	j	202a <linkunlink+0x9c>
      link("cat", "x");
    2050:	85d6                	mv	a1,s5
    2052:	855e                	mv	a0,s7
    2054:	00004097          	auipc	ra,0x4
    2058:	b9e080e7          	jalr	-1122(ra) # 5bf2 <link>
    205c:	b7f9                	j	202a <linkunlink+0x9c>
  if(pid)
    205e:	020c0463          	beqz	s8,2086 <linkunlink+0xf8>
    wait(0);
    2062:	4501                	li	a0,0
    2064:	00004097          	auipc	ra,0x4
    2068:	b36080e7          	jalr	-1226(ra) # 5b9a <wait>
}
    206c:	60e6                	ld	ra,88(sp)
    206e:	6446                	ld	s0,80(sp)
    2070:	64a6                	ld	s1,72(sp)
    2072:	6906                	ld	s2,64(sp)
    2074:	79e2                	ld	s3,56(sp)
    2076:	7a42                	ld	s4,48(sp)
    2078:	7aa2                	ld	s5,40(sp)
    207a:	7b02                	ld	s6,32(sp)
    207c:	6be2                	ld	s7,24(sp)
    207e:	6c42                	ld	s8,16(sp)
    2080:	6ca2                	ld	s9,8(sp)
    2082:	6125                	addi	sp,sp,96
    2084:	8082                	ret
    exit(0);
    2086:	4501                	li	a0,0
    2088:	00004097          	auipc	ra,0x4
    208c:	b0a080e7          	jalr	-1270(ra) # 5b92 <exit>

0000000000002090 <forktest>:
{
    2090:	7179                	addi	sp,sp,-48
    2092:	f406                	sd	ra,40(sp)
    2094:	f022                	sd	s0,32(sp)
    2096:	ec26                	sd	s1,24(sp)
    2098:	e84a                	sd	s2,16(sp)
    209a:	e44e                	sd	s3,8(sp)
    209c:	1800                	addi	s0,sp,48
    209e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a0:	4481                	li	s1,0
    20a2:	3e800913          	li	s2,1000
    pid = fork();
    20a6:	00004097          	auipc	ra,0x4
    20aa:	ae4080e7          	jalr	-1308(ra) # 5b8a <fork>
    if(pid < 0)
    20ae:	02054863          	bltz	a0,20de <forktest+0x4e>
    if(pid == 0)
    20b2:	c115                	beqz	a0,20d6 <forktest+0x46>
  for(n=0; n<N; n++){
    20b4:	2485                	addiw	s1,s1,1
    20b6:	ff2498e3          	bne	s1,s2,20a6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20ba:	85ce                	mv	a1,s3
    20bc:	00005517          	auipc	a0,0x5
    20c0:	b1c50513          	addi	a0,a0,-1252 # 6bd8 <malloc+0xc26>
    20c4:	00004097          	auipc	ra,0x4
    20c8:	e36080e7          	jalr	-458(ra) # 5efa <printf>
    exit(1);
    20cc:	4505                	li	a0,1
    20ce:	00004097          	auipc	ra,0x4
    20d2:	ac4080e7          	jalr	-1340(ra) # 5b92 <exit>
      exit(0);
    20d6:	00004097          	auipc	ra,0x4
    20da:	abc080e7          	jalr	-1348(ra) # 5b92 <exit>
  if (n == 0) {
    20de:	cc9d                	beqz	s1,211c <forktest+0x8c>
  if(n == N){
    20e0:	3e800793          	li	a5,1000
    20e4:	fcf48be3          	beq	s1,a5,20ba <forktest+0x2a>
  for(; n > 0; n--){
    20e8:	00905b63          	blez	s1,20fe <forktest+0x6e>
    if(wait(0) < 0){
    20ec:	4501                	li	a0,0
    20ee:	00004097          	auipc	ra,0x4
    20f2:	aac080e7          	jalr	-1364(ra) # 5b9a <wait>
    20f6:	04054163          	bltz	a0,2138 <forktest+0xa8>
  for(; n > 0; n--){
    20fa:	34fd                	addiw	s1,s1,-1
    20fc:	f8e5                	bnez	s1,20ec <forktest+0x5c>
  if(wait(0) != -1){
    20fe:	4501                	li	a0,0
    2100:	00004097          	auipc	ra,0x4
    2104:	a9a080e7          	jalr	-1382(ra) # 5b9a <wait>
    2108:	57fd                	li	a5,-1
    210a:	04f51563          	bne	a0,a5,2154 <forktest+0xc4>
}
    210e:	70a2                	ld	ra,40(sp)
    2110:	7402                	ld	s0,32(sp)
    2112:	64e2                	ld	s1,24(sp)
    2114:	6942                	ld	s2,16(sp)
    2116:	69a2                	ld	s3,8(sp)
    2118:	6145                	addi	sp,sp,48
    211a:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211c:	85ce                	mv	a1,s3
    211e:	00005517          	auipc	a0,0x5
    2122:	aa250513          	addi	a0,a0,-1374 # 6bc0 <malloc+0xc0e>
    2126:	00004097          	auipc	ra,0x4
    212a:	dd4080e7          	jalr	-556(ra) # 5efa <printf>
    exit(1);
    212e:	4505                	li	a0,1
    2130:	00004097          	auipc	ra,0x4
    2134:	a62080e7          	jalr	-1438(ra) # 5b92 <exit>
      printf("%s: wait stopped early\n", s);
    2138:	85ce                	mv	a1,s3
    213a:	00005517          	auipc	a0,0x5
    213e:	ac650513          	addi	a0,a0,-1338 # 6c00 <malloc+0xc4e>
    2142:	00004097          	auipc	ra,0x4
    2146:	db8080e7          	jalr	-584(ra) # 5efa <printf>
      exit(1);
    214a:	4505                	li	a0,1
    214c:	00004097          	auipc	ra,0x4
    2150:	a46080e7          	jalr	-1466(ra) # 5b92 <exit>
    printf("%s: wait got too many\n", s);
    2154:	85ce                	mv	a1,s3
    2156:	00005517          	auipc	a0,0x5
    215a:	ac250513          	addi	a0,a0,-1342 # 6c18 <malloc+0xc66>
    215e:	00004097          	auipc	ra,0x4
    2162:	d9c080e7          	jalr	-612(ra) # 5efa <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	00004097          	auipc	ra,0x4
    216c:	a2a080e7          	jalr	-1494(ra) # 5b92 <exit>

0000000000002170 <kernmem>:
{
    2170:	715d                	addi	sp,sp,-80
    2172:	e486                	sd	ra,72(sp)
    2174:	e0a2                	sd	s0,64(sp)
    2176:	fc26                	sd	s1,56(sp)
    2178:	f84a                	sd	s2,48(sp)
    217a:	f44e                	sd	s3,40(sp)
    217c:	f052                	sd	s4,32(sp)
    217e:	ec56                	sd	s5,24(sp)
    2180:	0880                	addi	s0,sp,80
    2182:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2184:	4485                	li	s1,1
    2186:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2188:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218a:	69b1                	lui	s3,0xc
    218c:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2190:	1003d937          	lui	s2,0x1003d
    2194:	090e                	slli	s2,s2,0x3
    2196:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    219a:	00004097          	auipc	ra,0x4
    219e:	9f0080e7          	jalr	-1552(ra) # 5b8a <fork>
    if(pid < 0){
    21a2:	02054963          	bltz	a0,21d4 <kernmem+0x64>
    if(pid == 0){
    21a6:	c529                	beqz	a0,21f0 <kernmem+0x80>
    wait(&xstatus);
    21a8:	fbc40513          	addi	a0,s0,-68
    21ac:	00004097          	auipc	ra,0x4
    21b0:	9ee080e7          	jalr	-1554(ra) # 5b9a <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b4:	fbc42783          	lw	a5,-68(s0)
    21b8:	05579d63          	bne	a5,s5,2212 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21bc:	94ce                	add	s1,s1,s3
    21be:	fd249ee3          	bne	s1,s2,219a <kernmem+0x2a>
}
    21c2:	60a6                	ld	ra,72(sp)
    21c4:	6406                	ld	s0,64(sp)
    21c6:	74e2                	ld	s1,56(sp)
    21c8:	7942                	ld	s2,48(sp)
    21ca:	79a2                	ld	s3,40(sp)
    21cc:	7a02                	ld	s4,32(sp)
    21ce:	6ae2                	ld	s5,24(sp)
    21d0:	6161                	addi	sp,sp,80
    21d2:	8082                	ret
      printf("%s: fork failed\n", s);
    21d4:	85d2                	mv	a1,s4
    21d6:	00004517          	auipc	a0,0x4
    21da:	78a50513          	addi	a0,a0,1930 # 6960 <malloc+0x9ae>
    21de:	00004097          	auipc	ra,0x4
    21e2:	d1c080e7          	jalr	-740(ra) # 5efa <printf>
      exit(1);
    21e6:	4505                	li	a0,1
    21e8:	00004097          	auipc	ra,0x4
    21ec:	9aa080e7          	jalr	-1622(ra) # 5b92 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f0:	0004c683          	lbu	a3,0(s1)
    21f4:	8626                	mv	a2,s1
    21f6:	85d2                	mv	a1,s4
    21f8:	00005517          	auipc	a0,0x5
    21fc:	a3850513          	addi	a0,a0,-1480 # 6c30 <malloc+0xc7e>
    2200:	00004097          	auipc	ra,0x4
    2204:	cfa080e7          	jalr	-774(ra) # 5efa <printf>
      exit(1);
    2208:	4505                	li	a0,1
    220a:	00004097          	auipc	ra,0x4
    220e:	988080e7          	jalr	-1656(ra) # 5b92 <exit>
      exit(1);
    2212:	4505                	li	a0,1
    2214:	00004097          	auipc	ra,0x4
    2218:	97e080e7          	jalr	-1666(ra) # 5b92 <exit>

000000000000221c <MAXVAplus>:
{
    221c:	7179                	addi	sp,sp,-48
    221e:	f406                	sd	ra,40(sp)
    2220:	f022                	sd	s0,32(sp)
    2222:	ec26                	sd	s1,24(sp)
    2224:	e84a                	sd	s2,16(sp)
    2226:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2228:	4785                	li	a5,1
    222a:	179a                	slli	a5,a5,0x26
    222c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2230:	fd843783          	ld	a5,-40(s0)
    2234:	cf85                	beqz	a5,226c <MAXVAplus+0x50>
    2236:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2238:	54fd                	li	s1,-1
    pid = fork();
    223a:	00004097          	auipc	ra,0x4
    223e:	950080e7          	jalr	-1712(ra) # 5b8a <fork>
    if(pid < 0){
    2242:	02054b63          	bltz	a0,2278 <MAXVAplus+0x5c>
    if(pid == 0){
    2246:	c539                	beqz	a0,2294 <MAXVAplus+0x78>
    wait(&xstatus);
    2248:	fd440513          	addi	a0,s0,-44
    224c:	00004097          	auipc	ra,0x4
    2250:	94e080e7          	jalr	-1714(ra) # 5b9a <wait>
    if(xstatus != -1)  // did kernel kill child?
    2254:	fd442783          	lw	a5,-44(s0)
    2258:	06979463          	bne	a5,s1,22c0 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225c:	fd843783          	ld	a5,-40(s0)
    2260:	0786                	slli	a5,a5,0x1
    2262:	fcf43c23          	sd	a5,-40(s0)
    2266:	fd843783          	ld	a5,-40(s0)
    226a:	fbe1                	bnez	a5,223a <MAXVAplus+0x1e>
}
    226c:	70a2                	ld	ra,40(sp)
    226e:	7402                	ld	s0,32(sp)
    2270:	64e2                	ld	s1,24(sp)
    2272:	6942                	ld	s2,16(sp)
    2274:	6145                	addi	sp,sp,48
    2276:	8082                	ret
      printf("%s: fork failed\n", s);
    2278:	85ca                	mv	a1,s2
    227a:	00004517          	auipc	a0,0x4
    227e:	6e650513          	addi	a0,a0,1766 # 6960 <malloc+0x9ae>
    2282:	00004097          	auipc	ra,0x4
    2286:	c78080e7          	jalr	-904(ra) # 5efa <printf>
      exit(1);
    228a:	4505                	li	a0,1
    228c:	00004097          	auipc	ra,0x4
    2290:	906080e7          	jalr	-1786(ra) # 5b92 <exit>
      *(char*)a = 99;
    2294:	fd843783          	ld	a5,-40(s0)
    2298:	06300713          	li	a4,99
    229c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a0:	fd843603          	ld	a2,-40(s0)
    22a4:	85ca                	mv	a1,s2
    22a6:	00005517          	auipc	a0,0x5
    22aa:	9aa50513          	addi	a0,a0,-1622 # 6c50 <malloc+0xc9e>
    22ae:	00004097          	auipc	ra,0x4
    22b2:	c4c080e7          	jalr	-948(ra) # 5efa <printf>
      exit(1);
    22b6:	4505                	li	a0,1
    22b8:	00004097          	auipc	ra,0x4
    22bc:	8da080e7          	jalr	-1830(ra) # 5b92 <exit>
      exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00004097          	auipc	ra,0x4
    22c6:	8d0080e7          	jalr	-1840(ra) # 5b92 <exit>

00000000000022ca <bigargtest>:
{
    22ca:	7179                	addi	sp,sp,-48
    22cc:	f406                	sd	ra,40(sp)
    22ce:	f022                	sd	s0,32(sp)
    22d0:	ec26                	sd	s1,24(sp)
    22d2:	1800                	addi	s0,sp,48
    22d4:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d6:	00005517          	auipc	a0,0x5
    22da:	99250513          	addi	a0,a0,-1646 # 6c68 <malloc+0xcb6>
    22de:	00004097          	auipc	ra,0x4
    22e2:	904080e7          	jalr	-1788(ra) # 5be2 <unlink>
  pid = fork();
    22e6:	00004097          	auipc	ra,0x4
    22ea:	8a4080e7          	jalr	-1884(ra) # 5b8a <fork>
  if(pid == 0){
    22ee:	c121                	beqz	a0,232e <bigargtest+0x64>
  } else if(pid < 0){
    22f0:	0a054063          	bltz	a0,2390 <bigargtest+0xc6>
  wait(&xstatus);
    22f4:	fdc40513          	addi	a0,s0,-36
    22f8:	00004097          	auipc	ra,0x4
    22fc:	8a2080e7          	jalr	-1886(ra) # 5b9a <wait>
  if(xstatus != 0)
    2300:	fdc42503          	lw	a0,-36(s0)
    2304:	e545                	bnez	a0,23ac <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2306:	4581                	li	a1,0
    2308:	00005517          	auipc	a0,0x5
    230c:	96050513          	addi	a0,a0,-1696 # 6c68 <malloc+0xcb6>
    2310:	00004097          	auipc	ra,0x4
    2314:	8c2080e7          	jalr	-1854(ra) # 5bd2 <open>
  if(fd < 0){
    2318:	08054e63          	bltz	a0,23b4 <bigargtest+0xea>
  close(fd);
    231c:	00004097          	auipc	ra,0x4
    2320:	89e080e7          	jalr	-1890(ra) # 5bba <close>
}
    2324:	70a2                	ld	ra,40(sp)
    2326:	7402                	ld	s0,32(sp)
    2328:	64e2                	ld	s1,24(sp)
    232a:	6145                	addi	sp,sp,48
    232c:	8082                	ret
    232e:	00007797          	auipc	a5,0x7
    2332:	13278793          	addi	a5,a5,306 # 9460 <args.1>
    2336:	00007697          	auipc	a3,0x7
    233a:	22268693          	addi	a3,a3,546 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    233e:	00005717          	auipc	a4,0x5
    2342:	93a70713          	addi	a4,a4,-1734 # 6c78 <malloc+0xcc6>
    2346:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2348:	07a1                	addi	a5,a5,8
    234a:	fed79ee3          	bne	a5,a3,2346 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    234e:	00007597          	auipc	a1,0x7
    2352:	11258593          	addi	a1,a1,274 # 9460 <args.1>
    2356:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    235a:	00004517          	auipc	a0,0x4
    235e:	d7e50513          	addi	a0,a0,-642 # 60d8 <malloc+0x126>
    2362:	00004097          	auipc	ra,0x4
    2366:	868080e7          	jalr	-1944(ra) # 5bca <exec>
    fd = open("bigarg-ok", O_CREATE);
    236a:	20000593          	li	a1,512
    236e:	00005517          	auipc	a0,0x5
    2372:	8fa50513          	addi	a0,a0,-1798 # 6c68 <malloc+0xcb6>
    2376:	00004097          	auipc	ra,0x4
    237a:	85c080e7          	jalr	-1956(ra) # 5bd2 <open>
    close(fd);
    237e:	00004097          	auipc	ra,0x4
    2382:	83c080e7          	jalr	-1988(ra) # 5bba <close>
    exit(0);
    2386:	4501                	li	a0,0
    2388:	00004097          	auipc	ra,0x4
    238c:	80a080e7          	jalr	-2038(ra) # 5b92 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2390:	85a6                	mv	a1,s1
    2392:	00005517          	auipc	a0,0x5
    2396:	9c650513          	addi	a0,a0,-1594 # 6d58 <malloc+0xda6>
    239a:	00004097          	auipc	ra,0x4
    239e:	b60080e7          	jalr	-1184(ra) # 5efa <printf>
    exit(1);
    23a2:	4505                	li	a0,1
    23a4:	00003097          	auipc	ra,0x3
    23a8:	7ee080e7          	jalr	2030(ra) # 5b92 <exit>
    exit(xstatus);
    23ac:	00003097          	auipc	ra,0x3
    23b0:	7e6080e7          	jalr	2022(ra) # 5b92 <exit>
    printf("%s: bigarg test failed!\n", s);
    23b4:	85a6                	mv	a1,s1
    23b6:	00005517          	auipc	a0,0x5
    23ba:	9c250513          	addi	a0,a0,-1598 # 6d78 <malloc+0xdc6>
    23be:	00004097          	auipc	ra,0x4
    23c2:	b3c080e7          	jalr	-1220(ra) # 5efa <printf>
    exit(1);
    23c6:	4505                	li	a0,1
    23c8:	00003097          	auipc	ra,0x3
    23cc:	7ca080e7          	jalr	1994(ra) # 5b92 <exit>

00000000000023d0 <stacktest>:
{
    23d0:	7179                	addi	sp,sp,-48
    23d2:	f406                	sd	ra,40(sp)
    23d4:	f022                	sd	s0,32(sp)
    23d6:	ec26                	sd	s1,24(sp)
    23d8:	1800                	addi	s0,sp,48
    23da:	84aa                	mv	s1,a0
  pid = fork();
    23dc:	00003097          	auipc	ra,0x3
    23e0:	7ae080e7          	jalr	1966(ra) # 5b8a <fork>
  if(pid == 0) {
    23e4:	c115                	beqz	a0,2408 <stacktest+0x38>
  } else if(pid < 0){
    23e6:	04054463          	bltz	a0,242e <stacktest+0x5e>
  wait(&xstatus);
    23ea:	fdc40513          	addi	a0,s0,-36
    23ee:	00003097          	auipc	ra,0x3
    23f2:	7ac080e7          	jalr	1964(ra) # 5b9a <wait>
  if(xstatus == -1)  // kernel killed child?
    23f6:	fdc42503          	lw	a0,-36(s0)
    23fa:	57fd                	li	a5,-1
    23fc:	04f50763          	beq	a0,a5,244a <stacktest+0x7a>
    exit(xstatus);
    2400:	00003097          	auipc	ra,0x3
    2404:	792080e7          	jalr	1938(ra) # 5b92 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2408:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    240a:	77fd                	lui	a5,0xfffff
    240c:	97ba                	add	a5,a5,a4
    240e:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2412:	85a6                	mv	a1,s1
    2414:	00005517          	auipc	a0,0x5
    2418:	98450513          	addi	a0,a0,-1660 # 6d98 <malloc+0xde6>
    241c:	00004097          	auipc	ra,0x4
    2420:	ade080e7          	jalr	-1314(ra) # 5efa <printf>
    exit(1);
    2424:	4505                	li	a0,1
    2426:	00003097          	auipc	ra,0x3
    242a:	76c080e7          	jalr	1900(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    242e:	85a6                	mv	a1,s1
    2430:	00004517          	auipc	a0,0x4
    2434:	53050513          	addi	a0,a0,1328 # 6960 <malloc+0x9ae>
    2438:	00004097          	auipc	ra,0x4
    243c:	ac2080e7          	jalr	-1342(ra) # 5efa <printf>
    exit(1);
    2440:	4505                	li	a0,1
    2442:	00003097          	auipc	ra,0x3
    2446:	750080e7          	jalr	1872(ra) # 5b92 <exit>
    exit(0);
    244a:	4501                	li	a0,0
    244c:	00003097          	auipc	ra,0x3
    2450:	746080e7          	jalr	1862(ra) # 5b92 <exit>

0000000000002454 <textwrite>:
{
    2454:	7179                	addi	sp,sp,-48
    2456:	f406                	sd	ra,40(sp)
    2458:	f022                	sd	s0,32(sp)
    245a:	ec26                	sd	s1,24(sp)
    245c:	1800                	addi	s0,sp,48
    245e:	84aa                	mv	s1,a0
  pid = fork();
    2460:	00003097          	auipc	ra,0x3
    2464:	72a080e7          	jalr	1834(ra) # 5b8a <fork>
  if(pid == 0) {
    2468:	c115                	beqz	a0,248c <textwrite+0x38>
  } else if(pid < 0){
    246a:	02054963          	bltz	a0,249c <textwrite+0x48>
  wait(&xstatus);
    246e:	fdc40513          	addi	a0,s0,-36
    2472:	00003097          	auipc	ra,0x3
    2476:	728080e7          	jalr	1832(ra) # 5b9a <wait>
  if(xstatus == -1)  // kernel killed child?
    247a:	fdc42503          	lw	a0,-36(s0)
    247e:	57fd                	li	a5,-1
    2480:	02f50c63          	beq	a0,a5,24b8 <textwrite+0x64>
    exit(xstatus);
    2484:	00003097          	auipc	ra,0x3
    2488:	70e080e7          	jalr	1806(ra) # 5b92 <exit>
    *addr = 10;
    248c:	47a9                	li	a5,10
    248e:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	00003097          	auipc	ra,0x3
    2498:	6fe080e7          	jalr	1790(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    249c:	85a6                	mv	a1,s1
    249e:	00004517          	auipc	a0,0x4
    24a2:	4c250513          	addi	a0,a0,1218 # 6960 <malloc+0x9ae>
    24a6:	00004097          	auipc	ra,0x4
    24aa:	a54080e7          	jalr	-1452(ra) # 5efa <printf>
    exit(1);
    24ae:	4505                	li	a0,1
    24b0:	00003097          	auipc	ra,0x3
    24b4:	6e2080e7          	jalr	1762(ra) # 5b92 <exit>
    exit(0);
    24b8:	4501                	li	a0,0
    24ba:	00003097          	auipc	ra,0x3
    24be:	6d8080e7          	jalr	1752(ra) # 5b92 <exit>

00000000000024c2 <manywrites>:
{
    24c2:	711d                	addi	sp,sp,-96
    24c4:	ec86                	sd	ra,88(sp)
    24c6:	e8a2                	sd	s0,80(sp)
    24c8:	e4a6                	sd	s1,72(sp)
    24ca:	e0ca                	sd	s2,64(sp)
    24cc:	fc4e                	sd	s3,56(sp)
    24ce:	f852                	sd	s4,48(sp)
    24d0:	f456                	sd	s5,40(sp)
    24d2:	f05a                	sd	s6,32(sp)
    24d4:	ec5e                	sd	s7,24(sp)
    24d6:	1080                	addi	s0,sp,96
    24d8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24da:	4981                	li	s3,0
    24dc:	4911                	li	s2,4
    int pid = fork();
    24de:	00003097          	auipc	ra,0x3
    24e2:	6ac080e7          	jalr	1708(ra) # 5b8a <fork>
    24e6:	84aa                	mv	s1,a0
    if(pid < 0){
    24e8:	02054963          	bltz	a0,251a <manywrites+0x58>
    if(pid == 0){
    24ec:	c521                	beqz	a0,2534 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24ee:	2985                	addiw	s3,s3,1
    24f0:	ff2997e3          	bne	s3,s2,24de <manywrites+0x1c>
    24f4:	4491                	li	s1,4
    int st = 0;
    24f6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24fa:	fa840513          	addi	a0,s0,-88
    24fe:	00003097          	auipc	ra,0x3
    2502:	69c080e7          	jalr	1692(ra) # 5b9a <wait>
    if(st != 0)
    2506:	fa842503          	lw	a0,-88(s0)
    250a:	ed6d                	bnez	a0,2604 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    250c:	34fd                	addiw	s1,s1,-1
    250e:	f4e5                	bnez	s1,24f6 <manywrites+0x34>
  exit(0);
    2510:	4501                	li	a0,0
    2512:	00003097          	auipc	ra,0x3
    2516:	680080e7          	jalr	1664(ra) # 5b92 <exit>
      printf("fork failed\n");
    251a:	00005517          	auipc	a0,0x5
    251e:	84e50513          	addi	a0,a0,-1970 # 6d68 <malloc+0xdb6>
    2522:	00004097          	auipc	ra,0x4
    2526:	9d8080e7          	jalr	-1576(ra) # 5efa <printf>
      exit(1);
    252a:	4505                	li	a0,1
    252c:	00003097          	auipc	ra,0x3
    2530:	666080e7          	jalr	1638(ra) # 5b92 <exit>
      name[0] = 'b';
    2534:	06200793          	li	a5,98
    2538:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    253c:	0619879b          	addiw	a5,s3,97
    2540:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2544:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2548:	fa840513          	addi	a0,s0,-88
    254c:	00003097          	auipc	ra,0x3
    2550:	696080e7          	jalr	1686(ra) # 5be2 <unlink>
    2554:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2556:	0000ab17          	auipc	s6,0xa
    255a:	722b0b13          	addi	s6,s6,1826 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    255e:	8a26                	mv	s4,s1
    2560:	0209ce63          	bltz	s3,259c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2564:	20200593          	li	a1,514
    2568:	fa840513          	addi	a0,s0,-88
    256c:	00003097          	auipc	ra,0x3
    2570:	666080e7          	jalr	1638(ra) # 5bd2 <open>
    2574:	892a                	mv	s2,a0
          if(fd < 0){
    2576:	04054763          	bltz	a0,25c4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    257a:	660d                	lui	a2,0x3
    257c:	85da                	mv	a1,s6
    257e:	00003097          	auipc	ra,0x3
    2582:	634080e7          	jalr	1588(ra) # 5bb2 <write>
          if(cc != sz){
    2586:	678d                	lui	a5,0x3
    2588:	04f51e63          	bne	a0,a5,25e4 <manywrites+0x122>
          close(fd);
    258c:	854a                	mv	a0,s2
    258e:	00003097          	auipc	ra,0x3
    2592:	62c080e7          	jalr	1580(ra) # 5bba <close>
        for(int i = 0; i < ci+1; i++){
    2596:	2a05                	addiw	s4,s4,1
    2598:	fd49d6e3          	bge	s3,s4,2564 <manywrites+0xa2>
        unlink(name);
    259c:	fa840513          	addi	a0,s0,-88
    25a0:	00003097          	auipc	ra,0x3
    25a4:	642080e7          	jalr	1602(ra) # 5be2 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25a8:	3bfd                	addiw	s7,s7,-1
    25aa:	fa0b9ae3          	bnez	s7,255e <manywrites+0x9c>
      unlink(name);
    25ae:	fa840513          	addi	a0,s0,-88
    25b2:	00003097          	auipc	ra,0x3
    25b6:	630080e7          	jalr	1584(ra) # 5be2 <unlink>
      exit(0);
    25ba:	4501                	li	a0,0
    25bc:	00003097          	auipc	ra,0x3
    25c0:	5d6080e7          	jalr	1494(ra) # 5b92 <exit>
            printf("%s: cannot create %s\n", s, name);
    25c4:	fa840613          	addi	a2,s0,-88
    25c8:	85d6                	mv	a1,s5
    25ca:	00004517          	auipc	a0,0x4
    25ce:	7f650513          	addi	a0,a0,2038 # 6dc0 <malloc+0xe0e>
    25d2:	00004097          	auipc	ra,0x4
    25d6:	928080e7          	jalr	-1752(ra) # 5efa <printf>
            exit(1);
    25da:	4505                	li	a0,1
    25dc:	00003097          	auipc	ra,0x3
    25e0:	5b6080e7          	jalr	1462(ra) # 5b92 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e4:	86aa                	mv	a3,a0
    25e6:	660d                	lui	a2,0x3
    25e8:	85d6                	mv	a1,s5
    25ea:	00004517          	auipc	a0,0x4
    25ee:	bbe50513          	addi	a0,a0,-1090 # 61a8 <malloc+0x1f6>
    25f2:	00004097          	auipc	ra,0x4
    25f6:	908080e7          	jalr	-1784(ra) # 5efa <printf>
            exit(1);
    25fa:	4505                	li	a0,1
    25fc:	00003097          	auipc	ra,0x3
    2600:	596080e7          	jalr	1430(ra) # 5b92 <exit>
      exit(st);
    2604:	00003097          	auipc	ra,0x3
    2608:	58e080e7          	jalr	1422(ra) # 5b92 <exit>

000000000000260c <copyinstr3>:
{
    260c:	7179                	addi	sp,sp,-48
    260e:	f406                	sd	ra,40(sp)
    2610:	f022                	sd	s0,32(sp)
    2612:	ec26                	sd	s1,24(sp)
    2614:	1800                	addi	s0,sp,48
  sbrk(8192);
    2616:	6509                	lui	a0,0x2
    2618:	00003097          	auipc	ra,0x3
    261c:	602080e7          	jalr	1538(ra) # 5c1a <sbrk>
  uint64 top = (uint64) sbrk(0);
    2620:	4501                	li	a0,0
    2622:	00003097          	auipc	ra,0x3
    2626:	5f8080e7          	jalr	1528(ra) # 5c1a <sbrk>
  if((top % PGSIZE) != 0){
    262a:	03451793          	slli	a5,a0,0x34
    262e:	e3c9                	bnez	a5,26b0 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2630:	4501                	li	a0,0
    2632:	00003097          	auipc	ra,0x3
    2636:	5e8080e7          	jalr	1512(ra) # 5c1a <sbrk>
  if(top % PGSIZE){
    263a:	03451793          	slli	a5,a0,0x34
    263e:	e3d9                	bnez	a5,26c4 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2640:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x71>
  *b = 'x';
    2644:	07800793          	li	a5,120
    2648:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    264c:	8526                	mv	a0,s1
    264e:	00003097          	auipc	ra,0x3
    2652:	594080e7          	jalr	1428(ra) # 5be2 <unlink>
  if(ret != -1){
    2656:	57fd                	li	a5,-1
    2658:	08f51363          	bne	a0,a5,26de <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    265c:	20100593          	li	a1,513
    2660:	8526                	mv	a0,s1
    2662:	00003097          	auipc	ra,0x3
    2666:	570080e7          	jalr	1392(ra) # 5bd2 <open>
  if(fd != -1){
    266a:	57fd                	li	a5,-1
    266c:	08f51863          	bne	a0,a5,26fc <copyinstr3+0xf0>
  ret = link(b, b);
    2670:	85a6                	mv	a1,s1
    2672:	8526                	mv	a0,s1
    2674:	00003097          	auipc	ra,0x3
    2678:	57e080e7          	jalr	1406(ra) # 5bf2 <link>
  if(ret != -1){
    267c:	57fd                	li	a5,-1
    267e:	08f51e63          	bne	a0,a5,271a <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2682:	00005797          	auipc	a5,0x5
    2686:	43678793          	addi	a5,a5,1078 # 7ab8 <malloc+0x1b06>
    268a:	fcf43823          	sd	a5,-48(s0)
    268e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2692:	fd040593          	addi	a1,s0,-48
    2696:	8526                	mv	a0,s1
    2698:	00003097          	auipc	ra,0x3
    269c:	532080e7          	jalr	1330(ra) # 5bca <exec>
  if(ret != -1){
    26a0:	57fd                	li	a5,-1
    26a2:	08f51c63          	bne	a0,a5,273a <copyinstr3+0x12e>
}
    26a6:	70a2                	ld	ra,40(sp)
    26a8:	7402                	ld	s0,32(sp)
    26aa:	64e2                	ld	s1,24(sp)
    26ac:	6145                	addi	sp,sp,48
    26ae:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b0:	0347d513          	srli	a0,a5,0x34
    26b4:	6785                	lui	a5,0x1
    26b6:	40a7853b          	subw	a0,a5,a0
    26ba:	00003097          	auipc	ra,0x3
    26be:	560080e7          	jalr	1376(ra) # 5c1a <sbrk>
    26c2:	b7bd                	j	2630 <copyinstr3+0x24>
    printf("oops\n");
    26c4:	00004517          	auipc	a0,0x4
    26c8:	71450513          	addi	a0,a0,1812 # 6dd8 <malloc+0xe26>
    26cc:	00004097          	auipc	ra,0x4
    26d0:	82e080e7          	jalr	-2002(ra) # 5efa <printf>
    exit(1);
    26d4:	4505                	li	a0,1
    26d6:	00003097          	auipc	ra,0x3
    26da:	4bc080e7          	jalr	1212(ra) # 5b92 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26de:	862a                	mv	a2,a0
    26e0:	85a6                	mv	a1,s1
    26e2:	00004517          	auipc	a0,0x4
    26e6:	19e50513          	addi	a0,a0,414 # 6880 <malloc+0x8ce>
    26ea:	00004097          	auipc	ra,0x4
    26ee:	810080e7          	jalr	-2032(ra) # 5efa <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	00003097          	auipc	ra,0x3
    26f8:	49e080e7          	jalr	1182(ra) # 5b92 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26fc:	862a                	mv	a2,a0
    26fe:	85a6                	mv	a1,s1
    2700:	00004517          	auipc	a0,0x4
    2704:	1a050513          	addi	a0,a0,416 # 68a0 <malloc+0x8ee>
    2708:	00003097          	auipc	ra,0x3
    270c:	7f2080e7          	jalr	2034(ra) # 5efa <printf>
    exit(1);
    2710:	4505                	li	a0,1
    2712:	00003097          	auipc	ra,0x3
    2716:	480080e7          	jalr	1152(ra) # 5b92 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    271a:	86aa                	mv	a3,a0
    271c:	8626                	mv	a2,s1
    271e:	85a6                	mv	a1,s1
    2720:	00004517          	auipc	a0,0x4
    2724:	1a050513          	addi	a0,a0,416 # 68c0 <malloc+0x90e>
    2728:	00003097          	auipc	ra,0x3
    272c:	7d2080e7          	jalr	2002(ra) # 5efa <printf>
    exit(1);
    2730:	4505                	li	a0,1
    2732:	00003097          	auipc	ra,0x3
    2736:	460080e7          	jalr	1120(ra) # 5b92 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    273a:	567d                	li	a2,-1
    273c:	85a6                	mv	a1,s1
    273e:	00004517          	auipc	a0,0x4
    2742:	1aa50513          	addi	a0,a0,426 # 68e8 <malloc+0x936>
    2746:	00003097          	auipc	ra,0x3
    274a:	7b4080e7          	jalr	1972(ra) # 5efa <printf>
    exit(1);
    274e:	4505                	li	a0,1
    2750:	00003097          	auipc	ra,0x3
    2754:	442080e7          	jalr	1090(ra) # 5b92 <exit>

0000000000002758 <rwsbrk>:
{
    2758:	1101                	addi	sp,sp,-32
    275a:	ec06                	sd	ra,24(sp)
    275c:	e822                	sd	s0,16(sp)
    275e:	e426                	sd	s1,8(sp)
    2760:	e04a                	sd	s2,0(sp)
    2762:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2764:	6509                	lui	a0,0x2
    2766:	00003097          	auipc	ra,0x3
    276a:	4b4080e7          	jalr	1204(ra) # 5c1a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    276e:	57fd                	li	a5,-1
    2770:	06f50263          	beq	a0,a5,27d4 <rwsbrk+0x7c>
    2774:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2776:	7579                	lui	a0,0xffffe
    2778:	00003097          	auipc	ra,0x3
    277c:	4a2080e7          	jalr	1186(ra) # 5c1a <sbrk>
    2780:	57fd                	li	a5,-1
    2782:	06f50663          	beq	a0,a5,27ee <rwsbrk+0x96>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2786:	20100593          	li	a1,513
    278a:	00004517          	auipc	a0,0x4
    278e:	68e50513          	addi	a0,a0,1678 # 6e18 <malloc+0xe66>
    2792:	00003097          	auipc	ra,0x3
    2796:	440080e7          	jalr	1088(ra) # 5bd2 <open>
    279a:	892a                	mv	s2,a0
  if(fd < 0){
    279c:	06054663          	bltz	a0,2808 <rwsbrk+0xb0>
  n = write(fd, (void*)(a+4096), 1024);
    27a0:	6785                	lui	a5,0x1
    27a2:	94be                	add	s1,s1,a5
    27a4:	40000613          	li	a2,1024
    27a8:	85a6                	mv	a1,s1
    27aa:	00003097          	auipc	ra,0x3
    27ae:	408080e7          	jalr	1032(ra) # 5bb2 <write>
    27b2:	862a                	mv	a2,a0
  if(n >= 0){
    27b4:	06054763          	bltz	a0,2822 <rwsbrk+0xca>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27b8:	85a6                	mv	a1,s1
    27ba:	00004517          	auipc	a0,0x4
    27be:	67e50513          	addi	a0,a0,1662 # 6e38 <malloc+0xe86>
    27c2:	00003097          	auipc	ra,0x3
    27c6:	738080e7          	jalr	1848(ra) # 5efa <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00003097          	auipc	ra,0x3
    27d0:	3c6080e7          	jalr	966(ra) # 5b92 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27d4:	00004517          	auipc	a0,0x4
    27d8:	60c50513          	addi	a0,a0,1548 # 6de0 <malloc+0xe2e>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	71e080e7          	jalr	1822(ra) # 5efa <printf>
    exit(1);
    27e4:	4505                	li	a0,1
    27e6:	00003097          	auipc	ra,0x3
    27ea:	3ac080e7          	jalr	940(ra) # 5b92 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27ee:	00004517          	auipc	a0,0x4
    27f2:	60a50513          	addi	a0,a0,1546 # 6df8 <malloc+0xe46>
    27f6:	00003097          	auipc	ra,0x3
    27fa:	704080e7          	jalr	1796(ra) # 5efa <printf>
    exit(1);
    27fe:	4505                	li	a0,1
    2800:	00003097          	auipc	ra,0x3
    2804:	392080e7          	jalr	914(ra) # 5b92 <exit>
    printf("open(rwsbrk) failed\n");
    2808:	00004517          	auipc	a0,0x4
    280c:	61850513          	addi	a0,a0,1560 # 6e20 <malloc+0xe6e>
    2810:	00003097          	auipc	ra,0x3
    2814:	6ea080e7          	jalr	1770(ra) # 5efa <printf>
    exit(1);
    2818:	4505                	li	a0,1
    281a:	00003097          	auipc	ra,0x3
    281e:	378080e7          	jalr	888(ra) # 5b92 <exit>
  close(fd);
    2822:	854a                	mv	a0,s2
    2824:	00003097          	auipc	ra,0x3
    2828:	396080e7          	jalr	918(ra) # 5bba <close>
  unlink("rwsbrk");
    282c:	00004517          	auipc	a0,0x4
    2830:	5ec50513          	addi	a0,a0,1516 # 6e18 <malloc+0xe66>
    2834:	00003097          	auipc	ra,0x3
    2838:	3ae080e7          	jalr	942(ra) # 5be2 <unlink>
  fd = open("README", O_RDONLY);
    283c:	4581                	li	a1,0
    283e:	00004517          	auipc	a0,0x4
    2842:	a7250513          	addi	a0,a0,-1422 # 62b0 <malloc+0x2fe>
    2846:	00003097          	auipc	ra,0x3
    284a:	38c080e7          	jalr	908(ra) # 5bd2 <open>
    284e:	892a                	mv	s2,a0
  if(fd < 0){
    2850:	02054963          	bltz	a0,2882 <rwsbrk+0x12a>
  n = read(fd, (void*)(a+4096), 10);
    2854:	4629                	li	a2,10
    2856:	85a6                	mv	a1,s1
    2858:	00003097          	auipc	ra,0x3
    285c:	352080e7          	jalr	850(ra) # 5baa <read>
    2860:	862a                	mv	a2,a0
  if(n >= 0){
    2862:	02054d63          	bltz	a0,289c <rwsbrk+0x144>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2866:	85a6                	mv	a1,s1
    2868:	00004517          	auipc	a0,0x4
    286c:	60050513          	addi	a0,a0,1536 # 6e68 <malloc+0xeb6>
    2870:	00003097          	auipc	ra,0x3
    2874:	68a080e7          	jalr	1674(ra) # 5efa <printf>
    exit(1);
    2878:	4505                	li	a0,1
    287a:	00003097          	auipc	ra,0x3
    287e:	318080e7          	jalr	792(ra) # 5b92 <exit>
    printf("open(rwsbrk) failed\n");
    2882:	00004517          	auipc	a0,0x4
    2886:	59e50513          	addi	a0,a0,1438 # 6e20 <malloc+0xe6e>
    288a:	00003097          	auipc	ra,0x3
    288e:	670080e7          	jalr	1648(ra) # 5efa <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	2fe080e7          	jalr	766(ra) # 5b92 <exit>
  close(fd);
    289c:	854a                	mv	a0,s2
    289e:	00003097          	auipc	ra,0x3
    28a2:	31c080e7          	jalr	796(ra) # 5bba <close>
  exit(0);
    28a6:	4501                	li	a0,0
    28a8:	00003097          	auipc	ra,0x3
    28ac:	2ea080e7          	jalr	746(ra) # 5b92 <exit>

00000000000028b0 <sbrkbasic>:
{
    28b0:	7139                	addi	sp,sp,-64
    28b2:	fc06                	sd	ra,56(sp)
    28b4:	f822                	sd	s0,48(sp)
    28b6:	f426                	sd	s1,40(sp)
    28b8:	f04a                	sd	s2,32(sp)
    28ba:	ec4e                	sd	s3,24(sp)
    28bc:	e852                	sd	s4,16(sp)
    28be:	0080                	addi	s0,sp,64
    28c0:	8a2a                	mv	s4,a0
  pid = fork();
    28c2:	00003097          	auipc	ra,0x3
    28c6:	2c8080e7          	jalr	712(ra) # 5b8a <fork>
  if(pid < 0){
    28ca:	02054c63          	bltz	a0,2902 <sbrkbasic+0x52>
  if(pid == 0){
    28ce:	ed21                	bnez	a0,2926 <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    28d0:	40000537          	lui	a0,0x40000
    28d4:	00003097          	auipc	ra,0x3
    28d8:	346080e7          	jalr	838(ra) # 5c1a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28dc:	57fd                	li	a5,-1
    28de:	02f50f63          	beq	a0,a5,291c <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28e2:	400007b7          	lui	a5,0x40000
    28e6:	97aa                	add	a5,a5,a0
      *b = 99;
    28e8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ec:	6705                	lui	a4,0x1
      *b = 99;
    28ee:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f2:	953a                	add	a0,a0,a4
    28f4:	fef51de3          	bne	a0,a5,28ee <sbrkbasic+0x3e>
    exit(1);
    28f8:	4505                	li	a0,1
    28fa:	00003097          	auipc	ra,0x3
    28fe:	298080e7          	jalr	664(ra) # 5b92 <exit>
    printf("fork failed in sbrkbasic\n");
    2902:	00004517          	auipc	a0,0x4
    2906:	58e50513          	addi	a0,a0,1422 # 6e90 <malloc+0xede>
    290a:	00003097          	auipc	ra,0x3
    290e:	5f0080e7          	jalr	1520(ra) # 5efa <printf>
    exit(1);
    2912:	4505                	li	a0,1
    2914:	00003097          	auipc	ra,0x3
    2918:	27e080e7          	jalr	638(ra) # 5b92 <exit>
      exit(0);
    291c:	4501                	li	a0,0
    291e:	00003097          	auipc	ra,0x3
    2922:	274080e7          	jalr	628(ra) # 5b92 <exit>
  wait(&xstatus);
    2926:	fcc40513          	addi	a0,s0,-52
    292a:	00003097          	auipc	ra,0x3
    292e:	270080e7          	jalr	624(ra) # 5b9a <wait>
  if(xstatus == 1){
    2932:	fcc42703          	lw	a4,-52(s0)
    2936:	4785                	li	a5,1
    2938:	00f70d63          	beq	a4,a5,2952 <sbrkbasic+0xa2>
  a = sbrk(0);
    293c:	4501                	li	a0,0
    293e:	00003097          	auipc	ra,0x3
    2942:	2dc080e7          	jalr	732(ra) # 5c1a <sbrk>
    2946:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2948:	4901                	li	s2,0
    294a:	6985                	lui	s3,0x1
    294c:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    2950:	a005                	j	2970 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    2952:	85d2                	mv	a1,s4
    2954:	00004517          	auipc	a0,0x4
    2958:	55c50513          	addi	a0,a0,1372 # 6eb0 <malloc+0xefe>
    295c:	00003097          	auipc	ra,0x3
    2960:	59e080e7          	jalr	1438(ra) # 5efa <printf>
    exit(1);
    2964:	4505                	li	a0,1
    2966:	00003097          	auipc	ra,0x3
    296a:	22c080e7          	jalr	556(ra) # 5b92 <exit>
    a = b + 1;
    296e:	84be                	mv	s1,a5
    b = sbrk(1);
    2970:	4505                	li	a0,1
    2972:	00003097          	auipc	ra,0x3
    2976:	2a8080e7          	jalr	680(ra) # 5c1a <sbrk>
    if(b != a){
    297a:	04951c63          	bne	a0,s1,29d2 <sbrkbasic+0x122>
    *b = 1;
    297e:	4785                	li	a5,1
    2980:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2984:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2988:	2905                	addiw	s2,s2,1
    298a:	ff3912e3          	bne	s2,s3,296e <sbrkbasic+0xbe>
  pid = fork();
    298e:	00003097          	auipc	ra,0x3
    2992:	1fc080e7          	jalr	508(ra) # 5b8a <fork>
    2996:	892a                	mv	s2,a0
  if(pid < 0){
    2998:	04054e63          	bltz	a0,29f4 <sbrkbasic+0x144>
  c = sbrk(1);
    299c:	4505                	li	a0,1
    299e:	00003097          	auipc	ra,0x3
    29a2:	27c080e7          	jalr	636(ra) # 5c1a <sbrk>
  c = sbrk(1);
    29a6:	4505                	li	a0,1
    29a8:	00003097          	auipc	ra,0x3
    29ac:	272080e7          	jalr	626(ra) # 5c1a <sbrk>
  if(c != a + 1){
    29b0:	0489                	addi	s1,s1,2
    29b2:	04a48f63          	beq	s1,a0,2a10 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    29b6:	85d2                	mv	a1,s4
    29b8:	00004517          	auipc	a0,0x4
    29bc:	55850513          	addi	a0,a0,1368 # 6f10 <malloc+0xf5e>
    29c0:	00003097          	auipc	ra,0x3
    29c4:	53a080e7          	jalr	1338(ra) # 5efa <printf>
    exit(1);
    29c8:	4505                	li	a0,1
    29ca:	00003097          	auipc	ra,0x3
    29ce:	1c8080e7          	jalr	456(ra) # 5b92 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d2:	872a                	mv	a4,a0
    29d4:	86a6                	mv	a3,s1
    29d6:	864a                	mv	a2,s2
    29d8:	85d2                	mv	a1,s4
    29da:	00004517          	auipc	a0,0x4
    29de:	4f650513          	addi	a0,a0,1270 # 6ed0 <malloc+0xf1e>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	518080e7          	jalr	1304(ra) # 5efa <printf>
      exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	1a6080e7          	jalr	422(ra) # 5b92 <exit>
    printf("%s: sbrk test fork failed\n", s);
    29f4:	85d2                	mv	a1,s4
    29f6:	00004517          	auipc	a0,0x4
    29fa:	4fa50513          	addi	a0,a0,1274 # 6ef0 <malloc+0xf3e>
    29fe:	00003097          	auipc	ra,0x3
    2a02:	4fc080e7          	jalr	1276(ra) # 5efa <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	18a080e7          	jalr	394(ra) # 5b92 <exit>
  if(pid == 0)
    2a10:	00091763          	bnez	s2,2a1e <sbrkbasic+0x16e>
    exit(0);
    2a14:	4501                	li	a0,0
    2a16:	00003097          	auipc	ra,0x3
    2a1a:	17c080e7          	jalr	380(ra) # 5b92 <exit>
  wait(&xstatus);
    2a1e:	fcc40513          	addi	a0,s0,-52
    2a22:	00003097          	auipc	ra,0x3
    2a26:	178080e7          	jalr	376(ra) # 5b9a <wait>
  exit(xstatus);
    2a2a:	fcc42503          	lw	a0,-52(s0)
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	164080e7          	jalr	356(ra) # 5b92 <exit>

0000000000002a36 <sbrkmuch>:
{
    2a36:	7179                	addi	sp,sp,-48
    2a38:	f406                	sd	ra,40(sp)
    2a3a:	f022                	sd	s0,32(sp)
    2a3c:	ec26                	sd	s1,24(sp)
    2a3e:	e84a                	sd	s2,16(sp)
    2a40:	e44e                	sd	s3,8(sp)
    2a42:	e052                	sd	s4,0(sp)
    2a44:	1800                	addi	s0,sp,48
    2a46:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a48:	4501                	li	a0,0
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	1d0080e7          	jalr	464(ra) # 5c1a <sbrk>
    2a52:	892a                	mv	s2,a0
  a = sbrk(0);
    2a54:	4501                	li	a0,0
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	1c4080e7          	jalr	452(ra) # 5c1a <sbrk>
    2a5e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a60:	06400537          	lui	a0,0x6400
    2a64:	9d05                	subw	a0,a0,s1
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	1b4080e7          	jalr	436(ra) # 5c1a <sbrk>
  if (p != a) {
    2a6e:	0ca49863          	bne	s1,a0,2b3e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a72:	4501                	li	a0,0
    2a74:	00003097          	auipc	ra,0x3
    2a78:	1a6080e7          	jalr	422(ra) # 5c1a <sbrk>
    2a7c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a7e:	00a4f963          	bgeu	s1,a0,2a90 <sbrkmuch+0x5a>
    *pp = 1;
    2a82:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a84:	6705                	lui	a4,0x1
    *pp = 1;
    2a86:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a8a:	94ba                	add	s1,s1,a4
    2a8c:	fef4ede3          	bltu	s1,a5,2a86 <sbrkmuch+0x50>
  *lastaddr = 99;
    2a90:	064007b7          	lui	a5,0x6400
    2a94:	06300713          	li	a4,99
    2a98:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	17c080e7          	jalr	380(ra) # 5c1a <sbrk>
    2aa6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aa8:	757d                	lui	a0,0xfffff
    2aaa:	00003097          	auipc	ra,0x3
    2aae:	170080e7          	jalr	368(ra) # 5c1a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ab2:	57fd                	li	a5,-1
    2ab4:	0af50363          	beq	a0,a5,2b5a <sbrkmuch+0x124>
  c = sbrk(0);
    2ab8:	4501                	li	a0,0
    2aba:	00003097          	auipc	ra,0x3
    2abe:	160080e7          	jalr	352(ra) # 5c1a <sbrk>
  if(c != a - PGSIZE){
    2ac2:	77fd                	lui	a5,0xfffff
    2ac4:	97a6                	add	a5,a5,s1
    2ac6:	0af51863          	bne	a0,a5,2b76 <sbrkmuch+0x140>
  a = sbrk(0);
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	14e080e7          	jalr	334(ra) # 5c1a <sbrk>
    2ad4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2ad6:	6505                	lui	a0,0x1
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	142080e7          	jalr	322(ra) # 5c1a <sbrk>
    2ae0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ae2:	0aa49a63          	bne	s1,a0,2b96 <sbrkmuch+0x160>
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	132080e7          	jalr	306(ra) # 5c1a <sbrk>
    2af0:	6785                	lui	a5,0x1
    2af2:	97a6                	add	a5,a5,s1
    2af4:	0af51163          	bne	a0,a5,2b96 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2af8:	064007b7          	lui	a5,0x6400
    2afc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b00:	06300793          	li	a5,99
    2b04:	0af70963          	beq	a4,a5,2bb6 <sbrkmuch+0x180>
  a = sbrk(0);
    2b08:	4501                	li	a0,0
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	110080e7          	jalr	272(ra) # 5c1a <sbrk>
    2b12:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b14:	4501                	li	a0,0
    2b16:	00003097          	auipc	ra,0x3
    2b1a:	104080e7          	jalr	260(ra) # 5c1a <sbrk>
    2b1e:	40a9053b          	subw	a0,s2,a0
    2b22:	00003097          	auipc	ra,0x3
    2b26:	0f8080e7          	jalr	248(ra) # 5c1a <sbrk>
  if(c != a){
    2b2a:	0aa49463          	bne	s1,a0,2bd2 <sbrkmuch+0x19c>
}
    2b2e:	70a2                	ld	ra,40(sp)
    2b30:	7402                	ld	s0,32(sp)
    2b32:	64e2                	ld	s1,24(sp)
    2b34:	6942                	ld	s2,16(sp)
    2b36:	69a2                	ld	s3,8(sp)
    2b38:	6a02                	ld	s4,0(sp)
    2b3a:	6145                	addi	sp,sp,48
    2b3c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b3e:	85ce                	mv	a1,s3
    2b40:	00004517          	auipc	a0,0x4
    2b44:	3f050513          	addi	a0,a0,1008 # 6f30 <malloc+0xf7e>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	3b2080e7          	jalr	946(ra) # 5efa <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	040080e7          	jalr	64(ra) # 5b92 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b5a:	85ce                	mv	a1,s3
    2b5c:	00004517          	auipc	a0,0x4
    2b60:	41c50513          	addi	a0,a0,1052 # 6f78 <malloc+0xfc6>
    2b64:	00003097          	auipc	ra,0x3
    2b68:	396080e7          	jalr	918(ra) # 5efa <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	024080e7          	jalr	36(ra) # 5b92 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b76:	86aa                	mv	a3,a0
    2b78:	8626                	mv	a2,s1
    2b7a:	85ce                	mv	a1,s3
    2b7c:	00004517          	auipc	a0,0x4
    2b80:	41c50513          	addi	a0,a0,1052 # 6f98 <malloc+0xfe6>
    2b84:	00003097          	auipc	ra,0x3
    2b88:	376080e7          	jalr	886(ra) # 5efa <printf>
    exit(1);
    2b8c:	4505                	li	a0,1
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	004080e7          	jalr	4(ra) # 5b92 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b96:	86d2                	mv	a3,s4
    2b98:	8626                	mv	a2,s1
    2b9a:	85ce                	mv	a1,s3
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	43c50513          	addi	a0,a0,1084 # 6fd8 <malloc+0x1026>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	356080e7          	jalr	854(ra) # 5efa <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	fe4080e7          	jalr	-28(ra) # 5b92 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bb6:	85ce                	mv	a1,s3
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	45050513          	addi	a0,a0,1104 # 7008 <malloc+0x1056>
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	33a080e7          	jalr	826(ra) # 5efa <printf>
    exit(1);
    2bc8:	4505                	li	a0,1
    2bca:	00003097          	auipc	ra,0x3
    2bce:	fc8080e7          	jalr	-56(ra) # 5b92 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd2:	86aa                	mv	a3,a0
    2bd4:	8626                	mv	a2,s1
    2bd6:	85ce                	mv	a1,s3
    2bd8:	00004517          	auipc	a0,0x4
    2bdc:	46850513          	addi	a0,a0,1128 # 7040 <malloc+0x108e>
    2be0:	00003097          	auipc	ra,0x3
    2be4:	31a080e7          	jalr	794(ra) # 5efa <printf>
    exit(1);
    2be8:	4505                	li	a0,1
    2bea:	00003097          	auipc	ra,0x3
    2bee:	fa8080e7          	jalr	-88(ra) # 5b92 <exit>

0000000000002bf2 <sbrkarg>:
{
    2bf2:	7179                	addi	sp,sp,-48
    2bf4:	f406                	sd	ra,40(sp)
    2bf6:	f022                	sd	s0,32(sp)
    2bf8:	ec26                	sd	s1,24(sp)
    2bfa:	e84a                	sd	s2,16(sp)
    2bfc:	e44e                	sd	s3,8(sp)
    2bfe:	1800                	addi	s0,sp,48
    2c00:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c02:	6505                	lui	a0,0x1
    2c04:	00003097          	auipc	ra,0x3
    2c08:	016080e7          	jalr	22(ra) # 5c1a <sbrk>
    2c0c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c0e:	20100593          	li	a1,513
    2c12:	00004517          	auipc	a0,0x4
    2c16:	45650513          	addi	a0,a0,1110 # 7068 <malloc+0x10b6>
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	fb8080e7          	jalr	-72(ra) # 5bd2 <open>
    2c22:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c24:	00004517          	auipc	a0,0x4
    2c28:	44450513          	addi	a0,a0,1092 # 7068 <malloc+0x10b6>
    2c2c:	00003097          	auipc	ra,0x3
    2c30:	fb6080e7          	jalr	-74(ra) # 5be2 <unlink>
  if(fd < 0)  {
    2c34:	0404c163          	bltz	s1,2c76 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c38:	6605                	lui	a2,0x1
    2c3a:	85ca                	mv	a1,s2
    2c3c:	8526                	mv	a0,s1
    2c3e:	00003097          	auipc	ra,0x3
    2c42:	f74080e7          	jalr	-140(ra) # 5bb2 <write>
    2c46:	04054663          	bltz	a0,2c92 <sbrkarg+0xa0>
  close(fd);
    2c4a:	8526                	mv	a0,s1
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	f6e080e7          	jalr	-146(ra) # 5bba <close>
  a = sbrk(PGSIZE);
    2c54:	6505                	lui	a0,0x1
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	fc4080e7          	jalr	-60(ra) # 5c1a <sbrk>
  if(pipe((int *) a) != 0){
    2c5e:	00003097          	auipc	ra,0x3
    2c62:	f44080e7          	jalr	-188(ra) # 5ba2 <pipe>
    2c66:	e521                	bnez	a0,2cae <sbrkarg+0xbc>
}
    2c68:	70a2                	ld	ra,40(sp)
    2c6a:	7402                	ld	s0,32(sp)
    2c6c:	64e2                	ld	s1,24(sp)
    2c6e:	6942                	ld	s2,16(sp)
    2c70:	69a2                	ld	s3,8(sp)
    2c72:	6145                	addi	sp,sp,48
    2c74:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c76:	85ce                	mv	a1,s3
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	3f850513          	addi	a0,a0,1016 # 7070 <malloc+0x10be>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	27a080e7          	jalr	634(ra) # 5efa <printf>
    exit(1);
    2c88:	4505                	li	a0,1
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f08080e7          	jalr	-248(ra) # 5b92 <exit>
    printf("%s: write sbrk failed\n", s);
    2c92:	85ce                	mv	a1,s3
    2c94:	00004517          	auipc	a0,0x4
    2c98:	3f450513          	addi	a0,a0,1012 # 7088 <malloc+0x10d6>
    2c9c:	00003097          	auipc	ra,0x3
    2ca0:	25e080e7          	jalr	606(ra) # 5efa <printf>
    exit(1);
    2ca4:	4505                	li	a0,1
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	eec080e7          	jalr	-276(ra) # 5b92 <exit>
    printf("%s: pipe() failed\n", s);
    2cae:	85ce                	mv	a1,s3
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	db850513          	addi	a0,a0,-584 # 6a68 <malloc+0xab6>
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	242080e7          	jalr	578(ra) # 5efa <printf>
    exit(1);
    2cc0:	4505                	li	a0,1
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	ed0080e7          	jalr	-304(ra) # 5b92 <exit>

0000000000002cca <argptest>:
{
    2cca:	1101                	addi	sp,sp,-32
    2ccc:	ec06                	sd	ra,24(sp)
    2cce:	e822                	sd	s0,16(sp)
    2cd0:	e426                	sd	s1,8(sp)
    2cd2:	e04a                	sd	s2,0(sp)
    2cd4:	1000                	addi	s0,sp,32
    2cd6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cd8:	4581                	li	a1,0
    2cda:	00004517          	auipc	a0,0x4
    2cde:	3c650513          	addi	a0,a0,966 # 70a0 <malloc+0x10ee>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	ef0080e7          	jalr	-272(ra) # 5bd2 <open>
  if (fd < 0) {
    2cea:	02054b63          	bltz	a0,2d20 <argptest+0x56>
    2cee:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf0:	4501                	li	a0,0
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	f28080e7          	jalr	-216(ra) # 5c1a <sbrk>
    2cfa:	567d                	li	a2,-1
    2cfc:	fff50593          	addi	a1,a0,-1
    2d00:	8526                	mv	a0,s1
    2d02:	00003097          	auipc	ra,0x3
    2d06:	ea8080e7          	jalr	-344(ra) # 5baa <read>
  close(fd);
    2d0a:	8526                	mv	a0,s1
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	eae080e7          	jalr	-338(ra) # 5bba <close>
}
    2d14:	60e2                	ld	ra,24(sp)
    2d16:	6442                	ld	s0,16(sp)
    2d18:	64a2                	ld	s1,8(sp)
    2d1a:	6902                	ld	s2,0(sp)
    2d1c:	6105                	addi	sp,sp,32
    2d1e:	8082                	ret
    printf("%s: open failed\n", s);
    2d20:	85ca                	mv	a1,s2
    2d22:	00004517          	auipc	a0,0x4
    2d26:	c5650513          	addi	a0,a0,-938 # 6978 <malloc+0x9c6>
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	1d0080e7          	jalr	464(ra) # 5efa <printf>
    exit(1);
    2d32:	4505                	li	a0,1
    2d34:	00003097          	auipc	ra,0x3
    2d38:	e5e080e7          	jalr	-418(ra) # 5b92 <exit>

0000000000002d3c <sbrkbugs>:
{
    2d3c:	1141                	addi	sp,sp,-16
    2d3e:	e406                	sd	ra,8(sp)
    2d40:	e022                	sd	s0,0(sp)
    2d42:	0800                	addi	s0,sp,16
  int pid = fork();
    2d44:	00003097          	auipc	ra,0x3
    2d48:	e46080e7          	jalr	-442(ra) # 5b8a <fork>
  if(pid < 0){
    2d4c:	02054263          	bltz	a0,2d70 <sbrkbugs+0x34>
  if(pid == 0){
    2d50:	ed0d                	bnez	a0,2d8a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d52:	00003097          	auipc	ra,0x3
    2d56:	ec8080e7          	jalr	-312(ra) # 5c1a <sbrk>
    sbrk(-sz);
    2d5a:	40a0053b          	negw	a0,a0
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	ebc080e7          	jalr	-324(ra) # 5c1a <sbrk>
    exit(0);
    2d66:	4501                	li	a0,0
    2d68:	00003097          	auipc	ra,0x3
    2d6c:	e2a080e7          	jalr	-470(ra) # 5b92 <exit>
    printf("fork failed\n");
    2d70:	00004517          	auipc	a0,0x4
    2d74:	ff850513          	addi	a0,a0,-8 # 6d68 <malloc+0xdb6>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	182080e7          	jalr	386(ra) # 5efa <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	e10080e7          	jalr	-496(ra) # 5b92 <exit>
  wait(0);
    2d8a:	4501                	li	a0,0
    2d8c:	00003097          	auipc	ra,0x3
    2d90:	e0e080e7          	jalr	-498(ra) # 5b9a <wait>
  pid = fork();
    2d94:	00003097          	auipc	ra,0x3
    2d98:	df6080e7          	jalr	-522(ra) # 5b8a <fork>
  if(pid < 0){
    2d9c:	02054563          	bltz	a0,2dc6 <sbrkbugs+0x8a>
  if(pid == 0){
    2da0:	e121                	bnez	a0,2de0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2da2:	00003097          	auipc	ra,0x3
    2da6:	e78080e7          	jalr	-392(ra) # 5c1a <sbrk>
    sbrk(-(sz - 3500));
    2daa:	6785                	lui	a5,0x1
    2dac:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6c>
    2db0:	40a7853b          	subw	a0,a5,a0
    2db4:	00003097          	auipc	ra,0x3
    2db8:	e66080e7          	jalr	-410(ra) # 5c1a <sbrk>
    exit(0);
    2dbc:	4501                	li	a0,0
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	dd4080e7          	jalr	-556(ra) # 5b92 <exit>
    printf("fork failed\n");
    2dc6:	00004517          	auipc	a0,0x4
    2dca:	fa250513          	addi	a0,a0,-94 # 6d68 <malloc+0xdb6>
    2dce:	00003097          	auipc	ra,0x3
    2dd2:	12c080e7          	jalr	300(ra) # 5efa <printf>
    exit(1);
    2dd6:	4505                	li	a0,1
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	dba080e7          	jalr	-582(ra) # 5b92 <exit>
  wait(0);
    2de0:	4501                	li	a0,0
    2de2:	00003097          	auipc	ra,0x3
    2de6:	db8080e7          	jalr	-584(ra) # 5b9a <wait>
  pid = fork();
    2dea:	00003097          	auipc	ra,0x3
    2dee:	da0080e7          	jalr	-608(ra) # 5b8a <fork>
  if(pid < 0){
    2df2:	02054a63          	bltz	a0,2e26 <sbrkbugs+0xea>
  if(pid == 0){
    2df6:	e529                	bnez	a0,2e40 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	e22080e7          	jalr	-478(ra) # 5c1a <sbrk>
    2e00:	67ad                	lui	a5,0xb
    2e02:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2e06:	40a7853b          	subw	a0,a5,a0
    2e0a:	00003097          	auipc	ra,0x3
    2e0e:	e10080e7          	jalr	-496(ra) # 5c1a <sbrk>
    sbrk(-10);
    2e12:	5559                	li	a0,-10
    2e14:	00003097          	auipc	ra,0x3
    2e18:	e06080e7          	jalr	-506(ra) # 5c1a <sbrk>
    exit(0);
    2e1c:	4501                	li	a0,0
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	d74080e7          	jalr	-652(ra) # 5b92 <exit>
    printf("fork failed\n");
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	f4250513          	addi	a0,a0,-190 # 6d68 <malloc+0xdb6>
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	0cc080e7          	jalr	204(ra) # 5efa <printf>
    exit(1);
    2e36:	4505                	li	a0,1
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	d5a080e7          	jalr	-678(ra) # 5b92 <exit>
  wait(0);
    2e40:	4501                	li	a0,0
    2e42:	00003097          	auipc	ra,0x3
    2e46:	d58080e7          	jalr	-680(ra) # 5b9a <wait>
  exit(0);
    2e4a:	4501                	li	a0,0
    2e4c:	00003097          	auipc	ra,0x3
    2e50:	d46080e7          	jalr	-698(ra) # 5b92 <exit>

0000000000002e54 <sbrklast>:
{
    2e54:	7179                	addi	sp,sp,-48
    2e56:	f406                	sd	ra,40(sp)
    2e58:	f022                	sd	s0,32(sp)
    2e5a:	ec26                	sd	s1,24(sp)
    2e5c:	e84a                	sd	s2,16(sp)
    2e5e:	e44e                	sd	s3,8(sp)
    2e60:	e052                	sd	s4,0(sp)
    2e62:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e64:	4501                	li	a0,0
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	db4080e7          	jalr	-588(ra) # 5c1a <sbrk>
  if((top % 4096) != 0)
    2e6e:	03451793          	slli	a5,a0,0x34
    2e72:	ebd9                	bnez	a5,2f08 <sbrklast+0xb4>
  sbrk(4096);
    2e74:	6505                	lui	a0,0x1
    2e76:	00003097          	auipc	ra,0x3
    2e7a:	da4080e7          	jalr	-604(ra) # 5c1a <sbrk>
  sbrk(10);
    2e7e:	4529                	li	a0,10
    2e80:	00003097          	auipc	ra,0x3
    2e84:	d9a080e7          	jalr	-614(ra) # 5c1a <sbrk>
  sbrk(-20);
    2e88:	5531                	li	a0,-20
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	d90080e7          	jalr	-624(ra) # 5c1a <sbrk>
  top = (uint64) sbrk(0);
    2e92:	4501                	li	a0,0
    2e94:	00003097          	auipc	ra,0x3
    2e98:	d86080e7          	jalr	-634(ra) # 5c1a <sbrk>
    2e9c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2e9e:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ea2:	07800a13          	li	s4,120
    2ea6:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2eaa:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eae:	20200593          	li	a1,514
    2eb2:	854a                	mv	a0,s2
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	d1e080e7          	jalr	-738(ra) # 5bd2 <open>
    2ebc:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ebe:	4605                	li	a2,1
    2ec0:	85ca                	mv	a1,s2
    2ec2:	00003097          	auipc	ra,0x3
    2ec6:	cf0080e7          	jalr	-784(ra) # 5bb2 <write>
  close(fd);
    2eca:	854e                	mv	a0,s3
    2ecc:	00003097          	auipc	ra,0x3
    2ed0:	cee080e7          	jalr	-786(ra) # 5bba <close>
  fd = open(p, O_RDWR);
    2ed4:	4589                	li	a1,2
    2ed6:	854a                	mv	a0,s2
    2ed8:	00003097          	auipc	ra,0x3
    2edc:	cfa080e7          	jalr	-774(ra) # 5bd2 <open>
  p[0] = '\0';
    2ee0:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ee4:	4605                	li	a2,1
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003097          	auipc	ra,0x3
    2eec:	cc2080e7          	jalr	-830(ra) # 5baa <read>
  if(p[0] != 'x')
    2ef0:	fc04c783          	lbu	a5,-64(s1)
    2ef4:	03479463          	bne	a5,s4,2f1c <sbrklast+0xc8>
}
    2ef8:	70a2                	ld	ra,40(sp)
    2efa:	7402                	ld	s0,32(sp)
    2efc:	64e2                	ld	s1,24(sp)
    2efe:	6942                	ld	s2,16(sp)
    2f00:	69a2                	ld	s3,8(sp)
    2f02:	6a02                	ld	s4,0(sp)
    2f04:	6145                	addi	sp,sp,48
    2f06:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f08:	0347d513          	srli	a0,a5,0x34
    2f0c:	6785                	lui	a5,0x1
    2f0e:	40a7853b          	subw	a0,a5,a0
    2f12:	00003097          	auipc	ra,0x3
    2f16:	d08080e7          	jalr	-760(ra) # 5c1a <sbrk>
    2f1a:	bfa9                	j	2e74 <sbrklast+0x20>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	c74080e7          	jalr	-908(ra) # 5b92 <exit>

0000000000002f26 <sbrk8000>:
{
    2f26:	1141                	addi	sp,sp,-16
    2f28:	e406                	sd	ra,8(sp)
    2f2a:	e022                	sd	s0,0(sp)
    2f2c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f2e:	80000537          	lui	a0,0x80000
    2f32:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	ce6080e7          	jalr	-794(ra) # 5c1a <sbrk>
  volatile char *top = sbrk(0);
    2f3c:	4501                	li	a0,0
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	cdc080e7          	jalr	-804(ra) # 5c1a <sbrk>
  *(top-1) = *(top-1) + 1;
    2f46:	fff54783          	lbu	a5,-1(a0)
    2f4a:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10b>
    2f4c:	0ff7f793          	zext.b	a5,a5
    2f50:	fef50fa3          	sb	a5,-1(a0)
}
    2f54:	60a2                	ld	ra,8(sp)
    2f56:	6402                	ld	s0,0(sp)
    2f58:	0141                	addi	sp,sp,16
    2f5a:	8082                	ret

0000000000002f5c <execout>:
{
    2f5c:	715d                	addi	sp,sp,-80
    2f5e:	e486                	sd	ra,72(sp)
    2f60:	e0a2                	sd	s0,64(sp)
    2f62:	fc26                	sd	s1,56(sp)
    2f64:	f84a                	sd	s2,48(sp)
    2f66:	f44e                	sd	s3,40(sp)
    2f68:	f052                	sd	s4,32(sp)
    2f6a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f6c:	4901                	li	s2,0
    2f6e:	49bd                	li	s3,15
    int pid = fork();
    2f70:	00003097          	auipc	ra,0x3
    2f74:	c1a080e7          	jalr	-998(ra) # 5b8a <fork>
    2f78:	84aa                	mv	s1,a0
    if(pid < 0){
    2f7a:	02054063          	bltz	a0,2f9a <execout+0x3e>
    } else if(pid == 0){
    2f7e:	c91d                	beqz	a0,2fb4 <execout+0x58>
      wait((int*)0);
    2f80:	4501                	li	a0,0
    2f82:	00003097          	auipc	ra,0x3
    2f86:	c18080e7          	jalr	-1000(ra) # 5b9a <wait>
  for(int avail = 0; avail < 15; avail++){
    2f8a:	2905                	addiw	s2,s2,1
    2f8c:	ff3912e3          	bne	s2,s3,2f70 <execout+0x14>
  exit(0);
    2f90:	4501                	li	a0,0
    2f92:	00003097          	auipc	ra,0x3
    2f96:	c00080e7          	jalr	-1024(ra) # 5b92 <exit>
      printf("fork failed\n");
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	dce50513          	addi	a0,a0,-562 # 6d68 <malloc+0xdb6>
    2fa2:	00003097          	auipc	ra,0x3
    2fa6:	f58080e7          	jalr	-168(ra) # 5efa <printf>
      exit(1);
    2faa:	4505                	li	a0,1
    2fac:	00003097          	auipc	ra,0x3
    2fb0:	be6080e7          	jalr	-1050(ra) # 5b92 <exit>
        if(a == 0xffffffffffffffffLL)
    2fb4:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fb6:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fb8:	6505                	lui	a0,0x1
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	c60080e7          	jalr	-928(ra) # 5c1a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fc2:	01350763          	beq	a0,s3,2fd0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fc6:	6785                	lui	a5,0x1
    2fc8:	97aa                	add	a5,a5,a0
    2fca:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x109>
      while(1){
    2fce:	b7ed                	j	2fb8 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fd0:	01205a63          	blez	s2,2fe4 <execout+0x88>
        sbrk(-4096);
    2fd4:	757d                	lui	a0,0xfffff
    2fd6:	00003097          	auipc	ra,0x3
    2fda:	c44080e7          	jalr	-956(ra) # 5c1a <sbrk>
      for(int i = 0; i < avail; i++)
    2fde:	2485                	addiw	s1,s1,1
    2fe0:	ff249ae3          	bne	s1,s2,2fd4 <execout+0x78>
      close(1);
    2fe4:	4505                	li	a0,1
    2fe6:	00003097          	auipc	ra,0x3
    2fea:	bd4080e7          	jalr	-1068(ra) # 5bba <close>
      char *args[] = { "echo", "x", 0 };
    2fee:	00003517          	auipc	a0,0x3
    2ff2:	0ea50513          	addi	a0,a0,234 # 60d8 <malloc+0x126>
    2ff6:	faa43c23          	sd	a0,-72(s0)
    2ffa:	00003797          	auipc	a5,0x3
    2ffe:	14e78793          	addi	a5,a5,334 # 6148 <malloc+0x196>
    3002:	fcf43023          	sd	a5,-64(s0)
    3006:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    300a:	fb840593          	addi	a1,s0,-72
    300e:	00003097          	auipc	ra,0x3
    3012:	bbc080e7          	jalr	-1092(ra) # 5bca <exec>
      exit(0);
    3016:	4501                	li	a0,0
    3018:	00003097          	auipc	ra,0x3
    301c:	b7a080e7          	jalr	-1158(ra) # 5b92 <exit>

0000000000003020 <fourteen>:
{
    3020:	1101                	addi	sp,sp,-32
    3022:	ec06                	sd	ra,24(sp)
    3024:	e822                	sd	s0,16(sp)
    3026:	e426                	sd	s1,8(sp)
    3028:	1000                	addi	s0,sp,32
    302a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    302c:	00004517          	auipc	a0,0x4
    3030:	24c50513          	addi	a0,a0,588 # 7278 <malloc+0x12c6>
    3034:	00003097          	auipc	ra,0x3
    3038:	bc6080e7          	jalr	-1082(ra) # 5bfa <mkdir>
    303c:	e165                	bnez	a0,311c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    303e:	00004517          	auipc	a0,0x4
    3042:	09250513          	addi	a0,a0,146 # 70d0 <malloc+0x111e>
    3046:	00003097          	auipc	ra,0x3
    304a:	bb4080e7          	jalr	-1100(ra) # 5bfa <mkdir>
    304e:	e56d                	bnez	a0,3138 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3050:	20000593          	li	a1,512
    3054:	00004517          	auipc	a0,0x4
    3058:	0d450513          	addi	a0,a0,212 # 7128 <malloc+0x1176>
    305c:	00003097          	auipc	ra,0x3
    3060:	b76080e7          	jalr	-1162(ra) # 5bd2 <open>
  if(fd < 0){
    3064:	0e054863          	bltz	a0,3154 <fourteen+0x134>
  close(fd);
    3068:	00003097          	auipc	ra,0x3
    306c:	b52080e7          	jalr	-1198(ra) # 5bba <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3070:	4581                	li	a1,0
    3072:	00004517          	auipc	a0,0x4
    3076:	12e50513          	addi	a0,a0,302 # 71a0 <malloc+0x11ee>
    307a:	00003097          	auipc	ra,0x3
    307e:	b58080e7          	jalr	-1192(ra) # 5bd2 <open>
  if(fd < 0){
    3082:	0e054763          	bltz	a0,3170 <fourteen+0x150>
  close(fd);
    3086:	00003097          	auipc	ra,0x3
    308a:	b34080e7          	jalr	-1228(ra) # 5bba <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    308e:	00004517          	auipc	a0,0x4
    3092:	18250513          	addi	a0,a0,386 # 7210 <malloc+0x125e>
    3096:	00003097          	auipc	ra,0x3
    309a:	b64080e7          	jalr	-1180(ra) # 5bfa <mkdir>
    309e:	c57d                	beqz	a0,318c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a0:	00004517          	auipc	a0,0x4
    30a4:	1c850513          	addi	a0,a0,456 # 7268 <malloc+0x12b6>
    30a8:	00003097          	auipc	ra,0x3
    30ac:	b52080e7          	jalr	-1198(ra) # 5bfa <mkdir>
    30b0:	cd65                	beqz	a0,31a8 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b2:	00004517          	auipc	a0,0x4
    30b6:	1b650513          	addi	a0,a0,438 # 7268 <malloc+0x12b6>
    30ba:	00003097          	auipc	ra,0x3
    30be:	b28080e7          	jalr	-1240(ra) # 5be2 <unlink>
  unlink("12345678901234/12345678901234");
    30c2:	00004517          	auipc	a0,0x4
    30c6:	14e50513          	addi	a0,a0,334 # 7210 <malloc+0x125e>
    30ca:	00003097          	auipc	ra,0x3
    30ce:	b18080e7          	jalr	-1256(ra) # 5be2 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d2:	00004517          	auipc	a0,0x4
    30d6:	0ce50513          	addi	a0,a0,206 # 71a0 <malloc+0x11ee>
    30da:	00003097          	auipc	ra,0x3
    30de:	b08080e7          	jalr	-1272(ra) # 5be2 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e2:	00004517          	auipc	a0,0x4
    30e6:	04650513          	addi	a0,a0,70 # 7128 <malloc+0x1176>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	af8080e7          	jalr	-1288(ra) # 5be2 <unlink>
  unlink("12345678901234/123456789012345");
    30f2:	00004517          	auipc	a0,0x4
    30f6:	fde50513          	addi	a0,a0,-34 # 70d0 <malloc+0x111e>
    30fa:	00003097          	auipc	ra,0x3
    30fe:	ae8080e7          	jalr	-1304(ra) # 5be2 <unlink>
  unlink("12345678901234");
    3102:	00004517          	auipc	a0,0x4
    3106:	17650513          	addi	a0,a0,374 # 7278 <malloc+0x12c6>
    310a:	00003097          	auipc	ra,0x3
    310e:	ad8080e7          	jalr	-1320(ra) # 5be2 <unlink>
}
    3112:	60e2                	ld	ra,24(sp)
    3114:	6442                	ld	s0,16(sp)
    3116:	64a2                	ld	s1,8(sp)
    3118:	6105                	addi	sp,sp,32
    311a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    311c:	85a6                	mv	a1,s1
    311e:	00004517          	auipc	a0,0x4
    3122:	f8a50513          	addi	a0,a0,-118 # 70a8 <malloc+0x10f6>
    3126:	00003097          	auipc	ra,0x3
    312a:	dd4080e7          	jalr	-556(ra) # 5efa <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00003097          	auipc	ra,0x3
    3134:	a62080e7          	jalr	-1438(ra) # 5b92 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3138:	85a6                	mv	a1,s1
    313a:	00004517          	auipc	a0,0x4
    313e:	fb650513          	addi	a0,a0,-74 # 70f0 <malloc+0x113e>
    3142:	00003097          	auipc	ra,0x3
    3146:	db8080e7          	jalr	-584(ra) # 5efa <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00003097          	auipc	ra,0x3
    3150:	a46080e7          	jalr	-1466(ra) # 5b92 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3154:	85a6                	mv	a1,s1
    3156:	00004517          	auipc	a0,0x4
    315a:	00250513          	addi	a0,a0,2 # 7158 <malloc+0x11a6>
    315e:	00003097          	auipc	ra,0x3
    3162:	d9c080e7          	jalr	-612(ra) # 5efa <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00003097          	auipc	ra,0x3
    316c:	a2a080e7          	jalr	-1494(ra) # 5b92 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	05e50513          	addi	a0,a0,94 # 71d0 <malloc+0x121e>
    317a:	00003097          	auipc	ra,0x3
    317e:	d80080e7          	jalr	-640(ra) # 5efa <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	a0e080e7          	jalr	-1522(ra) # 5b92 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	0a250513          	addi	a0,a0,162 # 7230 <malloc+0x127e>
    3196:	00003097          	auipc	ra,0x3
    319a:	d64080e7          	jalr	-668(ra) # 5efa <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	9f2080e7          	jalr	-1550(ra) # 5b92 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31a8:	85a6                	mv	a1,s1
    31aa:	00004517          	auipc	a0,0x4
    31ae:	0de50513          	addi	a0,a0,222 # 7288 <malloc+0x12d6>
    31b2:	00003097          	auipc	ra,0x3
    31b6:	d48080e7          	jalr	-696(ra) # 5efa <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	00003097          	auipc	ra,0x3
    31c0:	9d6080e7          	jalr	-1578(ra) # 5b92 <exit>

00000000000031c4 <diskfull>:
{
    31c4:	b9010113          	addi	sp,sp,-1136
    31c8:	46113423          	sd	ra,1128(sp)
    31cc:	46813023          	sd	s0,1120(sp)
    31d0:	44913c23          	sd	s1,1112(sp)
    31d4:	45213823          	sd	s2,1104(sp)
    31d8:	45313423          	sd	s3,1096(sp)
    31dc:	45413023          	sd	s4,1088(sp)
    31e0:	43513c23          	sd	s5,1080(sp)
    31e4:	43613823          	sd	s6,1072(sp)
    31e8:	43713423          	sd	s7,1064(sp)
    31ec:	43813023          	sd	s8,1056(sp)
    31f0:	47010413          	addi	s0,sp,1136
    31f4:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31f6:	00004517          	auipc	a0,0x4
    31fa:	0ca50513          	addi	a0,a0,202 # 72c0 <malloc+0x130e>
    31fe:	00003097          	auipc	ra,0x3
    3202:	9e4080e7          	jalr	-1564(ra) # 5be2 <unlink>
  for(fi = 0; done == 0; fi++){
    3206:	4a01                	li	s4,0
    name[0] = 'b';
    3208:	06200b93          	li	s7,98
    name[1] = 'i';
    320c:	06900b13          	li	s6,105
    name[2] = 'g';
    3210:	06700a93          	li	s5,103
    3214:	69c1                	lui	s3,0x10
    3216:	10b98993          	addi	s3,s3,267 # 1010b <base+0x493>
    321a:	aabd                	j	3398 <diskfull+0x1d4>
      printf("%s: could not create file %s\n", s, name);
    321c:	b9040613          	addi	a2,s0,-1136
    3220:	85e2                	mv	a1,s8
    3222:	00004517          	auipc	a0,0x4
    3226:	0ae50513          	addi	a0,a0,174 # 72d0 <malloc+0x131e>
    322a:	00003097          	auipc	ra,0x3
    322e:	cd0080e7          	jalr	-816(ra) # 5efa <printf>
      break;
    3232:	a821                	j	324a <diskfull+0x86>
        close(fd);
    3234:	854a                	mv	a0,s2
    3236:	00003097          	auipc	ra,0x3
    323a:	984080e7          	jalr	-1660(ra) # 5bba <close>
    close(fd);
    323e:	854a                	mv	a0,s2
    3240:	00003097          	auipc	ra,0x3
    3244:	97a080e7          	jalr	-1670(ra) # 5bba <close>
  for(fi = 0; done == 0; fi++){
    3248:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    324a:	4481                	li	s1,0
    name[0] = 'z';
    324c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3250:	08000993          	li	s3,128
    name[0] = 'z';
    3254:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3258:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    325c:	41f4d71b          	sraiw	a4,s1,0x1f
    3260:	01b7571b          	srliw	a4,a4,0x1b
    3264:	009707bb          	addw	a5,a4,s1
    3268:	4057d69b          	sraiw	a3,a5,0x5
    326c:	0306869b          	addiw	a3,a3,48
    3270:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3274:	8bfd                	andi	a5,a5,31
    3276:	9f99                	subw	a5,a5,a4
    3278:	0307879b          	addiw	a5,a5,48
    327c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3280:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3284:	bb040513          	addi	a0,s0,-1104
    3288:	00003097          	auipc	ra,0x3
    328c:	95a080e7          	jalr	-1702(ra) # 5be2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3290:	60200593          	li	a1,1538
    3294:	bb040513          	addi	a0,s0,-1104
    3298:	00003097          	auipc	ra,0x3
    329c:	93a080e7          	jalr	-1734(ra) # 5bd2 <open>
    if(fd < 0)
    32a0:	00054963          	bltz	a0,32b2 <diskfull+0xee>
    close(fd);
    32a4:	00003097          	auipc	ra,0x3
    32a8:	916080e7          	jalr	-1770(ra) # 5bba <close>
  for(int i = 0; i < nzz; i++){
    32ac:	2485                	addiw	s1,s1,1
    32ae:	fb3493e3          	bne	s1,s3,3254 <diskfull+0x90>
  if(mkdir("diskfulldir") == 0)
    32b2:	00004517          	auipc	a0,0x4
    32b6:	00e50513          	addi	a0,a0,14 # 72c0 <malloc+0x130e>
    32ba:	00003097          	auipc	ra,0x3
    32be:	940080e7          	jalr	-1728(ra) # 5bfa <mkdir>
    32c2:	12050963          	beqz	a0,33f4 <diskfull+0x230>
  unlink("diskfulldir");
    32c6:	00004517          	auipc	a0,0x4
    32ca:	ffa50513          	addi	a0,a0,-6 # 72c0 <malloc+0x130e>
    32ce:	00003097          	auipc	ra,0x3
    32d2:	914080e7          	jalr	-1772(ra) # 5be2 <unlink>
  for(int i = 0; i < nzz; i++){
    32d6:	4481                	li	s1,0
    name[0] = 'z';
    32d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32dc:	08000993          	li	s3,128
    name[0] = 'z';
    32e0:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32e4:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32e8:	41f4d71b          	sraiw	a4,s1,0x1f
    32ec:	01b7571b          	srliw	a4,a4,0x1b
    32f0:	009707bb          	addw	a5,a4,s1
    32f4:	4057d69b          	sraiw	a3,a5,0x5
    32f8:	0306869b          	addiw	a3,a3,48
    32fc:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3300:	8bfd                	andi	a5,a5,31
    3302:	9f99                	subw	a5,a5,a4
    3304:	0307879b          	addiw	a5,a5,48
    3308:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    330c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3310:	bb040513          	addi	a0,s0,-1104
    3314:	00003097          	auipc	ra,0x3
    3318:	8ce080e7          	jalr	-1842(ra) # 5be2 <unlink>
  for(int i = 0; i < nzz; i++){
    331c:	2485                	addiw	s1,s1,1
    331e:	fd3491e3          	bne	s1,s3,32e0 <diskfull+0x11c>
  for(int i = 0; i < fi; i++){
    3322:	03405e63          	blez	s4,335e <diskfull+0x19a>
    3326:	4481                	li	s1,0
    name[0] = 'b';
    3328:	06200a93          	li	s5,98
    name[1] = 'i';
    332c:	06900993          	li	s3,105
    name[2] = 'g';
    3330:	06700913          	li	s2,103
    name[0] = 'b';
    3334:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3338:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    333c:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3340:	0304879b          	addiw	a5,s1,48
    3344:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3348:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    334c:	bb040513          	addi	a0,s0,-1104
    3350:	00003097          	auipc	ra,0x3
    3354:	892080e7          	jalr	-1902(ra) # 5be2 <unlink>
  for(int i = 0; i < fi; i++){
    3358:	2485                	addiw	s1,s1,1
    335a:	fd449de3          	bne	s1,s4,3334 <diskfull+0x170>
}
    335e:	46813083          	ld	ra,1128(sp)
    3362:	46013403          	ld	s0,1120(sp)
    3366:	45813483          	ld	s1,1112(sp)
    336a:	45013903          	ld	s2,1104(sp)
    336e:	44813983          	ld	s3,1096(sp)
    3372:	44013a03          	ld	s4,1088(sp)
    3376:	43813a83          	ld	s5,1080(sp)
    337a:	43013b03          	ld	s6,1072(sp)
    337e:	42813b83          	ld	s7,1064(sp)
    3382:	42013c03          	ld	s8,1056(sp)
    3386:	47010113          	addi	sp,sp,1136
    338a:	8082                	ret
    close(fd);
    338c:	854a                	mv	a0,s2
    338e:	00003097          	auipc	ra,0x3
    3392:	82c080e7          	jalr	-2004(ra) # 5bba <close>
  for(fi = 0; done == 0; fi++){
    3396:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    3398:	b9740823          	sb	s7,-1136(s0)
    name[1] = 'i';
    339c:	b96408a3          	sb	s6,-1135(s0)
    name[2] = 'g';
    33a0:	b9540923          	sb	s5,-1134(s0)
    name[3] = '0' + fi;
    33a4:	030a079b          	addiw	a5,s4,48
    33a8:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33ac:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b0:	b9040513          	addi	a0,s0,-1136
    33b4:	00003097          	auipc	ra,0x3
    33b8:	82e080e7          	jalr	-2002(ra) # 5be2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33bc:	60200593          	li	a1,1538
    33c0:	b9040513          	addi	a0,s0,-1136
    33c4:	00003097          	auipc	ra,0x3
    33c8:	80e080e7          	jalr	-2034(ra) # 5bd2 <open>
    33cc:	892a                	mv	s2,a0
    if(fd < 0){
    33ce:	e40547e3          	bltz	a0,321c <diskfull+0x58>
    33d2:	84ce                	mv	s1,s3
      if(write(fd, buf, BSIZE) != BSIZE){
    33d4:	40000613          	li	a2,1024
    33d8:	bb040593          	addi	a1,s0,-1104
    33dc:	854a                	mv	a0,s2
    33de:	00002097          	auipc	ra,0x2
    33e2:	7d4080e7          	jalr	2004(ra) # 5bb2 <write>
    33e6:	40000793          	li	a5,1024
    33ea:	e4f515e3          	bne	a0,a5,3234 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    33ee:	34fd                	addiw	s1,s1,-1
    33f0:	f0f5                	bnez	s1,33d4 <diskfull+0x210>
    33f2:	bf69                	j	338c <diskfull+0x1c8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33f4:	00004517          	auipc	a0,0x4
    33f8:	efc50513          	addi	a0,a0,-260 # 72f0 <malloc+0x133e>
    33fc:	00003097          	auipc	ra,0x3
    3400:	afe080e7          	jalr	-1282(ra) # 5efa <printf>
    3404:	b5c9                	j	32c6 <diskfull+0x102>

0000000000003406 <iputtest>:
{
    3406:	1101                	addi	sp,sp,-32
    3408:	ec06                	sd	ra,24(sp)
    340a:	e822                	sd	s0,16(sp)
    340c:	e426                	sd	s1,8(sp)
    340e:	1000                	addi	s0,sp,32
    3410:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3412:	00004517          	auipc	a0,0x4
    3416:	f0e50513          	addi	a0,a0,-242 # 7320 <malloc+0x136e>
    341a:	00002097          	auipc	ra,0x2
    341e:	7e0080e7          	jalr	2016(ra) # 5bfa <mkdir>
    3422:	04054563          	bltz	a0,346c <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3426:	00004517          	auipc	a0,0x4
    342a:	efa50513          	addi	a0,a0,-262 # 7320 <malloc+0x136e>
    342e:	00002097          	auipc	ra,0x2
    3432:	7d4080e7          	jalr	2004(ra) # 5c02 <chdir>
    3436:	04054963          	bltz	a0,3488 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    343a:	00004517          	auipc	a0,0x4
    343e:	f2650513          	addi	a0,a0,-218 # 7360 <malloc+0x13ae>
    3442:	00002097          	auipc	ra,0x2
    3446:	7a0080e7          	jalr	1952(ra) # 5be2 <unlink>
    344a:	04054d63          	bltz	a0,34a4 <iputtest+0x9e>
  if(chdir("/") < 0){
    344e:	00004517          	auipc	a0,0x4
    3452:	f4250513          	addi	a0,a0,-190 # 7390 <malloc+0x13de>
    3456:	00002097          	auipc	ra,0x2
    345a:	7ac080e7          	jalr	1964(ra) # 5c02 <chdir>
    345e:	06054163          	bltz	a0,34c0 <iputtest+0xba>
}
    3462:	60e2                	ld	ra,24(sp)
    3464:	6442                	ld	s0,16(sp)
    3466:	64a2                	ld	s1,8(sp)
    3468:	6105                	addi	sp,sp,32
    346a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    346c:	85a6                	mv	a1,s1
    346e:	00004517          	auipc	a0,0x4
    3472:	eba50513          	addi	a0,a0,-326 # 7328 <malloc+0x1376>
    3476:	00003097          	auipc	ra,0x3
    347a:	a84080e7          	jalr	-1404(ra) # 5efa <printf>
    exit(1);
    347e:	4505                	li	a0,1
    3480:	00002097          	auipc	ra,0x2
    3484:	712080e7          	jalr	1810(ra) # 5b92 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3488:	85a6                	mv	a1,s1
    348a:	00004517          	auipc	a0,0x4
    348e:	eb650513          	addi	a0,a0,-330 # 7340 <malloc+0x138e>
    3492:	00003097          	auipc	ra,0x3
    3496:	a68080e7          	jalr	-1432(ra) # 5efa <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	00002097          	auipc	ra,0x2
    34a0:	6f6080e7          	jalr	1782(ra) # 5b92 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34a4:	85a6                	mv	a1,s1
    34a6:	00004517          	auipc	a0,0x4
    34aa:	eca50513          	addi	a0,a0,-310 # 7370 <malloc+0x13be>
    34ae:	00003097          	auipc	ra,0x3
    34b2:	a4c080e7          	jalr	-1460(ra) # 5efa <printf>
    exit(1);
    34b6:	4505                	li	a0,1
    34b8:	00002097          	auipc	ra,0x2
    34bc:	6da080e7          	jalr	1754(ra) # 5b92 <exit>
    printf("%s: chdir / failed\n", s);
    34c0:	85a6                	mv	a1,s1
    34c2:	00004517          	auipc	a0,0x4
    34c6:	ed650513          	addi	a0,a0,-298 # 7398 <malloc+0x13e6>
    34ca:	00003097          	auipc	ra,0x3
    34ce:	a30080e7          	jalr	-1488(ra) # 5efa <printf>
    exit(1);
    34d2:	4505                	li	a0,1
    34d4:	00002097          	auipc	ra,0x2
    34d8:	6be080e7          	jalr	1726(ra) # 5b92 <exit>

00000000000034dc <exitiputtest>:
{
    34dc:	7179                	addi	sp,sp,-48
    34de:	f406                	sd	ra,40(sp)
    34e0:	f022                	sd	s0,32(sp)
    34e2:	ec26                	sd	s1,24(sp)
    34e4:	1800                	addi	s0,sp,48
    34e6:	84aa                	mv	s1,a0
  pid = fork();
    34e8:	00002097          	auipc	ra,0x2
    34ec:	6a2080e7          	jalr	1698(ra) # 5b8a <fork>
  if(pid < 0){
    34f0:	04054663          	bltz	a0,353c <exitiputtest+0x60>
  if(pid == 0){
    34f4:	ed45                	bnez	a0,35ac <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34f6:	00004517          	auipc	a0,0x4
    34fa:	e2a50513          	addi	a0,a0,-470 # 7320 <malloc+0x136e>
    34fe:	00002097          	auipc	ra,0x2
    3502:	6fc080e7          	jalr	1788(ra) # 5bfa <mkdir>
    3506:	04054963          	bltz	a0,3558 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    350a:	00004517          	auipc	a0,0x4
    350e:	e1650513          	addi	a0,a0,-490 # 7320 <malloc+0x136e>
    3512:	00002097          	auipc	ra,0x2
    3516:	6f0080e7          	jalr	1776(ra) # 5c02 <chdir>
    351a:	04054d63          	bltz	a0,3574 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    351e:	00004517          	auipc	a0,0x4
    3522:	e4250513          	addi	a0,a0,-446 # 7360 <malloc+0x13ae>
    3526:	00002097          	auipc	ra,0x2
    352a:	6bc080e7          	jalr	1724(ra) # 5be2 <unlink>
    352e:	06054163          	bltz	a0,3590 <exitiputtest+0xb4>
    exit(0);
    3532:	4501                	li	a0,0
    3534:	00002097          	auipc	ra,0x2
    3538:	65e080e7          	jalr	1630(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    353c:	85a6                	mv	a1,s1
    353e:	00003517          	auipc	a0,0x3
    3542:	42250513          	addi	a0,a0,1058 # 6960 <malloc+0x9ae>
    3546:	00003097          	auipc	ra,0x3
    354a:	9b4080e7          	jalr	-1612(ra) # 5efa <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	642080e7          	jalr	1602(ra) # 5b92 <exit>
      printf("%s: mkdir failed\n", s);
    3558:	85a6                	mv	a1,s1
    355a:	00004517          	auipc	a0,0x4
    355e:	dce50513          	addi	a0,a0,-562 # 7328 <malloc+0x1376>
    3562:	00003097          	auipc	ra,0x3
    3566:	998080e7          	jalr	-1640(ra) # 5efa <printf>
      exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	626080e7          	jalr	1574(ra) # 5b92 <exit>
      printf("%s: child chdir failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	e3a50513          	addi	a0,a0,-454 # 73b0 <malloc+0x13fe>
    357e:	00003097          	auipc	ra,0x3
    3582:	97c080e7          	jalr	-1668(ra) # 5efa <printf>
      exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	60a080e7          	jalr	1546(ra) # 5b92 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3590:	85a6                	mv	a1,s1
    3592:	00004517          	auipc	a0,0x4
    3596:	dde50513          	addi	a0,a0,-546 # 7370 <malloc+0x13be>
    359a:	00003097          	auipc	ra,0x3
    359e:	960080e7          	jalr	-1696(ra) # 5efa <printf>
      exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	5ee080e7          	jalr	1518(ra) # 5b92 <exit>
  wait(&xstatus);
    35ac:	fdc40513          	addi	a0,s0,-36
    35b0:	00002097          	auipc	ra,0x2
    35b4:	5ea080e7          	jalr	1514(ra) # 5b9a <wait>
  exit(xstatus);
    35b8:	fdc42503          	lw	a0,-36(s0)
    35bc:	00002097          	auipc	ra,0x2
    35c0:	5d6080e7          	jalr	1494(ra) # 5b92 <exit>

00000000000035c4 <dirtest>:
{
    35c4:	1101                	addi	sp,sp,-32
    35c6:	ec06                	sd	ra,24(sp)
    35c8:	e822                	sd	s0,16(sp)
    35ca:	e426                	sd	s1,8(sp)
    35cc:	1000                	addi	s0,sp,32
    35ce:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35d0:	00004517          	auipc	a0,0x4
    35d4:	df850513          	addi	a0,a0,-520 # 73c8 <malloc+0x1416>
    35d8:	00002097          	auipc	ra,0x2
    35dc:	622080e7          	jalr	1570(ra) # 5bfa <mkdir>
    35e0:	04054563          	bltz	a0,362a <dirtest+0x66>
  if(chdir("dir0") < 0){
    35e4:	00004517          	auipc	a0,0x4
    35e8:	de450513          	addi	a0,a0,-540 # 73c8 <malloc+0x1416>
    35ec:	00002097          	auipc	ra,0x2
    35f0:	616080e7          	jalr	1558(ra) # 5c02 <chdir>
    35f4:	04054963          	bltz	a0,3646 <dirtest+0x82>
  if(chdir("..") < 0){
    35f8:	00004517          	auipc	a0,0x4
    35fc:	df050513          	addi	a0,a0,-528 # 73e8 <malloc+0x1436>
    3600:	00002097          	auipc	ra,0x2
    3604:	602080e7          	jalr	1538(ra) # 5c02 <chdir>
    3608:	04054d63          	bltz	a0,3662 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    360c:	00004517          	auipc	a0,0x4
    3610:	dbc50513          	addi	a0,a0,-580 # 73c8 <malloc+0x1416>
    3614:	00002097          	auipc	ra,0x2
    3618:	5ce080e7          	jalr	1486(ra) # 5be2 <unlink>
    361c:	06054163          	bltz	a0,367e <dirtest+0xba>
}
    3620:	60e2                	ld	ra,24(sp)
    3622:	6442                	ld	s0,16(sp)
    3624:	64a2                	ld	s1,8(sp)
    3626:	6105                	addi	sp,sp,32
    3628:	8082                	ret
    printf("%s: mkdir failed\n", s);
    362a:	85a6                	mv	a1,s1
    362c:	00004517          	auipc	a0,0x4
    3630:	cfc50513          	addi	a0,a0,-772 # 7328 <malloc+0x1376>
    3634:	00003097          	auipc	ra,0x3
    3638:	8c6080e7          	jalr	-1850(ra) # 5efa <printf>
    exit(1);
    363c:	4505                	li	a0,1
    363e:	00002097          	auipc	ra,0x2
    3642:	554080e7          	jalr	1364(ra) # 5b92 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3646:	85a6                	mv	a1,s1
    3648:	00004517          	auipc	a0,0x4
    364c:	d8850513          	addi	a0,a0,-632 # 73d0 <malloc+0x141e>
    3650:	00003097          	auipc	ra,0x3
    3654:	8aa080e7          	jalr	-1878(ra) # 5efa <printf>
    exit(1);
    3658:	4505                	li	a0,1
    365a:	00002097          	auipc	ra,0x2
    365e:	538080e7          	jalr	1336(ra) # 5b92 <exit>
    printf("%s: chdir .. failed\n", s);
    3662:	85a6                	mv	a1,s1
    3664:	00004517          	auipc	a0,0x4
    3668:	d8c50513          	addi	a0,a0,-628 # 73f0 <malloc+0x143e>
    366c:	00003097          	auipc	ra,0x3
    3670:	88e080e7          	jalr	-1906(ra) # 5efa <printf>
    exit(1);
    3674:	4505                	li	a0,1
    3676:	00002097          	auipc	ra,0x2
    367a:	51c080e7          	jalr	1308(ra) # 5b92 <exit>
    printf("%s: unlink dir0 failed\n", s);
    367e:	85a6                	mv	a1,s1
    3680:	00004517          	auipc	a0,0x4
    3684:	d8850513          	addi	a0,a0,-632 # 7408 <malloc+0x1456>
    3688:	00003097          	auipc	ra,0x3
    368c:	872080e7          	jalr	-1934(ra) # 5efa <printf>
    exit(1);
    3690:	4505                	li	a0,1
    3692:	00002097          	auipc	ra,0x2
    3696:	500080e7          	jalr	1280(ra) # 5b92 <exit>

000000000000369a <subdir>:
{
    369a:	1101                	addi	sp,sp,-32
    369c:	ec06                	sd	ra,24(sp)
    369e:	e822                	sd	s0,16(sp)
    36a0:	e426                	sd	s1,8(sp)
    36a2:	e04a                	sd	s2,0(sp)
    36a4:	1000                	addi	s0,sp,32
    36a6:	892a                	mv	s2,a0
  unlink("ff");
    36a8:	00004517          	auipc	a0,0x4
    36ac:	ea850513          	addi	a0,a0,-344 # 7550 <malloc+0x159e>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	532080e7          	jalr	1330(ra) # 5be2 <unlink>
  if(mkdir("dd") != 0){
    36b8:	00004517          	auipc	a0,0x4
    36bc:	d6850513          	addi	a0,a0,-664 # 7420 <malloc+0x146e>
    36c0:	00002097          	auipc	ra,0x2
    36c4:	53a080e7          	jalr	1338(ra) # 5bfa <mkdir>
    36c8:	38051663          	bnez	a0,3a54 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36cc:	20200593          	li	a1,514
    36d0:	00004517          	auipc	a0,0x4
    36d4:	d7050513          	addi	a0,a0,-656 # 7440 <malloc+0x148e>
    36d8:	00002097          	auipc	ra,0x2
    36dc:	4fa080e7          	jalr	1274(ra) # 5bd2 <open>
    36e0:	84aa                	mv	s1,a0
  if(fd < 0){
    36e2:	38054763          	bltz	a0,3a70 <subdir+0x3d6>
  write(fd, "ff", 2);
    36e6:	4609                	li	a2,2
    36e8:	00004597          	auipc	a1,0x4
    36ec:	e6858593          	addi	a1,a1,-408 # 7550 <malloc+0x159e>
    36f0:	00002097          	auipc	ra,0x2
    36f4:	4c2080e7          	jalr	1218(ra) # 5bb2 <write>
  close(fd);
    36f8:	8526                	mv	a0,s1
    36fa:	00002097          	auipc	ra,0x2
    36fe:	4c0080e7          	jalr	1216(ra) # 5bba <close>
  if(unlink("dd") >= 0){
    3702:	00004517          	auipc	a0,0x4
    3706:	d1e50513          	addi	a0,a0,-738 # 7420 <malloc+0x146e>
    370a:	00002097          	auipc	ra,0x2
    370e:	4d8080e7          	jalr	1240(ra) # 5be2 <unlink>
    3712:	36055d63          	bgez	a0,3a8c <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3716:	00004517          	auipc	a0,0x4
    371a:	d8250513          	addi	a0,a0,-638 # 7498 <malloc+0x14e6>
    371e:	00002097          	auipc	ra,0x2
    3722:	4dc080e7          	jalr	1244(ra) # 5bfa <mkdir>
    3726:	38051163          	bnez	a0,3aa8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    372a:	20200593          	li	a1,514
    372e:	00004517          	auipc	a0,0x4
    3732:	d9250513          	addi	a0,a0,-622 # 74c0 <malloc+0x150e>
    3736:	00002097          	auipc	ra,0x2
    373a:	49c080e7          	jalr	1180(ra) # 5bd2 <open>
    373e:	84aa                	mv	s1,a0
  if(fd < 0){
    3740:	38054263          	bltz	a0,3ac4 <subdir+0x42a>
  write(fd, "FF", 2);
    3744:	4609                	li	a2,2
    3746:	00004597          	auipc	a1,0x4
    374a:	daa58593          	addi	a1,a1,-598 # 74f0 <malloc+0x153e>
    374e:	00002097          	auipc	ra,0x2
    3752:	464080e7          	jalr	1124(ra) # 5bb2 <write>
  close(fd);
    3756:	8526                	mv	a0,s1
    3758:	00002097          	auipc	ra,0x2
    375c:	462080e7          	jalr	1122(ra) # 5bba <close>
  fd = open("dd/dd/../ff", 0);
    3760:	4581                	li	a1,0
    3762:	00004517          	auipc	a0,0x4
    3766:	d9650513          	addi	a0,a0,-618 # 74f8 <malloc+0x1546>
    376a:	00002097          	auipc	ra,0x2
    376e:	468080e7          	jalr	1128(ra) # 5bd2 <open>
    3772:	84aa                	mv	s1,a0
  if(fd < 0){
    3774:	36054663          	bltz	a0,3ae0 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3778:	660d                	lui	a2,0x3
    377a:	00009597          	auipc	a1,0x9
    377e:	4fe58593          	addi	a1,a1,1278 # cc78 <buf>
    3782:	00002097          	auipc	ra,0x2
    3786:	428080e7          	jalr	1064(ra) # 5baa <read>
  if(cc != 2 || buf[0] != 'f'){
    378a:	4789                	li	a5,2
    378c:	36f51863          	bne	a0,a5,3afc <subdir+0x462>
    3790:	00009717          	auipc	a4,0x9
    3794:	4e874703          	lbu	a4,1256(a4) # cc78 <buf>
    3798:	06600793          	li	a5,102
    379c:	36f71063          	bne	a4,a5,3afc <subdir+0x462>
  close(fd);
    37a0:	8526                	mv	a0,s1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	418080e7          	jalr	1048(ra) # 5bba <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37aa:	00004597          	auipc	a1,0x4
    37ae:	d9e58593          	addi	a1,a1,-610 # 7548 <malloc+0x1596>
    37b2:	00004517          	auipc	a0,0x4
    37b6:	d0e50513          	addi	a0,a0,-754 # 74c0 <malloc+0x150e>
    37ba:	00002097          	auipc	ra,0x2
    37be:	438080e7          	jalr	1080(ra) # 5bf2 <link>
    37c2:	34051b63          	bnez	a0,3b18 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37c6:	00004517          	auipc	a0,0x4
    37ca:	cfa50513          	addi	a0,a0,-774 # 74c0 <malloc+0x150e>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	414080e7          	jalr	1044(ra) # 5be2 <unlink>
    37d6:	34051f63          	bnez	a0,3b34 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37da:	4581                	li	a1,0
    37dc:	00004517          	auipc	a0,0x4
    37e0:	ce450513          	addi	a0,a0,-796 # 74c0 <malloc+0x150e>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	3ee080e7          	jalr	1006(ra) # 5bd2 <open>
    37ec:	36055263          	bgez	a0,3b50 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37f0:	00004517          	auipc	a0,0x4
    37f4:	c3050513          	addi	a0,a0,-976 # 7420 <malloc+0x146e>
    37f8:	00002097          	auipc	ra,0x2
    37fc:	40a080e7          	jalr	1034(ra) # 5c02 <chdir>
    3800:	36051663          	bnez	a0,3b6c <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3804:	00004517          	auipc	a0,0x4
    3808:	ddc50513          	addi	a0,a0,-548 # 75e0 <malloc+0x162e>
    380c:	00002097          	auipc	ra,0x2
    3810:	3f6080e7          	jalr	1014(ra) # 5c02 <chdir>
    3814:	36051a63          	bnez	a0,3b88 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3818:	00004517          	auipc	a0,0x4
    381c:	df850513          	addi	a0,a0,-520 # 7610 <malloc+0x165e>
    3820:	00002097          	auipc	ra,0x2
    3824:	3e2080e7          	jalr	994(ra) # 5c02 <chdir>
    3828:	36051e63          	bnez	a0,3ba4 <subdir+0x50a>
  if(chdir("./..") != 0){
    382c:	00004517          	auipc	a0,0x4
    3830:	e1450513          	addi	a0,a0,-492 # 7640 <malloc+0x168e>
    3834:	00002097          	auipc	ra,0x2
    3838:	3ce080e7          	jalr	974(ra) # 5c02 <chdir>
    383c:	38051263          	bnez	a0,3bc0 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3840:	4581                	li	a1,0
    3842:	00004517          	auipc	a0,0x4
    3846:	d0650513          	addi	a0,a0,-762 # 7548 <malloc+0x1596>
    384a:	00002097          	auipc	ra,0x2
    384e:	388080e7          	jalr	904(ra) # 5bd2 <open>
    3852:	84aa                	mv	s1,a0
  if(fd < 0){
    3854:	38054463          	bltz	a0,3bdc <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3858:	660d                	lui	a2,0x3
    385a:	00009597          	auipc	a1,0x9
    385e:	41e58593          	addi	a1,a1,1054 # cc78 <buf>
    3862:	00002097          	auipc	ra,0x2
    3866:	348080e7          	jalr	840(ra) # 5baa <read>
    386a:	4789                	li	a5,2
    386c:	38f51663          	bne	a0,a5,3bf8 <subdir+0x55e>
  close(fd);
    3870:	8526                	mv	a0,s1
    3872:	00002097          	auipc	ra,0x2
    3876:	348080e7          	jalr	840(ra) # 5bba <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    387a:	4581                	li	a1,0
    387c:	00004517          	auipc	a0,0x4
    3880:	c4450513          	addi	a0,a0,-956 # 74c0 <malloc+0x150e>
    3884:	00002097          	auipc	ra,0x2
    3888:	34e080e7          	jalr	846(ra) # 5bd2 <open>
    388c:	38055463          	bgez	a0,3c14 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3890:	20200593          	li	a1,514
    3894:	00004517          	auipc	a0,0x4
    3898:	e3c50513          	addi	a0,a0,-452 # 76d0 <malloc+0x171e>
    389c:	00002097          	auipc	ra,0x2
    38a0:	336080e7          	jalr	822(ra) # 5bd2 <open>
    38a4:	38055663          	bgez	a0,3c30 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38a8:	20200593          	li	a1,514
    38ac:	00004517          	auipc	a0,0x4
    38b0:	e5450513          	addi	a0,a0,-428 # 7700 <malloc+0x174e>
    38b4:	00002097          	auipc	ra,0x2
    38b8:	31e080e7          	jalr	798(ra) # 5bd2 <open>
    38bc:	38055863          	bgez	a0,3c4c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38c0:	20000593          	li	a1,512
    38c4:	00004517          	auipc	a0,0x4
    38c8:	b5c50513          	addi	a0,a0,-1188 # 7420 <malloc+0x146e>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	306080e7          	jalr	774(ra) # 5bd2 <open>
    38d4:	38055a63          	bgez	a0,3c68 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38d8:	4589                	li	a1,2
    38da:	00004517          	auipc	a0,0x4
    38de:	b4650513          	addi	a0,a0,-1210 # 7420 <malloc+0x146e>
    38e2:	00002097          	auipc	ra,0x2
    38e6:	2f0080e7          	jalr	752(ra) # 5bd2 <open>
    38ea:	38055d63          	bgez	a0,3c84 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38ee:	4585                	li	a1,1
    38f0:	00004517          	auipc	a0,0x4
    38f4:	b3050513          	addi	a0,a0,-1232 # 7420 <malloc+0x146e>
    38f8:	00002097          	auipc	ra,0x2
    38fc:	2da080e7          	jalr	730(ra) # 5bd2 <open>
    3900:	3a055063          	bgez	a0,3ca0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3904:	00004597          	auipc	a1,0x4
    3908:	e8c58593          	addi	a1,a1,-372 # 7790 <malloc+0x17de>
    390c:	00004517          	auipc	a0,0x4
    3910:	dc450513          	addi	a0,a0,-572 # 76d0 <malloc+0x171e>
    3914:	00002097          	auipc	ra,0x2
    3918:	2de080e7          	jalr	734(ra) # 5bf2 <link>
    391c:	3a050063          	beqz	a0,3cbc <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3920:	00004597          	auipc	a1,0x4
    3924:	e7058593          	addi	a1,a1,-400 # 7790 <malloc+0x17de>
    3928:	00004517          	auipc	a0,0x4
    392c:	dd850513          	addi	a0,a0,-552 # 7700 <malloc+0x174e>
    3930:	00002097          	auipc	ra,0x2
    3934:	2c2080e7          	jalr	706(ra) # 5bf2 <link>
    3938:	3a050063          	beqz	a0,3cd8 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    393c:	00004597          	auipc	a1,0x4
    3940:	c0c58593          	addi	a1,a1,-1012 # 7548 <malloc+0x1596>
    3944:	00004517          	auipc	a0,0x4
    3948:	afc50513          	addi	a0,a0,-1284 # 7440 <malloc+0x148e>
    394c:	00002097          	auipc	ra,0x2
    3950:	2a6080e7          	jalr	678(ra) # 5bf2 <link>
    3954:	3a050063          	beqz	a0,3cf4 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3958:	00004517          	auipc	a0,0x4
    395c:	d7850513          	addi	a0,a0,-648 # 76d0 <malloc+0x171e>
    3960:	00002097          	auipc	ra,0x2
    3964:	29a080e7          	jalr	666(ra) # 5bfa <mkdir>
    3968:	3a050463          	beqz	a0,3d10 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    396c:	00004517          	auipc	a0,0x4
    3970:	d9450513          	addi	a0,a0,-620 # 7700 <malloc+0x174e>
    3974:	00002097          	auipc	ra,0x2
    3978:	286080e7          	jalr	646(ra) # 5bfa <mkdir>
    397c:	3a050863          	beqz	a0,3d2c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3980:	00004517          	auipc	a0,0x4
    3984:	bc850513          	addi	a0,a0,-1080 # 7548 <malloc+0x1596>
    3988:	00002097          	auipc	ra,0x2
    398c:	272080e7          	jalr	626(ra) # 5bfa <mkdir>
    3990:	3a050c63          	beqz	a0,3d48 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3994:	00004517          	auipc	a0,0x4
    3998:	d6c50513          	addi	a0,a0,-660 # 7700 <malloc+0x174e>
    399c:	00002097          	auipc	ra,0x2
    39a0:	246080e7          	jalr	582(ra) # 5be2 <unlink>
    39a4:	3c050063          	beqz	a0,3d64 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39a8:	00004517          	auipc	a0,0x4
    39ac:	d2850513          	addi	a0,a0,-728 # 76d0 <malloc+0x171e>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	232080e7          	jalr	562(ra) # 5be2 <unlink>
    39b8:	3c050463          	beqz	a0,3d80 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39bc:	00004517          	auipc	a0,0x4
    39c0:	a8450513          	addi	a0,a0,-1404 # 7440 <malloc+0x148e>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	23e080e7          	jalr	574(ra) # 5c02 <chdir>
    39cc:	3c050863          	beqz	a0,3d9c <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39d0:	00004517          	auipc	a0,0x4
    39d4:	f1050513          	addi	a0,a0,-240 # 78e0 <malloc+0x192e>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	22a080e7          	jalr	554(ra) # 5c02 <chdir>
    39e0:	3c050c63          	beqz	a0,3db8 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	b6450513          	addi	a0,a0,-1180 # 7548 <malloc+0x1596>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	1f6080e7          	jalr	502(ra) # 5be2 <unlink>
    39f4:	3e051063          	bnez	a0,3dd4 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39f8:	00004517          	auipc	a0,0x4
    39fc:	a4850513          	addi	a0,a0,-1464 # 7440 <malloc+0x148e>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	1e2080e7          	jalr	482(ra) # 5be2 <unlink>
    3a08:	3e051463          	bnez	a0,3df0 <subdir+0x756>
  if(unlink("dd") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	a1450513          	addi	a0,a0,-1516 # 7420 <malloc+0x146e>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	1ce080e7          	jalr	462(ra) # 5be2 <unlink>
    3a1c:	3e050863          	beqz	a0,3e0c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	f3050513          	addi	a0,a0,-208 # 7950 <malloc+0x199e>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	1ba080e7          	jalr	442(ra) # 5be2 <unlink>
    3a30:	3e054c63          	bltz	a0,3e28 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	9ec50513          	addi	a0,a0,-1556 # 7420 <malloc+0x146e>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	1a6080e7          	jalr	422(ra) # 5be2 <unlink>
    3a44:	40054063          	bltz	a0,3e44 <subdir+0x7aa>
}
    3a48:	60e2                	ld	ra,24(sp)
    3a4a:	6442                	ld	s0,16(sp)
    3a4c:	64a2                	ld	s1,8(sp)
    3a4e:	6902                	ld	s2,0(sp)
    3a50:	6105                	addi	sp,sp,32
    3a52:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a54:	85ca                	mv	a1,s2
    3a56:	00004517          	auipc	a0,0x4
    3a5a:	9d250513          	addi	a0,a0,-1582 # 7428 <malloc+0x1476>
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	49c080e7          	jalr	1180(ra) # 5efa <printf>
    exit(1);
    3a66:	4505                	li	a0,1
    3a68:	00002097          	auipc	ra,0x2
    3a6c:	12a080e7          	jalr	298(ra) # 5b92 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a70:	85ca                	mv	a1,s2
    3a72:	00004517          	auipc	a0,0x4
    3a76:	9d650513          	addi	a0,a0,-1578 # 7448 <malloc+0x1496>
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	480080e7          	jalr	1152(ra) # 5efa <printf>
    exit(1);
    3a82:	4505                	li	a0,1
    3a84:	00002097          	auipc	ra,0x2
    3a88:	10e080e7          	jalr	270(ra) # 5b92 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a8c:	85ca                	mv	a1,s2
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	9da50513          	addi	a0,a0,-1574 # 7468 <malloc+0x14b6>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	464080e7          	jalr	1124(ra) # 5efa <printf>
    exit(1);
    3a9e:	4505                	li	a0,1
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	0f2080e7          	jalr	242(ra) # 5b92 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3aa8:	85ca                	mv	a1,s2
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	9f650513          	addi	a0,a0,-1546 # 74a0 <malloc+0x14ee>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	448080e7          	jalr	1096(ra) # 5efa <printf>
    exit(1);
    3aba:	4505                	li	a0,1
    3abc:	00002097          	auipc	ra,0x2
    3ac0:	0d6080e7          	jalr	214(ra) # 5b92 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ac4:	85ca                	mv	a1,s2
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	a0a50513          	addi	a0,a0,-1526 # 74d0 <malloc+0x151e>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	42c080e7          	jalr	1068(ra) # 5efa <printf>
    exit(1);
    3ad6:	4505                	li	a0,1
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	0ba080e7          	jalr	186(ra) # 5b92 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ae0:	85ca                	mv	a1,s2
    3ae2:	00004517          	auipc	a0,0x4
    3ae6:	a2650513          	addi	a0,a0,-1498 # 7508 <malloc+0x1556>
    3aea:	00002097          	auipc	ra,0x2
    3aee:	410080e7          	jalr	1040(ra) # 5efa <printf>
    exit(1);
    3af2:	4505                	li	a0,1
    3af4:	00002097          	auipc	ra,0x2
    3af8:	09e080e7          	jalr	158(ra) # 5b92 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3afc:	85ca                	mv	a1,s2
    3afe:	00004517          	auipc	a0,0x4
    3b02:	a2a50513          	addi	a0,a0,-1494 # 7528 <malloc+0x1576>
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	3f4080e7          	jalr	1012(ra) # 5efa <printf>
    exit(1);
    3b0e:	4505                	li	a0,1
    3b10:	00002097          	auipc	ra,0x2
    3b14:	082080e7          	jalr	130(ra) # 5b92 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b18:	85ca                	mv	a1,s2
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	a3e50513          	addi	a0,a0,-1474 # 7558 <malloc+0x15a6>
    3b22:	00002097          	auipc	ra,0x2
    3b26:	3d8080e7          	jalr	984(ra) # 5efa <printf>
    exit(1);
    3b2a:	4505                	li	a0,1
    3b2c:	00002097          	auipc	ra,0x2
    3b30:	066080e7          	jalr	102(ra) # 5b92 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b34:	85ca                	mv	a1,s2
    3b36:	00004517          	auipc	a0,0x4
    3b3a:	a4a50513          	addi	a0,a0,-1462 # 7580 <malloc+0x15ce>
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	3bc080e7          	jalr	956(ra) # 5efa <printf>
    exit(1);
    3b46:	4505                	li	a0,1
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	04a080e7          	jalr	74(ra) # 5b92 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b50:	85ca                	mv	a1,s2
    3b52:	00004517          	auipc	a0,0x4
    3b56:	a4e50513          	addi	a0,a0,-1458 # 75a0 <malloc+0x15ee>
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	3a0080e7          	jalr	928(ra) # 5efa <printf>
    exit(1);
    3b62:	4505                	li	a0,1
    3b64:	00002097          	auipc	ra,0x2
    3b68:	02e080e7          	jalr	46(ra) # 5b92 <exit>
    printf("%s: chdir dd failed\n", s);
    3b6c:	85ca                	mv	a1,s2
    3b6e:	00004517          	auipc	a0,0x4
    3b72:	a5a50513          	addi	a0,a0,-1446 # 75c8 <malloc+0x1616>
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	384080e7          	jalr	900(ra) # 5efa <printf>
    exit(1);
    3b7e:	4505                	li	a0,1
    3b80:	00002097          	auipc	ra,0x2
    3b84:	012080e7          	jalr	18(ra) # 5b92 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b88:	85ca                	mv	a1,s2
    3b8a:	00004517          	auipc	a0,0x4
    3b8e:	a6650513          	addi	a0,a0,-1434 # 75f0 <malloc+0x163e>
    3b92:	00002097          	auipc	ra,0x2
    3b96:	368080e7          	jalr	872(ra) # 5efa <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	00002097          	auipc	ra,0x2
    3ba0:	ff6080e7          	jalr	-10(ra) # 5b92 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ba4:	85ca                	mv	a1,s2
    3ba6:	00004517          	auipc	a0,0x4
    3baa:	a7a50513          	addi	a0,a0,-1414 # 7620 <malloc+0x166e>
    3bae:	00002097          	auipc	ra,0x2
    3bb2:	34c080e7          	jalr	844(ra) # 5efa <printf>
    exit(1);
    3bb6:	4505                	li	a0,1
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	fda080e7          	jalr	-38(ra) # 5b92 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bc0:	85ca                	mv	a1,s2
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	a8650513          	addi	a0,a0,-1402 # 7648 <malloc+0x1696>
    3bca:	00002097          	auipc	ra,0x2
    3bce:	330080e7          	jalr	816(ra) # 5efa <printf>
    exit(1);
    3bd2:	4505                	li	a0,1
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	fbe080e7          	jalr	-66(ra) # 5b92 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bdc:	85ca                	mv	a1,s2
    3bde:	00004517          	auipc	a0,0x4
    3be2:	a8250513          	addi	a0,a0,-1406 # 7660 <malloc+0x16ae>
    3be6:	00002097          	auipc	ra,0x2
    3bea:	314080e7          	jalr	788(ra) # 5efa <printf>
    exit(1);
    3bee:	4505                	li	a0,1
    3bf0:	00002097          	auipc	ra,0x2
    3bf4:	fa2080e7          	jalr	-94(ra) # 5b92 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bf8:	85ca                	mv	a1,s2
    3bfa:	00004517          	auipc	a0,0x4
    3bfe:	a8650513          	addi	a0,a0,-1402 # 7680 <malloc+0x16ce>
    3c02:	00002097          	auipc	ra,0x2
    3c06:	2f8080e7          	jalr	760(ra) # 5efa <printf>
    exit(1);
    3c0a:	4505                	li	a0,1
    3c0c:	00002097          	auipc	ra,0x2
    3c10:	f86080e7          	jalr	-122(ra) # 5b92 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c14:	85ca                	mv	a1,s2
    3c16:	00004517          	auipc	a0,0x4
    3c1a:	a8a50513          	addi	a0,a0,-1398 # 76a0 <malloc+0x16ee>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	2dc080e7          	jalr	732(ra) # 5efa <printf>
    exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00002097          	auipc	ra,0x2
    3c2c:	f6a080e7          	jalr	-150(ra) # 5b92 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c30:	85ca                	mv	a1,s2
    3c32:	00004517          	auipc	a0,0x4
    3c36:	aae50513          	addi	a0,a0,-1362 # 76e0 <malloc+0x172e>
    3c3a:	00002097          	auipc	ra,0x2
    3c3e:	2c0080e7          	jalr	704(ra) # 5efa <printf>
    exit(1);
    3c42:	4505                	li	a0,1
    3c44:	00002097          	auipc	ra,0x2
    3c48:	f4e080e7          	jalr	-178(ra) # 5b92 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c4c:	85ca                	mv	a1,s2
    3c4e:	00004517          	auipc	a0,0x4
    3c52:	ac250513          	addi	a0,a0,-1342 # 7710 <malloc+0x175e>
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	2a4080e7          	jalr	676(ra) # 5efa <printf>
    exit(1);
    3c5e:	4505                	li	a0,1
    3c60:	00002097          	auipc	ra,0x2
    3c64:	f32080e7          	jalr	-206(ra) # 5b92 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c68:	85ca                	mv	a1,s2
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	ac650513          	addi	a0,a0,-1338 # 7730 <malloc+0x177e>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	288080e7          	jalr	648(ra) # 5efa <printf>
    exit(1);
    3c7a:	4505                	li	a0,1
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	f16080e7          	jalr	-234(ra) # 5b92 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c84:	85ca                	mv	a1,s2
    3c86:	00004517          	auipc	a0,0x4
    3c8a:	aca50513          	addi	a0,a0,-1334 # 7750 <malloc+0x179e>
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	26c080e7          	jalr	620(ra) # 5efa <printf>
    exit(1);
    3c96:	4505                	li	a0,1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	efa080e7          	jalr	-262(ra) # 5b92 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ca0:	85ca                	mv	a1,s2
    3ca2:	00004517          	auipc	a0,0x4
    3ca6:	ace50513          	addi	a0,a0,-1330 # 7770 <malloc+0x17be>
    3caa:	00002097          	auipc	ra,0x2
    3cae:	250080e7          	jalr	592(ra) # 5efa <printf>
    exit(1);
    3cb2:	4505                	li	a0,1
    3cb4:	00002097          	auipc	ra,0x2
    3cb8:	ede080e7          	jalr	-290(ra) # 5b92 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cbc:	85ca                	mv	a1,s2
    3cbe:	00004517          	auipc	a0,0x4
    3cc2:	ae250513          	addi	a0,a0,-1310 # 77a0 <malloc+0x17ee>
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	234080e7          	jalr	564(ra) # 5efa <printf>
    exit(1);
    3cce:	4505                	li	a0,1
    3cd0:	00002097          	auipc	ra,0x2
    3cd4:	ec2080e7          	jalr	-318(ra) # 5b92 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cd8:	85ca                	mv	a1,s2
    3cda:	00004517          	auipc	a0,0x4
    3cde:	aee50513          	addi	a0,a0,-1298 # 77c8 <malloc+0x1816>
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	218080e7          	jalr	536(ra) # 5efa <printf>
    exit(1);
    3cea:	4505                	li	a0,1
    3cec:	00002097          	auipc	ra,0x2
    3cf0:	ea6080e7          	jalr	-346(ra) # 5b92 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cf4:	85ca                	mv	a1,s2
    3cf6:	00004517          	auipc	a0,0x4
    3cfa:	afa50513          	addi	a0,a0,-1286 # 77f0 <malloc+0x183e>
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	1fc080e7          	jalr	508(ra) # 5efa <printf>
    exit(1);
    3d06:	4505                	li	a0,1
    3d08:	00002097          	auipc	ra,0x2
    3d0c:	e8a080e7          	jalr	-374(ra) # 5b92 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d10:	85ca                	mv	a1,s2
    3d12:	00004517          	auipc	a0,0x4
    3d16:	b0650513          	addi	a0,a0,-1274 # 7818 <malloc+0x1866>
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	1e0080e7          	jalr	480(ra) # 5efa <printf>
    exit(1);
    3d22:	4505                	li	a0,1
    3d24:	00002097          	auipc	ra,0x2
    3d28:	e6e080e7          	jalr	-402(ra) # 5b92 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d2c:	85ca                	mv	a1,s2
    3d2e:	00004517          	auipc	a0,0x4
    3d32:	b0a50513          	addi	a0,a0,-1270 # 7838 <malloc+0x1886>
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	1c4080e7          	jalr	452(ra) # 5efa <printf>
    exit(1);
    3d3e:	4505                	li	a0,1
    3d40:	00002097          	auipc	ra,0x2
    3d44:	e52080e7          	jalr	-430(ra) # 5b92 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d48:	85ca                	mv	a1,s2
    3d4a:	00004517          	auipc	a0,0x4
    3d4e:	b0e50513          	addi	a0,a0,-1266 # 7858 <malloc+0x18a6>
    3d52:	00002097          	auipc	ra,0x2
    3d56:	1a8080e7          	jalr	424(ra) # 5efa <printf>
    exit(1);
    3d5a:	4505                	li	a0,1
    3d5c:	00002097          	auipc	ra,0x2
    3d60:	e36080e7          	jalr	-458(ra) # 5b92 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d64:	85ca                	mv	a1,s2
    3d66:	00004517          	auipc	a0,0x4
    3d6a:	b1a50513          	addi	a0,a0,-1254 # 7880 <malloc+0x18ce>
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	18c080e7          	jalr	396(ra) # 5efa <printf>
    exit(1);
    3d76:	4505                	li	a0,1
    3d78:	00002097          	auipc	ra,0x2
    3d7c:	e1a080e7          	jalr	-486(ra) # 5b92 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d80:	85ca                	mv	a1,s2
    3d82:	00004517          	auipc	a0,0x4
    3d86:	b1e50513          	addi	a0,a0,-1250 # 78a0 <malloc+0x18ee>
    3d8a:	00002097          	auipc	ra,0x2
    3d8e:	170080e7          	jalr	368(ra) # 5efa <printf>
    exit(1);
    3d92:	4505                	li	a0,1
    3d94:	00002097          	auipc	ra,0x2
    3d98:	dfe080e7          	jalr	-514(ra) # 5b92 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d9c:	85ca                	mv	a1,s2
    3d9e:	00004517          	auipc	a0,0x4
    3da2:	b2250513          	addi	a0,a0,-1246 # 78c0 <malloc+0x190e>
    3da6:	00002097          	auipc	ra,0x2
    3daa:	154080e7          	jalr	340(ra) # 5efa <printf>
    exit(1);
    3dae:	4505                	li	a0,1
    3db0:	00002097          	auipc	ra,0x2
    3db4:	de2080e7          	jalr	-542(ra) # 5b92 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3db8:	85ca                	mv	a1,s2
    3dba:	00004517          	auipc	a0,0x4
    3dbe:	b2e50513          	addi	a0,a0,-1234 # 78e8 <malloc+0x1936>
    3dc2:	00002097          	auipc	ra,0x2
    3dc6:	138080e7          	jalr	312(ra) # 5efa <printf>
    exit(1);
    3dca:	4505                	li	a0,1
    3dcc:	00002097          	auipc	ra,0x2
    3dd0:	dc6080e7          	jalr	-570(ra) # 5b92 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dd4:	85ca                	mv	a1,s2
    3dd6:	00003517          	auipc	a0,0x3
    3dda:	7aa50513          	addi	a0,a0,1962 # 7580 <malloc+0x15ce>
    3dde:	00002097          	auipc	ra,0x2
    3de2:	11c080e7          	jalr	284(ra) # 5efa <printf>
    exit(1);
    3de6:	4505                	li	a0,1
    3de8:	00002097          	auipc	ra,0x2
    3dec:	daa080e7          	jalr	-598(ra) # 5b92 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3df0:	85ca                	mv	a1,s2
    3df2:	00004517          	auipc	a0,0x4
    3df6:	b1650513          	addi	a0,a0,-1258 # 7908 <malloc+0x1956>
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	100080e7          	jalr	256(ra) # 5efa <printf>
    exit(1);
    3e02:	4505                	li	a0,1
    3e04:	00002097          	auipc	ra,0x2
    3e08:	d8e080e7          	jalr	-626(ra) # 5b92 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e0c:	85ca                	mv	a1,s2
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	b1a50513          	addi	a0,a0,-1254 # 7928 <malloc+0x1976>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	0e4080e7          	jalr	228(ra) # 5efa <printf>
    exit(1);
    3e1e:	4505                	li	a0,1
    3e20:	00002097          	auipc	ra,0x2
    3e24:	d72080e7          	jalr	-654(ra) # 5b92 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e28:	85ca                	mv	a1,s2
    3e2a:	00004517          	auipc	a0,0x4
    3e2e:	b2e50513          	addi	a0,a0,-1234 # 7958 <malloc+0x19a6>
    3e32:	00002097          	auipc	ra,0x2
    3e36:	0c8080e7          	jalr	200(ra) # 5efa <printf>
    exit(1);
    3e3a:	4505                	li	a0,1
    3e3c:	00002097          	auipc	ra,0x2
    3e40:	d56080e7          	jalr	-682(ra) # 5b92 <exit>
    printf("%s: unlink dd failed\n", s);
    3e44:	85ca                	mv	a1,s2
    3e46:	00004517          	auipc	a0,0x4
    3e4a:	b3250513          	addi	a0,a0,-1230 # 7978 <malloc+0x19c6>
    3e4e:	00002097          	auipc	ra,0x2
    3e52:	0ac080e7          	jalr	172(ra) # 5efa <printf>
    exit(1);
    3e56:	4505                	li	a0,1
    3e58:	00002097          	auipc	ra,0x2
    3e5c:	d3a080e7          	jalr	-710(ra) # 5b92 <exit>

0000000000003e60 <rmdot>:
{
    3e60:	1101                	addi	sp,sp,-32
    3e62:	ec06                	sd	ra,24(sp)
    3e64:	e822                	sd	s0,16(sp)
    3e66:	e426                	sd	s1,8(sp)
    3e68:	1000                	addi	s0,sp,32
    3e6a:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e6c:	00004517          	auipc	a0,0x4
    3e70:	b2450513          	addi	a0,a0,-1244 # 7990 <malloc+0x19de>
    3e74:	00002097          	auipc	ra,0x2
    3e78:	d86080e7          	jalr	-634(ra) # 5bfa <mkdir>
    3e7c:	e549                	bnez	a0,3f06 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e7e:	00004517          	auipc	a0,0x4
    3e82:	b1250513          	addi	a0,a0,-1262 # 7990 <malloc+0x19de>
    3e86:	00002097          	auipc	ra,0x2
    3e8a:	d7c080e7          	jalr	-644(ra) # 5c02 <chdir>
    3e8e:	e951                	bnez	a0,3f22 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e90:	00003517          	auipc	a0,0x3
    3e94:	93050513          	addi	a0,a0,-1744 # 67c0 <malloc+0x80e>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	d4a080e7          	jalr	-694(ra) # 5be2 <unlink>
    3ea0:	cd59                	beqz	a0,3f3e <rmdot+0xde>
  if(unlink("..") == 0){
    3ea2:	00003517          	auipc	a0,0x3
    3ea6:	54650513          	addi	a0,a0,1350 # 73e8 <malloc+0x1436>
    3eaa:	00002097          	auipc	ra,0x2
    3eae:	d38080e7          	jalr	-712(ra) # 5be2 <unlink>
    3eb2:	c545                	beqz	a0,3f5a <rmdot+0xfa>
  if(chdir("/") != 0){
    3eb4:	00003517          	auipc	a0,0x3
    3eb8:	4dc50513          	addi	a0,a0,1244 # 7390 <malloc+0x13de>
    3ebc:	00002097          	auipc	ra,0x2
    3ec0:	d46080e7          	jalr	-698(ra) # 5c02 <chdir>
    3ec4:	e94d                	bnez	a0,3f76 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ec6:	00004517          	auipc	a0,0x4
    3eca:	b3250513          	addi	a0,a0,-1230 # 79f8 <malloc+0x1a46>
    3ece:	00002097          	auipc	ra,0x2
    3ed2:	d14080e7          	jalr	-748(ra) # 5be2 <unlink>
    3ed6:	cd55                	beqz	a0,3f92 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3ed8:	00004517          	auipc	a0,0x4
    3edc:	b4850513          	addi	a0,a0,-1208 # 7a20 <malloc+0x1a6e>
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	d02080e7          	jalr	-766(ra) # 5be2 <unlink>
    3ee8:	c179                	beqz	a0,3fae <rmdot+0x14e>
  if(unlink("dots") != 0){
    3eea:	00004517          	auipc	a0,0x4
    3eee:	aa650513          	addi	a0,a0,-1370 # 7990 <malloc+0x19de>
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	cf0080e7          	jalr	-784(ra) # 5be2 <unlink>
    3efa:	e961                	bnez	a0,3fca <rmdot+0x16a>
}
    3efc:	60e2                	ld	ra,24(sp)
    3efe:	6442                	ld	s0,16(sp)
    3f00:	64a2                	ld	s1,8(sp)
    3f02:	6105                	addi	sp,sp,32
    3f04:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f06:	85a6                	mv	a1,s1
    3f08:	00004517          	auipc	a0,0x4
    3f0c:	a9050513          	addi	a0,a0,-1392 # 7998 <malloc+0x19e6>
    3f10:	00002097          	auipc	ra,0x2
    3f14:	fea080e7          	jalr	-22(ra) # 5efa <printf>
    exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	c78080e7          	jalr	-904(ra) # 5b92 <exit>
    printf("%s: chdir dots failed\n", s);
    3f22:	85a6                	mv	a1,s1
    3f24:	00004517          	auipc	a0,0x4
    3f28:	a8c50513          	addi	a0,a0,-1396 # 79b0 <malloc+0x19fe>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	fce080e7          	jalr	-50(ra) # 5efa <printf>
    exit(1);
    3f34:	4505                	li	a0,1
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	c5c080e7          	jalr	-932(ra) # 5b92 <exit>
    printf("%s: rm . worked!\n", s);
    3f3e:	85a6                	mv	a1,s1
    3f40:	00004517          	auipc	a0,0x4
    3f44:	a8850513          	addi	a0,a0,-1400 # 79c8 <malloc+0x1a16>
    3f48:	00002097          	auipc	ra,0x2
    3f4c:	fb2080e7          	jalr	-78(ra) # 5efa <printf>
    exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	c40080e7          	jalr	-960(ra) # 5b92 <exit>
    printf("%s: rm .. worked!\n", s);
    3f5a:	85a6                	mv	a1,s1
    3f5c:	00004517          	auipc	a0,0x4
    3f60:	a8450513          	addi	a0,a0,-1404 # 79e0 <malloc+0x1a2e>
    3f64:	00002097          	auipc	ra,0x2
    3f68:	f96080e7          	jalr	-106(ra) # 5efa <printf>
    exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	00002097          	auipc	ra,0x2
    3f72:	c24080e7          	jalr	-988(ra) # 5b92 <exit>
    printf("%s: chdir / failed\n", s);
    3f76:	85a6                	mv	a1,s1
    3f78:	00003517          	auipc	a0,0x3
    3f7c:	42050513          	addi	a0,a0,1056 # 7398 <malloc+0x13e6>
    3f80:	00002097          	auipc	ra,0x2
    3f84:	f7a080e7          	jalr	-134(ra) # 5efa <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	00002097          	auipc	ra,0x2
    3f8e:	c08080e7          	jalr	-1016(ra) # 5b92 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f92:	85a6                	mv	a1,s1
    3f94:	00004517          	auipc	a0,0x4
    3f98:	a6c50513          	addi	a0,a0,-1428 # 7a00 <malloc+0x1a4e>
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	f5e080e7          	jalr	-162(ra) # 5efa <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	bec080e7          	jalr	-1044(ra) # 5b92 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fae:	85a6                	mv	a1,s1
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	a7850513          	addi	a0,a0,-1416 # 7a28 <malloc+0x1a76>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	f42080e7          	jalr	-190(ra) # 5efa <printf>
    exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	bd0080e7          	jalr	-1072(ra) # 5b92 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fca:	85a6                	mv	a1,s1
    3fcc:	00004517          	auipc	a0,0x4
    3fd0:	a7c50513          	addi	a0,a0,-1412 # 7a48 <malloc+0x1a96>
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	f26080e7          	jalr	-218(ra) # 5efa <printf>
    exit(1);
    3fdc:	4505                	li	a0,1
    3fde:	00002097          	auipc	ra,0x2
    3fe2:	bb4080e7          	jalr	-1100(ra) # 5b92 <exit>

0000000000003fe6 <dirfile>:
{
    3fe6:	1101                	addi	sp,sp,-32
    3fe8:	ec06                	sd	ra,24(sp)
    3fea:	e822                	sd	s0,16(sp)
    3fec:	e426                	sd	s1,8(sp)
    3fee:	e04a                	sd	s2,0(sp)
    3ff0:	1000                	addi	s0,sp,32
    3ff2:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ff4:	20000593          	li	a1,512
    3ff8:	00004517          	auipc	a0,0x4
    3ffc:	a7050513          	addi	a0,a0,-1424 # 7a68 <malloc+0x1ab6>
    4000:	00002097          	auipc	ra,0x2
    4004:	bd2080e7          	jalr	-1070(ra) # 5bd2 <open>
  if(fd < 0){
    4008:	0e054d63          	bltz	a0,4102 <dirfile+0x11c>
  close(fd);
    400c:	00002097          	auipc	ra,0x2
    4010:	bae080e7          	jalr	-1106(ra) # 5bba <close>
  if(chdir("dirfile") == 0){
    4014:	00004517          	auipc	a0,0x4
    4018:	a5450513          	addi	a0,a0,-1452 # 7a68 <malloc+0x1ab6>
    401c:	00002097          	auipc	ra,0x2
    4020:	be6080e7          	jalr	-1050(ra) # 5c02 <chdir>
    4024:	cd6d                	beqz	a0,411e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4026:	4581                	li	a1,0
    4028:	00004517          	auipc	a0,0x4
    402c:	a8850513          	addi	a0,a0,-1400 # 7ab0 <malloc+0x1afe>
    4030:	00002097          	auipc	ra,0x2
    4034:	ba2080e7          	jalr	-1118(ra) # 5bd2 <open>
  if(fd >= 0){
    4038:	10055163          	bgez	a0,413a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    403c:	20000593          	li	a1,512
    4040:	00004517          	auipc	a0,0x4
    4044:	a7050513          	addi	a0,a0,-1424 # 7ab0 <malloc+0x1afe>
    4048:	00002097          	auipc	ra,0x2
    404c:	b8a080e7          	jalr	-1142(ra) # 5bd2 <open>
  if(fd >= 0){
    4050:	10055363          	bgez	a0,4156 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4054:	00004517          	auipc	a0,0x4
    4058:	a5c50513          	addi	a0,a0,-1444 # 7ab0 <malloc+0x1afe>
    405c:	00002097          	auipc	ra,0x2
    4060:	b9e080e7          	jalr	-1122(ra) # 5bfa <mkdir>
    4064:	10050763          	beqz	a0,4172 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4068:	00004517          	auipc	a0,0x4
    406c:	a4850513          	addi	a0,a0,-1464 # 7ab0 <malloc+0x1afe>
    4070:	00002097          	auipc	ra,0x2
    4074:	b72080e7          	jalr	-1166(ra) # 5be2 <unlink>
    4078:	10050b63          	beqz	a0,418e <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    407c:	00004597          	auipc	a1,0x4
    4080:	a3458593          	addi	a1,a1,-1484 # 7ab0 <malloc+0x1afe>
    4084:	00002517          	auipc	a0,0x2
    4088:	22c50513          	addi	a0,a0,556 # 62b0 <malloc+0x2fe>
    408c:	00002097          	auipc	ra,0x2
    4090:	b66080e7          	jalr	-1178(ra) # 5bf2 <link>
    4094:	10050b63          	beqz	a0,41aa <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4098:	00004517          	auipc	a0,0x4
    409c:	9d050513          	addi	a0,a0,-1584 # 7a68 <malloc+0x1ab6>
    40a0:	00002097          	auipc	ra,0x2
    40a4:	b42080e7          	jalr	-1214(ra) # 5be2 <unlink>
    40a8:	10051f63          	bnez	a0,41c6 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40ac:	4589                	li	a1,2
    40ae:	00002517          	auipc	a0,0x2
    40b2:	71250513          	addi	a0,a0,1810 # 67c0 <malloc+0x80e>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	b1c080e7          	jalr	-1252(ra) # 5bd2 <open>
  if(fd >= 0){
    40be:	12055263          	bgez	a0,41e2 <dirfile+0x1fc>
  fd = open(".", 0);
    40c2:	4581                	li	a1,0
    40c4:	00002517          	auipc	a0,0x2
    40c8:	6fc50513          	addi	a0,a0,1788 # 67c0 <malloc+0x80e>
    40cc:	00002097          	auipc	ra,0x2
    40d0:	b06080e7          	jalr	-1274(ra) # 5bd2 <open>
    40d4:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40d6:	4605                	li	a2,1
    40d8:	00002597          	auipc	a1,0x2
    40dc:	07058593          	addi	a1,a1,112 # 6148 <malloc+0x196>
    40e0:	00002097          	auipc	ra,0x2
    40e4:	ad2080e7          	jalr	-1326(ra) # 5bb2 <write>
    40e8:	10a04b63          	bgtz	a0,41fe <dirfile+0x218>
  close(fd);
    40ec:	8526                	mv	a0,s1
    40ee:	00002097          	auipc	ra,0x2
    40f2:	acc080e7          	jalr	-1332(ra) # 5bba <close>
}
    40f6:	60e2                	ld	ra,24(sp)
    40f8:	6442                	ld	s0,16(sp)
    40fa:	64a2                	ld	s1,8(sp)
    40fc:	6902                	ld	s2,0(sp)
    40fe:	6105                	addi	sp,sp,32
    4100:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4102:	85ca                	mv	a1,s2
    4104:	00004517          	auipc	a0,0x4
    4108:	96c50513          	addi	a0,a0,-1684 # 7a70 <malloc+0x1abe>
    410c:	00002097          	auipc	ra,0x2
    4110:	dee080e7          	jalr	-530(ra) # 5efa <printf>
    exit(1);
    4114:	4505                	li	a0,1
    4116:	00002097          	auipc	ra,0x2
    411a:	a7c080e7          	jalr	-1412(ra) # 5b92 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    411e:	85ca                	mv	a1,s2
    4120:	00004517          	auipc	a0,0x4
    4124:	97050513          	addi	a0,a0,-1680 # 7a90 <malloc+0x1ade>
    4128:	00002097          	auipc	ra,0x2
    412c:	dd2080e7          	jalr	-558(ra) # 5efa <printf>
    exit(1);
    4130:	4505                	li	a0,1
    4132:	00002097          	auipc	ra,0x2
    4136:	a60080e7          	jalr	-1440(ra) # 5b92 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    413a:	85ca                	mv	a1,s2
    413c:	00004517          	auipc	a0,0x4
    4140:	98450513          	addi	a0,a0,-1660 # 7ac0 <malloc+0x1b0e>
    4144:	00002097          	auipc	ra,0x2
    4148:	db6080e7          	jalr	-586(ra) # 5efa <printf>
    exit(1);
    414c:	4505                	li	a0,1
    414e:	00002097          	auipc	ra,0x2
    4152:	a44080e7          	jalr	-1468(ra) # 5b92 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4156:	85ca                	mv	a1,s2
    4158:	00004517          	auipc	a0,0x4
    415c:	96850513          	addi	a0,a0,-1688 # 7ac0 <malloc+0x1b0e>
    4160:	00002097          	auipc	ra,0x2
    4164:	d9a080e7          	jalr	-614(ra) # 5efa <printf>
    exit(1);
    4168:	4505                	li	a0,1
    416a:	00002097          	auipc	ra,0x2
    416e:	a28080e7          	jalr	-1496(ra) # 5b92 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4172:	85ca                	mv	a1,s2
    4174:	00004517          	auipc	a0,0x4
    4178:	97450513          	addi	a0,a0,-1676 # 7ae8 <malloc+0x1b36>
    417c:	00002097          	auipc	ra,0x2
    4180:	d7e080e7          	jalr	-642(ra) # 5efa <printf>
    exit(1);
    4184:	4505                	li	a0,1
    4186:	00002097          	auipc	ra,0x2
    418a:	a0c080e7          	jalr	-1524(ra) # 5b92 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    418e:	85ca                	mv	a1,s2
    4190:	00004517          	auipc	a0,0x4
    4194:	98050513          	addi	a0,a0,-1664 # 7b10 <malloc+0x1b5e>
    4198:	00002097          	auipc	ra,0x2
    419c:	d62080e7          	jalr	-670(ra) # 5efa <printf>
    exit(1);
    41a0:	4505                	li	a0,1
    41a2:	00002097          	auipc	ra,0x2
    41a6:	9f0080e7          	jalr	-1552(ra) # 5b92 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41aa:	85ca                	mv	a1,s2
    41ac:	00004517          	auipc	a0,0x4
    41b0:	98c50513          	addi	a0,a0,-1652 # 7b38 <malloc+0x1b86>
    41b4:	00002097          	auipc	ra,0x2
    41b8:	d46080e7          	jalr	-698(ra) # 5efa <printf>
    exit(1);
    41bc:	4505                	li	a0,1
    41be:	00002097          	auipc	ra,0x2
    41c2:	9d4080e7          	jalr	-1580(ra) # 5b92 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41c6:	85ca                	mv	a1,s2
    41c8:	00004517          	auipc	a0,0x4
    41cc:	99850513          	addi	a0,a0,-1640 # 7b60 <malloc+0x1bae>
    41d0:	00002097          	auipc	ra,0x2
    41d4:	d2a080e7          	jalr	-726(ra) # 5efa <printf>
    exit(1);
    41d8:	4505                	li	a0,1
    41da:	00002097          	auipc	ra,0x2
    41de:	9b8080e7          	jalr	-1608(ra) # 5b92 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41e2:	85ca                	mv	a1,s2
    41e4:	00004517          	auipc	a0,0x4
    41e8:	99c50513          	addi	a0,a0,-1636 # 7b80 <malloc+0x1bce>
    41ec:	00002097          	auipc	ra,0x2
    41f0:	d0e080e7          	jalr	-754(ra) # 5efa <printf>
    exit(1);
    41f4:	4505                	li	a0,1
    41f6:	00002097          	auipc	ra,0x2
    41fa:	99c080e7          	jalr	-1636(ra) # 5b92 <exit>
    printf("%s: write . succeeded!\n", s);
    41fe:	85ca                	mv	a1,s2
    4200:	00004517          	auipc	a0,0x4
    4204:	9a850513          	addi	a0,a0,-1624 # 7ba8 <malloc+0x1bf6>
    4208:	00002097          	auipc	ra,0x2
    420c:	cf2080e7          	jalr	-782(ra) # 5efa <printf>
    exit(1);
    4210:	4505                	li	a0,1
    4212:	00002097          	auipc	ra,0x2
    4216:	980080e7          	jalr	-1664(ra) # 5b92 <exit>

000000000000421a <iref>:
{
    421a:	7139                	addi	sp,sp,-64
    421c:	fc06                	sd	ra,56(sp)
    421e:	f822                	sd	s0,48(sp)
    4220:	f426                	sd	s1,40(sp)
    4222:	f04a                	sd	s2,32(sp)
    4224:	ec4e                	sd	s3,24(sp)
    4226:	e852                	sd	s4,16(sp)
    4228:	e456                	sd	s5,8(sp)
    422a:	e05a                	sd	s6,0(sp)
    422c:	0080                	addi	s0,sp,64
    422e:	8b2a                	mv	s6,a0
    4230:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4234:	00004a17          	auipc	s4,0x4
    4238:	98ca0a13          	addi	s4,s4,-1652 # 7bc0 <malloc+0x1c0e>
    mkdir("");
    423c:	00003497          	auipc	s1,0x3
    4240:	48c48493          	addi	s1,s1,1164 # 76c8 <malloc+0x1716>
    link("README", "");
    4244:	00002a97          	auipc	s5,0x2
    4248:	06ca8a93          	addi	s5,s5,108 # 62b0 <malloc+0x2fe>
    fd = open("xx", O_CREATE);
    424c:	00004997          	auipc	s3,0x4
    4250:	86c98993          	addi	s3,s3,-1940 # 7ab8 <malloc+0x1b06>
    4254:	a891                	j	42a8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4256:	85da                	mv	a1,s6
    4258:	00004517          	auipc	a0,0x4
    425c:	97050513          	addi	a0,a0,-1680 # 7bc8 <malloc+0x1c16>
    4260:	00002097          	auipc	ra,0x2
    4264:	c9a080e7          	jalr	-870(ra) # 5efa <printf>
      exit(1);
    4268:	4505                	li	a0,1
    426a:	00002097          	auipc	ra,0x2
    426e:	928080e7          	jalr	-1752(ra) # 5b92 <exit>
      printf("%s: chdir irefd failed\n", s);
    4272:	85da                	mv	a1,s6
    4274:	00004517          	auipc	a0,0x4
    4278:	96c50513          	addi	a0,a0,-1684 # 7be0 <malloc+0x1c2e>
    427c:	00002097          	auipc	ra,0x2
    4280:	c7e080e7          	jalr	-898(ra) # 5efa <printf>
      exit(1);
    4284:	4505                	li	a0,1
    4286:	00002097          	auipc	ra,0x2
    428a:	90c080e7          	jalr	-1780(ra) # 5b92 <exit>
      close(fd);
    428e:	00002097          	auipc	ra,0x2
    4292:	92c080e7          	jalr	-1748(ra) # 5bba <close>
    4296:	a889                	j	42e8 <iref+0xce>
    unlink("xx");
    4298:	854e                	mv	a0,s3
    429a:	00002097          	auipc	ra,0x2
    429e:	948080e7          	jalr	-1720(ra) # 5be2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42a2:	397d                	addiw	s2,s2,-1
    42a4:	06090063          	beqz	s2,4304 <iref+0xea>
    if(mkdir("irefd") != 0){
    42a8:	8552                	mv	a0,s4
    42aa:	00002097          	auipc	ra,0x2
    42ae:	950080e7          	jalr	-1712(ra) # 5bfa <mkdir>
    42b2:	f155                	bnez	a0,4256 <iref+0x3c>
    if(chdir("irefd") != 0){
    42b4:	8552                	mv	a0,s4
    42b6:	00002097          	auipc	ra,0x2
    42ba:	94c080e7          	jalr	-1716(ra) # 5c02 <chdir>
    42be:	f955                	bnez	a0,4272 <iref+0x58>
    mkdir("");
    42c0:	8526                	mv	a0,s1
    42c2:	00002097          	auipc	ra,0x2
    42c6:	938080e7          	jalr	-1736(ra) # 5bfa <mkdir>
    link("README", "");
    42ca:	85a6                	mv	a1,s1
    42cc:	8556                	mv	a0,s5
    42ce:	00002097          	auipc	ra,0x2
    42d2:	924080e7          	jalr	-1756(ra) # 5bf2 <link>
    fd = open("", O_CREATE);
    42d6:	20000593          	li	a1,512
    42da:	8526                	mv	a0,s1
    42dc:	00002097          	auipc	ra,0x2
    42e0:	8f6080e7          	jalr	-1802(ra) # 5bd2 <open>
    if(fd >= 0)
    42e4:	fa0555e3          	bgez	a0,428e <iref+0x74>
    fd = open("xx", O_CREATE);
    42e8:	20000593          	li	a1,512
    42ec:	854e                	mv	a0,s3
    42ee:	00002097          	auipc	ra,0x2
    42f2:	8e4080e7          	jalr	-1820(ra) # 5bd2 <open>
    if(fd >= 0)
    42f6:	fa0541e3          	bltz	a0,4298 <iref+0x7e>
      close(fd);
    42fa:	00002097          	auipc	ra,0x2
    42fe:	8c0080e7          	jalr	-1856(ra) # 5bba <close>
    4302:	bf59                	j	4298 <iref+0x7e>
    4304:	03300493          	li	s1,51
    chdir("..");
    4308:	00003997          	auipc	s3,0x3
    430c:	0e098993          	addi	s3,s3,224 # 73e8 <malloc+0x1436>
    unlink("irefd");
    4310:	00004917          	auipc	s2,0x4
    4314:	8b090913          	addi	s2,s2,-1872 # 7bc0 <malloc+0x1c0e>
    chdir("..");
    4318:	854e                	mv	a0,s3
    431a:	00002097          	auipc	ra,0x2
    431e:	8e8080e7          	jalr	-1816(ra) # 5c02 <chdir>
    unlink("irefd");
    4322:	854a                	mv	a0,s2
    4324:	00002097          	auipc	ra,0x2
    4328:	8be080e7          	jalr	-1858(ra) # 5be2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    432c:	34fd                	addiw	s1,s1,-1
    432e:	f4ed                	bnez	s1,4318 <iref+0xfe>
  chdir("/");
    4330:	00003517          	auipc	a0,0x3
    4334:	06050513          	addi	a0,a0,96 # 7390 <malloc+0x13de>
    4338:	00002097          	auipc	ra,0x2
    433c:	8ca080e7          	jalr	-1846(ra) # 5c02 <chdir>
}
    4340:	70e2                	ld	ra,56(sp)
    4342:	7442                	ld	s0,48(sp)
    4344:	74a2                	ld	s1,40(sp)
    4346:	7902                	ld	s2,32(sp)
    4348:	69e2                	ld	s3,24(sp)
    434a:	6a42                	ld	s4,16(sp)
    434c:	6aa2                	ld	s5,8(sp)
    434e:	6b02                	ld	s6,0(sp)
    4350:	6121                	addi	sp,sp,64
    4352:	8082                	ret

0000000000004354 <openiputtest>:
{
    4354:	7179                	addi	sp,sp,-48
    4356:	f406                	sd	ra,40(sp)
    4358:	f022                	sd	s0,32(sp)
    435a:	ec26                	sd	s1,24(sp)
    435c:	1800                	addi	s0,sp,48
    435e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4360:	00004517          	auipc	a0,0x4
    4364:	89850513          	addi	a0,a0,-1896 # 7bf8 <malloc+0x1c46>
    4368:	00002097          	auipc	ra,0x2
    436c:	892080e7          	jalr	-1902(ra) # 5bfa <mkdir>
    4370:	04054263          	bltz	a0,43b4 <openiputtest+0x60>
  pid = fork();
    4374:	00002097          	auipc	ra,0x2
    4378:	816080e7          	jalr	-2026(ra) # 5b8a <fork>
  if(pid < 0){
    437c:	04054a63          	bltz	a0,43d0 <openiputtest+0x7c>
  if(pid == 0){
    4380:	e93d                	bnez	a0,43f6 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4382:	4589                	li	a1,2
    4384:	00004517          	auipc	a0,0x4
    4388:	87450513          	addi	a0,a0,-1932 # 7bf8 <malloc+0x1c46>
    438c:	00002097          	auipc	ra,0x2
    4390:	846080e7          	jalr	-1978(ra) # 5bd2 <open>
    if(fd >= 0){
    4394:	04054c63          	bltz	a0,43ec <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    4398:	85a6                	mv	a1,s1
    439a:	00004517          	auipc	a0,0x4
    439e:	87e50513          	addi	a0,a0,-1922 # 7c18 <malloc+0x1c66>
    43a2:	00002097          	auipc	ra,0x2
    43a6:	b58080e7          	jalr	-1192(ra) # 5efa <printf>
      exit(1);
    43aa:	4505                	li	a0,1
    43ac:	00001097          	auipc	ra,0x1
    43b0:	7e6080e7          	jalr	2022(ra) # 5b92 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43b4:	85a6                	mv	a1,s1
    43b6:	00004517          	auipc	a0,0x4
    43ba:	84a50513          	addi	a0,a0,-1974 # 7c00 <malloc+0x1c4e>
    43be:	00002097          	auipc	ra,0x2
    43c2:	b3c080e7          	jalr	-1220(ra) # 5efa <printf>
    exit(1);
    43c6:	4505                	li	a0,1
    43c8:	00001097          	auipc	ra,0x1
    43cc:	7ca080e7          	jalr	1994(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    43d0:	85a6                	mv	a1,s1
    43d2:	00002517          	auipc	a0,0x2
    43d6:	58e50513          	addi	a0,a0,1422 # 6960 <malloc+0x9ae>
    43da:	00002097          	auipc	ra,0x2
    43de:	b20080e7          	jalr	-1248(ra) # 5efa <printf>
    exit(1);
    43e2:	4505                	li	a0,1
    43e4:	00001097          	auipc	ra,0x1
    43e8:	7ae080e7          	jalr	1966(ra) # 5b92 <exit>
    exit(0);
    43ec:	4501                	li	a0,0
    43ee:	00001097          	auipc	ra,0x1
    43f2:	7a4080e7          	jalr	1956(ra) # 5b92 <exit>
  sleep(1);
    43f6:	4505                	li	a0,1
    43f8:	00002097          	auipc	ra,0x2
    43fc:	82a080e7          	jalr	-2006(ra) # 5c22 <sleep>
  if(unlink("oidir") != 0){
    4400:	00003517          	auipc	a0,0x3
    4404:	7f850513          	addi	a0,a0,2040 # 7bf8 <malloc+0x1c46>
    4408:	00001097          	auipc	ra,0x1
    440c:	7da080e7          	jalr	2010(ra) # 5be2 <unlink>
    4410:	cd19                	beqz	a0,442e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4412:	85a6                	mv	a1,s1
    4414:	00002517          	auipc	a0,0x2
    4418:	73c50513          	addi	a0,a0,1852 # 6b50 <malloc+0xb9e>
    441c:	00002097          	auipc	ra,0x2
    4420:	ade080e7          	jalr	-1314(ra) # 5efa <printf>
    exit(1);
    4424:	4505                	li	a0,1
    4426:	00001097          	auipc	ra,0x1
    442a:	76c080e7          	jalr	1900(ra) # 5b92 <exit>
  wait(&xstatus);
    442e:	fdc40513          	addi	a0,s0,-36
    4432:	00001097          	auipc	ra,0x1
    4436:	768080e7          	jalr	1896(ra) # 5b9a <wait>
  exit(xstatus);
    443a:	fdc42503          	lw	a0,-36(s0)
    443e:	00001097          	auipc	ra,0x1
    4442:	754080e7          	jalr	1876(ra) # 5b92 <exit>

0000000000004446 <forkforkfork>:
{
    4446:	1101                	addi	sp,sp,-32
    4448:	ec06                	sd	ra,24(sp)
    444a:	e822                	sd	s0,16(sp)
    444c:	e426                	sd	s1,8(sp)
    444e:	1000                	addi	s0,sp,32
    4450:	84aa                	mv	s1,a0
  unlink("stopforking");
    4452:	00003517          	auipc	a0,0x3
    4456:	7ee50513          	addi	a0,a0,2030 # 7c40 <malloc+0x1c8e>
    445a:	00001097          	auipc	ra,0x1
    445e:	788080e7          	jalr	1928(ra) # 5be2 <unlink>
  int pid = fork();
    4462:	00001097          	auipc	ra,0x1
    4466:	728080e7          	jalr	1832(ra) # 5b8a <fork>
  if(pid < 0){
    446a:	04054563          	bltz	a0,44b4 <forkforkfork+0x6e>
  if(pid == 0){
    446e:	c12d                	beqz	a0,44d0 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4470:	4551                	li	a0,20
    4472:	00001097          	auipc	ra,0x1
    4476:	7b0080e7          	jalr	1968(ra) # 5c22 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    447a:	20200593          	li	a1,514
    447e:	00003517          	auipc	a0,0x3
    4482:	7c250513          	addi	a0,a0,1986 # 7c40 <malloc+0x1c8e>
    4486:	00001097          	auipc	ra,0x1
    448a:	74c080e7          	jalr	1868(ra) # 5bd2 <open>
    448e:	00001097          	auipc	ra,0x1
    4492:	72c080e7          	jalr	1836(ra) # 5bba <close>
  wait(0);
    4496:	4501                	li	a0,0
    4498:	00001097          	auipc	ra,0x1
    449c:	702080e7          	jalr	1794(ra) # 5b9a <wait>
  sleep(10); // one second
    44a0:	4529                	li	a0,10
    44a2:	00001097          	auipc	ra,0x1
    44a6:	780080e7          	jalr	1920(ra) # 5c22 <sleep>
}
    44aa:	60e2                	ld	ra,24(sp)
    44ac:	6442                	ld	s0,16(sp)
    44ae:	64a2                	ld	s1,8(sp)
    44b0:	6105                	addi	sp,sp,32
    44b2:	8082                	ret
    printf("%s: fork failed", s);
    44b4:	85a6                	mv	a1,s1
    44b6:	00002517          	auipc	a0,0x2
    44ba:	66a50513          	addi	a0,a0,1642 # 6b20 <malloc+0xb6e>
    44be:	00002097          	auipc	ra,0x2
    44c2:	a3c080e7          	jalr	-1476(ra) # 5efa <printf>
    exit(1);
    44c6:	4505                	li	a0,1
    44c8:	00001097          	auipc	ra,0x1
    44cc:	6ca080e7          	jalr	1738(ra) # 5b92 <exit>
      int fd = open("stopforking", 0);
    44d0:	00003497          	auipc	s1,0x3
    44d4:	77048493          	addi	s1,s1,1904 # 7c40 <malloc+0x1c8e>
    44d8:	4581                	li	a1,0
    44da:	8526                	mv	a0,s1
    44dc:	00001097          	auipc	ra,0x1
    44e0:	6f6080e7          	jalr	1782(ra) # 5bd2 <open>
      if(fd >= 0){
    44e4:	02055763          	bgez	a0,4512 <forkforkfork+0xcc>
      if(fork() < 0){
    44e8:	00001097          	auipc	ra,0x1
    44ec:	6a2080e7          	jalr	1698(ra) # 5b8a <fork>
    44f0:	fe0554e3          	bgez	a0,44d8 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44f4:	20200593          	li	a1,514
    44f8:	00003517          	auipc	a0,0x3
    44fc:	74850513          	addi	a0,a0,1864 # 7c40 <malloc+0x1c8e>
    4500:	00001097          	auipc	ra,0x1
    4504:	6d2080e7          	jalr	1746(ra) # 5bd2 <open>
    4508:	00001097          	auipc	ra,0x1
    450c:	6b2080e7          	jalr	1714(ra) # 5bba <close>
    4510:	b7e1                	j	44d8 <forkforkfork+0x92>
        exit(0);
    4512:	4501                	li	a0,0
    4514:	00001097          	auipc	ra,0x1
    4518:	67e080e7          	jalr	1662(ra) # 5b92 <exit>

000000000000451c <killstatus>:
{
    451c:	7139                	addi	sp,sp,-64
    451e:	fc06                	sd	ra,56(sp)
    4520:	f822                	sd	s0,48(sp)
    4522:	f426                	sd	s1,40(sp)
    4524:	f04a                	sd	s2,32(sp)
    4526:	ec4e                	sd	s3,24(sp)
    4528:	e852                	sd	s4,16(sp)
    452a:	0080                	addi	s0,sp,64
    452c:	8a2a                	mv	s4,a0
    452e:	06400913          	li	s2,100
    if(xst != -1) {
    4532:	59fd                	li	s3,-1
    int pid1 = fork();
    4534:	00001097          	auipc	ra,0x1
    4538:	656080e7          	jalr	1622(ra) # 5b8a <fork>
    453c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    453e:	02054f63          	bltz	a0,457c <killstatus+0x60>
    if(pid1 == 0){
    4542:	c939                	beqz	a0,4598 <killstatus+0x7c>
    sleep(1);
    4544:	4505                	li	a0,1
    4546:	00001097          	auipc	ra,0x1
    454a:	6dc080e7          	jalr	1756(ra) # 5c22 <sleep>
    kill(pid1);
    454e:	8526                	mv	a0,s1
    4550:	00001097          	auipc	ra,0x1
    4554:	672080e7          	jalr	1650(ra) # 5bc2 <kill>
    wait(&xst);
    4558:	fcc40513          	addi	a0,s0,-52
    455c:	00001097          	auipc	ra,0x1
    4560:	63e080e7          	jalr	1598(ra) # 5b9a <wait>
    if(xst != -1) {
    4564:	fcc42783          	lw	a5,-52(s0)
    4568:	03379d63          	bne	a5,s3,45a2 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    456c:	397d                	addiw	s2,s2,-1
    456e:	fc0913e3          	bnez	s2,4534 <killstatus+0x18>
  exit(0);
    4572:	4501                	li	a0,0
    4574:	00001097          	auipc	ra,0x1
    4578:	61e080e7          	jalr	1566(ra) # 5b92 <exit>
      printf("%s: fork failed\n", s);
    457c:	85d2                	mv	a1,s4
    457e:	00002517          	auipc	a0,0x2
    4582:	3e250513          	addi	a0,a0,994 # 6960 <malloc+0x9ae>
    4586:	00002097          	auipc	ra,0x2
    458a:	974080e7          	jalr	-1676(ra) # 5efa <printf>
      exit(1);
    458e:	4505                	li	a0,1
    4590:	00001097          	auipc	ra,0x1
    4594:	602080e7          	jalr	1538(ra) # 5b92 <exit>
        getpid();
    4598:	00001097          	auipc	ra,0x1
    459c:	67a080e7          	jalr	1658(ra) # 5c12 <getpid>
      while(1) {
    45a0:	bfe5                	j	4598 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45a2:	85d2                	mv	a1,s4
    45a4:	00003517          	auipc	a0,0x3
    45a8:	6ac50513          	addi	a0,a0,1708 # 7c50 <malloc+0x1c9e>
    45ac:	00002097          	auipc	ra,0x2
    45b0:	94e080e7          	jalr	-1714(ra) # 5efa <printf>
       exit(1);
    45b4:	4505                	li	a0,1
    45b6:	00001097          	auipc	ra,0x1
    45ba:	5dc080e7          	jalr	1500(ra) # 5b92 <exit>

00000000000045be <preempt>:
{
    45be:	7139                	addi	sp,sp,-64
    45c0:	fc06                	sd	ra,56(sp)
    45c2:	f822                	sd	s0,48(sp)
    45c4:	f426                	sd	s1,40(sp)
    45c6:	f04a                	sd	s2,32(sp)
    45c8:	ec4e                	sd	s3,24(sp)
    45ca:	e852                	sd	s4,16(sp)
    45cc:	0080                	addi	s0,sp,64
    45ce:	892a                	mv	s2,a0
  pid1 = fork();
    45d0:	00001097          	auipc	ra,0x1
    45d4:	5ba080e7          	jalr	1466(ra) # 5b8a <fork>
  if(pid1 < 0) {
    45d8:	00054563          	bltz	a0,45e2 <preempt+0x24>
    45dc:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45de:	e105                	bnez	a0,45fe <preempt+0x40>
    for(;;)
    45e0:	a001                	j	45e0 <preempt+0x22>
    printf("%s: fork failed", s);
    45e2:	85ca                	mv	a1,s2
    45e4:	00002517          	auipc	a0,0x2
    45e8:	53c50513          	addi	a0,a0,1340 # 6b20 <malloc+0xb6e>
    45ec:	00002097          	auipc	ra,0x2
    45f0:	90e080e7          	jalr	-1778(ra) # 5efa <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	00001097          	auipc	ra,0x1
    45fa:	59c080e7          	jalr	1436(ra) # 5b92 <exit>
  pid2 = fork();
    45fe:	00001097          	auipc	ra,0x1
    4602:	58c080e7          	jalr	1420(ra) # 5b8a <fork>
    4606:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4608:	00054463          	bltz	a0,4610 <preempt+0x52>
  if(pid2 == 0)
    460c:	e105                	bnez	a0,462c <preempt+0x6e>
    for(;;)
    460e:	a001                	j	460e <preempt+0x50>
    printf("%s: fork failed\n", s);
    4610:	85ca                	mv	a1,s2
    4612:	00002517          	auipc	a0,0x2
    4616:	34e50513          	addi	a0,a0,846 # 6960 <malloc+0x9ae>
    461a:	00002097          	auipc	ra,0x2
    461e:	8e0080e7          	jalr	-1824(ra) # 5efa <printf>
    exit(1);
    4622:	4505                	li	a0,1
    4624:	00001097          	auipc	ra,0x1
    4628:	56e080e7          	jalr	1390(ra) # 5b92 <exit>
  pipe(pfds);
    462c:	fc840513          	addi	a0,s0,-56
    4630:	00001097          	auipc	ra,0x1
    4634:	572080e7          	jalr	1394(ra) # 5ba2 <pipe>
  pid3 = fork();
    4638:	00001097          	auipc	ra,0x1
    463c:	552080e7          	jalr	1362(ra) # 5b8a <fork>
    4640:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4642:	02054e63          	bltz	a0,467e <preempt+0xc0>
  if(pid3 == 0){
    4646:	e525                	bnez	a0,46ae <preempt+0xf0>
    close(pfds[0]);
    4648:	fc842503          	lw	a0,-56(s0)
    464c:	00001097          	auipc	ra,0x1
    4650:	56e080e7          	jalr	1390(ra) # 5bba <close>
    if(write(pfds[1], "x", 1) != 1)
    4654:	4605                	li	a2,1
    4656:	00002597          	auipc	a1,0x2
    465a:	af258593          	addi	a1,a1,-1294 # 6148 <malloc+0x196>
    465e:	fcc42503          	lw	a0,-52(s0)
    4662:	00001097          	auipc	ra,0x1
    4666:	550080e7          	jalr	1360(ra) # 5bb2 <write>
    466a:	4785                	li	a5,1
    466c:	02f51763          	bne	a0,a5,469a <preempt+0xdc>
    close(pfds[1]);
    4670:	fcc42503          	lw	a0,-52(s0)
    4674:	00001097          	auipc	ra,0x1
    4678:	546080e7          	jalr	1350(ra) # 5bba <close>
    for(;;)
    467c:	a001                	j	467c <preempt+0xbe>
     printf("%s: fork failed\n", s);
    467e:	85ca                	mv	a1,s2
    4680:	00002517          	auipc	a0,0x2
    4684:	2e050513          	addi	a0,a0,736 # 6960 <malloc+0x9ae>
    4688:	00002097          	auipc	ra,0x2
    468c:	872080e7          	jalr	-1934(ra) # 5efa <printf>
     exit(1);
    4690:	4505                	li	a0,1
    4692:	00001097          	auipc	ra,0x1
    4696:	500080e7          	jalr	1280(ra) # 5b92 <exit>
      printf("%s: preempt write error", s);
    469a:	85ca                	mv	a1,s2
    469c:	00003517          	auipc	a0,0x3
    46a0:	5d450513          	addi	a0,a0,1492 # 7c70 <malloc+0x1cbe>
    46a4:	00002097          	auipc	ra,0x2
    46a8:	856080e7          	jalr	-1962(ra) # 5efa <printf>
    46ac:	b7d1                	j	4670 <preempt+0xb2>
  close(pfds[1]);
    46ae:	fcc42503          	lw	a0,-52(s0)
    46b2:	00001097          	auipc	ra,0x1
    46b6:	508080e7          	jalr	1288(ra) # 5bba <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46ba:	660d                	lui	a2,0x3
    46bc:	00008597          	auipc	a1,0x8
    46c0:	5bc58593          	addi	a1,a1,1468 # cc78 <buf>
    46c4:	fc842503          	lw	a0,-56(s0)
    46c8:	00001097          	auipc	ra,0x1
    46cc:	4e2080e7          	jalr	1250(ra) # 5baa <read>
    46d0:	4785                	li	a5,1
    46d2:	02f50363          	beq	a0,a5,46f8 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46d6:	85ca                	mv	a1,s2
    46d8:	00003517          	auipc	a0,0x3
    46dc:	5b050513          	addi	a0,a0,1456 # 7c88 <malloc+0x1cd6>
    46e0:	00002097          	auipc	ra,0x2
    46e4:	81a080e7          	jalr	-2022(ra) # 5efa <printf>
}
    46e8:	70e2                	ld	ra,56(sp)
    46ea:	7442                	ld	s0,48(sp)
    46ec:	74a2                	ld	s1,40(sp)
    46ee:	7902                	ld	s2,32(sp)
    46f0:	69e2                	ld	s3,24(sp)
    46f2:	6a42                	ld	s4,16(sp)
    46f4:	6121                	addi	sp,sp,64
    46f6:	8082                	ret
  close(pfds[0]);
    46f8:	fc842503          	lw	a0,-56(s0)
    46fc:	00001097          	auipc	ra,0x1
    4700:	4be080e7          	jalr	1214(ra) # 5bba <close>
  printf("kill... ");
    4704:	00003517          	auipc	a0,0x3
    4708:	59c50513          	addi	a0,a0,1436 # 7ca0 <malloc+0x1cee>
    470c:	00001097          	auipc	ra,0x1
    4710:	7ee080e7          	jalr	2030(ra) # 5efa <printf>
  kill(pid1);
    4714:	8526                	mv	a0,s1
    4716:	00001097          	auipc	ra,0x1
    471a:	4ac080e7          	jalr	1196(ra) # 5bc2 <kill>
  kill(pid2);
    471e:	854e                	mv	a0,s3
    4720:	00001097          	auipc	ra,0x1
    4724:	4a2080e7          	jalr	1186(ra) # 5bc2 <kill>
  kill(pid3);
    4728:	8552                	mv	a0,s4
    472a:	00001097          	auipc	ra,0x1
    472e:	498080e7          	jalr	1176(ra) # 5bc2 <kill>
  printf("wait... ");
    4732:	00003517          	auipc	a0,0x3
    4736:	57e50513          	addi	a0,a0,1406 # 7cb0 <malloc+0x1cfe>
    473a:	00001097          	auipc	ra,0x1
    473e:	7c0080e7          	jalr	1984(ra) # 5efa <printf>
  wait(0);
    4742:	4501                	li	a0,0
    4744:	00001097          	auipc	ra,0x1
    4748:	456080e7          	jalr	1110(ra) # 5b9a <wait>
  wait(0);
    474c:	4501                	li	a0,0
    474e:	00001097          	auipc	ra,0x1
    4752:	44c080e7          	jalr	1100(ra) # 5b9a <wait>
  wait(0);
    4756:	4501                	li	a0,0
    4758:	00001097          	auipc	ra,0x1
    475c:	442080e7          	jalr	1090(ra) # 5b9a <wait>
    4760:	b761                	j	46e8 <preempt+0x12a>

0000000000004762 <reparent>:
{
    4762:	7179                	addi	sp,sp,-48
    4764:	f406                	sd	ra,40(sp)
    4766:	f022                	sd	s0,32(sp)
    4768:	ec26                	sd	s1,24(sp)
    476a:	e84a                	sd	s2,16(sp)
    476c:	e44e                	sd	s3,8(sp)
    476e:	e052                	sd	s4,0(sp)
    4770:	1800                	addi	s0,sp,48
    4772:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4774:	00001097          	auipc	ra,0x1
    4778:	49e080e7          	jalr	1182(ra) # 5c12 <getpid>
    477c:	8a2a                	mv	s4,a0
    477e:	0c800913          	li	s2,200
    int pid = fork();
    4782:	00001097          	auipc	ra,0x1
    4786:	408080e7          	jalr	1032(ra) # 5b8a <fork>
    478a:	84aa                	mv	s1,a0
    if(pid < 0){
    478c:	02054263          	bltz	a0,47b0 <reparent+0x4e>
    if(pid){
    4790:	cd21                	beqz	a0,47e8 <reparent+0x86>
      if(wait(0) != pid){
    4792:	4501                	li	a0,0
    4794:	00001097          	auipc	ra,0x1
    4798:	406080e7          	jalr	1030(ra) # 5b9a <wait>
    479c:	02951863          	bne	a0,s1,47cc <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47a0:	397d                	addiw	s2,s2,-1
    47a2:	fe0910e3          	bnez	s2,4782 <reparent+0x20>
  exit(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	3ea080e7          	jalr	1002(ra) # 5b92 <exit>
      printf("%s: fork failed\n", s);
    47b0:	85ce                	mv	a1,s3
    47b2:	00002517          	auipc	a0,0x2
    47b6:	1ae50513          	addi	a0,a0,430 # 6960 <malloc+0x9ae>
    47ba:	00001097          	auipc	ra,0x1
    47be:	740080e7          	jalr	1856(ra) # 5efa <printf>
      exit(1);
    47c2:	4505                	li	a0,1
    47c4:	00001097          	auipc	ra,0x1
    47c8:	3ce080e7          	jalr	974(ra) # 5b92 <exit>
        printf("%s: wait wrong pid\n", s);
    47cc:	85ce                	mv	a1,s3
    47ce:	00002517          	auipc	a0,0x2
    47d2:	31a50513          	addi	a0,a0,794 # 6ae8 <malloc+0xb36>
    47d6:	00001097          	auipc	ra,0x1
    47da:	724080e7          	jalr	1828(ra) # 5efa <printf>
        exit(1);
    47de:	4505                	li	a0,1
    47e0:	00001097          	auipc	ra,0x1
    47e4:	3b2080e7          	jalr	946(ra) # 5b92 <exit>
      int pid2 = fork();
    47e8:	00001097          	auipc	ra,0x1
    47ec:	3a2080e7          	jalr	930(ra) # 5b8a <fork>
      if(pid2 < 0){
    47f0:	00054763          	bltz	a0,47fe <reparent+0x9c>
      exit(0);
    47f4:	4501                	li	a0,0
    47f6:	00001097          	auipc	ra,0x1
    47fa:	39c080e7          	jalr	924(ra) # 5b92 <exit>
        kill(master_pid);
    47fe:	8552                	mv	a0,s4
    4800:	00001097          	auipc	ra,0x1
    4804:	3c2080e7          	jalr	962(ra) # 5bc2 <kill>
        exit(1);
    4808:	4505                	li	a0,1
    480a:	00001097          	auipc	ra,0x1
    480e:	388080e7          	jalr	904(ra) # 5b92 <exit>

0000000000004812 <sbrkfail>:
{
    4812:	7119                	addi	sp,sp,-128
    4814:	fc86                	sd	ra,120(sp)
    4816:	f8a2                	sd	s0,112(sp)
    4818:	f4a6                	sd	s1,104(sp)
    481a:	f0ca                	sd	s2,96(sp)
    481c:	ecce                	sd	s3,88(sp)
    481e:	e8d2                	sd	s4,80(sp)
    4820:	e4d6                	sd	s5,72(sp)
    4822:	0100                	addi	s0,sp,128
    4824:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4826:	fb040513          	addi	a0,s0,-80
    482a:	00001097          	auipc	ra,0x1
    482e:	378080e7          	jalr	888(ra) # 5ba2 <pipe>
    4832:	e901                	bnez	a0,4842 <sbrkfail+0x30>
    4834:	f8040493          	addi	s1,s0,-128
    4838:	fa840993          	addi	s3,s0,-88
    483c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    483e:	5a7d                	li	s4,-1
    4840:	a085                	j	48a0 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4842:	85d6                	mv	a1,s5
    4844:	00002517          	auipc	a0,0x2
    4848:	22450513          	addi	a0,a0,548 # 6a68 <malloc+0xab6>
    484c:	00001097          	auipc	ra,0x1
    4850:	6ae080e7          	jalr	1710(ra) # 5efa <printf>
    exit(1);
    4854:	4505                	li	a0,1
    4856:	00001097          	auipc	ra,0x1
    485a:	33c080e7          	jalr	828(ra) # 5b92 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    485e:	00001097          	auipc	ra,0x1
    4862:	3bc080e7          	jalr	956(ra) # 5c1a <sbrk>
    4866:	064007b7          	lui	a5,0x6400
    486a:	40a7853b          	subw	a0,a5,a0
    486e:	00001097          	auipc	ra,0x1
    4872:	3ac080e7          	jalr	940(ra) # 5c1a <sbrk>
      write(fds[1], "x", 1);
    4876:	4605                	li	a2,1
    4878:	00002597          	auipc	a1,0x2
    487c:	8d058593          	addi	a1,a1,-1840 # 6148 <malloc+0x196>
    4880:	fb442503          	lw	a0,-76(s0)
    4884:	00001097          	auipc	ra,0x1
    4888:	32e080e7          	jalr	814(ra) # 5bb2 <write>
      for(;;) sleep(1000);
    488c:	3e800513          	li	a0,1000
    4890:	00001097          	auipc	ra,0x1
    4894:	392080e7          	jalr	914(ra) # 5c22 <sleep>
    4898:	bfd5                	j	488c <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    489a:	0911                	addi	s2,s2,4
    489c:	03390563          	beq	s2,s3,48c6 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48a0:	00001097          	auipc	ra,0x1
    48a4:	2ea080e7          	jalr	746(ra) # 5b8a <fork>
    48a8:	00a92023          	sw	a0,0(s2)
    48ac:	d94d                	beqz	a0,485e <sbrkfail+0x4c>
    if(pids[i] != -1)
    48ae:	ff4506e3          	beq	a0,s4,489a <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    48b2:	4605                	li	a2,1
    48b4:	faf40593          	addi	a1,s0,-81
    48b8:	fb042503          	lw	a0,-80(s0)
    48bc:	00001097          	auipc	ra,0x1
    48c0:	2ee080e7          	jalr	750(ra) # 5baa <read>
    48c4:	bfd9                	j	489a <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48c6:	6505                	lui	a0,0x1
    48c8:	00001097          	auipc	ra,0x1
    48cc:	352080e7          	jalr	850(ra) # 5c1a <sbrk>
    48d0:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48d2:	597d                	li	s2,-1
    48d4:	a021                	j	48dc <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48d6:	0491                	addi	s1,s1,4
    48d8:	01348f63          	beq	s1,s3,48f6 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48dc:	4088                	lw	a0,0(s1)
    48de:	ff250ce3          	beq	a0,s2,48d6 <sbrkfail+0xc4>
    kill(pids[i]);
    48e2:	00001097          	auipc	ra,0x1
    48e6:	2e0080e7          	jalr	736(ra) # 5bc2 <kill>
    wait(0);
    48ea:	4501                	li	a0,0
    48ec:	00001097          	auipc	ra,0x1
    48f0:	2ae080e7          	jalr	686(ra) # 5b9a <wait>
    48f4:	b7cd                	j	48d6 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48f6:	57fd                	li	a5,-1
    48f8:	04fa0163          	beq	s4,a5,493a <sbrkfail+0x128>
  pid = fork();
    48fc:	00001097          	auipc	ra,0x1
    4900:	28e080e7          	jalr	654(ra) # 5b8a <fork>
    4904:	84aa                	mv	s1,a0
  if(pid < 0){
    4906:	04054863          	bltz	a0,4956 <sbrkfail+0x144>
  if(pid == 0){
    490a:	c525                	beqz	a0,4972 <sbrkfail+0x160>
  wait(&xstatus);
    490c:	fbc40513          	addi	a0,s0,-68
    4910:	00001097          	auipc	ra,0x1
    4914:	28a080e7          	jalr	650(ra) # 5b9a <wait>
  if(xstatus != -1 && xstatus != 2)
    4918:	fbc42783          	lw	a5,-68(s0)
    491c:	577d                	li	a4,-1
    491e:	00e78563          	beq	a5,a4,4928 <sbrkfail+0x116>
    4922:	4709                	li	a4,2
    4924:	08e79d63          	bne	a5,a4,49be <sbrkfail+0x1ac>
}
    4928:	70e6                	ld	ra,120(sp)
    492a:	7446                	ld	s0,112(sp)
    492c:	74a6                	ld	s1,104(sp)
    492e:	7906                	ld	s2,96(sp)
    4930:	69e6                	ld	s3,88(sp)
    4932:	6a46                	ld	s4,80(sp)
    4934:	6aa6                	ld	s5,72(sp)
    4936:	6109                	addi	sp,sp,128
    4938:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    493a:	85d6                	mv	a1,s5
    493c:	00003517          	auipc	a0,0x3
    4940:	38450513          	addi	a0,a0,900 # 7cc0 <malloc+0x1d0e>
    4944:	00001097          	auipc	ra,0x1
    4948:	5b6080e7          	jalr	1462(ra) # 5efa <printf>
    exit(1);
    494c:	4505                	li	a0,1
    494e:	00001097          	auipc	ra,0x1
    4952:	244080e7          	jalr	580(ra) # 5b92 <exit>
    printf("%s: fork failed\n", s);
    4956:	85d6                	mv	a1,s5
    4958:	00002517          	auipc	a0,0x2
    495c:	00850513          	addi	a0,a0,8 # 6960 <malloc+0x9ae>
    4960:	00001097          	auipc	ra,0x1
    4964:	59a080e7          	jalr	1434(ra) # 5efa <printf>
    exit(1);
    4968:	4505                	li	a0,1
    496a:	00001097          	auipc	ra,0x1
    496e:	228080e7          	jalr	552(ra) # 5b92 <exit>
    a = sbrk(0);
    4972:	4501                	li	a0,0
    4974:	00001097          	auipc	ra,0x1
    4978:	2a6080e7          	jalr	678(ra) # 5c1a <sbrk>
    497c:	892a                	mv	s2,a0
    sbrk(10*BIG);
    497e:	3e800537          	lui	a0,0x3e800
    4982:	00001097          	auipc	ra,0x1
    4986:	298080e7          	jalr	664(ra) # 5c1a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    498a:	87ca                	mv	a5,s2
    498c:	3e800737          	lui	a4,0x3e800
    4990:	993a                	add	s2,s2,a4
    4992:	6705                	lui	a4,0x1
      n += *(a+i);
    4994:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4998:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    499a:	97ba                	add	a5,a5,a4
    499c:	ff279ce3          	bne	a5,s2,4994 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49a0:	8626                	mv	a2,s1
    49a2:	85d6                	mv	a1,s5
    49a4:	00003517          	auipc	a0,0x3
    49a8:	33c50513          	addi	a0,a0,828 # 7ce0 <malloc+0x1d2e>
    49ac:	00001097          	auipc	ra,0x1
    49b0:	54e080e7          	jalr	1358(ra) # 5efa <printf>
    exit(1);
    49b4:	4505                	li	a0,1
    49b6:	00001097          	auipc	ra,0x1
    49ba:	1dc080e7          	jalr	476(ra) # 5b92 <exit>
    exit(1);
    49be:	4505                	li	a0,1
    49c0:	00001097          	auipc	ra,0x1
    49c4:	1d2080e7          	jalr	466(ra) # 5b92 <exit>

00000000000049c8 <mem>:
{
    49c8:	7139                	addi	sp,sp,-64
    49ca:	fc06                	sd	ra,56(sp)
    49cc:	f822                	sd	s0,48(sp)
    49ce:	f426                	sd	s1,40(sp)
    49d0:	f04a                	sd	s2,32(sp)
    49d2:	ec4e                	sd	s3,24(sp)
    49d4:	0080                	addi	s0,sp,64
    49d6:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49d8:	00001097          	auipc	ra,0x1
    49dc:	1b2080e7          	jalr	434(ra) # 5b8a <fork>
    m1 = 0;
    49e0:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49e2:	6909                	lui	s2,0x2
    49e4:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x105>
  if((pid = fork()) == 0){
    49e8:	c115                	beqz	a0,4a0c <mem+0x44>
    wait(&xstatus);
    49ea:	fcc40513          	addi	a0,s0,-52
    49ee:	00001097          	auipc	ra,0x1
    49f2:	1ac080e7          	jalr	428(ra) # 5b9a <wait>
    if(xstatus == -1){
    49f6:	fcc42503          	lw	a0,-52(s0)
    49fa:	57fd                	li	a5,-1
    49fc:	06f50363          	beq	a0,a5,4a62 <mem+0x9a>
    exit(xstatus);
    4a00:	00001097          	auipc	ra,0x1
    4a04:	192080e7          	jalr	402(ra) # 5b92 <exit>
      *(char**)m2 = m1;
    4a08:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a0a:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a0c:	854a                	mv	a0,s2
    4a0e:	00001097          	auipc	ra,0x1
    4a12:	5a4080e7          	jalr	1444(ra) # 5fb2 <malloc>
    4a16:	f96d                	bnez	a0,4a08 <mem+0x40>
    while(m1){
    4a18:	c881                	beqz	s1,4a28 <mem+0x60>
      m2 = *(char**)m1;
    4a1a:	8526                	mv	a0,s1
    4a1c:	6084                	ld	s1,0(s1)
      free(m1);
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	512080e7          	jalr	1298(ra) # 5f30 <free>
    while(m1){
    4a26:	f8f5                	bnez	s1,4a1a <mem+0x52>
    m1 = malloc(1024*20);
    4a28:	6515                	lui	a0,0x5
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	588080e7          	jalr	1416(ra) # 5fb2 <malloc>
    if(m1 == 0){
    4a32:	c911                	beqz	a0,4a46 <mem+0x7e>
    free(m1);
    4a34:	00001097          	auipc	ra,0x1
    4a38:	4fc080e7          	jalr	1276(ra) # 5f30 <free>
    exit(0);
    4a3c:	4501                	li	a0,0
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	154080e7          	jalr	340(ra) # 5b92 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a46:	85ce                	mv	a1,s3
    4a48:	00003517          	auipc	a0,0x3
    4a4c:	2c850513          	addi	a0,a0,712 # 7d10 <malloc+0x1d5e>
    4a50:	00001097          	auipc	ra,0x1
    4a54:	4aa080e7          	jalr	1194(ra) # 5efa <printf>
      exit(1);
    4a58:	4505                	li	a0,1
    4a5a:	00001097          	auipc	ra,0x1
    4a5e:	138080e7          	jalr	312(ra) # 5b92 <exit>
      exit(0);
    4a62:	4501                	li	a0,0
    4a64:	00001097          	auipc	ra,0x1
    4a68:	12e080e7          	jalr	302(ra) # 5b92 <exit>

0000000000004a6c <sharedfd>:
{
    4a6c:	7159                	addi	sp,sp,-112
    4a6e:	f486                	sd	ra,104(sp)
    4a70:	f0a2                	sd	s0,96(sp)
    4a72:	eca6                	sd	s1,88(sp)
    4a74:	e8ca                	sd	s2,80(sp)
    4a76:	e4ce                	sd	s3,72(sp)
    4a78:	e0d2                	sd	s4,64(sp)
    4a7a:	fc56                	sd	s5,56(sp)
    4a7c:	f85a                	sd	s6,48(sp)
    4a7e:	f45e                	sd	s7,40(sp)
    4a80:	1880                	addi	s0,sp,112
    4a82:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a84:	00003517          	auipc	a0,0x3
    4a88:	2ac50513          	addi	a0,a0,684 # 7d30 <malloc+0x1d7e>
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	156080e7          	jalr	342(ra) # 5be2 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a94:	20200593          	li	a1,514
    4a98:	00003517          	auipc	a0,0x3
    4a9c:	29850513          	addi	a0,a0,664 # 7d30 <malloc+0x1d7e>
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	132080e7          	jalr	306(ra) # 5bd2 <open>
  if(fd < 0){
    4aa8:	04054a63          	bltz	a0,4afc <sharedfd+0x90>
    4aac:	892a                	mv	s2,a0
  pid = fork();
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	0dc080e7          	jalr	220(ra) # 5b8a <fork>
    4ab6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4ab8:	07000593          	li	a1,112
    4abc:	e119                	bnez	a0,4ac2 <sharedfd+0x56>
    4abe:	06300593          	li	a1,99
    4ac2:	4629                	li	a2,10
    4ac4:	fa040513          	addi	a0,s0,-96
    4ac8:	00001097          	auipc	ra,0x1
    4acc:	ed0080e7          	jalr	-304(ra) # 5998 <memset>
    4ad0:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ad4:	4629                	li	a2,10
    4ad6:	fa040593          	addi	a1,s0,-96
    4ada:	854a                	mv	a0,s2
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	0d6080e7          	jalr	214(ra) # 5bb2 <write>
    4ae4:	47a9                	li	a5,10
    4ae6:	02f51963          	bne	a0,a5,4b18 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4aea:	34fd                	addiw	s1,s1,-1
    4aec:	f4e5                	bnez	s1,4ad4 <sharedfd+0x68>
  if(pid == 0) {
    4aee:	04099363          	bnez	s3,4b34 <sharedfd+0xc8>
    exit(0);
    4af2:	4501                	li	a0,0
    4af4:	00001097          	auipc	ra,0x1
    4af8:	09e080e7          	jalr	158(ra) # 5b92 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4afc:	85d2                	mv	a1,s4
    4afe:	00003517          	auipc	a0,0x3
    4b02:	24250513          	addi	a0,a0,578 # 7d40 <malloc+0x1d8e>
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	3f4080e7          	jalr	1012(ra) # 5efa <printf>
    exit(1);
    4b0e:	4505                	li	a0,1
    4b10:	00001097          	auipc	ra,0x1
    4b14:	082080e7          	jalr	130(ra) # 5b92 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b18:	85d2                	mv	a1,s4
    4b1a:	00003517          	auipc	a0,0x3
    4b1e:	24e50513          	addi	a0,a0,590 # 7d68 <malloc+0x1db6>
    4b22:	00001097          	auipc	ra,0x1
    4b26:	3d8080e7          	jalr	984(ra) # 5efa <printf>
      exit(1);
    4b2a:	4505                	li	a0,1
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	066080e7          	jalr	102(ra) # 5b92 <exit>
    wait(&xstatus);
    4b34:	f9c40513          	addi	a0,s0,-100
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	062080e7          	jalr	98(ra) # 5b9a <wait>
    if(xstatus != 0)
    4b40:	f9c42983          	lw	s3,-100(s0)
    4b44:	00098763          	beqz	s3,4b52 <sharedfd+0xe6>
      exit(xstatus);
    4b48:	854e                	mv	a0,s3
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	048080e7          	jalr	72(ra) # 5b92 <exit>
  close(fd);
    4b52:	854a                	mv	a0,s2
    4b54:	00001097          	auipc	ra,0x1
    4b58:	066080e7          	jalr	102(ra) # 5bba <close>
  fd = open("sharedfd", 0);
    4b5c:	4581                	li	a1,0
    4b5e:	00003517          	auipc	a0,0x3
    4b62:	1d250513          	addi	a0,a0,466 # 7d30 <malloc+0x1d7e>
    4b66:	00001097          	auipc	ra,0x1
    4b6a:	06c080e7          	jalr	108(ra) # 5bd2 <open>
    4b6e:	8baa                	mv	s7,a0
  nc = np = 0;
    4b70:	8ace                	mv	s5,s3
  if(fd < 0){
    4b72:	02054563          	bltz	a0,4b9c <sharedfd+0x130>
    4b76:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b7a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b7e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b82:	4629                	li	a2,10
    4b84:	fa040593          	addi	a1,s0,-96
    4b88:	855e                	mv	a0,s7
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	020080e7          	jalr	32(ra) # 5baa <read>
    4b92:	02a05f63          	blez	a0,4bd0 <sharedfd+0x164>
    4b96:	fa040793          	addi	a5,s0,-96
    4b9a:	a01d                	j	4bc0 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b9c:	85d2                	mv	a1,s4
    4b9e:	00003517          	auipc	a0,0x3
    4ba2:	1ea50513          	addi	a0,a0,490 # 7d88 <malloc+0x1dd6>
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	354080e7          	jalr	852(ra) # 5efa <printf>
    exit(1);
    4bae:	4505                	li	a0,1
    4bb0:	00001097          	auipc	ra,0x1
    4bb4:	fe2080e7          	jalr	-30(ra) # 5b92 <exit>
        nc++;
    4bb8:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bba:	0785                	addi	a5,a5,1
    4bbc:	fd2783e3          	beq	a5,s2,4b82 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bc0:	0007c703          	lbu	a4,0(a5)
    4bc4:	fe970ae3          	beq	a4,s1,4bb8 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bc8:	ff6719e3          	bne	a4,s6,4bba <sharedfd+0x14e>
        np++;
    4bcc:	2a85                	addiw	s5,s5,1
    4bce:	b7f5                	j	4bba <sharedfd+0x14e>
  close(fd);
    4bd0:	855e                	mv	a0,s7
    4bd2:	00001097          	auipc	ra,0x1
    4bd6:	fe8080e7          	jalr	-24(ra) # 5bba <close>
  unlink("sharedfd");
    4bda:	00003517          	auipc	a0,0x3
    4bde:	15650513          	addi	a0,a0,342 # 7d30 <malloc+0x1d7e>
    4be2:	00001097          	auipc	ra,0x1
    4be6:	000080e7          	jalr	ra # 5be2 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bea:	6789                	lui	a5,0x2
    4bec:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x104>
    4bf0:	00f99763          	bne	s3,a5,4bfe <sharedfd+0x192>
    4bf4:	6789                	lui	a5,0x2
    4bf6:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x104>
    4bfa:	02fa8063          	beq	s5,a5,4c1a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4bfe:	85d2                	mv	a1,s4
    4c00:	00003517          	auipc	a0,0x3
    4c04:	1b050513          	addi	a0,a0,432 # 7db0 <malloc+0x1dfe>
    4c08:	00001097          	auipc	ra,0x1
    4c0c:	2f2080e7          	jalr	754(ra) # 5efa <printf>
    exit(1);
    4c10:	4505                	li	a0,1
    4c12:	00001097          	auipc	ra,0x1
    4c16:	f80080e7          	jalr	-128(ra) # 5b92 <exit>
    exit(0);
    4c1a:	4501                	li	a0,0
    4c1c:	00001097          	auipc	ra,0x1
    4c20:	f76080e7          	jalr	-138(ra) # 5b92 <exit>

0000000000004c24 <fourfiles>:
{
    4c24:	7135                	addi	sp,sp,-160
    4c26:	ed06                	sd	ra,152(sp)
    4c28:	e922                	sd	s0,144(sp)
    4c2a:	e526                	sd	s1,136(sp)
    4c2c:	e14a                	sd	s2,128(sp)
    4c2e:	fcce                	sd	s3,120(sp)
    4c30:	f8d2                	sd	s4,112(sp)
    4c32:	f4d6                	sd	s5,104(sp)
    4c34:	f0da                	sd	s6,96(sp)
    4c36:	ecde                	sd	s7,88(sp)
    4c38:	e8e2                	sd	s8,80(sp)
    4c3a:	e4e6                	sd	s9,72(sp)
    4c3c:	e0ea                	sd	s10,64(sp)
    4c3e:	fc6e                	sd	s11,56(sp)
    4c40:	1100                	addi	s0,sp,160
    4c42:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c44:	00003797          	auipc	a5,0x3
    4c48:	18478793          	addi	a5,a5,388 # 7dc8 <malloc+0x1e16>
    4c4c:	f6f43823          	sd	a5,-144(s0)
    4c50:	00003797          	auipc	a5,0x3
    4c54:	18078793          	addi	a5,a5,384 # 7dd0 <malloc+0x1e1e>
    4c58:	f6f43c23          	sd	a5,-136(s0)
    4c5c:	00003797          	auipc	a5,0x3
    4c60:	17c78793          	addi	a5,a5,380 # 7dd8 <malloc+0x1e26>
    4c64:	f8f43023          	sd	a5,-128(s0)
    4c68:	00003797          	auipc	a5,0x3
    4c6c:	17878793          	addi	a5,a5,376 # 7de0 <malloc+0x1e2e>
    4c70:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c74:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c78:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c7a:	4481                	li	s1,0
    4c7c:	4a11                	li	s4,4
    fname = names[pi];
    4c7e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c82:	854e                	mv	a0,s3
    4c84:	00001097          	auipc	ra,0x1
    4c88:	f5e080e7          	jalr	-162(ra) # 5be2 <unlink>
    pid = fork();
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	efe080e7          	jalr	-258(ra) # 5b8a <fork>
    if(pid < 0){
    4c94:	04054063          	bltz	a0,4cd4 <fourfiles+0xb0>
    if(pid == 0){
    4c98:	cd21                	beqz	a0,4cf0 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4c9a:	2485                	addiw	s1,s1,1
    4c9c:	0921                	addi	s2,s2,8
    4c9e:	ff4490e3          	bne	s1,s4,4c7e <fourfiles+0x5a>
    4ca2:	4491                	li	s1,4
    wait(&xstatus);
    4ca4:	f6c40513          	addi	a0,s0,-148
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	ef2080e7          	jalr	-270(ra) # 5b9a <wait>
    if(xstatus != 0)
    4cb0:	f6c42a83          	lw	s5,-148(s0)
    4cb4:	0c0a9863          	bnez	s5,4d84 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4cb8:	34fd                	addiw	s1,s1,-1
    4cba:	f4ed                	bnez	s1,4ca4 <fourfiles+0x80>
    4cbc:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cc0:	00008a17          	auipc	s4,0x8
    4cc4:	fb8a0a13          	addi	s4,s4,-72 # cc78 <buf>
    if(total != N*SZ){
    4cc8:	6d05                	lui	s10,0x1
    4cca:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4cce:	03400d93          	li	s11,52
    4cd2:	a22d                	j	4dfc <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4cd4:	85e6                	mv	a1,s9
    4cd6:	00002517          	auipc	a0,0x2
    4cda:	09250513          	addi	a0,a0,146 # 6d68 <malloc+0xdb6>
    4cde:	00001097          	auipc	ra,0x1
    4ce2:	21c080e7          	jalr	540(ra) # 5efa <printf>
      exit(1);
    4ce6:	4505                	li	a0,1
    4ce8:	00001097          	auipc	ra,0x1
    4cec:	eaa080e7          	jalr	-342(ra) # 5b92 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cf0:	20200593          	li	a1,514
    4cf4:	854e                	mv	a0,s3
    4cf6:	00001097          	auipc	ra,0x1
    4cfa:	edc080e7          	jalr	-292(ra) # 5bd2 <open>
    4cfe:	892a                	mv	s2,a0
      if(fd < 0){
    4d00:	04054763          	bltz	a0,4d4e <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d04:	1f400613          	li	a2,500
    4d08:	0304859b          	addiw	a1,s1,48
    4d0c:	00008517          	auipc	a0,0x8
    4d10:	f6c50513          	addi	a0,a0,-148 # cc78 <buf>
    4d14:	00001097          	auipc	ra,0x1
    4d18:	c84080e7          	jalr	-892(ra) # 5998 <memset>
    4d1c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d1e:	00008997          	auipc	s3,0x8
    4d22:	f5a98993          	addi	s3,s3,-166 # cc78 <buf>
    4d26:	1f400613          	li	a2,500
    4d2a:	85ce                	mv	a1,s3
    4d2c:	854a                	mv	a0,s2
    4d2e:	00001097          	auipc	ra,0x1
    4d32:	e84080e7          	jalr	-380(ra) # 5bb2 <write>
    4d36:	85aa                	mv	a1,a0
    4d38:	1f400793          	li	a5,500
    4d3c:	02f51763          	bne	a0,a5,4d6a <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d40:	34fd                	addiw	s1,s1,-1
    4d42:	f0f5                	bnez	s1,4d26 <fourfiles+0x102>
      exit(0);
    4d44:	4501                	li	a0,0
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	e4c080e7          	jalr	-436(ra) # 5b92 <exit>
        printf("create failed\n", s);
    4d4e:	85e6                	mv	a1,s9
    4d50:	00003517          	auipc	a0,0x3
    4d54:	09850513          	addi	a0,a0,152 # 7de8 <malloc+0x1e36>
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	1a2080e7          	jalr	418(ra) # 5efa <printf>
        exit(1);
    4d60:	4505                	li	a0,1
    4d62:	00001097          	auipc	ra,0x1
    4d66:	e30080e7          	jalr	-464(ra) # 5b92 <exit>
          printf("write failed %d\n", n);
    4d6a:	00003517          	auipc	a0,0x3
    4d6e:	08e50513          	addi	a0,a0,142 # 7df8 <malloc+0x1e46>
    4d72:	00001097          	auipc	ra,0x1
    4d76:	188080e7          	jalr	392(ra) # 5efa <printf>
          exit(1);
    4d7a:	4505                	li	a0,1
    4d7c:	00001097          	auipc	ra,0x1
    4d80:	e16080e7          	jalr	-490(ra) # 5b92 <exit>
      exit(xstatus);
    4d84:	8556                	mv	a0,s5
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	e0c080e7          	jalr	-500(ra) # 5b92 <exit>
          printf("wrong char\n", s);
    4d8e:	85e6                	mv	a1,s9
    4d90:	00003517          	auipc	a0,0x3
    4d94:	08050513          	addi	a0,a0,128 # 7e10 <malloc+0x1e5e>
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	162080e7          	jalr	354(ra) # 5efa <printf>
          exit(1);
    4da0:	4505                	li	a0,1
    4da2:	00001097          	auipc	ra,0x1
    4da6:	df0080e7          	jalr	-528(ra) # 5b92 <exit>
      total += n;
    4daa:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dae:	660d                	lui	a2,0x3
    4db0:	85d2                	mv	a1,s4
    4db2:	854e                	mv	a0,s3
    4db4:	00001097          	auipc	ra,0x1
    4db8:	df6080e7          	jalr	-522(ra) # 5baa <read>
    4dbc:	02a05063          	blez	a0,4ddc <fourfiles+0x1b8>
    4dc0:	00008797          	auipc	a5,0x8
    4dc4:	eb878793          	addi	a5,a5,-328 # cc78 <buf>
    4dc8:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4dcc:	0007c703          	lbu	a4,0(a5)
    4dd0:	fa971fe3          	bne	a4,s1,4d8e <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4dd4:	0785                	addi	a5,a5,1
    4dd6:	fed79be3          	bne	a5,a3,4dcc <fourfiles+0x1a8>
    4dda:	bfc1                	j	4daa <fourfiles+0x186>
    close(fd);
    4ddc:	854e                	mv	a0,s3
    4dde:	00001097          	auipc	ra,0x1
    4de2:	ddc080e7          	jalr	-548(ra) # 5bba <close>
    if(total != N*SZ){
    4de6:	03a91863          	bne	s2,s10,4e16 <fourfiles+0x1f2>
    unlink(fname);
    4dea:	8562                	mv	a0,s8
    4dec:	00001097          	auipc	ra,0x1
    4df0:	df6080e7          	jalr	-522(ra) # 5be2 <unlink>
  for(i = 0; i < NCHILD; i++){
    4df4:	0ba1                	addi	s7,s7,8
    4df6:	2b05                	addiw	s6,s6,1
    4df8:	03bb0d63          	beq	s6,s11,4e32 <fourfiles+0x20e>
    fname = names[i];
    4dfc:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e00:	4581                	li	a1,0
    4e02:	8562                	mv	a0,s8
    4e04:	00001097          	auipc	ra,0x1
    4e08:	dce080e7          	jalr	-562(ra) # 5bd2 <open>
    4e0c:	89aa                	mv	s3,a0
    total = 0;
    4e0e:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e10:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e14:	bf69                	j	4dae <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e16:	85ca                	mv	a1,s2
    4e18:	00003517          	auipc	a0,0x3
    4e1c:	00850513          	addi	a0,a0,8 # 7e20 <malloc+0x1e6e>
    4e20:	00001097          	auipc	ra,0x1
    4e24:	0da080e7          	jalr	218(ra) # 5efa <printf>
      exit(1);
    4e28:	4505                	li	a0,1
    4e2a:	00001097          	auipc	ra,0x1
    4e2e:	d68080e7          	jalr	-664(ra) # 5b92 <exit>
}
    4e32:	60ea                	ld	ra,152(sp)
    4e34:	644a                	ld	s0,144(sp)
    4e36:	64aa                	ld	s1,136(sp)
    4e38:	690a                	ld	s2,128(sp)
    4e3a:	79e6                	ld	s3,120(sp)
    4e3c:	7a46                	ld	s4,112(sp)
    4e3e:	7aa6                	ld	s5,104(sp)
    4e40:	7b06                	ld	s6,96(sp)
    4e42:	6be6                	ld	s7,88(sp)
    4e44:	6c46                	ld	s8,80(sp)
    4e46:	6ca6                	ld	s9,72(sp)
    4e48:	6d06                	ld	s10,64(sp)
    4e4a:	7de2                	ld	s11,56(sp)
    4e4c:	610d                	addi	sp,sp,160
    4e4e:	8082                	ret

0000000000004e50 <concreate>:
{
    4e50:	7135                	addi	sp,sp,-160
    4e52:	ed06                	sd	ra,152(sp)
    4e54:	e922                	sd	s0,144(sp)
    4e56:	e526                	sd	s1,136(sp)
    4e58:	e14a                	sd	s2,128(sp)
    4e5a:	fcce                	sd	s3,120(sp)
    4e5c:	f8d2                	sd	s4,112(sp)
    4e5e:	f4d6                	sd	s5,104(sp)
    4e60:	f0da                	sd	s6,96(sp)
    4e62:	ecde                	sd	s7,88(sp)
    4e64:	1100                	addi	s0,sp,160
    4e66:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e68:	04300793          	li	a5,67
    4e6c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e70:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e74:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e76:	4b0d                	li	s6,3
    4e78:	4a85                	li	s5,1
      link("C0", file);
    4e7a:	00003b97          	auipc	s7,0x3
    4e7e:	fbeb8b93          	addi	s7,s7,-66 # 7e38 <malloc+0x1e86>
  for(i = 0; i < N; i++){
    4e82:	02800a13          	li	s4,40
    4e86:	acc9                	j	5158 <concreate+0x308>
      link("C0", file);
    4e88:	fa840593          	addi	a1,s0,-88
    4e8c:	855e                	mv	a0,s7
    4e8e:	00001097          	auipc	ra,0x1
    4e92:	d64080e7          	jalr	-668(ra) # 5bf2 <link>
    if(pid == 0) {
    4e96:	a465                	j	513e <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4e98:	4795                	li	a5,5
    4e9a:	02f9693b          	remw	s2,s2,a5
    4e9e:	4785                	li	a5,1
    4ea0:	02f90b63          	beq	s2,a5,4ed6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4ea4:	20200593          	li	a1,514
    4ea8:	fa840513          	addi	a0,s0,-88
    4eac:	00001097          	auipc	ra,0x1
    4eb0:	d26080e7          	jalr	-730(ra) # 5bd2 <open>
      if(fd < 0){
    4eb4:	26055c63          	bgez	a0,512c <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4eb8:	fa840593          	addi	a1,s0,-88
    4ebc:	00003517          	auipc	a0,0x3
    4ec0:	f8450513          	addi	a0,a0,-124 # 7e40 <malloc+0x1e8e>
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	036080e7          	jalr	54(ra) # 5efa <printf>
        exit(1);
    4ecc:	4505                	li	a0,1
    4ece:	00001097          	auipc	ra,0x1
    4ed2:	cc4080e7          	jalr	-828(ra) # 5b92 <exit>
      link("C0", file);
    4ed6:	fa840593          	addi	a1,s0,-88
    4eda:	00003517          	auipc	a0,0x3
    4ede:	f5e50513          	addi	a0,a0,-162 # 7e38 <malloc+0x1e86>
    4ee2:	00001097          	auipc	ra,0x1
    4ee6:	d10080e7          	jalr	-752(ra) # 5bf2 <link>
      exit(0);
    4eea:	4501                	li	a0,0
    4eec:	00001097          	auipc	ra,0x1
    4ef0:	ca6080e7          	jalr	-858(ra) # 5b92 <exit>
        exit(1);
    4ef4:	4505                	li	a0,1
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	c9c080e7          	jalr	-868(ra) # 5b92 <exit>
  memset(fa, 0, sizeof(fa));
    4efe:	02800613          	li	a2,40
    4f02:	4581                	li	a1,0
    4f04:	f8040513          	addi	a0,s0,-128
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	a90080e7          	jalr	-1392(ra) # 5998 <memset>
  fd = open(".", 0);
    4f10:	4581                	li	a1,0
    4f12:	00002517          	auipc	a0,0x2
    4f16:	8ae50513          	addi	a0,a0,-1874 # 67c0 <malloc+0x80e>
    4f1a:	00001097          	auipc	ra,0x1
    4f1e:	cb8080e7          	jalr	-840(ra) # 5bd2 <open>
    4f22:	892a                	mv	s2,a0
  n = 0;
    4f24:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f26:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f2a:	02700b13          	li	s6,39
      fa[i] = 1;
    4f2e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f30:	4641                	li	a2,16
    4f32:	f7040593          	addi	a1,s0,-144
    4f36:	854a                	mv	a0,s2
    4f38:	00001097          	auipc	ra,0x1
    4f3c:	c72080e7          	jalr	-910(ra) # 5baa <read>
    4f40:	08a05263          	blez	a0,4fc4 <concreate+0x174>
    if(de.inum == 0)
    4f44:	f7045783          	lhu	a5,-144(s0)
    4f48:	d7e5                	beqz	a5,4f30 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f4a:	f7244783          	lbu	a5,-142(s0)
    4f4e:	ff4791e3          	bne	a5,s4,4f30 <concreate+0xe0>
    4f52:	f7444783          	lbu	a5,-140(s0)
    4f56:	ffe9                	bnez	a5,4f30 <concreate+0xe0>
      i = de.name[1] - '0';
    4f58:	f7344783          	lbu	a5,-141(s0)
    4f5c:	fd07879b          	addiw	a5,a5,-48
    4f60:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f64:	02eb6063          	bltu	s6,a4,4f84 <concreate+0x134>
      if(fa[i]){
    4f68:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xba>
    4f6c:	97a2                	add	a5,a5,s0
    4f6e:	fd07c783          	lbu	a5,-48(a5)
    4f72:	eb8d                	bnez	a5,4fa4 <concreate+0x154>
      fa[i] = 1;
    4f74:	fb070793          	addi	a5,a4,-80
    4f78:	00878733          	add	a4,a5,s0
    4f7c:	fd770823          	sb	s7,-48(a4)
      n++;
    4f80:	2a85                	addiw	s5,s5,1
    4f82:	b77d                	j	4f30 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f84:	f7240613          	addi	a2,s0,-142
    4f88:	85ce                	mv	a1,s3
    4f8a:	00003517          	auipc	a0,0x3
    4f8e:	ed650513          	addi	a0,a0,-298 # 7e60 <malloc+0x1eae>
    4f92:	00001097          	auipc	ra,0x1
    4f96:	f68080e7          	jalr	-152(ra) # 5efa <printf>
        exit(1);
    4f9a:	4505                	li	a0,1
    4f9c:	00001097          	auipc	ra,0x1
    4fa0:	bf6080e7          	jalr	-1034(ra) # 5b92 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fa4:	f7240613          	addi	a2,s0,-142
    4fa8:	85ce                	mv	a1,s3
    4faa:	00003517          	auipc	a0,0x3
    4fae:	ed650513          	addi	a0,a0,-298 # 7e80 <malloc+0x1ece>
    4fb2:	00001097          	auipc	ra,0x1
    4fb6:	f48080e7          	jalr	-184(ra) # 5efa <printf>
        exit(1);
    4fba:	4505                	li	a0,1
    4fbc:	00001097          	auipc	ra,0x1
    4fc0:	bd6080e7          	jalr	-1066(ra) # 5b92 <exit>
  close(fd);
    4fc4:	854a                	mv	a0,s2
    4fc6:	00001097          	auipc	ra,0x1
    4fca:	bf4080e7          	jalr	-1036(ra) # 5bba <close>
  if(n != N){
    4fce:	02800793          	li	a5,40
    4fd2:	00fa9763          	bne	s5,a5,4fe0 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fd6:	4a8d                	li	s5,3
    4fd8:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fda:	02800a13          	li	s4,40
    4fde:	a8c9                	j	50b0 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4fe0:	85ce                	mv	a1,s3
    4fe2:	00003517          	auipc	a0,0x3
    4fe6:	ec650513          	addi	a0,a0,-314 # 7ea8 <malloc+0x1ef6>
    4fea:	00001097          	auipc	ra,0x1
    4fee:	f10080e7          	jalr	-240(ra) # 5efa <printf>
    exit(1);
    4ff2:	4505                	li	a0,1
    4ff4:	00001097          	auipc	ra,0x1
    4ff8:	b9e080e7          	jalr	-1122(ra) # 5b92 <exit>
      printf("%s: fork failed\n", s);
    4ffc:	85ce                	mv	a1,s3
    4ffe:	00002517          	auipc	a0,0x2
    5002:	96250513          	addi	a0,a0,-1694 # 6960 <malloc+0x9ae>
    5006:	00001097          	auipc	ra,0x1
    500a:	ef4080e7          	jalr	-268(ra) # 5efa <printf>
      exit(1);
    500e:	4505                	li	a0,1
    5010:	00001097          	auipc	ra,0x1
    5014:	b82080e7          	jalr	-1150(ra) # 5b92 <exit>
      close(open(file, 0));
    5018:	4581                	li	a1,0
    501a:	fa840513          	addi	a0,s0,-88
    501e:	00001097          	auipc	ra,0x1
    5022:	bb4080e7          	jalr	-1100(ra) # 5bd2 <open>
    5026:	00001097          	auipc	ra,0x1
    502a:	b94080e7          	jalr	-1132(ra) # 5bba <close>
      close(open(file, 0));
    502e:	4581                	li	a1,0
    5030:	fa840513          	addi	a0,s0,-88
    5034:	00001097          	auipc	ra,0x1
    5038:	b9e080e7          	jalr	-1122(ra) # 5bd2 <open>
    503c:	00001097          	auipc	ra,0x1
    5040:	b7e080e7          	jalr	-1154(ra) # 5bba <close>
      close(open(file, 0));
    5044:	4581                	li	a1,0
    5046:	fa840513          	addi	a0,s0,-88
    504a:	00001097          	auipc	ra,0x1
    504e:	b88080e7          	jalr	-1144(ra) # 5bd2 <open>
    5052:	00001097          	auipc	ra,0x1
    5056:	b68080e7          	jalr	-1176(ra) # 5bba <close>
      close(open(file, 0));
    505a:	4581                	li	a1,0
    505c:	fa840513          	addi	a0,s0,-88
    5060:	00001097          	auipc	ra,0x1
    5064:	b72080e7          	jalr	-1166(ra) # 5bd2 <open>
    5068:	00001097          	auipc	ra,0x1
    506c:	b52080e7          	jalr	-1198(ra) # 5bba <close>
      close(open(file, 0));
    5070:	4581                	li	a1,0
    5072:	fa840513          	addi	a0,s0,-88
    5076:	00001097          	auipc	ra,0x1
    507a:	b5c080e7          	jalr	-1188(ra) # 5bd2 <open>
    507e:	00001097          	auipc	ra,0x1
    5082:	b3c080e7          	jalr	-1220(ra) # 5bba <close>
      close(open(file, 0));
    5086:	4581                	li	a1,0
    5088:	fa840513          	addi	a0,s0,-88
    508c:	00001097          	auipc	ra,0x1
    5090:	b46080e7          	jalr	-1210(ra) # 5bd2 <open>
    5094:	00001097          	auipc	ra,0x1
    5098:	b26080e7          	jalr	-1242(ra) # 5bba <close>
    if(pid == 0)
    509c:	08090363          	beqz	s2,5122 <concreate+0x2d2>
      wait(0);
    50a0:	4501                	li	a0,0
    50a2:	00001097          	auipc	ra,0x1
    50a6:	af8080e7          	jalr	-1288(ra) # 5b9a <wait>
  for(i = 0; i < N; i++){
    50aa:	2485                	addiw	s1,s1,1
    50ac:	0f448563          	beq	s1,s4,5196 <concreate+0x346>
    file[1] = '0' + i;
    50b0:	0304879b          	addiw	a5,s1,48
    50b4:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50b8:	00001097          	auipc	ra,0x1
    50bc:	ad2080e7          	jalr	-1326(ra) # 5b8a <fork>
    50c0:	892a                	mv	s2,a0
    if(pid < 0){
    50c2:	f2054de3          	bltz	a0,4ffc <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50c6:	0354e73b          	remw	a4,s1,s5
    50ca:	00a767b3          	or	a5,a4,a0
    50ce:	2781                	sext.w	a5,a5
    50d0:	d7a1                	beqz	a5,5018 <concreate+0x1c8>
    50d2:	01671363          	bne	a4,s6,50d8 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50d6:	f129                	bnez	a0,5018 <concreate+0x1c8>
      unlink(file);
    50d8:	fa840513          	addi	a0,s0,-88
    50dc:	00001097          	auipc	ra,0x1
    50e0:	b06080e7          	jalr	-1274(ra) # 5be2 <unlink>
      unlink(file);
    50e4:	fa840513          	addi	a0,s0,-88
    50e8:	00001097          	auipc	ra,0x1
    50ec:	afa080e7          	jalr	-1286(ra) # 5be2 <unlink>
      unlink(file);
    50f0:	fa840513          	addi	a0,s0,-88
    50f4:	00001097          	auipc	ra,0x1
    50f8:	aee080e7          	jalr	-1298(ra) # 5be2 <unlink>
      unlink(file);
    50fc:	fa840513          	addi	a0,s0,-88
    5100:	00001097          	auipc	ra,0x1
    5104:	ae2080e7          	jalr	-1310(ra) # 5be2 <unlink>
      unlink(file);
    5108:	fa840513          	addi	a0,s0,-88
    510c:	00001097          	auipc	ra,0x1
    5110:	ad6080e7          	jalr	-1322(ra) # 5be2 <unlink>
      unlink(file);
    5114:	fa840513          	addi	a0,s0,-88
    5118:	00001097          	auipc	ra,0x1
    511c:	aca080e7          	jalr	-1334(ra) # 5be2 <unlink>
    5120:	bfb5                	j	509c <concreate+0x24c>
      exit(0);
    5122:	4501                	li	a0,0
    5124:	00001097          	auipc	ra,0x1
    5128:	a6e080e7          	jalr	-1426(ra) # 5b92 <exit>
      close(fd);
    512c:	00001097          	auipc	ra,0x1
    5130:	a8e080e7          	jalr	-1394(ra) # 5bba <close>
    if(pid == 0) {
    5134:	bb5d                	j	4eea <concreate+0x9a>
      close(fd);
    5136:	00001097          	auipc	ra,0x1
    513a:	a84080e7          	jalr	-1404(ra) # 5bba <close>
      wait(&xstatus);
    513e:	f6c40513          	addi	a0,s0,-148
    5142:	00001097          	auipc	ra,0x1
    5146:	a58080e7          	jalr	-1448(ra) # 5b9a <wait>
      if(xstatus != 0)
    514a:	f6c42483          	lw	s1,-148(s0)
    514e:	da0493e3          	bnez	s1,4ef4 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5152:	2905                	addiw	s2,s2,1
    5154:	db4905e3          	beq	s2,s4,4efe <concreate+0xae>
    file[1] = '0' + i;
    5158:	0309079b          	addiw	a5,s2,48
    515c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5160:	fa840513          	addi	a0,s0,-88
    5164:	00001097          	auipc	ra,0x1
    5168:	a7e080e7          	jalr	-1410(ra) # 5be2 <unlink>
    pid = fork();
    516c:	00001097          	auipc	ra,0x1
    5170:	a1e080e7          	jalr	-1506(ra) # 5b8a <fork>
    if(pid && (i % 3) == 1){
    5174:	d20502e3          	beqz	a0,4e98 <concreate+0x48>
    5178:	036967bb          	remw	a5,s2,s6
    517c:	d15786e3          	beq	a5,s5,4e88 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5180:	20200593          	li	a1,514
    5184:	fa840513          	addi	a0,s0,-88
    5188:	00001097          	auipc	ra,0x1
    518c:	a4a080e7          	jalr	-1462(ra) # 5bd2 <open>
      if(fd < 0){
    5190:	fa0553e3          	bgez	a0,5136 <concreate+0x2e6>
    5194:	b315                	j	4eb8 <concreate+0x68>
}
    5196:	60ea                	ld	ra,152(sp)
    5198:	644a                	ld	s0,144(sp)
    519a:	64aa                	ld	s1,136(sp)
    519c:	690a                	ld	s2,128(sp)
    519e:	79e6                	ld	s3,120(sp)
    51a0:	7a46                	ld	s4,112(sp)
    51a2:	7aa6                	ld	s5,104(sp)
    51a4:	7b06                	ld	s6,96(sp)
    51a6:	6be6                	ld	s7,88(sp)
    51a8:	610d                	addi	sp,sp,160
    51aa:	8082                	ret

00000000000051ac <bigfile>:
{
    51ac:	7139                	addi	sp,sp,-64
    51ae:	fc06                	sd	ra,56(sp)
    51b0:	f822                	sd	s0,48(sp)
    51b2:	f426                	sd	s1,40(sp)
    51b4:	f04a                	sd	s2,32(sp)
    51b6:	ec4e                	sd	s3,24(sp)
    51b8:	e852                	sd	s4,16(sp)
    51ba:	e456                	sd	s5,8(sp)
    51bc:	0080                	addi	s0,sp,64
    51be:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51c0:	00003517          	auipc	a0,0x3
    51c4:	d2050513          	addi	a0,a0,-736 # 7ee0 <malloc+0x1f2e>
    51c8:	00001097          	auipc	ra,0x1
    51cc:	a1a080e7          	jalr	-1510(ra) # 5be2 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51d0:	20200593          	li	a1,514
    51d4:	00003517          	auipc	a0,0x3
    51d8:	d0c50513          	addi	a0,a0,-756 # 7ee0 <malloc+0x1f2e>
    51dc:	00001097          	auipc	ra,0x1
    51e0:	9f6080e7          	jalr	-1546(ra) # 5bd2 <open>
    51e4:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51e6:	4481                	li	s1,0
    memset(buf, i, SZ);
    51e8:	00008917          	auipc	s2,0x8
    51ec:	a9090913          	addi	s2,s2,-1392 # cc78 <buf>
  for(i = 0; i < N; i++){
    51f0:	4a51                	li	s4,20
  if(fd < 0){
    51f2:	0a054063          	bltz	a0,5292 <bigfile+0xe6>
    memset(buf, i, SZ);
    51f6:	25800613          	li	a2,600
    51fa:	85a6                	mv	a1,s1
    51fc:	854a                	mv	a0,s2
    51fe:	00000097          	auipc	ra,0x0
    5202:	79a080e7          	jalr	1946(ra) # 5998 <memset>
    if(write(fd, buf, SZ) != SZ){
    5206:	25800613          	li	a2,600
    520a:	85ca                	mv	a1,s2
    520c:	854e                	mv	a0,s3
    520e:	00001097          	auipc	ra,0x1
    5212:	9a4080e7          	jalr	-1628(ra) # 5bb2 <write>
    5216:	25800793          	li	a5,600
    521a:	08f51a63          	bne	a0,a5,52ae <bigfile+0x102>
  for(i = 0; i < N; i++){
    521e:	2485                	addiw	s1,s1,1
    5220:	fd449be3          	bne	s1,s4,51f6 <bigfile+0x4a>
  close(fd);
    5224:	854e                	mv	a0,s3
    5226:	00001097          	auipc	ra,0x1
    522a:	994080e7          	jalr	-1644(ra) # 5bba <close>
  fd = open("bigfile.dat", 0);
    522e:	4581                	li	a1,0
    5230:	00003517          	auipc	a0,0x3
    5234:	cb050513          	addi	a0,a0,-848 # 7ee0 <malloc+0x1f2e>
    5238:	00001097          	auipc	ra,0x1
    523c:	99a080e7          	jalr	-1638(ra) # 5bd2 <open>
    5240:	8a2a                	mv	s4,a0
  total = 0;
    5242:	4981                	li	s3,0
  for(i = 0; ; i++){
    5244:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5246:	00008917          	auipc	s2,0x8
    524a:	a3290913          	addi	s2,s2,-1486 # cc78 <buf>
  if(fd < 0){
    524e:	06054e63          	bltz	a0,52ca <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5252:	12c00613          	li	a2,300
    5256:	85ca                	mv	a1,s2
    5258:	8552                	mv	a0,s4
    525a:	00001097          	auipc	ra,0x1
    525e:	950080e7          	jalr	-1712(ra) # 5baa <read>
    if(cc < 0){
    5262:	08054263          	bltz	a0,52e6 <bigfile+0x13a>
    if(cc == 0)
    5266:	c971                	beqz	a0,533a <bigfile+0x18e>
    if(cc != SZ/2){
    5268:	12c00793          	li	a5,300
    526c:	08f51b63          	bne	a0,a5,5302 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5270:	01f4d79b          	srliw	a5,s1,0x1f
    5274:	9fa5                	addw	a5,a5,s1
    5276:	4017d79b          	sraiw	a5,a5,0x1
    527a:	00094703          	lbu	a4,0(s2)
    527e:	0af71063          	bne	a4,a5,531e <bigfile+0x172>
    5282:	12b94703          	lbu	a4,299(s2)
    5286:	08f71c63          	bne	a4,a5,531e <bigfile+0x172>
    total += cc;
    528a:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    528e:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5290:	b7c9                	j	5252 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5292:	85d6                	mv	a1,s5
    5294:	00003517          	auipc	a0,0x3
    5298:	c5c50513          	addi	a0,a0,-932 # 7ef0 <malloc+0x1f3e>
    529c:	00001097          	auipc	ra,0x1
    52a0:	c5e080e7          	jalr	-930(ra) # 5efa <printf>
    exit(1);
    52a4:	4505                	li	a0,1
    52a6:	00001097          	auipc	ra,0x1
    52aa:	8ec080e7          	jalr	-1812(ra) # 5b92 <exit>
      printf("%s: write bigfile failed\n", s);
    52ae:	85d6                	mv	a1,s5
    52b0:	00003517          	auipc	a0,0x3
    52b4:	c6050513          	addi	a0,a0,-928 # 7f10 <malloc+0x1f5e>
    52b8:	00001097          	auipc	ra,0x1
    52bc:	c42080e7          	jalr	-958(ra) # 5efa <printf>
      exit(1);
    52c0:	4505                	li	a0,1
    52c2:	00001097          	auipc	ra,0x1
    52c6:	8d0080e7          	jalr	-1840(ra) # 5b92 <exit>
    printf("%s: cannot open bigfile\n", s);
    52ca:	85d6                	mv	a1,s5
    52cc:	00003517          	auipc	a0,0x3
    52d0:	c6450513          	addi	a0,a0,-924 # 7f30 <malloc+0x1f7e>
    52d4:	00001097          	auipc	ra,0x1
    52d8:	c26080e7          	jalr	-986(ra) # 5efa <printf>
    exit(1);
    52dc:	4505                	li	a0,1
    52de:	00001097          	auipc	ra,0x1
    52e2:	8b4080e7          	jalr	-1868(ra) # 5b92 <exit>
      printf("%s: read bigfile failed\n", s);
    52e6:	85d6                	mv	a1,s5
    52e8:	00003517          	auipc	a0,0x3
    52ec:	c6850513          	addi	a0,a0,-920 # 7f50 <malloc+0x1f9e>
    52f0:	00001097          	auipc	ra,0x1
    52f4:	c0a080e7          	jalr	-1014(ra) # 5efa <printf>
      exit(1);
    52f8:	4505                	li	a0,1
    52fa:	00001097          	auipc	ra,0x1
    52fe:	898080e7          	jalr	-1896(ra) # 5b92 <exit>
      printf("%s: short read bigfile\n", s);
    5302:	85d6                	mv	a1,s5
    5304:	00003517          	auipc	a0,0x3
    5308:	c6c50513          	addi	a0,a0,-916 # 7f70 <malloc+0x1fbe>
    530c:	00001097          	auipc	ra,0x1
    5310:	bee080e7          	jalr	-1042(ra) # 5efa <printf>
      exit(1);
    5314:	4505                	li	a0,1
    5316:	00001097          	auipc	ra,0x1
    531a:	87c080e7          	jalr	-1924(ra) # 5b92 <exit>
      printf("%s: read bigfile wrong data\n", s);
    531e:	85d6                	mv	a1,s5
    5320:	00003517          	auipc	a0,0x3
    5324:	c6850513          	addi	a0,a0,-920 # 7f88 <malloc+0x1fd6>
    5328:	00001097          	auipc	ra,0x1
    532c:	bd2080e7          	jalr	-1070(ra) # 5efa <printf>
      exit(1);
    5330:	4505                	li	a0,1
    5332:	00001097          	auipc	ra,0x1
    5336:	860080e7          	jalr	-1952(ra) # 5b92 <exit>
  close(fd);
    533a:	8552                	mv	a0,s4
    533c:	00001097          	auipc	ra,0x1
    5340:	87e080e7          	jalr	-1922(ra) # 5bba <close>
  if(total != N*SZ){
    5344:	678d                	lui	a5,0x3
    5346:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x8c>
    534a:	02f99363          	bne	s3,a5,5370 <bigfile+0x1c4>
  unlink("bigfile.dat");
    534e:	00003517          	auipc	a0,0x3
    5352:	b9250513          	addi	a0,a0,-1134 # 7ee0 <malloc+0x1f2e>
    5356:	00001097          	auipc	ra,0x1
    535a:	88c080e7          	jalr	-1908(ra) # 5be2 <unlink>
}
    535e:	70e2                	ld	ra,56(sp)
    5360:	7442                	ld	s0,48(sp)
    5362:	74a2                	ld	s1,40(sp)
    5364:	7902                	ld	s2,32(sp)
    5366:	69e2                	ld	s3,24(sp)
    5368:	6a42                	ld	s4,16(sp)
    536a:	6aa2                	ld	s5,8(sp)
    536c:	6121                	addi	sp,sp,64
    536e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5370:	85d6                	mv	a1,s5
    5372:	00003517          	auipc	a0,0x3
    5376:	c3650513          	addi	a0,a0,-970 # 7fa8 <malloc+0x1ff6>
    537a:	00001097          	auipc	ra,0x1
    537e:	b80080e7          	jalr	-1152(ra) # 5efa <printf>
    exit(1);
    5382:	4505                	li	a0,1
    5384:	00001097          	auipc	ra,0x1
    5388:	80e080e7          	jalr	-2034(ra) # 5b92 <exit>

000000000000538c <fsfull>:
{
    538c:	7135                	addi	sp,sp,-160
    538e:	ed06                	sd	ra,152(sp)
    5390:	e922                	sd	s0,144(sp)
    5392:	e526                	sd	s1,136(sp)
    5394:	e14a                	sd	s2,128(sp)
    5396:	fcce                	sd	s3,120(sp)
    5398:	f8d2                	sd	s4,112(sp)
    539a:	f4d6                	sd	s5,104(sp)
    539c:	f0da                	sd	s6,96(sp)
    539e:	ecde                	sd	s7,88(sp)
    53a0:	e8e2                	sd	s8,80(sp)
    53a2:	e4e6                	sd	s9,72(sp)
    53a4:	e0ea                	sd	s10,64(sp)
    53a6:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    53a8:	00003517          	auipc	a0,0x3
    53ac:	c2050513          	addi	a0,a0,-992 # 7fc8 <malloc+0x2016>
    53b0:	00001097          	auipc	ra,0x1
    53b4:	b4a080e7          	jalr	-1206(ra) # 5efa <printf>
  for(nfiles = 0; ; nfiles++){
    53b8:	4481                	li	s1,0
    name[0] = 'f';
    53ba:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53be:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53c2:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53c6:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53c8:	00003c97          	auipc	s9,0x3
    53cc:	c10c8c93          	addi	s9,s9,-1008 # 7fd8 <malloc+0x2026>
    name[0] = 'f';
    53d0:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53d4:	0384c7bb          	divw	a5,s1,s8
    53d8:	0307879b          	addiw	a5,a5,48
    53dc:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53e0:	0384e7bb          	remw	a5,s1,s8
    53e4:	0377c7bb          	divw	a5,a5,s7
    53e8:	0307879b          	addiw	a5,a5,48
    53ec:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53f0:	0374e7bb          	remw	a5,s1,s7
    53f4:	0367c7bb          	divw	a5,a5,s6
    53f8:	0307879b          	addiw	a5,a5,48
    53fc:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5400:	0364e7bb          	remw	a5,s1,s6
    5404:	0307879b          	addiw	a5,a5,48
    5408:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    540c:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    5410:	f6040593          	addi	a1,s0,-160
    5414:	8566                	mv	a0,s9
    5416:	00001097          	auipc	ra,0x1
    541a:	ae4080e7          	jalr	-1308(ra) # 5efa <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    541e:	20200593          	li	a1,514
    5422:	f6040513          	addi	a0,s0,-160
    5426:	00000097          	auipc	ra,0x0
    542a:	7ac080e7          	jalr	1964(ra) # 5bd2 <open>
    542e:	892a                	mv	s2,a0
    if(fd < 0){
    5430:	0a055563          	bgez	a0,54da <fsfull+0x14e>
      printf("open %s failed\n", name);
    5434:	f6040593          	addi	a1,s0,-160
    5438:	00003517          	auipc	a0,0x3
    543c:	bb050513          	addi	a0,a0,-1104 # 7fe8 <malloc+0x2036>
    5440:	00001097          	auipc	ra,0x1
    5444:	aba080e7          	jalr	-1350(ra) # 5efa <printf>
  while(nfiles >= 0){
    5448:	0604c363          	bltz	s1,54ae <fsfull+0x122>
    name[0] = 'f';
    544c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5450:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5454:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5458:	4929                	li	s2,10
  while(nfiles >= 0){
    545a:	5afd                	li	s5,-1
    name[0] = 'f';
    545c:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5460:	0344c7bb          	divw	a5,s1,s4
    5464:	0307879b          	addiw	a5,a5,48
    5468:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    546c:	0344e7bb          	remw	a5,s1,s4
    5470:	0337c7bb          	divw	a5,a5,s3
    5474:	0307879b          	addiw	a5,a5,48
    5478:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    547c:	0334e7bb          	remw	a5,s1,s3
    5480:	0327c7bb          	divw	a5,a5,s2
    5484:	0307879b          	addiw	a5,a5,48
    5488:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    548c:	0324e7bb          	remw	a5,s1,s2
    5490:	0307879b          	addiw	a5,a5,48
    5494:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5498:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    549c:	f6040513          	addi	a0,s0,-160
    54a0:	00000097          	auipc	ra,0x0
    54a4:	742080e7          	jalr	1858(ra) # 5be2 <unlink>
    nfiles--;
    54a8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54aa:	fb5499e3          	bne	s1,s5,545c <fsfull+0xd0>
  printf("fsfull test finished\n");
    54ae:	00003517          	auipc	a0,0x3
    54b2:	b5a50513          	addi	a0,a0,-1190 # 8008 <malloc+0x2056>
    54b6:	00001097          	auipc	ra,0x1
    54ba:	a44080e7          	jalr	-1468(ra) # 5efa <printf>
}
    54be:	60ea                	ld	ra,152(sp)
    54c0:	644a                	ld	s0,144(sp)
    54c2:	64aa                	ld	s1,136(sp)
    54c4:	690a                	ld	s2,128(sp)
    54c6:	79e6                	ld	s3,120(sp)
    54c8:	7a46                	ld	s4,112(sp)
    54ca:	7aa6                	ld	s5,104(sp)
    54cc:	7b06                	ld	s6,96(sp)
    54ce:	6be6                	ld	s7,88(sp)
    54d0:	6c46                	ld	s8,80(sp)
    54d2:	6ca6                	ld	s9,72(sp)
    54d4:	6d06                	ld	s10,64(sp)
    54d6:	610d                	addi	sp,sp,160
    54d8:	8082                	ret
    int total = 0;
    54da:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54dc:	00007a97          	auipc	s5,0x7
    54e0:	79ca8a93          	addi	s5,s5,1948 # cc78 <buf>
      if(cc < BSIZE)
    54e4:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54e8:	40000613          	li	a2,1024
    54ec:	85d6                	mv	a1,s5
    54ee:	854a                	mv	a0,s2
    54f0:	00000097          	auipc	ra,0x0
    54f4:	6c2080e7          	jalr	1730(ra) # 5bb2 <write>
      if(cc < BSIZE)
    54f8:	00aa5563          	bge	s4,a0,5502 <fsfull+0x176>
      total += cc;
    54fc:	00a989bb          	addw	s3,s3,a0
    while(1){
    5500:	b7e5                	j	54e8 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    5502:	85ce                	mv	a1,s3
    5504:	00003517          	auipc	a0,0x3
    5508:	af450513          	addi	a0,a0,-1292 # 7ff8 <malloc+0x2046>
    550c:	00001097          	auipc	ra,0x1
    5510:	9ee080e7          	jalr	-1554(ra) # 5efa <printf>
    close(fd);
    5514:	854a                	mv	a0,s2
    5516:	00000097          	auipc	ra,0x0
    551a:	6a4080e7          	jalr	1700(ra) # 5bba <close>
    if(total == 0)
    551e:	f20985e3          	beqz	s3,5448 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5522:	2485                	addiw	s1,s1,1
    5524:	b575                	j	53d0 <fsfull+0x44>

0000000000005526 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5526:	7179                	addi	sp,sp,-48
    5528:	f406                	sd	ra,40(sp)
    552a:	f022                	sd	s0,32(sp)
    552c:	ec26                	sd	s1,24(sp)
    552e:	e84a                	sd	s2,16(sp)
    5530:	1800                	addi	s0,sp,48
    5532:	84aa                	mv	s1,a0
    5534:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5536:	00003517          	auipc	a0,0x3
    553a:	aea50513          	addi	a0,a0,-1302 # 8020 <malloc+0x206e>
    553e:	00001097          	auipc	ra,0x1
    5542:	9bc080e7          	jalr	-1604(ra) # 5efa <printf>
  if((pid = fork()) < 0) {
    5546:	00000097          	auipc	ra,0x0
    554a:	644080e7          	jalr	1604(ra) # 5b8a <fork>
    554e:	02054e63          	bltz	a0,558a <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5552:	c929                	beqz	a0,55a4 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5554:	fdc40513          	addi	a0,s0,-36
    5558:	00000097          	auipc	ra,0x0
    555c:	642080e7          	jalr	1602(ra) # 5b9a <wait>
    if(xstatus != 0) 
    5560:	fdc42783          	lw	a5,-36(s0)
    5564:	c7b9                	beqz	a5,55b2 <run+0x8c>
      printf("FAILED\n");
    5566:	00003517          	auipc	a0,0x3
    556a:	ae250513          	addi	a0,a0,-1310 # 8048 <malloc+0x2096>
    556e:	00001097          	auipc	ra,0x1
    5572:	98c080e7          	jalr	-1652(ra) # 5efa <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5576:	fdc42503          	lw	a0,-36(s0)
  }
}
    557a:	00153513          	seqz	a0,a0
    557e:	70a2                	ld	ra,40(sp)
    5580:	7402                	ld	s0,32(sp)
    5582:	64e2                	ld	s1,24(sp)
    5584:	6942                	ld	s2,16(sp)
    5586:	6145                	addi	sp,sp,48
    5588:	8082                	ret
    printf("runtest: fork error\n");
    558a:	00003517          	auipc	a0,0x3
    558e:	aa650513          	addi	a0,a0,-1370 # 8030 <malloc+0x207e>
    5592:	00001097          	auipc	ra,0x1
    5596:	968080e7          	jalr	-1688(ra) # 5efa <printf>
    exit(1);
    559a:	4505                	li	a0,1
    559c:	00000097          	auipc	ra,0x0
    55a0:	5f6080e7          	jalr	1526(ra) # 5b92 <exit>
    f(s);
    55a4:	854a                	mv	a0,s2
    55a6:	9482                	jalr	s1
    exit(0);
    55a8:	4501                	li	a0,0
    55aa:	00000097          	auipc	ra,0x0
    55ae:	5e8080e7          	jalr	1512(ra) # 5b92 <exit>
      printf("OK\n");
    55b2:	00003517          	auipc	a0,0x3
    55b6:	a9e50513          	addi	a0,a0,-1378 # 8050 <malloc+0x209e>
    55ba:	00001097          	auipc	ra,0x1
    55be:	940080e7          	jalr	-1728(ra) # 5efa <printf>
    55c2:	bf55                	j	5576 <run+0x50>

00000000000055c4 <runtests>:

int
runtests(struct test *tests, char *justone) {
    55c4:	1101                	addi	sp,sp,-32
    55c6:	ec06                	sd	ra,24(sp)
    55c8:	e822                	sd	s0,16(sp)
    55ca:	e426                	sd	s1,8(sp)
    55cc:	e04a                	sd	s2,0(sp)
    55ce:	1000                	addi	s0,sp,32
    55d0:	84aa                	mv	s1,a0
    55d2:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55d4:	6508                	ld	a0,8(a0)
    55d6:	ed09                	bnez	a0,55f0 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55d8:	4501                	li	a0,0
    55da:	a82d                	j	5614 <runtests+0x50>
      if(!run(t->f, t->s)){
    55dc:	648c                	ld	a1,8(s1)
    55de:	6088                	ld	a0,0(s1)
    55e0:	00000097          	auipc	ra,0x0
    55e4:	f46080e7          	jalr	-186(ra) # 5526 <run>
    55e8:	cd09                	beqz	a0,5602 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    55ea:	04c1                	addi	s1,s1,16
    55ec:	6488                	ld	a0,8(s1)
    55ee:	c11d                	beqz	a0,5614 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    55f0:	fe0906e3          	beqz	s2,55dc <runtests+0x18>
    55f4:	85ca                	mv	a1,s2
    55f6:	00000097          	auipc	ra,0x0
    55fa:	34c080e7          	jalr	844(ra) # 5942 <strcmp>
    55fe:	f575                	bnez	a0,55ea <runtests+0x26>
    5600:	bff1                	j	55dc <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5602:	00003517          	auipc	a0,0x3
    5606:	a5650513          	addi	a0,a0,-1450 # 8058 <malloc+0x20a6>
    560a:	00001097          	auipc	ra,0x1
    560e:	8f0080e7          	jalr	-1808(ra) # 5efa <printf>
        return 1;
    5612:	4505                	li	a0,1
}
    5614:	60e2                	ld	ra,24(sp)
    5616:	6442                	ld	s0,16(sp)
    5618:	64a2                	ld	s1,8(sp)
    561a:	6902                	ld	s2,0(sp)
    561c:	6105                	addi	sp,sp,32
    561e:	8082                	ret

0000000000005620 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5620:	7139                	addi	sp,sp,-64
    5622:	fc06                	sd	ra,56(sp)
    5624:	f822                	sd	s0,48(sp)
    5626:	f426                	sd	s1,40(sp)
    5628:	f04a                	sd	s2,32(sp)
    562a:	ec4e                	sd	s3,24(sp)
    562c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    562e:	fc840513          	addi	a0,s0,-56
    5632:	00000097          	auipc	ra,0x0
    5636:	570080e7          	jalr	1392(ra) # 5ba2 <pipe>
    563a:	06054763          	bltz	a0,56a8 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    563e:	00000097          	auipc	ra,0x0
    5642:	54c080e7          	jalr	1356(ra) # 5b8a <fork>

  if(pid < 0){
    5646:	06054e63          	bltz	a0,56c2 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    564a:	ed51                	bnez	a0,56e6 <countfree+0xc6>
    close(fds[0]);
    564c:	fc842503          	lw	a0,-56(s0)
    5650:	00000097          	auipc	ra,0x0
    5654:	56a080e7          	jalr	1386(ra) # 5bba <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5658:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    565a:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    565c:	00001997          	auipc	s3,0x1
    5660:	aec98993          	addi	s3,s3,-1300 # 6148 <malloc+0x196>
      uint64 a = (uint64) sbrk(4096);
    5664:	6505                	lui	a0,0x1
    5666:	00000097          	auipc	ra,0x0
    566a:	5b4080e7          	jalr	1460(ra) # 5c1a <sbrk>
      if(a == 0xffffffffffffffff){
    566e:	07250763          	beq	a0,s2,56dc <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    5672:	6785                	lui	a5,0x1
    5674:	97aa                	add	a5,a5,a0
    5676:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    567a:	8626                	mv	a2,s1
    567c:	85ce                	mv	a1,s3
    567e:	fcc42503          	lw	a0,-52(s0)
    5682:	00000097          	auipc	ra,0x0
    5686:	530080e7          	jalr	1328(ra) # 5bb2 <write>
    568a:	fc950de3          	beq	a0,s1,5664 <countfree+0x44>
        printf("write() failed in countfree()\n");
    568e:	00003517          	auipc	a0,0x3
    5692:	a2250513          	addi	a0,a0,-1502 # 80b0 <malloc+0x20fe>
    5696:	00001097          	auipc	ra,0x1
    569a:	864080e7          	jalr	-1948(ra) # 5efa <printf>
        exit(1);
    569e:	4505                	li	a0,1
    56a0:	00000097          	auipc	ra,0x0
    56a4:	4f2080e7          	jalr	1266(ra) # 5b92 <exit>
    printf("pipe() failed in countfree()\n");
    56a8:	00003517          	auipc	a0,0x3
    56ac:	9c850513          	addi	a0,a0,-1592 # 8070 <malloc+0x20be>
    56b0:	00001097          	auipc	ra,0x1
    56b4:	84a080e7          	jalr	-1974(ra) # 5efa <printf>
    exit(1);
    56b8:	4505                	li	a0,1
    56ba:	00000097          	auipc	ra,0x0
    56be:	4d8080e7          	jalr	1240(ra) # 5b92 <exit>
    printf("fork failed in countfree()\n");
    56c2:	00003517          	auipc	a0,0x3
    56c6:	9ce50513          	addi	a0,a0,-1586 # 8090 <malloc+0x20de>
    56ca:	00001097          	auipc	ra,0x1
    56ce:	830080e7          	jalr	-2000(ra) # 5efa <printf>
    exit(1);
    56d2:	4505                	li	a0,1
    56d4:	00000097          	auipc	ra,0x0
    56d8:	4be080e7          	jalr	1214(ra) # 5b92 <exit>
      }
    }

    exit(0);
    56dc:	4501                	li	a0,0
    56de:	00000097          	auipc	ra,0x0
    56e2:	4b4080e7          	jalr	1204(ra) # 5b92 <exit>
  }

  close(fds[1]);
    56e6:	fcc42503          	lw	a0,-52(s0)
    56ea:	00000097          	auipc	ra,0x0
    56ee:	4d0080e7          	jalr	1232(ra) # 5bba <close>

  int n = 0;
    56f2:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    56f4:	4605                	li	a2,1
    56f6:	fc740593          	addi	a1,s0,-57
    56fa:	fc842503          	lw	a0,-56(s0)
    56fe:	00000097          	auipc	ra,0x0
    5702:	4ac080e7          	jalr	1196(ra) # 5baa <read>
    if(cc < 0){
    5706:	00054563          	bltz	a0,5710 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    570a:	c105                	beqz	a0,572a <countfree+0x10a>
      break;
    n += 1;
    570c:	2485                	addiw	s1,s1,1
  while(1){
    570e:	b7dd                	j	56f4 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    5710:	00003517          	auipc	a0,0x3
    5714:	9c050513          	addi	a0,a0,-1600 # 80d0 <malloc+0x211e>
    5718:	00000097          	auipc	ra,0x0
    571c:	7e2080e7          	jalr	2018(ra) # 5efa <printf>
      exit(1);
    5720:	4505                	li	a0,1
    5722:	00000097          	auipc	ra,0x0
    5726:	470080e7          	jalr	1136(ra) # 5b92 <exit>
  }

  close(fds[0]);
    572a:	fc842503          	lw	a0,-56(s0)
    572e:	00000097          	auipc	ra,0x0
    5732:	48c080e7          	jalr	1164(ra) # 5bba <close>
  wait((int*)0);
    5736:	4501                	li	a0,0
    5738:	00000097          	auipc	ra,0x0
    573c:	462080e7          	jalr	1122(ra) # 5b9a <wait>
  
  return n;
}
    5740:	8526                	mv	a0,s1
    5742:	70e2                	ld	ra,56(sp)
    5744:	7442                	ld	s0,48(sp)
    5746:	74a2                	ld	s1,40(sp)
    5748:	7902                	ld	s2,32(sp)
    574a:	69e2                	ld	s3,24(sp)
    574c:	6121                	addi	sp,sp,64
    574e:	8082                	ret

0000000000005750 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5750:	711d                	addi	sp,sp,-96
    5752:	ec86                	sd	ra,88(sp)
    5754:	e8a2                	sd	s0,80(sp)
    5756:	e4a6                	sd	s1,72(sp)
    5758:	e0ca                	sd	s2,64(sp)
    575a:	fc4e                	sd	s3,56(sp)
    575c:	f852                	sd	s4,48(sp)
    575e:	f456                	sd	s5,40(sp)
    5760:	f05a                	sd	s6,32(sp)
    5762:	ec5e                	sd	s7,24(sp)
    5764:	e862                	sd	s8,16(sp)
    5766:	e466                	sd	s9,8(sp)
    5768:	e06a                	sd	s10,0(sp)
    576a:	1080                	addi	s0,sp,96
    576c:	8aaa                	mv	s5,a0
    576e:	89ae                	mv	s3,a1
    5770:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5772:	00003b97          	auipc	s7,0x3
    5776:	97eb8b93          	addi	s7,s7,-1666 # 80f0 <malloc+0x213e>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    577a:	00004b17          	auipc	s6,0x4
    577e:	896b0b13          	addi	s6,s6,-1898 # 9010 <quicktests>
      if(continuous != 2) {
    5782:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5784:	00004c17          	auipc	s8,0x4
    5788:	c5cc0c13          	addi	s8,s8,-932 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    578c:	00003d17          	auipc	s10,0x3
    5790:	97cd0d13          	addi	s10,s10,-1668 # 8108 <malloc+0x2156>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5794:	00003c97          	auipc	s9,0x3
    5798:	994c8c93          	addi	s9,s9,-1644 # 8128 <malloc+0x2176>
    579c:	a839                	j	57ba <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    579e:	856a                	mv	a0,s10
    57a0:	00000097          	auipc	ra,0x0
    57a4:	75a080e7          	jalr	1882(ra) # 5efa <printf>
    57a8:	a081                	j	57e8 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57aa:	00000097          	auipc	ra,0x0
    57ae:	e76080e7          	jalr	-394(ra) # 5620 <countfree>
    57b2:	04954663          	blt	a0,s1,57fe <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57b6:	06098163          	beqz	s3,5818 <drivetests+0xc8>
    printf("usertests starting\n");
    57ba:	855e                	mv	a0,s7
    57bc:	00000097          	auipc	ra,0x0
    57c0:	73e080e7          	jalr	1854(ra) # 5efa <printf>
    int free0 = countfree();
    57c4:	00000097          	auipc	ra,0x0
    57c8:	e5c080e7          	jalr	-420(ra) # 5620 <countfree>
    57cc:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57ce:	85ca                	mv	a1,s2
    57d0:	855a                	mv	a0,s6
    57d2:	00000097          	auipc	ra,0x0
    57d6:	df2080e7          	jalr	-526(ra) # 55c4 <runtests>
    57da:	c119                	beqz	a0,57e0 <drivetests+0x90>
      if(continuous != 2) {
    57dc:	03499c63          	bne	s3,s4,5814 <drivetests+0xc4>
    if(!quick) {
    57e0:	fc0a95e3          	bnez	s5,57aa <drivetests+0x5a>
      if (justone == 0)
    57e4:	fa090de3          	beqz	s2,579e <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    57e8:	85ca                	mv	a1,s2
    57ea:	8562                	mv	a0,s8
    57ec:	00000097          	auipc	ra,0x0
    57f0:	dd8080e7          	jalr	-552(ra) # 55c4 <runtests>
    57f4:	d95d                	beqz	a0,57aa <drivetests+0x5a>
        if(continuous != 2) {
    57f6:	fb498ae3          	beq	s3,s4,57aa <drivetests+0x5a>
          return 1;
    57fa:	4505                	li	a0,1
    57fc:	a839                	j	581a <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57fe:	8626                	mv	a2,s1
    5800:	85aa                	mv	a1,a0
    5802:	8566                	mv	a0,s9
    5804:	00000097          	auipc	ra,0x0
    5808:	6f6080e7          	jalr	1782(ra) # 5efa <printf>
      if(continuous != 2) {
    580c:	fb4987e3          	beq	s3,s4,57ba <drivetests+0x6a>
        return 1;
    5810:	4505                	li	a0,1
    5812:	a021                	j	581a <drivetests+0xca>
        return 1;
    5814:	4505                	li	a0,1
    5816:	a011                	j	581a <drivetests+0xca>
  return 0;
    5818:	854e                	mv	a0,s3
}
    581a:	60e6                	ld	ra,88(sp)
    581c:	6446                	ld	s0,80(sp)
    581e:	64a6                	ld	s1,72(sp)
    5820:	6906                	ld	s2,64(sp)
    5822:	79e2                	ld	s3,56(sp)
    5824:	7a42                	ld	s4,48(sp)
    5826:	7aa2                	ld	s5,40(sp)
    5828:	7b02                	ld	s6,32(sp)
    582a:	6be2                	ld	s7,24(sp)
    582c:	6c42                	ld	s8,16(sp)
    582e:	6ca2                	ld	s9,8(sp)
    5830:	6d02                	ld	s10,0(sp)
    5832:	6125                	addi	sp,sp,96
    5834:	8082                	ret

0000000000005836 <main>:

int
main(int argc, char *argv[])
{
    5836:	1101                	addi	sp,sp,-32
    5838:	ec06                	sd	ra,24(sp)
    583a:	e822                	sd	s0,16(sp)
    583c:	e426                	sd	s1,8(sp)
    583e:	e04a                	sd	s2,0(sp)
    5840:	1000                	addi	s0,sp,32
    5842:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5844:	4789                	li	a5,2
    5846:	02f50263          	beq	a0,a5,586a <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    584a:	4785                	li	a5,1
    584c:	08a7c063          	blt	a5,a0,58cc <main+0x96>
  char *justone = 0;
    5850:	4601                	li	a2,0
  int quick = 0;
    5852:	4501                	li	a0,0
  int continuous = 0;
    5854:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5856:	00000097          	auipc	ra,0x0
    585a:	efa080e7          	jalr	-262(ra) # 5750 <drivetests>
    585e:	c951                	beqz	a0,58f2 <main+0xbc>
    exit(1);
    5860:	4505                	li	a0,1
    5862:	00000097          	auipc	ra,0x0
    5866:	330080e7          	jalr	816(ra) # 5b92 <exit>
    586a:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    586c:	00003597          	auipc	a1,0x3
    5870:	8ec58593          	addi	a1,a1,-1812 # 8158 <malloc+0x21a6>
    5874:	00893503          	ld	a0,8(s2)
    5878:	00000097          	auipc	ra,0x0
    587c:	0ca080e7          	jalr	202(ra) # 5942 <strcmp>
    5880:	85aa                	mv	a1,a0
    5882:	e501                	bnez	a0,588a <main+0x54>
  char *justone = 0;
    5884:	4601                	li	a2,0
    quick = 1;
    5886:	4505                	li	a0,1
    5888:	b7f9                	j	5856 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    588a:	00003597          	auipc	a1,0x3
    588e:	8d658593          	addi	a1,a1,-1834 # 8160 <malloc+0x21ae>
    5892:	00893503          	ld	a0,8(s2)
    5896:	00000097          	auipc	ra,0x0
    589a:	0ac080e7          	jalr	172(ra) # 5942 <strcmp>
    589e:	c521                	beqz	a0,58e6 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58a0:	00003597          	auipc	a1,0x3
    58a4:	91058593          	addi	a1,a1,-1776 # 81b0 <malloc+0x21fe>
    58a8:	00893503          	ld	a0,8(s2)
    58ac:	00000097          	auipc	ra,0x0
    58b0:	096080e7          	jalr	150(ra) # 5942 <strcmp>
    58b4:	cd05                	beqz	a0,58ec <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    58b6:	00893603          	ld	a2,8(s2)
    58ba:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xa4>
    58be:	02d00793          	li	a5,45
    58c2:	00f70563          	beq	a4,a5,58cc <main+0x96>
  int quick = 0;
    58c6:	4501                	li	a0,0
  int continuous = 0;
    58c8:	4581                	li	a1,0
    58ca:	b771                	j	5856 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58cc:	00003517          	auipc	a0,0x3
    58d0:	89c50513          	addi	a0,a0,-1892 # 8168 <malloc+0x21b6>
    58d4:	00000097          	auipc	ra,0x0
    58d8:	626080e7          	jalr	1574(ra) # 5efa <printf>
    exit(1);
    58dc:	4505                	li	a0,1
    58de:	00000097          	auipc	ra,0x0
    58e2:	2b4080e7          	jalr	692(ra) # 5b92 <exit>
  char *justone = 0;
    58e6:	4601                	li	a2,0
    continuous = 1;
    58e8:	4585                	li	a1,1
    58ea:	b7b5                	j	5856 <main+0x20>
    continuous = 2;
    58ec:	85a6                	mv	a1,s1
  char *justone = 0;
    58ee:	4601                	li	a2,0
    58f0:	b79d                	j	5856 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    58f2:	00003517          	auipc	a0,0x3
    58f6:	8a650513          	addi	a0,a0,-1882 # 8198 <malloc+0x21e6>
    58fa:	00000097          	auipc	ra,0x0
    58fe:	600080e7          	jalr	1536(ra) # 5efa <printf>
  exit(0);
    5902:	4501                	li	a0,0
    5904:	00000097          	auipc	ra,0x0
    5908:	28e080e7          	jalr	654(ra) # 5b92 <exit>

000000000000590c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    590c:	1141                	addi	sp,sp,-16
    590e:	e406                	sd	ra,8(sp)
    5910:	e022                	sd	s0,0(sp)
    5912:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5914:	00000097          	auipc	ra,0x0
    5918:	f22080e7          	jalr	-222(ra) # 5836 <main>
  exit(0);
    591c:	4501                	li	a0,0
    591e:	00000097          	auipc	ra,0x0
    5922:	274080e7          	jalr	628(ra) # 5b92 <exit>

0000000000005926 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5926:	1141                	addi	sp,sp,-16
    5928:	e422                	sd	s0,8(sp)
    592a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    592c:	87aa                	mv	a5,a0
    592e:	0585                	addi	a1,a1,1
    5930:	0785                	addi	a5,a5,1
    5932:	fff5c703          	lbu	a4,-1(a1)
    5936:	fee78fa3          	sb	a4,-1(a5)
    593a:	fb75                	bnez	a4,592e <strcpy+0x8>
    ;
  return os;
}
    593c:	6422                	ld	s0,8(sp)
    593e:	0141                	addi	sp,sp,16
    5940:	8082                	ret

0000000000005942 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5942:	1141                	addi	sp,sp,-16
    5944:	e422                	sd	s0,8(sp)
    5946:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5948:	00054783          	lbu	a5,0(a0)
    594c:	cb91                	beqz	a5,5960 <strcmp+0x1e>
    594e:	0005c703          	lbu	a4,0(a1)
    5952:	00f71763          	bne	a4,a5,5960 <strcmp+0x1e>
    p++, q++;
    5956:	0505                	addi	a0,a0,1
    5958:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    595a:	00054783          	lbu	a5,0(a0)
    595e:	fbe5                	bnez	a5,594e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5960:	0005c503          	lbu	a0,0(a1)
}
    5964:	40a7853b          	subw	a0,a5,a0
    5968:	6422                	ld	s0,8(sp)
    596a:	0141                	addi	sp,sp,16
    596c:	8082                	ret

000000000000596e <strlen>:

uint
strlen(const char *s)
{
    596e:	1141                	addi	sp,sp,-16
    5970:	e422                	sd	s0,8(sp)
    5972:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5974:	00054783          	lbu	a5,0(a0)
    5978:	cf91                	beqz	a5,5994 <strlen+0x26>
    597a:	0505                	addi	a0,a0,1
    597c:	87aa                	mv	a5,a0
    597e:	86be                	mv	a3,a5
    5980:	0785                	addi	a5,a5,1
    5982:	fff7c703          	lbu	a4,-1(a5)
    5986:	ff65                	bnez	a4,597e <strlen+0x10>
    5988:	40a6853b          	subw	a0,a3,a0
    598c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    598e:	6422                	ld	s0,8(sp)
    5990:	0141                	addi	sp,sp,16
    5992:	8082                	ret
  for(n = 0; s[n]; n++)
    5994:	4501                	li	a0,0
    5996:	bfe5                	j	598e <strlen+0x20>

0000000000005998 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5998:	1141                	addi	sp,sp,-16
    599a:	e422                	sd	s0,8(sp)
    599c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    599e:	ca19                	beqz	a2,59b4 <memset+0x1c>
    59a0:	87aa                	mv	a5,a0
    59a2:	1602                	slli	a2,a2,0x20
    59a4:	9201                	srli	a2,a2,0x20
    59a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    59aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59ae:	0785                	addi	a5,a5,1
    59b0:	fee79de3          	bne	a5,a4,59aa <memset+0x12>
  }
  return dst;
}
    59b4:	6422                	ld	s0,8(sp)
    59b6:	0141                	addi	sp,sp,16
    59b8:	8082                	ret

00000000000059ba <strchr>:

char*
strchr(const char *s, char c)
{
    59ba:	1141                	addi	sp,sp,-16
    59bc:	e422                	sd	s0,8(sp)
    59be:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59c0:	00054783          	lbu	a5,0(a0)
    59c4:	cb99                	beqz	a5,59da <strchr+0x20>
    if(*s == c)
    59c6:	00f58763          	beq	a1,a5,59d4 <strchr+0x1a>
  for(; *s; s++)
    59ca:	0505                	addi	a0,a0,1
    59cc:	00054783          	lbu	a5,0(a0)
    59d0:	fbfd                	bnez	a5,59c6 <strchr+0xc>
      return (char*)s;
  return 0;
    59d2:	4501                	li	a0,0
}
    59d4:	6422                	ld	s0,8(sp)
    59d6:	0141                	addi	sp,sp,16
    59d8:	8082                	ret
  return 0;
    59da:	4501                	li	a0,0
    59dc:	bfe5                	j	59d4 <strchr+0x1a>

00000000000059de <gets>:

char*
gets(char *buf, int max)
{
    59de:	711d                	addi	sp,sp,-96
    59e0:	ec86                	sd	ra,88(sp)
    59e2:	e8a2                	sd	s0,80(sp)
    59e4:	e4a6                	sd	s1,72(sp)
    59e6:	e0ca                	sd	s2,64(sp)
    59e8:	fc4e                	sd	s3,56(sp)
    59ea:	f852                	sd	s4,48(sp)
    59ec:	f456                	sd	s5,40(sp)
    59ee:	f05a                	sd	s6,32(sp)
    59f0:	ec5e                	sd	s7,24(sp)
    59f2:	1080                	addi	s0,sp,96
    59f4:	8baa                	mv	s7,a0
    59f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    59f8:	892a                	mv	s2,a0
    59fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    59fc:	4aa9                	li	s5,10
    59fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a00:	89a6                	mv	s3,s1
    5a02:	2485                	addiw	s1,s1,1
    5a04:	0344d863          	bge	s1,s4,5a34 <gets+0x56>
    cc = read(0, &c, 1);
    5a08:	4605                	li	a2,1
    5a0a:	faf40593          	addi	a1,s0,-81
    5a0e:	4501                	li	a0,0
    5a10:	00000097          	auipc	ra,0x0
    5a14:	19a080e7          	jalr	410(ra) # 5baa <read>
    if(cc < 1)
    5a18:	00a05e63          	blez	a0,5a34 <gets+0x56>
    buf[i++] = c;
    5a1c:	faf44783          	lbu	a5,-81(s0)
    5a20:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a24:	01578763          	beq	a5,s5,5a32 <gets+0x54>
    5a28:	0905                	addi	s2,s2,1
    5a2a:	fd679be3          	bne	a5,s6,5a00 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a2e:	89a6                	mv	s3,s1
    5a30:	a011                	j	5a34 <gets+0x56>
    5a32:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a34:	99de                	add	s3,s3,s7
    5a36:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a3a:	855e                	mv	a0,s7
    5a3c:	60e6                	ld	ra,88(sp)
    5a3e:	6446                	ld	s0,80(sp)
    5a40:	64a6                	ld	s1,72(sp)
    5a42:	6906                	ld	s2,64(sp)
    5a44:	79e2                	ld	s3,56(sp)
    5a46:	7a42                	ld	s4,48(sp)
    5a48:	7aa2                	ld	s5,40(sp)
    5a4a:	7b02                	ld	s6,32(sp)
    5a4c:	6be2                	ld	s7,24(sp)
    5a4e:	6125                	addi	sp,sp,96
    5a50:	8082                	ret

0000000000005a52 <stat>:

int
stat(const char *n, struct stat *st)
{
    5a52:	1101                	addi	sp,sp,-32
    5a54:	ec06                	sd	ra,24(sp)
    5a56:	e822                	sd	s0,16(sp)
    5a58:	e426                	sd	s1,8(sp)
    5a5a:	e04a                	sd	s2,0(sp)
    5a5c:	1000                	addi	s0,sp,32
    5a5e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a60:	4581                	li	a1,0
    5a62:	00000097          	auipc	ra,0x0
    5a66:	170080e7          	jalr	368(ra) # 5bd2 <open>
  if(fd < 0)
    5a6a:	02054563          	bltz	a0,5a94 <stat+0x42>
    5a6e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5a70:	85ca                	mv	a1,s2
    5a72:	00000097          	auipc	ra,0x0
    5a76:	178080e7          	jalr	376(ra) # 5bea <fstat>
    5a7a:	892a                	mv	s2,a0
  close(fd);
    5a7c:	8526                	mv	a0,s1
    5a7e:	00000097          	auipc	ra,0x0
    5a82:	13c080e7          	jalr	316(ra) # 5bba <close>
  return r;
}
    5a86:	854a                	mv	a0,s2
    5a88:	60e2                	ld	ra,24(sp)
    5a8a:	6442                	ld	s0,16(sp)
    5a8c:	64a2                	ld	s1,8(sp)
    5a8e:	6902                	ld	s2,0(sp)
    5a90:	6105                	addi	sp,sp,32
    5a92:	8082                	ret
    return -1;
    5a94:	597d                	li	s2,-1
    5a96:	bfc5                	j	5a86 <stat+0x34>

0000000000005a98 <atoi>:

int
atoi(const char *s)
{
    5a98:	1141                	addi	sp,sp,-16
    5a9a:	e422                	sd	s0,8(sp)
    5a9c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5a9e:	00054683          	lbu	a3,0(a0)
    5aa2:	fd06879b          	addiw	a5,a3,-48
    5aa6:	0ff7f793          	zext.b	a5,a5
    5aaa:	4625                	li	a2,9
    5aac:	02f66863          	bltu	a2,a5,5adc <atoi+0x44>
    5ab0:	872a                	mv	a4,a0
  n = 0;
    5ab2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5ab4:	0705                	addi	a4,a4,1
    5ab6:	0025179b          	slliw	a5,a0,0x2
    5aba:	9fa9                	addw	a5,a5,a0
    5abc:	0017979b          	slliw	a5,a5,0x1
    5ac0:	9fb5                	addw	a5,a5,a3
    5ac2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5ac6:	00074683          	lbu	a3,0(a4)
    5aca:	fd06879b          	addiw	a5,a3,-48
    5ace:	0ff7f793          	zext.b	a5,a5
    5ad2:	fef671e3          	bgeu	a2,a5,5ab4 <atoi+0x1c>
  return n;
}
    5ad6:	6422                	ld	s0,8(sp)
    5ad8:	0141                	addi	sp,sp,16
    5ada:	8082                	ret
  n = 0;
    5adc:	4501                	li	a0,0
    5ade:	bfe5                	j	5ad6 <atoi+0x3e>

0000000000005ae0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5ae0:	1141                	addi	sp,sp,-16
    5ae2:	e422                	sd	s0,8(sp)
    5ae4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5ae6:	02b57463          	bgeu	a0,a1,5b0e <memmove+0x2e>
    while(n-- > 0)
    5aea:	00c05f63          	blez	a2,5b08 <memmove+0x28>
    5aee:	1602                	slli	a2,a2,0x20
    5af0:	9201                	srli	a2,a2,0x20
    5af2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5af6:	872a                	mv	a4,a0
      *dst++ = *src++;
    5af8:	0585                	addi	a1,a1,1
    5afa:	0705                	addi	a4,a4,1
    5afc:	fff5c683          	lbu	a3,-1(a1)
    5b00:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b04:	fee79ae3          	bne	a5,a4,5af8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b08:	6422                	ld	s0,8(sp)
    5b0a:	0141                	addi	sp,sp,16
    5b0c:	8082                	ret
    dst += n;
    5b0e:	00c50733          	add	a4,a0,a2
    src += n;
    5b12:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b14:	fec05ae3          	blez	a2,5b08 <memmove+0x28>
    5b18:	fff6079b          	addiw	a5,a2,-1
    5b1c:	1782                	slli	a5,a5,0x20
    5b1e:	9381                	srli	a5,a5,0x20
    5b20:	fff7c793          	not	a5,a5
    5b24:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b26:	15fd                	addi	a1,a1,-1
    5b28:	177d                	addi	a4,a4,-1
    5b2a:	0005c683          	lbu	a3,0(a1)
    5b2e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b32:	fee79ae3          	bne	a5,a4,5b26 <memmove+0x46>
    5b36:	bfc9                	j	5b08 <memmove+0x28>

0000000000005b38 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b38:	1141                	addi	sp,sp,-16
    5b3a:	e422                	sd	s0,8(sp)
    5b3c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b3e:	ca05                	beqz	a2,5b6e <memcmp+0x36>
    5b40:	fff6069b          	addiw	a3,a2,-1
    5b44:	1682                	slli	a3,a3,0x20
    5b46:	9281                	srli	a3,a3,0x20
    5b48:	0685                	addi	a3,a3,1
    5b4a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b4c:	00054783          	lbu	a5,0(a0)
    5b50:	0005c703          	lbu	a4,0(a1)
    5b54:	00e79863          	bne	a5,a4,5b64 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b58:	0505                	addi	a0,a0,1
    p2++;
    5b5a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b5c:	fed518e3          	bne	a0,a3,5b4c <memcmp+0x14>
  }
  return 0;
    5b60:	4501                	li	a0,0
    5b62:	a019                	j	5b68 <memcmp+0x30>
      return *p1 - *p2;
    5b64:	40e7853b          	subw	a0,a5,a4
}
    5b68:	6422                	ld	s0,8(sp)
    5b6a:	0141                	addi	sp,sp,16
    5b6c:	8082                	ret
  return 0;
    5b6e:	4501                	li	a0,0
    5b70:	bfe5                	j	5b68 <memcmp+0x30>

0000000000005b72 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b72:	1141                	addi	sp,sp,-16
    5b74:	e406                	sd	ra,8(sp)
    5b76:	e022                	sd	s0,0(sp)
    5b78:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b7a:	00000097          	auipc	ra,0x0
    5b7e:	f66080e7          	jalr	-154(ra) # 5ae0 <memmove>
}
    5b82:	60a2                	ld	ra,8(sp)
    5b84:	6402                	ld	s0,0(sp)
    5b86:	0141                	addi	sp,sp,16
    5b88:	8082                	ret

0000000000005b8a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b8a:	4885                	li	a7,1
 ecall
    5b8c:	00000073          	ecall
 ret
    5b90:	8082                	ret

0000000000005b92 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5b92:	4889                	li	a7,2
 ecall
    5b94:	00000073          	ecall
 ret
    5b98:	8082                	ret

0000000000005b9a <wait>:
.global wait
wait:
 li a7, SYS_wait
    5b9a:	488d                	li	a7,3
 ecall
    5b9c:	00000073          	ecall
 ret
    5ba0:	8082                	ret

0000000000005ba2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5ba2:	4891                	li	a7,4
 ecall
    5ba4:	00000073          	ecall
 ret
    5ba8:	8082                	ret

0000000000005baa <read>:
.global read
read:
 li a7, SYS_read
    5baa:	4895                	li	a7,5
 ecall
    5bac:	00000073          	ecall
 ret
    5bb0:	8082                	ret

0000000000005bb2 <write>:
.global write
write:
 li a7, SYS_write
    5bb2:	48c1                	li	a7,16
 ecall
    5bb4:	00000073          	ecall
 ret
    5bb8:	8082                	ret

0000000000005bba <close>:
.global close
close:
 li a7, SYS_close
    5bba:	48d5                	li	a7,21
 ecall
    5bbc:	00000073          	ecall
 ret
    5bc0:	8082                	ret

0000000000005bc2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5bc2:	4899                	li	a7,6
 ecall
    5bc4:	00000073          	ecall
 ret
    5bc8:	8082                	ret

0000000000005bca <exec>:
.global exec
exec:
 li a7, SYS_exec
    5bca:	489d                	li	a7,7
 ecall
    5bcc:	00000073          	ecall
 ret
    5bd0:	8082                	ret

0000000000005bd2 <open>:
.global open
open:
 li a7, SYS_open
    5bd2:	48bd                	li	a7,15
 ecall
    5bd4:	00000073          	ecall
 ret
    5bd8:	8082                	ret

0000000000005bda <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5bda:	48c5                	li	a7,17
 ecall
    5bdc:	00000073          	ecall
 ret
    5be0:	8082                	ret

0000000000005be2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5be2:	48c9                	li	a7,18
 ecall
    5be4:	00000073          	ecall
 ret
    5be8:	8082                	ret

0000000000005bea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5bea:	48a1                	li	a7,8
 ecall
    5bec:	00000073          	ecall
 ret
    5bf0:	8082                	ret

0000000000005bf2 <link>:
.global link
link:
 li a7, SYS_link
    5bf2:	48cd                	li	a7,19
 ecall
    5bf4:	00000073          	ecall
 ret
    5bf8:	8082                	ret

0000000000005bfa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5bfa:	48d1                	li	a7,20
 ecall
    5bfc:	00000073          	ecall
 ret
    5c00:	8082                	ret

0000000000005c02 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c02:	48a5                	li	a7,9
 ecall
    5c04:	00000073          	ecall
 ret
    5c08:	8082                	ret

0000000000005c0a <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c0a:	48a9                	li	a7,10
 ecall
    5c0c:	00000073          	ecall
 ret
    5c10:	8082                	ret

0000000000005c12 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c12:	48ad                	li	a7,11
 ecall
    5c14:	00000073          	ecall
 ret
    5c18:	8082                	ret

0000000000005c1a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c1a:	48b1                	li	a7,12
 ecall
    5c1c:	00000073          	ecall
 ret
    5c20:	8082                	ret

0000000000005c22 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c22:	48b5                	li	a7,13
 ecall
    5c24:	00000073          	ecall
 ret
    5c28:	8082                	ret

0000000000005c2a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c2a:	48b9                	li	a7,14
 ecall
    5c2c:	00000073          	ecall
 ret
    5c30:	8082                	ret

0000000000005c32 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c32:	1101                	addi	sp,sp,-32
    5c34:	ec06                	sd	ra,24(sp)
    5c36:	e822                	sd	s0,16(sp)
    5c38:	1000                	addi	s0,sp,32
    5c3a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5c3e:	4605                	li	a2,1
    5c40:	fef40593          	addi	a1,s0,-17
    5c44:	00000097          	auipc	ra,0x0
    5c48:	f6e080e7          	jalr	-146(ra) # 5bb2 <write>
}
    5c4c:	60e2                	ld	ra,24(sp)
    5c4e:	6442                	ld	s0,16(sp)
    5c50:	6105                	addi	sp,sp,32
    5c52:	8082                	ret

0000000000005c54 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5c54:	7139                	addi	sp,sp,-64
    5c56:	fc06                	sd	ra,56(sp)
    5c58:	f822                	sd	s0,48(sp)
    5c5a:	f426                	sd	s1,40(sp)
    5c5c:	f04a                	sd	s2,32(sp)
    5c5e:	ec4e                	sd	s3,24(sp)
    5c60:	0080                	addi	s0,sp,64
    5c62:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c64:	c299                	beqz	a3,5c6a <printint+0x16>
    5c66:	0805c963          	bltz	a1,5cf8 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5c6a:	2581                	sext.w	a1,a1
  neg = 0;
    5c6c:	4881                	li	a7,0
    5c6e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5c72:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5c74:	2601                	sext.w	a2,a2
    5c76:	00003517          	auipc	a0,0x3
    5c7a:	90250513          	addi	a0,a0,-1790 # 8578 <digits>
    5c7e:	883a                	mv	a6,a4
    5c80:	2705                	addiw	a4,a4,1
    5c82:	02c5f7bb          	remuw	a5,a1,a2
    5c86:	1782                	slli	a5,a5,0x20
    5c88:	9381                	srli	a5,a5,0x20
    5c8a:	97aa                	add	a5,a5,a0
    5c8c:	0007c783          	lbu	a5,0(a5)
    5c90:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5c94:	0005879b          	sext.w	a5,a1
    5c98:	02c5d5bb          	divuw	a1,a1,a2
    5c9c:	0685                	addi	a3,a3,1
    5c9e:	fec7f0e3          	bgeu	a5,a2,5c7e <printint+0x2a>
  if(neg)
    5ca2:	00088c63          	beqz	a7,5cba <printint+0x66>
    buf[i++] = '-';
    5ca6:	fd070793          	addi	a5,a4,-48
    5caa:	00878733          	add	a4,a5,s0
    5cae:	02d00793          	li	a5,45
    5cb2:	fef70823          	sb	a5,-16(a4)
    5cb6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5cba:	02e05863          	blez	a4,5cea <printint+0x96>
    5cbe:	fc040793          	addi	a5,s0,-64
    5cc2:	00e78933          	add	s2,a5,a4
    5cc6:	fff78993          	addi	s3,a5,-1
    5cca:	99ba                	add	s3,s3,a4
    5ccc:	377d                	addiw	a4,a4,-1
    5cce:	1702                	slli	a4,a4,0x20
    5cd0:	9301                	srli	a4,a4,0x20
    5cd2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5cd6:	fff94583          	lbu	a1,-1(s2)
    5cda:	8526                	mv	a0,s1
    5cdc:	00000097          	auipc	ra,0x0
    5ce0:	f56080e7          	jalr	-170(ra) # 5c32 <putc>
  while(--i >= 0)
    5ce4:	197d                	addi	s2,s2,-1
    5ce6:	ff3918e3          	bne	s2,s3,5cd6 <printint+0x82>
}
    5cea:	70e2                	ld	ra,56(sp)
    5cec:	7442                	ld	s0,48(sp)
    5cee:	74a2                	ld	s1,40(sp)
    5cf0:	7902                	ld	s2,32(sp)
    5cf2:	69e2                	ld	s3,24(sp)
    5cf4:	6121                	addi	sp,sp,64
    5cf6:	8082                	ret
    x = -xx;
    5cf8:	40b005bb          	negw	a1,a1
    neg = 1;
    5cfc:	4885                	li	a7,1
    x = -xx;
    5cfe:	bf85                	j	5c6e <printint+0x1a>

0000000000005d00 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d00:	715d                	addi	sp,sp,-80
    5d02:	e486                	sd	ra,72(sp)
    5d04:	e0a2                	sd	s0,64(sp)
    5d06:	fc26                	sd	s1,56(sp)
    5d08:	f84a                	sd	s2,48(sp)
    5d0a:	f44e                	sd	s3,40(sp)
    5d0c:	f052                	sd	s4,32(sp)
    5d0e:	ec56                	sd	s5,24(sp)
    5d10:	e85a                	sd	s6,16(sp)
    5d12:	e45e                	sd	s7,8(sp)
    5d14:	e062                	sd	s8,0(sp)
    5d16:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d18:	0005c903          	lbu	s2,0(a1)
    5d1c:	18090c63          	beqz	s2,5eb4 <vprintf+0x1b4>
    5d20:	8aaa                	mv	s5,a0
    5d22:	8bb2                	mv	s7,a2
    5d24:	00158493          	addi	s1,a1,1
  state = 0;
    5d28:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d2a:	02500a13          	li	s4,37
    5d2e:	4b55                	li	s6,21
    5d30:	a839                	j	5d4e <vprintf+0x4e>
        putc(fd, c);
    5d32:	85ca                	mv	a1,s2
    5d34:	8556                	mv	a0,s5
    5d36:	00000097          	auipc	ra,0x0
    5d3a:	efc080e7          	jalr	-260(ra) # 5c32 <putc>
    5d3e:	a019                	j	5d44 <vprintf+0x44>
    } else if(state == '%'){
    5d40:	01498d63          	beq	s3,s4,5d5a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    5d44:	0485                	addi	s1,s1,1
    5d46:	fff4c903          	lbu	s2,-1(s1)
    5d4a:	16090563          	beqz	s2,5eb4 <vprintf+0x1b4>
    if(state == 0){
    5d4e:	fe0999e3          	bnez	s3,5d40 <vprintf+0x40>
      if(c == '%'){
    5d52:	ff4910e3          	bne	s2,s4,5d32 <vprintf+0x32>
        state = '%';
    5d56:	89d2                	mv	s3,s4
    5d58:	b7f5                	j	5d44 <vprintf+0x44>
      if(c == 'd'){
    5d5a:	13490263          	beq	s2,s4,5e7e <vprintf+0x17e>
    5d5e:	f9d9079b          	addiw	a5,s2,-99
    5d62:	0ff7f793          	zext.b	a5,a5
    5d66:	12fb6563          	bltu	s6,a5,5e90 <vprintf+0x190>
    5d6a:	f9d9079b          	addiw	a5,s2,-99
    5d6e:	0ff7f713          	zext.b	a4,a5
    5d72:	10eb6f63          	bltu	s6,a4,5e90 <vprintf+0x190>
    5d76:	00271793          	slli	a5,a4,0x2
    5d7a:	00002717          	auipc	a4,0x2
    5d7e:	7a670713          	addi	a4,a4,1958 # 8520 <malloc+0x256e>
    5d82:	97ba                	add	a5,a5,a4
    5d84:	439c                	lw	a5,0(a5)
    5d86:	97ba                	add	a5,a5,a4
    5d88:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5d8a:	008b8913          	addi	s2,s7,8
    5d8e:	4685                	li	a3,1
    5d90:	4629                	li	a2,10
    5d92:	000ba583          	lw	a1,0(s7)
    5d96:	8556                	mv	a0,s5
    5d98:	00000097          	auipc	ra,0x0
    5d9c:	ebc080e7          	jalr	-324(ra) # 5c54 <printint>
    5da0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5da2:	4981                	li	s3,0
    5da4:	b745                	j	5d44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5da6:	008b8913          	addi	s2,s7,8
    5daa:	4681                	li	a3,0
    5dac:	4629                	li	a2,10
    5dae:	000ba583          	lw	a1,0(s7)
    5db2:	8556                	mv	a0,s5
    5db4:	00000097          	auipc	ra,0x0
    5db8:	ea0080e7          	jalr	-352(ra) # 5c54 <printint>
    5dbc:	8bca                	mv	s7,s2
      state = 0;
    5dbe:	4981                	li	s3,0
    5dc0:	b751                	j	5d44 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    5dc2:	008b8913          	addi	s2,s7,8
    5dc6:	4681                	li	a3,0
    5dc8:	4641                	li	a2,16
    5dca:	000ba583          	lw	a1,0(s7)
    5dce:	8556                	mv	a0,s5
    5dd0:	00000097          	auipc	ra,0x0
    5dd4:	e84080e7          	jalr	-380(ra) # 5c54 <printint>
    5dd8:	8bca                	mv	s7,s2
      state = 0;
    5dda:	4981                	li	s3,0
    5ddc:	b7a5                	j	5d44 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    5dde:	008b8c13          	addi	s8,s7,8
    5de2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5de6:	03000593          	li	a1,48
    5dea:	8556                	mv	a0,s5
    5dec:	00000097          	auipc	ra,0x0
    5df0:	e46080e7          	jalr	-442(ra) # 5c32 <putc>
  putc(fd, 'x');
    5df4:	07800593          	li	a1,120
    5df8:	8556                	mv	a0,s5
    5dfa:	00000097          	auipc	ra,0x0
    5dfe:	e38080e7          	jalr	-456(ra) # 5c32 <putc>
    5e02:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e04:	00002b97          	auipc	s7,0x2
    5e08:	774b8b93          	addi	s7,s7,1908 # 8578 <digits>
    5e0c:	03c9d793          	srli	a5,s3,0x3c
    5e10:	97de                	add	a5,a5,s7
    5e12:	0007c583          	lbu	a1,0(a5)
    5e16:	8556                	mv	a0,s5
    5e18:	00000097          	auipc	ra,0x0
    5e1c:	e1a080e7          	jalr	-486(ra) # 5c32 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e20:	0992                	slli	s3,s3,0x4
    5e22:	397d                	addiw	s2,s2,-1
    5e24:	fe0914e3          	bnez	s2,5e0c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5e28:	8be2                	mv	s7,s8
      state = 0;
    5e2a:	4981                	li	s3,0
    5e2c:	bf21                	j	5d44 <vprintf+0x44>
        s = va_arg(ap, char*);
    5e2e:	008b8993          	addi	s3,s7,8
    5e32:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5e36:	02090163          	beqz	s2,5e58 <vprintf+0x158>
        while(*s != 0){
    5e3a:	00094583          	lbu	a1,0(s2)
    5e3e:	c9a5                	beqz	a1,5eae <vprintf+0x1ae>
          putc(fd, *s);
    5e40:	8556                	mv	a0,s5
    5e42:	00000097          	auipc	ra,0x0
    5e46:	df0080e7          	jalr	-528(ra) # 5c32 <putc>
          s++;
    5e4a:	0905                	addi	s2,s2,1
        while(*s != 0){
    5e4c:	00094583          	lbu	a1,0(s2)
    5e50:	f9e5                	bnez	a1,5e40 <vprintf+0x140>
        s = va_arg(ap, char*);
    5e52:	8bce                	mv	s7,s3
      state = 0;
    5e54:	4981                	li	s3,0
    5e56:	b5fd                	j	5d44 <vprintf+0x44>
          s = "(null)";
    5e58:	00002917          	auipc	s2,0x2
    5e5c:	6c090913          	addi	s2,s2,1728 # 8518 <malloc+0x2566>
        while(*s != 0){
    5e60:	02800593          	li	a1,40
    5e64:	bff1                	j	5e40 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    5e66:	008b8913          	addi	s2,s7,8
    5e6a:	000bc583          	lbu	a1,0(s7)
    5e6e:	8556                	mv	a0,s5
    5e70:	00000097          	auipc	ra,0x0
    5e74:	dc2080e7          	jalr	-574(ra) # 5c32 <putc>
    5e78:	8bca                	mv	s7,s2
      state = 0;
    5e7a:	4981                	li	s3,0
    5e7c:	b5e1                	j	5d44 <vprintf+0x44>
        putc(fd, c);
    5e7e:	02500593          	li	a1,37
    5e82:	8556                	mv	a0,s5
    5e84:	00000097          	auipc	ra,0x0
    5e88:	dae080e7          	jalr	-594(ra) # 5c32 <putc>
      state = 0;
    5e8c:	4981                	li	s3,0
    5e8e:	bd5d                	j	5d44 <vprintf+0x44>
        putc(fd, '%');
    5e90:	02500593          	li	a1,37
    5e94:	8556                	mv	a0,s5
    5e96:	00000097          	auipc	ra,0x0
    5e9a:	d9c080e7          	jalr	-612(ra) # 5c32 <putc>
        putc(fd, c);
    5e9e:	85ca                	mv	a1,s2
    5ea0:	8556                	mv	a0,s5
    5ea2:	00000097          	auipc	ra,0x0
    5ea6:	d90080e7          	jalr	-624(ra) # 5c32 <putc>
      state = 0;
    5eaa:	4981                	li	s3,0
    5eac:	bd61                	j	5d44 <vprintf+0x44>
        s = va_arg(ap, char*);
    5eae:	8bce                	mv	s7,s3
      state = 0;
    5eb0:	4981                	li	s3,0
    5eb2:	bd49                	j	5d44 <vprintf+0x44>
    }
  }
}
    5eb4:	60a6                	ld	ra,72(sp)
    5eb6:	6406                	ld	s0,64(sp)
    5eb8:	74e2                	ld	s1,56(sp)
    5eba:	7942                	ld	s2,48(sp)
    5ebc:	79a2                	ld	s3,40(sp)
    5ebe:	7a02                	ld	s4,32(sp)
    5ec0:	6ae2                	ld	s5,24(sp)
    5ec2:	6b42                	ld	s6,16(sp)
    5ec4:	6ba2                	ld	s7,8(sp)
    5ec6:	6c02                	ld	s8,0(sp)
    5ec8:	6161                	addi	sp,sp,80
    5eca:	8082                	ret

0000000000005ecc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ecc:	715d                	addi	sp,sp,-80
    5ece:	ec06                	sd	ra,24(sp)
    5ed0:	e822                	sd	s0,16(sp)
    5ed2:	1000                	addi	s0,sp,32
    5ed4:	e010                	sd	a2,0(s0)
    5ed6:	e414                	sd	a3,8(s0)
    5ed8:	e818                	sd	a4,16(s0)
    5eda:	ec1c                	sd	a5,24(s0)
    5edc:	03043023          	sd	a6,32(s0)
    5ee0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ee4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5ee8:	8622                	mv	a2,s0
    5eea:	00000097          	auipc	ra,0x0
    5eee:	e16080e7          	jalr	-490(ra) # 5d00 <vprintf>
}
    5ef2:	60e2                	ld	ra,24(sp)
    5ef4:	6442                	ld	s0,16(sp)
    5ef6:	6161                	addi	sp,sp,80
    5ef8:	8082                	ret

0000000000005efa <printf>:

void
printf(const char *fmt, ...)
{
    5efa:	711d                	addi	sp,sp,-96
    5efc:	ec06                	sd	ra,24(sp)
    5efe:	e822                	sd	s0,16(sp)
    5f00:	1000                	addi	s0,sp,32
    5f02:	e40c                	sd	a1,8(s0)
    5f04:	e810                	sd	a2,16(s0)
    5f06:	ec14                	sd	a3,24(s0)
    5f08:	f018                	sd	a4,32(s0)
    5f0a:	f41c                	sd	a5,40(s0)
    5f0c:	03043823          	sd	a6,48(s0)
    5f10:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f14:	00840613          	addi	a2,s0,8
    5f18:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f1c:	85aa                	mv	a1,a0
    5f1e:	4505                	li	a0,1
    5f20:	00000097          	auipc	ra,0x0
    5f24:	de0080e7          	jalr	-544(ra) # 5d00 <vprintf>
}
    5f28:	60e2                	ld	ra,24(sp)
    5f2a:	6442                	ld	s0,16(sp)
    5f2c:	6125                	addi	sp,sp,96
    5f2e:	8082                	ret

0000000000005f30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f30:	1141                	addi	sp,sp,-16
    5f32:	e422                	sd	s0,8(sp)
    5f34:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f36:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f3a:	00003797          	auipc	a5,0x3
    5f3e:	5167b783          	ld	a5,1302(a5) # 9450 <freep>
    5f42:	a02d                	j	5f6c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f44:	4618                	lw	a4,8(a2)
    5f46:	9f2d                	addw	a4,a4,a1
    5f48:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f4c:	6398                	ld	a4,0(a5)
    5f4e:	6310                	ld	a2,0(a4)
    5f50:	a83d                	j	5f8e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f52:	ff852703          	lw	a4,-8(a0)
    5f56:	9f31                	addw	a4,a4,a2
    5f58:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f5a:	ff053683          	ld	a3,-16(a0)
    5f5e:	a091                	j	5fa2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f60:	6398                	ld	a4,0(a5)
    5f62:	00e7e463          	bltu	a5,a4,5f6a <free+0x3a>
    5f66:	00e6ea63          	bltu	a3,a4,5f7a <free+0x4a>
{
    5f6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f6c:	fed7fae3          	bgeu	a5,a3,5f60 <free+0x30>
    5f70:	6398                	ld	a4,0(a5)
    5f72:	00e6e463          	bltu	a3,a4,5f7a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f76:	fee7eae3          	bltu	a5,a4,5f6a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5f7a:	ff852583          	lw	a1,-8(a0)
    5f7e:	6390                	ld	a2,0(a5)
    5f80:	02059813          	slli	a6,a1,0x20
    5f84:	01c85713          	srli	a4,a6,0x1c
    5f88:	9736                	add	a4,a4,a3
    5f8a:	fae60de3          	beq	a2,a4,5f44 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5f8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5f92:	4790                	lw	a2,8(a5)
    5f94:	02061593          	slli	a1,a2,0x20
    5f98:	01c5d713          	srli	a4,a1,0x1c
    5f9c:	973e                	add	a4,a4,a5
    5f9e:	fae68ae3          	beq	a3,a4,5f52 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5fa2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5fa4:	00003717          	auipc	a4,0x3
    5fa8:	4af73623          	sd	a5,1196(a4) # 9450 <freep>
}
    5fac:	6422                	ld	s0,8(sp)
    5fae:	0141                	addi	sp,sp,16
    5fb0:	8082                	ret

0000000000005fb2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5fb2:	7139                	addi	sp,sp,-64
    5fb4:	fc06                	sd	ra,56(sp)
    5fb6:	f822                	sd	s0,48(sp)
    5fb8:	f426                	sd	s1,40(sp)
    5fba:	f04a                	sd	s2,32(sp)
    5fbc:	ec4e                	sd	s3,24(sp)
    5fbe:	e852                	sd	s4,16(sp)
    5fc0:	e456                	sd	s5,8(sp)
    5fc2:	e05a                	sd	s6,0(sp)
    5fc4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5fc6:	02051493          	slli	s1,a0,0x20
    5fca:	9081                	srli	s1,s1,0x20
    5fcc:	04bd                	addi	s1,s1,15
    5fce:	8091                	srli	s1,s1,0x4
    5fd0:	0014899b          	addiw	s3,s1,1
    5fd4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5fd6:	00003517          	auipc	a0,0x3
    5fda:	47a53503          	ld	a0,1146(a0) # 9450 <freep>
    5fde:	c515                	beqz	a0,600a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5fe0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5fe2:	4798                	lw	a4,8(a5)
    5fe4:	02977f63          	bgeu	a4,s1,6022 <malloc+0x70>
  if(nu < 4096)
    5fe8:	8a4e                	mv	s4,s3
    5fea:	0009871b          	sext.w	a4,s3
    5fee:	6685                	lui	a3,0x1
    5ff0:	00d77363          	bgeu	a4,a3,5ff6 <malloc+0x44>
    5ff4:	6a05                	lui	s4,0x1
    5ff6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ffa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5ffe:	00003917          	auipc	s2,0x3
    6002:	45290913          	addi	s2,s2,1106 # 9450 <freep>
  if(p == (char*)-1)
    6006:	5afd                	li	s5,-1
    6008:	a895                	j	607c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    600a:	0000a797          	auipc	a5,0xa
    600e:	c6e78793          	addi	a5,a5,-914 # fc78 <base>
    6012:	00003717          	auipc	a4,0x3
    6016:	42f73f23          	sd	a5,1086(a4) # 9450 <freep>
    601a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    601c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6020:	b7e1                	j	5fe8 <malloc+0x36>
      if(p->s.size == nunits)
    6022:	02e48c63          	beq	s1,a4,605a <malloc+0xa8>
        p->s.size -= nunits;
    6026:	4137073b          	subw	a4,a4,s3
    602a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    602c:	02071693          	slli	a3,a4,0x20
    6030:	01c6d713          	srli	a4,a3,0x1c
    6034:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6036:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    603a:	00003717          	auipc	a4,0x3
    603e:	40a73b23          	sd	a0,1046(a4) # 9450 <freep>
      return (void*)(p + 1);
    6042:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6046:	70e2                	ld	ra,56(sp)
    6048:	7442                	ld	s0,48(sp)
    604a:	74a2                	ld	s1,40(sp)
    604c:	7902                	ld	s2,32(sp)
    604e:	69e2                	ld	s3,24(sp)
    6050:	6a42                	ld	s4,16(sp)
    6052:	6aa2                	ld	s5,8(sp)
    6054:	6b02                	ld	s6,0(sp)
    6056:	6121                	addi	sp,sp,64
    6058:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    605a:	6398                	ld	a4,0(a5)
    605c:	e118                	sd	a4,0(a0)
    605e:	bff1                	j	603a <malloc+0x88>
  hp->s.size = nu;
    6060:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6064:	0541                	addi	a0,a0,16
    6066:	00000097          	auipc	ra,0x0
    606a:	eca080e7          	jalr	-310(ra) # 5f30 <free>
  return freep;
    606e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6072:	d971                	beqz	a0,6046 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6074:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6076:	4798                	lw	a4,8(a5)
    6078:	fa9775e3          	bgeu	a4,s1,6022 <malloc+0x70>
    if(p == freep)
    607c:	00093703          	ld	a4,0(s2)
    6080:	853e                	mv	a0,a5
    6082:	fef719e3          	bne	a4,a5,6074 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    6086:	8552                	mv	a0,s4
    6088:	00000097          	auipc	ra,0x0
    608c:	b92080e7          	jalr	-1134(ra) # 5c1a <sbrk>
  if(p == (char*)-1)
    6090:	fd5518e3          	bne	a0,s5,6060 <malloc+0xae>
        return 0;
    6094:	4501                	li	a0,0
    6096:	bf45                	j	6046 <malloc+0x94>
