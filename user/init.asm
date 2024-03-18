
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8a250513          	addi	a0,a0,-1886 # 8b0 <malloc+0xec>
  16:	00000097          	auipc	ra,0x0
  1a:	3be080e7          	jalr	958(ra) # 3d4 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3e8080e7          	jalr	1000(ra) # 40c <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3de080e7          	jalr	990(ra) # 40c <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	88290913          	addi	s2,s2,-1918 # 8b8 <malloc+0xf4>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6cc080e7          	jalr	1740(ra) # 70c <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	344080e7          	jalr	836(ra) # 38c <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	342080e7          	jalr	834(ra) # 39c <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	89e50513          	addi	a0,a0,-1890 # 908 <malloc+0x144>
  72:	00000097          	auipc	ra,0x0
  76:	69a080e7          	jalr	1690(ra) # 70c <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	318080e7          	jalr	792(ra) # 394 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	82850513          	addi	a0,a0,-2008 # 8b0 <malloc+0xec>
  90:	00000097          	auipc	ra,0x0
  94:	34c080e7          	jalr	844(ra) # 3dc <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	81650513          	addi	a0,a0,-2026 # 8b0 <malloc+0xec>
  a2:	00000097          	auipc	ra,0x0
  a6:	332080e7          	jalr	818(ra) # 3d4 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	82450513          	addi	a0,a0,-2012 # 8d0 <malloc+0x10c>
  b4:	00000097          	auipc	ra,0x0
  b8:	658080e7          	jalr	1624(ra) # 70c <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2d6080e7          	jalr	726(ra) # 394 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	addi	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	81a50513          	addi	a0,a0,-2022 # 8e8 <malloc+0x124>
  d6:	00000097          	auipc	ra,0x0
  da:	2f6080e7          	jalr	758(ra) # 3cc <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	81250513          	addi	a0,a0,-2030 # 8f0 <malloc+0x12c>
  e6:	00000097          	auipc	ra,0x0
  ea:	626080e7          	jalr	1574(ra) # 70c <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2a4080e7          	jalr	676(ra) # 394 <exit>

00000000000000f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	28a080e7          	jalr	650(ra) # 394 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	addi	a1,a1,1
 11c:	0785                	addi	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	1b0080e7          	jalr	432(ra) # 3ac <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e426                	sd	s1,8(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	addi	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	00000097          	auipc	ra,0x0
 252:	186080e7          	jalr	390(ra) # 3d4 <open>
  if(fd < 0)
 256:	02054563          	bltz	a0,280 <stat+0x42>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	18e080e7          	jalr	398(ra) # 3ec <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	152080e7          	jalr	338(ra) # 3bc <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x34>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while(n-- > 0)
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0705                	addi	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addiw	a5,a2,-1
 308:	1782                	slli	a5,a5,0x20
 30a:	9381                	srli	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 312:	15fd                	addi	a1,a1,-1
 314:	177d                	addi	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addiw	a3,a2,-1
 330:	1682                	slli	a3,a3,0x20
 332:	9281                	srli	a3,a3,0x20
 334:	0685                	addi	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	addi	a0,a0,1
    p2++;
 346:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 37c:	040007b7          	lui	a5,0x4000
}
 380:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefdd>
 382:	07b2                	slli	a5,a5,0xc
 384:	4388                	lw	a0,0(a5)
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38c:	4885                	li	a7,1
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exit>:
.global exit
exit:
 li a7, SYS_exit
 394:	4889                	li	a7,2
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <wait>:
.global wait
wait:
 li a7, SYS_wait
 39c:	488d                	li	a7,3
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a4:	4891                	li	a7,4
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <read>:
.global read
read:
 li a7, SYS_read
 3ac:	4895                	li	a7,5
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <write>:
.global write
write:
 li a7, SYS_write
 3b4:	48c1                	li	a7,16
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <close>:
.global close
close:
 li a7, SYS_close
 3bc:	48d5                	li	a7,21
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c4:	4899                	li	a7,6
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3cc:	489d                	li	a7,7
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <open>:
.global open
open:
 li a7, SYS_open
 3d4:	48bd                	li	a7,15
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3dc:	48c5                	li	a7,17
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e4:	48c9                	li	a7,18
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ec:	48a1                	li	a7,8
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <link>:
.global link
link:
 li a7, SYS_link
 3f4:	48cd                	li	a7,19
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fc:	48d1                	li	a7,20
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <dup>:
.global dup
dup:
 li a7, SYS_dup
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <connect>:
.global connect
connect:
 li a7, SYS_connect
 434:	48f5                	li	a7,29
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 43c:	48f9                	li	a7,30
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 444:	1101                	addi	sp,sp,-32
 446:	ec06                	sd	ra,24(sp)
 448:	e822                	sd	s0,16(sp)
 44a:	1000                	addi	s0,sp,32
 44c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 450:	4605                	li	a2,1
 452:	fef40593          	addi	a1,s0,-17
 456:	00000097          	auipc	ra,0x0
 45a:	f5e080e7          	jalr	-162(ra) # 3b4 <write>
}
 45e:	60e2                	ld	ra,24(sp)
 460:	6442                	ld	s0,16(sp)
 462:	6105                	addi	sp,sp,32
 464:	8082                	ret

