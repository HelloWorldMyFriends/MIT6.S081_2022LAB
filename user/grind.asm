
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e3c080e7          	jalr	-452(ra) # ecc <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	2c650513          	addi	a0,a0,710 # 1360 <malloc+0xec>
      a2:	00001097          	auipc	ra,0x1
      a6:	e0a080e7          	jalr	-502(ra) # eac <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	2b650513          	addi	a0,a0,694 # 1360 <malloc+0xec>
      b2:	00001097          	auipc	ra,0x1
      b6:	e02080e7          	jalr	-510(ra) # eb4 <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2ac50513          	addi	a0,a0,684 # 1368 <malloc+0xf4>
      c4:	00001097          	auipc	ra,0x1
      c8:	0f8080e7          	jalr	248(ra) # 11bc <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d76080e7          	jalr	-650(ra) # e44 <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	2b250513          	addi	a0,a0,690 # 1388 <malloc+0x114>
      de:	00001097          	auipc	ra,0x1
      e2:	dd6080e7          	jalr	-554(ra) # eb4 <chdir>
      e6:	00001997          	auipc	s3,0x1
      ea:	2b298993          	addi	s3,s3,690 # 1398 <malloc+0x124>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001997          	auipc	s3,0x1
      f4:	2a098993          	addi	s3,s3,672 # 1390 <malloc+0x11c>
  uint64 iters = 0;
      f8:	4481                	li	s1,0
  int fd = -1;
      fa:	5a7d                	li	s4,-1
      fc:	00001917          	auipc	s2,0x1
     100:	54c90913          	addi	s2,s2,1356 # 1648 <malloc+0x3d4>
     104:	a839                	j	122 <go+0xaa>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     106:	20200593          	li	a1,514
     10a:	00001517          	auipc	a0,0x1
     10e:	29650513          	addi	a0,a0,662 # 13a0 <malloc+0x12c>
     112:	00001097          	auipc	ra,0x1
     116:	d72080e7          	jalr	-654(ra) # e84 <open>
     11a:	00001097          	auipc	ra,0x1
     11e:	d52080e7          	jalr	-686(ra) # e6c <close>
    iters++;
     122:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     124:	1f400793          	li	a5,500
     128:	02f4f7b3          	remu	a5,s1,a5
     12c:	eb81                	bnez	a5,13c <go+0xc4>
      write(1, which_child?"B":"A", 1);
     12e:	4605                	li	a2,1
     130:	85ce                	mv	a1,s3
     132:	4505                	li	a0,1
     134:	00001097          	auipc	ra,0x1
     138:	d30080e7          	jalr	-720(ra) # e64 <write>
    int what = rand() % 23;
     13c:	00000097          	auipc	ra,0x0
     140:	f1c080e7          	jalr	-228(ra) # 58 <rand>
     144:	47dd                	li	a5,23
     146:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     14a:	4785                	li	a5,1
     14c:	faf50de3          	beq	a0,a5,106 <go+0x8e>
    } else if(what == 2){
     150:	47d9                	li	a5,22
     152:	fca7e8e3          	bltu	a5,a0,122 <go+0xaa>
     156:	050a                	slli	a0,a0,0x2
     158:	954a                	add	a0,a0,s2
     15a:	411c                	lw	a5,0(a0)
     15c:	97ca                	add	a5,a5,s2
     15e:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     160:	20200593          	li	a1,514
     164:	00001517          	auipc	a0,0x1
     168:	24c50513          	addi	a0,a0,588 # 13b0 <malloc+0x13c>
     16c:	00001097          	auipc	ra,0x1
     170:	d18080e7          	jalr	-744(ra) # e84 <open>
     174:	00001097          	auipc	ra,0x1
     178:	cf8080e7          	jalr	-776(ra) # e6c <close>
     17c:	b75d                	j	122 <go+0xaa>
    } else if(what == 3){
      unlink("grindir/../a");
     17e:	00001517          	auipc	a0,0x1
     182:	22250513          	addi	a0,a0,546 # 13a0 <malloc+0x12c>
     186:	00001097          	auipc	ra,0x1
     18a:	d0e080e7          	jalr	-754(ra) # e94 <unlink>
     18e:	bf51                	j	122 <go+0xaa>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     190:	00001517          	auipc	a0,0x1
     194:	1d050513          	addi	a0,a0,464 # 1360 <malloc+0xec>
     198:	00001097          	auipc	ra,0x1
     19c:	d1c080e7          	jalr	-740(ra) # eb4 <chdir>
     1a0:	e115                	bnez	a0,1c4 <go+0x14c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	22650513          	addi	a0,a0,550 # 13c8 <malloc+0x154>
     1aa:	00001097          	auipc	ra,0x1
     1ae:	cea080e7          	jalr	-790(ra) # e94 <unlink>
      chdir("/");
     1b2:	00001517          	auipc	a0,0x1
     1b6:	1d650513          	addi	a0,a0,470 # 1388 <malloc+0x114>
     1ba:	00001097          	auipc	ra,0x1
     1be:	cfa080e7          	jalr	-774(ra) # eb4 <chdir>
     1c2:	b785                	j	122 <go+0xaa>
        printf("grind: chdir grindir failed\n");
     1c4:	00001517          	auipc	a0,0x1
     1c8:	1a450513          	addi	a0,a0,420 # 1368 <malloc+0xf4>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	ff0080e7          	jalr	-16(ra) # 11bc <printf>
        exit(1);
     1d4:	4505                	li	a0,1
     1d6:	00001097          	auipc	ra,0x1
     1da:	c6e080e7          	jalr	-914(ra) # e44 <exit>
    } else if(what == 5){
      close(fd);
     1de:	8552                	mv	a0,s4
     1e0:	00001097          	auipc	ra,0x1
     1e4:	c8c080e7          	jalr	-884(ra) # e6c <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1e8:	20200593          	li	a1,514
     1ec:	00001517          	auipc	a0,0x1
     1f0:	1e450513          	addi	a0,a0,484 # 13d0 <malloc+0x15c>
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c90080e7          	jalr	-880(ra) # e84 <open>
     1fc:	8a2a                	mv	s4,a0
     1fe:	b715                	j	122 <go+0xaa>
    } else if(what == 6){
      close(fd);
     200:	8552                	mv	a0,s4
     202:	00001097          	auipc	ra,0x1
     206:	c6a080e7          	jalr	-918(ra) # e6c <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	1d250513          	addi	a0,a0,466 # 13e0 <malloc+0x16c>
     216:	00001097          	auipc	ra,0x1
     21a:	c6e080e7          	jalr	-914(ra) # e84 <open>
     21e:	8a2a                	mv	s4,a0
     220:	b709                	j	122 <go+0xaa>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     222:	3e700613          	li	a2,999
     226:	00002597          	auipc	a1,0x2
     22a:	dfa58593          	addi	a1,a1,-518 # 2020 <buf.0>
     22e:	8552                	mv	a0,s4
     230:	00001097          	auipc	ra,0x1
     234:	c34080e7          	jalr	-972(ra) # e64 <write>
     238:	b5ed                	j	122 <go+0xaa>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     23a:	3e700613          	li	a2,999
     23e:	00002597          	auipc	a1,0x2
     242:	de258593          	addi	a1,a1,-542 # 2020 <buf.0>
     246:	8552                	mv	a0,s4
     248:	00001097          	auipc	ra,0x1
     24c:	c14080e7          	jalr	-1004(ra) # e5c <read>
     250:	bdc9                	j	122 <go+0xaa>
    } else if(what == 9){
      mkdir("grindir/../a");
     252:	00001517          	auipc	a0,0x1
     256:	14e50513          	addi	a0,a0,334 # 13a0 <malloc+0x12c>
     25a:	00001097          	auipc	ra,0x1
     25e:	c52080e7          	jalr	-942(ra) # eac <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     262:	20200593          	li	a1,514
     266:	00001517          	auipc	a0,0x1
     26a:	19250513          	addi	a0,a0,402 # 13f8 <malloc+0x184>
     26e:	00001097          	auipc	ra,0x1
     272:	c16080e7          	jalr	-1002(ra) # e84 <open>
     276:	00001097          	auipc	ra,0x1
     27a:	bf6080e7          	jalr	-1034(ra) # e6c <close>
      unlink("a/a");
     27e:	00001517          	auipc	a0,0x1
     282:	18a50513          	addi	a0,a0,394 # 1408 <malloc+0x194>
     286:	00001097          	auipc	ra,0x1
     28a:	c0e080e7          	jalr	-1010(ra) # e94 <unlink>
     28e:	bd51                	j	122 <go+0xaa>
    } else if(what == 10){
      mkdir("/../b");
     290:	00001517          	auipc	a0,0x1
     294:	18050513          	addi	a0,a0,384 # 1410 <malloc+0x19c>
     298:	00001097          	auipc	ra,0x1
     29c:	c14080e7          	jalr	-1004(ra) # eac <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2a0:	20200593          	li	a1,514
     2a4:	00001517          	auipc	a0,0x1
     2a8:	17450513          	addi	a0,a0,372 # 1418 <malloc+0x1a4>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	bd8080e7          	jalr	-1064(ra) # e84 <open>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	bb8080e7          	jalr	-1096(ra) # e6c <close>
      unlink("b/b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	16c50513          	addi	a0,a0,364 # 1428 <malloc+0x1b4>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	bd0080e7          	jalr	-1072(ra) # e94 <unlink>
     2cc:	bd99                	j	122 <go+0xaa>
    } else if(what == 11){
      unlink("b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	12250513          	addi	a0,a0,290 # 13f0 <malloc+0x17c>
     2d6:	00001097          	auipc	ra,0x1
     2da:	bbe080e7          	jalr	-1090(ra) # e94 <unlink>
      link("../grindir/./../a", "../b");
     2de:	00001597          	auipc	a1,0x1
     2e2:	0ea58593          	addi	a1,a1,234 # 13c8 <malloc+0x154>
     2e6:	00001517          	auipc	a0,0x1
     2ea:	14a50513          	addi	a0,a0,330 # 1430 <malloc+0x1bc>
     2ee:	00001097          	auipc	ra,0x1
     2f2:	bb6080e7          	jalr	-1098(ra) # ea4 <link>
     2f6:	b535                	j	122 <go+0xaa>
    } else if(what == 12){
      unlink("../grindir/../a");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	15050513          	addi	a0,a0,336 # 1448 <malloc+0x1d4>
     300:	00001097          	auipc	ra,0x1
     304:	b94080e7          	jalr	-1132(ra) # e94 <unlink>
      link(".././b", "/grindir/../a");
     308:	00001597          	auipc	a1,0x1
     30c:	0c858593          	addi	a1,a1,200 # 13d0 <malloc+0x15c>
     310:	00001517          	auipc	a0,0x1
     314:	14850513          	addi	a0,a0,328 # 1458 <malloc+0x1e4>
     318:	00001097          	auipc	ra,0x1
     31c:	b8c080e7          	jalr	-1140(ra) # ea4 <link>
     320:	b509                	j	122 <go+0xaa>
    } else if(what == 13){
      int pid = fork();
     322:	00001097          	auipc	ra,0x1
     326:	b1a080e7          	jalr	-1254(ra) # e3c <fork>
      if(pid == 0){
     32a:	c909                	beqz	a0,33c <go+0x2c4>
        exit(0);
      } else if(pid < 0){
     32c:	00054c63          	bltz	a0,344 <go+0x2cc>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     330:	4501                	li	a0,0
     332:	00001097          	auipc	ra,0x1
     336:	b1a080e7          	jalr	-1254(ra) # e4c <wait>
     33a:	b3e5                	j	122 <go+0xaa>
        exit(0);
     33c:	00001097          	auipc	ra,0x1
     340:	b08080e7          	jalr	-1272(ra) # e44 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	11c50513          	addi	a0,a0,284 # 1460 <malloc+0x1ec>
     34c:	00001097          	auipc	ra,0x1
     350:	e70080e7          	jalr	-400(ra) # 11bc <printf>
        exit(1);
     354:	4505                	li	a0,1
     356:	00001097          	auipc	ra,0x1
     35a:	aee080e7          	jalr	-1298(ra) # e44 <exit>
    } else if(what == 14){
      int pid = fork();
     35e:	00001097          	auipc	ra,0x1
     362:	ade080e7          	jalr	-1314(ra) # e3c <fork>
      if(pid == 0){
     366:	c909                	beqz	a0,378 <go+0x300>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     368:	02054563          	bltz	a0,392 <go+0x31a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     36c:	4501                	li	a0,0
     36e:	00001097          	auipc	ra,0x1
     372:	ade080e7          	jalr	-1314(ra) # e4c <wait>
     376:	b375                	j	122 <go+0xaa>
        fork();
     378:	00001097          	auipc	ra,0x1
     37c:	ac4080e7          	jalr	-1340(ra) # e3c <fork>
        fork();
     380:	00001097          	auipc	ra,0x1
     384:	abc080e7          	jalr	-1348(ra) # e3c <fork>
        exit(0);
     388:	4501                	li	a0,0
     38a:	00001097          	auipc	ra,0x1
     38e:	aba080e7          	jalr	-1350(ra) # e44 <exit>
        printf("grind: fork failed\n");
     392:	00001517          	auipc	a0,0x1
     396:	0ce50513          	addi	a0,a0,206 # 1460 <malloc+0x1ec>
     39a:	00001097          	auipc	ra,0x1
     39e:	e22080e7          	jalr	-478(ra) # 11bc <printf>
        exit(1);
     3a2:	4505                	li	a0,1
     3a4:	00001097          	auipc	ra,0x1
     3a8:	aa0080e7          	jalr	-1376(ra) # e44 <exit>
    } else if(what == 15){
      sbrk(6011);
     3ac:	6505                	lui	a0,0x1
     3ae:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x73>
     3b2:	00001097          	auipc	ra,0x1
     3b6:	b1a080e7          	jalr	-1254(ra) # ecc <sbrk>
     3ba:	b3a5                	j	122 <go+0xaa>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3bc:	4501                	li	a0,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	b0e080e7          	jalr	-1266(ra) # ecc <sbrk>
     3c6:	d4aafee3          	bgeu	s5,a0,122 <go+0xaa>
        sbrk(-(sbrk(0) - break0));
     3ca:	4501                	li	a0,0
     3cc:	00001097          	auipc	ra,0x1
     3d0:	b00080e7          	jalr	-1280(ra) # ecc <sbrk>
     3d4:	40aa853b          	subw	a0,s5,a0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	af4080e7          	jalr	-1292(ra) # ecc <sbrk>
     3e0:	b389                	j	122 <go+0xaa>
    } else if(what == 17){
      int pid = fork();
     3e2:	00001097          	auipc	ra,0x1
     3e6:	a5a080e7          	jalr	-1446(ra) # e3c <fork>
     3ea:	8b2a                	mv	s6,a0
      if(pid == 0){
     3ec:	c51d                	beqz	a0,41a <go+0x3a2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3ee:	04054963          	bltz	a0,440 <go+0x3c8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3f2:	00001517          	auipc	a0,0x1
     3f6:	08650513          	addi	a0,a0,134 # 1478 <malloc+0x204>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	aba080e7          	jalr	-1350(ra) # eb4 <chdir>
     402:	ed21                	bnez	a0,45a <go+0x3e2>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     404:	855a                	mv	a0,s6
     406:	00001097          	auipc	ra,0x1
     40a:	a6e080e7          	jalr	-1426(ra) # e74 <kill>
      wait(0);
     40e:	4501                	li	a0,0
     410:	00001097          	auipc	ra,0x1
     414:	a3c080e7          	jalr	-1476(ra) # e4c <wait>
     418:	b329                	j	122 <go+0xaa>
        close(open("a", O_CREATE|O_RDWR));
     41a:	20200593          	li	a1,514
     41e:	00001517          	auipc	a0,0x1
     422:	02250513          	addi	a0,a0,34 # 1440 <malloc+0x1cc>
     426:	00001097          	auipc	ra,0x1
     42a:	a5e080e7          	jalr	-1442(ra) # e84 <open>
     42e:	00001097          	auipc	ra,0x1
     432:	a3e080e7          	jalr	-1474(ra) # e6c <close>
        exit(0);
     436:	4501                	li	a0,0
     438:	00001097          	auipc	ra,0x1
     43c:	a0c080e7          	jalr	-1524(ra) # e44 <exit>
        printf("grind: fork failed\n");
     440:	00001517          	auipc	a0,0x1
     444:	02050513          	addi	a0,a0,32 # 1460 <malloc+0x1ec>
     448:	00001097          	auipc	ra,0x1
     44c:	d74080e7          	jalr	-652(ra) # 11bc <printf>
        exit(1);
     450:	4505                	li	a0,1
     452:	00001097          	auipc	ra,0x1
     456:	9f2080e7          	jalr	-1550(ra) # e44 <exit>
        printf("grind: chdir failed\n");
     45a:	00001517          	auipc	a0,0x1
     45e:	02e50513          	addi	a0,a0,46 # 1488 <malloc+0x214>
     462:	00001097          	auipc	ra,0x1
     466:	d5a080e7          	jalr	-678(ra) # 11bc <printf>
        exit(1);
     46a:	4505                	li	a0,1
     46c:	00001097          	auipc	ra,0x1
     470:	9d8080e7          	jalr	-1576(ra) # e44 <exit>
    } else if(what == 18){
      int pid = fork();
     474:	00001097          	auipc	ra,0x1
     478:	9c8080e7          	jalr	-1592(ra) # e3c <fork>
      if(pid == 0){
     47c:	c909                	beqz	a0,48e <go+0x416>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     47e:	02054563          	bltz	a0,4a8 <go+0x430>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     482:	4501                	li	a0,0
     484:	00001097          	auipc	ra,0x1
     488:	9c8080e7          	jalr	-1592(ra) # e4c <wait>
     48c:	b959                	j	122 <go+0xaa>
        kill(getpid());
     48e:	00001097          	auipc	ra,0x1
     492:	a36080e7          	jalr	-1482(ra) # ec4 <getpid>
     496:	00001097          	auipc	ra,0x1
     49a:	9de080e7          	jalr	-1570(ra) # e74 <kill>
        exit(0);
     49e:	4501                	li	a0,0
     4a0:	00001097          	auipc	ra,0x1
     4a4:	9a4080e7          	jalr	-1628(ra) # e44 <exit>
        printf("grind: fork failed\n");
     4a8:	00001517          	auipc	a0,0x1
     4ac:	fb850513          	addi	a0,a0,-72 # 1460 <malloc+0x1ec>
     4b0:	00001097          	auipc	ra,0x1
     4b4:	d0c080e7          	jalr	-756(ra) # 11bc <printf>
        exit(1);
     4b8:	4505                	li	a0,1
     4ba:	00001097          	auipc	ra,0x1
     4be:	98a080e7          	jalr	-1654(ra) # e44 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4c2:	fa840513          	addi	a0,s0,-88
     4c6:	00001097          	auipc	ra,0x1
     4ca:	98e080e7          	jalr	-1650(ra) # e54 <pipe>
     4ce:	02054b63          	bltz	a0,504 <go+0x48c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4d2:	00001097          	auipc	ra,0x1
     4d6:	96a080e7          	jalr	-1686(ra) # e3c <fork>
      if(pid == 0){
     4da:	c131                	beqz	a0,51e <go+0x4a6>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4dc:	0a054a63          	bltz	a0,590 <go+0x518>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4e0:	fa842503          	lw	a0,-88(s0)
     4e4:	00001097          	auipc	ra,0x1
     4e8:	988080e7          	jalr	-1656(ra) # e6c <close>
      close(fds[1]);
     4ec:	fac42503          	lw	a0,-84(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	97c080e7          	jalr	-1668(ra) # e6c <close>
      wait(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	952080e7          	jalr	-1710(ra) # e4c <wait>
     502:	b105                	j	122 <go+0xaa>
        printf("grind: pipe failed\n");
     504:	00001517          	auipc	a0,0x1
     508:	f9c50513          	addi	a0,a0,-100 # 14a0 <malloc+0x22c>
     50c:	00001097          	auipc	ra,0x1
     510:	cb0080e7          	jalr	-848(ra) # 11bc <printf>
        exit(1);
     514:	4505                	li	a0,1
     516:	00001097          	auipc	ra,0x1
     51a:	92e080e7          	jalr	-1746(ra) # e44 <exit>
        fork();
     51e:	00001097          	auipc	ra,0x1
     522:	91e080e7          	jalr	-1762(ra) # e3c <fork>
        fork();
     526:	00001097          	auipc	ra,0x1
     52a:	916080e7          	jalr	-1770(ra) # e3c <fork>
        if(write(fds[1], "x", 1) != 1)
     52e:	4605                	li	a2,1
     530:	00001597          	auipc	a1,0x1
     534:	f8858593          	addi	a1,a1,-120 # 14b8 <malloc+0x244>
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00001097          	auipc	ra,0x1
     540:	928080e7          	jalr	-1752(ra) # e64 <write>
     544:	4785                	li	a5,1
     546:	02f51363          	bne	a0,a5,56c <go+0x4f4>
        if(read(fds[0], &c, 1) != 1)
     54a:	4605                	li	a2,1
     54c:	fa040593          	addi	a1,s0,-96
     550:	fa842503          	lw	a0,-88(s0)
     554:	00001097          	auipc	ra,0x1
     558:	908080e7          	jalr	-1784(ra) # e5c <read>
     55c:	4785                	li	a5,1
     55e:	02f51063          	bne	a0,a5,57e <go+0x506>
        exit(0);
     562:	4501                	li	a0,0
     564:	00001097          	auipc	ra,0x1
     568:	8e0080e7          	jalr	-1824(ra) # e44 <exit>
          printf("grind: pipe write failed\n");
     56c:	00001517          	auipc	a0,0x1
     570:	f5450513          	addi	a0,a0,-172 # 14c0 <malloc+0x24c>
     574:	00001097          	auipc	ra,0x1
     578:	c48080e7          	jalr	-952(ra) # 11bc <printf>
     57c:	b7f9                	j	54a <go+0x4d2>
          printf("grind: pipe read failed\n");
     57e:	00001517          	auipc	a0,0x1
     582:	f6250513          	addi	a0,a0,-158 # 14e0 <malloc+0x26c>
     586:	00001097          	auipc	ra,0x1
     58a:	c36080e7          	jalr	-970(ra) # 11bc <printf>
     58e:	bfd1                	j	562 <go+0x4ea>
        printf("grind: fork failed\n");
     590:	00001517          	auipc	a0,0x1
     594:	ed050513          	addi	a0,a0,-304 # 1460 <malloc+0x1ec>
     598:	00001097          	auipc	ra,0x1
     59c:	c24080e7          	jalr	-988(ra) # 11bc <printf>
        exit(1);
     5a0:	4505                	li	a0,1
     5a2:	00001097          	auipc	ra,0x1
     5a6:	8a2080e7          	jalr	-1886(ra) # e44 <exit>
    } else if(what == 20){
      int pid = fork();
     5aa:	00001097          	auipc	ra,0x1
     5ae:	892080e7          	jalr	-1902(ra) # e3c <fork>
      if(pid == 0){
     5b2:	c909                	beqz	a0,5c4 <go+0x54c>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5b4:	06054f63          	bltz	a0,632 <go+0x5ba>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5b8:	4501                	li	a0,0
     5ba:	00001097          	auipc	ra,0x1
     5be:	892080e7          	jalr	-1902(ra) # e4c <wait>
     5c2:	b685                	j	122 <go+0xaa>
        unlink("a");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	e7c50513          	addi	a0,a0,-388 # 1440 <malloc+0x1cc>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	8c8080e7          	jalr	-1848(ra) # e94 <unlink>
        mkdir("a");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e6c50513          	addi	a0,a0,-404 # 1440 <malloc+0x1cc>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	8d0080e7          	jalr	-1840(ra) # eac <mkdir>
        chdir("a");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e5c50513          	addi	a0,a0,-420 # 1440 <malloc+0x1cc>
     5ec:	00001097          	auipc	ra,0x1
     5f0:	8c8080e7          	jalr	-1848(ra) # eb4 <chdir>
        unlink("../a");
     5f4:	00001517          	auipc	a0,0x1
     5f8:	db450513          	addi	a0,a0,-588 # 13a8 <malloc+0x134>
     5fc:	00001097          	auipc	ra,0x1
     600:	898080e7          	jalr	-1896(ra) # e94 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     604:	20200593          	li	a1,514
     608:	00001517          	auipc	a0,0x1
     60c:	eb050513          	addi	a0,a0,-336 # 14b8 <malloc+0x244>
     610:	00001097          	auipc	ra,0x1
     614:	874080e7          	jalr	-1932(ra) # e84 <open>
        unlink("x");
     618:	00001517          	auipc	a0,0x1
     61c:	ea050513          	addi	a0,a0,-352 # 14b8 <malloc+0x244>
     620:	00001097          	auipc	ra,0x1
     624:	874080e7          	jalr	-1932(ra) # e94 <unlink>
        exit(0);
     628:	4501                	li	a0,0
     62a:	00001097          	auipc	ra,0x1
     62e:	81a080e7          	jalr	-2022(ra) # e44 <exit>
        printf("grind: fork failed\n");
     632:	00001517          	auipc	a0,0x1
     636:	e2e50513          	addi	a0,a0,-466 # 1460 <malloc+0x1ec>
     63a:	00001097          	auipc	ra,0x1
     63e:	b82080e7          	jalr	-1150(ra) # 11bc <printf>
        exit(1);
     642:	4505                	li	a0,1
     644:	00001097          	auipc	ra,0x1
     648:	800080e7          	jalr	-2048(ra) # e44 <exit>
    } else if(what == 21){
      unlink("c");
     64c:	00001517          	auipc	a0,0x1
     650:	eb450513          	addi	a0,a0,-332 # 1500 <malloc+0x28c>
     654:	00001097          	auipc	ra,0x1
     658:	840080e7          	jalr	-1984(ra) # e94 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     65c:	20200593          	li	a1,514
     660:	00001517          	auipc	a0,0x1
     664:	ea050513          	addi	a0,a0,-352 # 1500 <malloc+0x28c>
     668:	00001097          	auipc	ra,0x1
     66c:	81c080e7          	jalr	-2020(ra) # e84 <open>
     670:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     672:	04054f63          	bltz	a0,6d0 <go+0x658>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     676:	4605                	li	a2,1
     678:	00001597          	auipc	a1,0x1
     67c:	e4058593          	addi	a1,a1,-448 # 14b8 <malloc+0x244>
     680:	00000097          	auipc	ra,0x0
     684:	7e4080e7          	jalr	2020(ra) # e64 <write>
     688:	4785                	li	a5,1
     68a:	06f51063          	bne	a0,a5,6ea <go+0x672>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     68e:	fa840593          	addi	a1,s0,-88
     692:	855a                	mv	a0,s6
     694:	00001097          	auipc	ra,0x1
     698:	808080e7          	jalr	-2040(ra) # e9c <fstat>
     69c:	e525                	bnez	a0,704 <go+0x68c>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     69e:	fb843583          	ld	a1,-72(s0)
     6a2:	4785                	li	a5,1
     6a4:	06f59d63          	bne	a1,a5,71e <go+0x6a6>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6a8:	fac42583          	lw	a1,-84(s0)
     6ac:	0c800793          	li	a5,200
     6b0:	08b7e563          	bltu	a5,a1,73a <go+0x6c2>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6b4:	855a                	mv	a0,s6
     6b6:	00000097          	auipc	ra,0x0
     6ba:	7b6080e7          	jalr	1974(ra) # e6c <close>
      unlink("c");
     6be:	00001517          	auipc	a0,0x1
     6c2:	e4250513          	addi	a0,a0,-446 # 1500 <malloc+0x28c>
     6c6:	00000097          	auipc	ra,0x0
     6ca:	7ce080e7          	jalr	1998(ra) # e94 <unlink>
     6ce:	bc91                	j	122 <go+0xaa>
        printf("grind: create c failed\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	e3850513          	addi	a0,a0,-456 # 1508 <malloc+0x294>
     6d8:	00001097          	auipc	ra,0x1
     6dc:	ae4080e7          	jalr	-1308(ra) # 11bc <printf>
        exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	762080e7          	jalr	1890(ra) # e44 <exit>
        printf("grind: write c failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	e3650513          	addi	a0,a0,-458 # 1520 <malloc+0x2ac>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	aca080e7          	jalr	-1334(ra) # 11bc <printf>
        exit(1);
     6fa:	4505                	li	a0,1
     6fc:	00000097          	auipc	ra,0x0
     700:	748080e7          	jalr	1864(ra) # e44 <exit>
        printf("grind: fstat failed\n");
     704:	00001517          	auipc	a0,0x1
     708:	e3450513          	addi	a0,a0,-460 # 1538 <malloc+0x2c4>
     70c:	00001097          	auipc	ra,0x1
     710:	ab0080e7          	jalr	-1360(ra) # 11bc <printf>
        exit(1);
     714:	4505                	li	a0,1
     716:	00000097          	auipc	ra,0x0
     71a:	72e080e7          	jalr	1838(ra) # e44 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     71e:	2581                	sext.w	a1,a1
     720:	00001517          	auipc	a0,0x1
     724:	e3050513          	addi	a0,a0,-464 # 1550 <malloc+0x2dc>
     728:	00001097          	auipc	ra,0x1
     72c:	a94080e7          	jalr	-1388(ra) # 11bc <printf>
        exit(1);
     730:	4505                	li	a0,1
     732:	00000097          	auipc	ra,0x0
     736:	712080e7          	jalr	1810(ra) # e44 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     73a:	00001517          	auipc	a0,0x1
     73e:	e3e50513          	addi	a0,a0,-450 # 1578 <malloc+0x304>
     742:	00001097          	auipc	ra,0x1
     746:	a7a080e7          	jalr	-1414(ra) # 11bc <printf>
        exit(1);
     74a:	4505                	li	a0,1
     74c:	00000097          	auipc	ra,0x0
     750:	6f8080e7          	jalr	1784(ra) # e44 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     754:	f9840513          	addi	a0,s0,-104
     758:	00000097          	auipc	ra,0x0
     75c:	6fc080e7          	jalr	1788(ra) # e54 <pipe>
     760:	10054063          	bltz	a0,860 <go+0x7e8>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     764:	fa040513          	addi	a0,s0,-96
     768:	00000097          	auipc	ra,0x0
     76c:	6ec080e7          	jalr	1772(ra) # e54 <pipe>
     770:	10054663          	bltz	a0,87c <go+0x804>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     774:	00000097          	auipc	ra,0x0
     778:	6c8080e7          	jalr	1736(ra) # e3c <fork>
      if(pid1 == 0){
     77c:	10050e63          	beqz	a0,898 <go+0x820>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     780:	1c054663          	bltz	a0,94c <go+0x8d4>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     784:	00000097          	auipc	ra,0x0
     788:	6b8080e7          	jalr	1720(ra) # e3c <fork>
      if(pid2 == 0){
     78c:	1c050e63          	beqz	a0,968 <go+0x8f0>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     790:	2a054a63          	bltz	a0,a44 <go+0x9cc>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     794:	f9842503          	lw	a0,-104(s0)
     798:	00000097          	auipc	ra,0x0
     79c:	6d4080e7          	jalr	1748(ra) # e6c <close>
      close(aa[1]);
     7a0:	f9c42503          	lw	a0,-100(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6c8080e7          	jalr	1736(ra) # e6c <close>
      close(bb[1]);
     7ac:	fa442503          	lw	a0,-92(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6bc080e7          	jalr	1724(ra) # e6c <close>
      char buf[4] = { 0, 0, 0, 0 };
     7b8:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7bc:	4605                	li	a2,1
     7be:	f9040593          	addi	a1,s0,-112
     7c2:	fa042503          	lw	a0,-96(s0)
     7c6:	00000097          	auipc	ra,0x0
     7ca:	696080e7          	jalr	1686(ra) # e5c <read>
      read(bb[0], buf+1, 1);
     7ce:	4605                	li	a2,1
     7d0:	f9140593          	addi	a1,s0,-111
     7d4:	fa042503          	lw	a0,-96(s0)
     7d8:	00000097          	auipc	ra,0x0
     7dc:	684080e7          	jalr	1668(ra) # e5c <read>
      read(bb[0], buf+2, 1);
     7e0:	4605                	li	a2,1
     7e2:	f9240593          	addi	a1,s0,-110
     7e6:	fa042503          	lw	a0,-96(s0)
     7ea:	00000097          	auipc	ra,0x0
     7ee:	672080e7          	jalr	1650(ra) # e5c <read>
      close(bb[0]);
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	676080e7          	jalr	1654(ra) # e6c <close>
      int st1, st2;
      wait(&st1);
     7fe:	f9440513          	addi	a0,s0,-108
     802:	00000097          	auipc	ra,0x0
     806:	64a080e7          	jalr	1610(ra) # e4c <wait>
      wait(&st2);
     80a:	fa840513          	addi	a0,s0,-88
     80e:	00000097          	auipc	ra,0x0
     812:	63e080e7          	jalr	1598(ra) # e4c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     816:	f9442783          	lw	a5,-108(s0)
     81a:	fa842703          	lw	a4,-88(s0)
     81e:	8fd9                	or	a5,a5,a4
     820:	ef89                	bnez	a5,83a <go+0x7c2>
     822:	00001597          	auipc	a1,0x1
     826:	df658593          	addi	a1,a1,-522 # 1618 <malloc+0x3a4>
     82a:	f9040513          	addi	a0,s0,-112
     82e:	00000097          	auipc	ra,0x0
     832:	3b0080e7          	jalr	944(ra) # bde <strcmp>
     836:	8e0506e3          	beqz	a0,122 <go+0xaa>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     83a:	f9040693          	addi	a3,s0,-112
     83e:	fa842603          	lw	a2,-88(s0)
     842:	f9442583          	lw	a1,-108(s0)
     846:	00001517          	auipc	a0,0x1
     84a:	dda50513          	addi	a0,a0,-550 # 1620 <malloc+0x3ac>
     84e:	00001097          	auipc	ra,0x1
     852:	96e080e7          	jalr	-1682(ra) # 11bc <printf>
        exit(1);
     856:	4505                	li	a0,1
     858:	00000097          	auipc	ra,0x0
     85c:	5ec080e7          	jalr	1516(ra) # e44 <exit>
        fprintf(2, "grind: pipe failed\n");
     860:	00001597          	auipc	a1,0x1
     864:	c4058593          	addi	a1,a1,-960 # 14a0 <malloc+0x22c>
     868:	4509                	li	a0,2
     86a:	00001097          	auipc	ra,0x1
     86e:	924080e7          	jalr	-1756(ra) # 118e <fprintf>
        exit(1);
     872:	4505                	li	a0,1
     874:	00000097          	auipc	ra,0x0
     878:	5d0080e7          	jalr	1488(ra) # e44 <exit>
        fprintf(2, "grind: pipe failed\n");
     87c:	00001597          	auipc	a1,0x1
     880:	c2458593          	addi	a1,a1,-988 # 14a0 <malloc+0x22c>
     884:	4509                	li	a0,2
     886:	00001097          	auipc	ra,0x1
     88a:	908080e7          	jalr	-1784(ra) # 118e <fprintf>
        exit(1);
     88e:	4505                	li	a0,1
     890:	00000097          	auipc	ra,0x0
     894:	5b4080e7          	jalr	1460(ra) # e44 <exit>
        close(bb[0]);
     898:	fa042503          	lw	a0,-96(s0)
     89c:	00000097          	auipc	ra,0x0
     8a0:	5d0080e7          	jalr	1488(ra) # e6c <close>
        close(bb[1]);
     8a4:	fa442503          	lw	a0,-92(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5c4080e7          	jalr	1476(ra) # e6c <close>
        close(aa[0]);
     8b0:	f9842503          	lw	a0,-104(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5b8080e7          	jalr	1464(ra) # e6c <close>
        close(1);
     8bc:	4505                	li	a0,1
     8be:	00000097          	auipc	ra,0x0
     8c2:	5ae080e7          	jalr	1454(ra) # e6c <close>
        if(dup(aa[1]) != 1){
     8c6:	f9c42503          	lw	a0,-100(s0)
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5f2080e7          	jalr	1522(ra) # ebc <dup>
     8d2:	4785                	li	a5,1
     8d4:	02f50063          	beq	a0,a5,8f4 <go+0x87c>
          fprintf(2, "grind: dup failed\n");
     8d8:	00001597          	auipc	a1,0x1
     8dc:	cc858593          	addi	a1,a1,-824 # 15a0 <malloc+0x32c>
     8e0:	4509                	li	a0,2
     8e2:	00001097          	auipc	ra,0x1
     8e6:	8ac080e7          	jalr	-1876(ra) # 118e <fprintf>
          exit(1);
     8ea:	4505                	li	a0,1
     8ec:	00000097          	auipc	ra,0x0
     8f0:	558080e7          	jalr	1368(ra) # e44 <exit>
        close(aa[1]);
     8f4:	f9c42503          	lw	a0,-100(s0)
     8f8:	00000097          	auipc	ra,0x0
     8fc:	574080e7          	jalr	1396(ra) # e6c <close>
        char *args[3] = { "echo", "hi", 0 };
     900:	00001797          	auipc	a5,0x1
     904:	cb878793          	addi	a5,a5,-840 # 15b8 <malloc+0x344>
     908:	faf43423          	sd	a5,-88(s0)
     90c:	00001797          	auipc	a5,0x1
     910:	cb478793          	addi	a5,a5,-844 # 15c0 <malloc+0x34c>
     914:	faf43823          	sd	a5,-80(s0)
     918:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     91c:	fa840593          	addi	a1,s0,-88
     920:	00001517          	auipc	a0,0x1
     924:	ca850513          	addi	a0,a0,-856 # 15c8 <malloc+0x354>
     928:	00000097          	auipc	ra,0x0
     92c:	554080e7          	jalr	1364(ra) # e7c <exec>
        fprintf(2, "grind: echo: not found\n");
     930:	00001597          	auipc	a1,0x1
     934:	ca858593          	addi	a1,a1,-856 # 15d8 <malloc+0x364>
     938:	4509                	li	a0,2
     93a:	00001097          	auipc	ra,0x1
     93e:	854080e7          	jalr	-1964(ra) # 118e <fprintf>
        exit(2);
     942:	4509                	li	a0,2
     944:	00000097          	auipc	ra,0x0
     948:	500080e7          	jalr	1280(ra) # e44 <exit>
        fprintf(2, "grind: fork failed\n");
     94c:	00001597          	auipc	a1,0x1
     950:	b1458593          	addi	a1,a1,-1260 # 1460 <malloc+0x1ec>
     954:	4509                	li	a0,2
     956:	00001097          	auipc	ra,0x1
     95a:	838080e7          	jalr	-1992(ra) # 118e <fprintf>
        exit(3);
     95e:	450d                	li	a0,3
     960:	00000097          	auipc	ra,0x0
     964:	4e4080e7          	jalr	1252(ra) # e44 <exit>
        close(aa[1]);
     968:	f9c42503          	lw	a0,-100(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	500080e7          	jalr	1280(ra) # e6c <close>
        close(bb[0]);
     974:	fa042503          	lw	a0,-96(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4f4080e7          	jalr	1268(ra) # e6c <close>
        close(0);
     980:	4501                	li	a0,0
     982:	00000097          	auipc	ra,0x0
     986:	4ea080e7          	jalr	1258(ra) # e6c <close>
        if(dup(aa[0]) != 0){
     98a:	f9842503          	lw	a0,-104(s0)
     98e:	00000097          	auipc	ra,0x0
     992:	52e080e7          	jalr	1326(ra) # ebc <dup>
     996:	cd19                	beqz	a0,9b4 <go+0x93c>
          fprintf(2, "grind: dup failed\n");
     998:	00001597          	auipc	a1,0x1
     99c:	c0858593          	addi	a1,a1,-1016 # 15a0 <malloc+0x32c>
     9a0:	4509                	li	a0,2
     9a2:	00000097          	auipc	ra,0x0
     9a6:	7ec080e7          	jalr	2028(ra) # 118e <fprintf>
          exit(4);
     9aa:	4511                	li	a0,4
     9ac:	00000097          	auipc	ra,0x0
     9b0:	498080e7          	jalr	1176(ra) # e44 <exit>
        close(aa[0]);
     9b4:	f9842503          	lw	a0,-104(s0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	4b4080e7          	jalr	1204(ra) # e6c <close>
        close(1);
     9c0:	4505                	li	a0,1
     9c2:	00000097          	auipc	ra,0x0
     9c6:	4aa080e7          	jalr	1194(ra) # e6c <close>
        if(dup(bb[1]) != 1){
     9ca:	fa442503          	lw	a0,-92(s0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4ee080e7          	jalr	1262(ra) # ebc <dup>
     9d6:	4785                	li	a5,1
     9d8:	02f50063          	beq	a0,a5,9f8 <go+0x980>
          fprintf(2, "grind: dup failed\n");
     9dc:	00001597          	auipc	a1,0x1
     9e0:	bc458593          	addi	a1,a1,-1084 # 15a0 <malloc+0x32c>
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	7a8080e7          	jalr	1960(ra) # 118e <fprintf>
          exit(5);
     9ee:	4515                	li	a0,5
     9f0:	00000097          	auipc	ra,0x0
     9f4:	454080e7          	jalr	1108(ra) # e44 <exit>
        close(bb[1]);
     9f8:	fa442503          	lw	a0,-92(s0)
     9fc:	00000097          	auipc	ra,0x0
     a00:	470080e7          	jalr	1136(ra) # e6c <close>
        char *args[2] = { "cat", 0 };
     a04:	00001797          	auipc	a5,0x1
     a08:	bec78793          	addi	a5,a5,-1044 # 15f0 <malloc+0x37c>
     a0c:	faf43423          	sd	a5,-88(s0)
     a10:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a14:	fa840593          	addi	a1,s0,-88
     a18:	00001517          	auipc	a0,0x1
     a1c:	be050513          	addi	a0,a0,-1056 # 15f8 <malloc+0x384>
     a20:	00000097          	auipc	ra,0x0
     a24:	45c080e7          	jalr	1116(ra) # e7c <exec>
        fprintf(2, "grind: cat: not found\n");
     a28:	00001597          	auipc	a1,0x1
     a2c:	bd858593          	addi	a1,a1,-1064 # 1600 <malloc+0x38c>
     a30:	4509                	li	a0,2
     a32:	00000097          	auipc	ra,0x0
     a36:	75c080e7          	jalr	1884(ra) # 118e <fprintf>
        exit(6);
     a3a:	4519                	li	a0,6
     a3c:	00000097          	auipc	ra,0x0
     a40:	408080e7          	jalr	1032(ra) # e44 <exit>
        fprintf(2, "grind: fork failed\n");
     a44:	00001597          	auipc	a1,0x1
     a48:	a1c58593          	addi	a1,a1,-1508 # 1460 <malloc+0x1ec>
     a4c:	4509                	li	a0,2
     a4e:	00000097          	auipc	ra,0x0
     a52:	740080e7          	jalr	1856(ra) # 118e <fprintf>
        exit(7);
     a56:	451d                	li	a0,7
     a58:	00000097          	auipc	ra,0x0
     a5c:	3ec080e7          	jalr	1004(ra) # e44 <exit>

0000000000000a60 <iter>:
  }
}

void
iter()
{
     a60:	7179                	addi	sp,sp,-48
     a62:	f406                	sd	ra,40(sp)
     a64:	f022                	sd	s0,32(sp)
     a66:	ec26                	sd	s1,24(sp)
     a68:	e84a                	sd	s2,16(sp)
     a6a:	1800                	addi	s0,sp,48
  unlink("a");
     a6c:	00001517          	auipc	a0,0x1
     a70:	9d450513          	addi	a0,a0,-1580 # 1440 <malloc+0x1cc>
     a74:	00000097          	auipc	ra,0x0
     a78:	420080e7          	jalr	1056(ra) # e94 <unlink>
  unlink("b");
     a7c:	00001517          	auipc	a0,0x1
     a80:	97450513          	addi	a0,a0,-1676 # 13f0 <malloc+0x17c>
     a84:	00000097          	auipc	ra,0x0
     a88:	410080e7          	jalr	1040(ra) # e94 <unlink>
  
  int pid1 = fork();
     a8c:	00000097          	auipc	ra,0x0
     a90:	3b0080e7          	jalr	944(ra) # e3c <fork>
  if(pid1 < 0){
     a94:	02054163          	bltz	a0,ab6 <iter+0x56>
     a98:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     a9a:	e91d                	bnez	a0,ad0 <iter+0x70>
    rand_next ^= 31;
     a9c:	00001717          	auipc	a4,0x1
     aa0:	56470713          	addi	a4,a4,1380 # 2000 <rand_next>
     aa4:	631c                	ld	a5,0(a4)
     aa6:	01f7c793          	xori	a5,a5,31
     aaa:	e31c                	sd	a5,0(a4)
    go(0);
     aac:	4501                	li	a0,0
     aae:	fffff097          	auipc	ra,0xfffff
     ab2:	5ca080e7          	jalr	1482(ra) # 78 <go>
    printf("grind: fork failed\n");
     ab6:	00001517          	auipc	a0,0x1
     aba:	9aa50513          	addi	a0,a0,-1622 # 1460 <malloc+0x1ec>
     abe:	00000097          	auipc	ra,0x0
     ac2:	6fe080e7          	jalr	1790(ra) # 11bc <printf>
    exit(1);
     ac6:	4505                	li	a0,1
     ac8:	00000097          	auipc	ra,0x0
     acc:	37c080e7          	jalr	892(ra) # e44 <exit>
    exit(0);
  }

  int pid2 = fork();
     ad0:	00000097          	auipc	ra,0x0
     ad4:	36c080e7          	jalr	876(ra) # e3c <fork>
     ad8:	892a                	mv	s2,a0
  if(pid2 < 0){
     ada:	02054263          	bltz	a0,afe <iter+0x9e>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     ade:	ed0d                	bnez	a0,b18 <iter+0xb8>
    rand_next ^= 7177;
     ae0:	00001697          	auipc	a3,0x1
     ae4:	52068693          	addi	a3,a3,1312 # 2000 <rand_next>
     ae8:	629c                	ld	a5,0(a3)
     aea:	6709                	lui	a4,0x2
     aec:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x501>
     af0:	8fb9                	xor	a5,a5,a4
     af2:	e29c                	sd	a5,0(a3)
    go(1);
     af4:	4505                	li	a0,1
     af6:	fffff097          	auipc	ra,0xfffff
     afa:	582080e7          	jalr	1410(ra) # 78 <go>
    printf("grind: fork failed\n");
     afe:	00001517          	auipc	a0,0x1
     b02:	96250513          	addi	a0,a0,-1694 # 1460 <malloc+0x1ec>
     b06:	00000097          	auipc	ra,0x0
     b0a:	6b6080e7          	jalr	1718(ra) # 11bc <printf>
    exit(1);
     b0e:	4505                	li	a0,1
     b10:	00000097          	auipc	ra,0x0
     b14:	334080e7          	jalr	820(ra) # e44 <exit>
    exit(0);
  }

  int st1 = -1;
     b18:	57fd                	li	a5,-1
     b1a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b1e:	fdc40513          	addi	a0,s0,-36
     b22:	00000097          	auipc	ra,0x0
     b26:	32a080e7          	jalr	810(ra) # e4c <wait>
  if(st1 != 0){
     b2a:	fdc42783          	lw	a5,-36(s0)
     b2e:	ef99                	bnez	a5,b4c <iter+0xec>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b30:	57fd                	li	a5,-1
     b32:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b36:	fd840513          	addi	a0,s0,-40
     b3a:	00000097          	auipc	ra,0x0
     b3e:	312080e7          	jalr	786(ra) # e4c <wait>

  exit(0);
     b42:	4501                	li	a0,0
     b44:	00000097          	auipc	ra,0x0
     b48:	300080e7          	jalr	768(ra) # e44 <exit>
    kill(pid1);
     b4c:	8526                	mv	a0,s1
     b4e:	00000097          	auipc	ra,0x0
     b52:	326080e7          	jalr	806(ra) # e74 <kill>
    kill(pid2);
     b56:	854a                	mv	a0,s2
     b58:	00000097          	auipc	ra,0x0
     b5c:	31c080e7          	jalr	796(ra) # e74 <kill>
     b60:	bfc1                	j	b30 <iter+0xd0>

0000000000000b62 <main>:
}

int
main()
{
     b62:	1101                	addi	sp,sp,-32
     b64:	ec06                	sd	ra,24(sp)
     b66:	e822                	sd	s0,16(sp)
     b68:	e426                	sd	s1,8(sp)
     b6a:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b6c:	00001497          	auipc	s1,0x1
     b70:	49448493          	addi	s1,s1,1172 # 2000 <rand_next>
     b74:	a829                	j	b8e <main+0x2c>
      iter();
     b76:	00000097          	auipc	ra,0x0
     b7a:	eea080e7          	jalr	-278(ra) # a60 <iter>
    sleep(20);
     b7e:	4551                	li	a0,20
     b80:	00000097          	auipc	ra,0x0
     b84:	354080e7          	jalr	852(ra) # ed4 <sleep>
    rand_next += 1;
     b88:	609c                	ld	a5,0(s1)
     b8a:	0785                	addi	a5,a5,1
     b8c:	e09c                	sd	a5,0(s1)
    int pid = fork();
     b8e:	00000097          	auipc	ra,0x0
     b92:	2ae080e7          	jalr	686(ra) # e3c <fork>
    if(pid == 0){
     b96:	d165                	beqz	a0,b76 <main+0x14>
    if(pid > 0){
     b98:	fea053e3          	blez	a0,b7e <main+0x1c>
      wait(0);
     b9c:	4501                	li	a0,0
     b9e:	00000097          	auipc	ra,0x0
     ba2:	2ae080e7          	jalr	686(ra) # e4c <wait>
     ba6:	bfe1                	j	b7e <main+0x1c>

0000000000000ba8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e406                	sd	ra,8(sp)
     bac:	e022                	sd	s0,0(sp)
     bae:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bb0:	00000097          	auipc	ra,0x0
     bb4:	fb2080e7          	jalr	-78(ra) # b62 <main>
  exit(0);
     bb8:	4501                	li	a0,0
     bba:	00000097          	auipc	ra,0x0
     bbe:	28a080e7          	jalr	650(ra) # e44 <exit>

0000000000000bc2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bc2:	1141                	addi	sp,sp,-16
     bc4:	e422                	sd	s0,8(sp)
     bc6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bc8:	87aa                	mv	a5,a0
     bca:	0585                	addi	a1,a1,1
     bcc:	0785                	addi	a5,a5,1
     bce:	fff5c703          	lbu	a4,-1(a1)
     bd2:	fee78fa3          	sb	a4,-1(a5)
     bd6:	fb75                	bnez	a4,bca <strcpy+0x8>
    ;
  return os;
}
     bd8:	6422                	ld	s0,8(sp)
     bda:	0141                	addi	sp,sp,16
     bdc:	8082                	ret

0000000000000bde <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bde:	1141                	addi	sp,sp,-16
     be0:	e422                	sd	s0,8(sp)
     be2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     be4:	00054783          	lbu	a5,0(a0)
     be8:	cb91                	beqz	a5,bfc <strcmp+0x1e>
     bea:	0005c703          	lbu	a4,0(a1)
     bee:	00f71763          	bne	a4,a5,bfc <strcmp+0x1e>
    p++, q++;
     bf2:	0505                	addi	a0,a0,1
     bf4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	fbe5                	bnez	a5,bea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bfc:	0005c503          	lbu	a0,0(a1)
}
     c00:	40a7853b          	subw	a0,a5,a0
     c04:	6422                	ld	s0,8(sp)
     c06:	0141                	addi	sp,sp,16
     c08:	8082                	ret

0000000000000c0a <strlen>:

uint
strlen(const char *s)
{
     c0a:	1141                	addi	sp,sp,-16
     c0c:	e422                	sd	s0,8(sp)
     c0e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c10:	00054783          	lbu	a5,0(a0)
     c14:	cf91                	beqz	a5,c30 <strlen+0x26>
     c16:	0505                	addi	a0,a0,1
     c18:	87aa                	mv	a5,a0
     c1a:	86be                	mv	a3,a5
     c1c:	0785                	addi	a5,a5,1
     c1e:	fff7c703          	lbu	a4,-1(a5)
     c22:	ff65                	bnez	a4,c1a <strlen+0x10>
     c24:	40a6853b          	subw	a0,a3,a0
     c28:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c2a:	6422                	ld	s0,8(sp)
     c2c:	0141                	addi	sp,sp,16
     c2e:	8082                	ret
  for(n = 0; s[n]; n++)
     c30:	4501                	li	a0,0
     c32:	bfe5                	j	c2a <strlen+0x20>

0000000000000c34 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c34:	1141                	addi	sp,sp,-16
     c36:	e422                	sd	s0,8(sp)
     c38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c3a:	ca19                	beqz	a2,c50 <memset+0x1c>
     c3c:	87aa                	mv	a5,a0
     c3e:	1602                	slli	a2,a2,0x20
     c40:	9201                	srli	a2,a2,0x20
     c42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c46:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c4a:	0785                	addi	a5,a5,1
     c4c:	fee79de3          	bne	a5,a4,c46 <memset+0x12>
  }
  return dst;
}
     c50:	6422                	ld	s0,8(sp)
     c52:	0141                	addi	sp,sp,16
     c54:	8082                	ret

0000000000000c56 <strchr>:

char*
strchr(const char *s, char c)
{
     c56:	1141                	addi	sp,sp,-16
     c58:	e422                	sd	s0,8(sp)
     c5a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c5c:	00054783          	lbu	a5,0(a0)
     c60:	cb99                	beqz	a5,c76 <strchr+0x20>
    if(*s == c)
     c62:	00f58763          	beq	a1,a5,c70 <strchr+0x1a>
  for(; *s; s++)
     c66:	0505                	addi	a0,a0,1
     c68:	00054783          	lbu	a5,0(a0)
     c6c:	fbfd                	bnez	a5,c62 <strchr+0xc>
      return (char*)s;
  return 0;
     c6e:	4501                	li	a0,0
}
     c70:	6422                	ld	s0,8(sp)
     c72:	0141                	addi	sp,sp,16
     c74:	8082                	ret
  return 0;
     c76:	4501                	li	a0,0
     c78:	bfe5                	j	c70 <strchr+0x1a>

0000000000000c7a <gets>:

char*
gets(char *buf, int max)
{
     c7a:	711d                	addi	sp,sp,-96
     c7c:	ec86                	sd	ra,88(sp)
     c7e:	e8a2                	sd	s0,80(sp)
     c80:	e4a6                	sd	s1,72(sp)
     c82:	e0ca                	sd	s2,64(sp)
     c84:	fc4e                	sd	s3,56(sp)
     c86:	f852                	sd	s4,48(sp)
     c88:	f456                	sd	s5,40(sp)
     c8a:	f05a                	sd	s6,32(sp)
     c8c:	ec5e                	sd	s7,24(sp)
     c8e:	1080                	addi	s0,sp,96
     c90:	8baa                	mv	s7,a0
     c92:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c94:	892a                	mv	s2,a0
     c96:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c98:	4aa9                	li	s5,10
     c9a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c9c:	89a6                	mv	s3,s1
     c9e:	2485                	addiw	s1,s1,1
     ca0:	0344d863          	bge	s1,s4,cd0 <gets+0x56>
    cc = read(0, &c, 1);
     ca4:	4605                	li	a2,1
     ca6:	faf40593          	addi	a1,s0,-81
     caa:	4501                	li	a0,0
     cac:	00000097          	auipc	ra,0x0
     cb0:	1b0080e7          	jalr	432(ra) # e5c <read>
    if(cc < 1)
     cb4:	00a05e63          	blez	a0,cd0 <gets+0x56>
    buf[i++] = c;
     cb8:	faf44783          	lbu	a5,-81(s0)
     cbc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cc0:	01578763          	beq	a5,s5,cce <gets+0x54>
     cc4:	0905                	addi	s2,s2,1
     cc6:	fd679be3          	bne	a5,s6,c9c <gets+0x22>
  for(i=0; i+1 < max; ){
     cca:	89a6                	mv	s3,s1
     ccc:	a011                	j	cd0 <gets+0x56>
     cce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cd0:	99de                	add	s3,s3,s7
     cd2:	00098023          	sb	zero,0(s3)
  return buf;
}
     cd6:	855e                	mv	a0,s7
     cd8:	60e6                	ld	ra,88(sp)
     cda:	6446                	ld	s0,80(sp)
     cdc:	64a6                	ld	s1,72(sp)
     cde:	6906                	ld	s2,64(sp)
     ce0:	79e2                	ld	s3,56(sp)
     ce2:	7a42                	ld	s4,48(sp)
     ce4:	7aa2                	ld	s5,40(sp)
     ce6:	7b02                	ld	s6,32(sp)
     ce8:	6be2                	ld	s7,24(sp)
     cea:	6125                	addi	sp,sp,96
     cec:	8082                	ret

0000000000000cee <stat>:

int
stat(const char *n, struct stat *st)
{
     cee:	1101                	addi	sp,sp,-32
     cf0:	ec06                	sd	ra,24(sp)
     cf2:	e822                	sd	s0,16(sp)
     cf4:	e426                	sd	s1,8(sp)
     cf6:	e04a                	sd	s2,0(sp)
     cf8:	1000                	addi	s0,sp,32
     cfa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cfc:	4581                	li	a1,0
     cfe:	00000097          	auipc	ra,0x0
     d02:	186080e7          	jalr	390(ra) # e84 <open>
  if(fd < 0)
     d06:	02054563          	bltz	a0,d30 <stat+0x42>
     d0a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d0c:	85ca                	mv	a1,s2
     d0e:	00000097          	auipc	ra,0x0
     d12:	18e080e7          	jalr	398(ra) # e9c <fstat>
     d16:	892a                	mv	s2,a0
  close(fd);
     d18:	8526                	mv	a0,s1
     d1a:	00000097          	auipc	ra,0x0
     d1e:	152080e7          	jalr	338(ra) # e6c <close>
  return r;
}
     d22:	854a                	mv	a0,s2
     d24:	60e2                	ld	ra,24(sp)
     d26:	6442                	ld	s0,16(sp)
     d28:	64a2                	ld	s1,8(sp)
     d2a:	6902                	ld	s2,0(sp)
     d2c:	6105                	addi	sp,sp,32
     d2e:	8082                	ret
    return -1;
     d30:	597d                	li	s2,-1
     d32:	bfc5                	j	d22 <stat+0x34>

0000000000000d34 <atoi>:

int
atoi(const char *s)
{
     d34:	1141                	addi	sp,sp,-16
     d36:	e422                	sd	s0,8(sp)
     d38:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d3a:	00054683          	lbu	a3,0(a0)
     d3e:	fd06879b          	addiw	a5,a3,-48
     d42:	0ff7f793          	zext.b	a5,a5
     d46:	4625                	li	a2,9
     d48:	02f66863          	bltu	a2,a5,d78 <atoi+0x44>
     d4c:	872a                	mv	a4,a0
  n = 0;
     d4e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d50:	0705                	addi	a4,a4,1
     d52:	0025179b          	slliw	a5,a0,0x2
     d56:	9fa9                	addw	a5,a5,a0
     d58:	0017979b          	slliw	a5,a5,0x1
     d5c:	9fb5                	addw	a5,a5,a3
     d5e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d62:	00074683          	lbu	a3,0(a4)
     d66:	fd06879b          	addiw	a5,a3,-48
     d6a:	0ff7f793          	zext.b	a5,a5
     d6e:	fef671e3          	bgeu	a2,a5,d50 <atoi+0x1c>
  return n;
}
     d72:	6422                	ld	s0,8(sp)
     d74:	0141                	addi	sp,sp,16
     d76:	8082                	ret
  n = 0;
     d78:	4501                	li	a0,0
     d7a:	bfe5                	j	d72 <atoi+0x3e>

0000000000000d7c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d7c:	1141                	addi	sp,sp,-16
     d7e:	e422                	sd	s0,8(sp)
     d80:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d82:	02b57463          	bgeu	a0,a1,daa <memmove+0x2e>
    while(n-- > 0)
     d86:	00c05f63          	blez	a2,da4 <memmove+0x28>
     d8a:	1602                	slli	a2,a2,0x20
     d8c:	9201                	srli	a2,a2,0x20
     d8e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d92:	872a                	mv	a4,a0
      *dst++ = *src++;
     d94:	0585                	addi	a1,a1,1
     d96:	0705                	addi	a4,a4,1
     d98:	fff5c683          	lbu	a3,-1(a1)
     d9c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     da0:	fee79ae3          	bne	a5,a4,d94 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     da4:	6422                	ld	s0,8(sp)
     da6:	0141                	addi	sp,sp,16
     da8:	8082                	ret
    dst += n;
     daa:	00c50733          	add	a4,a0,a2
    src += n;
     dae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     db0:	fec05ae3          	blez	a2,da4 <memmove+0x28>
     db4:	fff6079b          	addiw	a5,a2,-1
     db8:	1782                	slli	a5,a5,0x20
     dba:	9381                	srli	a5,a5,0x20
     dbc:	fff7c793          	not	a5,a5
     dc0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dc2:	15fd                	addi	a1,a1,-1
     dc4:	177d                	addi	a4,a4,-1
     dc6:	0005c683          	lbu	a3,0(a1)
     dca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dce:	fee79ae3          	bne	a5,a4,dc2 <memmove+0x46>
     dd2:	bfc9                	j	da4 <memmove+0x28>

0000000000000dd4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dd4:	1141                	addi	sp,sp,-16
     dd6:	e422                	sd	s0,8(sp)
     dd8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dda:	ca05                	beqz	a2,e0a <memcmp+0x36>
     ddc:	fff6069b          	addiw	a3,a2,-1
     de0:	1682                	slli	a3,a3,0x20
     de2:	9281                	srli	a3,a3,0x20
     de4:	0685                	addi	a3,a3,1
     de6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     de8:	00054783          	lbu	a5,0(a0)
     dec:	0005c703          	lbu	a4,0(a1)
     df0:	00e79863          	bne	a5,a4,e00 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     df4:	0505                	addi	a0,a0,1
    p2++;
     df6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     df8:	fed518e3          	bne	a0,a3,de8 <memcmp+0x14>
  }
  return 0;
     dfc:	4501                	li	a0,0
     dfe:	a019                	j	e04 <memcmp+0x30>
      return *p1 - *p2;
     e00:	40e7853b          	subw	a0,a5,a4
}
     e04:	6422                	ld	s0,8(sp)
     e06:	0141                	addi	sp,sp,16
     e08:	8082                	ret
  return 0;
     e0a:	4501                	li	a0,0
     e0c:	bfe5                	j	e04 <memcmp+0x30>

0000000000000e0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e0e:	1141                	addi	sp,sp,-16
     e10:	e406                	sd	ra,8(sp)
     e12:	e022                	sd	s0,0(sp)
     e14:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e16:	00000097          	auipc	ra,0x0
     e1a:	f66080e7          	jalr	-154(ra) # d7c <memmove>
}
     e1e:	60a2                	ld	ra,8(sp)
     e20:	6402                	ld	s0,0(sp)
     e22:	0141                	addi	sp,sp,16
     e24:	8082                	ret

0000000000000e26 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     e26:	1141                	addi	sp,sp,-16
     e28:	e422                	sd	s0,8(sp)
     e2a:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     e2c:	040007b7          	lui	a5,0x4000
}
     e30:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdbf5>
     e32:	07b2                	slli	a5,a5,0xc
     e34:	4388                	lw	a0,0(a5)
     e36:	6422                	ld	s0,8(sp)
     e38:	0141                	addi	sp,sp,16
     e3a:	8082                	ret

0000000000000e3c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e3c:	4885                	li	a7,1
 ecall
     e3e:	00000073          	ecall
 ret
     e42:	8082                	ret

0000000000000e44 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e44:	4889                	li	a7,2
 ecall
     e46:	00000073          	ecall
 ret
     e4a:	8082                	ret

0000000000000e4c <wait>:
.global wait
wait:
 li a7, SYS_wait
     e4c:	488d                	li	a7,3
 ecall
     e4e:	00000073          	ecall
 ret
     e52:	8082                	ret

0000000000000e54 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e54:	4891                	li	a7,4
 ecall
     e56:	00000073          	ecall
 ret
     e5a:	8082                	ret

0000000000000e5c <read>:
.global read
read:
 li a7, SYS_read
     e5c:	4895                	li	a7,5
 ecall
     e5e:	00000073          	ecall
 ret
     e62:	8082                	ret

0000000000000e64 <write>:
.global write
write:
 li a7, SYS_write
     e64:	48c1                	li	a7,16
 ecall
     e66:	00000073          	ecall
 ret
     e6a:	8082                	ret

0000000000000e6c <close>:
.global close
close:
 li a7, SYS_close
     e6c:	48d5                	li	a7,21
 ecall
     e6e:	00000073          	ecall
 ret
     e72:	8082                	ret

0000000000000e74 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e74:	4899                	li	a7,6
 ecall
     e76:	00000073          	ecall
 ret
     e7a:	8082                	ret

0000000000000e7c <exec>:
.global exec
exec:
 li a7, SYS_exec
     e7c:	489d                	li	a7,7
 ecall
     e7e:	00000073          	ecall
 ret
     e82:	8082                	ret

0000000000000e84 <open>:
.global open
open:
 li a7, SYS_open
     e84:	48bd                	li	a7,15
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e8c:	48c5                	li	a7,17
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e94:	48c9                	li	a7,18
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e9c:	48a1                	li	a7,8
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <link>:
.global link
link:
 li a7, SYS_link
     ea4:	48cd                	li	a7,19
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     eac:	48d1                	li	a7,20
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     eb4:	48a5                	li	a7,9
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <dup>:
.global dup
dup:
 li a7, SYS_dup
     ebc:	48a9                	li	a7,10
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ec4:	48ad                	li	a7,11
 ecall
     ec6:	00000073          	ecall
 ret
     eca:	8082                	ret

0000000000000ecc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ecc:	48b1                	li	a7,12
 ecall
     ece:	00000073          	ecall
 ret
     ed2:	8082                	ret

0000000000000ed4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ed4:	48b5                	li	a7,13
 ecall
     ed6:	00000073          	ecall
 ret
     eda:	8082                	ret

0000000000000edc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     edc:	48b9                	li	a7,14
 ecall
     ede:	00000073          	ecall
 ret
     ee2:	8082                	ret

0000000000000ee4 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ee4:	48f5                	li	a7,29
 ecall
     ee6:	00000073          	ecall
 ret
     eea:	8082                	ret

0000000000000eec <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     eec:	48f9                	li	a7,30
 ecall
     eee:	00000073          	ecall
 ret
     ef2:	8082                	ret

0000000000000ef4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	1000                	addi	s0,sp,32
     efc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f00:	4605                	li	a2,1
     f02:	fef40593          	addi	a1,s0,-17
     f06:	00000097          	auipc	ra,0x0
     f0a:	f5e080e7          	jalr	-162(ra) # e64 <write>
}
     f0e:	60e2                	ld	ra,24(sp)
     f10:	6442                	ld	s0,16(sp)
     f12:	6105                	addi	sp,sp,32
     f14:	8082                	ret

0000000000000f16 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f16:	7139                	addi	sp,sp,-64
     f18:	fc06                	sd	ra,56(sp)
     f1a:	f822                	sd	s0,48(sp)
     f1c:	f426                	sd	s1,40(sp)
     f1e:	f04a                	sd	s2,32(sp)
     f20:	ec4e                	sd	s3,24(sp)
     f22:	0080                	addi	s0,sp,64
     f24:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f26:	c299                	beqz	a3,f2c <printint+0x16>
     f28:	0805c963          	bltz	a1,fba <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f2c:	2581                	sext.w	a1,a1
  neg = 0;
     f2e:	4881                	li	a7,0
     f30:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f34:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f36:	2601                	sext.w	a2,a2
     f38:	00000517          	auipc	a0,0x0
     f3c:	7d050513          	addi	a0,a0,2000 # 1708 <digits>
     f40:	883a                	mv	a6,a4
     f42:	2705                	addiw	a4,a4,1
     f44:	02c5f7bb          	remuw	a5,a1,a2
     f48:	1782                	slli	a5,a5,0x20
     f4a:	9381                	srli	a5,a5,0x20
     f4c:	97aa                	add	a5,a5,a0
     f4e:	0007c783          	lbu	a5,0(a5)
     f52:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f56:	0005879b          	sext.w	a5,a1
     f5a:	02c5d5bb          	divuw	a1,a1,a2
     f5e:	0685                	addi	a3,a3,1
     f60:	fec7f0e3          	bgeu	a5,a2,f40 <printint+0x2a>
  if(neg)
     f64:	00088c63          	beqz	a7,f7c <printint+0x66>
    buf[i++] = '-';
     f68:	fd070793          	addi	a5,a4,-48
     f6c:	00878733          	add	a4,a5,s0
     f70:	02d00793          	li	a5,45
     f74:	fef70823          	sb	a5,-16(a4)
     f78:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f7c:	02e05863          	blez	a4,fac <printint+0x96>
     f80:	fc040793          	addi	a5,s0,-64
     f84:	00e78933          	add	s2,a5,a4
     f88:	fff78993          	addi	s3,a5,-1
     f8c:	99ba                	add	s3,s3,a4
     f8e:	377d                	addiw	a4,a4,-1
     f90:	1702                	slli	a4,a4,0x20
     f92:	9301                	srli	a4,a4,0x20
     f94:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f98:	fff94583          	lbu	a1,-1(s2)
     f9c:	8526                	mv	a0,s1
     f9e:	00000097          	auipc	ra,0x0
     fa2:	f56080e7          	jalr	-170(ra) # ef4 <putc>
  while(--i >= 0)
     fa6:	197d                	addi	s2,s2,-1
     fa8:	ff3918e3          	bne	s2,s3,f98 <printint+0x82>
}
     fac:	70e2                	ld	ra,56(sp)
     fae:	7442                	ld	s0,48(sp)
     fb0:	74a2                	ld	s1,40(sp)
     fb2:	7902                	ld	s2,32(sp)
     fb4:	69e2                	ld	s3,24(sp)
     fb6:	6121                	addi	sp,sp,64
     fb8:	8082                	ret
    x = -xx;
     fba:	40b005bb          	negw	a1,a1
    neg = 1;
     fbe:	4885                	li	a7,1
    x = -xx;
     fc0:	bf85                	j	f30 <printint+0x1a>

0000000000000fc2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fc2:	715d                	addi	sp,sp,-80
     fc4:	e486                	sd	ra,72(sp)
     fc6:	e0a2                	sd	s0,64(sp)
     fc8:	fc26                	sd	s1,56(sp)
     fca:	f84a                	sd	s2,48(sp)
     fcc:	f44e                	sd	s3,40(sp)
     fce:	f052                	sd	s4,32(sp)
     fd0:	ec56                	sd	s5,24(sp)
     fd2:	e85a                	sd	s6,16(sp)
     fd4:	e45e                	sd	s7,8(sp)
     fd6:	e062                	sd	s8,0(sp)
     fd8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fda:	0005c903          	lbu	s2,0(a1)
     fde:	18090c63          	beqz	s2,1176 <vprintf+0x1b4>
     fe2:	8aaa                	mv	s5,a0
     fe4:	8bb2                	mv	s7,a2
     fe6:	00158493          	addi	s1,a1,1
  state = 0;
     fea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fec:	02500a13          	li	s4,37
     ff0:	4b55                	li	s6,21
     ff2:	a839                	j	1010 <vprintf+0x4e>
        putc(fd, c);
     ff4:	85ca                	mv	a1,s2
     ff6:	8556                	mv	a0,s5
     ff8:	00000097          	auipc	ra,0x0
     ffc:	efc080e7          	jalr	-260(ra) # ef4 <putc>
    1000:	a019                	j	1006 <vprintf+0x44>
    } else if(state == '%'){
    1002:	01498d63          	beq	s3,s4,101c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
    1006:	0485                	addi	s1,s1,1
    1008:	fff4c903          	lbu	s2,-1(s1)
    100c:	16090563          	beqz	s2,1176 <vprintf+0x1b4>
    if(state == 0){
    1010:	fe0999e3          	bnez	s3,1002 <vprintf+0x40>
      if(c == '%'){
    1014:	ff4910e3          	bne	s2,s4,ff4 <vprintf+0x32>
        state = '%';
    1018:	89d2                	mv	s3,s4
    101a:	b7f5                	j	1006 <vprintf+0x44>
      if(c == 'd'){
    101c:	13490263          	beq	s2,s4,1140 <vprintf+0x17e>
    1020:	f9d9079b          	addiw	a5,s2,-99
    1024:	0ff7f793          	zext.b	a5,a5
    1028:	12fb6563          	bltu	s6,a5,1152 <vprintf+0x190>
    102c:	f9d9079b          	addiw	a5,s2,-99
    1030:	0ff7f713          	zext.b	a4,a5
    1034:	10eb6f63          	bltu	s6,a4,1152 <vprintf+0x190>
    1038:	00271793          	slli	a5,a4,0x2
    103c:	00000717          	auipc	a4,0x0
    1040:	67470713          	addi	a4,a4,1652 # 16b0 <malloc+0x43c>
    1044:	97ba                	add	a5,a5,a4
    1046:	439c                	lw	a5,0(a5)
    1048:	97ba                	add	a5,a5,a4
    104a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    104c:	008b8913          	addi	s2,s7,8
    1050:	4685                	li	a3,1
    1052:	4629                	li	a2,10
    1054:	000ba583          	lw	a1,0(s7)
    1058:	8556                	mv	a0,s5
    105a:	00000097          	auipc	ra,0x0
    105e:	ebc080e7          	jalr	-324(ra) # f16 <printint>
    1062:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1064:	4981                	li	s3,0
    1066:	b745                	j	1006 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1068:	008b8913          	addi	s2,s7,8
    106c:	4681                	li	a3,0
    106e:	4629                	li	a2,10
    1070:	000ba583          	lw	a1,0(s7)
    1074:	8556                	mv	a0,s5
    1076:	00000097          	auipc	ra,0x0
    107a:	ea0080e7          	jalr	-352(ra) # f16 <printint>
    107e:	8bca                	mv	s7,s2
      state = 0;
    1080:	4981                	li	s3,0
    1082:	b751                	j	1006 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
    1084:	008b8913          	addi	s2,s7,8
    1088:	4681                	li	a3,0
    108a:	4641                	li	a2,16
    108c:	000ba583          	lw	a1,0(s7)
    1090:	8556                	mv	a0,s5
    1092:	00000097          	auipc	ra,0x0
    1096:	e84080e7          	jalr	-380(ra) # f16 <printint>
    109a:	8bca                	mv	s7,s2
      state = 0;
    109c:	4981                	li	s3,0
    109e:	b7a5                	j	1006 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
    10a0:	008b8c13          	addi	s8,s7,8
    10a4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10a8:	03000593          	li	a1,48
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	e46080e7          	jalr	-442(ra) # ef4 <putc>
  putc(fd, 'x');
    10b6:	07800593          	li	a1,120
    10ba:	8556                	mv	a0,s5
    10bc:	00000097          	auipc	ra,0x0
    10c0:	e38080e7          	jalr	-456(ra) # ef4 <putc>
    10c4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10c6:	00000b97          	auipc	s7,0x0
    10ca:	642b8b93          	addi	s7,s7,1602 # 1708 <digits>
    10ce:	03c9d793          	srli	a5,s3,0x3c
    10d2:	97de                	add	a5,a5,s7
    10d4:	0007c583          	lbu	a1,0(a5)
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	e1a080e7          	jalr	-486(ra) # ef4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10e2:	0992                	slli	s3,s3,0x4
    10e4:	397d                	addiw	s2,s2,-1
    10e6:	fe0914e3          	bnez	s2,10ce <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10ea:	8be2                	mv	s7,s8
      state = 0;
    10ec:	4981                	li	s3,0
    10ee:	bf21                	j	1006 <vprintf+0x44>
        s = va_arg(ap, char*);
    10f0:	008b8993          	addi	s3,s7,8
    10f4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10f8:	02090163          	beqz	s2,111a <vprintf+0x158>
        while(*s != 0){
    10fc:	00094583          	lbu	a1,0(s2)
    1100:	c9a5                	beqz	a1,1170 <vprintf+0x1ae>
          putc(fd, *s);
    1102:	8556                	mv	a0,s5
    1104:	00000097          	auipc	ra,0x0
    1108:	df0080e7          	jalr	-528(ra) # ef4 <putc>
          s++;
    110c:	0905                	addi	s2,s2,1
        while(*s != 0){
    110e:	00094583          	lbu	a1,0(s2)
    1112:	f9e5                	bnez	a1,1102 <vprintf+0x140>
        s = va_arg(ap, char*);
    1114:	8bce                	mv	s7,s3
      state = 0;
    1116:	4981                	li	s3,0
    1118:	b5fd                	j	1006 <vprintf+0x44>
          s = "(null)";
    111a:	00000917          	auipc	s2,0x0
    111e:	58e90913          	addi	s2,s2,1422 # 16a8 <malloc+0x434>
        while(*s != 0){
    1122:	02800593          	li	a1,40
    1126:	bff1                	j	1102 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
    1128:	008b8913          	addi	s2,s7,8
    112c:	000bc583          	lbu	a1,0(s7)
    1130:	8556                	mv	a0,s5
    1132:	00000097          	auipc	ra,0x0
    1136:	dc2080e7          	jalr	-574(ra) # ef4 <putc>
    113a:	8bca                	mv	s7,s2
      state = 0;
    113c:	4981                	li	s3,0
    113e:	b5e1                	j	1006 <vprintf+0x44>
        putc(fd, c);
    1140:	02500593          	li	a1,37
    1144:	8556                	mv	a0,s5
    1146:	00000097          	auipc	ra,0x0
    114a:	dae080e7          	jalr	-594(ra) # ef4 <putc>
      state = 0;
    114e:	4981                	li	s3,0
    1150:	bd5d                	j	1006 <vprintf+0x44>
        putc(fd, '%');
    1152:	02500593          	li	a1,37
    1156:	8556                	mv	a0,s5
    1158:	00000097          	auipc	ra,0x0
    115c:	d9c080e7          	jalr	-612(ra) # ef4 <putc>
        putc(fd, c);
    1160:	85ca                	mv	a1,s2
    1162:	8556                	mv	a0,s5
    1164:	00000097          	auipc	ra,0x0
    1168:	d90080e7          	jalr	-624(ra) # ef4 <putc>
      state = 0;
    116c:	4981                	li	s3,0
    116e:	bd61                	j	1006 <vprintf+0x44>
        s = va_arg(ap, char*);
    1170:	8bce                	mv	s7,s3
      state = 0;
    1172:	4981                	li	s3,0
    1174:	bd49                	j	1006 <vprintf+0x44>
    }
  }
}
    1176:	60a6                	ld	ra,72(sp)
    1178:	6406                	ld	s0,64(sp)
    117a:	74e2                	ld	s1,56(sp)
    117c:	7942                	ld	s2,48(sp)
    117e:	79a2                	ld	s3,40(sp)
    1180:	7a02                	ld	s4,32(sp)
    1182:	6ae2                	ld	s5,24(sp)
    1184:	6b42                	ld	s6,16(sp)
    1186:	6ba2                	ld	s7,8(sp)
    1188:	6c02                	ld	s8,0(sp)
    118a:	6161                	addi	sp,sp,80
    118c:	8082                	ret

000000000000118e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    118e:	715d                	addi	sp,sp,-80
    1190:	ec06                	sd	ra,24(sp)
    1192:	e822                	sd	s0,16(sp)
    1194:	1000                	addi	s0,sp,32
    1196:	e010                	sd	a2,0(s0)
    1198:	e414                	sd	a3,8(s0)
    119a:	e818                	sd	a4,16(s0)
    119c:	ec1c                	sd	a5,24(s0)
    119e:	03043023          	sd	a6,32(s0)
    11a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11aa:	8622                	mv	a2,s0
    11ac:	00000097          	auipc	ra,0x0
    11b0:	e16080e7          	jalr	-490(ra) # fc2 <vprintf>
}
    11b4:	60e2                	ld	ra,24(sp)
    11b6:	6442                	ld	s0,16(sp)
    11b8:	6161                	addi	sp,sp,80
    11ba:	8082                	ret

00000000000011bc <printf>:

void
printf(const char *fmt, ...)
{
    11bc:	711d                	addi	sp,sp,-96
    11be:	ec06                	sd	ra,24(sp)
    11c0:	e822                	sd	s0,16(sp)
    11c2:	1000                	addi	s0,sp,32
    11c4:	e40c                	sd	a1,8(s0)
    11c6:	e810                	sd	a2,16(s0)
    11c8:	ec14                	sd	a3,24(s0)
    11ca:	f018                	sd	a4,32(s0)
    11cc:	f41c                	sd	a5,40(s0)
    11ce:	03043823          	sd	a6,48(s0)
    11d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11d6:	00840613          	addi	a2,s0,8
    11da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11de:	85aa                	mv	a1,a0
    11e0:	4505                	li	a0,1
    11e2:	00000097          	auipc	ra,0x0
    11e6:	de0080e7          	jalr	-544(ra) # fc2 <vprintf>
}
    11ea:	60e2                	ld	ra,24(sp)
    11ec:	6442                	ld	s0,16(sp)
    11ee:	6125                	addi	sp,sp,96
    11f0:	8082                	ret

00000000000011f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11f2:	1141                	addi	sp,sp,-16
    11f4:	e422                	sd	s0,8(sp)
    11f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11fc:	00001797          	auipc	a5,0x1
    1200:	e147b783          	ld	a5,-492(a5) # 2010 <freep>
    1204:	a02d                	j	122e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1206:	4618                	lw	a4,8(a2)
    1208:	9f2d                	addw	a4,a4,a1
    120a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    120e:	6398                	ld	a4,0(a5)
    1210:	6310                	ld	a2,0(a4)
    1212:	a83d                	j	1250 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1214:	ff852703          	lw	a4,-8(a0)
    1218:	9f31                	addw	a4,a4,a2
    121a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    121c:	ff053683          	ld	a3,-16(a0)
    1220:	a091                	j	1264 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1222:	6398                	ld	a4,0(a5)
    1224:	00e7e463          	bltu	a5,a4,122c <free+0x3a>
    1228:	00e6ea63          	bltu	a3,a4,123c <free+0x4a>
{
    122c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    122e:	fed7fae3          	bgeu	a5,a3,1222 <free+0x30>
    1232:	6398                	ld	a4,0(a5)
    1234:	00e6e463          	bltu	a3,a4,123c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1238:	fee7eae3          	bltu	a5,a4,122c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    123c:	ff852583          	lw	a1,-8(a0)
    1240:	6390                	ld	a2,0(a5)
    1242:	02059813          	slli	a6,a1,0x20
    1246:	01c85713          	srli	a4,a6,0x1c
    124a:	9736                	add	a4,a4,a3
    124c:	fae60de3          	beq	a2,a4,1206 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1250:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1254:	4790                	lw	a2,8(a5)
    1256:	02061593          	slli	a1,a2,0x20
    125a:	01c5d713          	srli	a4,a1,0x1c
    125e:	973e                	add	a4,a4,a5
    1260:	fae68ae3          	beq	a3,a4,1214 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1264:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1266:	00001717          	auipc	a4,0x1
    126a:	daf73523          	sd	a5,-598(a4) # 2010 <freep>
}
    126e:	6422                	ld	s0,8(sp)
    1270:	0141                	addi	sp,sp,16
    1272:	8082                	ret

0000000000001274 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1274:	7139                	addi	sp,sp,-64
    1276:	fc06                	sd	ra,56(sp)
    1278:	f822                	sd	s0,48(sp)
    127a:	f426                	sd	s1,40(sp)
    127c:	f04a                	sd	s2,32(sp)
    127e:	ec4e                	sd	s3,24(sp)
    1280:	e852                	sd	s4,16(sp)
    1282:	e456                	sd	s5,8(sp)
    1284:	e05a                	sd	s6,0(sp)
    1286:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1288:	02051493          	slli	s1,a0,0x20
    128c:	9081                	srli	s1,s1,0x20
    128e:	04bd                	addi	s1,s1,15
    1290:	8091                	srli	s1,s1,0x4
    1292:	0014899b          	addiw	s3,s1,1
    1296:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1298:	00001517          	auipc	a0,0x1
    129c:	d7853503          	ld	a0,-648(a0) # 2010 <freep>
    12a0:	c515                	beqz	a0,12cc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12a4:	4798                	lw	a4,8(a5)
    12a6:	02977f63          	bgeu	a4,s1,12e4 <malloc+0x70>
  if(nu < 4096)
    12aa:	8a4e                	mv	s4,s3
    12ac:	0009871b          	sext.w	a4,s3
    12b0:	6685                	lui	a3,0x1
    12b2:	00d77363          	bgeu	a4,a3,12b8 <malloc+0x44>
    12b6:	6a05                	lui	s4,0x1
    12b8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12bc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12c0:	00001917          	auipc	s2,0x1
    12c4:	d5090913          	addi	s2,s2,-688 # 2010 <freep>
  if(p == (char*)-1)
    12c8:	5afd                	li	s5,-1
    12ca:	a895                	j	133e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    12cc:	00001797          	auipc	a5,0x1
    12d0:	13c78793          	addi	a5,a5,316 # 2408 <base>
    12d4:	00001717          	auipc	a4,0x1
    12d8:	d2f73e23          	sd	a5,-708(a4) # 2010 <freep>
    12dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12e2:	b7e1                	j	12aa <malloc+0x36>
      if(p->s.size == nunits)
    12e4:	02e48c63          	beq	s1,a4,131c <malloc+0xa8>
        p->s.size -= nunits;
    12e8:	4137073b          	subw	a4,a4,s3
    12ec:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12ee:	02071693          	slli	a3,a4,0x20
    12f2:	01c6d713          	srli	a4,a3,0x1c
    12f6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12f8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12fc:	00001717          	auipc	a4,0x1
    1300:	d0a73a23          	sd	a0,-748(a4) # 2010 <freep>
      return (void*)(p + 1);
    1304:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1308:	70e2                	ld	ra,56(sp)
    130a:	7442                	ld	s0,48(sp)
    130c:	74a2                	ld	s1,40(sp)
    130e:	7902                	ld	s2,32(sp)
    1310:	69e2                	ld	s3,24(sp)
    1312:	6a42                	ld	s4,16(sp)
    1314:	6aa2                	ld	s5,8(sp)
    1316:	6b02                	ld	s6,0(sp)
    1318:	6121                	addi	sp,sp,64
    131a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    131c:	6398                	ld	a4,0(a5)
    131e:	e118                	sd	a4,0(a0)
    1320:	bff1                	j	12fc <malloc+0x88>
  hp->s.size = nu;
    1322:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1326:	0541                	addi	a0,a0,16
    1328:	00000097          	auipc	ra,0x0
    132c:	eca080e7          	jalr	-310(ra) # 11f2 <free>
  return freep;
    1330:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1334:	d971                	beqz	a0,1308 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1336:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1338:	4798                	lw	a4,8(a5)
    133a:	fa9775e3          	bgeu	a4,s1,12e4 <malloc+0x70>
    if(p == freep)
    133e:	00093703          	ld	a4,0(s2)
    1342:	853e                	mv	a0,a5
    1344:	fef719e3          	bne	a4,a5,1336 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1348:	8552                	mv	a0,s4
    134a:	00000097          	auipc	ra,0x0
    134e:	b82080e7          	jalr	-1150(ra) # ecc <sbrk>
  if(p == (char*)-1)
    1352:	fd5518e3          	bne	a0,s5,1322 <malloc+0xae>
        return 0;
    1356:	4501                	li	a0,0
    1358:	bf45                	j	1308 <malloc+0x94>
