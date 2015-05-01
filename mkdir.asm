
_mkdir:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 45 08 00 	movl   $0x845,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 55 04 00 00       	call   478 <printf>
    exit();
  23:	e8 d0 02 00 00       	call   2f8 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 14 03 00 00       	call   360 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 5c 08 00 	movl   $0x85c,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 fe 03 00 00       	call   478 <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 69 02 00 00       	call   2f8 <exit>
  8f:	90                   	nop

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	88 10                	mov    %dl,(%eax)
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 08                	jmp    f2 <strcmp+0xd>
    p++, q++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 10                	je     10c <strcmp+0x27>
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	38 c2                	cmp    %al,%dl
 10a:	74 de                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 d0             	movzbl %al,%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	29 c2                	sub    %eax,%edx
 120:	89 d0                	mov    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 131:	eb 04                	jmp    137 <strlen+0x13>
 133:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 137:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 ed                	jne    133 <strlen+0xf>
    ;
  return n;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <memset>:

void*
memset(void *dst, int c, uint n)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 151:	8b 45 10             	mov    0x10(%ebp),%eax
 154:	89 44 24 08          	mov    %eax,0x8(%esp)
 158:	8b 45 0c             	mov    0xc(%ebp),%eax
 15b:	89 44 24 04          	mov    %eax,0x4(%esp)
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	89 04 24             	mov    %eax,(%esp)
 165:	e8 26 ff ff ff       	call   90 <stosb>
  return dst;
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16d:	c9                   	leave  
 16e:	c3                   	ret    

0000016f <strchr>:

char*
strchr(const char *s, char c)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	83 ec 04             	sub    $0x4,%esp
 175:	8b 45 0c             	mov    0xc(%ebp),%eax
 178:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17b:	eb 14                	jmp    191 <strchr+0x22>
    if(*s == c)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	3a 45 fc             	cmp    -0x4(%ebp),%al
 186:	75 05                	jne    18d <strchr+0x1e>
      return (char*)s;
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	eb 13                	jmp    1a0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	84 c0                	test   %al,%al
 199:	75 e2                	jne    17d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a0:	c9                   	leave  
 1a1:	c3                   	ret    

000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1af:	eb 4c                	jmp    1fd <gets+0x5b>
    cc = read(0, &c, 1);
 1b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b8:	00 
 1b9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c7:	e8 44 01 00 00       	call   310 <read>
 1cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d3:	7f 02                	jg     1d7 <gets+0x35>
      break;
 1d5:	eb 31                	jmp    208 <gets+0x66>
    buf[i++] = c;
 1d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1da:	8d 50 01             	lea    0x1(%eax),%edx
 1dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e0:	89 c2                	mov    %eax,%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 c2                	add    %eax,%edx
 1e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1eb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ed:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f1:	3c 0a                	cmp    $0xa,%al
 1f3:	74 13                	je     208 <gets+0x66>
 1f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f9:	3c 0d                	cmp    $0xd,%al
 1fb:	74 0b                	je     208 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 200:	83 c0 01             	add    $0x1,%eax
 203:	3b 45 0c             	cmp    0xc(%ebp),%eax
 206:	7c a9                	jl     1b1 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 208:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	01 d0                	add    %edx,%eax
 210:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <stat>:

int
stat(char *n, struct stat *st)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 225:	00 
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	89 04 24             	mov    %eax,(%esp)
 22c:	e8 07 01 00 00       	call   338 <open>
 231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 238:	79 07                	jns    241 <stat+0x29>
    return -1;
 23a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23f:	eb 23                	jmp    264 <stat+0x4c>
  r = fstat(fd, st);
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	89 44 24 04          	mov    %eax,0x4(%esp)
 248:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24b:	89 04 24             	mov    %eax,(%esp)
 24e:	e8 fd 00 00 00       	call   350 <fstat>
 253:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	89 04 24             	mov    %eax,(%esp)
 25c:	e8 bf 00 00 00       	call   320 <close>
  return r;
 261:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <atoi>:

int
atoi(const char *s)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 273:	eb 25                	jmp    29a <atoi+0x34>
    n = n*10 + *s++ - '0';
 275:	8b 55 fc             	mov    -0x4(%ebp),%edx
 278:	89 d0                	mov    %edx,%eax
 27a:	c1 e0 02             	shl    $0x2,%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	01 c0                	add    %eax,%eax
 281:	89 c1                	mov    %eax,%ecx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	8d 50 01             	lea    0x1(%eax),%edx
 289:	89 55 08             	mov    %edx,0x8(%ebp)
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	0f be c0             	movsbl %al,%eax
 292:	01 c8                	add    %ecx,%eax
 294:	83 e8 30             	sub    $0x30,%eax
 297:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	0f b6 00             	movzbl (%eax),%eax
 2a0:	3c 2f                	cmp    $0x2f,%al
 2a2:	7e 0a                	jle    2ae <atoi+0x48>
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	0f b6 00             	movzbl (%eax),%eax
 2aa:	3c 39                	cmp    $0x39,%al
 2ac:	7e c7                	jle    275 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c5:	eb 17                	jmp    2de <memmove+0x2b>
    *dst++ = *src++;
 2c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d9:	0f b6 12             	movzbl (%edx),%edx
 2dc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	8b 45 10             	mov    0x10(%ebp),%eax
 2e1:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e4:	89 55 10             	mov    %edx,0x10(%ebp)
 2e7:	85 c0                	test   %eax,%eax
 2e9:	7f dc                	jg     2c7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ee:	c9                   	leave  
 2ef:	c3                   	ret    

000002f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exit>:
SYSCALL(exit)
 2f8:	b8 02 00 00 00       	mov    $0x2,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <wait>:
SYSCALL(wait)
 300:	b8 03 00 00 00       	mov    $0x3,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <pipe>:
SYSCALL(pipe)
 308:	b8 04 00 00 00       	mov    $0x4,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <read>:
SYSCALL(read)
 310:	b8 05 00 00 00       	mov    $0x5,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <write>:
SYSCALL(write)
 318:	b8 10 00 00 00       	mov    $0x10,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <close>:
SYSCALL(close)
 320:	b8 15 00 00 00       	mov    $0x15,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <kill>:
SYSCALL(kill)
 328:	b8 06 00 00 00       	mov    $0x6,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exec>:
SYSCALL(exec)
 330:	b8 07 00 00 00       	mov    $0x7,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <open>:
SYSCALL(open)
 338:	b8 0f 00 00 00       	mov    $0xf,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <mknod>:
SYSCALL(mknod)
 340:	b8 11 00 00 00       	mov    $0x11,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <unlink>:
SYSCALL(unlink)
 348:	b8 12 00 00 00       	mov    $0x12,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <fstat>:
SYSCALL(fstat)
 350:	b8 08 00 00 00       	mov    $0x8,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <link>:
SYSCALL(link)
 358:	b8 13 00 00 00       	mov    $0x13,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <mkdir>:
SYSCALL(mkdir)
 360:	b8 14 00 00 00       	mov    $0x14,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <chdir>:
SYSCALL(chdir)
 368:	b8 09 00 00 00       	mov    $0x9,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup>:
SYSCALL(dup)
 370:	b8 0a 00 00 00       	mov    $0xa,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getpid>:
SYSCALL(getpid)
 378:	b8 0b 00 00 00       	mov    $0xb,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <sbrk>:
SYSCALL(sbrk)
 380:	b8 0c 00 00 00       	mov    $0xc,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sleep>:
SYSCALL(sleep)
 388:	b8 0d 00 00 00       	mov    $0xd,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <uptime>:
SYSCALL(uptime)
 390:	b8 0e 00 00 00       	mov    $0xe,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 18             	sub    $0x18,%esp
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ab:	00 
 3ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3af:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	89 04 24             	mov    %eax,(%esp)
 3b9:	e8 5a ff ff ff       	call   318 <write>
}
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
 3c5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d3:	74 17                	je     3ec <printint+0x2c>
 3d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d9:	79 11                	jns    3ec <printint+0x2c>
    neg = 1;
 3db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	f7 d8                	neg    %eax
 3e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ea:	eb 06                	jmp    3f2 <printint+0x32>
  } else {
    x = xx;
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fc:	8d 41 01             	lea    0x1(%ecx),%eax
 3ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 402:	8b 5d 10             	mov    0x10(%ebp),%ebx
 405:	8b 45 ec             	mov    -0x14(%ebp),%eax
 408:	ba 00 00 00 00       	mov    $0x0,%edx
 40d:	f7 f3                	div    %ebx
 40f:	89 d0                	mov    %edx,%eax
 411:	0f b6 80 c4 0a 00 00 	movzbl 0xac4(%eax),%eax
 418:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41c:	8b 75 10             	mov    0x10(%ebp),%esi
 41f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 422:	ba 00 00 00 00       	mov    $0x0,%edx
 427:	f7 f6                	div    %esi
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 430:	75 c7                	jne    3f9 <printint+0x39>
  if(neg)
 432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 436:	74 10                	je     448 <printint+0x88>
    buf[i++] = '-';
 438:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43b:	8d 50 01             	lea    0x1(%eax),%edx
 43e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 441:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 446:	eb 1f                	jmp    467 <printint+0xa7>
 448:	eb 1d                	jmp    467 <printint+0xa7>
    putc(fd, buf[i]);
 44a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	01 d0                	add    %edx,%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	0f be c0             	movsbl %al,%eax
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	89 04 24             	mov    %eax,(%esp)
 462:	e8 31 ff ff ff       	call   398 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 467:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46f:	79 d9                	jns    44a <printint+0x8a>
    putc(fd, buf[i]);
}
 471:	83 c4 30             	add    $0x30,%esp
 474:	5b                   	pop    %ebx
 475:	5e                   	pop    %esi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret    

