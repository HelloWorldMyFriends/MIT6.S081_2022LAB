
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	324080e7          	jalr	804(ra) # 334 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2f8080e7          	jalr	760(ra) # 334 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2d6080e7          	jalr	726(ra) # 334 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.0>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	430080e7          	jalr	1072(ra) # 4a6 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2b4080e7          	jalr	692(ra) # 334 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2a6080e7          	jalr	678(ra) # 334 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2b6080e7          	jalr	694(ra) # 35e <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4d4080e7          	jalr	1236(ra) # 5ae <open>
  e2:	06054f63          	bltz	a0,160 <ls+0xac>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4da080e7          	jalr	1242(ra) # 5c6 <fstat>
  f4:	08054163          	bltz	a0,176 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	4705                	li	a4,1
  fe:	08e78c63          	beq	a5,a4,196 <ls+0xe2>
 102:	37f9                	addiw	a5,a5,-2
 104:	17c2                	slli	a5,a5,0x30
 106:	93c1                	srli	a5,a5,0x30
 108:	02f76663          	bltu	a4,a5,134 <ls+0x80>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <fmtname>
 116:	85aa                	mv	a1,a0
 118:	da843703          	ld	a4,-600(s0)
 11c:	d9c42683          	lw	a3,-612(s0)
 120:	da041603          	lh	a2,-608(s0)
 124:	00001517          	auipc	a0,0x1
 128:	99c50513          	addi	a0,a0,-1636 # ac0 <malloc+0x122>
 12c:	00000097          	auipc	ra,0x0
 130:	7ba080e7          	jalr	1978(ra) # 8e6 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 134:	8526                	mv	a0,s1
 136:	00000097          	auipc	ra,0x0
 13a:	460080e7          	jalr	1120(ra) # 596 <close>
}
 13e:	26813083          	ld	ra,616(sp)
 142:	26013403          	ld	s0,608(sp)
 146:	25813483          	ld	s1,600(sp)
 14a:	25013903          	ld	s2,592(sp)
 14e:	24813983          	ld	s3,584(sp)
 152:	24013a03          	ld	s4,576(sp)
 156:	23813a83          	ld	s5,568(sp)
 15a:	27010113          	addi	sp,sp,624
 15e:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 160:	864a                	mv	a2,s2
 162:	00001597          	auipc	a1,0x1
 166:	92e58593          	addi	a1,a1,-1746 # a90 <malloc+0xf2>
 16a:	4509                	li	a0,2
 16c:	00000097          	auipc	ra,0x0
 170:	74c080e7          	jalr	1868(ra) # 8b8 <fprintf>
    return;
 174:	b7e9                	j	13e <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 176:	864a                	mv	a2,s2
 178:	00001597          	auipc	a1,0x1
 17c:	93058593          	addi	a1,a1,-1744 # aa8 <malloc+0x10a>
 180:	4509                	li	a0,2
 182:	00000097          	auipc	ra,0x0
 186:	736080e7          	jalr	1846(ra) # 8b8 <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	00000097          	auipc	ra,0x0
 190:	40a080e7          	jalr	1034(ra) # 596 <close>
    return;
 194:	b76d                	j	13e <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 196:	854a                	mv	a0,s2
 198:	00000097          	auipc	ra,0x0
 19c:	19c080e7          	jalr	412(ra) # 334 <strlen>
 1a0:	2541                	addiw	a0,a0,16
 1a2:	20000793          	li	a5,512
 1a6:	00a7fb63          	bgeu	a5,a0,1bc <ls+0x108>
      printf("ls: path too long\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	92650513          	addi	a0,a0,-1754 # ad0 <malloc+0x132>
 1b2:	00000097          	auipc	ra,0x0
 1b6:	734080e7          	jalr	1844(ra) # 8e6 <printf>
      break;
 1ba:	bfad                	j	134 <ls+0x80>
    strcpy(buf, path);
 1bc:	85ca                	mv	a1,s2
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	12a080e7          	jalr	298(ra) # 2ec <strcpy>
    p = buf+strlen(buf);
 1ca:	dc040513          	addi	a0,s0,-576
 1ce:	00000097          	auipc	ra,0x0
 1d2:	166080e7          	jalr	358(ra) # 334 <strlen>
 1d6:	1502                	slli	a0,a0,0x20
 1d8:	9101                	srli	a0,a0,0x20
 1da:	dc040793          	addi	a5,s0,-576
 1de:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1e2:	00190993          	addi	s3,s2,1
 1e6:	02f00793          	li	a5,47
 1ea:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1ee:	00001a17          	auipc	s4,0x1
 1f2:	8faa0a13          	addi	s4,s4,-1798 # ae8 <malloc+0x14a>
        printf("ls: cannot stat %s\n", buf);
 1f6:	00001a97          	auipc	s5,0x1
 1fa:	8b2a8a93          	addi	s5,s5,-1870 # aa8 <malloc+0x10a>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fe:	a801                	j	20e <ls+0x15a>
        printf("ls: cannot stat %s\n", buf);
 200:	dc040593          	addi	a1,s0,-576
 204:	8556                	mv	a0,s5
 206:	00000097          	auipc	ra,0x0
 20a:	6e0080e7          	jalr	1760(ra) # 8e6 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 20e:	4641                	li	a2,16
 210:	db040593          	addi	a1,s0,-592
 214:	8526                	mv	a0,s1
 216:	00000097          	auipc	ra,0x0
 21a:	370080e7          	jalr	880(ra) # 586 <read>
 21e:	47c1                	li	a5,16
 220:	f0f51ae3          	bne	a0,a5,134 <ls+0x80>
      if(de.inum == 0)
 224:	db045783          	lhu	a5,-592(s0)
 228:	d3fd                	beqz	a5,20e <ls+0x15a>
      memmove(p, de.name, DIRSIZ);
 22a:	4639                	li	a2,14
 22c:	db240593          	addi	a1,s0,-590
 230:	854e                	mv	a0,s3
 232:	00000097          	auipc	ra,0x0
 236:	274080e7          	jalr	628(ra) # 4a6 <memmove>
      p[DIRSIZ] = 0;
 23a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 23e:	d9840593          	addi	a1,s0,-616
 242:	dc040513          	addi	a0,s0,-576
 246:	00000097          	auipc	ra,0x0
 24a:	1d2080e7          	jalr	466(ra) # 418 <stat>
 24e:	fa0549e3          	bltz	a0,200 <ls+0x14c>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 252:	dc040513          	addi	a0,s0,-576
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <fmtname>
 25e:	85aa                	mv	a1,a0
 260:	da843703          	ld	a4,-600(s0)
 264:	d9c42683          	lw	a3,-612(s0)
 268:	da041603          	lh	a2,-608(s0)
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	678080e7          	jalr	1656(ra) # 8e6 <printf>
 276:	bf61                	j	20e <ls+0x15a>

0000000000000278 <main>:

int
main(int argc, char *argv[])
{
 278:	1101                	addi	sp,sp,-32
 27a:	ec06                	sd	ra,24(sp)
 27c:	e822                	sd	s0,16(sp)
 27e:	e426                	sd	s1,8(sp)
 280:	e04a                	sd	s2,0(sp)
 282:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 284:	4785                	li	a5,1
 286:	02a7d963          	bge	a5,a0,2b8 <main+0x40>
 28a:	00858493          	addi	s1,a1,8
 28e:	ffe5091b          	addiw	s2,a0,-2
 292:	02091793          	slli	a5,s2,0x20
 296:	01d7d913          	srli	s2,a5,0x1d
 29a:	05c1                	addi	a1,a1,16
 29c:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 29e:	6088                	ld	a0,0(s1)
 2a0:	00000097          	auipc	ra,0x0
 2a4:	e14080e7          	jalr	-492(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2a8:	04a1                	addi	s1,s1,8
 2aa:	ff249ae3          	bne	s1,s2,29e <main+0x26>
  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	00000097          	auipc	ra,0x0
 2b4:	2be080e7          	jalr	702(ra) # 56e <exit>
    ls(".");
 2b8:	00001517          	auipc	a0,0x1
 2bc:	84050513          	addi	a0,a0,-1984 # af8 <malloc+0x15a>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	df4080e7          	jalr	-524(ra) # b4 <ls>
    exit(0);
 2c8:	4501                	li	a0,0
 2ca:	00000097          	auipc	ra,0x0
 2ce:	2a4080e7          	jalr	676(ra) # 56e <exit>

00000000000002d2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2da:	00000097          	auipc	ra,0x0
 2de:	f9e080e7          	jalr	-98(ra) # 278 <main>
  exit(0);
 2e2:	4501                	li	a0,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	28a080e7          	jalr	650(ra) # 56e <exit>

00000000000002ec <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f2:	87aa                	mv	a5,a0
 2f4:	0585                	addi	a1,a1,1
 2f6:	0785                	addi	a5,a5,1
 2f8:	fff5c703          	lbu	a4,-1(a1)
 2fc:	fee78fa3          	sb	a4,-1(a5)
 300:	fb75                	bnez	a4,2f4 <strcpy+0x8>
    ;
  return os;
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb91                	beqz	a5,326 <strcmp+0x1e>
 314:	0005c703          	lbu	a4,0(a1)
 318:	00f71763          	bne	a4,a5,326 <strcmp+0x1e>
    p++, q++;
 31c:	0505                	addi	a0,a0,1
 31e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	fbe5                	bnez	a5,314 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 326:	0005c503          	lbu	a0,0(a1)
}
 32a:	40a7853b          	subw	a0,a5,a0
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret

0000000000000334 <strlen>:

uint
strlen(const char *s)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33a:	00054783          	lbu	a5,0(a0)
 33e:	cf91                	beqz	a5,35a <strlen+0x26>
 340:	0505                	addi	a0,a0,1
 342:	87aa                	mv	a5,a0
 344:	86be                	mv	a3,a5
 346:	0785                	addi	a5,a5,1
 348:	fff7c703          	lbu	a4,-1(a5)
 34c:	ff65                	bnez	a4,344 <strlen+0x10>
 34e:	40a6853b          	subw	a0,a3,a0
 352:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  for(n = 0; s[n]; n++)
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <strlen+0x20>

000000000000035e <memset>:

void*
memset(void *dst, int c, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 364:	ca19                	beqz	a2,37a <memset+0x1c>
 366:	87aa                	mv	a5,a0
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 370:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 374:	0785                	addi	a5,a5,1
 376:	fee79de3          	bne	a5,a4,370 <memset+0x12>
  }
  return dst;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  for(; *s; s++)
 386:	00054783          	lbu	a5,0(a0)
 38a:	cb99                	beqz	a5,3a0 <strchr+0x20>
    if(*s == c)
 38c:	00f58763          	beq	a1,a5,39a <strchr+0x1a>
  for(; *s; s++)
 390:	0505                	addi	a0,a0,1
 392:	00054783          	lbu	a5,0(a0)
 396:	fbfd                	bnez	a5,38c <strchr+0xc>
      return (char*)s;
  return 0;
 398:	4501                	li	a0,0
}
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret
  return 0;
 3a0:	4501                	li	a0,0
 3a2:	bfe5                	j	39a <strchr+0x1a>

00000000000003a4 <gets>:

char*
gets(char *buf, int max)
{
 3a4:	711d                	addi	sp,sp,-96
 3a6:	ec86                	sd	ra,88(sp)
 3a8:	e8a2                	sd	s0,80(sp)
 3aa:	e4a6                	sd	s1,72(sp)
 3ac:	e0ca                	sd	s2,64(sp)
 3ae:	fc4e                	sd	s3,56(sp)
 3b0:	f852                	sd	s4,48(sp)
 3b2:	f456                	sd	s5,40(sp)
 3b4:	f05a                	sd	s6,32(sp)
 3b6:	ec5e                	sd	s7,24(sp)
 3b8:	1080                	addi	s0,sp,96
 3ba:	8baa                	mv	s7,a0
 3bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3be:	892a                	mv	s2,a0
 3c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c2:	4aa9                	li	s5,10
 3c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3c6:	89a6                	mv	s3,s1
 3c8:	2485                	addiw	s1,s1,1
 3ca:	0344d863          	bge	s1,s4,3fa <gets+0x56>
    cc = read(0, &c, 1);
 3ce:	4605                	li	a2,1
 3d0:	faf40593          	addi	a1,s0,-81
 3d4:	4501                	li	a0,0
 3d6:	00000097          	auipc	ra,0x0
 3da:	1b0080e7          	jalr	432(ra) # 586 <read>
    if(cc < 1)
 3de:	00a05e63          	blez	a0,3fa <gets+0x56>
    buf[i++] = c;
 3e2:	faf44783          	lbu	a5,-81(s0)
 3e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ea:	01578763          	beq	a5,s5,3f8 <gets+0x54>
 3ee:	0905                	addi	s2,s2,1
 3f0:	fd679be3          	bne	a5,s6,3c6 <gets+0x22>
  for(i=0; i+1 < max; ){
 3f4:	89a6                	mv	s3,s1
 3f6:	a011                	j	3fa <gets+0x56>
 3f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3fa:	99de                	add	s3,s3,s7
 3fc:	00098023          	sb	zero,0(s3)
  return buf;
}
 400:	855e                	mv	a0,s7
 402:	60e6                	ld	ra,88(sp)
 404:	6446                	ld	s0,80(sp)
 406:	64a6                	ld	s1,72(sp)
 408:	6906                	ld	s2,64(sp)
 40a:	79e2                	ld	s3,56(sp)
 40c:	7a42                	ld	s4,48(sp)
 40e:	7aa2                	ld	s5,40(sp)
 410:	7b02                	ld	s6,32(sp)
 412:	6be2                	ld	s7,24(sp)
 414:	6125                	addi	sp,sp,96
 416:	8082                	ret

0000000000000418 <stat>:

int
stat(const char *n, struct stat *st)
{
 418:	1101                	addi	sp,sp,-32
 41a:	ec06                	sd	ra,24(sp)
 41c:	e822                	sd	s0,16(sp)
 41e:	e426                	sd	s1,8(sp)
 420:	e04a                	sd	s2,0(sp)
 422:	1000                	addi	s0,sp,32
 424:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 426:	4581                	li	a1,0
 428:	00000097          	auipc	ra,0x0
 42c:	186080e7          	jalr	390(ra) # 5ae <open>
  if(fd < 0)
 430:	02054563          	bltz	a0,45a <stat+0x42>
 434:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 436:	85ca                	mv	a1,s2
 438:	00000097          	auipc	ra,0x0
 43c:	18e080e7          	jalr	398(ra) # 5c6 <fstat>
 440:	892a                	mv	s2,a0
  close(fd);
 442:	8526                	mv	a0,s1
 444:	00000097          	auipc	ra,0x0
 448:	152080e7          	jalr	338(ra) # 596 <close>
  return r;
}
 44c:	854a                	mv	a0,s2
 44e:	60e2                	ld	ra,24(sp)
 450:	6442                	ld	s0,16(sp)
 452:	64a2                	ld	s1,8(sp)
 454:	6902                	ld	s2,0(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret
    return -1;
 45a:	597d                	li	s2,-1
 45c:	bfc5                	j	44c <stat+0x34>

000000000000045e <atoi>:

int
atoi(const char *s)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 464:	00054683          	lbu	a3,0(a0)
 468:	fd06879b          	addiw	a5,a3,-48
 46c:	0ff7f793          	zext.b	a5,a5
 470:	4625                	li	a2,9
 472:	02f66863          	bltu	a2,a5,4a2 <atoi+0x44>
 476:	872a                	mv	a4,a0
  n = 0;
 478:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 47a:	0705                	addi	a4,a4,1
 47c:	0025179b          	slliw	a5,a0,0x2
 480:	9fa9                	addw	a5,a5,a0
 482:	0017979b          	slliw	a5,a5,0x1
 486:	9fb5                	addw	a5,a5,a3
 488:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 48c:	00074683          	lbu	a3,0(a4)
 490:	fd06879b          	addiw	a5,a3,-48
 494:	0ff7f793          	zext.b	a5,a5
 498:	fef671e3          	bgeu	a2,a5,47a <atoi+0x1c>
  return n;
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
  n = 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <atoi+0x3e>

00000000000004a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ac:	02b57463          	bgeu	a0,a1,4d4 <memmove+0x2e>
    while(n-- > 0)
 4b0:	00c05f63          	blez	a2,4ce <memmove+0x28>
 4b4:	1602                	slli	a2,a2,0x20
 4b6:	9201                	srli	a2,a2,0x20
 4b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4be:	0585                	addi	a1,a1,1
 4c0:	0705                	addi	a4,a4,1
 4c2:	fff5c683          	lbu	a3,-1(a1)
 4c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ca:	fee79ae3          	bne	a5,a4,4be <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ce:	6422                	ld	s0,8(sp)
 4d0:	0141                	addi	sp,sp,16
 4d2:	8082                	ret
    dst += n;
 4d4:	00c50733          	add	a4,a0,a2
    src += n;
 4d8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4da:	fec05ae3          	blez	a2,4ce <memmove+0x28>
 4de:	fff6079b          	addiw	a5,a2,-1
 4e2:	1782                	slli	a5,a5,0x20
 4e4:	9381                	srli	a5,a5,0x20
 4e6:	fff7c793          	not	a5,a5
 4ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4ec:	15fd                	addi	a1,a1,-1
 4ee:	177d                	addi	a4,a4,-1
 4f0:	0005c683          	lbu	a3,0(a1)
 4f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4f8:	fee79ae3          	bne	a5,a4,4ec <memmove+0x46>
 4fc:	bfc9                	j	4ce <memmove+0x28>

00000000000004fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 504:	ca05                	beqz	a2,534 <memcmp+0x36>
 506:	fff6069b          	addiw	a3,a2,-1
 50a:	1682                	slli	a3,a3,0x20
 50c:	9281                	srli	a3,a3,0x20
 50e:	0685                	addi	a3,a3,1
 510:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 512:	00054783          	lbu	a5,0(a0)
 516:	0005c703          	lbu	a4,0(a1)
 51a:	00e79863          	bne	a5,a4,52a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 51e:	0505                	addi	a0,a0,1
    p2++;
 520:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 522:	fed518e3          	bne	a0,a3,512 <memcmp+0x14>
  }
  return 0;
 526:	4501                	li	a0,0
 528:	a019                	j	52e <memcmp+0x30>
      return *p1 - *p2;
 52a:	40e7853b          	subw	a0,a5,a4
}
 52e:	6422                	ld	s0,8(sp)
 530:	0141                	addi	sp,sp,16
 532:	8082                	ret
  return 0;
 534:	4501                	li	a0,0
 536:	bfe5                	j	52e <memcmp+0x30>

0000000000000538 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 538:	1141                	addi	sp,sp,-16
 53a:	e406                	sd	ra,8(sp)
 53c:	e022                	sd	s0,0(sp)
 53e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 540:	00000097          	auipc	ra,0x0
 544:	f66080e7          	jalr	-154(ra) # 4a6 <memmove>
}
 548:	60a2                	ld	ra,8(sp)
 54a:	6402                	ld	s0,0(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret

0000000000000550 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 550:	1141                	addi	sp,sp,-16
 552:	e422                	sd	s0,8(sp)
 554:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 556:	040007b7          	lui	a5,0x4000
}
 55a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffefdd>
 55c:	07b2                	slli	a5,a5,0xc
 55e:	4388                	lw	a0,0(a5)
 560:	6422                	ld	s0,8(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret

0000000000000566 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 566:	4885                	li	a7,1
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <exit>:
.global exit
exit:
 li a7, SYS_exit
 56e:	4889                	li	a7,2
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <wait>:
.global wait
wait:
 li a7, SYS_wait
 576:	488d                	li	a7,3
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57e:	4891                	li	a7,4
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <read>:
.global read
read:
 li a7, SYS_read
 586:	4895                	li	a7,5
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <write>:
.global write
write:
 li a7, SYS_write
 58e:	48c1                	li	a7,16
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <close>:
.global close
close:
 li a7, SYS_close
 596:	48d5                	li	a7,21
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <kill>:
.global kill
kill:
 li a7, SYS_kill
 59e:	4899                	li	a7,6
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a6:	489d                	li	a7,7
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <open>:
.global open
open:
 li a7, SYS_open
 5ae:	48bd                	li	a7,15
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b6:	48c5                	li	a7,17
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5be:	48c9                	li	a7,18
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c6:	48a1                	li	a7,8
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <link>:
.global link
link:
 li a7, SYS_link
 5ce:	48cd                	li	a7,19
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d6:	48d1                	li	a7,20
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5de:	48a5                	li	a7,9
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e6:	48a9                	li	a7,10
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ee:	48ad                	li	a7,11
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f6:	48b1                	li	a7,12
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fe:	48b5                	li	a7,13
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 606:	48b9                	li	a7,14
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <connect>:
.global connect
connect:
 li a7, SYS_connect
 60e:	48f5                	li	a7,29
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 616:	48f9                	li	a7,30
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 61e:	1101                	addi	sp,sp,-32
 620:	ec06                	sd	ra,24(sp)
 622:	e822                	sd	s0,16(sp)
 624:	1000                	addi	s0,sp,32
 626:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62a:	4605                	li	a2,1
 62c:	fef40593          	addi	a1,s0,-17
 630:	00000097          	auipc	ra,0x0
 634:	f5e080e7          	jalr	-162(ra) # 58e <write>
}
 638:	60e2                	ld	ra,24(sp)
 63a:	6442                	ld	s0,16(sp)
 63c:	6105                	addi	sp,sp,32
 63e:	8082                	ret

