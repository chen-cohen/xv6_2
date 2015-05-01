
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 1d 08 00 	movl   $0x81d,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 2d 04 00 00       	call   450 <printf>
    exit();
  23:	e8 a8 02 00 00       	call   2d0 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f2 01 00 00       	call   23e <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 ac 02 00 00       	call   300 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 69 02 00 00       	call   2d0 <exit>
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	8d 50 01             	lea    0x1(%eax),%edx
  a0:	89 55 08             	mov    %edx,0x8(%ebp)
  a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ac:	0f b6 12             	movzbl (%edx),%edx
  af:	88 10                	mov    %dl,(%eax)
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	84 c0                	test   %al,%al
  b6:	75 e2                	jne    9a <strcpy+0xd>
    ;
  return os;
  b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    

000000bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c0:	eb 08                	jmp    ca <strcmp+0xd>
    p++, q++;
  c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	84 c0                	test   %al,%al
  d2:	74 10                	je     e4 <strcmp+0x27>
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	0f b6 10             	movzbl (%eax),%edx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	0f b6 00             	movzbl (%eax),%eax
  e0:	38 c2                	cmp    %al,%dl
  e2:	74 de                	je     c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	0f b6 00             	movzbl (%eax),%eax
  ea:	0f b6 d0             	movzbl %al,%edx
  ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	0f b6 c0             	movzbl %al,%eax
  f6:	29 c2                	sub    %eax,%edx
  f8:	89 d0                	mov    %edx,%eax
}
  fa:	5d                   	pop    %ebp
  fb:	c3                   	ret    

000000fc <strlen>:

uint
strlen(char *s)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 109:	eb 04                	jmp    10f <strlen+0x13>
 10b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	01 d0                	add    %edx,%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	84 c0                	test   %al,%al
 11c:	75 ed                	jne    10b <strlen+0xf>
    ;
  return n;
 11e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 121:	c9                   	leave  
 122:	c3                   	ret    

00000123 <memset>:

void*
memset(void *dst, int c, uint n)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 129:	8b 45 10             	mov    0x10(%ebp),%eax
 12c:	89 44 24 08          	mov    %eax,0x8(%esp)
 130:	8b 45 0c             	mov    0xc(%ebp),%eax
 133:	89 44 24 04          	mov    %eax,0x4(%esp)
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	89 04 24             	mov    %eax,(%esp)
 13d:	e8 26 ff ff ff       	call   68 <stosb>
  return dst;
 142:	8b 45 08             	mov    0x8(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strchr>:

char*
strchr(const char *s, char c)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 04             	sub    $0x4,%esp
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 153:	eb 14                	jmp    169 <strchr+0x22>
    if(*s == c)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15e:	75 05                	jne    165 <strchr+0x1e>
      return (char*)s;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	eb 13                	jmp    178 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 165:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	84 c0                	test   %al,%al
 171:	75 e2                	jne    155 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 173:	b8 00 00 00 00       	mov    $0x0,%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <gets>:

char*
gets(char *buf, int max)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 187:	eb 4c                	jmp    1d5 <gets+0x5b>
    cc = read(0, &c, 1);
 189:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 190:	00 
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	89 44 24 04          	mov    %eax,0x4(%esp)
 198:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19f:	e8 44 01 00 00       	call   2e8 <read>
 1a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ab:	7f 02                	jg     1af <gets+0x35>
      break;
 1ad:	eb 31                	jmp    1e0 <gets+0x66>
    buf[i++] = c;
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	8d 50 01             	lea    0x1(%eax),%edx
 1b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b8:	89 c2                	mov    %eax,%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 c2                	add    %eax,%edx
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c9:	3c 0a                	cmp    $0xa,%al
 1cb:	74 13                	je     1e0 <gets+0x66>
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	3c 0d                	cmp    $0xd,%al
 1d3:	74 0b                	je     1e0 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	83 c0 01             	add    $0x1,%eax
 1db:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1de:	7c a9                	jl     189 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	01 d0                	add    %edx,%eax
 1e8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fd:	00 
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	89 04 24             	mov    %eax,(%esp)
 204:	e8 07 01 00 00       	call   310 <open>
 209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 210:	79 07                	jns    219 <stat+0x29>
    return -1;
 212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 217:	eb 23                	jmp    23c <stat+0x4c>
  r = fstat(fd, st);
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	89 44 24 04          	mov    %eax,0x4(%esp)
 220:	8b 45 f4             	mov    -0xc(%ebp),%eax
 223:	89 04 24             	mov    %eax,(%esp)
 226:	e8 fd 00 00 00       	call   328 <fstat>
 22b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 231:	89 04 24             	mov    %eax,(%esp)
 234:	e8 bf 00 00 00       	call   2f8 <close>
  return r;
 239:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <atoi>:

int
atoi(const char *s)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24b:	eb 25                	jmp    272 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	89 d0                	mov    %edx,%eax
 252:	c1 e0 02             	shl    $0x2,%eax
 255:	01 d0                	add    %edx,%eax
 257:	01 c0                	add    %eax,%eax
 259:	89 c1                	mov    %eax,%ecx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 01             	lea    0x1(%eax),%edx
 261:	89 55 08             	mov    %edx,0x8(%ebp)
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	01 c8                	add    %ecx,%eax
 26c:	83 e8 30             	sub    $0x30,%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 2f                	cmp    $0x2f,%al
 27a:	7e 0a                	jle    286 <atoi+0x48>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 39                	cmp    $0x39,%al
 284:	7e c7                	jle    24d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29d:	eb 17                	jmp    2b6 <memmove+0x2b>
    *dst++ = *src++;
 29f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a2:	8d 50 01             	lea    0x1(%eax),%edx
 2a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ab:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ae:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b1:	0f b6 12             	movzbl (%edx),%edx
 2b4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b6:	8b 45 10             	mov    0x10(%ebp),%eax
 2b9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bc:	89 55 10             	mov    %edx,0x10(%ebp)
 2bf:	85 c0                	test   %eax,%eax
 2c1:	7f dc                	jg     29f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c8:	b8 01 00 00 00       	mov    $0x1,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <exit>:
SYSCALL(exit)
 2d0:	b8 02 00 00 00       	mov    $0x2,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <wait>:
SYSCALL(wait)
 2d8:	b8 03 00 00 00       	mov    $0x3,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <pipe>:
SYSCALL(pipe)
 2e0:	b8 04 00 00 00       	mov    $0x4,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <read>:
SYSCALL(read)
 2e8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <write>:
SYSCALL(write)
 2f0:	b8 10 00 00 00       	mov    $0x10,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <close>:
SYSCALL(close)
 2f8:	b8 15 00 00 00       	mov    $0x15,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <kill>:
SYSCALL(kill)
 300:	b8 06 00 00 00       	mov    $0x6,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <exec>:
SYSCALL(exec)
 308:	b8 07 00 00 00       	mov    $0x7,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <open>:
SYSCALL(open)
 310:	b8 0f 00 00 00       	mov    $0xf,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <mknod>:
SYSCALL(mknod)
 318:	b8 11 00 00 00       	mov    $0x11,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <unlink>:
SYSCALL(unlink)
 320:	b8 12 00 00 00       	mov    $0x12,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <fstat>:
SYSCALL(fstat)
 328:	b8 08 00 00 00       	mov    $0x8,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <link>:
SYSCALL(link)
 330:	b8 13 00 00 00       	mov    $0x13,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <mkdir>:
SYSCALL(mkdir)
 338:	b8 14 00 00 00       	mov    $0x14,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <chdir>:
SYSCALL(chdir)
 340:	b8 09 00 00 00       	mov    $0x9,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <dup>:
SYSCALL(dup)
 348:	b8 0a 00 00 00       	mov    $0xa,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <getpid>:
SYSCALL(getpid)
 350:	b8 0b 00 00 00       	mov    $0xb,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sbrk>:
SYSCALL(sbrk)
 358:	b8 0c 00 00 00       	mov    $0xc,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <sleep>:
SYSCALL(sleep)
 360:	b8 0d 00 00 00       	mov    $0xd,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <uptime>:
SYSCALL(uptime)
 368:	b8 0e 00 00 00       	mov    $0xe,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 18             	sub    $0x18,%esp
 376:	8b 45 0c             	mov    0xc(%ebp),%eax
 379:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 383:	00 
 384:	8d 45 f4             	lea    -0xc(%ebp),%eax
 387:	89 44 24 04          	mov    %eax,0x4(%esp)
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	89 04 24             	mov    %eax,(%esp)
 391:	e8 5a ff ff ff       	call   2f0 <write>
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	56                   	push   %esi
 39c:	53                   	push   %ebx
 39d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ab:	74 17                	je     3c4 <printint+0x2c>
 3ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b1:	79 11                	jns    3c4 <printint+0x2c>
    neg = 1;
 3b3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	f7 d8                	neg    %eax
 3bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c2:	eb 06                	jmp    3ca <printint+0x32>
  } else {
    x = xx;
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d4:	8d 41 01             	lea    0x1(%ecx),%eax
 3d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e0:	ba 00 00 00 00       	mov    $0x0,%edx
 3e5:	f7 f3                	div    %ebx
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	0f b6 80 7c 0a 00 00 	movzbl 0xa7c(%eax),%eax
 3f0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f4:	8b 75 10             	mov    0x10(%ebp),%esi
 3f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fa:	ba 00 00 00 00       	mov    $0x0,%edx
 3ff:	f7 f6                	div    %esi
 401:	89 45 ec             	mov    %eax,-0x14(%ebp)
 404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 408:	75 c7                	jne    3d1 <printint+0x39>
  if(neg)
 40a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40e:	74 10                	je     420 <printint+0x88>
    buf[i++] = '-';
 410:	8b 45 f4             	mov    -0xc(%ebp),%eax
 413:	8d 50 01             	lea    0x1(%eax),%edx
 416:	89 55 f4             	mov    %edx,-0xc(%ebp)
 419:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 41e:	eb 1f                	jmp    43f <printint+0xa7>
 420:	eb 1d                	jmp    43f <printint+0xa7>
    putc(fd, buf[i]);
 422:	8d 55 dc             	lea    -0x24(%ebp),%edx
 425:	8b 45 f4             	mov    -0xc(%ebp),%eax
 428:	01 d0                	add    %edx,%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	0f be c0             	movsbl %al,%eax
 430:	89 44 24 04          	mov    %eax,0x4(%esp)
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	89 04 24             	mov    %eax,(%esp)
 43a:	e8 31 ff ff ff       	call   370 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 443:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 447:	79 d9                	jns    422 <printint+0x8a>
    putc(fd, buf[i]);
}
 449:	83 c4 30             	add    $0x30,%esp
 44c:	5b                   	pop    %ebx
 44d:	5e                   	pop    %esi
 44e:	5d                   	pop    %ebp
 44f:	c3                   	ret    

