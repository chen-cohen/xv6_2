
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 c8 08 00 00 	movl   $0x8c8,(%esp)
  18:	e8 9b 03 00 00       	call   3b8 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 c8 08 00 00 	movl   $0x8c8,(%esp)
  38:	e8 83 03 00 00       	call   3c0 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 c8 08 00 00 	movl   $0x8c8,(%esp)
  4c:	e8 67 03 00 00       	call   3b8 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 93 03 00 00       	call   3f0 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 87 03 00 00       	call   3f0 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 7b 04 00 00       	call   4f8 <printf>
    pid = fork();
  7d:	e8 ee 02 00 00       	call   370 <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 e3 08 00 	movl   $0x8e3,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 57 04 00 00       	call   4f8 <printf>
      exit();
  a1:	e8 d2 02 00 00       	call   378 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 60 0b 00 	movl   $0xb60,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 c5 08 00 00 	movl   $0x8c5,(%esp)
  bc:	e8 ef 02 00 00       	call   3b0 <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 f6 08 00 	movl   $0x8f6,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 23 04 00 00       	call   4f8 <printf>
      exit();
  d5:	e8 9e 02 00 00       	call   378 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 0c 09 00 	movl   $0x90c,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 08 04 00 00       	call   4f8 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 8b 02 00 00       	call   380 <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>
 10f:	90                   	nop

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d1:	8b 45 10             	mov    0x10(%ebp),%eax
 1d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 26 ff ff ff       	call   110 <stosb>
  return dst;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <strchr>:

char*
strchr(const char *s, char c)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x22>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	3a 45 fc             	cmp    -0x4(%ebp),%al
 206:	75 05                	jne    20d <strchr+0x1e>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22f:	eb 4c                	jmp    27d <gets+0x5b>
    cc = read(0, &c, 1);
 231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 238:	00 
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	89 44 24 04          	mov    %eax,0x4(%esp)
 240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 247:	e8 44 01 00 00       	call   390 <read>
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7f 02                	jg     257 <gets+0x35>
      break;
 255:	eb 31                	jmp    288 <gets+0x66>
    buf[i++] = c;
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	8d 50 01             	lea    0x1(%eax),%edx
 25d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	01 c2                	add    %eax,%edx
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	3c 0a                	cmp    $0xa,%al
 273:	74 13                	je     288 <gets+0x66>
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0d                	cmp    $0xd,%al
 27b:	74 0b                	je     288 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 280:	83 c0 01             	add    $0x1,%eax
 283:	3b 45 0c             	cmp    0xc(%ebp),%eax
 286:	7c a9                	jl     231 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 288:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <stat>:

int
stat(char *n, struct stat *st)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a5:	00 
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 04 24             	mov    %eax,(%esp)
 2ac:	e8 07 01 00 00       	call   3b8 <open>
 2b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b8:	79 07                	jns    2c1 <stat+0x29>
    return -1;
 2ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bf:	eb 23                	jmp    2e4 <stat+0x4c>
  r = fstat(fd, st);
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	89 04 24             	mov    %eax,(%esp)
 2ce:	e8 fd 00 00 00       	call   3d0 <fstat>
 2d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 bf 00 00 00       	call   3a0 <close>
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f3:	eb 25                	jmp    31a <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f8:	89 d0                	mov    %edx,%eax
 2fa:	c1 e0 02             	shl    $0x2,%eax
 2fd:	01 d0                	add    %edx,%eax
 2ff:	01 c0                	add    %eax,%eax
 301:	89 c1                	mov    %eax,%ecx
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 08             	mov    %edx,0x8(%ebp)
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	0f be c0             	movsbl %al,%eax
 312:	01 c8                	add    %ecx,%eax
 314:	83 e8 30             	sub    $0x30,%eax
 317:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	3c 2f                	cmp    $0x2f,%al
 322:	7e 0a                	jle    32e <atoi+0x48>
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 39                	cmp    $0x39,%al
 32c:	7e c7                	jle    2f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33f:	8b 45 0c             	mov    0xc(%ebp),%eax
 342:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 345:	eb 17                	jmp    35e <memmove+0x2b>
    *dst++ = *src++;
 347:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34a:	8d 50 01             	lea    0x1(%eax),%edx
 34d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 350:	8b 55 f8             	mov    -0x8(%ebp),%edx
 353:	8d 4a 01             	lea    0x1(%edx),%ecx
 356:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 359:	0f b6 12             	movzbl (%edx),%edx
 35c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	8b 45 10             	mov    0x10(%ebp),%eax
 361:	8d 50 ff             	lea    -0x1(%eax),%edx
 364:	89 55 10             	mov    %edx,0x10(%ebp)
 367:	85 c0                	test   %eax,%eax
 369:	7f dc                	jg     347 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
