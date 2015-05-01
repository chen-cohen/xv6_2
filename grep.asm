
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 bc 01 00 00       	call   1f5 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	29 c2                	sub    %eax,%edx
  50:	89 d0                	mov    %edx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 77 05 00 00       	call   5e0 <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	83 c0 01             	add    $0x1,%eax
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  79:	00 
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 b2 03 00 00       	call   437 <strchr>
  85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8e:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
  a4:	ba 60 0e 00 00       	mov    $0xe60,%edx
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	29 c2                	sub    %eax,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  c8:	e8 ae 04 00 00       	call   57b <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dc:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 e3 04 00 00       	call   5d8 <read>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 111:	7f 19                	jg     12c <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 113:	c7 44 24 04 10 0b 00 	movl   $0xb10,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 122:	e8 19 06 00 00       	call   740 <printf>
    exit();
 127:	e8 94 04 00 00       	call   5c0 <exit>
  }
  pattern = argv[1];
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	8b 40 04             	mov    0x4(%eax),%eax
 132:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 136:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 13a:	7f 19                	jg     155 <main+0x51>
    grep(pattern, 0);
 13c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 143:	00 
 144:	8b 44 24 18          	mov    0x18(%esp),%eax
 148:	89 04 24             	mov    %eax,(%esp)
 14b:	e8 b0 fe ff ff       	call   0 <grep>
    exit();
 150:	e8 6b 04 00 00       	call   5c0 <exit>
  }

  for(i = 2; i < argc; i++){
 155:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 15c:	00 
 15d:	e9 81 00 00 00       	jmp    1e3 <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 162:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	01 d0                	add    %edx,%eax
 172:	8b 00                	mov    (%eax),%eax
 174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17b:	00 
 17c:	89 04 24             	mov    %eax,(%esp)
 17f:	e8 7c 04 00 00       	call   600 <open>
 184:	89 44 24 14          	mov    %eax,0x14(%esp)
 188:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18d:	79 2f                	jns    1be <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 18f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 193:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	01 d0                	add    %edx,%eax
 19f:	8b 00                	mov    (%eax),%eax
 1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a5:	c7 44 24 04 30 0b 00 	movl   $0xb30,0x4(%esp)
 1ac:	00 
 1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b4:	e8 87 05 00 00       	call   740 <printf>
      exit();
 1b9:	e8 02 04 00 00       	call   5c0 <exit>
    }
    grep(pattern, fd);
 1be:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 2e fe ff ff       	call   0 <grep>
    close(fd);
 1d2:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 0a 04 00 00       	call   5e8 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1e3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e7:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ea:	0f 8c 72 ff ff ff    	jl     162 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f0:	e8 cb 03 00 00       	call   5c0 <exit>