00000478 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 485:	8d 45 0c             	lea    0xc(%ebp),%eax
 488:	83 c0 04             	add    $0x4,%eax
 48b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 495:	e9 7c 01 00 00       	jmp    616 <printf+0x19e>
    c = fmt[i] & 0xff;
 49a:	8b 55 0c             	mov    0xc(%ebp),%edx
 49d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a0:	01 d0                	add    %edx,%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	0f be c0             	movsbl %al,%eax
 4a8:	25 ff 00 00 00       	and    $0xff,%eax
 4ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b4:	75 2c                	jne    4e2 <printf+0x6a>
      if(c == '%'){
 4b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ba:	75 0c                	jne    4c8 <printf+0x50>
        state = '%';
 4bc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c3:	e9 4a 01 00 00       	jmp    612 <printf+0x19a>
      } else {
        putc(fd, c);
 4c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cb:	0f be c0             	movsbl %al,%eax
 4ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	89 04 24             	mov    %eax,(%esp)
 4d8:	e8 bb fe ff ff       	call   398 <putc>
 4dd:	e9 30 01 00 00       	jmp    612 <printf+0x19a>
      }
    } else if(state == '%'){
 4e2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e6:	0f 85 26 01 00 00    	jne    612 <printf+0x19a>
      if(c == 'd'){
 4ec:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f0:	75 2d                	jne    51f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f5:	8b 00                	mov    (%eax),%eax
 4f7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4fe:	00 
 4ff:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 506:	00 
 507:	89 44 24 04          	mov    %eax,0x4(%esp)
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	89 04 24             	mov    %eax,(%esp)
 511:	e8 aa fe ff ff       	call   3c0 <printint>
        ap++;
 516:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51a:	e9 ec 00 00 00       	jmp    60b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 51f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 523:	74 06                	je     52b <printf+0xb3>
 525:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 529:	75 2d                	jne    558 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 52b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 537:	00 
 538:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 53f:	00 
 540:	89 44 24 04          	mov    %eax,0x4(%esp)
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 71 fe ff ff       	call   3c0 <printint>
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 553:	e9 b3 00 00 00       	jmp    60b <printf+0x193>
      } else if(c == 's'){
 558:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55c:	75 45                	jne    5a3 <printf+0x12b>
        s = (char*)*ap;
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 566:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56e:	75 09                	jne    579 <printf+0x101>
          s = "(null)";
 570:	c7 45 f4 78 08 00 00 	movl   $0x878,-0xc(%ebp)
        while(*s != 0){
 577:	eb 1e                	jmp    597 <printf+0x11f>
 579:	eb 1c                	jmp    597 <printf+0x11f>
          putc(fd, *s);
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 05 fe ff ff       	call   398 <putc>
          s++;
 593:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 597:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59a:	0f b6 00             	movzbl (%eax),%eax
 59d:	84 c0                	test   %al,%al
 59f:	75 da                	jne    57b <printf+0x103>
 5a1:	eb 68                	jmp    60b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a7:	75 1d                	jne    5c6 <printf+0x14e>
        putc(fd, *ap);
 5a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	89 04 24             	mov    %eax,(%esp)
 5bb:	e8 d8 fd ff ff       	call   398 <putc>
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c4:	eb 45                	jmp    60b <printf+0x193>
      } else if(c == '%'){
 5c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ca:	75 17                	jne    5e3 <printf+0x16b>
        putc(fd, c);
 5cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 b7 fd ff ff       	call   398 <putc>
 5e1:	eb 28                	jmp    60b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ea:	00 
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 04 24             	mov    %eax,(%esp)
 5f1:	e8 a2 fd ff ff       	call   398 <putc>
        putc(fd, c);
 5f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 8d fd ff ff       	call   398 <putc>
      }
      state = 0;
 60b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 612:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 616:	8b 55 0c             	mov    0xc(%ebp),%edx
 619:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61c:	01 d0                	add    %edx,%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	84 c0                	test   %al,%al
 623:	0f 85 71 fe ff ff    	jne    49a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 629:	c9                   	leave  
 62a:	c3                   	ret    
 62b:	90                   	nop

0000062c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62c:	55                   	push   %ebp
 62d:	89 e5                	mov    %esp,%ebp
 62f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	83 e8 08             	sub    $0x8,%eax
 638:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	a1 e0 0a 00 00       	mov    0xae0,%eax
 640:	89 45 fc             	mov    %eax,-0x4(%ebp)
 643:	eb 24                	jmp    669 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	77 12                	ja     661 <free+0x35>
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	77 24                	ja     67b <free+0x4f>
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	77 1a                	ja     67b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	89 45 fc             	mov    %eax,-0x4(%ebp)
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66f:	76 d4                	jbe    645 <free+0x19>
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	76 ca                	jbe    645 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 40 04             	mov    0x4(%eax),%eax
 681:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	01 c2                	add    %eax,%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	39 c2                	cmp    %eax,%edx
 694:	75 24                	jne    6ba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
 6b8:	eb 0a                	jmp    6c4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d9:	75 20                	jne    6fb <free+0xcf>
    p->s.size += bp->s.size;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 10                	mov    (%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	89 10                	mov    %edx,(%eax)
 6f9:	eb 08                	jmp    703 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 701:	89 10                	mov    %edx,(%eax)
  freep = p;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <morecore>:

static Header*
morecore(uint nu)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71a:	77 07                	ja     723 <morecore+0x16>
    nu = 4096;
 71c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 723:	8b 45 08             	mov    0x8(%ebp),%eax
 726:	c1 e0 03             	shl    $0x3,%eax
 729:	89 04 24             	mov    %eax,(%esp)
 72c:	e8 4f fc ff ff       	call   380 <sbrk>
 731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 734:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 738:	75 07                	jne    741 <morecore+0x34>
    return 0;
 73a:	b8 00 00 00 00       	mov    $0x0,%eax
 73f:	eb 22                	jmp    763 <morecore+0x56>
  hp = (Header*)p;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	8b 55 08             	mov    0x8(%ebp),%edx
 74d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 750:	8b 45 f0             	mov    -0x10(%ebp),%eax
 753:	83 c0 08             	add    $0x8,%eax
 756:	89 04 24             	mov    %eax,(%esp)
 759:	e8 ce fe ff ff       	call   62c <free>
  return freep;
 75e:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 763:	c9                   	leave  
 764:	c3                   	ret    

00000765 <malloc>:

void*
malloc(uint nbytes)
{
 765:	55                   	push   %ebp
 766:	89 e5                	mov    %esp,%ebp
 768:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	83 c0 07             	add    $0x7,%eax
 771:	c1 e8 03             	shr    $0x3,%eax
 774:	83 c0 01             	add    $0x1,%eax
 777:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 77a:	a1 e0 0a 00 00       	mov    0xae0,%eax
 77f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 782:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 786:	75 23                	jne    7ab <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 788:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	a3 e0 0a 00 00       	mov    %eax,0xae0
 797:	a1 e0 0a 00 00       	mov    0xae0,%eax
 79c:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 7a1:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7a8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bc:	72 4d                	jb     80b <malloc+0xa6>
      if(p->s.size == nunits)
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c7:	75 0c                	jne    7d5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 10                	mov    (%eax),%edx
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	89 10                	mov    %edx,(%eax)
 7d3:	eb 26                	jmp    7fb <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7de:	89 c2                	mov    %eax,%edx
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	c1 e0 03             	shl    $0x3,%eax
 7ef:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	83 c0 08             	add    $0x8,%eax
 809:	eb 38                	jmp    843 <malloc+0xde>
    }
    if(p == freep)
 80b:	a1 e0 0a 00 00       	mov    0xae0,%eax
 810:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 813:	75 1b                	jne    830 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 815:	8b 45 ec             	mov    -0x14(%ebp),%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 ed fe ff ff       	call   70d <morecore>
 820:	89 45 f4             	mov    %eax,-0xc(%ebp)
 823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 827:	75 07                	jne    830 <malloc+0xcb>
        return 0;
 829:	b8 00 00 00 00       	mov    $0x0,%eax
 82e:	eb 13                	jmp    843 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	89 45 f0             	mov    %eax,-0x10(%ebp)
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83e:	e9 70 ff ff ff       	jmp    7b3 <malloc+0x4e>
}
 843:	c9                   	leave  
 844:	c3                   	ret    