SYSCALL(exit)
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
SYSCALL(wait)
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
SYSCALL(pipe)
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
SYSCALL(read)
 390:	b8 05 00 00 00       	mov    $0x5,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
SYSCALL(write)
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
SYSCALL(close)
 3a0:	b8 15 00 00 00       	mov    $0x15,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
SYSCALL(kill)
 3a8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
SYSCALL(exec)
 3b0:	b8 07 00 00 00       	mov    $0x7,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
SYSCALL(open)
 3b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
SYSCALL(mknod)
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
SYSCALL(unlink)
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
SYSCALL(link)
 3d8:	b8 13 00 00 00       	mov    $0x13,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
SYSCALL(mkdir)
 3e0:	b8 14 00 00 00       	mov    $0x14,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
SYSCALL(chdir)
 3e8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
SYSCALL(dup)
 3f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
SYSCALL(getpid)
 3f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
SYSCALL(sbrk)
 400:	b8 0c 00 00 00       	mov    $0xc,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
SYSCALL(sleep)
 408:	b8 0d 00 00 00       	mov    $0xd,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <uptime>:
SYSCALL(uptime)
 410:	b8 0e 00 00 00       	mov    $0xe,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 18             	sub    $0x18,%esp
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 424:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42b:	00 
 42c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42f:	89 44 24 04          	mov    %eax,0x4(%esp)
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	89 04 24             	mov    %eax,(%esp)
 439:	e8 5a ff ff ff       	call   398 <write>
}
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
 445:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 448:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 453:	74 17                	je     46c <printint+0x2c>
 455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 459:	79 11                	jns    46c <printint+0x2c>
    neg = 1;
 45b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	f7 d8                	neg    %eax
 467:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46a:	eb 06                	jmp    472 <printint+0x32>
  } else {
    x = xx;
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 479:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 47c:	8d 41 01             	lea    0x1(%ecx),%eax
 47f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 482:	8b 5d 10             	mov    0x10(%ebp),%ebx
 485:	8b 45 ec             	mov    -0x14(%ebp),%eax
 488:	ba 00 00 00 00       	mov    $0x0,%edx
 48d:	f7 f3                	div    %ebx
 48f:	89 d0                	mov    %edx,%eax
 491:	0f b6 80 68 0b 00 00 	movzbl 0xb68(%eax),%eax
 498:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 49c:	8b 75 10             	mov    0x10(%ebp),%esi
 49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a2:	ba 00 00 00 00       	mov    $0x0,%edx
 4a7:	f7 f6                	div    %esi
 4a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b0:	75 c7                	jne    479 <printint+0x39>
  if(neg)
 4b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b6:	74 10                	je     4c8 <printint+0x88>
    buf[i++] = '-';
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8d 50 01             	lea    0x1(%eax),%edx
 4be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c6:	eb 1f                	jmp    4e7 <printint+0xa7>
 4c8:	eb 1d                	jmp    4e7 <printint+0xa7>
    putc(fd, buf[i]);
 4ca:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d0:	01 d0                	add    %edx,%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 04 24             	mov    %eax,(%esp)
 4e2:	e8 31 ff ff ff       	call   418 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ef:	79 d9                	jns    4ca <printint+0x8a>
    putc(fd, buf[i]);
}
 4f1:	83 c4 30             	add    $0x30,%esp
 4f4:	5b                   	pop    %ebx
 4f5:	5e                   	pop    %esi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    

