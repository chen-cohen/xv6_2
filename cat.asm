
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 85 03 00 00       	call   3a8 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 62 03 00 00       	call   3a0 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 d5 08 00 	movl   $0x8d5,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 a7 04 00 00       	call   508 <printf>
    exit();
  61:	e8 22 03 00 00       	call   388 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 00 03 00 00       	call   388 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 14 03 00 00       	call   3c8 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 e6 08 00 	movl   $0x8e6,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 1f 04 00 00       	call   508 <printf>
      exit();
  e9:	e8 9a 02 00 00       	call   388 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 aa 02 00 00       	call   3b0 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 6b 02 00 00       	call   388 <exit>
 11d:	66 90                	xchg   %ax,%ax
 11f:	90                   	nop

00000120 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 125:	8b 4d 08             	mov    0x8(%ebp),%ecx
 128:	8b 55 10             	mov    0x10(%ebp),%edx
 12b:	8b 45 0c             	mov    0xc(%ebp),%eax
 12e:	89 cb                	mov    %ecx,%ebx
 130:	89 df                	mov    %ebx,%edi
 132:	89 d1                	mov    %edx,%ecx
 134:	fc                   	cld    
 135:	f3 aa                	rep stos %al,%es:(%edi)
 137:	89 ca                	mov    %ecx,%edx
 139:	89 fb                	mov    %edi,%ebx
 13b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 141:	5b                   	pop    %ebx
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 151:	90                   	nop
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	8d 50 01             	lea    0x1(%eax),%edx
 158:	89 55 08             	mov    %edx,0x8(%ebp)
 15b:	8b 55 0c             	mov    0xc(%ebp),%edx
 15e:	8d 4a 01             	lea    0x1(%edx),%ecx
 161:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 164:	0f b6 12             	movzbl (%edx),%edx
 167:	88 10                	mov    %dl,(%eax)
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	84 c0                	test   %al,%al
 16e:	75 e2                	jne    152 <strcpy+0xd>
    ;
  return os;
 170:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 173:	c9                   	leave  
 174:	c3                   	ret    

00000175 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 178:	eb 08                	jmp    182 <strcmp+0xd>
    p++, q++;
 17a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	74 10                	je     19c <strcmp+0x27>
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 10             	movzbl (%eax),%edx
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	0f b6 00             	movzbl (%eax),%eax
 198:	38 c2                	cmp    %al,%dl
 19a:	74 de                	je     17a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	0f b6 d0             	movzbl %al,%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	0f b6 00             	movzbl (%eax),%eax
 1ab:	0f b6 c0             	movzbl %al,%eax
 1ae:	29 c2                	sub    %eax,%edx
 1b0:	89 d0                	mov    %edx,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <strlen>:

uint
strlen(char *s)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c1:	eb 04                	jmp    1c7 <strlen+0x13>
 1c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	01 d0                	add    %edx,%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	84 c0                	test   %al,%al
 1d4:	75 ed                	jne    1c3 <strlen+0xf>
    ;
  return n;
 1d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <memset>:

void*
memset(void *dst, int c, uint n)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e1:	8b 45 10             	mov    0x10(%ebp),%eax
 1e4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 04 24             	mov    %eax,(%esp)
 1f5:	e8 26 ff ff ff       	call   120 <stosb>
  return dst;
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fd:	c9                   	leave  
 1fe:	c3                   	ret    

000001ff <strchr>:

char*
strchr(const char *s, char c)
{
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
 202:	83 ec 04             	sub    $0x4,%esp
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20b:	eb 14                	jmp    221 <strchr+0x22>
    if(*s == c)
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	3a 45 fc             	cmp    -0x4(%ebp),%al
 216:	75 05                	jne    21d <strchr+0x1e>
      return (char*)s;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	eb 13                	jmp    230 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	84 c0                	test   %al,%al
 229:	75 e2                	jne    20d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <gets>:

char*
gets(char *buf, int max)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23f:	eb 4c                	jmp    28d <gets+0x5b>
    cc = read(0, &c, 1);
 241:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 248:	00 
 249:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24c:	89 44 24 04          	mov    %eax,0x4(%esp)
 250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 257:	e8 44 01 00 00       	call   3a0 <read>
 25c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 263:	7f 02                	jg     267 <gets+0x35>
      break;
 265:	eb 31                	jmp    298 <gets+0x66>
    buf[i++] = c;
 267:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26a:	8d 50 01             	lea    0x1(%eax),%edx
 26d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 270:	89 c2                	mov    %eax,%edx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	01 c2                	add    %eax,%edx
 277:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 281:	3c 0a                	cmp    $0xa,%al
 283:	74 13                	je     298 <gets+0x66>
 285:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 289:	3c 0d                	cmp    $0xd,%al
 28b:	74 0b                	je     298 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 290:	83 c0 01             	add    $0x1,%eax
 293:	3b 45 0c             	cmp    0xc(%ebp),%eax
 296:	7c a9                	jl     241 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 298:	8b 55 f4             	mov    -0xc(%ebp),%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <stat>:

int
stat(char *n, struct stat *st)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b5:	00 
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	89 04 24             	mov    %eax,(%esp)
 2bc:	e8 07 01 00 00       	call   3c8 <open>
 2c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c8:	79 07                	jns    2d1 <stat+0x29>
    return -1;
 2ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cf:	eb 23                	jmp    2f4 <stat+0x4c>
  r = fstat(fd, st);
 2d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 fd 00 00 00       	call   3e0 <fstat>
 2e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e9:	89 04 24             	mov    %eax,(%esp)
 2ec:	e8 bf 00 00 00       	call   3b0 <close>
  return r;
 2f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 303:	eb 25                	jmp    32a <atoi+0x34>
    n = n*10 + *s++ - '0';
 305:	8b 55 fc             	mov    -0x4(%ebp),%edx
 308:	89 d0                	mov    %edx,%eax
 30a:	c1 e0 02             	shl    $0x2,%eax
 30d:	01 d0                	add    %edx,%eax
 30f:	01 c0                	add    %eax,%eax
 311:	89 c1                	mov    %eax,%ecx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 08             	mov    %edx,0x8(%ebp)
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	0f be c0             	movsbl %al,%eax
 322:	01 c8                	add    %ecx,%eax
 324:	83 e8 30             	sub    $0x30,%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	3c 2f                	cmp    $0x2f,%al
 332:	7e 0a                	jle    33e <atoi+0x48>
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	3c 39                	cmp    $0x39,%al
 33c:	7e c7                	jle    305 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 355:	eb 17                	jmp    36e <memmove+0x2b>
    *dst++ = *src++;
 357:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35a:	8d 50 01             	lea    0x1(%eax),%edx
 35d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 360:	8b 55 f8             	mov    -0x8(%ebp),%edx
 363:	8d 4a 01             	lea    0x1(%edx),%ecx
 366:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 369:	0f b6 12             	movzbl (%edx),%edx
 36c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36e:	8b 45 10             	mov    0x10(%ebp),%eax
 371:	8d 50 ff             	lea    -0x1(%eax),%edx
 374:	89 55 10             	mov    %edx,0x10(%ebp)
 377:	85 c0                	test   %eax,%eax
 379:	7f dc                	jg     357 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 380:	b8 01 00 00 00       	mov    $0x1,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exit>:
SYSCALL(exit)
 388:	b8 02 00 00 00       	mov    $0x2,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <wait>:
SYSCALL(wait)
 390:	b8 03 00 00 00       	mov    $0x3,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <pipe>:
SYSCALL(pipe)
 398:	b8 04 00 00 00       	mov    $0x4,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <read>:
SYSCALL(read)
 3a0:	b8 05 00 00 00       	mov    $0x5,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <write>:
SYSCALL(write)
 3a8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <close>:
SYSCALL(close)
 3b0:	b8 15 00 00 00       	mov    $0x15,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <kill>:
SYSCALL(kill)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exec>:
SYSCALL(exec)
 3c0:	b8 07 00 00 00       	mov    $0x7,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <open>:
SYSCALL(open)
 3c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <mknod>:
SYSCALL(mknod)
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <unlink>:
SYSCALL(unlink)
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <fstat>:
SYSCALL(fstat)
 3e0:	b8 08 00 00 00       	mov    $0x8,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <link>:
SYSCALL(link)
 3e8:	b8 13 00 00 00       	mov    $0x13,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mkdir>:
SYSCALL(mkdir)
 3f0:	b8 14 00 00 00       	mov    $0x14,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <chdir>:
SYSCALL(chdir)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <dup>:
SYSCALL(dup)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getpid>:
SYSCALL(getpid)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <sbrk>:
SYSCALL(sbrk)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <sleep>:
SYSCALL(sleep)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <uptime>:
SYSCALL(uptime)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	83 ec 18             	sub    $0x18,%esp
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 434:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43b:	00 
 43c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43f:	89 44 24 04          	mov    %eax,0x4(%esp)
 443:	8b 45 08             	mov    0x8(%ebp),%eax
 446:	89 04 24             	mov    %eax,(%esp)
 449:	e8 5a ff ff ff       	call   3a8 <write>
}
 44e:	c9                   	leave  
 44f:	c3                   	ret    

