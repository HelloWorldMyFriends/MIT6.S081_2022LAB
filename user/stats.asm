
user/_stats:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define SZ 4096
char buf[SZ];

int
main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i, n;
  
  while (1) {
    n = statistics(buf, SZ);
  10:	00001a17          	auipc	s4,0x1
  14:	000a0a13          	mv	s4,s4
  18:	6585                	lui	a1,0x1
  1a:	8552                	mv	a0,s4
  1c:	00000097          	auipc	ra,0x0
  20:	7ca080e7          	jalr	1994(ra) # 7e6 <statistics>
  24:	89aa                	mv	s3,a0
    for (i = 0; i < n; i++) {
  26:	02a05263          	blez	a0,4a <main+0x4a>
  2a:	00001497          	auipc	s1,0x1
  2e:	fe648493          	addi	s1,s1,-26 # 1010 <buf>
  32:	00950933          	add	s2,a0,s1
      write(1, buf+i, 1);
  36:	4605                	li	a2,1
  38:	85a6                	mv	a1,s1
  3a:	4505                	li	a0,1
  3c:	00000097          	auipc	ra,0x0
  40:	2c4080e7          	jalr	708(ra) # 300 <write>
    for (i = 0; i < n; i++) {
  44:	0485                	addi	s1,s1,1
  46:	ff2498e3          	bne	s1,s2,36 <main+0x36>
    }
    if (n != SZ)
  4a:	6785                	lui	a5,0x1
  4c:	fcf986e3          	beq	s3,a5,18 <main+0x18>
      break;
  }

  exit(0);
  50:	4501                	li	a0,0
  52:	00000097          	auipc	ra,0x0
  56:	28e080e7          	jalr	654(ra) # 2e0 <exit>

000000000000005a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  extern int main();
  main();
  62:	00000097          	auipc	ra,0x0
  66:	f9e080e7          	jalr	-98(ra) # 0 <main>
  exit(0);
  6a:	4501                	li	a0,0
  6c:	00000097          	auipc	ra,0x0
  70:	274080e7          	jalr	628(ra) # 2e0 <exit>

0000000000000074 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	addi	a1,a1,1 # 1001 <freep+0x1>
  7e:	0785                	addi	a5,a5,1 # 1001 <freep+0x1>
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0x8>
    ;
  return os;
}
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x1e>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x1e>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x26>
  c8:	0505                	addi	a0,a0,1
  ca:	87aa                	mv	a5,a0
  cc:	86be                	mv	a3,a5
  ce:	0785                	addi	a5,a5,1
  d0:	fff7c703          	lbu	a4,-1(a5)
  d4:	ff65                	bnez	a4,cc <strlen+0x10>
  d6:	40a6853b          	subw	a0,a3,a0
  da:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e422                	sd	s0,8(sp)
  ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ec:	ca19                	beqz	a2,102 <memset+0x1c>
  ee:	87aa                	mv	a5,a0
  f0:	1602                	slli	a2,a2,0x20
  f2:	9201                	srli	a2,a2,0x20
  f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fc:	0785                	addi	a5,a5,1
  fe:	fee79de3          	bne	a5,a4,f8 <memset+0x12>
  }
  return dst;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10e:	00054783          	lbu	a5,0(a0)
 112:	cb99                	beqz	a5,128 <strchr+0x20>
    if(*s == c)
 114:	00f58763          	beq	a1,a5,122 <strchr+0x1a>
  for(; *s; s++)
 118:	0505                	addi	a0,a0,1
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbfd                	bnez	a5,114 <strchr+0xc>
      return (char*)s;
  return 0;
 120:	4501                	li	a0,0
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
  return 0;
 128:	4501                	li	a0,0
 12a:	bfe5                	j	122 <strchr+0x1a>

000000000000012c <gets>:

char*
gets(char *buf, int max)
{
 12c:	711d                	addi	sp,sp,-96
 12e:	ec86                	sd	ra,88(sp)
 130:	e8a2                	sd	s0,80(sp)
 132:	e4a6                	sd	s1,72(sp)
 134:	e0ca                	sd	s2,64(sp)
 136:	fc4e                	sd	s3,56(sp)
 138:	f852                	sd	s4,48(sp)
 13a:	f456                	sd	s5,40(sp)
 13c:	f05a                	sd	s6,32(sp)
 13e:	ec5e                	sd	s7,24(sp)
 140:	1080                	addi	s0,sp,96
 142:	8baa                	mv	s7,a0
 144:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 146:	892a                	mv	s2,a0
 148:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14a:	4aa9                	li	s5,10
 14c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	2485                	addiw	s1,s1,1
 152:	0344d863          	bge	s1,s4,182 <gets+0x56>
    cc = read(0, &c, 1);
 156:	4605                	li	a2,1
 158:	faf40593          	addi	a1,s0,-81
 15c:	4501                	li	a0,0
 15e:	00000097          	auipc	ra,0x0
 162:	19a080e7          	jalr	410(ra) # 2f8 <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x56>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x54>
 176:	0905                	addi	s2,s2,1
 178:	fd679be3          	bne	a5,s6,14e <gets+0x22>
  for(i=0; i+1 < max; ){
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x56>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e426                	sd	s1,8(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	170080e7          	jalr	368(ra) # 320 <open>
  if(fd < 0)
 1b8:	02054563          	bltz	a0,1e2 <stat+0x42>
 1bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1be:	85ca                	mv	a1,s2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	178080e7          	jalr	376(ra) # 338 <fstat>
 1c8:	892a                	mv	s2,a0
  close(fd);
 1ca:	8526                	mv	a0,s1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	13c080e7          	jalr	316(ra) # 308 <close>
  return r;
}
 1d4:	854a                	mv	a0,s2
 1d6:	60e2                	ld	ra,24(sp)
 1d8:	6442                	ld	s0,16(sp)
 1da:	64a2                	ld	s1,8(sp)
 1dc:	6902                	ld	s2,0(sp)
 1de:	6105                	addi	sp,sp,32
 1e0:	8082                	ret
    return -1;
 1e2:	597d                	li	s2,-1
 1e4:	bfc5                	j	1d4 <stat+0x34>

00000000000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ec:	00054683          	lbu	a3,0(a0)
 1f0:	fd06879b          	addiw	a5,a3,-48
 1f4:	0ff7f793          	zext.b	a5,a5
 1f8:	4625                	li	a2,9
 1fa:	02f66863          	bltu	a2,a5,22a <atoi+0x44>
 1fe:	872a                	mv	a4,a0
  n = 0;
 200:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 202:	0705                	addi	a4,a4,1
 204:	0025179b          	slliw	a5,a0,0x2
 208:	9fa9                	addw	a5,a5,a0
 20a:	0017979b          	slliw	a5,a5,0x1
 20e:	9fb5                	addw	a5,a5,a3
 210:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 214:	00074683          	lbu	a3,0(a4)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	fef671e3          	bgeu	a2,a5,202 <atoi+0x1c>
  return n;
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
  n = 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <atoi+0x3e>

000000000000022e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 234:	02b57463          	bgeu	a0,a1,25c <memmove+0x2e>
    while(n-- > 0)
 238:	00c05f63          	blez	a2,256 <memmove+0x28>
 23c:	1602                	slli	a2,a2,0x20
 23e:	9201                	srli	a2,a2,0x20
 240:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 244:	872a                	mv	a4,a0
      *dst++ = *src++;
 246:	0585                	addi	a1,a1,1
 248:	0705                	addi	a4,a4,1
 24a:	fff5c683          	lbu	a3,-1(a1)
 24e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 252:	fee79ae3          	bne	a5,a4,246 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 262:	fec05ae3          	blez	a2,256 <memmove+0x28>
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x46>
 284:	bfc9                	j	256 <memmove+0x28>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28c:	ca05                	beqz	a2,2bc <memcmp+0x36>
 28e:	fff6069b          	addiw	a3,a2,-1
 292:	1682                	slli	a3,a3,0x20
 294:	9281                	srli	a3,a3,0x20
 296:	0685                	addi	a3,a3,1
 298:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29a:	00054783          	lbu	a5,0(a0)
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00e79863          	bne	a5,a4,2b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a6:	0505                	addi	a0,a0,1
    p2++;
 2a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2aa:	fed518e3          	bne	a0,a3,29a <memcmp+0x14>
  }
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	a019                	j	2b6 <memcmp+0x30>
      return *p1 - *p2;
 2b2:	40e7853b          	subw	a0,a5,a4
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  return 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <memcmp+0x30>

00000000000002c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c8:	00000097          	auipc	ra,0x0
 2cc:	f66080e7          	jalr	-154(ra) # 22e <memmove>
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d8:	4885                	li	a7,1
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e0:	4889                	li	a7,2
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e8:	488d                	li	a7,3
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f0:	4891                	li	a7,4
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <read>:
.global read
read:
 li a7, SYS_read
 2f8:	4895                	li	a7,5
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <write>:
.global write
write:
 li a7, SYS_write
 300:	48c1                	li	a7,16
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <close>:
.global close
close:
 li a7, SYS_close
 308:	48d5                	li	a7,21
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <kill>:
.global kill
kill:
 li a7, SYS_kill
 310:	4899                	li	a7,6
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <exec>:
.global exec
exec:
 li a7, SYS_exec
 318:	489d                	li	a7,7
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <open>:
.global open
open:
 li a7, SYS_open
 320:	48bd                	li	a7,15
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 328:	48c5                	li	a7,17
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 330:	48c9                	li	a7,18
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 338:	48a1                	li	a7,8
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <link>:
.global link
link:
 li a7, SYS_link
 340:	48cd                	li	a7,19
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 348:	48d1                	li	a7,20
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 350:	48a5                	li	a7,9
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <dup>:
.global dup
dup:
 li a7, SYS_dup
 358:	48a9                	li	a7,10
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 360:	48ad                	li	a7,11
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 368:	48b1                	li	a7,12
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 370:	48b5                	li	a7,13
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 378:	48b9                	li	a7,14
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 380:	1101                	addi	sp,sp,-32
 382:	ec06                	sd	ra,24(sp)
 384:	e822                	sd	s0,16(sp)
 386:	1000                	addi	s0,sp,32
 388:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38c:	4605                	li	a2,1
 38e:	fef40593          	addi	a1,s0,-17
 392:	00000097          	auipc	ra,0x0
 396:	f6e080e7          	jalr	-146(ra) # 300 <write>
}
 39a:	60e2                	ld	ra,24(sp)
 39c:	6442                	ld	s0,16(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret

00000000000003a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a2:	7139                	addi	sp,sp,-64
 3a4:	fc06                	sd	ra,56(sp)
 3a6:	f822                	sd	s0,48(sp)
 3a8:	f426                	sd	s1,40(sp)
 3aa:	f04a                	sd	s2,32(sp)
 3ac:	ec4e                	sd	s3,24(sp)
 3ae:	0080                	addi	s0,sp,64
 3b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b2:	c299                	beqz	a3,3b8 <printint+0x16>
 3b4:	0805c963          	bltz	a1,446 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b8:	2581                	sext.w	a1,a1
  neg = 0;
 3ba:	4881                	li	a7,0
 3bc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c2:	2601                	sext.w	a2,a2
 3c4:	00000517          	auipc	a0,0x0
 3c8:	50c50513          	addi	a0,a0,1292 # 8d0 <digits>
 3cc:	883a                	mv	a6,a4
 3ce:	2705                	addiw	a4,a4,1
 3d0:	02c5f7bb          	remuw	a5,a1,a2
 3d4:	1782                	slli	a5,a5,0x20
 3d6:	9381                	srli	a5,a5,0x20
 3d8:	97aa                	add	a5,a5,a0
 3da:	0007c783          	lbu	a5,0(a5)
 3de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e2:	0005879b          	sext.w	a5,a1
 3e6:	02c5d5bb          	divuw	a1,a1,a2
 3ea:	0685                	addi	a3,a3,1
 3ec:	fec7f0e3          	bgeu	a5,a2,3cc <printint+0x2a>
  if(neg)
 3f0:	00088c63          	beqz	a7,408 <printint+0x66>
    buf[i++] = '-';
 3f4:	fd070793          	addi	a5,a4,-48
 3f8:	00878733          	add	a4,a5,s0
 3fc:	02d00793          	li	a5,45
 400:	fef70823          	sb	a5,-16(a4)
 404:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 408:	02e05863          	blez	a4,438 <printint+0x96>
 40c:	fc040793          	addi	a5,s0,-64
 410:	00e78933          	add	s2,a5,a4
 414:	fff78993          	addi	s3,a5,-1
 418:	99ba                	add	s3,s3,a4
 41a:	377d                	addiw	a4,a4,-1
 41c:	1702                	slli	a4,a4,0x20
 41e:	9301                	srli	a4,a4,0x20
 420:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 424:	fff94583          	lbu	a1,-1(s2)
 428:	8526                	mv	a0,s1
 42a:	00000097          	auipc	ra,0x0
 42e:	f56080e7          	jalr	-170(ra) # 380 <putc>
  while(--i >= 0)
 432:	197d                	addi	s2,s2,-1
 434:	ff3918e3          	bne	s2,s3,424 <printint+0x82>
}
 438:	70e2                	ld	ra,56(sp)
 43a:	7442                	ld	s0,48(sp)
 43c:	74a2                	ld	s1,40(sp)
 43e:	7902                	ld	s2,32(sp)
 440:	69e2                	ld	s3,24(sp)
 442:	6121                	addi	sp,sp,64
 444:	8082                	ret
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4885                	li	a7,1
    x = -xx;
 44c:	bf85                	j	3bc <printint+0x1a>