0000000000000640 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 640:	7139                	addi	sp,sp,-64
 642:	fc06                	sd	ra,56(sp)
 644:	f822                	sd	s0,48(sp)
 646:	f426                	sd	s1,40(sp)
 648:	f04a                	sd	s2,32(sp)
 64a:	ec4e                	sd	s3,24(sp)
 64c:	0080                	addi	s0,sp,64
 64e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 650:	c299                	beqz	a3,656 <printint+0x16>
 652:	0805c963          	bltz	a1,6e4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 656:	2581                	sext.w	a1,a1
  neg = 0;
 658:	4881                	li	a7,0
 65a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 65e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 660:	2601                	sext.w	a2,a2
 662:	00000517          	auipc	a0,0x0
 666:	4fe50513          	addi	a0,a0,1278 # b60 <digits>
 66a:	883a                	mv	a6,a4
 66c:	2705                	addiw	a4,a4,1
 66e:	02c5f7bb          	remuw	a5,a1,a2
 672:	1782                	slli	a5,a5,0x20
 674:	9381                	srli	a5,a5,0x20
 676:	97aa                	add	a5,a5,a0
 678:	0007c783          	lbu	a5,0(a5)
 67c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 680:	0005879b          	sext.w	a5,a1
 684:	02c5d5bb          	divuw	a1,a1,a2
 688:	0685                	addi	a3,a3,1
 68a:	fec7f0e3          	bgeu	a5,a2,66a <printint+0x2a>
  if(neg)
 68e:	00088c63          	beqz	a7,6a6 <printint+0x66>
    buf[i++] = '-';
 692:	fd070793          	addi	a5,a4,-48
 696:	00878733          	add	a4,a5,s0
 69a:	02d00793          	li	a5,45
 69e:	fef70823          	sb	a5,-16(a4)
 6a2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a6:	02e05863          	blez	a4,6d6 <printint+0x96>
 6aa:	fc040793          	addi	a5,s0,-64
 6ae:	00e78933          	add	s2,a5,a4
 6b2:	fff78993          	addi	s3,a5,-1
 6b6:	99ba                	add	s3,s3,a4
 6b8:	377d                	addiw	a4,a4,-1
 6ba:	1702                	slli	a4,a4,0x20
 6bc:	9301                	srli	a4,a4,0x20
 6be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c2:	fff94583          	lbu	a1,-1(s2)
 6c6:	8526                	mv	a0,s1
 6c8:	00000097          	auipc	ra,0x0
 6cc:	f56080e7          	jalr	-170(ra) # 61e <putc>
  while(--i >= 0)
 6d0:	197d                	addi	s2,s2,-1
 6d2:	ff3918e3          	bne	s2,s3,6c2 <printint+0x82>
}
 6d6:	70e2                	ld	ra,56(sp)
 6d8:	7442                	ld	s0,48(sp)
 6da:	74a2                	ld	s1,40(sp)
 6dc:	7902                	ld	s2,32(sp)
 6de:	69e2                	ld	s3,24(sp)
 6e0:	6121                	addi	sp,sp,64
 6e2:	8082                	ret
    x = -xx;
 6e4:	40b005bb          	negw	a1,a1
    neg = 1;
 6e8:	4885                	li	a7,1
    x = -xx;
 6ea:	bf85                	j	65a <printint+0x1a>