00000450 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
 455:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 458:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 463:	74 17                	je     47c <printint+0x2c>
 465:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 469:	79 11                	jns    47c <printint+0x2c>
    neg = 1;
 46b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	f7 d8                	neg    %eax
 477:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47a:	eb 06                	jmp    482 <printint+0x32>
  } else {
    x = xx;
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 489:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 48c:	8d 41 01             	lea    0x1(%ecx),%eax
 48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 492:	8b 5d 10             	mov    0x10(%ebp),%ebx
 495:	8b 45 ec             	mov    -0x14(%ebp),%eax
 498:	ba 00 00 00 00       	mov    $0x0,%edx
 49d:	f7 f3                	div    %ebx
 49f:	89 d0                	mov    %edx,%eax
 4a1:	0f b6 80 68 0b 00 00 	movzbl 0xb68(%eax),%eax
 4a8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ac:	8b 75 10             	mov    0x10(%ebp),%esi
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f6                	div    %esi
 4b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c0:	75 c7                	jne    489 <printint+0x39>
  if(neg)
 4c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c6:	74 10                	je     4d8 <printint+0x88>
    buf[i++] = '-';
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	8d 50 01             	lea    0x1(%eax),%edx
 4ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d6:	eb 1f                	jmp    4f7 <printint+0xa7>
 4d8:	eb 1d                	jmp    4f7 <printint+0xa7>
    putc(fd, buf[i]);
 4da:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e0:	01 d0                	add    %edx,%eax
 4e2:	0f b6 00             	movzbl (%eax),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	89 04 24             	mov    %eax,(%esp)
 4f2:	e8 31 ff ff ff       	call   428 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	79 d9                	jns    4da <printint+0x8a>
    putc(fd, buf[i]);
}
 501:	83 c4 30             	add    $0x30,%esp
 504:	5b                   	pop    %ebx
 505:	5e                   	pop    %esi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    

