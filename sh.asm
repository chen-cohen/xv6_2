
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 53 0f 00 00       	call   f64 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 e0 14 00 00 	mov    0x14e0(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 b4 14 00 00 	movl   $0x14b4,(%esp)
      2b:	e8 27 03 00 00       	call   357 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 1f 0f 00 00       	call   f64 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 3f 0f 00 00       	call   f9c <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 bb 14 00 	movl   $0x14bb,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 69 10 00 00       	call   10e4 <printf>
    break;
      7b:	e9 86 01 00 00       	jmp    206 <runcmd+0x206>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 f8 0e 00 00       	call   f8c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 f8 0e 00 00       	call   fa4 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 cb 14 00 	movl   $0x14cb,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 16 10 00 00       	call   10e4 <printf>
      exit();
      ce:	e8 91 0e 00 00       	call   f64 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 20 01 00 00       	jmp    206 <runcmd+0x206>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 8c 02 00 00       	call   37d <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 64 0e 00 00       	call   f6c <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 eb 00 00 00       	jmp    206 <runcmd+0x206>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 48 0e 00 00       	call   f74 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 db 14 00 00 	movl   $0x14db,(%esp)
     137:	e8 1b 02 00 00       	call   357 <panic>
    if(fork1() == 0){
     13c:	e8 3c 02 00 00       	call   37d <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 3b 0e 00 00       	call   f8c <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 80 0e 00 00       	call   fdc <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 25 0e 00 00       	call   f8c <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 1a 0e 00 00       	call   f8c <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 f8 01 00 00       	call   37d <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 f7 0d 00 00       	call   f8c <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 3c 0e 00 00       	call   fdc <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 e1 0d 00 00       	call   f8c <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 d6 0d 00 00       	call   f8c <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 bd 0d 00 00       	call   f8c <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 b2 0d 00 00       	call   f8c <close>
    wait();
     1da:	e8 8d 0d 00 00       	call   f6c <wait>
    wait();
     1df:	e8 88 0d 00 00       	call   f6c <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 8c 01 00 00       	call   37d <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 10                	jne    205 <runcmd+0x205>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	eb 00                	jmp    205 <runcmd+0x205>
     205:	90                   	nop
  }
  exit();
     206:	e8 59 0d 00 00       	call   f64 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 f8 14 00 	movl   $0x14f8,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 bf 0e 00 00       	call   10e4 <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 78 0b 00 00       	call   db7 <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 bd 0b 00 00       	call   e0e <gets>
  if(buf[0] == 0) // EOF
     251:	8b 45 08             	mov    0x8(%ebp),%eax
     254:	0f b6 00             	movzbl (%eax),%eax
     257:	84 c0                	test   %al,%al
     259:	75 07                	jne    262 <getcmd+0x57>
    return -1;
     25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     260:	eb 05                	jmp    267 <getcmd+0x5c>
  return 0;
     262:	b8 00 00 00 00       	mov    $0x0,%eax
}
     267:	c9                   	leave  
     268:	c3                   	ret    

00000269 <main>:

int
main(void)
{
     269:	55                   	push   %ebp
     26a:	89 e5                	mov    %esp,%ebp
     26c:	83 e4 f0             	and    $0xfffffff0,%esp
     26f:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     272:	eb 15                	jmp    289 <main+0x20>
    if(fd >= 3){
     274:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     279:	7e 0e                	jle    289 <main+0x20>
      close(fd);
     27b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27f:	89 04 24             	mov    %eax,(%esp)
     282:	e8 05 0d 00 00       	call   f8c <close>
      break;
     287:	eb 1f                	jmp    2a8 <main+0x3f>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     289:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     290:	00 
     291:	c7 04 24 fb 14 00 00 	movl   $0x14fb,(%esp)
     298:	e8 07 0d 00 00       	call   fa4 <open>
     29d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a1:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a6:	79 cc                	jns    274 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a8:	e9 89 00 00 00       	jmp    336 <main+0xcd>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ad:	0f b6 05 60 1a 00 00 	movzbl 0x1a60,%eax
     2b4:	3c 63                	cmp    $0x63,%al
     2b6:	75 5c                	jne    314 <main+0xab>
     2b8:	0f b6 05 61 1a 00 00 	movzbl 0x1a61,%eax
     2bf:	3c 64                	cmp    $0x64,%al
     2c1:	75 51                	jne    314 <main+0xab>
     2c3:	0f b6 05 62 1a 00 00 	movzbl 0x1a62,%eax
     2ca:	3c 20                	cmp    $0x20,%al
     2cc:	75 46                	jne    314 <main+0xab>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2ce:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     2d5:	e8 b6 0a 00 00       	call   d90 <strlen>
     2da:	83 e8 01             	sub    $0x1,%eax
     2dd:	c6 80 60 1a 00 00 00 	movb   $0x0,0x1a60(%eax)
      if(chdir(buf+3) < 0)
     2e4:	c7 04 24 63 1a 00 00 	movl   $0x1a63,(%esp)
     2eb:	e8 e4 0c 00 00       	call   fd4 <chdir>
     2f0:	85 c0                	test   %eax,%eax
     2f2:	79 1e                	jns    312 <main+0xa9>
        printf(2, "cannot cd %s\n", buf+3);
     2f4:	c7 44 24 08 63 1a 00 	movl   $0x1a63,0x8(%esp)
     2fb:	00 
     2fc:	c7 44 24 04 03 15 00 	movl   $0x1503,0x4(%esp)
     303:	00 
     304:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     30b:	e8 d4 0d 00 00       	call   10e4 <printf>
      continue;
     310:	eb 24                	jmp    336 <main+0xcd>
     312:	eb 22                	jmp    336 <main+0xcd>
    }
    if(fork1() == 0)
     314:	e8 64 00 00 00       	call   37d <fork1>
     319:	85 c0                	test   %eax,%eax
     31b:	75 14                	jne    331 <main+0xc8>
      runcmd(parsecmd(buf));
     31d:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     324:	e8 c9 03 00 00       	call   6f2 <parsecmd>
     329:	89 04 24             	mov    %eax,(%esp)
     32c:	e8 cf fc ff ff       	call   0 <runcmd>
    wait();
     331:	e8 36 0c 00 00       	call   f6c <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     336:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     33d:	00 
     33e:	c7 04 24 60 1a 00 00 	movl   $0x1a60,(%esp)
     345:	e8 c1 fe ff ff       	call   20b <getcmd>
     34a:	85 c0                	test   %eax,%eax
     34c:	0f 89 5b ff ff ff    	jns    2ad <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     352:	e8 0d 0c 00 00       	call   f64 <exit>

00000357 <panic>:
}

void
panic(char *s)
{
     357:	55                   	push   %ebp
     358:	89 e5                	mov    %esp,%ebp
     35a:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     35d:	8b 45 08             	mov    0x8(%ebp),%eax
     360:	89 44 24 08          	mov    %eax,0x8(%esp)
     364:	c7 44 24 04 11 15 00 	movl   $0x1511,0x4(%esp)
     36b:	00 
     36c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     373:	e8 6c 0d 00 00       	call   10e4 <printf>
  exit();
     378:	e8 e7 0b 00 00       	call   f64 <exit>

0000037d <fork1>:
}

