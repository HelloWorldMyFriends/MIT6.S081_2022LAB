
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
int status;
char byte;
char buf[BSIZE];
int pid;

int main(){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
    status = pipe(fd);
   c:	00001517          	auipc	a0,0x1
  10:	00450513          	addi	a0,a0,4 # 1010 <fd>
  14:	00000097          	auipc	ra,0x0
  18:	3fa080e7          	jalr	1018(ra) # 40e <pipe>
  1c:	00001797          	auipc	a5,0x1
  20:	fea7a623          	sw	a0,-20(a5) # 1008 <status>
    if(status == -1){
  24:	57fd                	li	a5,-1
  26:	0ef50d63          	beq	a0,a5,120 <main+0x120>
    /* an error occur */
    /* TODO */
    exit(-1);
    }

    switch(fork()){
  2a:	00000097          	auipc	ra,0x0
  2e:	3cc080e7          	jalr	972(ra) # 3f6 <fork>
  32:	57fd                	li	a5,-1
  34:	0ef50163          	beq	a0,a5,116 <main+0x116>
  38:	ed39                	bnez	a0,96 <main+0x96>
        case -1: /* Handle error */
            break;
        case 0:  /*Child - reads from pipe and reply for parents*/
            /* TODO */
            pid = getpid();
  3a:	00000097          	auipc	ra,0x0
  3e:	444080e7          	jalr	1092(ra) # 47e <getpid>
  42:	00001797          	auipc	a5,0x1
  46:	faa7af23          	sw	a0,-66(a5) # 1000 <pid>
            read(fd[0], buf, 1);
  4a:	00001497          	auipc	s1,0x1
  4e:	fd648493          	addi	s1,s1,-42 # 1020 <buf>
  52:	4605                	li	a2,1
  54:	85a6                	mv	a1,s1
  56:	00001517          	auipc	a0,0x1
  5a:	fba52503          	lw	a0,-70(a0) # 1010 <fd>
  5e:	00000097          	auipc	ra,0x0
  62:	3b8080e7          	jalr	952(ra) # 416 <read>
            if(strcmp(buf,"a") == 0){
  66:	00001597          	auipc	a1,0x1
  6a:	8ba58593          	addi	a1,a1,-1862 # 920 <malloc+0xf2>
  6e:	8526                	mv	a0,s1
  70:	00000097          	auipc	ra,0x0
  74:	13e080e7          	jalr	318(ra) # 1ae <strcmp>
  78:	c94d                	beqz	a0,12a <main+0x12a>
                printf("%d: received ping\n", pid);
                write(fd[1], "b", 1);
            }
            close(fd[0]);
  7a:	00001497          	auipc	s1,0x1
  7e:	f9648493          	addi	s1,s1,-106 # 1010 <fd>
  82:	4088                	lw	a0,0(s1)
  84:	00000097          	auipc	ra,0x0
  88:	3a2080e7          	jalr	930(ra) # 426 <close>
            close(fd[1]);
  8c:	40c8                	lw	a0,4(s1)
  8e:	00000097          	auipc	ra,0x0
  92:	398080e7          	jalr	920(ra) # 426 <close>
            

        default: /* Parent - writes to pipe and reads the answer*/
            /* TODO*/
            pid = getpid();
  96:	00000097          	auipc	ra,0x0
  9a:	3e8080e7          	jalr	1000(ra) # 47e <getpid>
  9e:	00001797          	auipc	a5,0x1
  a2:	f6a7a123          	sw	a0,-158(a5) # 1000 <pid>
            write(fd[1], "a", 1);
  a6:	00001917          	auipc	s2,0x1
  aa:	f6a90913          	addi	s2,s2,-150 # 1010 <fd>
  ae:	4605                	li	a2,1
  b0:	00001597          	auipc	a1,0x1
  b4:	87058593          	addi	a1,a1,-1936 # 920 <malloc+0xf2>
  b8:	00492503          	lw	a0,4(s2)
  bc:	00000097          	auipc	ra,0x0
  c0:	362080e7          	jalr	866(ra) # 41e <write>
            wait(0);
  c4:	4501                	li	a0,0
  c6:	00000097          	auipc	ra,0x0
  ca:	340080e7          	jalr	832(ra) # 406 <wait>
            read(fd[0], buf, 1);
  ce:	00001497          	auipc	s1,0x1
  d2:	f5248493          	addi	s1,s1,-174 # 1020 <buf>
  d6:	4605                	li	a2,1
  d8:	85a6                	mv	a1,s1
  da:	00092503          	lw	a0,0(s2)
  de:	00000097          	auipc	ra,0x0
  e2:	338080e7          	jalr	824(ra) # 416 <read>
            if(strcmp(buf,"b") == 0){
  e6:	00001597          	auipc	a1,0x1
  ea:	85a58593          	addi	a1,a1,-1958 # 940 <malloc+0x112>
  ee:	8526                	mv	a0,s1
  f0:	00000097          	auipc	ra,0x0
  f4:	0be080e7          	jalr	190(ra) # 1ae <strcmp>
  f8:	c13d                	beqz	a0,15e <main+0x15e>
                printf("%d: received pong\n", pid);
            }
            close(fd[0]);
  fa:	00001497          	auipc	s1,0x1
  fe:	f1648493          	addi	s1,s1,-234 # 1010 <fd>
 102:	4088                	lw	a0,0(s1)
 104:	00000097          	auipc	ra,0x0
 108:	322080e7          	jalr	802(ra) # 426 <close>
            close(fd[1]);
 10c:	40c8                	lw	a0,4(s1)
 10e:	00000097          	auipc	ra,0x0
 112:	318080e7          	jalr	792(ra) # 426 <close>
    }   
exit(0);
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	2e6080e7          	jalr	742(ra) # 3fe <exit>
    exit(-1);
 120:	557d                	li	a0,-1
 122:	00000097          	auipc	ra,0x0
 126:	2dc080e7          	jalr	732(ra) # 3fe <exit>
                printf("%d: received ping\n", pid);
 12a:	00001597          	auipc	a1,0x1
 12e:	ed65a583          	lw	a1,-298(a1) # 1000 <pid>
 132:	00000517          	auipc	a0,0x0
 136:	7f650513          	addi	a0,a0,2038 # 928 <malloc+0xfa>
 13a:	00000097          	auipc	ra,0x0
 13e:	63c080e7          	jalr	1596(ra) # 776 <printf>
                write(fd[1], "b", 1);
 142:	4605                	li	a2,1
 144:	00000597          	auipc	a1,0x0
 148:	7fc58593          	addi	a1,a1,2044 # 940 <malloc+0x112>
 14c:	00001517          	auipc	a0,0x1
 150:	ec852503          	lw	a0,-312(a0) # 1014 <fd+0x4>
 154:	00000097          	auipc	ra,0x0
 158:	2ca080e7          	jalr	714(ra) # 41e <write>
 15c:	bf39                	j	7a <main+0x7a>
                printf("%d: received pong\n", pid);
 15e:	00001597          	auipc	a1,0x1
 162:	ea25a583          	lw	a1,-350(a1) # 1000 <pid>
 166:	00000517          	auipc	a0,0x0
 16a:	7e250513          	addi	a0,a0,2018 # 948 <malloc+0x11a>
 16e:	00000097          	auipc	ra,0x0
 172:	608080e7          	jalr	1544(ra) # 776 <printf>
 176:	b751                	j	fa <main+0xfa>

0000000000000178 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 180:	00000097          	auipc	ra,0x0
 184:	e80080e7          	jalr	-384(ra) # 0 <main>
  exit(0);
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	274080e7          	jalr	628(ra) # 3fe <exit>

0000000000000192 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 198:	87aa                	mv	a5,a0
 19a:	0585                	addi	a1,a1,1
 19c:	0785                	addi	a5,a5,1
 19e:	fff5c703          	lbu	a4,-1(a1)
 1a2:	fee78fa3          	sb	a4,-1(a5)
 1a6:	fb75                	bnez	a4,19a <strcpy+0x8>
    ;
  return os;
}
 1a8:	6422                	ld	s0,8(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cb91                	beqz	a5,1cc <strcmp+0x1e>
 1ba:	0005c703          	lbu	a4,0(a1)
 1be:	00f71763          	bne	a4,a5,1cc <strcmp+0x1e>
    p++, q++;
 1c2:	0505                	addi	a0,a0,1
 1c4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	fbe5                	bnez	a5,1ba <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1cc:	0005c503          	lbu	a0,0(a1)
}
 1d0:	40a7853b          	subw	a0,a5,a0
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strlen>:

