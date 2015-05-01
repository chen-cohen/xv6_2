
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 69 09 00 	movl   $0x969,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 5c 05 00 00       	call   59c <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 13 02 00 00       	call   26f <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 a6 03 00 00       	call   414 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 7c 09 00 	movl   $0x97c,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 f7 04 00 00       	call   59c <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 86 03 00 00       	call   45c <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 33 03 00 00       	call   43c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 1a 03 00 00       	call   444 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 86 09 00 	movl   $0x986,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 5e 04 00 00       	call   59c <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 07 03 00 00       	call   45c <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 ac 02 00 00       	call   434 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 9b 02 00 00       	call   444 <close>

  wait();
 1a9:	e8 76 02 00 00       	call   424 <wait>
  
  exit();
 1ae:	e8 69 02 00 00       	call   41c <exit>
 1b3:	90                   	nop

000001b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	57                   	push   %edi
 1b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bc:	8b 55 10             	mov    0x10(%ebp),%edx
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	89 cb                	mov    %ecx,%ebx
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	89 d1                	mov    %edx,%ecx
 1c8:	fc                   	cld    
 1c9:	f3 aa                	rep stos %al,%es:(%edi)
 1cb:	89 ca                	mov    %ecx,%edx
 1cd:	89 fb                	mov    %edi,%ebx
 1cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d5:	5b                   	pop    %ebx
 1d6:	5f                   	pop    %edi
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    

000001d9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e5:	90                   	nop
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	8d 50 01             	lea    0x1(%eax),%edx
 1ec:	89 55 08             	mov    %edx,0x8(%ebp)
 1ef:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f2:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f8:	0f b6 12             	movzbl (%edx),%edx
 1fb:	88 10                	mov    %dl,(%eax)
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	84 c0                	test   %al,%al
 202:	75 e2                	jne    1e6 <strcpy+0xd>
    ;
  return os;
 204:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20c:	eb 08                	jmp    216 <strcmp+0xd>
    p++, q++;
 20e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 212:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	84 c0                	test   %al,%al
 21e:	74 10                	je     230 <strcmp+0x27>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 10             	movzbl (%eax),%edx
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	38 c2                	cmp    %al,%dl
 22e:	74 de                	je     20e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	0f b6 d0             	movzbl %al,%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	0f b6 c0             	movzbl %al,%eax
 242:	29 c2                	sub    %eax,%edx
 244:	89 d0                	mov    %edx,%eax
}
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    

00000248 <strlen>:

uint
strlen(char *s)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 255:	eb 04                	jmp    25b <strlen+0x13>
 257:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	01 d0                	add    %edx,%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	84 c0                	test   %al,%al
 268:	75 ed                	jne    257 <strlen+0xf>
    ;
  return n;
 26a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26d:	c9                   	leave  
 26e:	c3                   	ret    

0000026f <memset>:

void*
memset(void *dst, int c, uint n)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 275:	8b 45 10             	mov    0x10(%ebp),%eax
 278:	89 44 24 08          	mov    %eax,0x8(%esp)
 27c:	8b 45 0c             	mov    0xc(%ebp),%eax
 27f:	89 44 24 04          	mov    %eax,0x4(%esp)
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	89 04 24             	mov    %eax,(%esp)
 289:	e8 26 ff ff ff       	call   1b4 <stosb>
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 4c                	jmp    321 <gets+0x5b>
    cc = read(0, &c, 1);
 2d5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2dc:	00 
 2dd:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2eb:	e8 44 01 00 00       	call   434 <read>
 2f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f7:	7f 02                	jg     2fb <gets+0x35>
      break;
 2f9:	eb 31                	jmp    32c <gets+0x66>
    buf[i++] = c;
 2fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fe:	8d 50 01             	lea    0x1(%eax),%edx
 301:	89 55 f4             	mov    %edx,-0xc(%ebp)
 304:	89 c2                	mov    %eax,%edx
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	01 c2                	add    %eax,%edx
 30b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 311:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 315:	3c 0a                	cmp    $0xa,%al
 317:	74 13                	je     32c <gets+0x66>
 319:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31d:	3c 0d                	cmp    $0xd,%al
 31f:	74 0b                	je     32c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 321:	8b 45 f4             	mov    -0xc(%ebp),%eax
 324:	83 c0 01             	add    $0x1,%eax
 327:	3b 45 0c             	cmp    0xc(%ebp),%eax
 32a:	7c a9                	jl     2d5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	01 d0                	add    %edx,%eax
 334:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <stat>:

int
stat(char *n, struct stat *st)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 349:	00 
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	89 04 24             	mov    %eax,(%esp)
 350:	e8 07 01 00 00       	call   45c <open>
 355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35c:	79 07                	jns    365 <stat+0x29>
    return -1;
 35e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 363:	eb 23                	jmp    388 <stat+0x4c>
  r = fstat(fd, st);
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 fd 00 00 00       	call   474 <fstat>
 377:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 37a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 bf 00 00 00       	call   444 <close>
  return r;
 385:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <atoi>:

int
atoi(const char *s)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 390:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 397:	eb 25                	jmp    3be <atoi+0x34>
    n = n*10 + *s++ - '0';
 399:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 02             	shl    $0x2,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	01 c0                	add    %eax,%eax
 3a5:	89 c1                	mov    %eax,%ecx
 3a7:	8b 45 08             	mov    0x8(%ebp),%eax
 3aa:	8d 50 01             	lea    0x1(%eax),%edx
 3ad:	89 55 08             	mov    %edx,0x8(%ebp)
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	0f be c0             	movsbl %al,%eax
 3b6:	01 c8                	add    %ecx,%eax
 3b8:	83 e8 30             	sub    $0x30,%eax
 3bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	3c 2f                	cmp    $0x2f,%al
 3c6:	7e 0a                	jle    3d2 <atoi+0x48>
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	3c 39                	cmp    $0x39,%al
 3d0:	7e c7                	jle    399 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e9:	eb 17                	jmp    402 <memmove+0x2b>
    *dst++ = *src++;
 3eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ee:	8d 50 01             	lea    0x1(%eax),%edx
 3f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f7:	8d 4a 01             	lea    0x1(%edx),%ecx
 3fa:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fd:	0f b6 12             	movzbl (%edx),%edx
 400:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	8b 45 10             	mov    0x10(%ebp),%eax
 405:	8d 50 ff             	lea    -0x1(%eax),%edx
 408:	89 55 10             	mov    %edx,0x10(%ebp)
 40b:	85 c0                	test   %eax,%eax
 40d:	7f dc                	jg     3eb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <exit>:
SYSCALL(exit)
 41c:	b8 02 00 00 00       	mov    $0x2,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <wait>:
SYSCALL(wait)
 424:	b8 03 00 00 00       	mov    $0x3,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <pipe>:
SYSCALL(pipe)
 42c:	b8 04 00 00 00       	mov    $0x4,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <read>:
SYSCALL(read)
 434:	b8 05 00 00 00       	mov    $0x5,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <write>:
SYSCALL(write)
 43c:	b8 10 00 00 00       	mov    $0x10,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <close>:
SYSCALL(close)
 444:	b8 15 00 00 00       	mov    $0x15,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <kill>:
SYSCALL(kill)
 44c:	b8 06 00 00 00       	mov    $0x6,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exec>:
SYSCALL(exec)
 454:	b8 07 00 00 00       	mov    $0x7,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <open>:
SYSCALL(open)
 45c:	b8 0f 00 00 00       	mov    $0xf,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mknod>:
SYSCALL(mknod)
 464:	b8 11 00 00 00       	mov    $0x11,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <unlink>:
SYSCALL(unlink)
 46c:	b8 12 00 00 00       	mov    $0x12,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <fstat>:
SYSCALL(fstat)
 474:	b8 08 00 00 00       	mov    $0x8,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <link>:
SYSCALL(link)
 47c:	b8 13 00 00 00       	mov    $0x13,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <mkdir>:
SYSCALL(mkdir)
 484:	b8 14 00 00 00       	mov    $0x14,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chdir>:
SYSCALL(chdir)
 48c:	b8 09 00 00 00       	mov    $0x9,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <dup>:
SYSCALL(dup)
 494:	b8 0a 00 00 00       	mov    $0xa,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <getpid>:
SYSCALL(getpid)
 49c:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sbrk>:
SYSCALL(sbrk)
 4a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <sleep>:
SYSCALL(sleep)
 4ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <uptime>:
SYSCALL(uptime)
 4b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 18             	sub    $0x18,%esp
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 5a ff ff ff       	call   43c <write>
}
 4e2:	c9                   	leave  
 4e3:	c3                   	ret    

000004e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	56                   	push   %esi
 4e8:	53                   	push   %ebx
 4e9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f7:	74 17                	je     510 <printint+0x2c>
 4f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fd:	79 11                	jns    510 <printint+0x2c>
    neg = 1;
 4ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 506:	8b 45 0c             	mov    0xc(%ebp),%eax
 509:	f7 d8                	neg    %eax
 50b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50e:	eb 06                	jmp    516 <printint+0x32>
  } else {
    x = xx;
 510:	8b 45 0c             	mov    0xc(%ebp),%eax
 513:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 520:	8d 41 01             	lea    0x1(%ecx),%eax
 523:	89 45 f4             	mov    %eax,-0xc(%ebp)
 526:	8b 5d 10             	mov    0x10(%ebp),%ebx
 529:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52c:	ba 00 00 00 00       	mov    $0x0,%edx
 531:	f7 f3                	div    %ebx
 533:	89 d0                	mov    %edx,%eax
 535:	0f b6 80 d8 0b 00 00 	movzbl 0xbd8(%eax),%eax
 53c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 540:	8b 75 10             	mov    0x10(%ebp),%esi
 543:	8b 45 ec             	mov    -0x14(%ebp),%eax
 546:	ba 00 00 00 00       	mov    $0x0,%edx
 54b:	f7 f6                	div    %esi
 54d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 554:	75 c7                	jne    51d <printint+0x39>
  if(neg)
 556:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55a:	74 10                	je     56c <printint+0x88>
    buf[i++] = '-';
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 f4             	mov    %edx,-0xc(%ebp)
 565:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56a:	eb 1f                	jmp    58b <printint+0xa7>
 56c:	eb 1d                	jmp    58b <printint+0xa7>
    putc(fd, buf[i]);
 56e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	01 d0                	add    %edx,%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 31 ff ff ff       	call   4bc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 593:	79 d9                	jns    56e <printint+0x8a>
    putc(fd, buf[i]);
}
 595:	83 c4 30             	add    $0x30,%esp
 598:	5b                   	pop    %ebx
 599:	5e                   	pop    %esi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    