000001f5 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	0f b6 00             	movzbl (%eax),%eax
 201:	3c 5e                	cmp    $0x5e,%al
 203:	75 17                	jne    21c <match+0x27>
    return matchhere(re+1, text);
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 50 01             	lea    0x1(%eax),%edx
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	89 14 24             	mov    %edx,(%esp)
 215:	e8 36 00 00 00       	call   250 <matchhere>
 21a:	eb 32                	jmp    24e <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 22 00 00 00       	call   250 <matchhere>
 22e:	85 c0                	test   %eax,%eax
 230:	74 07                	je     239 <match+0x44>
      return 1;
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	eb 15                	jmp    24e <match+0x59>
  }while(*text++ != '\0');
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8d 50 01             	lea    0x1(%eax),%edx
 23f:	89 55 0c             	mov    %edx,0xc(%ebp)
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 d3                	jne    21c <match+0x27>
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	84 c0                	test   %al,%al
 25e:	75 0a                	jne    26a <matchhere+0x1a>
    return 1;
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	e9 9b 00 00 00       	jmp    305 <matchhere+0xb5>
  if(re[1] == '*')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	83 c0 01             	add    $0x1,%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2a                	cmp    $0x2a,%al
 275:	75 24                	jne    29b <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8d 48 02             	lea    0x2(%eax),%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	0f b6 00             	movzbl (%eax),%eax
 283:	0f be c0             	movsbl %al,%eax
 286:	8b 55 0c             	mov    0xc(%ebp),%edx
 289:	89 54 24 08          	mov    %edx,0x8(%esp)
 28d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 6e 00 00 00       	call   307 <matchstar>
 299:	eb 6a                	jmp    305 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 24                	cmp    $0x24,%al
 2a3:	75 1d                	jne    2c2 <matchhere+0x72>
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	84 c0                	test   %al,%al
 2b0:	75 10                	jne    2c2 <matchhere+0x72>
    return *text == '\0';
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	84 c0                	test   %al,%al
 2ba:	0f 94 c0             	sete   %al
 2bd:	0f b6 c0             	movzbl %al,%eax
 2c0:	eb 43                	jmp    305 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	0f b6 00             	movzbl (%eax),%eax
 2c8:	84 c0                	test   %al,%al
 2ca:	74 34                	je     300 <matchhere+0xb0>
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	0f b6 00             	movzbl (%eax),%eax
 2d2:	3c 2e                	cmp    $0x2e,%al
 2d4:	74 10                	je     2e6 <matchhere+0x96>
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	0f b6 10             	movzbl (%eax),%edx
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	38 c2                	cmp    %al,%dl
 2e4:	75 1a                	jne    300 <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	8d 50 01             	lea    0x1(%eax),%edx
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	83 c0 01             	add    $0x1,%eax
 2f2:	89 54 24 04          	mov    %edx,0x4(%esp)
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 52 ff ff ff       	call   250 <matchhere>
 2fe:	eb 05                	jmp    305 <matchhere+0xb5>
  return 0;
 300:	b8 00 00 00 00       	mov    $0x0,%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 30d:	8b 45 10             	mov    0x10(%ebp),%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	8b 45 0c             	mov    0xc(%ebp),%eax
 317:	89 04 24             	mov    %eax,(%esp)
 31a:	e8 31 ff ff ff       	call   250 <matchhere>
 31f:	85 c0                	test   %eax,%eax
 321:	74 07                	je     32a <matchstar+0x23>
      return 1;
 323:	b8 01 00 00 00       	mov    $0x1,%eax
 328:	eb 29                	jmp    353 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	84 c0                	test   %al,%al
 332:	74 1a                	je     34e <matchstar+0x47>
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	3b 45 08             	cmp    0x8(%ebp),%eax
 346:	74 c5                	je     30d <matchstar+0x6>
 348:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 34c:	74 bf                	je     30d <matchstar+0x6>
  return 0;
 34e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    
 355:	66 90                	xchg   %ax,%ax
 357:	90                   	nop

00000358 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 360:	8b 55 10             	mov    0x10(%ebp),%edx
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	89 cb                	mov    %ecx,%ebx
 368:	89 df                	mov    %ebx,%edi
 36a:	89 d1                	mov    %edx,%ecx
 36c:	fc                   	cld    
 36d:	f3 aa                	rep stos %al,%es:(%edi)
 36f:	89 ca                	mov    %ecx,%edx
 371:	89 fb                	mov    %edi,%ebx
 373:	89 5d 08             	mov    %ebx,0x8(%ebp)
 376:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 379:	5b                   	pop    %ebx
 37a:	5f                   	pop    %edi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    

0000037d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 389:	90                   	nop
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	8d 50 01             	lea    0x1(%eax),%edx
 390:	89 55 08             	mov    %edx,0x8(%ebp)
 393:	8b 55 0c             	mov    0xc(%ebp),%edx
 396:	8d 4a 01             	lea    0x1(%edx),%ecx
 399:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 39c:	0f b6 12             	movzbl (%edx),%edx
 39f:	88 10                	mov    %dl,(%eax)
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	84 c0                	test   %al,%al
 3a6:	75 e2                	jne    38a <strcpy+0xd>
    ;
  return os;
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    

000003ad <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b0:	eb 08                	jmp    3ba <strcmp+0xd>
    p++, q++;
 3b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	0f b6 00             	movzbl (%eax),%eax
 3c0:	84 c0                	test   %al,%al
 3c2:	74 10                	je     3d4 <strcmp+0x27>
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	0f b6 10             	movzbl (%eax),%edx
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	0f b6 00             	movzbl (%eax),%eax
 3d0:	38 c2                	cmp    %al,%dl
 3d2:	74 de                	je     3b2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	0f b6 d0             	movzbl %al,%edx
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	0f b6 00             	movzbl (%eax),%eax
 3e3:	0f b6 c0             	movzbl %al,%eax
 3e6:	29 c2                	sub    %eax,%edx
 3e8:	89 d0                	mov    %edx,%eax
}
 3ea:	5d                   	pop    %ebp
 3eb:	c3                   	ret    

