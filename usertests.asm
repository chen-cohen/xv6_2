
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 c8 62 00 00       	mov    0x62c8,%eax
       b:	c7 44 24 04 1e 44 00 	movl   $0x441e,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 1d 40 00 00       	call   4038 <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 29 44 00 00 	movl   $0x4429,(%esp)
      22:	e8 f9 3e 00 00       	call   3f20 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 c8 62 00 00       	mov    0x62c8,%eax
      30:	c7 44 24 04 31 44 00 	movl   $0x4431,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 f8 3f 00 00       	call   4038 <printf>
    exit();
      40:	e8 73 3e 00 00       	call   3eb8 <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 29 44 00 00 	movl   $0x4429,(%esp)
      4c:	e8 d7 3e 00 00       	call   3f28 <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 c8 62 00 00       	mov    0x62c8,%eax
      5a:	c7 44 24 04 3f 44 00 	movl   $0x443f,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 ce 3f 00 00       	call   4038 <printf>
    exit();
      6a:	e8 49 3e 00 00       	call   3eb8 <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 55 44 00 00 	movl   $0x4455,(%esp)
      76:	e8 8d 3e 00 00       	call   3f08 <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 c8 62 00 00       	mov    0x62c8,%eax
      84:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 a4 3f 00 00       	call   4038 <printf>
    exit();
      94:	e8 1f 3e 00 00       	call   3eb8 <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 7a 44 00 00 	movl   $0x447a,(%esp)
      a0:	e8 83 3e 00 00       	call   3f28 <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 c8 62 00 00       	mov    0x62c8,%eax
      ae:	c7 44 24 04 7c 44 00 	movl   $0x447c,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 7a 3f 00 00       	call   4038 <printf>
    exit();
      be:	e8 f5 3d 00 00       	call   3eb8 <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 c8 62 00 00       	mov    0x62c8,%eax
      c8:	c7 44 24 04 8c 44 00 	movl   $0x448c,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 60 3f 00 00       	call   4038 <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 c8 62 00 00       	mov    0x62c8,%eax
      e5:	c7 44 24 04 9a 44 00 	movl   $0x449a,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 43 3f 00 00       	call   4038 <printf>

  pid = fork();
      f5:	e8 b6 3d 00 00       	call   3eb0 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 c8 62 00 00       	mov    0x62c8,%eax
     108:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 20 3f 00 00       	call   4038 <printf>
    exit();
     118:	e8 9b 3d 00 00       	call   3eb8 <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 29 44 00 00 	movl   $0x4429,(%esp)
     12e:	e8 ed 3d 00 00       	call   3f20 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 c8 62 00 00       	mov    0x62c8,%eax
     13c:	c7 44 24 04 31 44 00 	movl   $0x4431,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 ec 3e 00 00       	call   4038 <printf>
      exit();
     14c:	e8 67 3d 00 00       	call   3eb8 <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 29 44 00 00 	movl   $0x4429,(%esp)
     158:	e8 cb 3d 00 00       	call   3f28 <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 c8 62 00 00       	mov    0x62c8,%eax
     166:	c7 44 24 04 b6 44 00 	movl   $0x44b6,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 c2 3e 00 00       	call   4038 <printf>
      exit();
     176:	e8 3d 3d 00 00       	call   3eb8 <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 55 44 00 00 	movl   $0x4455,(%esp)
     182:	e8 81 3d 00 00       	call   3f08 <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 c8 62 00 00       	mov    0x62c8,%eax
     190:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 98 3e 00 00       	call   4038 <printf>
      exit();
     1a0:	e8 13 3d 00 00       	call   3eb8 <exit>
    }
    exit();
     1a5:	e8 0e 3d 00 00       	call   3eb8 <exit>
  }
  wait();
     1aa:	e8 11 3d 00 00       	call   3ec0 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 c8 62 00 00       	mov    0x62c8,%eax
     1b4:	c7 44 24 04 ca 44 00 	movl   $0x44ca,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 74 3e 00 00       	call   4038 <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 c8 62 00 00       	mov    0x62c8,%eax
     1d1:	c7 44 24 04 dc 44 00 	movl   $0x44dc,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 57 3e 00 00       	call   4038 <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 eb 44 00 00 	movl   $0x44eb,(%esp)
     1e8:	e8 33 3d 00 00       	call   3f20 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 c8 62 00 00       	mov    0x62c8,%eax
     1f6:	c7 44 24 04 f1 44 00 	movl   $0x44f1,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 32 3e 00 00       	call   4038 <printf>
    exit();
     206:	e8 ad 3c 00 00       	call   3eb8 <exit>
  }
  pid = fork();
     20b:	e8 a0 3c 00 00       	call   3eb0 <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 c8 62 00 00       	mov    0x62c8,%eax
     21e:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 0a 3e 00 00       	call   4038 <printf>
    exit();
     22e:	e8 85 3c 00 00       	call   3eb8 <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 eb 44 00 00 	movl   $0x44eb,(%esp)
     248:	e8 ab 3c 00 00       	call   3ef8 <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 c8 62 00 00       	mov    0x62c8,%eax
     25b:	c7 44 24 04 08 45 00 	movl   $0x4508,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 cd 3d 00 00       	call   4038 <printf>
      exit();
     26b:	e8 48 3c 00 00       	call   3eb8 <exit>
    }
    exit();
     270:	e8 43 3c 00 00       	call   3eb8 <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 c7 3c 00 00       	call   3f48 <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 eb 44 00 00 	movl   $0x44eb,(%esp)
     288:	e8 7b 3c 00 00       	call   3f08 <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 c8 62 00 00       	mov    0x62c8,%eax
     296:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 92 3d 00 00       	call   4038 <printf>
    exit();
     2a6:	e8 0d 3c 00 00       	call   3eb8 <exit>
  }
  wait();
     2ab:	e8 10 3c 00 00       	call   3ec0 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 c8 62 00 00       	mov    0x62c8,%eax
     2b5:	c7 44 24 04 3b 45 00 	movl   $0x453b,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 73 3d 00 00       	call   4038 <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 c8 62 00 00       	mov    0x62c8,%eax
     2d2:	c7 44 24 04 4d 45 00 	movl   $0x454d,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 56 3d 00 00       	call   4038 <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 08 44 00 00 	movl   $0x4408,(%esp)
     2f1:	e8 02 3c 00 00       	call   3ef8 <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 c8 62 00 00       	mov    0x62c8,%eax
     304:	c7 44 24 04 58 45 00 	movl   $0x4558,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 24 3d 00 00       	call   4038 <printf>
    exit();
     314:	e8 9f 3b 00 00       	call   3eb8 <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 bc 3b 00 00       	call   3ee0 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 6b 45 00 00 	movl   $0x456b,(%esp)
     333:	e8 c0 3b 00 00       	call   3ef8 <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 c8 62 00 00       	mov    0x62c8,%eax
     346:	c7 44 24 04 78 45 00 	movl   $0x4578,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 e2 3c 00 00       	call   4038 <printf>
    exit();
     356:	e8 5d 3b 00 00       	call   3eb8 <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 c8 62 00 00       	mov    0x62c8,%eax
     360:	c7 44 24 04 96 45 00 	movl   $0x4596,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 c8 3c 00 00       	call   4038 <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 c8 62 00 00       	mov    0x62c8,%eax
     37d:	c7 44 24 04 a4 45 00 	movl   $0x45a4,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 ab 3c 00 00       	call   4038 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 b5 45 00 00 	movl   $0x45b5,(%esp)
     39c:	e8 57 3b 00 00       	call   3ef8 <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 c8 62 00 00       	mov    0x62c8,%eax
     3af:	c7 44 24 04 bb 45 00 	movl   $0x45bb,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 79 3c 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 a0 00 00 00       	jmp    46b <writetest+0xf9>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 c8 62 00 00       	mov    0x62c8,%eax
     3d0:	c7 44 24 04 d6 45 00 	movl   $0x45d6,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 58 3c 00 00       	call   4038 <printf>
    exit();
     3e0:	e8 d3 3a 00 00       	call   3eb8 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 f2 45 00 	movl   $0x45f2,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 d8 3a 00 00       	call   3ed8 <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 c8 62 00 00       	mov    0x62c8,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 00 46 00 	movl   $0x4600,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 17 3c 00 00       	call   4038 <printf>
      exit();
     421:	e8 92 3a 00 00       	call   3eb8 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 24 46 00 	movl   $0x4624,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 97 3a 00 00       	call   3ed8 <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 c8 62 00 00       	mov    0x62c8,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 30 46 00 	movl   $0x4630,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 d6 3b 00 00       	call   4038 <printf>
      exit();
     462:	e8 51 3a 00 00       	call   3eb8 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     46b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46f:	0f 8e 70 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     475:	a1 c8 62 00 00       	mov    0x62c8,%eax
     47a:	c7 44 24 04 54 46 00 	movl   $0x4654,0x4(%esp)
     481:	00 
     482:	89 04 24             	mov    %eax,(%esp)
     485:	e8 ae 3b 00 00       	call   4038 <printf>
  close(fd);
     48a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 4b 3a 00 00       	call   3ee0 <close>
  fd = open("small", O_RDONLY);
     495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49c:	00 
     49d:	c7 04 24 b5 45 00 00 	movl   $0x45b5,(%esp)
     4a4:	e8 4f 3a 00 00       	call   3ef8 <open>
     4a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4b0:	78 3e                	js     4f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
     4b2:	a1 c8 62 00 00       	mov    0x62c8,%eax
     4b7:	c7 44 24 04 5f 46 00 	movl   $0x465f,0x4(%esp)
     4be:	00 
     4bf:	89 04 24             	mov    %eax,(%esp)
     4c2:	e8 71 3b 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4ce:	00 
     4cf:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     4d6:	00 
     4d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4da:	89 04 24             	mov    %eax,(%esp)
     4dd:	e8 ee 39 00 00       	call   3ed0 <read>
     4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4ec:	75 4e                	jne    53c <writetest+0x1ca>
     4ee:	eb 1a                	jmp    50a <writetest+0x198>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4f0:	a1 c8 62 00 00       	mov    0x62c8,%eax
     4f5:	c7 44 24 04 78 46 00 	movl   $0x4678,0x4(%esp)
     4fc:	00 
     4fd:	89 04 24             	mov    %eax,(%esp)
     500:	e8 33 3b 00 00       	call   4038 <printf>
    exit();
     505:	e8 ae 39 00 00       	call   3eb8 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     50a:	a1 c8 62 00 00       	mov    0x62c8,%eax
     50f:	c7 44 24 04 93 46 00 	movl   $0x4693,0x4(%esp)
     516:	00 
     517:	89 04 24             	mov    %eax,(%esp)
     51a:	e8 19 3b 00 00       	call   4038 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     522:	89 04 24             	mov    %eax,(%esp)
     525:	e8 b6 39 00 00       	call   3ee0 <close>

  if(unlink("small") < 0){
     52a:	c7 04 24 b5 45 00 00 	movl   $0x45b5,(%esp)
     531:	e8 d2 39 00 00       	call   3f08 <unlink>
     536:	85 c0                	test   %eax,%eax
     538:	79 36                	jns    570 <writetest+0x1fe>
     53a:	eb 1a                	jmp    556 <writetest+0x1e4>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53c:	a1 c8 62 00 00       	mov    0x62c8,%eax
     541:	c7 44 24 04 a6 46 00 	movl   $0x46a6,0x4(%esp)
     548:	00 
     549:	89 04 24             	mov    %eax,(%esp)
     54c:	e8 e7 3a 00 00       	call   4038 <printf>
    exit();
     551:	e8 62 39 00 00       	call   3eb8 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     556:	a1 c8 62 00 00       	mov    0x62c8,%eax
     55b:	c7 44 24 04 b3 46 00 	movl   $0x46b3,0x4(%esp)
     562:	00 
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 cd 3a 00 00       	call   4038 <printf>
    exit();
     56b:	e8 48 39 00 00       	call   3eb8 <exit>
  }
  printf(stdout, "small file test ok\n");
     570:	a1 c8 62 00 00       	mov    0x62c8,%eax
     575:	c7 44 24 04 c8 46 00 	movl   $0x46c8,0x4(%esp)
     57c:	00 
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 b3 3a 00 00       	call   4038 <printf>
}
     585:	c9                   	leave  
     586:	c3                   	ret    

00000587 <writetest1>:

void
writetest1(void)
{
     587:	55                   	push   %ebp
     588:	89 e5                	mov    %esp,%ebp
     58a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58d:	a1 c8 62 00 00       	mov    0x62c8,%eax
     592:	c7 44 24 04 dc 46 00 	movl   $0x46dc,0x4(%esp)
     599:	00 
     59a:	89 04 24             	mov    %eax,(%esp)
     59d:	e8 96 3a 00 00       	call   4038 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a9:	00 
     5aa:	c7 04 24 ec 46 00 00 	movl   $0x46ec,(%esp)
     5b1:	e8 42 39 00 00       	call   3ef8 <open>
     5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bd:	79 1a                	jns    5d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5bf:	a1 c8 62 00 00       	mov    0x62c8,%eax
     5c4:	c7 44 24 04 f0 46 00 	movl   $0x46f0,0x4(%esp)
     5cb:	00 
     5cc:	89 04 24             	mov    %eax,(%esp)
     5cf:	e8 64 3a 00 00       	call   4038 <printf>
    exit();
     5d4:	e8 df 38 00 00       	call   3eb8 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5e0:	eb 51                	jmp    633 <writetest1+0xac>
    ((int*)buf)[0] = i;
     5e2:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
     5e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f3:	00 
     5f4:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     5fb:	00 
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	89 04 24             	mov    %eax,(%esp)
     602:	e8 d1 38 00 00       	call   3ed8 <write>
     607:	3d 00 02 00 00       	cmp    $0x200,%eax
     60c:	74 21                	je     62f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60e:	a1 c8 62 00 00       	mov    0x62c8,%eax
     613:	8b 55 f4             	mov    -0xc(%ebp),%edx
     616:	89 54 24 08          	mov    %edx,0x8(%esp)
     61a:	c7 44 24 04 0a 47 00 	movl   $0x470a,0x4(%esp)
     621:	00 
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 0e 3a 00 00       	call   4038 <printf>
      exit();
     62a:	e8 89 38 00 00       	call   3eb8 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     633:	8b 45 f4             	mov    -0xc(%ebp),%eax
     636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     63b:	76 a5                	jbe    5e2 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     640:	89 04 24             	mov    %eax,(%esp)
     643:	e8 98 38 00 00       	call   3ee0 <close>

  fd = open("big", O_RDONLY);
     648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64f:	00 
     650:	c7 04 24 ec 46 00 00 	movl   $0x46ec,(%esp)
     657:	e8 9c 38 00 00       	call   3ef8 <open>
     65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     663:	79 1a                	jns    67f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
     665:	a1 c8 62 00 00       	mov    0x62c8,%eax
     66a:	c7 44 24 04 28 47 00 	movl   $0x4728,0x4(%esp)
     671:	00 
     672:	89 04 24             	mov    %eax,(%esp)
     675:	e8 be 39 00 00       	call   4038 <printf>
    exit();
     67a:	e8 39 38 00 00       	call   3eb8 <exit>
  }

  n = 0;
     67f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68d:	00 
     68e:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     695:	00 
     696:	8b 45 ec             	mov    -0x14(%ebp),%eax
     699:	89 04 24             	mov    %eax,(%esp)
     69c:	e8 2f 38 00 00       	call   3ed0 <read>
     6a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a8:	75 4c                	jne    6f6 <writetest1+0x16f>
      if(n == MAXFILE - 1){
     6aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6b1:	75 21                	jne    6d4 <writetest1+0x14d>
        printf(stdout, "read only %d blocks from big", n);
     6b3:	a1 c8 62 00 00       	mov    0x62c8,%eax
     6b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bb:	89 54 24 08          	mov    %edx,0x8(%esp)
     6bf:	c7 44 24 04 41 47 00 	movl   $0x4741,0x4(%esp)
     6c6:	00 
     6c7:	89 04 24             	mov    %eax,(%esp)
     6ca:	e8 69 39 00 00       	call   4038 <printf>
        exit();
     6cf:	e8 e4 37 00 00       	call   3eb8 <exit>
      }
      break;
     6d4:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     6d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6d8:	89 04 24             	mov    %eax,(%esp)
     6db:	e8 00 38 00 00       	call   3ee0 <close>
  if(unlink("big") < 0){
     6e0:	c7 04 24 ec 46 00 00 	movl   $0x46ec,(%esp)
     6e7:	e8 1c 38 00 00       	call   3f08 <unlink>
     6ec:	85 c0                	test   %eax,%eax
     6ee:	0f 89 87 00 00 00    	jns    77b <writetest1+0x1f4>
     6f4:	eb 6b                	jmp    761 <writetest1+0x1da>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     6f6:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6fd:	74 21                	je     720 <writetest1+0x199>
      printf(stdout, "read failed %d\n", i);
     6ff:	a1 c8 62 00 00       	mov    0x62c8,%eax
     704:	8b 55 f4             	mov    -0xc(%ebp),%edx
     707:	89 54 24 08          	mov    %edx,0x8(%esp)
     70b:	c7 44 24 04 5e 47 00 	movl   $0x475e,0x4(%esp)
     712:	00 
     713:	89 04 24             	mov    %eax,(%esp)
     716:	e8 1d 39 00 00       	call   4038 <printf>
      exit();
     71b:	e8 98 37 00 00       	call   3eb8 <exit>
    }
    if(((int*)buf)[0] != n){
     720:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
     725:	8b 00                	mov    (%eax),%eax
     727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     72a:	74 2c                	je     758 <writetest1+0x1d1>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     72c:	b8 c0 8a 00 00       	mov    $0x8ac0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     731:	8b 10                	mov    (%eax),%edx
     733:	a1 c8 62 00 00       	mov    0x62c8,%eax
     738:	89 54 24 0c          	mov    %edx,0xc(%esp)
     73c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     73f:	89 54 24 08          	mov    %edx,0x8(%esp)
     743:	c7 44 24 04 70 47 00 	movl   $0x4770,0x4(%esp)
     74a:	00 
     74b:	89 04 24             	mov    %eax,(%esp)
     74e:	e8 e5 38 00 00       	call   4038 <printf>
             n, ((int*)buf)[0]);
      exit();
     753:	e8 60 37 00 00       	call   3eb8 <exit>
    }
    n++;
     758:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
     75c:	e9 25 ff ff ff       	jmp    686 <writetest1+0xff>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     761:	a1 c8 62 00 00       	mov    0x62c8,%eax
     766:	c7 44 24 04 90 47 00 	movl   $0x4790,0x4(%esp)
     76d:	00 
     76e:	89 04 24             	mov    %eax,(%esp)
     771:	e8 c2 38 00 00       	call   4038 <printf>
    exit();
     776:	e8 3d 37 00 00       	call   3eb8 <exit>
  }
  printf(stdout, "big files ok\n");
     77b:	a1 c8 62 00 00       	mov    0x62c8,%eax
     780:	c7 44 24 04 a3 47 00 	movl   $0x47a3,0x4(%esp)
     787:	00 
     788:	89 04 24             	mov    %eax,(%esp)
     78b:	e8 a8 38 00 00       	call   4038 <printf>
}
     790:	c9                   	leave  
     791:	c3                   	ret    

00000792 <createtest>:

void
createtest(void)
{
     792:	55                   	push   %ebp
     793:	89 e5                	mov    %esp,%ebp
     795:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     798:	a1 c8 62 00 00       	mov    0x62c8,%eax
     79d:	c7 44 24 04 b4 47 00 	movl   $0x47b4,0x4(%esp)
     7a4:	00 
     7a5:	89 04 24             	mov    %eax,(%esp)
     7a8:	e8 8b 38 00 00       	call   4038 <printf>

  name[0] = 'a';
     7ad:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     7b4:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     7bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7c2:	eb 31                	jmp    7f5 <createtest+0x63>
    name[1] = '0' + i;
     7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c7:	83 c0 30             	add    $0x30,%eax
     7ca:	a2 c1 aa 00 00       	mov    %al,0xaac1
    fd = open(name, O_CREATE|O_RDWR);
     7cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d6:	00 
     7d7:	c7 04 24 c0 aa 00 00 	movl   $0xaac0,(%esp)
     7de:	e8 15 37 00 00       	call   3ef8 <open>
     7e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e9:	89 04 24             	mov    %eax,(%esp)
     7ec:	e8 ef 36 00 00       	call   3ee0 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7f5:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f9:	7e c9                	jle    7c4 <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7fb:	c6 05 c0 aa 00 00 61 	movb   $0x61,0xaac0
  name[2] = '\0';
     802:	c6 05 c2 aa 00 00 00 	movb   $0x0,0xaac2
  for(i = 0; i < 52; i++){
     809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     810:	eb 1b                	jmp    82d <createtest+0x9b>
    name[1] = '0' + i;
     812:	8b 45 f4             	mov    -0xc(%ebp),%eax
     815:	83 c0 30             	add    $0x30,%eax
     818:	a2 c1 aa 00 00       	mov    %al,0xaac1
    unlink(name);
     81d:	c7 04 24 c0 aa 00 00 	movl   $0xaac0,(%esp)
     824:	e8 df 36 00 00       	call   3f08 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     82d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     831:	7e df                	jle    812 <createtest+0x80>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     833:	a1 c8 62 00 00       	mov    0x62c8,%eax
     838:	c7 44 24 04 dc 47 00 	movl   $0x47dc,0x4(%esp)
     83f:	00 
     840:	89 04 24             	mov    %eax,(%esp)
     843:	e8 f0 37 00 00       	call   4038 <printf>
}
     848:	c9                   	leave  
     849:	c3                   	ret    

0000084a <dirtest>:

void dirtest(void)
{
     84a:	55                   	push   %ebp
     84b:	89 e5                	mov    %esp,%ebp
     84d:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     850:	a1 c8 62 00 00       	mov    0x62c8,%eax
     855:	c7 44 24 04 02 48 00 	movl   $0x4802,0x4(%esp)
     85c:	00 
     85d:	89 04 24             	mov    %eax,(%esp)
     860:	e8 d3 37 00 00       	call   4038 <printf>

  if(mkdir("dir0") < 0){
     865:	c7 04 24 0e 48 00 00 	movl   $0x480e,(%esp)
     86c:	e8 af 36 00 00       	call   3f20 <mkdir>
     871:	85 c0                	test   %eax,%eax
     873:	79 1a                	jns    88f <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     875:	a1 c8 62 00 00       	mov    0x62c8,%eax
     87a:	c7 44 24 04 31 44 00 	movl   $0x4431,0x4(%esp)
     881:	00 
     882:	89 04 24             	mov    %eax,(%esp)
     885:	e8 ae 37 00 00       	call   4038 <printf>
    exit();
     88a:	e8 29 36 00 00       	call   3eb8 <exit>
  }

  if(chdir("dir0") < 0){
     88f:	c7 04 24 0e 48 00 00 	movl   $0x480e,(%esp)
     896:	e8 8d 36 00 00       	call   3f28 <chdir>
     89b:	85 c0                	test   %eax,%eax
     89d:	79 1a                	jns    8b9 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     89f:	a1 c8 62 00 00       	mov    0x62c8,%eax
     8a4:	c7 44 24 04 13 48 00 	movl   $0x4813,0x4(%esp)
     8ab:	00 
     8ac:	89 04 24             	mov    %eax,(%esp)
     8af:	e8 84 37 00 00       	call   4038 <printf>
    exit();
     8b4:	e8 ff 35 00 00       	call   3eb8 <exit>
  }

  if(chdir("..") < 0){
     8b9:	c7 04 24 26 48 00 00 	movl   $0x4826,(%esp)
     8c0:	e8 63 36 00 00       	call   3f28 <chdir>
     8c5:	85 c0                	test   %eax,%eax
     8c7:	79 1a                	jns    8e3 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c9:	a1 c8 62 00 00       	mov    0x62c8,%eax
     8ce:	c7 44 24 04 29 48 00 	movl   $0x4829,0x4(%esp)
     8d5:	00 
     8d6:	89 04 24             	mov    %eax,(%esp)
     8d9:	e8 5a 37 00 00       	call   4038 <printf>
    exit();
     8de:	e8 d5 35 00 00       	call   3eb8 <exit>
  }

  if(unlink("dir0") < 0){
     8e3:	c7 04 24 0e 48 00 00 	movl   $0x480e,(%esp)
     8ea:	e8 19 36 00 00       	call   3f08 <unlink>
     8ef:	85 c0                	test   %eax,%eax
     8f1:	79 1a                	jns    90d <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8f3:	a1 c8 62 00 00       	mov    0x62c8,%eax
     8f8:	c7 44 24 04 3a 48 00 	movl   $0x483a,0x4(%esp)
     8ff:	00 
     900:	89 04 24             	mov    %eax,(%esp)
     903:	e8 30 37 00 00       	call   4038 <printf>
    exit();
     908:	e8 ab 35 00 00       	call   3eb8 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     90d:	a1 c8 62 00 00       	mov    0x62c8,%eax
     912:	c7 44 24 04 4e 48 00 	movl   $0x484e,0x4(%esp)
     919:	00 
     91a:	89 04 24             	mov    %eax,(%esp)
     91d:	e8 16 37 00 00       	call   4038 <printf>
}
     922:	c9                   	leave  
     923:	c3                   	ret    

00000924 <exectest>:

void
exectest(void)
{
     924:	55                   	push   %ebp
     925:	89 e5                	mov    %esp,%ebp
     927:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     92a:	a1 c8 62 00 00       	mov    0x62c8,%eax
     92f:	c7 44 24 04 5d 48 00 	movl   $0x485d,0x4(%esp)
     936:	00 
     937:	89 04 24             	mov    %eax,(%esp)
     93a:	e8 f9 36 00 00       	call   4038 <printf>
  if(exec("echo", echoargv) < 0){
     93f:	c7 44 24 04 b4 62 00 	movl   $0x62b4,0x4(%esp)
     946:	00 
     947:	c7 04 24 08 44 00 00 	movl   $0x4408,(%esp)
     94e:	e8 9d 35 00 00       	call   3ef0 <exec>
     953:	85 c0                	test   %eax,%eax
     955:	79 1a                	jns    971 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     957:	a1 c8 62 00 00       	mov    0x62c8,%eax
     95c:	c7 44 24 04 68 48 00 	movl   $0x4868,0x4(%esp)
     963:	00 
     964:	89 04 24             	mov    %eax,(%esp)
     967:	e8 cc 36 00 00       	call   4038 <printf>
    exit();
     96c:	e8 47 35 00 00       	call   3eb8 <exit>
  }
}
     971:	c9                   	leave  
     972:	c3                   	ret    

00000973 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     973:	55                   	push   %ebp
     974:	89 e5                	mov    %esp,%ebp
     976:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     979:	8d 45 d8             	lea    -0x28(%ebp),%eax
     97c:	89 04 24             	mov    %eax,(%esp)
     97f:	e8 44 35 00 00       	call   3ec8 <pipe>
     984:	85 c0                	test   %eax,%eax
     986:	74 19                	je     9a1 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     988:	c7 44 24 04 7a 48 00 	movl   $0x487a,0x4(%esp)
     98f:	00 
     990:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     997:	e8 9c 36 00 00       	call   4038 <printf>
    exit();
     99c:	e8 17 35 00 00       	call   3eb8 <exit>
  }
  pid = fork();
     9a1:	e8 0a 35 00 00       	call   3eb0 <fork>
     9a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9b4:	0f 85 88 00 00 00    	jne    a42 <pipe1+0xcf>
    close(fds[0]);
     9ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9bd:	89 04 24             	mov    %eax,(%esp)
     9c0:	e8 1b 35 00 00       	call   3ee0 <close>
    for(n = 0; n < 5; n++){
     9c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9cc:	eb 69                	jmp    a37 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
     9ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9d5:	eb 18                	jmp    9ef <pipe1+0x7c>
        buf[i] = seq++;
     9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9da:	8d 50 01             	lea    0x1(%eax),%edx
     9dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9e3:	81 c2 c0 8a 00 00    	add    $0x8ac0,%edx
     9e9:	88 02                	mov    %al,(%edx)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     9ef:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9f6:	7e df                	jle    9d7 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9fb:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     a02:	00 
     a03:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     a0a:	00 
     a0b:	89 04 24             	mov    %eax,(%esp)
     a0e:	e8 c5 34 00 00       	call   3ed8 <write>
     a13:	3d 09 04 00 00       	cmp    $0x409,%eax
     a18:	74 19                	je     a33 <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
     a1a:	c7 44 24 04 89 48 00 	movl   $0x4889,0x4(%esp)
     a21:	00 
     a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a29:	e8 0a 36 00 00       	call   4038 <printf>
        exit();
     a2e:	e8 85 34 00 00       	call   3eb8 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     a37:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a3b:	7e 91                	jle    9ce <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a3d:	e8 76 34 00 00       	call   3eb8 <exit>
  } else if(pid > 0){
     a42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a46:	0f 8e f9 00 00 00    	jle    b45 <pipe1+0x1d2>
    close(fds[1]);
     a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a4f:	89 04 24             	mov    %eax,(%esp)
     a52:	e8 89 34 00 00       	call   3ee0 <close>
    total = 0;
     a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a65:	eb 68                	jmp    acf <pipe1+0x15c>
      for(i = 0; i < n; i++){
     a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a6e:	eb 3d                	jmp    aad <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a73:	05 c0 8a 00 00       	add    $0x8ac0,%eax
     a78:	0f b6 00             	movzbl (%eax),%eax
     a7b:	0f be c8             	movsbl %al,%ecx
     a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a81:	8d 50 01             	lea    0x1(%eax),%edx
     a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a87:	31 c8                	xor    %ecx,%eax
     a89:	0f b6 c0             	movzbl %al,%eax
     a8c:	85 c0                	test   %eax,%eax
     a8e:	74 19                	je     aa9 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     a90:	c7 44 24 04 97 48 00 	movl   $0x4897,0x4(%esp)
     a97:	00 
     a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9f:	e8 94 35 00 00       	call   4038 <printf>
     aa4:	e9 b5 00 00 00       	jmp    b5e <pipe1+0x1eb>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     aa9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     ab3:	7c bb                	jl     a70 <pipe1+0xfd>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ab8:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     abb:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ac1:	3d 00 20 00 00       	cmp    $0x2000,%eax
     ac6:	76 07                	jbe    acf <pipe1+0x15c>
        cc = sizeof(buf);
     ac8:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ad5:	89 54 24 08          	mov    %edx,0x8(%esp)
     ad9:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     ae0:	00 
     ae1:	89 04 24             	mov    %eax,(%esp)
     ae4:	e8 e7 33 00 00       	call   3ed0 <read>
     ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     af0:	0f 8f 71 ff ff ff    	jg     a67 <pipe1+0xf4>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     af6:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     afd:	74 20                	je     b1f <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
     aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b02:	89 44 24 08          	mov    %eax,0x8(%esp)
     b06:	c7 44 24 04 a5 48 00 	movl   $0x48a5,0x4(%esp)
     b0d:	00 
     b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b15:	e8 1e 35 00 00       	call   4038 <printf>
      exit();
     b1a:	e8 99 33 00 00       	call   3eb8 <exit>
    }
    close(fds[0]);
     b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b22:	89 04 24             	mov    %eax,(%esp)
     b25:	e8 b6 33 00 00       	call   3ee0 <close>
    wait();
     b2a:	e8 91 33 00 00       	call   3ec0 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b2f:	c7 44 24 04 cb 48 00 	movl   $0x48cb,0x4(%esp)
     b36:	00 
     b37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b3e:	e8 f5 34 00 00       	call   4038 <printf>
     b43:	eb 19                	jmp    b5e <pipe1+0x1eb>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b45:	c7 44 24 04 bc 48 00 	movl   $0x48bc,0x4(%esp)
     b4c:	00 
     b4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b54:	e8 df 34 00 00       	call   4038 <printf>
    exit();
     b59:	e8 5a 33 00 00       	call   3eb8 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b5e:	c9                   	leave  
     b5f:	c3                   	ret    

00000b60 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b66:	c7 44 24 04 d5 48 00 	movl   $0x48d5,0x4(%esp)
     b6d:	00 
     b6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b75:	e8 be 34 00 00       	call   4038 <printf>
  pid1 = fork();
     b7a:	e8 31 33 00 00       	call   3eb0 <fork>
     b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b86:	75 02                	jne    b8a <preempt+0x2a>
    for(;;)
      ;
     b88:	eb fe                	jmp    b88 <preempt+0x28>

  pid2 = fork();
     b8a:	e8 21 33 00 00       	call   3eb0 <fork>
     b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b96:	75 02                	jne    b9a <preempt+0x3a>
    for(;;)
      ;
     b98:	eb fe                	jmp    b98 <preempt+0x38>

  pipe(pfds);
     b9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b9d:	89 04 24             	mov    %eax,(%esp)
     ba0:	e8 23 33 00 00       	call   3ec8 <pipe>
  pid3 = fork();
     ba5:	e8 06 33 00 00       	call   3eb0 <fork>
     baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bb1:	75 4c                	jne    bff <preempt+0x9f>
    close(pfds[0]);
     bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bb6:	89 04 24             	mov    %eax,(%esp)
     bb9:	e8 22 33 00 00       	call   3ee0 <close>
    if(write(pfds[1], "x", 1) != 1)
     bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bc8:	00 
     bc9:	c7 44 24 04 df 48 00 	movl   $0x48df,0x4(%esp)
     bd0:	00 
     bd1:	89 04 24             	mov    %eax,(%esp)
     bd4:	e8 ff 32 00 00       	call   3ed8 <write>
     bd9:	83 f8 01             	cmp    $0x1,%eax
     bdc:	74 14                	je     bf2 <preempt+0x92>
      printf(1, "preempt write error");
     bde:	c7 44 24 04 e1 48 00 	movl   $0x48e1,0x4(%esp)
     be5:	00 
     be6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bed:	e8 46 34 00 00       	call   4038 <printf>
    close(pfds[1]);
     bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf5:	89 04 24             	mov    %eax,(%esp)
     bf8:	e8 e3 32 00 00       	call   3ee0 <close>
    for(;;)
      ;
     bfd:	eb fe                	jmp    bfd <preempt+0x9d>
  }

  close(pfds[1]);
     bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c02:	89 04 24             	mov    %eax,(%esp)
     c05:	e8 d6 32 00 00       	call   3ee0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c0d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c14:	00 
     c15:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
     c1c:	00 
     c1d:	89 04 24             	mov    %eax,(%esp)
     c20:	e8 ab 32 00 00       	call   3ed0 <read>
     c25:	83 f8 01             	cmp    $0x1,%eax
     c28:	74 16                	je     c40 <preempt+0xe0>
    printf(1, "preempt read error");
     c2a:	c7 44 24 04 f5 48 00 	movl   $0x48f5,0x4(%esp)
     c31:	00 
     c32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c39:	e8 fa 33 00 00       	call   4038 <printf>
     c3e:	eb 77                	jmp    cb7 <preempt+0x157>
    return;
  }
  close(pfds[0]);
     c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c43:	89 04 24             	mov    %eax,(%esp)
     c46:	e8 95 32 00 00       	call   3ee0 <close>
  printf(1, "kill... ");
     c4b:	c7 44 24 04 08 49 00 	movl   $0x4908,0x4(%esp)
     c52:	00 
     c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c5a:	e8 d9 33 00 00       	call   4038 <printf>
  kill(pid1);
     c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c62:	89 04 24             	mov    %eax,(%esp)
     c65:	e8 7e 32 00 00       	call   3ee8 <kill>
  kill(pid2);
     c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6d:	89 04 24             	mov    %eax,(%esp)
     c70:	e8 73 32 00 00       	call   3ee8 <kill>
  kill(pid3);
     c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c78:	89 04 24             	mov    %eax,(%esp)
     c7b:	e8 68 32 00 00       	call   3ee8 <kill>
  printf(1, "wait... ");
     c80:	c7 44 24 04 11 49 00 	movl   $0x4911,0x4(%esp)
     c87:	00 
     c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c8f:	e8 a4 33 00 00       	call   4038 <printf>
  wait();
     c94:	e8 27 32 00 00       	call   3ec0 <wait>
  wait();
     c99:	e8 22 32 00 00       	call   3ec0 <wait>
  wait();
     c9e:	e8 1d 32 00 00       	call   3ec0 <wait>
  printf(1, "preempt ok\n");
     ca3:	c7 44 24 04 1a 49 00 	movl   $0x491a,0x4(%esp)
     caa:	00 
     cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb2:	e8 81 33 00 00       	call   4038 <printf>
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
     cbc:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cc6:	eb 53                	jmp    d1b <exitwait+0x62>
    pid = fork();
     cc8:	e8 e3 31 00 00       	call   3eb0 <fork>
     ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cd4:	79 16                	jns    cec <exitwait+0x33>
      printf(1, "fork failed\n");
     cd6:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
     cdd:	00 
     cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce5:	e8 4e 33 00 00       	call   4038 <printf>
      return;
     cea:	eb 49                	jmp    d35 <exitwait+0x7c>
    }
    if(pid){
     cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cf0:	74 20                	je     d12 <exitwait+0x59>
      if(wait() != pid){
     cf2:	e8 c9 31 00 00       	call   3ec0 <wait>
     cf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cfa:	74 1b                	je     d17 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cfc:	c7 44 24 04 26 49 00 	movl   $0x4926,0x4(%esp)
     d03:	00 
     d04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0b:	e8 28 33 00 00       	call   4038 <printf>
        return;
     d10:	eb 23                	jmp    d35 <exitwait+0x7c>
      }
    } else {
      exit();
     d12:	e8 a1 31 00 00       	call   3eb8 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d1b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d1f:	7e a7                	jle    cc8 <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d21:	c7 44 24 04 36 49 00 	movl   $0x4936,0x4(%esp)
     d28:	00 
     d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d30:	e8 03 33 00 00       	call   4038 <printf>
}
     d35:	c9                   	leave  
     d36:	c3                   	ret    

00000d37 <mem>:

void
mem(void)
{
     d37:	55                   	push   %ebp
     d38:	89 e5                	mov    %esp,%ebp
     d3a:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d3d:	c7 44 24 04 43 49 00 	movl   $0x4943,0x4(%esp)
     d44:	00 
     d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d4c:	e8 e7 32 00 00       	call   4038 <printf>
  ppid = getpid();
     d51:	e8 e2 31 00 00       	call   3f38 <getpid>
     d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d59:	e8 52 31 00 00       	call   3eb0 <fork>
     d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d65:	0f 85 aa 00 00 00    	jne    e15 <mem+0xde>
    m1 = 0;
     d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     d72:	eb 0e                	jmp    d82 <mem+0x4b>
      *(char**)m2 = m1;
     d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d7a:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d82:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d89:	e8 97 35 00 00       	call   4325 <malloc>
     d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d95:	75 dd                	jne    d74 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d97:	eb 19                	jmp    db2 <mem+0x7b>
      m2 = *(char**)m1;
     d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9c:	8b 00                	mov    (%eax),%eax
     d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da4:	89 04 24             	mov    %eax,(%esp)
     da7:	e8 40 34 00 00       	call   41ec <free>
      m1 = m2;
     dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
     daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     db6:	75 e1                	jne    d99 <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     db8:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     dbf:	e8 61 35 00 00       	call   4325 <malloc>
     dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dcb:	75 24                	jne    df1 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dcd:	c7 44 24 04 4d 49 00 	movl   $0x494d,0x4(%esp)
     dd4:	00 
     dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ddc:	e8 57 32 00 00       	call   4038 <printf>
      kill(ppid);
     de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     de4:	89 04 24             	mov    %eax,(%esp)
     de7:	e8 fc 30 00 00       	call   3ee8 <kill>
      exit();
     dec:	e8 c7 30 00 00       	call   3eb8 <exit>
    }
    free(m1);
     df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df4:	89 04 24             	mov    %eax,(%esp)
     df7:	e8 f0 33 00 00       	call   41ec <free>
    printf(1, "mem ok\n");
     dfc:	c7 44 24 04 67 49 00 	movl   $0x4967,0x4(%esp)
     e03:	00 
     e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e0b:	e8 28 32 00 00       	call   4038 <printf>
    exit();
     e10:	e8 a3 30 00 00       	call   3eb8 <exit>
  } else {
    wait();
     e15:	e8 a6 30 00 00       	call   3ec0 <wait>
  }
}
     e1a:	c9                   	leave  
     e1b:	c3                   	ret    

00000e1c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e1c:	55                   	push   %ebp
     e1d:	89 e5                	mov    %esp,%ebp
     e1f:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e22:	c7 44 24 04 6f 49 00 	movl   $0x496f,0x4(%esp)
     e29:	00 
     e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e31:	e8 02 32 00 00       	call   4038 <printf>

  unlink("sharedfd");
     e36:	c7 04 24 7e 49 00 00 	movl   $0x497e,(%esp)
     e3d:	e8 c6 30 00 00       	call   3f08 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e42:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e49:	00 
     e4a:	c7 04 24 7e 49 00 00 	movl   $0x497e,(%esp)
     e51:	e8 a2 30 00 00       	call   3ef8 <open>
     e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e5d:	79 19                	jns    e78 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e5f:	c7 44 24 04 88 49 00 	movl   $0x4988,0x4(%esp)
     e66:	00 
     e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e6e:	e8 c5 31 00 00       	call   4038 <printf>
    return;
     e73:	e9 a0 01 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  pid = fork();
     e78:	e8 33 30 00 00       	call   3eb0 <fork>
     e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e84:	75 07                	jne    e8d <sharedfd+0x71>
     e86:	b8 63 00 00 00       	mov    $0x63,%eax
     e8b:	eb 05                	jmp    e92 <sharedfd+0x76>
     e8d:	b8 70 00 00 00       	mov    $0x70,%eax
     e92:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e99:	00 
     e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ea1:	89 04 24             	mov    %eax,(%esp)
     ea4:	e8 62 2e 00 00       	call   3d0b <memset>
  for(i = 0; i < 1000; i++){
     ea9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb0:	eb 39                	jmp    eeb <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eb9:	00 
     eba:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
     ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ec4:	89 04 24             	mov    %eax,(%esp)
     ec7:	e8 0c 30 00 00       	call   3ed8 <write>
     ecc:	83 f8 0a             	cmp    $0xa,%eax
     ecf:	74 16                	je     ee7 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ed1:	c7 44 24 04 b4 49 00 	movl   $0x49b4,0x4(%esp)
     ed8:	00 
     ed9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ee0:	e8 53 31 00 00       	call   4038 <printf>
      break;
     ee5:	eb 0d                	jmp    ef4 <sharedfd+0xd8>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     eeb:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ef2:	7e be                	jle    eb2 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     ef8:	75 05                	jne    eff <sharedfd+0xe3>
    exit();
     efa:	e8 b9 2f 00 00       	call   3eb8 <exit>
  else
    wait();
     eff:	e8 bc 2f 00 00       	call   3ec0 <wait>
  close(fd);
     f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f07:	89 04 24             	mov    %eax,(%esp)
     f0a:	e8 d1 2f 00 00       	call   3ee0 <close>
  fd = open("sharedfd", 0);
     f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f16:	00 
     f17:	c7 04 24 7e 49 00 00 	movl   $0x497e,(%esp)
     f1e:	e8 d5 2f 00 00       	call   3ef8 <open>
     f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f2a:	79 19                	jns    f45 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2c:	c7 44 24 04 d4 49 00 	movl   $0x49d4,0x4(%esp)
     f33:	00 
     f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f3b:	e8 f8 30 00 00       	call   4038 <printf>
    return;
     f40:	e9 d3 00 00 00       	jmp    1018 <sharedfd+0x1fc>
  }
  nc = np = 0;
     f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f52:	eb 3b                	jmp    f8f <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
     f54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f5b:	eb 2a                	jmp    f87 <sharedfd+0x16b>
      if(buf[i] == 'c')
     f5d:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f63:	01 d0                	add    %edx,%eax
     f65:	0f b6 00             	movzbl (%eax),%eax
     f68:	3c 63                	cmp    $0x63,%al
     f6a:	75 04                	jne    f70 <sharedfd+0x154>
        nc++;
     f6c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
     f70:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f76:	01 d0                	add    %edx,%eax
     f78:	0f b6 00             	movzbl (%eax),%eax
     f7b:	3c 70                	cmp    $0x70,%al
     f7d:	75 04                	jne    f83 <sharedfd+0x167>
        np++;
     f7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f8a:	83 f8 09             	cmp    $0x9,%eax
     f8d:	76 ce                	jbe    f5d <sharedfd+0x141>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f8f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f96:	00 
     f97:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa1:	89 04 24             	mov    %eax,(%esp)
     fa4:	e8 27 2f 00 00       	call   3ed0 <read>
     fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
     fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     fb0:	7f a2                	jg     f54 <sharedfd+0x138>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb5:	89 04 24             	mov    %eax,(%esp)
     fb8:	e8 23 2f 00 00       	call   3ee0 <close>
  unlink("sharedfd");
     fbd:	c7 04 24 7e 49 00 00 	movl   $0x497e,(%esp)
     fc4:	e8 3f 2f 00 00       	call   3f08 <unlink>
  if(nc == 10000 && np == 10000){
     fc9:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fd0:	75 1f                	jne    ff1 <sharedfd+0x1d5>
     fd2:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fd9:	75 16                	jne    ff1 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
     fdb:	c7 44 24 04 ff 49 00 	movl   $0x49ff,0x4(%esp)
     fe2:	00 
     fe3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fea:	e8 49 30 00 00       	call   4038 <printf>
     fef:	eb 27                	jmp    1018 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
     fff:	c7 44 24 04 0c 4a 00 	movl   $0x4a0c,0x4(%esp)
    1006:	00 
    1007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    100e:	e8 25 30 00 00       	call   4038 <printf>
    exit();
    1013:	e8 a0 2e 00 00       	call   3eb8 <exit>
  }
}
    1018:	c9                   	leave  
    1019:	c3                   	ret    