0000059c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a9:	8d 45 0c             	lea    0xc(%ebp),%eax
 5ac:	83 c0 04             	add    $0x4,%eax
 5af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b9:	e9 7c 01 00 00       	jmp    73a <printf+0x19e>
    c = fmt[i] & 0xff;
 5be:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c4:	01 d0                	add    %edx,%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	25 ff 00 00 00       	and    $0xff,%eax
 5d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d8:	75 2c                	jne    606 <printf+0x6a>
      if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 0c                	jne    5ec <printf+0x50>
        state = '%';
 5e0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e7:	e9 4a 01 00 00       	jmp    736 <printf+0x19a>
      } else {
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 bb fe ff ff       	call   4bc <putc>
 601:	e9 30 01 00 00       	jmp    736 <printf+0x19a>
      }
    } else if(state == '%'){
 606:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 60a:	0f 85 26 01 00 00    	jne    736 <printf+0x19a>
      if(c == 'd'){
 610:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 614:	75 2d                	jne    643 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 622:	00 
 623:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 62a:	00 
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 aa fe ff ff       	call   4e4 <printint>
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	e9 ec 00 00 00       	jmp    72f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 643:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 647:	74 06                	je     64f <printf+0xb3>
 649:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 64d:	75 2d                	jne    67c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 64f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 65b:	00 
 65c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 663:	00 
 664:	89 44 24 04          	mov    %eax,0x4(%esp)
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	89 04 24             	mov    %eax,(%esp)
 66e:	e8 71 fe ff ff       	call   4e4 <printint>
        ap++;
 673:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 677:	e9 b3 00 00 00       	jmp    72f <printf+0x193>
      } else if(c == 's'){
 67c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 680:	75 45                	jne    6c7 <printf+0x12b>
        s = (char*)*ap;
 682:	8b 45 e8             	mov    -0x18(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 692:	75 09                	jne    69d <printf+0x101>
          s = "(null)";
 694:	c7 45 f4 8c 09 00 00 	movl   $0x98c,-0xc(%ebp)
        while(*s != 0){
 69b:	eb 1e                	jmp    6bb <printf+0x11f>
 69d:	eb 1c                	jmp    6bb <printf+0x11f>
          putc(fd, *s);
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 05 fe ff ff       	call   4bc <putc>
          s++;
 6b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6be:	0f b6 00             	movzbl (%eax),%eax
 6c1:	84 c0                	test   %al,%al
 6c3:	75 da                	jne    69f <printf+0x103>
 6c5:	eb 68                	jmp    72f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cb:	75 1d                	jne    6ea <printf+0x14e>
        putc(fd, *ap);
 6cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	0f be c0             	movsbl %al,%eax
 6d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 d8 fd ff ff       	call   4bc <putc>
        ap++;
 6e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e8:	eb 45                	jmp    72f <printf+0x193>
      } else if(c == '%'){
 6ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ee:	75 17                	jne    707 <printf+0x16b>
        putc(fd, c);
 6f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f3:	0f be c0             	movsbl %al,%eax
 6f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	89 04 24             	mov    %eax,(%esp)
 700:	e8 b7 fd ff ff       	call   4bc <putc>
 705:	eb 28                	jmp    72f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 707:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 70e:	00 
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 a2 fd ff ff       	call   4bc <putc>
        putc(fd, c);
 71a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 8d fd ff ff       	call   4bc <putc>
      }
      state = 0;
 72f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 736:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 73a:	8b 55 0c             	mov    0xc(%ebp),%edx
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	0f b6 00             	movzbl (%eax),%eax
 745:	84 c0                	test   %al,%al
 747:	0f 85 71 fe ff ff    	jne    5be <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74d:	c9                   	leave  
 74e:	c3                   	ret    
 74f:	90                   	nop

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 756:	8b 45 08             	mov    0x8(%ebp),%eax
 759:	83 e8 08             	sub    $0x8,%eax
 75c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75f:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 764:	89 45 fc             	mov    %eax,-0x4(%ebp)
 767:	eb 24                	jmp    78d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 771:	77 12                	ja     785 <free+0x35>
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 24                	ja     79f <free+0x4f>
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	77 1a                	ja     79f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 793:	76 d4                	jbe    769 <free+0x19>
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79d:	76 ca                	jbe    769 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	01 c2                	add    %eax,%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 00                	mov    (%eax),%eax
 7b6:	39 c2                	cmp    %eax,%edx
 7b8:	75 24                	jne    7de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	01 c2                	add    %eax,%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 0a                	jmp    7e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 10                	mov    (%eax),%edx
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	01 d0                	add    %edx,%eax
 7fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fd:	75 20                	jne    81f <free+0xcf>
    p->s.size += bp->s.size;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 50 04             	mov    0x4(%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	01 c2                	add    %eax,%edx
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	89 10                	mov    %edx,(%eax)
 81d:	eb 08                	jmp    827 <free+0xd7>
  } else
    p->s.ptr = bp;
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 55 f8             	mov    -0x8(%ebp),%edx
 825:	89 10                	mov    %edx,(%eax)
  freep = p;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	a3 f4 0b 00 00       	mov    %eax,0xbf4
}
 82f:	c9                   	leave  
 830:	c3                   	ret    

00000831 <morecore>:

static Header*
morecore(uint nu)
{
 831:	55                   	push   %ebp
 832:	89 e5                	mov    %esp,%ebp
 834:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 837:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83e:	77 07                	ja     847 <morecore+0x16>
    nu = 4096;
 840:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 847:	8b 45 08             	mov    0x8(%ebp),%eax
 84a:	c1 e0 03             	shl    $0x3,%eax
 84d:	89 04 24             	mov    %eax,(%esp)
 850:	e8 4f fc ff ff       	call   4a4 <sbrk>
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85c:	75 07                	jne    865 <morecore+0x34>
    return 0;
 85e:	b8 00 00 00 00       	mov    $0x0,%eax
 863:	eb 22                	jmp    887 <morecore+0x56>
  hp = (Header*)p;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86e:	8b 55 08             	mov    0x8(%ebp),%edx
 871:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	83 c0 08             	add    $0x8,%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 ce fe ff ff       	call   750 <free>
  return freep;
 882:	a1 f4 0b 00 00       	mov    0xbf4,%eax
}
 887:	c9                   	leave  
 888:	c3                   	ret    

00000889 <malloc>:

void*
malloc(uint nbytes)
{
 889:	55                   	push   %ebp
 88a:	89 e5                	mov    %esp,%ebp
 88c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	83 c0 07             	add    $0x7,%eax
 895:	c1 e8 03             	shr    $0x3,%eax
 898:	83 c0 01             	add    $0x1,%eax
 89b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89e:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 8a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8aa:	75 23                	jne    8cf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8ac:	c7 45 f0 ec 0b 00 00 	movl   $0xbec,-0x10(%ebp)
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	a3 f4 0b 00 00       	mov    %eax,0xbf4
 8bb:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 8c0:	a3 ec 0b 00 00       	mov    %eax,0xbec
    base.s.size = 0;
 8c5:	c7 05 f0 0b 00 00 00 	movl   $0x0,0xbf0
 8cc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	8b 40 04             	mov    0x4(%eax),%eax
 8dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e0:	72 4d                	jb     92f <malloc+0xa6>
      if(p->s.size == nunits)
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 40 04             	mov    0x4(%eax),%eax
 8e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8eb:	75 0c                	jne    8f9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	8b 10                	mov    (%eax),%edx
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	89 10                	mov    %edx,(%eax)
 8f7:	eb 26                	jmp    91f <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	8b 40 04             	mov    0x4(%eax),%eax
 8ff:	2b 45 ec             	sub    -0x14(%ebp),%eax
 902:	89 c2                	mov    %eax,%edx
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	c1 e0 03             	shl    $0x3,%eax
 913:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	8b 55 ec             	mov    -0x14(%ebp),%edx
 91c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 922:	a3 f4 0b 00 00       	mov    %eax,0xbf4
      return (void*)(p + 1);
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	83 c0 08             	add    $0x8,%eax
 92d:	eb 38                	jmp    967 <malloc+0xde>
    }
    if(p == freep)
 92f:	a1 f4 0b 00 00       	mov    0xbf4,%eax
 934:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 937:	75 1b                	jne    954 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 939:	8b 45 ec             	mov    -0x14(%ebp),%eax
 93c:	89 04 24             	mov    %eax,(%esp)
 93f:	e8 ed fe ff ff       	call   831 <morecore>
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
 947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94b:	75 07                	jne    954 <malloc+0xcb>
        return 0;
 94d:	b8 00 00 00 00       	mov    $0x0,%eax
 952:	eb 13                	jmp    967 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 962:	e9 70 ff ff ff       	jmp    8d7 <malloc+0x4e>
}
 967:	c9                   	leave  
 968:	c3                   	ret    