uint
strlen(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cf91                	beqz	a5,200 <strlen+0x26>
 1e6:	0505                	addi	a0,a0,1
 1e8:	87aa                	mv	a5,a0
 1ea:	86be                	mv	a3,a5
 1ec:	0785                	addi	a5,a5,1
 1ee:	fff7c703          	lbu	a4,-1(a5)
 1f2:	ff65                	bnez	a4,1ea <strlen+0x10>
 1f4:	40a6853b          	subw	a0,a3,a0
 1f8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1fa:	6422                	ld	s0,8(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret
  for(n = 0; s[n]; n++)
 200:	4501                	li	a0,0
 202:	bfe5                	j	1fa <strlen+0x20>

0000000000000204 <memset>:

void*
memset(void *dst, int c, uint n)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20a:	ca19                	beqz	a2,220 <memset+0x1c>
 20c:	87aa                	mv	a5,a0
 20e:	1602                	slli	a2,a2,0x20
 210:	9201                	srli	a2,a2,0x20
 212:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 216:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 21a:	0785                	addi	a5,a5,1
 21c:	fee79de3          	bne	a5,a4,216 <memset+0x12>
  }
  return dst;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret

0000000000000226 <strchr>:

char*
strchr(const char *s, char c)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 22c:	00054783          	lbu	a5,0(a0)
 230:	cb99                	beqz	a5,246 <strchr+0x20>
    if(*s == c)
 232:	00f58763          	beq	a1,a5,240 <strchr+0x1a>
  for(; *s; s++)
 236:	0505                	addi	a0,a0,1
 238:	00054783          	lbu	a5,0(a0)
 23c:	fbfd                	bnez	a5,232 <strchr+0xc>
      return (char*)s;
  return 0;
 23e:	4501                	li	a0,0
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  return 0;
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <strchr+0x1a>

000000000000024a <gets>:

char*
gets(char *buf, int max)
{
 24a:	711d                	addi	sp,sp,-96
 24c:	ec86                	sd	ra,88(sp)
 24e:	e8a2                	sd	s0,80(sp)
 250:	e4a6                	sd	s1,72(sp)
 252:	e0ca                	sd	s2,64(sp)
 254:	fc4e                	sd	s3,56(sp)
 256:	f852                	sd	s4,48(sp)
 258:	f456                	sd	s5,40(sp)
 25a:	f05a                	sd	s6,32(sp)
 25c:	ec5e                	sd	s7,24(sp)
 25e:	1080                	addi	s0,sp,96
 260:	8baa                	mv	s7,a0
 262:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 264:	892a                	mv	s2,a0
 266:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 268:	4aa9                	li	s5,10
 26a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 26c:	89a6                	mv	s3,s1
 26e:	2485                	addiw	s1,s1,1
 270:	0344d863          	bge	s1,s4,2a0 <gets+0x56>
    cc = read(0, &c, 1);
 274:	4605                	li	a2,1
 276:	faf40593          	addi	a1,s0,-81
 27a:	4501                	li	a0,0
 27c:	00000097          	auipc	ra,0x0
 280:	19a080e7          	jalr	410(ra) # 416 <read>
    if(cc < 1)
 284:	00a05e63          	blez	a0,2a0 <gets+0x56>
    buf[i++] = c;
 288:	faf44783          	lbu	a5,-81(s0)
 28c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 290:	01578763          	beq	a5,s5,29e <gets+0x54>
 294:	0905                	addi	s2,s2,1
 296:	fd679be3          	bne	a5,s6,26c <gets+0x22>
  for(i=0; i+1 < max; ){
 29a:	89a6                	mv	s3,s1
 29c:	a011                	j	2a0 <gets+0x56>
 29e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a0:	99de                	add	s3,s3,s7
 2a2:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a6:	855e                	mv	a0,s7
 2a8:	60e6                	ld	ra,88(sp)
 2aa:	6446                	ld	s0,80(sp)
 2ac:	64a6                	ld	s1,72(sp)
 2ae:	6906                	ld	s2,64(sp)
 2b0:	79e2                	ld	s3,56(sp)
 2b2:	7a42                	ld	s4,48(sp)
 2b4:	7aa2                	ld	s5,40(sp)
 2b6:	7b02                	ld	s6,32(sp)
 2b8:	6be2                	ld	s7,24(sp)
 2ba:	6125                	addi	sp,sp,96
 2bc:	8082                	ret

00000000000002be <stat>:

int
stat(const char *n, struct stat *st)
{
 2be:	1101                	addi	sp,sp,-32
 2c0:	ec06                	sd	ra,24(sp)
 2c2:	e822                	sd	s0,16(sp)
 2c4:	e426                	sd	s1,8(sp)
 2c6:	e04a                	sd	s2,0(sp)
 2c8:	1000                	addi	s0,sp,32
 2ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cc:	4581                	li	a1,0
 2ce:	00000097          	auipc	ra,0x0
 2d2:	170080e7          	jalr	368(ra) # 43e <open>
  if(fd < 0)
 2d6:	02054563          	bltz	a0,300 <stat+0x42>
 2da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2dc:	85ca                	mv	a1,s2
 2de:	00000097          	auipc	ra,0x0
 2e2:	178080e7          	jalr	376(ra) # 456 <fstat>
 2e6:	892a                	mv	s2,a0
  close(fd);
 2e8:	8526                	mv	a0,s1
 2ea:	00000097          	auipc	ra,0x0
 2ee:	13c080e7          	jalr	316(ra) # 426 <close>
  return r;
}
 2f2:	854a                	mv	a0,s2
 2f4:	60e2                	ld	ra,24(sp)
 2f6:	6442                	ld	s0,16(sp)
 2f8:	64a2                	ld	s1,8(sp)
 2fa:	6902                	ld	s2,0(sp)
 2fc:	6105                	addi	sp,sp,32
 2fe:	8082                	ret
    return -1;
 300:	597d                	li	s2,-1
 302:	bfc5                	j	2f2 <stat+0x34>

0000000000000304 <atoi>:

int
atoi(const char *s)
{
 304:	1141                	addi	sp,sp,-16
 306:	e422                	sd	s0,8(sp)
 308:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30a:	00054683          	lbu	a3,0(a0)
 30e:	fd06879b          	addiw	a5,a3,-48
 312:	0ff7f793          	zext.b	a5,a5
 316:	4625                	li	a2,9
 318:	02f66863          	bltu	a2,a5,348 <atoi+0x44>
 31c:	872a                	mv	a4,a0
  n = 0;
 31e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 320:	0705                	addi	a4,a4,1
 322:	0025179b          	slliw	a5,a0,0x2
 326:	9fa9                	addw	a5,a5,a0
 328:	0017979b          	slliw	a5,a5,0x1
 32c:	9fb5                	addw	a5,a5,a3
 32e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 332:	00074683          	lbu	a3,0(a4)
 336:	fd06879b          	addiw	a5,a3,-48
 33a:	0ff7f793          	zext.b	a5,a5
 33e:	fef671e3          	bgeu	a2,a5,320 <atoi+0x1c>
  return n;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  n = 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <atoi+0x3e>

000000000000034c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e422                	sd	s0,8(sp)
 350:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 352:	02b57463          	bgeu	a0,a1,37a <memmove+0x2e>
    while(n-- > 0)
 356:	00c05f63          	blez	a2,374 <memmove+0x28>
 35a:	1602                	slli	a2,a2,0x20
 35c:	9201                	srli	a2,a2,0x20
 35e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 362:	872a                	mv	a4,a0
      *dst++ = *src++;
 364:	0585                	addi	a1,a1,1
 366:	0705                	addi	a4,a4,1
 368:	fff5c683          	lbu	a3,-1(a1)
 36c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 370:	fee79ae3          	bne	a5,a4,364 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
    dst += n;
 37a:	00c50733          	add	a4,a0,a2
    src += n;
 37e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 380:	fec05ae3          	blez	a2,374 <memmove+0x28>
 384:	fff6079b          	addiw	a5,a2,-1
 388:	1782                	slli	a5,a5,0x20
 38a:	9381                	srli	a5,a5,0x20
 38c:	fff7c793          	not	a5,a5
 390:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 392:	15fd                	addi	a1,a1,-1
 394:	177d                	addi	a4,a4,-1
 396:	0005c683          	lbu	a3,0(a1)
 39a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39e:	fee79ae3          	bne	a5,a4,392 <memmove+0x46>
 3a2:	bfc9                	j	374 <memmove+0x28>

00000000000003a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3aa:	ca05                	beqz	a2,3da <memcmp+0x36>
 3ac:	fff6069b          	addiw	a3,a2,-1
 3b0:	1682                	slli	a3,a3,0x20
 3b2:	9281                	srli	a3,a3,0x20
 3b4:	0685                	addi	a3,a3,1
 3b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	0005c703          	lbu	a4,0(a1)
 3c0:	00e79863          	bne	a5,a4,3d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c4:	0505                	addi	a0,a0,1
    p2++;
 3c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c8:	fed518e3          	bne	a0,a3,3b8 <memcmp+0x14>
  }
  return 0;
 3cc:	4501                	li	a0,0
 3ce:	a019                	j	3d4 <memcmp+0x30>
      return *p1 - *p2;
 3d0:	40e7853b          	subw	a0,a5,a4
}
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfe5                	j	3d4 <memcmp+0x30>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	00000097          	auipc	ra,0x0
 3ea:	f66080e7          	jalr	-154(ra) # 34c <memmove>
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f6:	4885                	li	a7,1
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fe:	4889                	li	a7,2
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <wait>:
.global wait
wait:
 li a7, SYS_wait
 406:	488d                	li	a7,3
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40e:	4891                	li	a7,4
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <read>:
.global read
read:
 li a7, SYS_read
 416:	4895                	li	a7,5
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <write>:
.global write
write:
 li a7, SYS_write
 41e:	48c1                	li	a7,16
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <close>:
.global close
close:
 li a7, SYS_close
 426:	48d5                	li	a7,21
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <kill>:
.global kill
kill:
 li a7, SYS_kill
 42e:	4899                	li	a7,6
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exec>:
.global exec
exec:
 li a7, SYS_exec
 436:	489d                	li	a7,7
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <open>:
.global open
open:
 li a7, SYS_open
 43e:	48bd                	li	a7,15
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 446:	48c5                	li	a7,17
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44e:	48c9                	li	a7,18
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 456:	48a1                	li	a7,8
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <link>:
.global link
link:
 li a7, SYS_link
 45e:	48cd                	li	a7,19
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 466:	48d1                	li	a7,20
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46e:	48a5                	li	a7,9
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <dup>:
.global dup
dup:
 li a7, SYS_dup
 476:	48a9                	li	a7,10
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47e:	48ad                	li	a7,11
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 486:	48b1                	li	a7,12
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48e:	48b5                	li	a7,13
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 496:	48b9                	li	a7,14
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <trace>:
.global trace
trace:
 li a7, SYS_trace
 49e:	48d9                	li	a7,22
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4a6:	48dd                	li	a7,23
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ae:	1101                	addi	sp,sp,-32
 4b0:	ec06                	sd	ra,24(sp)
 4b2:	e822                	sd	s0,16(sp)
 4b4:	1000                	addi	s0,sp,32
 4b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ba:	4605                	li	a2,1
 4bc:	fef40593          	addi	a1,s0,-17
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f5e080e7          	jalr	-162(ra) # 41e <write>
}
 4c8:	60e2                	ld	ra,24(sp)
 4ca:	6442                	ld	s0,16(sp)
 4cc:	6105                	addi	sp,sp,32
 4ce:	8082                	ret

00000000000004d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	7139                	addi	sp,sp,-64
 4d2:	fc06                	sd	ra,56(sp)
 4d4:	f822                	sd	s0,48(sp)
 4d6:	f426                	sd	s1,40(sp)
 4d8:	f04a                	sd	s2,32(sp)
 4da:	ec4e                	sd	s3,24(sp)
 4dc:	0080                	addi	s0,sp,64
 4de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e0:	c299                	beqz	a3,4e6 <printint+0x16>
 4e2:	0805c963          	bltz	a1,574 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e6:	2581                	sext.w	a1,a1
  neg = 0;
 4e8:	4881                	li	a7,0
 4ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f0:	2601                	sext.w	a2,a2
 4f2:	00000517          	auipc	a0,0x0
 4f6:	4ce50513          	addi	a0,a0,1230 # 9c0 <digits>
 4fa:	883a                	mv	a6,a4
 4fc:	2705                	addiw	a4,a4,1
 4fe:	02c5f7bb          	remuw	a5,a1,a2
 502:	1782                	slli	a5,a5,0x20
 504:	9381                	srli	a5,a5,0x20
 506:	97aa                	add	a5,a5,a0
 508:	0007c783          	lbu	a5,0(a5)
 50c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 510:	0005879b          	sext.w	a5,a1
 514:	02c5d5bb          	divuw	a1,a1,a2
 518:	0685                	addi	a3,a3,1
 51a:	fec7f0e3          	bgeu	a5,a2,4fa <printint+0x2a>
  if(neg)
 51e:	00088c63          	beqz	a7,536 <printint+0x66>
    buf[i++] = '-';
 522:	fd070793          	addi	a5,a4,-48
 526:	00878733          	add	a4,a5,s0
 52a:	02d00793          	li	a5,45
 52e:	fef70823          	sb	a5,-16(a4)
 532:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 536:	02e05863          	blez	a4,566 <printint+0x96>
 53a:	fc040793          	addi	a5,s0,-64
 53e:	00e78933          	add	s2,a5,a4
 542:	fff78993          	addi	s3,a5,-1
 546:	99ba                	add	s3,s3,a4
 548:	377d                	addiw	a4,a4,-1
 54a:	1702                	slli	a4,a4,0x20
 54c:	9301                	srli	a4,a4,0x20
 54e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 552:	fff94583          	lbu	a1,-1(s2)
 556:	8526                	mv	a0,s1
 558:	00000097          	auipc	ra,0x0
 55c:	f56080e7          	jalr	-170(ra) # 4ae <putc>
  while(--i >= 0)
 560:	197d                	addi	s2,s2,-1
 562:	ff3918e3          	bne	s2,s3,552 <printint+0x82>
}
 566:	70e2                	ld	ra,56(sp)
 568:	7442                	ld	s0,48(sp)
 56a:	74a2                	ld	s1,40(sp)
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
 570:	6121                	addi	sp,sp,64
 572:	8082                	ret
    x = -xx;
 574:	40b005bb          	negw	a1,a1
    neg = 1;
 578:	4885                	li	a7,1
    x = -xx;
 57a:	bf85                	j	4ea <printint+0x1a>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	715d                	addi	sp,sp,-80
 57e:	e486                	sd	ra,72(sp)
 580:	e0a2                	sd	s0,64(sp)
 582:	fc26                	sd	s1,56(sp)
 584:	f84a                	sd	s2,48(sp)
 586:	f44e                	sd	s3,40(sp)
 588:	f052                	sd	s4,32(sp)
 58a:	ec56                	sd	s5,24(sp)
 58c:	e85a                	sd	s6,16(sp)
 58e:	e45e                	sd	s7,8(sp)
 590:	e062                	sd	s8,0(sp)
 592:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 594:	0005c903          	lbu	s2,0(a1)
 598:	18090c63          	beqz	s2,730 <vprintf+0x1b4>
 59c:	8aaa                	mv	s5,a0
 59e:	8bb2                	mv	s7,a2
 5a0:	00158493          	addi	s1,a1,1
  state = 0;
 5a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a6:	02500a13          	li	s4,37
 5aa:	4b55                	li	s6,21
 5ac:	a839                	j	5ca <vprintf+0x4e>
        putc(fd, c);
 5ae:	85ca                	mv	a1,s2
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	efc080e7          	jalr	-260(ra) # 4ae <putc>
 5ba:	a019                	j	5c0 <vprintf+0x44>
    } else if(state == '%'){
 5bc:	01498d63          	beq	s3,s4,5d6 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5c0:	0485                	addi	s1,s1,1
 5c2:	fff4c903          	lbu	s2,-1(s1)
 5c6:	16090563          	beqz	s2,730 <vprintf+0x1b4>
    if(state == 0){
 5ca:	fe0999e3          	bnez	s3,5bc <vprintf+0x40>
      if(c == '%'){
 5ce:	ff4910e3          	bne	s2,s4,5ae <vprintf+0x32>
        state = '%';
 5d2:	89d2                	mv	s3,s4
 5d4:	b7f5                	j	5c0 <vprintf+0x44>
      if(c == 'd'){
 5d6:	13490263          	beq	s2,s4,6fa <vprintf+0x17e>
 5da:	f9d9079b          	addiw	a5,s2,-99
 5de:	0ff7f793          	zext.b	a5,a5
 5e2:	12fb6563          	bltu	s6,a5,70c <vprintf+0x190>
 5e6:	f9d9079b          	addiw	a5,s2,-99
 5ea:	0ff7f713          	zext.b	a4,a5
 5ee:	10eb6f63          	bltu	s6,a4,70c <vprintf+0x190>
 5f2:	00271793          	slli	a5,a4,0x2
 5f6:	00000717          	auipc	a4,0x0
 5fa:	37270713          	addi	a4,a4,882 # 968 <malloc+0x13a>
 5fe:	97ba                	add	a5,a5,a4
 600:	439c                	lw	a5,0(a5)
 602:	97ba                	add	a5,a5,a4
 604:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 606:	008b8913          	addi	s2,s7,8
 60a:	4685                	li	a3,1
 60c:	4629                	li	a2,10
 60e:	000ba583          	lw	a1,0(s7)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	ebc080e7          	jalr	-324(ra) # 4d0 <printint>
 61c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61e:	4981                	li	s3,0
 620:	b745                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	ea0080e7          	jalr	-352(ra) # 4d0 <printint>
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b751                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000ba583          	lw	a1,0(s7)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e84080e7          	jalr	-380(ra) # 4d0 <printint>
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	b7a5                	j	5c0 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 65a:	008b8c13          	addi	s8,s7,8
 65e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 662:	03000593          	li	a1,48
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e46080e7          	jalr	-442(ra) # 4ae <putc>
  putc(fd, 'x');
 670:	07800593          	li	a1,120
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e38080e7          	jalr	-456(ra) # 4ae <putc>
 67e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 680:	00000b97          	auipc	s7,0x0
 684:	340b8b93          	addi	s7,s7,832 # 9c0 <digits>
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97de                	add	a5,a5,s7
 68e:	0007c583          	lbu	a1,0(a5)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e1a080e7          	jalr	-486(ra) # 4ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69c:	0992                	slli	s3,s3,0x4
 69e:	397d                	addiw	s2,s2,-1
 6a0:	fe0914e3          	bnez	s2,688 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6a4:	8be2                	mv	s7,s8
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bf21                	j	5c0 <vprintf+0x44>
        s = va_arg(ap, char*);
 6aa:	008b8993          	addi	s3,s7,8
 6ae:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b2:	02090163          	beqz	s2,6d4 <vprintf+0x158>
        while(*s != 0){
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	c9a5                	beqz	a1,72a <vprintf+0x1ae>
          putc(fd, *s);
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	df0080e7          	jalr	-528(ra) # 4ae <putc>
          s++;
 6c6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c8:	00094583          	lbu	a1,0(s2)
 6cc:	f9e5                	bnez	a1,6bc <vprintf+0x140>
        s = va_arg(ap, char*);
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5fd                	j	5c0 <vprintf+0x44>
          s = "(null)";
 6d4:	00000917          	auipc	s2,0x0
 6d8:	28c90913          	addi	s2,s2,652 # 960 <malloc+0x132>
        while(*s != 0){
 6dc:	02800593          	li	a1,40
 6e0:	bff1                	j	6bc <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	000bc583          	lbu	a1,0(s7)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dc2080e7          	jalr	-574(ra) # 4ae <putc>
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b5e1                	j	5c0 <vprintf+0x44>
        putc(fd, c);
 6fa:	02500593          	li	a1,37
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	dae080e7          	jalr	-594(ra) # 4ae <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	bd5d                	j	5c0 <vprintf+0x44>
        putc(fd, '%');
 70c:	02500593          	li	a1,37
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	d9c080e7          	jalr	-612(ra) # 4ae <putc>
        putc(fd, c);
 71a:	85ca                	mv	a1,s2
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	d90080e7          	jalr	-624(ra) # 4ae <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	bd61                	j	5c0 <vprintf+0x44>
        s = va_arg(ap, char*);
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bd49                	j	5c0 <vprintf+0x44>
    }
  }
}
 730:	60a6                	ld	ra,72(sp)
 732:	6406                	ld	s0,64(sp)
 734:	74e2                	ld	s1,56(sp)
 736:	7942                	ld	s2,48(sp)
 738:	79a2                	ld	s3,40(sp)
 73a:	7a02                	ld	s4,32(sp)
 73c:	6ae2                	ld	s5,24(sp)
 73e:	6b42                	ld	s6,16(sp)
 740:	6ba2                	ld	s7,8(sp)
 742:	6c02                	ld	s8,0(sp)
 744:	6161                	addi	sp,sp,80
 746:	8082                	ret

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	8622                	mv	a2,s0
 766:	00000097          	auipc	ra,0x0
 76a:	e16080e7          	jalr	-490(ra) # 57c <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	de0080e7          	jalr	-544(ra) # 57c <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e422                	sd	s0,8(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00001797          	auipc	a5,0x1
 7ba:	8627b783          	ld	a5,-1950(a5) # 1018 <freep>
 7be:	a02d                	j	7e8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9f2d                	addw	a4,a4,a1
 7c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6310                	ld	a2,0(a4)
 7cc:	a83d                	j	80a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9f31                	addw	a4,a4,a2
 7d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053683          	ld	a3,-16(a0)
 7da:	a091                	j	81e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e7e463          	bltu	a5,a4,7e6 <free+0x3a>
 7e2:	00e6ea63          	bltu	a3,a4,7f6 <free+0x4a>
{
 7e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	fed7fae3          	bgeu	a5,a3,7dc <free+0x30>
 7ec:	6398                	ld	a4,0(a5)
 7ee:	00e6e463          	bltu	a3,a4,7f6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	fee7eae3          	bltu	a5,a4,7e6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f6:	ff852583          	lw	a1,-8(a0)
 7fa:	6390                	ld	a2,0(a5)
 7fc:	02059813          	slli	a6,a1,0x20
 800:	01c85713          	srli	a4,a6,0x1c
 804:	9736                	add	a4,a4,a3
 806:	fae60de3          	beq	a2,a4,7c0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 80a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 80e:	4790                	lw	a2,8(a5)
 810:	02061593          	slli	a1,a2,0x20
 814:	01c5d713          	srli	a4,a1,0x1c
 818:	973e                	add	a4,a4,a5
 81a:	fae68ae3          	beq	a3,a4,7ce <free+0x22>
    p->s.ptr = bp->s.ptr;
 81e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 820:	00000717          	auipc	a4,0x0
 824:	7ef73c23          	sd	a5,2040(a4) # 1018 <freep>
}
 828:	6422                	ld	s0,8(sp)
 82a:	0141                	addi	sp,sp,16
 82c:	8082                	ret

000000000000082e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82e:	7139                	addi	sp,sp,-64
 830:	fc06                	sd	ra,56(sp)
 832:	f822                	sd	s0,48(sp)
 834:	f426                	sd	s1,40(sp)
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	02051493          	slli	s1,a0,0x20
 846:	9081                	srli	s1,s1,0x20
 848:	04bd                	addi	s1,s1,15
 84a:	8091                	srli	s1,s1,0x4
 84c:	0014899b          	addiw	s3,s1,1
 850:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 852:	00000517          	auipc	a0,0x0
 856:	7c653503          	ld	a0,1990(a0) # 1018 <freep>
 85a:	c515                	beqz	a0,886 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	02977f63          	bgeu	a4,s1,89e <malloc+0x70>
  if(nu < 4096)
 864:	8a4e                	mv	s4,s3
 866:	0009871b          	sext.w	a4,s3
 86a:	6685                	lui	a3,0x1
 86c:	00d77363          	bgeu	a4,a3,872 <malloc+0x44>
 870:	6a05                	lui	s4,0x1
 872:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 876:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87a:	00000917          	auipc	s2,0x0
 87e:	79e90913          	addi	s2,s2,1950 # 1018 <freep>
  if(p == (char*)-1)
 882:	5afd                	li	s5,-1
 884:	a895                	j	8f8 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 886:	00001797          	auipc	a5,0x1
 88a:	80278793          	addi	a5,a5,-2046 # 1088 <base>
 88e:	00000717          	auipc	a4,0x0
 892:	78f73523          	sd	a5,1930(a4) # 1018 <freep>
 896:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 898:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89c:	b7e1                	j	864 <malloc+0x36>
      if(p->s.size == nunits)
 89e:	02e48c63          	beq	s1,a4,8d6 <malloc+0xa8>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	76a73123          	sd	a0,1890(a4) # 1018 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	6121                	addi	sp,sp,64
 8d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	e118                	sd	a4,0(a0)
 8da:	bff1                	j	8b6 <malloc+0x88>
  hp->s.size = nu;
 8dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e0:	0541                	addi	a0,a0,16
 8e2:	00000097          	auipc	ra,0x0
 8e6:	eca080e7          	jalr	-310(ra) # 7ac <free>
  return freep;
 8ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ee:	d971                	beqz	a0,8c2 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	fa9775e3          	bgeu	a4,s1,89e <malloc+0x70>
    if(p == freep)
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	00000097          	auipc	ra,0x0
 908:	b82080e7          	jalr	-1150(ra) # 486 <sbrk>
  if(p == (char*)-1)
 90c:	fd5518e3          	bne	a0,s5,8dc <malloc+0xae>
        return 0;
 910:	4501                	li	a0,0
 912:	bf45                	j	8c2 <malloc+0x94>