0000101a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    101a:	55                   	push   %ebp
    101b:	89 e5                	mov    %esp,%ebp
    101d:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1020:	c7 45 c8 21 4a 00 00 	movl   $0x4a21,-0x38(%ebp)
    1027:	c7 45 cc 24 4a 00 00 	movl   $0x4a24,-0x34(%ebp)
    102e:	c7 45 d0 27 4a 00 00 	movl   $0x4a27,-0x30(%ebp)
    1035:	c7 45 d4 2a 4a 00 00 	movl   $0x4a2a,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    103c:	c7 44 24 04 2d 4a 00 	movl   $0x4a2d,0x4(%esp)
    1043:	00 
    1044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104b:	e8 e8 2f 00 00       	call   4038 <printf>

  for(pi = 0; pi < 4; pi++){
    1050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1057:	e9 fc 00 00 00       	jmp    1158 <fourfiles+0x13e>
    fname = names[pi];
    105c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    105f:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    1063:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    1066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1069:	89 04 24             	mov    %eax,(%esp)
    106c:	e8 97 2e 00 00       	call   3f08 <unlink>

    pid = fork();
    1071:	e8 3a 2e 00 00       	call   3eb0 <fork>
    1076:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    1079:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    107d:	79 19                	jns    1098 <fourfiles+0x7e>
      printf(1, "fork failed\n");
    107f:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    1086:	00 
    1087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108e:	e8 a5 2f 00 00       	call   4038 <printf>
      exit();
    1093:	e8 20 2e 00 00       	call   3eb8 <exit>
    }

    if(pid == 0){
    1098:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    109c:	0f 85 b2 00 00 00    	jne    1154 <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    10a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    10a9:	00 
    10aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ad:	89 04 24             	mov    %eax,(%esp)
    10b0:	e8 43 2e 00 00       	call   3ef8 <open>
    10b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    10b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    10bc:	79 19                	jns    10d7 <fourfiles+0xbd>
        printf(1, "create failed\n");
    10be:	c7 44 24 04 3d 4a 00 	movl   $0x4a3d,0x4(%esp)
    10c5:	00 
    10c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10cd:	e8 66 2f 00 00       	call   4038 <printf>
        exit();
    10d2:	e8 e1 2d 00 00       	call   3eb8 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10da:	83 c0 30             	add    $0x30,%eax
    10dd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10e4:	00 
    10e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e9:	c7 04 24 c0 8a 00 00 	movl   $0x8ac0,(%esp)
    10f0:	e8 16 2c 00 00       	call   3d0b <memset>
      for(i = 0; i < 12; i++){
    10f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10fc:	eb 4b                	jmp    1149 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    10fe:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1105:	00 
    1106:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    110d:	00 
    110e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1111:	89 04 24             	mov    %eax,(%esp)
    1114:	e8 bf 2d 00 00       	call   3ed8 <write>
    1119:	89 45 d8             	mov    %eax,-0x28(%ebp)
    111c:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    1123:	74 20                	je     1145 <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    1125:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1128:	89 44 24 08          	mov    %eax,0x8(%esp)
    112c:	c7 44 24 04 4c 4a 00 	movl   $0x4a4c,0x4(%esp)
    1133:	00 
    1134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113b:	e8 f8 2e 00 00       	call   4038 <printf>
          exit();
    1140:	e8 73 2d 00 00       	call   3eb8 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    1145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1149:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    114d:	7e af                	jle    10fe <fourfiles+0xe4>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    114f:	e8 64 2d 00 00       	call   3eb8 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    1154:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1158:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    115c:	0f 8e fa fe ff ff    	jle    105c <fourfiles+0x42>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1162:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    1169:	eb 09                	jmp    1174 <fourfiles+0x15a>
    wait();
    116b:	e8 50 2d 00 00       	call   3ec0 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1170:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1174:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    1178:	7e f1                	jle    116b <fourfiles+0x151>
    wait();
  }

  for(i = 0; i < 2; i++){
    117a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1181:	e9 dc 00 00 00       	jmp    1262 <fourfiles+0x248>
    fname = names[i];
    1186:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1189:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    1190:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1197:	00 
    1198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    119b:	89 04 24             	mov    %eax,(%esp)
    119e:	e8 55 2d 00 00       	call   3ef8 <open>
    11a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    11a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11ad:	eb 4c                	jmp    11fb <fourfiles+0x1e1>
      for(j = 0; j < n; j++){
    11af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11b6:	eb 35                	jmp    11ed <fourfiles+0x1d3>
        if(buf[j] != '0'+i){
    11b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11bb:	05 c0 8a 00 00       	add    $0x8ac0,%eax
    11c0:	0f b6 00             	movzbl (%eax),%eax
    11c3:	0f be c0             	movsbl %al,%eax
    11c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c9:	83 c2 30             	add    $0x30,%edx
    11cc:	39 d0                	cmp    %edx,%eax
    11ce:	74 19                	je     11e9 <fourfiles+0x1cf>
          printf(1, "wrong char\n");
    11d0:	c7 44 24 04 5d 4a 00 	movl   $0x4a5d,0x4(%esp)
    11d7:	00 
    11d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11df:	e8 54 2e 00 00       	call   4038 <printf>
          exit();
    11e4:	e8 cf 2c 00 00       	call   3eb8 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11e9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    11ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    11f3:	7c c3                	jl     11b8 <fourfiles+0x19e>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    11f8:	01 45 ec             	add    %eax,-0x14(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11fb:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1202:	00 
    1203:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    120a:	00 
    120b:	8b 45 dc             	mov    -0x24(%ebp),%eax
    120e:	89 04 24             	mov    %eax,(%esp)
    1211:	e8 ba 2c 00 00       	call   3ed0 <read>
    1216:	89 45 d8             	mov    %eax,-0x28(%ebp)
    1219:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    121d:	7f 90                	jg     11af <fourfiles+0x195>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    121f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 b6 2c 00 00       	call   3ee0 <close>
    if(total != 12*500){
    122a:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    1231:	74 20                	je     1253 <fourfiles+0x239>
      printf(1, "wrong length %d\n", total);
    1233:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1236:	89 44 24 08          	mov    %eax,0x8(%esp)
    123a:	c7 44 24 04 69 4a 00 	movl   $0x4a69,0x4(%esp)
    1241:	00 
    1242:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1249:	e8 ea 2d 00 00       	call   4038 <printf>
      exit();
    124e:	e8 65 2c 00 00       	call   3eb8 <exit>
    }
    unlink(fname);
    1253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1256:	89 04 24             	mov    %eax,(%esp)
    1259:	e8 aa 2c 00 00       	call   3f08 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    125e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1262:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    1266:	0f 8e 1a ff ff ff    	jle    1186 <fourfiles+0x16c>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    126c:	c7 44 24 04 7a 4a 00 	movl   $0x4a7a,0x4(%esp)
    1273:	00 
    1274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127b:	e8 b8 2d 00 00       	call   4038 <printf>
}
    1280:	c9                   	leave  
    1281:	c3                   	ret    

00001282 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1282:	55                   	push   %ebp
    1283:	89 e5                	mov    %esp,%ebp
    1285:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1288:	c7 44 24 04 88 4a 00 	movl   $0x4a88,0x4(%esp)
    128f:	00 
    1290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1297:	e8 9c 2d 00 00       	call   4038 <printf>

  for(pi = 0; pi < 4; pi++){
    129c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    12a3:	e9 f4 00 00 00       	jmp    139c <createdelete+0x11a>
    pid = fork();
    12a8:	e8 03 2c 00 00       	call   3eb0 <fork>
    12ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    12b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12b4:	79 19                	jns    12cf <createdelete+0x4d>
      printf(1, "fork failed\n");
    12b6:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    12bd:	00 
    12be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c5:	e8 6e 2d 00 00       	call   4038 <printf>
      exit();
    12ca:	e8 e9 2b 00 00       	call   3eb8 <exit>
    }

    if(pid == 0){
    12cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12d3:	0f 85 bf 00 00 00    	jne    1398 <createdelete+0x116>
      name[0] = 'p' + pi;
    12d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12dc:	83 c0 70             	add    $0x70,%eax
    12df:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12e2:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12ed:	e9 97 00 00 00       	jmp    1389 <createdelete+0x107>
        name[1] = '0' + i;
    12f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f5:	83 c0 30             	add    $0x30,%eax
    12f8:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12fb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1302:	00 
    1303:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1306:	89 04 24             	mov    %eax,(%esp)
    1309:	e8 ea 2b 00 00       	call   3ef8 <open>
    130e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    1311:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1315:	79 19                	jns    1330 <createdelete+0xae>
          printf(1, "create failed\n");
    1317:	c7 44 24 04 3d 4a 00 	movl   $0x4a3d,0x4(%esp)
    131e:	00 
    131f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1326:	e8 0d 2d 00 00       	call   4038 <printf>
          exit();
    132b:	e8 88 2b 00 00       	call   3eb8 <exit>
        }
        close(fd);
    1330:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1333:	89 04 24             	mov    %eax,(%esp)
    1336:	e8 a5 2b 00 00       	call   3ee0 <close>
        if(i > 0 && (i % 2 ) == 0){
    133b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133f:	7e 44                	jle    1385 <createdelete+0x103>
    1341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1344:	83 e0 01             	and    $0x1,%eax
    1347:	85 c0                	test   %eax,%eax
    1349:	75 3a                	jne    1385 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    134b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134e:	89 c2                	mov    %eax,%edx
    1350:	c1 ea 1f             	shr    $0x1f,%edx
    1353:	01 d0                	add    %edx,%eax
    1355:	d1 f8                	sar    %eax
    1357:	83 c0 30             	add    $0x30,%eax
    135a:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    135d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1360:	89 04 24             	mov    %eax,(%esp)
    1363:	e8 a0 2b 00 00       	call   3f08 <unlink>
    1368:	85 c0                	test   %eax,%eax
    136a:	79 19                	jns    1385 <createdelete+0x103>
            printf(1, "unlink failed\n");
    136c:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
    1373:	00 
    1374:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    137b:	e8 b8 2c 00 00       	call   4038 <printf>
            exit();
    1380:	e8 33 2b 00 00       	call   3eb8 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    1385:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1389:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    138d:	0f 8e 5f ff ff ff    	jle    12f2 <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    1393:	e8 20 2b 00 00       	call   3eb8 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    1398:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    139c:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13a0:	0f 8e 02 ff ff ff    	jle    12a8 <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13ad:	eb 09                	jmp    13b8 <createdelete+0x136>
    wait();
    13af:	e8 0c 2b 00 00       	call   3ec0 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    13b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    13b8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13bc:	7e f1                	jle    13af <createdelete+0x12d>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13be:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13c2:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    13c6:	88 45 c9             	mov    %al,-0x37(%ebp)
    13c9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    13cd:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13d7:	e9 bb 00 00 00       	jmp    1497 <createdelete+0x215>
    for(pi = 0; pi < 4; pi++){
    13dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e3:	e9 a1 00 00 00       	jmp    1489 <createdelete+0x207>
      name[0] = 'p' + pi;
    13e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13eb:	83 c0 70             	add    $0x70,%eax
    13ee:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f4:	83 c0 30             	add    $0x30,%eax
    13f7:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1401:	00 
    1402:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1405:	89 04 24             	mov    %eax,(%esp)
    1408:	e8 eb 2a 00 00       	call   3ef8 <open>
    140d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    1410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1414:	74 06                	je     141c <createdelete+0x19a>
    1416:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    141a:	7e 26                	jle    1442 <createdelete+0x1c0>
    141c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1420:	79 20                	jns    1442 <createdelete+0x1c0>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1422:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1425:	89 44 24 08          	mov    %eax,0x8(%esp)
    1429:	c7 44 24 04 9c 4a 00 	movl   $0x4a9c,0x4(%esp)
    1430:	00 
    1431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1438:	e8 fb 2b 00 00       	call   4038 <printf>
        exit();
    143d:	e8 76 2a 00 00       	call   3eb8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1446:	7e 2c                	jle    1474 <createdelete+0x1f2>
    1448:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    144c:	7f 26                	jg     1474 <createdelete+0x1f2>
    144e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1452:	78 20                	js     1474 <createdelete+0x1f2>
        printf(1, "oops createdelete %s did exist\n", name);
    1454:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1457:	89 44 24 08          	mov    %eax,0x8(%esp)
    145b:	c7 44 24 04 c0 4a 00 	movl   $0x4ac0,0x4(%esp)
    1462:	00 
    1463:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    146a:	e8 c9 2b 00 00       	call   4038 <printf>
        exit();
    146f:	e8 44 2a 00 00       	call   3eb8 <exit>
      }
      if(fd >= 0)
    1474:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1478:	78 0b                	js     1485 <createdelete+0x203>
        close(fd);
    147a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    147d:	89 04 24             	mov    %eax,(%esp)
    1480:	e8 5b 2a 00 00       	call   3ee0 <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    1485:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1489:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    148d:	0f 8e 55 ff ff ff    	jle    13e8 <createdelete+0x166>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    1493:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1497:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    149b:	0f 8e 3b ff ff ff    	jle    13dc <createdelete+0x15a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14a8:	eb 34                	jmp    14de <createdelete+0x25c>
    for(pi = 0; pi < 4; pi++){
    14aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14b1:	eb 21                	jmp    14d4 <createdelete+0x252>
      name[0] = 'p' + i;
    14b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b6:	83 c0 70             	add    $0x70,%eax
    14b9:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    14bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bf:	83 c0 30             	add    $0x30,%eax
    14c2:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14c8:	89 04 24             	mov    %eax,(%esp)
    14cb:	e8 38 2a 00 00       	call   3f08 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    14d4:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14d8:	7e d9                	jle    14b3 <createdelete+0x231>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    14de:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14e2:	7e c6                	jle    14aa <createdelete+0x228>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14e4:	c7 44 24 04 e0 4a 00 	movl   $0x4ae0,0x4(%esp)
    14eb:	00 
    14ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f3:	e8 40 2b 00 00       	call   4038 <printf>
}
    14f8:	c9                   	leave  
    14f9:	c3                   	ret    

000014fa <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14fa:	55                   	push   %ebp
    14fb:	89 e5                	mov    %esp,%ebp
    14fd:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1500:	c7 44 24 04 f1 4a 00 	movl   $0x4af1,0x4(%esp)
    1507:	00 
    1508:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    150f:	e8 24 2b 00 00       	call   4038 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1514:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    151b:	00 
    151c:	c7 04 24 02 4b 00 00 	movl   $0x4b02,(%esp)
    1523:	e8 d0 29 00 00       	call   3ef8 <open>
    1528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    152b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152f:	79 19                	jns    154a <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1531:	c7 44 24 04 0d 4b 00 	movl   $0x4b0d,0x4(%esp)
    1538:	00 
    1539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1540:	e8 f3 2a 00 00       	call   4038 <printf>
    exit();
    1545:	e8 6e 29 00 00       	call   3eb8 <exit>
  }
  write(fd, "hello", 5);
    154a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1551:	00 
    1552:	c7 44 24 04 27 4b 00 	movl   $0x4b27,0x4(%esp)
    1559:	00 
    155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155d:	89 04 24             	mov    %eax,(%esp)
    1560:	e8 73 29 00 00       	call   3ed8 <write>
  close(fd);
    1565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1568:	89 04 24             	mov    %eax,(%esp)
    156b:	e8 70 29 00 00       	call   3ee0 <close>

  fd = open("unlinkread", O_RDWR);
    1570:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1577:	00 
    1578:	c7 04 24 02 4b 00 00 	movl   $0x4b02,(%esp)
    157f:	e8 74 29 00 00       	call   3ef8 <open>
    1584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    158b:	79 19                	jns    15a6 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    158d:	c7 44 24 04 2d 4b 00 	movl   $0x4b2d,0x4(%esp)
    1594:	00 
    1595:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    159c:	e8 97 2a 00 00       	call   4038 <printf>
    exit();
    15a1:	e8 12 29 00 00       	call   3eb8 <exit>
  }
  if(unlink("unlinkread") != 0){
    15a6:	c7 04 24 02 4b 00 00 	movl   $0x4b02,(%esp)
    15ad:	e8 56 29 00 00       	call   3f08 <unlink>
    15b2:	85 c0                	test   %eax,%eax
    15b4:	74 19                	je     15cf <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    15b6:	c7 44 24 04 45 4b 00 	movl   $0x4b45,0x4(%esp)
    15bd:	00 
    15be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c5:	e8 6e 2a 00 00       	call   4038 <printf>
    exit();
    15ca:	e8 e9 28 00 00       	call   3eb8 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15d6:	00 
    15d7:	c7 04 24 02 4b 00 00 	movl   $0x4b02,(%esp)
    15de:	e8 15 29 00 00       	call   3ef8 <open>
    15e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15e6:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15ed:	00 
    15ee:	c7 44 24 04 5f 4b 00 	movl   $0x4b5f,0x4(%esp)
    15f5:	00 
    15f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f9:	89 04 24             	mov    %eax,(%esp)
    15fc:	e8 d7 28 00 00       	call   3ed8 <write>
  close(fd1);
    1601:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1604:	89 04 24             	mov    %eax,(%esp)
    1607:	e8 d4 28 00 00       	call   3ee0 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    160c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1613:	00 
    1614:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    161b:	00 
    161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    161f:	89 04 24             	mov    %eax,(%esp)
    1622:	e8 a9 28 00 00       	call   3ed0 <read>
    1627:	83 f8 05             	cmp    $0x5,%eax
    162a:	74 19                	je     1645 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    162c:	c7 44 24 04 63 4b 00 	movl   $0x4b63,0x4(%esp)
    1633:	00 
    1634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163b:	e8 f8 29 00 00       	call   4038 <printf>
    exit();
    1640:	e8 73 28 00 00       	call   3eb8 <exit>
  }
  if(buf[0] != 'h'){
    1645:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    164c:	3c 68                	cmp    $0x68,%al
    164e:	74 19                	je     1669 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    1650:	c7 44 24 04 7a 4b 00 	movl   $0x4b7a,0x4(%esp)
    1657:	00 
    1658:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165f:	e8 d4 29 00 00       	call   4038 <printf>
    exit();
    1664:	e8 4f 28 00 00       	call   3eb8 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1669:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1670:	00 
    1671:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    1678:	00 
    1679:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167c:	89 04 24             	mov    %eax,(%esp)
    167f:	e8 54 28 00 00       	call   3ed8 <write>
    1684:	83 f8 0a             	cmp    $0xa,%eax
    1687:	74 19                	je     16a2 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    1689:	c7 44 24 04 91 4b 00 	movl   $0x4b91,0x4(%esp)
    1690:	00 
    1691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1698:	e8 9b 29 00 00       	call   4038 <printf>
    exit();
    169d:	e8 16 28 00 00       	call   3eb8 <exit>
  }
  close(fd);
    16a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a5:	89 04 24             	mov    %eax,(%esp)
    16a8:	e8 33 28 00 00       	call   3ee0 <close>
  unlink("unlinkread");
    16ad:	c7 04 24 02 4b 00 00 	movl   $0x4b02,(%esp)
    16b4:	e8 4f 28 00 00       	call   3f08 <unlink>
  printf(1, "unlinkread ok\n");
    16b9:	c7 44 24 04 aa 4b 00 	movl   $0x4baa,0x4(%esp)
    16c0:	00 
    16c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c8:	e8 6b 29 00 00       	call   4038 <printf>
}
    16cd:	c9                   	leave  
    16ce:	c3                   	ret    

000016cf <linktest>:

void
linktest(void)
{
    16cf:	55                   	push   %ebp
    16d0:	89 e5                	mov    %esp,%ebp
    16d2:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16d5:	c7 44 24 04 b9 4b 00 	movl   $0x4bb9,0x4(%esp)
    16dc:	00 
    16dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16e4:	e8 4f 29 00 00       	call   4038 <printf>

  unlink("lf1");
    16e9:	c7 04 24 c3 4b 00 00 	movl   $0x4bc3,(%esp)
    16f0:	e8 13 28 00 00       	call   3f08 <unlink>
  unlink("lf2");
    16f5:	c7 04 24 c7 4b 00 00 	movl   $0x4bc7,(%esp)
    16fc:	e8 07 28 00 00       	call   3f08 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1701:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1708:	00 
    1709:	c7 04 24 c3 4b 00 00 	movl   $0x4bc3,(%esp)
    1710:	e8 e3 27 00 00       	call   3ef8 <open>
    1715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    171c:	79 19                	jns    1737 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    171e:	c7 44 24 04 cb 4b 00 	movl   $0x4bcb,0x4(%esp)
    1725:	00 
    1726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    172d:	e8 06 29 00 00       	call   4038 <printf>
    exit();
    1732:	e8 81 27 00 00       	call   3eb8 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1737:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    173e:	00 
    173f:	c7 44 24 04 27 4b 00 	movl   $0x4b27,0x4(%esp)
    1746:	00 
    1747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174a:	89 04 24             	mov    %eax,(%esp)
    174d:	e8 86 27 00 00       	call   3ed8 <write>
    1752:	83 f8 05             	cmp    $0x5,%eax
    1755:	74 19                	je     1770 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1757:	c7 44 24 04 de 4b 00 	movl   $0x4bde,0x4(%esp)
    175e:	00 
    175f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1766:	e8 cd 28 00 00       	call   4038 <printf>
    exit();
    176b:	e8 48 27 00 00       	call   3eb8 <exit>
  }
  close(fd);
    1770:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1773:	89 04 24             	mov    %eax,(%esp)
    1776:	e8 65 27 00 00       	call   3ee0 <close>

  if(link("lf1", "lf2") < 0){
    177b:	c7 44 24 04 c7 4b 00 	movl   $0x4bc7,0x4(%esp)
    1782:	00 
    1783:	c7 04 24 c3 4b 00 00 	movl   $0x4bc3,(%esp)
    178a:	e8 89 27 00 00       	call   3f18 <link>
    178f:	85 c0                	test   %eax,%eax
    1791:	79 19                	jns    17ac <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1793:	c7 44 24 04 f0 4b 00 	movl   $0x4bf0,0x4(%esp)
    179a:	00 
    179b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17a2:	e8 91 28 00 00       	call   4038 <printf>
    exit();
    17a7:	e8 0c 27 00 00       	call   3eb8 <exit>
  }
  unlink("lf1");
    17ac:	c7 04 24 c3 4b 00 00 	movl   $0x4bc3,(%esp)
    17b3:	e8 50 27 00 00       	call   3f08 <unlink>

  if(open("lf1", 0) >= 0){
    17b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17bf:	00 
    17c0:	c7 04 24 c3 4b 00 00 	movl   $0x4bc3,(%esp)
    17c7:	e8 2c 27 00 00       	call   3ef8 <open>
    17cc:	85 c0                	test   %eax,%eax
    17ce:	78 19                	js     17e9 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17d0:	c7 44 24 04 08 4c 00 	movl   $0x4c08,0x4(%esp)
    17d7:	00 
    17d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17df:	e8 54 28 00 00       	call   4038 <printf>
    exit();
    17e4:	e8 cf 26 00 00       	call   3eb8 <exit>
  }

  fd = open("lf2", 0);
    17e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17f0:	00 
    17f1:	c7 04 24 c7 4b 00 00 	movl   $0x4bc7,(%esp)
    17f8:	e8 fb 26 00 00       	call   3ef8 <open>
    17fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1804:	79 19                	jns    181f <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1806:	c7 44 24 04 2d 4c 00 	movl   $0x4c2d,0x4(%esp)
    180d:	00 
    180e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1815:	e8 1e 28 00 00       	call   4038 <printf>
    exit();
    181a:	e8 99 26 00 00       	call   3eb8 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    181f:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1826:	00 
    1827:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    182e:	00 
    182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1832:	89 04 24             	mov    %eax,(%esp)
    1835:	e8 96 26 00 00       	call   3ed0 <read>
    183a:	83 f8 05             	cmp    $0x5,%eax
    183d:	74 19                	je     1858 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    183f:	c7 44 24 04 3e 4c 00 	movl   $0x4c3e,0x4(%esp)
    1846:	00 
    1847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    184e:	e8 e5 27 00 00       	call   4038 <printf>
    exit();
    1853:	e8 60 26 00 00       	call   3eb8 <exit>
  }
  close(fd);
    1858:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185b:	89 04 24             	mov    %eax,(%esp)
    185e:	e8 7d 26 00 00       	call   3ee0 <close>

  if(link("lf2", "lf2") >= 0){
    1863:	c7 44 24 04 c7 4b 00 	movl   $0x4bc7,0x4(%esp)
    186a:	00 
    186b:	c7 04 24 c7 4b 00 00 	movl   $0x4bc7,(%esp)
    1872:	e8 a1 26 00 00       	call   3f18 <link>
    1877:	85 c0                	test   %eax,%eax
    1879:	78 19                	js     1894 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    187b:	c7 44 24 04 4f 4c 00 	movl   $0x4c4f,0x4(%esp)
    1882:	00 
    1883:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    188a:	e8 a9 27 00 00       	call   4038 <printf>
    exit();
    188f:	e8 24 26 00 00       	call   3eb8 <exit>
  }

  unlink("lf2");
    1894:	c7 04 24 c7 4b 00 00 	movl   $0x4bc7,(%esp)
    189b:	e8 68 26 00 00       	call   3f08 <unlink>
  if(link("lf2", "lf1") >= 0){
    18a0:	c7 44 24 04 c3 4b 00 	movl   $0x4bc3,0x4(%esp)
    18a7:	00 
    18a8:	c7 04 24 c7 4b 00 00 	movl   $0x4bc7,(%esp)
    18af:	e8 64 26 00 00       	call   3f18 <link>
    18b4:	85 c0                	test   %eax,%eax
    18b6:	78 19                	js     18d1 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    18b8:	c7 44 24 04 70 4c 00 	movl   $0x4c70,0x4(%esp)
    18bf:	00 
    18c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c7:	e8 6c 27 00 00       	call   4038 <printf>
    exit();
    18cc:	e8 e7 25 00 00       	call   3eb8 <exit>
  }

  if(link(".", "lf1") >= 0){
    18d1:	c7 44 24 04 c3 4b 00 	movl   $0x4bc3,0x4(%esp)
    18d8:	00 
    18d9:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    18e0:	e8 33 26 00 00       	call   3f18 <link>
    18e5:	85 c0                	test   %eax,%eax
    18e7:	78 19                	js     1902 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18e9:	c7 44 24 04 95 4c 00 	movl   $0x4c95,0x4(%esp)
    18f0:	00 
    18f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18f8:	e8 3b 27 00 00       	call   4038 <printf>
    exit();
    18fd:	e8 b6 25 00 00       	call   3eb8 <exit>
  }

  printf(1, "linktest ok\n");
    1902:	c7 44 24 04 b1 4c 00 	movl   $0x4cb1,0x4(%esp)
    1909:	00 
    190a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1911:	e8 22 27 00 00       	call   4038 <printf>
}
    1916:	c9                   	leave  
    1917:	c3                   	ret    

00001918 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1918:	55                   	push   %ebp
    1919:	89 e5                	mov    %esp,%ebp
    191b:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    191e:	c7 44 24 04 be 4c 00 	movl   $0x4cbe,0x4(%esp)
    1925:	00 
    1926:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    192d:	e8 06 27 00 00       	call   4038 <printf>
  file[0] = 'C';
    1932:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1936:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    193a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1941:	e9 f7 00 00 00       	jmp    1a3d <concreate+0x125>
    file[1] = '0' + i;
    1946:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1949:	83 c0 30             	add    $0x30,%eax
    194c:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    194f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1952:	89 04 24             	mov    %eax,(%esp)
    1955:	e8 ae 25 00 00       	call   3f08 <unlink>
    pid = fork();
    195a:	e8 51 25 00 00       	call   3eb0 <fork>
    195f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1966:	74 3a                	je     19a2 <concreate+0x8a>
    1968:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    196b:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1970:	89 c8                	mov    %ecx,%eax
    1972:	f7 ea                	imul   %edx
    1974:	89 c8                	mov    %ecx,%eax
    1976:	c1 f8 1f             	sar    $0x1f,%eax
    1979:	29 c2                	sub    %eax,%edx
    197b:	89 d0                	mov    %edx,%eax
    197d:	01 c0                	add    %eax,%eax
    197f:	01 d0                	add    %edx,%eax
    1981:	29 c1                	sub    %eax,%ecx
    1983:	89 ca                	mov    %ecx,%edx
    1985:	83 fa 01             	cmp    $0x1,%edx
    1988:	75 18                	jne    19a2 <concreate+0x8a>
      link("C0", file);
    198a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    198d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1991:	c7 04 24 ce 4c 00 00 	movl   $0x4cce,(%esp)
    1998:	e8 7b 25 00 00       	call   3f18 <link>
    199d:	e9 87 00 00 00       	jmp    1a29 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    19a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a6:	75 3a                	jne    19e2 <concreate+0xca>
    19a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    19ab:	ba 67 66 66 66       	mov    $0x66666667,%edx
    19b0:	89 c8                	mov    %ecx,%eax
    19b2:	f7 ea                	imul   %edx
    19b4:	d1 fa                	sar    %edx
    19b6:	89 c8                	mov    %ecx,%eax
    19b8:	c1 f8 1f             	sar    $0x1f,%eax
    19bb:	29 c2                	sub    %eax,%edx
    19bd:	89 d0                	mov    %edx,%eax
    19bf:	c1 e0 02             	shl    $0x2,%eax
    19c2:	01 d0                	add    %edx,%eax
    19c4:	29 c1                	sub    %eax,%ecx
    19c6:	89 ca                	mov    %ecx,%edx
    19c8:	83 fa 01             	cmp    $0x1,%edx
    19cb:	75 15                	jne    19e2 <concreate+0xca>
      link("C0", file);
    19cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    19d4:	c7 04 24 ce 4c 00 00 	movl   $0x4cce,(%esp)
    19db:	e8 38 25 00 00       	call   3f18 <link>
    19e0:	eb 47                	jmp    1a29 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    19e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19e9:	00 
    19ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19ed:	89 04 24             	mov    %eax,(%esp)
    19f0:	e8 03 25 00 00       	call   3ef8 <open>
    19f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19fc:	79 20                	jns    1a1e <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    19fe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1a01:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a05:	c7 44 24 04 d1 4c 00 	movl   $0x4cd1,0x4(%esp)
    1a0c:	00 
    1a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a14:	e8 1f 26 00 00       	call   4038 <printf>
        exit();
    1a19:	e8 9a 24 00 00       	call   3eb8 <exit>
      }
      close(fd);
    1a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a21:	89 04 24             	mov    %eax,(%esp)
    1a24:	e8 b7 24 00 00       	call   3ee0 <close>
    }
    if(pid == 0)
    1a29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a2d:	75 05                	jne    1a34 <concreate+0x11c>
      exit();
    1a2f:	e8 84 24 00 00       	call   3eb8 <exit>
    else
      wait();
    1a34:	e8 87 24 00 00       	call   3ec0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1a39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a3d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1a41:	0f 8e ff fe ff ff    	jle    1946 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1a47:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a4e:	00 
    1a4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a56:	00 
    1a57:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a5a:	89 04 24             	mov    %eax,(%esp)
    1a5d:	e8 a9 22 00 00       	call   3d0b <memset>
  fd = open(".", 0);
    1a62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a69:	00 
    1a6a:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    1a71:	e8 82 24 00 00       	call   3ef8 <open>
    1a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a80:	e9 a1 00 00 00       	jmp    1b26 <concreate+0x20e>
    if(de.inum == 0)
    1a85:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    1a89:	66 85 c0             	test   %ax,%ax
    1a8c:	75 05                	jne    1a93 <concreate+0x17b>
      continue;
    1a8e:	e9 93 00 00 00       	jmp    1b26 <concreate+0x20e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a93:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    1a97:	3c 43                	cmp    $0x43,%al
    1a99:	0f 85 87 00 00 00    	jne    1b26 <concreate+0x20e>
    1a9f:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    1aa3:	84 c0                	test   %al,%al
    1aa5:	75 7f                	jne    1b26 <concreate+0x20e>
      i = de.name[1] - '0';
    1aa7:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    1aab:	0f be c0             	movsbl %al,%eax
    1aae:	83 e8 30             	sub    $0x30,%eax
    1ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ab8:	78 08                	js     1ac2 <concreate+0x1aa>
    1aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abd:	83 f8 27             	cmp    $0x27,%eax
    1ac0:	76 23                	jbe    1ae5 <concreate+0x1cd>
        printf(1, "concreate weird file %s\n", de.name);
    1ac2:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ac5:	83 c0 02             	add    $0x2,%eax
    1ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
    1acc:	c7 44 24 04 ed 4c 00 	movl   $0x4ced,0x4(%esp)
    1ad3:	00 
    1ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1adb:	e8 58 25 00 00       	call   4038 <printf>
        exit();
    1ae0:	e8 d3 23 00 00       	call   3eb8 <exit>
      }
      if(fa[i]){
    1ae5:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aeb:	01 d0                	add    %edx,%eax
    1aed:	0f b6 00             	movzbl (%eax),%eax
    1af0:	84 c0                	test   %al,%al
    1af2:	74 23                	je     1b17 <concreate+0x1ff>
        printf(1, "concreate duplicate file %s\n", de.name);
    1af4:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1af7:	83 c0 02             	add    $0x2,%eax
    1afa:	89 44 24 08          	mov    %eax,0x8(%esp)
    1afe:	c7 44 24 04 06 4d 00 	movl   $0x4d06,0x4(%esp)
    1b05:	00 
    1b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b0d:	e8 26 25 00 00       	call   4038 <printf>
        exit();
    1b12:	e8 a1 23 00 00       	call   3eb8 <exit>
      }
      fa[i] = 1;
    1b17:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1d:	01 d0                	add    %edx,%eax
    1b1f:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1b22:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1b26:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1b2d:	00 
    1b2e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1b31:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b38:	89 04 24             	mov    %eax,(%esp)
    1b3b:	e8 90 23 00 00       	call   3ed0 <read>
    1b40:	85 c0                	test   %eax,%eax
    1b42:	0f 8f 3d ff ff ff    	jg     1a85 <concreate+0x16d>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1b4b:	89 04 24             	mov    %eax,(%esp)
    1b4e:	e8 8d 23 00 00       	call   3ee0 <close>

  if(n != 40){
    1b53:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b57:	74 19                	je     1b72 <concreate+0x25a>
    printf(1, "concreate not enough files in directory listing\n");
    1b59:	c7 44 24 04 24 4d 00 	movl   $0x4d24,0x4(%esp)
    1b60:	00 
    1b61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b68:	e8 cb 24 00 00       	call   4038 <printf>
    exit();
    1b6d:	e8 46 23 00 00       	call   3eb8 <exit>
  }

  for(i = 0; i < 40; i++){
    1b72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b79:	e9 2d 01 00 00       	jmp    1cab <concreate+0x393>
    file[1] = '0' + i;
    1b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b81:	83 c0 30             	add    $0x30,%eax
    1b84:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b87:	e8 24 23 00 00       	call   3eb0 <fork>
    1b8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b93:	79 19                	jns    1bae <concreate+0x296>
      printf(1, "fork failed\n");
    1b95:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    1b9c:	00 
    1b9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ba4:	e8 8f 24 00 00       	call   4038 <printf>
      exit();
    1ba9:	e8 0a 23 00 00       	call   3eb8 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bb1:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bb6:	89 c8                	mov    %ecx,%eax
    1bb8:	f7 ea                	imul   %edx
    1bba:	89 c8                	mov    %ecx,%eax
    1bbc:	c1 f8 1f             	sar    $0x1f,%eax
    1bbf:	29 c2                	sub    %eax,%edx
    1bc1:	89 d0                	mov    %edx,%eax
    1bc3:	01 c0                	add    %eax,%eax
    1bc5:	01 d0                	add    %edx,%eax
    1bc7:	29 c1                	sub    %eax,%ecx
    1bc9:	89 ca                	mov    %ecx,%edx
    1bcb:	85 d2                	test   %edx,%edx
    1bcd:	75 06                	jne    1bd5 <concreate+0x2bd>
    1bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bd3:	74 28                	je     1bfd <concreate+0x2e5>
       ((i % 3) == 1 && pid != 0)){
    1bd5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1bd8:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1bdd:	89 c8                	mov    %ecx,%eax
    1bdf:	f7 ea                	imul   %edx
    1be1:	89 c8                	mov    %ecx,%eax
    1be3:	c1 f8 1f             	sar    $0x1f,%eax
    1be6:	29 c2                	sub    %eax,%edx
    1be8:	89 d0                	mov    %edx,%eax
    1bea:	01 c0                	add    %eax,%eax
    1bec:	01 d0                	add    %edx,%eax
    1bee:	29 c1                	sub    %eax,%ecx
    1bf0:	89 ca                	mov    %ecx,%edx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1bf2:	83 fa 01             	cmp    $0x1,%edx
    1bf5:	75 74                	jne    1c6b <concreate+0x353>
       ((i % 3) == 1 && pid != 0)){
    1bf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bfb:	74 6e                	je     1c6b <concreate+0x353>
      close(open(file, 0));
    1bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c04:	00 
    1c05:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c08:	89 04 24             	mov    %eax,(%esp)
    1c0b:	e8 e8 22 00 00       	call   3ef8 <open>
    1c10:	89 04 24             	mov    %eax,(%esp)
    1c13:	e8 c8 22 00 00       	call   3ee0 <close>
      close(open(file, 0));
    1c18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c1f:	00 
    1c20:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c23:	89 04 24             	mov    %eax,(%esp)
    1c26:	e8 cd 22 00 00       	call   3ef8 <open>
    1c2b:	89 04 24             	mov    %eax,(%esp)
    1c2e:	e8 ad 22 00 00       	call   3ee0 <close>
      close(open(file, 0));
    1c33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c3a:	00 
    1c3b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c3e:	89 04 24             	mov    %eax,(%esp)
    1c41:	e8 b2 22 00 00       	call   3ef8 <open>
    1c46:	89 04 24             	mov    %eax,(%esp)
    1c49:	e8 92 22 00 00       	call   3ee0 <close>
      close(open(file, 0));
    1c4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1c55:	00 
    1c56:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c59:	89 04 24             	mov    %eax,(%esp)
    1c5c:	e8 97 22 00 00       	call   3ef8 <open>
    1c61:	89 04 24             	mov    %eax,(%esp)
    1c64:	e8 77 22 00 00       	call   3ee0 <close>
    1c69:	eb 2c                	jmp    1c97 <concreate+0x37f>
    } else {
      unlink(file);
    1c6b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c6e:	89 04 24             	mov    %eax,(%esp)
    1c71:	e8 92 22 00 00       	call   3f08 <unlink>
      unlink(file);
    1c76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c79:	89 04 24             	mov    %eax,(%esp)
    1c7c:	e8 87 22 00 00       	call   3f08 <unlink>
      unlink(file);
    1c81:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c84:	89 04 24             	mov    %eax,(%esp)
    1c87:	e8 7c 22 00 00       	call   3f08 <unlink>
      unlink(file);
    1c8c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c8f:	89 04 24             	mov    %eax,(%esp)
    1c92:	e8 71 22 00 00       	call   3f08 <unlink>
    }
    if(pid == 0)
    1c97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c9b:	75 05                	jne    1ca2 <concreate+0x38a>
      exit();
    1c9d:	e8 16 22 00 00       	call   3eb8 <exit>
    else
      wait();
    1ca2:	e8 19 22 00 00       	call   3ec0 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1ca7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1cab:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1caf:	0f 8e c9 fe ff ff    	jle    1b7e <concreate+0x266>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1cb5:	c7 44 24 04 55 4d 00 	movl   $0x4d55,0x4(%esp)
    1cbc:	00 
    1cbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cc4:	e8 6f 23 00 00       	call   4038 <printf>
}
    1cc9:	c9                   	leave  
    1cca:	c3                   	ret    

