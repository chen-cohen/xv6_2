
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 31 08 00 	movl   $0x831,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 41 04 00 00       	call   464 <printf>
    exit();
  23:	e8 bc 02 00 00       	call   2e4 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 00 03 00 00       	call   344 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 44 08 00 	movl   $0x844,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 f0 03 00 00       	call   464 <printf>
  exit();
  74:	e8 6b 02 00 00       	call   2e4 <exit>
  79:	66 90                	xchg   %ax,%ax
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 50 01             	lea    0x1(%eax),%edx
  b4:	89 55 08             	mov    %edx,0x8(%ebp)
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c0:	0f b6 12             	movzbl (%edx),%edx
  c3:	88 10                	mov    %dl,(%eax)
  c5:	0f b6 00             	movzbl (%eax),%eax
  c8:	84 c0                	test   %al,%al
  ca:	75 e2                	jne    ae <strcpy+0xd>
    ;
  return os;
  cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cf:	c9                   	leave  
  d0:	c3                   	ret    

000000d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d4:	eb 08                	jmp    de <strcmp+0xd>
    p++, q++;
  d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  da:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	84 c0                	test   %al,%al
  e6:	74 10                	je     f8 <strcmp+0x27>
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 10             	movzbl (%eax),%edx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	38 c2                	cmp    %al,%dl
  f6:	74 de                	je     d6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 d0             	movzbl %al,%edx
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	0f b6 c0             	movzbl %al,%eax
 10a:	29 c2                	sub    %eax,%edx
 10c:	89 d0                	mov    %edx,%eax
}
 10e:	5d                   	pop    %ebp
 10f:	c3                   	ret    

00000110 <strlen>:

uint
strlen(char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11d:	eb 04                	jmp    123 <strlen+0x13>
 11f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 123:	8b 55 fc             	mov    -0x4(%ebp),%edx
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	01 d0                	add    %edx,%eax
 12b:	0f b6 00             	movzbl (%eax),%eax
 12e:	84 c0                	test   %al,%al
 130:	75 ed                	jne    11f <strlen+0xf>
    ;
  return n;
 132:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 135:	c9                   	leave  
 136:	c3                   	ret    

00000137 <memset>:

void*
memset(void *dst, int c, uint n)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13d:	8b 45 10             	mov    0x10(%ebp),%eax
 140:	89 44 24 08          	mov    %eax,0x8(%esp)
 144:	8b 45 0c             	mov    0xc(%ebp),%eax
 147:	89 44 24 04          	mov    %eax,0x4(%esp)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	89 04 24             	mov    %eax,(%esp)
 151:	e8 26 ff ff ff       	call   7c <stosb>
  return dst;
 156:	8b 45 08             	mov    0x8(%ebp),%eax
}
 159:	c9                   	leave  
 15a:	c3                   	ret    

0000015b <strchr>:

char*
strchr(const char *s, char c)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	83 ec 04             	sub    $0x4,%esp
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 167:	eb 14                	jmp    17d <strchr+0x22>
    if(*s == c)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 172:	75 05                	jne    179 <strchr+0x1e>
      return (char*)s;
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	eb 13                	jmp    18c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 179:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	75 e2                	jne    169 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 187:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19b:	eb 4c                	jmp    1e9 <gets+0x5b>
    cc = read(0, &c, 1);
 19d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a4:	00 
 1a5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b3:	e8 44 01 00 00       	call   2fc <read>
 1b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bf:	7f 02                	jg     1c3 <gets+0x35>
      break;
 1c1:	eb 31                	jmp    1f4 <gets+0x66>
    buf[i++] = c;
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	8d 50 01             	lea    0x1(%eax),%edx
 1c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cc:	89 c2                	mov    %eax,%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 c2                	add    %eax,%edx
 1d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dd:	3c 0a                	cmp    $0xa,%al
 1df:	74 13                	je     1f4 <gets+0x66>
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	3c 0d                	cmp    $0xd,%al
 1e7:	74 0b                	je     1f4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f2:	7c a9                	jl     19d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <stat>:

int
stat(char *n, struct stat *st)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 211:	00 
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	89 04 24             	mov    %eax,(%esp)
 218:	e8 07 01 00 00       	call   324 <open>
 21d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 224:	79 07                	jns    22d <stat+0x29>
    return -1;
 226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22b:	eb 23                	jmp    250 <stat+0x4c>
  r = fstat(fd, st);
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	89 04 24             	mov    %eax,(%esp)
 23a:	e8 fd 00 00 00       	call   33c <fstat>
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	8b 45 f4             	mov    -0xc(%ebp),%eax
 245:	89 04 24             	mov    %eax,(%esp)
 248:	e8 bf 00 00 00       	call   30c <close>
  return r;
 24d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <atoi>:

int
atoi(const char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25f:	eb 25                	jmp    286 <atoi+0x34>
    n = n*10 + *s++ - '0';
 261:	8b 55 fc             	mov    -0x4(%ebp),%edx
 264:	89 d0                	mov    %edx,%eax
 266:	c1 e0 02             	shl    $0x2,%eax
 269:	01 d0                	add    %edx,%eax
 26b:	01 c0                	add    %eax,%eax
 26d:	89 c1                	mov    %eax,%ecx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	8d 50 01             	lea    0x1(%eax),%edx
 275:	89 55 08             	mov    %edx,0x8(%ebp)
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	0f be c0             	movsbl %al,%eax
 27e:	01 c8                	add    %ecx,%eax
 280:	83 e8 30             	sub    $0x30,%eax
 283:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	3c 2f                	cmp    $0x2f,%al
 28e:	7e 0a                	jle    29a <atoi+0x48>
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	3c 39                	cmp    $0x39,%al
 298:	7e c7                	jle    261 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b1:	eb 17                	jmp    2ca <memmove+0x2b>
    *dst++ = *src++;
 2b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b6:	8d 50 01             	lea    0x1(%eax),%edx
 2b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2bf:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c5:	0f b6 12             	movzbl (%edx),%edx
 2c8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ca:	8b 45 10             	mov    0x10(%ebp),%eax
 2cd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d0:	89 55 10             	mov    %edx,0x10(%ebp)
 2d3:	85 c0                	test   %eax,%eax
 2d5:	7f dc                	jg     2b3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dc:	b8 01 00 00 00       	mov    $0x1,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <exit>:
SYSCALL(exit)
 2e4:	b8 02 00 00 00       	mov    $0x2,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <wait>:
SYSCALL(wait)
 2ec:	b8 03 00 00 00       	mov    $0x3,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <pipe>:
SYSCALL(pipe)
 2f4:	b8 04 00 00 00       	mov    $0x4,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <read>:
SYSCALL(read)
 2fc:	b8 05 00 00 00       	mov    $0x5,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <write>:
SYSCALL(write)
 304:	b8 10 00 00 00       	mov    $0x10,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <close>:
SYSCALL(close)
 30c:	b8 15 00 00 00       	mov    $0x15,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <kill>:
SYSCALL(kill)
 314:	b8 06 00 00 00       	mov    $0x6,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <exec>:
SYSCALL(exec)
 31c:	b8 07 00 00 00       	mov    $0x7,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <open>:
SYSCALL(open)
 324:	b8 0f 00 00 00       	mov    $0xf,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mknod>:
SYSCALL(mknod)
 32c:	b8 11 00 00 00       	mov    $0x11,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <unlink>:
SYSCALL(unlink)
 334:	b8 12 00 00 00       	mov    $0x12,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <fstat>:
SYSCALL(fstat)
 33c:	b8 08 00 00 00       	mov    $0x8,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <link>:
SYSCALL(link)
 344:	b8 13 00 00 00       	mov    $0x13,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <mkdir>:
SYSCALL(mkdir)
 34c:	b8 14 00 00 00       	mov    $0x14,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <chdir>:
SYSCALL(chdir)
 354:	b8 09 00 00 00       	mov    $0x9,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <dup>:
SYSCALL(dup)
 35c:	b8 0a 00 00 00       	mov    $0xa,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <getpid>:
SYSCALL(getpid)
 364:	b8 0b 00 00 00       	mov    $0xb,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sbrk>:
SYSCALL(sbrk)
 36c:	b8 0c 00 00 00       	mov    $0xc,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sleep>:
SYSCALL(sleep)
 374:	b8 0d 00 00 00       	mov    $0xd,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <uptime>:
SYSCALL(uptime)
 37c:	b8 0e 00 00 00       	mov    $0xe,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	83 ec 18             	sub    $0x18,%esp
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 390:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 397:	00 
 398:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39b:	89 44 24 04          	mov    %eax,0x4(%esp)
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	89 04 24             	mov    %eax,(%esp)
 3a5:	e8 5a ff ff ff       	call   304 <write>
}
 3aa:	c9                   	leave  
 3ab:	c3                   	ret    

