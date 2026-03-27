
_task2b:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "Child [%d] finished\n", getpid());
    exit();
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 20             	sub    $0x20,%esp
    printf(1, "---------Testcase: set quanta------Scheduler: DEFAULT-------------------------------------\n");
  14:	68 98 08 00 00       	push   $0x898
  19:	6a 01                	push   $0x1
  1b:	e8 20 05 00 00       	call   540 <printf>
        int quanta=1;
        if(child==1)    quanta=100;
        if(child==2)   quanta=50;
        if(child==3)    quanta=10;

        int pid = fork();
  20:	e8 a6 03 00 00       	call   3cb <fork>

        set_quanta(pid, quanta);
  25:	5e                   	pop    %esi
  26:	5f                   	pop    %edi
  27:	6a 64                	push   $0x64
  29:	50                   	push   %eax
        int pid = fork();
  2a:	89 c3                	mov    %eax,%ebx
        set_quanta(pid, quanta);
  2c:	e8 5a 04 00 00       	call   48b <set_quanta>


        if (pid < 0)
  31:	83 c4 10             	add    $0x10,%esp
  34:	85 db                	test   %ebx,%ebx
  36:	78 74                	js     ac <main+0xac>
        {
            printf(1, "%d failed in fork!\n", getpid());
            exit();
        }
        else if (pid == 0)
  38:	0f 84 86 00 00 00    	je     c4 <main+0xc4>
        int pid = fork();
  3e:	e8 88 03 00 00       	call   3cb <fork>
        set_quanta(pid, quanta);
  43:	83 ec 08             	sub    $0x8,%esp
  46:	6a 32                	push   $0x32
        int pid = fork();
  48:	89 c3                	mov    %eax,%ebx
        set_quanta(pid, quanta);
  4a:	50                   	push   %eax
  4b:	e8 3b 04 00 00       	call   48b <set_quanta>
        if (pid < 0)
  50:	83 c4 10             	add    $0x10,%esp
  53:	85 db                	test   %ebx,%ebx
  55:	78 55                	js     ac <main+0xac>
        else if (pid == 0)
  57:	74 79                	je     d2 <main+0xd2>
        int pid = fork();
  59:	e8 6d 03 00 00       	call   3cb <fork>
        set_quanta(pid, quanta);
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	6a 0a                	push   $0xa
        int pid = fork();
  63:	89 c3                	mov    %eax,%ebx
        set_quanta(pid, quanta);
  65:	50                   	push   %eax
  66:	e8 20 04 00 00       	call   48b <set_quanta>
        if (pid < 0)
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	85 db                	test   %ebx,%ebx
  70:	78 3a                	js     ac <main+0xac>
        else if (pid == 0)
  72:	74 65                	je     d9 <main+0xd9>
  74:	bf 03 00 00 00       	mov    $0x3,%edi
  79:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  7c:	8d 5d e0             	lea    -0x20(%ebp),%ebx

    int wtime, rtime, status;

    for (int i = 1; i <= 3; i++)
    {
        status = wait2(&wtime, &rtime);
  7f:	83 ec 08             	sub    $0x8,%esp
  82:	56                   	push   %esi
  83:	53                   	push   %ebx
  84:	e8 f2 03 00 00       	call   47b <wait2>
        printf(1, "Child pid: %d exited with pid: %d, Waiting Time: %d, Run Time: %d\n", status, status, wtime, rtime);
  89:	5a                   	pop    %edx
  8a:	59                   	pop    %ecx
  8b:	ff 75 e4             	push   -0x1c(%ebp)
  8e:	ff 75 e0             	push   -0x20(%ebp)
  91:	50                   	push   %eax
  92:	50                   	push   %eax
  93:	68 f4 08 00 00       	push   $0x8f4
  98:	6a 01                	push   $0x1
  9a:	e8 a1 04 00 00       	call   540 <printf>
    for (int i = 1; i <= 3; i++)
  9f:	83 c4 20             	add    $0x20,%esp
  a2:	83 ef 01             	sub    $0x1,%edi
  a5:	75 d8                	jne    7f <main+0x7f>
    }

    exit();
  a7:	e8 27 03 00 00       	call   3d3 <exit>
            printf(1, "%d failed in fork!\n", getpid());
  ac:	e8 a2 03 00 00       	call   453 <getpid>
  b1:	53                   	push   %ebx
  b2:	50                   	push   %eax
  b3:	68 7b 08 00 00       	push   $0x87b
  b8:	6a 01                	push   $0x1
  ba:	e8 81 04 00 00       	call   540 <printf>
            exit();
  bf:	e8 0f 03 00 00       	call   3d3 <exit>
        else if (pid == 0)
  c4:	b8 64 00 00 00       	mov    $0x64,%eax
            computation(quanta);
  c9:	83 ec 0c             	sub    $0xc,%esp
  cc:	50                   	push   %eax
  cd:	e8 0e 00 00 00       	call   e0 <computation>
        else if (pid == 0)
  d2:	b8 32 00 00 00       	mov    $0x32,%eax
  d7:	eb f0                	jmp    c9 <main+0xc9>
  d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  de:	eb e9                	jmp    c9 <main+0xc9>