00000508 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 508:	55                   	push   %ebp
 509:	89 e5                	mov    %esp,%ebp
 50b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 515:	8d 45 0c             	lea    0xc(%ebp),%eax
 518:	83 c0 04             	add    $0x4,%eax
 51b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 525:	e9 7c 01 00 00       	jmp    6a6 <printf+0x19e>
    c = fmt[i] & 0xff;
 52a:	8b 55 0c             	mov    0xc(%ebp),%edx
 52d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 530:	01 d0                	add    %edx,%eax
 532:	0f b6 00             	movzbl (%eax),%eax
 535:	0f be c0             	movsbl %al,%eax
 538:	25 ff 00 00 00       	and    $0xff,%eax
 53d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 540:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 544:	75 2c                	jne    572 <printf+0x6a>
      if(c == '%'){
 546:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54a:	75 0c                	jne    558 <printf+0x50>
        state = '%';
 54c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 553:	e9 4a 01 00 00       	jmp    6a2 <printf+0x19a>
      } else {
        putc(fd, c);
 558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	89 44 24 04          	mov    %eax,0x4(%esp)
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	89 04 24             	mov    %eax,(%esp)
 568:	e8 bb fe ff ff       	call   428 <putc>
 56d:	e9 30 01 00 00       	jmp    6a2 <printf+0x19a>
      }
    } else if(state == '%'){
 572:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 576:	0f 85 26 01 00 00    	jne    6a2 <printf+0x19a>
      if(c == 'd'){
 57c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 580:	75 2d                	jne    5af <printf+0xa7>
        printint(fd, *ap, 10, 1);
 582:	8b 45 e8             	mov    -0x18(%ebp),%eax
 585:	8b 00                	mov    (%eax),%eax
 587:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 58e:	00 
 58f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 596:	00 
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	89 04 24             	mov    %eax,(%esp)
 5a1:	e8 aa fe ff ff       	call   450 <printint>
        ap++;
 5a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5aa:	e9 ec 00 00 00       	jmp    69b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5af:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b3:	74 06                	je     5bb <printf+0xb3>
 5b5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b9:	75 2d                	jne    5e8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c7:	00 
 5c8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5cf:	00 
 5d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 71 fe ff ff       	call   450 <printint>
        ap++;
 5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e3:	e9 b3 00 00 00       	jmp    69b <printf+0x193>
      } else if(c == 's'){
 5e8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ec:	75 45                	jne    633 <printf+0x12b>
        s = (char*)*ap;
 5ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fe:	75 09                	jne    609 <printf+0x101>
          s = "(null)";
 600:	c7 45 f4 fb 08 00 00 	movl   $0x8fb,-0xc(%ebp)
        while(*s != 0){
 607:	eb 1e                	jmp    627 <printf+0x11f>
 609:	eb 1c                	jmp    627 <printf+0x11f>
          putc(fd, *s);
 60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	0f be c0             	movsbl %al,%eax
 614:	89 44 24 04          	mov    %eax,0x4(%esp)
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	89 04 24             	mov    %eax,(%esp)
 61e:	e8 05 fe ff ff       	call   428 <putc>
          s++;
 623:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 627:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	84 c0                	test   %al,%al
 62f:	75 da                	jne    60b <printf+0x103>
 631:	eb 68                	jmp    69b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 633:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 637:	75 1d                	jne    656 <printf+0x14e>
        putc(fd, *ap);
 639:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	89 44 24 04          	mov    %eax,0x4(%esp)
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	89 04 24             	mov    %eax,(%esp)
 64b:	e8 d8 fd ff ff       	call   428 <putc>
        ap++;
 650:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 654:	eb 45                	jmp    69b <printf+0x193>
      } else if(c == '%'){
 656:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 65a:	75 17                	jne    673 <printf+0x16b>
        putc(fd, c);
 65c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	89 44 24 04          	mov    %eax,0x4(%esp)
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	89 04 24             	mov    %eax,(%esp)
 66c:	e8 b7 fd ff ff       	call   428 <putc>
 671:	eb 28                	jmp    69b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 673:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 67a:	00 
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 a2 fd ff ff       	call   428 <putc>
        putc(fd, c);
 686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	89 44 24 04          	mov    %eax,0x4(%esp)
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 8d fd ff ff       	call   428 <putc>
      }
      state = 0;
 69b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	0f b6 00             	movzbl (%eax),%eax
 6b1:	84 c0                	test   %al,%al
 6b3:	0f 85 71 fe ff ff    	jne    52a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b9:	c9                   	leave  
 6ba:	c3                   	ret    
 6bb:	90                   	nop

000006bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6bc:	55                   	push   %ebp
 6bd:	89 e5                	mov    %esp,%ebp
 6bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	83 e8 08             	sub    $0x8,%eax
 6c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cb:	a1 88 0b 00 00       	mov    0xb88,%eax
 6d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d3:	eb 24                	jmp    6f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6dd:	77 12                	ja     6f1 <free+0x35>
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e5:	77 24                	ja     70b <free+0x4f>
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ef:	77 1a                	ja     70b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ff:	76 d4                	jbe    6d5 <free+0x19>
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 709:	76 ca                	jbe    6d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	8b 40 04             	mov    0x4(%eax),%eax
 711:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	01 c2                	add    %eax,%edx
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	39 c2                	cmp    %eax,%edx
 724:	75 24                	jne    74a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 50 04             	mov    0x4(%eax),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
 748:	eb 0a                	jmp    754 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 10                	mov    (%eax),%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	01 d0                	add    %edx,%eax
 766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 769:	75 20                	jne    78b <free+0xcf>
    p->s.size += bp->s.size;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 50 04             	mov    0x4(%eax),%edx
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	01 c2                	add    %eax,%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	89 10                	mov    %edx,(%eax)
 789:	eb 08                	jmp    793 <free+0xd7>
  } else
    p->s.ptr = bp;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 791:	89 10                	mov    %edx,(%eax)
  freep = p;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 79b:	c9                   	leave  
 79c:	c3                   	ret    

0000079d <morecore>:

static Header*
morecore(uint nu)
{
 79d:	55                   	push   %ebp
 79e:	89 e5                	mov    %esp,%ebp
 7a0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7aa:	77 07                	ja     7b3 <morecore+0x16>
    nu = 4096;
 7ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	89 04 24             	mov    %eax,(%esp)
 7bc:	e8 4f fc ff ff       	call   410 <sbrk>
 7c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c8:	75 07                	jne    7d1 <morecore+0x34>
    return 0;
 7ca:	b8 00 00 00 00       	mov    $0x0,%eax
 7cf:	eb 22                	jmp    7f3 <morecore+0x56>
  hp = (Header*)p;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	8b 55 08             	mov    0x8(%ebp),%edx
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	83 c0 08             	add    $0x8,%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 ce fe ff ff       	call   6bc <free>
  return freep;
 7ee:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <malloc>:

void*
malloc(uint nbytes)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	83 c0 07             	add    $0x7,%eax
 801:	c1 e8 03             	shr    $0x3,%eax
 804:	83 c0 01             	add    $0x1,%eax
 807:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80a:	a1 88 0b 00 00       	mov    0xb88,%eax
 80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 812:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 816:	75 23                	jne    83b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 818:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 81f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 822:	a3 88 0b 00 00       	mov    %eax,0xb88
 827:	a1 88 0b 00 00       	mov    0xb88,%eax
 82c:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 831:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 838:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84c:	72 4d                	jb     89b <malloc+0xa6>
      if(p->s.size == nunits)
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 857:	75 0c                	jne    865 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 10                	mov    (%eax),%edx
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	89 10                	mov    %edx,(%eax)
 863:	eb 26                	jmp    88b <malloc+0x96>
      else {
        p->s.size -= nunits;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 40 04             	mov    0x4(%eax),%eax
 86b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86e:	89 c2                	mov    %eax,%edx
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	c1 e0 03             	shl    $0x3,%eax
 87f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 55 ec             	mov    -0x14(%ebp),%edx
 888:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	83 c0 08             	add    $0x8,%eax
 899:	eb 38                	jmp    8d3 <malloc+0xde>
    }
    if(p == freep)
 89b:	a1 88 0b 00 00       	mov    0xb88,%eax
 8a0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a3:	75 1b                	jne    8c0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a8:	89 04 24             	mov    %eax,(%esp)
 8ab:	e8 ed fe ff ff       	call   79d <morecore>
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <malloc+0xcb>
        return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 13                	jmp    8d3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ce:	e9 70 ff ff ff       	jmp    843 <malloc+0x4e>
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    
