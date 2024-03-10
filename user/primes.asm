
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <lpipe_first_data>:
// int pid;
int status;
int count;
// int first;

int lpipe_first_data(int *lpipe, int *first){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
    // printf("a\n");
    if(read(lpipe[RD], first, sizeof(int)) == sizeof(int)){
   c:	4611                	li	a2,4
   e:	4108                	lw	a0,0(a0)
  10:	00000097          	auipc	ra,0x0
  14:	478080e7          	jalr	1144(ra) # 488 <read>
  18:	4791                	li	a5,4
  1a:	00f50863          	beq	a0,a5,2a <lpipe_first_data+0x2a>
        printf("prime %d\n", *first);
        return 0;
    }
    // printf("b\n");
    return 1;
  1e:	4505                	li	a0,1
}
  20:	60e2                	ld	ra,24(sp)
  22:	6442                	ld	s0,16(sp)
  24:	64a2                	ld	s1,8(sp)
  26:	6105                	addi	sp,sp,32
  28:	8082                	ret
        printf("prime %d\n", *first);
  2a:	408c                	lw	a1,0(s1)
  2c:	00001517          	auipc	a0,0x1
  30:	96450513          	addi	a0,a0,-1692 # 990 <malloc+0xf0>
  34:	00000097          	auipc	ra,0x0
  38:	7b4080e7          	jalr	1972(ra) # 7e8 <printf>
        return 0;
  3c:	4501                	li	a0,0
  3e:	b7cd                	j	20 <lpipe_first_data+0x20>

0000000000000040 <transmit_data>:

void transmit_data(int *lpipe, int *rpipe, int first){
  40:	7139                	addi	sp,sp,-64
  42:	fc06                	sd	ra,56(sp)
  44:	f822                	sd	s0,48(sp)
  46:	f426                	sd	s1,40(sp)
  48:	f04a                	sd	s2,32(sp)
  4a:	ec4e                	sd	s3,24(sp)
  4c:	0080                	addi	s0,sp,64
  4e:	84aa                	mv	s1,a0
  50:	89ae                	mv	s3,a1
  52:	8932                	mv	s2,a2
    int data;
    while(read(lpipe[RD], &data, sizeof(int)) == sizeof(int)){  /**/
  54:	4611                	li	a2,4
  56:	fcc40593          	addi	a1,s0,-52
  5a:	4088                	lw	a0,0(s1)
  5c:	00000097          	auipc	ra,0x0
  60:	42c080e7          	jalr	1068(ra) # 488 <read>
  64:	4791                	li	a5,4
  66:	02f51163          	bne	a0,a5,88 <transmit_data+0x48>
        if(data % first){
  6a:	fcc42783          	lw	a5,-52(s0)
  6e:	0327e7bb          	remw	a5,a5,s2
  72:	d3ed                	beqz	a5,54 <transmit_data+0x14>
            write(rpipe[WR], &data, sizeof(int));
  74:	4611                	li	a2,4
  76:	fcc40593          	addi	a1,s0,-52
  7a:	0049a503          	lw	a0,4(s3)
  7e:	00000097          	auipc	ra,0x0
  82:	412080e7          	jalr	1042(ra) # 490 <write>
  86:	b7f9                	j	54 <transmit_data+0x14>
            // printf("%d ", data);
        }
    }
    close(lpipe[RD]);
  88:	4088                	lw	a0,0(s1)
  8a:	00000097          	auipc	ra,0x0
  8e:	40e080e7          	jalr	1038(ra) # 498 <close>
    close(rpipe[WR]);
  92:	0049a503          	lw	a0,4(s3)
  96:	00000097          	auipc	ra,0x0
  9a:	402080e7          	jalr	1026(ra) # 498 <close>
    // printf("\ne----------\n");
}
  9e:	70e2                	ld	ra,56(sp)
  a0:	7442                	ld	s0,48(sp)
  a2:	74a2                	ld	s1,40(sp)
  a4:	7902                	ld	s2,32(sp)
  a6:	69e2                	ld	s3,24(sp)
  a8:	6121                	addi	sp,sp,64
  aa:	8082                	ret

00000000000000ac <primes>:

void primes(int *lpipe){
  ac:	7179                	addi	sp,sp,-48
  ae:	f406                	sd	ra,40(sp)
  b0:	f022                	sd	s0,32(sp)
  b2:	ec26                	sd	s1,24(sp)
  b4:	1800                	addi	s0,sp,48
  b6:	84aa                	mv	s1,a0
    int first;
    
    close(lpipe[WR]);
  b8:	4148                	lw	a0,4(a0)
  ba:	00000097          	auipc	ra,0x0
  be:	3de080e7          	jalr	990(ra) # 498 <close>
    // printf("d\n");  /**/
    if(lpipe_first_data(lpipe, &first)){
  c2:	fdc40593          	addi	a1,s0,-36
  c6:	8526                	mv	a0,s1
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <lpipe_first_data>
  d0:	e521                	bnez	a0,118 <primes+0x6c>
        // printf("exit\n");
        exit(0);
    }
    int rpipe[2];
    pipe(rpipe);
  d2:	fd040513          	addi	a0,s0,-48
  d6:	00000097          	auipc	ra,0x0
  da:	3aa080e7          	jalr	938(ra) # 480 <pipe>

    // printf("first = %d---------", first);

    transmit_data(lpipe, rpipe, first);
  de:	fdc42603          	lw	a2,-36(s0)
  e2:	fd040593          	addi	a1,s0,-48
  e6:	8526                	mv	a0,s1
  e8:	00000097          	auipc	ra,0x0
  ec:	f58080e7          	jalr	-168(ra) # 40 <transmit_data>
    switch(fork()){
  f0:	00000097          	auipc	ra,0x0
  f4:	378080e7          	jalr	888(ra) # 468 <fork>
  f8:	57fd                	li	a5,-1
  fa:	02f50463          	beq	a0,a5,122 <primes+0x76>
  fe:	cd1d                	beqz	a0,13c <primes+0x90>
        case 0:     /*child*/
            // printf("child %d\n", count++);
            primes(rpipe);
            break;
        default:    /*parent*/
            close(rpipe[RD]);
 100:	fd042503          	lw	a0,-48(s0)
 104:	00000097          	auipc	ra,0x0
 108:	394080e7          	jalr	916(ra) # 498 <close>
            wait(0);
 10c:	4501                	li	a0,0
 10e:	00000097          	auipc	ra,0x0
 112:	36a080e7          	jalr	874(ra) # 478 <wait>
            // printf("parent end\n");
            break;
    }
}
 116:	a831                	j	132 <primes+0x86>
        exit(0);
 118:	4501                	li	a0,0
 11a:	00000097          	auipc	ra,0x0
 11e:	356080e7          	jalr	854(ra) # 470 <exit>
            printf("error shit\n");
 122:	00001517          	auipc	a0,0x1
 126:	87e50513          	addi	a0,a0,-1922 # 9a0 <malloc+0x100>
 12a:	00000097          	auipc	ra,0x0
 12e:	6be080e7          	jalr	1726(ra) # 7e8 <printf>
}
 132:	70a2                	ld	ra,40(sp)
 134:	7402                	ld	s0,32(sp)
 136:	64e2                	ld	s1,24(sp)
 138:	6145                	addi	sp,sp,48
 13a:	8082                	ret
            primes(rpipe);
 13c:	fd040513          	addi	a0,s0,-48
 140:	00000097          	auipc	ra,0x0
 144:	f6c080e7          	jalr	-148(ra) # ac <primes>
            break;
 148:	b7ed                	j	132 <primes+0x86>

000000000000014a <main>:


int main(int argc, const char* argv){
 14a:	7179                	addi	sp,sp,-48
 14c:	f406                	sd	ra,40(sp)
 14e:	f022                	sd	s0,32(sp)
 150:	ec26                	sd	s1,24(sp)
 152:	1800                	addi	s0,sp,48
    int lpipe[2];
    int i;
    pipe(lpipe);
 154:	fd840513          	addi	a0,s0,-40
 158:	00000097          	auipc	ra,0x0
 15c:	328080e7          	jalr	808(ra) # 480 <pipe>
    for(i = 2; i <= N ;++i){
 160:	4789                	li	a5,2
 162:	fcf42a23          	sw	a5,-44(s0)
 166:	02300493          	li	s1,35
        write(lpipe[WR], &i, sizeof(int));
 16a:	4611                	li	a2,4
 16c:	fd440593          	addi	a1,s0,-44
 170:	fdc42503          	lw	a0,-36(s0)
 174:	00000097          	auipc	ra,0x0
 178:	31c080e7          	jalr	796(ra) # 490 <write>
    for(i = 2; i <= N ;++i){
 17c:	fd442783          	lw	a5,-44(s0)
 180:	2785                	addiw	a5,a5,1
 182:	0007871b          	sext.w	a4,a5
 186:	fcf42a23          	sw	a5,-44(s0)
 18a:	fee4d0e3          	bge	s1,a4,16a <main+0x20>
    }
    
    switch(fork()){
 18e:	00000097          	auipc	ra,0x0
 192:	2da080e7          	jalr	730(ra) # 468 <fork>
 196:	57fd                	li	a5,-1
 198:	02f50963          	beq	a0,a5,1ca <main+0x80>
 19c:	cd05                	beqz	a0,1d4 <main+0x8a>
        case 0:     /*child*/
            // printf("child %d\n", count++);
            primes(lpipe);
            exit(0);
        default:    /*parent*/
            close(lpipe[RD]);
 19e:	fd842503          	lw	a0,-40(s0)
 1a2:	00000097          	auipc	ra,0x0
 1a6:	2f6080e7          	jalr	758(ra) # 498 <close>
            close(lpipe[WR]);
 1aa:	fdc42503          	lw	a0,-36(s0)
 1ae:	00000097          	auipc	ra,0x0
 1b2:	2ea080e7          	jalr	746(ra) # 498 <close>
            wait(0);
 1b6:	4501                	li	a0,0
 1b8:	00000097          	auipc	ra,0x0
 1bc:	2c0080e7          	jalr	704(ra) # 478 <wait>
            exit(0);
 1c0:	4501                	li	a0,0
 1c2:	00000097          	auipc	ra,0x0
 1c6:	2ae080e7          	jalr	686(ra) # 470 <exit>
            exit(-1);
 1ca:	557d                	li	a0,-1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	2a4080e7          	jalr	676(ra) # 470 <exit>
            primes(lpipe);
 1d4:	fd840513          	addi	a0,s0,-40
 1d8:	00000097          	auipc	ra,0x0
 1dc:	ed4080e7          	jalr	-300(ra) # ac <primes>
            exit(0);
 1e0:	4501                	li	a0,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	28e080e7          	jalr	654(ra) # 470 <exit>

00000000000001ea <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1f2:	00000097          	auipc	ra,0x0
 1f6:	f58080e7          	jalr	-168(ra) # 14a <main>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	274080e7          	jalr	628(ra) # 470 <exit>

0000000000000204 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 20a:	87aa                	mv	a5,a0
 20c:	0585                	addi	a1,a1,1
 20e:	0785                	addi	a5,a5,1
 210:	fff5c703          	lbu	a4,-1(a1)
 214:	fee78fa3          	sb	a4,-1(a5)
 218:	fb75                	bnez	a4,20c <strcpy+0x8>
    ;
  return os;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb91                	beqz	a5,23e <strcmp+0x1e>
 22c:	0005c703          	lbu	a4,0(a1)
 230:	00f71763          	bne	a4,a5,23e <strcmp+0x1e>
    p++, q++;
 234:	0505                	addi	a0,a0,1
 236:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	fbe5                	bnez	a5,22c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 23e:	0005c503          	lbu	a0,0(a1)
}
 242:	40a7853b          	subw	a0,a5,a0
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strlen>:

uint
strlen(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 252:	00054783          	lbu	a5,0(a0)
 256:	cf91                	beqz	a5,272 <strlen+0x26>
 258:	0505                	addi	a0,a0,1
 25a:	87aa                	mv	a5,a0
 25c:	86be                	mv	a3,a5
 25e:	0785                	addi	a5,a5,1
 260:	fff7c703          	lbu	a4,-1(a5)
 264:	ff65                	bnez	a4,25c <strlen+0x10>
 266:	40a6853b          	subw	a0,a3,a0
 26a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  for(n = 0; s[n]; n++)
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strlen+0x20>

0000000000000276 <memset>:

void*
memset(void *dst, int c, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 27c:	ca19                	beqz	a2,292 <memset+0x1c>
 27e:	87aa                	mv	a5,a0
 280:	1602                	slli	a2,a2,0x20
 282:	9201                	srli	a2,a2,0x20
 284:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 288:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 28c:	0785                	addi	a5,a5,1
 28e:	fee79de3          	bne	a5,a4,288 <memset+0x12>
  }
  return dst;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strchr>:

char*
strchr(const char *s, char c)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	cb99                	beqz	a5,2b8 <strchr+0x20>
    if(*s == c)
 2a4:	00f58763          	beq	a1,a5,2b2 <strchr+0x1a>
  for(; *s; s++)
 2a8:	0505                	addi	a0,a0,1
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbfd                	bnez	a5,2a4 <strchr+0xc>
      return (char*)s;
  return 0;
 2b0:	4501                	li	a0,0
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strchr+0x1a>

00000000000002bc <gets>:

char*
gets(char *buf, int max)
{
 2bc:	711d                	addi	sp,sp,-96
 2be:	ec86                	sd	ra,88(sp)
 2c0:	e8a2                	sd	s0,80(sp)
 2c2:	e4a6                	sd	s1,72(sp)
 2c4:	e0ca                	sd	s2,64(sp)
 2c6:	fc4e                	sd	s3,56(sp)
 2c8:	f852                	sd	s4,48(sp)
 2ca:	f456                	sd	s5,40(sp)
 2cc:	f05a                	sd	s6,32(sp)
 2ce:	ec5e                	sd	s7,24(sp)
 2d0:	1080                	addi	s0,sp,96
 2d2:	8baa                	mv	s7,a0
 2d4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	892a                	mv	s2,a0
 2d8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2da:	4aa9                	li	s5,10
 2dc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2de:	89a6                	mv	s3,s1
 2e0:	2485                	addiw	s1,s1,1
 2e2:	0344d863          	bge	s1,s4,312 <gets+0x56>
    cc = read(0, &c, 1);
 2e6:	4605                	li	a2,1
 2e8:	faf40593          	addi	a1,s0,-81
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	19a080e7          	jalr	410(ra) # 488 <read>
    if(cc < 1)
 2f6:	00a05e63          	blez	a0,312 <gets+0x56>
    buf[i++] = c;
 2fa:	faf44783          	lbu	a5,-81(s0)
 2fe:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 302:	01578763          	beq	a5,s5,310 <gets+0x54>
 306:	0905                	addi	s2,s2,1
 308:	fd679be3          	bne	a5,s6,2de <gets+0x22>
  for(i=0; i+1 < max; ){
 30c:	89a6                	mv	s3,s1
 30e:	a011                	j	312 <gets+0x56>
 310:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 312:	99de                	add	s3,s3,s7
 314:	00098023          	sb	zero,0(s3)
  return buf;
}
 318:	855e                	mv	a0,s7
 31a:	60e6                	ld	ra,88(sp)
 31c:	6446                	ld	s0,80(sp)
 31e:	64a6                	ld	s1,72(sp)
 320:	6906                	ld	s2,64(sp)
 322:	79e2                	ld	s3,56(sp)
 324:	7a42                	ld	s4,48(sp)
 326:	7aa2                	ld	s5,40(sp)
 328:	7b02                	ld	s6,32(sp)
 32a:	6be2                	ld	s7,24(sp)
 32c:	6125                	addi	sp,sp,96
 32e:	8082                	ret

0000000000000330 <stat>:

int
stat(const char *n, struct stat *st)
{
 330:	1101                	addi	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	e426                	sd	s1,8(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33e:	4581                	li	a1,0
 340:	00000097          	auipc	ra,0x0
 344:	170080e7          	jalr	368(ra) # 4b0 <open>
  if(fd < 0)
 348:	02054563          	bltz	a0,372 <stat+0x42>
 34c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34e:	85ca                	mv	a1,s2
 350:	00000097          	auipc	ra,0x0
 354:	178080e7          	jalr	376(ra) # 4c8 <fstat>
 358:	892a                	mv	s2,a0
  close(fd);
 35a:	8526                	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	13c080e7          	jalr	316(ra) # 498 <close>
  return r;
}
 364:	854a                	mv	a0,s2
 366:	60e2                	ld	ra,24(sp)
 368:	6442                	ld	s0,16(sp)
 36a:	64a2                	ld	s1,8(sp)
 36c:	6902                	ld	s2,0(sp)
 36e:	6105                	addi	sp,sp,32
 370:	8082                	ret
    return -1;
 372:	597d                	li	s2,-1
 374:	bfc5                	j	364 <stat+0x34>

0000000000000376 <atoi>:

int
atoi(const char *s)
{
 376:	1141                	addi	sp,sp,-16
 378:	e422                	sd	s0,8(sp)
 37a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	00054683          	lbu	a3,0(a0)
 380:	fd06879b          	addiw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	4625                	li	a2,9
 38a:	02f66863          	bltu	a2,a5,3ba <atoi+0x44>
 38e:	872a                	mv	a4,a0
  n = 0;
 390:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 392:	0705                	addi	a4,a4,1
 394:	0025179b          	slliw	a5,a0,0x2
 398:	9fa9                	addw	a5,a5,a0
 39a:	0017979b          	slliw	a5,a5,0x1
 39e:	9fb5                	addw	a5,a5,a3
 3a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a4:	00074683          	lbu	a3,0(a4)
 3a8:	fd06879b          	addiw	a5,a3,-48
 3ac:	0ff7f793          	zext.b	a5,a5
 3b0:	fef671e3          	bgeu	a2,a5,392 <atoi+0x1c>
  return n;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret
  n = 0;
 3ba:	4501                	li	a0,0
 3bc:	bfe5                	j	3b4 <atoi+0x3e>

00000000000003be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c4:	02b57463          	bgeu	a0,a1,3ec <memmove+0x2e>
    while(n-- > 0)
 3c8:	00c05f63          	blez	a2,3e6 <memmove+0x28>
 3cc:	1602                	slli	a2,a2,0x20
 3ce:	9201                	srli	a2,a2,0x20
 3d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d6:	0585                	addi	a1,a1,1
 3d8:	0705                	addi	a4,a4,1
 3da:	fff5c683          	lbu	a3,-1(a1)
 3de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e2:	fee79ae3          	bne	a5,a4,3d6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
    dst += n;
 3ec:	00c50733          	add	a4,a0,a2
    src += n;
 3f0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f2:	fec05ae3          	blez	a2,3e6 <memmove+0x28>
 3f6:	fff6079b          	addiw	a5,a2,-1
 3fa:	1782                	slli	a5,a5,0x20
 3fc:	9381                	srli	a5,a5,0x20
 3fe:	fff7c793          	not	a5,a5
 402:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 404:	15fd                	addi	a1,a1,-1
 406:	177d                	addi	a4,a4,-1
 408:	0005c683          	lbu	a3,0(a1)
 40c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 410:	fee79ae3          	bne	a5,a4,404 <memmove+0x46>
 414:	bfc9                	j	3e6 <memmove+0x28>

0000000000000416 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e422                	sd	s0,8(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca05                	beqz	a2,44c <memcmp+0x36>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x14>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x30>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  return 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <memcmp+0x30>

0000000000000450 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 458:	00000097          	auipc	ra,0x0
 45c:	f66080e7          	jalr	-154(ra) # 3be <memmove>
}
 460:	60a2                	ld	ra,8(sp)
 462:	6402                	ld	s0,0(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret

0000000000000468 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 468:	4885                	li	a7,1
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	4889                	li	a7,2
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <wait>:
.global wait
wait:
 li a7, SYS_wait
 478:	488d                	li	a7,3
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 480:	4891                	li	a7,4
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <read>:
.global read
read:
 li a7, SYS_read
 488:	4895                	li	a7,5
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <write>:
.global write
write:
 li a7, SYS_write
 490:	48c1                	li	a7,16
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <close>:
.global close
close:
 li a7, SYS_close
 498:	48d5                	li	a7,21
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a0:	4899                	li	a7,6
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a8:	489d                	li	a7,7
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <open>:
.global open
open:
 li a7, SYS_open
 4b0:	48bd                	li	a7,15
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b8:	48c5                	li	a7,17
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c0:	48c9                	li	a7,18
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c8:	48a1                	li	a7,8
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <link>:
.global link
link:
 li a7, SYS_link
 4d0:	48cd                	li	a7,19
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d8:	48d1                	li	a7,20
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e0:	48a5                	li	a7,9
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e8:	48a9                	li	a7,10
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f0:	48ad                	li	a7,11
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f8:	48b1                	li	a7,12
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 500:	48b5                	li	a7,13
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 508:	48b9                	li	a7,14
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <trace>:
.global trace
trace:
 li a7, SYS_trace
 510:	48d9                	li	a7,22
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 518:	48dd                	li	a7,23
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 520:	1101                	addi	sp,sp,-32
 522:	ec06                	sd	ra,24(sp)
 524:	e822                	sd	s0,16(sp)
 526:	1000                	addi	s0,sp,32
 528:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 52c:	4605                	li	a2,1
 52e:	fef40593          	addi	a1,s0,-17
 532:	00000097          	auipc	ra,0x0
 536:	f5e080e7          	jalr	-162(ra) # 490 <write>
}
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	6105                	addi	sp,sp,32
 540:	8082                	ret

0000000000000542 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 542:	7139                	addi	sp,sp,-64
 544:	fc06                	sd	ra,56(sp)
 546:	f822                	sd	s0,48(sp)
 548:	f426                	sd	s1,40(sp)
 54a:	f04a                	sd	s2,32(sp)
 54c:	ec4e                	sd	s3,24(sp)
 54e:	0080                	addi	s0,sp,64
 550:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 552:	c299                	beqz	a3,558 <printint+0x16>
 554:	0805c963          	bltz	a1,5e6 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 558:	2581                	sext.w	a1,a1
  neg = 0;
 55a:	4881                	li	a7,0
 55c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 560:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 562:	2601                	sext.w	a2,a2
 564:	00000517          	auipc	a0,0x0
 568:	4ac50513          	addi	a0,a0,1196 # a10 <digits>
 56c:	883a                	mv	a6,a4
 56e:	2705                	addiw	a4,a4,1
 570:	02c5f7bb          	remuw	a5,a1,a2
 574:	1782                	slli	a5,a5,0x20
 576:	9381                	srli	a5,a5,0x20
 578:	97aa                	add	a5,a5,a0
 57a:	0007c783          	lbu	a5,0(a5)
 57e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 582:	0005879b          	sext.w	a5,a1
 586:	02c5d5bb          	divuw	a1,a1,a2
 58a:	0685                	addi	a3,a3,1
 58c:	fec7f0e3          	bgeu	a5,a2,56c <printint+0x2a>
  if(neg)
 590:	00088c63          	beqz	a7,5a8 <printint+0x66>
    buf[i++] = '-';
 594:	fd070793          	addi	a5,a4,-48
 598:	00878733          	add	a4,a5,s0
 59c:	02d00793          	li	a5,45
 5a0:	fef70823          	sb	a5,-16(a4)
 5a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5a8:	02e05863          	blez	a4,5d8 <printint+0x96>
 5ac:	fc040793          	addi	a5,s0,-64
 5b0:	00e78933          	add	s2,a5,a4
 5b4:	fff78993          	addi	s3,a5,-1
 5b8:	99ba                	add	s3,s3,a4
 5ba:	377d                	addiw	a4,a4,-1
 5bc:	1702                	slli	a4,a4,0x20
 5be:	9301                	srli	a4,a4,0x20
 5c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c4:	fff94583          	lbu	a1,-1(s2)
 5c8:	8526                	mv	a0,s1
 5ca:	00000097          	auipc	ra,0x0
 5ce:	f56080e7          	jalr	-170(ra) # 520 <putc>
  while(--i >= 0)
 5d2:	197d                	addi	s2,s2,-1
 5d4:	ff3918e3          	bne	s2,s3,5c4 <printint+0x82>
}
 5d8:	70e2                	ld	ra,56(sp)
 5da:	7442                	ld	s0,48(sp)
 5dc:	74a2                	ld	s1,40(sp)
 5de:	7902                	ld	s2,32(sp)
 5e0:	69e2                	ld	s3,24(sp)
 5e2:	6121                	addi	sp,sp,64
 5e4:	8082                	ret
    x = -xx;
 5e6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ea:	4885                	li	a7,1
    x = -xx;
 5ec:	bf85                	j	55c <printint+0x1a>

00000000000005ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ee:	715d                	addi	sp,sp,-80
 5f0:	e486                	sd	ra,72(sp)
 5f2:	e0a2                	sd	s0,64(sp)
 5f4:	fc26                	sd	s1,56(sp)
 5f6:	f84a                	sd	s2,48(sp)
 5f8:	f44e                	sd	s3,40(sp)
 5fa:	f052                	sd	s4,32(sp)
 5fc:	ec56                	sd	s5,24(sp)
 5fe:	e85a                	sd	s6,16(sp)
 600:	e45e                	sd	s7,8(sp)
 602:	e062                	sd	s8,0(sp)
 604:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 606:	0005c903          	lbu	s2,0(a1)
 60a:	18090c63          	beqz	s2,7a2 <vprintf+0x1b4>
 60e:	8aaa                	mv	s5,a0
 610:	8bb2                	mv	s7,a2
 612:	00158493          	addi	s1,a1,1
  state = 0;
 616:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 618:	02500a13          	li	s4,37
 61c:	4b55                	li	s6,21
 61e:	a839                	j	63c <vprintf+0x4e>
        putc(fd, c);
 620:	85ca                	mv	a1,s2
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	efc080e7          	jalr	-260(ra) # 520 <putc>
 62c:	a019                	j	632 <vprintf+0x44>
    } else if(state == '%'){
 62e:	01498d63          	beq	s3,s4,648 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 632:	0485                	addi	s1,s1,1
 634:	fff4c903          	lbu	s2,-1(s1)
 638:	16090563          	beqz	s2,7a2 <vprintf+0x1b4>
    if(state == 0){
 63c:	fe0999e3          	bnez	s3,62e <vprintf+0x40>
      if(c == '%'){
 640:	ff4910e3          	bne	s2,s4,620 <vprintf+0x32>
        state = '%';
 644:	89d2                	mv	s3,s4
 646:	b7f5                	j	632 <vprintf+0x44>
      if(c == 'd'){
 648:	13490263          	beq	s2,s4,76c <vprintf+0x17e>
 64c:	f9d9079b          	addiw	a5,s2,-99
 650:	0ff7f793          	zext.b	a5,a5
 654:	12fb6563          	bltu	s6,a5,77e <vprintf+0x190>
 658:	f9d9079b          	addiw	a5,s2,-99
 65c:	0ff7f713          	zext.b	a4,a5
 660:	10eb6f63          	bltu	s6,a4,77e <vprintf+0x190>
 664:	00271793          	slli	a5,a4,0x2
 668:	00000717          	auipc	a4,0x0
 66c:	35070713          	addi	a4,a4,848 # 9b8 <malloc+0x118>
 670:	97ba                	add	a5,a5,a4
 672:	439c                	lw	a5,0(a5)
 674:	97ba                	add	a5,a5,a4
 676:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b8913          	addi	s2,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	ebc080e7          	jalr	-324(ra) # 542 <printint>
 68e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 690:	4981                	li	s3,0
 692:	b745                	j	632 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 694:	008b8913          	addi	s2,s7,8
 698:	4681                	li	a3,0
 69a:	4629                	li	a2,10
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	ea0080e7          	jalr	-352(ra) # 542 <printint>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b751                	j	632 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000ba583          	lw	a1,0(s7)
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e84080e7          	jalr	-380(ra) # 542 <printint>
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b7a5                	j	632 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 6cc:	008b8c13          	addi	s8,s7,8
 6d0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d4:	03000593          	li	a1,48
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e46080e7          	jalr	-442(ra) # 520 <putc>
  putc(fd, 'x');
 6e2:	07800593          	li	a1,120
 6e6:	8556                	mv	a0,s5
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e38080e7          	jalr	-456(ra) # 520 <putc>
 6f0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f2:	00000b97          	auipc	s7,0x0
 6f6:	31eb8b93          	addi	s7,s7,798 # a10 <digits>
 6fa:	03c9d793          	srli	a5,s3,0x3c
 6fe:	97de                	add	a5,a5,s7
 700:	0007c583          	lbu	a1,0(a5)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e1a080e7          	jalr	-486(ra) # 520 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	397d                	addiw	s2,s2,-1
 712:	fe0914e3          	bnez	s2,6fa <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 716:	8be2                	mv	s7,s8
      state = 0;
 718:	4981                	li	s3,0
 71a:	bf21                	j	632 <vprintf+0x44>
        s = va_arg(ap, char*);
 71c:	008b8993          	addi	s3,s7,8
 720:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 724:	02090163          	beqz	s2,746 <vprintf+0x158>
        while(*s != 0){
 728:	00094583          	lbu	a1,0(s2)
 72c:	c9a5                	beqz	a1,79c <vprintf+0x1ae>
          putc(fd, *s);
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	df0080e7          	jalr	-528(ra) # 520 <putc>
          s++;
 738:	0905                	addi	s2,s2,1
        while(*s != 0){
 73a:	00094583          	lbu	a1,0(s2)
 73e:	f9e5                	bnez	a1,72e <vprintf+0x140>
        s = va_arg(ap, char*);
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	b5fd                	j	632 <vprintf+0x44>
          s = "(null)";
 746:	00000917          	auipc	s2,0x0
 74a:	26a90913          	addi	s2,s2,618 # 9b0 <malloc+0x110>
        while(*s != 0){
 74e:	02800593          	li	a1,40
 752:	bff1                	j	72e <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 754:	008b8913          	addi	s2,s7,8
 758:	000bc583          	lbu	a1,0(s7)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	dc2080e7          	jalr	-574(ra) # 520 <putc>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	b5e1                	j	632 <vprintf+0x44>
        putc(fd, c);
 76c:	02500593          	li	a1,37
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	dae080e7          	jalr	-594(ra) # 520 <putc>
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bd5d                	j	632 <vprintf+0x44>
        putc(fd, '%');
 77e:	02500593          	li	a1,37
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	d9c080e7          	jalr	-612(ra) # 520 <putc>
        putc(fd, c);
 78c:	85ca                	mv	a1,s2
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	d90080e7          	jalr	-624(ra) # 520 <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	bd61                	j	632 <vprintf+0x44>
        s = va_arg(ap, char*);
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bd49                	j	632 <vprintf+0x44>
    }
  }
}
 7a2:	60a6                	ld	ra,72(sp)
 7a4:	6406                	ld	s0,64(sp)
 7a6:	74e2                	ld	s1,56(sp)
 7a8:	7942                	ld	s2,48(sp)
 7aa:	79a2                	ld	s3,40(sp)
 7ac:	7a02                	ld	s4,32(sp)
 7ae:	6ae2                	ld	s5,24(sp)
 7b0:	6b42                	ld	s6,16(sp)
 7b2:	6ba2                	ld	s7,8(sp)
 7b4:	6c02                	ld	s8,0(sp)
 7b6:	6161                	addi	sp,sp,80
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	8622                	mv	a2,s0
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e16080e7          	jalr	-490(ra) # 5ee <vprintf>
}
 7e0:	60e2                	ld	ra,24(sp)
 7e2:	6442                	ld	s0,16(sp)
 7e4:	6161                	addi	sp,sp,80
 7e6:	8082                	ret

00000000000007e8 <printf>:

void
printf(const char *fmt, ...)
{
 7e8:	711d                	addi	sp,sp,-96
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e40c                	sd	a1,8(s0)
 7f2:	e810                	sd	a2,16(s0)
 7f4:	ec14                	sd	a3,24(s0)
 7f6:	f018                	sd	a4,32(s0)
 7f8:	f41c                	sd	a5,40(s0)
 7fa:	03043823          	sd	a6,48(s0)
 7fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 802:	00840613          	addi	a2,s0,8
 806:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80a:	85aa                	mv	a1,a0
 80c:	4505                	li	a0,1
 80e:	00000097          	auipc	ra,0x0
 812:	de0080e7          	jalr	-544(ra) # 5ee <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6125                	addi	sp,sp,96
 81c:	8082                	ret

000000000000081e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e422                	sd	s0,8(sp)
 822:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 824:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	00000797          	auipc	a5,0x0
 82c:	7e07b783          	ld	a5,2016(a5) # 1008 <freep>
 830:	a02d                	j	85a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 832:	4618                	lw	a4,8(a2)
 834:	9f2d                	addw	a4,a4,a1
 836:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	6398                	ld	a4,0(a5)
 83c:	6310                	ld	a2,0(a4)
 83e:	a83d                	j	87c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 840:	ff852703          	lw	a4,-8(a0)
 844:	9f31                	addw	a4,a4,a2
 846:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 848:	ff053683          	ld	a3,-16(a0)
 84c:	a091                	j	890 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x3a>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x4a>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x30>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	slli	a6,a1,0x20
 872:	01c85713          	srli	a4,a6,0x1c
 876:	9736                	add	a4,a4,a3
 878:	fae60de3          	beq	a2,a4,832 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	slli	a1,a2,0x20
 886:	01c5d713          	srli	a4,a1,0x1c
 88a:	973e                	add	a4,a4,a5
 88c:	fae68ae3          	beq	a3,a4,840 <free+0x22>
    p->s.ptr = bp->s.ptr;
 890:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73b23          	sd	a5,1910(a4) # 1008 <freep>
}
 89a:	6422                	ld	s0,8(sp)
 89c:	0141                	addi	sp,sp,16
 89e:	8082                	ret

00000000000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	7139                	addi	sp,sp,-64
 8a2:	fc06                	sd	ra,56(sp)
 8a4:	f822                	sd	s0,48(sp)
 8a6:	f426                	sd	s1,40(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	e852                	sd	s4,16(sp)
 8ae:	e456                	sd	s5,8(sp)
 8b0:	e05a                	sd	s6,0(sp)
 8b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	74453503          	ld	a0,1860(a0) # 1008 <freep>
 8cc:	c515                	beqz	a0,8f8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	02977f63          	bgeu	a4,s1,910 <malloc+0x70>
  if(nu < 4096)
 8d6:	8a4e                	mv	s4,s3
 8d8:	0009871b          	sext.w	a4,s3
 8dc:	6685                	lui	a3,0x1
 8de:	00d77363          	bgeu	a4,a3,8e4 <malloc+0x44>
 8e2:	6a05                	lui	s4,0x1
 8e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ec:	00000917          	auipc	s2,0x0
 8f0:	71c90913          	addi	s2,s2,1820 # 1008 <freep>
  if(p == (char*)-1)
 8f4:	5afd                	li	s5,-1
 8f6:	a895                	j	96a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8f8:	00001797          	auipc	a5,0x1
 8fc:	8a878793          	addi	a5,a5,-1880 # 11a0 <base>
 900:	00000717          	auipc	a4,0x0
 904:	70f73423          	sd	a5,1800(a4) # 1008 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7e1                	j	8d6 <malloc+0x36>
      if(p->s.size == nunits)
 910:	02e48c63          	beq	s1,a4,948 <malloc+0xa8>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	slli	a3,a4,0x20
 91e:	01c6d713          	srli	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ea73023          	sd	a0,1760(a4) # 1008 <freep>
      return (void*)(p + 1);
 930:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	74a2                	ld	s1,40(sp)
 93a:	7902                	ld	s2,32(sp)
 93c:	69e2                	ld	s3,24(sp)
 93e:	6a42                	ld	s4,16(sp)
 940:	6aa2                	ld	s5,8(sp)
 942:	6b02                	ld	s6,0(sp)
 944:	6121                	addi	sp,sp,64
 946:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	e118                	sd	a4,0(a0)
 94c:	bff1                	j	928 <malloc+0x88>
  hp->s.size = nu;
 94e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 952:	0541                	addi	a0,a0,16
 954:	00000097          	auipc	ra,0x0
 958:	eca080e7          	jalr	-310(ra) # 81e <free>
  return freep;
 95c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 960:	d971                	beqz	a0,934 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 962:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 964:	4798                	lw	a4,8(a5)
 966:	fa9775e3          	bgeu	a4,s1,910 <malloc+0x70>
    if(p == freep)
 96a:	00093703          	ld	a4,0(s2)
 96e:	853e                	mv	a0,a5
 970:	fef719e3          	bne	a4,a5,962 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 974:	8552                	mv	a0,s4
 976:	00000097          	auipc	ra,0x0
 97a:	b82080e7          	jalr	-1150(ra) # 4f8 <sbrk>
  if(p == (char*)-1)
 97e:	fd5518e3          	bne	a0,s5,94e <malloc+0xae>
        return 0;
 982:	4501                	li	a0,0
 984:	bf45                	j	934 <malloc+0x94>
