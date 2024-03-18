
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	908a0a13          	addi	s4,s4,-1784 # 940 <malloc+0xea>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f2080e7          	jalr	498(ra) # 238 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	00998d63          	beq	s3,s1,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3c2080e7          	jalr	962(ra) # 43e <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	addi	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	8b250513          	addi	a0,a0,-1870 # 958 <malloc+0x102>
  ae:	00000097          	auipc	ra,0x0
  b2:	6f0080e7          	jalr	1776(ra) # 79e <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	87450513          	addi	a0,a0,-1932 # 948 <malloc+0xf2>
  dc:	00000097          	auipc	ra,0x0
  e0:	6c2080e7          	jalr	1730(ra) # 79e <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	340080e7          	jalr	832(ra) # 426 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
  fa:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  fc:	4785                	li	a5,1
  fe:	04a7d963          	bge	a5,a0,150 <main+0x62>
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	34a080e7          	jalr	842(ra) # 466 <open>
 124:	84aa                	mv	s1,a0
 126:	04054363          	bltz	a0,16c <main+0x7e>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	316080e7          	jalr	790(ra) # 44e <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2de080e7          	jalr	734(ra) # 426 <exit>
    wc(0, "");
 150:	00001597          	auipc	a1,0x1
 154:	81858593          	addi	a1,a1,-2024 # 968 <malloc+0x112>
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	ea6080e7          	jalr	-346(ra) # 0 <wc>
    exit(0);
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	2c2080e7          	jalr	706(ra) # 426 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 16c:	00093583          	ld	a1,0(s2)
 170:	00001517          	auipc	a0,0x1
 174:	80050513          	addi	a0,a0,-2048 # 970 <malloc+0x11a>
 178:	00000097          	auipc	ra,0x0
 17c:	626080e7          	jalr	1574(ra) # 79e <printf>
      exit(1);
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	2a4080e7          	jalr	676(ra) # 426 <exit>

000000000000018a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	00000097          	auipc	ra,0x0
 196:	f5c080e7          	jalr	-164(ra) # ee <main>
  exit(0);
 19a:	4501                	li	a0,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	28a080e7          	jalr	650(ra) # 426 <exit>

00000000000001a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	87aa                	mv	a5,a0
 1ac:	0585                	addi	a1,a1,1
 1ae:	0785                	addi	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fb75                	bnez	a4,1ac <strcpy+0x8>
    ;
  return os;
}
 1ba:	6422                	ld	s0,8(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cb91                	beqz	a5,1de <strcmp+0x1e>
 1cc:	0005c703          	lbu	a4,0(a1)
 1d0:	00f71763          	bne	a4,a5,1de <strcmp+0x1e>
    p++, q++;
 1d4:	0505                	addi	a0,a0,1
 1d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d8:	00054783          	lbu	a5,0(a0)
 1dc:	fbe5                	bnez	a5,1cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1de:	0005c503          	lbu	a0,0(a1)
}
 1e2:	40a7853b          	subw	a0,a5,a0
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strlen>:

uint
strlen(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf91                	beqz	a5,212 <strlen+0x26>
 1f8:	0505                	addi	a0,a0,1
 1fa:	87aa                	mv	a5,a0
 1fc:	86be                	mv	a3,a5
 1fe:	0785                	addi	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	ff65                	bnez	a4,1fc <strlen+0x10>
 206:	40a6853b          	subw	a0,a3,a0
 20a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  for(n = 0; s[n]; n++)
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <strlen+0x20>

0000000000000216 <memset>:

void*
memset(void *dst, int c, uint n)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 21c:	ca19                	beqz	a2,232 <memset+0x1c>
 21e:	87aa                	mv	a5,a0
 220:	1602                	slli	a2,a2,0x20
 222:	9201                	srli	a2,a2,0x20
 224:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 228:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 22c:	0785                	addi	a5,a5,1
 22e:	fee79de3          	bne	a5,a4,228 <memset+0x12>
  }
  return dst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret

0000000000000238 <strchr>:

char*
strchr(const char *s, char c)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 23e:	00054783          	lbu	a5,0(a0)
 242:	cb99                	beqz	a5,258 <strchr+0x20>
    if(*s == c)
 244:	00f58763          	beq	a1,a5,252 <strchr+0x1a>
  for(; *s; s++)
 248:	0505                	addi	a0,a0,1
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbfd                	bnez	a5,244 <strchr+0xc>
      return (char*)s;
  return 0;
 250:	4501                	li	a0,0
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  return 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <strchr+0x1a>

