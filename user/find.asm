
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"


char *fmtname(char* path){  /*return path's filename after secondly last slush/*/
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];
    char *p;
    /*
        Find first character after last slash.    
    */
    for(p = path + strlen(path); p >= path && *p != '/'; p--){
  10:	00000097          	auipc	ra,0x0
  14:	2d6080e7          	jalr	726(ra) # 2e6 <strlen>
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
    }
    p++;
  36:	00178493          	addi	s1,a5,1
    if(strlen(p) >= DIRSIZ){
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	2aa080e7          	jalr	682(ra) # 2e6 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
        return p;
    }
    memmove(buf, p, DIRSIZ);
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
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
    memmove(buf, p, DIRSIZ);
  5c:	00001997          	auipc	s3,0x1
  60:	fb498993          	addi	s3,s3,-76 # 1010 <buf.0>
  64:	4639                	li	a2,14
  66:	85a6                	mv	a1,s1
  68:	854e                	mv	a0,s3
  6a:	00000097          	auipc	ra,0x0
  6e:	3ee080e7          	jalr	1006(ra) # 458 <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  72:	8526                	mv	a0,s1
  74:	00000097          	auipc	ra,0x0
  78:	272080e7          	jalr	626(ra) # 2e6 <strlen>
  7c:	0005091b          	sext.w	s2,a0
  80:	8526                	mv	a0,s1
  82:	00000097          	auipc	ra,0x0
  86:	264080e7          	jalr	612(ra) # 2e6 <strlen>
  8a:	1902                	slli	s2,s2,0x20
  8c:	02095913          	srli	s2,s2,0x20
  90:	4639                	li	a2,14
  92:	9e09                	subw	a2,a2,a0
  94:	02000593          	li	a1,32
  98:	01298533          	add	a0,s3,s2
  9c:	00000097          	auipc	ra,0x0
  a0:	274080e7          	jalr	628(ra) # 310 <memset>
    return buf;
  a4:	84ce                	mv	s1,s3
  a6:	b75d                	j	4c <fmtname+0x4c>

00000000000000a8 <find>:


void find(char* path, char* filename){
  a8:	d9010113          	addi	sp,sp,-624
  ac:	26113423          	sd	ra,616(sp)
  b0:	26813023          	sd	s0,608(sp)
  b4:	24913c23          	sd	s1,600(sp)
  b8:	25213823          	sd	s2,592(sp)
  bc:	25313423          	sd	s3,584(sp)
  c0:	25413023          	sd	s4,576(sp)
  c4:	23513c23          	sd	s5,568(sp)
  c8:	23613823          	sd	s6,560(sp)
  cc:	1c80                	addi	s0,sp,624
  ce:	892a                	mv	s2,a0
  d0:	89ae                	mv	s3,a1
    char buf[512];
    char *p;
    int fd;
    struct dirent de;   /*directory consists of dirents*/
    struct stat st;
    if((fd = open(path, 0)) < 0){
  d2:	4581                	li	a1,0
  d4:	00000097          	auipc	ra,0x0
  d8:	476080e7          	jalr	1142(ra) # 54a <open>
  dc:	0a054863          	bltz	a0,18c <find+0xe4>
  e0:	84aa                	mv	s1,a0
        fprintf(2, "find:cannot open %s\n", path);
        return;
    }
    
    strcpy(buf, path);
  e2:	85ca                	mv	a1,s2
  e4:	dc040513          	addi	a0,s0,-576
  e8:	00000097          	auipc	ra,0x0
  ec:	1b6080e7          	jalr	438(ra) # 29e <strcpy>
    p = buf + strlen(buf);
  f0:	dc040513          	addi	a0,s0,-576
  f4:	00000097          	auipc	ra,0x0
  f8:	1f2080e7          	jalr	498(ra) # 2e6 <strlen>
  fc:	1502                	slli	a0,a0,0x20
  fe:	9101                	srli	a0,a0,0x20
 100:	dc040793          	addi	a5,s0,-576
 104:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 108:	00190a13          	addi	s4,s2,1
 10c:	02f00793          	li	a5,47
 110:	00f90023          	sb	a5,0(s2)
        // printf("4. %s\n", buf);
        if(stat(buf, &st) < 0){
            printf("find: cannot stat %s\n", buf);
            continue;
        }
        switch(st.type){
 114:	4b05                	li	s6,1
 116:	4a89                	li	s5,2
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 118:	4641                	li	a2,16
 11a:	db040593          	addi	a1,s0,-592
 11e:	8526                	mv	a0,s1
 120:	00000097          	auipc	ra,0x0
 124:	402080e7          	jalr	1026(ra) # 522 <read>
 128:	47c1                	li	a5,16
 12a:	0cf51363          	bne	a0,a5,1f0 <find+0x148>
        if(de.inum == 0)
 12e:	db045783          	lhu	a5,-592(s0)
 132:	d3fd                	beqz	a5,118 <find+0x70>
        memmove(p, de.name, DIRSIZ);
 134:	4639                	li	a2,14
 136:	db240593          	addi	a1,s0,-590
 13a:	8552                	mv	a0,s4
 13c:	00000097          	auipc	ra,0x0
 140:	31c080e7          	jalr	796(ra) # 458 <memmove>
        p[DIRSIZ] = 0;
 144:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0){
 148:	d9840593          	addi	a1,s0,-616
 14c:	dc040513          	addi	a0,s0,-576
 150:	00000097          	auipc	ra,0x0
 154:	27a080e7          	jalr	634(ra) # 3ca <stat>
 158:	04054563          	bltz	a0,1a2 <find+0xfa>
        switch(st.type){
 15c:	da041783          	lh	a5,-608(s0)
 160:	05678c63          	beq	a5,s6,1b8 <find+0x110>
 164:	fb579ae3          	bne	a5,s5,118 <find+0x70>
            case T_FILE:
                // printf("IM FILE %s AND START TO CMP\n", buf);
                if(strcmp(p, filename) == 0){
 168:	85ce                	mv	a1,s3
 16a:	8552                	mv	a0,s4
 16c:	00000097          	auipc	ra,0x0
 170:	14e080e7          	jalr	334(ra) # 2ba <strcmp>
 174:	f155                	bnez	a0,118 <find+0x70>

                    printf("%s\n", buf);
 176:	dc040593          	addi	a1,s0,-576
 17a:	00001517          	auipc	a0,0x1
 17e:	8d650513          	addi	a0,a0,-1834 # a50 <malloc+0x116>
 182:	00000097          	auipc	ra,0x0
 186:	700080e7          	jalr	1792(ra) # 882 <printf>
 18a:	b779                	j	118 <find+0x70>
        fprintf(2, "find:cannot open %s\n", path);
 18c:	864a                	mv	a2,s2
 18e:	00001597          	auipc	a1,0x1
 192:	89258593          	addi	a1,a1,-1902 # a20 <malloc+0xe6>
 196:	4509                	li	a0,2
 198:	00000097          	auipc	ra,0x0
 19c:	6bc080e7          	jalr	1724(ra) # 854 <fprintf>
        return;
 1a0:	a8a9                	j	1fa <find+0x152>
            printf("find: cannot stat %s\n", buf);
 1a2:	dc040593          	addi	a1,s0,-576
 1a6:	00001517          	auipc	a0,0x1
 1aa:	89250513          	addi	a0,a0,-1902 # a38 <malloc+0xfe>
 1ae:	00000097          	auipc	ra,0x0
 1b2:	6d4080e7          	jalr	1748(ra) # 882 <printf>
            continue;
 1b6:	b78d                	j	118 <find+0x70>
                }
                continue;
            case T_DIR: /*avoid recurse between '.' and '..'*/
                
                // printf("%s----------\n", buf);
                if((strcmp(p ,".") != 0) && (strcmp(p ,"..") != 0)){
 1b8:	00001597          	auipc	a1,0x1
 1bc:	8a058593          	addi	a1,a1,-1888 # a58 <malloc+0x11e>
 1c0:	8552                	mv	a0,s4
 1c2:	00000097          	auipc	ra,0x0
 1c6:	0f8080e7          	jalr	248(ra) # 2ba <strcmp>
 1ca:	d539                	beqz	a0,118 <find+0x70>
 1cc:	00001597          	auipc	a1,0x1
 1d0:	89458593          	addi	a1,a1,-1900 # a60 <malloc+0x126>
 1d4:	8552                	mv	a0,s4
 1d6:	00000097          	auipc	ra,0x0
 1da:	0e4080e7          	jalr	228(ra) # 2ba <strcmp>
 1de:	dd0d                	beqz	a0,118 <find+0x70>
                    find(buf, filename);
 1e0:	85ce                	mv	a1,s3
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	00000097          	auipc	ra,0x0
 1ea:	ec2080e7          	jalr	-318(ra) # a8 <find>
 1ee:	b72d                	j	118 <find+0x70>
                }
                continue;
        }
    }
    close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	00000097          	auipc	ra,0x0
 1f6:	340080e7          	jalr	832(ra) # 532 <close>
    return;
} 
 1fa:	26813083          	ld	ra,616(sp)
 1fe:	26013403          	ld	s0,608(sp)
 202:	25813483          	ld	s1,600(sp)
 206:	25013903          	ld	s2,592(sp)
 20a:	24813983          	ld	s3,584(sp)
 20e:	24013a03          	ld	s4,576(sp)
 212:	23813a83          	ld	s5,568(sp)
 216:	23013b03          	ld	s6,560(sp)
 21a:	27010113          	addi	sp,sp,624
 21e:	8082                	ret

0000000000000220 <main>:
    // }
//     close(fd);
//     return;
// }