000003ec <strlen>:

uint
strlen(char *s)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f9:	eb 04                	jmp    3ff <strlen+0x13>
 3fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	01 d0                	add    %edx,%eax
 407:	0f b6 00             	movzbl (%eax),%eax
 40a:	84 c0                	test   %al,%al
 40c:	75 ed                	jne    3fb <strlen+0xf>
    ;
  return n;
 40e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <memset>:

void*
memset(void *dst, int c, uint n)
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 419:	8b 45 10             	mov    0x10(%ebp),%eax
 41c:	89 44 24 08          	mov    %eax,0x8(%esp)
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	89 44 24 04          	mov    %eax,0x4(%esp)
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	89 04 24             	mov    %eax,(%esp)
 42d:	e8 26 ff ff ff       	call   358 <stosb>
  return dst;
 432:	8b 45 08             	mov    0x8(%ebp),%eax
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <strchr>:

char*
strchr(const char *s, char c)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 443:	eb 14                	jmp    459 <strchr+0x22>
    if(*s == c)
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	0f b6 00             	movzbl (%eax),%eax
 44b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 44e:	75 05                	jne    455 <strchr+0x1e>
      return (char*)s;
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	eb 13                	jmp    468 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 455:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	0f b6 00             	movzbl (%eax),%eax
 45f:	84 c0                	test   %al,%al
 461:	75 e2                	jne    445 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 463:	b8 00 00 00 00       	mov    $0x0,%eax
}
 468:	c9                   	leave  
 469:	c3                   	ret    

0000046a <gets>:

char*
gets(char *buf, int max)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 470:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 477:	eb 4c                	jmp    4c5 <gets+0x5b>
    cc = read(0, &c, 1);
 479:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 480:	00 
 481:	8d 45 ef             	lea    -0x11(%ebp),%eax
 484:	89 44 24 04          	mov    %eax,0x4(%esp)
 488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 48f:	e8 44 01 00 00       	call   5d8 <read>
 494:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49b:	7f 02                	jg     49f <gets+0x35>
      break;
 49d:	eb 31                	jmp    4d0 <gets+0x66>
    buf[i++] = c;
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	8d 50 01             	lea    0x1(%eax),%edx
 4a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a8:	89 c2                	mov    %eax,%edx
 4aa:	8b 45 08             	mov    0x8(%ebp),%eax
 4ad:	01 c2                	add    %eax,%edx
 4af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4b5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b9:	3c 0a                	cmp    $0xa,%al
 4bb:	74 13                	je     4d0 <gets+0x66>
 4bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c1:	3c 0d                	cmp    $0xd,%al
 4c3:	74 0b                	je     4d0 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c8:	83 c0 01             	add    $0x1,%eax
 4cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4ce:	7c a9                	jl     479 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	01 d0                	add    %edx,%eax
 4d8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <stat>:

int
stat(char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ed:	00 
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 07 01 00 00       	call   600 <open>
 4f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 500:	79 07                	jns    509 <stat+0x29>
    return -1;
 502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 507:	eb 23                	jmp    52c <stat+0x4c>
  r = fstat(fd, st);
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 f4             	mov    -0xc(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 fd 00 00 00       	call   618 <fstat>
 51b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 51e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 521:	89 04 24             	mov    %eax,(%esp)
 524:	e8 bf 00 00 00       	call   5e8 <close>
  return r;
 529:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <atoi>:

int
atoi(const char *s)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 534:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53b:	eb 25                	jmp    562 <atoi+0x34>
    n = n*10 + *s++ - '0';
 53d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 540:	89 d0                	mov    %edx,%eax
 542:	c1 e0 02             	shl    $0x2,%eax
 545:	01 d0                	add    %edx,%eax
 547:	01 c0                	add    %eax,%eax
 549:	89 c1                	mov    %eax,%ecx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	8d 50 01             	lea    0x1(%eax),%edx
 551:	89 55 08             	mov    %edx,0x8(%ebp)
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	01 c8                	add    %ecx,%eax
 55c:	83 e8 30             	sub    $0x30,%eax
 55f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	3c 2f                	cmp    $0x2f,%al
 56a:	7e 0a                	jle    576 <atoi+0x48>
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	3c 39                	cmp    $0x39,%al
 574:	7e c7                	jle    53d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 576:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 579:	c9                   	leave  
 57a:	c3                   	ret    

0000057b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 57b:	55                   	push   %ebp
 57c:	89 e5                	mov    %esp,%ebp
 57e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 587:	8b 45 0c             	mov    0xc(%ebp),%eax
 58a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 58d:	eb 17                	jmp    5a6 <memmove+0x2b>
    *dst++ = *src++;
 58f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 592:	8d 50 01             	lea    0x1(%eax),%edx
 595:	89 55 fc             	mov    %edx,-0x4(%ebp)
 598:	8b 55 f8             	mov    -0x8(%ebp),%edx
 59b:	8d 4a 01             	lea    0x1(%edx),%ecx
 59e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5a1:	0f b6 12             	movzbl (%edx),%edx
 5a4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5a6:	8b 45 10             	mov    0x10(%ebp),%eax
 5a9:	8d 50 ff             	lea    -0x1(%eax),%edx
 5ac:	89 55 10             	mov    %edx,0x10(%ebp)
 5af:	85 c0                	test   %eax,%eax
 5b1:	7f dc                	jg     58f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b6:	c9                   	leave  
 5b7:	c3                   	ret    

000005b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5b8:	b8 01 00 00 00       	mov    $0x1,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <exit>:
SYSCALL(exit)
 5c0:	b8 02 00 00 00       	mov    $0x2,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <wait>:
SYSCALL(wait)
 5c8:	b8 03 00 00 00       	mov    $0x3,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <pipe>:
SYSCALL(pipe)
 5d0:	b8 04 00 00 00       	mov    $0x4,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <read>:
SYSCALL(read)
 5d8:	b8 05 00 00 00       	mov    $0x5,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <write>:
SYSCALL(write)
 5e0:	b8 10 00 00 00       	mov    $0x10,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <close>:
SYSCALL(close)
 5e8:	b8 15 00 00 00       	mov    $0x15,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <kill>:
SYSCALL(kill)
 5f0:	b8 06 00 00 00       	mov    $0x6,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <exec>:
SYSCALL(exec)
 5f8:	b8 07 00 00 00       	mov    $0x7,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <open>:
SYSCALL(open)
 600:	b8 0f 00 00 00       	mov    $0xf,%eax
 605:	cd 40                	int    $0x40
 607:	c3                   	ret    

00000608 <mknod>:
SYSCALL(mknod)
 608:	b8 11 00 00 00       	mov    $0x11,%eax
 60d:	cd 40                	int    $0x40
 60f:	c3                   	ret    

00000610 <unlink>:
SYSCALL(unlink)
 610:	b8 12 00 00 00       	mov    $0x12,%eax
 615:	cd 40                	int    $0x40
 617:	c3                   	ret    

00000618 <fstat>:
SYSCALL(fstat)
 618:	b8 08 00 00 00       	mov    $0x8,%eax
 61d:	cd 40                	int    $0x40
 61f:	c3                   	ret    

00000620 <link>:
SYSCALL(link)
 620:	b8 13 00 00 00       	mov    $0x13,%eax
 625:	cd 40                	int    $0x40
 627:	c3                   	ret    

00000628 <mkdir>:
SYSCALL(mkdir)
 628:	b8 14 00 00 00       	mov    $0x14,%eax
 62d:	cd 40                	int    $0x40
 62f:	c3                   	ret    

00000630 <chdir>:
SYSCALL(chdir)
 630:	b8 09 00 00 00       	mov    $0x9,%eax
 635:	cd 40                	int    $0x40
 637:	c3                   	ret    

00000638 <dup>:
SYSCALL(dup)
 638:	b8 0a 00 00 00       	mov    $0xa,%eax
 63d:	cd 40                	int    $0x40
 63f:	c3                   	ret    

00000640 <getpid>:
SYSCALL(getpid)
 640:	b8 0b 00 00 00       	mov    $0xb,%eax
 645:	cd 40                	int    $0x40
 647:	c3                   	ret    

00000648 <sbrk>:
SYSCALL(sbrk)
 648:	b8 0c 00 00 00       	mov    $0xc,%eax
 64d:	cd 40                	int    $0x40
 64f:	c3                   	ret    

00000650 <sleep>:
SYSCALL(sleep)
 650:	b8 0d 00 00 00       	mov    $0xd,%eax
 655:	cd 40                	int    $0x40
 657:	c3                   	ret    

00000658 <uptime>:
SYSCALL(uptime)
 658:	b8 0e 00 00 00       	mov    $0xe,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	83 ec 18             	sub    $0x18,%esp
 666:	8b 45 0c             	mov    0xc(%ebp),%eax
 669:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 66c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 673:	00 
 674:	8d 45 f4             	lea    -0xc(%ebp),%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 5a ff ff ff       	call   5e0 <write>
}
 686:	c9                   	leave  
 687:	c3                   	ret    

00000688 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	56                   	push   %esi
 68c:	53                   	push   %ebx
 68d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 690:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 697:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 69b:	74 17                	je     6b4 <printint+0x2c>
 69d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6a1:	79 11                	jns    6b4 <printint+0x2c>
    neg = 1;
 6a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ad:	f7 d8                	neg    %eax
 6af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6b2:	eb 06                	jmp    6ba <printint+0x32>
  } else {
    x = xx;
 6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6c4:	8d 41 01             	lea    0x1(%ecx),%eax
 6c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d0:	ba 00 00 00 00       	mov    $0x0,%edx
 6d5:	f7 f3                	div    %ebx
 6d7:	89 d0                	mov    %edx,%eax
 6d9:	0f b6 80 14 0e 00 00 	movzbl 0xe14(%eax),%eax
 6e0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6e4:	8b 75 10             	mov    0x10(%ebp),%esi
 6e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ea:	ba 00 00 00 00       	mov    $0x0,%edx
 6ef:	f7 f6                	div    %esi
 6f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f8:	75 c7                	jne    6c1 <printint+0x39>
  if(neg)
 6fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fe:	74 10                	je     710 <printint+0x88>
    buf[i++] = '-';
 700:	8b 45 f4             	mov    -0xc(%ebp),%eax
 703:	8d 50 01             	lea    0x1(%eax),%edx
 706:	89 55 f4             	mov    %edx,-0xc(%ebp)
 709:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 70e:	eb 1f                	jmp    72f <printint+0xa7>
 710:	eb 1d                	jmp    72f <printint+0xa7>
    putc(fd, buf[i]);
 712:	8d 55 dc             	lea    -0x24(%ebp),%edx
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	01 d0                	add    %edx,%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	0f be c0             	movsbl %al,%eax
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 31 ff ff ff       	call   660 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 72f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 737:	79 d9                	jns    712 <printint+0x8a>
    putc(fd, buf[i]);
}
 739:	83 c4 30             	add    $0x30,%esp
 73c:	5b                   	pop    %ebx
 73d:	5e                   	pop    %esi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    