00000450 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 456:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 45d:	8d 45 0c             	lea    0xc(%ebp),%eax
 460:	83 c0 04             	add    $0x4,%eax
 463:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 466:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 46d:	e9 7c 01 00 00       	jmp    5ee <printf+0x19e>
    c = fmt[i] & 0xff;
 472:	8b 55 0c             	mov    0xc(%ebp),%edx
 475:	8b 45 f0             	mov    -0x10(%ebp),%eax
 478:	01 d0                	add    %edx,%eax
 47a:	0f b6 00             	movzbl (%eax),%eax
 47d:	0f be c0             	movsbl %al,%eax
 480:	25 ff 00 00 00       	and    $0xff,%eax
 485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48c:	75 2c                	jne    4ba <printf+0x6a>
      if(c == '%'){
 48e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 492:	75 0c                	jne    4a0 <printf+0x50>
        state = '%';
 494:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49b:	e9 4a 01 00 00       	jmp    5ea <printf+0x19a>
      } else {
        putc(fd, c);
 4a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a3:	0f be c0             	movsbl %al,%eax
 4a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	89 04 24             	mov    %eax,(%esp)
 4b0:	e8 bb fe ff ff       	call   370 <putc>
 4b5:	e9 30 01 00 00       	jmp    5ea <printf+0x19a>
      }
    } else if(state == '%'){
 4ba:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4be:	0f 85 26 01 00 00    	jne    5ea <printf+0x19a>
      if(c == 'd'){
 4c4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c8:	75 2d                	jne    4f7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cd:	8b 00                	mov    (%eax),%eax
 4cf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d6:	00 
 4d7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4de:	00 
 4df:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	89 04 24             	mov    %eax,(%esp)
 4e9:	e8 aa fe ff ff       	call   398 <printint>
        ap++;
 4ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f2:	e9 ec 00 00 00       	jmp    5e3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4f7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fb:	74 06                	je     503 <printf+0xb3>
 4fd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 501:	75 2d                	jne    530 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 503:	8b 45 e8             	mov    -0x18(%ebp),%eax
 506:	8b 00                	mov    (%eax),%eax
 508:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 50f:	00 
 510:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 517:	00 
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 71 fe ff ff       	call   398 <printint>
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52b:	e9 b3 00 00 00       	jmp    5e3 <printf+0x193>
      } else if(c == 's'){
 530:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 534:	75 45                	jne    57b <printf+0x12b>
        s = (char*)*ap;
 536:	8b 45 e8             	mov    -0x18(%ebp),%eax
 539:	8b 00                	mov    (%eax),%eax
 53b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 546:	75 09                	jne    551 <printf+0x101>
          s = "(null)";
 548:	c7 45 f4 31 08 00 00 	movl   $0x831,-0xc(%ebp)
        while(*s != 0){
 54f:	eb 1e                	jmp    56f <printf+0x11f>
 551:	eb 1c                	jmp    56f <printf+0x11f>
          putc(fd, *s);
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	0f be c0             	movsbl %al,%eax
 55c:	89 44 24 04          	mov    %eax,0x4(%esp)
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 05 fe ff ff       	call   370 <putc>
          s++;
 56b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	84 c0                	test   %al,%al
 577:	75 da                	jne    553 <printf+0x103>
 579:	eb 68                	jmp    5e3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57f:	75 1d                	jne    59e <printf+0x14e>
        putc(fd, *ap);
 581:	8b 45 e8             	mov    -0x18(%ebp),%eax
 584:	8b 00                	mov    (%eax),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 d8 fd ff ff       	call   370 <putc>
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	eb 45                	jmp    5e3 <printf+0x193>
      } else if(c == '%'){
 59e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a2:	75 17                	jne    5bb <printf+0x16b>
        putc(fd, c);
 5a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 b7 fd ff ff       	call   370 <putc>
 5b9:	eb 28                	jmp    5e3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c2:	00 
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 a2 fd ff ff       	call   370 <putc>
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	89 04 24             	mov    %eax,(%esp)
 5de:	e8 8d fd ff ff       	call   370 <putc>
      }
      state = 0;
 5e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	0f 85 71 fe ff ff    	jne    472 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 601:	c9                   	leave  
 602:	c3                   	ret    
 603:	90                   	nop

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 98 0a 00 00       	mov    0xa98,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	75 20                	jne    6d3 <free+0xcf>
    p->s.size += bp->s.size;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	01 c2                	add    %eax,%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 08                	jmp    6db <free+0xd7>
  } else
    p->s.ptr = bp;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6e3:	c9                   	leave  
 6e4:	c3                   	ret    

000006e5 <morecore>:

static Header*
morecore(uint nu)
{
 6e5:	55                   	push   %ebp
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6eb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f2:	77 07                	ja     6fb <morecore+0x16>
    nu = 4096;
 6f4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	c1 e0 03             	shl    $0x3,%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 4f fc ff ff       	call   358 <sbrk>
 709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 710:	75 07                	jne    719 <morecore+0x34>
    return 0;
 712:	b8 00 00 00 00       	mov    $0x0,%eax
 717:	eb 22                	jmp    73b <morecore+0x56>
  hp = (Header*)p;
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	8b 55 08             	mov    0x8(%ebp),%edx
 725:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	83 c0 08             	add    $0x8,%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 ce fe ff ff       	call   604 <free>
  return freep;
 736:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <malloc>:

void*
malloc(uint nbytes)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 743:	8b 45 08             	mov    0x8(%ebp),%eax
 746:	83 c0 07             	add    $0x7,%eax
 749:	c1 e8 03             	shr    $0x3,%eax
 74c:	83 c0 01             	add    $0x1,%eax
 74f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 752:	a1 98 0a 00 00       	mov    0xa98,%eax
 757:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75e:	75 23                	jne    783 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 760:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	a3 98 0a 00 00       	mov    %eax,0xa98
 76f:	a1 98 0a 00 00       	mov    0xa98,%eax
 774:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 779:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 780:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 45 f0             	mov    -0x10(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 794:	72 4d                	jb     7e3 <malloc+0xa6>
      if(p->s.size == nunits)
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79f:	75 0c                	jne    7ad <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
 7ab:	eb 26                	jmp    7d3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7b6:	89 c2                	mov    %eax,%edx
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	c1 e0 03             	shl    $0x3,%eax
 7c7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void*)(p + 1);
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	83 c0 08             	add    $0x8,%eax
 7e1:	eb 38                	jmp    81b <malloc+0xde>
    }
    if(p == freep)
 7e3:	a1 98 0a 00 00       	mov    0xa98,%eax
 7e8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7eb:	75 1b                	jne    808 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f0:	89 04 24             	mov    %eax,(%esp)
 7f3:	e8 ed fe ff ff       	call   6e5 <morecore>
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ff:	75 07                	jne    808 <malloc+0xcb>
        return 0;
 801:	b8 00 00 00 00       	mov    $0x0,%eax
 806:	eb 13                	jmp    81b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 816:	e9 70 ff ff ff       	jmp    78b <malloc+0x4e>
}
 81b:	c9                   	leave  
 81c:	c3                   	ret    