000000000000025c <gets>:

char*
gets(char *buf, int max)
{
 25c:	711d                	addi	sp,sp,-96
 25e:	ec86                	sd	ra,88(sp)
 260:	e8a2                	sd	s0,80(sp)
 262:	e4a6                	sd	s1,72(sp)
 264:	e0ca                	sd	s2,64(sp)
 266:	fc4e                	sd	s3,56(sp)
 268:	f852                	sd	s4,48(sp)
 26a:	f456                	sd	s5,40(sp)
 26c:	f05a                	sd	s6,32(sp)
 26e:	ec5e                	sd	s7,24(sp)
 270:	1080                	addi	s0,sp,96
 272:	8baa                	mv	s7,a0
 274:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 276:	892a                	mv	s2,a0
 278:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 27a:	4aa9                	li	s5,10
 27c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 27e:	89a6                	mv	s3,s1
 280:	2485                	addiw	s1,s1,1
 282:	0344d863          	bge	s1,s4,2b2 <gets+0x56>
    cc = read(0, &c, 1);
 286:	4605                	li	a2,1
 288:	faf40593          	addi	a1,s0,-81
 28c:	4501                	li	a0,0
 28e:	00000097          	auipc	ra,0x0
 292:	1b0080e7          	jalr	432(ra) # 43e <read>
    if(cc < 1)
 296:	00a05e63          	blez	a0,2b2 <gets+0x56>
    buf[i++] = c;
 29a:	faf44783          	lbu	a5,-81(s0)
 29e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a2:	01578763          	beq	a5,s5,2b0 <gets+0x54>
 2a6:	0905                	addi	s2,s2,1
 2a8:	fd679be3          	bne	a5,s6,27e <gets+0x22>
  for(i=0; i+1 < max; ){
 2ac:	89a6                	mv	s3,s1
 2ae:	a011                	j	2b2 <gets+0x56>
 2b0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b2:	99de                	add	s3,s3,s7
 2b4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b8:	855e                	mv	a0,s7
 2ba:	60e6                	ld	ra,88(sp)
 2bc:	6446                	ld	s0,80(sp)
 2be:	64a6                	ld	s1,72(sp)
 2c0:	6906                	ld	s2,64(sp)
 2c2:	79e2                	ld	s3,56(sp)
 2c4:	7a42                	ld	s4,48(sp)
 2c6:	7aa2                	ld	s5,40(sp)
 2c8:	7b02                	ld	s6,32(sp)
 2ca:	6be2                	ld	s7,24(sp)
 2cc:	6125                	addi	sp,sp,96
 2ce:	8082                	ret

00000000000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	1101                	addi	sp,sp,-32
 2d2:	ec06                	sd	ra,24(sp)
 2d4:	e822                	sd	s0,16(sp)
 2d6:	e426                	sd	s1,8(sp)
 2d8:	e04a                	sd	s2,0(sp)
 2da:	1000                	addi	s0,sp,32
 2dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	4581                	li	a1,0
 2e0:	00000097          	auipc	ra,0x0
 2e4:	186080e7          	jalr	390(ra) # 466 <open>
  if(fd < 0)
 2e8:	02054563          	bltz	a0,312 <stat+0x42>
 2ec:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ee:	85ca                	mv	a1,s2
 2f0:	00000097          	auipc	ra,0x0
 2f4:	18e080e7          	jalr	398(ra) # 47e <fstat>
 2f8:	892a                	mv	s2,a0
  close(fd);
 2fa:	8526                	mv	a0,s1
 2fc:	00000097          	auipc	ra,0x0
 300:	152080e7          	jalr	338(ra) # 44e <close>
  return r;
}
 304:	854a                	mv	a0,s2
 306:	60e2                	ld	ra,24(sp)
 308:	6442                	ld	s0,16(sp)
 30a:	64a2                	ld	s1,8(sp)
 30c:	6902                	ld	s2,0(sp)
 30e:	6105                	addi	sp,sp,32
 310:	8082                	ret
    return -1;
 312:	597d                	li	s2,-1
 314:	bfc5                	j	304 <stat+0x34>

0000000000000316 <atoi>:

int
atoi(const char *s)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31c:	00054683          	lbu	a3,0(a0)
 320:	fd06879b          	addiw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	4625                	li	a2,9
 32a:	02f66863          	bltu	a2,a5,35a <atoi+0x44>
 32e:	872a                	mv	a4,a0
  n = 0;
 330:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 332:	0705                	addi	a4,a4,1
 334:	0025179b          	slliw	a5,a0,0x2
 338:	9fa9                	addw	a5,a5,a0
 33a:	0017979b          	slliw	a5,a5,0x1
 33e:	9fb5                	addw	a5,a5,a3
 340:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 344:	00074683          	lbu	a3,0(a4)
 348:	fd06879b          	addiw	a5,a3,-48
 34c:	0ff7f793          	zext.b	a5,a5
 350:	fef671e3          	bgeu	a2,a5,332 <atoi+0x1c>
  return n;
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  n = 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <atoi+0x3e>

000000000000035e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 364:	02b57463          	bgeu	a0,a1,38c <memmove+0x2e>
    while(n-- > 0)
 368:	00c05f63          	blez	a2,386 <memmove+0x28>
 36c:	1602                	slli	a2,a2,0x20
 36e:	9201                	srli	a2,a2,0x20
 370:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 374:	872a                	mv	a4,a0
      *dst++ = *src++;
 376:	0585                	addi	a1,a1,1
 378:	0705                	addi	a4,a4,1
 37a:	fff5c683          	lbu	a3,-1(a1)
 37e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
    dst += n;
 38c:	00c50733          	add	a4,a0,a2
    src += n;
 390:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 392:	fec05ae3          	blez	a2,386 <memmove+0x28>
 396:	fff6079b          	addiw	a5,a2,-1
 39a:	1782                	slli	a5,a5,0x20
 39c:	9381                	srli	a5,a5,0x20
 39e:	fff7c793          	not	a5,a5
 3a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a4:	15fd                	addi	a1,a1,-1
 3a6:	177d                	addi	a4,a4,-1
 3a8:	0005c683          	lbu	a3,0(a1)
 3ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b0:	fee79ae3          	bne	a5,a4,3a4 <memmove+0x46>
 3b4:	bfc9                	j	386 <memmove+0x28>

00000000000003b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3bc:	ca05                	beqz	a2,3ec <memcmp+0x36>
 3be:	fff6069b          	addiw	a3,a2,-1
 3c2:	1682                	slli	a3,a3,0x20
 3c4:	9281                	srli	a3,a3,0x20
 3c6:	0685                	addi	a3,a3,1
 3c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00e79863          	bne	a5,a4,3e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d6:	0505                	addi	a0,a0,1
    p2++;
 3d8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3da:	fed518e3          	bne	a0,a3,3ca <memcmp+0x14>
  }
  return 0;
 3de:	4501                	li	a0,0
 3e0:	a019                	j	3e6 <memcmp+0x30>
      return *p1 - *p2;
 3e2:	40e7853b          	subw	a0,a5,a4
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
  return 0;
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <memcmp+0x30>