0000000000000466 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 466:	7139                	addi	sp,sp,-64
 468:	fc06                	sd	ra,56(sp)
 46a:	f822                	sd	s0,48(sp)
 46c:	f426                	sd	s1,40(sp)
 46e:	f04a                	sd	s2,32(sp)
 470:	ec4e                	sd	s3,24(sp)
 472:	0080                	addi	s0,sp,64
 474:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 476:	c299                	beqz	a3,47c <printint+0x16>
 478:	0805c963          	bltz	a1,50a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47c:	2581                	sext.w	a1,a1
  neg = 0;
 47e:	4881                	li	a7,0
 480:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 484:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 486:	2601                	sext.w	a2,a2
 488:	00000517          	auipc	a0,0x0
 48c:	50050513          	addi	a0,a0,1280 # 988 <digits>
 490:	883a                	mv	a6,a4
 492:	2705                	addiw	a4,a4,1
 494:	02c5f7bb          	remuw	a5,a1,a2
 498:	1782                	slli	a5,a5,0x20
 49a:	9381                	srli	a5,a5,0x20
 49c:	97aa                	add	a5,a5,a0
 49e:	0007c783          	lbu	a5,0(a5)
 4a2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a6:	0005879b          	sext.w	a5,a1
 4aa:	02c5d5bb          	divuw	a1,a1,a2
 4ae:	0685                	addi	a3,a3,1
 4b0:	fec7f0e3          	bgeu	a5,a2,490 <printint+0x2a>
  if(neg)
 4b4:	00088c63          	beqz	a7,4cc <printint+0x66>
    buf[i++] = '-';
 4b8:	fd070793          	addi	a5,a4,-48
 4bc:	00878733          	add	a4,a5,s0
 4c0:	02d00793          	li	a5,45
 4c4:	fef70823          	sb	a5,-16(a4)
 4c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4cc:	02e05863          	blez	a4,4fc <printint+0x96>
 4d0:	fc040793          	addi	a5,s0,-64
 4d4:	00e78933          	add	s2,a5,a4
 4d8:	fff78993          	addi	s3,a5,-1
 4dc:	99ba                	add	s3,s3,a4
 4de:	377d                	addiw	a4,a4,-1
 4e0:	1702                	slli	a4,a4,0x20
 4e2:	9301                	srli	a4,a4,0x20
 4e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e8:	fff94583          	lbu	a1,-1(s2)
 4ec:	8526                	mv	a0,s1
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f56080e7          	jalr	-170(ra) # 444 <putc>
  while(--i >= 0)
 4f6:	197d                	addi	s2,s2,-1
 4f8:	ff3918e3          	bne	s2,s3,4e8 <printint+0x82>
}
 4fc:	70e2                	ld	ra,56(sp)
 4fe:	7442                	ld	s0,48(sp)
 500:	74a2                	ld	s1,40(sp)
 502:	7902                	ld	s2,32(sp)
 504:	69e2                	ld	s3,24(sp)
 506:	6121                	addi	sp,sp,64
 508:	8082                	ret
    x = -xx;
 50a:	40b005bb          	negw	a1,a1
    neg = 1;
 50e:	4885                	li	a7,1
    x = -xx;
 510:	bf85                	j	480 <printint+0x1a>