00000000000006ec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ec:	715d                	addi	sp,sp,-80
 6ee:	e486                	sd	ra,72(sp)
 6f0:	e0a2                	sd	s0,64(sp)
 6f2:	fc26                	sd	s1,56(sp)
 6f4:	f84a                	sd	s2,48(sp)
 6f6:	f44e                	sd	s3,40(sp)
 6f8:	f052                	sd	s4,32(sp)
 6fa:	ec56                	sd	s5,24(sp)
 6fc:	e85a                	sd	s6,16(sp)
 6fe:	e45e                	sd	s7,8(sp)
 700:	e062                	sd	s8,0(sp)
 702:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 704:	0005c903          	lbu	s2,0(a1)
 708:	18090c63          	beqz	s2,8a0 <vprintf+0x1b4>
 70c:	8aaa                	mv	s5,a0
 70e:	8bb2                	mv	s7,a2
 710:	00158493          	addi	s1,a1,1
  state = 0;
 714:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 716:	02500a13          	li	s4,37
 71a:	4b55                	li	s6,21
 71c:	a839                	j	73a <vprintf+0x4e>
        putc(fd, c);
 71e:	85ca                	mv	a1,s2
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	efc080e7          	jalr	-260(ra) # 61e <putc>
 72a:	a019                	j	730 <vprintf+0x44>
    } else if(state == '%'){
 72c:	01498d63          	beq	s3,s4,746 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 730:	0485                	addi	s1,s1,1
 732:	fff4c903          	lbu	s2,-1(s1)
 736:	16090563          	beqz	s2,8a0 <vprintf+0x1b4>
    if(state == 0){
 73a:	fe0999e3          	bnez	s3,72c <vprintf+0x40>
      if(c == '%'){
 73e:	ff4910e3          	bne	s2,s4,71e <vprintf+0x32>
        state = '%';
 742:	89d2                	mv	s3,s4
 744:	b7f5                	j	730 <vprintf+0x44>
      if(c == 'd'){
 746:	13490263          	beq	s2,s4,86a <vprintf+0x17e>
 74a:	f9d9079b          	addiw	a5,s2,-99
 74e:	0ff7f793          	zext.b	a5,a5
 752:	12fb6563          	bltu	s6,a5,87c <vprintf+0x190>
 756:	f9d9079b          	addiw	a5,s2,-99
 75a:	0ff7f713          	zext.b	a4,a5
 75e:	10eb6f63          	bltu	s6,a4,87c <vprintf+0x190>
 762:	00271793          	slli	a5,a4,0x2
 766:	00000717          	auipc	a4,0x0
 76a:	3a270713          	addi	a4,a4,930 # b08 <malloc+0x16a>
 76e:	97ba                	add	a5,a5,a4
 770:	439c                	lw	a5,0(a5)
 772:	97ba                	add	a5,a5,a4
 774:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 776:	008b8913          	addi	s2,s7,8
 77a:	4685                	li	a3,1
 77c:	4629                	li	a2,10
 77e:	000ba583          	lw	a1,0(s7)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	ebc080e7          	jalr	-324(ra) # 640 <printint>
 78c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 78e:	4981                	li	s3,0
 790:	b745                	j	730 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8913          	addi	s2,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	ea0080e7          	jalr	-352(ra) # 640 <printint>
 7a8:	8bca                	mv	s7,s2
      state = 0;
 7aa:	4981                	li	s3,0
 7ac:	b751                	j	730 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	4681                	li	a3,0
 7b4:	4641                	li	a2,16
 7b6:	000ba583          	lw	a1,0(s7)
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	e84080e7          	jalr	-380(ra) # 640 <printint>
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b7a5                	j	730 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 7ca:	008b8c13          	addi	s8,s7,8
 7ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d2:	03000593          	li	a1,48
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	e46080e7          	jalr	-442(ra) # 61e <putc>
  putc(fd, 'x');
 7e0:	07800593          	li	a1,120
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e38080e7          	jalr	-456(ra) # 61e <putc>
 7ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7f0:	00000b97          	auipc	s7,0x0
 7f4:	370b8b93          	addi	s7,s7,880 # b60 <digits>
 7f8:	03c9d793          	srli	a5,s3,0x3c
 7fc:	97de                	add	a5,a5,s7
 7fe:	0007c583          	lbu	a1,0(a5)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e1a080e7          	jalr	-486(ra) # 61e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 80c:	0992                	slli	s3,s3,0x4
 80e:	397d                	addiw	s2,s2,-1
 810:	fe0914e3          	bnez	s2,7f8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 814:	8be2                	mv	s7,s8
      state = 0;
 816:	4981                	li	s3,0
 818:	bf21                	j	730 <vprintf+0x44>
        s = va_arg(ap, char*);
 81a:	008b8993          	addi	s3,s7,8
 81e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 822:	02090163          	beqz	s2,844 <vprintf+0x158>
        while(*s != 0){
 826:	00094583          	lbu	a1,0(s2)
 82a:	c9a5                	beqz	a1,89a <vprintf+0x1ae>
          putc(fd, *s);
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	df0080e7          	jalr	-528(ra) # 61e <putc>
          s++;
 836:	0905                	addi	s2,s2,1
        while(*s != 0){
 838:	00094583          	lbu	a1,0(s2)
 83c:	f9e5                	bnez	a1,82c <vprintf+0x140>
        s = va_arg(ap, char*);
 83e:	8bce                	mv	s7,s3
      state = 0;
 840:	4981                	li	s3,0
 842:	b5fd                	j	730 <vprintf+0x44>
          s = "(null)";
 844:	00000917          	auipc	s2,0x0
 848:	2bc90913          	addi	s2,s2,700 # b00 <malloc+0x162>
        while(*s != 0){
 84c:	02800593          	li	a1,40
 850:	bff1                	j	82c <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 852:	008b8913          	addi	s2,s7,8
 856:	000bc583          	lbu	a1,0(s7)
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	dc2080e7          	jalr	-574(ra) # 61e <putc>
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
 868:	b5e1                	j	730 <vprintf+0x44>
        putc(fd, c);
 86a:	02500593          	li	a1,37
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	dae080e7          	jalr	-594(ra) # 61e <putc>
      state = 0;
 878:	4981                	li	s3,0
 87a:	bd5d                	j	730 <vprintf+0x44>
        putc(fd, '%');
 87c:	02500593          	li	a1,37
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	d9c080e7          	jalr	-612(ra) # 61e <putc>
        putc(fd, c);
 88a:	85ca                	mv	a1,s2
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	d90080e7          	jalr	-624(ra) # 61e <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	bd61                	j	730 <vprintf+0x44>
        s = va_arg(ap, char*);
 89a:	8bce                	mv	s7,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bd49                	j	730 <vprintf+0x44>
    }
  }
}
 8a0:	60a6                	ld	ra,72(sp)
 8a2:	6406                	ld	s0,64(sp)
 8a4:	74e2                	ld	s1,56(sp)
 8a6:	7942                	ld	s2,48(sp)
 8a8:	79a2                	ld	s3,40(sp)
 8aa:	7a02                	ld	s4,32(sp)
 8ac:	6ae2                	ld	s5,24(sp)
 8ae:	6b42                	ld	s6,16(sp)
 8b0:	6ba2                	ld	s7,8(sp)
 8b2:	6c02                	ld	s8,0(sp)
 8b4:	6161                	addi	sp,sp,80
 8b6:	8082                	ret

00000000000008b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b8:	715d                	addi	sp,sp,-80
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	e010                	sd	a2,0(s0)
 8c2:	e414                	sd	a3,8(s0)
 8c4:	e818                	sd	a4,16(s0)
 8c6:	ec1c                	sd	a5,24(s0)
 8c8:	03043023          	sd	a6,32(s0)
 8cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d4:	8622                	mv	a2,s0
 8d6:	00000097          	auipc	ra,0x0
 8da:	e16080e7          	jalr	-490(ra) # 6ec <vprintf>
}
 8de:	60e2                	ld	ra,24(sp)
 8e0:	6442                	ld	s0,16(sp)
 8e2:	6161                	addi	sp,sp,80
 8e4:	8082                	ret

00000000000008e6 <printf>:

void
printf(const char *fmt, ...)
{
 8e6:	711d                	addi	sp,sp,-96
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e40c                	sd	a1,8(s0)
 8f0:	e810                	sd	a2,16(s0)
 8f2:	ec14                	sd	a3,24(s0)
 8f4:	f018                	sd	a4,32(s0)
 8f6:	f41c                	sd	a5,40(s0)
 8f8:	03043823          	sd	a6,48(s0)
 8fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 900:	00840613          	addi	a2,s0,8
 904:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 908:	85aa                	mv	a1,a0
 90a:	4505                	li	a0,1
 90c:	00000097          	auipc	ra,0x0
 910:	de0080e7          	jalr	-544(ra) # 6ec <vprintf>
}
 914:	60e2                	ld	ra,24(sp)
 916:	6442                	ld	s0,16(sp)
 918:	6125                	addi	sp,sp,96
 91a:	8082                	ret

000000000000091c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91c:	1141                	addi	sp,sp,-16
 91e:	e422                	sd	s0,8(sp)
 920:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 922:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	00000797          	auipc	a5,0x0
 92a:	6da7b783          	ld	a5,1754(a5) # 1000 <freep>
 92e:	a02d                	j	958 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 930:	4618                	lw	a4,8(a2)
 932:	9f2d                	addw	a4,a4,a1
 934:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	6398                	ld	a4,0(a5)
 93a:	6310                	ld	a2,0(a4)
 93c:	a83d                	j	97a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 93e:	ff852703          	lw	a4,-8(a0)
 942:	9f31                	addw	a4,a4,a2
 944:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 946:	ff053683          	ld	a3,-16(a0)
 94a:	a091                	j	98e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94c:	6398                	ld	a4,0(a5)
 94e:	00e7e463          	bltu	a5,a4,956 <free+0x3a>
 952:	00e6ea63          	bltu	a3,a4,966 <free+0x4a>
{
 956:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 958:	fed7fae3          	bgeu	a5,a3,94c <free+0x30>
 95c:	6398                	ld	a4,0(a5)
 95e:	00e6e463          	bltu	a3,a4,966 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 962:	fee7eae3          	bltu	a5,a4,956 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 966:	ff852583          	lw	a1,-8(a0)
 96a:	6390                	ld	a2,0(a5)
 96c:	02059813          	slli	a6,a1,0x20
 970:	01c85713          	srli	a4,a6,0x1c
 974:	9736                	add	a4,a4,a3
 976:	fae60de3          	beq	a2,a4,930 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 97e:	4790                	lw	a2,8(a5)
 980:	02061593          	slli	a1,a2,0x20
 984:	01c5d713          	srli	a4,a1,0x1c
 988:	973e                	add	a4,a4,a5
 98a:	fae68ae3          	beq	a3,a4,93e <free+0x22>
    p->s.ptr = bp->s.ptr;
 98e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 990:	00000717          	auipc	a4,0x0
 994:	66f73823          	sd	a5,1648(a4) # 1000 <freep>
}
 998:	6422                	ld	s0,8(sp)
 99a:	0141                	addi	sp,sp,16
 99c:	8082                	ret

000000000000099e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 99e:	7139                	addi	sp,sp,-64
 9a0:	fc06                	sd	ra,56(sp)
 9a2:	f822                	sd	s0,48(sp)
 9a4:	f426                	sd	s1,40(sp)
 9a6:	f04a                	sd	s2,32(sp)
 9a8:	ec4e                	sd	s3,24(sp)
 9aa:	e852                	sd	s4,16(sp)
 9ac:	e456                	sd	s5,8(sp)
 9ae:	e05a                	sd	s6,0(sp)
 9b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b2:	02051493          	slli	s1,a0,0x20
 9b6:	9081                	srli	s1,s1,0x20
 9b8:	04bd                	addi	s1,s1,15
 9ba:	8091                	srli	s1,s1,0x4
 9bc:	0014899b          	addiw	s3,s1,1
 9c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9c2:	00000517          	auipc	a0,0x0
 9c6:	63e53503          	ld	a0,1598(a0) # 1000 <freep>
 9ca:	c515                	beqz	a0,9f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ce:	4798                	lw	a4,8(a5)
 9d0:	02977f63          	bgeu	a4,s1,a0e <malloc+0x70>
  if(nu < 4096)
 9d4:	8a4e                	mv	s4,s3
 9d6:	0009871b          	sext.w	a4,s3
 9da:	6685                	lui	a3,0x1
 9dc:	00d77363          	bgeu	a4,a3,9e2 <malloc+0x44>
 9e0:	6a05                	lui	s4,0x1
 9e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9ea:	00000917          	auipc	s2,0x0
 9ee:	61690913          	addi	s2,s2,1558 # 1000 <freep>
  if(p == (char*)-1)
 9f2:	5afd                	li	s5,-1
 9f4:	a895                	j	a68 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9f6:	00000797          	auipc	a5,0x0
 9fa:	62a78793          	addi	a5,a5,1578 # 1020 <base>
 9fe:	00000717          	auipc	a4,0x0
 a02:	60f73123          	sd	a5,1538(a4) # 1000 <freep>
 a06:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a08:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0c:	b7e1                	j	9d4 <malloc+0x36>
      if(p->s.size == nunits)
 a0e:	02e48c63          	beq	s1,a4,a46 <malloc+0xa8>
        p->s.size -= nunits;
 a12:	4137073b          	subw	a4,a4,s3
 a16:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a18:	02071693          	slli	a3,a4,0x20
 a1c:	01c6d713          	srli	a4,a3,0x1c
 a20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a26:	00000717          	auipc	a4,0x0
 a2a:	5ca73d23          	sd	a0,1498(a4) # 1000 <freep>
      return (void*)(p + 1);
 a2e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a32:	70e2                	ld	ra,56(sp)
 a34:	7442                	ld	s0,48(sp)
 a36:	74a2                	ld	s1,40(sp)
 a38:	7902                	ld	s2,32(sp)
 a3a:	69e2                	ld	s3,24(sp)
 a3c:	6a42                	ld	s4,16(sp)
 a3e:	6aa2                	ld	s5,8(sp)
 a40:	6b02                	ld	s6,0(sp)
 a42:	6121                	addi	sp,sp,64
 a44:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a46:	6398                	ld	a4,0(a5)
 a48:	e118                	sd	a4,0(a0)
 a4a:	bff1                	j	a26 <malloc+0x88>
  hp->s.size = nu;
 a4c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a50:	0541                	addi	a0,a0,16
 a52:	00000097          	auipc	ra,0x0
 a56:	eca080e7          	jalr	-310(ra) # 91c <free>
  return freep;
 a5a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a5e:	d971                	beqz	a0,a32 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a62:	4798                	lw	a4,8(a5)
 a64:	fa9775e3          	bgeu	a4,s1,a0e <malloc+0x70>
    if(p == freep)
 a68:	00093703          	ld	a4,0(s2)
 a6c:	853e                	mv	a0,a5
 a6e:	fef719e3          	bne	a4,a5,a60 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a72:	8552                	mv	a0,s4
 a74:	00000097          	auipc	ra,0x0
 a78:	b82080e7          	jalr	-1150(ra) # 5f6 <sbrk>
  if(p == (char*)-1)
 a7c:	fd5518e3          	bne	a0,s5,a4c <malloc+0xae>
        return 0;
 a80:	4501                	li	a0,0
 a82:	bf45                	j	a32 <malloc+0x94>