000004f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 505:	8d 45 0c             	lea    0xc(%ebp),%eax
 508:	83 c0 04             	add    $0x4,%eax
 50b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 515:	e9 7c 01 00 00       	jmp    696 <printf+0x19e>
    c = fmt[i] & 0xff;
 51a:	8b 55 0c             	mov    0xc(%ebp),%edx
 51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 520:	01 d0                	add    %edx,%eax
 522:	0f b6 00             	movzbl (%eax),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	25 ff 00 00 00       	and    $0xff,%eax
 52d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 534:	75 2c                	jne    562 <printf+0x6a>
      if(c == '%'){
 536:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53a:	75 0c                	jne    548 <printf+0x50>
        state = '%';
 53c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 543:	e9 4a 01 00 00       	jmp    692 <printf+0x19a>
      } else {
        putc(fd, c);
 548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	89 44 24 04          	mov    %eax,0x4(%esp)
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	89 04 24             	mov    %eax,(%esp)
 558:	e8 bb fe ff ff       	call   418 <putc>
 55d:	e9 30 01 00 00       	jmp    692 <printf+0x19a>
      }
    } else if(state == '%'){
 562:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 566:	0f 85 26 01 00 00    	jne    692 <printf+0x19a>
      if(c == 'd'){
 56c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 570:	75 2d                	jne    59f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 572:	8b 45 e8             	mov    -0x18(%ebp),%eax
 575:	8b 00                	mov    (%eax),%eax
 577:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57e:	00 
 57f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 586:	00 
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 aa fe ff ff       	call   440 <printint>
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59a:	e9 ec 00 00 00       	jmp    68b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 59f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a3:	74 06                	je     5ab <printf+0xb3>
 5a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a9:	75 2d                	jne    5d8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b7:	00 
 5b8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5bf:	00 
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 71 fe ff ff       	call   440 <printint>
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	e9 b3 00 00 00       	jmp    68b <printf+0x193>
      } else if(c == 's'){
 5d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5dc:	75 45                	jne    623 <printf+0x12b>
        s = (char*)*ap;
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ee:	75 09                	jne    5f9 <printf+0x101>
          s = "(null)";
 5f0:	c7 45 f4 15 09 00 00 	movl   $0x915,-0xc(%ebp)
        while(*s != 0){
 5f7:	eb 1e                	jmp    617 <printf+0x11f>
 5f9:	eb 1c                	jmp    617 <printf+0x11f>
          putc(fd, *s);
 5fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 05 fe ff ff       	call   418 <putc>
          s++;
 613:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	84 c0                	test   %al,%al
 61f:	75 da                	jne    5fb <printf+0x103>
 621:	eb 68                	jmp    68b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 623:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 627:	75 1d                	jne    646 <printf+0x14e>
        putc(fd, *ap);
 629:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 d8 fd ff ff       	call   418 <putc>
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 644:	eb 45                	jmp    68b <printf+0x193>
      } else if(c == '%'){
 646:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64a:	75 17                	jne    663 <printf+0x16b>
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 b7 fd ff ff       	call   418 <putc>
 661:	eb 28                	jmp    68b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 663:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66a:	00 
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 a2 fd ff ff       	call   418 <putc>
        putc(fd, c);
 676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 8d fd ff ff       	call   418 <putc>
      }
      state = 0;
 68b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 692:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 696:	8b 55 0c             	mov    0xc(%ebp),%edx
 699:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69c:	01 d0                	add    %edx,%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	0f 85 71 fe ff ff    	jne    51a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    
 6ab:	90                   	nop

000006ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	83 e8 08             	sub    $0x8,%eax
 6b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bb:	a1 84 0b 00 00       	mov    0xb84,%eax
 6c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c3:	eb 24                	jmp    6e9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cd:	77 12                	ja     6e1 <free+0x35>
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	77 24                	ja     6fb <free+0x4f>
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	77 1a                	ja     6fb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ef:	76 d4                	jbe    6c5 <free+0x19>
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f9:	76 ca                	jbe    6c5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 40 04             	mov    0x4(%eax),%eax
 701:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	39 c2                	cmp    %eax,%edx
 714:	75 24                	jne    73a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	8b 50 04             	mov    0x4(%eax),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	8b 40 04             	mov    0x4(%eax),%eax
 724:	01 c2                	add    %eax,%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	8b 10                	mov    (%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	89 10                	mov    %edx,(%eax)
 738:	eb 0a                	jmp    744 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	01 d0                	add    %edx,%eax
 756:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 759:	75 20                	jne    77b <free+0xcf>
    p->s.size += bp->s.size;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 50 04             	mov    0x4(%eax),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	01 c2                	add    %eax,%edx
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 10                	mov    (%eax),%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	89 10                	mov    %edx,(%eax)
 779:	eb 08                	jmp    783 <free+0xd7>
  } else
    p->s.ptr = bp;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 781:	89 10                	mov    %edx,(%eax)
  freep = p;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	a3 84 0b 00 00       	mov    %eax,0xb84
}
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <morecore>:

static Header*
morecore(uint nu)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 793:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79a:	77 07                	ja     7a3 <morecore+0x16>
    nu = 4096;
 79c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	89 04 24             	mov    %eax,(%esp)
 7ac:	e8 4f fc ff ff       	call   400 <sbrk>
 7b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b8:	75 07                	jne    7c1 <morecore+0x34>
    return 0;
 7ba:	b8 00 00 00 00       	mov    $0x0,%eax
 7bf:	eb 22                	jmp    7e3 <morecore+0x56>
  hp = (Header*)p;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	8b 55 08             	mov    0x8(%ebp),%edx
 7cd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	83 c0 08             	add    $0x8,%eax
 7d6:	89 04 24             	mov    %eax,(%esp)
 7d9:	e8 ce fe ff ff       	call   6ac <free>
  return freep;
 7de:	a1 84 0b 00 00       	mov    0xb84,%eax
}
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <malloc>:

void*
malloc(uint nbytes)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	83 c0 07             	add    $0x7,%eax
 7f1:	c1 e8 03             	shr    $0x3,%eax
 7f4:	83 c0 01             	add    $0x1,%eax
 7f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7fa:	a1 84 0b 00 00       	mov    0xb84,%eax
 7ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 802:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 806:	75 23                	jne    82b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 808:	c7 45 f0 7c 0b 00 00 	movl   $0xb7c,-0x10(%ebp)
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	a3 84 0b 00 00       	mov    %eax,0xb84
 817:	a1 84 0b 00 00       	mov    0xb84,%eax
 81c:	a3 7c 0b 00 00       	mov    %eax,0xb7c
    base.s.size = 0;
 821:	c7 05 80 0b 00 00 00 	movl   $0x0,0xb80
 828:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83c:	72 4d                	jb     88b <malloc+0xa6>
      if(p->s.size == nunits)
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 847:	75 0c                	jne    855 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 10                	mov    (%eax),%edx
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	89 10                	mov    %edx,(%eax)
 853:	eb 26                	jmp    87b <malloc+0x96>
      else {
        p->s.size -= nunits;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 85e:	89 c2                	mov    %eax,%edx
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	c1 e0 03             	shl    $0x3,%eax
 86f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 55 ec             	mov    -0x14(%ebp),%edx
 878:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	a3 84 0b 00 00       	mov    %eax,0xb84
      return (void*)(p + 1);
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	83 c0 08             	add    $0x8,%eax
 889:	eb 38                	jmp    8c3 <malloc+0xde>
    }
    if(p == freep)
 88b:	a1 84 0b 00 00       	mov    0xb84,%eax
 890:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 893:	75 1b                	jne    8b0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 895:	8b 45 ec             	mov    -0x14(%ebp),%eax
 898:	89 04 24             	mov    %eax,(%esp)
 89b:	e8 ed fe ff ff       	call   78d <morecore>
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a7:	75 07                	jne    8b0 <malloc+0xcb>
        return 0;
 8a9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ae:	eb 13                	jmp    8c3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8be:	e9 70 ff ff ff       	jmp    833 <malloc+0x4e>
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    