00001ccb <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1ccb:	55                   	push   %ebp
    1ccc:	89 e5                	mov    %esp,%ebp
    1cce:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1cd1:	c7 44 24 04 63 4d 00 	movl   $0x4d63,0x4(%esp)
    1cd8:	00 
    1cd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ce0:	e8 53 23 00 00       	call   4038 <printf>

  unlink("x");
    1ce5:	c7 04 24 df 48 00 00 	movl   $0x48df,(%esp)
    1cec:	e8 17 22 00 00       	call   3f08 <unlink>
  pid = fork();
    1cf1:	e8 ba 21 00 00       	call   3eb0 <fork>
    1cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cfd:	79 19                	jns    1d18 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1cff:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    1d06:	00 
    1d07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d0e:	e8 25 23 00 00       	call   4038 <printf>
    exit();
    1d13:	e8 a0 21 00 00       	call   3eb8 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1d18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d1c:	74 07                	je     1d25 <linkunlink+0x5a>
    1d1e:	b8 01 00 00 00       	mov    $0x1,%eax
    1d23:	eb 05                	jmp    1d2a <linkunlink+0x5f>
    1d25:	b8 61 00 00 00       	mov    $0x61,%eax
    1d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1d34:	e9 8e 00 00 00       	jmp    1dc7 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    1d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d3c:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    1d42:	05 39 30 00 00       	add    $0x3039,%eax
    1d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d4a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d4d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d52:	89 c8                	mov    %ecx,%eax
    1d54:	f7 e2                	mul    %edx
    1d56:	d1 ea                	shr    %edx
    1d58:	89 d0                	mov    %edx,%eax
    1d5a:	01 c0                	add    %eax,%eax
    1d5c:	01 d0                	add    %edx,%eax
    1d5e:	29 c1                	sub    %eax,%ecx
    1d60:	89 ca                	mov    %ecx,%edx
    1d62:	85 d2                	test   %edx,%edx
    1d64:	75 1e                	jne    1d84 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    1d66:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d6d:	00 
    1d6e:	c7 04 24 df 48 00 00 	movl   $0x48df,(%esp)
    1d75:	e8 7e 21 00 00       	call   3ef8 <open>
    1d7a:	89 04 24             	mov    %eax,(%esp)
    1d7d:	e8 5e 21 00 00       	call   3ee0 <close>
    1d82:	eb 3f                	jmp    1dc3 <linkunlink+0xf8>
    } else if((x % 3) == 1){
    1d84:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1d87:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1d8c:	89 c8                	mov    %ecx,%eax
    1d8e:	f7 e2                	mul    %edx
    1d90:	d1 ea                	shr    %edx
    1d92:	89 d0                	mov    %edx,%eax
    1d94:	01 c0                	add    %eax,%eax
    1d96:	01 d0                	add    %edx,%eax
    1d98:	29 c1                	sub    %eax,%ecx
    1d9a:	89 ca                	mov    %ecx,%edx
    1d9c:	83 fa 01             	cmp    $0x1,%edx
    1d9f:	75 16                	jne    1db7 <linkunlink+0xec>
      link("cat", "x");
    1da1:	c7 44 24 04 df 48 00 	movl   $0x48df,0x4(%esp)
    1da8:	00 
    1da9:	c7 04 24 74 4d 00 00 	movl   $0x4d74,(%esp)
    1db0:	e8 63 21 00 00       	call   3f18 <link>
    1db5:	eb 0c                	jmp    1dc3 <linkunlink+0xf8>
    } else {
      unlink("x");
    1db7:	c7 04 24 df 48 00 00 	movl   $0x48df,(%esp)
    1dbe:	e8 45 21 00 00       	call   3f08 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1dc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1dc7:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1dcb:	0f 8e 68 ff ff ff    	jle    1d39 <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1dd5:	74 07                	je     1dde <linkunlink+0x113>
    wait();
    1dd7:	e8 e4 20 00 00       	call   3ec0 <wait>
    1ddc:	eb 05                	jmp    1de3 <linkunlink+0x118>
  else 
    exit();
    1dde:	e8 d5 20 00 00       	call   3eb8 <exit>

  printf(1, "linkunlink ok\n");
    1de3:	c7 44 24 04 78 4d 00 	movl   $0x4d78,0x4(%esp)
    1dea:	00 
    1deb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1df2:	e8 41 22 00 00       	call   4038 <printf>
}
    1df7:	c9                   	leave  
    1df8:	c3                   	ret    

00001df9 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1df9:	55                   	push   %ebp
    1dfa:	89 e5                	mov    %esp,%ebp
    1dfc:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1dff:	c7 44 24 04 87 4d 00 	movl   $0x4d87,0x4(%esp)
    1e06:	00 
    1e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e0e:	e8 25 22 00 00       	call   4038 <printf>
  unlink("bd");
    1e13:	c7 04 24 94 4d 00 00 	movl   $0x4d94,(%esp)
    1e1a:	e8 e9 20 00 00       	call   3f08 <unlink>

  fd = open("bd", O_CREATE);
    1e1f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1e26:	00 
    1e27:	c7 04 24 94 4d 00 00 	movl   $0x4d94,(%esp)
    1e2e:	e8 c5 20 00 00       	call   3ef8 <open>
    1e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1e36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e3a:	79 19                	jns    1e55 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1e3c:	c7 44 24 04 97 4d 00 	movl   $0x4d97,0x4(%esp)
    1e43:	00 
    1e44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e4b:	e8 e8 21 00 00       	call   4038 <printf>
    exit();
    1e50:	e8 63 20 00 00       	call   3eb8 <exit>
  }
  close(fd);
    1e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e58:	89 04 24             	mov    %eax,(%esp)
    1e5b:	e8 80 20 00 00       	call   3ee0 <close>

  for(i = 0; i < 500; i++){
    1e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e67:	eb 64                	jmp    1ecd <bigdir+0xd4>
    name[0] = 'x';
    1e69:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e70:	8d 50 3f             	lea    0x3f(%eax),%edx
    1e73:	85 c0                	test   %eax,%eax
    1e75:	0f 48 c2             	cmovs  %edx,%eax
    1e78:	c1 f8 06             	sar    $0x6,%eax
    1e7b:	83 c0 30             	add    $0x30,%eax
    1e7e:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e84:	99                   	cltd   
    1e85:	c1 ea 1a             	shr    $0x1a,%edx
    1e88:	01 d0                	add    %edx,%eax
    1e8a:	83 e0 3f             	and    $0x3f,%eax
    1e8d:	29 d0                	sub    %edx,%eax
    1e8f:	83 c0 30             	add    $0x30,%eax
    1e92:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e99:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ea0:	c7 04 24 94 4d 00 00 	movl   $0x4d94,(%esp)
    1ea7:	e8 6c 20 00 00       	call   3f18 <link>
    1eac:	85 c0                	test   %eax,%eax
    1eae:	74 19                	je     1ec9 <bigdir+0xd0>
      printf(1, "bigdir link failed\n");
    1eb0:	c7 44 24 04 ad 4d 00 	movl   $0x4dad,0x4(%esp)
    1eb7:	00 
    1eb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ebf:	e8 74 21 00 00       	call   4038 <printf>
      exit();
    1ec4:	e8 ef 1f 00 00       	call   3eb8 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1ec9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1ecd:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ed4:	7e 93                	jle    1e69 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1ed6:	c7 04 24 94 4d 00 00 	movl   $0x4d94,(%esp)
    1edd:	e8 26 20 00 00       	call   3f08 <unlink>
  for(i = 0; i < 500; i++){
    1ee2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1ee9:	eb 5c                	jmp    1f47 <bigdir+0x14e>
    name[0] = 'x';
    1eeb:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ef2:	8d 50 3f             	lea    0x3f(%eax),%edx
    1ef5:	85 c0                	test   %eax,%eax
    1ef7:	0f 48 c2             	cmovs  %edx,%eax
    1efa:	c1 f8 06             	sar    $0x6,%eax
    1efd:	83 c0 30             	add    $0x30,%eax
    1f00:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f06:	99                   	cltd   
    1f07:	c1 ea 1a             	shr    $0x1a,%edx
    1f0a:	01 d0                	add    %edx,%eax
    1f0c:	83 e0 3f             	and    $0x3f,%eax
    1f0f:	29 d0                	sub    %edx,%eax
    1f11:	83 c0 30             	add    $0x30,%eax
    1f14:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1f17:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1f1b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1f1e:	89 04 24             	mov    %eax,(%esp)
    1f21:	e8 e2 1f 00 00       	call   3f08 <unlink>
    1f26:	85 c0                	test   %eax,%eax
    1f28:	74 19                	je     1f43 <bigdir+0x14a>
      printf(1, "bigdir unlink failed");
    1f2a:	c7 44 24 04 c1 4d 00 	movl   $0x4dc1,0x4(%esp)
    1f31:	00 
    1f32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f39:	e8 fa 20 00 00       	call   4038 <printf>
      exit();
    1f3e:	e8 75 1f 00 00       	call   3eb8 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1f43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f47:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1f4e:	7e 9b                	jle    1eeb <bigdir+0xf2>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1f50:	c7 44 24 04 d6 4d 00 	movl   $0x4dd6,0x4(%esp)
    1f57:	00 
    1f58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f5f:	e8 d4 20 00 00       	call   4038 <printf>
}
    1f64:	c9                   	leave  
    1f65:	c3                   	ret    

00001f66 <subdir>:

void
subdir(void)
{
    1f66:	55                   	push   %ebp
    1f67:	89 e5                	mov    %esp,%ebp
    1f69:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f6c:	c7 44 24 04 e1 4d 00 	movl   $0x4de1,0x4(%esp)
    1f73:	00 
    1f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f7b:	e8 b8 20 00 00       	call   4038 <printf>

  unlink("ff");
    1f80:	c7 04 24 ee 4d 00 00 	movl   $0x4dee,(%esp)
    1f87:	e8 7c 1f 00 00       	call   3f08 <unlink>
  if(mkdir("dd") != 0){
    1f8c:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    1f93:	e8 88 1f 00 00       	call   3f20 <mkdir>
    1f98:	85 c0                	test   %eax,%eax
    1f9a:	74 19                	je     1fb5 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1f9c:	c7 44 24 04 f4 4d 00 	movl   $0x4df4,0x4(%esp)
    1fa3:	00 
    1fa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fab:	e8 88 20 00 00       	call   4038 <printf>
    exit();
    1fb0:	e8 03 1f 00 00       	call   3eb8 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1fb5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1fbc:	00 
    1fbd:	c7 04 24 0c 4e 00 00 	movl   $0x4e0c,(%esp)
    1fc4:	e8 2f 1f 00 00       	call   3ef8 <open>
    1fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fd0:	79 19                	jns    1feb <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1fd2:	c7 44 24 04 12 4e 00 	movl   $0x4e12,0x4(%esp)
    1fd9:	00 
    1fda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fe1:	e8 52 20 00 00       	call   4038 <printf>
    exit();
    1fe6:	e8 cd 1e 00 00       	call   3eb8 <exit>
  }
  write(fd, "ff", 2);
    1feb:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1ff2:	00 
    1ff3:	c7 44 24 04 ee 4d 00 	movl   $0x4dee,0x4(%esp)
    1ffa:	00 
    1ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ffe:	89 04 24             	mov    %eax,(%esp)
    2001:	e8 d2 1e 00 00       	call   3ed8 <write>
  close(fd);
    2006:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2009:	89 04 24             	mov    %eax,(%esp)
    200c:	e8 cf 1e 00 00       	call   3ee0 <close>
  
  if(unlink("dd") >= 0){
    2011:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    2018:	e8 eb 1e 00 00       	call   3f08 <unlink>
    201d:	85 c0                	test   %eax,%eax
    201f:	78 19                	js     203a <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2021:	c7 44 24 04 28 4e 00 	movl   $0x4e28,0x4(%esp)
    2028:	00 
    2029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2030:	e8 03 20 00 00       	call   4038 <printf>
    exit();
    2035:	e8 7e 1e 00 00       	call   3eb8 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    203a:	c7 04 24 4e 4e 00 00 	movl   $0x4e4e,(%esp)
    2041:	e8 da 1e 00 00       	call   3f20 <mkdir>
    2046:	85 c0                	test   %eax,%eax
    2048:	74 19                	je     2063 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    204a:	c7 44 24 04 55 4e 00 	movl   $0x4e55,0x4(%esp)
    2051:	00 
    2052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2059:	e8 da 1f 00 00       	call   4038 <printf>
    exit();
    205e:	e8 55 1e 00 00       	call   3eb8 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2063:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    206a:	00 
    206b:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    2072:	e8 81 1e 00 00       	call   3ef8 <open>
    2077:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    207a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    207e:	79 19                	jns    2099 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    2080:	c7 44 24 04 79 4e 00 	movl   $0x4e79,0x4(%esp)
    2087:	00 
    2088:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    208f:	e8 a4 1f 00 00       	call   4038 <printf>
    exit();
    2094:	e8 1f 1e 00 00       	call   3eb8 <exit>
  }
  write(fd, "FF", 2);
    2099:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    20a0:	00 
    20a1:	c7 44 24 04 91 4e 00 	movl   $0x4e91,0x4(%esp)
    20a8:	00 
    20a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20ac:	89 04 24             	mov    %eax,(%esp)
    20af:	e8 24 1e 00 00       	call   3ed8 <write>
  close(fd);
    20b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20b7:	89 04 24             	mov    %eax,(%esp)
    20ba:	e8 21 1e 00 00       	call   3ee0 <close>

  fd = open("dd/dd/../ff", 0);
    20bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20c6:	00 
    20c7:	c7 04 24 94 4e 00 00 	movl   $0x4e94,(%esp)
    20ce:	e8 25 1e 00 00       	call   3ef8 <open>
    20d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    20d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20da:	79 19                	jns    20f5 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    20dc:	c7 44 24 04 a0 4e 00 	movl   $0x4ea0,0x4(%esp)
    20e3:	00 
    20e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20eb:	e8 48 1f 00 00       	call   4038 <printf>
    exit();
    20f0:	e8 c3 1d 00 00       	call   3eb8 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20f5:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    20fc:	00 
    20fd:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    2104:	00 
    2105:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2108:	89 04 24             	mov    %eax,(%esp)
    210b:	e8 c0 1d 00 00       	call   3ed0 <read>
    2110:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    2113:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    2117:	75 0b                	jne    2124 <subdir+0x1be>
    2119:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    2120:	3c 66                	cmp    $0x66,%al
    2122:	74 19                	je     213d <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    2124:	c7 44 24 04 b9 4e 00 	movl   $0x4eb9,0x4(%esp)
    212b:	00 
    212c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2133:	e8 00 1f 00 00       	call   4038 <printf>
    exit();
    2138:	e8 7b 1d 00 00       	call   3eb8 <exit>
  }
  close(fd);
    213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2140:	89 04 24             	mov    %eax,(%esp)
    2143:	e8 98 1d 00 00       	call   3ee0 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2148:	c7 44 24 04 d4 4e 00 	movl   $0x4ed4,0x4(%esp)
    214f:	00 
    2150:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    2157:	e8 bc 1d 00 00       	call   3f18 <link>
    215c:	85 c0                	test   %eax,%eax
    215e:	74 19                	je     2179 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2160:	c7 44 24 04 e0 4e 00 	movl   $0x4ee0,0x4(%esp)
    2167:	00 
    2168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    216f:	e8 c4 1e 00 00       	call   4038 <printf>
    exit();
    2174:	e8 3f 1d 00 00       	call   3eb8 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2179:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    2180:	e8 83 1d 00 00       	call   3f08 <unlink>
    2185:	85 c0                	test   %eax,%eax
    2187:	74 19                	je     21a2 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    2189:	c7 44 24 04 01 4f 00 	movl   $0x4f01,0x4(%esp)
    2190:	00 
    2191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2198:	e8 9b 1e 00 00       	call   4038 <printf>
    exit();
    219d:	e8 16 1d 00 00       	call   3eb8 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    21a9:	00 
    21aa:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    21b1:	e8 42 1d 00 00       	call   3ef8 <open>
    21b6:	85 c0                	test   %eax,%eax
    21b8:	78 19                	js     21d3 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    21ba:	c7 44 24 04 1c 4f 00 	movl   $0x4f1c,0x4(%esp)
    21c1:	00 
    21c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c9:	e8 6a 1e 00 00       	call   4038 <printf>
    exit();
    21ce:	e8 e5 1c 00 00       	call   3eb8 <exit>
  }

  if(chdir("dd") != 0){
    21d3:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    21da:	e8 49 1d 00 00       	call   3f28 <chdir>
    21df:	85 c0                	test   %eax,%eax
    21e1:	74 19                	je     21fc <subdir+0x296>
    printf(1, "chdir dd failed\n");
    21e3:	c7 44 24 04 40 4f 00 	movl   $0x4f40,0x4(%esp)
    21ea:	00 
    21eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21f2:	e8 41 1e 00 00       	call   4038 <printf>
    exit();
    21f7:	e8 bc 1c 00 00       	call   3eb8 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21fc:	c7 04 24 51 4f 00 00 	movl   $0x4f51,(%esp)
    2203:	e8 20 1d 00 00       	call   3f28 <chdir>
    2208:	85 c0                	test   %eax,%eax
    220a:	74 19                	je     2225 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    220c:	c7 44 24 04 5d 4f 00 	movl   $0x4f5d,0x4(%esp)
    2213:	00 
    2214:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    221b:	e8 18 1e 00 00       	call   4038 <printf>
    exit();
    2220:	e8 93 1c 00 00       	call   3eb8 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    2225:	c7 04 24 77 4f 00 00 	movl   $0x4f77,(%esp)
    222c:	e8 f7 1c 00 00       	call   3f28 <chdir>
    2231:	85 c0                	test   %eax,%eax
    2233:	74 19                	je     224e <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    2235:	c7 44 24 04 5d 4f 00 	movl   $0x4f5d,0x4(%esp)
    223c:	00 
    223d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2244:	e8 ef 1d 00 00       	call   4038 <printf>
    exit();
    2249:	e8 6a 1c 00 00       	call   3eb8 <exit>
  }
  if(chdir("./..") != 0){
    224e:	c7 04 24 86 4f 00 00 	movl   $0x4f86,(%esp)
    2255:	e8 ce 1c 00 00       	call   3f28 <chdir>
    225a:	85 c0                	test   %eax,%eax
    225c:	74 19                	je     2277 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    225e:	c7 44 24 04 8b 4f 00 	movl   $0x4f8b,0x4(%esp)
    2265:	00 
    2266:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    226d:	e8 c6 1d 00 00       	call   4038 <printf>
    exit();
    2272:	e8 41 1c 00 00       	call   3eb8 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2277:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    227e:	00 
    227f:	c7 04 24 d4 4e 00 00 	movl   $0x4ed4,(%esp)
    2286:	e8 6d 1c 00 00       	call   3ef8 <open>
    228b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    228e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2292:	79 19                	jns    22ad <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    2294:	c7 44 24 04 9e 4f 00 	movl   $0x4f9e,0x4(%esp)
    229b:	00 
    229c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22a3:	e8 90 1d 00 00       	call   4038 <printf>
    exit();
    22a8:	e8 0b 1c 00 00       	call   3eb8 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    22ad:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    22b4:	00 
    22b5:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    22bc:	00 
    22bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22c0:	89 04 24             	mov    %eax,(%esp)
    22c3:	e8 08 1c 00 00       	call   3ed0 <read>
    22c8:	83 f8 02             	cmp    $0x2,%eax
    22cb:	74 19                	je     22e6 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    22cd:	c7 44 24 04 b6 4f 00 	movl   $0x4fb6,0x4(%esp)
    22d4:	00 
    22d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22dc:	e8 57 1d 00 00       	call   4038 <printf>
    exit();
    22e1:	e8 d2 1b 00 00       	call   3eb8 <exit>
  }
  close(fd);
    22e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22e9:	89 04 24             	mov    %eax,(%esp)
    22ec:	e8 ef 1b 00 00       	call   3ee0 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    22f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22f8:	00 
    22f9:	c7 04 24 70 4e 00 00 	movl   $0x4e70,(%esp)
    2300:	e8 f3 1b 00 00       	call   3ef8 <open>
    2305:	85 c0                	test   %eax,%eax
    2307:	78 19                	js     2322 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2309:	c7 44 24 04 d4 4f 00 	movl   $0x4fd4,0x4(%esp)
    2310:	00 
    2311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2318:	e8 1b 1d 00 00       	call   4038 <printf>
    exit();
    231d:	e8 96 1b 00 00       	call   3eb8 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2322:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2329:	00 
    232a:	c7 04 24 f9 4f 00 00 	movl   $0x4ff9,(%esp)
    2331:	e8 c2 1b 00 00       	call   3ef8 <open>
    2336:	85 c0                	test   %eax,%eax
    2338:	78 19                	js     2353 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    233a:	c7 44 24 04 02 50 00 	movl   $0x5002,0x4(%esp)
    2341:	00 
    2342:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2349:	e8 ea 1c 00 00       	call   4038 <printf>
    exit();
    234e:	e8 65 1b 00 00       	call   3eb8 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2353:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    235a:	00 
    235b:	c7 04 24 1e 50 00 00 	movl   $0x501e,(%esp)
    2362:	e8 91 1b 00 00       	call   3ef8 <open>
    2367:	85 c0                	test   %eax,%eax
    2369:	78 19                	js     2384 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    236b:	c7 44 24 04 27 50 00 	movl   $0x5027,0x4(%esp)
    2372:	00 
    2373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    237a:	e8 b9 1c 00 00       	call   4038 <printf>
    exit();
    237f:	e8 34 1b 00 00       	call   3eb8 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    2384:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    238b:	00 
    238c:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    2393:	e8 60 1b 00 00       	call   3ef8 <open>
    2398:	85 c0                	test   %eax,%eax
    239a:	78 19                	js     23b5 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    239c:	c7 44 24 04 43 50 00 	movl   $0x5043,0x4(%esp)
    23a3:	00 
    23a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23ab:	e8 88 1c 00 00       	call   4038 <printf>
    exit();
    23b0:	e8 03 1b 00 00       	call   3eb8 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    23b5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    23bc:	00 
    23bd:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    23c4:	e8 2f 1b 00 00       	call   3ef8 <open>
    23c9:	85 c0                	test   %eax,%eax
    23cb:	78 19                	js     23e6 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    23cd:	c7 44 24 04 59 50 00 	movl   $0x5059,0x4(%esp)
    23d4:	00 
    23d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23dc:	e8 57 1c 00 00       	call   4038 <printf>
    exit();
    23e1:	e8 d2 1a 00 00       	call   3eb8 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    23e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    23ed:	00 
    23ee:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    23f5:	e8 fe 1a 00 00       	call   3ef8 <open>
    23fa:	85 c0                	test   %eax,%eax
    23fc:	78 19                	js     2417 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    23fe:	c7 44 24 04 72 50 00 	movl   $0x5072,0x4(%esp)
    2405:	00 
    2406:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    240d:	e8 26 1c 00 00       	call   4038 <printf>
    exit();
    2412:	e8 a1 1a 00 00       	call   3eb8 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2417:	c7 44 24 04 8d 50 00 	movl   $0x508d,0x4(%esp)
    241e:	00 
    241f:	c7 04 24 f9 4f 00 00 	movl   $0x4ff9,(%esp)
    2426:	e8 ed 1a 00 00       	call   3f18 <link>
    242b:	85 c0                	test   %eax,%eax
    242d:	75 19                	jne    2448 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    242f:	c7 44 24 04 98 50 00 	movl   $0x5098,0x4(%esp)
    2436:	00 
    2437:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    243e:	e8 f5 1b 00 00       	call   4038 <printf>
    exit();
    2443:	e8 70 1a 00 00       	call   3eb8 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2448:	c7 44 24 04 8d 50 00 	movl   $0x508d,0x4(%esp)
    244f:	00 
    2450:	c7 04 24 1e 50 00 00 	movl   $0x501e,(%esp)
    2457:	e8 bc 1a 00 00       	call   3f18 <link>
    245c:	85 c0                	test   %eax,%eax
    245e:	75 19                	jne    2479 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2460:	c7 44 24 04 bc 50 00 	movl   $0x50bc,0x4(%esp)
    2467:	00 
    2468:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    246f:	e8 c4 1b 00 00       	call   4038 <printf>
    exit();
    2474:	e8 3f 1a 00 00       	call   3eb8 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2479:	c7 44 24 04 d4 4e 00 	movl   $0x4ed4,0x4(%esp)
    2480:	00 
    2481:	c7 04 24 0c 4e 00 00 	movl   $0x4e0c,(%esp)
    2488:	e8 8b 1a 00 00       	call   3f18 <link>
    248d:	85 c0                	test   %eax,%eax
    248f:	75 19                	jne    24aa <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2491:	c7 44 24 04 e0 50 00 	movl   $0x50e0,0x4(%esp)
    2498:	00 
    2499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24a0:	e8 93 1b 00 00       	call   4038 <printf>
    exit();
    24a5:	e8 0e 1a 00 00       	call   3eb8 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    24aa:	c7 04 24 f9 4f 00 00 	movl   $0x4ff9,(%esp)
    24b1:	e8 6a 1a 00 00       	call   3f20 <mkdir>
    24b6:	85 c0                	test   %eax,%eax
    24b8:	75 19                	jne    24d3 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    24ba:	c7 44 24 04 02 51 00 	movl   $0x5102,0x4(%esp)
    24c1:	00 
    24c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24c9:	e8 6a 1b 00 00       	call   4038 <printf>
    exit();
    24ce:	e8 e5 19 00 00       	call   3eb8 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    24d3:	c7 04 24 1e 50 00 00 	movl   $0x501e,(%esp)
    24da:	e8 41 1a 00 00       	call   3f20 <mkdir>
    24df:	85 c0                	test   %eax,%eax
    24e1:	75 19                	jne    24fc <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    24e3:	c7 44 24 04 1d 51 00 	movl   $0x511d,0x4(%esp)
    24ea:	00 
    24eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24f2:	e8 41 1b 00 00       	call   4038 <printf>
    exit();
    24f7:	e8 bc 19 00 00       	call   3eb8 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24fc:	c7 04 24 d4 4e 00 00 	movl   $0x4ed4,(%esp)
    2503:	e8 18 1a 00 00       	call   3f20 <mkdir>
    2508:	85 c0                	test   %eax,%eax
    250a:	75 19                	jne    2525 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    250c:	c7 44 24 04 38 51 00 	movl   $0x5138,0x4(%esp)
    2513:	00 
    2514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    251b:	e8 18 1b 00 00       	call   4038 <printf>
    exit();
    2520:	e8 93 19 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2525:	c7 04 24 1e 50 00 00 	movl   $0x501e,(%esp)
    252c:	e8 d7 19 00 00       	call   3f08 <unlink>
    2531:	85 c0                	test   %eax,%eax
    2533:	75 19                	jne    254e <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2535:	c7 44 24 04 55 51 00 	movl   $0x5155,0x4(%esp)
    253c:	00 
    253d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2544:	e8 ef 1a 00 00       	call   4038 <printf>
    exit();
    2549:	e8 6a 19 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    254e:	c7 04 24 f9 4f 00 00 	movl   $0x4ff9,(%esp)
    2555:	e8 ae 19 00 00       	call   3f08 <unlink>
    255a:	85 c0                	test   %eax,%eax
    255c:	75 19                	jne    2577 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    255e:	c7 44 24 04 71 51 00 	movl   $0x5171,0x4(%esp)
    2565:	00 
    2566:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    256d:	e8 c6 1a 00 00       	call   4038 <printf>
    exit();
    2572:	e8 41 19 00 00       	call   3eb8 <exit>
  }
  if(chdir("dd/ff") == 0){
    2577:	c7 04 24 0c 4e 00 00 	movl   $0x4e0c,(%esp)
    257e:	e8 a5 19 00 00       	call   3f28 <chdir>
    2583:	85 c0                	test   %eax,%eax
    2585:	75 19                	jne    25a0 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    2587:	c7 44 24 04 8d 51 00 	movl   $0x518d,0x4(%esp)
    258e:	00 
    258f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2596:	e8 9d 1a 00 00       	call   4038 <printf>
    exit();
    259b:	e8 18 19 00 00       	call   3eb8 <exit>
  }
  if(chdir("dd/xx") == 0){
    25a0:	c7 04 24 a5 51 00 00 	movl   $0x51a5,(%esp)
    25a7:	e8 7c 19 00 00       	call   3f28 <chdir>
    25ac:	85 c0                	test   %eax,%eax
    25ae:	75 19                	jne    25c9 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    25b0:	c7 44 24 04 ab 51 00 	movl   $0x51ab,0x4(%esp)
    25b7:	00 
    25b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25bf:	e8 74 1a 00 00       	call   4038 <printf>
    exit();
    25c4:	e8 ef 18 00 00       	call   3eb8 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    25c9:	c7 04 24 d4 4e 00 00 	movl   $0x4ed4,(%esp)
    25d0:	e8 33 19 00 00       	call   3f08 <unlink>
    25d5:	85 c0                	test   %eax,%eax
    25d7:	74 19                	je     25f2 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    25d9:	c7 44 24 04 01 4f 00 	movl   $0x4f01,0x4(%esp)
    25e0:	00 
    25e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e8:	e8 4b 1a 00 00       	call   4038 <printf>
    exit();
    25ed:	e8 c6 18 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd/ff") != 0){
    25f2:	c7 04 24 0c 4e 00 00 	movl   $0x4e0c,(%esp)
    25f9:	e8 0a 19 00 00       	call   3f08 <unlink>
    25fe:	85 c0                	test   %eax,%eax
    2600:	74 19                	je     261b <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    2602:	c7 44 24 04 c3 51 00 	movl   $0x51c3,0x4(%esp)
    2609:	00 
    260a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2611:	e8 22 1a 00 00       	call   4038 <printf>
    exit();
    2616:	e8 9d 18 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd") == 0){
    261b:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    2622:	e8 e1 18 00 00       	call   3f08 <unlink>
    2627:	85 c0                	test   %eax,%eax
    2629:	75 19                	jne    2644 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    262b:	c7 44 24 04 d8 51 00 	movl   $0x51d8,0x4(%esp)
    2632:	00 
    2633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    263a:	e8 f9 19 00 00       	call   4038 <printf>
    exit();
    263f:	e8 74 18 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd/dd") < 0){
    2644:	c7 04 24 f8 51 00 00 	movl   $0x51f8,(%esp)
    264b:	e8 b8 18 00 00       	call   3f08 <unlink>
    2650:	85 c0                	test   %eax,%eax
    2652:	79 19                	jns    266d <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    2654:	c7 44 24 04 fe 51 00 	movl   $0x51fe,0x4(%esp)
    265b:	00 
    265c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2663:	e8 d0 19 00 00       	call   4038 <printf>
    exit();
    2668:	e8 4b 18 00 00       	call   3eb8 <exit>
  }
  if(unlink("dd") < 0){
    266d:	c7 04 24 f1 4d 00 00 	movl   $0x4df1,(%esp)
    2674:	e8 8f 18 00 00       	call   3f08 <unlink>
    2679:	85 c0                	test   %eax,%eax
    267b:	79 19                	jns    2696 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    267d:	c7 44 24 04 13 52 00 	movl   $0x5213,0x4(%esp)
    2684:	00 
    2685:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    268c:	e8 a7 19 00 00       	call   4038 <printf>
    exit();
    2691:	e8 22 18 00 00       	call   3eb8 <exit>
  }

  printf(1, "subdir ok\n");
    2696:	c7 44 24 04 25 52 00 	movl   $0x5225,0x4(%esp)
    269d:	00 
    269e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26a5:	e8 8e 19 00 00       	call   4038 <printf>
}
    26aa:	c9                   	leave  
    26ab:	c3                   	ret    

