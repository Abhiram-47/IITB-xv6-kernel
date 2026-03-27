
_tc-barrier:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }

    exit();
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	8d 75 e8             	lea    -0x18(%ebp),%esi
  12:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
  15:	51                   	push   %ecx
  16:	83 ec 34             	sub    $0x34,%esp

    int N = 5;
    int ind[N];
    for(int i=0;i<N;i++)
        ind[i]=i;
  19:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

    barrier_init(&bar,N);
  20:	6a 05                	push   $0x5
  22:	68 c4 0d 00 00       	push   $0xdc4
        ind[i]=i;
  27:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  2e:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
  35:	c7 45 e0 03 00 00 00 	movl   $0x3,-0x20(%ebp)
  3c:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
    barrier_init(&bar,N);
  43:	e8 58 00 00 00       	call   a0 <barrier_init>

    for(int i=0;i<N;i++) {
  48:	83 c4 10             	add    $0x10,%esp
  4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        create_thread(work, &ind[i]);
  50:	83 ec 08             	sub    $0x8,%esp
  53:	53                   	push   %ebx
    for(int i=0;i<N;i++) {
  54:	83 c3 04             	add    $0x4,%ebx
        create_thread(work, &ind[i]);
  57:	68 d0 01 00 00       	push   $0x1d0
  5c:	e8 3f 04 00 00       	call   4a0 <create_thread>
    for(int i=0;i<N;i++) {
  61:	83 c4 10             	add    $0x10,%esp
  64:	39 f3                	cmp    %esi,%ebx
  66:	75 e8                	jne    50 <main+0x50>
    }

    for(int i=0;i<N;i++) {
        join();
  68:	e8 0e 05 00 00       	call   57b <join>
  6d:	e8 09 05 00 00       	call   57b <join>
  72:	e8 04 05 00 00       	call   57b <join>
  77:	e8 ff 04 00 00       	call   57b <join>
  7c:	e8 fa 04 00 00       	call   57b <join>
    }

    printf(1, "All threads joined, code completed\n");
  81:	83 ec 08             	sub    $0x8,%esp
  84:	68 c0 09 00 00       	push   $0x9c0
  89:	6a 01                	push   $0x1
  8b:	e8 c0 05 00 00       	call   650 <printf>
    exit();
  90:	e8 3e 04 00 00       	call   4d3 <exit>
  95:	66 90                	xchg   %ax,%ax
  97:	66 90                	xchg   %ax,%ax
  99:	66 90                	xchg   %ax,%ax
  9b:	66 90                	xchg   %ax,%ax
  9d:	66 90                	xchg   %ax,%ax
  9f:	90                   	nop

000000a0 <barrier_init>:
void barrier_init(struct barrier* bar, int num_threads){
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	83 ec 10             	sub    $0x10,%esp
  a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bar->n = num_threads;
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    bar->count = 0;
  ad:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    bar->n = num_threads;
  b4:	89 03                	mov    %eax,(%ebx)
    bar->sem_mutex = semaphore_init(1);
  b6:	6a 01                	push   $0x1
  b8:	e8 c6 04 00 00       	call   583 <semaphore_init>
  bd:	89 43 08             	mov    %eax,0x8(%ebx)
    bar->sem_turnstile = semaphore_init(0);
  c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c7:	e8 b7 04 00 00       	call   583 <semaphore_init>
  cc:	89 43 0c             	mov    %eax,0xc(%ebx)
    bar->sem_turnstile2 = semaphore_init(0);
  cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  d6:	e8 a8 04 00 00       	call   583 <semaphore_init>
}
  db:	83 c4 10             	add    $0x10,%esp
    bar->sem_turnstile2 = semaphore_init(0);
  de:	89 43 10             	mov    %eax,0x10(%ebx)
}
  e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e4:	c9                   	leave
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax

000000f0 <phase1_barrier>:
void phase1_barrier(struct barrier* bar) {
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    semaphore_down(bar->sem_mutex);
  f8:	83 ec 0c             	sub    $0xc,%esp
  fb:	ff 73 08             	push   0x8(%ebx)
  fe:	e8 90 04 00 00       	call   593 <semaphore_down>
    if (++bar->count == bar->n) {
 103:	8b 43 04             	mov    0x4(%ebx),%eax
 106:	83 c4 10             	add    $0x10,%esp
 109:	83 c0 01             	add    $0x1,%eax
 10c:	89 43 04             	mov    %eax,0x4(%ebx)
 10f:	3b 03                	cmp    (%ebx),%eax
 111:	74 25                	je     138 <phase1_barrier+0x48>
    semaphore_up(bar->sem_mutex);
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	ff 73 08             	push   0x8(%ebx)
 119:	e8 7d 04 00 00       	call   59b <semaphore_up>
    semaphore_down(bar->sem_turnstile);
 11e:	8b 43 0c             	mov    0xc(%ebx),%eax
 121:	83 c4 10             	add    $0x10,%esp
 124:	89 45 08             	mov    %eax,0x8(%ebp)
}
 127:	8d 65 f8             	lea    -0x8(%ebp),%esp
 12a:	5b                   	pop    %ebx
 12b:	5e                   	pop    %esi
 12c:	5d                   	pop    %ebp
    semaphore_down(bar->sem_turnstile);
 12d:	e9 61 04 00 00       	jmp    593 <semaphore_down>
 132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for (int i = 0; i < bar->n; i++)
 138:	85 c0                	test   %eax,%eax
 13a:	7e d7                	jle    113 <phase1_barrier+0x23>
 13c:	31 f6                	xor    %esi,%esi
 13e:	66 90                	xchg   %ax,%ax
            semaphore_up(bar->sem_turnstile);
 140:	83 ec 0c             	sub    $0xc,%esp
 143:	ff 73 0c             	push   0xc(%ebx)
        for (int i = 0; i < bar->n; i++)
 146:	83 c6 01             	add    $0x1,%esi
            semaphore_up(bar->sem_turnstile);
 149:	e8 4d 04 00 00       	call   59b <semaphore_up>
        for (int i = 0; i < bar->n; i++)
 14e:	83 c4 10             	add    $0x10,%esp
 151:	39 33                	cmp    %esi,(%ebx)
 153:	7f eb                	jg     140 <phase1_barrier+0x50>
 155:	eb bc                	jmp    113 <phase1_barrier+0x23>
 157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 15e:	00 
 15f:	90                   	nop

00000160 <phase2_barrier>:
void phase2_barrier(struct barrier* bar) {
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	56                   	push   %esi
 164:	53                   	push   %ebx
 165:	8b 75 08             	mov    0x8(%ebp),%esi
    semaphore_down(bar->sem_mutex);
 168:	83 ec 0c             	sub    $0xc,%esp
 16b:	ff 76 08             	push   0x8(%esi)
 16e:	e8 20 04 00 00       	call   593 <semaphore_down>
    if (--bar->count == 0) {
 173:	8b 46 04             	mov    0x4(%esi),%eax
 176:	83 c4 10             	add    $0x10,%esp
 179:	8d 58 ff             	lea    -0x1(%eax),%ebx
 17c:	89 5e 04             	mov    %ebx,0x4(%esi)
 17f:	85 db                	test   %ebx,%ebx
 181:	75 22                	jne    1a5 <phase2_barrier+0x45>
        for (int i = 0; i < bar->n; i++)
 183:	8b 06                	mov    (%esi),%eax
 185:	85 c0                	test   %eax,%eax
 187:	7e 1c                	jle    1a5 <phase2_barrier+0x45>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            semaphore_up(bar->sem_turnstile2);
 190:	83 ec 0c             	sub    $0xc,%esp
 193:	ff 76 10             	push   0x10(%esi)
        for (int i = 0; i < bar->n; i++)
 196:	83 c3 01             	add    $0x1,%ebx
            semaphore_up(bar->sem_turnstile2);
 199:	e8 fd 03 00 00       	call   59b <semaphore_up>
        for (int i = 0; i < bar->n; i++)
 19e:	83 c4 10             	add    $0x10,%esp
 1a1:	39 1e                	cmp    %ebx,(%esi)
 1a3:	7f eb                	jg     190 <phase2_barrier+0x30>
    semaphore_up(bar->sem_mutex);
 1a5:	83 ec 0c             	sub    $0xc,%esp
 1a8:	ff 76 08             	push   0x8(%esi)
 1ab:	e8 eb 03 00 00       	call   59b <semaphore_up>
    semaphore_down(bar->sem_turnstile2);
 1b0:	8b 46 10             	mov    0x10(%esi),%eax
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 08             	mov    %eax,0x8(%ebp)
}
 1b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bc:	5b                   	pop    %ebx
 1bd:	5e                   	pop    %esi
 1be:	5d                   	pop    %ebp
    semaphore_down(bar->sem_turnstile2);
 1bf:	e9 cf 03 00 00       	jmp    593 <semaphore_down>
 1c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1cb:	00 
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001d0 <work>:
void work(int *thread_num){
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	8b 75 08             	mov    0x8(%ebp),%esi
 1d7:	53                   	push   %ebx
    for(int i=0;i<3;i++){
 1d8:	31 db                	xor    %ebx,%ebx
    phase1_barrier(bar);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	68 c4 0d 00 00       	push   $0xdc4
 1e2:	e8 09 ff ff ff       	call   f0 <phase1_barrier>
    phase2_barrier(bar);
 1e7:	c7 04 24 c4 0d 00 00 	movl   $0xdc4,(%esp)
 1ee:	e8 6d ff ff ff       	call   160 <phase2_barrier>
        printf(1,"LOOP %d | Section 1 of code | Thread Number: %d\n",i,*thread_num);
 1f3:	ff 36                	push   (%esi)
 1f5:	53                   	push   %ebx
 1f6:	68 58 09 00 00       	push   $0x958
 1fb:	6a 01                	push   $0x1
 1fd:	e8 4e 04 00 00       	call   650 <printf>
    phase1_barrier(bar);
 202:	83 c4 14             	add    $0x14,%esp
 205:	68 c4 0d 00 00       	push   $0xdc4
 20a:	e8 e1 fe ff ff       	call   f0 <phase1_barrier>
    phase2_barrier(bar);
 20f:	c7 04 24 c4 0d 00 00 	movl   $0xdc4,(%esp)
 216:	e8 45 ff ff ff       	call   160 <phase2_barrier>
        printf(1,"LOOP %d | Section 2 of code | Thread Number: %d\n",i,*thread_num);
 21b:	ff 36                	push   (%esi)
 21d:	53                   	push   %ebx
    for(int i=0;i<3;i++){
 21e:	83 c3 01             	add    $0x1,%ebx
        printf(1,"LOOP %d | Section 2 of code | Thread Number: %d\n",i,*thread_num);
 221:	68 8c 09 00 00       	push   $0x98c
 226:	6a 01                	push   $0x1
 228:	e8 23 04 00 00       	call   650 <printf>
    for(int i=0;i<3;i++){
 22d:	83 c4 20             	add    $0x20,%esp
 230:	83 fb 03             	cmp    $0x3,%ebx
 233:	75 a5                	jne    1da <work+0xa>
    exit();
 235:	e8 99 02 00 00       	call   4d3 <exit>
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <barrier_place>:
void barrier_place(struct barrier* bar){
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	83 ec 10             	sub    $0x10,%esp
 247:	8b 5d 08             	mov    0x8(%ebp),%ebx
    phase1_barrier(bar);
 24a:	53                   	push   %ebx
 24b:	e8 a0 fe ff ff       	call   f0 <phase1_barrier>
    phase2_barrier(bar);
 250:	83 c4 10             	add    $0x10,%esp
 253:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 259:	c9                   	leave
    phase2_barrier(bar);
 25a:	e9 01 ff ff ff       	jmp    160 <phase2_barrier>
 25f:	90                   	nop

00000260 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 260:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 261:	31 c0                	xor    %eax,%eax
{
 263:	89 e5                	mov    %esp,%ebp
 265:	53                   	push   %ebx
 266:	8b 4d 08             	mov    0x8(%ebp),%ecx
 269:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 270:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 274:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 277:	83 c0 01             	add    $0x1,%eax
 27a:	84 d2                	test   %dl,%dl
 27c:	75 f2                	jne    270 <strcpy+0x10>
    ;
  return os;
}
 27e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 281:	89 c8                	mov    %ecx,%eax
 283:	c9                   	leave
 284:	c3                   	ret
 285:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28c:	00 
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 55 08             	mov    0x8(%ebp),%edx
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 29a:	0f b6 02             	movzbl (%edx),%eax
 29d:	84 c0                	test   %al,%al
 29f:	75 17                	jne    2b8 <strcmp+0x28>
 2a1:	eb 3a                	jmp    2dd <strcmp+0x4d>
 2a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ac:	83 c2 01             	add    $0x1,%edx
 2af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2b2:	84 c0                	test   %al,%al
 2b4:	74 1a                	je     2d0 <strcmp+0x40>
 2b6:	89 d9                	mov    %ebx,%ecx
 2b8:	0f b6 19             	movzbl (%ecx),%ebx
 2bb:	38 c3                	cmp    %al,%bl
 2bd:	74 e9                	je     2a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2bf:	29 d8                	sub    %ebx,%eax
}
 2c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c4:	c9                   	leave
 2c5:	c3                   	ret
 2c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cd:	00 
 2ce:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2d4:	31 c0                	xor    %eax,%eax
 2d6:	29 d8                	sub    %ebx,%eax
}
 2d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2db:	c9                   	leave
 2dc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2dd:	0f b6 19             	movzbl (%ecx),%ebx
 2e0:	31 c0                	xor    %eax,%eax
 2e2:	eb db                	jmp    2bf <strcmp+0x2f>
 2e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2eb:	00 
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 3a 00             	cmpb   $0x0,(%edx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 c0                	xor    %eax,%eax
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c0 01             	add    $0x1,%eax
 303:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 307:	89 c1                	mov    %eax,%ecx
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret
 30f:	90                   	nop
  for(n = 0; s[n]; n++)
 310:	31 c9                	xor    %ecx,%ecx
}
 312:	5d                   	pop    %ebp
 313:	89 c8                	mov    %ecx,%eax
 315:	c3                   	ret
 316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 31d:	00 
 31e:	66 90                	xchg   %ax,%ax

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	8b 7d fc             	mov    -0x4(%ebp),%edi
 335:	89 d0                	mov    %edx,%eax
 337:	c9                   	leave
 338:	c3                   	ret
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	75 12                	jne    363 <strchr+0x23>
 351:	eb 1d                	jmp    370 <strchr+0x30>
 353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 35c:	83 c0 01             	add    $0x1,%eax
 35f:	84 d2                	test   %dl,%dl
 361:	74 0d                	je     370 <strchr+0x30>
    if(*s == c)
 363:	38 d1                	cmp    %dl,%cl
 365:	75 f1                	jne    358 <strchr+0x18>
      return (char*)s;
  return 0;
}
 367:	5d                   	pop    %ebp
 368:	c3                   	ret
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 370:	31 c0                	xor    %eax,%eax
}
 372:	5d                   	pop    %ebp
 373:	c3                   	ret
 374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37b:	00 
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 385:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 388:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 389:	31 db                	xor    %ebx,%ebx
{
 38b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 38e:	eb 27                	jmp    3b7 <gets+0x37>
    cc = read(0, &c, 1);
 390:	83 ec 04             	sub    $0x4,%esp
 393:	6a 01                	push   $0x1
 395:	56                   	push   %esi
 396:	6a 00                	push   $0x0
 398:	e8 4e 01 00 00       	call   4eb <read>
    if(cc < 1)
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	85 c0                	test   %eax,%eax
 3a2:	7e 1d                	jle    3c1 <gets+0x41>
      break;
    buf[i++] = c;
 3a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
 3ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3af:	3c 0a                	cmp    $0xa,%al
 3b1:	74 10                	je     3c3 <gets+0x43>
 3b3:	3c 0d                	cmp    $0xd,%al
 3b5:	74 0c                	je     3c3 <gets+0x43>
  for(i=0; i+1 < max; ){
 3b7:	89 df                	mov    %ebx,%edi
 3b9:	83 c3 01             	add    $0x1,%ebx
 3bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3bf:	7c cf                	jl     390 <gets+0x10>
 3c1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 3ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cd:	5b                   	pop    %ebx
 3ce:	5e                   	pop    %esi
 3cf:	5f                   	pop    %edi
 3d0:	5d                   	pop    %ebp
 3d1:	c3                   	ret
 3d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3d9:	00 
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	push   0x8(%ebp)
 3ed:	e8 21 01 00 00       	call   513 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	push   0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 24 01 00 00       	call   52b <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 ea 00 00 00       	call   4fb <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42e:	00 
 42f:	90                   	nop

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 02             	movsbl (%edx),%eax
 43a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 43d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 440:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 445:	77 1e                	ja     465 <atoi+0x35>
 447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 44e:	00 
 44f:	90                   	nop
    n = n*10 + *s++ - '0';
 450:	83 c2 01             	add    $0x1,%edx
 453:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 456:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 45a:	0f be 02             	movsbl (%edx),%eax
 45d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 468:	89 c8                	mov    %ecx,%eax
 46a:	c9                   	leave
 46b:	c3                   	ret
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 45 10             	mov    0x10(%ebp),%eax
 477:	8b 55 08             	mov    0x8(%ebp),%edx
 47a:	56                   	push   %esi
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 c0                	test   %eax,%eax
 480:	7e 13                	jle    495 <memmove+0x25>
 482:	01 d0                	add    %edx,%eax
  dst = vdst;
 484:	89 d7                	mov    %edx,%edi
 486:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48d:	00 
 48e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 490:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 491:	39 f8                	cmp    %edi,%eax
 493:	75 fb                	jne    490 <memmove+0x20>
  return vdst;
}
 495:	5e                   	pop    %esi
 496:	89 d0                	mov    %edx,%eax
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret
 49b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000004a0 <create_thread>:

int create_thread(void(*fn)(int*), int *arg)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	83 ec 14             	sub    $0x14,%esp
  // ******************************
  // WPTHREAD -- START
  // ******************************
  int thread_id;
  void* uva_stack = malloc(4096);
 4a6:	68 00 10 00 00       	push   $0x1000
 4ab:	e8 c0 03 00 00       	call   870 <malloc>

  if ((thread_id = clone(fn, arg, uva_stack)) < 0)
 4b0:	83 c4 0c             	add    $0xc,%esp
 4b3:	50                   	push   %eax
 4b4:	ff 75 0c             	push   0xc(%ebp)
 4b7:	ff 75 08             	push   0x8(%ebp)
 4ba:	e8 b4 00 00 00       	call   573 <clone>
 4bf:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    return -1;
  return thread_id;
  // ******************************
  // WPTHREAD -- END
  // ******************************
}
 4c4:	c9                   	leave
  if ((thread_id = clone(fn, arg, uva_stack)) < 0)
 4c5:	85 c0                	test   %eax,%eax
 4c7:	0f 48 c2             	cmovs  %edx,%eax
}
 4ca:	c3                   	ret

000004cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4cb:	b8 01 00 00 00       	mov    $0x1,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <exit>:
SYSCALL(exit)
 4d3:	b8 02 00 00 00       	mov    $0x2,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <wait>:
SYSCALL(wait)
 4db:	b8 03 00 00 00       	mov    $0x3,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <pipe>:
SYSCALL(pipe)
 4e3:	b8 04 00 00 00       	mov    $0x4,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <read>:
SYSCALL(read)
 4eb:	b8 05 00 00 00       	mov    $0x5,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <write>:
SYSCALL(write)
 4f3:	b8 10 00 00 00       	mov    $0x10,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <close>:
SYSCALL(close)
 4fb:	b8 15 00 00 00       	mov    $0x15,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <kill>:
SYSCALL(kill)
 503:	b8 06 00 00 00       	mov    $0x6,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <exec>:
SYSCALL(exec)
 50b:	b8 07 00 00 00       	mov    $0x7,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <open>:
SYSCALL(open)
 513:	b8 0f 00 00 00       	mov    $0xf,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <mknod>:
SYSCALL(mknod)
 51b:	b8 11 00 00 00       	mov    $0x11,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <unlink>:
SYSCALL(unlink)
 523:	b8 12 00 00 00       	mov    $0x12,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <fstat>:
SYSCALL(fstat)
 52b:	b8 08 00 00 00       	mov    $0x8,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <link>:
SYSCALL(link)
 533:	b8 13 00 00 00       	mov    $0x13,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <mkdir>:
SYSCALL(mkdir)
 53b:	b8 14 00 00 00       	mov    $0x14,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <chdir>:
SYSCALL(chdir)
 543:	b8 09 00 00 00       	mov    $0x9,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <dup>:
SYSCALL(dup)
 54b:	b8 0a 00 00 00       	mov    $0xa,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <getpid>:
SYSCALL(getpid)
 553:	b8 0b 00 00 00       	mov    $0xb,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <sbrk>:
SYSCALL(sbrk)
 55b:	b8 0c 00 00 00       	mov    $0xc,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <sleep>:
SYSCALL(sleep)
 563:	b8 0d 00 00 00       	mov    $0xd,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <uptime>:
SYSCALL(uptime)
 56b:	b8 0e 00 00 00       	mov    $0xe,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <clone>:
SYSCALL(clone)
 573:	b8 16 00 00 00       	mov    $0x16,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <join>:
SYSCALL(join)
 57b:	b8 17 00 00 00       	mov    $0x17,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <semaphore_init>:
SYSCALL(semaphore_init)
 583:	b8 18 00 00 00       	mov    $0x18,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <semaphore_destroy>:
SYSCALL(semaphore_destroy)
 58b:	b8 19 00 00 00       	mov    $0x19,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <semaphore_down>:
SYSCALL(semaphore_down)
 593:	b8 1a 00 00 00       	mov    $0x1a,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <semaphore_up>:
SYSCALL(semaphore_up)
 59b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret
 5a3:	66 90                	xchg   %ax,%ax
 5a5:	66 90                	xchg   %ax,%ax
 5a7:	66 90                	xchg   %ax,%ax
 5a9:	66 90                	xchg   %ax,%ax
 5ab:	66 90                	xchg   %ax,%ax
 5ad:	66 90                	xchg   %ax,%ax
 5af:	90                   	nop

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5b8:	89 d1                	mov    %edx,%ecx
{
 5ba:	83 ec 3c             	sub    $0x3c,%esp
 5bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5c0:	85 d2                	test   %edx,%edx
 5c2:	0f 89 80 00 00 00    	jns    648 <printint+0x98>
 5c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5cc:	74 7a                	je     648 <printint+0x98>
    x = -xx;
 5ce:	f7 d9                	neg    %ecx
    neg = 1;
 5d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5d8:	31 f6                	xor    %esi,%esi
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5e0:	89 c8                	mov    %ecx,%eax
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	89 f7                	mov    %esi,%edi
 5e6:	f7 f3                	div    %ebx
 5e8:	8d 76 01             	lea    0x1(%esi),%esi
 5eb:	0f b6 92 44 0a 00 00 	movzbl 0xa44(%edx),%edx
 5f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5f6:	89 ca                	mov    %ecx,%edx
 5f8:	89 c1                	mov    %eax,%ecx
 5fa:	39 da                	cmp    %ebx,%edx
 5fc:	73 e2                	jae    5e0 <printint+0x30>
  if(neg)
 5fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 601:	85 c0                	test   %eax,%eax
 603:	74 07                	je     60c <printint+0x5c>
    buf[i++] = '-';
 605:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 60a:	89 f7                	mov    %esi,%edi
 60c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 60f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 612:	01 df                	add    %ebx,%edi
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 618:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	88 45 d7             	mov    %al,-0x29(%ebp)
 621:	8d 45 d7             	lea    -0x29(%ebp),%eax
 624:	6a 01                	push   $0x1
 626:	50                   	push   %eax
 627:	56                   	push   %esi
 628:	e8 c6 fe ff ff       	call   4f3 <write>
  while(--i >= 0)
 62d:	89 f8                	mov    %edi,%eax
 62f:	83 c4 10             	add    $0x10,%esp
 632:	83 ef 01             	sub    $0x1,%edi
 635:	39 c3                	cmp    %eax,%ebx
 637:	75 df                	jne    618 <printint+0x68>
}
 639:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63c:	5b                   	pop    %ebx
 63d:	5e                   	pop    %esi
 63e:	5f                   	pop    %edi
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 648:	31 c0                	xor    %eax,%eax
 64a:	eb 89                	jmp    5d5 <printint+0x25>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 659:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 65c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 65f:	0f b6 1e             	movzbl (%esi),%ebx
 662:	83 c6 01             	add    $0x1,%esi
 665:	84 db                	test   %bl,%bl
 667:	74 67                	je     6d0 <printf+0x80>
 669:	8d 4d 10             	lea    0x10(%ebp),%ecx
 66c:	31 d2                	xor    %edx,%edx
 66e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 671:	eb 34                	jmp    6a7 <printf+0x57>
 673:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 678:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 67b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 680:	83 f8 25             	cmp    $0x25,%eax
 683:	74 18                	je     69d <printf+0x4d>
  write(fd, &c, 1);
 685:	83 ec 04             	sub    $0x4,%esp
 688:	8d 45 e7             	lea    -0x19(%ebp),%eax
 68b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 68e:	6a 01                	push   $0x1
 690:	50                   	push   %eax
 691:	57                   	push   %edi
 692:	e8 5c fe ff ff       	call   4f3 <write>
 697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 69a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 69d:	0f b6 1e             	movzbl (%esi),%ebx
 6a0:	83 c6 01             	add    $0x1,%esi
 6a3:	84 db                	test   %bl,%bl
 6a5:	74 29                	je     6d0 <printf+0x80>
    c = fmt[i] & 0xff;
 6a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6aa:	85 d2                	test   %edx,%edx
 6ac:	74 ca                	je     678 <printf+0x28>
      }
    } else if(state == '%'){
 6ae:	83 fa 25             	cmp    $0x25,%edx
 6b1:	75 ea                	jne    69d <printf+0x4d>
      if(c == 'd'){
 6b3:	83 f8 25             	cmp    $0x25,%eax
 6b6:	0f 84 04 01 00 00    	je     7c0 <printf+0x170>
 6bc:	83 e8 63             	sub    $0x63,%eax
 6bf:	83 f8 15             	cmp    $0x15,%eax
 6c2:	77 1c                	ja     6e0 <printf+0x90>
 6c4:	ff 24 85 ec 09 00 00 	jmp    *0x9ec(,%eax,4)
 6cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret
 6d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6df:	00 
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ea:	6a 01                	push   $0x1
 6ec:	52                   	push   %edx
 6ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6f0:	57                   	push   %edi
 6f1:	e8 fd fd ff ff       	call   4f3 <write>
 6f6:	83 c4 0c             	add    $0xc,%esp
 6f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6fc:	6a 01                	push   $0x1
 6fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 701:	52                   	push   %edx
 702:	57                   	push   %edi
 703:	e8 eb fd ff ff       	call   4f3 <write>
        putc(fd, c);
 708:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70b:	31 d2                	xor    %edx,%edx
 70d:	eb 8e                	jmp    69d <printf+0x4d>
 70f:	90                   	nop
        printint(fd, *ap, 16, 0);
 710:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 713:	83 ec 0c             	sub    $0xc,%esp
 716:	b9 10 00 00 00       	mov    $0x10,%ecx
 71b:	8b 13                	mov    (%ebx),%edx
 71d:	6a 00                	push   $0x0
 71f:	89 f8                	mov    %edi,%eax
        ap++;
 721:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 724:	e8 87 fe ff ff       	call   5b0 <printint>
        ap++;
 729:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 72c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72f:	31 d2                	xor    %edx,%edx
 731:	e9 67 ff ff ff       	jmp    69d <printf+0x4d>
        s = (char*)*ap;
 736:	8b 45 d0             	mov    -0x30(%ebp),%eax
 739:	8b 18                	mov    (%eax),%ebx
        ap++;
 73b:	83 c0 04             	add    $0x4,%eax
 73e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 741:	85 db                	test   %ebx,%ebx
 743:	0f 84 87 00 00 00    	je     7d0 <printf+0x180>
        while(*s != 0){
 749:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 74c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 74e:	84 c0                	test   %al,%al
 750:	0f 84 47 ff ff ff    	je     69d <printf+0x4d>
 756:	8d 55 e7             	lea    -0x19(%ebp),%edx
 759:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75c:	89 de                	mov    %ebx,%esi
 75e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 766:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	53                   	push   %ebx
 76c:	57                   	push   %edi
 76d:	e8 81 fd ff ff       	call   4f3 <write>
        while(*s != 0){
 772:	0f b6 06             	movzbl (%esi),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x110>
      state = 0;
 77c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 17 ff ff ff       	jmp    69d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 786:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 789:	83 ec 0c             	sub    $0xc,%esp
 78c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 791:	8b 13                	mov    (%ebx),%edx
 793:	6a 01                	push   $0x1
 795:	eb 88                	jmp    71f <printf+0xcf>
        putc(fd, *ap);
 797:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 79a:	83 ec 04             	sub    $0x4,%esp
 79d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
 7aa:	52                   	push   %edx
 7ab:	57                   	push   %edi
 7ac:	e8 42 fd ff ff       	call   4f3 <write>
        ap++;
 7b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7b7:	31 d2                	xor    %edx,%edx
 7b9:	e9 df fe ff ff       	jmp    69d <printf+0x4d>
 7be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c9:	6a 01                	push   $0x1
 7cb:	e9 31 ff ff ff       	jmp    701 <printf+0xb1>
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7d5:	bb e4 09 00 00       	mov    $0x9e4,%ebx
 7da:	e9 77 ff ff ff       	jmp    756 <printf+0x106>
 7df:	90                   	nop

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 d8 0d 00 00       	mov    0xdd8,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	39 c8                	cmp    %ecx,%eax
 7fc:	73 32                	jae    830 <free+0x50>
 7fe:	39 d1                	cmp    %edx,%ecx
 800:	72 04                	jb     806 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	39 d0                	cmp    %edx,%eax
 804:	72 32                	jb     838 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 806:	8b 73 fc             	mov    -0x4(%ebx),%esi
 809:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80c:	39 fa                	cmp    %edi,%edx
 80e:	74 30                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 819:	39 f1                	cmp    %esi,%ecx
 81b:	74 3a                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 81d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 81f:	5b                   	pop    %ebx
  freep = p;
 820:	a3 d8 0d 00 00       	mov    %eax,0xdd8
}
 825:	5e                   	pop    %esi
 826:	5f                   	pop    %edi
 827:	5d                   	pop    %ebp
 828:	c3                   	ret
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 04                	jb     838 <free+0x58>
 834:	39 d1                	cmp    %edx,%ecx
 836:	72 ce                	jb     806 <free+0x26>
{
 838:	89 d0                	mov    %edx,%eax
 83a:	eb bc                	jmp    7f8 <free+0x18>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 c6                	jne    81d <free+0x3d>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 d8 0d 00 00       	mov    %eax,0xdd8
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 865:	89 08                	mov    %ecx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 d8 0d 00 00    	mov    0xdd8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 78 07             	lea    0x7(%eax),%edi
 885:	c1 ef 03             	shr    $0x3,%edi
 888:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 88b:	85 d2                	test   %edx,%edx
 88d:	0f 84 8d 00 00 00    	je     920 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 895:	8b 48 04             	mov    0x4(%eax),%ecx
 898:	39 f9                	cmp    %edi,%ecx
 89a:	73 64                	jae    900 <malloc+0x90>
  if(nu < 4096)
 89c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a1:	39 df                	cmp    %ebx,%edi
 8a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8ad:	eb 0a                	jmp    8b9 <malloc+0x49>
 8af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b2:	8b 48 04             	mov    0x4(%eax),%ecx
 8b5:	39 f9                	cmp    %edi,%ecx
 8b7:	73 47                	jae    900 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b9:	89 c2                	mov    %eax,%edx
 8bb:	3b 05 d8 0d 00 00    	cmp    0xdd8,%eax
 8c1:	75 ed                	jne    8b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8c3:	83 ec 0c             	sub    $0xc,%esp
 8c6:	56                   	push   %esi
 8c7:	e8 8f fc ff ff       	call   55b <sbrk>
  if(p == (char*)-1)
 8cc:	83 c4 10             	add    $0x10,%esp
 8cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d2:	74 1c                	je     8f0 <malloc+0x80>
  hp->s.size = nu;
 8d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8d7:	83 ec 0c             	sub    $0xc,%esp
 8da:	83 c0 08             	add    $0x8,%eax
 8dd:	50                   	push   %eax
 8de:	e8 fd fe ff ff       	call   7e0 <free>
  return freep;
 8e3:	8b 15 d8 0d 00 00    	mov    0xdd8,%edx
      if((p = morecore(nunits)) == 0)
 8e9:	83 c4 10             	add    $0x10,%esp
 8ec:	85 d2                	test   %edx,%edx
 8ee:	75 c0                	jne    8b0 <malloc+0x40>
        return 0;
  }
}
 8f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8f3:	31 c0                	xor    %eax,%eax
}
 8f5:	5b                   	pop    %ebx
 8f6:	5e                   	pop    %esi
 8f7:	5f                   	pop    %edi
 8f8:	5d                   	pop    %ebp
 8f9:	c3                   	ret
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 900:	39 cf                	cmp    %ecx,%edi
 902:	74 4c                	je     950 <malloc+0xe0>
        p->s.size -= nunits;
 904:	29 f9                	sub    %edi,%ecx
 906:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 909:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 90c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 90f:	89 15 d8 0d 00 00    	mov    %edx,0xdd8
}
 915:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 918:	83 c0 08             	add    $0x8,%eax
}
 91b:	5b                   	pop    %ebx
 91c:	5e                   	pop    %esi
 91d:	5f                   	pop    %edi
 91e:	5d                   	pop    %ebp
 91f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 920:	c7 05 d8 0d 00 00 dc 	movl   $0xddc,0xdd8
 927:	0d 00 00 
    base.s.size = 0;
 92a:	b8 dc 0d 00 00       	mov    $0xddc,%eax
    base.s.ptr = freep = prevp = &base;
 92f:	c7 05 dc 0d 00 00 dc 	movl   $0xddc,0xddc
 936:	0d 00 00 
    base.s.size = 0;
 939:	c7 05 e0 0d 00 00 00 	movl   $0x0,0xde0
 940:	00 00 00 
    if(p->s.size >= nunits){
 943:	e9 54 ff ff ff       	jmp    89c <malloc+0x2c>
 948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 94f:	00 
        prevp->s.ptr = p->s.ptr;
 950:	8b 08                	mov    (%eax),%ecx
 952:	89 0a                	mov    %ecx,(%edx)
 954:	eb b9                	jmp    90f <malloc+0x9f>
