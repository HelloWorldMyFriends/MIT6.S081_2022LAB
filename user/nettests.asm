
user/_nettests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:

// Decode a DNS name
static void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
       2:	02e00813          	li	a6,46
    if(qn >= qnMax){
       6:	02b56a63          	bltu	a0,a1,3a <decode_qname+0x3a>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	ffe50513          	addi	a0,a0,-2 # 1010 <malloc+0xee>
      1a:	00001097          	auipc	ra,0x1
      1e:	e50080e7          	jalr	-432(ra) # e6a <printf>
      exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	ace080e7          	jalr	-1330(ra) # af2 <exit>
    *qn++ = '.';
      2c:	00160793          	addi	a5,a2,1
      30:	953e                	add	a0,a0,a5
      32:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
      36:	fcb57ae3          	bgeu	a0,a1,a <decode_qname+0xa>
    int l = *qn;
      3a:	00054683          	lbu	a3,0(a0)
    if(l == 0)
      3e:	ce89                	beqz	a3,58 <decode_qname+0x58>
    for(int i = 0; i < l; i++) {
      40:	0006861b          	sext.w	a2,a3
      44:	96aa                	add	a3,a3,a0
    if(l == 0)
      46:	87aa                	mv	a5,a0
      *qn = *(qn+1);
      48:	0017c703          	lbu	a4,1(a5)
      4c:	00e78023          	sb	a4,0(a5)
      qn++;
      50:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
      52:	fed79be3          	bne	a5,a3,48 <decode_qname+0x48>
      56:	bfd9                	j	2c <decode_qname+0x2c>
      58:	8082                	ret

000000000000005a <ping>:
{
      5a:	7171                	addi	sp,sp,-176
      5c:	f506                	sd	ra,168(sp)
      5e:	f122                	sd	s0,160(sp)
      60:	ed26                	sd	s1,152(sp)
      62:	e94a                	sd	s2,144(sp)
      64:	e54e                	sd	s3,136(sp)
      66:	e152                	sd	s4,128(sp)
      68:	1900                	addi	s0,sp,176
      6a:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
      6c:	862e                	mv	a2,a1
      6e:	85aa                	mv	a1,a0
      70:	0a000537          	lui	a0,0xa000
      74:	20250513          	addi	a0,a0,514 # a000202 <base+0x9ffe1f2>
      78:	00001097          	auipc	ra,0x1
      7c:	b1a080e7          	jalr	-1254(ra) # b92 <connect>
      80:	08054663          	bltz	a0,10c <ping+0xb2>
      84:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
      86:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
      88:	00001917          	auipc	s2,0x1
      8c:	fb890913          	addi	s2,s2,-72 # 1040 <malloc+0x11e>
  for(int i = 0; i < attempts; i++) {
      90:	03405463          	blez	s4,b8 <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
      94:	854a                	mv	a0,s2
      96:	00001097          	auipc	ra,0x1
      9a:	838080e7          	jalr	-1992(ra) # 8ce <strlen>
      9e:	0005061b          	sext.w	a2,a0
      a2:	85ca                	mv	a1,s2
      a4:	854e                	mv	a0,s3
      a6:	00001097          	auipc	ra,0x1
      aa:	a6c080e7          	jalr	-1428(ra) # b12 <write>
      ae:	06054d63          	bltz	a0,128 <ping+0xce>
  for(int i = 0; i < attempts; i++) {
      b2:	2485                	addiw	s1,s1,1
      b4:	fe9a10e3          	bne	s4,s1,94 <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
      b8:	07f00613          	li	a2,127
      bc:	f5040593          	addi	a1,s0,-176
      c0:	854e                	mv	a0,s3
      c2:	00001097          	auipc	ra,0x1
      c6:	a48080e7          	jalr	-1464(ra) # b0a <read>
      ca:	84aa                	mv	s1,a0
  if(cc < 0){
      cc:	06054c63          	bltz	a0,144 <ping+0xea>
  close(fd);
      d0:	854e                	mv	a0,s3
      d2:	00001097          	auipc	ra,0x1
      d6:	a48080e7          	jalr	-1464(ra) # b1a <close>
  ibuf[cc] = '\0';
      da:	fd048793          	addi	a5,s1,-48
      de:	008784b3          	add	s1,a5,s0
      e2:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
      e6:	00001597          	auipc	a1,0x1
      ea:	fa258593          	addi	a1,a1,-94 # 1088 <malloc+0x166>
      ee:	f5040513          	addi	a0,s0,-176
      f2:	00000097          	auipc	ra,0x0
      f6:	7b0080e7          	jalr	1968(ra) # 8a2 <strcmp>
      fa:	e13d                	bnez	a0,160 <ping+0x106>
}
      fc:	70aa                	ld	ra,168(sp)
      fe:	740a                	ld	s0,160(sp)
     100:	64ea                	ld	s1,152(sp)
     102:	694a                	ld	s2,144(sp)
     104:	69aa                	ld	s3,136(sp)
     106:	6a0a                	ld	s4,128(sp)
     108:	614d                	addi	sp,sp,176
     10a:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
     10c:	00001597          	auipc	a1,0x1
     110:	f1c58593          	addi	a1,a1,-228 # 1028 <malloc+0x106>
     114:	4509                	li	a0,2
     116:	00001097          	auipc	ra,0x1
     11a:	d26080e7          	jalr	-730(ra) # e3c <fprintf>
    exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	9d2080e7          	jalr	-1582(ra) # af2 <exit>
      fprintf(2, "ping: send() failed\n");
     128:	00001597          	auipc	a1,0x1
     12c:	f3058593          	addi	a1,a1,-208 # 1058 <malloc+0x136>
     130:	4509                	li	a0,2
     132:	00001097          	auipc	ra,0x1
     136:	d0a080e7          	jalr	-758(ra) # e3c <fprintf>
      exit(1);
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	9b6080e7          	jalr	-1610(ra) # af2 <exit>
    fprintf(2, "ping: recv() failed\n");
     144:	00001597          	auipc	a1,0x1
     148:	f2c58593          	addi	a1,a1,-212 # 1070 <malloc+0x14e>
     14c:	4509                	li	a0,2
     14e:	00001097          	auipc	ra,0x1
     152:	cee080e7          	jalr	-786(ra) # e3c <fprintf>
    exit(1);
     156:	4505                	li	a0,1
     158:	00001097          	auipc	ra,0x1
     15c:	99a080e7          	jalr	-1638(ra) # af2 <exit>
    fprintf(2, "ping didn't receive correct payload\n");
     160:	00001597          	auipc	a1,0x1
     164:	f4058593          	addi	a1,a1,-192 # 10a0 <malloc+0x17e>
     168:	4509                	li	a0,2
     16a:	00001097          	auipc	ra,0x1
     16e:	cd2080e7          	jalr	-814(ra) # e3c <fprintf>
    exit(1);
     172:	4505                	li	a0,1
     174:	00001097          	auipc	ra,0x1
     178:	97e080e7          	jalr	-1666(ra) # af2 <exit>

000000000000017c <dns>:
  }
}

static void
dns()
{
     17c:	7119                	addi	sp,sp,-128
     17e:	fc86                	sd	ra,120(sp)
     180:	f8a2                	sd	s0,112(sp)
     182:	f4a6                	sd	s1,104(sp)
     184:	f0ca                	sd	s2,96(sp)
     186:	ecce                	sd	s3,88(sp)
     188:	e8d2                	sd	s4,80(sp)
     18a:	e4d6                	sd	s5,72(sp)
     18c:	e0da                	sd	s6,64(sp)
     18e:	fc5e                	sd	s7,56(sp)
     190:	f862                	sd	s8,48(sp)
     192:	f466                	sd	s9,40(sp)
     194:	f06a                	sd	s10,32(sp)
     196:	ec6e                	sd	s11,24(sp)
     198:	0100                	addi	s0,sp,128
     19a:	83010113          	addi	sp,sp,-2000
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
     19e:	3e800613          	li	a2,1000
     1a2:	4581                	li	a1,0
     1a4:	ba840513          	addi	a0,s0,-1112
     1a8:	00000097          	auipc	ra,0x0
     1ac:	750080e7          	jalr	1872(ra) # 8f8 <memset>
  memset(ibuf, 0, N);
     1b0:	3e800613          	li	a2,1000
     1b4:	4581                	li	a1,0
     1b6:	77fd                	lui	a5,0xfffff
     1b8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     1bc:	00f40533          	add	a0,s0,a5
     1c0:	00000097          	auipc	ra,0x0
     1c4:	738080e7          	jalr	1848(ra) # 8f8 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
     1c8:	03500613          	li	a2,53
     1cc:	6589                	lui	a1,0x2
     1ce:	71058593          	addi	a1,a1,1808 # 2710 <base+0x700>
     1d2:	08081537          	lui	a0,0x8081
     1d6:	80850513          	addi	a0,a0,-2040 # 8080808 <base+0x807e7f8>
     1da:	00001097          	auipc	ra,0x1
     1de:	9b8080e7          	jalr	-1608(ra) # b92 <connect>
     1e2:	777d                	lui	a4,0xfffff
     1e4:	7b070713          	addi	a4,a4,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     1e8:	9722                	add	a4,a4,s0
     1ea:	e308                	sd	a0,0(a4)
     1ec:	02054c63          	bltz	a0,224 <dns+0xa8>
  hdr->id = htons(6828);
     1f0:	77ed                	lui	a5,0xffffb
     1f2:	c1a78793          	addi	a5,a5,-998 # ffffffffffffac1a <base+0xffffffffffff8c0a>
     1f6:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
     1fa:	baa45783          	lhu	a5,-1110(s0)
     1fe:	0017e793          	ori	a5,a5,1
     202:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
     206:	10000793          	li	a5,256
     20a:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
     20e:	00001497          	auipc	s1,0x1
     212:	eba48493          	addi	s1,s1,-326 # 10c8 <malloc+0x1a6>
  char *l = host; 
     216:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     218:	bb440a93          	addi	s5,s0,-1100
     21c:	8926                	mv	s2,s1
    if(*c == '.') {
     21e:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     222:	a82d                	j	25c <dns+0xe0>
    fprintf(2, "ping: connect() failed\n");
     224:	00001597          	auipc	a1,0x1
     228:	e0458593          	addi	a1,a1,-508 # 1028 <malloc+0x106>
     22c:	4509                	li	a0,2
     22e:	00001097          	auipc	ra,0x1
     232:	c0e080e7          	jalr	-1010(ra) # e3c <fprintf>
    exit(1);
     236:	4505                	li	a0,1
     238:	00001097          	auipc	ra,0x1
     23c:	8ba080e7          	jalr	-1862(ra) # af2 <exit>
        *qn++ = *d;
     240:	0705                	addi	a4,a4,1
     242:	0007c683          	lbu	a3,0(a5)
     246:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     24a:	0785                	addi	a5,a5,1
     24c:	fef49ae3          	bne	s1,a5,240 <dns+0xc4>
        *qn++ = *d;
     250:	41448ab3          	sub	s5,s1,s4
     254:	9ab2                	add	s5,s5,a2
      l = c+1; // skip .
     256:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     25a:	0485                	addi	s1,s1,1
     25c:	854a                	mv	a0,s2
     25e:	00000097          	auipc	ra,0x0
     262:	670080e7          	jalr	1648(ra) # 8ce <strlen>
     266:	02051793          	slli	a5,a0,0x20
     26a:	9381                	srli	a5,a5,0x20
     26c:	0785                	addi	a5,a5,1
     26e:	97ca                	add	a5,a5,s2
     270:	02f4f363          	bgeu	s1,a5,296 <dns+0x11a>
    if(*c == '.') {
     274:	0004c783          	lbu	a5,0(s1)
     278:	ff3791e3          	bne	a5,s3,25a <dns+0xde>
      *qn++ = (char) (c-l);
     27c:	001a8613          	addi	a2,s5,1
     280:	414487b3          	sub	a5,s1,s4
     284:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     288:	009a7563          	bgeu	s4,s1,292 <dns+0x116>
     28c:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     28e:	8732                	mv	a4,a2
     290:	bf45                	j	240 <dns+0xc4>
     292:	8ab2                	mv	s5,a2
     294:	b7c9                	j	256 <dns+0xda>
  *qn = '\0';
     296:	000a8023          	sb	zero,0(s5)
  len += strlen(qname) + 1;
     29a:	bb440513          	addi	a0,s0,-1100
     29e:	00000097          	auipc	ra,0x0
     2a2:	630080e7          	jalr	1584(ra) # 8ce <strlen>
     2a6:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     2aa:	bb440513          	addi	a0,s0,-1100
     2ae:	00000097          	auipc	ra,0x0
     2b2:	620080e7          	jalr	1568(ra) # 8ce <strlen>
     2b6:	02051793          	slli	a5,a0,0x20
     2ba:	9381                	srli	a5,a5,0x20
     2bc:	0785                	addi	a5,a5,1
     2be:	bb440713          	addi	a4,s0,-1100
     2c2:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
     2c4:	00078023          	sb	zero,0(a5)
     2c8:	4705                	li	a4,1
     2ca:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
     2ce:	00078123          	sb	zero,2(a5)
     2d2:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
     2d6:	0114861b          	addiw	a2,s1,17
     2da:	ba840593          	addi	a1,s0,-1112
     2de:	77fd                	lui	a5,0xfffff
     2e0:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     2e4:	97a2                	add	a5,a5,s0
     2e6:	6388                	ld	a0,0(a5)
     2e8:	00001097          	auipc	ra,0x1
     2ec:	82a080e7          	jalr	-2006(ra) # b12 <write>
     2f0:	10054a63          	bltz	a0,404 <dns+0x288>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
     2f4:	3e800613          	li	a2,1000
     2f8:	77fd                	lui	a5,0xfffff
     2fa:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     2fe:	00f405b3          	add	a1,s0,a5
     302:	77fd                	lui	a5,0xfffff
     304:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     308:	97a2                	add	a5,a5,s0
     30a:	6388                	ld	a0,0(a5)
     30c:	00000097          	auipc	ra,0x0
     310:	7fe080e7          	jalr	2046(ra) # b0a <read>
     314:	8a2a                	mv	s4,a0
  if(cc < 0){
     316:	10054563          	bltz	a0,420 <dns+0x2a4>
  if(cc < sizeof(struct dns)){
     31a:	0005079b          	sext.w	a5,a0
     31e:	472d                	li	a4,11
     320:	10f77e63          	bgeu	a4,a5,43c <dns+0x2c0>
  if(!hdr->qr) {
     324:	77fd                	lui	a5,0xfffff
     326:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <base+0xffffffffffffd7b2>
     32a:	97a2                	add	a5,a5,s0
     32c:	00078783          	lb	a5,0(a5)
     330:	1207d363          	bgez	a5,456 <dns+0x2da>
  if(hdr->id != htons(6828)){
     334:	77fd                	lui	a5,0xfffff
     336:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     33a:	97a2                	add	a5,a5,s0
     33c:	0007d703          	lhu	a4,0(a5)
     340:	0007069b          	sext.w	a3,a4
     344:	67ad                	lui	a5,0xb
     346:	c1a78793          	addi	a5,a5,-998 # ac1a <base+0x8c0a>
     34a:	14f69063          	bne	a3,a5,48a <dns+0x30e>
  if(hdr->rcode != 0) {
     34e:	777d                	lui	a4,0xfffff
     350:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     354:	97a2                	add	a5,a5,s0
     356:	0007c783          	lbu	a5,0(a5)
     35a:	8bbd                	andi	a5,a5,15
     35c:	14079b63          	bnez	a5,4b2 <dns+0x336>
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     360:	7c470793          	addi	a5,a4,1988
     364:	97a2                	add	a5,a5,s0
     366:	0007d783          	lhu	a5,0(a5)
     36a:	4981                	li	s3,0
  len = sizeof(struct dns);
     36c:	44b1                	li	s1,12
  char *qname = 0;
     36e:	4901                	li	s2,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     370:	c3b9                	beqz	a5,3b6 <dns+0x23a>
    char *qn = (char *) (ibuf+len);
     372:	7afd                	lui	s5,0xfffff
     374:	7c0a8793          	addi	a5,s5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     378:	97a2                	add	a5,a5,s0
     37a:	00978933          	add	s2,a5,s1
    decode_qname(qn, cc - len);
     37e:	409a05bb          	subw	a1,s4,s1
     382:	854a                	mv	a0,s2
     384:	00000097          	auipc	ra,0x0
     388:	c7c080e7          	jalr	-900(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
     38c:	854a                	mv	a0,s2
     38e:	00000097          	auipc	ra,0x0
     392:	540080e7          	jalr	1344(ra) # 8ce <strlen>
    len += sizeof(struct dns_question);
     396:	2515                	addiw	a0,a0,5
     398:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     39a:	2985                	addiw	s3,s3,1
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     39c:	7c4a8793          	addi	a5,s5,1988
     3a0:	97a2                	add	a5,a5,s0
     3a2:	0007d783          	lhu	a5,0(a5)
     3a6:	0087971b          	slliw	a4,a5,0x8
     3aa:	83a1                	srli	a5,a5,0x8
     3ac:	8fd9                	or	a5,a5,a4
     3ae:	17c2                	slli	a5,a5,0x30
     3b0:	93c1                	srli	a5,a5,0x30
     3b2:	fcf9c0e3          	blt	s3,a5,372 <dns+0x1f6>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3b6:	77fd                	lui	a5,0xfffff
     3b8:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     3bc:	97a2                	add	a5,a5,s0
     3be:	0007d783          	lhu	a5,0(a5)
     3c2:	24078163          	beqz	a5,604 <dns+0x488>
    if(len >= cc){
     3c6:	1144da63          	bge	s1,s4,4da <dns+0x35e>
     3ca:	00001797          	auipc	a5,0x1
     3ce:	e3e78793          	addi	a5,a5,-450 # 1208 <malloc+0x2e6>
     3d2:	00090363          	beqz	s2,3d8 <dns+0x25c>
     3d6:	87ca                	mv	a5,s2
     3d8:	777d                	lui	a4,0xfffff
     3da:	7b870713          	addi	a4,a4,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     3de:	9722                	add	a4,a4,s0
     3e0:	e31c                	sd	a5,0(a4)
  int record = 0;
     3e2:	4c01                	li	s8,0
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3e4:	4901                	li	s2,0
    if((int) qn[0] > 63) {  // compression?
     3e6:	03f00b13          	li	s6,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     3ea:	10000a93          	li	s5,256
     3ee:	40000b93          	li	s7,1024
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     3f2:	00001c97          	auipc	s9,0x1
     3f6:	d96c8c93          	addi	s9,s9,-618 # 1188 <malloc+0x266>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     3fa:	08000d93          	li	s11,128
     3fe:	03400d13          	li	s10,52
     402:	a2b1                	j	54e <dns+0x3d2>
    fprintf(2, "dns: send() failed\n");
     404:	00001597          	auipc	a1,0x1
     408:	cdc58593          	addi	a1,a1,-804 # 10e0 <malloc+0x1be>
     40c:	4509                	li	a0,2
     40e:	00001097          	auipc	ra,0x1
     412:	a2e080e7          	jalr	-1490(ra) # e3c <fprintf>
    exit(1);
     416:	4505                	li	a0,1
     418:	00000097          	auipc	ra,0x0
     41c:	6da080e7          	jalr	1754(ra) # af2 <exit>
    fprintf(2, "dns: recv() failed\n");
     420:	00001597          	auipc	a1,0x1
     424:	cd858593          	addi	a1,a1,-808 # 10f8 <malloc+0x1d6>
     428:	4509                	li	a0,2
     42a:	00001097          	auipc	ra,0x1
     42e:	a12080e7          	jalr	-1518(ra) # e3c <fprintf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00000097          	auipc	ra,0x0
     438:	6be080e7          	jalr	1726(ra) # af2 <exit>
    printf("DNS reply too short\n");
     43c:	00001517          	auipc	a0,0x1
     440:	cd450513          	addi	a0,a0,-812 # 1110 <malloc+0x1ee>
     444:	00001097          	auipc	ra,0x1
     448:	a26080e7          	jalr	-1498(ra) # e6a <printf>
    exit(1);
     44c:	4505                	li	a0,1
     44e:	00000097          	auipc	ra,0x0
     452:	6a4080e7          	jalr	1700(ra) # af2 <exit>
     456:	77fd                	lui	a5,0xfffff
     458:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     45c:	97a2                	add	a5,a5,s0
     45e:	0007d783          	lhu	a5,0(a5)
     462:	0087971b          	slliw	a4,a5,0x8
     466:	83a1                	srli	a5,a5,0x8
     468:	00e7e5b3          	or	a1,a5,a4
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     46c:	15c2                	slli	a1,a1,0x30
     46e:	91c1                	srli	a1,a1,0x30
     470:	00001517          	auipc	a0,0x1
     474:	cb850513          	addi	a0,a0,-840 # 1128 <malloc+0x206>
     478:	00001097          	auipc	ra,0x1
     47c:	9f2080e7          	jalr	-1550(ra) # e6a <printf>
    exit(1);
     480:	4505                	li	a0,1
     482:	00000097          	auipc	ra,0x0
     486:	670080e7          	jalr	1648(ra) # af2 <exit>
     48a:	0087159b          	slliw	a1,a4,0x8
     48e:	0087571b          	srliw	a4,a4,0x8
     492:	8dd9                	or	a1,a1,a4
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
     494:	15c2                	slli	a1,a1,0x30
     496:	91c1                	srli	a1,a1,0x30
     498:	00001517          	auipc	a0,0x1
     49c:	ca850513          	addi	a0,a0,-856 # 1140 <malloc+0x21e>
     4a0:	00001097          	auipc	ra,0x1
     4a4:	9ca080e7          	jalr	-1590(ra) # e6a <printf>
    exit(1);
     4a8:	4505                	li	a0,1
     4aa:	00000097          	auipc	ra,0x0
     4ae:	648080e7          	jalr	1608(ra) # af2 <exit>
    printf("DNS rcode error: %x\n", hdr->rcode);
     4b2:	77fd                	lui	a5,0xfffff
     4b4:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <base+0xffffffffffffd7b3>
     4b8:	97a2                	add	a5,a5,s0
     4ba:	0007c583          	lbu	a1,0(a5)
     4be:	89bd                	andi	a1,a1,15
     4c0:	00001517          	auipc	a0,0x1
     4c4:	c9850513          	addi	a0,a0,-872 # 1158 <malloc+0x236>
     4c8:	00001097          	auipc	ra,0x1
     4cc:	9a2080e7          	jalr	-1630(ra) # e6a <printf>
    exit(1);
     4d0:	4505                	li	a0,1
     4d2:	00000097          	auipc	ra,0x0
     4d6:	620080e7          	jalr	1568(ra) # af2 <exit>
      printf("invalid DNS reply\n");
     4da:	00001517          	auipc	a0,0x1
     4de:	b3650513          	addi	a0,a0,-1226 # 1010 <malloc+0xee>
     4e2:	00001097          	auipc	ra,0x1
     4e6:	988080e7          	jalr	-1656(ra) # e6a <printf>
      exit(1);
     4ea:	4505                	li	a0,1
     4ec:	00000097          	auipc	ra,0x0
     4f0:	606080e7          	jalr	1542(ra) # af2 <exit>
      decode_qname(qn, cc - len);
     4f4:	409a05bb          	subw	a1,s4,s1
     4f8:	854e                	mv	a0,s3
     4fa:	00000097          	auipc	ra,0x0
     4fe:	b06080e7          	jalr	-1274(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
     502:	854e                	mv	a0,s3
     504:	00000097          	auipc	ra,0x0
     508:	3ca080e7          	jalr	970(ra) # 8ce <strlen>
     50c:	2485                	addiw	s1,s1,1
     50e:	9ca9                	addw	s1,s1,a0
     510:	a891                	j	564 <dns+0x3e8>
        printf("wrong ip address");
     512:	00001517          	auipc	a0,0x1
     516:	c8650513          	addi	a0,a0,-890 # 1198 <malloc+0x276>
     51a:	00001097          	auipc	ra,0x1
     51e:	950080e7          	jalr	-1712(ra) # e6a <printf>
        exit(1);
     522:	4505                	li	a0,1
     524:	00000097          	auipc	ra,0x0
     528:	5ce080e7          	jalr	1486(ra) # af2 <exit>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     52c:	2905                	addiw	s2,s2,1
     52e:	77fd                	lui	a5,0xfffff
     530:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <base+0xffffffffffffd7b6>
     534:	97a2                	add	a5,a5,s0
     536:	0007d783          	lhu	a5,0(a5)
     53a:	0087971b          	slliw	a4,a5,0x8
     53e:	83a1                	srli	a5,a5,0x8
     540:	8fd9                	or	a5,a5,a4
     542:	17c2                	slli	a5,a5,0x30
     544:	93c1                	srli	a5,a5,0x30
     546:	0cf95063          	bge	s2,a5,606 <dns+0x48a>
    if(len >= cc){
     54a:	f944d8e3          	bge	s1,s4,4da <dns+0x35e>
    char *qn = (char *) (ibuf+len);
     54e:	77fd                	lui	a5,0xfffff
     550:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     554:	97a2                	add	a5,a5,s0
     556:	009789b3          	add	s3,a5,s1
    if((int) qn[0] > 63) {  // compression?
     55a:	0009c783          	lbu	a5,0(s3)
     55e:	f8fb7be3          	bgeu	s6,a5,4f4 <dns+0x378>
      len += 2;
     562:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     564:	77fd                	lui	a5,0xfffff
     566:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     56a:	97a2                	add	a5,a5,s0
     56c:	00978733          	add	a4,a5,s1
    len += sizeof(struct dns_data);
     570:	0004899b          	sext.w	s3,s1
     574:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     576:	00074683          	lbu	a3,0(a4)
     57a:	00174783          	lbu	a5,1(a4)
     57e:	07a2                	slli	a5,a5,0x8
     580:	8fd5                	or	a5,a5,a3
     582:	fb5795e3          	bne	a5,s5,52c <dns+0x3b0>
     586:	00874683          	lbu	a3,8(a4)
     58a:	00974783          	lbu	a5,9(a4)
     58e:	07a2                	slli	a5,a5,0x8
     590:	8fd5                	or	a5,a5,a3
     592:	f9779de3          	bne	a5,s7,52c <dns+0x3b0>
      printf("DNS arecord for %s is ", qname ? qname : "" );
     596:	77fd                	lui	a5,0xfffff
     598:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <base+0xffffffffffffd7a8>
     59c:	97a2                	add	a5,a5,s0
     59e:	638c                	ld	a1,0(a5)
     5a0:	00001517          	auipc	a0,0x1
     5a4:	bd050513          	addi	a0,a0,-1072 # 1170 <malloc+0x24e>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	8c2080e7          	jalr	-1854(ra) # e6a <printf>
      uint8 *ip = (ibuf+len);
     5b0:	77fd                	lui	a5,0xfffff
     5b2:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     5b6:	97a2                	add	a5,a5,s0
     5b8:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     5ba:	0034c703          	lbu	a4,3(s1)
     5be:	0024c683          	lbu	a3,2(s1)
     5c2:	0014c603          	lbu	a2,1(s1)
     5c6:	0004c583          	lbu	a1,0(s1)
     5ca:	8566                	mv	a0,s9
     5cc:	00001097          	auipc	ra,0x1
     5d0:	89e080e7          	jalr	-1890(ra) # e6a <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     5d4:	0004c783          	lbu	a5,0(s1)
     5d8:	f3b79de3          	bne	a5,s11,512 <dns+0x396>
     5dc:	0014c783          	lbu	a5,1(s1)
     5e0:	f3a799e3          	bne	a5,s10,512 <dns+0x396>
     5e4:	0024c703          	lbu	a4,2(s1)
     5e8:	08100793          	li	a5,129
     5ec:	f2f713e3          	bne	a4,a5,512 <dns+0x396>
     5f0:	0034c703          	lbu	a4,3(s1)
     5f4:	07e00793          	li	a5,126
     5f8:	f0f71de3          	bne	a4,a5,512 <dns+0x396>
      len += 4;
     5fc:	00e9849b          	addiw	s1,s3,14
      record = 1;
     600:	4c05                	li	s8,1
     602:	b72d                	j	52c <dns+0x3b0>
  int record = 0;
     604:	4c01                	li	s8,0
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     606:	77fd                	lui	a5,0xfffff
     608:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <base+0xffffffffffffd7ba>
     60c:	97a2                	add	a5,a5,s0
     60e:	0007d783          	lhu	a5,0(a5)
     612:	0087959b          	slliw	a1,a5,0x8
     616:	0087d71b          	srliw	a4,a5,0x8
     61a:	8dd9                	or	a1,a1,a4
     61c:	15c2                	slli	a1,a1,0x30
     61e:	91c1                	srli	a1,a1,0x30
     620:	cfa9                	beqz	a5,67a <dns+0x4fe>
     622:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
     624:	650d                	lui	a0,0x3
     626:	90050513          	addi	a0,a0,-1792 # 2900 <base+0x8f0>
    if(*qn != 0) {
     62a:	f9048793          	addi	a5,s1,-112
     62e:	97a2                	add	a5,a5,s0
     630:	8307c783          	lbu	a5,-2000(a5)
     634:	e3c9                	bnez	a5,6b6 <dns+0x53a>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     636:	0014879b          	addiw	a5,s1,1
     63a:	777d                	lui	a4,0xfffff
     63c:	7c070713          	addi	a4,a4,1984 # fffffffffffff7c0 <base+0xffffffffffffd7b0>
     640:	9722                	add	a4,a4,s0
     642:	97ba                	add	a5,a5,a4
    len += sizeof(struct dns_data);
     644:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
     646:	0007c603          	lbu	a2,0(a5)
     64a:	0017c703          	lbu	a4,1(a5)
     64e:	0722                	slli	a4,a4,0x8
     650:	8f51                	or	a4,a4,a2
     652:	06a71f63          	bne	a4,a0,6d0 <dns+0x554>
    len += ntohs(d->len);
     656:	0087c703          	lbu	a4,8(a5)
     65a:	0097c783          	lbu	a5,9(a5)
     65e:	07a2                	slli	a5,a5,0x8
     660:	8fd9                	or	a5,a5,a4
     662:	0087971b          	slliw	a4,a5,0x8
     666:	83a1                	srli	a5,a5,0x8
     668:	8fd9                	or	a5,a5,a4
     66a:	0107979b          	slliw	a5,a5,0x10
     66e:	0107d79b          	srliw	a5,a5,0x10
     672:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     674:	2685                	addiw	a3,a3,1
     676:	fab6cae3          	blt	a3,a1,62a <dns+0x4ae>
  if(len != cc) {
     67a:	069a1863          	bne	s4,s1,6ea <dns+0x56e>
  if(!record) {
     67e:	080c0563          	beqz	s8,708 <dns+0x58c>
  }
  dns_rep(ibuf, cc);

  close(fd);
     682:	77fd                	lui	a5,0xfffff
     684:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <base+0xffffffffffffd7a0>
     688:	97a2                	add	a5,a5,s0
     68a:	6388                	ld	a0,0(a5)
     68c:	00000097          	auipc	ra,0x0
     690:	48e080e7          	jalr	1166(ra) # b1a <close>
}  
     694:	7d010113          	addi	sp,sp,2000
     698:	70e6                	ld	ra,120(sp)
     69a:	7446                	ld	s0,112(sp)
     69c:	74a6                	ld	s1,104(sp)
     69e:	7906                	ld	s2,96(sp)
     6a0:	69e6                	ld	s3,88(sp)
     6a2:	6a46                	ld	s4,80(sp)
     6a4:	6aa6                	ld	s5,72(sp)
     6a6:	6b06                	ld	s6,64(sp)
     6a8:	7be2                	ld	s7,56(sp)
     6aa:	7c42                	ld	s8,48(sp)
     6ac:	7ca2                	ld	s9,40(sp)
     6ae:	7d02                	ld	s10,32(sp)
     6b0:	6de2                	ld	s11,24(sp)
     6b2:	6109                	addi	sp,sp,128
     6b4:	8082                	ret
      printf("invalid name for EDNS\n");
     6b6:	00001517          	auipc	a0,0x1
     6ba:	afa50513          	addi	a0,a0,-1286 # 11b0 <malloc+0x28e>
     6be:	00000097          	auipc	ra,0x0
     6c2:	7ac080e7          	jalr	1964(ra) # e6a <printf>
      exit(1);
     6c6:	4505                	li	a0,1
     6c8:	00000097          	auipc	ra,0x0
     6cc:	42a080e7          	jalr	1066(ra) # af2 <exit>
      printf("invalid type for EDNS\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	af850513          	addi	a0,a0,-1288 # 11c8 <malloc+0x2a6>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	792080e7          	jalr	1938(ra) # e6a <printf>
      exit(1);
     6e0:	4505                	li	a0,1
     6e2:	00000097          	auipc	ra,0x0
     6e6:	410080e7          	jalr	1040(ra) # af2 <exit>
    printf("Processed %d data bytes but received %d\n", len, cc);
     6ea:	8652                	mv	a2,s4
     6ec:	85a6                	mv	a1,s1
     6ee:	00001517          	auipc	a0,0x1
     6f2:	af250513          	addi	a0,a0,-1294 # 11e0 <malloc+0x2be>
     6f6:	00000097          	auipc	ra,0x0
     6fa:	774080e7          	jalr	1908(ra) # e6a <printf>
    exit(1);
     6fe:	4505                	li	a0,1
     700:	00000097          	auipc	ra,0x0
     704:	3f2080e7          	jalr	1010(ra) # af2 <exit>
    printf("Didn't receive an arecord\n");
     708:	00001517          	auipc	a0,0x1
     70c:	b0850513          	addi	a0,a0,-1272 # 1210 <malloc+0x2ee>
     710:	00000097          	auipc	ra,0x0
     714:	75a080e7          	jalr	1882(ra) # e6a <printf>
    exit(1);
     718:	4505                	li	a0,1
     71a:	00000097          	auipc	ra,0x0
     71e:	3d8080e7          	jalr	984(ra) # af2 <exit>

0000000000000722 <main>:

int
main(int argc, char *argv[])
{
     722:	7179                	addi	sp,sp,-48
     724:	f406                	sd	ra,40(sp)
     726:	f022                	sd	s0,32(sp)
     728:	ec26                	sd	s1,24(sp)
     72a:	e84a                	sd	s2,16(sp)
     72c:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
     72e:	6499                	lui	s1,0x6
     730:	5f348593          	addi	a1,s1,1523 # 65f3 <base+0x45e3>
     734:	00001517          	auipc	a0,0x1
     738:	afc50513          	addi	a0,a0,-1284 # 1230 <malloc+0x30e>
     73c:	00000097          	auipc	ra,0x0
     740:	72e080e7          	jalr	1838(ra) # e6a <printf>
  
  printf("testing ping: ");
     744:	00001517          	auipc	a0,0x1
     748:	b0c50513          	addi	a0,a0,-1268 # 1250 <malloc+0x32e>
     74c:	00000097          	auipc	ra,0x0
     750:	71e080e7          	jalr	1822(ra) # e6a <printf>
  ping(2000, dport, 1);
     754:	4605                	li	a2,1
     756:	5f348593          	addi	a1,s1,1523
     75a:	7d000513          	li	a0,2000
     75e:	00000097          	auipc	ra,0x0
     762:	8fc080e7          	jalr	-1796(ra) # 5a <ping>
  printf("OK\n");
     766:	00001517          	auipc	a0,0x1
     76a:	afa50513          	addi	a0,a0,-1286 # 1260 <malloc+0x33e>
     76e:	00000097          	auipc	ra,0x0
     772:	6fc080e7          	jalr	1788(ra) # e6a <printf>
  
  printf("testing single-process pings: ");
     776:	00001517          	auipc	a0,0x1
     77a:	af250513          	addi	a0,a0,-1294 # 1268 <malloc+0x346>
     77e:	00000097          	auipc	ra,0x0
     782:	6ec080e7          	jalr	1772(ra) # e6a <printf>
     786:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
     78a:	6919                	lui	s2,0x6
     78c:	5f390913          	addi	s2,s2,1523 # 65f3 <base+0x45e3>
     790:	4605                	li	a2,1
     792:	85ca                	mv	a1,s2
     794:	7d000513          	li	a0,2000
     798:	00000097          	auipc	ra,0x0
     79c:	8c2080e7          	jalr	-1854(ra) # 5a <ping>
  for (i = 0; i < 100; i++)
     7a0:	34fd                	addiw	s1,s1,-1
     7a2:	f4fd                	bnez	s1,790 <main+0x6e>
  printf("OK\n");
     7a4:	00001517          	auipc	a0,0x1
     7a8:	abc50513          	addi	a0,a0,-1348 # 1260 <malloc+0x33e>
     7ac:	00000097          	auipc	ra,0x0
     7b0:	6be080e7          	jalr	1726(ra) # e6a <printf>
  
  printf("testing multi-process pings: ");
     7b4:	00001517          	auipc	a0,0x1
     7b8:	ad450513          	addi	a0,a0,-1324 # 1288 <malloc+0x366>
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6ae080e7          	jalr	1710(ra) # e6a <printf>
  for (i = 0; i < 10; i++){
     7c4:	4929                	li	s2,10
    int pid = fork();
     7c6:	00000097          	auipc	ra,0x0
     7ca:	324080e7          	jalr	804(ra) # aea <fork>
    if (pid == 0){
     7ce:	c92d                	beqz	a0,840 <main+0x11e>
  for (i = 0; i < 10; i++){
     7d0:	2485                	addiw	s1,s1,1
     7d2:	ff249ae3          	bne	s1,s2,7c6 <main+0xa4>
     7d6:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
     7d8:	fdc40513          	addi	a0,s0,-36
     7dc:	00000097          	auipc	ra,0x0
     7e0:	31e080e7          	jalr	798(ra) # afa <wait>
    if (ret != 0)
     7e4:	fdc42783          	lw	a5,-36(s0)
     7e8:	efad                	bnez	a5,862 <main+0x140>
  for (i = 0; i < 10; i++){
     7ea:	34fd                	addiw	s1,s1,-1
     7ec:	f4f5                	bnez	s1,7d8 <main+0xb6>
      exit(1);
  }
  printf("OK\n");
     7ee:	00001517          	auipc	a0,0x1
     7f2:	a7250513          	addi	a0,a0,-1422 # 1260 <malloc+0x33e>
     7f6:	00000097          	auipc	ra,0x0
     7fa:	674080e7          	jalr	1652(ra) # e6a <printf>
  
  printf("testing DNS\n");
     7fe:	00001517          	auipc	a0,0x1
     802:	aaa50513          	addi	a0,a0,-1366 # 12a8 <malloc+0x386>
     806:	00000097          	auipc	ra,0x0
     80a:	664080e7          	jalr	1636(ra) # e6a <printf>
  dns();
     80e:	00000097          	auipc	ra,0x0
     812:	96e080e7          	jalr	-1682(ra) # 17c <dns>
  printf("DNS OK\n");
     816:	00001517          	auipc	a0,0x1
     81a:	aa250513          	addi	a0,a0,-1374 # 12b8 <malloc+0x396>
     81e:	00000097          	auipc	ra,0x0
     822:	64c080e7          	jalr	1612(ra) # e6a <printf>
  
  printf("all tests passed.\n");
     826:	00001517          	auipc	a0,0x1
     82a:	a9a50513          	addi	a0,a0,-1382 # 12c0 <malloc+0x39e>
     82e:	00000097          	auipc	ra,0x0
     832:	63c080e7          	jalr	1596(ra) # e6a <printf>
  exit(0);
     836:	4501                	li	a0,0
     838:	00000097          	auipc	ra,0x0
     83c:	2ba080e7          	jalr	698(ra) # af2 <exit>
      ping(2000 + i + 1, dport, 1);
     840:	7d14851b          	addiw	a0,s1,2001
     844:	4605                	li	a2,1
     846:	6599                	lui	a1,0x6
     848:	5f358593          	addi	a1,a1,1523 # 65f3 <base+0x45e3>
     84c:	1542                	slli	a0,a0,0x30
     84e:	9141                	srli	a0,a0,0x30
     850:	00000097          	auipc	ra,0x0
     854:	80a080e7          	jalr	-2038(ra) # 5a <ping>
      exit(0);
     858:	4501                	li	a0,0
     85a:	00000097          	auipc	ra,0x0
     85e:	298080e7          	jalr	664(ra) # af2 <exit>
      exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	28e080e7          	jalr	654(ra) # af2 <exit>

000000000000086c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     86c:	1141                	addi	sp,sp,-16
     86e:	e406                	sd	ra,8(sp)
     870:	e022                	sd	s0,0(sp)
     872:	0800                	addi	s0,sp,16
  extern int main();
  main();
     874:	00000097          	auipc	ra,0x0
     878:	eae080e7          	jalr	-338(ra) # 722 <main>
  exit(0);
     87c:	4501                	li	a0,0
     87e:	00000097          	auipc	ra,0x0
     882:	274080e7          	jalr	628(ra) # af2 <exit>

0000000000000886 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     886:	1141                	addi	sp,sp,-16
     888:	e422                	sd	s0,8(sp)
     88a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     88c:	87aa                	mv	a5,a0
     88e:	0585                	addi	a1,a1,1
     890:	0785                	addi	a5,a5,1
     892:	fff5c703          	lbu	a4,-1(a1)
     896:	fee78fa3          	sb	a4,-1(a5)
     89a:	fb75                	bnez	a4,88e <strcpy+0x8>
    ;
  return os;
}
     89c:	6422                	ld	s0,8(sp)
     89e:	0141                	addi	sp,sp,16
     8a0:	8082                	ret

00000000000008a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8a2:	1141                	addi	sp,sp,-16
     8a4:	e422                	sd	s0,8(sp)
     8a6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8a8:	00054783          	lbu	a5,0(a0)
     8ac:	cb91                	beqz	a5,8c0 <strcmp+0x1e>
     8ae:	0005c703          	lbu	a4,0(a1)
     8b2:	00f71763          	bne	a4,a5,8c0 <strcmp+0x1e>
    p++, q++;
     8b6:	0505                	addi	a0,a0,1
     8b8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8ba:	00054783          	lbu	a5,0(a0)
     8be:	fbe5                	bnez	a5,8ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     8c0:	0005c503          	lbu	a0,0(a1)
}
     8c4:	40a7853b          	subw	a0,a5,a0
     8c8:	6422                	ld	s0,8(sp)
     8ca:	0141                	addi	sp,sp,16
     8cc:	8082                	ret

00000000000008ce <strlen>:

uint
strlen(const char *s)
{
     8ce:	1141                	addi	sp,sp,-16
     8d0:	e422                	sd	s0,8(sp)
     8d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8d4:	00054783          	lbu	a5,0(a0)
     8d8:	cf91                	beqz	a5,8f4 <strlen+0x26>
     8da:	0505                	addi	a0,a0,1
     8dc:	87aa                	mv	a5,a0
     8de:	86be                	mv	a3,a5
     8e0:	0785                	addi	a5,a5,1
     8e2:	fff7c703          	lbu	a4,-1(a5)
     8e6:	ff65                	bnez	a4,8de <strlen+0x10>
     8e8:	40a6853b          	subw	a0,a3,a0
     8ec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     8ee:	6422                	ld	s0,8(sp)
     8f0:	0141                	addi	sp,sp,16
     8f2:	8082                	ret
  for(n = 0; s[n]; n++)
     8f4:	4501                	li	a0,0
     8f6:	bfe5                	j	8ee <strlen+0x20>

00000000000008f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
     8f8:	1141                	addi	sp,sp,-16
     8fa:	e422                	sd	s0,8(sp)
     8fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     8fe:	ca19                	beqz	a2,914 <memset+0x1c>
     900:	87aa                	mv	a5,a0
     902:	1602                	slli	a2,a2,0x20
     904:	9201                	srli	a2,a2,0x20
     906:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     90a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     90e:	0785                	addi	a5,a5,1
     910:	fee79de3          	bne	a5,a4,90a <memset+0x12>
  }
  return dst;
}
     914:	6422                	ld	s0,8(sp)
     916:	0141                	addi	sp,sp,16
     918:	8082                	ret

000000000000091a <strchr>:

char*
strchr(const char *s, char c)
{
     91a:	1141                	addi	sp,sp,-16
     91c:	e422                	sd	s0,8(sp)
     91e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     920:	00054783          	lbu	a5,0(a0)
     924:	cb99                	beqz	a5,93a <strchr+0x20>
    if(*s == c)
     926:	00f58763          	beq	a1,a5,934 <strchr+0x1a>
  for(; *s; s++)
     92a:	0505                	addi	a0,a0,1
     92c:	00054783          	lbu	a5,0(a0)
     930:	fbfd                	bnez	a5,926 <strchr+0xc>
      return (char*)s;
  return 0;
     932:	4501                	li	a0,0
}
     934:	6422                	ld	s0,8(sp)
     936:	0141                	addi	sp,sp,16
     938:	8082                	ret
  return 0;
     93a:	4501                	li	a0,0
     93c:	bfe5                	j	934 <strchr+0x1a>

000000000000093e <gets>:

char*
gets(char *buf, int max)
{
     93e:	711d                	addi	sp,sp,-96
     940:	ec86                	sd	ra,88(sp)
     942:	e8a2                	sd	s0,80(sp)
     944:	e4a6                	sd	s1,72(sp)
     946:	e0ca                	sd	s2,64(sp)
     948:	fc4e                	sd	s3,56(sp)
     94a:	f852                	sd	s4,48(sp)
     94c:	f456                	sd	s5,40(sp)
     94e:	f05a                	sd	s6,32(sp)
     950:	ec5e                	sd	s7,24(sp)
     952:	1080                	addi	s0,sp,96
     954:	8baa                	mv	s7,a0
     956:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     958:	892a                	mv	s2,a0
     95a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     95c:	4aa9                	li	s5,10
     95e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     960:	89a6                	mv	s3,s1
     962:	2485                	addiw	s1,s1,1
     964:	0344d863          	bge	s1,s4,994 <gets+0x56>
    cc = read(0, &c, 1);
     968:	4605                	li	a2,1
     96a:	faf40593          	addi	a1,s0,-81
     96e:	4501                	li	a0,0
     970:	00000097          	auipc	ra,0x0
     974:	19a080e7          	jalr	410(ra) # b0a <read>
    if(cc < 1)
     978:	00a05e63          	blez	a0,994 <gets+0x56>
    buf[i++] = c;
     97c:	faf44783          	lbu	a5,-81(s0)
     980:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     984:	01578763          	beq	a5,s5,992 <gets+0x54>
     988:	0905                	addi	s2,s2,1
     98a:	fd679be3          	bne	a5,s6,960 <gets+0x22>
  for(i=0; i+1 < max; ){
     98e:	89a6                	mv	s3,s1
     990:	a011                	j	994 <gets+0x56>
     992:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     994:	99de                	add	s3,s3,s7
     996:	00098023          	sb	zero,0(s3)
  return buf;
}
     99a:	855e                	mv	a0,s7
     99c:	60e6                	ld	ra,88(sp)
     99e:	6446                	ld	s0,80(sp)
     9a0:	64a6                	ld	s1,72(sp)
     9a2:	6906                	ld	s2,64(sp)
     9a4:	79e2                	ld	s3,56(sp)
     9a6:	7a42                	ld	s4,48(sp)
     9a8:	7aa2                	ld	s5,40(sp)
     9aa:	7b02                	ld	s6,32(sp)
     9ac:	6be2                	ld	s7,24(sp)
     9ae:	6125                	addi	sp,sp,96
     9b0:	8082                	ret

00000000000009b2 <stat>:

int
stat(const char *n, struct stat *st)
{
     9b2:	1101                	addi	sp,sp,-32
     9b4:	ec06                	sd	ra,24(sp)
     9b6:	e822                	sd	s0,16(sp)
     9b8:	e426                	sd	s1,8(sp)
     9ba:	e04a                	sd	s2,0(sp)
     9bc:	1000                	addi	s0,sp,32
     9be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9c0:	4581                	li	a1,0
     9c2:	00000097          	auipc	ra,0x0
     9c6:	170080e7          	jalr	368(ra) # b32 <open>
  if(fd < 0)
     9ca:	02054563          	bltz	a0,9f4 <stat+0x42>
     9ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9d0:	85ca                	mv	a1,s2
     9d2:	00000097          	auipc	ra,0x0
     9d6:	178080e7          	jalr	376(ra) # b4a <fstat>
     9da:	892a                	mv	s2,a0
  close(fd);
     9dc:	8526                	mv	a0,s1
     9de:	00000097          	auipc	ra,0x0
     9e2:	13c080e7          	jalr	316(ra) # b1a <close>
  return r;
}
     9e6:	854a                	mv	a0,s2
     9e8:	60e2                	ld	ra,24(sp)
     9ea:	6442                	ld	s0,16(sp)
     9ec:	64a2                	ld	s1,8(sp)
     9ee:	6902                	ld	s2,0(sp)
     9f0:	6105                	addi	sp,sp,32
     9f2:	8082                	ret
    return -1;
     9f4:	597d                	li	s2,-1
     9f6:	bfc5                	j	9e6 <stat+0x34>

00000000000009f8 <atoi>:

int
atoi(const char *s)
{
     9f8:	1141                	addi	sp,sp,-16
     9fa:	e422                	sd	s0,8(sp)
     9fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     9fe:	00054683          	lbu	a3,0(a0)
     a02:	fd06879b          	addiw	a5,a3,-48
     a06:	0ff7f793          	zext.b	a5,a5
     a0a:	4625                	li	a2,9
     a0c:	02f66863          	bltu	a2,a5,a3c <atoi+0x44>
     a10:	872a                	mv	a4,a0
  n = 0;
     a12:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a14:	0705                	addi	a4,a4,1
     a16:	0025179b          	slliw	a5,a0,0x2
     a1a:	9fa9                	addw	a5,a5,a0
     a1c:	0017979b          	slliw	a5,a5,0x1
     a20:	9fb5                	addw	a5,a5,a3
     a22:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a26:	00074683          	lbu	a3,0(a4)
     a2a:	fd06879b          	addiw	a5,a3,-48
     a2e:	0ff7f793          	zext.b	a5,a5
     a32:	fef671e3          	bgeu	a2,a5,a14 <atoi+0x1c>
  return n;
}
     a36:	6422                	ld	s0,8(sp)
     a38:	0141                	addi	sp,sp,16
     a3a:	8082                	ret
  n = 0;
     a3c:	4501                	li	a0,0
     a3e:	bfe5                	j	a36 <atoi+0x3e>

0000000000000a40 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a40:	1141                	addi	sp,sp,-16
     a42:	e422                	sd	s0,8(sp)
     a44:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a46:	02b57463          	bgeu	a0,a1,a6e <memmove+0x2e>
    while(n-- > 0)
     a4a:	00c05f63          	blez	a2,a68 <memmove+0x28>
     a4e:	1602                	slli	a2,a2,0x20
     a50:	9201                	srli	a2,a2,0x20
     a52:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a56:	872a                	mv	a4,a0
      *dst++ = *src++;
     a58:	0585                	addi	a1,a1,1
     a5a:	0705                	addi	a4,a4,1
     a5c:	fff5c683          	lbu	a3,-1(a1)
     a60:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a64:	fee79ae3          	bne	a5,a4,a58 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a68:	6422                	ld	s0,8(sp)
     a6a:	0141                	addi	sp,sp,16
     a6c:	8082                	ret
    dst += n;
     a6e:	00c50733          	add	a4,a0,a2
    src += n;
     a72:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     a74:	fec05ae3          	blez	a2,a68 <memmove+0x28>
     a78:	fff6079b          	addiw	a5,a2,-1
     a7c:	1782                	slli	a5,a5,0x20
     a7e:	9381                	srli	a5,a5,0x20
     a80:	fff7c793          	not	a5,a5
     a84:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     a86:	15fd                	addi	a1,a1,-1
     a88:	177d                	addi	a4,a4,-1
     a8a:	0005c683          	lbu	a3,0(a1)
     a8e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     a92:	fee79ae3          	bne	a5,a4,a86 <memmove+0x46>
     a96:	bfc9                	j	a68 <memmove+0x28>

0000000000000a98 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     a98:	1141                	addi	sp,sp,-16
     a9a:	e422                	sd	s0,8(sp)
     a9c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     a9e:	ca05                	beqz	a2,ace <memcmp+0x36>
     aa0:	fff6069b          	addiw	a3,a2,-1
     aa4:	1682                	slli	a3,a3,0x20
     aa6:	9281                	srli	a3,a3,0x20
     aa8:	0685                	addi	a3,a3,1
     aaa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     aac:	00054783          	lbu	a5,0(a0)
     ab0:	0005c703          	lbu	a4,0(a1)
     ab4:	00e79863          	bne	a5,a4,ac4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     ab8:	0505                	addi	a0,a0,1
    p2++;
     aba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     abc:	fed518e3          	bne	a0,a3,aac <memcmp+0x14>
  }
  return 0;
     ac0:	4501                	li	a0,0
     ac2:	a019                	j	ac8 <memcmp+0x30>
      return *p1 - *p2;
     ac4:	40e7853b          	subw	a0,a5,a4
}
     ac8:	6422                	ld	s0,8(sp)
     aca:	0141                	addi	sp,sp,16
     acc:	8082                	ret
  return 0;
     ace:	4501                	li	a0,0
     ad0:	bfe5                	j	ac8 <memcmp+0x30>

0000000000000ad2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ad2:	1141                	addi	sp,sp,-16
     ad4:	e406                	sd	ra,8(sp)
     ad6:	e022                	sd	s0,0(sp)
     ad8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ada:	00000097          	auipc	ra,0x0
     ade:	f66080e7          	jalr	-154(ra) # a40 <memmove>
}
     ae2:	60a2                	ld	ra,8(sp)
     ae4:	6402                	ld	s0,0(sp)
     ae6:	0141                	addi	sp,sp,16
     ae8:	8082                	ret

0000000000000aea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     aea:	4885                	li	a7,1
 ecall
     aec:	00000073          	ecall
 ret
     af0:	8082                	ret

0000000000000af2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     af2:	4889                	li	a7,2
 ecall
     af4:	00000073          	ecall
 ret
     af8:	8082                	ret

0000000000000afa <wait>:
.global wait
wait:
 li a7, SYS_wait
     afa:	488d                	li	a7,3
 ecall
     afc:	00000073          	ecall
 ret
     b00:	8082                	ret

0000000000000b02 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b02:	4891                	li	a7,4
 ecall
     b04:	00000073          	ecall
 ret
     b08:	8082                	ret

0000000000000b0a <read>:
.global read
read:
 li a7, SYS_read
     b0a:	4895                	li	a7,5
 ecall
     b0c:	00000073          	ecall
 ret
     b10:	8082                	ret

0000000000000b12 <write>:
.global write
write:
 li a7, SYS_write
     b12:	48c1                	li	a7,16
 ecall
     b14:	00000073          	ecall
 ret
     b18:	8082                	ret

0000000000000b1a <close>:
.global close
close:
 li a7, SYS_close
     b1a:	48d5                	li	a7,21
 ecall
     b1c:	00000073          	ecall
 ret
     b20:	8082                	ret

0000000000000b22 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b22:	4899                	li	a7,6
 ecall
     b24:	00000073          	ecall
 ret
     b28:	8082                	ret

0000000000000b2a <exec>:
.global exec
exec:
 li a7, SYS_exec
     b2a:	489d                	li	a7,7
 ecall
     b2c:	00000073          	ecall
 ret
     b30:	8082                	ret

0000000000000b32 <open>:
.global open
open:
 li a7, SYS_open
     b32:	48bd                	li	a7,15
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b3a:	48c5                	li	a7,17
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b42:	48c9                	li	a7,18
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b4a:	48a1                	li	a7,8
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <link>:
.global link
link:
 li a7, SYS_link
     b52:	48cd                	li	a7,19
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b5a:	48d1                	li	a7,20
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b62:	48a5                	li	a7,9
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <dup>:
.global dup
dup:
 li a7, SYS_dup
     b6a:	48a9                	li	a7,10
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b72:	48ad                	li	a7,11
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b7a:	48b1                	li	a7,12
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b82:	48b5                	li	a7,13
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b8a:	48b9                	li	a7,14
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <connect>:
.global connect
connect:
 li a7, SYS_connect
     b92:	48f5                	li	a7,29
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     b9a:	48f9                	li	a7,30
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ba2:	1101                	addi	sp,sp,-32
     ba4:	ec06                	sd	ra,24(sp)
     ba6:	e822                	sd	s0,16(sp)
     ba8:	1000                	addi	s0,sp,32
     baa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bae:	4605                	li	a2,1
     bb0:	fef40593          	addi	a1,s0,-17
     bb4:	00000097          	auipc	ra,0x0
     bb8:	f5e080e7          	jalr	-162(ra) # b12 <write>
}
     bbc:	60e2                	ld	ra,24(sp)
     bbe:	6442                	ld	s0,16(sp)
     bc0:	6105                	addi	sp,sp,32
     bc2:	8082                	ret

0000000000000bc4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bc4:	7139                	addi	sp,sp,-64
     bc6:	fc06                	sd	ra,56(sp)
     bc8:	f822                	sd	s0,48(sp)
     bca:	f426                	sd	s1,40(sp)
     bcc:	f04a                	sd	s2,32(sp)
     bce:	ec4e                	sd	s3,24(sp)
     bd0:	0080                	addi	s0,sp,64
     bd2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bd4:	c299                	beqz	a3,bda <printint+0x16>
     bd6:	0805c963          	bltz	a1,c68 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     bda:	2581                	sext.w	a1,a1
  neg = 0;
     bdc:	4881                	li	a7,0
     bde:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     be2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     be4:	2601                	sext.w	a2,a2
     be6:	00000517          	auipc	a0,0x0
     bea:	75250513          	addi	a0,a0,1874 # 1338 <digits>
     bee:	883a                	mv	a6,a4
     bf0:	2705                	addiw	a4,a4,1
     bf2:	02c5f7bb          	remuw	a5,a1,a2
     bf6:	1782                	slli	a5,a5,0x20
     bf8:	9381                	srli	a5,a5,0x20
     bfa:	97aa                	add	a5,a5,a0
     bfc:	0007c783          	lbu	a5,0(a5)
     c00:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c04:	0005879b          	sext.w	a5,a1
     c08:	02c5d5bb          	divuw	a1,a1,a2
     c0c:	0685                	addi	a3,a3,1
     c0e:	fec7f0e3          	bgeu	a5,a2,bee <printint+0x2a>
  if(neg)
     c12:	00088c63          	beqz	a7,c2a <printint+0x66>
    buf[i++] = '-';
     c16:	fd070793          	addi	a5,a4,-48
     c1a:	00878733          	add	a4,a5,s0
     c1e:	02d00793          	li	a5,45
     c22:	fef70823          	sb	a5,-16(a4)
     c26:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c2a:	02e05863          	blez	a4,c5a <printint+0x96>
     c2e:	fc040793          	addi	a5,s0,-64
     c32:	00e78933          	add	s2,a5,a4
     c36:	fff78993          	addi	s3,a5,-1
     c3a:	99ba                	add	s3,s3,a4
     c3c:	377d                	addiw	a4,a4,-1
     c3e:	1702                	slli	a4,a4,0x20
     c40:	9301                	srli	a4,a4,0x20
     c42:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c46:	fff94583          	lbu	a1,-1(s2)
     c4a:	8526                	mv	a0,s1
     c4c:	00000097          	auipc	ra,0x0
     c50:	f56080e7          	jalr	-170(ra) # ba2 <putc>
  while(--i >= 0)
     c54:	197d                	addi	s2,s2,-1
     c56:	ff3918e3          	bne	s2,s3,c46 <printint+0x82>
}
     c5a:	70e2                	ld	ra,56(sp)
     c5c:	7442                	ld	s0,48(sp)
     c5e:	74a2                	ld	s1,40(sp)
     c60:	7902                	ld	s2,32(sp)
     c62:	69e2                	ld	s3,24(sp)
     c64:	6121                	addi	sp,sp,64
     c66:	8082                	ret
    x = -xx;
     c68:	40b005bb          	negw	a1,a1
    neg = 1;
     c6c:	4885                	li	a7,1
    x = -xx;
     c6e:	bf85                	j	bde <printint+0x1a>

0000000000000c70 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c70:	715d                	addi	sp,sp,-80
     c72:	e486                	sd	ra,72(sp)
     c74:	e0a2                	sd	s0,64(sp)
     c76:	fc26                	sd	s1,56(sp)
     c78:	f84a                	sd	s2,48(sp)
     c7a:	f44e                	sd	s3,40(sp)
     c7c:	f052                	sd	s4,32(sp)
     c7e:	ec56                	sd	s5,24(sp)
     c80:	e85a                	sd	s6,16(sp)
     c82:	e45e                	sd	s7,8(sp)
     c84:	e062                	sd	s8,0(sp)
     c86:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c88:	0005c903          	lbu	s2,0(a1)
     c8c:	18090c63          	beqz	s2,e24 <vprintf+0x1b4>
     c90:	8aaa                	mv	s5,a0
     c92:	8bb2                	mv	s7,a2
     c94:	00158493          	addi	s1,a1,1
  state = 0;
     c98:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     c9a:	02500a13          	li	s4,37
     c9e:	4b55                	li	s6,21
     ca0:	a839                	j	cbe <vprintf+0x4e>
        putc(fd, c);
     ca2:	85ca                	mv	a1,s2
     ca4:	8556                	mv	a0,s5
     ca6:	00000097          	auipc	ra,0x0
     caa:	efc080e7          	jalr	-260(ra) # ba2 <putc>
     cae:	a019                	j	cb4 <vprintf+0x44>
    } else if(state == '%'){
     cb0:	01498d63          	beq	s3,s4,cca <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
     cb4:	0485                	addi	s1,s1,1
     cb6:	fff4c903          	lbu	s2,-1(s1)
     cba:	16090563          	beqz	s2,e24 <vprintf+0x1b4>
    if(state == 0){
     cbe:	fe0999e3          	bnez	s3,cb0 <vprintf+0x40>
      if(c == '%'){
     cc2:	ff4910e3          	bne	s2,s4,ca2 <vprintf+0x32>
        state = '%';
     cc6:	89d2                	mv	s3,s4
     cc8:	b7f5                	j	cb4 <vprintf+0x44>
      if(c == 'd'){
     cca:	13490263          	beq	s2,s4,dee <vprintf+0x17e>
     cce:	f9d9079b          	addiw	a5,s2,-99
     cd2:	0ff7f793          	zext.b	a5,a5
     cd6:	12fb6563          	bltu	s6,a5,e00 <vprintf+0x190>
     cda:	f9d9079b          	addiw	a5,s2,-99
     cde:	0ff7f713          	zext.b	a4,a5
     ce2:	10eb6f63          	bltu	s6,a4,e00 <vprintf+0x190>
     ce6:	00271793          	slli	a5,a4,0x2
     cea:	00000717          	auipc	a4,0x0
     cee:	5f670713          	addi	a4,a4,1526 # 12e0 <malloc+0x3be>
     cf2:	97ba                	add	a5,a5,a4
     cf4:	439c                	lw	a5,0(a5)
     cf6:	97ba                	add	a5,a5,a4
     cf8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     cfa:	008b8913          	addi	s2,s7,8
     cfe:	4685                	li	a3,1
     d00:	4629                	li	a2,10
     d02:	000ba583          	lw	a1,0(s7)
     d06:	8556                	mv	a0,s5
     d08:	00000097          	auipc	ra,0x0
     d0c:	ebc080e7          	jalr	-324(ra) # bc4 <printint>
     d10:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d12:	4981                	li	s3,0
     d14:	b745                	j	cb4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d16:	008b8913          	addi	s2,s7,8
     d1a:	4681                	li	a3,0
     d1c:	4629                	li	a2,10
     d1e:	000ba583          	lw	a1,0(s7)
     d22:	8556                	mv	a0,s5
     d24:	00000097          	auipc	ra,0x0
     d28:	ea0080e7          	jalr	-352(ra) # bc4 <printint>
     d2c:	8bca                	mv	s7,s2
      state = 0;
     d2e:	4981                	li	s3,0
     d30:	b751                	j	cb4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
     d32:	008b8913          	addi	s2,s7,8
     d36:	4681                	li	a3,0
     d38:	4641                	li	a2,16
     d3a:	000ba583          	lw	a1,0(s7)
     d3e:	8556                	mv	a0,s5
     d40:	00000097          	auipc	ra,0x0
     d44:	e84080e7          	jalr	-380(ra) # bc4 <printint>
     d48:	8bca                	mv	s7,s2
      state = 0;
     d4a:	4981                	li	s3,0
     d4c:	b7a5                	j	cb4 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
     d4e:	008b8c13          	addi	s8,s7,8
     d52:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d56:	03000593          	li	a1,48
     d5a:	8556                	mv	a0,s5
     d5c:	00000097          	auipc	ra,0x0
     d60:	e46080e7          	jalr	-442(ra) # ba2 <putc>
  putc(fd, 'x');
     d64:	07800593          	li	a1,120
     d68:	8556                	mv	a0,s5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	e38080e7          	jalr	-456(ra) # ba2 <putc>
     d72:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d74:	00000b97          	auipc	s7,0x0
     d78:	5c4b8b93          	addi	s7,s7,1476 # 1338 <digits>
     d7c:	03c9d793          	srli	a5,s3,0x3c
     d80:	97de                	add	a5,a5,s7
     d82:	0007c583          	lbu	a1,0(a5)
     d86:	8556                	mv	a0,s5
     d88:	00000097          	auipc	ra,0x0
     d8c:	e1a080e7          	jalr	-486(ra) # ba2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d90:	0992                	slli	s3,s3,0x4
     d92:	397d                	addiw	s2,s2,-1
     d94:	fe0914e3          	bnez	s2,d7c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     d98:	8be2                	mv	s7,s8
      state = 0;
     d9a:	4981                	li	s3,0
     d9c:	bf21                	j	cb4 <vprintf+0x44>
        s = va_arg(ap, char*);
     d9e:	008b8993          	addi	s3,s7,8
     da2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     da6:	02090163          	beqz	s2,dc8 <vprintf+0x158>
        while(*s != 0){
     daa:	00094583          	lbu	a1,0(s2)
     dae:	c9a5                	beqz	a1,e1e <vprintf+0x1ae>
          putc(fd, *s);
     db0:	8556                	mv	a0,s5
     db2:	00000097          	auipc	ra,0x0
     db6:	df0080e7          	jalr	-528(ra) # ba2 <putc>
          s++;
     dba:	0905                	addi	s2,s2,1
        while(*s != 0){
     dbc:	00094583          	lbu	a1,0(s2)
     dc0:	f9e5                	bnez	a1,db0 <vprintf+0x140>
        s = va_arg(ap, char*);
     dc2:	8bce                	mv	s7,s3
      state = 0;
     dc4:	4981                	li	s3,0
     dc6:	b5fd                	j	cb4 <vprintf+0x44>
          s = "(null)";
     dc8:	00000917          	auipc	s2,0x0
     dcc:	51090913          	addi	s2,s2,1296 # 12d8 <malloc+0x3b6>
        while(*s != 0){
     dd0:	02800593          	li	a1,40
     dd4:	bff1                	j	db0 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
     dd6:	008b8913          	addi	s2,s7,8
     dda:	000bc583          	lbu	a1,0(s7)
     dde:	8556                	mv	a0,s5
     de0:	00000097          	auipc	ra,0x0
     de4:	dc2080e7          	jalr	-574(ra) # ba2 <putc>
     de8:	8bca                	mv	s7,s2
      state = 0;
     dea:	4981                	li	s3,0
     dec:	b5e1                	j	cb4 <vprintf+0x44>
        putc(fd, c);
     dee:	02500593          	li	a1,37
     df2:	8556                	mv	a0,s5
     df4:	00000097          	auipc	ra,0x0
     df8:	dae080e7          	jalr	-594(ra) # ba2 <putc>
      state = 0;
     dfc:	4981                	li	s3,0
     dfe:	bd5d                	j	cb4 <vprintf+0x44>
        putc(fd, '%');
     e00:	02500593          	li	a1,37
     e04:	8556                	mv	a0,s5
     e06:	00000097          	auipc	ra,0x0
     e0a:	d9c080e7          	jalr	-612(ra) # ba2 <putc>
        putc(fd, c);
     e0e:	85ca                	mv	a1,s2
     e10:	8556                	mv	a0,s5
     e12:	00000097          	auipc	ra,0x0
     e16:	d90080e7          	jalr	-624(ra) # ba2 <putc>
      state = 0;
     e1a:	4981                	li	s3,0
     e1c:	bd61                	j	cb4 <vprintf+0x44>
        s = va_arg(ap, char*);
     e1e:	8bce                	mv	s7,s3
      state = 0;
     e20:	4981                	li	s3,0
     e22:	bd49                	j	cb4 <vprintf+0x44>
    }
  }
}
     e24:	60a6                	ld	ra,72(sp)
     e26:	6406                	ld	s0,64(sp)
     e28:	74e2                	ld	s1,56(sp)
     e2a:	7942                	ld	s2,48(sp)
     e2c:	79a2                	ld	s3,40(sp)
     e2e:	7a02                	ld	s4,32(sp)
     e30:	6ae2                	ld	s5,24(sp)
     e32:	6b42                	ld	s6,16(sp)
     e34:	6ba2                	ld	s7,8(sp)
     e36:	6c02                	ld	s8,0(sp)
     e38:	6161                	addi	sp,sp,80
     e3a:	8082                	ret

0000000000000e3c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e3c:	715d                	addi	sp,sp,-80
     e3e:	ec06                	sd	ra,24(sp)
     e40:	e822                	sd	s0,16(sp)
     e42:	1000                	addi	s0,sp,32
     e44:	e010                	sd	a2,0(s0)
     e46:	e414                	sd	a3,8(s0)
     e48:	e818                	sd	a4,16(s0)
     e4a:	ec1c                	sd	a5,24(s0)
     e4c:	03043023          	sd	a6,32(s0)
     e50:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e58:	8622                	mv	a2,s0
     e5a:	00000097          	auipc	ra,0x0
     e5e:	e16080e7          	jalr	-490(ra) # c70 <vprintf>
}
     e62:	60e2                	ld	ra,24(sp)
     e64:	6442                	ld	s0,16(sp)
     e66:	6161                	addi	sp,sp,80
     e68:	8082                	ret

0000000000000e6a <printf>:

void
printf(const char *fmt, ...)
{
     e6a:	711d                	addi	sp,sp,-96
     e6c:	ec06                	sd	ra,24(sp)
     e6e:	e822                	sd	s0,16(sp)
     e70:	1000                	addi	s0,sp,32
     e72:	e40c                	sd	a1,8(s0)
     e74:	e810                	sd	a2,16(s0)
     e76:	ec14                	sd	a3,24(s0)
     e78:	f018                	sd	a4,32(s0)
     e7a:	f41c                	sd	a5,40(s0)
     e7c:	03043823          	sd	a6,48(s0)
     e80:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e84:	00840613          	addi	a2,s0,8
     e88:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e8c:	85aa                	mv	a1,a0
     e8e:	4505                	li	a0,1
     e90:	00000097          	auipc	ra,0x0
     e94:	de0080e7          	jalr	-544(ra) # c70 <vprintf>
}
     e98:	60e2                	ld	ra,24(sp)
     e9a:	6442                	ld	s0,16(sp)
     e9c:	6125                	addi	sp,sp,96
     e9e:	8082                	ret

0000000000000ea0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ea0:	1141                	addi	sp,sp,-16
     ea2:	e422                	sd	s0,8(sp)
     ea4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ea6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eaa:	00001797          	auipc	a5,0x1
     eae:	1567b783          	ld	a5,342(a5) # 2000 <freep>
     eb2:	a02d                	j	edc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     eb4:	4618                	lw	a4,8(a2)
     eb6:	9f2d                	addw	a4,a4,a1
     eb8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     ebc:	6398                	ld	a4,0(a5)
     ebe:	6310                	ld	a2,0(a4)
     ec0:	a83d                	j	efe <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     ec2:	ff852703          	lw	a4,-8(a0)
     ec6:	9f31                	addw	a4,a4,a2
     ec8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     eca:	ff053683          	ld	a3,-16(a0)
     ece:	a091                	j	f12 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ed0:	6398                	ld	a4,0(a5)
     ed2:	00e7e463          	bltu	a5,a4,eda <free+0x3a>
     ed6:	00e6ea63          	bltu	a3,a4,eea <free+0x4a>
{
     eda:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     edc:	fed7fae3          	bgeu	a5,a3,ed0 <free+0x30>
     ee0:	6398                	ld	a4,0(a5)
     ee2:	00e6e463          	bltu	a3,a4,eea <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ee6:	fee7eae3          	bltu	a5,a4,eda <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     eea:	ff852583          	lw	a1,-8(a0)
     eee:	6390                	ld	a2,0(a5)
     ef0:	02059813          	slli	a6,a1,0x20
     ef4:	01c85713          	srli	a4,a6,0x1c
     ef8:	9736                	add	a4,a4,a3
     efa:	fae60de3          	beq	a2,a4,eb4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     efe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f02:	4790                	lw	a2,8(a5)
     f04:	02061593          	slli	a1,a2,0x20
     f08:	01c5d713          	srli	a4,a1,0x1c
     f0c:	973e                	add	a4,a4,a5
     f0e:	fae68ae3          	beq	a3,a4,ec2 <free+0x22>
    p->s.ptr = bp->s.ptr;
     f12:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f14:	00001717          	auipc	a4,0x1
     f18:	0ef73623          	sd	a5,236(a4) # 2000 <freep>
}
     f1c:	6422                	ld	s0,8(sp)
     f1e:	0141                	addi	sp,sp,16
     f20:	8082                	ret

0000000000000f22 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f22:	7139                	addi	sp,sp,-64
     f24:	fc06                	sd	ra,56(sp)
     f26:	f822                	sd	s0,48(sp)
     f28:	f426                	sd	s1,40(sp)
     f2a:	f04a                	sd	s2,32(sp)
     f2c:	ec4e                	sd	s3,24(sp)
     f2e:	e852                	sd	s4,16(sp)
     f30:	e456                	sd	s5,8(sp)
     f32:	e05a                	sd	s6,0(sp)
     f34:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f36:	02051493          	slli	s1,a0,0x20
     f3a:	9081                	srli	s1,s1,0x20
     f3c:	04bd                	addi	s1,s1,15
     f3e:	8091                	srli	s1,s1,0x4
     f40:	0014899b          	addiw	s3,s1,1
     f44:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     f46:	00001517          	auipc	a0,0x1
     f4a:	0ba53503          	ld	a0,186(a0) # 2000 <freep>
     f4e:	c515                	beqz	a0,f7a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     f52:	4798                	lw	a4,8(a5)
     f54:	02977f63          	bgeu	a4,s1,f92 <malloc+0x70>
  if(nu < 4096)
     f58:	8a4e                	mv	s4,s3
     f5a:	0009871b          	sext.w	a4,s3
     f5e:	6685                	lui	a3,0x1
     f60:	00d77363          	bgeu	a4,a3,f66 <malloc+0x44>
     f64:	6a05                	lui	s4,0x1
     f66:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     f6a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     f6e:	00001917          	auipc	s2,0x1
     f72:	09290913          	addi	s2,s2,146 # 2000 <freep>
  if(p == (char*)-1)
     f76:	5afd                	li	s5,-1
     f78:	a895                	j	fec <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
     f7a:	00001797          	auipc	a5,0x1
     f7e:	09678793          	addi	a5,a5,150 # 2010 <base>
     f82:	00001717          	auipc	a4,0x1
     f86:	06f73f23          	sd	a5,126(a4) # 2000 <freep>
     f8a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     f8c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     f90:	b7e1                	j	f58 <malloc+0x36>
      if(p->s.size == nunits)
     f92:	02e48c63          	beq	s1,a4,fca <malloc+0xa8>
        p->s.size -= nunits;
     f96:	4137073b          	subw	a4,a4,s3
     f9a:	c798                	sw	a4,8(a5)
        p += p->s.size;
     f9c:	02071693          	slli	a3,a4,0x20
     fa0:	01c6d713          	srli	a4,a3,0x1c
     fa4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     fa6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     faa:	00001717          	auipc	a4,0x1
     fae:	04a73b23          	sd	a0,86(a4) # 2000 <freep>
      return (void*)(p + 1);
     fb2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
     fb6:	70e2                	ld	ra,56(sp)
     fb8:	7442                	ld	s0,48(sp)
     fba:	74a2                	ld	s1,40(sp)
     fbc:	7902                	ld	s2,32(sp)
     fbe:	69e2                	ld	s3,24(sp)
     fc0:	6a42                	ld	s4,16(sp)
     fc2:	6aa2                	ld	s5,8(sp)
     fc4:	6b02                	ld	s6,0(sp)
     fc6:	6121                	addi	sp,sp,64
     fc8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
     fca:	6398                	ld	a4,0(a5)
     fcc:	e118                	sd	a4,0(a0)
     fce:	bff1                	j	faa <malloc+0x88>
  hp->s.size = nu;
     fd0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     fd4:	0541                	addi	a0,a0,16
     fd6:	00000097          	auipc	ra,0x0
     fda:	eca080e7          	jalr	-310(ra) # ea0 <free>
  return freep;
     fde:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
     fe2:	d971                	beqz	a0,fb6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fe4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fe6:	4798                	lw	a4,8(a5)
     fe8:	fa9775e3          	bgeu	a4,s1,f92 <malloc+0x70>
    if(p == freep)
     fec:	00093703          	ld	a4,0(s2)
     ff0:	853e                	mv	a0,a5
     ff2:	fef719e3          	bne	a4,a5,fe4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
     ff6:	8552                	mv	a0,s4
     ff8:	00000097          	auipc	ra,0x0
     ffc:	b82080e7          	jalr	-1150(ra) # b7a <sbrk>
  if(p == (char*)-1)
    1000:	fd5518e3          	bne	a0,s5,fd0 <malloc+0xae>
        return 0;
    1004:	4501                	li	a0,0
    1006:	bf45                	j	fb6 <malloc+0x94>