int main(int argc, char* argv[]){
 220:	7179                	addi	sp,sp,-48
 222:	f406                	sd	ra,40(sp)
 224:	f022                	sd	s0,32(sp)
 226:	ec26                	sd	s1,24(sp)
 228:	e84a                	sd	s2,16(sp)
 22a:	e44e                	sd	s3,8(sp)
 22c:	1800                	addi	s0,sp,48
    int i;
    if(argc < 3){
 22e:	4789                	li	a5,2
 230:	02a7dd63          	bge	a5,a0,26a <main+0x4a>
 234:	89ae                	mv	s3,a1
 236:	01058493          	addi	s1,a1,16
 23a:	ffd5091b          	addiw	s2,a0,-3
 23e:	02091793          	slli	a5,s2,0x20
 242:	01d7d913          	srli	s2,a5,0x1d
 246:	01858793          	addi	a5,a1,24
 24a:	993e                	add	s2,s2,a5
        printf("what do you want?\n");
        exit(0);
    }
    for(i = 2; i < argc; ++i){
        find(argv[1], argv[i]);
 24c:	608c                	ld	a1,0(s1)
 24e:	0089b503          	ld	a0,8(s3)
 252:	00000097          	auipc	ra,0x0
 256:	e56080e7          	jalr	-426(ra) # a8 <find>
    for(i = 2; i < argc; ++i){
 25a:	04a1                	addi	s1,s1,8
 25c:	ff2498e3          	bne	s1,s2,24c <main+0x2c>
    }
    exit(0);
 260:	4501                	li	a0,0
 262:	00000097          	auipc	ra,0x0
 266:	2a8080e7          	jalr	680(ra) # 50a <exit>
        printf("what do you want?\n");
 26a:	00000517          	auipc	a0,0x0
 26e:	7fe50513          	addi	a0,a0,2046 # a68 <malloc+0x12e>
 272:	00000097          	auipc	ra,0x0
 276:	610080e7          	jalr	1552(ra) # 882 <printf>
        exit(0);
 27a:	4501                	li	a0,0
 27c:	00000097          	auipc	ra,0x0
 280:	28e080e7          	jalr	654(ra) # 50a <exit>

0000000000000284 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 284:	1141                	addi	sp,sp,-16
 286:	e406                	sd	ra,8(sp)
 288:	e022                	sd	s0,0(sp)
 28a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 28c:	00000097          	auipc	ra,0x0
 290:	f94080e7          	jalr	-108(ra) # 220 <main>
  exit(0);
 294:	4501                	li	a0,0
 296:	00000097          	auipc	ra,0x0
 29a:	274080e7          	jalr	628(ra) # 50a <exit>

000000000000029e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0x8>
    ;
  return os;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb91                	beqz	a5,2d8 <strcmp+0x1e>
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00f71763          	bne	a4,a5,2d8 <strcmp+0x1e>
    p++, q++;
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbe5                	bnez	a5,2c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2d8:	0005c503          	lbu	a0,0(a1)
}
 2dc:	40a7853b          	subw	a0,a5,a0
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strlen>:

uint
strlen(const char *s)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cf91                	beqz	a5,30c <strlen+0x26>
 2f2:	0505                	addi	a0,a0,1
 2f4:	87aa                	mv	a5,a0
 2f6:	86be                	mv	a3,a5
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff7c703          	lbu	a4,-1(a5)
 2fe:	ff65                	bnez	a4,2f6 <strlen+0x10>
 300:	40a6853b          	subw	a0,a3,a0
 304:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  for(n = 0; s[n]; n++)
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strlen+0x20>

0000000000000310 <memset>:

void*
memset(void *dst, int c, uint n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 316:	ca19                	beqz	a2,32c <memset+0x1c>
 318:	87aa                	mv	a5,a0
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 322:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 326:	0785                	addi	a5,a5,1
 328:	fee79de3          	bne	a5,a4,322 <memset+0x12>
  }
  return dst;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <strchr>:

char*
strchr(const char *s, char c)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  for(; *s; s++)
 338:	00054783          	lbu	a5,0(a0)
 33c:	cb99                	beqz	a5,352 <strchr+0x20>
    if(*s == c)
 33e:	00f58763          	beq	a1,a5,34c <strchr+0x1a>
  for(; *s; s++)
 342:	0505                	addi	a0,a0,1
 344:	00054783          	lbu	a5,0(a0)
 348:	fbfd                	bnez	a5,33e <strchr+0xc>
      return (char*)s;
  return 0;
 34a:	4501                	li	a0,0
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strchr+0x1a>

0000000000000356 <gets>:

char*
gets(char *buf, int max)
{
 356:	711d                	addi	sp,sp,-96
 358:	ec86                	sd	ra,88(sp)
 35a:	e8a2                	sd	s0,80(sp)
 35c:	e4a6                	sd	s1,72(sp)
 35e:	e0ca                	sd	s2,64(sp)
 360:	fc4e                	sd	s3,56(sp)
 362:	f852                	sd	s4,48(sp)
 364:	f456                	sd	s5,40(sp)
 366:	f05a                	sd	s6,32(sp)
 368:	ec5e                	sd	s7,24(sp)
 36a:	1080                	addi	s0,sp,96
 36c:	8baa                	mv	s7,a0
 36e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 370:	892a                	mv	s2,a0
 372:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 374:	4aa9                	li	s5,10
 376:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	2485                	addiw	s1,s1,1
 37c:	0344d863          	bge	s1,s4,3ac <gets+0x56>
    cc = read(0, &c, 1);
 380:	4605                	li	a2,1
 382:	faf40593          	addi	a1,s0,-81
 386:	4501                	li	a0,0
 388:	00000097          	auipc	ra,0x0
 38c:	19a080e7          	jalr	410(ra) # 522 <read>
    if(cc < 1)
 390:	00a05e63          	blez	a0,3ac <gets+0x56>
    buf[i++] = c;
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39c:	01578763          	beq	a5,s5,3aa <gets+0x54>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679be3          	bne	a5,s6,378 <gets+0x22>
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x56>
 3aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:

int
stat(const char *n, struct stat *st)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e426                	sd	s1,8(sp)
 3d2:	e04a                	sd	s2,0(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d8:	4581                	li	a1,0
 3da:	00000097          	auipc	ra,0x0
 3de:	170080e7          	jalr	368(ra) # 54a <open>
  if(fd < 0)
 3e2:	02054563          	bltz	a0,40c <stat+0x42>
 3e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e8:	85ca                	mv	a1,s2
 3ea:	00000097          	auipc	ra,0x0
 3ee:	178080e7          	jalr	376(ra) # 562 <fstat>
 3f2:	892a                	mv	s2,a0
  close(fd);
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	13c080e7          	jalr	316(ra) # 532 <close>
  return r;
}
 3fe:	854a                	mv	a0,s2
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	64a2                	ld	s1,8(sp)
 406:	6902                	ld	s2,0(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret
    return -1;
 40c:	597d                	li	s2,-1
 40e:	bfc5                	j	3fe <stat+0x34>

0000000000000410 <atoi>:

int
atoi(const char *s)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 416:	00054683          	lbu	a3,0(a0)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	4625                	li	a2,9
 424:	02f66863          	bltu	a2,a5,454 <atoi+0x44>
 428:	872a                	mv	a4,a0
  n = 0;
 42a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 42c:	0705                	addi	a4,a4,1
 42e:	0025179b          	slliw	a5,a0,0x2
 432:	9fa9                	addw	a5,a5,a0
 434:	0017979b          	slliw	a5,a5,0x1
 438:	9fb5                	addw	a5,a5,a3
 43a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 43e:	00074683          	lbu	a3,0(a4)
 442:	fd06879b          	addiw	a5,a3,-48
 446:	0ff7f793          	zext.b	a5,a5
 44a:	fef671e3          	bgeu	a2,a5,42c <atoi+0x1c>
  return n;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  n = 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <atoi+0x3e>

0000000000000458 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 45e:	02b57463          	bgeu	a0,a1,486 <memmove+0x2e>
    while(n-- > 0)
 462:	00c05f63          	blez	a2,480 <memmove+0x28>
 466:	1602                	slli	a2,a2,0x20
 468:	9201                	srli	a2,a2,0x20
 46a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 46e:	872a                	mv	a4,a0
      *dst++ = *src++;
 470:	0585                	addi	a1,a1,1
 472:	0705                	addi	a4,a4,1
 474:	fff5c683          	lbu	a3,-1(a1)
 478:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 47c:	fee79ae3          	bne	a5,a4,470 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret
    dst += n;
 486:	00c50733          	add	a4,a0,a2
    src += n;
 48a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 48c:	fec05ae3          	blez	a2,480 <memmove+0x28>
 490:	fff6079b          	addiw	a5,a2,-1
 494:	1782                	slli	a5,a5,0x20
 496:	9381                	srli	a5,a5,0x20
 498:	fff7c793          	not	a5,a5
 49c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 49e:	15fd                	addi	a1,a1,-1
 4a0:	177d                	addi	a4,a4,-1
 4a2:	0005c683          	lbu	a3,0(a1)
 4a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4aa:	fee79ae3          	bne	a5,a4,49e <memmove+0x46>
 4ae:	bfc9                	j	480 <memmove+0x28>

00000000000004b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b6:	ca05                	beqz	a2,4e6 <memcmp+0x36>
 4b8:	fff6069b          	addiw	a3,a2,-1
 4bc:	1682                	slli	a3,a3,0x20
 4be:	9281                	srli	a3,a3,0x20
 4c0:	0685                	addi	a3,a3,1
 4c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c4:	00054783          	lbu	a5,0(a0)
 4c8:	0005c703          	lbu	a4,0(a1)
 4cc:	00e79863          	bne	a5,a4,4dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d0:	0505                	addi	a0,a0,1
    p2++;
 4d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d4:	fed518e3          	bne	a0,a3,4c4 <memcmp+0x14>
  }
  return 0;
 4d8:	4501                	li	a0,0
 4da:	a019                	j	4e0 <memcmp+0x30>
      return *p1 - *p2;
 4dc:	40e7853b          	subw	a0,a5,a4
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret
  return 0;
 4e6:	4501                	li	a0,0
 4e8:	bfe5                	j	4e0 <memcmp+0x30>

00000000000004ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f2:	00000097          	auipc	ra,0x0
 4f6:	f66080e7          	jalr	-154(ra) # 458 <memmove>
}
 4fa:	60a2                	ld	ra,8(sp)
 4fc:	6402                	ld	s0,0(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 502:	4885                	li	a7,1
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exit>:
.global exit
exit:
 li a7, SYS_exit
 50a:	4889                	li	a7,2
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <wait>:
.global wait
wait:
 li a7, SYS_wait
 512:	488d                	li	a7,3
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51a:	4891                	li	a7,4
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <read>:
.global read
read:
 li a7, SYS_read
 522:	4895                	li	a7,5
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <write>:
.global write
write:
 li a7, SYS_write
 52a:	48c1                	li	a7,16
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <close>:
.global close
close:
 li a7, SYS_close
 532:	48d5                	li	a7,21
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <kill>:
.global kill
kill:
 li a7, SYS_kill
 53a:	4899                	li	a7,6
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exec>:
.global exec
exec:
 li a7, SYS_exec
 542:	489d                	li	a7,7
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <open>:
.global open
open:
 li a7, SYS_open
 54a:	48bd                	li	a7,15
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 552:	48c5                	li	a7,17
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55a:	48c9                	li	a7,18
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 562:	48a1                	li	a7,8
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <link>:
.global link
link:
 li a7, SYS_link
 56a:	48cd                	li	a7,19
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 572:	48d1                	li	a7,20
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57a:	48a5                	li	a7,9
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <dup>:
.global dup
dup:
 li a7, SYS_dup
 582:	48a9                	li	a7,10
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58a:	48ad                	li	a7,11
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 592:	48b1                	li	a7,12
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59a:	48b5                	li	a7,13
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a2:	48b9                	li	a7,14
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <trace>:
.global trace
trace:
 li a7, SYS_trace
 5aa:	48d9                	li	a7,22
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5b2:	48dd                	li	a7,23
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c6:	4605                	li	a2,1
 5c8:	fef40593          	addi	a1,s0,-17
 5cc:	00000097          	auipc	ra,0x0
 5d0:	f5e080e7          	jalr	-162(ra) # 52a <write>
}
 5d4:	60e2                	ld	ra,24(sp)
 5d6:	6442                	ld	s0,16(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret

00000000000005dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dc:	7139                	addi	sp,sp,-64
 5de:	fc06                	sd	ra,56(sp)
 5e0:	f822                	sd	s0,48(sp)
 5e2:	f426                	sd	s1,40(sp)
 5e4:	f04a                	sd	s2,32(sp)
 5e6:	ec4e                	sd	s3,24(sp)
 5e8:	0080                	addi	s0,sp,64
 5ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ec:	c299                	beqz	a3,5f2 <printint+0x16>
 5ee:	0805c963          	bltz	a1,680 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f2:	2581                	sext.w	a1,a1
  neg = 0;
 5f4:	4881                	li	a7,0
 5f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fc:	2601                	sext.w	a2,a2
 5fe:	00000517          	auipc	a0,0x0
 602:	4e250513          	addi	a0,a0,1250 # ae0 <digits>
 606:	883a                	mv	a6,a4
 608:	2705                	addiw	a4,a4,1
 60a:	02c5f7bb          	remuw	a5,a1,a2
 60e:	1782                	slli	a5,a5,0x20
 610:	9381                	srli	a5,a5,0x20
 612:	97aa                	add	a5,a5,a0
 614:	0007c783          	lbu	a5,0(a5)
 618:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 61c:	0005879b          	sext.w	a5,a1
 620:	02c5d5bb          	divuw	a1,a1,a2
 624:	0685                	addi	a3,a3,1
 626:	fec7f0e3          	bgeu	a5,a2,606 <printint+0x2a>
  if(neg)
 62a:	00088c63          	beqz	a7,642 <printint+0x66>
    buf[i++] = '-';
 62e:	fd070793          	addi	a5,a4,-48
 632:	00878733          	add	a4,a5,s0
 636:	02d00793          	li	a5,45
 63a:	fef70823          	sb	a5,-16(a4)
 63e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 642:	02e05863          	blez	a4,672 <printint+0x96>
 646:	fc040793          	addi	a5,s0,-64
 64a:	00e78933          	add	s2,a5,a4
 64e:	fff78993          	addi	s3,a5,-1
 652:	99ba                	add	s3,s3,a4
 654:	377d                	addiw	a4,a4,-1
 656:	1702                	slli	a4,a4,0x20
 658:	9301                	srli	a4,a4,0x20
 65a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 65e:	fff94583          	lbu	a1,-1(s2)
 662:	8526                	mv	a0,s1
 664:	00000097          	auipc	ra,0x0
 668:	f56080e7          	jalr	-170(ra) # 5ba <putc>
  while(--i >= 0)
 66c:	197d                	addi	s2,s2,-1
 66e:	ff3918e3          	bne	s2,s3,65e <printint+0x82>
}
 672:	70e2                	ld	ra,56(sp)
 674:	7442                	ld	s0,48(sp)
 676:	74a2                	ld	s1,40(sp)
 678:	7902                	ld	s2,32(sp)
 67a:	69e2                	ld	s3,24(sp)
 67c:	6121                	addi	sp,sp,64
 67e:	8082                	ret
    x = -xx;
 680:	40b005bb          	negw	a1,a1
    neg = 1;
 684:	4885                	li	a7,1
    x = -xx;
 686:	bf85                	j	5f6 <printint+0x1a>

0000000000000688 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 688:	715d                	addi	sp,sp,-80
 68a:	e486                	sd	ra,72(sp)
 68c:	e0a2                	sd	s0,64(sp)
 68e:	fc26                	sd	s1,56(sp)
 690:	f84a                	sd	s2,48(sp)
 692:	f44e                	sd	s3,40(sp)
 694:	f052                	sd	s4,32(sp)
 696:	ec56                	sd	s5,24(sp)
 698:	e85a                	sd	s6,16(sp)
 69a:	e45e                	sd	s7,8(sp)
 69c:	e062                	sd	s8,0(sp)
 69e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a0:	0005c903          	lbu	s2,0(a1)
 6a4:	18090c63          	beqz	s2,83c <vprintf+0x1b4>
 6a8:	8aaa                	mv	s5,a0
 6aa:	8bb2                	mv	s7,a2
 6ac:	00158493          	addi	s1,a1,1
  state = 0;
 6b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b2:	02500a13          	li	s4,37
 6b6:	4b55                	li	s6,21
 6b8:	a839                	j	6d6 <vprintf+0x4e>
        putc(fd, c);
 6ba:	85ca                	mv	a1,s2
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	efc080e7          	jalr	-260(ra) # 5ba <putc>
 6c6:	a019                	j	6cc <vprintf+0x44>
    } else if(state == '%'){
 6c8:	01498d63          	beq	s3,s4,6e2 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6cc:	0485                	addi	s1,s1,1
 6ce:	fff4c903          	lbu	s2,-1(s1)
 6d2:	16090563          	beqz	s2,83c <vprintf+0x1b4>
    if(state == 0){
 6d6:	fe0999e3          	bnez	s3,6c8 <vprintf+0x40>
      if(c == '%'){
 6da:	ff4910e3          	bne	s2,s4,6ba <vprintf+0x32>
        state = '%';
 6de:	89d2                	mv	s3,s4
 6e0:	b7f5                	j	6cc <vprintf+0x44>
      if(c == 'd'){
 6e2:	13490263          	beq	s2,s4,806 <vprintf+0x17e>
 6e6:	f9d9079b          	addiw	a5,s2,-99
 6ea:	0ff7f793          	zext.b	a5,a5
 6ee:	12fb6563          	bltu	s6,a5,818 <vprintf+0x190>
 6f2:	f9d9079b          	addiw	a5,s2,-99
 6f6:	0ff7f713          	zext.b	a4,a5
 6fa:	10eb6f63          	bltu	s6,a4,818 <vprintf+0x190>
 6fe:	00271793          	slli	a5,a4,0x2
 702:	00000717          	auipc	a4,0x0
 706:	38670713          	addi	a4,a4,902 # a88 <malloc+0x14e>
 70a:	97ba                	add	a5,a5,a4
 70c:	439c                	lw	a5,0(a5)
 70e:	97ba                	add	a5,a5,a4
 710:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 712:	008b8913          	addi	s2,s7,8
 716:	4685                	li	a3,1
 718:	4629                	li	a2,10
 71a:	000ba583          	lw	a1,0(s7)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	ebc080e7          	jalr	-324(ra) # 5dc <printint>
 728:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b745                	j	6cc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4629                	li	a2,10
 736:	000ba583          	lw	a1,0(s7)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	ea0080e7          	jalr	-352(ra) # 5dc <printint>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	b751                	j	6cc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 74a:	008b8913          	addi	s2,s7,8
 74e:	4681                	li	a3,0
 750:	4641                	li	a2,16
 752:	000ba583          	lw	a1,0(s7)
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e84080e7          	jalr	-380(ra) # 5dc <printint>
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	b7a5                	j	6cc <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 766:	008b8c13          	addi	s8,s7,8
 76a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76e:	03000593          	li	a1,48
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	e46080e7          	jalr	-442(ra) # 5ba <putc>
  putc(fd, 'x');
 77c:	07800593          	li	a1,120
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e38080e7          	jalr	-456(ra) # 5ba <putc>
 78a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	00000b97          	auipc	s7,0x0
 790:	354b8b93          	addi	s7,s7,852 # ae0 <digits>
 794:	03c9d793          	srli	a5,s3,0x3c
 798:	97de                	add	a5,a5,s7
 79a:	0007c583          	lbu	a1,0(a5)
 79e:	8556                	mv	a0,s5
 7a0:	00000097          	auipc	ra,0x0
 7a4:	e1a080e7          	jalr	-486(ra) # 5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a8:	0992                	slli	s3,s3,0x4
 7aa:	397d                	addiw	s2,s2,-1
 7ac:	fe0914e3          	bnez	s2,794 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7b0:	8be2                	mv	s7,s8
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bf21                	j	6cc <vprintf+0x44>
        s = va_arg(ap, char*);
 7b6:	008b8993          	addi	s3,s7,8
 7ba:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7be:	02090163          	beqz	s2,7e0 <vprintf+0x158>
        while(*s != 0){
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	c9a5                	beqz	a1,836 <vprintf+0x1ae>
          putc(fd, *s);
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	df0080e7          	jalr	-528(ra) # 5ba <putc>
          s++;
 7d2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	f9e5                	bnez	a1,7c8 <vprintf+0x140>
        s = va_arg(ap, char*);
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b5fd                	j	6cc <vprintf+0x44>
          s = "(null)";
 7e0:	00000917          	auipc	s2,0x0
 7e4:	2a090913          	addi	s2,s2,672 # a80 <malloc+0x146>
        while(*s != 0){
 7e8:	02800593          	li	a1,40
 7ec:	bff1                	j	7c8 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 7ee:	008b8913          	addi	s2,s7,8
 7f2:	000bc583          	lbu	a1,0(s7)
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	dc2080e7          	jalr	-574(ra) # 5ba <putc>
 800:	8bca                	mv	s7,s2
      state = 0;
 802:	4981                	li	s3,0
 804:	b5e1                	j	6cc <vprintf+0x44>
        putc(fd, c);
 806:	02500593          	li	a1,37
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	dae080e7          	jalr	-594(ra) # 5ba <putc>
      state = 0;
 814:	4981                	li	s3,0
 816:	bd5d                	j	6cc <vprintf+0x44>
        putc(fd, '%');
 818:	02500593          	li	a1,37
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	d9c080e7          	jalr	-612(ra) # 5ba <putc>
        putc(fd, c);
 826:	85ca                	mv	a1,s2
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	d90080e7          	jalr	-624(ra) # 5ba <putc>
      state = 0;
 832:	4981                	li	s3,0
 834:	bd61                	j	6cc <vprintf+0x44>
        s = va_arg(ap, char*);
 836:	8bce                	mv	s7,s3
      state = 0;
 838:	4981                	li	s3,0
 83a:	bd49                	j	6cc <vprintf+0x44>
    }
  }
}
 83c:	60a6                	ld	ra,72(sp)
 83e:	6406                	ld	s0,64(sp)
 840:	74e2                	ld	s1,56(sp)
 842:	7942                	ld	s2,48(sp)
 844:	79a2                	ld	s3,40(sp)
 846:	7a02                	ld	s4,32(sp)
 848:	6ae2                	ld	s5,24(sp)
 84a:	6b42                	ld	s6,16(sp)
 84c:	6ba2                	ld	s7,8(sp)
 84e:	6c02                	ld	s8,0(sp)
 850:	6161                	addi	sp,sp,80
 852:	8082                	ret

0000000000000854 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 854:	715d                	addi	sp,sp,-80
 856:	ec06                	sd	ra,24(sp)
 858:	e822                	sd	s0,16(sp)
 85a:	1000                	addi	s0,sp,32
 85c:	e010                	sd	a2,0(s0)
 85e:	e414                	sd	a3,8(s0)
 860:	e818                	sd	a4,16(s0)
 862:	ec1c                	sd	a5,24(s0)
 864:	03043023          	sd	a6,32(s0)
 868:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 870:	8622                	mv	a2,s0
 872:	00000097          	auipc	ra,0x0
 876:	e16080e7          	jalr	-490(ra) # 688 <vprintf>
}
 87a:	60e2                	ld	ra,24(sp)
 87c:	6442                	ld	s0,16(sp)
 87e:	6161                	addi	sp,sp,80
 880:	8082                	ret

0000000000000882 <printf>:

void
printf(const char *fmt, ...)
{
 882:	711d                	addi	sp,sp,-96
 884:	ec06                	sd	ra,24(sp)
 886:	e822                	sd	s0,16(sp)
 888:	1000                	addi	s0,sp,32
 88a:	e40c                	sd	a1,8(s0)
 88c:	e810                	sd	a2,16(s0)
 88e:	ec14                	sd	a3,24(s0)
 890:	f018                	sd	a4,32(s0)
 892:	f41c                	sd	a5,40(s0)
 894:	03043823          	sd	a6,48(s0)
 898:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 89c:	00840613          	addi	a2,s0,8
 8a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a4:	85aa                	mv	a1,a0
 8a6:	4505                	li	a0,1
 8a8:	00000097          	auipc	ra,0x0
 8ac:	de0080e7          	jalr	-544(ra) # 688 <vprintf>
}
 8b0:	60e2                	ld	ra,24(sp)
 8b2:	6442                	ld	s0,16(sp)
 8b4:	6125                	addi	sp,sp,96
 8b6:	8082                	ret

00000000000008b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b8:	1141                	addi	sp,sp,-16
 8ba:	e422                	sd	s0,8(sp)
 8bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	00000797          	auipc	a5,0x0
 8c6:	73e7b783          	ld	a5,1854(a5) # 1000 <freep>
 8ca:	a02d                	j	8f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8cc:	4618                	lw	a4,8(a2)
 8ce:	9f2d                	addw	a4,a4,a1
 8d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	6310                	ld	a2,0(a4)
 8d8:	a83d                	j	916 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8da:	ff852703          	lw	a4,-8(a0)
 8de:	9f31                	addw	a4,a4,a2
 8e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e2:	ff053683          	ld	a3,-16(a0)
 8e6:	a091                	j	92a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e8:	6398                	ld	a4,0(a5)
 8ea:	00e7e463          	bltu	a5,a4,8f2 <free+0x3a>
 8ee:	00e6ea63          	bltu	a3,a4,902 <free+0x4a>
{
 8f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	fed7fae3          	bgeu	a5,a3,8e8 <free+0x30>
 8f8:	6398                	ld	a4,0(a5)
 8fa:	00e6e463          	bltu	a3,a4,902 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	fee7eae3          	bltu	a5,a4,8f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 902:	ff852583          	lw	a1,-8(a0)
 906:	6390                	ld	a2,0(a5)
 908:	02059813          	slli	a6,a1,0x20
 90c:	01c85713          	srli	a4,a6,0x1c
 910:	9736                	add	a4,a4,a3
 912:	fae60de3          	beq	a2,a4,8cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 91a:	4790                	lw	a2,8(a5)
 91c:	02061593          	slli	a1,a2,0x20
 920:	01c5d713          	srli	a4,a1,0x1c
 924:	973e                	add	a4,a4,a5
 926:	fae68ae3          	beq	a3,a4,8da <free+0x22>
    p->s.ptr = bp->s.ptr;
 92a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 92c:	00000717          	auipc	a4,0x0
 930:	6cf73a23          	sd	a5,1748(a4) # 1000 <freep>
}
 934:	6422                	ld	s0,8(sp)
 936:	0141                	addi	sp,sp,16
 938:	8082                	ret

000000000000093a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 93a:	7139                	addi	sp,sp,-64
 93c:	fc06                	sd	ra,56(sp)
 93e:	f822                	sd	s0,48(sp)
 940:	f426                	sd	s1,40(sp)
 942:	f04a                	sd	s2,32(sp)
 944:	ec4e                	sd	s3,24(sp)
 946:	e852                	sd	s4,16(sp)
 948:	e456                	sd	s5,8(sp)
 94a:	e05a                	sd	s6,0(sp)
 94c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94e:	02051493          	slli	s1,a0,0x20
 952:	9081                	srli	s1,s1,0x20
 954:	04bd                	addi	s1,s1,15
 956:	8091                	srli	s1,s1,0x4
 958:	0014899b          	addiw	s3,s1,1
 95c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 95e:	00000517          	auipc	a0,0x0
 962:	6a253503          	ld	a0,1698(a0) # 1000 <freep>
 966:	c515                	beqz	a0,992 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	02977f63          	bgeu	a4,s1,9aa <malloc+0x70>
  if(nu < 4096)
 970:	8a4e                	mv	s4,s3
 972:	0009871b          	sext.w	a4,s3
 976:	6685                	lui	a3,0x1
 978:	00d77363          	bgeu	a4,a3,97e <malloc+0x44>
 97c:	6a05                	lui	s4,0x1
 97e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 982:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 986:	00000917          	auipc	s2,0x0
 98a:	67a90913          	addi	s2,s2,1658 # 1000 <freep>
  if(p == (char*)-1)
 98e:	5afd                	li	s5,-1
 990:	a895                	j	a04 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 992:	00000797          	auipc	a5,0x0
 996:	68e78793          	addi	a5,a5,1678 # 1020 <base>
 99a:	00000717          	auipc	a4,0x0
 99e:	66f73323          	sd	a5,1638(a4) # 1000 <freep>
 9a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a8:	b7e1                	j	970 <malloc+0x36>
      if(p->s.size == nunits)
 9aa:	02e48c63          	beq	s1,a4,9e2 <malloc+0xa8>
        p->s.size -= nunits;
 9ae:	4137073b          	subw	a4,a4,s3
 9b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b4:	02071693          	slli	a3,a4,0x20
 9b8:	01c6d713          	srli	a4,a3,0x1c
 9bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62a73f23          	sd	a0,1598(a4) # 1000 <freep>
      return (void*)(p + 1);
 9ca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9ce:	70e2                	ld	ra,56(sp)
 9d0:	7442                	ld	s0,48(sp)
 9d2:	74a2                	ld	s1,40(sp)
 9d4:	7902                	ld	s2,32(sp)
 9d6:	69e2                	ld	s3,24(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	6121                	addi	sp,sp,64
 9e0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9e2:	6398                	ld	a4,0(a5)
 9e4:	e118                	sd	a4,0(a0)
 9e6:	bff1                	j	9c2 <malloc+0x88>
  hp->s.size = nu;
 9e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ec:	0541                	addi	a0,a0,16
 9ee:	00000097          	auipc	ra,0x0
 9f2:	eca080e7          	jalr	-310(ra) # 8b8 <free>
  return freep;
 9f6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9fa:	d971                	beqz	a0,9ce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	fa9775e3          	bgeu	a4,s1,9aa <malloc+0x70>
    if(p == freep)
 a04:	00093703          	ld	a4,0(s2)
 a08:	853e                	mv	a0,a5
 a0a:	fef719e3          	bne	a4,a5,9fc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a0e:	8552                	mv	a0,s4
 a10:	00000097          	auipc	ra,0x0
 a14:	b82080e7          	jalr	-1150(ra) # 592 <sbrk>
  if(p == (char*)-1)
 a18:	fd5518e3          	bne	a0,s5,9e8 <malloc+0xae>
        return 0;
 a1c:	4501                	li	a0,0
 a1e:	bf45                	j	9ce <malloc+0x94>