int
fork1(void)
{
     37d:	55                   	push   %ebp
     37e:	89 e5                	mov    %esp,%ebp
     380:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     383:	e8 d4 0b 00 00       	call   f5c <fork>
     388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     38b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     38f:	75 0c                	jne    39d <fork1+0x20>
    panic("fork");
     391:	c7 04 24 15 15 00 00 	movl   $0x1515,(%esp)
     398:	e8 ba ff ff ff       	call   357 <panic>
  return pid;
     39d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3a0:	c9                   	leave  
     3a1:	c3                   	ret    

000003a2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3a2:	55                   	push   %ebp
     3a3:	89 e5                	mov    %esp,%ebp
     3a5:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a8:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3af:	e8 1d 10 00 00       	call   13d1 <malloc>
     3b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3b7:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3be:	00 
     3bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c6:	00 
     3c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ca:	89 04 24             	mov    %eax,(%esp)
     3cd:	e8 e5 09 00 00       	call   db7 <memset>
  cmd->type = EXEC;
     3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ed:	e8 df 0f 00 00       	call   13d1 <malloc>
     3f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f5:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3fc:	00 
     3fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     404:	00 
     405:	8b 45 f4             	mov    -0xc(%ebp),%eax
     408:	89 04 24             	mov    %eax,(%esp)
     40b:	e8 a7 09 00 00       	call   db7 <memset>
  cmd->type = REDIR;
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     419:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41c:	8b 55 08             	mov    0x8(%ebp),%edx
     41f:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     422:	8b 45 f4             	mov    -0xc(%ebp),%eax
     425:	8b 55 0c             	mov    0xc(%ebp),%edx
     428:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     42e:	8b 55 10             	mov    0x10(%ebp),%edx
     431:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     434:	8b 45 f4             	mov    -0xc(%ebp),%eax
     437:	8b 55 14             	mov    0x14(%ebp),%edx
     43a:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     440:	8b 55 18             	mov    0x18(%ebp),%edx
     443:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     446:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     449:	c9                   	leave  
     44a:	c3                   	ret    

0000044b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     44b:	55                   	push   %ebp
     44c:	89 e5                	mov    %esp,%ebp
     44e:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     451:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     458:	e8 74 0f 00 00       	call   13d1 <malloc>
     45d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     460:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     467:	00 
     468:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     46f:	00 
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	89 04 24             	mov    %eax,(%esp)
     476:	e8 3c 09 00 00       	call   db7 <memset>
  cmd->type = PIPE;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     484:	8b 45 f4             	mov    -0xc(%ebp),%eax
     487:	8b 55 08             	mov    0x8(%ebp),%edx
     48a:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     490:	8b 55 0c             	mov    0xc(%ebp),%edx
     493:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     499:	c9                   	leave  
     49a:	c3                   	ret    

0000049b <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     49b:	55                   	push   %ebp
     49c:	89 e5                	mov    %esp,%ebp
     49e:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4a1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     4a8:	e8 24 0f 00 00       	call   13d1 <malloc>
     4ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4b0:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4b7:	00 
     4b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4bf:	00 
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	89 04 24             	mov    %eax,(%esp)
     4c6:	e8 ec 08 00 00       	call   db7 <memset>
  cmd->type = LIST;
     4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ce:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d7:	8b 55 08             	mov    0x8(%ebp),%edx
     4da:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e0:	8b 55 0c             	mov    0xc(%ebp),%edx
     4e3:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4e9:	c9                   	leave  
     4ea:	c3                   	ret    

000004eb <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4eb:	55                   	push   %ebp
     4ec:	89 e5                	mov    %esp,%ebp
     4ee:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4f8:	e8 d4 0e 00 00       	call   13d1 <malloc>
     4fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     500:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     507:	00 
     508:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     50f:	00 
     510:	8b 45 f4             	mov    -0xc(%ebp),%eax
     513:	89 04 24             	mov    %eax,(%esp)
     516:	e8 9c 08 00 00       	call   db7 <memset>
  cmd->type = BACK;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     524:	8b 45 f4             	mov    -0xc(%ebp),%eax
     527:	8b 55 08             	mov    0x8(%ebp),%edx
     52a:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     530:	c9                   	leave  
     531:	c3                   	ret    

00000532 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     532:	55                   	push   %ebp
     533:	89 e5                	mov    %esp,%ebp
     535:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     538:	8b 45 08             	mov    0x8(%ebp),%eax
     53b:	8b 00                	mov    (%eax),%eax
     53d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     540:	eb 04                	jmp    546 <gettoken+0x14>
    s++;
     542:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     546:	8b 45 f4             	mov    -0xc(%ebp),%eax
     549:	3b 45 0c             	cmp    0xc(%ebp),%eax
     54c:	73 1d                	jae    56b <gettoken+0x39>
     54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     551:	0f b6 00             	movzbl (%eax),%eax
     554:	0f be c0             	movsbl %al,%eax
     557:	89 44 24 04          	mov    %eax,0x4(%esp)
     55b:	c7 04 24 2c 1a 00 00 	movl   $0x1a2c,(%esp)
     562:	e8 74 08 00 00       	call   ddb <strchr>
     567:	85 c0                	test   %eax,%eax
     569:	75 d7                	jne    542 <gettoken+0x10>
    s++;
  if(q)
     56b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     56f:	74 08                	je     579 <gettoken+0x47>
    *q = s;
     571:	8b 45 10             	mov    0x10(%ebp),%eax
     574:	8b 55 f4             	mov    -0xc(%ebp),%edx
     577:	89 10                	mov    %edx,(%eax)
  ret = *s;
     579:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57c:	0f b6 00             	movzbl (%eax),%eax
     57f:	0f be c0             	movsbl %al,%eax
     582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     585:	8b 45 f4             	mov    -0xc(%ebp),%eax
     588:	0f b6 00             	movzbl (%eax),%eax
     58b:	0f be c0             	movsbl %al,%eax
     58e:	83 f8 29             	cmp    $0x29,%eax
     591:	7f 14                	jg     5a7 <gettoken+0x75>
     593:	83 f8 28             	cmp    $0x28,%eax
     596:	7d 28                	jge    5c0 <gettoken+0x8e>
     598:	85 c0                	test   %eax,%eax
     59a:	0f 84 94 00 00 00    	je     634 <gettoken+0x102>
     5a0:	83 f8 26             	cmp    $0x26,%eax
     5a3:	74 1b                	je     5c0 <gettoken+0x8e>
     5a5:	eb 3c                	jmp    5e3 <gettoken+0xb1>
     5a7:	83 f8 3e             	cmp    $0x3e,%eax
     5aa:	74 1a                	je     5c6 <gettoken+0x94>
     5ac:	83 f8 3e             	cmp    $0x3e,%eax
     5af:	7f 0a                	jg     5bb <gettoken+0x89>
     5b1:	83 e8 3b             	sub    $0x3b,%eax
     5b4:	83 f8 01             	cmp    $0x1,%eax
     5b7:	77 2a                	ja     5e3 <gettoken+0xb1>
     5b9:	eb 05                	jmp    5c0 <gettoken+0x8e>
     5bb:	83 f8 7c             	cmp    $0x7c,%eax
     5be:	75 23                	jne    5e3 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5c4:	eb 6f                	jmp    635 <gettoken+0x103>
  case '>':
    s++;
     5c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cd:	0f b6 00             	movzbl (%eax),%eax
     5d0:	3c 3e                	cmp    $0x3e,%al
     5d2:	75 0d                	jne    5e1 <gettoken+0xaf>
      ret = '+';
     5d4:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5df:	eb 54                	jmp    635 <gettoken+0x103>
     5e1:	eb 52                	jmp    635 <gettoken+0x103>
  default:
    ret = 'a';
     5e3:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5ea:	eb 04                	jmp    5f0 <gettoken+0xbe>
      s++;
     5ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f6:	73 3a                	jae    632 <gettoken+0x100>
     5f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fb:	0f b6 00             	movzbl (%eax),%eax
     5fe:	0f be c0             	movsbl %al,%eax
     601:	89 44 24 04          	mov    %eax,0x4(%esp)
     605:	c7 04 24 2c 1a 00 00 	movl   $0x1a2c,(%esp)
     60c:	e8 ca 07 00 00       	call   ddb <strchr>
     611:	85 c0                	test   %eax,%eax
     613:	75 1d                	jne    632 <gettoken+0x100>
     615:	8b 45 f4             	mov    -0xc(%ebp),%eax
     618:	0f b6 00             	movzbl (%eax),%eax
     61b:	0f be c0             	movsbl %al,%eax
     61e:	89 44 24 04          	mov    %eax,0x4(%esp)
     622:	c7 04 24 32 1a 00 00 	movl   $0x1a32,(%esp)
     629:	e8 ad 07 00 00       	call   ddb <strchr>
     62e:	85 c0                	test   %eax,%eax
     630:	74 ba                	je     5ec <gettoken+0xba>
      s++;
    break;
     632:	eb 01                	jmp    635 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     634:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     635:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     639:	74 0a                	je     645 <gettoken+0x113>
    *eq = s;
     63b:	8b 45 14             	mov    0x14(%ebp),%eax
     63e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     641:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     643:	eb 06                	jmp    64b <gettoken+0x119>
     645:	eb 04                	jmp    64b <gettoken+0x119>
    s++;
     647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	3b 45 0c             	cmp    0xc(%ebp),%eax
     651:	73 1d                	jae    670 <gettoken+0x13e>
     653:	8b 45 f4             	mov    -0xc(%ebp),%eax
     656:	0f b6 00             	movzbl (%eax),%eax
     659:	0f be c0             	movsbl %al,%eax
     65c:	89 44 24 04          	mov    %eax,0x4(%esp)
     660:	c7 04 24 2c 1a 00 00 	movl   $0x1a2c,(%esp)
     667:	e8 6f 07 00 00       	call   ddb <strchr>
     66c:	85 c0                	test   %eax,%eax
     66e:	75 d7                	jne    647 <gettoken+0x115>
    s++;
  *ps = s;
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	8b 55 f4             	mov    -0xc(%ebp),%edx
     676:	89 10                	mov    %edx,(%eax)
  return ret;
     678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     67b:	c9                   	leave  
     67c:	c3                   	ret    

0000067d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     67d:	55                   	push   %ebp
     67e:	89 e5                	mov    %esp,%ebp
     680:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     683:	8b 45 08             	mov    0x8(%ebp),%eax
     686:	8b 00                	mov    (%eax),%eax
     688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     68b:	eb 04                	jmp    691 <peek+0x14>
    s++;
     68d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     691:	8b 45 f4             	mov    -0xc(%ebp),%eax
     694:	3b 45 0c             	cmp    0xc(%ebp),%eax
     697:	73 1d                	jae    6b6 <peek+0x39>
     699:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69c:	0f b6 00             	movzbl (%eax),%eax
     69f:	0f be c0             	movsbl %al,%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	c7 04 24 2c 1a 00 00 	movl   $0x1a2c,(%esp)
     6ad:	e8 29 07 00 00       	call   ddb <strchr>
     6b2:	85 c0                	test   %eax,%eax
     6b4:	75 d7                	jne    68d <peek+0x10>
    s++;
  *ps = s;
     6b6:	8b 45 08             	mov    0x8(%ebp),%eax
     6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6bc:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c1:	0f b6 00             	movzbl (%eax),%eax
     6c4:	84 c0                	test   %al,%al
     6c6:	74 23                	je     6eb <peek+0x6e>
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	0f b6 00             	movzbl (%eax),%eax
     6ce:	0f be c0             	movsbl %al,%eax
     6d1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d5:	8b 45 10             	mov    0x10(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 fb 06 00 00       	call   ddb <strchr>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 07                	je     6eb <peek+0x6e>
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
     6e9:	eb 05                	jmp    6f0 <peek+0x73>
     6eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f0:	c9                   	leave  
     6f1:	c3                   	ret    

000006f2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6f2:	55                   	push   %ebp
     6f3:	89 e5                	mov    %esp,%ebp
     6f5:	53                   	push   %ebx
     6f6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6fc:	8b 45 08             	mov    0x8(%ebp),%eax
     6ff:	89 04 24             	mov    %eax,(%esp)
     702:	e8 89 06 00 00       	call   d90 <strlen>
     707:	01 d8                	add    %ebx,%eax
     709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70f:	89 44 24 04          	mov    %eax,0x4(%esp)
     713:	8d 45 08             	lea    0x8(%ebp),%eax
     716:	89 04 24             	mov    %eax,(%esp)
     719:	e8 60 00 00 00       	call   77e <parseline>
     71e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     721:	c7 44 24 08 1a 15 00 	movl   $0x151a,0x8(%esp)
     728:	00 
     729:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8d 45 08             	lea    0x8(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 42 ff ff ff       	call   67d <peek>
  if(s != es){
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     741:	74 27                	je     76a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     743:	8b 45 08             	mov    0x8(%ebp),%eax
     746:	89 44 24 08          	mov    %eax,0x8(%esp)
     74a:	c7 44 24 04 1b 15 00 	movl   $0x151b,0x4(%esp)
     751:	00 
     752:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     759:	e8 86 09 00 00       	call   10e4 <printf>
    panic("syntax");
     75e:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     765:	e8 ed fb ff ff       	call   357 <panic>
  }
  nulterminate(cmd);
     76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     76d:	89 04 24             	mov    %eax,(%esp)
     770:	e8 a3 04 00 00       	call   c18 <nulterminate>
  return cmd;
     775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     778:	83 c4 24             	add    $0x24,%esp
     77b:	5b                   	pop    %ebx
     77c:	5d                   	pop    %ebp
     77d:	c3                   	ret    

0000077e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     77e:	55                   	push   %ebp
     77f:	89 e5                	mov    %esp,%ebp
     781:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 44 24 04          	mov    %eax,0x4(%esp)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	89 04 24             	mov    %eax,(%esp)
     791:	e8 bc 00 00 00       	call   852 <parsepipe>
     796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     799:	eb 30                	jmp    7cb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     79b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7a2:	00 
     7a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7aa:	00 
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b2:	8b 45 08             	mov    0x8(%ebp),%eax
     7b5:	89 04 24             	mov    %eax,(%esp)
     7b8:	e8 75 fd ff ff       	call   532 <gettoken>
    cmd = backcmd(cmd);
     7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 23 fd ff ff       	call   4eb <backcmd>
     7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7cb:	c7 44 24 08 31 15 00 	movl   $0x1531,0x8(%esp)
     7d2:	00 
     7d3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	89 04 24             	mov    %eax,(%esp)
     7e0:	e8 98 fe ff ff       	call   67d <peek>
     7e5:	85 c0                	test   %eax,%eax
     7e7:	75 b2                	jne    79b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e9:	c7 44 24 08 33 15 00 	movl   $0x1533,0x8(%esp)
     7f0:	00 
     7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     7f8:	8b 45 08             	mov    0x8(%ebp),%eax
     7fb:	89 04 24             	mov    %eax,(%esp)
     7fe:	e8 7a fe ff ff       	call   67d <peek>
     803:	85 c0                	test   %eax,%eax
     805:	74 46                	je     84d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     807:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     80e:	00 
     80f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     816:	00 
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 09 fd ff ff       	call   532 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	89 44 24 04          	mov    %eax,0x4(%esp)
     830:	8b 45 08             	mov    0x8(%ebp),%eax
     833:	89 04 24             	mov    %eax,(%esp)
     836:	e8 43 ff ff ff       	call   77e <parseline>
     83b:	89 44 24 04          	mov    %eax,0x4(%esp)
     83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     842:	89 04 24             	mov    %eax,(%esp)
     845:	e8 51 fc ff ff       	call   49b <listcmd>
     84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     850:	c9                   	leave  
     851:	c3                   	ret    

00000852 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     852:	55                   	push   %ebp
     853:	89 e5                	mov    %esp,%ebp
     855:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 04          	mov    %eax,0x4(%esp)
     85f:	8b 45 08             	mov    0x8(%ebp),%eax
     862:	89 04 24             	mov    %eax,(%esp)
     865:	e8 68 02 00 00       	call   ad2 <parseexec>
     86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     86d:	c7 44 24 08 35 15 00 	movl   $0x1535,0x8(%esp)
     874:	00 
     875:	8b 45 0c             	mov    0xc(%ebp),%eax
     878:	89 44 24 04          	mov    %eax,0x4(%esp)
     87c:	8b 45 08             	mov    0x8(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 f6 fd ff ff       	call   67d <peek>
     887:	85 c0                	test   %eax,%eax
     889:	74 46                	je     8d1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     88b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     892:	00 
     893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     89a:	00 
     89b:	8b 45 0c             	mov    0xc(%ebp),%eax
     89e:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a2:	8b 45 08             	mov    0x8(%ebp),%eax
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 85 fc ff ff       	call   532 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b4:	8b 45 08             	mov    0x8(%ebp),%eax
     8b7:	89 04 24             	mov    %eax,(%esp)
     8ba:	e8 93 ff ff ff       	call   852 <parsepipe>
     8bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8c6:	89 04 24             	mov    %eax,(%esp)
     8c9:	e8 7d fb ff ff       	call   44b <pipecmd>
     8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8d4:	c9                   	leave  
     8d5:	c3                   	ret    

000008d6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8dc:	e9 f6 00 00 00       	jmp    9d7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8e1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8e8:	00 
     8e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8f0:	00 
     8f1:	8b 45 10             	mov    0x10(%ebp),%eax
     8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fb:	89 04 24             	mov    %eax,(%esp)
     8fe:	e8 2f fc ff ff       	call   532 <gettoken>
     903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     906:	8d 45 ec             	lea    -0x14(%ebp),%eax
     909:	89 44 24 0c          	mov    %eax,0xc(%esp)
     90d:	8d 45 f0             	lea    -0x10(%ebp),%eax
     910:	89 44 24 08          	mov    %eax,0x8(%esp)
     914:	8b 45 10             	mov    0x10(%ebp),%eax
     917:	89 44 24 04          	mov    %eax,0x4(%esp)
     91b:	8b 45 0c             	mov    0xc(%ebp),%eax
     91e:	89 04 24             	mov    %eax,(%esp)
     921:	e8 0c fc ff ff       	call   532 <gettoken>
     926:	83 f8 61             	cmp    $0x61,%eax
     929:	74 0c                	je     937 <parseredirs+0x61>
      panic("missing file for redirection");
     92b:	c7 04 24 37 15 00 00 	movl   $0x1537,(%esp)
     932:	e8 20 fa ff ff       	call   357 <panic>
    switch(tok){
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
     93a:	83 f8 3c             	cmp    $0x3c,%eax
     93d:	74 0f                	je     94e <parseredirs+0x78>
     93f:	83 f8 3e             	cmp    $0x3e,%eax
     942:	74 38                	je     97c <parseredirs+0xa6>
     944:	83 f8 2b             	cmp    $0x2b,%eax
     947:	74 61                	je     9aa <parseredirs+0xd4>
     949:	e9 89 00 00 00       	jmp    9d7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     94e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     951:	8b 45 f0             	mov    -0x10(%ebp),%eax
     954:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     95b:	00 
     95c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     963:	00 
     964:	89 54 24 08          	mov    %edx,0x8(%esp)
     968:	89 44 24 04          	mov    %eax,0x4(%esp)
     96c:	8b 45 08             	mov    0x8(%ebp),%eax
     96f:	89 04 24             	mov    %eax,(%esp)
     972:	e8 69 fa ff ff       	call   3e0 <redircmd>
     977:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     97a:	eb 5b                	jmp    9d7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     97c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     982:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     989:	00 
     98a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     991:	00 
     992:	89 54 24 08          	mov    %edx,0x8(%esp)
     996:	89 44 24 04          	mov    %eax,0x4(%esp)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	89 04 24             	mov    %eax,(%esp)
     9a0:	e8 3b fa ff ff       	call   3e0 <redircmd>
     9a5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9a8:	eb 2d                	jmp    9d7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     9aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9b0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     9b7:	00 
     9b8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9bf:	00 
     9c0:	89 54 24 08          	mov    %edx,0x8(%esp)
     9c4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c8:	8b 45 08             	mov    0x8(%ebp),%eax
     9cb:	89 04 24             	mov    %eax,(%esp)
     9ce:	e8 0d fa ff ff       	call   3e0 <redircmd>
     9d3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9d6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9d7:	c7 44 24 08 54 15 00 	movl   $0x1554,0x8(%esp)
     9de:	00 
     9df:	8b 45 10             	mov    0x10(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e9:	89 04 24             	mov    %eax,(%esp)
     9ec:	e8 8c fc ff ff       	call   67d <peek>
     9f1:	85 c0                	test   %eax,%eax
     9f3:	0f 85 e8 fe ff ff    	jne    8e1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a04:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 5f fc ff ff       	call   67d <peek>
     a1e:	85 c0                	test   %eax,%eax
     a20:	75 0c                	jne    a2e <parseblock+0x30>
    panic("parseblock");
     a22:	c7 04 24 59 15 00 00 	movl   $0x1559,(%esp)
     a29:	e8 29 f9 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a35:	00 
     a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a3d:	00 
     a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a41:	89 44 24 04          	mov    %eax,0x4(%esp)
     a45:	8b 45 08             	mov    0x8(%ebp),%eax
     a48:	89 04 24             	mov    %eax,(%esp)
     a4b:	e8 e2 fa ff ff       	call   532 <gettoken>
  cmd = parseline(ps, es);
     a50:	8b 45 0c             	mov    0xc(%ebp),%eax
     a53:	89 44 24 04          	mov    %eax,0x4(%esp)
     a57:	8b 45 08             	mov    0x8(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 1c fd ff ff       	call   77e <parseline>
     a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a65:	c7 44 24 08 64 15 00 	movl   $0x1564,0x8(%esp)
     a6c:	00 
     a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a70:	89 44 24 04          	mov    %eax,0x4(%esp)
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 fe fb ff ff       	call   67d <peek>
     a7f:	85 c0                	test   %eax,%eax
     a81:	75 0c                	jne    a8f <parseblock+0x91>
    panic("syntax - missing )");
     a83:	c7 04 24 66 15 00 00 	movl   $0x1566,(%esp)
     a8a:	e8 c8 f8 ff ff       	call   357 <panic>
  gettoken(ps, es, 0, 0);
     a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a96:	00 
     a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a9e:	00 
     a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	89 04 24             	mov    %eax,(%esp)
     aac:	e8 81 fa ff ff       	call   532 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ab8:	8b 45 08             	mov    0x8(%ebp),%eax
     abb:	89 44 24 04          	mov    %eax,0x4(%esp)
     abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac2:	89 04 24             	mov    %eax,(%esp)
     ac5:	e8 0c fe ff ff       	call   8d6 <parseredirs>
     aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ad0:	c9                   	leave  
     ad1:	c3                   	ret    

00000ad2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ad2:	55                   	push   %ebp
     ad3:	89 e5                	mov    %esp,%ebp
     ad5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     ad8:	c7 44 24 08 57 15 00 	movl   $0x1557,0x8(%esp)
     adf:	00 
     ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae7:	8b 45 08             	mov    0x8(%ebp),%eax
     aea:	89 04 24             	mov    %eax,(%esp)
     aed:	e8 8b fb ff ff       	call   67d <peek>
     af2:	85 c0                	test   %eax,%eax
     af4:	74 17                	je     b0d <parseexec+0x3b>
    return parseblock(ps, es);
     af6:	8b 45 0c             	mov    0xc(%ebp),%eax
     af9:	89 44 24 04          	mov    %eax,0x4(%esp)
     afd:	8b 45 08             	mov    0x8(%ebp),%eax
     b00:	89 04 24             	mov    %eax,(%esp)
     b03:	e8 f6 fe ff ff       	call   9fe <parseblock>
     b08:	e9 09 01 00 00       	jmp    c16 <parseexec+0x144>

  ret = execcmd();
     b0d:	e8 90 f8 ff ff       	call   3a2 <execcmd>
     b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b22:	8b 45 0c             	mov    0xc(%ebp),%eax
     b25:	89 44 24 08          	mov    %eax,0x8(%esp)
     b29:	8b 45 08             	mov    0x8(%ebp),%eax
     b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 9b fd ff ff       	call   8d6 <parseredirs>
     b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b3e:	e9 8f 00 00 00       	jmp    bd2 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b46:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b4a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 44 24 04          	mov    %eax,0x4(%esp)
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	89 04 24             	mov    %eax,(%esp)
     b5e:	e8 cf f9 ff ff       	call   532 <gettoken>
     b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b6a:	75 05                	jne    b71 <parseexec+0x9f>
      break;
     b6c:	e9 83 00 00 00       	jmp    bf4 <parseexec+0x122>
    if(tok != 'a')
     b71:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b75:	74 0c                	je     b83 <parseexec+0xb1>
      panic("syntax");
     b77:	c7 04 24 2a 15 00 00 	movl   $0x152a,(%esp)
     b7e:	e8 d4 f7 ff ff       	call   357 <panic>
    cmd->argv[argc] = q;
     b83:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b8c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b90:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b99:	83 c1 08             	add    $0x8,%ecx
     b9c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     ba0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     ba4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ba8:	7e 0c                	jle    bb6 <parseexec+0xe4>
      panic("too many args");
     baa:	c7 04 24 79 15 00 00 	movl   $0x1579,(%esp)
     bb1:	e8 a1 f7 ff ff       	call   357 <panic>
    ret = parseredirs(ret, ps, es);
     bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbd:	8b 45 08             	mov    0x8(%ebp),%eax
     bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bc7:	89 04 24             	mov    %eax,(%esp)
     bca:	e8 07 fd ff ff       	call   8d6 <parseredirs>
     bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bd2:	c7 44 24 08 87 15 00 	movl   $0x1587,0x8(%esp)
     bd9:	00 
     bda:	8b 45 0c             	mov    0xc(%ebp),%eax
     bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
     be1:	8b 45 08             	mov    0x8(%ebp),%eax
     be4:	89 04 24             	mov    %eax,(%esp)
     be7:	e8 91 fa ff ff       	call   67d <peek>
     bec:	85 c0                	test   %eax,%eax
     bee:	0f 84 4f ff ff ff    	je     b43 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bfa:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c01:	00 
  cmd->eargv[argc] = 0;
     c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c08:	83 c2 08             	add    $0x8,%edx
     c0b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     c12:	00 
  return ret;
     c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     c16:	c9                   	leave  
     c17:	c3                   	ret    

00000c18 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     c18:	55                   	push   %ebp
     c19:	89 e5                	mov    %esp,%ebp
     c1b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c22:	75 0a                	jne    c2e <nulterminate+0x16>
    return 0;
     c24:	b8 00 00 00 00       	mov    $0x0,%eax
     c29:	e9 c9 00 00 00       	jmp    cf7 <nulterminate+0xdf>
  
  switch(cmd->type){
     c2e:	8b 45 08             	mov    0x8(%ebp),%eax
     c31:	8b 00                	mov    (%eax),%eax
     c33:	83 f8 05             	cmp    $0x5,%eax
     c36:	0f 87 b8 00 00 00    	ja     cf4 <nulterminate+0xdc>
     c3c:	8b 04 85 8c 15 00 00 	mov    0x158c(,%eax,4),%eax
     c43:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c45:	8b 45 08             	mov    0x8(%ebp),%eax
     c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c52:	eb 14                	jmp    c68 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c5a:	83 c2 08             	add    $0x8,%edx
     c5d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     c61:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c6e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c72:	85 c0                	test   %eax,%eax
     c74:	75 de                	jne    c54 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c76:	eb 7c                	jmp    cf4 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c78:	8b 45 08             	mov    0x8(%ebp),%eax
     c7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c81:	8b 40 04             	mov    0x4(%eax),%eax
     c84:	89 04 24             	mov    %eax,(%esp)
     c87:	e8 8c ff ff ff       	call   c18 <nulterminate>
    *rcmd->efile = 0;
     c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8f:	8b 40 0c             	mov    0xc(%eax),%eax
     c92:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c95:	eb 5d                	jmp    cf4 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c97:	8b 45 08             	mov    0x8(%ebp),%eax
     c9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ca0:	8b 40 04             	mov    0x4(%eax),%eax
     ca3:	89 04 24             	mov    %eax,(%esp)
     ca6:	e8 6d ff ff ff       	call   c18 <nulterminate>
    nulterminate(pcmd->right);
     cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cae:	8b 40 08             	mov    0x8(%eax),%eax
     cb1:	89 04 24             	mov    %eax,(%esp)
     cb4:	e8 5f ff ff ff       	call   c18 <nulterminate>
    break;
     cb9:	eb 39                	jmp    cf4 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     cbb:	8b 45 08             	mov    0x8(%ebp),%eax
     cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc4:	8b 40 04             	mov    0x4(%eax),%eax
     cc7:	89 04 24             	mov    %eax,(%esp)
     cca:	e8 49 ff ff ff       	call   c18 <nulterminate>
    nulterminate(lcmd->right);
     ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd2:	8b 40 08             	mov    0x8(%eax),%eax
     cd5:	89 04 24             	mov    %eax,(%esp)
     cd8:	e8 3b ff ff ff       	call   c18 <nulterminate>
    break;
     cdd:	eb 15                	jmp    cf4 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ce8:	8b 40 04             	mov    0x4(%eax),%eax
     ceb:	89 04 24             	mov    %eax,(%esp)
     cee:	e8 25 ff ff ff       	call   c18 <nulterminate>
    break;
     cf3:	90                   	nop
  }
  return cmd;
     cf4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    
     cf9:	66 90                	xchg   %ax,%ax
     cfb:	90                   	nop

00000cfc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     cfc:	55                   	push   %ebp
     cfd:	89 e5                	mov    %esp,%ebp
     cff:	57                   	push   %edi
     d00:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d01:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d04:	8b 55 10             	mov    0x10(%ebp),%edx
     d07:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0a:	89 cb                	mov    %ecx,%ebx
     d0c:	89 df                	mov    %ebx,%edi
     d0e:	89 d1                	mov    %edx,%ecx
     d10:	fc                   	cld    
     d11:	f3 aa                	rep stos %al,%es:(%edi)
     d13:	89 ca                	mov    %ecx,%edx
     d15:	89 fb                	mov    %edi,%ebx
     d17:	89 5d 08             	mov    %ebx,0x8(%ebp)
     d1a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d1d:	5b                   	pop    %ebx
     d1e:	5f                   	pop    %edi
     d1f:	5d                   	pop    %ebp
     d20:	c3                   	ret    

00000d21 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     d21:	55                   	push   %ebp
     d22:	89 e5                	mov    %esp,%ebp
     d24:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d27:	8b 45 08             	mov    0x8(%ebp),%eax
     d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d2d:	90                   	nop
     d2e:	8b 45 08             	mov    0x8(%ebp),%eax
     d31:	8d 50 01             	lea    0x1(%eax),%edx
     d34:	89 55 08             	mov    %edx,0x8(%ebp)
     d37:	8b 55 0c             	mov    0xc(%ebp),%edx
     d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
     d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d40:	0f b6 12             	movzbl (%edx),%edx
     d43:	88 10                	mov    %dl,(%eax)
     d45:	0f b6 00             	movzbl (%eax),%eax
     d48:	84 c0                	test   %al,%al
     d4a:	75 e2                	jne    d2e <strcpy+0xd>
    ;
  return os;
     d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d4f:	c9                   	leave  
     d50:	c3                   	ret    

00000d51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d51:	55                   	push   %ebp
     d52:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d54:	eb 08                	jmp    d5e <strcmp+0xd>
    p++, q++;
     d56:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d5a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d5e:	8b 45 08             	mov    0x8(%ebp),%eax
     d61:	0f b6 00             	movzbl (%eax),%eax
     d64:	84 c0                	test   %al,%al
     d66:	74 10                	je     d78 <strcmp+0x27>
     d68:	8b 45 08             	mov    0x8(%ebp),%eax
     d6b:	0f b6 10             	movzbl (%eax),%edx
     d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d71:	0f b6 00             	movzbl (%eax),%eax
     d74:	38 c2                	cmp    %al,%dl
     d76:	74 de                	je     d56 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d78:	8b 45 08             	mov    0x8(%ebp),%eax
     d7b:	0f b6 00             	movzbl (%eax),%eax
     d7e:	0f b6 d0             	movzbl %al,%edx
     d81:	8b 45 0c             	mov    0xc(%ebp),%eax
     d84:	0f b6 00             	movzbl (%eax),%eax
     d87:	0f b6 c0             	movzbl %al,%eax
     d8a:	29 c2                	sub    %eax,%edx
     d8c:	89 d0                	mov    %edx,%eax
}
     d8e:	5d                   	pop    %ebp
     d8f:	c3                   	ret    

00000d90 <strlen>:

uint
strlen(char *s)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d9d:	eb 04                	jmp    da3 <strlen+0x13>
     d9f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     da3:	8b 55 fc             	mov    -0x4(%ebp),%edx
     da6:	8b 45 08             	mov    0x8(%ebp),%eax
     da9:	01 d0                	add    %edx,%eax
     dab:	0f b6 00             	movzbl (%eax),%eax
     dae:	84 c0                	test   %al,%al
     db0:	75 ed                	jne    d9f <strlen+0xf>
    ;
  return n;
     db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     db5:	c9                   	leave  
     db6:	c3                   	ret    

00000db7 <memset>:

void*
memset(void *dst, int c, uint n)
{
     db7:	55                   	push   %ebp
     db8:	89 e5                	mov    %esp,%ebp
     dba:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     dbd:	8b 45 10             	mov    0x10(%ebp),%eax
     dc0:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     dcb:	8b 45 08             	mov    0x8(%ebp),%eax
     dce:	89 04 24             	mov    %eax,(%esp)
     dd1:	e8 26 ff ff ff       	call   cfc <stosb>
  return dst;
     dd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dd9:	c9                   	leave  
     dda:	c3                   	ret    

00000ddb <strchr>:

char*
strchr(const char *s, char c)
{
     ddb:	55                   	push   %ebp
     ddc:	89 e5                	mov    %esp,%ebp
     dde:	83 ec 04             	sub    $0x4,%esp
     de1:	8b 45 0c             	mov    0xc(%ebp),%eax
     de4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     de7:	eb 14                	jmp    dfd <strchr+0x22>
    if(*s == c)
     de9:	8b 45 08             	mov    0x8(%ebp),%eax
     dec:	0f b6 00             	movzbl (%eax),%eax
     def:	3a 45 fc             	cmp    -0x4(%ebp),%al
     df2:	75 05                	jne    df9 <strchr+0x1e>
      return (char*)s;
     df4:	8b 45 08             	mov    0x8(%ebp),%eax
     df7:	eb 13                	jmp    e0c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     df9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     dfd:	8b 45 08             	mov    0x8(%ebp),%eax
     e00:	0f b6 00             	movzbl (%eax),%eax
     e03:	84 c0                	test   %al,%al
     e05:	75 e2                	jne    de9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e0c:	c9                   	leave  
     e0d:	c3                   	ret    

00000e0e <gets>:

char*
gets(char *buf, int max)
{
     e0e:	55                   	push   %ebp
     e0f:	89 e5                	mov    %esp,%ebp
     e11:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e1b:	eb 4c                	jmp    e69 <gets+0x5b>
    cc = read(0, &c, 1);
     e1d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e24:	00 
     e25:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e28:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e33:	e8 44 01 00 00       	call   f7c <read>
     e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e3f:	7f 02                	jg     e43 <gets+0x35>
      break;
     e41:	eb 31                	jmp    e74 <gets+0x66>
    buf[i++] = c;
     e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e46:	8d 50 01             	lea    0x1(%eax),%edx
     e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e4c:	89 c2                	mov    %eax,%edx
     e4e:	8b 45 08             	mov    0x8(%ebp),%eax
     e51:	01 c2                	add    %eax,%edx
     e53:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e57:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e59:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e5d:	3c 0a                	cmp    $0xa,%al
     e5f:	74 13                	je     e74 <gets+0x66>
     e61:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     e65:	3c 0d                	cmp    $0xd,%al
     e67:	74 0b                	je     e74 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e6c:	83 c0 01             	add    $0x1,%eax
     e6f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e72:	7c a9                	jl     e1d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	01 d0                	add    %edx,%eax
     e7c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e82:	c9                   	leave  
     e83:	c3                   	ret    

00000e84 <stat>:

int
stat(char *n, struct stat *st)
{
     e84:	55                   	push   %ebp
     e85:	89 e5                	mov    %esp,%ebp
     e87:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e91:	00 
     e92:	8b 45 08             	mov    0x8(%ebp),%eax
     e95:	89 04 24             	mov    %eax,(%esp)
     e98:	e8 07 01 00 00       	call   fa4 <open>
     e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ea4:	79 07                	jns    ead <stat+0x29>
    return -1;
     ea6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eab:	eb 23                	jmp    ed0 <stat+0x4c>
  r = fstat(fd, st);
     ead:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb7:	89 04 24             	mov    %eax,(%esp)
     eba:	e8 fd 00 00 00       	call   fbc <fstat>
     ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ec5:	89 04 24             	mov    %eax,(%esp)
     ec8:	e8 bf 00 00 00       	call   f8c <close>
  return r;
     ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ed0:	c9                   	leave  
     ed1:	c3                   	ret    

00000ed2 <atoi>:

int
atoi(const char *s)
{
     ed2:	55                   	push   %ebp
     ed3:	89 e5                	mov    %esp,%ebp
     ed5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ed8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     edf:	eb 25                	jmp    f06 <atoi+0x34>
    n = n*10 + *s++ - '0';
     ee1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ee4:	89 d0                	mov    %edx,%eax
     ee6:	c1 e0 02             	shl    $0x2,%eax
     ee9:	01 d0                	add    %edx,%eax
     eeb:	01 c0                	add    %eax,%eax
     eed:	89 c1                	mov    %eax,%ecx
     eef:	8b 45 08             	mov    0x8(%ebp),%eax
     ef2:	8d 50 01             	lea    0x1(%eax),%edx
     ef5:	89 55 08             	mov    %edx,0x8(%ebp)
     ef8:	0f b6 00             	movzbl (%eax),%eax
     efb:	0f be c0             	movsbl %al,%eax
     efe:	01 c8                	add    %ecx,%eax
     f00:	83 e8 30             	sub    $0x30,%eax
     f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f06:	8b 45 08             	mov    0x8(%ebp),%eax
     f09:	0f b6 00             	movzbl (%eax),%eax
     f0c:	3c 2f                	cmp    $0x2f,%al
     f0e:	7e 0a                	jle    f1a <atoi+0x48>
     f10:	8b 45 08             	mov    0x8(%ebp),%eax
     f13:	0f b6 00             	movzbl (%eax),%eax
     f16:	3c 39                	cmp    $0x39,%al
     f18:	7e c7                	jle    ee1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f1d:	c9                   	leave  
     f1e:	c3                   	ret    

00000f1f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f1f:	55                   	push   %ebp
     f20:	89 e5                	mov    %esp,%ebp
     f22:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     f25:	8b 45 08             	mov    0x8(%ebp),%eax
     f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f31:	eb 17                	jmp    f4a <memmove+0x2b>
    *dst++ = *src++;
     f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f36:	8d 50 01             	lea    0x1(%eax),%edx
     f39:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f3c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f3f:	8d 4a 01             	lea    0x1(%edx),%ecx
     f42:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f45:	0f b6 12             	movzbl (%edx),%edx
     f48:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f4a:	8b 45 10             	mov    0x10(%ebp),%eax
     f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
     f50:	89 55 10             	mov    %edx,0x10(%ebp)
     f53:	85 c0                	test   %eax,%eax
     f55:	7f dc                	jg     f33 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f57:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f5a:	c9                   	leave  
     f5b:	c3                   	ret    

00000f5c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f5c:	b8 01 00 00 00       	mov    $0x1,%eax
     f61:	cd 40                	int    $0x40
     f63:	c3                   	ret    

00000f64 <exit>:
SYSCALL(exit)
     f64:	b8 02 00 00 00       	mov    $0x2,%eax
     f69:	cd 40                	int    $0x40
     f6b:	c3                   	ret    

00000f6c <wait>:
SYSCALL(wait)
     f6c:	b8 03 00 00 00       	mov    $0x3,%eax
     f71:	cd 40                	int    $0x40
     f73:	c3                   	ret    

00000f74 <pipe>:
SYSCALL(pipe)
     f74:	b8 04 00 00 00       	mov    $0x4,%eax
     f79:	cd 40                	int    $0x40
     f7b:	c3                   	ret    

00000f7c <read>:
SYSCALL(read)
     f7c:	b8 05 00 00 00       	mov    $0x5,%eax
     f81:	cd 40                	int    $0x40
     f83:	c3                   	ret    

00000f84 <write>:
SYSCALL(write)
     f84:	b8 10 00 00 00       	mov    $0x10,%eax
     f89:	cd 40                	int    $0x40
     f8b:	c3                   	ret    

00000f8c <close>:
SYSCALL(close)
     f8c:	b8 15 00 00 00       	mov    $0x15,%eax
     f91:	cd 40                	int    $0x40
     f93:	c3                   	ret    

00000f94 <kill>:
SYSCALL(kill)
     f94:	b8 06 00 00 00       	mov    $0x6,%eax
     f99:	cd 40                	int    $0x40
     f9b:	c3                   	ret    

00000f9c <exec>:
SYSCALL(exec)
     f9c:	b8 07 00 00 00       	mov    $0x7,%eax
     fa1:	cd 40                	int    $0x40
     fa3:	c3                   	ret    

00000fa4 <open>:
SYSCALL(open)
     fa4:	b8 0f 00 00 00       	mov    $0xf,%eax
     fa9:	cd 40                	int    $0x40
     fab:	c3                   	ret    

00000fac <mknod>:
SYSCALL(mknod)
     fac:	b8 11 00 00 00       	mov    $0x11,%eax
     fb1:	cd 40                	int    $0x40
     fb3:	c3                   	ret    

00000fb4 <unlink>:
SYSCALL(unlink)
     fb4:	b8 12 00 00 00       	mov    $0x12,%eax
     fb9:	cd 40                	int    $0x40
     fbb:	c3                   	ret    

00000fbc <fstat>:
SYSCALL(fstat)
     fbc:	b8 08 00 00 00       	mov    $0x8,%eax
     fc1:	cd 40                	int    $0x40
     fc3:	c3                   	ret    

00000fc4 <link>:
SYSCALL(link)
     fc4:	b8 13 00 00 00       	mov    $0x13,%eax
     fc9:	cd 40                	int    $0x40
     fcb:	c3                   	ret    

00000fcc <mkdir>:
SYSCALL(mkdir)
     fcc:	b8 14 00 00 00       	mov    $0x14,%eax
     fd1:	cd 40                	int    $0x40
     fd3:	c3                   	ret    

00000fd4 <chdir>:
SYSCALL(chdir)
     fd4:	b8 09 00 00 00       	mov    $0x9,%eax
     fd9:	cd 40                	int    $0x40
     fdb:	c3                   	ret    

00000fdc <dup>:
SYSCALL(dup)
     fdc:	b8 0a 00 00 00       	mov    $0xa,%eax
     fe1:	cd 40                	int    $0x40
     fe3:	c3                   	ret    

00000fe4 <getpid>:
SYSCALL(getpid)
     fe4:	b8 0b 00 00 00       	mov    $0xb,%eax
     fe9:	cd 40                	int    $0x40
     feb:	c3                   	ret    

00000fec <sbrk>:
SYSCALL(sbrk)
     fec:	b8 0c 00 00 00       	mov    $0xc,%eax
     ff1:	cd 40                	int    $0x40
     ff3:	c3                   	ret    

00000ff4 <sleep>:
SYSCALL(sleep)
     ff4:	b8 0d 00 00 00       	mov    $0xd,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <uptime>:
SYSCALL(uptime)
     ffc:	b8 0e 00 00 00       	mov    $0xe,%eax
    1001:	cd 40                	int    $0x40
    1003:	c3                   	ret    

00001004 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1004:	55                   	push   %ebp
    1005:	89 e5                	mov    %esp,%ebp
    1007:	83 ec 18             	sub    $0x18,%esp
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
    100d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1010:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1017:	00 
    1018:	8d 45 f4             	lea    -0xc(%ebp),%eax
    101b:	89 44 24 04          	mov    %eax,0x4(%esp)
    101f:	8b 45 08             	mov    0x8(%ebp),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 5a ff ff ff       	call   f84 <write>
}
    102a:	c9                   	leave  
    102b:	c3                   	ret    

0000102c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    102c:	55                   	push   %ebp
    102d:	89 e5                	mov    %esp,%ebp
    102f:	56                   	push   %esi
    1030:	53                   	push   %ebx
    1031:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1034:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    103b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    103f:	74 17                	je     1058 <printint+0x2c>
    1041:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1045:	79 11                	jns    1058 <printint+0x2c>
    neg = 1;
    1047:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    104e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1051:	f7 d8                	neg    %eax
    1053:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1056:	eb 06                	jmp    105e <printint+0x32>
  } else {
    x = xx;
    1058:	8b 45 0c             	mov    0xc(%ebp),%eax
    105b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    105e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1065:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1068:	8d 41 01             	lea    0x1(%ecx),%eax
    106b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    106e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1071:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1074:	ba 00 00 00 00       	mov    $0x0,%edx
    1079:	f7 f3                	div    %ebx
    107b:	89 d0                	mov    %edx,%eax
    107d:	0f b6 80 3c 1a 00 00 	movzbl 0x1a3c(%eax),%eax
    1084:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1088:	8b 75 10             	mov    0x10(%ebp),%esi
    108b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    108e:	ba 00 00 00 00       	mov    $0x0,%edx
    1093:	f7 f6                	div    %esi
    1095:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1098:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    109c:	75 c7                	jne    1065 <printint+0x39>
  if(neg)
    109e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a2:	74 10                	je     10b4 <printint+0x88>
    buf[i++] = '-';
    10a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a7:	8d 50 01             	lea    0x1(%eax),%edx
    10aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
    10ad:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    10b2:	eb 1f                	jmp    10d3 <printint+0xa7>
    10b4:	eb 1d                	jmp    10d3 <printint+0xa7>
    putc(fd, buf[i]);
    10b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
    10b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10bc:	01 d0                	add    %edx,%eax
    10be:	0f b6 00             	movzbl (%eax),%eax
    10c1:	0f be c0             	movsbl %al,%eax
    10c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	89 04 24             	mov    %eax,(%esp)
    10ce:	e8 31 ff ff ff       	call   1004 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    10d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10db:	79 d9                	jns    10b6 <printint+0x8a>
    putc(fd, buf[i]);
}
    10dd:	83 c4 30             	add    $0x30,%esp
    10e0:	5b                   	pop    %ebx
    10e1:	5e                   	pop    %esi
    10e2:	5d                   	pop    %ebp
    10e3:	c3                   	ret    

000010e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
    10e7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10f1:	8d 45 0c             	lea    0xc(%ebp),%eax
    10f4:	83 c0 04             	add    $0x4,%eax
    10f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1101:	e9 7c 01 00 00       	jmp    1282 <printf+0x19e>
    c = fmt[i] & 0xff;
    1106:	8b 55 0c             	mov    0xc(%ebp),%edx
    1109:	8b 45 f0             	mov    -0x10(%ebp),%eax
    110c:	01 d0                	add    %edx,%eax
    110e:	0f b6 00             	movzbl (%eax),%eax
    1111:	0f be c0             	movsbl %al,%eax
    1114:	25 ff 00 00 00       	and    $0xff,%eax
    1119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    111c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1120:	75 2c                	jne    114e <printf+0x6a>
      if(c == '%'){
    1122:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1126:	75 0c                	jne    1134 <printf+0x50>
        state = '%';
    1128:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    112f:	e9 4a 01 00 00       	jmp    127e <printf+0x19a>
      } else {
        putc(fd, c);
    1134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1137:	0f be c0             	movsbl %al,%eax
    113a:	89 44 24 04          	mov    %eax,0x4(%esp)
    113e:	8b 45 08             	mov    0x8(%ebp),%eax
    1141:	89 04 24             	mov    %eax,(%esp)
    1144:	e8 bb fe ff ff       	call   1004 <putc>
    1149:	e9 30 01 00 00       	jmp    127e <printf+0x19a>
      }
    } else if(state == '%'){
    114e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1152:	0f 85 26 01 00 00    	jne    127e <printf+0x19a>
      if(c == 'd'){
    1158:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    115c:	75 2d                	jne    118b <printf+0xa7>
        printint(fd, *ap, 10, 1);
    115e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1161:	8b 00                	mov    (%eax),%eax
    1163:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    116a:	00 
    116b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1172:	00 
    1173:	89 44 24 04          	mov    %eax,0x4(%esp)
    1177:	8b 45 08             	mov    0x8(%ebp),%eax
    117a:	89 04 24             	mov    %eax,(%esp)
    117d:	e8 aa fe ff ff       	call   102c <printint>
        ap++;
    1182:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1186:	e9 ec 00 00 00       	jmp    1277 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    118b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    118f:	74 06                	je     1197 <printf+0xb3>
    1191:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1195:	75 2d                	jne    11c4 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1197:	8b 45 e8             	mov    -0x18(%ebp),%eax
    119a:	8b 00                	mov    (%eax),%eax
    119c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    11a3:	00 
    11a4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    11ab:	00 
    11ac:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b0:	8b 45 08             	mov    0x8(%ebp),%eax
    11b3:	89 04 24             	mov    %eax,(%esp)
    11b6:	e8 71 fe ff ff       	call   102c <printint>
        ap++;
    11bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11bf:	e9 b3 00 00 00       	jmp    1277 <printf+0x193>
      } else if(c == 's'){
    11c4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    11c8:	75 45                	jne    120f <printf+0x12b>
        s = (char*)*ap;
    11ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11cd:	8b 00                	mov    (%eax),%eax
    11cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    11d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    11d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11da:	75 09                	jne    11e5 <printf+0x101>
          s = "(null)";
    11dc:	c7 45 f4 a4 15 00 00 	movl   $0x15a4,-0xc(%ebp)
        while(*s != 0){
    11e3:	eb 1e                	jmp    1203 <printf+0x11f>
    11e5:	eb 1c                	jmp    1203 <printf+0x11f>
          putc(fd, *s);
    11e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ea:	0f b6 00             	movzbl (%eax),%eax
    11ed:	0f be c0             	movsbl %al,%eax
    11f0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	89 04 24             	mov    %eax,(%esp)
    11fa:	e8 05 fe ff ff       	call   1004 <putc>
          s++;
    11ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1203:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1206:	0f b6 00             	movzbl (%eax),%eax
    1209:	84 c0                	test   %al,%al
    120b:	75 da                	jne    11e7 <printf+0x103>
    120d:	eb 68                	jmp    1277 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    120f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1213:	75 1d                	jne    1232 <printf+0x14e>
        putc(fd, *ap);
    1215:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1218:	8b 00                	mov    (%eax),%eax
    121a:	0f be c0             	movsbl %al,%eax
    121d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1221:	8b 45 08             	mov    0x8(%ebp),%eax
    1224:	89 04 24             	mov    %eax,(%esp)
    1227:	e8 d8 fd ff ff       	call   1004 <putc>
        ap++;
    122c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1230:	eb 45                	jmp    1277 <printf+0x193>
      } else if(c == '%'){
    1232:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1236:	75 17                	jne    124f <printf+0x16b>
        putc(fd, c);
    1238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    123b:	0f be c0             	movsbl %al,%eax
    123e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1242:	8b 45 08             	mov    0x8(%ebp),%eax
    1245:	89 04 24             	mov    %eax,(%esp)
    1248:	e8 b7 fd ff ff       	call   1004 <putc>
    124d:	eb 28                	jmp    1277 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    124f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1256:	00 
    1257:	8b 45 08             	mov    0x8(%ebp),%eax
    125a:	89 04 24             	mov    %eax,(%esp)
    125d:	e8 a2 fd ff ff       	call   1004 <putc>
        putc(fd, c);
    1262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1265:	0f be c0             	movsbl %al,%eax
    1268:	89 44 24 04          	mov    %eax,0x4(%esp)
    126c:	8b 45 08             	mov    0x8(%ebp),%eax
    126f:	89 04 24             	mov    %eax,(%esp)
    1272:	e8 8d fd ff ff       	call   1004 <putc>
      }
      state = 0;
    1277:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    127e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1282:	8b 55 0c             	mov    0xc(%ebp),%edx
    1285:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1288:	01 d0                	add    %edx,%eax
    128a:	0f b6 00             	movzbl (%eax),%eax
    128d:	84 c0                	test   %al,%al
    128f:	0f 85 71 fe ff ff    	jne    1106 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1295:	c9                   	leave  
    1296:	c3                   	ret    
    1297:	90                   	nop

00001298 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1298:	55                   	push   %ebp
    1299:	89 e5                	mov    %esp,%ebp
    129b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    129e:	8b 45 08             	mov    0x8(%ebp),%eax
    12a1:	83 e8 08             	sub    $0x8,%eax
    12a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12a7:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    12ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12af:	eb 24                	jmp    12d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b4:	8b 00                	mov    (%eax),%eax
    12b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12b9:	77 12                	ja     12cd <free+0x35>
    12bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12c1:	77 24                	ja     12e7 <free+0x4f>
    12c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c6:	8b 00                	mov    (%eax),%eax
    12c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12cb:	77 1a                	ja     12e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d0:	8b 00                	mov    (%eax),%eax
    12d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    12db:	76 d4                	jbe    12b1 <free+0x19>
    12dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e0:	8b 00                	mov    (%eax),%eax
    12e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    12e5:	76 ca                	jbe    12b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    12e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ea:	8b 40 04             	mov    0x4(%eax),%eax
    12ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f7:	01 c2                	add    %eax,%edx
    12f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fc:	8b 00                	mov    (%eax),%eax
    12fe:	39 c2                	cmp    %eax,%edx
    1300:	75 24                	jne    1326 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1302:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1305:	8b 50 04             	mov    0x4(%eax),%edx
    1308:	8b 45 fc             	mov    -0x4(%ebp),%eax
    130b:	8b 00                	mov    (%eax),%eax
    130d:	8b 40 04             	mov    0x4(%eax),%eax
    1310:	01 c2                	add    %eax,%edx
    1312:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1315:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1318:	8b 45 fc             	mov    -0x4(%ebp),%eax
    131b:	8b 00                	mov    (%eax),%eax
    131d:	8b 10                	mov    (%eax),%edx
    131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1322:	89 10                	mov    %edx,(%eax)
    1324:	eb 0a                	jmp    1330 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1326:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1329:	8b 10                	mov    (%eax),%edx
    132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    132e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1330:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1333:	8b 40 04             	mov    0x4(%eax),%eax
    1336:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1340:	01 d0                	add    %edx,%eax
    1342:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1345:	75 20                	jne    1367 <free+0xcf>
    p->s.size += bp->s.size;
    1347:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134a:	8b 50 04             	mov    0x4(%eax),%edx
    134d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1350:	8b 40 04             	mov    0x4(%eax),%eax
    1353:	01 c2                	add    %eax,%edx
    1355:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1358:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    135b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    135e:	8b 10                	mov    (%eax),%edx
    1360:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1363:	89 10                	mov    %edx,(%eax)
    1365:	eb 08                	jmp    136f <free+0xd7>
  } else
    p->s.ptr = bp;
    1367:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    136d:	89 10                	mov    %edx,(%eax)
  freep = p;
    136f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1372:	a3 cc 1a 00 00       	mov    %eax,0x1acc
}
    1377:	c9                   	leave  
    1378:	c3                   	ret    

00001379 <morecore>:

static Header*
morecore(uint nu)
{
    1379:	55                   	push   %ebp
    137a:	89 e5                	mov    %esp,%ebp
    137c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    137f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1386:	77 07                	ja     138f <morecore+0x16>
    nu = 4096;
    1388:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    138f:	8b 45 08             	mov    0x8(%ebp),%eax
    1392:	c1 e0 03             	shl    $0x3,%eax
    1395:	89 04 24             	mov    %eax,(%esp)
    1398:	e8 4f fc ff ff       	call   fec <sbrk>
    139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    13a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    13a4:	75 07                	jne    13ad <morecore+0x34>
    return 0;
    13a6:	b8 00 00 00 00       	mov    $0x0,%eax
    13ab:	eb 22                	jmp    13cf <morecore+0x56>
  hp = (Header*)p;
    13ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    13b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13b6:	8b 55 08             	mov    0x8(%ebp),%edx
    13b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    13bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13bf:	83 c0 08             	add    $0x8,%eax
    13c2:	89 04 24             	mov    %eax,(%esp)
    13c5:	e8 ce fe ff ff       	call   1298 <free>
  return freep;
    13ca:	a1 cc 1a 00 00       	mov    0x1acc,%eax
}
    13cf:	c9                   	leave  
    13d0:	c3                   	ret    

000013d1 <malloc>:

void*
malloc(uint nbytes)
{
    13d1:	55                   	push   %ebp
    13d2:	89 e5                	mov    %esp,%ebp
    13d4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	83 c0 07             	add    $0x7,%eax
    13dd:	c1 e8 03             	shr    $0x3,%eax
    13e0:	83 c0 01             	add    $0x1,%eax
    13e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    13e6:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    13eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    13ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13f2:	75 23                	jne    1417 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13f4:	c7 45 f0 c4 1a 00 00 	movl   $0x1ac4,-0x10(%ebp)
    13fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13fe:	a3 cc 1a 00 00       	mov    %eax,0x1acc
    1403:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    1408:	a3 c4 1a 00 00       	mov    %eax,0x1ac4
    base.s.size = 0;
    140d:	c7 05 c8 1a 00 00 00 	movl   $0x0,0x1ac8
    1414:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1417:	8b 45 f0             	mov    -0x10(%ebp),%eax
    141a:	8b 00                	mov    (%eax),%eax
    141c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    141f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1422:	8b 40 04             	mov    0x4(%eax),%eax
    1425:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1428:	72 4d                	jb     1477 <malloc+0xa6>
      if(p->s.size == nunits)
    142a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142d:	8b 40 04             	mov    0x4(%eax),%eax
    1430:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1433:	75 0c                	jne    1441 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1435:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1438:	8b 10                	mov    (%eax),%edx
    143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    143d:	89 10                	mov    %edx,(%eax)
    143f:	eb 26                	jmp    1467 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1441:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1444:	8b 40 04             	mov    0x4(%eax),%eax
    1447:	2b 45 ec             	sub    -0x14(%ebp),%eax
    144a:	89 c2                	mov    %eax,%edx
    144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1452:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1455:	8b 40 04             	mov    0x4(%eax),%eax
    1458:	c1 e0 03             	shl    $0x3,%eax
    145b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    145e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1461:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1464:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1467:	8b 45 f0             	mov    -0x10(%ebp),%eax
    146a:	a3 cc 1a 00 00       	mov    %eax,0x1acc
      return (void*)(p + 1);
    146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1472:	83 c0 08             	add    $0x8,%eax
    1475:	eb 38                	jmp    14af <malloc+0xde>
    }
    if(p == freep)
    1477:	a1 cc 1a 00 00       	mov    0x1acc,%eax
    147c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    147f:	75 1b                	jne    149c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1481:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1484:	89 04 24             	mov    %eax,(%esp)
    1487:	e8 ed fe ff ff       	call   1379 <morecore>
    148c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    148f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1493:	75 07                	jne    149c <malloc+0xcb>
        return 0;
    1495:	b8 00 00 00 00       	mov    $0x0,%eax
    149a:	eb 13                	jmp    14af <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a5:	8b 00                	mov    (%eax),%eax
    14a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    14aa:	e9 70 ff ff ff       	jmp    141f <malloc+0x4e>
}
    14af:	c9                   	leave  
    14b0:	c3                   	ret    