00000740 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 746:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 74d:	8d 45 0c             	lea    0xc(%ebp),%eax
 750:	83 c0 04             	add    $0x4,%eax
 753:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 75d:	e9 7c 01 00 00       	jmp    8de <printf+0x19e>
    c = fmt[i] & 0xff;
 762:	8b 55 0c             	mov    0xc(%ebp),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	01 d0                	add    %edx,%eax
 76a:	0f b6 00             	movzbl (%eax),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	25 ff 00 00 00       	and    $0xff,%eax
 775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 77c:	75 2c                	jne    7aa <printf+0x6a>
      if(c == '%'){
 77e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 782:	75 0c                	jne    790 <printf+0x50>
        state = '%';
 784:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 78b:	e9 4a 01 00 00       	jmp    8da <printf+0x19a>
      } else {
        putc(fd, c);
 790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 793:	0f be c0             	movsbl %al,%eax
 796:	89 44 24 04          	mov    %eax,0x4(%esp)
 79a:	8b 45 08             	mov    0x8(%ebp),%eax
 79d:	89 04 24             	mov    %eax,(%esp)
 7a0:	e8 bb fe ff ff       	call   660 <putc>
 7a5:	e9 30 01 00 00       	jmp    8da <printf+0x19a>
      }
    } else if(state == '%'){
 7aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ae:	0f 85 26 01 00 00    	jne    8da <printf+0x19a>
      if(c == 'd'){
 7b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b8:	75 2d                	jne    7e7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7c6:	00 
 7c7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ce:	00 
 7cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
 7d6:	89 04 24             	mov    %eax,(%esp)
 7d9:	e8 aa fe ff ff       	call   688 <printint>
        ap++;
 7de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e2:	e9 ec 00 00 00       	jmp    8d3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 7e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7eb:	74 06                	je     7f3 <printf+0xb3>
 7ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7f1:	75 2d                	jne    820 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7ff:	00 
 800:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 807:	00 
 808:	89 44 24 04          	mov    %eax,0x4(%esp)
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	89 04 24             	mov    %eax,(%esp)
 812:	e8 71 fe ff ff       	call   688 <printint>
        ap++;
 817:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81b:	e9 b3 00 00 00       	jmp    8d3 <printf+0x193>
      } else if(c == 's'){
 820:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 824:	75 45                	jne    86b <printf+0x12b>
        s = (char*)*ap;
 826:	8b 45 e8             	mov    -0x18(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 82e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 836:	75 09                	jne    841 <printf+0x101>
          s = "(null)";
 838:	c7 45 f4 46 0b 00 00 	movl   $0xb46,-0xc(%ebp)
        while(*s != 0){
 83f:	eb 1e                	jmp    85f <printf+0x11f>
 841:	eb 1c                	jmp    85f <printf+0x11f>
          putc(fd, *s);
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	0f b6 00             	movzbl (%eax),%eax
 849:	0f be c0             	movsbl %al,%eax
 84c:	89 44 24 04          	mov    %eax,0x4(%esp)
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	89 04 24             	mov    %eax,(%esp)
 856:	e8 05 fe ff ff       	call   660 <putc>
          s++;
 85b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	0f b6 00             	movzbl (%eax),%eax
 865:	84 c0                	test   %al,%al
 867:	75 da                	jne    843 <printf+0x103>
 869:	eb 68                	jmp    8d3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 86b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 86f:	75 1d                	jne    88e <printf+0x14e>
        putc(fd, *ap);
 871:	8b 45 e8             	mov    -0x18(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	0f be c0             	movsbl %al,%eax
 879:	89 44 24 04          	mov    %eax,0x4(%esp)
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 d8 fd ff ff       	call   660 <putc>
        ap++;
 888:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 88c:	eb 45                	jmp    8d3 <printf+0x193>
      } else if(c == '%'){
 88e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 892:	75 17                	jne    8ab <printf+0x16b>
        putc(fd, c);
 894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 897:	0f be c0             	movsbl %al,%eax
 89a:	89 44 24 04          	mov    %eax,0x4(%esp)
 89e:	8b 45 08             	mov    0x8(%ebp),%eax
 8a1:	89 04 24             	mov    %eax,(%esp)
 8a4:	e8 b7 fd ff ff       	call   660 <putc>
 8a9:	eb 28                	jmp    8d3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8b2:	00 
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	89 04 24             	mov    %eax,(%esp)
 8b9:	e8 a2 fd ff ff       	call   660 <putc>
        putc(fd, c);
 8be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c1:	0f be c0             	movsbl %al,%eax
 8c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
 8cb:	89 04 24             	mov    %eax,(%esp)
 8ce:	e8 8d fd ff ff       	call   660 <putc>
      }
      state = 0;
 8d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8de:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	01 d0                	add    %edx,%eax
 8e6:	0f b6 00             	movzbl (%eax),%eax
 8e9:	84 c0                	test   %al,%al
 8eb:	0f 85 71 fe ff ff    	jne    762 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f1:	c9                   	leave  
 8f2:	c3                   	ret    
 8f3:	90                   	nop

000008f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
 8fd:	83 e8 08             	sub    $0x8,%eax
 900:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 903:	a1 48 0e 00 00       	mov    0xe48,%eax
 908:	89 45 fc             	mov    %eax,-0x4(%ebp)
 90b:	eb 24                	jmp    931 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 915:	77 12                	ja     929 <free+0x35>
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91d:	77 24                	ja     943 <free+0x4f>
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 927:	77 1a                	ja     943 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 931:	8b 45 f8             	mov    -0x8(%ebp),%eax
 934:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 937:	76 d4                	jbe    90d <free+0x19>
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 941:	76 ca                	jbe    90d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 950:	8b 45 f8             	mov    -0x8(%ebp),%eax
 953:	01 c2                	add    %eax,%edx
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	39 c2                	cmp    %eax,%edx
 95c:	75 24                	jne    982 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	8b 50 04             	mov    0x4(%eax),%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	8b 40 04             	mov    0x4(%eax),%eax
 96c:	01 c2                	add    %eax,%edx
 96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 971:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	8b 45 fc             	mov    -0x4(%ebp),%eax
 977:	8b 00                	mov    (%eax),%eax
 979:	8b 10                	mov    (%eax),%edx
 97b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97e:	89 10                	mov    %edx,(%eax)
 980:	eb 0a                	jmp    98c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 98c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98f:	8b 40 04             	mov    0x4(%eax),%eax
 992:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	01 d0                	add    %edx,%eax
 99e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a1:	75 20                	jne    9c3 <free+0xcf>
    p->s.size += bp->s.size;
 9a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a6:	8b 50 04             	mov    0x4(%eax),%edx
 9a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ac:	8b 40 04             	mov    0x4(%eax),%eax
 9af:	01 c2                	add    %eax,%edx
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ba:	8b 10                	mov    (%eax),%edx
 9bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bf:	89 10                	mov    %edx,(%eax)
 9c1:	eb 08                	jmp    9cb <free+0xd7>
  } else
    p->s.ptr = bp;
 9c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9d3:	c9                   	leave  
 9d4:	c3                   	ret    

000009d5 <morecore>:

static Header*
morecore(uint nu)
{
 9d5:	55                   	push   %ebp
 9d6:	89 e5                	mov    %esp,%ebp
 9d8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9db:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e2:	77 07                	ja     9eb <morecore+0x16>
    nu = 4096;
 9e4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	c1 e0 03             	shl    $0x3,%eax
 9f1:	89 04 24             	mov    %eax,(%esp)
 9f4:	e8 4f fc ff ff       	call   648 <sbrk>
 9f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9fc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a00:	75 07                	jne    a09 <morecore+0x34>
    return 0;
 a02:	b8 00 00 00 00       	mov    $0x0,%eax
 a07:	eb 22                	jmp    a2b <morecore+0x56>
  hp = (Header*)p;
 a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a12:	8b 55 08             	mov    0x8(%ebp),%edx
 a15:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1b:	83 c0 08             	add    $0x8,%eax
 a1e:	89 04 24             	mov    %eax,(%esp)
 a21:	e8 ce fe ff ff       	call   8f4 <free>
  return freep;
 a26:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a2b:	c9                   	leave  
 a2c:	c3                   	ret    

00000a2d <malloc>:

void*
malloc(uint nbytes)
{
 a2d:	55                   	push   %ebp
 a2e:	89 e5                	mov    %esp,%ebp
 a30:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a33:	8b 45 08             	mov    0x8(%ebp),%eax
 a36:	83 c0 07             	add    $0x7,%eax
 a39:	c1 e8 03             	shr    $0x3,%eax
 a3c:	83 c0 01             	add    $0x1,%eax
 a3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a42:	a1 48 0e 00 00       	mov    0xe48,%eax
 a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4e:	75 23                	jne    a73 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a50:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5a:	a3 48 0e 00 00       	mov    %eax,0xe48
 a5f:	a1 48 0e 00 00       	mov    0xe48,%eax
 a64:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a69:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a70:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a76:	8b 00                	mov    (%eax),%eax
 a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7e:	8b 40 04             	mov    0x4(%eax),%eax
 a81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a84:	72 4d                	jb     ad3 <malloc+0xa6>
      if(p->s.size == nunits)
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	8b 40 04             	mov    0x4(%eax),%eax
 a8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8f:	75 0c                	jne    a9d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a94:	8b 10                	mov    (%eax),%edx
 a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a99:	89 10                	mov    %edx,(%eax)
 a9b:	eb 26                	jmp    ac3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	8b 40 04             	mov    0x4(%eax),%eax
 aa3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aa6:	89 c2                	mov    %eax,%edx
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 40 04             	mov    0x4(%eax),%eax
 ab4:	c1 e0 03             	shl    $0x3,%eax
 ab7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ac0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac6:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	83 c0 08             	add    $0x8,%eax
 ad1:	eb 38                	jmp    b0b <malloc+0xde>
    }
    if(p == freep)
 ad3:	a1 48 0e 00 00       	mov    0xe48,%eax
 ad8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 adb:	75 1b                	jne    af8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 add:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ae0:	89 04 24             	mov    %eax,(%esp)
 ae3:	e8 ed fe ff ff       	call   9d5 <morecore>
 ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aef:	75 07                	jne    af8 <malloc+0xcb>
        return 0;
 af1:	b8 00 00 00 00       	mov    $0x0,%eax
 af6:	eb 13                	jmp    b0b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b01:	8b 00                	mov    (%eax),%eax
 b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b06:	e9 70 ff ff ff       	jmp    a7b <malloc+0x4e>
}
 b0b:	c9                   	leave  
 b0c:	c3                   	ret    