000026ac <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    26ac:	55                   	push   %ebp
    26ad:	89 e5                	mov    %esp,%ebp
    26af:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    26b2:	c7 44 24 04 30 52 00 	movl   $0x5230,0x4(%esp)
    26b9:	00 
    26ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26c1:	e8 72 19 00 00       	call   4038 <printf>

  unlink("bigwrite");
    26c6:	c7 04 24 3f 52 00 00 	movl   $0x523f,(%esp)
    26cd:	e8 36 18 00 00       	call   3f08 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    26d2:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    26d9:	e9 b3 00 00 00       	jmp    2791 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    26de:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    26e5:	00 
    26e6:	c7 04 24 3f 52 00 00 	movl   $0x523f,(%esp)
    26ed:	e8 06 18 00 00       	call   3ef8 <open>
    26f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    26f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26f9:	79 19                	jns    2714 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    26fb:	c7 44 24 04 48 52 00 	movl   $0x5248,0x4(%esp)
    2702:	00 
    2703:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    270a:	e8 29 19 00 00       	call   4038 <printf>
      exit();
    270f:	e8 a4 17 00 00       	call   3eb8 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    2714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    271b:	eb 50                	jmp    276d <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2720:	89 44 24 08          	mov    %eax,0x8(%esp)
    2724:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    272b:	00 
    272c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    272f:	89 04 24             	mov    %eax,(%esp)
    2732:	e8 a1 17 00 00       	call   3ed8 <write>
    2737:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    273a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    273d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2740:	74 27                	je     2769 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2742:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2745:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    274c:	89 44 24 08          	mov    %eax,0x8(%esp)
    2750:	c7 44 24 04 60 52 00 	movl   $0x5260,0x4(%esp)
    2757:	00 
    2758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275f:	e8 d4 18 00 00       	call   4038 <printf>
        exit();
    2764:	e8 4f 17 00 00       	call   3eb8 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    2769:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    276d:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2771:	7e aa                	jle    271d <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2773:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2776:	89 04 24             	mov    %eax,(%esp)
    2779:	e8 62 17 00 00       	call   3ee0 <close>
    unlink("bigwrite");
    277e:	c7 04 24 3f 52 00 00 	movl   $0x523f,(%esp)
    2785:	e8 7e 17 00 00       	call   3f08 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    278a:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2791:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2798:	0f 8e 40 ff ff ff    	jle    26de <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    279e:	c7 44 24 04 72 52 00 	movl   $0x5272,0x4(%esp)
    27a5:	00 
    27a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ad:	e8 86 18 00 00       	call   4038 <printf>
}
    27b2:	c9                   	leave  
    27b3:	c3                   	ret    

000027b4 <bigfile>:

void
bigfile(void)
{
    27b4:	55                   	push   %ebp
    27b5:	89 e5                	mov    %esp,%ebp
    27b7:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    27ba:	c7 44 24 04 7f 52 00 	movl   $0x527f,0x4(%esp)
    27c1:	00 
    27c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c9:	e8 6a 18 00 00       	call   4038 <printf>

  unlink("bigfile");
    27ce:	c7 04 24 8d 52 00 00 	movl   $0x528d,(%esp)
    27d5:	e8 2e 17 00 00       	call   3f08 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    27da:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    27e1:	00 
    27e2:	c7 04 24 8d 52 00 00 	movl   $0x528d,(%esp)
    27e9:	e8 0a 17 00 00       	call   3ef8 <open>
    27ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    27f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    27f5:	79 19                	jns    2810 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    27f7:	c7 44 24 04 95 52 00 	movl   $0x5295,0x4(%esp)
    27fe:	00 
    27ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2806:	e8 2d 18 00 00       	call   4038 <printf>
    exit();
    280b:	e8 a8 16 00 00       	call   3eb8 <exit>
  }
  for(i = 0; i < 20; i++){
    2810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2817:	eb 5a                	jmp    2873 <bigfile+0xbf>
    memset(buf, i, 600);
    2819:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2820:	00 
    2821:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2824:	89 44 24 04          	mov    %eax,0x4(%esp)
    2828:	c7 04 24 c0 8a 00 00 	movl   $0x8ac0,(%esp)
    282f:	e8 d7 14 00 00       	call   3d0b <memset>
    if(write(fd, buf, 600) != 600){
    2834:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    283b:	00 
    283c:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    2843:	00 
    2844:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2847:	89 04 24             	mov    %eax,(%esp)
    284a:	e8 89 16 00 00       	call   3ed8 <write>
    284f:	3d 58 02 00 00       	cmp    $0x258,%eax
    2854:	74 19                	je     286f <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    2856:	c7 44 24 04 ab 52 00 	movl   $0x52ab,0x4(%esp)
    285d:	00 
    285e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2865:	e8 ce 17 00 00       	call   4038 <printf>
      exit();
    286a:	e8 49 16 00 00       	call   3eb8 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    286f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2873:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2877:	7e a0                	jle    2819 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2879:	8b 45 ec             	mov    -0x14(%ebp),%eax
    287c:	89 04 24             	mov    %eax,(%esp)
    287f:	e8 5c 16 00 00       	call   3ee0 <close>

  fd = open("bigfile", 0);
    2884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    288b:	00 
    288c:	c7 04 24 8d 52 00 00 	movl   $0x528d,(%esp)
    2893:	e8 60 16 00 00       	call   3ef8 <open>
    2898:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    289b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    289f:	79 19                	jns    28ba <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    28a1:	c7 44 24 04 c1 52 00 	movl   $0x52c1,0x4(%esp)
    28a8:	00 
    28a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28b0:	e8 83 17 00 00       	call   4038 <printf>
    exit();
    28b5:	e8 fe 15 00 00       	call   3eb8 <exit>
  }
  total = 0;
    28ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    28c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    28c8:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    28cf:	00 
    28d0:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    28d7:	00 
    28d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    28db:	89 04 24             	mov    %eax,(%esp)
    28de:	e8 ed 15 00 00       	call   3ed0 <read>
    28e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    28e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28ea:	79 19                	jns    2905 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    28ec:	c7 44 24 04 d6 52 00 	movl   $0x52d6,0x4(%esp)
    28f3:	00 
    28f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28fb:	e8 38 17 00 00       	call   4038 <printf>
      exit();
    2900:	e8 b3 15 00 00       	call   3eb8 <exit>
    }
    if(cc == 0)
    2905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2909:	75 1b                	jne    2926 <bigfile+0x172>
      break;
    290b:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    290f:	89 04 24             	mov    %eax,(%esp)
    2912:	e8 c9 15 00 00       	call   3ee0 <close>
  if(total != 20*600){
    2917:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    291e:	0f 84 99 00 00 00    	je     29bd <bigfile+0x209>
    2924:	eb 7e                	jmp    29a4 <bigfile+0x1f0>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    2926:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    292d:	74 19                	je     2948 <bigfile+0x194>
      printf(1, "short read bigfile\n");
    292f:	c7 44 24 04 eb 52 00 	movl   $0x52eb,0x4(%esp)
    2936:	00 
    2937:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    293e:	e8 f5 16 00 00       	call   4038 <printf>
      exit();
    2943:	e8 70 15 00 00       	call   3eb8 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2948:	0f b6 05 c0 8a 00 00 	movzbl 0x8ac0,%eax
    294f:	0f be d0             	movsbl %al,%edx
    2952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2955:	89 c1                	mov    %eax,%ecx
    2957:	c1 e9 1f             	shr    $0x1f,%ecx
    295a:	01 c8                	add    %ecx,%eax
    295c:	d1 f8                	sar    %eax
    295e:	39 c2                	cmp    %eax,%edx
    2960:	75 1a                	jne    297c <bigfile+0x1c8>
    2962:	0f b6 05 eb 8b 00 00 	movzbl 0x8beb,%eax
    2969:	0f be d0             	movsbl %al,%edx
    296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    296f:	89 c1                	mov    %eax,%ecx
    2971:	c1 e9 1f             	shr    $0x1f,%ecx
    2974:	01 c8                	add    %ecx,%eax
    2976:	d1 f8                	sar    %eax
    2978:	39 c2                	cmp    %eax,%edx
    297a:	74 19                	je     2995 <bigfile+0x1e1>
      printf(1, "read bigfile wrong data\n");
    297c:	c7 44 24 04 ff 52 00 	movl   $0x52ff,0x4(%esp)
    2983:	00 
    2984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    298b:	e8 a8 16 00 00       	call   4038 <printf>
      exit();
    2990:	e8 23 15 00 00       	call   3eb8 <exit>
    }
    total += cc;
    2995:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2998:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    299b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    299f:	e9 24 ff ff ff       	jmp    28c8 <bigfile+0x114>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    29a4:	c7 44 24 04 18 53 00 	movl   $0x5318,0x4(%esp)
    29ab:	00 
    29ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b3:	e8 80 16 00 00       	call   4038 <printf>
    exit();
    29b8:	e8 fb 14 00 00       	call   3eb8 <exit>
  }
  unlink("bigfile");
    29bd:	c7 04 24 8d 52 00 00 	movl   $0x528d,(%esp)
    29c4:	e8 3f 15 00 00       	call   3f08 <unlink>

  printf(1, "bigfile test ok\n");
    29c9:	c7 44 24 04 32 53 00 	movl   $0x5332,0x4(%esp)
    29d0:	00 
    29d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29d8:	e8 5b 16 00 00       	call   4038 <printf>
}
    29dd:	c9                   	leave  
    29de:	c3                   	ret    

000029df <fourteen>:

void
fourteen(void)
{
    29df:	55                   	push   %ebp
    29e0:	89 e5                	mov    %esp,%ebp
    29e2:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    29e5:	c7 44 24 04 43 53 00 	movl   $0x5343,0x4(%esp)
    29ec:	00 
    29ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29f4:	e8 3f 16 00 00       	call   4038 <printf>

  if(mkdir("12345678901234") != 0){
    29f9:	c7 04 24 52 53 00 00 	movl   $0x5352,(%esp)
    2a00:	e8 1b 15 00 00       	call   3f20 <mkdir>
    2a05:	85 c0                	test   %eax,%eax
    2a07:	74 19                	je     2a22 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2a09:	c7 44 24 04 61 53 00 	movl   $0x5361,0x4(%esp)
    2a10:	00 
    2a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a18:	e8 1b 16 00 00       	call   4038 <printf>
    exit();
    2a1d:	e8 96 14 00 00       	call   3eb8 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2a22:	c7 04 24 80 53 00 00 	movl   $0x5380,(%esp)
    2a29:	e8 f2 14 00 00       	call   3f20 <mkdir>
    2a2e:	85 c0                	test   %eax,%eax
    2a30:	74 19                	je     2a4b <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2a32:	c7 44 24 04 a0 53 00 	movl   $0x53a0,0x4(%esp)
    2a39:	00 
    2a3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a41:	e8 f2 15 00 00       	call   4038 <printf>
    exit();
    2a46:	e8 6d 14 00 00       	call   3eb8 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2a4b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a52:	00 
    2a53:	c7 04 24 d0 53 00 00 	movl   $0x53d0,(%esp)
    2a5a:	e8 99 14 00 00       	call   3ef8 <open>
    2a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a66:	79 19                	jns    2a81 <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a68:	c7 44 24 04 00 54 00 	movl   $0x5400,0x4(%esp)
    2a6f:	00 
    2a70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a77:	e8 bc 15 00 00       	call   4038 <printf>
    exit();
    2a7c:	e8 37 14 00 00       	call   3eb8 <exit>
  }
  close(fd);
    2a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a84:	89 04 24             	mov    %eax,(%esp)
    2a87:	e8 54 14 00 00       	call   3ee0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a93:	00 
    2a94:	c7 04 24 40 54 00 00 	movl   $0x5440,(%esp)
    2a9b:	e8 58 14 00 00       	call   3ef8 <open>
    2aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2aa7:	79 19                	jns    2ac2 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2aa9:	c7 44 24 04 70 54 00 	movl   $0x5470,0x4(%esp)
    2ab0:	00 
    2ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab8:	e8 7b 15 00 00       	call   4038 <printf>
    exit();
    2abd:	e8 f6 13 00 00       	call   3eb8 <exit>
  }
  close(fd);
    2ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ac5:	89 04 24             	mov    %eax,(%esp)
    2ac8:	e8 13 14 00 00       	call   3ee0 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2acd:	c7 04 24 aa 54 00 00 	movl   $0x54aa,(%esp)
    2ad4:	e8 47 14 00 00       	call   3f20 <mkdir>
    2ad9:	85 c0                	test   %eax,%eax
    2adb:	75 19                	jne    2af6 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2add:	c7 44 24 04 c8 54 00 	movl   $0x54c8,0x4(%esp)
    2ae4:	00 
    2ae5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aec:	e8 47 15 00 00       	call   4038 <printf>
    exit();
    2af1:	e8 c2 13 00 00       	call   3eb8 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2af6:	c7 04 24 f8 54 00 00 	movl   $0x54f8,(%esp)
    2afd:	e8 1e 14 00 00       	call   3f20 <mkdir>
    2b02:	85 c0                	test   %eax,%eax
    2b04:	75 19                	jne    2b1f <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2b06:	c7 44 24 04 18 55 00 	movl   $0x5518,0x4(%esp)
    2b0d:	00 
    2b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b15:	e8 1e 15 00 00       	call   4038 <printf>
    exit();
    2b1a:	e8 99 13 00 00       	call   3eb8 <exit>
  }

  printf(1, "fourteen ok\n");
    2b1f:	c7 44 24 04 49 55 00 	movl   $0x5549,0x4(%esp)
    2b26:	00 
    2b27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b2e:	e8 05 15 00 00       	call   4038 <printf>
}
    2b33:	c9                   	leave  
    2b34:	c3                   	ret    

00002b35 <rmdot>:

void
rmdot(void)
{
    2b35:	55                   	push   %ebp
    2b36:	89 e5                	mov    %esp,%ebp
    2b38:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2b3b:	c7 44 24 04 56 55 00 	movl   $0x5556,0x4(%esp)
    2b42:	00 
    2b43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b4a:	e8 e9 14 00 00       	call   4038 <printf>
  if(mkdir("dots") != 0){
    2b4f:	c7 04 24 62 55 00 00 	movl   $0x5562,(%esp)
    2b56:	e8 c5 13 00 00       	call   3f20 <mkdir>
    2b5b:	85 c0                	test   %eax,%eax
    2b5d:	74 19                	je     2b78 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2b5f:	c7 44 24 04 67 55 00 	movl   $0x5567,0x4(%esp)
    2b66:	00 
    2b67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b6e:	e8 c5 14 00 00       	call   4038 <printf>
    exit();
    2b73:	e8 40 13 00 00       	call   3eb8 <exit>
  }
  if(chdir("dots") != 0){
    2b78:	c7 04 24 62 55 00 00 	movl   $0x5562,(%esp)
    2b7f:	e8 a4 13 00 00       	call   3f28 <chdir>
    2b84:	85 c0                	test   %eax,%eax
    2b86:	74 19                	je     2ba1 <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2b88:	c7 44 24 04 7a 55 00 	movl   $0x557a,0x4(%esp)
    2b8f:	00 
    2b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b97:	e8 9c 14 00 00       	call   4038 <printf>
    exit();
    2b9c:	e8 17 13 00 00       	call   3eb8 <exit>
  }
  if(unlink(".") == 0){
    2ba1:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    2ba8:	e8 5b 13 00 00       	call   3f08 <unlink>
    2bad:	85 c0                	test   %eax,%eax
    2baf:	75 19                	jne    2bca <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2bb1:	c7 44 24 04 8d 55 00 	movl   $0x558d,0x4(%esp)
    2bb8:	00 
    2bb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bc0:	e8 73 14 00 00       	call   4038 <printf>
    exit();
    2bc5:	e8 ee 12 00 00       	call   3eb8 <exit>
  }
  if(unlink("..") == 0){
    2bca:	c7 04 24 26 48 00 00 	movl   $0x4826,(%esp)
    2bd1:	e8 32 13 00 00       	call   3f08 <unlink>
    2bd6:	85 c0                	test   %eax,%eax
    2bd8:	75 19                	jne    2bf3 <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2bda:	c7 44 24 04 9b 55 00 	movl   $0x559b,0x4(%esp)
    2be1:	00 
    2be2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2be9:	e8 4a 14 00 00       	call   4038 <printf>
    exit();
    2bee:	e8 c5 12 00 00       	call   3eb8 <exit>
  }
  if(chdir("/") != 0){
    2bf3:	c7 04 24 7a 44 00 00 	movl   $0x447a,(%esp)
    2bfa:	e8 29 13 00 00       	call   3f28 <chdir>
    2bff:	85 c0                	test   %eax,%eax
    2c01:	74 19                	je     2c1c <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2c03:	c7 44 24 04 7c 44 00 	movl   $0x447c,0x4(%esp)
    2c0a:	00 
    2c0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c12:	e8 21 14 00 00       	call   4038 <printf>
    exit();
    2c17:	e8 9c 12 00 00       	call   3eb8 <exit>
  }
  if(unlink("dots/.") == 0){
    2c1c:	c7 04 24 aa 55 00 00 	movl   $0x55aa,(%esp)
    2c23:	e8 e0 12 00 00       	call   3f08 <unlink>
    2c28:	85 c0                	test   %eax,%eax
    2c2a:	75 19                	jne    2c45 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2c2c:	c7 44 24 04 b1 55 00 	movl   $0x55b1,0x4(%esp)
    2c33:	00 
    2c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c3b:	e8 f8 13 00 00       	call   4038 <printf>
    exit();
    2c40:	e8 73 12 00 00       	call   3eb8 <exit>
  }
  if(unlink("dots/..") == 0){
    2c45:	c7 04 24 c8 55 00 00 	movl   $0x55c8,(%esp)
    2c4c:	e8 b7 12 00 00       	call   3f08 <unlink>
    2c51:	85 c0                	test   %eax,%eax
    2c53:	75 19                	jne    2c6e <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2c55:	c7 44 24 04 d0 55 00 	movl   $0x55d0,0x4(%esp)
    2c5c:	00 
    2c5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c64:	e8 cf 13 00 00       	call   4038 <printf>
    exit();
    2c69:	e8 4a 12 00 00       	call   3eb8 <exit>
  }
  if(unlink("dots") != 0){
    2c6e:	c7 04 24 62 55 00 00 	movl   $0x5562,(%esp)
    2c75:	e8 8e 12 00 00       	call   3f08 <unlink>
    2c7a:	85 c0                	test   %eax,%eax
    2c7c:	74 19                	je     2c97 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2c7e:	c7 44 24 04 e8 55 00 	movl   $0x55e8,0x4(%esp)
    2c85:	00 
    2c86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c8d:	e8 a6 13 00 00       	call   4038 <printf>
    exit();
    2c92:	e8 21 12 00 00       	call   3eb8 <exit>
  }
  printf(1, "rmdot ok\n");
    2c97:	c7 44 24 04 fd 55 00 	movl   $0x55fd,0x4(%esp)
    2c9e:	00 
    2c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ca6:	e8 8d 13 00 00       	call   4038 <printf>
}
    2cab:	c9                   	leave  
    2cac:	c3                   	ret    

00002cad <dirfile>:

void
dirfile(void)
{
    2cad:	55                   	push   %ebp
    2cae:	89 e5                	mov    %esp,%ebp
    2cb0:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2cb3:	c7 44 24 04 07 56 00 	movl   $0x5607,0x4(%esp)
    2cba:	00 
    2cbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc2:	e8 71 13 00 00       	call   4038 <printf>

  fd = open("dirfile", O_CREATE);
    2cc7:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cce:	00 
    2ccf:	c7 04 24 14 56 00 00 	movl   $0x5614,(%esp)
    2cd6:	e8 1d 12 00 00       	call   3ef8 <open>
    2cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ce2:	79 19                	jns    2cfd <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2ce4:	c7 44 24 04 1c 56 00 	movl   $0x561c,0x4(%esp)
    2ceb:	00 
    2cec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cf3:	e8 40 13 00 00       	call   4038 <printf>
    exit();
    2cf8:	e8 bb 11 00 00       	call   3eb8 <exit>
  }
  close(fd);
    2cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d00:	89 04 24             	mov    %eax,(%esp)
    2d03:	e8 d8 11 00 00       	call   3ee0 <close>
  if(chdir("dirfile") == 0){
    2d08:	c7 04 24 14 56 00 00 	movl   $0x5614,(%esp)
    2d0f:	e8 14 12 00 00       	call   3f28 <chdir>
    2d14:	85 c0                	test   %eax,%eax
    2d16:	75 19                	jne    2d31 <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2d18:	c7 44 24 04 33 56 00 	movl   $0x5633,0x4(%esp)
    2d1f:	00 
    2d20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d27:	e8 0c 13 00 00       	call   4038 <printf>
    exit();
    2d2c:	e8 87 11 00 00       	call   3eb8 <exit>
  }
  fd = open("dirfile/xx", 0);
    2d31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2d38:	00 
    2d39:	c7 04 24 4d 56 00 00 	movl   $0x564d,(%esp)
    2d40:	e8 b3 11 00 00       	call   3ef8 <open>
    2d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d4c:	78 19                	js     2d67 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2d4e:	c7 44 24 04 58 56 00 	movl   $0x5658,0x4(%esp)
    2d55:	00 
    2d56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d5d:	e8 d6 12 00 00       	call   4038 <printf>
    exit();
    2d62:	e8 51 11 00 00       	call   3eb8 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d67:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d6e:	00 
    2d6f:	c7 04 24 4d 56 00 00 	movl   $0x564d,(%esp)
    2d76:	e8 7d 11 00 00       	call   3ef8 <open>
    2d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d82:	78 19                	js     2d9d <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2d84:	c7 44 24 04 58 56 00 	movl   $0x5658,0x4(%esp)
    2d8b:	00 
    2d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d93:	e8 a0 12 00 00       	call   4038 <printf>
    exit();
    2d98:	e8 1b 11 00 00       	call   3eb8 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d9d:	c7 04 24 4d 56 00 00 	movl   $0x564d,(%esp)
    2da4:	e8 77 11 00 00       	call   3f20 <mkdir>
    2da9:	85 c0                	test   %eax,%eax
    2dab:	75 19                	jne    2dc6 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2dad:	c7 44 24 04 76 56 00 	movl   $0x5676,0x4(%esp)
    2db4:	00 
    2db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dbc:	e8 77 12 00 00       	call   4038 <printf>
    exit();
    2dc1:	e8 f2 10 00 00       	call   3eb8 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2dc6:	c7 04 24 4d 56 00 00 	movl   $0x564d,(%esp)
    2dcd:	e8 36 11 00 00       	call   3f08 <unlink>
    2dd2:	85 c0                	test   %eax,%eax
    2dd4:	75 19                	jne    2def <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2dd6:	c7 44 24 04 93 56 00 	movl   $0x5693,0x4(%esp)
    2ddd:	00 
    2dde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2de5:	e8 4e 12 00 00       	call   4038 <printf>
    exit();
    2dea:	e8 c9 10 00 00       	call   3eb8 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2def:	c7 44 24 04 4d 56 00 	movl   $0x564d,0x4(%esp)
    2df6:	00 
    2df7:	c7 04 24 b1 56 00 00 	movl   $0x56b1,(%esp)
    2dfe:	e8 15 11 00 00       	call   3f18 <link>
    2e03:	85 c0                	test   %eax,%eax
    2e05:	75 19                	jne    2e20 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2e07:	c7 44 24 04 b8 56 00 	movl   $0x56b8,0x4(%esp)
    2e0e:	00 
    2e0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e16:	e8 1d 12 00 00       	call   4038 <printf>
    exit();
    2e1b:	e8 98 10 00 00       	call   3eb8 <exit>
  }
  if(unlink("dirfile") != 0){
    2e20:	c7 04 24 14 56 00 00 	movl   $0x5614,(%esp)
    2e27:	e8 dc 10 00 00       	call   3f08 <unlink>
    2e2c:	85 c0                	test   %eax,%eax
    2e2e:	74 19                	je     2e49 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2e30:	c7 44 24 04 d7 56 00 	movl   $0x56d7,0x4(%esp)
    2e37:	00 
    2e38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e3f:	e8 f4 11 00 00       	call   4038 <printf>
    exit();
    2e44:	e8 6f 10 00 00       	call   3eb8 <exit>
  }

  fd = open(".", O_RDWR);
    2e49:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2e50:	00 
    2e51:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    2e58:	e8 9b 10 00 00       	call   3ef8 <open>
    2e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e64:	78 19                	js     2e7f <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e66:	c7 44 24 04 f0 56 00 	movl   $0x56f0,0x4(%esp)
    2e6d:	00 
    2e6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e75:	e8 be 11 00 00       	call   4038 <printf>
    exit();
    2e7a:	e8 39 10 00 00       	call   3eb8 <exit>
  }
  fd = open(".", 0);
    2e7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e86:	00 
    2e87:	c7 04 24 93 4c 00 00 	movl   $0x4c93,(%esp)
    2e8e:	e8 65 10 00 00       	call   3ef8 <open>
    2e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e96:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e9d:	00 
    2e9e:	c7 44 24 04 df 48 00 	movl   $0x48df,0x4(%esp)
    2ea5:	00 
    2ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ea9:	89 04 24             	mov    %eax,(%esp)
    2eac:	e8 27 10 00 00       	call   3ed8 <write>
    2eb1:	85 c0                	test   %eax,%eax
    2eb3:	7e 19                	jle    2ece <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2eb5:	c7 44 24 04 0f 57 00 	movl   $0x570f,0x4(%esp)
    2ebc:	00 
    2ebd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ec4:	e8 6f 11 00 00       	call   4038 <printf>
    exit();
    2ec9:	e8 ea 0f 00 00       	call   3eb8 <exit>
  }
  close(fd);
    2ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ed1:	89 04 24             	mov    %eax,(%esp)
    2ed4:	e8 07 10 00 00       	call   3ee0 <close>

  printf(1, "dir vs file OK\n");
    2ed9:	c7 44 24 04 23 57 00 	movl   $0x5723,0x4(%esp)
    2ee0:	00 
    2ee1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ee8:	e8 4b 11 00 00       	call   4038 <printf>
}
    2eed:	c9                   	leave  
    2eee:	c3                   	ret    

00002eef <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2eef:	55                   	push   %ebp
    2ef0:	89 e5                	mov    %esp,%ebp
    2ef2:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2ef5:	c7 44 24 04 33 57 00 	movl   $0x5733,0x4(%esp)
    2efc:	00 
    2efd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f04:	e8 2f 11 00 00       	call   4038 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2f10:	e9 d2 00 00 00       	jmp    2fe7 <iref+0xf8>
    if(mkdir("irefd") != 0){
    2f15:	c7 04 24 44 57 00 00 	movl   $0x5744,(%esp)
    2f1c:	e8 ff 0f 00 00       	call   3f20 <mkdir>
    2f21:	85 c0                	test   %eax,%eax
    2f23:	74 19                	je     2f3e <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2f25:	c7 44 24 04 4a 57 00 	movl   $0x574a,0x4(%esp)
    2f2c:	00 
    2f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f34:	e8 ff 10 00 00       	call   4038 <printf>
      exit();
    2f39:	e8 7a 0f 00 00       	call   3eb8 <exit>
    }
    if(chdir("irefd") != 0){
    2f3e:	c7 04 24 44 57 00 00 	movl   $0x5744,(%esp)
    2f45:	e8 de 0f 00 00       	call   3f28 <chdir>
    2f4a:	85 c0                	test   %eax,%eax
    2f4c:	74 19                	je     2f67 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2f4e:	c7 44 24 04 5e 57 00 	movl   $0x575e,0x4(%esp)
    2f55:	00 
    2f56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f5d:	e8 d6 10 00 00       	call   4038 <printf>
      exit();
    2f62:	e8 51 0f 00 00       	call   3eb8 <exit>
    }

    mkdir("");
    2f67:	c7 04 24 72 57 00 00 	movl   $0x5772,(%esp)
    2f6e:	e8 ad 0f 00 00       	call   3f20 <mkdir>
    link("README", "");
    2f73:	c7 44 24 04 72 57 00 	movl   $0x5772,0x4(%esp)
    2f7a:	00 
    2f7b:	c7 04 24 b1 56 00 00 	movl   $0x56b1,(%esp)
    2f82:	e8 91 0f 00 00       	call   3f18 <link>
    fd = open("", O_CREATE);
    2f87:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f8e:	00 
    2f8f:	c7 04 24 72 57 00 00 	movl   $0x5772,(%esp)
    2f96:	e8 5d 0f 00 00       	call   3ef8 <open>
    2f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fa2:	78 0b                	js     2faf <iref+0xc0>
      close(fd);
    2fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fa7:	89 04 24             	mov    %eax,(%esp)
    2faa:	e8 31 0f 00 00       	call   3ee0 <close>
    fd = open("xx", O_CREATE);
    2faf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2fb6:	00 
    2fb7:	c7 04 24 73 57 00 00 	movl   $0x5773,(%esp)
    2fbe:	e8 35 0f 00 00       	call   3ef8 <open>
    2fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fca:	78 0b                	js     2fd7 <iref+0xe8>
      close(fd);
    2fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2fcf:	89 04 24             	mov    %eax,(%esp)
    2fd2:	e8 09 0f 00 00       	call   3ee0 <close>
    unlink("xx");
    2fd7:	c7 04 24 73 57 00 00 	movl   $0x5773,(%esp)
    2fde:	e8 25 0f 00 00       	call   3f08 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2fe3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2fe7:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2feb:	0f 8e 24 ff ff ff    	jle    2f15 <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2ff1:	c7 04 24 7a 44 00 00 	movl   $0x447a,(%esp)
    2ff8:	e8 2b 0f 00 00       	call   3f28 <chdir>
  printf(1, "empty file name OK\n");
    2ffd:	c7 44 24 04 76 57 00 	movl   $0x5776,0x4(%esp)
    3004:	00 
    3005:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    300c:	e8 27 10 00 00       	call   4038 <printf>
}
    3011:	c9                   	leave  
    3012:	c3                   	ret    

00003013 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    3013:	55                   	push   %ebp
    3014:	89 e5                	mov    %esp,%ebp
    3016:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    3019:	c7 44 24 04 8a 57 00 	movl   $0x578a,0x4(%esp)
    3020:	00 
    3021:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3028:	e8 0b 10 00 00       	call   4038 <printf>

  for(n=0; n<1000; n++){
    302d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3034:	eb 1f                	jmp    3055 <forktest+0x42>
    pid = fork();
    3036:	e8 75 0e 00 00       	call   3eb0 <fork>
    303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    303e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3042:	79 02                	jns    3046 <forktest+0x33>
      break;
    3044:	eb 18                	jmp    305e <forktest+0x4b>
    if(pid == 0)
    3046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    304a:	75 05                	jne    3051 <forktest+0x3e>
      exit();
    304c:	e8 67 0e 00 00       	call   3eb8 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    3051:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3055:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    305c:	7e d8                	jle    3036 <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    305e:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3065:	75 19                	jne    3080 <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
    3067:	c7 44 24 04 98 57 00 	movl   $0x5798,0x4(%esp)
    306e:	00 
    306f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3076:	e8 bd 0f 00 00       	call   4038 <printf>
    exit();
    307b:	e8 38 0e 00 00       	call   3eb8 <exit>
  }
  
  for(; n > 0; n--){
    3080:	eb 26                	jmp    30a8 <forktest+0x95>
    if(wait() < 0){
    3082:	e8 39 0e 00 00       	call   3ec0 <wait>
    3087:	85 c0                	test   %eax,%eax
    3089:	79 19                	jns    30a4 <forktest+0x91>
      printf(1, "wait stopped early\n");
    308b:	c7 44 24 04 ba 57 00 	movl   $0x57ba,0x4(%esp)
    3092:	00 
    3093:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    309a:	e8 99 0f 00 00       	call   4038 <printf>
      exit();
    309f:	e8 14 0e 00 00       	call   3eb8 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    30a4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    30a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30ac:	7f d4                	jg     3082 <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    30ae:	e8 0d 0e 00 00       	call   3ec0 <wait>
    30b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    30b6:	74 19                	je     30d1 <forktest+0xbe>
    printf(1, "wait got too many\n");
    30b8:	c7 44 24 04 ce 57 00 	movl   $0x57ce,0x4(%esp)
    30bf:	00 
    30c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30c7:	e8 6c 0f 00 00       	call   4038 <printf>
    exit();
    30cc:	e8 e7 0d 00 00       	call   3eb8 <exit>
  }
  
  printf(1, "fork test OK\n");
    30d1:	c7 44 24 04 e1 57 00 	movl   $0x57e1,0x4(%esp)
    30d8:	00 
    30d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30e0:	e8 53 0f 00 00       	call   4038 <printf>
}
    30e5:	c9                   	leave  
    30e6:	c3                   	ret    

000030e7 <sbrktest>:

void
sbrktest(void)
{
    30e7:	55                   	push   %ebp
    30e8:	89 e5                	mov    %esp,%ebp
    30ea:	53                   	push   %ebx
    30eb:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    30f1:	a1 c8 62 00 00       	mov    0x62c8,%eax
    30f6:	c7 44 24 04 ef 57 00 	movl   $0x57ef,0x4(%esp)
    30fd:	00 
    30fe:	89 04 24             	mov    %eax,(%esp)
    3101:	e8 32 0f 00 00       	call   4038 <printf>
  oldbrk = sbrk(0);
    3106:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    310d:	e8 2e 0e 00 00       	call   3f40 <sbrk>
    3112:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    3115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    311c:	e8 1f 0e 00 00       	call   3f40 <sbrk>
    3121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    3124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    312b:	eb 59                	jmp    3186 <sbrktest+0x9f>
    b = sbrk(1);
    312d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3134:	e8 07 0e 00 00       	call   3f40 <sbrk>
    3139:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    313f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3142:	74 2f                	je     3173 <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3144:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3149:	8b 55 e8             	mov    -0x18(%ebp),%edx
    314c:	89 54 24 10          	mov    %edx,0x10(%esp)
    3150:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3153:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3157:	8b 55 f0             	mov    -0x10(%ebp),%edx
    315a:	89 54 24 08          	mov    %edx,0x8(%esp)
    315e:	c7 44 24 04 fa 57 00 	movl   $0x57fa,0x4(%esp)
    3165:	00 
    3166:	89 04 24             	mov    %eax,(%esp)
    3169:	e8 ca 0e 00 00       	call   4038 <printf>
      exit();
    316e:	e8 45 0d 00 00       	call   3eb8 <exit>
    }
    *b = 1;
    3173:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3176:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3179:	8b 45 e8             	mov    -0x18(%ebp),%eax
    317c:	83 c0 01             	add    $0x1,%eax
    317f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3182:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3186:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    318d:	7e 9e                	jle    312d <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    318f:	e8 1c 0d 00 00       	call   3eb0 <fork>
    3194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    3197:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    319b:	79 1a                	jns    31b7 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    319d:	a1 c8 62 00 00       	mov    0x62c8,%eax
    31a2:	c7 44 24 04 15 58 00 	movl   $0x5815,0x4(%esp)
    31a9:	00 
    31aa:	89 04 24             	mov    %eax,(%esp)
    31ad:	e8 86 0e 00 00       	call   4038 <printf>
    exit();
    31b2:	e8 01 0d 00 00       	call   3eb8 <exit>
  }
  c = sbrk(1);
    31b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31be:	e8 7d 0d 00 00       	call   3f40 <sbrk>
    31c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    31c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31cd:	e8 6e 0d 00 00       	call   3f40 <sbrk>
    31d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    31d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31d8:	83 c0 01             	add    $0x1,%eax
    31db:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    31de:	74 1a                	je     31fa <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    31e0:	a1 c8 62 00 00       	mov    0x62c8,%eax
    31e5:	c7 44 24 04 2c 58 00 	movl   $0x582c,0x4(%esp)
    31ec:	00 
    31ed:	89 04 24             	mov    %eax,(%esp)
    31f0:	e8 43 0e 00 00       	call   4038 <printf>
    exit();
    31f5:	e8 be 0c 00 00       	call   3eb8 <exit>
  }
  if(pid == 0)
    31fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    31fe:	75 05                	jne    3205 <sbrktest+0x11e>
    exit();
    3200:	e8 b3 0c 00 00       	call   3eb8 <exit>
  wait();
    3205:	e8 b6 0c 00 00       	call   3ec0 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    320a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3211:	e8 2a 0d 00 00       	call   3f40 <sbrk>
    3216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    3219:	8b 45 f4             	mov    -0xc(%ebp),%eax
    321c:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3221:	29 c2                	sub    %eax,%edx
    3223:	89 d0                	mov    %edx,%eax
    3225:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    3228:	8b 45 dc             	mov    -0x24(%ebp),%eax
    322b:	89 04 24             	mov    %eax,(%esp)
    322e:	e8 0d 0d 00 00       	call   3f40 <sbrk>
    3233:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    3236:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3239:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    323c:	74 1a                	je     3258 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    323e:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3243:	c7 44 24 04 48 58 00 	movl   $0x5848,0x4(%esp)
    324a:	00 
    324b:	89 04 24             	mov    %eax,(%esp)
    324e:	e8 e5 0d 00 00       	call   4038 <printf>
    exit();
    3253:	e8 60 0c 00 00       	call   3eb8 <exit>
  }
  lastaddr = (char*) (BIG-1);
    3258:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    325f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3262:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    3265:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    326c:	e8 cf 0c 00 00       	call   3f40 <sbrk>
    3271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3274:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    327b:	e8 c0 0c 00 00       	call   3f40 <sbrk>
    3280:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3283:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3287:	75 1a                	jne    32a3 <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
    3289:	a1 c8 62 00 00       	mov    0x62c8,%eax
    328e:	c7 44 24 04 86 58 00 	movl   $0x5886,0x4(%esp)
    3295:	00 
    3296:	89 04 24             	mov    %eax,(%esp)
    3299:	e8 9a 0d 00 00       	call   4038 <printf>
    exit();
    329e:	e8 15 0c 00 00       	call   3eb8 <exit>
  }
  c = sbrk(0);
    32a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32aa:	e8 91 0c 00 00       	call   3f40 <sbrk>
    32af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    32b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32b5:	2d 00 10 00 00       	sub    $0x1000,%eax
    32ba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    32bd:	74 28                	je     32e7 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    32bf:	a1 c8 62 00 00       	mov    0x62c8,%eax
    32c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
    32c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    32cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32ce:	89 54 24 08          	mov    %edx,0x8(%esp)
    32d2:	c7 44 24 04 a4 58 00 	movl   $0x58a4,0x4(%esp)
    32d9:	00 
    32da:	89 04 24             	mov    %eax,(%esp)
    32dd:	e8 56 0d 00 00       	call   4038 <printf>
    exit();
    32e2:	e8 d1 0b 00 00       	call   3eb8 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    32e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32ee:	e8 4d 0c 00 00       	call   3f40 <sbrk>
    32f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    32f6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    32fd:	e8 3e 0c 00 00       	call   3f40 <sbrk>
    3302:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    3305:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3308:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    330b:	75 19                	jne    3326 <sbrktest+0x23f>
    330d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3314:	e8 27 0c 00 00       	call   3f40 <sbrk>
    3319:	8b 55 f4             	mov    -0xc(%ebp),%edx
    331c:	81 c2 00 10 00 00    	add    $0x1000,%edx
    3322:	39 d0                	cmp    %edx,%eax
    3324:	74 28                	je     334e <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3326:	a1 c8 62 00 00       	mov    0x62c8,%eax
    332b:	8b 55 e0             	mov    -0x20(%ebp),%edx
    332e:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3332:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3335:	89 54 24 08          	mov    %edx,0x8(%esp)
    3339:	c7 44 24 04 dc 58 00 	movl   $0x58dc,0x4(%esp)
    3340:	00 
    3341:	89 04 24             	mov    %eax,(%esp)
    3344:	e8 ef 0c 00 00       	call   4038 <printf>
    exit();
    3349:	e8 6a 0b 00 00       	call   3eb8 <exit>
  }
  if(*lastaddr == 99){
    334e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3351:	0f b6 00             	movzbl (%eax),%eax
    3354:	3c 63                	cmp    $0x63,%al
    3356:	75 1a                	jne    3372 <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3358:	a1 c8 62 00 00       	mov    0x62c8,%eax
    335d:	c7 44 24 04 04 59 00 	movl   $0x5904,0x4(%esp)
    3364:	00 
    3365:	89 04 24             	mov    %eax,(%esp)
    3368:	e8 cb 0c 00 00       	call   4038 <printf>
    exit();
    336d:	e8 46 0b 00 00       	call   3eb8 <exit>
  }

  a = sbrk(0);
    3372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3379:	e8 c2 0b 00 00       	call   3f40 <sbrk>
    337e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3381:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3384:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    338b:	e8 b0 0b 00 00       	call   3f40 <sbrk>
    3390:	29 c3                	sub    %eax,%ebx
    3392:	89 d8                	mov    %ebx,%eax
    3394:	89 04 24             	mov    %eax,(%esp)
    3397:	e8 a4 0b 00 00       	call   3f40 <sbrk>
    339c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    339f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    33a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33a5:	74 28                	je     33cf <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    33a7:	a1 c8 62 00 00       	mov    0x62c8,%eax
    33ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
    33af:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33b6:	89 54 24 08          	mov    %edx,0x8(%esp)
    33ba:	c7 44 24 04 34 59 00 	movl   $0x5934,0x4(%esp)
    33c1:	00 
    33c2:	89 04 24             	mov    %eax,(%esp)
    33c5:	e8 6e 0c 00 00       	call   4038 <printf>
    exit();
    33ca:	e8 e9 0a 00 00       	call   3eb8 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33cf:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    33d6:	eb 7b                	jmp    3453 <sbrktest+0x36c>
    ppid = getpid();
    33d8:	e8 5b 0b 00 00       	call   3f38 <getpid>
    33dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    33e0:	e8 cb 0a 00 00       	call   3eb0 <fork>
    33e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    33e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33ec:	79 1a                	jns    3408 <sbrktest+0x321>
      printf(stdout, "fork failed\n");
    33ee:	a1 c8 62 00 00       	mov    0x62c8,%eax
    33f3:	c7 44 24 04 a9 44 00 	movl   $0x44a9,0x4(%esp)
    33fa:	00 
    33fb:	89 04 24             	mov    %eax,(%esp)
    33fe:	e8 35 0c 00 00       	call   4038 <printf>
      exit();
    3403:	e8 b0 0a 00 00       	call   3eb8 <exit>
    }
    if(pid == 0){
    3408:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    340c:	75 39                	jne    3447 <sbrktest+0x360>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3411:	0f b6 00             	movzbl (%eax),%eax
    3414:	0f be d0             	movsbl %al,%edx
    3417:	a1 c8 62 00 00       	mov    0x62c8,%eax
    341c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3420:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3423:	89 54 24 08          	mov    %edx,0x8(%esp)
    3427:	c7 44 24 04 55 59 00 	movl   $0x5955,0x4(%esp)
    342e:	00 
    342f:	89 04 24             	mov    %eax,(%esp)
    3432:	e8 01 0c 00 00       	call   4038 <printf>
      kill(ppid);
    3437:	8b 45 d0             	mov    -0x30(%ebp),%eax
    343a:	89 04 24             	mov    %eax,(%esp)
    343d:	e8 a6 0a 00 00       	call   3ee8 <kill>
      exit();
    3442:	e8 71 0a 00 00       	call   3eb8 <exit>
    }
    wait();
    3447:	e8 74 0a 00 00       	call   3ec0 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    344c:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3453:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    345a:	0f 86 78 ff ff ff    	jbe    33d8 <sbrktest+0x2f1>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3460:	8d 45 c8             	lea    -0x38(%ebp),%eax
    3463:	89 04 24             	mov    %eax,(%esp)
    3466:	e8 5d 0a 00 00       	call   3ec8 <pipe>
    346b:	85 c0                	test   %eax,%eax
    346d:	74 19                	je     3488 <sbrktest+0x3a1>
    printf(1, "pipe() failed\n");
    346f:	c7 44 24 04 7a 48 00 	movl   $0x487a,0x4(%esp)
    3476:	00 
    3477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    347e:	e8 b5 0b 00 00       	call   4038 <printf>
    exit();
    3483:	e8 30 0a 00 00       	call   3eb8 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    348f:	e9 87 00 00 00       	jmp    351b <sbrktest+0x434>
    if((pids[i] = fork()) == 0){
    3494:	e8 17 0a 00 00       	call   3eb0 <fork>
    3499:	8b 55 f0             	mov    -0x10(%ebp),%edx
    349c:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    34a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34a3:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34a7:	85 c0                	test   %eax,%eax
    34a9:	75 46                	jne    34f1 <sbrktest+0x40a>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    34ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    34b2:	e8 89 0a 00 00       	call   3f40 <sbrk>
    34b7:	ba 00 00 40 06       	mov    $0x6400000,%edx
    34bc:	29 c2                	sub    %eax,%edx
    34be:	89 d0                	mov    %edx,%eax
    34c0:	89 04 24             	mov    %eax,(%esp)
    34c3:	e8 78 0a 00 00       	call   3f40 <sbrk>
      write(fds[1], "x", 1);
    34c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
    34cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    34d2:	00 
    34d3:	c7 44 24 04 df 48 00 	movl   $0x48df,0x4(%esp)
    34da:	00 
    34db:	89 04 24             	mov    %eax,(%esp)
    34de:	e8 f5 09 00 00       	call   3ed8 <write>
      // sit around until killed
      for(;;) sleep(1000);
    34e3:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    34ea:	e8 59 0a 00 00       	call   3f48 <sleep>
    34ef:	eb f2                	jmp    34e3 <sbrktest+0x3fc>
    }
    if(pids[i] != -1)
    34f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34f4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34f8:	83 f8 ff             	cmp    $0xffffffff,%eax
    34fb:	74 1a                	je     3517 <sbrktest+0x430>
      read(fds[0], &scratch, 1);
    34fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3500:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3507:	00 
    3508:	8d 55 9f             	lea    -0x61(%ebp),%edx
    350b:	89 54 24 04          	mov    %edx,0x4(%esp)
    350f:	89 04 24             	mov    %eax,(%esp)
    3512:	e8 b9 09 00 00       	call   3ed0 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3517:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    351e:	83 f8 09             	cmp    $0x9,%eax
    3521:	0f 86 6d ff ff ff    	jbe    3494 <sbrktest+0x3ad>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    3527:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    352e:	e8 0d 0a 00 00       	call   3f40 <sbrk>
    3533:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3536:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    353d:	eb 26                	jmp    3565 <sbrktest+0x47e>
    if(pids[i] == -1)
    353f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3542:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3546:	83 f8 ff             	cmp    $0xffffffff,%eax
    3549:	75 02                	jne    354d <sbrktest+0x466>
      continue;
    354b:	eb 14                	jmp    3561 <sbrktest+0x47a>
    kill(pids[i]);
    354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3550:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3554:	89 04 24             	mov    %eax,(%esp)
    3557:	e8 8c 09 00 00       	call   3ee8 <kill>
    wait();
    355c:	e8 5f 09 00 00       	call   3ec0 <wait>
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3561:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    3565:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3568:	83 f8 09             	cmp    $0x9,%eax
    356b:	76 d2                	jbe    353f <sbrktest+0x458>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    356d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3571:	75 1a                	jne    358d <sbrktest+0x4a6>
    printf(stdout, "failed sbrk leaked memory\n");
    3573:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3578:	c7 44 24 04 6e 59 00 	movl   $0x596e,0x4(%esp)
    357f:	00 
    3580:	89 04 24             	mov    %eax,(%esp)
    3583:	e8 b0 0a 00 00       	call   4038 <printf>
    exit();
    3588:	e8 2b 09 00 00       	call   3eb8 <exit>
  }

  if(sbrk(0) > oldbrk)
    358d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3594:	e8 a7 09 00 00       	call   3f40 <sbrk>
    3599:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    359c:	76 1b                	jbe    35b9 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    359e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    35a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35a8:	e8 93 09 00 00       	call   3f40 <sbrk>
    35ad:	29 c3                	sub    %eax,%ebx
    35af:	89 d8                	mov    %ebx,%eax
    35b1:	89 04 24             	mov    %eax,(%esp)
    35b4:	e8 87 09 00 00       	call   3f40 <sbrk>

  printf(stdout, "sbrk test OK\n");
    35b9:	a1 c8 62 00 00       	mov    0x62c8,%eax
    35be:	c7 44 24 04 89 59 00 	movl   $0x5989,0x4(%esp)
    35c5:	00 
    35c6:	89 04 24             	mov    %eax,(%esp)
    35c9:	e8 6a 0a 00 00       	call   4038 <printf>
}
    35ce:	81 c4 84 00 00 00    	add    $0x84,%esp
    35d4:	5b                   	pop    %ebx
    35d5:	5d                   	pop    %ebp
    35d6:	c3                   	ret    

000035d7 <validateint>:

void
validateint(int *p)
{
    35d7:	55                   	push   %ebp
    35d8:	89 e5                	mov    %esp,%ebp
    35da:	53                   	push   %ebx
    35db:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    35de:	b8 0d 00 00 00       	mov    $0xd,%eax
    35e3:	8b 55 08             	mov    0x8(%ebp),%edx
    35e6:	89 d1                	mov    %edx,%ecx
    35e8:	89 e3                	mov    %esp,%ebx
    35ea:	89 cc                	mov    %ecx,%esp
    35ec:	cd 40                	int    $0x40
    35ee:	89 dc                	mov    %ebx,%esp
    35f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    35f3:	83 c4 10             	add    $0x10,%esp
    35f6:	5b                   	pop    %ebx
    35f7:	5d                   	pop    %ebp
    35f8:	c3                   	ret    

000035f9 <validatetest>:

void
validatetest(void)
{
    35f9:	55                   	push   %ebp
    35fa:	89 e5                	mov    %esp,%ebp
    35fc:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    35ff:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3604:	c7 44 24 04 97 59 00 	movl   $0x5997,0x4(%esp)
    360b:	00 
    360c:	89 04 24             	mov    %eax,(%esp)
    360f:	e8 24 0a 00 00       	call   4038 <printf>
  hi = 1100*1024;
    3614:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    361b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3622:	eb 7f                	jmp    36a3 <validatetest+0xaa>
    if((pid = fork()) == 0){
    3624:	e8 87 08 00 00       	call   3eb0 <fork>
    3629:	89 45 ec             	mov    %eax,-0x14(%ebp)
    362c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3630:	75 10                	jne    3642 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3632:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3635:	89 04 24             	mov    %eax,(%esp)
    3638:	e8 9a ff ff ff       	call   35d7 <validateint>
      exit();
    363d:	e8 76 08 00 00       	call   3eb8 <exit>
    }
    sleep(0);
    3642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3649:	e8 fa 08 00 00       	call   3f48 <sleep>
    sleep(0);
    364e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3655:	e8 ee 08 00 00       	call   3f48 <sleep>
    kill(pid);
    365a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    365d:	89 04 24             	mov    %eax,(%esp)
    3660:	e8 83 08 00 00       	call   3ee8 <kill>
    wait();
    3665:	e8 56 08 00 00       	call   3ec0 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    366d:	89 44 24 04          	mov    %eax,0x4(%esp)
    3671:	c7 04 24 a6 59 00 00 	movl   $0x59a6,(%esp)
    3678:	e8 9b 08 00 00       	call   3f18 <link>
    367d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3680:	74 1a                	je     369c <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    3682:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3687:	c7 44 24 04 b1 59 00 	movl   $0x59b1,0x4(%esp)
    368e:	00 
    368f:	89 04 24             	mov    %eax,(%esp)
    3692:	e8 a1 09 00 00       	call   4038 <printf>
      exit();
    3697:	e8 1c 08 00 00       	call   3eb8 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    369c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    36a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    36a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    36a9:	0f 83 75 ff ff ff    	jae    3624 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    36af:	a1 c8 62 00 00       	mov    0x62c8,%eax
    36b4:	c7 44 24 04 ca 59 00 	movl   $0x59ca,0x4(%esp)
    36bb:	00 
    36bc:	89 04 24             	mov    %eax,(%esp)
    36bf:	e8 74 09 00 00       	call   4038 <printf>
}
    36c4:	c9                   	leave  
    36c5:	c3                   	ret    

000036c6 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    36c6:	55                   	push   %ebp
    36c7:	89 e5                	mov    %esp,%ebp
    36c9:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    36cc:	a1 c8 62 00 00       	mov    0x62c8,%eax
    36d1:	c7 44 24 04 d7 59 00 	movl   $0x59d7,0x4(%esp)
    36d8:	00 
    36d9:	89 04 24             	mov    %eax,(%esp)
    36dc:	e8 57 09 00 00       	call   4038 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    36e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    36e8:	eb 2d                	jmp    3717 <bsstest+0x51>
    if(uninit[i] != '\0'){
    36ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36ed:	05 a0 63 00 00       	add    $0x63a0,%eax
    36f2:	0f b6 00             	movzbl (%eax),%eax
    36f5:	84 c0                	test   %al,%al
    36f7:	74 1a                	je     3713 <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    36f9:	a1 c8 62 00 00       	mov    0x62c8,%eax
    36fe:	c7 44 24 04 e1 59 00 	movl   $0x59e1,0x4(%esp)
    3705:	00 
    3706:	89 04 24             	mov    %eax,(%esp)
    3709:	e8 2a 09 00 00       	call   4038 <printf>
      exit();
    370e:	e8 a5 07 00 00       	call   3eb8 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    3713:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3717:	8b 45 f4             	mov    -0xc(%ebp),%eax
    371a:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    371f:	76 c9                	jbe    36ea <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3721:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3726:	c7 44 24 04 f2 59 00 	movl   $0x59f2,0x4(%esp)
    372d:	00 
    372e:	89 04 24             	mov    %eax,(%esp)
    3731:	e8 02 09 00 00       	call   4038 <printf>
}
    3736:	c9                   	leave  
    3737:	c3                   	ret    

00003738 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3738:	55                   	push   %ebp
    3739:	89 e5                	mov    %esp,%ebp
    373b:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    373e:	c7 04 24 ff 59 00 00 	movl   $0x59ff,(%esp)
    3745:	e8 be 07 00 00       	call   3f08 <unlink>
  pid = fork();
    374a:	e8 61 07 00 00       	call   3eb0 <fork>
    374f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3752:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3756:	0f 85 90 00 00 00    	jne    37ec <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    375c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3763:	eb 12                	jmp    3777 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3765:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3768:	c7 04 85 00 63 00 00 	movl   $0x5a0c,0x6300(,%eax,4)
    376f:	0c 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3773:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3777:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    377b:	7e e8                	jle    3765 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    377d:	c7 05 7c 63 00 00 00 	movl   $0x0,0x637c
    3784:	00 00 00 
    printf(stdout, "bigarg test\n");
    3787:	a1 c8 62 00 00       	mov    0x62c8,%eax
    378c:	c7 44 24 04 e9 5a 00 	movl   $0x5ae9,0x4(%esp)
    3793:	00 
    3794:	89 04 24             	mov    %eax,(%esp)
    3797:	e8 9c 08 00 00       	call   4038 <printf>
    exec("echo", args);
    379c:	c7 44 24 04 00 63 00 	movl   $0x6300,0x4(%esp)
    37a3:	00 
    37a4:	c7 04 24 08 44 00 00 	movl   $0x4408,(%esp)
    37ab:	e8 40 07 00 00       	call   3ef0 <exec>
    printf(stdout, "bigarg test ok\n");
    37b0:	a1 c8 62 00 00       	mov    0x62c8,%eax
    37b5:	c7 44 24 04 f6 5a 00 	movl   $0x5af6,0x4(%esp)
    37bc:	00 
    37bd:	89 04 24             	mov    %eax,(%esp)
    37c0:	e8 73 08 00 00       	call   4038 <printf>
    fd = open("bigarg-ok", O_CREATE);
    37c5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    37cc:	00 
    37cd:	c7 04 24 ff 59 00 00 	movl   $0x59ff,(%esp)
    37d4:	e8 1f 07 00 00       	call   3ef8 <open>
    37d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    37dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    37df:	89 04 24             	mov    %eax,(%esp)
    37e2:	e8 f9 06 00 00       	call   3ee0 <close>
    exit();
    37e7:	e8 cc 06 00 00       	call   3eb8 <exit>
  } else if(pid < 0){
    37ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    37f0:	79 1a                	jns    380c <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    37f2:	a1 c8 62 00 00       	mov    0x62c8,%eax
    37f7:	c7 44 24 04 06 5b 00 	movl   $0x5b06,0x4(%esp)
    37fe:	00 
    37ff:	89 04 24             	mov    %eax,(%esp)
    3802:	e8 31 08 00 00       	call   4038 <printf>
    exit();
    3807:	e8 ac 06 00 00       	call   3eb8 <exit>
  }
  wait();
    380c:	e8 af 06 00 00       	call   3ec0 <wait>
  fd = open("bigarg-ok", 0);
    3811:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3818:	00 
    3819:	c7 04 24 ff 59 00 00 	movl   $0x59ff,(%esp)
    3820:	e8 d3 06 00 00       	call   3ef8 <open>
    3825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    382c:	79 1a                	jns    3848 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    382e:	a1 c8 62 00 00       	mov    0x62c8,%eax
    3833:	c7 44 24 04 1f 5b 00 	movl   $0x5b1f,0x4(%esp)
    383a:	00 
    383b:	89 04 24             	mov    %eax,(%esp)
    383e:	e8 f5 07 00 00       	call   4038 <printf>
    exit();
    3843:	e8 70 06 00 00       	call   3eb8 <exit>
  }
  close(fd);
    3848:	8b 45 ec             	mov    -0x14(%ebp),%eax
    384b:	89 04 24             	mov    %eax,(%esp)
    384e:	e8 8d 06 00 00       	call   3ee0 <close>
  unlink("bigarg-ok");
    3853:	c7 04 24 ff 59 00 00 	movl   $0x59ff,(%esp)
    385a:	e8 a9 06 00 00       	call   3f08 <unlink>
}
    385f:	c9                   	leave  
    3860:	c3                   	ret    

00003861 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3861:	55                   	push   %ebp
    3862:	89 e5                	mov    %esp,%ebp
    3864:	53                   	push   %ebx
    3865:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3868:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    386f:	c7 44 24 04 34 5b 00 	movl   $0x5b34,0x4(%esp)
    3876:	00 
    3877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    387e:	e8 b5 07 00 00       	call   4038 <printf>

  for(nfiles = 0; ; nfiles++){
    3883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    388a:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    388e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3891:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3896:	89 c8                	mov    %ecx,%eax
    3898:	f7 ea                	imul   %edx
    389a:	c1 fa 06             	sar    $0x6,%edx
    389d:	89 c8                	mov    %ecx,%eax
    389f:	c1 f8 1f             	sar    $0x1f,%eax
    38a2:	29 c2                	sub    %eax,%edx
    38a4:	89 d0                	mov    %edx,%eax
    38a6:	83 c0 30             	add    $0x30,%eax
    38a9:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    38ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38af:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    38b4:	89 d8                	mov    %ebx,%eax
    38b6:	f7 ea                	imul   %edx
    38b8:	c1 fa 06             	sar    $0x6,%edx
    38bb:	89 d8                	mov    %ebx,%eax
    38bd:	c1 f8 1f             	sar    $0x1f,%eax
    38c0:	89 d1                	mov    %edx,%ecx
    38c2:	29 c1                	sub    %eax,%ecx
    38c4:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    38ca:	29 c3                	sub    %eax,%ebx
    38cc:	89 d9                	mov    %ebx,%ecx
    38ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38d3:	89 c8                	mov    %ecx,%eax
    38d5:	f7 ea                	imul   %edx
    38d7:	c1 fa 05             	sar    $0x5,%edx
    38da:	89 c8                	mov    %ecx,%eax
    38dc:	c1 f8 1f             	sar    $0x1f,%eax
    38df:	29 c2                	sub    %eax,%edx
    38e1:	89 d0                	mov    %edx,%eax
    38e3:	83 c0 30             	add    $0x30,%eax
    38e6:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    38e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    38ec:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    38f1:	89 d8                	mov    %ebx,%eax
    38f3:	f7 ea                	imul   %edx
    38f5:	c1 fa 05             	sar    $0x5,%edx
    38f8:	89 d8                	mov    %ebx,%eax
    38fa:	c1 f8 1f             	sar    $0x1f,%eax
    38fd:	89 d1                	mov    %edx,%ecx
    38ff:	29 c1                	sub    %eax,%ecx
    3901:	6b c1 64             	imul   $0x64,%ecx,%eax
    3904:	29 c3                	sub    %eax,%ebx
    3906:	89 d9                	mov    %ebx,%ecx
    3908:	ba 67 66 66 66       	mov    $0x66666667,%edx
    390d:	89 c8                	mov    %ecx,%eax
    390f:	f7 ea                	imul   %edx
    3911:	c1 fa 02             	sar    $0x2,%edx
    3914:	89 c8                	mov    %ecx,%eax
    3916:	c1 f8 1f             	sar    $0x1f,%eax
    3919:	29 c2                	sub    %eax,%edx
    391b:	89 d0                	mov    %edx,%eax
    391d:	83 c0 30             	add    $0x30,%eax
    3920:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3923:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3926:	ba 67 66 66 66       	mov    $0x66666667,%edx
    392b:	89 c8                	mov    %ecx,%eax
    392d:	f7 ea                	imul   %edx
    392f:	c1 fa 02             	sar    $0x2,%edx
    3932:	89 c8                	mov    %ecx,%eax
    3934:	c1 f8 1f             	sar    $0x1f,%eax
    3937:	29 c2                	sub    %eax,%edx
    3939:	89 d0                	mov    %edx,%eax
    393b:	c1 e0 02             	shl    $0x2,%eax
    393e:	01 d0                	add    %edx,%eax
    3940:	01 c0                	add    %eax,%eax
    3942:	29 c1                	sub    %eax,%ecx
    3944:	89 ca                	mov    %ecx,%edx
    3946:	89 d0                	mov    %edx,%eax
    3948:	83 c0 30             	add    $0x30,%eax
    394b:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    394e:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3952:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3955:	89 44 24 08          	mov    %eax,0x8(%esp)
    3959:	c7 44 24 04 41 5b 00 	movl   $0x5b41,0x4(%esp)
    3960:	00 
    3961:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3968:	e8 cb 06 00 00       	call   4038 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    396d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3974:	00 
    3975:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3978:	89 04 24             	mov    %eax,(%esp)
    397b:	e8 78 05 00 00       	call   3ef8 <open>
    3980:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3983:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3987:	79 1d                	jns    39a6 <fsfull+0x145>
      printf(1, "open %s failed\n", name);
    3989:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    398c:	89 44 24 08          	mov    %eax,0x8(%esp)
    3990:	c7 44 24 04 4d 5b 00 	movl   $0x5b4d,0x4(%esp)
    3997:	00 
    3998:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    399f:	e8 94 06 00 00       	call   4038 <printf>
      break;
    39a4:	eb 74                	jmp    3a1a <fsfull+0x1b9>
    }
    int total = 0;
    39a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    39ad:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    39b4:	00 
    39b5:	c7 44 24 04 c0 8a 00 	movl   $0x8ac0,0x4(%esp)
    39bc:	00 
    39bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39c0:	89 04 24             	mov    %eax,(%esp)
    39c3:	e8 10 05 00 00       	call   3ed8 <write>
    39c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    39cb:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    39d2:	7f 2f                	jg     3a03 <fsfull+0x1a2>
        break;
    39d4:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    39d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    39d8:	89 44 24 08          	mov    %eax,0x8(%esp)
    39dc:	c7 44 24 04 5d 5b 00 	movl   $0x5b5d,0x4(%esp)
    39e3:	00 
    39e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39eb:	e8 48 06 00 00       	call   4038 <printf>
    close(fd);
    39f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39f3:	89 04 24             	mov    %eax,(%esp)
    39f6:	e8 e5 04 00 00       	call   3ee0 <close>
    if(total == 0)
    39fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    39ff:	75 10                	jne    3a11 <fsfull+0x1b0>
    3a01:	eb 0c                	jmp    3a0f <fsfull+0x1ae>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a06:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3a09:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    3a0d:	eb 9e                	jmp    39ad <fsfull+0x14c>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3a0f:	eb 09                	jmp    3a1a <fsfull+0x1b9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3a11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3a15:	e9 70 fe ff ff       	jmp    388a <fsfull+0x29>

  while(nfiles >= 0){
    3a1a:	e9 d7 00 00 00       	jmp    3af6 <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    3a1f:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a23:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a26:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a2b:	89 c8                	mov    %ecx,%eax
    3a2d:	f7 ea                	imul   %edx
    3a2f:	c1 fa 06             	sar    $0x6,%edx
    3a32:	89 c8                	mov    %ecx,%eax
    3a34:	c1 f8 1f             	sar    $0x1f,%eax
    3a37:	29 c2                	sub    %eax,%edx
    3a39:	89 d0                	mov    %edx,%eax
    3a3b:	83 c0 30             	add    $0x30,%eax
    3a3e:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a44:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3a49:	89 d8                	mov    %ebx,%eax
    3a4b:	f7 ea                	imul   %edx
    3a4d:	c1 fa 06             	sar    $0x6,%edx
    3a50:	89 d8                	mov    %ebx,%eax
    3a52:	c1 f8 1f             	sar    $0x1f,%eax
    3a55:	89 d1                	mov    %edx,%ecx
    3a57:	29 c1                	sub    %eax,%ecx
    3a59:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    3a5f:	29 c3                	sub    %eax,%ebx
    3a61:	89 d9                	mov    %ebx,%ecx
    3a63:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a68:	89 c8                	mov    %ecx,%eax
    3a6a:	f7 ea                	imul   %edx
    3a6c:	c1 fa 05             	sar    $0x5,%edx
    3a6f:	89 c8                	mov    %ecx,%eax
    3a71:	c1 f8 1f             	sar    $0x1f,%eax
    3a74:	29 c2                	sub    %eax,%edx
    3a76:	89 d0                	mov    %edx,%eax
    3a78:	83 c0 30             	add    $0x30,%eax
    3a7b:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a81:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    3a86:	89 d8                	mov    %ebx,%eax
    3a88:	f7 ea                	imul   %edx
    3a8a:	c1 fa 05             	sar    $0x5,%edx
    3a8d:	89 d8                	mov    %ebx,%eax
    3a8f:	c1 f8 1f             	sar    $0x1f,%eax
    3a92:	89 d1                	mov    %edx,%ecx
    3a94:	29 c1                	sub    %eax,%ecx
    3a96:	6b c1 64             	imul   $0x64,%ecx,%eax
    3a99:	29 c3                	sub    %eax,%ebx
    3a9b:	89 d9                	mov    %ebx,%ecx
    3a9d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aa2:	89 c8                	mov    %ecx,%eax
    3aa4:	f7 ea                	imul   %edx
    3aa6:	c1 fa 02             	sar    $0x2,%edx
    3aa9:	89 c8                	mov    %ecx,%eax
    3aab:	c1 f8 1f             	sar    $0x1f,%eax
    3aae:	29 c2                	sub    %eax,%edx
    3ab0:	89 d0                	mov    %edx,%eax
    3ab2:	83 c0 30             	add    $0x30,%eax
    3ab5:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3ab8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3abb:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3ac0:	89 c8                	mov    %ecx,%eax
    3ac2:	f7 ea                	imul   %edx
    3ac4:	c1 fa 02             	sar    $0x2,%edx
    3ac7:	89 c8                	mov    %ecx,%eax
    3ac9:	c1 f8 1f             	sar    $0x1f,%eax
    3acc:	29 c2                	sub    %eax,%edx
    3ace:	89 d0                	mov    %edx,%eax
    3ad0:	c1 e0 02             	shl    $0x2,%eax
    3ad3:	01 d0                	add    %edx,%eax
    3ad5:	01 c0                	add    %eax,%eax
    3ad7:	29 c1                	sub    %eax,%ecx
    3ad9:	89 ca                	mov    %ecx,%edx
    3adb:	89 d0                	mov    %edx,%eax
    3add:	83 c0 30             	add    $0x30,%eax
    3ae0:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3ae3:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3ae7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3aea:	89 04 24             	mov    %eax,(%esp)
    3aed:	e8 16 04 00 00       	call   3f08 <unlink>
    nfiles--;
    3af2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3afa:	0f 89 1f ff ff ff    	jns    3a1f <fsfull+0x1be>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3b00:	c7 44 24 04 6d 5b 00 	movl   $0x5b6d,0x4(%esp)
    3b07:	00 
    3b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b0f:	e8 24 05 00 00       	call   4038 <printf>
}
    3b14:	83 c4 74             	add    $0x74,%esp
    3b17:	5b                   	pop    %ebx
    3b18:	5d                   	pop    %ebp
    3b19:	c3                   	ret    

00003b1a <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3b1a:	55                   	push   %ebp
    3b1b:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3b1d:	a1 cc 62 00 00       	mov    0x62cc,%eax
    3b22:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    3b28:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b2d:	a3 cc 62 00 00       	mov    %eax,0x62cc
  return randstate;
    3b32:	a1 cc 62 00 00       	mov    0x62cc,%eax
}
    3b37:	5d                   	pop    %ebp
    3b38:	c3                   	ret    

00003b39 <main>:

int
main(int argc, char *argv[])
{
    3b39:	55                   	push   %ebp
    3b3a:	89 e5                	mov    %esp,%ebp
    3b3c:	83 e4 f0             	and    $0xfffffff0,%esp
    3b3f:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b42:	c7 44 24 04 83 5b 00 	movl   $0x5b83,0x4(%esp)
    3b49:	00 
    3b4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b51:	e8 e2 04 00 00       	call   4038 <printf>

  if(open("usertests.ran", 0) >= 0){
    3b56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b5d:	00 
    3b5e:	c7 04 24 97 5b 00 00 	movl   $0x5b97,(%esp)
    3b65:	e8 8e 03 00 00       	call   3ef8 <open>
    3b6a:	85 c0                	test   %eax,%eax
    3b6c:	78 19                	js     3b87 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b6e:	c7 44 24 04 a8 5b 00 	movl   $0x5ba8,0x4(%esp)
    3b75:	00 
    3b76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b7d:	e8 b6 04 00 00       	call   4038 <printf>
    exit();
    3b82:	e8 31 03 00 00       	call   3eb8 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b87:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3b8e:	00 
    3b8f:	c7 04 24 97 5b 00 00 	movl   $0x5b97,(%esp)
    3b96:	e8 5d 03 00 00       	call   3ef8 <open>
    3b9b:	89 04 24             	mov    %eax,(%esp)
    3b9e:	e8 3d 03 00 00       	call   3ee0 <close>

  createdelete();
    3ba3:	e8 da d6 ff ff       	call   1282 <createdelete>
  linkunlink();
    3ba8:	e8 1e e1 ff ff       	call   1ccb <linkunlink>
  concreate();
    3bad:	e8 66 dd ff ff       	call   1918 <concreate>
  fourfiles();
    3bb2:	e8 63 d4 ff ff       	call   101a <fourfiles>
  sharedfd();
    3bb7:	e8 60 d2 ff ff       	call   e1c <sharedfd>

  bigargtest();
    3bbc:	e8 77 fb ff ff       	call   3738 <bigargtest>
  bigwrite();
    3bc1:	e8 e6 ea ff ff       	call   26ac <bigwrite>
  bigargtest();
    3bc6:	e8 6d fb ff ff       	call   3738 <bigargtest>
  bsstest();
    3bcb:	e8 f6 fa ff ff       	call   36c6 <bsstest>
  sbrktest();
    3bd0:	e8 12 f5 ff ff       	call   30e7 <sbrktest>
  validatetest();
    3bd5:	e8 1f fa ff ff       	call   35f9 <validatetest>

  opentest();
    3bda:	e8 e8 c6 ff ff       	call   2c7 <opentest>
  writetest();
    3bdf:	e8 8e c7 ff ff       	call   372 <writetest>
  writetest1();
    3be4:	e8 9e c9 ff ff       	call   587 <writetest1>
  createtest();
    3be9:	e8 a4 cb ff ff       	call   792 <createtest>

  openiputtest();
    3bee:	e8 d3 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3bf3:	e8 e2 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3bf8:	e8 03 c4 ff ff       	call   0 <iputtest>

  mem();
    3bfd:	e8 35 d1 ff ff       	call   d37 <mem>
  pipe1();
    3c02:	e8 6c cd ff ff       	call   973 <pipe1>
  preempt();
    3c07:	e8 54 cf ff ff       	call   b60 <preempt>
  exitwait();
    3c0c:	e8 a8 d0 ff ff       	call   cb9 <exitwait>

  rmdot();
    3c11:	e8 1f ef ff ff       	call   2b35 <rmdot>
  fourteen();
    3c16:	e8 c4 ed ff ff       	call   29df <fourteen>
  bigfile();
    3c1b:	e8 94 eb ff ff       	call   27b4 <bigfile>
  subdir();
    3c20:	e8 41 e3 ff ff       	call   1f66 <subdir>
  linktest();
    3c25:	e8 a5 da ff ff       	call   16cf <linktest>
  unlinkread();
    3c2a:	e8 cb d8 ff ff       	call   14fa <unlinkread>
  dirfile();
    3c2f:	e8 79 f0 ff ff       	call   2cad <dirfile>
  iref();
    3c34:	e8 b6 f2 ff ff       	call   2eef <iref>
  forktest();
    3c39:	e8 d5 f3 ff ff       	call   3013 <forktest>
  bigdir(); // slow
    3c3e:	e8 b6 e1 ff ff       	call   1df9 <bigdir>
  exectest();
    3c43:	e8 dc cc ff ff       	call   924 <exectest>

  exit();
    3c48:	e8 6b 02 00 00       	call   3eb8 <exit>
    3c4d:	66 90                	xchg   %ax,%ax
    3c4f:	90                   	nop

00003c50 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c50:	55                   	push   %ebp
    3c51:	89 e5                	mov    %esp,%ebp
    3c53:	57                   	push   %edi
    3c54:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c58:	8b 55 10             	mov    0x10(%ebp),%edx
    3c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c5e:	89 cb                	mov    %ecx,%ebx
    3c60:	89 df                	mov    %ebx,%edi
    3c62:	89 d1                	mov    %edx,%ecx
    3c64:	fc                   	cld    
    3c65:	f3 aa                	rep stos %al,%es:(%edi)
    3c67:	89 ca                	mov    %ecx,%edx
    3c69:	89 fb                	mov    %edi,%ebx
    3c6b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c6e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c71:	5b                   	pop    %ebx
    3c72:	5f                   	pop    %edi
    3c73:	5d                   	pop    %ebp
    3c74:	c3                   	ret    

00003c75 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3c75:	55                   	push   %ebp
    3c76:	89 e5                	mov    %esp,%ebp
    3c78:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c7b:	8b 45 08             	mov    0x8(%ebp),%eax
    3c7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c81:	90                   	nop
    3c82:	8b 45 08             	mov    0x8(%ebp),%eax
    3c85:	8d 50 01             	lea    0x1(%eax),%edx
    3c88:	89 55 08             	mov    %edx,0x8(%ebp)
    3c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
    3c8e:	8d 4a 01             	lea    0x1(%edx),%ecx
    3c91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    3c94:	0f b6 12             	movzbl (%edx),%edx
    3c97:	88 10                	mov    %dl,(%eax)
    3c99:	0f b6 00             	movzbl (%eax),%eax
    3c9c:	84 c0                	test   %al,%al
    3c9e:	75 e2                	jne    3c82 <strcpy+0xd>
    ;
  return os;
    3ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3ca3:	c9                   	leave  
    3ca4:	c3                   	ret    

00003ca5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3ca5:	55                   	push   %ebp
    3ca6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3ca8:	eb 08                	jmp    3cb2 <strcmp+0xd>
    p++, q++;
    3caa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3cae:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cb2:	8b 45 08             	mov    0x8(%ebp),%eax
    3cb5:	0f b6 00             	movzbl (%eax),%eax
    3cb8:	84 c0                	test   %al,%al
    3cba:	74 10                	je     3ccc <strcmp+0x27>
    3cbc:	8b 45 08             	mov    0x8(%ebp),%eax
    3cbf:	0f b6 10             	movzbl (%eax),%edx
    3cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cc5:	0f b6 00             	movzbl (%eax),%eax
    3cc8:	38 c2                	cmp    %al,%dl
    3cca:	74 de                	je     3caa <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3ccc:	8b 45 08             	mov    0x8(%ebp),%eax
    3ccf:	0f b6 00             	movzbl (%eax),%eax
    3cd2:	0f b6 d0             	movzbl %al,%edx
    3cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cd8:	0f b6 00             	movzbl (%eax),%eax
    3cdb:	0f b6 c0             	movzbl %al,%eax
    3cde:	29 c2                	sub    %eax,%edx
    3ce0:	89 d0                	mov    %edx,%eax
}
    3ce2:	5d                   	pop    %ebp
    3ce3:	c3                   	ret    

00003ce4 <strlen>:

uint
strlen(char *s)
{
    3ce4:	55                   	push   %ebp
    3ce5:	89 e5                	mov    %esp,%ebp
    3ce7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3cf1:	eb 04                	jmp    3cf7 <strlen+0x13>
    3cf3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    3cf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3cfa:	8b 45 08             	mov    0x8(%ebp),%eax
    3cfd:	01 d0                	add    %edx,%eax
    3cff:	0f b6 00             	movzbl (%eax),%eax
    3d02:	84 c0                	test   %al,%al
    3d04:	75 ed                	jne    3cf3 <strlen+0xf>
    ;
  return n;
    3d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d09:	c9                   	leave  
    3d0a:	c3                   	ret    

00003d0b <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d0b:	55                   	push   %ebp
    3d0c:	89 e5                	mov    %esp,%ebp
    3d0e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d11:	8b 45 10             	mov    0x10(%ebp),%eax
    3d14:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d18:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3d22:	89 04 24             	mov    %eax,(%esp)
    3d25:	e8 26 ff ff ff       	call   3c50 <stosb>
  return dst;
    3d2a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d2d:	c9                   	leave  
    3d2e:	c3                   	ret    

00003d2f <strchr>:

char*
strchr(const char *s, char c)
{
    3d2f:	55                   	push   %ebp
    3d30:	89 e5                	mov    %esp,%ebp
    3d32:	83 ec 04             	sub    $0x4,%esp
    3d35:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d38:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d3b:	eb 14                	jmp    3d51 <strchr+0x22>
    if(*s == c)
    3d3d:	8b 45 08             	mov    0x8(%ebp),%eax
    3d40:	0f b6 00             	movzbl (%eax),%eax
    3d43:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d46:	75 05                	jne    3d4d <strchr+0x1e>
      return (char*)s;
    3d48:	8b 45 08             	mov    0x8(%ebp),%eax
    3d4b:	eb 13                	jmp    3d60 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    3d51:	8b 45 08             	mov    0x8(%ebp),%eax
    3d54:	0f b6 00             	movzbl (%eax),%eax
    3d57:	84 c0                	test   %al,%al
    3d59:	75 e2                	jne    3d3d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d60:	c9                   	leave  
    3d61:	c3                   	ret    

00003d62 <gets>:

char*
gets(char *buf, int max)
{
    3d62:	55                   	push   %ebp
    3d63:	89 e5                	mov    %esp,%ebp
    3d65:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d6f:	eb 4c                	jmp    3dbd <gets+0x5b>
    cc = read(0, &c, 1);
    3d71:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3d78:	00 
    3d79:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3d87:	e8 44 01 00 00       	call   3ed0 <read>
    3d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3d8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d93:	7f 02                	jg     3d97 <gets+0x35>
      break;
    3d95:	eb 31                	jmp    3dc8 <gets+0x66>
    buf[i++] = c;
    3d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d9a:	8d 50 01             	lea    0x1(%eax),%edx
    3d9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    3da0:	89 c2                	mov    %eax,%edx
    3da2:	8b 45 08             	mov    0x8(%ebp),%eax
    3da5:	01 c2                	add    %eax,%edx
    3da7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3dab:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    3dad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3db1:	3c 0a                	cmp    $0xa,%al
    3db3:	74 13                	je     3dc8 <gets+0x66>
    3db5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    3db9:	3c 0d                	cmp    $0xd,%al
    3dbb:	74 0b                	je     3dc8 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dc0:	83 c0 01             	add    $0x1,%eax
    3dc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dc6:	7c a9                	jl     3d71 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3dcb:	8b 45 08             	mov    0x8(%ebp),%eax
    3dce:	01 d0                	add    %edx,%eax
    3dd0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dd6:	c9                   	leave  
    3dd7:	c3                   	ret    

00003dd8 <stat>:

int
stat(char *n, struct stat *st)
{
    3dd8:	55                   	push   %ebp
    3dd9:	89 e5                	mov    %esp,%ebp
    3ddb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3dde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3de5:	00 
    3de6:	8b 45 08             	mov    0x8(%ebp),%eax
    3de9:	89 04 24             	mov    %eax,(%esp)
    3dec:	e8 07 01 00 00       	call   3ef8 <open>
    3df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3df8:	79 07                	jns    3e01 <stat+0x29>
    return -1;
    3dfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3dff:	eb 23                	jmp    3e24 <stat+0x4c>
  r = fstat(fd, st);
    3e01:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e04:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e0b:	89 04 24             	mov    %eax,(%esp)
    3e0e:	e8 fd 00 00 00       	call   3f10 <fstat>
    3e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e19:	89 04 24             	mov    %eax,(%esp)
    3e1c:	e8 bf 00 00 00       	call   3ee0 <close>
  return r;
    3e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e24:	c9                   	leave  
    3e25:	c3                   	ret    

00003e26 <atoi>:

int
atoi(const char *s)
{
    3e26:	55                   	push   %ebp
    3e27:	89 e5                	mov    %esp,%ebp
    3e29:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e33:	eb 25                	jmp    3e5a <atoi+0x34>
    n = n*10 + *s++ - '0';
    3e35:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e38:	89 d0                	mov    %edx,%eax
    3e3a:	c1 e0 02             	shl    $0x2,%eax
    3e3d:	01 d0                	add    %edx,%eax
    3e3f:	01 c0                	add    %eax,%eax
    3e41:	89 c1                	mov    %eax,%ecx
    3e43:	8b 45 08             	mov    0x8(%ebp),%eax
    3e46:	8d 50 01             	lea    0x1(%eax),%edx
    3e49:	89 55 08             	mov    %edx,0x8(%ebp)
    3e4c:	0f b6 00             	movzbl (%eax),%eax
    3e4f:	0f be c0             	movsbl %al,%eax
    3e52:	01 c8                	add    %ecx,%eax
    3e54:	83 e8 30             	sub    $0x30,%eax
    3e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e5a:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5d:	0f b6 00             	movzbl (%eax),%eax
    3e60:	3c 2f                	cmp    $0x2f,%al
    3e62:	7e 0a                	jle    3e6e <atoi+0x48>
    3e64:	8b 45 08             	mov    0x8(%ebp),%eax
    3e67:	0f b6 00             	movzbl (%eax),%eax
    3e6a:	3c 39                	cmp    $0x39,%al
    3e6c:	7e c7                	jle    3e35 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e71:	c9                   	leave  
    3e72:	c3                   	ret    

00003e73 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e73:	55                   	push   %ebp
    3e74:	89 e5                	mov    %esp,%ebp
    3e76:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e79:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e82:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e85:	eb 17                	jmp    3e9e <memmove+0x2b>
    *dst++ = *src++;
    3e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e8a:	8d 50 01             	lea    0x1(%eax),%edx
    3e8d:	89 55 fc             	mov    %edx,-0x4(%ebp)
    3e90:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3e93:	8d 4a 01             	lea    0x1(%edx),%ecx
    3e96:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    3e99:	0f b6 12             	movzbl (%edx),%edx
    3e9c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e9e:	8b 45 10             	mov    0x10(%ebp),%eax
    3ea1:	8d 50 ff             	lea    -0x1(%eax),%edx
    3ea4:	89 55 10             	mov    %edx,0x10(%ebp)
    3ea7:	85 c0                	test   %eax,%eax
    3ea9:	7f dc                	jg     3e87 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3eae:	c9                   	leave  
    3eaf:	c3                   	ret    

00003eb0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3eb0:	b8 01 00 00 00       	mov    $0x1,%eax
    3eb5:	cd 40                	int    $0x40
    3eb7:	c3                   	ret    

00003eb8 <exit>:
SYSCALL(exit)
    3eb8:	b8 02 00 00 00       	mov    $0x2,%eax
    3ebd:	cd 40                	int    $0x40
    3ebf:	c3                   	ret    

00003ec0 <wait>:
SYSCALL(wait)
    3ec0:	b8 03 00 00 00       	mov    $0x3,%eax
    3ec5:	cd 40                	int    $0x40
    3ec7:	c3                   	ret    

00003ec8 <pipe>:
SYSCALL(pipe)
    3ec8:	b8 04 00 00 00       	mov    $0x4,%eax
    3ecd:	cd 40                	int    $0x40
    3ecf:	c3                   	ret    

00003ed0 <read>:
SYSCALL(read)
    3ed0:	b8 05 00 00 00       	mov    $0x5,%eax
    3ed5:	cd 40                	int    $0x40
    3ed7:	c3                   	ret    

00003ed8 <write>:
SYSCALL(write)
    3ed8:	b8 10 00 00 00       	mov    $0x10,%eax
    3edd:	cd 40                	int    $0x40
    3edf:	c3                   	ret    

00003ee0 <close>:
SYSCALL(close)
    3ee0:	b8 15 00 00 00       	mov    $0x15,%eax
    3ee5:	cd 40                	int    $0x40
    3ee7:	c3                   	ret    

00003ee8 <kill>:
SYSCALL(kill)
    3ee8:	b8 06 00 00 00       	mov    $0x6,%eax
    3eed:	cd 40                	int    $0x40
    3eef:	c3                   	ret    

00003ef0 <exec>:
SYSCALL(exec)
    3ef0:	b8 07 00 00 00       	mov    $0x7,%eax
    3ef5:	cd 40                	int    $0x40
    3ef7:	c3                   	ret    

00003ef8 <open>:
SYSCALL(open)
    3ef8:	b8 0f 00 00 00       	mov    $0xf,%eax
    3efd:	cd 40                	int    $0x40
    3eff:	c3                   	ret    

00003f00 <mknod>:
SYSCALL(mknod)
    3f00:	b8 11 00 00 00       	mov    $0x11,%eax
    3f05:	cd 40                	int    $0x40
    3f07:	c3                   	ret    

00003f08 <unlink>:
SYSCALL(unlink)
    3f08:	b8 12 00 00 00       	mov    $0x12,%eax
    3f0d:	cd 40                	int    $0x40
    3f0f:	c3                   	ret    

00003f10 <fstat>:
SYSCALL(fstat)
    3f10:	b8 08 00 00 00       	mov    $0x8,%eax
    3f15:	cd 40                	int    $0x40
    3f17:	c3                   	ret    

00003f18 <link>:
SYSCALL(link)
    3f18:	b8 13 00 00 00       	mov    $0x13,%eax
    3f1d:	cd 40                	int    $0x40
    3f1f:	c3                   	ret    

00003f20 <mkdir>:
SYSCALL(mkdir)
    3f20:	b8 14 00 00 00       	mov    $0x14,%eax
    3f25:	cd 40                	int    $0x40
    3f27:	c3                   	ret    

00003f28 <chdir>:
SYSCALL(chdir)
    3f28:	b8 09 00 00 00       	mov    $0x9,%eax
    3f2d:	cd 40                	int    $0x40
    3f2f:	c3                   	ret    

00003f30 <dup>:
SYSCALL(dup)
    3f30:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f35:	cd 40                	int    $0x40
    3f37:	c3                   	ret    

00003f38 <getpid>:
SYSCALL(getpid)
    3f38:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f3d:	cd 40                	int    $0x40
    3f3f:	c3                   	ret    

00003f40 <sbrk>:
SYSCALL(sbrk)
    3f40:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f45:	cd 40                	int    $0x40
    3f47:	c3                   	ret    

00003f48 <sleep>:
SYSCALL(sleep)
    3f48:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f4d:	cd 40                	int    $0x40
    3f4f:	c3                   	ret    

00003f50 <uptime>:
SYSCALL(uptime)
    3f50:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f55:	cd 40                	int    $0x40
    3f57:	c3                   	ret    

00003f58 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f58:	55                   	push   %ebp
    3f59:	89 e5                	mov    %esp,%ebp
    3f5b:	83 ec 18             	sub    $0x18,%esp
    3f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f61:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f64:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3f6b:	00 
    3f6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3f6f:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f73:	8b 45 08             	mov    0x8(%ebp),%eax
    3f76:	89 04 24             	mov    %eax,(%esp)
    3f79:	e8 5a ff ff ff       	call   3ed8 <write>
}
    3f7e:	c9                   	leave  
    3f7f:	c3                   	ret    

00003f80 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3f80:	55                   	push   %ebp
    3f81:	89 e5                	mov    %esp,%ebp
    3f83:	56                   	push   %esi
    3f84:	53                   	push   %ebx
    3f85:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3f88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3f8f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3f93:	74 17                	je     3fac <printint+0x2c>
    3f95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3f99:	79 11                	jns    3fac <printint+0x2c>
    neg = 1;
    3f9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fa5:	f7 d8                	neg    %eax
    3fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3faa:	eb 06                	jmp    3fb2 <printint+0x32>
  } else {
    x = xx;
    3fac:	8b 45 0c             	mov    0xc(%ebp),%eax
    3faf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fb9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3fbc:	8d 41 01             	lea    0x1(%ecx),%eax
    3fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    3fc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fc8:	ba 00 00 00 00       	mov    $0x0,%edx
    3fcd:	f7 f3                	div    %ebx
    3fcf:	89 d0                	mov    %edx,%eax
    3fd1:	0f b6 80 d0 62 00 00 	movzbl 0x62d0(%eax),%eax
    3fd8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    3fdc:	8b 75 10             	mov    0x10(%ebp),%esi
    3fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3fe2:	ba 00 00 00 00       	mov    $0x0,%edx
    3fe7:	f7 f6                	div    %esi
    3fe9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3ff0:	75 c7                	jne    3fb9 <printint+0x39>
  if(neg)
    3ff2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3ff6:	74 10                	je     4008 <printint+0x88>
    buf[i++] = '-';
    3ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ffb:	8d 50 01             	lea    0x1(%eax),%edx
    3ffe:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4001:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4006:	eb 1f                	jmp    4027 <printint+0xa7>
    4008:	eb 1d                	jmp    4027 <printint+0xa7>
    putc(fd, buf[i]);
    400a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4010:	01 d0                	add    %edx,%eax
    4012:	0f b6 00             	movzbl (%eax),%eax
    4015:	0f be c0             	movsbl %al,%eax
    4018:	89 44 24 04          	mov    %eax,0x4(%esp)
    401c:	8b 45 08             	mov    0x8(%ebp),%eax
    401f:	89 04 24             	mov    %eax,(%esp)
    4022:	e8 31 ff ff ff       	call   3f58 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4027:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    402b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    402f:	79 d9                	jns    400a <printint+0x8a>
    putc(fd, buf[i]);
}
    4031:	83 c4 30             	add    $0x30,%esp
    4034:	5b                   	pop    %ebx
    4035:	5e                   	pop    %esi
    4036:	5d                   	pop    %ebp
    4037:	c3                   	ret    

00004038 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4038:	55                   	push   %ebp
    4039:	89 e5                	mov    %esp,%ebp
    403b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    403e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4045:	8d 45 0c             	lea    0xc(%ebp),%eax
    4048:	83 c0 04             	add    $0x4,%eax
    404b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    404e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4055:	e9 7c 01 00 00       	jmp    41d6 <printf+0x19e>
    c = fmt[i] & 0xff;
    405a:	8b 55 0c             	mov    0xc(%ebp),%edx
    405d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4060:	01 d0                	add    %edx,%eax
    4062:	0f b6 00             	movzbl (%eax),%eax
    4065:	0f be c0             	movsbl %al,%eax
    4068:	25 ff 00 00 00       	and    $0xff,%eax
    406d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    4070:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4074:	75 2c                	jne    40a2 <printf+0x6a>
      if(c == '%'){
    4076:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    407a:	75 0c                	jne    4088 <printf+0x50>
        state = '%';
    407c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    4083:	e9 4a 01 00 00       	jmp    41d2 <printf+0x19a>
      } else {
        putc(fd, c);
    4088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    408b:	0f be c0             	movsbl %al,%eax
    408e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4092:	8b 45 08             	mov    0x8(%ebp),%eax
    4095:	89 04 24             	mov    %eax,(%esp)
    4098:	e8 bb fe ff ff       	call   3f58 <putc>
    409d:	e9 30 01 00 00       	jmp    41d2 <printf+0x19a>
      }
    } else if(state == '%'){
    40a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40a6:	0f 85 26 01 00 00    	jne    41d2 <printf+0x19a>
      if(c == 'd'){
    40ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40b0:	75 2d                	jne    40df <printf+0xa7>
        printint(fd, *ap, 10, 1);
    40b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40b5:	8b 00                	mov    (%eax),%eax
    40b7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40be:	00 
    40bf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    40c6:	00 
    40c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    40cb:	8b 45 08             	mov    0x8(%ebp),%eax
    40ce:	89 04 24             	mov    %eax,(%esp)
    40d1:	e8 aa fe ff ff       	call   3f80 <printint>
        ap++;
    40d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    40da:	e9 ec 00 00 00       	jmp    41cb <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    40df:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    40e3:	74 06                	je     40eb <printf+0xb3>
    40e5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    40e9:	75 2d                	jne    4118 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    40eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40ee:	8b 00                	mov    (%eax),%eax
    40f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    40f7:	00 
    40f8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    40ff:	00 
    4100:	89 44 24 04          	mov    %eax,0x4(%esp)
    4104:	8b 45 08             	mov    0x8(%ebp),%eax
    4107:	89 04 24             	mov    %eax,(%esp)
    410a:	e8 71 fe ff ff       	call   3f80 <printint>
        ap++;
    410f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4113:	e9 b3 00 00 00       	jmp    41cb <printf+0x193>
      } else if(c == 's'){
    4118:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    411c:	75 45                	jne    4163 <printf+0x12b>
        s = (char*)*ap;
    411e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4121:	8b 00                	mov    (%eax),%eax
    4123:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4126:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    412a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    412e:	75 09                	jne    4139 <printf+0x101>
          s = "(null)";
    4130:	c7 45 f4 d2 5b 00 00 	movl   $0x5bd2,-0xc(%ebp)
        while(*s != 0){
    4137:	eb 1e                	jmp    4157 <printf+0x11f>
    4139:	eb 1c                	jmp    4157 <printf+0x11f>
          putc(fd, *s);
    413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    413e:	0f b6 00             	movzbl (%eax),%eax
    4141:	0f be c0             	movsbl %al,%eax
    4144:	89 44 24 04          	mov    %eax,0x4(%esp)
    4148:	8b 45 08             	mov    0x8(%ebp),%eax
    414b:	89 04 24             	mov    %eax,(%esp)
    414e:	e8 05 fe ff ff       	call   3f58 <putc>
          s++;
    4153:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4157:	8b 45 f4             	mov    -0xc(%ebp),%eax
    415a:	0f b6 00             	movzbl (%eax),%eax
    415d:	84 c0                	test   %al,%al
    415f:	75 da                	jne    413b <printf+0x103>
    4161:	eb 68                	jmp    41cb <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4163:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4167:	75 1d                	jne    4186 <printf+0x14e>
        putc(fd, *ap);
    4169:	8b 45 e8             	mov    -0x18(%ebp),%eax
    416c:	8b 00                	mov    (%eax),%eax
    416e:	0f be c0             	movsbl %al,%eax
    4171:	89 44 24 04          	mov    %eax,0x4(%esp)
    4175:	8b 45 08             	mov    0x8(%ebp),%eax
    4178:	89 04 24             	mov    %eax,(%esp)
    417b:	e8 d8 fd ff ff       	call   3f58 <putc>
        ap++;
    4180:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4184:	eb 45                	jmp    41cb <printf+0x193>
      } else if(c == '%'){
    4186:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    418a:	75 17                	jne    41a3 <printf+0x16b>
        putc(fd, c);
    418c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    418f:	0f be c0             	movsbl %al,%eax
    4192:	89 44 24 04          	mov    %eax,0x4(%esp)
    4196:	8b 45 08             	mov    0x8(%ebp),%eax
    4199:	89 04 24             	mov    %eax,(%esp)
    419c:	e8 b7 fd ff ff       	call   3f58 <putc>
    41a1:	eb 28                	jmp    41cb <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41aa:	00 
    41ab:	8b 45 08             	mov    0x8(%ebp),%eax
    41ae:	89 04 24             	mov    %eax,(%esp)
    41b1:	e8 a2 fd ff ff       	call   3f58 <putc>
        putc(fd, c);
    41b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41b9:	0f be c0             	movsbl %al,%eax
    41bc:	89 44 24 04          	mov    %eax,0x4(%esp)
    41c0:	8b 45 08             	mov    0x8(%ebp),%eax
    41c3:	89 04 24             	mov    %eax,(%esp)
    41c6:	e8 8d fd ff ff       	call   3f58 <putc>
      }
      state = 0;
    41cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41d2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41d6:	8b 55 0c             	mov    0xc(%ebp),%edx
    41d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41dc:	01 d0                	add    %edx,%eax
    41de:	0f b6 00             	movzbl (%eax),%eax
    41e1:	84 c0                	test   %al,%al
    41e3:	0f 85 71 fe ff ff    	jne    405a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    41e9:	c9                   	leave  
    41ea:	c3                   	ret    
    41eb:	90                   	nop

000041ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    41ec:	55                   	push   %ebp
    41ed:	89 e5                	mov    %esp,%ebp
    41ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    41f2:	8b 45 08             	mov    0x8(%ebp),%eax
    41f5:	83 e8 08             	sub    $0x8,%eax
    41f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    41fb:	a1 88 63 00 00       	mov    0x6388,%eax
    4200:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4203:	eb 24                	jmp    4229 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4205:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4208:	8b 00                	mov    (%eax),%eax
    420a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    420d:	77 12                	ja     4221 <free+0x35>
    420f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4212:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4215:	77 24                	ja     423b <free+0x4f>
    4217:	8b 45 fc             	mov    -0x4(%ebp),%eax
    421a:	8b 00                	mov    (%eax),%eax
    421c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    421f:	77 1a                	ja     423b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4221:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4224:	8b 00                	mov    (%eax),%eax
    4226:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4229:	8b 45 f8             	mov    -0x8(%ebp),%eax
    422c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    422f:	76 d4                	jbe    4205 <free+0x19>
    4231:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4234:	8b 00                	mov    (%eax),%eax
    4236:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4239:	76 ca                	jbe    4205 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    423b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    423e:	8b 40 04             	mov    0x4(%eax),%eax
    4241:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4248:	8b 45 f8             	mov    -0x8(%ebp),%eax
    424b:	01 c2                	add    %eax,%edx
    424d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4250:	8b 00                	mov    (%eax),%eax
    4252:	39 c2                	cmp    %eax,%edx
    4254:	75 24                	jne    427a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4259:	8b 50 04             	mov    0x4(%eax),%edx
    425c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    425f:	8b 00                	mov    (%eax),%eax
    4261:	8b 40 04             	mov    0x4(%eax),%eax
    4264:	01 c2                	add    %eax,%edx
    4266:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4269:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    426c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    426f:	8b 00                	mov    (%eax),%eax
    4271:	8b 10                	mov    (%eax),%edx
    4273:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4276:	89 10                	mov    %edx,(%eax)
    4278:	eb 0a                	jmp    4284 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    427a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    427d:	8b 10                	mov    (%eax),%edx
    427f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4282:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    4284:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4287:	8b 40 04             	mov    0x4(%eax),%eax
    428a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4291:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4294:	01 d0                	add    %edx,%eax
    4296:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4299:	75 20                	jne    42bb <free+0xcf>
    p->s.size += bp->s.size;
    429b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    429e:	8b 50 04             	mov    0x4(%eax),%edx
    42a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42a4:	8b 40 04             	mov    0x4(%eax),%eax
    42a7:	01 c2                	add    %eax,%edx
    42a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42b2:	8b 10                	mov    (%eax),%edx
    42b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b7:	89 10                	mov    %edx,(%eax)
    42b9:	eb 08                	jmp    42c3 <free+0xd7>
  } else
    p->s.ptr = bp;
    42bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42be:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42c1:	89 10                	mov    %edx,(%eax)
  freep = p;
    42c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c6:	a3 88 63 00 00       	mov    %eax,0x6388
}
    42cb:	c9                   	leave  
    42cc:	c3                   	ret    

000042cd <morecore>:

static Header*
morecore(uint nu)
{
    42cd:	55                   	push   %ebp
    42ce:	89 e5                	mov    %esp,%ebp
    42d0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    42da:	77 07                	ja     42e3 <morecore+0x16>
    nu = 4096;
    42dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    42e3:	8b 45 08             	mov    0x8(%ebp),%eax
    42e6:	c1 e0 03             	shl    $0x3,%eax
    42e9:	89 04 24             	mov    %eax,(%esp)
    42ec:	e8 4f fc ff ff       	call   3f40 <sbrk>
    42f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    42f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    42f8:	75 07                	jne    4301 <morecore+0x34>
    return 0;
    42fa:	b8 00 00 00 00       	mov    $0x0,%eax
    42ff:	eb 22                	jmp    4323 <morecore+0x56>
  hp = (Header*)p;
    4301:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4304:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4307:	8b 45 f0             	mov    -0x10(%ebp),%eax
    430a:	8b 55 08             	mov    0x8(%ebp),%edx
    430d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4310:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4313:	83 c0 08             	add    $0x8,%eax
    4316:	89 04 24             	mov    %eax,(%esp)
    4319:	e8 ce fe ff ff       	call   41ec <free>
  return freep;
    431e:	a1 88 63 00 00       	mov    0x6388,%eax
}
    4323:	c9                   	leave  
    4324:	c3                   	ret    

00004325 <malloc>:

void*
malloc(uint nbytes)
{
    4325:	55                   	push   %ebp
    4326:	89 e5                	mov    %esp,%ebp
    4328:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    432b:	8b 45 08             	mov    0x8(%ebp),%eax
    432e:	83 c0 07             	add    $0x7,%eax
    4331:	c1 e8 03             	shr    $0x3,%eax
    4334:	83 c0 01             	add    $0x1,%eax
    4337:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    433a:	a1 88 63 00 00       	mov    0x6388,%eax
    433f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4342:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4346:	75 23                	jne    436b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4348:	c7 45 f0 80 63 00 00 	movl   $0x6380,-0x10(%ebp)
    434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4352:	a3 88 63 00 00       	mov    %eax,0x6388
    4357:	a1 88 63 00 00       	mov    0x6388,%eax
    435c:	a3 80 63 00 00       	mov    %eax,0x6380
    base.s.size = 0;
    4361:	c7 05 84 63 00 00 00 	movl   $0x0,0x6384
    4368:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    436b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    436e:	8b 00                	mov    (%eax),%eax
    4370:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4373:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4376:	8b 40 04             	mov    0x4(%eax),%eax
    4379:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    437c:	72 4d                	jb     43cb <malloc+0xa6>
      if(p->s.size == nunits)
    437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4381:	8b 40 04             	mov    0x4(%eax),%eax
    4384:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4387:	75 0c                	jne    4395 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4389:	8b 45 f4             	mov    -0xc(%ebp),%eax
    438c:	8b 10                	mov    (%eax),%edx
    438e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4391:	89 10                	mov    %edx,(%eax)
    4393:	eb 26                	jmp    43bb <malloc+0x96>
      else {
        p->s.size -= nunits;
    4395:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4398:	8b 40 04             	mov    0x4(%eax),%eax
    439b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    439e:	89 c2                	mov    %eax,%edx
    43a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a9:	8b 40 04             	mov    0x4(%eax),%eax
    43ac:	c1 e0 03             	shl    $0x3,%eax
    43af:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    43b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43b8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43be:	a3 88 63 00 00       	mov    %eax,0x6388
      return (void*)(p + 1);
    43c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43c6:	83 c0 08             	add    $0x8,%eax
    43c9:	eb 38                	jmp    4403 <malloc+0xde>
    }
    if(p == freep)
    43cb:	a1 88 63 00 00       	mov    0x6388,%eax
    43d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43d3:	75 1b                	jne    43f0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    43d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    43d8:	89 04 24             	mov    %eax,(%esp)
    43db:	e8 ed fe ff ff       	call   42cd <morecore>
    43e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    43e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    43e7:	75 07                	jne    43f0 <malloc+0xcb>
        return 0;
    43e9:	b8 00 00 00 00       	mov    $0x0,%eax
    43ee:	eb 13                	jmp    4403 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    43f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    43f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43f9:	8b 00                	mov    (%eax),%eax
    43fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    43fe:	e9 70 ff ff ff       	jmp    4373 <malloc+0x4e>
}
    4403:	c9                   	leave  
    4404:	c3                   	ret    