000000e0 <computation>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	83 ec 28             	sub    $0x28,%esp
    int child_pid = getpid();
  e6:	e8 68 03 00 00       	call   453 <getpid>
    printf(1, "Child [%d] created T.Q. [%d]\n", child_pid, quanta);
  eb:	ff 75 08             	push   0x8(%ebp)
  ee:	50                   	push   %eax
  ef:	68 48 08 00 00       	push   $0x848
  f4:	6a 01                	push   $0x1
  f6:	e8 45 04 00 00       	call   540 <printf>
    a = 3.14;
  fb:	c7 45 d8 1f 85 eb 51 	movl   $0x51eb851f,-0x28(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
 102:	83 c4 10             	add    $0x10,%esp
    volatile double x = 0, z;
 105:	d9 ee                	fldz
    a = 3.14;
 107:	c7 45 dc b8 1e 09 40 	movl   $0x40091eb8,-0x24(%ebp)
    b = 36.29;
 10e:	c7 45 e0 85 eb 51 b8 	movl   $0xb851eb85,-0x20(%ebp)
 115:	c7 45 e4 1e 25 42 40 	movl   $0x4042251e,-0x1c(%ebp)
    volatile double x = 0, z;
 11c:	dd 55 e8             	fstl   -0x18(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
 11f:	dd 5d f0             	fstpl  -0x10(%ebp)
 122:	dd 45 f0             	fldl   -0x10(%ebp)
 125:	dd 05 40 09 00 00    	fldl   0x940
 12b:	d9 05 38 09 00 00    	flds   0x938
 131:	df f2                	fcomip %st(2),%st
 133:	dd d9                	fstp   %st(1)
 135:	76 36                	jbe    16d <computation+0x8d>
 137:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13e:	00 
 13f:	90                   	nop
        x = x + a * b;
 140:	dd 45 d8             	fldl   -0x28(%ebp)
 143:	dd 45 e0             	fldl   -0x20(%ebp)
 146:	dd 45 e8             	fldl   -0x18(%ebp)
 149:	d9 ca                	fxch   %st(2)
 14b:	de c9                	fmulp  %st,%st(1)
 14d:	de c1                	faddp  %st,%st(1)
 14f:	dd 5d e8             	fstpl  -0x18(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
 152:	dd 45 f0             	fldl   -0x10(%ebp)
 155:	d8 c1                	fadd   %st(1),%st
 157:	dd 5d f0             	fstpl  -0x10(%ebp)
 15a:	dd 45 f0             	fldl   -0x10(%ebp)
 15d:	d9 05 38 09 00 00    	flds   0x938
 163:	df f1                	fcomip %st(1),%st
 165:	dd d8                	fstp   %st(0)
 167:	77 d7                	ja     140 <computation+0x60>
 169:	dd d8                	fstp   %st(0)
 16b:	eb 03                	jmp    170 <computation+0x90>
 16d:	dd d8                	fstp   %st(0)
 16f:	90                   	nop
    printf(1, "Child [%d] finished\n", getpid());
 170:	e8 de 02 00 00       	call   453 <getpid>
 175:	83 ec 04             	sub    $0x4,%esp
 178:	50                   	push   %eax
 179:	68 66 08 00 00       	push   $0x866
 17e:	6a 01                	push   $0x1
 180:	e8 bb 03 00 00       	call   540 <printf>
    exit();
 185:	e8 49 02 00 00       	call   3d3 <exit>
 18a:	66 90                	xchg   %ax,%ax
 18c:	66 90                	xchg   %ax,%ax
 18e:	66 90                	xchg   %ax,%ax

00000190 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 190:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 191:	31 c0                	xor    %eax,%eax
{
 193:	89 e5                	mov    %esp,%ebp
 195:	53                   	push   %ebx
 196:	8b 4d 08             	mov    0x8(%ebp),%ecx
 199:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1a7:	83 c0 01             	add    $0x1,%eax
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strcpy+0x10>
    ;
  return os;
}
 1ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b1:	89 c8                	mov    %ecx,%eax
 1b3:	c9                   	leave
 1b4:	c3                   	ret
 1b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bc:	00 
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
 1c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ca:	0f b6 02             	movzbl (%edx),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 17                	jne    1e8 <strcmp+0x28>
 1d1:	eb 3a                	jmp    20d <strcmp+0x4d>
 1d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1dc:	83 c2 01             	add    $0x1,%edx
 1df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1e2:	84 c0                	test   %al,%al
 1e4:	74 1a                	je     200 <strcmp+0x40>
 1e6:	89 d9                	mov    %ebx,%ecx
 1e8:	0f b6 19             	movzbl (%ecx),%ebx
 1eb:	38 c3                	cmp    %al,%bl
 1ed:	74 e9                	je     1d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1ef:	29 d8                	sub    %ebx,%eax
}
 1f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f4:	c9                   	leave
 1f5:	c3                   	ret
 1f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1fd:	00 
 1fe:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 200:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 204:	31 c0                	xor    %eax,%eax
 206:	29 d8                	sub    %ebx,%eax
}
 208:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 20b:	c9                   	leave
 20c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 20d:	0f b6 19             	movzbl (%ecx),%ebx
 210:	31 c0                	xor    %eax,%eax
 212:	eb db                	jmp    1ef <strcmp+0x2f>
 214:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21b:	00 
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <strlen>:

uint
strlen(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 3a 00             	cmpb   $0x0,(%edx)
 229:	74 15                	je     240 <strlen+0x20>
 22b:	31 c0                	xor    %eax,%eax
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c0 01             	add    $0x1,%eax
 233:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 237:	89 c1                	mov    %eax,%ecx
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	89 c8                	mov    %ecx,%eax
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret
 23f:	90                   	nop
  for(n = 0; s[n]; n++)
 240:	31 c9                	xor    %ecx,%ecx
}
 242:	5d                   	pop    %ebp
 243:	89 c8                	mov    %ecx,%eax
 245:	c3                   	ret
 246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24d:	00 
 24e:	66 90                	xchg   %ax,%ax

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	8b 7d fc             	mov    -0x4(%ebp),%edi
 265:	89 d0                	mov    %edx,%eax
 267:	c9                   	leave
 268:	c3                   	ret
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	75 12                	jne    293 <strchr+0x23>
 281:	eb 1d                	jmp    2a0 <strchr+0x30>
 283:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 288:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 28c:	83 c0 01             	add    $0x1,%eax
 28f:	84 d2                	test   %dl,%dl
 291:	74 0d                	je     2a0 <strchr+0x30>
    if(*s == c)
 293:	38 d1                	cmp    %dl,%cl
 295:	75 f1                	jne    288 <strchr+0x18>
      return (char*)s;
  return 0;
}
 297:	5d                   	pop    %ebp
 298:	c3                   	ret
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2a0:	31 c0                	xor    %eax,%eax
}
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret
 2a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ab:	00 
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2b5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 2b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2b9:	31 db                	xor    %ebx,%ebx
{
 2bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2be:	eb 27                	jmp    2e7 <gets+0x37>
    cc = read(0, &c, 1);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	6a 01                	push   $0x1
 2c5:	56                   	push   %esi
 2c6:	6a 00                	push   $0x0
 2c8:	e8 1e 01 00 00       	call   3eb <read>
    if(cc < 1)
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7e 1d                	jle    2f1 <gets+0x41>
      break;
    buf[i++] = c;
 2d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d8:	8b 55 08             	mov    0x8(%ebp),%edx
 2db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2df:	3c 0a                	cmp    $0xa,%al
 2e1:	74 10                	je     2f3 <gets+0x43>
 2e3:	3c 0d                	cmp    $0xd,%al
 2e5:	74 0c                	je     2f3 <gets+0x43>
  for(i=0; i+1 < max; ){
 2e7:	89 df                	mov    %ebx,%edi
 2e9:	83 c3 01             	add    $0x1,%ebx
 2ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ef:	7c cf                	jl     2c0 <gets+0x10>
 2f1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 2fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret
 302:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 309:	00 
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000310 <stat>:

int
stat(const char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 315:	83 ec 08             	sub    $0x8,%esp
 318:	6a 00                	push   $0x0
 31a:	ff 75 08             	push   0x8(%ebp)
 31d:	e8 f1 00 00 00       	call   413 <open>
  if(fd < 0)
 322:	83 c4 10             	add    $0x10,%esp
 325:	85 c0                	test   %eax,%eax
 327:	78 27                	js     350 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	ff 75 0c             	push   0xc(%ebp)
 32f:	89 c3                	mov    %eax,%ebx
 331:	50                   	push   %eax
 332:	e8 f4 00 00 00       	call   42b <fstat>
  close(fd);
 337:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 33a:	89 c6                	mov    %eax,%esi
  close(fd);
 33c:	e8 ba 00 00 00       	call   3fb <close>
  return r;
 341:	83 c4 10             	add    $0x10,%esp
}
 344:	8d 65 f8             	lea    -0x8(%ebp),%esp
 347:	89 f0                	mov    %esi,%eax
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret
 34d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 350:	be ff ff ff ff       	mov    $0xffffffff,%esi
 355:	eb ed                	jmp    344 <stat+0x34>
 357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35e:	00 
 35f:	90                   	nop

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 367:	0f be 02             	movsbl (%edx),%eax
 36a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 36d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 370:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 375:	77 1e                	ja     395 <atoi+0x35>
 377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37e:	00 
 37f:	90                   	nop
    n = n*10 + *s++ - '0';
 380:	83 c2 01             	add    $0x1,%edx
 383:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 386:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 38a:	0f be 02             	movsbl (%edx),%eax
 38d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 390:	80 fb 09             	cmp    $0x9,%bl
 393:	76 eb                	jbe    380 <atoi+0x20>
  return n;
}
 395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 398:	89 c8                	mov    %ecx,%eax
 39a:	c9                   	leave
 39b:	c3                   	ret
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 45 10             	mov    0x10(%ebp),%eax
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
 3aa:	56                   	push   %esi
 3ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ae:	85 c0                	test   %eax,%eax
 3b0:	7e 13                	jle    3c5 <memmove+0x25>
 3b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3b4:	89 d7                	mov    %edx,%edi
 3b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bd:	00 
 3be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3c1:	39 f8                	cmp    %edi,%eax
 3c3:	75 fb                	jne    3c0 <memmove+0x20>
  return vdst;
}
 3c5:	5e                   	pop    %esi
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret

000003cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3cb:	b8 01 00 00 00       	mov    $0x1,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <exit>:
SYSCALL(exit)
 3d3:	b8 02 00 00 00       	mov    $0x2,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <wait>:
SYSCALL(wait)
 3db:	b8 03 00 00 00       	mov    $0x3,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <pipe>:
SYSCALL(pipe)
 3e3:	b8 04 00 00 00       	mov    $0x4,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <read>:
SYSCALL(read)
 3eb:	b8 05 00 00 00       	mov    $0x5,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <write>:
SYSCALL(write)
 3f3:	b8 10 00 00 00       	mov    $0x10,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <close>:
SYSCALL(close)
 3fb:	b8 15 00 00 00       	mov    $0x15,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <kill>:
SYSCALL(kill)
 403:	b8 06 00 00 00       	mov    $0x6,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <exec>:
SYSCALL(exec)
 40b:	b8 07 00 00 00       	mov    $0x7,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <open>:
SYSCALL(open)
 413:	b8 0f 00 00 00       	mov    $0xf,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <mknod>:
SYSCALL(mknod)
 41b:	b8 11 00 00 00       	mov    $0x11,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <unlink>:
SYSCALL(unlink)
 423:	b8 12 00 00 00       	mov    $0x12,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <fstat>:
SYSCALL(fstat)
 42b:	b8 08 00 00 00       	mov    $0x8,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <link>:
SYSCALL(link)
 433:	b8 13 00 00 00       	mov    $0x13,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <mkdir>:
SYSCALL(mkdir)
 43b:	b8 14 00 00 00       	mov    $0x14,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <chdir>:
SYSCALL(chdir)
 443:	b8 09 00 00 00       	mov    $0x9,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <dup>:
SYSCALL(dup)
 44b:	b8 0a 00 00 00       	mov    $0xa,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <getpid>:
SYSCALL(getpid)
 453:	b8 0b 00 00 00       	mov    $0xb,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <sbrk>:
SYSCALL(sbrk)
 45b:	b8 0c 00 00 00       	mov    $0xc,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <sleep>:
SYSCALL(sleep)
 463:	b8 0d 00 00 00       	mov    $0xd,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <uptime>:
SYSCALL(uptime)
 46b:	b8 0e 00 00 00       	mov    $0xe,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <cscount>:
SYSCALL(cscount)
 473:	b8 16 00 00 00       	mov    $0x16,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <wait2>:
SYSCALL(wait2)
 47b:	b8 17 00 00 00       	mov    $0x17,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <set_priority>:
SYSCALL(set_priority)
 483:	b8 18 00 00 00       	mov    $0x18,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <set_quanta>:
 48b:	b8 19 00 00 00       	mov    $0x19,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret
 493:	66 90                	xchg   %ax,%ax
 495:	66 90                	xchg   %ax,%ax
 497:	66 90                	xchg   %ax,%ax
 499:	66 90                	xchg   %ax,%ax
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4a8:	89 d1                	mov    %edx,%ecx
{
 4aa:	83 ec 3c             	sub    $0x3c,%esp
 4ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4b0:	85 d2                	test   %edx,%edx
 4b2:	0f 89 80 00 00 00    	jns    538 <printint+0x98>
 4b8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4bc:	74 7a                	je     538 <printint+0x98>
    x = -xx;
 4be:	f7 d9                	neg    %ecx
    neg = 1;
 4c0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 4c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4c8:	31 f6                	xor    %esi,%esi
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	89 f7                	mov    %esi,%edi
 4d6:	f7 f3                	div    %ebx
 4d8:	8d 76 01             	lea    0x1(%esi),%esi
 4db:	0f b6 92 a0 09 00 00 	movzbl 0x9a0(%edx),%edx
 4e2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4e6:	89 ca                	mov    %ecx,%edx
 4e8:	89 c1                	mov    %eax,%ecx
 4ea:	39 da                	cmp    %ebx,%edx
 4ec:	73 e2                	jae    4d0 <printint+0x30>
  if(neg)
 4ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4f1:	85 c0                	test   %eax,%eax
 4f3:	74 07                	je     4fc <printint+0x5c>
    buf[i++] = '-';
 4f5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 4fa:	89 f7                	mov    %esi,%edi
 4fc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4ff:	8b 75 c0             	mov    -0x40(%ebp),%esi
 502:	01 df                	add    %ebx,%edi
 504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 508:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 50b:	83 ec 04             	sub    $0x4,%esp
 50e:	88 45 d7             	mov    %al,-0x29(%ebp)
 511:	8d 45 d7             	lea    -0x29(%ebp),%eax
 514:	6a 01                	push   $0x1
 516:	50                   	push   %eax
 517:	56                   	push   %esi
 518:	e8 d6 fe ff ff       	call   3f3 <write>
  while(--i >= 0)
 51d:	89 f8                	mov    %edi,%eax
 51f:	83 c4 10             	add    $0x10,%esp
 522:	83 ef 01             	sub    $0x1,%edi
 525:	39 c3                	cmp    %eax,%ebx
 527:	75 df                	jne    508 <printint+0x68>
}
 529:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52c:	5b                   	pop    %ebx
 52d:	5e                   	pop    %esi
 52e:	5f                   	pop    %edi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 538:	31 c0                	xor    %eax,%eax
 53a:	eb 89                	jmp    4c5 <printint+0x25>
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000540 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 549:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 54c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 54f:	0f b6 1e             	movzbl (%esi),%ebx
 552:	83 c6 01             	add    $0x1,%esi
 555:	84 db                	test   %bl,%bl
 557:	74 67                	je     5c0 <printf+0x80>
 559:	8d 4d 10             	lea    0x10(%ebp),%ecx
 55c:	31 d2                	xor    %edx,%edx
 55e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 561:	eb 34                	jmp    597 <printf+0x57>
 563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 568:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 56b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 570:	83 f8 25             	cmp    $0x25,%eax
 573:	74 18                	je     58d <printf+0x4d>
  write(fd, &c, 1);
 575:	83 ec 04             	sub    $0x4,%esp
 578:	8d 45 e7             	lea    -0x19(%ebp),%eax
 57b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 57e:	6a 01                	push   $0x1
 580:	50                   	push   %eax
 581:	57                   	push   %edi
 582:	e8 6c fe ff ff       	call   3f3 <write>
 587:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 58a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 58d:	0f b6 1e             	movzbl (%esi),%ebx
 590:	83 c6 01             	add    $0x1,%esi
 593:	84 db                	test   %bl,%bl
 595:	74 29                	je     5c0 <printf+0x80>
    c = fmt[i] & 0xff;
 597:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 59a:	85 d2                	test   %edx,%edx
 59c:	74 ca                	je     568 <printf+0x28>
      }
    } else if(state == '%'){
 59e:	83 fa 25             	cmp    $0x25,%edx
 5a1:	75 ea                	jne    58d <printf+0x4d>
      if(c == 'd'){
 5a3:	83 f8 25             	cmp    $0x25,%eax
 5a6:	0f 84 04 01 00 00    	je     6b0 <printf+0x170>
 5ac:	83 e8 63             	sub    $0x63,%eax
 5af:	83 f8 15             	cmp    $0x15,%eax
 5b2:	77 1c                	ja     5d0 <printf+0x90>
 5b4:	ff 24 85 48 09 00 00 	jmp    *0x948(,%eax,4)
 5bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c3:	5b                   	pop    %ebx
 5c4:	5e                   	pop    %esi
 5c5:	5f                   	pop    %edi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret
 5c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5cf:	00 
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5d6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5da:	6a 01                	push   $0x1
 5dc:	52                   	push   %edx
 5dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5e0:	57                   	push   %edi
 5e1:	e8 0d fe ff ff       	call   3f3 <write>
 5e6:	83 c4 0c             	add    $0xc,%esp
 5e9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ec:	6a 01                	push   $0x1
 5ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5f1:	52                   	push   %edx
 5f2:	57                   	push   %edi
 5f3:	e8 fb fd ff ff       	call   3f3 <write>
        putc(fd, c);
 5f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fb:	31 d2                	xor    %edx,%edx
 5fd:	eb 8e                	jmp    58d <printf+0x4d>
 5ff:	90                   	nop
        printint(fd, *ap, 16, 0);
 600:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 603:	83 ec 0c             	sub    $0xc,%esp
 606:	b9 10 00 00 00       	mov    $0x10,%ecx
 60b:	8b 13                	mov    (%ebx),%edx
 60d:	6a 00                	push   $0x0
 60f:	89 f8                	mov    %edi,%eax
        ap++;
 611:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 614:	e8 87 fe ff ff       	call   4a0 <printint>
        ap++;
 619:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 61c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61f:	31 d2                	xor    %edx,%edx
 621:	e9 67 ff ff ff       	jmp    58d <printf+0x4d>
        s = (char*)*ap;
 626:	8b 45 d0             	mov    -0x30(%ebp),%eax
 629:	8b 18                	mov    (%eax),%ebx
        ap++;
 62b:	83 c0 04             	add    $0x4,%eax
 62e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 631:	85 db                	test   %ebx,%ebx
 633:	0f 84 87 00 00 00    	je     6c0 <printf+0x180>
        while(*s != 0){
 639:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 63c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 63e:	84 c0                	test   %al,%al
 640:	0f 84 47 ff ff ff    	je     58d <printf+0x4d>
 646:	8d 55 e7             	lea    -0x19(%ebp),%edx
 649:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 64c:	89 de                	mov    %ebx,%esi
 64e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
 653:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 656:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 659:	6a 01                	push   $0x1
 65b:	53                   	push   %ebx
 65c:	57                   	push   %edi
 65d:	e8 91 fd ff ff       	call   3f3 <write>
        while(*s != 0){
 662:	0f b6 06             	movzbl (%esi),%eax
 665:	83 c4 10             	add    $0x10,%esp
 668:	84 c0                	test   %al,%al
 66a:	75 e4                	jne    650 <printf+0x110>
      state = 0;
 66c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 66f:	31 d2                	xor    %edx,%edx
 671:	e9 17 ff ff ff       	jmp    58d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 676:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 679:	83 ec 0c             	sub    $0xc,%esp
 67c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 681:	8b 13                	mov    (%ebx),%edx
 683:	6a 01                	push   $0x1
 685:	eb 88                	jmp    60f <printf+0xcf>
        putc(fd, *ap);
 687:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 68a:	83 ec 04             	sub    $0x4,%esp
 68d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 690:	8b 03                	mov    (%ebx),%eax
        ap++;
 692:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 695:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 698:	6a 01                	push   $0x1
 69a:	52                   	push   %edx
 69b:	57                   	push   %edi
 69c:	e8 52 fd ff ff       	call   3f3 <write>
        ap++;
 6a1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6a4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6a7:	31 d2                	xor    %edx,%edx
 6a9:	e9 df fe ff ff       	jmp    58d <printf+0x4d>
 6ae:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6b9:	6a 01                	push   $0x1
 6bb:	e9 31 ff ff ff       	jmp    5f1 <printf+0xb1>
 6c0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 6c5:	bb 8f 08 00 00       	mov    $0x88f,%ebx
 6ca:	e9 77 ff ff ff       	jmp    646 <printf+0x106>
 6cf:	90                   	nop

000006d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d1:	a1 64 0c 00 00       	mov    0xc64,%eax
{
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	57                   	push   %edi
 6d9:	56                   	push   %esi
 6da:	53                   	push   %ebx
 6db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	39 c8                	cmp    %ecx,%eax
 6ec:	73 32                	jae    720 <free+0x50>
 6ee:	39 d1                	cmp    %edx,%ecx
 6f0:	72 04                	jb     6f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f2:	39 d0                	cmp    %edx,%eax
 6f4:	72 32                	jb     728 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fc:	39 fa                	cmp    %edi,%edx
 6fe:	74 30                	je     730 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 700:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 703:	8b 50 04             	mov    0x4(%eax),%edx
 706:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 709:	39 f1                	cmp    %esi,%ecx
 70b:	74 3a                	je     747 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 70d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 70f:	5b                   	pop    %ebx
  freep = p;
 710:	a3 64 0c 00 00       	mov    %eax,0xc64
}
 715:	5e                   	pop    %esi
 716:	5f                   	pop    %edi
 717:	5d                   	pop    %ebp
 718:	c3                   	ret
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	39 d0                	cmp    %edx,%eax
 722:	72 04                	jb     728 <free+0x58>
 724:	39 d1                	cmp    %edx,%ecx
 726:	72 ce                	jb     6f6 <free+0x26>
{
 728:	89 d0                	mov    %edx,%eax
 72a:	eb bc                	jmp    6e8 <free+0x18>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 730:	03 72 04             	add    0x4(%edx),%esi
 733:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	8b 10                	mov    (%eax),%edx
 738:	8b 12                	mov    (%edx),%edx
 73a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 73d:	8b 50 04             	mov    0x4(%eax),%edx
 740:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 743:	39 f1                	cmp    %esi,%ecx
 745:	75 c6                	jne    70d <free+0x3d>
    p->s.size += bp->s.size;
 747:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 74a:	a3 64 0c 00 00       	mov    %eax,0xc64
    p->s.size += bp->s.size;
 74f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 752:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 755:	89 08                	mov    %ecx,(%eax)
}
 757:	5b                   	pop    %ebx
 758:	5e                   	pop    %esi
 759:	5f                   	pop    %edi
 75a:	5d                   	pop    %ebp
 75b:	c3                   	ret
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000760 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 769:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 76c:	8b 15 64 0c 00 00    	mov    0xc64,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8d 78 07             	lea    0x7(%eax),%edi
 775:	c1 ef 03             	shr    $0x3,%edi
 778:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 77b:	85 d2                	test   %edx,%edx
 77d:	0f 84 8d 00 00 00    	je     810 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 783:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 785:	8b 48 04             	mov    0x4(%eax),%ecx
 788:	39 f9                	cmp    %edi,%ecx
 78a:	73 64                	jae    7f0 <malloc+0x90>
  if(nu < 4096)
 78c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 791:	39 df                	cmp    %ebx,%edi
 793:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 796:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 79d:	eb 0a                	jmp    7a9 <malloc+0x49>
 79f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7a2:	8b 48 04             	mov    0x4(%eax),%ecx
 7a5:	39 f9                	cmp    %edi,%ecx
 7a7:	73 47                	jae    7f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a9:	89 c2                	mov    %eax,%edx
 7ab:	3b 05 64 0c 00 00    	cmp    0xc64,%eax
 7b1:	75 ed                	jne    7a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7b3:	83 ec 0c             	sub    $0xc,%esp
 7b6:	56                   	push   %esi
 7b7:	e8 9f fc ff ff       	call   45b <sbrk>
  if(p == (char*)-1)
 7bc:	83 c4 10             	add    $0x10,%esp
 7bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c2:	74 1c                	je     7e0 <malloc+0x80>
  hp->s.size = nu;
 7c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c7:	83 ec 0c             	sub    $0xc,%esp
 7ca:	83 c0 08             	add    $0x8,%eax
 7cd:	50                   	push   %eax
 7ce:	e8 fd fe ff ff       	call   6d0 <free>
  return freep;
 7d3:	8b 15 64 0c 00 00    	mov    0xc64,%edx
      if((p = morecore(nunits)) == 0)
 7d9:	83 c4 10             	add    $0x10,%esp
 7dc:	85 d2                	test   %edx,%edx
 7de:	75 c0                	jne    7a0 <malloc+0x40>
        return 0;
  }
}
 7e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7e3:	31 c0                	xor    %eax,%eax
}
 7e5:	5b                   	pop    %ebx
 7e6:	5e                   	pop    %esi
 7e7:	5f                   	pop    %edi
 7e8:	5d                   	pop    %ebp
 7e9:	c3                   	ret
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7f0:	39 cf                	cmp    %ecx,%edi
 7f2:	74 4c                	je     840 <malloc+0xe0>
        p->s.size -= nunits;
 7f4:	29 f9                	sub    %edi,%ecx
 7f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7ff:	89 15 64 0c 00 00    	mov    %edx,0xc64
}
 805:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 808:	83 c0 08             	add    $0x8,%eax
}
 80b:	5b                   	pop    %ebx
 80c:	5e                   	pop    %esi
 80d:	5f                   	pop    %edi
 80e:	5d                   	pop    %ebp
 80f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 810:	c7 05 64 0c 00 00 68 	movl   $0xc68,0xc64
 817:	0c 00 00 
    base.s.size = 0;
 81a:	b8 68 0c 00 00       	mov    $0xc68,%eax
    base.s.ptr = freep = prevp = &base;
 81f:	c7 05 68 0c 00 00 68 	movl   $0xc68,0xc68
 826:	0c 00 00 
    base.s.size = 0;
 829:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 830:	00 00 00 
    if(p->s.size >= nunits){
 833:	e9 54 ff ff ff       	jmp    78c <malloc+0x2c>
 838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 83f:	00 
        prevp->s.ptr = p->s.ptr;
 840:	8b 08                	mov    (%eax),%ecx
 842:	89 0a                	mov    %ecx,(%edx)
 844:	eb b9                	jmp    7ff <malloc+0x9f>
