
_task2a1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "Child %d finished\n", getpid());
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
    printf(1, "---------Testcase 1: set priority------Scheduler: PRIORITY BASED-------------------------------------\n");
   f:	be 03 00 00 00       	mov    $0x3,%esi
{
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 20             	sub    $0x20,%esp
    printf(1, "---------Testcase 1: set priority------Scheduler: PRIORITY BASED-------------------------------------\n");
  19:	68 64 08 00 00       	push   $0x864
  1e:	6a 01                	push   $0x1
  20:	e8 eb 04 00 00       	call   510 <printf>
  25:	83 c4 10             	add    $0x10,%esp

    for (int child = 1; child <= 3; child++)
    {
        int priority = 4; // Calculate priority for each child

        int pid = fork();
  28:	e8 6e 03 00 00       	call   39b <fork>

        set_priority(pid, priority);
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	6a 04                	push   $0x4
        int pid = fork();
  32:	89 c3                	mov    %eax,%ebx
        set_priority(pid, priority);
  34:	50                   	push   %eax
  35:	e8 19 04 00 00       	call   453 <set_priority>


        if (pid < 0)
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 db                	test   %ebx,%ebx
  3f:	78 3f                	js     80 <main+0x80>
        {
            printf(1, "%d failed in fork!\n", getpid());
            exit();
        }
        else if (pid == 0)
  41:	74 55                	je     98 <main+0x98>
    for (int child = 1; child <= 3; child++)
  43:	83 ee 01             	sub    $0x1,%esi
  46:	75 e0                	jne    28 <main+0x28>
  48:	bb 03 00 00 00       	mov    $0x3,%ebx
  4d:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  50:	8d 75 e0             	lea    -0x20(%ebp),%esi

    int wtime, rtime, status;

    for (int i = 1; i <= 3; i++)
    {
        status = wait2(&wtime, &rtime);
  53:	83 ec 08             	sub    $0x8,%esp
  56:	57                   	push   %edi
  57:	56                   	push   %esi
  58:	e8 ee 03 00 00       	call   44b <wait2>
        printf(1, "Child pid: %d exited with pid: %d, Waiting Time: %d, Run Time: %d\n", status, status, wtime, rtime);
  5d:	5a                   	pop    %edx
  5e:	59                   	pop    %ecx
  5f:	ff 75 e4             	push   -0x1c(%ebp)
  62:	ff 75 e0             	push   -0x20(%ebp)
  65:	50                   	push   %eax
  66:	50                   	push   %eax
  67:	68 cc 08 00 00       	push   $0x8cc
  6c:	6a 01                	push   $0x1
  6e:	e8 9d 04 00 00       	call   510 <printf>
    for (int i = 1; i <= 3; i++)
  73:	83 c4 20             	add    $0x20,%esp
  76:	83 eb 01             	sub    $0x1,%ebx
  79:	75 d8                	jne    53 <main+0x53>
    }

    exit();
  7b:	e8 23 03 00 00       	call   3a3 <exit>
            printf(1, "%d failed in fork!\n", getpid());
  80:	e8 9e 03 00 00       	call   423 <getpid>
  85:	53                   	push   %ebx
  86:	50                   	push   %eax
  87:	68 49 08 00 00       	push   $0x849
  8c:	6a 01                	push   $0x1
  8e:	e8 7d 04 00 00       	call   510 <printf>
            exit();
  93:	e8 0b 03 00 00       	call   3a3 <exit>
            computation(priority);
  98:	83 ec 0c             	sub    $0xc,%esp
  9b:	6a 04                	push   $0x4
  9d:	e8 0e 00 00 00       	call   b0 <computation>
  a2:	66 90                	xchg   %ax,%ax
  a4:	66 90                	xchg   %ax,%ax
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <computation>:
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 28             	sub    $0x28,%esp
    int child_pid = getpid();
  b6:	e8 68 03 00 00       	call   423 <getpid>
    printf(1, "Child %d created priority %d\n", child_pid, priority);
  bb:	ff 75 08             	push   0x8(%ebp)
  be:	50                   	push   %eax
  bf:	68 18 08 00 00       	push   $0x818
  c4:	6a 01                	push   $0x1
  c6:	e8 45 04 00 00       	call   510 <printf>
    a = 3.14;
  cb:	c7 45 d8 1f 85 eb 51 	movl   $0x51eb851f,-0x28(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
  d2:	83 c4 10             	add    $0x10,%esp
    volatile double x = 0, z;
  d5:	d9 ee                	fldz
    a = 3.14;
  d7:	c7 45 dc b8 1e 09 40 	movl   $0x40091eb8,-0x24(%ebp)
    b = 36.29;
  de:	c7 45 e0 85 eb 51 b8 	movl   $0xb851eb85,-0x20(%ebp)
  e5:	c7 45 e4 1e 25 42 40 	movl   $0x4042251e,-0x1c(%ebp)
    volatile double x = 0, z;
  ec:	dd 55 e8             	fstl   -0x18(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
  ef:	dd 5d f0             	fstpl  -0x10(%ebp)
  f2:	dd 45 f0             	fldl   -0x10(%ebp)
  f5:	dd 05 18 09 00 00    	fldl   0x918
  fb:	d9 05 10 09 00 00    	flds   0x910
 101:	df f2                	fcomip %st(2),%st
 103:	dd d9                	fstp   %st(1)
 105:	76 36                	jbe    13d <computation+0x8d>
 107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10e:	00 
 10f:	90                   	nop
        x = x + a * b;
 110:	dd 45 d8             	fldl   -0x28(%ebp)
 113:	dd 45 e0             	fldl   -0x20(%ebp)
 116:	dd 45 e8             	fldl   -0x18(%ebp)
 119:	d9 ca                	fxch   %st(2)
 11b:	de c9                	fmulp  %st,%st(1)
 11d:	de c1                	faddp  %st,%st(1)
 11f:	dd 5d e8             	fstpl  -0x18(%ebp)
    for (z = 0; z < 90000.0; z += 0.1)
 122:	dd 45 f0             	fldl   -0x10(%ebp)
 125:	d8 c1                	fadd   %st(1),%st
 127:	dd 5d f0             	fstpl  -0x10(%ebp)
 12a:	dd 45 f0             	fldl   -0x10(%ebp)
 12d:	d9 05 10 09 00 00    	flds   0x910
 133:	df f1                	fcomip %st(1),%st
 135:	dd d8                	fstp   %st(0)
 137:	77 d7                	ja     110 <computation+0x60>
 139:	dd d8                	fstp   %st(0)
 13b:	eb 03                	jmp    140 <computation+0x90>
 13d:	dd d8                	fstp   %st(0)
 13f:	90                   	nop
    printf(1, "Child %d finished\n", getpid());
 140:	e8 de 02 00 00       	call   423 <getpid>
 145:	83 ec 04             	sub    $0x4,%esp
 148:	50                   	push   %eax
 149:	68 36 08 00 00       	push   $0x836
 14e:	6a 01                	push   $0x1
 150:	e8 bb 03 00 00       	call   510 <printf>
    exit();
 155:	e8 49 02 00 00       	call   3a3 <exit>
 15a:	66 90                	xchg   %ax,%ax
 15c:	66 90                	xchg   %ax,%ax
 15e:	66 90                	xchg   %ax,%ax

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 161:	31 c0                	xor    %eax,%eax
{
 163:	89 e5                	mov    %esp,%ebp
 165:	53                   	push   %ebx
 166:	8b 4d 08             	mov    0x8(%ebp),%ecx
 169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 170:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 174:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 177:	83 c0 01             	add    $0x1,%eax
 17a:	84 d2                	test   %dl,%dl
 17c:	75 f2                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 17e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 181:	89 c8                	mov    %ecx,%eax
 183:	c9                   	leave
 184:	c3                   	ret
 185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18c:	00 
 18d:	8d 76 00             	lea    0x0(%esi),%esi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	53                   	push   %ebx
 194:	8b 55 08             	mov    0x8(%ebp),%edx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	75 17                	jne    1b8 <strcmp+0x28>
 1a1:	eb 3a                	jmp    1dd <strcmp+0x4d>
 1a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1ac:	83 c2 01             	add    $0x1,%edx
 1af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1b2:	84 c0                	test   %al,%al
 1b4:	74 1a                	je     1d0 <strcmp+0x40>
 1b6:	89 d9                	mov    %ebx,%ecx
 1b8:	0f b6 19             	movzbl (%ecx),%ebx
 1bb:	38 c3                	cmp    %al,%bl
 1bd:	74 e9                	je     1a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1bf:	29 d8                	sub    %ebx,%eax
}
 1c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c4:	c9                   	leave
 1c5:	c3                   	ret
 1c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1cd:	00 
 1ce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 1d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1d4:	31 c0                	xor    %eax,%eax
 1d6:	29 d8                	sub    %ebx,%eax
}
 1d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1db:	c9                   	leave
 1dc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1dd:	0f b6 19             	movzbl (%ecx),%ebx
 1e0:	31 c0                	xor    %eax,%eax
 1e2:	eb db                	jmp    1bf <strcmp+0x2f>
 1e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1eb:	00 
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001f0 <strlen>:

uint
strlen(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1f6:	80 3a 00             	cmpb   $0x0,(%edx)
 1f9:	74 15                	je     210 <strlen+0x20>
 1fb:	31 c0                	xor    %eax,%eax
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	83 c0 01             	add    $0x1,%eax
 203:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 207:	89 c1                	mov    %eax,%ecx
 209:	75 f5                	jne    200 <strlen+0x10>
    ;
  return n;
}
 20b:	89 c8                	mov    %ecx,%eax
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret
 20f:	90                   	nop
  for(n = 0; s[n]; n++)
 210:	31 c9                	xor    %ecx,%ecx
}
 212:	5d                   	pop    %ebp
 213:	89 c8                	mov    %ecx,%eax
 215:	c3                   	ret
 216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21d:	00 
 21e:	66 90                	xchg   %ax,%ax

00000220 <memset>:

void*
memset(void *dst, int c, uint n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 227:	8b 4d 10             	mov    0x10(%ebp),%ecx
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 d7                	mov    %edx,%edi
 22f:	fc                   	cld
 230:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 232:	8b 7d fc             	mov    -0x4(%ebp),%edi
 235:	89 d0                	mov    %edx,%eax
 237:	c9                   	leave
 238:	c3                   	ret
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000240 <strchr>:

char*
strchr(const char *s, char c)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 24a:	0f b6 10             	movzbl (%eax),%edx
 24d:	84 d2                	test   %dl,%dl
 24f:	75 12                	jne    263 <strchr+0x23>
 251:	eb 1d                	jmp    270 <strchr+0x30>
 253:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 258:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 25c:	83 c0 01             	add    $0x1,%eax
 25f:	84 d2                	test   %dl,%dl
 261:	74 0d                	je     270 <strchr+0x30>
    if(*s == c)
 263:	38 d1                	cmp    %dl,%cl
 265:	75 f1                	jne    258 <strchr+0x18>
      return (char*)s;
  return 0;
}
 267:	5d                   	pop    %ebp
 268:	c3                   	ret
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 270:	31 c0                	xor    %eax,%eax
}
 272:	5d                   	pop    %ebp
 273:	c3                   	ret
 274:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27b:	00 
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <gets>:

char*
gets(char *buf, int max)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 285:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 288:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 289:	31 db                	xor    %ebx,%ebx
{
 28b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 28e:	eb 27                	jmp    2b7 <gets+0x37>
    cc = read(0, &c, 1);
 290:	83 ec 04             	sub    $0x4,%esp
 293:	6a 01                	push   $0x1
 295:	56                   	push   %esi
 296:	6a 00                	push   $0x0
 298:	e8 1e 01 00 00       	call   3bb <read>
    if(cc < 1)
 29d:	83 c4 10             	add    $0x10,%esp
 2a0:	85 c0                	test   %eax,%eax
 2a2:	7e 1d                	jle    2c1 <gets+0x41>
      break;
    buf[i++] = c;
 2a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
 2ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2af:	3c 0a                	cmp    $0xa,%al
 2b1:	74 10                	je     2c3 <gets+0x43>
 2b3:	3c 0d                	cmp    $0xd,%al
 2b5:	74 0c                	je     2c3 <gets+0x43>
  for(i=0; i+1 < max; ){
 2b7:	89 df                	mov    %ebx,%edi
 2b9:	83 c3 01             	add    $0x1,%ebx
 2bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2bf:	7c cf                	jl     290 <gets+0x10>
 2c1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 2ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2cd:	5b                   	pop    %ebx
 2ce:	5e                   	pop    %esi
 2cf:	5f                   	pop    %edi
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret
 2d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2d9:	00 
 2da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	6a 00                	push   $0x0
 2ea:	ff 75 08             	push   0x8(%ebp)
 2ed:	e8 f1 00 00 00       	call   3e3 <open>
  if(fd < 0)
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	78 27                	js     320 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	ff 75 0c             	push   0xc(%ebp)
 2ff:	89 c3                	mov    %eax,%ebx
 301:	50                   	push   %eax
 302:	e8 f4 00 00 00       	call   3fb <fstat>
  close(fd);
 307:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 30a:	89 c6                	mov    %eax,%esi
  close(fd);
 30c:	e8 ba 00 00 00       	call   3cb <close>
  return r;
 311:	83 c4 10             	add    $0x10,%esp
}
 314:	8d 65 f8             	lea    -0x8(%ebp),%esp
 317:	89 f0                	mov    %esi,%eax
 319:	5b                   	pop    %ebx
 31a:	5e                   	pop    %esi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 320:	be ff ff ff ff       	mov    $0xffffffff,%esi
 325:	eb ed                	jmp    314 <stat+0x34>
 327:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32e:	00 
 32f:	90                   	nop

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 337:	0f be 02             	movsbl (%edx),%eax
 33a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 33d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 340:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 345:	77 1e                	ja     365 <atoi+0x35>
 347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 34e:	00 
 34f:	90                   	nop
    n = n*10 + *s++ - '0';
 350:	83 c2 01             	add    $0x1,%edx
 353:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 356:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 35a:	0f be 02             	movsbl (%edx),%eax
 35d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 360:	80 fb 09             	cmp    $0x9,%bl
 363:	76 eb                	jbe    350 <atoi+0x20>
  return n;
}
 365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 368:	89 c8                	mov    %ecx,%eax
 36a:	c9                   	leave
 36b:	c3                   	ret
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	8b 45 10             	mov    0x10(%ebp),%eax
 377:	8b 55 08             	mov    0x8(%ebp),%edx
 37a:	56                   	push   %esi
 37b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37e:	85 c0                	test   %eax,%eax
 380:	7e 13                	jle    395 <memmove+0x25>
 382:	01 d0                	add    %edx,%eax
  dst = vdst;
 384:	89 d7                	mov    %edx,%edi
 386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38d:	00 
 38e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 391:	39 f8                	cmp    %edi,%eax
 393:	75 fb                	jne    390 <memmove+0x20>
  return vdst;
}
 395:	5e                   	pop    %esi
 396:	89 d0                	mov    %edx,%eax
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <cscount>:
SYSCALL(cscount)
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <wait2>:
SYSCALL(wait2)
 44b:	b8 17 00 00 00       	mov    $0x17,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <set_priority>:
SYSCALL(set_priority)
 453:	b8 18 00 00 00       	mov    $0x18,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <set_quanta>:
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret
 463:	66 90                	xchg   %ax,%ax
 465:	66 90                	xchg   %ax,%ax
 467:	66 90                	xchg   %ax,%ax
 469:	66 90                	xchg   %ax,%ax
 46b:	66 90                	xchg   %ax,%ax
 46d:	66 90                	xchg   %ax,%ax
 46f:	90                   	nop

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 478:	89 d1                	mov    %edx,%ecx
{
 47a:	83 ec 3c             	sub    $0x3c,%esp
 47d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 480:	85 d2                	test   %edx,%edx
 482:	0f 89 80 00 00 00    	jns    508 <printint+0x98>
 488:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 48c:	74 7a                	je     508 <printint+0x98>
    x = -xx;
 48e:	f7 d9                	neg    %ecx
    neg = 1;
 490:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 495:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 498:	31 f6                	xor    %esi,%esi
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4a0:	89 c8                	mov    %ecx,%eax
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	89 f7                	mov    %esi,%edi
 4a6:	f7 f3                	div    %ebx
 4a8:	8d 76 01             	lea    0x1(%esi),%esi
 4ab:	0f b6 92 78 09 00 00 	movzbl 0x978(%edx),%edx
 4b2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4b6:	89 ca                	mov    %ecx,%edx
 4b8:	89 c1                	mov    %eax,%ecx
 4ba:	39 da                	cmp    %ebx,%edx
 4bc:	73 e2                	jae    4a0 <printint+0x30>
  if(neg)
 4be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4c1:	85 c0                	test   %eax,%eax
 4c3:	74 07                	je     4cc <printint+0x5c>
    buf[i++] = '-';
 4c5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 4ca:	89 f7                	mov    %esi,%edi
 4cc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4cf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 4d2:	01 df                	add    %ebx,%edi
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 4d8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 4db:	83 ec 04             	sub    $0x4,%esp
 4de:	88 45 d7             	mov    %al,-0x29(%ebp)
 4e1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 4e4:	6a 01                	push   $0x1
 4e6:	50                   	push   %eax
 4e7:	56                   	push   %esi
 4e8:	e8 d6 fe ff ff       	call   3c3 <write>
  while(--i >= 0)
 4ed:	89 f8                	mov    %edi,%eax
 4ef:	83 c4 10             	add    $0x10,%esp
 4f2:	83 ef 01             	sub    $0x1,%edi
 4f5:	39 c3                	cmp    %eax,%ebx
 4f7:	75 df                	jne    4d8 <printint+0x68>
}
 4f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fc:	5b                   	pop    %ebx
 4fd:	5e                   	pop    %esi
 4fe:	5f                   	pop    %edi
 4ff:	5d                   	pop    %ebp
 500:	c3                   	ret
 501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 508:	31 c0                	xor    %eax,%eax
 50a:	eb 89                	jmp    495 <printint+0x25>
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000510 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 519:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 51c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 51f:	0f b6 1e             	movzbl (%esi),%ebx
 522:	83 c6 01             	add    $0x1,%esi
 525:	84 db                	test   %bl,%bl
 527:	74 67                	je     590 <printf+0x80>
 529:	8d 4d 10             	lea    0x10(%ebp),%ecx
 52c:	31 d2                	xor    %edx,%edx
 52e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 531:	eb 34                	jmp    567 <printf+0x57>
 533:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 538:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 53b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 540:	83 f8 25             	cmp    $0x25,%eax
 543:	74 18                	je     55d <printf+0x4d>
  write(fd, &c, 1);
 545:	83 ec 04             	sub    $0x4,%esp
 548:	8d 45 e7             	lea    -0x19(%ebp),%eax
 54b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 54e:	6a 01                	push   $0x1
 550:	50                   	push   %eax
 551:	57                   	push   %edi
 552:	e8 6c fe ff ff       	call   3c3 <write>
 557:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 55a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 55d:	0f b6 1e             	movzbl (%esi),%ebx
 560:	83 c6 01             	add    $0x1,%esi
 563:	84 db                	test   %bl,%bl
 565:	74 29                	je     590 <printf+0x80>
    c = fmt[i] & 0xff;
 567:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 56a:	85 d2                	test   %edx,%edx
 56c:	74 ca                	je     538 <printf+0x28>
      }
    } else if(state == '%'){
 56e:	83 fa 25             	cmp    $0x25,%edx
 571:	75 ea                	jne    55d <printf+0x4d>
      if(c == 'd'){
 573:	83 f8 25             	cmp    $0x25,%eax
 576:	0f 84 04 01 00 00    	je     680 <printf+0x170>
 57c:	83 e8 63             	sub    $0x63,%eax
 57f:	83 f8 15             	cmp    $0x15,%eax
 582:	77 1c                	ja     5a0 <printf+0x90>
 584:	ff 24 85 20 09 00 00 	jmp    *0x920(,%eax,4)
 58b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 590:	8d 65 f4             	lea    -0xc(%ebp),%esp
 593:	5b                   	pop    %ebx
 594:	5e                   	pop    %esi
 595:	5f                   	pop    %edi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret
 598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 59f:	00 
  write(fd, &c, 1);
 5a0:	83 ec 04             	sub    $0x4,%esp
 5a3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5a6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5aa:	6a 01                	push   $0x1
 5ac:	52                   	push   %edx
 5ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5b0:	57                   	push   %edi
 5b1:	e8 0d fe ff ff       	call   3c3 <write>
 5b6:	83 c4 0c             	add    $0xc,%esp
 5b9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5bc:	6a 01                	push   $0x1
 5be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5c1:	52                   	push   %edx
 5c2:	57                   	push   %edi
 5c3:	e8 fb fd ff ff       	call   3c3 <write>
        putc(fd, c);
 5c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cb:	31 d2                	xor    %edx,%edx
 5cd:	eb 8e                	jmp    55d <printf+0x4d>
 5cf:	90                   	nop
        printint(fd, *ap, 16, 0);
 5d0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5d3:	83 ec 0c             	sub    $0xc,%esp
 5d6:	b9 10 00 00 00       	mov    $0x10,%ecx
 5db:	8b 13                	mov    (%ebx),%edx
 5dd:	6a 00                	push   $0x0
 5df:	89 f8                	mov    %edi,%eax
        ap++;
 5e1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 5e4:	e8 87 fe ff ff       	call   470 <printint>
        ap++;
 5e9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ef:	31 d2                	xor    %edx,%edx
 5f1:	e9 67 ff ff ff       	jmp    55d <printf+0x4d>
        s = (char*)*ap;
 5f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5f9:	8b 18                	mov    (%eax),%ebx
        ap++;
 5fb:	83 c0 04             	add    $0x4,%eax
 5fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 601:	85 db                	test   %ebx,%ebx
 603:	0f 84 87 00 00 00    	je     690 <printf+0x180>
        while(*s != 0){
 609:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 60c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 60e:	84 c0                	test   %al,%al
 610:	0f 84 47 ff ff ff    	je     55d <printf+0x4d>
 616:	8d 55 e7             	lea    -0x19(%ebp),%edx
 619:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 61c:	89 de                	mov    %ebx,%esi
 61e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 626:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 629:	6a 01                	push   $0x1
 62b:	53                   	push   %ebx
 62c:	57                   	push   %edi
 62d:	e8 91 fd ff ff       	call   3c3 <write>
        while(*s != 0){
 632:	0f b6 06             	movzbl (%esi),%eax
 635:	83 c4 10             	add    $0x10,%esp
 638:	84 c0                	test   %al,%al
 63a:	75 e4                	jne    620 <printf+0x110>
      state = 0;
 63c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 63f:	31 d2                	xor    %edx,%edx
 641:	e9 17 ff ff ff       	jmp    55d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 646:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 649:	83 ec 0c             	sub    $0xc,%esp
 64c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 651:	8b 13                	mov    (%ebx),%edx
 653:	6a 01                	push   $0x1
 655:	eb 88                	jmp    5df <printf+0xcf>
        putc(fd, *ap);
 657:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 65a:	83 ec 04             	sub    $0x4,%esp
 65d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 660:	8b 03                	mov    (%ebx),%eax
        ap++;
 662:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 665:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 668:	6a 01                	push   $0x1
 66a:	52                   	push   %edx
 66b:	57                   	push   %edi
 66c:	e8 52 fd ff ff       	call   3c3 <write>
        ap++;
 671:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 674:	83 c4 10             	add    $0x10,%esp
      state = 0;
 677:	31 d2                	xor    %edx,%edx
 679:	e9 df fe ff ff       	jmp    55d <printf+0x4d>
 67e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 680:	83 ec 04             	sub    $0x4,%esp
 683:	88 5d e7             	mov    %bl,-0x19(%ebp)
 686:	8d 55 e7             	lea    -0x19(%ebp),%edx
 689:	6a 01                	push   $0x1
 68b:	e9 31 ff ff ff       	jmp    5c1 <printf+0xb1>
 690:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 695:	bb 5d 08 00 00       	mov    $0x85d,%ebx
 69a:	e9 77 ff ff ff       	jmp    616 <printf+0x106>
 69f:	90                   	nop

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 40 0c 00 00       	mov    0xc40,%eax
{
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	57                   	push   %edi
 6a9:	56                   	push   %esi
 6aa:	53                   	push   %ebx
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	39 c8                	cmp    %ecx,%eax
 6bc:	73 32                	jae    6f0 <free+0x50>
 6be:	39 d1                	cmp    %edx,%ecx
 6c0:	72 04                	jb     6c6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	39 d0                	cmp    %edx,%eax
 6c4:	72 32                	jb     6f8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6cc:	39 fa                	cmp    %edi,%edx
 6ce:	74 30                	je     700 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d9:	39 f1                	cmp    %esi,%ecx
 6db:	74 3a                	je     717 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6dd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6df:	5b                   	pop    %ebx
  freep = p;
 6e0:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 6e5:	5e                   	pop    %esi
 6e6:	5f                   	pop    %edi
 6e7:	5d                   	pop    %ebp
 6e8:	c3                   	ret
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 d0                	cmp    %edx,%eax
 6f2:	72 04                	jb     6f8 <free+0x58>
 6f4:	39 d1                	cmp    %edx,%ecx
 6f6:	72 ce                	jb     6c6 <free+0x26>
{
 6f8:	89 d0                	mov    %edx,%eax
 6fa:	eb bc                	jmp    6b8 <free+0x18>
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 700:	03 72 04             	add    0x4(%edx),%esi
 703:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 12                	mov    (%edx),%edx
 70a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 70d:	8b 50 04             	mov    0x4(%eax),%edx
 710:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 713:	39 f1                	cmp    %esi,%ecx
 715:	75 c6                	jne    6dd <free+0x3d>
    p->s.size += bp->s.size;
 717:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 71a:	a3 40 0c 00 00       	mov    %eax,0xc40
    p->s.size += bp->s.size;
 71f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 722:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 725:	89 08                	mov    %ecx,(%eax)
}
 727:	5b                   	pop    %ebx
 728:	5e                   	pop    %esi
 729:	5f                   	pop    %edi
 72a:	5d                   	pop    %ebp
 72b:	c3                   	ret
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 73c:	8b 15 40 0c 00 00    	mov    0xc40,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 742:	8d 78 07             	lea    0x7(%eax),%edi
 745:	c1 ef 03             	shr    $0x3,%edi
 748:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 74b:	85 d2                	test   %edx,%edx
 74d:	0f 84 8d 00 00 00    	je     7e0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 753:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 755:	8b 48 04             	mov    0x4(%eax),%ecx
 758:	39 f9                	cmp    %edi,%ecx
 75a:	73 64                	jae    7c0 <malloc+0x90>
  if(nu < 4096)
 75c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 761:	39 df                	cmp    %ebx,%edi
 763:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 766:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 76d:	eb 0a                	jmp    779 <malloc+0x49>
 76f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 770:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 772:	8b 48 04             	mov    0x4(%eax),%ecx
 775:	39 f9                	cmp    %edi,%ecx
 777:	73 47                	jae    7c0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 779:	89 c2                	mov    %eax,%edx
 77b:	3b 05 40 0c 00 00    	cmp    0xc40,%eax
 781:	75 ed                	jne    770 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	56                   	push   %esi
 787:	e8 9f fc ff ff       	call   42b <sbrk>
  if(p == (char*)-1)
 78c:	83 c4 10             	add    $0x10,%esp
 78f:	83 f8 ff             	cmp    $0xffffffff,%eax
 792:	74 1c                	je     7b0 <malloc+0x80>
  hp->s.size = nu;
 794:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 797:	83 ec 0c             	sub    $0xc,%esp
 79a:	83 c0 08             	add    $0x8,%eax
 79d:	50                   	push   %eax
 79e:	e8 fd fe ff ff       	call   6a0 <free>
  return freep;
 7a3:	8b 15 40 0c 00 00    	mov    0xc40,%edx
      if((p = morecore(nunits)) == 0)
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	85 d2                	test   %edx,%edx
 7ae:	75 c0                	jne    770 <malloc+0x40>
        return 0;
  }
}
 7b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7b3:	31 c0                	xor    %eax,%eax
}
 7b5:	5b                   	pop    %ebx
 7b6:	5e                   	pop    %esi
 7b7:	5f                   	pop    %edi
 7b8:	5d                   	pop    %ebp
 7b9:	c3                   	ret
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7c0:	39 cf                	cmp    %ecx,%edi
 7c2:	74 4c                	je     810 <malloc+0xe0>
        p->s.size -= nunits;
 7c4:	29 f9                	sub    %edi,%ecx
 7c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7cc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7cf:	89 15 40 0c 00 00    	mov    %edx,0xc40
}
 7d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7d8:	83 c0 08             	add    $0x8,%eax
}
 7db:	5b                   	pop    %ebx
 7dc:	5e                   	pop    %esi
 7dd:	5f                   	pop    %edi
 7de:	5d                   	pop    %ebp
 7df:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 7e0:	c7 05 40 0c 00 00 44 	movl   $0xc44,0xc40
 7e7:	0c 00 00 
    base.s.size = 0;
 7ea:	b8 44 0c 00 00       	mov    $0xc44,%eax
    base.s.ptr = freep = prevp = &base;
 7ef:	c7 05 44 0c 00 00 44 	movl   $0xc44,0xc44
 7f6:	0c 00 00 
    base.s.size = 0;
 7f9:	c7 05 48 0c 00 00 00 	movl   $0x0,0xc48
 800:	00 00 00 
    if(p->s.size >= nunits){
 803:	e9 54 ff ff ff       	jmp    75c <malloc+0x2c>
 808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 80f:	00 
        prevp->s.ptr = p->s.ptr;
 810:	8b 08                	mov    (%eax),%ecx
 812:	89 0a                	mov    %ecx,(%edx)
 814:	eb b9                	jmp    7cf <malloc+0x9f>