00000000000003f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f66080e7          	jalr	-154(ra) # 35e <memmove>
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 40e:	040007b7          	lui	a5,0x4000
}
 412:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffeded>
 414:	07b2                	slli	a5,a5,0xc
 416:	4388                	lw	a0,0(a5)
 418:	6422                	ld	s0,8(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41e:	4885                	li	a7,1
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <exit>:
.global exit
exit:
 li a7, SYS_exit
 426:	4889                	li	a7,2
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <wait>:
.global wait
wait:
 li a7, SYS_wait
 42e:	488d                	li	a7,3
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 436:	4891                	li	a7,4
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <read>:
.global read
read:
 li a7, SYS_read
 43e:	4895                	li	a7,5
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <write>:
.global write
write:
 li a7, SYS_write
 446:	48c1                	li	a7,16
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <close>:
.global close
close:
 li a7, SYS_close
 44e:	48d5                	li	a7,21
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <kill>:
.global kill
kill:
 li a7, SYS_kill
 456:	4899                	li	a7,6
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <exec>:
.global exec
exec:
 li a7, SYS_exec
 45e:	489d                	li	a7,7
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <open>:
.global open
open:
 li a7, SYS_open
 466:	48bd                	li	a7,15
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46e:	48c5                	li	a7,17
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 476:	48c9                	li	a7,18
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47e:	48a1                	li	a7,8
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <link>:
.global link
link:
 li a7, SYS_link
 486:	48cd                	li	a7,19
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48e:	48d1                	li	a7,20
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 496:	48a5                	li	a7,9
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <dup>:
.global dup
dup:
 li a7, SYS_dup
 49e:	48a9                	li	a7,10
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a6:	48ad                	li	a7,11
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ae:	48b1                	li	a7,12
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b6:	48b5                	li	a7,13
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4be:	48b9                	li	a7,14
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4c6:	48f5                	li	a7,29
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ce:	48f9                	li	a7,30
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	1000                	addi	s0,sp,32
 4de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e2:	4605                	li	a2,1
 4e4:	fef40593          	addi	a1,s0,-17
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f5e080e7          	jalr	-162(ra) # 446 <write>
}
 4f0:	60e2                	ld	ra,24(sp)
 4f2:	6442                	ld	s0,16(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret

00000000000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	7139                	addi	sp,sp,-64
 4fa:	fc06                	sd	ra,56(sp)
 4fc:	f822                	sd	s0,48(sp)
 4fe:	f426                	sd	s1,40(sp)
 500:	f04a                	sd	s2,32(sp)
 502:	ec4e                	sd	s3,24(sp)
 504:	0080                	addi	s0,sp,64
 506:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 508:	c299                	beqz	a3,50e <printint+0x16>
 50a:	0805c963          	bltz	a1,59c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50e:	2581                	sext.w	a1,a1
  neg = 0;
 510:	4881                	li	a7,0
 512:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 516:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 518:	2601                	sext.w	a2,a2
 51a:	00000517          	auipc	a0,0x0
 51e:	4ce50513          	addi	a0,a0,1230 # 9e8 <digits>
 522:	883a                	mv	a6,a4
 524:	2705                	addiw	a4,a4,1
 526:	02c5f7bb          	remuw	a5,a1,a2
 52a:	1782                	slli	a5,a5,0x20
 52c:	9381                	srli	a5,a5,0x20
 52e:	97aa                	add	a5,a5,a0
 530:	0007c783          	lbu	a5,0(a5)
 534:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 538:	0005879b          	sext.w	a5,a1
 53c:	02c5d5bb          	divuw	a1,a1,a2
 540:	0685                	addi	a3,a3,1
 542:	fec7f0e3          	bgeu	a5,a2,522 <printint+0x2a>
  if(neg)
 546:	00088c63          	beqz	a7,55e <printint+0x66>
    buf[i++] = '-';
 54a:	fd070793          	addi	a5,a4,-48
 54e:	00878733          	add	a4,a5,s0
 552:	02d00793          	li	a5,45
 556:	fef70823          	sb	a5,-16(a4)
 55a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55e:	02e05863          	blez	a4,58e <printint+0x96>
 562:	fc040793          	addi	a5,s0,-64
 566:	00e78933          	add	s2,a5,a4
 56a:	fff78993          	addi	s3,a5,-1
 56e:	99ba                	add	s3,s3,a4
 570:	377d                	addiw	a4,a4,-1
 572:	1702                	slli	a4,a4,0x20
 574:	9301                	srli	a4,a4,0x20
 576:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57a:	fff94583          	lbu	a1,-1(s2)
 57e:	8526                	mv	a0,s1
 580:	00000097          	auipc	ra,0x0
 584:	f56080e7          	jalr	-170(ra) # 4d6 <putc>
  while(--i >= 0)
 588:	197d                	addi	s2,s2,-1
 58a:	ff3918e3          	bne	s2,s3,57a <printint+0x82>
}
 58e:	70e2                	ld	ra,56(sp)
 590:	7442                	ld	s0,48(sp)
 592:	74a2                	ld	s1,40(sp)
 594:	7902                	ld	s2,32(sp)
 596:	69e2                	ld	s3,24(sp)
 598:	6121                	addi	sp,sp,64
 59a:	8082                	ret
    x = -xx;
 59c:	40b005bb          	negw	a1,a1
    neg = 1;
 5a0:	4885                	li	a7,1
    x = -xx;
 5a2:	bf85                	j	512 <printint+0x1a>