000000000000044e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44e:	715d                	addi	sp,sp,-80
 450:	e486                	sd	ra,72(sp)
 452:	e0a2                	sd	s0,64(sp)
 454:	fc26                	sd	s1,56(sp)
 456:	f84a                	sd	s2,48(sp)
 458:	f44e                	sd	s3,40(sp)
 45a:	f052                	sd	s4,32(sp)
 45c:	ec56                	sd	s5,24(sp)
 45e:	e85a                	sd	s6,16(sp)
 460:	e45e                	sd	s7,8(sp)
 462:	e062                	sd	s8,0(sp)
 464:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 466:	0005c903          	lbu	s2,0(a1)
 46a:	18090c63          	beqz	s2,602 <vprintf+0x1b4>
 46e:	8aaa                	mv	s5,a0
 470:	8bb2                	mv	s7,a2
 472:	00158493          	addi	s1,a1,1
  state = 0;
 476:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 478:	02500a13          	li	s4,37
 47c:	4b55                	li	s6,21
 47e:	a839                	j	49c <vprintf+0x4e>
        putc(fd, c);
 480:	85ca                	mv	a1,s2
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	efc080e7          	jalr	-260(ra) # 380 <putc>
 48c:	a019                	j	492 <vprintf+0x44>
    } else if(state == '%'){
 48e:	01498d63          	beq	s3,s4,4a8 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 492:	0485                	addi	s1,s1,1
 494:	fff4c903          	lbu	s2,-1(s1)
 498:	16090563          	beqz	s2,602 <vprintf+0x1b4>
    if(state == 0){
 49c:	fe0999e3          	bnez	s3,48e <vprintf+0x40>
      if(c == '%'){
 4a0:	ff4910e3          	bne	s2,s4,480 <vprintf+0x32>
        state = '%';
 4a4:	89d2                	mv	s3,s4
 4a6:	b7f5                	j	492 <vprintf+0x44>
      if(c == 'd'){
 4a8:	13490263          	beq	s2,s4,5cc <vprintf+0x17e>
 4ac:	f9d9079b          	addiw	a5,s2,-99
 4b0:	0ff7f793          	zext.b	a5,a5
 4b4:	12fb6563          	bltu	s6,a5,5de <vprintf+0x190>
 4b8:	f9d9079b          	addiw	a5,s2,-99
 4bc:	0ff7f713          	zext.b	a4,a5
 4c0:	10eb6f63          	bltu	s6,a4,5de <vprintf+0x190>
 4c4:	00271793          	slli	a5,a4,0x2
 4c8:	00000717          	auipc	a4,0x0
 4cc:	3b070713          	addi	a4,a4,944 # 878 <statistics+0x92>
 4d0:	97ba                	add	a5,a5,a4
 4d2:	439c                	lw	a5,0(a5)
 4d4:	97ba                	add	a5,a5,a4
 4d6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4d8:	008b8913          	addi	s2,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000ba583          	lw	a1,0(s7)
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	ebc080e7          	jalr	-324(ra) # 3a2 <printint>
 4ee:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b745                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f4:	008b8913          	addi	s2,s7,8
 4f8:	4681                	li	a3,0
 4fa:	4629                	li	a2,10
 4fc:	000ba583          	lw	a1,0(s7)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	ea0080e7          	jalr	-352(ra) # 3a2 <printint>
 50a:	8bca                	mv	s7,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	b751                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 510:	008b8913          	addi	s2,s7,8
 514:	4681                	li	a3,0
 516:	4641                	li	a2,16
 518:	000ba583          	lw	a1,0(s7)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e84080e7          	jalr	-380(ra) # 3a2 <printint>
 526:	8bca                	mv	s7,s2
      state = 0;
 528:	4981                	li	s3,0
 52a:	b7a5                	j	492 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 52c:	008b8c13          	addi	s8,s7,8
 530:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 534:	03000593          	li	a1,48
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e46080e7          	jalr	-442(ra) # 380 <putc>
  putc(fd, 'x');
 542:	07800593          	li	a1,120
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e38080e7          	jalr	-456(ra) # 380 <putc>
 550:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 552:	00000b97          	auipc	s7,0x0
 556:	37eb8b93          	addi	s7,s7,894 # 8d0 <digits>
 55a:	03c9d793          	srli	a5,s3,0x3c
 55e:	97de                	add	a5,a5,s7
 560:	0007c583          	lbu	a1,0(a5)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e1a080e7          	jalr	-486(ra) # 380 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 56e:	0992                	slli	s3,s3,0x4
 570:	397d                	addiw	s2,s2,-1
 572:	fe0914e3          	bnez	s2,55a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 576:	8be2                	mv	s7,s8
      state = 0;
 578:	4981                	li	s3,0
 57a:	bf21                	j	492 <vprintf+0x44>
        s = va_arg(ap, char*);
 57c:	008b8993          	addi	s3,s7,8
 580:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 584:	02090163          	beqz	s2,5a6 <vprintf+0x158>
        while(*s != 0){
 588:	00094583          	lbu	a1,0(s2)
 58c:	c9a5                	beqz	a1,5fc <vprintf+0x1ae>
          putc(fd, *s);
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	df0080e7          	jalr	-528(ra) # 380 <putc>
          s++;
 598:	0905                	addi	s2,s2,1
        while(*s != 0){
 59a:	00094583          	lbu	a1,0(s2)
 59e:	f9e5                	bnez	a1,58e <vprintf+0x140>
        s = va_arg(ap, char*);
 5a0:	8bce                	mv	s7,s3
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	b5fd                	j	492 <vprintf+0x44>
          s = "(null)";
 5a6:	00000917          	auipc	s2,0x0
 5aa:	2ca90913          	addi	s2,s2,714 # 870 <statistics+0x8a>
        while(*s != 0){
 5ae:	02800593          	li	a1,40
 5b2:	bff1                	j	58e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	000bc583          	lbu	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	dc2080e7          	jalr	-574(ra) # 380 <putc>
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b5e1                	j	492 <vprintf+0x44>
        putc(fd, c);
 5cc:	02500593          	li	a1,37
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	dae080e7          	jalr	-594(ra) # 380 <putc>
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bd5d                	j	492 <vprintf+0x44>
        putc(fd, '%');
 5de:	02500593          	li	a1,37
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	d9c080e7          	jalr	-612(ra) # 380 <putc>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	d90080e7          	jalr	-624(ra) # 380 <putc>
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bd61                	j	492 <vprintf+0x44>
        s = va_arg(ap, char*);
 5fc:	8bce                	mv	s7,s3
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bd49                	j	492 <vprintf+0x44>
    }
  }
}
 602:	60a6                	ld	ra,72(sp)
 604:	6406                	ld	s0,64(sp)
 606:	74e2                	ld	s1,56(sp)
 608:	7942                	ld	s2,48(sp)
 60a:	79a2                	ld	s3,40(sp)
 60c:	7a02                	ld	s4,32(sp)
 60e:	6ae2                	ld	s5,24(sp)
 610:	6b42                	ld	s6,16(sp)
 612:	6ba2                	ld	s7,8(sp)
 614:	6c02                	ld	s8,0(sp)
 616:	6161                	addi	sp,sp,80
 618:	8082                	ret

000000000000061a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 61a:	715d                	addi	sp,sp,-80
 61c:	ec06                	sd	ra,24(sp)
 61e:	e822                	sd	s0,16(sp)
 620:	1000                	addi	s0,sp,32
 622:	e010                	sd	a2,0(s0)
 624:	e414                	sd	a3,8(s0)
 626:	e818                	sd	a4,16(s0)
 628:	ec1c                	sd	a5,24(s0)
 62a:	03043023          	sd	a6,32(s0)
 62e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 632:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 636:	8622                	mv	a2,s0
 638:	00000097          	auipc	ra,0x0
 63c:	e16080e7          	jalr	-490(ra) # 44e <vprintf>
}
 640:	60e2                	ld	ra,24(sp)
 642:	6442                	ld	s0,16(sp)
 644:	6161                	addi	sp,sp,80
 646:	8082                	ret

0000000000000648 <printf>:

void
printf(const char *fmt, ...)
{
 648:	711d                	addi	sp,sp,-96
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	addi	s0,sp,32
 650:	e40c                	sd	a1,8(s0)
 652:	e810                	sd	a2,16(s0)
 654:	ec14                	sd	a3,24(s0)
 656:	f018                	sd	a4,32(s0)
 658:	f41c                	sd	a5,40(s0)
 65a:	03043823          	sd	a6,48(s0)
 65e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 662:	00840613          	addi	a2,s0,8
 666:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 66a:	85aa                	mv	a1,a0
 66c:	4505                	li	a0,1
 66e:	00000097          	auipc	ra,0x0
 672:	de0080e7          	jalr	-544(ra) # 44e <vprintf>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret

000000000000067e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67e:	1141                	addi	sp,sp,-16
 680:	e422                	sd	s0,8(sp)
 682:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 684:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	00001797          	auipc	a5,0x1
 68c:	9787b783          	ld	a5,-1672(a5) # 1000 <freep>
 690:	a02d                	j	6ba <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 692:	4618                	lw	a4,8(a2)
 694:	9f2d                	addw	a4,a4,a1
 696:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 69a:	6398                	ld	a4,0(a5)
 69c:	6310                	ld	a2,0(a4)
 69e:	a83d                	j	6dc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a0:	ff852703          	lw	a4,-8(a0)
 6a4:	9f31                	addw	a4,a4,a2
 6a6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6a8:	ff053683          	ld	a3,-16(a0)
 6ac:	a091                	j	6f0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ae:	6398                	ld	a4,0(a5)
 6b0:	00e7e463          	bltu	a5,a4,6b8 <free+0x3a>
 6b4:	00e6ea63          	bltu	a3,a4,6c8 <free+0x4a>
{
 6b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	fed7fae3          	bgeu	a5,a3,6ae <free+0x30>
 6be:	6398                	ld	a4,0(a5)
 6c0:	00e6e463          	bltu	a3,a4,6c8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	fee7eae3          	bltu	a5,a4,6b8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6c8:	ff852583          	lw	a1,-8(a0)
 6cc:	6390                	ld	a2,0(a5)
 6ce:	02059813          	slli	a6,a1,0x20
 6d2:	01c85713          	srli	a4,a6,0x1c
 6d6:	9736                	add	a4,a4,a3
 6d8:	fae60de3          	beq	a2,a4,692 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6dc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e0:	4790                	lw	a2,8(a5)
 6e2:	02061593          	slli	a1,a2,0x20
 6e6:	01c5d713          	srli	a4,a1,0x1c
 6ea:	973e                	add	a4,a4,a5
 6ec:	fae68ae3          	beq	a3,a4,6a0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6f2:	00001717          	auipc	a4,0x1
 6f6:	90f73723          	sd	a5,-1778(a4) # 1000 <freep>
}
 6fa:	6422                	ld	s0,8(sp)
 6fc:	0141                	addi	sp,sp,16
 6fe:	8082                	ret

0000000000000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	7139                	addi	sp,sp,-64
 702:	fc06                	sd	ra,56(sp)
 704:	f822                	sd	s0,48(sp)
 706:	f426                	sd	s1,40(sp)
 708:	f04a                	sd	s2,32(sp)
 70a:	ec4e                	sd	s3,24(sp)
 70c:	e852                	sd	s4,16(sp)
 70e:	e456                	sd	s5,8(sp)
 710:	e05a                	sd	s6,0(sp)
 712:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 714:	02051493          	slli	s1,a0,0x20
 718:	9081                	srli	s1,s1,0x20
 71a:	04bd                	addi	s1,s1,15
 71c:	8091                	srli	s1,s1,0x4
 71e:	0014899b          	addiw	s3,s1,1
 722:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 724:	00001517          	auipc	a0,0x1
 728:	8dc53503          	ld	a0,-1828(a0) # 1000 <freep>
 72c:	c515                	beqz	a0,758 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	02977f63          	bgeu	a4,s1,770 <malloc+0x70>
  if(nu < 4096)
 736:	8a4e                	mv	s4,s3
 738:	0009871b          	sext.w	a4,s3
 73c:	6685                	lui	a3,0x1
 73e:	00d77363          	bgeu	a4,a3,744 <malloc+0x44>
 742:	6a05                	lui	s4,0x1
 744:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 748:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74c:	00001917          	auipc	s2,0x1
 750:	8b490913          	addi	s2,s2,-1868 # 1000 <freep>
  if(p == (char*)-1)
 754:	5afd                	li	s5,-1
 756:	a895                	j	7ca <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 758:	00002797          	auipc	a5,0x2
 75c:	8b878793          	addi	a5,a5,-1864 # 2010 <base>
 760:	00001717          	auipc	a4,0x1
 764:	8af73023          	sd	a5,-1888(a4) # 1000 <freep>
 768:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 76a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76e:	b7e1                	j	736 <malloc+0x36>
      if(p->s.size == nunits)
 770:	02e48c63          	beq	s1,a4,7a8 <malloc+0xa8>
        p->s.size -= nunits;
 774:	4137073b          	subw	a4,a4,s3
 778:	c798                	sw	a4,8(a5)
        p += p->s.size;
 77a:	02071693          	slli	a3,a4,0x20
 77e:	01c6d713          	srli	a4,a3,0x1c
 782:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 784:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 788:	00001717          	auipc	a4,0x1
 78c:	86a73c23          	sd	a0,-1928(a4) # 1000 <freep>
      return (void*)(p + 1);
 790:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 794:	70e2                	ld	ra,56(sp)
 796:	7442                	ld	s0,48(sp)
 798:	74a2                	ld	s1,40(sp)
 79a:	7902                	ld	s2,32(sp)
 79c:	69e2                	ld	s3,24(sp)
 79e:	6a42                	ld	s4,16(sp)
 7a0:	6aa2                	ld	s5,8(sp)
 7a2:	6b02                	ld	s6,0(sp)
 7a4:	6121                	addi	sp,sp,64
 7a6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a8:	6398                	ld	a4,0(a5)
 7aa:	e118                	sd	a4,0(a0)
 7ac:	bff1                	j	788 <malloc+0x88>
  hp->s.size = nu;
 7ae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7b2:	0541                	addi	a0,a0,16
 7b4:	00000097          	auipc	ra,0x0
 7b8:	eca080e7          	jalr	-310(ra) # 67e <free>
  return freep;
 7bc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7c0:	d971                	beqz	a0,794 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c4:	4798                	lw	a4,8(a5)
 7c6:	fa9775e3          	bgeu	a4,s1,770 <malloc+0x70>
    if(p == freep)
 7ca:	00093703          	ld	a4,0(s2)
 7ce:	853e                	mv	a0,a5
 7d0:	fef719e3          	bne	a4,a5,7c2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7d4:	8552                	mv	a0,s4
 7d6:	00000097          	auipc	ra,0x0
 7da:	b92080e7          	jalr	-1134(ra) # 368 <sbrk>
  if(p == (char*)-1)
 7de:	fd5518e3          	bne	a0,s5,7ae <malloc+0xae>
        return 0;
 7e2:	4501                	li	a0,0
 7e4:	bf45                	j	794 <malloc+0x94>

00000000000007e6 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 7e6:	7179                	addi	sp,sp,-48
 7e8:	f406                	sd	ra,40(sp)
 7ea:	f022                	sd	s0,32(sp)
 7ec:	ec26                	sd	s1,24(sp)
 7ee:	e84a                	sd	s2,16(sp)
 7f0:	e44e                	sd	s3,8(sp)
 7f2:	e052                	sd	s4,0(sp)
 7f4:	1800                	addi	s0,sp,48
 7f6:	8a2a                	mv	s4,a0
 7f8:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 7fa:	4581                	li	a1,0
 7fc:	00000517          	auipc	a0,0x0
 800:	0ec50513          	addi	a0,a0,236 # 8e8 <digits+0x18>
 804:	00000097          	auipc	ra,0x0
 808:	b1c080e7          	jalr	-1252(ra) # 320 <open>
  if(fd < 0) {
 80c:	04054263          	bltz	a0,850 <statistics+0x6a>
 810:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 812:	4481                	li	s1,0
 814:	03205063          	blez	s2,834 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 818:	4099063b          	subw	a2,s2,s1
 81c:	009a05b3          	add	a1,s4,s1
 820:	854e                	mv	a0,s3
 822:	00000097          	auipc	ra,0x0
 826:	ad6080e7          	jalr	-1322(ra) # 2f8 <read>
 82a:	00054563          	bltz	a0,834 <statistics+0x4e>
      break;
    }
    i += n;
 82e:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 830:	ff24c4e3          	blt	s1,s2,818 <statistics+0x32>
  }
  close(fd);
 834:	854e                	mv	a0,s3
 836:	00000097          	auipc	ra,0x0
 83a:	ad2080e7          	jalr	-1326(ra) # 308 <close>
  return i;
}
 83e:	8526                	mv	a0,s1
 840:	70a2                	ld	ra,40(sp)
 842:	7402                	ld	s0,32(sp)
 844:	64e2                	ld	s1,24(sp)
 846:	6942                	ld	s2,16(sp)
 848:	69a2                	ld	s3,8(sp)
 84a:	6a02                	ld	s4,0(sp)
 84c:	6145                	addi	sp,sp,48
 84e:	8082                	ret
      fprintf(2, "stats: open failed\n");
 850:	00000597          	auipc	a1,0x0
 854:	0a858593          	addi	a1,a1,168 # 8f8 <digits+0x28>
 858:	4509                	li	a0,2
 85a:	00000097          	auipc	ra,0x0
 85e:	dc0080e7          	jalr	-576(ra) # 61a <fprintf>
      exit(1);
 862:	4505                	li	a0,1
 864:	00000097          	auipc	ra,0x0
 868:	a7c080e7          	jalr	-1412(ra) # 2e0 <exit>