0000000000000512 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 512:	715d                	addi	sp,sp,-80
 514:	e486                	sd	ra,72(sp)
 516:	e0a2                	sd	s0,64(sp)
 518:	fc26                	sd	s1,56(sp)
 51a:	f84a                	sd	s2,48(sp)
 51c:	f44e                	sd	s3,40(sp)
 51e:	f052                	sd	s4,32(sp)
 520:	ec56                	sd	s5,24(sp)
 522:	e85a                	sd	s6,16(sp)
 524:	e45e                	sd	s7,8(sp)
 526:	e062                	sd	s8,0(sp)
 528:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c903          	lbu	s2,0(a1)
 52e:	18090c63          	beqz	s2,6c6 <vprintf+0x1b4>
 532:	8aaa                	mv	s5,a0
 534:	8bb2                	mv	s7,a2
 536:	00158493          	addi	s1,a1,1
  state = 0;
 53a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53c:	02500a13          	li	s4,37
 540:	4b55                	li	s6,21
 542:	a839                	j	560 <vprintf+0x4e>
        putc(fd, c);
 544:	85ca                	mv	a1,s2
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	efc080e7          	jalr	-260(ra) # 444 <putc>
 550:	a019                	j	556 <vprintf+0x44>
    } else if(state == '%'){
 552:	01498d63          	beq	s3,s4,56c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 556:	0485                	addi	s1,s1,1
 558:	fff4c903          	lbu	s2,-1(s1)
 55c:	16090563          	beqz	s2,6c6 <vprintf+0x1b4>
    if(state == 0){
 560:	fe0999e3          	bnez	s3,552 <vprintf+0x40>
      if(c == '%'){
 564:	ff4910e3          	bne	s2,s4,544 <vprintf+0x32>
        state = '%';
 568:	89d2                	mv	s3,s4
 56a:	b7f5                	j	556 <vprintf+0x44>
      if(c == 'd'){
 56c:	13490263          	beq	s2,s4,690 <vprintf+0x17e>
 570:	f9d9079b          	addiw	a5,s2,-99
 574:	0ff7f793          	zext.b	a5,a5
 578:	12fb6563          	bltu	s6,a5,6a2 <vprintf+0x190>
 57c:	f9d9079b          	addiw	a5,s2,-99
 580:	0ff7f713          	zext.b	a4,a5
 584:	10eb6f63          	bltu	s6,a4,6a2 <vprintf+0x190>
 588:	00271793          	slli	a5,a4,0x2
 58c:	00000717          	auipc	a4,0x0
 590:	3a470713          	addi	a4,a4,932 # 930 <malloc+0x16c>
 594:	97ba                	add	a5,a5,a4
 596:	439c                	lw	a5,0(a5)
 598:	97ba                	add	a5,a5,a4
 59a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	ebc080e7          	jalr	-324(ra) # 466 <printint>
 5b2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b745                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	ea0080e7          	jalr	-352(ra) # 466 <printint>
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b751                	j	556 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e84080e7          	jalr	-380(ra) # 466 <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b7a5                	j	556 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5f0:	008b8c13          	addi	s8,s7,8
 5f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f8:	03000593          	li	a1,48
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e46080e7          	jalr	-442(ra) # 444 <putc>
  putc(fd, 'x');
 606:	07800593          	li	a1,120
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e38080e7          	jalr	-456(ra) # 444 <putc>
 614:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 616:	00000b97          	auipc	s7,0x0
 61a:	372b8b93          	addi	s7,s7,882 # 988 <digits>
 61e:	03c9d793          	srli	a5,s3,0x3c
 622:	97de                	add	a5,a5,s7
 624:	0007c583          	lbu	a1,0(a5)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e1a080e7          	jalr	-486(ra) # 444 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 632:	0992                	slli	s3,s3,0x4
 634:	397d                	addiw	s2,s2,-1
 636:	fe0914e3          	bnez	s2,61e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 63a:	8be2                	mv	s7,s8
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf21                	j	556 <vprintf+0x44>
        s = va_arg(ap, char*);
 640:	008b8993          	addi	s3,s7,8
 644:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 648:	02090163          	beqz	s2,66a <vprintf+0x158>
        while(*s != 0){
 64c:	00094583          	lbu	a1,0(s2)
 650:	c9a5                	beqz	a1,6c0 <vprintf+0x1ae>
          putc(fd, *s);
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	df0080e7          	jalr	-528(ra) # 444 <putc>
          s++;
 65c:	0905                	addi	s2,s2,1
        while(*s != 0){
 65e:	00094583          	lbu	a1,0(s2)
 662:	f9e5                	bnez	a1,652 <vprintf+0x140>
        s = va_arg(ap, char*);
 664:	8bce                	mv	s7,s3
      state = 0;
 666:	4981                	li	s3,0
 668:	b5fd                	j	556 <vprintf+0x44>
          s = "(null)";
 66a:	00000917          	auipc	s2,0x0
 66e:	2be90913          	addi	s2,s2,702 # 928 <malloc+0x164>
        while(*s != 0){
 672:	02800593          	li	a1,40
 676:	bff1                	j	652 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 678:	008b8913          	addi	s2,s7,8
 67c:	000bc583          	lbu	a1,0(s7)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	dc2080e7          	jalr	-574(ra) # 444 <putc>
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b5e1                	j	556 <vprintf+0x44>
        putc(fd, c);
 690:	02500593          	li	a1,37
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	dae080e7          	jalr	-594(ra) # 444 <putc>
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bd5d                	j	556 <vprintf+0x44>
        putc(fd, '%');
 6a2:	02500593          	li	a1,37
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d9c080e7          	jalr	-612(ra) # 444 <putc>
        putc(fd, c);
 6b0:	85ca                	mv	a1,s2
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	d90080e7          	jalr	-624(ra) # 444 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd61                	j	556 <vprintf+0x44>
        s = va_arg(ap, char*);
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bd49                	j	556 <vprintf+0x44>
    }
  }
}
 6c6:	60a6                	ld	ra,72(sp)
 6c8:	6406                	ld	s0,64(sp)
 6ca:	74e2                	ld	s1,56(sp)
 6cc:	7942                	ld	s2,48(sp)
 6ce:	79a2                	ld	s3,40(sp)
 6d0:	7a02                	ld	s4,32(sp)
 6d2:	6ae2                	ld	s5,24(sp)
 6d4:	6b42                	ld	s6,16(sp)
 6d6:	6ba2                	ld	s7,8(sp)
 6d8:	6c02                	ld	s8,0(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e010                	sd	a2,0(s0)
 6e8:	e414                	sd	a3,8(s0)
 6ea:	e818                	sd	a4,16(s0)
 6ec:	ec1c                	sd	a5,24(s0)
 6ee:	03043023          	sd	a6,32(s0)
 6f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fa:	8622                	mv	a2,s0
 6fc:	00000097          	auipc	ra,0x0
 700:	e16080e7          	jalr	-490(ra) # 512 <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6161                	addi	sp,sp,80
 70a:	8082                	ret

000000000000070c <printf>:

void
printf(const char *fmt, ...)
{
 70c:	711d                	addi	sp,sp,-96
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	e40c                	sd	a1,8(s0)
 716:	e810                	sd	a2,16(s0)
 718:	ec14                	sd	a3,24(s0)
 71a:	f018                	sd	a4,32(s0)
 71c:	f41c                	sd	a5,40(s0)
 71e:	03043823          	sd	a6,48(s0)
 722:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	00840613          	addi	a2,s0,8
 72a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72e:	85aa                	mv	a1,a0
 730:	4505                	li	a0,1
 732:	00000097          	auipc	ra,0x0
 736:	de0080e7          	jalr	-544(ra) # 512 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret

0000000000000742 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 742:	1141                	addi	sp,sp,-16
 744:	e422                	sd	s0,8(sp)
 746:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 748:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74c:	00001797          	auipc	a5,0x1
 750:	8c47b783          	ld	a5,-1852(a5) # 1010 <freep>
 754:	a02d                	j	77e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 756:	4618                	lw	a4,8(a2)
 758:	9f2d                	addw	a4,a4,a1
 75a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	6398                	ld	a4,0(a5)
 760:	6310                	ld	a2,0(a4)
 762:	a83d                	j	7a0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 764:	ff852703          	lw	a4,-8(a0)
 768:	9f31                	addw	a4,a4,a2
 76a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 76c:	ff053683          	ld	a3,-16(a0)
 770:	a091                	j	7b4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	6398                	ld	a4,0(a5)
 774:	00e7e463          	bltu	a5,a4,77c <free+0x3a>
 778:	00e6ea63          	bltu	a3,a4,78c <free+0x4a>
{
 77c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	fed7fae3          	bgeu	a5,a3,772 <free+0x30>
 782:	6398                	ld	a4,0(a5)
 784:	00e6e463          	bltu	a3,a4,78c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	fee7eae3          	bltu	a5,a4,77c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 78c:	ff852583          	lw	a1,-8(a0)
 790:	6390                	ld	a2,0(a5)
 792:	02059813          	slli	a6,a1,0x20
 796:	01c85713          	srli	a4,a6,0x1c
 79a:	9736                	add	a4,a4,a3
 79c:	fae60de3          	beq	a2,a4,756 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a4:	4790                	lw	a2,8(a5)
 7a6:	02061593          	slli	a1,a2,0x20
 7aa:	01c5d713          	srli	a4,a1,0x1c
 7ae:	973e                	add	a4,a4,a5
 7b0:	fae68ae3          	beq	a3,a4,764 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b6:	00001717          	auipc	a4,0x1
 7ba:	84f73d23          	sd	a5,-1958(a4) # 1010 <freep>
}
 7be:	6422                	ld	s0,8(sp)
 7c0:	0141                	addi	sp,sp,16
 7c2:	8082                	ret

00000000000007c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c4:	7139                	addi	sp,sp,-64
 7c6:	fc06                	sd	ra,56(sp)
 7c8:	f822                	sd	s0,48(sp)
 7ca:	f426                	sd	s1,40(sp)
 7cc:	f04a                	sd	s2,32(sp)
 7ce:	ec4e                	sd	s3,24(sp)
 7d0:	e852                	sd	s4,16(sp)
 7d2:	e456                	sd	s5,8(sp)
 7d4:	e05a                	sd	s6,0(sp)
 7d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d8:	02051493          	slli	s1,a0,0x20
 7dc:	9081                	srli	s1,s1,0x20
 7de:	04bd                	addi	s1,s1,15
 7e0:	8091                	srli	s1,s1,0x4
 7e2:	0014899b          	addiw	s3,s1,1
 7e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7e8:	00001517          	auipc	a0,0x1
 7ec:	82853503          	ld	a0,-2008(a0) # 1010 <freep>
 7f0:	c515                	beqz	a0,81c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f4:	4798                	lw	a4,8(a5)
 7f6:	02977f63          	bgeu	a4,s1,834 <malloc+0x70>
  if(nu < 4096)
 7fa:	8a4e                	mv	s4,s3
 7fc:	0009871b          	sext.w	a4,s3
 800:	6685                	lui	a3,0x1
 802:	00d77363          	bgeu	a4,a3,808 <malloc+0x44>
 806:	6a05                	lui	s4,0x1
 808:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 80c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 810:	00001917          	auipc	s2,0x1
 814:	80090913          	addi	s2,s2,-2048 # 1010 <freep>
  if(p == (char*)-1)
 818:	5afd                	li	s5,-1
 81a:	a895                	j	88e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 81c:	00001797          	auipc	a5,0x1
 820:	80478793          	addi	a5,a5,-2044 # 1020 <base>
 824:	00000717          	auipc	a4,0x0
 828:	7ef73623          	sd	a5,2028(a4) # 1010 <freep>
 82c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 832:	b7e1                	j	7fa <malloc+0x36>
      if(p->s.size == nunits)
 834:	02e48c63          	beq	s1,a4,86c <malloc+0xa8>
        p->s.size -= nunits;
 838:	4137073b          	subw	a4,a4,s3
 83c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83e:	02071693          	slli	a3,a4,0x20
 842:	01c6d713          	srli	a4,a3,0x1c
 846:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 848:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84c:	00000717          	auipc	a4,0x0
 850:	7ca73223          	sd	a0,1988(a4) # 1010 <freep>
      return (void*)(p + 1);
 854:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 858:	70e2                	ld	ra,56(sp)
 85a:	7442                	ld	s0,48(sp)
 85c:	74a2                	ld	s1,40(sp)
 85e:	7902                	ld	s2,32(sp)
 860:	69e2                	ld	s3,24(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
 868:	6121                	addi	sp,sp,64
 86a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 86c:	6398                	ld	a4,0(a5)
 86e:	e118                	sd	a4,0(a0)
 870:	bff1                	j	84c <malloc+0x88>
  hp->s.size = nu;
 872:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 876:	0541                	addi	a0,a0,16
 878:	00000097          	auipc	ra,0x0
 87c:	eca080e7          	jalr	-310(ra) # 742 <free>
  return freep;
 880:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 884:	d971                	beqz	a0,858 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 888:	4798                	lw	a4,8(a5)
 88a:	fa9775e3          	bgeu	a4,s1,834 <malloc+0x70>
    if(p == freep)
 88e:	00093703          	ld	a4,0(s2)
 892:	853e                	mv	a0,a5
 894:	fef719e3          	bne	a4,a5,886 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 898:	8552                	mv	a0,s4
 89a:	00000097          	auipc	ra,0x0
 89e:	b82080e7          	jalr	-1150(ra) # 41c <sbrk>
  if(p == (char*)-1)
 8a2:	fd5518e3          	bne	a0,s5,872 <malloc+0xae>
        return 0;
 8a6:	4501                	li	a0,0
 8a8:	bf45                	j	858 <malloc+0x94>