000003ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	56                   	push   %esi
 3b0:	53                   	push   %ebx
 3b1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bf:	74 17                	je     3d8 <printint+0x2c>
 3c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c5:	79 11                	jns    3d8 <printint+0x2c>
    neg = 1;
 3c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	f7 d8                	neg    %eax
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d6:	eb 06                	jmp    3de <printint+0x32>
  } else {
    x = xx;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e8:	8d 41 01             	lea    0x1(%ecx),%eax
 3eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f4:	ba 00 00 00 00       	mov    $0x0,%edx
 3f9:	f7 f3                	div    %ebx
 3fb:	89 d0                	mov    %edx,%eax
 3fd:	0f b6 80 a4 0a 00 00 	movzbl 0xaa4(%eax),%eax
 404:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 408:	8b 75 10             	mov    0x10(%ebp),%esi
 40b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40e:	ba 00 00 00 00       	mov    $0x0,%edx
 413:	f7 f6                	div    %esi
 415:	89 45 ec             	mov    %eax,-0x14(%ebp)
 418:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41c:	75 c7                	jne    3e5 <printint+0x39>
  if(neg)
 41e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 422:	74 10                	je     434 <printint+0x88>
    buf[i++] = '-';
 424:	8b 45 f4             	mov    -0xc(%ebp),%eax
 427:	8d 50 01             	lea    0x1(%eax),%edx
 42a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 432:	eb 1f                	jmp    453 <printint+0xa7>
 434:	eb 1d                	jmp    453 <printint+0xa7>
    putc(fd, buf[i]);
 436:	8d 55 dc             	lea    -0x24(%ebp),%edx
 439:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43c:	01 d0                	add    %edx,%eax
 43e:	0f b6 00             	movzbl (%eax),%eax
 441:	0f be c0             	movsbl %al,%eax
 444:	89 44 24 04          	mov    %eax,0x4(%esp)
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	89 04 24             	mov    %eax,(%esp)
 44e:	e8 31 ff ff ff       	call   384 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 453:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45b:	79 d9                	jns    436 <printint+0x8a>
    putc(fd, buf[i]);
}
 45d:	83 c4 30             	add    $0x30,%esp
 460:	5b                   	pop    %ebx
 461:	5e                   	pop    %esi
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    

