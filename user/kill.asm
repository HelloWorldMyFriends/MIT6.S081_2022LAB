
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1c8080e7          	jalr	456(ra) # 1f0 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ea080e7          	jalr	746(ra) # 31a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2aa080e7          	jalr	682(ra) # 2ea <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7b858593          	addi	a1,a1,1976 # 800 <malloc+0xe6>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5e2080e7          	jalr	1506(ra) # 634 <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	28e080e7          	jalr	654(ra) # 2ea <exit>

0000000000000064 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	274080e7          	jalr	628(ra) # 2ea <exit>

000000000000007e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
    ;
  return os;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x1e>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x1e>
    p++, q++;
  ae:	0505                	addi	a0,a0,1
  b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf91                	beqz	a5,ec <strlen+0x26>
  d2:	0505                	addi	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	86be                	mv	a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	ff65                	bnez	a4,d6 <strlen+0x10>
  e0:	40a6853b          	subw	a0,a3,a0
  e4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret
  for(n = 0; s[n]; n++)
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strlen+0x20>

00000000000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f6:	ca19                	beqz	a2,10c <memset+0x1c>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	slli	a2,a2,0x20
  fc:	9201                	srli	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 102:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 106:	0785                	addi	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x12>
  }
  return dst;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:

char*
strchr(const char *s, char c)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  for(; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb99                	beqz	a5,132 <strchr+0x20>
    if(*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1a>
  for(; *s; s++)
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xc>
      return (char*)s;
  return 0;
 12a:	4501                	li	a0,0
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret
  return 0;
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strchr+0x1a>

0000000000000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	711d                	addi	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	1080                	addi	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 154:	4aa9                	li	s5,10
 156:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 158:	89a6                	mv	s3,s1
 15a:	2485                	addiw	s1,s1,1
 15c:	0344d863          	bge	s1,s4,18c <gets+0x56>
    cc = read(0, &c, 1);
 160:	4605                	li	a2,1
 162:	faf40593          	addi	a1,s0,-81
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	19a080e7          	jalr	410(ra) # 302 <read>
    if(cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x56>
    buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	01578763          	beq	a5,s5,18a <gets+0x54>
 180:	0905                	addi	s2,s2,1
 182:	fd679be3          	bne	a5,s6,158 <gets+0x22>
  for(i=0; i+1 < max; ){
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x56>
 18a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
  return buf;
}
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int
stat(const char *n, struct stat *st)
{
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	addi	s0,sp,32
 1b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	4581                	li	a1,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	170080e7          	jalr	368(ra) # 32a <open>
  if(fd < 0)
 1c2:	02054563          	bltz	a0,1ec <stat+0x42>
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	178080e7          	jalr	376(ra) # 342 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	00000097          	auipc	ra,0x0
 1da:	13c080e7          	jalr	316(ra) # 312 <close>
  return r;
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	597d                	li	s2,-1
 1ee:	bfc5                	j	1de <stat+0x34>

00000000000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addiw	a3,a2,-1
 29c:	1682                	slli	a3,a3,0x20
 29e:	9281                	srli	a3,a3,0x20
 2a0:	0685                	addi	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	addi	a0,a0,1
    p2++;
 2b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d2:	00000097          	auipc	ra,0x0
 2d6:	f66080e7          	jalr	-154(ra) # 238 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <connect>:
.global connect
connect:
 li a7, SYS_connect
 38a:	48f5                	li	a7,29
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 392:	48f9                	li	a7,30
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	1000                	addi	s0,sp,32
 3a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	fef40593          	addi	a1,s0,-17
 3ac:	00000097          	auipc	ra,0x0
 3b0:	f5e080e7          	jalr	-162(ra) # 30a <write>
}
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret

00000000000003bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bc:	7139                	addi	sp,sp,-64
 3be:	fc06                	sd	ra,56(sp)
 3c0:	f822                	sd	s0,48(sp)
 3c2:	f426                	sd	s1,40(sp)
 3c4:	f04a                	sd	s2,32(sp)
 3c6:	ec4e                	sd	s3,24(sp)
 3c8:	0080                	addi	s0,sp,64
 3ca:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3cc:	c299                	beqz	a3,3d2 <printint+0x16>
 3ce:	0805c963          	bltz	a1,460 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d2:	2581                	sext.w	a1,a1
  neg = 0;
 3d4:	4881                	li	a7,0
 3d6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3dc:	2601                	sext.w	a2,a2
 3de:	00000517          	auipc	a0,0x0
 3e2:	49a50513          	addi	a0,a0,1178 # 878 <digits>
 3e6:	883a                	mv	a6,a4
 3e8:	2705                	addiw	a4,a4,1
 3ea:	02c5f7bb          	remuw	a5,a1,a2
 3ee:	1782                	slli	a5,a5,0x20
 3f0:	9381                	srli	a5,a5,0x20
 3f2:	97aa                	add	a5,a5,a0
 3f4:	0007c783          	lbu	a5,0(a5)
 3f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fc:	0005879b          	sext.w	a5,a1
 400:	02c5d5bb          	divuw	a1,a1,a2
 404:	0685                	addi	a3,a3,1
 406:	fec7f0e3          	bgeu	a5,a2,3e6 <printint+0x2a>
  if(neg)
 40a:	00088c63          	beqz	a7,422 <printint+0x66>
    buf[i++] = '-';
 40e:	fd070793          	addi	a5,a4,-48
 412:	00878733          	add	a4,a5,s0
 416:	02d00793          	li	a5,45
 41a:	fef70823          	sb	a5,-16(a4)
 41e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 422:	02e05863          	blez	a4,452 <printint+0x96>
 426:	fc040793          	addi	a5,s0,-64
 42a:	00e78933          	add	s2,a5,a4
 42e:	fff78993          	addi	s3,a5,-1
 432:	99ba                	add	s3,s3,a4
 434:	377d                	addiw	a4,a4,-1
 436:	1702                	slli	a4,a4,0x20
 438:	9301                	srli	a4,a4,0x20
 43a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43e:	fff94583          	lbu	a1,-1(s2)
 442:	8526                	mv	a0,s1
 444:	00000097          	auipc	ra,0x0
 448:	f56080e7          	jalr	-170(ra) # 39a <putc>
  while(--i >= 0)
 44c:	197d                	addi	s2,s2,-1
 44e:	ff3918e3          	bne	s2,s3,43e <printint+0x82>
}
 452:	70e2                	ld	ra,56(sp)
 454:	7442                	ld	s0,48(sp)
 456:	74a2                	ld	s1,40(sp)
 458:	7902                	ld	s2,32(sp)
 45a:	69e2                	ld	s3,24(sp)
 45c:	6121                	addi	sp,sp,64
 45e:	8082                	ret
    x = -xx;
 460:	40b005bb          	negw	a1,a1
    neg = 1;
 464:	4885                	li	a7,1
    x = -xx;
 466:	bf85                	j	3d6 <printint+0x1a>

0000000000000468 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 468:	715d                	addi	sp,sp,-80
 46a:	e486                	sd	ra,72(sp)
 46c:	e0a2                	sd	s0,64(sp)
 46e:	fc26                	sd	s1,56(sp)
 470:	f84a                	sd	s2,48(sp)
 472:	f44e                	sd	s3,40(sp)
 474:	f052                	sd	s4,32(sp)
 476:	ec56                	sd	s5,24(sp)
 478:	e85a                	sd	s6,16(sp)
 47a:	e45e                	sd	s7,8(sp)
 47c:	e062                	sd	s8,0(sp)
 47e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c903          	lbu	s2,0(a1)
 484:	18090c63          	beqz	s2,61c <vprintf+0x1b4>
 488:	8aaa                	mv	s5,a0
 48a:	8bb2                	mv	s7,a2
 48c:	00158493          	addi	s1,a1,1
  state = 0;
 490:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 492:	02500a13          	li	s4,37
 496:	4b55                	li	s6,21
 498:	a839                	j	4b6 <vprintf+0x4e>
        putc(fd, c);
 49a:	85ca                	mv	a1,s2
 49c:	8556                	mv	a0,s5
 49e:	00000097          	auipc	ra,0x0
 4a2:	efc080e7          	jalr	-260(ra) # 39a <putc>
 4a6:	a019                	j	4ac <vprintf+0x44>
    } else if(state == '%'){
 4a8:	01498d63          	beq	s3,s4,4c2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4ac:	0485                	addi	s1,s1,1
 4ae:	fff4c903          	lbu	s2,-1(s1)
 4b2:	16090563          	beqz	s2,61c <vprintf+0x1b4>
    if(state == 0){
 4b6:	fe0999e3          	bnez	s3,4a8 <vprintf+0x40>
      if(c == '%'){
 4ba:	ff4910e3          	bne	s2,s4,49a <vprintf+0x32>
        state = '%';
 4be:	89d2                	mv	s3,s4
 4c0:	b7f5                	j	4ac <vprintf+0x44>
      if(c == 'd'){
 4c2:	13490263          	beq	s2,s4,5e6 <vprintf+0x17e>
 4c6:	f9d9079b          	addiw	a5,s2,-99
 4ca:	0ff7f793          	zext.b	a5,a5
 4ce:	12fb6563          	bltu	s6,a5,5f8 <vprintf+0x190>
 4d2:	f9d9079b          	addiw	a5,s2,-99
 4d6:	0ff7f713          	zext.b	a4,a5
 4da:	10eb6f63          	bltu	s6,a4,5f8 <vprintf+0x190>
 4de:	00271793          	slli	a5,a4,0x2
 4e2:	00000717          	auipc	a4,0x0
 4e6:	33e70713          	addi	a4,a4,830 # 820 <malloc+0x106>
 4ea:	97ba                	add	a5,a5,a4
 4ec:	439c                	lw	a5,0(a5)
 4ee:	97ba                	add	a5,a5,a4
 4f0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4f2:	008b8913          	addi	s2,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	ebc080e7          	jalr	-324(ra) # 3bc <printint>
 508:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b745                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 50e:	008b8913          	addi	s2,s7,8
 512:	4681                	li	a3,0
 514:	4629                	li	a2,10
 516:	000ba583          	lw	a1,0(s7)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	ea0080e7          	jalr	-352(ra) # 3bc <printint>
 524:	8bca                	mv	s7,s2
      state = 0;
 526:	4981                	li	s3,0
 528:	b751                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 52a:	008b8913          	addi	s2,s7,8
 52e:	4681                	li	a3,0
 530:	4641                	li	a2,16
 532:	000ba583          	lw	a1,0(s7)
 536:	8556                	mv	a0,s5
 538:	00000097          	auipc	ra,0x0
 53c:	e84080e7          	jalr	-380(ra) # 3bc <printint>
 540:	8bca                	mv	s7,s2
      state = 0;
 542:	4981                	li	s3,0
 544:	b7a5                	j	4ac <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 546:	008b8c13          	addi	s8,s7,8
 54a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 54e:	03000593          	li	a1,48
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e46080e7          	jalr	-442(ra) # 39a <putc>
  putc(fd, 'x');
 55c:	07800593          	li	a1,120
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e38080e7          	jalr	-456(ra) # 39a <putc>
 56a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56c:	00000b97          	auipc	s7,0x0
 570:	30cb8b93          	addi	s7,s7,780 # 878 <digits>
 574:	03c9d793          	srli	a5,s3,0x3c
 578:	97de                	add	a5,a5,s7
 57a:	0007c583          	lbu	a1,0(a5)
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e1a080e7          	jalr	-486(ra) # 39a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 588:	0992                	slli	s3,s3,0x4
 58a:	397d                	addiw	s2,s2,-1
 58c:	fe0914e3          	bnez	s2,574 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 590:	8be2                	mv	s7,s8
      state = 0;
 592:	4981                	li	s3,0
 594:	bf21                	j	4ac <vprintf+0x44>
        s = va_arg(ap, char*);
 596:	008b8993          	addi	s3,s7,8
 59a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 59e:	02090163          	beqz	s2,5c0 <vprintf+0x158>
        while(*s != 0){
 5a2:	00094583          	lbu	a1,0(s2)
 5a6:	c9a5                	beqz	a1,616 <vprintf+0x1ae>
          putc(fd, *s);
 5a8:	8556                	mv	a0,s5
 5aa:	00000097          	auipc	ra,0x0
 5ae:	df0080e7          	jalr	-528(ra) # 39a <putc>
          s++;
 5b2:	0905                	addi	s2,s2,1
        while(*s != 0){
 5b4:	00094583          	lbu	a1,0(s2)
 5b8:	f9e5                	bnez	a1,5a8 <vprintf+0x140>
        s = va_arg(ap, char*);
 5ba:	8bce                	mv	s7,s3
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	b5fd                	j	4ac <vprintf+0x44>
          s = "(null)";
 5c0:	00000917          	auipc	s2,0x0
 5c4:	25890913          	addi	s2,s2,600 # 818 <malloc+0xfe>
        while(*s != 0){
 5c8:	02800593          	li	a1,40
 5cc:	bff1                	j	5a8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	000bc583          	lbu	a1,0(s7)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	dc2080e7          	jalr	-574(ra) # 39a <putc>
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b5e1                	j	4ac <vprintf+0x44>
        putc(fd, c);
 5e6:	02500593          	li	a1,37
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	dae080e7          	jalr	-594(ra) # 39a <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd5d                	j	4ac <vprintf+0x44>
        putc(fd, '%');
 5f8:	02500593          	li	a1,37
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	d9c080e7          	jalr	-612(ra) # 39a <putc>
        putc(fd, c);
 606:	85ca                	mv	a1,s2
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	d90080e7          	jalr	-624(ra) # 39a <putc>
      state = 0;
 612:	4981                	li	s3,0
 614:	bd61                	j	4ac <vprintf+0x44>
        s = va_arg(ap, char*);
 616:	8bce                	mv	s7,s3
      state = 0;
 618:	4981                	li	s3,0
 61a:	bd49                	j	4ac <vprintf+0x44>
    }
  }
}
 61c:	60a6                	ld	ra,72(sp)
 61e:	6406                	ld	s0,64(sp)
 620:	74e2                	ld	s1,56(sp)
 622:	7942                	ld	s2,48(sp)
 624:	79a2                	ld	s3,40(sp)
 626:	7a02                	ld	s4,32(sp)
 628:	6ae2                	ld	s5,24(sp)
 62a:	6b42                	ld	s6,16(sp)
 62c:	6ba2                	ld	s7,8(sp)
 62e:	6c02                	ld	s8,0(sp)
 630:	6161                	addi	sp,sp,80
 632:	8082                	ret

0000000000000634 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 634:	715d                	addi	sp,sp,-80
 636:	ec06                	sd	ra,24(sp)
 638:	e822                	sd	s0,16(sp)
 63a:	1000                	addi	s0,sp,32
 63c:	e010                	sd	a2,0(s0)
 63e:	e414                	sd	a3,8(s0)
 640:	e818                	sd	a4,16(s0)
 642:	ec1c                	sd	a5,24(s0)
 644:	03043023          	sd	a6,32(s0)
 648:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 64c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 650:	8622                	mv	a2,s0
 652:	00000097          	auipc	ra,0x0
 656:	e16080e7          	jalr	-490(ra) # 468 <vprintf>
}
 65a:	60e2                	ld	ra,24(sp)
 65c:	6442                	ld	s0,16(sp)
 65e:	6161                	addi	sp,sp,80
 660:	8082                	ret

0000000000000662 <printf>:

void
printf(const char *fmt, ...)
{
 662:	711d                	addi	sp,sp,-96
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	1000                	addi	s0,sp,32
 66a:	e40c                	sd	a1,8(s0)
 66c:	e810                	sd	a2,16(s0)
 66e:	ec14                	sd	a3,24(s0)
 670:	f018                	sd	a4,32(s0)
 672:	f41c                	sd	a5,40(s0)
 674:	03043823          	sd	a6,48(s0)
 678:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 67c:	00840613          	addi	a2,s0,8
 680:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 684:	85aa                	mv	a1,a0
 686:	4505                	li	a0,1
 688:	00000097          	auipc	ra,0x0
 68c:	de0080e7          	jalr	-544(ra) # 468 <vprintf>
}
 690:	60e2                	ld	ra,24(sp)
 692:	6442                	ld	s0,16(sp)
 694:	6125                	addi	sp,sp,96
 696:	8082                	ret

0000000000000698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 698:	1141                	addi	sp,sp,-16
 69a:	e422                	sd	s0,8(sp)
 69c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	00001797          	auipc	a5,0x1
 6a6:	95e7b783          	ld	a5,-1698(a5) # 1000 <freep>
 6aa:	a02d                	j	6d4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ac:	4618                	lw	a4,8(a2)
 6ae:	9f2d                	addw	a4,a4,a1
 6b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b4:	6398                	ld	a4,0(a5)
 6b6:	6310                	ld	a2,0(a4)
 6b8:	a83d                	j	6f6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ba:	ff852703          	lw	a4,-8(a0)
 6be:	9f31                	addw	a4,a4,a2
 6c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6c2:	ff053683          	ld	a3,-16(a0)
 6c6:	a091                	j	70a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c8:	6398                	ld	a4,0(a5)
 6ca:	00e7e463          	bltu	a5,a4,6d2 <free+0x3a>
 6ce:	00e6ea63          	bltu	a3,a4,6e2 <free+0x4a>
{
 6d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	fed7fae3          	bgeu	a5,a3,6c8 <free+0x30>
 6d8:	6398                	ld	a4,0(a5)
 6da:	00e6e463          	bltu	a3,a4,6e2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6de:	fee7eae3          	bltu	a5,a4,6d2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6e2:	ff852583          	lw	a1,-8(a0)
 6e6:	6390                	ld	a2,0(a5)
 6e8:	02059813          	slli	a6,a1,0x20
 6ec:	01c85713          	srli	a4,a6,0x1c
 6f0:	9736                	add	a4,a4,a3
 6f2:	fae60de3          	beq	a2,a4,6ac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fa:	4790                	lw	a2,8(a5)
 6fc:	02061593          	slli	a1,a2,0x20
 700:	01c5d713          	srli	a4,a1,0x1c
 704:	973e                	add	a4,a4,a5
 706:	fae68ae3          	beq	a3,a4,6ba <free+0x22>
    p->s.ptr = bp->s.ptr;
 70a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 70c:	00001717          	auipc	a4,0x1
 710:	8ef73a23          	sd	a5,-1804(a4) # 1000 <freep>
}
 714:	6422                	ld	s0,8(sp)
 716:	0141                	addi	sp,sp,16
 718:	8082                	ret

000000000000071a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71a:	7139                	addi	sp,sp,-64
 71c:	fc06                	sd	ra,56(sp)
 71e:	f822                	sd	s0,48(sp)
 720:	f426                	sd	s1,40(sp)
 722:	f04a                	sd	s2,32(sp)
 724:	ec4e                	sd	s3,24(sp)
 726:	e852                	sd	s4,16(sp)
 728:	e456                	sd	s5,8(sp)
 72a:	e05a                	sd	s6,0(sp)
 72c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72e:	02051493          	slli	s1,a0,0x20
 732:	9081                	srli	s1,s1,0x20
 734:	04bd                	addi	s1,s1,15
 736:	8091                	srli	s1,s1,0x4
 738:	0014899b          	addiw	s3,s1,1
 73c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 73e:	00001517          	auipc	a0,0x1
 742:	8c253503          	ld	a0,-1854(a0) # 1000 <freep>
 746:	c515                	beqz	a0,772 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74a:	4798                	lw	a4,8(a5)
 74c:	02977f63          	bgeu	a4,s1,78a <malloc+0x70>
  if(nu < 4096)
 750:	8a4e                	mv	s4,s3
 752:	0009871b          	sext.w	a4,s3
 756:	6685                	lui	a3,0x1
 758:	00d77363          	bgeu	a4,a3,75e <malloc+0x44>
 75c:	6a05                	lui	s4,0x1
 75e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 762:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 766:	00001917          	auipc	s2,0x1
 76a:	89a90913          	addi	s2,s2,-1894 # 1000 <freep>
  if(p == (char*)-1)
 76e:	5afd                	li	s5,-1
 770:	a895                	j	7e4 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 772:	00001797          	auipc	a5,0x1
 776:	89e78793          	addi	a5,a5,-1890 # 1010 <base>
 77a:	00001717          	auipc	a4,0x1
 77e:	88f73323          	sd	a5,-1914(a4) # 1000 <freep>
 782:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 784:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 788:	b7e1                	j	750 <malloc+0x36>
      if(p->s.size == nunits)
 78a:	02e48c63          	beq	s1,a4,7c2 <malloc+0xa8>
        p->s.size -= nunits;
 78e:	4137073b          	subw	a4,a4,s3
 792:	c798                	sw	a4,8(a5)
        p += p->s.size;
 794:	02071693          	slli	a3,a4,0x20
 798:	01c6d713          	srli	a4,a3,0x1c
 79c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 79e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a2:	00001717          	auipc	a4,0x1
 7a6:	84a73f23          	sd	a0,-1954(a4) # 1000 <freep>
      return (void*)(p + 1);
 7aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ae:	70e2                	ld	ra,56(sp)
 7b0:	7442                	ld	s0,48(sp)
 7b2:	74a2                	ld	s1,40(sp)
 7b4:	7902                	ld	s2,32(sp)
 7b6:	69e2                	ld	s3,24(sp)
 7b8:	6a42                	ld	s4,16(sp)
 7ba:	6aa2                	ld	s5,8(sp)
 7bc:	6b02                	ld	s6,0(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	e118                	sd	a4,0(a0)
 7c6:	bff1                	j	7a2 <malloc+0x88>
  hp->s.size = nu;
 7c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7cc:	0541                	addi	a0,a0,16
 7ce:	00000097          	auipc	ra,0x0
 7d2:	eca080e7          	jalr	-310(ra) # 698 <free>
  return freep;
 7d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7da:	d971                	beqz	a0,7ae <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7de:	4798                	lw	a4,8(a5)
 7e0:	fa9775e3          	bgeu	a4,s1,78a <malloc+0x70>
    if(p == freep)
 7e4:	00093703          	ld	a4,0(s2)
 7e8:	853e                	mv	a0,a5
 7ea:	fef719e3          	bne	a4,a5,7dc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7ee:	8552                	mv	a0,s4
 7f0:	00000097          	auipc	ra,0x0
 7f4:	b82080e7          	jalr	-1150(ra) # 372 <sbrk>
  if(p == (char*)-1)
 7f8:	fd5518e3          	bne	a0,s5,7c8 <malloc+0xae>
        return 0;
 7fc:	4501                	li	a0,0
 7fe:	bf45                	j	7ae <malloc+0x94>