00000000000005a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a4:	715d                	addi	sp,sp,-80
 5a6:	e486                	sd	ra,72(sp)
 5a8:	e0a2                	sd	s0,64(sp)
 5aa:	fc26                	sd	s1,56(sp)
 5ac:	f84a                	sd	s2,48(sp)
 5ae:	f44e                	sd	s3,40(sp)
 5b0:	f052                	sd	s4,32(sp)
 5b2:	ec56                	sd	s5,24(sp)
 5b4:	e85a                	sd	s6,16(sp)
 5b6:	e45e                	sd	s7,8(sp)
 5b8:	e062                	sd	s8,0(sp)
 5ba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5bc:	0005c903          	lbu	s2,0(a1)
 5c0:	18090c63          	beqz	s2,758 <vprintf+0x1b4>
 5c4:	8aaa                	mv	s5,a0
 5c6:	8bb2                	mv	s7,a2
 5c8:	00158493          	addi	s1,a1,1
  state = 0;
 5cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ce:	02500a13          	li	s4,37
 5d2:	4b55                	li	s6,21
 5d4:	a839                	j	5f2 <vprintf+0x4e>
        putc(fd, c);
 5d6:	85ca                	mv	a1,s2
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	efc080e7          	jalr	-260(ra) # 4d6 <putc>
 5e2:	a019                	j	5e8 <vprintf+0x44>
    } else if(state == '%'){
 5e4:	01498d63          	beq	s3,s4,5fe <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 5e8:	0485                	addi	s1,s1,1
 5ea:	fff4c903          	lbu	s2,-1(s1)
 5ee:	16090563          	beqz	s2,758 <vprintf+0x1b4>
    if(state == 0){
 5f2:	fe0999e3          	bnez	s3,5e4 <vprintf+0x40>
      if(c == '%'){
 5f6:	ff4910e3          	bne	s2,s4,5d6 <vprintf+0x32>
        state = '%';
 5fa:	89d2                	mv	s3,s4
 5fc:	b7f5                	j	5e8 <vprintf+0x44>
      if(c == 'd'){
 5fe:	13490263          	beq	s2,s4,722 <vprintf+0x17e>
 602:	f9d9079b          	addiw	a5,s2,-99
 606:	0ff7f793          	zext.b	a5,a5
 60a:	12fb6563          	bltu	s6,a5,734 <vprintf+0x190>
 60e:	f9d9079b          	addiw	a5,s2,-99
 612:	0ff7f713          	zext.b	a4,a5
 616:	10eb6f63          	bltu	s6,a4,734 <vprintf+0x190>
 61a:	00271793          	slli	a5,a4,0x2
 61e:	00000717          	auipc	a4,0x0
 622:	37270713          	addi	a4,a4,882 # 990 <malloc+0x13a>
 626:	97ba                	add	a5,a5,a4
 628:	439c                	lw	a5,0(a5)
 62a:	97ba                	add	a5,a5,a4
 62c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 62e:	008b8913          	addi	s2,s7,8
 632:	4685                	li	a3,1
 634:	4629                	li	a2,10
 636:	000ba583          	lw	a1,0(s7)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	ebc080e7          	jalr	-324(ra) # 4f8 <printint>
 644:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 646:	4981                	li	s3,0
 648:	b745                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000ba583          	lw	a1,0(s7)
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	ea0080e7          	jalr	-352(ra) # 4f8 <printint>
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	b751                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 666:	008b8913          	addi	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4641                	li	a2,16
 66e:	000ba583          	lw	a1,0(s7)
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e84080e7          	jalr	-380(ra) # 4f8 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	b7a5                	j	5e8 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 682:	008b8c13          	addi	s8,s7,8
 686:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68a:	03000593          	li	a1,48
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e46080e7          	jalr	-442(ra) # 4d6 <putc>
  putc(fd, 'x');
 698:	07800593          	li	a1,120
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e38080e7          	jalr	-456(ra) # 4d6 <putc>
 6a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	00000b97          	auipc	s7,0x0
 6ac:	340b8b93          	addi	s7,s7,832 # 9e8 <digits>
 6b0:	03c9d793          	srli	a5,s3,0x3c
 6b4:	97de                	add	a5,a5,s7
 6b6:	0007c583          	lbu	a1,0(a5)
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	e1a080e7          	jalr	-486(ra) # 4d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c4:	0992                	slli	s3,s3,0x4
 6c6:	397d                	addiw	s2,s2,-1
 6c8:	fe0914e3          	bnez	s2,6b0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6cc:	8be2                	mv	s7,s8
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bf21                	j	5e8 <vprintf+0x44>
        s = va_arg(ap, char*);
 6d2:	008b8993          	addi	s3,s7,8
 6d6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6da:	02090163          	beqz	s2,6fc <vprintf+0x158>
        while(*s != 0){
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	c9a5                	beqz	a1,752 <vprintf+0x1ae>
          putc(fd, *s);
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	df0080e7          	jalr	-528(ra) # 4d6 <putc>
          s++;
 6ee:	0905                	addi	s2,s2,1
        while(*s != 0){
 6f0:	00094583          	lbu	a1,0(s2)
 6f4:	f9e5                	bnez	a1,6e4 <vprintf+0x140>
        s = va_arg(ap, char*);
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b5fd                	j	5e8 <vprintf+0x44>
          s = "(null)";
 6fc:	00000917          	auipc	s2,0x0
 700:	28c90913          	addi	s2,s2,652 # 988 <malloc+0x132>
        while(*s != 0){
 704:	02800593          	li	a1,40
 708:	bff1                	j	6e4 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 70a:	008b8913          	addi	s2,s7,8
 70e:	000bc583          	lbu	a1,0(s7)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	dc2080e7          	jalr	-574(ra) # 4d6 <putc>
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b5e1                	j	5e8 <vprintf+0x44>
        putc(fd, c);
 722:	02500593          	li	a1,37
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	dae080e7          	jalr	-594(ra) # 4d6 <putc>
      state = 0;
 730:	4981                	li	s3,0
 732:	bd5d                	j	5e8 <vprintf+0x44>
        putc(fd, '%');
 734:	02500593          	li	a1,37
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	d9c080e7          	jalr	-612(ra) # 4d6 <putc>
        putc(fd, c);
 742:	85ca                	mv	a1,s2
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	d90080e7          	jalr	-624(ra) # 4d6 <putc>
      state = 0;
 74e:	4981                	li	s3,0
 750:	bd61                	j	5e8 <vprintf+0x44>
        s = va_arg(ap, char*);
 752:	8bce                	mv	s7,s3
      state = 0;
 754:	4981                	li	s3,0
 756:	bd49                	j	5e8 <vprintf+0x44>
    }
  }
}
 758:	60a6                	ld	ra,72(sp)
 75a:	6406                	ld	s0,64(sp)
 75c:	74e2                	ld	s1,56(sp)
 75e:	7942                	ld	s2,48(sp)
 760:	79a2                	ld	s3,40(sp)
 762:	7a02                	ld	s4,32(sp)
 764:	6ae2                	ld	s5,24(sp)
 766:	6b42                	ld	s6,16(sp)
 768:	6ba2                	ld	s7,8(sp)
 76a:	6c02                	ld	s8,0(sp)
 76c:	6161                	addi	sp,sp,80
 76e:	8082                	ret

0000000000000770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 770:	715d                	addi	sp,sp,-80
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e010                	sd	a2,0(s0)
 77a:	e414                	sd	a3,8(s0)
 77c:	e818                	sd	a4,16(s0)
 77e:	ec1c                	sd	a5,24(s0)
 780:	03043023          	sd	a6,32(s0)
 784:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78c:	8622                	mv	a2,s0
 78e:	00000097          	auipc	ra,0x0
 792:	e16080e7          	jalr	-490(ra) # 5a4 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6161                	addi	sp,sp,80
 79c:	8082                	ret

000000000000079e <printf>:

void
printf(const char *fmt, ...)
{
 79e:	711d                	addi	sp,sp,-96
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e40c                	sd	a1,8(s0)
 7a8:	e810                	sd	a2,16(s0)
 7aa:	ec14                	sd	a3,24(s0)
 7ac:	f018                	sd	a4,32(s0)
 7ae:	f41c                	sd	a5,40(s0)
 7b0:	03043823          	sd	a6,48(s0)
 7b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	00840613          	addi	a2,s0,8
 7bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c0:	85aa                	mv	a1,a0
 7c2:	4505                	li	a0,1
 7c4:	00000097          	auipc	ra,0x0
 7c8:	de0080e7          	jalr	-544(ra) # 5a4 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret

00000000000007d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d4:	1141                	addi	sp,sp,-16
 7d6:	e422                	sd	s0,8(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a02d                	j	810 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e8:	4618                	lw	a4,8(a2)
 7ea:	9f2d                	addw	a4,a4,a1
 7ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	6398                	ld	a4,0(a5)
 7f2:	6310                	ld	a2,0(a4)
 7f4:	a83d                	j	832 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f6:	ff852703          	lw	a4,-8(a0)
 7fa:	9f31                	addw	a4,a4,a2
 7fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fe:	ff053683          	ld	a3,-16(a0)
 802:	a091                	j	846 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	6398                	ld	a4,0(a5)
 806:	00e7e463          	bltu	a5,a4,80e <free+0x3a>
 80a:	00e6ea63          	bltu	a3,a4,81e <free+0x4a>
{
 80e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	fed7fae3          	bgeu	a5,a3,804 <free+0x30>
 814:	6398                	ld	a4,0(a5)
 816:	00e6e463          	bltu	a3,a4,81e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	fee7eae3          	bltu	a5,a4,80e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 81e:	ff852583          	lw	a1,-8(a0)
 822:	6390                	ld	a2,0(a5)
 824:	02059813          	slli	a6,a1,0x20
 828:	01c85713          	srli	a4,a6,0x1c
 82c:	9736                	add	a4,a4,a3
 82e:	fae60de3          	beq	a2,a4,7e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 836:	4790                	lw	a2,8(a5)
 838:	02061593          	slli	a1,a2,0x20
 83c:	01c5d713          	srli	a4,a1,0x1c
 840:	973e                	add	a4,a4,a5
 842:	fae68ae3          	beq	a3,a4,7f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 846:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 848:	00000717          	auipc	a4,0x0
 84c:	7af73c23          	sd	a5,1976(a4) # 1000 <freep>
}
 850:	6422                	ld	s0,8(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f426                	sd	s1,40(sp)
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
 868:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	02051493          	slli	s1,a0,0x20
 86e:	9081                	srli	s1,s1,0x20
 870:	04bd                	addi	s1,s1,15
 872:	8091                	srli	s1,s1,0x4
 874:	0014899b          	addiw	s3,s1,1
 878:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87a:	00000517          	auipc	a0,0x0
 87e:	78653503          	ld	a0,1926(a0) # 1000 <freep>
 882:	c515                	beqz	a0,8ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	02977f63          	bgeu	a4,s1,8c6 <malloc+0x70>
  if(nu < 4096)
 88c:	8a4e                	mv	s4,s3
 88e:	0009871b          	sext.w	a4,s3
 892:	6685                	lui	a3,0x1
 894:	00d77363          	bgeu	a4,a3,89a <malloc+0x44>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000917          	auipc	s2,0x0
 8a6:	75e90913          	addi	s2,s2,1886 # 1000 <freep>
  if(p == (char*)-1)
 8aa:	5afd                	li	s5,-1
 8ac:	a895                	j	920 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8ae:	00001797          	auipc	a5,0x1
 8b2:	96278793          	addi	a5,a5,-1694 # 1210 <base>
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74f73523          	sd	a5,1866(a4) # 1000 <freep>
 8be:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c4:	b7e1                	j	88c <malloc+0x36>
      if(p->s.size == nunits)
 8c6:	02e48c63          	beq	s1,a4,8fe <malloc+0xa8>
        p->s.size -= nunits;
 8ca:	4137073b          	subw	a4,a4,s3
 8ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d0:	02071693          	slli	a3,a4,0x20
 8d4:	01c6d713          	srli	a4,a3,0x1c
 8d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8de:	00000717          	auipc	a4,0x0
 8e2:	72a73123          	sd	a0,1826(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	e118                	sd	a4,0(a0)
 902:	bff1                	j	8de <malloc+0x88>
  hp->s.size = nu;
 904:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 908:	0541                	addi	a0,a0,16
 90a:	00000097          	auipc	ra,0x0
 90e:	eca080e7          	jalr	-310(ra) # 7d4 <free>
  return freep;
 912:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 916:	d971                	beqz	a0,8ea <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 918:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91a:	4798                	lw	a4,8(a5)
 91c:	fa9775e3          	bgeu	a4,s1,8c6 <malloc+0x70>
    if(p == freep)
 920:	00093703          	ld	a4,0(s2)
 924:	853e                	mv	a0,a5
 926:	fef719e3          	bne	a4,a5,918 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 92a:	8552                	mv	a0,s4
 92c:	00000097          	auipc	ra,0x0
 930:	b82080e7          	jalr	-1150(ra) # 4ae <sbrk>
  if(p == (char*)-1)
 934:	fd5518e3          	bne	a0,s5,904 <malloc+0xae>
        return 0;
 938:	4501                	li	a0,0
 93a:	bf45                	j	8ea <malloc+0x94>