00000464 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 46a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 471:	8d 45 0c             	lea    0xc(%ebp),%eax
 474:	83 c0 04             	add    $0x4,%eax
 477:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 47a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 481:	e9 7c 01 00 00       	jmp    602 <printf+0x19e>
    c = fmt[i] & 0xff;
 486:	8b 55 0c             	mov    0xc(%ebp),%edx
 489:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48c:	01 d0                	add    %edx,%eax
 48e:	0f b6 00             	movzbl (%eax),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	25 ff 00 00 00       	and    $0xff,%eax
 499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a0:	75 2c                	jne    4ce <printf+0x6a>
      if(c == '%'){
 4a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a6:	75 0c                	jne    4b4 <printf+0x50>
        state = '%';
 4a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4af:	e9 4a 01 00 00       	jmp    5fe <printf+0x19a>
      } else {
        putc(fd, c);
 4b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	89 04 24             	mov    %eax,(%esp)
 4c4:	e8 bb fe ff ff       	call   384 <putc>
 4c9:	e9 30 01 00 00       	jmp    5fe <printf+0x19a>
      }
    } else if(state == '%'){
 4ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d2:	0f 85 26 01 00 00    	jne    5fe <printf+0x19a>
      if(c == 'd'){
 4d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4dc:	75 2d                	jne    50b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e1:	8b 00                	mov    (%eax),%eax
 4e3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ea:	00 
 4eb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f2:	00 
 4f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	89 04 24             	mov    %eax,(%esp)
 4fd:	e8 aa fe ff ff       	call   3ac <printint>
        ap++;
 502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 506:	e9 ec 00 00 00       	jmp    5f7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 50b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50f:	74 06                	je     517 <printf+0xb3>
 511:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 515:	75 2d                	jne    544 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 523:	00 
 524:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 52b:	00 
 52c:	89 44 24 04          	mov    %eax,0x4(%esp)
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	89 04 24             	mov    %eax,(%esp)
 536:	e8 71 fe ff ff       	call   3ac <printint>
        ap++;
 53b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53f:	e9 b3 00 00 00       	jmp    5f7 <printf+0x193>
      } else if(c == 's'){
 544:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 548:	75 45                	jne    58f <printf+0x12b>
        s = (char*)*ap;
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55a:	75 09                	jne    565 <printf+0x101>
          s = "(null)";
 55c:	c7 45 f4 58 08 00 00 	movl   $0x858,-0xc(%ebp)
        while(*s != 0){
 563:	eb 1e                	jmp    583 <printf+0x11f>
 565:	eb 1c                	jmp    583 <printf+0x11f>
          putc(fd, *s);
 567:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	89 44 24 04          	mov    %eax,0x4(%esp)
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 05 fe ff ff       	call   384 <putc>
          s++;
 57f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 583:	8b 45 f4             	mov    -0xc(%ebp),%eax
 586:	0f b6 00             	movzbl (%eax),%eax
 589:	84 c0                	test   %al,%al
 58b:	75 da                	jne    567 <printf+0x103>
 58d:	eb 68                	jmp    5f7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 593:	75 1d                	jne    5b2 <printf+0x14e>
        putc(fd, *ap);
 595:	8b 45 e8             	mov    -0x18(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	0f be c0             	movsbl %al,%eax
 59d:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	89 04 24             	mov    %eax,(%esp)
 5a7:	e8 d8 fd ff ff       	call   384 <putc>
        ap++;
 5ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b0:	eb 45                	jmp    5f7 <printf+0x193>
      } else if(c == '%'){
 5b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b6:	75 17                	jne    5cf <printf+0x16b>
        putc(fd, c);
 5b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 b7 fd ff ff       	call   384 <putc>
 5cd:	eb 28                	jmp    5f7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d6:	00 
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 a2 fd ff ff       	call   384 <putc>
        putc(fd, c);
 5e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 8d fd ff ff       	call   384 <putc>
      }
      state = 0;
 5f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 602:	8b 55 0c             	mov    0xc(%ebp),%edx
 605:	8b 45 f0             	mov    -0x10(%ebp),%eax
 608:	01 d0                	add    %edx,%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	84 c0                	test   %al,%al
 60f:	0f 85 71 fe ff ff    	jne    486 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 615:	c9                   	leave  
 616:	c3                   	ret    
 617:	90                   	nop

00000618 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	83 e8 08             	sub    $0x8,%eax
 624:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 627:	a1 c0 0a 00 00       	mov    0xac0,%eax
 62c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62f:	eb 24                	jmp    655 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 639:	77 12                	ja     64d <free+0x35>
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 24                	ja     667 <free+0x4f>
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64b:	77 1a                	ja     667 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	89 45 fc             	mov    %eax,-0x4(%ebp)
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	76 d4                	jbe    631 <free+0x19>
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 665:	76 ca                	jbe    631 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	01 c2                	add    %eax,%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	39 c2                	cmp    %eax,%edx
 680:	75 24                	jne    6a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 40 04             	mov    0x4(%eax),%eax
 690:	01 c2                	add    %eax,%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 0a                	jmp    6b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 40 04             	mov    0x4(%eax),%eax
 6b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c5:	75 20                	jne    6e7 <free+0xcf>
    p->s.size += bp->s.size;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 50 04             	mov    0x4(%eax),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	8b 40 04             	mov    0x4(%eax),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 08                	jmp    6ef <free+0xd7>
  } else
    p->s.ptr = bp;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ed:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <morecore>:

static Header*
morecore(uint nu)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 706:	77 07                	ja     70f <morecore+0x16>
    nu = 4096;
 708:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	c1 e0 03             	shl    $0x3,%eax
 715:	89 04 24             	mov    %eax,(%esp)
 718:	e8 4f fc ff ff       	call   36c <sbrk>
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 720:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 724:	75 07                	jne    72d <morecore+0x34>
    return 0;
 726:	b8 00 00 00 00       	mov    $0x0,%eax
 72b:	eb 22                	jmp    74f <morecore+0x56>
  hp = (Header*)p;
 72d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	8b 55 08             	mov    0x8(%ebp),%edx
 739:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	83 c0 08             	add    $0x8,%eax
 742:	89 04 24             	mov    %eax,(%esp)
 745:	e8 ce fe ff ff       	call   618 <free>
  return freep;
 74a:	a1 c0 0a 00 00       	mov    0xac0,%eax
}
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <malloc>:

void*
malloc(uint nbytes)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 757:	8b 45 08             	mov    0x8(%ebp),%eax
 75a:	83 c0 07             	add    $0x7,%eax
 75d:	c1 e8 03             	shr    $0x3,%eax
 760:	83 c0 01             	add    $0x1,%eax
 763:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 766:	a1 c0 0a 00 00       	mov    0xac0,%eax
 76b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 772:	75 23                	jne    797 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 774:	c7 45 f0 b8 0a 00 00 	movl   $0xab8,-0x10(%ebp)
 77b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77e:	a3 c0 0a 00 00       	mov    %eax,0xac0
 783:	a1 c0 0a 00 00       	mov    0xac0,%eax
 788:	a3 b8 0a 00 00       	mov    %eax,0xab8
    base.s.size = 0;
 78d:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 794:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a8:	72 4d                	jb     7f7 <malloc+0xa6>
      if(p->s.size == nunits)
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b3:	75 0c                	jne    7c1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 10                	mov    (%eax),%edx
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	89 10                	mov    %edx,(%eax)
 7bf:	eb 26                	jmp    7e7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ca:	89 c2                	mov    %eax,%edx
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	c1 e0 03             	shl    $0x3,%eax
 7db:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	a3 c0 0a 00 00       	mov    %eax,0xac0
      return (void*)(p + 1);
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	83 c0 08             	add    $0x8,%eax
 7f5:	eb 38                	jmp    82f <malloc+0xde>
    }
    if(p == freep)
 7f7:	a1 c0 0a 00 00       	mov    0xac0,%eax
 7fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ff:	75 1b                	jne    81c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 801:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804:	89 04 24             	mov    %eax,(%esp)
 807:	e8 ed fe ff ff       	call   6f9 <morecore>
 80c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 813:	75 07                	jne    81c <malloc+0xcb>
        return 0;
 815:	b8 00 00 00 00       	mov    $0x0,%eax
 81a:	eb 13                	jmp    82f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82a:	e9 70 ff ff ff       	jmp    79f <malloc+0x4e>
}
 82f:	c9                   	leave  
 830:	c3                   	ret    
